        IFNDEF  PRINTER_LIB
        DEFINE  PRINTER_LIB

        INCLUDE blit.asm
        INCLUDE surface.asm

        STRUCT  Printer
surfacePtr      DW                      ; TODO: Should we inline the surface?
row             DB      0
col             DB      0
attr            DB      %11100010       ; bright white on black
addr            DW      0               ; address at row / col
        ENDS

        MODULE  Printer

; Input:
;   ix - printer ptr
Init
        jp    UpdateAddr

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

        call    GetSurfacePtr           ; ix = surface ptr
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

        ENDMODULE
        ENDIF
