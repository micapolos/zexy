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
        call    Blit.CopyLineStride256
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
        ld      bc, 3
        exx
        call    Blit.CopyLinesStride256

        ; 3-patch opaque
        ld      hl, a3patch
        ld      de, $e030
        ld      bc, $3210
        ld      a, %11110000
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine

        ; 3-patch transparent
        ld      hl, a3patch
        ld      de, $f030
        ld      bc, $3210
        ld      a, %11110000
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        ld      a, %11010000
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLineRepeat
        call    Blit.Copy3PatchLine
        ld      a, %11110000
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine

        ; 9-patch
        ld      hl, a3patch
        ld      de, $e050       ; start address
        ld      bc, $3210       ; top bottom middle
        ld      a, %11111101    ; enable: top, bottom, opaque, middle, left, right, 8-bit length, right
        exx
        ld      bc, $4260       ; left right middle
        exx
        call    Blit.Copy9Patch

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

a3patch db      $12, $12, $12, $12, $12, $12
        db      $12, $ee, $ee, $ee, $ee, $12
        db      $12, $12, $12, $12, $12, $12
        db      $12, $ff, $ff, $ff, $ff, $12
        db      $12, $ff, $56, $45, $ff, $12
        db      $12, $ff, $ff, $ff, $ff, $12
        db      $12, $12, $12, $12, $12, $12

        savenex open "built/blit-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/blit-demo.map"
