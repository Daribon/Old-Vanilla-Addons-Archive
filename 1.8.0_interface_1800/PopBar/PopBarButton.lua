--[[
	PopBar

	By Mugendai

	This mod is a highly configurable auto hiding
	action bar.  You can move it around, set its
	size and all kinds of junk.
   ]]

POPBAR_MAX_ID=72;
POPBAR_MAX_HIGH_ID=120;
POPBAR_HIGH_ID=109;
POPBAR_UPDATETIME=0.1;
POPBAR_MAX_BARS=7;
POPBAR_MAX_ROWS=12;
POPBAR_MAX_COLS=12;
POPBAR_MAX_POPTIME=2;
PopBar_Config = { };
PopBar_Config.Enabled=0;
PopBar_Config.HideEmpty=0;
PopBar_Config.Rows=2;
PopBar_Config.Cols=12;
PopBar_Config.VAnchor=0;
PopBar_Config.HAnchor=0;
PopBar_Config.IDUp=0;
PopBar_Config.StartPage=5;
PopBar_Config.StartButton=12;
PopBar_Config.RowShow=1;
PopBar_Config.ColShow=12;
PopBar_Config.Orient=0;
PopBar_Config.InArea=0;
PopBar_Config.TurnPages=0;
PopBar_Config.KnobAlpha=1;
PopBar_Config.BarAlpha=1;
PopBar_Config.HideKeys=0;
PopBar_Config.HideKeyMod=0;
PopBar_Config.FlipH=0;
PopBar_Config.FlipV=0;
PopBar_Config.PopTime=0;
--Store this config for safe load
MCom.safeLoad("PopBar_Config");

PopBar_StartID=72;
PopBar_Initialized=0;
PopBar_Hovering=false;
PopBar_Toggled=false;
PopBar_LastUpdate=0;
PopBar_AnchorUpdated=false;
PopBar_RowLimit=6;
PopBar_ColLimit=12;
PopBar_Loaded=false;

function PopBar_OnUpdate(elapsed)
	if (PopBar_Config.Enabled == 1) then
		PopBar_LastUpdate = PopBar_LastUpdate + elapsed;
		if (PopBar_LastUpdate >= POPBAR_UPDATETIME) then 
			PopBar_LastUpdate = 0;
			
			if (not PopBar_AnchorUpdated) then
				PopBar_AnchorUpdated = true;
				local PopBar_VAnchor = "BOTTOM";
				local PopBar_HAnchor = "LEFT";
				if (PopBar_Config.VAnchor == 1) then
					PopBar_VAnchor = "TOP";
				end
				if (PopBar_Config.HAnchor == 1) then
					PopBar_HAnchor = "RIGHT";
				end
				this:ClearAllPoints();
				this:SetPoint(PopBar_VAnchor..PopBar_HAnchor,"PopBarKnob","CENTER",0,0);
			end
			
			local xPos, yPos = GetCursorPosition();
			local left = this:GetLeft() * UIParent:GetScale();
			local right = this:GetRight() * UIParent:GetScale();
			local top = this:GetTop() * UIParent:GetScale();
			local bottom = this:GetBottom() * UIParent:GetScale();
			local knob = getglobal("PopBarKnob");
			local kleft = nil;
			local kright = nil;
			local ktop = nil;
			local kbottom = nil;
			if (knob) then
				kleft = knob:GetLeft() * UIParent:GetScale();
				kright = knob:GetRight() * UIParent:GetScale();
				ktop = knob:GetTop() * UIParent:GetScale();
				kbottom = knob:GetBottom() * UIParent:GetScale();
				
				if (PopBar_Config.KnobAlpha > 0) then
					if (not knob:IsVisible()) then
						knob:Show();
					end
				else
					if (knob:IsVisible()) then
						knob:Hide();
					end
				end
					
				if (this:GetAlpha() ~= PopBar_Config.BarAlpha) then
					this:SetAlpha(PopBar_Config.BarAlpha);
				end
				
				if (knob:GetAlpha() ~= PopBar_Config.KnobAlpha) then
					knob:SetAlpha(PopBar_Config.KnobAlpha);
				end
			end
			if (xPos and yPos and left and right and top and bottom and knob and kleft and kright and ktop and kbottom) then
				local butsize = (36 * UIParent:GetScale());
				local spacesize = (6 * UIParent:GetScale());
				if ((PopBar_Config.InArea == 1) or PopBar_Hovering) then
					if (PopBar_Config.HAnchor==1) then
						left = right - ((PopBar_Config.Cols * butsize) + ((PopBar_Config.Cols - 1) * spacesize));
					else
						right = left + ((PopBar_Config.Cols * butsize) + ((PopBar_Config.Cols - 1) * spacesize));
					end
					if (PopBar_Config.VAnchor==1) then
						bottom = top - ((PopBar_Config.Rows * butsize) + ((PopBar_Config.Rows - 1) * spacesize));
					else
						top = bottom + ((PopBar_Config.Rows * butsize) + ((PopBar_Config.Rows - 1) * spacesize));
					end
				elseif ((PopBar_Config.ColShow > 0) and (PopBar_Config.RowShow > 0)) then
					if (PopBar_Config.HAnchor==1) then
						left = right - ((PopBar_Config.ColShow * butsize) + ((PopBar_Config.ColShow - 1) * spacesize));
					else
						right = left + ((PopBar_Config.ColShow * butsize) + ((PopBar_Config.ColShow - 1) * spacesize));
					end
					if (PopBar_Config.VAnchor==1) then
						bottom = top - ((PopBar_Config.RowShow * butsize) + ((PopBar_Config.RowShow - 1) * spacesize));
					else
						top = bottom + ((PopBar_Config.RowShow * butsize) + ((PopBar_Config.RowShow - 1) * spacesize));
					end
				else
					left = -1;
					right = -1;
					top = -1;
					bottom = -1;
				end
				
				if (((xPos >= left) and (xPos <= right) and (yPos >= bottom) and (yPos <= top)) or ((xPos >= kleft) and (xPos <= kright) and (yPos >= kbottom) and (yPos <= ktop))) then
					PopBar_Hover(1);
				else
					PopBar_Hover(0);
				end
			end
		end
	end
