--[[

Changes by sarf:

Added auto-config support. Will be determined on each cast (should not be a penalty).

Added out-of-range-check (requires that DD Action is present).

Added DoT check (for the "Shadow Word: Pain"/"Curse of Agony" spell).

--

Added Mana Spring totem

Removed Warlock DoTs

Added an optional DD Effect checking for the debuffs too (and hence restructured the UnitIsMarkedForDeath thingies).

]]--

--[[
Kill de totemz.

Edit with your own spell/shot if you need to, in the variables.

This is quick and dirty, by all means toss me a line at evilsmoo@gmail.com if you have a better idea.




Fire Blast(Rank 1) (for mages?)
Shoot Bow(Rank 1)  (for non-hunter guns?  need to test further.)


UnitClass("unit") - Returns the class name of the specified unit (e.g., "Warrior" or "Shaman").
   in case you want to set it up to use different spells by class....
]]

-- ***********************************

TKill_ChatSpellEvents = {
	"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF",
};

TKill_ZoneChangeEvents = {
	"ZONE_CHANGED",
	"ZONE_CHANGED_INDOORS",
	"ZONE_CHANGED_NEW_AREA"
};

-- *******

-- End variables.

-- Variables
TKill = { };
TKill.onlyHandleQueue = false;
TKill.assumeHostile = false;
TKill.autoDetectTotems = true;
TKill.showSplashMessage = true;
TKill.autoKill = true;

TKill.automode = false;
TKill.mode = "PvP";
TKill.Retarget = true;  --Change this to false if you don't want to target your last enemy
TKill.TempTarget = "";
TKill.Hostile = false;
--I'd suggest using a fast-cast spell with as little cooldown as possible.
--Not sure about hunters, though...  :/   A shot spell works, but annoying cooldown.

-- This function will cast an appropriate spell from the spell list. 
-- It will even be able (with DynamicData Spell) to use "backup" spells in the case where a spell has a cooldown.
function TKill_CastSpell()
	local class = UnitClass("player");
	local inRange = false;
	if ( class ) and ( TKill_Spells[class] ) then
		for k, v in TKill_Spells[class] do
			inRange = true;
			local spellRank = TKill_Rank_String;
			local spellName = v;
			if ( type(spellName) == "table" ) then
				if ( v.name ) then
					spellName = v.name;
					spellRank = v.rank;
				elseif ( v.action ) then
					local func = v.action;
					if ( type(func) == "string" ) then
						func = getglobal(func);
					end
					if ( func ) then
						if ( v.actionArgs ) then
							func(unpack(v.actionArgs));
						else
							func();
						end
						return true;
					end
				end
			end
			if ( DynamicData ) and ( DynamicData.action ) and ( DynamicData.action.getSpellAsActionId ) then
				local actionId = DynamicData.action.getSpellAsActionId(spellName);
				if ( actionId ) and ( actionId >= 1 ) and ( IsActionInRange(actionId) ~= 1 ) then
					inRange = false;
				end
			end
			if ( inRange ) then
				if ( DynamicData ) and ( DynamicData.spell ) and ( DynamicData.spell.getMatchingSpellId ) then
					local spellId = DynamicData.spell.getMatchingSpellId(spellName, 1);
					if ( spellId ) then
						local start, duration, enable = GetSpellCooldown(spellId, BOOKTYPE_SPELL);
						if ( ( start+duration ) <= 0 ) then
							CastSpell(spellId, BOOKTYPE_SPELL);
							return true;
						end
					end
				else
					local n = spellName;
					if ( spellRank ) then
						n = n..spellRank;
					end
					CastSpellByName(n);
					return true;
				end
			end
		end
	end
	return false;
end


TKILL_ITEMS_LIFESPAN = {};

TKILL_NORMAL_ITEM_LIFESPAN = 45;

TKill_Queued_Items = {};

function TKill_GetItemTimeSpan(itemName)
	if ( TKILL_ITEMS_LIFESPAN[itemName] ) then
		return TKILL_ITEMS_LIFESPAN[itemName];
	else
		return TKILL_NORMAL_ITEM_LIFESPAN;
	end
end

function TKill_CleanQueuedItems()
	local ok = true;
	local curTime = GetTime();
	while ( ok ) do
		ok = false;
		for k, v in TKill_Queued_Items do
			if ( v.time < curTime ) then
				table.remove(TKill_Queued_Items, k);
				ok = true;
				break;
			end
		end
	end
end

TKill_SplashMessage_DefaultColor = { r = 1.0, g = 0.1, b = 0.1 };

