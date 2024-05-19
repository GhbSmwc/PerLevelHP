?WriteRepeatedSymbolsLeftwards:
	LDA $01				;\Get index of rightmost icon and start there
	DEC				;|
	if !StatusbarFormat == $02	;|
		ASL			;|
	endif				;|
	TAY				;/
	
	?.Loop
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
			DEY 			;>Next status bar tile
			DEC $01			;>Decrement how many total tiles are left.
			BNE ?.Loop
	?.Done
		RTL