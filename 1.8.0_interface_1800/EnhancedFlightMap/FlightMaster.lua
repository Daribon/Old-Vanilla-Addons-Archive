--[[

FlightMaster.lua

The various routines for handling the flight master displays

]]

EFM_OriginalTaxiFrame_OnEvent		= nil;
EFM_OriginalTaxiNodeOnButtonEnter	= nil;
EFM_TaxiOrigin						= "";
EFM_FM_MAXVALUE						= 1000000000;  -- Highest ever conceivable values... if blizzard makes a set of flight times/costs that exceed this... eep!
EFM_TaxiDistantButtonData			= {};

-- Function: Calculate the maximum POI for the taximap poi's, and the path poi's
local function EFM_FM_CalcPOI()
	local buttonPOI = 1;
	local pathPOI	= 1;

	-- Calc the total number of "TaxiButton" POI's
	value = getglobal("TaxiButton"..buttonPOI);
	while( value ) do
		buttonPOI = buttonPOI + 1;
		value = getglobal("TaxiButton"..buttonPOI);
	end
	buttonPOI = buttonPOI - 1;
	
	-- Calc the total number of "EnhancedFlightMapPath" POI's
	value = getglobal("EnhancedFlightMapPath"..pathPOI);
	while( value ) do
		pathPOI = pathPOI + 1;
		value = getglobal("EnhancedFlightMapPath"..pathPOI);
	end
	pathPOI = pathPOI - 1;

	return buttonPOI, pathPOI;
end

-- Function: Check to see if the TaxiNode is already on the map.
function TaxiNodeOnMap(zone)
	local nodes = NumTaxiNodes();
	for i = 1, nodes, 1 do
		if( TaxiNodeName(i) == zone ) then
			return true;
		end
	end
	return false;
end

-- Function: Create table entry for flight node
local function EFM_FM_AddLocation(faction, continent, name, x, y)

	if (not EnhancedFlightMap_TaxiData[faction][continent][name]) then
		EnhancedFlightMap_TaxiData[faction][continent][name]			= {};
		EnhancedFlightMap_TaxiData[faction][continent][name]["x"]		= x;
		EnhancedFlightMap_TaxiData[faction][continent][name]["y"]		= y;
		EnhancedFlightMap_TaxiData[faction][continent][name]["routes"]	= {};
	end

end

-- Function: Add a route to the route table if not already known.
local function EFM_FM_AddLocationRoutes(faction, continent, name, route)
	local myRoutes = EnhancedFlightMap_TaxiData[faction][continent][name]["routes"];

	if (not LYS_StringInTable(myRoutes, route)) then
		table.insert(myRoutes, route);
		DEFAULT_CHAT_FRAME:AddMessage(format(EFM_NEW_NODE, name, route));
	end
end

-- Function: Create the data for the current flight node.  Adding in location, and routing information for the current players known routes.
local function EFM_CheckFlightPoints()
	local num_nodes 	= NumTaxiNodes();
	local nodeTargets	= {};
	local targetx;
	local targety;
	
	local currentFaction	= UnitFactionGroup("player");
	local currentContinent	= GetCurrentMapContinent();
	
	for index = 1, num_nodes, 1 do
		local type		= TaxiNodeGetType(index);
		local button	= getglobal("TaxiButton"..index);
		local nodeName	= TaxiNodeName(index);
		
		local routex, routey = TaxiNodePosition(index);
		EFM_FM_AddLocation(currentFaction, currentContinent, nodeName, routex, routey);

		if ( type == "CURRENT" ) then
			EFM_TaxiOrigin = nodeName;
			EFM_MAP_AddLocation(nodeName);
			EFM_KP_AddLocation(currentFaction, currentContinent, nodeName);

		elseif ( type == "REACHABLE" ) then
			table.insert(nodeTargets, nodeName);
			EFM_KP_AddLocation(currentFaction, currentContinent, nodeName);
		end
	end

	-- Fill in the route data for the node.  The function called validates that the route is not in the table before adding it.
	for index in nodeTargets do
		EFM_FM_AddLocationRoutes(currentFaction, currentContinent, EFM_TaxiOrigin, nodeTargets[index]);
	end
end

