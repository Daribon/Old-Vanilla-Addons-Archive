SecondBar_INITIALIZED=0;
SecondBar_HideEmpty=0;
SecondBar_HideKeys=0;
SecondBar_HideKeyMod=0;
SecondBar_Enabled=1;
SecondBar_HideArt=0;
OldActionButton_GetPagedID = nil;
SHAPESHIFTBAR_YPOS = 0;
SHAPESHIFTBAR_XPOS = 30;

function SecondActionButtonDown(id)
	local button = getglobal("SecondActionButton"..id);
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function SecondActionButtonUp(id, onSelf)

	local button = getglobal("SecondActionButton"..id);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		-- Used to save a macro
		MacroFrame_EditMacro();
		UseAction(SecondActionButton_GetPagedID(button), 0, onSelf);
		if ( IsCurrentAction(SecondActionButton_GetPagedID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

function SecondActionButton_OnLoad()
	-- todo: remove this when cosmos variable loading is working
	SecondBar_Toggle(1);
	SecondBar_PagesToggle(1);
	
	this.showgrid = 0;
	this.flashing = 0;
	this.flashtime = 0;
	SecondActionButton_Update();
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
	this:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("UPDATE_BINDINGS");
	this:RegisterEvent("START_AUTOREPEAT_SPELL");
	this:RegisterEvent("STOP_AUTOREPEAT_SPELL");
	
	this:RegisterEvent("VARIABLES_LOADED");	
	SecondActionButton_UpdateHotkeys();
end

function SecondActionButton_UpdateHotkeys(actionButtonType, button)
	if (not button) then
		button = this;
	end
	if ( not actionButtonType ) then
		actionButtonType = "SECONDACTIONBUTTON";
	end
	local hotkey = getglobal(button:GetName().."HotKey");
	local action = actionButtonType..button:GetID();
	if (SecondBar_HideKeys==1) then
		hotkey:SetText("");
	else
		local keyText = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
		if (SecondBar_HideKeyMod==1) then
			while ( ( keyText ) and ( strlen(keyText) > 1 ) and (string.find(keyText, "-")) and (keyText ~= "KP -") and (keyText ~= "Num Pad -")) do
				firsti, lasti, keyText = string.find (keyText, "-(.+)");
			end
		end
		if ( ( not keyText ) or ( strlen(keyText) <= 0 ) ) then keyText = ""; end
		hotkey:SetText(keyText);
	end
end

function SecondActionButton_UpdateAllHotkeys()
	if (SecondBar_INITIALIZED == 1) then
		for i=1, 12 do
			local button = getglobal("SecondActionButton"..i);
			if (button) then
				SecondActionButton_UpdateHotkeys("SECONDACTIONBUTTON", button)
			end
		end
	end
end

function SecondActionButton_Update()
	-- Determine whether or not the button should be flashing or not since the button may have missed the enter combat event
	local pagedID = SecondActionButton_GetPagedID(this);
	if ( IsAttackAction(pagedID) and IsCurrentAction(pagedID) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(pagedID);
	
	-- Special case code for bonus bar buttons
	-- Prevents the button from updating if the bonusbar is still in an animation transition

	-- Derek, I had to comment this out because it was causing them all to be grayed out after a cinematic...
	if ( this.isBonus and this.inTransition ) then
		SecondActionButton_UpdateUsable();
		SecondActionButton_UpdateCooldown();
		return;
	end
	
	local icon = getglobal(this:GetName().."Icon");
	local buttonCooldown = getglobal(this:GetName().."Cooldown");
	local texture = GetActionTexture(SecondActionButton_GetPagedID(this));
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		this.rangeTimer = TOOLTIP_UPDATE_TIME;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
		-- Save texture if the button is a bonus button, will be needed later
		if ( this.isBonus ) then
			this.texture = texture;
		end
	else
		icon:Hide();
		buttonCooldown:Hide();
		this.rangeTimer = nil;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
	end
	SecondActionButton_UpdateCount();
	if ( HasAction(SecondActionButton_GetPagedID(this)) ) then
		this:Show();
		SecondActionButton_UpdateUsable();
		SecondActionButton_UpdateCooldown();
	elseif ( this.showgrid == 0 ) then
		this:Hide();
	else
		getglobal(this:GetName().."Cooldown"):Hide();
	end
	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		SecondActionButton_StartFlash();
	else
		SecondActionButton_StopFlash();
	end
	if ( GameTooltip:IsOwned(this) ) then
		SecondActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(this:GetName().."Name");
	macroName:SetText(GetActionText(SecondActionButton_GetPagedID(this)));
end

function SecondActionButton_ShowGrid()
	this.showgrid = this.showgrid+1;
	getglobal(this:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0);
	this:Show();
end

function SecondActionButton_HideGrid()	
	this.showgrid = this.showgrid-1;
	if ( this.showgrid == 0 and not HasAction(SecondActionButton_GetPagedID(this)) ) then
		this:Hide();
	end
end

function SecondActionButton_UpdateState()
	if ( IsCurrentAction(SecondActionButton_GetPagedID(this)) or IsAutoRepeatAction(SecondActionButton_GetPagedID(this)) ) then
		this:SetChecked(1);
	else
		this:SetChecked(0);
	end
end

function SecondActionButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(SecondActionButton_GetPagedID(this));
	if ( isUsable ) then
		local inRange = true;
		if ( this.rangeTimer and (IsActionInRange(SecondActionButton_GetPagedID(this)) == 0)) then
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

function SecondActionButton_UpdateCount()
	local text = getglobal(this:GetName().."Count");
	local count = GetActionCount(SecondActionButton_GetPagedID(this));
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function SecondActionButton_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(SecondActionButton_GetPagedID(this));
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function SecondActionButton_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if(Cosmos_RegisterConfiguration == nil) then
			if (SecondActionBar_ENABLE == nil) then
				SecondActionBar_ENABLE = 1;
			end
			SecondBar_Toggle(SecondActionBar_ENABLE);
			SecondBar_Save();
		end
		return;
	end
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == SecondActionButton_GetPagedID(this) ) then
			SecondActionButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_PAGE_CHANGED" or event == "PLAYER_AURAS_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" ) then
		SecondActionButton_Update();
		SecondActionButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		SecondActionButton_ShowGrid();
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		SecondActionButton_HideGrid();
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		SecondActionButton_UpdateHotkeys();
	end

	-- All event handlers below this line MUST only be valid when the button is visible
	if ( not this:IsVisible() ) then
		return;
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		SecondActionButton_UpdateUsable();
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		if ( arg1 == "player" or arg1 == "target" ) then
			SecondActionButton_UpdateUsable();
		end
		return;
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			SecondActionButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_STATE" ) then
		SecondActionButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_USABLE" ) then
		SecondActionButton_UpdateUsable();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		SecondActionButton_UpdateCooldown();
		return;
	end
	if ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		SecondActionButton_UpdateState();
		return;
	end
	if ( arg1 == "player" and (event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY") ) then
		SecondActionButton_UpdateUsable();
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(SecondActionButton_GetPagedID(this)) ) then
			SecondActionButton_StartFlash();
		end
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = nil;
		if ( IsAttackAction(SecondActionButton_GetPagedID(this)) ) then
			SecondActionButton_StopFlash();
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		SecondActionButton_UpdateUsable();
		return;
	end
	if ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(SecondActionButton_GetPagedID(this)) ) then
			SecondActionButton_StartFlash();
		end
		return;
	end
	if ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( SecondActionButton_IsFlashing() and not IsAttackAction(SecondActionButton_GetPagedID(this)) ) then
			SecondActionButton_StopFlash();
		end
		return;
	end
end

function SecondActionButton_SetTooltip()
	if ((GetCVar("UberTooltips") == "1") and (not Cosmos_RelocateUberTooltip)) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
	else
		if (SmartSetOwner) then
			SmartSetOwner(this);
		else
			GameTooltip:SetOwner(this,"ANCHOR_TOPRIGHT");
		end
	end

	if ( GameTooltip:SetAction(SecondActionButton_GetPagedID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function SecondActionButton_OnUpdate(elapsed)
	if ( SecondActionButton_IsFlashing() ) then
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
			SecondActionButton_UpdateUsable();
			local count = getglobal(this:GetName().."HotKey");
			if ( IsActionInRange( SecondActionButton_GetPagedID(this)) == 0 ) then
				count:SetVertexColor(1.0, 0.1, 0.1);
			else
				count:SetVertexColor(0.6, 0.6, 0.6);
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
		SecondActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function SecondActionButton_GetPagedID(button)
	if( button == nil ) then
		message("nil button passed into SecondActionButton_GetPagedID(), contact Jeff");
		return 0;
	end
	-- this doesnt seem to work with stances
	--if (CURRENT_ACTIONBAR_PAGE == NUM_ACTIONBAR_PAGES) then
	--	return (button:GetId());
	--end
	
	local actualPage = math.mod(CURRENT_ACTIONBAR_PAGE-1,NUM_ACTIONBAR_PAGES) +1;
	
	-- had to change this to handle different page bys
	return (button:GetID() + ((actualPage - 1) * NUM_ACTIONBAR_BUTTONS) + 12);
end

function SecondActionButton_StartFlash()
	this.flashing = 1;
	this.flashtime = 0;
	SecondActionButton_UpdateState();
end

function SecondActionButton_StopFlash()
	this.flashing = 0;
	getglobal(this:GetName().."Flash"):Hide();
	SecondActionButton_UpdateState();
end

function SecondActionButton_IsFlashing()
	if ( this.flashing == 1 ) then
		return 1;
	else
		return nil;
	end
end



function SecondBar_PetActionBar_UpdateYTarget(newY)
	PETACTIONBAR_YPOS = newY;
	PetActionBarFrame.yTarget = PETACTIONBAR_YPOS;
	-- this should probably have an if statement around it, but having issues with reloadui
		PetActionBarFrame:ClearAllPoints();
		PetActionBarFrame:SetPoint("TOPLEFT", PetActionBarFrame:GetParent():GetName(), "BOTTOMLEFT", PETACTIONBAR_XPOS, PetActionBarFrame.yTarget);
end

function SecondBar_FPSMove()
	if (Cosmos_GetCVar == nil or Cosmos_GetCVar("COS_COS_FPSMOVE_X") ~= 1) then
		FramerateLabel:ClearAllPoints();
		if (SecondBar_Enabled == 1) then 
			FramerateLabel:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 80, 64);
		else
			FramerateLabel:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 0, 64);
		end
	end
end
function SecondBarUpdate() 
	local leftSmallDragon = getglobal("MainMenuBarLeftEndCap");
	local rightSmallDragon = getglobal("MainMenuBarRightEndCap");
	local lefttext = getglobal("SecondBarTexture0");
	local righttext = getglobal("SecondBarTexture1");
	local petlefttext = getglobal("SlidingActionBarTexture0");
	local petrighttext = getglobal("SlidingActionBarTexture1");
	local sslefttext = getglobal("ShapeshiftBarLeft");
	local ssmidtext = getglobal("ShapeshiftBarMiddle");
	local ssrighttext = getglobal("ShapeshiftBarRight");
	local rightdragon = getglobal("SecondBarRightEndCap");
	if (SecondBar_HideArt ==1) then
			if (leftSmallDragon ~=nil) then
				leftSmallDragon:Hide();
			end
			if (rightSmallDragon ~=nil) then
				rightSmallDragon:Hide();
			end
			if (leftBigDragon ~=nil) then
				leftBigDragon:Hide();
			end

			if (lefttext ~=nil) then
				lefttext:Hide();
			end
			if (righttext ~=nil) then
				righttext:Hide();
			end
			if (petlefttext ~=nil) then
				petlefttext:Hide();
			end
			if (petrighttext ~=nil) then
				petrighttext:Hide();
			end
			if (sslefttext~=nil) then
				sslefttext:Hide();
			end
			if (ssmidtext~=nil) then
				ssmidtext:Hide();
			end
			if (ssrighttext~=nil) then
				ssrighttext:Hide();
			end
			if (rightdragon~=nil) then
				rightdragon:Hide();
			end
			for i=1, 12 do
				local button = getglobal("SecondActionButton"..i);
				if (button) then
					if (SecondBar_HideEmpty == 0) then
						button.showgrid = 1;
					else
						button.showgrid = 0;
					end

					if (( not (HasAction(SecondActionButton_GetPagedID(button)))) and (SecondBar_HideEmpty ~= 0)) then
						button:Hide();
					else
						button:Show();
					end
				end
			end
			for i=1, 10 do
				local button = getglobal("PetActionButton"..i);
				if (button) then
					local name = GetPetActionInfo(i);
					if (SecondBar_HideEmpty == 0) then
						button:Show();
					else
						if( not name ) then
							button:Hide();
						end
					end
				end
			end
	else
			if (rightSmallDragon ~=nil) then
				rightSmallDragon:Show();
			end
			if (leftSmallDragon ~=nil) then
				leftSmallDragon:Show();
			end

			if (lefttext ~=nil) then
				lefttext:Show();
			end
			if (righttext ~=nil) then
				righttext:Show();
			end
			if (petlefttext ~=nil) then
				petlefttext:Show();
			end
			if (petrighttext ~=nil) then
				petrighttext:Show();
			end
			if (sslefttext~=nil) then
				sslefttext:Show();
			end
			if (ssmidtext~=nil) then
				ssmidtext:Show();
			end
			if (ssrighttext~=nil) then
				ssrighttext:Show();
			end
			if (rightdragon~=nil) then
				rightdragon:Show();
			end
			for i=1, 12 do
				local button = getglobal("SecondActionButton"..i);
				if (button) then
					local buttonCooldown = getglobal(button:GetName().."Cooldown");
					button.showgrid = 0;

					button:Show();
				end
			end
			for i=1, 10 do
				local button = getglobal("PetActionButton"..i);
				if (button) then
					local name = GetPetActionInfo(i);
					if( not name ) then
						button:Hide();
					end
				end
			end
	end

	if (SecondBar_Enabled == 1) then 
		SecondBar:Show(); 
	else	
		SecondBar:Hide(); 
		for i=1, 12 do
			local button = getglobal("SecondActionButton"..i);
			if (button) then
				button:Hide();
			end
		end
	end
end

function SecondBar_Toggle ( toggle ) 
	local leftSmallDragon = getglobal("MainMenuBarLeftEndCap");
	SecondBar_Enabled = toggle;
	if (toggle == 1) then 
		--adjust the shapeshift bar frame
		ShapeshiftBarFrame:ClearAllPoints();
		SHAPESHIFTBAR_YPOS = 43;

		--adjust the pet bar
		heightAnchor = MainMenuBar:GetHeight();
		heightAnchor = heightAnchor + SecondBar:GetHeight();
		heightAnchor = heightAnchor + PetActionBarFrame:GetHeight();
		heightAnchor = heightAnchor + 1 -- Add 1 pixel of space
		SecondBar_PetActionBar_UpdateYTarget(heightAnchor);

		ShapeshiftBar_Update();


		FCF_UpdateDockPosition();
	else 
		--adjust the shapeshift bar frame
		ShapeshiftBarFrame:ClearAllPoints();
		SHAPESHIFTBAR_YPOS = 0;

		--adjust the pet bar
		heightAnchor = MainMenuBar:GetHeight(); 
		heightAnchor = heightAnchor + PetActionBarFrame:GetHeight();
		heightAnchor = heightAnchor + 1 -- Add 1 pixel of space
		SecondBar_PetActionBar_UpdateYTarget(heightAnchor);
		ShapeshiftBar_Update();

		FCF_UpdateDockPosition();
	end
	SecondBarUpdate();
	SecondBar_FPSMove();
end

function SecondBar_RemoveArt ( toggle )
	SecondBar_HideArt = toggle;
	SecondBarUpdate();
end

function SecondBar_SetHideEmpty(toggle)
	if (toggle) then
		if (SecondBar_HideEmpty ~= toggle) then
			SecondBar_HideEmpty=toggle;
			local lefttext = getglobal("SecondBarTexture0");
			if (lefttext) then
				if (lefttext:IsVisible()) then
					SecondBar_RemoveArt(0);
				else
					SecondBar_RemoveArt(1);
				end
			end
		end
	end
	SecondBarUpdate();
end

function SecondBar_ToggleControlCast ( toggle )
	if (toggle == 1) then
		if(BlizzardActionButtonDown == nil) then
			BlizzardActionButtonDown = ActionButtonDown;
			BlizzardActionButtonUp = ActionButtonUp;
			ActionButtonDown = function(id)
				if (IsControlKeyDown() and (not PetActionBarFrame:IsVisible())) then
					if ( not (SecondActionButtonDown == nil) ) then
						SecondActionButtonDown(id);
						return;
					end
				end
				
				BlizzardActionButtonDown(id);
			end
		
			ActionButtonUp = function(id)
				if (IsControlKeyDown() and (not PetActionBarFrame:IsVisible())) then
					if ( not (SecondActionButtonUp == nil) ) then
						SecondActionButtonUp(id);
						return;
					end
				end
			
				BlizzardActionButtonUp(id);
			end
		end
	else
		if ( not (BlizzardActionButtonDown == nil)) then
			ActionButtonDown = BlizzardActionButtonDown;
			BlizzardActionButtonDown = nil;
		end
		if ( not (BlizzardActionButtonUp == nil)) then
			ActionButtonUp = BlizzardActionButtonUp;
			BlizzardActionButtonUp = nil;
		end
	end
end

function SecondBar_PagesToggle ( toggle ) 
	-- change the paging style
	if (toggle == 1) then 
		NUM_ACTIONBAR_PAGES = 3;
		NUM_ACTIONBAR_BUTTONS = 24;
	else
		NUM_ACTIONBAR_PAGES = 6;
		NUM_ACTIONBAR_BUTTONS = 12;
	end
	-- set the current page to page 1 just in case
	CURRENT_ACTIONBAR_PAGE = 1;
	-- update the actionbar
	ChangeActionBarPage();
end

function SecondBar_SetHideKeys(checked)
	if (checked and (checked==1)) then
		if (SecondBar_HideKeys ~= 1) then
			SecondBar_HideKeys=1;
			SecondActionButton_UpdateAllHotkeys();
		end
	else
		if (SecondBar_HideKeys ~= 0) then
			SecondBar_HideKeys=0;
			SecondActionButton_UpdateAllHotkeys();
		end
	end
end

function SecondBar_SetHideKeyMod(checked)
	if (checked and (checked==1)) then
		if (SecondBar_HideKeyMod ~= 1) then
			SecondBar_HideKeyMod=1;
			SecondActionButton_UpdateAllHotkeys();
		end
	else
		if (SecondBar_HideKeyMod ~= 0) then
			SecondBar_HideKeyMod=0;
			SecondActionButton_UpdateAllHotkeys();
		end
	end
end

function SecondBar_Save()
	RegisterForSave("SecondActionBar_ENABLE");
end





function SecondBar_OnLoad()
	if( SecondBar_INITIALIZED == 0) then
		SecondAction_OldActionButton_GetPagedID = ActionButton_GetPagedID;
		ActionButton_GetPagedID = SecondAction_ActionButton_GetPagedID;  
		Sea.util.hook("ShapeshiftBar_Update","SecondAction_ShapeshiftBar_Update","after");
		Sea.util.hook("FCF_UpdateDockPosition","SecondAction_FCF_UpdateDockPosition","after");
		Sea.util.hook("FCF_Set_SimpleChat","SecondAction_FCF_Set_SimpleChat","after");
		Sea.util.hook("FCF_Set_NormalChat","SecondAction_FCF_Set_SimpleChat","after");
		Sea.util.hook("PetActionBar_Update","SecondAction_PetActionBar_Update","after");
		Sea.util.hook("PetActionBar_HideGrid","SecondAction_PetActionBar_HideGrid","after");
		-- unfortunately cant use HookFunction due to inadequate return type handling
		if(not (Cosmos_RegisterConfiguration == nil)) then
			Sea.util.hook("Cosmos_TurnOnFPSMove","SecondAction_Cosmos_TurnOnFPSMove","after");
			Cosmos_RegisterConfiguration("COS_SECONDBAR", "SECTION", SAB_SEP, SAB_SEP_INFO );
			Cosmos_RegisterConfiguration("COS_SECONDBAR_HEADER", "SEPARATOR", SAB_SEP, SAB_SEP_INFO );
			Cosmos_RegisterConfiguration("COS_SECONDBAR_ONOFF", "CHECKBOX", 
				SAB_CHECK, 
				SAB_CHECK_INFO,
				SecondBar_Toggle,
				0
				);
			Cosmos_RegisterConfiguration("COS_SECONDBAR_PAGES", "CHECKBOX", 
				SAB_CHECK_PAGE, 
				SAB_CHECK_PAGE_INFO,
				SecondBar_PagesToggle,
				0
				);
			Cosmos_RegisterConfiguration("COS_SECONDBAR_SKIN", "CHECKBOX", 
				SAB_SKIN, 
				SAB_SKIN_INFO,
				SecondBar_RemoveArt,
				0
				);
			Cosmos_RegisterConfiguration("COS_SECONDBAR_HIDEEMPTY", "CHECKBOX", 
				SAB_HIDEEMPTY, 
				SAB_HIDEEMPTY_INFO,
				SecondBar_SetHideEmpty,
				0
				)
			Cosmos_RegisterConfiguration("COS_SECONDBAR_HIDEKEYS", "CHECKBOX",
				SAB_HIDEKEYS,
				SAB_HIDEKEYS_INFO,
				SecondBar_SetHideKeys,
				SecondBar_HideKeys
				);
			Cosmos_RegisterConfiguration("COS_SECONDBAR_HIDEKEYMOD", "CHECKBOX",
				SAB_HIDEKEYMOD,
				SAB_HIDEKEYMOD_INFO,
				SecondBar_SetHideKeyMod,
				SecondBar_HideKeyMod
				);
		else
			SecondBar_Toggle(1);
			SLASH_SECONDBAR1 = "/secondbar";
			SlashCmdList["SECONDBAR"] = function(msg)
				local tag = string.lower(msg);
				if ((tag ~= nil) and not (string.len(tag) == 0)) then
					if((string.find("on",tag) ~= nil)) then
						SecondBar_Toggle(1);
						DEFAULT_CHAT_FRAME:AddMessage("SecondBar enabled",1.0, 1.0, 0.0, 1.0);
					elseif((string.find("off",tag) ~= nil)) then
						SecondBar_Toggle(0);
						DEFAULT_CHAT_FRAME:AddMessage("SecondBar disabled",1.0, 1.0, 0.0, 1.0);
					elseif((string.find("save",tag) ~= nil)) then
						SecondBar_Save()
						DEFAULT_CHAT_FRAME:AddMessage("SecondBar persistent variables saved",1.0, 1.0, 0.0, 1.0);
					end
				else
					DEFAULT_CHAT_FRAME:AddMessage("SecondBar parameters: on, off, save",1.0, 1.0, 0.0, 1.0);
				end
			end
		end
		SecondBar_INITIALIZED = 1;
	end
end		

-- Second bar function overrides
function SecondAction_ActionButton_GetPagedID (button) 
		-- always call the old button
     local retval = SecondAction_OldActionButton_GetPagedID(button);
     if (SecondBar_Enabled == 1) then
	     local actualPage = math.mod(CURRENT_ACTIONBAR_PAGE-1,NUM_ACTIONBAR_PAGES) +1; 
	     if( button == nil ) then 
	          message(ACTIONBUTTON_ERROR_MESSAGE_NIL_BUTTON); 
	          return 0; 
	     end 
	     if ( button.isBonus and actualPage == 1 ) then 
	          local offset = GetBonusBarOffset();
			    if ( offset == 0 and BonusActionBarFrame and BonusActionBarFrame.lastBonusBar ) then
				    offset = BonusActionBarFrame.lastBonusBar;
			    end
			    return (button:GetID() + ((6 + offset - 1) * 12));
	     else 
	          return (button:GetID() + ((actualPage - 1) * NUM_ACTIONBAR_BUTTONS)) 
	     end 
    end
    return retval;
end

function SecondAction_ShapeshiftBar_Update()
	if ( GetNumShapeshiftForms() > 0 ) then
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT",SHAPESHIFTBAR_XPOS,SHAPESHIFTBAR_YPOS);
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83 + SHAPESHIFTBAR_YPOS);
	else
		if ( not PetHasActionBar() ) then
			--Move the casting bar back down
			CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60 + SHAPESHIFTBAR_YPOS);
		else 
			CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83 + SHAPESHIFTBAR_YPOS);
		end
	end
