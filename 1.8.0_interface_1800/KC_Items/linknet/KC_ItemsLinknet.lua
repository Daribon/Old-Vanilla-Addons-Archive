
KC_ItemsLinknetClass = KC_ItemsModuleClass:new({
	type		 = "linknet",
	name		 = KC_LINKNET_NAME,
	desc		 = KC_LINKNET_DESCRIPTION,
	cmdOptions	 = KC_LINKNET_CMD_OPTIONS,
	--dependencies = {"test"},
})

function KC_ItemsLinknetClass:Enable()
	self:RegisterEvent("CHAT_MSG_SYSTEM"	, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_SAY"		, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_WHISPER"	, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_PARTY"		, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_GUILD"		, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_YELL"		, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_TEXT_EMOTE", "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_OFFICER"	, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_LOOT"		, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_RAID"		, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG"			, "ChatMessageHandler" );
	self:RegisterEvent("CHAT_MSG_CHANNEL"	, "ChatMessageHandler" );

	self:RegisterEvent("PLAYER_TARGET_CHANGED"	, "InspectTarget" );

	self:RegisterEvent("AUCTION_ITEM_LIST_UPDATE", "AuctionUpdate");
end

function KC_ItemsLinknetClass:ChatMessageHandler()
	if (arg1) then
		for color, item, name in gfind(arg1, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
			if( color and item and name ) then
				self:GetCode(item);
			end	
		end
	end
end

function KC_ItemsLinknetClass:InspectTarget()
	if (UnitIsPlayer("target")) then
		for i = 1, 19 do
			self:GetCode(GetInventoryItemLink("target", i))
		end
	end
end

function KC_ItemsLinknetClass:AuctionUpdate()
	
	local numBatchAuctions = GetNumAuctionItems("list");
	numBatchAuctions = numBatchAuctions and numBatchAuctions or 0;
	if (numBatchAuctions < 1) then return;	end

	for auctionid = 1, numBatchAuctions do
		self:GetCode(GetAuctionItemLink("list", auctionid));
	end
end

-- Registering with KCI
KC_Items:Register(KC_ItemsLinknetClass:new())