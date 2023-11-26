-- BGAssist 
-- Copyright 2005 original author. Copyright is expressly not transferred to Blizzard.
-- 
-- Battleground helper functionality
--
--  Author: Marc aka Saien on Hyjal
--  http://64.168.251.69/wow
--
--    

BGASSIST_VERSION = "2005.06.28";

local BGAssist_ItemTrack = {
	["item:17422"] = "INV_Shoulder_19",		-- "Armor Scraps"
	-- Horde
	["item:17306"] = "INV_Potion_50",		-- "Stormpike Soldier's Blood"
	["item:17642"] = "INV_Misc_Pelt_Bear_02",	-- "Alterac Ram Hide"
	["item:18142"] = "INV_Misc_Head_Elf_02",	-- "Severed Night Elf Head"
	["item:18143"] = "INV_Misc_MonsterTail_02",	-- "Tuft of Gnome Hair"
	["item:18206"] = "INV_Misc_Bone_03",		-- "Dwarf Spine"
	["item:18144"] = "INV_Misc_Bone_07",		-- "Human Bone Chip"
	["item:17326"] = "INV_Misc_Food_52",		-- "Stormpike Soldier's Flesh",
	["item:17327"] = "INV_Misc_Food_72",		-- "Stormpike Lieutenant's Flesh"
	["item:17328"] = "INV_Misc_Food_69",		-- "Stormpike Commander's Flesh",
	-- Alliance
	["item:17423"] = "INV_Misc_Gem_Pearl_06",	-- "Storm Crystal"
	["item:17643"] = "INV_Misc_Pelt_Bear_02",	-- "Frostwolf Hide"
	["item:18145"] = "INV_Misc_Foot_Centaur",	-- "Tauren Hoof"
	["item:18146"] = "INV_Potion_82",		-- "Darkspear Troll Mojo"
	["item:18207"] = "INV_Misc_Bone_08",		-- "Orc Tooth"
	["item:18147"] = "INV_Misc_Organ_01",		-- "Forsaken Heart"
	["item:17502"] = "INV_Jewelry_Talisman_06", 	-- "Frostwolf Soldier's Medal"
	["item:17503"] = "INV_Jewelry_Talisman_04",	-- "Frostwolf Lieutenant's Medal"
	["item:17504"] = "INV_Jewelry_Talisman_12",	-- "Frostwolf Commander's Medal"
};
local BGAssist_Alterac_Quests = {
	["Irondeep Supplies"] = true,
	["Coldtooth Supplies"] = true,
	["Master Ryson's All Seeing Eye"] = true,
	["Empty Stables"] = true,	-- Wolf/Ram turnin
	-- Horde
	["More Booty!"] 			= { item = "item:17422", min=20 },
	["Lokholar the Ice Lord"] 		= { item = "item:17306", max=4 },
	["A Gallon of Blood"] 			= { item = "item:17306", min=5 },
	["Ram Hide Harnesses"] 			= { item = "item:17642" },
	["Darkspear Defense"] 			= { item = "item:18142" },
	["Tuft it Out"] 			= { item = "item:18143" },
	["Wanted: MORE DWARVES!"] 		= { item = "item:18206" },
	["I've Got A Fever For More Bone Chips"]= { item = "item:18144" },
	["Call of Air - Guse's Fleet"]		= { item = "item:17326" },
	["Call of Air - Jeztor's Fleet"]	= { item = "item:17327" },
	["Call of Air - Mulverick's Fleet"]	= { item = "item:17328" },
	-- Alliance
	["More Armor Scraps"] 			= { item = "item:17422", min=20 },
	["Ivus the Forest Lord"] 		= { item = "item:17423", max=4 },
	["Crystal Cluster"] 			= { item = "item:17423", min=5 },
	["Ram Riding Harnesses"] 		= { item = "item:17643" },
	["What the Hoof?"] 			= { item = "item:18145" },
	["Staghelm's Mojo Jamboree"] 		= { item = "item:18146" },
	["Wanted: MORE ORCS!"] 			= { item = "item:18207" },
	["One Man's Love"] 			= { item = "item:18147" },
	["Call of Air - Sildore's Fleet"]	= { item = "item:17502" },
	["Call of Air - Vipore's Fleet"]	= { item = "item:17503" },
	["Call of Air - Ichman's Fleet"]	= { item = "item:17504" },
};
local ALTERACVALLEY = "Alterac Valley";

