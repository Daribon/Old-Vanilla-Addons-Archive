
KC_ItemsAuction = KC_ItemsModuleClass:new({
	type		 = "auction",
	name		 = KC_AUCTION_NAME,
	desc		 = KC_AUCTION_DESCRIPTION,
	cmdOptions	 = KC_AUCTION_CMD_OPTIONS,
    db           = AceDbClass:new("KC_AuctionDB"),
	optPath		 = {"options"},
	gui		 = KC_AuctionGUI,
	--dependencies = {"test"},
})

function KC_ItemsAuction:Enable()
	if (self.app.tooltip) then
		self.app.tooltip:RegisterFunc(self, "DisplayInfo");
	end
	self:RegisterEvent("AUCTION_HOUSE_SHOW", "HookAuctionFrame");
	self.classes = {GetAuctionItemClasses()};
end

function KC_ItemsAuction:HookAuctionFrame()
	self.gui:SetParents();
	self.gui:Initialize(self, KC_AUCTION_GUI_CONFIG)	
	self.gui:Hooks();
	self:UnregisterEvent("AUCTION_HOUSE_SHOW");
end

-- do nothing, nothing happens in a blackhole.
function KC_ItemsAuction:BlackHole() end

-- Auction Scanning Code.
function KC_ItemsAuction:Scan()
	
	if(not AuctionFrame:IsVisible()) then
		self.gui:scan();
		self:Msg(KC_AUCTION_TEXT_CANT_SCAN);
		return;
	end

	self.targets = {};
	self.done = FALSE;

	for i = 0, 15 do
		local chk = self.gui["FilterChk" .. i];
		chk:Disable();
		
		if (i ~= 0 and self:GetOpt(i, self.optPath)) then
			tinsert(self.targets, i);
		end
	end

	for i=1, NUM_BROWSE_TO_DISPLAY do
		button = getglobal("BrowseButton"..i);
		button:Hide();
	end

	if (getn(self.targets) < 1) then
		self.gui:scan();
		BrowseNoResultsText:SetText(KC_AUCTION_TEXT_NO_TARGETS);
		return;
	end

	BrowseNoResultsText:Show();
	BrowseNoResultsText:SetText("");


	self:Hook("CanSendAuctionQuery")
	self:Hook("AuctionFrameBrowse_OnEvent", "BlackHole");

	self:RegisterEvent("AUCTION_ITEM_LIST_UPDATE"	, "AuctionUpdate");
	self:RegisterEvent("AUCTION_HOUSE_CLOSED"		, "ScanCanceled");
end

function KC_ItemsAuction:CanSendAuctionQuery()
	if (self:CallHook("CanSendAuctionQuery")) then
		self:NextPage();		
	end
end

function KC_ItemsAuction:NextPage()
	local maxPages;
	if (self.page) then
		local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
		maxPages= floor(totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE);

		if (totalAuctions == 0 or self.done) then
			self:ScanDone();
			return;
		end

		BrowseNoResultsText:SetText(format(KC_AUCTION_TEXT_SCANNING, self.page + 1, (maxPages or 0) + 1, self.classes[self.target]));
		
		if (self.page < maxPages) then
			self.page = self.page + 1;
		else
			if (getn(self.targets) > 0) then
				self.target = tremove(self.targets, 1);
				self.page = 0;
				maxPages = nil;
			else
				self.done = TRUE;
				self.page = self.page +1;
			end
		end
	else
		self.page = 0;
		self.target = tremove(self.targets, 1);
		BrowseNoResultsText:SetText(KC_AUCTION_TEXT_SETTINGUP);
	end
	self.needScan = TRUE;
	
	QueryAuctionItems("", "", "", nil, self.target, nil, self.page, nil, nil);

end

