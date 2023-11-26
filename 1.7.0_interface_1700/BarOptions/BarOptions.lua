--[[
	BarOptions
	 	Lets you configure extra options for the Main Bar and Action bars.
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	Gives several options for configuration of the varying bars:
	Remove art from the bars
	Add background art to the multi bars
	Replaces BonusActionBar with one that has an accessable background art, needed for PopNUI and TransNUI
	Provide coloring of actions that are not in range of their target.
	Use a different set of ID ranges for the bars, like secondbar, and sidebar did.
	Group the bottom left bar and action bar, for turning pages, like secondbar did.
	Make the bottom left bar use different ID's based on stance.
	Show/Hide empty bar buttons.
	Show the hotkeys on the multi bars.
	Show/Hide all hotkeys.
	Shorten the names of the modifier keys for bindings.
	Change the number of buttons on each of the four multi bars.
	
	$Id: BarOptions.lua 2167 2005-07-24 05:01:45Z mugendai $
	$Rev: 2167 $
	$LastChangedBy: mugendai $
	$Date: 2005-07-24 00:01:45 -0500 (Sun, 24 Jul 2005) $
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
	VERSION = 1.23;
	BARLIST = {
		"Action";
		"BOBonusAction";
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
	MultiBarLeft:SetUserPlaced(true);
	MultiBarRight:ClearAllPoints();
	MultiBarRight:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -7, 98);
	MultiBarRight:SetUserPlaced(true);
	--Move the Party Members frame to its default position
	BarOptions.OffsetParty();
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
	PartyMemberFrame1:SetUserPlaced(true);
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

	--Move the main bar to the new position, if needed
	if (mainPoint) then
		MainMenuBar:ClearAllPoints();
		MainMenuBar:SetPoint(mainPoint, "UIParent", mainPoint, 0, 0);
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
		--Register our configuration variable to be saved
		RegisterForSave("BarOptions_Config");
			
		--Hook the functions that need hooked
		if (BarOptions.Hook) then
			BarOptions.Hook();
		end

		--Smart register all the options
		MCom.registerSmart( {
			uifolder = "bars";
			uisec = "BarOptions";
			uiseclabel = BAROPTIONS_CONFIG_SECTION;
			uisecdesc = BAROPTIONS_CONFIG_SECTION_INFO;
			uisecdiff = 1;
			uivar = "BarOptionsBarSep";
			uitype = K_HEADER;
			uilabel = BAROPTIONS_CONFIG_BAR_HEADER;
			uidesc = BAROPTIONS_CONFIG_BAR_HEADER_INFO;
			uidiff = 1;
			uiver = BarOptions.VERSION;
			uiframe = "BarOptionsFrame";
			supercom = {"/baroptions", "/bo"};
			comaction = "before";
			comsticky = false;
			comhelp = BAROPTIONS_CHAT_COMMAND_INFO;
			name = BAROPTIONS_CONFIG_SECTION;
			infotext = BAROPTIONS_CONFIG_INFOTEXT;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsDefaultSetup";
			uitype = K_BUTTON;
			uilabel = BAROPTIONS_CONFIG_DEFAULTSETUP;
			uidesc = BAROPTIONS_CONFIG_DEFAULTSETUP_INFO;
			uidiff = 1;
			func = BarOptions.DefaultSetup;
			uitext = BAROPTIONS_CONFIG_DEFAULTSETUP_NAME;
			supercom = "/baroptions";
			subcom = {"default"};
			subhelp = BAROPTIONS_CONFIG_DEFAULTSETUP_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsSideBarSetup";
			uitype = K_BUTTON;
			uilabel = BAROPTIONS_CONFIG_SIDEBARSETUP;
			uidesc = BAROPTIONS_CONFIG_SIDEBARSETUP_INFO;
			uidiff = 1;
			func = BarOptions.SideBarSetup;
			uitext = BAROPTIONS_CONFIG_SIDEBARSETUP_NAME;
			supercom = "/baroptions";
			subcom = {"sidebar"};
			subhelp = BAROPTIONS_CONFIG_SIDEBARSETUP_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsAlternateIDs";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_ALTERNATEIDS;
			uidesc = BAROPTIONS_CONFIG_ALTERNATEIDS_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.AlternateIDs";
			update = function ()	ChangeActionBarPage();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_ALTERNATEIDS;
			uicheck = BarOptions_Config.AlternateIDs;
			supercom = "/baroptions";
			subcom = {"alternateids", "aid"};
			subhelp = BAROPTIONS_CONFIG_ALTERNATEIDS_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsTurnPages";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_TURNPAGES;
			uidesc = BAROPTIONS_CONFIG_TURNPAGES_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.TurnPages";
			update = function ()	ChangeActionBarPage();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_TURNPAGES;
			uicheck = BarOptions_Config.TurnPages;
			supercom = "/baroptions";
			subcom = {"turnpages", "tp"};
			subhelp = BAROPTIONS_CONFIG_TURNPAGES_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsGroupPages";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_GROUPPAGES;
			uidesc = BAROPTIONS_CONFIG_GROUPPAGES_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.GroupPages";
			update = function ()	ChangeActionBarPage();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_GROUPPAGES;
			uicheck = BarOptions_Config.GroupPages;
			supercom = "/baroptions";
			subcom = {"grouppages", "gp"};
			subhelp = BAROPTIONS_CONFIG_GROUPPAGES_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsStanceBar";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_STANCEBAR;
			uidesc = BAROPTIONS_CONFIG_STANCEBAR_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.StanceBar";
			update = function ()	ChangeActionBarPage();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_STANCEBAR;
			uicheck = BarOptions_Config.StanceBar;
			supercom = "/baroptions";
			subcom = {"stancebar", "sb"};
			subhelp = BAROPTIONS_CONFIG_STANCEBAR_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsHideEmpty";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_HIDEEMPTY;
			uidesc = BAROPTIONS_CONFIG_HIDEEMPTY_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.HideEmpty";
			update = function ()	ChangeActionBarPage();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_HIDEEMPTY;
			uicheck = BarOptions_Config.HideEmpty;
			supercom = "/baroptions";
			subcom = {"hideempty", "he"};
			subhelp = BAROPTIONS_CONFIG_HIDEEMPTY_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsMoveMainBarSep";
			uitype = K_HEADER;
			uilabel = BAROPTIONS_CONFIG_MOVEMAINBAR_HEADER;
			uidesc = BAROPTIONS_CONFIG_MOVEMAINBAR_HEADER_INFO;
			uidiff = 2;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsMainBarCenter";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_MAINBARCENTER;
			uidesc = BAROPTIONS_CONFIG_MAINBARCENTER_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.MainBarCenter";
			update = function ()	BarOptions.MoveMainBar();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_MAINBARCENTER;
			uicheck = BarOptions_Config.MainBarCenter;
			supercom = "/baroptions";
			subcom = {"mainbarcenter", "mbcenter", "mbc"};
			subhelp = BAROPTIONS_CONFIG_MAINBARCENTER_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsMainBarLeft";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_MAINBARLEFT;
			uidesc = BAROPTIONS_CONFIG_MAINBARLEFT_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.MainBarLeft";
			update = function ()	BarOptions.MoveMainBar();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_MAINBARLEFT;
			uicheck = BarOptions_Config.MainBarLeft;
			supercom = "/baroptions";
			subcom = {"mainbarleft", "mbleft", "mbl"};
			subhelp = BAROPTIONS_CONFIG_MAINBARLEFT_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsMainBarRight";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_MAINBARRIGHT;
			uidesc = BAROPTIONS_CONFIG_MAINBARRIGHT_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.MainBarRight";
			update = function ()	BarOptions.MoveMainBar();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_MAINBARRIGHT;
			uicheck = BarOptions_Config.MainBarRight;
			supercom = "/baroptions";
			subcom = {"mainbarright", "mbright", "mbr"};
			subhelp = BAROPTIONS_CONFIG_MAINBARRIGHT_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsHotkeySep";
			uitype = K_HEADER;
			uilabel = BAROPTIONS_CONFIG_HOTKEY_HEADER;
			uidesc = BAROPTIONS_CONFIG_HOTKEY_HEADER_INFO;
			uidiff = 2;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsHideKeys";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_HIDEKEYS;
			uidesc = BAROPTIONS_CONFIG_HIDEKEYS_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.HideKeys";
			update = function ()	BarOptions.UpdateHotkeys();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_HIDEKEYS;
			uicheck = BarOptions_Config.HideKeys;
			supercom = "/baroptions";
			subcom = {"hidekeys", "hk"};
			subhelp = BAROPTIONS_CONFIG_HIDEKEYS_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsMultiKeys";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_MULTIKEYS;
			uidesc = BAROPTIONS_CONFIG_MULTIKEYS_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.MultiKeys";
			update = function ()	BarOptions.ShowMultiHotkeys();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_MULTIKEYS;
			uicheck = BarOptions_Config.MultiKeys;
			supercom = "/baroptions";
			subcom = {"multikeys", "mk"};
			subhelp = BAROPTIONS_CONFIG_MULTIKEYS_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsShortKeys";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_SHORTKEYS;
			uidesc = BAROPTIONS_CONFIG_SHORTKEYS_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.ShortKeys";
			update = function ()	BarOptions.UpdateHotkeys();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_SHORTKEYS;
			uicheck = BarOptions_Config.ShortKeys;
			supercom = "/baroptions";
			subcom = {"shortkeys", "sk"};
			subhelp = BAROPTIONS_CONFIG_SHORTKEYS_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsHideKeyMod";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_HIDEKEYMOD;
			uidesc = BAROPTIONS_CONFIG_HIDEKEYMOD_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.HideKeyMod";
			update = function ()	BarOptions.UpdateHotkeys();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_HIDEKEYMOD;
			uicheck = BarOptions_Config.HideKeyMod;
			supercom = "/baroptions";
			subcom = {"hidekeymod", "hkmod"};
			subhelp = BAROPTIONS_CONFIG_HIDEKEYMOD_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsArtSep";
			uitype = K_HEADER;
			uilabel = BAROPTIONS_CONFIG_ART_HEADER;
			uidesc = BAROPTIONS_CONFIG_ART_HEADER_INFO;
			uidiff = 2;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsRangeColor";
			uitype = K_COLORPICKER;
			uilabel = BAROPTIONS_CONFIG_RANGECOLOR;
			uidesc = BAROPTIONS_CONFIG_RANGECOLOR_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.RangeColorOn";
			varcolor = "BarOptions_Config.RangeColor";
			update = function ()	ChangeActionBarPage();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_RANGECOLOR;
			uicheck = BarOptions_Config.RangeColorOn;
			uicolor = BarOptions_Config.RangeColor;
			supercom = "/baroptions";
			subcom = {"rangecolor", "rc"};
			subhelp = BAROPTIONS_CONFIG_RANGECOLOR_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsMainArt";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_MAINART;
			uidesc = BAROPTIONS_CONFIG_MAINART_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.MainArt";
			update = function ()	BarOptions.UpdateArt();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_MAINART;
			uicheck = BarOptions_Config.MainArt;
			supercom = "/baroptions";
			subcom = {"mainart", "ma"};
			subhelp = BAROPTIONS_CONFIG_MAINART_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsBLArt";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_BLART;
			uidesc = BAROPTIONS_CONFIG_BLART_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.BLArt";
			update = function ()	BarOptions.UpdateArt();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_BLART;
			uicheck = BarOptions_Config.BLArt;
			supercom = "/baroptions";
			subcom = {"blart", "bla"};
			subhelp = BAROPTIONS_CONFIG_BLART_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsBRArt";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_BRART;
			uidesc = BAROPTIONS_CONFIG_BRART_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.BRArt";
			update = function ()	BarOptions.UpdateArt();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_BRART;
			uicheck = BarOptions_Config.BRArt;
			supercom = "/baroptions";
			subcom = {"brart", "bra"};
			subhelp = BAROPTIONS_CONFIG_BRART_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsRArt";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_RART;
			uidesc = BAROPTIONS_CONFIG_RART_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.RArt";
			update = function ()	BarOptions.UpdateArt();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_RART;
			uicheck = BarOptions_Config.RArt;
			supercom = "/baroptions";
			subcom = {"rart", "ra"};
			subhelp = BAROPTIONS_CONFIG_RART_INFO;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsLArt";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_LART;
			uidesc = BAROPTIONS_CONFIG_LART_INFO;
			uidiff = 2;
			varbool = "BarOptions_Config.LArt";
			update = function ()	BarOptions.UpdateArt();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_LART;
			uicheck = BarOptions_Config.LArt;
			supercom = "/baroptions";
			subcom = {"lart", "la"};
			subhelp = BAROPTIONS_CONFIG_LART_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsCountSep";
			uitype = K_HEADER;
			uilabel = BAROPTIONS_CONFIG_COUNT_HEADER;
			uidesc = BAROPTIONS_CONFIG_COUNT_HEADER_INFO;
			uidiff = 2;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsBLCount";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_BLCOUNT;
			uidesc = BAROPTIONS_CONFIG_BLCOUNT_INFO;
			uidiff = 2;
			varnum = "BarOptions_Config.BLCount";
			update = function ()	BarOptions.UpdateButtons();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_BLCOUNT;
			uislider = BarOptions_Config.BLCount;
			uimin = 1;
			uimax = 12;
			uitext = BAROPTIONS_CONFIG_COUNT_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_COUNT_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"blcount"};
			subhelp = BAROPTIONS_CONFIG_BLCOUNT_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsBRCount";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_BRCOUNT;
			uidesc = BAROPTIONS_CONFIG_BRCOUNT_INFO;
			uidiff = 2;
			varnum = "BarOptions_Config.BRCount";
			update = function ()	BarOptions.UpdateButtons();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_BRCOUNT;
			uislider = BarOptions_Config.BRCount;
			uimin = 1;
			uimax = 12;
			uitext = BAROPTIONS_CONFIG_COUNT_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_COUNT_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"brcount"};
			subhelp = BAROPTIONS_CONFIG_BRCOUNT_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsRCount";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_RCOUNT;
			uidesc = BAROPTIONS_CONFIG_RCOUNT_INFO;
			uidiff = 2;
			varnum = "BarOptions_Config.RCount";
			update = function ()	BarOptions.UpdateButtons();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_RCOUNT;
			uislider = BarOptions_Config.RCount;
			uimin = 1;
			uimax = 12;
			uitext = BAROPTIONS_CONFIG_COUNT_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_COUNT_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"rcount"};
			subhelp = BAROPTIONS_CONFIG_RCOUNT_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsLCount";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_LCOUNT;
			uidesc = BAROPTIONS_CONFIG_LCOUNT_INFO;
			uidiff = 2;
			varnum = "BarOptions_Config.LCount";
			update = function ()	BarOptions.UpdateButtons();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_LCOUNT;
			uislider = BarOptions_Config.LCount;
			uimin = 1;
			uimax = 12;
			uitext = BAROPTIONS_CONFIG_COUNT_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_COUNT_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"lcount"};
			subhelp = BAROPTIONS_CONFIG_LCOUNT_INFO;
		} );
		if ( CosmosMaster_Init and (not Khaos) ) then
			MCom.registerSmart( {
				uivar = "BarOptionsRangeColorSep";
				uitype = K_HEADER;
				uilabel = BAROPTIONS_CONFIG_RANGECOLOR_HEADER;
				uidesc = BAROPTIONS_CONFIG_RANGECOLOR_HEADER_INFO;
				uidiff = 2;
			} );
			MCom.registerSmart( {
				hasbool = true;
				uivar = "BarOptionsRangeColor";
				uitype = K_TEXT;
				uilabel = BAROPTIONS_CONFIG_RANGECOLOR;
				uidesc = BAROPTIONS_CONFIG_RANGECOLOR_INFO;
				uidiff = 2;
				varbool = "BarOptions_Config.RangeColorOn";
				update = function ()	ChangeActionBarPage();
															BarOptions.SaveConfig(); end;
				uicheck = BarOptions_Config.RangeColorOn;
			} );
			MCom.registerSmart( {
				uivar = "BarOptionsRangeColorRed";
				uitype = K_SLIDER;
				uilabel = BAROPTIONS_CONFIG_RANGECOLORRED;
				uidesc = BAROPTIONS_CONFIG_RANGECOLORRED_INFO;
				uidiff = 2;
				varnum = "BarOptions_Config.RangeColor.r";
				update = BarOptions.SaveConfig;
				uislider = BarOptions_Config.RangeColor.r;
				uimin = 0;
				uimax = 1;
				uitext = BAROPTIONS_CONFIG_RANGECOLOR_NAME;
				uistep = 0.01;
				uitexton = 1;
				uisuffix = BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX;
				uimul = 100;
			} );
			MCom.registerSmart( {
				uivar = "BarOptionsRangeColorGreen";
				uitype = K_SLIDER;
				uilabel = BAROPTIONS_CONFIG_RANGECOLORGREEN;
				uidesc = BAROPTIONS_CONFIG_RANGECOLORGREEN_INFO;
				uidiff = 2;
				varnum = "BarOptions_Config.RangeColor.g";
				update = BarOptions.SaveConfig;
				uislider = BarOptions_Config.RangeColor.g;
				uimin = 0;
				uimax = 1;
				uitext = BAROPTIONS_CONFIG_RANGECOLOR_NAME;
				uistep = 0.01;
				uitexton = 1;
				uisuffix = BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX;
				uimul = 100;
			} );
			MCom.registerSmart( {
				uivar = "BarOptionsRangeColorBlue";
				uitype = K_SLIDER;
				uilabel = BAROPTIONS_CONFIG_RANGECOLORBLUE;
				uidesc = BAROPTIONS_CONFIG_RANGECOLORBLUE_INFO;
				uidiff = 2;
				varnum = "BarOptions_Config.RangeColor.b";
				update = BarOptions.SaveConfig;
				uislider = BarOptions_Config.RangeColor.b;
				uimin = 0;
				uimax = 1;
				uitext = BAROPTIONS_CONFIG_RANGECOLOR_NAME;
				uistep = 0.01;
				uitexton = 1;
				uisuffix = BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX;
				uimul = 100;
			} );
		end
		MCom.registerSmart( {
			uivar = "BarOptionsStanceSep";
			uitype = K_HEADER;
			uilabel = BAROPTIONS_CONFIG_STANCE_HEADER;
			uidesc = BAROPTIONS_CONFIG_STANCE_HEADER_INFO;
			uidiff = 3;
		} );
		MCom.registerSmart( {
			hasbool = true;
			uivar = "BarOptionsCustomStances";
			uitype = K_TEXT;
			uilabel = BAROPTIONS_CONFIG_CUSTOMSTANCES;
			uidesc = BAROPTIONS_CONFIG_CUSTOMSTANCES_INFO;
			uidiff = 3;
			varbool = "BarOptions_Config.CustomStances";
			update = function ()	ChangeActionBarPage();
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_CUSTOMSTANCES;
			uicheck = BarOptions_Config.CustomStances;
			supercom = "/baroptions";
			subcom = {"customstances", "cs"};
			subhelp = BAROPTIONS_CONFIG_CUSTOMSTANCES_INFO;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsStance0";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_STANCE0;
			uidesc = BAROPTIONS_CONFIG_STANCE0_INFO;
			uidiff = 3;
			varnum = "BarOptions_Config.Stance0";
			update = function ()	if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 0)) then ChangeActionBarPage(); end;
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_STANCE0;
			uislider = BarOptions_Config.Stance0;
			uimin = 1;
			uimax = 10;
			uitext = BAROPTIONS_CONFIG_STANCE_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_STANCE_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"stance0", "s0"};
			subhelp = BAROPTIONS_CONFIG_STANCE0_INFO..BAROPTIONS_CHAT_STANCE_RANGE;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsStance1";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_STANCE1;
			uidesc = BAROPTIONS_CONFIG_STANCE1_INFO;
			uidiff = 3;
			varnum = "BarOptions_Config.Stance1";
			update = function ()	if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 1)) then ChangeActionBarPage(); end;
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_STANCE1;
			uislider = BarOptions_Config.Stance1;
			uimin = 1;
			uimax = 10;
			uitext = BAROPTIONS_CONFIG_STANCE_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_STANCE_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"stance1", "s1"};
			subhelp = BAROPTIONS_CONFIG_STANCE1_INFO..BAROPTIONS_CHAT_STANCE_RANGE;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsStance2";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_STANCE2;
			uidesc = BAROPTIONS_CONFIG_STANCE2_INFO;
			uidiff = 3;
			varnum = "BarOptions_Config.Stance2";
			update = function ()	if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 2)) then ChangeActionBarPage(); end;
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_STANCE2;
			uislider = BarOptions_Config.Stance2;
			uimin = 1;
			uimax = 10;
			uitext = BAROPTIONS_CONFIG_STANCE_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_STANCE_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"stance2", "s2"};
			subhelp = BAROPTIONS_CONFIG_STANCE2_INFO..BAROPTIONS_CHAT_STANCE_RANGE;
		} );
		MCom.registerSmart( {
			uivar = "BarOptionsStance3";
			uitype = K_SLIDER;
			uilabel = BAROPTIONS_CONFIG_STANCE3;
			uidesc = BAROPTIONS_CONFIG_STANCE3_INFO;
			uidiff = 3;
			varnum = "BarOptions_Config.Stance3";
			update = function ()	if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 3)) then ChangeActionBarPage(); end;
														BarOptions.SaveConfig(); end;
			textname = BAROPTIONS_CHAT_STANCE3;
			uislider = BarOptions_Config.Stance3;
			uimin = 1;
			uimax = 10;
			uitext = BAROPTIONS_CONFIG_STANCE_NAME;
			uistep = 1;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_STANCE_SUFFIX;
			uimul = 1;
			supercom = "/baroptions";
			subcom = {"stance3", "s3"};
			subhelp = BAROPTIONS_CONFIG_STANCE3_INFO..BAROPTIONS_CHAT_STANCE_RANGE;
		} );
	
		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(BarOptions.OnVarsLoaded);
	
		BarOptions.Initialized = 1;
	end
end;
