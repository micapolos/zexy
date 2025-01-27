        ifndef  CmdCat_asm
        define  CmdCat_asm

        include printer.asm

        module  CmdCat

; Input
;   ix - Printer ptr
;   hl - filename ptr
Exec
        ; open dir, A = dir handle
        push    ix              ; printer ptr
        ld      a, '$'          ; system dir
        ld      ix, hl          ; filename
        ld      b, $01          ; read
        rst     $08
        db      $9a             ; f_open
        pop     ix              ; printer ptr
        jr      c, .openError

.loop
        ; a - file handle
        push    af              ; file handle
        push    ix              ; printer ptr
        ld      ix, .buffer     ; buffer ptr
        ld      bc, $0100       ; size
        rst     $08
        db      $9d             ; f_read
        pop     ix              ; printer ptr
        push    af              ; read flag

        ld      a, b
        or      c
        jr      z, .emptyBufferCheckFlag

        ld      hl, .buffer
        call    PrintBuffer

.nonEmptyBufferCheckFlag
        pop     af              ; read flag
        jp      c, .closeAndError

        pop     af              ; file handle
        jp      .loop

.emptyBufferCheckFlag
        pop     af              ; read flag
        jp      c, .closeAndError
.eof
        pop     af              ; file handle

.close
        rst     $08
        db      $9b             ; f_close
        jr      c, .closeError
        ret

.closeAndError
        pop     af              ; file handle
        jp      .close

.openError
        ld      hl, .openErrorString
        jr      .error

.readError
        ld      hl, .readErrorString
        jr      .error

.closeError
        ld      hl, .closeErrorString
        jr      .error

.error
        ld      (ix + Printer.attr), %10000010
        call    Printer.Println
        ld      (ix + Printer.attr), %11100010
        ret

.buffer                     ds      256
.openErrorString            dz      "Error opening file"
.readErrorString            dz      "Error reading file"
.closeErrorString           dz      "Error closing file"

; Input
;   ix - printer ptr
;   hl - addr
;   bc - count
PrintBuffer
        ld      a, (hl)
        inc     hl
        dec     bc
        push    hl
        push    bc
        call    Printer.Put
        pop     bc
        pop     hl
        ld      a, b
        or      c
        jr      nz, PrintBuffer
        ret

        endmodule

        endif
