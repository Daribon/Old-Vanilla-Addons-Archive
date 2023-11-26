--[[
	EclipseRegs
	 	Contains the registrations and functions for all the included frames for Eclipse
	
	By: Mugendai
	
	This contains the registrations for each of the included fromes of Eclipse.  It also
	contains any functions for these registrations that are neccisary to allow proper
	behavior of the varying frames.
	
	$Id: EclipseRegs.lua 2177 2005-07-28 01:26:55Z mugendai $
	$Rev: 2177 $
	$LastChangedBy: mugendai $
	$Date: 2005-07-27 20:26:55 -0500 (Wed, 27 Jul 2005) $
]]--

--[[ Registers several UI frames with Eclipse ]]--
Eclipse.RegisterFrames = function ()
	if ( Eclipse.Initialized ~= 1) then
		--Use the variable that specifies if shapeshift bar is shown, instead of simply checking to see if it is visible.
		MCom.util.hook("ShapeshiftBar_UpdatePosition", "Eclipse.ShapeshiftBar_UpdatePosition", "replace");
		--Makes the right sidebar properly offset the bags, based on if the bar is actually enabled, as apposed to visible
		MCom.util.hook("UIParent_ManageRightSideFrames", "Eclipse.UIParent_ManageRightSideFrames", "after");
		--We need to hook this cause the origional function only checks by visibility, insead of the right way
		MCom.util.hook("PetActionBar_UpdatePosition", "Eclipse.PetActionBar_UpdatePosition", "after");

		--Setup the name to display
		local infoName = string.format(MCOM_HELP_CONFIG, ECLIPSE_CONFIG_SECTION);
		local infoDesc = string.format(MCOM_HELP_TITLE, ECLIPSE_CONFIG_SECTION);
		
		local infoFunc = function ()
			--Get the info text and title
			local infotext = Sea.table.copy(ECLIPSE_CONFIG_INFOTEXT);
			local infotitle = infoDesc;
			--Add the slash command info on to it
			infotext[table.getn(infotext) + 1] = MCom.PrintSlashCommandInfo(MCom.getComID("/hide"), true);
			infotext[table.getn(infotext) + 1] = MCom.PrintSlashCommandInfo(MCom.getComID("/autohide"), true);
			infotext[table.getn(infotext) + 1] = MCom.PrintSlashCommandInfo(MCom.getComID("/trans"), true);
			--Show the text frame
			MCom.textFrame( { text = infotext; title = infotitle; } );
		end
		
		--Register the main VisOpts section
		MCom.registerSmart( {
			uifolder = "frames";
			uisec = "VisibilityOptions";
			uiseclabel = ECLIPSE_CONFIG_SECTION;
			uisecdesc = ECLIPSE_CONFIG_SECTION_INFO;
			uisecdiff = 1;
			uisep = "VisibilityOptionsSeparator";
			uiseplabel = ECLIPSE_CONFIG_SECTION;
			uisepdesc = ECLIPSE_CONFIG_SECTION_INFO;
			uisepdiff = 1;
			uivar = "VisibilityOptionsHelp";									--The option name for the UI
			uitype = K_BUTTON;																--The option type for the UI
			uilabel = infoName;																--The label to use for the checkbox in the UI
			uidesc = infoDesc;																--The description to use for the checkbox in the UI
			uidiff = 1;																				--The option's difficulty in Khaos
			uifunc = infoFunc;																--The function to call
			uitext = MCOM_HELP_GENERIC_TITLE;									--The text to show on the button
			uiver = Eclipse.VERSION;													--The version number to display in the UI
			uiframe = "EclipseFrame";													--The frame to identify this addon by
		} );
		--Register the slash commands
		MCom.registerSmart( {
			supercom = { "/hide", "/show", "/voh" };						--The main(super) slash command associated with this subommand
			comaction = "before";																--See Sky for info on this
			comsticky = false;																	--See Sky for info on this
			comhelp = TOTAL_CHAT_COMMAND_INFO;									--The help text to show for the slash command
			extrahelp = TOTAL_CHAT_COMMAND_HELP;								--Extra help text to print out
			subcom = MCOM_HELP_COMMAND;
			subhelp = infoDesc;
			comtype = MCOM_SIMPLET;
			func = infoFunc;
		} );
		MCom.registerSmart( {
			supercom = {"/autohide", "/ahide", "/voah"};				--The main(super) slash command associated with this subommand
			comaction = "before";																--See Sky for info on this
			comsticky = false;																	--See Sky for info on this
			comhelp = LUNAR_CHAT_COMMAND_INFO;									--The help text to show for the slash command
			extrahelp = LUNAR_CHAT_COMMAND_HELP;								--Extra help text to print out
			subcom = MCOM_HELP_COMMAND;
			subhelp = infoDesc;
			comtype = MCOM_SIMPLET;
			func = infoFunc;
		} );
		MCom.registerSmart( {
			supercom = {"/transparency", "/trans", "/vot"};			--The main(super) slash command associated with this subommand
			comaction = "before";																--See Sky for info on this
			comsticky = false;																	--See Sky for info on this
			comhelp = SOLAR_CHAT_COMMAND_INFO;									--The help text to show for the slash command
			extrahelp = SOLAR_CHAT_COMMAND_HELP;								--Extra help text to print out
			subcom = MCOM_HELP_COMMAND;
			subhelp = infoDesc;
			comtype = MCOM_SIMPLET;
			func = infoFunc;
		} );

		--In the case that bar options isn't loaded, we dun wanna stick stuff in its section
		local barSec = nil;
		if (BarOptions) then
			barSec = "BarOptions";
		end

		--Register MainBar
		--We need to register one way if we have BarOptions, and another if we dont
		if (BarOptions) then
			Eclipse.Total.registerForHide( {
				--We don't want to hide the actual frame, so we make this virtual one, and let
				--the special function for mainbar handle it.
				name = "MainBar";
				slashcom = {"mainbar", "main", "mb"};
				uisec = "BarOptions";
				uiname = ECLIPSE_CONFIG_MAINBAR;
			} );
			Eclipse.registerForVisibility( {
				name = "MainMenuBar";
				--We have a seperate register for total
				nototal = true;
				checkframes = { "MainMenuBar", "MultiBarBottomLeft", "PetActionBarFrame", "ShapeshiftBarFrame" };
				slashcom = {"mainbar", "main", "mb"};
				uisec = "BarOptions";
				uiname = ECLIPSE_CONFIG_MAINBAR;
				--Because the hiding and showing proccess is very complex, we use a before callback to handle the
				--hiding and showing manually, the callback returns true to let Lunar know not to use its own funcs
				callback = Eclipse.ShowHideMainBar;
				callhow = Eclipse.Lunar.CALL_BEFORE;
				reqs = {	{ var = "Eclipse.Frames.MultiBarBottomLeft.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.PetActionBarFrame.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.ShapeshiftBarFrame.autohide"; val = 0; show = true; };	};
			} );
	
			--Register ActionBar
			--We first register all of the action bar and bonus action bar buttons with Eclipse
			--so that only one of the two bars is onscreen at once(due to the confangled design
			--of ActionBar and BonusActionBar)
			for index = 1, 12 do
				Eclipse.SetFrame( {
					name = "ActionButton"..index;
					reqs = { var = function () return ( GetBonusBarOffset() <= 0 ); end; val = true; hide = true; };
				}	);
			end
			for index = 1, 12 do
				Eclipse.SetFrame( {
					name = "BOBonusActionButton"..index;
					reqs = { var = function () return ( GetBonusBarOffset() > 0 ); end; val = true; hide = true; };
				}	);
			end
			Eclipse.registerForVisibility( {
				name = "ActionBar";
				--For Solar, we just want to adjust the entire bar
				nosolar = true;
				--Register only the buttons of the action/bonus action bar, as this is what we wanna hide/show
				frames = {	{ name = "ActionButton"; min = 1; max = 12; };
										{ name = "BOBonusActionButton"; min = 1; max = 12; }; };
				--If any of these frames have the mouse we wanna show this bar
				checkframes = { "ActionBar", "MainMenuBar", "MultiBarBottomLeft", "PetActionBarFrame", "ShapeshiftBarFrame" };
				slashcom = { "action", "mainactionbar", "mab" };
				uisec = "BarOptions";
				uiname = ECLIPSE_CONFIG_ACTIONBAR;
				left = getglobal("ActionButton1");
				top = getglobal("ActionButton1");
				bottom = getglobal("ActionButton1");
				right = getglobal("ActionButton12");
				reqs = {	{ var = "Eclipse.Frames.ActionBar.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.PetActionBarFrame.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.ShapeshiftBarFrame.autohide"; val = 0; show = true; }; };
			} );
			--Register menu buttons
			Eclipse.registerForVisibility( {
				name = "MenuButtons";
				frames = {	"CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "QuestLogMicroButton",
										"SocialsMicroButton", "WorldMapMicroButton", "MainMenuMicroButton", "HelpMicroButton" };
				--If any of these frames have the mouse we wanna show this bar
				checkframes = { "ActionBar", "MainMenuBar", "MultiBarBottomLeft", "PetActionBarFrame", "ShapeshiftBarFrame", "MenuButtons" };
				slashcom = { "menubuttons", "mbn" };
				uisec = "BarOptions";
				uiname = ECLIPSE_CONFIG_MENUBUTTONS;
				reqs = {	{ var = "Eclipse.Frames.ActionBar.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.PetActionBarFrame.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.ShapeshiftBarFrame.autohide"; val = 0; show = true; }; };
				--Because on startup the proper state of these frames is not available, we need to set the default state
				state = {show = true;};
			} );
			--Register bag buttons
			Eclipse.registerForVisibility( {
				name = "BagButtons";
				frames = {	"MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot" };
				--If any of these frames have the mouse we wanna show this bar
				checkframes = { "ActionBar", "MainMenuBar", "MultiBarBottomLeft", "PetActionBarFrame", "ShapeshiftBarFrame", "MenuButtons", "BagButtons" };
				slashcom = { "bagbuttons", "bbn" };
				uisec = "BarOptions";
				uiname = ECLIPSE_CONFIG_BAGBUTTONS;
				reqs = {	{ var = "Eclipse.Frames.ActionBar.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.PetActionBarFrame.autohide"; val = 0; show = true; };
									{ var = "Eclipse.Frames.ShapeshiftBarFrame.autohide"; val = 0; show = true; }; };
				state = {show = true;};
			} );
		else
			--Without BarOptions we can't hide all the parts of the MainBar, seperate from ActionBar... so instead
			--we register only for hiding MainBar, this has the added disadvantage of hiding the pet and stance
			--bar anytime the MainBar is hidden.
			Eclipse.registerForVisibility( {
				name = "MainMenuBar";
				slashcom = {"mainbar", "main", "mb"};
				uiname = ECLIPSE_CONFIG_MAINBAR;
				reqs = {	{ var = "Eclipse.Frames.MultiBarBottomLeft.hasMouse"; val = 1; show = true; };
									{ var = "Eclipse.Frames.PetActionBarFrame.hasMouse"; val = 1; show = true; };
									{ var = "Eclipse.Frames.ShapeshiftBarFrame.hasMouse"; val = 1; show = true; }; };
			} );
		end

		--Register ShapeBar
		Eclipse.ShapeDone = 0;	--This is to deal with an issue that occurs if the shape bar is not show atleast once
		Eclipse.registerForVisibility( {
			name = "ShapeshiftBarFrame";
			slashcom = {"shape", "stance", "aura", "stealth"};
			uisec = barSec;
			uiname = ECLIPSE_CONFIG_SHAPEBAR;
			--Left, top, and bottom can be gotten from the first button of the ShapeBar
			left = getglobal("ShapeshiftButton1");
			top = getglobal("ShapeshiftButton1");
			bottom = getglobal("ShapeshiftButton1");
			--But right needs to be calculated based on the number of forms so we use a function to handle that
			right = Eclipse.GetShapeRight;
			--We pad the sides to include the frame of the shapebar
			leftpad = -5;
			toppad = 3;
			bottompad = -5;
		} );

		--Register PetBar
		Eclipse.registerForVisibility( {
			name = "PetActionBarFrame";
			slashcom = "pet";
			uisec = barSec;
			uiname = ECLIPSE_CONFIG_PETBAR;
			left = getglobal("PetActionButton1");
			right = getglobal("PetActionButton10");
			top = getglobal("PetActionButton1");
			bottom = getglobal("PetActionButton1");
		} );

		--Register Bottom Left MultiBar
		Eclipse.registerForVisibility( {
			name = "MultiBarBottomLeft";
			--This option has its own method of being disabled
			nototal = true;
			--If ShapeBar, or PetBar are hovered we wanna show the BLMB as well
			checkframes = { "MultiBarBottomLeft", "ShapeshiftBarFrame", "PetActionBarFrame" };
			slashcom = {"multibl", "mbl"};
			uisec = barSec;
			uiname = ECLIPSE_CONFIG_MULTIBL;
			reqs = {	{ var = "Eclipse.Frames.PetActionBarFrame.autohide"; val = 0; show = true; };
								{ var = "Eclipse.Frames.ShapeshiftBarFrame.autohide"; val = 0; show = true; }; };
		} );

		--Register Bottom Right MultiBar
		Eclipse.registerForVisibility( {
			name = "MultiBarBottomRight";
			--This option has its own method of being disabled
			nototal = true;
			slashcom = {"multibr", "mbr"};
			uisec = barSec;
			uiname = ECLIPSE_CONFIG_MULTIBR;
		} );

		--Register Right MultiBar
		Eclipse.registerForVisibility( {
			name = "MultiBarRight";
			--This option has its own method of being disabled
			nototal = true;
			slashcom = {"multir", "mr"};
			uisec = barSec;
			uiname = ECLIPSE_CONFIG_MULTIR;
		} );

		--Register Left MultiBar
		Eclipse.registerForVisibility( {
			name = "MultiBarLeft";
			--This option has its own method of being disabled
			nototal = true;
			slashcom = {"multil", "ml"};
			uisec = barSec;
			uiname = ECLIPSE_CONFIG_MULTIL;
		} );

		--Register the Minimap Cluster
		--We are doing only a Total, and Lunar reg here, so that the first Solar option
		--can be UIParent, we will do the Solar for Minimap, after UIParent
		Eclipse.registerForVisibility( {
			name = "MinimapCluster";
			nosolar = true;
			slashcom = {"map", "minimap"};
			uiname = ECLIPSE_CONFIG_MINIMAP;
		} );
		
		--Register UIParent
		Eclipse.Solar.registerForTransparency( {
			name = "UIParent";
			slashcom = "global";
			uiname = ECLIPSE_CONFIG_GLOBAL;
			min = 0.1;
		} );

		--Register the Minimap Cluster
		--Now we finish registering Minimap
		Eclipse.Solar.registerForTransparency( {
			name = "MinimapCluster";
			slashcom = {"map", "minimap"};
			uiname = ECLIPSE_CONFIG_MINIMAP;
		} );

		--Register the Buffs
		Eclipse.registerForVisibility( {
			name = "BuffFrame";
			frames = { "BuffFrame", {name = "BuffButton"; min = 0; max = 23}; {name = "TempEnchant"; min = 1; max = 2}; };
			slashcom = {"buffs", "buff"};
			uiname = ECLIPSE_CONFIG_BUFFS;
			left = getglobal("BuffButton0");
			right = getglobal("BuffButton0");
			top = getglobal("BuffButton0");
			bottom = getglobal("BuffButton0");
			--We can apparently only get positional info from BuffButton0, so we have to pad
			--to the left and bottom to fill in the area
			leftpad = -256;
			bottompad = -106;
		} );

		--Register the Player Frame
		Eclipse.registerForVisibility( {
			name = "PlayerFrame";
			slashcom = {"stats", "player"};
			uiname = ECLIPSE_CONFIG_STATS;
		} );

		--Register the party members frames
		Eclipse.registerForVisibility( {
			name = "PartyFrame";
			--There is no encompasing party members frame, so we have to deal with each one
			frames = { name = "PartyMemberFrame"; min = 1; max = MAX_PARTY_MEMBERS };
			slashcom = {"party"};
			uiname = ECLIPSE_CONFIG_PARTY;
		} );

		--Register chat menu and scroll buttons
		Eclipse.registerForVisibility( {
			name = "ChatFrameButtons";
			--Hide the chat menu button, and all of the chat scroll buttons
			frames =	{	"ChatFrameMenuButton", {name = "ChatFrame%dUpButton"; min = 1; max = 7;},
									{name = "ChatFrame%dDownButton"; min = 1; max = 7;},	{name = "ChatFrame%dBottomButton"; min = 1; max = 7;} };
			slashcom = {"chatframebuttons", "cfb"};
			uiname = ECLIPSE_CONFIG_CHATBUTTONS;
		}	);
	end
