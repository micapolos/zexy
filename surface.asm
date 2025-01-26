        ifndef  Surface_asm
        define  Surface_asm

        include blit.asm

        struct  Surface
addr    dw
width   db      ; max = 128
height  db
        ends

        module  Surface

        macro   Surface_GetWidthHeight idx, hi, lo
        ld      hi, (idx + Surface.width)
        ld      lo, (idx + Surface.height)
        endm

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
        push    ix

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
        ld      ixl, a
        ld      ixh, a

        call    Blit.CopyRect8Inc
        pop     ix
        ret

; Input:
;   ix - dst Surface*
;   iy - src Surface*
;   hl - dst col, row
;   de - src col, row
;   bc - width, height
XCopyRect:
        push    ix

        ; bc = blit width / height
        rlc     b

        ; hl = dst addr
        push    bc
        push    de
        call    GetAddrAt
        pop     de
        pop     bc

        ; ixl = dst stride
        ld      a, (ix + Surface.width)
        rlca
        sub     b
        ld      ixl, a
        push    ix

        ; de = src address
        ld      ix, iy
        ex      de, hl
        push    bc
        push    de
        call    GetAddrAt
        pop     de
        pop     bc

        ; ixh = src stride
        ld      a, (ix + Surface.width)
        rlca
        sub     b
        pop     ix
        ld      ixh, a

        call    Blit.CopyRect8Inc

        pop     ix
        ret

        endmodule

        endif
