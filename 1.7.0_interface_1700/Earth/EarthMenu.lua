--[[
--
--	Earth Menu
--
--		By Alexander Brazie
--
--	Unfortunately, OnEvent handlers require code. 
--	Hopefully, this will make it easier to use than 
--	the stock Blizzard code. 
--
--	This will hopefully avoid collisions with 
--	Blizzard menus as well. I've tried to avoid
--	duplicating code by reusing Blizzards functions
--	where they are sufficiently generic.
--
--	Eventually, this will need to be redone to resolve
--	those Lua issues that popup, but the basic 
--	structure should be the same: 
--
--	Edit a widget's .onEvent to change that function. 
--	Leave it nil for default functionality.
--	
--]]



--[[
--
--	Earth Menu Instructions
--	
--	To overwrite a widget event handler, simply 
--
--	menu = getglobal("WidgetSubMenu1");
--	menu.onClick = function() MyCommands() end;
--	menu.onEnter = function() bar(); end
--
--	and so on...
--	
--]]

EARTH_UIDROPDOWNMENU_MAXBUTTONS = 32;
EARTH_UIDROPDOWNMENU_MAXLEVELS = 3;
EARTH_UIDROPDOWNMENU_BUTTON_HEIGHT = 16;
EARTH_UIDROPDOWNMENU_BORDER_HEIGHT = 15;
-- The current open menu
EARTH_UIDROPDOWNMENU_OPEN_MENU = nil;
-- The current menu being initialized
EARTH_UIDROPDOWNMENU_INIT_MENU = nil;
-- Current level shown of the open menu
EARTH_UIDROPDOWNMENU_MENU_LEVEL = 1;
-- Current value of the open menu
EARTH_UIDROPDOWNMENU_MENU_VALUE = nil;
-- Time to wait to hide the menu
EARTH_UIDROPDOWNMENU_SHOW_TIME = 2;

EARTHMENU_HIDE_TIMEOUT = 2;
EARTHMENU_TEMP_HIDE_TIMEOUT = nil;

--
-- Event Handlers:
--

function EarthMenu_ColorSwatchScriptedTemplate_OnClick() 
	if(not this.onClick ) then 
		EarthMenu_CloseMenus();
		EarthMenuButton_OpenColorPicker(this:GetParent());
	else
		this.onClick();
	end
end

function EarthMenu_ColorSwatchScriptedTemplate_OnEnter()
	if(not this.onEnter) then 
		EarthMenu_CloseDropDownMenus(this:GetParent():GetParent():GetID()+1);
		getglobal(this:GetName().."SwatchBg"):SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		EarthMenu_StopCounting(this:GetParent():GetParent());
	else
		this.onEnter();
	end
end

function EarthMenu_ColorSwatchScriptedTemplate_OnLeave()
	if ( not this.onLeave ) then 
		getglobal(this:GetName().."SwatchBg"):SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		EarthMenu_StartCounting(this:GetParent():GetParent());
	else
		this.onLeave();
	end
end

function EarthMenu_ExpandArrowScriptedTemplate_OnClick ()
	if ( not this.onClick ) then 
		EarthMenu_ToggleDropDownMenu(this:GetParent():GetParent():GetID()+1, this:GetParent().index);	
		EarthMenu_SetSelectedValue(this:GetParent():GetParent(), this:GetParent().value);
	else
		this.onClick();
	end
end
function EarthMenu_ExpandArrowScriptedTemplate_OnEnter()
	if ( not this.onEnter) then 
		EarthMenu_ToggleDropDownMenu(this:GetParent():GetParent():GetID()+1, this:GetParent().index);	
		EarthMenu_SetSelectedValue(this:GetParent():GetParent(), this:GetParent().value);
		EarthMenu_StopCounting(this:GetParent():GetParent());
	else 
		this.onEnter();
	end
end
function EarthMenu_ExpandArrowScriptedTemplate_OnLeave()
	if ( not this.onLeave ) then 
		EarthMenu_StartCounting(this:GetParent():GetParent());	
	else
		this.onLeave();
	end
end

function EarthMenu_InvisibleButtonScriptedTemplate_OnEnter()
	if ( not this.onEnter ) then
		EarthMenu_StopCounting(this:GetParent():GetParent());	
	else
		this.onEnter();
	end
end

function EarthMenu_InvisibleButtonScriptedTemplate_OnLeave()
	if ( not this.onLeave ) then
		EarthMenu_StartCounting(this:GetParent():GetParent());
	else 
		this.onLeave();
	end
end