end;

--[[
	Handles autohiding for the MainBar
	Because we want to be able to hide the MainBar but not the ActionBar, we need to use
	this complex function, to hide all the parts of MainBar that aren't the ActionBar.
]]--
Eclipse.ShowHideMainBar = function (whichUI, isEnabled, doShow)
	--Deal with Total's absolute hiding
	if ( (not Total_Override) and (Eclipse.Frames.MainBar.wantHide == 1) ) then
		doShow = 0;
		isEnabled = 1;
	end
	
	--Show/Hide the Background textures for the Main Action Bar
	Eclipse.Lunar.showHide("MainMenuBarTexture0", doShow, isEnabled);
	Eclipse.Lunar.showHide("MainMenuBarTexture1", doShow, isEnabled);
	--Show/Hide the Background textures for the Bonus Action Bar
	if ( GetBonusBarOffset() <= 0 ) then
		Eclipse.Lunar.showHide("BOBonusActionBarTexture0", 0, isEnabled);
		Eclipse.Lunar.showHide("BOBonusActionBarTexture1", 0, isEnabled);
	else
		Eclipse.Lunar.showHide("BOBonusActionBarTexture0", doShow, isEnabled);
		Eclipse.Lunar.showHide("BOBonusActionBarTexture1", doShow, isEnabled);
	end
	
	--Show/hide the artwork on the BottomLeftMultiBar if there is any
	local showBLArt = doShow;
	if ( BarOptions_Config.BLArt == 0 ) then
		showBLArt = 0;
	end
	for index = 1, 12 do
		if (index <= BarOptions_Config.BLCount) then
			Eclipse.Lunar.showHide("MultiBarBottomLeftArtButton"..index, showBLArt, isEnabled);
		end
	end
	
	--Find out if we should be showing the Bar Artwork
	local HideEndcaps = true;
	if (BarOptions_Config and (BarOptions_Config.MainArt == 0)) then
		HideEndcaps = false;
	end
	--Show/Hide the bar artwork
	if (HideEndcaps) then
		Eclipse.Lunar.showHide("MainMenuBarLeftEndCap", doShow, isEnabled);
		Eclipse.Lunar.showHide("MainMenuBarRightEndCap", doShow, isEnabled);
	end
	
	--Show/Hide the rest of the Main Bar
	Eclipse.Lunar.showHide("MainMenuBarTexture2", doShow, isEnabled);
	Eclipse.Lunar.showHide("MainMenuBarTexture3", doShow, isEnabled);
	Eclipse.Lunar.showHide("MainMenuBarPageNumber", doShow, isEnabled);
	Eclipse.Lunar.showHide("MainMenuBarOverlayFrame", doShow, isEnabled);
	Eclipse.Lunar.showHide("MainMenuBarPerformanceBarFrame", doShow, isEnabled);
	Eclipse.Lunar.showHide("MainMenuBarPerformanceBarFrameButton", doShow, isEnabled);
	Eclipse.Lunar.showHide("ActionBarUpButton", doShow, isEnabled);
	Eclipse.Lunar.showHide("ActionBarDownButton", doShow, isEnabled);
	Eclipse.Lunar.showHide("ExhaustionLevelFillBar", doShow, isEnabled);

	--Show/Hide the experience bar by making it normal size, or so small it can't be seen
	if (doShow == 1) then
		MainMenuExpBar:SetWidth(1024);
	else
		if (isEnabled == 1) then
			MainMenuExpBar:SetWidth(0.00001);
		elseif (isEnabled == 0) then
			MainMenuExpBar:SetWidth(1024);
		end
	end
	
	--Show/Hide the rest indicator tick
	local exhaustionThreshold = GetXPExhaustion();
	local playerCurrXP = UnitXP("player");
	local playerMaxXP = UnitXPMax("player");
	if (exhaustionThreshold and playerCurrXP and playerMaxXP) then
		--Figure out if the exhaustion tick should be showing or not
		local exhaustionTickSet = ((playerCurrXP + exhaustionThreshold) / playerMaxXP) * 1024;
		if (exhaustionTickSet > 1024) then
			Eclipse.Lunar.showHide("ExhaustionTick", 0, 1);
		else
			Eclipse.Lunar.showHide("ExhaustionTick", doShow, isEnabled);
		end
	else
		Eclipse.Lunar.showHide("ExhaustionTick", 0, 1);
	end
	--If the Exhaustion Tick is visible, then make sure it is in the right spot, since it may
	--have ended up in the wrong spot due to us resizing the exp bar to hide it
	if (ExhaustionTick:IsVisible()) then
		--Get the players CP levels
		local playerCurrXP = UnitXP("player");
		local playerMaxXP = UnitXPMax("player");
		local exhaustionThreshold = GetXPExhaustion();
		local exhaustionStateID, exhaustionStateName, exhaustionStateMultiplier = GetRestState();
		if (exhaustionStateID >= 3) then
			ExhaustionTick:SetPoint("CENTER", "MainMenuExpBar", "RIGHT", 0, 0);
		end
		--If the tick is within visual range, then make sure its in the right spot
		if (exhaustionThreshold) then
			local exhaustionTickSet = max(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * MainMenuExpBar:GetWidth(), 0);
			ExhaustionTick:ClearAllPoints();
			if (exhaustionTickSet <= MainMenuExpBar:GetWidth()) then
				ExhaustionTick:SetPoint("CENTER", "MainMenuExpBar", "LEFT", exhaustionTickSet, 0);
			end
		end
	end
	
	return true;
