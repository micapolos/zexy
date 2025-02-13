        device  zxspectrumnext

        org     $8000

        include l2-320.asm

        lua allpass
        require("l2-320")
        endlua

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

        ; 3-patch opaque, line by line
        ld      hl, ninePatch
        ld      de, $e030
        ld      bc, $3210
        ld      a, %11010000
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine

        ; 3px space
        call    Blit.BankedIncD
        call    Blit.BankedIncD
        call    Blit.BankedIncD

        ; 3-patch opaque, repeated lines
        ld      hl, ninePatch
        exb
        ld      bc, 4
        exb
        call    Blit.Copy3PatchLines
        exb
        ld      bc, 7
        exb
        call    Blit.Copy3PatchLineRepeat
        exb
        ld      bc, 2
        exb
        call    Blit.Copy3PatchLines

        ; 3px space
        call    Blit.BankedIncD
        call    Blit.BankedIncD
        call    Blit.BankedIncD

        ; 3-patch transparent
        ld      hl, ninePatch
        ld      bc, $3210
        ld      a, %11010000
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine
        ld      a, %11110000
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLineRewind
        call    Blit.Copy3PatchLine
        ld      a, %11010000
        call    Blit.Copy3PatchLine
        call    Blit.Copy3PatchLine

        nextreg Reg.MMU_7, 18

        ; 9-patch
        ld      hl, ninePatch
        ld      de, $e050       ; start address
        ld      bc, $3208       ; top bottom middle
        ld      a, %11010000    ; enable: top, bottom, opaque, middle
        exx
        ld      bc, $4210       ; left right middle
        exx
        exa
        ld      a, %11010000    ; enable: left, right, 8-bit length, right
        exa
        call    Blit.Copy9Patch

        ; 9-patch wide
        ld      hl, ninePatch
        ld      de, $e060       ; start address
        ld      bc, $3208       ; top bottom middle
        ld      a, %11010000    ; enable: top, bottom, opaque, middle
        exx
        ld      bc, $4220       ; left right middle
        exx
        exa
        ld      a, %11110000    ; enable: left, right, 8-bit length, right
        exa
        call    Blit.Copy9Patch

        ; 9-patch wide transparent
        nextreg Reg.MMU_7, 18
        ld      hl, ninePatch
        ld      de, $e070       ; start address
        ld      bc, $3208       ; top bottom middle
        ld      a, %11110000    ; enable: top, bottom, transparent, middle
        exx
        ld      bc, $4220       ; left right middle
        exx
        exa
        ld      a, %11110000    ; enable: left, right, 8-bit length, right
        exa
        call    Blit.Copy9Patch

        ; 9-patch with macro
        nextreg Reg.MMU_7, 18
        BlitNinePatch ninePatch, $e080, 3, 8, 2, 4, $120, 2, 0

        ; 9-patch with lua
        lua allpass
        l2_320_draw_nine_patch("luaNinePatch", 10, 0xa0, 7, 6, 1)
        l2_320_draw_nine_patch("luaNinePatch", 20, 0xa0, 128, 16, 1)
        endlua

        ; vertical pattern line
        nextreg Reg.MMU_7, 27
        ld      hl, line
        ld      (Blit.PatternLine.repeatSrcAddr), hl
        ld      a, line.size
        ld      (Blit.PatternLine.repeatSrcSize), a
        ld      hl, line
        ld      c, line.size
        ld      de, $fe40
        ld      b, $40
        call    Blit.PatternLine

        ; ...advanced in same line
        ld      b, $40
        call    Blit.PatternLine

        ; ...advanced in next line
        ld      b, $80
        ld      de, $ff40
        call    Blit.PatternLine

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

ninePatch
        db      $12, $12, $12, $12, $12, $12
        db      $12, $ee, $ee, $ee, $ee, $12
        db      $12, $12, $12, $12, $12, $12
        db      $12, $ff, $ff, $ff, $ff, $12
        db      $12, $ff, $56, $45, $ff, $12
        db      $12, $ff, $ff, $ff, $ff, $12
        db      $12, $12, $12, $12, $12, $12

        lua allpass
        l2_320_nine_patch("luaNinePatch", 4, 3,
                "12121212121212",
                "12ee12ffffff12",
                "12ee12ff56ff12",
                "12ee12ff45ff12",
                "12ee12ffffff12",
                "12121212121212")
        endlua

line    dh      "0001020304050607"
.size   equ     $ - line

        savenex open "built/blit-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/blit-demo.map"
