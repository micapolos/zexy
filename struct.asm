        ifndef  Struct_asm
        define  Struct_asm

        include stack.asm

        module  Struct

; =========================================================
; Input
;   hl - struct ptr
        macro   StructInc size
        dup     size
        inc     hl
        edup
        endm

; =========================================================
; Input
;   hl - struct ptr
        macro   StructDec size
        dup     size
        dec     hl
        edup
        endm

; =========================================================
; Input
;   hl - struct ptr
        macro   StructLd reg
        ld      reg, (hl)
        endm

; =========================================================
; Input
;   hl - struct ptr
        macro   StructLdi reg
        ldi     reg, (hl)
        endm

; =========================================================
; Input
;   ix - struct ptr
        macro   StructPush name
        ld      hl, ix
        ld      b, (name + 1) >> 1
        call    Stack.Push16
        endm

; =========================================================
; Input
;   ix - struct ptr
        macro   StructPop name
        ld      hl, ix
        ld      b, (name + 1) >> 1
        call    Stack.Pop16
        endm

; =========================================================
; Input
;   ix - struct ptr
        macro   StructPush_tail name
        ld      hl, ix
        ld      b, (name + 1) >> 1
        jp      Stack.Push16
        endm

; =========================================================
; Input
;   ix - struct ptr
        macro   StructPop_tail name
        ld      hl, ix
        ld      b, (name + 1) >> 1
        jp      Stack.Pop16
        endm

        endmodule

        endif
