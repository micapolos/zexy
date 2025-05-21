        ifndef  SymbolTable_asm
        define  SymbolTable_asm

        include bank.asm
        include mmu.asm
        include string.asm

        module  SymbolTable

; Base address of symbol index table
indexBaseAddr     dw 0

; Number of free entries in the index
symbolsFree       dw 0

; Number of symbols already in the index
symbolCount       dw 0

; Next free address in the strings buffer
freeStringsAddr   dw 0

; Number of bytes free in the strings buffer
stringsBytesFree  dw 0

; ======================================================
; Input
;   HL - symbol index
; Output
;   HL - string
GetString
        ex      de, hl
        ld      hl, (indexBaseAddr)
        add     hl, de
        add     hl, de
        ldi     de, (hl)
        ex      de, hl
        ret

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