local MENU_LOCKWINDOW = "Lock Window Position";
local MENU_AUTOREZ = "Auto Rez in BG";
local MENU_AUTOQUEST = "Auto Confirm BG Quests";
local MENU_AUTOENTER = "Auto Enter BG";
local MENU_TIMERSHOW = "Show Capture Timers";
local MENU_ITEMSHOW = "Show BG Item Counts";

if ( GetLocale() == "frFR" ) then
	BGAssist_Alterac_Quests = {
	};
	ALTERACVALLEY = "";
end
if ( GetLocale() == "deDE" ) then
	BGAssist_Alterac_Quests = {
	};
	ALTERACVALLEY = "";
end


local MAXTIMERS = 5;
local MAXICONS = 10;
local MAXTIMERVALUE = 300; -- Five minute countdown on capture
local OUTOFZONETEST = false; -- Debug mode to test stuff while out of zone;
local EVENTSINBATTLEGROUND = {
	-- Bag item tracking
	"BAG_UPDATE",
	-- Track into quest windows for autocomplete
	"QUEST_PROGRESS",
	"QUEST_COMPLETE",
	"QUEST_GREETING",
	"QUEST_DETAIL",
	"GOSSIP_SHOW",
	-- Autorez
	"AREA_SPIRIT_HEALER_IN_RANGE",
	-- People counting
	"UPDATE_BATTLEFIELD_SCORE",
	-- Chat messages
	"CHAT_MSG_MONSTER_YELL",
};

BGAssist_Player = nil; -- global;
local BGAssist_Config_Loaded = nil;
local BGAssist_CountedPlayers = nil;
local BGAssist_Scheduled_MapCheck = nil;
local BGAssist_InBattleGround = nil;
local BGAssist_TimersActive = nil;
local BGAssist_LastTimersProc = 0;
local BGAssist_MapItems = {};
local BGAssist_TrackedItems = {};
local BGAssist_ItemInfo = {};

local function BGAssist_LinkDecode(link)
	local id, name;
	_, _, id, name = string.find(link,"|H(item:%d+):%d+:%d+:%d+|h%[([^]]+)%]|h|r$");
	-- Only first number of itemid is significant in this.
	if (id and name) then
		return name, id;
	end
end

local function BGAssist_BagCheck()
	local bag, slot, size;
	BGAssist_TrackedItems = {};
	for bag = 0, 4, 1 do
		if (bag == 0) then
			size = 16;
		else
			size = GetContainerNumSlots(bag);
		end
		if (size and size > 0) then
			for slot = 1, size, 1 do
				local itemLink = GetContainerItemLink(bag,slot);
				if (itemLink) then
					local itemName, itemID = BGAssist_LinkDecode(itemLink);
					local texture, itemCount = GetContainerItemInfo(bag,slot);
					if (itemID and BGAssist_ItemTrack[itemID]) then
						if (not BGAssist_TrackedItems[itemID]) then
							BGAssist_TrackedItems[itemID] = 0;
						end
						BGAssist_ItemInfo[itemID] = {
							["name"] = itemName, 
							["texture"] = texture;
						};
						BGAssist_TrackedItems[itemID] = BGAssist_TrackedItems[itemID] + itemCount;
					end
				end
			end
		end
	end
	if (BGAssist_Timers:IsVisible()) then
		BGAssist_Timers_OnShow();
	end
end

