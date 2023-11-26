function DAB_Checkbox_Initialize(box, value)
	if (value) then
		box:SetChecked(1);
	else
		box:SetChecked(0);
	end
end

function DAB_Checkbox_OnClick(index, subindex, subindex2, func)
	if (DAB_FloaterOptions:IsVisible() and (not DAB_FLOATER)) then return; end
	local value;
	if (this:GetChecked()) then
		value = true;
	end
	DAB_Set_Option(value, index, subindex, subindex2);
	if (func) then
		index = DAB_Get_OptionsIndex(index);
		func(index);
	end
end

function DAB_ColorPicker_ColorCancelled()
	local color = ColorPickerFrame.previousValues;
	DAB_Set_Option(color, ColorPickerFrame.index, ColorPickerFrame.subindex, ColorPickerFrame.subindex2);
	getglobal(ColorPickerFrame.colorBox):SetBackdropColor(color.r, color.g, color.b);
	if (ColorPickerFrame.initfunc) then
		local index = DAB_Get_OptionsIndex(ColorPickerFrame.index);
		ColorPickerFrame.initfunc(index);
	end
end

function DAB_ColorPicker_ColorChanged()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	local color = { r=r, g=g, b=b };
	DAB_Set_Option(color, ColorPickerFrame.index, ColorPickerFrame.subindex, ColorPickerFrame.subindex2);
	getglobal(ColorPickerFrame.colorBox):SetBackdropColor(color.r, color.g, color.b);
	if (ColorPickerFrame.initfunc) then
		local index = DAB_Get_OptionsIndex(ColorPickerFrame.index);
		ColorPickerFrame.initfunc(index);
	end
end

function DAB_ColorPicker_Initialize(frame, value)
	frame:SetBackdropColor(value.r, value.g, value.b);
end

function DAB_ColorPicker_Show(index, subindex, subindex2, func)
	if (DAB_FloaterOptions:IsVisible() and (not DAB_FLOATER)) then return; end
	local color;
	if (index == "bar") then
		if (subindex2) then
			color = DAB_Settings[DAB_INDEX].Bar[DAB_BAR][subindex][subindex2];
		else
			color = DAB_Settings[DAB_INDEX].Bar[DAB_BAR][subindex];
		end
	elseif (index == "floater") then
		if (subindex2) then
			color = DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER][subindex][subindex2];
		else
			color = DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER][subindex];
		end
	elseif (index == "otherbar") then
		if (subindex2) then
			color = DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR][subindex][subindex2];
		else
			color = DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR][subindex];
		end
	elseif (subindex2) then
		color = DAB_Settings[DAB_INDEX][index][subindex][subindex2];
	elseif (subindex) then
		color = DAB_Settings[DAB_INDEX][index][subindex];
	else
		color = DAB_Settings[DAB_INDEX][index];
	end
	ColorPickerFrame.previousValues = color;
	ColorPickerFrame.cancelFunc = DAB_ColorPicker_ColorCancelled;
	ColorPickerFrame.opacityFunc = DAB_ColorPicker_ColorChanged;
	ColorPickerFrame.func = DAB_ColorPicker_ColorChanged;
	ColorPickerFrame.initfunc = func;
	ColorPickerFrame.colorBox = this:GetName();
	ColorPickerFrame.index = index;
	ColorPickerFrame.subindex = subindex;
	ColorPickerFrame.subindex2 = subindex2;
	ColorPickerFrame:SetColorRGB(color.r, color.g, color.b);
	ColorPickerFrame:ClearAllPoints();
	ColorPickerFrame:SetPoint("RIGHT", "DAB_Options", "LEFT", 0, 0);
	ColorPickerFrame:Show();
end

function DAB_Copy_BackgroundSettings()
	if (not DAB_COPYBAR) then return; end
	if (DAB_COPYBAR == DAB_BAR) then return; end
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].background= {nil};
	DAB_Copy_Table(DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].background, DAB_Settings[DAB_INDEX].Bar[DAB_BAR].background);
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].padding = DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].padding;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].buttonborderalpha = DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].buttonborderalpha;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].buttonborderpadding = DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].buttonborderpadding;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].buttonbordercolor = DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].buttonbordercolor;
	DAB_Bar_Initialize(DAB_BAR);
	DAB_Initialize_BarOptions(DAB_BAR);
	DAB_BackgroundOptions_CopyBGSettings_Setting:SetText("")
	DAB_COPYBAR = nil;
end

function DAB_Copy_BarSettings()
	if (not DAB_COPYBAR) then return; end
	if (DAB_COPYBAR == DAB_BAR) then return; end
	local numbuttons = DAB_Settings[DAB_INDEX].Bar[DAB_BAR].numbuttons;
	local oldtext = DAB_Settings[DAB_INDEX].Bar[DAB_BAR].controlbox.text;
	local oldlabel = DAB_Settings[DAB_INDEX].Bar[DAB_BAR].label.text;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR] = {nil};
	DAB_Copy_Table(DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR], DAB_Settings[DAB_INDEX].Bar[DAB_BAR]);
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].numbuttons = numbuttons;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].controlbox.text = oldtext;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].label.text = oldlabel;
	DAB_Bar_Initialize(DAB_BAR);
	DAB_ControlBox_Initialize(DAB_BAR);
	DAB_Initialize_BarOptions(DAB_BAR);
	DAB_BarOptions_CopyBarSettings_Setting:SetText("")
	DAB_COPYBAR = nil;
end

function DAB_Copy_ControlBoxSettings()
	if (not DAB_COPYBAR) then return; end
	if (DAB_COPYBAR == DAB_BAR) then return; end
	local oldtext = DAB_Settings[DAB_INDEX].Bar[DAB_BAR].controlbox.text;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].controlbox = {nil};
	DAB_Copy_Table(DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].controlbox, DAB_Settings[DAB_INDEX].Bar[DAB_BAR].controlbox);
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].controlbox.text = oldtext;
	DAB_ControlBox_Initialize(DAB_BAR);
	DAB_Initialize_BarOptions(DAB_BAR);
	DAB_ControlBoxOptions_CopyBoxSettings_Setting:SetText("")
	DAB_COPYBAR = nil;
end

