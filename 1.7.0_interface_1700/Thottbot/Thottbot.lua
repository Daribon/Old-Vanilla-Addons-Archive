-- Copyright 2004 by Thott

function Thottbot_Tloc()
	if(not Thottbot.Tloc) then
		return true;
	end
	local x,y = GetPlayerMapPosition("player");
	x = Sea.math.round(x*100);
	y = Sea.math.round(y*100);
	ThottbotText:SetText(format("%2d,%2d",x,y));
end
function Thottbot_ProfileLink()
	local server = GetRealmName();
	if (server) then
		return "http://www.thottbot.com/?profile="..UnitName("player").."."..server;
	else
		return T_SERVER_UNKNOWN;
	end
end
function Thottbot_KhaosInit()
	if(not Khaos) then
		return;
	end
	local Options = {
		{
			id="ThottbotHeader";
			text="Thottbot";
			helptext=T_HEADER_HELP;
			difficulty=1;
			type=K_HEADER;
		};
		{
			id="ThottbotProfileEnable";
			text=T_PROFILE_TEXT;
			helptext=T_PROFILE_HELP..Thottbot_ProfileLink();
			difficulty=1;
			key="tbprofile";
			check=true;
			type=K_TEXT;
			callback=Thottbot_PlayerProfileEnable;
			feedback=function(state)
				if(state.checked) then
					return T_PROFILE_ENABLED..Thottbot_ProfileLink();
				else
					return T_PROFILE_DISABLED;
				end
			end;
			default = {
				checked = true;
			};
			disabled = {
				checked = false;
			};
		};
		{
			id="ThottbotTargetProfileEnable";
			text=T_TARGET_PROFILE_TEXT;
			helptext=T_TARGET_PROFILE_HELP;
			difficulty=1;
			key="tbtarget";
			check=true;
			type=K_TEXT;
			callback=Thottbot_TargetProfileEnable;
			feedback=function(state)
				if(state.checked) then
					return T_TARGET_PROFILE_ENABLED;
				else
					return T_TARGET_PROFILE_DISABLED;
				end
			end;
			default = {
				checked = true;
			};
			disabled = {
				checked = false;
			};
		};
		{
			id="ThottbotDataEnable";
			text=T_DATA_TEXT;
			helptext=T_DATA_HELP;
			difficulty=1;
			key="tbdata";
			check=true;
			type=K_TEXT;
			callback=Thottbot_Enable;
			feedback=function(state)
				if(state.checked) then
					return T_DATA_ENABLED;
				else
					return T_DATA_DISABLED;
				end
			end;
			default = {
				checked = true;
			};
			disabled = {
				checked = false;
			};
		};
		{
			id="ThottbotHeavyEnable";
			text=T_HEAVY_TEXT;
			helptext=T_HEAVY_HELP;
			difficulty=1;
			key="tbheavy";
			check=true;
			type=K_TEXT;
			callback=Thottbot_HeavyEnable;
			feedback=function(state)
				if(state.checked) then
					return T_HEAVY_ENABLED;
				else
					return T_HEAVY_DISABLED;
				end
			end;
			default = {
				checked = false;
			};
			disabled = {
				checked = false;
			};
			dependencies = {
				tbdata={checked=true;match=true};
			};
		};
		{
			id="ThottbotStateEnable";
			text=T_STATE_TEXT;
			helptext=T_STATE_HELP;
			difficulty=1;
			key="tbstate";
			check=true;
			type=K_TEXT;
			callback=Thottbot_StateEnable;
			feedback=function(state)
				if(state.checked) then
					return T_STATE_ENABLED;
				else
					return T_STATE_DISABLED;
				end
			end;
			default = {
				checked = true;
			};
			disabled = {
				checked = true;
			};
			dependencies = {
				tbprofile={checked=true;match=true};
			};
		};
	};
		
	Khaos.registerOptionSet(
		"other",
		{
			id = "Thottbot";
			text = "Thottbot";
			helptext = T_SET_DESC;
			options = Options;
			difficulty = 1;
		}
	);
	dprint("Khaos initialized.");
