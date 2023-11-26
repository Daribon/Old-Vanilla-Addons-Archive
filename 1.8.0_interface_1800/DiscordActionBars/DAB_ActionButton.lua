ATTACK_BUTTON_FLASH_TIME = 0.4;

IN_ATTACK_MODE = nil;
IN_AUTOREPEAT_MODE = nil;

function DAB_ActionButton_OnClick(id, mousebutton)
	local bar = DAB_Settings[DAB_INDEX].Button[id];

	local rightclick, middleclick, target, hideonclick, autoattack, forcetarget;

	if (bar == "floater") then
		target = DAB_Settings[DAB_INDEX].Floaters[id].target;
		hideonclick = DAB_Settings[DAB_INDEX].Floaters[id].hideonclick;
		rightclick = DAB_Settings[DAB_INDEX].Floaters[id].rightclick;
		middleclick = DAB_Settings[DAB_INDEX].Floaters[id].middleclick;
		autoattack = DAB_Settings[DAB_INDEX].Floaters[id].AutoAttack;
		forcetarget = DAB_Settings[DAB_INDEX].Floaters[id].ForceTarget;
	else
		rightclick = DAB_Get_MatchingButton(bar, id, DAB_Settings[DAB_INDEX].Bar[bar].rightclick);
		middleclick = DAB_Get_MatchingButton(bar, id, DAB_Settings[DAB_INDEX].Bar[bar].middleclick);
		target = DAB_Settings[DAB_INDEX].Bar[bar].target;
		hideonclick = DAB_Settings[DAB_INDEX].Bar[bar].hideonclick;
		autoattack = DAB_Settings[DAB_INDEX].Bar[bar].AutoAttack;
		 forcetarget = DAB_Settings[DAB_INDEX].Bar[bar].ForceTarget;
	end

	if ( IsShiftKeyDown() ) then
		PickupAction(id);
		if (bar ~= "floater") then
			DAB_Bar_SetLayout(bar);			
		end
	else
		if (not IsAttackAction(id)) then
			if (autoattack) then
				DAB_AttackTarget();
			end
		end
		if ( MacroFrame_SaveMacro ) then
			MacroFrame_SaveMacro();
		end
		local action = id;
		if (mousebutton == "RightButton" and rightclick) then
			action = rightclick;
		elseif (mousebutton == "MiddleButton" and middleclick) then
			action = middleclick;
		end

		if (target and forcetarget) then
			TargetUnit(target);
		end

		UseAction(action, 1);

		if (target and forcetarget) then
			TargetLastTarget();
		elseif (SpellIsTargeting() and target) then
			SpellTargetUnit(target);
		end

		if (hideonclick) then
			if (bar == "floater") then
				DAB_Floater_Hide(id);
			else
				DAB_Bar_Hide(bar);
			end
		end
	end

	getglobal("DAB_ActionButton_"..id).clicked = true;
	DAB_ActionButton_UpdateState();
end

function DAB_ActionButton_OnDragStart()
	local bar = DAB_Settings[DAB_INDEX].Button[this:GetID()];
	if (DAB_DRAGGING_UNLOCKED or IsControlKeyDown()) then
		this.moving = true;
		if (bar == "floater") then
			this:StartMoving();
			this.bar = this:GetName();
		else
			this.bar = "DAB_ActionBar_"..bar;
			getglobal(this.bar):StartMoving();
		end
	elseif (DAB_Settings[DAB_INDEX].ButtonsUnlocked) then
		PickupAction(this:GetID());
		DAB_ActionButton_UpdateState();
		if (bar ~= "floater") then
			DAB_Bar_SetLayout(bar);	
		end
	end
end

function DAB_ActionButton_OnDragStop()
	if (this.moving) then
		this.moving = nil;
		DAB_Update_FrameLocation(this.bar);
		this.bar = nil;
	end
end