function EarthMenu_ButtonScriptedTemplate_OnClick()
	if ( not this.onClick ) then
		EarthMenuButton_OnClick();	
	else
		this.onClick();
	end
end

function EarthMenu_ButtonScriptedTemplate_OnEnter()
	if ( not this.onEnter ) then
		if ( this.hasArrow ) then
			EarthMenu_ToggleDropDownMenu(this:GetParent():GetID() + 1, this.index);
		end
		getglobal(this:GetName().."Highlight"):Show();
		EarthMenu_StopCounting(this:GetParent());
		if ( this.tooltipTitle ) then
			GameTooltip_AddNewbieTip(this.tooltipTitle, 1.0, 1.0, 1.0, this.tooltipText, 1);
		end
	else
		this.onEnter();
	end
end
function EarthMenu_ButtonScriptedTemplate_OnLeave()
	if ( not this.onLeave ) then
		getglobal(this:GetName().."Highlight"):Hide();
		EarthMenu_StartCounting(this:GetParent());
		GameTooltip:Hide();	
	else
		this.onLeave();
	end
end

function EarthMenu_ListGraphicTemplateMenuBackdrop_OnLoad()
	if ( not this.onLoad ) then 
		this:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
		this:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);	
	else
		this.onLoad();
	end
end

function EarthMenu_ListScriptedTemplate_OnClick()
	if ( not this.onClick ) then 
		this:Hide();
	else
		this.onClick();
	end
end

function EarthMenu_ListScriptedTemplate_OnEnter()
	if ( not this.onEnter ) then 
		EarthMenu_StopCounting(this);
	else
		this.onEnter();
	end
end

function EarthMenu_ListScriptedTemplate_OnLeave()
	if ( not this.onLeave ) then 
		EarthMenu_StartCounting(this);
	else
		this.onLeave();
	end
end

function EarthMenu_ListScriptedTemplate_OnHide()
	if ( not this.onHide ) then 
		EarthMenu_CloseDropDownMenus (this:GetID()+1);
	else
		this.onHide();
	end
end

function EarthMenu_ListScriptedTemplate_OnUpdate(elapsed)
	if ( not this.onUpdate ) then
		EarthMenu_OnUpdate(elapsed);
	else
		this.onUpdate();
	end
end

function EarthMenu_ListScriptedTemplate_OnShow()
	if ( not this.onShow ) then 
		for i=1, EARTH_UIDROPDOWNMENU_MAXBUTTONS do
			if (not this.noResize) then
				getglobal(this:GetName().."Button"..i):SetWidth(this.maxWidth);
			end
		end
		if (not this.noResize) then
			this:SetWidth(this.maxWidth+15);
		end
		this.showTime = nil;
		if ( this:GetID() > 1 ) then
			this.parent = getglobal("EarthDropDownList"..(this:GetID() - 1));
		end
	else
		this.onShow();
	end
end

function EarthMenu_TemplateScriptedButtonTemplate_OnClick()
	if( not this.onClick ) then 
		EarthMenu_ToggleDropDownMenu();
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		this.onClick();
	end
end

function EarthMenu_ScriptedTemplate_OnHide()
	if ( not this.onHide ) then 
		EarthMenu_CloseDropDownMenus();
	else
		this.onHide();
	end
end

--[[
--
-- Real code
--
--]]

