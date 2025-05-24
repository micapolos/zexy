  ; =================================================================
  ; A page with fixed-size values
  ; =================================================================
  ifndef FxPg_asm
  define FxPg_asm

  include ../control.asm

  module FxPg

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