end
function Thottbot_CosmosInit()
	if(not Cosmos_RegisterConfiguration) then
		return;
	end

	Cosmos_RegisterConfiguration(
		"COS_THOTTBOT",
		"SECTION",
		"Thottbot",
		T_HEADER_HELP
		);
	Cosmos_RegisterConfiguration(
		"COS_THOTTBOT_HEADER",
		"SEPARATOR",
		"Thottbot",
		T_SECTION_DESC
		);
	Cosmos_RegisterConfiguration(
		"COS_THOTTBOT_PP",
		"CHECKBOX",
		T_PROFILE_TEXT,
		T_PROFILE_HELP..Thottbot_ProfileLink(),
		Thottbot_PlayerProfileEnable,
		0,
		1
		);
	Cosmos_RegisterConfiguration("COS_THOTTBOT_PT",
		"CHECKBOX",
		T_TARGET_PROFILE_TEXT,
		T_TARGET_PROFILE_HELP,
		Thottbot_TargetProfileEnable,
		0,
		1
		);
	Cosmos_RegisterConfiguration("COS_THOTTBOT_ON",
		"CHECKBOX",
		T_DATA_TEXT,
		T_DATA_HELP,
		Thottbot_Enable,
		0,
		1
		);
	Cosmos_RegisterConfiguration("COS_THOTTBOT_HY",
		"CHECKBOX",
		T_HEAVY_TEXT,
		T_HEAVY_HELP,
		Thottbot_HeavyEnable,
		0,
		1
		);
	Cosmos_RegisterConfiguration("COS_THOTTBOT_ST",
		"CHECKBOX",
		T_STATE_TEXT,
		T_STATE_HELP,
		Thottbot_StateEnable,
		1,
		1
		);

	dprint("Cosmos initialized.");
end
function Thottbot_RegisterCommands()
	local id	= "TSIZE";
	local comlist	= T_CMD_SIZE_COMLIST;
	local desc	= T_CMD_SIZE_HELP;
	local func = Thottbot_PrintSize;
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = comlist;
				onExecute = func;
				helpText = desc;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
	end

	local id	= "TSTATE";
	local comlist	= T_CMD_STATE_COMLIST;
	local desc	= T_CMD_STATE_HELP;
	local func = Thottbot_PrintState;
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = comlist;
				onExecute = func;
				helpText = desc;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
	end

	local id	= "TRESET";
	local comlist	= T_CMD_RESET_COMLIST;
	local desc	= T_CMD_RESET_HELP;
	local func = function()
		if(Thottbot.Loaded) then
			Thottbot_Reset();
			print1(T_RESET);
			Thottbot_PrintSize();
		else
			print1(T_DISABLED);
		end
	end
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = comlist;
				onExecute = func;
				helpText = desc;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
	end

	local id	= "TLOC";
	local comlist	= T_CMD_LOC_COMLIST;
	local desc	= T_CMD_LOC_HELP;
	local func = function(msg)
		if(Thottbot.Tloc and msg == "") then
			Thottbot.Tloc = false;
			ThottbotText:Hide();
			if(ThottbotLocationFrame) then
				ThottbotLocationFrame:Hide();
			end
		else
			Thottbot.Tloc = true;
			ThottbotText:Show();
			Chronos.everyFrame(Thottbot_Tloc);
			print1(T_CMD_LOC_MINIMAP);
			if(msg ~= "") then
				local i,j,x,y = string.find(msg,"(%d+),(%d+)");
				if(x and y) then
					Thottbot.Tlocx = x;
					Thottbot.Tlocy = y;
					dprint("x = ",Thottbot.Tlocx,", y = ",Thottbot.Tlocy);
					print1(T_CMD_LOC_ZONEMAP);
				else
					print1(T_CMD_LOC_USAGE);
				end
			else
				print1(T_CMD_LOC_NOTE);
			--	print1(T_CMD_LOC_NOTE2);
			end
		end
	end
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = comlist;
				onExecute = func;
				helpText = desc;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
	end

	local id	= "TPROFILE";
	local comlist	= T_CMD_PROFILE_COMLIST;
	local desc	= T_CMD_PROFILE_HELP;
	local func = function()
		Thottbot_Profile("player");
	end
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = comlist;
				onExecute = func;
				helpText = desc;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
	end

	local id	= "GCINFO";
	local comlist	= T_CMD_GCINFO_COMLIST;
	local desc	= T_CMD_GCINFO_HELP;
	local func = function()
		Thottbot_GCInfo();
	end
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = comlist;
				onExecute = func;
				helpText = desc;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
	end

	local id	= "TVER";
	local comlist	= T_CMD_VER_COMLIST;
	local desc	= T_CMD_VER_HELP;
	local func = function()
		print1(T_CMD_VER_VERSION, THOTTBOT_VERSION);
	end
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = comlist;
				onExecute = func;
				helpText = desc;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(comlist) do setglobal("SLASH_"..id..i, comlist[i]); end;
	end

	local id = "LANG";
	-- this really should be in some other addon
	local func = function(msg)
		local numLanguages = GetNumLaguages();
		local i;
		if(not msg or msg == "") then
			print1(T_LANGUAGE_HELP1);
			print1(T_LANGUAGE_HELP2);
			for i = 1, numLanguages, 1 do
				local language = GetLanguageByIndex(i);
				print1("- "..language);
			end
			return;
		end
		local numLanguages = GetNumLaguages();
		local i;
		for i = 1, numLanguages, 1 do
			local language = GetLanguageByIndex(i);
			if(strlower(language) == strlower(msg) or strlower(string.sub(language,1,string.len(msg))) == strlower(msg)) then
				ChatFrame1.editBox.language = language;
				print1(format(LANGUAGE_NOWSPEAK, language));
				return;
			end
		end
		print1(format(T_LANGUAGE_UNKNOWN, msg));
	end
	if (Sky) then
		Sky.registerSlashCommand(
			{
				id = id;
				commands = T_LANGUAGE_COMM;
				onExecute = func;
				helpText = T_LANGUAGE_COMM_INFO;
			}
		);
	else
		SlashCmdList[id] = func;
		for i=1, table.getn(T_LANGUAGE_COMM) do setglobal("SLASH_"..id..i, T_LANGUAGE_COMM[i]); end;
	end

	dprint("Commands registered.");