function DAB_Copy_LabelSettings()
	if (not DAB_COPYBAR) then return; end
	if (DAB_COPYBAR == DAB_BAR) then return; end
	local oldlabel = DAB_Settings[DAB_INDEX].Bar[DAB_BAR].label.text;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].label = {nil};
	DAB_Copy_Table(DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].label, DAB_Settings[DAB_INDEX].Bar[DAB_BAR].label);
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].hidelabel = DAB_Settings[DAB_INDEX].Bar[DAB_COPYBAR].hidelabel;
	DAB_Settings[DAB_INDEX].Bar[DAB_BAR].label.text = oldlabel;
	DAB_Bar_Initialize(DAB_BAR);
	DAB_Initialize_BarOptions(DAB_BAR);
	DAB_LabelOptions_CopyLabelSettings_Setting:SetText("")
	DAB_COPYBAR = nil;
end

function DAB_EditBox_Initialize(editbox, value)
	if (value) then
		editbox:SetText(value);
	else
		editbox:SetText("");
	end
end

function DAB_EditBox_OnEnterPressed(index, subindex, subindex2, func)
	if (not DAB_INITIALIZED) then return; end
	if (DAB_FloaterOptions:IsVisible() and (not DAB_FLOATER)) then return; end
	local value = this:GetText();
	if (value == "") then value = nil; end
	if (this:GetID() == 1) then
		if (not DAB_UNITIDS[value]) then
			this:SetText("");
			value = nil;
		end
	elseif (this:GetID() == 2) then
		value = tonumber(value);
		if (not value) then
			this:SetText("");
		elseif (value < 1 or value > 120) then
			value = nil;
			this:SetText("");
		end
	end
	DAB_Set_Option(value, index, subindex, subindex2);
	this.prevvalue = value;
	this:ClearFocus();
	if (func) then
		index = DAB_Get_OptionsIndex(index);
		func(index);
	end
end

function DAB_Get_FreeButton()
	local button;
	for i, v in DAB_FREE_BUTTONS do
		if (v) then
			if (button) then
				if (i > button) then	
					button = i;
				end
			else
				button = i;
			end
		end
	end
	return button;
end

function DAB_Get_OptionsIndex(index)
	if (index == "bar") then
		return DAB_BAR;
	elseif (index == "floater") then 
		return DAB_FLOATER;
	elseif (index == "otherbar") then
		return DAB_OTHERBAR;
	else
		return index;
	end
end

