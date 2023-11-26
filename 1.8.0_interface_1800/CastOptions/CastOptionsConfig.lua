--[[
	CastOptionsConfig
	 	Configuration options for CastOptions
	
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
CastOptions.Register = function ()
	--Smart register all the options
	--Register a seperator, specifying section, and main super slash command
	MCom.registerSmart( {
		uifolder = "combat";															--The folder to use in Khaos
		uisec = "CastOptions";														--The section/set to use in the UI
		uiseclabel = CASTOPTIONS_CONFIG_SECTION;					--The section/set label
		uisecdesc = CASTOPTIONS_CONFIG_SECTION_INFO;			--The section/set description
		uisecdiff = 1;																		--The section/set difficulty
		uivar = "CastOptionsSeparator";										--The option name for the UI
		uitype = K_HEADER;																--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_MAIN_HEADER;					--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_MAIN_HEADER_INFO;			--The description to use for the seperator in the UI
		uiver = CastOptions.VERSION;											--The version number to display in the UI
		uiframe = "CastOptionsFrame";											--The frame to identify this addon by
		supercom = {"/castoptions", "/co"};								--The main slash command, and any aliases for it
		comaction = "before";															--See Sky for info on this
		comsticky = false;																--See Sky for info on this
		comhelp = CASTOPTIONS_CHAT_COMMAND_INFO;					--The help text to show for the slash command
		name = CASTOPTIONS_CONFIG_SECTION;								--The name of the addon, for display in the info text
		infotext = CASTOPTIONS_CONFIG_INFOTEXT;						--The text to show when the help function is called
		uiauthor = "Mugendai";
		uiwww = "http://www.curse-gaming.com/mod.php?addid=1487";
		uimail = "mugekun@gmail.com";
	} );
	--Register a checkbox, and a boolean sub slash command for Enabled
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsEnabled";												--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_ENABLED;								--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_ENABLED_INFO;						--The description to use for the checkbox in the UI
		uidiff = 1;																					--The difficulty of the option
		varbool = "CastOptions_Config.Enabled";							--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_ENABLED;								--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.Enabled;								--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"enable"};																--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_ENABLED_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for SmartEquip
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsSmartEquip";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMARTEQUIP;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SMARTEQUIP_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.SmartEquip";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SMARTEQUIP;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.SmartEquip;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"smartequip", "se"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SMARTEQUIP_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for CancelWand
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsCancelWand";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_CANCELWAND;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_CANCELWAND_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.CancelWand";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_CANCELWAND;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.CancelWand;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"cancelwand", "cw"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_CANCELWAND_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for CancelShot
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsCancelShot";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_CANCELSHOT;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_CANCELSHOT_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.CancelShot";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_CANCELSHOT;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.CancelShot;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"cancelautoshot", "cas"};									--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_CANCELSHOT_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for ShowCancelShot
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsShowCancelShot";								--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SHOWCANCELSHOT;				--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO;		--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.ShowCancelShot";			--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SHOWCANCELSHOT;					--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.ShowCancelShot;				--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"showcancelshot", "scs"};									--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO;		--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for NoDispel
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsNoDispel";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_NODISPEL;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_NODISPEL_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.NoDispel";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_NODISPEL;								--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.NoDispel;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"nodispel", "nd"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_NODISPEL_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for ManaControl
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsManaControl";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_MANACONTROL;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_MANACONTROL_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.ManaControl";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_MANACONTROL;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.ManaControl;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"manacontrol", "mc"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_MANACONTROL_INFO;			--The help text for the sub slash command
	} );
	--Register a button, and a simple slash command to toggle self cast
	MCom.registerSmart( {
		uivar = "CastOptionsToggle";										--The option name for the UI
		uitype = "BUTTON";															--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_TOGGLESELF;				--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_TOGGLESELF_INFO;		--The description to use for the checkbox in the UI
		uidiff = 3;																			--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		func = CastOptions.ToggleSelf;									--The function to call
		uitext = CASTOPTIONS_CONFIG_TOGGLESELF_TEXT;		--The text to show on the button
		supercom = "/castoptions";											--The main(super) slash command associated with this subommand
		subcom = {"toggleself", "ts"};									--The sub slash command and any aliases
		subhelp = CASTOPTIONS_CONFIG_TOGGLESELF_INFO;		--The help text for the sub slash command
	} );
	--Register a seperator
	MCom.registerSmart( {
		uivar = "CastOptionsRankSep";											--The option name for the UI
		uitype = "SEPARATOR";															--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_RANK_HEADER;					--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_RANK_HEADER_INFO;			--The description to use for the seperator in the UI
		uidiff = 2;
	} );
	--Register a checkbox, and a boolean sub slash command for SmartRank
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsSmartRank";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMARTRANK;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SMARTRANK_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.SmartRank";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SMARTRANK;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.SmartRank;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"smartrank", "sr"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SMARTRANK_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for SmartHeal
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsSmartHeal";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMARTHEAL;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SMARTHEAL_INFO;					--The description to use for the checkbox in the UI
		uidiff = 3;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartRank"] = { checked = true }; };
		varbool = "CastOptions_Config.SmartHeal";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SMARTHEAL;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.SmartHeal;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"smartheal", "sh"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SMARTHEAL_INFO;				--The help text for the sub slash command
	} );
	--Register a slider, and a number sub slash command for HealBoost
	MCom.registerSmart( {
		uivar = "CastOptionsHealBoost";											--The option name for the UI
		uitype = K_SLIDER;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_HEALBOOST;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_HEALBOOST_INFO;					--The description to use for the checkbox in the UI
		uidiff = 3;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartRank"] = { checked = true };
							["CastOptionsSmartHeal"] = { checked = true }; };
		varnum = "CastOptions_Config.HealBoost";						--The number variable associate with this option
		textname = CASTOPTIONS_CHAT_HEALBOOST;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uislider = CastOptions_Config.HealBoost;						--The default value for the checkbox in the UI
		uimin = 0;
		uimax = 1;
		uitext = CASTOPTIONS_CONFIG_HEALBOOST;
		uistep = 0.01;
		uitexton = 1;
		uisuffix = CASTOPTIONS_CONFIG_HEALBOOST_SUFFIX;
		uimul = 100;
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"healboost", "hb"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_HEALBOOST_INFO;				--The help text for the sub slash command
	} );
	--Register a seperator
	MCom.registerSmart( {
		uivar = "CastOptionsKeysSep";											--The option name for the UI
		uitype = "SEPARATOR";															--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_KEYS_HEADER;					--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_KEYS_HEADER_INFO;			--The description to use for the seperator in the UI
		uidiff = 1;
	} );
	--Register a checkbox, and a boolean sub slash command for Alt
	MCom.registerSmart( {
		hasbool = true;																	--Whether this options has a boolean part
		uivar = "CastOptionsAlt";												--The option name for the UI
		uitype = K_TEXT;																--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_ALT;								--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_ALT_INFO;						--The description to use for the checkbox in the UI
		uidiff = 1;																			--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.Alt";							--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_ALT;								--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.Alt;								--The default value for the checkbox in the UI
		supercom = "/castoptions";											--The main(super) slash command associated with this subommand
		subcom = {"alt"};																--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_ALT_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for Shift
	MCom.registerSmart( {
		hasbool = true;																		--Whether this options has a boolean part
		uivar = "CastOptionsShift";												--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SHIFT;								--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SHIFT_INFO;						--The description to use for the checkbox in the UI
		uidiff = 1;																				--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.Shift";							--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SHIFT;								--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.Shift;								--The default value for the checkbox in the UI
		supercom = "/castoptions";												--The main(super) slash command associated with this subommand
		subcom = {"shift"};																--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SHIFT_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for Ctrl
	MCom.registerSmart( {
		hasbool = true;																		--Whether this options has a boolean part
		uivar = "CastOptionsCtrl";												--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_CTRL;								--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_CTRL_INFO;						--The description to use for the checkbox in the UI
		uidiff = 1;																				--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.Ctrl";							--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_CTRL;									--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.Ctrl;								--The default value for the checkbox in the UI
		supercom = "/castoptions";												--The main(super) slash command associated with this subommand
		subcom = {"control", "ctrl"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_CTRL_INFO;						--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for RightSelf
	MCom.registerSmart( {
		hasbool = true;																		--Whether this options has a boolean part
		uivar = "CastOptionsRightSelf";										--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_RIGHTSELF;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_RIGHTSELF_INFO;				--The description to use for the checkbox in the UI
		uidiff = 1;																				--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.RightSelf";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_RIGHTSELF;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.RightSelf;						--The default value for the checkbox in the UI
		supercom = "/castoptions";												--The main(super) slash command associated with this subommand
		subcom = {"rightself", "right", "rs"};						--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_RIGHTSELF_INFO;			--The help text for the sub slash command
	} );
	--Register a seperator
	MCom.registerSmart( {
		uivar = "CastOptionsAimedKeysSep";									--The option name for the UI
		uitype = "SEPARATOR";																--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER;			--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER_INFO;	--The description to use for the seperator in the UI
		uidiff = 2;
	} );
	--Register a checkbox, and a boolean sub slash command for AimedCast
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsAimedCast";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_AIMEDCAST;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_AIMEDCAST_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.AimedCast";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_AIMEDCAST;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.AimedCast;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"aimedcast", "ac"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_AIMEDCAST_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for AimedWorld
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsAimedWorld";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_AIMEDWORLD;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_AIMEDWORLD_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true }; };
		varbool = "CastOptions_Config.AimedWorld";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_AIMEDWORLD;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.AimedWorld;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"aimedworld", "aw"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_AIMEDWORLD_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for AimedHostile
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsAimedHostile";									--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_AIMEDHOSTILE;					--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_AIMEDHOSTILE_INFO;			--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true }; };
		varbool = "CastOptions_Config.AimedHostile";				--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_AIMEDHOSTILE;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.AimedHostile;					--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"aimedhostile", "ah"};										--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_AIMEDHOSTILE_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for AimedAlt
	MCom.registerSmart( {
		hasbool = true;																		--Whether this options has a boolean part
		uivar = "CastOptionsAimedAlt";										--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_AIMEDALT;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_AIMEDALT_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																				--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.AimedAlt";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_AIMEDALT;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.AimedAlt;						--The default value for the checkbox in the UI
		supercom = "/castoptions";												--The main(super) slash command associated with this subommand
		subcom = {"aimedalt", "aalt"};										--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_AIMEDALT_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for AimedShift
	MCom.registerSmart( {
		hasbool = true;																		--Whether this options has a boolean part
		uivar = "CastOptionsAimedShift";									--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_AIMEDSHIFT;					--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_AIMEDSHIFT_INFO;			--The description to use for the checkbox in the UI
		uidiff = 2;																				--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.AimedShift";				--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_AIMEDSHIFT;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.AimedShift;					--The default value for the checkbox in the UI
		supercom = "/castoptions";												--The main(super) slash command associated with this subommand
		subcom = {"aimedshift", "ashift"};								--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_AIMEDSHIFT_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for AimedCtrl
	MCom.registerSmart( {
		hasbool = true;																		--Whether this options has a boolean part
		uivar = "CastOptionsAimedCtrl";										--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_AIMEDCTRL;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_AIMEDCTRL_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																				--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.AimedCtrl";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_AIMEDCTRL;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.AimedCtrl;						--The default value for the checkbox in the UI
		supercom = "/castoptions";												--The main(super) slash command associated with this subommand
		subcom = {"aimedcontrol", "aimedctrl", "actrl"};	--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_AIMEDCTRL_INFO;			--The help text for the sub slash command
	} );
	--Register a seperator
	MCom.registerSmart( {
		uivar = "CastOptionsSmartSep";											--The option name for the UI
		uitype = "SEPARATOR";																--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMART_HEADER;					--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_SMART_HEADER_INFO;			--The description to use for the seperator in the UI
		uidiff = 1;
	} );
	--Register a checkbox, and a boolean sub slash command for Smart
	MCom.registerSmart( {
		hasbool = true;																		--Whether this options has a boolean part
		uivar = "CastOptionsSmart";												--The option name for the UI
		uitype = K_TEXT;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMART;								--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SMART_INFO;						--The description to use for the checkbox in the UI
		uidiff = 1;																				--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.Smart";							--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SMART;								--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.Smart;								--The default value for the checkbox in the UI
		supercom = "/castoptions";												--The main(super) slash command associated with this subommand
		subcom = {"smartcast", "smart", "sc"};						--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SMART_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for NoGroup
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsNoGroup";												--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_NOGROUP;								--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_NOGROUP_INFO;						--The description to use for the checkbox in the UI
		uidiff = 1;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmart"] = { checked = true }; };
		
		varbool = "CastOptions_Config.NoGroup";							--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_NOGROUP;								--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.NoGroup;								--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"nogroup", "ng"};													--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_NOGROUP_INFO;					--The help text for the sub slash command
	} );
	--Register a seperator
	MCom.registerSmart( {
		uivar = "CastOptionsSmartAssistSep";								--The option name for the UI
		uitype = "SEPARATOR";																--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMARTASSIST_HEADER;		--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_SMARTASSIST_HEADER_INFO;--The description to use for the seperator in the UI
		uidiff = 2;
	} );
	--Register a checkbox, and a boolean sub slash command for SmartAssist
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsSmartAssist";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMARTASSIST;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SMARTASSIST_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.SmartAssist";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SMARTASSIST;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.SmartAssist;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"smartassist", "sa"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SMARTASSIST_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for AssistTarget
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsAssistTarget";									--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_ASSISTTARGET;					--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_ASSISTTARGET_INFO;			--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartAssist"] = { checked = true }; };
		varbool = "CastOptions_Config.AssistTarget";				--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_ASSISTTARGET;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.AssistTarget;					--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"assisttarget", "at"};										--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_ASSISTTARGET_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for ChainAssist
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsChainAssist";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_CHAINASSIST;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_CHAINASSIST_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartAssist"] = { checked = true }; };
		varbool = "CastOptions_Config.ChainAssist";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_CHAINASSIST;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.ChainAssist;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"chainassist", "ca"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_CHAINASSIST_INFO;			--The help text for the sub slash command
	} );
	--Register a seperator
	MCom.registerSmart( {
		uivar = "CastOptionsSmartGroupSep";									--The option name for the UI
		uitype = "SEPARATOR";																--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMARTGROUP_HEADER;			--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_SMARTGROUP_HEADER_INFO;	--The description to use for the seperator in the UI
		uidiff = 2;
	} );
	--Register a checkbox, and a boolean sub slash command for SmartGroup
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsSmartGroup";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_SMARTGROUP;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_SMARTGROUP_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.SmartGroup";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_SMARTGROUP;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.SmartGroup;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"smartgroup", "sg"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_SMARTGROUP_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupPets
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupPets";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPPETS;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPPETS_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupPets";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPPETS;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupPets;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"grouppets", "gp"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPPETS_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupTarget
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupTarget";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPTARGET;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPTARGET_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupTarget";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPTARGET;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupTarget;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"grouptarget", "gt"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPTARGET_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupGroup
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupGroup";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPGROUP;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPGROUP_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupGroup";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPGROUP;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupGroup;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"groupcast", "gc"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPGROUP_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupSelf
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupSelf";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPSELF;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPSELF_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupSelf";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPSELF;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupSelf;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"groupself", "gs"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPSELF_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupHeal
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupHeal";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPHEAL;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPHEAL_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupHeal";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPHEAL;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupHeal;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"groupheal", "gh"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPHEAL_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupMana
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupMana";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPMANA;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPMANA_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupMana";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPMANA;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupMana;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"groupmana", "gm"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPMANA_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupCure
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupCure";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPCURE;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPCURE_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupCure";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPCURE;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupCure;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"groupcure", "gcu"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPCURE_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupBuff
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupBuff";											--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPBUFF;							--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPBUFF_INFO;					--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupBuff";						--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPBUFF;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupBuff;							--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"groupbuff", "gb"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPBUFF_INFO;				--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for GroupBlessing
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsGroupBlessing";									--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_GROUPBLESSING;					--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_GROUPBLESSING_INFO;			--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true };
							["CastOptionsGroupBuff"] = { checked = true }; };
		varbool = "CastOptions_Config.GroupBlessing";				--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_GROUPBLESSING;					--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.GroupBlessing;					--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"groupblessing", "gbl"};									--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_GROUPBLESSING_INFO;		--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for CancelSpell
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsCancelSpell";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_CANCELSPELL;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_CANCELSPELL_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varbool = "CastOptions_Config.CancelSpell";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_CANCELSPELL;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.CancelSpell;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"cancelspell", "cs"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_CANCELSPELL_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox and slider, and a boolean and number sub slash command for RecastTime
	MCom.registerSmart( {
		uivar = "CastOptionsRecastTime";										--The option name for the UI
		uitype = K_SLIDER;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_RECASTTIME;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_RECASTTIME_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsSmartGroup"] = { checked = true }; };
		varnum = "CastOptions_Config.RecastTime";						--The number variable associate with this option
		textname = CASTOPTIONS_CHAT_RECASTTIME;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uislider = CastOptions_Config.RecastTime;						--The default value for the checkbox in the UI
		uimin = 0;
		uimax = CastOptions.MAX_RECAST;
		uitext = CASTOPTIONS_CONFIG_RECASTTIME;
		uistep = 1;
		uitexton = 1;
		uisuffix = CASTOPTIONS_CONFIG_RECASTTIME_SUFFIX;
		uimul = 1;
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"recasttime", "rct"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_RECASTTIME_INFO;				--The help text for the sub slash command
	} );
	--Register a seperator
	MCom.registerSmart( {
		uivar = "CastOptionsBoundSep";										--The option name for the UI
		uitype = "SEPARATOR";															--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_BOUND_HEADER;				--The label to use for the seperator in the UI
		uidesc = CASTOPTIONS_CONFIG_BOUND_HEADER_INFO;		--The description to use for the seperator in the UI
		uidiff = 2;
	} );
	--Register a checkbox, and a boolean sub slash command for NoBoundCast
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsNoBoundCast";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_NOBOUNDCAST;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_NOBOUNDCAST_INFO;				--The description to use for the checkbox in the UI
		uidiff = 2;																					--The difficulty of the option
		uidep = { ["CastOptionsEnabled"] = { checked = true } };
		varbool = "CastOptions_Config.NoBoundCast";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_NOBOUNDCAST;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.NoBoundCast;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"noboundcast", "nbc"};										--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_NOBOUNDCAST_INFO;					--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for BoundPotential
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsBoundPotential";								--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_BOUNDPOTENTIAL;				--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_BOUNDPOTENTIAL_INFO;		--The description to use for the checkbox in the UI
		uidiff = 3;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsNoBoundCast"] = { checked = true }; };
		varbool = "CastOptions_Config.BoundPotential";			--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_BOUNDPOTENTIAL;					--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.BoundPotential;				--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"noboundpotential", "nbp"};								--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_BOUNDPOTENTIAL_INFO;		--The help text for the sub slash command
	} );
	--Register a checkbox, and a boolean sub slash command for BoundAttack
	MCom.registerSmart( {
		hasbool = true;																			--Whether this options has a boolean part
		uivar = "CastOptionsBoundAttack";										--The option name for the UI
		uitype = K_TEXT;																		--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_BOUNDATTACK;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_BOUNDATTACK_INFO;				--The description to use for the checkbox in the UI
		uidiff = 3;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsNoBoundCast"] = { checked = true }; };
		varbool = "CastOptions_Config.BoundAttack";					--The boolean variable associate with this option
		textname = CASTOPTIONS_CHAT_BOUNDATTACK;						--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uicheck = CastOptions_Config.BoundAttack;						--The default value for the checkbox in the UI
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"noboundattack", "nba"};									--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_BOUNDATTACK_INFO;			--The help text for the sub slash command
	} );
	--Register a checkbox and slider, and a boolean and number sub slash command for BoundDelay
	MCom.registerSmart( {
		uivar = "CastOptionsBoundDelay";										--The option name for the UI
		uitype = K_SLIDER;																	--The option type for the UI
		uilabel = CASTOPTIONS_CONFIG_BOUNDDELAY;						--The label to use for the checkbox in the UI
		uidesc = CASTOPTIONS_CONFIG_BOUNDDELAY_INFO;				--The description to use for the checkbox in the UI
		uidiff = 3;																					--The difficulty of the option
		uidep = {	["CastOptionsEnabled"] = { checked = true };
							["CastOptionsNoBoundCast"] = { checked = true }; };
		varnum = "CastOptions_Config.BoundDelay";						--The number variable associate with this option
		textname = CASTOPTIONS_CHAT_BOUNDDELAY;							--What to say when the command is successfully updated, and there is no GUI
		update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
		uislider = CastOptions_Config.BoundDelay;						--The default value for the checkbox in the UI
		uimin = 0;
		uimax = CastOptions.MAX_BOUNDDELAY;
		uitext = CASTOPTIONS_CONFIG_BOUNDDELAY;
		uistep = 0.1;
		uitexton = 1;
		uisuffix = CASTOPTIONS_CONFIG_BOUNDDELAY_SUFFIX;
		uimul = 1;
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"bounddelay", "bd"};											--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CONFIG_BOUNDDELAY_INFO;				--The help text for the sub slash command
	} );
	--Register a boolean sub slash command for Texture feedback
	MCom.registerSmart( {
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"texture", "tex"};												--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CHAT_TEXTURE_INFO;					--The help text for the sub slash command
		comtype = MCOM_BOOLT;
		varbool = "CastOptions.Texture";
		textname = CASTOPTIONS_CHAT_TEXTURE;
		textshow = true;
	} );
	--Register a boolean sub slash command for ItemLink feedback
	MCom.registerSmart( {
		supercom = "/castoptions";													--The main(super) slash command associated with this subommand
		subcom = {"link"};																	--The sub slash command and any aliases for this option
		subhelp = CASTOPTIONS_CHAT_LINK_INFO;							--The help text for the sub slash command
		comtype = MCOM_BOOLT;
		varbool = "CastOptions.PrintLink";
		textname = CASTOPTIONS_CHAT_LINK;
		textshow = true;
	} );
end