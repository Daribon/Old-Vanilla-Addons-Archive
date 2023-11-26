--[[
	Localization stings for Gatherer config UI
	english set by default, localized versions overwrite the variables.
	Version: <%version%>
	Revision: $Id: UI_localization.lua,v 1.8 2005/07/15 20:12:07 islorgris Exp $
	
	ToDo:
	* Add some leftover strings
	
]]

	GATHERER_TEXT_TITLE_BUTTON = "Gatherer Options";

	BINDING_HEADER_GATHERER_BINDINGS_HEADER   = "Gatherer";
	BINDING_NAME_GATHERER_BINDING_TOGGLE_MENU = "Gatherer menu On/Off";

	GATHERER_TEXT_REMATCH_TITLE		= "Zone Rematch";
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

	GATHERER_TEXT_MAPMINDER			= "Activate Map Minder";
	GATHERER_TEXT_MAPMINDER_VALUE	= "Map Minder timer";

	GATHERER_TEXT_FADEPERC			= "Fade Percent";

	GATHERER_TEXT_FADEDIST			= "Fade Distance";

	GATHERER_TEXT_THEME				= "Theme: ";

	GATHERER_TEXT_MINIIDIST			= "Minimal icon distance";

	GATHERER_TEXT_NUMBER			= "Mininotes number";

	GATHERER_TEXT_MAXDIST			= "Mininotes distance";

	GATHERER_TEXT_FILTER_HERBS		= "Herbs: ";
	GATHERER_TEXT_FILTER_ORE		= "Ore: ";
	GATHERER_TEXT_FILTER_TREASURE	= "Treasure: ";
	GATHERER_TEXT_LINKRECORD        = "Filter Record"

	GATHERER_TEXT_APPLY_REMATCH		= "Apply Zone Rematch:";
	GATHERER_TEXT_SRCZONE_MISSING	= "Source Zone not selected.";
	GATHERER_TEXT_DESTZONE_MISSING	= "Destination Zone not selected.";
	GATHERER_TEXT_FIXITEMS			= "Fix Item Names";
	GATHERER_TEXT_LASTMATCH			= "Last Match: ";
	GATHERER_TEXT_LASTMATCH_NONE	= "None";
	GATHERER_TEXT_CONFIRM_REMATCH	= "Confirm Zone Rematch (WARNING, this will modify data)";

	-- Tooltips
	GATHERER_TEXT_MAPMINDER_TIP	= "Adjusts the Map Minder timer";
	GATHERER_TEXT_FADEPERC_TIP	= "Adjusts icons fade percent" ;
	GATHERER_TEXT_FADEDIST_TIP	= "Adjusts icons fade distance";
	GATHERER_TEXT_MINIIDIST_TIP	= "Adjusts minimal distance at which item icon appears";
	GATHERER_TEXT_NUMBER_TIP	= "Adjusts number of mininotes displayed on the minimap";
	GATHERER_TEXT_MAXDIST_TIP	= "Adjusts maximum distance to consider when looking for mininotes to display on the minimap";
	GATHERER_TEXT_LINKRECORD_TIP = "Link recording to selected filters";

	-- New Tooltips
	GATHERER_MENUTITLE_TIP="Access Configuration dialog";

	GATHERER_HERBSKLEB_TIP="Set min Herbalism skill for display";
	GATHERER_ORESKLEB_TIP="Set min Mining skill for display";
	GATHERER_HERBDDM_TIP="Filter shown herbs";
	GATHERER_OREDDM_TIP="Filter shown ores";
	GATHERER_TREASUREDDM_TIP="Filter shown treasures";

	GATHERER_SHOWONMOUSE_TIP="Show menu on icon mouse over";
	GATHERER_SHOWONCLICK_TIP="Show Menu on icon left-click";
	GATHERER_HIDEONMOUSE_TIP="Hide menu off mouse over";
	GATHERER_HIDEONCLICK_TIP="Hide menu on icon left-click";
	GATHERER_HIDEONBUTTON_TIP="Hide menu on selection";

	GATHERER_MAPMINDER_TIP="Activate/Deactivate Map Minder";
	GATHERER_THEME_TIP="Set Icon Theme";
	GATHERER_NOMINIICONDIST_TIP="No display of minimap icon under min distance";	
	GATHERER_RAREORE_TIP="Show common/rare ore/herbs together";

	GATHERER_ZMBUTTON_TIP="Access Zone Match dialog";
	GATHERER_ZM_FIXITEM_TIP="Fix Items names, localized version only";
	GATHERER_ZM_SRCDDM_TIP="Set Source Map order";
	GATHERER_ZM_DESTDDM_TIP="Set Destination Map order";

	GATHERER_HIDEICON_TIP ="Hide minimap icon to access menu";
	GATHERER_HIDEMININOTES_TIP="Do not display mininotes on minimap";
	GATHERER_TOGGLEWORLDNOTES_TIP="Toggle between short/long item name in worldmap notes";
	GATHERER_WMICONSIZEEB_TIP="Set Icon size on world map";

	-- new texts
	GATHERER_TEXT_HIDEICON="Hide menu icon";
	GATHERER_TEXT_HIDEMININOTES="Hide mininotes";
	GATHERER_TEXT_TOGGLEWORLDNOTES="Long world note names";
	GATHERER_TEXT_WMICONSIZEEB="Worldmap icon size";

	GATHERER_TEXT_WMFILTERS="Filters on World Map";
	GATHERER_TEXT_WMFILTERS_TIP="Toggle items filters on world map.";

	GATHERER_TEXT_DISABLEWMFIX="Disable Show/Hide button";
	GATHERER_TEXT_DISABLEWMFIX_TIP="Disable the world map freeze workaround, use at your own risk.";

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
	GATHERER_TEXT_LINKRECORD        = "Saisie Filtr\195\169e"
	GATHERER_TEXT_LINKRECORD_TIP = "Conditionne l'enregistrement au contenu du filtre";

	GATHERER_TEXT_APPLY_REMATCH	= "Synchronisation des zones:";
	GATHERER_TEXT_SRCZONE_MISSING	= "Zone Source non s\195\169lection\195\169e.";
	GATHERER_TEXT_DESTZONE_MISSING	= "Zone Destination non s\195\169lection\195\169e.";
	GATHERER_TEXT_FIXITEMS		= "Correction du nom des objets";
	GATHERER_TEXT_LASTMATCH		= "Derni\195\168re synchro: ";
	GATHERER_TEXT_LASTMATCH_NONE	= "Aucune";
	GATHERER_TEXT_CONFIRM_REMATCH	= "Confirmation de la resynchronisation des zones (ATTENTION, cela modifie les donn\195\169es)";

	-- New Tooltips
	GATHERER_MENUTITLE_TIP="Vers la fenetre de configuration";

	GATHERER_HERBSKLEB_TIP="Comp\195\169tence mini pour l'affichage les herbes";
	GATHERER_ORESKLEB_TIP="Comp\195\169tence mini pour l'affichage des minerais";
	GATHERER_HERBDDM_TIP="Filtrer les herbes affich\195\169es";
	GATHERER_OREDDM_TIP="Filtrer les minerais affich\195\169es";
	GATHERER_TREASUREDDM_TIP="Filtrer les tr\195\169sors affich\195\169es";

	GATHERER_SHOWONMOUSE_TIP="Montrer le menu en passant la souris sur l'icone";
	GATHERER_SHOWONCLICK_TIP="Montrer le menu en faisant un clic gauche sur l'icone";
	GATHERER_HIDEONMOUSE_TIP="Cacher le menu quand la souris n'est plus sur l'icone";
	GATHERER_HIDEONCLICK_TIP="Cacher le menu en faisant un clic gauche sur l'icone";
	GATHERER_HIDEONBUTTON_TIP="Cacher le menu quand on clique sur un de ses \195\169l\195\169ments";

	GATHERER_MAPMINDER_TIP="Activater/D\195\169sactiver Map Minder";
	GATHERER_THEME_TIP="Choisir le th\195\168me d'icone";
	GATHERER_NOMINIICONDIST_TIP="Ne pas afficher les mini-icones en dessous de la distance minimale";	
	GATHERER_RAREORE_TIP="Coupler l'affichage des herbes/minerais rares";

	GATHERER_ZMBUTTON_TIP="Vers la synchronisation de zone";
	GATHERER_ZM_FIXITEM_TIP="Correction des noms d'objets, version localis\195\169e uniquement";
	GATHERER_ZM_SRCDDM_TIP="Choisir l'ordre des Zones d'origine";
	GATHERER_ZM_DESTDDM_TIP="Choisir l'ordre des Zones destination";

	GATHERER_HIDEICON_TIP ="Cacher l'icone d'acc\195\168s au menu";
	GATHERER_HIDEMININOTES_TIP="Ne pas afficher les mininotes sur la minicarte";
	GATHERER_TOGGLEWORLDNOTES_TIP="Basculer entre les noms courts/longs des objets sur la carte du monde";
	GATHERER_WMICONSIZEEB_TIP="Choisir la taille des icones sur la carte du monde";

	-- new texts
	GATHERER_TEXT_HIDEICON="Cacher l'icone de menu";
	GATHERER_TEXT_HIDEMININOTES="Cacher les mininotes";
	GATHERER_TEXT_TOGGLEWORLDNOTES="Noms longs sur carte du monde";
	GATHERER_TEXT_WMICONSIZEEB="Taille icone carte du monde";

	GATHERER_TEXT_WMFILTERS="Filtres Carte du Monde"
	GATHERER_TEXT_WMFILTERS_TIP="Montre/Cache les filtres d'objets sur la Carte du Monde"

	GATHERER_TEXT_DISABLEWMFIX="D\195\169sactive le bouton Show/Hide";
	GATHERER_TEXT_DISABLEWMFIX_TIP="D\195\169sactive le contournement du freeze carte du monde, \195\160 vos risques.";
