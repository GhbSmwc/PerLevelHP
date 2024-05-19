;Settings
	!Setting_HealthSize = 0
		;^0 = 8-bit (HP and damage ranges 0-255)
		; 1 = 16-bit (HP and damage ranges 0-65535)
	!Setting_MaxHPAsRAM = 1
		;^0 = no (not stored in RAM)
		; 1 = yes (stored as RAM, and can have different max HP amounts)
	!Setting_DefaultDamage = 1
		;^Amount of damage the player receives from any source that calls JSL $00F5B7.
		; If you want custom damage, you'll need to call a custom subroutine.
	!Setting_DefaultMushroomHeal = 2
		;^Amount of HP recovered when grabbing a mushroom.
	;Display settings
		!StatusbarFormat = $02
			;^$01 = Tile numbers and properties are in seperate tables, each byte in the table is the next tile
			; $02 = Alternating tile numbers and properties, every 2 bytes in the table is the next tile
		;Status bar address (where to place the display is offset from). Must be the same RAM as the status bar patch uses.
			if !sa1 == 0
				!StatusBarBaseAddressTile = $7FA000
			else
				!StatusBarBaseAddressTile = $404000
			endif
			if !sa1 == 0
				!StatusBarBaseAddressProp = !StatusBarBaseAddressTile+1
			else
				!StatusBarBaseAddressProp = !StatusBarBaseAddressTile+1
			endif
		;Where to place the HP display
		;This is the position of the numbers or repeated icons
			!StatusBarLocationTile = !StatusBarBaseAddressTile+$00
			!StatusBarLocationProp = !StatusBarBaseAddressProp+$00
		;These are for graphical bar (if !Setting_HPDisplayGraphicalBar == 1)
			!StatusBarLocationTile_GraphicalBar = !StatusBarBaseAddressTile+$40
			!StatusBarLocationProp_GraphicalBar = !StatusBarBaseAddressProp+$40
		!StatusBar_UsingCustomProperties = 1
			;^0 if only tile numbers are to be modified
			; 1 if you are also want to modifiy the tile properties
		!Setting_HPDisplayType = 1
			;^0 = repeated icons (not recommended to use if you have more than 32 HP)
			; 1 = Numerical
		;Repeated icons (when !Setting_HPDisplayType == 0) settings
			!Setting_HPDisplay_RepeatedIcons_Empty_TileNum = $38 ;Tile number for empty HP icon
			!Setting_HPDisplay_RepeatedIcons_Empty_TileProp = %00111000 ;YXPCCCTT property for empty HP icon (not used if !StatusBar_UsingCustomProperties == 0)
			!Setting_HPDisplay_RepeatedIcons_Full_TileNum = $39 ;Same as above but for empty
			!Setting_HPDisplay_RepeatedIcons_Full_TileProp = %00111000 ;Same as above but for empty
		;Numerical HP settings (when !Numerical == 1)
			!Setting_MaxHPDigits = 3
				;^Maximum number of digits, needed to determine how many tiles to write, including removing
				; leading zeroes, and clearing out tiles when using aligned digits.
			!Setting_DisplayMaxHP = 0
				;^0 = display only the current HP
				; 1 = display <currentHP>/<maxHP>
			!Setting_HPNumberAlignment = 0
				;^0 = Digits at fixed locations (leading spaces if fewer digits than !Setting_MaxHPDigits)
				; 1 = left aligned, leading zeroes suppressed (instead of "  3/  3" with !Setting_MaxHPDigits == 3, it is "3/3")
				; 2 = right aligned (pointless to use this setting if you have 1 number since fixed location is automatically right-aligned)
			!StatusBarCharTileProps = %00111000 ; YXPCCCTT property for text (number and slash symbol)
		;Graphical bar settings
			!Setting_HPDisplayGraphicalBar = 1
				;^0 = no
				; 1 = yes, use graphical bar.
			!Default_MiddleLength                = 7             ;>30 = screen-wide (30 + 2 end tiles = 32, all 8x8 tile row in the screen's width)
			!Default_LeftPieces                  = 3             ;\These will by default, set the RAM for the pieces for each section
			!Default_MiddlePieces                = 8             ;|
			!Default_RightPieces                 = 3             ;/
				;^Don't get confused with GraphicalBarDefines.asm's Bar attributes. These are the ACTUAL number of pieces
				; that the RAM address are set to contain these values. Therefore, these are what the RAM address are set
				; by default.
		
			!Default_LeftwardsBar                           = 0
				;^0 = Fill from left to right (default)
				; 1 = Fill from right to left (will always SET bit X in YXPCCCTT).
				; Note that end tiles are also mirrored. This only works properly
				; on any status bar patches that allow editing the tile properties.
				; Having this set to 1 while using SMW's vanilla status bar causes
				; each tiles to fill backwards (rightwards as fill increases) while
				; advancing tiles to the left. If that is the case, flip the tiles
				; in the file bin then or edit SMW's status bar table at address $008C81.
				;
				; Note: Make sure the bar graphic tiles are fill left-to-right
				; BY DEFAULT (in the .bin files).
			!Default_GraphicalBarProps                      = %00111000
				;^YXPCCCTT tile properties for graphical bar. NOTE: If leftwards, X bit is forcibly set.

	;Various tile numbers to use
		!StatusBarBlankTile = $FC
			;^Tile number to use for blank
		!StatusBarSlashCharacterTileNumb = $29
			;^Tile number for "/" symbol (often to display a separation between current and max). Only used when Setting_HPDisplayType == 1 and !Setting_DisplayMaxHP == 1
	;Routine-specific defines
		;RemoveLeadingZeroes16Bit
			!StatusBarBlankTile = $FC
				;^Tile number to use for blank
;Freeram
	!Freeram_PlayerHPMode = $0DC3|!addr
		;^[1 byte] RAM to determine should the HP system be applied:
		; #$00 = no (vanilla mode, as if game isn't patched at all)
		; #$01 = yes, HP is only lost when taking damage as small mario, and powerdowns will not
		; #$02 = yes, and also loses HP when taking damage while having a powerup.
	!Freeram_PlayerHP = $0DC4|!addr
		;^[BytesUsed = 1+!Setting_HealthSize] Player HP
	!Freeram_PlayerMaxHP = $0DDB|!addr
		;^[BytesUsed = (1+!Setting_HealthSize)*!Setting_MaxHPAsRAM] Player max HP. Only used when !Setting_MaxHPAsRAM
		; is set to 1.
		

	assert not(and(notequal(!Setting_HealthSize, 0),equal(!Setting_HPDisplayType,0))), "Why would you want 16-bit HP repeated icons?"
	assert not(and(equal(!Setting_HPNumberAlignment, 2),notequal(!Setting_DisplayMaxHP, 0))), "You do not need a right-aligned number display if you are displaying a single number."