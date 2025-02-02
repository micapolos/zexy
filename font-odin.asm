Font
.glyphs     DW   GlyphData
.flipGlyphs DW   GlyphFlipData
.widths     DW   GlyphWidths

; ------------------------------------
; Input:
;       HL = text address
; Output:
;       C = width
;       HL = advanced HL (after trailing 0)
GetTextWidth:
        LD   C, 0

        LD   A, (HL)
        INC  HL
        OR   A
        RET  Z

        DEC  HL
        DEC  C

; ------------------------------------
; Input:
;       HL = text address
;       C = initial width
; Output:
;       C = added width
;       HL = advanced text addr (after trailing 0)
AddTextWidth:
.loop
        LD   A, (HL)
        INC  HL
        OR   A
        RET  Z

        INC  C
        LD   DE, GlyphWidths
        ADD  DE, A
        LD   A, (DE)
        ADD  C
        LD   C, A
        JR   .loop

; ------------------------------------
; Input:
;       A = char
; Output
;       A = width
GetCharWidth:
        PUSH HL
        LD   HL, GlyphWidths
        ADD  HL, A
        LD   A, (HL)
        POP  HL
        RET

; ------------------------------------
; Input:
;       DE = src
;       HL = dst
; Output:
;       DE = advanced
;       BC = 0
;       AF = ?
GlyphFlipCopy
        LD   C, 8

.byteLoop
        PUSH HL
        LD   A, (DE)
        LD   B, 8

.bitsLoop
        RLCA
        RL   (HL)
        INC  HL
        DJNZ .bitsLoop
        POP  HL

        INC  DE
        DEC  C
        JR   NZ, .byteLoop

        RET

; ------------------------------------
; Input:
;       DE = src
;       HL = dst
;       B = count
; Output:
;       DE = advanced
;       HL = advanced
;       B = 0
;       AF = ?
GlyphsFlipCopy
.loop
        PUSH BC
        PUSH HL

        CALL GlyphFlipCopy

        POP  HL
        POP  BC

        ADD  HL, 8

        DJNZ .loop

        RET

; ------------------------------------
; Input:
;       B = color
;       HL = text address
;       DE = screen address
; Output:
;       HL = advanced text address (after trailing 0)
;       DE = advanced screen address
DrawText
        PUSH AF
.setLine
        LD   A, D
        CALL GrSetLine
        LD   D, A
.loop
        LD   A, (HL)
        INC  HL
        OR   A
        JR   Z, .end

        CALL BlitChar

        INC  E
        JR   .loop
.end
        POP  AF
        RET

; ------------------------------------
; Input:
;       A = char
;       B = color
;       DE = screen address
; Output:
;       DE = advanced screen address
DrawGlyph
        PUSH AF
        LD   A, D
        CALL GrSetLine
        LD   D, A
        POP  AF
        JP   BlitChar          ; tail call

; ------------------------------------
; Input:
;       A = char
;       B = color
;       DE = screen address
; Output:
;       DE = advanced screen address
BlitChar
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL

        ; C = glyph width
        LD   HL, GlyphWidths
        ADD  HL, A
        LD   C, (HL)

        ; HL = glyph address
        LD   H, 0
        LD   L, A
        ADD  HL, HL
        ADD  HL, HL
        ADD  HL, HL             ; HL = 8*char
        ADD  HL, GlyphData      ; HL = glyphData + 9 * char

        ; A = color
        LD   A, B

        ; B = height
        LD   B, 8

.nextLine
        PUSH BC                 ; save height and width

        LD   B, (HL)            ; load bits
        INC  HL

        INC  B                  ; skip bits if zero
        DEC  B
        JR   Z, .skipBits

        PUSH DE                 ; save screen address
.bitsLoop
        SLA  B
        JR   NC, .skipBit
        LD   (DE), A
.skipBit
        INC  DE
        DEC  C
        JR   NZ, .bitsLoop

        POP  DE                 ; restore screen address

.skipBits
        INC  D                  ; next screen line
        POP  BC                 ; restore height and width
        DEC  B                  ; decrement height
        JR   NZ, .nextLine

        POP  HL
        POP  DE

        LD   A, E               ; add width to DE
        ADD  C
        LD   E, A

        POP  BC
        POP  AF
        RET

