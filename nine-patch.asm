        ifndef  NinePatch_asm
        define  NinePatch_asm

; TODO: add support for transparent color

        struct  NinePatch
addr                    dw

; bit 1: 1 = enable transparent color, 0 = no transparent color
; bit 0: 1 = middle opaque, 0 = middle transparent
flags                   db
transparentColor        db
leftWidth               dw
middleWidth             dw
rightWidth              dw
topHeight               dw
middleHeight            dw
bottomHeight            dw
        ends

        assert (NinePatch & 1) = 0

        endif
