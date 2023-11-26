--The Options Page variables and functions

--Set color functions
local SCTOptionsFrame_SetColorFunc = {
	[1] = function(x) SCTOptionsFrame_SetColor(1) end,
	[2] = function(x) SCTOptionsFrame_SetColor(2) end,
	[3] = function(x) SCTOptionsFrame_SetColor(3) end,
	[4] = function(x) SCTOptionsFrame_SetColor(4) end,
	[5] = function(x) SCTOptionsFrame_SetColor(5) end,
	[6] = function(x) SCTOptionsFrame_SetColor(6) end,
	[7] = function(x) SCTOptionsFrame_SetColor(7) end,
	[8] = function(x) SCTOptionsFrame_SetColor(8) end,
	[9] = function(x) SCTOptionsFrame_SetColor(9) end,
	[10] = function(x) SCTOptionsFrame_SetColor(10) end,
	[11] = function(x) SCTOptionsFrame_SetColor(11) end,
	[12] = function(x) SCTOptionsFrame_SetColor(12) end,
	[13] = function(x) SCTOptionsFrame_SetColor(13) end,
	[14] = function(x) SCTOptionsFrame_SetColor(14) end,
	[15] = function(x) SCTOptionsFrame_SetColor(15) end,
	[16] = function(x) SCTOptionsFrame_SetColor(16) end,
	[17] = function(x) SCTOptionsFrame_SetColor(17) end,
	[18] = function(x) SCTOptionsFrame_SetColor(18) end
};

local SCTOptionsFrame_CancelColorFunc = {
	[1] = function(x) SCTOptionsFrame_CancelColor(1,x) end,
	[2] = function(x) SCTOptionsFrame_CancelColor(2,x) end,
	[3] = function(x) SCTOptionsFrame_CancelColor(3,x) end,
	[4] = function(x) SCTOptionsFrame_CancelColor(4,x) end,
	[5] = function(x) SCTOptionsFrame_CancelColor(5,x) end,
	[6] = function(x) SCTOptionsFrame_CancelColor(6,x) end,
	[7] = function(x) SCTOptionsFrame_CancelColor(7,x) end,
	[8] = function(x) SCTOptionsFrame_CancelColor(8,x) end,
	[9] = function(x) SCTOptionsFrame_CancelColor(9,x) end,
	[10] = function(x) SCTOptionsFrame_CancelColor(10,x) end,
	[11] = function(x) SCTOptionsFrame_CancelColor(11,x) end,
	[12] = function(x) SCTOptionsFrame_CancelColor(12,x) end,
	[13] = function(x) SCTOptionsFrame_CancelColor(13,x) end,
	[14] = function(x) SCTOptionsFrame_CancelColor(14,x) end,
	[15] = function(x) SCTOptionsFrame_CancelColor(15,x) end,
	[16] = function(x) SCTOptionsFrame_CancelColor(16,x) end,
	[17] = function(x) SCTOptionsFrame_CancelColor(17,x) end,
	[18] = function(x) SCTOptionsFrame_CancelColor(18,x) end
};

--Event and Damage option values
SCTOptionsFrameEventFrames = { };
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT1.name] = { index = 1, tooltipText = SCT_OPTION_EVENT1.tooltipText, SCTVar = "SHOWHIT"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT2.name] = { index = 2, tooltipText = SCT_OPTION_EVENT2.tooltipText, SCTVar = "SHOWMISS"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT3.name] = { index = 3, tooltipText = SCT_OPTION_EVENT3.tooltipText, SCTVar = "SHOWDODGE"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT4.name] = { index = 4, tooltipText = SCT_OPTION_EVENT4.tooltipText, SCTVar = "SHOWPARRY"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT5.name] = { index = 5, tooltipText = SCT_OPTION_EVENT5.tooltipText, SCTVar = "SHOWBLOCK"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT6.name] = { index = 6, tooltipText = SCT_OPTION_EVENT6.tooltipText, SCTVar = "SHOWSPELL"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT7.name] = { index = 7, tooltipText = SCT_OPTION_EVENT7.tooltipText, SCTVar = "SHOWHEAL"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT8.name] = { index = 8, tooltipText = SCT_OPTION_EVENT8.tooltipText, SCTVar = "SHOWRESIST"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT9.name] = { index = 9, tooltipText = SCT_OPTION_EVENT9.tooltipText, SCTVar = "SHOWDEBUFF"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT10.name] = { index = 10, tooltipText = SCT_OPTION_EVENT10.tooltipText, SCTVar = "SHOWABSORB"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT11.name] = { index = 11, tooltipText = SCT_OPTION_EVENT11.tooltipText, SCTVar = "SHOWLOWHP"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT12.name] = { index = 12, tooltipText = SCT_OPTION_EVENT12.tooltipText, SCTVar = "SHOWLOWMANA"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT13.name] = { index = 13, tooltipText = SCT_OPTION_EVENT13.tooltipText, SCTVar = "SHOWPOWER"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT14.name] = { index = 14, tooltipText = SCT_OPTION_EVENT14.tooltipText, SCTVar = "SHOWCOMBAT"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT15.name] = { index = 15, tooltipText = SCT_OPTION_EVENT15.tooltipText, SCTVar = "SHOWCOMBOPOINTS"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT16.name] = { index = 16, tooltipText = SCT_OPTION_EVENT16.tooltipText, SCTVar = "SHOWHONOR"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT17.name] = { index = 17, tooltipText = SCT_OPTION_EVENT17.tooltipText, SCTVar = "SHOWBUFF"};
SCTOptionsFrameEventFrames [SCT_OPTION_EVENT18.name] = { index = 18, tooltipText = SCT_OPTION_EVENT18.tooltipText, SCTVar = "SHOWFADE"};

