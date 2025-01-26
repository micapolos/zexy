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
;   ix - Printer ptr
; Output:
;   hl - width / height
GetWidthHeight
        push    ix
        Printer_GetSurfacePtr    ix, h, l
        ld      ix, hl
        Surface_GetWidthHeight   ix, h, l
        pop ix
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

        ret

; Input:
;   ix - Printer ptr
;   a - byte
Put
        cp      $20
        jp      nc, .char

        ld      hl, .jumpTable
        rlca
        add     hl, a
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        ex      de, hl
        jp      (hl)

.char
        ld      l, (ix + Printer.addr)
        ld      h, (ix + Printer.addr + 1)

        sub     $20
        ld      (hl), a
        inc     hl

        ld      a, (ix + Printer.attr)
        ld      (hl), a

        jp      Advance

.jumpTable
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      NewLine
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
        dw      .ret
.ret
        ret

; Input
;   IX - Printer ptr
Advance
        call    GetWidthHeight

        ld      a, (ix + Printer.col)
        inc     a
        cp      h
        jp      nc, .nextLine
        ld      (ix + Printer.col), a
        jp      .done
.nextLine
        ld      (ix + Printer.col), 0
        ld      a, (ix + Printer.row)
        inc     a
        cp      l
        jp      nc, .scrollUp
        ld      (ix + Printer.row), a
        jp      .done
.scrollUp
        call    ScrollUp
.done
        jp    UpdateAddr

; Input:
;   ix - printer ptr
NewLine
        call    GetWidthHeight         ; hl
        ld      (ix + Printer.col), 0
        ld      a, (ix + Printer.row)
        inc     a
        cp      l
        jp      nc, .scrollUp
        ld      (ix + Printer.row), a
        jp      .done
.scrollUp
        call    ScrollUp
.done
        jp      UpdateAddr

; Input
;   IX - Printer ptr
ScrollUp
        push    ix

        Printer_GetSurfacePtr    ix, h, l
        ld      ix, hl

        Surface_GetWidthHeight   ix, b, c
        dec     c
        jp      z, .clearBottomLine

.moveUp
        ld      hl, $0001
        ld      de, $0000
        push    bc
        call    Surface.CopyRect
        pop     bc

.clearBottomLine
        ld      h, 0
        ld      l, c
        ld      c, 1
        ld      de, 0
        call    Surface.FillRect

        pop     ix
        ret

        ENDMODULE
        ENDIF