local function BGAssist_CheckMap()
	local OUTOFZONEDATA = {
		[1] = { "Dead Guys", "", 3 };
		[2] = { "Bar", "Drink Here", 8};
		[3] = { "Elves Head Point", "ELVES DIE", 11 };
		[4] = { "Monkey", "Monkey", 13 };
	};
	local totallandmarks = GetNumMapLandmarks()
	if (OUTOFZONETEST) then
		totallandmarks = 4;
	end
	local name, description, typ, x, y;
	local i;
	for i = 1, totallandmarks, 1 do
		name, description, typ, x, y = GetMapLandmarkInfo(i);
		if (OUTOFZONETEST) then
			name = OUTOFZONEDATA[i][1];
			description = OUTOFZONEDATA[i][2];
			typ = OUTOFZONEDATA[i][3];
		end

		-- typ:
		--  0 = Mines, no icon
		--  1 = Horde controlled mine
		--  2 = Alliance controlled mine
		--  3 = Horde graveyard attacked by Alliance
		--  4 = Towns (Booty Bay, Stonard, etc)
		--  5 = Destroyed tower
		--  6 = 
		--  7 = 
		--  8 = Horde tower attacked by Alliance
		--  9 = Horde controlled tower
		-- 10 = Alliance controlled tower
		-- 11 = Alliance tower attacked by Horde
		-- 12 = Horde controlled graveyard
		-- 13 = Alliance graveyard attacked by Horde
		-- 14 = Alliance controlled graveyard
		-- 15 = Garrisons/Caverns, no icon
		-- Cap time is 300 seconds (5min)
		if (not BGAssist_MapItems[name]) then BGAssist_MapItems[name] = {} end
		if (typ == 3 or typ == 8 or typ == 9 or typ == 12) then
			BGAssist_MapItems[name].owner = "HORDE";
		elseif (typ == 10 or typ == 11 or typ == 13 or typ == 14) then
			BGAssist_MapItems[name].owner = "ALLIANCE";
		elseif (typ == 0 or typ == 5 or typ == 15) then
			BGAssist_MapItems[name].owner = nil;
		end
		if (typ == 3 or typ == 12 or typ == 13 or typ == 14) then
			BGAssist_MapItems[name].func = "GRAVEYARD";
		elseif (typ == 5 or typ == 8 or typ == 9 or typ == 10 or typ == 11) then
			BGAssist_MapItems[name].func = "TOWER";
		elseif (typ == 0 or typ == 1 or typ == 2) then
			BGAssist_MapItems[name].func = "MINE";
		end
		if (typ == 3 or typ == 13 or typ == 8 or typ == 11) then
			if (not BGAssist_MapItems[name].conflictstart) then
				if (OUTOFZONETEST) then
					BGAssist_MapItems[name].conflictstart = GetTime() - math.random(200);
				else
					BGAssist_MapItems[name].conflictstart = GetTime();
				end
			end
		else
			BGAssist_MapItems[name].conflictstart = nil
		end
		if (typ ==  6 or typ ==  7) then
			if (Debug) then Debug ("UNKNOWN: "..name.." = "..description.." = "..typ); end
		end
	end
	if (not BGAssist_Config.timerhide) then
		BGAssist_Timers_OnShow();
	end
end

--[[
local function BGAssist_ChatFound(method, place, faction)
	if (faction) then
		Debug ("BG: CHATFOUND: "..method.." for "..place.." by "..faction);
	else
		Debug ("BG: CHATFOUND: "..method.." for "..place.." by UNLISTED");
	end
end

local function BGAssist_ParseChat(text)
	local messages = {
		["GYTAKEN"] = { ["one"] = "PLACE", ["two"] = "FACTION", 
				["regexp"] = "The ([^ ]*) Graveyard was taken by the ([^!]*)" 
		},
		["GYATTACK"] = { ["one"] = "PLACE",
				["regexp"] = "The ([^ ]*) Graveyard is under attack"
		},
		["GYUNCHECKED"] = { ["one"] = "PLACE", ["two"] = "FACTION", 
				["regexp"] = "The ([^ ]*) Graveyard is under attack! If left unchecked, the ([^ ]*) will capture it"
		},
		["MINETAKEN"] = { ["one"] = "FACTION", ["two"] = "PLACE",
				["regexp"] = "The ([^ ]*) has taken the ([^ ]*) Mine"
		},
	};
	local one, two, start, idx;
	local place, faction;
	for method in messages do
		Debug ("CHECKING METHOD: "..method);
		start, _, one, two = string.find (text,messages[method].regexp);
		if (start) then
			place = nil;
			faction = nil;
			if (messages[method].one == "PLACE") then place = one; end
			if (messages[method].one == "FACTION") then faction = one; end
			if (messages[method].two == "PLACE") then place = two; end
			if (messages[method].two == "FACTION") then faction = two; end
			BGAssist_ChatFound(method, place, faction);
		end
	end
end
]]

