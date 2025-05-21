        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include string-area-16k.asm
        include writer.asm

BANK_0  equ $50
BANK_1  equ $51
SIZE    equ $100

Main
        call    Terminal.Init

        ld      hl, StringArea16k.bank0
        ld      (hl), BANK_0

        ld      hl, StringArea16k.bank1
        ld      (hl), BANK_1

        ld      hl, StringArea16k.bytesFree
        ld      bc, SIZE
        ld      (hl), bc

        call    StringArea16k.PageIn

.loop
        call    InsertString
        jp      nc, .loop

.end    jr      .end

InsertString
        WriteString "Inserting string "
        ld      hl, (string.count)
        inc     hl
        call    Writer.Hex16
        WriteString "... "

        ld      hl, string.hello
        call    StringArea16k.Insert

        push    af
        push    hl
        WriteString "done (addr: "
        pop     hl
        call    Writer.Hex16h
        WriteString ") "
        pop     af

        jr      c, .error
.ok
        ld      hl, (string.count)
        inc     hl
        ld      (string.count), hl

        WritelnString "OK"
        or      a
        ret
.error
        WritelnString "out of memory!"
        scf
        ret

string
.count  dw      0
.hello  dz      "Hello, world!"

        savenex open "built/string-area-16k-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/string-area-16k-demo.map"
