        IFNDEF  String_asm
        DEFINE  String_asm

        MODULE  String

; Input
;   DE - string addr
;   HL - callback with each byte in A
; Output
;   DE - advanced string addr
ForEach
.loop
        ld      a, (de)
        inc     de
        and     a
        ret     z
        push    de
        push    hl
        push    .continue
        jp      (hl)
.continue
        pop     hl
        pop     de
        jp      .loop

        ENDMODULE

        ENDIF
