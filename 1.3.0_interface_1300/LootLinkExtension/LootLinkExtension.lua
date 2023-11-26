LOOTLINKEXTENSION_INVENTORY_SLOT_LIST = {
	{ name = "HeadSlot" },
	{ name = "NeckSlot" },
	{ name = "ShoulderSlot" },
	{ name = "BackSlot" },
	{ name = "ChestSlot" },
	{ name = "ShirtSlot" },
	{ name = "TabardSlot" },
	{ name = "WristSlot" },
	{ name = "HandsSlot" },
	{ name = "WaistSlot" },
	{ name = "LegsSlot" },
	{ name = "FeetSlot" },
	{ name = "Finger0Slot" },
	{ name = "Finger1Slot" },
	{ name = "Trinket0Slot" },
	{ name = "Trinket1Slot" },
	{ name = "MainHandSlot" },
	{ name = "SecondaryHandSlot" },
	{ name = "RangedSlot" },
};

LootLinkExtension_ScanMerchantItems = 1;
LootLinkExtension_RefreshOnShow = 0;
LootLinkExtension_InspectOnMouseover = 0;

LootLinkExtension_Saved_LootLink_OnShow = nil;
LootLinkExtension_Saved_GameTooltip_SetQuestItem = nil;
LootLinkExtension_Saved_GameTooltip_SetQuestLogItem = nil;
LootLinkExtension_Saved_GameTooltip_SetCraftItem = nil;
LootLinkExtension_Saved_GameTooltip_SetCraftSpell = nil;
LootLinkExtension_Saved_GameTooltip_SetTradeSkillItem = nil;
LootLinkExtension_Saved_GameTooltip_SetTradePlayerItem = nil;
LootLinkExtension_Saved_GameTooltip_SetTradeTargetItem = nil;
LootLinkExtension_Saved_ItemRefTooltip_SetHyperlink = nil;

function LootLinkExtension_OnLoad()
	this:RegisterEvent("MERCHANT_SHOW");
	this:RegisterEvent("MERCHANT_UPDATE");

	LootLinkExtension_HookFunctions();

	LootLinkExtension_AddSlashCommands();
end


function LootLinkExtension_IsPresent()
	return true;
end

function LootLinkExtension_OnMerchantEvent()
	if ( LootLinkExtension_ScanMerchantItems == 1 ) then
		LootLinkExtension_ScanMerchant();
	end
end

function LootLinkExtension_OnMouseOverUnitEvent()
	if( LootLinkExtension_InspectOnMouseover == 1 ) then
		if( UnitIsUnit("mouseover", "player") ) then
			return;
		elseif( UnitIsPlayer("mouseover") ) then
			LootLinkExtension_Inspect("mouseover");
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

function LootLinkExtension_ScanMerchant()
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



function LootLinkExtension_GetCoinValue(value)
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

function LootLinkExtension_ToggleValue(variableName, value)
	local currentValue = getglobal(variableName);
	if ( currentValue ~= value ) then
		if ( value == -1 ) then
			if ( currentValue ) and ( currentValue == 1 ) then
				value = 0;
			else
				value = 1;
			end
		end
		setglobal(variableName, value);
	end
end

function LootLinkExtension_SetRefreshOnShow(toggle)
	LootLinkExtension_ToggleValue("LootLinkExtension_RefreshOnShow", toggle);
end

function LootLinkExtension_SetInspectOnMouseOver(toggle)
	LootLinkExtension_ToggleValue("LootLinkExtension_InspectOnMouseover", toggle);
end

function LootLinkExtension_SetScanMerchantItems(toggle)
	LootLinkExtension_ToggleValue("LootLinkExtension_ScanMerchantItems", toggle);
end

