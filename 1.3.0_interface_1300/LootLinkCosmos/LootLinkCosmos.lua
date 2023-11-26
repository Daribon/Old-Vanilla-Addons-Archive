function LootLinkCosmos_OnLoad()
	LootLinkCosmos_CosmosRegister();
end

function LootLinkCosmos_OnEvent(event)
end

function LootLinkCosmos_ShouldAddOptions()
	if ( LootLinkExtension_IsPresent ) then
		return LootLinkExtension_IsPresent();
	else
		return false;
	end
end

function LootLinkCosmos_CosmosRegister()
	if ( Cosmos_RegisterButton ) then 
		Cosmos_RegisterButton(
			TEXT(COSMOS_LOOTLINK_NAME),
			TEXT(COSMOS_LOOTLINK_SHORT_DESC), 
			TEXT(COSMOS_LOOTLINK_LONG_DESC), 
			TEXT(COSMOS_LOOTLINK_BUTTON_TEXTURE), 
			ToggleLootLink
		);
	end
	if ( Cosmos_RegisterConfiguration ) and ( LootLinkCosmos_ShouldAddOptions() ) then 
		Cosmos_RegisterConfiguration(
			"COS_LOOTLINK",
			"SECTION",
			TEXT(COSMOS_LOOTLINK_NAME),
			TEXT(COSMOS_LOOTLINK_LONG_DESC)
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTLINK_HEADER",
			"SEPARATOR",
			TEXT(COSMOS_LOOTLINK_NAME),
			TEXT(COSMOS_LOOTLINK_LONG_DESC)
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTLINK_SCAN_MERCHANT_ITEMS",
			"CHECKBOX",
			TEXT(COSMOS_LOOTLINK_SCAN_MERCHANT_ITEMS),
			TEXT(COSMOS_LOOTLINK_SCAN_MERCHANT_ITEMS_INFO),
			LootLinkExtension_SetScanMerchantItems,
			LootLinkExtension_ScanMerchantItems
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTLINK_INSPECT_ON_MOUSEOVER",
			"CHECKBOX",
			TEXT(COSMOS_LOOTLINK_INSPECT_ON_MOUSEOVER),
			TEXT(COSMOS_LOOTLINK_INSPECT_ON_MOUSEOVER_INFO),
			LootLinkExtension_SetInspectOnMouseover,
			LootLinkExtension_InspectOnMouseover
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTLINK_REFRESHONSHOW",
			"CHECKBOX",
			TEXT(COSMOS_LOOTLINK_REFRESH_ON_OPEN),
			TEXT(COSMOS_LOOTLINK_REFRESH_ON_OPEN_INFO),
			LootLinkExtension_SetRefreshOnShow,
			LootLinkExtension_RefreshOnShow
		);
	end
end