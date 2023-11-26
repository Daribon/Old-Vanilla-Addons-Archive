--[[	****************************************************************
	MiniGroup vK0.4b (bugbash ver)

	Author: Kaitlin of Sargeras
	****************************************************************
	Description:
		A set of moveable, dockable, and configurable
		minimalistic, DAoC-esque mini-windows including
		Mini-Group, Mini-Target, and Mini-Group Buff windows.

	Thank you to:
		Lothero of Sargeras (my bro) for debuffing me instead
			of leveling
		ImageShack.us for hosting my pics

	Official Site:
		wow.jaslaughter.com
	
	K0.4a-Options
	****************************************************************]]

--[[	***********************
	Options Frame Functions
	***********************
]]

local MGOptions_BuffPos = {[1] = { x = 0, y = -30 },[2] = { x = 0, y = -52 },[3] = { x = 0, y = -74 },[4] = { x = 0, y = -96 },[5] = { x = 0, y = -118 }};
local MGOptionsFrame_SetColorFunc = {
	["Magic"] = function(x) MGOptionsFrame_SetColor("Magic") end,
	["Poison"] = function(x) MGOptionsFrame_SetColor("Poison") end,
	["Disease"] = function(x) MGOptionsFrame_SetColor("Disease") end,
	["Curse"] = function(x) MGOptionsFrame_SetColor("Curse") end,
	["None"] = function(x) MGOptionsFrame_SetColor("None") end,
};

local MGOptionsFrameCheckButtons = { };
MGOptionsFrameCheckButtons["Enable Party Tooltips"] = { index = 1, tooltipText = "Show Buffs/Debuffs in a tooltip when you mouse-over a party member", MGVar = "ShowMGPartyTips"};
MGOptionsFrameCheckButtons["Show Actual Health Values"] = { index = 2, tooltipText = "Show HPs instead of % if possible.\n\n(Uses Telo's MobHealth Values if available)", MGVar = "ShowHealthType"};
MGOptionsFrameCheckButtons["Show KeyBindings"] = { index = 3, tooltipText = "Show KeyBindings to the left of members names", MGVar = "ShowBindingLabels", setFunc = MiniGroup_UpdateParty};
MGOptionsFrameCheckButtons["Use Global Settings"] = { index = 4, tooltipText = "Global settings are synchronous across all characters", MGVar = "UseGlobalDebuffColors" };
MGOptionsFrameCheckButtons["Show Party Symbol Indicators"] = { index = 5, tooltipText = "Show color-blind indicators when units are debuffed", MGVar = "ShowColorBlindIndicators" };
MGOptionsFrameCheckButtons["Show Player Frame"] = { index = 6, tooltipText = "Show the built-in (Blizzard) Player Frame\n\n(This has not been tested with any mods that manipulate that frame)", MGVar = "ShowPlayerFrame"};
MGOptionsFrameCheckButtons["Show Party Frames"] = { index = 7, tooltipText = "Show the built-in (Blizzard) Party Frames\n\n(This has not been tested with any mods that manipulate that frame)", MGVar = "ShowPartyFrames"};
MGOptionsFrameCheckButtons["Show Target Frame"] = { index = 8, tooltipText = "Show the built-in (Blizzard) Target Frame\n\n(This has not been tested with any mods that manipulate that frame)", MGVar = "ShowTargetFrame"};
MGOptionsFrameCheckButtons["Always Show Target Auras"] = { index = 9, tooltipText = "Expand the MiniTarget window to show target auras.", MGVar = "MGTarget_BuffFrame" };
MGOptionsFrameCheckButtons["Smooth HealthBar Color"] = { index = 10, tooltipText = "Degrade the HealthBar colors from Green to Red depending on value.", MGVar = "SmoothHealthColor" };
MGOptionsFrameCheckButtons["Show Buffs Under Members"] = { index = 11, tooltipText = "Show up to 10 buffs under each member", MGVar = "ShowMGPartyBuffs" };
MGOptionsFrameCheckButtons["Use Independent Scaling"] = { index = 12, tooltipText = "Scale the MiniGroup windows independently from the UIParent scale", MGVar = "UseUIScale" };
MGOptionsFrameCheckButtons["Scale Windows with Members"] = { index = 13, tooltipText = "Checking this will cause the MiniParty and MiniBuff windows to scale depending on how many members are in the party", MGVar = "MGMemberScaling" };
MGOptionsFrameCheckButtons["Enable Target Tooltips"] = { index = 14, tooltipText = "Check to show tooltips over the Target frame", MGVar = "ShowMGTargetTips" };
MGOptionsFrameCheckButtons["Show Party Color Indicators"] = { index = 15, tooltipText = "Show Color Indicators in the Party frame", MGVar = "ShowColorIndicators" };
MGOptionsFrameCheckButtons["Show Target Color Indicators"] = { index = 16, tooltipText = "Show Color Indicators in the Target frame", MGVar = "ShowTColorIndicators" };
MGOptionsFrameCheckButtons["Show Target Symbol Indicators"] = { index = 17, tooltipText = "Show color-blind indicators in the Target frame", MGVar = "ShowTColorBlindIndicators" };
MGOptionsFrameCheckButtons["Auto-Hide MGParty Frame"] = { index = 18, tooltipText = "Check this to auto-hide the MiniGroup frames when not grouped", MGVar = "AutoHide" };

