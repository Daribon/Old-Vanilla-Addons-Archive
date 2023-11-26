-- Version : German (by StarDust)
-- Last Update : 09/14/2005

if ( GetLocale() == "deDE" ) then

	PLAYER_GHOST 					= "Geist";
	PLAYER_WISP 					= "Wisp";

	ARCHAEOLOGIST_CONFIG_SEP			= "Arch\195\164ologe";
	ARCHAEOLOGIST_CONFIG_SEP_INFO			= "Einstellungen des Arch\195\164ologen";

	ARCHAEOLOGIST_FEEDBACK_STRING			= "%s ge\195\164ndert auf %s.";

	-- <= == == == == == == == == == == == == =>
	-- => Player Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PLAYER_SEP			= "Eigenen Statusanzeige";
	ARCHAEOLOGIST_CONFIG_PLAYER_SEP_INFO		= "Die meisten Angaben werden standardm\195\164\195\159ig angezeigt, wenn der Mauszeiger \195\188ber den entsprechenden Statusbalken bewegt wird.";
			
	ARCHAEOLOGIST_CONFIG_PLAYERHP			= "Eigene Gesundheit immer anzeigen";
	ARCHAEOLOGIST_CONFIG_PLAYERHP_INFO		= "Wenn aktiviert, wird die Zahl der eigene Gesundheit immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber den Gesundheitsbalken bewegt.";
	ARCHAEOLOGIST_CONFIG_PLAYERMP			= "Eigene(s) Mana, Wut und Energie immer anzeigen";
	ARCHAEOLOGIST_CONFIG_PLAYERMP_INFO		= "Wenn aktiviert, wird die Zahl des eigenen Manas, Wut undEnergie immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber den zweiten Statusbalken (unter Gesundheit) bewegt.";
	ARCHAEOLOGIST_CONFIG_PLAYERXP			= "Erfahrung immer anzeigen";
	ARCHAEOLOGIST_CONFIG_PLAYERXP_INFO		= "Wenn aktiviert, wird die Zahl des Erfahrung immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber den Erfahrungsbalken bewegt.";
	ARCHAEOLOGIST_CONFIG_PLAYERHPP			= "Eigene Gesundheit in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_PLAYERHPP_INFO		= "Wenn aktiviert, wird die Zahl der eigenen Gesundheit in Prozent angegeben und nicht mehr als momentan/maximal.";
	ARCHAEOLOGIST_CONFIG_PLAYERMPP			= "Eigene(s) Mana, Wut und Energie in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_PLAYERMPP_INFO		= "Wenn aktiviert, wird die Zahl des eigenen Manas, Wut und Energie im zweiten Statusbalken (unter Gesundheit) in Prozent angegeben.";
	ARCHAEOLOGIST_CONFIG_PLAYERXPP			= "Erfahrung in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_PLAYERXPP_INFO		= "Wenn aktiviert, wird die Zahl der Erfahrung in Prozent angegeben und nicht mehr als momentan/maximal dieser Level.";
	ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE		= "Prefix 'Gesundheit' verbergen";
	ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Gesundheit' im Gesundheitsbalken ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE		= "Prefix 'Mana', 'Wut' und 'Energie' verbergen";
	ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Mana', 'Wut' und 'Energie' im zweiten Statusbalken (unter Gesundheit) ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE		= "Prefix 'Erfahrung' verbergen";
	ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Erfahrung' im Erfahrungssbalken ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_PLAYERCLASSICON		= "Klassen-Icon anzeigen";
	ARCHAEOLOGIST_CONFIG_PLAYERCLASSICON_INFO	= "Wenn aktiviert, wird im eigenen Charakterfenster ein Icon gem\195\164\195\159 der eigene Klasse angezeigt.";

	-- <= == == == == == == == == == == == == =>
	-- => Party Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PARTY_SEP			= "Statusanzeigen der Gruppe";
	ARCHAEOLOGIST_CONFIG_PARTY_SEP_INFO		= "Die meisten Angaben werden standardm\195\164\195\159ig angezeigt, wenn der Mauszeiger \195\188ber den entsprechenden Statusbalken bewegt wird.";

	ARCHAEOLOGIST_CONFIG_PARTYHP			= "Gesundheit von Gruppenmitgliedern immer anzeigen";
	ARCHAEOLOGIST_CONFIG_PARTYHP_INFO		= "Wenn aktiviert, wird die Zahl der Gesundheit von Gruppenmitgliedern immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber den jeweiligen Gesundheitsbalken bewegt.";
	ARCHAEOLOGIST_CONFIG_PARTYMP			= "Mana, Wut und Energie der Gruppe immer anzeigen";
	ARCHAEOLOGIST_CONFIG_PARTYMP_INFO		= "Wenn aktiviert, wird die Zahl des Manas, Wut und Energie von Gruppenmitgliedern immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber den jeweiligen Statusbalken bewegt.";
	ARCHAEOLOGIST_CONFIG_PARTYHPP			= "Gesundheit von Gruppenmitgliedern in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_PARTYHPP_INFO		= "Wenn aktiviert, wird die Zahl der Gesundheit von Gruppenmitgliedern jeweils in Prozent angegeben und nicht mehr als momentan/maximal.";
	ARCHAEOLOGIST_CONFIG_PARTYMPP			= "Mana, Wut und Energie der Gruppe in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_PARTYMPP_INFO		= "Wenn aktiviert, wird die Zahl des Mana, Wut und Energie von Gruppenmitgliedern im jeweiligen zweiten Statusbalken (unter Gesundheit) in Prozent angegeben.";
	ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE		= "Prefix 'Gesundheit' verbergen";
	ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Gesundheit' des jeweiligen Gruppenmitglieds ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE		= "Prefix 'Mana', 'Wut' und 'Energie' verbergen";
	ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Mana', 'Wut' und 'Energie' von Gruppenmitgliedern im jeweiligen zweiten Statusbalken (unter Gesundheit) ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_PARTYCLASSICON		= "Klassen-Icons anzeigen";
	ARCHAEOLOGIST_CONFIG_PARTYCLASSICON_INFO	= "Wenn aktiviert, wird im Gruppenfenster neben dem jeweiligen Charakter ein Icon f\195\188r die entsprechende Klasse angezeigt.";

	-- <= == == == == == == == == == == == == =>
	-- => Pet Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PET_SEP			= "Statusanzeigen des Pet";
	ARCHAEOLOGIST_CONFIG_PET_SEP_INFO		= "Die meisten Angaben werden standardm\195\164\195\159ig angezeigt, wenn der Mauszeiger \195\188ber den entsprechenden Statusbalken bewegt wird.";

	ARCHAEOLOGIST_CONFIG_PETHP			= "Gesundheit des Pets immer anzeigen";
	ARCHAEOLOGIST_CONFIG_PETHP_INFO			= "Wenn aktiviert, wird die Zahl der Gesundheit des Pet immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber dessen Gesundheitsbalken bewegt.";
	ARCHAEOLOGIST_CONFIG_PETMP			= "Mana, Wut und Energie des Pet immer anzeigen";
	ARCHAEOLOGIST_CONFIG_PETMP_INFO			= "Wenn aktiviert, wird die Zahl des Manas, Wut und Energie des Pet immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber dessen zweiten Statusbalken (unter Gesundheit) bewegt.";
	ARCHAEOLOGIST_CONFIG_PETHPP			= "Gesundheit des Pet in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_PETHPP_INFO		= "Wenn aktiviert, wird die Zahl der Gesundheit des Pet jeweils in Prozent angegeben und nicht mehr als momentan/maximal.";
	ARCHAEOLOGIST_CONFIG_PETMPP			= "Mana, Wut und Energie des Pet in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_PETMPP_INFO		= "Wenn aktiviert, wird die Zahl des Mana, Wut und Energie des Pet in dessen zweitem Statusbalken (unter Gesundheit) in Prozent angegeben.";
	ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE		= "Prefix 'Gesundheit' verbergen";
	ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Gesundheit' des Pet ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE		= "Prefix 'Mana', 'Wut' und 'Energie' verbergen";
	ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Mana', 'Wut' und 'Energie' des Pet in dessem zweiten Statusbalken (unter Gesundheit) ausgeblendet und nur noch die Zahl angezeigt.";

	-- <= == == == == == == == == == == == == =>
	-- => Target Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_TARGET_SEP			= "Statusanzeigen des Ziels";
	ARCHAEOLOGIST_CONFIG_TARGET_SEP_INFO		= "Die meisten Angaben werden standardm\195\164\195\159ig angezeigt, wenn der Mauszeiger \195\188ber den entsprechenden Statusbalken bewegt wird.";

	ARCHAEOLOGIST_CONFIG_TARGETHP			= "Gesundheit des Ziels immer anzeigen (nur in Prozent)";
	ARCHAEOLOGIST_CONFIG_TARGETHP_INFO		= "Wenn aktiviert, wird die Zahl der Gesundheit des momentanen Ziels im Zielfenster immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber dessen Gesundheitsbalken bewegt.";
	ARCHAEOLOGIST_CONFIG_TARGETMP			= "Mana, Wut und Energie des Ziels immer anzeigen";
	ARCHAEOLOGIST_CONFIG_TARGETMP_INFO		= "Wenn aktiviert, wird die Zahl des Manas, Wut und Energie des momentanen Ziels im Zielfenster immer angezeigt und nicht erst wenn man den Mauszeiger \195\188ber dessen Statusbalken bewegt.";
	ARCHAEOLOGIST_CONFIG_TARGETHPP			= "Gesundheit des Ziels in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_TARGETHPP_INFO		= "Wenn aktiviert, wird die Zahl der Gesundheit des momentanen Ziels im Zielfenster jeweils in Prozent angegeben und nicht mehr als momentan/maximal.";
	ARCHAEOLOGIST_CONFIG_TARGETMPP			= "Mana, Wut und Energie des Ziels in Prozent anzeigen";
	ARCHAEOLOGIST_CONFIG_TARGETMPP_INFO		= "Wenn aktiviert, wird die Zahl des Mana, Wut und Energie des momentanen Ziels im Zielfenster in dessen zweitem Statusbalken (unter Gesundheit) in Prozent angegeben.";
	ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE		= "Prefix 'Gesundheit' verbergen";
	ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Gesundheit' des momentanen Ziels im Zielfenster ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE		= "Prefix 'Mana', 'Wut' und 'Energie' verbergen";
	ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE_INFO	= "Wenn aktiviert, wird der Prefix 'Mana', 'Wut' und 'Energie' des momentanen Ziels im Zielfenster in dessem zweiten Statusbalken (unter Gesundheit) ausgeblendet und nur noch die Zahl angezeigt.";
	ARCHAEOLOGIST_CONFIG_TARGETCLASSICON		= "Klassen-Icon anzeigen";
	ARCHAEOLOGIST_CONFIG_TARGETCLASSICON_INFO	= "Wenn aktiviert, wird im Zielfenster ein Icon gem\195\164\195\159 der jeweiligen Klasse des Ziels angezeigt.";

	-- <= == == == == == == == == == == == == =>
	-- => Alternate Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP		= "Sonstige Einstellungen";
	ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP_INFO		= "Sonstige Einstellungen";

	ARCHAEOLOGIST_CONFIG_HPCOLOR			= "Farbwechsel des Gesundheitsbalken aktivieren";
	ARCHAEOLOGIST_CONFIG_HPCOLOR_INFO		= "Wenn aktiviert, \195\164ndert der Gesundheitsbalken seine Farbe je weniger Gesundheit vorhanden ist.";

	ARCHAEOLOGIST_CONFIG_DEBUFFALT			= "Alternative Position der Debufficons";
	ARCHAEOLOGIST_CONFIG_DEBUFFALT_INFO		= "Wenn aktiviert, werden Debufficons des Pet und von Gruppenmitgliedern unter deren Bufficons angezeigt. Standardm\195\164\195\159ig werden jene neben dem jeweiligen Portraitfenster angezeigt.";

	ARCHAEOLOGIST_CONFIG_TBUFFALT			= "Bufficons des Ziels von Rechts nach Links anordnen";
	ARCHAEOLOGIST_CONFIG_TBUFFALT_INFO		= "Wenn aktiviert, werden die Buff- und Debufficons des Ziels von rechts nach links angeordnet.";

	ARCHAEOLOGIST_CONFIG_HPMPALT			= "Alternative Position der Statusangaben";
	ARCHAEOLOGIST_CONFIG_HPMPALT_INFO		= "Wenn aktiviert, werden alle Angaben von Gesundheit, Mana, Wut und Energie rechts neben den jeweiligen Statusbalken angezeigt und nicht mehr innerhalb der jeweiligen Statusbalken.";

	ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE		= "Charakter- und Zielportrait";
	ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE_INFO		= "Erm\195\182glicht es die Schriftgr\195\182\195\159e f\195\188r Gesundheit, Mana und Wut im eigenen Charakter- sowie im Zielprortrait Fenster anzupassen.";
	ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE_SLIDERTEXT   = "Schriftgr\195\182\195\159e";

	ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE		= "Pet- und Gruppenportrait";
	ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE_INFO		= "Erm\195\182glicht es die Schriftgr\195\182\195\159e f\195\188r Gesundheit, Mana und Wut im Petportrait Fenster sowie in den Portraits der Gruppenmitglieder anzupassen.";
	ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE_SLIDERTEXT   = "Schriftgr\195\182\195\159e";

	ARCHAEOLOGIST_CONFIG_MOBHEALTH			= "MobHealth2 f\195\188r Gesundheitsanzeige des Ziels verwenden";
	ARCHAEOLOGIST_CONFIG_MOBHEALTH_INFO		= "Verbirgt den normalen MobHealth2 Text und verwendet jenen anstelle des Textes f\195\188r die Gesundheitsanzeige im Zielfenster.";

	ARCHAEOLOGIST_CONFIG_CLASSPORTRAIT		= "Klassenportrait verwenden";
	ARCHAEOLOGIST_CONFIG_CLASSPORTRAIT_INFO		= "Wenn aktiviert, wird wenn m\195\182glich das Charakterportrait mit dem Klassenicon ersetzt.";

	-- <= == == == == == == == == == == == == =>
	-- => Party Buff Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP		= "Buff-Einstellungen der Gruppe";
	ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP_INFO	= "Standardm\195\164\195\159ig werden 12 Bufficons und 12 Debufficons angezeigt.";

	ARCHAEOLOGIST_CONFIG_PBUFFS			= "Buffs von Gruppenmitgliedern verbergen";
	ARCHAEOLOGIST_CONFIG_PBUFFS_INFO		= "Wenn aktiviert, werden Buffs von Gruppenmitgliedern nur angezeigt wenn man den Mauszeiger \195\188ber deren Portraitfenster bewegt.";

	ARCHAEOLOGIST_CONFIG_PBUFF_NUM			= "Anzahl der angezeigten Buffs";
	ARCHAEOLOGIST_CONFIG_PBUFF_NUM_INFO		= "Legt die Anzahl der angezeigten Buffs von jedem Gruppenmitgliedern fest.";
	ARCHAEOLOGIST_CONFIG_PBUFF_NUM_SLIDER_TEXT	= "Buffs";

	ARCHAEOLOGIST_CONFIG_PDEBUFFS			= "Debuffs von Gruppenmitgliedern verbergen";
	ARCHAEOLOGIST_CONFIG_PDEBUFFS_INFO		= "Wenn aktiviert, werden Debuffs von Gruppenmitgliedern nicht angezeigt.";

	ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM		= "Anzahl der angezeigten Debuffs";
	ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM_INFO		= "Legt die Anzahl der angezeigten Debuffs von jedem Gruppenmitglied fest.";
	ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM_SLIDER_TEXT	= "Debuffs";

	-- <= == == == == == == == == == == == == =>
	-- => Pet Buff Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP		= "Buff-Einstellungen des Pet";
	ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP_INFO		= "Standardm\195\164\195\159ig werden 12 Bufficons und 12 Debufficons angezeigt.";

	ARCHAEOLOGIST_CONFIG_PTBUFFS			= "Buffs des Pet verbergen";
	ARCHAEOLOGIST_CONFIG_PTBUFFS_INFO		= "Wenn aktiviert, werden Buffs des Pet nur angezeigt wenn man den Mauszeiger \195\188ber dessen Portraitfenster bewegt.";

	ARCHAEOLOGIST_CONFIG_PTBUFFNUM			= "Anzahl der angezeigten Buffs";
	ARCHAEOLOGIST_CONFIG_PTBUFFNUM_INFO		= "Legt die Anzahl der angezeigten Buffs des Pet fest.";
	ARCHAEOLOGIST_CONFIG_PTBUFFNUM_SLIDER_TEXT	= "Buffs";

	ARCHAEOLOGIST_CONFIG_PTDEBUFFS			= "Debuffs des Pet verbergen";
	ARCHAEOLOGIST_CONFIG_PTDEBUFFS_INFO		= "Wenn aktiviert, werden Debuffs des Pet nicht angezeigt.";

	ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM		= "Anzahl der angezeigten Debuffs";
	ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM_INFO		= "Legt die Anzahl der angezeigten Debuffs des Pet fest.";
	ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM_SLIDER_TEXT	= "Debuffs";

	-- <= == == == == == == == == == == == == =>
	-- => Target Buff Options
	-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_TARGETBUFFS_SEP		= "Buff-Einstellungen des Ziels";
	ARCHAEOLOGIST_CONFIG_TARGETBUFFS_SEP_INFO	= "Standardm\195\164\195\159ig werden 8 Bufficons und 16 Debufficons angezeigt.";

	ARCHAEOLOGIST_CONFIG_TBUFFS			= "Buffs des Ziels verbergen";
	ARCHAEOLOGIST_CONFIG_TBUFFS_INFO		= "Wenn aktiviert, werden Buffs des angew\195\164hlten Ziels nicht angezeigt.";

	ARCHAEOLOGIST_CONFIG_TBUFFNUM			= "Anzahl der angezeigten Buffs";
	ARCHAEOLOGIST_CONFIG_TBUFFNUM_INFO		= "Legt die Anzahl der angezeigten Buffs des angew\195\164hlten Ziels fest.";
	ARCHAEOLOGIST_CONFIG_TBUFFNUM_SLIDER_TEXT	= "Buffs";

	ARCHAEOLOGIST_CONFIG_TDEBUFFS			= "Debuffs des Ziels verbergen";
	ARCHAEOLOGIST_CONFIG_TDEBUFFS_INFO		= "Wenn aktiviert, werden Debuffs des angew\195\164hlten Ziels nicht angezeigt.";

	ARCHAEOLOGIST_CONFIG_TDEBUFFNUM			= "Anzahl der angezeigten Debuffs";
	ARCHAEOLOGIST_CONFIG_TDEBUFFNUM_INFO		= "Legt die Anzahl der angezeigten Debuffs des angew\195\164hlten Ziels fest.";
	ARCHAEOLOGIST_CONFIG_TDEBUFFNUM_SLIDER_TEXT	= "Debuffs";

	ARCHAEOLOGIST_FEEDBACK_STRING			= "%s ist momentan auf %s gesetzt.";

end