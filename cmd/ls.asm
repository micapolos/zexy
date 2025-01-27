        ifndef  CmdLs_asm
        define  CmdLs_asm

        include string.asm
        include printer.asm
        include raster.asm   ; TODO: Remove

        module  CmdLs

; Input
;   ix - Printer ptr
Exec
        ; open dir, A = dir handle
        push    ix
        ld      a, '$'          ; system dir
        ld      ix, .dirString
        ld      b, $01          ; ???
        rst     $08
        db      $a3
        pop     ix
        jp      c, .error
        ld      (.fileHandle), a

.loop
        push    ix
        ld      a, (.fileHandle)
        ld      ix, .dirBuffer
        rst     $08
        db      $a4
        pop     ix
        jp      c, .dirEntryError

        and     a
        jp      z, .dirDone

        ld      hl, .dirBuffer

        ld      a, (hl)
        inc     hl
        push    hl

        and     $10
        jp      z, .incFileCount
        ld      hl, .dirCount
        jp      .inc
.incFileCount
        ld      hl, .fileCount
.inc
        inc     (hl)

        and     $10
        jp      z, .printFileEntry
        ld      hl, .dirEntryString
        jp      .printEntry
.printFileEntry
        ld      hl, .fileEntryString
.printEntry
        call    Printer.Print

        pop     hl
        call    Printer.Println

        ; TODO: Remove
        call    Raster.FrameWait
        call    Raster.FrameWait
        call    Raster.FrameWait

        jp      .loop

.dirDone
        ld      hl, .fileCountString
        call    Printer.Print
        ld      a, (.fileCount)
        call    Printer.PrintHex8
        call    Printer.NewLine

        ld      hl, .dirCountString
        call    Printer.Print
        ld      a, (.dirCount)
        call    Printer.PrintHex8
        call    Printer.NewLine
        ret

.dirEntryError
        ld      hl, .dirEntryErrorString
        jp      Printer.Println

.dirEmpty
        ld      hl, .dirEmptyString
        jp      Printer.Println

.error
        ld      hl, .errorString
        jp      Printer.Println

.fileHandle             db      0
.errorString            dz      "Error opening directory\n"
.okString               dz      "Directory opened\n"
.dirEmptyString         dz      "Directory empty\n"
.dirEntryErrorString    dz      "Error reading directory entry\n"
.dirString              dz      "/cmd"
.fileCountString        dz      "File count: "
.dirCountString         dz      "Directory count: "
.dirEntryString         dz      "<DIR> "
.fileEntryString        dz      "      "
.dirBuffer              ds      260
.fileCount              db      0
.dirCount               db      0

        endmodule

        endif
