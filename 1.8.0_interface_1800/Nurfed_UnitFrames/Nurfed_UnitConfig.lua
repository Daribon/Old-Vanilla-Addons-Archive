
---------------------------------------------------------------------------
--			Blizz Unit Frame Functions
---------------------------------------------------------------------------

local function Nurfed_DisablePlayer()
	--** Blizz Player Frame Events
	PlayerFrame:UnregisterEvent("UNIT_LEVEL");
	PlayerFrame:UnregisterEvent("UNIT_COMBAT");
	PlayerFrame:UnregisterEvent("UNIT_SPELLMISS");
	PlayerFrame:UnregisterEvent("UNIT_PVP_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_MAXMANA");
	PlayerFrame:UnregisterEvent("PLAYER_ENTER_COMBAT");
	PlayerFrame:UnregisterEvent("PLAYER_LEAVE_COMBAT");
	PlayerFrame:UnregisterEvent("PLAYER_UPDATE_RESTING");
	PlayerFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED");
	PlayerFrame:UnregisterEvent("PARTY_LEADER_CHANGED");
	PlayerFrame:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED");
	PlayerFrame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	PlayerFrame:UnregisterEvent("PLAYER_REGEN_DISABLED");
	PlayerFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
	PlayerFrameHealthBar:UnregisterEvent("UNIT_HEALTH");
	PlayerFrameHealthBar:UnregisterEvent("UNIT_MAXHEALTH");
	-- ManaBar Events
	PlayerFrameManaBar:UnregisterEvent("UNIT_MANA");
	PlayerFrameManaBar:UnregisterEvent("UNIT_RAGE");
	PlayerFrameManaBar:UnregisterEvent("UNIT_FOCUS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_ENERGY");
	PlayerFrameManaBar:UnregisterEvent("UNIT_HAPPINESS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXMANA");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXRAGE");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXFOCUS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXENERGY");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXHAPPINESS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_DISPLAYPOWER");
	-- UnitFrame Events
	PlayerFrame:UnregisterEvent("UNIT_NAME_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_DISPLAYPOWER");
	PlayerFrame:Hide();
end

local function Nurfed_DisablePet()
	--** Blizz Pet Frame Events
	PetFrame:UnregisterEvent("UNIT_COMBAT");
	PetFrame:UnregisterEvent("UNIT_SPELLMISS");
	PetFrame:UnregisterEvent("UNIT_AURA");
	PetFrame:UnregisterEvent("PLAYER_PET_CHANGED");
	PetFrame:UnregisterEvent("PET_ATTACK_START");
	PetFrame:UnregisterEvent("PET_ATTACK_STOP");
	PetFrame:UnregisterEvent("UNIT_HAPPINESS");
	PetFrame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	PetFrame:Hide();
end

local function Nurfed_DisableTarget()
	--** Blizz Target Frame Events
	TargetFrame:UnregisterEvent("UNIT_HEALTH");
	TargetFrame:UnregisterEvent("UNIT_LEVEL");
	TargetFrame:UnregisterEvent("UNIT_FACTION");
	TargetFrame:UnregisterEvent("UNIT_DYNAMIC_FLAGS");
	TargetFrame:UnregisterEvent("UNIT_CLASSIFICATION_CHANGED");
	TargetFrame:UnregisterEvent("PLAYER_PVPLEVEL_CHANGED");
	TargetFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
	TargetFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED");
	TargetFrame:UnregisterEvent("PARTY_LEADER_CHANGED");
	TargetFrame:UnregisterEvent("PARTY_MEMBER_ENABLE");
	TargetFrame:UnregisterEvent("PARTY_MEMBER_DISABLE");
	TargetFrame:UnregisterEvent("UNIT_AURA");
	TargetFrame:UnregisterEvent("PLAYER_FLAGS_CHANGED");
	ComboFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
	ComboFrame:UnregisterEvent("PLAYER_COMBO_POINTS");
	TargetFrameHealthBar:UnregisterEvent("UNIT_HEALTH");
	TargetFrameHealthBar:UnregisterEvent("UNIT_MAXHEALTH");
	-- ManaBar Events
	TargetFrameManaBar:UnregisterEvent("UNIT_MANA");
	TargetFrameManaBar:UnregisterEvent("UNIT_RAGE");
	TargetFrameManaBar:UnregisterEvent("UNIT_FOCUS");
	TargetFrameManaBar:UnregisterEvent("UNIT_ENERGY");
	TargetFrameManaBar:UnregisterEvent("UNIT_HAPPINESS");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXMANA");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXRAGE");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXFOCUS");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXENERGY");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXHAPPINESS");
	TargetFrameManaBar:UnregisterEvent("UNIT_DISPLAYPOWER");
	-- UnitFrame Events
	TargetFrame:UnregisterEvent("UNIT_NAME_UPDATE");
	TargetFrame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	TargetFrame:UnregisterEvent("UNIT_DISPLAYPOWER");
	TargetFrame:Hide();
end

