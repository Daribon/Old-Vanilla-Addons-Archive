-- Configuration variables
SLASH_BANKSTATEMENT1                    = "/bankstatement";
SLASH_BANKSTATEMENT2                    = "/bs";
SLASH_BANKSTATEMENT3                    = "/bstate";
BANKSTATEMENT_SUBCMD_LIST               = "list";
BANKSTATEMENT_SUBCMD_SHOW               = "show";
BANKSTATEMENT_SUBCMD_SHOWALL            = "showall";
BANKSTATEMENT_SUBCMD_CLEAR              = "clear";
BANKSTATEMENT_SUBCMD_CLEARALL           = "clearall";
BINDING_HEADER_BANKSTATEMENT            = "BankStatement Bindings";
BINDING_NAME_TOGGLEBANKSTATEMENT        = "Toggle BankStatement";
BINDING_NAME_TOGGLEBANKSTATEMENTALL     = "Toggle BankStatement and all Bags";

-- Constants
BANKSTATEMENT_MSG_EMPTY                 = "Bank Statement is empty. Please visit your local bank to update.";
BANKSTATEMENT_USAGE                     = "Usage: '/bankstatement <command>' where <command> is";
BANKSTATEMENT_USAGE_SUBCMD              = {};
BANKSTATEMENT_USAGE_SUBCMD[1]           = " list : displays bank items as a list in the chat window";
BANKSTATEMENT_USAGE_SUBCMD[2]           = " show : displays bank items in a Bank window";
BANKSTATEMENT_USAGE_SUBCMD[3]           = " showall : displays bank items in a Bank window and opens all Bags";
BANKSTATEMENT_USAGE_SUBCMD[4]           = " clear : clears all stored bank items for current character";
BANKSTATEMENT_USAGE_SUBCMD[5]           = " clearall : clears all stored bank items for all chars in all servers";

BANKSTATEMENT_SELPLAYER                 = "Select Player";
BANKSTATEMENT_PLAYERITEMSCLEARED        = "Stored bank items for %s have been cleared.";
BANKSTATEMENT_ALLPLAYERITEMSCLEARED     = "Stored bank items for all players have been cleared.";
BANKSTATEMENT_BANKITEM                  = "Bank Item ";
BANKSTATEMENT_BANKBAG                   = "Bank Bag ";
BANKSTATEMENT_ITEM                      = " Item ";
BANKSTATEMENT_ON                        = " on ";



if ( GetLocale() == "frFR" ) then
    -- Traduit par Juki <Unskilled>
    
    -- Configuration variables
    SLASH_BANKSTATEMENT1                    = "/bankstatement";
    SLASH_BANKSTATEMENT2                    = "/bs";
    SLASH_BANKSTATEMENT3                    = "/bstate";
    BANKSTATEMENT_SUBCMD_LIST               = "list";
    BANKSTATEMENT_SUBCMD_SHOW               = "show";
    BANKSTATEMENT_SUBCMD_SHOWALL            = "showall";
    BANKSTATEMENT_SUBCMD_CLEAR              = "clear";
    BANKSTATEMENT_SUBCMD_CLEARALL           = "clearall";
    BINDING_HEADER_BANKSTATEMENT            = "Raccourcis BankStatement";
    BINDING_NAME_TOGGLEBANKSTATEMENT        = "Afficher/Masquer BankStatement";
    BINDING_NAME_TOGGLEBANKSTATEMENTALL     = "Afficher/Masquer BankStatement et tous les sacs";
    
    -- Constants
    BANKSTATEMENT_MSG_EMPTY                 = "BankStatement est vide. Allez voir votre banque pour mettre à jour.";
    BANKSTATEMENT_USAGE                     = "Utilisation : '/bankstatement <commande>' où <commande> est :";
    BANKSTATEMENT_USAGE_SUBCMD              = {};
    BANKSTATEMENT_USAGE_SUBCMD[1]           = " list : Affiche les objets de votre banque sous la forme d'une liste dans la fenêtre de discussion";
    BANKSTATEMENT_USAGE_SUBCMD[2]           = " show : Affiche les objets de votre banque";
    BANKSTATEMENT_USAGE_SUBCMD[3]           = " showall : Affiche les objets de votre banque et ouvre tous les sacs";
    BANKSTATEMENT_USAGE_SUBCMD[4]           = " clear : Effacer les données BankStatement pour ce personnage";
    BANKSTATEMENT_USAGE_SUBCMD[5]           = " clearall : Effacer les données BankStatement pour tous vos personnages sur tous les serveurs";
    
    BANKSTATEMENT_SELPLAYER                 = "Choisir Personnage";
    BANKSTATEMENT_PLAYERITEMSCLEARED        = "Les données BankStatement du personnage %s ont été effacées.";
    BANKSTATEMENT_ALLPLAYERITEMSCLEARED     = "Les données BankStatement de tous vos personnages sur tous les serveurs ont été effacées.";
    BANKSTATEMENT_BANKITEM                  = "Objet Banque ";
    BANKSTATEMENT_BANKBAG                   = "Sac Banque ";
    BANKSTATEMENT_ITEM                      = " Objet ";
    BANKSTATEMENT_ON                        = " sur ";


    
end
