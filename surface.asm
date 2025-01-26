        IFNDEF  SURFACE_LIB
        DEFINE  SURFACE_LIB

        INCLUDE blit.asm

        STRUCT  Surface
addr    DW
width   DB      ; max = 128
height  DB
        ENDS

        MODULE  Surface

        MACRO   Surface_GetWidthHeight idx, hi, lo
        ld      hi, (idx + Surface.width)
        ld      lo, (idx + Surface.height)
        ENDM

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
; Output:
;   afbcdehl/ixiy - corrupt
FillRect:
        ; hl = addr
        call    GetAddrAt

        ; a = stride
        ld      a, (ix + Surface.width)
        sub     b

        jp    Blit.FillRect16

; Input:
;   ix - Surface*
;   hl - src col, row
;   de - dst col, row
;   bc - width, height
; Output:
;   AFBCDEHL/IXIY - corrupt
CopyRect:
        ; hl = src addr
        ; de = dst addr
        call    GetAddrAt
        ex      de, hl
        call    GetAddrAt
        ex      de, hl

        ; bc = blit width / height
        rlc     b

        ; ixl,ixh = stride
        ld      a, (ix + Surface.width)
        rlca
        sub     b
        ld      ixl, a
        ld      ixh, a

        jp      Blit.CopyRect8Inc

; Input:
;   ix - dst Surface*
;   iy - src Surface*
;   hl - dst col, row
;   de - src col, row
;   bc - width, height
; Output:
;   agbcdehl/ixiy - corrupt
XCopyRect:
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

        jp      Blit.CopyRect8Inc

        ENDMODULE

        ENDIF   SURFACE_LIB
