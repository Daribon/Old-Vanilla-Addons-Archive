--------------------------------------------------------------------------
-- localization.lua 
--------------------------------------------------------------------------

PLAYER_GHOST 						= "Ghost";
PLAYER_WISP 						= "Wisp";

ARCHAEOLOGIST_CONFIG_SEP				= "Archaeologist";
ARCHAEOLOGIST_CONFIG_SEP_INFO			= "Archaeologist Settings";

ARCHAEOLOGIST_FEEDBACK_STRING = "%s changed to %s.";
ARCHAEOLOGIST_NOT_A_VALID_FONT = "%s is not a valid font.";
ArchaeologistLocalizedFonts = { 
	["Default"] = "Default";
	--change fist string for displayd string
	--values must match ArchaeologistFonts keys
	["GameFontNormal"] = "GameFontNormal";
	["NumberFontNormal"] = "NumberFontNormal";
	["ItemTextFontNormal"] = "ItemTextFontNormal";
};

-- <= == == == == == == == == == == == == =>
-- => Player Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PLAYER_SEP				= "Player Status Bar Settings";
ARCHAEOLOGIST_CONFIG_PLAYER_SEP_INFO		= "Most values, by default, can be seen on mouseover.";
		
ARCHAEOLOGIST_CONFIG_PLAYERHP		= "Primary Player Health Display";
ARCHAEOLOGIST_CONFIG_PLAYERHP_INFO = "Always shows player health text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PLAYERHP2		= "Secondary Player Health Display";
ARCHAEOLOGIST_CONFIG_PLAYERHP2_INFO = "Always shows player health text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PLAYERMP		= "Primary Player Mana Display";
ARCHAEOLOGIST_CONFIG_PLAYERMP_INFO = "Always shows player mana text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PLAYERMP2		= "Secondary Player Mana Display";
ARCHAEOLOGIST_CONFIG_PLAYERMP2_INFO = "Always shows player mana text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PLAYERXP		= "Always Show Player Experience";
ARCHAEOLOGIST_CONFIG_PLAYERXP_INFO = "Always shows player experience text on the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PLAYERXPP			= "Show Percentage on the Player XP bar";
ARCHAEOLOGIST_CONFIG_PLAYERXPP_INFO	= "";
ARCHAEOLOGIST_CONFIG_PLAYERXPV			= "Show Exact Value on the Player XP bar";
ARCHAEOLOGIST_CONFIG_PLAYERXPV_INFO	= "";
ARCHAEOLOGIST_CONFIG_PLAYERHPINVERT			= "Show Player Health Missing";
ARCHAEOLOGIST_CONFIG_PLAYERHPINVERT_INFO	= "Invert the player health display.";
ARCHAEOLOGIST_CONFIG_PLAYERMPINVERT			= "Show Player Mana Missing";
ARCHAEOLOGIST_CONFIG_PLAYERMPINVERT_INFO	= "Invert the player mana display.";
ARCHAEOLOGIST_CONFIG_PLAYERXPINVERT			= "Show Experience Left to Level";
ARCHAEOLOGIST_CONFIG_PLAYERXPINVERT_INFO	= "Invert the player XP display";
ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE		= "Hide Player Health Prefix";
ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the player health bar.";
ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE		= "Hide Player Mana Prefix";
ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the player mana bar.";
ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE		= "Hide Player XP Prefix";
ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE_INFO	= "Turns off the 'XP' prefix on the player xp bars.";
ARCHAEOLOGIST_CONFIG_PLAYERCLASSICON		= "Show Player Class Icon";
ARCHAEOLOGIST_CONFIG_PLAYERCLASSICON_INFO	= "Turns on the class icon on the player frame.";

-- <= == == == == == == == == == == == == =>
-- => Party Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PARTY_SEP				= "Party Status Bar Settings";
ARCHAEOLOGIST_CONFIG_PARTY_SEP_INFO			= "Most values, by default, can be seen on mouseover.";

