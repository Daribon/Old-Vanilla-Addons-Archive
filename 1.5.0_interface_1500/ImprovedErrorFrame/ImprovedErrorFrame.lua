--------------------------------------------------------------------------
-- ImprovedErrorFrame.lua 
--------------------------------------------------------------------------
--[[

Original ImprovedErrorFrame - Vjeux
ImprovedErrorFrame without FrameXML - AnduinLothar

ImprovedErrorFrame v2 - Sinaloit
	- Now adds a minimap button when errors are present, no more windows
	  popping up every time you get an error. Click the button to view
	  the errors.
Icons provided by Moonfire

v2.0
- Restructured code
- Error messages now reveal an error button rather than a popup on occurance
  clicking on button shows frame with error messages
- Error button flashes when shown, hidden if no bugs
- Error button is mobile, orbits the Minimap
	Shift-Left Click to drag, Shift-Right Click to reset

v2.1
- Added Report button back, only shows up if ImprovedErrorFrame.displayReportButton = true
  Set this value if you want to be able to have people report errors
- Added ImprovedErrorFrame_Report_OnClick() to be hooked by any AddOn that wants to know
  when the Report button was clicked, passes ImprovedErrorFrame.errorMessageList
- Added slash command (/ief) to allow user to choose frame or button appearing on error


v2.2
- Added IMPROVEDERRORFRAME_REV variable
- AddOn names/files are now stored in the errorMessageList
- Added ability to turn off blinking on notification icon
- Changed blinking to simply turning off/on highlight
- Added localization strings
- Streamlined the code a little
- Uses Sky for slashCommand registration if present else default method

v2.3
- Added Khoas/Cosmos Registration if present
- Added tooltip to ErrorButton
- Added option to display count of errors
- Added option to always have ErrorButton present (button is disabled if no messages)
- Added sound when 1st error notification occurs
- Added option to disable sound

v2.4
- Fixed Cosmos Registration
- Added line and parsedErr to errorList
- Fixed some state errors with toggles
- Khaos Registration now working correctly

v2.5
- Fixed Always show to always show, even after camping when not using Cosmos/Khaos
- Removed extraneous calls to ImprovedErrorFrame.change<blah> in Khaos commands
- changeBlink/Count functions now are aware of button being disabled

v2.6
- Fixed file pattern match to work on files with more than 1 period
- Renamed ping.mp3 to ErrorSound.mp3 for more clarity
- Fixed string.find in IEFSetOptions to work with 1 word commands

v2.7
- Changed Bug Count to Red
- Fixed error sound for each error if minimap was open.
- Instead of rescheduling IEFNotify every time checks if present 1st
- Always shown button now enables properly when error occurs

v2.8
- Added depedencies to Khaos Registration
- Changed Report button to hide IEFF before calling OnClick, now hook order doesn't matter
- Added a header to the IEFF so that its more obvious what it is
- Resolved issue with multiple sounds from getting same error repeatedly as only error
- Rechecked code and made compliant with new errorButtonActive setting

$Id: ImprovedErrorFrame.lua 1506 2005-05-17 01:27:49Z Sinaloit $
$Rev: 1506 $
$LastChangedBy: Sinaloit $
$Date: 2005-05-16 20:27:49 -0500 (Mon, 16 May 2005) $
]]--

-- Revision tag
IMPROVEDERRORFRAME_REV = "$Rev: 1506 $";

-- ImprovedErrorFrame Defines
local IEF_ERROR_MESSAGE_PAGE_MAX = 10;
local IEF_ERROR_MESSAGE_MAX = 999;
local IEF_ERROR_MESSAGE_INFINITE = 20;
local IEF_BLINK_DELAY  = 2;
IEF_MSG_NEW      = 0; -- Message added, not scheduled to be shown yet
IEF_MSG_SHOWN    = 1; -- Message scheduled to be seen by user
IEF_MSG_VIEWED   = 2; -- Message was viewed by user

ImprovedErrorSettings = {
	-- Show error when it occurs
	displayOnError = false;
	-- To Blink or not to Blink
	blinkNotification = true;
	-- Display count of errors
	displayCount = true;
	-- Display even when no errors pending
	alwaysShow = false;
	-- Prevent sound from playing when error occurs
	gagNoise = false;
};