function EarthMenu_Initialize(frame, initFunction, displayMode, level)
	if ( not frame ) then
		frame = this;
	end

	if ( frame:GetName() ~= EARTH_UIDROPDOWNMENU_OPEN_MENU ) then
		EARTH_UIDROPDOWNMENU_MENU_LEVEL = 1;
	end

	-- Set the frame that's being intialized
	EARTH_UIDROPDOWNMENU_INIT_MENU = frame:GetName();

	-- Hide all the buttons
	local button, dropDownList;
	for i = 1, EARTH_UIDROPDOWNMENU_MAXLEVELS, 1 do
		dropDownList = getglobal("EarthDropDownList"..i);
		if ( i >= EARTH_UIDROPDOWNMENU_MENU_LEVEL or frame:GetName() ~= EARTH_UIDROPDOWNMENU_OPEN_MENU ) then
			dropDownList.numButtons = 0;
			dropDownList.maxWidth = 0;
			for j=1, EARTH_UIDROPDOWNMENU_MAXBUTTONS, 1 do
				button = getglobal("EarthDropDownList"..i.."Button"..j);
				button:Hide();
			end
		end
	end
	frame:SetHeight(EARTH_UIDROPDOWNMENU_BUTTON_HEIGHT * 2);
	
	-- Set the initialize function and call it.  The initFunction populates the dropdown list.
	if ( initFunction ) then
		frame.initialize = initFunction;
		initFunction(level);
	end

	-- Change appearance based on the displayMode
	if ( displayMode == "MENU" ) then
		getglobal(frame:GetName().."Left"):Hide();
		getglobal(frame:GetName().."Middle"):Hide();
		getglobal(frame:GetName().."Right"):Hide();
		--[[
		getglobal(frame:GetName().."ButtonNormalTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonDisabledTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonPushedTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonHighlightTexture"):SetTexture("");
		getglobal(frame:GetName().."Button"):ClearAllPoints();
		]]
		getglobal(frame:GetName().."Button"):SetPoint("LEFT", frame:GetName().."Text", "LEFT", -9, 0);
		getglobal(frame:GetName().."Button"):SetPoint("RIGHT", frame:GetName().."Text", "RIGHT", 6, 0);
	else 
		getglobal(frame:GetName().."Left"):Show();
		getglobal(frame:GetName().."Middle"):Show();
		getglobal(frame:GetName().."Right"):Show();
		--[[
		getglobal(frame:GetName().."ButtonNormalTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonDisabledTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonPushedTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonHighlightTexture"):SetTexture("");
		getglobal(frame:GetName().."Button"):ClearAllPoints();
		]]
		getglobal(frame:GetName().."Button"):SetPoint("LEFT", frame:GetName().."Text", "LEFT", -9, 0);
		getglobal(frame:GetName().."Button"):SetPoint("RIGHT", frame:GetName().."Text", "RIGHT", 6, 0);		
	end
	frame.displayMode = displayMode;

end

-- If dropdown is visible then see if its timer has expired, if so hide the frame
function EarthMenu_OnUpdate(elapsed)
	if ( this:IsVisible() ) then
		if ( not this.showTimer or not this.isCounting ) then
			return;
		elseif ( this.showTimer < 0 ) then
			this:Hide();
			this.showTimer = nil;
			this.isCounting = nil;
		else
			if ( type(elapsed) == "number") then 
				this.showTimer = this.showTimer - elapsed;
			end
		end
	end
end

-- Start the countdown on a frame
function EarthMenu_StartCounting(frame)
	if ( frame.parent ) then
		EarthMenu_StartCounting(frame.parent);
	else
		frame.showTimer = EARTH_UIDROPDOWNMENU_SHOW_TIME;
		frame.isCounting = 1;
	end
end

-- Stop the countdown on a frame
function EarthMenu_StopCounting(frame)
	if ( frame.parent ) then
		EarthMenu_StopCounting(frame.parent);
	else
		frame.isCounting = nil;
	end
end

--[[
List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING]  --  The value that EARTH_UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, 1]  --  Check the button
info.isTitle = [nil, 1]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, 1]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.hasArrow = [nil, 1]  --  Show the expand arrow for multilevel menus
info.hasColorSwatch = [nil, 1]  --  Show color swatch or not, for color selection
info.r = [1 - 255]  --  Red color value of the color swatch
info.g = [1 - 255]  --  Green color value of the color swatch
info.b = [1 - 255]  --  Blue color value of the color swatch
info.textR = [1 - 255]  --  Red color value of the button text
info.textG = [1 - 255]  --  Green color value of the button text
info.textB = [1 - 255]  --  Blue color value of the button text
info.swatchFunc = [function()]  --  Function called by the color picker on color change
info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
info.justifyH = [nil, "CENTER"] -- Justify button text
]]--

