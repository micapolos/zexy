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

.loop   jr      .loop

line1   db      $01, $01, $01, $01, $01, $01, $01, $01
.stride db      0, 0

line2   db      $01, $ff, $ff, $ff, $ff, $ff, $ff, $01
.stride db      0, 0

line3   db      $01, $ff, $44, $44, $44, $44, $ff, $01
.stride db      0, 0

line4   db      $01, $ff, $ff, $ff, $ff, $ff, $ff, $01
.stride db      0, 0

line5   db      $01, $01, $01, $01, $01, $01, $01, $01
.stride db      0, 0

        savenex open "built/blit-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/blit-demo.map"
