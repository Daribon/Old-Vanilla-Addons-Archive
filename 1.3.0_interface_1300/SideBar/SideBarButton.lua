-- A few globals
--
SIDEBAR_DEBUG=1;
Left_Sidebar_On = 0;
Right_Sidebar_On = 0;
SideBar_HideKeys = 0;
SideBar_HideKeyMod = 0;
SideBar_LeftOffset = 0;
SideBar_RightOffset = 0;

SideBar_HideEmpty = 0;
SideBar_LeftMovePartyMemberFrames = 0;
SideBar_RightMoveBagFrames = 0;

function SideBarButtonDown(id)
	local button = getglobal("SideBarButton"..id);
	DebugPrint(button, "SIDEBAR_DEBUG");
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function SideBarButtonUp(id)
	local button = getglobal("SideBarButton"..id);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		-- Used to save a macro
		MacroFrame_EditMacro();
		UseAction(SideBarButton_GetID(button), 0);
		if ( IsCurrentAction(SideBarButton_GetID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

function SideBar2ButtonDown(id)
	local button = getglobal("SideBar2Button"..id);
	DebugPrint(button, "SIDEBAR_DEBUG");
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function SideBar2ButtonUp(id)
	local button = getglobal("SideBar2Button"..id);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		-- Used to save a macro
		MacroFrame_EditMacro();
		UseAction(SideBarButton_GetID(button), 0);
		if ( IsCurrentAction(SideBarButton_GetID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

function SideBar_UpdateOffset()
	SideBar2:SetPoint("LEFT", "UIParent", "LEFT", 0, SideBar_LeftOffset);
	SideBar:SetPoint("RIGHT", "UIParent", "RIGHT", 0, SideBar_RightOffset);
end

function SideBar_LeftSliderUpdate(toogle, speed)
	SideBar_LeftOffset = speed;
	SideBar_UpdateOffset();
end

function SideBar_RightSliderUpdate(toogle, speed)
	SideBar_RightOffset = speed;
	SideBar_UpdateOffset();
end

function SideBar_OnLoad()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration("COS_SIDEBAR", "SECTION", SIDEBAR_SEP, SIDEBAR_SEP_INFO );
		Cosmos_RegisterConfiguration("COS_SIDEBARHEADER", "SEPARATOR", SIDEBAR_SEP, SIDEBAR_SEP_INFO );
		Cosmos_RegisterConfiguration("COS_SIDEBARL", "CHECKBOX",
			SIDEBAR_CHECK1, 
			SIDEBAR_CHECK1_INFO,
			SideBar2_Toggle,
			Left_Sidebar_On
			);
		Cosmos_RegisterConfiguration("COS_SIDEBARR", "CHECKBOX", 
			SIDEBAR_CHECK2, 
			SIDEBAR_CHECK2_INFO,
			SideBar_Toggle,
			Right_Sidebar_On
			);
		Cosmos_RegisterConfiguration("COS_SIDEBAR_HIDEKEYS", "CHECKBOX",
			SIDEBAR_HIDEKEYS,
			SIDEBAR_HIDEKEYS_INFO,
			SideBar_SetHideKeys,
			SideBar_HideKeys
			);
		Cosmos_RegisterConfiguration("COS_SIDEBAR_HIDEKEYMOD", "CHECKBOX",
			SIDEBAR_HIDEKEYMOD,
			SIDEBAR_HIDEKEYMOD_INFO,
			SideBar_SetHideKeyMod,
			SideBar_HideKeyMod
			);
		Cosmos_RegisterConfiguration("COS_SIDEBAR_HIDEEMPTY", "CHECKBOX",
			SIDEBAR_CONFIG_HIDE_EMPTY,
			SIDEBAR_CONFIG_HIDE_EMPTY_INFO,
			SideBar_SetHideEmpty,
			SideBar_HideEmpty
			);
		Cosmos_RegisterConfiguration("COS_SIDEBAR_LEFTMOVEPARTYFRAME", "CHECKBOX",
			SIDEBAR_CONFIG_LEFT_PARTY,
			SIDEBAR_CONFIG_LEFT_PARTY_INFO,
			SideBar_SetLeftMovePartyMemberFrames,
			SideBar_LeftMovePartyMemberFrames
			);
		Cosmos_RegisterConfiguration("COS_SIDEBAR_RIGHTMOVEBAGFRAME", "CHECKBOX",
			SIDEBAR_CONFIG_RIGHT_BAG,
			SIDEBAR_CONFIG_RIGHT_BAG_INFO,
			SideBar_SetRightMoveBagFrames,
			SideBar_RightMoveBagFrames
			);
		Cosmos_RegisterConfiguration(
			"COS_SIDEBAR_LEFTSLIDER", -- CVAr
			"SLIDER",
			SIDEBAR_CONFIG_SLIDER_LEFT,
			"",
			SideBar_LeftSliderUpdate,
			0,
			0,				--Default Value
			-500,			--Min value
			500,			--Max value
			SIDEBAR_CONFIG_SLIDER_OFFSET,		--Slider Text
			1,				--Slider Increment
			1,				--Slider state text on/off
			"",				--Slider state text append
			1				--Slider state text multiplier
			);
		Cosmos_RegisterConfiguration(
			"COS_SIDEBAR_RIGHTSLIDER", -- CVAr
			"SLIDER",
			SIDEBAR_CONFIG_SLIDER_RIGHT,
			"",
			SideBar_RightSliderUpdate,
			0,
			0,				--Default Value
			-500,			--Min value
			500,			--Max value
			SIDEBAR_CONFIG_SLIDER_OFFSET,		--Slider Text
			1,				--Slider Increment
			1,				--Slider state text on/off
			"",				--Slider state text append
			1				--Slider state text multiplier
			);
	end
end
function SideBarButton_OnLoad()
	this.showgrid = 1;
	this.flashing = 0;
	this.flashtime = 0;
	SideBarButton_Update();
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("ACTIONBAR_SHOWGRID");
	this:RegisterEvent("ACTIONBAR_HIDEGRID");
	this:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	this:RegisterEvent("ACTIONBAR_UPDATE_STATE");
	this:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
	this:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("UNIT_AURASTATE");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("CRAFT_SHOW");
	this:RegisterEvent("CRAFT_CLOSE");
	this:RegisterEvent("TRADE_SKILL_SHOW");
	this:RegisterEvent("TRADE_SKILL_CLOSE");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("UNIT_COMBO_POINTS");
	this:RegisterEvent("UPDATE_BINDINGS");
	this:RegisterEvent("START_AUTOREPEAT_SPELL");
	this:RegisterEvent("STOP_AUTOREPEAT_SPELL");
	
	SideBarButton_UpdateHotkeys();

end

function SideBarButton_UpdateHotkeys(actionButtonType, button)
	if (not button) then
		button = this;
	end
	if ( not actionButtonType ) then
		actionButtonType = string.upper(button:GetParent():GetName()).."ACTIONBUTTON";
	end
	local hotkey = getglobal(button:GetName().."HotKey");
	local curID = button:GetID();
	local checkedID = curID - 108;
	if ((checkedID < 1) or (checkedID > 6)) then
		checkedID = curID - 114;
	end
	if (SideBar_HideKeys==1) then
		hotkey:SetText("");
	else
		if ((checkedID >= 1) and (checkedID <= 6)) then
			local action = actionButtonType..checkedID;	
			local keyText = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
			if (SideBar_HideKeyMod==1) then
				while ( ( keyText ) and ( strlen(keyText) > 1 ) and (string.find(keyText, "-")) and (keyText ~= "KP -") and (keyText ~= "Num Pad -")) do
					firsti, lasti, keyText = string.find (keyText, "-(.+)");
				end
			end
			if ( ( not keyText ) or ( strlen(keyText) <= 0 ) ) then keyText = ""; end
			hotkey:SetText(keyText);
		end
	end
end

function SideBarButton_UpdateAllHotkeys()
	for i=1, 6 do
		local button = getglobal("SideBarButton"..i);
		if (button) then
			SideBarButton_UpdateHotkeys(nil, button)
		end
	end
	for i=1, 6 do
		local button = getglobal("SideBar2Button"..i);
		if (button) then
			SideBarButton_UpdateHotkeys(nil, button)
		end
	end
end

function SideBarButton_Update()
	local icon = getglobal(this:GetName().."Icon");
	local buttonCooldown = getglobal(this:GetName().."Cooldown");
	local texture = GetActionTexture(SideBarButton_GetID(this));
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		this.rangeTimer = TOOLTIP_UPDATE_TIME;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
		-- Save texture if the button is a bonus button, will be needed later
		--if ( this.isBonus ) then
		--	this.texture = texture;
		--end
	else
		icon:Hide();
		buttonCooldown:Hide();
		this.rangeTimer = nil;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
	end

	SideBarButton_UpdateCount();
	if ( HasAction(SideBarButton_GetID(this)) ) then
		this:Show();
		SideBarButton_UpdateUsable();
		SideBarButton_UpdateCooldown();
	elseif ( this.showgrid == 0 ) then
		this:Hide();
	else
		getglobal(this:GetName().."Cooldown"):Hide();
	end
	if ( IsAttackAction(SideBarButton_GetID(this)) and IN_ATTACK_MODE == 1 ) then
		SideBarButton_StartFlash();
	else
		SideBarButton_StopFlash();
	end
	if ( GameTooltip:IsOwned(this) ) then
		SideBarButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(this:GetName().."Name");
	macroName:SetText(GetActionText(SideBarButton_GetID(this)));
end

function SideBarButton_ShowGrid()
	this.showgrid = this.showgrid+1;
	getglobal(this:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0);
	this:Show();
end

function SideBarButton_HideGrid()	
	this.showgrid = this.showgrid-1;
	if ( this.showgrid == 0 and not HasAction(SideBarButton_GetID(this)) ) then
		this:Hide();
	end
end

function SideBarButton_UpdateState()
	if ( IsCurrentAction(SideBarButton_GetID(this)) ) then
		this:SetChecked(1);
	else
		this:SetChecked(0);
	end
end

function SideBarButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(SideBarButton_GetID(this));
	if ( isUsable ) then
		local inRange = true;
		if ( this.rangeTimer and (IsActionInRange(SideBarButton_GetID(this)) == 0)) then
			inRange = false;
		end
		if ( inRange ) then
			icon:SetVertexColor(1.0, 1.0, 1.0);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		else
			icon:SetVertexColor(1.0, 0.5, 0.5);
			normalTexture:SetVertexColor(1.0, 0.5, 0.5);
		end
	elseif ( notEnoughMana ) then
		icon:SetVertexColor(0.5, 0.5, 1.0);
		normalTexture:SetVertexColor(0.5, 0.5, 1.0);
	else
		icon:SetVertexColor(0.4, 0.4, 0.4);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
	end
end

function SideBarButton_UpdateCount()
	local text = getglobal(this:GetName().."Count");
	local count = GetActionCount(SideBarButton_GetID(this));
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function SideBarButton_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(SideBarButton_GetID(this));
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function SideBarButton_OnEvent(event)
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == SideBarButton_GetID(this) ) then
			SideBarButton_Update();
		end
		return;
	end
	if ( event == "PLAYER_AURAS_CHANGED") then
		SideBarButton_Update();
		SideBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		SideBarButton_ShowGrid();
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		SideBarButton_HideGrid();
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		SideBarButton_UpdateHotkeys();
	end

	-- All event handlers below this line MUST only be valid when the button is visible
	if ( not this:IsVisible() ) then
		return;
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		SideBarButton_UpdateUsable();
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		if ( arg1 == "player" or arg1 == "target" ) then
			SideBarButton_UpdateUsable();
		end
		return;
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			SideBarButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_STATE" ) then
		SideBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_USABLE" ) then
		SideBarButton_UpdateUsable();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		-- Do we really need to update usable state?  It adds 50% CPU usage in this event processing
		--ActionButton_UpdateUsable();
		SideBarButton_UpdateCooldown();
		return;
	end
	if ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		SideBarButton_UpdateState();
		return;
	end
	if ( arg1 == "player" and (event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY") ) then
		SideBarButton_UpdateUsable();
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StartFlash();
		end
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = 0;
		if ( IsAttackAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StopFlash();
		end
		return;
	end
	if ( (event == "UNIT_COMBO_POINTS") and (arg1 == "player") ) then
		SideBarButton_UpdateUsable();
		return;
	end
	if ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StartFlash();
		end
		return;
	end
	if ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( SideBarButton_IsFlashing() and not IsAttackAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StopFlash();
		end
		return;
	end
end

function SideBarButton_SetTooltip()
	if ((GetCVar("UberTooltips") == "1") and (not Cosmos_RelocateUberTooltip)) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
	else
		if (SmartSetOwner) then
			SmartSetOwner(this);
		else
			GameTooltip:SetOwner(this,"ANCHOR_TOPRIGHT");
		end
	end

	if ( GameTooltip:SetAction(SideBarButton_GetID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end
function SideBarButton_SetTooltipRight()
	if ((GetCVar("UberTooltips") == "1") and (not Cosmos_RelocateUberTooltip)) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
	else
		if (SmartSetOwner) then
			SmartSetOwner(this);
		else
			GameTooltip:SetOwner(this,"ANCHOR_TOPRIGHT");
		end
	end

	if ( CosmosTooltip:SetAction(SideBarButton_GetID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function SideBarButton_OnUpdate(elapsed)
	if ( this.flashing ~= 0 and this.flashing) then
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
	
	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			SideBarButton_UpdateUsable();
			local count = getglobal(this:GetName().."HotKey");
			if ( IsActionInRange( SideBarButton_GetID(this)) == 0 ) then
				if (count) then
					count:SetVertexColor(1.0, 0.1, 0.1);
				end
			else
				if (count) then
					count:SetVertexColor(0.6, 0.6, 0.6);
				end
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	else
		local count = getglobal(this:GetName().."HotKey");
		count:SetVertexColor(0.6, 0.6, 0.6);
	end


	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(this) ) then
		SideBarButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function SideBarButton_GetID(button)
	if( button == nil ) then
		message("nil button passed into SideBarButton_GetID(), contact Jeff");
		return 0;
	end
	return (button:GetID());
end

function SideBarButton_StartFlash()
	this.flashing = 1;
	this.flashtime = 0;
	SideBarButton_UpdateState();
end

function SideBarButton_StopFlash()
	this.flashing = 0;
	getglobal(this:GetName().."Flash"):Hide();
	SideBarButton_UpdateState();
end


function SideBarButton_IsFlashing()
	if ( this.flashing == 1 ) then
		return 1;
	else
		return nil;
	end
end

function SideBar_Toggle ( toggle ) if (toggle == 1) then SideBar:Show(); SideBarRight_Show(); else SideBar:Hide(); SideBarRight_Hide(); end end
function SideBar2_Toggle ( toggle ) if (toggle == 1) then SideBar2:Show(); SideBarLeft_Show(); else SideBar2:Hide(); SideBarLeft_Hide(); end end

function SideBar_SetHideKeys(checked)
	if (checked and (checked==1)) then
		if (SideBar_HideKeys ~= 1) then
			SideBar_HideKeys=1;
			SideBarButton_UpdateAllHotkeys();
		end
	else
		if (SideBar_HideKeys ~= 0) then
			SideBar_HideKeys=0;
			SideBarButton_UpdateAllHotkeys();
		end
	end
end

function SideBar_SetHideKeyMod(checked)
	if (checked and (checked==1)) then
		if (SideBar_HideKeyMod ~= 1) then
			SideBar_HideKeyMod=1;
			SideBarButton_UpdateAllHotkeys();
		end
	else
		if (SideBar_HideKeyMod ~= 0) then
			SideBar_HideKeyMod=0;
			SideBarButton_UpdateAllHotkeys();
		end
	end
end

function SideBarLeft_ShouldShiftBagFramesLeftOnShow()
	if ( SideBar_RightMoveBagFrames == 1 ) then
		return true;
	else
		return false;
	end
end

function SideBarLeft_ShouldShiftPartyPortraitsRightOnShow()
	if ( SideBar_LeftMovePartyMemberFrames == 1 ) then
		return true;
	else
		return false;
	end
end

function SideBar_SetLeftMovePartyMemberFrames(toggle)
	if ( SideBar_LeftMovePartyMemberFrames ~= toggle ) then
		SideBar_LeftMovePartyMemberFrames = toggle;
		if ( SideBarLeft_ShouldShiftPartyPortraitsRightOnShow() ) then
			SideBarLeft_UpdatePartyFrames();
		else
			SideBarLeft_ResetPartyFrames();
		end
	end
end

function SideBarLeft_ResetPartyFrames()
	PartyMemberFrame1:ClearAllPoints();
	PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 10, -128);
end

function SideBarLeft_UpdatePartyFrames()
	local newXPos = 10;
	if ( SideBar2:IsVisible() ) then
		local centerX = SideBar2Button6:GetCenter();
		local width = SideBar2Button6:GetWidth();
		local scale = SideBar2Button6:GetScale();
		if ( ( not centerX ) or ( not width ) or ( not scale ) ) then
			return;
		else
			newXPos = newXPos + centerX + ( width * scale / 2 );
		end
	end
	PartyMemberFrame1:ClearAllPoints();
	PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", newXPos, -128);
end


function SideBarLeft_Show()
	if ( SideBarLeft_ShouldShiftPartyPortraitsRightOnShow() ) then
		SideBarLeft_UpdatePartyFrames();
	end
end

function SideBarLeft_Hide()
	if ( SideBarLeft_ShouldShiftPartyPortraitsRightOnShow() ) then
		SideBarLeft_UpdatePartyFrames();
	end
end

SideBar_Saved_updateContainerFrameAnchors = updateContainerFrameAnchors;
function SideBar_updateContainerFrameAnchors()
	SideBar_Saved_updateContainerFrameAnchors();
	SideBarLeft_UpdateBagFrames();
end
updateContainerFrameAnchors = SideBar_updateContainerFrameAnchors;

function SideBarLeft_GetSafeOffset()
	local b = getglobal("SideBarButton6");
	return ( 0 - ( b:GetWidth() * b:GetScale() ) - 10 );
end

function SideBarLeft_UpdateBagFrames()
	return;
end

function SideBarLeft_UpdateBagFramesOld()
	local uiScale = GetCVar("uiscale") + 0;
--	local screenHeight = GetScreenHeight();
	local screenHeight = 768;
	if ( GetCVar("useUiScale") == "1" ) then
		screenHeight = 768 / uiScale;
	end
	if ( not CONTAINER_OFFSET ) then
		CONTAINER_OFFSET = 0;
	end
	local freeScreenHeight = screenHeight - CONTAINER_OFFSET;
	local index = 1;
	local column = 0;
	local previousColumnFrame = nil;
	while ContainerFrame1.bags[index] do
		local frame = getglobal(ContainerFrame1.bags[index]);
		if ( frame ) then
			-- freeScreenHeight determines when to start a new column of bags
			if ( index == 1 ) then
				-- First bag
				local newXPos = 0;
				if ( SideBarLeft_ShouldShiftBagFramesLeftOnShow() ) then
					newXPos = SideBarLeft_GetSafeOffset();
				end
				frame:ClearAllPoints();
				frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", newXPos, CONTAINER_OFFSET);
				previousColumnFrame = frame;
			elseif ( freeScreenHeight < frame:GetHeight() ) then
				freeScreenHeight = UIParent:GetHeight() - CONTAINER_OFFSET;
				-- anchor to the previous column frame
				frame:SetPoint("BOTTOMRIGHT", previousColumnFrame:GetName(), "BOTTOMLEFT", 0, 0);
				previousColumnFrame = frame;
			else
				-- Anchor to the previous bag
				frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);	
			end
			freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		end
		index = index + 1;
	end
end

function SideBar_SetRightMoveBagFrames(toggle)
	if ( SideBar_RightMoveBagFrames ~= toggle ) then
		SideBar_RightMoveBagFrames = toggle;
		SideBarLeft_UpdateBagFrames();
	end
end

function SideBarRight_Show()
	if ( SideBarLeft_ShouldShiftBagFramesLeftOnShow() ) then
		SideBarLeft_UpdateBagFrames();
	end
end

function SideBarRight_Hide()
	if ( SideBarLeft_ShouldShiftBagFramesLeftOnShow() ) then
		SideBarLeft_UpdateBagFrames();
	end
end

function SideBar_SetHideEmpty(checked)
	if (checked and (checked == 1)) then
		if (SideBar_HideEmpty ~= 1) then
			SideBar_HideEmpty = 1;
			SideBarButton_UpdateHidingEmptySlots();
		end
	else
		if (SideBar_HideEmpty ~= 0) then
			SideBar_HideEmpty = 0;
			SideBarButton_UpdateHidingEmptySlots();
		end
	end
end

function SideBarButton_UpdateHidingEmptySlots()
	local i = 0;
	local j = 0;
	local bar = "";
	local name = "SideBar%sButton%d";
	local button = nil;
	for j = 1, 2 do
		for i = 1, 6 do
			button = getglobal(format(name, bar, i));
			if (button) then
				if (SideBar_HideEmpty == 0) then
					button.showgrid = 1;
				else
					button.showgrid = 0;
				end
				
				if (( not (HasAction(button:GetID()))) and (SideBar_HideEmpty ~= 0)) then
					button:Hide();
				else
					button:Show();
				end
			end
		end
		bar = "2";
	end
end
