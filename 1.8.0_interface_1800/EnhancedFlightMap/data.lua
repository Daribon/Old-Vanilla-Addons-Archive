--[[

data.lua

Various data load functions.

]]

-- Function: Define the EFM data variable(s)
function EFM_DefineData()
	---------------------------------
	-- Global options data definition
	if (not EFM_Config) then
		EFM_Config = {};
	end
	
	if (EFM_Config.Timer == nil) then
		EFM_Config.Timer		= true;
	end

	if (EFM_Config.ZoneMarker == nil) then
		EFM_Config.ZoneMarker	= true;
	end

	if (EFM_Config.DruidPaths == nil) then
		EFM_Config.DruidPaths	= true;
	end
	
	if (EFM_Config.ShowAltPaths == nil) then
		EFM_Config.ShowAltPaths	= true;
	end

	if (EFM_Config.ShowTimerBar == nil) then
		EFM_Config.ShowTimerBar = false;
	end

	if (EFM_Config.ShowCheapestFlight == nil) then
		EFM_Config.ShowCheapestFlight = true;
	end
	
	if (EFM_Config.ShowRemotePaths == nil) then
		EFM_Config.ShowRemotePaths = true;
	end
	
	if (EFM_Config.ShowLargeBar == nil) then
		EFM_Config.ShowLargeBar = false;
	end

	------------------------------------------------------------------------------------------
	-- Make sure the global variable for the flight master location data is defined correctly.
	if (not EnhancedFlightMap_TaxiData) then
		EnhancedFlightMap_TaxiData = {};
	end
	
	-- Define structure for horde
	if (not EnhancedFlightMap_TaxiData["Horde"]) then
		EnhancedFlightMap_TaxiData["Horde"]	= {};
	end
	if (not EnhancedFlightMap_TaxiData["Horde"][1]) then
		EnhancedFlightMap_TaxiData["Horde"][1]	= {};
	end
	if (not EnhancedFlightMap_TaxiData["Horde"][2]) then
		EnhancedFlightMap_TaxiData["Horde"][2]	= {};
	end
	
	-- Define structure for alliance
	if (not EnhancedFlightMap_TaxiData["Alliance"]) then
		EnhancedFlightMap_TaxiData["Alliance"]	= {};
	end
	if (not EnhancedFlightMap_TaxiData["Alliance"][1]) then
		EnhancedFlightMap_TaxiData["Alliance"][1]	= {};
	end
	if (not EnhancedFlightMap_TaxiData["Alliance"][2]) then
		EnhancedFlightMap_TaxiData["Alliance"][2]	= {};
	end

	
	-------------------------------------------------------------------------------
	-- Make sure the global variable for map translation data is defined correctly.
	if (not EFM_MapTranslation) then
		EFM_MapTranslation = {};
	end
	
	-- Define structure for horde
	if (not EFM_MapTranslation["Horde"]) then
		EFM_MapTranslation["Horde"]	= {};
	end
	if (not EFM_MapTranslation["Horde"][1]) then
		EFM_MapTranslation["Horde"][1]	= {};
	end
	if (not EFM_MapTranslation["Horde"][2]) then
		EFM_MapTranslation["Horde"][2]	= {};
	end
	
	-- Define structure for alliance
	if (not EFM_MapTranslation["Alliance"]) then
		EFM_MapTranslation["Alliance"]	= {};
	end
	if (not EFM_MapTranslation["Alliance"][1]) then
		EFM_MapTranslation["Alliance"][1]	= {};
	end
	if (not EFM_MapTranslation["Alliance"][2]) then
		EFM_MapTranslation["Alliance"][2]	= {};
	end


	-------------------------------------------------------------------------------------
	-- Make sure the global variable for flight times and cost data is defined correctly.
	if (not EnhancedFlightMap_TaxiPathData) then
		EnhancedFlightMap_TaxiPathData = {};
	end
	-- Define structure for horde
	if (not EnhancedFlightMap_TaxiPathData["Horde"]) then
		EnhancedFlightMap_TaxiPathData["Horde"]	= {};
	end
	if (not EnhancedFlightMap_TaxiPathData["Horde"][1]) then
		EnhancedFlightMap_TaxiPathData["Horde"][1]	= {};
	end
	if (not EnhancedFlightMap_TaxiPathData["Horde"][2]) then
		EnhancedFlightMap_TaxiPathData["Horde"][2]	= {};
	end
	
	-- Define structure for alliance
	if (not EnhancedFlightMap_TaxiPathData["Alliance"]) then
		EnhancedFlightMap_TaxiPathData["Alliance"]	= {};
	end
	if (not EnhancedFlightMap_TaxiPathData["Alliance"][1]) then
		EnhancedFlightMap_TaxiPathData["Alliance"][1]	= {};
	end
	if (not EnhancedFlightMap_TaxiPathData["Alliance"][2]) then
		EnhancedFlightMap_TaxiPathData["Alliance"][2]	= {};
	end

	-------------------------------------------------------------------------------------
	-- Make sure the global variable for the known path data is defined correctly.
	if (not EFM_KnownPaths) then
		EFM_KnownPaths = {};
	end
	
	-- Define structure for horde
	if (not EFM_KnownPaths["Horde"]) then
		EFM_KnownPaths["Horde"]	= {};
	end
	if (not EFM_KnownPaths["Horde"][1]) then
		EFM_KnownPaths["Horde"][1]	= {};
	end
	if (not EFM_KnownPaths["Horde"][2]) then
		EFM_KnownPaths["Horde"][2]	= {};
	end
	
	-- Define structure for alliance
	if (not EFM_KnownPaths["Alliance"]) then
		EFM_KnownPaths["Alliance"]	= {};
	end
	if (not EFM_KnownPaths["Alliance"][1]) then
		EFM_KnownPaths["Alliance"][1]	= {};
	end
	if (not EFM_KnownPaths["Alliance"][2]) then
		EFM_KnownPaths["Alliance"][2]	= {};
	end