; -------------------------------
; Input:
;       A = char
;       DE = dst addr
;       C = color
; Output:
;       AF, HL = ?
;       B = width
;       DE = advanced dst addr
BlitChar2
        ; B = width
        LD   HL, (Font.widths)
        ADD  HL, A
        LD   B, (HL)
        ; fall-through

; -------------------------------
; Input:
;       A = char
;       DE = dst addr
;       BC = width/color
; Output:
;       AF, HL = ?
;       B = width
;       DE = advanced dst addr
BlitCharW
        ; HL = glyph addr
        LD   HL, (Font.glyphs)

        ; This seems to be the fastest way
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A

        ; fall-through to BlitGlyph

; ------------------------------------
; Input:
;       HL = glyph addr
;       DE = dst addr
;       BC = width/color
; Output:
;       HL = next glyph addr
;       DE = advanced dst addr
;       AF = ?
BlitGlyph
        PUSH DE

.lineLoop
        PUSH DE
        PUSH BC

        ; A = glyph bits
        LD   A, (HL)

        OR   0
        JR   Z, .nextLine

        EX   DE, HL

.bitsLoop
        RLCA
        JR   NC, .bit1
        LD   (HL), C

.bit1
        INC  L
        DJNZ .bitsLoop
        EX   DE, HL

.nextLine
        POP  BC
        POP  DE

        INC  D
        INC  HL
        LD   A, L
        AND  %111
        JR   NZ, .lineLoop

        ; advance E
        POP  DE
        LD   A, E
        ADD  B
        INC  A
        LD   E, A

        RET

; ------------------------------------
; Input:
;       HL = addr after trailing 0
;       DE = dst addr
BlitText
.charLoop
        ; A = char
        LD   A, (HL)
        INC  HL
        OR   A
        RET  Z

        ; TODO: Need to flip banks, so use blt!!!

        PUSH HL
        CALL BlitChar2
        POP  HL

        JR   .charLoop

; ------------------------------------
; Input:
;       DE = dst addr
;       A = color
; Output:
;       DE = ?
;       B = 0
BlitSpacing
        LD   B, 8
.loop
        LD   (DE), A
        INC  D
        DJNZ .loop
        RET

; -------------------------------
; Input:
;       A = char
;       DE = dst addr
; Output:
;       AF, HL = ?
;       C = 0
;       DE = advanced dst addr
BlitCharFlip
        ; B = width
        LD   HL, (Font.widths)
        ADD  HL, A
        LD   C, (HL)

        ; HL = glyph addr
        LD   HL, (Font.flipGlyphs)

        ; This seems to be the fastest way
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A
        ADD  HL, A

        ; fall-through to BlitGlyph

; ------------------------------------
; Input:
;       HL = glyph addr
;       DE = dst addr
;       C = width
;       .color = color
;
; Output:
;       HL = ?
;       DE = advanced dst addr
;       BC = 0
;       AF = ?
BlitGlyphFlip
.color  EQU  .ldHLn + 1

        EX   DE, HL

.outerLoop
        LD   A, (DE)
        INC  DE

        LD   B, 8

        PUSH HL
.innerLoop
        RLCA
        JR   NC, .bitDone
.ldHLn
        LD   (HL), 1
.bitDone
        INC  HL
        DJNZ .innerLoop

        POP  HL
        INC  H

        DEC  C
        JR   NZ, .outerLoop

        INC  H

        EX   DE,HL
        RET

; ------------------------------------
; Input:
;       HL = addr after trailing 0
;       DE = dst addr
BlitTextFlip
.charLoop
        ; A = char
        LD   A, (HL)
        INC  HL
        OR   A
        RET  Z

        PUSH HL
        CALL BlitCharFlip
        POP  HL

        JR   .charLoop

; ------------------------------------
; Input:
;       A = index
; Output:
;       HL = char data address
GetGlyphAddress
        LD   H, 0
        LD   L, A
        ADD  HL, HL
        ADD  HL, HL
        ADD  HL, HL             ; HL = 8*char
        ADD  HL, GlyphData      ; HL = glyphData + 9 * char
        RET

GlyphDataAlign8
        DS   7 - (GlyphDataAlign8 - 1) & 7
