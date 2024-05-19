	;For [WriteStringDigitsToHUD]. This is only used if you are using aligned numbers (suppresses leading zeroes instead of leading spaces)
	;Meaning you have:
	; !Setting_HPDisplayType == 1
	; !Setting_HPNumberAlignment set to 1 or 2
	;
	;
	;
	;
		if !sa1 == 0
			!Scratchram_CharacterTileTable = $7F8458
		else
			!Scratchram_CharacterTileTable = $40414A
		endif
		;^[X bytes] A table containing strings of "characters"
		; (more specifically digits). The number of bytes used
		; is the highest number of characters you would write
		; in your entire game.
		; For example:
		; -If you want to display a 5-digit 16-bit number 65535,
		;  that will be 5 bytes.
		; -If you want to display [10000/10000], that will be
		;  11 bytes (2 numbers up to 5 digits, plus 1 because
		;  "/"; 5 + 5 + 1 = 11)
		; -For 32-bit hexdec:
		; --For displaying a left-aligned number will be !Setting_32bitHexDec_MaxNumberOfDigits
		; --For X/Y display: (!Setting_32bitHexDec_MaxNumberOfDigits*2)+1
;Don't touch unless you know what you're doing
	;[5 bytes]
	;16-bit Hexdec Digit table.
	;For these routines:
	;-SixteenBitHexDecDivision
	;-RemoveLeadingZeroes16Bit
	;-SupressLeadingZeros
	;This is due to the fact that the digit table
	;position varies as the 16-bit HexDec routine
	;uses the SNES registers for non SA-1, or
	;uses a division routine which the outputs are
	;at $00-$03.
		!Scratchram_16bitHexDecOutput = $02 ;>$02-$06
		if !sa1 != 0
			!Scratchram_16bitHexDecOutput = $04 ;>$04-$08
		endif