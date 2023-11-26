-- Nurfed Unit Frames Config

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

local Nurfed_UnitDropDown1Idx = 1;
Nurfed_UnitPlayer = nil;

UIPanelWindows["Nurfed_UnitOptionsFrame"] = {area = "center", pushable = 0};
Nurfed_PartyHPMin = 10;
Nurfed_PartyHPMax = 75;
Nurfed_PartyHPStep = 1;

function Nurfed_UnitConfig_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	RegisterForSave("Nurfed_UnitFrames");
	
	-- Register our slash command
	SLASH_NURFEDUNITS1 = "/nurfedunits";
	SLASH_NURFEDUNITS2 = "/nunits";
	SlashCmdList["NURFEDUNITS"] = function(msg)
		NurfedUnits_SlashCommandHandler(msg);
	end
end

function Nurfed_UnitConfig_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		if( not Nurfed_UnitFrames or not Nurfed_UnitFrames.Version) then
			Nurfed_UnitFrames = {};
		end

		Nurfed_UnitFrames.Version = "07.28.2005";

		local realm = GetCVar("realmName");
		local player = UnitName("player");
		Nurfed_UnitPlayer = player.." - "..realm;

		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer]) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer] = {};
		end

		--general options
		if ( not Nurfed_UnitFrames[Nurfed_UnitPlayer].unitsLocked) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].unitsLocked = 1;
		end
		if ( not Nurfed_UnitFrames[Nurfed_UnitPlayer].texturedBars) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].texturedBars = 1;
		end
		if ( not Nurfed_UnitFrames[Nurfed_UnitPlayer].showTextOnBars) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].showTextOnBars = 0;
		end
		if ( not Nurfed_UnitFrames[Nurfed_UnitPlayer].showXPTextOnBars) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].showXPTextOnBars = 0;
		end

		--player options
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].playerColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].playerColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].playerBorderColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].playerBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].playerHPStyle) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].playerHPStyle = 2;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].playerCombatFeedBack) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].playerCombatFeedBack = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].playerScale) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].playerScale = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].playerReset) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].playerReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 20, y = -30 };
		end

		--party options
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyBorderColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if(not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyLowHealthWarn) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyLowHealthWarn = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyLowHealthWarnPerc) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyLowHealthWarnPerc = 30;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyHPStyle) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyHPStyle = 2;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyBuffs) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyBuffs = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyDeBuffs) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyDeBuffs = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyScale) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyScale = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyGrowUp) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyGrowUp = 0;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partySeperate) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partySeperate = 0;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyShowLoot) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyShowLoot = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyShowPets) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyShowPets = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyPetShowDeBuffs) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyPetShowDeBuffs = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].partyReset) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].partyReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 20, y = -200 };
		end

		--pet options
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].petColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].petColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].petBorderColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].petBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].pettargetColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].pettargetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].pettargetBorderColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].pettargetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].petHPStyle) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].petHPStyle = 2;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].pettarget) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].pettarget = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].petScale) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].petScale = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].petReset) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].petReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 20, y = -90 };
		end

		--target options
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targetColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targetBorderColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargetColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargetBorderColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargettargetColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargettargetColor = { r = 0, g = 0, b = 0 , a = 0.75 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargettargetBorderColor) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargettargetBorderColor = { r = 1, g = 1, b = 1, a = 1 };
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targettarget) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targettarget = 1;
		end
		if ( not Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargettarget) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targettargettarget = 1;
		end
		if ( not Nurfed_UnitFrames[Nurfed_UnitPlayer].targetScale) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targetScale = 1;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targetHPStyle) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targetHPStyle = 2;
		end
		if (not Nurfed_UnitFrames[Nurfed_UnitPlayer].targetReset) then
			Nurfed_UnitFrames[Nurfed_UnitPlayer].targetReset = { point = "TOPLEFT", relativeTo = "UIParent", relativePoint = "TOPLEFT", x = 200, y = -50 };
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
	end
end

function Nurfed_UnitFramesMenu()
	if (Nurfed_UnitOptionsFrame:IsVisible()) then
		HideUIPanel(Nurfed_UnitOptionsFrame);
	else
		ShowUIPanel(Nurfed_UnitOptionsFrame);
	end
end

