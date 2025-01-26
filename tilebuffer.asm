        ifndef  Tilebuffer_asm
        define  Tilebuffer_asm

        include size.asm
        include coord.asm
        include blit.asm

        struct  Tilebuffer
addr    dw
size    Size
stride  db
        ends

        module  Tilebuffer

; Input
;   ix - Tilebuffer ptr
;   de - tile
Fill
        ld      l, (ix + Tilebuffer.addr)
        ld      h, (ix + Tilebuffer.addr + 1)

        ld      c, (ix + Tilebuffer.size.height)
        ld      b, (ix + Tilebuffer.size.width)

        ld      a, (ix + Tilebuffer.stride)

        jp      Blit.FillRect16

; Input
;   ix - Tilebuffer ptr
;   de - col / row
;   bc - width / height
;   hl - attr / char
FillRect
        push    hl
        call    CoordAddr
        pop     de

        ld      a, (ix + Tilebuffer.stride)
        add     (ix + Tilebuffer.size.width)
        sub     b

        jp      Blit.FillRect16

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

        ; dst->size = size
        ld      (iy + Tilebuffer.size.height), c
        ld      (iy + Tilebuffer.size.width), b

        ; dst->stride = src->stride + (src->width - width) * 2
        ld      a, (ix + Tilebuffer.stride)
        add     (ix + Tilebuffer.size.width)
        sub     b
        ld      (iy + Tilebuffer.stride), a

        ret

        endmodule

        endif
