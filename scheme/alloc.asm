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
; - bit 3..0: block size: 0..15
;   - actual size = 1 << (bitSize + 1)
;   - 0 means 65536
; ===============================================================

        ifndef  SchemeAlloc_asm
        define  SchemeAlloc_asm

        include ../ld.asm

        module  SchemeAlloc

ALLOCATED_BIT   equ     7
ALLOCATED_MASK  equ     $80
DATA_MASK       equ     $70
SIZE_MASK       equ     $0f

segment
.addrMask       dw      0
.bitSize        db      0

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
;   HL - block address
; Output:
;   HL - block address
;   DE - block size
;   B - block header
; =========================================================
GetMetadata
        push    hl              ; stack = [block address]
        ld      a, (hl)         ; A - block header
        push    af              ; stack = [block address, block header]
        and     SIZE_MASK       ; A - block bit size
        call    GetSize         ; DE - block size
        pop     bc              ; B - block header
        pop     hl              ; HL - block address
        ret

; =========================================================
; Input:
;   HL - segment address
; =========================================================
InitSegment
        ld      a, (segment.bitSize)
        ld      (hl), a
        ret

; =========================================================
; Input:
;   C - block header
;     - bit 7: zero
;     - bits 6..4: user data
;     - bits 3..0: requested size, actual size = 1 << bitSize
;   HL - current block address (may be free or allocated)
; Output:
;   FC - 0 = OK, 1 = out of memory
;   HL - allocated block address
; =========================================================
Alloc
        call    GetMetadata

        ; check if block is free
        bit     ALLOCATED_BIT, b
        jp      nz, .nextBlock

.checkSize
        ; check if the size is equal or larger than requested
        ld      a, b
        cp      c
        jp      c, .nextBlock
        jp      nz, .split

.allocate
        ld      (hl), c  ; carry is already zero
        ret

.nextBlock
        add     hl, de

.applySegmentMask
        dec     de
        ld      a, h
        and     d
        ld      h, a
        ld      a, l
        and     e
        ld      l, a
        inc     de

.checkBlockFull
        ld      a, h
        cp      0
        jp      nz, .notFull
        ld      a, e
        cp      l
        jp      nz, .notFull
.full


.notFull
        exx

.split
        ; divide block size by 2
        dec     b
        rrc     d
        rr      e

        ; mark sibling block as free
        _GetSiblingBlock
        ld      (hl), b
        _GetSiblingBlock

        ; repeat search
        jp      .checkSize

; =========================================================
; Input:
;   HL - block address
; Output:
;   HL - coalesced block address, not necessarily free
; =========================================================
Free
        call    GetMetadata

.coalesce
        ; return if block is top-level (size >= segment.bitSize)
        ld      a, (segment.bitSize)
        cp      b
        ret     z

        _GetSiblingBlock
        ld      c, (hl)        ; c = sibling block header

        ; return if sibling block is not free
        bit     ALLOCATED_BIT, c
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

; ------------------------------------------------------
; Input:
;   A - bit size, 0..15
; Output:
;   DE - size
; =========================================================
GetSize
        ld      h, high .table
        ld      l, low .table
        rlca
        or      l
        ld      l, a
        ldi     de, (hl)
        ret

        align   16 * 2
.table
        dw      %0000000000000010
        dw      %0000000000000100
        dw      %0000000000001000
        dw      %0000000000010000
        dw      %0000000000100000
        dw      %0000000001000000
        dw      %0000000010000000
        dw      %0000000100000000
        dw      %0000001000000000
        dw      %0000010000000000
        dw      %0000100000000000
        dw      %0001000000000000
        dw      %0010000000000000
        dw      %0100000000000000
        dw      %1000000000000000
        dw      %0000000000000000

        endmodule

        endif
