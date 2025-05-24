  device  zxspectrumnext

  org     $8000

  include terminal.asm
  include writer.asm
  include control.asm

Main
  call    Terminal.Init

  WriteString "Testing _skip... "
  _skip
    WritelnString "ERROR"
  _end
  WritelnString "OK"

  WriteString "Testing _if z, positive... "
  xor     a
  _if z
    WritelnString "OK"
  _end

  WriteString "Testing _if nz, positive... "
  ld a, 1
  or a
  _if nz
    WritelnString "OK"
  _end

  WriteString "Testing _if c, positive... "
  scf
  _if c
    WritelnString "OK"
  _end

  WriteString "Testing _if nc, positive... "
  or a
  _if nc
    WritelnString "OK"
  _end

  WriteString "Testing _if / _else, positive... "
  xor a
  _if z
    WritelnString "OK"
  _else
    WritelnString "ERROR"
  _end

  WriteString "Testing _if / _else, negative... "
  ld a, 1
  or a
  _if z
    WritelnString "ERROR"
  _else
    WritelnString "OK"
  _end

  WriteString "Testing _preserve hl... "
  ld hl, $1234
  _preserve hl
    ld hl, $5678
  _end
  ld de, $1234
  sub hl, de
  _if z
    WritelnString "OK"
  _else
    WritelnString "ERROR (invalid H)"
  _end

  ; TODO: Implement real checks, not only syntax
  WriteString "Testing _preserve bc_de_hl_af... "
  _preserve bc_de_hl_af
  _end
  WritelnString "OK"

  WriteString "Testing _djnz... "
  ld a, 0
  ld b, 45
  _djnz
    inc a
    inc a
  _end
  xor 90
  _if z
    WritelnString "OK"
  _else
    WritelnString "ERROR"
  _end

  WriteString "Testing _proc... "
  _skip
    _proc Increment
      inc a
    _end
  _end

  ld a, 0
  call Increment
  xor 1
  _if z
    WritelnString "OK"
  _else
    WritelnString "ERROR"
  _end

  WriteString "Testing _const / _var outside _data... "
  _skip
    _const const8, $ff
    _const const16, $ffff
    _var   var8, db, 0
    _var   var16, dw, 0
  _end
  ld a, const8
  ld hl, const16
  ld a, (var8)
  ld hl, (var16)
  WritelnString "OK"

  WriteString "Testing _const / _var inside _data_... "
  _skip
    _data Segment
      _const const8, $ff
      _const const16, $ffff
      _var   var8, db, 0
      _var   var16, dw, 0
    _end
  _end
  ld a, Segment.const8
  ld hl, Segment.const16
  ld a, (Segment.var8)
  ld hl, (Segment.var16)
  WritelnString "OK"

.end
  jp      .end

  savenex open "built/control-demo.nex", Main, $bfe0
  savenex auto
  savenex close
  cspectmap    "built/control-demo.map"
