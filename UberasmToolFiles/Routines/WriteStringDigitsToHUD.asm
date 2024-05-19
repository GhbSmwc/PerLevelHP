	incsrc "../PerLevelHPDefines/Defines.asm"
	incsrc "../PerLevelHPDefines/Defines_HexDec.asm"
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Write aligned digits to Status bar/OWB+
	;
	;Input:
	; -$00-$02 = 24-bit address location to write to status bar tile number.
	; -If tile properties are edit-able (if !StatusBar_UsingCustomProperties != 0):
	; --$03-$05 = Same as $00-$02 but tile properties
	; --$06 = the tile properties, for all tiles
	; -X = The number of characters to write, ("123" would have X = 3)
	; -!Scratchram_CharacterTileTable-(!Scratchram_CharacterTileTable+N-1)
	;  the string to write to the status bar.
	;
	;Note:
	; -WriteStringDigitsToHUD is designed for [TTTTTTTT, TTTTTTTT,...], [YXPCCCTT, YXPCCCTT,...]
	; -WriteStringDigitsToHUDFormat2 is designed for [TTTTTTTT, YXPCCCTT, TTTTTTTT, YXPCCCTT...]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	?WriteStringDigitsToHUD:
		DEX
		TXY
		
		.Loop
			LDA !Scratchram_CharacterTileTable,x
			STA [$00],y
			if !StatusBar_UsingCustomProperties != 0
				LDA $06
				STA [$03],y
			endif
			DEX
			DEY
			BPL ?.Loop
		RTL