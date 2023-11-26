-- Nurfed Unit Frames Global Variables

---------------------------------------------------------------------------
--			Blizz Unit Frame Functions
---------------------------------------------------------------------------

function Nurfed_DisablePlayer()
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

function Nurfed_DisablePet()
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

function Nurfed_DisableTarget()
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

function Nurfed_DisableParty()
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

---------------------------------------------------------------------------
--			Unit Dropdowns
---------------------------------------------------------------------------

function Nurfed_UnitDropDown_OnLoad()
	local unit = Nurfed_Units[this:GetParent():GetName()];
	if (unit == "player") then
		UIDropDownMenu_Initialize(this, Nurfed_playerDropDown_Initialize, "MENU");
	elseif (unit == "pet") then
		UIDropDownMenu_Initialize(this, Nurfed_petDropDown_Initialize, "MENU");
	elseif (unit == "target") then
		UIDropDownMenu_Initialize(this, Nurfed_targetDropDown_Initialize, "MENU");
	elseif ( UnitInParty(unit) ) then
		UIDropDownMenu_Initialize(this, Nurfed_partyDropDown_Initialize, "MENU");
	end
end

function Nurfed_playerDropDown_Initialize()
	UnitPopup_ShowMenu(Nurfed_playerDropDown, "SELF", "player");
end

function Nurfed_petDropDown_Initialize ()
	if ( UnitExists("pet") ) then
		UnitPopup_ShowMenu(Nurfed_petDropDown, "PET", "pet");
	end
end

function Nurfed_targetDropDown_Initialize()
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
		UnitPopup_ShowMenu(Nurfed_targetDropDown, menu, "target");
	end
end

function Nurfed_partyDropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	UnitPopup_ShowMenu(dropdown, "PARTY", "party"..this:GetID());
end

---------------------------------------------------------------------------
--			Unit Misc. Functions
---------------------------------------------------------------------------

function Nurfed_UpdatePvP(unit)
	local icon = getglobal("Nurfed_"..unit.."PVPIcon");
	if (not icon) then return; end
	local factionGroup = UnitFactionGroup(unit);
	if ( UnitIsPVPFreeForAll(unit) ) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		icon:Show();
	elseif ( factionGroup and UnitIsPVP(unit) ) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		icon:Show();
	else
		icon:Hide();
	end
end

function Nurfed_UpdateRank(unit)
	local rankname, ranknumber = GetPVPRankInfo(UnitPVPRank(unit));
	if (ranknumber) then
		local icon = getglobal("Nurfed_"..unit.."RankIcon");
		icon:Show();
		if (ranknumber==0) then
			icon:Hide();
		elseif (ranknumber>9) then
			icon:SetTexture("Interface\\PVPRankBadges\\PVPRank"..ranknumber);
		else
			icon:SetTexture("Interface\\PVPRankBadges\\PVPRank0"..ranknumber);
		end
	else 
		icon:Hide();
	end
end

function Nurfed_UpdatePartyLoot()
	local id = this:GetID();
	local lootMethod, lootMaster = GetLootMethod();
	local color = ITEM_QUALITY_COLORS[GetLootThreshold()];

	Nurfed_PartyLoot:SetText(UnitLootMethod[lootMethod].text);
	Nurfed_PartyLoot:SetVertexColor(color.r, color.g, color.b);

	if (lootMaster == 0) then
		Nurfed_playerMasterIcon:Show();
	else
		Nurfed_playerMasterIcon:Hide();
	end

	if( (lootMaster == id) and (id > 0) ) then
		getglobal("Nurfed_party"..id.."MasterIcon"):Show();
	elseif (id > 0) then
		getglobal("Nurfed_party"..id.."MasterIcon"):Hide();
	end
end

