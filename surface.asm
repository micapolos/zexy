        ifndef  Surface_asm
        define  Surface_asm

        include blit.asm

        struct  Surface
addr    dw
width   db      ; max = 128
height  db
        ends

        module  Surface

; Input:
;   ix - Surface*
;   hl - col / row
; Output:
;   hl - addr
GetAddrAt:
        ; bc = col / row
        ld      bc, hl

        ; hl = surface addr
        ld      l, (ix + Surface.addr)
        ld      h, (ix + Surface.addr + 1)

        ; hl += col offset
        ld      d, 0
        ld      e, b
        rlc     e
        add     hl, de

        ; hl += row offset
        ld      e, (ix + Surface.width)
        rlc     e
        ld      d, c
        mul     d, e
        add     hl, de

        ret

; Input:
;   ix - Surface*
;   hl - col, row
;   bc - width, height
;   de - value
FillRect:
        ; hl = addr
        push    bc
        push    de
        call    GetAddrAt
        pop     de
        pop     bc

        ; a = stride
        ld      a, (ix + Surface.width)
        sub     b

        jp    Blit.FillRect16

; Input:
;   ix - Surface*
;   hl - src col, row
;   de - dst col, row
;   bc - width, height
CopyRect:
        ; hl = src addr
        ; de = dst addr
        push    bc

        push    de
        call    GetAddrAt
        pop     de

        ex      de, hl

        push    de
        call    GetAddrAt
        pop     de

        ex      de, hl

        pop     bc

        ; bc = blit width / height
        rlc     b

        ; ixl,ixh = stride
        ld      a, (ix + Surface.width)
        rlca
        sub     b

        jp      Blit.CopyRect8Inc

        endmodule

        endif
