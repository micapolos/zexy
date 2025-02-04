        ifndef  Keyboard_asm
        define  Keyboard_asm

        include port.asm
        include reg.asm
        include key-modifier.asm

        module  Keyboard

; Output
;   a - KeyModifier
GetModifier
        ; Caps shift
        ld      bc, ($fe << 8) | Port.ULA
        in      a, (c)
        cpl
        and     %00000001
        ld      d, a

        ; Symbol shift
        ld      b, $7e
        in      a, (c)
        cpl
        and     %00000010
        or      d
        ld      d, a

        ; Extend
        ld      a, Reg.EXT_KEYS_1
        call    Reg.Read
        and     %00000001
        rlca
        rlca
        or      d

        ret

        endmodule

        endif