MGOptionsFrameSliders = {
	{ text = "", MGVar = "MGScale", minValue = 0.5, maxValue = 1.5, valueStep = 0.05, tooltipText = "Adjust the scale of the MiniGroup Windows" },
};

function MGOptionsFrame_OnLoad()
	for key, value in DebuffID do
		getglobal("MGOptionsFrame_"..value.."_TextBoxLabel"):SetText(value);
	end
end

function MGOptionsFrame_OnShow()
	-- Initial Values
	local button, string, checked;
	MGOptionsFrame_DebuffOrder = {};
	MGOptionsFrame_UsingGlobal = MG_Get("UseGlobalDebuffColors");

	-- Set CheckButton states
	for key, value in MGOptionsFrameCheckButtons do
		button = getglobal("MGOptionsFrame_CheckButton"..value.index);
		string = getglobal("MGOptionsFrame_CheckButton"..value.index.."Text");
		checked = nil;
		button.disabled = nil;
		if ( value.func ) then
			checked = value.func();
		elseif ( value.MGVar ) then
			if ( MG_Get(value.MGVar) == 1 ) then
				checked = 1;
			else
				checked = nil;
			end
		elseif ( value.uvar ) then
			checked = getglobal(value.uvar);
		else
			checked = nil;
		end
		OptionsFrame_EnableCheckBox(button);
		button:SetChecked(checked);
		string:SetText(key);
		button.tooltipText = value.tooltipText;
	end

	for index, value in MGOptionsFrameSliders do
		local slider = getglobal("MGOptionsFrameSlider"..index);
		local string = getglobal("MGOptionsFrameSlider"..index.."Text");
		local low = getglobal("MGOptionsFrameSlider"..index.."Low");
		local high = getglobal("MGOptionsFrameSlider"..index.."High");
		local getvalue = MG_Get(value.MGVar);
		local text = value.text;
		OptionsFrame_EnableSlider(slider);
		slider:SetMinMaxValues(value.minValue, value.maxValue);
		slider:SetValueStep(value.valueStep);
		slider:SetValue(getvalue);
		string:SetText(value.text);
		low:SetText(value.minValue);
		high:SetText(value.maxValue);
		slider.tooltipText = value.tooltipText;
		slider.tooltipRequirement = value.tooltipRequirement;
	end

	OptionsFrame_EnableDropDown(MGOptionsFrame_ToolTips_Dropdown);
	OptionsFrame_EnableDropDown(MGOptionsFrame_TToolTips_Dropdown);
	OptionsFrame_EnableDropDown(MGOptionsFrame_TargetAuras_Dropdown);
	MGOptionsFrame_UpdateDependencies();
	MGOptionsFrame_DebuffDisplay_OnLoad();
	MGOptionsFrame_DebuffOrder_OnLoad();
end

