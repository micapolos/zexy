        ifndef  SM_asm
        define  SM_asm

; SM = Stack Machine of 16-bit values.
; The top of the stack is stored in HL.
; Registers are not preserved between calls.

        ; Pushes constant value
        macro   SM_Const value
        push    hl
        ld      hl, value
        endm

        ; Pushes constant value MSB / LSB
        macro   SM_ConstNM msb, lsb
        push    hl
        ld      hl, (msb << 8) | lsb
        endm

        ; Push value reading it from the given address
        macro   SM_Read addr
        push    hl
        ld      hl, (addr)
        endm

        ; Pops value and writes to given addr
        macro   SM_Write addr
        ld      (addr), hl
        pop     hl
        endm

        ; Push byte value reading it from the given address
        macro   SM_Read8 addr
        push    hl
        ld      a, (addr)
        ld      h, 0
        ld      l, a
        endm

        ; Pops value, and writes LSB to given addr
        macro   SM_Write8 addr
        ld      a, l
        ld      (addr), a
        pop     hl
        endm

        ; Duplicates top value
        macro   SM_Dup
        push    hl
        endm

        ; Drops value from the top
        macro   SM_Drop
        pop     hl
        endm

        ; Increments top value
        macro   SM_Inc
        inc     hl
        endm

        ; Decrements top value
        macro   SM_Dec
        dec     hl
        endm

        ; Adds constant to the top value
        macro   SM_AddConst value
        add     hl, value
        endm

        ; Subtracts constant from the top value
        macro   SM_SubConst value
        xor     a
        sub     hl, value
        endm

        ; Adds top value to the previous value
        macro   SM_Add
        pop     de
        add     hl, de
        endm

        ; Subtracts previous value from the top value
        macro   SM_Sub
        pop     de
        xor     a
        sbc     hl, de
        endm

        ; Call with no arguments, no return value
        macro   SM_Call addr
        push    hl
        call    addr
        pop     hl
        endm

        ; Calls with HL popped from the stack, no return value
        macro   SM_Call_HL addr
        call    addr
        pop     hl
        endm

        ; Calls with HL and DE popped from the stack, no return value
        macro   SM_Call_HLDE addr
        pop     de
        call    addr
        pop     hl
        endm

        ; Calls with HL, DE and BC popped from the stack, no return value
        macro   SM_Call_HLDEBC addr
        pop     de
        pop     bc
        call    addr
        pop     hl
        endm

        ; Calls with HL, DE, BC and AF popped from the stack, no return value
        macro   SM_Call_HLDEBCAF addr
        pop     de
        pop     bc
        pop     af
        call    addr
        pop     hl
        endm

        ; Call with no arguments, return value in HL
        macro   SM_Call_void_HL addr
        push    hl
        call    addr
        endm

        ; Calls with HL popped from the stack, return value in HL
        macro   SM_Call_HL_HL addr
        call    addr
        endm

        ; Calls with HL and DE popped from the stack, return value in HL
        macro   SM_Call_HLDE_HL addr
        pop     de
        call    addr
        endm

        ; Calls with HL, DE and BC popped from the stack, return value in HL
        macro   SM_Call_HLDEBC_HL addr
        pop     de
        pop     bc
        call    addr
        endm

        ; Calls with HL, DE, BC and AF popped from the stack, return value in HL
        macro   SM_Call_HLDEBCAF_HL addr
        pop     de
        pop     bc
        pop     af
        call    addr
        endm

        ; Calls with HL and DE popped from the stack, return values in HL, DE
        macro   SM_Call_HLDE_HLDE addr
        pop     de
        call    addr
        push    de
        endm

        ; Calls with HL, DE and BC popped from the stack, return values in HL, DE
        macro   SM_Call_HLDEBC_HLDEDE addr
        pop     de
        pop     bc
        call    addr
        push    de
        endm

        ; Calls with HL, DE, BC and AF popped from the stack, return values in HL, DE
        macro   SM_Call_HLDEBCAF_HLDE addr
        pop     de
        pop     bc
        pop     af
        call    addr
        push    de
        endm

        endif
