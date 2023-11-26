-- Auctioneer
AUCTIONEER_VERSION="2.03";
-- Written by Norganna
--
-- This is an addon for World of Warcraft that works in combination with 
-- LootLink to add statistical history to the auction data that is collected
-- when the auction is scanned, so that you can easily determine what price
-- you will be able to sell an item for at auction or at a vendor whenever you
-- mouse-over an item in the game
--
-- (LootLink is an in-game item database)
--

-- Function hooks
local lOriginalGameTooltip_OnHide;
local lOriginalGameTooltip_ClearMoney;
local lOriginalSetItemRef;

-- If non-nil, check for appearance of GameTooltip for adding information
local lAuctioneerCheckTooltip;

-- Timer for frequency of tooltip checks
local lAuctioneerCheckTimer = 0;

-- Current Tooltip frame
local lAuctioneerTooltip = nil;

AuctionConfig = {};
AuctionPrices = {};
Auction_DoneItems = {};
local function Auctioneer_AuctionStart_Hook()
	Auctioneer_Old_AuctionStart_Hook();
	Auction_DoneItems = {};
end

function Auctioneer_GetItemLink(itemName)
	if (ItemLinks == nil) then
--		Auctioneer_ChatPrint("NIL ItemLinks");
		return nil; 
	end
	if (ItemLinks[itemName] == nil) then 
--		Auctioneer_ChatPrint("NIL ItemLinks["..itemName.."]");
		return nil; 
	end
	return ItemLinks[itemName];
end

local function nullSafe(val)
	if (val == nil) then return 0; end
	if (0 + val > 0) then return 0 + val; end
	return 0;
end

local function auctionKey()
	local serverName = GetCVar("realmName");
	local factionGroup = UnitFactionGroup("player");
	return serverName.."-"..factionGroup;
end

local function getBaseItemID(itemName)
	local itemLink = Auctioneer_GetItemLink(itemName);
	if (not itemLink or not itemLink.i) then return 0; end
	local i,j, baseItemID = string.find(itemLink.i, "^(%d+):");
	if (not baseItemID) then return 0; end
	baseItemID = 0 + baseItemID;

	-- An upgrade item thing
	return baseItemID;
end

local function getAuctionPriceData(itemID)
	local server = auctionKey();
	if (AuctionPrices[server] == nil) then
		AuctionPrices[server] = {};
	end
	local link = AuctionPrices[server][itemID];
	if (link == nil) then 
		link = "0:0:0:0:0:0:0";
	end
	return link;
end

local function getAuctionPrices(priceData)
	local i,j, count,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = string.find(priceData, "^(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)");
	return nullSafe(count),nullSafe(minCount),nullSafe(minPrice),nullSafe(bidCount),nullSafe(bidPrice),nullSafe(buyCount),nullSafe(buyPrice);
end

local function upgradeData()
	local server = auctionKey();
	local upgradeCount = 0;
	for itemName, itemLink in ItemLinks do
		local baseItemID = getBaseItemID(itemName);
		if (getAuctionPriceData(baseItemID) == "0:0:0:0:0:0:0") then
			if (itemLink.ahCount ~= nil) then
				local itemData = string.format("%d:%d:%d:%d:%d:%d:%d", nullSafe(itemLink.ahCount),nullSafe(itemLink.ahMinCount),nullSafe(itemLink.ahMinPrice),nullSafe(itemLink.ahBidCount),nullSafe(itemLink.ahBidPrice),nullSafe(itemLink.ahBuyCount),nullSafe(itemLink.ahBuyPrice));
				AuctionPrices[server][baseItemID] = itemData;
			end
		end
		upgradeCount = upgradeCount+1;
	end
end

local function cleanOldData()
	for itemName, itemData in ItemLinks do
		itemData.ahCount    = nil;
		itemData.ahMinCount = nil;
		itemData.ahMinPrice = nil;
		itemData.ahBidCount = nil;
		itemData.ahBidPrice = nil;
		itemData.ahBuyCount = nil;
		itemData.ahBuyPrice = nil;
		ItemLinks[itemName] = itemData;
	end
end