local function BGAssist_CountPlayers()
	local players = GetNumBattlefieldScores();
	if (players > 0) then
		local i;
		BGAssist_CountedPlayers = { 
			["Horde"] = {
				["count"] = 0,
				["Druid"] = 0, ["Hunter"] = 0, ["Mage"] = 0, ["Priest"] = 0,
				["Rogue"] = 0, ["Shaman"] = 0, ["Warrior"] = 0, ["Warlock"] = 0,
			}, 
			["Alliance"] = {
				["count"] = 0,
				["Druid"] = 0, ["Hunter"] = 0, ["Mage"] = 0, ["Paladin"] = 0,
				["Priest"] = 0, ["Rogue"] = 0, ["Warrior"] = 0, ["Warlock"] = 0,
			}, 
		};
		for i = 1, players, 1 do
			_, _, _, _, _, faction, _, _, class = GetBattlefieldScore(i);
			if (faction == 0) then faction = "Horde"; else faction = "Alliance"; end
			BGAssist_CountedPlayers[faction].count = BGAssist_CountedPlayers[faction].count + 1;
			BGAssist_CountedPlayers[faction][class] = BGAssist_CountedPlayers[faction][class] + 1;
		end
		-- Debug ("HORDE: "..BGAssist_CountedPlayers["Horde"].count);
		-- Debug ("ALLIANCE: "..BGAssist_CountedPlayers["Alliance"].count);
		ChatFrame1:AddMessage("Total Population: "..(BGAssist_CountedPlayers["Horde"].count+BGAssist_CountedPlayers["Alliance"].count));
		ChatFrame1:AddMessage ("HORDE: "..BGAssist_CountedPlayers["Horde"].count);
		ChatFrame1:AddMessage ("ALLIANCE: "..BGAssist_CountedPlayers["Alliance"].count);
	end
end

local function BGAssist_Alterac_SelectQuest(...) 
	local i;
	local idx = 0;
	for i = 1, arg.n, 2 do
		idx = idx + 1;
		if (BGAssist_Alterac_Quests[arg[i]]) then
			local item, min, max;
			if (type(BGAssist_Alterac_Quests[arg[i]]) == "table") then
				item = BGAssist_Alterac_Quests[arg[i]].item;
				min = BGAssist_Alterac_Quests[arg[i]].min;
				max = BGAssist_Alterac_Quests[arg[i]].max;
			else
				item = true;
			end
			if (not min or min < 1) then min = 1; end
			if (not max) then max = 1000; end
			local count = BGAssist_TrackedItems[item];
			if (not count) then count = 0; end
			if (item == true or (count >= min and count <= max)) then
				if (not BGAssist_Config[BGAssist_Player].turnins[arg[i]]) then
					BGAssist_Config[BGAssist_Player].turnins[arg[i]] = 0;
				end
				BGAssist_Config[BGAssist_Player].turnins[arg[i]] = BGAssist_Config[BGAssist_Player].turnins[arg[i]] + min;
				SelectGossipAvailableQuest(idx);
			end
		end
	end
end

local function BGAssist_Alterac_AutoProcess(method)
	if (BGAssist_Alterac_Quests[GetTitleText()]) then
		if (method == "QUEST_COMPLETE") then
			QuestRewardCompleteButton_OnClick();
		elseif (method == "QUEST_PROGRESS") then
			QuestProgressCompleteButton_OnClick();
		elseif (method == "QUEST_DETAIL") then
			QuestDetailAcceptButton_OnClick();
		elseif (Debug) then
			Debug ("Unknown METHOD: "..method.." for "..GetTitleText());
		end
	end
end

local function BGAssist_ConfigInit()
	if (not BGAssist_Config) then
		BGAssist_Config = {};
	end
	if (not BGAssist_Config[BGAssist_Player]) then
		BGAssist_Config[BGAssist_Player] = {};
	end
	if (not BGAssist_Config[BGAssist_Player].turnins) then
		BGAssist_Config[BGAssist_Player].turnins = {};
	end

	BGAssist_CheckMap();
end

function BGAssist_OnLoad()
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("VARIABLES_LOADED");
	-- Autoenter
	this:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");

	if(UltimateUI_RegisterButton) then
		UltimateUI_RegisterButton ( 
			"BGAssist", 
			"Configure", 
			"Configure", 
			"Interface\\Icons\\Spell_Holy_DevotionAura", 
			ToggleBGAssist
		);
	end
	
end

function ToggleBGAssist()
	if( BGAssist_Timers:IsVisible() ) then
		BGAssist_Timers:Hide();
	else
		BGAssist_Timers:Show();
	end
end

