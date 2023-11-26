--[[
	Localization stings for Gatherer config UI
	english set by default, localized versions overwrite the variables.
	Version: 2.0.1
	Revision: $Id: UI_localization.lua,v 1.2 2005/04/28 02:43:23 norganna Exp $
	
	ToDo:
	* Add some leftover strings
	
]]

	GATHERER_TEXT_TITLE_BUTTON = "Gatherer Options";

	BINDING_HEADER_GATHERER_BINDINGS_HEADER   = "Gatherer";
	BINDING_NAME_GATHERER_BINDING_TOGGLE_MENU = "Gatherer menu On/Off";

	GATHERER_TEXT_REMATCH_TITLE	= "Zone Rematch";
	GATHERER_TEXT_CONFIG_TITLE      = "Gatherer: Options";

	GATHERER_TEXT_TOGGLE_MINIMAP	= "Minimap ";
	GATHERER_TEXT_TOGGLE_MAINMAP	= "Worldmap ";

	GATHERER_TEXT_TOGGLE_HERBS   	= "Herbs ";
	GATHERER_TEXT_TOGGLE_MINERALS	= "Ore ";
	GATHERER_TEXT_TOGGLE_TREASURE	= "Treasure ";

	GATHERER_TEXT_SHOWONMOUSE       = "Show on mouse over";
	GATHERER_TEXT_HIDEONMOUSE       = "Hide on mouse out";
	GATHERER_TEXT_SHOWONCLICK       = "Show on left click";
	GATHERER_TEXT_HIDEONCLICK       = "Hide on left click";
	GATHERER_TEXT_HIDEONBUTTON      = "Hide on button press";
	GATHERER_TEXT_POSITION          = "Position";
	GATHERER_TEXT_POSITION_TIP      = "Adjusts the position of the tracking icon around the border of the minimap";

	GATHERER_TEXT_RAREORE           = "Couple Rare Ore/Herbs";
	GATHERER_TEXT_NO_MINICONDIST	= "No icon under min distance";

	GATHERER_TEXT_MAPMINDER		= "Activate Map Minder";
	GATHERER_TEXT_MAPMINDER_VALUE	= "Map Minder timer";
	GATHERER_TEXT_MAPMINDER_TIP	= "Adjusts the Map Minder timer";

	GATHERER_TEXT_FADEPERC		= "Fade Percent";
	GATHERER_TEXT_FADEPERC_TIP	= "Adjusts icons fade percent" ;

	GATHERER_TEXT_FADEDIST		= "Fade Distance";
	GATHERER_TEXT_FADEDIST_TIP	= "Adjusts icons fade distance";

	GATHERER_TEXT_THEME		= "Theme: ";

	GATHERER_TEXT_MINIIDIST		= "Minimal icon distance";
	GATHERER_TEXT_MINIIDIST_TIP	= "Adjusts minimal distance at which item icon appears";

	GATHERER_TEXT_NUMBER		= "Mininotes number";
	GATHERER_TEXT_NUMBER_TIP	= "Adjusts number of mininotes displayed on the minimap";

	GATHERER_TEXT_MAXDIST		= "Mininotes distance";
	GATHERER_TEXT_MAXDIST_TIP	= "Adjusts maximum distance to consider when looking for mininotes to display on the minimap";

	GATHERER_TEXT_FILTER_HERBS	= "Herbs: ";
	GATHERER_TEXT_FILTER_ORE	= "Ore: ";
	GATHERER_TEXT_FILTER_TREASURE	= "Treasure: ";

	GATHERER_TEXT_APPLY_REMATCH	= "Apply Zone Rematch:";
	GATHERER_TEXT_SRCZONE_MISSING	= "Source Zone not selected.";
	GATHERER_TEXT_DESTZONE_MISSING	= "Destination Zone not selected.";
	GATHERER_TEXT_FIXITEMS		= "Fix Item Names";
	GATHERER_TEXT_LASTMATCH		= "Last Match: ";
	GATHERER_TEXT_LASTMATCH_NONE	= "None";
	GATHERER_TEXT_CONFIRM_REMATCH	= "Confirm Zone Rematch (WARNING, this will modify data)";
	


