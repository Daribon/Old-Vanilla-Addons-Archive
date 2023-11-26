-- Array with information on what locales are supported.
ACR_SUPPORTED_LOCALE		= 
{
	["enUS"] = 1;
	["enGB"] = 1;
};

-- Messages (does not need to be localized for the addon to work).

ACR_MSG_UNSUPPORTED_LOCALE	= "ArmorCalculatorRecorder does not support the current locale.\nThis means that ACR will not work.";

-- Language dependent mandatory strings (need to be localized for the addon to work).

ACR_LNG_PLAYER_HIT_REGEXP 	= "You hit (.+) for ([0-9]+)%."; -- COMBATHITSELFOTHER

-- Language dependent optional strings (set to nil if not implemented).

ACR_LNGOPT_PLAYER_SKILL_HIT_REGEXP	= "Your (.+) hits (.+) for ([0-9]+)%."; -- SPELLLOGSELFOTHER
ACR_LNGOPT_NAME_DMG_REL_DEBUFFS		= 
{
	["Expose Armor"] = 1;
	["Sunder Armor"] = 1;
	["Phantom Blade"] = 1;
	["Faerie Fire"] = 1;
	["Hemorrhage"] = 1;
};

ACR_LNGOPT_RANGED_SKILLS		= 
{
	["Auto Shot"] = 1;
	["Shoot Gun"] = 1;
	["Shoot Crossbow"] = 1;
	["Shoot Bow"] = 1;
	["Throwing"] = 1;
};

ACR_LNGOPT_EXTRA_SKILLS			= 
{
	[ACR_ABILITY_MELEE] 		=
	{
		["Sinister Strike"] = 1;
		["Raptor Strike"] = 1;
	};
	[ACR_ABILITY_RANGED] 		=
	{
		["Aimed Shot"] = 1;
	};
};

--- This allows indices to the ACR_SKILL_EXTRA_DAMAGE.
--
ACR_SKILL_TRANSLATE			= {
	["Heroic Strike"] = "Heroic Strike";
	["Sinister Strike"] = "Sinister Strike";
	["Aimed Shot"] = "Aimed Shot";
};

--- This allows for fine-tuning of the regular expressions used to extract info from the tooltips.
-- It is probably better to just do a class/level offset instead.
-- pattern, match, func, index
ACR_LNGOPT_EXTRA_SKILLS_TOOLTIP_REGEXP	=
{
	--[[
	["Sinister Strike"] = {
		pattern = "([0-9]+)";
		match = 1;
	};
	["Aimed Shot"] = {
		pattern = "([0-9]+)";
		match = 1;
		index = 5;
	};
	["Heroic Strike"] = {
		pattern = "([0-9]+)";
		match = 1;
	};
	]]--
};


-- Functions that may need to be overridden.

--- Executed OnLoad.
-- This function is meant to be used for stuff that need other addons or 
-- in-game data. It is called automatically OnLoad.
-- @return true if initialization is OK, otherwise false.
function ArmorCalculatorRecorder_InitiateLocalization()
	return true;
end


--- Interprets a hit message and adds the data to the database if appropriate.
-- @usage ArmorCalculatorRecorder_InterpretHit(arg1, event); in any OnEvent handler.
-- @param msg The event message to be interpreted
-- @param event The name of the event
-- @return name of the hurt entity, the amount of damage done and finally what ability did the damaging
function ArmorCalculatorRecorder_InterpretHit(msg, event)
	if ( event == ACR_EVENT_MELEE_HIT_ENEMY ) then
		for name, damage in string.gfind(msg, ACR_LNG_PLAYER_HIT_REGEXP) do
			return name, damage, ACR_ABILITY_MELEE;
		end
	elseif ( event == ACR_EVENT_SKILL_HIT_ENEMY ) and ( ACR_LNGOPT_PLAYER_SKILL_HIT_REGEXP ) then
		for skill, name, damage in string.gfind(msg, ACR_LNGOPT_PLAYER_SKILL_HIT_REGEXP) do
			if ( ACR_LNGOPT_RANGED_SKILLS ) and ( ACR_LNGOPT_RANGED_SKILLS[skill] ) then
				return name, damage, ACR_ABILITY_RANGED;
			else
				return name, damage, skill;
			end
		end
	end
	return nil, nil, nil;
end

