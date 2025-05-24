  include control.asm

  _nex nex-demo
    include terminal.asm

    _main
      call Terminal.Init
      WritelnString "Hello, NEX!!!"
      _freeze
    _end
  _end
