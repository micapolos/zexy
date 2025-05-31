  ifndef Test_asm
  define Test_asm
    include zexy.asm
    include terminal.asm

    lua allpass
      require("test")
    endlua

    macro _test name
      lua allpass
        block_test(arg("name"))
      endlua
    endm

    macro _assert cond
      _if cond
      _else
        _error
      _end
    endm

    macro _calltest name
      lua allpass
        call_test(arg("name"))
      endlua
    endm
  endif
