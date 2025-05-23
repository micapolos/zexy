; ===============================================================
; Allocator of aligned power-of-two blocks inside aligned
; power-of-two segments.
;
; The first byte of allocated block contains header, remaining
; bytes contains block data.
;
; Block header:
; - bit 7: 0 = free, 1 = allocated
; - bit 6..4: user data, zero if not allocated
; - bit 3..0: block size: 0..15, actual size = 1 << bitSize
; ===============================================================

        ifndef  SchemeBlock_asm
        define  SchemeBlock_asm

        include ../pot.asm

        module  SchemeBlock

SEGMENT_BIT_SIZE        db      12

; =========================================================
; Input:
;   hl - block address
;   de - block size (power of two)
; Output:
;   hl - sibling block address
;   af - corrupted, other preserved
; =========================================================
        macro   _GetSiblingBlock

        ld      a, h
        xor     d
        ld      h, a

        ld      a, l
        xor     e
        ld      l, a

        endm

; =========================================================
; Input:
;   hl - block address
;   de - block size (power of two)
; Output:
;   hl - sibling block address
;   af - corrupted, other preserved
; =========================================================
        macro   _GetParentBlock

        ld      a, d
        cpl
        and     h
        ld      h, a

        ld      a, e
        cpl
        and     l
        ld      l, a

        endm

; =========================================================
; Input:
;   HL - top-level block address
Init
        ld      a, (SEGMENT_BIT_SIZE)
        ld      (hl), a
        ret

; =========================================================
; Input:
;   A - block size: 0..15, actual size = 1 << bitSize
;   HL - current block address (may be free or allocated)
; Output:
;   FC - 0 = OK, 1 = out of memory
;   HL - allocated block address
Alloc
        push    hl      ; push current block address, to detect cycle
        ret

; =========================================================
; Input:
;   HL - block address
; Output:
;   HL - coalesced block address, not necessarily free
; =========================================================
Free
        push    hl              ; stack = [block address]
        ld      a, (hl)         ; A - block header
        push    af              ; stack = [block address, block header]
        and     $0f             ; A - block size bits
        call    POT.Get         ; DE - block size
        pop     bc              ; B - block header
        pop     hl              ; HL - block address

.coalesce
        ; return if block is top-level (size >= SEGMENT_BIT_SIZE)
        ld      a, b
        cp      (SEGMENT_BIT_SIZE)
        ret     nc

        _GetSiblingBlock
        ld      c, (hl)        ; c = sibling block header

        ; return if sibling block is not free
        bit     7, c
        ret     nz

        ; return if sibling block has different size
        ld      a, c
        xor     b
        ret     nz

        _GetParentBlock

        ; coalesce sibling blocks
        inc     b
        ld      (hl), b

        ; block size *= 2
        rlc     e
        rl      d

        ; bubble up
        jp      .coalesce

        endmodule

        endif
