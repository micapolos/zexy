        ifndef  Tilebuffer_asm
        define  Tilebuffer_asm

        include size.asm
        include coord.asm
        include frame.asm
        include blit.asm
        include stack.asm

        struct  Tilebuffer
addr    dw
size    Size
stride  db      0
        ends

        module  Tilebuffer

struct
.size   equ     Tilebuffer
.size16 equ     (Tilebuffer + 1) >> 1

; Input
;   ix - Tilebuffer ptr
;   de - col / row
;   bc - attr / value
Set
        call    GetAddr
        ld      (hl), c
        inc     hl
        ld      (hl), b
        ret

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
        call    GetAddr
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
GetAddr
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
        call    GetAddr

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
        ; compare rows
        ld      a, l
        cp      e
        jp      c, CopyRectDec
        jp      nz, CopyRectInc

        ; compare cols
        ld      a, h
        cp      d
        jp      c, CopyRectDec
        jp      nz, CopyRectInc

        ret

; Input:
;   ix - Tilebuffer ptr
;   hl - src col / row
;   bc - width / height
;   de - dst col / row
CopyRectInc
        push    hl              ; src col / row
        call    GetAddr       ; hl = dst addr
        ex      de, hl          ; de = dst addr
        pop     hl              ; hl = src col / row
        push    de              ; dst addr
        ex      de, hl          ; de = src col / row
        call    GetAddr       ; hl = src addr
        pop     de              ; de = dst addr

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
        push    hl              ; src col / row
        call    Frame.Swap
        call    GetAddr       ; hl = dst addr
        ex      de, hl          ; de = dst addr
        pop     hl              ; hl = src col / row
        push    de              ; dst addr
        ex      de, hl          ; de = src col / row
        call    Frame.Swap
        call    GetAddr       ; hl = src addr
        pop     de              ; de = dst addr

        inc     hl
        inc     de

        ld      a, (ix + Tilebuffer.stride)
        add     (ix + Tilebuffer.size.width)
        sub     b

        rlca                    ; a = blit stride
        rlc     b               ; bc = blit width / height

        jp      nc, Blit.CopyRect8Dec

; Input
;   ix - Tilebuffer ptr
;   bc - width / height
;   de - col / row
Clip
        ; hl = new addr
        ld      hl, (ix + Tilebuffer.addr)
        ld      a, e
        rlca
        add     hl, a
        ld      a, (ix + Tilebuffer.size.width)
        add     (ix + Tilebuffer.stride)
        rlca
        ld      d, a
        mul     d, e
        add     hl, de

        push    de
        ld      d, (ix + Tilebuffer.size.width)
        mul     d, e

        ld      hl, (ix + Tilebuffer.size)
        ret

; Input
;   ix - Tilebuffer ptr
Push
        ld      hl, ix
        ld      b, struct.size16
        jp      Stack.Pop16

; Input
;   ix - Tilebuffer ptr
Pop
        ld      hl, ix
        ld      b, struct.size16
        jp      Stack.Pop16

        endmodule

        endif
