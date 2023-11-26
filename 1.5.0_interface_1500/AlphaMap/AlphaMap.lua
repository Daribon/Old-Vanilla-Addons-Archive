--	///////////////////////////////////////////////////////////////////////////////////////////
--
--	AlphaMap: A worldmap frame that is transparent and allows character manipulation
--		copyright 2004-2005 by Jeromy Walsh ( DragonWalsh@yahoo.com )
--
--	Official Site: AlphaMap has popped up on a number of related websites. This is great news!! But for the
--          latest and greatest version, check the following URL: http://www.curse-gaming.com/mod.php?addid=190
--
--	Contributions: Part of the code for this is adapted from WorldMapFrame.xml and OpacitySliderFrame.xml
--		of the original Blizzard(tm) Entertainment distribution.
--
--	3rd Party Components: Part of the code is taken from MapNotes, MapNotes Gathering, and Gatherer.  This
--		is done to provide optional support for those addons.
--
-- 	Other Contributors: I'd like to thank "Ska Demon" of the Curse Gaming forums for helping me make v1.3
--		as good as it is.  Ska provided the base code for the slash commands to set various parameters,
--		as well as provided the base code to save variables between WoW sessions.  Finally, Ska
--		provided the code to scale the AlphaMap via a slash command.
--
--	Special Thanks: Special thanks to Ska Demon for keeping AlphaMap alive during my busy schedule.
--		Also thanks to my wife Lindsey Walsh, for putting up with me during the midnight coding sessions.
--
--	License: You are hereby authorized to freely modify and/or distribute all files of this add-on, in whole or in part,
--		providing that this header stays intact, and that you do not claim ownership of this Add-on.
--
--		Additionally, the original owner wishes to be notified by email if you make any improvements to this add-on.
--		Any positive alterations will be added to a future release, and any contributing authors will be
--		identified in the section above.
--
--	Features:
--
--         v1.3.1 - Removed all references to the worldmap POI's - some other addon was conflicting
--         v1.3.0 - A large number of slash commands, usable via /AlphaMap or /am
--                - Every slash command setting is stored between WoW usage
--                - Raid Pins Shown ( togglable via /am raid )
--                - Optional Tooltips on Pins ( Party/Raid, MapNotes, Gatherer, and MapNotes Gathering )
--                - Tooltips Togglable via /am ptips, /am mntips, /am gtips, /am mngtips
--                - Slider is moveable and lockable via /am moveslider
--                - Optionally Show Slider via /am slider
--                - Optional Support for Gatherer 1.9.12 (1300) via /am gatherer
--                - Optional Support for MapNotes 0.5.4 (4196)  via /am mapnotes
--                - Optional Support for MapNotes Gathering 0.5.6 (4150) via /am gathering
--                - Optionally Close AlphaMap when entering combat via /am combat
--                - Optionally Close Alphamap when world map closes via /am wmclose
--                - Moveable AlphaMap; move by dragging along the top border - lockable via /lock
--                - Scaleable AlphaMap via /am scale <value>
--                - AlphaMap togglable via /am tog
--                - AlphaMap alpha settable through /am alpha <value>
--                - Alpha value is saved between sessions
--                - Fixed a bug allowing you to set a scale < 0
--                - Fixed a bug allowing you to set alpha < 0 or > 1
--                - Fixed a bug caused by 1300 where GetMapLandmarkInfo returned an extra parameter
--         v1.2.1 - Fixed a bug causing AlphaMap to be closely tied to MapNotes
--         v1.2.0 - Automatic update of AlphaMap on zone change
--                - Now displays "Point of Interest" flags, such as set by guards
--                - Now displays "MapNotes" pins, until they change something with MapNotes that breaks AlphaMap
--                - Player pin is now shown as an arrow, indicating direction
--                - Added Hotkey assignment to Increment/Decrement map alpha by 10%
--                - Added player's coordinates near the top right of the AlphaMap. (Under the minimap in standard resolutions)
--         v1.1.0 - Fixed a bug with markers not becoming transparent when alpha is set to 0
--                - Player Corpse is now shown on AlphaMap
--         v1.0.0 - Displays a slider in the lower left corner that can be used to set window opacity
--         v0.9.0 - Displays the worldmap in a large, semi-transparent, non-movable window
--
--	///////////////////////////////////////////////////////////////////////////////////////////

NUM_ALPHAMAP_DETAIL_TILES	= 12;
NUM_ALPHAMAP_OVERLAYS		= 40;
NUM_ALPHAMAP_POIS			= 32;

ALPHAMAP_POI_TEXTURE_WIDTH	= 64;
NUM_ALPHAMAP_POI_COLUMNS	= 4;
NUM_ALPHAMAP_MAPNOTE_POIS	  = 100;
NUM_ALPHAMAP_GATHERNOTE_POIS  = 200;

