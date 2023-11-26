--[[

Globalised functions for use with various programs I have.

Functions start with LYS_ as my main char's name on feathermoon is Lysidia... I should come up with something better, but I'm lazy :-)

To check version:-
/script DEFAULT_CHAT_FRAME:AddMessage(LYS_LIBRARY);
]]

-- START OF LIBRARY --
if ((LYS_LIBRARY == nil) or (LYS_LIBRARY < LYS_VERS_NUM)) then

-- Various global settings... this allows modification of some things.
LYS_LINETEXTURE_SIZE	= 256;
LYS_LINETEXTURE_UP  	= "Interface\\AddOns\\EnhancedFlightMap\\LineUp";
LYS_LINETEXTURE_DOWN	= "Interface\\AddOns\\EnhancedFlightMap\\LineDown";

-- Define library version so other programs can check against this
-- Using reference number from the locale file as it is the primary record of the version number.
LYS_LIBRARY = LYS_VERS_NUM;

--[[
Functions below
]]

-- Function: Return the value to given precision.
function LYS_ValueToPrecision(value, precision)
	local precValue = 10 ^ precision;
	
	value = floor(value * precValue) / precValue;
	
	return value;
end

-- Function: Get the current player co-ordinates
function LYS_GetPlayerCoords()
	local px, py = GetPlayerMapPosition("player");

   px = floor(px * 10000);
   py = floor(py * 10000);
   px = px / 100;
   py = py / 100;
   return px,py
end

-- Function: Help display routine
function LYS_Display_Help(helpTextVariable)
	local index = 0;
	local value = getglobal(helpTextVariable..index);
	while( value ) do
		DEFAULT_CHAT_FRAME:AddMessage(value);
		index = index + 1;
		value = getglobal(helpTextVariable..index);
	end
end

-- Function: Merge two LUA tables
function LYS_mergeTable(src,dest)
	for key,val in pairs(src) do
		local dval = dest[key];
		if (type(val) == "table") then
			if (dval == nil) then
				dval = {};
				dest[key] = dval;
			end
			LYS_mergeTable(val, dval)
		else
			if ((dval == nil) and (dval ~= val)) then
				dest[key] = val;
			end
		end
	end
end

-- Function: Check to see if a given string is in the table.
function LYS_StringInTable(inputTable, inputString)
	for index in inputTable do
		if (inputTable[index] == inputString) then
			return true;
		end
	end
	return false;
end

-- Function: Check to see if a given string is in the table keys
function LYS_StringInTableKeys(inputTable, inputString)
	for key, val in pairs(inputTable) do
		if (key == inputString) then
			return true;
		end
	end
	return false;	
end

-- Function: Return the time difference between the start and finish times.
function LYS_Elapsed(start,finish)
   return LYS_FormatTime(finish-start);
end

-- Function: Format an input number to return a human-readable time format.
function LYS_FormatTime(duration)
   local minutes	= floor(duration / 60);
   local seconds	= duration - (minutes * 60);
   local tens		= floor(seconds/10);
   local single		= seconds - (tens * 10);
   return minutes..":"..tens..single;
end

-- Function: Find out the real player name, that is player+realm
function LYS_GetPlayerRealmName()
	local realmName = GetCVar("realmName");

	local playerName = UnitName("player");
	if ((playerName ~= nil) and (playerName ~= UNKNOWNOBJECT) and (playerName ~= UKNOWNBEING)) then
		return realmName.."."..playerName;
	end

	return "unknown";
end

-- Function: Get the text version of an amount given in copper.
function LYS_GetTextMoney(money, withColour)
	if (money == nil) then money = 0; end
	local g = math.floor(money / 10000);
	local s = math.floor((money - (g*10000)) / 100);
	local c = math.floor(money - (g*10000) - (s*100));

	local gsc = "";

	if (withColour) then
		if (g > 0) then
			gsc = LYS_COLOURS.GOLD..g..LYS_MONEYTEXT_GOLD.." "..LYS_COLOURS.NORMAL;
		end
		if (s > 0) then
			gsc = gsc..LYS_COLOURS.SILVER..s..LYS_MONEYTEXT_SILVER.." "..LYS_COLOURS.NORMAL;
		end
		if (c > 0) then
			gsc = gsc..LYS_COLOURS.COPPER..c..LYS_MONEYTEXT_COPPER.." "..LYS_COLOURS.NORMAL;
		end
	else
		local ctext;
		local stext;
		local gtext;

		ctext = format("%02.2s", c)..LYS_MONEYTEXT_COPPER;

		if (s > 0) then
			stext = format("%2.2s", s)..LYS_MONEYTEXT_SILVER;
		else
			stext = "     ";
		end

		if (g > 0) then
			gtext = format("%2.2s", g)..LYS_MONEYTEXT_GOLD;
		else
			gtext = "     ";
		end
		
		gsc = gtext.." "..stext.." "..ctext;
	end

	return gsc;
