function DAB_Bar_Hide(bar)
	if (not getglobal("DAB_ActionBar_"..bar)) then
		DAB_Debug("Attempted to hide a bar that doesn't exist: "..bar);
		return;
	end
	if (not getglobal("DAB_ActionBar_"..bar):IsVisible()) then
		return;
	end
	DAB_Settings[DAB_INDEX].Bar[bar].hide = true;
	DAB_Bar_SetLayout(bar);
end

function DAB_Bar_Initialize(bar)
	local settings = DAB_Settings[DAB_INDEX].Bar[bar];
	local barname = "DAB_ActionBar_"..bar;
	local barframe = getglobal(barname);

	if (settings.attachframe) then
		barframe:ClearAllPoints();
		barframe:SetPoint(settings.attachpoint, settings.attachframe, settings.attachto, settings.attachoffsetx, settings.attachoffsety);
	else
		barframe:ClearAllPoints();
		barframe:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", DAB_Settings[DAB_INDEX].FrameLocation[barname].x, DAB_Settings[DAB_INDEX].FrameLocation[barname].y);
	end

	local background = getglobal(barname);
	local bgtexture = "Interface\\AddOns\\DiscordActionBars\\PlainBackdrop";
	if (settings.background.texture) then
		bgtexture = "Interface\\AddOns\\DiscordActionBars\\" .. settings.background.texture;
	end
	if (settings.background.style == 1) then
		local bordertexture = "Interface\\AddOns\\DiscordActionBars\\PlainBackdrop";
		if (settings.background.bordertexture) then
			bordertexture = "Interface\\AddOns\\DiscordActionBars\\" .. settings.background.bordertexture;
		end
		background:SetBackdrop({bgFile = bgtexture, edgeFile = bordertexture, tile = false, tileSize = 1, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 }});
	elseif (settings.background.style == 2) then
		background:SetBackdrop({bgFile = bgtexture, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }});
	elseif (settings.background.style == 3) then
		background:SetBackdrop({bgFile = bgtexture, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, insets = { left = 11, right = 12, top = 12, bottom = 11 }});
	end
	background:SetBackdropColor(settings.background.color.r, settings.background.color.g, settings.background.color.b, settings.background.alpha);
	background:SetBackdropBorderColor(settings.background.bordercolor.r, settings.background.bordercolor.g, settings.background.bordercolor.b, settings.background.borderalpha);

	local borderoffset = 12 / 36 * settings.size + settings.buttonborderpadding;
	local scale = settings.size / 36 * UIParent:GetScale();
	local cooldownscale = settings.size / 36 * .85;
	if (DAB_Settings[DAB_INDEX].ModifyCooldownByUIScale) then
		cooldownscale = cooldownscale * UIParent:GetScale();
	end
	for button=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[button] == bar) then
			getglobal("DAB_ActionButton_"..button.."TextFrameCooldownCount"):SetTextHeight(settings.ccfontsize);
			getglobal("DAB_ActionButton_"..button).scale = scale;
			getglobal("DAB_ActionButton_"..button.."TextFrame"):SetScale(scale + 1);
			getglobal("DAB_ActionButton_"..button.."TextFrame"):SetScale(scale);
			getglobal("DAB_ActionButton_"..button):SetHeight(settings.size);
			getglobal("DAB_ActionButton_"..button):SetWidth(settings.size);
			getglobal("DAB_ActionButton_"..button):SetAlpha(settings.alpha);
			getglobal("DAB_ActionButton_"..button.."Cooldown"):SetScale(cooldownscale);
			getglobal("DAB_ActionButton_"..button.."Cooldown").cdscale = cooldownscale;
			getglobal("DAB_ActionButton_"..button.."Border"):ClearAllPoints();
			getglobal("DAB_ActionButton_"..button.."Border"):SetPoint("TOPLEFT", "DAB_ActionButton_"..button, "TOPLEFT", -borderoffset, borderoffset);
			getglobal("DAB_ActionButton_"..button.."Border"):SetPoint("BOTTOMRIGHT", "DAB_ActionButton_"..button, "BOTTOMRIGHT", borderoffset + 1, -borderoffset - 1);
			getglobal("DAB_ActionButton_"..button.."Border"):SetVertexColor(settings.buttonbordercolor.r, settings.buttonbordercolor.g, settings.buttonbordercolor.b);
			getglobal("DAB_ActionButton_"..button.."Border"):SetAlpha(settings.buttonborderalpha);
		end
	end

	local label = barname.."_Label";
	getglobal(label):ClearAllPoints();
	getglobal(label):SetPoint(settings.label.attachpoint, barname, settings.label.attachto, settings.label.attachoffsetx, settings.label.attachoffsety);
	getglobal(label.."_Text"):SetText(settings.label.text);
	getglobal(label.."_Text"):SetTextHeight(settings.label.textsize);
	getglobal(label):SetScale(getglobal(label):GetScale() + 1);
	getglobal(label):SetScale(getglobal(label):GetScale() - 1);
	getglobal("DAB_Bar_Button"..bar):SetText("["..bar.."] "..settings.label.text);
	getglobal(label.."_Text"):SetTextColor(settings.label.color.r, settings.label.color.g, settings.label.color.b, settings.label.alpha);
	getglobal(label):SetWidth(getglobal(label.."_Text"):GetWidth() + 10);
	getglobal(label):SetHeight(getglobal(label.."_Text"):GetHeight() + 10);
	getglobal(label.."_Background"):SetAlpha(settings.label.bgalpha);
	getglobal(label.."_Background"):SetVertexColor(settings.label.bgcolor.r, settings.label.bgcolor.g, settings.label.bgcolor.b);
	for _,border in DAB_BORDERS do
		getglobal(label..border):SetAlpha(settings.label.borderalpha);
		getglobal(label..border):SetVertexColor(settings.label.bordercolor.r, settings.label.bordercolor.g, settings.label.bordercolor.b);
	end

	if (settings.hidelabel) then
		getglobal(label):Hide();
	else
		getglobal(label):Show();
	end

	barframe:UnregisterEvent("PLAYER_TARGET_CHANGED");
	barframe:UnregisterEvent("PLAYER_ENTER_COMBAT");
	barframe:UnregisterEvent("PLAYER_LEAVE_COMBAT");
	barframe:UnregisterEvent("PLAYER_REGEN_DISABLED");
	barframe:UnregisterEvent("PLAYER_REGEN_ENABLED");

	if (settings.friendlytarget or settings.hostiletarget) then
		barframe:RegisterEvent("PLAYER_TARGET_CHANGED");
	end

	if (settings.incombat or settings.notincombat) then
		barframe:RegisterEvent("PLAYER_ENTER_COMBAT");
		barframe:RegisterEvent("PLAYER_LEAVE_COMBAT");
		barframe:RegisterEvent("PLAYER_REGEN_DISABLED");
		barframe:RegisterEvent("PLAYER_REGEN_ENABLED");
	end

	DAB_Bar_SetLayout(bar);

	if (settings.mouseoverbar or settings.controlbox.mouseovershowbar) then
		getglobal("DAB_MouseoverBar_"..bar):Show();
		DAB_Bar_Hide(bar);
	elseif (not settings.mouseoverbar) then
		getglobal("DAB_MouseoverBar_"..bar):Hide();
	end

	if (bar == DAB_Settings[DAB_INDEX].GhostBar) then
		DAB_Bar_Hide(bar);
	end