function TKill_SplashMessage(message, pColor, sound)
	if ( not sound ) then
		sound = "AuctionWindowOpen";
	end
	local color = {};
	for k, v in TKill_SplashMessage_DefaultColor do
		color[k] = v;
	end
	for k, v in pColor do
		color[k] = v;
	end
	TKillSplashFrameText:SetTextColor(color.r, color.g, color.b);
	TKillSplashFrameText:SetText(message);
    TKillSplashFrame.startTime = GetTime();
    if ( strlen(sound) > 0 ) then
		PlaySound(sound);
	end
    TKillSplashFrame:Show();
end


function TKill_ShowQueuedItem(itemName)
	local msg = TEXT(TKILL_QUEUE_MESSAGE);
	if ( string.find(msg, "%%s") ) then
		msg = string.format(msg, itemName);
	end
	TKill_SplashMessage(msg);
end

function TKill_AddQueuedItem(itemName)
	local item = { name = itemName, time = TKill_GetItemTimeSpan(itemName) + GetTime() };
	table.insert(TKill_Queued_Items, item);
	if ( TKill.autoKill ) then
		if ( SpellQueue_QueueSpellAdvanced ) then
			local t = {};
			t.name = "Totem Killer";
			t.shouldExecuteFunc = SpellQueue_ShouldExecuteFunction_ASAP;
			t.executeFunc = TKill_Handle_Queue;
			SpellQueue_QueueSpellAdvanced(t);
		end
	end
	TKill_CleanQueuedItems();
end

TKill_CastTotem_Friendly_UnitList = nil;

-- generates a list of all friendly units (party1..5, raid1..40, player, pet)
function TKill_GetFriendlyUnitList()
	if ( TKill_CastTotem_Friendly_UnitList ) then
		return TKill_CastTotem_Friendly_UnitList;
	end
	TKill_CastTotem_Friendly_UnitList = {};
	table.insert(TKill_CastTotem_Friendly_UnitList, "pet");
	table.insert(TKill_CastTotem_Friendly_UnitList, "player");
	for i = 1, 5 do
		table.insert(TKill_CastTotem_Friendly_UnitList, "party"..i);
	end
	for i = 1, 40 do
		table.insert(TKill_CastTotem_Friendly_UnitList, "raid"..i);
	end
end

function TKill_ShouldAssumeHostile()
	-- TODO: code for detecting faction and PvP mode should go here
	local factionGroup = UnitFactionGroup(unit);
	if ( factionGroup ) and ( factionGroup == TKILL_FACTIONGROUP_ALLIANCE ) then
		return true;
	elseif ( not UnitIsPVPFreeForAll("player") ) and ( ( not factionGroup ) or ( not UnitIsPVP("player") ) ) then
		return true;
	else
		return TKill.assumeHostile;
	end
end

function TKill_Handle_CastTotem(whom, spellName)
	local targetName = UnitName("target");
	local shouldAdd = false;
	if ( targetName ) and ( strlen(targetName) > 0 ) and ( whom == targetName ) and ( UnitCanAttack("target", "player") )  then
		shouldAdd = true;
		TKill_AddQueuedItem(spellName);
	end
	if ( not shouldAdd ) and ( TKill_ShouldAssumeHostile() ) then
		local isFriendly = false;
		local list = TKill_GetFriendlyUnitList();
		for k, v in list do
			if ( UnitExists(v) ) then
				name = UnitName(v);
				if ( name ) and ( type(name) == "string" ) and ( name == whom ) then
					isFriendly = true;
					break;
				end
			end
		end
		if ( not isFriendly ) then
			shouldAdd = true;
		end
	end
	if ( shouldAdd ) then
		TKill_AddQueuedItem(spellName);
		if ( TKill.showSplashMessage ) then
			TKill_ShowQueuedItem(itemName);
		end
	end
end

function TKill_Handle_Queue()
	if ( table.getn(TKill_Queued_Items) > 0 ) then
		local item = table.remove(TKill_Queued_Items);
		if ( item ) and ( item.name ) and ( strlen(item.name) > 0 ) then
			TKill_Kill_Setup();
			if ( TKill_Kill_Something(item) ) then
				return true;
			end
			TKill_Kill_Teardown();
		end
	end
	return false;
end

function TKill_Event_Chat(msg)
	if ( TKill.autoDetectTotems ) then
		TKill_Event_Chat_Localized(msg);
	end
end

function TKill_OnLoad()

	-- Register for Events
	for k, v in TKill_ChatSpellEvents do
		this:RegisterEvent(v);
	end
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_PVP_UPDATE");
	for k, v in TKill_ZoneChangeEvents do
		this:RegisterEvent(v);
	end

	-- Register Slash Commands
	SLASH_TKILL1 = "/tkill";
	SlashCmdList["TKILL"] = function( msg )
		TKill_SlashMessageHandler(msg)
		--TKill_Kill();
	end
	DEFAULT_CHAT_FRAME:AddMessage("Totem Killer Active.");
	
	-- Set spell by class (default is druid  ;)
	--Self_Class = UnitClass("player");
	--Spellname = Class_Spells.Self_Class;
	
