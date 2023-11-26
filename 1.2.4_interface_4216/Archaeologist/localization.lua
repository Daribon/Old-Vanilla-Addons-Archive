--------------------------------------------------------------------------
-- localization.lua 
--------------------------------------------------------------------------

PLAYER_GHOST 						= "Ghost";
PLAYER_WISP 						= "Wisp";

ARCHAEOLOGIST_CONFIG_SEP				= "Archaeologist";
ARCHAEOLOGIST_CONFIG_SEP_INFO			= "Archaeologist Settings";

-- <= == == == == == == == == == == == == =>
-- => Player Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PLAYER_SEP				= "Player Status Bar Settings";
ARCHAEOLOGIST_CONFIG_PLAYER_SEP_INFO		= "Most values, by default, can be seen on mouseover.";
		
ARCHAEOLOGIST_CONFIG_PLAYERHP		= "Always Display Player Health";
ARCHAEOLOGIST_CONFIG_PLAYERHP_INFO = "Turns on the number for the player health bar.";
ARCHAEOLOGIST_CONFIG_PLAYERMP		= "Always Display Player Mana";
ARCHAEOLOGIST_CONFIG_PLAYERMP_INFO = "Turns on the number for the player mana bar.";
ARCHAEOLOGIST_CONFIG_PLAYERXP		= "Always Display Player Experience";
ARCHAEOLOGIST_CONFIG_PLAYERXP_INFO = "Turns on the number for the player experience bar.";
ARCHAEOLOGIST_CONFIG_PLAYERHPP			= "Percentage value on the Player Health bar";
ARCHAEOLOGIST_CONFIG_PLAYERHPP_INFO	= "";
ARCHAEOLOGIST_CONFIG_PLAYERMPP			= "Percentage value on the Player Mana bar";
ARCHAEOLOGIST_CONFIG_PLAYERMPP_INFO	= "";
ARCHAEOLOGIST_CONFIG_PLAYERXPP			= "Percentage value on the Player XP bar";
ARCHAEOLOGIST_CONFIG_PLAYERXPP_INFO	= "";
ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE		= "Hide Player Health Prefix";
ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the player health bar.";
ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE		= "Hide Player Mana Prefix";
ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the player mana bar.";
ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE		= "Hide Player XP Prefix";
ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE_INFO	= "Turns off the 'XP' prefix on the player xp bars.";

-- <= == == == == == == == == == == == == =>
-- => Party Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PARTY_SEP				= "Party Status Bar Settings";
ARCHAEOLOGIST_CONFIG_PARTY_SEP_INFO			= "Most values, by default, can be seen on mouseover.";

ARCHAEOLOGIST_CONFIG_PARTYHP				= "Always Display Party Health";
ARCHAEOLOGIST_CONFIG_PARTYHP_INFO			= "Turns on the number for the party's health bars.";
ARCHAEOLOGIST_CONFIG_PARTYMP				= "Always Display Party Mana";
ARCHAEOLOGIST_CONFIG_PARTYMP_INFO			= "Turns on the number for the party's secondary bars.";
ARCHAEOLOGIST_CONFIG_PARTYHPP				= "Percentage value on the Party Members Health bar";
ARCHAEOLOGIST_CONFIG_PARTYHPP_INFO			= "";
ARCHAEOLOGIST_CONFIG_PARTYMPP				= "Percentage value on the Party Members Mana bar";
ARCHAEOLOGIST_CONFIG_PARTYMPP_INFO			= "";
ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE		= "Hide Party Health Prefix";
ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the party health bars.";
ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE		= "Hide Party Mana Prefix";
ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the party mana bars.";

-- <= == == == == == == == == == == == == =>
-- => Pet Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PET_SEP				= "Pet Status Bar Settings";
ARCHAEOLOGIST_CONFIG_PET_SEP_INFO			= "Most values, by default, can be seen on mouseover.";

ARCHAEOLOGIST_CONFIG_PETHP					= "Always Display Pet Health";
ARCHAEOLOGIST_CONFIG_PETHP_INFO				= "Turns on the number for the pet health bar.";
ARCHAEOLOGIST_CONFIG_PETMP					= "Always Display Pet Mana";
ARCHAEOLOGIST_CONFIG_PETMP_INFO				= "Turns on the number for the pet secondary bar.";
ARCHAEOLOGIST_CONFIG_PETHPP					= "Percentage value on the Pet Health bar";
ARCHAEOLOGIST_CONFIG_PETHPP_INFO			= "";
ARCHAEOLOGIST_CONFIG_PETMPP					= "Percentage value on the Pet Mana bar";
ARCHAEOLOGIST_CONFIG_PETMPP_INFO			= "";
ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE			= "Hide Pet Health Prefix";
ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the pet health bar.";
ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE			= "Hide Pet Mana Prefix";
ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the bet mana bar.";