local function Nurfed_DisableParty()
	--** Blizz Party Events
	for num = 1, 4 do
		frame = getglobal("PartyMemberFrame"..num);
		HealthBar = getglobal("PartyMemberFrame"..num.."HealthBar");
		ManaBar = getglobal("PartyMemberFrame"..num.."ManaBar");
		frame:UnregisterEvent("PARTY_MEMBERS_CHANGED");
		frame:UnregisterEvent("PARTY_LEADER_CHANGED");
		frame:UnregisterEvent("PARTY_MEMBER_ENABLE");
		frame:UnregisterEvent("PARTY_MEMBER_DISABLE");
		frame:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED");
		frame:UnregisterEvent("UNIT_PVP_UPDATE");
		frame:UnregisterEvent("UNIT_AURA");
		-- HealthBar Events
		HealthBar:UnregisterEvent("UNIT_HEALTH");
		HealthBar:UnregisterEvent("UNIT_MAXHEALTH");
		-- ManaBar Events
		ManaBar:UnregisterEvent("UNIT_MANA");
		ManaBar:UnregisterEvent("UNIT_RAGE");
		ManaBar:UnregisterEvent("UNIT_FOCUS");
		ManaBar:UnregisterEvent("UNIT_ENERGY");
		ManaBar:UnregisterEvent("UNIT_HAPPINESS");
		ManaBar:UnregisterEvent("UNIT_MAXMANA");
		ManaBar:UnregisterEvent("UNIT_MAXRAGE");
		ManaBar:UnregisterEvent("UNIT_MAXFOCUS");
		ManaBar:UnregisterEvent("UNIT_MAXENERGY");
		ManaBar:UnregisterEvent("UNIT_MAXHAPPINESS");
		ManaBar:UnregisterEvent("UNIT_DISPLAYPOWER");
		-- UnitFrame Events
		frame:UnregisterEvent("UNIT_NAME_UPDATE");
		frame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
		frame:UnregisterEvent("UNIT_DISPLAYPOWER");
	end
	HidePartyFrame();
end

local function Nurfed_SetBackdropColor(unit)
	local bginfo = {};
	bginfo = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"];
	local bdinfo = {};
	bdinfo = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"];
	if (unit == "party") then
		for i=1, 4 do
			getglobal("Nurfed_"..unit..i.."Backdrop"):SetBackdropColor(bginfo.r, bginfo.g, bginfo.b, bginfo.a);
			getglobal("Nurfed_"..unit..i.."Backdrop"):SetBackdropBorderColor(bdinfo.r, bdinfo.g, bdinfo.b, bdinfo.a);
		end
		getglobal("Nurfed_"..unit.."Backdrop"):SetBackdropColor(bginfo.r, bginfo.g, bginfo.b, bginfo.a);
		getglobal("Nurfed_"..unit.."Backdrop"):SetBackdropBorderColor(bdinfo.r, bdinfo.g, bdinfo.b, bdinfo.a);
	else
		getglobal("Nurfed_"..unit.."Backdrop"):SetBackdropColor(bginfo.r, bginfo.g, bginfo.b, bginfo.a);
		getglobal("Nurfed_"..unit.."Backdrop"):SetBackdropBorderColor(bdinfo.r, bdinfo.g, bdinfo.b, bdinfo.a);
	end
end

local function Nurfed_UpdateBarTextures()
	local textured = Nurfed_UnitConfig[Nurfed_UnitPlayer].texturedBars;
	for _,unit in Nurfed_Units do
		local healthbar = getglobal("Nurfed_"..unit.."HealthBarTex");
		local manabar = getglobal("Nurfed_"..unit.."ManaBarTex");
		local healthbarBG = getglobal("Nurfed_"..unit.."HealthBarBG");
		healthbarBG:SetVertexColor(1, 0, 0, 0.25);
		if (textured == 1) then
			healthbar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
			if (manabar) then
				manabar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
			end
			if (unit == "player") then
				Nurfed_playerXPBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
			end
		else
			healthbar:SetTexture("Interface\\AddOns\\Nurfed_UnitFrames\\images\\nurfed_statusbar"..textured..".tga");
			if (manabar) then
				manabar:SetTexture("Interface\\AddOns\\Nurfed_UnitFrames\\images\\nurfed_statusbar"..textured..".tga");
			end
			if (unit == "player") then
				Nurfed_playerXPBarTex:SetTexture("Interface\\AddOns\\Nurfed_UnitFrames\\images\\nurfed_statusbar"..textured..".tga");
			end
		end
	end
end

local function Nurfed_UpdateBarTextureStyle()
	Nurfed_UnitDropDown5Idx = this:GetID();
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown5, this:GetID());
	Nurfed_UnitConfig[Nurfed_UnitPlayer].texturedBars = this:GetID();
	Nurfed_UpdateBarTextures();
end

local function Nurfed_UpdateUnitBorder()
	local border = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBorder;
	for _,unit in Nurfed_Units do
		if (unit ~= "targettarget" and unit ~= "targettargettarget" and unit ~= "pettarget") then
			local frame = getglobal("Nurfed_"..unit.."Backdrop");
			if (frame and border == 1) then
				frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
				if (Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"]) then
					Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].a = 0;
				end
			elseif (frame and border == 2) then
				frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }});
				if (Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"]) then
					Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].a = 1;
				end
			elseif (frame and border == 3) then
				frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }});
				if (Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"]) then
					Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].a = 1;
				end
			end
		end
		if (not string.find(unit, "party")) then
			Nurfed_SetBackdropColor(unit);
		end
	end
	if (border == 1) then
		getglobal("Nurfed_partyBackdrop"):SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
		Nurfed_UnitConfig[Nurfed_UnitPlayer]["partyBorderColor"].a = 0;
	elseif (border == 2) then
		getglobal("Nurfed_partyBackdrop"):SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }});
		Nurfed_UnitConfig[Nurfed_UnitPlayer]["partyBorderColor"].a = 1;
	elseif (border == 3) then
		getglobal("Nurfed_partyBackdrop"):SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }});
		Nurfed_UnitConfig[Nurfed_UnitPlayer]["partyBorderColor"].a = 1;
	end
	Nurfed_SetBackdropColor("party");
