        ifndef  Scheme_asm
        define  Scheme_asm
        module  Scheme

        struct  Symbol

        ends

        module  Bank

        module  Type
_BITS           equ     3
_MASK           equ     (1 << _BITS) - 1

NATIVE          equ     %000  ; native bank, not managed by Scheme
U8              equ     %001  ; 8192 * u8
CONS            equ     %010  ; 1024 * Cons
VALUE           equ     %011  ; 2048 * Value
SYMBOL          equ     %011  ; 2048 * Value
UNUSED_4        equ     %100
UNUSED_5        equ     %101
UNUSED_6        equ     %110
UNUSED_7        equ     %111
        endmodule

        endmodule

        module  Tag
BITS    equ     4
MASK    equ     (1 << BITS) - 1

U24     equ     %0010   ; 24-bit integer
PRIM    equ     %0011   ; 3-bit primitive
SYMBOL  equ     $0100   ; symbol with index
BANK    equ     %0111   ; bank with index
REF     equ     %1001   ; reference: 8-bit bank and 13-bit index within the bank
FUNC    equ     %1000   ; function
        endmodule

        module  Prim
BITS    equ     3
MASK    equ     (1 << BITS) - 1

UNDEF   equ     %000
NIL     equ     %001
FALSE   equ     %010
TRUE    equ     %011
        endmodule

        struct  Value
header  db
data0   db
data1   db
data2   db
        ends

        module  Value
HEADER_GC_MARK    equ     %10000000
HEADER_TAG_SHIFT  equ     7 - Scheme.Tag.BITS
HEADER_TAG_MASK   equ     Scheme.Tag.MASK << HEADER_TAG_SHIFT
HEADER_PRIM_MASK  equ     Scheme.Prim.MASK
        endmodule

        struct  Cons
car     Value
cdr     Value
        ends

        endmodule
        endif