end

function TKill_IsInPvPMode()
	if ( TKill ) and ( TKill.mode == "PvP" ) then
		return true;
	else
		return false;
	end
end

function TKill_IsInAutoMode()
	if ( TKill ) then
		return TKill.automode;
	else
		return false;
	end
end

function TKill_Event_ZoneChanged()
	if ( TKill_IsInAutoMode() ) then
		local zoneText = GetZoneText();
		local newmode = nil;
		if ( TKill_TotemList[zoneText] ) then
			newmode = zoneText;
		end
		if ( newmode ) then
			if ( TKill_IsInPvPMode() ) then
				TKill.oldmode = newmode;
			else
				TKill.oldmode = TKill.mode;
				TKill.mode = newmode;
			end
		else
			if ( TKill_IsInPvPMode() ) then
				TKill.oldmode = "PvE";
			else
				TKill.mode = "PvE";
			end
		end
	end
end

function TKill_Event_PvP()
	if ( TKill_IsInAutoMode() ) then
		local factionGroup, factionName = UnitFactionGroup("player");
		if ( UnitIsPVPFreeForAll("player") ) or ( ( factionGroup ) and ( UnitIsPVP("player") ) ) then
			if ( TKill ) then
				TKill.oldmode = TKill.mode;
				TKill.mode = "PvP";
			end
		else
			if ( TKill ) then
				if ( TKill.oldmode ) then
					TKill.mode = TKill.oldmode;
				else
					TKill.mode = "PvE";
				end
			end
		end
	end
end

function TKill_OnEvent()
	-- Save Variables
	if ( event == "VARIABLES_LOADED") then
		--RegisterForSave("TKill");  --no point now since added to the .toc
		return;
	end
	if ( event == "UNIT_PVP_UPDATE" ) then
		TKill_Event_PvP();
		return;
	end
	-- Zone Changed events
	for k, v in TKill_ZoneChangeEvents do
		if ( event == v ) then
			TKill_Event_ZoneChanged();
			return;
		end
	end
	for k, v in TKill_ChatSpellEvents do
		if ( event == v ) then
			TKill_Event_Chat(arg1);
			return;
		end
	end
end	

function TKill_UnitIsMarkedForDeath_DD_Effect(unit, debuffsList)
	if ( not unit ) or ( not debuffsList ) then
		return false;
	end
	if ( not DynamicData ) or ( not DynamicData.effect ) or ( not DynamicData.effect.hasEffectInfo ) then
		return false;
	end
	
	for k, debuffData in debuffsList do
		-- we could specify texture too, but there is no need to, besides, textures may change but names will (hopefully) stay the same
		if ( DynamicData.effect.hasEffectInfo(unit, debuffData.name) ) then
			return true;
		end
	end
	return false;
end

function TKill_GetTotemList()
	if ( not TKill ) then
		TKill = {};
	end
	if ( not TKill.mode ) then
		TKill.mode = "PvP";
	end
	if ( TKill_TotemList[TKill.mode] ) then
		return TKill_TotemList[TKill.mode];
	else
		for k, v in TKill_TotemList do
			return v;
		end
	end
end

-- Will detect if a DoT is on the totem and if so, skip it.
function TKill_UnitIsMarkedForDeath(unit)
	if ( not unit ) then
		return false;
	end
	-- performance increase - will only check for debuffs on classes that need it
	local class = UnitClass("player");
	if ( not class ) then
		return false;
	end
	if ( not TKill_UnitIsMarkedForDeath_Data ) then
		return false;
	end
	local list = TKill_UnitIsMarkedForDeath_Data[class];
	if ( not list ) then
		return false;
	end
	if ( DynamicData ) and ( DynamicData.effect ) and ( DynamicData.effect.hasEffectInfo ) then
		return TKill_UnitIsMarkedForDeath_DD_Effect(unit, list);
	end
	
	local i = 1;
	local debuff = UnitDebuff(unit, i);
	while debuff do
		for k, v in list do
			if ( string.find(debuff, v.texture) ) then
				return true;
			end
		end
		i = i + 1;
		debuff = UnitDebuff(unit, i);
	end
	return false;
end

