  ifndef Control_asm
  define Control_asm

  lua allpass
    require("control")
    control_init()
  endlua

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

  macro _end
    lua allpass
      block_end()
    endlua
  endm

  endif
