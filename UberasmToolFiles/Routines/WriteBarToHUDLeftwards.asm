incsrc "../PerLevelHPDefines/Defines_GraphicalBar.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Same as above, but fills leftwards as opposed to rightwards.
;Note that this is still "left anchored", meaning the address
;to write your bar on would be the left side where the fill
;is at when full.
;
;NOTE: does not reverse the order of data in
;!Scratchram_GraphicalBar_FillByteTbl, it simply writes to the HUD
;in reverse order.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		?WriteBarToHUDLeftwards:
			;JSL CountNumberOfTiles
			%UberRoutine(GraphicalBarCountNumberOfTiles)
			CPX #$FF
			BEQ ?.Done
			LDY #$00
			
			?.Loop
				LDA !Scratchram_GraphicalBar_FillByteTbl,x
				STA [$00],y
				if !StatusBar_UsingCustomProperties != 0
					LDA $06
					STA [$03],y
				endif
			
				?..Next
					INY
					DEX
					BPL ?.Loop
		
			?.Done
				RTL