function TKill_Kill_Something(v)
	TargetUnit("player");
	TargetByName(v);
	--DEFAULT_CHAT_FRAME:AddMessage(v);  --only for debug.  very spammy.
	if ( not UnitIsDead("target") ) 
		and ( UnitIsEnemy("player", "target") ) 
		and ( not UnitIsPlayer("target") ) 
		and ( not TKill_UnitIsMarkedForDeath("target") )
		then
		TKill_CastSpell();  --Wham goes here.
		if ( TKill.Retarget and TKill.TempTarget ~= nil ) then 
			TargetByName(TKill.TempTarget);
		else
			ClearTarget();
		end
		return true;
	end
	if TKill.Hostile then
		TargetLastEnemy();
	end
	return false;
end

function TKill_Kill_Setup()
	TKill.Hostile = false;
	TKill.TempTarget = UnitName("target");
	if UnitIsEnemy("player", "target") then
		TKill.Hostile = true;
	else
		TKill.Hostile = false;
	end
end

function TKill_Kill_Teardown()
	if TKill.Hostile then
		return;
	end
	if ( TKill.Retarget and TKill.TempTarget ~= nil ) then 
		TargetByName(TKill.TempTarget);
	else
		ClearTarget();
	end
end

function TKill_Kill()	-- You get the idea.  Check if it exists, if it does, kill.
	if ( TKill_Handle_Queue() ) then
		return;
	end
	if ( TKill.onlyHandleQueue ) then
		return;
	end
	TKill_Kill_Setup();
	--DEFAULT_CHAT_FRAME:AddMessage("ttarg is "..TKill.Temptarget.." forsooth!");  --debug
	local totemList = TKill_GetTotemList();
	for k, v in totemList do
		if ( TKill_Kill_Something(v) ) then
			return;
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(TEXT(TKILL_NOTHING_FOUND_MESSAGE));
	TKill_Kill_Teardown();
end

function TKill_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
end

function TKill_Extract_NextParameter(msg)
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

function TKill_IsCommand(command, commandList)
	for k, v in commandList do
		if ( string.find(command, v) ) then
			return true;
		end
	end
end

function TKill_Slash_Usage()
	for k, v in TKill_Slash_Help do
		TKill_Print(v);
	end
end

function TKill_ToggleHandler(varName, messageName)
	if ( not TKill ) then
		TKill = {};
	end
	if ( TKill[varName] ) then
		TKill[varName] = false;
		toggle = TKill_Toggle_Disable;
	else
		TKill[varName] = true;
		toggle = TKill_Toggle_Enable;
	end
	TKill_Print(string.format(messageName, toggle));
end

function TKill_SlashMessageHandler(msg)
	if ( not msg ) or ( strlen(msg) <= 0 ) then
		TKill_Kill();
		return;
	else
		local command, params = TKill_Extract_NextParameter(msg);
		if ( TKill_IsCommand(command, TKill_Slash_Command_Kill) ) then
			TKill_Kill();
			return;
		end
		if ( TKill_IsCommand(command, TKill_Slash_Command_AutoKillMode) ) then
			TKill_ToggleHandler("autoKill", TKill_AutoKillMode_Toggle);
			return;
		end
		
		if ( TKill_IsCommand(command, TKill_Slash_Command_OnlyHandleQueueMode) ) then
			TKill_ToggleHandler("onlyHandleQueue", TKill_OnlyHandleQueueMode_Toggle);
			return;
		end
		if ( TKill_IsCommand(command, TKill_Slash_Command_AssumeHostileMode) ) then
			TKill_ToggleHandler("assumeHostile", TKill_AssumeHostileMode_Toggle);
			return;
		end
		if ( TKill_IsCommand(command, TKill_Slash_Command_ShowSplashMode) ) then
			TKill_ToggleHandler("showSplashMessage", TKill_ShowSplashMode_Toggle);
			return;
		end
		if ( TKill_IsCommand(command, TKill_Slash_Command_AutoMode) ) then
			TKill_ToggleHandler("automode", TKill_AutoMode_Toggle);
			return;
		end
		if ( TKill_IsCommand(command, TKill_Slash_Command_ListMode) ) then
			TKill_Print(TKill_ListMode_Text);
			for k, v in TKill_TotemList do
				TKill_Print(k);
			end
			return;
		end
		if ( TKill_IsCommand(command, TKill_Slash_Command_Mode) ) then
			local outMsg = nil;
			if ( not TKill_TotemList[params] ) then
				if ( not params ) then params = "<NIL>"; end
				outMsg = string.format(TKill_Mode_NotFound, params);
			else
				if ( not TKill ) then
					TKill = {};
				end
				TKill.mode = params;
				outMsg = string.format(TKill_Mode_Switch, params);
			end
			TKill_Print(outMsg);
			return;
		end
		TKill_Slash_Usage();
	end
end