local function Auctioneer_AuctionEntry_Hook(name, count, item, page, index)
	Auctioneer_Old_AuctionEntry_Hook(name, count, item, page, index);
	if (not page) then
		return;
	end
	if (not Auction_DoneItems[page]) then
		Auction_DoneItems[page] = {};
	end
	if (Auction_DoneItems[page][index]) then
		return;
	end
	Auction_DoneItems[page][index] = true;

	local itemID = getBaseItemID(name);
	if (itemID == 0) then return; end
	local itemData = getAuctionPriceData(itemID);
	local count,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);

	local aiName, aiTexture, aiCount, aiQuality, aiCanUse, aiLevel, aiMinBid, aiMinIncrement, aiBuyoutPrice, aiBidAmount, aiHighBidder, aiOwner = GetAuctionItemInfo("list", index);
	if (aiCount < 1) then aiCount = 1; end


	-- Sanity check values to ensure they aren't whack.
	if ((nullSafe(minCount) > 10) and (aiMinBid/aiCount > 5*minPrice/minCount)) then return; end
	if ((nullSafe(bidCount) > 10) and (aiBidAmount/aiCount > 5*bidPrice/bidCount)) then return; end
	if ((nullSafe(buyCount) > 10) and (aiBuyoutPrice/aiCount > 5*buyPrice/buyCount)) then return; end
	

	count = nullSafe(count) + 1;
	minCount = nullSafe(minCount) + aiCount;
	minPrice = nullSafe(minPrice) + aiMinBid;
	if (aiBidAmount > 0) then 
		bidCount = nullSafe(bidCount) + aiCount;
		bidPrice = nullSafe(bidPrice) + aiBidAmount;
	end
	if (aiBuyoutPrice > 0) then
		buyCount = nullSafe(buyCount) + aiCount;
		buyPrice = nullSafe(buyPrice) + aiBuyoutPrice;
	end

	itemData = string.format("%d:%d:%d:%d:%d:%d:%d", count,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice);
	AuctionPrices[auctionKey()][itemID] = itemData; 
end

local function Auctioneer_GetGSC(money)
	if (money == nil) then money = 0; end
	local g = math.floor(money / 10000);
	local s = math.floor((money - (g*10000)) / 100);
	local c = math.floor(money - (g*10000) - (s*100));
	return g,s,c;
end


GSC_GOLD="ffd100";
GSC_SILVER="e6e6e6";
GSC_COPPER="c8602c";
GSC_START="|cff%s%d|r";
GSC_PART=".|cff%s%02d|r";
GSC_NONE="|cffa0a0a0none|r";
local function Auctioneer_GetTextGSC(money)
	local g, s, c = Auctioneer_GetGSC(money);
	local gsc = "";
	if (g > 0) then
		gsc = format(GSC_START, GSC_GOLD, g);
		if ((s > 0) or (c > 0)) then
			if (c > 50) then s = s+1; end
			gsc = gsc..format(GSC_PART, GSC_SILVER, s);
		end
	elseif (s > 0) then
		gsc = format(GSC_START, GSC_SILVER, s);
		if (c > 0) then
			gsc = gsc..format(GSC_PART, GSC_COPPER, c);
		end
	elseif (c > 0) then
		gsc = gsc..format(GSC_START, GSC_COPPER, c);
	else
		gsc = GSC_NONE;
	end

	return gsc;
end

local function Auctioneer_Tooltip_Hook(frame, name, count, data)
	Auctioneer_AddTooltipInfo(frame, name, count, data);
	Auctioneer_Old_Tooltip_Hook(frame, name, count, data);
end

