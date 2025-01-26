        ifndef  Raster_asm
        define  Raster_asm

        include nextreg.asm

        module  Raster

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
LineWait
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

FrameWait
        push    de
        ld      de, 223
        call    LineWait
        inc     de
        call    LineWait
        pop     de
        ret

        endmodule
        endif
