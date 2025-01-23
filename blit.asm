	IFNDEF  BLIT
	DEFINE 	BLIT

; Input:
;   HL - src start
;   DE - dst start
;   BC - width / height
;   IXh - src stride
;   IXl - dst stride
; Output:
;   HL - src end
;   DE - dst end
;   BC - ?
Blit8x8:
	push af
.nextRow
	push bc
	ld a,b
.nextCell
	ldi
	inc bc
	djnz .nextCell
	pop bc
	ld b,a

	ld a,ixh
	add hl,a
	ld a,ixl
	add de,a

	dec c
	jp nz, .nextRow

	pop af
	ret

	ENDIF
