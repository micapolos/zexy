  include test.asm
  include segment.asm

  _proc SegmentTest
    _test IsZero_start
      ld hl, Segment.BASE_MASK
      call Segment.IsZero
      _assert z
    _end

    _test IsZero_middle
      ld hl, Segment.BASE_MASK + 1
      call Segment.IsZero
      _assert nz
    _end
  _end
