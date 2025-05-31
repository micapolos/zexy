  include test.asm
  include mem.asm

  _module Mem
    _proc Test
      _test Eq1
        ld hl, mem1 + 2
        ld de, mem2 + 2
        ld bc, 2
        call Mem.Eq
        _assert z
      _end

      _test Neq1
        ld hl, mem1
        ld de, mem2
        ld bc, 4
        call Mem.Eq
        _assert nz
      _end

      _test Neq2
        ld hl, mem1 + 1
        ld de, mem2 + 1
        ld bc, 3
        call Mem.Eq
        _assert nz
      _end

      _test Fill
        ld hl, fillMem
        ld bc, 3
        ld e, $12
        call Mem.Fill
        ld hl, fillMem
        ld de, fillMem1
        ld bc, 4
        call Mem.Eq
        _assert z
      _end

      _test Clear
        ld hl, fillMem
        ld bc, 2
        call Mem.Clear
        ld hl, fillMem
        ld de, fillMem2
        ld bc, 4
        call Mem.Eq
        _assert z
      _end
    _end

    _block mem1
      db $00, $01, $02, $03
    _end

    _block mem2
      db $00, $02, $02, $03
    _end

    _block fillMem
      db $00, $00, $00, $00
    _end

    _block fillMem1
      db $12, $12, $12, $00
    _end

    _block fillMem2
      db $00, $00, $12, $00
    _end
  _end
