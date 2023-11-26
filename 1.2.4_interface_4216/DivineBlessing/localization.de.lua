-- Version : German (by StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- <= == == == == == == == == == == == == =>
	-- => Bindings Names
	-- <= == == == == == == == == == == == == =>
	BINDING_HEADER_DIVINEBLESSING		= "G\195\182ttliche Segnung";

	BINDING_NAME_BLESSINGSET1		= "Segnungs-Set A benutzen";
	BINDING_NAME_BLESSINGSET2		= "Segnungs-Set B benutzen";
	BINDING_NAME_BLESSINGSET3		= "Segnungs-Set C benutzen";
	BINDING_NAME_BLESSINGSET4		= "Segnungs-Set D benutzen";
	BINDING_NAME_BLESSINGSET5		= "Segnungs-Set E benutzen";

	BINDING_NAME_BLESSINGSHOW		= "Fenster anzeigen/verbergen";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Settings
	-- <= == == == == == == == == == == == == =>
	DIVINEBLESSING_BUTTON_TITLE		= "G\195\182ttliche Segnung";
	DIVINEBLESSING_BUTTON_SUBTITLE		= "Segnungs-Sets";
	DIVINEBLESSING_BUTTON_TIP		= "Erlaubt es einem Paladin bestimmte Abfolgen von Buffs anzulegen\num so das Buffen von Gruppenmitgliedern zu vereinfachen.";

	COS_DB_SEPARATOR_TEXT			= "G\195\182ttliche Segnung";
	COS_DB_SEPARATOR_INFO			= "G\195\182ttliche Segnung erlaubt es einem Paladin bestimmte Abfolgen von Buffs anzulegen um so das Buffen von Gruppenmitgliedern zu vereinfachen.";
	COS_DB_ENABLE_TEXT			= "Shortcut-Tasten der G\195\182ttlichen Segnung aktivieren";
	COS_DB_ENABLE_INFO			= "Wenn aktiviert, k\195\182nnen die in der Tastaturbelegung zugewiesenen Shortcuts benutzt werden um die Segnungs-Sets auszul\195\182sen.";
	COS_DB_DELAY_TEXT			= "Buff-Verz\195\182gerung einstellen";
	COS_DB_DELAY_INFO			= "Mit diesem Regler kann die Verz\195\182gerung zwischen jedem Buff eingestellt werden. Ist standardm\195\164\195\159ig nicht aktiviert, wodurch die Verz\195\182gerung anhand der Abklingzeit des jew. Buffs berechnet wird.";
	COS_DB_IGNOREABSENT_TEXT		= "Leere Gruppen-Slots ignorieren";
	COS_DB_IGNOREABSENT_INFO		= "Wenn aktiviert, werden Buffs die in Gruppen-Slots zugewiesen wurden in denen sich aber momentan kein Gruppenmitglied befindet \195\188bersprungen.";
	COS_DB_SHOWANNOUNCE_TEXT		= "Aktiviere Status-Nachrichten";
	COS_DB_SHOWANNOUNCE_INFO		= "Wenn aktiviert, wird bei jeder Aktion von G\195\182ttliche Segnung eine Statusnachricht ausgegeben.";
	COS_DB_BANNERANNOUNCE_TEXT		= "Fertigstellung eines Sets in Bildschirmmitte melden";
	COS_DB_BANNERANNOUNCE_INFO		= "Wenn nicht aktiviert, wird die Meldung nach Fertigstellung eines\nBuff-Sets im Haupt-Chat Fenster ausgegeben\nund nicht in der Mitte des Bildschirms.";
	COS_DB_OVERRIDETARGET_TEXT		= "Befreundetes Ziel akzeptieren";
	COS_DB_OVERRIDETARGET_INFO		= "Wenn aktiviert, wird der erste Buff eines Segnung-Sets auf das angew\195\164hlte befreundete Ziel ausgef\195\188hrt und nicht auf einen selbst. Vorsussetzung ist, da\195\159 ein g\195\188ltiges befreundetes Ziel angew\195\164hlt ist.";

	-- <= == == == == == == == == == == == == =>
	-- => International Language Code
	-- <= == == == == == == == == == == == == =>
	DIVINEBLESSING_HELP			= "Benutze /bless A-E oder 1-5 (z.B. /bless 2) um das entsprechende Segnung-Set auszuf\195\188hren. |cFFAA3333[Nur Macro]|r";
	DIVINEBLESSING_INSTRUCTION		= "Ziehe Buff-Zauber vom Zauberbuch in die Boxen. Aktiviere die Sets mit dem entsprechenden Shortcut (x5)";
	DIVINEBLESSING_PARTY_INSTRUCTION	= "Zeigt Verwendung von Gruppen-Buffs an.\nBoxen bleiben leer bis ein\nSegnung-Set benutzt wird.";
	DIVINEBLESSING_FULL_INSTRUCTIONS	= "Anwendung:\n\195\150ffne das Fenster der G\195\182ttliche Segnung \195\188ber das Cosmos-Men\195\188, \195\182ffne dein Zauberbuch und ziehe anschlie\195\159end mittels Drag & Drop oder Shift + Maustaste die Buffs, welche verwendet werden sollen, in die entsprechenden Sets bzw. Boxen. \195\150ffne nun das Fenster f\195\188r die Tastaturbelegung und scolle runter bis zum Eintrag der G\195\182ttlichen Segnung. Belege die Sets A bis E mit Shotcut Tasten und dr\195\188cke jene im Spiel um ein Gruppenmitglied entsprechend zu buffen. Die Buffs werden in der Reihenfolge ausgef\195\188hrt in der sie im Set festgelegt wurden... beginnend beim Caster selbst und dann der Reihe nach vom ersten bis zm letzten Gruppenmitglied."
	DIVINEBLESSING_BLESSINGSHARE_INSTRUCTIONS = "Buff Teiler:\nDer Buff Teiler teilt die Inhalte der aktiven Segnung-Sets allen Partymitgliedern mit. Es wird dann ein gruppeninternen Buffvergleich durchgef\195\188hrt und folgende Farbcodierung werden vorgenommen: Der Spieler mit dem besten Buff einer bestimmten Art wird gr\195\188n eingef\195\164rbt, Spieler, die einen Buff der gleichen Art und Rang benutzen, werden rot und Spieler, die minderwertigere Buffs benutzen, grau eingef\195\164rbt.\nDies funktioniert nur, falls die Buff-Sets per /bless Makro oder entsprechendem Tastenk\195\188rzel gesetzt wurden.";
	DIVINEBLESSING_VERSION_TIP		= "Programmiert von CheshireKatt";
	DIVINEBLESSING_VERSION			= "1.5";

	DIVINEBLESSING_WAIT_TIP			= "Aktivieren um die Abklingzeit abzuwarten,\nbevor der n\195\164chste Buff ausgef\195\188hrt wird.";
	DIVINEBLESSING_SKIP_TIP			= "Aktivieren um einen Buff auszulassen\nund mit dem n\195\164chsten fortzufahren.";

	VERSIONLABEL				= "Version";
	RESET					= "R\195\188cksetzen";

end