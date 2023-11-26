--[[

	LootLink 3.0: An in-game item database
		copyright 2004 by Telo
	
	- Watches all chat links you see to cache link color and link data
	- Automatically extracts data from items already in or added to your inventory
	- Automatically caches link data from items already in or added to your bank
	- Automatically inspects your target and extracts data for each of their equipped items
	- Automatically gets link data from your auction queries
	- Can perform a fully automatic scan of the entire auction house inventory
	- Stores sell prices for items that you've moused over while a merchant window was open
	  and displays them in the tooltips for stacks of items that you are looting, stacks of items
	  in your inventory and entries in the LootLink browse window
	- Converts green loot messages into correctly colored item messages if the item is cached
	- Provides a browsable, searchable window that allows you to find any item in the cache
	- Allows you to shift-click items in the browse window to insert links in the chat edit box

	- Adds optional mouseover inspect scanning
	
]]

--------------------------------------------------------------------------------------------------
-- Localizable strings
--------------------------------------------------------------------------------------------------
BINDING_HEADER_LOOTLINK = "LootLink Buttons";
BINDING_NAME_TOGGLELOOTLINK = "Toggle LootLink";
LOOTLINK_TITLE = "LootLink";
LOOTLINK_SEARCH_TITLE = "LootLink Search";
LOOTLINK_TITLE_FORMAT_SINGULAR = "LootLink - 1 item total";
LOOTLINK_TITLE_FORMAT_PLURAL = "LootLink - %d items total";
LOOTLINK_TITLE_FORMAT_PARTIAL_SINGULAR = "LootLink - 1 item found";
LOOTLINK_TITLE_FORMAT_PARTIAL_PLURAL = "LootLink - %d items found";
LOOTLINK_SEARCH = "Search...";
LOOTLINK_REFRESH = "Refresh";
LOOTLINK_RESET = "Reset";
LOOTLINK_HELP = "help"; -- must be lowercase; command to display help
LOOTLINK_AUCTION = "auction"; -- must be lowercase; command to scan auctions
LOOTLINK_SCAN = "scan"; -- must be lowercase; alias for command to scan auctions
LOOTLINK_AUCTION_SCAN_START = "LootLink: scanning page 1...";
LOOTLINK_AUCTION_PAGE_N = "LootLink: scanning page %d of %d...";
LOOTLINK_AUCTION_SCAN_DONE = "LootLink: auction scanning finished";
LOOTLINK_SELL_PRICE = "Sell price:";
LOOTLINK_SELL_PRICE_N = "Sell price for %d:";

LOOTLINK_HELP_TEXT0 = " ";
LOOTLINK_HELP_TEXT1 = "|cffffff00LootLink command help:|r";
LOOTLINK_HELP_TEXT2 = "|cff00ff00Use |r|cffffffff/lootlink|r|cff00ff00 or |r|cffffffff/ll|r|cff00ff00 without any arguments to toggle the browse window open or closed.|r";
LOOTLINK_HELP_TEXT3 = "|cff00ff00Use |r|cffffffff/lootlink <command>|r|cff00ff00 or |r|cffffffff/ll <command>|r|cff00ff00 to perform the following commands:|r";
LOOTLINK_HELP_TEXT4 = "|cffffffff"..LOOTLINK_HELP.."|r|cff00ff00: displays this message.|r";
LOOTLINK_HELP_TEXT5 = "|cffffffff"..LOOTLINK_AUCTION.."|r|cff00ff00 or |r|cffffffff"..LOOTLINK_SCAN.."|r|cff00ff00: starts or schedules an automatic scan of all items in the auction house.|r";
LOOTLINK_HELP_TEXT6 = " ";
LOOTLINK_HELP_TEXT7 = "|cff00ff00For example: |r|cffffffff/lootlink scan|r|cff00ff00 will start an auction house scan if the auction window is open.|r";

LOOTLINK_HELP_TEXT = {
	LOOTLINK_HELP_TEXT0,
	LOOTLINK_HELP_TEXT1,
	LOOTLINK_HELP_TEXT2,
	LOOTLINK_HELP_TEXT3,
	LOOTLINK_HELP_TEXT4,
	LOOTLINK_HELP_TEXT5,
	LOOTLINK_HELP_TEXT6,
	LOOTLINK_HELP_TEXT7,
};

LLS_TEXT = "All text:";
LLS_NAME = "Name:";
LLS_RARITY = "Rarity:";
LLS_BINDS = "Binds:";
LLS_UNIQUE = "Is Unique?";
LLS_LOCATION = "Equip location:";
LLS_MINIMUM_LEVEL = "Minimum level:";
LLS_MAXIMUM_LEVEL = "Maximum level:";
LLS_TYPE = "Type:";
LLS_SUBTYPE_ARMOR = "Armor subtype:";
LLS_SUBTYPE_WEAPON = "Weapon subtype:";
LLS_SUBTYPE_SHIELD = "Shield subtype:";
LLS_SUBTYPE_RECIPE = "Recipe subtype:";
LLS_MINIMUM_DAMAGE = "Min. low damage:";
LLS_MAXIMUM_DAMAGE = "Min. high damage:";
LLS_MAXIMUM_SPEED = "Maximum speed:";
LLS_MINIMUM_DPS = "Minimum DPS:";
LLS_MINIMUM_ARMOR = "Minimum armor:";
LLS_MINIMUM_BLOCK = "Minimum block:";
LLS_MINIMUM_SLOTS = "Minimum slots:";
LLS_MINIMUM_SKILL = "Minimum skill:";
LLS_MAXIMUM_SKILL = "Maximum skill:";

ANY = "Any";
POOR = "Poor";
COMMON = "Common";
UNCOMMON = "Uncommon";
RARE = "Rare";
EPIC = "Epic";
DOES_NOT = "Does Not";
ON_EQUIP = "On Equip";
ON_PICKUP = "On Pickup";
--ARMOR = "Armor"; -- already in globalstrings
WEAPON = "Weapon";
SHIELD = "Shield";
CONTAINER = "Container";
OTHER = "Other";
RECIPE = "Recipe";
CLOTH = "Cloth";
LEATHER = "Leather";
MAIL = "Mail";
PLATE = "Plate";
AXE = "Axe";
BOW = "Bow";
DAGGER = "Dagger";
MACE = "Mace";
STAFF = "Staff";
SWORD = "Sword";
GUN = "Gun";
WAND = "Wand";
POLEARM = "Polearm";
FIST_WEAPON = "Fist Weapon";
CROSSBOW = "Crossbow";
BUCKLER = "Buckler";
ALCHEMY = "Alchemy";
BLACKSMITHING = "Blacksmithing";
COOKING = "Cooking";
ENCHANTING = "Enchanting";
ENGINEERING = "Engineering";
LEATHERWORKING = "Leatherworking";
TAILORING = "Tailoring";

-- For sorting
SORT_NAME = "Name";
SORT_RARITY = "Rarity";
SORT_BINDS = "Binds";
SORT_UNIQUE = "Unique";
SORT_LOCATION = "Location";
SORT_TYPE = "Type";
SORT_SUBTYPE = "Subtype";
SORT_MINDAMAGE = "Min Damage";
SORT_MAXDAMAGE = "Max Damage";
SORT_SPEED = "Speed";
SORT_DPS = "DPS";
SORT_ARMOR = "Armor";
SORT_BLOCK = "Block";
SORT_SLOTS = "Slots";
SORT_LEVEL = "Level";
SORT_SKILL = "Skill Level";

--------------------------------------------------------------------------------------------------
-- Local LootLink variables
--------------------------------------------------------------------------------------------------

-- Function hooks
local originalChatFrame_OnEvent;
local lOriginal_CanSendAuctionQuery;
local lOriginal_AuctionFrameBrowse_OnEvent;
local lOriginal_ContainerFrameItemButton_OnEnter;
local lOriginal_ContainerFrame_Update;
local lOriginal_GameTooltip_SetLootItem;
local lOriginal_GameTooltip_SetOwner;
local lOriginal_GameTooltip_ClearMoney;

-- If non-nil, kick off a full auction scan next time auctioneer is used
local lScanAuction;

-- The current owner of the GameTooltip
local lGameToolTipOwner;

local STATE_NAME = 0;
local STATE_BOUND = 1;
local STATE_UNIQUE = 2;
local STATE_LOCATION = 3;
local STATE_TYPE = 4;
local STATE_DAMAGE = 5;
local STATE_DPS = 6;
local STATE_ARMOR = 7;
local STATE_BLOCK = 8;
local STATE_CONTAINER = 9;
local STATE_REQUIRES = 10;
local STATE_FINISH = 11;

local BINDS_DOES_NOT_BIND = 0;
local BINDS_EQUIP = 1;
local BINDS_PICKUP = 2;

local TYPE_ARMOR = 0;
local TYPE_WEAPON = 1;
local TYPE_SHIELD = 2;
local TYPE_RECIPE = 3;
local TYPE_CONTAINER = 4;
local TYPE_MISC = 5;

local SUBTYPE_ARMOR_CLOTH = 0;
local SUBTYPE_ARMOR_LEATHER = 1;
local SUBTYPE_ARMOR_MAIL = 2;
local SUBTYPE_ARMOR_PLATE = 3;

local ItemLinksSize;

local ArmorSubtypes = { };
ArmorSubtypes["Cloth"] = SUBTYPE_ARMOR_CLOTH;
ArmorSubtypes["Leather"] = SUBTYPE_ARMOR_LEATHER;
ArmorSubtypes["Mail"] = SUBTYPE_ARMOR_MAIL;
ArmorSubtypes["Plate"] = SUBTYPE_ARMOR_PLATE;

local SUBTYPE_WEAPON_AXE = 0;
local SUBTYPE_WEAPON_BOW = 1;
local SUBTYPE_WEAPON_DAGGER = 2;
local SUBTYPE_WEAPON_MACE = 3;
-- 4 is available
local SUBTYPE_WEAPON_STAFF = 5;
local SUBTYPE_WEAPON_SWORD = 6;
local SUBTYPE_WEAPON_GUN = 7;
local SUBTYPE_WEAPON_WAND = 8;
local SUBTYPE_WEAPON_THROWN = 9;
local SUBTYPE_WEAPON_POLEARM = 10;
local SUBTYPE_WEAPON_FIST_WEAPON = 11;
local SUBTYPE_WEAPON_CROSSBOW = 12;

