ZGAnnounce_Options = {};

local isOnLoad = nil

function ZGAnnounce_OnLoad()
	-- add default values
	for k, v in ZGANNOUNCE_OPTIONS_DEFAULT do
		if ( ZGAnnounce_Options[k] == nil ) then
			ZGAnnounce_Options[k] = v;
		end
	end
	
	local slashCmd = "ZGAnnounce";
	SlashCmdList[slashCmd] = ZGAnnounce_command;
	for k, v in ZGANNOUNCE_SLASH_COMMANDS do
		setglobal("SLASH_"..slashCmd..k, v);
	end
	
	ZGAnnounce_Saved_RollOnLoot = RollOnLoot;
	RollOnLoot = ZGAnnounce_RollOnLoot;
	
	isOnLoad = 1;

	if ( not ZGAnnounce_PassItemList ) then
		ZGAnnounce_PassItemList = {};
	end

	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("START_LOOT_ROLL");
end

local function Print(msg)
	if (IOTH_Banner) then
		IOTH_Banner(msg)	
		if (not DEFAULT_CHAT_FRAME) then
			return;
		end
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	else
		if (not DEFAULT_CHAT_FRAME) then
			return;
		end
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end


function ZGAnnounce_RaidSay(msg)
	if ( ZGAnnounce_Options.raidSay ) and ( CT_RA_AddMessage ) then 
		CT_RA_AddMessage("MS " .. msg);
		--CT_RABoss_Announce(msg, 1);
	end
end

function ZGAnnounce_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if ( not ZGAnnounce_PassItemList ) then
			ZGAnnounce_PassItemList = {};
		end
		if (isOnLoad == 1) and (ZGAnnounce_Options.enabled) then
			Print(ZGANNOUNCE_MSG_LOADED)
			for k, v in pairs(ZGANNOUNCE_USAGE) do
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
			isOnLoad = nil;
		end
		-- set default values if options contain nil entries
		for k, v in ZGANNOUNCE_OPTIONS_DEFAULT do
			if ( ZGAnnounce_Options[k] == nil ) then
				ZGAnnounce_Options[k] = v;
			end
		end
		return;
	end
	if ( event == "START_LOOT_ROLL" ) then
		ZGAnnounce_HandleItemRoll(arg1);
		return;
	end
end

function ZGAnnounce_Command_FindItemEntry(item)
	local lItem = string.lower(item);
	local tmp;
	for k, v in ZGANNOUNCE_ITEMS do
		if ( string.find(k, item) ) then
			return k, v;
		end
	end
	if ( not ZGANNOUNCE_ITEMS_LOWER ) then
		ZGANNOUNCE_ITEMS_LOWER = {};
		for k, v in ZGANNOUNCE_ITEMS do
			tmp = string.lower(k);
			ZGANNOUNCE_ITEMS_LOWER[tmp] = k;
		end
	end
	for k, v in ZGANNOUNCE_ITEMS_LOWER do
		if ( string.find(k, item) ) then
			return v, ZGANNOUNCE_ITEMS[v];
		end
	end
	return nil, nil;
end

function ZGAnnounce_Command_Send(item)
	local index, message = ZGAnnounce_Command_FindItemEntry(item);
	if ( index ) then
		SendChatMessage(message, "RAID");
		ZGAnnounce_RaidSay(message);
	end
end

function ZGAnnounce_Command_Show(item)
	local index, message = ZGAnnounce_Command_FindItemEntry(item);
	if ( index ) then
		DEFAULT_CHAT_FRAME:AddMessage(message);
	end
end

function ZGAnnounce_PassItemListUpdated(item)
end

function ZGAnnounce_Command_Pass(item)
	local index, message = ZGAnnounce_Command_FindItemEntry(item);
	if ( index ) then
		local state = ZGANNOUNCE_STATE_DISABLED;
		msg = index;
		if ( ZGAnnounce_PassItemList[index] ) then
			state = ZGANNOUNCE_STATE_ENABLED;
			ZGAnnounce_PassItemList[index] = false;
		else
			ZGAnnounce_PassItemList[index] = true;
		end
		ZGAnnounce_PassItemListUpdated(index);
		DEFAULT_CHAT_FRAME:AddMessage(format(ZGANNOUNCE_PASS_MSG, index, state));
	else
		DEFAULT_CHAT_FRAME:AddMessage(ZGANNOUNCE_UNKNOWN_ITEM_PASS);
	end
