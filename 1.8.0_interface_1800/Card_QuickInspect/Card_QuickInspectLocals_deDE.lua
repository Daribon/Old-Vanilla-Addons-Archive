function CardQI_Locals_deDE()
BINDING_HEADER_CARDQIBINDINGS = "Schnelle Analyse"
BINDING_NAME_CARDQISCANTARGET = "Ziel analysieren"
BINDING_NAME_CARDQIINSPECT = "Betrachten"

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
			{option = "rank", desc = CARDQI_TEXT_RANK},
			{option = "bonus", desc = CARDQI_TEXT_BONUS},
			{option = "weapons", desc = CARDQI_TEXT_WEAPONS},
			{option = "special", desc = CARDQI_TEXT_SPECIAL},
			{option = "rarity", desc = CARDQI_TEXT_RARITY},
			{option = "sets", desc = CARDQI_TEXT_SETS},
		}},
	{option = "hostile", desc = "Set options for enemy players", method = "Hostile", input = TRUE,
		args = {
			{option = "compare", desc = CARDQI_TEXT_COMPARE},
			{option = "rank", desc = CARDQI_TEXT_RANK},
			{option = "bonus", desc = CARDQI_TEXT_BONUS},
			{option = "weapons", desc = CARDQI_TEXT_WEAPONS},
			{option = "special", desc = CARDQI_TEXT_SPECIAL},
			{option = "rarity", desc = CARDQI_TEXT_RARITY},
			{option = "sets", desc = CARDQI_TEXT_SETS},
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
	{option = "compare", desc = CARDQI_TEXT_COMPARE, method = "Compare", input = TRUE,
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
		desc = {"Verschiedenes"},
		Mana5s = {desc = {"Mana/5s"}, bonus = {"Verwenden: Stellt alle 5 Sek. (%d+) Punkt(e) Mana wieder her"}},
		Mana10s = {desc = {"Mana/10s"}, bonus = {"Verwenden: Stellt alle 10 Sek. (%d+) Punkt(e) Mana wieder her"}},
		HP5s = {desc = {"Gesundheit/5s"}, bonus = {"Verwenden: Stellt alle 5 Sek. (%d+) Punkt(e) Gesundheit wieder her"}},
		Fishing = {desc = {"Angeln"}, bonus = {"Verwenden: Angeln %+(%d+)"}},
	},
	Stats = {
		desc = {"Stats"},
		Spirit = {desc = {"Willenskraft"}, bonus = {"%+(%d+) Willenskraft"}, enchant = {"Willenskraft %+(%d+)"}},
		Intell = {desc = {"Intelligenz"}, bonus = {"%+(%d+) Intelligenz"}, enchant = {"Intelligenz %+(%d+)"}},
		Stam = {desc = {"Ausdauer"}, bonus = {"%+(%d+) Ausdauer"}, enchant = {"Ausdauer %+(%d+)"}},
		Agi = {desc = {"Beweglichkeit"}, bonus = {"%+(%d+) Beweglichkeit"}, enchant = {"Beweglichkeit %+(%d+)"}},
		Str = {desc = {"St\195\164rke"}, bonus = {"%+(%d+) St\195\164rke"}, enchant = {"St\195\164rke %+(%d+)"}},
		Mana = {desc = {"Mana"},bonus = {"%+(%d+) Mana"}, enchant = {"Mana %+(%d+)"}},
		Armor = {desc = {"Verteidigung"}, bonus = {"(%d+) Verteidigung"}, enchant = {"Reinforced Armor %+(%d+)","Armor %+(%d+)"}},
		HP = {desc = {"Gesundheit"}, enchant = {"Gesundheit %+(%d+)", "GP %+(%d+)"}},
		AllStats = {desc = {"Alle Werte"}, enchant = {"Alle Werte %+(%d+)"}},
	},
	Spells = {
		desc = {"Zauber"},
		Heal = {desc = {"Heilzauber"}, bonus = {"Verwenden: Erh\195\182ht durch Zauber und Effekte verursachte Heilung um bis zu (%d+)"},
			enchant = {"Heilzauber %+(%d+)"}},
		HealAndDmg = {desc = {"Heil- und Schadenszauber"},
			bonus = {"Verwenden: Erh\195\182ht durch magische Zauber und magische Effekte zugef\195\188gten Schaden und Heilung um bis zu (%d+)"}},
		SpellToHit = {desc = {"Chance mit Zaubern zu treffen","%"},
			bonus = {"Verwenden: Erh\195\182ht Eure Chance mit Zaubern zu treffen um (%d+)%%"}},
		SpellCrit = {desc = {"Kritischer Schlag durch Zauber","%"},
			bonus = {"Verwenden: Erh\195\182ht Eure Chance, einen kritischen Schlag durch Zauber zu erzielen, um (%d+)%%"}},
		SpellDmg = {desc = {"Schaden"}, enchant = {"Zauberschaden %+(%d+)"}},
		FireDmg = {desc = {"Feuerschaden"}, bonus = {"Verwenden: Erh\195\182ht durch Feuerzauber und Feuereffekte zugef\195\188gten Schaden um bis zu (%d+)"}},
		FrostDmg = {desc = {"Frostschaden"}, bonus = {"Verwenden: Erh\195\182ht durch Frostzauber und Frosteffekte zugef\195\188gten Schaden um bis zu (%d+)"}},
		ShadowDmg = {desc = {"Schattenschaden"}, 
			bonus = {"Verwenden: Erh\195\182ht durch Schattenzauber und Schatteneffekte zugef\195\188gten Schaden um bis zu (%d+)"}},
		ArcaneDmg = {desc = {"Arkanschaden"},
			bonus = {"Verwenden: Verwenden: Erh\195\182ht durch Arkanzauber und Arkaneffekte zugef\195\188gten Schaden um bis zu (%d+)"}},
		HolyCrit = {desc = {"Crit. strike with holy spells","%"}, 
			bonus = {"Equip: Increases the critical effect chance of your Holy spells by (%d+)%%"}},
	},
	Resist = {
		desc = {"Widerst\195\164nde"},
		ResistAll = {desc = {"Alle Widerstandsarten"}, enchant = {"Alle Widerstandsarten %+(%d+)"}},
		Fire = {desc = {"Feuer"}, bonus = {"%+(%d+) Feuerwiderstand"}},
		Nature = {desc = {"Natur"}, bonus = {"%+(%d+) Naturwiderstand"}},
		Frost = {desc = {"Frost"}, bonus = {"%+(%d+) Frostwiderstand"}},
		Arcane = {desc = {"Arkan"}, bonus = {"%+(%d+) Arkanwiderstand"}},
		Shadow = {desc = {"Schatten"}, bonus = {"%+(%d+) Schattenwiderstand"}},
	},
	Combat = {
		desc = {"Kampf"},
		Crit = {desc = {"Kritische Schl\195\164ge","%"}, bonus = {"Verwenden: Erh\195\182ht Eure Chance, einen kritischen Schlag zu erzielen, um (%d+)%%"}},
		Dodge = {desc = {"Ausweichchance","%"}, bonus = {"Verwenden: Erh\195\182ht Eure Chance, einem Angriff auszuweichen, um (%d+)%%"}},
		ToHit = {desc = {"Trefferchance","%"}, bonus = {"Verwenden: Verbessert Eure Trefferchance um (%d+)%%"}},
		APower = {desc = {"Angriffskraft"}, bonus = {"Verwenden: %+(%d+) Angriffskraft"}},
		Def = {desc = {"Verteidigung"}, bonus = {"Verwenden: Verteidigung %+(%d+)"}},
		Dagger = { desc = {"Dolche"}, bonus = {"Verwenden: Dolche %+(%d+)"}},
		Axe = {desc = {"\195\134xte"}, bonus = {"Verwenden: \195\134xte %+(%d+)"}},
		Sword = {desc = {"Zweihandschwerter"}, bonus = {"Verwenden: Zweihandschwerter %+(%d+)"}},
		BlockV = {desc = {"Block Value"}, bonus = {"Verwenden: Erh\195\182ht den Blockwert Eures Schildes um (%d+)"}},
		BlockP = {desc = {"Block Percent","%"}, bonus = {"Verwenden: Erh\195\182ht Eure Chance, Angriffe mit einem Schild zu blocken, um (%d+)%%"}},
		Parry = {desc = {"Parieren","%"}, bonus = {"Verwenden: Erh\195\182ht Eure Chance, einen Angriff zu parieren, um (%d+)%%"}},
	},
}

CARDQI_SCAN_DEFAULT_ITEM_LIST = {"Insignien der","Karrotte am Stiel","Schicke Stoppuhr"}
CARDQI_SCAN_SPECIAL_ENCHANTS = {"(Schwache Tempo-Steigerung)","(Mithrilsporen)","Verwenden: (Immun gegen Entwaffnen)",
	"Equip: Increases your (stealth detection)"}
CARDQI_SCAN_WEAPONS  = {
	desc = {"Waffen"},
	weaponType = {"(Zweih\195\164ndig)","(Einh\195\164ndig)","(Waffenhand)","(Schildhand)","(Distanz)","(In Schildhand gef\195\188hrt)","(Thrown)"},
	weaponSubType = {"(Streitkolben)","(Schwert)","(Dolch)","(Stab)","(Zauberstab)","(Polearm)","(Angel)","(Axt)","(Bogen)",
		"(Armbrust)","(Faustwaffe)","(Schusswaffe)","(Schild)","(Thrown)"},
	speed = {"Tempo (.+)"},
	dps = {"%((.+) Schaden pro Sekunde%)"},
	block = {"(%d+) Blocken"},
	enchant = {"(Kreuzfahrer)","(Waffenschaden %+%d+)","(Beastslaying %+%d+)","(Zielfernrohr %(%+%d+ Damage%))","(D\195\164monent\195\182ten)",
		"(Eisige Waffe)","(Feurige Waffe)","(Gegengewicht %+%d+%% Attack Speed)","(Lebensentzug)","(Unheilige Waffe)"},
}

--------------------------------------------------------------------------------------
end
