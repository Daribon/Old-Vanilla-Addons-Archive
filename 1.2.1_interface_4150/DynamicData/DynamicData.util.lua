--[[
	DynamicData

	By sarf

	This AddOn allows you to access dynamic data in WoW without being forced to rely on strange Blizzard functions

	Thanks goes to the Sea people, the Cosmos team and finally the nice (but strange) people at 
	 #cosmostesters and Blizzard.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=NOT_YET_ANNOUNCED
	
   ]]


-- Utility functions
DynamicData.util = {

-- public functions	

	-- 
	-- addOnWhateverHandler (func)
	--
	--  Adds a function name that will be called on whatever.
	--
	addOnWhateverHandler = function (list, func)
		for k, v in list do
			if ( v == func ) then
				return false;
			end
		end
		table.insert(list, func);
		return true;
	end;

	-- 
	-- removeOnWhateverHandler (list, func)
	--
	--  Removes the specified function, so that it will not be called on whatever.
	--
	removeOnWhateverHandler = function (list, func)
		local index = nil;
		for k, v in list do
			if ( v == func ) then
				index = k;
				break;
			end
		end
		if ( index ) then
			table.remove(list, index);
			return true;
		else
			return false;
		end
	end;

	-- 
	-- notifyWhateverHandlers (list, ...)
	--
	-- Args: 
	--  list - the list of handlers
	-- 
	--  Notifies all handlers that an Whatever has occurred.
	--
	notifyWhateverHandlers = function (list, ...) 
		local func = nil;
		for k, v in list do
			func = v;
			if ( arg ) then
				func(unpack(arg));
			else
				func();
			end
		end
	end;

	--
	-- isStringInList (str, list)
	--
	--  Returns true if str is a value of list.
	--
	isStringInList = function (param1, param2)
		local str = param1;
		local list = param2;
		if ( type(param1) == "table" ) then
			str = param2;
			list = param1;
		end
		for k, v in list do
			if ( v == str ) then
				return true;
			end
		end
		return false;
	end;
	
	--
	-- safeToUseTooltips ()
	--
	--  Checks if it is "safe" to use tooltips to dump information.
	--  Basically, it checks if one (or more) particular frames are visible.
	--  If they are, it is not safe to use tooltips.
	safeToUseTooltips = function (ignoreList)
		local frame = nil;
		local list = {};
		if ( DynamicData.util.tooltipUsingFrames ) then
			for k, v in DynamicData.util.tooltipUsingFrames do
				list[v] = 1;
			end
		end
		if ( ignoreList ) then
			for k, v in ignoreList do
				list[v] = nil;
			end
		end
		for k, v in list do
			frame = getglobal(k);
			if ( ( frame ) and ( frame:IsVisible() ) ) then
				return false;
			end
		end
		return true;
	end;

	--
	-- clearTooltipStrings (tooltipName)
	--
	--  Clears a tooltip of text.
	--
	clearTooltipStrings = function (tooltipName)
		local tooltip = getglobal(tooltipName);
		if ( tooltip ) then
			local textObj = nil;
			for i = 1, 15 do
				textObj = getglobal(tooltipName.."TextLeft"..i);
				if ( textObj ) then
					textObj:SetText("");
				end
				textObj = getglobal(tooltipName.."TextRight"..i);
				if ( textObj ) then
					textObj:SetText("");
				end
			end
		end
	end;

	--
	-- getNameFromTooltip (tooltipName)
	--
	--  Retrieves the name from the specified tooltip.
	--
	getNameFromTooltip = function (tooltipName)
		local strings = DynamicData.util.getTooltipStrings(tooltipName);
		if ( strings ) and ( strings[1] ) then
			return strings[1].left;
		else
			return nil;
		end
	end;
	
	--
	-- getTooltipStrings (tooltipName)
	--
	--  Retrieves strings from the specified tooltip.
	--  It basically takes all strings in the tooltip and puts them in an array and returns the array.
	--  All credit to Sea for this one, even though it is not copy/pasted! ;)
	--
	getTooltipStrings = function (tooltipName)
		local strings = {};
		local tooltip = getglobal(tooltipName);
		if ( tooltip ) then
			local textObj = nil;
			local textLeft = nil;
			local textRight = nil;
			for i = 1, 15 do
				strings[i] = {};
				textObj = getglobal(tooltipName.."TextLeft"..i);
				if ( textObj ) then
					textLeft = textObj:GetText();
				else
					textLeft = nil;
				end
				strings[i].left = textLeft;
				textObj = getglobal(tooltipName.."TextRight"..i);
				if ( textObj ) then
					textRight = textObj:GetText();
				else
					textRight = nil;
				end
				strings[i].right = textRight;
			end
		end
		return strings;
	end;

	--
	-- getItemTooltipInfo (bag, slot, tooltipName)
	--
	--  Retrieves info about a particular item.
	--
	getItemTooltipInfo = function (bag, slot, tooltipName)
		if ( not tooltipName ) then
			tooltipName = "DynamicDataTooltip";
		end
		local tooltip = getglobal(tooltipName);
		local strings = nil;
		DynamicData.util.clearTooltipStrings(tooltipName);
		if ( bag > -1 ) then
			DynamicData.util.protectTooltipMoney();
			tooltip:SetBagItem(bag, slot);
			DynamicData.util.unprotectTooltipMoney();
			strings = DynamicData.util.getTooltipStrings(tooltipName);
		else
			if ( slot == -1 ) then
				return nil;
			end
			DynamicData.util.protectTooltipMoney();
			local hasItem, hasCooldown = tooltip:SetInventoryItem("player", slot);
			DynamicData.util.unprotectTooltipMoney();
			strings = DynamicData.util.getTooltipStrings(tooltipName);
			if ( not hasItem) then
				DynamicData.util.clearTooltipStrings(tooltipName);
				if ( strings[1] ) then
					strings[1].left = "";
				end
			end
		end
		return strings;
	end;

	--
	-- getCurrentAndMaxDurability (strings)
	--
	--  Extracts durability info from an array that correspond to a tooltip.
	--
	getCurrentAndMaxDurability = function (strings)
		if ( not strings ) then
			return nil, nil;
		end
		local index = nil;
		local index2 = nil;
		local tmp = nil;
		for k, v in strings do
			if ( v.left )  then
				index = strfind(v.left, DYNAMICDATA_DURABILITY);
				if ( index ) then
					tmp = strsub(v.left, strlen(DYNAMICDATA_DURABILITY)+1);
					while ( strsub(tmp, 1, 1) == " " ) do
						tmp = strsub(tmp, 2);
					end
					index = strfind(tmp, " ");
					index2 = strfind(tmp, "/");
					if ( index2 < index ) then
						local indexTmp = index;
						index = index2;
						index2 = indexTmp;
					end
					local currentDurability = tonumber(strsub(tmp, 1, index-1));
					tmp = strsub(tmp, index2+1);
					while ( strsub(tmp, 1, 1) == " " ) do
						tmp = strsub(tmp, 2);
					end
					index = strfind(tmp, " ");
					if ( not index ) then
						index = strlen(tmp);
					end
					local maxDurability = tonumber(strsub(tmp, 1, index));
					return currentDurability, maxDurability;
				end					
			end
		end
		return nil, nil;
	end;
	
	--
	-- getDPS (strings)
	--
	--  Extracts DPS info from an array that correspond to a tooltip.
	--
	getDPS = function (strings)
		if ( not strings ) then
			return nil, nil;
		end
		local tmpNumber = nil;
		local tmp = nil;
		for k, v in strings do
			for tmp in string.gfind(v.left, DYNAMICDATA_DPS_GSUB) do 
				tmpNumber = tonumber(tmp);
				if ( tmpNumber ) then
					return tmpNumber;
				end
			end
		end
		return nil;
	end;
	
	
	--
	-- getItemNameFromLink (link)
	--  
	--  retrieves an item name from a link or nil if it fails
	--  Thanks to Telo for providing me with the code!
	--
	getItemNameFromLink = function (link)
		local name;
		if( not link ) then
			return nil;
		end
		for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
			return name;
		end
		return nil;
	end;

	--
	-- isItemNotBindOnAnything (strings)
	--
	--  Checks if the item represented by the parameter is not bind on anything.
	--
	isItemNotBindOnAnything = function (strings)
		if ( not strings ) then
			return false;
		end
		local tmpNumber = nil;
		local tmp = nil;
		for k, v in strings do
			if ( ( v.left ) and ( string.find(v.left, DYNAMICDATA_BIND_ON) ) ) then
				return true;
			end
		end
		return false;
	end;
	
	--
	-- getDamage (strings)
	--
	--  Extracts damage info from an array that correspond to a tooltip.
	--
	getDamage = function (strings)
		if ( not strings ) then
			return nil, nil;
		end
		local tmpNumber = nil;
		local tmp = nil;
		for k, v in strings do
			if ( v.left )  then
				local firstNumber = nil;
				for tmp in string.gfind(v.left, "%w+") do 
					tmpNumber = tonumber(tmp);
					if ( tmpNumber ) then
						if ( firstNumber ) then
							return firstNumber, tmpNumber;
						else
							firstNumber = tmpNumber;
						end
					end
				end
			end
		end
		return nil, nil;
	end;

	--
	-- getItemStringType (strings)
	--
	--  Extracts item type information from an array that correspond to a tooltip.
	--
	getItemStringType = function (strings)
		if ( not strings ) then
			return nil;
		end
		local str = nil;
		if ( ( strings[2] ) and ( strings[2].right ) ) then
			str = strings[2].right;
		end
		if ( ( str ) and ( strlen(str) <= 0 ) ) then
			if ( ( strings[3] ) and ( strings[3].right ) ) then
				str = strings[3].right;
			end
		end
		if ( ( str ) and ( strlen(str) <= 0 ) ) then
			if ( ( strings[4] ) and ( strings[4].right ) ) then
				str = strings[4].right;
			end
		end
		return str;
	end;

	--
	-- extractWeaponSpeed (str)
	--
	--  Extracts weapon speed information from a string.
	--
	extractWeaponSpeed = function (str)
		local speed = -1;
		local tmp = str;
		local index = strfind(tmp, DYNAMICDATA_WEAPON_SPEED);
		if ( index ) then
			tmp = strsub(tmp, index+1);
			while ( strsub(tmp, 1, 1) == " " ) do
				tmp = strsub(tmp, 2);
			end
			speed = tonumber(tmp);
			if ( not speed ) then
				speed = -1;
			end
		end
		return speed;
	end;

	--
	-- getWeaponSpeed (strings)
	--
	--  Extracts weapon speed information from an array that correspond to a tooltip.
	--
	getWeaponSpeed = function (strings)
		if ( not strings ) then
			return nil;
		end
		local str = "";
		if ( ( strings[2] ) and ( strings[2].right ) ) then
			str = strings[2].right;
		end
		if ( strlen(str) <= 0 ) then
			if ( ( strings[3] ) and ( strings[3].right ) ) then
				str = strings[3].right;
			end
		else
		end
		if ( strlen(str) <= 0 ) then
			if ( ( strings[4] ) and ( strings[4].right ) ) then
				str = strings[4].right;
			end
		end
		local speed = DynamicData.util.extractWeaponSpeed(str);
		if ( speed <= 0 ) then
			return nil;
		else
			return speed;
		end
	end;

	--
	-- protectTooltipMoney ()
	--
	--  Thanks to Telo for providing this solution!
	--  Prevents the clearing of money from tooltips.
	--  USE WITH CAUTION! ALWAYS CALL unhookMoneyTooltip() AFTER SETTING THE TOOLTIP!
	--
	protectTooltipMoney = function()
		if ( not DynamicData.util.saved_GameTooltip_ClearMoney ) then
			DynamicData.util.saved_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
			GameTooltip_ClearMoney = DynamicData.util.doNothing;
		end
	end;

	--
	-- unprotectTooltipMoney ()
	--
	--  Thanks to Telo for providing this solution!
	--  Allows the clearing of money from tooltips.
	--
	unprotectTooltipMoney = function()
		if ( DynamicData.util.saved_GameTooltip_ClearMoney ) then
			GameTooltip_ClearMoney = DynamicData.util.saved_GameTooltip_ClearMoney;
			DynamicData.util.saved_GameTooltip_ClearMoney = nil;
		end
	end;