end


-- Function: Validate the data set versions and load missing data.
function EFM_ValidateVersions()
	-- Load user data or default data if available.
	if (not EnhancedFlightMap_TaxiData) then
		EFM_Clear_Data();	-- Create a blank data set.  Users can load the presets if they want to.
	elseif (EnhancedFlightMap_TaxiData.Version) then
		EnhancedFlightMap_TaxiData.Version = nil;

	elseif ((EnhancedFlightMap_TaxiData.HordeVersion) and (EnhancedFlightMap_TaxiData.HordeVersion ~= Default_EFM_Data_Horde.HordeVersion)) then
		EFM_Load_Stored_Data("Horde");
	elseif ((EFM_MapTranslation.HordeMapTranslationVersion) and (EFM_MapTranslation.HordeMapTranslationVersion ~= Default_EFM_Data_HordeMapTranslation.HordeMapTranslationVersion)) then
		EFM_MAP_LoadData("Horde");
	elseif ((EnhancedFlightMap_TaxiPathData.HordeFlightPathVersion) and (EnhancedFlightMap_TaxiPathData.HordeFlightPathVersion ~= Default_EFM_Data_HordeFlightPath.HordeFlightPathVersion)) then
		EFM_Timer_LoadData("Horde");

	elseif ((EnhancedFlightMap_TaxiData.AllianceVersion) and (EnhancedFlightMap_TaxiData.AllianceVersion ~= Default_EFM_Data_Alliance.AllianceVersion)) then
		EFM_Load_Stored_Data("Alliance");
	elseif ((EFM_MapTranslation.AllianceMapTranslationVersion) and (EFM_MapTranslation.AllianceMapTranslationVersion ~= Default_EFM_Data_AllianceMapTranslation.AllianceMapTranslationVersion)) then
		EFM_MAP_LoadData("Alliance");
	elseif ((EnhancedFlightMap_TaxiPathData.AllianceFlightPathVersion) and (EnhancedFlightMap_TaxiPathData.AllianceFlightPathVersion ~= Default_EFM_Data_AllianceFlightPath.AllianceFlightPathVersion)) then
		EFM_Timer_LoadData("Alliance");

	elseif ((EnhancedFlightMap_TaxiData.DruidVersion) and (EnhancedFlightMap_TaxiData.DruidVersion ~= Default_EFM_Data_Druid.DruidVersion)) then
		EFM_Load_Stored_Data("Druid");
	end
end

-- Function to load data from defaults.
function EFM_Load_Stored_Data(DataType)
	if (EFMDATA_CLEAR_ON_LOAD) then
		EFM_Clear_DataByType(EnhancedFlightMap_TaxiData, DataType);
	end

	local StoredData = getglobal("Default_EFM_Data_"..DataType);
	local SDVersion = DataType.."Version";

	-- Do dataset merge.
	LYS_mergeTable(StoredData, EnhancedFlightMap_TaxiData);

	EnhancedFlightMap_TaxiData[SDVersion] = StoredData[SDVersion];

	-- Notify user of successful data load.
	DEFAULT_CHAT_FRAME:AddMessage(format(EFM_DATA_LOAD_SUCCESS, DataType));
end

-- Function: Load Map data
function EFM_MAP_LoadData(DataType)
	if (EFMDATA_CLEAR_ON_LOAD) then
		EFM_Clear_DataByType(EFM_MapTranslation, DataType);
	end

	local StoredData = getglobal("Default_EFM_Data_"..DataType.."MapTranslation");
	local SDVersion = DataType.."MapTranslationVersion";

	-- Do dataset merge.
	LYS_mergeTable(StoredData, EFM_MapTranslation);

	EFM_MapTranslation[SDVersion] = StoredData[SDVersion];
end

-- Function: Load the timer data.
function EFM_Timer_LoadData(DataType)
	if (EFMDATA_CLEAR_ON_LOAD) then
		EFM_Clear_DataByType(EnhancedFlightMap_TaxiPathData, DataType);
	end

	local StoredData = getglobal("Default_EFM_Data_"..DataType.."FlightPath");
	local SDVersion = DataType.."FlightPathVersion";

	-- Do dataset merge.
	LYS_mergeTable(StoredData, EnhancedFlightMap_TaxiPathData);

	EnhancedFlightMap_TaxiPathData[SDVersion] = StoredData[SDVersion];
end

-- Function to clear all data so flightpaths can be re-learnt.
function EFM_Clear_Data()
	EnhancedFlightMap_TaxiData		= {};
	EnhancedFlightMap_TaxiPathData	= {};
	EFM_MapTranslation				= {};

	EFM_DefineData();

	-- Tell the user
	DEFAULT_CHAT_FRAME:AddMessage(EFM_CLEAR_MESSAGE);
end

function EFM_Clear_DataByType(dataType, myFaction)
	dataType[myFaction] = {};
	dataType[myFaction][1] = {};
	dataType[myFaction][2] = {};
end