function DAB_Initialize_BarOptions()
	local settings = DAB_Settings[DAB_INDEX].Bar[DAB_BAR];
	local text = string.gsub(DAB_TEXT.BarOptions, '$n', DAB_BAR);
	DAB_OptionsTitle_Label:SetText(text);
	DAB_BarOptions_ButtonRows:SetMinMaxValues(1, settings.numbuttons);
	DAB_BarOptions_ButtonRowsHigh:SetText(settings.numbuttons);
	DAB_Checkbox_Initialize(DAB_BarOptions_ForceTarget, settings.ForceTarget);
	DAB_Checkbox_Initialize(DAB_BarOptions_AutoAttack, settings.AutoAttack);
	DAB_Checkbox_Initialize(DAB_BarOptions_Hide, settings.hide);
	DAB_Checkbox_Initialize(DAB_BarOptions_HideEmpty, settings.hideempty);
	DAB_Checkbox_Initialize(DAB_BarOptions_CollapseEmpty, settings.collapse);
	DAB_Checkbox_Initialize(DAB_BarOptions_HideOnClick, settings.hideonclick);
	DAB_Checkbox_Initialize(DAB_BarOptions_ShowInCombat, settings.incombat);
	DAB_Checkbox_Initialize(DAB_BarOptions_ShowOutOfCombat, settings.notincombat);
	DAB_Checkbox_Initialize(DAB_BarOptions_ShowForFriendly, settings.friendlytarget);
	DAB_Checkbox_Initialize(DAB_BarOptions_ShowForHostile, settings.hostiletarget);
	DAB_Checkbox_Initialize(DAB_BarOptions_OneTrue, settings.onetrue);
	DAB_Checkbox_Initialize(DAB_BarOptions_ShowOnMouseover, settings.mouseoverbar);
	DAB_Checkbox_Initialize(DAB_BarOptions_ShowWhileKeyIsPressed, settings.showonkeypress);
	DAB_MenuControl_Initialize(DAB_BarOptions_RightClickBar, settings.rightclick);
	DAB_MenuControl_Initialize(DAB_BarOptions_MiddleClickBar, settings.middleclick);
	DAB_EditBox_Initialize(DAB_BarOptions_DefaultTarget, settings.target);
	DAB_Slider_Initialize(DAB_BarOptions_ButtonSize,settings.size);
	DAB_Slider_Initialize(DAB_BarOptions_ButtonAlpha,settings.alpha * 100);
	DAB_Slider_Initialize(DAB_BarOptions_ButtonHSpacing,settings.spacingh);
	DAB_Slider_Initialize(DAB_BarOptions_ButtonVSpacing,settings.spacingv);
	DAB_Slider_Initialize(DAB_BarOptions_ButtonRows,settings.rows);
	DAB_Slider_Initialize(DAB_BarOptions_CCHeight,settings.ccfontsize);
	DAB_MenuControl_Initialize(DAB_BarOptions_AnchorFrame, settings.attachframe);
	DAB_MenuControl_Initialize(DAB_BarOptions_AnchorPoint, settings.attachpoint);
	DAB_MenuControl_Initialize(DAB_BarOptions_AnchorTo, settings.attachto);
	DAB_Slider_Initialize(DAB_BarOptions_XOffset,settings.attachoffsetx);
	DAB_Slider_Initialize(DAB_BarOptions_YOffset,settings.attachoffsety);
	DAB_MenuControl_Initialize(DAB_BarOptions_Forms, settings.form);
	DAB_MenuControl_Initialize(DAB_BarOptions_FormMethod, settings.formmethod);
	DAB_MenuControl_Initialize(DAB_BackgroundOptions_Style, settings.background.style);
	DAB_ColorPicker_Initialize(DAB_BackgroundOptions_Color, settings.background.color);
	DAB_EditBox_Initialize(DAB_BackgroundOptions_Texture, settings.background.texture);
	DAB_Slider_Initialize(DAB_BackgroundOptions_Alpha, settings.background.alpha * 100);
	DAB_Slider_Initialize(DAB_BackgroundOptions_Padding, settings.padding);
	DAB_ColorPicker_Initialize(DAB_BackgroundOptions_BorderColor, settings.background.bordercolor);
	DAB_EditBox_Initialize(DAB_BackgroundOptions_BorderTexture, settings.background.bordertexture);
	DAB_Slider_Initialize(DAB_BackgroundOptions_BorderAlpha, settings.background.borderalpha * 100);
	DAB_ColorPicker_Initialize(DAB_BackgroundOptions_ButtonBorderColor, settings.buttonbordercolor);
	DAB_Slider_Initialize(DAB_BackgroundOptions_ButtonBorderAlpha, settings.buttonborderalpha * 100);
	DAB_Slider_Initialize(DAB_BackgroundOptions_ButtonBorderPadding, settings.buttonborderpadding);
	DAB_EditBox_Initialize(DAB_ControlBoxOptions_Text,settings.controlbox.text);
	DAB_ColorPicker_Initialize(DAB_ControlBoxOptions_TextColor,settings.controlbox.textcolor);
	DAB_ColorPicker_Initialize(DAB_ControlBoxOptions_BackgroundColor,settings.controlbox.bgcolor);
	DAB_ColorPicker_Initialize(DAB_ControlBoxOptions_BorderColor,settings.controlbox.bordercolor);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_Hide,settings.controlbox.hide);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_ShowBarOnClick,settings.controlbox.baronclick);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_HideOtherBars,settings.controlbox.hideotherbars);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_ShowBarOnMouseover,settings.controlbox.mouseovershowbar);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_RecolorOnMouseover,settings.controlbox.recolor);
	DAB_ColorPicker_Initialize(DAB_ControlBoxOptions_MouseoverBGColor,settings.controlbox.mouseovercolor);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_RecolorTextOnMouseover,settings.controlbox.textrecolor);
	DAB_ColorPicker_Initialize(DAB_ControlBoxOptions_MouseoverTextColor,settings.controlbox.textmouseovercolor);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_ShowTopBorder,settings.controlbox.top);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_ShowBottomBorder,settings.controlbox.bottom);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_ShowLeftBorder,settings.controlbox.left);
	DAB_Checkbox_Initialize(DAB_ControlBoxOptions_ShowRightBorder,settings.controlbox.right);
	DAB_EditBox_Initialize(DAB_ControlBoxOptions_MacroOnClick,settings.controlbox.macroonclick);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_Height, settings.controlbox.height);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_Width, settings.controlbox.width);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_TextAlpha, settings.controlbox.alpha * 100);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_TextSize, settings.controlbox.fontheight);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_BackgroundAlpha, settings.controlbox.bgalpha * 100);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_BorderAlpha, settings.controlbox.borderalpha * 100);
	DAB_MenuControl_Initialize(DAB_ControlBoxOptions_AnchorFrame, settings.controlbox.attachframe);
	DAB_MenuControl_Initialize(DAB_ControlBoxOptions_AnchorPoint, settings.controlbox.attachpoint);
	DAB_MenuControl_Initialize(DAB_ControlBoxOptions_AnchorTo, settings.controlbox.attachto);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_XOffset, settings.controlbox.attachoffsetx);
	DAB_Slider_Initialize(DAB_ControlBoxOptions_YOffset, settings.controlbox.attachoffsety);
	DAB_EditBox_Initialize(DAB_LabelOptions_Text,settings.label.text);
	DAB_ColorPicker_Initialize(DAB_LabelOptions_TextColor,settings.label.color);
	DAB_ColorPicker_Initialize(DAB_LabelOptions_BackgroundColor,settings.label.bgcolor);
	DAB_ColorPicker_Initialize(DAB_LabelOptions_BorderColor,settings.label.bordercolor);
	DAB_Checkbox_Initialize(DAB_LabelOptions_Hide,settings.hidelabel);
	DAB_Slider_Initialize(DAB_LabelOptions_TextSize, settings.label.textsize);
	DAB_Slider_Initialize(DAB_LabelOptions_TextAlpha, settings.label.alpha * 100);
	DAB_Slider_Initialize(DAB_LabelOptions_BackgroundAlpha, settings.label.bgalpha * 100);
	DAB_Slider_Initialize(DAB_LabelOptions_BorderAlpha, settings.label.borderalpha * 100);
	DAB_Slider_Initialize(DAB_LabelOptions_XOffset, settings.label.attachoffsetx);
	DAB_Slider_Initialize(DAB_LabelOptions_YOffset, settings.label.attachoffsety);
	DAB_MenuControl_Initialize(DAB_LabelOptions_AnchorTo, settings.label.attachto);
	DAB_MenuControl_Initialize(DAB_LabelOptions_AnchorPoint, settings.label.attachpoint);
	DAB_BAR_SLIDER_INIT = true;
end

function DAB_Initialize_FloaterOptions(button)
	local settings = DAB_Settings[DAB_INDEX].Floaters[button];
	DAB_Checkbox_Initialize(DAB_FloaterOptions_Hide, settings.hide);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_ForceTarget, settings.ForceTarget);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_AutoAttack, settings.AutoAttack);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_HideOnClick, settings.hideonclick);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_ShowOnKeypress, settings.showonkeypress);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_FriendlyTarget, settings.friendlytarget);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_HostileTarget, settings.hostiletarget);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_InCombat, settings.incombat);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_OneTrue, settings.onetrue);
	DAB_Checkbox_Initialize(DAB_FloaterOptions_NotInCombat, settings.notincombat);
	DAB_ColorPicker_Initialize(DAB_FloaterOptions_BorderColor, settings.bordercolor);
	DAB_EditBox_Initialize(DAB_FloaterOptions_DefaultTarget, settings.target);
	DAB_EditBox_Initialize(DAB_FloaterOptions_MiddleClickButton, settings.middleclick);
	DAB_EditBox_Initialize(DAB_FloaterOptions_RightClickButton, settings.rightclick);
	DAB_EditBox_Initialize(DAB_FloaterOptions_AnchorButton, settings.attachbutton);
	DAB_MenuControl_Initialize(DAB_FloaterOptions_AnchorFrame, settings.attachframe);
	DAB_MenuControl_Initialize(DAB_FloaterOptions_AnchorPoint, settings.attachpoint);
	DAB_MenuControl_Initialize(DAB_FloaterOptions_AnchorTo, settings.attachto);
	DAB_MenuControl_Initialize(DAB_FloaterOptions_Forms, settings.form);
	DAB_Slider_Initialize(DAB_FloaterOptions_ButtonBorderAlpha, settings.borderalpha * 100);
	DAB_Slider_Initialize(DAB_FloaterOptions_ButtonAlpha, settings.alpha * 100);
	DAB_Slider_Initialize(DAB_FloaterOptions_ButtonSize, settings.size);
	DAB_Slider_Initialize(DAB_FloaterOptions_BorderPadding, settings.borderpadding);
	DAB_Slider_Initialize(DAB_FloaterOptions_XOffset, settings.attachoffsetx);
	DAB_Slider_Initialize(DAB_FloaterOptions_YOffset, settings.attachoffsety);
