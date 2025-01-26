        ifndef  String_asm
        define  String_asm

        module  String

; Input
;   hl - string addr
;   iy - callback with each byte in A
; Output
;   hl - advanced string addr
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

        endmodule

        endif