ARCHAEOLOGIST_CONFIG_PARTYHP		= "Primary Party Health Display";
ARCHAEOLOGIST_CONFIG_PARTYHP_INFO = "Always shows party health text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PARTYHP2		= "Secondary Party Health Display";
ARCHAEOLOGIST_CONFIG_PARTYHP2_INFO = "Always shows party health text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PARTYMP		= "Primary Party Mana Display";
ARCHAEOLOGIST_CONFIG_PARTYMP_INFO = "Always shows party mana text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PARTYMP2		= "Secondary Party Mana Display";
ARCHAEOLOGIST_CONFIG_PARTYMP2_INFO = "Always shows party mana text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PARTYHPINVERT			= "Show Party Health Missing";
ARCHAEOLOGIST_CONFIG_PARTYHPINVERT_INFO	= "Invert the party health display.";
ARCHAEOLOGIST_CONFIG_PARTYMPINVERT			= "Show Party Mana Missing";
ARCHAEOLOGIST_CONFIG_PARTYMPINVERT_INFO	= "Invert the party mana display.";
ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE		= "Hide Party Health Prefix";
ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the party health bars.";
ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE		= "Hide Party Mana Prefix";
ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the party mana bars.";
ARCHAEOLOGIST_CONFIG_PARTYCLASSICON			= "Show Party Class Icons";
ARCHAEOLOGIST_CONFIG_PARTYCLASSICON_INFO	= "Turns on the class icons on the party member frames.";

-- <= == == == == == == == == == == == == =>
-- => Pet Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PET_SEP				= "Pet Status Bar Settings";
ARCHAEOLOGIST_CONFIG_PET_SEP_INFO			= "Most values, by default, can be seen on mouseover.";

ARCHAEOLOGIST_CONFIG_PETHP		= "Primary Pet Health Display";
ARCHAEOLOGIST_CONFIG_PETHP_INFO = "Always shows pet health text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PETHP2		= "Secondary Pet Health Display";
ARCHAEOLOGIST_CONFIG_PETHP2_INFO = "Always shows pet health text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PETMP		= "Primary Pet Mana Display";
ARCHAEOLOGIST_CONFIG_PETMP_INFO = "Always shows pet mana text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PETMP2		= "Secondary Pet Mana Display";
ARCHAEOLOGIST_CONFIG_PETMP2_INFO = "Always shows pet mana text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_PETHPINVERT			= "Show Pet Health Missing";
ARCHAEOLOGIST_CONFIG_PETHPINVERT_INFO	= "Invert the pet health display.";
ARCHAEOLOGIST_CONFIG_PETMPINVERT			= "Show Pet Mana Missing";
ARCHAEOLOGIST_CONFIG_PETMPINVERT_INFO	= "Invert the pet mana display.";
ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE			= "Hide Pet Health Prefix";
ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the pet health bar.";
ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE			= "Hide Pet Mana Prefix";
ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the bet mana bar.";

-- <= == == == == == == == == == == == == =>
-- => Target Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_TARGET_SEP				= "Target Status Bar Settings";
ARCHAEOLOGIST_CONFIG_TARGET_SEP_INFO		= "Most values, by default, can be seen on mouseover.";

ARCHAEOLOGIST_CONFIG_TARGETHP		= "Primary Target Health Display";
ARCHAEOLOGIST_CONFIG_TARGETHP_INFO = "Always shows target health text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_TARGETHP2		= "Secondary Target Health Display";
ARCHAEOLOGIST_CONFIG_TARGETHP2_INFO = "Always shows target health text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_TARGETMP		= "Primary Target Mana Display";
ARCHAEOLOGIST_CONFIG_TARGETMP_INFO = "Always shows target mana text over the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_TARGETMP2		= "Secondary Target Mana Display";
ARCHAEOLOGIST_CONFIG_TARGETMP2_INFO = "Always shows target mana text next to the bar. (Disabled: only on mouseover)";
ARCHAEOLOGIST_CONFIG_TARGETHPINVERT			= "Show Target Health Missing";
ARCHAEOLOGIST_CONFIG_TARGETHPINVERT_INFO	= "Invert the target health display.";
ARCHAEOLOGIST_CONFIG_TARGETMPINVERT			= "Show Target Mana Missing";
ARCHAEOLOGIST_CONFIG_TARGETMPINVERT_INFO	= "Invert the target mana display.";
ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE		= "Hide Target Health Prefix";
ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE_INFO	= "Turns off the 'Health' prefix on the target health bar.";
ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE		= "Hide Target Mana Prefix";
ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE_INFO	= "Turns off the 'Mana/Rage/Power' prefix on the target mana bar.";
ARCHAEOLOGIST_CONFIG_TARGETCLASSICON		= "Show Target Class Icon";
ARCHAEOLOGIST_CONFIG_TARGETCLASSICON_INFO	= "Turns on the class icon on the target frame.";