end

function DAB_Bar_OnDragStart(label)
	if (label) then
		this:GetParent().moving = true;
		this:GetParent():StartMoving();
	elseif (DAB_DRAGGING_UNLOCKED or IsControlKeyDown()) then
		this.moving = true;
		this:StartMoving();
	end
end

function DAB_Bar_OnDragStop(label)
	if (label) then
		this:GetParent().moving = nil;
		this:GetParent():StopMovingOrSizing();
		DAB_Update_FrameLocation(this:GetParent():GetName());
	elseif (this.moving) then
		this.moving = nil;
		this:StopMovingOrSizing();
		DAB_Update_FrameLocation(this:GetName());
	end
end

function DAB_Bar_OnEnter(bar)
	if (bar < 11) then
		getglobal("DAB_ActionBar_"..bar).timer = nil;
		if (DAB_Settings[DAB_INDEX].Bar[bar].mouseoverbar) then
			DAB_Bar_Show(bar);
		end
	else
		local barindex = DAB_Get_OtherBar(bar);
		getglobal("DAB_OtherBar_"..barindex).timer = nil;
		if (DAB_Settings[DAB_INDEX].OtherBar[bar].mouseoverbar) then
			DAB_OtherBar_Show(bar);
		end
	end
end

function DAB_Bar_OnEvent(event)
	if (event == "PLAYER_TARGET_CHANGED") then
		if (DAB_IsInContext(
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].friendlytarget,
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].hostiletarget,
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].incombat,
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].notincombat,
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].form,
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].onetrue)) then
			DAB_Bar_Show(this:GetID());
		else
			DAB_Bar_Hide(this:GetID());
		end
	elseif (event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
		if (DAB_IsInContext(DAB_Settings[DAB_INDEX].Bar[this:GetID()].friendlytarget, 
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].hostiletarget, 
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].incombat, 
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].notincombat, 
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].form,
			DAB_Settings[DAB_INDEX].Bar[this:GetID()].onetrue)) then
			DAB_Bar_Show(this:GetID());
		else
			DAB_Bar_Hide(this:GetID());
		end
	elseif (event == "UNIT_PET") then
		if (UnitName("pet") and UnitExists("pet")) then
			if (not DAB_Settings[DAB_INDEX].OtherBar[11].hide) then
				DAB_OtherBar_Show(11);
			end
		else
			DAB_OtherBar_Hide(11);
		end
	end
