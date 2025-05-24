        ifndef  Test_asm
        define  Test_asm

        include terminal.asm
        include writer.asm

; =========================================================
suite   macro
        call    Terminal.Init
        WriteHeader
        _writeln "Starting test suite..."
        endm

; =========================================================
endsuite        macro
        WriteHeader
        _write "Done, passed: "
        ld      hl, testCounter.passed
        ld      a, (hl)
        call    Writer.Hex8h
        _write "failed: "
        ld      hl, testCounter.failed
        ld      a, (hl)
        call    Writer.Hex8h
        call    Writer.NewLine
@testEndLoop
        jp      testEndLoop
        endm

; =========================================================
test    macro message
        WriteHeader
        _write message
        _write "... "
        endm

; =========================================================
endtest         macro
        jp      c, caseFail
        COLOR   %01000000
        _writeln "OK"
        ld      hl, testCounter.passed
        jp      caseEnd
@caseFail
        COLOR   %10000000
        _writeln "ERROR"
        ld      hl, testCounter.failed
@caseEnd
        inc     hl          ; increment test counter
        COLOR   %11100000
        endm

; =========================================================
COLOR   macro   col
        push    ix
        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), col
        pop     ix
        endm

; =========================================================
; Input
;   message - string
; =========================================================
SUCCESS macro
        or      a
        endm

; =========================================================
; Input
;   message - string
; =========================================================
fail    macro   message
        COLOR   %10000000
        _writeln "ERROR"
        COLOR   %11100000
@failLoop
        jp      failLoop
        endm

; =========================================================
; Input
;   message - string
; =========================================================
ASSERT_EQ_R     macro   message, r, nn
        ld      a, r
        xor     nn
        jp      z, eqOK
@eqFail
        COLOR   %01000000
        _writeln "ERROR"
        COLOR   %11100000

        FAIL
        jp      eqEnd
@eqOK
        SUCCESS
@eqEnd
        endm

; =========================================================
        macro   WriteHeader
;        ld      hl, __LINE__
;        call    Writer.Hex16h
;        _write ": "
        endm

testCounter
.passed db     0
.failed db     0

        endif