end

function SecondAction_FCF_UpdateDockPosition() 
	if ( DEFAULT_CHAT_FRAME:IsUserPlaced()) then
		if ( SIMPLE_CHAT ~= "1" ) then
			return;
		end
	end
	
	local offY = 85;

	if (SecondBar_Enabled == 1) then
		offY = offY + 42;
	end
	if (PetHasActionBar() or GetNumShapeshiftForms() > 0) then
		offY = offY + 34;
	end
	DEFAULT_CHAT_FRAME:ClearAllPoints();	
	DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, offY);
end

function SecondAction_FCF_Set_SimpleChat()
	SecondAction_FCF_UpdateDockPosition();
end
function SecondAction_FCF_Set_NormalChat()
	SecondAction_FCF_UpdateDockPosition();
end

function SecondAction_PetActionBar_Update()
	local petActionButton;
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		petActionButton = getglobal("PetActionButton"..i);
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if ( not name ) then
			if ( PetActionBarFrame.showgrid == 0 ) then
				local lefttext = getglobal("SecondBarTexture0");
				local artshown = true;
				if (lefttext and (not lefttext:IsVisible())) then
					artshown = nil;
				end
				if (artshown or ((SecondBar_HideEmpty == 1) and (not artshown))) then
					petActionButton:Hide();
				end
			end
		end
	end
end


function SecondAction_PetActionBar_HideGrid()
	local lefttext = getglobal("SecondBarTexture0");
	local artshown = true;
	if (lefttext and (not lefttext:IsVisible())) then
		artshown = nil;
	end
	if (artshown or ((SecondBar_HideEmpty == 1) and (not artshown))) then
		if ( PetActionBarFrame.showgrid == 0 ) then
			HidePetActionBar();
			local name;
			for i=1, NUM_PET_ACTION_SLOTS, 1 do
				name = GetPetActionInfo(i);
				if ( not name ) then
					getglobal("PetActionButton"..i):Hide();
				end
			end
		end
	end
end

--overide cosmos move world!
function SecondAction_Cosmos_TurnOnFPSMove(toggle)
	SecondBar_FPSMove();
end