function DAB_ActionButton_OnEnter()
	if (DAB_Settings[DAB_INDEX].Button[this:GetID()] and DAB_Settings[DAB_INDEX].Button[this:GetID()] ~= "floater") then
		getglobal("DAB_ActionBar_"..DAB_Settings[DAB_INDEX].Button[this:GetID()]).timer = nil;
	end
	if (DAB_Settings[DAB_INDEX].DisableTooltips) then return; end
	if ( GetCVar("UberTooltips") == "1" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
	else
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	end
	
	if ( GameTooltip:SetAction(this:GetID()) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function DAB_ActionButton_OnEvent(event)
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == this:GetID() ) then
			DAB_ActionButton_Update();
		end
	elseif ( event == "PLAYER_TARGET_CHANGED") then
		if (DAB_Settings[DAB_INDEX].Floaters[this:GetID()]) then
			if (DAB_IsInContext(DAB_Settings[DAB_INDEX].Floaters[this:GetID()].friendlytarget, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].hostiletarget, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].combat, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].notincombat, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].form,
			DAB_Settings[DAB_INDEX].Floaters[this:GetID()].onetrue)) then
				DAB_Floater_Show(this:GetID());
			else
				DAB_Floater_Hide(this:GetID());
			end
		end
		return;
	elseif ( event == "PLAYER_AURAS_CHANGED" ) then
		DAB_ActionButton_Update();
		DAB_ActionButton_UpdateState();
		return;
	elseif ( event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" ) then
		if (DAB_Settings[DAB_INDEX].Floaters[this:GetID()]) then
			if (DAB_Settings[DAB_INDEX].Floaters[this:GetID()].incombat or DAB_Settings[DAB_INDEX].Floaters[this:GetID()].notincombat) then
				if (DAB_IsInContext(DAB_Settings[DAB_INDEX].Floaters[this:GetID()].friendlytarget, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].hostiletarget, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].incombat, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].notincombat, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].form,
				DAB_Settings[DAB_INDEX].Floaters[this:GetID()].onetrue)) then
					DAB_Floater_Show(this:GetID());
				else
					DAB_Floater_Hide(this:GetID());
				end
			end
		end
	elseif ( event == "UPDATE_BONUS_ACTIONBAR" ) then
		DAB_ActionButton_Update();
		DAB_ActionButton_UpdateState();
		if (DAB_Settings[DAB_INDEX].Floaters[this:GetID()]) then
			if (DAB_Settings[DAB_INDEX].Floaters[this:GetID()].form) then
				if (DAB_IsInContext(DAB_Settings[DAB_INDEX].Floaters[this:GetID()].friendlytarget, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].hostiletarget, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].incombat, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].notincombat, DAB_Settings[DAB_INDEX].Floaters[this:GetID()].form,				DAB_Settings[DAB_INDEX].Floaters[this:GetID()].onetrue)) then
					DAB_Floater_Show(this:GetID());
				else
					DAB_Floater_Hide(this:GetID());
				end
			end
		end
		return;
	end

	if ( not this:IsVisible() ) then return; end

	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			DAB_ActionButton_Update();
		end
	elseif ( event == "ACTIONBAR_UPDATE_STATE" ) then
		DAB_ActionButton_UpdateState();
	elseif ( event == "ACTIONBAR_UPDATE_USABLE" or event == "UPDATE_INVENTORY_ALERTS" or event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		DAB_ActionButton_UpdateCooldown();
	elseif ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		DAB_ActionButton_UpdateState();
	elseif ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(this:GetID()) ) then
			DAB_ActionButton_StartFlash();
		end
	elseif ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = nil;
		if ( IsAttackAction(this:GetID()) ) then
			DAB_ActionButton_StopFlash();
		end
	elseif ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(this:GetID()) ) then
			DAB_ActionButton_StartFlash();
		end
	elseif ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( this.flashing == 1 and (not IsAttackAction(this:GetID())) ) then
			DAB_ActionButton_StopFlash();
		end
	end
end

function DAB_ActionButton_OnLeave()
	this.updateTooltip = nil;
	GameTooltip:Hide();
end

function DAB_ActionButton_OnLoad()
	this.flashing = 0;
	this.flashtime = 0;
	DAB_ActionButton_Update();
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	this:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	this:RegisterEvent("ACTIONBAR_UPDATE_STATE");
	this:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
	this:RegisterEvent("CRAFT_CLOSE");
	this:RegisterEvent("CRAFT_SHOW");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("START_AUTOREPEAT_SPELL");
	this:RegisterEvent("STOP_AUTOREPEAT_SPELL");
	this:RegisterEvent("TRADE_SKILL_CLOSE");
	this:RegisterEvent("TRADE_SKILL_SHOW");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("UPDATE_BINDINGS");
	this:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
end

