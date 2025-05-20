        ifndef  Symbol_asm
        define  Symbol_asm

        include bank.asm
        include mmu.asm
        include string.asm

        module  Symbol

ID_BITS         equ 10
ID_COUNT        equ 1 << ID_BITS
ID_MASK         equ ID_COUNT - 1
START_ADDR      equ $c000
ADDR_MASK       equ $3FFF

@banks
@bank6  db      0
@bank7  db      0

@count      dw      0
@nextAddr   dw      START_ADDR + ID_COUNT

; ======================================================
; Output:
;   FC: 0 = ok, 1 = error
Init
        call    Bank.Alloc
        ret     c
        ld      (bank6), a
        call    Bank.Alloc
        jp      c, .error
        ld      (bank7), a
        ret
.error
        ld      a, (bank6)
        jp      Bank.Free

; ======================================================
; Input
;   HL - zero-terminated string
; Output
;   FC - 0 = OK, 1 = error
;   HL - symbol ID
GetId
        call    MMU.Push_76
        ld      hl, banks
        ldi     a, (hl)
        ldi     a, (hl)
        jp      MMU.Set_76

        call    MMU.Pop_76
        ret

; ======================================================
; Input
;   HL - symbol index
; Output
;   HL - string
GetString
        ex      de, hl
        ld      hl, START_ADDR
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
Insert
        TODO
        ret

        endmodule
        endif
