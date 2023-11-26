--------------------------------------------------------------------------
-- Archaeologist.lua 
--------------------------------------------------------------------------
--[[
Archaeologist 
	Unearthing Health and Mana values at a unit frame near you.

By: AnduinLothar    <Anduin@cosmosui.org>

Replaces some old Cosmos FrameXML Hacks.
Chnage Log:
v0.1a
-Adds Text to Unit Frame Status Bars
-Adds Dead/Offline/Ghost text to all unit frames
-Changes health bar color as it decreases
-Status bar prefix is optional
-All status text can be shown as percent or real value (except target HP which is percent from server)

v0.2a
-Fixed Slash commands not working for text.
-Sepperated Player HP/MP/XP text
-Made target percent an option so you can see true values when you target self or party member

v0.3a
-Optimized Slash and Cosmos Reg Code.
-Fixed non-Cosmos saved variables not being saved (also nil pointer bug)
-Fixed text relocation so that the HP and MP text are now slightly sepperated
-Removed partial frame replacement and replaced it with onLoad status bar initializing

v0.4a
-Fixed a hp prefix reshowing bug
-Added Pet Dead Text
-Fixed Pet MP/HP show issue

v0.5a
-TargetFrame healthbars now always display as percent unless max hp is difforent thant 100 (party, player, pet)

v0.6a
-Added 12 Buffs and 12 Debuffs for all party members and pet.
-Moved Pet Happiness to accomidate pet debuffs
-Options to Show or Hide buffs or debuffs (reverts to normal onmouseover behavior when off)
-Show anywhere between 0 and 12 Buffs or Debuffs
-Cleaned up slash command printouts
-Syncronized Cosmos with Slash Commands. Use both if you're thus inspired.

v0.7a
-Added Alternate Debuff Location.
-Added buff tooltips
-Changed Slash Command syntax
-Added Alternate HPMP text location that aligns to the outside of the bar frame.

v1.0
-Live in Cosmos!
-Spelling Errors Corrected


	$Id: Archaeologist.lua 999 2005-03-11 02:07:10Z AlexYoshi $
	$Rev: 999 $
	$LastChangedBy: AlexYoshi $
	$Date: 2005-03-10 21:07:10 -0500 (Thu, 10 Mar 2005) $

]]--

-- <= == == == == == == == == == == == == =>
-- => Global Variables
-- <= == == == == == == == == == == == == =>

MIN_PBUFFS = 0;
MAX_PBUFFS = 12;
MIN_PDEBUFFS = 0;
MAX_PDEBUFFS = 12;
MIN_PTBUFFS = 0;
MAX_PTBUFFS = 12;
MIN_PTDEBUFFS = 0;
MAX_PTDEBUFFS = 12;

Archaeologist_TextStringPercentStatusBars = { };

ArchaeologistStatusBars = { };

function Archaeologist_DefineStatusBars()

	ArchaeologistStatusBars.player  = { frame = PlayerFrame, statusText = PlayerStatusText };
	ArchaeologistStatusBars.party1  = { frame = PartyMemberFrame1, statusText = PartyMemberFrame1.statusText };
	ArchaeologistStatusBars.party2  = { frame = PartyMemberFrame2, statusText = PartyMemberFrame2.statusText };
	ArchaeologistStatusBars.party3  = { frame = PartyMemberFrame3, statusText = PartyMemberFrame3.statusText };
	ArchaeologistStatusBars.party4  = { frame = PartyMemberFrame4, statusText = PartyMemberFrame4.statusText };
	ArchaeologistStatusBars.pet		= { frame = PetFrame, statusText = PetStatusText };
	ArchaeologistStatusBars.target  = { frame = TargetFrame, statusText = TargetDeadText };

end


-- <= == == == == == == == == == == == == =>
-- => Variable Sync Tables
-- <= == == == == == == == == == == == == =>

--ArchaeologistVars = { };
ArchaeologistVarData = { };

function Archaeologist_DefineVarData()
	ArchaeologistVarData = {

		PLAYERHP = { cosmos = "COS_ARCHAEOLOGIST_PLAYERHP", default = 0, func = Archaeologist_TurnOnPlayerHP },
		PLAYERMP = { cosmos = "COS_ARCHAEOLOGIST_PLAYERMP", default = 0, func = Archaeologist_TurnOnPlayerMP },
		PLAYERXP = { cosmos = "COS_ARCHAEOLOGIST_PLAYERXP", default = 0, func = Archaeologist_TurnOnPlayerXP },
		PLAYERHPP = { cosmos = "COS_ARCHAEOLOGIST_PLAYERHPP", default = 0, func = Archaeologist_TurnOnPlayerHPPercent },
		PLAYERMPP = { cosmos = "COS_ARCHAEOLOGIST_PLAYERMPP", default = 0, func = Archaeologist_TurnOnPlayerMPPercent },
		PLAYERXPP = { cosmos = "COS_ARCHAEOLOGIST_PLAYERXPP", default = 0, func = Archaeologist_TurnOnPlayerXPPercent },
		PLAYERHPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_PLAYERHPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPlayerHPPrefix },
		PLAYERMPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_PLAYERMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPlayerMPPrefix },
		PLAYERXPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_PLAYERXPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPlayerXPPrefix },
		
		PARTYHP = { cosmos = "COS_ARCHAEOLOGIST_PARTYHP", default = 0, func = Archaeologist_TurnOnPartyHP },
		PARTYMP = { cosmos = "COS_ARCHAEOLOGIST_PARTYMP", default = 0, func = Archaeologist_TurnOnPartyMP },
		PARTYHPP = { cosmos = "COS_ARCHAEOLOGIST_PARTYHPP", default = 0, func = Archaeologist_TurnOnPartyHPPercent },
		PARTYMPP = { cosmos = "COS_ARCHAEOLOGIST_PARTYMPP", default = 0, func = Archaeologist_TurnOnPartyMPPercent },
		PARTYHPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_PARTYHPJUSTVALUE", default = 1, func = Archaeologist_TurnOffPartyHPPrefix },
		PARTYMPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_PARTYMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPartyMPPrefix },
		
		PETHP = { cosmos = "COS_ARCHAEOLOGIST_PETHP", default = 0, func = Archaeologist_TurnOnPetHP },
		PETMP = { cosmos = "COS_ARCHAEOLOGIST_PETMP", default = 0, func = Archaeologist_TurnOnPetMP },
		PETHPP = { cosmos = "COS_ARCHAEOLOGIST_PETHPP", default = 0, func = Archaeologist_TurnOnPetHPPercent },
		PETMPP = { cosmos = "COS_ARCHAEOLOGIST_PETMPP", default = 0, func = Archaeologist_TurnOnPetMPPercent },
		PETHPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_PETHPJUSTVALUE", default = 1, func = Archaeologist_TurnOffPetHPPrefix },
		PETMPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_PETMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPetMPPrefix },
		
		TARGETHP = { cosmos = "COS_ARCHAEOLOGIST_TARGETHP", default = 0, func = Archaeologist_TurnOnTargetHP },
		TARGETMP = { cosmos = "COS_ARCHAEOLOGIST_TARGETMP", default = 0, func = Archaeologist_TurnOnTargetMP },
		TARGETHPP = { cosmos = "COS_ARCHAEOLOGIST_TARGETHPP", default = 0, func = Archaeologist_TurnOnTargetHPPercent },
		TARGETMPP = { cosmos = "COS_ARCHAEOLOGIST_TARGETMPP", default = 0, func = Archaeologist_TurnOnTargetMPPercent },
		TARGETHPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_TARGETHPJUSTVALUE", default = 1, func = Archaeologist_TurnOffTargetHPPrefix },
		TARGETMPJUSTVALUE = { cosmos = "COS_ARCHAEOLOGIST_TARGETMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffTargetMPPrefix },
		
		HPCOLOR = { cosmos = "COS_ARCHAEOLOGIST_HPCOLOR", default = 0, func = Archaeologist_TurnOnHPColorMod },
		
		PBUFFS = { cosmos = "COS_ARCHAEOLOGIST_PBUFFS", default = 0, func = Archaeologist_TurnOffPartyBuffs },
		PBUFFNUM = { cosmos = "COS_ARCHAEOLOGIST_PBUFFNUM", default = MAX_PBUFFS, func = Archaeologist_SetPartyBuffs },
		
		PDEBUFFS = { cosmos = "COS_ARCHAEOLOGIST_PDEBUFFS", default = 0, func = Archaeologist_TurnOffPartyDebuffs },
		PDEBUFFNUM = { cosmos = "COS_ARCHAEOLOGIST_PDEBUFFNUM", default = MAX_PDEBUFFS, func = Archaeologist_SetPartyDebuffs },
		
		PTBUFFS = { cosmos = "COS_ARCHAEOLOGIST_PTBUFFS", default = 0, func = Archaeologist_TurnOffPetBuffs },
		PTBUFFNUM = { cosmos = "COS_ARCHAEOLOGIST_PTBUFFNUM", default = MAX_PTBUFFS, func = Archaeologist_SetPetBuffs },
		
		PTDEBUFFS = { cosmos = "COS_ARCHAEOLOGIST_PTDEBUFFS", default = 0, func = Archaeologist_TurnOffPetDebuffs },
		PTDEBUFFNUM = { cosmos = "COS_ARCHAEOLOGIST_PTDEBUFFNUM", default = 4, func = Archaeologist_SetPetDebuffs },
		
		DEBUFFALT = { cosmos = "COS_ARCHAEOLOGIST_DEBUFFALT", default = 0, func = Archaeologist_SetAltDebuffLocation },
		HPMPALT = { cosmos = "COS_ARCHAEOLOGIST_HPMPALT", default = 0, func = Archaeologist_SetAltHPMPLocation }

	};
