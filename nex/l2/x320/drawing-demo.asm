        device  zxspectrumnext

        org     $8000

        include l2/x320/drawing.asm

Main
        call    L2.x320.Drawing.Init

        ld      hl, fill
        call    L2.x320.Drawing.DrawFill

        ld      hl, filledRect
        call    L2.x320.Drawing.DrawFilledRect

        ld      hl, patch
        call    L2.x320.Drawing.DrawPatch

        ld      hl, patchX
        call    L2.x320.Drawing.DrawPatchX
.loop
        jr      .loop

fill
        L2.x320.Drawing.Fill { $01 }

filledRect
        L2.x320.Drawing.FilledRect { 10, 10, 300, 236, $02 }

fg      equ     $ff
bg      equ     $72

patch
        L2.x320.Drawing.Patch { 20, 20, patchData, 7, 8, 10 }
patchX
        L2.x320.Drawing.PatchX { 30, 20, bg, patchData, 7, 8, 10 }

patchData
        db      fg, fg, fg, fg, fg, fg, fg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, fg, fg, fg, fg, fg, fg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, bg, fg, bg, bg, bg, bg, fg, 0, 0
        db      fg, fg, fg, fg, fg, fg, fg, fg, 0, 0

        savenex open "built/l2/x320/drawing-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/l2/x320/drawing-demo.map"