function BGAssist_OnEvent()
	if (event == "UNIT_NAME_UPDATE" and arg1 == "player") then
		local playerName = UnitName("player");
		if (playerName ~= UKNOWNBEING and playerName ~= UNKNOWNOBJECT) then
			BGAssist_Player = playerName;
		end
		if (BGAssist_Player and BGAssist_Config_Loaded) then
			BGAssist_ConfigInit();
		end
	elseif (event == "VARIABLES_LOADED") then
		BGAssist_Config_Loaded = 1;
		if (BGAssist_Player) then
			BGAssist_ConfigInit();
		end
	elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
		local status, mapName, instanceID = GetBattlefieldStatus()
		if (status=="active" or OUTOFZONETEST) then
			if (OUTOFZONETEST and not mapName) then mapName = "OUTOFZONETEST"; end
			if (not BGAssist_InBattleGround) then
				DEFAULT_CHAT_FRAME:AddMessage("BGAssist: Entering Battlegrounds: "..mapName);
				BGAssist_InBattleGround = mapName;
				BGAssist_BagCheck();
				local idx,event;
				for idx,event in EVENTSINBATTLEGROUND do
					BGAssist:RegisterEvent(event);
				end
				if (not BGAssist_Config.timerhide or not BGAssist_Config.itemhide) then
					BGAssist_Timers:Show();
				end

			end
			BGAssist_CheckMap();
		elseif (not BGAssist_Config.noautoenter and status=="confirm") then
			StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY");
			BattlefieldFrame_EnterBattlefield();
		elseif (BGAssist_InBattleGround) then
			DEFAULT_CHAT_FRAME:AddMessage("BGAssist: Left Battlegrounds: "..BGAssist_InBattleGround);
			BGAssist_InBattleGround = nil;
			local idx, event;
			for idx, event in EVENTSINBATTLEGROUND do
				BGAssist:UnregisterEvent(event);
			end
			BGAssist_Timers:Hide();
		end
	elseif (event == "CHAT_MSG_MONSTER_YELL") then
	 	-- BGAssist_ParseChat(arg1);
		BGAssist_Scheduled_MapCheck = GetTime()+0.1;
	elseif (event == "BAG_UPDATE") then
		BGAssist_BagCheck();
	elseif (event == "AREA_SPIRIT_HEALER_IN_RANGE") then
		if (not BGAssist_Config.noautorez and (OUTOFZONETEST or BGAssist_InBattleGround == ALTERACVALLEY or BGAssist_InBattleGround == WARSONGGULCH)) then
			AcceptAreaSpiritHeal();
			local win = 1;
			if (StaticPopup2:IsVisible() and StaticPopup2.which == "AREA_SPIRIT_HEAL") then win = 2; end
			if (StaticPopup3:IsVisible() and StaticPopup3.which == "AREA_SPIRIT_HEAL") then win = 3; end
			if (StaticPopup4:IsVisible() and StaticPopup4.which == "AREA_SPIRIT_HEAL") then win = 4; end
			getglobal("StaticPopup"..win.."Button1"):Hide();
			getglobal("StaticPopup"..win.."Button2"):Hide();
		end
	elseif (event == "QUEST_PROGRESS" or event == "QUEST_COMPLETE" or event == "QUEST_GREETING" or event == "QUEST_DETAIL") then
		if (not BGAssist_Config.noautoquest and (OUTOFZONETEST or BGAssist_InBattleGround == ALTERACVALLEY)) then
			BGAssist_Alterac_AutoProcess(event);
		end
	elseif (event == "GOSSIP_SHOW") then
		if (not BGAssist_Config.noautoquest and (OUTOFZONETEST or BGAssist_InBattleGround == ALTERACVALLEY)) then
			BGAssist_Alterac_SelectQuest(GetGossipAvailableQuests());
		end
	elseif (event == "UPDATE_BATTLEFIELD_SCORE") then
		BGAssist_CountPlayers();
	end
end

function BGAssist_OnUpdate()
	local time = GetTime();
	if (BGAssist_Scheduled_MapCheck and BGAssist_Scheduled_MapCheck <= time) then
		BGAssist_Scheduled_MapCheck = nil;
		BGAssist_CheckMap();
	end
end

