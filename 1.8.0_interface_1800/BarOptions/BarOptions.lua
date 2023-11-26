--[[
	BarOptions
	 	Lets you configure extra options for the Main Bar and Action bars.
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	Gives several options for configuration of the varying bars:
	Remove art from the bars
	Add background art to the multi bars
	Provide coloring of actions that are not in range of their target.
	Use a different set of ID ranges for the bars, like secondbar, and sidebar did.
	Group the bottom left bar and action bar, for turning pages, like secondbar did.
	Make the bottom left bar use different ID's based on stance.
	Show/Hide empty bar buttons.
	Show the hotkeys on the multi bars.
	Show/Hide all hotkeys.
	Shorten the names of the modifier keys for bindings.
	Change the number of buttons on each of the four multi bars.
	
	$Id: BarOptions.lua 2690 2005-10-25 01:49:24Z mugendai $
	$Rev: 2690 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-24 20:49:24 -0500 (Mon, 24 Oct 2005) $
]]--

--------------------------------------------------
--
-- BarOptions Declaration
--
--------------------------------------------------
BarOptions = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	VERSION = 1.37;
	BARLIST = {
		"Action";
		"BonusAction";
		"MultiBarBottomLeft";
		"MultiBarBottomRight";
		"MultiBarRight";
		"MultiBarLeft";
	};
};
--Main Configuration variable
BarOptions_Config = {};
BarOptions.SetDefaults = function ()
	BarOptions_Config.AlternateIDs = 0; --Whether to use the alternate button ID ranges or not
	BarOptions_Config.TurnPages = 0; --Whether bottom left multi bar changes pages when the page changes
	BarOptions_Config.GroupPages = 0; --Whether to use grouped pages for mainbar and bottom left multi bar
	BarOptions_Config.StanceBar = 0; --Whether the bottom left multibar should switch to an different page when stance changes
	BarOptions_Config.HideEmpty = 1; --Whether to hide empty buttons or not
	BarOptions_Config.MainBarCenter = 0; --Whether to move the main bar to the bottom center or not
	BarOptions_Config.MainBarLeft = 0; --Whether to move the main bar to the bottom left or not
	BarOptions_Config.MainBarRight = 0; --Whether to move the main bar to the bottom right or not
	BarOptions_Config.HideKeys = 0; --Whether to hide all hotkeys or not
	BarOptions_Config.MultiKeys = 0; --Whether to show hotkeys on the multi bars or not
	BarOptions_Config.ShortKeys = 0; --Whether to shorten the names of the key modifiers or not
	BarOptions_Config.HideKeyMod = 0; --Whether to hide the hotkey modifiers or not
	BarOptions_Config.MainArt = 1; --Whether to show the main bar artwork or not
	BarOptions_Config.BLArt = 0; --Whether to show the bottom left bar artwork or not
	BarOptions_Config.BRArt = 0; --Whether to show the bottom right bar artwork or not
	BarOptions_Config.RArt = 0; --Whether to show the right bar artwork or not
	BarOptions_Config.LArt = 0; --Whether to show the left bar artwork or not
	BarOptions_Config.BLCount = 12; --HoBarOptions_Config.w many buttons on the bottom left multi bar
	BarOptions_Config.BRCount = 12; --How many buttons on the bottom right multi bar
	BarOptions_Config.RCount = 12; --How many buttons on the right multi bar
	BarOptions_Config.LCount = 12; --How many buttons on the left multi bar
	BarOptions_Config.RangeColorOn = 0;	--Should we color action buttons when they arent in range
	BarOptions_Config.RangeColor = {	r = 1;			--How much red	
																		g = 0.5;		--How much green
																		b = 0.5; };	--How much blue
	BarOptions_Config.CustomStances = 0; --If anabled then the customized stance pages will be used.
	BarOptions_Config.Stance0 = 6; --No stance page
	BarOptions_Config.Stance1 = 3; --Stance numer 1 page
	BarOptions_Config.Stance2 = 2; --Stance numer 2 page
	BarOptions_Config.Stance3 = 10; --Stance numer 3 page
