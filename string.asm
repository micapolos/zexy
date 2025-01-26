        IFNDEF  String_asm
        DEFINE  String_asm

        MODULE  String

; Input
;   HL - string addr
;   IY - callback with each byte in A
; Output
;   HL - advanced string addr
ForEach
.loop
        ld      a, (hl)
        inc     hl
        and     a
        ret     z
        push    hl
        push    .continue
        jp      (IY)
.continue
        pop     hl
        jp      .loop

        ENDMODULE

        ENDIF
