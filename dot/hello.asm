        device  zxspectrumnext
        org     $2000

        call    Dot.Init

        ld      a, 'H'
        rst     $10
        ld      a, 'e'
        rst     $10
        ld      a, 'l'
        rst     $10
        ld      a, 'l'
        rst     $10
        ld      a, 'o'
        rst     $10

        jp      Dot.Exit

        include dot.asm

        savebin "built/dot/hello", $2000, $-$2000