end

function DAB_Initialize_OtherBarOptions()
	local settings = DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR];
	DAB_Checkbox_Initialize(DAB_OtherBarOptions_Hide, settings.hide);
	DAB_Checkbox_Initialize(DAB_OtherBarOptions_ShowOnMouseover, settings.mouseoverbar);
	DAB_MenuControl_Initialize(DAB_OtherBarOptions_Layout, settings.layout);
	DAB_Slider_Initialize(DAB_OtherBarOptions_ButtonSize,settings.size);
	DAB_Slider_Initialize(DAB_OtherBarOptions_ButtonAlpha,settings.alpha * 100);
	DAB_Slider_Initialize(DAB_OtherBarOptions_ButtonHSpacing,settings.spacingh);
	DAB_Slider_Initialize(DAB_OtherBarOptions_ButtonVSpacing,settings.spacingv);
	DAB_MenuControl_Initialize(DAB_OtherBarOptions_AnchorFrame, settings.attachframe);
	DAB_MenuControl_Initialize(DAB_OtherBarOptions_AnchorPoint, settings.attachpoint);
	DAB_MenuControl_Initialize(DAB_OtherBarOptions_AnchorTo, settings.attachto);
	DAB_Slider_Initialize(DAB_OtherBarOptions_XOffset,settings.attachoffsetx);
	DAB_Slider_Initialize(DAB_OtherBarOptions_YOffset,settings.attachoffsety);
	DAB_MenuControl_Initialize(DAB_OtherBackgroundOptions_Style, settings.background.style);
	DAB_ColorPicker_Initialize(DAB_OtherBackgroundOptions_Color, settings.background.color);
	DAB_EditBox_Initialize(DAB_OtherBackgroundOptions_Texture, settings.background.texture);
	DAB_Slider_Initialize(DAB_OtherBackgroundOptions_Alpha, settings.background.alpha * 100);
	DAB_Slider_Initialize(DAB_OtherBackgroundOptions_Padding, settings.padding);
	DAB_ColorPicker_Initialize(DAB_OtherBackgroundOptions_BorderColor, settings.background.bordercolor);
	DAB_EditBox_Initialize(DAB_OtherBackgroundOptions_BorderTexture, settings.background.bordertexture);
	DAB_Slider_Initialize(DAB_OtherBackgroundOptions_BorderAlpha, settings.background.borderalpha * 100);
	DAB_EditBox_Initialize(DAB_OtherLabelOptions_Text,settings.label.text);
	DAB_ColorPicker_Initialize(DAB_OtherLabelOptions_TextColor,settings.label.color);
	DAB_ColorPicker_Initialize(DAB_OtherLabelOptions_BackgroundColor,settings.label.bgcolor);
	DAB_ColorPicker_Initialize(DAB_OtherLabelOptions_BorderColor,settings.label.bordercolor);
	DAB_Checkbox_Initialize(DAB_OtherLabelOptions_Hide,settings.hidelabel);
	DAB_Slider_Initialize(DAB_OtherLabelOptions_TextSize, settings.label.textsize);
	DAB_Slider_Initialize(DAB_OtherLabelOptions_TextAlpha, settings.label.alpha * 100);
	DAB_Slider_Initialize(DAB_OtherLabelOptions_BackgroundAlpha, settings.label.bgalpha * 100);
	DAB_Slider_Initialize(DAB_OtherLabelOptions_BorderAlpha, settings.label.borderalpha * 100);
	DAB_Slider_Initialize(DAB_OtherLabelOptions_XOffset, settings.label.attachoffsetx);
	DAB_Slider_Initialize(DAB_OtherLabelOptions_YOffset, settings.label.attachoffsety);
	DAB_MenuControl_Initialize(DAB_OtherLabelOptions_AnchorTo, settings.label.attachto);
	DAB_MenuControl_Initialize(DAB_OtherLabelOptions_AnchorPoint, settings.label.attachpoint);
end

function DAB_Menu_OnClick()
	if (DAB_FloaterOptions:IsVisible() and (not DAB_FLOATER)) then return; end
	this:GetParent():Hide();
	getglobal(DAB_DropMenu.controlbox.."_Setting"):SetText(getglobal(this:GetName().."_Text"):GetText());
	if (DAB_DropMenu.index == "EventMacros") then
		DAB_MACRO_EVENT = this.value;
		if (DAB_Settings[DAB_INDEX].EventMacros[this.value]) then
			DAB_OnEventMacros_ScrollFrame_Text:SetText(DAB_Settings[DAB_INDEX].EventMacros[this.value]);
		else
			DAB_OnEventMacros_ScrollFrame_Text:SetText("");
		end
		DAB_OnEventMacros_ScrollFrame_Text:SetFocus();
		return;
	elseif (DAB_DropMenu.index == "BarToEdit") then
		DAB_OTHERBAR = this.value;
		DAB_Initialize_OtherBarOptions();
		return;
	elseif (DAB_DropMenu.index == "CopyBar") then
		DAB_COPYBAR = this.value;
		return;
	elseif (DAB_DropMenu.index == "SavedSettings") then
		DAB_SETTINGS_INDEX = this.value;
		return;
	elseif (DAB_DropMenu.index == "bar" and DAB_DropMenu.subindex == "form") then
		if (DAB_BAR == DAB_Settings[DAB_INDEX].MainBar) then
			this.value = nil;
			getglobal(DAB_DropMenu.controlbox.."_Setting"):SetText("");
			DAB_Debug("You can't set the Main Bar to use a shapeshift form.");
		end
	end
	DAB_Set_Option(this.value, DAB_DropMenu.index, DAB_DropMenu.subindex, DAB_DropMenu.subindex2);
	if (DAB_DropMenu.func) then
		local index = DAB_Get_OptionsIndex(DAB_DropMenu.index);
		DAB_DropMenu.func(index);
	end
