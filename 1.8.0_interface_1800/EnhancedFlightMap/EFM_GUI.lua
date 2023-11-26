--[[

EFM_GUI.lua

This lua file handles the GUI options screen functions.


/script EFM_GUI_Toggle();

]]

-- Function: Display GUI options frame.
function EFM_GUI_Toggle()
	if(EFM_GUI_Options_Frame:IsVisible()) then
		EFM_GUI_Options_Frame:Hide();
	else
		EFM_GUI_Options_Frame:Show();
	end
end

-- Function: When hiding, if run from myAddons, then return to it's menu.
function EFM_GUI_OnHide()
	if(MYADDONS_ACTIVE_OPTIONSFRAME == this) then
		ShowUIPanel(myAddOnsFrame);
	end
end

-- Function: OnLoad handler
function EFM_GUI_OnLoad()
	-- Register the events we wish to see.
	this:RegisterEvent("VARIABLES_LOADED");
end

-- Function: handle the events we are registered to receive
function EFM_GUI_OnEvent()
	if (event == "VARIABLES_LOADED") then
		LYS_ProgramRegsiterAddon("EnhancedFlightMap", EFM_Version_String, EFM_Version, "", "EnhancedFlightMapFrame", "EFM_GUI_Options_Frame", MYADDONS_CATEGORY_MAP);

		-- Set the button text.
		for key,val in pairs(EFM_Config) do
			local myText = getglobal("EFM_GUITEXT_"..key);
			getglobal("EFM_GUI_Options_Frame_Toggle_"..key.."Text"):SetText(myText);
		end
	end
end

-- Function: Set the various options to their current settings.
function EFM_GUI_OnShow()
	-- Make sure the various options are set.
	for key,val in pairs(EFM_Config) do
		getglobal("EFM_GUI_Options_Frame_Toggle_"..key):SetChecked(EFM_Config[key]);
	end
end

-- Function: What to do when the button is "clicked"
function EFM_GUI_Button_OnEvent(myOption)
	local myOptionName = myOption:GetName();

	if (string.find(myOptionName, "EFM_GUI_Options_Frame_Toggle_") ~= nil) then
		local value = string.sub(myOptionName, (string.len("EFM_GUI_Options_Frame_Toggle_") + 1));

		if (EFM_Config[value]) then
			if (value == "Timer") then
				EFM_Timer_HideTimers();
			end
			EFM_Config[value] = false;
			myOption:SetChecked(false);
		else
			EFM_Config[value] = true;
			myOption:SetChecked(true);
		end
	elseif (myOptionName == "EFM_GUI_Options_Frame_Done") then
		EFM_GUI_Options_Frame:Hide();
	elseif (myOptionName == "EFM_GUI_Options_Frame_Defaults") then
		EnhancedFlightMap_Options("all", "defaults");
		EFM_GUI_OnShow();
	elseif (myOptionName == "EFM_GUI_Options_Frame_LoadAlliance") then
		EFM_Load_Stored_Data("Alliance");
		EFM_Timer_LoadData("Alliance");
		EFM_MAP_LoadData("Alliance");
	elseif (myOptionName == "EFM_GUI_Options_Frame_LoadHorde") then
		EFM_Load_Stored_Data("Horde");
		EFM_Timer_LoadData("Horde");
		EFM_MAP_LoadData("Horde");
	elseif (myOptionName == "EFM_GUI_Options_Frame_LoadDruid") then
		EFM_Load_Stored_Data("Druid");
	end
end

-- Function: Handler routine for the divider OnShow events
function EFM_GUI_DividerOnShow(myOption)
	if (myOption:GetName() == "EFM_GUI_Options_Frame_LoadDivider") then
		EFM_GUI_Options_Frame_LoadDividerHeaderText:SetText(EFM_GUITEXT_LoadHeader);
	end
end
