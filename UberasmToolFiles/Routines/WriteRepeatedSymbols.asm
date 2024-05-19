;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Input:
; -$00 (1 byte): the amount filled
; -$01 (1 byte): the total amount (or maximum)
; -$02 (1 byte): Tile number for empty
; -$03 (1 byte): Tile number for full
; -$04-$06 (3 bytes): The status bar address of tiles to write (leftmost tile position,
;  for both rightwards and leftwards).
; -If you have !StatusBar_UsingCustomProperties set to 1, the following will be used:
; --$07 (1 byte): Tile properties for empty
; --$08 (1 byte): Tile properties for full
; --$09-$0B (3 bytes): The status bar address of tile properties to write

;Output:
; -$00: How many extra fills if exceeding max, otherwise 0; FillsLeft = max(AmountFilled - TotalAmount, 0)
; -$01: will be 0 as they're being used to count how many tiles left to write.
; -RAM_In_Addr04 to [RAM_In_Addr04 + ((ValueIn01-1) * !StatusbarFormat)] The
;  repeated tiles in question.
; -RAM_In_Addr09 to [RAM_In_Addr09 + ((ValueIn01-1) * !StatusbarFormat)] The
;   repeated tile properties in question.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
?WriteRepeatedSymbols:
	LDY #$00
	
	.Loop
		LDA $01			;\If no tiles left, done.
		BEQ ?.Done		;/
		LDA $00			;\If no full tiles, write empty.
		BEQ ?..Empty		;/
	
		?..Full
			LDA $03			;\Write full tile
			STA [$04],y		;/
			if !StatusBar_UsingCustomProperties != 0
				LDA $08			;\Write full tile properties
				STA [$09],y		;/
			endif
			DEC $00			;>Decrement how much full tiles left.
			BRA ?..Next
	
		?..Empty
			LDA $02			;\Write empty tile
			STA [$04],y		;/
			if !StatusBar_UsingCustomProperties != 0
				LDA $07			;\Write empty tile properties
				STA [$09],y		;/
			endif
		?..Next
			INY 			;>Next status bar tile
			DEC $01			;>Decrement how many total tiles are left.
			BNE ?.Loop
	
	?.Done
		RTL