function EarthMenu_AddButton(info, level)
	--[[
	Might to uncomment this if there are performance issues 
	if ( not EARTH_UIDROPDOWNMENU_OPEN_MENU ) then
		return;
	end
	]]
	if ( not level ) then
		level = 1;
	end
	
	local listFrame = getglobal("EarthDropDownList"..level);
	local listFrameName = listFrame:GetName();
	local index = listFrame.numButtons + 1;
	local width;

	-- If too many buttons error out
	if ( index > EARTH_UIDROPDOWNMENU_MAXBUTTONS ) then
		Sea.io.error("Too many buttons in EarthMenu: "..EARTH_UIDROPDOWNMENU_OPEN_MENU);
		return;
	end

	-- If too many levels error out
	if ( level > EARTH_UIDROPDOWNMENU_MAXLEVELS ) then
		Sea.io.error("Too many levels in EarthMenu: "..EARTH_UIDROPDOWNMENU_OPEN_MENU);
		return;
	end
	
	-- Set the number of buttons in the listframe
	listFrame.numButtons = index;
	
	local button = getglobal(listFrameName.."Button"..index);
	local normalText = getglobal(button:GetName().."NormalText");
	local highlightText = getglobal(button:GetName().."HighlightText");
	local disabledText = getglobal(button:GetName().."DisabledText");
	-- This button is used to capture the mouse OnEnter/OnLeave events if the dropdown button is disabled, since a disabled button doesn't receive any events
	-- This is used specifically for drop down menu time outs
	local invisibleButton = getglobal(button:GetName().."InvisibleButton");
	
	-- Default settings
	disabledText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	invisibleButton:Hide();
	button:Enable();
	
	-- Configure button
	if ( info.text ) then
		button:SetText(info.text);
		-- Determine the maximum width of a button
		width = normalText:GetWidth() + 60;
		-- Add padding if has and expand arrow or color swatch
		if ( info.hasArrow or info.hasColorSwatch ) then
			width = width + 50 - 30;
		end
		if ( info.notCheckable ) then
			width = width - 30;
		end
		if ( width > listFrame.maxWidth ) then
			listFrame.maxWidth = width;
		end
		-- If a textR is set then set the vertex color of the button text
		if ( info.textR ) then
			normalText:SetTextColor(info.textR, info.textG, info.textB);
			highlightText:SetTextColor(info.textR, info.textG, info.textB);
		else
			normalText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			highlightText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		end
	else
		button:SetText("");
	end

	-- Pass through attributes
	button.func = info.func;
	button.owner = info.owner;
	button.hasOpacity = info.hasOpacity;
	button.opacity = info.opacity;
	button.opacityFunc = info.opacityFunc;
	button.cancelFunc = info.cancelFunc;
	button.swatchFunc = info.swatchFunc;
	button.keepShownOnClick = info.keepShownOnClick;
	button.tooltipTitle = info.tooltipTitle;
	button.tooltipText = info.tooltipText;
	button.index = info.index;

	if ( info.value ) then
		button.value = info.value;
	elseif ( info.text ) then
		button.value = info.text;
	else
		button.value = nil;
	end
	
	-- Show the expand arrow if it has one
	if ( info.hasArrow ) then
		getglobal(listFrameName.."Button"..index.."ExpandArrow"):Show();
	else
		getglobal(listFrameName.."Button"..index.."ExpandArrow"):Hide();
	end
	button.hasArrow = info.hasArrow;
	
	-- If not checkable move everything over to the left to fill in the gap where the check would be
	local xPos = 5;
	local yPos = -((button:GetID() - 1) * EARTH_UIDROPDOWNMENU_BUTTON_HEIGHT) - EARTH_UIDROPDOWNMENU_BORDER_HEIGHT;
	normalText:ClearAllPoints();
	highlightText:ClearAllPoints();
	disabledText:ClearAllPoints();
	if ( info.notCheckable ) then
		if ( info.justifyH and info.justifyH == "CENTER" ) then
			normalText:SetPoint("CENTER", button:GetName(), "CENTER", -7, 0);
			highlightText:SetPoint("CENTER", button:GetName(), "CENTER", -7, 0);
			disabledText:SetPoint("CENTER", button:GetName(), "CENTER", -7, 0);
		else
			normalText:SetPoint("LEFT", button:GetName(), "LEFT", 0, 0);
			highlightText:SetPoint("LEFT", button:GetName(), "LEFT", 0, 0);
			disabledText:SetPoint("LEFT", button:GetName(), "LEFT", 0, 0);
		end
		xPos = xPos + 10;
		
	else
		xPos = xPos + 12;
		normalText:SetPoint("LEFT", button:GetName(), "LEFT", 27, 0);
		highlightText:SetPoint("LEFT", button:GetName(), "LEFT", 27, 0);
		disabledText:SetPoint("LEFT", button:GetName(), "LEFT", 27, 0);
	end

	-- Adjust offset if displayMode is menu
	local frame = getglobal(EARTH_UIDROPDOWNMENU_OPEN_MENU);
	if ( frame and frame.displayMode == "MENU" ) then
		if ( not info.notCheckable ) then
			xPos = xPos - 6;
		end
	end
	
	-- If no open frame then set the frame to the currently initialized frame
	if ( not frame ) then
		frame = getglobal(EARTH_UIDROPDOWNMENU_INIT_MENU);
	end

	button:SetPoint("TOPLEFT", button:GetParent():GetName(), "TOPLEFT", xPos, yPos);

	-- See if button is selected by id or name
	if ( frame ) then
		if ( EarthMenu_GetSelectedName(frame) ) then
			if ( button:GetText() == EarthMenu_GetSelectedName(frame) ) then
				info.checked = 1;
			end
		elseif ( EarthMenu_GetSelectedID(frame) ) then
			if ( button:GetID() == EarthMenu_GetSelectedID(frame) ) then
				info.checked = 1;
			end
		elseif ( EarthMenu_GetSelectedValue(frame) ) then
			if ( button.value == EarthMenu_GetSelectedValue(frame) ) then
				info.checked = 1;
			end
		end
	end

	-- Show the check if checked
	if ( info.checked ) then
		button:LockHighlight();
		getglobal(listFrameName.."Button"..index.."Check"):Show();
	else
		button:UnlockHighlight();
		getglobal(listFrameName.."Button"..index.."Check"):Hide();
	end
	button.checked = info.checked;

	-- If has a colorswatch, show it and vertex color it
	local colorSwatch = getglobal(listFrameName.."Button"..index.."ColorSwatch");
	if ( info.hasColorSwatch ) then
		getglobal("EarthDropDownList"..level.."Button"..index.."ColorSwatch".."NormalTexture"):SetVertexColor(info.r, info.g, info.b);
		button.r = info.r;
		button.g = info.g;
		button.b = info.b;
		colorSwatch:Show();
	else
		colorSwatch:Hide();
	end

	-- If not clickable then disable the button and set it white
	if ( info.notClickable ) then
		info.disabled = 1;
		disabledText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	end

	-- Set the text color and disable it if its a title
	if ( info.isTitle ) then
		info.disabled = 1;
		disabledText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	
	-- Disable the button if disabled
	if ( info.disabled ) then
		button:Disable();
		invisibleButton:Show();
	end

	-- Set the height of the listframe
	listFrame:SetHeight((index * EARTH_UIDROPDOWNMENU_BUTTON_HEIGHT) + (EARTH_UIDROPDOWNMENU_BORDER_HEIGHT * 2));

	button:Show();
