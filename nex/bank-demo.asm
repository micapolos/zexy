        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include bank.asm
        include writer.asm

Main
        call    Terminal.Init

        call    TotalBanks
        call    AvailableBanks

        call    AllocateBank
        ld      (bank1), a

        call    AvailableBanks

        call    AllocateBank
        ld      (bank2), a

        call    AvailableBanks

        ld      a, (bank2)
        call    FreeBank
        call    AvailableBanks

        ld      a, (bank1)
        call    FreeBank
        call    AvailableBanks

        WritelnString "Goodbye!!!"

        jp      End

TotalBanks
        WriteString "Total number of banks: "
        call    Bank.Total
        jp      c, Error
        call    Writer.Hex8h
        jp      Writer.NewLine

AvailableBanks
        WriteString "Number of available banks: "
        call    Bank.Available
        jp      c, Error
        call    Writer.Hex8h
        jp      Writer.NewLine

AllocateBank
        WriteString "Allocating bank... "
        call    Bank.Alloc
        jp      c, Error

        push    af
        WriteString "done: "
        pop     af
        push    af
        call    Writer.Hex8h
        call    Writer.NewLine
        pop     af
        ret

FreeBank
        push    af
        WriteString "Freeing bank: "
        pop     af
        push    af
        call    Writer.Hex8h
        WriteString "... "
        pop     af

        call    Bank.Free
        jp      c, Error

        WritelnString "OK"
        ret

Error
        WritelnString "Error!!!"

End     jp      End

@bank1   db      0
@bank2   db      0

        savenex open "built/bank-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/bank-demo.map"
