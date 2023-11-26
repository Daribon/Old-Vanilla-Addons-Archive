--
-- TotemBar
--
-- Creates a (normally hidden) set of 20 buttons above buttons 4-8 
-- on the ActionBar that load up with all the Shaman totem spells
-- (with initial and minor support for Warlock and Mage spells)
--
-- Show the bar by mousing over the area, and pressing the shift key.
-- Hide the bar again by moving the mouse out of the area.
-- Spells can be cast or dragged from the TotemBar like normal
--
-- Author: Marc aka Saien on Hyjal
-- http://64.168.251.69/wow
--
-- Changes:
-- 2005.03.24
--   TOC update to 1300
-- 2005.03.09
--   Fixed localization problem with the keybindings
-- 2005.03.05
--   Updated TOC to 4216
-- 2005.02.20
--   Updated toc to 4211
-- 2005.02.06
--   Fixed bad function calls in Bindings.
-- 2005.01.25
--   Added show or hide on combat
-- 2005.01.16
--   Updated Warlock listing with Bear's list.
-- 2005.01.15:
--   Bugfix on the click through
--   Added hunter spells
-- 2005.01.14:
--   Movable, drag the new titlebar
--   Columns can be swapped around, leftclick on the titlebar to move left, rightclick to move right
--   /totembar reset to well, reset
--   /totembar show [col] to always show that column, or if none given, all of them
--   /totembar hide [col] to always hide that column, or if none given, all of them

TOTEMBAR_VERSION = "2005.03.24" -- Notice the cleverly disguised date.

TotemBar_ShowViaKeypress = nil; -- global
local TotemBar_Enabled = nil;
local TOTEMBAR_UPDATETIME = 0.1;
local TotemBar_MouseInBar = 0;
local TotemBar_LastUpdate = 0;
local TotemBar_Player = nil;
local TotemBar_Show = {};
local TotemBar_SpellList = {};
local TotemBar_InMotion = nil;
local TotemBar_Config_Loaded = nil;
local TotemBar_InCombat = nil;
local TotemBar_OnHateList = nil;

BINDING_HEADER_TOTEMBAR	= "Totem Bar";
BINDING_NAME_TOTEMBAR_HOLD = "Hold to Show";
BINDING_NAME_TOTEMBAR_TOGGLE = "Toggle on/off";

