function writeln16(a)
  _pc("ld a, '$'")
  _pc("call Writer.Char")
  ld_hl(a)
  _pc("call Writer.Hex16")
  _pc("call Writer.NewLine")
end

function const16(a)
  return function()
    _pc("push hl")
    _pc("ld hl, " .. hex16(a))
  end
end

function add16(a, b)
  if type(a) == "function" then
    if type(b) == "function" then
      return function()
        a()
        b()
        evalAdd16()
      end
    else
      return function()
        a()
        evalAddConst16()
      end
    end
  else
    if type(b) == "function" then
      return function()
        b()
        evalAddConst16(a)
      end
    else
      return a + b
    end
  end
end

function inc16(expr)
  if type(expr) == "function" then
    return function()
      expr()
      _pc("inc hl")
    end
  else
    return expr + 1
  end
end

function load16(addr)
  return function()
    _pc("push hl")
    if type(addr) == "number" then
      _pc("ld hl, (" .. hex16(addr) .. ")")
    elseif type(addr) == "string" then
      _pc("ld hl, (" .. addr .. ")")
    elseif type(addr) == "function" then
      -- TODO
    end
  end
end

function store16(addr)
  return function()
    if type(addr) == "number" then
      _pc("ld (" .. hex16(addr) .. "), hl")
    elseif type(addr) == "string" then
      _pc("ld (" .. addr .. "), hl")
    elseif type(addr) == "function" then
      -- TODO
    end
    _pc("pop hl")
  end
end

function ld_hl(a)
  if type(expr) == "function" then
    a()
  else
    _pc("ld hl, " .. hex16(a))
  end
end

function evalAdd16()
  _pc("pop de")
  _pc("add hl, de")
end

function evalAddConst16(a)
  _pc("ld de, " .. hex16(a))
  _pc("add hl, de")
end

function evalConstAdd16(a)
  _pc("ld de, " .. hex16(a))
  _pc("add hl, de")
end

function hex16(a)
  return string.format("$%04X", a)
end