--Check Button option values
SCTOptionsFrameCheckButtons = { };
SCTOptionsFrameCheckButtons [SCT_OPTION_CHECK1.name] = { index = 1, tooltipText = SCT_OPTION_CHECK1.tooltipText, SCTVar = "ENABLED"};
SCTOptionsFrameCheckButtons [SCT_OPTION_CHECK2.name] = { index = 2, tooltipText = SCT_OPTION_CHECK2.tooltipText, SCTVar = "SHOWSELF"};
SCTOptionsFrameCheckButtons [SCT_OPTION_CHECK3.name] = { index = 3, tooltipText = SCT_OPTION_CHECK3.tooltipText, SCTVar = "SHOWASMESSAGE"};
SCTOptionsFrameCheckButtons [SCT_OPTION_CHECK4.name] = { index = 4, tooltipText = SCT_OPTION_CHECK4.tooltipText, SCTVar = "DIRECTION"};
SCTOptionsFrameCheckButtons [SCT_OPTION_CHECK5.name] = { index = 5, tooltipText = SCT_OPTION_CHECK5.tooltipText, SCTVar = "STICKYCRIT"}
SCTOptionsFrameCheckButtons [SCT_OPTION_CHECK6.name] = { index = 6, tooltipText = SCT_OPTION_CHECK6.tooltipText, SCTVar = "SPELLTYPE"};

--Slider options values
SCTOptionsFrameSliders = { };
SCTOptionsFrameSliders [SCT_OPTION_SLIDER1.name] = { index = 1, SCTVar = "ANIMATIONSPEED", minValue = .005, maxValue = .025, valueStep = .005, minText=SCT_OPTION_SLIDER1.minText, maxText=SCT_OPTION_SLIDER1.maxText, tooltipText = SCT_OPTION_SLIDER1.tooltipText};
SCTOptionsFrameSliders [SCT_OPTION_SLIDER2.name] = { index = 2, SCTVar = "TEXTSIZE", minValue = 12, maxValue = 36, valueStep = 3, minText=SCT_OPTION_SLIDER2.minText, maxText=SCT_OPTION_SLIDER2.maxText, tooltipText = SCT_OPTION_SLIDER2.tooltipText};
SCTOptionsFrameSliders [SCT_OPTION_SLIDER3.name] = { index = 3, SCTVar = "LOWHP", minValue = .1, maxValue = .9, valueStep = .1, minText=SCT_OPTION_SLIDER3.minText, maxText=SCT_OPTION_SLIDER3.maxText, tooltipText = SCT_OPTION_SLIDER3.tooltipText};
SCTOptionsFrameSliders [SCT_OPTION_SLIDER4.name] = { index = 4, SCTVar = "LOWMANA", minValue = .1, maxValue = .9, valueStep = .1, minText=SCT_OPTION_SLIDER4.minText, maxText=SCT_OPTION_SLIDER4.maxText, tooltipText = SCT_OPTION_SLIDER4.tooltipText};
SCTOptionsFrameSliders [SCT_OPTION_SLIDER5.name] = { index = 5, SCTVar = "ALPHA", minValue = .1, maxValue = 1, valueStep = .1, minText=SCT_OPTION_SLIDER5.minText, maxText=SCT_OPTION_SLIDER5.maxText, tooltipText = SCT_OPTION_SLIDER5.tooltipText};