local function TotemBar_SetSpellList()
	local class = UnitClass("player");
	local race = UnitRace("player");
	local level = UnitLevel("player");

	if (class == "Shaman") then
		TotemBar_SpellList = {
			-- Air
			"Nature Resistance Totem",
			"Windwall Totem", 
			"Windfury Totem",
			"Grace of Air Totem",
			"Grounding Totem",
			-- Earth
			"Stoneclaw Totem", 
			"Earthbind Totem",
			"Tremor Totem",
			"Strength of Earth Totem",
			"Stoneskin Totem",
			-- Water
			"Fire Resistance Totem",
			"Poison Cleansing Totem",
			"Disease Cleansing Totem",
			"Healing Stream Totem",
			"Mana Spring Totem",
			-- Fire
			"Frost Resistance Totem",
			"Flametongue Totem", 
			"Magma Totem",
			"Fire Nova Totem",
			"Searing Totem",
		};
	elseif (class == "Warlock") then
		--[[
		TotemBar_SpellList = {
			"","","","","",
			"Curse of Tongues",
			"Curse of Recklessness",
			"Curse of Weakness",
			"Curse of Agony",
			"", -- Blank spot to give room for pet bar
			"Curse of Doom",
			"Curse of Exhaustion",
			"Curse of Shadow",
			"Curse of the Elements",
			"", -- Blank spot to give room for pet bar
			"","","","","",
		};
		]]
		TotemBar_SpellList = {
			-- Summons
			"Summon Imp",
			"Summon Voidwalker",
			"Summon Succubus",
			"Summon Felhunter",
			"Inferno Summon",
			-- Conjuring Items
			"Create Healthstone (Minor)",
			"Create Soulstone (Minor)",
			"Create Firestone (Lesser)",
			"Create Spellstone",
			"Ritual of Summoning",
			-- Curses - Bar 1
			"Curse of Weakness",
			"Curse of Agony",
			"Curse of Recklessness",
			"Curse of Exhaustion", -- Is this one real?
			-- And yes, its real. It's from talents.
			-- Affliction, Tier 5
			"Curse of Idiocy",
			-- Curses - Bar 2
			"Curse of Tongues",
			"Curse of the Elements",
			"Curse of Shadow",
			"Curse of Doom",
			"Ritual of Doom",
		};
		-- Healthstones
		if (level >= 58) then
			TotemBar_SpellList[6] = "Create Healthstone (Major)";
		elseif (level >= 46) then
			TotemBar_SpellList[6] = "Create Healthstone (Greater)";
		elseif (level >= 34) then
			TotemBar_SpellList[6] = "Create Healthstone";
		elseif (level >= 22) then
			TotemBar_SpellList[6] = "Create Healthstone (Lesser)";
		end
		-- Soulstones
		if (level >= 60) then
			TotemBar_SpellList[7] = "Create Soulstone (Major)";
		elseif (level >= 50) then
			TotemBar_SpellList[7] = "Create Soulstone (Greater)";
		elseif (level >= 40) then
			TotemBar_SpellList[7] = "Create Soulstone";
		elseif (level >= 30) then
			TotemBar_SpellList[7] = "Create Soulstone (Lesser)";
		end
		-- Firestones
		if (level >= 56) then
			TotemBar_SpellList[8] = "Create Firestone (Major)";
		elseif (level >= 46) then
			TotemBar_SpellList[8] = "Create Firestone (Greater)";
		elseif (level >= 36) then
			TotemBar_SpellList[8] = "Create Firestone";
		end
		-- Spellstones
		if (level >= 60) then
			TotemBar_SpellList[9] = "Create Spellstone (Major)";
		elseif (level >= 48) then
			TotemBar_SpellList[9] = "Create Spellstone (Greater)";
		end
	elseif (class == "Mage") then
		TotemBar_SpellList = {
			"Conjure Food",
			"Conjure Water",
			"","","",
			"Teleport: Thunder Bluff",
			"Teleport: Undercity",
			"Teleport: Orgrimmar",
			"","",
			"Portal: Thunder Bluff",
			"Portal: Undercity",
			"Portal: Orgrimmar",
			"","",
			"Conjure Mana Agate",
			"Conjure Mana Jade",
			"Conjure Mana Citrine",
			"Conjure Mana Ruby",
			"",
		};
		if (race == "Human" or race == "Gnome") then
			TotemBar_SpellList[6]  = "Teleport: Darnassus";
			TotemBar_SpellList[7]  = "Teleport: Ironforge";
			TotemBar_SpellList[8] = "Teleport: Stormwind";
			TotemBar_SpellList[11] = "Portal: Darnassus";
			TotemBar_SpellList[12] = "Portal: Ironforge";
			TotemBar_SpellList[13] = "Portal: Stormwind";
			TotemBar_SpellList[14] = "Alliance are dirty filthy creatures";
		end
	elseif (class == "Hunter") then
		TotemBar_SpellList = {
			-- Aspects
			"Aspect of the Monkey",
			"Aspect of the Hawk",
			"Aspect of the Cheetah",
			"Aspect of the Beast",
			"Aspect of the Wild",
			-- Stings
			"Serpent Sting",
			"Scorpid Sting",
			"Viper Sting",
			"","",
			-- Shots
			"Concussive Shot",
			"Arcane Shot",
			"Aimed Shot",
			"Distracting Shot",
			"Multi-Shot",
			-- Traps
			"Immolation Trap",
			"Freezing Trap",
			"Frost Trap",
			"Explosive Trap",
			"",
		};
		if (level >= 40) then
			TotemBar_SpellList[3] = "Aspect of the Pack";
		end
	end
end

local function TotemBar_Button_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	if (this.spellID) then
		local start, duration, enable = GetSpellCooldown (this.spellID, BOOKTYPE_SPELL);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
	else
		cooldown:Hide();
	end
end