end

-- <= == == == == == == == == == == == == =>
-- => XML Function Calls
-- <= == == == == == == == == == == == == =>

local SavedHealthBar_OnValueChanged = nil;

function Archaeologist_OnLoad()
	Sea.util.hook( "TargetFrame_CheckDead", "Archaeologist_TargetCheckDead", "replace" );
	Sea.util.hook( "ShowTextStatusBarText", "Archaeologist_ShowTextStatusBarText", "replace" );
	Sea.util.hook( "HideTextStatusBarText", "Archaeologist_HideTextStatusBarText", "replace" );
	Sea.util.hook( "TextStatusBar_UpdateTextString", "Archaeologist_TextStatusBar_UpdateTextString", "replace" );
	Sea.util.hook( "UnitFrame_UpdateManaType", "Archaeologist_UnitFrame_UpdateManaType", "replace" );
	
	Sea.util.hook( "PartyMemberFrame_RefreshBuffs", "Archaeologist_PartyMemberFrame_RefreshBuffs", "replace" );
	Sea.util.hook( "PetFrame_RefreshBuffs", "Archaeologist_PetFrame_RefreshBuffs", "replace" );
	Sea.util.hook( "PartyMemberBuffTooltip_Update", "Archaeologist_PartyMemberBuffs_Update", "replace" );
	Sea.util.hook( "ShowPartyFrame", "Archaeologist_UpdatePartyMemberBuffs", "after" );
	
	Sea.util.hook( "PartyMemberFrame_OnLoad", "Archaeologist_PartyMemberFrame_OnLoad", "before" );
	
	--HealthBar_OnValueChanged manual hook to modify input
	if (HealthBar_OnValueChanged ~= SavedHealthBar_OnValueChanged) then
		SavedHealthBar_OnValueChanged = HealthBar_OnValueChanged;
		HealthBar_OnValueChanged = Archaeologist_HealthBar_OnValueChanged;
	end
	
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	this:RegisterEvent("PARTY_MEMBER_ENABLE");
	this:RegisterEvent("UNIT_AURA");
	
	Archaeologist_DefineVarData();
	
end

function Archaeologist_PartyMemberFrame_OnLoad()
	Sea.io.print("PARTYFRAME.XML RELOAD!");
end


function Archaeologist_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		
		Archaeologist_InitializeAddedStatusBarTexts();
		Archaeologist_DefineStatusBars();
		
		if (not ArchaeologistVars) then
			ArchaeologistVars = { };
		end
		
		if (Cosmos_RegisterConfiguration) then
			Archaeologist_VarSync_CosmosToVars();
			Archaeologist_RegisterForCosmos();
		else
			Archaeologist_VarSync_SavedToVars()
			Archaeologist_VarSync_VarsToLive();
			RegisterForSave("ArchaeologistVars");
		end
		
		Archaeologist_RegisterForSlashCommands();
		
		Archaeologist_PlayerCheckDead();
		Archaeologist_UpdatePartyMembersDead();
		Archaeologist_PetCheckDead();
		
		--moved pet happiness so that the debuffs go in its place
		PetFrameHappiness:ClearAllPoints();
		PetFrameHappiness:SetPoint("TOPRIGHT", "PetFrame", "BOTTOMLEFT", 8, 15);
	
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		--Archaeologist_PlayerCheckDead();
		--Archaeologist_UpdatePartyMembersDead();
		--Archaeologist_PetCheckDead();
		Archaeologist_UpdatePartyMemberBuffs();
	
	elseif ( event == "UNIT_HEALTH" ) then
		if (arg1 == "player") then
			Archaeologist_PlayerCheckDead();
		elseif (arg1 == "target") then
			--called by hook
			--Archaeologist_TargetCheckDead();
		elseif (arg1 == "pet") then
			Archaeologist_PetCheckDead();
		else
			local partyIndex = Archaeologist_PartyIndexFromUnit(arg1);
			Archaeologist_PartyCheckDead(partyIndex);
		end
		
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		Archaeologist_UpdatePartyMembersDead();
		--Sea.io.print(event,arg1,arg2,arg3,arg4,arg5);
		
	elseif (event == "PARTY_MEMBER_ENABLE") then
		local partyIndex = Archaeologist_PartyIndexFromName(arg1);
		Archaeologist_PartyCheckDead(partyIndex);
		--Sea.io.print(event," ",arg1);
		
	elseif (event == "PARTY_MEMBER_DISABLE") then
		local partyIndex = Archaeologist_PartyIndexFromName(arg1);
		Archaeologist_PartyCheckDead(partyIndex);
		--Sea.io.print(event," ",arg1);
	
	elseif (event == "UNIT_AURA") then
		local partyIndex = Archaeologist_PartyIndexFromUnit(arg1);
		Archaeologist_PartyCheckDead(partyIndex);
		if (arg1 == "pet") then
			Archaeologist_PetCheckDead();
		end
	end

end

-- <= == == == == == == == == == == == == =>
-- => Status Bar Initializing
-- <= == == == == == == == == == == == == =>

function Archaeologist_InitializeAddedStatusBarTexts()

	SetTextStatusBarText(PartyMemberFrame1HealthBar, PartyMemberFrame1HealthBarTextString);
	SetTextStatusBarText(PartyMemberFrame2HealthBar, PartyMemberFrame2HealthBarTextString);
	SetTextStatusBarText(PartyMemberFrame3HealthBar, PartyMemberFrame3HealthBarTextString);
	SetTextStatusBarText(PartyMemberFrame4HealthBar, PartyMemberFrame4HealthBarTextString);
	
	SetTextStatusBarText(PartyMemberFrame1ManaBar, PartyMemberFrame1ManaBarTextString);
	SetTextStatusBarText(PartyMemberFrame2ManaBar, PartyMemberFrame2ManaBarTextString);
	SetTextStatusBarText(PartyMemberFrame3ManaBar, PartyMemberFrame3ManaBarTextString);
	SetTextStatusBarText(PartyMemberFrame4ManaBar, PartyMemberFrame4ManaBarTextString);
	
	SetTextStatusBarText(TargetFrameHealthBar, TargetFrameHealthBarTextString);
	SetTextStatusBarText(TargetFrameManaBar, TargetFrameManaBarTextString);
end

