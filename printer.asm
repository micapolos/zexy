        IFNDEF  PRINTER_LIB
        DEFINE  PRINTER_LIB

        INCLUDE blit.asm
        INCLUDE surface.asm

        STRUCT  Printer
surfacePtr      DW                      ; TODO: Should we inline the surface?
row             DB      0
col             DB      0
attr            DB      %11100010       ; bright white on black
state           DB      0
addr            DW      0               ; address at row / col
        ENDS

        MODULE  Printer

; Input:
;   ix - printer ptr
Init
        jp      UpdateAddr

        MACRO   Printer_GetSurfacePtr idx, hi, lo
        ld      lo, (idx + surfacePtr)
        ld      hi, (idx + surfacePtr + 1)
        ENDM

; Input:
;   ix - printer ptr
; Output:
;   ix - surface ptr
GetSurfacePtr
        push    hl
        ld      l, (ix + Printer.surfacePtr)
        ld      h, (ix + Printer.surfacePtr + 1)
        ld      ix, hl
        pop     hl
        ret

; Input:
;   ix - Printer ptr
;   hl - col / row
MoveTo
        ld      (ix + Printer.row), l
        ld      (ix + Printer.col), h

; Input:
;   ix - Printer ptr
@UpdateAddr
        push    hl
        push    ix                      ; printer ptr

        ld      l, (ix + Printer.row)
        ld      h, (ix + Printer.col)
        push    hl                      ; col / row

        Printer_GetSurfacePtr    ix, h, l
        ld      ix, hl

        Surface_GetWidthHeight   ix, h, l
        pop     hl                      ; col / row
        call    Surface.GetAddrAt       ; hl = addr
        pop     ix                      ; printer ptr

        ld      (ix + Printer.addr), l
        ld      (ix + Printer.addr + 1), h

        pop     hl
        ret

; Put char at current col / row.
;
; Input:
;   IX - Printer ptr
;   A - char
PutChar
        push    hl
        push    af

        ld      l, (ix + Printer.addr)
        ld      h, (ix + Printer.addr + 1)

        sub     $20
        ld      (hl), a
        inc     hl

        ld      a, (ix + Printer.attr)
        ld      (hl), a

        pop     af
        pop     hl
        ret

; Input:
;   ix - Printer ptr
;   a - byte
; Output:
;   afbcdehl/iy - corrupt
Put
        call    PutChar
        jp      Advance

; Input
;   IX - Printer ptr
; Output
;   AF, BC, DE, HL - corrupt
;   C - on scroll up
Advance
        push    ix

        ; ix - surface ptr
        Printer_GetSurfacePtr    ix, h, l
        ld      ix, hl

        ; hl = width / height
        Surface_GetWidthHeight   ix, h, l

        ; ix - printer ptr
        pop     ix

        ld      a, (ix + Printer.col)
        inc     a
        cp      h
        jp      nc, .nextLine
        ld      (ix + Printer.col), a
        or      a       ; clear carry flag
        jp      .done
.nextLine
        ld      (ix + Printer.col), 0
        ld      a, (ix + Printer.row)
        inc     a
        cp      l
        jp      nc, .scrollUp
        ld      (ix + Printer.row), a
        or      a       ; clear carry flag
        jp      .done
.scrollUp
        push    ix
        call    ScrollUp
        pop     ix
        scf
.done
        push    af             ; preserve carry flag
        call    UpdateAddr
        pop     af
        ret

; Input
;   IX - Printer ptr
; Output
;   AF, BC, DE, HL, IX, IY - corrupt
ScrollUp
        Printer_GetSurfacePtr    ix, h, l
        ld      ix, hl

        Surface_GetWidthHeight   ix, b, c
        dec     c
        jp      z, .clearBottomLine

.moveUp
        ld      hl, $0001
        ld      de, $0000
        push    ix
        push    bc
        call    Surface.CopyRect
        pop     bc
        pop     ix

.clearBottomLine
        ld      h, 0
        ld      l, c
        ld      c, 1
        ld      de, 0
        jp      Surface.FillRect

        ENDMODULE
        ENDIF