end

function DAB_Bar_OnHide()
	if (not DAB_INITIALIZED) then return; end
	local showit;
	local bar = this:GetID();
	if (bar < 11) then
		showit = DAB_Settings[DAB_INDEX].Bar[this:GetID()].mouseoverbar;
		getglobal("DAB_ActionBar_"..bar).timer = nil;
	else
		showit = DAB_Settings[DAB_INDEX].OtherBar[this:GetID()].mouseoverbar;
		local barindex = DAB_Get_OtherBar(bar);
		getglobal("DAB_OtherBar_"..barindex).timer = nil;
	end
	if (showit) then
		getglobal("DAB_MouseoverBar_"..this:GetID()):Show();		
	end
end

function DAB_Bar_OnLeave(bar)
	if (bar < 11) then
		if (DAB_Settings[DAB_INDEX].Bar[bar].mouseoverbar or DAB_Settings[DAB_INDEX].Bar[bar].controlbox.mouseovershowbar) then
			getglobal("DAB_ActionBar_"..bar).timer = .1;
		end
	else
		if (DAB_Settings[DAB_INDEX].OtherBar[bar].mouseoverbar) then
			local barindex = DAB_Get_OtherBar(bar);
			getglobal("DAB_OtherBar_"..barindex).timer = .1;
		end
	end
end

function DAB_Bar_OnShow()
	if (not DAB_INITIALIZED) then return; end
	getglobal("DAB_MouseoverBar_"..this:GetID()):Hide();
	if (this:GetID() < 11) then
		getglobal("DAB_ActionBar_"..this:GetID()).timer = nil;
	else
		local barindex = DAB_Get_OtherBar(this:GetID());
		getglobal("DAB_OtherBar_"..barindex).timer = nil;
	end
end

function DAB_Bar_OnUpdate(elapsed)
	local bar = this:GetID();
	if (this.timer) then
		this.timer = this.timer - elapsed;
		if (this.timer < 0) then
			this.timer = nil;
			if (bar < 11) then
				DAB_Bar_Hide(bar);
			else
				DAB_OtherBar_Hide(bar);
			end
		end
	else
		if (bar < 11) then
			if (DAB_Settings[DAB_INDEX].Bar[bar].controlbox.mouseovershowbar) then
				if (not this.timer) then
					if (not DAB_Check_Mouseover(this)) then
						if (not DAB_Check_Mouseover(getglobal("DAB_ControlBox_"..bar))) then
							this.timer = DAB_Settings[DAB_INDEX].Timeout;
						end
					end
				end
			elseif (DAB_Settings[DAB_INDEX].Bar[bar].mouseoverbar) then
				if (not DAB_Check_Mouseover(this)) then
					DAB_Bar_Hide(bar);
				end
			end
		else
			if (DAB_Settings[DAB_INDEX].OtherBar[bar].mouseoverbar and (not DAB_Check_Mouseover(this))) then
				DAB_OtherBar_Hide(bar);
			end
		end
	end
end