end

function EarthMenu_Refresh(frame, isCleared, useValue)
	local button, checked, checkImage;
	if ( not frame ) then
		frame = this;
	end
	
	-- Just redraws the existing menu
	for i=1, EARTH_UIDROPDOWNMENU_MAXBUTTONS do
		button = getglobal("EarthDropDownList"..EARTH_UIDROPDOWNMENU_MENU_LEVEL.."Button"..i);
		checked = nil;		

		-- See if checked or not
		if ( EarthMenu_GetSelectedName(frame) ) then
			if ( button:GetText() == EarthMenu_GetSelectedName(frame) ) then
				checked = 1;
			end
		elseif ( EarthMenu_GetSelectedID(frame) ) then
			if ( button:GetID() == EarthMenu_GetSelectedID(frame) ) then
				checked = 1;
			end
		elseif ( EarthMenu_GetSelectedValue(frame) ) then
			if ( button.value == EarthMenu_GetSelectedValue(frame) ) then
				checked = 1;
			end
		end

		-- If checked show check image
		checkImage = getglobal("EarthDropDownList"..EARTH_UIDROPDOWNMENU_MENU_LEVEL.."Button"..i.."Check");
		if ( checked and not isCleared ) then
			if ( useValue ) then
				EarthMenu_SetText(button.value, frame);
			else
				EarthMenu_SetText(button:GetText(), frame);
			end
			button:LockHighlight();
			checkImage:Show();
		else
			button:UnlockHighlight();
			checkImage:Hide();
		end
	end
end

function EarthMenu_SetSelectedName(frame, name, useValue)
	frame.selectedName = name;
	frame.selectedID = nil;
	frame.selectedValue = nil;
	EarthMenu_Refresh(frame, nil, useValue);
end

function EarthMenu_SetSelectedValue(frame, value, useValue)
	-- useValue will set the value as the text, not the name
	frame.selectedName = nil;
	frame.selectedID = nil;
	frame.selectedValue = value;
	EarthMenu_Refresh(frame, nil, useValue);
end

function EarthMenu_SetSelectedID(frame, id, useValue)
	frame.selectedID = id;
	frame.selectedName = nil;
	frame.selectedValue = nil;
	EarthMenu_Refresh(frame, nil, useValue);
end

function EarthMenu_GetSelectedName(frame)
	return frame.selectedName;
end

function EarthMenu_GetSelectedID(frame)
	if ( frame.selectedID ) then
		return frame.selectedID;
	else
		-- If no explicit selectedID then try to send the id of a selected value or name
		local button;
		for i=1, EARTH_UIDROPDOWNMENU_MAXBUTTONS do
			button = getglobal("EarthDropDownList"..EARTH_UIDROPDOWNMENU_MENU_LEVEL.."Button"..i);
			-- See if checked or not
			if ( EarthMenu_GetSelectedName(frame) ) then
				if ( button:GetText() == EarthMenu_GetSelectedName(frame) ) then
					return i;
				end
			elseif ( EarthMenu_GetSelectedValue(frame) ) then
				if ( button.value == EarthMenu_GetSelectedValue(frame) ) then
					return i;
				end
			end
		end
	end