end

local function Nurfed_UpdateStatusText()
	local align = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitStatusText;
	for _,unit in Nurfed_Units do
		local healthbartext = getglobal("Nurfed_"..unit.."HealthBarText");
		local manabartext = getglobal("Nurfed_"..unit.."ManaBarText");
		local xpbartext = getglobal("Nurfed_"..unit.."XPBarText");
		healthbartext:SetWidth(getglobal("Nurfed_"..unit.."HealthBar"):GetWidth());
		healthbartext:SetHeight(getglobal("Nurfed_"..unit.."HealthBar"):GetHeight());
		if (manabartext) then
			manabartext:SetWidth(getglobal("Nurfed_"..unit.."ManaBar"):GetWidth());
			manabartext:SetHeight(getglobal("Nurfed_"..unit.."ManaBar"):GetHeight());
		end
		if (xpbartext) then
			xpbartext:SetWidth(getglobal("Nurfed_"..unit.."XPBar"):GetWidth());
			xpbartext:SetHeight(getglobal("Nurfed_"..unit.."XPBar"):GetHeight());
		end
		if (align == 1) then
			healthbartext:SetJustifyH("LEFT");
			if (manabartext) then
				manabartext:SetJustifyH("LEFT");
			end
			if (xpbartext) then
				xpbartext:SetJustifyH("LEFT");
			end
		elseif (align == 2) then
			healthbartext:SetJustifyH("RIGHT");
			if (manabartext) then
				manabartext:SetJustifyH("RIGHT");
			end
			if (xpbartext) then
				xpbartext:SetJustifyH("RIGHT");
			end
		else
			healthbartext:SetJustifyH("CENTER");
			if (manabartext) then
				manabartext:SetJustifyH("CENTER");
			end
			if (xpbartext) then
				xpbartext:SetJustifyH("CENTER");
			end
		end
	end
end

local function Nurfed_UpdateUnitLayout(unit)
	local layoutID = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitLayout;
	local unitFrame = getglobal("Nurfed_"..unit);
	local unitItem, relativeItem;
	for k, v in Nurfed_UnitLayouts["Layout"..layoutID] do
		unitItem = getglobal("Nurfed_"..unit..k);
		if (unitItem) then
			if (v == false) then
				unitItem:Hide();
			else
				if (v.shown) then
					unitItem:Show();
				end
				unitItem:ClearAllPoints();
				if (v.relativeto) then
					relativeItem = getglobal("Nurfed_"..unit..v.relativeto);
					unitItem:SetPoint(v.point, relativeItem, v.relativepoint, v.x, v.y);
				else
					unitItem:SetPoint(v.point, unitFrame, v.relativepoint, v.x, v.y);
				end
				if (v.height) then
					unitItem:SetHeight(v.height);
					unitItem:SetWidth(v.width);
				end
				if (v.align) then
					unitItem:SetJustifyH(v.align);
				end
				if (v.textheight) then
					unitItem:SetTextHeight(v.textheight);
				end
			end
		end
	end
	if (string.find(unit, "party")) then
		Nurfed_SetScale("party");
	else
		Nurfed_SetScale(unit);
	end
end

local function Nurfed_UpdateUnitBorderStyle()
	Nurfed_UnitDropDown6Idx = this:GetID();
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown6, this:GetID());
	Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBorder = this:GetID();
	Nurfed_UpdateUnitBorder();
end

local function Nurfed_UpdateUnitStatusTextStyle()
	Nurfed_UnitDropDown7Idx = this:GetID();
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown7, this:GetID());
	Nurfed_UnitConfig[Nurfed_UnitPlayer].unitStatusText = this:GetID();
	Nurfed_UpdateStatusText();
end

local function Nurfed_UpdateUnitLayoutStyle()
	Nurfed_UnitDropDown8Idx = this:GetID();
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown8, this:GetID());
	Nurfed_UnitConfig[Nurfed_UnitPlayer].unitLayout = this:GetID();
	Nurfed_UpdateUnitLayout("player");
	Nurfed_UpdateUnitLayout("target");
	Nurfed_UpdateUnitLayout("pet");
	for i=1, 4 do
		Nurfed_UpdateUnitLayout("party"..i);
	end
end

local function Nurfed_UpdateBarText()
	local showtext = Nurfed_UnitConfig[Nurfed_UnitPlayer].showTextOnBars;
	local showxptext = Nurfed_UnitConfig[Nurfed_UnitPlayer].showXPTextOnBars;
	for _,unit in Nurfed_Units do
		local healthbartext = getglobal("Nurfed_"..unit.."HealthBarText");
		local manabartext = getglobal("Nurfed_"..unit.."ManaBarText");
		local xpbartext = getglobal("Nurfed_"..unit.."XPBarText");
		if (showtext == 1) then
			healthbartext:Show();
			if (manabartext) then
				manabartext:Show();
			end
		else
			healthbartext:Hide();
			if (manabartext) then
				manabartext:Hide();
			end
		end
		if (xpbartext) then
			if (showxptext == 1) then
				xpbartext:Show();
			else
				xpbartext:Hide();
			end
		end
		Nurfed_UpdateHealth(unit);
	end
