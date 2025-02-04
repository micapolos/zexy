        ifndef  Printer_asm
        define  Printer_asm

        include blit.asm
        include tilebuffer.asm
        include coord.asm
        include string.asm
        include struct.asm

        struct  Printer
tilebuffer      Tilebuffer
cursor          Coord   0, 0
attr            db      %11100010       ; bright white on black
        ends

        assert  Printer.tilebuffer = 0

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
PushCursor
        pop     hl
        ld      de, (ix + Printer.cursor)
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
        ld      h, (ix + Printer.attr)  ; h = attr
        ex      hl, (sp)                ; hl = ret attr, (SP) = attr
        jp      (hl)

; Input:
;   ix - Printer ptr
PopAttr
        pop     hl              ; ret addr
        ex      hl, (sp)        ; h = attr, (SP) = ret addr
        ld      (ix + Printer.attr), h
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
        ld      de, (ix + Printer.cursor)
        ld      c, a
        ld      b, (ix + Printer.attr)
        call    Tilebuffer.Set

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
        dw      Delete
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
        ld      hl, (ix + Printer.tilebuffer.size)
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
        ld      hl, (ix + Printer.tilebuffer.size)

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
Delete
        ld      a, (ix + Printer.cursor.col)
        or      a
        jp      nz, .colOk
        add     (ix + Printer.tilebuffer.size.width)
        ld      b, a
        ld      a, (ix + Printer.cursor.row)
        or      a
        ret     z
        dec     a
        ld      (ix + Printer.cursor.row), a
        ld      a, b
.colOk
        dec     a
        ld      (ix + Printer.cursor.col), a
        ld      d, a
        ld      e, (ix + Printer.cursor.row)
        ld      bc, $0000
        jp      Tilebuffer.Set

; Input
;   ix - Printer ptr
ScrollUp
        ld      bc, (ix + Printer.tilebuffer.size)
        dec     c
        jp      z, .clearBottomLine

.moveUp
        ld      hl, $0001
        ld      de, $0000
        push    bc
        call    Tilebuffer.CopyRectInc
        pop     bc

.clearBottomLine
        ld      d, $00
        ld      e, c
        ld      c, $01
        ld      hl, $0000
        call    Tilebuffer.FillRect

        ret

; Input
;   ix - Printer ptr
;   de - Coord (col / row)
;   bc - Size (width / height)
Cut     equ     Tilebuffer.Cut

; Input
;   ix - Printer ptr
Push    StructPush_tail Printer

; Input
;   ix - Printer ptr
Pop     StructPop_tail Printer

        endmodule
        endif
