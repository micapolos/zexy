  ; =================================================================
  ; A page with fixed-size values
  ; =================================================================
  ifndef FxPage_asm
  define FxPage_asm
    include ../control.asm
    include segment.asm
    include bit-size.asm

    module FxPage
      ; -----------------------------------------------------------------
      ; Input:
      ;   HL - page-aligned address
      ;   A - size
      ; -----------------------------------------------------------------
      _proc Init
        call BitSize.GetSize   ; de = size
      _end
    endmodule
  endif