function BGAssist_Timers_OnUpdate(elapsed)
	local time = GetTime();
	if (BGAssist_TimersActive) then
		if (BGAssist_TimersActive <= time) then
			BGAssist_UpdateTimers();
		else
			if (BGAssist_LastTimersProc+1 < time) then
				local i;
				for i = 1, MAXTIMERS, 1 do
					local timer = getglobal("BGAssist_Timers"..i);
					if (timer.endtime) then
						local timeleft = timer.endtime - time;
						timer:SetValue(timeleft);
					end
				end
				BGAssist_LastTimersProc = time;
			end
		end
		if (this.updateTooltip) then
			this.updateTooltip = this.updateTooltip - elapsed;
			if (this.updateTooltip < 0) then
				BGAssist_Timer_SetTooltip(this.tooltipUpdate);
			end
		end
	end
end

function BGAssist_DynamicResize()
	local i;
	local maxtimer = 0;
	local maxicon = 0;
	for i = 1, MAXICONS, 1 do
		local icon = getglobal("BGAssist_Timers_Icon"..i);
		if (icon:IsVisible()) then maxicon = i; end
	end
	for i = 1, MAXTIMERS, 1 do
		local timerobj = getglobal("BGAssist_Timers"..i);
		if (timerobj:IsVisible()) then maxtimer = i; end;
	end

	if (BGAssist_Config.timerhide) then maxtimer = 0; end
	if (BGAssist_Config.itemhide) then maxicon = 0; end

	-- Move Icons to under last timer
	if (maxicon and maxicon > 0) then
		BGAssist_Timers_Icon1:ClearAllPoints();
		if (maxtimer == 0) then
			BGAssist_Timers_Icon1:SetPoint("TOPLEFT","BGAssist_Timers","TOPLEFT",6,-8);
		else
			BGAssist_Timers_Icon1:SetPoint("TOPLEFT","BGAssist_Timers"..maxtimer,"BOTTOMLEFT",0,-6);
		end
	end
	local iconwidth = 36;
	local iconheight = 36;
	if (maxicon and maxicon > 3) then
		if (maxicon > 4) then
			iconwidth = 24;
		else
			iconwidth = 30;
		end
		if (maxicon > 5) then
			iconheight = 18;
		end
	end
	for i = 1, MAXICONS, 1 do
		local icon = getglobal("BGAssist_Timers_Icon"..i);
		local texture = getglobal("BGAssist_Timers_Icon"..i.."NormalTexture");
		icon:SetWidth(iconwidth);
		icon:SetHeight(iconheight);
		texture:SetWidth(iconwidth*2);
		texture:SetHeight(iconheight*2);
	end
	local backdropheight = 16; -- Buffer at top and bottom and room for border
	backdropheight = backdropheight + (maxtimer*12);
	if (maxicon > 0 and maxtimer > 0) then backdropheight = backdropheight + 3; end
	if (maxicon > 5) then 
		backdropheight = backdropheight + (iconheight*2) + 3;
	elseif (maxicon > 0) then
		backdropheight = backdropheight + iconheight;
	end
	BGAssist_Timers:SetHeight(backdropheight);
end

function BGAssist_Timers_OnShow()
	UIDropDownMenu_Initialize(BGAssist_Timers_Menu, BGAssist_MenuDropDown_Initialize, "MENU");
	
	BGAssist_UpdateTimers();
	BGAssist_UpdateItems();
	if (BGAssist_Timers1:IsVisible()) then
		BGAssist_Timers_TitleText:SetText("Captures");
	else
		if (BGAssist_Timers_Icon1:IsVisible()) then
			BGAssist_Timers_TitleText:SetText("Items");
		else
			BGAssist_Timers_TitleText:SetText("BGAssist");
		end
	end
	BGAssist_DynamicResize();
end

