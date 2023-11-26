--[[	****************************************************************
	MiniGroup vK0.4b (bugbash ver)

	Author: Kaitlin of Sargeras
	****************************************************************
	Description:
		A set of moveable, dockable, and configurable
		minimalistic, DAoC-esque mini-windows including
		Mini-Group, Mini-Target, and Mini-Group Buff windows.

	Thank you to:
		Lothero of Sargeras (my bro) for debuffing me instead
			of leveling
		ImageShack.us for hosting my pics

	Official Site:
		wow.jaslaughter.com
	
	K0.4a-Target
	****************************************************************]]

-- Local Vars
local MAX_TARGET_DEBUFFS = 6;
local inCombat = 0;

-- Global Vars
MGTarget_IsLoaded = 0;

function MGTarget_OnLoad()
	this.statusCounter = 0;
	this.statusSign = -1;
	this.unitHPPercent = 1;
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_FACTION");
	this:RegisterEvent("UNIT_DYNAMIC_FLAGS");
	this:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
	this:RegisterEvent("PLAYER_PVPLEVEL_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED" );

	-- ** Tell UIDropDownMenu to check my dropdown
	table.insert(UnitPopupFrames,"MGTarget_DropDown");
	MGTarget_IsLoaded = 1;
end

function MGTarget_Update()
	if ( UnitExists("target") and MG_Get("ShowMGTargetFrame") == 1 ) then
		this:Hide();
		this:Show();
	else
		this:Hide();
	end
end

function MGTarget_OnEvent(event)
	if ( MGPlayer == nil ) then
		return;
	end

	UnitFrame_OnEvent(event);

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		MGTarget_Update();
	end
	if ( event == "UNIT_FACTION" ) then
		if ( arg1 == "target" or arg1 == "player" ) then
			MGTarget_CheckFaction();
			MGTarget_CheckLevel();
		end
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_REGEN_DISABLED") then
		inCombat = 1;
		MGTarget_UpdateCombatStatus();
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" or event == "PLAYER_REGEN_ENABLED") then
		inCombat = 0;
		MGTarget_UpdateCombatStatus();
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		MGTarget_UpdateCombos();
		return;
	end
	if ( arg1 ~= "target" ) then
		return;
	end
	if ( event == "UNIT_HEALTH" ) then
		MGTarget_CheckDead();
		return;
	end
	if ( event == "UNIT_LEVEL" ) then
		MGTarget_CheckLevel();
		return;
	end
	if ( event == "UNIT_DYNAMIC_FLAGS" ) then
		MGTarget_CheckFaction();
		return;
	end
	if ( event == "UNIT_CLASSIFICATION_CHANGED" ) then
		MGTarget_CheckLevel();
		return;
	end
	if ( event == "UNIT_AURA" ) then
		MGTargetDebuffButton_Update();
		return;
	end
end

function MGTarget_OnShow()
	-- This was in the MGTarget_Update() and I moved it
		UnitFrame_Update();
		UnitFrame_UpdateManaType();
		MGTarget_CheckLevel();
		MGTarget_CheckFaction();
		MGTarget_CheckDead();
		MGTarget_UpdateCombos();
		MGTargetDebuffButton_Update();
	-- ************************************************
	local info = ManaBarColor[UnitPowerType("target")];
	MGTarget_ManaBarBG:SetStatusBarColor(info.r, info.g, info.b, 0.25);
	MGTarget_UpdateCombatStatus();
	if ( MG_Get("ShowTargetFrame") == 0 and TargetFrame:IsVisible() ) then
		TargetFrame:Hide();
		if (getglobal("MobHealthFrame")) then
			MobHealthFrame:Hide();
		end
	end
end

function MGTarget_OnHide()
	this:StopMovingOrSizing();
	CloseDropDownMenus();
end