-- <= == == == == == == == == == == == == =>
-- => Variable Sync
-- <= == == == == == == == == == == == == =>

function Archaeologist_VarSync_CosmosToVars()
	--sync internal values with cosmos values, else use default stored, else default to 0
	for index, var in ArchaeologistVarData do
		if (var.cosmos) and (index == "PBUFFNUM" or index == "PDEBUFFNUM" or index == "PTBUFFNUM" or index == "PTDEBUFFNUM") then
			local cosVal = getglobal(var.cosmos);
			if (cosVal) then
				ArchaeologistVars[index] = cosVal;
			elseif (var.default) then
				ArchaeologistVars[index] = var.default;
			else
				ArchaeologistVars[index] = 0;
			end
		elseif (var.cosmos) then
			local cosVal = getglobal(var.cosmos.."_X");
			if (cosVal) then
				ArchaeologistVars[index] = cosVal;
			elseif (var.default) then
				ArchaeologistVars[index] = var.default;
			else
				ArchaeologistVars[index] = 0;
			end
		end
	end
end


function Archaeologist_VarSync_VarsToCosmos()
	--sync cosmos values with internal values, else use default stored, else default to 0
	if(Cosmos_RegisterConfiguration) then
		for index, var in ArchaeologistVarData do
			if (var.cosmos) and (index == "PBUFFNUM" or index == "PDEBUFFNUM" or index == "PTBUFFNUM" or index == "PTDEBUFFNUM") then
				if(ArchaeologistVars[index]) then
					Cosmos_UpdateValue(var.cosmos, CSM_SLIDERVALUE, ArchaeologistVars[index]);
				end
			elseif (var.cosmos) then
				if(ArchaeologistVars[index]) then
					Cosmos_UpdateValue(var.cosmos, CSM_CHECKONOFF, ArchaeologistVars[index]);
				end
			end
		end
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
			CosmosMaster_DrawData();
		end
	end
end


function Archaeologist_VarSync_SavedToVars()
	--sync saved values with internal values, else use default stored, else default to 0
	for index, var in ArchaeologistVarData do
		if (ArchaeologistVars[index]) then
			--already saved
		elseif (var.default) then
			ArchaeologistVars[index] = var.default;
		else
			ArchaeologistVars[index] = 0;
		end
	end
end


function Archaeologist_VarSync_VarsToLive()
	--sync live status with internal values, else use default stored, else default to 0
	for index, var in ArchaeologistVarData do
		if (index == "PBUFFNUM" or index == "PDEBUFFNUM" or index == "PTBUFFNUM" or index == "PTDEBUFFNUM") then
			if (ArchaeologistVars[index]) and (var.func) then
				var.func(1, ArchaeologistVars[index])
			elseif (var.func) and (var.default) then
				var.func(1, var.default);
			elseif (var.func) then
				var.func(1, 0);
			end
		elseif (ArchaeologistVars[index]) and (var.func) then
			var.func(ArchaeologistVars[index])
		elseif (var.func) and (var.default) then
			var.func(var.default);
		elseif (var.func) then
			var.func(0);
		end
	end
end


-- <= == == == == == == == == == == == == =>
-- => HP Color Mod
-- <= == == == == == == == == == == == == =>

function Archaeologist_HealthBar_OnValueChanged(value, smooth)
	if (ArchaeologistVars) then
		if (ArchaeologistVars["HPCOLOR"] == 1) then
			smooth = not smooth;
		end
	end
	SavedHealthBar_OnValueChanged(value, smooth)
end

-- <= == == == == == == == == == == == == => <= == == == == == == == == == == == == =>
-- => Toggle Functions
-- <= == == == == == == == == == == == == => <= == == == == == == == == == == == == =>

-- <= == == == == == == == == == == == == =>
-- => TurnOn HP Color Function
-- <= == == == == == == == == == == == == =>

function Archaeologist_TurnOnHPColorMod(toggle)
	ArchaeologistVars["HPCOLOR"] = toggle;
end


-- <= == == == == == == == == == == == == =>
-- => TurnOn HP/MP/XP Functions
-- <= == == == == == == == == == == == == =>

function Archaeologist_TurnOnPlayerHP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["player"].frame.healthbar, toggle);
	ArchaeologistVars["PLAYERHP"] = toggle;
end


function Archaeologist_TurnOnPlayerMP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["player"].frame.manabar, toggle);
	ArchaeologistVars["PLAYERMP"] = toggle;
end

function Archaeologist_TurnOnPlayerXP(toggle)
	OverrideShowStatusBarText(MainMenuExpBar, toggle);
	ArchaeologistVars["PLAYERXP"] = toggle;
end


function Archaeologist_TurnOnPartyHP(toggle)
	for i=1, 4 do
		local bar = ArchaeologistStatusBars["party"..i].frame.healthbar;
		OverrideShowStatusBarText(bar, toggle);
	end
	ArchaeologistVars["PARTYHP"] = toggle;
end


function Archaeologist_TurnOnPartyMP(toggle) 
	for i = 1, 4 do
		local bar = ArchaeologistStatusBars["party"..i].frame.manabar
		OverrideShowStatusBarText(bar, toggle);
	end
	ArchaeologistVars["PARTYMP"] = toggle;
end


function Archaeologist_TurnOnTargetHP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["target"].frame.healthbar, toggle);
	ArchaeologistVars["TARGETHP"] = toggle;
end


function Archaeologist_TurnOnTargetMP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["target"].frame.manabar, toggle);
	ArchaeologistVars["TARGETMP"] = toggle;
end


function Archaeologist_TurnOnPetHP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["pet"].frame.healthbar, toggle);
	ArchaeologistVars["PETHP"] = toggle;
end


function Archaeologist_TurnOnPetMP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["pet"].frame.manabar, toggle);
	ArchaeologistVars["PETMP"] = toggle;
end


function Archaeologist_SetAltHPMPLocation(toggle)
	ArchaeologistVars["HPMPALT"] = toggle;
	local bar;
	local bartext;
	local bartextstring;
	local stringSuffix;
	local point;
	local relativePoint;
	local justify;
	local width = 20;
	local x;
	local y;

	for unit, data in ArchaeologistStatusBars do
		if (toggle == 1) then
			if (unit == "target") then
				point = "RIGHT";
				relativePoint = "LEFT";
				justify = "RIGHT";
			else
				point = "LEFT";
				relativePoint = "RIGHT";
				justify = "LEFT";
				
			end
		else
			point = "CENTER";
			relativePoint = "CENTER";
			justify = "CENTER";
		end
		if (unit == "pet") or (unit == "player") then
			stringSuffix = "";
		else
			stringSuffix = "String";
		end
		x = 0;
		y = 2;
		
		bar = getglobal(data.frame:GetName().."HealthBar");
		bartext = getglobal(data.frame:GetName().."HealthBarText");
		bartextstring = getglobal(data.frame:GetName().."HealthBarText"..stringSuffix);
		
		bartext:SetHeight(bar:GetHeight());
		bartext:SetWidth(bar:GetWidth()+width);
		bartext:ClearAllPoints();
		bartext:SetPoint(point, bar:GetName(), relativePoint, x, y);
		bartextstring:SetJustifyH(justify);
		
		y = -2;
		
		bar = getglobal(data.frame:GetName().."ManaBar");
		bartext = getglobal(data.frame:GetName().."ManaBarText");
		bartextstring = getglobal(data.frame:GetName().."ManaBarText"..stringSuffix);
		
		bartext:SetHeight(bar:GetHeight());
		bartext:SetWidth(bar:GetWidth()+width);
		bartext:ClearAllPoints();
		bartext:SetPoint(point, bar:GetName(), relativePoint, x, y);
		bartextstring:SetJustifyH(justify);
	end

end


-- <= == == == == == == == == == == == == =>
-- => Change HP/MP/XP Values to Percent Functions
-- <= == == == == == == == == == == == == =>

function Archaeologist_TurnOnPlayerHPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["player"].frame.healthbar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PLAYERHPP"] = toggle;
end

