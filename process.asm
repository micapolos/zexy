        ifndef Process_asm
        define Process_asm

        struct Process
; bit 0 - active
flags   db      0
regs
sp      dw
af      dw
bc      dw
de      dw
hl      dw
af2     dw
bc2     dw
de2     dw
hl2     dw
ix      dw
iy      dw
regEnd
        ends

        module Process

bits    equ     5
size    equ     1 << bits
        assert  (Process <= size)

regCount        equ     11

; Input
;   ix - Process ptr
;   de - start addr
;   hl - stack addr
;   a - parameter passed in A
Init
        ld      (ix + Process.af + 1), a

        ; Push Exit address on process stack
        push    de
        ld      de, Exit
        dec     hl
        ld      (hl), d
        dec     hl
        ld      (hl), e
        pop     de

        ; Push start address on process stack
        dec     hl
        ld      (hl), d
        dec     hl
        ld      (hl), e

        ; Push start address on process stack
        dec     hl
        ld      (hl), d
        dec     hl
        ld      (hl), e

        ; Init Process.sp
        ld      (ix + Process.sp), l
        ld      (ix + Process.sp + 1), h

        ret

        endmodule

        endif