function DAB_Bar_SetLayout(bar)
	if (not DAB_INITIALIZED) then return; end
	local lastbutton, actionbutton, attachbutton;
	local barname = "DAB_ActionBar_"..bar;
	local barframe = getglobal(barname);
	local settings = DAB_Settings[DAB_INDEX].Bar[bar];
	local barwidth = 10;
	local barheight = math.abs(settings.rows * settings.size + (settings.rows - 1) * settings.spacingv + settings.padding * 2);
	local horizcount = 0;
	if (settings.hide) then
		barframe:Hide();
	else
		barframe:Show();
	end
	for button=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[button] == bar) then
			actionbutton = getglobal("DAB_ActionButton_"..button);
			actionbutton:ClearAllPoints();
			if (settings.hide) then
				actionbutton:Hide();
			else
				actionbutton:Show();
			end
			if ((not HasAction(button)) and (not DAB_SHOWING_EMPTY)) then
				if (settings.hideempty or settings.collapse) then
					actionbutton:Hide();
				end
			end
			if (HasAction(button) or DAB_SHOWING_EMPTY or (not settings.collapse)) then
				if (lastbutton) then
					attachbutton = "DAB_ActionButton_"..lastbutton;
					if (lastbuttonempty) then
						actionbutton:SetPoint("LEFT", attachbutton, "LEFT", settings.spacingh, 0);
					else
						actionbutton:SetPoint("LEFT", attachbutton, "RIGHT", settings.spacingh, 0);
					end
				else
					actionbutton:SetPoint("TOPLEFT", barname, "TOPLEFT", settings.padding, -settings.padding);
				end
				lastbuttonempty = nil;
				horizcount = horizcount + 1;
			else
				if (lastbutton) then
					attachbutton = "DAB_ActionButton_"..lastbutton;
					if (lastbuttonempty) then
						actionbutton:SetPoint("LEFT", attachbutton, "LEFT", 0, 0);
					else
						actionbutton:SetPoint("LEFT", attachbutton, "RIGHT", 0, 0);
					end
				else
					actionbutton:SetPoint("TOPLEFT", barname, "TOPLEFT", settings.padding, -settings.padding);
				end
				lastbuttonempty = true;
			end
			lastbutton = button;
		end
	end

	local highest = horizcount;
	if (settings.rows > 1) then
		local newrow = math.ceil(settings.numbuttons / settings.rows);
		local resetrow = math.mod(settings.numbuttons, settings.rows);
		if (resetrow == 0) then resetrow = 999; end
		highest = 0;
		local count = 0;
		local row = 1;
		local visible = 0;
		local rowstart;
		for button=1,120 do
			if (DAB_Settings[DAB_INDEX].Button[button] == bar) then
				if (not rowstart) then rowstart = button; end
				if (count >= newrow) then
					row = row + 1;
					if (visible > highest) then
						highest = visible;
					end
					visible = 0;
					if (row > resetrow) then
						newrow = newrow - 1;
						resetrow = 999;
					end
					actionbutton = getglobal("DAB_ActionButton_"..button);
					attachbutton = "DAB_ActionButton_"..rowstart;
					actionbutton:ClearAllPoints();
					actionbutton:SetPoint("TOP", attachbutton, "BOTTOM", 0, -settings.spacingv);
					rowstart = button;
					count = 0;
				end

				if (HasAction(button) or DAB_SHOWING_EMPTY or (not settings.collapse)) then
					visible = visible + 1;				
				end
				count = count + 1;
			end
		end
	end
	if (highest == 0) then highest = 1; end
	barwidth = math.abs(highest * settings.size + (highest - 1) * settings.spacingh + settings.padding * 2);
	barframe:SetHeight(barheight);
	barframe:SetWidth(barwidth);
end

function DAB_Bar_Show(bar)
	if (not getglobal("DAB_ActionBar_"..bar)) then
		DAB_Debug("Attempted to show a bar that doesn't exist: "..bar);
		return;
	end
	if (getglobal("DAB_ActionBar_"..bar):IsVisible()) then
		return;
	end
	DAB_Settings[DAB_INDEX].Bar[bar].hide = nil;
	DAB_Bar_SetLayout(bar);
end

