        ifndef  SymbolTable_asm
        define  SymbolTable_asm

        include bank.asm
        include mmu.asm
        include string.asm

        module  SymbolTable

; Base address of symbol index table
indexBaseAddr   dw 0

; Number of free entries in the index
symbolsFree     dw 0

; Number of symbols already in the index
symbolCount     dw 0

; Next free address in the strings buffer
freeStringsAddr  dw 0

; Number of bytes free in the strings buffer
stringsBytesFree dw 0

; ======================================================
; Input
;   HL - zero-terminated string
; Output
;   FC - 0 = OK, 1 = error
;   HL - symbol index
FindSymbol
        ret

; ======================================================
; Input
;   HL - symbol index
; Output
;   HL - string
GetString
        ex      de, hl
        ld      hl, START_ADDR
        add     hl, de
        add     hl, de
        ldi     de, (hl)
        ex      de, hl
        ret

; ======================================================
; Input
;   HL - symbol index
;   DE - string index
; Output
;   FZ - 0 = equal, 1 = not equal
EqualToString
        push    de
        ex      de, hl
        call    GetString
        pop     de
        jp      String.Equal

; ======================================================
; Input
;   HL - string
; Output
;   FC - 0 = OK, 1 = out of memory
;   HL - symbol index
Insert
        TODO
        ret

        endmodule
        endif
