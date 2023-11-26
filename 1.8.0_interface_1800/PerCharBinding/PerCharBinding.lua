local _DEBUG = false;
local charServer = nil;
local charName = nil;
local charProfileName = nil;
local updatesToSkip = 0;
local pewFired = nil;

-- some local utility stuff
local function Print(msg)
	if (not msg) then return; end
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg,1.0,1.0,1.0);
	end
end
local function Debug(msg)
	if (not _DEBUG) then return; end
	if (not msg) then return; end
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("PCB: "..GetTime()..": "..msg,1.0,0.0,0.0);
	end
end
local function Error(msg)
	if (not msg) then return; end
	UIErrorsFrame:AddMessage(msg, 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
end

--[[-----------------------------------------------------------------------
-- Fires when addon is loaded                                            --
-------------------------------------------------------------------------]]
function PCB_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("UPDATE_BINDINGS")
	this:RegisterEvent("PLAYER_ENTERING_WORLD")

	SLASH_PCB_COMMAND1 = "/percharbinding";
	SLASH_PCB_COMMAND2 = "/pcb";
	SlashCmdList["PCB_COMMAND"] = PCB_CommandHandler;
end

function PCB_DeleteSavedBindings(profName, verbose)

	if (not profName) then return; end
	if (not PCB_Data[profName]) then return; end
	Debug("DeleteSavedBindings("..profName..")");

	local workingProf = PCB_Data[profName];
	local keyName;
	for keyName, _ in pairs(workingProf) do
		workingProf[keyName] = nil;
	end
	
	workingProf = nil;
	PCB_Data[profName] = nil;

	if (verbose) then
		Print(string.format(PCB_OUT_PROFILE_DELETE, profName));
	end
	
end

function PCB_SaveCurrentBindings(profName, verbose)

	if (not profName) then return; end
	Debug("SaveCurrentBindings("..profName..")");

	PCB_Data[profName] = PCB_Data[profName] or {};
	local workingProf = PCB_Data[profName];
	local numBindings = GetNumBindings();
	local i, j, curBind, numKeys;
	for i=1, numBindings do
		curBind = {GetBinding(i)};
		numKeys = table.getn(curBind);
		for j=2, numKeys do
			workingProf[curBind[1]] = workingProf[curBind[1]] or {};
			table.insert(workingProf[curBind[1]], curBind[j]);
		end
	end

	if (verbose) then
		Print(string.format(PCB_OUT_PROFILE_SAVE, profName));
	end
	
end

function PCB_ApplySavedBindings(profName, verbose)

	if (not profName) then return; end
	Debug("ApplySavedBindings("..profName..")");

	if (not PCB_Data[profName]) then
		Debug("Profile, "..profName..", not found.");
		if (verbose) then
			Print(string.format(PCB_OUT_PROFILE_NOTFOUND, profName));
		end
		return;
	end

	local workingProf = PCB_Data[profName];
	local numBindings = GetNumBindings();
	local i, j, curBind, numKeys;
	for i=1, numBindings do
		curBind = {GetBinding(i)};
		numKeys = table.getn(curBind);
		-- clear out any existing keys for this command
		for j=2, numKeys do
			SetBinding(curBind[j]);
		end
		if (workingProf[curBind[1]]) then
			-- now set the bindings we have saved
			for j=1, table.getn(workingProf[curBind[1]]) do
				SetBinding(workingProf[curBind[1]][j], curBind[1]);
			end
		end
	end
	
	-- persist the changes to disk
	updatesToSkip = updatesToSkip + 1;
	SaveBindings();
	
	if (verbose) then
		Print(string.format(PCB_OUT_PROFILE_LOAD, profName));
	end
	
end

function PCB_ListProfiles()

	Print(PCB_OUT_LIST_HEADER);
	local profName;
	local list = {};
	-- put all the profile names in a list to be sorted
	for profName, _ in pairs(PCB_Data) do
		table.insert(list, profName);
	end
	-- sort the list
	table.sort(list);
	-- write them out in order
	for _, profName in ipairs(list) do
		Print("   "..profName);
	end
	Print(string.format(PCB_OUT_LIST_TOTAL, table.getn(list)));

end


--[[
	As of 1.6.0 patch, the order of events when logging in seem to be:
	- VARIABLES_LOADED
	- UPDATE_BINDINGS
	- PLAYER_ENTERING_WORLD
	After a UI reload, they are:
	- UPDATE_BINDINGS
	- VARIABLES_LOADED
	- PLAYER_ENTERING_WORLD
]]
function PCB_OnEvent(event, arg1, arg2, arg3)

	if (event == "VARIABLES_LOADED") then

		-- build the profile name
		charName, charServer = UnitName("player"), GetCVar("RealmName");
		charProfileName = charName.." of "..charServer;

		-- initialize our binding storage table
		PCB_Data = PCB_Data or {};
		-- get the global settings
		PCB_Settings = PCB_Settings or {};

	elseif (event == "UPDATE_BINDINGS") then

		if (updatesToSkip > 0) then
			Debug("Skipping the binding update event we generated.");
			updatesToSkip = updatesToSkip - 1;
		elseif (pewFired) then
			if (arg1) then
				Debug("Bindings updated externally with arg1 = "..arg1);
			else
				Debug("Bindings updated externally");
			end
			PCB_DeleteSavedBindings(charProfileName);
			PCB_SaveCurrentBindings(charProfileName);
			if (PCB_Settings["verbose"]) then
				Print(string.format(PCB_OUT_UPDATED, charProfileName));
			end
		else
			if (arg1) then
				Debug("UPDATE BINDINGS with arg1 = "..arg1);
			else
				Debug("UPDATE BINDINGS");
			end
		end

	elseif (event == "PLAYER_ENTERING_WORLD") then

		if (not pewFired) then
			pewFired = true;

			-- If we have an empty profile, fill it with the current bindings
			if (not PCB_Data[charProfileName]) then 
				Debug("New character profile, "..charProfileName);
				PCB_SaveCurrentBindings(charProfileName); 
			end

			-- Apply the saved bindings for this profile
			PCB_ApplySavedBindings(charProfileName);
		end

    end
end

function PCB_ImportExternalKeySets()
	if (ClassBinding_Bindings) then
		local sStart, sEnd, nStart, nEnd;
		local cbServer = nil;
		local cbName = nil;
		local numImports = 0;
		local workingProf = nil;
		for cbProfName, cbProf in pairs(ClassBinding_Bindings) do

			sStart = string.find(cbProfName, "@", 1, true);
			nStart = string.find(cbProfName, ":", 1, true);

			if (sStart and not nStart) then
				-- if we found a @ and didn't find a colon,
				-- it's an "old format" name with no server
				cbName = string.sub(cbProfName, 2);
				cbServer = nil;
			elseif (sStart and nStart) then
				-- if we found both, it's a @Server:Name format
				cbName = string.sub(cbProfName, nStart+1);
				cbServer = string.sub(cbProfName, 2, nStart-1);
				-- Put back any space characters that were stripped out for underscores
				cbServer = string.gsub(cbServer, "_", " ")
			end

			if (cbName and cbServer) then
				-- import it to our format
				Print(string.format(PCB_OUT_IMPORTING, (cbName.." of "..cbServer)));
				numImports = numImports + 1;

				PCB_DeleteSavedBindings(cbName.." of "..cbServer);
				PCB_Data[cbName.." of "..cbServer] = {}
				
				workingProf = PCB_Data[cbName.." of "..cbServer];
				for cmd, keys in pairs(cbProf) do
					for _, key in pairs(keys) do
						workingProf[cmd] = workingProf[cmd] or {};
						table.insert(workingProf[cmd], key);
					end
				end
			end

		end

		if (numImports < 1) then
			Print(PCB_OUT_IMPORT_NONE);
		else
			Print(PCB_OUT_IMPORT_OK);
		end
	else
		Print(PCB_OUT_IMPORT_FAIL);
	end
end

function PCB_GetProfileNameFromArgs(args)
	if (not args or not args[2]) then return ""; end
	local i=0;
	local catProfile = args[2];
	for i=3, table.getn(args) do
		catProfile = catProfile.." "..args[i];
	end
	return catProfile;
end

--[[-----------------------------------------------------------------------
-- Slash command handler                                                 --
-------------------------------------------------------------------------]]
function PCB_CommandHandler(msg)
	if (not msg) then return; end
	local args = {};
	for arg in string.gfind(msg, "([%w]+)") do
		table.insert(args, arg);
	end
	if (args[1] and args[1] == PCB_CMD_SAVE) then
		PCB_SaveCurrentBindings(PCB_GetProfileNameFromArgs(args), true);
	elseif (args[1] and args[1] == PCB_CMD_LOAD) then
		PCB_ApplySavedBindings(PCB_GetProfileNameFromArgs(args), true);
	elseif (args[1] and args[1] == PCB_CMD_DELETE) then
		PCB_DeleteSavedBindings(PCB_GetProfileNameFromArgs(args), true);
	elseif (args[1] and args[1] == PCB_CMD_LIST) then
		PCB_ListProfiles();
	elseif (args[1] and args[1] == PCB_CMD_IMPORT) then
		PCB_ImportExternalKeySets();
	elseif (args[1] and args[1] == PCB_CMD_VERBOSE) then
		PCB_ToggleVerbose();
	elseif (args[1] and args[1] == "debug") then
		PCB_ToggleDebug();
	else
		for _, value in PCB_COMMAND_HELP do
			Print(value);
		end
	end
end

function PCB_ToggleVerbose()
	if (PCB_Settings["verbose"]) then
		PCB_Settings["verbose"] = nil;
		Print(PCB_OUT_VERBOSE_OFF);
	else
		PCB_Settings["verbose"] = 1;
		Print(PCB_OUT_VERBOSE_ON);
	end
end

function PCB_ToggleDebug()
	_DEBUG = not _DEBUG;
	if (_DEBUG) then
		Print("Debug output is now on.");
	else
		Print("Debug output is now off.");
	end
end

