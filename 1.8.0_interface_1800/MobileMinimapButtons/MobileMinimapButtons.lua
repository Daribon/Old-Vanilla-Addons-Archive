--------------------------------------------------------------------------
-- MobileFrames.lua 
--------------------------------------------------------------------------
--[[
Mobile Minimap Buttons

By: AnduinLothar    <KarlKFI@cosmosui.org>

Makes the Minimap Buttons draggable around the minimap with adjustable angle.
Shift-Drag to change angle.
Shift-Right-Click to bring up menu.
Menu: Reset, Reset All, Disable.

Possible ToDo: Shift-Ctrl-Drag to change radius.

Change Log:

v1.0 (9/30/05)
-Initial Release
v1.1 (10/18/05)
-Added dynamic button adding using MobileMinimapButtons_AddButton at any time.
-See API.txt for details on how to make your addon's button mobile.

		
	$Id: MobileMinimapButtons.lua 2025 2005-07-02 23:51:34Z KarlKFI $
	$Rev: 2025 $
	$LastChangedBy: KarlKFI $
	$Date: 2005-07-02 16:51:34 -0700 (Sat, 02 Jul 2005) $


]]--

MobileMinimapButtons_Coords = {};
MobileMinimapButtons_Enabled = true;

MobileMinimapButtons_FullSizeButtons = {
	--Fullsize buttons use the 1/2 width offset rather than the normal 1/4 width
	["MiniMapTrackingFrame"] = true,
};

MobileMinimapButtons_NotAButton = {
	--Frames have no OnClick script element
	["MiniMapMailFrame"] = true,
	["MiniMapTrackingFrame"] = true,
};

function MobileMinimapButtons_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	if (Khaos) then
		MobileMinimapButtons_RegisterForKhaos();
	end
end

function MobileMinimapButtons_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		--Loop Through Minimap Buttons
		for frameName, localizedFrameName in MOBILE_MINIMAP_BUTTONS_DESCRIPTIONS do
			MobileMinimapButtons_MakeMobile(frameName, localizedFrameName)
		end
		
		--Fix the Problem of Enable/Disable not effecting OnMouseUp/OnMouseDown
		Sea.util.hook( "Minimap_ZoomInClick", "MobileMinimapButtons_Minimap_ZoomInClick", "replace" );
		Sea.util.hook( "Minimap_ZoomOutClick", "MobileMinimapButtons_Minimap_ZoomOutClick", "replace" );
		MobileMinimapButtons_VarsLoaded = true;
	end
end

function MobileMinimapButtons_AddButton(frameName, localizedFrameName, notAButton)
	if (not frameName) or (not getglobal(frameName)) then
		Sea.io.print("MobileMinimapButtons Error: Cannot add ", frameName, " (", localizedFrameName, ") called from ", this:GetName(), ". The button does not exist.");
		return;
	elseif (MOBILE_MINIMAP_BUTTONS_DESCRIPTIONS[frameName]) then
		Sea.io.print("MobileMinimapButtons Error: Cannot add ", frameName, " (", localizedFrameName, ") called from ", this:GetName(), ". Duplicate already registered.");
		return;
	end
	MOBILE_MINIMAP_BUTTONS_DESCRIPTIONS[frameName] = localizedFrameName;
	if (notAButton) then
		MobileMinimapButtons_NotAButton[frameName] = true
	end
	if (MobileMinimapButtons_VarsLoaded) then
		MobileMinimapButtons_MakeMobile(frameName, localizedFrameName);
		if (not MobileMinimapButtons_Enabled) then
			--Override Disable to redisable
			MobileMinimapButtons_Enabled = true;
			MobileMinimapButtons_Disable();
		end
	end
end

function MobileMinimapButtons_MakeMobile(frameName, localizedFrameName)
	local frame = Sea.util.getValue(frameName);
	
	--Store the current position as the reset coords
	MobileMinimapButtons_StoreResetPosition(frameName);
	
	--Load Frame Script Element Hooks
	Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnEvent", "replace", "OnEvent" );
	if (not MobileMinimapButtons_NotAButton[frameName]) then
		Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnClick", "replace", "OnClick" );
	end
	Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnMouseDown", "replace", "OnMouseDown" );
	Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnMouseUp", "replace", "OnMouseUp" );
	Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnHide", "replace", "OnHide" );
	Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnUpdate", "replace", "OnUpdate" );
	
	--Make sure all the Buttons are Mobile
	if (not frame:IsMovable()) then
		frame:SetMovable(1);
	end
	
	--Reposition Buttons to Saved Coords
	local coords = MobileMinimapButtons_Coords[frameName];
	if (coords) and (coords.x) and (coords.y) then
		frame:ClearAllPoints();
		frame:SetPoint("CENTER", "Minimap", "CENTER", coords.x, coords.y);
	end
	
	--Elevate Buttons Above the MiniMap
	frame:SetFrameLevel(frame:GetFrameLevel()+1);
