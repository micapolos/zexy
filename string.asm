        ifndef  String_asm
        define  String_asm

        module  String

; =========================================================
; Input
;   hl - string addr
;   iy - callback with each byte in A
; Output
;   hl - advanced string addr (after trailing 0)
ForEach
.loop
        ld      a, (hl)
        inc     hl
        and     a
        ret     z
        push    hl
        push    .continue
        jp      (iy)
.continue
        pop     hl
        jp      .loop

; =========================================================
; Input
;   hl - string addr
; Output
;   hl - advanced addr (after trailing 0)
Skip
.loop
        ldi     a, (hl)
        and     a
        jp      nz, .loop
        ret

        endmodule

        endif
