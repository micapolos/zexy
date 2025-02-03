        ifndef  ForEach_asm
        define  ForEach_asm

        include call.asm

        module  ForEach

; =========================================================
; Input
;   d - start
;   b - count
;   hl - callback
;     Input
;       d - current
;       b - count
;     Output
;       d, b - preserved
;   other - passed through callback
; Output
;   d - advanced
;   b - 0
;   other - passed through callback
dbhl
.loop
        calli   hl
        inc     c
        djnz    .loop
        ret

; =========================================================
; Input
;   h - start
;   c - count
;   iy - callback
;     Input
;       h - current
;       c - count
;     Output
;       h, c - preserved
;   other - passed through callback
; Output
;   h - advanced
;   c - 0
;   other - passed through callback
hciy
.loop
        calli   iy
        inc     h
        dec     c
        jp      nz, .loop
        ret

        endmodule

        endif
