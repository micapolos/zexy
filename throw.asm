; ===========================================================
; Implementation of try/finally/endtry/throw.
;
; It assumes that the current error handler is stored in IY.
; ===========================================================
        ifndef  Throw_asm
        define  Throw_asm

        include terminal.asm
        include writer.asm

        module  Throw

        lua
          tryStack = {}
        endlua

; ===========================================================
; Initializes default throw handler address.
; ===========================================================
throw_handler   macro     addr
        ld      hl, addr
        ld      (Throw.Panic.stack), hl
        endm

; ===========================================================
try     macro   name

        ; Validate syntax
        lua
          table.insert(tryStack, { name = sj.get_define("name", true) })
        endlua

        endm

; ===========================================================
finally macro   name

        ; Validate syntax
        lua
          local entry = tryStack[#tryStack]
          if entry == nil then
            sj.error("finally without a try")
          elseif entry.name ~= sj.get_define("name", true) then
            sj.error("finally label mismatch, expected " .. entry.name)
          else
            local finally = entry.finally
            if finally == nil then
              entry.finally = true
            else
              sj.error("duplicate finally")
            end
          end
        endlua

        endm

; ===========================================================
endtry  macro   name

        ; Validate syntax
        lua
          if #tryStack > 0 then
            local entry = table.remove(tryStack)
            local finally = entry.finally
            if finally == nil then
              sj.error("endtry without finally")
            end
          else
            sj.error("endtry without try")
          end
        endlua

        endm

; ===========================================================
throw   macro
        ld      hl, (Throw.throwSP)
        ld      sp, hl
        ret
        endm

; ===========================================================
Panic   break
.stack  dw      Panic

throwSP         dw      Panic.stack

        endmodule

        endif