end

function EarthMenu_GetSelectedValue(frame)
	return frame.selectedValue;
end

function EarthMenuButton_OnClick()
	local func = this.func;
	if ( func ) then
		func(not this.checked, this.value);
	else
		return;
	end
	
	if ( this.keepShownOnClick ) then
		if ( this.checked ) then
			getglobal(this:GetName().."Check"):Hide();
			this.checked = nil;
		else
			getglobal(this:GetName().."Check"):Show();
			this.checked = 1;
		end
	else
		this:GetParent():Hide();
	end
	PlaySound("UChatScrollButton");
end

function EarthMenu_ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset, customPoint)
	if ( not level ) then
		level = 1;
	end
	EARTH_UIDROPDOWNMENU_MENU_LEVEL = level;
	EARTH_UIDROPDOWNMENU_MENU_VALUE = value;
	local listFrame = getglobal("EarthDropDownList"..level);
	local listFrameName = "EarthDropDownList"..level;
	local tempFrame;
	if ( not dropDownFrame ) then
		tempFrame = this:GetParent();
	else
		tempFrame = dropDownFrame;
	end

	if ( not customPoint ) then
		customPoint = "TOPLEFT";
	end
	
	if ( listFrame:IsVisible() and (EARTH_UIDROPDOWNMENU_OPEN_MENU == tempFrame:GetName()) ) then
		listFrame:Hide();
	else
		-- Hide the listframe anyways since it is redrawn OnShow() 
		listFrame:Hide();
		
		-- Frame to anchor the dropdown menu to
		local anchorFrame;

		-- Display stuff
		-- Level specific stuff
		if ( level == 1 ) then
			if ( not dropDownFrame ) then
				dropDownFrame = this:GetParent();
			end
			EARTH_UIDROPDOWNMENU_OPEN_MENU = dropDownFrame:GetName();
			listFrame:ClearAllPoints();
			-- If there's no specified anchorName then use left side of the dropdown menu
			if ( not anchorName ) then
				anchorName = EARTH_UIDROPDOWNMENU_OPEN_MENU.."Left"
			end
			if ( not xOffset or not yOffset ) then
				xOffset = 8;
				yOffset = 22;
			end
			listFrame:SetPoint(customPoint, anchorName, "BOTTOMLEFT", xOffset, yOffset);
		else
			if ( not dropDownFrame ) then
				dropDownFrame = getglobal(EARTH_UIDROPDOWNMENU_OPEN_MENU);
			end
			listFrame:ClearAllPoints();
			-- If this is a dropdown button, not the arrow anchor it to itself
			if ( string.sub(this:GetParent():GetName(), 0,17) == "EarthDropDownList" and string.len(this:GetParent():GetName()) == 18 ) then
				anchorFrame = this:GetName();
			else
				anchorFrame = this:GetParent():GetName();
			end
			listFrame:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 0, 0);
		end
		
		-- Auto close after n seconds
		if ( Chronos ) then 
			local timeout = EARTHMENU_HIDE_TIMEOUT;
			if ( EARTHMENU_TEMP_HIDE_TIMEOUT ) then 
				timeout = EARTHMENU_TEMP_HIDE_TIMEOUT;
			end
			if( timeout and timeout > 0 ) then 
				Chronos.scheduleByName("EarthMenuAutoHide".."EarthDropDownList"..level, timeout, function() EarthMenu_HideFrame("EarthDropDownList", level);  EARTHMENU_TEMP_HIDE_TIMEOUT = nil; end);
			end
		end
		
		-- Change list box appearance depending on display mode
		if ( dropDownFrame and dropDownFrame.displayMode == "MENU" ) then
			getglobal(listFrameName.."Backdrop"):Hide();
			getglobal(listFrameName.."MenuBackdrop"):Show();
		else
			getglobal(listFrameName.."Backdrop"):Show();
			getglobal(listFrameName.."MenuBackdrop"):Hide();
		end

		EarthMenu_Initialize(dropDownFrame, dropDownFrame.initialize, nil, level);
		-- If no items in the drop down don't show it
		if ( listFrame.numButtons == 0 ) then
			return;
		end

		-- Check to see if the dropdownlist is off the screen, if it is anchor it to the top of the dropdown button
		listFrame:Show();
		-- Hack will fix this in next revision of dropdowns
		if ( not listFrame:GetLeft() ) then
			listFrame:Hide();
			return;
		end
		-- Determine whether the menu is off the screen or not
		local offscreenY, offscreenX;
		if ( listFrame:GetBottom() < 0 ) then
			offscreenY = 1;
		end
		if ( listFrame:GetRight() > WorldFrame:GetRight() ) then
			offscreenX = 1;
		end
		
		local anchorPoint, relativePoint, offsetX, offsetY;
		if ( offscreenY ) then
			if ( offscreenX ) then
				anchorPoint = string.gsub(customPoint, "TOP(.*)", "BOTTOM%1");
				anchorPoint = string.gsub(customPoint, "(.*)LEFT", "%1RIGHT");
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
			if ( offscreenX ) then
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
		if ( level == 1 ) then
			listFrame:SetPoint(anchorPoint, anchorName, relativePoint, offsetX, offsetY);
		else
			listFrame:SetPoint(anchorPoint, anchorFrame, relativePoint, offsetX, offsetY);
		end
	end
