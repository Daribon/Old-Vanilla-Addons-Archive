-- Version : German (by DrVanGogh, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Cosmos Configuration
	ITEMBUFF_SEP			= "Ausr\195\188stungsbuffs";
	ITEMBUFF_CHECK			= "Zeitlich beschr\195\164nkte Buffs auf Ausr\195\188stungen angezeigen";
	ITEMBUFF_CHECK_INFO		= "Wenn aktiviert, wird das Fenster f\195\188r Ausr\195\188stungsbuffs angezeigt.";
	ITEMBUFF_CANTUPDATE		= "- w\195\164hrend eines Handels nicht verf\195\188gbar -";

	ITEMBUFF_SMALL_ICONS		= "Kleine Icons verwenden";
	ITEMBUFF_SMALL_ICONS_INFO	= "Wenn aktiviert, werden kleine Icons f\195\188r Ausr\195\188stungsbuffs verwendet.";

	ITEMBUFF_DISPLAY_BUFFNAME	= "Buffname sowie verbleibende Zeit anzeigen";
	ITEMBUFF_DISPLAY_BUFFNAME_INFO	= "Wenn aktiviert, wird neben dem Icon des Ausr\195\188stungsbuffs dessen Name sowie die verbleibende Zeit angezeigt.";

	ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY		= "Verbleibende Zeit unter Ausr\195\188stungsbuff anzeigen";
	ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY_INFO	= "Wenn aktiviert, wird die die noch verbleibende Zeit des Ausr\195\188stungsbuffs unterhalb des Icons angezeigt.";

	-- Chat Configuration
	ITEMBUFF_CHAT_COMMAND_INFO	= "Kontolliert die "..ITEMBUFF_SEP..".";
	ITEMBUFF_HELP			= "help";		-- must be lowercase; displays help
	ITEMBUFF_STATUS			= "status";		-- must be lowercase; shows status
	ITEMBUFF_FREEZE			= "freeze";		-- must be lowercase; freezes the window in position
	ITEMBUFF_UNFREEZE		= "unfreeze";		-- must be lowercase; unfreezes the window so that it can be dragged
	ITEMBUFF_RESET			= "reset";		-- must be lowercase; resets the window to its default position

	ITEMBUFF_STATUS_HEADER		= "|cffffff00Ausr\195\188stungsbuff Status:|r";
	ITEMBUFF_FROZEN			= "Fenster: auf Position fixiert";
	ITEMBUFF_UNFROZEN		= "Fenster: freigelassen und kann verschoben werden";
	ITEMBUFF_RESET_DONE		= "Fenster: Position auf Standard zur\195\188ckgesetzt";

	ITEMBUFF_HELP_TEXT0		= " ";
	ITEMBUFF_HELP_TEXT1		= "|cffffff00Ausr\195\188stungsbuff Befehlshilfe:|r";
	ITEMBUFF_HELP_TEXT2		= "|cff00ff00Use |r|cffffffff/itembuff <Befehl>|r|cff00ff00 oder |r|cffffffff/ib <Befehl>|r|cff00ff00 um einen der folgenden Befehle auszuf\195\188hren:|r";
	ITEMBUFF_HELP_TEXT3		= "|cffffffff"..ITEMBUFF_HELP.."|r|cff00ff00: zeigt diese Hilfe an.|r";
	ITEMBUFF_HELP_TEXT4		= "|cffffffff"..ITEMBUFF_STATUS.."|r|cff00ff00: zeigt Statusinformationen zur momentanen Einstellung.|r";
	ITEMBUFF_HELP_TEXT5		= "|cffffffff"..ITEMBUFF_FREEZE.."|r|cff00ff00: fixiert das Fenster auf der momentanen Position fest, soda\195\159 es nicht mehr verschoben werden kann.|r";
	ITEMBUFF_HELP_TEXT6		= "|cffffffff"..ITEMBUFF_UNFREEZE.."|r|cff00ff00: setzt das Fenster wieder frei, soda\195\159 es wieder verschoben werden kann.|r";
	ITEMBUFF_HELP_TEXT7		= "|cffffffff"..ITEMBUFF_RESET.."|r|cff00ff00: setzt das Fenster auf seine Standardposition zur\195\188ck.|r";
	ITEMBUFF_HELP_TEXT8		= " ";
	ITEMBUFF_HELP_TEXT9		= "|cff00ff00Beispiel: |r|cffffffff/itembuff freeze|r|cff00ff00 fixiert das Fenster auf der momentanen Position und verhindert somit, da\195\159 jenes verschoben werden kann.|r";


	-- Localisation Strings
	ITEMBUFF_ENCHANT_TIME_LEFT_MINUTES	= "%(%d+ Min%.%)";
	ITEMBUFF_ENCHANT_TIME_LEFT_SECONDS	= "%((%d+) Sek%.%)";

	ItemBuff_HideBuffsFromTheseItems = {
		"Feuerstein",	
		"Gro\195\159er Feuerstein",
		"GeringerFeuerstein",
		"M\195\164chtiger Feuerstein",
		"Windfury Totem"
	};

end