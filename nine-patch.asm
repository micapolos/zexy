        ifndef  NinePatch_asm
        define  NinePatch_asm

        struct  NinePatch
; data address
addr                    dw

; bit 7: left enabled
; bit 6: middle enabled
; bit 5: middle transparent
; bit 4: right enabled
; bit 3: top enabled
; bit 2: middle enabled
; bit 1: middle height MSB (8-th bit)
; bit 0: bottom enabled
flags                   db

; bit 7..4: left width, 0 = 16
; bit 3..0: right width, 0 = 16
leftRightWidths         db

; middle width, 0 = 256
middleWidth             db

; bit 7..4: top height, 0 = 16
; bit 3..0: bottom height, 0 = 16
topBottomHeights        db

; middle height, 0 = 256
middleHeight
        ends

        endif
