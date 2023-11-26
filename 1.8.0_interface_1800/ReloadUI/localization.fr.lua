-- Version : French ( by Sasmira )
-- Last Update : 06/09/2005

if ( GetLocale() == "frFR" ) then

BINDING_HEADER_RELOADUI	= "Reload Interface";
BINDING_NAME_RELOADUI	= "Reload User Interface";

-- Chat Configuration
RELOAD_COMMANDS		= {"/rl", "/reloadui", "/reload", "/rel", "/reboot"};
RELOAD_COMMANDS_DESC	= "/reloadui - Recharge de l\'interface Utilisateur. Utile lorsque vous ne pouvez pas trouver votre cadavre.";
RELOAD_CANCEL_COMMANDS	= {"/reloadcancel", "/reloaduicancel", "/rlc", "/relc", "/rebootcancel"};
RELOAD_CANCEL_COMMANDS_DESC = "/reloaduicancel (/rlc) - Annule un rechargement d\'ui. S\'execute seulement si c\'est tap\195\169 dans la seconde du /reloadui.";

RELOAD_WARNING = "Rechargement de l\'interface Utilisateur dans %d secondes. Taper /rlc pour annuler.";
RELOAD_CANCEL = "Rechargement Annul\195\169.";

end
