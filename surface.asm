        IFNDEF  SURFACE_LIB
        DEFINE  SURFACE_LIB

        INCLUDE blit.asm

        STRUCT  Surface
addr    DW
width   DB      ; max = 128
height  DB
        ENDS

        MODULE  Surface

; Input:
;   IX - Surface ptr
; Output:
;   HL - width / height
GetWidthHeight
        ld      h, (ix + Surface.width)
        ld      l, (ix + Surface.height)
        ret

; Input:
;   ix - Surface*
;   hl - col / row
; Output:
;   hl - addr
GetAddrAt:
        push    de
        push    bc

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

        pop     bc
        pop     de
        ret

; Input:
;   ix - Surface*
;   hl - col, row
;   bc - width, height
;   de - value
FillRect:
        push    hl
        push    af

        ; hl = addr
        call    GetAddrAt

        ; a = stride
        ld      a, (ix + Surface.width)
        sub     b

        call    Blit.FillRect16

        pop     af
        pop     hl
        ret

; Input:
;   ix - dst Surface*
;   hl - dst col, row
;   iy - src Surface*
;   de - src col, row
;   bc - width, height
CopyRect:
        push    ix
        push    iy
        push    hl
        push    de
        push    bc
        push    af

        ; bc = blit width / height
        rlc     b

        ; hl = dst addr
        call    GetAddrAt

        ; ixl = dst stride
        ld      a, (ix + Surface.width)
        rlca
        sub     b
        ld      ixl, a
        push    ix

        ; de = src address
        ld      ix, iy
        ex      de, hl
        call    GetAddrAt

        ; ixh = src stride
        ld      a, (ix + Surface.width)
        rlca
        sub     b
        pop     ix
        ld      ixh, a

        call    Blit.CopyRect8Inc

        pop     af
        pop     bc
        pop     de
        pop     hl
        pop     iy
        pop     ix
        ret

        ENDMODULE

        ENDIF   SURFACE_LIB
