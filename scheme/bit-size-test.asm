  include test.asm
  include bit-size.asm

  _proc BitSizeTest
    _test GetSize_0
      ld a, 0
      call BitSize.GetSize
      ld hl, $0002
      sub hl, de
      _assert z
    _end

    _test GetSize_12
      ld a, 12
      call BitSize.GetSize
      ld hl, $2000
      sub hl, de
      _assert z
    _end

    _test GetSize_15
      ld a, 15
      call BitSize.GetSize
      ld hl, $0000
      sub hl, de
      _assert z
    _end
  _end
