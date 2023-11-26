
function XRaid_Locals_deDE()

ace:RegisterGlobals({
    -- Match this version to the library version you are pulling from.
    version = 1.0,

    -- Place any AceUtil globals your addon needs here.
    ACE_MAP_ONOFF = {[0]="|cffff5050Off|r",[1]="|cff00ff00On|r"},
    RAID_SORT = {[0]="Group",[1]="Class"},
})

XRAID_NAME				= "XRaid"
XRAID_DESCRIPTION		= "Ein Raid Addon"
XRAID_VERSION           = "0.21"
XRAID_RELEASEDATE       = "27.09.2005"

XRAID_CLASS_WARRIOR  = "Krieger";
XRAID_CLASS_MAGE     = "Magier";
XRAID_CLASS_ROGUE    = "Schurke";
XRAID_CLASS_DRUID    = "Druide";
XRAID_CLASS_HUNTER   = "J\195\164ger";
XRAID_CLASS_SHAMAN   = "Schamane";
XRAID_CLASS_PRIEST   = "Priester";
XRAID_CLASS_WARLOCK  = "Hexenmeister";
XRAID_CLASS_PALADIN  = "Paladin";

XRAID_GRP1  = "Gruppe 1";
XRAID_GRP2  = "Gruppe 2";
XRAID_GRP3  = "Gruppe 3";
XRAID_GRP4  = "Gruppe 4";
XRAID_GRP5  = "Gruppe 5";
XRAID_GRP6  = "Gruppe 6";
XRAID_GRP7  = "Gruppe 7";
XRAID_GRP8  = "Gruppe 8";
XRAID_MTT   = "MT Ziele"

XRAID_CURSE      = "Fluch";
XRAID_POISON     = "Gift";
XRAID_MAGIC      = "Magie";
XRAID_DISEASE    = "Krankheit";

xraid_buffs = { }
xraid_buffs[1] = "Machtwort: Seelenst\195\164rke"
xraid_buffs[2] = "Gebet der Seelenst\195\164rke"
xraid_buffs[3] = "Mal der Wildnis"
xraid_buffs[4] = "Gabe der Wildnis"
xraid_buffs[5] = "Arkane Intelligenz"
xraid_buffs[6] = "Arkane Brillanz"
xraid_buffs[7] = "Admiralshut"
xraid_buffs[8] = "Schattenschutz"
xraid_buffs[9] = "Machtwort: Schild"
xraid_buffs[10] = "Seelenstein-Auferstehung"
xraid_buffs[11] = "G\195\182ttlicher Willen"
xraid_buffs[12] = "Dornen"
xraid_buffs[13] = "Furchtbarriere"
xraid_buffs[14] = "Segen der Macht"
xraid_buffs[15] = "Segen der Weisheit"
xraid_buffs[16] = "Segen der K\195\182nige"
xraid_buffs[17] = "Segen der Rettung"
xraid_buffs[18] = "Segen des Lichts"
xraid_buffs[19] = "Segen des Refugiums"
xraid_buffs[20] = "Nachwachsen"
xraid_buffs[21] = "Verj\195\188ngung"
xraid_buffs[22] = "Erneuerung"

-- Chat handler locals
XRAID_COMMANDS		 = {"/xraid", "/xr"}
XRAID_CMD_OPTIONS	 = {
	{
		option	= "invite",
		desc	= "Invite guild members into your raid group. Put the specified level after the command.",
		method	= "RaidInvite"
	},
	{
		option	= "lock",
		desc	= "Will lock/unlock the raid unit frames in their current place",
		method	= "ChangeLock"
	},
	{
		option	= "unlock",
		desc	= "Will lock/unlock the raid unit frames in their current place",
		method	= "ChangeLock"
	},
	{
		option	= "scale",
		desc	= "Change the scale of the raid windows",
		method	= "ChangeScale"
	},
	{
		option	= "trans",
		desc	= "Change the transparency of the raid windows",
		method	= "ChangeTransparency"
	},
	{
		option	= "texttrans",
		desc	= "Change the text transparency of the raid windows",
		method	= "ChangeTextTransparency"
	},
	{
		option	= "updaterate",
		desc	= "Change the update rate of the Maintank Targets (Targets)",
		method	= "ChangeUpdaterate"
	},
	{
	    option = "view",
        args = {
            {
                option = "group",
				desc   = "Change the raid to the group view",
				method = "ChangeToGroupView"
			},
            {
                option = "class",
				desc   = "Change the raid to the class view",
				method = "ChangeToClassView"
			}
        },
        desc   = "Change the group/class view",
	},
	{
	    option = "health",
        args = {
            {
                option = "perc",
				desc   = "Show health percent view",
				method = "ChangeToHealthPercView"
			},
            {
                option = "deficit",
				desc   = "Show health deficit view",
				method = "ChangeToHealthDeficitView"
			},
            {
                option = "absolute",
				desc   = "Show health absolute view",
				method = "ChangeToHealthAbsoluteView"
			},
			{
                option = "none",
				desc   = "Show no health text",
				method = "ChangeToNoneHealthView"
			}
        },
        desc   = "Change the health view",
	},
    {
	    option = "show",
        desc   = "Show groups/targets",
        method = "ShowGroup"
	},
	{
	    option = "hide",
        desc   = "Hide groups/targets",
        method = "HideGroup"
	},
	{
	    option = "bartex",
        desc   = "Show/Hide bar textures",
        method = "ChangeBarTextures"
	},
	{
	    option = "reset",
	    args = {
            {
                option = "position",
				desc   = "Resets the positions of the raid windows",
				method = "ResetPosition"
			},
            {
                option = "config",
				desc   = "Resets the config",
				method = "ResetConfig"
			},
        },
        desc   = "Resets specific things of xraid",
	},
}

