--[[
	TackleBoxConfig
	 	Configuration options for TackleBox
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	This registers all of the configurations options with MCom to allow the user to
	modify the config options, either by slash commands, or a user interface.
	
	$Id$
	$Rev$
	$LastChangedBy$
	$Date$
]]--

--------------------------------------------------
--
-- Configuration Registration
--
--------------------------------------------------
TackleBox.Register = function ()
	--Register a header
	MCom.registerSmart( {
		uifolder = "other";																--The Khaos folder to put the option in
		uisec = "TackleBox";															--The section for the UI
		uiseclabel = TACKLEBOX_CONFIG_SECTION;						--The label for the section in the UI
		uisecdesc = TACKLEBOX_CONFIG_SECTION_INFO;				--The description for the section in the UI
		uisecdiff = 1;																		--The section's difficulty in Khaos
		uisecdef = false;																	--Whether the section should be default enabled or not in Khaos
		uivar = "TackleBoxHeader";												--The option name for the UI
		uitype = K_HEADER;																--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_SECTION;								--The label to use for the seperator in the UI
		uidesc = TACKLEBOX_CONFIG_SECTION_INFO;						--The description to use for the seperator in the UI
		uidiff = 1;																				--The option's difficulty in Khaos
		uiver = TackleBox.VERSION;												--The version number to display in the UI
		uiframe = "TackleBoxFrame";												--The frame to identify this addon by
		supercom = {"/tacklebox", "/tb"};									--The main slash command, and any aliases for it
		comaction = "before";															--See Sky for info on this
		comsticky = false;																--See Sky for info on this
		name = TACKLEBOX_CONFIG_SECTION;									--The name of the addon, for display in the info text
		infotext = TACKLEBOX_CONFIG_INFOTEXT;							--The text to show when the help function is called
		uiauthor = "Mugendai";
		uiwww = "http://www.curse-gaming.com/mod.php?addid=97";
		uimail = "mugekun@gmail.com";
	} );
	--Register a checkbox
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "TackleBoxEasyCast";											--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_EASYCAST_ONOFF;				--The label to use for the checkbox in the UI
		uidesc = TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO;		--The description to use for the checkbox in the UI
		uidiff = 1;																				--The option's difficulty in Khaos
		varbool = "TackleBox_Config.EasyCast";						--The boolean variable associate with this option
		update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
		textname = TACKLEBOX_OUTPUT_EASYCAST;							--What to say when the command is successfully updated, and there is no GUI
		uicheck = TackleBox_Config.EasyCast;							--The default value for the checkbox in the UI
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"easycast", "easy", "ec"};							--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO;		--The help text for the sub slash command
	} );
	--Register a checkbox
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "TackleBoxFastCast";											--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_FASTCAST_ONOFF;				--The label to use for the checkbox in the UI
		uidesc = TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO;		--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = { ["TackleBoxEasyCast"] = { checked = true } };
		varbool = "TackleBox_Config.FastCast";						--The boolean variable associate with this option
		update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
		textname = TACKLEBOX_OUTPUT_FASTCAST;							--What to say when the command is successfully updated, and there is no GUI
		uicheck = TackleBox_Config.FastCast;							--The default value for the checkbox in the UI
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"fastcast", "fast", "fc"};							--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO;		--The help text for the sub slash command
	} );
	--Register a checkbox
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "TackleBoxEasyLure";											--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_EASYLURE_ONOFF;				--The label to use for the checkbox in the UI
		uidesc = TACKLEBOX_CONFIG_EASYLURE_ONOFF_INFO;		--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = { ["TackleBoxEasyCast"] = { checked = true } };
		varbool = "TackleBox_Config.EasyLure";						--The boolean variable associate with this option
		update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
		textname = TACKLEBOX_OUTPUT_EASYLURE;							--What to say when the command is successfully updated, and there is no GUI
		uicheck = TackleBox_Config.EasyLure;							--The default value for the checkbox in the UI
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"easylure", "lure", "el"};							--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CONFIG_EASYLURE_ONOFF_INFO;		--The help text for the sub slash command
	} );
	--Register a checkbox
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "TackleBoxAlt";														--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_ALT_ONOFF;							--The label to use for the checkbox in the UI
		uidesc = TACKLEBOX_CONFIG_ALT_ONOFF_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = { ["TackleBoxEasyCast"] = { checked = true } };
		varbool = "TackleBox_Config.Alt";									--The boolean variable associate with this option
		update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
		textname = TACKLEBOX_OUTPUT_ALT;									--What to say when the command is successfully updated, and there is no GUI
		uicheck = TackleBox_Config.Alt;										--The default value for the checkbox in the UI
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"alt"};																	--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CONFIG_ALT_ONOFF_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "TackleBoxCtrl";													--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_CTRL_ONOFF;						--The label to use for the checkbox in the UI
		uidesc = TACKLEBOX_CONFIG_CTRL_ONOFF_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = { ["TackleBoxEasyCast"] = { checked = true } };
		varbool = "TackleBox_Config.Ctrl";								--The boolean variable associate with this option
		update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
		textname = TACKLEBOX_OUTPUT_CTRL;									--What to say when the command is successfully updated, and there is no GUI
		uicheck = TackleBox_Config.Ctrl;									--The default value for the checkbox in the UI
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"control", "ctrl"};											--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CONFIG_CTRL_ONOFF_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "TackleBoxShift";													--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_SHIFT_ONOFF;						--The label to use for the checkbox in the UI
		uidesc = TACKLEBOX_CONFIG_SHIFT_ONOFF_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																				--The option's difficulty in Khaos
		uidep = { ["TackleBoxEasyCast"] = { checked = true } };
		varbool = "TackleBox_Config.Shift";								--The boolean variable associate with this option
		update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
		textname = TACKLEBOX_OUTPUT_SHIFT;								--What to say when the command is successfully updated, and there is no GUI
		uicheck = TackleBox_Config.Shift;									--The default value for the checkbox in the UI
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"shift"};																--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CONFIG_SHIFT_ONOFF_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox
	MCom.registerSmart( {
		hasbool = true;																		--True if the option has a boolean portion
		uivar = "TackleBoxSwitch";												--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = TACKLEBOX_CONFIG_SWITCH_ONOFF;					--The label to use for the checkbox in the UI
		uidesc = TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO;			--The description to use for the checkbox in the UI
		uidiff = 1;																				--The option's difficulty in Khaos
		varbool = "TackleBox_Config.MakeMacro";						--The boolean variable associate with this option
		update = function()	TackleBox.SaveConfig();				--A command to perform when the option is succesfully updated
												TackleBox.MakeMacro(); end;
		textname = TACKLEBOX_OUTPUT_SWITCH;								--What to say when the command is successfully updated, and there is no GUI
		uicheck = TackleBox_Config.MakeMacro;							--The default value for the checkbox in the UI
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"makemacro", "macro"};									--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO;			--The help text for the sub slash command
	} );
	--Register a slash com for switching equipment
	MCom.registerSmart( {
		supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
		subcom = {"switch", "swap", "sw"};								--The sub slash command and any aliases for this option
		subhelp = TACKLEBOX_CHAT_SWITCH;									--The help text for the sub slash command
		func = TackleBox.Switch;
	} );
end;