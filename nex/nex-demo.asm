  include control.asm
  _nex nex-demo
    include terminal.asm
    _proc Main
      call Terminal.Init
      WritelnString "Hello, NEX!!!"
      _block loop
        jp .loop
      _end
    _end
  _end
