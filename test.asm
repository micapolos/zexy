        device ZXSPECTRUMNEXT

        org $c000

        include mem.asm
        include assert.asm
        include tilebuffer-test.asm

main
        ld      hl, $4000
        ld      bc, $1800
        ld      e, $00
        call    Mem.Fill

        ld      hl, $5800
        ld      bc, $0300
        ld      e, $07
        call    Mem.Fill

        ld      hl, $3d00
        ld      de, $4000
        ld      bc, $300
        ldir

        call    Assert.Print
.loop   jp      .loop

        SAVENEX OPEN "test.nex", main, $FFFE
        SAVENEX AUTO
        SAVENEX CLOSE
