  ifndef Control_asm
  define Control_asm

    lua allpass
      require("control")
      control_init()
    endlua

    macro _end
      lua allpass
        block_end()
      endlua
    endm

    macro _module name
      lua allpass
        block_module(sj.get_define("name", true))
      endlua
    endm

    macro _skip
      lua allpass
        block_skip()
      endlua
    endm

    macro _block name
      lua allpass
        block_block(sj.get_define("name", true))
      endlua
    endm

    macro _if cond
      lua allpass
        block_if(sj.get_define("cond", true))
      endlua
    endm

    macro _else
      lua allpass
        block_else()
      endlua
    endm

    macro _preserve regs
      lua allpass
        block_preserve(sj.get_define("regs", true))
      endlua
    endm

    macro _djnz
      lua allpass
        block_djnz()
      endlua
    endm

    macro _proc name
      lua allpass
        block_proc(sj.get_define("name", true))
      endlua
    endm

    macro _data name
      lua allpass
        block_data(sj.get_define("name", true))
      endlua
    endm

    macro _const name, value
      lua allpass
        control_const(
          sj.get_define("name", true),
          sj.get_define("value", true))
      endlua
    endm

    macro _var name, type, value
      lua allpass
        control_var(
          sj.get_define("name", true),
          sj.get_define("type", true),
          sj.get_define("value", true))
      endlua
    endm

    macro _nex name
      lua allpass
        block_nex(sj.get_define("name", true))
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

    macro _while cond
      lua allpass
        control_while(sj.get_define("cond", true))
      endlua
    endm

    macro _until cond
      lua allpass
        control_until(sj.get_define("cond", true))
      endlua
    endm

  endif
