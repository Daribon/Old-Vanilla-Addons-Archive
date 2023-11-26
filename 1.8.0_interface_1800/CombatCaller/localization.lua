-- Version : English (by Alex Brazie)
-- Last Update : 06/20/2005

-- Cosmos Configuration
COMBATC_SEP                = "Combat Caller";
COMBATC_SEP_INFO           = "These settings define when an automatic\n help voice command is executed.";
COMBATC_HEALTH             = "Auto Low Health Shout";
COMBATC_HEALTH_INFO        = "Automatically notifies your party\n when your health drops below a certain level.";
COMBATC_HEALTH_LIMIT       = "Health Limit";
COMBATC_MANA               = "Auto Out Of Mana Shout";
COMBATC_MANA_INFO          = "Automatically notifies your party\n when your mana drops to the specified level.";
COMBATC_MANA_LIMIT         = "Mana Limit";
COMBATC_COOL               = "Auto Shout Cooldown";
COMBATC_COOL_INFO          = "Minimum number of seconds between shouts\nKept track of seperately for HP and mana.";
COMBATC_COOL_LIMIT         = "Cooldown";
COMBATC_COOL_SEC           = " sec";

COMBATC_PET_HEALTH         = "Auto Low Pet Health Shout";
COMBATC_PET_HEALTH_LIMIT   = "Pet Healt Limit";
COMBATC_PET_HEALTH_INFO    = "Automatically notifies your party\n when your pet health drops below a certain level.";
COMBATC_PET_SHOUT1         = "warns that is pet ";
COMBATC_PET_SHOUT2         = " need healing!";

COMBATC_FEEDBACK =
{
   player =
   {
      hp    = "Combat Caller will shout out of health %s, no more often than once every %s seconds.";
      mana  = "Combat Caller will shout out of mana %s, no more often than once every %s seconds.";
   };
   pet =
   {
      hp = "Combat Caller will shout out Pet of health at %s, no more often than once every %s seconds.";
   };
   COOLDOWN = "Combat Caller will shout no more often than once per %s seconds.";
   INSERT   = "at %s%%";
   NEVER    = "never";
};

COMBATC_SLIDER_STRING      = "%s%%";

