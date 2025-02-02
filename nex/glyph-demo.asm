        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include glyph.asm
        include reg.asm

Main
        call    L2_320.Init

        ld      a, %00100101
        call    L2_320.Fill

        ld      a, %11011011
        call    L2_320.Fill

        ld      a, %00100001
        call    L2_320.Fill

        nextreg Reg.MMU_7, 18

        ld      de, glyph.a
        ld      h, $e1
        ld      a, 1
        ld      (Glyph.Draw.x), a
        ld      a, 4
        ld      (Glyph.Draw.h), a
        ld      a, 6
        ld      (Glyph.Draw.w), a
        ld      a, 89
        ld      (Glyph.Draw.v), a
        call    Glyph.Draw

        inc     h
        ld      de, glyph.b
        call    Glyph.Draw

        inc     h
        ld      de, glyph.c
        call    Glyph.Draw

        inc     h
        ld      de, glyph.d
        call    Glyph.Draw

.loop   jr      .loop

glyph
.a
        db      %01111100
        db      %10010000
        db      %10010000
        db      %01111100
.b
        db      %11111100
        db      %10100100
        db      %10100100
        db      %01011000
.c
        db      %01111000
        db      %10000100
        db      %10000100
        db      %10000100
.d
        db      %11111100
        db      %10000100
        db      %10000100
        db      %01111000

        savenex open "built/glyph-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/glyph-demo.map"
