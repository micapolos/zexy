  define TEST
  include zexy.asm

  _nex scheme/tests
    include scheme/segment-test.asm
    include scheme/bit-size-test.asm

    _main
      call Terminal.Init

      _writeln "=== BitSizeTest ==="
      call BitSizeTest

      _writeln "=== SegmentTest ==="
      call SegmentTest

      _freeze
    _end
  _end