function MGOptionsFrame_SortBuff_OnClick(buttonID,dir)
	local cPos,debuff;

	debuff = DebuffID[buttonID];
	for key,val in MGOptionsFrame_DebuffOrder do
		if ( val == debuff ) then
			cPos = key;
			break;
		end
	end

	if ( not cPos or (cPos == 5 and dir == "Down") or (cPos == 1 and dir == "Up") ) then
		return;
	end

	if ( dir == "Up" ) then
		MG_ReOrder(MGOptionsFrame_DebuffOrder, debuff, (cPos-1));
	else
		MG_ReOrder(MGOptionsFrame_DebuffOrder, debuff, (cPos+1));
	end
	MGOptionsFrame_DebuffOrder_Refresh();
end

function MGOptionsFrame_DebuffOrder_OnLoad()
	if ( MGOptionsFrame_UsingGlobal == 1 ) then
		for index,val in MiniGroup_Config["DebuffOrder"] do
			MGOptionsFrame_DebuffOrder[index] = val;
		end
	else
		for index,val in MGPlayer["DebuffOrder"] do
			MGOptionsFrame_DebuffOrder[index] = val;
		end
	end
	MGOptionsFrame_DebuffOrder_Refresh();
end

function MGOptionsFrame_DebuffOrder_Refresh()
	local frame;

	for key, value in MGOptionsFrame_DebuffOrder do
		frame = getglobal("MGOptionsFrame_"..value);
		MGOptionsFrame_SortBuffBtn(frame,key);
	end
end

function MGOptionsFrame_SortBuffBtn(frame,pos)
	frame:ClearAllPoints();
	frame:SetPoint("LEFT","MGOptionsFrame_CheckButton4","RIGHT",MGOptions_BuffPos[pos].x,MGOptions_BuffPos[pos].y);
end