function Auctioneer_AddTooltipInfo(frame, name, count, data)
	if (Auctioneer_GetFilter("all")) then
		local money = nil;
		local itemInfo = nil;

		local itemID = getBaseItemID(name);
		if (itemID > 0) then
			frame.eDone = 1;
			local itemData = getAuctionPriceData(itemID);
			local aCount,minCount,minPrice,bidCount,bidPrice,buyCount,buyPrice = getAuctionPrices(itemData);
			itemInfo = Auctioneer_BasePrices[itemID];

			if (aCount == 0) then
				--frame:AddLine("Never seen at auction", 0.5, 0.8, 0.5);
			else
				local avgQty = math.floor(minCount / aCount);
				local avgMin = math.floor(minPrice / minCount);

				local bidPct = math.floor(bidCount / minCount * 100);
				local avgBid = 0;
				if (buyCount > 0) then
					avgBid = math.floor(bidPrice / bidCount);
				end
				
				local buyPct = math.floor(buyCount / minCount * 100);
				local avgBuy = 0;
				if (buyCount > 0) then
					avgBuy = math.floor(buyPrice / buyCount);
				end

				if (Auctioneer_GetFilter("average")) then
					frame:AddLine(format("%d times at auction", aCount), 0.5,0.8,0.1);
					if (avgQty > 1) then
						frame:AddLine(format("For 1: %s min/%s buy (%s bid) [in %d's]", Auctioneer_GetTextGSC(avgMin), Auctioneer_GetTextGSC(avgBuy), Auctioneer_GetTextGSC(avgBid), avgQty), 0.1,0.8,0.5);
					else
						frame:AddLine(format("%s min/%s buy (%s bid)", Auctioneer_GetTextGSC(avgMin), Auctioneer_GetTextGSC(avgBuy), Auctioneer_GetTextGSC(avgBid)), 0.1,0.8,0.5);
					end
				end
				if (Auctioneer_GetFilter("suggest")) then
					if (count > 1) then
						frame:AddLine(format("Your %d stack: %s min/%s buy (%s bid)", count, Auctioneer_GetTextGSC(avgMin*count), Auctioneer_GetTextGSC(avgBuy*count), Auctioneer_GetTextGSC(avgBid*count)), 0.5,0.5,0.8);
					end
				end
				if (Auctioneer_GetFilter("stats")) then
					frame:AddLine(format("%d%% have bids, %d%% have buyout", bidPct, buyPct), 0.1,0.5,0.8);
				end
			end
			if ((data ~= nil) and (data.price ~= nil)) then
				money = data.price;
			else
				money = 0;
			end
		end
		if (money == nil) then
			money = 0;
		end

		local sellNote = "";
		local buyNote = "";
		local sell = money;
		local buy = sell * 4;
		local quant = 1;
		local stacks = 1;
		local class = "";
		local uses = "";
		if (itemInfo) then
			buyNote = "*"
			stacks = itemInfo.x;
			if (not stacks) then stacks = 1; end
			quant = nullSafe(itemInfo.q);
			if (quant < 1) then quant = 1; end
			if (quant > 1) then
				buyNote = "*";
			end
			buy = nullSafe(itemInfo.b) / quant;
			if ((not sell) or (sell == "") or (sell <= 0))  then
				sellNote = "*"
				sell = nullSafe(itemInfo.s);
			end;
			if (itemInfo.c) then
				class = itemInfo.c;
			end
			if (itemInfo.u) then
				uses = itemInfo.u;
			end
		end
			
		if (Auctioneer_GetFilter("vendor")) then
			if ((buy > 0) or (sell > 0)) then
				local hasSellPrice = false;
				local lastLineNumber = frame:NumLines();
				local lastLine = getglobal(frame:GetName().."TextLeft"..lastLineNumber);
				if ( lastLine ) and ( string.find(lastLine:GetText(), "Sell") ) then
					hasSellPrice = true;
				end
				local bgsc = Auctioneer_GetTextGSC(buy);
				local sgsc = Auctioneer_GetTextGSC(sell);
				if ((count > 1) or (quant > 1)) then
					local bqgsc = Auctioneer_GetTextGSC(buy*count);
					local sqgsc = Auctioneer_GetTextGSC(sell*count);
					if (Auctioneer_GetFilter("vendorbuy")) then
						frame:AddLine(format("Buy%s %d at %s (%s ea)", buyNote, count, bqgsc, bgsc), 0.8, 0.5, 0.1);
					end
					if (Auctioneer_GetFilter("vendorsell")) and ( not hasSellPrice ) then
						frame:AddLine(format("Sell%s %d at %s (%s ea)", sellNote, count, sqgsc, sgsc), 0.8, 0.5, 0.1);
					end
				else
					if (Auctioneer_GetFilter("vendorbuy")) then
						if (Auctioneer_GetFilter("vendorsell")) and ( not hasSellPrice ) then
							frame:AddLine(format("Buy%s %s, Sell%s %s", buyNote, bgsc, sellNote, sgsc), 0.8, 0.5, 0.1);
						else 
							frame:AddLine(format("Buy%s %s", buyNote, bgsc), 0.8, 0.5, 0.1);
						end
					elseif (Auctioneer_GetFilter("vendorsell")) and ( not hasSellPrice ) then
						frame:AddLine(format("Sell%s %s", sellNote, sgsc), 0.8, 0.5, 0.1);
					end
				end
			end
		end

		if (Auctioneer_GetFilter("stacksize")) then
			if (stacks > 1) then
				frame:AddLine(format("Stacks in lots of %d", stacks));
			end
		end
		if (Auctioneer_GetFilter("usage")) then
			local reagentInfo = "";
			if (class ~= "") then
				if (uses ~= "") then
					reagentInfo = "Class: "..class.." used for "..uses;
				else
					reagentInfo = "Class: "..class;
				end
			elseif (uses ~= "") then
				reagentInfo = "Used for: "..uses;
			end
			if (reagentInfo ~= "") then
				frame:AddLine(reagentInfo, 0.6, 0.4, 0.8);
			end
		end
	end
	frame:Show();
