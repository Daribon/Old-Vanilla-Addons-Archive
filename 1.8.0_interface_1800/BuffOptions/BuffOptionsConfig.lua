--[[
	BuffOptionsConfig
	 	Configuration options for BuffOptions
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	This registers all of the configurations options with MCom to allow the user to
	modify the config options, either by slash commands, or a user interface.
	
	$Id: BuffOptionsConfig.lua 2603 2005-10-12 03:01:28Z mugendai $
	$Rev: 2603 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-11 22:01:28 -0500 (Tue, 11 Oct 2005) $
]]--

--------------------------------------------------
--
-- Configuration Registration
--
--------------------------------------------------
BuffOptions.Register = function ()
	--Smart register all the options
	--Register a header
	MCom.registerSmart( {
		uifolder = "frames";																	--The Khaos folder to put the option in
		uisec = "BuffOptions";															--The section for the UI
		uiseclabel = BUFFOPTIONS_CONFIG_SECTION;						--The label for the section in the UI
		uisecdesc = BUFFOPTIONS_CONFIG_SECTION_INFO;				--The description for the section in the UI
		uisecdiff = 1;																			--The section's difficulty in Khaos
		uisecdef = false;																		--Whether the section should be default enabled or not in Khaos
		uiseccall = nil;																		--A callback to be called when the section is enabled/disabled in Khaos
		uivar = "BuffOptionsSep";														--The option name for the UI
		uitype = K_HEADER;																	--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_MAIN_HEADER;						--The label to use for the seperator in the UI
		uidesc = BUFFOPTIONS_CONFIG_MAIN_HEADER_INFO;				--The description to use for the seperator in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		uicat = MYADDONS_CATEGORY_OTHERS;										--The category to use for MyAddOns
		uiver = BuffOptions.VERSION;												--The version number to display in the UI
		uiframe = "BuffOptionsFrame";												--The frame to identify this addon by
		uioptionsframe = nil;																--The name of the frame to display when the MyAddOns option button is pushed
		supercom = {"/buffoptions", "/bfo"};								--The main slash command, and any aliases for it
		comaction = "before";																--See Sky for info on this
		comsticky = false;																	--See Sky for info on this
		comhelp = BUFFOPTIONS_CHAT_COMMAND_INFO;						--The help text to show for the slash command
		name = BUFFOPTIONS_CONFIG_SECTION;									--The name of the addon, for display in the info text
		infotext = BUFFOPTIONS_CONFIG_INFOTEXT;							--The text to show when the help function is called
		uiauthor = "Mugendai";
		uiwww = "http://www.curse-gaming.com/mod.php?addid=2130";
		uimail = "mugekun@gmail.com";
	} );
	--Register a checkbox, and a boolean sub slash command for Reverse
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsReverse";												--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_REVERSE;								--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_REVERSE_INFO;						--The description to use for the checkbox in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		varbool = "BuffOptions_Config.Reverse";							--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.Reverse;								--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"reverse", "rev"};												--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for Swap
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsSwap";													--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_SWAP;									--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_SWAP_INFO;							--The description to use for the checkbox in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		varbool = "BuffOptions_Config.Swap";								--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.Swap;									--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"swap", "sw"};														--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for Border
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsBorder";												--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_BORDER;								--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_BORDER_INFO;						--The description to use for the checkbox in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		varbool = "BuffOptions_Config.Border";							--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.Border;								--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"border", "bor"};													--The sub slash command and any aliases for this option
	} );
	--Register a slider, and a number sub slash command for Size
	MCom.registerSmart( {
		uivar = "BuffOptionsSize";													--The option name for the UI
		uitype = K_SLIDER;																	--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_SIZE;									--The label to use for the option in the UI
		uidesc = BUFFOPTIONS_CONFIG_SIZE_INFO;							--The description to use for the option in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		varnum = "BuffOptions_Config.Size";									--The number variable associate with this option
		update = function ()	BuffOptions.UpdateSize();			--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uislider = BuffOptions_Config.Size;									--The default value for the slider in the UI
		uimin = 0.5;																				--The minimum value for the slider in the UI
		uimax = 2;																					--The maximum value for the slider in the UI
		uitext = BUFFOPTIONS_CONFIG_SIZE_TEXT;							--The text to show above the slider in the UI
		uistep = 0.05;																			--The increment to increase the slider in the UI
		uitexton = 1;																				--Whether to show the exact value of the slider in the UI or not
		uisuffix = BUFFOPTIONS_CONFIG_SIZE_SUFFIX;					--The suffix to place after the slider value
		uimul = 100;																				--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"size", "sz"};														--The sub slash command and any aliases for this option
	} );
	
	--Register a seperator
	MCom.registerSmart( {
		uivar = "BuffOptionsVerticalSep";										--The option name for the UI
		uitype = "SEPARATOR";																--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_VERTICAL_HEADER;				--The label to use for the seperator in the UI
		uidesc = BUFFOPTIONS_CONFIG_VERTICAL_HEADER_INFO;		--The description to use for the seperator in the UI
		uidiff = 1;
	} );
	--Register a checkbox, and a boolean sub slash command for Vertical
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsVertical";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_VERTICAL;							--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_VERTICAL_INFO;					--The description to use for the checkbox in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		varbool = "BuffOptions_Config.Vertical";						--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.UpdateText();
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.Vertical;							--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"vertical", "vert"};											--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for SideTime
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsSideTime";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_SIDETIME;							--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_SIDETIME_INFO;					--The description to use for the checkbox in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsVertical"] = { checked = true } };
		varbool = "BuffOptions_Config.SideTime";						--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.SideTime;							--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"sidetime", "st"};												--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for Text
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsText";													--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_TEXT;									--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_TEXT_INFO;							--The description to use for the checkbox in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsVertical"] = { checked = true } };
		varbool = "BuffOptions_Config.Text";								--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.UpdateText();
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.Text;									--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"text", "tx"};														--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for DebuffType
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsDebuffType";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_DEBUFFTYPE;						--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_DEBUFFTYPE_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		uidep = {	["BuffOptionsVertical"] = { checked = true };
							["BuffOptionsText"] = { checked = true }; };
		varbool = "BuffOptions_Config.DebuffType";					--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.UpdateText();
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.DebuffType;						--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"debufftype", "dbt"};											--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for NoRight
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsNoRight";												--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_NORIGHT;								--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_NORIGHT_INFO;						--The description to use for the checkbox in the UI
		uidiff = 3;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsVertical"] = { checked = true } };
		varbool = "BuffOptions_Config.NoRight";							--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.NoRight;								--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"noright", "nr"};													--The sub slash command and any aliases for this option
	} );
	
	--Register a seperator
	MCom.registerSmart( {
		uivar = "BuffOptionsTextSep";												--The option name for the UI
		uitype = "SEPARATOR";																--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_TEXT_HEADER;						--The label to use for the seperator in the UI
		uidesc = BUFFOPTIONS_CONFIG_TEXT_HEADER_INFO;				--The description to use for the seperator in the UI
		uidiff = 1;
	} );
	--Register a checkbox, and a boolean sub slash command for LongTime
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsLongTime";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_LONGTIME;						--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_LONGTIME_INFO;				--The description to use for the checkbox in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsVertical"] = { checked = true };
							["BuffOptionsShortTime"] = { checked = false }; };
		varbool = "BuffOptions_Config.LongTime";					--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.UpdateText();
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.LongTime;						--The default value for the checkbox in the UI
		supercom = "/buffoptions";												--The main(super) slash command associated with this subommand
		subcom = {"longtime", "lt"};											--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for ShortTime
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "BuffOptionsShortTime";										--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_SHORTTIME;						--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_SHORTTIME_INFO;				--The description to use for the checkbox in the UI
		uidiff = 1;																				--The option's difficulty in Khaos
		varbool = "BuffOptions_Config.ShortTime";					--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();			--A command to perform when the option is succesfully updated
													BuffOptions.UpdateText();
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.ShortTime;						--The default value for the checkbox in the UI
		supercom = "/buffoptions";												--The main(super) slash command associated with this subommand
		subcom = {"shorttime", "st"};											--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for FadeTime
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "BuffOptionsFadeTime";										--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_FADETIME;						--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_FADETIME_INFO;				--The description to use for the checkbox in the UI
		uidiff = 1;																				--The option's difficulty in Khaos
		varbool = "BuffOptions_Config.FadeTime";					--The boolean variable associate with this option
		update = BuffOptions.SaveConfig;									--A command to perform when the option is succesfully updated
		uicheck = BuffOptions_Config.FadeTime;						--The default value for the checkbox in the UI
		supercom = "/buffoptions";												--The main(super) slash command associated with this subommand
		subcom = {"fadetime", "ft"};											--The sub slash command and any aliases for this option
	} );
	--Register a color sub slash command for TextColor
	MCom.registerSmart( {
		uivar = "BuffOptionsTextColor";											--The option name for the UI
		uitype = K_COLORPICKER;															--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_TEXTCOLOR;							--The label to use for the option in the UI
		uidesc = BUFFOPTIONS_CONFIG_TEXTCOLOR_INFO;					--The description to use for the option in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		varcolor = "BuffOptions_Config.TextColor";					--The color variable associated with this option
		update = BuffOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicolor = BuffOptions_Config.TextColor;							--The default value for the color in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"textcolor", "tc"};												--The sub slash command and any aliases for this option
	} );
	--Register a color sub slash command for TextShortColor
	MCom.registerSmart( {
		uivar = "BuffOptionsTextShortColor";								--The option name for the UI
		uitype = K_COLORPICKER;															--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR;				--The label to use for the option in the UI
		uidesc = BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR_INFO;		--The description to use for the option in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		varcolor = "BuffOptions_Config.TextShortColor";			--The color variable associated with this option
		update = BuffOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicolor = BuffOptions_Config.TextShortColor;				--The default value for the color in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"textshortcolor", "tsc"};									--The sub slash command and any aliases for this option
	} );
	--Register a slider, and a number sub slash command for TextSize
	MCom.registerSmart( {
		uivar = "BuffOptionsTextSize";											--The option name for the UI
		uitype = K_SLIDER;																	--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_TEXTSIZE;							--The label to use for the option in the UI
		uidesc = BUFFOPTIONS_CONFIG_TEXTSIZE_INFO;					--The description to use for the option in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		varnum = "BuffOptions_Config.TextSize";							--The number variable associate with this option
		update = function ()	BuffOptions.UpdateTextSize();	--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uislider = BuffOptions_Config.TextSize;							--The default value for the slider in the UI
		uimin = 0.5;																				--The minimum value for the slider in the UI
		uimax = 1.5;																				--The maximum value for the slider in the UI
		uitext = BUFFOPTIONS_CONFIG_TEXTSIZE_TEXT;					--The text to show above the slider in the UI
		uistep = 0.05;																			--The increment to increase the slider in the UI
		uitexton = 1;																				--Whether to show the exact value of the slider in the UI or not
		uisuffix = BUFFOPTIONS_CONFIG_SIZE_SUFFIX;					--The suffix to place after the slider value
		uimul = 100;																				--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"textsize", "ts"};												--The sub slash command and any aliases for this option
	} );

	--Register a seperator
	MCom.registerSmart( {
		uivar = "BuffOptionsReminderSep";										--The option name for the UI
		uitype = "SEPARATOR";																--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_REMINDER_HEADER;				--The label to use for the seperator in the UI
		uidesc = BUFFOPTIONS_CONFIG_REMINDER_HEADER_INFO;		--The description to use for the seperator in the UI
		uidiff = 1;
	} );
	--Register a slider, and a number sub slash command for Reminder
	MCom.registerSmart( {
		hasbool = true;
		uivar = "BuffOptionsReminder";											--The option name for the UI
		uitype = K_SLIDER;																	--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_REMINDER;							--The label to use for the option in the UI
		uidesc = BUFFOPTIONS_CONFIG_REMINDER_INFO;					--The description to use for the option in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		varbool = "BuffOptions_Config.Reminder";						--The number variable associate with this option
		varnum = "BuffOptions_Config.ReminderTime";					--The number variable associate with this option
		update = BuffOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = BuffOptions_Config.Reminder;							--The default value for the checkbox in the UI
		uislider = BuffOptions_Config.ReminderTime;					--The default value for the slider in the UI
		uimin = 0;																					--The minimum value for the slider in the UI
		uimax = 300;																				--The maximum value for the slider in the UI
		uitext = BUFFOPTIONS_CONFIG_REMINDER_TEXT;					--The text to show above the slider in the UI
		uistep = 10;																				--The increment to increase the slider in the UI
		uitexton = 1;																				--Whether to show the exact value of the slider in the UI or not
		uisuffix = BUFFOPTIONS_CONFIG_REMINDER_SUFFIX;			--The suffix to place after the slider value
		uimul = 1;																					--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"reminder", "rem"};												--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for ReminderSound
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsReminderSound";									--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_REMINDERSOUND;					--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_REMINDERSOUND_INFO;			--The description to use for the checkbox in the UI
		uidiff = 1;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsReminder"] = { checked = true } };
		varbool = "BuffOptions_Config.ReminderSound";				--The boolean variable associate with this option
		update = BuffOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = BuffOptions_Config.ReminderSound;					--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"remindersound", "rsound", "rs"};					--The sub slash command and any aliases for this option
	} );
	--Register a color sub slash command for ReminderColor
	MCom.registerSmart( {
		uivar = "BuffOptionsReminderColor";									--The option name for the UI
		uitype = K_COLORPICKER;															--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_REMINDERCOLOR;					--The label to use for the option in the UI
		uidesc = BUFFOPTIONS_CONFIG_REMINDERCOLOR_INFO;			--The description to use for the option in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsReminder"] = { checked = true } };
		varcolor = "BuffOptions_Config.ReminderColor";			--The color variable associated with this option
		update = function ()	ChangeActionBarPage();				--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uicolor = BuffOptions_Config.ReminderColor;					--The default value for the color in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"remindercolor", "rc"};										--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for ReminderOSD
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsReminderOSD";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_REMINDEROSD;						--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_REMINDEROSD_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsReminder"] = { checked = true } };
		varbool = "BuffOptions_Config.ReminderOSD";					--The boolean variable associate with this option
		update = BuffOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = BuffOptions_Config.ReminderOSD;						--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"reminderosd", "rosd", "ro"};							--The sub slash command and any aliases for this option
	} );
	--Register a checkbox, and a boolean sub slash command for EquipmentOnly
	MCom.registerSmart( {
		hasbool = true;																			--True if the option has a boolean portion
		uivar = "BuffOptionsEquipmentOnly";									--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_EQUIPMENTONLY;					--The label to use for the checkbox in the UI
		uidesc = BUFFOPTIONS_CONFIG_EQUIPMENTONLY_INFO;			--The description to use for the checkbox in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsReminder"] = { checked = true } };
		varbool = "BuffOptions_Config.EquipmentOnly";				--The boolean variable associate with this option
		update = function ()	BuffOptions.ReOrient();				--A command to perform when the option is succesfully updated
													BuffOptions.SaveConfig(); end;
		uicheck = BuffOptions_Config.EquipmentOnly;					--The default value for the checkbox in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"equipmentonly", "eo"};										--The sub slash command and any aliases for this option
	} );
	--Register a slider, and a number sub slash command for NoShort
	MCom.registerSmart( {
		hasbool = true;
		uivar = "BuffOptionsNoShort";												--The option name for the UI
		uitype = K_SLIDER;																	--The option type for the UI
		uilabel = BUFFOPTIONS_CONFIG_NOSHORT;								--The label to use for the option in the UI
		uidesc = BUFFOPTIONS_CONFIG_NOSHORT_INFO;						--The description to use for the option in the UI
		uidiff = 2;																					--The option's difficulty in Khaos
		uidep = { ["BuffOptionsReminder"] = { checked = true } };
		varbool = "BuffOptions_Config.NoShort";							--The number variable associate with this option
		varnum = "BuffOptions_Config.ShortBuffTime";				--The number variable associate with this option
		update = BuffOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = BuffOptions_Config.NoShort;								--The default value for the checkbox in the UI
		uislider = BuffOptions_Config.ShortBuffTime;						--The default value for the slider in the UI
		uimin = 1;																					--The minimum value for the slider in the UI
		uimax = 120;																				--The maximum value for the slider in the UI
		uitext = BUFFOPTIONS_CONFIG_NOSHORT_TEXT;						--The text to show above the slider in the UI
		uistep = 1;																					--The increment to increase the slider in the UI
		uitexton = 1;																				--Whether to show the exact value of the slider in the UI or not
		uisuffix = BUFFOPTIONS_CONFIG_NOSHORT_SUFFIX;				--The suffix to place after the slider value
		uimul = 1;																					--What to multiply the actual value of the slider by when showing the value in the UI
		supercom = "/buffoptions";													--The main(super) slash command associated with this subommand
		subcom = {"noshort", "ns"};													--The sub slash command and any aliases for this option
	} );
end