function MGOptionsFrame_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("MGOptionsFrame_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("MGOptionsFrame_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
end

function MGOptionsFrame_SaveOptions()
	local button,frame,text;
	local useScale = MG_Get("UseUIScale");

	for index, value in MGOptionsFrameCheckButtons do
		button = getglobal("MGOptionsFrame_CheckButton"..value.index);
		if ( button:GetChecked() ) then
			value.value = "1";
		else
			value.value = "0";
		end
		if ( value.MGVar ) then
			MG_Set(value.MGVar,value.value);
		end
		if ( value.setFunc ) then
			value.setFunc();
		end
		if ( value.index == 6 ) then
			if ( button:GetChecked() ) then
				MiniGroup_PlayerFrame("on");
			else
				MiniGroup_PlayerFrame("off");
			end
		elseif ( value.index == 7 ) then
			if ( button:GetChecked() ) then
				ShowPartyFrame();
			else
				HidePartyFrame();
			end
		elseif ( value.index == 8 ) then
			if ( button:GetChecked() ) then
				if (UnitExists("target")) then
					TargetFrame:Show();
					if (getglobal("MobHealthFrame")) then
						MobHealthFrame:Show();
					end
				end
			else
				if ( TargetFrame:IsVisible() ) then
					TargetFrame:Hide();
					if (getglobal("MobHealthFrame")) then
						MobHealthFrame:Hide();
					end
				end
			end
		elseif ( value.index == 9 ) then
			if ( button:GetChecked() ) then
				MGTarget_BuffFrameSet("on");
			else
				MGTarget_BuffFrameSet("off");
			end
		elseif ( value.index == 12 ) then
			if ( button:GetChecked() ) then
				if ( ( MGOptionsFrameSlider1:GetValue() ~= MG_Get("MGScale") ) or useScale ~= 1 ) then
					MG_Set("MGScale",MGOptionsFrameSlider1:GetValue());
					MiniGroup_SetScale();
					MiniGroup_ResetPos();
					MiniGroup_SavePos(MGParty_Frame);
					MiniGroup_SavePos(MGTarget_Frame);
					MiniGroup_SavePos(MGBuff_Frame);
				end
			elseif ( useScale == 1 ) then
				MiniGroup_SetScale();
				MiniGroup_ResetPos();
				MiniGroup_SavePos(MGParty_Frame);
				MiniGroup_SavePos(MGTarget_Frame);
				MiniGroup_SavePos(MGBuff_Frame);
			end
		end
	end
	for index, value in DebuffID do
		frame = getglobal("MGOptionsFrame_"..value);
		text = getglobal("MGOptionsFrame_"..value.."_TextBox"):GetText();

		if ( MGOptionsFrame_UsingGlobal == 1 ) then
			MiniGroup_Config["DebuffColors"][value].r = frame.r;
			MiniGroup_Config["DebuffColors"][value].g = frame.g;
			MiniGroup_Config["DebuffColors"][value].b = frame.b;
			MiniGroup_Config["DebuffColors"][value].c = text;
		else
			MGPlayer["DebuffColors"][value].r = frame.r;
			MGPlayer["DebuffColors"][value].g = frame.g;
			MGPlayer["DebuffColors"][value].b = frame.b;
			MGPlayer["DebuffColors"][value].c = text;
		end
	end
	if ( MGOptionsFrame_UsingGlobal == 1 ) then
		for key,value in MGOptionsFrame_DebuffOrder do
			MiniGroup_Config["DebuffOrder"][key] = value;
		end
	else
		for key,value in MGOptionsFrame_DebuffOrder do
			MGPlayer["DebuffOrder"][key] = value;
		end
	end
	MG_Set("MGToolTipStyle",UIDropDownMenu_GetSelectedValue(MGOptionsFrame_ToolTips_Dropdown));
	MG_Set("MGTToolTipStyle",UIDropDownMenu_GetSelectedValue(MGOptionsFrame_TToolTips_Dropdown));
	MG_Set("TargetAuraPos",UIDropDownMenu_GetSelectedValue(MGOptionsFrame_TargetAuras_Dropdown));
	if ( UnitExists("target") and MG_Get("ShowMGTargetFrame") == 1 ) then
		MGTarget_Frame:Hide();
		MGTarget_Frame:Show();
	end
	MGParty_Member_UpdateAllMembers();
end

function MGOptionsFrame_OnClick()
	if ( this:GetName() == "MGOptionsFrame_CheckButton1" ) then
		if ( this:GetChecked() ) then
			OptionsFrame_EnableDropDown(MGOptionsFrame_ToolTips_Dropdown);
		else
			OptionsFrame_DisableDropDown(MGOptionsFrame_ToolTips_Dropdown);
		end
	elseif ( this:GetName() == "MGOptionsFrame_CheckButton4" ) then
		if ( this:GetChecked() ) then
			MGOptionsFrame_UsingGlobal = 1;
		else
			MGOptionsFrame_UsingGlobal = 0;
		end
		MGOptionsFrame_DebuffOrder_OnLoad();
		MGOptionsFrame_DebuffDisplay_OnLoad();
	elseif ( this:GetName() == "MGOptionsFrame_CheckButton9" ) then
		if ( this:GetChecked() ) then
			OptionsFrame_EnableDropDown(MGOptionsFrame_TargetAuras_Dropdown);
		else
			OptionsFrame_DisableDropDown(MGOptionsFrame_TargetAuras_Dropdown);
		end
	elseif ( this:GetName() == "MGOptionsFrame_CheckButton12" ) then
		if ( this:GetChecked() ) then
			OptionsFrame_EnableSlider(MGOptionsFrameSlider1);
		else
			OptionsFrame_DisableSlider(MGOptionsFrameSlider1);
		end
	elseif ( this:GetName() == "MGOptionsFrame_CheckButton14" ) then
		if ( this:GetChecked() ) then
			OptionsFrame_EnableDropDown(MGOptionsFrame_TToolTips_Dropdown);
		else
			OptionsFrame_DisableDropDown(MGOptionsFrame_TToolTips_Dropdown);
		end
	elseif ( this:GetName() == "MGOptionsFrameDefaults" ) then
		MiniGroup_FreshVar();
		MGPlayer = MiniGroup_GetPlayer();
		MiniGroup_SetOptions();
		MGOptionsFrame_DebuffOrder_OnLoad();
		MGOptionsFrame_DebuffDisplay_OnLoad();
		MGOptionsFrame_OnShow();
	end
end

function MGOptionsFrame_UpdateDependencies()
	if ( not MGOptionsFrame_CheckButton1:GetChecked() ) then
		OptionsFrame_DisableDropDown(MGOptionsFrame_ToolTips_Dropdown);
	end
	if ( not MGOptionsFrame_CheckButton9:GetChecked() ) then
		OptionsFrame_DisableDropDown(MGOptionsFrame_TargetAuras_Dropdown);
	end
	if ( not MGOptionsFrame_CheckButton12:GetChecked() ) then
		OptionsFrame_DisableSlider(MGOptionsFrameSlider1);
	end
	if ( not MGOptionsFrame_CheckButton14:GetChecked() ) then
		OptionsFrame_DisableDropDown(MGOptionsFrame_TToolTips_Dropdown);
	end
end

function MGOptionsFrame_DebuffDisplay_OnLoad()
	if ( MGPlayer == nil ) then
		return;
	end
	local frame,swatch,text,sRed,sGreen,sBlue,sCB;

	for key,value in DebuffID do
		frame = getglobal("MGOptionsFrame_"..value);
		swatch = getglobal("MGOptionsFrame_"..value.."_ColorSwatchNormalTexture");
		text = getglobal("MGOptionsFrame_"..value.."_TextBox");

		if ( MGOptionsFrame_UsingGlobal == 1 ) then
			sRed = MiniGroup_Config["DebuffColors"][value].r;
			sGreen = MiniGroup_Config["DebuffColors"][value].g;
			sBlue = MiniGroup_Config["DebuffColors"][value].b;
			sCB = MiniGroup_Config["DebuffColors"][value].c;
		else
			sRed = MGPlayer["DebuffColors"][value].r;
			sGreen = MGPlayer["DebuffColors"][value].g;
			sBlue = MGPlayer["DebuffColors"][value].b;
			sCB = MGPlayer["DebuffColors"][value].c;
		end
		frame.r = sRed;
		frame.g = sGreen;
		frame.b = sBlue;
		frame.swatchFunc = MGOptionsFrame_SetColorFunc[value];
		swatch:SetVertexColor(sRed,sGreen,sBlue);
		text:SetText(sCB);
	end
end

function MGOptionsFrame_TargetAuras_Dropdown_OnLoad()
	UIDropDownMenu_Initialize(this, MGOptionsFrame_TargetAuras_Dropdown_Initialize);
	UIDropDownMenu_SetSelectedValue(this, MG_Get("TargetAuraPos"));
	MGOptionsFrame_TargetAuras_Dropdown.tooltip = getglobal("DropDownList1Button"..MGOptionsFrame_TargetAuras_Dropdown.selectedValue).tooltipText;
	UIDropDownMenu_SetWidth(130, MGOptionsFrame_TargetAuras_Dropdown);
end

function MGOptionsFrame_TargetAuras_Dropdown_OnClick()
	UIDropDownMenu_SetSelectedValue(MGOptionsFrame_TargetAuras_Dropdown, this.value);
	MGOptionsFrame_TargetAuras_Dropdown.tooltip = this.tooltipText;
end

function MGOptionsFrame_TargetAuras_Dropdown_Initialize()
	local selectedValue = UIDropDownMenu_GetSelectedValue(MGOptionsFrame_TargetAuras_Dropdown);
	local info;

	-- Show Buffs
	info = {};
	info.text = "Above Frame";
	info.tooltipTitle = info.text;
	info.tooltipText = "Target auras will display above the target frame.";
	info.func = MGOptionsFrame_TargetAuras_Dropdown_OnClick;
	info.value = 1;
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);

	-- Show Debuffs
	info = {};
	info.text = "Below Frame";
	info.tooltipTitle = info.text;
	info.tooltipText = "Target auras will display below the target frame.";
	info.func = MGOptionsFrame_TargetAuras_Dropdown_OnClick;
	info.value = 2
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
end

