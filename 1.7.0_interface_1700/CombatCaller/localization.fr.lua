-- Version : French ( by Elzix, Sasmira, Flisher )
-- Last Update : 08/07/2005

if ( GetLocale() == "frFR" ) then
   
   -- Cosmos Configuration
   COMBATC_SEP                = "Combat Caller"; -- Message d'alerte is cut in Khaos
   COMBATC_SEP_INFO           = "Si vous votre mana/vie descend en dessous d\'un certain seuil, un message sonore sera lanc\195\169e.";
   COMBATC_HEALTH             = "Activer l\'alerte : vie faible";
   COMBATC_HEALTH_INFO        = "Averti automatiquement votre groupe lorsque votre vie \ndescend en dessous d\'un seuil d\195\169fini.";
   COMBATC_HEALTH_LIMIT       = "Seuil de vie";
   COMBATC_MANA               = "Activer l\'alerte : mana faible";
   COMBATC_MANA_INFO          = "Averti automatiquement votre groupe lorsque votre mana \ndescend en dessous d\'un seuil d\195\169fini.";
   COMBATC_MANA_LIMIT         = "Seuil de mana";
   COMBATC_COOL               = "Activer le d\195\169lais d\'alerte";
   COMBATC_COOL_INFO          = "Dur\195\169e minimum en secondes entre deux m\195\170mes avertissements\n(Points de vie ou de mana).";
   COMBATC_COOL_LIMIT         = "D\195\169lais";
   COMBATC_COOL_SEC           = " sec";

   COMBATC_PET_HEALTH         = "Activer l\'alerte : Vie du familier";
   COMBATC_PET_HEALTH_LIMIT   = "Seuil";
   COMBATC_PET_HEALTH_INFO    = "Notifie automatiquement par un message sonore, \nle niveau de vie du Familier dans le groupe.";
   COMBATC_PET_SHOUT1         = "averti que son familier ";
   COMBATC_PET_SHOUT2         = " \195\160 besoin de soins !";

   COMBATC_FEEDBACK =
{
   player =
   {
      hp    = "Combat Caller criera \195\160 partir de %s de vie, plus souvent qu\'une fois toutes les %s secondes.";
      mana  = "Combat Caller criera \195\160 partir de %s de mana, plus souvent qu\'une fois toutes les %s secondes.";
   };
   pet =
   {
      hp = "Combat Caller criera \195\160 partir de %s de vie du familier, plus souvent qu\'une fois toutes les %s secondes.";
   };
   COOLDOWN = "Combat Caller criera plus souvent qu\'une fois toutes les %s secondes.";
   INSERT   = "\195\160 %s%%";
   NEVER    = "Jamais";
};

COMBATC_SLIDER_STRING      = "%s%%";
   
end
