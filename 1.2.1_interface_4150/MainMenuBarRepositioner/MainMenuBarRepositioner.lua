--[[
	Main MenuBar Repositioner

	By sarf

	This mod allows you change the position of the main menu bar.

	Thanks goes to Oof on the CosmosUI forums.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=417
	
   ]]


-- Constants
MAINMENUBARREPOSITIONER_POSITION_LEFT = 1;
MAINMENUBARREPOSITIONER_POSITION_MIDDLE = 2;
MAINMENUBARREPOSITIONER_POSITION_RIGHT = 3;

MAINMENUBARREPOSITIONER_POSITION_MIN = 1;
MAINMENUBARREPOSITIONER_POSITION_MAX = 3;

MAINMENUBARREPOSITIONER_POSITION_DEFAULT = MAINMENUBARREPOSITIONER_POSITION_MIDDLE;

-- Variables
MainMenuBarRepositioner_Position = MAINMENUBARREPOSITIONER_POSITION_DEFAULT;

MainMenuBarRepositioner_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function MainMenuBarRepositioner_OnLoad()
	MainMenuBarRepositioner_Register();
end

-- registers the mod with Cosmos
function MainMenuBarRepositioner_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( MainMenuBarRepositioner_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_MAINMENUBARREPOSITIONER",
			"SECTION",
			TEXT(MAINMENUBARREPOSITIONER_CONFIG_HEADER),
			TEXT(MAINMENUBARREPOSITIONER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_MAINMENUBARREPOSITIONER_HEADER",
			"SEPARATOR",
			TEXT(MAINMENUBARREPOSITIONER_CONFIG_HEADER),
			TEXT(MAINMENUBARREPOSITIONER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_MAINMENUBARREPOSITIONER_POSITION",
			"SLIDER",
			TEXT(MAINMENUBARREPOSITIONER_POSITION),
			TEXT(MAINMENUBARREPOSITIONER_POSITION_INFO),
			MainMenuBarRepositioner_Position_Change,
			1, -- checked
			MainMenuBarRepositioner_Position,
			MAINMENUBARREPOSITIONER_POSITION_MIN, -- min value
			MAINMENUBARREPOSITIONER_POSITION_MAX, -- max value
			MAINMENUBARREPOSITIONER_POSITION_SLIDER, -- slider text
			1,
			0,
			"", -- slider text append
			1  -- slider multiplier
		);
		--[[
		Cosmos_RegisterConfiguration(
			"COS_MAINMENUBARREPOSITIONER_POSITION_RESET",
			"BUTTON",
			TEXT(MAINMENUBARREPOSITIONER_POSITION_RESET),
			TEXT(MAINMENUBARREPOSITIONER_POSITION_RESET_INFO),
			MainMenuBarRepositioner_Reset_Position,
			0,
			0,
			0,
			0,
			MAINMENUBARREPOSITIONER_POSITION_RESET_NAME
		);
		]]--
		MainMenuBarRepositioner_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function MainMenuBarRepositioner_Register()
	if ( Cosmos_RegisterConfiguration ) then
		MainMenuBarRepositioner_Register_Cosmos();
	else
		SlashCmdList["MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE"] = MainMenuBarRepositioner_Position_Change_ChatCommandHandler;
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE1 = "/mainmenubarrepositioner";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE2 = "/mainmenubarreposition";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE3 = "/mmbr";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE4 = "/mainbarrepositioner";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE5 = "/mainbarreposition";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE6 = "/mainmenubarpositionchange";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE7 = "/mainbarpositionchange";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE8 = "/mmbpositionchange";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE9 = "/mmbposchange";
		SLASH_MAINMENUBARREPOSITIONERSLASHPOSITION_CHANGE10 = "/mmbpc";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local MainMenuBarRepositionerPositionChangeCommands = {"/mainmenubarreposition","/mainmenubarrepositioner","/mmbr","/mainbarrepositioner","/mainbarreposition", "/mainmenubarpositionchange", "/mainbarpositionchange", "/mmbpositionchange", "/mmbposchange", "/mmbpc"};
		Cosmos_RegisterChatCommand (
			"MAINMENUBARREPOSITIONER_POSITION_CHANGE_COMMANDS", -- Some Unique Group ID
			MainMenuBarRepositionerPositionChangeCommands, -- The Commands
			MainMenuBarRepositioner_Position_Change_ChatCommandHandler,
			MAINMENUBARREPOSITIONER_CHAT_COMMAND_POSITION_CHANGE_INFO -- Description String
		);
	end
end

-- Handles chat - e.g. slashcommands - repositioning the main menu bar 
function MainMenuBarRepositioner_Position_Change_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, MAINMENUBARREPOSITIONER_SLASH_COMMAND_LEFT)) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		MainMenuBarRepositioner_ChangePosition(MAINMENUBARREPOSITIONER_POSITION_LEFT);
	else
		if ( (string.find(msg, MAINMENUBARREPOSITIONER_SLASH_COMMAND_DEFAULT)) or (string.find(msg, MAINMENUBARREPOSITIONER_SLASH_COMMAND_RESTORE)) or (string.find(msg, MAINMENUBARREPOSITIONER_SLASH_COMMAND_MIDDLE)) or ((string.find(msg, '2')) ) ) then
			MainMenuBarRepositioner_ChangePosition(MAINMENUBARREPOSITIONER_POSITION_MIDDLE);
		else
			if ( (string.find(msg, MAINMENUBARREPOSITIONER_SLASH_COMMAND_RIGHT)) or ((string.find(msg, '3')) ) ) then
				MainMenuBarRepositioner_ChangePosition(MAINMENUBARREPOSITIONER_POSITION_RIGHT);
			else
				if ( ( not msg ) or ( strlen(msg) <= 0 ) ) then
					MainMenuBarRepositioner_Print(MAINMENUBARREPOSITIONER_CHAT_EMPTY_PARAMETER);
				else
					MainMenuBarRepositioner_Print(MAINMENUBARREPOSITIONER_CHAT_UNKNOWN_PARAMETER);
				end
				local str = MAINMENUBARREPOSITIONER_CHAT_VALID_PARAMETERS..MAINMENUBARREPOSITIONER_SLASH_COMMAND_LEFT.." "..MAINMENUBARREPOSITIONER_SLASH_COMMAND_LEFT.." "..MAINMENUBARREPOSITIONER_SLASH_COMMAND_DEFAULT.." "..MAINMENUBARREPOSITIONER_SLASH_COMMAND_RIGHT;
			 	MainMenuBarRepositioner_Print(str);
			end
		end
	end
