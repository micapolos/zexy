function inverted_cond(cond)
  if cond == "z" then
    return "nz"
  elseif cond == "nz" then
    return "z"
  elseif cond == "c" then
    return "nc"
  elseif cond == "nc" then
    return "c"
  else
    sj.error("invalid cond " .. cond)
  end
end

function split_underscore(string)
  local parts = {}
  for part in string:gmatch("[^_]+") do
    table.insert(parts, part)
  end
  return parts
end

function control_init()
  label_count = 0
  block_stack = {}
end

function gen_label(prefix)
  label_count = label_count + 1
  return prefix .. "_" .. label_count
end

function block_begin(type, value, end_fn)
  table.insert(block_stack, { type = type, value = value, end_fn = end_fn })
end

function block_update(expected_type, fn)
  local block = block_stack[#block_stack]
  if block == nil or block.type ~= expected_type then
    sj.error("not inside " .. expected_type)
  else
    block.value = fn(block.value)
  end
end

function block_end()
  local block = table.remove(block_stack)
  if block == nil then
    sj.error("unmatched end")
  else
    block.end_fn(block.value)
  end
end

-- Custom blocks

function block_if(cond)
  local end_label = gen_label("if")
  _pc("jp " .. inverted_cond(cond) .. ", " .. end_label)
  block_begin(
    "if",
    end_label,
    function(end_label)
      _pl("@" .. end_label)
    end)
end

function block_else()
  block_update(
    "if",
    function(end_label)
      local end_label_2 = gen_label("if")
      _pc("jp " .. end_label_2)
      _pl("@" .. end_label)
      return end_label_2
    end)
end

function block_preserve(regs_def)
  local regs = split_underscore(regs_def)
  for i = 1, #regs do
    _pc("push " .. regs[i])
  end
  block_begin(
    "push",
    nil,
    function()
      for i = #regs, 1, -1 do
        _pc("pop " .. regs[i])
      end
    end)
end

function block_djnz()
  local label = gen_label("djnz")
  _pl("@" .. label)
  block_begin(
    "djnz",
    nil,
    function()
      _pc("djnz " .. label)
    end)
end


function block_proc(name)
  _pl(name)
  block_begin(
    "proc",
    nil,
    function()
      _pc("ret")
    end)
end
