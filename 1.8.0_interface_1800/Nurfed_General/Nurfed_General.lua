
local Nurfed_MicroMenu = {
	[1] = {text = NURFEDMICROHEADER, isTitle = 1, level = 2 },
	[2] = {text = NURFEDPAPERDOLL, func = function(x) ToggleCharacter("PaperDollFrame"); end, level = 2 },
	[3] = {text = NURFEDSPELLBOOK, func = function(x) ToggleSpellBook(BOOKTYPE_SPELL) end, level = 2 },
	[4] = {text = NURFEDTALENTS, func = ToggleTalentFrame, level = 2 },
	[5] = {text = NURFEDQUESTLOG, func = ToggleQuestLog, level = 2 },
	[6] = {text = NURFEDFRIENDS, func = ToggleFriendsFrame, level = 2 },
	[7] = {text = NURFEDHELPMENU, func = ToggleHelpFrame, level = 2 },
};

Nurfed_AddOns = {
	[1] = {text = NURFEDADDONHEADER, isTitle = 1, nurfed = 1 },
	[2] = {text = NURFEDOTHERADDONS, isTitle = 1, level = 2 },
};

UIPanelWindows["Nurfed_GeneralOptionsFrame"] = {area = "center", pushable = 0};

local Original_ChatFrame_OnEvent;

Nurfed_GeneralPlayer = nil;

NURFED_GENERAL = 1;
NURFED_TIME = 0;
NURFED_TIME_FREQUENCY = 0.5;
local Nurfed_Time_Elapsed = 0;
local Nurfed_lastmin = 0;

local Nurfed_GeneralCheckBoxes = {};
local Nurfed_GeneralSliders = {};

-----------------------------------------------------------------------------------------------
--				Menu Functions
-----------------------------------------------------------------------------------------------

local function Nurfed_Menu_AddSpacer(level)
	local info = {};
	info.disabled = 1;
	UIDropDownMenu_AddButton(info, level);
end

local function Nurfed_Menu_GetIndex(text)
	local i;
	for i = 1, table.getn(Nurfed_AddOns) do
		if (Nurfed_AddOns[i].text == text) then
			return i;
		end
	end

	return nil;
end

local function Nurfed_Menu_Initialize()
	local info = {};

	if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
		for k, v in Nurfed_AddOns do
			if (v.nurfed == 1) then
				info = {};
				info.text = v.text;
				info.func = v.func;
				info.isTitle = v.isTitle;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info);
			end
		end

		Nurfed_Menu_AddSpacer();

		info = {};
		info.text = NURFEDOTHERADDONS;
		info.value = "Other AddOns";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);

		info = {};
		info.text = NURFEDMICROHEADER;
		info.value = "Micro Buttons";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
		return;
	end

	if (UIDROPDOWNMENU_MENU_VALUE == "Micro Buttons") then
		for k, v in Nurfed_MicroMenu do
			info = {};
			info.text = v.text;
			info.func = v.func;
			info.isTitle = v.isTitle;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info, v.level);
		end
		return;
	end

	if (UIDROPDOWNMENU_MENU_VALUE == "Other AddOns") then
		for k, v in Nurfed_AddOns do
			if (v.nurfed ~= 1) then
				info = {};
				info.text = v.text;
				info.func = v.func;
				info.isTitle = v.isTitle;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info, v.level);
			end
		end
		return;
	end
end

function Nurfed_AddMenuItem(text, func, nurfed)
	local index = Nurfed_Menu_GetIndex(text);
	local found = (index ~= nil);
	if (nil == index) then
		index = table.getn(Nurfed_AddOns) + 1;
		table.setn(Nurfed_AddOns, index);
		Nurfed_AddOns[index] = {};
		Nurfed_AddOns[index].text = text;
		Nurfed_AddOns[index].func = func;
		if (nurfed == 1) then
			Nurfed_AddOns[index].nurfed = 1;
		else
			Nurfed_AddOns[index].level = 2;
		end
	end
end