local function TotemBar_ConfigInit()
	if (not TotemBar_Config_Loaded or not TotemBar_Player) then
		return;
	end
	if (not TotemBar_Config) then
		TotemBar_Config = {};
	end
	if (not TotemBar_Config[TotemBar_Player]) then
		TotemBar_Config[TotemBar_Player] = {};
	end
end

local function TotemBar_DecodeOrder()
	if (not TotemBar_Config[TotemBar_Player].order) then
		return {1, 2, 3, 4};
	else
		return TotemBar_Config[TotemBar_Player].order;
	end
end

local function TotemBar_EncodeOrder(order)
	if (order == {1,2,3,4}) then
		TotemBar_Config[TotemBar_Player].order = nil;
	else
		TotemBar_Config[TotemBar_Player].order = order;
	end
end

local function TotemBar_GetLeftColumn()
	local order = TotemBar_DecodeOrder();
	local frame = getglobal("TotemBar_Title"..order[1]);
	return frame;
end

local function TotemBar_SetupCol(order)
	local oneidx = 1;
	local workingidx = 1;
	local workingframe = nil;
	if (not order) then
		order = TotemBar_DecodeOrder();
	end
	while (order[oneidx] ~= 1) do 
		oneidx = oneidx+1;
	end
	workingframe = getglobal("TotemBar_Title"..order[1]);
	workingframe:ClearAllPoints();
	workingframe:SetPoint("TOPLEFT","TotemBar_Move","TOPLEFT",0,0);
	workingidx = 2;
	while (workingidx <= 4) do
		workingframe = getglobal("TotemBar_Title"..order[workingidx]);
		workingframe:ClearAllPoints();
		workingframe:SetPoint("LEFT","TotemBar_Title"..order[workingidx-1],"RIGHT",0,0);
		workingidx = workingidx + 1;
	end
end

local function TotemBar_SetTextDisplay()
	if (TotemBar_MouseInBar or TotemBar_InMotion or TotemBar_ShowViaKeypress or (TotemBar_Show[1] and TotemBar_Show[2] and TotemBar_Show[3] and TotemBar_Show[4]) or (TotemBar_Config[TotemBar_Player].OnCombat and (TotemBar_InCombat or TotemBar_OnHateList))) then
		TotemBar_MoveText:SetText("Totem Bar ("..TOTEMBAR_VERSION..")");
		TotemBar_MoveTextLayer:Show();
	else
		TotemBar_MoveText:SetText("");
		TotemBar_MoveTextLayer:Hide();
	end
end

local function TotemBar_Reset()
	TotemBar_Move:StopMovingOrSizing();
	TotemBar_Move:ClearAllPoints();
	TotemBar_Move:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",173,323);
	TotemBar_Config[TotemBar_Player].order = nil;
	TotemBar_SetupCol();
	TotemBar_SetTextDisplay();
end