end

function Auctioneer_OnLoad()
--	if ((not LOOTLINK_VERSION) or (LOOTLINK_VERSION < 315)) then
--		Auctioneer_ChatPrint("Auctioneer: Needs LootLink >= 2.1.3 (exiting)");
--		return;
--	end

	RegisterForSave("AuctionConfig");
	RegisterForSave("AuctionPrices");

	lOriginalGameTooltip_ClearMoney = GameTooltip_ClearMoney;
	GameTooltip_ClearMoney = Auctioneer_GameTooltip_ClearMoney;

	lOriginalGameTooltip_OnHide = GameTooltip_OnHide;
	GameTooltip_OnHide = Auctioneer_GameTooltip_OnHide;

	lOriginalSetItemRef = SetItemRef;
	SetItemRef = Auctioneer_SetItemRef;
	
	Auctioneer_Old_Tooltip_Hook = LootLink_AddExtraTooltipInfo;
	LootLink_AddExtraTooltipInfo = Auctioneer_Tooltip_Hook;

	Auctioneer_Old_AuctionStart_Hook = LootLink_Event_StartAuctionScan;
	LootLink_Event_StartAuctionScan = Auctioneer_AuctionStart_Hook;

	Auctioneer_Old_AuctionEntry_Hook = LootLink_Event_ScanAuction;
	LootLink_Event_ScanAuction = Auctioneer_AuctionEntry_Hook;

	SLASH_AUCTIONEER1 = "/auctioneer";
	SlashCmdList["AUCTIONEER"] = function(msg)
		Auctioneer_Command(msg);
	end
	
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage("Auctioneer v"..AUCTIONEER_VERSION.." loaded", 0.8, 0.8, 0.2);
	end
end

function Auctioneer_Command(command)
	local i,j, cmd, param = string.find(command, "^([^ ]+) (.+)$");
	if (not cmd) then cmd = command; end
	if (not cmd) then cmd = ""; end
	if (not param) then param = ""; end

	if ((cmd == "") or (cmd == "help")) then
		Auctioneer_ChatPrint("Usage:");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("all").."]|r - turns the auction data display on and off");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer average (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("average").."]|r - select whether to show item's average auction price");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer suggest (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("suggest").."]|r - select whether to show item's suggested auction price");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer stats (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("stats").."]|r - select whether to show item's bidded/buyout percentages");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer vendor (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("vendor").."]|r - select whether to show item's vendor pricing");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer vendorsell (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("vendor").."]|r - select whether to show item's vendor sell pricing (req vendor=on)");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer vendorbuy (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("vendor").."]|r - select whether to show item's vendor buy pricing (req vendor=on)");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer usage (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("usage").."]|r - select whether to show tradeskill item's usage");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer stacksize (on|off|toggle)|r |cff2040ff["..Auctioneer_GetFilterVal("stacksize").."]|r - select whether to show the item's stackable size");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer upgrade [complete]|r - Upgrade your old data to the new format. You must do this once for each server/faction you want to give the data to. Once you are finished upgrading, rerun this command again with the complete parameter and it will wipe out the old data thus cleaning up some free space.");
		Auctioneer_ChatPrint("  |cffffffff/auctioneer clear <item|all>|r - clear the specified item's lootlink data (you may shift click insert multiple items into this command, or specify only one textually) If you specify 'all' by itself, the entire dataset for this server will be cleared");
	elseif (cmd == "on") then
		Auctioneer_SetFilter("all", "on");
		Auctioneer_ChatPrint("Displaying configured auction data");
	elseif (cmd == "off") then
		Auctioneer_SetFilter("all", "off");
		Auctioneer_ChatPrint("Not displaying any auction data");
	elseif (cmd == "toggle") then
		local cur = Auctioneer_GetFilterVal("all");
		if (cur == "off") then
			Auctioneer_SetFilter("all", "on");
			Auctioneer_ChatPrint("Displaying configured auction data");
		else
			Auctioneer_SetFilter("all", "off");
			Auctioneer_ChatPrint("Not displaying any auction data");
		end
	elseif (cmd == "clear") then
		if (param == "all") then
			local aKey = auctionKey();
			Auctioneer_ChatPrint("Clearing all auction data for "..aKey);
			AuctionPrices[aKey] = {};
		else
			local items = Auctioneer_GetItems(param);
			for _,item in items do
				local aKey = auctionKey();
				local baseItemID = getBaseItemID(item);
				if ((baseItemID > 0) and (AuctionPrices[aKey][baseItemID] ~= nil)) then
					AuctionPrices[aKey][baseItemID] = nil;
					Auctioneer_ChatPrint("Clearing data for item "..item);
				else
					Auctioneer_ChatPrint("Unable to find item "..item);
				end
			end
		end
	elseif (cmd == "upgrade") then
		if (param == "complete") then
			Auctioneer_ChatPrint("Cleaning out all the old auction data");
			cleanOldData();
		else
			Auctioneer_ChatPrint("Upgrading your old auction data to the new compact and per-server/faction format");
			upgradeData();
		end
	elseif ((cmd == "average") or (cmd == "suggest") or (cmd == "stats") or (cmd == "vendor") or (cmd == "usage") or (cmd == "stacksize") or (cmd == "vendorsell") or (cmd == "vendorbuy")) then
		if ((param == "false") or (param == "off") or (param == "no") or (param == "0")) then
			Auctioneer_SetFilter(cmd, "off");
			Auctioneer_ChatPrint("Not displaying item's "..cmd.." data");
		elseif (param == "toggle") then
			local cur = Auctioneer_GetFilterVal(cmd);
			if (cur == "on") then
				cur = "off";
				Auctioneer_ChatPrint("Not displaying item's "..cmd.." data");
			else
				cur = "on";
				Auctioneer_ChatPrint("Displaying item's "..cmd.." data");
			end
			Auctioneer_SetFilter(cmd, cur);
		else
			Auctioneer_SetFilter(cmd, "on");
			Auctioneer_ChatPrint("Displaying item's "..cmd.." data");
		end
	else
		Auctioneer_ChatPrint("Unknown command keyword: '"..cmd.."'");
	end
