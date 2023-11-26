---------------
-- Variables --
---------------

local InCombat = nil;
local EnterCombat = nil;
local VariablesLoaded = nil;

----------------------
-- Loading Function --
----------------------

function Perl_Player_OnLoad()

	-- Events
	CombatFeedback_Initialize(Perl_PlayerHitIndicator, 30);
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("UNIT_SPELLMISS");
	this:RegisterEvent("UNIT_MAXMANA");
	this:RegisterEvent("QUEST_COMPLETE");
	this:RegisterEvent("PLAYER_UPDATE_RESTING");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_PVP_UPDATE");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_DISPLAYPOWER");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	PerlPlayerPortrait:Show();
	table.insert(UnitPopupFrames,"Perl_Player_DropDown");
	Perl_Player_ManaBarTEXT:Hide();
	Perl_Player_ManaBarText:Hide();
	Perl_Player_DruidBar:Hide();
	Perl_Player_DruidBarBG:Hide();
	Perl_Player_DruidBar:SetHeight(1);
	Perl_Player_DruidBarBG:SetHeight(1);
	Perl_Player_CastClickOverlay:SetFrameLevel(Perl_Player_StatsFrame:GetFrameLevel() + 2);

end

-------------------
-- Event Handler --
-------------------

function Perl_Player_OnEvent(event, unit)
	if ( event == "UNIT_COMBAT" ) then
		if ( arg1 == "player" ) then
			CombatFeedback_OnCombatEvent(arg2, arg3, arg4, arg5);
		end
		return;
	end
	if ( event == "UNIT_SPELLMISS" ) then
		if ( arg1 == "player" ) then
			CombatFeedback_OnSpellMissEvent(arg2);
		end
		return;
	end
	if (arg1) then
		
		if ((arg1=="player") or UnitIsUnit(arg1, "player")) then
			if ((event=="UNIT_HEALTH") or (event=="UNIT_MAXHEALTH")) then
				Perl_Player_UpdateHealth();
			elseif ((event=="UNIT_MANA") or (event=="UNIT_MAXMANA") or (event=="UNIT_RAGE") or (event=="UNIT_MAXRAGE") or (event=="UNIT_ENERGY") or (event=="UNIT_MAXENERGY") or (event=="UNIT_FOCUS") or (event=="UNIT_MAXFOCUS")) then
				Perl_Player_UpdateMana();
			elseif (event=="UNIT_DISPLAYPOWER") then
				Perl_Player_UpdateManaType();
			elseif (event=="UNIT_NAME_UPDATE") then
				Perl_Player_UpdateName();
			elseif (event=="UNIT_AURA") then
				
			elseif (event=="UNIT_PVP_UPDATE") then
				Perl_Player_UpdatePVP();
			else
				Perl_Player_UpdateDisplay();
			end
		end
	elseif (event == "PLAYER_ENTER_COMBAT") then
		EnterCombat = 1;
		Perl_Player_UpdateCombat();
	elseif (event == "PLAYER_LEAVE_COMBAT") then
		EnterCombat = nil;
		Perl_Player_UpdateCombat();
	elseif (event == "PLAYER_REGEN_ENABLED") then
		InCombat = nil;
		Perl_Player_UpdateDisplay();
	elseif (event == "PLAYER_REGEN_DISABLED") then
		InCombat = 1;
		Perl_Player_UpdateDisplay();
	else	
		Perl_Player_UpdateDisplay();
	end
		
end

-------------------------
-- The Update Function --
-------------------------

function Perl_Player_UpdateDisplay ()
	Perl_Player_UpdateXP();
	Perl_Player_UpdateManaType();
	if (Perl_Config.ShowPlayerLevel) then Perl_Player_UpdateLevel(); end
	if (Perl_Config.ShowPlayerPortrait) then SetPortraitTexture(PerlPlayerPortrait, "player"); end
	Perl_Player_UpdateName();
	Perl_Player_UpdatePVP();
	Perl_Player_UpdateCombat();
	Perl_Player_UpdateLeader();
	Perl_Player_UpdateMana();
	Perl_Player_UpdateHealth();
	
end

