  include zexy.asm

  _nex test-demo
    include test.asm

    _suite
      _test passing
      _end

      _test failing
        _error
      _end
    _end
  _end
