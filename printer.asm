        ifndef  Printer_asm
        define  Printer_asm

        include blit.asm
        include tilebuffer.asm
        include coord.asm

        struct  Printer
tilebuffer      Tilebuffer
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
        ld      (.hl), hl
        pop     hl
        ld      (.ret), hl
        ld      h, (ix + Printer.attr)
        push    hl
.hl+1   ld      hl, 0
.ret+1  jp      0

; Input:
;   ix - Printer ptr
PopAttr
        ld      (.hl), hl
        pop     hl
        ld      (.ret), hl
        pop     hl
        ld      (ix + Printer.attr), h
.hl+1   ld      hl, 0
.ret+1  jp      0

; Input
;   ix - Printer ptr
;   hl - null-terminated string
Print
        push    iy
        ld      iy, Put
        call    String.ForEach
        pop     iy
        ret

; Input
;   ix - Printer ptr
;   hl - null-terminated string
Println
        call    Print
        ld      a, $0a
        jp      Put

; Input
;   ix - Printer ptr
;   a - value
PrintHex4
        cp      10
        jp      c, .digit
        add     'A' - '9' + 1
.digit
        add     '0'
        jp      Put

; Input
;   ix - Printer ptr
;   a - value
PrintHex8
        push    af
        swapnib
        and     $0f
        call    PrintHex4
        pop     af

        and     $0f
        jp      PrintHex4

; Input
;   ix - Printer ptr
;   hl - value
PrintHex16
        push    hl
        ld      a, h
        call    PrintHex8
        pop     hl

        ld      a, l
        jp      PrintHex8

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
        ld      e, (ix + Printer.cursor.row)
        ld      d, (ix + Printer.cursor.col)

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
        ld      h, (ix + Printer.tilebuffer.size.width)
        ld      l, (ix + Printer.tilebuffer.size.height)

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
        ld      h, (ix + Printer.tilebuffer.size.width)
        ld      l, (ix + Printer.tilebuffer.size.height)

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
        ld      b, (ix + Printer.tilebuffer.size.width)
        ld      c, (ix + Printer.tilebuffer.size.height)
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

        endmodule
        endif
