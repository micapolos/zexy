        INCLUDE tilebuffer.asm

tilebuffer        Tilebuffer { $4000, { 32, 80 }, 0 }
subTilebuffer     Tilebuffer

TilebufferTest
        ld      ix, tilebuffer
        ld      iy, subTilebuffer
        ld      de, $0401
        ld      bc, $1004
        call    Tilebuffer.LoadSubFrame

        ld      a, (iy + Tilebuffer.addr)
        cp      0
        jp      nz, .error

        ld      a, (iy + Tilebuffer.addr + 1)
        cp      $40
        jp      nz, .error

        ld      a, (iy + Tilebuffer.size.height)
        cp      $04
        jp      nz, .error

        ld      a, (iy + Tilebuffer.size.width)
        cp      $10
        jp      nz, .error

        ld      a, (iy + Tilebuffer.stride)
        cp      $10
        jp      nz, .error
        ret

.error
        break
        ret
