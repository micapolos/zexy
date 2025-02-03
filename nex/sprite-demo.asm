        device  zxspectrumnext

        org     $8000

        include sprite.asm
        include reg.asm
        include palette.asm

Main
        nextreg Reg.SPR_LAY_SYS, Reg.SPR_LAY_SYS.sprOn

        ; Load garbage sprite patterns from ROM.
        ld      hl, (garbagePtr)
        ld      bc, $4000
        ld      a, 0            ; start from pattern 0
        call    Sprite.LoadPatterns

        ; Load garbage sprite attributes from ROM.
        ld      hl, (garbagePtr)
        ld      bc, 128 * 5
        ld      a, 0            ; start from sprite 0
        call    Sprite.LoadAttrs

.loop
        ; Load garbage palette from ROM
        ld      hl, (garbagePtr)
        ld      b, 0            ; 256 colors
        nextreg Reg.PAL_IDX, 0  ; start from color 0
        call    Palette.Load9Bit

        ld      hl, garbagePtr
        inc     (hl)

        jr      .loop

garbagePtr
        dw      $0000

        savenex open "built/sprite-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/sprite-demo.map"
