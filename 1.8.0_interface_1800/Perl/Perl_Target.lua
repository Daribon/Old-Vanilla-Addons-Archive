local numDebuffs = 0;
local debuffAmnt = 0;
local debuffTime = 0;
local debuffDelta = 9999;
local elapsed = 0;
----------------------
-- Loading Function --
----------------------

function Perl_Target_OnLoad()
	-- Events
	CombatFeedback_Initialize(Perl_TargetHitIndicator, 30);
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("UNIT_SPELLMISS");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_FACTION");
	this:RegisterEvent("UNIT_DYNAMIC_FLAGS");
	this:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
	this:RegisterEvent("PLAYER_PVPLEVEL_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_ENABLE");
	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	--this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_FLAGS_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("UNIT_MAXHEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_MAXMANA");
	this:RegisterEvent("UNIT_MAXRAGE");
	this:RegisterEvent("UNIT_MAXFOCUS");
	this:RegisterEvent("UNIT_MAXENERGY");
	this:RegisterEvent("UNIT_DISPLAYPOWER");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	
	this:Hide();
			
	table.insert(UnitPopupFrames,"Perl_Target_DropDown");
end

-------------------
-- Event Handler --
-------------------

function Perl_Target_OnEvent(event)
	
	if ( event == "UNIT_COMBAT" ) then
		if ( arg1 == "target" ) then
			CombatFeedback_OnCombatEvent(arg2, arg3, arg4, arg5);
		end
		return;
	end
	if ( event == "UNIT_SPELLMISS" ) then
		if ( arg1 == "target" ) then
			CombatFeedback_OnSpellMissEvent(arg2);
		end
		return;
	end
	if (arg1) then
		if (arg1=="target") then
			if ((event=="UNIT_HEALTH") or (event=="UNIT_MAXHEALTH")) then
				Perl_Target_UpdateHealth();
			elseif ((event=="UNIT_MANA") or (event=="UNIT_MAXMANA") or (event=="UNIT_RAGE") or (event=="UNIT_MAXRAGE") or (event=="UNIT_ENERGY") or (event=="UNIT_MAXENERGY") or (event=="UNIT_FOCUS") or (event=="UNIT_MAXFOCUS")) then
				Perl_Target_UpdateMana();
			elseif (event=="UNIT_DISPLAYPOWER") then
				Perl_Target_UpdateManaType();
			elseif (event=="UNIT_PORTRAIT_UPDATE") then
				Perl_Target_UpdatePortrait();
			elseif (event=="UNIT_NAME_UPDATE") then
				Perl_Target_UpdateName();
			elseif (event=="UNIT_CLASSIFICATION_CHANGED") then
				Perl_Target_UpdateClassification();
			end
		end
		if (event=="PLAYER_TARGET_CHANGED") then
			Perl_Target_UpdateDisplay();
		end
	else
		if (event=="PLAYER_TARGET_CHANGED") then
			Perl_Target_UpdateDisplay();
		elseif (event=="PLAYER_COMBO_POINTS") then
			Perl_Target_UpdateCombo();
		elseif (event=="UNIT_AURA") then
			Perl_Target_Buff_UpdateAll();
			Perl_Target_DebuffUpdate();

		end
	end
end
-------------------------
-- The Update Functions--
-------------------------

function Perl_Target_UpdateDisplay()	
	if (perl_loaded) then
		if (UnitName("target") ~= nil) then
			Perl_Target_Frame:Show(); 
			Perl_Target_UpdateName();
			Perl_Target_UpdatePortrait();
			Perl_Target_UpdateLevel();
			Perl_Target_UpdateClassification();
			Perl_Target_UpdateType();
			Perl_Target_UpdatePVP();
			Perl_Target_UpdateCombo();
			Perl_Target_UpdateManaType();
			Perl_Target_UpdateMana();
			Perl_Target_UpdateHealth();
			TargetFrame:Hide();  -- Hide default frame
			ComboFrame:Hide();  -- Hide Combo Points
		else
			Perl_Target_Frame:Hide();
			Perl_Target_Frame:StopMovingOrSizing();
		end
	else
	end
	
