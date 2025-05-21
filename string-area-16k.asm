        ifndef  StringArea16k_asm
        define  StringArea16k_asm

        include bank.asm
        include mmu.asm
        include string.asm

        module  StringArea16k

START           equ $c000
SIZE            equ $4000

bank0           db  0
bank1           db  0

topAddr         dw  START
bytesFree       dw  SIZE

; ======================================================
; Output
;   mmu6, mmu7 - paged in
PageIn
        ld      a, (bank0)
        nextreg Reg.MMU_6, a
        ld      a, (bank1)
        nextreg Reg.MMU_7, a
        ret

; ======================================================
; Input
;   mmu6, mmu7 - paged in
;   HL - string
; Output
;   FC - 0 = OK, 1 - out of memory
;   hl - string address
Insert
        push    hl                ; stack = [string]

        ld      hl, (topAddr)
        push    hl                ; stack = [string, start addr]

        ld      hl, (bytesFree)   ; hl = bytes free
        ld      a, h
        or      l
        jr      nz, .hasBytesFree

.outOfMemory
        pop     hl                ; hl = start addr
        pop     de                ; de = string
        scf
        ret

.hasBytesFree
        ld      bc, hl            ; bc = bytes free
        pop     de                ; de = start addr
        pop     hl                ; hl = string
        push    de                ; push start addr
        call    String.CopyN

        ld      hl, bc
        ld      (bytesFree), hl
        ex      de, hl
        ld      (topAddr), hl
        pop     hl                ; hl = start addr
        ret                       ; carry from CopyN

        endmodule
        endif