end
function Thottbot_GCInfo()
	if(Thottbot.GCInfo) then
		Thottbot.GCInfo = nil;
		ThottbotText:SetText("");
		ThottbotText:Hide();
		return;
	else
		Thottbot.GCInfo = {};
		for i=1, 4 do
			Thottbot.GCInfo[i] = 0;
		end
		Thottbot.GCInfo_lasti = 0;
		Thottbot.GCInfo_last = gcinfo();
		Chronos.everyFrame(Thottbot_GCInfo_Update);
	end
end
function Thottbot_GCInfo_Update()
	if(not Thottbot.GCInfo) then
		return true;
	end
	local current,threshold = gcinfo();
	local diff = current - Thottbot.GCInfo_last;
	if(diff < 0) then
		Thottbot.GCInfo_last = current;
		Thottbot.GCInfo_window = threshold - current;
		return;
	end
	Thottbot.GCInfo_last = current;
	local i = mod(floor(GetTime()),4)+1;
	if(i ~= Thottbot.GCInfo_lasti) then
		Thottbot.GCInfo[i] = 0;
		Thottbot.GCInfo_lasti = i;
	end
	Thottbot.GCInfo[i] = Thottbot.GCInfo[i] + diff;
	local avg = 0;
	for j=1,4 do
		if(j ~= i) then
			avg = avg + Thottbot.GCInfo[j];
		end
	end
	avg = avg / 3;

	local f;
	if(Thottbot.GCInfo_window and avg > 0) then
		f = format(T_CMD_GCINFO_FORMAT_WINDOW,current,threshold,diff,avg,Thottbot.GCInfo_window/avg);
	else
		f = format(T_CMD_GCINFO_FORMAT,current,threshold,diff,avg);
	end
	ThottbotText:SetText(f);
	ThottbotText:Show();
	return;
end
function TFixState(state)
	if(state == 1 or state == 0) then
		return state;
	end
	if(state.checked) then
		return 1;
	end
	return 0;
end
function Thottbot_PlayerProfileEnable(state)
	state = TFixState(state);
	if(state == 1 and not Thottbot.PlayerProfile) then
		if(not Thottbot.Loaded) then
			-- basic Thottbot capability required to gather profile
			-- don't collect any other data until Thottbot.IsOn is 1
			Thottbot_Load();
		end
		Thottbot.PlayerProfile = true;
		if(Thottbot.Running) then
			Chronos.scheduleByName("TProfile",0,Thottbot_Profile,"player");
			print1(T_PROFILE_TEXT1);
			print1(T_PROFILE_TEXT2);
			print1(T_PROFILE_TEXT3);
			print1( Thottbot_ProfileLink());
			Thottbot_PrintState();
		end
	elseif(state == 0 and Thottbot.PlayerProfile) then
		Thottbot.PlayerProfile = false;
		if(Thottbot.Running) then
			--print1(T_PROFILE_DISABLED);
			Thottbot_PrintState();
		end
	end