-- Function: Display routine when we receive the TAXIMAP_OPENED event.
-- Handles display of the remote flight points, filling in the details for known flight points, and other details.
function EnhancedFlightMap_TaxiFrame_OnEvent()

	if ( event == "TAXIMAP_OPENED" ) then
		-- Make sure the map location is correct (according to wowwiki
		-- this is needed for GetCurrentMapContinent to be correct).
		SetMapToCurrentZone();

		-- Check taxiframe details...
		EFM_CheckFlightPoints();
		
		-- Set the max poi references
		local EFM_FM_MaxButton, EFM_FM_MaxPath = EFM_FM_CalcPOI();

		-- Clear map background
		for routepoi = 1, EFM_FM_MaxPath do
			local tex = getglobal("EnhancedFlightMapPath" .. routepoi);
			tex:Hide();
		end

		local routepoi = 1;
		
		-- Set variables that get used a lot...
		local EFM_Faction	= UnitFactionGroup("player");
		local EFM_Continent = GetCurrentMapContinent();
		local frameWidth	= TaxiRouteMap:GetWidth();
		local frameHeight	= TaxiRouteMap:GetHeight();
	
		-- Clear the seenRoutes variable.
		seenRoutes = {};

		-- Add all distant taxi buttons.
		EFM_TaxiDistantButtonData = {};
		local EFM_FM_LastDistantButton = EFM_FM_MaxButton;

		local skipthis;
		for zone, data in EnhancedFlightMap_TaxiData[EFM_Faction][EFM_Continent] do
			skipthis = false;

			-- Are we allowed to show the druid flight paths
			if (not EFM_Config.DruidPaths) then
				if (string.find(zone, "Nighthaven, Moonglade") ~= nil) then
					skipthis = true;
				end
			end

			-- Are we allowed to show flightpaths unknown to this character?
			if (not EFM_Config.ShowAltPaths) then
				if (not EFM_KP_CheckPaths(EFM_Faction, EFM_Continent, zone)) then
					skipthis = true;
				end
			end

			-- Is it valid for this user and its location?
			if ((not TaxiNodeOnMap(zone)) and (not skipthis))then
				local button	= getglobal("TaxiButton"..EFM_FM_LastDistantButton);
				local buttonID	= button:GetID();

				-- Save the data for this button along with the zone name.
				EFM_TaxiDistantButtonData[buttonID]= {};
				LYS_mergeTable(data, EFM_TaxiDistantButtonData[buttonID]);
				EFM_TaxiDistantButtonData[buttonID]["zone"] = zone;

				-- Display it.
				button:ClearAllPoints();
				button:SetPoint("CENTER", "TaxiMap", "BOTTOMLEFT", data["x"] * frameWidth, data["y"] * frameHeight);
				button:SetNormalTexture("Interface\\TaxiFrame\\UI-Taxi-Icon-Gray");
				button:Show();

				-- Draw Routes on map
				if (data["routes"]) then
					local RouteName;

					for routeNumber in data["routes"] do
						RouteName = data["routes"][routeNumber];

						if (not LYS_StringInTable(seenRoutes, RouteName)) then
							local endPoint = EnhancedFlightMap_TaxiData[EFM_Faction][EFM_Continent][RouteName];
							local myPOI = "EnhancedFlightMapPath"..routepoi;

							if (not EFM_Config.ShowAltPaths) then
								if (EFM_KP_CheckPaths(EFM_Faction, EFM_Continent, RouteName)) then
									LYS_DrawLine("TaxiRouteMap", myPOI, data["x"], data["y"], endPoint["x"], endPoint["y"]);
								end
							else
								LYS_DrawLine("TaxiRouteMap", myPOI, data["x"], data["y"], endPoint["x"], endPoint["y"]);
							end

							routepoi = routepoi + 1;
						end
					end
					table.insert(seenRoutes, zone);
				end

				EFM_FM_LastDistantButton = EFM_FM_LastDistantButton - 1;
			end
		end
	end
end

