        IFNDEF  PRINTER_LIB
        DEFINE  PRINTER_LIB

        INCLUDE blit.asm
        INCLUDE surface.asm

        MODULE  PRINTER

        STRUCT  Printer
surfacePtr      DW
attr            DB      %00000001
        ENDS

; Input:
;   ix - Printer*
;   hl - col / row
;   a - char
Put
        push    af
        push    de

        sub     $20
        jp      nc, .char
.control
        xor     a       ; TODO: select fallback char
.char
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
        ld      d, (ix + Printer.attr)
        ld      e, a
        call    Blit.Put16

        pop     de
        pop     af
        ret

        ENDMODULE
        ENDIF