end;
BarOptions.SetDefaults();
--Store this config for safe load
MCom.safeLoad("BarOptions_Config");

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ Sets things back to their defaults ]]--
BarOptions.DefaultSetup = function ()
	--Set the default settings
	BarOptions.SetDefaults();
	--Update the UI with the defaults
	MCom.updateUI("/baroptions");
	--Update the varying UI elements
	BarOptions.UpdateHotkeys();
	BarOptions.ShowMultiHotkeys();
	BarOptions.UpdateButtons();
	ChangeActionBarPage();
	--Move the right and left multi bars to their normal positions
	MultiBarLeft:ClearAllPoints();
	MultiBarLeft:SetPoint("TOPRIGHT", "MultiBarRight", "TOPLEFT", -5, 0);
	MultiBarLeft:SetUserPlaced(false);
	MultiBarRight:ClearAllPoints();
	MultiBarRight:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -7, 98);
	MultiBarRight:SetUserPlaced(false);
	MultiActionBar_Update();
	--Move the Party Members frame to its default position
	BarOptions.OffsetParty();
	--Set MobileFrames Offsets if availible.
	if (MobileFrames_SetOffsets) then
		MobileFrames_SetOffsets("REGULAR 0");
		MobileFrames_SetOffsets("CONTAINERS 90");
	end
	--Print output to let the player know the command succeeded, if there is no UI
	MCom.printStatus(BAROPTIONS_CHAT_DEFAULTSETUP);
end;

--[[ Sets things up to behave like Sidebars ]]--
BarOptions.SideBarSetup = function ()
	--Set to the sidebar settings
	BarOptions_Config.AlternateIDs = 1;
	BarOptions_Config.TurnPages = 1;
	BarOptions_Config.MultiKeys = 1;
	BarOptions_Config.LCount = 6;
	BarOptions_Config.RCount = 6;
	BarOptions_Config.RangeColorOn = 1;
	--Update the UI with the defaults
	MCom.updateUI("/baroptions");
	--Update the varying UI elements
	BarOptions.UpdateHotkeys();
	BarOptions.ShowMultiHotkeys();
	BarOptions.UpdateButtons();
	ChangeActionBarPage();
	--Move the right and left multi bars to their sidebar positions
	MultiBarLeft:ClearAllPoints();
	MultiBarLeft:SetPoint("TOPLEFT", "UIParent", "LEFT", -5, (98 - 80) + 56);
	MultiBarLeft:SetUserPlaced(true);
	MultiBarRight:ClearAllPoints();
	MultiBarRight:SetPoint("TOPRIGHT", "UIParent", "RIGHT", 0, 98 + 56);
	MultiBarRight:SetUserPlaced(true);

	--Move the Party Members frame out of the way of the left bar
	BarOptions.OffsetParty(true);

	--Set MobileFrames Offsets if availible.
	if (MobileFrames_SetOffsets) then
		MobileFrames_SetOffsets("REGULAR 40");
		MobileFrames_SetOffsets("CONTAINERS 30");
	end

	--Enable the sidebars
	SHOW_MULTI_ACTIONBAR_3 = 1;	
	SHOW_MULTI_ACTIONBAR_4 = 1;
	--Save sidebar state
	SetActionBarToggles(SHOW_MULTI_ACTIONBAR_1, SHOW_MULTI_ACTIONBAR_2, SHOW_MULTI_ACTIONBAR_3, SHOW_MULTI_ACTIONBAR_4);

	MultiActionBar_Update();
	UIParent_ManageRightSideFrames();
	FCF_UpdateCombatLogPosition();
	UIOptionsFrame_UpdateDependencies();

	--Print output to let the player know the command succeeded, if there is no UI
	MCom.printStatus(BAROPTIONS_CHAT_SIDEBARSETUP);
end;

