--[[
--
--	DamageMeters Localization Data (GERMAN)
--

    German translation by Zoldan
           and Chakotay1357.  Many thanks!
	   and StarDust
    
    Last Update : 06/29/2005
--]]

if ( GetLocale() == "deDE" ) then

	-- Bindings --
	BINDING_HEADER_DAMAGEMETERSHEADER 		= "SchadensAnzeiger";
	BINDING_NAME_DAMAGEMETERS_TOGGLESHOW		= "Fenster anzeigen/verbergen";
	BINDING_NAME_DAMAGEMETERS_CYCLEQUANT		= "Sichtbare Menge wechseln";
	BINDING_NAME_DAMAGEMETERS_CYCLEQUANTBACK	= "Sichtbare Menge umgekehrt wechseln";
	BINDING_NAME_DAMAGEMETERS_CLEAR			= "Daten l\195\182schen";
	BINDING_NAME_DAMAGEMETERS_TOGGLEPAUSED		= "Pause aktivieren/deaktivieren";
	BINDING_NAME_DAMAGEMETERS_SHOWREPORTFRAME	= "Konsolenfenster anzeigen";
	BINDING_NAME_DAMAGEMETERS_SWAPMEMORY		= "Speichert tauschen";
	BINDING_NAME_DAMAGEMETERS_TOGGLESHOWMAX		= "Max. Anzahl an Leisten ja/nein";

	-- Cosmos/Earth button
	DAMAGEMETERS_SHORT_DESC				= "Zeigt, wer wieviel ... verursacht.";
	DAMAGEMETERS_DESCRIPTION			= "Zeigt, wer wieviel Schaden, Heilung usw.\nin deiner Gruppe/Schlachtzug verursacht.";

	-- Help --
	DamageMeters_helpTable = {
		"Folgende Befehle k\195\182nnen in die Konsole eingegeben werden:",
		"/dmhelp : Alle verf\195\188gbaren /dm (Damage Meters) - Befehle auflisten.",
		"/dmshow : Das Fenster anzeigen.",
		"/dmhide : Das Fenster Verstecken.",
		"/dmclear [#] : Entfernt # Eintr\195\164ge von unten aus der Liste. Wenn # nicht angegeben wird, wird die gesamte Liste gel\195\182scht.",
		"/dmreport [c/s/p/r/w/h/g[#]] [whispertarget/Kanalname] - Gibt die aktuellen Daten aus. c druckt in die Konsole, s gibt als 'sag' aus, p zur Gruppe, r zum Schlachtzug, w als fl\195\188stern zum Spieler 'whispertarget', g zum Gildenchat und h zum Kanal channelname.  Wenn Grossbuchstaben eingegeben werden, erscheint die Ausgabe in umgekehrter Reihenfolge.  Wenn # angegen wird, werden nur die ersten # Spieler ausgegeben.",
		"/dmsort [#] - Stellt die Sortiermethode ein.  Setzte keine Zahl f\195\188r eine Liste der verf\195\188gbahren Styles.",
		"/dmcount [#] - Stellt die Anzahl der auf einmal sichtbaren Leisten ein.  Wenn # nicht angegeben wird, wird das Maximum angezeigt.",
		"/dmsave - Speichert die aktuelle Tabelle intern.",
		"/dmrestore - Stellt eine zuvor gespeicherte Tabelle wieder her und \195\188berschreibt dabei neue Daten.",
		"/dmmerge - Verbindet eine zuvor gespeicherte Tabelle mit bereits vorhandenen Daten.",
		"/dmswap - Tauscht die zuvor gespeicherte Tabelle mit der aktuellen.",
		"/dmmemclear - L\195\182scht alle gespeicherten Werte.",
		"/dmresetpos - Setzt die Position des Fensters zur\195\188ck (Hilfreich, wenn man es verliert.)",
		"/dmtext 0/<[n][p][v]> - Stellt den anzuzeigenden Text an den Leisten ein. n - Spielername. p - Prozent. v - Wert.",
		"/dmcolor # - Stellt das Farbschema f\195\188r die Leisten ein. Wenn # nicht angegeben wird, erscheint eine Liste mit Optionen.",
		"/dmquant # - Stellt die Gr\195\182sse, die die Leisten benutzen sollen ein. Wenn # nicht angegeben wird, erscheint eine Liste mit Optionen.",
		"/dmvisinparty [y/n] - Stellt ein, ob das Fenster nur in einer Gruppe oder einem Schlachtzug angezeigt werden soll. Kein Argument schaltet hin und her.",
		"/dmautocount # - Wenn # gr\195\182sser als Null ist, wird das Fenster soviele Leisten anzeigen, wie es Informationen hat bis zu #. Wenn # gleich Null ist, wird das Automatische Z\192\164hlen abgeschaltet.",
		"/dmlistbanned - Listet alle verbannten Schadensquellen auf.",
		"/dmclearbanned - L\195\182scht die Liste der verbannten Schadensquellen.",
		"/dmsync - Synchronisiert Deine Daten mit anderen Benutzern, die den selben Kanal wie Du nutzen. (Ruft dmsyncsend und dmsyncrequest auf)",
		"/dmsyncchan - Stellt den Namen des Kanals ein, der zum Synchronisieren benutzt wird.",
		"/dmsyncsend - Sendet sync - Informationen auf dem sync - Kanal.",
		"/dmsyncrequest - Sendet eine Anfrage f\195\188r das automatische dmsync an andere Spieler, die Deinen Sync-Kanal benutzen.",
		"/dmsyncclear - Sendet eine Anfrage an andere Spieler, die Deinen Sync-Kanal benutzen, alle Daten zu l\195\182schen.",
		"/dmsyncmsg msg - Sendet eine Nachricht an andere Spieler im selben SyncChannel. Kann auch mit /dmm verwendet werden.",
		"/dmpop - Erstellt die Liste mit den aktuellen Gruppen- / Schlachtzugsmitgliedern (aber entfernt keine bereits vorhandene Eintr\192\164ge).",
		"/dmlock - Nur Log Eintr\195\164ge auswerten, die zu Spielern geh\195\182ren, die bereits in der Liste erfasst sind.",
		"/dmpause - Loganalyse stoppen/starten.",
		"/dmlockpos - Das Fenster fixieren/freisetzen.",
		"/dmgrouponly - Nur Log Eintr\195\164ge von Gruppen-/Schlachtzugsmitgliedern auswerten. (Begleiter werden immer ausgewertet.)",
		"/dmaddpettoplayer - Begleiterdaten zum Besitzer z\195\164hlen.",
		"/dmresetoncombat = Bei Kampfbeginn Daten zur\195\188cksetzen.",
		"/dmversion - Zeigt Versionsinformationen.",
		"/dmtotal - Gesamtanzeige verwenden ja/nein.",
		"/dmshowmax - Maximale Anzahl an Leisten anzeigen ja/nein."
	};

	-- Filters
	DamageMeters_Filter_STRING1 = "Gruppenmitglieder";
	DamageMeters_Filter_STRING2 = "Alle freundlich gesinnten Charaktere";

	-- Relationships
	DamageMeters_Relation_STRING = {
		"Selbst",
		"Mein Tier",
		"Gruppe",
		"Freundliche"};

	-- Color Schemes
	DamageMeters_colorScheme_STRING = {
		"Beziehungen",
		"Klassenfarben"};

	-- Quantities
	DamageMeters_Quantity_STRING = {
		"Verursacht. Schaden",
		"Geheilt",
		"Erlittener Schaden",
		"Heilung erhalten",
		"Unt\195\164tige Zeit",
		"DPS"};

	-- Sort
	DamageMeters_Sort_STRING = {
		"Abnehmend",
		"Zunehmend",
		"Alphabetisch"};
	
	-- Class Names
	function DamageMeters_GetClassColor(className)
		return RAID_CLASS_COLORS[string.upper(className)];
	end

	-- Errors
	DM_ERROR_INVALIDARG		= "SchadensAnzeiger: Unzul\195\164ssiges Argument.";
	DM_ERROR_MISSINGARG		= "SchadensAnzeiger: Argument fehlt.";
	DM_ERROR_NOSAVEDTABLE		= "SchadensAnzeiger: Keine Tabelle gepseichert.";
	DM_ERROR_BADREPORTTARGET	= "SchadensAnzeiger: Unzul\195\164ssiges Ziel = ";
	DM_ERROR_MISSINGWHISPERTARGET	= "SchadensAnzeiger: Fl\195\188stern eingestellt, aber kein Spieler angegeben.";
	DM_ERROR_MISSINGCHANNEL		= "SchadensAnzeiger: Kanal eingegeben, aber es wurde keine Nummer angegeben.";
	DM_ERROR_NOSYNCCHANNEL		= "SchadensAnzeiger: Sync Kanal muss mit dmsyncchan angegeben werden bevor dmsync aufgerufen wird.";
	DM_ERROR_JOINSYNCCHANNEL	= "SchadensAnzeiger: Du musst den sync Kanal ('%s') betreten, bevor dmsync aufgerufen wird.";
	DM_ERROR_SYNCTOOSOON		= "SchadensAnzeiger: Sync Anfrage zu schnell nach der letzten; ignoriert.";
	DM_ERROR_POPNOPARTY		= "SchadensAnzeiger: Kann Tabelle nicht f\195\188llen; Du bist in keiner Gruppe oder einem Schlachtzug.";
	DM_ERROR_NOROOMFORPLAYER	= "SchadensAnzeiger: Begleiterdaten k\195\182nnen nicht mit Besitzer vereinigt werden (Liste voll?).";

	-- Messages --
	DM_MSG_SETQUANT			= "SchadensAnzeiger: Sichtbare Anzeigen gesetzt auf ";
	DM_MSG_CURRENTQUANT		= "SchadensAnzeiger: Aktuelle Anzeigen = ";
	DM_MSG_CURRENTSORT		= "SchadensAnzeiger: Aktuelle Sortierung = ";
	DM_MSG_SORT			= "SchadensAnzeiger: Sortierung gesetzt auf ";
	DM_MSG_CLEAR			= "SchadensAnzeiger: L\195\182sche %d bis %d.";
	DM_MSG_REMAINING		= "SchadensAnzeiger: %d Eintr\195\164ge \195\188brig.";
	DM_MSG_REPORTHEADER		= "SchadensAnzeiger: <%s> berichte aus %d/%d Quellen:";
	DM_MSG_SETCOUNTTOMAX		= "SchadensAnzeigers: Kein Z\195\164hlargument spezifiziert, wird auf Maximum gesetzt.";
	DM_MSG_SETCOUNT			= "SchadensAnzeiger: Neue Leistenanzahl = ";
	DM_MSG_RESETFRAMEPOS		= "SchadensAnzeiger: Position des Fensters zur\195\188ckgesetzt.";
	DM_MSG_SAVE			= "SchadensAnzeiger: Tabelle gesichert.";
	DM_MSG_RESTORE			= "SchadensAnzeiger: Gesicherte Tabelle wiederhergestellt.";
	DM_MSG_MERGE			= "SchadensAnzeiger: Vereinige gespeicherte Tabelle mit aktueller.";
	DM_MSG_SWAP			= "SchadensAnzeiger: Normale Tabelle (%d) und gesicherte Tabelle (%d) getauscht.";
	DM_MSG_SETCOLORSCHEME		= "SchadensAnzeiger: Farbschema gesetzt auf ";
	DM_MSG_TRUE			= "zutreffend";
	DM_MSG_FALSE			= "falsch";
	DM_MSG_SETVISINPARTY		= "SchadensAnzeiger: Nur-in-einer-Gruppe-anzeigen gesetzt auf ";
	DM_MSG_SETAUTOCOUNT		= "SchadensAnzeiger: Neues Automatisches Z\195\164hlen gesetzt auf ";
	DM_MSG_LISTBANNED		= "SchadensAnzeiger: Verbannte Schadensquellen auflisten:";
	DM_MSG_CLEARBANNED		= "SchadensAnzeiger: L\195\182sche alle verbannten Schadensquellen.";
	DM_MSG_HOWTOSHOW		= "SchadensAnzeiger: Verstecke Fenster. /dmshow benutzen um es wieder anzuzeigen.";
	DM_MSG_SYNCCHAN			= "SchadensAnzeiger: Synchronization Kanal gesetzt auf ";
	DM_MSG_SYNCREQUESTACK		= "SchadensAnzeiger: Sync angefragt: sende Informationen.";
	DM_MSG_SYNC			= "SchadensAnzeiger: Sende sync Informationen.";
	DM_MSG_LOCKED			= "SchadensAnzeiger: Position der Liste fixiert.";
	DM_MSG_NOTLOCKED		= "SchadensAnzeiger: Liste freigegeben.";
	DM_MSG_PAUSED			= "SchadensAnzeiger: Loganalyse angehalten.";
	DM_MSG_UNPAUSED			= "SchadensAnzeigers: Loganalyse wird fortgesetzt.";
	DM_MSG_POSLOCKED		= "SchadensAnzeiger: Fenster verankert.";
	DM_MSG_POSNOTLOCKED		= "SchadensAnzeiger: Fenster freigesetzt.";
	DM_MSG_CLEARRECEIVED		= "SchadensAnzeiger: Anfrage Daten zu l\195\182schen erhalten von ";
	DM_MSG_ADDINGPETTOPLAYER	= "SchadensAnzeiger: Begleiterdaten werden zum Besitzer gez\195\164hlt.";
	DM_MSG_NOTADDINGPETTOPLAYER	= "SchadensAnzeiger: Begleiterdaten werden extra gez\195\164hlt.";
	DM_MSG_PETMERGE			= "SchadensAnzeiger: Vereinige Begleiterdaten (%s) mit Deinen.";
	DM_MSG_RESETWHENCOMBATSTARTSCHANGE = "SchadensAnzeiger: Bei Kampfbeginn zur\195\188cksetzen = ";
	DM_MSG_COMBATDURATION		= "Kampfdauer = %.2f Sekundens.";
	DM_MSG_RECEIVEDSYNCDATA		= "SchadensAnzeiger: Sync. Daten empfangen von %s.";
	DM_MSG_TOTAL			= "GESAMT";
	DM_MSG_VERSION			= "SchadensAnzeiger Version %s aktiviert.";
	DM_MSG_REPORTHELP		= "Der /dmreport Befehl besteht aus drei Teilen:\n\n1) Der Zielcharakter. Dies kann einer der folgenden Buchstaben sein:\n  c - Konsole (welche nur du sehen kannst).\n  s - Sagen\n  p - Gruppenchat\n  r - Schlachtzug Chat\n  g - Gildenchat\n  h - Chat cHannel. /dmreport h meinchannel\n  w - zum Spieler fl\195\188stern.  /dmreport w dandelion\n  f - Fenster: Zeigt den Bericht in diesem Fenster an.\n\nWenn ein Kleinbuchstabe angegeben wird, wird der Bericht in umgekehrter Reihenfolge angezeit.\n\n2) Optional, die Anzahl der personen, auf welche beschr\195\164nkt werden soll.  Diese Nummer muss direkt nach dem Zielcharakter folgen.\nBeispiel: /dmreport p5.\n\n3) Standardm\195\164\195\159ig wird der Report wird nur nach der momentanen Anzahl an sichtbaren Menge wiedergegeben.  Wenn das Wort 'total' vorm Zielcharakter angegeben wird, wird der Report von allen wiedergegeben. 'Total' Berichte sind so formatiert, da\195\159 jene bei einem Kopieren.Einf\195\188gen in einen Texteditor gut leserlich sind und am besten mit dem Zielfenster zusammen passen.\nBeispiel: /dmreport total f\n\nBeispiel: Dem Spieler 'dandelion' die ersten drei Leute in der Liste zufl\195\188stern:\n/dmreport w3 dandelion";
	DM_MSG_COLLECTORS		= "Datensammler: (%s)";
	DM_MSG_ACCUMULATING		= "SchadensAnzeiger: Sammle Daten im Speicherregister.";
	DM_MSG_REPORTTOTALDPS		= "Gesamt = %.1f (%.1f sichtbar)";
	DM_MSG_REPORTTOTAL		= "Gesamt = %d (%d sichtbar)";
	DM_MSG_SYNCMSG			= "[%s] sendet: %s";
	DM_MSG_MEMCLEAR			= "SchadensAnzeiger: Gespeicherte Tabelle gel\195\182scht.";
	DM_MSG_MAXBARS			= "SchadensAnzeiger: Maximale-Leisten-Anzeigen gesetzt auf %s.";
	DM_MSG_LEADERREPORTHEADER	= "SchadensAnzeiger: Anf\195\188hrer berichten %d/%d Quellen:\n #";
	DM_MSG_FULLREPORTHEADER		= "SchadensAnzeiger: Gesamtreport von %d/%d Quellen:\n\nSpieler        Schaden     Heilung     Schaden      Geheilt        Treffer   Kritisch\n_______________________________________________________________________________";

	-- Menu Options --
	DM_MENU_CLEAR			= "Alle Eintr\195\164ge l\195\182schen";
	DM_MENU_RESETPOS		= "Position zur\195\188cksetzen";
	DM_MENU_HIDE			= "Fenster verstecken";
	DM_MENU_SHOW			= "Fenster anzeigen";
	DM_MENU_VISINPARTY		= "Nur in einer Gruppe anzeigen";
	DM_MENU_REPORT			= "Berichten";
	DM_MENU_BARCOUNT		= "Leistenanzahl";
	DM_MENU_AUTOCOUNTLIMIT		= "Automatische Z\195\164hlgrenze ";
	DM_MENU_SORT			= "Sortierung";
	DM_MENU_VISIBLEQUANTITY		= "Sichtbare Anzeigen";
	DM_MENU_COLORSCHEME		= "Farbschema";
	DM_MENU_MEMORY			= "Speicher";
	DM_MENU_SAVE			= "Sichern";
	DM_MENU_RESTORE			= "Wiederherstellen";
	DM_MENU_MERGE			= "Verbinden";
	DM_MENU_SWAP			= "Tausch";
	DM_MENU_DELETE			= "L\195\182schen";
	DM_MENU_BAN			= "Verbannen";
	DM_MENU_CLEARABOVE		= "Oberhalb l\195\182schen";
	DM_MENU_CLEARBELOW		= "Unterhalb l\195\182schen";
	DM_MENU_LOCK			= "Liste fixieren";
	DM_MENU_UNLOCK			= "Liste freigeben";
	DM_MENU_PAUSE			= "Loganalyse anhalten";
	DM_MENU_UNPAUSE			= "Loganalyse fortsetzen";
	DM_MENU_LOCKPOS			= "Fenster fixieren";
	DM_MENU_UNLOCKPOS		= "Fenster freigeben";
	DM_MENU_GROUPMEMBERSONLY	= "Nur Gruppenmitglieder aufzeichnen";
	DM_MENU_ADDPETTOPLAYER		= "Begleiterdaten zum Besitzer z\195\164hlen";
	DM_MENU_TEXT			= "Text Optionen";
	DM_MENU_TEXTRANK		= "Rang";
	DM_MENU_TEXTNAME		= "Name";
	DM_MENU_TEXTPERCENTAGE		= "% von Insgesamt";
	DM_MENU_TEXTPERCENTAGELEADER	= "% des Anf\195\188hrers";
	DM_MENU_TEXTVALUE		= "Wert";
	DM_MENU_SETCOLORFORALL		= "Farbe f\195\188r alle setzen";
	DM_MENU_DEFAULTCOLORS		= "Standardfarbe wieder herstellen";
	DM_MENU_RESETONCOMBATSTARTS	= "Daten zur\195\188cksetzen wenn Kampf beginnt";
	DM_MENU_REFRESHBUTTON		= "Aktualisieren";
	DM_MENU_TOTAL			= "Gesamt";
	DM_MENU_CHOOSEREPORT		= "Bericht Ausw\195\164hlen";
	-- Note reordered this list in version 2.2.0
	DM_MENU_REPORTNAMES		= {"Konsole", "Sagen", "Gruppe", "Schlachtzug", "Gilde", "Fenster"};
	DM_MENU_TEXTCYCLE		= "Zyklisch";
	DM_MENU_QUANTCYCLE		= "Zyklisch";
	DM_MENU_HELP			= "Hilfe";
	DM_MENU_ACCUMULATEINMEMORY	= "Daten sammeln";
	DM_MENU_POSITION		= "Position";
	DM_MENU_RESIZELEFT		= "nach Links Gr\195\182\195\159e \195\164ndern";
	DM_MENU_RESIZEUP		= "nach Oben Gr\195\182\195\159e \195\164ndern";
	DM_MENU_SHOWMAX			= "Max anzeigen";
	DM_MENU_SHOWTOTAL		= "Gesamt anzeigen";
	DM_MENU_LEADERS			= "Anf\195\188hrer";

	-- Misc
	DM_CLASS			= "Klasse"; -- The word for player class, like Druid or Warrior.
	DM_TOOLTIP			= "Zeit seit der letzten Aktion = %.1fs\nBeziehung = %s";
	DM_YOU				= "Euch"
	DM_CRITSTR			= "Kritisch";


	--[[
	-------------------------------------------------------------------------------
	THIS IS WHERE COMBAT MESSAGES GET PARSED
	-------------------------------------------------------------------------------

	Notes:
	- Using %a+ for player names is very risk as totems are pets and have spaces in their names.
	- Leave .'s off the end as a rule to save us from having to put in (%d absorbed) cases.

	-----------------
	THE EVENT MATRIX:
	-----------------
						(S)Self		(E)Pet		(P)Party		(F)Friendly
	01 Hit				x			x			x				x
	02 Crit				x			x			0				x
	03 Spell			x			x			x				x
	04 SpellCrit		x			x			x				x
	05 Dot				x			A			A				A
	06 DmgShield		x			B			B				B
	07 SplitDmg						0			0				0

	10 IncHit			x			x			x				x
	11 IncCrit			x			x			x				x
	12 IncSpell			x			x			x				x
	13 IncSpellCrit		x			0			x				x
	14 IncDot			x			x			x				x

	20 Heal				x			0			x				x
	21 HealCrit			x			0			x				x
	22 Hot				x			0			x				x
	23 NDB				-			0			0				x
	24 JD				-			0			0				0


	x : Confirmed
	0 : Case exists, but unconfirmed.
	- : Irrelevant.
	A - Ambiguous: Dots messages come from the creature being hit, not the player.
	B - Damage shield messags are only self and "other".
	NDB - "Night Dragon's Blossom" : English special-case because of the "'s".
	JD - "Julie's Dagger" : English special-case because of the "'s".

	]]--

	function DamageMeters_ParseMessage(arg1, event)
		local creatureName;
		local damage;
		local spell;
		local spell2;
		local petName;
		local partialBlock;
		local damageType;

		---------------------
		-- DAMAGE MESSAGES --
		---------------------
		if ( event == "CHAT_MSG_COMBAT_SELF_HITS" ) then
			for creatureName, damage in string.gfind(arg1, "Ihr trefft (.+). Schaden: (%d+).") do
				DM_CountMsg(arg1, "S01 Self Hit", event);
				DamageMeters_AddDamage(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
				return;
			end
			for creatureName, damage in string.gfind(arg1, "Ihr trefft (.+) kritisch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "S02 Self Crit", event);
				DamageMeters_AddDamage(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
				return;
			end
		end

		if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" )then
			for spell, creatureName, damage in string.gfind(arg1, "(.+) von Euch trifft (.+) f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "S03 Self Spell Hit", event);
				DamageMeters_AddDamage(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
				return;
			end
			for spell, creatureName, damage in string.gfind(arg1, "(.+) trifft (.+) kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "S04 Self Spell Crit", event);
				DamageMeters_AddDamage(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
				return;
			end
		end

		if ( event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" ) then	
			for creatureName, damage, damageType, spell in string.gfind(arg1, "(.+) erleidet (%d+) (.+)schaden %(durch (.+)%).") do
				DM_CountMsg(arg1, "S05 Self DOT", event);
				DamageMeters_AddDamage(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
				return;
			end		
			for creatureName, damage, damageType, playerName, spell in string.gfind(arg1, "(.+) erleidet (%d+) (.+)schaden von (.+) (durch (.+)).") do
				DM_CountMsg(arg1, "F05 Friendly DOT", event);
				DamageMeters_AddDamage(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
		end

		if (event == "CHAT_MSG_COMBAT_PARTY_HITS" or
			event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS" or
			event == "CHAT_MSG_COMBAT_PET_HITS") then

			local relationship = DamageMeters_Relation_PARTY;
			local relationshipName = "P";
			if (event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS") then
				relationship = DamageMeters_Relation_FRIENDLY;
				relationshipName = "F";
			elseif (event == "CHAT_MSG_COMBAT_PET_HITS") then
				relationship = DamageMeters_Relation_PET;
				relationshipName = "E";
			end
				
			for playerName, creatureName, damage in string.gfind(arg1, "(.+) trifft (.+). f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, relationshipName.."01 Hit", event);
				DamageMeters_AddDamage(playerName, damage, DM_HIT, relationship, "[Melee]");
				return;
			end
			for playerName, creatureName, damage in string.gfind(arg1,  "(.+) trifft (.+) kritisch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, relationshipName.."02 Crit", event);
				DamageMeters_AddDamage(playerName, damage, DM_CRIT, relationship, "[Melee]");
				return;
			end
		end

		if (event == "CHAT_MSG_SPELL_PARTY_DAMAGE" or
			event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE" or
			event == "CHAT_MSG_SPELL_PET_DAMAGE") then

			local relationship = DamageMeters_Relation_PARTY;
			local relationshipName = "P";
			if (event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE") then
				relationship = DamageMeters_Relation_FRIENDLY;
				relationshipName = "F";
			elseif (event == "CHAT_MSG_SPELL_PET_DAMAGE") then
				relationship = DamageMeters_Relation_PET;
				relationshipName = "E";
			end

			for playerName, spell, creatureName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) f\195\188r (%d+) Schaden.") do		
				DM_CountMsg(arg1, relationshipName.."03 Spell", event);
				DamageMeters_AddDamage(playerName, damage, DM_HIT, relationship, spell);
				return;
			end
			for playerName, spell, creatureName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) kritisch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, relationshipName.."04 SpellCrit", event);
				DamageMeters_AddDamage(playerName, damage, DM_CRIT, relationship, spell);
				return;
			end

			-- For soul link
			-- SPELLSPLITDAMAGEOTHEROTHER
			--! todo SPELLSPLITDAMAGEOTHERSELF
			--! todo SPELLSPLITDAMAGESELFOTHER
			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) verursacht (.+) (%d+) Schaden") do
				DM_CountMsg(arg1, relationshipName.."07 SplitDmg", event);
				DamageMeters_AddDamage(playerName, damage, DM_DOT, relationship, spell);
				return;
			end
		end

		-- Damage Shields --
		if (event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF") then
			for damage, damageType, creatureName in string.gfind(arg1, "Ihr reflektiert (%d+) (.+)schaden auf (.+).") do
				DM_CountMsg(arg1, "S06 DmgShield", event);
				DamageMeters_AddDamage(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, "[DmgShield]");
				return;
			end
		end
		if (event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS") then
			for playerName, damage, damageType, creatureName in string.gfind(arg1, "(.+) reflektiert (%d+) (.+)schaden auf (.+).") do
				DM_CountMsg(arg1, "F06 DmgShield", event);
				DamageMeters_AddDamage(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, "[DmgShield]");
				return;
			end
		end

		------------------------------
		-- DAMAGE-RECEIVED MESSAGES --
		------------------------------
		-- TODO: Reflected spells.  "you are affected by YOUR spell."
		if (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS") then
			for creatureName, damage in string.gfind(arg1, "(.+) trifft Euch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "S10 IncHit", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
				return;
			end
			for creatureName, damage in string.gfind(arg1, "(.+) trifft Euch kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "S11 IncCrit", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
				return;
			end

			-- These are for your pet:
			for creatureName, playerName, damage in string.gfind(arg1, "(.+) trifft (.+). f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "E10 IncHit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PET, "[Melee]");
				return;
			end
			for creatureName, playerName, damage in string.gfind(arg1, "(.+) trifft (.+) kritisch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "E11 IncCrit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PET, "[Melee]");
				return;
			end
		end

		if (event == "CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS") then
			for creatureName, playerName, damage in string.gfind(arg1, "(.+) trifft (.+). f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "P10 IncHit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PARTY, "[Melee]");
				return;
			end
			for creatureName, playerName, damage in string.gfind(arg1, "(.+) trifft (.+) kritisch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "P11 IncCrit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PARTY, "[Melee]");
				return;
			end
		end
		if (event == "CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS" or
			event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS") then
			for creatureName, damage in string.gfind(arg1, "(.+) trifft Euch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "S10 IncHit PVP", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
				return;
			end
			for creatureName, damage in string.gfind(arg1,  "(.+) trifft Euch kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "S11 IncCrit PVP", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
				return;
			end

			for creatureName, playerName, damage in string.gfind(arg1, "(.+) trifft (.+). f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "F10 IncHit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, "[Melee]");
				return;
			end
			for creatureName, playerName, damage in string.gfind(arg1, "(.+) trifft (.+) kritisch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "F11 IncCrit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, "[Melee]");
				return;
			end
		end

		if (event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE") then
			for creatureName, spell, damage in string.gfind(arg1, "(.+)s (.+) trifft Euch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "S12 IncSpell", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
				return;
			end
			for creatureName, spell, damage in string.gfind(arg1, "(.+)s (.+) trifft Euch kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "S13 IncSpellCrit", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
				return;
			end

			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "E12 IncSpell", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PET, spell);
				return;
			end
			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "E13 IncSpellCrit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PET, spell);
				return;
			end
		end
		
		if (event == "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") then
			for creatureName, spell, playerName, damage in string.gfind(arg1,  "(.+)s (.+) trifft (.+) f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "P12 IncSpell", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PARTY, spell);
				return;
			end
			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "P13 IncSpellCrit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PARTY, spell);
				return;
			end
		end

		if (event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") then
				for creatureName, spell, playerName, damage in string.gfind(arg1,  "(.+)s (.+) trifft (.+) f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "F12 IncSpell", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "F13 IncSpellCrit", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
		end

		if (event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE") then
			for creatureName, spell, damage in string.gfind(arg1, "(.+)s (.+) trifft Euch f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "S12 IncSpell PVP", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
				return;
			end
			for creatureName, spell, damage in string.gfind(arg1, "(.+)s (.+) trifft Euch kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "S13 IncSpellCrit PVP", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
				return;
			end

			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) f\195\188r (%d+) Schaden.") do
				DM_CountMsg(arg1, "F12 IncSpell PVP", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)s (.+) trifft (.+) kritisch. Schaden: (%d+).") do
				DM_CountMsg(arg1, "F13 IncSpellCrit PVP", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
		end

		-- Periodic.
		if (event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE") then
			for damage, damageType, creatureName, spell in string.gfind(arg1, "Ihr erleidet (%d+) (.+)schaden von (.+) (durch (.+)).") do
				DM_CountMsg(arg1, "S14 IncDot", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
				return;
			end

			-- For reflected dots: 
			for damage, damageType, creatureName, spell in string.gfind(arg1, "Ihr erleidet (%d+) (.+)schaden durch Euer (.+).") do
				DM_CountMsg(arg1, "S14 IncDot", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
				return;
			end

			-- Pet
			for playerName, damage, damageType, creatureName, spell in string.gfind(arg1, "(.+) erleidet (%d+) (.+)schaden von (.+) (durch (.+)).") do
				DM_CountMsg(arg1, "E14 IncDot", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_PET, spell);
				return;
			end
		end
		if (event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE") then
			for playerName, damage, damageType, creatureName, spell in string.gfind(arg1, "(.+) erleidet (%d+) (.+)schaden von (.+) (durch (.+)).") do
				DM_CountMsg(arg1, "P14 IncDot", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_DOT, DamageMeters_Relation_PARTY, spell);
				return;
			end
		end
		if (event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" or
			event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") then
			-- For pvp.
			for damage, damageType, creatureName, spell in string.gfind(arg1, "Ihr erleidet (%d+) (.+)schaden von (.+) (durch (.+)).") do
				DM_CountMsg(arg1, "S14 IncDot PVP", event);
				DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
				return;
			end

			for playerName, damage, damageType, creatureName, spell in string.gfind(arg1, "(.+) erleidet (%d+) (.+)schaden von (.+)s (durch (.+)).") do
				DM_CountMsg(arg1, "F14 IncDot", event);
				DamageMeters_AddDamageReceived(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end

			--! This happens in bg right after you die.
			--! "Bob takes 100 Arcane damage from your Moonfire."
		end

		----------------------
		-- HEALING MESSAGES --
		----------------------

		-- NOTE: There is a kind of bug here--we cannot tell the relationship of the 
		-- healer from the message, so if the group filter is on healing pets (healing totems particularly)
		-- won't be added into the list until some other quantity puts them in.
		-- NOTE: Inexplicably, HOSTILEPLAYER_BUFF messages report for party members.
		-- Note: In English, the following things require special healing cases:
		-- Night Dragon's Breath, Julie's Dagger.

		for playerName, spell, creatureName, damage in string.gfind(arg1, "Besondere Heilung: (.+)s (.+) heilt (.+) um (%d+) Punkte.") do
				DM_CountMsg(arg1, "Other's Critical Heal");
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(playerName, creatureName, damage, DamageMeters_Relation_FRIENDLY);
				return;
			end
			for spell, creatureName, damage in string.gfind(arg1, "Besondere Heilung: (.+) heilt (.+)  um (%d+) Punkte.") do
				DM_CountMsg(arg1, "Self Crit Heal");
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DamageMeters_Relation_SELF);
				return;
			end


		if (event == "CHAT_MSG_SPELL_SELF_BUFF" or
			event == "CHAT_MSG_SPELL_PARTY_BUFF" or
			event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF" or
			event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"
			) then

			for spell, creatureName, damage in string.gfind(arg1, "Besondere Heilung: Euer (.+) heilt (.+) um (%d+) Punkte.") do
				DM_CountMsg(arg1, "S21 HealCrit", event);
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
				return;
			end
			for spell, creatureName, damage in string.gfind(arg1, "Euer (.+) heilt (.+) um (%d+) Punkte.") do
				DM_CountMsg(arg1, "S20 Heal", event);
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_HIT, DamageMeters_Relation_SELF, spell);
				return;
			end
			for playerName, spell, creatureName, damage in string.gfind(arg1, "Besondere Heilung: (.+)s (.+) heilt (.+) um (%d+) Punkte.") do
				DM_CountMsg(arg1, "F21 HealCrit", event);
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(playerName, creatureName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end

			-- English-only special cases. (Assuming these effects cannot crit.)
			for playerName, creatureName, damage in string.gfind(arg1, "(.+)'s Night Dragon's Breath heals (.+) for (%d+)") do
				spell = "Other's Night Dragon's Breath";
				DM_CountMsg(arg1, "F23 NDB", event);
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
			for playerName, creatureName, damage in string.gfind(arg1, "(.+)'s Julie's Dagger heals (.+) for (%d+)") do
				spell = "Julie's Dagger";
				DM_CountMsg(arg1, "F24 JD", event);
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end

			for playerName, spell, creatureName, damage in string.gfind(arg1, "(.+)s (.+) heilt (.+) um (%d+) Punkte.") do
				DM_CountMsg(arg1, "F20 Heal", event);
				if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
				DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
		end

		if (event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or
			event == "CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS" or
			event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS" or
			event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" -- why?
			) then

			for damage, playerName, spell in string.gfind(arg1, "Ihr erhaltet (%d+) Gesundheit von (.+) (durch (.+)).") do
				DM_CountMsg(arg1, "F22 Hot2", event);
				DamageMeters_AddHealing(playerName, UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
			for damage, spell in string.gfind(arg1, "Ihr erhaltet (%d+) Gesundheit durch (.+).") do
				DM_CountMsg(arg1, "S22 Hot1", event);
				DamageMeters_AddHealing(UnitName("Player"), UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
				return;
			end
			for creatureName, damage, spell in string.gfind(arg1, "(.+) erh\195\164lt (%d+) Gesundheit durch (.+).") do		
				DM_CountMsg(arg1, "S22 Hot2", event);
				DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_DOT, DamageMeters_Relation_SELF, spell);
				return;
			end
			for creatureName, damage, playerName, spell in string.gfind(arg1, "(.+) erh\195\164lt (%d+) Gesundheit von (.+)s (.+).") do
				DM_CountMsg(arg1, "F22 Hot2", event);
				DamageMeters_AddHealing(playerName, creatureName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
				return;
			end
		end
		----------------------

		-- Check the message to see if it is the kind of thing we should have caught.
		if (DamageMeters_enableDebugPrint and arg1) then
			local sub = string.sub(event, 1, 8);
			if (sub == "CHAT_MSG") then			
				-- We only care about messages with numbers in them.
				for amount in string.gfind(arg1, "(%d+)") do

					--DMPrint("UNPARSED NUMERIC ["..event.."] : "..arg1);

					-- GENERICPOWERGAIN_OTHER
					-- GENERICPOWERGAIN_SELF
					for player, amount, type in string.gfind(arg1, "(.+) erh\195\164lt (%d+) (.+).") do return; end
					for player, amount, type in string.gfind(arg1, "Ihr erhaltet (%d+) (.+).") do return; end
					for player, amount, type in string.gfind(arg1, "(.+) bekommt (%d+) (.+).") do return; end
					for player, amount, type in string.gfind(arg1, "Ihr bekommt (%d+) (.+).") do return; end
					-- SPELLEXTRAATTACKSOTHER_SINGULAR etc
					if (string.find(arg1, "Extra-Angriffe")) then return; end
					-- ITEMENCHANTMENTADDOTHEROTHER, etc
					for player in string.gfind(arg1, "(.+) wirkt (.+) auf (.+)'s (.+).") do return; end
					for player in string.gfind(arg1, "(.+) wirkt (.+) auf Euer (.+).") do return; end
					for player in string.gfind(arg1, "Ihr wirkt (.+) auf (.+)'s (.+).") do return; end
					for player in string.gfind(arg1, "Ihr wirkt (.+) auf Euer (.+).") do return; end
					-- VSENVIRONMENTALDAMAGE_DROWNING_OTHER etc.
					for player in string.gfind(arg1, "(.+) ertrinkt und verliert (%d+) Gesundheit.") do return; end
					for player in string.gfind(arg1, "Ihr ertrinkt und verliert (%d+) Gesundheit.") do return; end
					for player in string.gfind(arg1, "(.+) f\195\164llt und verliert (%d+) Gesundheit.") do return; end
					for player in string.gfind(arg1, "Ihr fallt und verliert (%d+) Gesundheit.") do return; end
					for player in string.gfind(arg1, "(.+) ist ersch\195\182pft und verliert (%d+) Gesundheit.") do return; end
					for player in string.gfind(arg1, "Ihr seid ersch\195\182pft und verliert (%d+) Gesundheit.") do return; end
					for player in string.gfind(arg1, "(.+) verliert (%d+) Punkte aufgrund von Feuerschaden.") do return; end
					for player in string.gfind(arg1, "Ihr verliert (%d+) Punkte aufgrund von Feuerschaden.") do return; end
					for player in string.gfind(arg1, "(.+) verliert (%d+) Gesundheit wegen Schwimmens in (.+).") do return; end
					for player in string.gfind(arg1, "Ihr verliert (%d+) Gesundheit durch Ber\195\188hrung mit Lava.") do return; end
					for player in string.gfind(arg1, "Ihr verliert (%d+) Gesundheit wegen Schwimmens in (.+).") do return; end
					-- SPELLPOWERDRAINOTHEROTHER etc
					for player in string.gfind(arg1, "(.+) entzieht (%d+) Mana von Euch.") do return; end
					for player in string.gfind(arg1, "(.+) entzieht (%d+) Mana von (.+).") do return; end
					for player in string.gfind(arg1, "Ihr entzieht (%d+) Mana von (.+).") do return; end
					for player in string.gfind(arg1, "(.+) entzieht (%d+) Mana von Euch und bekommt (%d+).") do return; end
					for player in string.gfind(arg1, "Ihr entzieht (%d+) Mana von (.+) und bekommt (%d+).") do return; end


					-- blah casts field repair bot 74a
					-- blah begins to cast armor +40
					---------------

					DMPrint("Numerische Nachricht verpasst! ["..event.."]");
					DMPrint(arg1);
					return;
				end
			end
		end
	end

end