function Nurfed_SetBackdropColor(unit)
	local bginfo = {};
	bginfo = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"];
	local bdinfo = {};
	bdinfo = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"];
	if (unit == "party") then
		for i=1, 4 do
			getglobal("Nurfed_"..unit..i.."Backdrop"):SetBackdropColor(bginfo.r, bginfo.g, bginfo.b, bginfo.a);
			getglobal("Nurfed_"..unit..i.."Backdrop"):SetBackdropBorderColor(bdinfo.r, bdinfo.g, bdinfo.b, bdinfo.a);
		end
	else
		getglobal("Nurfed_"..unit.."Backdrop"):SetBackdropColor(bginfo.r, bginfo.g, bginfo.b, bginfo.a);
		getglobal("Nurfed_"..unit.."Backdrop"):SetBackdropBorderColor(bdinfo.r, bdinfo.g, bdinfo.b, bdinfo.a);
	end
end

function Nurfed_SetScale(unit)
	local scale = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Scale"];
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
		end
	end
end

function Nurfed_UnitFramesInit()
	Nurfed_DisablePlayer();
	Nurfed_DisablePet();
	Nurfed_DisableTarget();
	Nurfed_DisableParty();

	Nurfed_SetBackdropColor("player");
	Nurfed_SetBackdropColor("target");
	Nurfed_SetBackdropColor("party");
	Nurfed_SetBackdropColor("pet");
	Nurfed_SetBackdropColor("pettarget");
	Nurfed_SetBackdropColor("targettarget");
	Nurfed_SetBackdropColor("targettargettarget");

	Nurfed_UpdateBarTextures();
	Nurfed_UpdateBarText();

	Nurfed_UnitOptionsFrameTitle:SetText(NURFEDUNITFRAMES.."\nVers. "..Nurfed_UnitFrames.Version);
end

function Nurfed_UnitOptionsInit()
--Checks
	--general
	Nurfed_UnitCheckBoxes = {
		[1] = { text = "Lock Unit Frames", option = "unitsLocked" },
		[2] = { text = "Texture Bars", option = "texturedBars", func = Nurfed_UpdateBarTextures },
		[3] = { text = "Show HP/MP Text", option = "showTextOnBars", func = Nurfed_UpdateBarText },
		[4] = { text = "Show XP Text", option = "showXPTextOnBars", func = Nurfed_UpdateBarText },
	--player
		[5] = { text = "Show Combat Text", option = "playerCombatFeedBack" },
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
	};

--Sliders
	Nurfed_UnitSliders = {
		[1] = { text = "Scale Player", option = "playerScale", unit = "player", min = 0.5, max = 1.5, step = 0.05, func = Nurfed_UpdateUnitScale },
		[2] = { text = "Scale Party", option = "partyScale", unit = "party", min = 0.5, max = 1.5, step = 0.05, func = Nurfed_UpdateUnitScale },
		[3] = { text = "Low HP Warning", option = "partyLowHealthWarnPerc", min = 10, max = 75, step = 5, func = Nurfed_UpdateLowHPWarn },
		[4] = { text = "Scale Pet", option = "petScale", unit = "pet", min = 0.5, max = 1.5, step = 0.05, func = Nurfed_UpdateUnitScale },
		[5] = { text = "Scale Target", option = "targetScale", unit = "target", min = 0.5, max = 1.5, step = 0.05, func = Nurfed_UpdateUnitScale },
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
	};
end

function Nurfed_UnitSliderOnShow()
	local id = this:GetID();
	getglobal("Nurfed_UnitSlider"..id.."Text"):SetText(Nurfed_UnitSliders[id].text);
	getglobal("Nurfed_UnitSlider"..id.."Low"):SetText(Nurfed_UnitSliders[id].min);
	getglobal("Nurfed_UnitSlider"..id.."High"):SetText(Nurfed_UnitSliders[id].max);
	getglobal("Nurfed_UnitSlider"..id.."SliderValue"):SetText(format("%.2f", this:GetValue()));
	this:SetMinMaxValues(Nurfed_UnitSliders[id].min, Nurfed_UnitSliders[id].max);
	this:SetValueStep(Nurfed_UnitSliders[id].step);
	this:SetValue(Nurfed_UnitFrames[Nurfed_UnitPlayer][Nurfed_UnitSliders[id].option]);
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