-----------------------------------------------------------------------------------------------
--				Nurfed Repair Functions
-----------------------------------------------------------------------------------------------

local function Nurfed_Repair()
	local repairbill = 0;
	local repairAllCost, canRepair = GetRepairAllCost();
	local money = GetMoney();
	local g = math.floor(money / COPPER_PER_GOLD);

	if ( canRepair and g >= Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepairGold ) then
		repairbill = repairbill + repairAllCost;
		RepairAllItems();
	end
	if (Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepairInv == 1) then
		ShowRepairCursor();
		for bag = 0,4,1 do
			for slot = 1, GetContainerNumSlots(bag) , 1 do
				local hasCooldown, repairCost = GameTooltip:SetBagItem(bag,slot);
				if (InRepairMode() and (repairCost and repairCost > 0)) then
					UseContainerItem(bag,slot);
					repairbill = repairbill + repairCost;
				end
			end
		end
		HideRepairCursor();
	end
	if (repairbill > 0) then
		local gold = floor(repairbill / (COPPER_PER_SILVER * SILVER_PER_GOLD));
		local silver = floor((repairbill - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
		local copper = mod(repairbill, COPPER_PER_SILVER);
		DEFAULT_CHAT_FRAME:AddMessage("|cffffffffSpent|r |c00ffff66"..gold.."g|r |c00c0c0c0"..silver.."s|r |c00cc9900"..copper.."c|r |cffffffffOn Repairs.|r");
	end
end

local function Nurfed_LinkFrame(dButton, pFrame)
	getglobal(pFrame):ClearAllPoints();
	getglobal(pFrame):SetPoint("TOPLEFT", dButton, "TOPRIGHT");
end

-----------------------------------------------------------------------------------------------
--				Nurfed Chat Events
-----------------------------------------------------------------------------------------------

local function Nurfed_AddMessage(this, msg, r, g, b, id)
	local text = "";

	if msg == nil then msg="The value was nil"; end

	if (Nurfed_GeneralConfig[Nurfed_GeneralPlayer]) then
		if(Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeStamps == 1) then
			local hour, minute = GetGameTime();
			local second = GetTime() - NURFED_TIME;
			hour = hour + Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeOffset;
			if( hour > 23 ) then
				hour = hour - 24;
			elseif( hour < 0 ) then
				hour = 24 + hour;
			end
			if (Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeAMPM == 1) then
				if (hour >= 12) then
					hour = hour - 12;
				end
				if (hour == 0) then
					hour = 12;
				end
			end
			local timestamp = format("%d:%02d:%02d", hour, minute, second);
			text = text.."|cffffffff"..timestamp.."|r ";
		end
		if (string.find(msg, "%[Raid%]")) then
			local numRaidMembers = GetNumRaidMembers();
			local name, subgroup, class;
			for i=1, numRaidMembers do
				name, _, subgroup, _, class, _, _, _, _ = GetRaidRosterInfo(i);
				if (name == arg2) then
					break;
				end
			end
			if (Nurfed_GeneralConfig[Nurfed_GeneralPlayer].RaidGroup == 1) then
				text = text.."["..subgroup.."] ";
			end
			if (Nurfed_GeneralConfig[Nurfed_GeneralPlayer].RaidClass == 1) then
				text = text.."["..class.."] ";
			end
		end

		if (text ~= "") then
			local newmsg = text..msg;
			this:Original_AddMessage(newmsg, r, g, b, id);
		else
			this:Original_AddMessage(msg, r, g, b, id);
		end
	else
		this:Original_AddMessage(msg, r, g, b, id);
	end
end

local function Nurfed_ChatFrame_OnEvent(event)
	Original_ChatFrame_OnEvent(event);
	if(not this.Original_AddMessage) then
		this.Original_AddMessage = this.AddMessage;
		this.AddMessage = Nurfed_AddMessage;
	end
end

local function Nurfed_LockButtonPOS()
	Nurfed_LockButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(Nurfed_GeneralConfig[Nurfed_GeneralPlayer].MenuPos)), (80 * sin(Nurfed_GeneralConfig[Nurfed_GeneralPlayer].MenuPos)) - 52);
