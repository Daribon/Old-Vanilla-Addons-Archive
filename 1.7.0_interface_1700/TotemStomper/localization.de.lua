-- Version : German (by DrVanGogh, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- <= == == == == == == == == == == == == =>
	-- => Bindings Names
	-- <= == == == == == == == == == == == == =>
	BINDING_HEADER_TOTEMSTOMPER	= "Totemstampfer";
   
	BINDING_NAME_TOTEMSET1		= "Totem-Set A zaubern";
	BINDING_NAME_TOTEMSET2		= "Totem-Set B zaubern";
	BINDING_NAME_TOTEMSET3		= "Totem-Set C zaubern";
	BINDING_NAME_TOTEMSET4		= "Totem-Set D zaubern";
	BINDING_NAME_TOTEMSET5		= "Totem-Set E zaubern";
   
	BINDING_NAME_TOTEMSHOW		= "Totemstampfer ein-/ausschalten";
   
	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Settings
	-- <= == == == == == == == == == == == == =>
	COS_TS_SEPARATOR_TEXT		= "Totemstampfer";
	COS_TS_SEPARATOR_INFO		= "Ein Schamane kann mittels Totemstampfer verschiedene Totems zu Gruppen zusammenfassen, die dann mit einer Taste gezaubert werden k\195\182nnen.";
	COS_TS_ENABLE_TEXT		= "Shortcut-Tasten des Totemstampfers aktivieren";
	COS_TS_ENABLE_INFO		= "Wenn aktiviert, k\195\182nnen die in der Tastaturbelegung zugewiesenen Shortcuts benutzt werden um die Totem-Sets auszul\195\182sen.";
	COS_TS_DELAY_TEXT		= "Zauber-Verz\195\182gerung einstellen";
	COS_TS_DELAY_INFO		= "Mit diesem Regler kann die Verz\195\182gerung zwischen jedem Zauber eingestellt werden. Standardm\195\164\195\159ig nicht aktiviert, wodurch die Verz\195\182gerung anhand der Abklingzeit des jew. Zaubers berechnet wird."

	-- <= == == == == == == == == == == == == =>
	-- => International Language Code
	-- <= == == == == == == == == == == == == =>
	TOTEMSTOMPER_HELP		= "Anwendung: /stomp A-E oder 1-5 (z.B. /stomp 2) um das entsprechende Totem-Set zu zaubern. |cFFAA3333[Nur Makro]|r";
	TOTEMSTOMPER_INSTRUCTION	= "Totemspr\195\188che vom Zauberbuch in die Boxen ziehen. Aktiviere die Sets mit dem entsprechenden Shortcut (x4)";
	TOTEMSTOMPER_PARTY_INSTRUCTION	= "Zeigt Verwendung von Gruppen-Totemzaubern an.\nBoxen bleiben leer bis ein\nTotem-Set benutzt wird.";
	TOTEMSTOMPER_FULL_INSTRUCTIONS	= "Anwendung:\n\195\156ber die Cosmos Einstellungen die Seite des Totemstampfers \195\182ffnen, das Zauberbuch \195\182ffnen, danach per Drag & Drop oder Shift-Klick die Totems, die man benutzen m\195\182chte, in die entprechende Sets bzw. Boxen ziehen. \195\150ffne nun das Fenster f\195\188r die Tastaturbelegung und scrolle nach unten bis zum Eintrag des Totem Stomper. Belege die Sets A bis E mit Shotcut Tasten und dr\195\188cke jene im Spiel, um die Totems zu setzen. Die Totems werden in der Reihenfolge gesetzt, wie sie festgelegt werden (Falls das unverst\195\164ndlich ist: Totem Stomper \195\182ffnen und zuschauen, w\195\164hrend man die Tasten dr\195\188ckt)\nStandardm\195\164\195\159ig wird der Cooldown jedes Totems abgewartet, bevor es gezaubert wird. Um Spr\195\188che, die man noch nicht zaubern kann, zu \195\188berspringen, einfach das 'warten' Kontrollk\195\164stchen deaktivieren.\nTotem Stomper Sets k\195\188nnen per /stomp <Befehl> in Makros verwendet werden (zum Gebrauch mit den normalen Aktionsleisten). ";
	TOTEMSTOMPER_TOTEMSHARE_INSTRUCTIONS = "Totem Teiler:\nDer Totem Teiler teilt die Inhalte der aktiven Totem-Sets allen Partymitgliedern mit. Es wird dann ein gruppeninternen Totemvergleich durchgef\195\188hrt und folgende Farbcodierung werden vorgenommen: Der Spieler mit dem besten Totem einer bestimmten Art wird gr\195\188n eingef\195\164rbt, Spieler, die ein Totem der gleichen Art und Rang benutzen, werden rot und Spieler, die minderwertigere Totems benutzen, grau eingef\195\164rbt.\nDies funktioniert nur, falls die Totems per /stomp Makro oder Totemstampfer Tastenk\195\188rzel gesetzt wurden.";
	TOTEMSTOMPER_VERSION_TIP	= "Programmiert von AlexYoshi";
	TOTEMSTOMPER_VERSION		= "1.0";
	
	TOTEMSTOMPER_WAIT_TIP		= "Aktivieren um die Abklingzeit abzuwarten,\nbevor der n\195\164chste Zauber ausgef\195\188hrt wird.";
	TOTEMSTOMPER_SKIP_TIP		= "Aktivieren um einen Zauber auszulassen und mit dem n\195\164chsten fortzufahren.";
   
	VERSIONLABEL			= "Version";
	RESET				= "R\195\188cksetzen";

	TOTEMSTOMPER_BUTTON_TITLE	= "Totemstampfer";
	TOTEMSTOMPER_BUTTON_SUBTITLE	= "Totem-Sets";
	TOTEMSTOMPER_BUTTON_TIP		= "Erlaubt es einem Schamanen bestimmte Abfolgen von Totems anzulegen\num so das Setzen von Totems zu vereinfachen.";

end