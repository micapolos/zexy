        ifndef  Keyboard_asm
        define  Keyboard_asm

        include port.asm
        include reg.asm

        struct  Keyboard
rows    block   10
ext     block   2
        ends

        module  Keyboard

; Input
;   HL - Keyboard ptr
; Output
;   HL - advanced
Read
        ; Read rows
        ld      c, $fe
        ld      b, 8
.rowsLoop
        ld      a, c
        rrca
        ld      c, a
        in      ($fe)
        cpl
        and     %00011111
        ld      (hl), a
        inc     hl
        djnz    .rowsLoop

        ; Read extended keys
        ld      bc, Port.ACTIVE_REG
        out     (c), a
        inc     b

        ; Extended row 1
        ld      a, Reg.EXT_KEYS_0
        in      a, (c)
        ld      (hl), a
        inc     hl

        ; Extended row 2
        ld      a, Reg.EXT_KEYS_0
        in      a, (c)
        ld      (hl), a
        inc     hl

        ret

        endmodule

        endif