function BGAssist_UpdateItems()
	local function findicon (item)
		local idx = 1;
		local found = 0;
		while (found == 0 and idx <= MAXICONS) do
			local icon = getglobal("BGAssist_Timers_Icon"..idx);
			if (icon and icon.item and icon.item == item) then
				found = idx;
			end
			idx = idx + 1;
		end
		return found;
	end
	local function fillicon (item, num)
		local icon = getglobal("BGAssist_Timers_Icon"..num);
		if (icon) then
			icon.item = item;
			icon:Show();
			getglobal("BGAssist_Timers_Icon"..num.."Icon"):SetTexture(BGAssist_ItemInfo[item].texture);
		end
	end

	local showitems = {};
	local maxicon = 0;
	if (not BGAssist_Config.itemhide and BGAssist_TrackedItems and BGAssist_TrackedItems ~= {}) then
		local item;
		for item in BGAssist_TrackedItems do
			if (BGAssist_TrackedItems[item] > 0) then
				showitems[item] = findicon(item);
			end
		end
		for item in showitems do
			local idx = 1;
			if (showitems[item] == 0) then
				while (showitems[item] == 0 and idx <= MAXICONS) do
					local icon = getglobal("BGAssist_Timers_Icon"..idx);
					if (icon and not icon.item) then
						showitems[item] = idx;
					end
					idx = idx + 1;
				end
			end
			if (showitems[item] > maxicon) then maxicon = showitems[item]; end
			fillicon (item, showitems[item])
		end
		local i;
		for i = 1, MAXICONS, 1 do
			local icon = getglobal("BGAssist_Timers_Icon"..i);
			if (not icon.item or not BGAssist_TrackedItems[icon.item] or BGAssist_TrackedItems[icon.item] < 1) then
				if (i < maxicon) then
					local j = i+1;
					local jicon = getglobal("BGAssist_Timers_Icon"..j);
					while (j <= MAXICONS and not jicon.item) do
						jicon = getglobal("BGAssist_Timers_Icon"..j);
						j = j + 1;
					end
					if (jicon.item) then
						fillicon (jicon.item, j-1);
						jicon.item = nil;
					end
				else
					icon.item = nil;
					icon:Hide();
				end
			end
		end
	else
		local i;
		for i = 1, MAXICONS, 1 do
			local icon = getglobal("BGAssist_Timers_Icon"..i);
			icon:Hide();
			icon.item = nil;
		end
	end
end

function BGAssist_UpdateTimers()

	local function sort_function (a, b) 
		local endtime= BGAssist_MapItems[a].conflictstart + 300;
		local atime = endtime - GetTime();
		endtime= BGAssist_MapItems[b].conflictstart + 300;
		local btime = endtime - GetTime();
		if (atime < btime) then return true; else return false; end
	end

	if (not BGAssist_Config.timerhide) then
		local status, mapName, instanceID = GetBattlefieldStatus()
		if (OUTOFZONETEST or status == "active") then
			if (BGAssist_MapItems == nil or BGAssist_MapItems == {}) then
				BGAssist_CheckMap();
			else
				local conflicts = {};
				local conflictcount = 0;
				local red, green, blue;
				local name;
				for name in BGAssist_MapItems do
					if (BGAssist_MapItems[name].conflictstart) then
						local endtime = BGAssist_MapItems[name].conflictstart + 300;
						local timeleft = endtime - GetTime();
						if (timeleft > 0) then
							conflictcount = conflictcount + 1;
							conflicts[conflictcount] = name;
						end
					end
				end
				table.sort(conflicts, sort_function);
				local timer = 0;
				local timersused = nil;
				for timer = 1, MAXTIMERS, 1 do
					if (conflicts[timer]) then
						timersused = nil;
						red = 0; green = 0; blue = 0;
						if (BGAssist_MapItems[conflicts[timer]].owner == "HORDE") then
							red = 1;
						elseif (BGAssist_MapItems[conflicts[timer]].owner == "ALLIANCE") then
							blue = 1;
						end
						local endtime= BGAssist_MapItems[conflicts[timer]].conflictstart + 300;
						local timeleft = endtime - GetTime();
						if (timeleft < 1) then
							BGAssist_Scheduled_MapCheck = endtime; 
						end
						if (not BGAssist_TimersActive or endtime < BGAssist_TimersActive) then
							BGAssist_TimersActive = endtime;
						end
						local timerobj = getglobal("BGAssist_Timers"..timer);
						local text = getglobal("BGAssist_Timers"..timer.."Text");
						timerobj.name = conflicts[timer];
						timerobj.endtime = endtime;
						timerobj:Show();
						timerobj:SetStatusBarColor (red, green, blue);
						timerobj:SetMinMaxValues(0,MAXTIMERVALUE);
						timerobj:SetValue(timeleft);
						text:Show();
						text:SetText(conflicts[timer]);
					else
						local timerobj = getglobal("BGAssist_Timers"..timer);
						local text = getglobal("BGAssist_Timers"..timer.."Text");
						timerobj.name = nil;
						timerobj.endtime = nil;
						timerobj:Hide();
						text:SetText("");
						text:Hide();
					end
				end
				if (timersused) then
					BGAssist_TimersActive = nil;
				end
			end
		end
	else
		for timer = 1, MAXTIMERS, 1 do
			local timerobj = getglobal("BGAssist_Timers"..timer);
			local text = getglobal("BGAssist_Timers"..timer.."Text");
			timerobj:Hide();
			text:Hide();
		end
	end
