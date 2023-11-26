if (LLH_READ == nil) then
LLH_READ = true;
	
function LLH_OnLoad()
	if (LLH_Loaded ~= nil) then 
		return; 
	end

	-- Hook in alternative Chat/Hyperlinking code
	Orig_Chat_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
	ChatFrame_OnHyperlinkShow = LLH_Chat_OnHyperlinkShow;

	-- Hook in alternative Auctionhouse tooltip code
	Orig_AuctionFrameItem_OnEnter = AuctionFrameItem_OnEnter;
	AuctionFrameItem_OnEnter = LLH_AuctionFrameItem_OnEnter;

	-- Hook in enhanced AddTooltipInfo
	Orig_AddTooltipInfo = LootLink_AddTooltipInfo;
	LootLink_AddTooltipInfo = LLH_AddTooltipInfo;

	LLH_Loaded = true;
end

local function nameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end


function LLH_Chat_OnHyperlinkShow(link)
	Orig_Chat_OnHyperlinkShow(link);

	local name = ItemRefTooltipTextLeft1:GetText();
	if( name and ItemLinks[name] and LootLink_ChatCurrentItem ~= name ) then
		LootLink_ChatCurrentItem = name;
		LLH_AddTooltipInfo(name, ItemRefTooltip, 1);
	end
end

function LLH_AuctionFrameItem_OnEnter(type, index)
	Orig_AuctionFrameItem_OnEnter(type, index);

	local link = GetAuctionItemLink(type, index);
	if( link ) then
		local name = nameFromLink(link);
		if( name and ItemLinks[name] ) then
			local aiName, aiTexture, aiCount, aiQuality, aiCanUse, aiLevel, aiMinBid, aiMinIncrement, aiBuyoutPrice, aiBidAmount, aiHighBidder, aiOwner = GetAuctionItemInfo(type, index);
			LLH_AddTooltipInfo(name, GameTooltip, aiCount);
			GameTooltip:Show();
		end
	end
end

function LLH_AddTooltipInfo(name, tooltip, quantity)
	if (not tooltip) then tooltip = LootLinkTooltip; end
	if (not quantity) then quantity = 1; end
	
	-- Some code to prevent LL from outputting multiple times in not GameTooltip tooltips
	if( not LootLinkState.HideInfo and ItemLinks[name] ) then
		if (tooltip ~= GameTooltip) then
			local lineCount = tooltip:NumLines();
			if ((tooltip.llLast == name) and (tooltip.llLines >= lineCount)) then
				return;
			end
		else
			if (tooltip.llDone) then
				return;
			end
		end
	end
	Orig_AddTooltipInfo(name, tooltip, quantity);
	if (tooltip ~= GameTooltip) then
		tooltip.llLast = name;
		tooltip.llLines = tooltip:NumLines();
	end
end

end
