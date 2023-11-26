--
-- Visible Flight Map - 0.5.0
-- http://home.san.rr.com/kral/WoW/VisibleFlightMap
--
-- Visible Flight Map makes it so that all flight paths and destinations show
-- up on the flight path map, complete with mouse-over support so you can check
-- their names.  Destinations you can't reach from your current location are
-- shaded grey.  It should make it much easier to figure out how to get where
-- you want to go.  No more alt+tabbing to check a map!
--
-- 4/10/2005: 0.5.0 released.
-- This version should be complete for alliance, but has no horde data, yet.
-- Also, this isn't internationalized - it will only work on English versions of
-- WoW.  Could use some help on figuring out how to internationalize it.
--
-- Rosten of Durotan
-- - Rosten <rosten@variadic.org>
--

local VISIBLEFLIGHTMAP_VERSION = "0.5.0";

local TAXI_MAP_WIDTH = 280;
local TAXI_MAP_HEIGHT = 280;
local TAXI_BUTTONS = 64;

local ContinentMaps = {};
ContinentMaps["Alliance"] = {};
ContinentMaps["Horde"] = {};
ContinentMaps["Alliance"][1] = "Interface\\AddOns\\VisibleFlightMap\\alliance-west.tga";
ContinentMaps["Alliance"][2] = "Interface\\AddOns\\VisibleFlightMap\\alliance-east.tga";
ContinentMaps["Horde"][1] = "Interface\\AddOns\\VisibleFlightMap\\horde-west.tga";
ContinentMaps["Horde"][2] = "Interface\\AddOns\\VisibleFlightMap\\horde-east.tga";

