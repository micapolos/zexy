        ifndef  UIAlignment_asm
        define  UIAlignment_asm

        include ui/frame.asm

        module  UIAlignment

left            equ     %00000000
right           equ     %00000001
top             equ     %00000000
bottom          equ     %00000010

; Input
;   hl - start
;   de - size
;   bc - value
;   a - bit 0: axis alignment
; Output
;   hl - aligned value
;   a - preserved
AlignValue
        test    %00000001
        jp      z, .start
.end
        add     hl, de
        scf
        sbc     hl, bc
        ret
.start
        add     hl, bc
        ret

; =========================================================
; Input
;   hl - UIFrame ptr
;   de - x
;   bc - y
;   a - UIAlignment
; Output
;   hl - advanced
;   de - aligned x
;   bc - aligned y
AlignXY
        push      hl            ; (hl) = UIFrame
        push      bc            ; push y

        StructLdi bc            ; bc = UIFrame.x
        push      bc            ; push UIFrame.x
        StructInc 2             ; skip UIFrame.y
        StructLdi bc            ; de = UIFrame.width
        ld        hl, bc        ; hl = UIFrame.x
        call      AlignValue    ; bc = aligned x
        ld        de, bc        ; de = aligned x

        pop       bc            ; bc = y
        pop       hl            ; (hl) = UIFrame

        push      de            ; push aligned x

        StructInc 2             ; skip UIFrame.x
        StructLdi de            ; de = UIFrame.y
        StructInc 2             ; skip UIFrame.width
        StructLdi de            ; de = UIFrame.height
        push      hl            ; push advanced hl
        ld        hl, bc        ; hl = y
        call      AlignValue    ; bc = aligned y

        pop       hl            ; hl = advanced
        pop       de            ; de = aligned x
        ret

        endmodule

        endif
