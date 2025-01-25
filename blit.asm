        IFNDEF  BLIT_LIB
        DEFINE  BLIT_LIB

        MODULE  Blit

; Input:
;   hl - addr
;   de - value
; Output:
;   hl - advanced addr
Put16:
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl
        ret

; Input:
;   hl - address
;   bc - width, height
;   de - value
;   a - stride
; Output:
;   hl - end address
;   bc - width, 0
FillRect16:
.loop
        push    bc
.rowLoop
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl
        djnz    .rowLoop

        add     hl, a
        add     hl, a

        pop     bc
        dec     c
        jp      nz, .loop

        ret

        MACRO   MAKE_COPY_RECT_8  name, ldi_instr, add_instr
; Input:
;   HL - src start
;   DE - dst start
;   BC - width / height
;   IXh - src stride
;   IXl - dst stride
; Output:
;   HL - src end
;   DE - dst end
;   BC - ?
name
        push    af
.nextRow
        push    bc
        ld      a, b
.nextCell
        ldi
        inc     bc
        djnz    .nextCell
        pop     bc
        ld      b, a

        ld      a, ixh
        add     hl, a
        ld      a, ixl
        add     de, a

        dec     c
        jp      nz, .nextRow

        pop     af
        ret
        ENDM

        MAKE_COPY_RECT_8 CopyRect8Inc, ldi, add
        MAKE_COPY_RECT_8 CopyRect8Dec, ldd, sub

; Input:
;   HL - src start
;   DE - dst start
;   BC - width / height
;   IXh - src stride
;   IXl - dst stride
;   FC - 0 = inc, 1 = dec
; Output:
;   HL - src end
;   DE - dst end
;   BC - ?
CopyRect8
        jp      nc, CopyRect8Inc
        jp      CopyRect8Dec

        ENDMODULE

        ENDIF
