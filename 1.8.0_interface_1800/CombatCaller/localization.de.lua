-- Version : German (by DrVanGogh, StarDust)
-- Last Update : 08/16/2005

if ( GetLocale() == "deDE" ) then

	-- Cosmos Configuration
	COMBATC_SEP			= "Kampfrufer";
	COMBATC_SEP_INFO		= "Diese Einstellungen definieren, wann ein automatischer Hilferuf erfolgt.";
	COMBATC_HEALTH			= "Warnung bei niedriger Gesundheit";
	COMBATC_HEALTH_INFO		= "L\195\182st automatisch das '/v healme' Sprachemote aus, wenn die Gesundheit unter den angegebenen Prozentsatz f\195\164llt.";
	COMBATC_HEALTH_LIMIT		= "Schwellwert Gesundheit";
	COMBATC_MANA			= "Warnung bei niedrigem Mana";
	COMBATC_MANA_INFO		= "L\195\182st automatisch das '/v oom' Sprachemote aus, wenn das Mana unter den angegebenen Prozentsatz f\195\164llt.";
	COMBATC_MANA_LIMIT		= "Schwellwert Mana";
	COMBATC_COOL			= "Abklingzeit zwischen Hilferufen";
	COMBATC_COOL_INFO		= "Gibt die Zeit in Sekunden an, welche mindestens zwischen zwei Hilferufen vergehen mu\195\159. Schwellwerte f\195\188r Gesundheit und Mana werden getrennt eingestellt.";
	COMBATC_COOL_LIMIT		= "Abklingzeit";
	COMBATC_COOL_SEC		= " Sek.";

	COMBATC_PET_HEALTH		= "Warnung bei niedriger\nGesundheit des Pets";
	COMBATC_PET_HEALTH_LIMIT	= "Schwellwert";
	COMBATC_PET_HEALTH_INFO		= "Informiert Gruppenmitglieder automatisch, wenn die Gesundheit des Pets unter den angegebenen Prozentsatz f\195\164llt.";
	COMBATC_PET_SHOUT1		= "warnt, da\195\159 das Pet ";
	COMBATC_PET_SHOUT2		= " ben\195\182tigt Heilung!";

	COMBATC_FEEDBACK =
	{
	   player =
	   {
	      hp	= "Der Kampfrufer wird bei %s Gesundheit nur einmal alle %s Sekunden rufen.";
	      mana	= "Der Kampfrufer wird bei %s Mana nur einmal alle %s Sekunden rufen.";
	   };
	   pet =
	   {
	      hp	= "Der Kampfrufer wird bei %s Gesundheit des Pet nur einmal alle %s Sekunden rufen.";
	   };
	   COOLDOWN	= "Der Kampfrufer wird nur einmal alle %s Sekunden rufen.";
	   INSERT	= "bei %s%%";
	   NEVER	= "niemals";
	};

	COMBATC_SLIDER_STRING		= "%s%%";

end