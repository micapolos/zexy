        device  zxspectrumnext
        org     $2000

        call    Dot.Init

        ld      hl, guruString
        jp      Dot.Error

guruString      dc "Guru meditation!"

        include dot.asm

        savebin "built/dot/error.demo", $2000, $-$2000