end

function MobileMinimapButtons_Minimap_ZoomInClick()
	if(MinimapZoomIn:IsEnabled() == 1) then
		return true;
	end
end

function MobileMinimapButtons_Minimap_ZoomOutClick()
	if(MinimapZoomOut:IsEnabled() == 1) then
		return true;
	end
end

function MobileMinimapButtons_StoreResetPosition(frameName)
	local frame = Sea.util.getValue(frameName);
	local centerX, centerY = Minimap:GetCenter();
	local thisX, thisY = frame:GetCenter();
	local radius;
	if (MobileMinimapButtons_FullSizeButtons[frameName]) then
		radius = ((Minimap:GetRight()-Minimap:GetLeft())/2) + ((frame:GetRight()-frame:GetLeft())/2);
	else
		radius = ((Minimap:GetRight()-Minimap:GetLeft())/2) + ((frame:GetRight()-frame:GetLeft())/4);
	end
	local x = math.abs(thisX - centerX);
	local y = math.abs(thisY - centerY);
	local xSign = 1;
	local ySign = 1;
	if not (thisX >= centerX) then
		xSign = -1;
	end
	if not (thisY >= centerY) then
		ySign = -1;
	end
	--Sea.io.print(xSign*x,", ",ySign*y);
	local angle = math.atan(x/y);
	x = math.sin(angle)*radius;
	y = math.cos(angle)*radius;
	frame.resetX = xSign*x;
	frame.resetY = ySign*y;
end

function MobileMinimapButtons_Reset(frame)
	frame.isMoving = false;
	frame:ClearAllPoints();
	frame:SetPoint("CENTER", "Minimap", "CENTER", frame.resetX, frame.resetY);
	frame:SetUserPlaced(false);
	MobileMinimapButtons_Coords[frame:GetName()] = nil;
end

function MobileMinimapButtons_ResetAll()
	for frameName, localizedFrameName in MOBILE_MINIMAP_BUTTONS_DESCRIPTIONS do
		local frame = Sea.util.getValue(frameName);
		MobileMinimapButtons_Reset(frame);
	end
end

function MobileMinimapButtons_Disable()
	if (not MobileMinimapButtons_Enabled) then
		return;
	end
	for frameName, localizedFrameName in MOBILE_MINIMAP_BUTTONS_DESCRIPTIONS do
		--Reset Location without forgetting coords
		local frame = Sea.util.getValue(frameName);
		frame.isMoving = false;
		frame:ClearAllPoints();
		frame:SetPoint("CENTER", "Minimap", "CENTER", frame.resetX, frame.resetY);
		frame:SetUserPlaced(false);
		
		--Unload Frame Script Element Hooks
		Sea.util.unhook( frameName, "MobileMinimapButtons_Master_OnEvent", "replace", "OnEvent" );
		if (not MobileMinimapButtons_NotAButton[frameName]) then
			Sea.util.unhook( frameName, "MobileMinimapButtons_Master_OnClick", "replace", "OnClick" );
		end
		Sea.util.unhook( frameName, "MobileMinimapButtons_Master_OnMouseDown", "replace", "OnMouseDown" );
		Sea.util.unhook( frameName, "MobileMinimapButtons_Master_OnMouseUp", "replace", "OnMouseUp" );
		Sea.util.unhook( frameName, "MobileMinimapButtons_Master_OnHide", "replace", "OnHide" );
		Sea.util.unhook( frameName, "MobileMinimapButtons_Master_OnUpdate", "replace", "OnUpdate" );
	end
	MobileMinimapButtons_Enabled = nil;
end