end

if ( GetLocale() == "deDE" ) then

	GATHERER_TEXT_TITLE_BUTTON = "Gatherer Optionen";

	BINDING_HEADER_GATHERER_BINDINGS_HEADER = "Gatherer";
	BINDING_NAME_GATHERER_BINDING_TOGGLE_MENU = "Gatherer-Men\195\188 An/Aus";

	GATHERER_TEXT_REMATCH_TITLE = "Zonenabgleich";
	GATHERER_TEXT_CONFIG_TITLE = "Gatherer: Optionen";

	GATHERER_TEXT_TOGGLE_MINIMAP = "Minikarte ";
	GATHERER_TEXT_TOGGLE_MAINMAP = "Weltkarte ";

	GATHERER_TEXT_TOGGLE_HERBS    = "Kr\195\164uter ";
	GATHERER_TEXT_TOGGLE_MINERALS = "Erze ";
	GATHERER_TEXT_TOGGLE_TREASURE = "Sch\195\164tze ";

	GATHERER_TEXT_SHOWONMOUSE = "Anzeigen bei 'Mouse-over'";
	GATHERER_TEXT_HIDEONMOUSE = "Verstecken bei 'Mouse-out'";
	GATHERER_TEXT_SHOWONCLICK = "Anzeigen bei Linksklick";
	GATHERER_TEXT_HIDEONCLICK = "Verstecken bei Linksklick";
	GATHERER_TEXT_HIDEONBUTTON = "Verstecken bei Tastendruck";
	GATHERER_TEXT_POSITION = "Position";
	GATHERER_TEXT_POSITION_TIP = "Passt die Position des Trackingicons am Rand der Minikarte an";

	GATHERER_TEXT_RAREORE = "Ein paar seltene Erze/Kr\195\164uter";
	GATHERER_TEXT_NO_MINICONDIST = "Kein Icon unter der min.enfern.";
	
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

	GATHERER_TEXT_FILTER_HERBS = "Kr\195\164uter: ";
	GATHERER_TEXT_FILTER_ORE = "Erze: ";
	GATHERER_TEXT_FILTER_TREASURE = "Sch\195\164tze: ";
	
	GATHERER_TEXT_APPLY_REMATCH = "Zonenabgleich durchf\195\188hren:";
	GATHERER_TEXT_SRCZONE_MISSING = "Quellzone nicht ausgew\195\164hlt.";
	GATHERER_TEXT_DESTZONE_MISSING = "Zielzone nicht ausgew\195\164hlt.";
	GATHERER_TEXT_FIXITEMS = "Item-Namen korrigieren";
	GATHERER_TEXT_LASTMATCH = "Letzer Treffer: ";
	GATHERER_TEXT_LASTMATCH_NONE = "Keiner";
	GATHERER_TEXT_CONFIRM_REMATCH = "Zonenabgleich best\195\164tigen (ACHTUNG: Daten werden ge\195\164ndert!)";

	-- New Tooltips
	GATHERER_MENUTITLE_TIP="Zugriff auf Konfigurationen";  

	GATHERER_HERBSKLEB_TIP="Setze min. Kr\195\164uterkundeskill f\195\188r die Anzeige";  
	GATHERER_ORESKLEB_TIP="Set min. Bergbauskill f\195\188r die Anzeige";  
	GATHERER_HERBDDM_TIP="Filter anzuzeigende Pflanzen";  
	GATHERER_OREDDM_TIP="Filter anzuzeigende Erze";  
	GATHERER_TREASUREDDM_TIP="Filter anzuzeigende Truhen";  

	GATHERER_SHOWONMOUSE_TIP="Zeige das Menu beim Mausover \195\188ber das Icon";  
	GATHERER_SHOWONCLICK_TIP="Zeige das Menu beim Linksklick auf das Icon";  
	GATHERER_HIDEONMOUSE_TIP="Verstecke das Menu wenn der Mauszeiger nicht mehr auf dem Icon ist";  
	GATHERER_HIDEONCLICK_TIP="Verstecke das Menu beim Linksklick auf das Icon";  
	GATHERER_HIDEONBUTTON_TIP="Verstecke das Menu bei Anwahl";  

	GATHERER_MAPMINDER_TIP="Aktiviere/Deaktiviere Map Minder";  
	GATHERER_THEME_TIP="Setze Icon Theme";  
	GATHERER_NOMINIICONDIST_TIP="Keine Anzeige der Minimap-Icons unter der Mindestentfernung";  
	GATHERER_RAREORE_TIP="Zeige gew\195\182hnliche/seltene Erze/Pflanzen zusammen";  
 
	GATHERER_ZMBUTTON_TIP="Zugriff auf Zone Match Dialog";  
	GATHERER_ZM_FIXITEM_TIP="Korrigiere Itemnamen, nur lokalisierte Version";  
	GATHERER_ZM_SRCDDM_TIP="Setze Source Map Reihenfolge";  
	GATHERER_ZM_DESTDDM_TIP="Setze Destination Map Reihenfolge";  
 
	GATHERER_HIDEICON_TIP ="Verstecke das Minimapicon zum Menuzugriff";  
	GATHERER_HIDEMININOTES_TIP="Zeige keine Minimapsymbole an";  
	GATHERER_TOGGLEWORLDNOTES_TIP="Wechsel zwischen kurzen/langen Itemnamen der Weltkartenmarkierungen";  
	GATHERER_WMICONSIZEEB_TIP="Setze Icongr\195\182\195\159e auf der Weltkarte";  
 
	-- new texts  
	GATHERER_TEXT_HIDEICON="Verstecke Menuicon";  
	GATHERER_TEXT_HIDEMININOTES="Verstecke Minimarkierungen";  
	GATHERER_TEXT_TOGGLEWORLDNOTES="Lange Weltmarkierungsnamen";  
	GATHERER_TEXT_WMICONSIZEEB="Weltkarten Icongr\195\182\195\159e"; 
end

