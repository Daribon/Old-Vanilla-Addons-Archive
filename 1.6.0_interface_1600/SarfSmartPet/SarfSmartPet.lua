--[[


SarfSmartPet

Adds more intelligence to SmartPet.

Features:

 * Improved Spell Attack - will make sure that the spell is not present on the target before casting it.

]]--


SarfSmartPet_Options_Default = {
	enabled = true;
	doNotCastInCombat = false; -- will not cast the spell if you are already in combat
	alwaysCheckDebuffs = false; -- will make sure to check for the cast spells debuff always
	checkDebuffsByName = false; -- will make sure to check for the debuff spells by name
	checkDebuffsByTexture = true; -- will make sure to check for the debuff spells by texture
	verifyDebuffByName = true; -- will double check the debuffs name (disable to increase performance)
	ignorePresenceAtFullMana = false; -- if enabled, it will bypass detection if the player is at full mana.
};

-- NOTE:
--  Checking by texture is faster, whereas name is safer.
--  Unfortunately, name requires localization.
--  verifyDebuffByName is actually independent of localization (since it uses the internal name) and should be very very quick, but it is still possible to disable it to increase performance.

SarfSmartPet_Options = {};

function SarfSmartPet_OnLoad()
	local f = SarfSmartPetFrame;
	f:RegisterEvent("VARIABLES_LOADED");
	
	SarfSmartPet_Saved_SmartPetSpellAttack = SmartPetSpellAttack;
	SmartPetSpellAttack = SarfSmartPet_SmartPetSpellAttack;
end

function SarfSmartPet_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in SarfSmartPet_Options_Default do
			if ( SarfSmartPet_Options[k] == nil ) then
				SarfSmartPet_Options[k] = v;
			end
		end
	end
end

function SarfSmartPet_SmartPetSpellAttack()
	if ( not SarfSmartPet_Options.enabled ) then
		return SarfSmartPet_Saved_SmartPetSpellAttack();
	end
	if (SmartPet_Config.SpellAttack == false) or (SmartPet_Config.Spell == "") then
		return;
	end
	if ( SarfSmartPet_Options.doNotCastInCombat ) and ( PlayerFrame.inCombat ) then
		return;
	end
	local tex = GetSpellTexture(SmartPet_Config.Spell, SmartPet_Config.SpellBook);
	local name = nil;
	local noCheck = false;
	if ( not noCheck ) and ( SarfSmartPet_Options.ignorePresenceAtFullMana ) then
		if ( UnitMana("player") >= UnitManaMax("player") ) then
			noCheck = true;
		end
	end
	local checkDebuff = SarfSmartPet_Options.alwaysCheckDebuffs;
	if ( not noCheck ) and ( not checkDebuff ) and ( SarfSmartPet_Options.checkDebuffsByName ) then
		name = GetSpellName(SmartPet_Config.Spell, SmartPet_Config.SpellBook);
		for k, v in SARFSMARTPET_DEBUFF_SPELL_NAMES do
			if ( v == name ) then
				checkDebuff = true;
				break;
			end
		end
	end
	if ( not noCheck ) and ( not checkDebuff ) and ( SarfSmartPet_Options.checkDebuffsByTexture ) then
		for k, v in SARFSMARTPET_DEBUFF_SPELL_TEXTURES do
			if ( v == tex ) then
				checkDebuff = true;
				break;
			end
		end
	end
	if ( not noCheck ) and ( checkDebuff ) then
		if ( not name ) and ( SarfSmartPet_Options.verifyDebuffByName ) then
			name = GetSpellName(SmartPet_Config.Spell, SmartPet_Config.SpellBook);
		end
		local i = 1;
		local debuff = UnitDebuff("target", i);
		if ( name ) then
			local text = nil;
			while ( debuff ) do
				if ( debuff == tex ) then
					SarfSmartPetTooltip:SetUnitDebuff("target", i);
					text = SarfSmartPetTooltipTextLeft1:GetText();
					if ( text == name ) then
						return;
					end
				end
				i = i + 1;
				debuff = UnitDebuff("target", i);
			end
		else
			while ( debuff ) do
				if ( debuff == tex ) then
					return;
				end
				i = i + 1;
				debuff = UnitDebuff("target", i);
			end
		end
	end
	CastSpell(SmartPet_Config.Spell, SmartPet_Config.SpellBook);
end

