        ifndef  Printer_asm
        define  Printer_asm

        include blit.asm
        include surface.asm
        include coord.asm

        struct  Printer
surface         Surface
cursor          Coord   0, 0
attr            db      %11100010       ; bright white on black
        ends

        module  Printer

; Input:
;   ix - Printer ptr
;   hl - col / row
MoveTo
        ld      (ix + Printer.cursor.row), l
        ld      (ix + Printer.cursor.col), h
        ret

; Input:
;   ix - Printer ptr
; Output:
;   hl - addr
@GetCursorAddr
        ld      l, (ix + Printer.cursor.row)
        ld      h, (ix + Printer.cursor.col)
        call    Surface.GetAddrAt       ; hl = addr

        ret

; Input:
;   ix - Printer ptr
PushCursor
        pop     hl
        ld      d, (ix + Printer.cursor.col)
        ld      e, (ix + Printer.cursor.row)
        push    de
        jp      (hl)

; Input:
;   ix - Printer ptr
PopCursor
        pop     de      ; ret addr
        pop     hl      ; col / row
        push    de      ; ret addr
        jp      MoveTo

; Input:
;   ix - Printer ptr
PushAttr
        pop     hl
        ld      d, (ix + Printer.attr)
        push    de
        jp      (hl)

; Input:
;   ix - Printer ptr
PopAttr
        pop     hl      ; ret addr
        pop     de      ; attr / value
        ld      (ix + Printer.attr), d
        jp      (hl)

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
        push    af
        call    GetCursorAddr
        pop     af

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
;   ix - Printer ptr
Advance
        ld      h, (ix + Printer.surface.width)
        ld      l, (ix + Printer.surface.height)

        ld      a, (ix + Printer.cursor.col)
        inc     a
        cp      h
        jp      nc, .nextLine
        ld      (ix + Printer.cursor.col), a
        jp      .done
.nextLine
        ld      (ix + Printer.cursor.col), 0
        ld      a, (ix + Printer.cursor.row)
        inc     a
        cp      l
        jp      nc, .scrollUp
        ld      (ix + Printer.cursor.row), a
        jp      .done
.scrollUp
        call    ScrollUp
.done
        ret

; Input:
;   ix - printer ptr
NewLine
        ld      h, (ix + Printer.surface.width)
        ld      l, (ix + Printer.surface.height)

        ld      (ix + Printer.cursor.col), 0
        ld      a, (ix + Printer.cursor.row)
        inc     a
        cp      l
        jp      nc, .scrollUp
        ld      (ix + Printer.cursor.row), a
        jp      .done
.scrollUp
        call    ScrollUp
.done
        ret

; Input
;   ix - Printer ptr
ScrollUp
        ld      b, (ix + Printer.surface.width)
        ld      c, (ix + Printer.surface.height)
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

        ret

        endmodule
        endif