function Nurfed_Reaction(unit)
	local info = {};
	info.a = 0.7;
	if ( UnitPlayerControlled(unit) ) then
		if ( UnitCanAttack(unit, "player") ) then
			-- Hostile players are red
			if ( not UnitCanAttack("player", unit) ) then
				info.r = 0.0;
				info.g = 0.0;
				info.b = 1.0;
			else
				info.r = UnitReactionColor[2].r;
				info.g = UnitReactionColor[2].g;
				info.b = UnitReactionColor[2].b;
			end
		elseif ( UnitCanAttack("player", unit) ) then
			-- Players we can attack but which are not hostile are yellow
			info.r = UnitReactionColor[4].r;
			info.g = UnitReactionColor[4].g;
			info.b = UnitReactionColor[4].b;
		elseif ( UnitIsPVP(unit) ) then
			-- Players we can assist but are PvP flagged are green
			info.r = UnitReactionColor[6].r;
			info.g = UnitReactionColor[6].g;
			info.b = UnitReactionColor[6].b;
		else
			-- All other players are blue (the usual state on the "blue" server)
			info.r = 0.0;
			info.g = 0.0;
			info.b = 1.0;
		end
	elseif ( UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) ) then
		info.r = 0.5;
		info.g = 0.5;
		info.b = 0.5;
	else
		local reaction = UnitReaction(unit, "player");
		if ( reaction ) then
			info.r = UnitReactionColor[reaction].r;
			info.g = UnitReactionColor[reaction].g;
			info.b = UnitReactionColor[reaction].b;
		else
			info.r = 0.0;
			info.g = 0.0;
			info.b = 1.0;
		end
	end
	return info;
end

function Nurfed_Update_ToT(unit)
	local name = UnitName(unit);
	local info = {};
	if (name and (Nurfed_UnitFrames[Nurfed_UnitPlayer][unit] == 1)) then
		getglobal("Nurfed_"..unit):Show();
		getglobal("Nurfed_"..unit.."Name"):SetText(name);
		info = Nurfed_Reaction(unit);
		getglobal("Nurfed_"..unit.."BG"):SetVertexColor(info.r, info.g, info.b, info.a);
		Nurfed_UpdateHealth(unit);
		Nurfed_UpdateMana(unit);
		Nurfed_UpdateManaType(unit);

		if(UnitManaMax(unit) == 0) then
			getglobal("Nurfed_"..unit.."ManaBar"):Hide();
			getglobal("Nurfed_"..unit.."ManaText"):Hide();
			getglobal("Nurfed_"..unit):SetHeight(20);
		else
			getglobal("Nurfed_"..unit.."ManaBar"):Show();
			getglobal("Nurfed_"..unit):SetHeight(26);
		end
	else
		getglobal("Nurfed_"..unit):Hide();
	end
end

---------------------------------------------------------------------------
--			Unit Entry and Movement Functions
---------------------------------------------------------------------------

function Nurfed_UnitOnClick(arg1, unit)
	if ( SpellIsTargeting() and arg1 == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( arg1 == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit(unit);
		elseif ( CursorHasItem() ) then
			if (unit == "player") then
				AutoEquipCursorItem();
			else
				DropItemOnUnit(unit);
			end
		else
			TargetUnit(unit);
		end
	else
		local dropdown = getglobal("Nurfed_"..unit.."DropDown");
		if (dropdown) then
			ToggleDropDownMenu(1, nil, dropdown, "Nurfed_"..unit, 106, 27);
		end
		return;
	end
end

function Nurfed_UnitFrame_OnEnter(unit)
	if ( SpellIsTargeting() ) then
		if ( SpellCanTargetUnit(unit) ) then
			SetCursor("CAST_CURSOR");
		else
			SetCursor("CAST_ERROR_CURSOR");
		end
	end

	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if ( GameTooltip:SetUnit(unit) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end

	this.r, this.g, this.b = GameTooltip_UnitColor(unit);
	GameTooltipTextLeft1:SetTextColor(this.r, this.g, this.b);
end

function Nurfed_UnitFrame_OnLeave()
	if ( SpellIsTargeting() ) then
		SetCursor("CAST_ERROR_CURSOR");
	end
	this.updateTooltip = nil;
	GameTooltip:FadeOut();
end

function Nurfed_UnitOnDragStart(frame)
	local unitframeslocked;
	if (NURFED_GENERAL == 1) then
		unitframeslocked = NURFED_LOCKALL;
	else
		unitframeslocked = Nurfed_UnitFrames[Nurfed_UnitPlayer].unitsLocked;
	end
	local name = frame:GetName();
	if ( (name == "Nurfed_party1" or name == "Nurfed_party2" or name == "Nurfed_party3" or name == "Nurfed_party4") and (Nurfed_UnitFrames[Nurfed_UnitPlayer].partySeperate == 0) ) then
		return;
	end

	if (unitframeslocked ~= 1) then
		CloseDropDownMenus();
		frame.BeingDragged = 1;
		frame:StartMoving();
	end
end

function Nurfed_UnitOnDragStop(frame)
	frame:StopMovingOrSizing();
	frame.BeingDragged = nil;
end
