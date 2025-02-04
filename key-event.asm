        ifndef  KeyEvent_asm
        define  KeyEvent_asm

        struct  KeyEvent
; Key
key     db

; bit 7: 1 = keydown, 0 = keydown
; bit 6..3: unused 0
; bit 2..0: KeyModifier
flags   db
        ends

        module  KeyEvent

keyDown         equ     %10000000

        endmodule

        endif