end

function PopBar_SetRows(checked, count)
	if (count) then
		if (count > POPBAR_MAX_ROWS) then
			count = POPBAR_MAX_ROWS;
		end
		if (count < 1) then
			count = 1;
		end
		if (PopBar_Config.Rows ~= count) then
			PopBar_Config.Rows = count;
			PopBar_ColLimit = floor((POPBAR_MAX_ID + 12) / PopBar_Config.Rows);
			if (PopBar_ColLimit > POPBAR_MAX_COLS) then
				PopBar_ColLimit = POPBAR_MAX_COLS;
			end
			
			if (PopBar_Loaded) then
				if (PopBar_Config.Cols > PopBar_ColLimit) then
					PopBar_SetCols(0,PopBar_ColLimit);
				end
				if (PopBar_Config.ColShow > PopBar_ColLimit) then
					PopBar_SetColShow(0,PopBar_ColLimit);
				end
			end
		end
		PopBar_Update();
	end
end

function PopBar_SetCols(checked, count)
	if (count) then
		if (count > POPBAR_MAX_COLS) then
			count = POPBAR_MAX_COLS;
		end
		if (count < 1) then
			count = 1;
		end
		if (PopBar_Config.Cols ~= count) then
			PopBar_Config.Cols = count;
			PopBar_RowLimit = floor((POPBAR_MAX_ID + 12) / PopBar_Config.Cols);
			if (PopBar_RowLimit > POPBAR_MAX_ROWS) then
				PopBar_RowLimit = POPBAR_MAX_ROWS;
			end
			if (PopBar_Loaded) then
				if (PopBar_Config.Rows > PopBar_RowLimit) then
					PopBar_SetRows(0,PopBar_RowLimit);
				end
				if (PopBar_Config.RowShow > PopBar_RowLimit) then
					PopBar_SetRowShow(0,PopBar_RowLimit);
				end
			end
		end
		PopBar_Update();
	end
end

function PopBar_SetRowShow(checked, count)
	if (count) then
		local newCount = count;
		if (newCount > PopBar_Config.Rows) then
			newCount = PopBar_Config.Rows;
		end
		if (newCount < 0) then
			newCount = 0;
		end
		if (PopBar_Config.RowShow ~= newCount) then
			PopBar_Config.RowShow = newCount;
		end
		PopBar_Update();
	end
end

function PopBar_SetColShow(checked, count)
	if (count) then
		local newCount = count;
		if (newCount > PopBar_Config.Cols) then
			newCount = PopBar_Config.Cols;
		end
		if (newCount < 0) then
			newCount = 0;
		end
		if (PopBar_Config.ColShow ~= newCount) then
			PopBar_Config.ColShow = newCount;
		end
		PopBar_Update();
	end
end

function PopBar_Toggle(toggle)
	if (toggle == 1) then
		if (not PopBar_Toggled) then
			PopBar_Toggled = true;
			PopBar_Update();
		end
	elseif (toggle == 0) then
		if (PopBar_Toggled) then
			PopBar_Toggled = false;
			PopBar_Update();
		end
	elseif (PopBar_Toggled) then
		PopBar_Toggled = false;
		PopBar_Update();
	else
		PopBar_Toggled = true;
		PopBar_Update();
	end
end