end

function DAB_Menu_Show(menu, index, subindex, subindex2, func, controlbox)
	if (DAB_FloaterOptions:IsVisible() and (not DAB_FLOATER)) then return; end
	if (not menu) then return; end
	if (menu == "forms") then
		if (index == "bar" and DAB_Settings[DAB_INDEX].MainBar == DAB_BAR) then
			DAB_Feedback(DAB_TEXT.MainBarWarning);
			return;
		end
		menu = DAB_MENU_FORMS;
	elseif (menu == "SavedSettings") then
		menu = DAB_MENU_SAVEDSETTINGS;
	end
	if (DAB_DropMenu:IsVisible()) then
		DAB_DropMenu:Hide();
		return;
	end
	DAB_DropMenu.func = func;
	DAB_DropMenu.index = index;
	DAB_DropMenu.subindex = subindex;
	DAB_DropMenu.subindex2 = subindex2;
	DAB_DropMenu.controlbox = controlbox;
	local width = 0;
	local count = 1;
	local textwidth;
	for _,v in menu do
		getglobal("DAB_DropMenu_Option"..count):Show();
		getglobal("DAB_DropMenu_Option"..count.."_Text"):SetText(v.text);
		getglobal("DAB_DropMenu_Option"..count).value =v.value;
		textwidth = getglobal("DAB_DropMenu_Option"..count.."_Text"):GetWidth();
		if (textwidth > width) then
			width = textwidth;
		end
		count = count + 1;
	end
	for i=1, 40 do
		if (i < count) then
			getglobal("DAB_DropMenu_Option"..i):SetWidth(width);
		else
			getglobal("DAB_DropMenu_Option"..i):Hide();			
		end
	end
	count = count - 1;
	DAB_DropMenu:SetWidth(width + 20);
	DAB_DropMenu:SetHeight(count * 15 + 20);
	DAB_DropMenu:ClearAllPoints();
	DAB_DropMenu:SetPoint("TOPRIGHT", controlbox, "BOTTOMRIGHT", 0, 0);
	if (DAB_DropMenu:GetBottom() < UIParent:GetBottom()) then
		local yoffset = UIParent:GetBottom() - DAB_DropMenu:GetBottom();
		DAB_DropMenu:ClearAllPoints();
		DAB_DropMenu:SetPoint("TOPRIGHT", controlbox, "BOTTOMRIGHT", 0, yoffset);
	end
	DAB_DropMenu:Show();
end

function DAB_Menu_TimeOut(elapsed)
	if (this.timer) then
		this.timer = this.timer - elapsed;
		if (this.timer < 0) then
			this.timer = nil;
			this:Hide();
		end
	end
end

function DAB_MenuControl_Initialize(menucontrol, value)
	if (not menucontrol.menu) then return; end
	local menu = menucontrol.menu;
	if (menucontrol.menu == "forms") then
		menu = DAB_MENU_FORMS;
	end
	local text;
	for _,v in menu do
		if (v.value == value) then
			text = v.text;
			break;
		end
	end
	getglobal(menucontrol:GetName().."_Setting"):SetText(text);
end

function DAB_NextFloaterButton_OnLoad()
	this:SetText(">");
end

function DAB_Nudge_Down(frametype)
	local frame, settings, func, num, slider = DAB_Nudge_GetInfo(frametype);
	if (settings.attachframe) then
		settings.attachoffsety = settings.attachoffsety - 1;
		DAB_Slider_Initialize(getglobal(slider.."YOffset"), settings.attachoffsety);
	else
		DAB_Settings[DAB_INDEX].FrameLocation[frame].y = DAB_Settings[DAB_INDEX].FrameLocation[frame].y - 1;
	end
	func(num);
end

function DAB_Nudge_GetInfo(frametype)
	local frame, settings, func, num, slider;
	if (frametype == "bar") then
		frame = "DAB_ActionBar_"..DAB_BAR;
		settings = DAB_Settings[DAB_INDEX].Bar[DAB_BAR];
		num = DAB_BAR;
		func = DAB_Bar_Initialize;
		slider = "DAB_BarOptions_";
	elseif (frametype == "floater") then
		frame = "DAB_ActionButton_"..DAB_FLOATER;
		settings = DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER];
		num = DAB_FLOATER;
		func = DAB_Floater_Initialize;
		slider = "DAB_FloaterOptions_";
	elseif (frametype == "controlbox") then
		frame = "DAB_ControlBox_"..DAB_BAR;
		settings = DAB_Settings[DAB_INDEX].Bar[DAB_BAR].controlbox;
		num = DAB_BAR;
		func = DAB_ControlBox_Initialize;
		slider = "DAB_ControlBoxOptions_";
	elseif (frametype == "otherbar") then
		local otherbar = DAB_Get_OtherBar(DAB_OTHERBAR)
		frame = "DAB_OtherBar_"..otherbar;
		settings = DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR];
		num = DAB_OTHERBAR;
		func = DAB_OtherBar_Initialize;
		slider = "DAB_OtherBarOptions_";
	end
	return frame, settings, func, num, slider;
end

function DAB_Nudge_Left(frametype)
	local frame, settings, func, num, slider = DAB_Nudge_GetInfo(frametype);
	if (settings.attachframe) then
		settings.attachoffsetx = settings.attachoffsetx - 1;
		DAB_Slider_Initialize(getglobal(slider.."XOffset"), settings.attachoffsetx);
	else
		DAB_Settings[DAB_INDEX].FrameLocation[frame].x = DAB_Settings[DAB_INDEX].FrameLocation[frame].x - 1;
	end
	func(num);
