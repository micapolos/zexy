  ifndef Dump_asm
  define Dump_asm

  include writer.asm
  include zexy.asm

  module Dump
columns  db  16
  endmodule

  module Writer

; ==================================================================
; Input
;   HL - address
;   BC - length
; ==================================================================
  _proc Dump
    ; bc = advanced length
    ; a = line length
    _preserve hl
      ld hl, bc
      ld a, (Dump.columns)
      ld d, 0
      ld e, a
      ld a, l
      sub hl, de
      _if c
        ld hl, 0
      _else
        ld a, e
      _end
      ld bc, hl
    _end

    _preserve bc
      ld c, a
      call DumpLine
    _end

    ; TODO: implement using _do / _while
    ld a, b
    or c
    ret z
    jp Dump
  _end

; ==================================================================
; Input
;   HL - address
;   C - length
; Output
;   HL - advanced
; ==================================================================
  _proc DumpLine
    _preserve bc_hl
      call Writer.Hex16
      _write "   "
    _end

    _preserve hl
      _preserve bc
        ld a, (Dump.columns)
        ld b, a
        _djnz
          ld d, (hl)
          inc hl
          _preserve hl
            xor a
            or c
            _if z
              _preserve bc
                _write "   "
              _end
            _else
              _preserve bc
                ld a, d
                call Writer.Hex8
                _write " "
              _end
              dec c
            _end
          _end
        _end
      _end

      _write "  "
    _end

    ld a, (Dump.columns)
    ld b, a
    _djnz
      ld d, (hl)
      inc hl
      _preserve hl
        xor a
        or c
        _if z
          _preserve bc
            _putc ' '
          _end
        _else
          ld a, d
          cp $20
          _preserve bc
            _if c
              _putc '.'
            _else
              cp $7f
              _if c
                call Writer.Char
              _else
                _putc '.'
              _end
            _end
          _end
          dec c
        _end
      _end
    _end
    _preserve hl
      call Writer.NewLine
    _end
  _end

  endmodule

  endif
