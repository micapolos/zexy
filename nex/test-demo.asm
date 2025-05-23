        device  zxspectrumnext

        org     $8000

        include test.asm

Main
        suite

        test   "Load into register"
        fail
        endtest

        endsuite

        savenex open "built/test-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/test-demo.map"
