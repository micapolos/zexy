        ifndef  UIFrame_asm
        define  UIFrame_asm

        include ui/coord.asm
        include ui/size.asm

        struct  UIFrame
origin  UICoord
size    UISize
        ends

        endif