local function TotemBar_SlashCmd(msg)
	msg = string.lower(msg)
	local firstword = nil;
	local restwords = nil;
	local idx = string.find(msg," ");
	if (idx) then
		firstword = string.sub(msg,1,idx-1);
		restwords = string.sub(msg,idx+1);
	else
		firstword = msg;
	end

	if (firstword == "reset") then
		TotemBar_Reset();
	elseif (firstword == "combat" or firstword == "oncombat") then
		if (not restwords or restwords == "") then
			TotemBar_Config[TotemBar_Player].OnCombat = nil;
		elseif (restwords and restwords == "show") then
			TotemBar_Config[TotemBar_Player].OnCombat = "SHOW";
		elseif (restwords and restwords == "hide") then
			TotemBar_Config[TotemBar_Player].OnCombat = "HIDE";
		end
		if (TotemBar_Config[TotemBar_Player].OnCombat) then
			DEFAULT_CHAT_FRAME:AddMessage("Totem Bar: At Combat: "..string.sub(TotemBar_Config[TotemBar_Player].OnCombat,1,1)..string.lower(string.sub(TotemBar_Config[TotemBar_Player].OnCombat,2)).." the Totem Bar");
		else
			DEFAULT_CHAT_FRAME:AddMessage("Totem Bar: At Combat: Do nothing");
		end
	elseif (firstword == "show" or firstword == "hide") then
		local num = nil;
		if (restwords) then 
			num = tonumber(restwords);
		end
		if (num and num > 0 and num <= 4) then
			if (firstword == "show") then
				TotemBar_Show[num] = 1;
			else
				TotemBar_Show[num] = nil;
			end
		elseif (firstword == "show") then
			TotemBar_Show[1] = 1;
			TotemBar_Show[2] = 1;
			TotemBar_Show[3] = 1;
			TotemBar_Show[4] = 1;
		else
			TotemBar_Show[1] = nil;
			TotemBar_Show[2] = nil;
			TotemBar_Show[3] = nil;
			TotemBar_Show[4] = nil;
		end
		TotemBar_BarShowHide ();
	elseif ((firstword == "toggle" or firstword == "key") and restwords) then
		if (restwords == "shift") then
			TotemBar_Config[TotemBar_Player].ToggleKey = "SHIFT";
		elseif (restwords == "control" or restwords == "cntrl") then
			TotemBar_Config[TotemBar_Player].ToggleKey = "CONTROL";
		elseif (restwords == "alt") then
			TotemBar_Config[TotemBar_Player].ToggleKey = "ALT";
		elseif (restwords == "none") then
			TotemBar_Config[TotemBar_Player].ToggleKey = "NONE";
		elseif (restwords == "never") then
			TotemBar_Config[TotemBar_Player].ToggleKey = "NEVER";
		end
		DEFAULT_CHAT_FRAME:AddMessage("Totem Bar: Toggle key set to "..string.sub(TotemBar_Config[TotemBar_Player].ToggleKey,1,1)..string.lower(string.sub(TotemBar_Config[TotemBar_Player].ToggleKey,2)));
	else
		DEFAULT_CHAT_FRAME:AddMessage("/totembar (or /totem)");
		DEFAULT_CHAT_FRAME:AddMessage("/totembar reset -- Reset the four columns to default location.");
		DEFAULT_CHAT_FRAME:AddMessage("/totembar show [col] -- Show all or column.");
		DEFAULT_CHAT_FRAME:AddMessage("/totembar hide [col] -- Hide all or column.");
		DEFAULT_CHAT_FRAME:AddMessage("/totembar key [shift:control:alt:none:never] -- Set the meta key used to show Totem Bar on mouse-hover. (None means none needed, Never means never show)");
		DEFAULT_CHAT_FRAME:AddMessage("/totembar combat [show:hide] -- Show or Hide or Do Nothing when you enter combat.");

	end
end

local function TotemBar_SetSpell(spellID,idx)
	while (idx > 20) do idx = idx - 20; end
	local button = getglobal("TotemBar_Button"..idx);
	if (button) then
		TotemBar_Enabled = 1;
		button.spellID = spellID;
		local texture = GetSpellTexture(spellID, BOOKTYPE_SPELL);
		local icon = getglobal(button:GetName().."Icon");
		local normalTexture = getglobal(button:GetName().."NormalTexture");
		icon:SetTexture(texture);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		if (TotemBar_MouseInBar == 1) then
			this:Show();
		end
	end
end

local function TotemBar_SpellSearch()
	local id = 1;
	local spellName;
	local subSpellName;
	local secondSpellName;
	local secondSubSpellName;
	local idx;
	local taggedSpell;
	spellName, subSpellName = GetSpellName(id,BOOKTYPE_SPELL);
	while (spellName) do
		if (spellName) then
			for idx,taggedSpell in TotemBar_SpellList do
				if (taggedSpell == spellName) then
					secondSpellName, secondSubSpellName = GetSpellName(id+1,BOOKTYPE_SPELL);
					while (spellName == secondSpellName) do
						id = id + 1;
						secondSpellName, secondSubSpellName = GetSpellName(id+1,BOOKTYPE_SPELL);
					end
					spellName, subSpellName = GetSpellName(id,BOOKTYPE_SPELL);
					TotemBar_SetSpell(id,idx);
				end
			end
		end
		id = id + 1;
		spellName, subSpellName = GetSpellName(id,BOOKTYPE_SPELL);
	end
end

