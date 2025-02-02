        ifndef  CmdPwd_asm
        define  CmdPwd_asm

        include string.asm
        include writer.asm
        include esxdos.asm

        module  CmdPwd

errorString             dz      "Error getting current drive and directory\n"
currentDirectoryString  dz      "Current directory: "
dirBuffer               ds      256

; Input:
;   ix - writer ptr
Exec
        ld      a, '*'
        push    ix
        ld      ix, dirBuffer
        rst     $08
        db      EsxDOS.getCwd
        pop     ix
        jp      c, .error

        ld      hl, dirBuffer
        jp      Writer.StringLine
.error
        ld      hl, errorString
        jp      Writer.StringLine

        endmodule

        endif