ImprovedErrorFrame = {
	-- Current Error Message
	messagePrint = "";

	--[[
	--	List of all current Errors, both viewed and unviewed
	--
	--	Table Structure:
	--		.err		= error message
	--		.count		= number of occurances
	--		.status		= IEF_MSG_NEW or IEF_MSG_SHOWN or IEF_MSG_VIEWED
	--		.AddOn		= name of addon that generated the error
	--		.fileName	= file name error occured in
	--		.line		= line number error occured on
	--		.parsedErr	= Just the error message no file/line number
	--		.errDate	= date/time error occured
	--		.reported	= error has been reported
	--]]
	errorMessageList = { };
	-- Display the report button, set by some other AddOn
	displayReportButton = false;
	-- Indicates if errorButton is active
	errorButtonActive = false;

	-- Previous function handlers
	oldFuncs = {
		oldERRORMESSAGE = _ERRORMESSAGE;
		oldMessage = message;
	};

	-- Error reporting function, this loads before Sea so we have to have our own.
	Print = function(msg, r, g, b, frame)
		if (not r) then r = 1.0; end
		if (not g) then g = 1.0; end
		if (not b) then b = 1.0; end
		if (frame) then
			frame:AddMessage(msg, r, g, b);
		else
			if ( DEFAULT_CHAT_FRAME ) then
				DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
			end
		end
	end;

	-- Replaces old error handling functions and adds the Frame to the UI Panel list
	enable = function()
		_ERRORMESSAGE = ImprovedErrorFrame.newErrorMessage;
		message = ImprovedErrorFrame.newErrorMessage;
		UIPanelWindows["ImprovedErrorFrameFrame"] = { area = "center", pushable = 0 }; -- Allows the frame to be closed by Escape
	end;

	-- Returns error handling functions to original and removes Frame from UI Panel List
	disable = function()
		_ERRORMESSAGE = ImprovedErrorFrame.oldFuncs.oldERRORMESSAGE;
		message = ImprovedErrorFrame.oldFuncs.oldMessage;
		UIPanelWindows["ImprovedErrorFrameFrame"] = nil;
	end;	

	-- Slash command handler
	IEFSetOptions = function(msg)
		msg = string.lower(msg);
		local change = false;
		local _, _, option, setting = string.find(msg, "(%w+) *(%w*)");
		if (option == IEF_NOTIFY_OPT) then
			if (setting == IEF_ON) then
				ImprovedErrorSettings.displayOnError = false;
			elseif (setting == IEF_OFF) then
				ImprovedErrorSettings.displayOnError = true;
			else
				ImprovedErrorSettings.displayOnError = not ImprovedErrorSettings.displayOnError;
			end
			if (ImprovedErrorSettings.displayOnError) then
				ImprovedErrorFrame.Print(IEF_NOTIFY_OFF);
			else
				ImprovedErrorFrame.Print(IEF_NOTIFY_ON);
			end
			change = true;
		elseif (Chronos and (option == IEF_BLINK_OPT)) then
			if (setting == IEF_ON) then
				ImprovedErrorSettings.blinkNotification = true;
			elseif (setting == IEF_OFF) then
				ImprovedErrorSettings.blinkNotification = false;
			else
				ImprovedErrorSettings.blinkNotification = not ImprovedErrorSettings.blinkNotification;
			end
			if (ImprovedErrorSettings.blinkNotification) then
				ImprovedErrorFrame.Print(IEF_BLINK_ON);
			else
				ImprovedErrorFrame.Print(IEF_BLINK_OFF);
			end
			ImprovedErrorFrame.changeBlink();
			change = true;
		elseif (option == IEF_COUNT_OPT) then
			if (setting == IEF_ON) then
				ImprovedErrorSettings.displayCount = true;
			elseif (setting == IEF_OFF) then
				ImprovedErrorSettings.displayCount = false;
			else
				ImprovedErrorSettings.displayCount = not ImprovedErrorSettings.displayCount;
			end
			if (ImprovedErrorSettings.displayCount) then
				ImprovedErrorFrame.Print(IEF_COUNT_ON);
			else
				ImprovedErrorFrame.Print(IEF_COUNT_OFF);
			end
			ImprovedErrorFrame.changeCount();
			change = true;
		elseif (option == IEF_ALWAYS_OPT) then
			if (setting == IEF_ON) then
				ImprovedErrorSettings.alwaysShow = true;
			elseif (setting == IEF_OFF) then
				ImprovedErrorSettings.alwaysShow = false;
			else
				ImprovedErrorSettings.alwaysShow = not ImprovedErrorSettings.alwaysShow;
			end
			if (ImprovedErrorSettings.alwaysShow) then
				ImprovedErrorFrame.Print(IEF_ALWAYS_ON);
			else
				ImprovedErrorFrame.Print(IEF_ALWAYS_OFF);
			end
			ImprovedErrorFrame.changeAlways();
			change = true;
		elseif (option == IEF_SOUND_OPT) then
			if (setting == IEF_ON) then
				ImprovedErrorSettings.gagNoise = false;
			elseif (setting == IEF_OFF) then
				ImprovedErrorSettings.gagNoise = true;
			else
				ImprovedErrorSettings.gagNoise = not ImprovedErrorSettings.gagNoise;
			end
			if (ImprovedErrorSettings.gagNoise) then
				ImprovedErrorFrame.Print(IEF_SOUND_OFF);
			else
				ImprovedErrorFrame.Print(IEF_SOUND_ON);
			end
			change = true;
		end
		if (change) then
			ImprovedErrorFrame.syncCosmosToVars();
			return;
		end
		ImprovedErrorFrame.displayOptions();
	end;

	-- Starts/stops blinking if needed based on blinkNotification value
	changeBlink = function(msg)
		if (ImprovedErrorSettings.blinkNotification and IEFMinimapButton:IsVisible()) then
			if (ImprovedErrorFrame.errorButtonActive) then
				if (not Chronos.isScheduledByName("IEFNotify")) then
					Chronos.scheduleByName("IEFNotify", IEF_BLINK_DELAY, ImprovedErrorFrame.buttonFlash, true);
				end
			end
		else
			Chronos.unscheduleByName("IEFNotify");
			IEFMinimapButton:UnlockHighlight();
		end
	end;

	-- Shows number on the button if it should be based on displayCount value
	changeCount = function(msg)
		if (ImprovedErrorSettings.displayCount and IEFMinimapButton:IsVisible()) then
			if (ImprovedErrorFrame.errorButtonActive) then
				IEFMinimapButton:SetText(ImprovedErrorFrame.countErrors());
			end
		else
			IEFMinimapButton:SetText("");
		end
	end;

	-- Makes appropriate changes based on the alwaysShow value
	changeAlways = function(msg)
		if (ImprovedErrorSettings.alwaysShow) then
			if (not IEFMinimapButton:IsVisible()) then
				IEFMinimapButton:Show();
				IEFMinimapButton:Disable();
			end
		else
			if (IEFMinimapButton:IsVisible() and not ImprovedErrorFrame.errorButtonActive) then
				IEFMinimapButton:Enable();
				IEFMinimapButton:Hide();
			end
		end
	end;

	-- Print Format String and current settings
	displayOptions = function()
		if (Chronos) then
			ImprovedErrorFrame.Print(IEF_FORMAT_STR);
		else
			ImprovedErrorFrame.Print(IEF_FORMAT_STR_NOCHRON);
		end
		ImprovedErrorFrame.Print(IEF_CURRENT_SETTINGS);
		if (ImprovedErrorSettings.displayOnError) then
			ImprovedErrorFrame.Print("    "..IEF_NOTIFY_OFF);
		else
			ImprovedErrorFrame.Print("    "..IEF_NOTIFY_ON);
		end
		if (Chronos) then
			if (ImprovedErrorSettings.blinkNotification) then
				ImprovedErrorFrame.Print("    "..IEF_BLINK_ON);
			else
				ImprovedErrorFrame.Print("    "..IEF_BLINK_OFF);
			end
		end
		if (ImprovedErrorSettings.displayCount) then
			ImprovedErrorFrame.Print("    "..IEF_COUNT_ON);
		else
			ImprovedErrorFrame.Print("    "..IEF_COUNT_OFF);
		end
		if (ImprovedErrorSettings.alwaysShow) then
			ImprovedErrorFrame.Print("    "..IEF_ALWAYS_ON);
		else
			ImprovedErrorFrame.Print("    "..IEF_ALWAYS_OFF);
		end
		if (ImprovedErrorSettings.gagNoise) then
			ImprovedErrorFrame.Print("    "..IEF_SOUND_OFF);
		else
			ImprovedErrorFrame.Print("    "..IEF_SOUND_ON);
		end
	end;

	-- Ran when AddOn starts
	onLoad = function()
		-- Convert Revision into a number
		convertRev("IMPROVEDERRORFRAME_REV");

		-- Perform onLoad tasks
		ImprovedErrorFrame.enable();
		this:RegisterEvent("VARIABLES_LOADED");
	end;

	-- Event handler function
	onEvent = function(event)
		if (event == "VARIABLES_LOADED") then
			if (Khaos) then
				ImprovedErrorFrame.KhaosRegister();
			else
				if (Cosmos_RegisterConfiguration) then
					ImprovedErrorFrame.CosmosRegister();
				end
				if (Sky) then
					Sky.registerSlashCommand(
						{
							id = "ImprovedErrorFrameCommand";
							commands = { "/ief" };
							onExecute = ImprovedErrorFrame.IEFSetOptions;
							helpText = IEF_HELP_TEXT;
						}
					);
				else
					SlashCmdList["IEFRAME"] = ImprovedErrorFrame.IEFSetOptions;
					SLASH_IEFRAME1 = "/ief";
				end
			end
			if (ImprovedErrorSettings.alwaysShow) then
				if (not IEFMinimapButton:IsVisible()) then
					IEFMinimapButton:Show();
					IEFMinimapButton:Disable();
				end
			end
		end
	end;

	-- Register Option set w/ Khaos
	KhaosRegister = function()
		Khaos.registerOptionSet("debug",
			{
				id = "ImprovedErrorFrame";
				text = IEF_OPTION_TEXT;
				helptext = IEF_OPTION_HELP;
				difficulty = 1;
				default = true;
				options = {
					{
						id = "IEFHeader";
						text = IEF_HEADER_TEXT;
						helptext = IEF_HEADER_HELP;
						type = K_HEADER;
						difficulty = 1;
					};
					{
						id = "IEFNotification";
						text = IEF_NOTIFY_TEXT;
						helptext = IEF_NOTIFY_HELP;
						type = K_TEXT;
						value = true;
						check = true;
						difficulty = 4;
						callback = function(state)
							ImprovedErrorSettings.displayOnError = not state.checked;
						end;
						feedback = function(state)
							if (state.checked) then
								return IEF_NOTIFY_OFF;
							else
								return IEF_NOTIFY_ON;
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
						id = "IEFBlink";
						text = IEF_BLINK_TEXT;
						helptext = IEF_BLINK_HELP;
						type = K_TEXT;
						value = true;
						check = true;
						difficulty = 1;
						callback = function(state)
							ImprovedErrorSettings.blinkNotification = state.checked;
							ImprovedErrorFrame.changeBlink();
						end;
						feedback = function(state)
							if (state.checked) then
								return IEF_BLINK_ON;
							else
								return IEF_BLINK_OFF;
							end
						end;
						default = {
							checked = true;
						};
						disabled = {
							checked = false;
						};
						dependencies = {
							["IEFNotification"] = { checked = true };
						};
					};
					{
						id = "IEFCount";
						text = IEF_COUNT_TEXT;
						helptext = IEF_COUNT_HELP;
						type = K_TEXT;
						value = true;
						check = true;
						difficulty = 1;
						callback = function(state)
							ImprovedErrorSettings.displayCount = state.checked;
							ImprovedErrorFrame.changeCount();
						end;
						feedback = function(state)
							if (state.checked) then
								return IEF_COUNT_ON;
							else
								return IEF_COUNT_OFF;
							end
						end;
						default = {
							checked = true;
						};
						disabled = {
							checked = false;
						};
						dependencies = {
							["IEFNotification"] = { checked = true };
						};
					};
					{
						id = "IEFAlways";
						text = IEF_ALWAYS_TEXT;
						helptext = IEF_ALWAYS_HELP;
						type = K_TEXT;
						value = true;
						check = true;
						difficulty = 1;
						callback = function(state)
							ImprovedErrorSettings.alwaysShow = state.checked;
							ImprovedErrorFrame.changeAlways();
						end;
						feedback = function(state)
							if (state.checked) then
								return IEF_ALWAYS_ON;
							else
								return IEF_ALWAYS_OFF;
							end
						end;
						default = {
							checked = false;
						};
						disabled = {
							checked = false;
						};
						dependencies = {
							["IEFNotification"] = { checked = true };
						};
					};
					{
						id = "IEFSound";
						text = IEF_SOUND_TEXT;
						helptext = IEF_SOUND_HELP;
						type = K_TEXT;
						value = true;
						check = true;
						difficulty = 1;
						callback = function(state)
							ImprovedErrorSettings.gagNoise = not state.checked;
						end;
						feedback = function(state)
							if (state.checked) then
								return IEF_SOUND_ON;
							else
								return IEF_SOUND_OFF;
							end
						end;
						default = {
							checked = true;
						};
						disabled = {
							checked = false;
						};
						dependencies = {
							["IEFNotification"] = { checked = true };
						};
					};
				};
				commands = {
					{
						id = "ImprovedErrorFrameCommand";
						commands = { "/ief" };
						helpText = IEF_HELP_TEXT;
						parseTree = {
							[IEF_NOTIFY_OPT] = {
								[1] = {
									key = "IEFNotification";
									stringMap = {
										[IEF_ON] = { checked = false; };
										[IEF_OFF] = { checked = true; };
										["default"] = { checked = "~IEFNotification.checked" };
									};
								};
								[2] = {
									callback = function(msg)
										if (ImprovedErrorSettings.displayOnError) then
											ImprovedErrorFrame.Print(IEF_NOTIFY_OFF);
										else
											ImprovedErrorFrame.Print(IEF_NOTIFY_ON);
										end
									end;
								};
							};
							[IEF_BLINK_OPT] = {
								[1] = {
									key = "IEFBlink";
									stringMap = {
										[IEF_ON] = { checked = true; };
										[IEF_OFF] = { checked = false; };
										["default"] = { checked = "~IEFBlink.checked" };
									};
								};
								[2] = {
									callback = function(msg)
										if (ImprovedErrorSettings.blinkNotification) then
											ImprovedErrorFrame.Print(IEF_BLINK_ON);
										else
											ImprovedErrorFrame.Print(IEF_BLINK_OFF);
										end
									end;
								};
							};
							[IEF_COUNT_OPT] = {
								[1] = {
									key = "IEFCount";
									stringMap = {
										[IEF_ON] = { checked = true; };
										[IEF_OFF] = { checked = false; };
										["default"] = { checked = "~IEFCount.checked" };
									};
								};
								[2] = {
									callback = function(msg)
										if (ImprovedErrorSettings.displayCount) then
											ImprovedErrorFrame.Print(IEF_COUNT_ON);
										else
											ImprovedErrorFrame.Print(IEF_COUNT_OFF);
										end
									end;
								};
							};
							[IEF_ALWAYS_OPT] = {
								[1] = {
									key = "IEFAlways";
									stringMap = {
										[IEF_ON] = { checked = true; };
										[IEF_OFF] = { checked = false; };
										["default"] = { checked = "~IEFAlways.checked" };
									};
								};
								[2] = {
									callback = function(msg)
										if (ImprovedErrorSettings.alwaysShow) then
											ImprovedErrorFrame.Print(IEF_ALWAYS_ON);
										else
											ImprovedErrorFrame.Print(IEF_ALWAYS_OFF);
										end
									end;
								};

							};
							[IEF_SOUND_OPT] = {
								[1] = {
									key = "IEFSound";
									stringMap = {
										[IEF_ON] = { checked = false; };
										[IEF_OFF] = { checked = true; };
										["default"] = { checked = "~IEFSound.checked" };
									};
								};
								[2] = {
									callback = function(msg)
										if (ImprovedErrorSettings.gagNoise) then
											ImprovedErrorFrame.Print(IEF_SOUND_OFF);
										else
											ImprovedErrorFrame.Print(IEF_SOUND_ON);
										end
									end;
								};
							};
							["default"] = {
								callback = function(msg)
									ImprovedErrorFrame.displayOptions();
								end;
							};
						};
					};
				};
			}
		);
	end;

	-- Register everything with Cosmos
	CosmosRegister = function()
		Cosmos_RegisterConfiguration(
			"COS_IEF",
			"SECTION",
			"Improved Error Settings",
			"Change your Improved Error settings."
		);
		Cosmos_RegisterConfiguration(
			"COS_IEF_SEPARATOR",
			"SEPARATOR",
			"Improved Error Frame",
			"Improved Error Frame options."
		);
		Cosmos_RegisterConfiguration(
			"COS_IEF_NOTIFY_OPT",
			"CHECKBOX",
			IEF_NOTIFY_TEXT,
			IEF_NOTIFY_HELP,
			function(value, checked)
				ImprovedErrorSettings.displayOnError = (value < 1);
			end,
			ImprovedErrorFrame.convertVar(not ImprovedErrorSettings.displayOnError)
		);
		Cosmos_RegisterConfiguration(
			"COS_IEF_BLINK_OPT",
			"CHECKBOX",
			IEF_BLINK_TEXT,
			IEF_BLINK_HELP,
			function(value, checked)
				ImprovedErrorSettings.blinkNotification = (value > 0);
				ImprovedErrorFrame.changeBlink();
			end,
			ImprovedErrorFrame.convertVar(ImprovedErrorSettings.blinkNotification)
		);
		Cosmos_RegisterConfiguration(
			"COS_IEF_COUNT_OPT",
			"CHECKBOX",
			IEF_COUNT_TEXT,
			IEF_COUNT_HELP,
			function(value, checked)
				ImprovedErrorSettings.displayCount = (value > 0);
				ImprovedErrorFrame.changeCount();
			end,
			ImprovedErrorFrame.convertVar(ImprovedErrorSettings.displayCount)
		);
		Cosmos_RegisterConfiguration(
			"COS_IEF_ALWAYS_OPT",
			"CHECKBOX",
			IEF_ALWAYS_TEXT,
			IEF_ALWAYS_HELP,
			function(value, checked)
				ImprovedErrorSettings.alwaysShow = (value > 0);
				ImprovedErrorFrame.changeAlways();
			end,
			ImprovedErrorFrame.convertVar(ImprovedErrorSettings.alwaysShow)
		);
		Cosmos_RegisterConfiguration(
			"COS_IEF_SOUND_OPT",
			"CHECKBOX",
			IEF_SOUND_TEXT,
			IEF_SOUND_HELP,
			function(value, checked)
				ImprovedErrorSettings.gagNoise = (value < 1);
			end,
			ImprovedErrorFrame.convertVar(not ImprovedErrorSettings.gagNoise)
		);
		--ImprovedErrorFrame.syncVarsToCosmos();
	end;

	-- Cosmos uses 0 & 1 not false/true so we need to convert
	convertVar = function(varVal)
		if (varVal) then
			return 1;
		else
			return 0;
		end
	end;

	-- Sync changed variables to Cosmos Vars
	syncCosmosToVars = function()
		if (Cosmos_RegisterConfiguration) then
			Cosmos_UpdateValue("COS_IEF_NOTIFY_OPT", CSM_CHECKONOFF, ImprovedErrorFrame.convertVar(not ImprovedErrorSettings.displayOnError));
			Cosmos_SetCVar("COS_IEF_NOTIFY_OPT_X", ImprovedErrorFrame.convertVar(not ImprovedErrorSettings.displayOnError));
			Cosmos_UpdateValue("COS_IEF_BLINK_OPT", CSM_CHECKONOFF, ImprovedErrorFrame.convertVar(ImprovedErrorSettings.blinkNotification));
			Cosmos_SetCVar("COS_IEF_BLINK_OPT_X", ImprovedErrorFrame.convertVar(ImprovedErrorSettings.blinkNotification));
			Cosmos_UpdateValue("COS_IEF_COUNT_OPT", CSM_CHECKONOFF, ImprovedErrorFrame.convertVar(ImprovedErrorSettings.displayCount));
			Cosmos_SetCVar("COS_IEF_COUNT_OPT_X", ImprovedErrorFrame.convertVar(ImprovedErrorSettings.displayCount));
			Cosmos_UpdateValue("COS_IEF_ALWAYS_OPT", CSM_CHECKONOFF, ImprovedErrorFrame.convertVar(ImprovedErrorSettings.alwaysShow));
			Cosmos_SetCVar("COS_IEF_ALWAYS_OPT_X", ImprovedErrorFrame.convertVar(ImprovedErrorSettings.alwaysShow));
			Cosmos_UpdateValue("COS_IEF_SOUND_OPT", CSM_CHECKONOFF, ImprovedErrorFrame.convertVar(not ImprovedErrorSettings.gagNoise));
			Cosmos_SetCVar("COS_IEF_SOUND_OPT_X", ImprovedErrorFrame.convertVar(not ImprovedErrorSettings.gagNoise));
			if (CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading)) then
				CosmosMaster_DrawData();
			end
		end
	end;

	-- Sync variables to Cosmos Vars
	syncVarsToCosmos = function()
		local cosVar = getglobal("COS_IEF_NOTIFY_OPT_X");
		if (cosVar) then
			ImprovedErrorSettings.displayOnError = (cosVar < 1);
		end
		cosVar = getglobal("COS_IEF_BLINK_OPT_X");
		if (cosVar) then
			ImprovedErrorSettings.blinkNotification = (cosVar > 0);
		end
		cosVar = getglobal("COS_IEF_COUNT_OPT_X");
		if (cosVar) then
			ImprovedErrorSettings.displayCount = (cosVar > 0);
		end
		cosVar = getglobal("COS_IEF_ALWAYS_OPT_X");
		if (cosVar) then
			ImprovedErrorSettings.alwaysShow = (cosVar > 0);
		end
		cosVar = getglobal("COS_IEF_SOUND_OPT_X");
		if (cosVar) then
			ImprovedErrorSettings.gagNoise = (cosVar < 1);
		end
	end;

	-- Flags messages as shown, also builds the ImprovedErrorFrame.messagePrint message
	populateErrors = function()
		local errorMessageList = ImprovedErrorFrame.errorMessageList;
		local shown = 0;
		ImprovedErrorFrame.messagePrint = "";
		for i = 1, table.getn(errorMessageList), 1 do
			if (shown >= IEF_ERROR_MESSAGE_PAGE_MAX) then
				break;
			end
			local curMes = errorMessageList[i];
			if (curMes.status < IEF_MSG_VIEWED) then
				curMes.status = IEF_MSG_SHOWN;
				shown = shown + 1;

				local _, _, file, line, error = string.find(curMes.err, "^%[string \"(.+)\"%]:([^:]+):(.+)");
				local count = curMes.count;
				if (file and not curMes.AddOn and not curMes.fileName) then
					local patternStr;
					if (string.sub(file, -3) == "...") then
						patternStr = ".+\\(.+)\\(.+%.%.%.)$";
					else
						patternStr = ".+\\(.+)\\(.+%....)$";
					end
					local _, _, AddOnName, fileName = string.find(file, patternStr);
					if (AddOnName and not curMes.AddOn) then
						curMes.AddOn = AddOnName;
					end
					if (fileName and not curMes.fileName) then
						curMes.fileName = fileName;
					end
					if (line and not curMes.line) then
						curMes.line = line;
					end
					if (error and not curMes.parsedErr) then
						curMes.parsedErr = error;
					end
				end
				if (curMes.fileName) then
					if (string.sub(curMes.fileName, -3) ~= "...") then
						ImprovedErrorFrame.messagePrint = ImprovedErrorFrame.messagePrint..IEF_FILE..file.."\n"..IEF_LINE..line.."\n"..IEF_COUNT..count.."\n|cFFFF0000"..IEF_ERROR..error.."|r";
					else
						ImprovedErrorFrame.messagePrint = ImprovedErrorFrame.messagePrint..IEF_STRING..file.."\n"..IEF_LINE..line.."\n"..IEF_COUNT..count.."\n|cFFFF0000"..IEF_ERROR..error.."|r";
					end
				else 
					ImprovedErrorFrame.messagePrint = ImprovedErrorFrame.messagePrint.."\n"..IEF_COUNT..count.."\n|cFFFF0000"..IEF_ERROR..curMes.err.."|r";
				end
				if (i ~= table.getn(errorMessageList)) then
					ImprovedErrorFrame.messagePrint = ImprovedErrorFrame.messagePrint.."\n--------------------------------------------------\n";
				end
			end
		end
	end;

	-- Called after IEFFrame is hidden, turns off button if no more errors to view. Updates count if more.
	updateStatus = function()
		local numErrors = ImprovedErrorFrame.countErrors();
		if (numErrors > 0) then
			ImprovedErrorFrame.errorNotify(numErrors);
		else
			IEFMinimapButton:UnlockHighlight();
			IEFMinimapButton:SetText("");
			ImprovedErrorFrame.errorButtonActive = false;
			if (ImprovedErrorSettings.alwaysShow) then
				IEFMinimapButton:Disable();
			else
				IEFMinimapButton:Hide();
			end
			if (Chronos) then
				Chronos.unscheduleByName("IEFNotify");
			end
		end
	end;

	-- Reoccuring function to toggle Textures on the IEFMinimapButton
	buttonFlash = function(toggle)
		if (toggle) then
			IEFMinimapButton:LockHighlight();
		else
			IEFMinimapButton:UnlockHighlight();
		end
		if (ImprovedErrorFrame.errorButtonActive) then
			Chronos.scheduleByName("IEFNotify", IEF_BLINK_DELAY, ImprovedErrorFrame.buttonFlash, not toggle);
		end
	end;

	-- Counts number of errors left to be viewed, returns that number
	countErrors = function()
		local errorMessageList = ImprovedErrorFrame.errorMessageList;
		local numErrors = 0;
		for k,v in errorMessageList do
			if (v.status < IEF_MSG_VIEWED) then
				numErrors = numErrors + 1;
			end
		end
		return numErrors;
	end;

	-- Show the IEFMinimap button and start the texture toggling, passed the # of unviewed errors
	errorNotify = function(numErrors)
		if (not ImprovedErrorFrame.errorButtonActive) then
			ImprovedErrorFrame.errorButtonActive = true;
			if (not ImprovedErrorSettings.gagNoise) then
				PlaySoundFile("Interface\\AddOns\\ImprovedErrorFrame\\Sound\\ErrorSound.mp3");
	 		end
			if (ImprovedErrorSettings.alwaysShow) then
				IEFMinimapButton:Enable();
			else
				IEFMinimapButton:Show();
			end
			if (ImprovedErrorSettings.blinkNotification and Chronos) then
				if (not Chronos.isScheduledByName("IEFNotify")) then
					Chronos.scheduleByName("IEFNotify", IEF_BLINK_DELAY, ImprovedErrorFrame.buttonFlash, true);
				end
			end
		end
		if (ImprovedErrorSettings.displayCount) then
			IEFMinimapButton:SetText(numErrors);
		end
	end;

	--[[
	--	Called after errors occur, builds error list and behaves according to invoked.
	--
	--	Arguments:
	--		invoked - called by button click?
	--			  if true show frame, otherwise just notify.
	--]]
	showErrors = function(invoked)
		local numErrors = ImprovedErrorFrame.countErrors()
		if (numErrors) then
			if (not ImprovedErrorFrameFrame:IsVisible() and not ImprovedErrorSettings.displayOnError and not invoked) then
				ImprovedErrorFrame.errorNotify(numErrors);
				return;
			end
			ImprovedErrorFrame.populateErrors();
			if (not ImprovedErrorFrameFrame:IsVisible()) then
				if (ImprovedErrorFrame.displayReportButton) then
					ImprovedErrorFrameReportButton:Show();
				else
					ImprovedErrorFrameReportButton:Hide();
				end
				ImprovedErrorFrameCloseButton:Show();
				ScriptErrorsScrollFrameOne:Show();
				ImprovedErrorFrameFrameButton:Hide();
				if (ImprovedErrorSettings.displayOnError) then
					ImprovedErrorFrameFrameHeaderText:SetText(IEF_ERROR_TEXT);
				else
					ImprovedErrorFrameFrameHeaderText:SetText(IEF_TITLE_TEXT);
				end
				ImprovedErrorFrameFrame:Show();
			end

			ScriptErrorsScrollFrameOneText:SetText(ImprovedErrorFrame.messagePrint);
			ScriptErrorsScrollFrameOneText:ClearFocus();
		end
	end;

	--[[
	--	New _ERRORMESSAGE handler, increments count if error exists already. If the message is new then
	--	it is printed to the DEFAULT_CHAT_FRAME and added to the table of errors. the showErrors function
	--	is then called.
	--]]
	newErrorMessage = function(errorMessage)
		local errorMessageList = ImprovedErrorFrame.errorMessageList;
		debuginfo();
		if (not errorMessage) then return; end
		--if (table.getn(errorMessageList) >= IEF_ERROR_MESSAGE_MAX) then return; end

		local foundMes = false;
		for curNum, curMes in errorMessageList do
			if (curMes.err == errorMessage) then
				if (curMes.count.."" ~= IEF_INFINITE) then
					curMes.count = curMes.count + 1;
					if (curMes.count > IEF_ERROR_MESSAGE_INFINITE) then
						curMes.count = IEF_INFINITE;
					end
					curMes.status = IEF_MSG_NEW;
				else
					if (curMes.status >= IEF_MSG_VIEWED) then
						return;
					end
				end
				foundMes = true;
				break;
			end
		end

		if (not foundMes) then
			ImprovedErrorFrame.Print(errorMessage);
		end

		if ((not foundMes) and (table.getn(errorMessageList) < IEF_ERROR_MESSAGE_MAX)) then 
			table.insert(errorMessageList, { err = errorMessage, count = 1, status = IEF_MSG_NEW, reported = false, errDate = date() });
		end

		--if (table.getn(errorMessageList) > 0 and ImprovedErrorFrameFrame:IsVisible()) then return; end
		ImprovedErrorFrame.showErrors(false);
	end;

	-- Button related functions that wont be hooked.
	-- Shamelessly copied from AnduinLothar with his permission
	Button = {
		onLoad = function()
			this:RegisterEvent("VARIABLES_LOADED");
		end;
		-- Set the IEFMinimap button to whatever position it was moved to on startup.
		onEvent = function(event)
			if (event == "VARIABLES_LOADED") then
				if ((IEFMinimapButton_OffsetX) and (IEFMinimapButton_OffsetY)) then
					this:SetPoint("CENTER", "Minimap", "CENTER", IEFMinimapButton_OffsetX, IEFMinimapButton_OffsetY);
				end
			end
		end;
		-- Reset IEFMinimapButton to the default position.
		reset = function()
			IEFMinimapButton:ClearAllPoints();
			IEFMinimapButton_OffsetX = 12;
			IEFMinimapButton_OffsetY = -80;
			IEFMinimapButton:SetPoint("CENTER", "Minimap", "CENTER", IEFMinimapButton_OffsetX, IEFMinimapButton_OffsetY);
		end;
		-- Ensures the button travels around the minimap when dragged, not around your screen
		onUpdate = function()
			if (this.isMoving) then
				local mouseX, mouseY = GetCursorPosition();
				local centerX, centerY = Minimap:GetCenter();
				local scale = Minimap:GetScale();
				mouseX = mouseX / scale;
				mouseY = mouseY / scale;
				local radius = (Minimap:GetWidth()/2) + (this:GetWidth()/3);
				local x = math.abs(mouseX - centerX);
				local y = math.abs(mouseY - centerY);
				local xSign = 1;
				local ySign = 1;
				if not (mouseX >= centerX) then
					xSign = -1;
				end
				if not (mouseY >= centerY) then
					ySign = -1;
				end
				local angle = math.atan(x/y);
				x = math.sin(angle)*radius;
				y = math.cos(angle)*radius;
				this.currentX = xSign*x;
				this.currentY = ySign*y;
				this:SetPoint("CENTER", "Minimap", "CENTER", this.currentX, this.currentY);
			end
		end;
	}
}

