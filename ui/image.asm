        ifndef  UIImage_asm
        define  UIImage_asm

        include size.asm

        struct  UIImage
addr    dw      0
size    UISize  { 0, 0 }
stride  dw      0
        ends

        endif
