        ifndef  String_asm
        define  String_asm

        include call.asm

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
        calli   iy
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

; ======================================================
; Input
;   HL - string 1
;   DE - string 2
; Output
;   FZ - 0 = equal, 1 = not equal
;   HL, DE - advanced addr, after trailing 0 if equal, after non-equal char if not equal
Equal
.nextChar
        ld      a, (de)
        inc     de
        cp      (hl)
        inc     hl
        ret     nz
.charMatch
        cp      0
        ret     z
        jp      .nextChar

; ======================================================
; Input
;   HL - source string
;   DE - destination string
;   BC - max bytes, 0 = no limit
; Output
;   FC - 0 = OK, 1 = overflow
;   HL, DE, BC - advanced
CopyN
.nextChar
        ld      a, (hl)
        ldi
        cp      0
        jp      z, .complete
.checkOverflow
        ld      a, b
        or      c
        jp      nz, .nextChar
.overflow
        scf
        ret
.complete
        or      a  ; clear carry flag
        ret

        endmodule

        endif