end


function EarthMenuButton_OpenColorPicker(button)
	EarthMenu_CloseMenus();
	if ( not button ) then
		button = this;
	end
	EARTH_UIDROPDOWNMENU_MENU_VALUE = button.index;
	ColorPickerFrame.func = button.swatchFunc;
	ColorPickerFrame.hasOpacity = button.hasOpacity;
	ColorPickerFrame.opacityFunc = button.opacityFunc;
	ColorPickerFrame.opacity = button.opacity;
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity};
	ColorPickerFrame.cancelFunc = button.cancelFunc;
	ShowUIPanel(ColorPickerFrame);
end


function EarthMenu_CloseDropDownMenus(level)
	if ( not level ) then
		level = 1;
	end
	for i=level, EARTH_UIDROPDOWNMENU_MAXLEVELS do
		getglobal("EarthDropDownList"..i):Hide();
	end
end

function EarthMenu_SetWidth(width, frame)
	if ( not frame ) then
		frame = this;
	end
	getglobal(frame:GetName().."Middle"):SetWidth(width);
	frame:SetWidth(width + 25 + 25);
	getglobal(frame:GetName().."Text"):SetWidth(width - 25);
	frame.noResize = 1;
end

function EarthMenu_SetButtonWidth(width, frame)
	if ( not frame ) then
		frame = this;
	end
	
	if ( width == "TEXT" ) then
		width = getglobal(frame:GetName().."Text"):GetWidth();
	end
	
	getglobal(frame:GetName().."Button"):SetWidth(width);
	frame.noResize = 1;
end


function EarthMenu_SetText(text, frame)
	if ( not frame ) then
		frame = this;
	end
	local filterText = getglobal(frame:GetName().."Text");
	if ( filterText ) then 
		filterText:SetText(text);
	end
end

function EarthMenu_GetText(frame)
	if ( not frame ) then
		frame = this;
	end
	local filterText = getglobal(frame:GetName().."Text");
	if ( filterText ) then 
		return filterText:GetText();
	end
end

function EarthMenu_ClearAll(frame)
	EarthMenu_SetSelectedID(frame, nil);
	EarthMenu_SetSelectedName(frame,nil);
	EarthMenu_SetSelectedValue(frame,nil);
	EarthMenu_SetText("", frame);
	EarthMenu_Refresh(frame, 1)
end

function EarthMenu_JustifyText(justification, frame)
	if ( not frame ) then
		frame = this;
	end
	local text = getglobal(frame:GetName().."Text");
	text:ClearAllPoints();
	if ( justification == "LEFT" ) then
		text:SetPoint("LEFT", frame:GetName().."Left", "LEFT", 27, 2);
	elseif ( justification == "RIGHT" ) then
		text:SetPoint("RIGHT", frame:GetName().."Right", "RIGHT", -43, 2);
	elseif ( justification == "CENTER" ) then
		text:SetPoint("CENTER", frame:GetName().."Middle", "CENTER", -5, 2);
	end
end

function EarthMenu_GetCurrentDropDown()
	if ( EARTH_UIDROPDOWNMENU_OPEN_MENU ) then
		return getglobal(EARTH_UIDROPDOWNMENU_OPEN_MENU);
	end
	
	-- If no dropdown then use this
	return this;
end

function EarthMenuButton_GetChecked()
	return getglobal(this:GetName().."Check"):IsVisible();
end

function EarthMenuButton_GetName()
	return getglobal(this:GetName().."NormalText"):GetText();
end

