--
-- AutoBar
-- Copyright 2004, 2005 original author. Copyright is expressly not transferred to Blizzard.
-- 
-- Replaces "micro" buttons in mainbar with up to 12 autoloading buttons
--   that load from a user chosen list of several (more than 12) categories.
--
--  Author: Marc aka Saien on Hyjal
--  http://64.168.251.69/wow
--
--  Slash Command:
--    /autobar -- Will list all slash commands
--
--
--  2005.07.13
--    Included itemids for new talent improved Healthstones.
--    New TOC 1600
--  2005.06.17
--    Fixed typo when setting up defaults for new characters - was setting it to button types that didn't exist.
--  2005.06.15
--    Added new "Merged" categories. Refer to website as to how these work.
--    New TOC 1500
--  2005.05.10 Refer to website as to how these work. Refer to website as to how these work.
--    Added Combat Healing and Mana potion.
--  2005.04.10
--    Bandages now have a lesser category.
--    Added Thrown Weapons category
--    Configuration is now by playername by realm.
--  2005.03.24
--    New item ids, including thorium headed arrow and conjured crystal water
--    TOC change to 1300
--  2005.03.09
--    Option to make buttons take on MicroButton aspect ratio (the original buttons on 
--      the MainMenuBar that AutoBar replaces) -- Suggestion from Blindfury
--  2005.03.05
--    Many itemid updates
--    Updated TOC to 4216
--  2005.02.20
--    Hide Count option - for when you shrink the buttons
--    Hideallbags no longer needed and is removed
--    Changed matching to use itemIDs
--    Updated toc to 4211
--  2005.02.13
--    OpenAllBags now monitored for hideforbags.
--  2005.02.06
--    Fixed item counts not always updating in a timely manner.
--    Fixed initialization of the hideforbags checkbox.
--  2005.01.31
--    Changed methodology of scaling buttons. Its better now, but its 
--      also now not independent. Choose scaling based in relation to your normal UI scale.
--    Changed independent scaling to work from 0.25 to 2.0
--    Fixed bug with background of move frame sizing.
--  2005.01.29
--     Fix bug with checking for bag option prior to config load.
--     Made poisons usable.
--     Discolored healing potion was in mana potions, wtf?
--     Added Senggin Root
--  2005.01.25
--     Config option to turn off autobar when bags open
--     Right click on categories with "lesser" to use lesser
--     Reverse button order (and on config window)
--     Don't grow undocked background when buttons empty.
--     Hax0r to not hide buttons when Gypsy is up. 
--     Config window now supports all the docking options (Chatframe1..4)
--     Changed independent scaling to work from 0.5 to 2.0
--     Added donotskip(and to config window)
--     Upped it to 12 customizable
--     Added Enriched Manna biscuit to both water and food lists
--     Added rogue poisons - look for something special here later
--     hidekeys on config window
--     selfcast on config window
--  Todo
--

AUTOBAR_VERSION = "2005.06.17" -- Notice the cleverly disguised date.

-- Declares, if this was a real language
AutoBar_Player = nil; -- global
local AutoBar_LastUpdate = 0;
local AutoBar_PlayerClass = nil;
local AutoBar_Button_ReSync = 1;
local AutoBar_Config_Loaded = nil;
local AutoBar_Max_Button_Displayed = nil;
local AutoBar_EVERFREAKINGHIDTHEGODDAMNMICROBUTTONS = nil;
local AutoBar_NeedResize = nil;
local AutoBar_ButtonsAssigned = nil;
local AutoBar_Watching = {};
local AutoBar_CurrentZone = nil;
local AutoBar_ScheduledResync = nil;
AutoBar_CatInfo = { -- global
	["MERGED_HEAL"] = {
		["description"] = "Merged: Healing";
		["texture"] = "Interface\\Icons\\INV_Potion_52";
		["usable"] = true;
		["beneficial"] = true;
		["merged"] = true;
	},
	["MERGED_MANA"] = {
		["description"] = "Merged: Mana";
		["texture"] = "Interface\\Icons\\INV_Potion_73";
		["usable"] = true;
		["beneficial"] = true;
		["merged"] = true;
	},
	["MERGED_BANDAGE"] = {
		["description"] = "Merged: Bandage";
		["texture"] = "Interface\\Icons\\INV_Misc_Bandage_01";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
		["merged"] = true;
	},

	["HEARTHSTONE"] = {
		["description"] = "Hearthstone";
		["texture"] = "Interface\\Icons\\INV_Misc_Rune_01";
		["usable"] = true;
		["beneficial"] = true;
	},
	["BANDAGES"] = {
		["description"] = "Bandages";
		["texture"] = "Interface\\Icons\\INV_Misc_Bandage_01";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
	},
	["HEALPOTIONS"] = {
		["description"] = "Heal Potions";
		["texture"] = "Interface\\Icons\\INV_Potion_52";
		["usable"] = true;
		["beneficial"] = true;
	},
	["MANAPOTIONS"] = {
		["description"] = "Mana Potions";
		["texture"] = "Interface\\Icons\\INV_Potion_73";
		["usable"] = true;
		["beneficial"] = true;
	},
	["HEALTHSTONE"] = {
		["description"] = "Healthstones";
		["texture"] = "Interface\\Icons\\INV_Stone_04";
		["usable"] = true;
		["beneficial"] = true;
	},
	["MANASTONE"] = {
		["description"] = "Manastones";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Ruby_01";
		["usable"] = true;
		["beneficial"] = true;
	},
	["WATER"] = {
		["description"] = "Water";
		["texture"] = "Interface\\Icons\\INV_Drink_10";
		["usable"] = true;
		["beneficial"] = true;
	},
	["RAGEPOTIONS"] = {
		["description"] = "Rage Potions";
		["texture"] = "Interface\\Icons\\INV_Potion_24";
		["usable"] = true;
		["beneficial"] = true;
	},
	["ENERGYPOTIONS"] = {
		["description"] = "Energy Potions";
		["texture"] = "Interface\\Icons\\INV_Drink_Milk_05";
		["usable"] = true;
		["beneficial"] = true;
	},
	["SWIFTNESSPOTIONS"] = {
		["description"] = "Swiftness Potions";
		["texture"] = "Interface\\Icons\\INV_Potion_95";
		["usable"] = true;
		["beneficial"] = true;
	},
	["SOULSHARDS"] = {
		["description"] = "Soul Shards";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Amethyst_02";
	},
	["UNGORORESTORE"] = {
		["description"] = "Un'Goro: Crystal Restore";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Diamond_02";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
		--[[
		["abort"] = function() 
			Debug ("Called");
			if (UnitCanCooperate("player","target")) then
				Debug ("can cooperate");
				Debug (math.floor((UnitHealth("target")/UnitHealthMax("target"))*100));
				if ((math.floor((UnitHealth("target")/UnitHealthMax("target"))*100) > 90)) then 
				return true; 
				end
			end 
		end;
		["abortmessage"] = "Friendly target not hurt, aborting to avoid waste.";
		]]
	},
	["UNGOROCHARGE"] = {
		["description"] = "Un'Goro: Crystal Charge";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Opal_01";
		["usable"] = true;
		["targetted"] = true;
	},
	["UNGOROFORCE"] = {
		["description"] = "Un'Goro: Crystal Force";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Crystal_02";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
	},
	["UNGOROSPIRE"] = {
		["description"] = "Un'Goro: Crystal Spire";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Stone_01";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
	},
	["UNGOROWARD"] = {
		["description"] = "Un'Goro: Crystal Ward";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Ruby_02";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
	},
	["UNGOROYIELD"] = {
		["description"] = "Un'Goro: Crystal Yield";
		["texture"] = "Interface\\Icons\\INV_Misc_Gem_Amethyst_01";
		["usable"] = true;
		["targetted"] = true;
	},
	["ARROWS"] = {
		["description"] = "Arrows";
		["texture"] = "Interface\\Icons\\INV_Ammo_Arrow_02";
		["usable"] = false;
	},
	["BULLETS"] = {
		["description"] = "Bullets";
		["texture"] = "Interface\\Icons\\INV_Ammo_Bullet_02";
		["usable"] = false;
	},
	["THROWN"] = {
		["description"] = "Thrown Weapons";
		["texture"] = "Interface\\Icons\\Ability_UpgradeMoonGlaive";
		["usable"] = false;
	},
	["FOOD"] = {
		["description"] = "Food";
		["texture"] = "Interface\\Icons\\INV_Misc_Food_14";
		["usable"] = true;
		["beneficial"] = true;
	},
	["SHARPENINGSTONES"] = {
		["description"] = "Blacksmith created Sharpening stones";
		["texture"] = "Interface\\Icons\\INV_Stone_SharpeningStone_01";
		["usable"] = true;
	},
	["WEIGHTSTONE"] = {
		["description"] = "Blacksmith created Weight stones";
		["texture"] = "Interface\\Icons\\INV_Stone_WeightStone_02";
		["usable"] = true;
	},
	["POISON-CRIPPLING"] = {
		["description"] = "Crippling Poison";
		["texture"] = "Interface\\Icons\\INV_Potion_19";
		["usable"] = true;
	},
	["POISON-DEADLY"] = {
		["description"] = "Deadly Poison";
		["texture"] = "Interface\\Icons\\Ability_Rogue_DualWeild";
		["usable"] = true;
	},
	["POISON-INSTANT"] = {
		["description"] = "Instant Poison";
		["texture"] = "Interface\\Icons\\Ability_Poisons";
		["usable"] = true;
	},
	["POISON-MINDNUMBING"] = {
		["description"] = "Mind-Numbing Poison";
		["texture"] = "Interface\\Icons\\Spell_Nature_NullifyDisease";
		["usable"] = true;
	},
	["POISON-WOUND"] = {
		["description"] = "Wounding Poison";
		["texture"] = "Interface\\Icons\\Ability_PoisonSting";
		["usable"] = true;
	},
	["EXPLOSIVES"] = {
		["description"] = "Engineering Explosives";
		["texture"] = "Interface\\Icons\\INV_Misc_Bomb_08";
		["usable"] = true;
	},
	["WHIPPER_ROOT"] = {
		["description"] = "Whipper Root";
		["texture"] = "Interface\\Icons\\INV_Misc_Food_55";
		["usable"] = true;
		["beneficial"] = true;
		["donotdisplay"] = true;
	},
	["ALTERAC_HEAL"] = {
		["description"] = "Alterac Heal Potions";
		["texture"] = "Interface\\Icons\\INV_Potion_39";
		["usable"] = true;
		["beneficial"] = true;
		["location"] = "Alterac Valley";
		["donotdisplay"] = true;
	},
	["ALTERAC_MANA"] = {
		["description"] = "Alterac Mana Potions";
		["texture"] = "Interface\\Icons\\INV_Potion_81";
		["usable"] = true;
		["beneficial"] = true;
		["location"] = "Alterac Valley";
		["donotdisplay"] = true;
	},
	["ALTERAC_BANDAGE"] = {
		["description"] = "Alterac Bandages";
		["texture"] = "Interface\\Icons\\INV_Misc_Bandage_12";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
		["location"] = "Alterac Valley";
		["donotdisplay"] = true;
	},
	["WARSONG_BANDAGE"] = {
		["description"] = "Warsong Bandages";
		["texture"] = "Interface\\Icons\\INV_Misc_Bandage_12";
		["usable"] = true;
		["targetted"] = true;
		["beneficial"] = true;
		["location"] = "Warsong Gulch";
		["donotdisplay"] = true;
	},
	["CUSTOM1"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #1";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM2"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #2";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM3"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #3";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM4"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #4";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM5"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #5";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM6"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #6";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM7"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #7";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM8"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #8";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM9"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #9";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM10"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #10";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM11"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #11";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	["CUSTOM12"] = {
		["donotdisplay"] = true;
		["description"] = "Custom category #12";
		["texture"] = "";
		["usable"] = false;
		["custom"] = true;
	},
	
};