XRAID_VAR_SORT_TEXT = "Raid sort"
XRAID_CMD_GRPVIEW_MSG = "Raid view changed to group"
XRAID_CMD_GRPVIEW_FALSE_MSG = "Raid view not changed. Group view already active"

XRAID_CMD_SHOWMTTAR_MSG = "Show maintank targets"
XRAID_CMD_HIDEMTTAR_MSG = "Hide maintank targets"

XRAID_CMD_CLASSVIEW_MSG = "Raid view changed to class"
XRAID_CMD_CLASSVIEW_FALSE_MSG = "Raid view not changed. Class view already active"

XRAID_VAR_LOCK_TEXT	= "Locked"
XRAID_CMD_LOCK_MSG  = "XRaid Unit Frames are now locked in place."
XRAID_CMD_UNLOCK_MSG  = "XRaid Unit Frames are now unlocked."

XRAID_CMD_SCALE_FALSE_MSG = "Scale value has to be between 0.5 and 1.5"
XRAID_CMD_SCALE_MSG = "Scale value set to %s."

XRAID_CMD_TRANS_FALSE_MSG = "Transparency value has to be between 0 and 1"
XRAID_CMD_TRANS_MSG = "Transparency value set to %s."

XRAID_CMD_TEXTTRANS_FALSE_MSG = "Text transparency value has to be between 0 and 1"
XRAID_CMD_TEXTTRANS_MSG = "Text transparency value set to %s."

XRAID_CMD_UPD_FALSE_MSG = "Update value for maintank targets has to be between 0 and 1"
XRAID_CMD_UPD_MSG = "Update value for maintank targets set to %s."

XRAID_CMD_HEALTH_MSG = "Health view changed to %s."
XRAID_CMD_NOHEALTH_MSG = "Health text disabled."

XRAID_CMD_SHOWGROUP_MSG = "Showing group: %s"
XRAID_CMD_FALSESHOWGROUP_MSG = "Wrong syntax, e.g. /xr show 6, /xr show targets or /xr show all"

XRAID_CMD_HIDEGROUP_MSG = "Hiding group: %s"
XRAID_CMD_FALSEHIDEGROUP_MSG = "Wrong syntax, e.g. /xr hide 6, /xr hide targets or /xr hide all"

XRAID_CMD_BARTEX_MSG = "Showing bar textures"
XRAID_CMD_NOBARTEX_MSG = "Hiding bar textures"

XRAID_VAR_BARTEX_TEXT = "Bar Textures"
XRAID_VAR_TRANS_TEXT = "Transparency"
XRAID_VAR_TTRANS_TEXT = "Text Transparency"
XRAID_VAR_SCALE_TEXT = "Raid Scale"
XRAID_VAR_UPDTIMER_TEXT = "MT Target Update Timer"
XRAID_VAR_CASTPARTY_TEXT = "Cast Party Support"
XRAID_VAR_MTTARGETS_TEXT = "Maintank Targets"
XRAID_VAR_GRP1_TEXT = XRAID_GRP1 .. " / " .. XRAID_CLASS_WARRIOR
XRAID_VAR_GRP2_TEXT = XRAID_GRP2 .. " / " .. XRAID_CLASS_MAGE
XRAID_VAR_GRP3_TEXT = XRAID_GRP3 .. " / " .. XRAID_CLASS_PRIEST
XRAID_VAR_GRP4_TEXT = XRAID_GRP4 .. " / " .. XRAID_CLASS_WARLOCK
XRAID_VAR_GRP5_TEXT = XRAID_GRP5 .. " / " .. XRAID_CLASS_DRUID
XRAID_VAR_GRP6_TEXT = XRAID_GRP6 .. " / " .. XRAID_CLASS_ROGUE
XRAID_VAR_GRP7_TEXT = XRAID_GRP7 .. " / " .. XRAID_CLASS_HUNTER
XRAID_VAR_GRP8_TEXT = XRAID_GRP8 .. " / " .. XRAID_CLASS_SHAMAN .. " / " .. XRAID_CLASS_PALADIN
XRAID_VAR_BARTEX_TEXT = "Bar Textures"

MainTankMenu = { {Text="Set maintank 1"}, {Text="Set maintank 2"}, {Text="Set maintank 3"},{Text="Set maintank 4"}, {Text="Set maintank 5"}, {Text="Set maintank 6"}, {Text="Set maintank 7"}, {Text="Set maintank 8"} };

end