----------------------
--Called when option page loads
function SCTOptionsFrame_OnShow()
	-- Initial Values
	local button, string, checked;
	
	string = getglobal("SCTFrameTitleText");
	string:SetText(SCT_Options.." "..SCT_Version)
	
	-- Set Options values
	for key, value in SCTOptionsFrameEventFrames do
		button = getglobal("SCTOptionsFrame"..value.index.."_CheckButton");
		string = getglobal("SCTOptionsFrame"..value.index.."_CheckButtonText");
		checked = nil;
		button.disabled = nil;
		
		--Check Box
		if ( value.SCTVar ) then
			if ( SCT_Get(value.SCTVar) == 1 ) then
				checked = 1;
			else
				checked = 0;
			end
		else
			checked = 0;
		end
		OptionsFrame_EnableCheckBox(button);
		button:SetChecked(checked);
		string:SetText(key);
		button.tooltipText = value.tooltipText;
		
		--Color Swatch
		local frame,swatch,sRed,sGreen,sBlue,sColor;
		
		frame = getglobal("SCTOptionsFrame"..value.index);
		swatch = getglobal("SCTOptionsFrame"..value.index.."_ColorSwatchNormalTexture");
		
		sColor = SCT_GetColor(value.index);
		sRed = sColor.r;
		sGreen = sColor.g;
		sBlue = sColor.b;

		frame.r = sRed;
		frame.g = sGreen;
		frame.b = sBlue;
		frame.swatchFunc = SCTOptionsFrame_SetColorFunc[value.index];
		frame.cancelFunc = SCTOptionsFrame_CancelColorFunc[value.index];
		swatch:SetVertexColor(sRed,sGreen,sBlue);
	end
	
	-- Set CheckButton states
	for key, value in SCTOptionsFrameCheckButtons do
		button = getglobal("SCTOptionsFrame_CheckButton"..value.index);
		string = getglobal("SCTOptionsFrame_CheckButton"..value.index.."Text");
		checked = nil;
		button.disabled = nil;
		if ( value.SCTVar ) then
			if ( SCT_Get(value.SCTVar) == 1 ) then
				checked = 1;
			else
				checked = 0;
			end
		else
			checked = 0;
		end
		OptionsFrame_EnableCheckBox(button);
		button:SetChecked(checked);
		string:SetText(key);
		button.tooltipText = value.tooltipText;
	end
	
	local slider, string, low, high, getvalue	

	--Set Sliders
	for key, value in SCTOptionsFrameSliders do
		slider = getglobal("SCTOptionsFrame_Slider"..value.index);
		string = getglobal("SCTOptionsFrame_Slider"..value.index.."Text");
		low = getglobal("SCTOptionsFrame_Slider"..value.index.."Low");
		high = getglobal("SCTOptionsFrame_Slider"..value.index.."High");
		getvalue = SCT_Get(value.SCTVar);
		OptionsFrame_EnableSlider(slider);
		slider:SetMinMaxValues(value.minValue, value.maxValue);
		slider:SetValueStep(value.valueStep);
		slider:SetValue(getvalue);
		string:SetText(key);
		low:SetText(value.minText);
		high:SetText(value.maxText);
		slider.tooltipText = value.tooltipText;
	end
	
	local loadprofile
	local i = 1;
	--Sel Save/Load Profile Buttons
	for key, value in SCT_CONFIG do
		if (i > 10) then
			return;
		end
		loadprofile = getglobal("SCTList"..i.."_Name");
		loadprofile:SetText(key);
		i = i + 1;
	end
end

----------------------
--Sets the colors of the config from a color swatch
function SCTOptionsFrame_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("SCTOptionsFrame"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("SCTOptionsFrame"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	--update back to config
	SCT_SetColor(key, r, g, b)
end

----------------------
-- Cancels the color selection
function SCTOptionsFrame_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("SCTOptionsFrame"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("SCTOptionsFrame"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	-- Update back to config
	SCT_SetColor(key, r, g, b)
end

----------------------
--Sets the silder values in the config
function SCT_OptionsSliderOnValueChanged()
	local slider;
	--loop thru slider array to find current one, then update its value	
	for key, value in SCTOptionsFrameSliders do
		if (this:GetName() == "SCTOptionsFrame_Slider"..value.index) then
			slider = getglobal("SCTOptionsFrame_CheckButton"..value.index);
			if ( value.SCTVar ) then
				SCT_Set(value.SCTVar,this:GetValue());
			end
		end
	end
end

----------------------
--Sets the checkbox values in the config
function SCT_OptionsCheckButtonOnClick()
	local button;
	--loop thru event checkbox array to find current one, then update its value
	for index, value in SCTOptionsFrameEventFrames do
		if (this:GetName() == "SCTOptionsFrame"..value.index.."_CheckButton") then
			button = getglobal("SCTOptionsFrame"..value.index.."_CheckButton");
			if ( button:GetChecked() ) then
				value.value = 1;
			else
				value.value = 0;
			end
			if ( value.SCTVar ) then
				SCT_Set(value.SCTVar,value.value);
			end
		end
	end
	--loop thru checkbox array to find current one, then update its value
	for index, value in SCTOptionsFrameCheckButtons do
		if (this:GetName() == "SCTOptionsFrame_CheckButton"..value.index) then
			button = getglobal("SCTOptionsFrame_CheckButton"..value.index);
			if ( button:GetChecked() ) then
				value.value = 1;
			else
				value.value = 0;
			end
			if ( value.SCTVar ) then
				SCT_Set(value.SCTVar,value.value);
			end
		end
	end
end

----------------------
--Open the color selector using show/hide
function SCTSaveList_OnClick()
	local id = this:GetName();
	local profile = getglobal(id.."_Name"):GetText();
	if (SCT_CONFIG[profile]) then
		SCTPlayer = SCT_CONFIG[profile];
		SCT_hideMenu();
		SCT_showMenu();
		SCT_Chat_Message(SCT_PROFILE..profile);
	end
end

----------------------
--Open the color selector using show/hide
function SCT_OpenColorPicker(button)
	CloseMenus();
	if ( not button ) then
		button = this;
	end
	ColorPickerFrame.func = button.swatchFunc;
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity};
	ColorPickerFrame.cancelFunc = button.cancelFunc;
	ColorPickerFrame:Show();
end