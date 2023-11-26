
function ItemBuffCharges_Cosmos_SetEnabled(value)
	if ( value == 1 ) then
		ItemBuffCharges_SetEnabled(true);
	else
		ItemBuffCharges_SetEnabled(false);
	end
end

function ItemBuffCharges_Cosmos_GetCosmosBoolean(index)
	if ( type(index) == "boolean" ) then
		if ( index ) then
			return 1;
		else
			return 0;
		end
	end
	if ( ItemBuffCharges_Options[index] ) then
		return 1;
	else
		return 0;
	end
end

ItemBuffCharges_Cosmos_Override_SetEnabled_Mutex = false;

function ItemBuffCharges_Cosmos_Override_SetEnabled(value)
	if ( ItemBuffCharges_Cosmos_Override_SetEnabled_Mutex ) then
		return;
	end
	ItemBuffCharges_Cosmos_Override_SetEnabled_Mutex = true;
	ItemBuffCharges_Cosmos_Saved_SetEnabled(value);
	Cosmos_UpdateValue("COS_ITEMBUFFCHARGES_ENABLED", CSM_CHECKONOFF, ItemBuffCharges_Cosmos_GetCosmosBoolean(value));
	ItemBuffCharges_Cosmos_Override_SetEnabled_Mutex = false;
end

function ItemBuffCharges_Register_Cosmos()
	if ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) then
		ItemBuffCharges_Cosmos_Saved_SetEnabled = ItemBuffCharges_SetEnabled;
		ItemBuffCharges_SetEnabled = ItemBuffCharges_Cosmos_Override_SetEnabled;
		Cosmos_RegisterConfiguration(
			"COS_ITEMBUFFCHARGES",
			"SECTION",
			TEXT(ITEMBUFFCHARGES_HEADER),
			TEXT(ITEMBUFFCHARGES_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ITEMBUFFCHARGES_HEADER",
			"SEPARATOR",
			TEXT(ITEMBUFFCHARGES_HEADER),
			TEXT(ITEMBUFFCHARGES_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ITEMBUFFCHARGES_ENABLED",
			"CHECKBOX",
			TEXT(ITEMBUFFCHARGES_CHECK),
			TEXT(ITEMBUFFCHARGES_CHECK_INFO),
			ItemBuffCharges_Cosmos_SetEnabled,
			ItemBuffCharges_Cosmos_GetCosmosBoolean("enable")
		);
		return true;
	end	


	return false;
end