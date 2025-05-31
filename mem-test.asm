  include test.asm
  include mem.asm

  _module Mem
    _proc Test
      _test neq1
        ld hl, mem1
        ld de, mem2
        ld bc, 4
        call Mem.Eq
        _assert nz
      _end

      _test neq2
        ld hl, mem1 + 1
        ld de, mem2 + 1
        ld bc, 3
        call Mem.Eq
        _assert nz
      _end

      _test neq3
        ld hl, mem1 + 2
        ld de, mem2 + 2
        ld bc, 2
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
  _end