function MGTarget_CheckLevel()
	local playerLevel = UnitLevel("player");
	local targetLevel = UnitLevel("target");
	local targetMobType = MGTarget_GetMobType();
	local displayText;

	if ( targetLevel == -1 ) then
		displayText = "??";
	elseif ( targetLevel == 0 ) then
		displayText = "";
	else
		displayText = targetLevel;
	end

	if ( targetMobType ) then
		if (targetMobType == "Boss") then
			displayText = targetMobType;
		else
			displayText = targetMobType.." "..displayText;
		end
	else
		displayText = "Level "..displayText;
	end

	if ( UnitIsCorpse("target") ) then
		displayText = "Corpse";
	end

	MGTarget_Info:SetText(displayText);
	-- Color level number
	local color = GetDifficultyColor(targetLevel);
	MGTarget_Info:SetVertexColor(color.r, color.g, color.b);
end

function MGTarget_CheckFaction()
	local r, g, b, a;
	a = 0.4;
	if ( UnitPlayerControlled("target") ) then
		if ( UnitCanAttack("target", "player") ) then
			-- Hostile players are red
			if ( not UnitCanAttack("player", "target") ) then
				r = 0.0;
				g = 0.0;
				b = 1.0;
			else
				r = UnitReactionColor[2].r;
				g = UnitReactionColor[2].g;
				b = UnitReactionColor[2].b;
			end
		elseif ( UnitCanAttack("player", "target") ) then
			-- Players we can attack but which are not hostile are yellow
			r = UnitReactionColor[4].r;
			g = UnitReactionColor[4].g;
			b = UnitReactionColor[4].b;
		elseif ( UnitIsPVP("target") ) then
			-- Players we can assist but are PvP flagged are green
			r = UnitReactionColor[6].r;
			g = UnitReactionColor[6].g;
			b = UnitReactionColor[6].b;
		else
			-- All other players are blue (the usual state on the "blue" server)
			r = 0.0;
			g = 0.0;
			b = 1.0;
		end
		MGTarget_BG:SetVertexColor(r, g, b, a);
	elseif ( UnitIsTapped("target") and not UnitIsTappedByPlayer("target") ) then
		MGTarget_BG:SetVertexColor(0.5, 0.5, 0.5, a);
	else
		local reaction = UnitReaction("target", "player");
		if ( reaction ) then
			r = UnitReactionColor[reaction].r;
			g = UnitReactionColor[reaction].g;
			b = UnitReactionColor[reaction].b;
			MGTarget_BG:SetVertexColor(r, g, b, a);
		else
			MGTarget_BG:SetVertexColor(0, 0, 1.0, a);
		end
	end

	local factionGroup = UnitFactionGroup("target");
	if ( UnitIsPVPFreeForAll("target") ) then
		MGTarget_PVP:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		MGTarget_PVP:Show();
	elseif ( factionGroup and UnitIsPVP("target") ) then
		MGTarget_PVP:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		MGTarget_PVP:Show();
	else
		MGTarget_PVP:Hide();
	end
end

function MGTarget_CheckDead()
	if ( (UnitHealth("target") <= 0) and UnitIsConnected("target") ) then
		MGTarget_DeadText:Show();
	else
		MGTarget_DeadText:Hide();
	end
end

function MGTarget_OnClick(button)
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
		local distance = ( UIParent:GetWidth() - MGTarget_Frame:GetRight() );
		if ( distance <= 100 ) then
			ToggleDropDownMenu(1, nil, MGTarget_DropDown, "MGTarget_Title", -100, 60);
		else
			ToggleDropDownMenu(1, nil, MGTarget_DropDown, "MGTarget_Title", 100, 60);
		end
	end
end

