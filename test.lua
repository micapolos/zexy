require("zexy")

function block_test(name)
  _pc("_testing \"" .. name .. "\"")
  block_push({
    type = "test",
    end_fn = function()
      _pc("_ok")
    end
  })
end

function call_test(name)
  local label = name .. ".Test"
  _pc("_writeln \"===" .. label .. "===\"")
  _pc("call " .. label)
end

function assert_eq(reg, value)
  if string.lower(reg) == "a" then
    _pc("_preserve af_bc_de_hl")
    _pc("  cp " .. value)
    _pc("  _if z")
    _pc("    TerminalInk %010")
    _pc("    _writeln \"OK\"")
    _pc("    TerminalInk %111")
    _pc("  _else")
    _pc("    TerminalInk %100")
    _pc("    _writeln \"ERROR\"")
    _pc("    TerminalInk %111")
    _pc("    _write \"expected: \"")
    _pc("    ld a, " .. value)
    _pc("    call Writer.Hex8h")
    _pc("    _write \"actual: \"")
    _pc("    call Writer.Hex8h")
    _pc("    call Writer.NewLine")
    _pc("  _end")
    _pc("_end")
  elseif #reg == 1 then
    _pc("push af")
    _pc("ld a, " .. reg)
    _pc("_asserteq a, " .. value)
    _pc("pop af")
    _pc("ret")
  elseif #reg == 2 then
    _pc("push af")
    _pc("ld a, low " .. reg)
    _pc("_asserteq a, " .. low(value))
    _pc("ld a, high " .. reg)
    _pc("_asserteq a, " .. high(value))
    _pc("pop af")
    _pc("ret")
  else
    sj.error("invalid reg " .. reg)
  end
end