end

local function Nurfed_GeneralOptionsInit()
	SecondsToTimeAbbrev = Nurfed_SecondsToTimeAbbrev;
	--QUEST_FADING_ENABLE = nil;
	--Nurfed_LinkFrame(dQuestWatchDragButton:GetName(), QuestWatchFrame:GetName(), "RIGHT");
	Nurfed_LockButtonPOS();

	if (NURFED_LOCKALL == nil) then
		NURFED_LOCKALL = 1;
	end
	if (NURFED_LOCKALL == 1) then
		Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedlocked");
	else
		Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedunlocked");
	end

	if (IsAddOnLoaded("AutoBar")) then
		Nurfed_AddMenuItem("Autobar Config", AutoBar_EditConfig);
	end
	if (IsAddOnLoaded("Sct")) then
		Nurfed_AddMenuItem("SCT Menu", SCT_showMenu);
	end
	if (IsAddOnLoaded("AF_ToolTip")) then
		Nurfed_AddMenuItem("AF_ToolTip Menu", aftt_toggleFrames);
	end
	--[[
	if (TIPBUDDY_VERSION) then
		Nurfed_AddMenuItem("TipBuddy Menu", TipBuddy_ToggleOptionsFrame);
	end
	]]

--Checks
	--general
	Nurfed_GeneralCheckBoxes = {
		[1] = { text = "Auto Repair", option = "AutoRepair" },
		[2] = { text = "Auto Repair Inventory", option = "AutoRepairInv" },
		[3] = { text = "Ping Warning", option = "PingWarning" },
		[4] = { text = "Only Show Available Skills", option = "TrainerAvailable" },
		[5] = { text = "Chat Timestamps", option = "TimeStamps" },
		[6] = { text = "12 Hour Format", option = "TimeAMPM" },
		[7] = { text = "Raid Group Number", option = "RaidGroup", align = "right" },
		[8] = { text = "Raid Class", option = "RaidClass", align = "right" },
	};

--Sliders
	Nurfed_GeneralSliders = {
		[1] = { text = "Lock Button POS", option = "MenuPos", min = 1, max = 360, step = 1, func = Nurfed_LockButtonPOS },
		[2] = { text = "Auto Repair Limit", option = "AutoRepairGold", min = 5, max = 150, step = 1 },
		[3] = { text = "Timestamp Offset", option = "TimeOffset", min = -12, max = 12, step = 1 },
	};

	Nurfed_GeneralOptionsFrameTitle:SetText(NURFEDGENERAL.."\nVers. "..Nurfed_GeneralConfig.Version);
end

function Nurfed_GeneralOnLoad ()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("MERCHANT_SHOW");
	this:RegisterEvent("MINIMAP_PING");
	this:RegisterEvent("TRAINER_SHOW");

	Original_ChatFrame_OnEvent = ChatFrame_OnEvent;
	ChatFrame_OnEvent = Nurfed_ChatFrame_OnEvent;
end

