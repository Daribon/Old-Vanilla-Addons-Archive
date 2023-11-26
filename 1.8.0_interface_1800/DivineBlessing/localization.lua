-- The Addon name (the directory / toc name)
DIVINEBLESSING_ADDON_NAME				= "DivineBlessing"

-- Key Bindings
BINDING_HEADER_DIVINEBLESSING 			= "Divine Blessing";
BINDING_NAME_BLESSINGSET1 				= "Use Blessing Set A";
BINDING_NAME_BLESSINGSET2 				= "Use Blessing Set B";
BINDING_NAME_BLESSINGSET3 				= "Use Blessing Set C";
BINDING_NAME_BLESSINGSET4 				= "Use Blessing Set D";
BINDING_NAME_BLESSINGSET5 				= "Use Blessing Set E";
BINDING_NAME_BLESSINGSET6 				= "Use Blessing Set F";
BINDING_NAME_BLESSINGSETCLASS 			= "Use Class Blessing Set";
BINDING_NAME_BLESSINGSETRAID			= "Use Raid Blessing Set";
BINDING_NAME_BLESSINGSHOW				= "Toggle Divine Blessing Config";

-- Cosmos/Khaos Regstration
DIVINEBLESSING_KHAOS_ID					= "DivineBlessing";
DIVINEBLESSING_BUTTON_NAME				= "Divine Blessing";
DIVINEBLESSING_BUTTON_SUBTITLE			= "Blessing Sets";
DIVINEBLESSING_BUTTON_DESCRIPTION		= "This allows you to organize \nspells into one button sets";
DIVINEBLESSING_BUTTON_ICON				= "Interface\\Icons\\Spell_Holy_SealOfFury"

-- Display Strings
DIVINEBLESSING_VERSION					= "2.0"
DIVINEBLESSING_TITLE					= "|cffee9966Divine Blessing|r ("..DIVINEBLESSING_VERSION..")"
DIVINEBLESSING_LOADED_FORMAT_STRING		= "|cffffff00Divine Blessing "..DIVINEBLESSING_VERSION.."|r |cffeeeeaa - Settings for '|cffffffff%s|cffeeeeaa' loaded.|r|n  Type |cffeeeeaa/divineblessing help|r for more information."

-- Set Names
DIVINEBLESSING_PARTY_SET				= "Blessing Set"
DIVINEBLESSING_CLASS_SET				= "Class Blessing Set"
DIVINEBLESSING_RAID_SET					= "Raid Blessing Set"
DIVINEBLESSING_UNKNOWN_SET				= "Unknown Blessing Set (%d)"

DIVINEBLESSING_RESET_FORMAT				= "%s reset to the beginning."

-- Creature Types
DIVINEBLESSING_CREATURE_BEAST			= "Beast"
DIVINEBLESSING_CREATURE_DEMON			= "Demon"

-- Slash Command Regex
DIVINEBLESSING_REGEX_CHAT_COMMAND		= "^([^ ]+) (.+)$"

-- Slash Commands
SLASH_DIVINEBLESSING1					= "/divineblessing";
SLASH_DIVINEBLESSING2					= "/db";
SLASH_BLESS1							= "/bless";

DIVINEBLESSING_CMD_RESET				= "reset"
DIVINEBLESSING_CMD_RESETALL				= "resetall"

-- Help
DIVINEBLESSING_HELP_DEFAULT = {
		[1] = "|cffeeee66DivineBlessing Slash Commands:|r (|cffeeee66/db|r can be used in place of |cffeeee66/divineblessing|r)",
		[2] = " |cffeeee66/divineblessing|r : Toggle the Divine Blessing configuration window",
		[3] = " |cffeeee66/divineblessing help|r : Display this help message",
		[4] = " |cffeeee66/divineblessing reset <set>|r : Reset the specified set to the beginning",
		[5] = " |cffeeee66/divineblessing resetall|r : Reset all sets to the beginning",
		[6] = " |cffeeee66/bless <set>|r : Cast the next spell in the specified set:",
		[7] = "     |cffeeee66A|r-|cffeeee66F|r or |cffeeee661|r-|cffeeee666|r for party sets",
		[8] = "     |cffeeee66CLASS|r or |cffeeee667|r for class-based party buffing",
		[9] = "     |cffeeee66RAID|r or |cffeeee668|r for class-based raid buffing",
	}