if ( GetLocale() == "frFR" ) then

	GATHERER_TEXT_TITLE_BUTTON = "Gatherer Options";

	BINDING_HEADER_GATHERER_BINDINGS_HEADER   = "Gatherer";
	BINDING_NAME_GATHERER_BINDING_TOGGLE_MENU = "Montrer/Cacher menu Gatherer";

	GATHERER_TEXT_REMATCH_TITLE	= "Zone Rematch";
	GATHERER_TEXT_CONFIG_TITLE      = "Gatherer: Options";

	GATHERER_TEXT_TOGGLE_MINIMAP	= "Carte: Minicarte ";
	GATHERER_TEXT_TOGGLE_MAINMAP	= "Carte: Monde ";

	GATHERER_TEXT_TOGGLE_HERBS   	= "R\195\169colte Herbes ";
	GATHERER_TEXT_TOGGLE_MINERALS	= "R\195\169colte Gisements ";
	GATHERER_TEXT_TOGGLE_TREASURE	= "R\195\169colte Tr\195\169sors ";

	GATHERER_TEXT_SHOWONMOUSE       = "Montrer sur passage souris";
	GATHERER_TEXT_HIDEONMOUSE       = "Cacher hors passage souris";
	GATHERER_TEXT_SHOWONCLICK       = "Montrer sur clic gauche";
	GATHERER_TEXT_HIDEONCLICK       = "Cacher sur clic gauche";
	GATHERER_TEXT_HIDEONBUTTON      = "Cacher sur activation bouton";
	GATHERER_TEXT_POSITION          = "Position";
	GATHERER_TEXT_POSITION_TIP      = "Ajuste la position de l'icone de pistage sur le bord de la minicarte";

	GATHERER_TEXT_RAREORE      	= "Coupler Minerais/Herbes Rares";
	GATHERER_TEXT_NO_MINICONDIST	= "Pas d'icone sous distance mini";

	GATHERER_TEXT_MAPMINDER		= "Activation Map Minder";
	GATHERER_TEXT_MAPMINDER_VALUE	= "Dur\195\169e Map Minder";
	GATHERER_TEXT_MAPMINDER_TIP	= "Ajuste la dur\195\169e du Map Minder";

	GATHERER_TEXT_FADEPERC		= "Pourcentage transparence";
	GATHERER_TEXT_FADEPERC_TIP	= "Ajuste le pourcentage de transparence des icones" ;

	GATHERER_TEXT_FADEDIST		= "Distance transparence";
	GATHERER_TEXT_FADEDIST_TIP	= "Ajuste la distance de transparence des icones";

	GATHERER_TEXT_THEME		= "Th\195\168me: ";

	GATHERER_TEXT_MINIIDIST		= "Distance mini icone";
	GATHERER_TEXT_MINIIDIST_TIP	= "Ajuste la distance minimale a laquelle l'icone apparait";

	GATHERER_TEXT_NUMBER		= "Nombre de notes";
	GATHERER_TEXT_NUMBER_TIP	= "Ajuste le nombre de notes affich\195\169es sur la minicarte";

	GATHERER_TEXT_MAXDIST		= "Distance maxi notes";
	GATHERER_TEXT_MAXDIST_TIP	= "Ajuste la distance maximum pour l'affichage des notes sur la minicarte";

	GATHERER_TEXT_FILTER_HERBS	= "Herbes: ";
	GATHERER_TEXT_FILTER_ORE	= "Gisements: ";
	GATHERER_TEXT_FILTER_TREASURE	= "Tr\195\169sors: ";

	GATHERER_TEXT_APPLY_REMATCH	= "Synchronisation des zones:";
	GATHERER_TEXT_SRCZONE_MISSING	= "Zone Source non s\195\169lection\195\169e.";
	GATHERER_TEXT_DESTZONE_MISSING	= "Zone Destination non s\195\169lection\195\169e.";
	GATHERER_TEXT_FIXITEMS		= "Correction du nom des objets";
	GATHERER_TEXT_LASTMATCH		= "Derni\195\168re synchro: ";
	GATHERER_TEXT_LASTMATCH_NONE	= "Aucune";
	GATHERER_TEXT_CONFIRM_REMATCH	= "Confirmation de la resynchronisation des zones (ATTENTION, cela modifie les donn\195\169es)";
end