end
function Perl_Target_OnUpdate()
	elapsed=elapsed+arg1;
	if elapsed > .3 then
		Perl_Target_Buff_UpdateAll();
		Perl_Target_DebuffUpdate();
		elapsed=0;
	end
end
function Perl_Target_UpdateName()
	local targetname = UnitName("target");
	if (strlen(targetname) > 20) then
		targetname = strsub(targetname, 1, 19).."...";
	end
	Perl_Target_NameBarText:SetText(targetname);  
	if (UnitIsTapped("target") and not UnitIsTappedByPlayer("target")) then
		Perl_Target_NameBarText:SetTextColor(0.5,0.5,0.5);
	elseif (UnitIsPlayer("target")) then
		if (UnitFactionGroup("player") == UnitFactionGroup("target")) then
			if (UnitIsPVP("target")) then
				Perl_Target_NameBarText:SetTextColor(0,1,0);
			else
				Perl_Target_NameBarText:SetTextColor(0.5,0.5,1);
			end
		else
			if (UnitIsPVP("target")) then
				if (UnitIsPVP("player")) then
					Perl_Target_NameBarText:SetTextColor(1,0,0);
				else
					Perl_Target_NameBarText:SetTextColor(1,1,0);
				end
			else
				Perl_Target_NameBarText:SetTextColor(0.5,0.5,1);
			end
		end
	else
		if (UnitFactionGroup("player") == UnitFactionGroup("target")) then
			Perl_Target_NameBarText:SetTextColor(0,1,0);
		elseif (UnitIsEnemy("player", "target")) then			
			Perl_Target_NameBarText:SetTextColor(1,0,0);					
		else					
			Perl_Target_NameBarText:SetTextColor(1,1,0);
		end
	end
	guildname, guildtitle, guildrank = GetGuildInfo("target");
end

function Perl_Target_UpdatePortrait()
	if (Perl_Config.ShowTargetPortrait==1) then
		SetPortraitTexture(PerlTargetPortrait, "target");
		PerlTargetPortrait:Show();
	end
end
function Perl_Target_UpdateLevel()
	local targetlevel = UnitLevel("target");
	Perl_Target_LevelBarText:SetText(targetlevel);
	-- Set Level
	if (Perl_Config.ShowTargetLevel==1) then
		Perl_Target_LevelFrame:Show();
		Perl_Target_LevelFrame:SetWidth(27);
		if (targetlevel < 0) then
			Perl_Target_LevelBarText:SetTextColor(1, 0, 0);
			Perl_Target_LevelFrame:Hide();
		else
			local color = GetDifficultyColor(targetlevel);
			Perl_Target_LevelBarText:SetTextColor(color.r, color.g, color.b);
		end
		if ((Perl_Config.ShowTargetMobType==0) and (UnitIsPlusMob("target"))) then
			Perl_Target_LevelBarText:SetText(targetlevel.."+");
			Perl_Target_LevelFrame:SetWidth(33);
		end
	end
end
function Perl_Target_UpdateClassification()
	local targetclassification = UnitClassification("target");
	if (Perl_Config.ShowTargetLevel==1) then
		Perl_Target_BossFrame:Show();
		if (targetclassification == "worldboss") then
			Perl_Target_CreatureBossText:SetText("Boss");
			Perl_Target_BossFrame:SetWidth(38);
		elseif (targetclassification == "rareelite") then
			Perl_Target_CreatureBossText:SetText("Rare+");
			Perl_Target_BossFrame:SetWidth(43);
		elseif (targetclassification == "elite") then
			Perl_Target_CreatureBossText:SetText("Elite");
			Perl_Target_BossFrame:SetWidth(43);
		elseif (targetclassification == "rare") then
			Perl_Target_CreatureBossText:SetText("Rare");
			Perl_Target_BossFrame:SetWidth(38);
		else
			Perl_Target_BossFrame:Hide();
		end
	end
	Perl_Target_CreatureText:SetTextColor(1, 1, 1);
