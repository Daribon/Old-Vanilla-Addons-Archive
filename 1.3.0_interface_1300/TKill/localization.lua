TKill_Rank_String = "(Rank 1)";

-- unlikely to change in differently localized versions, but you never know, besides, the spells are here, so why not.
TKill_UnitIsMarkedForDeath_Data = {
	--[[
	["Priest"] = {
		{ 
			name = "Shadow Word: Pain",
			texture = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
		},
	},
	]]--
};

TKill_Spells = {
	["Druid"] = {
		{ name = "Moonfire", rank = TKill_Rank_String }
	},
	["Hunter"] = {
		{ name = "Arcane Shot", rank = TKill_Rank_String }, 
		{ name = "Multi Shot", rank = TKill_Rank_String },
		{ name = "Serpent Sting", rank = TKill_Rank_String },
		{ action = PetAttack },
	},
	["Mage"] = {
		{ name = "Fire Blast", rank = TKill_Rank_String },
		{ name = "Shoot" },
	},
	["Priest"] = {
		{ name = "Shoot" },
		--{ name = "Shadow Word: Pain", rank = TKill_Rank_String },
	},
	["Warlock"] = {
		{ name = "Shoot" },
		{ action = PetAttack },
	},
	["Shaman"] = {
		{ name = "Earth Shock", rank = TKill_Rank_String },
	},
};

TKill_TotemMoreHealthList = {
	["Stoneclaw Totem"] = {
		50,
		150,
		220,
		280,
		390,
		480
	},
	["Sentry Totem"] = {
		100,
	},
};

TKill_TotemList_All = {
	"Grounding Totem",
	"Earthbind Totem",
	"Tremor Totem",
	"Windfury Totem",
	"Flametongue Totem",
	"Windwall Totem",
	"Fire Nova Totem",
	"Searing Totem",
	"Grace of Air Totem",
	"Fire Resistance Totem",
	"Nature Resistance Totem",
	"Frost Resistance Totem",
	"Mana Tide Totem",
	"Healing Totem",
	"Strength of Earth Totem",
	"Magma Totem",
	"Fire Nova Totem",
	"Mana Spring Totem",
	--"Stoneclaw Totem", -- this totem is PvE only, and can be ignored
	"Sentry Totem", -- this totem does not do anything in combat and can be ignored but is "corpsecamp heaven" according to informed sources.
	"Healing Ward", -- mob spell
};

TKill_TotemList_PvP = {
	"Grounding Totem",
	"Earthbind Totem",
	"Tremor Totem",
	"Windfury Totem",
	"Flametongue Totem",
	"Windwall Totem",
	"Searing Totem",
	"Grace of Air Totem",
	"Fire Resistance Totem",
	"Nature Resistance Totem",
	"Frost Resistance Totem",
	"Mana Tide Totem",
	"Healing Totem",
	"Strength of Earth Totem",
	"Magma Totem",
	"Fire Nova Totem",
	"Mana Spring Totem",
	--"Stoneclaw Totem", -- this totem is PvE only, and can be ignored
	"Sentry Totem", -- this totem does not do anything in combat and can be ignored but is "corpsecamp heaven" according to informed sources.
};

TKill_TotemList_PvE = TKill_TotemList_PvP;

TKill_TotemList_PvE_DireMaul = TKill_TotemList_PvE;
TKill_TotemList_PvE_Gnomeregon = TKill_TotemList_PvE;
TKill_TotemList_PvE_Uldaman = TKill_TotemList_PvE;

-- the "index" should be equal to the mode
TKill_TotemList = {
	["PvE"] = TKill_TotemList_PvE,
	["PvP"] = TKill_TotemList_PvP,
	["Dire Maul"] = TKill_TotemList_PvE_DireMaul,
	["Gnomeregon"] = TKill_TotemList_PvE_Gnomeregon,
	["Uldaman"] = TKill_TotemList_PvE_Uldaman,
};
--"anything else you wanna kill thats hostile, not dead, and not a player",  --you can change those checks tho...
--This is the priority list basically.  The higher up, the sooner it gets checked.
--ALSO- the shorter it is, the faster the main loop runs.