function DAB_Bar_Swap(bar1, bar2)
	if (not bar1) then return; end
	if (not bar2) then return; end
	if (not getglobal("DAB_ActionBar_"..bar1)) then
		DAB_Debug("Attempted to swap a bar that doesn't exist: "..bar1);
		return;
	end
	if (not getglobal("DAB_ActionBar_"..bar2)) then
		DAB_Debug("Attempted to swap a bar that doesn't exist: "..bar2);
		return;
	end
	for i=1, 120 do
		if (DAB_Settings[DAB_INDEX].Button[i] == bar1) then
			DAB_Settings[DAB_INDEX].Button[i] = bar2;
		elseif (DAB_Settings[DAB_INDEX].Button[i] == bar2) then
			DAB_Settings[DAB_INDEX].Button[i] = bar1;
		end
	end
	for button = 1, 120 do
		if ( DAB_Settings[DAB_INDEX].Button[button] == bar1 or  DAB_Settings[DAB_INDEX].Button[button] == bar2) then
			getglobal("DAB_ActionButton_"..button.."TextFrameDynamicHotKey"):SetText("");
		end
	end
	local bar1numbuttons = DAB_Settings[DAB_INDEX].Bar[bar1].numbuttons;
	DAB_Settings[DAB_INDEX].Bar[bar1].numbuttons = DAB_Settings[DAB_INDEX].Bar[bar2].numbuttons;
	DAB_Settings[DAB_INDEX].Bar[bar2].numbuttons = bar1numbuttons;
	DAB_Bar_Initialize(bar1);
	DAB_Bar_Initialize(bar2);
	DAB_UpdateKeybindingLabels();
	DAB_UpdateKeybindings();
	DAB_SetKeybindingBar(DAB_Settings[DAB_INDEX].DynamicKeybindingBar);
end

function DAB_Bar_Toggle(bar)
	if (not getglobal("DAB_ActionBar_"..bar)) then
		DAB_Debug("Attempted to toggle a bar that doesn't exist: "..bar);
		return;
	end
	local barframe;
	if (bar < 11) then
		barframe = getglobal("DAB_ActionBar_"..bar);
		if (barframe:IsVisible()) then
			DAB_Bar_Hide(bar);
		else
			DAB_Bar_Show(bar);
		end
	else
		local barindex = DAB_Get_OtherBar(bar);
		barframe = getglobal("DAB_OtherBar_"..barindex);
		if (barframe:IsVisible()) then
			DAB_OtherBar_Hide(bar);
		else
			DAB_OtherBar_Show(bar);
		end
	end
end

function DAB_Bar_UpdateFormBars(currentform)
	local doswap = true;
	if (DAB_Settings[DAB_INDEX].CurrentBarInMainBar and currentform == 0) then
		DAB_Bar_Swap(DAB_Settings[DAB_INDEX].MainBar, DAB_Settings[DAB_INDEX].CurrentBarInMainBar);
		doswap = nil;
		DAB_Settings[DAB_INDEX].CurrentBarInMainBar = nil;
	end
	for i=1,10 do
		if (not DAB_Settings[DAB_INDEX].Bar[i].formmethod) then
			
		elseif (DAB_Settings[DAB_INDEX].Bar[i].formmethod < 3) then
			if (DAB_Settings[DAB_INDEX].Bar[i].form) then
				if (DAB_Settings[DAB_INDEX].Bar[i].form == currentform) then
					if (DAB_IsInContext(DAB_Settings[DAB_INDEX].Bar[i].friendlytarget, DAB_Settings[DAB_INDEX].Bar[i].hostiletarget, DAB_Settings[DAB_INDEX].Bar[i].incombat, DAB_Settings[DAB_INDEX].Bar[i].notincombat, DAB_Settings[DAB_INDEX].Bar[i].form, DAB_Settings[DAB_INDEX].Bar[i].onetrue)) then
						DAB_Bar_Show(i);
					end
					if (DAB_Settings[DAB_INDEX].Bar[i].formmethod == 2) then
						DAB_SetKeybindingBar(i)
					end
				else
					DAB_Bar_Hide(i);
				end
			end
		elseif (DAB_Settings[DAB_INDEX].Bar[i].formmethod == 3 and doswap) then
			if (DAB_Settings[DAB_INDEX].MainBar) then
				if (DAB_Settings[DAB_INDEX].Bar[i].form == currentform) then
					if (DAB_Settings[DAB_INDEX].CurrentBarInMainBar) then
						DAB_Bar_Swap(DAB_Settings[DAB_INDEX].MainBar, DAB_Settings[DAB_INDEX].CurrentBarInMainBar);
					end
					DAB_Settings[DAB_INDEX].CurrentBarInMainBar = i;
					DAB_Bar_Swap(DAB_Settings[DAB_INDEX].MainBar, i);
				end
			end
		end
	end