ALPHAMAP_INCREMENT		      = 0.10;

BINDING_HEADER_ALPHAMAP        = "AlphaMap Key Bindings";
BINDING_NAME_TOGGLEALPHAMAP    = "Toggle AlphaMap";
BINDING_NAME_INCREMENTALPHAMAP = "Increase AlphaMap Opacity";
BINDING_NAME_DECREMENTALPHAMAP = "Decrease AlphaMap Opacity";

AlphaMapConfig = { alpha = 0.5, scale = 0.8, lock = false, combat = true,
				   ptips = true, gtips = false, mntips = false, mngtips = false,
				   wmclose = true, gathering = false, gatherer = false, mapnotes = false,
				   raid = true, sliderlock = true, slider = true };

-- This makes it so you can close the AlphaMap by hitting the ESC key
-- But if used, the world map will not open with AlphaMap open
-- UIPanelWindows["AlphaMapFrame"] = { area = "center", pushable = 0 };

-- Called whenever AlphaMap is loaded
function AlphaMapFrame_OnLoad()
	SlashCmdList["ALPHAMAPSLASH"] = AlphaMap_Main_ChatCommandHandler;
	SLASH_ALPHAMAPSLASH1 = "/AlphaMap";
	SLASH_ALPHAMAPSLASH2 = "/am";

	this:RegisterEvent( "WORLD_MAP_UPDATE" );
	this:RegisterEvent( "ZONE_CHANGED_NEW_AREA" );
	this:RegisterEvent( "VARIABLES_LOADED" );
	this:RegisterEvent( "PLAYER_REGEN_DISABLED" );

	RegisterForSave("AlphaMapConfig");

	AlphaMapFrame_Update();
end

AlphaMap_LoadCount = 0;

-- Called whenever AlphaMap is sent an event notification
function AlphaMapFrame_OnEvent()
	if ( event == "WORLD_MAP_UPDATE" ) then
		AlphaMapFrame_Update();

	elseif( event == "ZONE_CHANGED_NEW_AREA" ) then
		SetMapToCurrentZone();

	elseif ( event == "PLAYER_REGEN_DISABLED" and AlphaMapConfig.combat == true ) then
		HideUIPanel(this);

	elseif( event == "VARIABLES_LOADED") then

		AlphaMap_LoadCount = AlphaMap_LoadCount + 1;

		-- DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Variables Loaded!" );

		if( not AlphaMapConfig.alpha ) then
			AlphaMapConfig.alpha = 0.5;
		end

		if( not AlphaMapConfig.scale ) then
			AlphaMapConfig.scale = 0.8;
		end

		if( AlphaMapConfig.lock == nil ) then
			AlphaMapConfig.lock = false;
		end

		if( AlphaMapConfig.combat  == nil ) then
			AlphaMapConfig.combat = true;
		end

		if( AlphaMapConfig.ptips  == nil ) then
			AlphaMapConfig.ptips = true;
		end

		if( AlphaMapConfig.gtips  == nil ) then
			AlphaMapConfig.gtips = false;
		end

		if( AlphaMapConfig.mntips  == nil ) then
			AlphaMapConfig.mntips = false;
		end

		if( AlphaMapConfig.mngtips  == nil ) then
			AlphaMapConfig.mngtips = false;
		end

		if( AlphaMapConfig.wmclose  == nil ) then
			AlphaMapConfig.wmclose = true;
		end

		if( AlphaMapConfig.gathering  == nil ) then
			AlphaMapConfig.gathering = false;
		end

		if( AlphaMapConfig.gatherer  == nil ) then
			AlphaMapConfig.gatherer = false;
		end

		if( AlphaMapConfig.mapnotes  == nil ) then
			AlphaMapConfig.mapnotes = false;
		end

		if( AlphaMapConfig.raid  == nil ) then
			AlphaMapConfig.raid = true;
		end

		if( AlphaMapConfig.sliderlock  == nil ) then
			AlphaMapConfig.sliderlock = true;
		end

		if( AlphaMapConfig.slider == nil ) then
			AlphaMapConfig.slider = true;
		end

		if( AlphaMapConfig.slider == false ) then
			HideUIPanel( AlphaMapSliderFrame );
		end

		AlphaMapDetailFrame:SetAlpha( AlphaMapConfig.alpha );
		AlphaMapSliderFrame:SetValue( 1 - AlphaMapConfig.alpha );
	end
end


