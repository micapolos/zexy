        ifndef  SymbolTable_asm
        define  SymbolTable_asm

        include bank.asm
        include mmu.asm
        include string.asm

        module  SymbolTable

BASE_ADDR         equ  $e000

bank              db  0
baseAddr          dw  $e000
capacity          dw  2048

; Number of symbols already in the index
@symbolCount       dw  0

; Next free address in the strings buffer
@freeStringsAddr   dw 0

; Number of bytes free in the strings buffer
@stringsBytesFree  dw 0

; ======================================================
; Output
;   FC - 0 = OK, 1 - error
Init
.allocStringBank0
        call    Bank.Alloc
        ret     c
        ld      (bank0), a

.allocStringBank1
        call    Bank.Alloc
        jr      c, .allocStringBank1Error
        ld      (bank1), a

.allocIndexBank
        call    Bank.Alloc
        jr      c, .allocIndedBankError
        ld      (indexBank), a

.initPointers
        ld      hl, $c000
        ld      (indexBaseAddr), hl

        ld      hl, 2048
        ld      (symbolsFree), hl

        ld      hl, 0
        ld      (symbolCount), hl

        ret

.allocIndedBankError
        ld      a, (stringBank1)
        call    Bank.Free

.allocStringBank1Error
        ld      a, (stringBank0)
        jp      Bank.Free

; ======================================================
@PageInIndexBank
        ld      a, (indexBank)
        nextreg Reg.MMU_6, a
        ret

; ======================================================
@PageInStringBank
        ld      a, (stringBank0)
        nextreg Reg.MMU_6, a
        ld      a, (stringBank1)
        nextreg Reg.MMU_7, a
        ret

; ======================================================
; Input
;   HL - symbol index
; Output
;   HL - string
;   MMU_6, MMU_7 - updated
GetString
        call    PageInIndexBank

        ex      de, hl
        ld      hl, (indexBaseAddr)
        add     hl, de
        add     hl, de
        ldi     de, (hl)
        ex      de, hl

        jp      PageInStringBank

; ======================================================
; Input
;   HL - symbol index
;   DE - string index
; Output
;   FZ - 0 = equal, 1 = not equal
EqualToString
        push    de
        ex      de, hl
        call    GetString
        pop     de
        jp      String.Equal

; ======================================================
; Input
;   HL - string
; Output
;   FC - 0 = OK, 1 = out of memory
;   HL - symbol index
Find
        push    hl

        ld      hl, (indexBaseAddr)
        ld      bc, (symbolCount)
.checkIndex
        ld      a, b
        or      c
        ret     z

; ======================================================
; Input
;   HL - string
; Output
;   FC - 0 = OK, 1 - out of memory
;   HL - symbol index
Insert
        push    hl   ; stack = string
        ld      hl, (symbolsFree)
        push    hl   ; stack = string, symbols free
        ld      a, h
        or      l
        jr      nz, .hasSymbolsFree

.outOfSymbols
        pop     hl, hl
        scf
        ret

.hasSymbolsFree
        ld      hl, (stringsBytesFree)
        push    hl  ; stack = string, symbols free, strings bytes free
        ld      a, h
        or      l
        jr      nz, .hasStringsBytesFree

.outOfStringsBytes
        pop     hl, hl, hl
        scf
        ret

.hasStringsBytesFree
        pop     bc   ; strings bytes free
        pop     de   ; symbols free
        pop     hl   ; string
        push    de   ; stack = symbols free
        call    String.CopyN

.updateStringsPointers
        ld      hl, bc
        ld      (stringsBytesFree), hl
        ex      de, hl
        ld      (freeStringsAddr), hl
        pop     hl   ; symbols free, stack = empty
        ret     c

.stringInserted
        inc     hl
        ld      (symbolsFree), hl

.incSymbolCount
        ld      hl, (symbolCount)
        inc     hl
        ld      (symbolCount), hl

.done
        or      a  ; clear carry flag
        ret

        endmodule
        endif