end

local function Nurfed_UnitToTUpdate()
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer]["targettargettarget"] == 1) then
		Nurfed_targettarget:SetWidth(70);
		Nurfed_targettargetBG:SetWidth(67);
		Nurfed_targettargetName:SetWidth(65);
		Nurfed_targettargetHealthBar:SetWidth(65);
		Nurfed_targettargetManaBar:SetWidth(65);
		Nurfed_targettargetHealthText:Hide();
		Nurfed_targettargetManaText:Hide();
	else
		Nurfed_targettarget:SetWidth(145);
		Nurfed_targettargetBG:SetWidth(142);
		Nurfed_targettargetName:SetWidth(140);
		Nurfed_targettargetHealthBar:SetWidth(100);
		Nurfed_targettargetManaBar:SetWidth(100);
		Nurfed_targettargetHealthText:Show();
		Nurfed_targettargetManaText:Show();
	end
end

local function Nurfed_UpdateUnitScale(unit, value)
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Scale"] ~= value) then
		Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Scale"] = value;
		Nurfed_SetScale(unit);
		Nurfed_UnitResetPos(unit);
	end
end

local function Nurfed_UpdateLowHPWarn(value)
	Nurfed_UnitConfig[Nurfed_UnitPlayer]["partyLowHealthWarnPerc"] = value;
end

local function Nurfed_UpdateHealthBar(unit)
	local healthbar = getglobal("Nurfed_"..unit.."HealthBar");
	if (strsub(unit,1,5) == "party") then
		unitcheck = "party";
	else
		unitcheck = unit;
	end
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 1) then
	else
	end
	if (UnitExists(unit)) then
		Nurfed_UpdateHealth(unit);
	end
end

local function Nurfed_UpdateHPStyle(unit, id)
	if (id == 1) then
		Nurfed_UnitDropDown1Idx = this:GetID();
		UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown1, this:GetID());
	elseif (id == 2) then
		Nurfed_UnitDropDown2Idx = this:GetID();
		UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown2, this:GetID());
	elseif (id == 3) then
		Nurfed_UnitDropDown3Idx = this:GetID();
		UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown3, this:GetID());
	elseif (id == 4) then
		Nurfed_UnitDropDown4Idx = this:GetID();
		UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown4, this:GetID());
	end
	Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."HPStyle"] = this:GetID();
	if (unit == "party") then
		for i=1, 4 do
			Nurfed_UpdateHealthBar("party"..i);
			Nurfed_UpdateHealthBar("partypet"..i);
		end
	else
		Nurfed_UpdateHealthBar(unit);
	end
end

local function Nurfed_PartyRefreshAuras(unit)
	if (unit == "party") then
		for id = 1, 4 do
			Nurfed_RefreshAuras("party"..id);
		end
		Nurfed_UpdatePartyLocation();
	elseif (unit == "partypet") then
		for id = 1, 4 do
			Nurfed_RefreshAuras("partypet"..id);
		end
	end

end

local Nurfed_UnitOptionTabs = {
	[1] = NURFEDUNITS_OPTIONS_TABS_GENERAL,
	[2] = NURFEDUNITS_OPTIONS_TABS_PLAYER,
	[3] = NURFEDUNITS_OPTIONS_TABS_PARTY,
	[4] = NURFEDUNITS_OPTIONS_TABS_PET,
	[5] = NURFEDUNITS_OPTIONS_TABS_TARGET,
};

local Nurfed_UnitCheckBoxes = {};
local Nurfed_UnitSliders = {};
local Nurfed_UnitColorSwatches = {};
local Nurfed_UnitColorSwatchesFunc = {};
local Nurfed_UnitDropDowns = {};

local function Nurfed_UnitOptionsInit()
--Checks
	--general
	Nurfed_UnitCheckBoxes = {
		[1] = { text = "Lock Unit Frames", option = "unitsLocked" },
		[2] = { text = "Only Class Buffs", option = "unitClassBuffs", func = Nurfed_PartyRefreshAuras, arg = "party" },
		[3] = { text = "Show HP/MP Text", option = "showTextOnBars", func = Nurfed_UpdateBarText },
		[4] = { text = "Show XP Text", option = "showXPTextOnBars", func = Nurfed_UpdateBarText },
		[18] = { text = "Red Current HP", option = "unitCurrentRedHP", func = Nurfed_UpdateBarText },
		[20] = { text = "Show Max HP on Bars", option = "unitBarMaxHP", func = Nurfed_UpdateBarText },
		[21] = { text = "Force Current HP on Bars", option = "unitForceBarCurrent", func = Nurfed_UpdateBarText },
	--player
		[5] = { text = "Show Combat Text", option = "playerCombatFeedBack" },
		[19] = { text = "Show Player DeBuffs", option = "playerDeBuffs", func = Nurfed_RefreshAuras, arg = "player" },
	--party
		[6] = { text = "Grow Party Frame Up", option = "partyGrowUp", func = Nurfed_UpdatePartyLocation },
		[7] = { text = "Show Party Buffs", option = "partyBuffs", func = Nurfed_PartyRefreshAuras, arg = "party" },
		[8] = { text = "Show Party Debuffs", option = "partyDeBuffs", func = Nurfed_PartyRefreshAuras, arg = "party" },
		[9] = { text = "Show Party Pets", option = "partyShowPets", func = Nurfed_UpdatePartyPets },
		[10] = { text = "Show Party Pet Debuffs", option = "partyPetShowDeBuffs", func = Nurfed_PartyRefreshAuras, arg = "partypet" },
		[11] = { text = "Party Low Health Warning", option = "partyLowHealthWarn", align = "right" },
		[12] = { text = "Seperate Party Frame", option = "partySeperate", func = Nurfed_UpdatePartyLocation },
		[13] = { text = "Show Party Loot", option = "partyShowLoot", func = Nurfed_PartySize },
	--pet
		[14] = { text = "Show Pet's Target", option = "pettarget" },
	--target
		[15] = { text = "Show Target of Target", option = "targettarget" },
		[16] = { text = "Show Target of Target's Target", option = "targettargettarget", func = Nurfed_UnitToTUpdate },
		[17] = { text = "Preserve Target in Combat", option = "targetPreserve" },
	};

