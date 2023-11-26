--[[
--	Tackle Box Localization
--		"German Localization"
--	
--	By: DranGogh, StarDust
--	
--	$Id: localization.de.lua 2409 2005-09-09 06:39:02Z stardust $
--	$Rev: 2409 $
--	$LastChangedBy: stardust $
--	$Date: 2005-09-09 01:39:02 -0500 (Fri, 09 Sep 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- Binding Strings
	--
	--------------------------------------------------
	BINDING_HEADER_TACKLEBOXHEADER		= "Fischers Box";
	BINDING_NAME_TACKLEBOX_THROW		= "Angeln starten";
	
	--------------------------------------------------
	--
	-- Cosmos Configuration
	--
	--------------------------------------------------
	TACKLEBOX_CONFIG_SECTION                = "Fischers Box";
	TACKLEBOX_CONFIG_SECTION_INFO           = "Mit diesen Einstellungen wird das Fischen intuitiver indem h\195\164ufig benutzten Aktionen Tastaturk\195\188rzel zugewiesen werden.";
	TACKLEBOX_CONFIG_EASYCAST_ONOFF         = "Einfaches Werfen (EasyCast)";
	TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO    = "Wenn aktiviert und man eine Angel in der Hand h\195\164lt, reicht ein Rechtsklick um die Leine automatisch auszuwerfen.";
	TACKLEBOX_CONFIG_FASTCAST_ONOFF         = "Schnelles Werfen (FastCast)";
	TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO    = "Wenn aktiviert, wir die Leine unverz\195\188glich wieder ausgeworfen sobald man auf den Schwimmer klickt.";
	TACKLEBOX_CONFIG_EASYLURE_ONOFF		= "Einfaches K\195\182dern";
	TACKLEBOX_CONFIG_EASYLURE_ONOFF_INFO	= "Wenn aktiviert, wird auf die Angelrute automatisch ein Fischanlocker benutzt sofern jene nicht bereits einen besitzt und sich ein Fischanlocker im Inventar befindet.";
	TACKLEBOX_CONFIG_ALT_ONOFF		= "'Alt'-Taste f\195\188r Einfaches Werfen verwenden";
	TACKLEBOX_CONFIG_ALT_ONOFF_INFO		= "Wenn aktiviert, mu\195\159 die Alt-Taste beim Rechtsklick gedr\195\188ckt werden, um die Leine automatisch auszuwerfen.";
	TACKLEBOX_CONFIG_CTRL_ONOFF		= "'Strg'-Taste f\195\188r Einfaches Werfen verwenden";
	TACKLEBOX_CONFIG_CTRL_ONOFF_INFO	= "Wenn aktiviert, mu\195\159 die Strg-Taste beim Rechtsklick gedr\195\188ckt werden, um die Leine automatisch auszuwerfen.";
	TACKLEBOX_CONFIG_SHIFT_ONOFF		= "'Shift'-Taste f\195\188r Einfaches Werfen verwenden";
	TACKLEBOX_CONFIG_SHIFT_ONOFF_INFO	= "Wenn aktiviert, mu\195\159 die Shift-Taste beim Rechtsklick gedr\195\188ckt werden, um die Leine automatisch auszuwerfen.";
	TACKLEBOX_CONFIG_SWITCH_ONOFF           = "Ausr\195\188stungs Makro";
	TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO      = "F\195\188gt den Makros ein 'Fischers Box' Makro hinzu, mit dem die Ausr\195\188stung einfach gewechselt werden kann.";
	
	--------------------------------------------------
	--
	-- Chat Configuration
	--
	--------------------------------------------------	
	TACKLEBOX_OUTPUT_SET_POLE		= "Angel auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_MAIN		= "Waffenhand auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_SECONDARY		= "Schildhand auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_FISHING_HAT	= "Angelhut auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_FISHING_GLOVE	= "Angelhandschuhe auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_HAT		= "Normaler Hut auf %s eingestellt.";
	TACKLEBOX_OUTPUT_SET_GLOVE		= "Normale Handschuhe auf %s eingestellt.";
	TACKLEBOX_OUTPUT_NEED_SET_POLE		= "Bitte die Angel, die benutzt werden soll, in die Hand nehmen und nochmal versuchen.";
	TACKLEBOX_OUTPUT_NEED_SET_HAND		= "Bitte die Waffe, die benutzt werden soll, in die Hand nehmen und nochmal versuchen.";
	TACKLEBOX_OUTPUT_EASYCAST		= TACKLEBOX_CONFIG_EASYCAST_ONOFF;
	TACKLEBOX_OUTPUT_FASTCAST		= TACKLEBOX_CONFIG_FASTCAST_ONOFF;
	TACKLEBOX_OUTPUT_EASYLURE		= TACKLEBOX_CONFIG_EASYLURE_ONOFF;
	TACKLEBOX_OUTPUT_SWITCH			= "Makro Erstellung %s";
	TACKLEBOX_CHAT_SWITCH			= "Wechselt zwischen deiner Fischer- und Standard-Ausr\195\188stung.";
	TACKLEBOX_OUTPUT_ALT			= TACKLEBOX_CONFIG_ALT_ONOFF;
	TACKLEBOX_OUTPUT_CTRL			= TACKLEBOX_CONFIG_CTRL_ONOFF;
	TACKLEBOX_OUTPUT_SHIFT			= TACKLEBOX_CONFIG_SHIFT_ONOFF;
	TACKLEBOX_OUTPUT_OLD_SWITCH_WARN	= "Du verwendest ein altes Format beim Makro zum Wechseln. Bitte verwende \"/tb sw\" anstelle des Makros oder aktiviere das Ausr\195\188stungs Makro in den Optionen.";

	--------------------------------------------------
	--
	-- Other Strings
	--
	--------------------------------------------------
	TACKLEBOX_MACRO_NAME			= "Fischers Box";
	TACKLEBOX_LOG_HEADER			= "Fischer-Log";

	--------------------------------------------------
	--
	-- Help Text
	--
	--------------------------------------------------
	TACKLEBOX_CONFIG_INFOTEXT = {
		"[NOTE: If you are using Khaos, you may not be "..
		"seeing all of the options available.  For more "..
		"advanced options, increase the difficulty setting.]\n"..
		"\n"..
		"    Tackle Box is an addon that makes fishing much easier.  "..
		"It gives you a command to easily switch back and forth "..
		"between your fishing gear, and your normal gear.  To use "..
		"this command, you can either type /tb switch, or enable "..
		"the easy switch macro option which will add a macro that "..
		"you can drag to one of your action bars.\n\n"..
		"    It also allows you to simply, right click while you have a "..
		"fishing pole equipped, to cast your line.  You can choose to "..
		"only allow this when one of the system keys is allowed."..
		"\n\n"..
		"Easy Switch Usage:\n"..
		"-Put on your normal equipment, and then use the switch macro/command.\n"..
		"-Next put on your fishing equipment. (Including hat and gloves if you have them.)\n"..
		"-Use the switch macro/command again, and you are good to go.\n\n"..
		"Options Explainations:\n"..
		"Easy Cast - If this is enabled, then when you right click your "..
		"mouse while you have a fishing pole selected, the line will be "..
		"cast.  Fast Cast, and Easy Lure will only have an effect if this "..
		"is enabled.\n"..
		"\n"..
		"Fast Cast - Normally Tackle Box won't easy cast again until you "..
		"have finished fishing your current throw.  If this is enabled "..
		"then you easy cast your line while you are still fishing.  Doing "..
		"this will of course reset your current try.  This has the added "..
		"bonus of making it so that as soon as you right click the bobber "..
		"you will cast your line again.\n"..
		"\n"..
		"Easy Lure - This will put a lure on your pole if it needs one.  "..
		"If the pole doesn't have a lure on it, and you have a lure that "..
		"you can use, then the highest power lure will be applied to your pole, "..
		"instead of casting the line.  Once it is applied to your pole, just "..
		"right-click again to cast your line.\n"..
		"\n"..
		"Alt/Control/Shift for Easy Cast - If any of these are enabled "..
		"then you will have to be holding on of them when you right click "..
		"to do your easy cast.\n"..
		"\n"..
		"Easy Switch Macro - If this is enabled, then Tackle Box will make "..
		"a macro for you that you can drag into one of your bars, and "..
		"simply click to switch your equipment.  You can find the macro by "..
		"opening the main menu, then clicking on Macros.\n"..
		"\n"..
		"See page 3 for a list of slash commands.",
		
		"Tackle Box\n"..
		"\n"..
		"By: Mugendai\n"..
		"Special Thanks:\n"..
		"    Sinaloit: Origional use of textures to determine fishing skill and equipment.\n"..
		"    Aalny: Origional use of ItemLink's to store/recognize equipment.  As well as "..
				"a few tweaks and fixes.  Oh and the Shift click option.  Aalny did a "..
				"fair amount of good work.\n"..
		"    Groll: For asking for the Easy Lure feature\n"..
		"\n"..
		"Contact: mugekun@gmail.com"
	}
end