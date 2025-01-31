        ifndef  Video_asm
        define  Video_asm

        include reg.asm

        module Video

; Input
;   HL - number of scanlines in current video mode
; TODO: it only works on ZX Spectrum 48, and not 128
GetScanlines
        ld      a, Reg.PERIPH_1
        call    Reg.Read
        and     Reg.PERIPH_1.hz60
        jp      nz, .hz60
.hz50
        ld      hl, 312
        jp      .lineCountOk
.hz60
        ld      hl, 262
.lineCountOk
        ret

        endmodule

        endif
