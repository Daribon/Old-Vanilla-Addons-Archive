--------------------------------------------------------------------------
-- Archaeologist.lua 
--------------------------------------------------------------------------
--[[
Archaeologist 
	Unearthing Health and Mana values at a unit frame near you.

By: AnduinLothar    <KarlKFI@cosmosui.org>

Change Log:
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

v0.4aC:\Program Files\World of Warcraft\Interface\AddOns
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

v1.1
-Added German Localization
-Sorting of cosmos options.
-Auto Pet Happiness Alt Location Management

v1.2
-Added French Localization
-Fixed ArchaeologistVars = nil error
-Text is now resizable from 6-20.
Note: due to a blizzard text resizing bug the text will not propperly smooth/rescale once changed.
To correct it go to windowed mode and back to fullscreen.  I have notified Blizzard of the bug.
-Made Party/Pet Buff borders green. Debuffs are still red.

v1.3
-Added 8 Buffs and 8 Debuffs for target frame.
-Target Buffs slightly rearanged. They now extend from right to left so that the 3 extra buffs don't
get covered by the portrait and elite graphics.
-Increased Pet and Party Max buffs/debuffs to 14

v1.4
-Fixed the bug that hid status text while moused over.
-Fixed the bug that hid status text while the character frame was open.

v1.41
-Implimented Smooth Text Resizing Work-around

v1.42
-Fixed a bug with loading default values from the new text sliders w/o cosmos.

v1.43
-Fixed a bigger bug with values not saving with slash commands and cosmos.

v1.5
-Made Target Buffs on top if targeting an ally and Debuffs on top if targeting an enemy.
-Added an alternate option for target buffs to display from right to left. Default is left to right.
-Fixed/Avoided MouseOver hook so that Arch plays nicely with mouse over offsets.

v1.6
-Added Optional use of the MobHealth2 addon if you are usign it.
http://www.curse-gaming.com/mod.php?addid=1087

v1.7
-Added Khaos configuration options
-Updated to work with cosmos MobHealth addon
-No longer displays 0/0 if the health is unknown
-Fixed manabar nil bug.

v1.8
-Added optional class icons to the Player, Party and Target Frames

v1.9
-Added optional replacement of unit portraits with large class icons
-Raised Target Buffs slightly to be above the Target portait
-Fixed a nil bug when using class icons on party members.

2.0
-Updated TOC to 1700
-Increased Target Buff and Debuff max to 16
-Added 16 PartyPet Buffs and Debuffs
-Added Party Pet Buffs/Debuffs mouseover only option
-Updated all Buffs and Debuffs to 16 max
-Added Primary and Secondary Text Displays for every StatusBar
-AltTextLocation now swaps % and value
-Added Text Inversion for all StatusBars (Show how much is missing in % or value)
-Now works with the MobHealth inbedded in MobInfo2
-Added dynamic font changing (dropdown in khaos)
[Note if you change the font the font shadow will dissapear. To get it back change the font to default and ReloadUI.]
-Added font coloring (color wheel in khaos)
-If in default positions PartyPets, PartyMembers and Target Frames are slightly relocated to make room for Text and Buffs
-Added Options to either show percent, value, both or neither on the XP bar
-Increased the Frame Level of Target Debuffs to be above the Target Frame
-Added Target debuff aplication overlays

Known Bugs: Party Pet Buff/Debuff tooltips don't show. Need to update slash commands for v2.0 options.


	$Id: Archaeologist.lua 2454 2005-09-15 21:19:36Z karlkfi $
	$Rev: 2454 $
	$LastChangedBy: karlkfi $
	$Date: 2005-09-15 16:19:36 -0500 (Thu, 15 Sep 2005) $

]]--

-- <= == == == == == == == == == == == == =>
-- => Global Variables
-- <= == == == == == == == == == == == == =>

Archaeologist_TextStringPercentStatusBars = { };
Archaeologist_TextStringValueStatusBars = { };
Archaeologist_TextStringInvertStatusBars = { };

ArchaeologistStatusBars = { };
ArchaeologistOptionSetName = "Archaeologist";

ArchaeologistFonts = { 
	GameFontNormal = "Fonts\\FRIZQT__.TTF";
	NumberFontNormal = "Fonts\\ARIALN.TTF";
	ItemTextFontNormal = "Fonts\\MORPHEUS.TTF";
};

function Archaeologist_DefineStatusBars()

	ArchaeologistStatusBars.player  = { frame = PlayerFrame, statusText = PlayerStatusText };
	ArchaeologistStatusBars.party1  = { frame = PartyMemberFrame1, statusText = PartyMemberFrame1.statusText };
	ArchaeologistStatusBars.party2  = { frame = PartyMemberFrame2, statusText = PartyMemberFrame2.statusText };
	ArchaeologistStatusBars.party3  = { frame = PartyMemberFrame3, statusText = PartyMemberFrame3.statusText };
	ArchaeologistStatusBars.party4  = { frame = PartyMemberFrame4, statusText = PartyMemberFrame4.statusText };
	ArchaeologistStatusBars.pet		= { frame = PetFrame, statusText = PetStatusText };
	ArchaeologistStatusBars.target  = { frame = TargetFrame, statusText = TargetDeadText };

end

Archaeologist_TargetBuffsAreOnTop = false;

-- <= == == == == == == == == == == == == =>
-- => Variable Sync Tables
-- <= == == == == == == == == == == == == =>

ArchaeologistVars = { };
ArchaeologistVarData = { };