function KC_ItemsAuction:AuctionUpdate()
	if (not self.needScan) then return;	end
	
	local numBatchAuctions = GetNumAuctionItems("list");
	if( numBatchAuctions > 0 ) then
		for id = 1, numBatchAuctions do
			link = GetAuctionItemLink("list", id);

			if (link) then
				local _, _, count, _, _, _, minBid, _, buyoutPrice, bidAmount, _, _ = GetAuctionItemInfo("list", id);
				self:ProcessItem(link, count, minBid, bidAmount, buyoutPrice);
			end
		end
	end

	self.needScan = FALSE;
end

-- Scan Cleanup
function KC_ItemsAuction:ProcessSnapshot()
	if (self.snapshot) then
		local items = self.snapshot:get();
		local storePath = {self:GetRealmFactionID()};

		for code in items do
			local item = items[code];
			local mins = item.mins or {};
			local buys = item.buys or {};
			local bids = item.bids or {};
			local seen = item.seen or {};
			local stacks = item.stacks;
		
			local oldSeen, oldAvgStack, oldMin, oldBidSeen, oldBid, oldBuySeen, oldBuy = self:getItemData(code);
			local newSeen, newAvgStack, newMin, newBidSeen, newBid, newBuySeen, newBuy;
			
			newSeen = seen + (oldSeen or 0); 
			newBidSeen = getn(bids) + (oldBidSeen or 0);
			newBuySeen = getn(buys) + (oldBuySeen or 0);
			newAvgStack = self:getAvg(stacks);
			newMin = self:getBellCurve(mins) or 0;
			newBid = self:getBellCurve(bids) or 0;
			newBuy = self:getBellCurve(buys) or 0;

			if (oldMin and oldSeen) then
				local total = (newMin * seen) + (oldMin * oldSeen);
				newMin = floor(total / newSeen);
			end

			if (oldBid and oldBidSeen and newBidSeen > 0) then
				newBid = (newBid * getn(bids)) + (oldBid * oldBidSeen);
				newBid = floor(newBid / newBidSeen);
			end
			
			if (oldBuy and oldBuySeen and newBuySeen > 0) then
				newBuy = (newBuy * getn(buys)) + (oldBuy * oldBuySeen);
				newBuy = floor(newBuy / newBuySeen);
			end
			
			if (oldSeen and oldAvgStack) then
				newAvgStack = (newAvgStack * seen) + (oldSeen * oldAvgStack);
				newAvgStack = floor(newAvgStack / newSeen);
			end
			
			local store = newSeen .. ":" .. newAvgStack .. ":" .. newMin .. ":" .. newBidSeen .. ":" .. newBid .. ":" .. newBuySeen .. ":" .. newBuy;
			if (storePath and code and store) then
				self.db:set(storePath, code, store);		
			end
		end
	end
end

function KC_ItemsAuction:ScanCleanup()

	self:ProcessSnapshot();

	if (not self.persistent) then
		self.snapshot = nil;
	end

	for i = 0, 15 do
		local chk = self.gui["FilterChk" .. i];
		chk:Enable();
	end

	self.page = nil;
	self.needScan = FALSE;
	self.target = nil;
	self.targets = nil;
	self.done = FALSE;

	self:Unhook("CanSendAuctionQuery");
	self:Unhook("AuctionFrameBrowse_OnEvent");

	self:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE");
	self:UnregisterEvent("AUCTION_HOUSE_CLOSED");

	self.gui.ScanButton:SetValue(KC_AUCTION_TEXT_SCAN);
end

function KC_ItemsAuction:ScanDone()
		BrowseNoResultsText:SetText(KC_AUCTION_TEXT_SCAN_DONE);
		self:ScanCleanup();
end

function KC_ItemsAuction:ScanCanceled()
		BrowseNoResultsText:SetText(KC_AUCTION_TEXT_SCAN_CANCELED);
		self:ScanCleanup();
end

