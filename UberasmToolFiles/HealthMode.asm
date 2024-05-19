;Insert this as "Level" in uberasm tool code.

;Extra bytes format:
; $xx $xx
;
; $xx $xx is the player's starting HP
;
; Note that they're little little-endian.
; meaning a value of 1234 (which is $04D2 in hex), is in bytes form: $D2 $04.
; If you have !Setting_HealthSize set to 0 (8-bit), the extra bytes here
; must have them as if they are 16-bit as dynamic extra bytes size don't exists.
; (so the second byte must be $00 if you have HP 0-255; $XX $00).

incsrc "../PerLevelHPDefines/Defines.asm"
incsrc "../PerLevelHPDefines/Defines_GraphicalBar.asm"
incsrc "../PerLevelHPDefines/Defines_HexDec.asm"
;>bytes 2
init:
	LDA #$01
	STA !Freeram_PlayerHPMode
	if !Setting_HealthSize != 0
		REP #$20
	endif
	LDA ($00)			;Initalize starting HP and max
	STA !Freeram_PlayerHP
	if !Setting_MaxHPAsRAM != 0
		STA !Freeram_PlayerMaxHP
	endif
	if !Setting_HealthSize != 0
		SEP #$20
	endif
	RTL
main:
	.DisplayHP
		if !Setting_HPDisplayType == 0 ;repeating icons
			..RepeatedIcons
				;$00-$01 stores an address for extra bytes.
				
				if !Setting_MaxHPAsRAM != 0
					LDA !Freeram_PlayerMaxHP
				else
					LDA ($00)
				endif
				STA $01		;>Max amount
				LDA !Freeram_PlayerHP
				STA $00		;>Current amount
				LDA.b #!Setting_HPDisplay_RepeatedIcons_Empty_TileNum
				STA $02
				LDA.b #!Setting_HPDisplay_RepeatedIcons_Full_TileNum
				STA $03
				if !StatusBar_UsingCustomProperties != 0
					LDA #!Setting_HPDisplay_RepeatedIcons_Empty_TileProp
					STA $07
					LDA #!Setting_HPDisplay_RepeatedIcons_Full_TileProp
					STA $08
				endif
				LDA.b #!StatusBarLocationTile
				STA $04
				LDA.b #!StatusBarLocationTile>>8
				STA $05
				LDA.b #!StatusBarLocationTile>>16
				STA $06
				if !StatusBar_UsingCustomProperties != 0
					LDA.b #!StatusBarLocationProp
					STA $09
					LDA.b #!StatusBarLocationProp>>8
					STA $0A
					LDA.b #!StatusBarLocationProp>>16
					STA $0B
				endif
				if !StatusbarFormat == $01
					%UberRoutine(WriteRepeatedSymbols)
				elseif !StatusbarFormat == $02
					%UberRoutine(WriteRepeatedSymbolsFormat2)
				endif
		else ;numerical
			..Numerical
				if and(equal(!Setting_HealthSize, 0), equal(!Setting_HPNumberAlignment, 0))
					if !Setting_MaxHPDigits == 1
						LDA !Freeram_PlayerHP
						STA !StatusBarLocationTile
						if !Setting_DisplayMaxHP != 0
							LDA #!StatusBarSlashCharacterTileNumb
							STA !StatusBarLocationTile+(1*!StatusbarFormat)
							if !Setting_MaxHPAsRAM == 0
								LDA ($00)
							else
								LDA !Freeram_PlayerMaxHP
							endif
							STA !StatusBarLocationTile+(2*!StatusbarFormat)
						endif
					elseif !Setting_MaxHPDigits == 2
						...CurrentHP
							LDA !Freeram_PlayerHP
							%UberRoutine(EightBitHexDec)
							STA !StatusBarLocationTile+(1*!StatusbarFormat) ;Ones place
							TXA
							BNE ....NotLeadingZero
							LDA.b #!StatusBarBlankTile
							....NotLeadingZero
							STA !StatusBarLocationTile		;tens place
						...MaxHP
							if !Setting_DisplayMaxHP != 0
								LDA #!StatusBarSlashCharacterTileNumb
								STA !StatusBarLocationTile+(2*!StatusbarFormat)
								LDA ($00)
								%UberRoutine(EightBitHexDec)
								STA !StatusBarLocationTile+(4*!StatusbarFormat) ;Ones place
								TXA
								BNE ....NotLeadingZero
								LDA.b #!StatusBarBlankTile
								....NotLeadingZero
								STA !StatusBarLocationTile+(3*!StatusbarFormat)		;tens place
							endif
					else
						...CurrentHP
							LDA !Freeram_PlayerHP
							%UberRoutine(EightBitHexDec3Digits) ;A:1s,X:10s,Y:100s
							STA !StatusBarLocationTile+(2*!StatusbarFormat)
							CPY #$00
							BNE ....HundredsNonZero
							
							....NoHundreds
								LDA.b #!StatusBarBlankTile
								STA !StatusBarLocationTile
								BRA ....HandleTens
							....HundredsNonZero
								TYA
								STA !StatusBarLocationTile
								BRA ....HandleTens_WriteTens
							
							....HandleTens
								CPX #$00
								BNE .....WriteTens
								.....NoTens
									LDX #!StatusBarBlankTile
								.....WriteTens
									TXA
									STA !StatusBarLocationTile+(1*!StatusbarFormat)
						...MaxHP
							if !Setting_DisplayMaxHP != 0
								LDA #!StatusBarSlashCharacterTileNumb
								STA !StatusBarLocationTile+(3*!StatusbarFormat)
								if !Setting_MaxHPAsRAM == 0
									LDA ($00)
								else
									LDA !Freeram_PlayerMaxHP
								endif
								%UberRoutine(EightBitHexDec3Digits) ;A:1s,X:10s,Y:100s
								STA !StatusBarLocationTile+(6*!StatusbarFormat)
								CPY #$00
								BNE ....HundredsNonZero
								
								....NoHundreds
									LDA.b #!StatusBarBlankTile
									STA !StatusBarLocationTile+(4*!StatusbarFormat)
									BRA ....HandleTens
								....HundredsNonZero
									TYA
									STA !StatusBarLocationTile+(4*!StatusbarFormat)
									BRA ....HandleTens_WriteTens
								
								....HandleTens
									CPX #$00
									BNE .....WriteTens
									.....NoTens
										LDX #!StatusBarBlankTile
									.....WriteTens
										TXA
										STA !StatusBarLocationTile+(5*!StatusbarFormat)
							endif
					endif
				elseif !Setting_HPNumberAlignment != 0
					...ClearTiles
						if !Setting_DisplayMaxHP == 0
							LDX.b #(!Setting_MaxHPDigits-1)*!StatusbarFormat
						else
							LDX.b #((!Setting_MaxHPDigits*2))*!StatusbarFormat
						endif
						....Loop
							LDA #!StatusBarBlankTile
							STA !StatusBarLocationTile,x
							if !StatusBar_UsingCustomProperties != 0
								LDA #!StatusBarCharTileProps
								STA !StatusBarLocationProp,x
							endif
							DEX #!StatusbarFormat
							BPL ....Loop
					...WriteText
						if and(notequal(!Setting_DisplayMaxHP, 0),equal(!Setting_MaxHPAsRAM, 0))
							REP #$20
							LDA ($00)	;We are going to need $00 for another purpose
							STA $8A
							SEP #$20
						endif
						LDA !Freeram_PlayerHP
						STA $00
						if !Setting_HealthSize == 0
							STZ $01
						else
							LDA !Freeram_PlayerHP+1
							STA $01
						endif
						%UberRoutine(SixteenBitHexDecDivision)
						;We call SixteenBitHexDecDivision so we have the digits in the table
						LDX #$00
						%UberRoutine(SupressLeadingZeros) ;X = char position (after last written character)
						if !Setting_DisplayMaxHP == 0
							CPX.b #!Setting_MaxHPDigits+1
							BCS ....TooManyChars
						else
							LDA #!StatusBarSlashCharacterTileNumb
							STA !Scratchram_CharacterTileTable,x
							INX
							
							PHX
							if !Setting_MaxHPAsRAM == 0
								LDA $8A
								STA $00
								if !Setting_HealthSize == 0
									STZ $01
								else
									LDA $8A+1
									STA $01
								endif
							else
								LDA !Freeram_PlayerMaxHP
								STA $00
								if !Setting_HealthSize == 0
									STZ $01
								else
									LDA !Freeram_PlayerMaxHP+1
									STA $01
								endif
							endif
							%UberRoutine(SixteenBitHexDecDivision)
							PLX
							%UberRoutine(SupressLeadingZeros) ;X = char position (after last written character)
							CPX.b #(((!Setting_MaxHPDigits*2)+1)+1)
							BCS ....TooManyChars
						endif
						LDA.b #!StatusBarLocationTile     : STA $00
						LDA.b #!StatusBarLocationTile>>8  : STA $01
						LDA.b #!StatusBarLocationTile>>16 : STA $02
						if !StatusBar_UsingCustomProperties != 0
							LDA.b #!StatusBarLocationProp     : STA $03
							LDA.b #!StatusBarLocationProp>>8  : STA $04
							LDA.b #!StatusBarLocationProp>>16 : STA $05
							LDA #!StatusBarCharTileProps
							STA $06
						endif
						if !StatusbarFormat == $01
							%UberRoutine(WriteStringDigitsToHUD)
						else
							%UberRoutine(WriteStringDigitsToHUDFormat2)
						endif
						....TooManyChars
				endif
				if and(notequal(!Setting_HealthSize, 0), equal(!Setting_HPNumberAlignment, 0))
					REP #$20
					if and(notequal(!Setting_DisplayMaxHP, 0),equal(!Setting_MaxHPAsRAM, 0))
						LDA ($00)
						STA $8A
					endif
					
					
					LDA !Freeram_PlayerHP
					STA $00
					SEP #$20
					%UberRoutine(SixteenBitHexDecDivision)
					%UberRoutine(RemoveLeadingZeroes16Bit)
					if !StatusbarFormat == $01
						LDX.b #(!Setting_MaxHPDigits-1)
						-
						LDA.b !Scratchram_16bitHexDecOutput+$04-(!Setting_MaxHPDigits-1),x
						STA !StatusBarLocationTile,x
						DEX
						BPL -
					else
						LDX.b #((!Setting_MaxHPDigits-1)*2)
						LDY.b #(!Setting_MaxHPDigits-1)
						-
						LDA.w (!Scratchram_16bitHexDecOutput)+$04-(!Setting_MaxHPDigits-1)|!dp,y
						STA !StatusBarLocationTile,x
						DEY
						DEX #2
						BPL -
					endif
					if !Setting_DisplayMaxHP != 0
						LDA #!StatusBarSlashCharacterTileNumb
						STA !StatusBarLocationTile+(!Setting_MaxHPDigits*!StatusbarFormat)
						REP #$20
						if !Setting_MaxHPAsRAM == 0
							LDA $8A
							STA $00
						else
							LDA !Freeram_PlayerMaxHP
							STA $00
						endif
						SEP #$20
						%UberRoutine(SixteenBitHexDecDivision)
						%UberRoutine(RemoveLeadingZeroes16Bit)
						if !StatusbarFormat == $01
							LDX.b #(!Setting_MaxHPDigits-1)
							-
							LDA.b !Scratchram_16bitHexDecOutput+$04-(!Setting_MaxHPDigits-1),x
							STA !StatusBarLocationTile+(!Setting_MaxHPDigits+1),x
							DEX
							BPL -
						else
							LDX.b #((!Setting_MaxHPDigits-1)*2)
							LDY.b #(!Setting_MaxHPDigits-1)
							-
							LDA.w (!Scratchram_16bitHexDecOutput)+$04-(!Setting_MaxHPDigits-1)|!dp,y
							STA !StatusBarLocationTile+((!Setting_MaxHPDigits+1)*2),x
							DEY
							DEX #2
							BPL -
						endif
					endif
				endif
		endif
		if !Setting_HPDisplayGraphicalBar != 0
			.InputRatio
				LDA !Freeram_PlayerHP					;\Quantity low byte (example: current HP). Use RAM here.
				STA !Scratchram_GraphicalBar_FillByteTbl		;/
				if !Setting_HealthSize == 0
					LDA #$00
				else
					LDA !Freeram_PlayerHP+1
				endif
				STA !Scratchram_GraphicalBar_FillByteTbl+1
				LDA !Freeram_PlayerMaxHP				;\Max quantity low byte (example: max HP). Can be a fixed value (#$) or adjustable RAM in-game.
				STA !Scratchram_GraphicalBar_FillByteTbl+2		;/
				if !Setting_HealthSize == 0
					LDA #$00
				else
					LDA !Freeram_PlayerMaxHP+1
				endif
				STA !Scratchram_GraphicalBar_FillByteTbl+3
			.InputGraphicalBarAttributes
				LDA.b #!Default_LeftPieces				;\Left end normally have 3 pieces.
				STA !Scratchram_GraphicalBar_LeftEndPiece		;/
				LDA.b #!Default_MiddlePieces				;\Number of pieces in each middle byte/8x8 tile
				STA !Scratchram_GraphicalBar_MiddlePiece		;/
				LDA.b #!Default_RightPieces				;\Right end
				STA !Scratchram_GraphicalBar_RightEndPiece		;/
				LDA.b #!Default_MiddleLength				;\length (number of middle tiles)
				STA !Scratchram_GraphicalBar_TempLength			;/
			.ConvertToBar
				wdm
				%UberRoutine(CalculateGraphicalBarPercentage)
				%UberRoutine(DrawGraphicalBarSubtractionLoopEdition)
				STZ $00								;>Use Level-layer3 tileset
				%UberRoutine(ConvertBarFillAmountToTiles)	;>Convert tiles.
				LDA.b #!StatusBarLocationTile_GraphicalBar				;\Setup address to where to draw the bar.
				STA $00								;|
				LDA.b #!StatusBarLocationTile_GraphicalBar>>8			;|
				STA $01								;|
				LDA.b #!StatusBarLocationTile_GraphicalBar>>16			;|
				STA $02								;/
				if !StatusBar_UsingCustomProperties != 0
					LDA.b #!StatusBarLocationProp_GraphicalBar				;\Same as above but properties
					STA $03								;|
					LDA.b #!StatusBarLocationProp_GraphicalBar>>8			;|
					STA $04								;|
					LDA.b #!StatusBarLocationProp_GraphicalBar>>16			;|
					STA $05								;/
					if !Default_LeftwardsBar == 0
						LDA.b #!Default_GraphicalBarProps			;\Properties
					else
						LDA.b #(!Default_GraphicalBarProps|(!Default_LeftwardsBar<<6))
					endif
					STA $06								;/
				endif
				if !Default_LeftwardsBar == 0
					if !StatusbarFormat = $01
						%UberRoutine(WriteBarToHUD)			;>Write to status bar
					else
						%UberRoutine(WriteBarToHUDFormat2)		;>Write to status bar
					endif
				else
					if !StatusbarFormat = $01
						%UberRoutine(WriteBarToHUDLeftwards)
					else
						(WriteBarToHUDLeftwardsFormat2)
					endif
				endif
		endif
	
	RTL