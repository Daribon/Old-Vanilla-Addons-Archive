--[[
--	BuffOptions Localization
--		"Germanh Localization"
--	
--	English By: StarDust
--	Contact: -
--	
--	$Id: localization.de.lua 2479 2005-09-26 12:50:44Z stardust$
--	$Rev: 2540 $
--	$LastChangedBy: stardust $
--	$Date: 2005-09-29 03:56:10 -0500 (Thu, 29 Sep 2005) $
--]]

if ( GetLocale() == "deDE" ) then
	--------------------------------------------------
	--
	-- UI Strings
	--
	--------------------------------------------------
	BUFFOPTIONS_CONFIG_SECTION		= "Buff Optionen";
	BUFFOPTIONS_CONFIG_SECTION_INFO		= "Erlaubt es das Aussehen und die Position der eigenen Buffs zu ver\195\164ndern.";
	BUFFOPTIONS_CONFIG_MAIN_HEADER		= "Allgemeine Optionen";
	BUFFOPTIONS_CONFIG_MAIN_HEADER_INFO	= "Allgemeine Einstellungen zur Buffanzeige.";
	BUFFOPTIONS_CONFIG_REVERSE		= "Anordung umkehren";
	BUFFOPTIONS_CONFIG_REVERSE_INFO		= "Wenn aktiviert, wird die Anordnung der angezeigten Buffs umgekehrt.";
	BUFFOPTIONS_CONFIG_SWAP			= "Position der Buffs/Debuffs tauschen";
	BUFFOPTIONS_CONFIG_SWAP_INFO		= "Wenn aktiviert, wird die Position der angezeigten Buffs und Debuffs vertauscht.";
	BUFFOPTIONS_CONFIG_BORDER		= "Rahmen anzeigen";
	BUFFOPTIONS_CONFIG_BORDER_INFO		= "Wenn aktiviert, wird rund um jeden Buff ein Hintergrund mit Rahmen angezeigt.";
	BUFFOPTIONS_CONFIG_SIZE			= "Buff Gr\195\182\195\159e";
	BUFFOPTIONS_CONFIG_SIZE_INFO		= "Erlaubt es die Gr\195\182\195\159e der angezeigten Buffs einzustellen.";
	BUFFOPTIONS_CONFIG_SIZE_TEXT		= "Gr\195\182\195\159e";
	BUFFOPTIONS_CONFIG_SIZE_SUFFIX		= "%";
	BUFFOPTIONS_CONFIG_VERTICAL_HEADER	= "Vertikale Optionen";
	BUFFOPTIONS_CONFIG_VERTICAL_HEADER_INFO = "Optionen, welche nur die Darstellung der Buffs in vertikaler Anordnung betreffen.";
	BUFFOPTIONS_CONFIG_VERTICAL		= "Buffs vertikal anordnen";
	BUFFOPTIONS_CONFIG_VERTICAL_INFO	= "Wenn aktiviert, werden angezeigte Buffs vertikal (von oben nach unten) anstatt von rechts nach links angeordnet.";
	BUFFOPTIONS_CONFIG_SIDETIME		= "Verbleibende Zeit daneben anzeigen";
	BUFFOPTIONS_CONFIG_SIDETIME_INFO	= "Wenn aktiviert, wird die noch verbleibende Zeit rechts neben dem jeweiligen Buff angezeigt und nicht darunter.";
	BUFFOPTIONS_CONFIG_TEXT			= "Buffname anzeigen";
	BUFFOPTIONS_CONFIG_TEXT_INFO		= "Wenn aktiviert, wird der Name des Buff rechts neben dem jeweiligen Bufficon mit angezeigt.";
	BUFFOPTIONS_CONFIG_DEBUFFTYPE		= "Debuff Typ anzeigen";
	BUFFOPTIONS_CONFIG_DEBUFFTYPE_INFO	= "Wenn aktiviert, wird neben dem Debuff dessen Typ angezeigt und nicht dessen Name.";
	BUFFOPTIONS_CONFIG_NORIGHT		= "Buffs nicht nach rechts verschieben";
	BUFFOPTIONS_CONFIG_NORIGHT_INFO		= "Wenn aktiviert, werden die Bufficons bei der vertikalen Anordnung nicht auf die rechte Seite des Bildschirms verschoben.";
	BUFFOPTIONS_CONFIG_TEXT_HEADER		= "Bufftext Optionen";
	BUFFOPTIONS_CONFIG_TEXT_HEADER_INFO	= "Erlaubt es den Text der eigenen Buffs zu ver\195\164ndern.";
	BUFFOPTIONS_CONFIG_LONGTIME		= "Langes Zeitformat verwenden";
	BUFFOPTIONS_CONFIG_LONGTIME_INFO	= "Wenn aktiviert, wird die noch verbleibende Zeit im langen Zeitformat angezeigt, wie z.B. '29 Minuten 14 Sekunden'";
	BUFFOPTIONS_CONFIG_SHORTTIME		= "Kurzes Zeitformat verwenden";
	BUFFOPTIONS_CONFIG_SHORTTIME_INFO	= "Wenn aktiviert, wird die noch verbleibende Zeit im kurzen Zeitformat angezeigt, wie z.B. '29:14'";
	BUFFOPTIONS_CONFIG_FADETIME		= "Verbleibende Zeit blinkend";
	BUFFOPTIONS_CONFIG_FADETIME_INFO	= "Wenn aktiviert, blinkt die noch verbleibende Zeit zusammen mit dem Bufficon wenn jener bald schwindet.";
	BUFFOPTIONS_CONFIG_TEXTCOLOR		= "Textfarbe";
	BUFFOPTIONS_CONFIG_TEXTCOLOR_INFO	= "Legt die Farbe des Textes f\195\188r den Buffnamen und die noch verbleibende Zeit fest.";
	BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR	= "Textfarbe beim Schwinden";
	BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR_INFO	= "Legt die Farbe des Textes f\195\188r den Buffnamen und die noch verbleibende Zeit fest wenn jener bald schwindet.";
	BUFFOPTIONS_CONFIG_TEXTSIZE		= "Textgr\195\182\195\159e";
	BUFFOPTIONS_CONFIG_TEXTSIZE_INFO	= "Legt die Gr\195\182\195\159e des Textes f\195\188r den Buffnamen und die noch verbleibende Zeit fest.";
	BUFFOPTIONS_CONFIG_TEXTSIZE_TEXT	= "Gr\195\182\195\159e";
	BUFFOPTIONS_CONFIG_TEXTSIZE_SUFFIX	= "%";
	BUFFOPTIONS_CONFIG_REMINDER_HEADER	= "Erinnerung Optionen";
	BUFFOPTIONS_CONFIG_REMINDER_HEADER_INFO	= "Optionen, welche die Erinnerungsfunktion der Buffs betreffen, wenn jene bald schwinden.";
	BUFFOPTIONS_CONFIG_REMINDER		= "Buff Erinnerung aktivieren";
	BUFFOPTIONS_CONFIG_REMINDER_INFO	= "Wenn aktiviert, wirst du durch einen Alarm daran erinnert wenn ein Buff bald schwindet.";
	BUFFOPTIONS_CONFIG_REMINDER_TEXT	= "Warnzeit";
	BUFFOPTIONS_CONFIG_REMINDER_SUFFIX	= " Sek.";
	BUFFOPTIONS_CONFIG_REMINDERSOUND	= "Akustische Erinnerung";
	BUFFOPTIONS_CONFIG_REMINDERSOUND_INFO	= "Wenn aktiviert, wird ein Sound wiedergegeben sobald die Warnzeit erreicht wird.";
	BUFFOPTIONS_CONFIG_REMINDERCOLOR	= "Farbe des Erinnerungstextes";
	BUFFOPTIONS_CONFIG_REMINDERCOLOR_INFO	= "Legt die Farbe des Erinnerungstextes fest.";
	BUFFOPTIONS_CONFIG_REMINDEROSD		= "OSD Erinnerung";
	BUFFOPTIONS_CONFIG_REMINDEROSD_INFO	= "Wenn aktiviert, wird der Erinnerungstext in der Mitte des Bildschirms angezeigt und nicht im Chatfenster.";
	BUFFOPTIONS_CONFIG_EQUIPMENTONLY	= "Nur Ausr\195\188stung ber\195\188cksichtigen";
	BUFFOPTIONS_CONFIG_EQUIPMENTONLY_INFO	= "Wenn aktiviert, werden nur Buffs auf Ausr\195\188stungsgegenst\195\164nde f\195\188r die Erinnerung ber\195\188cksichtigt.";
	BUFFOPTIONS_CONFIG_NOSHORT		= "Mindest-Buffzeit f\195\188r Erinnerung";
	BUFFOPTIONS_CONFIG_NOSHORT_INFO		= "Wenn aktiviert, werden nur Buffs die l\195\164nger als die angegebene Zeit halten f\195\188r die Erinnerung ber\195\188cksichtigt.";
	BUFFOPTIONS_CONFIG_NOSHORT_TEXT		= "Minimum Time";
	BUFFOPTIONS_CONFIG_NOSHORT_SUFFIX	= " Sek.";

	--------------------------------------------------
	--
	-- Weapon Buff Strings
	--
	--------------------------------------------------
	--The search string for finding the line with the number of charges in a tooltip
	BUFFOPTIONS_CHARGE_STRINGS = {
		"%d+ Aufladungen",
		"%d+ Aufladung"
	};
	--The search string for finding the line with the enchant name in a tooltip
	BUFFOPTIONS_ENCHANT_STRINGS = {
		".+ %(%d+ "..string.lower(DAYS_ABBR).."%)",
		".+ %(%d+ "..string.lower(DAYS_ABBR_P1).."%)",
		".+ %(%d+ "..string.lower(HOURS_ABBR_P1).."%)",
		".+ %(%d+ "..string.lower(DAYS_ABBR_P1).."%)",
		".+ %(%d+ "..string.lower(MINUTES_ABBR).."%)",
		".+ %(%d+ "..string.lower(SECONDS_ABBR).."%)",
	};
	--The string to parse out the number of charges from a tooltip
	BUFFOPTIONS_CHARGE = "%((%d+) Aufladung";
	--The string to parse out the name of the enchant from a tooltip
	BUFFOPTIONS_ENCHANT = "(.+) %(";
	--Strings for displaying the name and number of charges on a weapon
	BUFFOPTIONS_WEAPONBUFF = "%s";
	BUFFOPTIONS_WEAPONBUFF_CHARGE = "%s (%s)";
	--If this is defined it will be used instead of BUFFOPTIONS_WEAPONBUFF_CHARGE,
	--and the charge will be the first variable and buff name the second
	--BUFFOPTIONS_CHARGE_WEAPONBUFF = "(%s) %s";

	--------------------------------------------------
	--
	-- Other Strings
	--
	--------------------------------------------------
	BUFFOPTIONS_EXPIRESOON		= "- %s schwindet bald -";
	BUFFOPTIONS_EXPIRESOON_ENCHANT	= "- der Buff auf %s schwindet bald -"

	--------------------------------------------------
	--
	-- Help Text
	--
	--------------------------------------------------
	BUFFOPTIONS_CONFIG_INFOTEXT = {
		"[NOTE: If you are using Khaos, you may not be "..
		"seeing all of the options available.  For more "..
		"advanced options, increase the difficulty setting.]\n"..
		"\n"..
		"  BuffOptions is an addon that allows you to "..
		"customize the display and behavior of your buffs.\n\n"..
		"It allows you to stack your buffs vertically,  "..
		"reverse them, swap their position with the debuffs, "..
		"show reminders when a buff is about to expire, and more.\n\n"..
		"Options Explaination:\n"..
		BUFFOPTIONS_CONFIG_REVERSE.." - "..BUFFOPTIONS_CONFIG_REVERSE_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_SWAP.." - "..BUFFOPTIONS_CONFIG_SWAP_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_BORDER.." - "..BUFFOPTIONS_CONFIG_BORDER_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_SIZE.." - "..BUFFOPTIONS_CONFIG_SIZE_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_SIDETIME.." - "..BUFFOPTIONS_CONFIG_SIDETIME_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_TEXT.." - "..BUFFOPTIONS_CONFIG_TEXT_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_DEBUFFTYPE.." - "..BUFFOPTIONS_CONFIG_DEBUFFTYPE_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_NORIGHT.." - "..BUFFOPTIONS_CONFIG_NORIGHT_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_LONGTIME.." - "..BUFFOPTIONS_CONFIG_LONGTIME_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_SHORTTIME.." - "..BUFFOPTIONS_CONFIG_SHORTTIME_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_FADETIME.." - "..BUFFOPTIONS_CONFIG_FADETIME_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_TEXTCOLOR.." - "..BUFFOPTIONS_CONFIG_TEXTCOLOR_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_TEXTSIZE.." - "..BUFFOPTIONS_CONFIG_TEXTSIZE_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_REMINDER.." - "..BUFFOPTIONS_CONFIG_REMINDER_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_REMINDERCOLOR.." - "..BUFFOPTIONS_CONFIG_REMINDERCOLOR_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_REMINDEROSD.." - "..BUFFOPTIONS_CONFIG_REMINDEROSD_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_EQUIPMENTONLY.." - "..BUFFOPTIONS_CONFIG_EQUIPMENTONLY_INFO.."\n\n"..
		BUFFOPTIONS_CONFIG_NOSHORT.." - "..BUFFOPTIONS_CONFIG_NOSHORT_INFO.."\n\n"..
		"\n"..
		"See page 3 for a list of slash commands.",
		
		"Buff Options\n"..
		"\n"..
		"By: Mugendai\n"..
		"Special Thanks:\n"..
		"    GotMoo - For MooBuffMod, the inspiration for most buff mods\n\n"..
		"    Zespri - For many ideas, and testing, and more\n\n"..
		"Contact: mugekun@gmail.com"
	};

end