end

function DAB_Get_OtherBar(id)
	if (id == 11) then
		return "Pet";
	elseif (id == 12) then
		return "Form";
	elseif (id == 13) then
		return "Bag";
	elseif (id == 14) then
		return "Menu";
	end
end

function DAB_MouseOverBar_OnLoad()
	this:ClearAllPoints();
	if (this:GetID() < 11) then
		this:SetPoint("TOPLEFT", "DAB_ActionBar_"..this:GetID(), "TOPLEFT", 0, 0);
		this:SetPoint("BOTTOMRIGHT", "DAB_ActionBar_"..this:GetID(), "BOTTOMRIGHT", 0, 0);
	else
		local barindex = DAB_Get_OtherBar(this:GetID());
		this:SetPoint("TOPLEFT", "DAB_OtherBar_"..barindex, "TOPLEFT", 0, 0);
		this:SetPoint("BOTTOMRIGHT", "DAB_OtherBar_"..barindex, "BOTTOMRIGHT", 0, 0);
	end
end

function DAB_OtherBar_FixScales()
	for i=1,10 do
		getglobal("PetActionButton"..i.."AutoCast"):SetScale(getglobal("PetActionButton"..i.."AutoCast").scale);
		getglobal("PetActionButton"..i.."Cooldown"):SetScale(getglobal("PetActionButton"..i.."Cooldown").scale);
		getglobal("ShapeshiftButton"..i.."Cooldown"):SetScale(getglobal("ShapeshiftButton"..i.."Cooldown").scale);
	end
end

function DAB_OtherBar_Hide(bar)
	if (not DAB_Settings[DAB_INDEX].OtherBar[bar]) then
		DAB_Debug("Attempted to hide an other bar that doesn't exist: "..bar);
		return;
	end
	local barindex = DAB_Get_OtherBar(bar);
	if (bar ~= 11) then
		DAB_Settings[DAB_INDEX].OtherBar[bar].hide = true;		
	end
	getglobal("DAB_OtherBar_"..barindex):Hide();
end