function MobileMinimapButtons_ReEnable()
	if (MobileMinimapButtons_Enabled) then
		return;
	end
	for frameName, localizedFrameName in MOBILE_MINIMAP_BUTTONS_DESCRIPTIONS do
		--Load Frame Script Element Hooks
		Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnEvent", "replace", "OnEvent" );
		if (not MobileMinimapButtons_NotAButton[frameName]) then
			Sea.util.unhook( frameName, "MobileMinimapButtons_Master_OnClick", "replace", "OnClick" );
		end
		Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnMouseDown", "replace", "OnMouseDown" );
		Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnMouseUp", "replace", "OnMouseUp" );
		Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnHide", "replace", "OnHide" );
		Sea.util.hook( frameName, "MobileMinimapButtons_Master_OnUpdate", "replace", "OnUpdate" );
		
		--Reposition Buttons to Saved Coords
		local coords = MobileMinimapButtons_Coords[frameName];
		if (coords) and (coords.x) and (coords.y) then
			local frame = Sea.util.getValue(frameName);
			frame:ClearAllPoints();
			frame:SetPoint("CENTER", "Minimap", "CENTER", coords.x, coords.y);
		end
	end
	MobileMinimapButtons_Enabled = true;
end

function MobileMinimapButtons_Master_OnMouseDown()
	if (IsShiftKeyDown()) then
		if (arg1 == "LeftButton") then
			this.isMoving = true;
		end
	else
		return true;
	end
end

function MobileMinimapButtons_Master_OnMouseUp()
	local frameName = this:GetName();
	if (this.isMoving) then
		this.isMoving = false;
		if (not MobileMinimapButtons_Coords[frameName]) then
			MobileMinimapButtons_Coords[frameName] = {};
		end
		MobileMinimapButtons_Coords[frameName].x = this.currentX;
		MobileMinimapButtons_Coords[frameName].y = this.currentY;
	elseif (MouseIsOver(this)) then
		if (IsShiftKeyDown()) and (arg1 == "RightButton") then
			--MobileMinimapButtons_Reset(this);
			MobileMinimapButtonsDropDown.displayMode = "MENU";
			ToggleDropDownMenu(1, frameName, MobileMinimapButtonsDropDown, frameName);
			--MobileMinimapButtonsDropDown_Reposition(frameName);
		else
			if (Sea.util.Hooks[this:GetName()..".OnClick"]) and (Sea.util.Hooks[this:GetName()..".OnClick"].orig) then
				Sea.util.Hooks[this:GetName()..".OnClick"].orig();
			end
			return true;
		end
	else
		return true;
	end
end

function MobileMinimapButtons_Master_OnClick()
	--[[
	if (this.isMoving) then
		return;
	elseif (MouseIsOver(this)) then
		if (IsShiftKeyDown()) and (arg1 == "RightButton") then
			return;
		else
			return true;
		end
	else
		return true;
	end
	]]--
end

function MobileMinimapButtons_Master_OnHide()
	this.isMoving = false;
	return true;
end

function MobileMinimapButtons_Master_OnUpdate()
	if (this.isMoving) then
		local mouseX, mouseY = GetCursorPosition();
		local centerX, centerY = Minimap:GetCenter();
		local scale = Minimap:GetScale();
		mouseX = mouseX / scale;
		mouseY = mouseY / scale;
		if (MobileMinimapButtons_FullSizeButtons[this:GetName()]) then
			radius = ((Minimap:GetRight()-Minimap:GetLeft())/2) + ((this:GetRight()-this:GetLeft())/2);
		else
			radius = ((Minimap:GetRight()-Minimap:GetLeft())/2) + ((this:GetRight()-this:GetLeft())/4);
		end
		local x = math.abs(mouseX - centerX);
		local y = math.abs(mouseY - centerY);
		local xSign = 1;
		local ySign = 1;
		if not (mouseX >= centerX) then
			xSign = -1;
		end
		if not (mouseY >= centerY) then
			ySign = -1;
		end
		--Sea.io.print(xSign*x,", ",ySign*y);
		local angle = math.atan(x/y);
		x = math.sin(angle)*radius;
		y = math.cos(angle)*radius;
		this.currentX = xSign*x;
		this.currentY = ySign*y;
		this:ClearAllPoints();
		this:SetPoint("CENTER", "Minimap", "CENTER", this.currentX, this.currentY);
	else
		return true;
	end
end

-- <= == == == == == == == == == == == == =>
-- => Menu
-- <= == == == == == == == == == == == == =>

