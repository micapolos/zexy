        ifndef  Writer_asm
        define  Writer_asm

        include string.asm
        include call.asm

        module  Writer

Char
.proc+* jp      0

        macro   WriteChar ch
        ld      a, ch
        call    Writer.Char
        endm

; =========================================================
NewLine
.char+* ld      a, $0a
        jp      Char

        macro   _newline
        call    Writer.NewLine
        endm

; =========================================================
; Input
;   hl - null-terminated string
String
        push    iy
        ld      iy, Char
        call    String.ForEach
        pop     iy
        ret

        macro   WriteStringAt ptr
        ld      hl, ptr
        call    Writer.String
        endm

; =========================================================
; Input
;   hl - null-terminated string
StringLine
        call    String
        jp      NewLine

        macro   WritelnStringAt ptr
        ld      hl, ptr
        call    Writer.StringLine
        endm

StringDZ
; =========================================================
; Input
;   (sp) - null-terminated string
        pop     hl
        push    iy
        ld      iy, Char
        call    String.ForEach
        pop     iy
        jp      (hl)
        ret

        macro   WriteString string
        call    Writer.StringDZ
        dz      string
        endm

        macro   WritelnString string
        call    Writer.StringDZ
        dz      string
        call    Writer.NewLine
        endm

; =========================================================
; Input
;   a - nibble in 0..3 bits
Nibble
        cp      $0a
        jp      c, .digit
        add     'A' - 10
        jp      .print
.digit
        add     '0'
.print
        jp      Char

; =========================================================
; Input
;   a - value
Hex8
        push    af
        swapnib
        and     $0f
        call    Nibble
        pop     af

        and     $0f
        jp      Nibble

; =========================================================
; Input
;   a - value
Hex8h
        call    Hex8
        jp      HexSuffix

; =========================================================
; Input
;   hl - value
Hex16
        push    hl
        ld      a, h
        call    Hex8
        pop     hl

        ld      a, l
        jp      Hex8

; =========================================================
; Input
;   hl - value
Hex16h
        call    Hex16
        jp      HexSuffix

; =========================================================
; Input
;   bcde - value
Hex32
        push    de
        ld      hl, bc
        call    Hex16
        pop     de
        ld      hl, de
        jp      Hex16

; =========================================================
; Input
;   bcde - value
Hex32h
        call    Hex32
        jp      HexSuffix

; =========================================================
; Input
@HexSuffix
        ld      a, 'h'
        jp      Char

; =========================================================
; Input
;   a - value
Bin8
        ld      b, 8
.loop
        ld      c, '0'
        rlca
        jp      nc, .print
        inc     c
.print
        push    af
        push    bc
        ld      a, c
        call    Char
        pop     bc
        pop     af
        djnz    .loop

        ret

        endmodule

        endif