function PopBar_Hover(toggle)
	if (toggle == 1) then
		local canHover = false;
		if (Chronos) then
			if (Chronos.getTimer("POPBAR") == 0) then
				Chronos.startTimer("POPBAR");
			end
			if (not PopBar_Config.PopTime) then
				PopBar_Config.PopTime = 0;
			end
			if (Chronos.getTimer("POPBAR") >= PopBar_Config.PopTime) then
				canHover = true;
			end
		else
			canHover = true;
		end
		
		if ((not PopBar_Hovering) and canHover) then
			PopBar_Hovering = true;
			PopBar_Update();
		end
	else
		if (Chronos) then
			Chronos.endTimer("POPBAR");
		end
		if (PopBar_Hovering) then
			PopBar_Hovering = false;
			PopBar_Update();
		end
	end
end

function PopBar_Update(fullupdate)
	if (PopBar_Initialized == 1) then
		PopBar_StartID = ((PopBar_Config.StartPage - 1) * 12) + PopBar_Config.StartButton;
		for row=1, POPBAR_MAX_ROWS do
			for i=1, POPBAR_MAX_COLS do
				local button = getglobal(string.format ("PopBarButton%d%02d", row, i));
				if (button) then
					if (not fullupdate) then
						PopBarButton_CheckShow(button);
					else
						PopBarButton_Update(button);
					end
				end
			end
		end
		--Use MCom's save function to save the config
		MCom.saveConfig( {
			configVar = "PopBar_Config";
		});
	end
end

function PopBar_ResetPos()
	local knob = getglobal("PopBarKnob");
	knob:ClearAllPoints();
	knob:SetPoint("CENTER","MainMenuBarArtFrame","TOPLEFT",522,4);
end

function PopBarButton_CheckShow(button)
	if (button) then
		local doShow = false;
		local firsti, lasti, row, col;
		if (string.len(button:GetID()) > 3) then
			firsti, lasti, row, col = string.find (button:GetID(), "(%d%d)(%d%d)");
		else
			firsti, lasti, row, col = string.find (button:GetID(), "(%d)(%d%d)");
		end
		if (row and col) then
			row = row + 0;
			col = col + 0;
			if (PopBar_Config.VAnchor==1) then
				row = POPBAR_MAX_ROWS - (row - 1);
			end
			if (PopBar_Config.HAnchor==1) then
				col = POPBAR_MAX_COLS - (col - 1);
			end
			if ((row <= PopBar_Config.Rows) and (col <= PopBar_Config.Cols)) then
				if (((row <= PopBar_Config.RowShow) and (col <= PopBar_Config.ColShow)) or PopBar_Toggled or PopBar_Hovering) then
					doShow = true;
				end
			end
			if ((PopBar_Config.HideEmpty == 1) and ((HasAction(PopBarButton_GetPagedID(button)) == nil) and (button.showgrid == 0))) then
				doShow = false;
			end
		end	
		
		if (doShow) then
			button:Show();
		else
			button:Hide();
		end
	end
end

function PopBarButtonDown(row,col)
	local butName = PopBarButton_GetBindButton(row, col);
	if (butName) then
		local button = getglobal(butName);
		if ( button:GetButtonState() == "NORMAL" ) then
			button:SetButtonState("PUSHED");
		end
	end
end

function PopBarButtonUp(row, col, onSelf)
	local butName = PopBarButton_GetBindButton(row, col);
	if (butName) then
		local button = getglobal(butName);
		if ( button:GetButtonState() == "PUSHED" ) then
			button:SetButtonState("NORMAL");
			-- Used to save a macro
			if ( MacroFrame_SaveMacro ) then
				MacroFrame_SaveMacro();
			end
			
			local pagedID = PopBarButton_GetPagedID(button);
			if (pagedID) then
				UseAction(pagedID, 0, onSelf);
				
				if ( IsCurrentAction(pagedID) ) then
					button:SetChecked(1);
				else
					button:SetChecked(0);
				end
			end
		end
	end
end

function PopBarButton_OnLoad()
	
	this.showgrid = 0;
	this.flashing = 0;
	this.flashtime = 0;
	PopBarButton_Update();
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
	PopBarButton_UpdateHotkeys();
end

function PopBarButton_UpdateHotkeys(actionButtonType,button)
	if ( not actionButtonType ) then
		actionButtonType = "POPBARBUTTON";
	end
	if (not button) then
		button = this;
	end
	local hotkey = getglobal(button:GetName().."HotKey");	
	local action = PopBarButton_GetBindID(button); --actionButtonType..button:GetID();
	if (hotkey) then
		if (PopBar_Config.HideKeys==1) then
			hotkey:SetText("");
		else
			if (action) then
				local keyText = GetBindingText(GetBindingKey(action), "KEY_");
				if (PopBar_Config.HideKeyMod==1) then
					while ( ( keyText ) and ( strlen(keyText) > 1 ) and (string.find(keyText, "-")) and (keyText ~= "KP -") and (keyText ~= "Num Pad -")) do
						firsti, lasti, keyText = string.find (keyText, "-(.+)");
					end
				end
				if ( ( not keyText ) or ( strlen(keyText) <= 0 ) ) then keyText = ""; end
				hotkey:SetText(keyText);
			else
				hotkey:SetText("");
			end
		end
	end