end
function Thottbot_TargetProfileEnable(state)
	state = TFixState(state);
	if(state == 1 and not Thottbot.TargetProfile) then
		if(not Thottbot.Loaded) then
			-- basic Thottbot capability required to gather profile
			-- no other data gets collected until Thottbot.IsOn is 1
			Thottbot_Load();
		end
		Thottbot.TargetProfile = true;
		if(Thottbot.Running) then
			--print1(T_TARGET_PROFILE_ENABLED);
			Thottbot_PrintState();
		end
	elseif(state == 0 and Thottbot.TargetProfile) then
		Thottbot.TargetProfile = false;
		if(Thottbot.Running) then
			--print1(T_TARGET_PROFILE_DISABLED);
			Thottbot_PrintState();
		end
	end
end
function Thottbot_HeavyEnable(state)
	state = TFixState(state);
	if(Thottbot.BadVersion) then
		return;
	end
	if(state == 1 and not Thottbot.Heavy) then
		--Thottbot_Enable(state);
		if(not Thottbot.Loaded) then
			Thottbot_Load();
		end
		Thottbot.Heavy = true;
		if(Thottbot.Running) then
			--print1(T_HEAVY_TEXT1);
			--print1(T_HEAVY_TEXT2);
			--print1(T_HEAVY_TEXT3);
			--print1(T_HEAVY_TEXT4);
			--print1(T_HEAVY_TEXT5);
			Thottbot_PrintState();
		end
	elseif(state == 0 and Thottbot.Heavy) then
		Thottbot.Heavy = false;
		if(Thottbot.Running) then
			Thottbot_PrintState();
		end
	end
end
function Thottbot_StateEnable(state)
	state = TFixState(state);
	if(state == 1 and Thottbot.NoState) then
		Thottbot.NoState = false;
		if(Thottbot.Running) then
			print1(T_STATE_ENABLED);
			Thottbot_PrintState();
		end
	elseif(state == 0 and not Thottbot.NoState) then
		Thottbot.NoState = true;
		if(Thottbot.Running) then
			print1(T_STATE_DISABLED);
		end
	end
end
function Thottbot_Enable(state)
	state = TFixState(state);
	if(Thottbot.BadVersion) then
		return;
	end
	if(state == 1 and not Thottbot.IsOn) then
		Thottbot.IsOn = true;
		if(not Thottbot.Loaded) then
			Thottbot_Load();
		end
		if(Thottbot.Running) then
			Thottbot_PrintState();
			--print1(T_ENABLED);
		end
	elseif(state == 0 and Thottbot.IsOn) then
		Thottbot.IsOn = false;
		--if(Thottbot.Heavy) then
			--SetCVar("COS_THOTTBOT_HY","0","COS_THOTTBOT_HY");
			--CosmosMaster_HandleCVarUpdate("COS_THOTTBOT_HY",state);
			--CosmosMaster_UpdateValue("COS_THOTTBOT_HY",CSM_CHECKONOFF,state);
			--CosmosMaster_NotifyAll();
			--CosmosMaster_DrawData();
		--end
		if(Thottbot.Running) then
			--print1(T_DISABLED);
			Thottbot_PrintState();
		end
	end
end
function Thottbot_PrintState()
	local state = {};
	state.n = 0;
	Sea.table.push(state,Thottbot_State(T_STATE_PROFILE,Thottbot.PlayerProfile));
	Sea.table.push(state,Thottbot_State(T_STATE_TARGET,Thottbot.TargetProfile));
	Sea.table.push(state,Thottbot_State(T_STATE_DATA,Thottbot.IsOn));
	Sea.table.push(state,Thottbot_State(T_STATE_HEAVY,Thottbot.Heavy));
	Sea.io.printc({r=1,g=1,b=1},"|cFF0000FFTHOTTB|r|cFFCFB53BO|r|cFF0000FFT|r: ",join(state,", "));
end
function Thottbot_State(name,state)
	if(state) then
		return name.." [|cFF00FF00On|r]";
	else
		return name.." [|cFF000000Off|r]";
	end
end
function Thottbot_OnLoad()
	Thottbot_RegisterCommands();
	if (Khaos) then
		Thottbot_KhaosInit();
	elseif (Cosmos_RegisterConfiguration) then
		Thottbot_CosmosInit();
	else
		Thottbot_Enable(1);
		Thottbot_HeavyEnable(1);
		Thottbot_PlayerProfileEnable(1);
	end
	Thottbot_Engine_OnLoad();
end

function racetype(race)
	if (race == T_RACE_HUMAN or
	    race == T_RACE_DWARF or
	    race == T_RACE_NELF or
	    race == T_RACE_GNOME) then
		return "A";
	elseif (race == T_RACE_UNDEAD or
		race == T_RACE_TAUREN or
		race == T_RACE_ORC or
		race == T_RACE_TROLL) then
		return "H";
	end

	-- Default Return Value
	return "?";
end
