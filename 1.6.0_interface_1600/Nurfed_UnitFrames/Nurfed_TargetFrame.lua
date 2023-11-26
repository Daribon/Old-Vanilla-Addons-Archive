--[[***** Nurfed TargetFrame *****]]--
--[[***** Modifies the default TargetFrame *****]]--

function NurfedTarget_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this.statusCounter = 0;
	this.statusSign = -1;
	this.unitHPPercent = 1;

	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_FACTION");
	this:RegisterEvent("UNIT_DYNAMIC_FLAGS");
	this:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PLAYER_FLAGS_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PLAYER_COMBO_POINTS");

	table.insert(UnitPopupFrames,"Nurfed_targetDropDown");
	this.unit = "target";
	Nurfed_ToT_LastUpdate = 0;
	TargetTimeSinceLastUpdate = 0;
end

function NurfedTarget_OnEvent(event)
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		Nurfed_targetUpdate();
		return;
	end
	if ( event == "UNIT_FACTION" ) then
		if ( arg1 == "target" or arg1 == "player" ) then
			NurfedTarget_CheckFaction();
			NurfedTarget_CheckLevel();
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		NurfedTarget_UpdateCombos();
		return;
	end
	if ( arg1 ~= "target" ) then
		return;
	end
	if ( event == "UNIT_LEVEL" ) then
		NurfedTarget_CheckLevel();
		return;
	end
	if ( event == "UNIT_DYNAMIC_FLAGS" ) then
		NurfedTarget_CheckFaction();
		return;
	end
	if ( event == "UNIT_CLASSIFICATION_CHANGED" ) then
		NurfedTarget_CheckLevel();
		return;
	end
end

function Nurfed_targetUpdate()
	if ( UnitExists("target") ) then
		this:Show();
		Nurfed_targetName:SetText(UnitName("target"));
		NurfedTarget_CheckLevel();
		NurfedTarget_CheckFaction();
		NurfedTarget_UpdateCombos();
		Nurfed_UpdatePvP("target");
		if (getglobal("MobHealthFrame")) then
			MobHealthFrame:Hide();
		end
		if(UnitManaMax("target") == 0) then
			Nurfed_targetManaBar:Hide();
			Nurfed_targetManaText:Hide();
			Nurfed_target:SetHeight(46);
		else
			Nurfed_targetManaBar:Show();
			Nurfed_targetManaText:Show();
			Nurfed_target:SetHeight(55);
		end
		if ( UnitIsUnit("target", "player") or UnitIsUnit("target", "pet") or UnitInParty("target") or UnitInRaid("target") ) then
			Nurfed_RefreshAuras("target", Nurfed_UnitAuras["target"].buffs, Nurfed_UnitAuras["target"].debuffs);
			Nurfed_UpdateHealth("target");
			Nurfed_UpdateMana("target");
			Nurfed_UpdateManaType("target");
			Nurfed_AuraUpdatePos("target");
		end
	else
		this:Hide();
		Nurfed_targettarget:Hide();
		Nurfed_targettargettarget:Hide();
	end
end

function NurfedTarget_CheckFaction()
	local info = Nurfed_Reaction("target");
	Nurfed_targetBG:SetVertexColor(info.r, info.g, info.b, info.a);
	Nurfed_UpdateRank("target");
end

function NurfedTarget_CheckLevel()
	local playerLevel = UnitLevel("player");
	local targetLevel = UnitLevel("target");
	local targetMobType = NurfedTarget_GetMobType();
	local displayText;

	if ( UnitIsPlusMob("target") ) then
		displayText = targetLevel.."+";
	elseif ( targetLevel == 0 ) then
		displayText = "";
	elseif ( targetLevel < 0 ) then
		displayText = "??";
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

	Nurfed_targetInfo:SetText(displayText);
	-- Color level number
	local color = GetDifficultyColor(targetLevel);
	Nurfed_targetInfo:SetVertexColor(color.r, color.g, color.b);
end

function NurfedTarget_GetMobType()
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

function NurfedTarget_UpdateCombos()
	local points = GetComboPoints();
	if ( ComboFrame:IsVisible() ) then
		ComboFrame:Hide();
	end
	if ( points > 0 ) then
		Nurfed_targetCombo:SetText("Combo: "..NORMAL_FONT_COLOR_CODE..points..FONT_COLOR_CODE_CLOSE);
	elseif ( UnitIsPlayer("target") ) then
		local classcolor = Nurfed_UnitClass[UnitClass("target")];
		if (not classcolor) then classcolor = "FFFFFF"; end
		Nurfed_targetCombo:SetText("|cff"..classcolor..UnitClass("target").."|r");
	elseif ( UnitCreatureType("target") == "Humanoid" and UnitIsFriend("player", "target") ) then
		Nurfed_targetCombo:SetText( "NPC" );
	else
		Nurfed_targetCombo:SetText(UnitCreatureType("target"));
	end
end

function Nurfed_TargetOnShow()
	if ( UnitIsEnemy("target", "player") ) then
		PlaySound("igCreatureAggroSelect");
	elseif ( UnitIsFriend("player", "target") ) then
		PlaySound("igCharacterNPCSelect");
	else
		PlaySound("igCreatureNeutralSelect");
	end
end

function NurfedTarget_OnHide()
	PlaySound("INTERFACESOUND_LOSTTARGETUNIT");
	this:StopMovingOrSizing();
	CloseDropDownMenus();
end

function Nurfed_TargetGetTelosInfo(unit)
	if ( UnitName(unit) and UnitLevel(unit) ) then
		local index = UnitName(unit)..":"..UnitLevel(unit);
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

			local currentPct = UnitHealth(unit);

			if ( pointsPerPct > 0 ) then	
				if ( currentPct ) then
					telocurr = string.format("%d", (currentPct * pointsPerPct) + 0.5);
					telomax = string.format("%d", (100 * pointsPerPct) + 0.5);
				else
					telocurr = string.format("%d", (100 * pointsPerPct) + 0.5);
					telomax = string.format("%d", (100 * pointsPerPct) + 0.5);
				end
			end
			return telocurr, telomax;
		else
			return nil;
		end
	else
		return nil;
	end
end