--Sliders
	Nurfed_UnitSliders = {
		[1] = { text = "Scale Player", option = "playerScale", unit = "player", min = 0.5, max = 1.5, step = 0.01, func = Nurfed_UpdateUnitScale },
		[2] = { text = "Scale Party", option = "partyScale", unit = "party", min = 0.5, max = 1.5, step = 0.01, func = Nurfed_UpdateUnitScale },
		[3] = { text = "Low HP Warning", option = "partyLowHealthWarnPerc", min = 10, max = 75, step = 1, func = Nurfed_UpdateLowHPWarn },
		[4] = { text = "Scale Pet", option = "petScale", unit = "pet", min = 0.5, max = 1.5, step = 0.01, func = Nurfed_UpdateUnitScale },
		[5] = { text = "Scale Target", option = "targetScale", unit = "target", min = 0.5, max = 1.5, step = 0.01, func = Nurfed_UpdateUnitScale },
	};

--ColorSwatches
	Nurfed_UnitColorSwatches = {
		[1] = { text = "Player BG Color", option = "playerColor", unit = "player" },
		[2] = { text = "Player Border Color", option = "playerBorderColor", unit = "player", border = 1 },
		[3] = { text = "Party BG Color", option = "partyColor", unit = "party" },
		[4] = { text = "Party Border Color", option = "partyBorderColor", unit = "party", border = 1 },
		[5] = { text = "Pet BG Color", option = "petColor", unit = "pet" },
		[6] = { text = "Pet Border Color", option = "petBorderColor", unit = "pet", border = 1 },
		[7] = { text = "Target BG Color", option = "targetColor", unit = "target" },
		[8] = { text = "Target Border Color", option = "targetBorderColor", unit = "target", border = 1 },
	};

--DropDowns
	Nurfed_UnitDropDowns = {
		[1] = { text = "Health", text1 = "None", text2 = "Missing", text3 = "Current", unit = "player" },
		[2] = { text = "Health", text1 = "None", text2 = "Missing", text3 = "Current", unit = "party" },
		[3] = { text = "Health", text1 = "None", text2 = "Missing", text3 = "Current", unit = "pet" },
		[4] = { text = "Health", text1 = "None", text2 = "Missing", text3 = "Current", unit = "target" },
		[5] = { text = "Bar Texture", text1 = "None", text2 = "Style 1", text3 = "Style 2", text4 = "Style 3", text5 = "Style 4" },
		[6] = { text = "Unit Border", text1 = "None", text2 = "Rounded", text3 = "Square" },
		[7] = { text = "Status Text", text1 = "Left", text2 = "Right", text3 = "Center" },
		[8] = { text = "Unit Layout", text1 = "Layout 1", text2 = "Layout 2", text3 = "Layout 3" },
	};
end

local function Nurfed_UnitFramesInit()
	Nurfed_DisablePlayer();
	Nurfed_DisablePet();
	Nurfed_DisableTarget();
	Nurfed_DisableParty();

	Nurfed_UpdateBarTextures();
	Nurfed_UpdateBarText();
	Nurfed_UpdateUnitBorder();
	Nurfed_UpdateUnitLayout("player");
	Nurfed_UpdateUnitLayout("target");
	Nurfed_UpdateUnitLayout("pet");
	for i=1, 4 do
		Nurfed_UpdateUnitLayout("party"..i);
	end
	Nurfed_UpdateStatusText();

	Nurfed_UnitOptionsFrameTitle:SetText(NURFEDUNITFRAMES.."\nVers. "..Nurfed_UnitConfig.Version);
end

local Nurfed_UnitDropDown1Idx = 1;
Nurfed_UnitPlayer = nil;

UIPanelWindows["Nurfed_UnitOptionsFrame"] = {area = "center", pushable = 0};

function Nurfed_UnitConfig_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	
	-- Register our slash command
	SLASH_NURFEDUNITS1 = "/nurfedunits";
	SLASH_NURFEDUNITS2 = "/nunits";
	SlashCmdList["NURFEDUNITS"] = function(msg)
		NurfedUnits_SlashCommandHandler(msg);
	end
end

