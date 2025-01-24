        IFNDEF  SURFACE_LIB
        DEFINE  SURFACE_LIB

        INCLUDE blit.asm

        STRUCT  Surface
height  DB
width   DB
addr    DW
        ENDS

        MODULE  Surface

; Input:
;   ix - Surface*
;   hl - col / row
; Output:
;   hl - addr
GetAddr:
        push    de
        push    bc

        ld      bc, hl

        ld      l, (ix + Surface.addr)
        ld      h, (ix + Surface.addr + 1)

        ; hl += col offset
        ld      d, 0
        ld      e, b
        sla     e
        add     hl, de

        ; hl += row offset
        ld      e, (ix + Surface.width)
        sla     e
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
        call    GetAddr

        ; a = stride
        ld      a, (ix + Surface.width)
        sub     b

        call    Blit.Fill16

        pop     af
        pop     hl
        ret

; Input:
;   ix - src Surface*
;   iy - dst Surface*
;   hl - src col, row
;   de - dst col, row
;   bc - width, height
CopyRect:
        push    ix
        push    iy
        push    hl
        push    de
        push    bc
        push    af

        ; hl = src addr
        call    GetAddr

        ; ixh = src stride
        ld      a, (ix + Surface.width)
        sub     b
        rla
        ld      ixh, a

        ; de = dst address
        ld      ix, iy
        ex      de, hl
        call    GetAddr
        ex      de, hl

        ; ixl = dst stride
        ld      a, (ix + Surface.width)
        sub     b
        rla
        ld      ixl, a

        call    Blit.Copy8x8

        push    af
        pop     bc
        pop     de
        pop     hl
        pop     iy
        pop     ix

        ret

        ENDMODULE

        ENDIF
