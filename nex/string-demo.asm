        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include string.asm
        include writer.asm

Main
        call    Terminal.Init

        ld      hl, string.hello1
        ld      de, string.hello2
        call    CompareStrings

        ld      hl, string.hello1
        ld      de, string.helloWorld
        call    CompareStrings

        ld      hl, string.hello1
        ld      de, string.hemroids
        call    CompareStrings

        ld      hl, string.hello1
        ld      bc, 10
        call    CopyString

        ld      hl, string.helloWorld
        ld      bc, 13
        call    CopyString

        ld      hl, string.helloWorld
        ld      bc, 14
        call    CopyString

.end    jp      .end

; HL, DE - strings to compare
CompareStrings
        push    hl
        push    de

        push    hl
        push    de
        WriteString "Comparing \""
        pop     hl
        call    Writer.String
        WriteString "\" with \""
        pop     hl
        call    Writer.String
        WriteString "\" ... "

        pop     de
        pop     hl
        call    String.Equal
        jp      nz, .notEqual

        WritelnString "equal"
        ret

.notEqual
        WritelnString "not equal"
        ret

; HL - string to copy
; BC - max size
CopyString
        push    hl, bc

        push    bc, hl
        WriteString "Copying \""
        pop     hl
        call    Writer.String
        WriteString "\" (max "
        pop     hl
        call    Writer.Hex16h
        WriteString " bytes)... "

        pop     bc, hl

        ld      de, string.buffer
        call    String.CopyN
        jr      c, .partial
.complete
        WriteString " complete: \""
        jr      .writeCopied
.partial
        WriteString " partial: \""
.writeCopied
        ld      hl, string.buffer
        call    Writer.String
        WritelnString "\""
        ret

string
.hello1       dz "Hello"
.hello2       dz "Hello"
.helloWorld   dz "Hello, world!"
.hemroids     dz "Hemroids"
.buffer       dz "--------------------"


        savenex open "built/string-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/string-demo.map"