end

function DAB_Nudge_Right(frametype)
	local frame, settings, func, num, slider = DAB_Nudge_GetInfo(frametype);
	if (settings.attachframe) then
		settings.attachoffsetx = settings.attachoffsetx + 1;
		DAB_Slider_Initialize(getglobal(slider.."XOffset"), settings.attachoffsetx);
	else
		DAB_Settings[DAB_INDEX].FrameLocation[frame].x = DAB_Settings[DAB_INDEX].FrameLocation[frame].x + 1;
	end
	func(num);
end

function DAB_Nudge_Up(frametype)
	local frame, settings, func, num, slider = DAB_Nudge_GetInfo(frametype);
	if (settings.attachframe) then
		settings.attachoffsety = settings.attachoffsety + 1;
		DAB_Slider_Initialize(getglobal(slider.."YOffset"), settings.attachoffsety);
	else
		DAB_Settings[DAB_INDEX].FrameLocation[frame].y = DAB_Settings[DAB_INDEX].FrameLocation[frame].y + 1;
	end
	func(num);
end

function DAB_Options_AddButton(bar, override)
	local button = DAB_Get_FreeButton();
	if (not button) then return; end
	DAB_Settings[DAB_INDEX].Button[button] = bar;
	DAB_Settings[DAB_INDEX].Bar[bar].numbuttons = DAB_Settings[DAB_INDEX].Bar[bar].numbuttons + 1;
	DAB_FREE_BUTTONS[button] = nil;
	DAB_Initialize_NumButtonsOptions();
	if (not override) then
		DAB_Bar_Initialize(bar);
		DAB_UpdateKeybindingLabels();
		DAB_UpdateKeybindings();
	end
end

function DAB_Options_DeleteFloater()
	if (not DAB_FLOATER) then return; end
	DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER] = nil;
	getglobal("DAB_ActionButton_"..DAB_FLOATER):ClearAllPoints();
	getglobal("DAB_ActionButton_"..DAB_FLOATER):SetPoint("TOP", "UIParent", "BOTTOM", 0, -200);
	DAB_Update_FrameLocation("DAB_ActionButton_"..DAB_FLOATER);
	DAB_FREE_BUTTONS[DAB_FLOATER] = true;
	DAB_Settings[DAB_INDEX].Button[DAB_FLOATER] = nil;
	DAB_FLOATER = nil;
	DAB_CurrentFloater_Text:SetText("");
	DAB_Initialize_NumButtonsOptions();
	DAB_UpdateKeybindingLabels();
	DAB_UpdateKeybindings();
	DAB_FloaterOptions_Icon_Texture:SetTexture("");
end

function DAB_Options_GetNewFloater()
	local button = DAB_Get_FreeButton();
	if (not button) then return; end
	DAB_Settings[DAB_INDEX].Button[button] = "floater";
	getglobal("DAB_ActionButton_"..button):ClearAllPoints();
	getglobal("DAB_ActionButton_"..button):SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
	DAB_Update_FrameLocation("DAB_ActionButton_"..button);
	DAB_Floater_InitializeSettings(button);
	DAB_Floater_Initialize(button);
	DAB_FLOATER = button;
	DAB_CurrentFloater_Text:SetText(DAB_FLOATER);
	local count = 1;
	for i in DAB_Settings[DAB_INDEX].Floaters do
		if (i == button) then break; end
		count = count + 1;
	end
	DAB_FLOATER_COUNT = count;
	DAB_Initialize_NumButtonsOptions();
	DAB_FREE_BUTTONS[button] = nil;
	DAB_Initialize_FloaterOptions(button);
	DAB_UpdateKeybindingLabels();
	DAB_UpdateKeybindings();
	local texture = GetActionTexture(DAB_FLOATER);
	DAB_FloaterOptions_Icon_Texture:SetTexture(texture);
end

function DAB_Options_GetNextFloater()
	if (not DAB_Settings[DAB_INDEX].Floaters) then
		return;
	end
	local low, high;
	for i in DAB_Settings[DAB_INDEX].Floaters do
		if (not low) then low = i; end
		if (not high) then high = i; end
		if (i < low) then low = i; end
		if (i > high) then high = i; end
	end
	if (not low) then return; end
	if (not DAB_FLOATER) then
		DAB_FLOATER = low;
	else
		for i=1,120 do
			DAB_FLOATER = DAB_FLOATER + 1;
			if (DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER]) then break; end
		end
		if (DAB_FLOATER > high) then
			DAB_FLOATER = low;
		end
	end
	DAB_CurrentFloater_Text:SetText(DAB_FLOATER);
	DAB_Initialize_FloaterOptions(DAB_FLOATER);
	local texture = GetActionTexture(DAB_FLOATER);
	DAB_FloaterOptions_Icon_Texture:SetTexture(texture);
end

function DAB_Options_GetPrevFloater()
	if (not DAB_Settings[DAB_INDEX].Floaters) then
		return;
	end
	local low, high;
	for i in DAB_Settings[DAB_INDEX].Floaters do
		if (not low) then low = i; end
		if (not high) then high = i; end
		if (i < low) then low = i; end
		if (i > high) then high = i; end
	end
	if (not low) then return; end
	if (not DAB_FLOATER) then
		DAB_FLOATER = high;
	else
		for i=1,120 do
			DAB_FLOATER = DAB_FLOATER - 1;
			if (DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER]) then break; end
		end
		if (DAB_FLOATER < low) then
			DAB_FLOATER = high;
		end
	end
	DAB_CurrentFloater_Text:SetText(DAB_FLOATER);
	DAB_Initialize_FloaterOptions(DAB_FLOATER);
	local texture = GetActionTexture(DAB_FLOATER);
	DAB_FloaterOptions_Icon_Texture:SetTexture(texture);
end

function DAB_Options_LoadDefaultSettings()
	DAB_Settings[DAB_INDEX] = {};
	DAB_Initialize_DefaultSettings();
	DAB_Initialize_AllSettings();
	DAB_Feedback(DAB_TEXT.DefaultSettingsLoaded);