function MGTargetDebuffButton_Update()
	local unitName = MGTarget_TitleBliz:GetText();
	local unitText = MGTarget_Title;
	local unitBlizText = MGTarget_TitleBliz;
	local debuff, debuffButton, buff, buffButton;
	local button,debuffType;
	local unitDebuffs = {};

	if ( MG_Get("MGTarget_BuffFrame") == 1 ) then
		if ( MG_Get("TargetAuraPos") == 1 ) then
			-- Position buffs depending on whether the targeted unit is friendly or not
			if ( UnitIsFriend("player", "target") ) then
				MGTarget_Buff1:SetPoint("TOPLEFT", "MGTarget_Frame", "TOPLEFT", 14, 44);
				MGTarget_Debuff1:SetPoint("TOPLEFT", "MGTarget_Buff1", "BOTTOMLEFT", 0, -2);
			else
				MGTarget_Debuff1:SetPoint("TOPLEFT", "MGTarget_Frame", "TOPLEFT", 14, 44);
				MGTarget_Buff1:SetPoint("TOPLEFT", "MGTarget_Debuff1", "BOTTOMLEFT", 0, -2);
			end
		else
			-- Below
			-- Position buffs depending on whether the targeted unit is friendly or not
			if ( UnitIsFriend("player", "target") ) then
				MGTarget_Buff1:SetPoint("TOPLEFT", "MGTarget_Frame", "BOTTOMLEFT", 14, -2);
				MGTarget_Debuff1:SetPoint("TOPLEFT", "MGTarget_Buff1", "BOTTOMLEFT", 0, -2);
			else
				MGTarget_Debuff1:SetPoint("TOPLEFT", "MGTarget_Frame", "BOTTOMLEFT", 14, -2);
				MGTarget_Buff1:SetPoint("TOPLEFT", "MGTarget_Debuff1", "BOTTOMLEFT", 0, -2);
			end
		end

		for i=1, MAX_TARGET_DEBUFFS do
			buff = UnitBuff("target", i);
			button = getglobal("MGTarget_Buff"..i);
			if ( buff ) then
				getglobal("MGTarget_Buff"..i.."Icon"):SetTexture(buff);
				button:Show();
				button.id = i;
			else
				button:Hide();
			end
		end
		for i=1, MAX_TARGET_DEBUFFS do
			debuff = UnitDebuff("target", i);

			MGTooltipTextRight1:SetText("");
			MGTooltip:SetUnitDebuff("target", i);
			debuffType = MGTooltipTextRight1:GetText();
			if ( debuffType ) then
				table.insert(unitDebuffs, debuffType);
				debuffType = nil;
			end

			button = getglobal("MGTarget_Debuff"..i);
			if ( debuff ) then
				getglobal("MGTarget_Debuff"..i.."Icon"):SetTexture(debuff);
				button:Show();
			else
				button:Hide();
			end
			button.id = i;
		end
	else
		local button;
		for i=1, MAX_TARGET_DEBUFFS do
			button = getglobal("MGTarget_Buff"..i);
			button:Hide();
		end
		for i=1, MAX_TARGET_DEBUFFS do
			button = getglobal("MGTarget_Debuff"..i);
			button:Hide();
		end
	end

	if ( not unitName ) then
		unitName = "";
	end

	if ( table.getn(unitDebuffs) > 0 and (MG_Get("ShowTColorBlindIndicators") == 1 or MG_Get("ShowTColorIndicators") == 1) ) then
		info = MiniGroup_GetDebuffColor(unitDebuffs);
		if ( MG_Get("ShowTColorBlindIndicators") == 1 ) then
			unitText:SetText(info.c..unitName..info.c);
		else
			unitText:SetText(unitName);
		end
		if ( MG_Get("ShowTColorIndicators") == 1 ) then
			unitText:SetVertexColor(info.r,info.g,info.b);
		else
			unitText:SetVertexColor(1,0.82,0);
		end
	else
		unitText:SetText(unitName);
		unitText:SetVertexColor(1,0.82,0);
	end

	unitBlizText:Hide();
end