function Nurfed_UnitConfig_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		if( not Nurfed_UnitConfig or not Nurfed_UnitConfig.Version) then
			Nurfed_UnitConfig = {};
		end

		Nurfed_UnitConfig.Version = "10.12.2005";

		local realm = GetCVar("realmName");
		local player = UnitName("player");
		Nurfed_UnitPlayer = player.." - "..realm;

		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer]) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer] = {};
		end

		--general options
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitsLocked) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitsLocked = 1;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].texturedBars) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].texturedBars = 2;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].showTextOnBars) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].showTextOnBars = 0;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].showXPTextOnBars) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].showXPTextOnBars = 0;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBorder) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBorder = 2;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitClassBuffs) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitClassBuffs = 0;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitStatusText) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitStatusText = 1;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitLayout) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitLayout = 1;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitCurrentRedHP) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitCurrentRedHP = 1;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBarMaxHP) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBarMaxHP = 1;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].unitForceBarCurrent) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].unitForceBarCurrent = 1;
		end

		--player options
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].playerColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].playerColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].playerBorderColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].playerBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].playerHPStyle) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].playerHPStyle = 2;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].playerCombatFeedBack) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].playerCombatFeedBack = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].playerScale) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].playerScale =0.8;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].playerDeBuffs) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].playerDeBuffs = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].playerReset) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].playerReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 20, y = -30 };
		end

		--party options
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBorderColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if(not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyLowHealthWarn) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyLowHealthWarn = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyLowHealthWarnPerc) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyLowHealthWarnPerc = 30;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyHPStyle) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyHPStyle = 2;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBuffs) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBuffs = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyDeBuffs) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyDeBuffs = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyScale) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyScale = 0.8;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyGrowUp) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyGrowUp = 0;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partySeperate) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partySeperate = 0;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyShowLoot) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyShowLoot = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyShowPets) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyShowPets = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyPetShowDeBuffs) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyPetShowDeBuffs = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].partyReset) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].partyReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 20, y = -200 };
		end

		--pet options
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].petColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].petColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].petBorderColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].petBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].pettargetColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].pettargetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].pettargetBorderColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].pettargetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].petHPStyle) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].petHPStyle = 2;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].pettarget) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].pettarget = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].petScale) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].petScale = 0.8;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].petReset) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].petReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 20, y = -90 };
		end

		--target options
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targetColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targetBorderColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargetColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargetBorderColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargettargetColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargettargetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargettargetBorderColor) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargettargetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targettarget) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targettarget = 1;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargettarget) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targettargettarget = 1;
		end
		if ( not Nurfed_UnitConfig[Nurfed_UnitPlayer].targetScale) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targetScale = 0.8;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targetHPStyle) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targetHPStyle = 2;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targetPreserve) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targetPreserve = 1;
		end
		if (not Nurfed_UnitConfig[Nurfed_UnitPlayer].targetReset) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer].targetReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 200, y = -50 };
		end

		if(NURFED_GENERAL == 1) then
			Nurfed_AddMenuItem(NURFEDUNITFRAMES, Nurfed_UnitFramesMenu, 1);
		end

		Nurfed_UnitFramesInit();
		Nurfed_UnitOptionsInit();
	end

	if (event =="PLAYER_ENTERING_WORLD") then
		Nurfed_SetScale("player");
		Nurfed_SetScale("target");
		Nurfed_SetScale("party");
		Nurfed_SetScale("pet");
		Nurfed_UnitToTUpdate();
		Nurfed_UpdateHealthBar("player");
		Nurfed_UpdateHealthBar("target");
		Nurfed_UpdateHealthBar("pet");
		for i=1, 4 do
			Nurfed_UpdateHealthBar("party"..i);
			Nurfed_UpdateHealthBar("partypet"..i);
		end
	end
end

function Nurfed_UnitFramesMenu()
	if (Nurfed_UnitOptionsFrame:IsVisible()) then
		HideUIPanel(Nurfed_UnitOptionsFrame);
	else
		ShowUIPanel(Nurfed_UnitOptionsFrame);
	end
end

function Nurfed_SetScale(unit)
	local scale = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Scale"];
	if (unit == "party") then
		getglobal("Nurfed_party"):SetScale(scale);
		for i=1, 4 do
			getglobal("Nurfed_party"..i):SetScale(scale);
			getglobal("Nurfed_partypet"..i):SetScale(scale);
		end
	else
		getglobal("Nurfed_"..unit):SetScale(scale);
		if (unit == "pet") then
			getglobal("Nurfed_pettarget"):SetScale(scale);
		end
		if (unit == "target") then
			getglobal("Nurfed_targettarget"):SetScale(scale);
			getglobal("Nurfed_targettargettarget"):SetScale(scale);
			getglobal("Nurfed_targetClass"):SetScale(scale);
		end
	end
end

---------------------------------------------------------------------------
--			Nurfed Unit Slider Functions
---------------------------------------------------------------------------

