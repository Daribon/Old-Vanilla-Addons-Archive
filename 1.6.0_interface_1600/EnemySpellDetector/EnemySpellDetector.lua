EnemySpellDetector_Debug = true;
EnemySpellDetector_OptimizeMemory = false;

EnemySpellDetector_Type_Cast = "cast";
EnemySpellDetector_Type_Gain = "gain";
EnemySpellDetector_Type_Perform = "perform";
EnemySpellDetector_Type_BeginCast = "begincast";
EnemySpellDetector_Type_BeginPerform = "beginperform";

EnemySpellDetector_Options = {
	onlyTargetIsEnemy = false;
};

EnemySpellDetector_Listeners = {
	cast = {};
	gain = {};
	perform = {};
	begincast = {};
	beginperform = {};
};

EnemySpellDetector_GlobalStringTranslations = {
	["%%s"] = "%(%.+%)",
	["%%d"] = "%(%%d%)",
};

function EnemySpellDetector_GlobalStringTogfind(str)
	local retStr = str;
	for k, v in EnemySpellDetector_GlobalStringTranslations do
		retStr = string.gsub(str, k, v);
	end
	return retStr;
end



function EnemySpellDetector_PrepareForGFind()
	for event, list in EnemySpellDetector_ChatMessages do
		for key, value in list do
			if ( not value.pattern ) then
				value.pattern = EnemySpellDetector_GlobalStringTogfind(getglobal(value.msg));
				if ( EnemySpellDetector_OptimizeMemory ) then
					value.msg = nil;
				end
			end
		end
	end
end


function EnemySpellDetector_OnLoad()
	EnemySpellDetector_PrepareForGFind();
	local f = EnemySpellDetectorFrame;
	for event, list in EnemySpellDetector_ChatMessages do
		f:RegisterEvent(event);
	end
	f:RegisterEvent("VARIABLES_LOADED");
end

function EnemySpellDetector_AfterLoad_OnEvent()
	local value = EnemySpellDetector_ChatMessages[event];
	if ( value ) then
		EnemySpellDetector_HandleChatEvent(event, arg1);
	end
end

function EnemySpellDetector_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		local f = EnemySpellDetectorFrame;
		f:UnregisterEvent(event);
		EnemySpellDetector_OnEvent = EnemySpellDetector_AfterLoad_OnEvent;
		return;
	end
	EnemySpellDetector_AfterLoad_OnEvent();
end

function EnemySpellDetector_OnUpdate()
end

EnemySpellDetector_FriendlyUnits = {
	"pet",
	"party1",
	"party2",
	"party3",
	"party4",
	--[[
	"raid1",
	"raid2",
	"raid3",
	"raid4",
	"raid5",
	"raid6",
	"raid7",
	"raid8",
	"raid9",
	"raid10",
	"raid11",
	"raid12",
	"raid13",
	"raid14",
	"raid15",
	"raid16",
	"raid17",
	"raid18",
	"raid19",
	"raid20",
	"raid21",
	"raid22",
	"raid23",
	"raid24",
	"raid25",
	"raid26",
	"raid27",
	"raid28",
	"raid29",
	"raid30",
	"raid31",
	"raid32",
	"raid33",
	"raid34",
	"raid35",
	"raid36",
	"raid37",
	"raid38",
	"raid39",
	"raid40"
	]]--
};

function EnemySpellDetector_IsEnemy(name)
	if ( not name ) then
		return false;
	end
	local tmp = nil;
	if ( EnemySpellDetector_Options.onlyTargetIsEnemy ) then
		tmp = UnitName("target"); 
		if ( tmp ) and ( tmp == name ) then
			return true;
		end
	end
	for k, v in EnemySpellDetector_FriendlyUnits do
		tmp = UnitName(v);
		if ( tmp ) then
			if ( name == tmp ) then
				return false;
			end
		end
	end
	return true;
end

