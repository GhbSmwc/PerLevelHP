;This is a patch that modifies the damage routine to check !Freeram_PlayerHPMode whether to
;run the vanilla damage system or the health system.

;Defines. Don't touch unless you know what you're doing.
	!dp = $0000
	!addr = $0000
	!bank = $800000
	!sa1 = 0
	if read1($00FFD5) == $23
		sa1rom
		!dp = $3000
		!addr = $6000
		!bank = $000000
		!sa1 = 1
	endif
	macro define_sprite_table(name, addr, addr_sa1)
		if !sa1
			!<name> = <addr_sa1>
		else
			!<name> = <addr>
		endif
	endmacro
	
%define_sprite_table("7FAB10",$7FAB10,$400040)
%define_sprite_table("7FAB1C",$7FAB1C,$400056)
%define_sprite_table("7FAB28",$7FAB28,$400057)
%define_sprite_table("7FAB34",$7FAB34,$40006D)
%define_sprite_table("7FAB9E",$7FAB9E,$400083)
%define_sprite_table("7FAB40",$7FAB40,$400099)
%define_sprite_table("7FAB4C",$7FAB4C,$4000AF)
%define_sprite_table("7FAB58",$7FAB58,$4000C5)
%define_sprite_table("extra_bits",$7FAB10,$400040)
%define_sprite_table("new_code_flag",$7FAB1C,$400056)
%define_sprite_table("extra_prop_1",$7FAB28,$400057)
%define_sprite_table("extra_prop_2",$7FAB34,$40006D)
%define_sprite_table("new_sprite_num",$7FAB9E,$400083)
%define_sprite_table("extra_byte_1",$7FAB40,$400099)
%define_sprite_table("extra_byte_2",$7FAB4C,$4000AF)
%define_sprite_table("extra_byte_3",$7FAB58,$4000C5)
%define_sprite_table("extra_byte_4",$7FAB64,$4000DB)
%define_sprite_table(sprite_num, $9E, $3200)
%define_sprite_table(sprite_speed_y, $AA, $9E)
%define_sprite_table(sprite_speed_x, $B6, $B6)
%define_sprite_table(sprite_misc_c2, $C2, $D8)
%define_sprite_table(sprite_y_low, $D8, $3216)
%define_sprite_table(sprite_x_low, $E4, $322C)
%define_sprite_table(sprite_status, $14C8, $3242)
%define_sprite_table(sprite_y_high, $14D4, $3258)
%define_sprite_table(sprite_x_high, $14E0, $326E)
%define_sprite_table(sprite_speed_y_frac, $14EC, $74C8)
%define_sprite_table(sprite_speed_x_frac, $14F8, $74DE)
%define_sprite_table(sprite_misc_1504, $1504, $74F4)
%define_sprite_table(sprite_misc_1510, $1510, $750A)
%define_sprite_table(sprite_misc_151c, $151C, $3284)
%define_sprite_table(sprite_misc_1528, $1528, $329A)
%define_sprite_table(sprite_misc_1534, $1534, $32B0)
%define_sprite_table(sprite_misc_1540, $1540, $32C6)
%define_sprite_table(sprite_misc_154c, $154C, $32DC)
%define_sprite_table(sprite_misc_1558, $1558, $32F2)
%define_sprite_table(sprite_misc_1564, $1564, $3308)
%define_sprite_table(sprite_misc_1570, $1570, $331E)
%define_sprite_table(sprite_misc_157c, $157C, $3334)
%define_sprite_table(sprite_blocked_status, $1588, $334A)
%define_sprite_table(sprite_misc_1594, $1594, $3360)
%define_sprite_table(sprite_off_screen_horz, $15A0, $3376)
%define_sprite_table(sprite_misc_15ac, $15AC, $338C)
%define_sprite_table(sprite_slope, $15B8, $7520)
%define_sprite_table(sprite_off_screen, $15C4, $7536)
%define_sprite_table(sprite_being_eaten, $15D0, $754C)
%define_sprite_table(sprite_obj_interact, $15DC, $7562)
%define_sprite_table(sprite_oam_index, $15EA, $33A2)
%define_sprite_table(sprite_oam_properties, $15F6, $33B8)
%define_sprite_table(sprite_misc_1602, $1602, $33CE)
%define_sprite_table(sprite_misc_160e, $160E, $33E4)
%define_sprite_table(sprite_index_in_level, $161A, $7578)
%define_sprite_table(sprite_misc_1626, $1626, $758E)
%define_sprite_table(sprite_behind_scenery, $1632, $75A4)
%define_sprite_table(sprite_misc_163e, $163E, $33FA)
%define_sprite_table(sprite_in_water, $164A, $75BA)
%define_sprite_table(sprite_tweaker_1656, $1656, $75D0)
%define_sprite_table(sprite_tweaker_1662, $1662, $75EA)
%define_sprite_table(sprite_tweaker_166e, $166E, $7600)
%define_sprite_table(sprite_tweaker_167a, $167A, $7616)
%define_sprite_table(sprite_tweaker_1686, $1686, $762C)
%define_sprite_table(sprite_off_screen_vert, $186C, $7642)
%define_sprite_table(sprite_misc_187b, $187B, $3410)
%define_sprite_table(sprite_tweaker_190f, $190F, $7658)
%define_sprite_table(sprite_misc_1fd6, $1FD6, $766E)
%define_sprite_table(sprite_cape_disable_time, $1FE2, $7FD6)
%define_sprite_table("9E", $9E, $3200)
%define_sprite_table("AA", $AA, $9E)
%define_sprite_table("B6", $B6, $B6)
%define_sprite_table("C2", $C2, $D8)
%define_sprite_table("D8", $D8, $3216)
%define_sprite_table("E4", $E4, $322C)
%define_sprite_table("14C8", $14C8, $3242)
%define_sprite_table("14D4", $14D4, $3258)
%define_sprite_table("14E0", $14E0, $326E)
%define_sprite_table("14EC", $14EC, $74C8)
%define_sprite_table("14F8", $14F8, $74DE)
%define_sprite_table("1504", $1504, $74F4)
%define_sprite_table("1510", $1510, $750A)
%define_sprite_table("151C", $151C, $3284)
%define_sprite_table("1528", $1528, $329A)
%define_sprite_table("1534", $1534, $32B0)
%define_sprite_table("1540", $1540, $32C6)
%define_sprite_table("154C", $154C, $32DC)
%define_sprite_table("1558", $1558, $32F2)
%define_sprite_table("1564", $1564, $3308)
%define_sprite_table("1570", $1570, $331E)
%define_sprite_table("157C", $157C, $3334)
%define_sprite_table("1588", $1588, $334A)
%define_sprite_table("1594", $1594, $3360)
%define_sprite_table("15A0", $15A0, $3376)
%define_sprite_table("15AC", $15AC, $338C)
%define_sprite_table("15B8", $15B8, $7520)
%define_sprite_table("15C4", $15C4, $7536)
%define_sprite_table("15D0", $15D0, $754C)
%define_sprite_table("15DC", $15DC, $7562)
%define_sprite_table("15EA", $15EA, $33A2)
%define_sprite_table("15F6", $15F6, $33B8)
%define_sprite_table("1602", $1602, $33CE)
%define_sprite_table("160E", $160E, $33E4)
%define_sprite_table("161A", $161A, $7578)
%define_sprite_table("1626", $1626, $758E)
%define_sprite_table("1632", $1632, $75A4)
%define_sprite_table("163E", $163E, $33FA)
%define_sprite_table("164A", $164A, $75BA)
%define_sprite_table("1656", $1656, $75D0)
%define_sprite_table("1662", $1662, $75EA)
%define_sprite_table("166E", $166E, $7600)
%define_sprite_table("167A", $167A, $7616)
%define_sprite_table("1686", $1686, $762C)
%define_sprite_table("186C", $186C, $7642)
%define_sprite_table("187B", $187B, $3410)
%define_sprite_table("190F", $190F, $7658)
%define_sprite_table("1FD6", $1FD6, $766E)
%define_sprite_table("1FE2", $1FE2, $7FD6)
	
	incsrc "PerLevelHPDefines/Defines.asm"


