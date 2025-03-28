        ifndef  CmdCat_asm
        define  CmdCat_asm

        include writer.asm
        include esxdos.asm

        module  CmdCat

; Input
;   hl - filename ptr
Exec
        ; open dir, A = dir handle
        ld      a, '$'          ; system dir
        ld      ix, hl          ; filename
        ld      b, $01          ; read
        rst     $08
        db      EsxDOS.open
        jr      c, .openError

.loop
        ; a - file handle
        push    af              ; file handle
        ld      ix, .buffer     ; buffer ptr
        ld      bc, $0100       ; size
        rst     $08
        db      EsxDOS.read
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
        db      EsxDOS.close
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
        jp      Writer.StringLine

.buffer                     ds      256
.openErrorString            dz      "Error opening file"
.readErrorString            dz      "Error reading file"
.closeErrorString           dz      "Error closing file"

; Input
;   hl - addr
;   bc - count
@PrintBuffer
        ld      a, (hl)
        inc     hl
        dec     bc
        push    hl
        push    bc
        call    Writer.Char
        pop     bc
        pop     hl
        ld      a, b
        or      c
        jr      nz, PrintBuffer
        ret

        endmodule

        endif
