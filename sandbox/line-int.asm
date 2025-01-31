        device  zxspectrumnext

        org     $8000

        include int-table.asm
        include reg.asm
        include port.asm

Main
        ld      a, Reg.PERIPH_1
        call    Reg.Read
        and     Reg.PERIPH_1.hz60
        jp      nz, .hz60
.hz50
        ld      hl, 312
        jp      .lineCountOk
.hz60
        ld      hl, 262
.lineCountOk
        ld      (LineHandler.lineCount), hl

        di
        nextreg Reg.INT_CTL, (IntTable.start & Reg.INT_CTL.intTableMask) | Reg.INT_CTL.im2
        nextreg Reg.INT_EN_0, Reg.INT_EN_0.expBusInt | Reg.INT_EN_0.line
        nextreg Reg.INT_EN_1, 0
        nextreg Reg.INT_EN_2, 0

        ld      a, IntTable.start >> 8
        ld      i, a

        im      2

        ld      hl, LineHandler
        ld      (IntTable.line), hl
        ei

.loop   jp      .loop

LineHandler
        ei

        push    af, hl

        ld      a, (color)
        out     (Port.ULA), a
        inc     a
        and     $07
        ld      (color), a

        ld      hl, (line)
        inc     hl

        xor     a       ; clear carry flag
.lineCount+*    ld      bc, 312
        sbc     hl, bc
        jp      nc, .lineOk
        add     hl, bc
.lineOk
        ld      (line), hl

        di
        ld      a, l
        nextreg Reg.LINE_INT_VAL, a
        ld      a, h
        or      Reg.LINE_INT_CTL.ulaIntOff | Reg.LINE_INT_CTL.lineIntOn
        nextreg Reg.LINE_INT_CTL, a
        ei

        pop     hl, af
        reti

color           db      0
line            dw      0

        savenex open "sandbox/line-int.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "sandbox/line-int.map"
