        ifndef  KeyTable_asm
        define  KeyTable_asm

        include port.asm
        include reg.asm

        struct  KeyLine
new     db      0
old     db      0
        ends

        struct  KeyTable
line0   KeyLine
line1   KeyLine
line2   KeyLine
line3   KeyLine
line4   KeyLine
line5   KeyLine
line6   KeyLine
line7   KeyLine
exLine0 KeyLine
exLine1 KeyLine
        ends

        module  KeyTable

; =========================================================
; Input
;   HL - KeyTable ptr
; Output
;   HL - advanced
Scan
        ; Read rows
        ld      bc, (~1 << 8) | Port.ULA
        ld      d, 8            ; row counter
.lineLoop
        rrc     b               ; key line
        in      a, (c)          ; read key state
        cpl                     ; invert: 1=pressed, 0=not pressed
        and     %00011111       ; mask-out unused bits
        call    .writeLine
        dec     d
        jp      nz, .lineLoop

        ; Read extended row 1
        ld      a, Reg.EXT_KEYS_0
        call    Reg.Read
        call    .writeLine

        ; Read extended row 2
        ld      a, Reg.EXT_KEYS_1
        call    Reg.Read
        jp      .writeLine

.writeLine
        ld      e, (hl)
        ldi     (hl), a
        ldi     (hl), e
        ret

; Input
;   hl - KeyTable ptr
;   bc - KeyCode
;   e - 0 = current, 1 - previous
; Output
;   nz - pressed, z - not pressed
GetKeyState
        ld      a, b
        rlca
        add     e
        add     hl, a
        ld      a, (hl)
        and     c
        ret

        endmodule

        endif
