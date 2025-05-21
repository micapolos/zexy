        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include writer.asm
        include ld.asm

Main
        call    Terminal.Init

        ld      hl, data
        ldi_ihl_u8  $01
        ldi_ihl_u16 $0302
        ldi_ihl_u32 $07060504

        ld      hl, data2 + 7
        ldd_ihl_u32 $07060504
        ldd_ihl_u16 $0302
        ldd_ihl_u8  $01

        ld      hl, data3
        ld      a, $01
        ldi_ihl_a
        ld      de, $0302
        ldi_ihl_de
        ld_bcde_u32 $07060504
        ldi_ihl_bcde

        ld      hl, data4 + 7
        ld_bcde_u32 $07060504
        ldd_ihl_bcde
        ld      de, $0302
        ldd_ihl_de
        ld      a, $01
        ldd_ihl_a

        ld      hl, data5
        ldi_ihl_u8  $01       : ldd_a_ihl    : inc a : ldi_ihl_a
        ldi_ihl_u16 $0302     : ldd_de_ihl   : inc d : inc e : ldi_ihl_de
        ldi_ihl_u32 $07060504 : ldd_bcde_ihl : inc b : inc c : inc d : inc e : ldi_ihl_bcde

        ld      hl, data6 + 7
        ldd_ihl_u32 $07060504 : ldi_bcde_ihl : inc b : inc c : inc d : inc e : ldd_ihl_bcde
        ldd_ihl_u16 $0302     : ldi_de_ihl   : inc d : inc e : ldd_ihl_de
        ldd_ihl_u8  $01       : ldi_a_ihl    : inc a : ldd_ihl_a

        break

.end    jp      .end

data    block 8, 0
data2   block 8, 0
data3   block 8, 0
data4   block 8, 0
data5   block 8, 0
data6   block 8, 0

        savenex open "built/ld-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/ld-demo.map"
