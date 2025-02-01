        ifndef  Writer_asm
        define  Writer_asm

        struct  Writer
target          dw
charProc        dw
        ends

        module  Writer

; =========================================================
; Input
;   ix - Writer ptr
;   a - char
Char
        push    ix

        ; hl = target
        ld      l, (ix + Writer.target)
        ld      h, (ix + Writer.target + 1)
        push    hl

        ; hl = proc
        ld      l, (ix + Writer.charProc)
        ld      h, (ix + Writer.charProc + 1)

        ; ix = target
        pop     ix

        ; call (hl)
        push    .ret
        jp      (hl)
.ret
        pop     ix
        ret

; =========================================================
; Input
;   ix - Writer ptr
NewLine
        ld      a, $0a
        jp      Char

; =========================================================
; Input
;   ix - Writer ptr
;   hl - null-terminated string
String
        push    iy
        ld      iy, Char
        call    String.ForEach
        pop     iy
        ret

; =========================================================
; Input
;   ix - Writer ptr
;   hl - null-terminated string
StringLine
        call    String
        jp      NewLine

; =========================================================
; Input
;   ix - Writer ptr
;   a - nibble in 0..3 bits
Nibble
        cp      $0a
        jp      c, .digit
        add     'A' - '9' + 1
.digit
        add     '0'
        jp      Char

; =========================================================
; Input
;   ix - Writer ptr
;   a - value
Hex8
        push    af
        swapnib
        and     $0f
        call    Nibble
        pop     af

        and     $0f
        jp      Nibble

; =========================================================
; Input
;   ix - Writer ptr
;   hl - value
Hex16
        push    hl
        ld      a, h
        call    Hex8
        pop     hl

        ld      a, l
        jp      Hex8

        endmodule

        endif