end
function Perl_Target_UpdateType()
	if (UnitIsPlayer("target")) then
		if (UnitFactionGroup("player")~=UnitFactionGroup("target")) then
			Perl_Target_CreatureText:SetTextColor(1, 0, 0);
		else    Perl_Target_CreatureText:SetTextColor(0.3, 0.3, 1); 
		end
	end
	local targettype = UnitCreatureType("target");
	if (Perl_Config.ShowTargetMobType==1) then Perl_Target_TypeFrame:Show(); end
	Perl_Target_TypeFramePlayer:Hide();
	Perl_Target_CreatureText:SetText(targettype);
	if (UnitIsPlayer("target")) then
		local PlayerClass = UnitClass("target");
		if (Perl_Config.ShowTargetClassIcon==1) then
			Perl_Target_ClassTexture:SetTexCoord(Perl_ClassPosRight(PlayerClass), Perl_ClassPosLeft(PlayerClass), Perl_ClassPosTop(PlayerClass), Perl_ClassPosBottom(PlayerClass));							
			Perl_Target_TypeFramePlayer:Show();
		end
		Perl_Target_TypeFrame:Hide();
		
	 elseif (targettype == PERL_LOC_TYPE_HUMANOID) then
		 Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_HUMANOID_LENGTH);
 	elseif (targettype == PERL_LOC_TYPE_BEAST) then
 		Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_BEAST_LENGTH);
 	elseif (targettype == PERL_LOC_TYPE_GIANT) then
 		Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_GIANT_LENGTH);
	 elseif (targettype == PERL_LOC_TYPE_UNDEAD) then
 		Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_UNDEAD_LENGTH);
 	elseif (targettype == PERL_LOC_TYPE_DEMON) then
 		Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_DEMON_LENGTH);
	 elseif (targettype == PERL_LOC_TYPE_ELEMENTAL) then
 		Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_ELEMENTAL_LENGTH);
 	elseif (targettype == PERL_LOC_TYPE_CRITTER) then
		 Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_CRITTER_LENGTH);
 	elseif (targettype == PERL_LOC_TYPE_DRAGONKIN) then
 		Perl_Target_TypeFrame:SetWidth(PERL_LOC_TYPE_DRAGONKIN_LENGTH);
	else 
		Perl_Target_TypeFrame:Hide();
	end
end
function Perl_Target_UpdatePVP()
	local targetrankname, targetrank=GetPVPRankInfo(UnitPVPRank("target"), "target");
	if (targetrank and Perl_Config.ShowTargetPVPRank==1 and UnitIsPlayer("target")) then
		Perl_Target_PVPRankIcon:Show();
		if (targetrank==0) then
			Perl_Target_PVPRankIcon:Hide();
		elseif (targetrank>9) then
			Perl_Target_PVPRankIcon:SetTexture("Interface\\PVPRankBadges\\PVPRank"..targetrank);
		else
			Perl_Target_PVPRankIcon:SetTexture("Interface\\PVPRankBadges\\PVPRank0"..targetrank);
		end
	else 
		Perl_Target_PVPRankIcon:Hide();
	end
	if (UnitIsPVP("target")) then
		if (UnitFactionGroup("target") == "Alliance") then
			Perl_Target_PVPStatus:SetTexture("Interface\\TargetingFrame\\UI-PVP-Alliance");
		elseif (UnitFactionGroup("target") == "Horde") then
			Perl_Target_PVPStatus:SetTexture("Interface\\TargetingFrame\\UI-PVP-Horde");
		else
			Perl_Target_PVPStatus:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		end
		Perl_Target_PVPStatus:Show();
	else
		Perl_Target_PVPStatus:Hide();
	end
