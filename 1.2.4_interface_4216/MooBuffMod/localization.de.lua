-- Version : German (by pc, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Cosmos Configuration
	MBM_SEP				= "Buff-Anzeige";
	MBM_SEP_INFO			= "Erm\195\182glicht es die Anzeige der Buffs, die auf einen selbst wirken, zu ver\195\164ndern.";
	MBM_CHECK			= "Verbesserte Buff-Anzeige verwenden";
	MBM_CHECK_INFO			= "Wenn aktiviert, wird die verbesserte Buff-Anzeige verwendet.";

	MBM_SHOW_NAMES			= "Name des Buffs anzeigen";
	MBM_SHOW_NAMES_INFO		= "Wenn aktiviert, wird neben dem Icon der volle Name des jeweiligen Buffs mit angezeigt. Da jene mitunter lange sind wird die vertikale Anzeige des Namens neben dem jeweiligen Buff erzwungen.";

	MBM_VERTICAL			= "Buffs vertikal anzeigen";
	MBM_VERTICAL_INFO		= "Wenn aktiviert, werden die Buffs vertikal und nicht mehr horizontal aufgelistet. Diese Option wird erzwungen, wenn 'Name des Buffs anzeigen' aktiviert ist.";

	MBM_TEXT_BELOW			= "Verbleibende Zeit nicht als Text anzeigen";
	MBM_TEXT_BELOW_INFO		= "Wenn aktiviert, wird unter dem jeweiligen Buff die noch verbleibende Zeit nicht als Text sondern im MM:SS Format angezeigt. Wenn nicht aktiviert, wird die vertikale Auflistung der Buffs erzwungen.";

	MBM_NORMAL_MODE			= "Original Modus verwenden";
	MBM_NORMAL_MODE_INFO		= "Wenn aktiviert, wird die Buff-Anzeige wie standardm\195\164\195\159ig in World of Warcraft angezeigt.";

	MBM_NEW_MODE			= "Neuen Modus verwenden";
	MBM_NEW_MODE_INFO		= "Wenn aktiviert, wird die Buff-Anzeige im neuen, vertikalen Modus angezeigt.";

	MBM_TIME_SHORT			= "Kurzes Zeitformat benutzen";
	MBM_TIME_SHORT_INFO		= "Wenn aktiviert, wird das k\195\188rzere MM:SS Zeitformat bei der Anzeige verwendet und nicht MM Minuten oder SS Sekunden.";

	MBM_NAME_SHORT			= "Kurze Buff-Namen verwenden";
	MBM_NAME_SHORT_INFO		= "Wenn aktiviert, wird versucht die Namen der jeweiligen Buffs zu verk\195\188rzen. Experimentell! Nur ein paar wenige Buffs sind bis jetzt verf\195\188gbar.";

	MBM_UNDER_MINIMAP		= "Buffs unterhalb der MiniMap anzeigen";
	MBM_UNDER_MINIMAP_INFO		= "Wenn aktiviert, werden die Buffs unterhalb der MiniMap aufgelistet.";

	MBM_NORMAL_MODE_NAME		= "Festlegen";
	MBM_NEW_MODE_NAME		= "Festlegen";

	MBM_TIME_MINUTES                = " Minuten";
	MBM_TIME_MINUTE                 = " Minute";
	MBM_TIME_SECONDS                = " Sekunden";
	MBM_TIME_SECOND                 = " Sekunde";

	-- Localisation Strings
	MooBuffButton_ShorterBuffNames = {
		["Machtwort"]				= "MW",
		["entdecken"]				= "ent.",
		["Unsichtbarkeit"]			= "Uns.",
		["Siegel des Furors"]			= "Furor (Si)",	-- ?
		["Siegel des Schutzes"]			= "Schutz (Si)", 
		["Seal of Reckoning"]			= "Reckoning (S)", 	--?
		["Siegel der Rechtschaffenheit"]	= "Rechtschaffenheit (Si)", 
		["Siegel der Rettung"]			= "Rettung (Si)",
		["Siegel der Freiheit"]			= "Freiheit (Si)",
		["Siegel der Gerechtigkeit"]		= "Gerechtigkeit (Si)",
		["Siegel des Kreuzfahrers"]		= "Kreuzfahrer (Si)",
		["Siegel des Befehls"]			= "Befehl (Si)",
	
		["Segen des Furors"]			= "Furor (Se)", -- ?
		["Segen des Lichts"]			= "Licht (Se)", 
		["Segen der Könige"]			= "Könige (Se)", 
		["Segen des Schutzes"]			= "Schutz (Se)", 
		["Blessing of Reckoning"]		= "Reckoning (B)", 	-- ?
		["Segen der Rechtschaffenheit"]		= "Rechtschaffenheit (Se)",	
		["Segen der Rettung"]			= "Rettung (Se)",
		["Segen der Freiheit"]			= "Freiheit (Se)",
	
		["Leinenverband"]			= "Leinenv.",
		["Schwerer Leinenverband"]		= "Schw Leinenv.",
		["Wollverband"]				= "Wollv.",
		["Schwerer Wollverband"]		= "Schw Wollv.",
		["Silk Bandage"]			= "Silk B.",	-- ?
		["Heavy Silk Bandage"]			= "Hvy Silk B.",	-- ?
		["Mageweave Bandage"]			= "Mageweave B.", -- ? 
		["Heavy Mageweave Bandage"]		= "Hvy Mageweave B.", -- ?
		["Anti-Venom"]				= "Anti-Venom",	-- ?
		["Strong Anti-Venom"]			= "Strong Anti-Venom",	--?
		["Recently Bandaged"]			= "Recently Bandaged"	--?
	};

end