        device  zxspectrumnext

        org     $8000

        include l2-320.asm

Main
        call    L2_320.Init
        nextreg Reg.MMU_7, 18

        ; Copy line by line
        ld      hl, line1
        ld      de, $e000
        ld      bc, $0208
        call    Blit.CopyLineStride256
        call    Blit.CopyLineStride256
        call    Blit.CopyLineStride256PreserveSrc
        call    Blit.CopyLineStride256PreserveSrc
        call    Blit.CopyLineStride256PreserveSrc
        call    Blit.CopyLineStride256PreserveSrc
        call    Blit.CopyLineStride256PreserveSrc
        call    Blit.CopyLineStride256
        call    Blit.CopyLineStride256

        ; Copy lines
        ld      hl, line1
        ld      de, $e010
        ld      bc, $0208
        exx
        ld      bc, 5
        exx
        call    Blit.CopyLinesStride256

        ; Copy lines
        ld      hl, line1
        ld      de, $e020
        ld      bc, $0208
        exx
        ld      bc, 2
        exx
        call    Blit.CopyLinesStride256

        exx
        ld      bc, 10
        exx
        call    Blit.CopyLineStride256Repeat

        exx
        ld      bc, 2
        exx
        call    Blit.CopyLinesStride256

        ; 3-patch
        ld      hl, a3patch
        ld      de, $e030
        ld      bc, $2208
        ld      a, %11100000
        call    Blit.Copy3PatchLine

.loop   jr      .loop

line1   db      $12, $12, $12, $12, $12, $12, $12, $12
.stride db      0, 0

line2   db      $12, $ff, $ff, $ff, $ff, $ff, $ff, $12
.stride db      0, 0

line3   db      $12, $ff, $44, $44, $44, $44, $ff, $12
.stride db      0, 0

line4   db      $12, $ff, $ff, $ff, $ff, $ff, $ff, $12
.stride db      0, 0

line5   db      $12, $12, $12, $12, $12, $12, $12, $12
.stride db      0, 0

a3patch db      $12, $ff, $44, $ff, $12

        savenex open "built/blit-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/blit-demo.map"
