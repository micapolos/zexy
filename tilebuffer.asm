        ifndef  Tilebuffer_asm
        define  Tilebuffer_asm

        include size.asm
        include coord.asm
        include frame.asm
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
        call    GetAddrAt
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
GetAddrAt
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
        call    GetAddrAt

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

; Input:
;   ix - Tilebuffer ptr
;   hl - src col / row
;   bc - width / height
;   de - dst col / row
CopyRect:
        ; compare src / dst col / row
        push    hl
        or      a       ; FC=0
        sbc     hl, de
        pop     hl

        ret     z
        jp      c, CopyRectDec

        ; fallthrough to CopyRectInc

; Input:
;   ix - Tilebuffer ptr
;   hl - src col / row
;   bc - width / height
;   de - dst col / row
CopyRectInc
        push    de              ; dst col / row
        call    GetAddrAt       ; hl = src addr

        ex      de, hl          ; hl = src addr
        pop     de              ; de = dst col / row
        push    hl              ; src addr
        ex      de, hl
        call    GetAddrAt       ; hl = dst addr
        pop     hl              ; hl = src addr

        ld      a, (ix + Tilebuffer.stride)
        add     (ix + Tilebuffer.size.width)
        sub     b

        rlca                    ; a = blit stride
        rlc     b               ; bc = blit width / height

        jp      nc, Blit.CopyRect8Inc

; Input:
;   ix - Tilebuffer ptr
;   hl - src col / row
;   bc - width / height
;   de - dst col / row
CopyRectDec
        ; FIXIT: It's not working
        push    de              ; dst col / row
        call    Frame.Swap
        call    GetAddrAt       ; hl = src addr

        ex      de, hl          ; hl = src addr
        pop     de              ; de = dst col / row
        push    hl              ; src addr
        ex      de, hl
        call    Frame.Swap
        call    GetAddrAt       ; hl = dst addr
        pop     hl              ; hl = src addr

        ld      a, (ix + Tilebuffer.stride)
        add     (ix + Tilebuffer.size.width)
        sub     b

        rlca                    ; a = blit stride
        rlc     b               ; bc = blit width / height

        jp      nc, Blit.CopyRect8Dec

; TODO: Replace with CopyRect
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
@MoveUp
        ld      hl, $0001       ; src col / row
        ld      de, $0000       ; dst col / row
        ld      b, (ix + Tilebuffer.size.width)
        ld      c, (ix + Tilebuffer.size.height)
        dec     c
        ret
        jp      CopyRectInc

; Input
;   ix - Tilebuffer ptr
;   hl - attr / value
@FillBottomRow
        ld      d, 0
        ld      e, (ix + Tilebuffer.size.height)
        dec     e

        ld      b, (ix + Tilebuffer.size.width)
        ld      c, 1

        jp      FillRect

        endmodule

        endif