-- <= == == == == == == == == == == == == =>
-- => Alternate Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP			= "Alternate Options";
ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP_INFO		= "Alternate Options";

ARCHAEOLOGIST_CONFIG_HPCOLOR			= "Turn On Health Bar Color Change";
ARCHAEOLOGIST_CONFIG_HPCOLOR_INFO		= "Healthbar changes color as it decreases.";

ARCHAEOLOGIST_CONFIG_DEBUFFALT			= "Alternate Debuff Location";
ARCHAEOLOGIST_CONFIG_DEBUFFALT_INFO		= "Moves Pet and Party Debuffs to below the Buffs.\ndefault debuffs show to the right of the unit frame.";

ARCHAEOLOGIST_CONFIG_TBUFFALT			= "Align Target Buffs Right to Left";
ARCHAEOLOGIST_CONFIG_TBUFFALT_INFO		= "Sets Target buffs and debuffs to display from right to left.";

ARCHAEOLOGIST_CONFIG_HPMPALT			= "Alternate Text Location";
ARCHAEOLOGIST_CONFIG_HPMPALT_INFO		= "Moves All Unit HP and MP text off of the bars.";

ARCHAEOLOGIST_CONFIG_MOBHEALTH			= "Use MobHealth2 for Target HP";
ARCHAEOLOGIST_CONFIG_MOBHEALTH_INFO		= "Hides the regular MobHealth2 text and uses it in place of the HP text on the Target Frame.";

ARCHAEOLOGIST_CONFIG_CLASSPORTRAIT		= "Class Portrait";
ARCHAEOLOGIST_CONFIG_CLASSPORTRAIT_INFO = "Replace unit portraits with class icons when applicable.";

-- <= == == == == == == == == == == == == =>
-- => Font Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_FONTOPTS_SEP			= "Font Options";
ARCHAEOLOGIST_CONFIG_FONTOPTS_SEP_INFO		= "Font Options";

ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE		= "Set Player/Target Text Size.";
ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE_INFO = " ";
ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE_SLIDERTEXT   = "Font Size";

ARCHAEOLOGIST_CONFIG_HPMPLARGEFONT		= "Set Player/Target Text Font.";
ARCHAEOLOGIST_CONFIG_HPMPLARGEFONT_INFO = " ";

ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE		= "Set Pet/Party Text Size";
ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE_INFO = " ";
ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE_SLIDERTEXT   = "Font Size";

ARCHAEOLOGIST_CONFIG_HPMPSMALLFONT		= "Set Pet/Party Text Font";
ARCHAEOLOGIST_CONFIG_HPMPSMALLFONT_INFO = " ";

ARCHAEOLOGIST_COLOR_CHANGED				= "|c%s%s color changed.|r";
ARCHAEOLOGIST_COLOR_RESET				= "|c%s%s color reset.|r";

ARCHAEOLOGIST_CONFIG_COLORPHP			= "Primary Health Color (Default is white):";
ARCHAEOLOGIST_CONFIG_COLORPHP_INFO		= "Changes the color of the primary health text.";
ARCHAEOLOGIST_CONFIG_COLORPHP_RESET			= "Reset the Primary Health Color";
ARCHAEOLOGIST_CONFIG_COLORPHP_RESET_INFO	= "Resets the color of the primary health text to white.";

ARCHAEOLOGIST_CONFIG_COLORPMP			= "Primary Mana Color (Default is white):";
ARCHAEOLOGIST_CONFIG_COLORPMP_INFO		= "Changes the color of the primary mana text.";
ARCHAEOLOGIST_CONFIG_COLORPMP_RESET			= "Reset the Primary Mana Color";
ARCHAEOLOGIST_CONFIG_COLORPMP_RESET_INFO	= "Resets the color of the primary mana text to white.";