function Nurfed_GeneralOnEvent ()
	if (event == "VARIABLES_LOADED") then
		if( not Nurfed_GeneralConfig or not Nurfed_GeneralConfig.Version) then
			Nurfed_GeneralConfig = {};
		end

		Nurfed_GeneralConfig.Version = "09.15.2005";
		Nurfed_AddOns[1].text = NURFEDADDONHEADER.."\nVers. "..Nurfed_GeneralConfig.Version;

		local realm = GetCVar("realmName");
		local player = UnitName("player");
		Nurfed_GeneralPlayer = player.." - "..realm;

		if (not Nurfed_GeneralConfig[Nurfed_GeneralPlayer]) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer] = {};
		end

		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepair) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepair = 1;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepairInv) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepairInv = 1;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepairGold) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepairGold = 20;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].PingWarning) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].PingWarning = 1;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TrainerAvailable) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TrainerAvailable = 1;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeStamps) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeStamps = 1;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeOffset) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeOffset = 0;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeAMPM) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TimeAMPM = 0;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].RaidGroup) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].RaidGroup = 0;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].RaidClass) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].RaidClass = 0;
		end
		if ( not Nurfed_GeneralConfig[Nurfed_GeneralPlayer].MenuPos) then
			Nurfed_GeneralConfig[Nurfed_GeneralPlayer].MenuPos = 231;
		end

		Nurfed_GeneralOptionsInit();
		Nurfed_Time_Elapsed = 0;
		Nurfed_AddMenuItem(NURFEDGENERAL, Nurfed_GeneralOptionsMenu, 1);
	end

	if (event == "MERCHANT_SHOW") then
		if (Nurfed_GeneralConfig[Nurfed_GeneralPlayer].AutoRepair == 1) then
			Nurfed_Repair();
		end
		return;
	end

	if (event == "TRAINER_SHOW") then
		if(Nurfed_GeneralConfig[Nurfed_GeneralPlayer].TrainerAvailable == 1) then
			SetTrainerServiceTypeFilter("unavailable",0);
		end
		return;
	end
end

-----------------------------------------------------------------------------------------------
--				Buff Timers
-----------------------------------------------------------------------------------------------

function Nurfed_SecondsToTimeAbbrev(seconds)
	local time = "";
	local tempTime;
	local tempTime2;
	if ( seconds > 86400  ) then
		tempTime = ceil(seconds / 86400);
		time = tempTime.." "..DAY_ONELETTER_ABBR;
		return time;
	end
	if ( seconds > 3600  ) then
		tempTime = ceil(seconds / 3600);
		time = tempTime.." "..HOUR_ONELETTER_ABBR;
		return time;
	end
	if ( seconds > 60  ) then
		tempTime = floor(seconds / 60);
		tempTime2 = floor(seconds-(tempTime)*60);
		time = format("%02d:%02d", tempTime, tempTime2);
		return time;
	end
	time = format("00:%02d", seconds);
	return time;
end

-----------------------------------------------------------------------------------------------
--				Nurfed General
-----------------------------------------------------------------------------------------------

function Nurfed_MenuDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Nurfed_Menu_Initialize, "MENU");
end

function Nurfed_DragFrameStart(frame)
	if (NURFED_LOCKALL == 0) then
		frame:StartMoving();
	end
end

function Nurfed_DragFrameStop(frame)
	frame:StopMovingOrSizing();
end

function Nurfed_GeneralOnUpdate(arg1)
	Nurfed_Time_Elapsed = Nurfed_Time_Elapsed + arg1;
	if (Nurfed_Time_Elapsed > NURFED_TIME_FREQUENCY) then
		local hour, minute = GetGameTime();
		if (minute ~= Nurfed_lastmin) then
			NURFED_TIME = GetTime();
			Nurfed_lastmin = minute;
		end
	end
end

function Nurfed_GeneralOptionsMenu()
	if (Nurfed_GeneralOptionsFrame:IsVisible()) then
		HideUIPanel(Nurfed_GeneralOptionsFrame);
	else
		ShowUIPanel(Nurfed_GeneralOptionsFrame);
	end
end

-----------------------------------------------------------------------------------------------
--				Nurfed Lock Button
-----------------------------------------------------------------------------------------------

function Nurfed_LockButtonOnClick(button)
	if (Nurfed_LockButtonDropDown:IsVisible()) then
		Nurfed_LockButtonDropDown:Hide();
	end

	if (button == "LeftButton") then
		Nurfed_ToggleLock();
	elseif (button == "RightButton") then
		GameTooltip:Hide();
		ToggleDropDownMenu(1, nil, Nurfed_LockButtonDropDown, "Nurfed_LockButton", 0, 0);
		local listFrame = getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL);
		if (UIDROPDOWNMENU_MENU_LEVEL == 1) then
			listFrame:ClearAllPoints();
			listFrame:SetPoint("TOPRIGHT", "Nurfed_LockButton", "BOTTOMLEFT", 0, 0);
		end
	end
end

