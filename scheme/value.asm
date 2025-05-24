; ===============================================================
; Value encoding:
; - L = value header
;   - bit 7 = allocation status: 0 = free, 1 = allocated
;   - bit 6 = value type: 0 - primitive (GC leaf), 1 - reference (subject to GC)
;   - bit 5 = GC mark: 0 - not marked, 1 = marked
;   - bit 4 = unused
;   - bit 3..0 = allocation size: 1 << (n + 2) bytes
;     - 0 = 4 bytes
;     - 1 = 8 bytes
;     - 2 = 16 bytes
;     - ...
;     - 11 = 8192 bytes
; - HDE = 24-bit value
;   - for references, bits 2..0 are reserved for tag:
;     - 000 = cons
;     - 001 = ???
; ===============================================================

  ifndef  SchemeValue_asm
  define  SchemeValue_asm
    include zexy.asm
    include ../reg.asm

    _module  Value
      _const ALLOCATED_BIT, 7
      _const REFERENCE_BIT, 6
      _const MARK_BIT, 5

      _const ALLOCATED, 1 << ALLOCATED_BIT
      _const REFERENCE, 1 << REFERENCE_BIT
      _const MARK, 1 << MARK_BIT

      _const FALSE_TAG, 0
      _const TRUE_TAG, 1
    _end
  endif