local WeaponSubtypes = { };
WeaponSubtypes["Axe"] = SUBTYPE_WEAPON_AXE;
WeaponSubtypes["Bow"] = SUBTYPE_WEAPON_BOW;
WeaponSubtypes["Dagger"] = SUBTYPE_WEAPON_DAGGER;
WeaponSubtypes["Mace"] = SUBTYPE_WEAPON_MACE;
WeaponSubtypes["Staff"] = SUBTYPE_WEAPON_STAFF;
WeaponSubtypes["Sword"] = SUBTYPE_WEAPON_SWORD;
WeaponSubtypes["Gun"] = SUBTYPE_WEAPON_GUN;
WeaponSubtypes["Wand"] = SUBTYPE_WEAPON_WAND;
WeaponSubtypes["Thrown"] = SUBTYPE_WEAPON_THROWN;
WeaponSubtypes["Polearm"] = SUBTYPE_WEAPON_POLEARM;
WeaponSubtypes["Fist Weapon"] = SUBTYPE_WEAPON_FIST_WEAPON;
WeaponSubtypes["Crossbow"] = SUBTYPE_WEAPON_CROSSBOW;

local SUBTYPE_SHIELD_BUCKLER = 0;
local SUBTYPE_SHIELD_SHIELD = 1;

local ShieldSubtypes = { };
ShieldSubtypes["Buckler"] = SUBTYPE_SHIELD_BUCKLER;
ShieldSubtypes["Shield"] = SUBTYPE_SHIELD_SHIELD;

local SUBTYPE_RECIPE_ALCHEMY = 0;
local SUBTYPE_RECIPE_BLACKSMITHING = 1;
local SUBTYPE_RECIPE_COOKING = 2;
local SUBTYPE_RECIPE_ENCHANTING = 3;
local SUBTYPE_RECIPE_ENGINEERING = 4;
local SUBTYPE_RECIPE_LEATHERWORKING = 5;
local SUBTYPE_RECIPE_TAILORING = 6;

local RecipeSubtypes = { };
RecipeSubtypes["Alchemy"] = SUBTYPE_RECIPE_ALCHEMY;
RecipeSubtypes["Blacksmithing"] = SUBTYPE_RECIPE_BLACKSMITHING;
RecipeSubtypes["Cooking"] = SUBTYPE_RECIPE_COOKING;
RecipeSubtypes["Enchanting"] = SUBTYPE_RECIPE_ENCHANTING;
RecipeSubtypes["Engineering"] = SUBTYPE_RECIPE_ENGINEERING;
RecipeSubtypes["Leatherworking"] = SUBTYPE_RECIPE_LEATHERWORKING;
RecipeSubtypes["Tailoring"] = SUBTYPE_RECIPE_TAILORING;

