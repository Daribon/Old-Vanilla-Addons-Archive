-- UI CODE GOES HERE

function CustomTooltip_showFrame(frame)
	CustomTooltipEntry:Hide();
	CustomTooltipMouse:Hide();
	CustomTooltipSave:Hide();
	CustomTooltipColors:Hide();
	frame:Show();
end

function CustomTooltip_MouseDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CustomTooltip_MouseDropDown_Initialize);
end

function CustomTooltip_MouseDropDown_Initialize()
	
	local info = {};
	
	info.checked = nil;
	
	info.text = "TOPLEFT";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "TOP";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "TOPRIGHT";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "BOTTOMLEFT";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "BOTTOM";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "BOTTOMRIGHT";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "LEFT";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "RIGHT";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	info.text = "CENTER";
	info.func = CustomTooltip_MouseDropDown_Button;
	UIDropDownMenu_AddButton(info);
	
	
	UIDropDownMenu_SetText(CustomTooltip_Options.relocatePos, CustomTooltipMousePosDropDown);
	UIDropDownMenu_SetSelectedName(CustomTooltipMousePosDropDown, CustomTooltip_Options.relocatePos);
	--UIDropDownMenu_Refresh(CustomTooltipMousePosDropDown);
		
end

function CustomTooltip_MouseDropDown_Button()
	
	local posid = this:GetID();
	UIDropDownMenu_SetSelectedID(CustomTooltipMousePosDropDown, posid);
	CustomTooltip_Options.relocatePos = UIDropDownMenu_GetText(CustomTooltipMousePosDropDown);
	
end

function CustomTooltip_setRelocate(state)
	CustomTooltip_debug("setting state ",state);
	CustomTooltip_Options.relocateTooltip = state;
	
	CustomTooltipMouseDisable:SetChecked(0);
	CustomTooltipMouseMouse:SetChecked(0);
	CustomTooltipMousePos:SetChecked(0);
	
	if(state == 0) then
		CustomTooltipMouseDisable:SetChecked(1);
	elseif(state == 1) then
		CustomTooltipMouseMouse:SetChecked(1);
	else
		CustomTooltipMousePos:SetChecked(1);
	end
end


function CustomTooltip_ColorsDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CustomTooltip_ColorsDropDown_Initialize);
end

function CustomTooltip_ColorsDropDown_OnShow()
end

function CustomTooltip_ColorsDropDown_Initialize()

	local info = {};
	
	info.checked = nil;
		
	table.foreach(CustomTooltip_Colors, 
		function(i, v)
			info.text = i;
			info.value = v;
			info.func = CustomTooltip_Colors_Button;
			UIDropDownMenu_AddButton(info);
		end	
				);
	
	local last = UIDropDownMenu_GetText(CustomTooltipColorsDropDown);		
	UIDropDownMenu_SetSelectedName(CustomTooltipColorsDropDown, last);
	
end

function CustomTooltip_Colors_Button()

	local posid = this:GetID();
	UIDropDownMenu_SetSelectedID(CustomTooltipColorsDropDown, posid);
	local index = UIDropDownMenu_GetText(CustomTooltipColorsDropDown);
	UIDropDownMenu_SetSelectedName(CustomTooltipColorsDropDown, index);
	CustomTooltip_debug("Colors button: ", index);
	
	CustomTooltip_setColorBars(CustomTooltip_Colors[index].r, CustomTooltip_Colors[index].g, CustomTooltip_Colors[index].b);	

end

function CustomTooltip_setColorBars(r, g, b)
	
	CustomTooltipColorsRed:SetValue(r);
	CustomTooltipColorsGreen:SetValue(g);
	CustomTooltipColorsBlue:SetValue(b);
	CustomTooltip_debug("set colors bar", r, " ", g, " ", b);
end

function CustomTooltip_setColorSample()
	-- because of load order, we have to make sure the sliders
	-- are there before talking with them
	if(CustomTooltipColorsRed == nil) then
		CustomTooltip_debug("red is nil");
		return;
	end
	if(CustomTooltipColorsGreen == nil) then
		CustomTooltip_debug("green is nil");
		return;
	end
	if(CustomTooltipColorsBlue == nil) then
		CustomTooltip_debug("blue is nil");
		return;
	end
	
	
	local r,g,b;
	r = CustomTooltipColorsRed:GetValue();
	g = CustomTooltipColorsGreen:GetValue();
	b = CustomTooltipColorsBlue:GetValue();
	local index = UIDropDownMenu_GetText(CustomTooltipColorsDropDown);
	
	
	CustomTooltipColorsSample:SetTextColor(r, g, b);
	-- load order again
	if(index == nil) then
		return;
	end
	
	
	CustomTooltip_Colors[index].r = r;
	CustomTooltip_Colors[index].g = g;
	CustomTooltip_Colors[index].b = b;
	