end

function BGAssist_TimersTitle_OnClick()
	if (arg1 == "RightButton") then
		ToggleDropDownMenu(1, nil, BGAssist_Timers_Menu, "BGAssist_Timers_Menu", 0, 50);
	else
		if (this:GetButtonState() == "PUSHED") then
			this:GetParent():StopMovingOrSizing();
		elseif (not BGAssist_Config.windowlocked) then
			this:GetParent():StartMoving();
		end
	end
end

function BGAssist_Timer_SetTooltip(override)
	if (not override) then
		override = this;
	end
	if (override.name and override.endtime) then
		
		local txt = override.name;
		local timeleft = math.floor(override.endtime - GetTime());
		txt = txt.."\nTime Left: "..timeleft.." seconds.";
		if (timeleft > 60) then
			txt = txt.."\n("..(math.floor(timeleft/6)/10).." minutes)";
		end
		BGAssist_Timers.updateTooltip = TOOLTIP_UPDATE_TIME;
		BGAssist_Timers.tooltipUpdate = override;
		local left = override:GetLeft();
		if (left > 800) then
			GameTooltip:SetOwner(override, "ANCHOR_LEFT");
		else
			GameTooltip:SetOwner(override, "ANCHOR_RIGHT");
		end
		GameTooltip:SetText(txt);
	end
end

function BGAssist_Item_SetTooltip()
	if (this.item and BGAssist_ItemInfo[this.item] and BGAssist_ItemInfo[this.item].name) then
		local txt = BGAssist_ItemInfo[this.item].name.."\nCurrent Count: "..BGAssist_TrackedItems[this.item];
		local left = this:GetLeft();
		if (left > 800) then
			GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		else
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		end
		GameTooltip:SetText(txt);
	end
end

function BGAssist_MenuDropDown_CheckedToggle()
	local mapping = {};
	mapping[MENU_LOCKWINDOW] = "windowlocked";
	mapping[MENU_AUTOREZ] = "noautorez";
	mapping[MENU_AUTOQUEST] = "noautoquest";
	mapping[MENU_AUTOENTER] = "noautoenter";
	mapping[MENU_TIMERSHOW] = "timerhide";
	mapping[MENU_ITEMSHOW] = "itemhide";
	local confoption = mapping[this.value];
	if (confoption) then
		if (BGAssist_Config[confoption]) then
			BGAssist_Config[confoption] = nil;
		else
			BGAssist_Config[confoption] = true;
		end
		BGAssist_Timers_OnShow();
	end
end

function BGAssist_MenuDropDown_Initialize()
	local info = {};
	if (UIDROPDOWNMENU_MENU_LEVEL == 2) then
	else
		info.isTitle = true;
		info.text = "BGAssist "..BGASSIST_VERSION;
		UIDropDownMenu_AddButton(info);

		info = {};
		-- info.keepShownOnClick = true;
		info.func = BGAssist_MenuDropDown_CheckedToggle;

		info.text = MENU_LOCKWINDOW;
		info.checked = nil;
		if (BGAssist_Config.windowlocked) then info.checked = 1; end
		UIDropDownMenu_AddButton(info);

		info.text = MENU_AUTOREZ;
		info.checked = nil;
		if (not BGAssist_Config.noautorez) then info.checked = 1; end
		UIDropDownMenu_AddButton(info);
		
		info.text = MENU_AUTOQUEST;
		info.checked = nil;
		if (not BGAssist_Config.noautoquest) then info.checked = 1; end
		UIDropDownMenu_AddButton(info);
		
		info.text = MENU_AUTOENTER;
		info.checked = nil;
		if (not BGAssist_Config.noautoenter) then info.checked = 1; end
		UIDropDownMenu_AddButton(info);
		
		info.text = MENU_TIMERSHOW;
		info.checked = nil;
		if (not BGAssist_Config.timerhide) then info.checked = 1; end
		UIDropDownMenu_AddButton(info);
		
		info.text = MENU_ITEMSHOW;
		info.checked = nil;
		if (not BGAssist_Config.itemhide) then info.checked = 1; end
		UIDropDownMenu_AddButton(info);
		
	end
end