TKill_Toggle_Enable 					= "enabled";
TKill_Toggle_Disable 					= "disabled";

TKill_AutoMode_Toggle 					= "TKill: automatic mode switching %s.";
TKill_Mode_Switch 						= "TKill: mode switched to '%s'.";
TKill_Mode_NotFound 					= "TKill: mode '%s' not found.";

TKill_AutoKillMode_Toggle 				= "TKill: autokill %s.";
TKill_ShowSplashMode_Toggle				= "TKill: splash message %s.";
TKill_AssumeHostileMode_Toggle			= "TKill: assume hostile totem casters %s.";
TKill_OnlyHandleQueueMode_Toggle		= "TKill: only handle queued items %s.";
TKill_ListMode_Text 					= "TKill list of modes:";

TKill_Slash_Command_Kill 				= {"kill"};
TKill_Slash_Command_AutoMode 			= {"auto"};
TKill_Slash_Command_Mode 				= {"mode"};
TKill_Slash_Command_ListMode 			= {"list"};
TKill_Slash_Command_AutoKillMode		= {"autokill"};
TKill_Slash_Command_ShowSplashMode		= {"splash"};
TKill_Slash_Command_AssumeHostileMode	= {"hostile"};
TKill_Slash_Command_OnlyHandleQueueMode	= {"queue"};

TKill_Slash_Help = {};
table.insert(TKill_Slash_Help, " Usage: /tkill [kill/<command>] [params...]");
table.insert(TKill_Slash_Help, "defaults to kill");
table.insert(TKill_Slash_Help, "");
table.insert(TKill_Slash_Help, "Slash commands:");
table.insert(TKill_Slash_Help, " kill - tries to kill a totem");
table.insert(TKill_Slash_Help, " automode - toggles automatic mode switching on and off");
table.insert(TKill_Slash_Help, " listmode - lists all valid modes");
table.insert(TKill_Slash_Help, " mode <new mode> - switch to mode <new mode>");
if ( SpellQueue_QueueSpellAdvanced ) then
	table.insert(TKill_Slash_Help, " autokill - toggles auto kill mode (requires SpellQueue AddOn)");
end
table.insert(TKill_Slash_Help, " splash - toggles showing of splash message (when a totem is dropped)");
table.insert(TKill_Slash_Help, " chat - toggles monitoring of chat messages (to detect when totems are dropped)");
table.insert(TKill_Slash_Help, " assumehostile - toggles assumption of all casters of totems to be hostile (only party/raid will be checked)\n   this option is ALWAYS ON for Alliance and for Horde in PvE, but you can force it to always be on if you wish.");
table.insert(TKill_Slash_Help, " onlyhandlequeue - toggles whether to ONLY target dropped totems or target stuff on its own (and queued totems)");

TKILL_NOTHING_FOUND_MESSAGE				= "Nothing found to kill.";
TKILL_QUEUE_MESSAGE						= "Totem Killer wants to kill!";

if ( not TKILL_ITEMS_LIFESPAN ) then
	TKILL_ITEMS_LIFESPAN = {};
end
TKILL_ITEMS_LIFESPAN["Fire Nova Totem"] = 5;

TKILL_FACTIONGROUP_ALLIANCE		= "Alliance";
TKILL_FACTIONGROUP_HORDE		= "Horde";

-- easy-fix solution for parsing chat messages
function TKill_Event_Chat_Localized(msg)
	for whom, spellName in string.gfind(msg, SPELLCASTGOOTHER) do
		for k, v in TKill_TotemList_All do
			if ( v == spellName ) then
				TKill_Handle_CastTotem(whom, spellName);
				return;
			end
		end
	end
end

