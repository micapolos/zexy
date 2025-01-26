        ifndef  CmdLs_asm
        define  CmdLs_asm

        include string.asm

        module  CmdLs

errorString             dz      "Error opening directory\n"
okString                dz      "Directory opened\n"
dirEmptyString          dz      "Directory empty\n"
dirEntryErrorString     dz      "Error reading directory entry\n"
dirString           dz      "c:/apps"
wildcardString          dz      "*"
dirBuffer               ds      256

Exec
        push    iy

        ; open dir, A = dir handle
        ld      a, '*'
        ld      ix, homeDirString
        ld      bc, $0000
        ld      de, wildcardString
        rst     $08
        db      $a3
        jp      c, .error

        ld      ix, dirBuffer
        rst     $08
        db      $a4
        jp      c, .dirEntryError

        and     a
        jp      z, .dirEmpty

        ld      hl, dirBuffer
        jp      .print

.dirEntryError
        ld      hl, dirEntryErrorString
        jp      .print

.dirEmpty
        ld      hl, dirEmptyString
        jp      .print

.error
        ld      hl, errorString

.print
        ld      iy, $0010
        call    String.ForEach

        pop     iy
        ret

        endmodule

        endif
