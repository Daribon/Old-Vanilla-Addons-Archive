--[[
	BarOptions
	 	Lets you configure extra options for the Main Bar and Action bars.
	
	By: Mugendai
	
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
	
	$Id: BarOptions.lua 1441 2005-05-05 08:41:19Z Sinaloit $
	$Rev: 1441 $
	$LastChangedBy: Sinaloit $
	$Date: 2005-05-05 10:41:19 +0200 (Thu, 05 May 2005) $
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
BarOptions_Config = {
	AlternateIDs = 0; --Whether to use the alternate button ID ranges or not
	TurnPages = 0; --Whether bottom left multi bar changes pages when the page changes
	GroupPages = 0; --Whether to use grouped pages for mainbar and bottom left multi bar
	StanceBar = 0; --Whether the bottom left multibar should switch to an different page when stance changes
	HideEmpty = 1; --Whether to hide empty buttons or not
	HideKeys = 0; --Whether to hide all hotkeys or not
	MultiKeys = 0; --Whether to show hotkeys on the multi bars or not
	ShortKeys = 0; --Whether to shorten the names of the key modifiers or not
	HideKeyMod = 0; --Whether to hide the hotkey modifiers or not
	MainArt = 1; --Whether to show the main bar artwork or not
	BLArt = 0; --Whether to show the bottom left bar artwork or not
	BRArt = 0; --Whether to show the bottom right bar artwork or not
	RArt = 0; --Whether to show the right bar artwork or not
	LArt = 0; --Whether to show the left bar artwork or not
	BLCount = 12; --How many buttons on the bottom left multi bar
	BRCount = 12; --How many buttons on the bottom right multi bar
	RCount = 12; --How many buttons on the right multi bar
	LCount = 12; --How many buttons on the left multi bar
	RangeColor = 0;	--Should we color action buttons when they arent in range
	RangeColorRed = 1;	--How much red
	RangeColorGreen = 0.5;	--How much gree
	RangeColorBlue = 0.5;	--How much blue
	CustomStances = 0; --If anabled then the customized stance pages will be used.
	Stance0 = 6; --No stance page
	Stance1 = 3; --Stance numer 1 page
	Stance2 = 2; --Stance numer 2 page
	Stance3 = 10; --Stance numer 3 page
};

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ Sets things back to their defaults ]]--
BarOptions.DefaultSetup = function ()
	--Set the default settings
	BarOptions_Config.AlternateIDs = 0;
	BarOptions_Config.TurnPages = 0;
	BarOptions_Config.GroupPages = 0;
	BarOptions_Config.StanceBar = 0;
	BarOptions_Config.HideEmpty = 1;
	BarOptions_Config.HideKeys = 0;
	BarOptions_Config.MultiKeys = 0;
	BarOptions_Config.ShortKeys = 0;
	BarOptions_Config.HideKeyMod = 0;
	BarOptions_Config.MainArt = 1;
	BarOptions_Config.BLArt = 0;
	BarOptions_Config.BRArt = 0;
	BarOptions_Config.RArt = 0;
	BarOptions_Config.LArt = 0;
	BarOptions_Config.BLCount = 12;
	BarOptions_Config.BRCount = 12;
	BarOptions_Config.RCount = 12;
	BarOptions_Config.LCount = 12;
	BarOptions_Config.RangeColor = 0;
	BarOptions_Config.RangeColorRed = 1;
	BarOptions_Config.RangeColorGreen = 0.5;
	BarOptions_Config.RangeColorBlue = 0.5;
	BarOptions_Config.CustomStances = 0;
	BarOptions_Config.Stance0 = 6;
	BarOptions_Config.Stance1 = 3;
	BarOptions_Config.Stance2 = 2;
	BarOptions_Config.Stance3 = 10;
	--Update Cosmos with the defaults
	MCom.updateUI("/baroptions");
	--Update the varying UI elements
	BarOptions.ShowMultiHotkeys();
	BarOptions.UpdateButtons();
	ChangeActionBarPage();
	--Move the right and left multi bars to their normal positions
	MultiBarLeft:SetMovable(1);
	MultiBarLeft:ClearAllPoints();
	MultiBarLeft:SetPoint("TOPRIGHT", "MultiBarRight", "TOPLEFT", -5, 0);
	MultiBarRight:SetMovable(1);
	MultiBarRight:ClearAllPoints();
	MultiBarRight:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -7, 98);
	--Move the Party Members frame to its default position
	BarOptions.OffsetParty();
	--Print output to let the player know the command succeeded, if there is no Cosmos
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
	BarOptions_Config.RangeColor = 1;
	--Update Cosmos with the defaults
	MCom.updateUI("/baroptions");
	--Update the varying UI elements
	BarOptions.ShowMultiHotkeys();
	BarOptions.UpdateButtons();
	ChangeActionBarPage();
	--Move the right and left multi bars to their sidebar positions
	MultiBarLeft:SetMovable(1);
	MultiBarLeft:ClearAllPoints();
	MultiBarLeft:SetPoint("TOPLEFT", "UIParent", "LEFT", -5, (98 - 80) + 56);
	MultiBarRight:SetMovable(1);
	MultiBarRight:ClearAllPoints();
	MultiBarRight:SetPoint("TOPRIGHT", "UIParent", "RIGHT", 0, 98 + 56);
	
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
	
	--Print output to let the player know the command succeeded, if there is no Cosmos
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
	PartyMemberFrame1:SetMovable(1);
	PartyMemberFrame1:ClearAllPoints();
	PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", newXPos, -128);
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
			BO_ActionButton_UpdateHotkeys(nil, getglobal(name.."Button"..curBut));
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

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
BarOptions.OnEvent = function (event)
	if (event == "VARIABLES_LOADED") then
		--Update the artwork
		BarOptions.UpdateArt();
		--Update which buttons should be showing
		BarOptions.UpdateButtons();
		--Update the button IDs
		ChangeActionBarPage();
	end
