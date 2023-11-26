-- general
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
TITAN_ITEMBONUSES_HEAL = "Healing";
TITAN_ITEMBONUSES_HEALCRIT = "Crit. Healing";
TITAN_ITEMBONUSES_HEALTHREG = "Life Regeneration";
TITAN_ITEMBONUSES_MANAREG = "Mana Regeneration";
TITAN_ITEMBONUSES_HEALTH = "Life Points";
TITAN_ITEMBONUSES_MANA = "Mana Points";	

-- equip and set bonus patterns:
TITAN_ITEMBONUSES_EQUIP_PREFIX = "Equip: ";
TITAN_ITEMBONUSES_SET_PREFIX = "Set: ";

TITAN_ITEMBONUSES_EQUIP_PATTERNS = {
	{ pattern = "+(%d+) Attack Power%.", effect = "ATTACKPOWER" },
	{ pattern = "+(%d+) ranged Attack Power%.", effect = "RANGEDATTACKPOWER" },
	{ pattern = "Increases your chance to dodge an attack by (%d+)%%%.", effect = "BLOCK" },
	{ pattern = "Increases your chance to dodge an attack by (%d+)%%%.", effect = "DODGE" },
	{ pattern = "Increases your chance to parry an attack by (%d+)%%%.", effect = "PARRY" },
	{ pattern = "Improves your chance to get a critical strike with spells by (%d+)%%%.", effect = "SPELLCRIT" },
	{ pattern = "Improves your chance to get a critical strike by (%d+)%%%.", effect = "CRIT" },
	{ pattern = "Improves your chance to get a critical strike with missile weapons by (%d+)%%%.", effect = "RANGEDCRIT" },
	{ pattern = "Increases the critical effect chance of your Holy spells by (%d+)%%%.", effect = "HEALCRIT" },
	{ pattern = "Increases damage done by Arcane spells and effects by up to (%d+)%.", effect = "ARCANEDMG" },
	{ pattern = "Increases damage done by Fire spells and effects by up to (%d+)%.", effect = "FIREDMG" },
	{ pattern = "Increases damage done by Frost spells and effects by up to (%d+)%.", effect = "FROSTDMG" },
	{ pattern = "Increases damage done by Holy spells and effects by up to (%d+)%.", effect = "HOLYDMG" },
	{ pattern = "Increases damage done by Nature spells and effects by up to (%d+)%.", effect = "NATUREDMG" },
	{ pattern = "Increases damage done by Shadow spells and effects by up to (%d+)%.", effect = "SHADOWDMG" },
	{ pattern = "Increases healing done by spells and effects by up to (%d+)%.", effect = "HEAL" },
	{ pattern = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", effect = "HEAL" },
	{ pattern = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", effect = "DMG" },
	{ pattern = "Restores (%d+) health every 5 sec.", effect = "HEALTHREG" },
	{ pattern = "Restores (%d+) mana every 5 sec.", effect = "MANAREG" },
	{ pattern = "Improves your chance to hit by (%d+)%%%.", effect = "TOHIT" }
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
	{ pattern = "Damage", 	effect = "DMG" }
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
	["Mining"]				= "MINING",
	["Herbalism"]			= "HERBALISM",
	["Skinning"]			= "SKINNING",
	["Defense"]				= "DEFENSE",

	["Attack Power"] 		= "ATTACKPOWER",
	["Dodge"] 				= "DODGE",
	["Block"]				= "BLOCK",
	["Blocking"]			= "BLOCK",
	["Ranged Attack Power"] = "RANGEDATTACKPOWER",
	["health every 5 sec."] = "HEALTHREG",
	["Healing Spells"] 		= "HEAL",
	["mana every 5 sec."] 	= "MANAREG",
	["Spell Damage"] 		= "DMG",
	["Critical Hit"] 		= "CRIT",
	["Damage"] 				= "DMG",
	["Health"]				= "HEALTH",
	["Mana"]				= "MANA",
	["Armor"]				= "ARMOR",
	["Reinforced Armor"]	= "ARMOR",
};	

if ( GetLocale() == "deDE" ) then
	-- Allgemeines
	TITAN_ITEMBONUSES_TEXT = "Gegenstandboni";
	TITAN_ITEMBONUSES_DISPLAY_NONE = "Keine Anzeige";
	TITAN_ITEMBONUSES_SHORTDISPLAY = "Kurze Beschriftung";
	
	TITAN_ITEMBONUSES_CAT_ATT = "Attribute";
	TITAN_ITEMBONUSES_CAT_RES = "Widerstand";
	TITAN_ITEMBONUSES_CAT_SKILL = "Fertigkeiten";
	TITAN_ITEMBONUSES_CAT_BON = "Nah- und Fernkampf";
	TITAN_ITEMBONUSES_CAT_SBON = "Zauber";
	TITAN_ITEMBONUSES_CAT_OBON = "Leben und Mana";

	-- Namen der Boni
	TITAN_ITEMBONUSES_STR = "Stärke";
	TITAN_ITEMBONUSES_AGI = "Beweglichkeit";
	TITAN_ITEMBONUSES_STA = "Ausdauer";
	TITAN_ITEMBONUSES_INT = "Intelligenz";
	TITAN_ITEMBONUSES_SPI = "Willenskraft";
	TITAN_ITEMBONUSES_ARMOR = "Verstärkte Rüstung";

	TITAN_ITEMBONUSES_ARCANERES = "Arkanwiderstand";	
	TITAN_ITEMBONUSES_FIRERES	= "Feuerwiderstand";
	TITAN_ITEMBONUSES_NATURERES = "Naturwiderstand";
	TITAN_ITEMBONUSES_FROSTRES	= "Frostwiderstand";
	TITAN_ITEMBONUSES_SHADOWRES	= "Schattenwiderstand";

	TITAN_ITEMBONUSES_FISHING	= "Angeln";
	TITAN_ITEMBONUSES_MINING	= "Bergbau";
	TITAN_ITEMBONUSES_HERBALISM	= "Kräuterkunde";
	TITAN_ITEMBONUSES_SKINNING	= "Kürschnerei";
	TITAN_ITEMBONUSES_DEFENSE	= "Verteidigung";

	TITAN_ITEMBONUSES_BLOCK = "Blocken";
	TITAN_ITEMBONUSES_DODGE = "Ausweichen";
	TITAN_ITEMBONUSES_PARRY = "Parieren";
	TITAN_ITEMBONUSES_ATTACKPOWER = "Angriffskraft";
	TITAN_ITEMBONUSES_CRIT = "krit. Treffer";
	TITAN_ITEMBONUSES_RANGEDATTACKPOWER = "Distanzangriffskraft";
	TITAN_ITEMBONUSES_RANGEDCRIT = "krit. Schuss";
	TITAN_ITEMBONUSES_TOHIT = "Trefferchance";
	TITAN_ITEMBONUSES_DMG = "Zauberschaden";
	TITAN_ITEMBONUSES_ARCANEDMG = "Arkanschaden";
	TITAN_ITEMBONUSES_FIREDMG = "Feuerschaden";
	TITAN_ITEMBONUSES_FROSTDMG = "Frostschaden";
	TITAN_ITEMBONUSES_HOLYDMG = "Heiligschaden";
	TITAN_ITEMBONUSES_NATUREDMG = "Naturschaden";
	TITAN_ITEMBONUSES_SHADOWDMG = "Schattenschaden";
	TITAN_ITEMBONUSES_SPELLCRIT = "krit. Zauber";
	TITAN_ITEMBONUSES_HEAL = "Heilung";
	TITAN_ITEMBONUSES_HEALCRIT = "krit. Heilung";
	TITAN_ITEMBONUSES_HEALTHREG = "Lebensregeneration";
	TITAN_ITEMBONUSES_MANAREG = "Manaregeneration";	
	TITAN_ITEMBONUSES_HEALTH = "Lebenspunkte";
	TITAN_ITEMBONUSES_MANA = "Manapunkte";	

	-- "Verwenden: " und Set-Suchmuster
	TITAN_ITEMBONUSES_EQUIP_PREFIX = "Verwenden: ";
	TITAN_ITEMBONUSES_SET_PREFIX = "Set: ";

	TITAN_ITEMBONUSES_EQUIP_PATTERNS = {
		{ pattern = "%-(%d+) Angriffskraft%.", effect = "ATTACKPOWER" },
		{ pattern = "Angeln %-(%d+)%.", effect = "FISHING" },
		{ pattern = "%-(%d+) Distanzangriffskraft%.", effect = "RANGEDATTACKPOWER" },
		{ pattern = "Erhöht Eure Chance, Angriffe mit einem Schild zu blocken, um $s1%.", effect = "BLOCK" },
		{ pattern = "Erhöht Eure Chance, einem Angriff auszuweichen, um (%d+)%%%.", effect = "DODGE" },
		{ pattern = "Erhöht Eure Chance, einen Angriff zu parieren, um (%d+)%%%.", effect = "PARRY" },
		{ pattern = "Erhöht Eure Chance, einen kritischen Schlag durch Zauber zu erzielen, um (%d+)%%%.", effect = "SPELLCRIT" },
		{ pattern = "Erhöht Eure Chance, einen kritischen Schlag zu erzielen, um (%d+)%%%.", effect = "CRIT" },
		{ pattern = "Erhöht Eure Chance, mit Geschosswaffen einen kritischen Schlag zu erzielen, um (%d+)%.", effect = "RANGEDCRIT" },
		{ pattern = "Erhöht die Chancefür einen kritischen Effekt Eurer Heiligzauber um (%d+)%.", effect = "HEALCRIT" },
		{ pattern = "Erhöht durch Arkanzauber und Arkaneffekte zugefügten Schaden um bis zu (%d+)%.", effect = "ARCANEDMG" },
		{ pattern = "Erhöht durch Feuerzauber und Feuereffekte zugefügten Schaden um bis zu (%d+)%.", effect = "FIREDMG" },
		{ pattern = "Erhöht durch Frostzauber und Frosteffekte zugefügten Schaden um bis zu (%d+)%.", effect = "FROSTDMG" },
		{ pattern = "Erhöht durch Heiligzauber und Heiligeffekte zugefügten Schaden um bis zu (%d+)%.", effect = "HOLYDMG" },
		{ pattern = "Erhöht durch Naturzauber und Natureffekte zugefügten Schaden um bis zu (%d+)%.", effect = "NATUREDMG" },
		{ pattern = "Erhöht durch Schattenzauber und Schatteneffekte zugefügten Schaden um bis zu (%d+)%.", effect = "SHADOWDMG" },
		{ pattern = "Erhöht durch Zauber und Effekte verursachte Heilung um bis zu (%d+)%.", effect = "HEAL" },
		{ pattern = "Erhöht durch magische Zauber und magische Effekte zugefügten Schaden und Heilung um bis zu (%d+) Punkt%(e%)%.", effect = "HEAL" },
		{ pattern = "Erhöht durch magische Zauber und magische Effekte zugefügten Schaden und Heilung um bis zu (%d+) Punkt%(e%)%.", effect = "DMG" },
		{ pattern = "Stellt alle 5 Sek%. (%d+) Punkt%(e%) Gesundheit wieder her%.", effect = "HEALTHREG" },
		{ pattern = "Stellt alle 5 Sekunden (%d+) Punkt%(e%) Gesundheit wieder her%.", effect = "HEALTHREG" },
		{ pattern = "Stellt alle 5 Sekunden (%d+) Punkt%(e%) Mana wieder her%.", effect = "MANAREG" },
		{ pattern = "Stellt beim Spieler alle 5 Sekunden (%d+) Punkt%(e%) Mana wieder her%.", effect = "MANAREG" },
		{ pattern = "Verbessert Eure Trefferchance um (%d+)%%%.", effect = "TOHIT" }
	};
	
	TITAN_ITEMBONUSES_S1 = {
		{ pattern = "Arkan", 	effect = "ARCANE" },	
		{ pattern = "Feuer", 	effect = "FIRE" },	
		{ pattern = "Frost", 	effect = "FROST" },	
		{ pattern = "Heilig", 	effect = "HOLY" },	
		{ pattern = "Schatten", effect = "SHADOW" },	
		{ pattern = "Natur", 	effect = "NATURE" }}; 	

	TITAN_ITEMBONUSES_S2 = {
		{ pattern = "widerst", 	effect = "RES" },	
		{ pattern = "schaden", 	effect = "DMG" }}; 	
	
	
	-- Suchmuster f�r zuf�llige Gegenstandsboni
	TITAN_ITEMBONUSES_TOKEN_EFFECT = {
		["Alle Werte"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
		["Stärke"]				= "STR",
		["Beweglichkeit"]		= "AGI",
		["Ausdauer"]			= "STA",
		["Intelligenz"]			= "INT",
		["Willenskraft"] 		= "SPI",

		["Allem widerstehen"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},

		["Angeln"]				= "FISHING",
		["Bergbau"]				= "MINING",
		["Kräuterkunde"]		= "HERBALISM",
		["Kürschnerei"]		= "SKINNING",
		["Verteidigung"]		= "DEFENSE",

		["Angriffskraft"] 		= "ATTACKPOWER",
		["Ausweichen"] 			= "DODGE",
		["Blocken"]				= "BLOCK",
		["Distanzangriffskraft"] = "RANGEDATTACKPOWER",
		["Gesundheit alle 5 Sek."] = "HEALTHREG",
		["Heilzauber"] 			= "HEAL",
		["Mana alle 5 Sek."] 	= "MANAREG",
		["Schaden"] 			= "DMG",
		["Kritischer Treffer"] 	= "CRIT",
		["Zauberschaden"] 		= "DMG",
		["Blocken"]				= "BLOCK",
		["Gesundheit"]			= "HEALTH",
		["Heilzauber"]			= "HEAL",
		["Mana"]				= "MANA",
		["Rüstung"]			= "ARMOR",
		["Verstärkte Rüstung"]= "ARMOR",
		};
end

