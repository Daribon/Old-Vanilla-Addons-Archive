--[[
   Version: $Rev: 2025 $
   Last Changed by: $LastChangedBy: Sinaloit $
   Date: $Date: 2005-07-02 19:51:34 -0400 (Sat, 02 Jul 2005) $

   Note: Please don't remove commented line and change the layout of this file, the main goal is to have 3 localization files with the same layout for easy spotting of missing information.
   The SVN tag at the begining of the file will automaticaly update upon uploading.
]]--

if (GetLocale() == "frFR") then

   -- Configuration variables
   --   SLASH_CHARACTERSVIEWER1                    = "/charactersviewer";
   --   SLASH_CHARACTERSVIEWER2                    = "/cv";
   --   CHARACTERSVIEWER_SUBCMD_SHOW               = "show";
   --   CHARACTERSVIEWER_SUBCMD_CLEAR              = "clear";
   --   CHARACTERSVIEWER_SUBCMD_CLEARALL           = "clearall";
   --   CHARACTERSVIEWER_SUBCMD_PREVIOUS           = "previous";
   --   CHARACTERSVIEWER_SUBCMD_NEXT               = "next";
   --   CHARACTERSVIEWER_SUBCMD_SWITCH             = "switch";

   -- Localization text
   BINDING_HEADER_CHARACTERSVIEWER                 = "Characters Viewer";
   BINDING_NAME_CHARACTERSVIEWER_TOGGLE            = "Ouvrir/Fermer CharactersViewer";
   BINDING_NAME_CHARACTERSVIEWER_SWITCH_PREVIOUS   = "Changer pour le personnage pr\195\169c\195\169dant";
   BINDING_NAME_CHARACTERSVIEWER_SWITCH_NEXT       = "Changer pour le personnage suivant";

   CHARACTERSVIEWER_CRIT                           = "Critique";

   CHARACTERSVIEWER_SELPLAYER                      = "Changer";
   CHARACTERSVIEWER_DROPDOWN2                      = "Comparer";
   CHARACTERSVIEWER_TOOLTIP_BAGRESET               = "Clic-Gauche : Affiche/cache les sacs.\nClic-Droit : Repositionne les sacs."
   CHARACTERSVIEWER_TOOLTIP_DROPDOWN2              = "Choisir un autre de vos personnages \195\160 comparer.";

   CHARACTERSVIEWER_PROFILECLEARED                 = "Le profil suivant a \195\169t\195\169 supprim\195\169 : ";
   CHARACTERSVIEWER_ALLPROFILECLEARED              = "Tous les profils de tous les serveurs ont \195\169t\195\169 effac\195\169. Le profil du personnage actuel \195\160 \195\169t\195\169 ajout\195\169";
   CHARACTERSVIEWER_NOT_FOUND                      = "Personnage non-trouv�: ";

   CHARACTERSVIEWER_USAGE                          = ": '/cv <commande>' ou  <commande> est";
   CHARACTERSVIEWER_USAGE_SUBCMD                   = {};
   CHARACTERSVIEWER_USAGE_SUBCMD[1]                = " show : Affiche les \195\169quipments et statistiques dans une fen\195\170tre";
   CHARACTERSVIEWER_USAGE_SUBCMD[2]                = " clear <arg1> : Efface le profile du personnage <arg1>";
   CHARACTERSVIEWER_USAGE_SUBCMD[3]                = " clearall : Efface tous vos profils de tous les serveurs";
   CHARACTERSVIEWER_USAGE_SUBCMD[4]                = " previous : " .. BINDING_NAME_CHARACTERSVIEWER_SWITCH_PREVIOUS;
   CHARACTERSVIEWER_USAGE_SUBCMD[5]                = " next : " .. BINDING_NAME_CHARACTERSVIEWER_SWITCH_NEXT;
   CHARACTERSVIEWER_USAGE_SUBCMD[6]                = " switch <arg1> : Changer au personnage <arg1>";

   CHARACTERSVIEWER_DESCRIPTION                    = "Affiche l\'\195\169quipement, l\'inventaire et les statistiques de vos autres personnages";
   CHARACTERSVIEWER_SHORT_DESC                     = "Active/D\195\169sactive CV";
   -- CHARACTERSVIEWER_ICON                           = "Interface\\Buttons\\Button-Backpack-Up";
   
end
