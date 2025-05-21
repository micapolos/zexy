        ifndef  LD_asm
        define  LD_asm

        ; === ld ===

        macro   ld_cde_u24 u24
        ld      c, (u24) >> 16
        ld      de, (u24) & $ffff
        endm

        macro   ld_bcde_u32 u32
        ld      bc, (u32) >> 16
        ld      de, (u32) & $ffff
        endm

        ; === ldi ===

        macro   ldi_ihl_u8 u8
        ld      (hl), (u8)
        inc     hl
        endm

        macro   ldi_ihl_u16 u16
        ldi_ihl_u8 (u16) & $ff
        ldi_ihl_u8 (u16) >> 8
        endm

        macro   ldi_ihl_u24 u24
        ldi_ihl_u16 (u24) & $ffff
        ldi_ihl_u8 (u24) >> 16
        endm

        macro   ldi_ihl_u32 u32
        ldi_ihl_u16 (u32) & $ffff
        ldi_ihl_u16 (u32) >> 16
        endm

        macro   ldi_ihl_a
        ld      (hl), a
        inc     hl
        endm

        macro   ldi_ihl_de
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl
        endm

        macro   ldi_ihl_cde
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl
        ld      (hl), c
        inc     hl
        endm

        macro   ldi_ihl_bcde
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl
        ld      (hl), c
        inc     hl
        ld      (hl), b
        inc     hl
        endm

        macro   ldi_a_ihl
        ld      a, (hl)
        inc     hl
        endm

        macro   ldi_de_ihl
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        endm

        macro   ldi_cde_ihl
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      c, (hl)
        inc     hl
        endm

        macro   ldi_bcde_ihl
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        endm

        ; === ldd ===

        macro   ldd_ihl_u8 u8
        dec     hl
        ld      (hl), u8
        endm

        macro   ldd_ihl_u16 u16
        ldd_ihl_u8 (u16) >> 8
        ldd_ihl_u8 (u16) & $ff
        endm

        macro   ldd_ihl_u24 u24
        ldd_ihl_u8 (u24) >> 16
        ldd_ihl_u16 (u24) & $ffff
        endm

        macro   ldd_ihl_u32 u32
        ldd_ihl_u16 (u32) >> 16
        ldd_ihl_u16 (u32) & $ffff
        endm

        macro   ldd_ihl_a
        dec     hl
        ld      (hl), a
        endm

        macro   ldd_ihl_de
        dec     hl
        ld      (hl), d
        dec     hl
        ld      (hl), e
        endm

        macro   ldd_ihl_cde
        dec     hl
        ld      (hl), c
        dec     hl
        ld      (hl), d
        dec     hl
        ld      (hl), e
        endm

        macro   ldd_ihl_bcde
        dec     hl
        ld      (hl), b
        dec     hl
        ld      (hl), c
        dec     hl
        ld      (hl), d
        dec     hl
        ld      (hl), e
        endm

        macro   ldd_a_ihl
        dec     hl
        ld      a, (hl)
        endm

        macro   ldd_de_ihl
        dec     hl
        ld      d, (hl)
        dec     hl
        ld      e, (hl)
        endm

        macro   ldd_cde_ihl
        dec     hl
        ld      c, (hl)
        dec     hl
        ld      d, (hl)
        dec     hl
        ld      e, (hl)
        endm

        macro   ldd_bcde_ihl
        dec     hl
        ld      b, (hl)
        dec     hl
        ld      c, (hl)
        dec     hl
        ld      d, (hl)
        dec     hl
        ld      e, (hl)
        endm

        endif
