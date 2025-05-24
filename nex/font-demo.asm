        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include font.asm

        lua     allpass
        require("sys-bold-font")
        require("font-gen")
        font_gen("sysFont", sys_bold_font)
        endlua

Main
        call    Terminal.Init

        ld      a, 'W'
        call    WritelnCharWidth

        ld      a, 'I'
        call    WritelnCharWidth

        ld      a, 'a'
        call    WritelnCharWidth
        call    Writer.NewLine

        ld      hl, string.empty
        call    WritelnStringWidth

        ld      hl, string.i
        call    WritelnStringWidth

        ld      hl, string.a
        call    WritelnStringWidth

        ld      hl, string.hello
        call    WritelnStringWidth

        ld      hl, string.long
        call    WritelnStringWidth

.loop   jr      .loop

; =========================================================
; Input
;   a - char
WritelnCharWidth
        push    af
        _write "Width of '"
        pop     af

        push    af
        call    Writer.Char
        _write "' = "
        ld      hl, sysFont.index
        pop     af

        call    Font.GetCharWidth
        call    Writer.Hex8h
        jp      Writer.NewLine

; =========================================================
; Input
;   hl - string
WritelnStringWidth
        push    hl
        _write "Width of \""
        pop     hl

        push    hl
        call    Writer.String
        _write "\" = "
        pop     de              ; de = string ptr

        ld      hl, sysFont.index
        or      a       ; clear carry

        push    de      ; push string ptr
        call    Font.GetStringWidth
        push    af      ; push fc

        ld      hl, bc  ; hl - length
        call    Writer.Hex16h
        call    Writer.NewLine

        _write "- with carry = "

        pop     af      ; pop fc
        pop     de      ; pop string ptr

        ld      hl, sysFont.index
        call    Font.GetStringWidth
        ld      hl, bc
        call    Writer.Hex16h
        call    Writer.NewLine
        jp      Writer.NewLine

string
.empty          db      0
.i              dz      "i"
.a              dz      "a"
.hello          dz      "Hello"
.long           dz      "This is a rather longer string, which needs to be measured."

        savenex open "built/font-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/font-demo.map"
