        ifndef  MMU_asm
        define  MMU_asm

        include reg.asm

        module  MMU

; =========================================================
; Output
;   HL - banks in slots 7 and 6
Get_76
        ld      a, Reg.MMU_7
        call    Reg.Read
        ld      h, a
        ld      a, Reg.MMU_6
        call    Reg.Read
        ld      l, a
        ret

; =========================================================
; Output
;   HL - banks in slots 7 and 6
Set_76
        ld      a, h
        nextreg Reg.MMU_7, a
        ld      a, l
        nextreg Reg.MMU_6, a
        ret

; =========================================================
; Saves current 7 and 6 banks on the stack
Push_76
        call    Get_76    ; hl = current banks
        ex      hl, (sp)  ; hl = return adress, current banks on the stack
        jp      (hl)      ; return

; =========================================================
; Restore 7 and 6 banks from the stack
Pop_76
        ex      hl, (sp)  ; hl = return address
        pop     de        ; de = restored banks
        push    hl
        ex      de, hl    ; hl = restored banks
        jp      Set_76

        endmodule
        endif
