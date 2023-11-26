--
-- CurrentZoneFix v1.1
-- by Legorol
--
-- Fixes a bug in SetMapToCurrentZone()
--
-- The bug:
-- -------
-- When you first log in to the game, SetMapToCurrentZone()
-- doesn't work correctly for a short period and only zooms
-- to the current continent rather than the current zone.
-- This renders many AddOns unusable for a short period after
-- log in, e.g. MapNotes. This also means that if you open the
-- world map you are presented with the continent rather than
-- the zone map.
--
-- The Fix:
-- -------
-- This AddOn fixes this behaviour. The fix is smart, so
-- that once SetMapToCurrentZone() starts behaving normally,
-- the fix turns itself off to avoid unnecessary overhead.
--
-- For coders:
-- ----------
-- Simply copy the CurrentZoneFix_SetupFix() function and use
-- it in your AddOn if you like. It only needs to be called
-- once, best done in an OnLoad function, like it's done here.
-- It detects if the Fix is already present, so multiple AddOns
-- can safely include it.
--

local function CurrentZoneFix_SetupFix()
	if ( CurrentZoneFix_FixInPlace ) then
		return;
	end
	
	local versionID = "1.1";
	local continent,zone,name
	local zoneID={};
	local orig_SetMapToCurrentZone;
	
	for continent in ipairs{GetMapContinents()} do
		for zone,name in ipairs{GetMapZones(continent)} do
			zoneID[name] = zone;
		end
	end
	
	orig_SetMapToCurrentZone = SetMapToCurrentZone;
	SetMapToCurrentZone = function()
		orig_SetMapToCurrentZone();
		if ( GetCurrentMapZone()==0 ) then
			SetMapZoom(GetCurrentMapContinent(),zoneID[GetRealZoneText()]);
		else
			SetMapToCurrentZone = orig_SetMapToCurrentZone;
			CurrentZoneFix_FixInPlace = "deactivated "..versionID;
		end
	end
	
	CurrentZoneFix_FixInPlace = versionID;
end

function CurrentZoneFix_OnLoad()
	ChatFrame1:AddMessage("CurrentZoneFix 1.1 by Legorol");
	CurrentZoneFix_SetupFix()
end