function MGTargetHealthCheck()
	local unitMinHP, unitMaxHP, unitCurrHP, unitPercentHP;
	local TelosInfo = MGTarget_GetTelosInfo();
	unitHPMin, unitHPMax = MGTarget_HealthBar:GetMinMaxValues();
	unitCurrHP = MGTarget_HealthBar:GetValue();
	MGTarget_HealthBar:GetParent().unitHPPercent = unitCurrHP / unitHPMax;

	unitPercentHP = ""..((unitCurrHP/unitHPMax)*100);
	unitPercentHP = string.gsub(unitPercentHP, "(%d+)(%.)(%d+)", "%1");

	if ( MG_Get("ShowHealthType") == 1 ) then
		if ( UnitIsUnit("target","pet") or UnitInParty("target") or UnitIsUnit("target", "player") ) then
			MGTarget_HealthText:SetText(unitCurrHP.."/"..unitHPMax);
		elseif ( TelosInfo ) then
			MGTarget_HealthText:SetText(TelosInfo);
		else
			MGTarget_HealthText:SetText(unitPercentHP.."%");
		end
	else
		MGTarget_HealthText:SetText(unitPercentHP.."%");
	end

	MGTarget_CheckFaction();
end

function MGTargetFrameDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, MGTargetFrameDropDown_Initialize, "MENU");
end

function MGTargetFrameDropDown_Initialize()
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
		UnitPopup_ShowMenu(MGTarget_DropDown, menu, "target");
	end
end

function MGTarget_UpdateCombatStatus()
	if (inCombat == 1) then
		-- Red
		MGTarget_FrameBackdrop:SetBackdropColor(0.2,0,0);
		MGTarget_FrameBackdrop:SetBackdropBorderColor(1.0,0,0);
		MGParty_TitleBarText:SetText("MG (Combat)");
	else
		-- Normal
		MGTarget_FrameBackdrop:SetBackdropColor(MGTarget_FrameColors.red, MGTarget_FrameColors.green, MGTarget_FrameColors.blue, MGTarget_FrameColors.alpha);
		MGTarget_FrameBackdrop:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r,TOOLTIP_DEFAULT_COLOR.g,TOOLTIP_DEFAULT_COLOR.b, MGTarget_FrameColors.alpha);
		MGParty_CheckResting();
	end
end

function MGTarget_UpdateCombos()
	local points = GetComboPoints();
	if ( ComboFrame:IsVisible() and MG_Get("ShowTargetFrame") == 0 ) then
		ComboFrame:Hide();
	end
	if ( points > 0 ) then
		MGTarget_Combo:SetText("Combo: "..NORMAL_FONT_COLOR_CODE..points..FONT_COLOR_CODE_CLOSE);
	elseif ( UnitIsPlayer("target") ) then
		MGTarget_Combo:SetText(UnitClass("target"));
	elseif ( UnitCreatureType("target") == "Humanoid" and UnitIsFriend("player", "target") ) then
		MGTarget_Combo:SetText( "NPC" );
	else
		MGTarget_Combo:SetText(UnitCreatureType("target"));
	end
end

function MGTarget_GetMobType()
	local classification = UnitClassification("target");
	if ( classification == "worldboss" ) then
		return "Boss";
	elseif ( classification == "rareelite"  ) then
		return "Rare-Elite";
	elseif ( classification == "elite"  ) then
		return "Elite";
	elseif ( classification == "rare"  ) then
		return "Rare";
	else
		return nil;
	end
end

function MGTarget_GetTelosInfo()
	if ( UnitName("target") and UnitLevel("target") ) then
		local index = UnitName("target")..":"..UnitLevel("target");
		local text = "";

		if ( MobHealthDB and MobHealthDB[index] ) then
			local s, e;
			local pts;
			local pct;

			if ( type(MobHealthDB[index]) ~= "string" ) then
				return;
			end
			s, e, pts, pct = string.find(MobHealthDB[index], "^(%d+)/(%d+)$");
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
				if ( currentPct ) then
					text = string.format("%d/%d", (currentPct * pointsPerPct) + 0.5, (100 * pointsPerPct) + 0.5);
				else
					text = string.format("???/%d", (100 * pointsPerPct) + 0.5);
				end
			end
			return text;
		else
			return nil;
		end
	else
		return nil;
	end
