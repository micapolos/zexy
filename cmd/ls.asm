        ifndef  CmdLs_asm
        define  CmdLs_asm

        include string.asm
        include writer.asm

        module  CmdLs

; Input
;   ix - Writer ptr
Exec
        ; open dir, A = dir handle
        push    ix
        ld      a, '*'          ; current dir
        ld      ix, .dirString
        ld      bc, $1000       ; lfn
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
        ret

.dirEntryError
        ld      hl, .dirEntryErrorString
        jp      Writer.StringLine

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
