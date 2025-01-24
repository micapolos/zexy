  DEVICE ZXSPECTRUMNEXT

BAR EQU 384

CHAR_COUNT  EQU   96

  ORG $c000

  INCLUDE blit.asm
  INCLUDE surface.asm

screen:   Surface { $5020, tileMap }

main:
  di

  nextreg $07, 3  ; 28MHz clock
  nextreg $54,34  ; MMU 4, 34

  nextreg $6b, %11000011  ; enable tilemap, 80x32, 512 tiles, tilemap over ULA
  nextreg $6c, %00000000  ; Default tilemap attribute
  nextreg $6e, (tileMap - $4000) >> 8
  nextreg $6f, (tileDefs - $4000) >> 8
  nextreg $68, %10000000  ; Disable ULA output

  ld    ix, screen
  ld    bc, $0001
  call  Surface.Fill

  call  copyTilemapPalette

  ld hl, backBuffer
  ld de, tileMap
.srcCols  EQU 16
.dstCols  EQU 80
.cols     EQU   16
.rows     EQU   6
  ld bc, ((.cols * 2) << 8) | .rows
  ld ix, (((.srcCols - .cols) * 2) << 8) | ((.dstCols - .cols) * 2)
  call    Blit.Copy8x8

  ; start with yellow bar
  ld a,6
.loop:
  out (254),a
  xor 7
  ld bc,BAR
  call wait
  jp .loop

wait:
  push af
.loop:
  dec bc
  ld a,b
  or c
  jr nz,.loop

  pop af
  ret

copyTilemapPalette:
  nextreg $43, %00110000 ; tilemap 1-st palette for write, auto-increment
  nextreg $40, 0  ; start palette index = 0
  ld  hl, tilemapPalette
        ld  b, 0
.loop:
      ld  a, (hl)
  inc   hl
        nextreg $41, a  ; write palette color
        djnz  .loop
        ret

  ORG $4000

tileMap:
  ds      80*32*2

tileDefs:
  INCLUDE topaz.asm

  MMU   4, 34, $8000
scr:
  INCBIN "RoboCop.scr"

tilemapPalette:
  DUP 32
  ; dimmed colors
  DB %00000000
  DB %00000010
  DB %00010000
  DB %00010010
  DB %10000000
  DB %10000010
  DB %10010000
  DB %10010010

  ; full colors
  DB %00000000
  DB %00000011
  DB %00011100
  DB %00011111
  DB %11100000
  DB %11100011
  DB %11111100
  DB %11111111
  EDUP

backBuffer:
        DUP   80*32, i
        DB    (i % CHAR_COUNT) & $ff
        DB    ((i % CHAR_COUNT) & $100) >> 8
        EDUP

  SAVENEX OPEN "main.nex", main, $FFFE
  SAVENEX AUTO
      SAVENEX CLOSE