end

function PopBarButton_Update(button)
	if (not button) then
		button = this;
	end
	
	-- Determine whether or not the button should be flashing or not since the button may have missed the enter combat event
	local pagedID = PopBarButton_GetPagedID(button);
	if (pagedID ~= nil) then
		if ( IsAttackAction(pagedID) and IsCurrentAction(pagedID) ) then
			IN_ATTACK_MODE = 1;
		else
			IN_ATTACK_MODE = nil;
		end
		IN_AUTOREPEAT_MODE = IsAutoRepeatAction(pagedID);
		
		-- Special case code for bonus bar buttons
		-- Prevents the button from updating if the bonusbar is still in an animation transition
	
		-- Derek, I had to comment this out because it was causing them all to be grayed out after a cinematic...
		if ( button.isBonus and button.inTransition ) then
			PopBarButton_UpdateUsable(button);
			PopBarButton_UpdateCooldown(button);
			return;
		end
		
		local icon = getglobal(button:GetName().."Icon");
		local buttonCooldown = getglobal(button:GetName().."Cooldown");
		local texture = GetActionTexture(pagedID);
		if ( texture ) then
			icon:SetTexture(texture);
			icon:Show();
			button.rangeTimer = TOOLTIP_UPDATE_TIME;
			button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
			-- Save texture if the button is a bonus button, will be needed later
			if ( button.isBonus ) then
				button.texture = texture;
			end
		else
			icon:Hide();
			buttonCooldown:Hide();
			button.rangeTimer = nil;
			button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
		end
		PopBarButton_UpdateCount(button);
		if ( HasAction(pagedID) ) then
			button:Show();
			PopBarButton_UpdateUsable(button);
			PopBarButton_UpdateCooldown(button);
		elseif ( (PopBar_Config.HideEmpty == 1) and (button.showgrid == 0) ) then
			button:Hide();
		else
			getglobal(button:GetName().."Cooldown"):Hide();
		end
		if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
			PopBarButton_StartFlash(button);
		else
			PopBarButton_StopFlash(button);
		end
		if ( GameTooltip:IsOwned(button) ) then
			PopBarButton_SetTooltip(button);
		else
			button.updateTooltip = nil;
		end

		-- Add a green border if button is an equipped item
		local border = getglobal(button:GetName().."Border");
		if ( IsEquippedAction(pagedID) ) then
			border:SetVertexColor(0, 1.0, 0, 0.35);
			border:Show();
		else
			border:Hide();
		end

		PopBarButton_UpdateHotkeys("POPBARBUTTON",button);
		PopBarButton_CheckShow(button);
	
		-- Update Macro Text
		local macroName = getglobal(button:GetName().."Name");
		macroName:SetText(GetActionText(pagedID));
	end
end

function PopBarButton_ShowGrid(button)
	if (not button) then
		button = this;
	end
	button.showgrid = button.showgrid+1;
	--getglobal(this:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0);
	--button:Show();
	PopBarButton_CheckShow(button);
end

function PopBarButton_HideGrid(button)
	if (not button) then
		button = this;
	end
	button.showgrid = button.showgrid-1;
	--if ( button.showgrid == 0 and not HasAction(PopBarButton_GetPagedID(button)) ) then
	--	button:Hide();
	--end
	PopBarButton_CheckShow(button);
end

