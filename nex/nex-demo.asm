  include control.asm

  _nex nex-demo
    include terminal.asm

    _main
      call Terminal.Init
      _writeln "Hello, NEX!!!"
      _freeze
    _end
  _end
