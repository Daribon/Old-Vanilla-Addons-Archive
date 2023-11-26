-- Version : French ( by Vjeux, Sasmira )
-- Last Update : 03/21/2005

if ( GetLocale() == "frFR" ) then

-- UltimateUI COnfiguration
ITEMBUFF_SEP					= "Buff d\'Equipement";
ITEMBUFF_CHECK					= "Afficher les buffs temporaires";
ITEMBUFF_CHECK_INFO				= "En choisissant cette option, vous verrez les buffs de vos objets \195\169quip\195\169s en bas \195\160 droite de votre \195\169cran.";
ITEMBUFF_CANTUPDATE				= "Impossible de mettre \195\160 jour quand vous faites votre shopping.";

ITEMBUFF_SMALL_ICONS				= "Afficher les buffs en petits icones";
ITEMBUFF_SMALL_ICONS_INFO			= "Affiche les buffs sous forme d\'icones plus petits.";

ITEMBUFF_DISPLAY_BUFFNAME			= "Afficher le nom et le temps restant des Buffs";
ITEMBUFF_DISPLAY_BUFFNAME_INFO			= "Affiche le nom et le temps restant correspondant \195\160 chaque icone de Buffs.";

ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY		= "Afficher le temps restant sous le nom des Buffs";
ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY_INFO	= "Affiche sur la droite, le temps restant sous le nom des Buffs";


-- Chat Configuration
ITEMBUFF_CHAT_COMMAND_INFO	= "Controle le : "..ITEMBUFF_SEP..".";

ITEMBUFF_HELP			= "help";		-- must be lowercase; displays help
ITEMBUFF_STATUS			= "status";		-- must be lowercase; shows status
ITEMBUFF_FREEZE			= "freeze";		-- must be lowercase; freezes the window in position
ITEMBUFF_UNFREEZE		= "unfreeze";		-- must be lowercase; unfreezes the window so that it can be dragged
ITEMBUFF_RESET			= "reset";		-- must be lowercase; resets the window to its default position

ITEMBUFF_STATUS_HEADER		= "|cffffff00Buff d\'Equipement, Etat :|r";
ITEMBUFF_FROZEN			= "Buff d\'Equipement : Bloqu\195\169 sur place";
ITEMBUFF_UNFROZEN		= "Buff d\'Equipement : D\195\169bloqu\195\169 et peut bouger";
ITEMBUFF_RESET_DONE		= "Buff d\'Equipement : Position r\195\169initialiser par d\195\169faut";

ITEMBUFF_HELP_TEXT0		= " ";
ITEMBUFF_HELP_TEXT1		= "|cffffff00Buff d\'Equipement, Aide au ligne de commandes :|r";
ITEMBUFF_HELP_TEXT2		= "|cff00ff00Use |r|cffffffff/itembuff <command>|r|cff00ff00 ou |r|cffffffff/ib <command>|r|cff00ff00 pour avoir la suite des commandes:|r";
ITEMBUFF_HELP_TEXT3		= "|cffffffff"..ITEMBUFF_HELP.."|r|cff00ff00: Affiche ce message.|r";
ITEMBUFF_HELP_TEXT4		= "|cffffffff"..ITEMBUFF_STATUS.."|r|cff00ff00: Affiche les informations sur l\'\195\169tat des options actuelles.|r";
ITEMBUFF_HELP_TEXT5		= "|cffffffff"..ITEMBUFF_FREEZE.."|r|cff00ff00: Verrouiller la fen\195\170tre.|r";
ITEMBUFF_HELP_TEXT6		= "|cffffffff"..ITEMBUFF_UNFREEZE.."|r|cff00ff00: D\195\169verrouiller la fen\195\170tre.|r";
ITEMBUFF_HELP_TEXT7		= "|cffffffff"..ITEMBUFF_RESET.."|r|cff00ff00: r\195\169initialise la position de la fen\195\170tre par d\195\169faut.|r";
ITEMBUFF_HELP_TEXT8		= " ";
ITEMBUFF_HELP_TEXT9		= "|cff00ff00Pour exemple: |r|cffffffff/itembuff freeze|r|cff00ff00 Emp\195\170chera la fen\195\170tre d\'\195\170tre d\195\169plac\195\169 par la souris.|r";

-- Localisation Strings
ITEMBUFF_ENCHANT_TIME_LEFT_MINUTES	= "%(%d+ min%)";	-- Enchantment name, followed by the time left in minutes
ITEMBUFF_ENCHANT_TIME_LEFT_SECONDS	= "%((%d+) sec%)";	-- Enchantment name, followed by the time left in seconds

ItemBuff_HideBuffsFromTheseItems = {
	"Pierre de feu",
	"Pierre de feu sup\195\169rieure",
	"Pierre de feu mineure",
	"Pierre de feu majeure",
	"Windfury Totem"
};

-- non localised strings
-- DO NOT TRANSLATE OR CHANGE
ITEMBUFF_HELP_TEXT = {
	ITEMBUFF_HELP_TEXT0,
	ITEMBUFF_HELP_TEXT1,
	ITEMBUFF_HELP_TEXT2,
	ITEMBUFF_HELP_TEXT3,
	ITEMBUFF_HELP_TEXT4,
	ITEMBUFF_HELP_TEXT5,
	ITEMBUFF_HELP_TEXT6,
	ITEMBUFF_HELP_TEXT7,
	ITEMBUFF_HELP_TEXT8,
	ITEMBUFF_HELP_TEXT9,
};
end