function EarthMenuButton_OpenColorPicker(button)
	EarthMenu_CloseMenus();
	if ( not button ) then
		button = this;
	end
	EARTH_UIDROPDOWNMENU_MENU_VALUE = button.index;
	ColorPickerFrame.func = button.swatchFunc;
	ColorPickerFrame.hasOpacity = button.hasOpacity;
	ColorPickerFrame.opacityFunc = button.opacityFunc;
	ColorPickerFrame.opacity = button.opacity;
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity};
	ColorPickerFrame.cancelFunc = button.cancelFunc;
	ShowUIPanel(ColorPickerFrame);
end

function EarthMenu_DisableButton(level, id)
	getglobal("EarthDropDownList"..level.."Button"..id):Disable();
end

function EarthMenu_EnableButton(level, id)
	getglobal("EarthDropDownList"..level.."Button"..id):Enable();
end

function EarthMenu_SetButtonText(level, id, text, r, g, b)
	getglobal("EarthDropDownList"..level.."Button"..id):SetText(text);
	if ( r ) then
		getglobal("EarthDropDownList"..level.."Button"..id.."NormalText"):SetTextColor(r, g, b);
		getglobal("EarthDropDownList"..level.."Button"..id.."HighlightText"):SetTextColor(r, g, b);
	end
end


--[[
--
--	Example Usage Code
--
--
--]]

--[[ List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING] -- The value returned to the info.func when clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, 1]  --  Check the button
info.isTitle = [nil, 1]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, 1]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.hasArrow = [nil, 1]  --  Show the expand arrow for multilevel menus
info.hasColorSwatch = [nil, 1]  --  Show color swatch or not, for color selection
info.r = [1 - 255]  --  Red color value of the color swatch
info.g = [1 - 255]  --  Green color value of the color swatch
info.b = [1 - 255]  --  Blue color value of the color swatch
info.swatchFunc = [function()]  --  Function called by the color picker on color change
info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
]]--

EarthMenu_MenuInfo = { };
EarthMenu_MenuLastValue = 0;

function EarthMenu_DefaultDropDownMenu_OnLoad()
	EarthMenu_Initialize(EarthMenu, EarthMenu_DefaultMenu_Initialize);
	EarthMenu_SetButtonWidth(50);
	EarthMenu_SetWidth(50);
end

function EarthMenu_DefaultDropDownMenu_OnShow()
	EarthMenu_Initialize(this, EarthMenu_DefaultMenu_Initialize);
end	

function EarthMenu_MenuOpen(menulist, anchor, x, y, mode, autoHideDelay, customPoint)
	if ( autoHideDelay ) then EARTHMENU_TEMP_HIDE_TIMEOUT = autoHideDelay; end
	if ( menulist ) then EarthMenu_MenuInfo = menulist; end
	if ( mode ~= EarthMenu.displayMode ) then 
		EarthMenu_Initialize(EarthMenu, EarthMenu_DefaultMenu_Initialize, mode);
	end
	EarthMenu_ToggleDropDownMenu(1, nil, EarthMenu, anchor, x, y, customPoint);
end

function EarthMenu_DefaultMenu_Initialize()
	if ( EARTH_UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
		for index, value in EarthMenu_MenuInfo do
			if (value.text) then
				value.index = index;
				EarthMenu_AddButton(value, 1);
			end
		end
	end
	if ( EARTH_UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		EarthMenu_MenuLastValue = EARTH_UIDROPDOWNMENU_MENU_VALUE;

		for index, value in EarthMenu_MenuInfo[EARTH_UIDROPDOWNMENU_MENU_VALUE] do
			if (type(value) == "table") then
				if (value.text) then
					value.index = index;
					EarthMenu_AddButton(value, 2);
				end
			end
		end
	end
	if ( EARTH_UIDROPDOWNMENU_MENU_LEVEL == 3 ) then
		for index, value in EarthMenu_MenuInfo[EarthMenu_MenuLastValue][EARTH_UIDROPDOWNMENU_MENU_VALUE] do
			if (type(value) == "table") then
				if (value.text) then
					EarthMenu_AddButton(value, 3);
				end
			end
		end
	end
end

function EarthMenu_HideFrame(frameName, level) 
	local frame = getglobal(frameName..level);

	if ( not MouseIsOver(frame) and not Chronos.isScheduledByName("EarthMenuAutoHide"..frameName..(level+1)) ) then 
		frame:Hide();
	else
		for i=level,1,-1 do
			Chronos.scheduleByName("EarthMenuAutoHide"..frameName..i, EARTHMENU_HIDE_TIMEOUT, function() EarthMenu_HideFrame(frameName, i) end );
		end
	end
end