-- Helper function to compute UV coords to draw pins
function AlphaMap_GetPOITextureCoords( index )
	local alphaMapIconDimension = AlphaMapPOI1Texture:GetWidth();
	local xCoord1, xCoord2, yCoord1, yCoord2;
	local coordIncrement = alphaMapIconDimension / ALPHAMAP_POI_TEXTURE_WIDTH;

	xCoord1 = mod(index , NUM_ALPHAMAP_POI_COLUMNS) * coordIncrement;
	xCoord2 = xCoord1 + coordIncrement;
	yCoord1 = floor(index / NUM_ALPHAMAP_POI_COLUMNS) * coordIncrement;
	yCoord2 = yCoord1 + coordIncrement;

	return xCoord1, xCoord2, yCoord1, yCoord2;
end


-- Called every frame to update the AlphaMap
function AlphaMapFrame_Update()
	local mapFileName, textureHeight = GetMapInfo();

	if ( not mapFileName ) then
		mapFileName = "World";
	end

	for i=1, NUM_ALPHAMAP_DETAIL_TILES, 1 do
		getglobal("AlphaMapDetailTile"..i):SetTexture("Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName..i);
	end

	-- Setup the POI's
	-- This should be moved out of here
	local numPOIs = GetNumMapLandmarks();
	local name, textureIndex, x, y;
	local alphaMapPOI;
	local x1, x2, y1, y2;

	-- Iterate through each of the Points of interest
	for i=1, NUM_ALPHAMAP_POIS, 1 do

		-- Get the current point of interest
		alphaMapPOI = getglobal( "AlphaMapPOI"..i );

		-- Check if the current POI is a valid POI
		if ( i <= numPOIs ) then
			name, description, textureIndex, x, y = GetMapLandmarkInfo( i );
			x1, x2, y1, y2 = AlphaMap_GetPOITextureCoords( textureIndex );

			-- Set the texture coordinates
			getglobal( alphaMapPOI:GetName().."Texture" ):SetTexCoord( x1, x2, y1, y2 );
			x =  x * AlphaMapUnits:GetWidth();
			y = -y * AlphaMapUnits:GetHeight();

			alphaMapPOI:SetPoint( "CENTER", "AlphaMapUnits", "TOPLEFT", x, y );
			alphaMapPOI.name = name;
			alphaMapPOI:Show();
		else
			alphaMapPOI:Hide();
		end
	end

	-- Overlay stuff
	local numOverlays = GetNumMapOverlays();
	local textureName, textureWidth, textureHeight, offsetX, offsetY, mapPointX, mapPointY;
	local textureCount = 1;
	local texture;
	local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight;
	local numTexturesWide, numTexturesTall;

	for i=1, numOverlays do
		textureName, textureWidth, textureHeight, offsetX, offsetY, mapPointX, mapPointY = GetMapOverlayInfo(i);
		numTexturesWide = ceil(textureWidth/256);
		numTexturesTall = ceil(textureHeight/256);

		for j=1, numTexturesTall do
			if ( j < numTexturesTall ) then
				texturePixelHeight = 256;
				textureFileHeight = 256;
			else
				texturePixelHeight = mod(textureHeight, 256);
				if ( texturePixelHeight == 0 ) then
					texturePixelHeight = 256;
				end
				textureFileHeight = 16;
				while(textureFileHeight < texturePixelHeight) do
					textureFileHeight = textureFileHeight * 2;
				end
			end
			for k=1, numTexturesWide do
				if ( textureCount > NUM_ALPHAMAP_OVERLAYS ) then
					message("Too many worldmap overlays!");
					return;
				end
				texture = getglobal("AlphaMapOverlay"..textureCount);
				if ( k < numTexturesWide ) then
					texturePixelWidth = 256;
					textureFileWidth = 256;
				else
					texturePixelWidth = mod(textureWidth, 256);
					if ( texturePixelWidth == 0 ) then
						texturePixelWidth = 256;
					end
					textureFileWidth = 16;
					while(textureFileWidth < texturePixelWidth) do
						textureFileWidth = textureFileWidth * 2;
					end
				end
				texture:SetWidth(texturePixelWidth);
				texture:SetHeight(texturePixelHeight);
				texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight);
				texture:ClearAllPoints();
				texture:SetPoint("TOPLEFT", "AlphaMapDetailFrame", "TOPLEFT", offsetX + (256 * (k-1)), -(offsetY + (256 * (j - 1))));
				texture:SetTexture(textureName..(((j - 1) * numTexturesWide) + k));
				texture:Show();
				textureCount = textureCount +1;
			end
		end
	end
	for i=textureCount, NUM_ALPHAMAP_OVERLAYS do
		getglobal("AlphaMapOverlay"..i):Hide();
	end

	if( AlphaMapConfig.scale ) then
		AlphaMapFrame:SetScale( AlphaMapConfig.scale );
	end
end


-- Called to toggle visibility of the AlphaMap
function ToggleAlphaMap()
	if ( AlphaMapFrame:IsVisible() ) then
		AlphaMapFrame.UserHidden = true;
		HideUIPanel( AlphaMapFrame );
	else
		SetupWorldMapScale();
		ShowUIPanel( AlphaMapFrame );
	end