end
function Perl_Target_UpdateCombo()
	local combopoints = GetComboPoints();
	if (Perl_Config.UseCPMeter == 1) then
		Perl_Target_CPFrame:Hide();
		Perl_Target_CPMeter:SetMinMaxValues(0, 5);
		Perl_Target_CPMeter:SetValue(combopoints);
		Perl_Target_CPMeter:Show();
		if (combopoints == 5) then
			Perl_Target_CPMeter:SetStatusBarColor(1, 0, 0, 0.7);
		elseif (combopoints == 4) then
			Perl_Target_CPMeter:SetStatusBarColor(1, 0.5, 0, 0.7);
		elseif (combopoints == 3) then
			Perl_Target_CPMeter:SetStatusBarColor(1, 1, 0, 0.6);
		elseif (combopoints == 2) then
			Perl_Target_CPMeter:SetStatusBarColor(0.5, 1, 0, 0.4);
		elseif (combopoints == 1) then
			Perl_Target_CPMeter:SetStatusBarColor(0, 1, 0, 0.4);
		else
			Perl_Target_CPMeter:Hide();
		end
	else
		Perl_Target_CPMeter:Hide();
		Perl_Target_CPFrame:Show();
		Perl_Target_CPText:Show();
		Perl_Target_CPText:SetText(combopoints);
		if (combopoints == 5) then
			Perl_Target_CPText:SetTextColor(1, 0, 0, 1);
		elseif (combopoints == 4) then
			Perl_Target_CPText:SetTextColor(1, 0.5, 0, 1);
		elseif (combopoints == 3) then
			Perl_Target_CPText:SetTextColor(1, 1, 0, 1);
		elseif (combopoints == 2) then
			Perl_Target_CPText:SetTextColor(0.5, 1, 0,1);
		elseif (combopoints == 1) then
			Perl_Target_CPText:SetTextColor(0, 1, 0, 1);
		else
			Perl_Target_CPText:Hide();
			Perl_Target_CPFrame:Hide();
		end
	end
end
function Perl_Target_UpdateManaType()
	local targetpower = UnitPowerType("target");
	local targetmana = UnitMana("target");
	local targetmanamax = UnitManaMax("target");
	if ((targetmanamax == 0) or (Perl_Config.ShowTargetMana==0)) then
		Perl_Target_ManaBar:Hide();
		Perl_Target_ManaBarBG:Hide();
		Perl_Target_StatsFrame:SetHeight(28);
		Perl_Target_Frame:SetHeight(28);
	elseif (targetpower == 1) then
		Perl_Target_ManaBar:SetStatusBarColor(1, 0, 0, 1);
		Perl_Target_ManaBarBG:SetStatusBarColor(1, 0, 0, 0.25);
		Perl_Target_ManaBar:Show();
		Perl_Target_ManaBarBG:Show();
		Perl_Target_ManaBarText:Hide();
		Perl_Target_StatsFrame:SetHeight(40);
		Perl_Target_Frame:SetHeight(50);
	elseif (targetpower == 2) then
		Perl_Target_ManaBar:SetStatusBarColor(1, 0.5, 0, 1);
		Perl_Target_ManaBarBG:SetStatusBarColor(1, 0.5, 0, 0.25);
		Perl_Target_ManaBar:Show();
		Perl_Target_ManaBarBG:Show();
		Perl_Target_StatsFrame:SetHeight(40);
		Perl_Target_ManaBarText:Hide();
		Perl_Target_Frame:SetHeight(50);
	elseif (targetpower == 3) then
		Perl_Target_ManaBar:SetStatusBarColor(1, 1, 0, 1);
		Perl_Target_ManaBarBG:SetStatusBarColor(1, 1, 0, 0.25);
		Perl_Target_ManaBar:Show();
		Perl_Target_ManaBarBG:Show();
		Perl_Target_StatsFrame:SetHeight(40);
		Perl_Target_ManaBarText:Hide();
		Perl_Target_Frame:SetHeight(50);
	else
		Perl_Target_ManaBar:SetStatusBarColor(0, 0, 1, 1);
		Perl_Target_ManaBarBG:SetStatusBarColor(0, 0, 1, 0.25);
		Perl_Target_ManaBar:Show();
		Perl_Target_ManaBarBG:Show();
		
		Perl_Target_ManaBarText:Show();
		Perl_Target_StatsFrame:SetHeight(40);
		Perl_Target_Frame:SetHeight(50);
	end
end
function Perl_Target_UpdateMana()
	local targetmana = UnitMana("target");
	local targetmanamax = UnitManaMax("target");
	if (Perl_Target_HealthBarPercent:IsVisible()) then Perl_Target_ManaBarPercent:Show(); end
	Perl_Target_ManaBar:SetMinMaxValues(0, targetmanamax);
	Perl_Target_ManaBar:SetValue(targetmana);
	Perl_Target_ManaBarPercent:SetText(string.format("%d",(100*(targetmana / targetmanamax))+0.5).."%");
	Perl_Target_ManaBarText:SetText(targetmana.."/"..targetmanamax);
