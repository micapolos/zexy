        ifndef  CmdPwd_asm
        define  CmdPwd_asm

        include string.asm
        include writer.asm

        module  CmdPwd

errorString             dz      "Error getting current directory\n"
currentDirectoryString  dz      "Current directory: "
dirBuffer               ds      256

; Input:
;   ix - writer ptr
Exec
        ; open dir, A = dir handle
        ld      a, '*'
        ld      ix, dirBuffer
        rst     $08
        db      $a8
        jp      c, .error

        ld      hl, currentDirectoryString
        call    Writer.String

        ld      hl, dirBuffer
        jp      Writer.StringLine
.error
        ld      hl, errorString
        jp      Writer.StringLine

        endmodule

        endif