function MobileMinimapButtons_LoadDropDownMenu()
	--Title
	local info = {};
	info.text = MOBILE_MINIMAP_BUTTONS_DESCRIPTIONS[UIDROPDOWNMENU_MENU_VALUE];
	info.notClickable = 1;
	info.isTitle = 1;
	UIDropDownMenu_AddButton(info, 1);
	
	--Reset
	local info = {};
	info.text = RESET;
	info.value = "Reset";
	info.func = function() MobileMinimapButtons_Reset(Sea.util.getValue(UIDROPDOWNMENU_MENU_VALUE)) end;
	--info.notCheckable = 1;
	UIDropDownMenu_AddButton(info, 1);
	
	--Reset All
	local info = {};
	info.text = RESET_ALL;
	info.value = "ResetAll";
	info.func = MobileMinimapButtons_ResetAll;
	--info.notCheckable = 1;
	UIDropDownMenu_AddButton(info, 1);
	
	MobileMinimapButtonsDropDown_Reposition(UIDROPDOWNMENU_MENU_VALUE);
end

function MobileMinimapButtonsDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, MobileMinimapButtons_LoadDropDownMenu, "MENU");
end

function MobileMinimapButtonsDropDown_Reposition(anchorName)
	local customPoint = "TOPLEFT";   --Default Anchor
	local offscreenY, offscreenX, anchorPoint, relativePoint, offsetX, offsetY;
	local listFrame = getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL);
	-- Determine whether the menu is off the screen or not
	local offscreenY, offscreenX;
	--Hack for built in bug
	if ( not listFrame:GetRight() ) then
		return;
	end
	
	if ( listFrame:GetBottom() < WorldFrame:GetBottom() ) then
		offscreenY = 1;
	end
	if ( listFrame:GetRight() > WorldFrame:GetRight() ) then
		offscreenX = 1;
	end
	
	local anchorPoint, relativePoint, offsetX, offsetY;
	if ( offscreenY == 1 ) then
		if ( offscreenX == 1 ) then
			anchorPoint = string.gsub(customPoint, "TOP(.*)", "BOTTOM%1");
			anchorPoint = string.gsub(anchorPoint, "(.*)LEFT", "%1RIGHT");
			relativePoint = "TOPRIGHT";
			offsetX = 0;
			offsetY = 14;
		else
			anchorPoint = string.gsub(customPoint, "TOP(.*)", "BOTTOM%1");
			relativePoint = "TOPLEFT";
			offsetX = 0;
			offsetY = 14;
		end
	else
		if ( offscreenX == 1 ) then
			anchorPoint = string.gsub(customPoint, "(.*)LEFT", "%1RIGHT");
			relativePoint = "BOTTOMRIGHT";
			offsetX = 0;
			offsetY = -14;
		else
			anchorPoint = customPoint;
			relativePoint = "BOTTOMLEFT";
			offsetX = 0;
			offsetY = -14;
		end
	end
	listFrame:ClearAllPoints();
	listFrame:SetPoint(anchorPoint, anchorName, relativePoint, offsetX, offsetY);
	
	-- Reshow the "MENU" border
	getglobal(listFrame:GetName().."Backdrop"):Hide();
	getglobal(listFrame:GetName().."MenuBackdrop"):Show();
	--getglobal(listFrame:GetName().."Backdrop"):Show();
	--getglobal(listFrame:GetName().."MenuBackdrop"):Hide();
end

-- <= == == == == == == == == == == == == =>
-- => Khaos Registration
-- <= == == == == == == == == == == == == =>

function MobileMinimapButtons_RegisterForKhaos()
	local optionSet = {
		id="MobileMinimapButtons";
		text=MOBILE_MINIMAP_BUTTONS_HEADER;
		helptext=MOBILE_MINIMAP_BUTTONS_HEADER_INFO;
		difficulty=1;
		default = {checked = true};
		callback = function(checked)
			if (checked) then
				MobileMinimapButtons_ReEnable();
			else
				MobileMinimapButtons_Disable();
			end
		end;
		options={
			{
				id="Header";
				text=MOBILE_MINIMAP_BUTTONS_HEADER;
				helptext=MOBILE_MINIMAP_BUTTONS_HEADER_INFO;
				type=K_HEADER;
			};
			{
				id="ResetAll";
				type=K_BUTTON;
				text=MOBILE_MINIMAP_BUTTONS_RESET_ALL_TEXT;
				helptext=MOBILE_MINIMAP_BUTTONS_RESET_ALL_TEXT_INFO;
				callback=MobileMinimapButtons_ResetAll;
				setup={buttonText=RESET_ALL};
			};
		};
	};
	Khaos.registerOptionSet(
		"frames",
		optionSet
	);
end