end

function Auctioneer_SetFilter(type, value)
	if (not AuctionConfig.filters) then AuctionConfig.filters = {}; end
	AuctionConfig.filters[type] = value;
end

function Auctioneer_GetFilterVal(type)
	if (not AuctionConfig.filters) then AuctionConfig.filters = {}; end
	value = AuctionConfig.filters[type];
	if (not value) then return "on"; end
	return value;
end

function Auctioneer_GetFilter(filter)
	value = Auctioneer_GetFilterVal(filter);
	if (value == "on") then return true;
	elseif (value == "off") then return false; end
	return true;
end

function Auctioneer_ChatPrint(str)
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(str, 1.0, 0.5, 0.25);
	end
end

function Auctioneer_GetItems(str)
	local itemList = {};
	local listSize = 0;
	for item in string.gfind(str, "|Hitem:[^|]+|h[[]([^]]+)[]]|h") do
		listSize = listSize+1;
		itemList[listSize] = item;
	end
	if (listSize == 0) then
		listSize = listSize+1;
		itemList[listSize] = str;
	end
	return itemList;
end


function Auctioneer_GameTooltip_ClearMoney()
	lOriginalGameTooltip_ClearMoney();
	lAuctioneerCheckTooltip = Auctioneer_CheckTooltipInfo(GaeTooltip);
end

function Auctioneer_GameTooltip_OnHide()
	lOriginalGameTooltip_OnHide();
	GameTooltip.eDone = nil;
	if ( lAuctioneerTooltip ) then
		lAuctioneerTooltip.eDone = nil;
		lAuctioneerTooltip = nil;
	end
end

function Auctioneer_OnUpdate(elapsed)
	lAuctioneerCheckTimer = lAuctioneerCheckTimer + elapsed;
	if( lAuctioneerCheckTimer >= 0.2 ) then
		if( lAuctioneerCheckTooltip ) then
			lAuctioneerCheckTooltip = Auctioneer_CheckTooltipInfo(lAuctioneerTooltip);
		end
		lAuctioneerCheckTimer = 0;
	end
end

function Auctioneer_SetItemRef(link)
	lOriginalSetItemRef(link);
	lAuctioneerCheckTooltip = Auctioneer_CheckTooltipInfo(ItemRefTooltip);
end

function Auctioneer_CheckTooltipInfo(frame)
	-- If we've already added our information, no need to do it again
	if ( not frame or frame.eDone ) then
		return nil;
	end

	lAuctioneerTooltip = frame;

	if( frame:IsVisible() ) then
		local field = getglobal(frame:GetName().."TextLeft1");
		if( field and field:IsVisible() ) then
			local name = field:GetText();
			if( name ) then
				Auctioneer_AddTooltipInfo(frame, name);
				return nil;
			end
		end
	end
	
	return 1;
end

