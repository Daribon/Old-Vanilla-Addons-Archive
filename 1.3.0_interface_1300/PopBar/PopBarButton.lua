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
PopBar_Config = { };
PopBar_Config.Enabled=1;
PopBar_Config.HideEmpty=0;
PopBar_Config.Rows=2;
PopBar_Config.Cols=12;
PopBar_Config.VAnchor=0;
PopBar_Config.HAnchor=0;
PopBar_Config.IDUp=0;
PopBar_Config.StartPage=6;
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
PopBar_StartID=72;
PopBar_Initialized=0;
PopBar_Hovering=false;
PopBar_Toggled=false;
PopBar_LastUpdate=0;
PopBar_AnchorUpdated=false;
PopBar_RowLimit=6;
PopBar_ColLimit=12;
PopBar_Loaded=false;
PopBar_ChatHandlers={};

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

function PopBar_SetKnobAlpha(checked, amount)
	if (amount) then
		if (amount > 1) then
			amount = 1;
		end
		if (amount < 0) then
			amount = 0;
		end
		if (PopBar_Config.KnobAlpha ~= amount) then
			PopBar_Config.KnobAlpha = amount;
		end
	end
end

function PopBar_SetBarAlpha(checked, amount)
	if (amount) then
		if (amount > 1) then
			amount = 1;
		end
		if (amount < 0) then
			amount = 0;
		end
		if (PopBar_Config.BarAlpha ~= amount) then
			PopBar_Config.BarAlpha = amount;
		end
	end
end

function PopBar_SetHideKeys(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.HideKeys == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked==1)) then
		if (PopBar_Config.HideKeys ~= 1) then
			PopBar_Config.HideKeys=1;
			PopBar_Update(true);
		end
	else
		if (PopBar_Config.HideKeys ~= 0) then
			PopBar_Config.HideKeys=0;
			PopBar_Update(true);
		end
	end
end

function PopBar_SetHideKeyMod(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.HideKeyMod == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked==1)) then
		if (PopBar_Config.HideKeyMod ~= 1) then
			PopBar_Config.HideKeyMod=1;
			PopBar_Update(true);
		end
	else
		if (PopBar_Config.HideKeyMod ~= 0) then
			PopBar_Config.HideKeyMod=0;
			PopBar_Update(true);
		end
	end
end

function PopBar_SetHideEmpty(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.HideEmpty == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked==1)) then
		if (PopBar_Config.HideEmpty ~= 1) then
			PopBar_Config.HideEmpty=1;
			PopBar_Update();
		end
	else
		if (PopBar_Config.HideEmpty ~= 0) then
			PopBar_Config.HideEmpty=0;
			PopBar_Update();
		end
	end
end