ARCHAEOLOGIST_CONFIG_COLORSHP			= "Secondary Health Color (Default is white):";
ARCHAEOLOGIST_CONFIG_COLORSHP_INFO		= "Changes the color of the secondary health text.";
ARCHAEOLOGIST_CONFIG_COLORSHP_RESET			= "Reset the Secondary Health Color";
ARCHAEOLOGIST_CONFIG_COLORSHP_RESET_INFO	= "Resets the color of the secondary health text to white.";

ARCHAEOLOGIST_CONFIG_COLORSMP			= "Secondary Mana Color (Default is white):";
ARCHAEOLOGIST_CONFIG_COLORSMP_INFO		= "Changes the color of the secondary mana text.";
ARCHAEOLOGIST_CONFIG_COLORSMP_RESET			= "Reset the Secondary Mana Color";
ARCHAEOLOGIST_CONFIG_COLORSMP_RESET_INFO	= "Resets the color of the secondary mana text to white.";


-- <= == == == == == == == == == == == == =>
-- => Party Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP			= "Party Buff Settings";
ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP_INFO	= "By default 16 buffs and 16 debuffs are visible.";

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
-- => Party Pet Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PARTYPETBUFFS_SEP			= "Party Pet Buff Settings";
ARCHAEOLOGIST_CONFIG_PARTYPETBUFFS_SEP_INFO	= "By default 16 buffs and 16 debuffs are visible.";

ARCHAEOLOGIST_CONFIG_PPTBUFFS					= "Hide the party pet buffs ";
ARCHAEOLOGIST_CONFIG_PPTBUFFS_INFO			= "Removes the party pet's spell buffs from view unless you mouse-over their portrait.";

ARCHAEOLOGIST_CONFIG_PPTBUFF_NUM				= "Number of party pet buffs ";
ARCHAEOLOGIST_CONFIG_PPTBUFF_NUM_INFO			= "Set the number of party pet buffs to show.";
ARCHAEOLOGIST_CONFIG_PPTBUFF_NUM_SLIDER_TEXT  = "Buffs Visible";

ARCHAEOLOGIST_CONFIG_PPTDEBUFFS				= "Hide the party pet debuffs ";
ARCHAEOLOGIST_CONFIG_PPTDEBUFFS_INFO			= "Removes the party pet's spell debuffs from view.";

ARCHAEOLOGIST_CONFIG_PPTDEBUFF_NUM			= "Number of party pet debuffs ";
ARCHAEOLOGIST_CONFIG_PPTDEBUFF_NUM_INFO		= "Set the number of party pet debuffs to show.";
ARCHAEOLOGIST_CONFIG_PPTDEBUFF_NUM_SLIDER_TEXT = "Debuffs Visible";

-- <= == == == == == == == == == == == == =>
-- => Pet Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP			= "Pet Buff Settings";
ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP_INFO		= "By default 16 buffs and 4 debuffs are visible.";

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

-- <= == == == == == == == == == == == == =>
-- => Target Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_TARGETBUFFS_SEP		= "Target Buff Settings";
ARCHAEOLOGIST_CONFIG_TARGETBUFFS_SEP_INFO   = "By default 8 buffs and 16 debuffs are visible.";

ARCHAEOLOGIST_CONFIG_TBUFFS					= "Hide the target buffs ";
ARCHAEOLOGIST_CONFIG_TBUFFS_INFO			= "Removes the target's spell buffs from view.";

ARCHAEOLOGIST_CONFIG_TBUFFNUM				= "Number of target buffs ";
ARCHAEOLOGIST_CONFIG_TBUFFNUM_INFO			= "Set the number of target buffs to show.";
ARCHAEOLOGIST_CONFIG_TBUFFNUM_SLIDER_TEXT   = "Buffs Visible";

ARCHAEOLOGIST_CONFIG_TDEBUFFS				= "Hide the target debuffs ";
ARCHAEOLOGIST_CONFIG_TDEBUFFS_INFO			= "Removes the target's spell debuffs from view.";

ARCHAEOLOGIST_CONFIG_TDEBUFFNUM				= "Number of target debuffs ";
ARCHAEOLOGIST_CONFIG_TDEBUFFNUM_INFO		= "Set the number of target debuffs to show.";
ARCHAEOLOGIST_CONFIG_TDEBUFFNUM_SLIDER_TEXT = "Debuffs Visible";

ARCHAEOLOGIST_FEEDBACK_STRING = "%s is currently set to %s.";
