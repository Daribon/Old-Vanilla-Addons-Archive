local Original_ChatFrame_OnHyperlinkShow;
local links;

local function Relinker_CreateLink(hyperLink)
	local linkData = links[string.sub(hyperLink, 6)];

	if ( linkData and linkData.name and linkData.color ) then
		return "|c"..linkData.color.."|H"..hyperLink.."|h["..linkData.name.."]|h|r";
	end

	return nil;
end

function Relinker_ChatFrame_OnHyperlinkShow(hyperLink)
	local link;

	if ( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
		link = Relinker_CreateLink(hyperLink);
	end
	
	if ( link ) then
		ChatFrameEditBox:Insert(link);
	else
		Original_ChatFrame_OnHyperlinkShow(hyperLink)
	end
end

function Relinker_ScanTextForLinks(text)
	local color;
	local item;
	local name;
	
	if ( text ) then
		for color, item, name in string.gfind(text, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
			if ( color and item and name ) then
				if ( not links[item] ) then
					links[item] = { };
					links[item].name = name;
					links[item].color = color;
				end
			end
		end
	end
end

function Relinker_OnEvent()
	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		Relinker_ScanTextForLinks(arg1);
	end
end

function Relinker_OnLoad()
	-- Initialize the link table.
	links = { };

	-- Register for all chat message events.
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("CHAT_MSG_SAY");
	this:RegisterEvent("CHAT_MSG_TEXT_EMOTE");
	this:RegisterEvent("CHAT_MSG_YELL");
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("CHAT_MSG_PARTY");
	this:RegisterEvent("CHAT_MSG_GUILD");
	this:RegisterEvent("CHAT_MSG_OFFICER");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("CHAT_MSG_RAID");
	
	-- Hook on hyperlink clicks event handler.
	Original_ChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
	ChatFrame_OnHyperlinkShow = Relinker_ChatFrame_OnHyperlinkShow;
end