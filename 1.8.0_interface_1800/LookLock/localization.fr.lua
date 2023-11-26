-- Version : French ( by Sasmira )
-- Last Update : 03/22/2005

if ( GetLocale() == "frFR" ) then

-- <= == == == == == == == == == == == == =>
-- => Bindings Names
-- <= == == == == == == == == == == == == =>
BINDING_HEADER_LOOKLOCKHEADER		= "Vue FPS";
BINDING_NAME_LOOKLOCK			= "Marche/Arr\195\170t Vue FPS";
BINDING_NAME_LOOKLOCKPUSH		= "Vue FPS : Appuyer";
BINDING_NAME_LOOKLOCKACTION		= "Vue FPS : Action";
BINDING_NAME_LOOKLOCKCAMERA		= "Vue FPS : Cam\195\169ra";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Configuration Strings
-- <= == == == == == == == == == == == == =>
LOOKLOCK_CONFIG_HEADER			= "Vue FPS";
LOOKLOCK_CONFIG_HEADER_INFO		= "Configuration des options de Vue FPS ";
LOOKLOCK_CONFIG_REMAP_ONOFF		= "Assigner les boutons de la Souris \195\160 Vue FPS.";
LOOKLOCK_CONFIG_REMAP_ONOFF_INFO	= "Permet un meilleur comportement des boutons de souris \195\160 l\'aide de Vue FPS.";
LOOKLOCK_CONFIG_STRAFE_ONOFF		= "D\195\169placements lat\195\169raux sur la Souris.";
LOOKLOCK_CONFIG_STRAFE_ONOFF_INFO	= "Les boutons Droite et Gauche deviennent les d\195\169placements lat\195\169raux en Vue FPS.";
LOOKLOCK_CONFIG_ALWAYS_ONOFF		= "Toujours Bloqu\195\169 ( Hautement Exp\195\169rimental )";
LOOKLOCK_CONFIG_ALWAYS_ONOFF_INFO	= "Laisse tout le temps la Souris en mode Vue FPS, Clic de Droite pour retourner en mode normal.";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Chat Command Strings
-- <= == == == == == == == == == == == == =>
LOOKLOCK_CHAT_COMMAND_INFO		= "Taper /looklock ou /ll pour avoir l\aide.";
LOOKLOCK_CHAT_COMMAND_HELP		= {};
LOOKLOCK_CHAT_COMMAND_HELP[1]		= "Taper /looklock ou /ll plus l\'option suivi de on/off";
LOOKLOCK_CHAT_COMMAND_HELP[2]		= "Exemple: /ll remap on";
LOOKLOCK_CHAT_COMMAND_HELP[3]		= "remap - on/off, pour assigner les boutons de la Souris \195\160 Vue FPS.";
LOOKLOCK_CHAT_COMMAND_HELP[4]		= "strafe - on/off, pour que les boutons Droite et Gauche deviennent les d\195\169placements lat\195\169raux en Vue FPS.";
LOOKLOCK_CHAT_COMMAND_HELP[5]		= "reset - R\195\169initialisation des boutons de la Souris a leur configuration par d\195\169faut.";
LOOKLOCK_CHAT_COMMAND_HELP[6]		= "always - Laisse tout le temps la Souris en mode Vue FPS, Clic de Droite pour retourner en mode normal.";

-- <= == == == == == == == == == == == == =>
-- => Chat Strings
-- <= == == == == == == == == == == == == =>
LOOKLOCK_CHAT_REMAP_ON			= "Vue FPS : Assignation des boutons de la Souris activ\195\169e.";
LOOKLOCK_CHAT_REMAP_OFF			= "Vue FPS : Assignation des boutons de la Souris d\195\169sactiv\195\169e.";
LOOKLOCK_CHAT_STRAFE_ON			= "Vue FPS : D\195\169placements lat\195\169raux activ\195\169s.";
LOOKLOCK_CHAT_STRAFE_OFF		= "Vue FPS : D\195\169placements lat\195\169raux d\195\169sactiv\195\169s.";
LOOKLOCK_CHAT_ALWAYS_ON			= "Vue FPS : Toujours Bloqu\195\169 activ\195\169.";
LOOKLOCK_CHAT_ALWAYS_OFF		= "Vue FPS : Toujours Bloqu\195\169 d\195\169sactiv\195\169.";
LOOKLOCK_CHAT_FIX_DONE			= "Vue FPS :  R\195\169initialisation des boutons de la Souris a leur configuration par d\195\169faut.";

end