function EnemySpellDetector_HandleChatEvent(event, msg)

	local performer = nil;
	local action = nil;
	local target = nil;
	local shouldCall = true;

	local value = EnemySpellDetector_ChatMessages[event];
	for key, template in value do
		if ( EnemySpellDetector_Listeners[template.type] ) and ( table.getn(EnemySpellDetector_Listeners[template.type]) > 0 ) then
			for a1, a2, a3, a4, a5, a6, a7, a8, a9 in string.gfind(msg, template.pattern) do
				function getIndex(i) if ( not i ) then return nil; elseif (i == 1) then return a1; elseif (i == 2) then return a2; elseif (i == 3) then return a3; elseif (i == 4) then return a4; elseif (i == 5) then return a5; elseif (i == 6) then return a6; elseif (i == 7) then return a7; elseif (i == 8) then return a8; elseif (i == 9) then return a9; else return nil; end end
				shouldCall = true;
				performer = getIndex(template.performerIndex);
				action = getIndex(template.actionIndex);
				target = getIndex(template.targetIndex);
				--[[
				if ( performerIndex == 1 ) then performer = a1; 
				elseif ( performerIndex == 2 ) then performer = a2; 
				elseif ( performerIndex == 3 ) then performer = a3; 
				else performer = nil; end
				if ( actionIndex == 1 ) then action = a1; 
				elseif ( actionIndex == 2 ) then action = a2; 
				elseif ( actionIndex == 3 ) then action = a3;
				else action = nil; end
				if ( targetIndex == 1 ) then target = a1; 
				elseif ( targetIndex == 2 ) then target = a2; 
				elseif ( targetIndex == 3 ) then target = a3;
				else target = nil; end
				]]--
				if ( performer ) then
					if ( not EnemySpellDetector_IsEnemy(performer) ) then
						shouldCall = false;
					end
				end
				if ( shouldCall ) then
					EnemySpellDetector_CallListener(template.type, performer, action, target);
				end
			end
		end
	end
end

function EnemySpellDetector_CallListener(eventType, performer, action, target, p1, p2, p3, p4, p5, p6, p7, p8, p9)
	if ( not EnemySpellDetector_Listeners[eventType] ) then
		EnemySpellDetector_Error(ENEMYSPELLDETECTOR_ERROR_MISSING_EVENTTYPE);
		return;
	end
	local list = EnemySpellDetector_Listeners[eventType];
	local func = nil;
	for k, funcName in list do
		if ( type(funcName) == "string" ) then
			func = getglobal(funcName);
		else
			func = funcName;
		end
		if ( func ) then
			func(performer, action, target, p1, p2, p3, p4, p5, p6, p7, p8, p9);
		end
	end
end

function EnemySpellDetector_AddListener(eventType, funcName)
	if ( type(eventType) == "table" ) then
		local ok = false;
		for k, v in eventType do
			if ( EnemySpellDetector_AddListener(v, funcName) ) then
				ok = true;
			end
		end
		return ok;
	end
	if ( EnemySpellDetector_RemoveListener(eventType, funcName) ) then
		EnemySpellDetector_Warning(ENEMYSPELLDETECTOR_WARNING_ADDED_EXISTING_LISTENER);
	end
	table.insert(EnemySpellDetector_Listeners[eventType], funcName);
	return true;
end

function EnemySpellDetector_RemoveListener(eventType, funcName)
	if ( type(eventType) == "table" ) then
		local ok = false;
		for k, v in eventType do
			if ( EnemySpellDetector_RemoveListener(v, funcName) ) then
				ok = true;
			end
		end
		return ok;
	end
	if ( not EnemySpellDetector_Listeners[eventType] ) then
		EnemySpellDetector_Error(ENEMYSPELLDETECTOR_ERROR_NON_EVENTTYPE);
		EnemySpellDetector_Listeners[eventType] = {};
	end
	local foundPos = nil;
	for k, v in EnemySpellDetector_Listeners[eventType] do
		if ( v == funcName ) then
			foundPos = k;
			break;
		end
	end
	if ( foundPos ) then
		table.remove(EnemySpellDetector_Listeners[eventType], foundPos);
		return true;
	else
		return false;
	end
end



function EnemySpellDetector_Error(msg)
	if ( EnemySpellDetector_Debug ) and ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("EnemySpellDetector ERROR: "..msg, 1, 0.1, 0.1);
	end
end

function EnemySpellDetector_Warning(msg)
	if ( EnemySpellDetector_Debug ) and ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("EnemySpellDetector WARNING: "..msg, 0.2, 0.2, 1);
	end
end

function EnemySpellDetector_Notify(msg)
	if ( EnemySpellDetector_Debug ) and ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("EnemySpellDetector NOTE: "..msg, 0.2, 1, 0.2);
	end
end

function EnemySpellDetector_Print(msg)
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("EnemySpellDetector: "..msg, 1, 1, 0.1);
	end
end