BINDING_HEADER_AUTOBAR_SEP = "Auto Bar";
BINDING_NAME_AUTOBAR_CONFIG = "Configuration Window";

BINDING_NAME_AUTOBAR_BUTTON_MERGED_HEAL= AutoBar_CatInfo["MERGED_HEAL"].description;
BINDING_NAME_AUTOBAR_BUTTON_MERGED_MANA= AutoBar_CatInfo["MERGED_MANA"].description;
BINDING_NAME_AUTOBAR_BUTTON_MERGED_BANDAGE= AutoBar_CatInfo["MERGED_BANDAGE"].description;

BINDING_NAME_AUTOBAR_BUTTON_HEARTHSTONE = AutoBar_CatInfo["HEARTHSTONE"].description;
BINDING_NAME_AUTOBAR_BUTTON_BANDAGES = AutoBar_CatInfo["BANDAGES"].description;
BINDING_NAME_AUTOBAR_BUTTON_BANDAGES_LESSER = AutoBar_CatInfo["BANDAGES"].description.." - Lesser";
BINDING_NAME_AUTOBAR_BUTTON_HEALPOTIONS = AutoBar_CatInfo["HEALPOTIONS"].description;
BINDING_NAME_AUTOBAR_BUTTON_HEALPOTIONS_LESSER = "Healing Potions - Lesser";
BINDING_NAME_AUTOBAR_BUTTON_MANAPOTIONS = AutoBar_CatInfo["MANAPOTIONS"].description;
BINDING_NAME_AUTOBAR_BUTTON_MANAPOTIONS_LESSER = "Mana Potions - Lesser";
BINDING_NAME_AUTOBAR_BUTTON_HEALTHSTONE = AutoBar_CatInfo["HEALTHSTONE"].description;
BINDING_NAME_AUTOBAR_BUTTON_MANASTONE = AutoBar_CatInfo["MANASTONE"].description;
BINDING_NAME_AUTOBAR_BUTTON_WATER = AutoBar_CatInfo["WATER"].description;
BINDING_NAME_AUTOBAR_BUTTON_FOOD = AutoBar_CatInfo["FOOD"].description;
BINDING_NAME_AUTOBAR_BUTTON_RAGEPOTIONS = AutoBar_CatInfo["RAGEPOTIONS"].description;
BINDING_NAME_AUTOBAR_BUTTON_ENERGYPOTIONS = AutoBar_CatInfo["ENERGYPOTIONS"].description;
BINDING_NAME_AUTOBAR_BUTTON_SWIFTNESSPOTIONS = AutoBar_CatInfo["SWIFTNESSPOTIONS"].description;
BINDING_NAME_AUTOBAR_BUTTON_SHARPENINGSTONES = AutoBar_CatInfo["SHARPENINGSTONES"].description;
BINDING_NAME_AUTOBAR_BUTTON_WEIGHTSTONE = AutoBar_CatInfo["WEIGHTSTONE"].description;
BINDING_NAME_AUTOBAR_BUTTON_UNGORORESTORE = AutoBar_CatInfo["UNGORORESTORE"].description;
BINDING_NAME_AUTOBAR_BUTTON_UNGOROCHARGE = AutoBar_CatInfo["UNGOROCHARGE"].description;
BINDING_NAME_AUTOBAR_BUTTON_UNGOROFORCE = AutoBar_CatInfo["UNGOROFORCE"].description;
BINDING_NAME_AUTOBAR_BUTTON_UNGOROSPIRE = AutoBar_CatInfo["UNGOROSPIRE"].description;
BINDING_NAME_AUTOBAR_BUTTON_UNGOROWARD = AutoBar_CatInfo["UNGOROWARD"].description;
BINDING_NAME_AUTOBAR_BUTTON_UNGOROYIELD = AutoBar_CatInfo["UNGOROYIELD"].description;

