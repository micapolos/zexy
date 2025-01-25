        IFNDEF  PRINTER_LIB
        DEFINE  PRINTER_LIB

        INCLUDE blit.asm
        INCLUDE surface.asm

        STRUCT  Printer
surfacePtr      DW
row             DB      0
col             DB      0
attr            DB      %11100010       ; bright white on black
addr            DW      0               ; address at row / col
        ENDS

        MODULE  Printer

; Input:
;   ix - Printer ptr
;   hl - col / row
MoveTo
        push    hl
        push    ix      ; printer ptr
        push    hl      ; col / row

        ; hl = surface ptr
        ld      l, (ix + Printer.surfacePtr)
        ld      h, (ix + Printer.surfacePtr + 1)

        ; hl = surface addr
        ld      ix, hl  ; surface ptr
        pop     hl      ; col / row
        call    Surface.GetAddr

        pop     ix      ; printer ptr
        ld      (ix + Printer.addr), l
        ld      (ix + Printer.addr + 1), h

        pop     hl
        ret

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
