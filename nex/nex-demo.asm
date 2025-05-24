  include control.asm
  _nex nex-demo
    include terminal.asm
    _proc Main
      call Terminal.Init
      WritelnString "Hello, NEX!!!"
      _freeze
    _end
  _end
