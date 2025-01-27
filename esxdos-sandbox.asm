        device  zxspectrumnext

        org     $8000

main
        ld      a, '*'
        ld      ix, filename
        ld      b, $01
        rst     $08
        db      $9a  ; f_open
        ;db      $a3  ; f_opendir
        break

filename        dz      "/tbblue.fw"
stat            ds      11

        savenex open "esxdos-sandbox.nex", main, $bfe0
        savenex auto
        savenex close