function MGOptionsFrame_TToolTips_Dropdown_OnLoad()
	UIDropDownMenu_Initialize(this, MGOptionsFrame_TToolTips_Dropdown_Initialize);
	UIDropDownMenu_SetSelectedValue(this, MG_Get("MGTToolTipStyle"));
	MGOptionsFrame_TToolTips_Dropdown.tooltip = getglobal("DropDownList1Button"..MGOptionsFrame_TToolTips_Dropdown.selectedValue).tooltipText;
	UIDropDownMenu_SetWidth(130, MGOptionsFrame_TToolTips_Dropdown);
end

function MGOptionsFrame_TToolTips_Dropdown_OnClick()
	UIDropDownMenu_SetSelectedValue(MGOptionsFrame_TToolTips_Dropdown, this.value);
	MGOptionsFrame_TToolTips_Dropdown.tooltip = this.tooltipText;
end

function MGOptionsFrame_TToolTips_Dropdown_Initialize()
	local selectedValue = UIDropDownMenu_GetSelectedValue(MGOptionsFrame_TToolTips_Dropdown);
	local info;

	-- Show Buffs
	info = {};
	info.text = "Show Buffs Only";
	info.tooltipTitle = info.text;
	info.tooltipText = "Only Buffs will display when you mouse-over a target in the mini-target window.";
	info.func = MGOptionsFrame_TToolTips_Dropdown_OnClick;
	info.value = 1;
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);

	-- Show Debuffs
	info = {};
	info.text = "Show Debuffs Only";
	info.tooltipTitle = info.text;
	info.tooltipText = "Only Debuffs will display when you mouse-over a party member in the mini-group window.";
	info.func = MGOptionsFrame_TToolTips_Dropdown_OnClick;
	info.value = 2;
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);

	-- Show Both
	info = {};
	info.text = "Show Both";
	info.tooltipTitle = info.text;
	info.tooltipText = "Buffs and Debuffs will display when you mouse-over a party member in the mini-group window.";
	info.func = MGOptionsFrame_TToolTips_Dropdown_OnClick;
	info.value = 3;
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
end