function Archaeologist_TurnOnPlayerMPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["player"].frame.manabar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PLAYERMPP"] = toggle;
end

function Archaeologist_TurnOnPlayerXPPercent(toggle)
	Archaeologist_TextStringPercentStatusBars["MainMenuExpBar"] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(MainMenuExpBar);
	ArchaeologistVars["PLAYERXPP"] = toggle;
end

function Archaeologist_TurnOnPartyHPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["party1"].frame.healthbar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party2"].frame.healthbar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party3"].frame.healthbar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party4"].frame.healthbar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	ArchaeologistVars["PARTYHPP"] = toggle;
end

function Archaeologist_TurnOnPartyMPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["party1"].frame.manabar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party2"].frame.manabar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party3"].frame.manabar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party4"].frame.manabar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	ArchaeologistVars["PARTYMPP"] = toggle;
end

--only used to call onload since no more accurate data is provided
function Archaeologist_TurnOnTargetHPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["target"].frame.healthbar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
end

function Archaeologist_TurnOnTargetMPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["target"].frame.manabar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["TARGETMPP"] = toggle;
end


function Archaeologist_TurnOnPetHPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["pet"].frame.healthbar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PETHPP"] = toggle;
end

function Archaeologist_TurnOnPetMPPercent(toggle)
	local statusBar = ArchaeologistStatusBars["pet"].frame.manabar;
	Archaeologist_TextStringPercentStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PETMPP"] = toggle;
end



-- <= == == == == == == == == == == == == =>
-- => Hide HP/MP/XP Value Prefix Functions
-- <= == == == == == == == == == == == == =>

function Archaeologist_UnitFrame_UpdateManaType()
	local info = ManaBarColor[UnitPowerType(this.unit)];
	this.manabar:SetStatusBarColor(info.r, info.g, info.b);
	
	-- Update the manabar prefix only if not hidden
	if ( Archaeologist_ManaPrefixNotHidden(this) ) then
		SetTextStatusBarTextPrefix(this.manabar, info.prefix);
		TextStatusBar_UpdateTextString(this.manabar);
	end

	-- Setup newbie tooltip
	if ( this:GetName() == "PlayerFrame" ) then
		this.manabar.tooltipTitle = info.prefix;
		this.manabar.tooltipText = getglobal("NEWBIE_TOOLTIP_MANABAR"..UnitPowerType(this.unit));
	else
		this.manabar.tooltipTitle = nil;
		this.manabar.tooltipText = nil;
	end
	
end


function Archaeologist_ManaPrefixNotHidden(frame)
	if  ( (ArchaeologistVars["PLAYERMPJUSTVALUE"] == 0) and (frame == ArchaeologistStatusBars.player.frame) ) or
		( (ArchaeologistVars["PARTYMPJUSTVALUE"] == 0) and (
			(frame == ArchaeologistStatusBars.party1.frame) or
			(frame == ArchaeologistStatusBars.party2.frame) or
			(frame == ArchaeologistStatusBars.party3.frame) or
			(frame == ArchaeologistStatusBars.party4.frame)
		) ) or
		( (ArchaeologistVars["PETMPJUSTVALUE"] == 0) and (frame == ArchaeologistStatusBars.pet.frame) ) or
		( (ArchaeologistVars["TARGETMPJUSTVALUE"] == 0) and (frame == ArchaeologistStatusBars.target.frame) )
	then
		return true;
	end
end


function Archaeologist_TurnOffUnitHPPrefix(unit, toggle)
	local statusBar = ArchaeologistStatusBars[unit].frame.healthbar;
	if (toggle == 1) then
		SetTextStatusBarTextPrefix(statusBar, nil);
	else
		SetTextStatusBarTextPrefix(statusBar, TEXT(HEALTH));
	end
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
end

function Archaeologist_TurnOffUnitMPPrefix(unit, toggle)
	local statusBar = ArchaeologistStatusBars[unit].frame.manabar;
	if (toggle == 1) then
		SetTextStatusBarTextPrefix(statusBar, nil);
	else
		SetTextStatusBarTextPrefix(statusBar, ManaBarColor[UnitPowerType(unit)].prefix);
	end
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
end


function Archaeologist_TurnOffPlayerHPPrefix(toggle)
	Archaeologist_TurnOffUnitHPPrefix("player", toggle)
	ArchaeologistVars["PLAYERHPJUSTVALUE"] = toggle;
end

function Archaeologist_TurnOffPlayerMPPrefix(toggle)
	Archaeologist_TurnOffUnitMPPrefix("player", toggle)
	ArchaeologistVars["PLAYERMPJUSTVALUE"] = toggle;
end

function Archaeologist_TurnOffPlayerXPPrefix(toggle)
	local statusBar = MainMenuExpBar;
	if (toggle == 1) then
		SetTextStatusBarTextPrefix(statusBar, nil);
	else
		SetTextStatusBarTextPrefix(statusBar, TEXT(XP));
	end
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PLAYERXPJUSTVALUE"] = toggle;
end

function Archaeologist_TurnOffPartyHPPrefix(toggle)
	Archaeologist_TurnOffUnitHPPrefix("party1", toggle)
	Archaeologist_TurnOffUnitHPPrefix("party2", toggle)
	Archaeologist_TurnOffUnitHPPrefix("party3", toggle)
	Archaeologist_TurnOffUnitHPPrefix("party4", toggle)
	ArchaeologistVars["PARTYHPJUSTVALUE"] = toggle;
end

function Archaeologist_TurnOffPartyMPPrefix(toggle)
	Archaeologist_TurnOffUnitMPPrefix("party1", toggle)
	Archaeologist_TurnOffUnitMPPrefix("party2", toggle)
	Archaeologist_TurnOffUnitMPPrefix("party3", toggle)
	Archaeologist_TurnOffUnitMPPrefix("party4", toggle)
	ArchaeologistVars["PARTYMPJUSTVALUE"] = toggle;
end

function Archaeologist_TurnOffTargetHPPrefix(toggle)
	Archaeologist_TurnOffUnitHPPrefix("target", toggle)
	ArchaeologistVars["TARGETHPJUSTVALUE"] = toggle;
end

function Archaeologist_TurnOffTargetMPPrefix(toggle)
	Archaeologist_TurnOffUnitMPPrefix("target", toggle)
	ArchaeologistVars["TARGETMPJUSTVALUE"] = toggle;
end


function Archaeologist_TurnOffPetHPPrefix(toggle)
	Archaeologist_TurnOffUnitHPPrefix("pet", toggle)
	ArchaeologistVars["PETHPJUSTVALUE"] = toggle;
end

function Archaeologist_TurnOffPetMPPrefix(toggle)
	Archaeologist_TurnOffUnitMPPrefix("pet", toggle)
	ArchaeologistVars["PETMPJUSTVALUE"] = toggle;
end


-- <= == == == == == == == == == == == == =>
-- => Status HP/MP/XP Bar Overrides
-- <= == == == == == == == == == == == == =>

function OverrideShowStatusBarText(bar, toggle)
	if (toggle == 1) then
		SetStatusBarTextOverride(bar, 1);
	else
		SetStatusBarTextOverride(bar, nil);
	end
end

--[[unused.. yet
function OverrideHideStatusBarText(bar, toggle)
	if (toggle == 1) then
		SetStatusBarTextOverride(bar, 0);
	else
		SetStatusBarTextOverride(bar, nil);
	end
end
]]--

--sets the override for StatusBarTexts.
--override = nil removes override, 0 sets to hide, 1 sets to show
function SetStatusBarTextOverride(bar, override)
	if(not bar) then
		return;
	end
	if(override == "1" or override == 1 or override == "show") then
		bar.override = "show";
		--UIOptionsFrameCheckButtons["STATUS_BAR_TEXT"].value = "1"
		ShowTextStatusBarText(bar);
	elseif(override == "0" or override == 0 or override == "hide") then
		bar.override = "hide";
		HideTextStatusBarText(bar);
	else
		bar.override = nil;
		HideTextStatusBarText(bar);
	end
end