org $00F5D5
	autoclean JML SmallKillHijack
	
org $01C4BF
	autoclean JML PowerupHijack
freecode


SmallKillHijack:
	;^$00F5D5, The part that checks if Mario is small and receives damage.
	LDA !Freeram_PlayerHPMode
	BEQ .Restore
	CMP #$01
	BNE .AlternateDamage
	
	.OnlyLoseHPWhenSmall
		LDA $19
		BNE .Restore_SkipLoading19Twice
	.AlternateDamage
		if !Setting_HealthSize != 0
			REP #$20
		endif
		LDA !Freeram_PlayerHP
		SEC
		if !Setting_HealthSize == 0
			SBC.b #!Setting_DefaultDamage
		else
			SBC.w #!Setting_DefaultDamage
		endif
		BCS ..NonNegativeHP
		..NegativeHP
			if !Setting_HealthSize == 0
				LDA #$00
			else
				LDA.w #$0000
			endif
		..NonNegativeHP
			STA !Freeram_PlayerHP
		BEQ .Restore_Kill
		if !Setting_HealthSize != 0
			SEP #$20
		endif
		LDA $19
		JML $00F5D9
	
	.Restore
		LDA $19
		..SkipLoading19Twice
		BEQ ..Kill
		JML $00F5D9
	..Kill
		if !Setting_HealthSize != 0
			SEP #$20
		endif
		JML $00F606
