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

leftWidth               dw
rightWidth              dw
topHeight               dw
bottomHeight            dw
        ends

        assert (NinePatch & 1) = 0

        endif