end;

BarOptions.OnLoad = function ()
	if ( BarOptions.Initialized ~= 1) then
		--If we don't have Cosmos, then we need to store our setting our self,
		--and perform a few actions when the variables are loaded
		if ( Cosmos_RegisterConfiguration == nil ) then 
			RegisterForSave("BarOptions_Config");
			this:RegisterEvent("VARIABLES_LOADED");
		end
			
		--Hook the functions that need hooked
		if (BarOptions.Hook) then
			BarOptions.Hook();
		end
		
		--Smart register all the options
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS";
			uitype = "SECTION";
			uilabel = BAROPTIONS_CONFIG_SECTION;
			uidesc = BAROPTIONS_CONFIG_SECTION_INFO;
			supercom = {"/baroptions", "/bo"};
			comaction = "before";
			comsticky = false;
			comhelp = BAROPTIONS_CHAT_COMMAND_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_BAR_SEP";
			uitype = "SEPARATOR";
			uilabel = BAROPTIONS_CONFIG_BAR_HEADER;
			uidesc = BAROPTIONS_CONFIG_BAR_HEADER_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_DEFAULTSETUP";
			uitype = "BUTTON";
			uilabel = BAROPTIONS_CONFIG_DEFAULTSETUP;
			uidesc = BAROPTIONS_CONFIG_DEFAULTSETUP_INFO;
			func = BarOptions.DefaultSetup;
			uitext = BAROPTIONS_CONFIG_DEFAULTSETUP_NAME;
			supercom = "/baroptions";
			subcom = {"default"};
			subhelp = BAROPTIONS_CONFIG_DEFAULTSETUP_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_SIDEBARSETUP";
			uitype = "BUTTON";
			uilabel = BAROPTIONS_CONFIG_SIDEBARSETUP;
			uidesc = BAROPTIONS_CONFIG_SIDEBARSETUP_INFO;
			func = BarOptions.SideBarSetup;
			uitext = BAROPTIONS_CONFIG_SIDEBARSETUP_NAME;
			supercom = "/baroptions";
			subcom = {"sidebar"};
			subhelp = BAROPTIONS_CONFIG_SIDEBARSETUP_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_ALTERNATEIDS";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_ALTERNATEIDS;
			uidesc = BAROPTIONS_CONFIG_ALTERNATEIDS_INFO;
			varbool = "BarOptions_Config.AlternateIDs";
			update = ChangeActionBarPage;
			textbool = BAROPTIONS_CHAT_ALTERNATEIDS;
			uicheck = BarOptions_Config.AlternateIDs;
			supercom = "/baroptions";
			subcom = {"alternateids", "aid"};
			subhelp = BAROPTIONS_CONFIG_ALTERNATEIDS_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_TURNPAGES";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_TURNPAGES;
			uidesc = BAROPTIONS_CONFIG_TURNPAGES_INFO;
			varbool = "BarOptions_Config.TurnPages";
			update = ChangeActionBarPage;
			textbool = BAROPTIONS_CHAT_TURNPAGES;
			uicheck = BarOptions_Config.TurnPages;
			supercom = "/baroptions";
			subcom = {"turnpages", "tp"};
			subhelp = BAROPTIONS_CONFIG_TURNPAGES_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_GROUPPAGES";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_GROUPPAGES;
			uidesc = BAROPTIONS_CONFIG_GROUPPAGES_INFO;
			varbool = "BarOptions_Config.GroupPages";
			update = ChangeActionBarPage;
			textbool = BAROPTIONS_CHAT_GROUPPAGES;
			uicheck = BarOptions_Config.GroupPages;
			supercom = "/baroptions";
			subcom = {"grouppages", "gp"};
			subhelp = BAROPTIONS_CONFIG_GROUPPAGES_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_STANCEBAR";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_STANCEBAR;
			uidesc = BAROPTIONS_CONFIG_STANCEBAR_INFO;
			varbool = "BarOptions_Config.StanceBar";
			update = ChangeActionBarPage;
			textbool = BAROPTIONS_CHAT_STANCEBAR;
			uicheck = BarOptions_Config.StanceBar;
			supercom = "/baroptions";
			subcom = {"stancebar", "sb"};
			subhelp = BAROPTIONS_CONFIG_STANCEBAR_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_HIDEEMPTY";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_HIDEEMPTY;
			uidesc = BAROPTIONS_CONFIG_HIDEEMPTY_INFO;
			varbool = "BarOptions_Config.HideEmpty";
			update = ChangeActionBarPage;
			textbool = BAROPTIONS_CHAT_HIDEEMPTY;
			uicheck = BarOptions_Config.HideEmpty;
			supercom = "/baroptions";
			subcom = {"hideempty", "he"};
			subhelp = BAROPTIONS_CONFIG_HIDEEMPTY_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_HOTKEY_SEP";
			uitype = "SEPARATOR";
			uilabel = BAROPTIONS_CONFIG_HOTKEY_HEADER;
			uidesc = BAROPTIONS_CONFIG_HOTKEY_HEADER_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_HIDEKEYS";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_HIDEKEYS;
			uidesc = BAROPTIONS_CONFIG_HIDEKEYS_INFO;
			varbool = "BarOptions_Config.HideKeys";
			update = BarOptions.UpdateHotkeys;
			textbool = BAROPTIONS_CHAT_HIDEKEYS;
			uicheck = BarOptions_Config.HideKeys;
			supercom = "/baroptions";
			subcom = {"hidekeys", "hk"};
			subhelp = BAROPTIONS_CONFIG_HIDEKEYS_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_MULTIKEYS";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_MULTIKEYS;
			uidesc = BAROPTIONS_CONFIG_MULTIKEYS_INFO;
			varbool = "BarOptions_Config.MultiKeys";
			update = BarOptions.ShowMultiHotkeys;
			textbool = BAROPTIONS_CHAT_MULTIKEYS;
			uicheck = BarOptions_Config.MultiKeys;
			supercom = "/baroptions";
			subcom = {"multikeys", "mk"};
			subhelp = BAROPTIONS_CONFIG_MULTIKEYS_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_SHORTKEYS";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_SHORTKEYS;
			uidesc = BAROPTIONS_CONFIG_SHORTKEYS_INFO;
			varbool = "BarOptions_Config.ShortKeys";
			update = BarOptions.UpdateHotkeys;
			textbool = BAROPTIONS_CHAT_SHORTKEYS;
			uicheck = BarOptions_Config.ShortKeys;
			supercom = "/baroptions";
			subcom = {"shortkeys", "sk"};
			subhelp = BAROPTIONS_CONFIG_SHORTKEYS_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_HIDEKEYMOD";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_HIDEKEYMOD;
			uidesc = BAROPTIONS_CONFIG_HIDEKEYMOD_INFO;
			varbool = "BarOptions_Config.HideKeyMod";
			update = BarOptions.UpdateHotkeys;
			textbool = BAROPTIONS_CHAT_HIDEKEYMOD;
			uicheck = BarOptions_Config.HideKeyMod;
			supercom = "/baroptions";
			subcom = {"hidekeymod", "hkmod"};
			subhelp = BAROPTIONS_CONFIG_HIDEKEYMOD_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_ART_SEP";
			uitype = "SEPARATOR";
			uilabel = BAROPTIONS_CONFIG_ART_HEADER;
			uidesc = BAROPTIONS_CONFIG_ART_HEADER_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_MAINART";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_MAINART;
			uidesc = BAROPTIONS_CONFIG_MAINART_INFO;
			varbool = "BarOptions_Config.MainArt";
			update = BarOptions.UpdateArt;
			textbool = BAROPTIONS_CHAT_MAINART;
			uicheck = BarOptions_Config.MainArt;
			supercom = "/baroptions";
			subcom = {"mainart", "ma"};
			subhelp = BAROPTIONS_CONFIG_MAINART_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_BLART";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_BLART;
			uidesc = BAROPTIONS_CONFIG_BLART_INFO;
			varbool = "BarOptions_Config.BLArt";
			update = BarOptions.UpdateArt;
			textbool = BAROPTIONS_CHAT_BLART;
			uicheck = BarOptions_Config.BLArt;
			supercom = "/baroptions";
			subcom = {"blart", "bla"};
			subhelp = BAROPTIONS_CONFIG_BLART_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_BRART";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_BRART;
			uidesc = BAROPTIONS_CONFIG_BRART_INFO;
			varbool = "BarOptions_Config.BRArt";
			update = BarOptions.UpdateArt;
			textbool = BAROPTIONS_CHAT_BRART;
			uicheck = BarOptions_Config.BRArt;
			supercom = "/baroptions";
			subcom = {"brart", "bra"};
			subhelp = BAROPTIONS_CONFIG_BRART_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_RART";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_RART;
			uidesc = BAROPTIONS_CONFIG_RART_INFO;
			varbool = "BarOptions_Config.RArt";
			update = BarOptions.UpdateArt;
			textbool = BAROPTIONS_CHAT_RART;
			uicheck = BarOptions_Config.RArt;
			supercom = "/baroptions";
			subcom = {"rart", "ra"};
			subhelp = BAROPTIONS_CONFIG_RART_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_LART";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_LART;
			uidesc = BAROPTIONS_CONFIG_LART_INFO;
			varbool = "BarOptions_Config.LArt";
			update = BarOptions.UpdateArt;
			textbool = BAROPTIONS_CHAT_LART;
			uicheck = BarOptions_Config.LArt;
			supercom = "/baroptions";
			subcom = {"lart", "la"};
			subhelp = BAROPTIONS_CONFIG_LART_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_COUNT_SEP";
			uitype = "SEPARATOR";
			uilabel = BAROPTIONS_CONFIG_COUNT_HEADER;
			uidesc = BAROPTIONS_CONFIG_COUNT_HEADER_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_BLCOUNT";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_BLCOUNT;
			uidesc = BAROPTIONS_CONFIG_BLCOUNT_INFO;
			varnum = "BarOptions_Config.BLCount";
			update = BarOptions.UpdateButtons;
			textnum = BAROPTIONS_CHAT_BLCOUNT;
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
			uivar = "COS_BAROPTIONS_BRCOUNT";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_BRCOUNT;
			uidesc = BAROPTIONS_CONFIG_BRCOUNT_INFO;
			varnum = "BarOptions_Config.BRCount";
			update = BarOptions.UpdateButtons;
			textnum = BAROPTIONS_CHAT_BRCOUNT;
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
			uivar = "COS_BAROPTIONS_RCOUNT";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_RCOUNT;
			uidesc = BAROPTIONS_CONFIG_RCOUNT_INFO;
			varnum = "BarOptions_Config.RCount";
			update = BarOptions.UpdateButtons;
			textnum = BAROPTIONS_CHAT_RCOUNT;
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
			uivar = "COS_BAROPTIONS_LCOUNT";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_LCOUNT;
			uidesc = BAROPTIONS_CONFIG_LCOUNT_INFO;
			varnum = "BarOptions_Config.LCount";
			update = BarOptions.UpdateButtons;
			textnum = BAROPTIONS_CHAT_LCOUNT;
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
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_RANGECOLOR_SEP";
			uitype = "SEPARATOR";
			uilabel = BAROPTIONS_CONFIG_RANGECOLOR_HEADER;
			uidesc = BAROPTIONS_CONFIG_RANGECOLOR_HEADER_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_RANGECOLOR";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_RANGECOLOR;
			uidesc = BAROPTIONS_CONFIG_RANGECOLOR_INFO;
			varbool = "BarOptions_Config.RangeColor";
			update = ChangeActionBarPage;
			textbool = BAROPTIONS_CHAT_RANGECOLOR;
			uicheck = BarOptions_Config.RangeColor;
			supercom = "/baroptions";
			subcom = {"rangecolor", "rc"};
			subhelp = BAROPTIONS_CONFIG_RANGECOLOR_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_RANGECOLORRED";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_RANGECOLORRED;
			uidesc = BAROPTIONS_CONFIG_RANGECOLORRED_INFO;
			varnum = "BarOptions_Config.RangeColorRed";
			textnum = BAROPTIONS_CHAT_RANGECOLORRED;
			uislider = BarOptions_Config.RangeColorRed;
			uimin = 0;
			uimax = 1;
			uitext = BAROPTIONS_CONFIG_RANGECOLOR_NAME;
			uistep = 0.01;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX;
			uimul = 100;
			supercom = "/baroptions";
			subcom = {"rcred", "rcr"};
			subhelp = BAROPTIONS_CONFIG_RANGECOLORRED_INFO..BAROPTIONS_CHAT_RANGECOLOR_RANGE;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_RANGECOLORGREEN";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_RANGECOLORGREEN;
			uidesc = BAROPTIONS_CONFIG_RANGECOLORGREEN_INFO;
			varnum = "BarOptions_Config.RangeColorGreen";
			textnum = BAROPTIONS_CHAT_RANGECOLORGREEN;
			uislider = BarOptions_Config.RangeColorGreen;
			uimin = 0;
			uimax = 1;
			uitext = BAROPTIONS_CONFIG_RANGECOLOR_NAME;
			uistep = 0.01;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX;
			uimul = 100;
			supercom = "/baroptions";
			subcom = {"rcgreen", "rcg"};
			subhelp = BAROPTIONS_CONFIG_RANGECOLORGREEN_INFO..BAROPTIONS_CHAT_RANGECOLOR_RANGE;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_RANGECOLORBLUE";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_RANGECOLORBLUE;
			uidesc = BAROPTIONS_CONFIG_RANGECOLORBLUE_INFO;
			varnum = "BarOptions_Config.RangeColorBlue";
			textnum = BAROPTIONS_CHAT_RANGECOLORBLUE;
			uislider = BarOptions_Config.RangeColorBlue;
			uimin = 0;
			uimax = 1;
			uitext = BAROPTIONS_CONFIG_RANGECOLOR_NAME;
			uistep = 0.01;
			uitexton = 1;
			uisuffix = BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX;
			uimul = 100;
			supercom = "/baroptions";
			subcom = {"rcblue", "rcb"};
			subhelp = BAROPTIONS_CONFIG_RANGECOLORBLUE_INFO..BAROPTIONS_CHAT_RANGECOLOR_RANGE;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_STANCE_SEP";
			uitype = "SEPARATOR";
			uilabel = BAROPTIONS_CONFIG_STANCE_HEADER;
			uidesc = BAROPTIONS_CONFIG_STANCE_HEADER_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_CUSTOMSTANCES";
			uitype = "CHECKBOX";
			uilabel = BAROPTIONS_CONFIG_CUSTOMSTANCES;
			uidesc = BAROPTIONS_CONFIG_CUSTOMSTANCES_INFO;
			varbool = "BarOptions_Config.CustomStances";
			update = ChangeActionBarPage;
			textbool = BAROPTIONS_CHAT_CUSTOMSTANCES;
			uicheck = BarOptions_Config.CustomStances;
			supercom = "/baroptions";
			subcom = {"customstances", "cs"};
			subhelp = BAROPTIONS_CONFIG_CUSTOMSTANCES_INFO;
		} );
		MCom.registerSmart( {
			uivar = "COS_BAROPTIONS_STANCE0";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_STANCE0;
			uidesc = BAROPTIONS_CONFIG_STANCE0_INFO;
			varnum = "BarOptions_Config.Stance0";
			update = function () if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 0)) then ChangeActionBarPage(); end; end;
			textnum = BAROPTIONS_CHAT_STANCE0;
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
			uivar = "COS_BAROPTIONS_STANCE1";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_STANCE1;
			uidesc = BAROPTIONS_CONFIG_STANCE1_INFO;
			varnum = "BarOptions_Config.Stance1";
			update = function () if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 1)) then ChangeActionBarPage(); end; end;
			textnum = BAROPTIONS_CHAT_STANCE1;
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
			uivar = "COS_BAROPTIONS_STANCE2";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_STANCE2;
			uidesc = BAROPTIONS_CONFIG_STANCE2_INFO;
			varnum = "BarOptions_Config.Stance2";
			update = function () if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 2)) then ChangeActionBarPage(); end; end;
			textnum = BAROPTIONS_CHAT_STANCE2;
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
			uivar = "COS_BAROPTIONS_STANCE3";
			uitype = "SLIDER";
			uilabel = BAROPTIONS_CONFIG_STANCE3;
			uidesc = BAROPTIONS_CONFIG_STANCE3_INFO;
			varnum = "BarOptions_Config.Stance3";
			update = function () if ((BarOptions_Config.CustomStances == 1) and (GetBonusBarOffset() == 3)) then ChangeActionBarPage(); end; end;
			textnum = BAROPTIONS_CHAT_STANCE3;
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
		
		BarOptions.Initialized = 1;
	end
end;