--updates old lockShow to the new override notation
local function ConvertLockShowToOverrideSyntax(bar)
	if (bar.textLockable) then
		bar.textLockable = nil;
	end
	if (bar.lockShow) then
		if (bar.lockShow == 1) then
			bar.override = "show";
		end
		bar.lockShow = nil;
	end
end


--allows the setting of textStatusBar.oneText to override other values if value = 1
--used to hide hp text of a ghost
--also added optional percents
function Archaeologist_TextStatusBar_UpdateTextString(textStatusBar)
	if ( not textStatusBar ) then
		textStatusBar = this;
	end
	local string = textStatusBar.TextString;
	if(string) then
		local value = textStatusBar:GetValue();
		local valueMin, valueMax = textStatusBar:GetMinMaxValues();
		if ( valueMax > 0 ) then
			textStatusBar:Show();
			if ( value == 0 and textStatusBar.zeroText ) then
				string:SetText(textStatusBar.zeroText);
				textStatusBar.isZero = 1;
				ShowTextStatusBarText(textStatusBar);
			elseif ( value == 1 and textStatusBar.oneText ) then
				string:SetText(textStatusBar.oneText);
				textStatusBar.isOne = 1;
				string:Show();
				ShowTextStatusBarText(textStatusBar);
			else
				textStatusBar.isZero = nil;
				textStatusBar.isOne = nil;
				
				local stringText = "";
				if (textStatusBar == TargetFrame.healthbar) and (valueMax == 100) then
					stringText = Sea.math.round(value / valueMax * 100).."%";
				elseif (Archaeologist_TextStringPercentStatusBars[textStatusBar:GetName()] == 1) then
					stringText = Sea.math.round(value / valueMax * 100).."%";
				else
					stringText = value.." / "..valueMax;
				end
				if ( textStatusBar.prefix ) then
					stringText = textStatusBar.prefix.." "..stringText;
				end
				string:SetText(stringText);
					
				if (textStatusBar.override == "show") then
					ShowTextStatusBarText(textStatusBar);
				else
					HideTextStatusBarText(textStatusBar);
				end
			end
		else
			textStatusBar:Hide();
		end
	end
end


--removes lockShow and adds override
function Archaeologist_ShowTextStatusBarText(bar)
	if ( bar and bar.TextString ) then
		ConvertLockShowToOverrideSyntax(bar);
		if (bar.override ~= "hide") then
			bar.TextString:Show();
		end
	end
end

--removes old lockShow, adds override, adds visibility for isOne, and removes UIOptions check
--effectively breaks the 'Show HP/Mana/XP Always Vislible' in the default UIOptions
function Archaeologist_HideTextStatusBarText(bar)
	if ( bar and bar.TextString ) then
		ConvertLockShowToOverrideSyntax(bar);
		if (bar.override == "hide") then
			bar.TextString:Hide();
		elseif (bar.isZero) or (bar.isOne) or (bar.override == "show") then
			bar.TextString:Show();
		else
			bar.TextString:Hide();
		end
	end
end


--sets bar.oneText
function SetTextStatusBarTextOneText(bar, oneText)
	if ( bar and bar.TextString ) then
		bar.oneText = oneText;
	end
end


-- <= == == == == == == == == == == == == =>
-- => Dead/Offline/Ghost Status Overrides
-- <= == == == == == == == == == == == == =>


function Archaeologist_TargetCheckDead()
	local unit = "target";
	local healthbar = ArchaeologistStatusBars[unit].frame.healthbar;
	local manabar = ArchaeologistStatusBars[unit].frame.manabar;
	local statusText = ArchaeologistStatusBars[unit].statusText;
	Archaeologist_UnitCheckDead(unit, statusText, healthbar, manabar);
end


function Archaeologist_PartyCheckDead(partyIndex)
	if (type(partyIndex) ~= "number")  then
		return;
	end
	local unit = "party"..partyIndex;
	local healthbar = ArchaeologistStatusBars[unit].frame.healthbar;
	local manabar = ArchaeologistStatusBars[unit].frame.manabar;
	local statusText = ArchaeologistStatusBars[unit].statusText;
	Archaeologist_UnitCheckDead(unit, statusText, healthbar, manabar);
end


function Archaeologist_UpdatePartyMembersDead()
	if (GetNumPartyMembers() > 0) then
		for i=1, GetNumPartyMembers() do
			Archaeologist_PartyCheckDead(i);
		end
	end
end


function Archaeologist_PlayerCheckDead()
	local unit = "player";
	local healthbar = ArchaeologistStatusBars[unit].frame.healthbar;
	local manabar = ArchaeologistStatusBars[unit].frame.manabar;
	local statusText = ArchaeologistStatusBars[unit].statusText;
	Archaeologist_UnitCheckDead(unit, statusText, healthbar, manabar);
end


function Archaeologist_PetCheckDead()
	local unit = "pet";
	local healthbar = ArchaeologistStatusBars[unit].frame.healthbar;
	local manabar = ArchaeologistStatusBars[unit].frame.manabar;
	local statusText = ArchaeologistStatusBars[unit].statusText;
	Archaeologist_UnitCheckDead(unit, statusText, healthbar, manabar);
end


function Archaeologist_UnitCheckDead(unit, statusText, healthbar, manabar)
	--adds Dead text if unit is Dead
	--adds Offline text if unit is a player and not connected
	--adds Ghost/Wisp text if unit is a player
	--Sea.io.print("CheckDead: "..unit);
	--Sea.io.print(this:GetName());
	
	if ( UnitIsDead(unit) ) and ( Archaeologist_UnitIsConnected(unit) ) then
	
		statusText:SetText(DEAD);
		statusText:Show();
		
		--hide health/mana if dead 
		SetTextStatusBarTextZeroText(healthbar, "");
		SetTextStatusBarTextZeroText(manabar, "");
		
	elseif ( UnitIsPlayer(unit) ) and ( not Archaeologist_UnitIsConnected(unit) ) then
		
		statusText:SetText(PLAYER_OFFLINE);
		healthbar:Hide();
		manabar:Hide();
		--!!!!!!!!!!!
		--^^ add a status bar hook to change this.
		--!!!!!!!!!!!
		statusText:Show();
		
		--hide health/mana if offline 
		SetTextStatusBarTextZeroText(healthbar, "");
		SetTextStatusBarTextZeroText(manabar, "");
		
	elseif ( UnitIsGhost(unit) ) then
	
		if ( UnitRace(unit) == "Night Elf" ) then
			statusText:SetText(PLAYER_WISP);
		else
			statusText:SetText(PLAYER_GHOST);
		end
		statusText:Show();

		--hide health/mana if ghost 
		SetTextStatusBarTextOneText(healthbar, "");
		SetTextStatusBarTextZeroText(manabar, "");
		
	else
	
		statusText:Hide();
		
		--show health/mana if not dead, offline or ghost
		SetTextStatusBarTextZeroText(healthbar, nil);
		SetTextStatusBarTextOneText(healthbar, nil);
		SetTextStatusBarTextZeroText(manabar, nil);
		
		--reset to override show
		ShowTextStatusBarText(healthbar);
		
	end
	
	TextStatusBar_UpdateTextString(healthbar);
	TextStatusBar_UpdateTextString(manabar);
	
end

function Archaeologist_UnitIsConnected(unit)
	ArchaeologistTooltip:SetUnit(unit);
	local tooltipOfflineLine = Sea.wow.tooltip.scan("ArchaeologistTooltip")[3];
	Sea.wow.tooltip.clear("ArchaeologistTooltip");
	local tooltipOfflineText;
	if ( tooltipOfflineLine ) then
		tooltipOfflineText = tooltipOfflineLine.left;
	end
	if (tooltipOfflineText == PLAYER_OFFLINE) then
		return;
	end
	return UnitIsConnected(unit);
end


-- <= == == == == == == == == == == == == =>
-- => Party and Pet Buffs
-- <= == == == == == == == == == == == == =>