ScriptErrors.Show = function()
	message(ScriptErrors_Message:GetText());
end

-- Converts SVN Rev tag to just a number, pass name of global variable with tag in quotes.
function convertRev(revStr)
	local _, _, revNum = string.find(getglobal(revStr), "^%$Rev: (%d+) %$");
	setglobal(revStr, revNum);
end

-- ==========================================================
-- == Hookable IEFMinimap functions
-- ==========================================================
function IEFMinimapButton_OnMouseDown()
	if (IsShiftKeyDown() and MouseIsOver(IEFMinimapButton)) then
		if ( arg1 == "RightButton" ) then
			--wait for reset
		else
			this.isMoving = true;
		end
	end
end

function IEFMinimapButton_OnMouseUp()
	if (this.isMoving) then
		this.isMoving = false;
		IEFMinimapButton_OffsetX = this.currentX;
		IEFMinimapButton_OffsetY = this.currentY;
	elseif (MouseIsOver(IEFMinimapButton)) then
		if (IsShiftKeyDown() and (arg1 == "RightButton")) then
			ImprovedErrorFrame.Button.reset();
		elseif (ImprovedErrorFrame.errorButtonActive) then
			ImprovedErrorFrame.showErrors(true);
		end
	end
end

function IEFMinimapButton_OnHide()
	this.isMoving = false;
end

-- Empty function to be hooked by error reporting AddOns
function ImprovedErrorFrame_Report_OnClick(errorList)
	--[[
	--  Hook this function if you care when the report button is clicked
	--  the table of errors is passed, see the notes at the top for the
	--  structure.
	--]]
end