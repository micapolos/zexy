        IFNDEF  RASTER_LIB
        DEFINE  RASTER_LIB

        INCLUDE nextreg.asm

        MODULE  Raster

; Output:
;   HL - current raster line (0..311)
Line:
.loop
        ; h = raster line MSB
        ld      a, $1e
        call    NextReg.Read
        ld      h, a

        ; l = raster line LSB
        ld      a, $1f
        call    NextReg.Read
        ld      l, a

        ; read MSB for the second time, and retry if it changed
        ld      a, $1e
        call    NextReg.Read
        cp      h
        jp      nz, .loop

        ret

; Input:
;   DE - raster line (0..311)
WaitUntilLine
        push    hl
.loop
        call    Line

        ld      a, h
        cp      d
        jp      nz, .loop

        ld      a, l
        cp      e
        jp      nz, .loop

        pop     hl
        ret

WaitFrameOut
        push    de
        ld      de, 223
        call    WaitUntilLine
        inc     de
        call    WaitUntilLine
        pop     de
        ret

        ENDMODULE
        ENDIF