end

function ZGAnnounce_Command_Usage()
	for k, v in pairs(ZGANNOUNCE_USAGE) do
		DEFAULT_CHAT_FRAME:AddMessage(v);
	end
end


function ZGAnnounce_Command_Enable()
	ZGAnnounce_Options.enabled = true;
	Print(format(ZGANNOUNCE_STATE, ZGANNOUNCE_STATE_ENABLED));
end

function ZGAnnounce_Command_Disable()
	ZGAnnounce_Options.enabled = false;
	Print(format(ZGANNOUNCE_STATE, ZGANNOUNCE_STATE_DISABLED));
end

function ZGAnnounce_Command_Toggle()
	if ( ZGAnnounce_Options.enabled ) then
		ZGAnnounce_CommandDisable();
	else
		ZGAnnounce_CommandEnable();
	end
end

function ZGAnnounce_SetupCommands()
	ZGAnnounce_CommandList = {};
	ZGAnnounce_CommandList[ZGAnnounce_Command_Enable] = ZGANNOUNCE_COMMAND_ENABLE;
	ZGAnnounce_CommandList[ZGAnnounce_Command_Disable] = ZGANNOUNCE_COMMAND_DISABLE;
	ZGAnnounce_CommandList[ZGAnnounce_Command_Toggle] = ZGANNOUNCE_COMMAND_TOGGLE;
	ZGAnnounce_CommandList[ZGAnnounce_Command_Show] = ZGANNOUNCE_COMMAND_SHOW;
	ZGAnnounce_CommandList[ZGAnnounce_Command_Send] = ZGANNOUNCE_COMMAND_SEND;
	ZGAnnounce_CommandList[ZGAnnounce_Command_Pass] = ZGANNOUNCE_COMMAND_PASS;
end

function ZGAnnounce_command(msg)
	if ( type(msg) ~= "string" ) or ( strlen(msg) <= 0 ) then
		return ZGAnnounce_Command_Usage();
	end
	local cmd,tail = nil, nil;
	for a in string.gfind(msg, "([^%s]+)") do
		if ( not cmd ) then
			cmd = a;
		elseif ( not tail ) then
			tail = a;
		else
			tail = tail.." "..a;
		end
	end
	if ( not tail ) then
		cmd = msg;
		tail = "";
	end
	local lCmd = string.lower(cmd);
	if ( not ZGAnnounce_CommandList ) then
		ZGAnnounce_SetupCommands();
	end
	local rightCommand = false;
	for k, v in ZGAnnounce_CommandList do
		for key, value in v do 
			if ( lCmd == value ) then
				rightCommand = true;
				break;
			end
		end
		if ( rightCommand ) then
			return k(tail);
		end
	end
	return ZGAnnounce_Command_Usage();
end


function ZGAnnounce_ShouldAnnounce()
	if ( not ZGAnnounce_Options.enabled ) or ( not ZGAnnounce_Options.shouldAnnounce ) then
		return false;
	elseif ( ZGAnnounce_Options.onlyAnnounceIfRaidLeader ) and ( not IsRaidLeader() ) then
		return false;
	elseif ( ZGAnnounce_Options.onlyAnnounceIfRaidOfficer ) and ( ( not IsRaidOfficer() ) and ( not IsRaidLeader() ) ) then
		return false;
	elseif ( ZGAnnounce_Options.onlyInRaid ) and ( GetNumRaidMembers() <= 0 ) then
		return false;
	else
		return true;
	end
end

function ZGAnnounce_ShouldRoll(id)
	local name = nil;
	_, name = GetLootRollItemInfo(id);
	return ZGAnnounce_ShouldRollOnItem(name);
end

function ZGAnnounce_ShouldRollOnItem(name)
	if ( ZGAnnounce_Options.onlyInZulGurub ) and ( GetRealZoneText() ~= ZGANNOUNCE_ZONE_ZULGURUB ) then
		return false;
	end
	if ( not name ) then return false; end
	local msg = ZGANNOUNCE_ITEMS[name];
	local class = nil;
	class = UnitClass("player");
	if ( msg ) and (strfind(msg, class)) then
		return true;
	end
	return false;