function MGOptionsFrame_ToolTips_Dropdown_OnLoad()
	UIDropDownMenu_Initialize(this, MGOptionsFrame_ToolTips_Dropdown_Initialize);
	UIDropDownMenu_SetSelectedValue(this, MG_Get("MGToolTipStyle"));
	MGOptionsFrame_ToolTips_Dropdown.tooltip = getglobal("DropDownList1Button"..MGOptionsFrame_ToolTips_Dropdown.selectedValue).tooltipText;
	UIDropDownMenu_SetWidth(130, MGOptionsFrame_ToolTips_Dropdown);
end

function MGOptionsFrame_ToolTips_Dropdown_OnClick()
	UIDropDownMenu_SetSelectedValue(MGOptionsFrame_ToolTips_Dropdown, this.value);
	MGOptionsFrame_ToolTips_Dropdown.tooltip = this.tooltipText;
end

function MGOptionsFrame_ToolTips_Dropdown_Initialize()
	local selectedValue = UIDropDownMenu_GetSelectedValue(MGOptionsFrame_ToolTips_Dropdown);
	local info;

	-- Show Buffs
	info = {};
	info.text = "Show Buffs Only";
	info.tooltipTitle = info.text;
	info.tooltipText = "Only Buffs will display when you mouse-over a party member in the mini-group window.";
	info.func = MGOptionsFrame_ToolTips_Dropdown_OnClick;
	info.value = 1;
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);

	-- Show Debuffs
	info = {};
	info.text = "Show Debuffs Only";
	info.tooltipTitle = info.text;
	info.tooltipText = "Only Debuffs will display when you mouse-over a party member in the mini-group window.";
	info.func = MGOptionsFrame_ToolTips_Dropdown_OnClick;
	info.value = 2;
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);

	-- Show Both
	info = {};
	info.text = "Show Both";
	info.tooltipTitle = info.text;
	info.tooltipText = "Buffs and Debuffs will display when you mouse-over a party member in the mini-group window.";
	info.func = MGOptionsFrame_ToolTips_Dropdown_OnClick;
	info.value = 3;
	if ( selectedValue == info.value ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
end
