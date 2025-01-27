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
        jp      z, .dirEmpty

        ld      hl, .dirBuffer
        push    hl

        ld      a, (hl)
        call    Printer.PrintHex8
        ld      a, ' '
        call    Printer.Put

        pop     hl
        inc     hl
        call    Printer.Println

        ; TODO: Remove
        call    Raster.FrameWait
        call    Raster.FrameWait
        call    Raster.FrameWait

        jp      .loop

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
.dirBuffer              ds      260

        endmodule

        endif
