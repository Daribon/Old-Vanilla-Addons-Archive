if not ace:LoadTranslation("CardQI") then
--------------------------------------------------------------------------------------

BINDING_HEADER_CARDQIBINDINGS = "Quick Inspect"
BINDING_NAME_CARDQISCANTARGET = "Scan target"
BINDING_NAME_CARDQIINSPECT = "Inspect target"

CARDQI_MAP = {[0]="|cffff5050Off|r",[1]="|cff00ff00On|r",class="|cfff5f530Class|r"}

--------------------------------------------------------------------------------------
--			Strings
--------------------------------------------------------------------------------------

CARDQI_STRINGS = {
	DESCRIPTION = "Scans target's equipement and shows total bonuses.",
	RELEASEDATE = "09/16",
	RESET_DISPLAY = "Display settings have been reset to their defaults",
	RESET_LIST = "The item list has been reset",
	RESET_HOSTILE = "Settings for enemy players have been reset",
	REMOVE_ERR = "Usage : /qi remove item_id",
	REMOVE = "\"%s\" has been removed from the list.",
	ADD_ERR = "Usage : /qi add item_name",
	RANK = "Rank display",
	BONUS = "Bonuses display",
	WEAPONS = "Weapons display",
	SPECIAL = "Special items display",
	RARITY = "Item counter display",
	SETS = "Item sets display",
	CUSTOMLIST = "Custom item list",
	COMPARE = "Comparison tooltip display",
	FORHOSTILEPLAYERS = "for enemy players",
	INVALID_OPTION = "\"%s\" is not a valid option.",
	LIST_IS_EMPTY = "Your item list is empty.",
	NO_BONUS_DETECTED = "No bonus detected.",
	SPEED = "speed",
	TEXT_RANK = "rank",
	BLOCK = "block",
	COMPAREBUTTON = "Compare with target",
}

--------------------------------------------------------------------------------------
--			Slash commands
--------------------------------------------------------------------------------------

CARDQI_CMD_OPTIONS = {
	{option = "scan", desc = "Scan target", method = "ScanInventory"},
	{option = "display", desc = "Set display options", method = "Display", input = TRUE,
		args = {
			{option = "rank", desc = CARDQI_STRINGS.RANK},
			{option = "bonus", desc = CARDQI_STRINGS.BONUS},
			{option = "weapons", desc = CARDQI_STRINGS.WEAPONS},
			{option = "special", desc = CARDQI_STRINGS.SPECIAL},
			{option = "rarity", desc = CARDQI_STRINGS.RARITY},
			{option = "sets", desc = CARDQI_STRINGS.SETS},
		}},
	{option = "hostile", desc = "Set options for enemy players", method = "Hostile", input = TRUE,
		args = {
			{option = "compare", desc = CARDQI_STRINGS.COMPARE},
			{option = "rank", desc = CARDQI_STRINGS.RANK},
			{option = "bonus", desc = CARDQI_STRINGS.BONUS},
			{option = "weapons", desc = CARDQI_STRINGS.WEAPONS},
			{option = "special", desc = CARDQI_STRINGS.SPECIAL},
			{option = "rarity", desc = CARDQI_STRINGS.RARITY},
			{option = "sets", desc = CARDQI_STRINGS.SETS},
		}},
	{option = "add", desc = "Add an item to the list", method = "AddSpecial"},
	{option = "list", desc = "View items in your list", method = "ListSpecial"},
	{option = "remove", desc = "Remove an item from the list", method = "RemoveSpecial"},
	{option = "reset", desc = "Reset display or list options",
		args = {
			{option = "display", desc = "Reset display settings", method = "ResetDisplay"},
			{option = "hostile", desc = "Reset settings for enemy players", method = "ResetHostile"},
			{option = "list", desc = "Reset your item list", method = "ResetList"},
			{option = "all", desc = "Reset all settings", method = "ResetAll"},
		}},
	{option = "compare", desc = CARDQI_STRINGS.COMPARE, method = "Compare", input = TRUE,
		args = {
			{option = "on", desc = "Enable comparison tooltip"},
			{option = "off", desc = "Disable comparison tooltip"},
			{option = "class", desc = "Enable comparison tooltip for players of your class"},
		}},
}

--------------------------------------------------------------------------------------
--			Patterns
--------------------------------------------------------------------------------------

