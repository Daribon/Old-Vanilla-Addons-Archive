
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
	elseif (string.find(unit, "party[1-4]")) then
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

--Set tooltip for auras
function Nurfed_SetAuraTooltip()
	if (not this:IsVisible()) then return; end
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
	local unit = this.unit;
	if (this.isdebuff == 1) then
		if (unit == "party") then
			GameTooltip:SetUnitDebuff("party"..this:GetParent():GetID(), this:GetID());
		else
			GameTooltip:SetUnitDebuff(unit, this:GetID());
		end
	else
		
		if (unit == "party") then
			GameTooltip:SetUnitBuff("party"..this:GetParent():GetID(), this:GetID());
		else
			GameTooltip:SetUnitBuff(unit, this:GetID());
		end
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
		unitframeslocked = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitsLocked;
	end
	local name = frame:GetName();
	if ( (string.find(name, "Nurfed_party[1-4]")) and (Nurfed_UnitConfig[Nurfed_UnitPlayer].partySeperate == 0) ) then
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