local TaxiData = {
	["Southshore, Hillsbrad"] = {
		["y"] = 0.700487,
		["x"] = 0.47862,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Sentinel Hill, Westfall"] = {
		["y"] = 0.245498,
		["x"] = 0.40741,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Theramore, Dustwallow Marsh"] = {
		["y"] = 0.330511,
		["x"] = 0.636261,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Moonglade"] = {
		["y"] = 0.793992,
		["x"] = 0.552823,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Talrendis Point, Azshara"] = {
		["y"] = 0.599073,
		["x"] = 0.610477,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Auberdine, Darkshore"] = {
		["y"] = 0.748208,
		["x"] = 0.427786,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Thelsamar, Loch Modan"] = {
		["y"] = 0.484383,
		["x"] = 0.589393,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Astranaar, Ashenvale"] = {
		["y"] = 0.603835,
		["x"] = 0.462582,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Nijel's Point, Desolace"] = {
		["y"] = 0.493395,
		["x"] = 0.396228,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Light's Hope Chapel, Eastern Plaguelands"] = {
		["y"] = 0.837321,
		["x"] = 0.699995,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Aerie Peak, The Hinterlands"] = {
		["y"] = 0.746146,
		["x"] = 0.546853,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Everlook, Winterspring"] = {
		["y"] = 0.767019,
		["x"] = 0.64554,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Stormwind, Elwynn"] = {
		["y"] = 0.327542,
		["x"] = 0.432504,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Chillwind Camp, Western Plaguelands"] = {
		["y"] = 0.775855,
		["x"] = 0.520581,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Valor's Rest, Silithus"] = {
		["y"] = 0.223823,
		["x"] = 0.463876,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Stonetalon Peak, Stonetalon Mountains"] = {
		["y"] = 0.597828,
		["x"] = 0.390646,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Lakeshire, Redridge"] = {
		["y"] = 0.300541,
		["x"] = 0.557343,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Gadgetzan, Tanaris"] = {
		["y"] = 0.19088,
		["x"] = 0.604133,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Morgan's Vigil, Burning Steppes"] = {
		["y"] = 0.349378,
		["x"] = 0.580601,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Talonbranch Glade, Felwood"] = {
		["y"] = 0.742692,
		["x"] = 0.530809,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Feathermoon, Feralas"] = {
		["y"] = 0.307979,
		["x"] = 0.313531,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Menethil Harbor, Wetlands"] = {
		["y"] = 0.559148,
		["x"] = 0.490907,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Darkshire, Duskwood"] = {
		["y"] = 0.250701,
		["x"] = 0.512853,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Ironforge, Dun Morogh"] = {
		["y"] = 0.511915,
		["x"] = 0.50798,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Booty Bay, Stranglethorn"] = {
		["y"] = 0.0691357,
		["x"] = 0.433677,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Nethergarde Keep, Blasted Lands"] = {
		["y"] = 0.223322,
		["x"] = 0.612595,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
	["Rut'theran Village, Teldrassil"] = {
		["y"] = 0.842793,
		["x"] = 0.416144,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Thalanaar, Feralas"] = {
		["y"] = 0.303127,
		["x"] = 0.482576,
		["faction"] = "Alliance",
		["continent"] = 1,
	},
	["Refuge Pointe, Arathi"] = {
		["y"] = 0.676216,
		["x"] = 0.570359,
		["faction"] = "Alliance",
		["continent"] = 2,
	},
}

local TaxiDistantButtonData = {};

local VisibleFlightMap_OriginalTaxiFrame_OnEvent;
local VisibleFlightMap_OriginalTaxiNodeOnButtonEnter;

function VisibleFlightMap_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
end

function VisibleFlightMap_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		VisibleFlightMap_Init();
	end
end

function VisibleFlightMap_Init()

	-- Hook TaxiFrame_OnEvent.
	VisibleFlightMap_OriginalTaxiFrame_OnEvent = TaxiFrame_OnEvent;
	TaxiFrame_OnEvent = VisibleFlightMap_TaxiFrame_OnEvent;

	-- Hook TaxiNodeOnButtonEnter.
	VisibleFlightMap_OriginalTaxiNodeOnButtonEnter = TaxiNodeOnButtonEnter;
	TaxiNodeOnButtonEnter = VisibleFlightMap_TaxiNodeOnButtonEnter;

	-- DEFAULT_CHAT_FRAME:AddMessage("Visible Flight Map "..VISIBLEFLIGHTMAP_VERSION.." initialized.");
end

function VisibleFlightMap_TaxiFrame_OnEvent(event)

	-- Call the original to set things up for us.
	VisibleFlightMap_OriginalTaxiFrame_OnEvent(event);

	if ( event == "TAXIMAP_OPENED" ) then

		-- Make sure the map location is correct (according to wowwiki
		-- this is needed for GetCurrentMapContinent to be correct).
		SetMapToCurrentZone();

		-- Add the route map.
		TaxiMap:SetTexture(ContinentMaps[UnitFactionGroup("player")][GetCurrentMapContinent()]);
		local xt = TAXI_MAP_WIDTH / 512;
		local yt = TAXI_MAP_HEIGHT / 512;
		TaxiMap:SetTexCoord(0, xt, 0, yt);

		-- Add all distant taxi buttons.
		TaxiDistantButtonData = {};
		local last_distant_button = TAXI_BUTTONS - 1;
		for zone, data in TaxiData do

			-- Is it valid for this user and its location?
			if( data["continent"] == GetCurrentMapContinent() and data["faction"] == UnitFactionGroup("player") and not TaxiNodeOnMap(zone) ) then
				local button = getglobal("TaxiButton"..last_distant_button);

				-- Save the data for this button along with the zone name.
				TaxiDistantButtonData[button:GetID()] = data;
				TaxiDistantButtonData[button:GetID()]["zone"] = zone;

				-- Display it.
				button:ClearAllPoints();
				button:SetPoint("CENTER", "TaxiMap", "BOTTOMLEFT", data["x"] * TAXI_MAP_WIDTH, data["y"] * TAXI_MAP_HEIGHT);
				-- button:SetNormalTexture("Interface\\TaxiFrame\\UI-Taxi-Icon-Gray");
				button:Show();

				last_distant_button = last_distant_button - 1;
			end
		end
	end
end

function VisibleFlightMap_TaxiNodeOnButtonEnter(button)
	local data = TaxiDistantButtonData[button:GetID()];

	-- If we're a distant button, draw the distant way.
	if( data ~= nil ) then
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
		GameTooltip:AddLine(data["zone"], "", 1.0, 1.0, 1.0);
		GameTooltip:Show();

	-- Otherwise, it's just normal.
	else
		VisibleFlightMap_OriginalTaxiNodeOnButtonEnter(button);
	end
end

function TaxiNodeOnMap(zone)
	local nodes = NumTaxiNodes();
	for i = 1, nodes, 1 do
		if( TaxiNodeName(i) == zone ) then
			return true;
		end
	end
	return false;
end