function Nurfed_UpdateUnitScale(unit, value)
	if (Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Scale"] ~= value) then
		Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Scale"] = value;
		Nurfed_SetScale(unit);
		Nurfed_UnitResetPos(unit);
	end
end

function Nurfed_UpdateLowHPWarn(value)
	Nurfed_UnitFrames[Nurfed_UnitPlayer]["partyLowHealthWarnPerc"] = value;
end

function Nurfed_UnitDropDown1_Init()
	local id = 1;
	local unit = Nurfed_UnitDropDowns[id].unit;
	local style = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."HPStyle"];
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
	local style = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."HPStyle"];
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
	local style = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."HPStyle"];
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
	local style = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."HPStyle"];
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

function Nurfed_UpdateHPStyle(unit, id)
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
	Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."HPStyle"] = this:GetID();
	if (unit == "party") then
		for i=1, 4 do
			Nurfed_UpdateHealthBar("party"..i);
			Nurfed_UpdateHealthBar("partypet"..i);
		end
	else
		Nurfed_UpdateHealthBar(unit);
	end
end

function Nurfed_UpdateHealthBar(unit)
	local healthbar = getglobal("Nurfed_"..unit.."HealthBar");
	if (strsub(unit,1,5) == "party") then
		unitcheck = "party";
	else
		unitcheck = unit;
	end
	if (Nurfed_UnitFrames[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 1) then
		healthbar:SetWidth(132);
	else
		healthbar:SetWidth(100);
	end
	Nurfed_UpdateHealth(unit);
end

function Nurfed_UnitColorSwatchOnShow()
	local id = this:GetID();
	local option = Nurfed_UnitColorSwatches[id].option;
	local unit = Nurfed_UnitColorSwatches[id].unit;
	local border = Nurfed_UnitColorSwatches[id].border;
	local info = {};
	info = Nurfed_UnitFrames[Nurfed_UnitPlayer][option];
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

function Nurfed_UnitSetColor(key, unit, border)
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
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].r = r;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].g = g;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].b = b;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].a = a;
		else
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].r = r;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].g = g;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].b = b;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].a = a;
		end
		Nurfed_SetBackdropColor(unit);
	end
end

function Nurfed_UnitCancelColor(key, prev, unit, border)
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
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].r = r;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].g = g;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].b = b;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."BorderColor"].a = a;
		else
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].r = r;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].g = g;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].b = b;
			Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Color"].a = a;
		end
		Nurfed_SetBackdropColor(unit);
	end
end

function Nurfed_UnitCheckBoxOnShow()
	local id = this:GetID();
	local option = Nurfed_UnitCheckBoxes[id].option;
	local value = Nurfed_UnitFrames[Nurfed_UnitPlayer][option];
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
	if (Nurfed_UnitFrames[Nurfed_UnitPlayer][option] == 1) then
		Nurfed_UnitFrames[Nurfed_UnitPlayer][option] = 0;
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		Nurfed_UnitFrames[Nurfed_UnitPlayer][option] = 1;
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

function Nurfed_UnitToTUpdate()
	if (Nurfed_UnitFrames[Nurfed_UnitPlayer]["targettargettarget"] == 1) then
		Nurfed_targettarget:SetWidth(70);
		Nurfed_targettargetBG:SetWidth(67);
		Nurfed_targettargetHealthBar:SetWidth(65);
		Nurfed_targettargetManaBar:SetWidth(65);
		Nurfed_targettargetHealthText:Hide();
		Nurfed_targettargetManaText:Hide();
	else
		Nurfed_targettarget:SetWidth(145);
		Nurfed_targettargetBG:SetWidth(142);
		Nurfed_targettargetHealthBar:SetWidth(100);
		Nurfed_targettargetManaBar:SetWidth(100);
		Nurfed_targettargetHealthText:Show();
		Nurfed_targettargetManaText:Show();
	end
end

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

function Nurfed_PartyRefreshAuras(unit)
	if (unit == "party") then
		for id = 1, 4 do
			Nurfed_RefreshAuras("party"..id, 8, 4);
		end
		Nurfed_UpdatePartyLocation();
	elseif (unit == "partypet") then
		for id = 1, 4 do
			Nurfed_RefreshAuras("partypet"..id, 0, 4);
		end
	end

end

function Nurfed_UnitResetPos(unit, x, y)
	local button = getglobal("Nurfed_"..unit);
	local info = {};
	info = Nurfed_UnitFrames[Nurfed_UnitPlayer][unit.."Reset"];
	if (unit == "party") then
		Nurfed_UnitFrames[Nurfed_UnitPlayer].partySeperate = 0;
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