function LootLinkExtension_HookFunctions()
	LootLinkExtension_HookLootLinkFunctions();
	
	LootLinkExtension_Saved_GameTooltip_SetQuestItem = GameTooltip.SetQuestItem;
	GameTooltip.SetQuestItem = LootLinkExtension_GameTooltip_SetQuestItem;
	
	LootLinkExtension_Saved_GameTooltip_SetQuestLogItem = GameTooltip.SetQuestLogItem;
	GameTooltip.SetQuestLogItem = LootLinkExtension_GameTooltip_SetQuestLogItem;

	LootLinkExtension_Saved_GameTooltip_SetCraftItem = GameTooltip.SetCraftItem;
	GameTooltip.SetCraftItem = LootLinkExtension_GameTooltip_SetCraftItem;

	LootLinkExtension_Saved_GameTooltip_SetCraftSpell = GameTooltip.SetCraftSpell;
	GameTooltip.SetCraftSpell = LootLinkExtension_GameTooltip_SetCraftSpell;

	LootLinkExtension_Saved_GameTooltip_SetTradeSkillItem = GameTooltip.SetTradeSkillItem;
	GameTooltip.SetTradeSkillItem = LootLinkExtension_GameTooltip_SetTradeSkillItem;

	LootLinkExtension_Saved_GameTooltip_SetTradePlayerItem = GameTooltip.SetTradePlayerItem;
	GameTooltip.SetTradePlayerItem = LootLinkExtension_GameTooltip_SetTradePlayerItem;
	
	LootLinkExtension_Saved_GameTooltip_SetTradeTargetItem = GameTooltip.SetTradeTargetItem;
	GameTooltip.SetTradeTargetItem = LootLinkExtension_GameTooltip_SetTradeTargetItem;
	
	--LootLinkExtension_Saved_ItemRefTooltip_SetHyperlink = ItemRefTooltip.SetHyperlink;
	--ItemRefTooltip.SetHyperlink = LootLinkExtension_ItemRefTooltip_SetHyperlink;
end

function LootLinkExtension_HookLootLinkFunctions()
	LootLinkExtension_Saved_LootLink_OnShow = LootLink_OnShow;
	LootLink_OnShow = LootLinkExtension_LootLink_OnShow;
end

function LootLinkExtension_LootLink_OnShow()
	if ( LootLinkExtension_RefreshOnShow == 1 ) then
		LootLink_Refresh();
	end
	LootLinkExtension_Saved_LootLink_OnShow()
end

function LootLinkExtension_GameTooltip_SetQuestItem(tooltip, questItemType, questItemID, ...)
	if ( not tooltip ) then
		return;
	end;
	if ( arg ) then
		LootLinkExtension_Saved_GameTooltip_SetQuestItem(tooltip, questItemType, questItemID, unpack(arg));
	else
		LootLinkExtension_Saved_GameTooltip_SetQuestItem(tooltip, questItemType, questItemID);
	end

	local money = 0;
	local link = GetQuestItemLink(questItemType, questItemID);
	local name = LootLink_ProcessLinks(link);
	if ( not name ) or ( strlen(name) <= 0 ) then
		return;
	end
	
	local otherName, texture, numItems, quality, isUsable = GetQuestItemInfo(questItemType, questItemID);
	
	local count = nil;
	
	if ( otherName == name ) then
		count = numItems;
	end

	LootLinkExtension_Hookup(tooltip, name, count);
end

function LootLinkExtension_Hookup(tooltip, name, quantity, data)
	if ( not data ) then 
		data = ItemLinks[name];
	end
	if ( not data ) then 
		return;
	end
	if ( not quantity ) then 
		quantity = 1;
	end
	LootLink_AddExtraTooltipInfo(tooltip, name, quantity, data);
	tooltip:Show();
	if( tooltip == GameTooltip ) then
		GameTooltip.llDone = 1;
	end
end

function LootLinkExtension_GameTooltip_SetQuestLogItem(tooltip, questItemType, questItemID, ...)
	if ( not tooltip ) then
		return;
	end;
	if ( arg ) then
		LootLinkExtension_Saved_GameTooltip_SetQuestLogItem(tooltip, questItemType, questItemID, unpack(arg));
	else
		LootLinkExtension_Saved_GameTooltip_SetQuestLogItem(tooltip, questItemType, questItemID);
	end

	local money = 0;
	local link = GetQuestLogItemLink(questItemType, questItemID);
	local name = LootLink_ProcessLinks(link);
	if ( not name ) or ( strlen(name) <= 0 ) then
		return;
	end
	
	local otherName, texture, numItems, quality, isUsable = GetQuestLogChoiceInfo(questItemID);
	
	local count = nil;
	
	if ( otherName == name ) then
		count = numItems;
	end

	LootLinkExtension_Hookup(tooltip, name, count);
end

function LootLinkExtension_GameTooltip_SetCraftItem(tooltip, craftSelection, craftItemID, ...)
	if ( not tooltip ) then
		return;
	end;
	if ( arg ) then
		LootLinkExtension_Saved_GameTooltip_SetCraftItem(tooltip, craftSelection, craftItemID, unpack(arg));
	else
		LootLinkExtension_Saved_GameTooltip_SetCraftItem(tooltip, craftSelection, craftItemID);
	end

	local money = 0;
	local link = GetCraftReagentItemLink(craftSelection, craftItemID);
	local name = LootLink_ProcessLinks(link);
	if ( not name ) or ( strlen(name) <= 0 ) then
		return;
	end
	
	local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(craftSelection, craftItemID);
	
	local count = nil;
	
	if ( reagentName == name ) then
		count = reagentCount;
	end

	LootLinkExtension_Hookup(tooltip, name, count);
