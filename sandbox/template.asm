        device  zxspectrumnext

        org     $8000

Main
        ret

        savenex open "sandbox/template.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "sandbox/template.map"
