        ifndef  Tilebuffer_asm
        define  Tilebuffer_asm

        include size.asm
        include coord.asm
        include frame.asm
        include blit.asm
        include struct.asm

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
        ld      hl, (ix + Tilebuffer.addr)
        ld      bc, (ix + Tilebuffer.size)
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
        ld      hl, (ix + Tilebuffer.addr)

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

; =========================================================
; Input
;   ix - Tilebuffer ptr
;   de - Coord (col / row)
;   bc - Size (width / height)
Cut
        ; hl = addr
        ld      hl, (ix + Tilebuffer.addr)

        ; hl += col * 2
        ld      a, d
        rlca
        add     hl, a

        ; hl += (width + stride) * 2 * row
        ld      a, (ix + Tilebuffer.size.width)
        add     (ix + Tilebuffer.stride)
        rlca
        ld      d, a
        mul     d, e
        add     hl, de

        ; Store new addr
        ld      (ix + Tilebuffer.addr), hl

        ; stride += width - new width
        ld      a, (ix + Tilebuffer.stride)
        sub     b
        add     (ix + Tilebuffer.size.width)

        ; Store new stride
        ld      (ix + Tilebuffer.stride), a

        ; Store new size
        ld      (ix + Tilebuffer.size), bc

        ret

; Input
;   ix - Tilebuffer ptr
Push    StructPush_tail Tilebuffer

; Input
;   ix - Tilebuffer ptr
Pop     StructPop_tail Tilebuffer

        endmodule

        endif
