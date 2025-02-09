function font_gen(name, font)
  local index = {}
  for i = 0, 127 do
    index[i] = 0
  end

  _pl(name)
  _pl(".data")
  for i = 1, #font do
    local glyph = font[i]
    if glyph ~= nil then
      local code = glyph.code
      local width = glyph.width
      index[code] = sj.current_address
      _pl(".g" .. code .. " db " .. width)
      for x = 1, width do
        local db = "db %"
        for y = 1, 8 do
          db = db .. string.sub(glyph.lines[y], x, x)
        end
        _pc(db)
      end
    end
  end
  _pl(".dataSize equ $ - .data")

  _pl(".index")
  for i = 0, 127 do
    _pl(".i" .. i .. " dw " .. string.format("$%04X", index[i]))
  end
  _pl(".indexSize equ $ - .index")
end
