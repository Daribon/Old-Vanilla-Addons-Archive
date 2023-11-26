
function ItemBuffCharges_Khaos_GetBoolean(index)
	return ItemBuffCharges_Options[index];
end

function ItemBuffCharges_Khaos_SetEnable(state)
	if ( state ) then
		ItemBuffCharges_SetEnabled(state.checked);
	else
		ItemBuffCharges_SetEnabled(false);
	end
end

ItemBuffCharges_Khaos_Override_SetEnabled_Mutex = false;

function ItemBuffCharges_Khaos_Override_SetEnabled(value)
	if ( ItemBuffCharges_Khaos_Override_SetEnabled_Mutex ) then
		return;
	end
	ItemBuffCharges_Khaos_Override_SetEnabled_Mutex = true;
	
	ItemBuffCharges_Khaos_Saved_SetEnabled(value);
	
	local khaosKey = Khaos.getSetKey(ITEMBUFFCHARGES_KHAOS_SET_ID, "enable");
	if ( khaosKey ) then
		Khaos.setSetKeyParameter(ITEMBUFFCHARGES_KHAOS_SET_ID, "enable", "checked", value)

		if ( KhaosFrame:IsVisible() ) then 
			if ( KhaosCore.getCurrentSet() == ITEMBUFFCHARGES_KHAOS_SET_ID ) then 
				Khaos.refresh()
			end
		end

	end
	
	ItemBuffCharges_Khaos_Override_SetEnabled_Mutex = false;
end


function ItemBuffCharges_Khaos_SlashCommand_Enable(msg, callback, state)
	if ( state ) then
		ItemBuffCharges_SlashCommand_Enable(state.checked);
	else
		ItemBuffCharges_SlashCommand_Enable(false);
	end
end

function ItemBuffCharges_Register_Khaos()

	if ( not Khaos ) then
		return false;
	end

	ItemBuffCharges_Khaos_Saved_SetEnabled = ItemBuffCharges_SetEnabled;
	ItemBuffCharges_SetEnabled = ItemBuffCharges_Khaos_Override_SetEnabled;

	local optionSetEasy = {
		id = ITEMBUFFCHARGES_KHAOS_SET_ID;
		text = ITEMBUFFCHARGES_HEADER;
		helptext = ITEMBUFFCHARGES_HEADER_INFO;
		difficulty = 1;
		default = true;
		options = {
			{
				id = "ItemBuffChargesCheckBoxEnabled";
				key = "enable";
				text = ITEMBUFFCHARGES_CHECK;
				helptext = ITEMBUFFCHARGES_CHECK_INFO;
				check = true;
				callback = ItemBuffCharges_Khaos_SetEnable;
				type = K_TEXT;
				feedback = function(state) local s = ITEMBUFFCHARGES_STATE_ENABLED; if ( not state.checked ) then s = ITEMBUFFCHARGES_STATE_DISABLED; end return string.format(ITEMBUFFCHARGES_STATE_CHECK, s); end;
				default = {
					checked = ItemBuffCharges_Options.enable;
				};
				disabled = {
					checked = false;
				};
			}
		};
	};
	local slashCommandParseTreeEnable = {
		checked = true;
	};
	local slashCommandParseTreeDisable = {
		checked = false;
	};
	
	local slashCommandParseTree = {
		default = {
			callback = ItemBuffCharges_SlashCommand_Usage;
		};
		[1] = {
			key = "enable";
			stringMap = {};
			callback = ItemBuffCharges_Khaos_SlashCommand_Enable;
		};
	};
	for k, v in ITEMBUFFCHARGES_SLASH_ENABLE do
		slashCommandParseTree[1].stringMap[string.lower(v)] = slashCommandParseTreeEnable;
	end
	
	for k, v in ITEMBUFFCHARGES_SLASH_DISABLE do
		slashCommandParseTree[1].stringMap[string.lower(v)] = slashCommandParseTreeDisable;
	end

	local slashCommand = {
		id = "ItemBuffChargesCommand";
		commands = ITEMBUFFCHARGES_SLASH_CMDS;
		parseTree = slashCommandParseTree;
		helpText = ITEMBUFFCHARGES_SLASH_INFO;
	};
	optionSetEasy.commands = {
		slashCommand;
	};

	Khaos.registerOptionSet( "inventory", optionSetEasy );

	return true;
end