end;

--[[
	Used to get the right side of the Shapeshift bar, based on how many forms/auras/stances etc.
	are available.  Also does initial showing of the ShapeShiftBar since it needs to be shown
	once before we start messing with it.
]]--
Eclipse.GetShapeRight = function ()
	local right = 0;
	--Find out how many shapeshift/stance/stealt/aura forms we have.
	local forms = GetNumShapeshiftForms();
	if (forms > 0) then
		--If there are any, then the shape bar should be showing, so lets deal with it
		if (Eclipse.ShapeDone == 0) then
			--Because we had to replace the origional function that shows the bar for the first time,
			--we need to show it for the first time ourselves, but only once
			Eclipse.ShapeDone = 1;
			ShapeshiftBarFrame:Show();
		end
		
		local left = nil;
		--Get the frame to work with
		local uiFrame = getglobal("ShapeshiftButton1");
		if (uiFrame) then
			--Right side is calculated as an offset of the left side
			left = uiFrame:GetLeft();
			--Calculate the right side based on the number of forms and position of the buttons
			if (left) then
				left = left - 5;
				local extra = 10;
				extra = extra + (7 * (forms - 1));
				right = left + (((30 * forms) + extra));
			end
		end
	end
	return right;
end;

--[[
	Overrides the origional function to make it use the variable that specifies if the bar
	is shown, instead of simply checking to see if it is visible.
]]--
function Eclipse.ShapeshiftBar_UpdatePosition()
	if ( SHOW_MULTI_ACTIONBAR_1 == 1 ) then
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 45);
		ShapeshiftBarLeft:Hide();
		ShapeshiftBarRight:Hide();
		ShapeshiftBarMiddle:Hide();
		for i=1, GetNumShapeshiftForms() do
			getglobal("ShapeshiftButton"..i.."NormalTexture"):SetWidth(50);
			getglobal("ShapeshiftButton"..i.."NormalTexture"):SetHeight(50);
		end
	else
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
		if ( GetNumShapeshiftForms() > 2 ) then
			ShapeshiftBarMiddle:Show();
		end
		ShapeshiftBarLeft:Show();
		ShapeshiftBarRight:Show();
		for i=1, GetNumShapeshiftForms() do
			getglobal("ShapeshiftButton"..i.."NormalTexture"):SetWidth(64);
			getglobal("ShapeshiftButton"..i.."NormalTexture"):SetHeight(64);
		end
	end
end

--[[ Moves the bags over based on bars being enabled, as apposed to visible ]]--
function Eclipse.UIParent_ManageRightSideFrames()
	-- Update bag anchor
	if ( SHOW_MULTI_ACTIONBAR_2 ) then
		CONTAINER_OFFSET_Y = 97;
	else
		CONTAINER_OFFSET_Y = 70;
	end
	-- Setup x anchor
	if ( SHOW_MULTI_ACTIONBAR_4 ) then
		CONTAINER_OFFSET_X = 90;
		anchorX = 90;
	elseif ( SHOW_MULTI_ACTIONBAR_3 ) then
		CONTAINER_OFFSET_X = 45;
		anchorX = 45;
	else
		CONTAINER_OFFSET_X = 0;
		anchorX = 0;
	end
end

--[[ Fixes pet bar flying off the screen due to bad blizz coding ]]--
function Eclipse.PetActionBar_UpdatePosition()
	if ( ( not PetActionBarFrame:IsVisible() ) and ( PetHasActionBar() == 1 ) ) then
		PetActionBarFrame:SetPoint("TOPLEFT", "MainMenuBar", "BOTTOMLEFT", PETACTIONBAR_XPOS, PETACTIONBAR_YPOS);
	end
end