function PopBar_SetTurnPages(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.TurnPages == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked==1)) then
		if (PopBar_Config.TurnPages ~= 1) then
			PopBar_Config.TurnPages=1;
			PopBar_Update();
		end
	else
		if (PopBar_Config.TurnPages ~= 0) then
			PopBar_Config.TurnPages=0;
			PopBar_Update();
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
			--[[if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_COLS", CSM_SLIDERMAX, PopBar_ColLimit);
			end
			if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_COLSHOW", CSM_SLIDERMAX, PopBar_ColLimit);
			end]]
			
			if (PopBar_Loaded) then
				if (PopBar_Config.Cols > PopBar_ColLimit) then
					PopBar_SetCols(0,PopBar_ColLimit);
				end
				if (PopBar_Config.ColShow > PopBar_ColLimit) then
					PopBar_SetColShow(0,PopBar_ColLimit);
				end
				PopBar_Update(true);
				if(Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue("COS_POPBAR_ROWS", CSM_SLIDERVALUE, PopBar_Config.Rows);
				end
			end
		end
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
			--[[if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_ROWS", CSM_SLIDERMAX, PopBar_RowLimit);
			end
			if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_ROWSHOW", CSM_SLIDERMAX, PopBar_RowLimit);
			end]]
			if (PopBar_Loaded) then
				if (PopBar_Config.Rows > PopBar_RowLimit) then
					PopBar_SetRows(0,PopBar_RowLimit);
				end
				if (PopBar_Config.RowShow > PopBar_RowLimit) then
					PopBar_SetRowShow(0,PopBar_RowLimit);
				end
				PopBar_Update(true);
				if(Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue("COS_POPBAR_COLS", CSM_SLIDERVALUE, PopBar_Config.Cols);
				end
			end
		end
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
		if (PopBar_Config.RowShow ~= count) then
			if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_ROWSHOW", CSM_SLIDERVALUE, newCount);
			end
		end
		if (PopBar_Config.RowShow ~= newCount) then
			PopBar_Config.RowShow = newCount;
			PopBar_Update();
		end
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
		if (PopBar_Config.ColShow ~= count) then
			if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_COLSHOW", CSM_SLIDERVALUE, newCount);
			end
		end
		if (PopBar_Config.ColShow ~= newCount) then
			PopBar_Config.ColShow = newCount;
			PopBar_Update();
		end
	end
end

function PopBar_SetOrient(orient)
	if (orient == 1) then
		orient = 1;
	else
		orient = 0;
	end
	if (PopBar_Config.Orient ~= orient) then
		PopBar_Config.Orient = orient;
		PopBar_Update(true);
	end
end

function PopBar_SetVAnchor(anchor)
	if (anchor == "TOP") then
		anchor = 1;
	end
	if (anchor == "BOTTOM") then
		anchor = 0;
	end
	
	if ((anchor == 1) or (anchor == 0)) then
		if (PopBar_Config.VAnchor ~= anchor) then
			PopBar_Config.VAnchor = anchor;
			PopBar_AnchorUpdated=false;
			PopBar_Update(true);
		end
	end	
end

function PopBar_SetHAnchor(anchor)
	if (anchor == "RIGHT") then
		anchor = 1;
	end
	if (anchor == "LEFT") then
		anchor = 0;
	end
	
	if ((anchor == 1) or (anchor == 0)) then
		if (PopBar_Config.HAnchor ~= anchor) then
			PopBar_Config.HAnchor = anchor;
			PopBar_AnchorUpdated=false;
			PopBar_Update(true);
		end
	end	
end

function PopBar_SetInArea(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.InArea == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked == 1)) then
		PopBar_Config.InArea = 1;
	else
		PopBar_Config.InArea = 0;
	end
end

function PopBar_SetIDUp(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.SetIDUP == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked==1)) then
		if (PopBar_Config.IDUp ~= 1) then
			PopBar_Config.IDUp=1;
			PopBar_Update(true);
		end
	else
		if (PopBar_Config.IDUp ~= 0) then
			PopBar_Config.IDUp=0;
			PopBar_Update(true);
		end
	end
end

function PopBar_SetFlipH(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.FlipH == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked==1)) then
		if (PopBar_Config.FlipH ~= 1) then
			PopBar_Config.FlipH=1;
			PopBar_Update(true);
		end
	else
		if (PopBar_Config.FlipH ~= 0) then
			PopBar_Config.FlipH=0;
			PopBar_Update(true);
		end
	end
end

function PopBar_SetFlipV(checked)
	if (checked and (checked == -1)) then
		if (PopBar_Config.FlipV == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked==1)) then
		if (PopBar_Config.FlipV ~= 1) then
			PopBar_Config.FlipV=1;
			PopBar_Update(true);
		end
	else
		if (PopBar_Config.FlipV ~= 0) then
			PopBar_Config.FlipV=0;
			PopBar_Update(true);
		end
	end
end

function PopBar_SetStartPage(checked, count)
	if (count) then
		if (count > POPBAR_MAX_BARS) then
			count = POPBAR_MAX_BARS;
		end
		if (count < 1) then
			count = 1;
		end
		if (PopBar_Config.StartPage ~= count) then
			PopBar_Config.StartPage = count;
			PopBar_Update(true);
			if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_STARTPAGE", CSM_SLIDERVALUE, PopBar_Config.StartPage);
			end
		end
	end