function Nurfed_UnitSliderOnShow()
	local id = this:GetID();
	getglobal("Nurfed_UnitSlider"..id.."Text"):SetText(Nurfed_UnitSliders[id].text);
	getglobal("Nurfed_UnitSlider"..id.."Low"):SetText(Nurfed_UnitSliders[id].min);
	getglobal("Nurfed_UnitSlider"..id.."High"):SetText(Nurfed_UnitSliders[id].max);
	this:SetMinMaxValues(Nurfed_UnitSliders[id].min, Nurfed_UnitSliders[id].max);
	this:SetValueStep(Nurfed_UnitSliders[id].step);
	this:SetValue(Nurfed_UnitConfig[Nurfed_UnitPlayer][Nurfed_UnitSliders[id].option]);
	getglobal("Nurfed_UnitSlider"..id.."SliderValue"):SetText(format("%.2f", this:GetValue()));
end

function Nurfed_UnitSliderOnValueChanged()
	if (this.tip ~=1) then return; end
	local id = this:GetID();
	getglobal(this:GetName().."SliderValue"):SetText(format("%.2f", this:GetValue()));
	local func = Nurfed_UnitSliders[id].func;
	local unit = Nurfed_UnitSliders[id].unit;
	if (func) then
		if (unit) then
			func(unit, this:GetValue());
		else
			func(this:GetValue());
		end
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
end

---------------------------------------------------------------------------
--			Nurfed Unit DropDown Functions
---------------------------------------------------------------------------

function Nurfed_UnitDropDown1_Init()
	local id = 1;
	local unit = Nurfed_UnitDropDowns[id].unit;
	local style = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."HPStyle"];
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown1Idx = 1;
	local info;
	for i=1, 3 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateHPStyle(unit, id) end;
		if (style == i) then
			Nurfed_UnitDropDown1Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown1,Nurfed_UnitDropDown1Idx);
end

function Nurfed_UnitDropDown2_Init()
	local id = 2;
	local unit = Nurfed_UnitDropDowns[id].unit;
	local style = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."HPStyle"];
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown2Idx = 1;
	local info;
	for i=1, 3 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateHPStyle(unit, id) end;
		if (style == i) then
			Nurfed_UnitDropDown2Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown2,Nurfed_UnitDropDown2Idx);
end

function Nurfed_UnitDropDown3_Init()
	local id = 3;
	local unit = Nurfed_UnitDropDowns[id].unit;
	local style = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."HPStyle"];
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown3Idx = 1;
	local info;
	for i=1, 3 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateHPStyle(unit, id) end;
		if (style == i) then
			Nurfed_UnitDropDown3Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown3,Nurfed_UnitDropDown3Idx);
end

function Nurfed_UnitDropDown4_Init()
	local id = 4;
	local unit = Nurfed_UnitDropDowns[id].unit;
	local style = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."HPStyle"];
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown4Idx = 1;
	local info;
	for i=1, 3 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateHPStyle(unit, id) end;
		if (style == i) then
			Nurfed_UnitDropDown4Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown4,Nurfed_UnitDropDown4Idx);
end

function Nurfed_UnitDropDown5_Init()
	local id = 5;
	local style = Nurfed_UnitConfig[Nurfed_UnitPlayer].texturedBars;
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown5Idx = 1;
	local info;
	for i=1, 5 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateBarTextureStyle() end;
		if (style == i) then
			Nurfed_UnitDropDown5Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown5,Nurfed_UnitDropDown5Idx);
end

function Nurfed_UnitDropDown6_Init()
	local id = 6;
	local style = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBorder;
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown6Idx = 1;
	local info;
	for i=1, 3 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateUnitBorderStyle() end;
		if (style == i) then
			Nurfed_UnitDropDown6Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown6,Nurfed_UnitDropDown6Idx);
end

function Nurfed_UnitDropDown7_Init()
	local id = 7;
	local align = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitStatusText;
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown7Idx = 1;
	local info;
	for i=1, 3 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateUnitStatusTextStyle() end;
		if (align == i) then
			Nurfed_UnitDropDown7Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown7,Nurfed_UnitDropDown7Idx);
end

function Nurfed_UnitDropDown8_Init()
	local id = 8;
	local layout = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitLayout;
	getglobal("Nurfed_UnitDropDown"..id.."OptionText"):SetText(Nurfed_UnitDropDowns[id].text);
	local Nurfed_UnitDropDown8Idx = 1;
	local info;
	for i=1, 3 do
		info = {};
		info.text = Nurfed_UnitDropDowns[id]["text"..i];
		info.func = function() Nurfed_UpdateUnitLayoutStyle() end;
		if (layout == i) then
			Nurfed_UnitDropDown8Idx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(Nurfed_UnitDropDown8,Nurfed_UnitDropDown8Idx);
end

---------------------------------------------------------------------------
--			Nurfed Unit Color Swatch Functions
---------------------------------------------------------------------------

local function Nurfed_UnitSetColor(key, unit, border)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local a = 1.0 - OpacitySliderFrame:GetValue();
	local swatch,frame;
	swatch = getglobal("Nurfed_UnitColor"..key.."NormalTexture");
	frame = getglobal("Nurfed_UnitColor"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	if (unit) then
		if (border) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].r = r;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].g = g;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].b = b;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].a = a;
		else
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].r = r;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].g = g;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].b = b;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].a = a;
		end
		Nurfed_SetBackdropColor(unit);
	end
end

local function Nurfed_UnitCancelColor(key, prev, unit, border)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local a = prev.a;
	local swatch, frame;
	swatch = getglobal("Nurfed_UnitColor"..key.."NormalTexture");
	button = getglobal("Nurfed_UnitColor"..key)
	swatch:SetVertexColor(r, g, b);
	button.r = r;
	button.g = g;
	button.b = b;
	if (unit) then
		if (border) then
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].r = r;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].g = g;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].b = b;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."BorderColor"].a = a;
		else
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].r = r;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].g = g;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].b = b;
			Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Color"].a = a;
		end
		Nurfed_SetBackdropColor(unit);
	end