function Archaeologist_PartyMemberFrame_RefreshBuffs()
	
	local texture;
	if ( ArchaeologistVars["PBUFFS"] == 1 ) then
		for i=1, MAX_PBUFFS do
			getglobal(this:GetName().."NewBuff"..i):Hide();
		end
	else
		for i=1, MAX_PBUFFS do
			texture = UnitBuff("party"..this:GetID(), i);
			if ( texture ) and (i <= ArchaeologistVars["PBUFFNUM"]) then
				getglobal(this:GetName().."NewBuff"..i.."Icon"):SetTexture(texture);
				getglobal(this:GetName().."NewBuff"..i):SetID(i);
				getglobal(this:GetName().."NewBuff"..i):Show();
			else
				getglobal(this:GetName().."NewBuff"..i):Hide();
			end
		end
	end
	
	if ( ArchaeologistVars["PDEBUFFS"] == 1 ) then
		for i=1, MAX_PDEBUFFS do
			getglobal(this:GetName().."NewDebuff"..i):Hide();
		end
	else
		local texture;
		for i=1, MAX_PDEBUFFS do
			texture = UnitDebuff("party"..this:GetID(), i);
			if (texture) and (i <= ArchaeologistVars["PDEBUFFNUM"]) then
				getglobal(this:GetName().."NewDebuff"..i.."Icon"):SetTexture(texture);
				getglobal(this:GetName().."NewDebuff"..i):SetID(i);
				getglobal(this:GetName().."NewDebuff"..i):Show();
			else
				getglobal(this:GetName().."NewDebuff"..i):Hide();
			end
		end
	end
	
end


function Archaeologist_PetFrame_RefreshBuffs()
	
	local texture;
	if ( ArchaeologistVars["PTBUFFS"] == 1 ) then
		for i=1, MAX_PTBUFFS do
			getglobal(this:GetName().."NewBuff"..i):Hide();
		end
	else
		for i=1, MAX_PTBUFFS do
			texture = UnitBuff("pet", i);
			if ( texture ) and (i <= ArchaeologistVars["PTBUFFNUM"]) then
				getglobal(this:GetName().."NewBuff"..i.."Icon"):SetTexture(texture);
				getglobal(this:GetName().."NewBuff"..i):SetID(i);
				getglobal(this:GetName().."NewBuff"..i):Show();
			else
				getglobal(this:GetName().."NewBuff"..i):Hide();
			end
		end
	end
	
	if ( ArchaeologistVars["PTDEBUFFS"] == 1 ) then
		for i=1, MAX_PTDEBUFFS do
			getglobal(this:GetName().."NewDebuff"..i):Hide();
		end
	else
		local texture;
		for i=1, MAX_PTDEBUFFS do
			texture = UnitDebuff("pet", i);
			if (texture) and (i <= ArchaeologistVars["PTDEBUFFNUM"]) then
				getglobal(this:GetName().."NewDebuff"..i.."Icon"):SetTexture(texture);
				getglobal(this:GetName().."NewDebuff"..i):SetID(i);
				getglobal(this:GetName().."NewDebuff"..i):Show();
			else
				getglobal(this:GetName().."NewDebuff"..i):Hide();
			end
		end
	end
	
end


function Archaeologist_UpdatePartyMemberBuffs()
	for i=1, MAX_PARTY_MEMBERS do
        if ( GetPartyMember(i) ) then
			this = getglobal("PartyMemberFrame"..i);
            Archaeologist_PartyMemberFrame_RefreshBuffs()
        end
    end
end

function Archaeologist_UpdatePetBuffs()
	this = PetFrame;
	Archaeologist_PetFrame_RefreshBuffs()
end


function Archaeologist_PartyMemberBuffs_Update()
	--only show buff tooltip on mouseover if buffs are hidden
	if (arg1 == "pet") then
		return (ArchaeologistVars["PTBUFFS"] == 1);
	end
	return (ArchaeologistVars["PBUFFS"] == 1);
end


function Archaeologist_TurnOffPartyBuffs(toggle)
	ArchaeologistVars["PBUFFS"] = toggle;
	Archaeologist_UpdatePartyMemberBuffs();
end

function Archaeologist_TurnOffPetBuffs(toggle)
	ArchaeologistVars["PTBUFFS"] = toggle;
	Archaeologist_UpdatePetBuffs();
end


function Archaeologist_TurnOffPartyDebuffs(toggle)
	ArchaeologistVars["PDEBUFFS"] = toggle;
	Archaeologist_UpdatePartyMemberBuffs();
end

function Archaeologist_TurnOffPetDebuffs(toggle)
	ArchaeologistVars["PTDEBUFFS"] = toggle;
	Archaeologist_UpdatePetBuffs();
end


function Archaeologist_SetPartyBuffs(toggle, count)
	if (count) then
		ArchaeologistVars["PBUFFNUM"] = count;
		Archaeologist_UpdatePartyMemberBuffs();
	end
end

function Archaeologist_SetPetBuffs(toggle, count)
	if (count) then
		ArchaeologistVars["PTBUFFNUM"] = count;
		Archaeologist_UpdatePetBuffs();
	end
end


function Archaeologist_SetPartyDebuffs(toggle, count)
	if (count) then
		ArchaeologistVars["PDEBUFFNUM"] = count;
		Archaeologist_UpdatePartyMemberBuffs();
	end
end

function Archaeologist_SetPetDebuffs(toggle, count)
	if (count) then
		ArchaeologistVars["PTDEBUFFNUM"] = count;
		Archaeologist_UpdatePetBuffs();
	end
end

function Archaeologist_SetAltDebuffLocation(toggle)
	ArchaeologistVars["DEBUFFALT"] = toggle;
	if (toggle == 1) then
		PetFrameNewDebuff1:ClearAllPoints();
		PetFrameNewDebuff1:SetPoint("TOP", "PetFrameNewBuff1", "BOTTOM", 0, -2);
		for i=1, 4 do
			getglobal("PartyMemberFrame"..i.."NewDebuff1"):ClearAllPoints();
			getglobal("PartyMemberFrame"..i.."NewDebuff1"):SetPoint("TOP", "PartyMemberFrame"..i.."NewBuff1", "BOTTOM", 0, -2);
		end
	else
		PetFrameNewDebuff1:ClearAllPoints();
		PetFrameNewDebuff1:SetPoint("TOPLEFT", "PetFrame", "TOPLEFT", 120, -24);
		for i=1, 4 do
			getglobal("PartyMemberFrame"..i.."NewDebuff1"):ClearAllPoints();
			getglobal("PartyMemberFrame"..i.."NewDebuff1"):SetPoint("TOPLEFT", "PartyMemberFrame"..i, "TOPLEFT", 124, -14);
		end
	end
end



-- <= == == == == == == == == == == == == =>
-- => Helpful Funcs
-- <= == == == == == == == == == == == == =>

-- 1 => 0, 0 => 1
function BinaryInvert(oneZero)
	if oneZero == 1 then
		return 0;
	else 
		return 1;
	end
end

function Archaeologist_PartyIndexFromName(name)
	for i=1, GetNumPartyMembers() do
		if ( name == UnitName("party"..i) ) then
			return i;
		end
	end
end


function Archaeologist_PartyIndexFromUnit(unit)
	if (type(unit) == "string") then
		if ( strsub(unit,0, string.len(unit)-1) == "party" ) then
			local partyIndex = tonumber( strsub(unit,string.len(unit)) );
			return partyIndex;
		end
	end
end


function Archaeologist_PartyIndexFromFrame(frame)
	local frameName = frame:GetName();
	if (frameName) then
		if ( strsub(frameName,0, string.len(frameName)-1) == "PartyMemberFrame" ) then
			local frameIndex = frame:GetID();
			if (frameIndex > 0) then
				return frameIndex;
			end
		end
	end
end


-- <= == == == == == == == == == == == == =>
-- => Options Via Cosmos Or Slash Commands
-- <= == == == == == == == == == == == == =>