if ( GetLocale() == "deDE" ) then

	GATHERER_TEXT_TITLE_BUTTON = "Gatherer Optionen";

	BINDING_HEADER_GATHERER_BINDINGS_HEADER = "Gatherer";
	BINDING_NAME_GATHERER_BINDING_TOGGLE_MENU = "Gatherer-Menue An/Aus";

	GATHERER_TEXT_REMATCH_TITLE = "Zonenabgleich";
	GATHERER_TEXT_CONFIG_TITLE = "Gatherer: Optionen";

	GATHERER_TEXT_TOGGLE_MINIMAP = "Minikarte ";
	GATHERER_TEXT_TOGGLE_MAINMAP = "Weltkarte ";

	GATHERER_TEXT_TOGGLE_HERBS = "Kraeuter ";
	GATHERER_TEXT_TOGGLE_MINERALS = "Erze ";
	GATHERER_TEXT_TOGGLE_TREASURE = "Schaetze ";

	GATHERER_TEXT_SHOWONMOUSE = "Anzeigen bei 'Mouse-over'";
	GATHERER_TEXT_HIDEONMOUSE = "Verstecken bei 'Mouse-out'";
	GATHERER_TEXT_SHOWONCLICK = "Anzeigen beim Linksklick";
	GATHERER_TEXT_HIDEONCLICK = "Verstecken beim Linksklick";
	GATHERER_TEXT_HIDEONBUTTON = "Verstecken bei Tastendruck";
	GATHERER_TEXT_POSITION = "Position";
	GATHERER_TEXT_POSITION_TIP = "Passt die Position des Trackingicons am Rand der Minikarte an";

	GATHERER_TEXT_RAREORE = "Ein paar seltene Erze/Kraeuter";
	GATHERER_TEXT_NO_MINICONDIST = "Kein icon unter der min.enfern.";

	GATHERER_TEXT_MAPMINDER = "Map-Minder aktivieren";
	GATHERER_TEXT_MAPMINDER_VALUE = "Map-Minder-Timer";
	GATHERER_TEXT_MAPMINDER_TIP = "Stellt den Map-Minder-Timer ein";

	GATHERER_TEXT_FADEPERC = "Transparenz in Prozent";
	GATHERER_TEXT_FADEPERC_TIP = "Stellt die Transparenz in Prozent ein" ;

	GATHERER_TEXT_FADEDIST = "Ausblendungsabstand";
	GATHERER_TEXT_FADEDIST_TIP = "Stellt die Entfernung f\195\188r die Ausblendung ein";

	GATHERER_TEXT_THEME = "Theme: ";

	GATHERER_TEXT_MINIIDIST = "Minimale Icon-Entfernung";
	GATHERER_TEXT_MINIIDIST_TIP = "Stellt die minimale Entfernung der Icons ein in welcher sie erscheinen";

	GATHERER_TEXT_NUMBER = "Mininotiz-Anzahl";
	GATHERER_TEXT_NUMBER_TIP = "Stellt die Anzahl der angezeigten Mininotizen ein";

	GATHERER_TEXT_MAXDIST = "Mininotiz-Entfernung";
	GATHERER_TEXT_MAXDIST_TIP = "Stellt die maximale Entfernung ein, in welcher nach Mininotizen gesucht wird";

	GATHERER_TEXT_FILTER_HERBS = "Kraeuter: ";
	GATHERER_TEXT_FILTER_ORE = "Erze: ";
	GATHERER_TEXT_FILTER_TREASURE = "Schaetze: ";

	GATHERER_TEXT_APPLY_REMATCH = "Zonenabgleich durchf\195\188hren:";
	GATHERER_TEXT_SRCZONE_MISSING = "Quellzone nicht ausgew\195\164hlt.";
	GATHERER_TEXT_DESTZONE_MISSING = "Zielzone nicht ausgew\195\164hlt.";
	GATHERER_TEXT_FIXITEMS = "Item-Namen korrigieren";
	GATHERER_TEXT_LASTMATCH = "Letzer Treffer: ";
	GATHERER_TEXT_LASTMATCH_NONE = "Keiner";
	GATHERER_TEXT_CONFIRM_REMATCH = "Zonenabgleich best\195\164tigen (ACHTUNG: Daten werden ge\195\164ndert)";
end

