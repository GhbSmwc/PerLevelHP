	;This is a bit faster than calling [EightBitHexDec] twice. Done by subtracting by 100
	;repeatedly first, then 10s, and after that, the ones are done.
	; Y = 100s
	; X = 10s
	; A = 1s
	;
	;Example: A=$FF (255):
	; 255 -> 155 -> 55 Subtracted 2 times, so 100s place is 2 (goes into Y).
	; 55 -> 45 -> 35 -> 25 -> 15 -> 5 Subtracted 5 times, so 10s place is 5 (in X).
	; 5 is already the ones place for A.
	;As a result, a total of 7 repeated loops (2 for 100s, plus 5 for the 10s), vs 27
	;of calling [EightBitHexDec] twice.
	?EightBitHexDec3Digits:
		LDX #$00			;\Start the counter at 0.
		LDY #$00			;/
		?.LoopSub100
			CMP.b #100		;\Y counts how many 100s until A cannot be subtracted by 100 anymore
			BCC ?.LoopSub10		;/
			SBC.b #100		;>Subtract and...
			INY			;>Count how many 100s.
			BRA ?.LoopSub100		;>Keep counting until less than 100
		?.LoopSub10
			CMP.b #10		;\X counts how many 10s until A cannot be subtracted by 10 anymore
			BCC ?.Return		;/A will automatically be the 1s place.
			SBC.b #10		;>Subtract and...
			INX			;>Count how many 10s
			BRA ?.LoopSub10		;>Keep counting until less than 10.
		?.Return
			RTL