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
;   hl - UIFrame ptr
; Output
;   hl - advanced
Write
        push    hl
        WriteStringAt string.name
        _putc '('
        pop     hl

        StructLdi de     ; de = x
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        _putc ','
        pop     hl

        StructLdi de     ; de = y
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        _putc ','
        pop     hl

        StructLdi de     ; de = width
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        _putc ','
        pop     hl

        StructLdi de     ; de = height
        push    hl
        ex      de, hl
        call    Writer.Hex16h
        _putc ')'
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