function Archaeologist_DefineVarData()
	ArchaeologistVarData = {

		PLAYERHP = { khaos = "PlayerHpEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERHP", default = 0, func = Archaeologist_TurnOnPlayerHP },
		PLAYERHP2 = { khaos = "PlayerHp2Enable", cosmos = "COS_ARCHAEOLOGIST_PLAYERHP2", default = 0, func = Archaeologist_TurnOnPlayerHP2 },
		PLAYERMP = { khaos = "PlayerMpEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERMP", default = 0, func = Archaeologist_TurnOnPlayerMP },
		PLAYERMP2 = { khaos = "PlayerMp2Enable", cosmos = "COS_ARCHAEOLOGIST_PLAYERMP2", default = 0, func = Archaeologist_TurnOnPlayerMP2 },
		PLAYERXP = { khaos = "PlayerXpEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERXP", default = 0, func = Archaeologist_TurnOnPlayerXP },
		PLAYERHPINVERT = { khaos = "PlayerHpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERHPINVERT", default = 0, func = Archaeologist_TurnOnPlayerHPInvert },
		PLAYERMPINVERT = { khaos = "PlayerMpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERMPINVERT", default = 0, func = Archaeologist_TurnOnPlayerMPInvert },
		PLAYERXPINVERT = { khaos = "PlayerXpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERXPINVERT", default = 0, func = Archaeologist_TurnOnPlayerXPInvert },
		PLAYERXPP = { khaos = "PlayerXpPercentEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERXPP", default = 0, func = Archaeologist_TurnOnPlayerXPPercent },
		PLAYERXPV = { khaos = "PlayerXpValueEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERXPV", default = 1, func = Archaeologist_TurnOnPlayerXPValue },
		PLAYERHPJUSTVALUE = { khaos = "PlayerHpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERHPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPlayerHPPrefix },
		PLAYERMPJUSTVALUE = { khaos = "PlayerMpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPlayerMPPrefix },
		PLAYERXPJUSTVALUE = { khaos = "PlayerXpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERXPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPlayerXPPrefix },
		PLAYERCLASSICON = { khaos = "PlayerClassIconEnable", cosmos = "COS_ARCHAEOLOGIST_PLAYERCLASSICON", default = 0, func = Archaeologist_TurnOnPlayerClassIcon },
		
		PARTYHP = { khaos = "PartyHpEnable", cosmos = "COS_ARCHAEOLOGIST_PARTYHP", default = 0, func = Archaeologist_TurnOnPartyHP },
		PARTYHP2 = { khaos = "PartyHp2Enable", cosmos = "COS_ARCHAEOLOGIST_PARTYHP2", default = 0, func = Archaeologist_TurnOnPartyHP2 },
		PARTYMP = { khaos = "PartyMpEnable", cosmos = "COS_ARCHAEOLOGIST_PARTYMP", default = 0, func = Archaeologist_TurnOnPartyMP },
		PARTYMP2 = { khaos = "PartyMp2Enable", cosmos = "COS_ARCHAEOLOGIST_PARTYMP2", default = 0, func = Archaeologist_TurnOnPartyMP2 },
		PARTYHPINVERT = { khaos = "PartyHpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_PARTYHPINVERT", default = 0, func = Archaeologist_TurnOnPartyHPInvert },
		PARTYMPINVERT = { khaos = "PartyMpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_PARTYMPINVERT", default = 0, func = Archaeologist_TurnOnPartyMPInvert },
		PARTYHPJUSTVALUE = { khaos = "PartyHpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_PARTYHPJUSTVALUE", default = 1, func = Archaeologist_TurnOffPartyHPPrefix },
		PARTYMPJUSTVALUE = { khaos = "PartyMpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_PARTYMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPartyMPPrefix },
		PARTYCLASSICON = { khaos = "PartyClassIconEnable", cosmos = "COS_ARCHAEOLOGIST_PARTYCLASSICON", default = 1, func = Archaeologist_TurnOnPartyClassIcon },
		
		PETHP = { khaos = "PetHpEnable", cosmos = "COS_ARCHAEOLOGIST_PETHP", default = 0, func = Archaeologist_TurnOnPetHP },
		PETHP2 = { khaos = "PetHp2Enable", cosmos = "COS_ARCHAEOLOGIST_PETHP2", default = 0, func = Archaeologist_TurnOnPetHP2 },
		PETMP = { khaos = "PetMpEnable", cosmos = "COS_ARCHAEOLOGIST_PETMP", default = 0, func = Archaeologist_TurnOnPetMP },
		PETMP2 = { khaos = "PetMp2Enable", cosmos = "COS_ARCHAEOLOGIST_PETMP2", default = 0, func = Archaeologist_TurnOnPetMP2 },
		PETHPINVERT = { khaos = "PetHpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_PETHPINVERT", default = 0, func = Archaeologist_TurnOnPetHPInvert },
		PETMPINVERT = { khaos = "PetMpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_PETMPINVERT", default = 0, func = Archaeologist_TurnOnPetMPInvert },
		PETHPJUSTVALUE = { khaos = "PetHpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_PETHPJUSTVALUE", default = 1, func = Archaeologist_TurnOffPetHPPrefix },
		PETMPJUSTVALUE = { khaos = "PetMpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_PETMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffPetMPPrefix },
		
		TARGETHP = { khaos = "TargetHpEnable", cosmos = "COS_ARCHAEOLOGIST_TARGETHP", default = 0, func = Archaeologist_TurnOnTargetHP },
		TARGETHP2 = { khaos = "TargetHp2Enable", cosmos = "COS_ARCHAEOLOGIST_TARGETHP2", default = 0, func = Archaeologist_TurnOnTargetHP2 },
		TARGETMP = { khaos = "TargetMpEnable", cosmos = "COS_ARCHAEOLOGIST_TARGETMP", default = 0, func = Archaeologist_TurnOnTargetMP },
		TARGETMP2 = { khaos = "TargetMp2Enable", cosmos = "COS_ARCHAEOLOGIST_TARGETMP2", default = 0, func = Archaeologist_TurnOnTargetMP2 },
		TARGETHPINVERT = { khaos = "TargetHpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_TARGETHPINVERT", default = 0, func = Archaeologist_TurnOnTargetHPInvert },
		TARGETMPINVERT = { khaos = "TargetMpInvertEnable", cosmos = "COS_ARCHAEOLOGIST_TARGETMPINVERT", default = 0, func = Archaeologist_TurnOnTargetMPInvert },
		TARGETHPJUSTVALUE = { khaos = "TargetHpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_TARGETHPJUSTVALUE", default = 1, func = Archaeologist_TurnOffTargetHPPrefix },
		TARGETMPJUSTVALUE = { khaos = "TargetMpPrefixEnable", cosmos = "COS_ARCHAEOLOGIST_TARGETMPJUSTVALUE", default = 0, func = Archaeologist_TurnOffTargetMPPrefix },
		TARGETCLASSICON = { khaos = "TargetClassIconEnable", cosmos = "COS_ARCHAEOLOGIST_TARGETCLASSICON", default = 1, func = Archaeologist_TurnOnTargetClassIcon },
		
		HPCOLOR = { khaos = "HealthGradientEnable", cosmos = "COS_ARCHAEOLOGIST_HPCOLOR", default = 0, func = Archaeologist_TurnOnHPColorMod },
		
		PBUFFS = { khaos = "PartyBuffEnable", cosmos = "COS_ARCHAEOLOGIST_PBUFFS", default = 0, func = Archaeologist_TurnOffPartyBuffs },
		PBUFFNUM = { khaos = "PartyBuffCount", dependencies = {["PartyBuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_PBUFFNUM", default = 16, min = 0, max = 16, func = Archaeologist_SetPartyBuffs },
		
		PDEBUFFS = { khaos = "PartyDebuffEnable", cosmos = "COS_ARCHAEOLOGIST_PDEBUFFS", default = 0, func = Archaeologist_TurnOffPartyDebuffs },
		PDEBUFFNUM = { khaos = "PartyDebuffCount", dependencies = {["PartyDebuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_PDEBUFFNUM", default = 16, min = 0, max = 16, func = Archaeologist_SetPartyDebuffs },
		
		PPTBUFFS = { khaos = "PartyPetBuffEnable", cosmos = "COS_ARCHAEOLOGIST_PPTBUFFS", default = 0, func = Archaeologist_TurnOffPartyPetBuffs },
		PPTBUFFNUM = { khaos = "PartyPetBuffCount", dependencies = {["PartyPetBuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_PPTBUFFNUM", default = 16, min = 0, max = 16, func = Archaeologist_SetPartyPetBuffs },
		
		PPTDEBUFFS = { khaos = "PartyPetDebuffEnable", cosmos = "COS_ARCHAEOLOGIST_PPTDEBUFFS", default = 0, func = Archaeologist_TurnOffPartyPetDebuffs },
		PPTDEBUFFNUM = { khaos = "PartyPetDebuffCount", dependencies = {["PartyPetDebuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_PPTDEBUFFNUM", default = 16, min = 0, max = 16, func = Archaeologist_SetPartyPetDebuffs },
		
		PTBUFFS = { khaos = "PetBuffEnable", cosmos = "COS_ARCHAEOLOGIST_PTBUFFS", default = 0, func = Archaeologist_TurnOffPetBuffs },
		PTBUFFNUM = { khaos = "PetBuffCount", dependencies = {["PetBuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_PTBUFFNUM", default = 16, min = 0, max = 16, func = Archaeologist_SetPetBuffs },
		
		PTDEBUFFS = { khaos = "PetDebuffEnable", cosmos = "COS_ARCHAEOLOGIST_PTDEBUFFS", default = 0, func = Archaeologist_TurnOffPetDebuffs },
		PTDEBUFFNUM = { khaos = "PetDebuffCount", dependencies = {["PetDebuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_PTDEBUFFNUM", default = 4, min = 0, max = 16, func = Archaeologist_SetPetDebuffs },
		
		TBUFFS = { khaos = "TargetBuffEnable", cosmos = "COS_ARCHAEOLOGIST_TBUFFS", default = 0, func = Archaeologist_TurnOffTargetBuffs },
		TBUFFNUM = { khaos = "TargetBuffCount", dependencies = {["TargetBuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_TBUFFNUM", default = 8, min = 0, max = 16, func = Archaeologist_SetTargetBuffs },
		
		TDEBUFFS = { khaos = "TargetDebuffEnable", cosmos = "COS_ARCHAEOLOGIST_TDEBUFFS", default = 0, func = Archaeologist_TurnOffTargetDebuffs },
		TDEBUFFNUM = { khaos = "TargetDebuffCount", dependencies = {["TargetDebuffEnable"]={checked=false}}; cosmos = "COS_ARCHAEOLOGIST_TDEBUFFNUM", default = 16, min = 0, max = 16, func = Archaeologist_SetTargetDebuffs },
		
		DEBUFFALT = { khaos = "DebuffRelocateEnable", cosmos = "COS_ARCHAEOLOGIST_DEBUFFALT", default = 0, func = Archaeologist_SetAltDebuffLocation },
		TBUFFALT = { khaos = "TargetBuffAlignment", cosmos = "COS_ARCHAEOLOGIST_TBUFFALT", default = 0, func = Archaeologist_TargetBuffs_SetAltHorizontalAlignment },
		CLASSPORTRAIT = { khaos = "ClassPortrait", cosmos = "COS_ARCHAEOLOGIST_CLASSPORTRAIT", default = 0, func = Archaeologist_EnableClassPortrait },
		HPMPALT = { khaos = "RelocateHpMpText", cosmos = "COS_ARCHAEOLOGIST_HPMPALT", default = 0, func = Archaeologist_SetAltHPMPLocation },
		HPMPLARGESIZE = { khaos = "LargeTextSize", cosmos = "COS_ARCHAEOLOGIST_HPMPLARGESIZE", default = 14, min = 6, max = 20, func = Archaeologist_SetHPMPLargeTextSize },
		HPMPSMALLSIZE = { khaos = "SmallTextSize", cosmos = "COS_ARCHAEOLOGIST_HPMPSMALLSIZE", default = 14, min = 6, max = 20, func = Archaeologist_SetHPMPSmallTextSize },
		HPMPLARGEFONT = { khaos = "LargeFontSelect", default = "Default", func = Archaeologist_SetHPMPLargeFont },
		HPMPSMALLFONT = { khaos = "SmallFontSelect", default = "Default", func = Archaeologist_SetHPMPSmallFont },
		COLORPHP = { khaos = "PrimaryHpColorSelect", default = {r=1,g=1,b=1,opacity=1}, func = Archaeologist_SetPrimaryHPColor },
		COLORPMP = { khaos = "PrimaryMpColorSelect", default = {r=1,g=1,b=1,opacity=1}, func = Archaeologist_SetPrimaryMPColor },
		COLORSHP = { khaos = "SecondaryHpColorSelect", default = {r=1,g=1,b=1,opacity=1}, func = Archaeologist_SetSecondaryHPColor },
		COLORSMP = { khaos = "SecondaryMpColorSelect", default = {r=1,g=1,b=1,opacity=1}, func = Archaeologist_SetSecondaryMPColor },
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
	Sea.util.hook( "CharacterFrame_OnShow", "Archaeologist_CharacterFrame_OnShow", "replace" );
	Sea.util.hook( "CharacterFrame_OnHide", "Archaeologist_CharacterFrame_OnHide", "replace" );
	Sea.util.hook( "UnitFrame_UpdateManaType", "Archaeologist_UnitFrame_UpdateManaType", "replace" );
	
	Sea.util.hook( "PartyMemberFrame_RefreshBuffs", "Archaeologist_PartyMemberFrame_RefreshBuffs", "replace" );
	Sea.util.hook( "PartyMemberFrame_RefreshPetBuffs", "Archaeologist_PartyMemberFrame_RefreshPetBuffs", "replace" );
	Sea.util.hook( "PetFrame_RefreshBuffs", "Archaeologist_PetFrame_RefreshBuffs", "replace" );
	Sea.util.hook( "PartyMemberBuffTooltip_Update", "Archaeologist_PartyMemberBuffs_Update", "replace" );
	Sea.util.hook( "ShowPartyFrame", "Archaeologist_UpdatePartyMemberBuffs", "after" );
	Sea.util.hook( "TargetDebuffButton_Update", "Archaeologist_TargetDebuffButton_Update", "replace" );
	Sea.util.hook( "PartyMemberFrame_UpdatePet", "Archaeologist_PartyMemberFrame_UpdatePet", "replace" );
	
	Sea.util.hook( "UnitFrame_Update", "Archaeologist_UnitFrame_Update_After", "after" );
	Sea.util.hook( "UnitFrame_OnEvent", "Archaeologist_UnitFrame_OnEvent_After", "after" );
	Sea.util.hook( "UnitFrame_OnEnter", "Archaeologist_UnitFrame_PartyPet_CheckMouseover", "after" );
	Sea.util.hook( "UnitFrame_OnLeave", "Archaeologist_UnitFrame_PartyPet_CheckMouseover", "after" );
	Sea.util.hook( "SetTextStatusBarText", "Archaeologist_SetTextStatusBarText", "after" );
	
	--HealthBar_OnValueChanged manual hook to modify input
	if (HealthBar_OnValueChanged ~= SavedHealthBar_OnValueChanged) then
		SavedHealthBar_OnValueChanged = HealthBar_OnValueChanged;
		HealthBar_OnValueChanged = Archaeologist_HealthBar_OnValueChanged;
	end
	
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	this:RegisterEvent("PARTY_MEMBER_ENABLE");
	this:RegisterEvent("UNIT_AURA");
	
	Archaeologist_DefineVarData();
	Archaeologist_InitializeAddedStatusBarTexts();
	Archaeologist_DefineStatusBars();
	Archaeologist_HookStatusBars_OnLeave(); -- Add Hiding Handlers for 2ndary Displays
	Archaeologist_RegisterForSlashCommands();
	Archaeologist_VarSync_SavedToVars(); --set all to default since nothing has loaded yet
end

function Archaeologist_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		
		if (not ArchaeologistVars) then
			ArchaeologistVars = { };
		end
		
		if (MobHealth_OnEvent) then
			if (MI2_OnEvent) then
				Sea.util.hook( "MI2_OnEvent", "Archaeologist_MobHealth_OnEvent", "after" );
			else
				Sea.util.hook( "MobHealth_OnEvent", "Archaeologist_MobHealth_OnEvent", "after" );
			end
			ArchaeologistVarData["MOBHEALTH"] = { khaos = "UseMobHealth", cosmos = "COS_ARCHAEOLOGIST_MOBHEALTH", default = 0, func = Archaeologist_EnableMobHealth };
		end
		
		if (Khaos) then 
			Archaeologist_VarSync_KhaosToVars();
			Archaeologist_RegisterForKhaos();
		elseif (Cosmos_RegisterConfiguration) then
			Archaeologist_VarSync_CosmosToVars();
			Archaeologist_RegisterForCosmos();
		else
			Archaeologist_VarSync_SavedToVars()
			Archaeologist_VarSync_VarsToLive();
			RegisterForSave("ArchaeologistVars");
		end
		
		Archaeologist_PlayerCheckDead();
		Archaeologist_UpdatePartyMembersDead();
		Archaeologist_PetCheckDead();
		Archaeologist_HideOrigTargetBuffs();
		Archaeologist_PartyMemberFrame_UpdateOverlapPositions()
	
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		--Archaeologist_PlayerCheckDead();
		--Archaeologist_UpdatePartyMembersDead();
		--Archaeologist_PetCheckDead();
		Archaeologist_UpdatePartyMemberBuffs();
		Archaeologist_UpdatePlayerClassIcon();
	
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
		
	elseif (event == "PLAYER_TARGET_CHANGED") then
		--Archaeologist_TargetCheckDead();
		Archaeologist_UpdateTargetClassIcon();
		
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		Archaeologist_UpdatePartyMembersDead();
		Archaeologist_UpdatePartyClassIcons();
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

function Archaeologist_SetTextStatusBarText(bar, text, text2)
	if ( not bar or not text2 ) then
		return
	end
	bar.TextString2 = text2;
end

function Archaeologist_InitializeAddedStatusBarTexts()

	SetTextStatusBarText(PartyMemberFrame1HealthBar, PartyMemberFrame1HealthBarTextString, PartyMemberFrame1HealthBarTextString2);
	SetTextStatusBarText(PartyMemberFrame2HealthBar, PartyMemberFrame2HealthBarTextString, PartyMemberFrame2HealthBarTextString2);
	SetTextStatusBarText(PartyMemberFrame3HealthBar, PartyMemberFrame3HealthBarTextString, PartyMemberFrame3HealthBarTextString2);
	SetTextStatusBarText(PartyMemberFrame4HealthBar, PartyMemberFrame4HealthBarTextString, PartyMemberFrame4HealthBarTextString2);
	
	SetTextStatusBarText(PartyMemberFrame1ManaBar, PartyMemberFrame1ManaBarTextString, PartyMemberFrame1ManaBarTextString2);
	SetTextStatusBarText(PartyMemberFrame2ManaBar, PartyMemberFrame2ManaBarTextString, PartyMemberFrame2ManaBarTextString2);
	SetTextStatusBarText(PartyMemberFrame3ManaBar, PartyMemberFrame3ManaBarTextString, PartyMemberFrame3ManaBarTextString2);
	SetTextStatusBarText(PartyMemberFrame4ManaBar, PartyMemberFrame4ManaBarTextString, PartyMemberFrame4ManaBarTextString2);
	
	SetTextStatusBarText(TargetFrameHealthBar, TargetFrameHealthBarTextString, TargetFrameHealthBarTextString2);
	SetTextStatusBarText(TargetFrameManaBar, TargetFrameManaBarTextString, TargetFrameManaBarTextString2);
	
	SetTextStatusBarText(PetFrameHealthBar, PetFrameHealthBarText, PetFrameHealthBarText2String);
	SetTextStatusBarText(PetFrameManaBar, PetFrameManaBarText, PetFrameManaBarText2String);
	
	SetTextStatusBarText(PlayerFrameHealthBar, PlayerFrameHealthBarText, PlayerFrameHealthBarText2String);
	SetTextStatusBarText(PlayerFrameManaBar, PlayerFrameManaBarText, PlayerFrameManaBarText2String);
end

-- <= == == == == == == == == == == == == =>
-- => Variable Sync
-- <= == == == == == == == == == == == == =>

function Archaeologist_VarSync_CosmosToVars()
	--sync internal values with cosmos values, else use default stored, else default to 0
	for index, var in ArchaeologistVarData do
		if (var.cosmos) and (var.min) and (var.max) then --slider
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
			if (var.cosmos) and (var.min) and (var.max) then --slider
				if(ArchaeologistVars[index]) then
					Cosmos_UpdateValue(var.cosmos, CSM_CHECKONOFF, 1);
					Cosmos_SetCVar(var.cosmos.."_X", 1);
					Cosmos_UpdateValue(var.cosmos, CSM_SLIDERVALUE, ArchaeologistVars[index]);
					Cosmos_SetCVar(var.cosmos, ArchaeologistVars[index]);
				end
			elseif (var.cosmos) then
				if(ArchaeologistVars[index]) then
					Cosmos_UpdateValue(var.cosmos, CSM_CHECKONOFF, ArchaeologistVars[index]);
					Cosmos_SetCVar(var.cosmos.."_X", ArchaeologistVars[index]);
				end
			end
		end
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
			CosmosMaster_DrawData();
		end
	end
end


function Archaeologist_VarSync_KhaosToVars()
	--sync internal values with cosmos values, else use default stored, else default to 0
	for index, var in ArchaeologistVarData do
		if (var.khaos) and (var.min) and (var.max) then --slider
			local kVal = Khaos.getSetKey(ArchaeologistOptionSetName, var.khaos);
			if (kVal) then
				ArchaeologistVars[index] = kVal.slider;
			elseif (var.default) then
				ArchaeologistVars[index] = var.default;
			else
				ArchaeologistVars[index] = 0;
			end
		elseif (var.khaos) then
			local kVal = Khaos.getSetKey(ArchaeologistOptionSetName, var.khaos);
			if (kVal) then
				if ( kVal.checked ) then 
					ArchaeologistVars[index] = 1;
				else
					ArchaeologistVars[index] = 0;
				end
			elseif (var.default) then
				ArchaeologistVars[index] = var.default;
			else
				ArchaeologistVars[index] = 0;
			end
		end
	end
end


function Archaeologist_VarSync_VarsToKhaos()
	--sync cosmos values with internal values, else use default stored, else default to 0
	if(Khaos) then
		for index, var in ArchaeologistVarData do
			if (var.khaos) and (var.min) and (var.max) then --slider
				if(ArchaeologistVars[index]) then
					Khaos.setSetKeyParameter(ArchaeologistOptionSetName, var.khaos, "checked", true);
					Khaos.setSetKeyParameter(ArchaeologistOptionSetName, var.khaos, "slider", ArchaeologistVars[index]);
				end
			elseif (var.khaos) then
				if(ArchaeologistVars[index]) then
					local checked = (ArchaeologistVars[index] == 1);
					Khaos.setSetKeyParameter(ArchaeologistOptionSetName, var.khaos, "checked", checked);
				end
			end
		end
		if KhaosFrame:IsVisible() then
			Khaos.refresh(false, false, true);  --Refresh Visible
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
		if (var.min) and (var.max) then --slider
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

-- <= == == == == == == == == == == == == =>
-- => HPMP Text Size
-- <= == == == == == == == == == == == == =>

function Archaeologist_SetHPMPLargeTextSize(checked, size)
	if (not size) then
		return;
	end
	ArchaeologistVars["HPMPLARGESIZE"] = size;
	local barParent = ArchaeologistStatusBars["player"].frame;
	barParent.healthbar.TextString:SetTextHeight(size);
	barParent.manabar.TextString:SetTextHeight(size);
	barParent.healthbar.TextString2:SetTextHeight(size);
	barParent.manabar.TextString2:SetTextHeight(size);
	local scale = barParent:GetScale();
	barParent:SetScale(scale+.1);
	barParent:SetScale(scale);
	barParent = ArchaeologistStatusBars["target"].frame;
	barParent.healthbar.TextString:SetTextHeight(size);
	barParent.manabar.TextString:SetTextHeight(size);
	barParent.healthbar.TextString2:SetTextHeight(size);
	barParent.manabar.TextString2:SetTextHeight(size);
	scale = barParent:GetScale();
	barParent:SetScale(scale+.1);
	barParent:SetScale(scale);
end

function Archaeologist_SetHPMPSmallTextSize(checked, size)
	if (not size) then
		return;
	end
	ArchaeologistVars["HPMPSMALLSIZE"] = size;
	local barParent = ArchaeologistStatusBars["pet"].frame;
	barParent.healthbar.TextString:SetTextHeight(size);
	barParent.manabar.TextString:SetTextHeight(size);
	barParent.healthbar.TextString2:SetTextHeight(size);
	barParent.manabar.TextString2:SetTextHeight(size);
	local scale = barParent:GetScale();
	barParent:SetScale(scale+.1);
	barParent:SetScale(scale);
	for i=1, 4 do
		barParent = ArchaeologistStatusBars["party"..i].frame;
		barParent.healthbar.TextString:SetTextHeight(size);
		barParent.manabar.TextString:SetTextHeight(size);
		barParent.healthbar.TextString2:SetTextHeight(size);
		barParent.manabar.TextString2:SetTextHeight(size);
		scale = barParent:GetScale();
		barParent:SetScale(scale+.1);
		barParent:SetScale(scale);
	end
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

function Archaeologist_TurnOnPlayerHP2(toggle)
	OverrideShowStatusBarText2(ArchaeologistStatusBars["player"].frame.healthbar, toggle);
	ArchaeologistVars["PLAYERHP2"] = toggle;
end

function Archaeologist_RestorePlayerHP()
	Archaeologist_TurnOnPlayerHP(ArchaeologistVars["PLAYERHP"]);
end

function Archaeologist_TurnOnPlayerMP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["player"].frame.manabar, toggle);
	ArchaeologistVars["PLAYERMP"] = toggle;
end

function Archaeologist_TurnOnPlayerMP2(toggle)
	OverrideShowStatusBarText2(ArchaeologistStatusBars["player"].frame.manabar, toggle);
	ArchaeologistVars["PLAYERMP2"] = toggle;
end

function Archaeologist_RestorePlayerMP()
	Archaeologist_TurnOnPlayerMP(ArchaeologistVars["PLAYERMP"]);
end

function Archaeologist_TurnOnPlayerXP(toggle)
	OverrideShowStatusBarText(MainMenuExpBar, toggle);
	ArchaeologistVars["PLAYERXP"] = toggle;
end

function Archaeologist_RestorePlayerXP()
	Archaeologist_TurnOnPlayerXP(ArchaeologistVars["PLAYERXP"]);
end

function Archaeologist_TurnOnPartyHP(toggle)
	for i=1, 4 do
		local bar = ArchaeologistStatusBars["party"..i].frame.healthbar;
		OverrideShowStatusBarText(bar, toggle);
	end
	ArchaeologistVars["PARTYHP"] = toggle;
end

function Archaeologist_TurnOnPartyHP2(toggle)
	for i=1, 4 do
		local bar = ArchaeologistStatusBars["party"..i].frame.healthbar;
		OverrideShowStatusBarText2(bar, toggle);
	end
	ArchaeologistVars["PARTYHP2"] = toggle;
end

function Archaeologist_TurnOnPartyMP(toggle) 
	for i = 1, 4 do
		local bar = ArchaeologistStatusBars["party"..i].frame.manabar
		OverrideShowStatusBarText(bar, toggle);
	end
	ArchaeologistVars["PARTYMP"] = toggle;
end

function Archaeologist_TurnOnPartyMP2(toggle) 
	for i = 1, 4 do
		local bar = ArchaeologistStatusBars["party"..i].frame.manabar
		OverrideShowStatusBarText2(bar, toggle);
	end
	ArchaeologistVars["PARTYMP2"] = toggle;
end


function Archaeologist_TurnOnTargetHP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["target"].frame.healthbar, toggle);
	ArchaeologistVars["TARGETHP"] = toggle;
end

function Archaeologist_TurnOnTargetHP2(toggle)
	OverrideShowStatusBarText2(ArchaeologistStatusBars["target"].frame.healthbar, toggle);
	ArchaeologistVars["TARGETHP2"] = toggle;
end

function Archaeologist_TurnOnTargetMP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["target"].frame.manabar, toggle);
	ArchaeologistVars["TARGETMP"] = toggle;
end

function Archaeologist_TurnOnTargetMP2(toggle)
	OverrideShowStatusBarText2(ArchaeologistStatusBars["target"].frame.manabar, toggle);
	ArchaeologistVars["TARGETMP2"] = toggle;
end

function Archaeologist_TurnOnPetHP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["pet"].frame.healthbar, toggle);
	ArchaeologistVars["PETHP"] = toggle;
end

function Archaeologist_TurnOnPetHP2(toggle)
	OverrideShowStatusBarText2(ArchaeologistStatusBars["pet"].frame.healthbar, toggle);
	ArchaeologistVars["PETHP2"] = toggle;
end

function Archaeologist_TurnOnPetMP(toggle)
	OverrideShowStatusBarText(ArchaeologistStatusBars["pet"].frame.manabar, toggle);
	ArchaeologistVars["PETMP"] = toggle;
end

function Archaeologist_TurnOnPetMP2(toggle)
	OverrideShowStatusBarText2(ArchaeologistStatusBars["pet"].frame.manabar, toggle);
	ArchaeologistVars["PETMP2"] = toggle;
end


-- <= == == == == == == == == == == == == =>
-- => Change HP/MP/XP Values to Percent Functions
-- <= == == == == == == == == == == == == =>

function Archaeologist_TurnOnPlayerXPPercent(toggle)
	Archaeologist_TextStringPercentStatusBars["MainMenuExpBar"] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(MainMenuExpBar);
	ArchaeologistVars["PLAYERXPP"] = toggle;
end

function Archaeologist_TurnOnPlayerXPValue(toggle)
	Archaeologist_TextStringValueStatusBars["MainMenuExpBar"] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(MainMenuExpBar);
	ArchaeologistVars["PLAYERXPV"] = toggle;
end

-- <= == == == == == == == == == == == == =>
-- => Invert HP/MP/XP Values
-- <= == == == == == == == == == == == == =>

function Archaeologist_TurnOnPlayerHPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["player"].frame.healthbar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PLAYERHPINVERT"] = toggle;
end

function Archaeologist_TurnOnPlayerMPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["player"].frame.manabar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PLAYERMPINVERT"] = toggle;
end

function Archaeologist_TurnOnPlayerXPInvert(toggle)
	Archaeologist_TextStringInvertStatusBars["MainMenuExpBar"] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(MainMenuExpBar);
	ArchaeologistVars["PLAYERXPINVERT"] = toggle;
end

function Archaeologist_TurnOnPartyHPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["party1"].frame.healthbar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party2"].frame.healthbar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party3"].frame.healthbar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party4"].frame.healthbar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	ArchaeologistVars["PARTYHPINVERT"] = toggle;
end

function Archaeologist_TurnOnPartyMPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["party1"].frame.manabar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party2"].frame.manabar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party3"].frame.manabar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	statusBar = ArchaeologistStatusBars["party4"].frame.manabar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	
	ArchaeologistVars["PARTYMPINVERT"] = toggle;
end

--only used to call onload since no more accurate data is provided
function Archaeologist_TurnOnTargetHPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["target"].frame.healthbar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
end

function Archaeologist_TurnOnTargetMPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["target"].frame.manabar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["TARGETMPINVERT"] = toggle;
end


function Archaeologist_TurnOnPetHPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["pet"].frame.healthbar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PETHPINVERT"] = toggle;
end

function Archaeologist_TurnOnPetMPInvert(toggle)
	local statusBar = ArchaeologistStatusBars["pet"].frame.manabar;
	Archaeologist_TextStringInvertStatusBars[statusBar:GetName()] = toggle;
	Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	ArchaeologistVars["PETMPINVERT"] = toggle;
end

-- <= == == == == == == == == == == == == =>
-- => Hide HP/MP/XP Value Prefix Functions
-- <= == == == == == == == == == == == == =>

function Archaeologist_UnitFrame_UpdateManaType(unitFrame)
	if ( not unitFrame ) then
		unitFrame = this;
	end
	if ( not unitFrame.manabar ) then
		return;
	end
	local info = ManaBarColor[UnitPowerType(unitFrame.unit)];
	unitFrame.manabar:SetStatusBarColor(info.r, info.g, info.b);
	
	-- Update the manabar prefix only if not hidden
	if ( Archaeologist_ManaPrefixNotHidden(unitFrame) ) then
		SetTextStatusBarTextPrefix(unitFrame.manabar, info.prefix);
		TextStatusBar_UpdateTextString(unitFrame.manabar);
	end

	-- Setup newbie tooltip
	if ( unitFrame:GetName() == "PlayerFrame" ) then
		unitFrame.manabar.tooltipTitle = info.prefix;
		unitFrame.manabar.tooltipText = getglobal("NEWBIE_TOOLTIP_MANABAR"..UnitPowerType(unitFrame.unit));
	else
		unitFrame.manabar.tooltipTitle = nil;
		unitFrame.manabar.tooltipText = nil;
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

function OverrideShowStatusBarText2(bar, toggle)
	if (toggle == 1) then
		SetStatusBarTextOverride2(bar, 1);
	else
		SetStatusBarTextOverride2(bar, nil);
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

--sets the override for secondary StatusBarTexts.
--override = nil removes override, 0 sets to hide, 1 sets to show
function SetStatusBarTextOverride2(bar, override)
	if(not bar) then
		return;
	end
	if(override == "1" or override == 1 or override == "show") then
		bar.override2 = "show";
		Archaeologist_ShowTextStatusBarText2(bar);
	elseif(override == "0" or override == 0 or override == "hide") then
		bar.override2 = "hide";
		Archaeologist_HideTextStatusBarText2(bar);
	else
		bar.override2 = nil;
		Archaeologist_HideTextStatusBarText2(bar);
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
	local string2 = textStatusBar.TextString2;
	if (string) then
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
				
				local percent = (not Archaeologist_TextStringPercentStatusBars[textStatusBar:GetName()]) or (Archaeologist_TextStringPercentStatusBars[textStatusBar:GetName()] == 1);
				local exactValue = (Archaeologist_TextStringValueStatusBars[textStatusBar:GetName()] == 1);
				local invert = (Archaeologist_TextStringInvertStatusBars[textStatusBar:GetName()] == 1);
				
				local stringText1, stringText2 = Archaeologist_GetCurrentTextStrings(textStatusBar, value, valueMax, percent, exactValue, invert);
				string:SetText(stringText1);
				if (string2) then
					string2:SetText(stringText2);
				end
				
				if (textStatusBar.override == "show") or (textStatusBar:GetLeft()) and (MouseIsOver(textStatusBar)) then
					ShowTextStatusBarText(textStatusBar);
				else
					HideTextStatusBarText(textStatusBar);
				end
				
				if (textStatusBar.override2 == "show") or (textStatusBar:GetLeft()) and (MouseIsOver(textStatusBar)) then
					Archaeologist_ShowTextStatusBarText2(textStatusBar);
				else
					Archaeologist_HideTextStatusBarText2(textStatusBar);
				end
			end
		else
			textStatusBar:Hide();
		end
	end
end

function Archaeologist_GetCurrentTextStrings(textStatusBar, value, valueMax, percent, exactValue, invert)
	
	local stringText1 = "";
	local stringText2 = "";
	local percentText = "";
	local valueText = "";
	
	if (invert) then 
		percentText = "-"..(100 - Sea.math.round(value / valueMax * 100)).."%";
	else
		percentText = Sea.math.round(value / valueMax * 100).."%";
	end
	
	if (textStatusBar == TargetFrame.healthbar) and (valueMax == 100) then
		if (MobHealth_GetTargetCurHP) and (MobHealth_GetTargetMaxHP) and (ArchaeologistVars["MOBHEALTH"] == 1) then
			local mobValue = MobHealth_GetTargetCurHP();
			local mobValueMax = MobHealth_GetTargetMaxHP();
			if (mobValue) and (mobValueMax) and (mobValueMax ~= 0) then
				if (invert) then
					valueText = "-"..(mobValueMax-mobValue).." / "..mobValueMax;
				else
					valueText = mobValue.." / "..mobValueMax;
				end
			end
		end
	elseif (invert) then
		valueText = "-"..(valueMax-value).." / "..valueMax;
	else
		valueText = value.." / "..valueMax;
	end
	
	if (percent) and (exactValue) then
		stringText1 = percentText.." "..valueText;
		stringText2 = percentText.." "..valueText;
	elseif (percent) then
		stringText1 = percentText;
		stringText2 = valueText;
	elseif (exactValue) then
		stringText1 = valueText;
		stringText2 = valueText;
	end
	
	if ( textStatusBar.prefix ) then
		stringText1 = textStatusBar.prefix.." "..stringText1;
	end
	
	if (ArchaeologistVars["HPMPALT"] == 1) then
		return stringText2, stringText1;
	else
		return stringText1, stringText2;
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

function Archaeologist_ShowTextStatusBarText2(bar)
	if ( bar and bar.TextString2 ) then
		if (bar.override2 ~= "hide") then
			bar.TextString2:Show();
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
		elseif (bar.isZero) or (bar.isOne) or (bar.override == "show") then -- or (MouseIsOver(bar)) then
			bar.TextString:Show();
		else
			bar.TextString:Hide();
		end
	end
end

function Archaeologist_HideTextStatusBarText2(bar)
	if ( bar and bar.TextString2 ) then
		if (bar.override2 == "hide") then
			bar.TextString2:Hide();
		elseif (bar.isZero) or (bar.isOne) or (bar.override2 == "show") then -- or (MouseIsOver(bar)) then
			bar.TextString2:Show();
		else
			bar.TextString2:Hide();
		end
	end
end

function Archaeologist_HookStatusBars_OnLeave()
	local afterHook = function(bar)
		Archaeologist_HideTextStatusBarText2(bar);
	end
	for unit, data in ArchaeologistStatusBars do
		local bar1 = data.frame.healthbar;
		setglobal("Archaeologist_"..bar1:GetName().."_OnLeave_orig", bar1:GetScript("OnLeave"));
		bar1:SetScript("OnLeave", function() getglobal("Archaeologist_"..bar1:GetName().."_OnLeave_orig")(); afterHook(bar1); end);
		
		local bar2 = data.frame.manabar;
		setglobal("Archaeologist_"..bar2:GetName().."_OnLeave_orig", bar2:GetScript("OnLeave"));
		bar2:SetScript("OnLeave", function() getglobal("Archaeologist_"..bar2:GetName().."_OnLeave_orig")(); afterHook(bar2); end);
	end
end

--sets bar.oneText
function SetTextStatusBarTextOneText(bar, oneText)
	if ( bar and bar.TextString ) then
		bar.oneText = oneText;
	end
end

function Archaeologist_CharacterFrame_OnShow()
	PlaySound("igCharacterInfoOpen");
	SetPortraitTexture(CharacterFramePortrait, "player");
	CharacterNameText:SetText(UnitPVPName("player"));
	UpdateMicroButtons();
	OverrideShowStatusBarText(PlayerFrameHealthBar, 1);
	OverrideShowStatusBarText(PlayerFrameManaBar, 1);
	OverrideShowStatusBarText(MainMenuExpBar, 1);
end

function Archaeologist_CharacterFrame_OnHide()
	PlaySound("igCharacterInfoClose");
	UpdateMicroButtons();
	Archaeologist_RestorePlayerHP();
	Archaeologist_RestorePlayerMP();
	Archaeologist_RestorePlayerXP();
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

function Archaeologist_PartyMemberFrame_UpdateOverlapPositions()
	if (ArchaeologistVars["PPTDEBUFFS"] ~= 0) then
		if (not PartyMemberFrame2:IsUserPlaced()) then
			PartyMemberFrame2:ClearAllPoints()
			PartyMemberFrame2:SetPoint("TOPLEFT", "PartyMemberFrame1PetFrame", "BOTTOMLEFT", -23, -30);
		end
		if (not PartyMemberFrame3:IsUserPlaced()) then
			PartyMemberFrame3:ClearAllPoints()
			PartyMemberFrame3:SetPoint("TOPLEFT", "PartyMemberFrame2PetFrame", "BOTTOMLEFT", -23, -30);
		end
		if (not PartyMemberFrame4:IsUserPlaced()) then
			PartyMemberFrame4:ClearAllPoints()
			PartyMemberFrame4:SetPoint("TOPLEFT", "PartyMemberFrame3PetFrame", "BOTTOMLEFT", -23, -30);
		end
	end
	if (not TargetFrame:IsUserPlaced()) and (not PlayerFrame:IsUserPlaced()) then
		local y = TargetFrame:GetTop() - UIParent:GetTop();
		local x = PlayerFrame:GetRight()+170;
		TargetFrame:ClearAllPoints()
		TargetFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", x, y);
	end
end

function Archaeologist_PartyMemberFrame_UpdatePet(id)
	if ( not id ) then
		id = this:GetID();
	end
	
	local frameName = "PartyMemberFrame"..id;
	local petFrame = getglobal("PartyMemberFrame"..id.."PetFrame");
	
	if ( UnitIsConnected("party"..id) and UnitExists("partypet"..id) and SHOW_PARTY_PETS == "1" ) then
		petFrame:Show();
		if (not petFrame:IsUserPlaced()) then
			petFrame:SetPoint("TOPLEFT", frameName, "TOPLEFT", 23, -63);	--Added 20 to Y distance
		end
	else
		petFrame:Hide();
		if (not petFrame:IsUserPlaced()) then
			petFrame:SetPoint("TOPLEFT", frameName, "TOPLEFT", 23, -27);
		end
	end
	PartyMemberFrame_RefreshPetBuffs(id);
end

function Archaeologist_UnitFrame_PartyPet_CheckMouseover()
	local id;
	if (this.unit == "partypet1") then
		id = 1;
	elseif (this.unit == "partypet2") then
		id = 2;
	elseif (this.unit == "partypet3") then
		id = 3;
	elseif (this.unit == "partypet4") then
		id = 4;
	else
		return;
	end
	PartyMemberFrame_RefreshPetBuffs(id);
end

function Archaeologist_PartyMemberFrame_RefreshBuffs()
	
	local texture;
	if ( ArchaeologistVars["PBUFFS"] == 1 ) then
		for i=1, ArchaeologistVarData["PBUFFNUM"].max do
			getglobal(this:GetName().."NewBuff"..i):Hide();
		end
	else
		for i=1, ArchaeologistVarData["PBUFFNUM"].max do
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
		for i=1, ArchaeologistVarData["PDEBUFFNUM"].max do
			getglobal(this:GetName().."NewDebuff"..i):Hide();
		end
	else
		local texture;
		for i=1, ArchaeologistVarData["PDEBUFFNUM"].max do
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

function Archaeologist_PartyMemberFrame_RefreshPetBuffs(id)
	if ( not id ) then
		id = this:GetID();
	end
	local texture;
	local petFrame = "PartyMemberFrame"..id.."PetFrame"
	if ( ArchaeologistVars["PPTBUFFS"] == 1 ) and (not MouseIsOver(getglobal(petFrame))) then
		for i=1, ArchaeologistVarData["PPTBUFFNUM"].max do
			getglobal(petFrame.."NewBuff"..i):Hide();
		end
	else
		for i=1, ArchaeologistVarData["PPTBUFFNUM"].max do
			texture = UnitBuff("partypet"..id, i);
			if ( texture ) and (i <= ArchaeologistVars["PPTBUFFNUM"]) then
				getglobal(petFrame.."NewBuff"..i.."Icon"):SetTexture(texture);
				getglobal(petFrame.."NewBuff"..i):Show();
			else
				getglobal(petFrame.."NewBuff"..i):Hide();
			end
		end
	end
	
	if ( ArchaeologistVars["PPTDEBUFFS"] == 1 ) and (not MouseIsOver(getglobal(petFrame))) then
		for i=1, ArchaeologistVarData["PPTDEBUFFNUM"].max do
			getglobal(petFrame.."NewDebuff"..i):Hide();
		end
	else
		for i=1, ArchaeologistVarData["PPTDEBUFFNUM"].max do
			texture = UnitDebuff("partypet"..id, i);
			if ( texture ) and (i <= ArchaeologistVars["PPTDEBUFFNUM"]) then
				getglobal(petFrame.."NewDebuff"..i.."Icon"):SetTexture(texture);
				getglobal(petFrame.."NewDebuff"..i):Show();
			else
				getglobal(petFrame.."NewDebuff"..i):Hide();
			end
		end
	end
end

function Archaeologist_PetFrame_RefreshBuffs()
	
	local texture;
	if ( ArchaeologistVars["PTBUFFS"] == 1 ) then
		for i=1, ArchaeologistVarData["PTBUFFNUM"].max do
			getglobal(this:GetName().."NewBuff"..i):Hide();
		end
	else
		for i=1, ArchaeologistVarData["PTBUFFNUM"].max do
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
		for i=1, ArchaeologistVarData["PTDEBUFFNUM"].max do
			getglobal(this:GetName().."NewDebuff"..i):Hide();
		end
	else
		local texture;
		for i=1, ArchaeologistVarData["PTDEBUFFNUM"].max do
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
	local tempThis = this;
	for i=1, MAX_PARTY_MEMBERS do
        if ( GetPartyMember(i) ) then
			this = getglobal("PartyMemberFrame"..i);
            Archaeologist_PartyMemberFrame_RefreshBuffs()
        end
    end
	this = tempThis;
end

function Archaeologist_UpdatePartyPetBuffs()
	PartyMemberFrame_RefreshPetBuffs(1);
	PartyMemberFrame_RefreshPetBuffs(2);
	PartyMemberFrame_RefreshPetBuffs(3);
	PartyMemberFrame_RefreshPetBuffs(4);
end

function Archaeologist_UpdatePetBuffs()
	local tempThis = this;
	this = PetFrame;
	Archaeologist_PetFrame_RefreshBuffs()
	this = tempThis;
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

function Archaeologist_TurnOffPartyPetBuffs(toggle)
	ArchaeologistVars["PPTBUFFS"] = toggle;
	Archaeologist_UpdatePartyPetBuffs();
end

function Archaeologist_TurnOffPetBuffs(toggle)
	ArchaeologistVars["PTBUFFS"] = toggle;
	Archaeologist_UpdatePetBuffs();
end


function Archaeologist_TurnOffPartyDebuffs(toggle)
	ArchaeologistVars["PDEBUFFS"] = toggle;
	Archaeologist_UpdatePartyMemberBuffs();
end

function Archaeologist_TurnOffPartyPetDebuffs(toggle)
	ArchaeologistVars["PPTDEBUFFS"] = toggle;
	Archaeologist_UpdatePartyPetBuffs();
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

function Archaeologist_SetPartyPetBuffs(toggle, count)
	if (count) then
		ArchaeologistVars["PPTBUFFNUM"] = count;
		Archaeologist_UpdatePartyPetBuffs();
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

function Archaeologist_SetPartyPetDebuffs(toggle, count)
	if (count) then
		ArchaeologistVars["PPTDEBUFFNUM"] = count;
		Archaeologist_UpdatePartyPetBuffs();
	end
end

function Archaeologist_SetPetDebuffs(toggle, count)
	if (count) then
		ArchaeologistVars["PTDEBUFFNUM"] = count;
		Archaeologist_UpdatePetBuffs();
	end
end

-- <= == == == == == == == == == == == == =>
-- => Target Buffs
-- <= == == == == == == == == == == == == =>

function Archaeologist_HideOrigTargetBuffs()
	for i=1, MAX_TARGET_BUFFS do
		getglobal("TargetFrameBuff"..i):Hide();
	end
	for i=1, MAX_TARGET_DEBUFFS do
		getglobal("TargetFrameDebuff"..i):Hide();
	end
	--for i=1, MAX_PARTY_DEBUFFS do
	--	getglobal("PartyMemberFrame"..i.."PetFrameDebuff"):Hide();
	--end
end

function Archaeologist_TargetDebuffButton_Update()
	-- Position buffs depending on whether the targeted unit is friendly or not
	Archaeologist_TargetBuffs_SetVerticalAlignment( UnitIsFriend("player", "target") );
	
	local button, debuff, debuffButton, buff, buffButton, debuffCount, debuffApplications;
	for i=1, ArchaeologistVarData["TBUFFNUM"].max do
		buff = UnitBuff("target", i);
		button = getglobal("TargetFrameNewBuff"..i);
		if ( buff ) and (i <= ArchaeologistVars["TBUFFNUM"]) and (ArchaeologistVars["TBUFFS"] == 0) then
			getglobal("TargetFrameNewBuff"..i.."Icon"):SetTexture(buff);
			button:Show();
			button.id = i;
		else
			button:Hide();
		end
	end
	local numDebuffs = 0;
	for i=1, ArchaeologistVarData["TDEBUFFNUM"].max do
		debuff, debuffApplications = UnitDebuff("target", i);
		button = getglobal("TargetFrameNewDebuff"..i);
		if ( debuff ) and (i <= ArchaeologistVars["TDEBUFFNUM"]) and (ArchaeologistVars["TDEBUFFS"] == 0) then
			getglobal("TargetFrameNewDebuff"..i.."Icon"):SetTexture(debuff);
			debuffCount = getglobal("TargetFrameNewDebuff"..i.."Count");
			if ( debuffApplications > 1 ) then
				debuffCount:SetText(debuffApplications);
				debuffCount:Show();
			else
				debuffCount:Hide();
			end
			button:Show();
			numDebuffs = numDebuffs + 1;
		else
			button:Hide();
		end
		button.id = i;
	end
end

function Archaeologist_TargetBuffs_SetVerticalAlignment(buffsOnTop)
	local leftPos;
	if (ArchaeologistVars["TBUFFALT"] == 1) then
		leftPos = 100;
	else
		leftPos = 5;
	end
	TargetFrameNewBuff1:ClearAllPoints();
	TargetFrameNewDebuff1:ClearAllPoints();
	if (buffsOnTop) then
		-- Move Buffs to Top
		TargetFrameNewBuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", leftPos, 32);
		TargetFrameNewDebuff1:SetPoint("TOPRIGHT", "TargetFrameNewBuff1", "BOTTOMRIGHT", 0, -2);
		Archaeologist_TargetBuffsAreOnTop = true;
	else
		-- Move Buffs to Bottom
		TargetFrameNewDebuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", leftPos, 32);
		TargetFrameNewBuff1:SetPoint("TOPRIGHT", "TargetFrameNewDebuff1", "BOTTOMRIGHT", 0, -2);
		Archaeologist_TargetBuffsAreOnTop = false;
	end
end

function Archaeologist_TargetBuffs_SetAltHorizontalAlignment(toggle)
	local button, point, relativePoint, leftOffset;
	if (toggle == 1) then
		point = "RIGHT";
		relativePoint = "LEFT";
		leftOffset = -3;
	else
		point = "LEFT";
		relativePoint = "RIGHT";
		leftOffset = 3;
	end
	
	ArchaeologistVars["TBUFFALT"] = toggle;
	
	Archaeologist_TargetBuffs_SetVerticalAlignment(Archaeologist_TargetBuffsAreOnTop);
	
	for i=2, ArchaeologistVarData["TBUFFNUM"].max do
		button = getglobal("TargetFrameNewBuff"..i);
		button:ClearAllPoints();
		button:SetPoint(point, "TargetFrameNewBuff"..(i-1), relativePoint, leftOffset, 0);
	end
	for i=2, ArchaeologistVarData["TDEBUFFNUM"].max do
		button = getglobal("TargetFrameNewDebuff"..i);
		button:ClearAllPoints();
		button:SetPoint(point, "TargetFrameNewDebuff"..(i-1), relativePoint, leftOffset, 0);
	end
end

function Archaeologist_TurnOffTargetBuffs(toggle)
	ArchaeologistVars["TBUFFS"] = toggle;
	TargetDebuffButton_Update();
end

function Archaeologist_TurnOffTargetDebuffs(toggle)
	ArchaeologistVars["TDEBUFFS"] = toggle;
	TargetDebuffButton_Update();
end


function Archaeologist_SetTargetBuffs(toggle, count)
	if (count) then
		ArchaeologistVars["TBUFFNUM"] = count;
		TargetDebuffButton_Update();
	end
end


function Archaeologist_SetTargetDebuffs(toggle, count)
	if (count) then
		ArchaeologistVars["TDEBUFFNUM"] = count;
		TargetDebuffButton_Update();
	end
end

-- <= == == == == == == == == == == == == =>
-- => Alternate Options
-- <= == == == == == == == == == == == == =>

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
	
	Archaeologist_SetPetFrameHappinessLocation();
end

function Archaeologist_SetAltHPMPLocation(toggle)
	ArchaeologistVars["HPMPALT"] = toggle;
	local statusBar;
	for unit, data in ArchaeologistStatusBars do
		statusBar = data.frame.healthbar;
		Archaeologist_TextStatusBar_UpdateTextString(statusBar);
		statusBar = data.frame.manabar;
		Archaeologist_TextStatusBar_UpdateTextString(statusBar);
	end
end

function Archaeologist_SetPetFrameHappinessLocation()
	if (ArchaeologistVars["HPMPALT"] == 1) or (ArchaeologistVars["DEBUFFALT"] == 0) then
		--alt position
		PetFrameHappiness:ClearAllPoints();
		PetFrameHappiness:SetPoint("TOPRIGHT", "PetFrame", "BOTTOMLEFT", 8, 15);
	else
		--normal position
		PetFrameHappiness:ClearAllPoints();
		PetFrameHappiness:SetPoint("LEFT", "PetFrame", "RIGHT", -7, -4);
	end

end

-- <= == == == == == == == == == == == == =>
-- => Font Options
-- <= == == == == == == == == == == == == =>

function Archaeologist_SetPrimaryHPColor(colorTable)
	for unit, data in ArchaeologistStatusBars do
		data.frame.healthbar.TextString:SetTextColor(colorTable.r, colorTable.g, colorTable.b, colorTable.opacity);
	end
end

function Archaeologist_SetPrimaryMPColor(colorTable)
	for unit, data in ArchaeologistStatusBars do
		data.frame.manabar.TextString:SetTextColor(colorTable.r, colorTable.g, colorTable.b, colorTable.opacity);
	end
end

function Archaeologist_SetSecondaryHPColor(colorTable)
	for unit, data in ArchaeologistStatusBars do
		data.frame.healthbar.TextString2:SetTextColor(colorTable.r, colorTable.g, colorTable.b, colorTable.opacity);
	end
end

function Archaeologist_SetSecondaryMPColor(colorTable)
	for unit, data in ArchaeologistStatusBars do
		data.frame.manabar.TextString2:SetTextColor(colorTable.r, colorTable.g, colorTable.b, colorTable.opacity);
	end
end

function Archaeologist_SetHPMPLargeFont(key)
	if (not key) then
		return;
	end
	ArchaeologistVars["HPMPLARGEFONT"] = key;
	local font = ArchaeologistFonts[key];
	if (not font) then
		-- Will reset to default on next Reload
		return;
	end
	local frame;
	local size = ArchaeologistVars["HPMPLARGESIZE"];
	for i, unit in {"player", "target"} do
		frame = ArchaeologistStatusBars[unit].frame;
		frame.healthbar.TextString:SetFont(font, size);
		frame.healthbar.TextString2:SetFont(font, size);
		frame.manabar.TextString:SetFont(font, size);
		frame.manabar.TextString2:SetFont(font, size);
	end
	Archaeologist_SetHPMPLargeTextSize(true, size); --Size corrects refonting problem with linebreaks
	--/z ArchaeologistStatusBars["player"].frame.healthbar.TextString:SetTextColor(1,.82,0)
end

function Archaeologist_SetHPMPSmallFont(key)
	if (not key) then
		return;
	end
	ArchaeologistVars["HPMPSMALLFONT"] = key;
	local font = ArchaeologistFonts[key];
	if (not font) then
		-- Will reset to default on next Reload
		return;
	end
	local frame;
	local size = ArchaeologistVars["HPMPSMALLSIZE"];
	for i, unit in {"party1", "party2", "party3", "party4", "pet"} do
		frame = ArchaeologistStatusBars[unit].frame;
		frame.healthbar.TextString:SetFont(font, size);
		frame.healthbar.TextString2:SetFont(font, size);
		frame.manabar.TextString:SetFont(font, size);
		frame.manabar.TextString2:SetFont(font, size);
	end
	Archaeologist_SetHPMPSmallTextSize(true, size); --Size corrects refonting problem with linebreaks
end

-- <= == == == == == == == == == == == == =>
-- => MobHealth2 Compatibility
-- <= == == == == == == == == == == == == =>


function Archaeologist_MobHealth_OnEvent(event)
	if (event == "PLAYER_TARGET_CHANGED") then
		--Archaeologist_TargetCheckDead();
		TextStatusBar_UpdateTextString(ArchaeologistStatusBars.target.frame.healthbar);
		--Sea.io.print("MobHealth2: PLAYER_TARGET_CHANGED");
	end
end


function Archaeologist_EnableMobHealth(toggle)
	ArchaeologistVars["MOBHEALTH"] = toggle;
	local frame;
	if (MI2_MobHealthFrame) then
		frame = MI2_MobHealthFrame;
	elseif (MobHealthFrame) then
		frame = MobHealthFrame;
	else
		return;
	end
	if (toggle == 1) then
		frame:Hide();
	else
		frame:Show();
	end
end

-- <= == == == == == == == == == == == == =>
-- => Class Icons
-- <= == == == == == == == == == == == == =>

function Archaeologist_TurnOnPartyClassIcon(toggle)
	ArchaeologistVars["PARTYCLASSICON"] = toggle;
	Archaeologist_UpdatePartyClassIcons();
	if (toggle == 1) then
		for i=1, 4 do
			getglobal("PartyMemberFrame"..i.."MasterIcon"):ClearAllPoints();
			getglobal("PartyMemberFrame"..i.."MasterIcon"):SetPoint("TOPLEFT", "PartyMemberFrame"..i, "TOPLEFT", 15, 5);
		end
	else
		for i=1, 4 do
			getglobal("PartyMemberFrame"..i.."MasterIcon"):ClearAllPoints();
			getglobal("PartyMemberFrame"..i.."MasterIcon"):SetPoint("TOPLEFT", "PartyMemberFrame"..i, "TOPLEFT", 32, 0);
		end
	end
end

function Archaeologist_UpdatePartyClassIcons()
	if (ArchaeologistVars["PARTYCLASSICON"] == 1) then
		local localizedClass, englishClass, icon;
		for i=1, GetNumPartyMembers() do
			localizedClass, englishClass = UnitClass("party"..i);
			icon = getglobal("PartyMemberFrame"..i.."ClassIcon");
			if (englishClass) then
				if (not icon:IsVisible()) then
					icon:Show();
				end
				getglobal(icon:GetName().."Texture"):SetTexture("Interface\\AddOns\\Archaeologist\\Skin\\ClassIcons\\"..Sea.string.capitalizeWords(englishClass));
			else
				if (icon:IsVisible()) then
					icon:Hide();
				end
			end
		end
	else
		for i=1, GetNumPartyMembers() do
			icon = getglobal("PartyMemberFrame"..i.."ClassIcon");
			if (icon:IsVisible()) then
				icon:Hide();
			end
		end
	end
end

function Archaeologist_TurnOnTargetClassIcon(toggle)
	ArchaeologistVars["TARGETCLASSICON"] = toggle;
	Archaeologist_UpdateTargetClassIcon();
end

function Archaeologist_UpdateTargetClassIcon()
	if (ArchaeologistVars["TARGETCLASSICON"] == 1) then
		if (UnitIsPlayer("target")) then
			local localizedClass, englishClass = UnitClass("target");
			if (not TargetFrameClassIcon:IsVisible()) then
				TargetFrameClassIcon:Show();
			end
			TargetFrameClassIconTexture:SetTexture("Interface\\AddOns\\Archaeologist\\Skin\\ClassIcons\\"..Sea.string.capitalizeWords(englishClass));
		else
			TargetFrameClassIcon:Hide();
		end
	else
		if (TargetFrameClassIcon:IsVisible()) then
			TargetFrameClassIcon:Hide();
		end
	end
end

function Archaeologist_TurnOnPlayerClassIcon(toggle)
	ArchaeologistVars["PLAYERCLASSICON"] = toggle;
	Archaeologist_UpdatePlayerClassIcon();
	if (toggle == 1) then
		PlayerMasterIcon:ClearAllPoints();
		PlayerMasterIcon:SetPoint("TOPLEFT", "PlayerFrame", "TOPLEFT", 65, -2);
	else
		PlayerMasterIcon:ClearAllPoints();
		PlayerMasterIcon:SetPoint("TOPLEFT", "PlayerFrame", "TOPLEFT", 80, -10);
	end
end

function Archaeologist_UpdatePlayerClassIcon()
	if (ArchaeologistVars["PLAYERCLASSICON"] == 1) then
		local localizedClass, englishClass = UnitClass("player");
		if (not PlayerFrameClassIcon:IsVisible()) then
			PlayerFrameClassIcon:Show();
		end
		PlayerFrameClassIconTexture:SetTexture("Interface\\AddOns\\Archaeologist\\Skin\\ClassIcons\\"..Sea.string.capitalizeWords(englishClass));
	else
		if (PlayerFrameClassIcon:IsVisible()) then
			PlayerFrameClassIcon:Hide();
		end
	end
end

function Archaeologist_ClassIcon_OnLoad()
	this:SetFrameLevel(this:GetFrameLevel()+2);
end

function Archaeologist_EnableClassPortrait(toggle)
	ArchaeologistVars["CLASSPORTRAIT"] = toggle;
	if (toggle == 1) then
		for unit, data in ArchaeologistStatusBars do
			if (unit ~= "pet") then
				if (UnitIsPlayer(unit)) then
					local localizedClass, englishClass = UnitClass(unit);
					if (englishClass) then
						data.frame.portrait:SetTexture("Interface\\AddOns\\Archaeologist\\Skin\\PortraitIcons\\"..Sea.string.capitalizeWords(englishClass));
					end
				end
			end
		end
	else
		SetPortraitTexture(PlayerFrame.portrait, "player");
		SetPortraitTexture(TargetFrame.portrait, "target");
		SetPortraitTexture(PartyMemberFrame1.portrait, "party1");
		SetPortraitTexture(PartyMemberFrame2.portrait, "party2");
		SetPortraitTexture(PartyMemberFrame3.portrait, "party3");
		SetPortraitTexture(PartyMemberFrame4.portrait, "party4");
	end
end

function Archaeologist_UnitFrame_Update_After()
	if (ArchaeologistVars["CLASSPORTRAIT"] == 1) then
		if (UnitIsPlayer(this.unit)) then
			local localizedClass, englishClass = UnitClass(this.unit);
			if (englishClass) then
				this.portrait:SetTexture("Interface\\AddOns\\Archaeologist\\Skin\\PortraitIcons\\"..Sea.string.capitalizeWords(englishClass));
			end
		end
	end
end

function Archaeologist_UnitFrame_OnEvent_After(event)
	if (ArchaeologistVars["CLASSPORTRAIT"] == 1) then
		if ( (event == "UNIT_PORTRAIT_UPDATE") and (arg1 == this.unit) ) then
			if (UnitIsPlayer(this.unit)) then
				local localizedClass, englishClass = UnitClass(this.unit);
				if (englishClass) then
					this.portrait:SetTexture("Interface\\AddOns\\Archaeologist\\Skin\\PortraitIcons\\"..Sea.string.capitalizeWords(englishClass));
				end
			end
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
	
	table.sort(varPrefixes);
	for index, varPrefix in varPrefixes do
	
		Cosmos_RegisterConfiguration(
			"COS_ARCHAEOLOGIST_"..varPrefix.."_SEPARATOR",
			"SEPARATOR",
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP")),
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"))
		);
		
		local keyList = Sea.table.getKeyList(ArchaeologistVarData);
		local sorter = function(a,b) 
			if ( type(getglobal("ARCHAEOLOGIST_CONFIG_"..a)) == type(getglobal("ARCHAEOLOGIST_CONFIG_"..b)) and type(getglobal("ARCHAEOLOGIST_CONFIG_"..a)) ~= "nil") then 
				return (getglobal("ARCHAEOLOGIST_CONFIG_"..a) < getglobal("ARCHAEOLOGIST_CONFIG_"..b));
			else
				return false;
			end
		end
		table.sort(keyList, sorter);

		for k, index in keyList do
			local var = ArchaeologistVarData[index];
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
	
	varPrefixes = { "HPCOLOR", "DEBUFFALT", "TBUFFALT", "CLASSPORTRAIT", "HPMPALT", "MOBHEALTH" };
	
	for index, varPrefix in varPrefixes do
	
		if (ArchaeologistVarData[varPrefix]) then
		Cosmos_RegisterConfiguration(
			ArchaeologistVarData[varPrefix].cosmos,						--CVar
			"CHECKBOX",													--Things to use
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix)),
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_INFO")),
			ArchaeologistVarData[varPrefix].func,						--Callback
			ArchaeologistVars[varPrefix]								--Default Checked/Unchecked
		);
		end
	
	end
	
	varPrefixes = { "HPMPLARGESIZE", "HPMPSMALLSIZE" };
	
	for index, varPrefix in varPrefixes do
	
		Cosmos_RegisterConfiguration(
			ArchaeologistVarData[varPrefix].cosmos,		-- CVar
			"SLIDER",					-- Type
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix)),		-- Short description
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_INFO")),	-- Long description
			ArchaeologistVarData[varPrefix].func,	-- Callback
			1,						-- Default Checked/Unchecked
			ArchaeologistVarData[varPrefix].default,		-- Default slider value
			ArchaeologistVarData[varPrefix].min,		-- Minimum slider value
			ArchaeologistVarData[varPrefix].max, 		-- max value
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SLIDERTEXT")), 	-- slider "header" text
			1,						-- Slider steps
			1,						-- Text on slider
			"",						-- slider text append
			1						-- slider multiplier
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
			ArchaeologistVarData[varPrefix.."NUM"].min,									-- Minimum slider value
			ArchaeologistVarData[varPrefix.."NUM"].max,									-- max value
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM_SLIDER_TEXT")),	-- slider "header" text
			1,						-- Slider steps
			1,						-- Text on slider
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
			ArchaeologistVarData[varPrefix.."NUM"].min,									-- Minimum slider value
			ArchaeologistVarData[varPrefix.."NUM"].max,									-- max value
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_SLIDER_TEXT")),	-- slider "header" text
			1,						-- Slider steps
			1,						-- Text on slider?
			"",						-- slider text append
			1						-- slider multiplier
		);
		
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Target Buff Registering
	-- <= == == == == == == == == == == == =>
	
	varPrefix = "TARGETBUFFS";
	
	Cosmos_RegisterConfiguration(
		"COS_ARCHAEOLOGIST_"..varPrefix.."_SEPARATOR",
		"SEPARATOR",
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP")),
		TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"))
	);
	
	varPrefixes = { "TBUFF", "TDEBUFF" };
	
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
			ArchaeologistVarData[varPrefix.."NUM"].min,									-- Minimum slider value
			ArchaeologistVarData[varPrefix.."NUM"].max,									-- max value
			TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_SLIDER_TEXT")),	-- slider "header" text
			1,						-- Slider steps
			1,						-- Text on slider?
			"",						-- slider text append
			1						-- slider multiplier
		);
		
	end
	
end


function Archaeologist_RegisterForKhaos()	
	
	-- <= == == == == == == == == == == == =>
	-- => Looped Registering
	-- <= == == == == == == == == == == == =>
	
	local optionSet = {};
	
	local varPrefixes = { "PLAYER", "PARTY", "PET", "TARGET" };
	
	table.sort(varPrefixes);
	for index, varPrefix in varPrefixes do
	
		local header = {
			id = Sea.string.capitalizeWords(varPrefix).."Header";
			type = K_HEADER;
			difficulty = 1;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"));
		};

		table.insert(optionSet, header);
		
		local keyList = Sea.table.getKeyList(ArchaeologistVarData);
		local sorter = function(a,b) 
			if ( type(getglobal("ARCHAEOLOGIST_CONFIG_"..a)) == type(getglobal("ARCHAEOLOGIST_CONFIG_"..b)) and type(getglobal("ARCHAEOLOGIST_CONFIG_"..a)) ~= "nil") then 
				return (getglobal("ARCHAEOLOGIST_CONFIG_"..a) < getglobal("ARCHAEOLOGIST_CONFIG_"..b));
			else
				return false;
			end
		end
		table.sort(keyList, sorter);

		for k, index in keyList do
			local var = ArchaeologistVarData[index];
			if (type(index) == "string") then
				if (strsub(index, 0, string.len(varPrefix)) == varPrefix) then
					local f = ArchaeologistVarData[index].func;
					local option = {
						id = ArchaeologistVarData[index].khaos;
						check = true;
						type = K_TEXT;
						difficulty = 1;
						text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..index));
						helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..index.."_INFO"));
						callback = function(state) local c = 0; if ( state.checked ) then c = 1; end f(c); end;
						feedback = function(state) return Archaeologist_Feedback(index, state.checked) end;
						default = { 
							checked = false; 
						};
						disabled = {
							checked = false;
						};
						dependencies = ArchaeologistVarData[index].dependencies;
					};

					if ( ArchaeologistVarData[index].default == 1 ) then 
						option.default.checked = true;
						option.disabled.checked = true;
					end

					table.insert(optionSet, option);
				end
			end
		end
		
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Alternate Options Registering
	-- <= == == == == == == == == == == == =>

	local varPrefix = "ALTOPTS";
	
	local header = {
		id = Sea.string.capitalizeWords(varPrefix).."Header";
		type = K_HEADER;
		difficulty = 2;
		text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP"));
		helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"));
	};
	table.insert(optionSet, header);
		
	varPrefixes = { "HPCOLOR", "DEBUFFALT", "TBUFFALT", "CLASSPORTRAIT", "HPMPALT" };

	if ( MobHealth_OnEvent ) then
		table.insert(varPrefixes, "MOBHEALTH" );
	end
	
	for index, varPrefix in varPrefixes do
		local f = ArchaeologistVarData[varPrefix].func;
		local option = {
			id = ArchaeologistVarData[varPrefix].khaos;
			check = true;
			type = K_TEXT;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_INFO"));
			callback = function(state) local c = 0; if ( state.checked ) then c = 1; end f(c); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.checked) end;
			default = { 
				checked = false; 
			};
			disabled = {
				checked = false;
			};
			dependencies = ArchaeologistVarData[varPrefix].dependencies;
		};
		if ( ArchaeologistVarData[varPrefix].default == 1 ) then 
			option.default.checked = true;
			option.disabled.checked = true;
		end
		
		table.insert(optionSet, option);
	end
	
	local varPrefix = "FONTOPTS";
	
	local header = {
		id = Sea.string.capitalizeWords(varPrefix).."Header";
		type = K_HEADER;
		difficulty = 3;
		text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP"));
		helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"));
	};
	table.insert(optionSet, header);
	
	varPrefixes = { "HPMPLARGE", "HPMPSMALL" };
	
	for index, varPrefix in varPrefixes do
		local id = varPrefix.."FONT";
		local f = ArchaeologistVarData[id].func;
		local option = {
			id = ArchaeologistVarData[id].khaos;
			type = K_PULLDOWN;
			difficulty = 3;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..id));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..id.."_INFO"));
			callback = function(state) f(state.value) end;
			feedback = function(state) return Archaeologist_Feedback(id, state.value) end;
			dependencies = ArchaeologistVarData[id].dependencies;

			default = { 
				key = ArchaeologistVarData[id].default; 
			};
			disabled = {
				key = ArchaeologistVarData[id].default;
			};
			setup = {
				options = ArchaeologistLocalizedFonts;
				multiSelect = false;
			};
		};
		table.insert(optionSet, option);
		
		local id = varPrefix.."SIZE";
		local f = ArchaeologistVarData[id].func;
		local option = {
			id = ArchaeologistVarData[id].khaos;
			type = K_SLIDER;
			difficulty = 3;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..id));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..id.."_INFO"));
			callback = function(state) f(state.checked, state.slider); end;
			feedback = function(state) return Archaeologist_Feedback(id, state.checked) end;
			dependencies = ArchaeologistVarData[id].dependencies;

			default = { 
				slider = ArchaeologistVarData[id].default; 
			};
			disabled = {
				slider = ArchaeologistVarData[id].default;
			};
			setup = {
				sliderMin = ArchaeologistVarData[id].min;
				sliderMax = ArchaeologistVarData[id].max;
				sliderStep = 1;
				sliderText = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..id.."_SLIDERTEXT"));
			};
		};
		if ( ArchaeologistVars[id] == 1 ) then 
			option.default.checked = true;
		end
		table.insert(optionSet, option);			
	end
	
	varPrefixes = { "COLORPHP", "COLORPMP", "COLORSHP", "COLORSMP" };
	
	for index, varPrefix in varPrefixes do
		local data = ArchaeologistVarData[varPrefix]
		local colorChangeFeedback = function(state)
			return string.format(ARCHAEOLOGIST_COLOR_CHANGED, Sea.string.colorToString(state.color), data.khaos );
		end
		local colorResetFeedback = function(state)
			return string.format(ARCHAEOLOGIST_COLOR_RESET, Sea.string.colorToString(state.color), data.khaos );
		end
		table.insert(
			optionSet,
			{
				id=ArchaeologistVarData[varPrefix].khaos;
				text=getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix);
				helptext=getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_INFO");
				difficulty=3;
				callback=function(state)
					data.func(state.color);
				end;
				feedback=colorChangeFeedback;
				type=K_COLORPICKER;
				setup= {
					hasOpacity=true;
				};
				default={
					color=ArchaeologistVarData[varPrefix].default;
				};
				disabled={
					color=ArchaeologistVarData[varPrefix].default;
				};					
			}
		);
		table.insert(
			optionSet,
			{
				id=ArchaeologistVarData[varPrefix].khaos.."Reset";
				text=getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_RESET");
				helptext=getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_RESET_INFO");
				difficulty=3;
				callback=function(state)
					Khaos.setSetKey(KhaosCore.getCurrentSet(), data.khaos, {color=data.default});
					Khaos.refresh(false, false, true);  --Refresh Visible
				end;
				feedback=colorResetFeedback;
				type=K_BUTTON;
				setup = {
					buttonText=RESET;
				};
			}
		);
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Party Buff Registering
	-- <= == == == == == == == == == == == =>
	
	varPrefix = "PARTYBUFFS";
	
	local header = {
		id = Sea.string.capitalizeWords(varPrefix).."Header";
		type = K_HEADER;
		difficulty = 2;
		text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP"));
		helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"));
	};
	table.insert(optionSet, header);
			
	varPrefixes = { "PBUFF", "PDEBUFF" };
	
	for index, varPrefix in varPrefixes do
		local f = ArchaeologistVarData[varPrefix.."S"].func;
		local option = {
			id = ArchaeologistVarData[varPrefix.."S"].khaos;
			check = true;
			type = K_TEXT;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S".."_INFO"));
			callback = function(state) local c = 0; if ( state.checked ) then c = 1; end f(c); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.checked) end;
			default = { 
				checked = false; 
			};
			disabled = {
				checked = false;
			};
			dependencies = ArchaeologistVarData[varPrefix.."S"].dependencies;
		};
		if ( ArchaeologistVars[varPrefix.."S"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, option);
		
		local sf = ArchaeologistVarData[varPrefix.."NUM"].func;

		local optionSlider = {
			id = ArchaeologistVarData[varPrefix.."NUM"].khaos;
			type = K_SLIDER;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM_INFO"));
			callback = function(state) sf(state.checked, state.slider); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.slider) end;
			dependencies = ArchaeologistVarData[varPrefix.."NUM"].dependencies;

			default = { 
				slider = ArchaeologistVarData[varPrefix.."NUM"].default; 
			};
			disabled = {
				slider = ArchaeologistVarData[varPrefix.."NUM"].default;
			};
			setup = {
				sliderMin = ArchaeologistVarData[varPrefix.."NUM"].min;
				sliderMax = ArchaeologistVarData[varPrefix.."NUM"].max;
				sliderStep = 1;
				sliderText = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM_SLIDER_TEXT"));
			};
		};
		if ( ArchaeologistVars[varPrefix.."NUM"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, optionSlider);		
	end
	
	-- <= == == == == == == == == == == == =>
	-- => PartyPet Buff Registering
	-- <= == == == == == == == == == == == =>
	
	varPrefix = "PARTYPETBUFFS";
	
	local header = {
		id = Sea.string.capitalizeWords(varPrefix).."Header";
		type = K_HEADER;
		difficulty = 2;
		text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP"));
		helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"));
	};
	table.insert(optionSet, header);
			
	varPrefixes = { "PPTBUFF", "PPTDEBUFF" };
	
	for index, varPrefix in varPrefixes do
		local f = ArchaeologistVarData[varPrefix.."S"].func;
		local option = {
			id = ArchaeologistVarData[varPrefix.."S"].khaos;
			check = true;
			type = K_TEXT;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S".."_INFO"));
			callback = function(state) local c = 0; if ( state.checked ) then c = 1; end f(c); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.checked) end;
			default = { 
				checked = false; 
			};
			disabled = {
				checked = false;
			};
			dependencies = ArchaeologistVarData[varPrefix.."S"].dependencies;
		};
		if ( ArchaeologistVars[varPrefix.."S"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, option);
		
		local sf = ArchaeologistVarData[varPrefix.."NUM"].func;

		local optionSlider = {
			id = ArchaeologistVarData[varPrefix.."NUM"].khaos;
			type = K_SLIDER;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM_INFO"));
			callback = function(state) sf(state.checked, state.slider); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.slider) end;
			dependencies = ArchaeologistVarData[varPrefix.."NUM"].dependencies;

			default = { 
				slider = ArchaeologistVarData[varPrefix.."NUM"].default; 
			};
			disabled = {
				slider = ArchaeologistVarData[varPrefix.."NUM"].default;
			};
			setup = {
				sliderMin = ArchaeologistVarData[varPrefix.."NUM"].min;
				sliderMax = ArchaeologistVarData[varPrefix.."NUM"].max;
				sliderStep = 1;
				sliderText = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_NUM_SLIDER_TEXT"));
			};
		};
		if ( ArchaeologistVars[varPrefix.."NUM"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, optionSlider);		
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Pet Buff Registering
	-- <= == == == == == == == == == == == =>
	
	varPrefix = "PETBUFFS";
	
	local header = {
		id = Sea.string.capitalizeWords(varPrefix).."Header";
		type = K_HEADER;
		difficulty = 2;
		text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP"));
		helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"));
	};
	table.insert(optionSet, header);

	varPrefixes = { "PTBUFF", "PTDEBUFF" };
	
	for index, varPrefix in varPrefixes do
		local f = ArchaeologistVarData[varPrefix.."S"].func;
		local option = {
			id = ArchaeologistVarData[varPrefix.."S"].khaos;
			check = true;
			type = K_TEXT;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S".."_INFO"));
			callback = function(state) local c = 0; if ( state.checked ) then c = 1; end f(c); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.checked) end;
			default = { 
				checked = false; 
			};
			disabled = {
				checked = false;
			};
			dependencies = ArchaeologistVarData[varPrefix.."S"].dependencies;
		};
		if ( ArchaeologistVars[varPrefix.."S"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, option);

		local sf = ArchaeologistVarData[varPrefix.."NUM"].func;
		local optionSlider = {
			id = ArchaeologistVarData[varPrefix.."NUM"].khaos;
			type = K_SLIDER;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_INFO"));
			callback = function(state) sf(state.checked, state.slider); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.slider) end;
			dependencies = ArchaeologistVarData[varPrefix.."NUM"].dependencies;

			default = { 
				slider = ArchaeologistVarData[varPrefix.."NUM"].default; 
			};
			disabled = {
				slider = ArchaeologistVarData[varPrefix.."NUM"].default;
			};
			setup = {
				sliderMin = ArchaeologistVarData[varPrefix.."NUM"].min;
				sliderMax = ArchaeologistVarData[varPrefix.."NUM"].max;
				sliderStep = 1;
				sliderText = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_SLIDER_TEXT"));
			};
		};
		if ( ArchaeologistVars[varPrefix.."NUM"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, optionSlider);			
	end
	
	-- <= == == == == == == == == == == == =>
	-- => Target Buff Registering
	-- <= == == == == == == == == == == == =>
	
	varPrefix = "TARGETBUFFS";
	
	local header = {
		id = Sea.string.capitalizeWords(varPrefix).."Header";
		type = K_HEADER;
		difficulty = 2;
		text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP"));
		helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."_SEP_INFO"));
	};
	table.insert(optionSet, header);
	
	varPrefixes = { "TBUFF", "TDEBUFF" };
	
	for index, varPrefix in varPrefixes do
		local f = ArchaeologistVarData[varPrefix.."S"].func;
		local option = {
			id = ArchaeologistVarData[varPrefix.."S"].khaos;
			check = true;
			type = K_TEXT;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."S".."_INFO"));
			callback = function(state) local c = 0; if ( state.checked ) then c = 1; end f(c); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.checked) end;
			default = { 
				checked = false; 
			};
			disabled = {
				checked = false;
			};
			dependencies = ArchaeologistVarData[varPrefix.."S"].dependencies;
		};
		if ( ArchaeologistVars[varPrefix.."S"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, option);
		
		local sf = ArchaeologistVarData[varPrefix.."NUM"].func;
		local optionSlider = {
			id = ArchaeologistVarData[varPrefix.."NUM"].khaos;
			type = K_SLIDER;
			difficulty = 2;
			text = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM"));
			helptext = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_INFO"));
			callback = function(state) sf(state.checked, state.slider); end;
			feedback = function(state) return Archaeologist_Feedback(varPrefix, state.slider) end;
			dependencies = ArchaeologistVarData[varPrefix.."NUM"].dependencies;

			default = { 
				slider = ArchaeologistVarData[varPrefix.."NUM"].default; 
			};
			disabled = {
				slider = ArchaeologistVarData[varPrefix.."NUM"].default;
			};
			setup = {
				sliderMin = ArchaeologistVarData[varPrefix.."NUM"].min;
				sliderMax = ArchaeologistVarData[varPrefix.."NUM"].max;
				sliderStep = 1;
				sliderText = TEXT(getglobal("ARCHAEOLOGIST_CONFIG_"..varPrefix.."NUM_SLIDER_TEXT"));
			};
		};
		if ( ArchaeologistVars[varPrefix.."NUM"] == 1 ) then 
			option.default.checked = true;
		end
		
		table.insert(optionSet, optionSlider);			
	end	

	Khaos.registerOptionSet(
		"frames",
		{
			id = ArchaeologistOptionSetName;
			text = TEXT(ARCHAEOLOGIST_CONFIG_SEP);
			helptext = TEXT(ARCHAEOLOGIST_CONFIG_SEP_INFO);
			difficulty = 1;
			options = optionSet;
		}
	);
end

function Archaeologist_Feedback(id, setToValue)
	if (not id) then
		id = "Unknown";
	end
	if (not setToValue) then
		setToValue = "false";
	end
	return string.format(ARCHAEOLOGIST_FEEDBACK_STRING, id, tostring(setToValue));
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
	Sea.io.printc(color,"/archtarget [buffs/debuffs] [on/off/toggle/#]");
	Sea.io.printc(color,"*** Special Options ***");
	Sea.io.printc(color,"/arch [hpcolor/debuffalt/targetbuffalt/hpmpalt/mobhealth] [on/off/toggle]");
	Sea.io.printc(color,"/arch [textsize1/textsize2] [#]");
	Sea.io.printc(color,"(textsize1: player, target. textsize2: pet, party.  #: 6-20)");

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
		if ( Khaos ) then 
			Archaeologist_VarSync_VarsToKhaos();
		else
		Archaeologist_VarSync_VarsToCosmos();
	end
end
end

function Archaeologist_Slash_SetSlider(var, number)
	if (var) and (number) then
		number = tonumber(number);
		if (number < ArchaeologistVarData[var].min) then
			number = ArchaeologistVarData[var].min;
		elseif (number > ArchaeologistVarData[var].max) then
			number = ArchaeologistVarData[var].max;
		end
		
		ArchaeologistVarData[var].func(1, number);
		Sea.io.print(getglobal("ARCHAEOLOGIST_CONFIG_"..var)," ",number);
		if ( Khaos ) then 
			Archaeologist_VarSync_VarsToKhaos();
		else
		Archaeologist_VarSync_VarsToCosmos();
		end
	else
		Archaeologist_Slash_ArchHelp();
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
	
	else
		startpos, endpos, option, status = string.find(msg, "(%w+) (%w+)");
		if (option) and (status) then
		
			if (option == "CLASS") then
				onVal = 1;
				var = "PLAYERCLASSICON";
			
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
			end
			Archaeologist_Slash_SetSlider(var, number);
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
				
				elseif (option == "CLASS") then
					onVal = 1;
					var = "PARTYCLASSICON";
				
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
			end
			Archaeologist_Slash_SetSlider(var, number);
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
	
	else
		startpos, endpos, option, number = string.find(msg, "(%w+) (%d+)");
		if (option) and (number) then
		
			if (option == "BUFFS") then
				var = "TBUFFNUM";
			elseif (option == "DEBUFFS") then
				var = "TDEBUFFNUM";
			end
			Archaeologist_Slash_SetSlider(var, number);
			return;
			
		else
			startpos, endpos, option, status = string.find(msg, "(%w+) (%w+)");
			if (option) and (status) then
			
				if (option == "BUFFS") then
					onVal = 0;
					var = "TBUFFS";
					
				elseif (option == "DEBUFFS") then
					onVal = 0;
					var = "TDEBUFFS";
					
				elseif (option == "CLASS") then
					onVal = 1;
					var = "TARGETCLASSICON";
					
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
			
		elseif (option == "TARGETBUFFALT") then
			onVal = 1;
			var = "TBUFFALT";
			
		elseif (option == "CLASSPORTRAIT") then
			onVal = 1;
			var = "CLASSPORTRAIT";
			
		elseif (option == "HPMPALT") then
			onVal = 1;
			var = "HPMPALT";
		
		elseif (option == "MOBHEALTH") then
			onVal = 1;
			var = "MOBHEALTH";
		elseif (option == "HPMPLARGEFONT") or (option == "HPMPSMALLFONT") then
			if (not ArchaeologistFonts[status]) then
				Sea.io.print(format(ARCHAEOLOGIST_NOT_A_VALID_FONT, status));
				return;
			end
			ArchaeologistVarData[option].func(status);
			Sea.io.print(getglobal("ARCHAEOLOGIST_CONFIG_"..var)," ",number);
			if ( Khaos ) then 
				Archaeologist_VarSync_VarsToKhaos();
			end
			return;
		else
			startpos, endpos, option, number = string.find(msg, "(%w+) (%d+)");
			if (option) and (number) then
			
				if (option == "TEXTSIZE1") then
					var = "HPMPLARGESIZE";
				elseif (option == "TEXTSIZE2") then
					var = "HPMPSMALLSIZE";
				end
				Archaeologist_Slash_SetSlider(var, number);
				return;
			end
		
		end
		
	end
	if (var) and (onVal) and (status) then
		Archaeologist_Slash_Toggle(var, onVal, status);
	else
		Archaeologist_Slash_ArchHelp();
	end
end


