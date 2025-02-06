        ifndef  Struct_asm
        define  Struct_asm

        include stack.asm

        module  Struct

; =========================================================
; Input
;   hl - struct ptr
        macro   StructSkip name
        dup     name
        inc     hl
        edup
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
