
function AQ_AutoReactiveClass_Khaos()
	if ( Khaos ) then
		local optionSetEasy = {
			id = "AQ_AutoReactiveClass_BasicOptionId";
			text = AUTOREACTIVECLASS_CONFIG_HEADER;
			helptext = AUTOREACTIVECLASS_CONFIG_HEADER_INFO;
			difficulty = 1;
			options = {
				{
					id = "CheckBoxEnabled";
					key = "enabled";
					text = AUTOREACTIVECLASS_CONFIG_ENABLED;
					helptext = AUTOREACTIVECLASS_CONFIG_ENABLED_INFO;
					check = true;
					callback = function(state) AQ_AutoReactiveClass_Options.enabled = state.checked; end;
					type = K_TEXT;
					checked = AQ_AutoReactiveClass_Options.enabled;
					feedback = function(state) local s = AUTOREACTIVECLASS_STATE_ENABLED; if ( not state.checked ) then s = AUTOREACTIVECLASS_STATE_DISABLED; end return AUTOREACTIVECLASS_STATE_TEXT.." "..s; end;
					default = {
						checked = true;
					};
					disabled = {
						checked = false;
					};
				},
				{
					id = "CheckBoxShowMessage";
					key = "showMessage";
					text = AUTOREACTIVECLASS_CONFIG_SHOW_MESSAGE;
					helptext = AUTOREACTIVECLASS_CONFIG_SHOW_MESSAGE_INFO;
					check = true;
					checked = AQ_AutoReactiveClass_Options.showMessage;
					callback = function(state) AQ_AutoReactiveClass_Options.showMessage = state.checked; end;
					type = K_TEXT;
					feedback = function(state) local s = AUTOREACTIVECLASS_STATE_ENABLED; if ( not state.checked ) then s = AUTOREACTIVECLASS_STATE_DISABLED; end return AUTOREACTIVECLASS_STATE_TEXT.." "..s; end;
					default = {
						checked = pcheck;
					};
					disabled = {
						checked = false;
					};
				},
				{
					id = "CheckBoxQueueAction";
					key = "queueAction";
					text = AUTOREACTIVECLASS_CONFIG_QUEUE_ACTION;
					helptext = AUTOREACTIVECLASS_CONFIG_QUEUE_ACTION_INFO;
					check = true;
					checked = AQ_AutoReactiveClass_Options.queueAction;
					callback = function(state) AQ_AutoReactiveClass_Options.queueAction = state.checked; end;
					type = K_TEXT;
					feedback = function(state) local s = AUTOREACTIVECLASS_STATE_ENABLED; if ( not state.checked ) then s = AUTOREACTIVECLASS_STATE_DISABLED; end return AUTOREACTIVECLASS_STATE_TEXT.." "..s; end;
					default = {
						checked = pcheck;
					};
					disabled = {
						checked = false;
					};
				},
				{
					id = "CheckBoxUseHighestEarthShockAlways";
					key = "useHighestEarthShockAlways";
					text = AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_ALWAYS;
					helptext = AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_ALWAYS_INFO;
					check = true;
					checked = AQ_AutoReactiveClass_Options.useHighestEarthShockAlways;
					callback = function(state) AQ_AutoReactiveClass_Options.useHighestEarthShockAlways = state.checked; end;
					type = K_TEXT;
					feedback = function(state) local s = AUTOREACTIVECLASS_STATE_ENABLED; if ( not state.checked ) then s = AUTOREACTIVECLASS_STATE_DISABLED; end return AUTOREACTIVECLASS_STATE_TEXT.." "..s; end;
					default = {
						checked = pcheck;
					};
					disabled = {
						checked = false;
					};
				},
				{
					id = "CheckBoxUseHighestEarthShockWhenClearcastingActive";
					key = "useHighestEarthShockWhenClearcastingActive";
					text = AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_WHEN_CLEARCASTING;
					helptext = AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_WHEN_CLEARCASTING_INFO;
					check = true;
					checked = AQ_AutoReactiveClass_Options.useHighestEarthShockWhenClearcastingActive;
					callback = function(state) AQ_AutoReactiveClass_Options.useHighestEarthShockWhenClearcastingActive = state.checked; end;
					type = K_TEXT;
					feedback = function(state) local s = AUTOREACTIVECLASS_STATE_ENABLED; if ( not state.checked ) then s = AUTOREACTIVECLASS_STATE_DISABLED; end return AUTOREACTIVECLASS_STATE_TEXT.." "..s; end;
					default = {
						checked = pcheck;
					};
					disabled = {
						checked = false;
					};
				}
			};
			default = true;
		};
		Khaos.registerOptionSet( "combat", optionSetEasy );
		return true;
	else
		return false;
	end
end