function DAB_OtherBar_Initialize(bar)
	local barindex = DAB_Get_OtherBar(bar);
	local settings = DAB_Settings[DAB_INDEX].OtherBar[bar];
	local barname = "DAB_OtherBar_"..barindex;
	local barframe = getglobal(barname);

	local buttoname, button, prevbutton;
	local heightscale = 1;
	local yoffset = 0;
	if (bar == 14) then
		heightscale = 58/29;
		yoffset = settings.size * heightscale - 36/29 * settings.size;
		MicroButtonPortrait:ClearAllPoints();
		MicroButtonPortrait:SetPoint("TOPLEFT", "CharacterMicroButton", "TOPLEFT", 5.5 * settings.size / 29, -28 * settings.size / 29);
		MicroButtonPortrait:SetPoint("BOTTOMRIGHT", "CharacterMicroButton", "TOPLEFT", 23.5 * settings.size / 29, -53 * settings.size / 29);
	end

	local basescale = settings.size / 30;
	if (DAB_Settings[DAB_INDEX].ModifyCooldownByUIScale) then
		basescale = basescale * UIParent:GetScale();
	end
	for i=1,10 do
		buttonname = DAB_OTHER_BARS[barindex].frames[i];
		if (not buttonname) then break; end
		button = getglobal(buttonname);

		button:SetHeight(settings.size * heightscale);
		button:SetWidth(settings.size);	
		button:SetAlpha(settings.alpha);

		if (bar == 13) then
			button:SetNormalTexture("");
			getglobal(buttonname.."NormalTexture"):Hide();
		elseif (bar == 11) then
			button:SetNormalTexture("");
			getglobal(buttonname.."AutoCastable"):SetWidth(58 * basescale);
			getglobal(buttonname.."AutoCastable"):SetHeight(58 * basescale);
			getglobal(buttonname.."AutoCast").scale = basescale * 1.2;
			getglobal(buttonname.."AutoCast"):SetScale(basescale * 1.2);
			getglobal(buttonname.."Cooldown").scale = basescale * .65;
			getglobal(buttonname.."Cooldown"):ClearAllPoints();
			getglobal(buttonname.."Cooldown"):SetAllPoints(buttonname);
			getglobal(buttonname.."Cooldown"):SetScale(basescale * .65);
		elseif (bar == 12) then
			button:SetNormalTexture("");
			local cooldownscale = settings.size / 36 * .85;
			if (DAB_Settings[DAB_INDEX].ModifyCooldownByUIScale) then
				cooldownscale = cooldownscale * UIParent:GetScale();
			end
			getglobal(buttonname.."Cooldown").scale = cooldownscale;
			getglobal(buttonname.."Cooldown"):SetScale(cooldownscale);
		end

		button:ClearAllPoints();
		if (prevbutton) then
			if (settings.layout < 3) then
				button:SetPoint("LEFT", prevbutton, "RIGHT", settings.spacingh, 0);
			else
				button:SetPoint("TOP", prevbutton, "BOTTOM", 0, -settings.spacingv + yoffset);
			end
		else
			button:SetPoint("TOPLEFT", barname, "TOPLEFT", settings.padding, -settings.padding + yoffset);
		end
		prevbutton = buttonname;

		if (settings.hide or settings.mouseoverbar) then
			button:Hide();
		else
			button:Show();
		end

		if (bar == 11) then
			button:SetParent(DAB_OtherBar_Pet);
		elseif (bar == 12) then
			button:SetParent(DAB_OtherBar_Form);
		elseif (bar == 13) then
			button:SetParent(DAB_OtherBar_Bag);
		elseif (bar == 14) then
			button:SetParent(DAB_OtherBar_Menu);
		end
	end

	local barheight, barwidth;
	local baseheight = settings.size * heightscale - yoffset;
	if (settings.layout == 1) then
		barheight = baseheight + settings.padding * 2;
		barwidth = settings.size * DAB_OTHER_BARS[barindex].length1 + settings.padding * 2 + (DAB_OTHER_BARS[barindex].length1 - 1) * settings.spacingh;
	elseif (settings.layout == 2) then
		barheight = baseheight * 2 + settings.padding * 2 + settings.spacingv;
		barwidth = settings.size * DAB_OTHER_BARS[barindex].length2 + settings.padding * 2 + (DAB_OTHER_BARS[barindex].length2 - 1) * settings.spacingh;
		getglobal(DAB_OTHER_BARS[barindex].row2):ClearAllPoints();
		getglobal(DAB_OTHER_BARS[barindex].row2):SetPoint("TOP", DAB_OTHER_BARS[barindex].first, "BOTTOM", 0, -settings.spacingv + yoffset);
	elseif (settings.layout == 3) then
		barheight = baseheight * DAB_OTHER_BARS[barindex].length1 + settings.padding * 2 + (DAB_OTHER_BARS[barindex].length1 - 1) * settings.spacingv;
		barwidth = settings.size + settings.padding * 2;
	elseif (settings.layout == 4) then
		barheight = baseheight * DAB_OTHER_BARS[barindex].length2 + settings.padding * 2 + (DAB_OTHER_BARS[barindex].length2 - 1) * settings.spacingv;
		barwidth = settings.size * 2 + settings.padding * 2 + settings.spacingh;
		getglobal(DAB_OTHER_BARS[barindex].row2):ClearAllPoints();
		getglobal(DAB_OTHER_BARS[barindex].row2):SetPoint("LEFT", DAB_OTHER_BARS[barindex].first, "RIGHT", settings.spacingh, 0);
	end

	barframe:SetHeight(barheight);
	barframe:SetWidth(barwidth);

	local background = getglobal(barname);
	local bgtexture = "Interface\\AddOns\\DiscordActionBars\\PlainBackdrop";
	if (settings.background.texture) then
		bgtexture = "Interface\\AddOns\\DiscordActionBars\\" .. settings.background.texture;
	end
	if (settings.background.style == 1) then
		local bordertexture = "Interface\\AddOns\\DiscordActionBars\\PlainBackdrop";
		if (settings.background.bordertexture) then
			bordertexture = "Interface\\AddOns\\DiscordActionBars\\" .. settings.background.bordertexture;
		end
		background:SetBackdrop({bgFile = bgtexture, edgeFile = bordertexture, tile = false, tileSize = 1, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 }});
	elseif (settings.background.style == 2) then
		background:SetBackdrop({bgFile = bgtexture, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }});
	elseif (settings.background.style == 3) then
		background:SetBackdrop({bgFile = bgtexture, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, insets = { left = 11, right = 12, top = 12, bottom = 11 }});
	end

	background:SetBackdropColor(settings.background.color.r, settings.background.color.g, settings.background.color.b, settings.background.alpha);
	background:SetBackdropBorderColor(settings.background.bordercolor.r, settings.background.bordercolor.g, settings.background.bordercolor.b, settings.background.borderalpha);

	local label = barname.."_Label";
	getglobal(label):ClearAllPoints();
	getglobal(label):SetPoint(settings.label.attachpoint, barname, settings.label.attachto, settings.label.attachoffsetx, settings.label.attachoffsety);
	getglobal(label.."_Text"):SetText(settings.label.text);
	getglobal(label.."_Text"):SetTextHeight(settings.label.textsize);
	getglobal(label):SetScale(getglobal(label):GetScale() + 1);
	getglobal(label):SetScale(getglobal(label):GetScale() - 1);
	getglobal(label.."_Text"):SetTextColor(settings.label.color.r, settings.label.color.g, settings.label.color.b, settings.label.alpha);
	getglobal(label):SetWidth(getglobal(label.."_Text"):GetWidth() + 10);
	getglobal(label):SetHeight(getglobal(label.."_Text"):GetHeight() + 10);
	getglobal(label.."_Background"):SetAlpha(settings.label.bgalpha);
	getglobal(label.."_Background"):SetVertexColor(settings.label.bgcolor.r, settings.label.bgcolor.g, settings.label.bgcolor.b);
	for _,border in DAB_BORDERS do
		getglobal(label..border):SetAlpha(settings.label.borderalpha);
		getglobal(label..border):SetVertexColor(settings.label.bordercolor.r, settings.label.bordercolor.g, settings.label.bordercolor.b);
	end

	if (settings.hidelabel) then
		getglobal(label):Hide();
	else
		getglobal(label):Show();
	end


	if (settings.mouseoverbar) then
		barframe:Hide();
		getglobal("DAB_MouseoverBar_"..bar):Show();
	elseif (settings.hide) then
		barframe:Hide();
		getglobal("DAB_MouseoverBar_"..bar):Hide();
	else
		DAB_OtherBar_Show(bar);
		getglobal("DAB_MouseoverBar_"..bar):Hide();
	end

	if (settings.attachframe) then
		barframe:ClearAllPoints();
		barframe:SetPoint(settings.attachpoint, settings.attachframe, settings.attachto, settings.attachoffsetx, settings.attachoffsety);
	else
		barframe:ClearAllPoints();
		barframe:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", DAB_Settings[DAB_INDEX].FrameLocation[barname].x, DAB_Settings[DAB_INDEX].FrameLocation[barname].y);
	end

	if (bar == 11) then
		barframe:RegisterEvent("UNIT_PET");
	end
end

function DAB_OtherBar_Show(bar)
	if (not DAB_Settings[DAB_INDEX].OtherBar[bar]) then
		DAB_Debug("Attempted to show an other bar that doesn't exist: "..bar);
		return;
	end
	local barindex = DAB_Get_OtherBar(bar);
	DAB_Settings[DAB_INDEX].OtherBar[bar].hide = nil;
	getglobal("DAB_OtherBar_"..barindex):Show();
	local i = 0;
	for _, button in DAB_OTHER_BARS[barindex].frames do
		getglobal(button):Show();
		i = i + 1;
		if (bar == 12 and i > GetNumShapeshiftForms()) then
			getglobal(button):Hide();
		end
	end
end

function DAB_OtherBar_Toggle(bar)
	if (not DAB_Settings[DAB_INDEX].OtherBar[bar]) then
		DAB_Debug("Attempted to toggle an other bar that doesn't exist: "..bar);
		return;
	end
	local barindex = DAB_Get_OtherBar(bar);
	if (getglobal("DAB_OtherBar_"..barindex):IsVisible()) then
		DAB_OtherBar_Hide(bar);
	else
		DAB_OtherBar_Show(bar);
	end
end