end

function ToggleSlider()
	if ( AlphaMapSliderFrame:IsVisible() ) then
		HideUIPanel( AlphaMapSliderFrame );
		AlphaMapConfig.slider = false;
	else
		ShowUIPanel( AlphaMapSliderFrame );
		AlphaMapConfig.slider = true;
	end
end

-- Helper function to increment the opacity by .10
function IncrementAlphaMap()

	-- Get the frames
	alphaMapDetailFrame = getglobal( "AlphaMapDetailFrame" );
	alphaMapSliderFrame = getglobal( "AlphaMapSliderFrame" );

	-- Determine the transparency from the alpha slider
	local alpha = 1.0 - alphaMapSliderFrame:GetValue();

	-- Increment the opacity
	alpha = alpha + ALPHAMAP_INCREMENT;

	-- Clamp the opacity to 1.0
	if( alpha > 1.0 ) then
		alpha = 1.0;
	end

	alphaMapDetailFrame:SetAlpha( alpha );
	alphaMapSliderFrame:SetValue( 1 - alpha );

	AlphaMapConfig.alpha = alpha;

	-- If there is 1 alpha, then hide the markers
	if( alpha == 0.0 ) then
		alphaMapUnits:Hide();
	else
		alphaMapUnits:Show();
	end
end


-- Helper function to decrement the opacity by .10
function DecrementAlphaMap()

	-- Get the frames
	alphaMapDetailFrame = getglobal( "AlphaMapDetailFrame" );
	alphaMapSliderFrame = getglobal( "AlphaMapSliderFrame" );

	-- Determine the transparency from the alpha slider
	local alpha = 1.0 - alphaMapSliderFrame:GetValue();

	-- Increment the opacity
	alpha = alpha - ALPHAMAP_INCREMENT;

	-- Clamp the opacity to 0.0
	if( alpha < 0.0 ) then
		alpha = 0.0;
	end

	AlphaMapConfig.alpha = alpha;

	alphaMapDetailFrame:SetAlpha( alpha );
	alphaMapSliderFrame:SetValue( 1 - alpha );

	-- If there is 1 alpha, then hide the markers
	if( alpha == 0.0 ) then
		alphaMapUnits:Hide();
	else
		alphaMapUnits:Show();
	end
end


