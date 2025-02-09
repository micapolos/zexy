function exec(...)
  local args = {...}
  for i = 1, #args do
    args[i]()
  end
end

function loop(...)
  local args = {...}
  return function()
    local addr = sj.current_address
    for i = 1, #args do
      args[i]()
    end
    _pc("jp " .. hex16(addr))
  end
end

function waitSpace()
  return function()
    _pc("call Debug.WaitSpace")
  end
end

function u8(a)
  if a < 0x00 or a > 0xff then
    sj.error("invalid i8 ", hex(a))
    sj.exit()
  else
    return {
      type = "u8",
      fn = function(size)
        if size ~= 0 then
          _pc("push hl")
        end
        _pc("ld hl, " .. hex16(a))
        return size + 1
      end
    }
  end
end

function u16(a)
  if a < 0x00 or a > 0xffff then
    sj.error("invalid i16 ", hex(a))
    sj.exit()
  else
    return {
      type = "u16",
      fn = function(size)
        if size ~= 0 then
          _pc("push hl")
        end
        _pc("ld hl, " .. hex16(a))
        return size + 1
      end,
    }
  end
end

function write(a)
  if type(a) == "number" then
    return function()
      _pc("WriteString " .. str(hex(a)))
    end
  elseif type(a) == "string" then
    return function()
      _pc("WriteString \"" .. a .. "\"")  -- escape?
    end
  elseif a.type == "u8" then
    return function()
      a.fn(0)
      _pc("ld a, l")
      _pc("call Writer.Hex8h")
    end
  elseif a.type == "u16" then
    return function()
      a.fn(0)
      _pc("call Writer.Hex16h")
    end
  else
    sj.error("write(" .. expr .. ")")
    sj.exit()
  end
end

function writeln(a)
  local fn = write(a)
  return function()
    fn()
    _pc("Writeln")
  end
end

function inc(a)
  if type(a) == "number" then
    return a + 1
  elseif a.type == "u8" then
    return {
      type = "u8",
      fn = function(size)
        local size = a.fn(size)
        _pc("inc l")
        return size
      end
    }
  elseif a.type == "u16" then
    return  {
      type = "u16",
      fn = function(size)
        local size = a.fn(size)
        _pc("inc hl")
        return size
      end
    }
  else
    sj.error("inc(" .. expr .. ")")
    sj.exit()
  end
end

function dec(a)
  if type(a) == "number" then
    return a + 1
  elseif a.type == "u8" then
    return {
      type = "u8",
      fn = function(size)
        local size = a.fn(size)
        _pc("dec l")
        return size
      end
    }
  elseif a.type == "u16" then
    return  {
      type = "u16",
      fn = function(size)
        local size = a.fn(size)
        _pc("dec hl")
        return size
      end
    }
  else
    sj.error("dec(" .. expr .. ")")
    sj.exit()
  end
end

function add(a, b)
  if type(a) == "number" then
    if type(b) == "number" then
      return a + b
    else
      return {
        type = b.type,
        fn = function(size)
          size = b.fn(size)
          _pc("add hl, " .. hex16(a))
          return size
        end
      }
    end
  else
    if type(b) == "number" then
      return {
        type = a.type,
        fn = function(size)
          local size = a.fn(size)
          _pc("add hl, " .. hex16(b))
          return size
        end
      }
    else
      local bv = fn_of(b, a.type)
      return {
        type = a.type,
        fn = function(size)
          local size = a.fn(size)
          size = b.fn(size)
          _pc("pop de")
          _pc("add hl, de")
          return size - 1
        end
      }
    end
  end
end

function load(addr, typ)
  local addrLit = addrLiteral(addr)
  if typ == "u8" then
    return {
      type = typ,
      fn = function(size)
        if size ~= 0 then
          _pc("push hl")
        end
        _pc("ld h, 0")
        _pc("ld l, (" .. addrLit .. ")")
        return size + 1
      end
    }
  elseif typ == "u16" then
    return {
      type = typ,
      fn = function(size)
        if size ~= 0 then
          _pc("push hl")
        end
        _pc("ld hl, (" .. addrLit .. ")")
        return size + 1
      end
    }
  else
    sj.error("load(" .. typ .. ", " .. addrLit .. ")")
    sj.exit()
  end
end

function load8(addr)
  return load(addr, "u8")
end

function load16(addr)
  return load(addr, "u16")
end

function store(addr, expr, typ)
  local addrLit = addrLiteral(addr)
  if type(expr) == "number" then
    if typ == "u8" then
      return function()
        _pc("ld a, " .. hex8(expr))
        _pc("ld (" .. addrLit .. "), a")
      end
    elseif typ == "u16" then
      return function()
        _pc("ld hl, " .. hex16(expr))
        _pc("ld (" .. addrLit .. "), hl")
      end
    else
      sj.error("store(" .. addr .. ", " .. expr .. ", " .. typ .. ")")
      sj.exit()
    end
  else
    if expr.type == "u8" then
      return function()
        expr.fn(0)
        _pc("ld (" .. addrLit .. "), l")
      end
    elseif expr.type == "u16" then
      return function()
        expr.fn(0)
        _pc("ld (" .. addrLit .. "), hl")
      end
    else
      sj.error("store(" .. addr .. ", " .. expr .. ", " .. typ .. ")")
      sj.exit()
    end
  end
end

function fn_of(expr, type)
  if expr.type ~= type then
    sj.error("invalid type of " .. expr.fn .. ", expected " .. type .. ", was " .. expr.type)
    sj.exit()
  end
end

function hex(a)
  return string.format("%Xh", a)
end

function hex8(a)
  return string.format("%02Xh", a)
end

function hex16(a)
  return string.format("%04Xh", a)
end

function str(s)
  return "\"" .. s .. "\"" -- todo: escape
end

function addrLiteral(addr)
  if type(addr) == "number" then
    -- TODO: Validate hex16
    return hex16(addr)
  elseif type(addr) == "string" then
    return addr
  else
    sj.error("addrLiteral(" .. addr .. ")")
    sj.exit()
  end
end