end

function LootLinkExtension_GameTooltip_SetCraftSpell(tooltip, craftSelection, ...)
	if ( not tooltip ) then
		return;
	end;
	if ( arg ) then
		LootLinkExtension_Saved_GameTooltip_SetCraftSpell(tooltip, craftSelection, unpack(arg));
	else
		LootLinkExtension_Saved_GameTooltip_SetCraftSpell(tooltip, craftSelection);
	end

	local craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(craftSelection);

	if ( craftType == "header" ) then	
		-- we don't do headers.
		return;
	end

	local money = 0;
	local link = GetCraftItemLink(craftSelection);
	local name = LootLink_ProcessLinks(link);
	if ( not name ) or ( strlen(name) <= 0 ) then
		return;
	end
	
	local count = nil;
	
	if ( craftSubSpellName == name ) then
		--count = 0; -- ? any way to get number of stuff
	end

	LootLinkExtension_Hookup(tooltip, name, count);
end


function LootLinkExtension_GameTooltip_SetTradeSkillItem(tooltip, craftSelection, craftItemID, ...)
	if ( not tooltip ) then
		return;
	end;
	if ( arg ) then
		LootLinkExtension_Saved_GameTooltip_SetTradeSkillItem(tooltip, craftSelection, craftItemID, unpack(arg));
	else
		LootLinkExtension_Saved_GameTooltip_SetTradeSkillItem(tooltip, craftSelection, craftItemID);
	end
	if ( not craftSelection ) then
		return;
	end
	local skillName, skillType, numAvailable, isExpanded;
	if ( not craftItemID ) then
		skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(craftSelection);
	
		if ( skillType == "header" ) then	
			-- we don't do headers.
			return;
		end
	end


	local money = 0;
	local link = nil;
	if ( not craftItemID ) then
		link = GetTradeSkillItemLink(craftSelection);
	else
		link = GetTradeSkillReagentItemLink(craftSelection, craftItemID);
	end
	local name = LootLink_ProcessLinks(link);
	if ( not name ) or ( strlen(name) <= 0 ) then
		return;
	end
	
	local reagentName, reagentTexture, reagentCount, playerReagentCount;
	if ( craftItemID ) then
		reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(craftSelection, craftItemID);
	end
	
	local count = nil;

	if ( not craftItemID ) then
		local minMade,maxMade = GetTradeSkillNumMade(craftSelection);	
		if ( skillName == name ) then
			count = minMade;
		end
	else
		if ( reagentName == name ) then
			count = reagentCount;
		end
	end

	LootLinkExtension_Hookup(tooltip, name, count);
end

function LootLinkExtension_GameTooltip_SetTradeTargetItem(tooltip, tradeItemID, ...)
	if ( not tooltip ) then
		return;
	end;
	if ( arg ) then
		LootLinkExtension_Saved_GameTooltip_SetTradeTargetItem(tooltip, tradeItemID, unpack(arg));
	else
		LootLinkExtension_Saved_GameTooltip_SetTradeTargetItem(tooltip, tradeItemID);
	end

	local money = 0;
	local link = GetTradeTargetItemLink(tradeItemID);
	local name = LootLink_ProcessLinks(link);
	if ( not name ) or ( strlen(name) <= 0 ) then
		return;
	end
	
	local tradeName, texture, numItems, quality, isUsable, enchantment = GetTradeTargetItemInfo(tradeItemID);
	
	local count = nil;

	if ( tradeName == name ) then
		count = numItems;
	end

	LootLinkExtension_Hookup(tooltip, name, count);
end

function LootLinkExtension_GameTooltip_SetTradePlayerItem(tooltip, tradeItemID, ...)
	if ( not tooltip ) then
		return;
	end;
	if ( arg ) then
		LootLinkExtension_Saved_GameTooltip_SetTradePlayerItem(tooltip, tradeItemID, unpack(arg));
	else
		LootLinkExtension_Saved_GameTooltip_SetTradePlayerItem(tooltip, tradeItemID);
	end

	local money = 0;
	local link = GetTradePlayerItemLink(tradeItemID);
	local name = LootLink_ProcessLinks(link);
	if ( not name ) or ( strlen(name) <= 0 ) then
		return;
	end
	
	local tradeName, texture, numItems, isUsable, enchantment = GetTradePlayerItemInfo(tradeItemID);
	
	local count = nil;

	if ( tradeName == name ) then
		count = numItems;
	end

	LootLinkExtension_Hookup(tooltip, name, count);
