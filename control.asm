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

  endif
