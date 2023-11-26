ACR_OPTION_RECORD_PLAYER		= false;
ACR_OPTION_CACHE_SKILL_DAMAGE	= true;

ACR_EVENT_MELEE_HIT_ENEMY 	= "CHAT_MSG_COMBAT_SELF_HITS";
ACR_EVENT_SKILL_HIT_ENEMY 	= "CHAT_MSG_SPELL_SELF_DAMAGE";
ACR_EVENT_SKILLS_CHANGED 	= "SPELLS_CHANGED";

ACR_ABILITY_MELEE			= "melee";
ACR_ABILITY_RANGED			= "ranged";


ACR_ICON_DMG_REL_DEBUFFS	=
{
	["Interface\\Icons\\Ability_Warrior_Riposte"] = 1;
	["Interface\\Icons\\Ability_Warrior_Sunder"] = 1;
	["Interface\\Icons\\Nature_Faerie_Fire"] = 1;
	["Interface\\Icons\\Spell_Shadow_LifeDrain"] = 1;
};

-- Refer to ACR_SKILL_TRANSLATE to get indices.
ACR_SKILL_EXTRA_DAMAGE		= 
{
	["HUNTER"] = 
	{
		["Aimed Shot"] =
		{
			{ l = 20; e = 70; },
			{ l = 28; e = 125; },
			{ l = 36; e = 200; },
			{ l = 44; e = 330; },
			{ l = 52; e = 460; },
			{ l = 60; e = 600; }
		};
		["Raptor Strike"] = {
			{ l = 1; e = 5; },
			{ l = 8; e = 11; },
			{ l = 16; e = 21; },
			{ l = 24; e = 34; },
			{ l = 32; e = 50; },
			{ l = 40; e = 80; },
			{ l = 48; e = 110; },
			{ l = 56; e = 140; }
		};
	};
	["ROGUE"] = 
	{
		["Sinister Strike"] =
		{
			{ l = 1; e = 3; },
			{ l = 6; e = 6; },
			{ l = 14; e = 10; },
			{ l = 22; e = 15; },
			{ l = 38; e = 33; },
			{ l = 46; e = 52; },
			{ l = 54; e = 68; }
		};
	};
	["WARRIOR"] = 
	{
		["Heroic Strike"] =
		{
			{ l = 1; e = 11; },
			{ l = 8; e = 21; },
			{ l = 16; e = 32; },
			{ l = 24; e = 44; },
			{ l = 32; e = 58; },
			{ l = 40; e = 80; },
			{ l = 48; e = 111; },
			{ l = 56; e = 138; }
		};
	};
};