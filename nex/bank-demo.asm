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

        _writeln "Goodbye!!!"

        jp      End

TotalBanks
        _write "Total number of banks: "
        call    Bank.Total
        jp      c, Error
        call    Writer.Hex8h
        jp      Writer.NewLine

AvailableBanks
        _write "Number of available banks: "
        call    Bank.Available
        jp      c, Error
        call    Writer.Hex8h
        jp      Writer.NewLine

AllocateBank
        _write "Allocating bank... "
        call    Bank.Alloc
        jp      c, Error

        push    af
        _write "done: "
        pop     af
        push    af
        call    Writer.Hex8h
        call    Writer.NewLine
        pop     af
        ret

FreeBank
        push    af
        _write "Freeing bank: "
        pop     af
        push    af
        call    Writer.Hex8h
        _write "... "
        pop     af

        call    Bank.Free
        jp      c, Error

        _writeln "OK"
        ret

Error
        _writeln "Error!!!"

End     jp      End

@bank1   db      0
@bank2   db      0

        savenex open "built/bank-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/bank-demo.map"
