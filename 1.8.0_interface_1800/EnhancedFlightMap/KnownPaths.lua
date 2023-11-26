--[[

KnownPaths.lua

This segment deals with who knows what flight path.

]]

EFM_PLAYER = "unknown";

-- Function: Map Initialization routine
function EFM_KP_Init()	
	-- Find the player name.
	EFM_PLAYER = LYS_GetPlayerRealmName();
end

-- Function: Record that the player knows this flight master.
function EFM_KP_AddLocation(myFaction, myContinent, myNode)
	if (not EFM_KnownPaths[myFaction][myContinent][myNode]) then
		EFM_KnownPaths[myFaction][myContinent][myNode] = {};
	end
	
	if (not LYS_StringInTable(EFM_KnownPaths[myFaction][myContinent][myNode], LYS_GetPlayerRealmName())) then
		table.insert(EFM_KnownPaths[myFaction][myContinent][myNode], LYS_GetPlayerRealmName());
	end
end

-- Function: Check if player knows the flight path, return true if known, false otherwise.
function EFM_KP_CheckPaths(myFaction, myContinent, myNode)
	if (EFM_KnownPaths[myFaction][myContinent][myNode]) then
		if (LYS_StringInTable(EFM_KnownPaths[myFaction][myContinent][myNode], LYS_GetPlayerRealmName())) then
			return true;
		end
	end
	return false;
end
