        ifndef  UIPattern_asm
        define  UIPattern_asm

        include size.asm

        struct  UIPattern
bank    db      0
addr    dw      0
size    UISize  { 0, 0 }
stride  dw      0
        ends

        endif