end

function PopBar_SetStartButton(checked, count)
	if (count) then
		if (count > 12) then
			count = 12;
		end
		if (count < 1) then
			count = 1;
		end
		if (PopBar_Config.StartButton ~= count) then
			PopBar_Config.StartButton = count;
			PopBar_Update(true);
			if(Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_POPBAR_STARTBUTTON", CSM_SLIDERVALUE, PopBar_Config.StartButton);
			end
		end
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
		if (not PopBar_Hovering) then
			PopBar_Hovering = true;
			PopBar_Update();
		end
	elseif (PopBar_Hovering) then
		PopBar_Hovering = false;
		PopBar_Update();
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
			MacroFrame_EditMacro();
			
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
				local keyText = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
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
	if ( event == "VARIABLES_LOADED" ) then
		if(Cosmos_RegisterConfiguration == nil) then
			PopBar_Show(PopBar_Config.Enabled);
			PopBar_Save();
		end
		return;
	end
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

function PopBar_Save()
	RegisterForSave("PopBar_Config");
end

function PopBar_OnLoad()
	if( PopBar_Initialized == 0) then
		if(not (Cosmos_RegisterConfiguration == nil)) then
			Cosmos_RegisterVarsLoaded(PopBar_CosVarsLoaded);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR",
				"SECTION",
				POPBAR_CONFIG_HEADER,
				POPBAR_CONFIG_HEADER_INFO
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_TOGGLE", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_ONOFF,
				POPBAR_CONFIG_ONOFF_INFO,
				PopBar_Show,
				PopBar_Config.Enabled
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_PAGES", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_PAGES,
				POPBAR_CONFIG_PAGES_INFO,
				PopBar_SetTurnPages,
				PopBar_Config.TurnPages
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_HIDEEMPTY", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HIDEEMPTY,
				POPBAR_CONFIG_HIDEEMPTY_INFO,
				PopBar_SetHideEmpty,
				PopBar_Config.HideEmpty
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_HIDEKEYS", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HIDEKEYS,
				POPBAR_CONFIG_HIDEKEYS_INFO,
				PopBar_SetHideKeys,
				PopBar_Config.HideKeys
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_HIDEKEYMOD", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HIDEKEYMOD,
				POPBAR_CONFIG_HIDEKEYMOD_INFO,
				PopBar_SetHideKeyMod,
				PopBar_Config.HideKeyMod
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_ORIENT", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_ORIENT,
				POPBAR_CONFIG_ORIENT_INFO,
				PopBar_SetOrient,
				PopBar_Config.Orient
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_AREA", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_AREA,
				POPBAR_CONFIG_AREA_INFO,
				PopBar_SetInArea,
				PopBar_Config.InArea
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_VANCHOR", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_VANCHOR,
				POPBAR_CONFIG_VANCHOR_INFO,
				PopBar_SetVAnchor,
				PopBar_Config.VAnchor
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_HANCHOR", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_HANCHOR,
				POPBAR_CONFIG_HANCHOR_INFO,
				PopBar_SetHAnchor,
				PopBar_Config.HAnchor
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_KNOBALPHA", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_KNOBALPHA,
				POPBAR_CONFIG_KNOBALPHA_INFO,
				PopBar_SetKnobAlpha,
				0,
				PopBar_Config.KnobAlpha,
				0,
				1,
				POPBAR_CONFIG_KNOBALPHA_NAME,
				0.01,
				1,
				POPBAR_CONFIG_KNOBALPHA_SUFFIX,
				100
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_BARALPHA", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_BARALPHA,
				POPBAR_CONFIG_BARALPHA_INFO,
				PopBar_SetBarAlpha,
				0,
				PopBar_Config.BarAlpha,
				0,
				1,
				POPBAR_CONFIG_BARALPHA_NAME,
				0.01,
				1,
				POPBAR_CONFIG_BARALPHA_SUFFIX,
				100
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_ROWS", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_ROWS,
				POPBAR_CONFIG_ROWS_INFO,
				PopBar_SetRows,
				0,
				PopBar_Config.Rows,
				1,
				POPBAR_MAX_ROWS,
				POPBAR_CONFIG_ROWS_NAME,
				1,
				1,
				POPBAR_CONFIG_ROWS_SUFFIX,
				1				
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_COLS", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_COLS,
				POPBAR_CONFIG_COLS_INFO,
				PopBar_SetCols,
				0,
				PopBar_Config.Cols,
				1,
				POPBAR_MAX_COLS,
				POPBAR_CONFIG_COLS_NAME,
				1,
				1,
				POPBAR_CONFIG_COLS_SUFFIX,
				1				
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_ROWSHOW", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_ROWSHOW,
				POPBAR_CONFIG_ROWSHOW_INFO,
				PopBar_SetRowShow,
				0,
				PopBar_Config.RowShow,
				0,
				POPBAR_MAX_ROWS,
				POPBAR_CONFIG_ROWSHOW_NAME,
				1,
				1,
				POPBAR_CONFIG_ROWSHOW_SUFFIX,
				1				
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_COLSHOW", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_COLSHOW,
				POPBAR_CONFIG_COLSHOW_INFO,
				PopBar_SetColShow,
				0,
				PopBar_Config.ColShow,
				0,
				POPBAR_MAX_COLS,
				POPBAR_CONFIG_COLSHOW_NAME,
				1,
				1,
				POPBAR_CONFIG_COLSHOW_SUFFIX,
				1				
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_IDUP", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_IDUP,
				POPBAR_CONFIG_IDUP_INFO,
				PopBar_SetIDUp,
				PopBar_Config.IDUp
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_FLIPH", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_FLIPH,
				POPBAR_CONFIG_FLIPH_INFO,
				PopBar_SetFlipH,
				PopBar_Config.FlipH
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_FLIPV", -- CVAr
				"CHECKBOX",
				POPBAR_CONFIG_FLIPV,
				POPBAR_CONFIG_FLIPV_INFO,
				PopBar_SetFlipV,
				PopBar_Config.FlipV
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_STARTPAGE", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_STARTPAGE,
				POPBAR_CONFIG_STARTPAGE_INFO,
				PopBar_SetStartPage,
				0,
				PopBar_Config.StartPage,
				1,
				POPBAR_MAX_BARS,
				POPBAR_CONFIG_STARTPAGE_NAME,
				1,
				1,
				POPBAR_CONFIG_STARTPAGE_SUFFIX,
				1
				);
			Cosmos_RegisterConfiguration(
				"COS_POPBAR_STARTBUTTON", -- CVAr
				"SLIDER",
				POPBAR_CONFIG_STARTBUTTON,
				POPBAR_CONFIG_STARTBUTTON_INFO,
				PopBar_SetStartButton,
				0,
				PopBar_Config.StartButton,
				1,
				12,
				POPBAR_CONFIG_STARTBUTTON_NAME,
				1,
				1,
				POPBAR_CONFIG_STARTBUTTON_SUFFIX,
				1				
				);
			Cosmos_RegisterConfiguration(
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
				);
				
			PopBar_Config.Cols=1;
			PopBar_Config.Rows=1;
				
			if ( Cosmos_RegisterChatCommand ) then
				local PopBarCommands = {"/popbar","/pb"};				
				Cosmos_RegisterChatCommand (
					"POPBAR_COMMANDS", -- Some Unique Group ID
					PopBarCommands, -- The Commands
					PopBar_ChatCommandHandler,
					POPBAR_CHAT_COMMAND_INFO -- Description String
				);				
			end
		else
			SlashCmdList["POPBARSLASH"] = PopBar_ChatCommandHandler;
			SLASH_POPBARSLASH1 = "/popbar";
			SLASH_POPBARSLASH2 = "/pb";
			PopBar_Loaded = true;
		end
		PopBar_Initialized = 1;
	end