-- Called every frame to update the pin overlays on the AlphaMap
function AlphaMapUnits_OnUpdate()

	-- Get Zone/Continent Info
	local zone		= GetCurrentMapZone();
	local continent = GetCurrentMapContinent();

	--Position player
	local playerX, playerY = GetPlayerMapPosition("player");
	if ( playerX == 0 and playerY == 0 ) then
		AlphaMapMinimap:Hide();
	else
		playerX = playerX *  AlphaMapDetailFrame:GetWidth();
		playerY = -playerY * AlphaMapDetailFrame:GetHeight();

		AlphaMapMinimap:SetPoint("CENTER", "AlphaMapDetailFrame", "TOPLEFT", playerX, playerY);
		AlphaMapMinimap:Show();
	end

	-- Update Position info
	playerX, playerY = GetPlayerMapPosition("player");
	AlphaMapLocationText:SetText( format( "%d, %d", playerX * 100.0, playerY * 100.0) );

	--Position groupmates
	local partyX, partyY, partyMemberFrame;
	if( GetNumRaidMembers() > 0 and AlphaMapConfig.raid == true ) then
		for i=1, MAX_PARTY_MEMBERS do
			partyMemberFrame = getglobal("AlphaMapParty"..i);
			partyMemberFrame:Hide();
		end
		for i=1, MAX_RAID_MEMBERS do
			partyX, partyY = GetPlayerMapPosition( "raid"..i );
			partyMemberFrame = getglobal( "AlphaMapRaid"..i );
			if ( partyX == 0 and partyY == 0 or UnitIsUnit( "raid"..i, "player" ) ) then
				partyMemberFrame:Hide();
			else
				partyX =  partyX * AlphaMapDetailFrame:GetWidth();
				partyY = -partyY * AlphaMapDetailFrame:GetHeight();
				partyMemberFrame:SetPoint( "CENTER", "AlphaMapDetailFrame", "TOPLEFT", partyX, partyY);
				partyMemberFrame:Show();
			end
		end
	else
		for i=1, MAX_PARTY_MEMBERS do
			partyX, partyY = GetPlayerMapPosition("party"..i);
			partyMemberFrame = getglobal("AlphaMapParty"..i);
			if ( partyX == 0 and partyY == 0 ) then
				partyMemberFrame:Hide();
			else
				partyX = partyX * AlphaMapDetailFrame:GetWidth();
				partyY = -partyY * AlphaMapDetailFrame:GetHeight();
				partyMemberFrame:SetPoint("CENTER", "AlphaMapDetailFrame", "TOPLEFT", partyX, partyY);
				partyMemberFrame:Show();
			end
		end
		for i=1, MAX_RAID_MEMBERS do
			partyMemberFrame = getglobal("AlphaMapRaid"..i);
			partyMemberFrame:Hide();
		end
	end

	--Position corpse
	local corpseX, corpseY = GetCorpseMapPosition();
	if ( corpseX == 0 and corpseY == 0 ) then
		AlphaMapCorpse:Hide();
	else
		corpseX = corpseX * AlphaMapDetailFrame:GetWidth();
		corpseY = -corpseY * AlphaMapDetailFrame:GetHeight();

		AlphaMapCorpse:SetPoint("CENTER", "AlphaMapDetailFrame", "TOPLEFT", corpseX, corpseY);
		AlphaMapCorpse:Show();
	end

	-- /////////////////////////////////////////////////////////////////
	-- MapNotes 0.5.3 Pins
	-- ////////////////////////////////////////////////////////////////

	-- Check if we're in a valid zone and MapNotes is active
	if( zone ~= 0 and MapNotes_Options and AlphaMapConfig.mapnotes == true ) then
		local n = 1;

		-- Iterate through the saved MapNotes
		for i, value in MapNotes_Data[continent][zone] do

			local temp = getglobal( "AlphaMapNotesPOI"..i );
			temp:SetPoint("CENTER", "AlphaMapDetailFrame", "TOPLEFT", ( MapNotes_Data[continent][zone][i].xPos)*AlphaMapDetailFrame:GetWidth(), -(MapNotes_Data[continent][zone][i].yPos)*AlphaMapDetailFrame:GetHeight() );

			local myTexture = getglobal( "AlphaMapNotesPOI"..i.."Texture" );
			myTexture:SetTexture( "Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_Data[continent][zone][i].icon );

			if( MapNotes_Options[ MapNotes_Data[continent][zone][i].icon ] ~= "off" and ((MapNotes_Options[10] ~= "off" and MapNotes_Data[continent][zone][i].creator == UnitName("player")) or (MapNotes_Options[11] ~= "off" and MapNotes_Data[continent][zone][i].creator ~= UnitName("player")))) then
				temp:Show();
			else
				temp:Hide();
			end
			n = n + 1;
		end

		-- Hide all the others
		for i=n, NUM_ALPHAMAP_MAPNOTE_POIS, 1 do
			getglobal( "AlphaMapNotesPOI"..i ):Hide();
			end
	else
		for i=1, NUM_ALPHAMAP_MAPNOTE_POIS, 1 do
			getglobal("AlphaMapNotesPOI"..i):Hide();
		end
	end

	-- ////////////////////////////////////////////////////////////////
	-- MapNotes Gathering 0.5.6 Pins
	-- ////////////////////////////////////////////////////////////////

	if( zone ~= 0 and MapNotesGathering_Data and AlphaMapConfig.gathering == true ) then
		for i=1, getn( MapNotesGathering_Data[continent][zone] ), 1 do

			local temp = getglobal( "AlphaMapGatheringPOI"..i );
			local icon = MapNotesGathering_Data[continent][zone][i].icon;

			if (icon ~= nil and icon ~= 0) then --workaround for the bug in the first version...
				if ((MapNotes_Options.showherbs and icon > 9 and icon <= 38 and
				    MapNotes_Options["Gathering"][icon] ~= "off") or
				    (MapNotes_Options.showveins and icon <= 9 and
				    MapNotes_Options["Gathering"][icon] ~= "off") or
				    (MapNotes_Options.showchests and icon >= 39)) then
					temp:SetPoint("CENTER", "AlphaMapDetailFrame", "TOPLEFT", (MapNotesGathering_Data[continent][zone][i].xPos)*AlphaMapDetailFrame:GetWidth(), -(MapNotesGathering_Data[continent][zone][i].yPos)*AlphaMapDetailFrame:GetHeight());
					getglobal("AlphaMapGatheringPOI"..i.."Texture"):SetTexture("Interface\\AddOns\\MapNotesGathering\\POIIcons\\Icon"..icon);
					temp:Show();
				else
					temp:Hide();
				end
			else
				temp:Hide();
			end
		end
		for i=(getn( MapNotesGathering_Data[continent][zone])+1 ), NUM_ALPHAMAP_GATHERNOTE_POIS, 1 do
			getglobal("AlphaMapGatheringPOI"..i):Hide();
		end
	else
		for i=1, NUM_ALPHAMAP_GATHERNOTE_POIS, 1 do
			getglobal("AlphaMapGatheringPOI"..i):Hide();
		end
	end

	-- ////////////////////////////////////////////////////////////////
	-- Gatherer 1.9.12 Pins
	-- ////////////////////////////////////////////////////////////////

	DrawAlphaMapGatherer();

end


-- Helper function to set the opacity of the AlphaMap
function SetAlphaMapOpacity()

	-- Get the frames
	alphaMapDetailFrame = getglobal( "AlphaMapDetailFrame" );
	alphaMapUnits       = getglobal( "AlphaMapUnits" );

	-- Determine the transparency from the alpha slider
	local alpha = 1.0 - this:GetValue();
	alphaMapDetailFrame:SetAlpha( alpha );

	-- If there is 1 alpha, then hide the markers
	if( alpha == 0.0 ) then
		alphaMapUnits:Hide();
	else
		alphaMapUnits:Show();
	end

	AlphaMapConfig.alpha = alpha;
end

-- Function to extract the next param from the command line
function AlphaMap_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end

-- Function to handle slash commands
function AlphaMap_Main_ChatCommandHandler(msg)
	local commandName, params = AlphaMap_Extract_NextParameter(msg);
	if ((commandName) and (strlen(commandName) > 0)) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end

	-- Check if we should toggle on/off the AlphaMap
	if( strfind( commandName, "tog" ) ) then
		ToggleAlphaMap();

	-- Check if we should lock the UI
	elseif( strfind( commandName, "lock" ) ) then

		AlphaMapConfig.lock = not AlphaMapConfig.lock;

		 if( AlphaMapConfig.lock == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: User Interface Locked" );
		 else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: User Interface Unlocked" );
		 end

	-- Check if we should scale the window
	elseif( strfind( commandName, "scale" ) ) then
		AlphaMapConfig.scale = tonumber(params);

		if( not AlphaMapConfig.scale or AlphaMapConfig.scale < 0.0 ) then
			AlphaMapConfig.scale = 1.0;
		end

		AlphaMapFrame:SetScale( AlphaMapConfig.scale );

	-- Check if we should allow movement of the slider
	-- NOTE: This must be checked BEFORE "slider"
	elseif( strfind(commandName, "moveslider" ) ) then
		AlphaMapConfig.sliderlock = not AlphaMapConfig.sliderlock;

		if( AlphaMapConfig.sliderlock == false ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Slider Movement Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Slider Movement Disabled" );
		end

	-- Check if we should Toggle on/off display of the slider
	elseif (strfind(commandName, "slider")) then
		 ToggleSlider();

	--  Check if we should autoclose AM on combat
	elseif (strfind(commandName, "combat")) then
		 AlphaMapConfig.combat = not AlphaMapConfig.combat;

		 if( AlphaMapConfig.combat == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: AutoClose on Combat Enabled" );
		 else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: AutoClose on Combat Disabled" );
		 end

	--  Check if we should show raid pins
	elseif (strfind(commandName, "raid")) then
		 AlphaMapConfig.raid = not AlphaMapConfig.raid;

		 if( AlphaMapConfig.raid == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Raid Pins Enabled" );
		 else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Raid Pins Disabled" );
		 end

	-- check if we should display party/raid tooltips
	elseif (strfind(commandName, "ptips")) then
		AlphaMapConfig.ptips = not AlphaMapConfig.ptips;

		if( AlphaMapConfig.ptips == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Party/Raid ToolTips Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Party/Raid ToolTips Disabled" );
		end

	-- check if we should display Gatherer tooltips
	elseif( strfind( commandName, "mntips" ) ) then
		AlphaMapConfig.mntips = not AlphaMapConfig.mntips;

		if( AlphaMapConfig.mntips == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes ToolTips Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes ToolTips Disabled" );
		end

	-- check if we should display Gatherer tooltips
	elseif( strfind( commandName, "mngtips" ) ) then
		AlphaMapConfig.mngtips = not AlphaMapConfig.mngtips;

		if( AlphaMapConfig.mngtips == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes Gathering ToolTips Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes Gathering ToolTips Disabled" );
		end

	-- check if we should display Gatherer tooltips
	elseif (strfind(commandName, "gtips")) then
		AlphaMapConfig.gtips = not AlphaMapConfig.gtips;

		if( AlphaMapConfig.gtips == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Gatherer ToolTips Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Gatherer ToolTips Disabled" );
		end

	-- Check if we should set the alpha
	elseif (strfind(commandName, "alpha")) then
		AlphaMapConfig.alpha = tonumber(params);

		if( not AlphaMapConfig.alpha or AlphaMapConfig.alpha < 0 ) then
			AlphaMapConfig.alpha = 0.0;
		end

		if( AlphaMapConfig.alpha > 1.0 ) then
			AlphaMapConfig.alpha = 1.0;
		end

		AlphaMapDetailFrame:SetAlpha( AlphaMapConfig.alpha );
		AlphaMapSliderFrame:SetValue( 1 - AlphaMapConfig.alpha );


	-- Check if we should close AlphaMap when the World Map Closes
	elseif (strfind(commandName, "wmclose")) then
		AlphaMapConfig.wmclose = not AlphaMapConfig.wmclose;

		if( AlphaMapConfig.wmclose == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Close on WorldMap Close Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Close on WorldMap Close Disabled" );
		end

	-- Check if we should show MapNotes Gathering Pins
	elseif (strfind(commandName, "gathering")) then
		AlphaMapConfig.gathering = not AlphaMapConfig.gathering;

		if( AlphaMapConfig.gathering == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes Gathering Support Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes Gathering Support Disabled" );
		end

	-- Check if we should show Gatherer Pins
	elseif (strfind(commandName, "gatherer")) then
		AlphaMapConfig.gatherer = not AlphaMapConfig.gatherer;

		if( AlphaMapConfig.gatherer == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Gatherer Support Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: Gatherer Support Disabled" );
		end

	-- Check if we should show MapNotes Pins
	elseif (strfind(commandName, "mapnotes")) then
		AlphaMapConfig.mapnotes = not AlphaMapConfig.mapnotes;

		if( AlphaMapConfig.mapnotes == true ) then
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes Support Enabled" );
		else
			DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: MapNotes Support Disabled" );
		end

	else
		-- If all else fails, output the help info
		--DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap: /am [tog/lock/scale/slider/alpha/combat/ptips/wmclose/gatherer/gathering/mapnotes]" );

		DEFAULT_CHAT_FRAME:AddMessage( "AlphaMap Usage: /alphamap or /am:" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am raid - show Raid Pins" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am ptips - show party tooltips" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am mntips - show MapNotes tips" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am gtips - show Gatherer tips" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am mngtips - show MapNotes Gathering tips" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am moveslider - toggle movement of the slider" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am slider - toggle display of slider" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am gatherer - toggle support for Gatherer" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am mapnotes - toggle support for MapNotes" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am gathering - toggle support for MapNotes Gathering" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am combat - toggle Autoclose on Combat" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am wmclose - toggle Autoclose on WorldMap close" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am lock - toggle movement of the AlphaMap" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am scale <value> - set the alphamap window scale" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am tog - toggle display of alphamap" );
		DEFAULT_CHAT_FRAME:AddMessage( "/am alpha <value> - set the transparency of alphamap in a range from 0.0 - 1.0" );
	end
end


function DrawAlphaMapGatherer()

	local maxNotes = 500;
	local i = 1;

	if( GatherConfig and GatherConfig.useMainmap and AlphaMapConfig.gatherer == true ) then

		-- Get Current Conteninent and Zone
		local mapContinent  = GetCurrentMapContinent();
		local mapZone		= GetCurrentMapZone();

		if ((mapContinent ~= 0) and (mapZone ~= 0) and ( GatherItems[mapContinent] ) and
				( GatherItems[mapContinent][mapZone] )) then

			-- Iterate through all the pins in the current zone
			for gatherName, gatherData in GatherItems[mapContinent][mapZone] do

				local gatherType   = "Default";
				local specificType = "";
				local allowed      = true;

				-- Check for specific types
				specificType = Gatherer_FindOreType(gatherName);
				if (specificType) then
					gatherType = "Ore";
					allowed = Gatherer_GetFilter("mining");
				else
					specificType = Gatherer_FindTreasureType(gatherName);
					if (specificType) then
						gatherType = "Treasure";
						allowed = Gatherer_GetFilter("treasure");
					else
						specificType = gatherName;
						gatherType = "Herb";
						allowed = Gatherer_GetFilter("herbs");
					end
				end

				if( not specificType ) then
					specificType = "default";
				end

				if( allowed ) then
					for hPos, gatherInfo in gatherData do
						if ((gatherInfo.x)   and (gatherInfo.y) and (gatherInfo.x>0) and
						    (gatherInfo.y>0) and ( i <= maxNotes)) then

							-- Get the frame
							local mainNote = getglobal( "AlphaMapGathererPOI"..i );

							-- Determine coordinates for note
							local mnX,mnY;
							mnX =  gatherInfo.x / 100 * AlphaMapDetailFrame:GetWidth();
							mnY = -gatherInfo.y / 100 * AlphaMapDetailFrame:GetHeight();

							-- Set note properties
							--mainNote:SetAlpha(0.8);
							mainNote:SetPoint( "CENTER", "AlphaMapDetailFrame", "TOPLEFT", mnX, mnY );
							mainNote:SetFrameLevel( this:GetFrameLevel() + 1 );
							mainNote.toolTip = Gatherer_TitleCase(specificType);

							if( not Gather_IconSet["iconic"][gatherType] ) then
								gatherType = "Default";
							end

							local texture = Gather_IconSet["iconic"][gatherType][specificType];
							if( not texture ) then
								texture = Gather_IconSet["iconic"][gatherType]["default"];
							end

							local gathererTexture = getglobal( "AlphaMapGathererPOI"..i.."Texture" );
							gathererTexture:SetTexture( texture );

							mainNote:Show();

							i = i + 1;
						end
					end
				end
			end
		end
	end
	for j=i, maxNotes, 1 do
		local mainNote = getglobal( "AlphaMapGathererPOI"..j );
		mainNote:Hide();
	end
end



function AlphaMapNotes_OnEnter( id )

	if( MapNotes_Options and AlphaMapConfig.mntips == true ) then

		local x, y = this:GetCenter();
		local parentX, parentY = this:GetParent():GetCenter();

		if( x > parentX ) then
			AlphaMapTooltip:SetOwner( this, "ANCHOR_LEFT" );
		else
			AlphaMapTooltip:SetOwner( this, "ANCHOR_RIGHT" );
		end

		local zone		= MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];
		local continent = GetCurrentMapContinent();
		local cNr		= MapNotes_Data[continent][zone][id].ncol;

		AlphaMapTooltip:SetText( MapNotes_Data[continent][zone][id].name, MapNotes_Colors[cNr].r, MapNotes_Colors[cNr].g, MapNotes_Colors[cNr].b);

		if ((MapNotes_Data[continent][zone][id].inf1 ~= nil) and (MapNotes_Data[continent][zone][id].inf1 ~= "")) then
			cNr = MapNotes_Data[continent][zone][id].in1c;
			AlphaMapTooltip:AddLine(MapNotes_Data[continent][zone][id].inf1, MapNotes_Colors[cNr].r, MapNotes_Colors[cNr].g, MapNotes_Colors[cNr].b);
		end
		if ((MapNotes_Data[continent][zone][id].inf2 ~= nil) and (MapNotes_Data[continent][zone][id].inf2 ~= "")) then
			cNr = MapNotes_Data[continent][zone][id].in2c;
			AlphaMapTooltip:AddLine(MapNotes_Data[continent][zone][id].inf2, MapNotes_Colors[cNr].r, MapNotes_Colors[cNr].g, MapNotes_Colors[cNr].b);
		end

		AlphaMapTooltip:AddDoubleLine( MAPNOTES_CREATEDBY, MapNotes_Data[continent][zone][id].creator, 0.49, 0.39, 0.0, 0.49, 0.39, 0.0 );
		AlphaMapTooltip:Show();
	end
end

function AlphaMapNotes_OnLeave( id )
	AlphaMapTooltip:Hide();
end



function AlphaNotesGathering_OnEnter(id)

	if( MapNotesGathering_Data and AlphaMapConfig.gathering == true ) then

		local x, y = this:GetCenter();
		local parentX, parentY = this:GetParent():GetCenter();

		if( x > parentX ) then
			AlphaMapTooltip:SetOwner( this, "ANCHOR_LEFT" );
		else
			AlphaMapTooltip:SetOwner( this, "ANCHOR_RIGHT" );
		end

		local zone		= GetCurrentMapZone();
		local continent = GetCurrentMapContinent();

		AlphaMapTooltip:SetText(MapNotesGathering_Names[MapNotesGathering_Data[continent][zone][id].icon][MapNotesGathering_Data[continent][zone][id].subname], MapNotes_Colors[0].r, MapNotes_Colors[0].g, MapNotes_Colors[0].b);

		local xPos = MapNotesGathering_Data[continent][zone][id].xPos;
		local yPos = MapNotesGathering_Data[continent][zone][id].yPos;

		for i=1, getn(MapNotesGathering_Data[continent][zone]), 1 do
			if (i ~= id and abs(MapNotesGathering_Data[continent][zone][i].xPos - xPos) <= 0.0009765625 * MapNotes_MinDiff and abs(MapNotesGathering_Data[continent][zone][i].yPos - yPos) <= 0.0013020833 * MapNotes_MinDiff) then
				local icon = MapNotesGathering_Data[continent][zone][i].icon;

				if ((MapNotes_Options.showherbs and icon > 9 and icon <= 38 and MapNotes_Options["Gathering"][icon] ~= "off") or (MapNotes_Options.showveins and icon <= 9 and MapNotes_Options["Gathering"][icon] ~= "off") or (MapNotes_Options.showchests and icon == 39)) then
					AlphaMapTooltip:AddLine(MapNotesGathering_Names[icon][MapNotesGathering_Data[continent][zone][i].subname], MapNotes_Colors[0].r, MapNotes_Colors[0].g, MapNotes_Colors[0].b);
				end
			end
		end
		AlphaMapTooltip:Show();
	end
end

function AlphaNotesGathering_OnLeave(id)
	AlphaMapTooltip:Hide();
end





