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

        ld      de, text
        ld      h, $e1
        ld      a, $01
        ld      (Glyph.Draw.l), a
        ld      c, text.width
        ld      a, %11001010
        ld      (Glyph.Draw.val), a
        call    Glyph.Draw

.loop   jr      .loop

text
        db      %00111110
        db      %01001000
        db      %01001000
        db      %00111110
        db      0
        db      %01111110
        db      %01010010
        db      %01010010
        db      %00101100
        db      0
        db      %00111100
        db      %01000010
        db      %01000010
        db      %01000010
        db      0
        db      %01111110
        db      %01000010
        db      %01000010
        db      %00111100
.width  equ     $ - text

        savenex open "built/glyph-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/glyph-demo.map"
