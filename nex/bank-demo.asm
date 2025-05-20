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
        call    AvailableBanks
        jp      End

TotalBanks
        WriteString "Total number of banks: "
        call    Bank.Total
        jp      c, Error
        ld      a, e
        call    Writer.Hex8h
        jp      Writer.NewLine

AvailableBanks
        WriteString "Number of available banks: "
        call    Bank.Available
        jp      c, Error
        ld      a, e
        call    Writer.Hex8h
        jp      Writer.NewLine

AllocateBank
        WriteString "Allocating bank... "
        call    Bank.Alloc
        jp      c, Error

        push    de
        WriteString "done: "
        pop     af
        call    Writer.Hex8h
        jp      Writer.NewLine

Error
        WritelnString "Error!!!"

End     jp      End

        savenex open "built/bank-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/bank-demo.map"
