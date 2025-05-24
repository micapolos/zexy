  device  zxspectrumnext

  org     $8000

  include terminal.asm
  include writer.asm
  include ld.asm
  include dump.asm
  include control.asm
  include scheme/fx-page.asm
  include mem.asm

  _const SEGMENT_BIT_SIZE, 3
  _const SEGMENT_SIZE, 1 << (SEGMENT_BIT_SIZE + 1)
  _const SEGMENT_ADDR_MASK, SEGMENT_SIZE - 1

  macro   PressSpaceTo msg
    WriteString "<- Press SPACE to "
    WriteString msg
    WritelnString " ->"
    call    Debug.WaitSpace
    call    Writer.NewLine
  endm

  _proc Main
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

    call    Reset
    WritelnString "Init size 3"
    ld      hl, segment
    ld      a, 3
    call    FxPage.Init
    call    Dump

    call    Reset
    WritelnString "Init size 2"
    ld      hl, segment
    ld      a, 2
    call    FxPage.Init
    call    Dump

    call    Reset
    WritelnString "Init size 1"
    ld      hl, segment
    ld      a, 1
    call    FxPage.Init
    call    Dump

    call    Reset
    WritelnString "Init size 0"
    ld      hl, segment
    ld      a, 0
    call    FxPage.Init
    call    Dump

    _block end
      jp .end
    _end
  _end

  _proc Dump
    ld      hl, segment
    ld      bc, SEGMENT_SIZE
    call    Writer.Dump
    call    Writer.NewLine
  _end

  _proc Reset
    ld      hl, segment
    ld      bc, SEGMENT_SIZE
    ld      e, $ff
    call      Mem.Fill
  _end

  org     $c000
  _data segment
    ds      SEGMENT_SIZE, $ff
  _end

  savenex open "built/scheme/fx-page-demo.nex", Main, $bfe0
  savenex auto
  savenex close
  cspectmap    "built/scheme/fx-page-demo.map"
