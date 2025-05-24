  ; =================================================================
  ; A page with fixed-size values
  ; =================================================================
  ifndef FxPage_asm
  define FxPage_asm
    include ../control.asm
    include segment.asm
    include bit-size.asm

    _module FxPage
      ; -----------------------------------------------------------------
      ; Input:
      ;   HL - segment address
      ;   A - element bit size / TODO what about user meta data?
      ; -----------------------------------------------------------------
      _proc Init
        _preserve hl
          call BitSize.GetSize  ; DE = size (power-of-two)
        _end
        _block loop
          ld (hl), 0
          add hl, de
          _preserve de_hl
            call Segment.IsZero
          _end
          jp nz, .loop
        _end
      _end
    _end
  endif