end

function CustomTooltip_SaveDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CustomTooltip_SaveDropDown_Initialize);
end

function CustomTooltip_SaveDropDown_Initialize()
	local info = {};
	
	info.checked = nil;
		
		
	-- add the built in ones
	table.foreach(CustomTooltip_BuiltInText, 
		function(i, v)
			info.text = i;
			info.value = v;
			info.func = CustomTooltip_SaveDropDown_Button;
			UIDropDownMenu_AddButton(info);
		end	
	);
	
	table.foreach(CustomTooltip_CustomText, 
		function(i, v)
			info.text = i;
			info.value = v;
			info.func = CustomTooltip_SaveDropDown_Button;
			UIDropDownMenu_AddButton(info);
		end	
	);
	
	local last = UIDropDownMenu_GetText(CustomTooltipSaveDropDown);		
	UIDropDownMenu_SetSelectedName(CustomTooltipSaveDropDown, last);
	
end

function CustomTooltip_SaveDropDown_Button()

	local posid = this:GetID();
	UIDropDownMenu_SetSelectedID(CustomTooltipSaveDropDown, posid);
	local index = UIDropDownMenu_GetText(CustomTooltipSaveDropDown);
	UIDropDownMenu_SetSelectedName(CustomTooltipSaveDropDown, index);
	
	CustomTooltip_loadTooltipPreview(index);
	
	CustomTooltip_debug("Save dropdown button: ", index);

end

function CustomTooltip_saveTooltip(name, text)
	CustomTooltip_CustomText[name] = text;
end

function CustomTooltip_loadTooltipPreview(name)
	local text;
	text = CustomTooltip_CustomText[name]
	
	if(text == nil) then
		text = CustomTooltip_BuiltInText[name];
	end
	
	if(text == nil) then
		text = "Invalid Load";
	end
	CustomTooltipSavePreview:SetText(text);
	CustomTooltipSaveName:SetText(name);
end

function CustomTooltip_loadTooltip(name)

	local text;
	text = CustomTooltip_CustomText[name]
	
	if(text == nil) then
		text = CustomTooltip_BuiltInText[name];
	end

	if(text == nil) then
		text = "Invalid Load";
	end
	
	CustomTooltip_Text = text;

end

function CustomTooltip_ResetTooltip()

	CustomTooltip_Text = CustomTooltip_BuiltInText["Insomniax v1.56"];
	ChatFrame1:AddMessage("CustomTooltip: Reseting Custom Tooltips Defaults", 1, 1, 0);	
	
	CustomTooltip_DefColors = {
		-- default is white 
		["default"] = { r = 1; g = 1; b = 1; };
		
		["partymate"] = { r = 0.5; g = 0.9; b = 1.0; };
		["guildmate"] = { r = 0.5; g = 1.0; b = 0.75; };
		
		["friendpc"] = { r = 0.5; g = 0.65; b = 1.0; };
		["friendnpc"] = { r = 0.3; g = 0.9; b = 0.3; };
		["pet"] = { r = .45; g = 0.45; b = 0.9; };
		
		-- enemies are red
		["enemypc"] = { r = 0.8; g = 0.2; b = 0.75; };
		["enemynpc"] = { r = 0.9; g = 0.3; b = 0.3; };
		
		-- neutral are yellow
		["neutral"] = { r = 1.0; g = 0.85; b = 0.0; };
		
		-- used for %f color
		-- hostile is red
		["hostile"] = { r = .9; g = 0.3; b = 0.3; };
		-- nopvp (friends and enemies) is blue
		["nopvp"] = { r = .3; g = 0.3; b = 0.9; };
		-- friends with pvp on is green
		["friendpvp"] = { r = 0.1; g = 0.9; b = 0.1; };
	};

	CustomTooltip_Colors = CustomTooltip_DefColors;		
	
	CustomTooltip_setColorSample();

	CustomTooltip_ColorsDropDown_OnLoad();
end