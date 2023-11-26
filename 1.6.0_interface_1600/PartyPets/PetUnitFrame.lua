function PetUnitFrame_Initialize(unit, name, portrait, healthbar, healthtext, manabar, manatext)
	this.unit = unit;
	this.name = name;
	this.portrait = portrait;
	this.portraitNeedsUpdate = true;
	this.healthbar = healthbar;
	this.manabar = manabar;
	PetUnitFrameHealthBar_Initialize(unit, healthbar, healthtext);
--	PetUnitFrameManaBar_Initialize(unit, manabar, manatext);
	PetUnitFrame_Update();
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function PetUnitFrame_Update()
	this.name:SetText(PetUnitName(this.unit));
	PetSetPortraitTexture(this.portrait, this.unit);
	PetUnitFrameHealthBar_Update(this.healthbar, this.unit);
--	PetUnitFrameManaBar_Update(this.manabar, this.unit);
end

function PetUnitFrame_OnEvent(event)
end

function PetUnitFrame_OnEnter()
	if ( SpellIsTargeting() ) then
		if ( PetSpellCanTargetUnit(this.unit) ) then
			SetCursor("CAST_CURSOR");
		else
			SetCursor("CAST_ERROR_CURSOR");
		end
	end

	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	-- If showing newbie tips then only show the explanation
	
	GameTooltip:SetText(PetUnitName(this.unit));
	GameTooltip:AddLine("|cffffffff"..PetUnitOwner(this.unit).."'s Pet".."|r");
	GameTooltip:AddLine("|cffffffff".."Level "..PetUnitLevel(this.unit).."|r");
	GameTooltip:Show();

	this.updateTooltip = TOOLTIP_UPDATE_TIME;

	this.r, this.g, this.b = GameTooltip_UnitColor(this.unit);
	GameTooltipTextLeft1:SetTextColor(this.r, this.g, this.b);
end

function PetUnitFrame_OnLeave()
	if ( SpellIsTargeting() ) then
		SetCursor("CAST_ERROR_CURSOR");
	end
	this.updateTooltip = nil;
	GameTooltip:Hide();
end

function PetUnitFrame_OnUpdate(elapsed)
	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(this) ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
		if ( GameTooltip:SetUnit(this.unit) ) then
			this.updateTooltip = TOOLTIP_UPDATE_TIME;
		else
			this.updateTooltip = nil;
		end
		--GameTooltip:SetBackdropColor(this.r, this.g, this.b);
		GameTooltipTextLeft1:SetTextColor(this.r, this.g, this.b);
	else
		this.updateTooltip = nil;
	end
end

-- port me
function PetUnitFrame_UpdateManaType()
	local info = ManaBarColor[PetUnitPowerType(this.unit)];
	this.manabar:SetStatusBarColor(info.r, info.g, info.b);
	--Hack for pets
	if ( this.unit == "pet" and info.prefix ~= HAPPINESS_POINTS ) then
		return;
	end
	-- Update the manabar text if shown in the ui options
	SetTextStatusBarTextPrefix(this.manabar, info.prefix);
	if ( UIOptionsFrameCheckButtons["STATUS_BAR_TEXT"].value == "1" ) then
		TextStatusBar_UpdateTextString(this.manabar);
	end

	this.manabar.tooltipTitle = nil;
	this.manabar.tooltipText = nil;
end

function PetUnitFrameHealthBar_Initialize(unit, statusbar, statustext)
	statusbar.unit = unit;
	SetTextStatusBarText(statusbar, statustext);

	statusbar.tooltipTitle = nil;
	statusbar.tooltipText = nil;	
end

function PetUnitFrameHealthBar_Update(statusbar, unit)
	local cvar = arg1;
	local value = arg2;
	if ( unit == statusbar.unit ) then
		local currValue = PetHealth(unit);
		local maxValue = PetHealthMax(unit);
		statusbar:SetMinMaxValues(0, maxValue);
		statusbar:SetValue(currValue);
	end
	TextStatusBar_OnEvent(cvar, value);
end

function PetUnitFrameHealthBar_OnValueChanged(value)
	TextStatusBar_OnValueChanged();
	HealthBar_OnValueChanged(value);
end

function PetUnitFrameManaBar_Initialize(unit, statusbar, statustext)
	statusbar.unit = unit;
	SetTextStatusBarText(statusbar, statustext);
end

function PetUnitFrameManaBar_Update(statusbar, unit)
	local cvar = arg1;
	local value = arg2;
	if ( unit == statusbar.unit ) then
		local currValue = UnitMana(unit);
		local maxValue = UnitManaMax(unit);
		statusbar:SetMinMaxValues(0, maxValue);
		statusbar:SetValue(currValue);
	end
	TextStatusBar_OnEvent(cvar, value);
end