end

function Nurfed_UnitColorSwatchOnShow()
	local id = this:GetID();
	local option = Nurfed_UnitColorSwatches[id].option;
	local unit = Nurfed_UnitColorSwatches[id].unit;
	local border = Nurfed_UnitColorSwatches[id].border;
	local info = {};
	info = Nurfed_UnitConfig[Nurfed_UnitPlayer][option];
	local button,swatch;
	button = getglobal("Nurfed_UnitColor"..id);
	swatch = getglobal("Nurfed_UnitColor"..id.."NormalTexture");

	button.r = info.r;
	button.g = info.g;
	button.b = info.b;
	button.swatchFunc = function() Nurfed_UnitSetColor(id, unit, border) end;
	button.cancelFunc = function(x) Nurfed_UnitCancelColor(id, x, unit, border) end;
	button.hasOpacity = 1;
	button.opacityFunc = function() Nurfed_UnitSetColor(id, unit, border) end;
	button.opacity = 1.0 - info.a;
	swatch:SetVertexColor(info.r, info.g, info.b);
	getglobal("Nurfed_UnitColor"..id.."Text"):SetText(Nurfed_UnitColorSwatches[id].text);
end

function Nurfed_UnitOpenColorPicker()
	CloseMenus();
	ColorPickerFrame.func = this.swatchFunc;
	ColorPickerFrame.hasOpacity = this.hasOpacity;
	ColorPickerFrame.opacityFunc = this.opacityFunc;
	ColorPickerFrame.opacity = this.opacity;
	ColorPickerFrame:SetColorRGB(this.r, this.g, this.b);
	ColorPickerFrame.previousValues = {r = this.r, g = this.g, b = this.b, a = this.opacity};
	ColorPickerFrame.cancelFunc = this.cancelFunc;
	ColorPickerFrame:Show();
end

---------------------------------------------------------------------------
--			Nurfed Unit CheckBox Functions
---------------------------------------------------------------------------

function Nurfed_UnitCheckBoxOnShow()
	local id = this:GetID();
	local option = Nurfed_UnitCheckBoxes[id].option;
	local value = Nurfed_UnitConfig[Nurfed_UnitPlayer][option];
	local align = Nurfed_UnitCheckBoxes[id].align;
	if (align == "right") then
		getglobal("Nurfed_UnitOptionCheck"..id.."Text"):ClearAllPoints();
		getglobal("Nurfed_UnitOptionCheck"..id.."Text"):SetPoint("RIGHT", "Nurfed_UnitOptionCheck"..id, "LEFT", 0, 0);
	end
	getglobal("Nurfed_UnitOptionCheck"..id.."Text"):SetText(Nurfed_UnitCheckBoxes[id].text);
	this:SetChecked(value);
end

function Nurfed_UnitCheckBoxOnClick()
	local id = this:GetID();
	local func = Nurfed_UnitCheckBoxes[id].func;
	local arg = Nurfed_UnitCheckBoxes[id].arg;
	local value = Nurfed_UnitCheckBoxes[id].value;
	local option = Nurfed_UnitCheckBoxes[id].option;
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer][option] == 1) then
		Nurfed_UnitConfig[Nurfed_UnitPlayer][option] = 0;
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		Nurfed_UnitConfig[Nurfed_UnitPlayer][option] = 1;
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
--			Nurfed Unit Tab Functions
---------------------------------------------------------------------------

function Nurfed_UnitOptionTabsInit()
	for k,v in Nurfed_UnitOptionTabs do
		getglobal("Nurfed_UnitOptionTab"..k):SetText(v);
		getglobal("Nurfed_UnitOptionPage"..k.."SubFrame1Title"):SetText(v);
	end
	if ( not this.selectedTab ) then
		this.selectedTab = 1;
	end
	Nurfed_UnitOptionTabSelect(this.selectedTab);
end

function Nurfed_UnitOptionTabSelect(page)
	for k,v in Nurfed_UnitOptionTabs do
		if (page == k) then
			Nurfed_UnitOptionsFrame.selectedTab = k;
			getglobal("Nurfed_UnitOptionPage"..k):Show();
			getglobal("Nurfed_UnitOptionTab"..k):Disable();
		else
			getglobal("Nurfed_UnitOptionPage"..k):Hide();
			getglobal("Nurfed_UnitOptionTab"..k):Enable();
		end
	end
end

function Nurfed_UnitResetPos(unit, x, y)
	local button = getglobal("Nurfed_"..unit);
	local info = {};
	info = Nurfed_UnitConfig[Nurfed_UnitPlayer][unit.."Reset"];
	if (unit == "party") then
		Nurfed_UnitConfig[Nurfed_UnitPlayer].partySeperate = 0;
		Nurfed_UpdatePartyLocation();
	end
	button:ClearAllPoints();
	button:SetPoint(info.point, info.relativeTo, info.relativePoint, info.x, info.y);
end

function NurfedUnits_SlashCommandHandler(msg)
	if( msg ) then
		Nurfed_UnitFramesMenu();
	end
end