end

function DAB_Options_DeleteSettings()
	if (not DAB_SETTINGS_INDEX) then return; end
	DAB_Settings.SavedSettings[DAB_SETTINGS_INDEX] = nil;
	DAB_Initialize_SavedSettingsMenu();
	DAB_Feedback(DAB_TEXT.SettingsDeleted);
end

function DAB_Options_LoadSettings(index)
	if (not index) then
		index = DAB_SETTINGS_INDEX;
	end
	if (not index) then return;  end
	if (not DAB_Settings.SavedSettings[index]) then return; end
	DAB_Settings[DAB_INDEX] = {};
	DAB_Copy_Table(DAB_Settings.SavedSettings[index], DAB_Settings[DAB_INDEX]);
	DAB_Initialize_AllSettings();
	DAB_Feedback(DAB_TEXT.SettingsLoaded);
end

function DAB_Options_ModifyCooldownScales()
	local scale, size;
	for i=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[i] == "floater" and DAB_Settings[DAB_INDEX].Floaters[i]) then
			size = DAB_Settings[DAB_INDEX].Floaters[i].size;
		elseif (DAB_Settings[DAB_INDEX].Button[i]) then
			size = DAB_Settings[DAB_INDEX].Bar[DAB_Settings[DAB_INDEX].Button[i]].size;
		else
			size = nil;
		end
		if (size) then
			scale = size / 36 * .85;
			if (DAB_Settings[DAB_INDEX].ModifyCooldownByUIScale) then
				scale = scale * UIParent:GetScale();
			end
			getglobal("DAB_ActionButton_"..i.."Cooldown").cdscale = scale;
			getglobal("DAB_ActionButton_"..i.."Cooldown"):SetScale(scale);
		end
	end
end

function DAB_Options_SaveSettings(index)
	if (not index) then
		index = DAB_MiscOptions_SettingsName:GetText();
	end
	DAB_Settings.SavedSettings[index] = {};
	DAB_Copy_Table(DAB_Settings[DAB_INDEX], DAB_Settings.SavedSettings[index]);
	DAB_Initialize_SavedSettingsMenu();
	DAB_Feedback(DAB_TEXT.SettingsSaved);
end

function DAB_Options_RemoveAllButtons()
	for i=1, DAB_NUMBER_OF_BARS do
		if (DAB_Settings[DAB_INDEX].Bar[i].numbuttons > 0) then
			for x=1, DAB_Settings[DAB_INDEX].Bar[i].numbuttons do
				DAB_Options_RemoveButton(i, 1);
			end
		end
	end
	for i=1, DAB_NUMBER_OF_BARS do
		DAB_Bar_Initialize(i);
	end
	DAB_UpdateKeybindingLabels();
	DAB_UpdateKeybindings();
end

function DAB_Options_RemoveButton(bar, override)
	if (DAB_Settings[DAB_INDEX].Bar[bar].numbuttons == 0) then return; end
	local button;
	for i=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[i] == bar) then
			button = i;
		end
	end
	DAB_Settings[DAB_INDEX].Button[button] = nil;
	DAB_FREE_BUTTONS[button] = true;
	DAB_Settings[DAB_INDEX].Bar[bar].numbuttons = DAB_Settings[DAB_INDEX].Bar[bar].numbuttons - 1;
	if (DAB_Settings[DAB_INDEX].Bar[bar].rows > DAB_Settings[DAB_INDEX].Bar[bar].numbuttons) then
		DAB_Settings[DAB_INDEX].Bar[bar].rows = DAB_Settings[DAB_INDEX].Bar[bar].numbuttons;
		if (DAB_Settings[DAB_INDEX].Bar[bar].rows == 0) then
			DAB_Settings[DAB_INDEX].Bar[bar].rows = 1;
		end
	end
	DAB_Initialize_NumButtonsOptions();
	getglobal("DAB_ActionButton_"..button):ClearAllPoints();
	getglobal("DAB_ActionButton_"..button):SetPoint("TOP", "UIParent", "BOTTOM", 0, -200);
	DAB_Update_FrameLocation("DAB_ActionButton_"..button);
	if (not override) then
		DAB_Bar_Initialize(bar);
		DAB_UpdateKeybindingLabels();
		DAB_UpdateKeybindings();
	end
end

function DAB_Options_SetScale()
	DAB_Options.scale = DAB_Settings[DAB_INDEX].OptionsScale / 100 * UIParent:GetScale();
end

function DAB_PreviousFloaterButton_OnLoad()
	this:SetText("<");
end

function DAB_Set_Anchor(subframe, xoffset, yoffset)
	xoffset = getglobal(this:GetName().."_Label"):GetWidth() + xoffset + 5;
	this:SetPoint("TOPLEFT", this:GetParent():GetName()..subframe, "BOTTOMLEFT", xoffset, yoffset);
end

function DAB_Set_Label(text)
	getglobal(this:GetName().."_Label"):SetText(text);
end

function DAB_Set_Option(value, index, subindex, subindex2)
	if (index == "bar") then
		if (subindex2) then
			DAB_Settings[DAB_INDEX].Bar[DAB_BAR][subindex][subindex2] = value;
		elseif (subindex) then
			DAB_Settings[DAB_INDEX].Bar[DAB_BAR][subindex] = value;
		end
	elseif (index == "floater") then
		if (subindex2) then
			DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER][subindex][subindex2] = value;
		elseif (subindex) then
			DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER][subindex] = value;
		end
	elseif (index == "otherbar") then
		if (subindex2) then
			DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR][subindex][subindex2] = value;
		elseif (subindex) then
			DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR][subindex] = value;
		end
	elseif (subindex2) then
		DAB_Settings[DAB_INDEX][index][subindex][subindex2] = value;
	elseif (subindex) then
		DAB_Settings[DAB_INDEX][index][subindex] = value;
	elseif (index) then
		DAB_Settings[DAB_INDEX][index] = value;
	end
end