-- Item Data Management.
function KC_ItemsAuction:ProcessItem(link, count, min, bid, buy)
	local code = self:GetCode(link);
	if (not code) then return; end
	if (not self.snapshot) then self.snapshot = AceDbClass:new(); end
	
	if (buy > 0) then 
		if( not self.snapshot:get({code}, "buys") ) then self.snapshot:set({code}, "buys", {}) end
		self.snapshot:insert({code}, "buys", floor(buy/count)); 
	end
	if (bid > 0) then 
		if( not self.snapshot:get({code}, "bids") ) then self.snapshot:set({code}, "bids", {}) end
		self.snapshot:insert({code}, "bids", floor(bid/count)); 
	end
	
	if( not self.snapshot:get({code}, "mins") ) then self.snapshot:set({code}, "mins", {}) end
	self.snapshot:insert({code}, "mins", floor(min/count));
	
	if( not self.snapshot:get({code}, "stacks") ) then self.snapshot:set({code}, "stacks", {}) end
	self.snapshot:insert({code}, "stacks", count);

	local seen = self.snapshot:get({code}, "seen") or 0;
	self.snapshot:set({code}, "seen", seen + 1);
end

function KC_ItemsAuction:getItemData(id)
	local storePath = {self:GetRealmFactionID()};
	local data  = self.db:get(storePath, id);
	local seen, avgstack, min, bidseen, bid, buyseen, buy;
	if (data) then
		seen, avgstack, min, bidseen, bid, buyseen, buy = ace.SplitString(data, ":");	
		seen = tonumber(seen) or 0;
		avgstack = floor(tonumber(avgstack) or 0);
		bidseen = tonumber(bidseen) or 0;
		buyseen = tonumber(buyseen) or 0;
		min   = tonumber(min) or 0;
		bid   = tonumber(bid) or 0;
		buy   = tonumber(buy) or 0;
	end

	return seen, avgstack, min, bidseen, bid, buyseen, buy;
end

-- Utility
function KC_ItemsAuction:GetRealmFactionID()
	local faction = UnitFactionGroup("player");
	if (GetMinimapZoneText() == "Gadgetzan") then
		faction = "Gadgetzan";
	end
	return ace.char.realm .. "|" .. faction;
end

function KC_ItemsAuction:EnablePersistance()
	self.persistent = TRUE;
end

-- Math
function KC_ItemsAuction:getBellCurve(values)
	if (not values or getn(values) < 1) then return; end
	local lPass = FALSE;
	local hPass = FALSE;
	
	local sd, avg = self:getStandardDeviation(values);

	sort(values);
	
	local lLimit = avg - (sd * 1.5);
	local hLimit = avg + (sd * 1.5);
	
	while (not lPass or not hPass) do
		if (tonumber(values[1]) < lLimit and not lPass) then
			tremove(values, 1);
		else
			lPass = TRUE;
		end				
		if (tonumber(values[getn(values)]) > hLimit and not hPass) then
			tremove(values);
		else
			hPass = TRUE;
		end
	end

	avg = self:getAvg(values);

	return floor(avg);
end

function KC_ItemsAuction:getAvg(values, count)
	local total = 0;
	if (type(values) ~= "table" or getn(values) < 1) then return; end
	if (not count) then count = getn(values); end

	for i = 1, getn(values) do
		total = total + tonumber(values[i]);
	end

	return floor(total / count);		
end

function KC_ItemsAuction:getStandardDeviation(values, avg)
	if (not avg) then avg = self:getAvg(values); end
	local num = 0;

	for i = 1, getn(values) do
		num = num + ((values[i] - avg)^2)	
	end

	num = num / getn(values);

	return floor(math.sqrt(num)), avg;
end

-- Tooltip methods

