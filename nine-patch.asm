        ifndef  NinePatch_asm
        define  NinePatch_asm

; TODO: add support for transparent color

        struct  NinePatch
addr                    dw

; bits 7..2: unused, must be 0
; bit 1: enable transparent color
; bit 0: transparent middle
flags                   db

; transparent color (if enabled)
transparentColor        db

leftWidth               db      ; 0..16
rightWidth              db      ; 0..16
topHeight               db      ; 0..16
bottomHeight            db      ; 0..16
        ends

        assert (NinePatch & 1) = 0

        endif