end

function LootLinkExtension_ItemRefTooltip_SetHyperlink(tooltip, link)
	LootLinkExtension_Saved_ItemRefTooltip_SetHyperlink(tooltip, link);
	local name = LootLink_ProcessLinks(link);

	local data = nil;
	local count = nil;
	LootLinkExtension_Hookup(tooltip, name, count);
end


function LootLinkExtension_InspectSlot(unit, id)
	local link = GetInventoryItemLink(unit, id);
	if( link ) then
		local name = LootLink_ProcessLinks(link);
		if( name and ItemLinks[name] ) then
			local count = GetInventoryItemCount(unit, id);
			if( count > 1 ) then
				ItemLinks[name].stack = 1;
			end
			LootLink_Event_InspectSlot(name, count, ItemLinks[name], unit, id);
		end
	end
end

function LootLinkExtension_Inspect(unit)
	local index;
	
	for index = 1, getn(LOOTLINKEXTENSION_INVENTORY_SLOT_LIST), 1 do
		LootLinkExtension_InspectSlot(unit, LOOTLINKEXTENSION_INVENTORY_SLOT_LIST[index].id)
	end
end


LootLinkExtension_SlashCommands = {
	"lootlinkextension", "lle"
};

LootLinkExtension_CommandParameters = {
	[1] = {
		["commands"] = LOOTLINKEXTENSION_SLASH_COMMANDS_INSPECT_ON_MOUSE_OVER,
		["func"] = LootLinkExtension_SetInspectOnMouseOver,
		["info"] = LOOTLINKEXTENSION_INFO_INSPECT_ON_MOUSE_OVER,
	},
	[2] = {
		["commands"] = LOOTLINKEXTENSION_SLASH_COMMANDS_REFRESH_ON_SHOW,
		["func"] = LootLinkExtension_SetRefreshOnShow,
		["info"] = LOOTLINKEXTENSION_INFO_REFRESH_ON_SHOW,
	},
	[3] = {
		["commands"] = LOOTLINKEXTENSION_SLASH_COMMANDS_SCAN_MERCHANT_ITEMS,
		["func"] = LootLinkExtension_SetScanMerchantItems,
		["info"] = LOOTLINKEXTENSION_INFO_SCAN_MERCHANT_ITEMS,
	},
}

function LootLinkExtension_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end

function LootLinkExtension_DoCommand(func, param)
	local paramValue = nil;
	if ( not param ) or ( strlen(param) == 0 ) then
		paramValue = -1;
	else
		paramValue = tonumber(param);
	end
	func(paramValue);
end

function LootLinkExtension_ShowSlashUsage()
	for k, v in LOOTLINKEXTENSION_USAGE do
		LootLinkExtension_Print(v);
	end
end

function LootLinkExtension_Main_SlashCommand(msg)
	local command, params = LootLinkExtension_Extract_NextParameter(msg);
	if ( not command ) or (strlen(command) <= 0 ) then
		LootLinkExtension_ShowSlashUsage();
		return;
	end
	local param = nil;
	param, params = LootLinkExtension_Extract_NextParameter(params);
	for k, v in LootLinkExtension_CommandParameters do
		for key, commandName in v[1] do
			if ( commandName == command ) then
				return LootLinkExtension_DoCommand(v[2], param);
			end
		end
	end
	LootLinkExtension_ShowSlashUsage();
end



function LootLinkExtension_AddSlashCommands()
	if ( Cosmos_RegisterChatCommand ) then
		Cosmos_RegisterChatCommand (
			"LOOTLINKEXTENSION_MAIN_COMMANDS", -- Some Unique Group ID
			LootLinkExtension_SlashCommands, -- The Commands
			LootLinkExtension_Main_SlashCommand,
			LOOTLINKEXTENSION_CHAT_COMMANDS_INFO -- Description String
		);
	else
		local id = "LOOTLINKEXTENSION";
		local slashIdFormat = format("SLASH_%s%%d", id);
		for k, v in LootLinkExtension_SlashCommands do
			setglobal(format(slashIdFormat, k), v);
		end
		SlashCmdList[id] = LootLinkExtension_Main_SlashCommand;
	end
end

-- Prints out text to a chat box.
function LootLinkExtension_Print(msg,r,g,b,frame,id,unknown4th)
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 0.0; end
	if ( Print ) then
		Print(msg, r, g, b, frame, id, unknown4th);
		return;
	end
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end