PowerupHijack:
	;^$01C4BF, yes the beginning of the general powerup routine.
	; Different compared to the metroid HP patch/player HP meter that I adopted
	; This is because of the handling of a table $01C510 to determine when
	; grabbing a powerup should instead be placed in the item box (e.g. big
	; mario grabbing a mushroom).
	;
	; Also if Super/big Mario grabs a flower or a feather, a Mushroom
	; is added to the item box, allowing the player to heal from a free mushroom
	; which is weird that a "mushroom is extracted from the player".
	;LDA.w $1540,X				;$01C4BF	|| 
	;CMP.b #$18				;$01C4C2	||
	.CheckIfHPMode
		LDA !Freeram_PlayerHPMode
		BEQ .ReturnToSMWCode
	
		LDA !9E,x
		CMP #$74			;>$74 = mushroom
		BEQ .MushroomHeal
		CMP #$75
		BEQ .FlowerFeatherNoItemBox
		CMP #$77
		BEQ .FlowerFeatherNoItemBox
		BRA .ReturnToSMWCode
	.MushroomHeal
		if !Setting_HealthSize != 0
			REP #$20
		endif
		LDA !Freeram_PlayerHP
		CMP !Freeram_PlayerMaxHP
		BCS .ReturnToSMWCode		;If full health, do vanilla things, otherwise heal and maybe grow the player.
		CLC
		if !Setting_HealthSize == 0
			ADC.b #!Setting_DefaultMushroomHeal
		else
			ADC.w #!Setting_DefaultMushroomHeal
		endif
		BCC ..NoOverflow ;If exceeding 255/65535, cap it to max
		..Overflow
			BRA ..SetToMax
		..NoOverflow
			CMP !Freeram_PlayerMaxHP
			BCC ..SetHP ;If no overflow and less than max HP, set it
		..SetToMax
			LDA !Freeram_PlayerMaxHP
		..SetHP
			STA !Freeram_PlayerHP
		if !Setting_HealthSize != 0
			SEP #$20
		endif
		..ConsumeMushroom
			STZ !14C8,x
		;Here is under the conditions the player is not at full health
		;and then healed. Prevent healing AND added to item box,
		;allowing the player to infinitely heal.
		;
		;Also makes it so that if the player transforms OR heals,
		;it won't be added to item box, otherwise if there is any affect
		;on the player, it is consumed.
		LDA $19		;Grow the player if small.
		BEQ ..Grow
		..PointsAndSFX
			JML $01C56F ;Only give points and SFX, no other effects
		..Grow
			;JML $01C561
			LDA #$02
			STA $71
			LDA #$2F
			STA $1496|!addr
			STA $9D
			BRA ..PointsAndSFX
	.FlowerFeatherNoItemBox
		;A HP version of $01C510
		;Makes so that big Mario grabbing a flower or feather not to place a mushroom in the item box.
		STZ !14C8,x			;>Erase sprite
		PHB				;>Preserve bank of whatever was in SMW's code
		PHK				;\Switch bank to whatever this patch's code is in
		PLB				;/
		wdm
		SEC
		SBC #$74			;>Subtract by $74, so that Mushroom, Flower, Star, and then Feather are mapped to $00-$02.
		ASL #2				;>Multiply by 4, so each powerup sprite in a sequence is a jump of 4 bytes; %**PPPPPP -> %PPPPPP00
		ORA $19				;>"Add" (ORA to fill out bits 0 and 1) by player powerup status, which is small, big, cape, and then fire
		TAY				;>Y_value = (PowerupSpriteNumber*4)+MarioPowerup
		LDA.w .ItemBoxHPEdition-4,y
		PLB				;>Restore bank of SMW's code
		CMP #$00			;>Another case where CMP #$00 is needed, because PLB/LDX/LDY affects the N and Z flags when we need to compare A.
		JML $01C543
	.ReturnToSMWCode
		LDA $1540|!addr,x
		CMP #$18
		JML $01C4C4
	.ItemBoxHPEdition
		;   SM  BG  CP  FR    <- powerup prior touching an item: small, big, cape, fire
		db $00,$00,$04,$02   ;>Item box when grabbing a Flower
		db $00,$00,$00,$00   ;>Item box when grabbing a Star (unused?)
		db $00,$00,$04,$02   ;>Item box when grabbing a Feather