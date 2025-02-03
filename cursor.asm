        ifndef  Cursor_asm
        define  Cursor_asm

        struct  Cursor
blinkPeriod     db
blinkCounter    db
flags           db
x               db
y               db
        ends

        module  Cursor

flag
.visible        equ     %10000000
.xMsb           equ     %00000001

; =========================================================
; Input
;   hl - Cursor ptr
;   c - blink period
; Output
;   hl - advanced Cursor ptr
Init
        ldi      (hl), c
        ldi      (hl), 0
        ldi      (hl), 0
        ldi      (hl), 0
        ldi      (hl), 0
        ret

; =========================================================
; Input
;   hl - Cursor ptr
; Output
;   hl - advanced Cursor ptr
Update
                                        ; (hl) = blinkPeriod
        ldi     c, (hl)                 ; c = blinkPeriod
        ldi     b, (hl)                 ; b = blinkCounter
        ldd     a, (hl)                 ; a = flags

        dec     b                       ; b = decremented blinkCounter
        jp      ns, .blinkCounterOk
        ld      b, c                    ; reset b to blinkPeriod
        xor     flag.visible            ; invert visible flag

.blinkCounterOk
        ldi     (hl), b                 ; save blinkCounter
        ldi     (hl), a                 ; save flags
        inc     hl                      ; (hl) = y
        inc     hl                      ; hl = advanced
        ret

; =========================================================
; Input
;   hl - Cursor ptr
;   bc -
;     bits 15..9: unused, must be 0
;     bits 8..0: x coordinate
;   e - y coordinate
; Output
;    hl - advanced Cursor ptr
Move
        inc     hl              ; skip blinkPeriod
        ldi     (hl), 0         ; reset blinkCounter
        ldi     (hl), b         ; save xMsb without any flags
        ldi     (hl), c         ; save x
        ldi     (hl), e         ; save y
        ret

        endmodule

        endif
