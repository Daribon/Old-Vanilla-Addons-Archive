---------------------------------------------------------------------
-- Constants
---------------------------------------------------------------------

TIMERS_VERSION                      = 1.08;
TIMERS_POPUP                        = "TIMERS_MOB_NAME";
TIMERS_DEFAULT_SORT                 = { by="time", ascending=true };
TIMERS_DEFAULT_MINIMIZED            = true;
TIMERS_DEFAULT_MINIMIZED_POSITION   = { x = 250, y = 730 };
TIMERS_DEFAULT_MAXIMIZED_POSITION   = { x = 220, y = 650 };
TIMERS_DEFAULT_VISIBILE             = true;
TIMERS_DEFAULT_WARNING              = { time=0, channel="RAID" };
TIMERS_DEFAULT_TRIGGER_THRESHOLD    = 15;
TIMERS_DEFAULT_TRIGGER_LIST         = {
                                        ["dog"] =
                                        {
                                            time = 18,
                                            trigger = "Ancient Core Hound dies."
                                        },
                                        ["surger"] =
                                        {
                                            time = 27,
                                            trigger = "Lava Surger dies."
                                        },
                                        ["pack"] =
                                        {
                                            time = 60,
                                            trigger = "Core Hound collapses and begins to smolder."
                                        },
                                      };


---------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------

local state;
local popupType;
local lastTrigger;
local oldWindowState;

---------------------------------------------------------------------
-- Slash command functions
---------------------------------------------------------------------

function Timers_InitSlashCommands()
	SlashCmdList["TIMERCOMMANDS"] = Timers_SlashCommandHandler;
	SLASH_TIMERCOMMANDS1 = "/timer";
	SLASH_TIMERCOMMANDS2 = "/ti";
end

-- Ugly non-robust function to parse arguments.
function Timers_ParseArguments(msg)
	local args = {};
	local tmp = {};

	-- Find all space delimited words.
	for value in string.gfind(msg, "[^ ]+") do
		table.insert(tmp, value);
	end
	
	-- Make a pass through the table, and concatenate all words that have quotes.
	local quoteOpened = false;
	local quotedArg = "";
	for i = 1, table.getn(tmp) do
		if (string.find(tmp[i], "\"") == nil) then
			if (quoteOpened) then
				quotedArg = quotedArg.." "..string.gsub(tmp[i], "\"", "");
			else
				table.insert(args, tmp[i]);
			end
		else
			for value in string.gfind(tmp[i], "\"") do
				quoteOpened = not quoteOpened;
			end

			if (quoteOpened) then
				quotedArg = string.gsub(tmp[i], "\"", "");
			else
				if (string.len(quotedArg) > 0) then
					quotedArg = quotedArg.." "..string.gsub(tmp[i], "\"", "");
				else
					quotedArg = string.gsub(tmp[i], "\"", "");
				end
				
				table.insert(args, quotedArg);
				quotedArg = "";
			end
		end
	end
	
	if (string.len(quotedArg) > 0) then
		table.insert(args, quotedArg);
	end
	
	return args;
end

function Timers_SlashCommandHandler(msg)
	local command;
	local args;

	args = Timers_ParseArguments(msg);

	if (args[1] ~= nil) then
		command = string.lower(args[1]);
	end	

	if (command == "show") then
		TimersFrame_SetVisible(true);
	elseif (command == "help") then
		ShowUIPanel(TimersHelpFrame);
	elseif (command == "reset") then
		TimersFrame_ResetPositions();
	elseif (command == "warning") then
		TimersFrame_SetWarning(args[2], args[3]);
	elseif ((command == "add") and (args[2] ~= nil) and (args[3] ~= nil)) then
		TimerList_Add(args[2], args[3] * 60);
	elseif ((command == "spam") and (args[2] ~= nil)) then
		TimersFrame_SpamChannel(args[2], args[3]);
	elseif ((command == "list_triggers") and (args[2] == nil)) then
		TimerTriggers_Show();
	elseif ((command == "add_trigger") and (args[2] ~= nil) and (args[3] ~= nil)) then
		TimerTriggers_Add(args[2], args[3], args[4]);
	elseif (((command == "delete_trigger") or (command == "remove_trigger")) and (args[2] ~= nil)) then
		TimerTriggers_Remove(args[2]);
	elseif (command == "threshold") then
		TimerTriggers_SetThreshold(args[2]);
	else
		local commandFound = false;
	
		-- Look for trigger timer commands.
		for index, value in state.triggerList do
			if ((command == string.lower(index)) and (args[2] ~= nil)) then
				TimerList_Add(index.."_"..args[2], value.time * 60);
				commandFound = true;
				break;
			end
		end
	
		if (not commandFound) then
			Timers_Print("Version "..TIMERS_VERSION.." (Type \"/ti help\" to see a list of available commands)");
		end
	end

	TimersFrame_Update();
