--[[
	All In One Inventory (Cosmos)

	By sarf

	This mod allows you to configure AIOI from Cosmos.

	Thanks goes to AlexYoshi for inspiring me to seperate my addons into ever smaller parts. :)

	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]

AllInOneInventoryCosmos_Registered = 0;
AllInOneInventoryCosmos_Registered_Slash = 0;

AllInOneInventoryCosmos_Saved_Register = AllInOneInventory_Register;

AllInOneInventoryCosmos_Generic_Map = {
	["AllInOneInventory_Enabled"] = "COS_ALLINONEINVENTORY_ENABLED_X",
	["AllInOneInventory_ReplaceBags"] = "COS_ALLINONEINVENTORY_REPLACEBAGS_X",
	["AllInOneInventory_IncludeShotBags"] = "COS_ALLINONEINVENTORY_INCLUDE_SHOTBAGS_X",
	["AllInOneInventory_IncludeBagZero"] = "COS_ALLINONEINVENTORY_INCLUDE_BAGZERO_X",
	["AllInOneInventory_IncludeBagOne"] = "COS_ALLINONEINVENTORY_INCLUDE_BAGONE_X",
	["AllInOneInventory_IncludeBagTwo"] = "COS_ALLINONEINVENTORY_INCLUDE_BAGTWO_X",
	["AllInOneInventory_IncludeBagThree"] = "COS_ALLINONEINVENTORY_INCLUDE_BAGTHREE_X",
	["AllInOneInventory_IncludeBagFour"] = "COS_ALLINONEINVENTORY_INCLUDE_BAGFOUR_X",
	["AllInOneInventory_Columns"] = "COS_ALLINONEINVENTORY_COLUMNS",
	["AllInOneInventory_SwapBagOrder"] = "COS_ALLINONEINVENTORY_SWAP_BAG_ORDER_X",
	["AllInOneInventory_Alpha"] = "COS_ALLINONEINVENTORY_ALPHA",
	["AllInOneInventory_Scale"] = "COS_ALLINONEINVENTORY_SCALE"
};

function AllInOneInventoryCosmos_Generic_Toggle(toggle, name, p1, p2, p3, p4, p5)
	if ( not arg ) then
		arg = {};
	end
	if ( not name ) then
		AllInOneInventory_Print("ERROR: AllInOneInventoryCosmos_Generic_Toggle() given nil name!");
		return;
	end
	local retValue = AllInOneInventoryCosmos_Saved_Generic_Toggle(toggle, name, p1, p2, p3, p4, p5);
	local mappedValue = AllInOneInventoryCosmos_Generic_Map[name];
	if ( not mappedValue ) then
		return retValue;
	end
	local CVarName = nil;
	local CosmosVarName = nil;
	if ( type(mappedValue) == "table" ) then
		CVarName = mappedValue.CVarName;
		CosmosVarName = mappedValue.CosmosVarName;
	else
		CVarName = mappedValue;
	end
	if ( AllInOneInventoryCosmos_Registered == 1 ) then 
		if ( CVarName ) then
			AllInOneInventoryCosmos_Generic_CosmosUpdateCheckOnOff(CVarName, retValue);
		end
		if ( CosmosVarName ) then
			AllInOneInventoryCosmos_Generic_CosmosUpdateCheckOnOff(CosmosVarName, retValue);
		end
	end
	return retValue;
end

function AllInOneInventoryCosmos_Generic_Number(value, variableName, p1, p2, p3, p4, p5)
	if ( not arg ) then
		arg = {};
	end
	if ( not variableName ) then
		AllInOneInventory_Print("ERROR: AllInOneInventoryCosmos_Generic_Number() given nil variableName!");
		return;
	end
	local retValue = AllInOneInventoryCosmos_Saved_Generic_Number(value, variableName, p1, p2, p3, p4, p5);
	local mappedValue = AllInOneInventoryCosmos_Generic_Map[variableName];
	if ( not mappedValue ) then
		return retValue;
	end
	local CVarName = nil;
	local CosmosVarName = nil;
	if ( type(mappedValue) == "table" ) then
		CVarName = mappedValue.CVarName;
		CosmosVarName = mappedValue.CosmosVarName;
	else
		CVarName = mappedValue;
	end
	if ( AllInOneInventoryCosmos_Registered == 1 ) then 
		if ( CVarName ) then
			AllInOneInventoryCosmos_Generic_CosmosUpdateValue(CVarName, retValue);
		end
		if ( CosmosVarName ) then
			AllInOneInventoryCosmos_Generic_CosmosUpdateValue(CosmosVarName, retValue);
		end
	end
	return retValue;
