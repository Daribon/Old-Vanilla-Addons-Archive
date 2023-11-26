LootLink_RefreshOnShow = 0;
LootLink_InspectOnMouseover = 0;

LootLinkExtension_Saved_LootLink_OnShow = nil;

function LootLinkExtension_OnLoad()
	this:RegisterEvent("MERCHANT_SHOW");
	this:RegisterEvent("MERCHANT_UPDATE");
	this:RegisterEvent("MERCHANT_UPDATE");

	LootLinkExtension_CosmosRegister();

	LootLinkExtension_HookLootLinkFunctions();
end


function LootLinkExtension_CosmosRegister()
	if ( Cosmos_RegisterButton ) then 
		Cosmos_RegisterButton(
			TEXT(COSMOS_LOOTLINK_NAME),
			TEXT(COSMOS_LOOTLINK_SHORT_DESC), 
			TEXT(COSMOS_LOOTLINK_LONG_DESC), 
			TEXT(COSMOS_LOOTLINK_BUTTON_TEXTURE), 
			ToggleLootLink
		);
	end
	if ( Cosmos_RegisterConfiguration ) then 
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
			"COS_LOOTLINK_INSPECT_ON_MOUSEOVER",
			"CHECKBOX",
			TEXT(COSMOS_LOOTLINK_INSPECT_ON_MOUSEOVER),
			TEXT(COSMOS_LOOTLINK_INSPECT_ON_MOUSEOVER_INFO),
			LootLink_SetInspectOnMouseover,
			LootLink_InspectOnMouseover
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTLINK_REFRESHONSHOW",
			"CHECKBOX",
			TEXT(COSMOS_LOOTLINK_REFRESH_ON_OPEN),
			TEXT(COSMOS_LOOTLINK_REFRESH_ON_OPEN_INFO),
			LootLink_SetRefreshOnShow,
			LootLink_RefreshOnShow
		);
	end
end

function LootLinkExtension_OnMerchantEvent()
	LootLink_ScanMerchant();
end

function LootLinkExtension_OnMouseOverUnitEvent()
	if( LootLink_InspectOnMouseover == 1 ) then
		if( UnitIsUnit("mouseover", "player") ) then
			return;
		elseif( UnitIsPlayer("mouseover") ) then
			LootLink_Inspect("mouseover");
		end
	end
end

function LootLinkExtension_OnEvent(event)
	if( ( event == "MERCHANT_SHOW" ) or ( event == "MERCHANT_UPDATE" ) ) then
		LootLinkExtension_OnMerchantEvent();
		return;
	elseif( event == "UPDATE_MOUSEOVER_UNIT" ) then
		LootLinkExtension_OnMouseOverUnitEvent();
		return;
	end
end

function LootLink_ScanMerchant()
	local size;
	local slotid;
	local link;
	
	size = GetMerchantNumItems();
	for slotid = size, 1, -1 do
		local name, _, merchantBuyPrice, quantity = GetMerchantItemInfo(slotid);
		link = GetMerchantItemLink(slotid);
		if( link ) then
			LootLink_ProcessLinks(link);
		end
		if ((ItemLinks[name] ~= nil) and (merchantBuyPrice ~= nil)) then
			local realBuyPrice = merchantBuyPrice;
			if ( quantity > 0 ) then
				realBuyPrice = realBuyPrice / quantity;
			end
			if(ItemLinks[name].buyPrice ~= nil ) then
				if(ItemLinks[name].buyPrice > realBuyPrice) then
  					ItemLinks[name].buyPrice = realBuyPrice;
				end
			else
				ItemLinks[name].buyPrice = realBuyPrice;
			end
			if ( ItemLinks[name].buyPrice ) then
				local newPrice = math.ceil(ItemLinks[name].buyPrice / 4);
				if ( not ItemLinks[name].price ) or ( newPrice < ItemLinks[name].price ) then
					ItemLinks[name].price = newPrice;
				end
			end
		end
	end
end



function LootLink_GetCoinValue(value)
	value = floor(value);
	local gold = floor(value / 10000);
	value = value - gold * 10000;
	local silver = floor(value / 100);
	value = value - silver * 100;
	local str = "";
	if ( gold > 0 ) then
		if ( strlen(str) > 0 ) then str = str.." "; end
		str = str..gold.." g";
	end
	if ( silver > 0 ) then
		if ( strlen(str) > 0 ) then str = str.." "; end
		str = str..silver.." s";
	end
	if ( value > 0 ) then
		if ( strlen(str) > 0 ) then str = str.." "; end
		str = str..value.." c";
	end
	return str;
end

function LootLink_SetRefreshOnShow(toggle)
	if ( toggle ~= LootLink_RefreshOnShow ) then
		LootLink_RefreshOnShow = toggle;
	end
end

function LootLinkExtension_HookLootLinkFunctions()
	LootLinkExtension_Saved_LootLink_OnShow = LootLink_OnShow;
	LootLink_OnShow = LootLinkExtension_LootLink_OnShow;
end

function LootLinkExtension_LootLink_OnShow()
	if ( LootLink_RefreshOnShow == 1 ) then
		LootLink_Refresh();
	end
	LootLinkExtension_Saved_LootLink_OnShow()
end