end

-- Function: Convert a link to the item name
function LYS_LinkToName(itemLink)
	if( itemLink ) then
		local _,_,name = string.find(itemLink, "^.*%[(.*)%].*$");
		return name;
	end
	return nil;
end

-- Function: Return the ID when given the item link
function LYS_LinkToID(itemLink)
	if( itemLink ) then
		local _,_,id = string.find(itemLink, "^.*item:([0-9]+):.*$");	
		return id;
	end
	return nil;
end

-- Function: Display the "program loaded" chatter.
function LYS_ProgramLoadedText(programName)
	if (LYS_Config) then
		if (LYS_Config.LoadMessage) then
			DEFAULT_CHAT_FRAME:AddMessage(programName..LYS_MSG_LOADED);
			UIErrorsFrame:AddMessage(programName..LYS_MSG_LOADED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
	end
end

-- Function: Add program to various addon registration things.
function LYS_ProgramRegsiterAddon(addonName, addonDesc, addonVersion, addonDate, addonFrame, addonOptionFrame, myAddonsCategory)
	if(myAddOnsFrame_Register) then
		AddonDetails = {
				name			= addonName,
				--description		= addonDesc,
				version			= addonVersion,
				releaseDate 	= addonDate,
				category		= myAddonsCategory,
				author			= "Lysidia of Fethermoon",
				--email			= "anyone@anywhere.com",
				--website		= "http://www.anywhere.com",
				--frame			= addonFrame,
				optionsframe	= addonOptionFrame
				};
			myAddOnsFrame_Register(AddonDetails);
		end
end

-- Display the line on the flightmap for given points.
function LYS_DrawLine(myFrame, myTexture, x1, y1, x2, y2)
	local lineFrame		= getglobal(myFrame);
	local lineTexture	= getglobal(myTexture);

	lineTexture:ClearAllPoints();
	
	local frameWidth	= lineFrame:GetWidth();
	local frameHeight	= lineFrame:GetHeight();
	
    local dx = abs((x1 - x2) * frameWidth);
    local dy = abs((y1 - y2) * frameHeight);

    local clipsize = dx;
    if (dy < dx) then clipsize = dy; end
	
	if (dy < LYS_Config.LineWidth) then
		dy = LYS_Config.LineWidth;
	end

	if (dx < LYS_Config.LineWidth) then
		dx = LYS_Config.LineWidth;
	end

    -- Normalise the clipping size, and clamp it to 0 - 1
    clipsize = clipsize / LYS_LINETEXTURE_SIZE;
    if (clipsize > 1) then clipsize = 1; end

	-- Simply the possible line positions to draw.
    if (x1 > x2) then
        x1, y1, x2, y2 = x2, y2, x1, y1;
    end

    -- Figure out UP or DOWN texture
    if (y1 > y2) then
        lineTexture:SetTexture(LYS_LINETEXTURE_DOWN);
        lineTexture:SetTexCoord(0, clipsize, 0, clipsize);
        lineTexture:SetPoint("TOPLEFT", lineFrame:GetName(), "BOTTOMLEFT", (x1 * frameWidth), (y1 * frameHeight));
    else
        lineTexture:SetTexture(LYS_LINETEXTURE_UP);
        lineTexture:SetTexCoord(0, clipsize, 1 - clipsize, 1);
        lineTexture:SetPoint("BOTTOMLEFT", lineFrame:GetName(), "BOTTOMLEFT", (x1 * frameWidth), (y1 * frameHeight));
	end
    lineTexture:SetWidth(dx);
    lineTexture:SetHeight(dy);
    lineTexture:Show();
end


-- Function: Find the tooltip line which contains itemString
function LYS_GetItemTooltipLine(itemBag, itemSlot, itemString)

	local itemIndex = 1;
	local tooltipLine = nil;

	GameTooltip:SetBagItem(itemBag, itemSlot);

	local myCheckLine = getglobal("GameTooltipTextLeft"..itemIndex);
	while (myCheckLine) do
		local myText = myCheckLine:GetText();

		if (myText ~= nil) then
			if (string.find(myText, itemString) ~= nil) then
				tooltipLine = myText;
			end
		end

		itemIndex = itemIndex + 1;
		myCheckLine = getglobal("GameTooltipTextLeft"..itemIndex);
	end
	GameTooltip:Hide();
	
	return tooltipLine;
end

-- Function: Get the value of an item from the given link
function LYS_ItemValue(itemLink, itemCount)
	local myValue 	= 0;

	local itemName	= LYS_LinkToName(itemLink);
	local itemID	= LYS_LinkToID(itemLink);

	-- for use with WOWEcon data
	if ((WOWEcon_Enabled) and (myValue < 1)) then
		myValue = WOWEcon_GetVendorPrice_ByLink(itemLink);
	end

	-- for use with LootLink data
	if ((ItemLinks) and (myValue < 1)) then
		if (itemName and ItemLinks[itemName]) then
			myValue = ItemLinks[itemName].p;
		end
	end

	-- for use with ItemxMatrix data
	if ((ItemMatrix_Items) and (myValue < 1)) then
		if (itemName and ItemMatrix_Items[itemName]) then
			myValue = ItemMatrix_Items[itemName].price;
		end
	end

	-- for use with KC Items
	if ((KC_SellValue) and (myValue < 1)) then
		if (itemID) then
			myValue = KC_SellValue:GetPrice(id);
		end
	end

	if ((myValue > 0) and (itemCount ~= nil)) then
		myValue = myValue * itemCount;
	end

	return myValue;
end

--[[

These are the special library routines for handling configuration of the library for all addons.

]]

function LYS_OnLoad()
	-- Register the events we care about
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Register our slash commands
	SLASH_LYSLIB1 = "/lyslib";
	SLASH_LYSLIB2 = "/ll";
	SlashCmdList["LYSLIB"] = function(msg)
		LYS_SlashHandler(msg);
	end
end

function LYS_OnEvent()
	if (event == "VARIABLES_LOADED") then
		-- Define Variabels if needed.
		RegisterForSave("LYS_Config");	-- I know, it's bad, but it needs to be global to WoW, not just this addon.

		if (LYS_Config == nil) then
			LYS_Config = {};
		end

		if (LYS_Config.LoadMessage == nil) then
			LYS_Config.LoadMessage = true;
		end

		if (LYS_Config.LineWidth == nil) then
			LYS_Config.LineWidth = 1;
		end

		--LYS_ProgramLoadedText(LYS_VERS);
	end
end

function LYS_SlashHandler(msg)
	local value;
	local myStyle;
	
	msg = string.lower(msg);

	if (msg == '') then
		msg = nil;
	end

	if (msg) then
		if (string.find(msg, LYS_CMD_LOADMESSAGE) ~= nil) then
			value = string.sub(msg, (string.len(LYS_CMD_LOADMESSAGE) + 2));
			if (string.lower(value) == LYS_CMD_ENABLE) then
				LYS_Config.LoadMessage = true;
				DEFAULT_CHAT_FRAME:AddMessage(format(LYS_MSG_LOADMESSAGE, LYS_MSG_ENABLED));
				return;
			elseif (string.lower(value) == LYS_CMD_DISABLE) then
				LYS_Config.LoadMessage = false;
				DEFAULT_CHAT_FRAME:AddMessage(format(LYS_MSG_LOADMESSAGE, LYS_MSG_DISABLED));
				return;
			end
		elseif (string.find(msg, LYS_CMD_LINEWIDTH) ~= nil) then
			value = string.sub(msg, (string.len(LYS_CMD_LINEWIDTH) + 2));
			value = tonumber(value);
			if ((value ~= nil) and (value > 0) and (value < 20)) then
				LYS_Config.LineWidth = value;
				DEFAULT_CHAT_FRAME:AddMessage(format(LYS_MSG_LINEWIDTH, LYS_Config.LineWidth));
				return;
			end
		end
	end

	LYS_Display_Help("LYS_HELP_TEXT");
end

-- Function: This routine delays for one second.
function LYS_Delay()
	local sortTime	= time();
	local curTime	= time();
	while (curTime == sortTime) do
		curTime = time();
	end
end

-- Function: Moves items from one bag and slot to another bag and slot.
function LYS_MoveItem(bag, slot, dBag, dSlot)
    PickupContainerItem(bag, slot);

    if (GetContainerItemLink(dBag, dSlot) ~= nil) then
        PickupContainerItem(dBag, dSlot);
        return;
    end

	if dBag == 0 then
		PickupContainerItem(dBag, dSlot);
		PickupContainerItem(dBag, dSlot);
		PutItemInBackpack();
	else
		PickupContainerItem(dBag, dSlot);
		PickupContainerItem(dBag, dSlot);
		PutItemInBag(getglobal("CharacterBag"..(dBag-1).."Slot"):GetID());
	end
end

-- END OF LIBRARY --
end
