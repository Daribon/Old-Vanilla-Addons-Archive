
function AQ_AutoReactiveClass_CosmosBoolean(name)
	if ( AQ_AutoReactiveClass_Options[name] ) then
		return 1;
	else
		return 0;
	end
end

function AQ_AutoReactiveClass_Toggle_Variable(name, toggle)
	if ( not name ) then
		return;
	end
	if ( toggle == 1 ) then
		AQ_AutoReactiveClass_Options[name] = true;
	elseif ( toggle == 0 ) then
		AQ_AutoReactiveClass_Options[name] = false;
	else
		AQ_AutoReactiveClass_Options[name] = not AQ_AutoReactiveClass_Options[name];
	end
end

function AQ_AutoReactiveClass_Toggle_Enabled(toggle)
	AQ_AutoReactiveClass_Toggle_Variable("enabled", toggle);
end

function AQ_AutoReactiveClass_Toggle_ShowMessage(toggle)
	AQ_AutoReactiveClass_Toggle_Variable("showMessage", toggle);
end

function AQ_AutoReactiveClass_Toggle_QueueAction(toggle)
	AQ_AutoReactiveClass_Toggle_Variable("queueAction", toggle);
end


function AQ_AutoReactiveClass_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration(
			"COS_AUTOREACTIVECLASS",
			"SECTION",
			TEXT(AUTOREACTIVECLASS_CONFIG_HEADER),
			TEXT(AUTOREACTIVECLASS_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_AUTOREACTIVECLASS_HEADER",
			"SEPARATOR",
			TEXT(AUTOREACTIVECLASS_CONFIG_HEADER),
			TEXT(AUTOREACTIVECLASS_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_AUTOREACTIVECLASS_CONFIG_ENABLED",
			"CHECKBOX",
			TEXT(AUTOREACTIVECLASS_CONFIG_ENABLED),
			TEXT(AUTOREACTIVECLASS_CONFIG_ENABLED_INFO),
			AQ_AutoReactiveClass_Toggle_Enabled,
			AQ_AutoReactiveClass_CosmosBoolean("enabled")
		);
		Cosmos_RegisterConfiguration(
			"COS_AUTOREACTIVECLASS_CONFIG_SHOW_MESSAGE",
			"CHECKBOX",
			TEXT(AUTOREACTIVECLASS_CONFIG_SHOW_MESSAGE),
			TEXT(AUTOREACTIVECLASS_CONFIG_SHOW_MESSAGE_INFO),
			AQ_AutoReactiveClass_Toggle_ShowMessage,
			AQ_AutoReactiveClass_CosmosBoolean("showMessage")
		);
		Cosmos_RegisterConfiguration(
			"COS_AUTOREACTIVECLASS_CONFIG_QUEUE_ACTION",
			"CHECKBOX",
			TEXT(AUTOREACTIVECLASS_CONFIG_QUEUE_ACTION),
			TEXT(AUTOREACTIVECLASS_CONFIG_QUEUE_ACTION_INFO),
			AQ_AutoReactiveClass_Toggle_QueueAction,
			AQ_AutoReactiveClass_CosmosBoolean("queueAction")
		);
	end
end

