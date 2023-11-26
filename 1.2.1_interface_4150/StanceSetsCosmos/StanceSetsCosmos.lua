function StanceSetsCosmos_OnLoad()
	if ( Cosmos_RegisterButton ) then 
		Cosmos_RegisterButton(
			TEXT(COSMOS_STANCESETS_NAME),
			TEXT(COSMOS_STANCESETS_SHORT_DESC), 
			TEXT(COSMOS_STANCESETS_LONG_DESC), 
			TEXT(COSMOS_STANCESETS_BUTTON_TEXTURE), 
			StanceSets_Toggle
		);
	end
end

function StanceSets_OnEvent(event, arg1)
end

