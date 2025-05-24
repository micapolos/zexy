require("zexy")

function block_test(name)
  _pc("_testing \"" .. name .. "\"")
  block_begin(
    "test",
    nil,
    nil,
    function()
      _pc("_ok")
    end)
end
