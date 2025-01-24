        IFNDEF  SURFACE_LIB
        DEFINE  SURFACE_LIB

        INCLUDE blit.asm

        STRUCT  Surface
size    DW
addr    DW
        ENDS

        MODULE  Surface

; Input:
;   ix - Surface*
;   hl - col, row
;   bc - width, height
;   de - value
Rect:
        push   de



        pop    de
        ret

; Input:
;   IX - Surface*
Clear:
        ld  bc, 0

; Input:
;   IX - Surface*
;   BC - tile
Fill:
        push af
        push de
        push hl

        ld  e, (ix+0)
        ld  d, (ix+1)
        ld  l, (ix+2)
        ld  h, (ix+3)
        mul d, e
.loop:
        ld  (hl), c
        inc hl
        ld  (hl), b
        inc hl

        dec de
        ld  a, d
        or  e
        jp  nz, .loop

        pop hl
        pop de
        pop af
        ret

        ENDMODULE

        ENDIF