function DAB_ActionButton_OnReceiveDrag()
	PlaceAction(this:GetID());
	DAB_ActionButton_UpdateState();
end

function DAB_ActionButton_OnShow()
	if (not DAB_INITIALIZED) then return; end
	if ( IsAttackAction(this:GetID()) and IsCurrentAction(this:GetID()) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(this:GetID());
	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		DAB_ActionButton_StartFlash();
	else
		DAB_ActionButton_StopFlash();
	end
	DAB_ActionButton_UpdateCooldown();
	DAB_ActionButton_UpdateState();
	this.timetohide = nil;
end

function DAB_ActionButton_OnUpdate(elapsed)
	if (not DAB_INITIALIZED) then return; end
	local id = this:GetID();
	if (not HasAction(id)) then return; end
	if ( this.flashing == 1 ) then
		this.flashtime = this.flashtime - elapsed;
		if ( this.flashtime <= 0 ) then
			local overtime = -this.flashtime;
			if ( overtime >= ATTACK_BUTTON_FLASH_TIME ) then
				overtime = 0;
			end
			this.flashtime = ATTACK_BUTTON_FLASH_TIME - overtime;

			local flashTexture = getglobal(this:GetName().."Flash");
			if ( flashTexture:IsVisible() ) then
				flashTexture:Hide();
			else
				flashTexture:Show();
			end
		end
	end

	if (this.timetohide) then
		this.timetohide = this.timetohide - elapsed;
		if (this.timetohide < 0) then
			this.timetohide = nil;
			DAB_Floater_Hide(id);
		end
	end

	local cdscale = getglobal(this:GetName().."Cooldown").scale;
	if (cdscale) then
		if (getglobal(this:GetName().."Cooldown"):GetScale() ~= cdscale) then
			getglobal(this:GetName().."Cooldown"):SetScale(cdscale);
		end
	end

	if (this.scale and this:GetScale() ~= this.scale) then
		getglobal(this:GetName().."TextFrame"):SetScale(this.scale);
	end

	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			local isUsable, notEnoughMana = IsUsableAction(id);
			local r, g, b;
			if ( IsActionInRange(id) == 0 ) then
				r = DAB_Settings[DAB_INDEX].OutOfRangeColor.r;
				g = DAB_Settings[DAB_INDEX].OutOfRangeColor.g;
				b = DAB_Settings[DAB_INDEX].OutOfRangeColor.b;
			elseif ((not UnitIsVisible("target")) and UnitExists("target")) then
				r = DAB_Settings[DAB_INDEX].OutOfRangeColor.r;
				g = DAB_Settings[DAB_INDEX].OutOfRangeColor.g;
				b = DAB_Settings[DAB_INDEX].OutOfRangeColor.b;
			elseif ( isUsable ) then
				if (DAB_Settings[DAB_INDEX].RecolorBorder) then
					if (DAB_Settings[DAB_INDEX].Button[id] == "floater") then
						r = DAB_Settings[DAB_INDEX].Floaters[id].bordercolor.r;
						g = DAB_Settings[DAB_INDEX].Floaters[id].bordercolor.g;
						b = DAB_Settings[DAB_INDEX].Floaters[id].bordercolor.b;
					else
						local bar = DAB_Settings[DAB_INDEX].Button[id];
						if (bar) then
							r = DAB_Settings[DAB_INDEX].Bar[bar].buttonbordercolor.r;
							g = DAB_Settings[DAB_INDEX].Bar[bar].buttonbordercolor.g;
							b = DAB_Settings[DAB_INDEX].Bar[bar].buttonbordercolor.b;
						else
							r, g, b = 1, 1, 1;
						end
					end
				else
					r, g, b = 1, 1, 1;
				end
			elseif ( notEnoughMana ) then
				r = DAB_Settings[DAB_INDEX].OutOfManaColor.r;
				g = DAB_Settings[DAB_INDEX].OutOfManaColor.g;
				b = DAB_Settings[DAB_INDEX].OutOfManaColor.b;
			else
				r = DAB_Settings[DAB_INDEX].UnusableColor.r;
				g = DAB_Settings[DAB_INDEX].UnusableColor.g;
				b = DAB_Settings[DAB_INDEX].UnusableColor.b;
			end
			if (DAB_Settings[DAB_INDEX].RecolorBorder) then
				getglobal(this:GetName().."Border"):SetVertexColor(r, g, b);
			else
				getglobal(this:GetName().."Icon"):SetVertexColor(r, g, b);
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
			if (this.clicked and (not this.keydown)) then
				if ( (not IsCurrentAction(id)) and (not IsAutoRepeatAction(id)) ) then
					this:SetChecked(0);
					this.clicked = nil;
				end
			end
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	end

	if (this.cooldowncount) then
		this.cooldowncount = this.cooldowncount - elapsed;
		if (this.cooldowncount <= 0) then
			this.cooldowncount = nil;
			this.clicked = nil;
			if (not DAB_SHOWING_IDS) then
				getglobal(this:GetName().."TextFrameCooldownCount"):SetText("");
			end
		elseif (not DAB_SHOWING_IDS) then
			local count = math.ceil(this.cooldowncount);
			if (count < 60) then
				if (DAB_Settings[DAB_INDEX].DoNotShowS) then
					getglobal(this:GetName().."TextFrameCooldownCount"):SetText(count);
				else
					getglobal(this:GetName().."TextFrameCooldownCount"):SetText(count.."s");
				end
			else
				count = math.ceil(count / 60);
				getglobal(this:GetName().."TextFrameCooldownCount"):SetText(count.."m");
			end
		end
	end

	if ( not this.updateTooltip ) then return; end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then return; end

	if ( GameTooltip:IsOwned(this) ) then
		DAB_ActionButton_OnEnter();
	else
		this.updateTooltip = nil;
	end
end

function DAB_ActionButton_StartFlash()
	this.flashing = 1;
	this.flashtime = 0;
	DAB_ActionButton_UpdateState();
end

function DAB_ActionButton_StopFlash()
	this.flashing = 0;
	getglobal(this:GetName().."Flash"):Hide();
	DAB_ActionButton_UpdateState();
end

function DAB_ActionButton_Update()
	local pagedID = this:GetID();
	local icon = getglobal(this:GetName().."Icon");
	local texture = GetActionTexture(pagedID);

	DAB_ActionButton_UpdateCount();
	if ( HasAction(pagedID) ) then
		if (texture == "" or (not texture)) then
			icon:SetTexture("Interface\\AddOns\\DiscordActionBars\\EmptyButton");			
		else
			icon:SetTexture(texture);
		end
		this.rangeTimer = TOOLTIP_UPDATE_TIME;
		DAB_ActionButton_UpdateCooldown();
	else
		icon:SetTexture("Interface\\AddOns\\DiscordActionBars\\EmptyButton");
	end

	if ( IsAttackAction(pagedID) and IsCurrentAction(pagedID) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(pagedID);
	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		DAB_ActionButton_StartFlash();
	else
		DAB_ActionButton_StopFlash();
	end

	if ( GameTooltip:IsOwned(this) ) then
		DAB_ActionButton_OnEnter();
	else
		this.updateTooltip = nil;
	end

	getglobal(this:GetName().."TextFrameName"):SetText(GetActionText(pagedID));
end

function DAB_ActionButton_UpdateCooldown()
	if (not DAB_INITIALIZED) then return; end
	if (not HasAction(this:GetID())) then return; end
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(this:GetID());
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
	if (not DAB_SHOWING_IDS) then
		getglobal(this:GetName().."TextFrameCooldownCount"):SetText("");
	end
	if (DAB_Settings[DAB_INDEX].OnlyClickedButtons and (not this.clicked)) then
		return;
	end
	if (DAB_Settings[DAB_INDEX].ShowCooldownCount) then
		if (start and start > 0) then
			if (this.cooldowncount) then
				this.cooldowncount = duration - (GetTime() - start);
			elseif (duration > DAB_Settings[DAB_INDEX].MinCooldownCount) then
				this.cooldowncount = duration;
			end
		else
			this.cooldowncount = 0;
		end
	end
end

function DAB_ActionButton_UpdateCount()
	local text = getglobal(this:GetName().."TextFrameCount");
	local count = GetActionCount(this:GetID());
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function DAB_ActionButton_UpdateState()
	if (this.keydown) then return; end
	if ( IsCurrentAction(this:GetID()) or IsAutoRepeatAction(this:GetID()) ) then
		this:SetChecked(1);
	else
		this:SetChecked(0);
		this.clicked = nil;
	end
end