CardQI_Scan = {
	Misc = {
		desc = {"Miscellaneous"},
		Mana5s = {desc = {"Mana/5s"}, bonus = {"Equip: Restores (%d+) mana every 5 sec"}},
		Mana10s = {desc = {"Mana/10s"}, bonus = {"Equip: Restores (%d+) mana every 10 sec"}},
		HP5s = {desc = {"Health/5s"}, bonus = {"Equip: Restores (%d+) health every 5 sec"}},
		Fishing = {desc = {"Fishing"}, bonus = {"Equip: Increased Fishing %+(%d+)"}},
	},
	Stats = {
		desc = {"Stats"},
		Spirit = {desc = {"Spirit"}, bonus = {"%+(%d+) Spirit"}, enchant = {"Spirit %+(%d+)"}},
		Intell = {desc = {"Intellect"}, bonus = {"%+(%d+) Intellect"}, enchant = {"Intellect %+(%d+)"}},
		Stam = {desc = {"Stamina"}, bonus = {"%+(%d+) Stamina"}, enchant = {"Stamina %+(%d+)"}},
		Agi = {desc = {"Agility"}, bonus = {"%+(%d+) Agility"}, enchant = {"Agility %+(%d+)"}},
		Str = {desc = {"Strength"}, bonus = {"%+(%d+) Strength"}, enchant = {"Strength %+(%d+)"}},
		Mana = {desc = {"Mana"},bonus = {"%+(%d+) Mana"}, enchant = {"Mana %+(%d+)"}},
		Armor = {desc = {"Armor"}, bonus = {"(%d+) Armor"}, enchant = {"Reinforced Armor %+(%d+)","Armor %+(%d+)"}},
		HP = {desc = {"Health points"}, enchant = {"Health %+(%d+)", "HP %+(%d+)"}},
		AllStats = {desc = {"All stats"}, enchant = {"All Stats %+(%d+)"}},
	},
	Spells = {
		desc = {"Spells"},
		Heal = {desc = {"Heal"}, bonus = {"Equip: Increases healing done by spells and effects by up to (%d+)"},
			enchant = {"Healing Spells %+(%d+)"}},
		HealAndDmg = {desc = {"Heal and damage"},
			bonus = {"Equip: Increases damage and healing done by magical spells and effects by up to (%d+)"}},
		SpellToHit = {desc = {"Chance to hit with spells","%"},
			bonus = {"Equip: Improves your chance to hit with spells by (%d+)%%"}},
		SpellCrit = {desc = {"Critical strike with spells","%"},
			bonus = {"Equip: Improves your chance to get a critical strike with spells by (%d+)%%"}},
		SpellDmg = {desc = {"Damage"}, enchant = {"Spell Damage %+(%d+)"}},
		FireDmg = {desc = {"Fire damage"}, bonus = {"Equip: Increases damage done by Fire spells and effects by up to (%d+)"}},
		FrostDmg = {desc = {"Frost damage"}, bonus = {"Equip: Increases damage done by Frost spells and effects by up to (%d+)"}},
		ShadowDmg = {desc = {"Shadow damage"}, 
			bonus = {"Equip: Increases damage done by Shadow spells and effects by up to (%d+)"}},
		ArcaneDmg = {desc = {"Arcane damage"},
			bonus = {"Equip: Increases damage done by Arcane spells and effects by up to (%d+)"}},
	},
	Resist = {
		desc = {"Resistances"},
		ResistAll = {desc = {"All resistances"}, enchant = {"%+(%d+) All Resistances"}},
		Fire = {desc = {"Fire",nil,1}, bonus = {"%+(%d+) Fire Resistance"}},
		Nature = {desc = {"Nature",nil,1}, bonus = {"%+(%d+) Nature Resistance"}},
		Frost = {desc = {"Frost",nil,1}, bonus = {"%+(%d+) Frost Resistance"}},
		Arcane = {desc = {"Arcane",nil,1}, bonus = {"%+(%d+) Arcane Resistance"}},
		Shadow = {desc = {"Shadow",nil,1}, bonus = {"%+(%d+) Shadow Resistance"}},
	},
	Combat = {
		desc = {"Combat"},
		Crit = {desc = {"Critical strikes","%"}, bonus = {"Equip: Improves your chance to get a critical strike by (%d+)%%"}},
		Dodge = {desc = {"Dodge","%"}, bonus = {"Equip: Increases your chance to dodge an attack by (%d+)%%"}},
		ToHit = {desc = {"Chance to hit","%"}, bonus = {"Equip: Improves your chance to hit by (%d+)%%"}},
		APower = {desc = {"Attack power"}, bonus = {"Equip: %+(%d+) Attack Power"}},
		Def = {desc = {"Defense"}, bonus = {"Equip: Increased Defense %+(%d+)"}},
		Dagger = { desc = {"Daggers"}, bonus = {"Equip: Increased Daggers %+(%d+)"}},
		Axe = {desc = {"Axes"}, bonus = {"Equip: Increased Axes %+(%d+)"}},
		Sword = {desc = {"Swords"}, bonus = {"Equip: Increased Swords %+(%d+)"}},
		BlockV = {desc = {"Block Value"}, bonus = {"Equip: Increases the block value of your shield by (%d+)"}},
		BlockP = {desc = {"Block Percent","%"}, bonus = {"Equip: Increases your chance to block attacks with a shield by (%d+)%%"}},
		Parry = {desc = {"Parry","%"}, bonus = {"Equip: Increases your chance to parry an attack by (%d+)%%"}},
	},
}

CARDQI_SCAN_DEFAULT_ITEM_LIST = {"Insignia of the","Carrot on a Stick","Nifty Stopwatch"}
CARDQI_SCAN_SPECIAL_ENCHANTS = {"(Minor Speed Increase)","(Mithril Spurs)","Equip: (Immune to Disarm)",
	"Equip: Increases your (stealth detection)"}
CARDQI_SCAN_WEAPONS  = {
	desc = {"Weapons"},
	weaponType = {"(Two%-Hand)","(One%-Hand)","(Main Hand)","(Off Hand)","(Ranged)","(Held In Off%-hand)","(Thrown)"},
	weaponSubType = {"(Mace)","(Sword)","(Dagger)","(Staff)","(Wand)","(Polearm)","(Fishing Pole)","(Axe)","(Bow)",
		"(Crossbow)","(Fist Weapons)","(Gun)","(Shield)","(Thrown)"},
	speed = {"Speed (.+)"},
	dps = {"%((.+) damage per second%)"},
	block = {"(%d+) Block"},
	enchant = {"(Crusader)","(Weapon Damage %+%d+)","(Beastslaying %+%d+)","(Scope %(%+%d+ Damage%))","(Demonslaying)",
		"(Icy Weapon)","(Fiery Weapon)","(Counterweight %+%d+%% Attack Speed)","(Lifestealing)","(Unholy Weapon)"},
}

--------------------------------------------------------------------------------------
end
