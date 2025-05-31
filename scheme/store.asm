  ifndef Store_asm
  define Store_asm

  include virtual-bank.asm
  include pointer.asm

  struct Store
flags             db 0
bankCount         db 0
sizePointerArray  dw 0
virtualBankArray  dw 0
  ends

  _module store
    _module flag
      _module full
        _const bit, 7
        _const mask, 1 << BIT
      _end
    _end
  _end

  endif
