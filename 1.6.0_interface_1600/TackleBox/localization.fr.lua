-- Version : French  ( by Elzix, Sasmira )
-- Last Update : 03/22/2005

if ( GetLocale() == "frFR" ) then

-- <= == == == == == == == == == == == == =>
-- => UltimateUI Configuration Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_CONFIG_SECTION			= "Boite du P\195\170cheur";
TACKLEBOX_CONFIG_SECTION_INFO			= "Permet de rendre plus intuitif la p\195\170che.";
TACKLEBOX_CONFIG_EASYCAST_ONOFF			= "P\195\170che facile";
TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO		= "Quand une canne \195\160 p\195\170che est \195\169quip\195\169e, permet de lancer la ligne par un clic droit.";
TACKLEBOX_CONFIG_FASTCAST_ONOFF			= "P\195\170che rapide";
TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO		= "Si activ\195\169, vous pouvez lancer votre ligne au m\195\170me moment que vous cliquez sur le bouchon.";
TACKLEBOX_CONFIG_SWITCH_ONOFF			= "Macro d\'\195\169quipement";
TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO		= "Une macro pour changer facilement entre votre \195\169quipement, sera ajout\195\169e \195\160 votre liste de macros.";

-- <= == == == == == == == == == == == == =>
-- => Chat Command Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_CHAT_COMMAND_INFO		= "Utiliser /tb ou /tacklebox pour les informations d\'utilisation.";
TACKLEBOX_CHAT_COMMAND_HELP = {};
TACKLEBOX_CHAT_COMMAND_HELP[1]		= "Utiliser /tacklebox ou /tb [option][on/off]";
TACKLEBOX_CHAT_COMMAND_HELP[2]		= "easycast - "..TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO;
TACKLEBOX_CHAT_COMMAND_HELP[3]		= "fastcast - "..TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO;
TACKLEBOX_CHAT_COMMAND_HELP[4]		= "switch - Permet de s\'\195\169quiper rapidement de sa canne \195\160 p\195\170che.";
TACKLEBOX_CHAT_COMMAND_HELP[5]		= "Exemple: /tb easycast on";

-- <= == == == == == == == == == == == == =>
-- => Output Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_OUTPUT_SET_POLE			= "Canne \195\160 p\195\170che affect\195\169e \195\160 %s.";
TACKLEBOX_OUTPUT_SET_MAIN			= "Arme principale affect\195\169e \195\160 %s.";
TACKLEBOX_OUTPUT_SET_SECONDARY			= "Arme secondaire affect\195\169e \195\160 %s.";
TACKLEBOX_OUTPUT_SET_FISHING_HAT		= "Chapeau de p\195\170che affect\195\169 \195\160  %s.";
TACKLEBOX_OUTPUT_SET_HAT			= "Casque affect\195\169 \195\160 ";
TACKLEBOX_OUTPUT_NEED_SET_POLE			= "Equipez vous de la canne \195\160 p\195\170che que vous voulez utiliser, et ensuite recommencer.";
TACKLEBOX_OUTPUT_NEED_SET_HAND			= "Equipez vous de l\'arme que vous voulez utiliser, et ensuite recommencer.";
TACKLEBOX_OUTPUT_ENABLED			= "%s activ\195\169";
TACKLEBOX_OUTPUT_DISABLED			= "%s d\195\169sactiv\195\169";
TACKLEBOX_OUTPUT_EASYCAST		= TACKLEBOX_CONFIG_EASYCAST_ONOFF;
TACKLEBOX_OUTPUT_FASTCAST		= TACKLEBOX_CONFIG_FASTCAST_ONOFF;
TACKLEBOX_OUTPUT_SWITCH		= TACKLEBOX_CONFIG_SWITCH_ONOFF;
TACKLEBOX_OUTPUT_ALT		= TACKLEBOX_CONFIG_ALT_ONOFF;
TACKLEBOX_OUTPUT_CTRL		= TACKLEBOX_CONFIG_CTRL_ONOFF;
TACKLEBOX_OUTPUT_SHIFT		= TACKLEBOX_CONFIG_SHIFT_ONOFF;

-- <= == == == == == == == == == == == == =>
-- => Other Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_MACRO_NAME			= "Boite du P\195\170cheur";

-- <= == == == == == == == == == == == == =>
-- => Bindings
-- <= == == == == == == == == == == == == =>
BINDING_HEADER_TACKLEBOXHEADER		= "Boite du P\195\170cheur";
BINDING_NAME_TACKLEBOX_THROW		= "D\195\169buter la p\195\170che";

end