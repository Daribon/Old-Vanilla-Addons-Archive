-- time between updates
AUTOMATICITEMUSER_TIME_BETWEEN_UPDATES = 1;

-- time between actual item usages
AUTOMATICITEMUSER_TIME_BETWEEN_ITEM_USES = 10;
AutomaticItemUser_Options = {};

AutomaticItemUser_CachedLocations = {};

function AutomaticItemUser_OnLoad()
	local f = AutomaticItemUserFrame; 
	f:RegisterEvent("BAG_UPDATE");
	f:RegisterEvent("VARIABLES_LOADED");
	f:RegisterEvent("UI_ERROR_MESSAGE");
end


function AutomaticItemUser_UpdateLocations(bag)
	if ( not bag ) then
		AutomaticItemUser_CachedLocations = {};
		AutomaticItemUser_ScanInventory();
	else
		local shouldErase = false;
		for k, v in AutomaticItemUser_CachedLocations do
			if ( type(v) == "table" ) then
				shouldErase = false;
				for key, value in v do
					if ( value.b == bag ) then
						shouldErase = true;
						break;
					end
				end
				if ( shouldErase ) then
					AutomaticItemUser_CachedLocations[k] = {};
				end
			end
		end
		AutomaticItemUser_ScanInventory(bag);
	end
end

--
-- getItemNameFromLink (link)
--  
--  retrieves an item name from a link or nil if it fails
--  Thanks to Telo for providing me with the code!
--
function AutomaticItemUser_GetItemNameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end;

function AutomaticItemUser_ConditionFunction_Execute(bag, slot)
	UseContainerItem(bag, slot);
	return true;
end

function AutomaticItemUser_ConditionFunction_ASAP(condition)
	local start, duration, enable;
	if ( condition.item ) then
		local locs = AutomaticItemUser_CachedLocations[condition.item];
		if ( not locs ) then
			return false;
		end
		for k, v in locs do
			start, duration, enable = GetContainerItemCooldown(v.b, v.s);
			if ( start + duration <= 0 ) and ( enable == 1 ) then
				UseContainerItem(v.b, v.s);
				return true;
			end
		end
	end
	if ( condition.items ) then
		local locs = nil;
		for key, value in condition.items do
			locs = AutomaticItemUser_CachedLocations[value];
			if ( locs ) then
				for k, v in locs do
					start, duration, enable = GetContainerItemCooldown(v.b, v.s);
					if ( start + duration <= 0 ) and ( enable == 1 ) then
						if ( condition.execFunc ) then
							return condition.execFunc(v.b, v.s);
						else
							UseContainerItem(v.b, v.s);
							return true;
						end
					end
				end
			end
		end
	end
	return false;
end

AutomaticItemUser_LastUse = 0;
AutomaticItemUser_LastUpdate = 0;

function AutomaticItemUser_OnUpdate(elapsed)
	if ( MerchantFrame:IsVisible() ) then
		return;
	end
	local curTime = GetTime();
	local diff = curTime - AutomaticItemUser_LastUpdate;
	if ( diff > AUTOMATICITEMUSER_TIME_BETWEEN_UPDATES ) then
		AutomaticItemUser_LastUpdate = curTime;
		diff = curTime - AutomaticItemUser_LastUse;
		if ( diff > AUTOMATICITEMUSER_TIME_BETWEEN_ITEM_USES ) then
			if ( AutomaticItemUser_DoUpdate() ) then
				AutomaticItemUser_LastUse = curTime;
			end
		end
	end
end

function AutomaticItemUser_DoUpdate()
	if ( not AutomaticItemUser_Options ) then
		return false;
	end
	if ( not AutomaticItemUser_Options.Conditions ) then
		return false;
	end
	local ok = true;
	local size = nil;
	local entry = nil;
	local startPos = 1;
	local retVal = false;
	while ( ok ) do
		ok = false;
		size = table.getn(AutomaticItemUser_Options.Conditions);
		for i = startPos, size do
			entry = AutomaticItemUser_Options.Conditions[i];
			if ( entry.removeFunc ) then
				if ( entry.removeFunc(v) ) then
					table.remove(AutomaticItemUser_Options, i);
					ok = true;
					break;
				end
			end
			if ( entry.updateFunc ) then
				if ( entry.updateFunc(entry) ) then
					retVal = true;
				end
			else
				if ( AutomaticItemUser_ConditionFunction_ASAP(entry) ) then
					retVal = true;
				end
			end
			if ( entry.removeFunc ) then
				if ( entry.removeFunc(entry) ) then
					table.remove(AutomaticItemUser_Options, i);
					ok = true;
					break;
				end
			end
			if ( retVal ) then
				return retVal;
			end
		end
	end
	return retVal;
end