end

function ZGAnnounce_AQ_Execute(entry)
	if ( not entry.lootIds ) then
		return false;
	end
	local lootId, lootMethod;
	for k, v in entry.lootIds do
		if ( v ) then 
			lootId = k; 
			lootMethod = v;
			break; 
		end
	end
	if ( not lootId ) then
		return false;
	end
	RollOnLoot(lootId, lootMethod);
	entry.lootIds[lootId] = false;
	if ( ZGAnnounce_AQ_ShouldExecute(entry) ) then
		ActionQueue_QueueAction(entry);
	end
	return true;
end

function ZGAnnounce_AQ_ShouldExecute(entry)
	if ( not entry.lootIds ) then
		return false;
	end
	local lootId = nil;
	for k, v in entry.lootIds do
		if ( v ) then 
			return true;
		end
	end
	return false;
end

ZGAnnounce_ActionQueueEntry = {
	id = "ZG Item Need Roll";
	name = "ZG Item Need Roll";
	shouldExecuteFunc = ZGAnnounce_AQ_ShouldExecute;
	executeFunc = ZGAnnounce_AQ_Execute;
	lootIds = {
	};
};

function ZGAnnounce_RollOnLoot(id, rollType, p1, p2, p3, p4, p5)
	if ( ZGAnnounce_ActionQueueEntry.lootIds ) then
		ZGAnnounce_ActionQueueEntry.lootIds[id] = false;
	end
	return ZGAnnounce_Saved_RollOnLoot(id, rollType, p1, p2, p3, p4, p5);
end

ZGAnnounceTooltipTextLefts = {
};
for i = 1, 15 do
	ZGAnnounceTooltipTextLefts[i] = getglobal("ZGAnnounceTooltipTextLeft"..i);
end

function ZGAnnounce_SpecialHandler(id)
	ZGAnnounceTooltip:SetLootRollItem(id);
	local obj;
	if ( ZGAnnounce_Options.specialAutoRollGreedOnBoE ) then
		for i = 2, 5 do
			obj = ZGAnnounceTooltipTextLefts[i];
			if ( obj ) and ( obj.GetText ) and ( obj:GetText() == ITEM_BIND_ON_EQUIP ) then
				ZGAnnounce_DoRoll(id, 2);
				return true;
			end
		end
	end
	return false;
end


function ZGAnnounce_DoRoll(id,rollType)
	RollOnLoot(id, rollType);
	ZGAnnounce_ActionQueueEntry.lootIds[id] = rollType;
	if ( ActionQueue_QueueAction ) and ( ActionQueue_IsQueued ) and ( not ActionQueue_IsQueued(ZGAnnounce_ActionQueueEntry) ) then 
		--ActionQueue_QueueAction(ZGAnnounce_ActionQueueEntry);
	end
end

function ZGAnnounce_HandleItemRoll(id)
	if ( ZGAnnounce_Options.specialAutoRoller ) then
		if ( ZGAnnounce_SpecialHandler(id) ) then
			return;
		end
	end
	
	local name = nil;
	_, name = GetLootRollItemInfo(id);
	if ( ZGAnnounce_PassItemList[name] ) then
		ZGAnnounce_DoRoll(id, 0);
	elseif ( ZGAnnounce_ShouldRollOnItem(name) ) then
		ZGAnnounce_DoRoll(id, 1);
	elseif ( name ) and ( ZGANNOUNCE_ITEMS[name] ) then
		ZGAnnounce_DoRoll(id, 0);
	end
	if ( ZGAnnounce_ShouldAnnounce() ) then
		local message = nil;
		if ( name ) then
			message = ZGANNOUNCE_ITEMS[name];
		end
		if ( not message ) and ( ZGAnnounce_Options.announceUnknownItems ) then
			message = ZGANNOUNCE_UNKNOWN_ITEM;
		end
		if ( message ) then 
			SendChatMessage(message, "RAID");
			ZGAnnounce_RaidSay(message);
		end
		return true;
	else
		return false;
	end
end