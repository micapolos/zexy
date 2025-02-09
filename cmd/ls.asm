        ifndef  CmdLs_asm
        define  CmdLs_asm

        include string.asm
        include writer.asm
        include esxdos.asm

        module  CmdLs

; Input
Exec
        ; open dir, A = dir handle
        ld      a, '*'          ; current dir
        ld      ix, .dirString
        ld      bc, $1000       ; lfn
        rst     $08
        db      EsxDOS.openDir
        jp      c, .error
        ld      (.fileHandle), a

.loop
        ld      a, (.fileHandle)
        ld      ix, .dirBuffer
        rst     $08
        db      EsxDOS.readDir
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
        call    Writer.String
        pop     hl

        push    hl
        call    String.Skip     ; skip filename
        ld      a, 4
        add     hl, a           ; skip time/date
        ldi     de, (hl)
        ldi     bc, (hl)        ; bcde - filesize
        call    Writer.Hex32h

        ld      a, ' '
        call    Writer.Char
        ld      a, ' '
        call    Writer.Char

        pop     hl
        call    Writer.StringLine

        jp      .loop

.dirDone
        ld      a, (.fileHandle)
        rst     $08
        db      EsxDOS.close
        ret

.dirEntryError
        ld      hl, .dirEntryErrorString
        call    Writer.StringLine
        jp      .dirDone

.dirEmpty
        ld      hl, .dirEmptyString
        jp      Writer.StringLine

.error
        ld      hl, .errorString
        jp      Writer.StringLine

.fileHandle             db      0
.errorString            dz      "Error opening directory\n"
.okString               dz      "Directory opened\n"
.dirEmptyString         dz      "Directory empty\n"
.dirEntryErrorString    dz      "Error reading directory entry\n"
.dirString              dz      "."
.dirEntryString         dz      "<DIR> "
.fileEntryString        dz      "      "
.dirBuffer              ds      260
.fileCount              db      0
.dirCount               db      0

        endmodule

        endif
