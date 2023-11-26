-- Version : English - ?????

PARTYDISTANCE_SEP			= "Party Distance";
PARTYDISTANCE_SEP_INFO		= "These options involve the indicator displaying the\n distance to your party members.";
PARTYDISTANCE_CHECK 		= "Show party distance";
PARTYDISTANCE_CHECK_INFO	= "Shows a panel which displays the distance to your target";
PARTYDISTANCE_DISTANCE		= "Distance: %d yds";

if ( GetLocale() == "frFR" ) then
--[[
	PARTYDISTANCE_SEP				= "Distance Cible";
	PARTYDISTANCE_SEP_INFO			= "Permet de configurer l'affichage de la distance de la cible";
	PARTYDISTANCE_CHECK 			= "Afficher la distance de la cible";
	PARTYDISTANCE_CHECK_INFO		= "Indique sur l'écran la distance vous séparant de votre cible";
	PARTYDISTANCE_DISTANCE			= "Distance: %d yds";	
]]--
elseif ( GetLocale() == "deDE" ) then
	-- Translatin by pc
--[[

	PARTYDISTANCE_SEP				= "Ziel Mod";
	PARTYDISTANCE_SEP_INFO			= "Diese Einstellungen modifizieren die Anzeige der Entfernung zum ausgewählten Ziel.";
	PARTYDISTANCE_CHECK			= "Zeige Entfernung zum Ziel";
	PARTYDISTANCE_CHECK_INFO		= "Zeigt ein Feld das die Entfernung zum ausgewählten Ziel angibt";
	PARTYDISTANCE_DISTANCE			= "Entfernung: %d yds";
]]--
end
