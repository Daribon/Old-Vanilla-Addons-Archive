-- Version : English - sarf

BINDING_HEADER_CHATTSHEADER			= "Chat TimeStamps";
BINDING_NAME_CHATTS					= "Chat TimeStamps Toggle";

CHATTS_CONFIG_HEADER				= "Chat TimeStamps";
CHATTS_CONFIG_HEADER_INFO			= "These options configure the Chat TimeStamps.";
CHATTS_CONFIG_ENABLED				= "Enable Chat TimeStamps.";
CHATTS_CONFIG_ENABLED_INFO			= "Adds timestamps to the chat windows.\nIf the clock is installed it uses the clock's format and offset\notherwise server time is used.";
CHATTS_CONFIG_SEPARATOR				= "Use > as a separator character.";
CHATTS_CONFIG_SEPARATOR_INFO		= "Adds > to separate the text from the timestamp";

CHATTS_FORMAT_STRING				= "%02d:%02d";

if ( GetLocale() == "frFR" ) then
	-- Traduction par Vjeux

	BINDING_HEADER_CHATTSHEADER			= "Indicat'Heure";
	BINDING_NAME_CHATTS					= "Activer/Désactiver l'Indicat'Heure";

	CHATTS_CONFIG_HEADER				= "Indicat'Heure";
	CHATTS_CONFIG_HEADER_INFO			= "Cette option permet d'ajouter l'heure devant chaque message.";
	CHATTS_CONFIG_ENABLED				= "Activer l'ajout de l'heure.";
	CHATTS_CONFIG_ENABLED_INFO			= "Ajouter l'heure devant chaque message. Si vous utilisez l'horloge, cela utilisera par défaut le format de celle-ci, sinon, l'heure du serveur est affichée.";
	CHATTS_CONFIG_SEPARATOR				= "Utiliser '>' après l'heure.";
	CHATTS_CONFIG_SEPARATOR_INFO		= "Si cette option est activée, un '>' sera placé après l'heure pour la séparer du message.";

elseif ( GetLocale() == "deDE" ) then
	-- Translation by pc

	BINDING_HEADER_CHATTSHEADER		= "Chatnachrichten Zeitanzeige";
	BINDING_NAME_CHATTS				= "Aktiviere/Deaktiviere Zeitanzeige";

	CHATTS_CONFIG_HEADER			= "Chatnachrichten Zeitanzeige";
	CHATTS_CONFIG_HEADER_INFO		= "Diese Einstellungen erlauben die Konfiguration der Chatnachrichten Zeitanzeige.";
	CHATTS_CONFIG_ENABLED			= "Aktiviere Chatnachrichten Zeitanzeige";
	CHATTS_CONFIG_ENABLED_INFO		= "Fügt zu jeder Chatnachricht die Zeit hinzu.\n Wenn die Uhr installiert ist wird deren Zeitformat, wenn nicht das Serverzeitformat benutzt.";
	CHATTS_CONFIG_SEPARATOR			= "Benutze '>' als Abstandhalter";
	CHATTS_CONFIG_SEPARATOR_INFO	= "Wenn aktivert, wird die Nachricht von der Urzeit jeweils durch ein '>' getrennt";

end