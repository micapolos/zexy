  ifndef Segment_asm
  define Segment_asm
    include ../zexy.asm
    include ../math.asm

    _data Segment
      _var addrMask, dw, 0
      _var bitSize,  db, 0
    _end

    _module Segment
      ; ---------------------------------------------------
      ; Input:
      ;   hl - address
      ; Output:
      ;   FZ: 0 = zero, 1 = non-zero
      ; ---------------------------------------------------
      _proc IsZero
        ex      de, hl
        ld      hl, (Segment.addrMask)
        and_hl_rr de
        ld      a, h
        or      l
      _end
    _end
  endif
