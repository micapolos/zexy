        device  zxspectrumnext

        org     $8000

        include reg.asm

Main
        nextreg $68, %10000000  ; disable ULA
        nextreg $4a, %11111111  ; global background color

.loop
        ld      a, $22
        push    bc
        call    Reg.Read
        pop     bc
        and     $80
        jp      z, .noint
        ld      b, $ff
.noint
        ld      a, b
        or      a
        jp      z, .zero
        dec     a
        ld      b, a
.zero
        ld      a, b
        nextreg $4a, a          ; global background color
        jp      .loop

        savenex open "built/show-int.nex", Main, $bfe0
        savenex auto
        savenex close

