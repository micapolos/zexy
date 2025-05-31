  include zexy.asm

  _nex tests
    include mem-test.asm

    _main
      call Terminal.Init

      _calltest Mem

      _freeze
    _end
  _end