function PopBarButton_UpdateState(button)
	if (not button) then
		button = this;
	end
	local pagedID = PopBarButton_GetPagedID(button);
	if (pagedID) then
		if ( IsCurrentAction(pagedID) or IsAutoRepeatAction(pagedID) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

function PopBarButton_UpdateUsable(button)
	if (not button) then
		button = this;
	end
	local icon = getglobal(button:GetName().."Icon");
	local normalTexture = getglobal(button:GetName().."NormalTexture");
	local pagedID = PopBarButton_GetPagedID(button);
	local isUsable, notEnoughMana;
	if (pagedID) then
		isUsable, notEnoughMana = IsUsableAction(pagedID);
	end
	if (icon and normalTexture) then
		if ( isUsable ) then
			local inRange = true;
			if ( button.rangeTimer and (IsActionInRange(PopBarButton_GetPagedID(button)) == 0)) then
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
end

function PopBarButton_UpdateCount(button)
	if (not button) then
		button = this;
	end
	local text = getglobal(button:GetName().."Count");
	local count = GetActionCount(PopBarButton_GetPagedID(button));
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function PopBarButton_UpdateCooldown(button)
	if (not button) then
		button = this;
	end
	local cooldown = getglobal(button:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(PopBarButton_GetPagedID(button));
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function PopBarButton_OnEvent(event)
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == PopBarButton_GetPagedID(this) ) then
			PopBarButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_PAGE_CHANGED" or event == "PLAYER_AURAS_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" ) then
		PopBarButton_Update();
		PopBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		PopBarButton_ShowGrid();
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		PopBarButton_HideGrid();
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		PopBarButton_UpdateHotkeys();
	end

	-- All event handlers below this line MUST only be valid when the button is visible
	if ( not this:IsVisible() ) then
		return;
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		PopBarButton_UpdateUsable();
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		if ( arg1 == "player" or arg1 == "target" ) then
			PopBarButton_UpdateUsable();
		end
		return;
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			PopBarButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_STATE" ) then
		PopBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_USABLE" ) then
		PopBarButton_UpdateUsable();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		PopBarButton_UpdateCooldown();
		return;
	end
	if ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		PopBarButton_UpdateState();
		return;
	end
	if ( arg1 == "player" and (event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY") ) then
		PopBarButton_UpdateUsable();
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(PopBarButton_GetPagedID(this)) ) then
			PopBarButton_StartFlash();
		end
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = nil;
		if ( IsAttackAction(PopBarButton_GetPagedID(this)) ) then
			PopBarButton_StopFlash();
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		PopBarButton_UpdateUsable();
		return;
	end
	if ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(PopBarButton_GetPagedID(this)) ) then
			PopBarButton_StartFlash();
		end
		return;
	end
	if ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( PopBarButton_IsFlashing() and not IsAttackAction(PopBarButton_GetPagedID(this)) ) then
			PopBarButton_StopFlash();
		end
		return;
	end
end

function PopBarButton_SetTooltip(button)
	if (not button) then
		button = this;
	end

	if ((GetCVar("UberTooltips") == "1") and (not Cosmos_RelocateUberTooltip)) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
	else
		if (SmartSetOwner) then
			SmartSetOwner(this);
		else
			GameTooltip:SetOwner(this,"ANCHOR_TOPRIGHT");
		end
	end

	if ( GameTooltip:SetAction(PopBarButton_GetPagedID(button)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function PopBarButton_OnUpdate(elapsed)
	if ( PopBarButton_IsFlashing() ) then
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
			PopBarButton_UpdateUsable(button);
			local count = getglobal(this:GetName().."HotKey");
			if (IsActionInRange( PopBarButton_GetPagedID(this)) == 0) then
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
		PopBarButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function PopBarButton_GetPagedID(button)
	if( button == nil ) then
		message("nil button passed into PopBarButton_GetPagedID(), contact Jeff");
		return 0;
	end
	
	local firsti, lasti, row, col;
	if (string.len(button:GetID()) > 3) then
		firsti, lasti, row, col = string.find (button:GetID(), "(%d%d)(%d%d)");
	else
		firsti, lasti, row, col = string.find (button:GetID(), "(%d)(%d%d)");
	end
	local page = CURRENT_ACTIONBAR_PAGE;
	if (PopBar_Config.TurnPages==0) then
		page = 1;
	end
	if (row and col) then
		row = row+0;
		col = col+0;
		local retid = 1;
		if (PopBar_Config.VAnchor==1) then
			row = POPBAR_MAX_ROWS - (row - 1);
		end
		if (PopBar_Config.FlipV==1) then
			row = PopBar_Config.Rows - (row - 1);
		end		
		if (PopBar_Config.HAnchor==1) then
			col = POPBAR_MAX_COLS - (col - 1);
		end
		if (PopBar_Config.FlipH==1) then
			col = PopBar_Config.Cols - (col - 1);
		end
		local butNum;
		if (PopBar_Config.Orient==1) then		
			butNum = (PopBar_Config.Rows * (col - 1)) + row;
		else
			butNum = (PopBar_Config.Cols * (row - 1)) + col;
		end
		if (PopBar_Config.IDUp == 1) then
			retid = butNum + (PopBar_StartID - 1) + ((page - 1) * 12);
		else
			retid = ((PopBar_StartID + 1) + ((page - 1) * 12)) - butNum;
		end
		if (retid > POPBAR_MAX_ID) then
			retid = retid + ((POPBAR_HIGH_ID - 1) - POPBAR_MAX_ID);
			if (retid > POPBAR_MAX_HIGH_ID) then
				retid = retid - POPBAR_MAX_HIGH_ID;
			end
		end
		if (retid < 1) then
			retid = POPBAR_MAX_HIGH_ID + retid;
			if (retid < POPBAR_HIGH_ID) then
				retid = retid - ((POPBAR_HIGH_ID - 1) - POPBAR_MAX_ID);
			end
		end
		return retid;
	else
		return nil;
	end
end

function PopBarButton_GetBindID(button)
	if( button == nil ) then
		message("nil button passed into PopBarButton_GetPagedID(), contact Jeff");
		return 0;
	end
		
	local firsti, lasti, row, col;
	if (string.len(button:GetID()) > 3) then
		firsti, lasti, row, col = string.find (button:GetID(), "(%d%d)(%d%d)");
	else
		firsti, lasti, row, col = string.find (button:GetID(), "(%d)(%d%d)");
	end
	local retid = nil;
	if (row and col) then
		row = row + 0;
		col = col + 0;
		if (PopBar_Config.VAnchor==1) then
			row = POPBAR_MAX_ROWS - (row - 1);
		end
		if (PopBar_Config.HAnchor==1) then
			col = POPBAR_MAX_COLS - (col - 1);
		end
		if ((row <= PopBar_Config.Rows) and (col <= PopBar_Config.Cols)) then
			local butNum=nil;
			if (PopBar_Config.Orient==1) then
				butNum = ((PopBar_Config.Rows * (col - 1)) + row);
				row = ceil(butNum / PopBar_Config.Rows);
				col = butNum - ((col - 1) * PopBar_Config.Rows);
			else
				butNum = ((PopBar_Config.Cols * (row - 1)) + col);
				row = ceil(butNum / PopBar_Config.Cols);
				col = butNum - ((row - 1) * PopBar_Config.Cols);
			end
			retid = string.format("POPBARBUTTON%d%02d", row, col);
		end
	end
	return retid;
end

function PopBarButton_GetBindButton(row, col)
	if (PopBar_Config.Orient==1) then
		local temp = col;
		col = row;
		row = temp;
	end
	local retid = nil;
	if ((row <= PopBar_Config.Rows) and (col <= PopBar_Config.Cols)) then
		if (PopBar_Config.VAnchor==1) then
			row = POPBAR_MAX_ROWS - (row - 1);
		end
		if (PopBar_Config.HAnchor==1) then
			col = POPBAR_MAX_COLS - (col - 1);
		end
		retid = string.format("PopBarButton%d%02d", row, col);
	end
	return retid;
end

function PopBarButton_StartFlash(button)
	if (not button) then
		button = this;
	end
	button.flashing = 1;
	button.flashtime = 0;
	PopBarButton_UpdateState();
end

function PopBarButton_StopFlash(button)
	if (not button) then
		button = this;
	end
	button.flashing = 0;
	getglobal(button:GetName().."Flash"):Hide();
	PopBarButton_UpdateState();
end

function PopBarButton_IsFlashing(button)
	if (not button) then
		button = this;
	end
	if ( button.flashing == 1 ) then
		return 1;
	else
		return nil;
	end
end

function PopBar_Show ( toggle ) 
	if (toggle == -1) then
		if (PopBar_Config.Enabled == 1) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 1) then 
		PopBar:Show();
		PopBarKnob:Show();
		PopBar_Config.Enabled = 1;
	else
		PopBar:Hide(); 
		PopBarKnob:Hide();
		PopBar_Config.Enabled = 0;
	end
end

function PopBar_OnLoad()
	if( PopBar_Initialized == 0) then
		MCom.registerVarsLoaded(PopBar_CosVarsLoaded);
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR",
				"SECTION",
				POPBAR_CONFIG_HEADER,
				POPBAR_CONFIG_HEADER_INFO
			};
			uifolder = "bars";
			uisecdiff = 1;
			addonname = "PopBar";
			name = POPBAR_CONFIG_HEADER;									--The name of the addon, for display in the info text
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_TOGGLE", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_ONOFF,
				POPBAR_CONFIG_ONOFF_INFO,
				nil,
				PopBar_Config.Enabled
			};
			uidiff = 1;
			uisep = "POPBAR_HEADER";
			uiseplabel = POPBAR_CONFIG_HEADER;
			uisepdesc = POPBAR_CONFIG_HEADER_INFO;
			uisepdiff = 1;
			varbool = "PopBar_Config.Enabled";							--The boolean variable associate with this option
			update = function ()	PopBar_Update(true);
														PopBar_Show(MCom.getStringVar("PopBar_Config.Enabled")); end;
			supercom = {"/popbar", "/pb"};								--The main slash command, and any aliases for it
			comaction = "before";													--See Sky for info on this
			comsticky = false;														--See Sky for info on this
			comhelp = POPBAR_CHAT_COMMAND_INFO;						--The help text to show for the slash command
			subcom = {"enable"};														--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_PAGES", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_PAGES,
				POPBAR_CONFIG_PAGES_INFO,
				nil,
				PopBar_Config.TurnPages
			};
			uidiff = 2;
			varbool = "PopBar_Config.TurnPages";						--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"pages"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_HIDEEMPTY", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HIDEEMPTY,
				POPBAR_CONFIG_HIDEEMPTY_INFO,
				nil,
				PopBar_Config.HideEmpty
			};
			uidiff = 1;
			varbool = "PopBar_Config.HideEmpty";						--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"hideempty"};													--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_HIDEKEYS", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HIDEKEYS,
				POPBAR_CONFIG_HIDEKEYS_INFO,
				nil,
				PopBar_Config.HideKeys
			};
			uidiff = 2;
			varbool = "PopBar_Config.HideKeys";							--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"hidekeys"};													--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_HIDEKEYMOD", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HIDEKEYMOD,
				POPBAR_CONFIG_HIDEKEYMOD_INFO,
				nil,
				PopBar_Config.HideKeyMod
			};
			uidiff = 2;
			varbool = "PopBar_Config.HideKeyMod";						--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"hidekeymod"};												--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_ORIENT", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_ORIENT,
				POPBAR_CONFIG_ORIENT_INFO,
				nil,
				PopBar_Config.Orient
			};
			uidiff = 1;
			varbool = "PopBar_Config.Orient";								--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"orient"};														--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_AREA", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_AREA,
				POPBAR_CONFIG_AREA_INFO,
				nil,
				PopBar_Config.InArea
			};
			uidiff = 1;
			varbool = "PopBar_Config.InArea";								--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"area"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_VANCHOR", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_VANCHOR,
				POPBAR_CONFIG_VANCHOR_INFO,
				nil,
				PopBar_Config.VAnchor
			};
			uidiff = 2;
			varbool = "PopBar_Config.VAnchor";							--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"vanchor"};														--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_HANCHOR", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HANCHOR,
				POPBAR_CONFIG_HANCHOR_INFO,
				nil,
				PopBar_Config.HAnchor
			};
			uidiff = 2;
			varbool = "PopBar_Config.HAnchor";							--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"hanchor"};														--The sub slash command and any aliases for this option
		} );
		if (Chronos) then
			MCom.registerSmart( {
				uioption = {
					"COS_POPBAR_POPTIME", -- CVAr
					"SLIDER",
					POPBAR_CONFIG_POPTIME,
					POPBAR_CONFIG_POPTIME_INFO,
					nil,
					0,
					PopBar_Config.PopTime,
					0,
					POPBAR_MAX_POPTIME,
					POPBAR_CONFIG_POPTIME_NAME,
					0.1,
					1,
					POPBAR_CONFIG_POPTIME_SUFFIX,
					1
				};
				uidiff = 2;
				varnum = "PopBar_Config.PopTime";								--The boolean variable associate with this option
				update = function () PopBar_Update(true); end;
				supercom = "/pb";																--The main(super) slash command associated with this subommand
				subcom = {"poptime"};														--The sub slash command and any aliases for this option
			} );
		end
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_KNOBALPHA", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_KNOBALPHA,
				POPBAR_CONFIG_KNOBALPHA_INFO,
				PopBar_SetKnobAlpha,
				0,
				nil,
				0,
				1,
				POPBAR_CONFIG_KNOBALPHA_NAME,
				0.01,
				1,
				POPBAR_CONFIG_KNOBALPHA_SUFFIX,
				100
			};
			uidiff = 1;
			varnum = "PopBar_Config.KnobAlpha";							--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"knobalpha"};													--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_BARALPHA", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_BARALPHA,
				POPBAR_CONFIG_BARALPHA_INFO,
				nil,
				0,
				PopBar_Config.BarAlpha,
				0,
				1,
				POPBAR_CONFIG_BARALPHA_NAME,
				0.01,
				1,
				POPBAR_CONFIG_BARALPHA_SUFFIX,
				100
			};
			uidiff = 1;
			varnum = "PopBar_Config.BarAlpha";							--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"alpha"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_ROWS", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_ROWS,
				POPBAR_CONFIG_ROWS_INFO,
				nil,
				0,
				PopBar_Config.Rows,
				1,
				POPBAR_MAX_ROWS,
				POPBAR_CONFIG_ROWS_NAME,
				1,
				1,
				POPBAR_CONFIG_ROWS_SUFFIX,
				1
			};
			uidiff = 1;
			varnum = "PopBar_Config.Rows";								--The boolean variable associate with this option
			update = function () PopBar_SetRows(nil, MCom.getStringVar("PopBar_Config.Rows")); end;
			supercom = "/pb";															--The main(super) slash command associated with this subommand
			subcom = {"rows"};														--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_COLS", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_COLS,
				POPBAR_CONFIG_COLS_INFO,
				nil,
				0,
				PopBar_Config.Cols,
				1,
				POPBAR_MAX_COLS,
				POPBAR_CONFIG_COLS_NAME,
				1,
				1,
				POPBAR_CONFIG_COLS_SUFFIX,
				1
			};
			uidiff = 1;
			varnum = "PopBar_Config.Cols";								--The boolean variable associate with this option
			update = function () PopBar_SetCols(nil, MCom.getStringVar("PopBar_Config.Cols")); end;
			supercom = "/pb";															--The main(super) slash command associated with this subommand
			subcom = {"cols"};														--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_ROWSHOW", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_ROWSHOW,
				POPBAR_CONFIG_ROWSHOW_INFO,
				nil,
				0,
				PopBar_Config.RowShow,
				0,
				POPBAR_MAX_ROWS,
				POPBAR_CONFIG_ROWSHOW_NAME,
				1,
				1,
				POPBAR_CONFIG_ROWSHOW_SUFFIX,
				1
			};
			uidiff = 1;
			varnum = "PopBar_Config.RowShow";								--The boolean variable associate with this option
			update = function () PopBar_SetRowShow(nil, MCom.getStringVar("PopBar_Config.RowShow")); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"srows"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_COLSHOW", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_COLSHOW,
				POPBAR_CONFIG_COLSHOW_INFO,
				nil,
				0,
				PopBar_Config.ColShow,
				0,
				POPBAR_MAX_COLS,
				POPBAR_CONFIG_COLSHOW_NAME,
				1,
				1,
				POPBAR_CONFIG_COLSHOW_SUFFIX,
				1
			};
			uidiff = 1;
			varnum = "PopBar_Config.ColShow";								--The boolean variable associate with this option
			update = function () PopBar_SetColShow(nil, MCom.getStringVar("PopBar_Config.ColShow")); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"scols"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_IDUP", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_IDUP,
				POPBAR_CONFIG_IDUP_INFO,
				nil,
				PopBar_Config.IDUp
			};
			uidiff = 3;
			varbool = "PopBar_Config.IDUp";									--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"idup"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_FLIPH", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_FLIPH,
				POPBAR_CONFIG_FLIPH_INFO,
				nil,
				PopBar_Config.FlipH
			};
			uidiff = 3;
			varbool = "PopBar_Config.FlipH";								--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"fliph"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_FLIPV", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_FLIPV,
				POPBAR_CONFIG_FLIPV_INFO,
				nil,
				PopBar_Config.FlipV
			};
			uidiff = 3;
			varbool = "PopBar_Config.FlipV";								--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"flipv"};															--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_STARTPAGE", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_STARTPAGE,
				POPBAR_CONFIG_STARTPAGE_INFO,
				nil,
				0,
				PopBar_Config.StartPage,
				1,
				POPBAR_MAX_BARS,
				POPBAR_CONFIG_STARTPAGE_NAME,
				1,
				1,
				POPBAR_CONFIG_STARTPAGE_SUFFIX,
				1
			};
			uidiff = 3;
			varnum = "PopBar_Config.StartPage";							--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"startpage"};													--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_STARTBUTTON", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_STARTBUTTON,
				POPBAR_CONFIG_STARTBUTTON_INFO,
				nil,
				0,
				PopBar_Config.StartButton,
				1,
				12,
				POPBAR_CONFIG_STARTBUTTON_NAME,
				1,
				1,
				POPBAR_CONFIG_STARTBUTTON_SUFFIX,
				1
			};
			uidiff = 3;
			varnum = "PopBar_Config.StartButton";						--The boolean variable associate with this option
			update = function () PopBar_Update(true); end;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"startbutton"};												--The sub slash command and any aliases for this option
		} );
		MCom.registerSmart( {
			uioption = {
				"COS_POPBAR_RESET", -- CVAr
				"BUTTON",
				POPBAR_CONFIG_RESET,
				POPBAR_CONFIG_RESET_INFO,
				PopBar_ResetPos,
				0,
				0,
				0,
				0,
				POPBAR_CONFIG_RESET_NAME
			};
			uidiff = 2;
			supercom = "/pb";																--The main(super) slash command associated with this subommand
			subcom = {"reset"};															--The sub slash command and any aliases for this option
		} );

		PopBar_Config.Cols=1;
		PopBar_Config.Rows=1;
		PopBar_Initialized = 1;
	end
end

function PopBar_CosVarsLoaded()
	PopBar_Loaded = true;

	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "PopBar_Config";
		nonUIList = {};
	});
	PopBar_Show(PopBar_Config.Enabled);
	PopBar_Update(true);
end