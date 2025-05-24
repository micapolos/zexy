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

function block_top()
  return block_stack[#block_stack]
end

function block_top_of(expected_type)
  local block = block_top()
  if block == nil or block.type ~= expected_type then
    sj.error("not inside " .. expected_type)
  else
    return block
  end
end

function block_begin(type, name, value, end_fn)
  table.insert(block_stack, { type = type, name = name, value = value, end_fn = end_fn })
end

function block_update(expected_type, fn)
  local block = block_top_of(expected_type)
  block.value = fn(block.value)
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

function block_module(name)
  _pc("module " .. name)
  block_begin(
    "module",
    nil,
    nul,
    function()
      _pc("endmodule")
    end)
end

function block_skip()
  local end_label = gen_label("skip")
  _pc("jp " .. end_label)
  block_begin(
    "skip",
    nil,
    end_label,
    function(end_label)
      _pl("@" .. end_label)
    end)
end

function block_block(name)
  local label = name_label(name)
  _pl(label)
  block_begin(
    "proc",
    name,
    nil,
    function()
    end)
end

function block_if(cond)
  local end_label = gen_label("if")
  _pc("jp " .. inverted_cond(cond) .. ", " .. end_label)
  block_begin(
    "if",
    nil,
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
    nil,
    function()
      _pc("djnz " .. label)
    end)
end


function block_proc(name)
  _pl(name)
  block_begin(
    "proc",
    name,
    nil,
    function()
      _pc("ret")
    end)
end

function has_label_at(index)
  if index == 0 then
    return false
  else
    local block = block_stack[index]
    return block.name ~= nil or has_label_at(index - 1)
  end
end

function has_label()
  return has_label_at(#block_stack)
end

function name_label(name)
  if has_label() then
    return "@." .. name
  else
    return name
  end
end

function block_data(name)
  local label = name_label(name)
  _pl(label)
  block_begin(
    "data",
    name,
    nil,
    function()
      _pl("._end")
      _pl("._size equ ._end - " .. label)
    end)
end

function control_const(name, value)
  local label = name_label(name)
  _pl(label .. " equ " .. value)
end

function control_var(name, type, value)
  local label = name_label(name)
  _pl(label .. " " .. type .. " " .. value)
end

function block_nex(name)
  _pc("device zxspectrumnext")
  _pc("org $8000")
  block_begin(
    "nex",
    nil,
    nil,
    function()
      _pc("savenex open \"built/" .. name .. ".nex\", Main, $bfe0")
      _pc("savenex auto")
      _pc("savenex close")
      _pc("cspectmap \"built/" .. name .. ".map\"")
    end)
end

function control_freeze()
  local label = gen_label("freeze")
  _pl(label)
  _pc("jp " .. label)
end


