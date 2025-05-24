  include control.asm
  _nex control-demo
    include terminal.asm
    include writer.asm
    include control.asm

    _const const8, $ff
    _const const16, $ffff
    _var   var8, db, 0
    _var   var16, dw, 0

    _data Segment
      _const const8, $ff
      _const const16, $ffff
      _var   var8, db, 0
      _var   var16, dw, 0
    _end

    _main
      call    Terminal.Init

      _test "_skip"
      _skip
        _error
      _end
      _ok

      _test "_block"
      jp .okBlock
      _block errorBlock
        _error
      _end
      _block okBlock
        _ok
      _end

      _test "_if z, positive"
      xor     a
      _if z
        _ok
      _end

      _test "_if nz, positive"
      ld a, 1
      or a
      _if nz
        _ok
      _end

      _test "_if c, positive"
      scf
      _if c
        _ok
      _end

      _test "_if nc, positive"
      or a
      _if nc
        _ok
      _end

      _test "_if / _else, positive"
      xor a
      _if z
        _ok
      _else
        _error
      _end

      _test "_if / _else, negative"
      ld a, 1
      or a
      _if z
        _error
      _else
        _ok
      _end

      _test "_preserve hl"
      ld hl, $1234
      _preserve hl
        ld hl, $5678
      _end
      ld de, $1234
      sub hl, de
      _okif z

      ; TODO: Implement real checks, not only syntax
      _test "_preserve bc_de_hl_af"
      _preserve bc_de_hl_af
      _end
      _ok

      _test "_djnz"
      ld a, 0
      ld b, 45
      _djnz
        inc a
        inc a
      _end
      xor 90
      _okif z

      _test "_do / _end"
      ld a, 0
      _do
        inc a
      _end
      xor 1
      _okif z

      _test "_loop / _end"
      ld a, 0
      ld b, 12
      _loop
        inc a
        inc a
        dec b
        jp z, exit    ;  TODO: Implement break | continue, which will pop from the stack if necessary.
      _end
!exit
      xor 24
      _okif z

      _test "_loop / _while"
      ld a, 0
      ld b, 12
      _loop
        inc a
        inc a
        dec b
      _while nz
      xor 24
      _okif z

      _test "_loop / _until"
      ld a, 0
      ld b, 12
      _loop
        inc a
        inc a
        dec b
      _until z
      xor 24
      _okif z

      _test "_proc"
      _skip
        _proc Increment
          inc a
        _end
      _end

      ld a, 0
      call Increment
      xor 1
      _okif z

      _test "_const / _var outside _data"
      ld a, const8
      ld hl, const16
      ld a, (var8)
      ld hl, (var16)
      _ok

      _test "_const / _var inside _data_"
      ld a, Segment.const8
      ld hl, Segment.const16
      ld a, (Segment.var8)
      ld hl, (Segment.var16)
      _ok

      _test "_module"
      _module Foo
        _const FOO, 10
      _end
      ;ld a, Foo.FOO
      _ok

      _freeze
    _end
  _end
