        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include writer.asm
        include ld.asm
        include scheme/alloc.asm

SEGMENT_BIT_SIZE  equ     4
SEGMENT_SIZE      equ     1 << (SEGMENT_BIT_SIZE + 1)
SEGMENT_ADDR_MASK equ     SEGMENT_SIZE - 1

Main
        call    Terminal.Init

        WritelnString "Welcome to Scheme!!!"

        ld      hl, SchemeAlloc.segment
        ldi_ihl_u16 SEGMENT_ADDR_MASK
        ldi_ihl_u8  SEGMENT_BIT_SIZE

        ld      hl, segment
        call    SchemeAlloc.InitSegment

        ld      hl, segment
        call    SchemeAlloc.GetMetadata

        break
.end    jp      .end

        align   SEGMENT_SIZE
segment         ds      SEGMENT_SIZE, 0
currentBlock    dw      segment

        savenex open "built/scheme/alloc-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/scheme/alloc-demo.map"
