        ifndef  UIFrameWriter_asm
        define  UIFrameWriter_asm

        include ui/frame.asm
        include ui/coord.asm
        include ui/size.asm
        include writer.asm
        include struct.asm

        module  UIFrameWriter

; =========================================================
; Input
;   ix - Writer ptr
;   hl - UIFrame ptr
; Output
;   hl - advanced
Write
        push    hl
        WriteStringAt string.name
        WriteChar '('
        pop     hl

        StructLdi de     ; de = x
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        WriteChar ','
        pop     hl

        StructLdi de     ; de = y
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        WriteChar ','
        pop     hl

        StructLdi de     ; de = width
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        WriteChar ','
        pop     hl

        StructLdi de     ; de = height
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        WriteChar ')'
        call    Writer.Char
        pop     hl

        ret

Writeln
        call    Write
        push    hl
        call    Writer.NewLine
        pop     hl
        ret

string
.name   dz      "UIFrame"

        endmodule

        endif
