  ; =================================================================
  ; A page with fixed-size values
  ; =================================================================
  ifndef FxPage_asm
  define FxPage_asm

  include ../control.asm

  module FxPage

  ; -----------------------------------------------------------------
  ; Input:
  ;   HL - page-aligned address
  ;
  ;   A - size
  ; -----------------------------------------------------------------
  _proc Init
  _end

  endmodule
  endif
