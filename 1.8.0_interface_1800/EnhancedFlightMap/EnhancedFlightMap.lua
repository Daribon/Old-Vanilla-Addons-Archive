--[[

Main program function for Enhanced Flight Map.

Localisation of text should be done in localization.lua.

All other code in here should not be modified unless you know what you are doing,
and if you do modify something, please let me know.

]]

EFM_TaxiOrigin = "";

---------------------------------------------------------------------------
-- Functions to deal with the various methods the program can be called
---------------------------------------------------------------------------

-- Events to register for.
function EnhancedFlightMap_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("WORLD_MAP_UPDATE");
	this:RegisterEvent("TAXIMAP_OPENED");
end

-- What to do when events are seen.
function EnhancedFlightMap_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		-- Call various init routines.
		EnhancedFlightMap_Init();
		EFM_Timer_Init();

		-- Display login message
	--	LYS_ProgramLoadedText(EFM_Version_String);

	elseif (event == "WORLD_MAP_UPDATE") then
		EFM_Map_WorldMapEvent();

	elseif (event == "TAXIMAP_OPENED") then
		EnhancedFlightMap_TaxiFrame_OnEvent();

	else
		DEFAULT_CHAT_FRAME:AddMessage("Event: "..event);
	end
end

-- Program initialisation routine.
function EnhancedFlightMap_Init()
	EFM_DefineData();
	EFM_ValidateVersions();
	
	-- Register our slash commands
	SLASH_EFM1 = EFM_SLASH1;
	SLASH_EFM2 = EFM_SLASH2;
	SlashCmdList["EFM"] = function(msg)
		EFM_SlashCommandHandler(msg);
	end
end

