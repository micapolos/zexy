function l2_320_nine_patch(name, left, top, ...)
  local width = string.len(select(1, ...)) / 2
  local right = width - left - 1
  local height = select("#", ...)
  local bottom = height - top - 1
  _pl(name)
  _pl(".left equ " .. left)
  _pl(".top equ " .. top)
  _pl(".right equ " .. right)
  _pl(".bottom equ " .. bottom)
  _pl(".data")
  for x = 1, width do
    for y = 1, height do
      _pc("db $"
        .. string.sub(select(y, ...), x*2-1, x*2-1)
        .. string.sub(select(y, ...), x*2, x*2))
    end
  end
end

function l2_320_draw_nine_patch(name, x, y, width, height, transparent)
  _pc("nextreg Reg.MMU_7, (" .. x .. " >> 5) + 18")
  _pc("BlitNinePatch " ..
      name .. ".data, " ..
      "((" .. x .. " << 8) & $1f00) | $e000 | " .. y .. "," ..
      name .. ".top, " ..
      height .. " - " .. name .. ".top - " .. name .. ".bottom, " ..
      name .. ".bottom, " ..
      name .. ".left, " ..
      width .. " - " .. name .. ".left - " .. name .. ".right, " ..
      name .. ".right, " ..
      transparent)
end