end

---------------------------------------------------------------------
-- TimersFrame functions
---------------------------------------------------------------------

function TimersFrame_OnLoad()
	TimersJustLoaded == 1;
	this:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	this:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 40);

	Timers_InitSlashCommands();

	Chronos.afterInit(TimersFrame_OnAfterInit);
end

function TimersFrame_OnAfterInit()
	local playerName = UnitName("player");

	TimersState = Timers_InitValue(TimersState, {});
	TimersState[playerName] = Timers_InitValue(TimersState[playerName], {});
	
	state = TimersState[playerName];

	state.warning = Timers_InitValue(state.warning, TIMERS_DEFAULT_WARNING);	
	state.sort = Timers_InitValue(state.sort, TIMERS_DEFAULT_SORT);
	state.minimized = Timers_InitValue(state.minimized, TIMERS_DEFAULT_MINIMIZED);
	state.minimizedPosition = Timers_InitValue(state.minimizedPosition, TIMERS_DEFAULT_MINIMIZED_POSITION);
	state.maximizedPosition = Timers_InitValue(state.maximizedPosition, TIMERS_DEFAULT_MAXIMIZED_POSITION);
	state.visible = Timers_InitValue(state.visible, TIMERS_DEFAULT_VISIBILE);
	state.triggerThreshold = Timers_InitValue(state.triggerThreshold, TIMERS_DEFAULT_TRIGGER_THRESHOLD);
	state.timerList = Timers_InitValue(state.timerList, {});
	state.triggerList = Timers_InitValue(state.triggerList, TIMERS_DEFAULT_TRIGGER_LIST);

	TimersFrame_UpdatePosition();
	TimersFrame_Update();
	TimersFrame_SetVisible(state.visible);

	lastTrigger = 0;

	Chronos.schedule(1, Timers_OnTick);
	
	TimersFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
	TimersFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");
	TimersFrame:RegisterEvent("CHAT_MSG_OFFICER");
end