function Archaeologist_RegisterForCosmos()
		
	Cosmos_RegisterConfiguration(
		"COS_ARCHAEOLOGIST",
		"SECTION",
		TEXT(ARCHAEOLOGIST_CONFIG_SEP),
		TEXT(ARCHAEOLOGIST_CONFIG_SEP_INFO)
	);
	
	-- <= == == == == == == == == == == == =>
	-- => Looped Registering
	-- <= == == == == == == == == == == == =>
	
	local varPrefixes = { "PLAYER", "PARTY", "PET", "TARGET" };
	
	for index, varPrefix in varPrefixes do
	
		Cosmos_RegisterConfiguration(
			"COS_ARCHAEOLOGIST_"..varPrefix.."_SEPARATOR",
			"SEPARATOR",
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP")),
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"))
		);
		
		for index, var in ArchaeologistVarData do
			if (type(index) == "string") then
				if (strsub(index, 0, string.len(varPrefix)) == varPrefix) then

					Cosmos_RegisterConfiguration(
						ArchaeologistVarData[index].cosmos,					--CVar
						"CHECKBOX",											--Things to use
						TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..index)),
						TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..index.."_INFO")),
						ArchaeologistVarData[index].func,					--Callback
						ArchaeologistVars[index]							--Default Checked/Unchecked
					);
					
				end
			end
		end
		
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Alternate Options Registering
	-- <= == == == == == == == == == == == =>

	local varPrefix = "ALTOPTS";
	
	Cosmos_RegisterConfiguration(
		"COS_ARCHAEOLOGIST_"..varPrefix.."_SEPARATOR",
		"SEPARATOR",
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP")),
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"))
	);
	
	varPrefixes = { "HPCOLOR", "DEBUFFALT", "HPMPALT" };
	
	for index, varPrefix in varPrefixes do
	
		Cosmos_RegisterConfiguration(
			ArchaeologistVarData[varPrefix].cosmos,						--CVar
			"CHECKBOX",													--Things to use
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix)),
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_INFO")),
			ArchaeologistVarData[varPrefix].func,						--Callback
			ArchaeologistVars[varPrefix]								--Default Checked/Unchecked
		);
	
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Party Buff Registering
	-- <= == == == == == == == == == == == =>
	
	varPrefix = "PARTYBUFFS";
	
	Cosmos_RegisterConfiguration(
		"COS_ARCHAEOLOGIST_"..varPrefix.."_SEPARATOR",
		"SEPARATOR",
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP")),
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"))
	);
	
	varPrefixes = { "PBUFF", "PDEBUFF" };
	
	for index, varPrefix in varPrefixes do
	
		Cosmos_RegisterConfiguration(
			ArchaeologistVarData[varPrefix.."S"].cosmos,					--CVar
			"CHECKBOX",														--Things to use
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S")),
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S".."_INFO")),
			ArchaeologistVarData[varPrefix.."S"].func,						--Callback
			ArchaeologistVars[varPrefix.."S"]								--Default Checked/Unchecked
		);
	
		Cosmos_RegisterConfiguration(
			ArchaeologistVarData[varPrefix.."NUM"].cosmos,								-- CVar
			"SLIDER",														-- Type
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM")),				-- Short description
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM_INFO")),		-- Long description
			ArchaeologistVarData[varPrefix.."NUM"].func,								-- Callback
			1,																-- Default Checked/Unchecked
			ArchaeologistVars[varPrefix.."NUM"],										-- Default slider value
			TEXT(getglobal("MIN_"..varPrefix.."S")),									-- Minimum slider value
			TEXT(getglobal("MAX_"..varPrefix.."S")),									-- max value
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM_SLIDER_TEXT")),	-- slider "header" text
			1,						-- Slider steps
			1,						-- Text on slider?
			"",						-- slider text append
			1						-- slider multiplier
		);
		
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Pet Buff Registering
	-- <= == == == == == == == == == == == =>
	
	varPrefix = "PETBUFFS";
	
	Cosmos_RegisterConfiguration(
		"COS_ARCHAEOLOGIST_"..varPrefix.."_SEPARATOR",
		"SEPARATOR",
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP")),
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"))
	);
	
	varPrefixes = { "PTBUFF", "PTDEBUFF" };
	
	for index, varPrefix in varPrefixes do
	
		Cosmos_RegisterConfiguration(
			ArchaeologistVarData[varPrefix.."S"].cosmos,					--CVar
			"CHECKBOX",														--Things to use
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S")),
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S".."_INFO")),
			ArchaeologistVarData[varPrefix.."S"].func,						--Callback
			ArchaeologistVars[varPrefix.."S"]								--Default Checked/Unchecked
		);
	
		Cosmos_RegisterConfiguration(
			ArchaeologistVarData[varPrefix.."NUM"].cosmos,								-- CVar
			"SLIDER",														-- Type
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM")),				-- Short description
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_INFO")),		-- Long description
			ArchaeologistVarData[varPrefix.."NUM"].func,								-- Callback
			1,																-- Default Checked/Unchecked
			ArchaeologistVars[varPrefix.."NUM"],										-- Default slider value
			TEXT(getglobal("MIN_"..varPrefix.."S")),									-- Minimum slider value
			TEXT(getglobal("MAX_"..varPrefix.."S")),									-- max value
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_SLIDER_TEXT")),	-- slider "header" text
			1,						-- Slider steps
			1,						-- Text on slider?
			"",						-- slider text append
			1						-- slider multiplier
		);
		
	end

	
end


function Archaeologist_RegisterForSlashCommands()
	
	SlashCmdList["ARCHHELP"] = Archaeologist_Slash_ArchHelp;
    SLASH_ARCHHELP1 = "/archhelp";
	
	SlashCmdList["ARCHPLAYER"] = Archaeologist_Slash_ArchPlayer;
    SLASH_ARCHPLAYER1 = "/archplayer";
	
	SlashCmdList["ARCHPARTY"] = Archaeologist_Slash_ArchParty;
    SLASH_ARCHPARTY1 = "/archparty";
	
	SlashCmdList["ARCHPET"] = Archaeologist_Slash_ArchPet;
    SLASH_ARCHPET1 = "/archpet";
	
	SlashCmdList["ARCHTARGET"] = Archaeologist_Slash_ArchTarget;
    SLASH_ARCHTARGET1 = "/archtarget";
	
	SlashCmdList["ARCHOPTIONS"] = Archaeologist_Slash_Arch;
    SLASH_ARCHOPTIONS1 = "/arch";

end



-- <= == == == == == == == == == == == == =>
-- => Slash Commands
-- <= == == == == == == == == == == == == =>

