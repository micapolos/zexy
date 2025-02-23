        ifndef  UiMenu_asm
        define  UiMenu_asm

        struct  UIMenuBar
items   db
        ends

        struct  UIMenuBarItem
; bit 7..6: kind
;   00 - end of items
;   01 - separator
;   10 - label
;     bit 5: enabled
;     bits 4..3: unused
;     bits 2..0: key modifier
;       followed by
;
;   11 - unused
flags           db      0
labelStringPtr  dw      0
        ends

        struct  UIMenuItem
; bit 7..6: type
;   00 - label
flags   db
        ends

        struct  UIMenuItemSeparator
flags   db      %01000000
        ends

        struct  UIAction
; bits 7: enabled
; bit 6..4: unused, must be 0
; bit 3: key shortcut enabled
; bit 2..0: key modifier
flags           db      %00000000
key             db      0
label           dw      0
proc            dw      0
        ends

        endif
