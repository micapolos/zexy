  device  zxspectrumnext

  org     $8000

  include terminal.asm
  include writer.asm
  include control.asm

Main
  call    Terminal.Init

  WriteString "Testing if z, positive... "
  xor     a
  _if z
    WritelnString "OK"
  _end

  WriteString "Testing if nz, positive... "
  ld a, 1
  or a
  _if nz
    WritelnString "OK"
  _end

  WriteString "Testing if c, positive... "
  scf
  _if c
    WritelnString "OK"
  _end

  WriteString "Testing if nc, positive... "
  or a
  _if nc
    WritelnString "OK"
  _end

  WriteString "Testing if / else, positive... "
  xor a
  _if z
    WritelnString "OK"
  _else
    WritelnString "ERROR"
  _end

  WriteString "Testing if / else, negative... "
  ld a, 1
  or a
  _if z
    WritelnString "ERROR"
  _else
    WritelnString "OK"
  _end

.end
  jp      .end

  savenex open "built/control-demo.nex", Main, $bfe0
  savenex auto
  savenex close
  cspectmap    "built/control-demo.map"