-- protected functions

	-- 
	-- postpone (params)
	--
	--  params.schedulingName = scheduling name
	--  params.func = function name
	--  params.args = function arguments
	--  params.lastPostponedName = name of the variable with last postponed information
	--  params.lastUpdatedName = name of the variable with last updated information
	--  params.minimumDelay = the smallest amount of time between function calls
	--
	postpone = function (params)
		local curTime = GetTime();
		if ( not params.minimumDelay ) then
			params.minimumDelay = 0.1;
		end
		if ( not params.lastPostponedName ) then
			params.lastPostponedName = params.schedulingName.."_lastPostponedName";
		end
		if ( not params.lastUpdatedName ) then
			params.lastUpdatedName = params.schedulingName.."_lastUpdatedName";
		end
		setglobal(params.lastPostponedName, curTime);
		-- postpone checking until the updates have stopped
		if ( params.schedulingName ) then
			Cosmos_ScheduleByName(params.schedulingName, params.minimumDelay+0.01, DynamicData.util.handlePostponement, params);
		else
			Cosmos_Schedule(params.minimumDelay+0.01, DynamicData.util.handlePostponement, params);
		end
	end;


	-- 
	-- handlePostponement (params)
	--
	--  params.schedulingName = scheduling name
	--  params.func = function name
	--  params.args = function arguments
	--  params.lastPostponedName = name of the variable with last postponed information
	--  params.lastUpdatedName = name of the variable with last updated information
	--  params.minimumDelay = the smallest amount of time between function calls
	--
	handlePostponement = function (params)
		local curTime = GetTime();
		local lastPostponed = getglobal(params.lastPostponedName);
		local lastUpdated = getglobal(params.lastUpdatedName);
		if ( not lastPostponed ) then
			lastPostponed = 0;
		end
		if ( not lastUpdated ) then
			lastUpdated = 0;
		end
		if ( ( lastPostponed == 0 ) or ( curTime-lastPostponed <= params.minimumDelay ) and ( params.allowInitialUpdate == 1 ) ) then
			postpone(params);
			return;
		end
		if ( curTime-lastUpdated <= params.minimumDelay ) then
			postpone(params);
			return;
		end
		setglobal(params.lastPostponedName, 0);
		setglobal(params.lastUpdatedName, curTime);
		local f = params.func;
		if ( f ) then
			if ( params.args ) then
				f(unpack(params.args));
			else
				f();
			end
		end
	end;
-- private functions	

	--
	-- addTooltipUsingFrame (frame)
	--
	--  Adds a frame to the list of frames that want tooltips to be untouched.
	--
	addTooltipUsingFrame = function(frame)
		if ( not frame ) then
			return;
		end
		local frameName = nil;
		if ( type(frame) == "string" ) then
			frameName = frame;
		else
			frameName = frame:GetName();
		end
		if ( not frameName ) then
			return;
		end
		for k, v in DynamicData.util.tooltipUsingFrames do
			if ( v == frameName ) then
				return;
			end
		end
		table.insert(DynamicData.util.tooltipUsingFrames, frameName);
	end;


	--
	-- doNothing()
	--
	--  Does nothing.
	--
	doNothing = function()
	end;

-- variables

	saved_GameTooltip_ClearMoney = nil;

	-- contains default frames which should prevent tooltips from being parsed.
	tooltipUsingFrames = {
		"TaxiFrame", "MerchantFrame", "TradeSkillFrame", 
		"SuggestFrame", "WhoFrame", "AuctionFrame", "MailFrame" 
	};

};