-- <= == == == == == == == == == == == == =>
-- => Target Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_TARGET_SEP				= "Target Status Bar Settings";
ARCHAEOLOGIST_CONFIG_TARGET_SEP_INFO		= "Most values, by default, can be seen on mouseover.";

ARCHAEOLOGIST_CONFIG_TARGETHP				= "Always Display Target Health (percent only)";
ARCHAEOLOGIST_CONFIG_TARGETHP_INFO			= "Turns on the number for the target health bar.";
ARCHAEOLOGIST_CONFIG_TARGETMP				= "Always Display Target Mana";
ARCHAEOLOGIST_CONFIG_TARGETMP_INFO			= "Turns on the number for the target secondary bar.";
ARCHAEOLOGIST_CONFIG_TARGETHPP				= "Percentage value on the Target Health bar";
ARCHAEOLOGIST_CONFIG_TARGETHPP_INFO			= "";
ARCHAEOLOGIST_CONFIG_TARGETMPP				= "Percentage value on the Target Mana bar";
ARCHAEOLOGIST_CONFIG_TARGETMPP_INFO			= "";
ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE		= "Hide Target Health Prefix";
ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the target health bar.";
ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE		= "Hide Target Mana Prefix";
ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the target mana bar.";

-- <= == == == == == == == == == == == == =>
-- => Alternate Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP			= "Alternate Options";
ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP_INFO		= "Alternate Options";

ARCHAEOLOGIST_CONFIG_HPCOLOR			= "Turn On Health Bar Color Change";
ARCHAEOLOGIST_CONFIG_HPCOLOR_INFO		= "Healthbar changes color as it decreases.";

ARCHAEOLOGIST_CONFIG_DEBUFFALT			= "Alternate Debuff Location";
ARCHAEOLOGIST_CONFIG_DEBUFFALT_INFO		= "Moves Pet and Party Debuffs to below the Buffs.\ndefault debuffs show to the right of the unit frame.";

ARCHAEOLOGIST_CONFIG_HPMPALT			= "Alternate Text Location";
ARCHAEOLOGIST_CONFIG_HPMPALT_INFO		= "Moves All Unit HP and MP text off of the bars.";

-- <= == == == == == == == == == == == == =>
-- => Party Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP			= "Party Buff Settings";
ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP_INFO	= "By default 12 buffs and 12 debuffs are visible.";

ARCHAEOLOGIST_CONFIG_PBUFFS					= "Hide the party buffs ";
ARCHAEOLOGIST_CONFIG_PBUFFS_INFO			= "Removes the party's spell buffs from view unless you mouse-over their portrait.";

ARCHAEOLOGIST_CONFIG_PBUFF_NUM				= "Number of party buffs ";
ARCHAEOLOGIST_CONFIG_PBUFF_NUM_INFO			= "Set the number of party buffs to show.";
ARCHAEOLOGIST_CONFIG_PBUFF_NUM_SLIDER_TEXT  = "Buffs Visible";

ARCHAEOLOGIST_CONFIG_PDEBUFFS				= "Hide the party debuffs ";
ARCHAEOLOGIST_CONFIG_PDEBUFFS_INFO			= "Removes the party's spell debuffs from view.";

ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM			= "Number of party debuffs ";
ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM_INFO		= "Set the number of party debuffs to show.";
ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM_SLIDER_TEXT = "Debuffs Visible";

-- <= == == == == == == == == == == == == =>
-- => Pet Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP			= "Pet Buff Settings";
ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP_INFO		= "By default 12 buffs and 12 debuffs are visible.";

ARCHAEOLOGIST_CONFIG_PTBUFFS				= "Hide the pet buffs ";
ARCHAEOLOGIST_CONFIG_PTBUFFS_INFO			= "Removes the pet's spell buffs from view unless you mouse-over their portrait.";

ARCHAEOLOGIST_CONFIG_PTBUFFNUM				= "Number of pet buffs ";
ARCHAEOLOGIST_CONFIG_PTBUFFNUM_INFO			= "Set the number of pet buffs to show.";
ARCHAEOLOGIST_CONFIG_PTBUFFNUM_SLIDER_TEXT  = "Buffs Visible";

ARCHAEOLOGIST_CONFIG_PTDEBUFFS				= "Hide the pet debuffs ";
ARCHAEOLOGIST_CONFIG_PTDEBUFFS_INFO			= "Removes the pet's spell debuffs from view.";

ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM			= "Number of pet debuffs ";
ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM_INFO		= "Set the number of pet debuffs to show.";
ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM_SLIDER_TEXT = "Debuffs Visible";

