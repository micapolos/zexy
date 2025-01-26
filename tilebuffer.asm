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
;   de - attr / value
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
;   hl - attr / value
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
;   de - col / row
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

; Input
;   ix - src Tilebuffer ptr
;   iy - dst Tilebuffer ptr
;   de - col / row
;   bc - width / height
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

; Input
;   ix - Tilebuffer ptr
;   hl - attr / value
ScrollUp
        push    hl
        call    MoveUp
        pop     hl

        jp      FillBottomRow

; Input
;   ix - Tilebuffer ptr
MoveUp
        push    ix

        ld      e, (ix + Tilebuffer.addr)
        ld      d, (ix + Tilebuffer.addr + 1)

        ld      c, (ix + Tilebuffer.size.height)
        ld      b, (ix + Tilebuffer.size.width)
        rlc     b

        ld      hl, de
        ld      a, (ix + Tilebuffer.size.width)
        add     (ix + Tilebuffer.stride)
        rlca
        add     hl, a

        ld      a, (ix + Tilebuffer.stride)
        rlca
        ld      ixh, a
        ld      ixl, a
        call    Blit.CopyRect8Inc

        pop     ix
        ret

; Input
;   ix - Tilebuffer ptr
;   hl - attr / value
FillBottomRow
        ld      d, 0
        ld      e, (ix + Tilebuffer.size.height)
        dec     e

        ld      b, (ix + Tilebuffer.size.width)
        ld      c, 1

        jp      FillRect

        endmodule

        endif
