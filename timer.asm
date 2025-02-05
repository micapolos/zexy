        ifndef  Timer_asm
        define  Timer_asm

        struct  Timer
counter         db      0
callback        dw      0
        ends

        module  Timer

; =========================================================
; Input
;   hl - Timer ptr
;   de - callback
Init
        ldi     (hl), 0
        ldi     (hl), de
        ret

; =========================================================
; Input
;   hl - Timer ptr
;   a - timeout
Start
        ldi     (hl), a
        inc     hl
        inc     hl
        ret

; =========================================================
; Input
;   hl - Timer ptr
Update
        ld      a, (hl)         ; a = counter
        or      a
        jp      z, .idle
        dec     a
        ldi     (hl), a         ; counter = a
        jp      nz, .noFire
.fire
        ldi     de, (hl)        ; de = callback
        push    hl              ; invoke callback
        ex      de, hl
        calli   hl
        pop     hl
        ret
.idle
        inc     hl              ; skip counter
.noFire
        inc     hl              ; skip callback
        inc     hl
        ret

        endmodule

        endif
