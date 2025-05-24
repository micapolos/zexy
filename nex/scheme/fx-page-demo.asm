        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include writer.asm
        include ld.asm
        include dump.asm
        include control.asm
        include scheme/fx-page.asm

SEGMENT_BIT_SIZE  equ     3
SEGMENT_SIZE      equ     1 << (SEGMENT_BIT_SIZE + 1)
SEGMENT_ADDR_MASK equ     SEGMENT_SIZE - 1

        macro   PressSpaceTo msg
        WriteString "<- Press SPACE to "
        WriteString msg
        WritelnString " ->"
        call    Debug.WaitSpace
        call    Writer.NewLine
        endm

Main
        call    Terminal.Init

        WriteString "Segment bit size: "
        ld      a, SEGMENT_BIT_SIZE
        call    Writer.Hex8
        call    Writer.NewLine

        WriteString "Segment size: "
        ld      hl, SEGMENT_SIZE
        call    Writer.Hex16
        call    Writer.NewLine

        WriteString "Segment mask: "
        ld      hl, SEGMENT_ADDR_MASK
        call    Writer.Hex16
        call    Writer.NewLine

        call    Writer.NewLine

        ; Initialize segment config
        ld      hl, Segment
        ldi_ihl_u16 SEGMENT_ADDR_MASK
        ldi_ihl_u8  SEGMENT_BIT_SIZE

        WritelnString "Init size 3"
        ld      hl, segment
        ld      a, 3
        call    FxPage.Init
        call    Dump

        WritelnString "Init size 2"
        ld      hl, segment
        ld      a, 2
        call    FxPage.Init
        call    Dump

        WritelnString "Init size 1"
        ld      hl, segment
        ld      a, 1
        call    FxPage.Init
        call    Dump

        WritelnString "Init size 0"
        ld      hl, segment
        ld      a, 0
        call    FxPage.Init
        call    Dump

.end    jp      .end

Dump
        ld      hl, segment
        ld      bc, SEGMENT_SIZE
        call    Writer.Dump
        call    Writer.NewLine
        ret

        org     $c000
segment         ds      SEGMENT_SIZE, $ff

        savenex open "built/scheme/fx-page-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/scheme/fx-page-demo.map"