function Nurfed_ToggleLock()
	if (NURFED_LOCKALL == 1) then
		NURFED_LOCKALL = 0;
		Nurfed_LockButton:SetChecked(0);
		PlaySound("igMainMenuQuit");
		GameTooltip:SetText("Left Click - Lock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
		Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedunlocked");
	else
		NURFED_LOCKALL = 1;
		Nurfed_LockButton:SetChecked(1);
		PlaySound("igMainMenuOption");
		GameTooltip:SetText("Left Click - Unlock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
		Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedlocked");
	end
end

function Nurfed_LockButtonOnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	if (this:GetChecked()) then
		GameTooltip:SetText("Left Click - Unlock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
	else
		GameTooltip:SetText("Left Click - Lock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
	end
end

---------------------------------------------------------------------------
--			Nurfed General CheckBox Functions
---------------------------------------------------------------------------

function Nurfed_GeneralCheckBoxOnShow()
	local id = this:GetID();
	local option = Nurfed_GeneralCheckBoxes[id].option;
	local value = Nurfed_GeneralConfig[Nurfed_GeneralPlayer][option];
	local align = Nurfed_GeneralCheckBoxes[id].align;
	if (align == "right") then
		getglobal("Nurfed_GeneralOptionCheck"..id.."Text"):ClearAllPoints();
		getglobal("Nurfed_GeneralOptionCheck"..id.."Text"):SetPoint("RIGHT", "Nurfed_GeneralOptionCheck"..id, "LEFT", 0, 0);
	end
	getglobal("Nurfed_GeneralOptionCheck"..id.."Text"):SetText(Nurfed_GeneralCheckBoxes[id].text);
	this:SetChecked(value);
end

function Nurfed_GeneralCheckBoxOnClick()
	local id = this:GetID();
	local func = Nurfed_GeneralCheckBoxes[id].func;
	local arg = Nurfed_GeneralCheckBoxes[id].arg;
	local value = Nurfed_GeneralCheckBoxes[id].value;
	local option = Nurfed_GeneralCheckBoxes[id].option;
	if (Nurfed_GeneralConfig[Nurfed_GeneralPlayer][option] == 1) then
		Nurfed_GeneralConfig[Nurfed_GeneralPlayer][option] = 0;
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		Nurfed_GeneralConfig[Nurfed_GeneralPlayer][option] = 1;
		PlaySound("igMainMenuOptionCheckBoxOn");
	end
	if (func) then
		if (arg) then
			func(arg);
		else
			func();
		end
	end
end

---------------------------------------------------------------------------
--			Nurfed General Slider Functions
---------------------------------------------------------------------------

function Nurfed_GeneralSliderOnShow()
	local id = this:GetID();
	getglobal("Nurfed_GeneralSlider"..id.."Text"):SetText(Nurfed_GeneralSliders[id].text);
	getglobal("Nurfed_GeneralSlider"..id.."Low"):SetText(Nurfed_GeneralSliders[id].min);
	getglobal("Nurfed_GeneralSlider"..id.."High"):SetText(Nurfed_GeneralSliders[id].max);
	this:SetMinMaxValues(Nurfed_GeneralSliders[id].min, Nurfed_GeneralSliders[id].max);
	this:SetValueStep(Nurfed_GeneralSliders[id].step);
	this:SetValue(Nurfed_GeneralConfig[Nurfed_GeneralPlayer][Nurfed_GeneralSliders[id].option]);
	getglobal("Nurfed_GeneralSlider"..id.."SliderValue"):SetText(format("%.2f", this:GetValue()));
end

function Nurfed_GeneralSliderOnValueChanged()
	if (this.tip ~=1) then return; end
	local id = this:GetID();
	getglobal(this:GetName().."SliderValue"):SetText(format("%.2f", this:GetValue()));
	local func = Nurfed_GeneralSliders[id].func;
	local option = Nurfed_GeneralSliders[id].option;
	Nurfed_GeneralConfig[Nurfed_GeneralPlayer][option] = this:GetValue();
	if (func) then
		func();
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
end
