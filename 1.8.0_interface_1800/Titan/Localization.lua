function TitanLocalizeEN()
	TITAN_DEBUG = "<Titan>";
	TITAN_INFO = "<Titan>"
	
	TITAN_NA = "N/A";
	TITAN_SECONDS = "seconds";
	TITAN_MINUTES = "minutes";
	TITAN_HOURS = "hours";
	TITAN_DAYS = "days";
	TITAN_SECONDS_ABBR = "s";
	TITAN_MINUTES_ABBR = "m";
	TITAN_HOURS_ABBR = "h";
	TITAN_DAYS_ABBR = "d";
	TITAN_MILLISECOND = "ms";
	TITAN_KILOBYTES_PER_SECOND = "KB/s";
	TITAN_KILOBITS_PER_SECOND = "kbps"
	TITAN_MEGABYTE = "MB";
	
	TITAN_MOVABLE_TOOLTIP = "Drag to move around";
	
	TITAN_PANEL = "Titan Panel";
	TITAN_PANEL_MENU_TITLE = "Titan Panel";
	TITAN_PANEL_MENU_HIDE = "Hide";
	TITAN_PANEL_MENU_CUSTOMIZE = "Customize";
	TITAN_PANEL_MENU_SHOW_COLORED_TEXT = "Show colored text";
	TITAN_PANEL_MENU_SHOW_ICON = "Show icon";
	TITAN_PANEL_MENU_SHOW_LABEL_TEXT = "Show label text";
	TITAN_PANEL_MENU_AUTOHIDE = "Auto-hide";
	TITAN_PANEL_MENU_CENTER_TEXT = "Center text";
	TITAN_PANEL_MENU_DISPLAY_ONTOP = "Display on top";
	TITAN_PANEL_MENU_DISPLAY_BOTH = "Display both bars";
	TITAN_PANEL_MENU_DISABLE_PUSH = "Disable screen adjust";
	TITAN_PANEL_MENU_BUILTINS = "Titan Built-ins";
	TITAN_PANEL_MENU_LEFT_SIDE = "Left Side";
	TITAN_PANEL_MENU_RIGHT_SIDE = "Right Side";
	TITAN_PANEL_MENU_LOAD_SETTINGS = "Load Settings";
	TITAN_PANEL_MENU_DOUBLE_BAR = "Double Bar";
	
	TITAN_AUTOHIDE_TOOLTIP = "Toggles panel auto-hide on/off";
	TITAN_AUTOHIDE_MENU_TEXT = "Auto-hide";
	
	TITAN_AMMO_FORMAT = "%d";
	TITAN_AMMO_BUTTON_LABEL_AMMO = "Ammo: ";
	TITAN_AMMO_BUTTON_LABEL_THROWN = "Thrown: ";
	TITAN_AMMO_BUTTON_LABEL_AMMO_THROWN = "Ammo/Thrown: ";
	TITAN_AMMO_TOOLTIP = "Equipped Ammo/Thrown Count";
	TITAN_AMMO_MENU_TEXT = "Ammo/Thrown";
	TITAN_AMMO_THROWN_KEYWORD = "Throw";
	
	TITAN_BAG_FORMAT = "%d/%d";
	TITAN_BAG_BUTTON_LABEL = "Bags: ";
	TITAN_BAG_TOOLTIP = "Bag Usage";
	TITAN_BAG_TOOLTIP_HINTS = "Hint: Left-click to open all bags.";
	TITAN_BAG_MENU_TEXT = "Bag";
	TITAN_BAG_MENU_SHOW_USED_SLOTS = "Show used slots";
	TITAN_BAG_MENU_SHOW_AVAILABLE_SLOTS = "Show available slots";
	TITAN_BAG_MENU_IGNORE_AMMO_POUCH_SLOTS = "Ignore ammo pouch slots";
	TITAN_BAG_AMMO_POUCH_NAMES = {"Ammo", "Quiver", "Bandolier", "Shot", "Lamina"};
	
	TITAN_CLOCK_TOOLTIP = "Clock";
	TITAN_CLOCK_TOOLTIP_VALUE = "Offset hour value: ";
	TITAN_CLOCK_TOOLTIP_HINT1 = "Hint: Left-click to adjust the offset"
	TITAN_CLOCK_TOOLTIP_HINT2 = "hour and the 12/24H time format.";
	TITAN_CLOCK_CONTROL_TOOLTIP = "Hour Offset: ";
	TITAN_CLOCK_CONTROL_TITLE = "Offset";
	TITAN_CLOCK_CONTROL_HIGH = "+12";
	TITAN_CLOCK_CONTROL_LOW = "-12";
	TITAN_CLOCK_CHECKBUTTON = "24H Fmt";
	TITAN_CLOCK_CHECKBUTTON_TOOLTIP = "Toggles the time display between 12-hour and 24-hour format";
	TITAN_CLOCK_MENU_TEXT = "Clock";
	TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE = "Display on far right side";
	
	TITAN_COORDS_FORMAT = "(%.d, %.d)";
	TITAN_COORDS_BUTTON_LABEL = "Loc: ";
	TITAN_COORDS_TOOLTIP = "Location Info";
	TITAN_COORDS_TOOLTIP_HINTS_1 = "Hint: Shift + left-click to add location";
	TITAN_COORDS_TOOLTIP_HINTS_2 = "info to the chat message.";
	TITAN_COORDS_TOOLTIP_ZONE = "Zone: ";
	TITAN_COORDS_TOOLTIP_SUBZONE = "SubZone: ";
	TITAN_COORDS_TOOLTIP_PVPINFO = "PVP Info: ";
	TITAN_COORDS_TOOLTIP_HOMELOCATION = "Home Location";
	TITAN_COORDS_TOOLTIP_INN = "Inn: ";
	TITAN_COORDS_MENU_TEXT = "Location";
	TITAN_COORDS_MENU_SHOW_ZONE_ON_PANEL_TEXT = "Show zone text";
	TITAN_COORDS_MENU_SHOW_COORDS_ON_MAP_TEXT = "Show coordinates on world map";
	TITAN_COORDS_MAP_COORDS_TEXT = "%d, %d";
	TITAN_COORDS_MAP_CURSOR_COORDS_TEXT = "Cursor(X,Y): %s";
	TITAN_COORDS_MAP_PLAYER_COORDS_TEXT = "Player(X,Y): %s";
	
	TITAN_FPS_FORMAT = "%.1f";
	TITAN_FPS_BUTTON_LABEL = "FPS: ";
	TITAN_FPS_MENU_TEXT = "FPS";
	TITAN_FPS_TOOLTIP_CURRENT_FPS = "Current FPS: ";
	TITAN_FPS_TOOLTIP_AVG_FPS = "Average FPS: ";
	TITAN_FPS_TOOLTIP_MIN_FPS = "Minimum FPS: ";
	TITAN_FPS_TOOLTIP_MAX_FPS = "Maximum FPS: ";
	TITAN_FPS_TOOLTIP = "Frames Per Second";
	
	TITAN_HONOR_BUTTON_LABEL_RANK = RANK..": ";
	TITAN_HONOR_BUTTON_LABEL_HK = "HK: ";
	TITAN_HONOR_BUTTON_LABEL_DK = "DK: ";
	TITAN_HONOR_TOOLTIP = "PVP Honor Info";
	TITAN_HONOR_MENU_TEXT = "PVP Honor";
	
	TITAN_LATENCY_FORMAT = "%d"..TITAN_MILLISECOND;
	TITAN_LATENCY_BANDWIDTH_FORMAT = "%.3f "..TITAN_KILOBYTES_PER_SECOND;
	TITAN_LATENCY_BUTTON_LABEL = "Latency: ";
	TITAN_LATENCY_TOOLTIP = "Network Status";
	TITAN_LATENCY_TOOLTIP_LATENCY = "Latency: ";
	TITAN_LATENCY_TOOLTIP_BANDWIDTH_IN = "Bandwidth in: ";
	TITAN_LATENCY_TOOLTIP_BANDWIDTH_OUT = "Bandwidth out: ";
	TITAN_LATENCY_MENU_TEXT = "Latency";
	
	TITAN_LOOTTYPE_BUTTON_LABEL = "Loot: ";
	TITAN_LOOTTYPE_FREE_FOR_ALL = "Free for all";
	TITAN_LOOTTYPE_ROUND_ROBIN = "Round robin";
	TITAN_LOOTTYPE_MASTER_LOOTER = "Master looter";
	TITAN_LOOTTYPE_GROUP_LOOT = "Group Loot";
	TITAN_LOOTTYPE_NEED_BEFORE_GREED = "Need Before Greed";
	TITAN_LOOTTYPE_TOOLTIP = "Loot Type";
	TITAN_LOOTTYPE_MENU_TEXT = "Loot Type";
	
	TITAN_MEMORY_FORMAT = "%.3f"..TITAN_MEGABYTE;
	TITAN_MEMORY_RATE_FORMAT = "%.3f"..TITAN_KILOBYTES_PER_SECOND;
	TITAN_MEMORY_BUTTON_LABEL = "Memory: ";
	TITAN_MEMORY_TOOLTIP = "Memory Usage";
	TITAN_MEMORY_TOOLTIP_CURRENT_MEMORY = "Current: ";
	TITAN_MEMORY_TOOLTIP_INITIAL_MEMORY = "Initial: ";
	TITAN_MEMORY_TOOLTIP_INCREASING_RATE = "Increasing rate: ";
	TITAN_MEMORY_TOOLTIP_GC_INFO = "Garbage-Collection Info: ";
	TITAN_MEMORY_TOOLTIP_GC_THRESHOLD = "GC threshold: ";
	TITAN_MEMORY_TOOLTIP_TIME_TO_GC = "Time to next GC: "
	TITAN_MEMORY_MENU_TEXT = "Memory";
	TITAN_MEMORY_MENU_RESET_SESSION = "Reset memory data";
	
	TITAN_MONEY_GOLD = "g";
	TITAN_MONEY_SILVER = "s";
	TITAN_MONEY_COPPER = "c";
	TITAN_MONEY_FORMAT = "%d"..TITAN_MONEY_GOLD..", %d"..TITAN_MONEY_SILVER..", %d"..TITAN_MONEY_COPPER;
	TITAN_MONEY_MENU_TEXT = "Money";
	TITAN_MONEY_MENU_RESET_SESSION = "Reset session";
	TITAN_MONEY_TOOLTIP = "Money Fluctuation";
	TITAN_MONEY_TOOLTIP_HINTS = "Hint: Left-click to pick up money.";
	TITAN_MONEY_TOOLTIP_CURRENT = "Current: ";
	TITAN_MONEY_TOOLTIP_INITIAL = "Initial: ";
	TITAN_MONEY_TOOLTIP_EARNED = "Earned: ";
	TITAN_MONEY_TOOLTIP_LOST = "Lost: ";
	TITAN_MONEY_TOOLTIP_EARNED_HOUR = "Earned/hr: ";
	TITAN_MONEY_TOOLTIP_LOST_HOUR = "Lost/hr: ";
	
	TITAN_PERFORMANCE_TOOLTIP = "Performance";
	TITAN_PERFORMANCE_MENU_TEXT = "Performance";
	TITAN_PERFORMANCE_MENU_SHOW_FPS = "Show FPS";
	TITAN_PERFORMANCE_MENU_SHOW_LATENCY = "Show Latency";
	TITAN_PERFORMANCE_MENU_SHOW_MEMORY = "Show Memory";

	TITAN_TRANS_TOOLTIP = "Transparency Control";
	TITAN_TRANS_TOOLTIP_VALUE = "Panel transparency: ";
	TITAN_TRANS_TOOLTIP_HINT1 = "Hint: Left-click to adjust the";
	TITAN_TRANS_TOOLTIP_HINT2 = "transparency of the panel.";
	TITAN_TRANS_CONTROL_TOOLTIP = "Panel Transparency: ";
	TITAN_TRANS_CONTROL_TITLE = "Transparency";
	TITAN_TRANS_CONTROL_HIGH = "100%";
	TITAN_TRANS_CONTROL_LOW = "0%";
	TITAN_TRANS_MENU_TEXT = "Panel Transparency";
	
	TITAN_UISCALE_TOOLTIP = "UI/Panel/Font Scale";
	TITAN_UISCALE_TOOLTIP_VALUE_UI = "UI Scale: ";
	TITAN_UISCALE_TOOLTIP_VALUE_PANEL = "Panel Scale: ";
	TITAN_UISCALE_TOOLTIP_VALUE_FONT = "Font Scale: ";
	TITAN_UISCALE_TOOLTIP_HINT1 = "Hint: Left-click to adjusts the size of";
	TITAN_UISCALE_TOOLTIP_HINT2 = "the panel or game's user interface.";
	TITAN_UISCALE_CONTROL_TOOLTIP_UI = "UI Scale: ";
	TITAN_UISCALE_CONTROL_TOOLTIP_PANEL = "Panel Scale: ";
	TITAN_UISCALE_CONTROL_TOOLTIP_FONT = "Font Scale: ";
	TITAN_UISCALE_CONTROL_TITLE_UI = "UI Scale";
	TITAN_UISCALE_CONTROL_TITLE_PANEL = "Panel Scale";
	TITAN_UISCALE_CONTROL_TITLE_FONT = "Font Scale";
	TITAN_UISCALE_CONTROL_HIGH_UI = "100%";
	TITAN_UISCALE_CONTROL_HIGH_PANEL = "125%";
	TITAN_UISCALE_CONTROL_HIGH_FONT = "200%";
	TITAN_UISCALE_CONTROL_LOW_UI = "64%";
	TITAN_UISCALE_CONTROL_LOW_PANEL = "75%";
	TITAN_UISCALE_CONTROL_LOW_FONT = "50%";
	TITAN_UISCALE_MENU_TEXT = "UI/Panel/Font Scale";
	
	TITAN_VOLUME_TOOLTIP = "Volume Control";
	TITAN_VOLUME_TOOLTIP_VALUE = "Master sound volume: ";
	TITAN_VOLUME_TOOLTIP_HINT1 = "Hint: Left-click to adjust the"
	TITAN_VOLUME_TOOLTIP_HINT2 = "master sound volume.";
	TITAN_VOLUME_CONTROL_TOOLTIP = "Master Sound Volume: ";
	TITAN_VOLUME_CONTROL_TITLE = "Volume";
	TITAN_VOLUME_CONTROL_HIGH = "High";
	TITAN_VOLUME_CONTROL_LOW = "Low";
	TITAN_VOLUME_MENU_TEXT = "Volume";
	
	TITAN_XP_FORMAT = "%d";
	TITAN_XP_PERCENT_FORMAT = TITAN_XP_FORMAT.." (%.1f%%)";
	TITAN_XP_BUTTON_LABEL_XPHR_LEVEL = "XP/hr this level: ";
	TITAN_XP_BUTTON_LABEL_XPHR_SESSION = "XP/hr this session: ";
	TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_LEVEL = "Time to level: ";
	TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_SESSION = "Time to level: ";
	TITAN_XP_TOOLTIP = "Experience(XP) Info";
	TITAN_XP_TOOLTIP_TOTAL_TIME = "Total time played: ";
	TITAN_XP_TOOLTIP_LEVEL_TIME = "Time played this level: ";
	TITAN_XP_TOOLTIP_SESSION_TIME = "Time played this session: ";
	TITAN_XP_TOOLTIP_TOTAL_XP = "Total XP required this level: ";
	TITAN_XP_TOOLTIP_LEVEL_XP = "XP gained this level: ";
	TITAN_XP_TOOLTIP_TOLEVEL_XP = "XP needed to level: ";
	TITAN_XP_TOOLTIP_SESSION_XP = "XP gained this session: ";
	TITAN_XP_TOOLTIP_XPHR_LEVEL = "XP/hr this level: ";
	TITAN_XP_TOOLTIP_XPHR_SESSION = "XP/hr this session: ";
	TITAN_XP_TOOLTIP_TOLEVEL_LEVEL = "Time to level (level rate): ";
	TITAN_XP_TOOLTIP_TOLEVEL_SESSION = "Time to level (session rate): ";
	TITAN_XP_MENU_TEXT = "Experience(XP)";
	TITAN_XP_MENU_SHOW_XPHR_THIS_LEVEL = "Show XP/hr this level";
	TITAN_XP_MENU_SHOW_XPHR_THIS_SESSION = "Show XP/hr this session";
	TITAN_XP_MENU_RESET_SESSION = "Reset session";
	
	TITAN_REGEN_MENU_TEXT 		= "Regen"
	TITAN_REGEN_MENU_TOOLTIP_TITLE	= "Regen Rates"
	TITAN_REGEN_MENU_SHOW1 		= "Show"
	TITAN_REGEN_MENU_SHOW2 		= "HP"
	TITAN_REGEN_MENU_SHOW3 		= "MP"
	TITAN_REGEN_MENU_SHOW4		= "As Percentage"
	TITAN_REGEN_BUTTON_TEXT_HP 		= "HP: "..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_BUTTON_TEXT_HP_PERCENT 	= "HP: "..HIGHLIGHT_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_BUTTON_TEXT_MP 		= " MP: "..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_BUTTON_TEXT_MP_PERCENT 	= " MP: "..HIGHLIGHT_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP1 		= "Health: \t"..GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." / " ..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..RED_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE..")";
	TITAN_REGEN_TOOLTIP2 		= "Mana: \t"..GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." / " ..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..RED_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE..")";
	TITAN_REGEN_TOOLTIP3 		= "Best HP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP4 		= "Worst HP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP5 		= "Best MP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP6 		= "Worst MP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP7		= "MP Regen in Last Fight: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..GREEN_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE.."%%)";

	TITAN_ITEMBONUSES_TEXT = "Item Bonuses";
	TITAN_ITEMBONUSES_DISPLAY_NONE = "Display none";
	TITAN_ITEMBONUSES_SHORTDISPLAY = "Brief label text";
	
	TITAN_ITEMBONUSES_CAT_ATT = "Attributes";
	TITAN_ITEMBONUSES_CAT_RES = "Resistance";
	TITAN_ITEMBONUSES_CAT_SKILL = "Skills";
	TITAN_ITEMBONUSES_CAT_BON = "Melee and ranged combat";
	TITAN_ITEMBONUSES_CAT_SBON = "Spells";
	TITAN_ITEMBONUSES_CAT_OBON = "Life and mana";
		
	-- bonus names
	TITAN_ITEMBONUSES_STR = "Strength";
	TITAN_ITEMBONUSES_AGI = "Agility";
	TITAN_ITEMBONUSES_STA = "Stamina";
	TITAN_ITEMBONUSES_INT = "Intellect";
	TITAN_ITEMBONUSES_SPI = "Spirit";
	TITAN_ITEMBONUSES_ARMOR = "Reinforced Armor";
	
	TITAN_ITEMBONUSES_ARCANERES = "Arcane Resistance";	
	TITAN_ITEMBONUSES_FIRERES	= "Fire Resistance";
	TITAN_ITEMBONUSES_NATURERES = "Nature Resistance";
	TITAN_ITEMBONUSES_FROSTRES	= "Frost Resistance";
	TITAN_ITEMBONUSES_SHADOWRES	= "Shadow Resistance";
	
	TITAN_ITEMBONUSES_FISHING	= "Fishing";
	TITAN_ITEMBONUSES_MINING	= "Mining";
	TITAN_ITEMBONUSES_HERBALISM	= "Herbalism";
	TITAN_ITEMBONUSES_SKINNING	= "Skinning";
	TITAN_ITEMBONUSES_DEFENSE	= "Defense";
		
	TITAN_ITEMBONUSES_BLOCK = "Block";
	TITAN_ITEMBONUSES_DODGE = "Dodge";
	TITAN_ITEMBONUSES_PARRY = "Parry";
	TITAN_ITEMBONUSES_ATTACKPOWER = "Attack Power";
	TITAN_ITEMBONUSES_CRIT = "Crit. hits";
	TITAN_ITEMBONUSES_RANGEDATTACKPOWER = "Ranged Attack Power";
	TITAN_ITEMBONUSES_RANGEDCRIT = "Crit. Shots";
	TITAN_ITEMBONUSES_TOHIT = "Chance to Hit";
	TITAN_ITEMBONUSES_DMG = "Spell Damage";
	TITAN_ITEMBONUSES_ARCANEDMG = "Arcane Damage";
	TITAN_ITEMBONUSES_FIREDMG = "Fire Damage";
	TITAN_ITEMBONUSES_FROSTDMG = "Frost Damage";
	TITAN_ITEMBONUSES_HOLYDMG = "Holy Damage";
	TITAN_ITEMBONUSES_NATUREDMG = "Nature Damage";
	TITAN_ITEMBONUSES_SHADOWDMG = "Shadow Damage";
	TITAN_ITEMBONUSES_SPELLCRIT = "Crit. Spell";
	TITAN_ITEMBONUSES_SPELLTOHIT = "Chance to Hit with spells";
	TITAN_ITEMBONUSES_HEAL = "Healing";
	TITAN_ITEMBONUSES_HOLYCRIT = "Crit. Holy Spell";
	TITAN_ITEMBONUSES_HEALTHREG = "Life Regeneration";
	TITAN_ITEMBONUSES_MANAREG = "Mana Regeneration";
	TITAN_ITEMBONUSES_HEALTH = "Life Points";
	TITAN_ITEMBONUSES_MANA = "Mana Points";	
	
	-- equip and set bonus patterns:
	TITAN_ITEMBONUSES_EQUIP_PREFIX = "Equip: ";
	TITAN_ITEMBONUSES_SET_PREFIX = "Set: ";
	
	TITAN_ITEMBONUSES_EQUIP_PATTERNS = {
		{ pattern = "+(%d+) ranged Attack Power%.", effect = "RANGEDATTACKPOWER" },
		{ pattern = "Increases your chance to block attacks with a shield by (%d+)%%%.", effect = "BLOCK" },
		{ pattern = "Increases your chance to dodge an attack by (%d+)%%%.", effect = "DODGE" },
		{ pattern = "Increases your chance to parry an attack by (%d+)%%%.", effect = "PARRY" },
		{ pattern = "Improves your chance to get a critical strike with spells by (%d+)%%%.", effect = "SPELLCRIT" },
		{ pattern = "Improves your chance to get a critical strike with Holy spells by (%d+)%%%.", effect = "HOLYCRIT" },
		{ pattern = "Improves your chance to get a critical strike by (%d+)%%%.", effect = "CRIT" },
		{ pattern = "Improves your chance to get a critical strike with missile weapons by (%d+)%%%.", effect = "RANGEDCRIT" },
		{ pattern = "Increases damage done by Arcane spells and effects by up to (%d+)%.", effect = "ARCANEDMG" },
		{ pattern = "Increases damage done by Fire spells and effects by up to (%d+)%.", effect = "FIREDMG" },
		{ pattern = "Increases damage done by Frost spells and effects by up to (%d+)%.", effect = "FROSTDMG" },
		{ pattern = "Increases damage done by Holy spells and effects by up to (%d+)%.", effect = "HOLYDMG" },
		{ pattern = "Increases damage done by Nature spells and effects by up to (%d+)%.", effect = "NATUREDMG" },
		{ pattern = "Increases damage done by Shadow spells and effects by up to (%d+)%.", effect = "SHADOWDMG" },
		{ pattern = "Increases healing done by spells and effects by up to (%d+)%.", effect = "HEAL" },
		{ pattern = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", effect = {"HEAL", "DMG"} },
		{ pattern = "Restores (%d+) health every 5 sec%.", effect = "HEALTHREG" },
		{ pattern = "Restores (%d+) mana every 5 sec%.", effect = "MANAREG" },
		{ pattern = "Improves your chance to hit by (%d+)%%%.", effect = "TOHIT" },
		{ pattern = "Improves your chance to hit with spells by (%d+)%%%.", effect = "SPELLTOHIT" }
	};
	
	
	TITAN_ITEMBONUSES_S1 = {
		{ pattern = "Arcane", 	effect = "ARCANE" },	
		{ pattern = "Fire", 	effect = "FIRE" },	
		{ pattern = "Frost", 	effect = "FROST" },	
		{ pattern = "Holy", 	effect = "HOLY" },	
		{ pattern = "Shadow",	effect = "SHADOW" },	
		{ pattern = "Nature", 	effect = "NATURE" }
	}; 	
	
	TITAN_ITEMBONUSES_S2 = {
		{ pattern = "Resist", 	effect = "RES" },	
		{ pattern = "Damage", 	effect = "DMG" },
		{ pattern = "Effects", 	effect = "DMG" },
	}; 	
		
	TITAN_ITEMBONUSES_TOKEN_EFFECT = {
		["All Stats"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
		["Strength"]			= "STR",
		["Agility"]				= "AGI",
		["Stamina"]				= "STA",
		["Intellect"]			= "INT",
		["Spirit"] 				= "SPI",
	
		["All Resistances"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},
	
		["Fishing"]				= "FISHING",
		["Fishing Lure"]		= "FISHING",
		["Increased Fishing"]	= "FISHING",
		["Mining"]				= "MINING",
		["Herbalism"]			= "HERBALISM",
		["Skinning"]			= "SKINNING",
		["Defense"]				= "DEFENSE",
		["Increased Defense"]	= "DEFENSE",
	
		["Attack Power"] 		= "ATTACKPOWER",
		["Dodge"] 				= "DODGE",
		["Block"]				= "BLOCK",
		["Hit"] 				= "TOHIT",
		["Spell Hit"]			= "SPELLTOHIT",
		["Blocking"]			= "BLOCK",
		["Ranged Attack Power"] = "RANGEDATTACKPOWER",
		["health every 5 sec"] = "HEALTHREG",
		["Healing Spells"] 		= "HEAL",
		["Increases Healing"] 	= "HEAL",
		["Healing and Spell Damage"] = {"HEAL", "DMG"},
		["mana every 5 sec"] 	= "MANAREG",
		["Mana Regen"] 			= "MANAREG",
		["Spell Damage"] 		= "DMG",
		["Critical"] 			= "CRIT",
		["Critical Hit"] 		= "CRIT",
		["Damage"] 				= "DMG",
		["Health"]				= "HEALTH",
		["HP"]				= "HEALTH",
		["Mana"]				= "MANA",
		["Armor"]				= "ARMOR",
		["Reinforced Armor"]	= "ARMOR",
	};	
	
	TITAN_ITEMBONUSES_OTHER_PATTERNS = {
		{ pattern = "Mana Regen (%d+) per 5 sec%.", effect = "MANAREG" },
		{ pattern = "Zandalar Signet of Might", effect = "ATTACKPOWER", value = 30 },
		{ pattern = "Zandalar Signet of Mojo", effect = {"DMG", "HEAL"}, value = 18 },
		{ pattern = "Zandalar Signet of Serenity", effect = "HEAL", value = 33 }
	};

	TITAN_HONORPLUS_BUTTON_LABEL_RANK = RANK..": ";
	TITAN_HONORPLUS_CLASSINDEX = {
		["Druid"]   = 1,
		["Hunter"]  = 2,
		["Mage"]    = 3,
		["Paladin"] = 4,
		["Priest"]  = 5,
		["Rogue"]   = 6,
		["Shaman"]  = 7,
		["Warlock"] = 8,
		["Warrior"] = 9,
		["Druide"] = 1,
		["J\195\164ger"] = 2,
		["Magier"] = 3,
		["Paladin"] = 4,
		["Priester"] = 5,
		["Schurke"] = 6,
		["Schamane"] = 7,
		["Hexenmeister"] = 8,
		["Krieger"] = 9,
		["Druide"] = 1,
		["Chasseur"] = 2,
		["Mage"] = 3,
		["Paladin"] = 4,
		["Pr\195\170tre"] = 5,
		["Voleur"] = 6,
		["Chaman"] = 7,
		["D\195\169moniste"] = 8,
		["Guerrier"] = 9,
	};
	
	TITAN_HONORPLUS_BUTTON_LABEL_HK = "HK: ";
	TITAN_HONORPLUS_BUTTON_LABEL_DK = "DK: ";
	TITAN_HONORPLUS_TOOLTIP = "PVP Honor+ Info";
	TITAN_HONORPLUS_TOOLTIP_THISWEEK = "This Week"
	TITAN_HONORPLUS_MENU_TEXT = "Honor+";
	TITAN_HONORPLUS_MENU_CALCTODAY = "Add-on Calculates Today's HK";
	TITAN_HONORPLUS_MENU_SCT = "Scrolling Combat Text Display";
	TITAN_HONORPLUS_MENU_OPIUM = "Opium Support";
	TITAN_HONORPLUS_MENU_SCOREBOARDCLASSCOLORSYMBOL = "Scoreboard Color Class Symbol";
	TITAN_HONORPLUS_MENU_SCOREBOARDCLASSCOLORLIST = "Scoreboard Color Class Name";
	TITAN_HONORPLUS_MENU_SCOREBOARDKILLS = "Show Today's Kills on Scoreboard";
	TITAN_HONORPLUS_MENU_PRINTBONUS = "Display Bonus Honor in Chat Window";
	TITAN_HONORPLUS_MENU_TOOLTIP = "Show Tooltip Info";
	TITAN_HONORPLUS_MENU_SORTBYHONOR = "Sort by Honor";
	TITAN_HONORPLUS_MENU_SORTBYKILLS = "Sort by Kills";
	TITAN_HONORPLUS_ESTIMATED = "%s dies, [%d times today.], Rank: %s. [Educated Honor: %d]";
	TITAN_HONORPLUS_BONUSHONORGAINED = "You gain %s bonus honor.";
	TITAN_HONORPLUS_BONUS = "Bonus";
	TITAN_HONORPLUS_PROGRESS = "Progress";
	TITAN_HONORPLUS_TODAYHONOR = "Today's Honor";
	TITAN_HONORPLUS_KILLS = "Kills";
	TITAN_HONORPLUS_DEATHS = "Deaths";
	TITAN_HONORPLUS_TOTAL = "Total";
	TITAN_HONORPLUS_TOP15 = "Top 15";
	TITAN_HONORPLUS_PVPSTATS = "PvP Stats";
	TITAN_HONORPLUS_NOKILLS = "No kills";
	TITAN_HONORPLUS_HINT = "Hint: Left-click for different statistics.";
	TITAN_HONORPLUS_HINT_TOOLTIP = "(Left click for more)";
	TITAN_HONORPLUS_TOOLTIP_TODAYSKILLS = "Number of kills today.\nIf more than 4 kills, then no more honor from this player.";
	TITAN_HONORPLUS_KILLEDTODAY = "Killed Today";
	TITAN_HONORPLUS_MENU_AUTORELEASE = "Auto-Release";
	TITAN_HONORPLUS_MENU_AUTOJOINBG = "Auto-Join Battlegrounds";
	TITAN_HONORPLUS_AUTOJOINBG = "Auto-joining battlegrounds in 10 seconds...";
	TITAN_HONORPLUS_AUTOJOINBG_CANCEL = "Cancelled joining battlegrounds.";
	TITAN_HONORPLUS_AUTOJOINBG_DONE = "Now joining battlegrounds. Good luck!";

	--Titan Repair
	REPAIR_LOCALE = {
		pattern = "^Durability (%d+) / (%d+)$",
		menu = "Durability Info",
		tooltip = "Durability Info",
		button = "Durability: ",
		percentage = "Show as Percentage",
		itemname = "Show Item Name",
		undamaged = "Show undamaged Items",
		nothing = "Nothing damaged",
		confirmation = "Do you want to repair all equipped Items?"
	};

	TITAN_PLUGINS_MENU_TITLE = "Plug-ins";
	
	CUSTOMIZATION_FEATURE_COMING_SOON = "Customization feature coming soon...";
end

function Localize()
	TitanLocalizeEN();
	
	local locale = GetLocale();
	if ( locale == "deDE" ) then
		TitanLocalizeDE();
	elseif ( locale == "frFR" ) then
		TitanLocalizeFR();
	end
end

function LocalizeFrames()
	-- Put all locale specific UI adjustments here
end