end

-- Handles events
function MainMenuBarRepositioner_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( MainMenuBarRepositioner_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_MAINMENUBARREPOSITIONER_POSITION");
			if (value == nil ) then
				-- defaults to off
				value = MainMenuBarRepositioner_Position;
			end
			MainMenuBarRepositioner_ChangePosition(value);
		end
	end
end

function MainMenuBarRepositioner_ChangePosition(value)
	local anchorPoint = "BOTTOM";
	if ( value == MAINMENUBARREPOSITIONER_POSITION_LEFT ) then
		anchorPoint = "BOTTOMLEFT";
	end
	if ( value == MAINMENUBARREPOSITIONER_POSITION_RIGHT ) then
		anchorPoint = "BOTTOMRIGHT";
	end
	local oldvalue = MainMenuBarRepositioner_Enabled;
	MainMenuBarRepositioner_Position = value;
	MainMenuBar:ClearAllPoints();
	MainMenuBar:SetPoint(anchorPoint, "UIParent", anchorPoint, 0, 0);
	if ( newvalue ~= oldvalue ) then
		MainMenuBarRepositioner_Print(format(MAINMENUBARREPOSITIONER_CHAT_POSITION_CHANGED, anchorPoint));
	end
	setglobal("COS_MAINMENUBARREPOSITIONER_POSITION", newvalue);
	MainMenuBarRepositioner_Register_Cosmos();
	if ( MainMenuBarRepositioner_Cosmos_Registered == 0 ) then 
		RegisterForSave("COS_MAINMENUBARREPOSITIONER_POSITION");
	end
end

function MainMenuBarRepositioner_Position_Change(toggle, value)
	MainMenuBarRepositioner_ChangePosition(value);
end

function MainMenuBarRepositioner_Reset_Position()
	MainMenuBarRepositioner_ChangePosition(MAINMENUBARREPOSITIONER_POSITION_MIDDLE);
end

-- Prints out text to a chat box.
function MainMenuBarRepositioner_Print(msg,r,g,b,frame,id,unknown4th)
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end
