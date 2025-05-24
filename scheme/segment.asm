  ifndef Segment_asm
  define Segment_asm
    include zexy.asm
    include math.asm

    ; Allow configuring different value for tests.
    ifndef SEGMENT_BIT_SIZE
    define SEGMENT_BIT_SIZE 12
    endif

    _data Segment
      _const BIT_SIZE,  SEGMENT_BIT_SIZE
      _const SIZE,      1 << (.BIT_SIZE + 1)
      _const ADDR_MASK, .SIZE - 1
      _const BASE_MASK, ~.ADDR_MASK & $ffff

      DISPLAY "Segment"
      DISPLAY ".BIT_SIZE:  ", .BIT_SIZE
      DISPLAY ".SIZE:      ", .SIZE
      DISPLAY ".ADDR_MASK: ", .ADDR_MASK
      DISPLAY ".BASE_MASK: ", .BASE_MASK

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