end
function Perl_Target_UpdateHealth()
	local targethealth = UnitHealth("target");
	local targethealthmax = UnitHealthMax("target");
		
	Perl_Target_HealthBar:SetMinMaxValues(0, targethealthmax);
	Perl_Target_HealthBar:SetValue(targethealth);
	Perl_SetSmoothBarColor(Perl_Target_HealthBar);
	Perl_SetSmoothBarColor(Perl_Target_HealthBarBG, Perl_Target_HealthBar, 0.25);
	if (targethealthmax == 100) then
		Perl_Target_HealthBarPercent:SetText(targethealth.."%");
	else
		Perl_Target_HealthBarPercent:SetText(string.format("%d",(100*(targethealth / targethealthmax))+0.5).."%");
	end
	if (targethealthmax ~= 100) then
		Perl_Target_HealthBarText:SetText(targethealth.."/"..targethealthmax);
	else
		if MobHealthFrame then MobHealthFrame:Hide(); end
		local index;
		if UnitIsPlayer("target") then
			index = UnitName("target");
		else
			index = UnitName("target")..":"..UnitLevel("target");
		end
		if (( MobHealthDB and MobHealthDB[index]) or (MobHealthPlayerDB and MobHealthPlayerDB[index])) then
			local s, e;
			local pts;
			local pct;
			if MobHealthDB[index] then
				if ( type(MobHealthDB[index]) ~= "string" ) then
					Perl_Target_HealthBarText:SetText(targethealth.."%");
				end
				s, e, pts, pct = string.find(MobHealthDB[index], "^(%d+)/(%d+)$");
			else
				if ( type(MobHealthPlayerDB[index]) ~= "string" ) then
					Perl_Target_HealthBarText:SetText(targethealth.."%");
				end
				s, e, pts, pct = string.find(MobHealthPlayerDB[index], "^(%d+)/(%d+)$");
			end
			if ( pts and pct ) then
				pts = pts + 0;
				pct = pct + 0;
				if( pct ~= 0 ) then
					pointsPerPct = pts / pct;
				else
					pointsPerPct = 0;
				end
			end
			local currentPct = UnitHealth("target");
			if ( pointsPerPct > 0 ) then	
				Perl_Target_HealthBarText:SetText(string.format("%d", (currentPct * pointsPerPct) + 0.5).."/"..string.format("%d", (100 * pointsPerPct) + 0.5));
			end
		else
			Perl_Target_HealthBarText:SetText(targethealth.."%");
		end
	end
	if ((targethealth==0) and (targethealthmax==1)) then
		Perl_Target_ManaBarText:Hide();
		Perl_Target_HealthBarText:SetText("Offine");
	elseif ((targethealth==0) and ((targethealthmax>1) and (targethealthmax~=100))) then
		Perl_Target_ManaBarText:Hide();
	elseif ((targethealth==1) and ((targethealthmax>1) and (targethealthmax~=100))) then
		Perl_Target_ManaBarText:Hide();
		Perl_Target_HealthBarText:SetText("Ghost");
	end
	if ((targethealth==1) and ((targethealthmax==0) and (targethealthmax~=100))) then
		Perl_Target_ManaBarPercent:Hide();
		Perl_Target_HealthBarPercent:SetText("Ghost");
	elseif (targethealth==0) then
		Perl_Target_ManaBarPercent:Hide();
		Perl_Target_HealthBarPercent:SetText("Dead");
	end
