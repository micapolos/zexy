        device  zxspectrumnext
        org     $2000

        jp      Main

        include dot.asm

Main
        call    Dot.Init

        ld      b, 30
.loop
        push    bc
        _write "Odliczam "
        pop     bc

        ld      a, b
        push    bc
        call    Writer.Hex8
        _writeln " do zera..."
        pop     bc

        djnz    .loop

        _writeln "Koniec!!! Do widzenia."

        jp      Dot.Exit

        savebin "built/dot/string.demo", $2000, $-$2000
