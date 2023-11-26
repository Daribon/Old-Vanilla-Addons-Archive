--[[

Map modifications

]]

local Original_WorldMapButton_OnUpdate;
local knownPoints = {};

local EFM_MAX_POI = 50;

-- Function: Map Initialization routine
function EFM_Map_Init()
	-- Hook the world map button so we know when map zones change via pulldown menu
	--if(WorldMapButton_OnUpdate ~= EFM_Map_WorldMapButton_OnUpdate) then
	--	Original_WorldMapButton_OnUpdate = WorldMapButton_OnUpdate;
	--	WorldMapButton_OnUpdate = EFM_Map_WorldMapButton_OnUpdate;
	--end
end

-- Function: Clear the POI buttons
function EFM_Map_ClearPOI()
	for i = 1, EFM_MAX_POI, 1 do
		POI = getglobal("EFM_MAP_POI"..i);
		if(POI) then
			POI:ClearAllPoints();
			POI.Location = nil;
			POI:Hide();
		end
	end
end

-- Function: Get map points for world map.
function EFM_Map_CheckPoints(myFaction, myContinent, myZone)
	for key,val in pairs(EFM_MapTranslation[myFaction][myContinent]) do
		if (val == myZone) then
			if (not LYS_StringInTable(knownPoints, key)) then
				table.insert(knownPoints, key);
			end
		end
	end
end

-- Function: World Map Update thingy.
function EFM_Map_WorldMapEvent()

	if (not EFM_Config.ZoneMarker) then
		return;
	end

	if (WorldMapDetailFrame:IsVisible()) then
		EFM_Map_ClearPOI();

		local myFaction		= UnitFactionGroup("player");
		local myContinent	= GetCurrentMapContinent();
		local myZone		= GetCurrentMapZone();

		local zoneList		= {};
		local zoneName		= "";
		knownPoints			= {};

		local buttonCount	= 0;

		if ((myContinent == 0) or (myZone == 0)) then
			return nil;
		end

		EFM_Map_CheckPoints(myFaction, myContinent, myZone);
		EFM_Map_ClearPOI();

		local POI;
		local POITexture;

		for key, val in pairs(knownPoints) do
			if (EnhancedFlightMap_TaxiData[myFaction][myContinent][val]) then
				local myTable = EnhancedFlightMap_TaxiData[myFaction][myContinent][val];
				if ((myTable.mapx) and (myTable.mapy)) then
					buttonCount = buttonCount + 1;
					POI = getglobal("EFM_MAP_POI"..buttonCount);
					POITexture = getglobal("EFM_MAP_POI"..buttonCount.."Icon");

					-- Display the actual POI Button
					if (EFM_KP_CheckPaths(myFaction, myContinent, val)) then
						POITexture:SetTexture("Interface\\TaxiFrame\\UI-Taxi-Icon-Yellow");
					else
						POITexture:SetTexture("Interface\\TaxiFrame\\UI-Taxi-Icon-Gray");
					end

					POI:ClearAllPoints();
					POI:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", myTable.mapx/100*WorldMapButton:GetWidth(), -myTable.mapy/100*WorldMapButton:GetHeight());
					POI:Show();
				
					-- Set the Location Field.
					POI.Location = val;
				end
			end
		end
	end
end

-- Function: POI On Enter
function EFM_MAP_POIOnEnter()
	local px, py = this:GetCenter();
	local wx, wy = WorldMapButton:GetCenter();
	local align = "ANCHOR_LEFT";
	if(px <= wx) then align = "ANCHOR_RIGHT"; end

	WorldMapFrameAreaLabel:SetText(this.Location);
	WorldMapTooltip:SetOwner(this, align);
	WorldMapTooltip:AddLine(this.Location);

	-- Flight path display stuff...
	EFM_MAP_POIPaths(this);

	-- Show the Tooltip
	WorldMapTooltip:Show();
end

-- Function: POI On Leave
function EFM_MAP_POIOnLeave()
	WorldMapTooltip:Hide();
	WorldMapTooltip:SetText("");
end

-- Function: Add co-ordinates for maps
function EFM_MAP_AddLocation(flightNode)
	local myFaction		= UnitFactionGroup("player");
	local myContinent	= GetCurrentMapContinent();

	if (GetCurrentMapZone() ~= 0) then
		if (EnhancedFlightMap_TaxiData[myFaction][myContinent][flightNode]) then
			EnhancedFlightMap_TaxiData[myFaction][myContinent][flightNode].mapx, EnhancedFlightMap_TaxiData[myFaction][myContinent][flightNode].mapy = LYS_GetPlayerCoords();	
		end

		EFM_MapTranslation[myFaction][myContinent][flightNode] = GetCurrentMapZone();
	end
end

-- Function: Add known flight paths to the tooltip information
function EFM_MAP_POIPaths(myPOI)
	local myNode			= myPOI.Location;
	local myFaction			= UnitFactionGroup("player");
	local myContinent		= GetCurrentMapContinent();
	local myLine			= "";
	local flightDuration	= "";
	local flightCost    	= "";

	WorldMapTooltip:AddLine(LYS_COLOURS.WHITE..EFM_MAP_PATHLIST);

	for key, val in pairs(EnhancedFlightMap_TaxiData[myFaction][myContinent][myNode]["routes"]) do
		flightDuration	= "";
		flightCost		= "";

		if (EFM_KP_CheckPaths(myFaction, myContinent, val)) then
			flightColour = LYS_COLOURS.GREEN;
		else
			flightColour = LYS_COLOURS.GREY;
		end

		if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent][myNode]) then
			if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent][myNode][val]) then
				flightDuration = EFM_Timer_FlightDuration(myNode, val);

				flightCost = EFM_Timer_FlightCost(myNode, val);
				if (flightCost > 0) then
					flightCost = LYS_GetTextMoney(flightCost, false);
				else
					flightCost = nil;
				end
			end
		end

		if ((flightDuration) or (flightCost)) then
			if (not flightDuration) then
				flightDuration = "";
			end

			if (not flightCost) then
				flightCost = "                  ";
			end

			myLine = string.format("%s%s %s%s", flightColour, flightDuration, flightCost, LYS_COLOURS.NORMAL);
			WorldMapTooltip:AddDoubleLine(flightColour..val..LYS_COLOURS.NORMAL, myLine);
		else
			WorldMapTooltip:AddLine(flightColour..val..LYS_COLOURS.NORMAL);
		end
	end
end