BINDING_NAME_AUTOBAR_BUTTON_CUSTOM1 = AutoBar_CatInfo["CUSTOM1"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM2 = AutoBar_CatInfo["CUSTOM2"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM3 = AutoBar_CatInfo["CUSTOM3"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM4 = AutoBar_CatInfo["CUSTOM4"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM5 = AutoBar_CatInfo["CUSTOM5"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM6 = AutoBar_CatInfo["CUSTOM6"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM7 = AutoBar_CatInfo["CUSTOM7"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM8 = AutoBar_CatInfo["CUSTOM8"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM9 = AutoBar_CatInfo["CUSTOM9"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM10 = AutoBar_CatInfo["CUSTOM10"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM11 = AutoBar_CatInfo["CUSTOM11"].description
BINDING_NAME_AUTOBAR_BUTTON_CUSTOM12 = AutoBar_CatInfo["CUSTOM12"].description

AutoBar_Items = {
	["MERGED_HEAL"] = { },
	["MERGED_MANA"] = { },
	["MERGED_BANDAGE"] = { },
	["HEARTHSTONE"] = {
		"item:6948",		-- "Hearthstone"
	},
	["BANDAGES"] = {
		"item:1251",		-- "Linen Bandage",
		"item:2581",		-- "Heavy Linen Bandage",
		"item:3530",		-- "Wool Bandage",
		"item:3531",		-- "Heavy Wool Bandage",
		"item:6450",		-- "Silk Bandage",
		"item:6451",		-- "Heavy Silk Bandage",
		"item:8544",		-- "Mageweave Bandage",
		"item:8545",		-- "Heavy Mageweave Bandage",
		"item:14529", 		-- "Runecloth Bandage",
		"item:14530",		-- "Heavy Runecloth Bandage"
	},
	["HEALPOTIONS"] = {
		"item:118",		-- "Minor Healing Potion",
		"item:858",		-- "Lesser Healing Potion",
		"item:4596",		-- "Discolored Healing Potion",
		"item:929",		-- "Healing Potion",
		"item:1710",		-- "Greater Healing Potion",
		"item:3928",		-- "Superior Healing Potion",
		"item:18839",		-- Combat Healing Potion
		"item:13446",		-- "Major Healing Potion"
	},
	["MANAPOTIONS"] = {
		"item:2455",		-- "Minor Mana Potion",
		"item:3385",		-- "Lesser Mana Potion",
		"item:3827",		-- "Mana Potion",
		"item:6149",		-- "Greater Mana Potion",
		"item:13443",		-- "Superior Mana Potion",
		"item:18841",		-- Combat Mana Potion
		"item:13444", 		-- "Major Mana Potion"
	},
	["HEALTHSTONE"] = {
		"item:5512",		-- "Minor Healthstone",
		"item:19004",		-- Talent improved Minor Healthstone
		"item:19005",		-- 2pt Talent improved Minor Healthstone
		"item:5511",		-- "Lesser Healthstone",
		"item:19006",		-- Talent improved Lesser Healthstone
		"item:19007",		-- 2pt Talent improved Lesser Healthstone
		"item:5509",		-- "Healthstone",
		"item:19008",		-- Talent improved Healthstone
		"item:19009",		-- 2pt Talent improved Healthstone
		"item:5510",		-- "Greater Healthstone",
		"item:19010",		-- Talent improved Greater Healthstone
		"item:19011",		-- 2pt Talent improved Greater Healthstone
		"item:9421",		-- "Major Healthstone"
		"item:19012",		-- Talent improved Major Healthstone
		"item:19013",		-- 2pt Talent improved Major Healthstone
	},
	["MANASTONE"] = {
		"item:5514",		-- "Mana Agate",
		"item:5513",		-- "Mana Jade",
		"item:8007",		-- "Mana Citrine",
		"item:8008",		-- "Mana Ruby",
	},
	["WATER"] = {
		"item:159",		-- "Refreshing Spring Water",
		"item:5350",		-- "Conjured Water",
		"item:1179",		-- "Ice Cold Milk",
		"item:2288",		-- "Conjured Fresh Water",
		"item:1205",		-- "Melon Juice",
		"item:9451",		-- "Bubbling Water",
		"item:2136",		-- "Conjured Purified Water",
		"item:1708",		-- "Sweet Nectar",
		"item:4791", 		-- "Enchanted Water",
		"item:10841",		-- "Goldthorn Tea",
		"item:3772",		-- "Conjured Spring Water",
		"item:1645",		-- "Moonberry Juice",
		"item:8077",		-- "Conjured Mineral Water",
		"item:8766",		-- "Morning Glory Dew",
		"item:8078",		-- "Conjured Sparkling Water",
		"item:19318",		-- "Bottled Alterac Spring Water",
		"item:13724",		-- "Enriched Manna Biscuit",
		"item:8079",		-- "Conjured Crystal Water",
	},
	["RAGEPOTIONS"] = {
		"item:5631", 		-- "Rage Potion",
		"item:5633",		-- "Great Rage Potion",
		"item:13442",		-- "Mighty Rage Potion"
	},
	["ENERGYPOTIONS"] = {
		"item:7676",		-- "Thistle Tea"
	},
	["SWIFTNESSPOTIONS"] = {
		"item:2459",		-- "Swiftness Potion"
	},
	["SOULSHARDS"] = {
		"item:6265",		-- "Soul Shard"
	},
	["UNGORORESTORE"] = {
		"item:11562",	 	-- "Crystal Restore"
	},
	["UNGOROCHARGE"] = {
		"item:11566",		-- "Crystal Charge"
	},
	["UNGOROFORCE"] = {
		"item:11563",		-- "Crystal Force"
	},
	["UNGOROSPIRE"] = {
		"item:11567",	 	-- "Crystal Spire"
	},
	["UNGOROWARD"] = {
		"item:11564",		-- "Crystal Ward"
	},
	["UNGOROYIELD"] = {
		"item:11565",		-- "Crystal Yield"
	},
	["BULLETS"] = {
		"item:2516",		-- "Light Shot",
		"item:4960",		-- "Flash Pellet" 
		"item:8067", 		-- "Crafted Light Shot",
		"item:2519",		-- "Heavy Shot",
		"item:5568",		-- "Smooth Pebble",
		"item:8068",		-- "Crafted Heavy Shot",
		"item:3033",		-- "Solid Shot",
		"item:8069",		-- "Crafted Solid Shot",
		"item:3465", 		-- "Exploding Shot",
		"item:10512",		-- "Hi-Impact Mithril Slugs",
		"item:11284",		-- "Accurate Slugs",
		"item:10513", 		-- "Mithril Gyro-Shot",
		"item:11630", 		-- "Rockshard Pellets",
		"item:15997",		-- "Thorium Shells",
		"item:13377"		-- "Minature Cannon Balls"
	},
	["ARROWS"] = {
		"item:2512",		-- "Rough Arrow",
		"item:2515",		-- "Sharp Arrow",
		"item:3030",		-- "Razor Arrow",
		"item:3464",		-- "Feathered Arrow",
		"item:9399",		-- "Precision Arrow",
		"item:11285",		-- "Jagged Arrow",
		"item:18042",		-- "Thorium Headed Arrow"
		"item:12654" 		-- "Doomshot"
	},	
	["THROWN"] = {
		"Crude Throwing Axe",
		"Silver Star",
		"Small Throwing Knife",
		"Balanced Throwing Dagger",
		"Boot Knife",
		"Weighted Throwing Axe",
		"Throwing Tomahawk",
		"item:3107",		-- "Keen Throwing Knife",
		"item:3135",		-- "Sharp Throwing Axe",
		"item:3137",		-- "Deadly Throwing Axe",
		"item:3108",		-- "Heavy Throwing Dagger",
		"item:15326",		-- "Gleaming Throwing Axe",
		"item:15327",		-- "Wicked Throwing Dagger",
		"Flightblade Throwing Axe",
	},
	["FOOD"] = {
		"item:2070",		-- "Darnassian Bleu",	-- Vendor  - Level 1, heals 61
		"item:4540",		-- Tough Hunk of Bread Vendor  - Level 1, heals 61
		"item:4536", 		-- Shiny Red Apple Vendor  - Level 1, heals 61
		"item:117",		-- Tough Jerky Vendor  - Level 1, heals 61
		"item:4604",		-- "Forest Mushroom Cap",	-- Vendor  - Level 1, heals 61
		"item:16166",		-- "Bean Soup",		-- Vendor  - Level 1, heals 61
		"item:9681",		-- "Charred Wolf Meat",	-- Cooking - Level 1, heals 61
		"item:2681", 		-- "Roasted Boar Meat",	-- Cooking - Level 1, heals 61
		"item:787",		-- "Slitherskin Mackerel",	-- Cooking - Level 1, heals 61
		"item:6290",		-- "Brilliant Smallfish",	-- Cooking - Level 1, heals 61
		"item:2680",		-- "Spiced Wolf Meat",	-- Cooking
		"item:5349",		-- Conjured Muffin Mage    - Level 1, heals 61
		"item:6888", 		-- "Herb Baked Egg",	-- Cooking - Level 1, heals 61, with bonus
		"item:12224", 		-- "Crispy Bat Wing" Cooking - Level 1, heals 61, with bonus
		"item:17197", 		-- "Gingerbread Cookie" Cooking - Level 1, heals 61, with bonus
		"item:17198", 		-- "Egg Nog" Cooking - Level 1, heals 61, with bonus
		"item:5472",		-- "Kaldorei Spider Kabob" Cooking - Level 1, heals 61, with bonus
		"item:2888",		-- "Beer Basted Boar Ribs" Cooking - Level 1, heals 61, with bonus
		"item:5474", 		-- "Roasted Kodo Meat" Cooking - Level 1, heals 61, with bonus
		"item:11584",		-- "Cactus Apple Surprise" Quest - Level 1, heals 61, with bonus
		"item:16167",		-- "Versicolor Treat" Vendor - Level 5, heals 243 
		"item:4605",		-- "Red-speckled Mushroom",-- Vendor  - Level 5, heals 243
		"item:2287",		-- Haunch of Meat Vendor  - Level 5, heals 243
		"item:4537",		-- Tel'Abim Banana Vendor  - Level 5, heals 243
		"item:414",		-- Dalaran Sharp Vendor  - Level 5, heals 243
		"item:4541", 		-- "Freshly Baked Bread",	-- Vendor  - Level 5, heals 243
		"item:6890",		-- "Smoked Bear Meat" Cooking - Level 5, heals 243
		"item:6316",		-- "Loch Frenzy Delight" Cooking - Level 5, heals 243 
		"item:5095", 		-- "Rainbow Fin Albacore",	-- Cooking - Level 5, heals 243
		"item:4592",		-- "Longjaw Mud Snapper",	-- Cooking - Level 5, heals 243
		"item:2683",		-- "Crab Cake",		-- Cooking
		"item:2684", 		-- "Coyote Steak",		-- Cooking
		"item:5525",		-- "Boiled Clams",		-- Cooking
		"item:1113",		-- Conjured Bread Mage    - Level 5, heals 243
		"item:5476", 		-- "Fillet of Frenzy",	-- Cooking - Level 5, heals 243, with bonus
		"item:5477",		-- Strider Stew Cooking - Level 5, heals 243, with bonus
		"item:724", 		-- "Goretusk Liver Pie",	-- Cooking - Level 5, heals 243, with bonus
		"item:3220", 		-- "Blood Sausage",	-- Cooking - Level 5, heals 243, with bonus
		"item:3662",		-- "Crocolisk Steak",	-- Cooking - Level 5, heals 243, with bonus
		"item:2687", 		-- "Dry Pork Ribs",	-- Cooking - Level 5, heals 243, with bonus
		"item:3448", 		-- Senggin Root	Horde Quest - Level 1, heals 294, mana 294
		"item:5473",		-- "Scorpid Surprise",	-- Cooking - Level 1, heals 294
		"item:2682",		-- "Cooked Crab Claw",	-- Cooking - Level 5, heals 294
		"item:733",		-- Westfall StewCooking - Level 5, heals 552
		"item:422",		-- "Dwarven Mild",		-- Vendor  - Level 15, heals 552
		"item:4542", 		-- "Moist Cornbread",	-- Vendor  - Level 15, heals 552
		"item:4538",		-- Snapvine Watermelon Vendor  - Level 15, heals 552
		"item:3770",		-- Mutton Chop Vendor  - Level 15, heals 552
		"item:4606",		-- "Spongy Morel",		-- Vendor  - Level 15, heals 552
		"item:16170",		-- "Steamed Mandu" Vendor - Level 15, heals 552
		"item:5526",		-- "Clam Chowder" Cooking - Level 10, heals 552
		"item:5478",		-- "Dig Rat Stew" Cooking - Level 10, heals 552
		"item:2685",		-- "Succulent Pork Ribs" Cooking - Level 10, heals 552 
		"item:4593",		-- Bristle Whisker Catfish Cooking - Level 15, heals 552
		"item:1114",		-- Conjured Rye Mage    - Level 15, heals 552
		"item:1082", 		-- "Redridge Goulash",	-- Cooking - Level 10, heals 552, with bonus
		"item:5479", 		-- "Crispy Lizard Tail",	-- Cooking - Level 12, heals 552, with bonus
		"item:1017",		-- "Seasoned Wolf Kabob" Cooking - Level 15, heals 552, with bonus
		"item:3663",		-- "Murloc Fin Soup" Cooking - Level 15, heals 552, with bonus 
		"item:3726",		-- "Big Bear Steak",	-- Cooking - Level 15, heals 552, with bonus
		"item:5480", 		-- "Lean Venison" Cooking - Level 15, heals 552, with bonus
		"item:3666", 		-- "Gooey Spider Cake" Cooking - Level 15, heals 552, with bonus
		"item:3664", 		-- "Crocolisk Gumbo" Cooking - Level 15, heals 552, with bonus 
		"item:5527",		-- "Goblin Deviled Clams",	-- Cooking - Level 15, heals 552, with bonus
		"item:3727",		-- "Hot Lion Chops",	-- Cooking - Level 15, heals 552, with bonus
		"item:12209", 		-- "Lean Wolf Steak",	-- Cooking - Level 15, heals 552, with bonus
		"item:3665",		-- "Curiously Tasty Omelet",-- Cooking - Level 15, heals 552, with bonus
		"item:4594", 		-- "Rockscale Cod",	-- Cooking - Level 25, heals 874
		"item:8364",		-- Mithril Head Trout Cooking - Level 25, heals 874
		"item:16169",		-- "Wild Ricecake",	-- Vendor  - Level 25, heals 874
		"item:4607", 		-- "Delicious Cave Mold",	-- Vendor  - Level 25, heals 874
		"item:3771",		-- Wild Hog Shank Vendor  - Level 25, heals 874
		"item:4539",		-- Goldenbark Apple Vendor  - Level 25, heals 874
		"item:4544",		-- Mulgore Spice Bread Vendor  - Level 25, heals 874
		"item:1707",		-- Stormwind Brie Vendor  - Level 25, heals 874
		"item:1487",		-- Conjured Pumpernickel Mage    - Level 25, heals 874
		"item:3728",		-- "Tasty Lion Steak",	-- Cooking - Level 20, heals 874, with bonus
		"item:4457",		-- "Barbecued Buzzard Wing",-- Cooking - Level 25, heals 874, with bonus
		"item:12213",		-- "Carrion Surprise",	-- Cooking - Level 25, heals 874, with bonus
		"item:6038",		-- "Giant Clam Corcho",	-- Cooking - Level 25, heals 874, with bonus
		"item:3729",		-- "Soothing Turtle Bisque",-- Cooking - Level 25, heals 874, with bonus
		"item:13851",		-- "Hot Wolf Ribs",	-- Cooking - Level 25, heals 874, with bonus
		"item:12214",		-- "Mystery Stew",		-- Cooking - Level 25, heals 874, with bonus
		"item:12210",		-- "Roast Raptor",		-- Cooking - Level 25, heals 874, with bonus
		"item:12212", 		-- "Jungle Stew",		-- Cooking - Level 25, heals 874, with bonus
		"item:17222",		-- Spider Sausage Cooking
		"item:13928",		-- "Grilled Squid",	-- Cooking - Level 35, heals 874, with bonus(agility)
		"item:13929",		-- "Hot Smoked Bass",	-- Cooking - Level 35, heals 874, with bonus
		"item:13931", 		-- "Nightfin Soup",	-- Cooking - Level 35, heals 874, with bonus(mana regen)
		"item:13932",		-- "Poached Sunscale Salmon",-- Cooking - Level 35, heals 874, with bonus(hp regen)
		"item:13546",		-- "Bloodbelly Fish",	-- Quest   - Level 25, heals 1392
		"item:3927",		-- "Fine Aged Cheddar",	-- Vendor  - Level 35, heals 1392
		"item:4601",		-- "Soft Banana Bread",	-- Vendor  - Level 35, heals 1392
		"item:4602",		-- "Moon Harvest Pumpkin",	-- Vendor  - Level 35, heals 1392
		"item:4599",		-- Cured Ham Steak Vendor  - Level 35, heals 1392
		"item:4608", 		-- Raw Black Truffle Vendor  - Level 35, heals 1392
		"item:18255",		-- Runn Tum Tuber
		"item:16168",		-- "Heaven Peach",		-- Vendor  - Level 35, heals 1392
		"item:13930",		-- "Filet of Redgill",	-- Cooking - Level 35, heals 1392
		"item:9681",		-- "Grilled King Crawler Legs",-- Quest   - Level 35, heals 1392
		"item:8075",		-- "Conjured Sourdough",	-- Mage    - Level 35, heals 1392
		"item:12215",		-- "Heavy Kodo Stew",	-- Cooking - Level 35, heals 1392, with bonus
		"item:6887",		-- "Spotted Yellowtail",	-- Cooking - Level 35, heals 1392, with bonus
		"item:13927",		-- "Cooked Glossy Mightfish",-- Cooking - Level 35, heals 1392, with bonus
		"item:12216", 		-- "Spider Chilli Crab",	-- Cooking - Level 35, heals 1392, with bonus
		"item:16766",		-- "Undermine Clam Chowder",-- Cooking - Level 35, heals 1392, with bonus
		"item:12218", 		-- "Monster Omlette",	-- Cooking - Level 40, heals 1392, with bonus
		"item:16971",		-- Clamlette Surprise Cooking - Level 40, heals 1392, with bonus
		"item:13934",		-- "Mightfish Steak",	-- Cooking - Level 45, heals 1933, with bonus
		"item:11950",		-- "Windblossom Berries",	-- Felwood, heals 1933, with bonus
		"item:16171",		-- "Shinsollo",		-- Vendor  - Level 45, heals 2148
		"item:8952", 		-- Roasted Quail Vendor  - Level 45, heals 2148
		"item:8953", 		-- Deep Fried Plantains Vendor  - Level 45, heals 2148
		"item:8950",		-- Homemade Cherry Pie Vendor  - Level 45, heals 2148
		"item:8932", 		-- Alterac Swiss Vendor  - Level 45, heals 2148 
		"item:8948", 		-- Dried King Bolete Vendor  - Level 45, heals 2148
		"item:8957", 		-- "Spinefin Halibut",	-- Vendor  - Level 45, heals 2148
		"item:13935",		-- "Baked Salmon",		-- Cooking - Level 45, heals 2148
		"item:13933", 		-- "Lobster Stew",		-- Cooking - Level 45, heals 2148
		"item:8076",		-- "Conjured Sweet Roll",	-- Mage    - Level 45, heals 2148
		"item:18254",		-- "Runn Tum Tuber Surprise", int bonus
	},
	["SHARPENINGSTONES"] = {
		"item:2862",		-- "Rough Sharpening Stone",
		"item:2863",		-- "Coarse Sharpening Stone",
		"item:2871",		-- "Heavy Sharpening Stone",
		"item:7964",		-- "Solid Sharpening Stone",
		"item:12404",		-- "Dense Sharpening Stone",
	}, 
	["WEIGHTSTONE"] = {
		"item:3239",		-- "Rough Weightstone",
		"item:3240",		-- "Coarse Weightstone",
		"item:3241", 		-- "Heavy Weightstone"
		"item:7965", 		-- "Solid Weightstone"
		"item:12643", 		-- "Dense Weightstone" 
	},
	["POISON-CRIPPLING"] = {
		"item:3775",		-- "Crippling Poison",
		"item:3776", 		-- "Crippling Poison II",
	},
	["POISON-DEADLY"] = {
		"item:2892",		-- "Deadly Poison",
		"item:2893",		-- "Deadly Poison II"
		"item:8984",		-- "Deadly Poison III"
		"item:8985",		-- "Deadly Poison IV" 
	},
	["POISON-INSTANT"] = {
		"item:6947",		-- "Instant Poison",
		"item:6949",		-- "Instant Poison II",
		"item:6950", 		-- "Instant Poison III"
		"item:8926", 		-- "Instant Poison IV"
		"item:8927", 		-- "Instant Poison V",
		"item:8928", 		-- "Instant Poison VI" 
	},
	["POISON-MINDNUMBING"] = {
		"item:5237",		-- "Mind-numbing Poison",
		"item:6951", 		-- "Mind-numbing Poison II"
		"item:9186", 		-- "Mind-numbing Poison III" 
	},
	["POISON-WOUND"] = {
		"item:10918",		-- "Wound Poison"
		"item:10920",		-- "Wound Poison II"
		"item:10921",		-- "Wound Poison III"
		"item:10922",		-- "Wound Poison IV" 
	},
	["EXPLOSIVES"] = {
		"item:4358",		-- "Rough Dynamite",
		"item:4360",		-- "Rough Copper Bomb",
		"item:4365",		-- "Coarse Dynamite",
		"item:4370",		-- "Large Copper Bomb",
		"EZ-Thro Dynamite",
		"item:4374",		-- "Small Bronze Bomb",
		"Heavy Dynamite",
		"item:4380", 		-- "Big Bronze Bomb",
		"Solid Dynamite",
		"Iron Grenade",
		"Portable Bronze Mortar",
		"Big Iron Bomb",
		"Mithril Frag Bomb",
		"item:10577",		-- "Goblin Mortar",
		"The Big One",
		"item:10562",		-- "Hi-Explosive Bomb",
		"Thorium Grenade",
		"Dark Iron Bomb",
		"Arcane Bomb",
	},
	["WHIPPER_ROOT"] = {
		"item:11951",
	},
	["ALTERAC_HEAL"] = {
		"item:17349",		-- "Superior Healing Draught",
		"item:17348",		-- "Major Healing Draught",
	},
	["ALTERAC_MANA"] = {
		"item:17352",		-- "Superior Mana Draught",
		"item:17351",		-- "Major Mana Draught",
	},
	["ALTERAC_BANDAGE"] = {
		"item:19307",		-- "Alterac Heavy Runecloth Bandage",
	},
	["WARSONG_BANDAGE"] = {
		"item:19068",		-- Warsong Gulch Silk Bandage
		"item:19067",		-- Warsong Gulch Mageweave Bandage
		"item:19066",		-- Warsong Gulch Runecloth Bandage
	},
};

local function AutoBar_Button_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetContainerItemCooldown(AutoBar_Watching[this.itemType].bag, AutoBar_Watching[this.itemType].slot);
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

local function AutoBar_Button_UpdateHotkeys(button)
	if (not button) then button = this; end
	local hotkey = getglobal(button:GetName().."HotKey");
	if (button.itemType and AutoBar_Config[AutoBar_Player].hidekeys == 0) then
		local action = "AUTOBAR_BUTTON_"..button.itemType;
		local keyText = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
		keyText = string.gsub(keyText, "CTRL", "C");
		keyText = string.gsub(keyText, "ALT", "A");
		keyText = string.gsub(keyText, "SHIFT", "S");
		hotkey:SetText(keyText);
	else
		hotkey:SetText("");
	end
end

local function AutoBar_SizeBackground(lastButton)
	if (lastButton and lastButton > 0) then
		local width = 0;
		local height = 0;
		local column = AutoBar_Config[AutoBar_Player].columns;
		if (lastButton < column) then column = lastButton; end
		local checkTop = getglobal("AutoBar_Normal_Button1");
		local checkBottom = getglobal("AutoBar_Normal_Button"..lastButton);
		local checkLeft = getglobal("AutoBar_Normal_Button1");
		local checkRight = getglobal("AutoBar_Normal_Button"..column);
		local top = checkTop:GetTop();
		local bottom = checkBottom:GetBottom();
		local left = checkLeft:GetLeft();
		local right = checkRight:GetRight();
		if (not top or not bottom or not left or not right) then 
			AutoBar_NeedResize = 1;
		else
			AutoBar_NeedResize = nil;
			local spacing;
			if (AutoBar_Config[AutoBar_Player].scalebuttons == 1) then
				spacing = math.floor(6*AutoBar_Config[AutoBar_Player].scaling);
			else
				spacing = 6;
			end
			if (AutoBar_Config[AutoBar_Player].microaspect) then
				height = 12+top-bottom;
				width = 12+right-left;
			else
				height = top-bottom+(spacing*2);
				width = right-left+(spacing*2);
			end
			AutoBar_MainMenu:SetWidth(width);
			AutoBar_MainMenu:SetHeight(height);
			AutoBar_Normal:SetWidth(width);
			AutoBar_Normal:SetHeight(height);
		end
	end
end

local function AutoBar_AssignIcons()
	local buttonsAssigned = 0;
	local maxbuttons;
	if (AutoBar_Max_Button_Displayed) then
		maxbuttons = AutoBar_Max_Button_Displayed;
	else
		maxbuttons = 6;
	end
	local i;
	local numstart = 1;
	local numend = 12;
	local numstep = 1;
	if (AutoBar_Config[AutoBar_Player].reversebuttons == 1) then
		numstart = 12;
		numend = 1;
		numstep = -1;
	end
	for i = numstart, numend, numstep do
		if (buttonsAssigned < maxbuttons) then
			local itemType = AutoBar_Config[AutoBar_Player].buttonTypes[i];
			if (itemType and AutoBar_Watching[itemType].bag and AutoBar_Watching[itemType].slot and AutoBar_Watching[itemType].count) then
				buttonsAssigned = buttonsAssigned + 1;
				local buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonsAssigned);
				local buttonNormal = getglobal("AutoBar_Normal_Button"..buttonsAssigned);
				if (buttonMain and buttonNormal) then
					buttonMain.itemType = itemType;
					buttonNormal.itemType = itemType;
					getglobal(buttonMain:GetName().."Icon"):SetTexture(AutoBar_Watching[itemType].texture);
					getglobal(buttonNormal:GetName().."Icon"):SetTexture(AutoBar_Watching[itemType].texture);
					buttonMain:Show();
					buttonNormal:Show();
					AutoBar_Button_UpdateHotkeys(buttonMain);
					AutoBar_Button_UpdateHotkeys(buttonNormal);
				end
			elseif (AutoBar_Config[AutoBar_Player].donotskip == 1) then
				buttonsAssigned = buttonsAssigned + 1;
				local buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonsAssigned);
				local buttonNormal = getglobal("AutoBar_Normal_Button"..buttonsAssigned);
				buttonMain.itemType = nil;
				buttonNormal.itemType = nil;
				buttonMain:Hide();
				buttonNormal:Hide();
			end
		end
	end
	AutoBar_ButtonsAssigned = buttonsAssigned;
	AutoBar_SizeBackground(buttonsAssigned);
	for leftover = buttonsAssigned+1, 12, 1 do
		local buttonMain = getglobal("AutoBar_MainMenu_Button"..leftover);
		local buttonNormal = getglobal("AutoBar_Normal_Button"..leftover);
		if (buttonMain and buttonNormal) then
			buttonMain:Hide();
			buttonMain.itemType = nil;
			buttonNormal:Hide();
			buttonNormal.itemType = nil;
		end
	end
	AutoBar_Button_ReSync = 0;
end

local function AutoBar_TileButtons(rows, columns)
	if (not rows) then 
		rows = AutoBar_Config[AutoBar_Player].rows;
	end
	if (not columns) then
		columns = AutoBar_Config[AutoBar_Player].columns;
	end
	local buttonNum;
	local buttonMain;
	local buttonNormal;
	local textureMain;
	local textureNormal;
	local spacing
	local scaling;
	if (AutoBar_Config[AutoBar_Player].scalebuttons == 1) then
		scaling = AutoBar_Config[AutoBar_Player].scaling;
		spacing = math.floor(6*AutoBar_Config[AutoBar_Player].scaling);
	else
		spacing = 6;
		scaling = 1;
	end
	if (AutoBar_Config[AutoBar_Player].microaspect) then
		spacing = 2;
	end
	for buttonNum = 1, 12, 1 do
		buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonNum);
		textureMain = getglobal("AutoBar_MainMenu_Button"..buttonNum.."NormalTexture");
		buttonNormal = getglobal("AutoBar_Normal_Button"..buttonNum);
		textureNormal = getglobal("AutoBar_Normal_Button"..buttonNum.."NormalTexture");
		buttonMain:SetHeight(36*scaling);
		buttonNormal:SetHeight(36*scaling);
		textureMain:SetHeight(64*scaling);
		textureNormal:SetHeight(64*scaling);

		if (AutoBar_Config[AutoBar_Player].microaspect) then
			buttonMain:SetWidth(36*scaling*0.7);
			textureMain:SetWidth(64*scaling*0.7);
			buttonNormal:SetWidth(36*scaling*0.7);
			textureNormal:SetWidth(64*scaling*0.7);
		else
			buttonMain:SetWidth(36*scaling);
			textureMain:SetWidth(64*scaling);
			buttonNormal:SetWidth(36*scaling);
			textureNormal:SetWidth(64*scaling);
		end
	end
	buttonNum = 2;
	AutoBar_Normal_Button1:ClearAllPoints();
	if (spacing < 6) then
		AutoBar_Normal_Button1:SetPoint("TOPLEFT","AutoBar_Normal","TOPLEFT",6,-6);
	else
		AutoBar_Normal_Button1:SetPoint("TOPLEFT","AutoBar_Normal","TOPLEFT",spacing,spacing*-1);
	end
	buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonNum);
	buttonNormal = getglobal("AutoBar_Normal_Button"..buttonNum);
	local rowsDone = 1;
	local columnsDone = 1;
	local prevRowMain = "AutoBar_MainMenu_Button1";
	local prevRowNormal = "AutoBar_Normal_Button1";
	local setupDone = false;
	while (buttonMain and buttonNormal and not setupDone) do
		columnsDone = columnsDone + 1;
		if (columnsDone > columns) then
			columnsDone = 1;
			rowsDone = rowsDone + 1;
		end
			
		buttonMain:ClearAllPoints();
		buttonNormal:ClearAllPoints();
		if (rowsDone > rows) then
			setupDone = true;
			buttonNum = buttonNum - 1;
		elseif (columnsDone == 1) then
			buttonMain:SetPoint("TOP",prevRowMain,"BOTTOM",0,spacing*-1);
			buttonNormal:SetPoint("TOP",prevRowNormal,"BOTTOM",0,spacing*-1);
			prevRowMain = "AutoBar_MainMenu_Button"..buttonNum;
			prevRowNormal = "AutoBar_Normal_Button"..buttonNum;
			buttonMain.row = rowsDone;
			buttonMain.column = columnsDone;
			buttonNormal.row = rowsDone;
			buttonNormal.column = columnsDone;
		else
			buttonMain:SetPoint("LEFT","AutoBar_MainMenu_Button"..(buttonNum-1),"RIGHT",spacing,0);
			buttonNormal:SetPoint("LEFT","AutoBar_Normal_Button"..(buttonNum-1),"RIGHT",spacing,0);
			buttonMain.row = rowsDone;
			buttonMain.column = columnsDone;
			buttonNormal.row = rowsDone;
			buttonNormal.column = columnsDone;
		end
		buttonNum = buttonNum + 1;
		buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonNum);
		buttonNormal = getglobal("AutoBar_Normal_Button"..buttonNum);
	end
	AutoBar_Max_Button_Displayed = buttonNum-1;
	AutoBar_AssignIcons();
end

local function AutoBar_Dock(override)
	if (not override) then
		override = AutoBar_Config[AutoBar_Player].docked;
	end
	if (not override) then
		override = "MAINMENU";
		AutoBar_Config[AutoBar_Player].docked = "MAINMENU";
	end
	if (override == "LOCKED" and (not AutoBar_Config[AutoBar_Player].lockedLeft or not AutoBar_Config[AutoBar_Player].lockedTop)) then
		DEFAULT_CHAT_FRAME:AddMessage("AutoBar: In Locked state without information on where! Resetting to Main Menu docking");
		override = "UNDOCKED";
		AutoBar_Config[AutoBar_Player].docked = "UNDOCKED";
	end
	if (not Gypsy_Print and override ~= "MAINMENU") then
		-- If Gypsy_Print exists, we assume Gypsy is handling this. 
		-- And if not, QUE SERA SERA
		if (AutoBar_EVERFREAKINGHIDTHEGODDAMNMICROBUTTONS) then
			QuestLogMicroButton:SetPoint("BOTTOMLEFT", "TalentMicroButton", "BOTTOMRIGHT", -2, 0);
			CharacterMicroButton:Show();
			SpellbookMicroButton:Show();
			TalentMicroButton:Show();
			QuestLogMicroButton:Show();
			SocialsMicroButton:Show();
			WorldMapMicroButton:Show();
			MainMenuMicroButton:Show();
			HelpMicroButton:Show();
		end
	end

	if (override == "MAINMENU") then
		AutoBar_MainMenu:Show();
		AutoBar_Normal:Hide();
		if (AutoBar_Config[AutoBar_Player].scalebuttons ~= 1 and not AutoBar_Config[AutoBar_Player].microaspect) then
			AutoBar_TileButtons(1, 6);
		else
			AutoBar_TileButtons();
		end
		UpdateTalentButton = function() return; end
		CharacterMicroButton:Hide();
		SpellbookMicroButton:Hide();
		TalentMicroButton:Hide();
		QuestLogMicroButton:Hide();
		SocialsMicroButton:Hide();
		WorldMapMicroButton:Hide();
		MainMenuMicroButton:Hide();
		HelpMicroButton:Hide();
		AutoBar_EVERFREAKINGHIDTHEGODDAMNMICROBUTTONS = 1;
	else
		AutoBar_MainMenu:Hide();
		AutoBar_Normal:Show();
	end

	if (override == "UNDOCKED") then
		if (AutoBar_Config[AutoBar_Player].scalebuttons == 1) then
			spacing = math.floor(6*AutoBar_Config[AutoBar_Player].scaling);
		else
			spacing = 6;
		end
		AutoBar_Normal_Move:Show();
		AutoBar_Normal_Backdrop:Show();
		AutoBar_TileButtons();
	else
		AutoBar_Normal_Move:Hide();
		AutoBar_Normal_Backdrop:Hide();
	end

	if (override == "RESET") then
		AutoBar_Normal:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
	elseif (override == "HIDE") then
		AutoBar_Normal:Hide();
		AutoBar_MainMenu:Hide();
	elseif (override == "LOCKED") then
		AutoBar_Normal:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",AutoBar_Config[AutoBar_Player].lockedLeft,AutoBar_Config[AutoBar_Player].lockedTop);
		AutoBar_TileButtons();
	elseif (string.find(override,"CHATFRAME")) then
		local idx,ridx = string.find(AutoBar_Config[AutoBar_Player].docked,"CHATFRAME");
		local rest = string.sub(AutoBar_Config[AutoBar_Player].docked,ridx+1);
		local frame = "1";
		local side = "LEFT";
		idx,ridx = string.find(rest,"_");
		if (idx and ridx and ridx > 1) then
			frame = tonumber(string.sub(rest,1,ridx-1));
			if (frame and frame > 0) then
				frame = tostring(frame);
			else
				frame = "1";
			end
		end
		rest = string.sub(rest,idx+1);
		if (rest == "TOP" or rest == "BOTTOM" or rest == "LEFT" or rest == "RIGHT") then
			side = rest;
		end
		local framename = "ChatFrame"..frame;
		AutoBar_TileButtons();
		AutoBar_Normal:ClearAllPoints();
		if (side == "LEFT") then
			AutoBar_Normal:SetPoint("TOPRIGHT",framename,"TOPLEFT",0,6);
		elseif (side == "RIGHT") then
			AutoBar_Normal:SetPoint("TOPLEFT",framename,"TOPRIGHT",0,6);
		elseif (side == "TOP") then
			AutoBar_Normal:SetPoint("BOTTOMLEFT",framename,"TOPLEFT",-6,0);
		elseif (side == "BOTTOM") then
			AutoBar_Normal:SetPoint("TOPLEFT",framename,"BOTTOMLEFT",-6,0);
		end
	end
end

local function AutoBar_SlashCmd(msg)
	msg = string.lower (msg);
	if (msg == "config") then
		AutoBar_EditConfig();
	elseif (msg == "lock") then
		AutoBar_EngageLock();
	elseif (msg == "reset") then
		AutoBar_Dock("RESET");
	elseif (msg == "hide") then
		AutoBar_Config[AutoBar_Player].docked = "HIDE";
		AutoBar_Dock("HIDE");
	elseif (msg == "dock" or msg == "main" or msg == "mainmenu" or msg == "menu") then
		AutoBar_Config[AutoBar_Player].docked = "MAINMENU";
		AutoBar_Dock("MAINMENU");
	elseif (msg == "undock") then
		AutoBar_Config[AutoBar_Player].docked = "UNDOCKED";
		AutoBar_Dock("UNDOCKED");
		AutoBar_Normal:ClearAllPoints();
		AutoBar_Normal:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
	elseif (msg == "keyhide") then
		AutoBar_Config[AutoBar_Player].hidekeys = 1;
		DEFAULT_CHAT_FRAME:AddMessage("AutoBar: Keybindings hidden");
		local idx = 1;
		local buttonMain = getglobal("AutoBar_MainMenu_Button"..idx);
		local buttonNormal = getglobal("AutoBar_Normal_Button"..idx);
		while (buttonMain and buttonNormal) do
			AutoBar_Button_UpdateHotkeys(buttonMain);
			AutoBar_Button_UpdateHotkeys(buttonNormal);
			idx = idx + 1;
			buttonMain = getglobal("AutoBar_MainMenu_Button"..idx);
			buttonNormal = getglobal("AutoBar_Normal_Button"..idx);
		end
	elseif (msg == "keyshow") then
		AutoBar_Config[AutoBar_Player].hidekeys = 0;
		DEFAULT_CHAT_FRAME:AddMessage("AutoBar: Keybindings shown");
		local idx = 1;
		local buttonMain = getglobal("AutoBar_MainMenu_Button"..idx);
		local buttonNormal = getglobal("AutoBar_Normal_Button"..idx);
		while (buttonMain and buttonNormal) do
			AutoBar_Button_UpdateHotkeys(buttonMain);
			AutoBar_Button_UpdateHotkeys(buttonNormal);
			idx = idx + 1;
			buttonMain = getglobal("AutoBar_MainMenu_Button"..idx);
			buttonNormal = getglobal("AutoBar_Normal_Button"..idx);
		end
	elseif (msg == "selfcast") then
		if (AutoBar_Config[AutoBar_Player].selfcast == 0) then
			AutoBar_Config[AutoBar_Player].selfcast = 1;
			DEFAULT_CHAT_FRAME:AddMessage("AutoBar: Self cast turned on");
		else
			AutoBar_Config[AutoBar_Player].selfcast = 0;
			DEFAULT_CHAT_FRAME:AddMessage("AutoBar: Self cast turned off");
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("/autobar config - Bring up config menu (or use keybinding)");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar keyhide - Hide button keybindings");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar keyshow - Hide button keybindings");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar selfcast - Toggle self cast for beneficial items");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar hide - Hide all buttons, but leave keybindings functional");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar undock - Move buttons to a movable area");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar lock - Lock buttons in current location");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar reset - Reset the movable area");
		DEFAULT_CHAT_FRAME:AddMessage("/autobar main - Dock buttons into the main menu area");
	end
end

local function AutoBar_Button_UpdateCount(override)
	if (not override) then
		override = this;
	end
	local text = getglobal(override:GetName().."Count");
	local count = AutoBar_Watching[override.itemType].count;
	local count_lesser = AutoBar_Watching[override.itemType].count_lesser;
	if (count and (count > 1 or count_lesser) and not AutoBar_Config[AutoBar_Player].hidecount) then
		if (count_lesser) then
			text:SetText(count.."/"..count_lesser);
		else
			text:SetText(count);
		end
	else
		text:SetText("");
	end
end

local function AutoBar_ItemType_UpdateCount(itemType)
	local buttonNum = 1;
	local buttonMain = nil;
	local buttonNormal = nil;
	while (buttonNum < 12 and not buttonMain) do
		buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonNum);
		buttonNormal = getglobal("AutoBar_Normal_Button"..buttonNum);
		if (buttonMain.itemType ~= itemType) then buttonMain = nil; end
		buttonNum = buttonNum + 1;
	end
	if (buttonMain and buttonNormal) then
		AutoBar_Button_UpdateCount(buttonMain);
		AutoBar_Button_UpdateCount(buttonNormal);
	end
end

local function AutoBar_SetItem(bag, slot, itemType, itemIdx, itemName)
	if (AutoBar_Watching[itemType].itemIdx == itemIdx) then
		local texture, itemCount = GetContainerItemInfo(bag,slot);
		if (AutoBar_Watching[itemType].count and itemCount) then
			AutoBar_Watching[itemType].count = AutoBar_Watching[itemType].count+itemCount;
		else
			AutoBar_Watching[itemType].count = itemCount;
		end
	elseif (AutoBar_Watching[itemType].itemIdx_lesser == itemIdx) then
		local texture, itemCount = GetContainerItemInfo(bag,slot);
		if (AutoBar_Watching[itemType].count_lesser and itemCount) then
			AutoBar_Watching[itemType].count_lesser = AutoBar_Watching[itemType].count_lesser+itemCount;
		else
			AutoBar_Watching[itemType].count_lesser = itemCount;
		end
	elseif (not AutoBar_Watching[itemType].itemIdx or (AutoBar_Watching[itemType].itemIdx<itemIdx)) then
		if ((itemType == "BANDAGES" or itemType == "HEALPOTIONS" or itemType == "MANAPOTIONS") and AutoBar_Watching[itemType].itemIdx and (not AutoBar_Watching[itemType].itemIdx_lesser or 
			AutoBar_Watching[itemType].itemIdx_lesser < AutoBar_Watching[itemType].itemIdx)) then
			AutoBar_Watching[itemType].count_lesser = AutoBar_Watching[itemType].count;
			AutoBar_Watching[itemType].itemName_lesser = AutoBar_Watching[itemType].itemName;
			AutoBar_Watching[itemType].itemType_lesser = AutoBar_Watching[itemType].itemType;
			AutoBar_Watching[itemType].itemIdx_lesser = AutoBar_Watching[itemType].itemIdx;
			AutoBar_Watching[itemType].bag_lesser = AutoBar_Watching[itemType].bag;
			AutoBar_Watching[itemType].slot_lesser = AutoBar_Watching[itemType].slot;
		end
		local texture, itemCount = GetContainerItemInfo(bag,slot);
		AutoBar_Watching[itemType].texture = texture;
		AutoBar_Watching[itemType].itemIdx = itemIdx;
		AutoBar_Watching[itemType].itemType = itemType;
		AutoBar_Watching[itemType].itemName = itemName;
		AutoBar_Watching[itemType].bag = bag;
		AutoBar_Watching[itemType].slot = slot;
		AutoBar_Watching[itemType].count = itemCount;
		AutoBar_Button_ReSync = 1;
	elseif ((itemType == "BANDAGES" or itemType == "HEALPOTIONS" or itemType == "MANAPOTIONS") and AutoBar_Watching[itemType].itemIdx and (not AutoBar_Watching[itemType].itemIdx_lesser or AutoBar_Watching[itemType].itemIdx_lesser < itemIdx)) then
		local texture, itemCount = GetContainerItemInfo(bag,slot);
		AutoBar_Watching[itemType].count_lesser = itemCount;
		AutoBar_Watching[itemType].itemName_lesser = itemName;
		AutoBar_Watching[itemType].itemType_lesser = itemType;
		AutoBar_Watching[itemType].itemIdx_lesser = itemIdx;
		AutoBar_Watching[itemType].bag_lesser = bag;
		AutoBar_Watching[itemType].slot_lesser = slot;
	end
	AutoBar_ItemType_UpdateCount(itemType);
end

local function AutoBar_LinkDecode(link)
	local id;
	local name;
	-- for id,name in string.gfind(link,"|c%x%x%x%x%x%x%x%x|H(item:%d+:%d+:%d+:%d+)|h%[([^]]+)%]|h|r$") do 
	for id,name in string.gfind(link,"|H(item:%d+):%d+:%d+:%d+|h%[([^]]+)%]|h|r$") do 
		-- Only first number of itemid is significant in this.
		if (id and name) then
			return name, id;
		end
	end
end

local function AutoBar_LinkSave(name, id, typ)
	if (not string.find(typ,"^CUSTOM")) then
		if (not AutoBar_NewIDs) then AutoBar_NewIDs = {}; end
		if (name and id and not AutoBar_NewIDs[name]) then
			AutoBar_NewIDs.version = AUTOBAR_VERSION;
			AutoBar_NewIDs[name] = {};
			AutoBar_NewIDs[name].id = id;
			AutoBar_NewIDs[name].typ = typ;
			DEFAULT_CHAT_FRAME:AddMessage("AutoBar: New ID found for "..name..", check your SavedVariables.lua file and upload the AutoBar_NewIDs variable block to the forum!");
			RegisterForSave("AutoBar_NewIDs");
		end
	end
end

local function AutoBar_VerifyItems()
	local function Clear(itemType)
		AutoBar_Watching[itemType].bag = nil;
		AutoBar_Watching[itemType].slot = nil;
		AutoBar_Watching[itemType].bag_lesser = nil;
		AutoBar_Watching[itemType].slot_lesser = nil;
		AutoBar_Watching[itemType].itemIdx = nil;
		AutoBar_Watching[itemType].itemIdx_lesser = nil;
		AutoBar_Button_ReSync = 1;
	end

	local itemType;

	for itemType in AutoBar_Items do
		if (AutoBar_Watching[itemType].bag) then
			local recordedName = AutoBar_Watching[itemType].itemName;
			local itemLink = GetContainerItemLink(AutoBar_Watching[itemType].bag,AutoBar_Watching[itemType].slot);
			if (AutoBar_CatInfo[itemType].merged or AutoBar_CatInfo[itemType].custom) then
				local start, duration, enable = GetContainerItemCooldown(AutoBar_Watching[itemType].bag, AutoBar_Watching[itemType].slot);
				if (start > 0 and duration > 0) then
					Clear(itemType);
				end
			end
			if (recordedName and itemLink) then
				local itemName, itemID = AutoBar_LinkDecode(itemLink);
				if (not itemName or itemName ~= recordedName) then
					Clear(itemType);
				end
			else
				Clear(itemType);
			end
		end
	end
end

local function AutoBar_ItemSearch()
	local bag; 
	local slot; 
	local idx; 
	local item; 
	local itemType = nil; 
	local itemIdx = nil; 
	local itemName = nil; 
	local itemLink = nil;
	local itemID = nil;
	local size; 
	local searchItemType = nil;

	AutoBar_VerifyItems();
	for searchItemType in AutoBar_Items do
		AutoBar_Watching[searchItemType].count = nil;
		AutoBar_Watching[searchItemType].count_lesser = nil;
	end
	for bag = 0, 4, 1 do
		if (bag == 0) then
			size = 16;
		else
			size = GetContainerNumSlots(bag);
		end
		if (size and size > 0) then
			for slot = 1, size, 1 do
				itemType = nil; itemIdx = nil; itemName=nil;
				itemLink = GetContainerItemLink(bag,slot);
				if (itemLink) then
					itemName, itemID = AutoBar_LinkDecode(itemLink);
					for searchItemType in AutoBar_Items do
						if (not itemType and AutoBar_Watching[searchItemType].watching) then
							for idx,item in AutoBar_Items[searchItemType] do
								if (itemID == item) then
									itemType = searchItemType
									itemIdx = idx;
								elseif (itemName == item) then
									itemType = searchItemType
									itemIdx = idx;
									AutoBar_LinkSave(itemName, itemID, itemType);
								end
							end
						end
					end
					if (itemType) then
						if (AutoBar_CatInfo[itemType].merged or AutoBar_CatInfo[itemType].custom) then
							local start, duration, enable = GetContainerItemCooldown(bag, slot);
							if (start and duration and enable) then
							end
							if (start > 0 and duration > 0) then
								-- Don't add items in cooldown
								local left = start-GetTime()+duration;
								if (not AutoBar_ScheduledResync or AutoBar_ScheduledResync > (start+duration)) then
									AutoBar_ScheduledResync = start+duration;
								end
							else
								AutoBar_SetItem(bag, slot, itemType, itemIdx, itemName);
							end
						else
							AutoBar_SetItem(bag, slot, itemType, itemIdx, itemName);
						end
					end
				end
			end
		end
	end
	if (AutoBar_Button_ReSync == 1) then
		AutoBar_AssignIcons();
	end
end

local function AutoBar_UpdateMerged()
	local function AddList (to, from)
		local i = 1;
		while (AutoBar_Items[from][i]) do
			table.insert(AutoBar_Items[to], AutoBar_Items[from][i]);
			i = i + 1;
		end
	end

	local zone = GetZoneText();
	if (zone) then
		AutoBar_CurrentZone = zone;
		AutoBar_Items["MERGED_HEAL"] = { };
		AddList("MERGED_HEAL","HEALPOTIONS");
		AddList("MERGED_HEAL","WHIPPER_ROOT");
		if (zone == AutoBar_CatInfo["ALTERAC_HEAL"].location) then
			AddList("MERGED_HEAL","ALTERAC_HEAL");
		end
		AddList("MERGED_HEAL","HEALTHSTONE");

		AutoBar_Items["MERGED_MANA"] = { };
		AddList("MERGED_MANA","MANAPOTIONS");
		if (zone == AutoBar_CatInfo["ALTERAC_MANA"].location) then
			AddList("MERGED_MANA","ALTERAC_MANA");
		end
		AddList("MERGED_MANA","MANASTONE");

		AutoBar_Items["MERGED_BANDAGE"] = { };
		AddList("MERGED_BANDAGE","BANDAGES");
		if (zone == AutoBar_CatInfo["WARSONG_BANDAGE"].location) then
			AddList("MERGED_BANDAGE","WARSONG_BANDAGE");
		elseif (zone == AutoBar_CatInfo["ALTERAC_BANDAGE"].location) then
			AddList("MERGED_BANDAGE","ALTERAC_BANDAGE");
		end

		-- Reset item tracking because the list just changed.
		if (AutoBar_Watching["MERGED_HEAL"].watching) then
			AutoBar_Watching["MERGED_HEAL"] = {};
			AutoBar_Watching["MERGED_HEAL"].watching = 1;
		end
		if (AutoBar_Watching["MERGED_MANA"].watching) then
			AutoBar_Watching["MERGED_MANA"] = {};
			AutoBar_Watching["MERGED_MANA"].watching = 1;
		end
		if (AutoBar_Watching["MERGED_BANDAGE"].watching) then
			AutoBar_Watching["MERGED_BANDAGE"] = {};
			AutoBar_Watching["MERGED_BANDAGE"].watching = 1;
		end
		AutoBar_ItemSearch();
	end
end


local function AutoBar_ConfigInit()
	if (not AutoBar_Player) then
		DEFAULT_CHAT_FRAME:AddMessage("Config Init called with Player = nil");
		return;
	end
	if (not AutoBar_Config_Loaded) then
		DEFAULT_CHAT_FRAME:AddMessage("Config Init called without config load");
	end
	if (AutoBar_Player and AutoBar_Config_Loaded) then
		if (not AutoBar_Config) then
			AutoBar_Config = {};
		end
		AutoBar_Config.docked = nil;
		if (AutoBar_Config[AutoBar_Player]) then
			local realm = GetCVar("realmName");
			local newplayer = AutoBar_Player.." - "..realm
			AutoBar_Config[newplayer] = AutoBar_Config[AutoBar_Player];
			AutoBar_Config[AutoBar_Player] = nil;
			
			DEFAULT_CHAT_FRAME:AddMessage("AutoBar: Config found for this player with no Realm. Attaching this player to this Realm ("..realm..")");
		end
		AutoBar_Player = AutoBar_Player.." - "..GetCVar("realmName");

		if (not AutoBar_Config[AutoBar_Player]) then
			AutoBar_Config[AutoBar_Player] = {};
		end
		if (not AutoBar_Config[AutoBar_Player].selfcast) then
			AutoBar_Config[AutoBar_Player].selfcast = 0;
		end
		if (not AutoBar_Config[AutoBar_Player].donotskip) then
			AutoBar_Config[AutoBar_Player].donotskip = 0;
		end
		if (not AutoBar_Config[AutoBar_Player].hidekeys) then
			AutoBar_Config[AutoBar_Player].hidekeys = 0;
		end
		if (not AutoBar_Config[AutoBar_Player].reversebuttons) then
			AutoBar_Config[AutoBar_Player].reversebuttons = 0;
		end
		if (not AutoBar_Config[AutoBar_Player].docked) then
			AutoBar_Config[AutoBar_Player].docked = "UNDOCKED";
		end
		if (not AutoBar_Config[AutoBar_Player].rows) then
			AutoBar_Config[AutoBar_Player].rows = 1;
		end
		if (not AutoBar_Config[AutoBar_Player].columns) then
			AutoBar_Config[AutoBar_Player].columns = 6;
		end
		if (AutoBar_Config[AutoBar_Player].independentScaling and
		    AutoBar_Config[AutoBar_Player].independentScaling == 1) then
			AutoBar_Config[AutoBar_Player].scalebuttons = 1;
		end
		if (not AutoBar_Config[AutoBar_Player].scalebuttons) then
			-- CheckButtons require 0 or 1, not true or false
			AutoBar_Config[AutoBar_Player].scalebuttons = 0;
		end
		if (not AutoBar_Config[AutoBar_Player].scaling) then
			AutoBar_Config[AutoBar_Player].scaling = 1;
		end
		if (not AutoBar_Config[AutoBar_Player].custom) then
			AutoBar_Config[AutoBar_Player].custom = {};
		end
		if (not AutoBar_Config[AutoBar_Player].buttonTypes) then
			AutoBar_Config[AutoBar_Player].buttonTypes = {};
			AutoBar_Config[AutoBar_Player].buttonTypes[1] = "MERGED_BANDAGE";
			AutoBar_Config[AutoBar_Player].buttonTypes[2] = "MERGED_HEAL";
			if (AutoBar_PlayerClass == "Warrior") then
				AutoBar_Config[AutoBar_Player].buttonTypes[3] = "RAGEPOTIONS";
			elseif (AutoBar_PlayerClass == "Rogue") then
				AutoBar_Config[AutoBar_Player].buttonTypes[3] = "ENERGYPOTIONS";
			else
				AutoBar_Config[AutoBar_Player].buttonTypes[3] = "MERGED_MANA";
			end
			if (AutoBar_PlayerClass ~= "Warrior" and AutoBar_PlayerClass ~= "Rogue") then
				AutoBar_Config[AutoBar_Player].buttonTypes[4] = "WATER";
			end
			AutoBar_Config[AutoBar_Player].buttonTypes[12] = "HEARTHSTONE";
		end
		if (AutoBar_Config[AutoBar_Player].buttonTypes[1] == "MERGE_BANDAGE") then
			AutoBar_Config[AutoBar_Player].buttonTypes[1] = "MERGED_BANDAGE";
		end
		if (AutoBar_Config[AutoBar_Player].buttonTypes[2] == "MERGE_HEAL") then
			AutoBar_Config[AutoBar_Player].buttonTypes[2] = "MERGED_HEAL";
		end
		if (AutoBar_Config[AutoBar_Player].buttonTypes[3] == "MERGE_MANA") then
			AutoBar_Config[AutoBar_Player].buttonTypes[3] = "MERGED_MANA";
		end


		if (AutoBar_Config[AutoBar_Player].hideforbags) then
			AutoBar_Config[AutoBar_Player].hideforbags = nil;
		end
		AutoBar_Init();
	end
	if (AutoBar_NewIDs) then
		if (not AutoBar_NewIDs.version or AutoBar_NewIDs.version ~= AUTOBAR_VERSION) then
			AutoBar_NewIDs = nil;
		else
			RegisterForSave("AutoBar_NewIDs");
		end
	end
	AutoBar_UpdateMerged();
end

local function AutoBar_Button_Use_Final (itemType, bag, slot)
	--[[
	if (AutoBar_CatInfo[itemType].abort) then
		Debug (itemType.." has abort function");
		if (AutoBar_CatInfo[itemType].abort()) then
			Debug (itemType.." was true");
			if (AutoBar_CatInfo[itemType].abortmessage) then
				DEFAULT_CHAT_FRAME:AddMessage(AutoBar_CatInfo[itemType].abortmessage);
			end
			return;
		end
	end
	]]
	UseContainerItem(bag, slot);
	if (AutoBar_CatInfo[itemType].beneficial and AutoBar_CatInfo[itemType].targetted and AutoBar_Config[AutoBar_Player].selfcast == 1) then
		if (SpellIsTargeting()) then
			SpellTargetUnit("player");
		end
	end
	if (AutoBar_CatInfo[itemType].merged) then
		AutoBar_ItemSearch();
	end
end

function AutoBar_Button_Use(itemType)
	local idx = string.find(itemType,"_LESSER");
	local lesser = nil;
	if (idx) then
		lesser = 1;
		itemType = string.sub (itemType,1,idx-1);
	end
	if (not AutoBar_CatInfo[itemType].usable) then 
		return;
	end
	local bag = AutoBar_Watching[itemType].bag;
	local slot = AutoBar_Watching[itemType].slot;
	local bag_lesser = AutoBar_Watching[itemType].bag_lesser;
	local slot_lesser = AutoBar_Watching[itemType].slot_lesser;
	if (lesser and bag_lesser and slot_lesser) then
		local recordedName = AutoBar_Watching[itemType].itemName_lesser;
		local itemLink = GetContainerItemLink(bag_lesser,slot_lesser);
		if (recordedName and itemLink) then
			local itemName, itemID = AutoBar_LinkDecode(itemLink);
			if (itemName and itemName == recordedName) then
				AutoBar_Button_Use_Final(itemType, bag_lesser, slot_lesser);
			end
		end
	elseif (lesser) then
		DEFAULT_CHAT_FRAME:AddMessage("You have no lesser items for category "..AutoBar_CatInfo[itemType].description);
	elseif (bag and slot) then
		local recordedName = AutoBar_Watching[itemType].itemName;
		local itemLink = GetContainerItemLink(bag,slot);
		if (recordedName and itemLink) then
			local itemName, itemID = AutoBar_LinkDecode(itemLink);
			if (itemName and itemName == recordedName) then
				AutoBar_Button_Use_Final(itemType, bag, slot);
			end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("You have no items for category "..AutoBar_CatInfo[itemType].description);
	end
end

function AutoBar_DisplayLink (foo, bar)
	local bag;
	local slot;
	local itemLink;
	local itemName;
	local itemID;
	if (foo and bar) then
		bag = tonumber(foo);
		slot = tonumber(bar);
	else
		local searchbag;
		local searchslot;
		local size;
		for searchbag = 0, 4, 1 do
			if (searchbag == 0) then
				size = 16;
			else
				size = GetContainerNumSlots(searchbag);
			end
			if (size and size > 0) then
				for searchslot = 1, size, 1 do
					itemLink = GetContainerItemLink(searchbag,searchslot);
					if (itemLink) then
						itemName, itemID = AutoBar_LinkDecode(itemLink);
						if (itemName and itemName == foo) then
							bag = searchbag;
							slot = searchslot;
						end
					end
				end
			end
		end
	end
	if (bag and slot) then
		itemLink = GetContainerItemLink(bag,slot);
		if (itemLink) then
			itemName, itemID = AutoBar_LinkDecode(itemLink);
		end
		if (itemLink and itemName) then
			message(itemName.."\n"..itemID);
			AutoBar_LinkSave(itemName, itemID, "MANUAL")
		else
			if (bar) then
				message ("Item not found:"..foo.." / "..bar);
			else
				message ("Item not found: "..foo);
			end
		end
	end
end

function AutoBar_EngageLock()
	if (AutoBar_Config[AutoBar_Player].docked == "UNDOCKED") then
		local left = AutoBar_Normal:GetLeft();
		local top = AutoBar_Normal:GetTop();
		AutoBar_Normal:ClearAllPoints();
		AutoBar_Normal:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",left,top);
		AutoBar_Normal_Move:Hide();
		AutoBar_Normal_Backdrop:Hide();
		AutoBar_Config[AutoBar_Player].lockedLeft = left;
		AutoBar_Config[AutoBar_Player].lockedTop = top;
		AutoBar_Config[AutoBar_Player].docked = "LOCKED";
	else
		DEFAULT_CHAT_FRAME:AddMessage("You can only lock when in the undocked position");
	end
end

function AutoBar_Init()
	local i;
	local startidx;
	local endidx;
	local itemType;
	AutoBar_Items["CUSTOM1"] = nil;
	AutoBar_Items["CUSTOM2"] = nil;
	AutoBar_Items["CUSTOM3"] = nil;
	AutoBar_Items["CUSTOM4"] = nil;
	AutoBar_Items["CUSTOM5"] = nil;
	AutoBar_Items["CUSTOM6"] = nil;
	AutoBar_Items["CUSTOM7"] = nil;
	AutoBar_Items["CUSTOM8"] = nil;
	AutoBar_Items["CUSTOM9"] = nil;
	AutoBar_Items["CUSTOM10"] = nil;
	AutoBar_Items["CUSTOM11"] = nil;
	AutoBar_Items["CUSTOM12"] = nil;
	for i = 1, 12, 1 do
		if (AutoBar_Config[AutoBar_Player].buttonTypes[i]) then
			startidx, endidx = string.find(AutoBar_Config[AutoBar_Player].buttonTypes[i],"CUSTOM");
			if (startidx) then
				local customnum = string.sub(AutoBar_Config[AutoBar_Player].buttonTypes[i],endidx+1) * 1;
				AutoBar_Items[AutoBar_Config[AutoBar_Player].buttonTypes[i]] = 
					AutoBar_Config[AutoBar_Player].custom[customnum];
				AutoBar_CatInfo[AutoBar_Config[AutoBar_Player].buttonTypes[i]].usable = true;
			end
		end
	end
	for itemType in AutoBar_CatInfo do
		AutoBar_Watching[itemType] = {};
	end
	for num,itemType in AutoBar_Config[AutoBar_Player].buttonTypes do
		AutoBar_Watching[itemType] = {};
		AutoBar_Watching[itemType].watching = 1;
	end
	AutoBar_Dock();
	AutoBar_ItemSearch();
	AutoBar_AssignIcons();
end

function AutoBar_OnLoad()
	RegisterForSave("AutoBar_Config");

	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA");

	SLASH_AUTOBAR1 = "/autobar";
	SlashCmdList["AUTOBAR"] = function (msg)
		AutoBar_SlashCmd(msg);
	end

	DEFAULT_CHAT_FRAME:AddMessage("AutoBar ("..AUTOBAR_VERSION..") loaded.");
end

function AutoBar_OnUpdate(event)
	if (AutoBar_NeedResize) then
		AutoBar_SizeBackground(AutoBar_ButtonsAssigned);
	end
	if (AutoBar_ScheduledResync and GetTime() >= AutoBar_ScheduledResync) then
		AutoBar_ScheduledResync = nil;
		AutoBar_ItemSearch();
	end
end

function AutoBar_OnEvent(event)
	if (event == "UNIT_INVENTORY_CHANGED" or 
	    event == "BAG_UPDATE") then
		if (AutoBar_Config_Loaded and AutoBar_Player) then
			AutoBar_ItemSearch();
		end
		return;
	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		AutoBar_UpdateMerged();
	elseif (event == "UNIT_NAME_UPDATE" and arg1 == "player") then
		local playerName = UnitName("player");
		if (playerName ~= UKNOWNBEING and playerName ~= UNKNOWNOBJECT) then
			AutoBar_PlayerClass = UnitClass("player");
			AutoBar_Player = playerName;
		end
		if (AutoBar_Player and AutoBar_Config_Loaded) then
			AutoBar_ConfigInit();
		end
	elseif (event == "VARIABLES_LOADED") then
		AutoBar_Config_Loaded = 1;
		if (AutoBar_Player) then
			AutoBar_ConfigInit();
		end
	end
end

function AutoBar_Button_OnLoad()
	this.itemType = nil;

	this:RegisterEvent("UPDATE_BINDINGS");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function AutoBar_Button_Update(elapsed)
	AutoBar_LastUpdate = AutoBar_LastUpdate + elapsed;
	if (AutoBar_LastUpdate < 0.1) then
		return;
	end
	AutoBar_LastUpdate = 0;

	if (this.itemType and AutoBar_Watching[this.itemType].count) then
		this:Show();
		AutoBar_Button_UpdateCount();
		AutoBar_Button_UpdateCooldown();
	else
		this:Hide();
	end
end

function AutoBar_Button_OnEvent(event)
	if (event == "UPDATE_BINDINGS") then
		AutoBar_Button_UpdateHotkeys();
		return;
	end
end

function AutoBar_Button_OnClick(button)
	local itemType = this.itemType;
	if (button == "RightButton" and AutoBar_Watching[itemType].bag_lesser and AutoBar_Watching[itemType].slot_lesser) then
		itemType = itemType.."_LESSER";
	end
	AutoBar_Button_Use(itemType);
end

function AutoBar_Button_SetTooltip()
	if (AutoBar_Watching[this.itemType].bag and AutoBar_Watching[this.itemType].slot) then
		if ( GetCVar("UberTooltips") == "1" ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, this);
		else
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		end
		if ( GameTooltip:SetBagItem(AutoBar_Watching[this.itemType].bag, AutoBar_Watching[this.itemType].slot) ) then
			this.updateTooltip = TOOLTIP_UPDATE_TIME;
		else
			this.updateTooltip = nil;
		end
	end
end


function AutoBar_Down(itemType)
	local buttonnum = 1;
	local buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonnum);
	local buttonNormal = getglobal("AutoBar_Normal_Button"..buttonnum);
	while (buttonNormal and buttonNormal.itemType ~= itemType) do
		buttonnum = buttonnum + 1;
		buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonnum);
		buttonNormal = getglobal("AutoBar_Normal_Button"..buttonnum);
	end
	if (buttonMain and buttonNormal and buttonNormal:GetButtonState() == "NORMAL") then
		buttonMain:SetButtonState("PUSHED");
		buttonNormal:SetButtonState("PUSHED");
	end
