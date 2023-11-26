--[[
	LookLockConfig
	 	Configuration options for LookLock
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	This registers all of the configurations options with MCom to allow the user to
	modify the config options, either by slash commands, or a user interface.
	
	$Id: LookLockConfig.lua 2544 2005-09-30 01:25:32Z mugendai $
	$Rev: 2544 $
	$LastChangedBy: mugendai $
	$Date: 2005-09-29 20:25:32 -0500 (Thu, 29 Sep 2005) $
]]--

--------------------------------------------------
--
-- Configuration Registration
--
--------------------------------------------------
LookLock.Register = function ()
	local superCom = {"/looklock", "/ll", "/llk"};
	if (LootLinkFrame) then
		superCom = {"/looklock", "/llk"};
	end
	
	--Smart register all the options
	--Register a header
	MCom.registerSmart( {
		uifolder = "other";																--The Khaos folder to put the option in
		uisec = "LookLock";																--The section for the UI
		uiseclabel = LOOKLOCK_CONFIG_HEADER;							--The label for the section in the UI
		uisecdesc = LOOKLOCK_CONFIG_HEADER_INFO;				--The description for the section in the UI
		uisecdiff = 2;																		--The section's difficulty in Khaos
		uisecdef = false;																	--Whether the section should be default enabled or not in Khaos
		uivar = "LookLockHeader";													--The option name for the UI
		uitype = K_HEADER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_HEADER;									--The label to use for the seperator in the UI
		uidesc = LOOKLOCK_CONFIG_HEADER_INFO;							--The description to use for the seperator in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uiver = LookLock.VERSION;													--The version number to display in the UI
		uiframe = "LookLockFrame";												--The frame to identify this addon by
		supercom = superCom;															--The main slash command, and any aliases for it
		comaction = "before";															--See Sky for info on this
		comsticky = false;																--See Sky for info on this
		comhelp = LOOKLOCK_CHAT_COMMAND_INFO;							--The help text to show for the slash command
		name = LOOKLOCK_CONFIG_HEADER;										--The name of the addon, for display in the info text
		infotext = LOOKLOCK_CONFIG_INFOTEXT;							--The text to show when the help function is called
		uiauthor = "Mugendai";
		uiwww = "http://www.curse-gaming.com/mod.php?addid=171";
		uimail = "mugekun@gmail.com";
	} );
	--Register a checkbox, and a boolean sub slash command for Remap
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "LookLockRemap";													--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_REMAP;									--The label to use for the checkbox in the UI
		uidesc = LOOKLOCK_CONFIG_REMAP_INFO;							--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		varbool = "LookLock_Config.Remap";								--The boolean variable associate with this option
		textname = LOOKLOCK_CHAT_REMAP;										--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.Remap;									--The default value for the checkbox in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"remap", "rm", "mousecontrol", "mbc"};	--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_REMAP_INFO;							--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for Strafe
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "LookLockStrafe";													--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_STRAFE;									--The label to use for the checkbox in the UI
		uidesc = LOOKLOCK_CONFIG_STRAFE_INFO;							--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = { ["LookLockRemap"] = { checked = true } };
		varbool = "LookLock_Config.Strafe";								--The boolean variable associate with this option
		textname = LOOKLOCK_CHAT_STRAFE;									--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.Strafe;									--The default value for the checkbox in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"strafe", "st"};												--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_STRAFE_INFO;						--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for SelectMode
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "LookLockSelectMode";											--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_SELECT;									--The label to use for the checkbox in the UI
		uidesc = LOOKLOCK_CONFIG_SELECT_INFO;							--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = {	["LookLockRemap"] = { checked = true };	};
		varbool = "LookLock_Config.SelectMode";						--The boolean variable associate with this option
		textname = LOOKLOCK_CHAT_SELECT;									--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.SelectMode;							--The default value for the checkbox in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"selectmode", "sm"};										--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_SELECT_INFO;						--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for UseCursor
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "LookLockUseCursor";											--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_CURSOR;									--The label to use for the checkbox in the UI
		uidesc = LOOKLOCK_CONFIG_CURSOR_INFO;							--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = {	["LookLockRemap"] = { checked = true };	};
		varbool = "LookLock_Config.UseCursor";						--The boolean variable associate with this option
		textname = LOOKLOCK_CHAT_CURSOR;									--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.UseCursor;							--The default value for the checkbox in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"usecursor", "uc"};											--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_CURSOR_INFO;						--The help text for the sub slash command
	} );
	--Register a checkbox/slider, and a bool/number sub slash command for EasyLook
	MCom.registerSmart( {
		hasbool = true;
		uivar = "LookLockEasyLook";												--The option name for the UI
		uitype = K_SLIDER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_EASYLOOK;								--The label to use for the option in the UI
		uidesc = LOOKLOCK_CONFIG_EASYLOOK_INFO;						--The description to use for the option in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		varbool = "LookLock_Config.EasyLook";							--The boolean variable associate with this option
		varnum = "LookLock_Config.EasyLookTime";					--The number variable associate with this option
		textname = LOOKLOCK_CHAT_EASYLOOK;								--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.EasyLook;								--The default value for the checkbox in the UI
		uislider = LookLock_Config.EasyLookTime;					--The default value for the slider in the UI
		uimin = 0.5;																			--The minimum value for the slider in the UI
		uimax = 5;																				--The maximum value for the slider in the UI
		uitext = LOOKLOCK_CONFIG_EASYLOOK_TEXT;						--The text to show above the slider in the UI
		uistep = 0.1;																			--The increment to increase the slider in the UI
		uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
		uisuffix = LOOKLOCK_CONFIG_EASYLOOK_SUFFIX;				--The suffix to place after the slider value
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"easylook", "el"};											--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_AREAWIDTH_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox/slider, and a bool/number sub slash command for EasyCamera
	MCom.registerSmart( {
		hasbool = true;
		uivar = "LookLockEasyCamera";											--The option name for the UI
		uitype = K_SLIDER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_EASYCAMERA;							--The label to use for the option in the UI
		uidesc = LOOKLOCK_CONFIG_EASYCAMERA_INFO;					--The description to use for the option in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		varbool = "LookLock_Config.EasyCamera";						--The boolean variable associate with this option
		varnum = "LookLock_Config.EasyCameraTime";				--The number variable associate with this option
		textname = LOOKLOCK_CHAT_EASYCAMERA;							--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.EasyCamera;							--The default value for the checkbox in the UI
		uislider = LookLock_Config.EasyCameraTime;				--The default value for the slider in the UI
		uimin = 0.5;																			--The minimum value for the slider in the UI
		uimax = 5;																				--The maximum value for the slider in the UI
		uitext = LOOKLOCK_CONFIG_EASYCAMERA_TEXT;					--The text to show above the slider in the UI
		uistep = 0.1;																			--The increment to increase the slider in the UI
		uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
		uisuffix = LOOKLOCK_CONFIG_EASYCAMERA_SUFFIX;			--The suffix to place after the slider value
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"easycamera", "ec"};										--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_EASYCAMERA_INFO;				--The help text for the sub slash command
	} );
	--[[ Blizzard broke always look mode, probably for good, *cry*
	--Register a header for Always Look
	MCom.registerSmart( {
		uitype = K_HEADER;																--The option type for the UI
		uivar = "LookLockAlwaysLookSep";									--The option name for the UI
		uilabel = LOOKLOCK_CONFIG_ALWAYS_SEP;							--The label to use for the checkbox in the UI
		uidesc = LOOKLOCK_CONFIG_ALWAYS_SEP_INFO;					--The description to use for the checkbox in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
	} );
	--Register a checkbox, and a boolean sub slash command for AlwaysLook
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "LookLockAlwaysLook";											--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_ALWAYS;									--The label to use for the checkbox in the UI
		uidesc = LOOKLOCK_CONFIG_ALWAYS_INFO;							--The description to use for the checkbox in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
		varbool = "LookLock_Config.AlwaysLook";						--The boolean variable associate with this option
		textname = LOOKLOCK_CHAT_ALWAYS;									--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.AlwaysLook;							--The default value for the checkbox in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"alwayslook", "al"};										--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_ALWAYS_INFO;						--The help text for the sub slash command
	} );
	--Register a slider, and a number sub slash command for LookTime
	MCom.registerSmart( {
		uivar = "LookLockLookTime";												--The option name for the UI
		uitype = K_SLIDER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_LOOKTIME;								--The label to use for the option in the UI
		uidesc = LOOKLOCK_CONFIG_LOOKTIME_INFO;						--The description to use for the option in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
		varnum = "LookLock_Config.LookTime";							--The number variable associate with this option
		textname = LOOKLOCK_CHAT_LOOKTIME;								--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig();										--A command to perform when the option is succesfully updated
		uislider = LookLock_Config.LookTime;							--The default value for the slider in the UI
		uimin = 0;																				--The minimum value for the slider in the UI
		uimax = 5;																				--The maximum value for the slider in the UI
		uitext = LOOKLOCK_CONFIG_LOOKTIME_TEXT;						--The text to show above the slider in the UI
		uistep = 0.1;																			--The increment to increase the slider in the UI
		uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"looktime", "lt"};											--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_LOOKTIME_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for UseArea
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "LookLockUseArea";												--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_USEAREA;								--The label to use for the checkbox in the UI
		uidesc = LOOKLOCK_CONFIG_USEAREA_INFO;						--The description to use for the checkbox in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
		varbool = "LookLock_Config.UseArea";							--The boolean variable associate with this option
		textname = LOOKLOCK_CHAT_USEAREA;									--What to say when the command is successfully updated, and there is no GUI
		update = LookLock.SaveConfig;											--A command to perform when the option is succesfully updated
		uicheck = LookLock_Config.UseArea;								--The default value for the checkbox in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"usearea", "ua"};												--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_USEAREA_INFO;						--The help text for the sub slash command
	} );
	--Register a slider, and a number sub slash command for AreaWidth
	MCom.registerSmart( {
		uivar = "LookLockAreaWidth";											--The option name for the UI
		uitype = K_SLIDER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_AREAWIDTH;							--The label to use for the option in the UI
		uidesc = LOOKLOCK_CONFIG_AREAWIDTH_INFO;					--The description to use for the option in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
		varnum = "LookLock_Config.AreaWidth";							--The number variable associate with this option
		textname = LOOKLOCK_CHAT_AREAWIDTH;								--What to say when the command is successfully updated, and there is no GUI
		update = function ()															--A command to perform when the option is succesfully updated
							LookLock.SaveConfig();
							LookLock.UpdateArea();
						end;
		uislider = LookLock_Config.AreaWidth;							--The default value for the slider in the UI
		uimin = 0.04;																			--The minimum value for the slider in the UI
		uimax = 1;																				--The maximum value for the slider in the UI
		uitext = LOOKLOCK_CONFIG_AREAWIDTH_TEXT;					--The text to show above the slider in the UI
		uistep = 0.01;																		--The increment to increase the slider in the UI
		uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
		uisuffix = LOOKLOCK_CONFIG_AREAWIDTH_SUFFIX;			--The suffix to place after the slider value
		uimul = 100;																			--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"areawidth", "aw"};											--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_AREAWIDTH_INFO;					--The help text for the sub slash command
	} );
	--Register a slider, and a number sub slash command for AreaHeight
	MCom.registerSmart( {
		uivar = "LookLockAreaHeight";											--The option name for the UI
		uitype = K_SLIDER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_AREAHEIGHT;							--The label to use for the option in the UI
		uidesc = LOOKLOCK_CONFIG_AREAHEIGHT_INFO;					--The description to use for the option in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
		varnum = "LookLock_Config.AreaHeight";						--The number variable associate with this option
		textname = LOOKLOCK_CHAT_AREAHEIGHT;							--What to say when the command is successfully updated, and there is no GUI
		update = function ()															--A command to perform when the option is succesfully updated
							LookLock.SaveConfig();
							LookLock.UpdateArea();
						end;
		uislider = LookLock_Config.AreaHeight;						--The default value for the slider in the UI
		uimin = 0.05;																			--The minimum value for the slider in the UI
		uimax = 1;																				--The maximum value for the slider in the UI
		uitext = LOOKLOCK_CONFIG_AREAHEIGHT_TEXT;					--The text to show above the slider in the UI
		uistep = 0.01;																		--The increment to increase the slider in the UI
		uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
		uisuffix = LOOKLOCK_CONFIG_AREAHEIGHT_SUFFIX;			--The suffix to place after the slider value
		uimul = 100;																			--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"areaheight", "ah"};										--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_AREAHEIGHT_INFO;				--The help text for the sub slash command
	} );
	--Register a slider, and a number sub slash command for AreaHOff
	MCom.registerSmart( {
		uivar = "LookLockAreaHOff";												--The option name for the UI
		uitype = K_SLIDER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_AREAHOFF;								--The label to use for the option in the UI
		uidesc = LOOKLOCK_CONFIG_AREAHOFF_INFO;						--The description to use for the option in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
		varnum = "LookLock_Config.AreaHOff";							--The number variable associate with this option
		textname = LOOKLOCK_CHAT_AREAHOFF;								--What to say when the command is successfully updated, and there is no GUI
		update = function ()															--A command to perform when the option is succesfully updated
							LookLock.SaveConfig();
							LookLock.UpdateArea();
						end;
		uislider = LookLock_Config.AreaHOff;							--The default value for the slider in the UI
		uimin = -1;																				--The minimum value for the slider in the UI
		uimax = 1;																				--The maximum value for the slider in the UI
		uitext = LOOKLOCK_CONFIG_AREAHOFF_TEXT;						--The text to show above the slider in the UI
		uistep = 0.01;																		--The increment to increase the slider in the UI
		uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
		uisuffix = LOOKLOCK_CONFIG_AREAHOFF_SUFFIX;				--The suffix to place after the slider value
		uimul = 100;																			--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"areahorizoffset", "aho"};							--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_AREAHOFF_INFO;					--The help text for the sub slash command
	} );
	--Register a slider, and a number sub slash command for AreaVOff
	MCom.registerSmart( {
		uivar = "LookLockAreaVOff";												--The option name for the UI
		uitype = K_SLIDER;																--The option type for the UI
		uilabel = LOOKLOCK_CONFIG_AREAVOFF;								--The label to use for the option in the UI
		uidesc = LOOKLOCK_CONFIG_AREAVOFF_INFO;						--The description to use for the option in the UI
		uidiff = 3;																				--The option's difficulty in Khaos
		varnum = "LookLock_Config.AreaVOff";							--The number variable associate with this option
		textname = LOOKLOCK_CHAT_AREAVOFF;								--What to say when the command is successfully updated, and there is no GUI
		update = function ()															--A command to perform when the option is succesfully updated
							LookLock.SaveConfig();
							LookLock.UpdateArea();
						end;
		uislider = LookLock_Config.AreaVOff;							--The default value for the slider in the UI
		uimin = -1;																				--The minimum value for the slider in the UI
		uimax = 1;																				--The maximum value for the slider in the UI
		uitext = LOOKLOCK_CONFIG_AREAVOFF_TEXT;						--The text to show above the slider in the UI
		uistep = 0.01;																		--The increment to increase the slider in the UI
		uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
		uisuffix = LOOKLOCK_CONFIG_AREAVOFF_SUFFIX;				--The suffix to place after the slider value
		uimul = 100;																			--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/looklock";														--The main(super) slash command associated with this subommand
		subcom = {"areavertoffset", "avo"};								--The sub slash command and any aliases for this option
		subhelp = LOOKLOCK_CONFIG_AREAVOFF_INFO;					--The help text for the sub slash command
	} );
	]]--
	if (Eclipse and Eclipse.Solar) then
		--Register wih VisibilityOptions to make the targeting cursor transparentable
		Eclipse.Solar.registerForTransparency( {
			name = "LookLockCursor";
			supercom = "/looklock";													--The main(super) slash command associated with this subommand
			slashcom = { "looklockcursor", "llc" };
			uiname = LOOKLOCK_CONFIG_CURSOR_NAME;
			uisec = "LookLock";																--The section for the UI
			uiseclabel = LOOKLOCK_CONFIG_HEADER;							--The label for the section in the UI
			uisecdesc = LOOKLOCK_CONFIG_HEADER_INFO;					--The description for the section in the UI
			trans = 0.5;
		} );
		--[[
		--Register wih VisibilityOptions to make the look area transparentable
		Eclipse.Solar.registerForTransparency( {
			name = "LookLockArea";
			supercom = "/looklock";														--The main(super) slash command associated with this subommand
			slashcom = { "looklockarea", "lla" };
			uiname = LOOKLOCK_CONFIG_AREA_NAME;
			uisec = "LookLock";																--The section for the UI
			uiseclabel = LOOKLOCK_CONFIG_HEADER;							--The label for the section in the UI
			uisecdesc = LOOKLOCK_CONFIG_HEADER_INFO;					--The description for the section in the UI
			uidiff = 3;
			trans = 0.5;
		} );
		]]--
	end
end