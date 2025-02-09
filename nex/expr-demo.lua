require("expr")

function expr_demo()
  exec(
    loop(
      writeln("Hello, world!"),
      write("value is: "),
      store("value", inc(load16("value"))),
      writeln(load16("value")),
      waitSpace()))
end