function Perl_Player_UpdateManaType()
	local playerpower = UnitPowerType("player");
	if (playerpower == 1) then
		Perl_Player_ManaBar:SetStatusBarColor(1, 0, 0, 1);
		Perl_Player_ManaBarBG:SetStatusBarColor(1, 0, 0, 0.25);
	elseif (playerpower == 2) then
		Perl_Player_ManaBar:SetStatusBarColor(1, 0.5, 0, 1);
		Perl_Player_ManaBarBG:SetStatusBarColor(1, 0.5, 0, 0.25);
	elseif (playerpower == 3) then
		Perl_Player_ManaBar:SetStatusBarColor(1, 1, 0, 1);
		Perl_Player_ManaBarBG:SetStatusBarColor(1, 1, 0, 0.25);
	else
		Perl_Player_ManaBar:SetStatusBarColor(0, 0, 1, 1);
		Perl_Player_ManaBarBG:SetStatusBarColor(0, 0, 1, 0.25);
	end
end
function Perl_Player_UpdateLeader()
	if (IsPartyLeader()) then
		Perl_Player_LeaderIcon:Show();
	else
		Perl_Player_LeaderIcon:Hide();
	end
end
function Perl_Player_UpdateName()
	Perl_Player_NameBarText:SetText(UnitName("player"));
end
function Perl_Player_UpdateXP()
	local playerxp = UnitXP("player");
	local playerxpmax = UnitXPMax("player");
	local playerxprest = GetXPExhaustion();
	Perl_Player_XPBar:SetMinMaxValues(0, playerxpmax);
	Perl_Player_XPRestBar:SetMinMaxValues(0, playerxpmax);
	Perl_Player_XPBar:SetValue(playerxp);
	local xptext = playerxp.."/"..playerxpmax;
	if (playerxprest) then
		xptext = xptext .."(+"..(playerxprest)..")";
		Perl_Player_XPBar:SetStatusBarColor(0.3, 0.3, 1, 1);
		Perl_Player_XPRestBar:SetStatusBarColor(0.3, 0.3, 1, 0.5);
		Perl_Player_XPBarBG:SetStatusBarColor(0.3, 0.3, 1, 0.25);
		Perl_Player_XPRestBar:SetValue(playerxp + playerxprest);
	else
		Perl_Player_XPBar:SetStatusBarColor(0.6, 0, 0.6, 1);
		Perl_Player_XPRestBar:SetStatusBarColor(0.6, 0, 0.6, 0.5);
		Perl_Player_XPBarBG:SetStatusBarColor(0.6, 0, 0.6, 0.25);
		Perl_Player_XPRestBar:SetValue(playerxp);
	end
	Perl_Player_XPBarText:SetText(xptext);
	local xppercenttext=((playerxp * 100.0) / playerxpmax);
	xppercenttext=string.format("%3.0f", xppercenttext);
	Perl_Player_XPBarPercentText:SetText(xppercenttext.."%");
end
function Perl_Player_UpdateCombat()
	if (InCombat == 1) then
		Perl_Player_ActivityStatus:SetTexCoord(0.5, 1.0, 0.0, 0.5);
		Perl_Player_ActivityStatus:Show();
	elseif (IsResting()) then
		Perl_Player_ActivityStatus:SetTexCoord(0, 0.5, 0.0, 0.5);
		Perl_Player_ActivityStatus:Show();
	else
		Perl_Player_ActivityStatus:Hide();
	end