end

function MGTarget_BuffTooltip_Update()
	for i = 1, MAX_PARTY_TOOLTIP_BUFFS do
		getglobal("MGTarget_BuffTooltip_Buff"..i):Hide();
	end
	for i = 1, MAX_PARTY_TOOLTIP_DEBUFFS do
		getglobal("MGTarget_BuffTooltip_Debuff"..i):Hide();
	end

	local TipStyle = MG_Get("MGTToolTipStyle");
	local buff, buffButton;
	local numBuffs = 0;
	local numDebuffs = 0;
	local index;

	if ( TipStyle == 1 or TipStyle == 3 ) then
		index = 1;
		for i=1, MAX_PARTY_TOOLTIP_BUFFS do
			if ( isPet ) then
				buff = UnitBuff("pet", i);		
			else
				buff = UnitBuff("target", i);
			end
			if ( buff ) then
				getglobal("MGTarget_BuffTooltip_Buff"..index.."Icon"):SetTexture(buff);
				getglobal("MGTarget_BuffTooltip_Buff"..index.."Overlay"):Hide();
				getglobal("MGTarget_BuffTooltip_Buff"..index):Show();
				index = index + 1;
				numBuffs = numBuffs + 1;
			end
		end
		for i=index, MAX_PARTY_TOOLTIP_BUFFS do
			getglobal("MGTarget_BuffTooltip_Buff"..i):Hide();
		end
	end

	if ( numBuffs == 0 ) then
		MGTarget_BuffTooltip_Debuff1:SetPoint("TOP", "MGTarget_BuffTooltip_Buff1", "TOP", 0, 0);
	elseif ( numBuffs <= 8 ) then
		MGTarget_BuffTooltip_Debuff1:SetPoint("TOP", "MGTarget_BuffTooltip_Buff1", "BOTTOM", 0, -2);
	else
		MGTarget_BuffTooltip_Debuff1:SetPoint("TOP", "MGTarget_BuffTooltip_Buff9", "BOTTOM", 0, -2);
	end

	if ( TipStyle == 2 or TipStyle == 3 ) then
		index = 1;
		for i=1, MAX_PARTY_TOOLTIP_DEBUFFS do
			if ( isPet ) then
				buff = UnitDebuff("pet", i);
			else
				buff = UnitDebuff("target", i);
			end

			if ( buff ) then
				getglobal("MGTarget_BuffTooltip_Debuff"..index.."Icon"):SetTexture(buff);
				getglobal("MGTarget_BuffTooltip_Debuff"..index.."Overlay"):Show();
				getglobal("MGTarget_BuffTooltip_Debuff"..index):Show();
				index = index + 1;
				numDebuffs = numDebuffs + 1;
			end
		end
		for i=index, MAX_PARTY_TOOLTIP_DEBUFFS do
			getglobal("MGTarget_BuffTooltip_Debuff"..i):Hide();
		end
	end

	-- Size the tooltip
	local rows = ceil(numBuffs / 8) + ceil(numDebuffs / 8);
	local columns = min(8, max(numBuffs, numDebuffs));
	if ( (rows > 0) and (columns > 0) ) then
		MGTarget_BuffTooltip:SetWidth( (columns * 17) + 15 );
		MGTarget_BuffTooltip:SetHeight( (rows * 17) + 15 );
		MGTarget_BuffTooltip:Show();
	else
		MGTarget_BuffTooltip:Hide();
	end
end

function MGTarget_OnEnter(frame)
	if ( not frame ) then
		frame = this
	end
	if ( MG_Get("ShowMGTargetTips") ~= 0 ) then
		MGTarget_BuffTooltip:SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 60, -25);
		MGTarget_BuffTooltip_Update();
	end
end

function MGTarget_OnLeave(frame)
	if ( not frame ) then
		frame = this;
	end
	if ( MG_Get("ShowMGTargetTips") ~= 0 ) then
		MGTarget_BuffTooltip:Hide();
	end
end
