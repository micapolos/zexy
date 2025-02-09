        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include blit.asm
        include reg.asm

Main
        call    L2_320.Init

        ld      a, %00100001
        call    L2_320.Fill

        nextreg Reg.MMU_7, 18
        ld      hl, text
        ld      de, $e100
        ld      bc, text.width
        ld      a, text.color
        call    Blit.Copy8BitLines

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
        db      0
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
        db      0
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
        db      0
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
        db      0
.width  equ     $ - text
.color  equ     %11001010

        savenex open "built/glyph-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/glyph-demo.map"
