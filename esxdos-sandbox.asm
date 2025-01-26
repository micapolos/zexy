        device  zxspectrumnext

        org     $8000
main
        ld      a, '*'
        ld      ix, filename
        ld      b, $01
        rst     $08
        db      $9a
        break

filename
        dz      "tbblue.fw"

        savenex open "esxdos-sandbox.nex", main, $bfe0
        savenex auto
        savenex close
