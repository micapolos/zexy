  include control.asm

  _nex fx-page-demo
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

    macro PressSpaceTo msg
      _write "<- Press SPACE to "
      _write msg
      _writeln " ->"
      call    Debug.WaitSpace
      call    Writer.NewLine
    endm

    _main
      call    Terminal.Init

      _write "Segment bit size: "
      ld      a, SEGMENT_BIT_SIZE
      call    Writer.Hex8
      call    Writer.NewLine

      _write "Segment size: "
      ld      hl, SEGMENT_SIZE
      call    Writer.Hex16
      call    Writer.NewLine

      _write "Segment mask: "
      ld      hl, SEGMENT_ADDR_MASK
      call    Writer.Hex16
      call    Writer.NewLine

      call    Writer.NewLine

      ; Initialize segment config
      ld      hl, Segment
      ldi_ihl_u16 SEGMENT_ADDR_MASK
      ldi_ihl_u8  SEGMENT_BIT_SIZE

      call    Reset
      _writeln "Init size 3"
      ld      hl, segment
      ld      a, 3
      call    FxPage.Init
      call    Dump

      call    Reset
      _writeln "Init size 2"
      ld      hl, segment
      ld      a, 2
      call    FxPage.Init
      call    Dump

      call    Reset
      _writeln "Init size 1"
      ld      hl, segment
      ld      a, 1
      call    FxPage.Init
      call    Dump

      call    Reset
      _writeln "Init size 0"
      ld      hl, segment
      ld      a, 0
      call    FxPage.Init
      call    Dump

      _freeze
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
  _end
