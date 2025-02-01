        device  zxspectrumnext

        org     $8000

Main
        ret

        savenex open "built/template.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/template.map"
