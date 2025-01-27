        ifndef  CmdPwd_asm
        define  CmdPwd_asm

        include string.asm
        include printer.asm

        module  CmdPwd

errorString             dz      "Error getting current directory\n"
currentDirectoryString  dz      "Current directory: "
dirBuffer               ds      256

; Input:
;   ix - printer ptr
Exec
        ; open dir, A = dir handle
        ld      a, '*'
        ld      ix, dirBuffer
        rst     $08
        db      $a8
        jp      c, .error

        ld      hl, currentDirectoryString
        call    Printer.Print

        ld      hl, dirBuffer
        jp      Printer.Println
.error
        ld      hl, errorString
        jp      Printer.Println

        endmodule

        endif