function TotemBar_Title_OnClick()
	local order = TotemBar_DecodeOrder();
	local WorkingCol = 1;
	while (order[WorkingCol] ~= this:GetID()) do
		WorkingCol = WorkingCol + 1;
	end
	local temp = order[WorkingCol];
	if (arg1 == "LeftButton" and this:GetID() == order[1]) then
		order[1] = order[4];
		order[4] = temp;
	elseif (arg1 == "RightButton" and this:GetID() == order[4]) then
		order[4] = order[1];
		order[1] = temp;
	elseif (arg1 == "LeftButton") then
		order[WorkingCol] = order[WorkingCol - 1];
		order[WorkingCol - 1] = temp;
	elseif (arg1 == "RightButton") then
		order[WorkingCol] = order[WorkingCol + 1];
		order[WorkingCol + 1] = temp;
	end
	TotemBar_EncodeOrder(order);
	TotemBar_SetupCol();
end


function TotemBar_OnLoad()
	RegisterForSave("TotemBar_Config");
	
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("SPELLS_CHANGED");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	
	SLASH_TOTEMBAR1 = "/totembar";
	SLASH_TOTEMBAR2 = "/totem";
	SlashCmdList["TOTEMBAR"] = function (msg)
		TotemBar_SlashCmd(msg);
	end

	TotemBar_MouseInBar = nil;
	DEFAULT_CHAT_FRAME:AddMessage("TotemBar ("..TOTEMBAR_VERSION..") loaded. '/totembar' to show commands.");
end

function TotemBar_OnUpdate(elapsed)
	if (not TotemBar_Enabled or not TotemBar_Move:GetLeft()) then return; end
	local CurrentInBar = nil;
	local ToggleKeyPressed = nil;
	TotemBar_LastUpdate = TotemBar_LastUpdate+elapsed;
	if (TotemBar_LastUpdate > TOTEMBAR_UPDATETIME) then
		TotemBar_LastUpdate = 0;
		local xPos, yPos = GetCursorPosition();
		if (TotemBar_Title1 and TotemBar_Title1:GetLeft()) then 
			local TotemBar1_Left = TotemBar_Title1:GetLeft() * UIParent:GetScale();
			local TotemBar1_Right = TotemBar_Title1:GetRight() * UIParent:GetScale();
			local TotemBar1_Top = TotemBar_Title1:GetTop() * UIParent:GetScale();
			local TotemBar1_Bottom = (TotemBar_Title1:GetBottom()-210) * UIParent:GetScale();
			if (yPos <= TotemBar1_Top and yPos >= TotemBar1_Bottom and 
			    xPos <= TotemBar1_Right and xPos >= TotemBar1_Left) then
				CurrentInBar = 1;
			end
		end

		if (TotemBar_Title2 and TotemBar_Title2:GetLeft()) then 
			local TotemBar2_Left = TotemBar_Title2:GetLeft() * UIParent:GetScale();
			local TotemBar2_Right = TotemBar_Title2:GetRight() * UIParent:GetScale();
			local TotemBar2_Top = TotemBar_Title2:GetTop() * UIParent:GetScale();
			local TotemBar2_Bottom = (TotemBar_Title2:GetBottom()-210) * UIParent:GetScale();
			if (yPos <= TotemBar2_Top and yPos >= TotemBar2_Bottom and 
			    xPos <= TotemBar2_Right and xPos >= TotemBar2_Left) then
				CurrentInBar = 1;
			end
		end

		if (TotemBar_Title3 and TotemBar_Title3:GetLeft()) then
			local TotemBar3_Left = TotemBar_Title3:GetLeft() * UIParent:GetScale();
			local TotemBar3_Right = TotemBar_Title3:GetRight() * UIParent:GetScale();
			local TotemBar3_Top = TotemBar_Title3:GetTop() * UIParent:GetScale();
			local TotemBar3_Bottom = (TotemBar_Title3:GetBottom()-210) * UIParent:GetScale();
			if (yPos <= TotemBar3_Top and yPos >= TotemBar3_Bottom and 
			    xPos <= TotemBar3_Right and xPos >= TotemBar3_Left) then
				CurrentInBar = 1;
			end
		end

		if (TotemBar_Title4 and TotemBar_Title4:GetLeft()) then 
			local TotemBar4_Left = TotemBar_Title4:GetLeft() * UIParent:GetScale();
			local TotemBar4_Right = TotemBar_Title4:GetRight() * UIParent:GetScale();
			local TotemBar4_Top = TotemBar_Title4:GetTop() * UIParent:GetScale();
			local TotemBar4_Bottom = (TotemBar_Title4:GetBottom()-210) * UIParent:GetScale();
			if (yPos <= TotemBar4_Top and yPos >= TotemBar4_Bottom and 
			    xPos <= TotemBar4_Right and xPos >= TotemBar4_Left) then
				CurrentInBar = 1;
			end
		end
		if (IsShiftKeyDown() and (not TotemBar_Config[TotemBar_Player].ToggleKey or TotemBar_Config[TotemBar_Player].ToggleKey == "SHIFT")) then
			ToggleKeyPressed = 1;
		elseif (IsControlKeyDown() and TotemBar_Config[TotemBar_Player].ToggleKey == "CONTROL") then
			ToggleKeyPressed = 1;
		elseif (IsAltKeyDown() and TotemBar_Config[TotemBar_Player].ToggleKey == "ALT") then
			ToggleKeyPressed = 1;
		elseif (TotemBar_Config[TotemBar_Player].ToggleKey == "NONE") then
			ToggleKeyPressed = 1;
		end

		if (ToggleKeyPressed and not ChatFrameEditBox:IsVisible() and CurrentInBar == 1 and not TotemBar_MouseInBar) then
			TotemBar_MouseInBar = 1;
			TotemBar_BarShowHide ();
		elseif (not CurrentInBar and TotemBar_MouseInBar) then
			TotemBar_MouseInBar = nil;
			TotemBar_BarShowHide ();
		end
	end
