        ifndef  Tilebuffer_asm
        define  Tilebuffer_asm

        include size.asm
        include coord.asm

        struct  Tilebuffer
addr    dw
size    Size
stride  db
        ends

; Input:
;   ix - Tilebuffer ptr
;   de - Coord
; Output:
;   hl - addr
;   bc - preserved
CoordAddr
        ; hl = base addr
        ld      l, (ix + Tilebuffer.addr)
        ld      h, (ix + Tilebuffer.addr + 1)

        ; hl += col * 2
        ld      a, d
        rlca
        add     hl, a

        ; hl += row * (width + stride) * 2
        ld      a, (ix + Tilebuffer.size.width)
        add     (ix + Tilebuffer.stride)
        rlca
        ld      d, a
        mul     d, e
        add     hl, de
        ret

        module  Tilebuffer

; Input:
;   ix - src Tilebuffer ptr
;   iy - dst Tilebuffer ptr
;   debc - Frame (col, row, width, height)
LoadSubFrame
        ; hl = src->addr
        call    CoordAddr

        ; dst->addr = hl
        ld      (iy + Tilebuffer.addr), l
        ld      (iy + Tilebuffer.addr + 1), h

        ; src->size.height = dst->size.height
        ld      a, (ix + Tilebuffer.size.height)
        ld      (iy + Tilebuffer.size.height), a

        ; src->size.width = dst->size.width
        ld      a, (ix + Tilebuffer.size.width)
        ld      (iy + Tilebuffer.size.width), a

        ; src->stride += (src->width - width) * 2
        ld      a, (ix + Tilebuffer.stride)
        add     (ix + Tilebuffer.size.width)
        sub     b
        rlca
        ld      (iy + Tilebuffer.stride), a

        ret

        endmodule

        endif