end

function AutoBar_Up(itemType)
	local buttonnum = 1;
	local buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonnum);
	local buttonNormal = getglobal("AutoBar_Normal_Button"..buttonnum);
	while (buttonNormal and buttonNormal.itemType ~= itemType) do
		buttonnum = buttonnum + 1;
		buttonMain = getglobal("AutoBar_MainMenu_Button"..buttonnum);
		buttonNormal = getglobal("AutoBar_Normal_Button"..buttonnum);
	end
	if (buttonMain and buttonNormal and buttonNormal:GetButtonState() == "PUSHED") then
		buttonMain:SetButtonState("NORMAL");
		buttonNormal:SetButtonState("NORMAL");
	end
	AutoBar_Button_Use(itemType);
end

--[[
function AutoBar_Dump()
	local txt;
	for itemType in AutoBar_Items do
		txt = itemType..": ";
		if (AutoBar_Watching[itemType].watching) then
			txt = txt.."WATCHING ";
		end
		if (AutoBar_Watching[itemType].bag) then
			txt = txt.."B:"..AutoBar_Watching[itemType].bag.." ";
		end
		if (AutoBar_Watching[itemType].slot) then
			txt = txt.."S:"..AutoBar_Watching[itemType].slot.." ";
		end
		if (AutoBar_Watching[itemType].count) then
			txt = txt.."C:"..AutoBar_Watching[itemType].count.." ";
		end
		if (AutoBar_Watching[itemType].bag_lesser) then
			txt = txt.."BL:"..AutoBar_Watching[itemType].bag_lesser.." ";
		end
		if (AutoBar_Watching[itemType].slot_lesser) then
			txt = txt.."SL:"..AutoBar_Watching[itemType].slot_lesser.." ";
		end
		if (AutoBar_Watching[itemType].count_lesser) then
			txt = txt.."CL:"..AutoBar_Watching[itemType].count_lesser.." ";
		end
		DEFAULT_CHAT_FRAME:AddMessage(txt);
	end
	for i = 1, 12, 1 do
		local buttonMain = getglobal("AutoBar_MainMenu_Button"..i);
		if (buttonMain) then
			if (buttonMain.itemType) then
				DEFAULT_CHAT_FRAME:AddMessage (buttonMain:GetName().." is "..buttonMain.itemType);
			else
				DEFAULT_CHAT_FRAME:AddMessage (buttonMain:GetName().." empty");
			end
		end
	end
end
]]

