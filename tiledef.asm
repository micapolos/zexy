        IFNDEF  TILEDEF_LIB
        DEFINE  TILEDEF_LIB

        MODULE  Tiledef

; Input:
;   HL = tiledef ptr
;   DE = bitmap ptr
;   C = color
;     bit 7-4: foreground
;     bit 3-0: background
; Output:
;   DE += 8
;   HL += 32
;   AF = ?
ConvertBitmap
        push    bc
        ld      b, 8
.loop
        ld      a, (de)
        inc     de
        call    ConvertByte
        djnz    .loop
        pop     bc
        ret

; Input:
;   A - byte
;   HL - dst
;   C - color
;     bit 7-4: foreground
;     bit 3-0: background
; Output:
;   HL - advanced 4 bytes
ConvertByte
        push    bc
        ld      b, 4
.loop
        call    ConvertBit
        call    ConvertBit
        inc     hl
        djnz    .loop
        pop     bc
        ret

; Input:
;   A - byte
;   HL - dst
;   C - color
;     bit 7-4: foreground
;     bit 3-0: background
; Output:
;   A - rotated left
;   (HL) - bits 0-3 shifted left, and color written
ConvertBit
        rlca
        push    af
        ld      a, c
        jp      nc, .background
        swapnib
.background
        rld
        pop     af
        ret

        ENDMODULE

        ENDIF
