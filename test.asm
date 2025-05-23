        ifndef  Test_asm
        define  Test_asm

        include terminal.asm
        include writer.asm

; =========================================================
suite   macro
        call    Terminal.Init
        WriteHeader
        WritelnString "Starting test suite..."
        endm

; =========================================================
endsuite        macro
        WriteHeader
        WriteString "Done, passed: "
        ld      hl, testCounter.passed
        ld      a, (hl)
        call    Writer.Hex8h
        WriteString "failed: "
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
        WriteString message
        WriteString "... "
        endm

; =========================================================
endtest         macro
        jp      c, caseFail
        COLOR   %01000000
        WritelnString "OK"
        ld      hl, testCounter.passed
        jp      caseEnd
@caseFail
        COLOR   %10000000
        WritelnString "ERROR"
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
        WritelnString "ERROR"
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
        WritelnString "ERROR"
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
;        WriteString ": "
        endm

testCounter
.passed db     0
.failed db     0

        endif
