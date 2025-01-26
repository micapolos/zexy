        ifndef  CmdPwd_asm
        define  CmdPwd_asm

        include string.asm

        module  CmdPwd

errorString             dz      "Error getting current directory\n"
currentDirectoryString  dz      "Current directory: "
dirBuffer               ds      256

Exec
        push    iy

        ; open dir, A = dir handle
        ld      a, '*'
        ld      ix, dirBuffer
        rst     $08
        db      $a8
        jp      c, .error

        ld      hl, currentDirectoryString
        ld      iy, $0010
        call    String.ForEach

        ld      hl, dirBuffer
        ld      iy, $0010
        call    String.ForEach

        ld      a, $0a
        rst     $10
        jp      .end

.error
        ld      hl, errorString

.print
        ld      iy, $0010
        call    String.ForEach

.end
        pop     iy
        ret

        endmodule

        endif
