ZGANNOUNCE_SLASH_COMMANDS	= { "/zgannounce", "/zga" };

ZGANNOUNCE_MSG_LOADED		= "ZGannounce v1.0 loaded";

ZGANNOUNCE_USAGE			= {
	"(use /ZGA on/off/toggle in order to toggle ZGAnnounce on and off)";
	"/zga show 'item name' will show you what classes 'item name' is for";
	"/zga send 'item name' will send to raid what classes 'item name' is for";
	"/zga pass 'item name' will auto-pass on item name - by character";
};

ZGANNOUNCE_COMMAND_ENABLE	= {
	"on";
	"enable";
};

ZGANNOUNCE_COMMAND_DISABLE	= {
	"off";
	"disable";
};

ZGANNOUNCE_COMMAND_TOGGLE	= {
	"toggle";
	"switch";
};

ZGANNOUNCE_COMMAND_SHOW		= {
	"show";
};

ZGANNOUNCE_COMMAND_SEND		= {
	"send";
};

ZGANNOUNCE_COMMAND_PASS	= {
	"pass";
	"gotenough";
	"got";
	"have";
	"haveall";
};

ZGANNOUNCE_STATE			= "ZGAnnounce %s.";
ZGANNOUNCE_STATE_ENABLED	= "on";
ZGANNOUNCE_STATE_DISABLED	= "off";

ZGANNOUNCE_PASS_MSG			= "ZGA: Rolling on %s is now %s.";
ZGANNOUNCE_UNKNOWN_ITEM_PASS= "Unknown item";


ZGANNOUNCE_UNKNOWN_ITEM		= "Unknown item - please consult your local raid leader";

-- format is "index" => "message"
ZGANNOUNCE_ITEMS			= {
	["Bloodscalp Coin"] = "Bloodscalp: Priest, Rogue, Warrior, Warlock, Paladin, Shaman";
	["Gurubashi Coin"] = "Gurubashi: Druid, Hunter, Mage, Warrior, Warlock, Shaman";
	["Hakkari Coin"] = "Hakkari: Priest, Druid, Rogue, Hunter, Warlock, Shaman";
	["Razzashi Coin"] = "Razzashi: Priest, Druid, Mage, Rogue, Hunter, Shaman";
	["Sandfury Coin"] = "Sandfury: Priest, Druid, Mage, Hunter, Warrior, Paladin";
	["Skullsplitter Coin"] = "Skullsplitter: Rogue, Hunter, Warrior, Warlock, Paladin, Shaman";
	["Vilebranch Coin"] = "Vilebranch: Druid, Mage, Rogue, Warrior, Warlock, Paladin";
	["Witherbark Coin"] = "Witherbark: Priest, Mage, Warrior, Warlock, Paladin, Shaman";
	["Zulian Coin"] = "Zulian: Priest, Druid, Mage, Rogue, Hunter, Paladin";
	["Blue Hakkari Bijou"] = "Blue: Mage, Rogue, Shaman";
	["Bronze Hakkari Bijou"] = "Bronze: Priest, Druid, Warrior";
	["Gold Hakkari Bijou"] = "Gold: Rogue, Paladin, Shaman";
	["Green Hakkari Bijou"] = "Green: Druid, Hunter, Warrior";
	["Orange Hakkari Bijou"] = "Orange: Priest, Mage, Warlock";
	["Purple Hakkari Bijou"] = "Purple: Rogue, Paladin, Shaman";
	["Red Hakkari Bijou"] = "Red: Druid, Warlock, Paladin";
	["Silver Hakkari Bijou"] = "Silver: Mage, Hunter, Warlock";
	["Yellow Hakkari Bijou"] = "Yellow: Priest, Hunter, Warrior";
	["Primal Hakkari Aegis"] = "Aegis: Priest, Rogue, Hunter; Enchant: Warrior";
	["Primal Hakkari Armsplint"] = "Armsplint: Rogue, Warrior, Shaman; Enchant: Warlock";
	["Primal Hakkari Bindings"] = "Bindings: Mage, Hunter, Paladin; Enchant: Druid";
	["Primal Hakkari Girdle"] = "Girdle: Rogue, Warrior, Shaman; Enchant: Mage";
	["Primal Hakkari Kossack"] = "Kossack: Mage, Warrior, Warlock; Enchant: Rogue";
	["Primal Hakkari Sash"] = "Sash: Priest, Druid, Warlock; Enchant: Shaman";
	["Primal Hakkari Shawl"] = "Shawl: Mage, Hunter, Paladin; Enchant: Paladin";
	["Primal Hakkari Stanchion"] = "Stanchion: Priest, Druid, Warlock; Enchant: Hunter";
	["Primal Hakkari Tabard"] = "Tabard: Druid, Paladin, Shaman; Enchant: Priest";
-- Ahn'Qiraj Drops
	["Qiraji Magisterial Ring"] = "Magisterial Ring: Warrior, Paladin, Shaman, Mage, Druid";
	["Qiraji Regal Drape"] = "Regal Drape: Paladin, Hunter, Shaman, Warlock, Druid";
	["Qiraji Martial Drape"] = "Regal Drape: Warrior, Rogue, Priest, Mage";
	["Qiraji Ornate Hilt"] = "Ornate Hilt: Priest, Mage, Warlock, Druid";
	["Qiraji Ceremonial Ring"] = "Ceremonial Ring: Hunter, Rogue, Priest, Warlock";
	["Qiraji Spiked Hilt"] = "Spiked Hilt: Warrior, Paladin, Hunter, Rogue, Shaman";
	["Alabaster Idol"] = "Alabaster Idol: Warrior, Mage, Druid";
	["Vermillion Idol"] = "Vermillion Idol: Paladin, Rogue, Shaman, Druid";
	["Jasper Idol"] = "Jasper Idol: Priest, Warlock, Druid";
	["Amber Idol"] = "Amber Idol: Paladin, Hunter, Shaman, Warlock";
	["Lambent Idol"] = "Lambent Idol: Warrior, Hunter, Priest";
	["Azure Idol"] = "Azure Idol: Hunter, Rogue, Mage";
	["Obsidian Idol"] = "Obsidian Idol: Paladin, Priest, Shaman, Mage";
	["Onyx Idol"] = "Onyx Idol: Warrior, Rogue, Warlock";
	["Bronze Scarab"] = "Bronze Scarab: Druid, Paladin, Priest, Rogue, Shaman, Warlock, Warrior";
	["Ivory Scarab"] = "Ivory Scarab: Druid, Paladin, Priest, Rogue, Shaman, Warlock, Warrior";
	["Bone Scarab"] = "Bone Scarab: Druid, Hunter, Mage, Paladin, Priest, Shaman, Warrior";
	["Silver Scarab"] = "Silver Scarab: Druid, Hunter, Mage, Paladin, Priest, Shaman, Warrior";
	["Crystal Scarab"] = "Crystal Scarab: Druid, Hunter, Mage, Rogue, Warlock, Warrior";
	["Stone Scarab"] = "Stone Scarab: Druid, Hunter, Mage, Rogue, Warlock, Warrior";
	["Clay Scarab"] = "Clay Scarab: Hunter, Mage, Paladin, Priest, Rogue, Shaman, Warlock";
	["Gold Scarab"] = "Gold Scarab: Hunter, Mage, Paladin, Priest, Rogue, Shaman, Warlock";
};


ZGANNOUNCE_ZONE_ZULGURUB	= "Zul'Gurub";
