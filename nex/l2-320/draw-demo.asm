        device  zxspectrumnext

        org     $8000

        include l2-320/draw.asm

Main
        call    L2_320_Draw.Init

        ld      hl, fill
        call    L2_320_Draw.DrawFill

        ld      hl, filledRect
        call    L2_320_Draw.DrawFilledRect

        ld      hl, patch
        call    L2_320_Draw.DrawPatch

        ld      hl, patchX
        call    L2_320_Draw.DrawPatchX
.loop
        jr      .loop

fill
        L2_320_Draw.Fill { $01 }

filledRect
        L2_320_Draw.FilledRect { 10, 10, 300, 236, $02 }

fg      equ     $ff
bg      equ     $72

patch
        L2_320_Draw.Patch { 20, 20, patchData, 7, 8, 10 }
patchX
        L2_320_Draw.PatchX { 30, 20, bg, patchData, 7, 8, 10 }

patchData
        db      fg, fg, fg, fg, fg, fg, fg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, fg, fg, fg, fg, fg, fg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, fg, fg, fg, fg, fg, fg, fg, 0, 0

        savenex open "built/l2-320/draw-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/l2-320/draw-demo.map"
