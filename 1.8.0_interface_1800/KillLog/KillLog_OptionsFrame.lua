--[[
path: /KillLog/
filename: KillLog_OptionsFrame.xml
author: Daniel Risse <dan@risse.com>
created: Mon, 17 Jan 2005 17:33:00 -0800
updated: Mon, 17 Jan 2005 17:33:00 -0800

list frame: a listing of the creeps you have fought
]]

local KillLog_OptionsFrameCheckButtons = { 
	["KILLLOG_OPTION_STORE_MAX"]      = { index = 1, setting = "storeMax",      tooltipText = KILLLOG_OPTION_TOOLTIP_STORE_MAX },
	["KILLLOG_OPTION_NOTIFY_MAX"]     = { index = 2, setting = "notifyMax",     tooltipText = KILLLOG_OPTION_TOOLTIP_NOTIFY_MAX },
	["KILLLOG_OPTION_STORE_CREEP"]    = { index = 3, setting = "storeCreep",    tooltipText = KILLLOG_OPTION_TOOLTIP_STORE_CREEP },
	["KILLLOG_OPTION_STORE_LOCATION"] = { index = 4, setting = "storeLocation", tooltipText = KILLLOG_OPTION_TOOLTIP_STORE_LOCATION },
	["KILLLOG_OPTION_SESSION"]        = { index = 5, setting = "session",       tooltipText = KILLLOG_OPTION_TOOLTIP_SESSION },

	["KILLLOG_OPTION_TOOLTIP"]        = { index = 6, setting = "tooltip",       tooltipText = KILLLOG_OPTION_TOOLTIP_TOOLTIP },
	["KILLLOG_OPTION_STORE_DEATH"]    = { index = 7, setting = "storeDeath",    tooltipText = KILLLOG_OPTION_TOOLTIP_STORE_DEATH },
	["KILLLOG_OPTION_TRIVIAL"]        = { index = 9, setting = "trivial",       tooltipText = KILLLOG_OPTION_TOOLTIP_TRIVIAL },
	["KILLLOG_OPTION_STORE_OVERALL"]  = { index = 10, setting = "storeOverall", tooltipText = KILLLOG_OPTION_TOOLTIP_STORE_OVERALL },

	["KILLLOG_OPTION_STORE_LEVEL"]    = { index = 11, setting = "storeLevel",   tooltipText = KILLLOG_OPTION_TOOLTIP_STORE_LEVEL },
	["KILLLOG_OPTION_PORTRAIT"]       = { index = 12, setting = "portrait",     tooltipText = KILLLOG_OPTION_TOOLTIP_PORTRAIT },
};

local KillLog_OptionsFrameSliders = {
	{ setting = "storeLevel", valueStep = 1,  minValue = 1, maxValue = 32,                         text = KILLLOG_OPTION_SLIDER_STORE_LEVEL, tooltipText = KILLLOG_OPTION_SLIDER_TOOLTIP_STORE_LEVEL },
	{ setting = "portrait",   valueStep = 10, minValue = 1, maxValue = KILLLOG_LIST_MAX_PORTRAITS, text = KILLLOG_OPTION_SLIDER_PORTRAIT,    tooltipText = KILLLOG_OPTION_SLIDER_TOOLTIP_PORTRAIT },
};


StaticPopupDialogs["KILLLOG_CLEAR"] = {
    text = KILLLOG_CLEAR_CONFIRMATION,
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function()
		KillLog_CreepInfo = nil;
		KillLog_CharacterData = nil;
		KillLogFrame.loaded = nil;
		KillLogFrame_LoadData();
    end,
    showAlert = 1,
    timeout = 0,
};