end

function AllInOneInventoryCosmos_Generic_Value(value, variableName, p1, p2, p3, p4, p5)
	if ( not arg ) then
		arg = {};
	end
	if ( not variableName ) then
		AllInOneInventory_Print("ERROR: AllInOneInventoryCosmos_Generic_Value() given nil variableName!");
		return;
	end
	local retValue = AllInOneInventoryCosmos_Saved_Generic_Value(value, variableName, p1, p2, p3, p4, p5);
	local mappedValue = AllInOneInventoryCosmos_Generic_Map[variableName];
	if ( not mappedValue ) then
		return retValue;
	end
	local CVarName = nil;
	local CosmosVarName = nil;
	if ( type(mappedValue) == "table" ) then
		CVarName = mappedValue.CVarName;
		CosmosVarName = mappedValue.CosmosVarName;
	else
		CVarName = mappedValue;
	end
	if ( AllInOneInventoryCosmos_Registered == 1 ) then 
		if ( CVarName ) then
			AllInOneInventoryCosmos_Generic_CosmosUpdateValue(CVarName, retValue);
		end
		if ( CosmosVarName ) then
			AllInOneInventoryCosmos_Generic_CosmosUpdateValue(CosmosVarName, retValue);
		end
	end
	return retValue;
end



function AllInOneInventoryCosmosFrame_OnLoad()
	AllInOneInventoryCosmos_Saved_Generic_Toggle = AllInOneInventory_Generic_Toggle;
	AllInOneInventory_Generic_Toggle = AllInOneInventoryCosmos_Generic_Toggle;

	AllInOneInventoryCosmos_Saved_Generic_Value = AllInOneInventory_Generic_Value;
	AllInOneInventory_Generic_Value = AllInOneInventoryCosmos_Generic_Value;

	AllInOneInventoryCosmos_Saved_Generic_Number = AllInOneInventory_Generic_Number;
	AllInOneInventory_Generic_Number = AllInOneInventoryCosmos_Generic_Number;

	AllInOneInventoryCosmos_Register();
end

function AllInOneInventoryCosmosFrame_OnEvent(event)
	
end

function AllInOneInventoryCosmos_Register()
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		AllInOneInventoryCosmos_Register_Cosmos();
		if ( AllInOneInventoryCosmos_Registered_Slash ~= 1 ) then
			AllInOneInventory_Register_SlashCommands();
		end
	end
end

