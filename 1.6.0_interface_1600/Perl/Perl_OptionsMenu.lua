-- Display or hide the options menu.
function Perl_OptionsMenu_Toggle()
	if(Perl_OptionsMenu_Frame:IsVisible()) then
		Perl_OptionsMenu_Frame:Hide();
	else
		Perl_OptionsMenu_Frame:Show();
	end
end

-- OnLoad function for the options menu.
function Perl_OptionsMenu_OnLoad()
	UIPanelWindows['Perl_OptionsMenu_Frame'] = {area = 'center', pushable = 0};
end

-- This function is called when the options screen is closed.
-- It's first task is to check to see if it is running under myAddons and if so return to that menu
-- The second option actually runs the config changes as due to the number of changes this will
-- be way too complex to do this every time there is an update in the config screen
function Perl_OptionsMenu_OnHide()
	if(MYADDONS_ACTIVE_OPTIONSFRAME == this) then
		ShowUIPanel(myAddOnsFrame);
	end
	
	-- Do all config changes.
	Perl_OptionActions();
end

-- Function to set the "Checked/Unchecked" option for a checkbox...
function Perl_OptionsMenu_CheckBox(frame, variable)
	if (variable == 1) then
		frame:SetChecked(true);
	else
		frame:SetChecked(false);
	end
end

-- This function toggles the variable given between 1 and 0.
function Perl_OptionsMenu_Toggle(variable)
	if (variable == 1) then
		variable = 0;
	else
		variable = 1;
	end
	return variable;
end

-- This function allows the "tabs" to work
function Perl_OptionsMenu_Select(framename)
	if (framename == "Perl_OptionsMenu_Frame_TabGlobal") then
		Perl_OptionsMenu_Frame_Global:Show();
		Perl_OptionsMenu_Frame_CastParty:Hide();
		Perl_OptionsMenu_Frame_Player:Hide();
		Perl_OptionsMenu_Frame_Target:Hide();
		Perl_OptionsMenu_Frame_Party:Hide();
		Perl_OptionsMenu_Frame_Raid:Hide();
	elseif (framename == "Perl_OptionsMenu_Frame_TabCastParty") then
		Perl_OptionsMenu_Frame_Global:Hide();
		Perl_OptionsMenu_Frame_CastParty:Show();
		Perl_OptionsMenu_Frame_Player:Hide();
		Perl_OptionsMenu_Frame_Target:Hide();
		Perl_OptionsMenu_Frame_Party:Hide();
		Perl_OptionsMenu_Frame_Raid:Hide();
	elseif (framename == "Perl_OptionsMenu_Frame_TabPlayer") then
		Perl_OptionsMenu_Frame_Global:Hide();
		Perl_OptionsMenu_Frame_CastParty:Hide();
		Perl_OptionsMenu_Frame_Player:Show();
		Perl_OptionsMenu_Frame_Target:Hide();
		Perl_OptionsMenu_Frame_Party:Hide();
		Perl_OptionsMenu_Frame_Raid:Hide();
	elseif (framename == "Perl_OptionsMenu_Frame_TabTarget") then
		Perl_OptionsMenu_Frame_Global:Hide();
		Perl_OptionsMenu_Frame_CastParty:Hide();
		Perl_OptionsMenu_Frame_Player:Hide();
		Perl_OptionsMenu_Frame_Target:Show();
		Perl_OptionsMenu_Frame_Party:Hide();
		Perl_OptionsMenu_Frame_Raid:Hide();
	elseif (framename == "Perl_OptionsMenu_Frame_TabParty") then
		Perl_OptionsMenu_Frame_Global:Hide();
		Perl_OptionsMenu_Frame_CastParty:Hide();
		Perl_OptionsMenu_Frame_Player:Hide();
		Perl_OptionsMenu_Frame_Target:Hide();
		Perl_OptionsMenu_Frame_Party:Show();
		Perl_OptionsMenu_Frame_Raid:Hide();
	elseif (framename == "Perl_OptionsMenu_Frame_TabRaid") then
		Perl_OptionsMenu_Frame_Global:Hide();
		Perl_OptionsMenu_Frame_CastParty:Hide();
		Perl_OptionsMenu_Frame_Player:Hide();
		Perl_OptionsMenu_Frame_Target:Hide();
		Perl_OptionsMenu_Frame_Party:Hide();
		Perl_OptionsMenu_Frame_Raid:Show();
	end
end