function KillLog_OptionsFrame_Load()
	KillLog_OptionsFrameCheckButton8:Hide();
	local setting = "";
	local index, value, button, string, checked;
	for index, value in KillLog_OptionsFrameCheckButtons do
		--DebugMessage("KL - Option", "CheckButton"..value.index..") "..value.setting, "info");
		button = getglobal("KillLog_OptionsFrameCheckButton"..value.index);
		string = getglobal("KillLog_OptionsFrameCheckButton"..value.index.."Text");
		if ( KillLog_Options[value.setting] ) then
			checked = 1;
			setting = setting..value.setting..": true, ";
		else
			checked = 0;
			setting = setting..value.setting..": false, ";
		end

		button.disabled = nil;
		if ( (index == "KILLLOG_OPTION_NOTIFY_MAX" and not KillLog_Options.storeMax) or (index == "KILLLOG_OPTION_STORE_LOCATION" and not KillLog_Options.storeCreep) ) then
			button.disabled = true;
		end

		if ( button.disabled ) then
			OptionsFrame_DisableCheckBox(button);
		else
			OptionsFrame_EnableCheckBox(button, checked);
		end

		string:SetText(getglobal(index));
		button.tooltipText  = value.tooltipText;
	end

	local slider, sliderString, getvalue;
	for index, value in KillLog_OptionsFrameSliders do
		--DebugMessage("KL - Option", "Slider"..index..") "..value.setting, "info");
		slider       = getglobal("KillLog_OptionsFrameSlider"..index);
		string       = getglobal("KillLog_OptionsFrameSlider"..index.."Text");
		getvalue     = KillLog_Options[value.setting];

		slider.disabled = nil;
		if ( not getvalue ) then
			slider.disabled = true;
			getvalue = value.maxValue;
		else
			setting = setting..value.setting..": "..getvalue..", ";
		end

		if ( slider.disabled ) then
			OptionsFrame_DisableSlider(slider);
		else
			OptionsFrame_EnableSlider(slider);
		end

		slider:SetMinMaxValues(value.minValue, value.maxValue);
		slider:SetValueStep(value.valueStep);
		slider:SetValue(getvalue);
		slider.tooltipText = value.tooltipText;
		string:SetText(value.text);
	end
	DebugMessage("KL - Op", "load "..setting, "info");
end

function KillLog_OptionsFrame_Save()
	local setting = "";
	local index, value, button, string, checked;
	for index, value in KillLog_OptionsFrameCheckButtons do
		button = getglobal("KillLog_OptionsFrameCheckButton"..value.index);
		if ( not button:GetChecked() ) then
			setting = setting..value.setting..": nil, ";
			KillLog_Options[value.setting] = nil;
		else
			KillLog_Options[value.setting] = true;
			setting = setting..value.setting..": true, ";
		end
	end
	for index, value in KillLog_OptionsFrameSliders do
		slider = getglobal("KillLog_OptionsFrameSlider"..index);
		if ( KillLog_Options[value.setting] ) then
			setting = setting..value.setting..": "..slider:GetValue()..", ";
			KillLog_Options[value.setting] = slider:GetValue();
		end
	end
	DebugMessage("KL - Op", "save "..setting, "info");
	KillLog_SendUpdate();
end

function KillLog_OptionsFrame_Cancel()
	KillLog_OptionsFrame_Load()
end

function KillLog_OptionsFrame_UpdateMaxOptions(storeChecked)
	local index = "KILLLOG_OPTION_NOTIFY_MAX";
	local value = KillLog_OptionsFrameCheckButtons[index];
	local button = getglobal("KillLog_OptionsFrameCheckButton"..value.index);
	local checked = nil;
	if ( KillLog_Options[value.setting] ) then
		checked = 1;
	end

	button.disabled = nil;
	if ( not storeChecked ) then
		button.disabled = true;
	end

	if ( button.disabled ) then
		OptionsFrame_DisableCheckBox(button);
	else
		OptionsFrame_EnableCheckBox(button, checked);
	end
end

function KillLog_OptionsFrame_UpdateStoreCreepOptions(storeChecked)
	local index = "KILLLOG_OPTION_STORE_LOCATION";
	local value = KillLog_OptionsFrameCheckButtons[index];
	local button = getglobal("KillLog_OptionsFrameCheckButton"..value.index);
	local checked = nil;
	if ( KillLog_Options[value.setting] ) then
		checked = 1;
	end

	button.disabled = nil;
	if ( not storeChecked ) then
		button.disabled = true;
	end

	if ( button.disabled ) then
		OptionsFrame_DisableCheckBox(button);
	else
		OptionsFrame_EnableCheckBox(button, checked);
	end
end

function KillLog_OptionsFrame_UpdateStoreLevel(checked)
	if ( checked ) then
		OptionsFrame_EnableSlider(KillLog_OptionsFrameSlider1);
	else
		OptionsFrame_DisableSlider(KillLog_OptionsFrameSlider1);
	end
end

function KillLog_OptionsFrame_UpdatePortraits(checked)
	if ( checked ) then
		OptionsFrame_EnableSlider(KillLog_OptionsFrameSlider2);
	else
		OptionsFrame_DisableSlider(KillLog_OptionsFrameSlider2);
	end
end
