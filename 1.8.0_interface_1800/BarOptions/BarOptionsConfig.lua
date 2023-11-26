--[[
	BarOptionsConfig
	 	Configuration options for BarOptions
	
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
BarOptions.Register = function ()
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
		uiauthor = "Mugendai";
		uiwww = "http://www.curse-gaming.com/mod.php?addid=1486";
		uimail = "mugekun@gmail.com";
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
		uidep = { ["BarOptionsStanceBar"] = { checked = true } };
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
		uidep = { ["BarOptionsStanceBar"] = { checked = true } };
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
		uidep = { ["BarOptionsStanceBar"] = { checked = true } };
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
		uidep = { ["BarOptionsStanceBar"] = { checked = true } };
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
		uidep = { ["BarOptionsStanceBar"] = { checked = true } };
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
end