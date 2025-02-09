function font(...)
  return {...}
end

function glyph(char, ...)
  local code
  if type(char) == "string" then
    code = string.byte(char)
  elseif type(char) == "number" then
    code = char
  else
    sj.error("invalid char: " .. char)
    sj.exit()
  end
  if code < 0 or code > 127 then
    sj.error("invalid char code: " .. code)
    sj.exit()
  end

  local lines = {...}
  if #lines ~= 8 then
    sj.error("invalid number of lines in: " .. char)
    sj.exit()
  end

  local bitsLines = {}
  local width
  for i = 1, #lines do
    local line = lines[i]
    local lineWidth = string.len(line)
    if width == nil then
      if lineWidth == 0 then
        sj.error("empty line 1 in: " .. char)
        sj.exit()
      end
      width = lineWidth
    elseif lineWidth ~= width then
      sj.error("invalid width in line: " .. i .. " in: " .. char)
      sj.exit()
    end

    local bits = ""
    for j = 1, lineWidth do
      local ch = string.sub(line, j, j)
      local bit
      if ch == " " or ch == '.' then
        bit = "0"
      else
        bit = "1"
      end
      bits = bits .. bit
    end
    bitsLines[i] = bits
  end

  return {
    code = code,
    width = width,
    lines = bitsLines,
  }
end