function AutoBar_StuffItem(itemLink)
	local item; 
	local itemType = nil; 
	local itemIdx = nil; 
	local itemName = nil; 
	local itemID = nil;
	local searchItemType = nil;
	local idx;

	itemType = nil; itemIdx = nil; itemName=nil;
	if (itemLink) then
		itemName, itemID = AutoBar_LinkDecode(itemLink);
		for searchItemType in AutoBar_Items do
			if (not itemType) then
				for idx,item in AutoBar_Items[searchItemType] do
					if (itemID == item) then
						itemType = searchItemType
						itemIdx = idx;
					elseif (itemName == item) then
						itemType = searchItemType
						itemIdx = idx;
						AutoBar_LinkSave(itemName, itemID, itemType);
					end
				end
			end
		end
	end
end

foogoochoo_auction = GetAuctionItemLink;
function foogoo_auction(stuff, id)
	local ret;
	ret = foogoochoo_auction(stuff, id);
	AutoBar_StuffItem(ret);
	return ret;
end
GetAuctionItemLink = foogoo_auction;

foogoochoo_merchant = GetMerchantItemLink;
function foogoo_merchant(id)
	local ret;
	ret = foogoochoo_merchant(id);
	AutoBar_StuffItem(ret);
	return ret;
end
GetMerchantItemLink = foogoo_merchant;

foogoochoo_trade = GetTradeSkillItemLink;
function foogoo_trade(stuff)
	local ret;
	ret = foogoochoo_trade(stuff);
	AutoBar_StuffItem(ret);
	return ret;
end
GetTradeSkillItemLink = foogoo_trade;
