        device  zxspectrumnext

        org     $8000

        include sprite.asm
        include reg.asm

Main
        ; Load garbage sprite patterns from ROM.
        ld      hl, $0000
        ld      bc, $4000
        ld      a, 0
        call    Sprite.LoadPatterns

        ; Load garbage sprite attributes from ROM.
        ld      hl, $0000
        ld      bc, 128 * 5
        ld      a, 0
        call    Sprite.LoadAttrs

        nextreg Reg.SPR_LAY_SYS, Reg.SPR_LAY_SYS.sprOn

.loop   jr      .loop

        savenex open "built/sprite-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/sprite-demo.map"