end

function TotemBar_BarShowHide(show)
	if (not TotemBar_Title1 or not TotemBar_Title2 or not TotemBar_Title3 or not TotemBar_Title4) then
		-- Stupid Blizzard. Objects not always created at OnLoad
		return;
	end
	if (not show) then
		if (not TotemBar_Enabled) then 
			show = 0; 
		elseif (TotemBar_MouseInBar or TotemBar_InMotion or TotemBar_ShowViaKeypress) then
			show = 1;
		elseif (TotemBar_Config[TotemBar_Player].OnCombat and (TotemBar_InCombat or TotemBar_OnHateList)) then
			if (TotemBar_Config[TotemBar_Player].OnCombat == "SHOW") then
				show = 1;
			elseif (TotemBar_Config[TotemBar_Player].OnCombat == "HIDE") then
				show = 0;
			end
		end
	end
	if (show == 0 and not TotemBar_Show[1] and not TotemBar_Show[2] and not TotemBar_Show[3] and not TotemBar_Show[4]) then
		TotemBar_Move:Hide();
		return;
	end
	TotemBar_SetTextDisplay();
	if (show == 1 or TotemBar_Show[1]) then
		TotemBar_Title1:Show();
		for i = 1, 5 do
			local button = getglobal("TotemBar_Button"..i);
			if (button.spellID) then
				button:Show();
			else
				button:Hide();
			end
		end
	else
		TotemBar_Title1:Hide();
	end
	if (show == 1 or TotemBar_Show[2]) then
		TotemBar_Title2:Show();
		for i = 6, 10 do
			local button = getglobal("TotemBar_Button"..i);
			if (button.spellID) then
				button:Show();
			else
				button:Hide();
			end
		end
	else
		TotemBar_Title2:Hide();
	end
	if (show == 1 or TotemBar_Show[3]) then
		TotemBar_Title3:Show();
		for i = 11, 15 do
			local button = getglobal("TotemBar_Button"..i);
			if (button.spellID) then
				button:Show();
			else
				button:Hide();
			end
		end
	else
		TotemBar_Title3:Hide();
	end
	if (show == 1 or TotemBar_Show[4]) then
		TotemBar_Title4:Show();
		for i = 16, 20 do
			local button = getglobal("TotemBar_Button"..i);
			if (button.spellID) then
				button:Show();
			else
				button:Hide();
			end
		end
	else
		TotemBar_Title4:Hide();
	end
