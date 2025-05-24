  ifndef Segment_asm
  define Segment_asm
    include ../control.asm
    _data Segment
      _var addrMask, dw, 0
      _var bitSize,  db, 0
    _end
  endif