end
---------------------
--Debuffs          --
---------------------
function Perl_Target_DebuffUpdate()

	if UnitClass("player")==PERL_LOC_CLASS_WARRIOR then
		local hasDebuff, _, _, debuff = Perl_UnitDebuffInformation( "target", "Sunder Armor", "Armor decreased by (%d+)\.$" );
		if hasDebuff and debuff then
			if debuff~=debuffAmnt then
				debuffAmnt=tonumber(debuff);
				debuffTime=GetTime();
				debuffDelta=tonumber(debuffDelta);
				if debuffAmnt < debuffDelta then
					debuffDelta=debuff;
				end
			end
			numDebuffs=debuff/debuffDelta;
			timeDebuff=math.floor( 30 - ( GetTime() - debuffTime ) );
		else
			numDebuffs=0;
			timeDebuff=nil;
		end
	elseif UnitClass("player")==PERL_LOC_CLASS_PRIEST then
		local hasDebuff, _, _, debuff = Perl_UnitDebuffInformation( "target", "Shadow Vulnerability", "Increases Shadow damage by (%d+)\%.$" );
		if hasDebuff and debuff then
			if debuff~=debuffAmnt then
				debuffAmnt=debuff;
				debuffTime=GetTime();
				if debuff < debuffDelta then
					debuffDelta=debuff;
				end
			end
			numDebuffs=debuff/debuffDelta;
			timeDebuff=math.floor( 15 - ( GetTime() - debuffTime ) );
		else
			numDebuffs=0;
			timeDebuff=nil;
		end
	elseif UnitClass("player")==PERL_LOC_CLASS_MAGE then
		local hasDebuff, _, _, debuff = Perl_UnitDebuffInformation( "target", "Fire Vulnerability", "Increases Fire damage taken by (%d+)\%.$" );
		if hasDebuff and debuff then
			if debuff~=debuffAmnt then
				debuffAmnt=debuff;
				debuffTime=GetTime();
				if debuff < debuffDelta then
					debuffDelta=debuff;
				end
			end
			numDebuffs=debuff/debuffDelta;
			timeDebuff=math.floor( 15 - ( GetTime() - debuffTime ) );
		else
			numDebuffs=0;
			timeDebuff=nil;
		end
	end
	if (GetComboPoints()==0) then
		if (Perl_Config.UseCPMeter == 1) then
			Perl_Target_CPFrame:Hide();
			Perl_Target_CPMeter:SetMinMaxValues(0, 5);
			Perl_Target_CPMeter:SetValue(numDebuffs);
			Perl_Target_CPMeter:Show();
			if (numDebuffs == 5) then
				Perl_Target_CPMeter:SetStatusBarColor(1, 0, 0, 0.4);
			elseif (numDebuffs == 4) then
				Perl_Target_CPMeter:SetStatusBarColor(1, 0.5, 0, 0.4);
			elseif (numDebuffs == 3) then
				Perl_Target_CPMeter:SetStatusBarColor(1, 1, 0, 0.4);
			elseif (numDebuffs == 2) then
				Perl_Target_CPMeter:SetStatusBarColor(0.5, 1, 0, 0.4);
			elseif (numDebuffs == 1) then
				Perl_Target_CPMeter:SetStatusBarColor(0, 1, 0, 0.4);
			else
				Perl_Target_CPMeter:Hide();
			end
		else
			Perl_Target_CPMeter:Hide();
			Perl_Target_CPFrame:Show();
			Perl_Target_CPText:Show();
			Perl_Target_CPText:SetText(numDebuffs);
			if (cnumDebuffs == 5) then
				Perl_Target_CPText:SetTextColor(1, 0, 0, 1);
			elseif (numDebuffs == 4) then
				Perl_Target_CPText:SetTextColor(1, 0.5, 0, 1);
			elseif (numDebuffs == 3) then
				Perl_Target_CPText:SetTextColor(1, 1, 0, 1);
			elseif (numDebuffs == 2) then
				Perl_Target_CPText:SetTextColor(0.5, 1, 0,1);
			elseif (numDebuffs == 1) then
				Perl_Target_CPText:SetTextColor(0, 1, 0, 1);
			else
				Perl_Target_CPText:Hide();
				Perl_Target_CPFrame:Hide();
			end
		end
	else
		local combopoints = GetComboPoints();
		if (Perl_Config.UseCPMeter == 1) then
			Perl_Target_CPFrame:Hide();
			Perl_Target_CPMeter:SetMinMaxValues(0, 5);
			Perl_Target_CPMeter:SetValue(combopoints);
			Perl_Target_CPMeter:Show();
			if (combopoints == 5) then
				Perl_Target_CPMeter:SetStatusBarColor(1, 0, 0, 0.7);
			elseif (combopoints == 4) then
				Perl_Target_CPMeter:SetStatusBarColor(1, 0.5, 0, 0.7);
			elseif (combopoints == 3) then
				Perl_Target_CPMeter:SetStatusBarColor(1, 1, 0, 0.6);
			elseif (combopoints == 2) then
				Perl_Target_CPMeter:SetStatusBarColor(0.5, 1, 0, 0.4);
			elseif (combopoints == 1) then
				Perl_Target_CPMeter:SetStatusBarColor(0, 1, 0, 0.4);
			else
				Perl_Target_CPMeter:Hide();
			end
		else
			Perl_Target_CPMeter:Hide();
			Perl_Target_CPFrame:Show();
			Perl_Target_CPText:Show();
			Perl_Target_CPText:SetText(combopoints);
			if (combopoints == 5) then
				Perl_Target_CPText:SetTextColor(1, 0, 0, 1);
			elseif (combopoints == 4) then
				Perl_Target_CPText:SetTextColor(1, 0.5, 0, 1);
			elseif (combopoints == 3) then
				Perl_Target_CPText:SetTextColor(1, 1, 0, 1);
			elseif (combopoints == 2) then
				Perl_Target_CPText:SetTextColor(0.5, 1, 0,1);
			elseif (combopoints == 1) then
				Perl_Target_CPText:SetTextColor(0, 1, 0, 1);
			else
				Perl_Target_CPText:Hide();
				Perl_Target_CPFrame:Hide();
			end
		end
	end
