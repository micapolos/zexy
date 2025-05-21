        device  zxspectrumnext
        org     $2000

        jp      Main

        include dot.asm

Main    jp      Dot.Exit

        savebin "built/dot/template", $2000, $-$2000