function KC_ItemsAuction:DisplayInfo(tooltip, code, qty, hooker)
	local seen, avgstack, min, bidseen, bid, buyseen, buy = self:getItemData(code);
	if (not seen) then return; end
	local showsingle = self:GetOpt("single", self.optPath);
	
	if (self:GetOpt("short", self.optPath)) then
		if (min and min > 0 and qty) then
			local label = format(KC_AUCTION_TEXT_MIN_SHORT, qty);
			local label = (showsingle and qty > 1) and label .. KC_AUCTION_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and min;
			hooker:AddPriceLine(tooltip, min * qty, label, single, KC_AUCTION_TEXT_SEP, KC_AUCTION_SEPCOLOR);
		end
		if (buy and buy > 0 and qty) then
			local label = format(KC_AUCTION_TEXT_BUY_SHORT, qty);
			local label = (showsingle and qty > 1) and label .. KC_AUCTION_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and buy;
			hooker:AddPriceLine(tooltip, buy * qty, label, single, KC_AUCTION_TEXT_SEP, KC_AUCTION_SEPCOLOR);
		end
		if (self:GetOpt("showbid", self.optPath) and bid and bid > 0 and qty) then
			local label = format(KC_AUCTION_TEXT_BID_SHORT, qty);
			local label = (showsingle and qty > 1) and label .. KC_AUCTION_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and bid;
			hooker:AddPriceLine(tooltip, bid * qty, label, single, KC_AUCTION_TEXT_SEP, KC_AUCTION_SEPCOLOR);
		end
	else
		hooker:AddTextLine(tooltip, format(KC_AUCTION_TEXT_AUCTION_PRICES_FOR, qty));
		if (min and min > 0 and qty) then
			local label = KC_AUCTION_TEXT_MIN_LONG;
			local label = (showsingle and qty > 1) and label .. KC_AUCTION_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and min;
			hooker:AddPriceLine(tooltip, min * qty, label, single, KC_AUCTION_TEXT_SEP, KC_AUCTION_SEPCOLOR);
		end
		if (buy and buy > 0 and qty) then
			local label = KC_AUCTION_TEXT_BUY_LONG;
			local label = (showsingle and qty > 1) and label .. KC_AUCTION_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and buy;
			hooker:AddPriceLine(tooltip, buy * qty, label, single, KC_AUCTION_TEXT_SEP, KC_AUCTION_SEPCOLOR);
		end
		if (self:GetOpt("showbid", self.optPath) and bid and bid > 0 and qty) then
			local label = KC_AUCTION_TEXT_BID_LONG;
			local label = (showsingle and qty > 1) and label .. KC_AUCTION_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and bid;
			hooker:AddPriceLine(tooltip, bid * qty, label, single, KC_AUCTION_TEXT_SEP, KC_AUCTION_SEPCOLOR);
		end

	end

	if (self:GetOpt("showstats", self.optPath) and seen and avgstack) then
		hooker:AddTextLine(tooltip, format(KC_AUCTION_TEXT_STATS, seen, avgstack));
	end
end

-- Chat commands

function KC_ItemsAuction:scanstart()
	self.gui:scan();
end

function KC_ItemsAuction:short()
	local status = self:TogOpt("short", self.optPath);
	self:Result(KC_SELLVALUE_TEXT_SHORT_DISPLAY_MODE, status, ACEG_MAP_ENABLED);
end

function KC_ItemsAuction:single()
	local status = self:TogOpt("single", self.optPath);
	self:Result(KC_SELLVALUE_TEXT_DISPLAY_OF_SINGLE, status, ACEG_MAP_ENABLED);
end

function KC_ItemsAuction:showbid()
	local status = self:TogOpt("showbid", self.optPath);
	self:Result(KC_AUCTION_TEXT_DISPLAY_OF_BID, status, ACEG_MAP_ENABLED);
end

function KC_ItemsAuction:showstats()
	local status = self:TogOpt("showstats", self.optPath);
	self:Result(KC_AUCTION_TEXT_DISPLAY_OF_STATS, status, ACEG_MAP_ENABLED);
end

function KC_ItemsAuction:clear()
	PlaySound("QUESTADDED");
	StaticPopup_Show("KCI_AUCTION_CLEARDATA_CONFIRM");
end

function KC_ItemsAuction:clearConfirmed()
	self.db:reset({self:GetRealmFactionID()});
	self:Msg(KC_AUCTION_TEXT_AUCTION_DATA_CLEARED);
end

-- Registering with KCI
KC_Items:Register(KC_ItemsAuction)