end
--------------------
-- Buff Functions --
--------------------

function Perl_Target_Buff_UpdateAll ()
	Perl_Target_UpdatePortrait();
	if ((UnitFactionGroup("player") == UnitFactionGroup("target"))) then
		Perl_Target_DeBuffFrameBuffer:SetHeight(24);
		Perl_Target_BuffFrameBuffer:SetHeight(3);
	else
		Perl_Target_DeBuffFrameBuffer:SetHeight(3);
		Perl_Target_BuffFrameBuffer:SetHeight(34);
	end
	if (UnitName("target")) then
		for buffnum=1,20 do
			local button = getglobal("Perl_Target_Buff"..buffnum);
			local icon = getglobal(button:GetName().."Icon");
			if (UnitBuff("target", buffnum)) then
				icon:SetTexture(UnitBuff("target", buffnum));
				button:Show();
			else
				button:Hide();
			end
		end
		
				
		for buffnum=1,16 do
			local button = getglobal("Perl_Target_DeBuff"..buffnum);
			local icon = getglobal(button:GetName().."Icon");
			
			
			if (UnitDebuff("target", buffnum)) then
				icon:SetTexture(UnitDebuff("target", buffnum));
				button:Show();
			else
				button:Hide();
			end
		end
	end
end

function Perl_Target_SetBuffTooltip ()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetUnitBuff("target", this:GetID());
end
function Perl_Target_SetDeBuffTooltip ()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetUnitDebuff("target", this:GetID());
end

function Perl_Target_PlayerTip()
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	GameTooltip:SetUnit("Target");
end

--------------------
-- Click Handlers --
--------------------

function Perl_TargetDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Perl_TargetDropDown_Initialize, "MENU");
end
				
function Perl_TargetDropDown_Initialize()
	local menu = nil;
	if ( UnitIsEnemy("target", "player") ) then
		return;
	end
	if ( UnitIsUnit("target", "player") ) then
		menu = "SELF";
	elseif ( UnitIsUnit("target", "pet") ) then
		menu = "PET";
	elseif ( UnitIsPlayer("target") ) then
		if ( UnitInParty("target") ) then
			menu = "PARTY";
		else
			menu = "PLAYER";
		end
	end
	if ( menu ) then
		UnitPopup_ShowMenu(Perl_Target_DropDown, menu, "target");
	end
end

function Perl_Target_MouseUp(button)
	if ( SpellIsTargeting() and button == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( button == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("target");
		elseif ( CursorHasItem() ) then
			DropItemOnUnit("target");
		end
	else
		ToggleDropDownMenu(1, nil, Perl_Target_DropDown, "Perl_Target_NameFrame", 40, -25);
	end
	
	Perl_Target_Frame:StopMovingOrSizing();
	--Perl_Target_ComboBubbles:StopMovingOrSizing();
end

function Perl_Target_MouseDown(button)
	if ( button == "LeftButton" and perl_locked == 0) then
		if (this:GetName()=="Perl_Target_ComboBubbles_Overlay") then
			Perl_Target_ComboBubbles:StartMoving();
		else
			Perl_Target_Frame:StartMoving();
		end
	end
end
