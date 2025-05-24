  ; =================================================================
  ; A page with fixed-size values
  ; =================================================================
  ifndef FxPage_asm
  define FxPage_asm
    include ../zexy.asm
    include segment.asm
    include value.asm
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

      ; -----------------------------------------------------------------
      ; Input:
      ;   HL - cursor
      ; Output
      ;   HL - preserved
      ; -----------------------------------------------------------------
      _proc Free
        ld (hl), 0
      _end

      ; -----------------------------------------------------------------
      ; Input:
      ;   HL - cursor
      ;   A - element bit size
      ; Output
      ;   FC: 0 = OK, 1 - overflow
      ;   HL - advanced cursor
      ; -----------------------------------------------------------------
      _proc Alloc
        _preserve hl
          call BitSize.GetSize    ; de = size
        _end
        ld b, (hl)                ; b = header
        bit Value.ALLOCATED_BIT, b
        ret nc
        add hl, de

      _end

      ; -----------------------------------------------------------------
      ; Input:
      ;   HL - cursor
      ;   DE - size
      ; Output
      ;   FC - 0 = OK, 1 - overflow
      ;   DE - preserved
      ;   HL - advanced cursor
      ; -----------------------------------------------------------------
      _proc Next
        add hl, de
        _preserve de_hl
          call Segment.IsZero
        _end
      _end

    _end
  endif