local LocationTypes = { };
LocationTypes["Held In Off-hand"]		= { type = TYPE_MISC };
LocationTypes["Back"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["One-Hand"]				= { type = TYPE_WEAPON, subtypes = WeaponSubtypes };
LocationTypes["Two-Hand"]				= { type = TYPE_WEAPON, subtypes = WeaponSubtypes };
LocationTypes["Off Hand"]				= { type = TYPE_SHIELD, subtypes = ShieldSubtypes };
LocationTypes["Wrist"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Chest"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Legs"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Feet"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Shirt"]					= { type = TYPE_MISC };
LocationTypes["Ranged"]					= { type = TYPE_WEAPON, subtypes = WeaponSubtypes };
LocationTypes["Main Hand"]				= { type = TYPE_WEAPON, subtypes = WeaponSubtypes };
LocationTypes["Waist"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Head"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Gun"]					= { type = TYPE_WEAPON, subtype = SUBTYPE_WEAPON_GUN };
LocationTypes["Finger"]					= { type = TYPE_MISC };
LocationTypes["Hands"]					= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Shoulder"]				= { type = TYPE_ARMOR, subtypes = ArmorSubtypes };
LocationTypes["Wand"]					= { type = TYPE_WEAPON, subtype = SUBTYPE_WEAPON_WAND };
LocationTypes["Trinket"]				= { type = TYPE_MISC };
LocationTypes["Tabard"]					= { type = TYPE_MISC };
LocationTypes["Neck"]					= { type = TYPE_MISC };
LocationTypes["Thrown"]					= { type = TYPE_WEAPON, subtype = SUBTYPE_WEAPON_THROWN };

local INVENTORY_SLOT_LIST = {
	{ name = "HeadSlot" },
	{ name = "NeckSlot" },
	{ name = "ShoulderSlot" },
	{ name = "BackSlot" },
	{ name = "ChestSlot" },
	{ name = "ShirtSlot" },
	{ name = "TabardSlot" },
	{ name = "WristSlot" },
	{ name = "HandsSlot" },
	{ name = "WaistSlot" },
	{ name = "LegsSlot" },
	{ name = "FeetSlot" },
	{ name = "Finger0Slot" },
	{ name = "Finger1Slot" },
	{ name = "Trinket0Slot" },
	{ name = "Trinket1Slot" },
	{ name = "MainHandSlot" },
	{ name = "SecondaryHandSlot" },
	{ name = "RangedSlot" },
};

local ChatMessageTypes = {
	"CHAT_MSG_SYSTEM",
	"CHAT_MSG_SAY",
	"CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_YELL",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_CHANNEL",
};

local LOOTLINK_DROPDOWN_LIST = {
	{ name = SORT_NAME, sortType = "name" },
	{ name = SORT_RARITY, sortType = "rarity" },
	{ name = SORT_LOCATION, sortType = "location" },
	{ name = SORT_TYPE, sortType = "type" },
	{ name = SORT_SUBTYPE, sortType = "subtype" },
	{ name = SORT_LEVEL, sortType = "level" },
	{ name = SORT_BINDS, sortType = "binds" },
	{ name = SORT_UNIQUE, sortType = "unique" },
	{ name = SORT_ARMOR, sortType = "armor" },
	{ name = SORT_BLOCK, sortType = "block" },
	{ name = SORT_MINDAMAGE, sortType = "minDamage" },
	{ name = SORT_MAXDAMAGE, sortType = "maxDamage" },
	{ name = SORT_DPS, sortType = "DPS" },
	{ name = SORT_SPEED, sortType = "speed" },
	{ name = SORT_SLOTS, sortType = "slots" },
	{ name = SORT_SKILL, sortType = "skill" }
};

local LLS_RARITY_LIST = {
	{ name = ANY, value = nil },
	{ name = POOR, value = "ff9d9d9d", r = 157 / 255, g = 157 / 255, b = 157 / 255 },
	{ name = COMMON, value = "ffffffff", r = 1, g = 1, b = 1 },
	{ name = UNCOMMON, value = "ff1eff00", r = 30 / 255, g = 1, b = 0 },
	{ name = RARE, value = "ff0070dd", r = 0, g = 70 / 255, b = 221 / 255 },
	{ name = EPIC, value = "ffa335ee", r = 163 / 255, g = 53 / 255, b = 238 / 255 },
};

local LLS_BINDS_LIST = {
	{ name = ANY, value = nil },
	{ name = DOES_NOT, value = BINDS_DOES_NOT_BIND },
	{ name = ON_EQUIP, value = BINDS_EQUIP },
	{ name = ON_PICKUP, value = BINDS_PICKUP },
};

local LLS_TYPE_LIST = {
	{ name = ANY, value = nil },
	{ name = ARMOR, value = TYPE_ARMOR },
	{ name = CONTAINER, value = TYPE_CONTAINER },
	{ name = OTHER, value = TYPE_MISC },
	{ name = RECIPE, value = TYPE_RECIPE },
	{ name = SHIELD, value = TYPE_SHIELD },
	{ name = WEAPON, value = TYPE_WEAPON },
};

local LLS_SUBTYPE_ARMOR_LIST = {
	{ name = ANY, value = nil },
	{ name = CLOTH, value = SUBTYPE_ARMOR_CLOTH },
	{ name = LEATHER, value = SUBTYPE_ARMOR_LEATHER },
	{ name = MAIL, value = SUBTYPE_ARMOR_MAIL },
	{ name = PLATE, value = SUBTYPE_ARMOR_PLATE },
};

local LLS_SUBTYPE_WEAPON_LIST = {
	{ name = ANY, value = nil },
	{ name = AXE, value = SUBTYPE_WEAPON_AXE },
	{ name = BOW, value = SUBTYPE_WEAPON_BOW },
	{ name = CROSSBOW, value = SUBTYPE_WEAPON_CROSSBOW },
	{ name = DAGGER, value = SUBTYPE_WEAPON_DAGGER },
	{ name = FIST_WEAPON, value = SUBTYPE_WEAPON_FIST_WEAPON },
	{ name = GUN, value = SUBTYPE_WEAPON_GUN },
	{ name = MACE, value = SUBTYPE_WEAPON_MACE },
	{ name = POLEARM, value = SUBTYPE_WEAPON_POLEARM },
	{ name = STAFF, value = SUBTYPE_WEAPON_STAFF },
	{ name = SWORD, value = SUBTYPE_WEAPON_SWORD },
	{ name = WAND, value = SUBTYPE_WEAPON_WAND },
};

local LLS_SUBTYPE_SHIELD_LIST = {
	{ name = ANY, value = nil },
	{ name = BUCKLER, value = SUBTYPE_SHIELD_BUCKLER },
	{ name = SHIELD, value = SUBTYPE_SHIELD_SHIELD },
};

local LLS_SUBTYPE_RECIPE_LIST = {
	{ name = ANY, value = nil },
	{ name = ALCHEMY, value = SUBTYPE_RECIPE_ALCHEMY },
	{ name = BLACKSMITHING, value = SUBTYPE_RECIPE_BLACKSMITHING },
	{ name = COOKING, value = SUBTYPE_RECIPE_COOKING },
	{ name = ENCHANTING, value = SUBTYPE_RECIPE_ENCHANTING },
	{ name = ENGINEERING, value = SUBTYPE_RECIPE_ENGINEERING },
	{ name = LEATHERWORKING, value = SUBTYPE_RECIPE_LEATHERWORKING },
	{ name = TAILORING, value = SUBTYPE_RECIPE_TAILORING },
};

local LLS_LOCATION_LIST = {
	{ name = "Any", },
	{ name = "None", },
	{ name = "Back", },
	{ name = "Chest", },
	{ name = "Feet", },
	{ name = "Finger", },
	{ name = "Hands", },
	{ name = "Head", },
	{ name = "Held In Off-hand", },
	{ name = "Gun", },
	{ name = "Legs", },
	{ name = "Main Hand", },
	{ name = "Neck", },
	{ name = "Off Hand", },
	{ name = "One-Hand", },
	{ name = "Ranged", },
	{ name = "Shirt", },
	{ name = "Shoulder", },
	{ name = "Tabard", },
	{ name = "Thrown", },
	{ name = "Trinket", },
	{ name = "Two-Hand", },
	{ name = "Waist", },
	{ name = "Wand", },
	{ name = "Wrist", },
};

local lMagicCharacters = { };
lMagicCharacters["^"] = 1;
lMagicCharacters["$"] = 1;
lMagicCharacters["("] = 1;
lMagicCharacters[")"] = 1;
lMagicCharacters["%"] = 1;
lMagicCharacters["."] = 1;
lMagicCharacters["["] = 1;
lMagicCharacters["]"] = 1;
lMagicCharacters["*"] = 1;
lMagicCharacters["+"] = 1;
lMagicCharacters["-"] = 1;
lMagicCharacters["?"] = 1;

--------------------------------------------------------------------------------------------------
-- Global LootLink variables
--------------------------------------------------------------------------------------------------
LOOTLINK_ITEM_HEIGHT = 16;
LOOTLINK_ITEMS_SHOWN = 23;

UIPanelWindows["LootLinkFrame"] =		{ area = "left",	pushable = 11 };
UIPanelWindows["LootLinkSearchFrame"] =	{ area = "center",	pushable = 0 };

--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------
local function LootLink_EscapeString(string)
	return string.gsub(string, "\"", "\\\"");
end

local function LootLink_UnescapeString(string)
	return string.gsub(string, "\\\"", "\"");
end

local function LootLink_EscapePattern(string)
	local result = "";
	local remain = string;
	local char;
	
	while( remain ~= "" ) do
		char = strsub(remain, 1, 1);
		if( lMagicCharacters[char] ) then
			result = result.."%"..char;
		else
			result = result..char;
		end
		remain = strsub(remain, 2);
	end
	
	return result;
end

local function LootLink_GetSize()
	return ItemLinksSize;
end

local function LootLink_CheckNumeric(string)
	local remain = string;
	local hasNumber;
	local hasPeriod;
	local char;
	
	while( remain ~= "" ) do
		char = strsub(remain, 1, 1);
		if( char >= "0" and char <= "9" ) then
			hasNumber = 1;
		elseif( char == "." and hasPeriod == nil ) then
			hasPeriod = 1;
		else
			return nil;
		end
		remain = strsub(remain, 2);
	end
	
	return hasNumber;
end

local function LootLink_NameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end

local function LootLink_MoneyToggle()
	if( lOriginal_GameTooltip_ClearMoney ) then
		GameTooltip_ClearMoney = lOriginal_GameTooltip_ClearMoney;
		lOriginal_GameTooltip_ClearMoney = nil;
	else
		lOriginal_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
		GameTooltip_ClearMoney = LootLink_GameTooltip_ClearMoney;
	end
end

local function LootLink_GetHyperlink(name)
	if( ItemLinks[name] and ItemLinks[name].item ) then
		-- Remove instance-specific data that we captured from the link we return
		local item = string.gsub(ItemLinks[name].item, "(%d+):(%d+):(%d+):(%d+)", "%1:0:%3:%4");
		return "item:"..item;
	end
	return nil;
end

local function LootLink_GetLink(name)
	local itemLink = ItemLinks[name];
	if( itemLink and itemLink.color and itemLink.item ) then
		local link = "|c"..itemLink.color.."|H"..LootLink_GetHyperlink(name).."|h["..name.."]|h|r";
		return link;
	end
	return nil;
end

local function LootLink_SetTitle()
	local lootLinkTitle = getglobal("LootLinkTitleText");
	local total = LootLink_GetSize();
	local size;
	
	if( DisplayIndices == nil ) then
		size = total;
	else
		size = DisplayIndices.onePastEnd - 1;
	end
	if( size < total ) then
		if( size == 1 ) then
			lootLinkTitle:SetText(TEXT(LOOTLINK_TITLE_FORMAT_PARTIAL_SINGULAR));
		else
			lootLinkTitle:SetText(format(TEXT(LOOTLINK_TITLE_FORMAT_PARTIAL_PLURAL), size));
		end
	else
		if( size == 1 ) then
			lootLinkTitle:SetText(TEXT(LOOTLINK_TITLE_FORMAT_SINGULAR));
		else
			lootLinkTitle:SetText(format(TEXT(LOOTLINK_TITLE_FORMAT_PLURAL), size));
		end
	end
end

local function LootLink_MatchType(left, right)
	local lt = LocationTypes[left];
	local type;
	local subtype;
	
	if( lt ) then
		local subtypes;
		
		-- Check for weapon override of base type
		if( WeaponSubtypes[right] ) then
			type = TYPE_WEAPON;
			subtypes = WeaponSubtypes;
		else
			type = lt.type;
			subtypes = lt.subtypes;
		end
		
		if( subtypes ) then
			subtype = subtypes[right];
		else
			subtype = lt.subtype;
		end
		return nil, left, type, subtype;
	end
	
	return 1, nil, TYPE_MISC, nil;
end

local function LootLink_NameMatchesTooltip(name, link)
	local itemLink;
	local tooltipName;
	local nSubs;
	
	if( name == nil ) then
		return nil;
	end
	if( link == nil ) then
		itemLink = LootLink_GetHyperlink(name);
		if( itemLink == nil ) then
			return nil;
		end
	else
		itemLink, nSubs = string.gsub(link, "^(%d+):(%d+):(%d+):(%d+)$", "item:%1:0:%3:%4");
		if( nSubs ~= 1 ) then
			return nil;
		end
	end
	
	-- protect money frame while we set hidden tooltip
	LootLink_MoneyToggle();
	LLHiddenTooltip:SetHyperlink(itemLink);
	LootLink_MoneyToggle();

	tooltipName = getglobal("LLHiddenTooltipTextLeft1"):GetText();
	if( tooltipName ) then
		if( tooltipName == name ) then
			return 1;
		end
	end
	
	return nil;
end

local function LootLink_BuildSearchData(name, value, debug)
	if( LootLink_NameMatchesTooltip(name) ) then
		local state = STATE_NAME;
		local loop;
		local sd;
		local index;
		local field;
		local left;
		local right;
		local iStart;
		local iEnd;
		local val1;
		local val2;
		local val3;
		local foundRequires;
		
		value.SearchData = { };
		sd = value.SearchData;
		sd.text = "";
		
		for index = 1, 15, 1 do
			field = getglobal("LLHiddenTooltipTextLeft"..index);
			if( field and field:IsVisible() ) then
				left = field:GetText();
			else
				left = nil;
			end
			
			field = getglobal("LLHiddenTooltipTextRight"..index);
			if( field and field:IsVisible() ) then
				right = field:GetText();
			else
				right = nil;
			end
			
			if( left ) then
				sd.text = sd.text..left.."·";
			else
				left = "";
			end
			if( right ) then
				sd.text = sd.text..right.."·";
			else
				right = "";
			end
			
			loop = 1;
			while( loop ) do
				if( state == STATE_NAME ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_NAME {"..index..", '"..left.."', '"..right.."'}");
					end
					state = STATE_BOUND;
					loop = nil;
				elseif( state == STATE_BOUND ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_BOUND {"..index..", '"..left.."', '"..right.."'}");
					end
					iStart, iEnd, val1 = string.find(left, "Binds when (.+)");
					if( val1 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found: "..val1);
						end
						if( val1 == "equipped" ) then
							sd.binds = BINDS_EQUIP;
						elseif( val1 == "picked up" ) then
							sd.binds = BINDS_PICKUP;
						end
						loop = nil;
					else
						sd.binds = BINDS_DOES_NOT_BIND;
					end
					state = STATE_UNIQUE;
				elseif( state == STATE_UNIQUE ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_UNIQUE {"..index..", '"..left.."', '"..right.."'}");
					end
					if( string.find(left, "Unique") ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found Unique");
						end
						sd.unique = 1;
						loop = nil;
					end
					state = STATE_LOCATION;
				elseif( state == STATE_LOCATION ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_LOCATION {"..index..", '"..left.."', '"..right.."'}");
					end
					loop, sd.location, sd.type, sd.subtype = LootLink_MatchType(left, right);
					if( sd.type == TYPE_WEAPON ) then
						state = STATE_DAMAGE;
					elseif( sd.type == TYPE_ARMOR or sd.type == TYPE_SHIELD ) then
						state = STATE_ARMOR;
					else
						state = STATE_CONTAINER;
					end
				elseif( state == STATE_DAMAGE ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_DAMAGE {"..index..", '"..left.."', '"..right.."'}");
					end
					iStart, iEnd, val1, val2 = string.find(left, "(%d+) %- (%d+) Damage");
					if( val1 and val2 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found damage: "..val1.." - "..val2);
						end
						sd.minDamage = val1 + 0;
						sd.maxDamage = val2 + 0;
					end
					iStart, iEnd, val1 = string.find(right, "Speed (.+)");
					if( val1 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found speed: "..val1);
						end
						sd.speed = val1 + 0;
					end
					state = STATE_DPS;
					loop = nil;
				elseif( state == STATE_DPS ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_DPS {"..index..", '"..left.."', '"..right.."'}");
					end
					iStart, iEnd, val1 = string.find(left, "%((.+) damage per second%)");
					if( val1 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found DPS: "..val1);
						end
						sd.DPS = val1 + 0;
					end
					state = STATE_REQUIRES;
					loop = nil;
				elseif( state == STATE_ARMOR ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_ARMOR {"..index..", '"..left.."', '"..right.."'}");
					end
					iStart, iEnd, val1 = string.find(left, "(%d+) Armor");
					if( val1 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found armor: "..val1);
						end
						sd.armor = val1 + 0;
					end
					if( sd.type == TYPE_SHIELD ) then
						state = STATE_BLOCK;
					else
						state = STATE_REQUIRES;
					end
					loop = nil;
				elseif( state == STATE_BLOCK ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_BLOCK {"..index..", '"..left.."', '"..right.."'}");
					end
					iStart, iEnd, val1 = string.find(left, "(%d+) Block");
					if( val1 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found block: "..val1);
						end
						sd.block = val1 + 0;
					end
					state = STATE_REQUIRES;
					loop = nil;
				elseif( state == STATE_CONTAINER ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_CONTAINER {"..index..", '"..left.."', '"..right.."'}");
					end
					iStart, iEnd, val1 = string.find(left, "(%d+) Slot Container");
					if( val1 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found slots: "..val1);
						end
						sd.type = TYPE_CONTAINER;
						sd.slots = val1 + 0;
						loop = nil;
					end
					state = STATE_REQUIRES;
				elseif( state == STATE_REQUIRES ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_REQUIRES {"..index..", '"..left.."', '"..right.."'}");
					end
					iStart, iEnd, val1 = string.find(left, "Requires (.+)");
					if( val1 ) then
						if( debug ) then
							DEFAULT_CHAT_FRAME:AddMessage(" found requires: "..val1);
						end
						foundRequires = 1;
						loop = nil;
						iStart, iEnd, val2 = string.find(val1, "Level (%d+)");
						if( val2 ) then
							sd.level = val2 + 0;
						else
							iStart, iEnd, val2, val3 = string.find(val1, "(.+) %((%d+)%)");
							if( val2 and val3 ) then
								val1 = RecipeSubtypes[val2];
								if( val1 and sd.type == TYPE_MISC ) then
									sd.type = TYPE_RECIPE;
									sd.subtype = val1;
									sd.skill = val3 + 0;
								end
							end
						end
					else
						if( foundRequires ) then
							state = STATE_FINISH;
						else
							loop = nil;
						end
					end
				elseif( state == STATE_FINISH ) then
					if( debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("STATE_FINISH {"..index..", '"..left.."', '"..right.."'}");
					end
					loop = nil;
				end
			end
		end
	else
		return nil;
	end
	
	return 1;
end

local function LootLink_MatchesSearch(name, value)
	if( LootLinkFrame.SearchParams == nil or name == nil or value == nil ) then
		return 1;
	end
	
	if( value.SearchData == nil
--@todo Telo: temporary to build polearms, crossbows, and fist weapons types correctly
		or (value.SearchData.type == TYPE_WEAPON and value.SearchData.subtype == nil)
		or (value.SearchData.type == TYPE_SHIELD)
	   ) then
		LootLink_BuildSearchData(name, value);
	end

	if( value.SearchData ) then
		local sp = LootLinkFrame.SearchParams; 
		local sd = value.SearchData;
		
		if( sp.text and sd.text ) then
			if( not string.find(string.lower(sd.text), string.lower(sp.text), 1, sp.plain) ) then
				return nil;
			end
		end
		
		if( sp.name ) then
			if( not string.find(string.lower(name), string.lower(sp.name), 1, sp.plain) ) then
				return nil;
			end
		end
		
		if( sp.rarity ) then
			if( LLS_RARITY_LIST[sp.rarity].value ~= value.color ) then
				return nil;
			end
		end
		
		if( sp.binds ) then
			if( LLS_BINDS_LIST[sp.binds].value ~= sd.binds ) then
				return nil;
			end
		end
		
		if( sp.unique ) then
			if( sp.unique ~= sd.unique ) then
				return nil;
			end
		end
		
		if( sp.location ) then
			if( sp.location == 2 ) then
				if( sd.location ) then
					return nil;
				end
			elseif( sp.location ~= 1 ) then
				if( LLS_LOCATION_LIST[sp.location].name ~= sd.location ) then
					return nil;
				end
			end
		end
		
		if( sp.minLevel ) then
			if( sd.level == nil or sd.level < sp.minLevel ) then
				return nil;
			end
		end
		
		if( sp.maxLevel ) then
			if( sd.level and sd.level > sp.maxLevel ) then
				return nil;
			end
		end
		
		if( sp.type ) then
			local type = LLS_TYPE_LIST[sp.type].value;
			if( type ~= sd.type ) then
				return nil;
			end
			if( sp.subtype ) then
				local subtype;
				if( type == TYPE_ARMOR ) then
					subtype = LLS_SUBTYPE_ARMOR_LIST[sp.subtype].value;
				elseif( type == TYPE_SHIELD ) then
					subtype = LLS_SUBTYPE_SHIELD_LIST[sp.subtype].value;
				elseif( type == TYPE_WEAPON ) then
					subtype = LLS_SUBTYPE_WEAPON_LIST[sp.subtype].value;
				elseif( type == TYPE_RECIPE ) then
					subtype = LLS_SUBTYPE_RECIPE_LIST[sp.subtype].value;
				end
				if( subtype and subtype ~= sd.subtype ) then
					return nil;
				end
			end
			
			if( type == TYPE_WEAPON ) then
				if( sp.minMinDamage ) then
					if( sd.minDamage == nil or sd.minDamage < sp.minMinDamage ) then
						return nil;
					end
				end

				if( sp.minMaxDamage ) then
					if( sd.maxDamage == nil or sd.maxDamage < sp.minMaxDamage ) then
						return nil;
					end
				end

				if( sp.maxSpeed ) then
					if( sd.speed == nil or sd.speed > sp.maxSpeed ) then
						return nil;
					end
				end

				if( sp.minDPS ) then
					if( sd.DPS == nil or sd.DPS < sp.minDPS ) then
						return nil;
					end
				end
			elseif( type == TYPE_ARMOR or type == TYPE_SHIELD ) then
				if( sp.minArmor ) then
					if( sd.armor == nil or sd.armor < sp.minArmor ) then
						return nil;
					end
				end
				
				if( type == TYPE_SHIELD ) then
					if( sp.minBlock ) then
						if( sd.block == nil or sd.block < sp.minBlock ) then
							return nil;
						end
					end
				end
			elseif( type == TYPE_CONTAINER ) then
				if( sp.minSlots ) then
					if( sd.slots == nil or sd.slots < sp.minSlots ) then
						return nil;
					end
				end
			elseif( type == TYPE_RECIPE ) then
				if( sp.minSkill ) then
					if( sd.skill == nil or sd.skill < sp.minSkill ) then
						return nil;
					end
				end
				
				if( sp.maxSkill ) then
					if( sd.skill == nil or sd.skill > sp.maxSkill ) then
						return nil;
					end
				end
			end
		end
	else
		return nil;
	end

	return 1;
end

local function LootLink_ColorComparison(elem1, elem2)
	local color1;
	local color2;
	
	if( ItemLinks[elem1] and ItemLinks[elem1].color ) then
		color1 = ItemLinks[elem1].color;
	else
		color1 = "FFFFFFFF";
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].color ) then
		color2 = ItemLinks[elem2].color;
	else
		color2 = "FFFFFFFF";
	end

	if( color1 == color2 ) then
		return elem1 < elem2;
	end	
	return color1 < color2;
end

local function LootLink_ForceSearchData(elem1, elem2)
--@todo Telo: this crashes the client if there are too many items w/o search data
--[[
	if( ItemLinks[elem1] and not ItemLinks[elem1].SearchData ) then
		LootLink_BuildSearchData(elem1, ItemLinks[elem1]);
	end
	if( ItemLinks[elem2] and not ItemLinks[elem2].SearchData ) then
		LootLink_BuildSearchData(elem2, ItemLinks[elem2]);
	end
]]
end

local function LootLink_GenericComparison(elem1, elem2, v1, v2)
	if( v1 == v2 ) then
		return elem1 < elem2;
	end
	if( not v1 ) then
		return 1;
	end
	if( not v2 ) then
		return nil;
	end
	return v1 < v2;
end

local function LootLink_BindsComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.binds;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.binds;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_UniqueComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.unique;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.unique;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_LocationComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.location;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.location;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_TypeComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.type;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.type;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_SubtypeComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.subtype;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.subtype;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_MinDamageComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.minDamage;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.minDamage;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_MaxDamageComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.maxDamage;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.maxDamage;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_SpeedComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.speed;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.speed;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_DPSComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.DPS;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.DPS;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_ArmorComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.armor;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.armor;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_BlockComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.block;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.block;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_SlotsComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.slots;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.slots;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_SkillComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);

	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.skill;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.skill;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_LevelComparison(elem1, elem2)
	local v1, v2;
	
	LootLink_ForceSearchData(elem1, elem2);
	
	if( ItemLinks[elem1] and ItemLinks[elem1].SearchData ) then
		v1 = ItemLinks[elem1].SearchData.level;
	end
	if( ItemLinks[elem2] and ItemLinks[elem2].SearchData ) then
		v2 = ItemLinks[elem2].SearchData.level;
	end
	
	return LootLink_GenericComparison(elem1, elem2, v1, v2);
end

local function LootLink_Sort()
	if( LOOTLINK_DROPDOWN_LIST[UIDropDownMenu_GetSelectedID(LootLinkFrameDropDown)].sortType ) then
		local sortType = LOOTLINK_DROPDOWN_LIST[UIDropDownMenu_GetSelectedID(LootLinkFrameDropDown)].sortType;
		if( sortType == "name" ) then
			table.sort(DisplayIndices);
		elseif( sortType == "rarity" ) then
			table.sort(DisplayIndices, LootLink_ColorComparison);
		elseif( sortType == "binds" ) then
			table.sort(DisplayIndices, LootLink_BindsComparison);
		elseif( sortType == "unique" ) then
			table.sort(DisplayIndices, LootLink_UniqueComparison);
		elseif( sortType == "location" ) then
			table.sort(DisplayIndices, LootLink_LocationComparison);
		elseif( sortType == "type" ) then
			table.sort(DisplayIndices, LootLink_TypeComparison);
		elseif( sortType == "subtype" ) then
			table.sort(DisplayIndices, LootLink_SubtypeComparison);
		elseif( sortType == "minDamage" ) then
			table.sort(DisplayIndices, LootLink_MinDamageComparison);
		elseif( sortType == "maxDamage" ) then
			table.sort(DisplayIndices, LootLink_MaxDamageComparison);
		elseif( sortType == "speed" ) then
			table.sort(DisplayIndices, LootLink_SpeedComparison);
		elseif( sortType == "DPS" ) then
			table.sort(DisplayIndices, LootLink_DPSComparison);
		elseif( sortType == "armor" ) then
			table.sort(DisplayIndices, LootLink_ArmorComparison);
		elseif( sortType == "block" ) then
			table.sort(DisplayIndices, LootLink_BlockComparison);
		elseif( sortType == "slots" ) then
			table.sort(DisplayIndices, LootLink_SlotsComparison);
		elseif( sortType == "skill" ) then
			table.sort(DisplayIndices, LootLink_SkillComparison);
		elseif( sortType == "level" ) then
			table.sort(DisplayIndices, LootLink_LevelComparison);
		end
	end
end

local function LootLink_BuildDisplayIndices()
	local iNew = 1;
	
	DisplayIndices = { };
	for index, value in ItemLinks do
		if( LootLink_MatchesSearch(index, value) ) then
			DisplayIndices[iNew] = index;
			iNew = iNew + 1;
		end
	end
	DisplayIndices.onePastEnd = iNew;
	LootLink_Sort();
	LootLink_SetTitle();
end

local function LootLink_MakeIntFromHexString(str)
	local remain = str;
	local amount = 0;
	while( remain ~= "" ) do
		amount = amount * 16;
		local byteVal = string.byte(strupper(strsub(remain, 1, 1)));
		if( byteVal >= string.byte("0") and byteVal <= string.byte("9") ) then
			amount = amount + (byteVal - string.byte("0"));
		elseif( byteVal >= string.byte("A") and byteVal <= string.byte("F") ) then
			amount = amount + 10 + (byteVal - string.byte("A"));
		end
		remain = strsub(remain, 2);
	end
	return amount;
end

local function LootLink_GetRGBFromHexColor(hexColor)
	local red = LootLink_MakeIntFromHexString(strsub(hexColor, 3, 4)) / 255;
	local green = LootLink_MakeIntFromHexString(strsub(hexColor, 5, 6)) / 255;
	local blue = LootLink_MakeIntFromHexString(strsub(hexColor, 7, 8)) / 255;
	return red, green, blue;
end

local function LootLink_HideTooltipMoney()
	LootLinkTooltipMoneyFrame:SetPoint("LEFT", "LootLinkTooltipTextLeft1", "LEFT", 0, 0);
	LootLinkTooltipMoneyFrame:Hide();
end

function LootLink_Tooltip_Hook(frame, name, money, count, data)
	if (money > 0) then
		if (count > 1) then
			money = money * count;
			frame:AddLine(format(LOOTLINK_SELL_PRICE_N, count), 1.0, 1.0, 1.0);
		else
			frame:AddLine(LOOTLINK_SELL_PRICE, 1.0, 1.0, 1.0);
		end
	end

	local numLines = frame:NumLines();
	if ( numLines > 0 ) then
		local moneyFrame = getglobal(frame:GetName().."MoneyFrame");
		local newLine = frame:GetName().."TextLeft"..numLines;
	
		moneyFrame:SetPoint("LEFT", newLine, "RIGHT", 4, 0);
		if (money > 0) then
			moneyFrame:Show();
		else
			moneyFrame:Hide();
		end
		MoneyFrame_Update(moneyFrame:GetName(), money);
		frame:SetMoneyWidth(moneyFrame:GetWidth() + getglobal(newLine):GetWidth() - 10);
	end
end

local function LootLink_SetTooltipMoney(frame, name, count)
	local money = 0;
	local data = nil;
	if (ItemLinks[name]) then data = ItemLinks[name]; end
	if (data and data.price) then money = data.price; end
	if (not count) then count = 1; end

	LootLink_Tooltip_Hook(frame, name, money, count, data);
end

local function LootLink_AddTooltipPrice(name)
	if( ItemLinks[name] ) then
		LootLink_SetTooltipMoney(LootLinkTooltip, name, 1);
		LootLinkTooltip:Show();
	else
		LootLink_HideTooltipMoney();
	end
end

local function LootLinkFrameDropDown_Initialize()
	local info;
	for i = 1, getn(LOOTLINK_DROPDOWN_LIST), 1 do
		info = { };
		info.text = LOOTLINK_DROPDOWN_LIST[i].name;
		info.func = LootLinkFrameDropDownButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_RarityDropDown_Initialize()
	local info;
	for i = 1, getn(LLS_RARITY_LIST), 1 do
		info = { };
		info.text = LLS_RARITY_LIST[i].name;
		info.func = LLS_RarityDropDown_OnClick;
		if( LLS_RARITY_LIST[i].value ) then
			info.textR = LLS_RARITY_LIST[i].r;
			info.textG = LLS_RARITY_LIST[i].g;
			info.textB = LLS_RARITY_LIST[i].b;
		end
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_BindsDropDown_Initialize()
	local info;
	for i = 1, getn(LLS_BINDS_LIST), 1 do
		info = { };
		info.text = LLS_BINDS_LIST[i].name;
		info.func = LLS_BindsDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_LocationDropDown_Initialize()
	local info;
	for i = 1, getn(LLS_LOCATION_LIST), 1 do
		info = { };
		info.text = LLS_LOCATION_LIST[i].name;
		info.func = LLS_LocationDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_TypeDropDown_Initialize()
	local info;
	for i = 1, getn(LLS_TYPE_LIST), 1 do
		info = { };
		info.text = LLS_TYPE_LIST[i].name;
		info.func = LLS_TypeDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_SubtypeDropDownArmor_Initialize()
	local info;
	for i = 1, getn(LLS_SUBTYPE_ARMOR_LIST), 1 do
		info = { };
		info.text = LLS_SUBTYPE_ARMOR_LIST[i].name;
		info.func = LLS_SubtypeDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_SubtypeDropDownShield_Initialize()
	local info;
	for i = 1, getn(LLS_SUBTYPE_SHIELD_LIST), 1 do
		info = { };
		info.text = LLS_SUBTYPE_SHIELD_LIST[i].name;
		info.func = LLS_SubtypeDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_SubtypeDropDownWeapon_Initialize()
	local info;
	for i = 1, getn(LLS_SUBTYPE_WEAPON_LIST), 1 do
		info = { };
		info.text = LLS_SUBTYPE_WEAPON_LIST[i].name;
		info.func = LLS_SubtypeDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LLS_SubtypeDropDownRecipe_Initialize()
	local info;
	for i = 1, getn(LLS_SUBTYPE_RECIPE_LIST), 1 do
		info = { };
		info.text = LLS_SUBTYPE_RECIPE_LIST[i].name;
		info.func = LLS_SubtypeDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

local function LootLink_UIDropDownMenu_SetSelectedID(frame, id, names)
	UIDropDownMenu_SetSelectedID(frame, id);
	if( not frame ) then
		frame = this;
	end
	UIDropDownMenu_SetText(names[id].name, frame);
end

local function LootLink_SetupTypeUI(iType, iSubtype)
	local type = LLS_TYPE_LIST[iType].value;
	
	if( iSubtype == nil ) then
		iSubtype = 1;
	end

	-- Hide all of the variable labels and fields to start
	getglobal("LLS_SubtypeLabel"):Hide();
	getglobal("LLS_SubtypeDropDown"):Hide();
	getglobal("LLS_MinimumArmorLabel"):Hide();
	getglobal("LLS_MinimumBlockLabel"):Hide();
	getglobal("LLS_MinimumDamageLabel"):Hide();
	getglobal("LLS_MaximumDamageLabel"):Hide();
	getglobal("LLS_MaximumSpeedLabel"):Hide();
	getglobal("LLS_MinimumDPSLabel"):Hide();
	getglobal("LLS_MinimumSlotsLabel"):Hide();
	getglobal("LLS_MinimumSkillLabel"):Hide();
	getglobal("LLS_MaximumSkillLabel"):Hide();
	getglobal("LLS_MinimumArmorEditBox"):Hide();
	getglobal("LLS_MinimumBlockEditBox"):Hide();
	getglobal("LLS_MinimumDamageEditBox"):Hide();
	getglobal("LLS_MaximumDamageEditBox"):Hide();
	getglobal("LLS_MaximumSpeedEditBox"):Hide();
	getglobal("LLS_MinimumDPSEditBox"):Hide();
	getglobal("LLS_MinimumSlotsEditBox"):Hide();
	getglobal("LLS_MinimumSkillEditBox"):Hide();
	getglobal("LLS_MaximumSkillEditBox"):Hide();
	
	if( type == TYPE_ARMOR or type == TYPE_SHIELD or type == TYPE_WEAPON or type == TYPE_RECIPE ) then
		local label = getglobal("LLS_SubtypeLabel");
		local dropdown = getglobal("LLS_SubtypeDropDown");
		local initfunc;
		
		-- Show the dropdown and its label
		label:Show();
		dropdown:Show();
		
		if( type == TYPE_ARMOR ) then
			label:SetText(LLS_SUBTYPE_ARMOR);
			initfunc = LLS_SubtypeDropDownArmor_Initialize;
			
			getglobal("LLS_MinimumArmorLabel"):Show();
			getglobal("LLS_MinimumArmorEditBox"):Show();
		elseif( type == TYPE_SHIELD ) then
			label:SetText(LLS_SUBTYPE_SHIELD);
			initfunc = LLS_SubtypeDropDownShield_Initialize;

			getglobal("LLS_MinimumArmorLabel"):Show();
			getglobal("LLS_MinimumBlockLabel"):Show();
			getglobal("LLS_MinimumArmorEditBox"):Show();
			getglobal("LLS_MinimumBlockEditBox"):Show();
		elseif( type == TYPE_WEAPON ) then
			label:SetText(LLS_SUBTYPE_WEAPON);
			initfunc = LLS_SubtypeDropDownWeapon_Initialize;
			
			getglobal("LLS_MinimumDamageLabel"):Show();
			getglobal("LLS_MaximumDamageLabel"):Show();
			getglobal("LLS_MaximumSpeedLabel"):Show();
			getglobal("LLS_MinimumDPSLabel"):Show();
			getglobal("LLS_MinimumDamageEditBox"):Show();
			getglobal("LLS_MaximumDamageEditBox"):Show();
			getglobal("LLS_MaximumSpeedEditBox"):Show();
			getglobal("LLS_MinimumDPSEditBox"):Show();
		else
			label:SetText(LLS_SUBTYPE_RECIPE);
			initfunc = LLS_SubtypeDropDownRecipe_Initialize;

			getglobal("LLS_MinimumSkillLabel"):Show();
			getglobal("LLS_MaximumSkillLabel"):Show();
			getglobal("LLS_MinimumSkillEditBox"):Show();
			getglobal("LLS_MaximumSkillEditBox"):Show();
		end
		
		UIDropDownMenu_Initialize(dropdown, initfunc);
		UIDropDownMenu_SetSelectedID(LLS_SubtypeDropDown, iSubtype);
	elseif( type == TYPE_CONTAINER ) then
		getglobal("LLS_MinimumSlotsLabel"):Show();
		getglobal("LLS_MinimumSlotsEditBox"):Show();
	end
end

local function LootLink_InspectSlot(unit, id)
	local link = GetInventoryItemLink(unit, id);
	if( link ) then
		LootLink_ProcessLinks(link);
	end
end

local function LootLink_Inspect(who)
	local index;
	
	for index = 1, getn(INVENTORY_SLOT_LIST), 1 do
		LootLink_InspectSlot(who, INVENTORY_SLOT_LIST[index].id)
	end
end

local function LootLink_ScanInventory()
	local bagid;
	local size;
	local slotid;
	local link;
	
	for bagid = 0, 4, 1 do
		size = GetContainerNumSlots(bagid);
		if( size ) then
			for slotid = size, 1, -1 do
				link = GetContainerItemLink(bagid, slotid);
				if( link ) then
					LootLink_ProcessLinks(link);
				end
			end
		end
	end
end

function LootLink_AuctionStart_Hook()
end

local function LootLink_StartAuctionScan()
	-- Start with the first page
	lCurrentAuctionPage = nil;

	-- Hook the functions that we need for the scan
	if( not lOriginal_CanSendAuctionQuery ) then
		lOriginal_CanSendAuctionQuery = CanSendAuctionQuery;
		CanSendAuctionQuery = LootLink_CanSendAuctionQuery;
	end
	if( not lOriginal_AuctionFrameBrowse_OnEvent ) then
		lOriginal_AuctionFrameBrowse_OnEvent = AuctionFrameBrowse_OnEvent;
		AuctionFrameBrowse_OnEvent = LootLink_AuctionFrameBrowse_OnEvent;
	end
	
	LootLink_AuctionStart_Hook();
end

function LootLink_AuctionStop_Hook()
end

local function LootLink_StopAuctionScan()
	-- Unhook the scanning functions
	if( lOriginal_CanSendAuctionQuery ) then
		CanSendAuctionQuery = lOriginal_CanSendAuctionQuery;
		lOriginal_CanSendAuctionQuery = nil;
	end
	if( lOriginal_AuctionFrameBrowse_OnEvent ) then
		AuctionFrameBrowse_OnEvent = lOriginal_AuctionFrameBrowse_OnEvent;
		lOriginal_AuctionFrameBrowse_OnEvent = nil;
	end
	LootLink_AuctionStop_Hook();
end

local function LootLink_AuctionNextQuery()
	if( lCurrentAuctionPage ) then
		local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
		local maxPages = floor(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE);
		
		if( lCurrentAuctionPage < maxPages ) then
			lCurrentAuctionPage = lCurrentAuctionPage + 1;
			BrowseNoResultsText:SetText(format(LOOTLINK_AUCTION_PAGE_N, lCurrentAuctionPage + 1, maxPages + 1));
		else
			lScanAuction = nil;
			LootLink_StopAuctionScan();
			if( totalAuctions > 0 ) then
				BrowseNoResultsText:SetText(LOOTLINK_AUCTION_SCAN_DONE);
			end
			return;
		end
	else
		lCurrentAuctionPage = 0;
		BrowseNoResultsText:SetText(LOOTLINK_AUCTION_SCAN_START);
	end
	QueryAuctionItems("", "", "", nil, nil, nil, lCurrentAuctionPage, nil, nil);
end

function LootLink_AuctionEntry_Hook(page, index, name)
end

local function LootLink_ScanAuction()
	local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
	local auctionid;
	local link;
	local name;
	
	if( numBatchAuctions > 0 ) then
		for auctionid = 1, numBatchAuctions do
			link = GetAuctionItemLink("list", auctionid);
			if( link ) then
				name = LootLink_ProcessLinks(link);
			else
				name = nil;
			end
			if ( ( name ) and (strlen(name) > 0) ) then
				LootLink_AuctionEntry_Hook(lCurrentAuctionPage, auctionid, name);
			end
		end
	end
end

function LootLink_BankEntry_Hook(bagid, slotid, name)
end

local function LootLink_ScanBank()
	local bagid;
	local size;
	local slotid;
	local link;
	
	-- First the bank container itself
	size = GetContainerNumSlots(BANK_CONTAINER);
	for slotid = size, 1, -1 do
		link = GetContainerItemLink(BANK_CONTAINER, slotid);
		if ( link ) then
			local name = LootLink_ProcessLinks(link);
			if (name and (strlen(name) > 0 ) ) then
				LootLink_BankEntry_Hook(bagid, slotid, name);
			end
		end
	end
	
	-- Now the bank bags
	for bagid = 5, 10, 1 do
		size = GetContainerNumSlots(bagid);
		if( size ) then
			for slotid = size, 1, -1 do
				link = GetContainerItemLink(bagid, slotid);
				if ( link ) then
					local name = LootLink_ProcessLinks(link);
					if (name and (strlen(name) > 0 ) ) then
						LootLink_BankEntry_Hook(bagid, slotid, name);
					end
				end
			end
		end
	end
end

function LootLink_VendorEntry_Hook(frameid, buttonid, name, price)
end

local function LootLink_ScanSellPrice(price)
	local button = lGameToolTipOwner;
	
	if( button ) then
		local frame = button:GetParent();
		local frameID = frame:GetID();
		local buttonID = button:GetID();
		local link = GetContainerItemLink(frameID, buttonID);
		local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID);
		local name;
		
		if( itemCount and itemCount > 1 ) then
			price = price / itemCount;
		end
		
		name = LootLink_NameFromLink(link);
		if( name and ItemLinks[name] ) then
			ItemLinks[name].price = price;
			LootLink_VendorEntry_Hook(frameID, buttonID, name, price);
		end
	end
end

--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------
function LootLink_OnLoad()
	local index;
	local value;

	RegisterForSave("ItemLinks");
	ItemLinksSize = 0;
	
	for index, value in ChatMessageTypes do
		this:RegisterEvent(value);
	end
	
	for index = 1, getn(INVENTORY_SLOT_LIST), 1 do
		INVENTORY_SLOT_LIST[index].id = GetInventorySlotInfo(INVENTORY_SLOT_LIST[index].name);
	end
	
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("BANKFRAME_OPENED");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("AUCTION_HOUSE_SHOW");
	this:RegisterEvent("AUCTION_HOUSE_CLOSE");
	this:RegisterEvent("AUCTION_ITEM_LIST_UPDATE");
	this:RegisterEvent("TOOLTIP_ADD_MONEY");

	-- Register our slash command
	SLASH_LOOTLINK1 = "/lootlink";
	SLASH_LOOTLINK2 = "/ll";
	SlashCmdList["LOOTLINK"] = function(msg)
		LootLink_SlashCommandHandler(msg);
	end
	
	-- Hook the ChatFrame_OnEvent function
	originalChatFrame_OnEvent = ChatFrame_OnEvent;
	ChatFrame_OnEvent = LootLink_ChatFrame_OnEvent;

	-- Hook the GameTooltip:SetOwner function
	lOriginal_GameTooltip_SetOwner = GameTooltip.SetOwner;
	GameTooltip.SetOwner = LootLink_GameTooltip_SetOwner;
	
	-- Hook the ContainerFrameItemButton_OnEnter, ContainerFrame_Update and GameTooltip:SetLootItem functions
	lOriginal_ContainerFrameItemButton_OnEnter = ContainerFrameItemButton_OnEnter;
	ContainerFrameItemButton_OnEnter = LootLink_ContainerFrameItemButton_OnEnter;
	lOriginal_ContainerFrame_Update = ContainerFrame_Update;
	ContainerFrame_Update = LootLink_ContainerFrame_Update;
	lOriginal_GameTooltip_SetLootItem = GameTooltip.SetLootItem;
	GameTooltip.SetLootItem = LootLink_GameTooltip_SetLootItem;
	
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("Telo's LootLink AddOn loaded");
	end
	UIErrorsFrame:AddMessage("Telo's LootLink AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function LootLink_CanSendAuctionQuery()
	local value = lOriginal_CanSendAuctionQuery();
	if( value ) then
		LootLink_AuctionNextQuery();
		return nil;
	end
	return value;
end

function LootLink_AuctionFrameBrowse_OnEvent()
	-- Intentionally empty; don't allow the auction UI to update while we're scanning
end

function LootLink_ChatFrame_OnEvent()
	if( event == "CHAT_MSG_LOOT" ) then
		LootLink_ProcessLootMsg(arg1, this, ChatTypeInfo["LOOT"]);
		return;
	end

	originalChatFrame_OnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
end

function LootLink_GameTooltip_SetOwner(this, owner, anchor)
	lOriginal_GameTooltip_SetOwner(this, owner, anchor);
	lGameToolTipOwner = owner;
end

function LootLink_GameTooltip_ClearMoney()
	-- Intentionally empty; don't clear money while we use our hidden tooltip
end

function LootLink_ContainerFrameItemButton_OnEnter()
	lOriginal_ContainerFrameItemButton_OnEnter();
	if( not InRepairMode() and not MerchantFrame:IsVisible() ) then
		local frameID = this:GetParent():GetID();
		local buttonID = this:GetID();
		local link = GetContainerItemLink(frameID, buttonID);
		local name = LootLink_NameFromLink(link);
		
		if( name and ItemLinks[name] and ItemLinks[name].price ) then
			local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID);
			LootLink_SetTooltipMoney(GameTooltip, name, itemCount);
			GameTooltip:Show();
		end
	end
end

function LootLink_ContainerFrame_Update(frame)
	lOriginal_ContainerFrame_Update(frame);
	if( not InRepairMode() and not MerchantFrame:IsVisible() and GameTooltip:IsVisible() ) then
		local frameID = frame:GetID();
		local frameName = frame:GetName();
		local iButton;
		for iButton = 1, frame.size do
			local button = getglobal(frameName.."Item"..iButton);
			if( GameTooltip:IsOwned(button) ) then
				local buttonID = button:GetID();
				local link = GetContainerItemLink(frameID, buttonID);
				local name = LootLink_NameFromLink(link);
				
				if( name and ItemLinks[name] and ItemLinks[name].price ) then
					local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID);
					LootLink_SetTooltipMoney(GameTooltip, name, itemCount);
					GameTooltip:Show();
				end
			end
		end
	end
end

function LootLink_GameTooltip_SetLootItem(this, slot)
	lOriginal_GameTooltip_SetLootItem(this, slot);
	
	local link = GetLootSlotLink(slot);
	local name = LootLink_NameFromLink(link);
	if( name and ItemLinks[name] and ItemLinks[name].price ) then
		local texture, item, quantity, quality = GetLootSlotInfo(slot);
		LootLink_SetTooltipMoney(GameTooltip, name, quantity);
		GameTooltip:Show();
	end
end

function LootLink_OnEvent()
	if( event == "PLAYER_TARGET_CHANGED" ) then
		if( UnitIsUnit("target", "player") ) then
			return;
		elseif( UnitIsPlayer("target") ) then
			LootLink_Inspect("target");
		end
	elseif( event == "UNIT_INVENTORY_CHANGED" ) then
		if( arg1 == "player" ) then
			LootLink_ScanInventory();
			LootLink_Inspect("player");
		end
	elseif( event == "BANKFRAME_OPENED" ) then
		LootLink_ScanBank();
	elseif( event == "VARIABLES_LOADED" ) then
		if( not ItemLinks ) then
			ItemLinks = { };
		else
			ItemLinksSize = 0;
			for index, value in ItemLinks do
				ItemLinksSize = ItemLinksSize + 1;
			end
		end
	elseif( event == "AUCTION_HOUSE_SHOW" ) then
		if( lScanAuction ) then
			LootLink_StartAuctionScan();
		end
	elseif( event == "AUCTION_HOUSE_CLOSED" ) then
		LootLink_StopAuctionScan();
	elseif( event == "AUCTION_ITEM_LIST_UPDATE" ) then
		LootLink_ScanAuction();
	elseif( event == "TOOLTIP_ADD_MONEY" ) then
		LootLink_ScanSellPrice(arg2);
	else
		LootLink_ProcessLinks(arg1);
	end
end

function LootLinkItemButton_OnClick(button)
	if( button == "LeftButton" ) then
		if( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert(LootLink_GetLink(this:GetText()));
		end
	end
end

function LootLink_OnShow()
	PlaySound("igMainMenuOpen");
	LootLink_Update();
end

function LootLink_OnHide()
	PlaySound("igMainMenuClose");
end

function LootLinkItemButton_OnEnter()
	local link = LootLink_GetHyperlink(this:GetText());
	if( link ) then
		LootLinkFrame.TooltipButton = this:GetID();
		LootLinkTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
		LootLinkTooltip:SetHyperlink(link);
		LootLink_AddTooltipPrice(this:GetText());
	end
end

function LootLinkItemButton_OnLeave()
	if( LootLinkFrame.TooltipButton ) then
		LootLinkFrame.TooltipButton = nil;
		HideUIPanel(LootLinkTooltip);
	end
end

function LootLinkFrameDropDown_OnLoad()
	UIDropDownMenu_Initialize(LootLinkFrameDropDown, LootLinkFrameDropDown_Initialize);
	LootLink_UIDropDownMenu_SetSelectedID(LootLinkFrameDropDown, 1, LOOTLINK_DROPDOWN_LIST);
	UIDropDownMenu_SetWidth(80);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", LootLinkFrameDropDown)
end

function LootLinkFrameDropDownButton_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID(LootLinkFrameDropDown);
	UIDropDownMenu_SetSelectedID(LootLinkFrameDropDown, this:GetID());
	if( oldID ~= this:GetID() ) then
		LootLink_Refresh();
	end
end

function LLS_RarityDropDown_OnLoad()
	UIDropDownMenu_SetWidth(90);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", LLS_RarityDropDown);
end

function LLS_RarityDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(LLS_RarityDropDown, this:GetID());
end

function LLS_BindsDropDown_OnLoad()
	UIDropDownMenu_SetWidth(90);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", LLS_BindsDropDown);
end

function LLS_BindsDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(LLS_BindsDropDown, this:GetID());
end

function LLS_LocationDropDown_OnLoad()
	UIDropDownMenu_SetWidth(90);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", LLS_LocationDropDown);
end

function LLS_LocationDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(LLS_LocationDropDown, this:GetID());
end

function LLS_TypeDropDown_OnLoad()
	UIDropDownMenu_SetWidth(90);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", LLS_TypeDropDown);
end

function LLS_TypeDropDown_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID(LLS_TypeDropDown);
	UIDropDownMenu_SetSelectedID(LLS_TypeDropDown, this:GetID());
	if( oldID ~= this:GetID() ) then
		LootLink_SetupTypeUI(this:GetID(), 1);
	end
end

function LLS_SubtypeDropDown_OnLoad()
	UIDropDownMenu_SetWidth(90);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", LLS_SubtypeDropDown);
end

function LLS_SubtypeDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(LLS_SubtypeDropDown, this:GetID());
end

--------------------------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------------------------
function ToggleLootLink()
	if( LootLinkFrame:IsVisible() ) then
		HideUIPanel(LootLinkFrame);
	else
		ShowUIPanel(LootLinkFrame);
	end
end

function LootLink_SlashCommandHandler(msg)
	if( not msg or msg == "" ) then
		ToggleLootLink();
	else
		local command = string.lower(msg);
		if( command == LOOTLINK_HELP ) then
			local index;
			local value;
			for index, value in LOOTLINK_HELP_TEXT do
				DEFAULT_CHAT_FRAME:AddMessage(value);
			end
		elseif( command == LOOTLINK_AUCTION or command == LOOTLINK_SCAN ) then
			if( AuctionFrame:IsVisible() ) then
				local iButton;
				local button;

				-- Hide the UI from any current results, show the no results text so we can use it
				BrowseNoResultsText:Show();
				for iButton = 1, NUM_BROWSE_TO_DISPLAY do
					button = getglobal("BrowseButton"..iButton);
					button:Hide();
				end
				BrowsePrevPageButton:Hide();
				BrowseNextPageButton:Hide();
				BrowseSearchCountText:Hide();

				LootLink_StartAuctionScan();
			else
				lScanAuction = 1;
				DEFAULT_CHAT_FRAME:AddMessage("LootLink will perform a full auction scan the next time you talk to an auctioneer.");
			end
		end
	end
end

function LootLink_Update()
	local iItem;
	
	if( DisplayIndices == nil ) then
		LootLink_BuildDisplayIndices();
	end
	FauxScrollFrame_Update(LootLinkListScrollFrame, DisplayIndices.onePastEnd - 1, LOOTLINK_ITEMS_SHOWN, LOOTLINK_ITEM_HEIGHT);
	for iItem = 1, LOOTLINK_ITEMS_SHOWN, 1 do
		local itemIndex = iItem + FauxScrollFrame_GetOffset(LootLinkListScrollFrame);
		local lootLinkItem = getglobal("LootLinkItem"..iItem);
		if( itemIndex < DisplayIndices.onePastEnd ) then
			local color = { };
			local name = DisplayIndices[itemIndex];
			lootLinkItem:SetText(name);
			if( ItemLinks[name].color ) then
				color.r, color.g, color.b = LootLink_GetRGBFromHexColor(ItemLinks[name].color);
				lootLinkItem:SetTextColor(color.r, color.g, color.b);
				lootLinkItem.r = color.r;
				lootLinkItem.g = color.g;
				lootLinkItem.b = color.b;
			else
				lootLinkItem.r = 0;
				lootLinkItem.g = 0;
				lootLinkItem.b = 0;
			end
			lootLinkItem:Show();
			
			if( LootLinkFrame.TooltipButton and LootLinkFrame.TooltipButton == iItem ) then
				if( ItemLinks[name].item ) then
					LootLinkTooltip:SetHyperlink(LootLink_GetHyperlink(name));
					LootLink_AddTooltipPrice(name);
				else
					LootLinkItemButton_OnLeave();
				end
			end
		else
			lootLinkItem:Hide();
		end
	end
end

function LootLink_Search()
	LootLinkSearchFrame:Show();
end

function LootLink_Refresh()
	FauxScrollFrame_SetOffset(LootLinkListScrollFrame, 0);
	getglobal("LootLinkListScrollFrameScrollBar"):SetValue(0);
	LootLink_BuildDisplayIndices();
	LootLink_Update();
end

function LootLink_DoSearch()
	LootLink_Refresh();
end

function LootLinkSearch_LoadValues()
	local sp = LootLinkFrame.SearchParams;
	local field;
	
	field = getglobal("LLS_TextEditBox");
	if( sp and sp.text ) then
		field:SetText(sp.text);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_NameEditBox");
	if( sp and sp.name ) then
		field:SetText(sp.name);
	else
		field:SetText("");
	end
	
	UIDropDownMenu_Initialize(LLS_RarityDropDown, LLS_RarityDropDown_Initialize);
	if( sp and sp.rarity ) then
		LootLink_UIDropDownMenu_SetSelectedID(LLS_RarityDropDown, sp.rarity, LLS_RARITY_LIST);
	else
		LootLink_UIDropDownMenu_SetSelectedID(LLS_RarityDropDown, 1, LLS_RARITY_LIST);
	end
	
	UIDropDownMenu_Initialize(LLS_BindsDropDown, LLS_BindsDropDown_Initialize);
	if( sp and sp.binds ) then
		LootLink_UIDropDownMenu_SetSelectedID(LLS_BindsDropDown, sp.binds, LLS_BINDS_LIST);
	else
		LootLink_UIDropDownMenu_SetSelectedID(LLS_BindsDropDown, 1, LLS_BINDS_LIST);
	end
	
	if( sp and sp.unique ) then
		getglobal("LLS_UniqueCheckButton"):SetChecked(1);
	else
		getglobal("LLS_UniqueCheckButton"):SetChecked(0);
	end
	
	UIDropDownMenu_Initialize(LLS_LocationDropDown, LLS_LocationDropDown_Initialize);
	if( sp and sp.location ) then
		LootLink_UIDropDownMenu_SetSelectedID(LLS_LocationDropDown, sp.location, LLS_LOCATION_LIST);
	else
		LootLink_UIDropDownMenu_SetSelectedID(LLS_LocationDropDown, 1, LLS_LOCATION_LIST);
	end
	
	field = getglobal("LLS_MinimumLevelEditBox");
	if( sp and sp.minLevel ) then
		field:SetText(sp.minLevel);
	else
		field:SetText("");
	end

	field = getglobal("LLS_MaximumLevelEditBox");
	if( sp and sp.maxLevel ) then
		field:SetText(sp.maxLevel);
	else
		field:SetText("");
	end
	
	UIDropDownMenu_Initialize(LLS_TypeDropDown, LLS_TypeDropDown_Initialize);
	if( sp and sp.type ) then
		LootLink_UIDropDownMenu_SetSelectedID(LLS_TypeDropDown, sp.type, LLS_TYPE_LIST);
	else
		LootLink_UIDropDownMenu_SetSelectedID(LLS_TypeDropDown, 1, LLS_TYPE_LIST);
	end
	
	if( sp and sp.type ) then
		LootLink_SetupTypeUI(sp.type, sp.subtype);
	else
		LootLink_SetupTypeUI(1, 1);
	end

	field = getglobal("LLS_MinimumDamageEditBox");
	if( sp and sp.minMinDamage ) then
		field:SetText(sp.minMinDamage);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MaximumDamageEditBox");
	if( sp and sp.minMaxDamage ) then
		field:SetText(sp.minMaxDamage);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MaximumSpeedEditBox");
	if( sp and sp.maxSpeed ) then
		field:SetText(sp.maxSpeed);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MinimumDPSEditBox");
	if( sp and sp.minDPS ) then
		field:SetText(sp.minDPS);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MinimumArmorEditBox");
	if( sp and sp.minArmor ) then
		field:SetText(sp.minArmor);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MinimumBlockEditBox");
	if( sp and sp.minBlock ) then
		field:SetText(sp.minBlock);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MinimumSlotsEditBox");
	if( sp and sp.minSlots ) then
		field:SetText(sp.minSlots);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MinimumSkillEditBox");
	if( sp and sp.minSkill ) then
		field:SetText(sp.minSkill);
	else
		field:SetText("");
	end
	
	field = getglobal("LLS_MaximumSkillEditBox");
	if( sp and sp.maxSkill ) then
		field:SetText(sp.maxSkill);
	else
		field:SetText("");
	end
end

function LootLinkSearch_SaveValues()
	local sp;
	local interesting;
	local field;
	local value;
	
	LootLinkFrame.SearchParams = { };
	sp = LootLinkFrame.SearchParams;
	
	field = getglobal("LLS_TextEditBox");
	value = field:GetText();
	if( value and value ~= "" ) then
		sp.text = value;
		interesting = 1;
	end
	
	field = getglobal("LLS_NameEditBox");
	value = field:GetText();
	if( value and value ~= "" ) then
		sp.name = value;
		interesting = 1;
	end
	
	value = UIDropDownMenu_GetSelectedID(LLS_RarityDropDown);
	if( value and value ~= 1 ) then
		sp.rarity = value;
		interesting = 1;
	end
	
	value = UIDropDownMenu_GetSelectedID(LLS_BindsDropDown);
	if( value and value ~= 1 ) then
		sp.binds = value;
		interesting = 1;
	end
	
	field = getglobal("LLS_UniqueCheckButton");
	value = field:GetChecked();
	if( value ) then
		sp.unique = value;
		interesting = 1;
	end
	
	value = UIDropDownMenu_GetSelectedID(LLS_LocationDropDown);
	if( value and value ~= 1 ) then
		sp.location = value;
		interesting = 1;
	end
	
	field = getglobal("LLS_MinimumLevelEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minLevel = value + 0;
		interesting = 1;
	end
	
	field = getglobal("LLS_MaximumLevelEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.maxLevel = value + 0;
		interesting = 1;
	end

	value = UIDropDownMenu_GetSelectedID(LLS_TypeDropDown);
	if( value and value ~= 1 ) then
		sp.type = value;
		interesting = 1;
	end
	
	value = UIDropDownMenu_GetSelectedID(LLS_SubtypeDropDown);
	if( value and value ~= 1 ) then
		sp.subtype = value;
		if( sp.type and sp.type ~= 1 ) then
			interesting = 1;
		end
	end

	field = getglobal("LLS_MinimumDamageEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minMinDamage = value + 0;
		interesting = 1;
	end
	
	field = getglobal("LLS_MaximumDamageEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minMaxDamage = value + 0;
		interesting = 1;
	end
	
	field = getglobal("LLS_MaximumSpeedEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.maxSpeed = value + 0;
		interesting = 1;
	end
	
	field = getglobal("LLS_MinimumDPSEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minDPS = value + 0;
		interesting = 1;
	end
	
	field = getglobal("LLS_MinimumArmorEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minArmor = value + 0;
		interesting = 1;
	end
	
	field = getglobal("LLS_MinimumBlockEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minBlock = value + 0;
		interesting = 1;
	end

	field = getglobal("LLS_MinimumSlotsEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minSlots = value + 0;
		interesting = 1;
	end

	field = getglobal("LLS_MinimumSkillEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.minSkill = value + 0;
		interesting = 1;
	end

	field = getglobal("LLS_MaximumSkillEditBox");
	value = field:GetText();
	if( value and LootLink_CheckNumeric(value) ) then
		sp.maxSkill = value + 0;
		interesting = 1;
	end

	-- Only save search params if we had interesting data on the page	
	if( interesting == nil ) then
		LootLinkFrame.SearchParams = nil;
	else
		if( IsControlKeyDown() ) then
			sp.plain = nil;
		else
			sp.plain = 1;
		end
	end
end

function LootLinkSearchFrame_SaveSearchParams()
	LootLinkSearchFrame.OldSearchParams = LootLinkFrame.SearchParams;
end

function LootLinkSearchFrame_RestoreSearchParams()
	LootLinkFrame.SearchParams = LootLinkSearchFrame.OldSearchParams;
end

function LootLinkSearchFrame_Cancel()
	PlaySound("gsTitleOptionExit");
	LootLinkSearchFrame:Hide();
	LootLinkSearchFrame_RestoreSearchParams();
end

function LootLinkSearchFrame_Okay()
	PlaySound("gsTitleOptionOK");
	LootLinkSearchFrame:Hide();
	LootLinkSearch_SaveValues();
	LootLink_DoSearch();
end

--------------------------------------------------------------------------------------------------
-- External functions
--------------------------------------------------------------------------------------------------
function LootLink_ProcessLinks(text)
	local color;
	local item;
	local name;
	local lastName = "";
	
	if( text ) then
		for color, item, name in string.gfind(text, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
			if( color and item and name ) then
				if( ItemLinks[name] == nil ) then
-- Telo: unfortunately, this code to verify the link causes random client crashes
--					if( LootLink_NameMatchesTooltip(name, item) ) then
						ItemLinks[name] = { };
						ItemLinks[name].color = color;
						ItemLinks[name].item = string.gsub(item, "^(%d+):(%d+):(%d+):(%d+)$", "%1:0:%3:%4");
--					end
				end
				lastName = name;
			end
		end
	end
	return lastName;
end

function LootLink_ProcessLootMsg(msg, frame, info)
	local item;
	local name;
	local link;
	
	for item, name in string.gfind(msg, "|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h") do
		if( item and name and ItemLinks[name] ) then
			link = "|Hitem:"..item.."|h["..name.."]|h";
			msg = string.gsub(msg, LootLink_EscapePattern(link), "|c"..ItemLinks[name].color..link);
		end
	end
	frame:AddMessage(msg, info.r, info.g, info.b, info.id);
end

function LootLink_Validate()
	for index, value in ItemLinks do
		if( not value.SearchData ) then
			DEFAULT_CHAT_FRAME:AddMessage(index.." has no SearchData");
		else
			if( not value.SearchData.subtype ) then
				DEFAULT_CHAT_FRAME:AddMessage(index.." has no subtype");
			end
		end
	end
end
