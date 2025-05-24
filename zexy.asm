  ifndef Zexy_asm
  define Zexy_asm

    lua allpass
      require("zexy")
      control_init()
    endlua

    macro _end
      lua allpass
        block_end()
      endlua
    endm

    macro _module name
      lua allpass
        block_module(arg("name"))
      endlua
    endm

    macro _skip
      lua allpass
        block_skip()
      endlua
    endm

    macro _block name
      lua allpass
        block_block(arg("name"))
      endlua
    endm

    macro _if cond
      lua allpass
        block_if(arg("cond"))
      endlua
    endm

    macro _else
      lua allpass
        block_else()
      endlua
    endm

    macro _preserve regs
      lua allpass
        block_preserve(arg("regs"))
      endlua
    endm

    macro _djnz
      lua allpass
        block_djnz()
      endlua
    endm

    macro _proc name
      lua allpass
        block_proc(arg("name"))
      endlua
    endm

    macro _data name
      lua allpass
        block_data(arg("name"))
      endlua
    endm

    macro _const name, value
      lua allpass
        control_const(
          arg("name"),
          arg("value"))
      endlua
    endm

    macro _var name, type, value
      lua allpass
        control_var(
          arg("name"),
          arg("type"),
          arg("value"))
      endlua
    endm

    macro _nex name
      lua allpass
        block_nex(arg("name"))
      endlua
    endm

    macro _freeze
      lua allpass
        control_freeze()
      endlua
    endm

    macro _main
      lua allpass
        block_proc("Main")
      endlua
    endm

    macro _do
      lua allpass
        block_do()
      endlua
    endm

    macro _loop
      lua allpass
        block_loop()
      endlua
    endm

    macro _while cond
      lua allpass
        control_while(arg("cond"))
      endlua
    endm

    macro _until cond
      lua allpass
        control_until(arg("cond"))
      endlua
    endm

    macro _label name
      lua allpass
        control_label(arg("name"))
      endlua
    endm

  endif
