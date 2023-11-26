-- Version : German (by DrVanGogh, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then
	
	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Configuration Strings
	-- <= == == == == == == == == == == == == =>
	TACKLEBOX_CONFIG_SECTION                = "Fischers Box";
	TACKLEBOX_CONFIG_SECTION_INFO           = "Mit diesen Einstellungen wird das Fischen intuitiver indem h\195\164ufig benutzten Aktionen Tastaturk\195\188rzel zugewiesen werden.";
	TACKLEBOX_CONFIG_EASYCAST_ONOFF         = "Einfaches Werfen (EasyCast)";
	TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO    = "Wenn aktiviert und man eine Angel in der Hand h\195\164lt, reicht ein Rechtsklick um die Leine automatisch auszuwerfen.";
	TACKLEBOX_CONFIG_FASTCAST_ONOFF         = "Schnelles Werfen (FastCast)";
	TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO    = "Wenn aktiviert, wir die Leine unverz\195\188glich wieder ausgeworfen sobald man auf den Schwimmer klickt.";
	TACKLEBOX_CONFIG_SWITCH_ONOFF           = "Einfaches Ausr\195\188stungs Makro";
	TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO      = "F\195\188gt den Makros ein 'Fischers Box' Makro hinzu, mit dem die Ausr\195\188stung einfach ausgetauscht werden kann.";
    
	-- <= == == == == == == == == == == == == =>
	-- => Chat Command Strings
	-- <= == == == == == == == == == == == == =>
	TACKLEBOX_CHAT_COMMAND_INFO		= "Gib /tb oder /tacklebox ein um eine Hilfe anzuzeigen.";
	TACKLEBOX_CHAT_COMMAND_HELP		= {};
	TACKLEBOX_CHAT_COMMAND_HELP[1]		= "/tacklebox oder /tb <Parameter>, dann on/off";
	TACKLEBOX_CHAT_COMMAND_HELP[2]		= "easycast - "..TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO;
	TACKLEBOX_CHAT_COMMAND_HELP[3]		= "fastcast - "..TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO;
	TACKLEBOX_CHAT_COMMAND_HELP[4]		= "switch - Vereinfacht das austauschen der Ausr\195\188stung von der Angel und umgekehrt.";
	TACKLEBOX_CHAT_COMMAND_HELP[5]		= "Beispiel: /tb easycast on";
    
    
	-- <= == == == == == == == == == == == == =>
	-- => Output Strings
	-- <= == == == == == == == == == == == == =>
	TACKLEBOX_OUTPUT_SET_POLE		= "Angel auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_MAIN		= "Waffenhand auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_SECONDARY		= "Schildhand auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_FISHING_HAT	= "Angelhut auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_HAT		= "Normaler Hut auf %s eingestellt.";
	TACKLEBOX_OUTPUT_NEED_SET_POLE		= "Bitte die Angel, die benutzt werden soll, in die Hand nehmen und nochmal versuchen.";
	TACKLEBOX_OUTPUT_NEED_SET_HAND		= "Bitte die Waffe, die benutzt werden soll, in die Hand nehmen und nochmal versuchen.";
	TACKLEBOX_OUTPUT_ENABLED		= "%s aktiviert";
	TACKLEBOX_OUTPUT_DISABLED		= "%s deaktiviet";
	TACKLEBOX_OUTPUT_EASYCAST		= "Einfaches Werfen";
	TACKLEBOX_OUTPUT_FASTCAST		= "Schnelles Werfen";   
    
	-- <= == == == == == == == == == == == == =>
	-- => Other Strings
	-- <= == == == == == == == == == == == == =>
	TACKLEBOX_MACRO_NAME			= "Fischers Box";
	TACKLEBOX_BOBBER_NAME			= "Blinker";
	TACKLEBOX_SKILL_FISHING_NAME		= "Angeln";

	-- <= == == == == == == == == == == == == =>
	-- => Bindings
	-- <= == == == == == == == == == == == == =>
	BINDING_HEADER_TACKLEBOXHEADER		= "Fischers Box";
	BINDING_NAME_TACKLEBOX_THROW		= "Angeln starten";


	-- <= == == == == == == == == == == == == =>
	-- => Skill names
	-- <= == == == == == == == == == == == == =>
	TACKLEBOX_SKILL_FISHING_NAME		= "Angeln";

	-- <= == == == == == == == == == == == == =>
	-- => Item names
	-- <= == == == == == == == == == == == == =>
	TACKLEBOX_ITEM_FISHING_NAME		= "Angel";
	TACKLEBOX_ITEM_FISHING_POLE_NAME	= "Angel";
	TACKLEBOX_ITEM_FISHING_ROD_NAME		= "Angel";

end