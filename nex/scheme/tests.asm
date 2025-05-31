  define TEST
  include zexy.asm

  _nex scheme/tests
    include scheme/segment-test.asm
    include scheme/bit-size-test.asm

    _main
      call Terminal.Init
      _calltest BitSize
      _calltest Segment
      _freeze
    _end
  _end