--[[ Moves Party Frame out of left sidebar's way ]]--
BarOptions.OffsetParty = function (doOffset)
	local newXPos = 10;
	--if we are supposed to offset party frame for the left bar, then calculate the new position
	if (doOffset) then
		local width = MultiBarLeft:GetWidth();
		local scale = MultiBarLeft:GetScale();
		if ( ( width ) and ( scale ) ) then
			newXPos = newXPos + (width * scale);
		end
	end	
	
	--Move the party member frame to its new home
	PartyMemberFrame1:ClearAllPoints();
	PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", newXPos, -128);
	if (doOffset) then
		PartyMemberFrame1:SetUserPlaced(true);
	else
		PartyMemberFrame1:SetUserPlaced(false);
	end
end;

--[[ Moves Main Bar ]]--
BarOptions.MoveMainBar = function ()
	--Default to not moving it
	local mainPoint = nil;
	--If any of the movers are enabled, then set mainPoint for it
	if ( BarOptions_Config.MainBarCenter == 1 ) then
		mainPoint = "BOTTOM";
	elseif ( BarOptions_Config.MainBarLeft == 1 ) then
		mainPoint = "BOTTOMLEFT";
	elseif ( BarOptions_Config.MainBarRight == 1 ) then
		mainPoint = "BOTTOMRIGHT";
	end

	--Adjust for TitanBar
	local yOff = 0;
	if (TitanPanelGetVar and TITAN_PANEL_PLACE_BOTTOM and ( ( TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_BOTTOM ) or TitanPanelGetVar("BothBars") ) and TitanMovable_GetPanelYOffset ) then
		local titanOffset = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_BOTTOM, TitanPanelGetVar("BothBars"));
		if (titanOffset) then
			yOff = yOff + titanOffset;
		end
	end

	--Move the main bar to the new position, if needed
	if ( mainPoint and ( not MainMenuBar:IsUserPlaced() ) ) then
		MainMenuBar:ClearAllPoints();
		MainMenuBar:SetPoint(mainPoint, "UIParent", mainPoint, 0, yOff);
	end
end;

--[[ Shows or hides a frame ]]--
BarOptions.ShowFrame = function (whichFrame, hideShow)
	--Show/hide the frame
	if (hideShow == 1) then
		if (not getglobal(whichFrame):IsVisible()) then
			getglobal(whichFrame):Show();
		end
	else
		if (getglobal(whichFrame):IsVisible()) then
			getglobal(whichFrame):Hide();
		end
	end
end;

--[[ Updates all hotkey text ]]--
BarOptions.UpdateHotkeys = function ()
	for num, name in BarOptions.BARLIST do
		for curBut=1, 12 do
			BarOptions.ActionButton_UpdateHotkeys(nil, getglobal(name.."Button"..curBut));
		end
	end
end;

--[[ Updates showing of multibar hotkey text ]]--
BarOptions.ShowMultiHotkeys = function ()
	for index = 3, getn(BarOptions.BARLIST) do
		for curBut=1, 12 do
			local name = BarOptions.BARLIST[index];
			BarOptions.ShowFrame(name.."Button"..curBut.."HotKey", BarOptions_Config.MultiKeys);
		end
	end
end;

--[[ Shows or hides a button based on its ID and parent ]]--
BarOptions.ShowButton = function (button)
	local shouldShow = 1;
	if (string.find(button:GetName(), "MultiBarBottomLeft")) then
		if (button:GetID() > BarOptions_Config.BLCount) then
			shouldShow = 0;
		end
	elseif (string.find(button:GetName(), "MultiBarBottomRight")) then
		if (button:GetID() > BarOptions_Config.BRCount) then
			shouldShow = 0;
		end
	elseif (string.find(button:GetName(), "MultiBarRight")) then
		if (button:GetID() > BarOptions_Config.RCount) then
			shouldShow = 0;
		end
	elseif (string.find(button:GetName(), "MultiBarLeft")) then
		if (button:GetID() > BarOptions_Config.LCount) then
			shouldShow = 0;
		end
	end
	
	if (shouldShow == 1) then
		if (not button:IsVisible()) then
			if ( (string.find(button:GetName(), "ArtButton")) or HasAction(ActionButton_GetPagedID(button)) or (button.showgrid > 0) or (BarOptions_Config.HideEmpty == 0) ) then
				button:Show();
			end
		end
	elseif (button:IsVisible()) then
		button:Hide();
	end
end;

--[[ Shows or hides a buttons artwork based on its ID and parent ]]--
BarOptions.ShowButtonArt = function (button)
	local shouldShow = 1;
	if (string.find(button:GetName(), "MultiBarBottomLeft")) then
		if (button:GetID() > BarOptions_Config.BLCount) then
			shouldShow = 0;
		end
	elseif (string.find(button:GetName(), "MultiBarBottomRight")) then
		if (button:GetID() > BarOptions_Config.BRCount) then
			shouldShow = 0;
		end
	elseif (string.find(button:GetName(), "MultiBarRight")) then
		if (button:GetID() > BarOptions_Config.RCount) then
			shouldShow = 0;
		end
	elseif (string.find(button:GetName(), "MultiBarLeft")) then
		if (button:GetID() > BarOptions_Config.LCount) then
			shouldShow = 0;
		end
	end
	
	if (shouldShow == 1) then
		if (not button:IsVisible()) then
			button:Show();
		end
	elseif (button:IsVisible()) then
		button:Hide();
	end
end;

--[[ Updates showing of all buttons ]]--
BarOptions.UpdateButtons = function ()
	for index = 1, getn(BarOptions.BARLIST) do
		for curBut=1, 12 do
			local name = BarOptions.BARLIST[index];
			BarOptions.ShowButton(getglobal(name.."Button"..curBut));
		end
	end
	for index = 3, getn(BarOptions.BARLIST) do
		for curBut=1, 12 do
			local name = BarOptions.BARLIST[index];
			BarOptions.ShowButton(getglobal(name.."ArtButton"..curBut));
		end
	end
end;

--[[ Updates showing of all artwork ]]--
BarOptions.UpdateArt = function ()
	--Show/hide MainBar dragons
	BarOptions.ShowFrame("MainMenuBarLeftEndCap", BarOptions_Config.MainArt);
	BarOptions.ShowFrame("MainMenuBarRightEndCap", BarOptions_Config.MainArt);

	--Show/hide Multi Bar Artwork
	BarOptions.ShowFrame("MultiBarBottomLeftArt", BarOptions_Config.BLArt);
	BarOptions.ShowFrame("MultiBarBottomRightArt", BarOptions_Config.BRArt);
	BarOptions.ShowFrame("MultiBarRightArt", BarOptions_Config.RArt);
	BarOptions.ShowFrame("MultiBarLeftArt", BarOptions_Config.LArt);
end;

--[[ Saves the current configuration on a per realm/per character basis ]]--
BarOptions.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "BarOptions_Config";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
BarOptions.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "BarOptions_Config";
		nonUIList = {};
	});
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
BarOptions.OnVarsLoaded = function ()
	if (not BarOptions.ConfigLoaded) then
		BarOptions.ConfigLoaded = true;
		--Load the configuration
		BarOptions.LoadConfig();
		--Store the configuration for this character
		BarOptions.SaveConfig();

		--Update the main bar position
		BarOptions.MoveMainBar();
		--Update the artwork
		BarOptions.UpdateArt();
		--Update which buttons should be showing
		BarOptions.UpdateButtons();
		--Update the button IDs
		ChangeActionBarPage();
		--Update showing of the Hotkeys
		BarOptions.UpdateHotkeys();
		BarOptions.ShowMultiHotkeys();
	end;
end

BarOptions.OnLoad = function ()
	if ( BarOptions.Initialized ~= 1) then
		--Hook the functions that need hooked
		if (BarOptions.Hook) then
			BarOptions.Hook();
		end

		--Set these frames mobile so they can retain positions if needed
		MultiBarRight:SetMovable(true);
		MultiBarLeft:SetMovable(true);
		PartyMemberFrame1:SetMovable(true);

		--Register the configuration options
		BarOptions.Register();

		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(BarOptions.OnVarsLoaded);

		BarOptions.Initialized = 1;
	end
end;