-- registers the mod with Cosmos
function AllInOneInventoryCosmos_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( AllInOneInventoryCosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY",
			"SECTION",
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER),
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_HEADER",
			"SEPARATOR",
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER),
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER_INFO)
		);
		--[[
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_ENABLED",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_ENABLED),
			TEXT(ALLINONEINVENTORY_ENABLED_INFO),
			AllInOneInventory_Toggle_Enabled_NoChat,
			AllInOneInventory_Enabled
		);
		]]--
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_REPLACEBAGS",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_REPLACEBAGS),
			TEXT(ALLINONEINVENTORY_REPLACEBAGS_INFO),
			AllInOneInventory_Toggle_ReplaceBags_NoChat,
			AllInOneInventory_ReplaceBags
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_SWAP_BAG_ORDER",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_SWAP_BAG_ORDER),
			TEXT(ALLINONEINVENTORY_SWAP_BAG_ORDER_INFO),
			AllInOneInventory_Toggle_SwapBagOrder_NoChat,
			AllInOneInventory_SwapBagOrder
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_INCLUDE_SHOTBAGS",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_INCLUDE_SHOTBAGS),
			TEXT(ALLINONEINVENTORY_INCLUDE_SHOTBAGS_INFO),
			AllInOneInventory_Toggle_IncludeShotBags_NoChat,
			AllInOneInventory_IncludeShotBags
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_INCLUDE_BAGZERO",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGZERO),
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGZERO_INFO),
			AllInOneInventory_Toggle_IncludeBagZero_NoChat,
			AllInOneInventory_IncludeBagZero
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_INCLUDE_BAGONE",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGONE),
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGONE_INFO),
			AllInOneInventory_Toggle_IncludeBagOne_NoChat,
			AllInOneInventory_IncludeBagOne
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_INCLUDE_BAGTWO",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGTWO),
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGTWO_INFO),
			AllInOneInventory_Toggle_IncludeBagTwo_NoChat,
			AllInOneInventory_IncludeBagTwo
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_INCLUDE_BAGTHREE",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGTHREE),
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGTHREE_INFO),
			AllInOneInventory_Toggle_IncludeBagThree_NoChat,
			AllInOneInventory_IncludeBagThree
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_INCLUDE_BAGFOUR",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGFOUR),
			TEXT(ALLINONEINVENTORY_INCLUDE_BAGFOUR_INFO),
			AllInOneInventory_Toggle_IncludeBagFour_NoChat,
			AllInOneInventory_IncludeBagFour
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_LOCKED",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_LOCKED),
			TEXT(ALLINONEINVENTORY_LOCKED_INFO),
			AllInOneInventory_Toggle_Locked_NoChat,
			AllInOneInventory_Locked
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_ALPHA",
			"SLIDER",
			TEXT(ALLINONEINVENTORY_ALPHA),
			TEXT(ALLINONEINVENTORY_ALPHA_INFO),
			AllInOneInventory_Change_Alpha_NoChat,
			1,
			AllInOneInventory_Alpha,
			ALLINONEINVENTORY_ALPHA_MIN,
			ALLINONEINVENTORY_ALPHA_MAX,
			"",
			0.01,
			1,
			TEXT(ALLINONEINVENTORY_ALPHA_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_SCALE",
			"SLIDER",
			TEXT(ALLINONEINVENTORY_SCALE),
			TEXT(ALLINONEINVENTORY_SCALE_INFO),
			AllInOneInventory_Change_Scale_NoChat,
			1,
			AllInOneInventory_Scale,
			ALLINONEINVENTORY_SCALE_MIN,
			ALLINONEINVENTORY_SCALE_MAX,
			"",
			0.01,
			1,
			TEXT(ALLINONEINVENTORY_SCALE_APPEND)
		);

		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_COLUMNS",
			"SLIDER",
			TEXT(ALLINONEINVENTORY_COLUMNS),
			TEXT(ALLINONEINVENTORY_COLUMNS_INFO),
			AllInOneInventory_Change_Columns_NoChat,
			1,
			AllInOneInventory_Columns,
			ALLINONEINVENTORY_COLUMNS_MIN,
			ALLINONEINVENTORY_COLUMNS_MAX,
			"",
			1,
			1,
			TEXT(ALLINONEINVENTORY_COLUMNS_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_RESETPOSITION",
			"BUTTON",
			TEXT(ALLINONEINVENTORY_RESETPOSITION),
			TEXT(ALLINONEINVENTORY_RESETPOSITION_INFO),
			AllInOneInventoryFrame_ResetButton,
			0,
			0,
			0,
			0,
			ALLINONEINVENTORY_RESETPOSITION_NAME
		);
		if ( Cosmos_RegisterChatCommand ) or ( ( Sky ) and ( Sky.registerSlashCommand ) ) then
			AllInOneInventoryCosmos_Registered_Slash = 1;
			local AllInOneInventoryMainCommands = {"/allinoneinventory","/aioi"};
			if ( Sky ) and ( Sky.registerSlashCommand ) then
				Sky.registerSlashCommand({ 
					id = "ALLINONEINVENTORY_MAIN_COMMANDS",
					commands = AllInOneInventoryMainCommands,
					onExecute = AllInOneInventory_Main_ChatCommandHandler,
					helpText = ALLINONEINVENTORY_CHAT_COMMAND_INFO,
					action = "before",
				});
			else
				Cosmos_RegisterChatCommand (
					"ALLINONEINVENTORY_MAIN_COMMANDS", -- Some Unique Group ID
					AllInOneInventoryMainCommands, -- The Commands
					AllInOneInventory_Main_ChatCommandHandler,
					ALLINONEINVENTORY_CHAT_COMMAND_INFO -- Description String
				);
			end
		end
		if ( Cosmos_RegisterButton ) then 
			Cosmos_RegisterButton(
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER),
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER_SHORT_INFO), 
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER_INFO), 
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER_TEXTURE), 
				ToggleAllInOneInventoryFrame
			);
		end
		AllInOneInventoryCosmos_Registered = 1;
	end
end

function AllInOneInventoryCosmos_Generic_CosmosUpdateCheckOnOff(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_CHECKONOFF, value);
	end
	if ( CosmosMaster_DrawData ) then
		CosmosMaster_DrawData();
	end
end

function AllInOneInventoryCosmos_Generic_CosmosUpdateValue(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_SLIDERVALUE, value);
	end
	if ( CosmosMaster_DrawData ) then
		CosmosMaster_DrawData();
	end
end



