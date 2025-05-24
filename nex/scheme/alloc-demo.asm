        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include writer.asm
        include ld.asm
        include dump.asm
        include zexy.asm
        include scheme/alloc.asm

SEGMENT_BIT_SIZE  equ     3
SEGMENT_SIZE      equ     1 << (SEGMENT_BIT_SIZE + 1)
SEGMENT_ADDR_MASK equ     SEGMENT_SIZE - 1

        macro   PressSpaceTo msg
        _write "<- Press SPACE to "
        _write msg
        _writeln " ->"
        call    Debug.WaitSpace
        call    Writer.NewLine
        endm

Main
        call    Terminal.Init

        _write "Segment bit size: "
        ld      a, SEGMENT_BIT_SIZE
        call    Writer.Hex8
        call    Writer.NewLine

        _write "Segment size: "
        ld      hl, SEGMENT_SIZE
        call    Writer.Hex16
        call    Writer.NewLine

        _write "Segment mask: "
        ld      hl, SEGMENT_ADDR_MASK
        call    Writer.Hex16
        call    Writer.NewLine

        call    Writer.NewLine

        ; Initialize segment config
        ld      hl, Segment
        ldi_ihl_u16 SEGMENT_ADDR_MASK
        ldi_ihl_u8  SEGMENT_BIT_SIZE

        ; Initialize empty segment
        ld      hl, segment
        call    SchemeAlloc.InitSegment
        call    DumpSegment

        PressSpaceTo "allocate full segment"
        call    Debug.WaitSpace
        ld      hl, (currentBlock)
        ld      a, SEGMENT_BIT_SIZE
        call    SchemeAlloc.Alloc
        ld      (currentBlock), hl
        call    DumpSegment

        PressSpaceTo "free full segment"
        call    Debug.WaitSpace
        ld      hl, (currentBlock)
        call    SchemeAlloc.Free
        ld      (currentBlock), hl
        call    DumpSegment

        PressSpaceTo "allocate first half segment"
        call    Debug.WaitSpace
        ld      hl, (currentBlock)
        ld      a, SEGMENT_BIT_SIZE - 1
        call    SchemeAlloc.Alloc
        ld      (currentBlock), hl
        call    DumpSegment

        PressSpaceTo "allocate second half segment"
        call    Debug.WaitSpace
        ld      hl, (currentBlock)
        ld      a, SEGMENT_BIT_SIZE - 1
        call    SchemeAlloc.Alloc
        ld      (currentBlock), hl
        call    DumpSegment

        PressSpaceTo "allocate 1/8 segment"
        call    Debug.WaitSpace
        ld      hl, (currentBlock)
        ld      a, SEGMENT_BIT_SIZE - 3
        call    SchemeAlloc.Alloc
        ld      (currentBlock), hl
        call    DumpSegment

.end    jp      .end

DumpSegment
        _if c
          _writeln "Out of memory!!!"
        _end
        ld      hl, segment
        ld      bc, SEGMENT_SIZE
        call    Writer.Dump

        _write "Current block: "
        ld      hl, (currentBlock)
        call    Writer.Hex16
        call    Writer.NewLine

        call    Writer.NewLine

        ret

        org     $c000
segment         ds      SEGMENT_SIZE, 0
currentBlock    dw      segment

        savenex open "built/scheme/alloc-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/scheme/alloc-demo.map"
