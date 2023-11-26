--[[
	Tooltip Placer

	By sarf

	This mod allows you to put the tooltip where you want.

	Thanks goes to Owlboy on the CosmosUI forums.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
TOOLTIPPLACER_POINT = "Point";
TOOLTIPPLACER_RELATIVETO = "RelativeTo";
TOOLTIPPLACER_RELATIVEPOINT = "RelativePoint";
TOOLTIPPLACER_POSITION = "Position";


-- Variables
TooltipPlacer_Enabled = 0;
TooltipPlacer_VerticalGrowth = 0;

TooltipPlacer_Saved_GameTooltip_SetDefaultAnchor = nil;
TooltipPlacer_Cosmos_Registered = 0;

TooltipPlacer_PointSettings = {
	[TOOLTIPPLACER_POINT] = "TOPLEFT",
	[TOOLTIPPLACER_RELATIVETO] = "UIParent",
	[TOOLTIPPLACER_RELATIVEPOINT] = "TOPLEFT",
	[TOOLTIPPLACER_POSITION] = nil
};

-- executed on load, calls general set-up functions
function TooltipPlacer_OnLoad()
	TooltipPlacer_Register();
end

function TooltipPlacer_GameTooltip_SetDefaultAnchor(tooltip, parent) 
	if ( ( TooltipPlacer_Enabled == 1 ) and ( tooltip == GameTooltip ) ) then 
		if ( TooltipPlacer_PointSettings ) then
			local position = TooltipPlacer_PointSettings[TOOLTIPPLACER_POSITION];
			if ( ( position ) and ( position[1] ) and ( position[2] ) ) then
				tooltip:SetOwner(parent, "ANCHOR_NONE");
				tooltip:ClearAllPoints();
				tooltip:SetPoint(TooltipPlacer_PointSettings[TOOLTIPPLACER_POINT], TooltipPlacer_PointSettings[TOOLTIPPLACER_RELATIVETO], TooltipPlacer_PointSettings[TOOLTIPPLACER_RELATIVEPOINT], position[1], position[2] );
				return;
			end
		end
	end
	TooltipPlacer_Saved_GameTooltip_SetDefaultAnchor(tooltip, parent);
end


-- registers the mod with Cosmos
function TooltipPlacer_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( TooltipPlacer_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPPLACER",
			"SECTION",
			TEXT(TOOLTIPPLACER_CONFIG_HEADER),
			TEXT(TOOLTIPPLACER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPPLACER_HEADER",
			"SEPARATOR",
			TEXT(TOOLTIPPLACER_CONFIG_HEADER),
			TEXT(TOOLTIPPLACER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPPLACER_ENABLED",
			"CHECKBOX",
			TEXT(TOOLTIPPLACER_ENABLED),
			TEXT(TOOLTIPPLACER_ENABLED_INFO),
			TooltipPlacer_Toggle_Enabled,
			TooltipPlacer_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPPLACER_VERTICALGROWTH",
			"CHECKBOX",
			TEXT(TOOLTIPPLACER_VERTICALGROWTH),
			TEXT(TOOLTIPPLACER_VERTICALGROWTH_INFO),
			TooltipPlacer_Toggle_VerticalGrowth,
			TooltipPlacer_VerticalGrowth
		);
		TooltipPlacer_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function TooltipPlacer_Register()
	if ( Cosmos_RegisterConfiguration ) then
		TooltipPlacer_Register_Cosmos();
	else
		SlashCmdList["TOOLTIPPLACERSLASHENABLE"] = TooltipPlacer_Enable_ChatCommandHandler;
		SLASH_TOOLTIPPLACERSLASHENABLE1 = "/tooltipplacerenable";
		SLASH_TOOLTIPPLACERSLASHENABLE2 = "/tpenable";
		SLASH_TOOLTIPPLACERSLASHENABLE3 = "/tooltipplacerdisable";
		SLASH_TOOLTIPPLACERSLASHENABLE4 = "/tpdisable";
		SLASH_TOOLTIPPLACERSLASHENABLE5 = "/tooltipplacertoggle";
		SLASH_TOOLTIPPLACERSLASHENABLE6 = "/tptoggle";
		SlashCmdList["TOOLTIPPLACERSLASHMARKNEWPLACE"] = TooltipPlacer_MarkNewPlace;
		SLASH_TOOLTIPPLACERSLASHMARKNEWPLACE1 = "/tooltipplacermark";
		SLASH_TOOLTIPPLACERSLASHMARKNEWPLACE2 = "/tpmark";
		SLASH_TOOLTIPPLACERSLASHMARKNEWPLACE3 = "/tooltipplacermarknewplace";
		SLASH_TOOLTIPPLACERSLASHMARKNEWPLACE4 = "/tpmarknewplace";
		SLASH_TOOLTIPPLACERSLASHMARKNEWPLACE5 = "/tooltipplacermarkposition";
		SLASH_TOOLTIPPLACERSLASHMARKNEWPLACE6 = "/tpmarkposition";
		SlashCmdList["TOOLTIPPLACERSLASHVERTICALGROWTH"] = TooltipPlacer_VerticalGrowth_ChatCommandHandler;
		SLASH_TOOLTIPPLACERSLASHMARKVERTICALGROWTH1 = "/tooltipplacerverticalgrowth";
		SLASH_TOOLTIPPLACERSLASHMARKVERTICALGROWTH2 = "/tpverticalgrowth";
	end

	if ( Cosmos_RegisterChatCommand ) then
		local TooltipPlacerEnableCommands = {"/tooltipplacertoggle","/tptoggle","/tooltipplacerenable","/tpenable","/tooltipplacerdisable","/tpdisable"};
		Cosmos_RegisterChatCommand (
			"TOOLTIPPLACER_ENABLE_COMMANDS", -- Some Unique Group ID
			TooltipPlacerEnableCommands, -- The Commands
			TooltipPlacer_Enable_ChatCommandHandler,
			TOOLTIPPLACER_CHAT_COMMAND_ENABLE_INFO -- Description String
		);
		local TooltipPlacerMarkNewPlaceCommands = {"/tooltipplacermark","/tpmark","/tooltipplacermarknewplace","/tpmarknewplace","/tooltipplacermarkposition","/tpmarkposition"};
		Cosmos_RegisterChatCommand (
			"TOOLTIPPLACER_MARKNEWPLACE_COMMANDS", -- Some Unique Group ID
			TooltipPlacerMarkNewPlaceCommands, -- The Commands
			TooltipPlacer_MarkNewPlace,
			TOOLTIPPLACER_CHAT_COMMAND_MARKNEWPLACE_INFO -- Description String
		);
		local TooltipPlacerVerticalGrowthCommands = {"/tooltipplacerverticalgrowth","/tpverticalgrowth"};
		Cosmos_RegisterChatCommand (
			"TOOLTIPPLACER_VERTICALGROWTH_COMMANDS", -- Some Unique Group ID
			TooltipPlacerVerticalGrowthCommands, -- The Commands
			TooltipPlacer_VerticalGrowth_ChatCommandHandler,
			TOOLTIPPLACER_CHAT_COMMAND_VERTICALGROWTH_INFO -- Description String
		);
	end
	
	RegisterForSave("TooltipPlacer_PointSettings");
	this:RegisterEvent("VARIABLES_LOADED");
end

-- Handles chat - e.g. slashcommands - enabling/disabling the TooltipPlacer
function TooltipPlacer_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		TooltipPlacer_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			TooltipPlacer_Toggle_Enabled(0);
		else
			TooltipPlacer_Toggle_Enabled(-1);
		end
	end
end

-- Handles chat - e.g. slashcommands - enabling/disabling the TooltipPlacer
function TooltipPlacer_VerticalGrowth_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		TooltipPlacer_Toggle_VerticalGrowth(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			TooltipPlacer_Toggle_VerticalGrowth(0);
		else
			TooltipPlacer_Toggle_VerticalGrowth(-1);
		end
	end
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function TooltipPlacer_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( GameTooltip_SetDefaultAnchor ~= TooltipPlacer_GameTooltip_SetDefaultAnchor ) and (TooltipPlacer_Saved_GameTooltip_SetDefaultAnchor == nil) ) then
			TooltipPlacer_Saved_GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor;
			GameTooltip_SetDefaultAnchor = TooltipPlacer_GameTooltip_SetDefaultAnchor;
		end
	else
		if ( GameTooltip_SetDefaultAnchor == TooltipPlacer_GameTooltip_SetDefaultAnchor) then
			GameTooltip_SetDefaultAnchor = TooltipPlacer_Saved_GameTooltip_SetDefaultAnchor;
			TooltipPlacer_Saved_GameTooltip_SetDefaultAnchor = nil;
		end
	end
end

-- Handles events
function TooltipPlacer_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( TooltipPlacer_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_TOOLTIPPLACER_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			TooltipPlacer_Toggle_Enabled(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function TooltipPlacer_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage)
	local oldvalue = getglobal(variableName);
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	setglobal(variableName, newvalue);
	setglobal(CVarName, newvalue);
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			TooltipPlacer_Print(TEXT(getglobal(enableMessage)));
		else
			TooltipPlacer_Print(TEXT(getglobal(disableMessage)));
		end
	end
	TooltipPlacer_Register_Cosmos();
	if ( TooltipPlacer_Cosmos_Registered == 0 ) then 
		RegisterForSave(CVarName);
	end
	return newvalue;
end

-- Toggles the enabled/disabled state of the TooltipPlacer
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function TooltipPlacer_Toggle_Enabled(toggle)
	local newvalue = TooltipPlacer_Generic_Toggle(toggle, "TooltipPlacer_Enabled", "COS_TOOLTIPPLACER_ENABLED_X", "TOOLTIPPLACER_CHAT_ENABLED", "TOOLTIPPLACER_CHAT_DISABLED");
	TooltipPlacer_Setup_Hooks(newvalue);
	TooltipPlacer_RefreshTooltipPlace();
end

function TooltipPlacer_Toggle_VerticalGrowth(toggle)
	local newvalue = TooltipPlacer_Generic_Toggle(toggle, "TooltipPlacer_VerticalGrowth", "COS_TOOLTIPPLACER_VERTICALGROWTH_X", "TOOLTIPPLACER_CHAT_VERTICALGROWTH_ENABLED", "TOOLTIPPLACER_CHAT_VERTICALGROWTH_DISABLED");
	if ( TooltipPlacer_PointSettings ) then
		if ( newvalue == 0 ) then
			TooltipPlacer_PointSettings[TOOLTIPPLACER_POINT] = "TOPLEFT";
		else
			TooltipPlacer_PointSettings[TOOLTIPPLACER_POINT] = "BOTTOMLEFT";
		end
	end
	TooltipPlacer_RefreshTooltipPlace();
end

-- Prints out text to a chat box.
function TooltipPlacer_Print(msg,r,g,b,frame,id,unknown4th)
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

function TooltipPlacer_RefreshTooltipPlace()
	if ( TooltipPlacer_Enabled == 1 ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
	end
end

function TooltipPlacer_MarkNewPlace()
	local x, y = GetCursorPosition(UIParent); 
	local coords = { x, ((UIParent:GetHeight()-y)*-1) }; 
	TooltipPlacer_PointSettings[TOOLTIPPLACER_POSITION] = coords;
	TooltipPlacer_Print(TOOLTIPPLACER_CHAT_NEWPLACE);
	TooltipPlacer_RefreshTooltipPlace();
end

