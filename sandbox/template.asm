        device  zxspectrumnext

        org     $8000

Main
        ret

        savenex open "built/sandbox/template.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/sandbox/template.map"