end
function Perl_Player_UpdatePVP()
	local playerrankname, playerrank=GetPVPRankInfo(UnitPVPRank("player"), "player");
	if (playerrank and Perl_Config.ShowPlayerPVPRank==1) then
		Perl_Player_PVPRankIcon:Show();
		if (playerrank==0) then
			Perl_Player_PVPRankIcon:Hide();
		elseif (playerrank>9) then
			Perl_Player_PVPRankIcon:SetTexture("Interface\\PVPRankBadges\\PVPRank"..playerrank);
		else
			Perl_Player_PVPRankIcon:SetTexture("Interface\\PVPRankBadges\\PVPRank0"..playerrank);
		end
	else 
		Perl_Player_PVPRankIcon:Hide();
	end
	local PlayerClass = UnitClass("player");
	if (Perl_Config.ShowPlayerClassIcon) then Perl_Player_ClassTexture:SetTexCoord(Perl_ClassPosRight(PlayerClass), Perl_ClassPosLeft(PlayerClass), Perl_ClassPosTop(PlayerClass), Perl_ClassPosBottom(PlayerClass)); end
	
	-- PVP Status settings
	if (EnterCombat == 1) then
		Perl_Player_NameBarText:SetTextColor(1,0,0);
	elseif (UnitIsPVP("player")) then
		Perl_Player_NameBarText:SetTextColor(0,1,0);
		Perl_Player_PVPStatus:Show();
		if (UnitFactionGroup('player') == "Horde") then
			Perl_Player_PVPStatus:SetTexture("Interface\\TargetingFrame\\UI-PVP-Horde");
		else
			Perl_Player_PVPStatus:SetTexture("Interface\\TargetingFrame\\UI-PVP-Alliance");
		end
	else
		Perl_Player_NameBarText:SetTextColor(0.5,0.5,1);
		Perl_Player_PVPStatus:Hide();
	end
end
function Perl_Player_UpdateMana()
	local playerhealth = UnitHealth("player");
	local playerhealthmax = UnitHealthMax("player");
	local playermana = UnitMana("player");
	local playermanamax = UnitManaMax("player");
	Perl_Player_ManaBar:SetMinMaxValues(0, playermanamax);
	Perl_Player_ManaBar:SetValue(playermana);
	manaPct = (playermana * 100.0) / playermanamax
	manaPct =  string.format("%3.0f", manaPct);
	Perl_Player_ManaBarTEXT:Show();
	Perl_Player_ManaBarText:Show();
	if (UnitPowerType("player")>=1) then 
		Perl_Player_ManaBarText:SetText(playermana);
	else
		Perl_Player_ManaBarText:SetText(manaPct.."%");
	end
	Perl_Player_ManaBarTEXT:SetText(playermana.."/"..playermanamax);
	if ((playerhealth==0) and (playerhealthmax==1)) then
		Perl_Player_ManaBarTEXT:Hide();
		Perl_Player_HealthBarTEXT:SetText("Offine");
	elseif ((playerhealth==0) and (playerhealthmax>1)) then
		Perl_Player_ManaBarTEXT:Hide();
		Perl_Player_HealthBarTEXT:SetText("Dead");
	elseif ((playerhealth==1) and (playerhealthmax>1)) then
		Perl_Player_ManaBarTEXT:Hide();
		Perl_Player_HealthBarTEXT:SetText("Ghost");
	end
	if (DruidBarKey and (UnitClass("player")==PERL_LOC_CLASS_DRUID)) then
		Perl_Player_DruidBarUpdate();
	end
end
function Perl_Player_DruidBarUpdate()
	Perl_Player_DruidBar:SetMinMaxValues(0,DruidBarKey.maxmana);
	Perl_Player_DruidBar:SetValue(DruidBarKey.keepthemana);
	manaPct = (DruidBarKey.keepthemana * 100.0) / DruidBarKey.maxmana;
	manaPct =  string.format("%3.0f", manaPct);
	Perl_Player_DruidBarText:SetText(manaPct.."%");
	Perl_Player_DruidBarTEXT:SetText(math.floor(DruidBarKey.keepthemana).."/"..DruidBarKey.maxmana);
	if (UnitPowerType("player")>0) then
		if Perl_Config.ShowPlayerXPBar==1 then Perl_Player_StatsFrame:SetHeight(60);
		else Perl_Player_StatsFrame:SetHeight(50); end
		Perl_Player_DruidBarTEXT:Show();
		Perl_Player_DruidBarText:Show();
		Perl_Player_DruidBar:Show();
		Perl_Player_DruidBarBG:Show();
		Perl_Player_DruidBar:SetHeight(10);
		Perl_Player_DruidBarBG:SetHeight(10);
	else
		if Perl_Config.ShowPlayerXPBar==1 then Perl_Player_StatsFrame:SetHeight(50);
		else Perl_Player_StatsFrame:SetHeight(40); end
		Perl_Player_DruidBarTEXT:Hide();
		Perl_Player_DruidBarText:Hide();
		Perl_Player_DruidBar:Hide();
		Perl_Player_DruidBarBG:Hide();
		Perl_Player_DruidBar:SetHeight(1);
		Perl_Player_DruidBarBG:SetHeight(1);
	end
	
