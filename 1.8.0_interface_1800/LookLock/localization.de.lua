--[[
--	LookLock Localization
--		"German Localization"
--	
--	English By: StarDust
--	
--	$Id: localization.de.lua 2544 2005-09-30 01:25:32Z mugendai $
--	$Rev: 2544 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-09-29 20:25:32 -0500 (Thu, 29 Sep 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- Binding Strings
	--
	--------------------------------------------------
	BINDING_HEADER_LOOKLOCKHEADER           = "Sichtsperre";
	BINDING_NAME_LOOKLOCK                   = "Sichtsperre ein-/ausschalten";
	BINDING_NAME_LOOKLOCKPUSH               = "Sichtsperre Halten";
	BINDING_NAME_CAMERALOCK			= "Kamerasperre ein-/ausschalten";
	BINDING_NAME_CAMERALOCKPUSH		= "Kamerasperre Halten";
	BINDING_NAME_LOOKLOCKACTION             = "Sichtsperre Aktion";
	BINDING_NAME_LOOKLOCKCAMERA             = "Sichtsperre Kamera";

	--------------------------------------------------
	--
	-- UI Strings
	--
	--------------------------------------------------
	LOOKLOCK_CONFIG_HEADER			= "Sichtsperre";
	LOOKLOCK_CONFIG_HEADER_INFO             = "Diese Einstellungen erlauben die Konfiguration der Sichtsperre.";
	LOOKLOCK_CONFIG_REMAP			= "Maustasten in der Sichtsperre andere Funktione zuweisen";
	LOOKLOCK_CONFIG_REMAP_INFO		= "Verbessert die Benutzung der Maustasten bei Verwendung der Sichtsperre.";
	LOOKLOCK_CONFIG_STRAFE			= "Maustasten 'gleiten'";
	LOOKLOCK_CONFIG_STRAFE_INFO		= "Veranlasst die linke und rechte Maustaste nach links bzw. rechts zu 'gleiten' wenn die Sichtsperre aktiv ist.";
	LOOKLOCK_CONFIG_SELECT			= "Auswahlmodus";
	LOOKLOCK_CONFIG_SELECT_INFO		= "Wenn aktiviert und die Sichtsperre aktiv ist, erlaubt es die linke Maustaste Ziele anzuw\195\164hlen anstatt die Kamera zu drehen.";
	LOOKLOCK_CONFIG_CURSOR			= "Ziel-Mauszeiger anzeigen";
	LOOKLOCK_CONFIG_CURSOR_INFO		= "Wenn aktiviert, wird wenn die Sichtsperre aktiv ist der Ziel-Mauszeiger angezeigt.";
	LOOKLOCK_CONFIG_EASYLOOK		= "Einfache Sichtsperre";
	LOOKLOCK_CONFIG_EASYLOOK_INFO		= "Wenn aktiviert, wird der Sichtsperre-Modus aktiviert wenn die rechte Maustaste f\195\188r l\195\164nger als die angegebene Zeit gedr\195\188ckt gehalten und dann wieder freigelassen wird.";
	LOOKLOCK_CONFIG_EASYLOOK_SUFFIX		= "Sek.";
	LOOKLOCK_CONFIG_EASYCAMERA		= "Einfache Kamerasperre";
	LOOKLOCK_CONFIG_EASYCAMERA_INFO		= "Wenn aktiviert, wird der Kamerasperre-Modus aktiviert wenn die linke Maustaste f\195\188r l\195\164nger als die angegebene Zeit gedr\195\188ckt gehalten und dann wieder freigelassen wird.";
	LOOKLOCK_CONFIG_EASYCAMERA_SUFFIX	= "Sek.";
	LOOKLOCK_CONFIG_ALWAYS_SEP		= "Dauerhafte Sichtsperre";
	LOOKLOCK_CONFIG_ALWAYS_SEP_INFO		= "Diese Einstellungen erlauben die Konfiguration der dauerhaften Sichtsperre.";
	LOOKLOCK_CONFIG_ALWAYS			= "Immer gesperrt (Vorsicht!)";
	LOOKLOCK_CONFIG_ALWAYS_INFO		= "Wenn aktiviert, wird die Maus st\195\164ndig im Sichtsperre-Modus gehalten. Rechts-Klick stellt den normalen Modus wieder her. (mit Vorsicht verwenden!)";
	LOOKLOCK_CONFIG_LOOKTIME		= "Sichtzeit";
	LOOKLOCK_CONFIG_LOOKTIME_INFO		= "Legt die Zeit fest welche der Mauszeiger mindestens in einem automatischen Sichtmodus sein mu\195\159 bevor die Sichtsperre aktiviert wird.";
	LOOKLOCK_CONFIG_LOOKTIME_TEXT		= "Sekunden";
	LOOKLOCK_CONFIG_USEAREA			= "Sichtbereich verwenden";
	LOOKLOCK_CONFIG_USEAREA_INFO		= "Wenn aktiviert, mu\195\159 sich der Mauszeiger in einem bestimmten Sichtbereich befinden um den Sichtmodus zur\195\188ckzukehren.";
	LOOKLOCK_CONFIG_AREAWIDTH		= "Bereich Breite";
	LOOKLOCK_CONFIG_AREAWIDTH_INFO		= "Legt die Breite des Sichtbereichs in Prozent der Bildschirmbreite fest.";
	LOOKLOCK_CONFIG_AREAWIDTH_TEXT		= "Prozent der Bildschirmbreite";
	LOOKLOCK_CONFIG_AREAWIDTH_SUFFIX	= "%";
	LOOKLOCK_CONFIG_AREAHEIGHT		= "Bereich H\195\182he";
	LOOKLOCK_CONFIG_AREAHEIGHT_INFO		= "Legt die H\195\182he des Sichtbereichs in Prozent der Bildschirmh\195\182he fest.";
	LOOKLOCK_CONFIG_AREAHEIGHT_TEXT		= "Prozent der Bildschirmh\195\182he";
	LOOKLOCK_CONFIG_AREAHEIGHT_SUFFIX	= "%";
	LOOKLOCK_CONFIG_AREAHOFF		= "Bereich Horizontaler Versatz";
	LOOKLOCK_CONFIG_AREAHOFF_INFO		= "Legt den horizontalen Versatz des Sichtbereichs in Prozent der Bildschirmbreite vom Zentrum aus fest.";
	LOOKLOCK_CONFIG_AREAHOFF_TEXT		= "Prozent vom Zentrum";
	LOOKLOCK_CONFIG_AREAHOFF_SUFFIX		= "%";
	LOOKLOCK_CONFIG_AREAVOFF		= "Bereich Vertikaler Versatz";
	LOOKLOCK_CONFIG_AREAVOFF_INFO		= "Legt den vertikalen Versatz des Sichtbereichs in Prozent der Bildschirmh\195\182he vom Zentrum aus fest.";
	LOOKLOCK_CONFIG_AREAVOFF_TEXT		= "Prozent vom Zentrum";
	LOOKLOCK_CONFIG_AREAVOFF_SUFFIX		= "%";
	LOOKLOCK_CONFIG_CURSOR_NAME		= "Ziel-Mauszeiger";
	LOOKLOCK_CONFIG_AREA_NAME		= "Sichtsperre Bereich";

	--------------------------------------------------
	--
	-- Chat Strings
	--
	--------------------------------------------------
	LOOKLOCK_CHAT_REMAP			= LOOKLOCK_CONFIG_REMAP;
	LOOKLOCK_CHAT_STRAFE			= LOOKLOCK_CONFIG_STRAFE;
	LOOKLOCK_CHAT_SELECT			= LOOKLOCK_CONFIG_SELECT;
	LOOKLOCK_CHAT_CURSOR			= LOOKLOCK_CONFIG_CURSOR;
	LOOKLOCK_CHAT_ALWAYS			= LOOKLOCK_CONFIG_ALWAYS;
	LOOKLOCK_CHAT_LOOKTIME			= LOOKLOCK_CONFIG_LOOKTIME;
	LOOKLOCK_CHAT_USEAREA			= LOOKLOCK_CONFIG_USEAREA;
	LOOKLOCK_CHAT_AREAWIDTH			= LOOKLOCK_CONFIG_AREAWIDTH;
	LOOKLOCK_CHAT_AREAHEIGHT		= LOOKLOCK_CONFIG_AREAHEIGHT;
	LOOKLOCK_CHAT_AREAHOFF			= LOOKLOCK_CONFIG_AREAHOFF;
	LOOKLOCK_CHAT_AREAVOFF			= LOOKLOCK_CONFIG_AREAVOFF;

	--------------------------------------------------
	--
	-- Help Text
	--
	--------------------------------------------------
	LOOKLOCK_CONFIG_INFOTEXT = {
		"    Look Lock is an addon that allows you to enter a "..
		"state where you do not have to hold down a button to "..
		"rotate your character with the mouse.  Just push the "..
		"Look Lock button, and until you push it again, your "..
		"character will rotate when you move the mouse.\n"..
		"\n"..
		"    Go to the key bindings settings to configure a key "..
		"to use for Look Lock.  There are three bindable keys:"..
		BINDING_NAME_LOOKLOCK.." - this if the primary look lock "..
		"key, press this button to enter look lock mode.\n"..
		"\n"..
		BINDING_NAME_LOOKLOCKPUSH.." - this allows you to configure "..
		"a key that will put you in look lock mode only as long as "..
		"you hold it down.\n"..
		"\n"..
		BINDING_NAME_LOOKLOCKACTION.." - this allows you to map a "..
		"key to the look lock version of the right click function.\n"..
		"\n"..
		BINDING_NAME_LOOKLOCKCAMERA.." - this allows you to map a "..
		"key to the look lock version of the left click function.\n"..
		"\n"..
		"Option Explainations:\n"..
		"\n"..
		LOOKLOCK_CONFIG_REMAP.." - if this is enabled, then the right "..
		"and left mouse buttons will behave slightly different when in "..
		"Look Lock mode.  The right button will cause you to leave "..
		"Look Lock mode, and you will get a cursor which you can then put "..
		"over an object, and when you release it will be activated.\n"..
		"The left button will leave look mode, enter camera rotation mode "..
		"and then when released will return to look mode.  If the left button "..
		"is clicked, then whatever is under the mouse cursor will be selected.\n"..
		"\n"..
		LOOKLOCK_CONFIG_STRAFE.." - if this is enabled, and "..LOOKLOCK_CONFIG_REMAP..
		" is enabled, then pressing the right and left mouse button will strafe "..
		"left and right when in Look Lock mode.\n"..
		"\n"..
		LOOKLOCK_CONFIG_SELECT.." - if enabled, then when in look lock mode, "..
		"pressing the left mouse button will give you a cursor, which you can "..
		"then point at a target with, and when you release, the target will be "..
		"selected.  Otherwise, the left button will rotate the camera, however "..
		"clicking the left button will select what is under the mouse.\n"..
		"\n"..
		LOOKLOCK_CONFIG_CURSOR.." - if enabled, then when in look lock mode, "..
		"if the camera or character are turning, and the mouse cursor has been "..
		"hidden, a targeting cursor will be shown.\n"..
		"\n"..
		LOOKLOCK_CONFIG_ALWAYS.." - if enabled, then you will always be in "..
		"look lock mode.\nRight clicking the mouse will give you a cursor "..
		"which you can then put over an object and release to activate it.\n"..
		"Left clicking will give you a cursor which you can move over an "..
		"object to select it.  When in this mode, the Look Lock button will "..
		"switch to more normal behavior.\n"..
		"\n"..
		"This mode is imperfect, and you "..
		"should be aware that it may skrew up gameplay for you.  Blizzard "..
		"did not make it easy to make this style of interface implemented "..
		"and Look Lock must know pretty much every frame in the game so "..
		"so that it can avoid getting your mouse cursor stuck in look mode.\n"..
		"So consider this your warning, that this mode just might not work "..
		"out for you at all.  In general it works without getting the mouse "..
		"stuck, but if a frame that Look Lock doesn't know ends up under "..
		"the mouse cursor, it is likely it will get stuck.\n"..
		"\n"..
		LOOKLOCK_CONFIG_USEAREA.." - if enabled, the mouse will have to be within "..
		"the look area to re-enter look mode, when always look is on.  The look "..
		"area will be displayed, when not in look mode.\n"..
		"\n"..
		LOOKLOCK_CONFIG_AREAWIDTH.." - "..LOOKLOCK_CONFIG_AREAWIDTH_INFO.."\n"..
		"\n"..
		LOOKLOCK_CONFIG_AREAHEIGHT.." - "..LOOKLOCK_CONFIG_AREAHEIGHT_INFO.."\n"..
		"\n"..
		LOOKLOCK_CONFIG_AREAHOFF.." - "..LOOKLOCK_CONFIG_AREAHOFF_INFO.."\n"..
		"\n"..
		LOOKLOCK_CONFIG_AREAVOFF.." - "..LOOKLOCK_CONFIG_AREAVOFF_INFO.."\n"..
		"\n"..
		"See page 3 for a list of slash commands.",

		"Sichtsperre\n"..
		"\n"..
		"Von: Mugendai\n"..
		"Besonderen Dank an:\n"..
		"    Skrag und iecur die mir zeigten wie dies hier zu realisieren ist.\n"..
		"\n"..
		"Kontakt: mugekun@gmail.com"
	};

end