end

function PopBar_CosVarsLoaded()
	PopBar_Loaded = true;
end

-- PopBar command handler
function PopBar_ChatCommandHandler(msg)
	if (msg) then
		msg = string.lower(msg);
		local command, setStr = unpack(Sea.string.split(msg, " "));
		if ((not command) and msg) then
			command = msg;
		end
		if (command) then
			for curCommand in PopBar_ChatHandlers do
				if (command == curCommand) then
					if (setStr) then
						PopBar_ChatHandlers[curCommand](setStr);
					else
						PopBar_ChatHandlers[curCommand]();
					end
					return;
				end
			end
		end
	end
	for i = 1, getn(POPBAR_CHAT_COMMAND_HELP) do
		Sea.io.printc(ChatTypeInfo["SYSTEM"], POPBAR_CHAT_COMMAND_HELP[i]);
	end	
end

-- PopBar command handler
function PopBar_Enable_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_Show(1);
		elseif (string.find(msg, "OFF")) then
			PopBar_Show(0);		
		end
	else
		PopBar_Show(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_TOGGLE", CSM_CHECKONOFF, PopBar_Config.Enabled);
	end
end
PopBar_ChatHandlers["enable"] = PopBar_Enable_ChatCommandHandler;

-- PopBar command handler
function PopBar_Pages_ChatCommandHandler(msg)
	-- Toggle appropriately
	if (msg) then
		msg = string.upper(msg);
		if (string.find(msg, "ON")) then
			PopBar_SetTurnPages(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetTurnPages(0);
			end
		end
	else
		PopBar_SetTurnPages(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_PAGES", CSM_CHECKONOFF, PopBar_Config.TurnPages);
	end
end
PopBar_ChatHandlers["pages"] = PopBar_Pages_ChatCommandHandler;

-- PopBar command handler
function PopBar_HideEmpty_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_SetHideEmpty(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetHideEmpty(0);
			end
		end
	else
		PopBar_SetHideEmpty(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_HIDEEMPTY", CSM_CHECKONOFF, PopBar_Config.HideEmpty);
	end
end
PopBar_ChatHandlers["hideempty"] = PopBar_HideEmpty_ChatCommandHandler;

-- PopBar command handler
function PopBar_HideKeys_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);	
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_SetHideKeys(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetHideKeys(0);
			end
		end
	else
		PopBar_SetHideKeys(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_HIDEKEYS", CSM_CHECKONOFF, PopBar_Config.HideKeys);
	end
end
PopBar_ChatHandlers["hidekeys"] = PopBar_HideKeys_ChatCommandHandler;

-- PopBar command handler
function PopBar_HideKeyMod_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);	
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_SetHideKeyMod(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetHideKeyMod(0);
			end
		end
	else
		PopBar_SetHideKeyMod(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_HIDEKEYMOD", CSM_CHECKONOFF, PopBar_Config.HideKeyMod);
	end
end
PopBar_ChatHandlers["hidekeymod"] = PopBar_HideKeyMod_ChatCommandHandler;

-- PopBar command handler
function PopBar_Alpha_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetKnobAlpha(0,msg+0);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_KNOBALPHA", CSM_SLIDERVALUE, PopBar_Config.KnobAlpha);
	end
end
PopBar_ChatHandlers["knobalpha"] = PopBar_Alpha_ChatCommandHandler;

-- PopBar command handler
function PopBar_BarAlpha_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetBarAlpha(0,msg+0);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_BARALPHA", CSM_SLIDERVALUE, PopBar_Config.BarAlpha);
	end
end
PopBar_ChatHandlers["alpha"] = PopBar_BarAlpha_ChatCommandHandler;

-- PopBar command handler
function PopBar_Rows_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetRows(0,msg+0);
	end
end
PopBar_ChatHandlers["rows"] = PopBar_Rows_ChatCommandHandler;

-- PopBar command handler
function PopBar_Cols_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetCols(0,msg+0);
	end
end
PopBar_ChatHandlers["cols"] = PopBar_Cols_ChatCommandHandler;


-- PopBar command handler
function PopBar_VAnchor_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);
		PopBar_SetVAnchor(msg);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_VANCHOR", CSM_CHECKONOFF, PopBar_Config.VAnchor);
	end
end
PopBar_ChatHandlers["vanchor"] = PopBar_VAnchor_ChatCommandHandler;

-- PopBar command handler
function PopBar_HAnchor_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);
		PopBar_SetHAnchor(msg);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_HANCHOR", CSM_CHECKONOFF, PopBar_Config.HAnchor);
	end
end
PopBar_ChatHandlers["hanchor"] = PopBar_HAnchor_ChatCommandHandler;

-- PopBar command handler
function PopBar_SRow_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetRowShow(0,msg+0);
	end
end
PopBar_ChatHandlers["srows"] = PopBar_SRow_ChatCommandHandler;
PopBar_ChatHandlers["showrows"] = PopBar_SRow_ChatCommandHandler;

-- PopBar command handler
function PopBar_SCol_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetColShow(0,msg+0);
	end
end
PopBar_ChatHandlers["scols"] = PopBar_SCol_ChatCommandHandler;
PopBar_ChatHandlers["showcols"] = PopBar_SCol_ChatCommandHandler;

-- PopBar command handler
function PopBar_Orient_ChatCommandHandler(msg)	
	if (msg) then
		msg = string.upper(msg);
		if (msg == "H") then
			PopBar_SetOrient(1);
		else
			PopBar_SetOrient(0);
		end
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_ORIENT", CSM_CHECKONOFF, PopBar_Config.Orient);
	end
end
PopBar_ChatHandlers["orient"] = PopBar_Orient_ChatCommandHandler;

-- PopBar command handler
function PopBar_Area_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);	
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_SetInArea(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetInArea(0);
			end
		end
	else
		PopBar_SetInArea(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_AREA", CSM_CHECKONOFF, PopBar_Config.InArea);
	end
end
PopBar_ChatHandlers["area"] = PopBar_Area_ChatCommandHandler;

-- PopBar command handler
function PopBar_IDUp_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);	
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_SetIDUp(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetIDUp(0);
			end
		end
	else
		PopBar_SetIDUp(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_IDUP", CSM_CHECKONOFF, PopBar_Config.IDUp);
	end
end
PopBar_ChatHandlers["idup"] = PopBar_IDUp_ChatCommandHandler;

-- PopBar command handler
function PopBar_FlipH_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);	
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_SetFlipH(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetFlipH(0);
			end
		end
	else
		PopBar_SetFlipH(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_FLIPH", CSM_CHECKONOFF, PopBar_Config.FlipH);
	end
end
PopBar_ChatHandlers["fliph"] = PopBar_FlipH_ChatCommandHandler;

-- PopBar command handler
function PopBar_FlipV_ChatCommandHandler(msg)
	if (msg) then
		msg = string.upper(msg);	
		-- Toggle appropriately
		if (string.find(msg, "ON")) then
			PopBar_SetFlipV(1);
		else
			if (string.find(msg, "OFF")) then
				PopBar_SetFlipV(0);
			end
		end
	else
		PopBar_SetFlipV(-1);
	end
	
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_POPBAR_FLIPV", CSM_CHECKONOFF, PopBar_Config.FlipV);
	end
end
PopBar_ChatHandlers["flipv"] = PopBar_FlipV_ChatCommandHandler;

-- PopBar command handler
function PopBar_StartPage_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetStartPage(0,msg+0);
	end
end
PopBar_ChatHandlers["startpage"] = PopBar_StartPage_ChatCommandHandler;

-- PopBar command handler
function PopBar_StartButton_ChatCommandHandler(msg)
	if (msg) then
		PopBar_SetStartButton(0,msg+0);
	end
end
PopBar_ChatHandlers["startbut"] = PopBar_StartButton_ChatCommandHandler;

-- PopBar command handler
function PopBar_Reset_ChatCommandHandler(msg)	
	PopBar_ResetPos();
end
PopBar_ChatHandlers["reset"] = PopBar_Reset_ChatCommandHandler;