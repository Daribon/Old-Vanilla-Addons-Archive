--[[
--	FileName Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2041 2005-07-05 11:30:14Z mugendai $
--	$Rev: 2041 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-07-05 06:30:14 -0500 (Tue, 05 Jul 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--Only overwrite if version is newer, be sure to include this(but not the above part) in localizations
	if (MCom_Update) then
		--------------------------------------------------
		--
		-- MCom types
		--
		--------------------------------------------------
		MCOM_BOOLT = "B";
		MCOM_NUMT = "N";
		MCOM_MULTIT = "M";
		MCOM_STRINGT = "S";
		MCOM_SIMPLET = "E";
		MCOM_CHOICET = "C";
		MCOM_COLORT = "K";

		--------------------------------------------------
		--
		-- MCom help text
		--
		--------------------------------------------------
		MCOM_CHAT_COMMAND_ALIAS		= "Alternative Befehle: %s";
		MCOM_CHAT_COMMAND_COMMANDS	= "Befehle: [Befehl] - [Typ] - [Details]";
		MCOM_CHAT_COMMAND_SUBCOMMAND	= "%s - %s - %s";
		MCOM_CHAT_COMMAND_NOINFO	= "Keine zus\195\164tzlichen Informationen verf\195\188gbar.";
		MCOM_CHAT_COM_CLIST		= "M\195\182glichkeiten: %s";
		MCOM_CHAT_COM_USAGE		= "Wenn Befehle verwendet werden, die Klammern nicht mit angeben.";
	
		MCOM_CHAT_C_M			= MCOM_CHOICET.."M";	--Letter indicator that this is a multiple choice option
		MCOM_CHAT_K_O			= MCOM_COLORT.."O";	--Letter indicator that this is a color option with opacity
		
		MCOM_CHAT_COM_B			= "[Ein/Aus]";
		MCOM_CHAT_COM_N			= "[Nummer]";
		MCOM_CHAT_COM_S			= "[Zeichenkette]";
		MCOM_CHAT_COM_C			= "[Auswahl]";
		MCOM_CHAT_COM_C_M		= "[Auswahl[ weitereAuswahl]]";
		MCOM_CHAT_COM_K			= "[rot gr\195\188n blau]";
		MCOM_CHAT_COM_K_O		= "[rot gr\195\188n blau [Opazit\195\164t]]";
		
		MCOM_CHAT_COM_USAGE_S_E		= "Benutzung %s";
		MCOM_CHAT_COM_USAGE_S_S		= "Benutzung %s %s";
		MCOM_CHAT_COM_USAGE_S_M		= "Benutzung %s "..MCOM_CHAT_COM_B.." %s";
		
		MCOM_CHAT_COM_USAGE_E		= "Benutzung f\195\188r ("..MCOM_SIMPLET..") %s [option]";
		MCOM_CHAT_COM_USAGE_S		= "Benutzung f\195\188r (%s) %s [Option] %s";
		MCOM_CHAT_COM_USAGE_M		= "Benutzung f\195\188r (%s) %s [Option] "..MCOM_CHAT_COM_B.." %s";
		
		MCOM_CHAT_COM_EXAMPLE		= "Beispiel:";
		
		MCOM_CHAT_COM_EXAMPLE_O_B	= "Ein";
		MCOM_CHAT_COM_EXAMPLE_O_N	= "1";
		MCOM_CHAT_COM_EXAMPLE_O_S	= "eineZeichenkette";
		MCOM_CHAT_COM_EXAMPLE_O_C	= "Auswahl1";
		MCOM_CHAT_COM_EXAMPLE_O_C_M	= "Auswahl1 Auswahl2 Auswahl5";
		MCOM_CHAT_COM_EXAMPLE_O_K	= "20 56 100";
		MCOM_CHAT_COM_EXAMPLE_O_K_O	= "20 56 100 62";
		
		MCOM_CHAT_COM_EXAMPLE_S_E	= "%s";
		MCOM_CHAT_COM_EXAMPLE_S_S	= "%s %s";
		MCOM_CHAT_COM_EXAMPLE_S_M	= "%s "..MCOM_CHAT_COM_EXAMPLE_O_B.." %s";
		
		MCOM_CHAT_COM_EXAMPLE_E		= "%s %s";
		MCOM_CHAT_COM_EXAMPLE_S		= "%s %s %s";
		MCOM_CHAT_COM_EXAMPLE_M		= "%s %s "..MCOM_CHAT_COM_EXAMPLE_O_B.." %s";
		
		MCOM_CHAT_ENABLED		= "Aktiviert";
		MCOM_CHAT_DISABLED		= "Deaktiviert";
		
		MCOM_FEEDBACK_CHECK		= "%s %s";
		MCOM_FEEDBACK_RADIO		= "%s gesetzt auf %s";
		
		MCOM_PAGE_TEXT			= "Seite (%s/%s)";
		MCOM_HELP_COMMAND		= "Hilfe";
		MCOM_HELP_CONFIG		= "%s Hilfe";
		MCOM_HELP_CONFIG_INFO		= "Zeigt ein Fenster mit hilfreichen Informatione \195\188ber %s an.";
		MCOM_HELP_GENERIC		= "Zeigt ein Fenster mit hilfreichen Informatione \195\188ber dieses AddOn an.";
		MCOM_HELP_TITLE			= "%s Hilfe";
		MCOM_HELP_GENERIC_TITLE		= "Hilfe";
	end

end