end

function TotemBar_OnEvent(event)
	if (event == "SPELLS_CHANGED") then
		TotemBar_SpellSearch();
	elseif (event == "PLAYER_ENTER_COMBAT") then
		TotemBar_InCombat = 1;
		TotemBar_BarShowHide ();
	elseif (event == "PLAYER_LEAVE_COMBAT") then
		TotemBar_InCombat = nil;
		TotemBar_BarShowHide ();
	elseif (event == "PLAYER_REGEN_DISABLED") then
		TotemBar_OnHateList = 1;
		TotemBar_BarShowHide ();
	elseif (event == "PLAYER_REGEN_ENABLED") then
		TotemBar_OnHateList = nil;
		TotemBar_BarShowHide ();
	elseif (event == "UNIT_NAME_UPDATE" and arg1 == "player") then
		local playerName = UnitName("player");
		if (playerName ~= UKNOWNBEING and playerName ~= "Unknown Entity") then
			if (not TotemBar_Player) then
				TotemBar_Player = playerName;
			end
			if (TotemBar_Player and TotemBar_Config_Loaded) then
				TotemBar_ConfigInit();
				TotemBar_SetSpellList();
				TotemBar_SpellSearch();
				TotemBar_SetupCol();
				TotemBar_BarShowHide ();
			end
		end
	elseif (event == "VARIABLES_LOADED") then
		TotemBar_Config_Loaded = 1;
		if (TotemBar_Player and TotemBar_Config_Loaded) then
			TotemBar_ConfigInit();
			TotemBar_SetSpellList();
			TotemBar_SpellSearch();
			TotemBar_SetupCol();
			TotemBar_BarShowHide ();
		end
		
	end
end

function TotemBar_Button_SetTooltip()
	if (this.spellID) then
		local spellName, subSpellName = GetSpellName(this.spellID,BOOKTYPE_SPELL);
		if ( GetCVar("UberTooltips") == "1" ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, this);
			GameTooltip:SetSpell(this.spellID, BOOKTYPE_SPELL);
			--if (subSpellName and subSpellName ~= "") then
			--	GameTooltipTextRight1:SetText("("..subSpellName..")");
			--end
		else
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
			local txt;
			if (subSpellName and subSpellName ~= "") then
				txt = spellName.." ("..subSpellName..")";
			else
				txt = spellName;
			end
			GameTooltip:SetText(txt);
		end
	end
end

function TotemBar_Button_OnLoad()
	this.spellID = nil;

	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterForDrag("LeftButton");
end

function TotemBar_Button_Update()
	if (this.spellID) then
		local num = this:GetID();
		if (TotemBar_MouseInBar == 1 or TotemBar_InMotion or TotemBar_ShowViaKeypress or (TotemBar_Config[TotemBar_Player].OnCombat and (TotemBar_InCombat or TotemBar_OnHateList)) or
			(num <= 5 and TotemBar_Show[1]) or
			(num >= 6 and num <= 10 and TotemBar_Show[2]) or
			(num >= 11 and num <= 15 and TotemBar_Show[3]) or
			(num >= 16 and TotemBar_Show[4])) then
			this:Show();
			TotemBar_Button_UpdateCooldown();
		else
			this:Hide();
			local cooldown = getglobal(this:GetName().."Cooldown");
			cooldown:Hide();
		end
	else
		this:Hide();
	end

end

function TotemBar_Button_OnClick()
	if (this.spellID) then
		CastSpell(this.spellID, BOOKTYPE_SPELL);
	end
end

function TotemBar_Button_OnDrag()
	if (this.spellID) then
		PickupSpell(this.spellID, BOOKTYPE_SPELL);
	end
end

function TotemBar_Title_DragStart()
	TotemBar_InMotion = 1;
	TotemBar_Move:StartMoving();
end

function TotemBar_Title_DragStop()
	TotemBar_InMotion = nil;
	TotemBar_Move:StopMovingOrSizing();
	TotemBar_BarShowHide ();
end