end
function Perl_Player_UpdateHealth()
	local playerhealth = UnitHealth("player");
	local playerhealthmax = UnitHealthMax("player");
	Perl_Player_HealthBar:SetMinMaxValues(0, playerhealthmax);
	Perl_Player_HealthBar:SetValue(playerhealth);
	Perl_SetSmoothBarColor(Perl_Player_HealthBar);
	Perl_SetSmoothBarColor(Perl_Player_HealthBarBG, Perl_Player_HealthBar, 0.25);
	healthPct = (playerhealth * 100.0) / playerhealthmax
	healthPct = string.format("%3.0f", healthPct);
	Perl_Player_HealthBarTEXT:Show();
	Perl_Player_HealthBarText:SetText(healthPct.."%");
	Perl_Player_HealthBarTEXT:SetText(playerhealth.."/"..playerhealthmax);
	if ((playerhealth==0) and (playerhealthmax==1)) then
		Perl_Player_ManaBarTEXT:Hide();
		Perl_Player_HealthBarTEXT:SetText("Offine");
	elseif ((playerhealth==0) and (playerhealthmax>1)) then
		Perl_Player_ManaBarTEXT:Hide();
		Perl_Player_HealthBarTEXT:SetText("Dead");
	elseif ((playerhealth==1) and (playerhealthmax>1)) then
		Perl_Player_ManaBarTEXT:Hide();
		Perl_Player_HealthBarTEXT:SetText("Ghost");
	end
end
function Perl_Player_UpdateLevel()
	Perl_Player_LevelFrame_LevelBarText:SetText(UnitLevel("player"));
end
function Perl_Player_ScalingUpdate()
	if (this:GetScale() == UIParent:GetScale()) and (this:GetScale() ~= Perl_Config.Scale_PlayerFrame) then 
		Perl_ScalePlayer(Perl_Config.Scale_PlayerFrame);
		Perl_ScalePet(Perl_Config.Scale_PetFrame);
		Perl_ScaleParty(Perl_Config.Scale_PartyFrame);
		Perl_ScaleTarget(Perl_Config.Scale_TargetFrame);
		Perl_ScaleTargetTarget(Perl_Config.Scale_TargetTargetFrame);
		Perl_ScaleRaid(Perl_Config.Scale_Raid);
	end
end
--------------------
-- Click Handlers --
--------------------

function Perl_PlayerDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Perl_PlayerDropDown_Initialize, "MENU");
end
				
function Perl_PlayerDropDown_Initialize()
	UnitPopup_ShowMenu(Perl_Player_DropDown, "SELF", "player");
end
function Perl_Player_OnClick(button)
	if (CastParty_constants and (Perl_Config.CastParty==1) ) then
		--this:SetID(0);
		CastParty_OnClick(button);
	end
end
function Perl_Player_MouseUp(button)
	this:SetID(0);
	if (not (CastParty_constants and (Perl_Config.CastParty==1) and not (strfind(this:GetName(), ("Perl_Player_Frame"))))) then
		
		if ( SpellIsTargeting() and button == "RightButton" ) then
			SpellStopTargeting();
			return;
		end
		if ( button == "LeftButton" ) then
			if ( SpellIsTargeting() ) then
				SpellTargetUnit("player");
			elseif ( CursorHasItem() ) then
				DropItemOnUnit("player");
			else
				TargetUnit("player");
			end
		else
			ToggleDropDownMenu(1, nil, Perl_Player_DropDown, "Perl_Player_NameFrame", 40, 0);
		end
		
	end
	Perl_Player_Frame:StopMovingOrSizing();
end

function Perl_Player_MouseDown(button)
	if ( button == "LeftButton" and perl_locked == 0) then
		Perl_Player_Frame:StartMoving();
	end
end

---------------------------------
-- Mouse enter/leave functions --
---------------------------------

function Perl_Player_MouseEnter()
	
end

function Perl_Player_MouseLeave()
	
end
function Perl_PlayerXPBar_MouseEnter()
	Perl_Player_XPBarText:Show();
end

function Perl_PlayerXPBar_MouseLeave()
	Perl_Player_XPBarText:Hide();
end