-- Function: Replacement handler for the TaxiNodeOnButtonEnter function
function EFM_FM_TaxiNodeOnButtonEnter(button)
	local index = button:GetID();
	local data = EFM_TaxiDistantButtonData[index];
	local buttonLocation = TaxiNodeName(index);

	GameTooltip:SetOwner(button, "ANCHOR_RIGHT");

	-- If we're a distant button, draw the distant way.
	if( data ~= nil ) then
		GameTooltip:AddLine(data["zone"], "", 1.0, 1.0, 1.0);
		-- Display the flight times and costs if desired.
		if (EFM_Config.ShowRemotePaths) then
			local myCost, myTime, myPath = EFM_FlightCalc(UnitFactionGroup("player"), GetCurrentMapContinent(), EFM_TaxiOrigin, data["zone"], 0, 0, {});
			if (myPath ~= "INVALID") then
				GameTooltip:AddLine(myPath, "", 1.0, 1.0, 1.0);
				GameTooltip:AddLine(EFM_FT_FLIGHT_TIME..LYS_FormatTime(myTime), "", 1.0, 1.0, 1.0);
				SetTooltipMoney(GameTooltip, myCost);
			end
		end
	else
		-- Otherwise, it's just normal.
		-- Display original information
		-- Doing this ourselves is necessary to add the duration data if known.
		GameTooltip:AddLine(buttonLocation, "", 1.0, 1.0, 1.0);

		local type = TaxiNodeGetType(index);
		if ( type == "REACHABLE" ) then
			-- This next bit is for the duration data.
			if (EFM_Timer_FlightDuration(EFM_TaxiOrigin, buttonLocation) ~= nil) then
				myDuration = EFM_Timer_FlightDuration(EFM_TaxiOrigin, buttonLocation);
				GameTooltip:AddLine(EFM_FT_FLIGHT_TIME..myDuration, "", 0.5, 1.0, 0.5);
			end

			-- With or without the duration data, we still need to know how much this flight will cost us.
			SetTooltipMoney(GameTooltip, TaxiNodeCost(index));

			-- Update the flight cost to this node.
			EFM_Timer_FlightCostUpdate(EFM_TaxiOrigin, buttonLocation, TaxiNodeCost(index));

		elseif ( type == "CURRENT" ) then
			GameTooltip:AddLine(TEXT(TAXINODEYOUAREHERE), "", 0.5, 1.0, 0.5);
		end
	end
	GameTooltip:Show();
end

-- Function: Calculate a remote route cost, time and path.
function EFM_FlightCalc(myFaction, myContinent, curNode, destNode, curCost, curTime, seenRoutes)

	local myRoute = EnhancedFlightMap_TaxiData[myFaction][myContinent][curNode];
	local totalCost = 0;
	local totalTime = 0;
	local totalPath = "";
	local tempNode = "";
	local testedRoutes = {};

	LYS_mergeTable(seenRoutes, testedRoutes);
	table.insert(testedRoutes, curNode);

	for index in myRoute["routes"] do
		tempNode = myRoute["routes"][index];

		if ((EFM_Config.ShowAltPaths) or (EFM_KP_CheckPaths(myFaction, myContinent, tempNode))) then
			if (not LYS_StringInTable(seenRoutes, tempNode)) then
				if (tempNode == destNode) then
					if (EFM_Timer_FlightLength(curNode, destNode) > 0) then
						totalCost = curCost + EFM_Timer_FlightCost(curNode, destNode);
						totalTime = curTime + EFM_Timer_FlightLength(curNode, destNode);
						totalPath = curNode.."\n -> "..destNode;
						return totalCost, totalTime, totalPath;
					end
				end
			end
		end
	end

	local flightCost = EFM_FM_MAXVALUE;
	local flightTime = EFM_FM_MAXVALUE;
	local flightPath = "";

	local tempCost = EFM_FM_MAXVALUE;
	local tempTime = EFM_FM_MAXVALUE;
	tempNode = "";

	for index in myRoute["routes"] do
		tempNode = myRoute["routes"][index];
		tempCost = EFM_FM_MAXVALUE;
		tempTime = EFM_FM_MAXVALUE;

		if (not LYS_StringInTable(seenRoutes, tempNode)) then
			if ((EFM_Config.ShowAltPaths) or (EFM_KP_CheckPaths(myFaction, myContinent, tempNode))) then
				totalCost = curCost + EFM_Timer_FlightCost(curNode, tempNode);
				totalTime = curTime + EFM_Timer_FlightLength(curNode, tempNode);

				tempCost, tempTime, tempPath = EFM_FlightCalc(myFaction, myContinent, tempNode, destNode, totalCost, totalTime, testedRoutes);
				table.insert(testedRoutes, tempNode);

				if ((tempCost ~= 0) and (tempTime ~= 0) and (tempPath ~= "INVALID")) then
					if (EFM_Config.ShowCheapestFlight) then
						if (tempCost < flightCost) then
							flightCost = tempCost;
							flightTime = tempTime;
							flightPath = curNode.."\n -> "..tempPath;
						end
					else
						if (tempTime < flightTime) then
							flightCost = tempCost;
							flightTime = tempTime;
							flightPath = curNode.."\n -> "..tempPath;
						end
					end
				end
			end
		end
	end
	
	if ((flightCost ~= EFM_FM_MAXVALUE) and (flightTime ~= EFM_FM_MAXVALUE)) then
		return flightCost, flightTime, flightPath;
	end

	return 0, 0, "INVALID";
end
