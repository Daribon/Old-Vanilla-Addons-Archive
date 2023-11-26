--- This file was very much inspired by EquipCompare.
-- Lots of credits to it and Legorol! ^^
-- /sarf

function BadRep_Config_OptionSet_Toggle(toggle)
	-- do not know if this is necessary, but...
	BadRep_Config_Toggle_Enabled(toggle);
end

function BadRep_Config_Toggle_Enabled(checked)
	-- fix if we want to add on Cosmos config for backwards compatibility
	if ( checked == 0 ) then 
		checked = false; 
	end
	if ( checked ) then
		BadRepFrame:Show();
	else
		BadRepFrame:Hide();
	end
	BadRep_Options.enabled = checked;
	BadRep_RepFrame_Update();
end

function BadRep_Options_Khaos()
	if ( not Khaos ) or ( not Khaos.registerOptionSet ) or ( BadRep_Options_Khaos_Registered ) then
		return false;
	end
	BadRep_Options_Khaos_Registered = true;

	Khaos.registerOptionSet (
		"other",
		{
			id = "BadRepOptionSet";
			text = BADREP_CONFIG_SECTION;
			helptext = BADREP_CONFIG_SECTION_INFO;
			difficulty = 1;
			callback = BadRep_Config_OptionSet_Toggle;
			default = true;
			options = {
				{
					id = "BadRepOptionHeader";
					type = K_HEADER;
					difficulty = 1;
					text = BADREP_CONFIG_SECTION;
					helptext = BADREP_CONFIG_SECTION_INFO;
				},
				{
					id = "BadRepOptionEnabled";
					type = K_TEXT;
					difficulty = 1;
					text = BADREP_CONFIG_ENABLED;
					helptext = BADREP_CONFIG_ENABLED_INFO;
					callback = function(state) BadRep_Config_Toggle_Enabled(state.checked); end;
					feedback = function(state)
						if (state.checked) then
							return BADREP_CONFIG_ENABLED_ON;
						else
							return BADREP_CONFIG_ENABLED_OFF;
						end
					end;
					check = true;
					default = { checked = true; };
					disabled = { checked = false; };
				}
			}
		}
	)

end