function Archaeologist_Slash_ArchHelp()

	local color = {r = 0, g = 1, b = 0.2};
	Sea.io.printc(color,"Archaeologist Help");
	Sea.io.printc(color,"----------------------------------------------");
	Sea.io.printc(color,"*** Player Options ***");
	Sea.io.printc(color,"/archplayer text [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archplayer percent [hp/mp/xp] [on/off/toggle]");
	Sea.io.printc(color,"/archplayer prefix [hp/mp/xp] [on/off/toggle]");
	Sea.io.printc(color,"*** Party Options ***");
	Sea.io.printc(color,"/archparty text [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archparty percent [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archparty prefix [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archparty [buffs/debuffs] [on/off/toggle/#]");
	Sea.io.printc(color,"*** Pet Options ***");
	Sea.io.printc(color,"/archpet text [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archpet percent [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archpet prefix [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archpet [buffs/debuffs] [on/off/toggle/#]");
	Sea.io.printc(color,"*** Target Options ***");
	Sea.io.printc(color,"/archtarget text [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archtarget percent [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"/archtarget prefix [hp/mp] [on/off/toggle]");
	Sea.io.printc(color,"*** Special Options ***");
	Sea.io.printc(color,"/arch [hpcolor/debuffalt/hpmpalt] [on/off/toggle]");

end

function Archaeologist_Slash_Toggle(var, onVal, status)
	if (var) and (onVal) and (status) then
		--Sea.io.print(var.." "..status.."("..onVal..")");
		if (ArchaeologistVarData[var].func) then
			if (status == "ON") then
				ArchaeologistVarData[var].func(onVal);
				ArchaeologistVars[var] = onVal;
			elseif (status == "OFF") then
				ArchaeologistVarData[var].func(BinaryInvert(onVal));
				ArchaeologistVars[var] = BinaryInvert(onVal);
			elseif (status == "TOGGLE") then
				local val = BinaryInvert(ArchaeologistVars[var])
				ArchaeologistVarData[var].func(val);
				ArchaeologistVars[var] = val;
			else
				Archaeologist_Slash_ArchHelp();
				return;
			end
		else
			--some internal error with the function not being found
			Sea.io.print("Error: Toggle Function Not Found");
			return;
		end
		local readValue = "OFF";
		if (ArchaeologistVars[var] == onVal) then
			readValue = "ON";
		end
		Sea.io.print(getglobal("ARCHAEOLOGIST_CONFIG_"..var).." "..readValue);
		Archaeologist_VarSync_VarsToCosmos();
	end
end


function Archaeologist_Slash_ArchPlayer(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, option, type, status = string.find(msg, "(%w+) (%w+) (%w+)");
	if (option) and (type) and (status) then
	
		if (option == "TEXT") then
			onVal = 1;
			if (type == "HP") then
				var = "PLAYERHP";
			elseif (type == "MP") then
				var = "PLAYERMP";
			elseif (type == "XP") then
				var = "PLAYERXP";
			end
		
		elseif (option == "PERCENT") then
			onVal = 1;
			if (type == "HP") then
				var = "PLAYERHPP";
			elseif (type == "MP") then
				var = "PLAYERMPP";
			elseif (type == "XP") then
				var = "PLAYERXPP";
			end
			
		elseif (option == "PREFIX") then
			onVal = 0;
			if (type == "HP") then
				var = "PLAYERHPJUSTVALUE";
			elseif (type == "MP") then
				var = "PLAYERMPJUSTVALUE";
			elseif (type == "XP") then
				var = "PLAYERXPJUSTVALUE";
			end
			
		end
		
	end
	if (var) and (onVal) and (status) then
		Archaeologist_Slash_Toggle(var, onVal, status);
	else
		Archaeologist_Slash_ArchHelp();
	end
end


function Archaeologist_Slash_ArchParty(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, option, type, status = string.find(msg, "(%w+) (%w+) (%w+)");
	if (option) and (type) and (status) then
	
		if (option == "TEXT") then
			onVal = 1;
			if (type == "HP") then
				var = "PARTYHP";
			elseif (type == "MP") then
				var = "PARTYMP";
			end
		
		elseif (option == "PERCENT") then
			onVal = 1;
			if (type == "HP") then
				var = "PARTYHPP";
			elseif (type == "MP") then
				var = "PARTYMPP";
			end
			
		elseif (option == "PREFIX") then
			onVal = 0;
			if (type == "HP") then
				var = "PARTYHPJUSTVALUE";
			elseif (type == "MP") then
				var = "PARTYMPJUSTVALUE";
			end
			
		end
	else
		startpos, endpos, option, number = string.find(msg, "(%w+) (%d+)");
		if (option) and (number) then
		
			if (option == "BUFFS") then
				var = "PBUFFNUM";
			elseif (option == "DEBUFFS") then
				var = "PDEBUFFNUM";
			else
				Archaeologist_Slash_ArchHelp();
				return;
			end
			if (number < MIN_PBUFFS) then
				number = MIN_PBUFFS;
			elseif (number > MAX_PBUFFS) then
				number = MAX_PBUFFS;
			end
			ArchaeologistVarData[var].func(1, number);
			ArchaeologistVars[var] = number;
			Sea.io.print(getglobal("ARCHAEOLOGIST_CONFIG_"..var).." "..number);
			Archaeologist_VarSync_VarsToCosmos();
			return;
			
		else
			startpos, endpos, option, status = string.find(msg, "(%w+) (%w+)");
			if (option) and (status) then
			
				if (option == "BUFFS") then
					onVal = 0;
					var = "PBUFFS";
					
				elseif (option == "DEBUFFS") then
					onVal = 0;
					var = "PDEBUFFS";
					
				end
			end
		end
	end
	if (var) and (onVal) and (status) then
		Archaeologist_Slash_Toggle(var, onVal, status);
	else
		Archaeologist_Slash_ArchHelp();
	end
end


function Archaeologist_Slash_ArchPet(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, option, type, status = string.find(msg, "(%w+) (%w+) (%w+)");
	if (option) and (type) and (status) then
	
		if (option == "TEXT") then
			onVal = 1;
			if (type == "HP") then
				var = "PETHP";
			elseif (type == "MP") then
				var = "PETMP";
			end
		
		elseif (option == "PERCENT") then
			onVal = 1;
			if (type == "HP") then
				var = "PETHPP";
			elseif (type == "MP") then
				var = "PETMPP";
			end
			
		elseif (option == "PREFIX") then
			onVal = 0;
			if (type == "HP") then
				var = "PETHPJUSTVALUE";
			elseif (type == "MP") then
				var = "PETMPJUSTVALUE";
			end
			
		end
	
	else
		startpos, endpos, option, number = string.find(msg, "(%w+) (%d+)");
		if (option) and (number) then
		
			if (option == "BUFFS") then
				var = "PTBUFFNUM";
			elseif (option == "DEBUFFS") then
				var = "PTDEBUFFNUM";
			else
				Archaeologist_Slash_ArchHelp();
				return;
			end
			number = tonumber(number);
			if (number < MIN_PTBUFFS) then
				number = MIN_PTBUFFS;
			elseif (number > MAX_PBUFFS) then
				number = MAX_PTBUFFS;
			end
			
			ArchaeologistVarData[var].func(1, number);
			ArchaeologistVars[var] = number;
			Sea.io.print(getglobal("ARCHAEOLOGIST_CONFIG_"..var).." "..number);
			Archaeologist_VarSync_VarsToCosmos();
			return;
			
		else
			startpos, endpos, option, status = string.find(msg, "(%w+) (%w+)");
			if (option) and (status) then
			
				if (option == "BUFFS") then
					onVal = 0;
					var = "PTBUFFS";
					
				elseif (option == "DEBUFFS") then
					onVal = 0;
					var = "PTDEBUFFS";
					
				end
			end
		end
	end
	if (var) and (onVal) and (status) then
		Archaeologist_Slash_Toggle(var, onVal, status);
	else
		Archaeologist_Slash_ArchHelp();
	end
end


function Archaeologist_Slash_ArchTarget(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, option, type, status = string.find(msg, "(%w+) (%w+) (%w+)");
	if (option) and (type) and (status) then
	
		if (option == "TEXT") then
			onVal = 1;
			if (type == "HP") then
				var = "TARGETHP";
			elseif (type == "MP") then
				var = "TARGETMP";
			end
		
		elseif (option == "PERCENT") then
			onVal = 1;
			if (type == "HP") then
				var = "TARGETHPP";
			elseif (type == "MP") then
				var = "TARGETMPP";
			end
			
		elseif (option == "PREFIX") then
			onVal = 0;
			if (type == "HP") then
				var = "TARGETHPJUSTVALUE";
			elseif (type == "MP") then
				var = "TARGETMPJUSTVALUE";
			end
			
		end
		
	end
	if (var) and (onVal) and (status) then
		Archaeologist_Slash_Toggle(var, onVal, status);
	else
		Archaeologist_Slash_ArchHelp();
	end
end


function Archaeologist_Slash_Arch(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, option, status = string.find(msg, "(%w+) (%w+)");
	if (option) and (type) and (status) then
	
		if (option == "HPCOLOR") then
			onVal = 1;
			var = "HPCOLOR";
		
		elseif (option == "DEBUFFALT") then
			onVal = 1;
			var = "DEBUFFALT";
			
		elseif (option == "HPMPALT") then
			onVal = 1;
			var = "HPMPALT";
		end
		
	end
	if (var) and (onVal) and (status) then
		Archaeologist_Slash_Toggle(var, onVal, status);
	else
		Archaeologist_Slash_ArchHelp();
	end
end