function AutomaticItemUser_IsInterestedInItem(name)
	if ( AutomaticItemUser_Options.Conditions ) then
		for k, v in AutomaticItemUser_Options.Conditions do
			if ( v.item ) then
				if ( v.item == name ) then
					return true;
				end
			end
			if ( v.items ) then
				for key, value in v.items do
					if ( value == name ) then
						return true;
					end
				end
			end
		end
	end
end

function AutomaticItemUser_AddConditionSimple(name, item, execFunc, extraParams)
	if ( not name ) or ( not item ) then
		return false;
	end
	local t = {};
	t.name = name;
	if ( type(item) == "table" ) then
		t.items = item;
	else
		t.item = item;
	end
	if ( not execFunc ) then
	end
	t.execFunc = execFunc;
	if ( extraParams ) then
		for k, v in extraParams do
			t[k] = v;
		end
	end
	return AutomaticItemUser_AddConditionAdvanced(t);
end

function AutomaticItemUser_CheckAndFixState()
	if ( AutomaticItemUserFrame:IsVisible() ) then
		local remainVisible = false;
		for k, v in AutomaticItemUser_CachedLocations do
			if (table.getn(v) > 0 ) then
				remainVisible = true;
				break;
			end
		end
		if ( not remainVisible ) then
			AutomaticItemUserFrame:Hide();
		end
	else
		AutomaticItemUser_UpdateLocations();
		local remainHidden = true;
		for k, v in AutomaticItemUser_CachedLocations do
			if (table.getn(v) > 0 ) then
				remainHidden = false;
				break;
			end
		end
		if ( not remainHidden ) then
			AutomaticItemUserFrame:Show();
		end
	end
end


function AutomaticItemUser_RemoveCondition(name)
	if ( not AutomaticItemUser_Options ) then
		return false;
	end
	if ( not AutomaticItemUser_Options.Conditions ) then
		return false;
	end
	for k, v in AutomaticItemUser_Options.Conditions do
		if ( v.name == name ) then
			table.remove(AutomaticItemUser_Options.Conditions, k);
			return true;
		end
	end
	return false;
end

function AutomaticItemUser_AddConditionAdvanced(t)
	if ( not t ) then
		return false;
	end
	if ( not AutomaticItemUser_Options.Conditions ) then
		AutomaticItemUser_Options.Conditions = {};
	end
	table.insert(AutomaticItemUser_Options.Conditions, t);
	AutomaticItemUser_UpdateLocations();
	return true;
end

function AutomaticItemUser_ScanBag(bag)
	local numSlots = GetContainerNumSlots(bag);
	local textureName, itemCount, name;
	for slot = 1, numSlots do
		textureName, itemCount = GetContainerItemInfo(bag, slot);
		if ( textureName ) and ( strlen(textureName) > 0 ) then
			name = AutomaticItemUser_GetItemNameFromLink(GetContainerItemLink(bag, slot));
			if ( name ) then
				if ( AutomaticItemUser_CachedLocations[name] ) then
					for k, v in AutomaticItemUser_CachedLocations[name] do
						local ok = true;
						while ( ok ) do
							ok = false;
							for key, value in v.locs do
								if ( value.b == bag ) then
									table.remove(v.locs, key);
									ok = true;
									break;
								end
							end
						end
					end
				end
				if ( AutomaticItemUser_IsInterestedInItem(name) ) then
					if ( not AutomaticItemUser_CachedLocations[name] ) then
						AutomaticItemUser_CachedLocations[name] = {};
					end
					local loc = { ["b"] = bag, ["s"] = slot };
					table.insert(AutomaticItemUser_CachedLocations[name], loc);
				end
			end
		end
	end
end

function AutomaticItemUser_ScanInventory(bag)
	if ( not bag ) then
		for i = 0, 4 do 
			AutomaticItemUser_ScanBag(i);
		end
	else
		AutomaticItemUser_ScanBag(bag);
	end
end

function AutomaticItemUser_OnEvent(event)
	if ( event == "BAG_UPDATE" ) then
		AutomaticItemUser_UpdateLocations(arg1);
		AutomaticItemUser_CheckAndFixState();
	end
	if ( event == "VARIABLES_LOADED" ) then
		AutomaticItemUserFrame:UnregisterEvent("VARIABLES_LOADED");
		AutomaticItemUser_UpdateLocations();
	end
	if ( event == "UI_ERROR_MESSAGE" ) then
		if ( arg1 == SPELL_FAILED_NOT_MOUNTED ) then
			if ( not UnitOnTaxi("player") ) then
				if ( AutoMount_Dismount ) then
					AutoMount_Dismount();
				end
			end
		end
		if ( arg1 == SPELL_FAILED_NOT_STANDING ) then
			DoEmote("STAND");
		end
	end
	
end