function TimersFrame_OnEvent(event)
	if (StaticPopup_Visible(TIMERS_POPUP)) then
		return;
	end

	local text;

	if (event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
		text = arg1;
	elseif (event == "CHAT_MSG_MONSTER_EMOTE") then
		text = arg2.." "..arg1;
	end

	-- If the threshold has expired, search for any possible triggers.
	if ((text ~= nil) and TimerTriggers_IsThresholdExpired()) then
		for index, value in state.triggerList do
			if (value.trigger == text) then
				oldWindowState = state.minimized;
				TimersFrame_SetMinimized(false);
				popupType = index;
				StaticPopup_Show(TIMERS_POPUP);
				break;
			end
		end
	end
	
	if (event == "CHAT_MSG_OFFICER") then
		if (string.find(arg1, "show_time") ~= nil) then
			TimersFrame_SpamChannel("officer", nil);
		end
	end
end

function TimersFrame_OnMessageBoxAccept(name)
	TimerList_Add(popupType.."_"..name, state.triggerList[popupType].time * 60);
	lastTrigger = GetTime();
	TimersFrame_SetMinimized(oldWindowState);
end

function TimersFrame_SpamChannel(channel, name)
	local text;

	if (table.getn(state.timerList) == 0) then
		Timers_Print("The timer list is empty!");
		return;
	end

	if (name ~= nil) then
		local index = 0;
	
		for i = 1, table.getn(state.timerList) do
			if (string.lower(state.timerList[i].name) == string.lower(name)) then
				index = i;
				break;
			end
		end
		
		if (index ~= 0) then
			text = TimerList_ToString(index);
		else
			Timers_Print("A timer with the name \""..name.."\" could not be found!");
		end
	else
		text = TimerList_ToString(1);
		for i = 2, table.getn(state.timerList) do
			text = text.." "..TimerList_ToString(i);
		end
	end

	if (text ~= nil) then
		SendChatMessage(text, channel);
	end
end

function TimersFrame_SetWarning(time, channel)
	if (time ~= nil) then
		state.warning.time = tonumber(time);

		if (channel ~= nil) then
			state.warning.channel = channel;
		else
			state.warning.channel = TIMERS_DEFAULT_WARNING.channel;
		end
	end

	if (state.warning.time == 0) then
		Timers_Print("Warnings are currently disabled.");
	else
		local textTime = Timers_TimeToText(state.warning.time);
		Timers_Print("Warning is set to "..textTime.." to channel \""..state.warning.channel.."\"");
	end
end

function TimersFrame_SetVisible(visible)
	state.visible = visible;
	
	if (visible) then
		ShowUIPanel(TimersFrame);
	else
		HideUIPanel(TimersFrame);
		if( TimersJustLoaded == 1 ) then
			TimersJustLoaded = 0;
		else
			Timers_Print("Timers window was closed.  Type \"/ti show\" to make it visible again.");
		end
	end
end

function TimersFrame_OnMouseDown(arg1)
	if (arg1 == "LeftButton") then
		TimersFrame:StartMoving();
	end
end

function TimersFrame_OnMouseUp(arg1)
	if (arg1 == "LeftButton") then
		TimersFrame:StopMovingOrSizing();
		TimersFrame_SavePosition();
	end
end

function TimersFrame_SavePosition()
	if (state.minimized) then
		state.minimizedPosition = { x = TimersFrame:GetLeft(), y = TimersFrame:GetTop() };
	else
		state.maximizedPosition = { x = TimersFrame:GetLeft(), y = TimersFrame:GetTop() };
	end
end

function TimersFrame_UpdatePosition()
	TimersFrame:ClearAllPoints();
	
	if (state.minimized) then
		TimersFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", state.minimizedPosition.x, state.minimizedPosition.y);
	else
		TimersFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", state.maximizedPosition.x, state.maximizedPosition.y);
	end
end

function TimersFrame_ResetPositions()
	state.minimizedPosition = TIMERS_DEFAULT_MINIMIZED_POSITION;
	state.maximizedPosition = TIMERS_DEFAULT_MAXIMIZED_POSITION;
	TimersFrame_UpdatePosition();
	TimersFrame_SavePosition();
end

function TimersFrame_SetMinimized(minimized)
	TimersFrame_SavePosition();
	state.minimized = minimized;
	TimersFrame_UpdatePosition();
	TimersFrame_Update();
end

function TimersFrame_ResizeWindow()
	if (state.minimized) then
		TimersFrame:SetWidth(TimersFrameTitle:GetWidth() + 60);
		TimersFrame:SetHeight(TimersFrameTitle:GetHeight() + 12);
	else
		if (TimerListFrame:IsVisible()) then
			TimersFrame:SetWidth(274);
		else
			TimersFrame:SetWidth(256);
		end
		TimersFrame:SetHeight(216);
	end	
end

function TimersFrame_ToggleHelp()
	if (TimersHelpFrame:IsVisible()) then
		HideUIPanel(TimersHelpFrame);
	else
		ShowUIPanel(TimersHelpFrame);
	end
end

function TimersFrame_Warning(index)
	TimersFrame_SpamChannel(state.warning.channel, state.timerList[index].name);
	state.timerList[index].warned = true;
end

function TimersFrame_CheckTimers()
	local currentTime = GetTime();

	for i = 1, table.getn(state.timerList) do
		local timeLeft = state.timerList[i].endTime - currentTime;

		if ((timeLeft <= 0) and (not state.timerList[i].expired)) then
			TimersFrame_OnTimerExpired(i);
			state.timerList[i].expired = true;
		elseif ((state.warning.time ~= 0) and (timeLeft <= state.warning.time) and (not state.timerList[i].warned)) then
			TimersFrame_Warning(i);
		end
	end			
end

function TimersFrame_UpdateButtonVisibility()
	for i = 1, 5 do
		local itemIndex = i + FauxScrollFrame_GetOffset(TimerListFrame);
		TimerListButton_SetVisible(i, (not state.minimized) and (itemIndex <= table.getn(state.timerList)));
	end
end

function TimersFrame_UpdateFrameState()
	if (state.minimized) then
		TimerListFrame:Hide();
		TimersFrameNameSortButton:Hide();
		TimersFrameTimeLeftSortButton:Hide();
		TimersFrameMinimizeButton:Hide();
		TimersFrameMaximizeButton:Show();
		TimersFrameHelpButton:Hide();
	else
		TimerListFrame:Show();
		TimersFrameNameSortButton:Show();
		TimersFrameTimeLeftSortButton:Show();
		TimersFrameMinimizeButton:Show();
		TimersFrameMaximizeButton:Hide();
		TimersFrameHelpButton:Show();
	end

	TimersFrame_UpdateButtonVisibility()
end

function TimersFrame_UpdateButtonData()
	for i = 1, 5 do
		local itemIndex = i + FauxScrollFrame_GetOffset(TimerListFrame);
		
		if (itemIndex <= table.getn(state.timerList)) then
			local timeLeft = state.timerList[itemIndex].endTime - GetTime();

			TimerListButton_SetName(i, state.timerList[itemIndex].name);
			TimerListButton_SetTimeLeft(i, math.abs(timeLeft));
			
			if (timeLeft > 0) then
				TimerListButton_SetNameColor(i, 1.0, 0.8, 0.0);
				TimerListButton_SetTimeLeftColor(i, 1.0, 1.0, 1.0);
			else
				TimerListButton_SetNameColor(i, 1.0, 0.0, 0.0);
				TimerListButton_SetTimeLeftColor(i, 1.0, 0.0, 0.0);
			end
		end
	end
end

function TimersFrame_UpdateSortArrowVisibility()
	if (state.sort.by == "name") then
		TimersFrameNameSortButtonArrow:Show();
		TimersFrameTimeLeftSortButtonArrow:Hide();
	else
		TimersFrameNameSortButtonArrow:Hide();
		TimersFrameTimeLeftSortButtonArrow:Show();
	end
end

function TimersFrame_UpdateScrollbars()
	if (state.minimized) then
		FauxScrollFrame_Update(TimerListFrame, 0, 5, AUCTIONS_BUTTON_HEIGHT);
	else
		FauxScrollFrame_Update(TimerListFrame, table.getn(state.timerList), 5, AUCTIONS_BUTTON_HEIGHT);
	end
end

function TimersFrame_Update()
	if (state == nil) then
		return;
	end

	TimersFrame_UpdateFrameState();
	TimersFrame_UpdateButtonData();
	TimersFrame_UpdateScrollbars();
	TimersFrame_ResizeWindow();
	TimersFrame_UpdateSortArrowVisibility();

	TimersFrame_CheckTimers();
end

function TimersFrame_OnSortChanged(sortBy)
	if (state.sort.by == sortBy) then
		state.sort.ascending = not state.sort.ascending;
	end

	state.sort.by = sortBy;
	
	TimerList_Sort();
	
	TimersFrame_Update();
end

function TimersFrame_OnTimerExpired(index)
	UIErrorsFrame:AddMessage("The timer \""..state.timerList[index].name.."\" has expired!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	PlaySound("AuctionWindowOpen");
end

function Timers_OnTick()
	TimersFrame_Update();
	Chronos.schedule(1, Timers_OnTick);
end

---------------------------------------------------------------------
-- TimerButton functions
---------------------------------------------------------------------

function TimerListButton_OnRemove(id)
	TimerList_Remove(id + FauxScrollFrame_GetOffset(TimerListFrame));
	TimersFrame_Update();
end

function TimerListButton_OnReset(id)
	TimerList_Reset(id + FauxScrollFrame_GetOffset(TimerListFrame));
	TimersFrame_Update();

	-- If a trigger popup is displayed, hide it and restore the old window state.
	if (StaticPopup_Visible(TIMERS_POPUP)) then
		StaticPopup_Hide(TIMERS_POPUP);
		TimersFrame_SetMinimized(oldWindowState);
	end
end

function TimerListButton_SetVisible(index, visible)
	if (visible) then
		getglobal("TimerListButton"..index):Show();
	else
		getglobal("TimerListButton"..index):Hide();
	end
end

function TimerListButton_SetName(index, text)
	getglobal("TimerListButton"..index.."Name"):SetText(text);
end

function TimerListButton_SetNameColor(index, red, green, blue)
	getglobal("TimerListButton"..index.."Name"):SetVertexColor(red, green, blue);
end

function TimerListButton_SetTimeLeft(index, time)
	getglobal("TimerListButton"..index.."TimeLeft"):SetText(Timers_TimeToText(time));
end

function TimerListButton_SetTimeLeftColor(index, red, green, blue)
	getglobal("TimerListButton"..index.."TimeLeft"):SetVertexColor(red, green, blue);
end

---------------------------------------------------------------------
-- Timer List functions
---------------------------------------------------------------------

function TimerList_Add(name, time)
	table.insert(state.timerList, { name=name, time=time, endTime=time + GetTime(), expired=false, warned=false });
	TimerList_Sort();
end

function TimerList_Remove(index)
	table.remove(state.timerList, index);
end

function TimerList_Reset(index)
	state.timerList[index].endTime = state.timerList[index].time + GetTime();
end

function TimerList_SortCompare(item1, item2)
	if (state.sort.by == "name") then
		if (state.sort.ascending) then
			return item1.name < item2.name;
		else
			return item1.name > item2.name;
		end
	else
		if (state.sort.ascending) then
			return item1.endTime < item2.endTime;
		else
			return item1.endTime > item2.endTime;
		end
	end
end

function TimerList_Sort()
	table.sort(state.timerList, TimerList_SortCompare);
end

function TimerList_ToString(index)
	return "["..state.timerList[index].name.." "..Timers_TimeToText(state.timerList[index].endTime - GetTime()).."]";
end

---------------------------------------------------------------------
-- Trigger functions
---------------------------------------------------------------------

function TimerTriggers_Show()
	Timers_Print("Triggers");

	for index, value in state.triggerList do
		if (value.trigger == nil) then
			Timers_Print(" \""..index.."\", "..value.time..", <no trigger>");
		else
			Timers_Print(" \""..index.."\", "..value.time..", \""..value.trigger.."\"");
		end
	end
end

function TimerTriggers_Add(name, time, trigger)
	name = string.lower(name);

	if (state.triggerList[name] == nil) then
		state.triggerList[name] = {};
		state.triggerList[name].time = time;
		state.triggerList[name].trigger = trigger;
		Timers_Print("A new trigger has been added for \""..name.."\".");
	else
		Timers_Print("A trigger called \""..name.."\" already exists!");
	end
end

function TimerTriggers_Remove(name)
	name = string.lower(name);

	if (state.triggerList[name] ~= nil) then
		state.triggerList[name] = nil;
		Timers_Print("Trigger \""..name.."\" has been removed.");
	else
		Timers_Print("A trigger by the name of \""..name.."\" doesn't exists!");
	end
end

function TimerTriggers_SetThreshold(threshold)
	if (threshold ~= nil) then
		state.triggerThreshold = tonumber(threshold);
	end

	Timers_Print("Trigger threshold is "..state.triggerThreshold.." seconds.");
end

function TimerTriggers_IsThresholdExpired()
	return (GetTime() - lastTrigger) > state.triggerThreshold;
end

---------------------------------------------------------------------
-- Misc functions
---------------------------------------------------------------------

function Timers_InitValue(value, default)
	if (value == nil) then
		value = default;
	end
	
	return value;
end

function Timers_Print(text)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00[Timers]: "..text.."|r");
end

function Timers_TimeToText(time)
	local TIME_FORMAT = "%02d:%02d:%02d";
	local absTime = math.abs(time);

	local hours = absTime / 3600;
	local minutes = math.mod(absTime / 60, 60);
	local seconds = math.mod(absTime, 60);

	if (time >= 0) then
		return format(TIME_FORMAT, hours, minutes, seconds);
	else
		return format("-"..TIME_FORMAT, hours, minutes, seconds);
	end
end

---------------------------------------------------------------------
-- StaticPopup definition
---------------------------------------------------------------------

StaticPopupDialogs[TIMERS_POPUP] = {
	text = "Enter a timer name for this mob.",
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = 1,
	maxLetters = 12,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		TimersFrame_OnMessageBoxAccept(editBox:GetText());
	end,
	OnShow = function()
		getglobal(this:GetName().."EditBox"):SetFocus();
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetFocus();
		end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		TimersFrame_OnMessageBoxAccept(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function()
		this:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1
};

---------------------------------------------------------------------
-- TimersHelpFrame functions
---------------------------------------------------------------------

function TimersHelpFrame_OnLoad()
	local text = "";

	text = text.."|cFFFF7F00Usage|r:\n";
	text = text.."/ti |cFFFF5555command|r <|cFF55FF55parameter|r> [|cFF5555FFoptional|r]\n\n";

	text = text.."|cFFFF5555show|r\n";
	text = text.."Displays the Timers frame.\n\n";

	text = text.."|cFFFF5555reset|r\n";
	text = text.."Resets the position of the frames.\n\n";

	text = text.."|cFFFF5555add|r <|cFF55FF55name|r> <|cFF55FF55time|r>\n";
	text = text.."Adds a new timer with the specified name and time (in minutes).\n\n";
	
	text = text.."|cFFFF5555spam|r <|cFF55FF55channel|r> [|cFF5555FFname|r]\n";
	text = text.."Spams the specified channel (raid, officer, ect.) once with the current\n";
	text = text.."timers. If a name is specified, then only that timer will be spammed.\n\n";

	text = text.."|cFFFF5555warning|r [|cFF5555FFtime|r] [|cFF5555FFchannel|r]\n";
	text = text.."Sets the automatic spamming.  If the time is 0, then warnings\n";
	text = text.."are disabled.\n\n";

	text = text.."|cFFFF5555list_triggers|r\n";
	text = text.."Lists all triggers.\n\n";

	text = text.."|cFFFF5555add_trigger|r <|cFF55FF55name|r> <|cFF55FF55time|r> [|cFF5555FFtrigger|r]\n";
	text = text.."Adds a new trigger.\n\n";

	text = text.."|cFFFF5555delete_trigger|r <|cFF55FF55name|r>\n";
	text = text.."Deletes a trigger\n\n";

	text = text.."|cFFFF5555threshold|r <|cFF55FF55time|r>\n";
	text = text.."Sets a threshold for triggers (in seconds).\n\n\n";

	text = text.."|cFFFF7F00About triggers|r:\n";
	text = text.."A trigger can be manually invoked by typing \"/ti <trigger> <name>\"\n\n";

	text = text.."For example, the following would manually invoke a trigger called\n";
	text = text.."\"dog\" with the name \"1\"\n\n";

	text = text.." /ti dog 1\n\n\n";

	text = text.."|cFFFF7F00Note|r:\n";
	text = text.."For strings which contain spaces, they must be enclosed in double\n";
	text = text.."quotes.\n\n";

	text = text.."For example,\n\n";

	text = text.." /ti add \"Two words\" 15\n\n";
	
	TimersHelpFrameText:SetText(text);
end
