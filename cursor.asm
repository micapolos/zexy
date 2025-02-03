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
        ld      (hl), c
        inc     hl
        ld      (hl), 0
        inc     hl
        ld      (hl), 0
        inc     hl
        ld      (hl), 0
        inc     hl
        ld      (hl), 0
        inc     hl
        ret

; =========================================================
; Input
;   hl - Cursor ptr
; Output
;   hl - advanced Cursor ptr
Update
                                        ; (hl) = blinkPeriod
        ld      c, (hl)                 ; c = blinkPeriod
        inc     hl                      ; (hl) = blinkCounter
        ld      b, (hl)                 ; b = blinkCounter
        inc     hl                      ; (hl) = flags
        ld      a, (hl)                 ; a = flags
        dec     hl                      ; hl = blinkCounter

        dec     b                       ; b = decremented blinkCounter
        jp      ns, .blinkCounterOk
        ld      b, c                    ; reset b to blinkPeriod
        xor     flag.visible            ; invert visible flag

.blinkCounterOk
        ld      (hl), b                 ; save blinkCounter
        inc     hl                      ; (hl) = flags
        ld      (hl), a                 ; save flags
        inc     hl                      ; (hl) = x
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
                                ; (hl) = blinkPeriod
        inc     hl              ; (hl) = blinkCounter
        ld      (hl), 0         ; reset blinkCounter
        inc     hl              ; (hl) = flags
        ld      (hl), b         ; save xMsb without any flags
        inc     hl
        ld      (hl), c         ; save x
        inc     hl              ; (hl) = y
        ld      (hl), e         ; save y
        inc     hl              ; hl = advanced
        ret

        endmodule

        endif
