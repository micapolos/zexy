PROCESS_COUNT   equ     4
STACK_SIZE      equ     $100

        device  zxspectrumnext

        org     $8000

        include int-table.asm
        include nextreg.asm
        include scheduler.asm
        include tilebuffer.asm
        include printer.asm
        include palette.asm
        include color.asm
        include debug.asm

Main
        nextreg NextReg.CPU_SPEED, 3
        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg $68, %10000000  ; Disable ULA output

        call    InitTilemapPalette
        call    Scheduler.Init

        ld      de, stackTable
        ld      b, PROCESS_COUNT
        ld      a, 0
.launchLoop
        add     de, STACK_SIZE

        push    af
        push    bc
        push    de

        ld      bc, Process.entry
        call    Scheduler.Launch

        pop     de
        pop     bc
        pop     af

        inc     a

        djnz    .launchLoop

.mainLoop
        jp      .mainLoop

InitTilemapPalette
        ld      hl, textPalette
        ld      de, tilemapPalette
        call    Palette.InitText

        nextreg $43, %00110000  ; tilemap 1-st palette for write, auto-increment
        nextreg $40, 0          ; start palette index = 0

        ld      hl, tilemapPalette
        ld      b, 0
        call    Palette.Load9Bit
        ret

screenTilebuffer
screenPrinter
        Printer { { tileMap, { 32, 80 }, 0 } }

Process
.entry
.loop
        push    af
        push    af
        ld      ix, screenPrinter
        rlca : rlca : rlca : rlca : rlca
        and     %11100000
        or      %10000110
        ld      (ix + Printer.attr), a
        pop     af
        add     a, '0'

        ; TODO: Implement mutex instead of disabling and enabling interrupts.
        di
        call    Printer.Put
        ei

        pop     af

        push    af
        ld      b, a
        add     bc, $800
        call    Debug.Wait
        pop     af

        jp      .loop

stackTable
        dup     PROCESS_COUNT
        ds      STACK_SIZE
        edup

tilemapPalette
        ds      256 * 2

textPalette
        ; normal palette
        RGB_333         0, 0, 0
        RGB_333         0, 0, 3
        RGB_333         0, 3, 0
        RGB_333         0, 3, 3
        RGB_333         3, 0, 0
        RGB_333         3, 0, 3
        RGB_333         3, 3, 0
        RGB_333         3, 3, 3

        ; bright palette
        RGB_333         0, 0, 0
        RGB_333         0, 0, 7
        RGB_333         0, 7, 0
        RGB_333         0, 7, 7
        RGB_333         7, 0, 0
        RGB_333         7, 0, 7
        RGB_333         7, 7, 0
        RGB_333         7, 7, 7

        org $4000

tileMap:
        ds      80 * 32 * 2

tileDefs:
        include topaz-8.asm

        savenex         open "sandbox/terminals.nex", Main, $bfe0
        savenex         auto
        savenex         close
        cspectmap       "sandbox/terminals.map"
