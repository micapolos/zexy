  include test.asm
  include segment.asm

  _module Segment
    _proc Test
      _test IsZero_start
        ld hl, BASE_MASK
        call IsZero
        _assert z
      _end

      _test IsZero_middle
        ld hl, BASE_MASK + 1
        call IsZero
        _assert nz
      _end
    _end
  _end