function DAB_Show_OptionsFrame(frame)
	if (frame == "main") then
		if (DAB_Options:IsVisible()) then
			DAB_Options:Hide();
		else
			DAB_Options:Show();
		end
	else
		DAB_BarOptionsHeader:Hide();
		DAB_MiscOptions:Hide();
		DAB_NumButtonsOptions:Hide();
		DAB_FloaterOptions:Hide();
		DAB_OnEventMacros:Hide();
		DAB_OtherBarOptionsHeader:Hide();
		if (frame == "misc") then
			DAB_MiscOptions:Show();
			DAB_OptionsTitle_Label:SetText(DAB_TEXT.MiscOptionsHeader);
		elseif (frame == "numbuttons") then
			DAB_NumButtonsOptions:Show();
			DAB_OptionsTitle_Label:SetText(DAB_TEXT.NumButtonsHeader);
		elseif (frame == "floaters") then
			DAB_FloaterOptions:Show();
			DAB_OptionsTitle_Label:SetText(DAB_TEXT.FloatersHeader);
		elseif (frame == "events") then
			DAB_OnEventMacros:Show();
			DAB_OptionsTitle_Label:SetText(DAB_TEXT.MacrosOnEvents);
		elseif (frame == "other") then
			DAB_OtherBarOptionsHeader:Show();
			DAB_OptionsTitle_Label:SetText(DAB_TEXT.OtherBarsHeader);
		else
			DAB_BAR = frame;
			DAB_BarOptionsHeader:Show();
			DAB_BAR_SLIDER_INIT = nil;
			DAB_Initialize_BarOptions();
		end
	end
end

function DAB_Slider_Initialize(slider, value)
	if (not value) then
		value = "";
	end
	getglobal(slider:GetName().."_Display"):SetText(value);
	if (value ~= "") then
		slider:SetValue(value);		
	end
end

function DAB_Slider_OnValueChanged(index, subindex, subindex2, func)
	if (not DAB_INITIALIZED) then return; end
	if (not DAB_BAR_SLIDER_INIT) then return; end
	if (DAB_FloaterOptions:IsVisible() and (not DAB_FLOATER)) then return; end
	local value;
	if (index == "bar") then
		if (subindex2) then
			value = DAB_Settings[DAB_INDEX].Bar[DAB_BAR][subindex][subindex2];
		elseif (subindex) then
			value = DAB_Settings[DAB_INDEX].Bar[DAB_BAR][subindex];
		end
	elseif (index == "floater") then
		if (subindex2) then
			value = DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER][subindex][subindex2];
		elseif (subindex) then
			value = DAB_Settings[DAB_INDEX].Floaters[DAB_FLOATER][subindex];
		end
	elseif (index == "otherbar") then
		if (subindex2) then
			value = DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR][subindex][subindex2];
		elseif (subindex) then
			value = DAB_Settings[DAB_INDEX].OtherBar[DAB_OTHERBAR][subindex];
		end
	elseif (subindex2) then
		value = DAB_Settings[DAB_INDEX][index][subindex][subindex2];
	elseif (subindex) then
		value = DAB_Settings[DAB_INDEX][index][subindex];
	else
		value = DAB_Settings[DAB_INDEX][index];
	end
	local min, max = this:GetMinMaxValues();
	if (this.scale) then
		value = value * this.scale;
	end
	if (value) then
		if (value < min or value > max) then
			return;
		else
			value = this:GetValue();
		end
	else
		value = this:GetValue();
	end
	getglobal(this:GetName().."_Display"):SetText(value);
	if (this.scale) then
		value = value / this.scale;
	end
	DAB_Set_Option(value, index, subindex, subindex2);
	if (func) then
		index = DAB_Get_OptionsIndex(index);
		func(index);
	end
end

function DAB_Slider_UpdateFromEditBox(minlock, maxlock, index, subindex, subindex2, func)
	if (not DAB_INITIALIZED) then return; end
	if (DAB_FloaterOptions:IsVisible() and (not DAB_FLOATER)) then return; end
	local min, max = this:GetParent():GetMinMaxValues();
	local value = this:GetNumber();
	if (minlock and value < min) then
		value = min;
	end
	if (maxlock and value > max) then
		value = max;
	end
	this:SetText(value);
	if (this:GetParent().scale) then
		value = value / this:GetParent().scale;
	end
	DAB_Set_Option(value, index, subindex, subindex2);
	if (func) then
		index = DAB_Get_OptionsIndex(index);
		func(index);
	end
	if (value >= min and value <= max) then
		this:GetParent():SetValue(value);		
	end
	this:ClearFocus();
end

function DAB_Toggle_ButtonsLock()
	if (DAB_Settings[DAB_INDEX].ButtonsUnlocked) then
		DAB_Settings[DAB_INDEX].ButtonsUnlocked = nil;
		DAB_ToggleButtonsLock_Button:SetText(DAB_TEXT.UnlockButtons);
	else
		DAB_Settings[DAB_INDEX].ButtonsUnlocked = true;
		DAB_ToggleButtonsLock_Button:SetText(DAB_TEXT.LockButtons);
	end
end

function DAB_Toggle_Dragging()
	if (DAB_DRAGGING_UNLOCKED) then
		DAB_DRAGGING_UNLOCKED = nil;
		DAB_ToggleDragging_Button:SetText(DAB_TEXT.UnlockDragging);
		for index, value in DAB_OTHER_BARS do
			for _,button in value.frames do
				getglobal(button):EnableMouse(1);
			end
		end
	else
		DAB_DRAGGING_UNLOCKED = true;
		DAB_ToggleDragging_Button:SetText(DAB_TEXT.LockDragging);
		for index, value in DAB_OTHER_BARS do
			for _,button in value.frames do
				getglobal(button):EnableMouse();
			end
		end
	end
end

function DAB_Toggle_IDs()
	if (DAB_SHOWING_IDS) then
		DAB_SHOWING_IDS = nil;
		DAB_ToggleIDs_Button:SetText(DAB_TEXT.ShowIDs);
		for i=1,120 do
			getglobal("DAB_ActionButton_"..i.."TextFrameCooldownCount"):SetText("");
		end
	else
		DAB_SHOWING_IDS = true;
		DAB_ToggleIDs_Button:SetText(DAB_TEXT.HideIDs);
		for i=1,120 do
			getglobal("DAB_ActionButton_"..i.."TextFrameCooldownCount"):SetText(i);
		end
	end
end
