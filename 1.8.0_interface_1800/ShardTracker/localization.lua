--
-- ShardTracker Localization
--   English by Cragganmore
--

BINDING_HEADER_SHARDTRACKERHEADER       = "ShardTracker";
BINDING_NAME_SHARDTRACKER               = "ShardTracker Toggle";

-- cosmos variables
SHARDTRACKER_CONFIG_HEADER              = "ShardTracker";
SHARDTRACKER_CONFIG_HEADER_INFO         = "ShardTracker allows Warlocks to keep track of various aspects about their shards and stones via small buttons attached to the minimap.";
SHARDTRACKER_CONFIG_ENABLED             = "Enable ShardTracker";
SHARDTRACKER_CONFIG_ENABLED_INFO        = "Enable or disable the plugin.";
SHARDTRACKER_CONFIG_FLASH_HEALTH        = "Flash Healthstone Icon";
SHARDTRACKER_CONFIG_FLASH_HEALTH_INFO   = "Flash the Healthstone icon when there is no Healthstone in your inventory.";
SHARDTRACKER_CONFIG_SOUND               = "Enable alert sounds";
SHARDTRACKER_CONFIG_SOUND_INFO          = "Play sounds when a Soulstone cooldown expires and when party members need new Healthstones.";
SHARDTRACKER_CONFIG_SOULPOP             = "Enable Soulstone popup alerts.";
SHARDTRACKER_CONFIG_SOULPOP_INFO        = "Show a popup message when your Soulstone cooldown timer expires.";
SHARDTRACKER_CONFIG_MONITOR_PARTY       = "Monitor your Party's Healthstones";
SHARDTRACKER_CONFIG_MONITOR_PARTY_INFO  = "Enable whether to monitor your Party's Healthstones and be alerted when new ones are needed.";
SHARDTRACKER_CONFIG_RESTRICT            = "Restrict party communication.";
SHARDTRACKER_CONFIG_RESTRICT_INFO       = "Restrict Healthstone monitoring communication to a specified list of players.";
SHARDTRACKER_RESET                      = "Reset button locations";
SHARDTRACKER_RESET_INFO                 = "Move the ShardTracker buttons to their default locations.";
SHARDTRACKER_RESET_NAME                 = "Reset";
SHARDTRACKER_CENTER                     = "Center button locations";
SHARDTRACKER_CENTER_INFO                = "Move the ShardTracker buttons to the center of the screen.";
SHARDTRACKER_CENTER_NAME                = "Center";

-- slash commands
-- NOTE: if translating these, make sure they remain single-word only
SHARDTRACKER_DEBUG_CMD       = "debug";
SHARDTRACKER_TOGGLE_CMD      = "toggle";
SHARDTRACKER_ON_CMD          = "on";
SHARDTRACKER_OFF_CMD         = "off";
SHARDTRACKER_BAG_CMD         = "bag";
SHARDTRACKER_SORT_CMD        = "sort";
SHARDTRACKER_LIMIT_CMD       = "limit";
SHARDTRACKER_SOUND_CMD       = "sound";
SHARDTRACKER_MONITOR_CMD     = "monitor";
SHARDTRACKER_HELP_CMD        = "help";
SHARDTRACKER_FLASH_CMD       = "flash";
SHARDTRACKER_LOCK_CMD        = "lock";
SHARDTRACKER_UNLOCK_CMD      = "unlock";
SHARDTRACKER_INFO_CMD        = "info";
SHARDTRACKER_RESET_CMD       = "reset";
SHARDTRACKER_CENTER_CMD      = "center";
SHARDTRACKER_TOGGLE_CMD      = "toggle";
SHARDTRACKER_SCALE_CMD       = "scale";
SHARDTRACKER_SCALE_1_CMD     = "regular";
SHARDTRACKER_SCALE_2_CMD     = "large";
SHARDTRACKER_SCALE_3_CMD     = "biggie";
SHARDTRACKER_SCALE_4_CMD     = "supersizeme";
SHARDTRACKER_SOUL_POPUP_CMD  = "soulpopup";
SHARDTRACKER_SHARDBG_CMD     = "shardbg";
SHARDTRACKER_RESTRICT_CMD    = "restrict";
SHARDTRACKER_ADD_CMD         = "add";
SHARDTRACKER_REMOVE_CMD      = "remove";
SHARDTRACKER_LIST_CMD        = "list";
SHARDTRACKER_SOULSOUND_CMD   = "soulsound";
SHARDTRACKER_HEALTHSOUND_CMD = "healthsound";
SHARDTRACKER_FLASHY_CMD      = "flashy";
SHARDTRACKER_NAGSOUL_CMD     = "soulnag";
SHARDTRACKER_NAGHEALTH_CMD   = "healthnag";
SHARDTRACKER_NAGCOUNT_CMD    = "nagcount";
SHARDTRACKER_NAGFREQ_CMD     = "nagfrequency";
SHARDTRACKER_MAXSHARDS_CMD   = "maxshards";
SHARDTRACKER_NIGHTFALL_CMD   = "nightfall";
SHARDTRACKER_SHARDEFFECT_CMD = "shardeffect";
SHARDTRACKER_AUTOSORT_CMD    = "autosort";

-- Messages used to sync healthstone status
SHARDTRACKER_GOT_HEALTHSTONE_MSG            = "received a HealthStone!";
SHARDTRACKER_NEED_HEALTHSTONE_MSG           = "needs a new HealthStone!";
SHARDTRACKER_REQUEST_HEALTHSTONE_STATUS_MSG = "ShardTracker is requesting a sync update.";
SHARDTRACKER_SYNC_HEALTHSTONE_YES_MSG       = "has a Healthstone.";
SHARDTRACKER_SYNC_HEALTHSTONE_NO_MSG        = "does not have a Healthstone.";
SHARDTRACKER_CHAT_PREFIX                    = "<ST>";

-- tooltip text
SHARDTRACKER_SHARDBUTTON_TIP1           = "ShardTracker Shard Button";
SHARDTRACKER_SHARDBUTTON_TIP2           = "Shows the number of shards in your bag.";
SHARDTRACKER_SHARDBUTTON_TIP3           = "Click to sort your shards into the bag";
SHARDTRACKER_SHARDBUTTON_TIP4           = "specified by /shardtracker bag [0-4].";

SHARDTRACKER_HEALTHBUTTON_TIP1          = "ShardTracker Healthstone Button";
SHARDTRACKER_HEALTHBUTTON_TIP2          = "Click to create your highest rank Healthstone.";
SHARDTRACKER_HEALTHBUTTON_TIP3          = "Click again to use the Healthstone, or select a";
SHARDTRACKER_HEALTHBUTTON_TIP4          = "player and click to give them the Healthstone.";
SHARDTRACKER_HEALTHBUTTON_TIP5          = "Click to use your Healthstone.";

SHARDTRACKER_SOULBUTTON_TIP1            = "ShardTracker Soulstone Button";
SHARDTRACKER_SOULBUTTON_TIP2            = "Click to create your highest rank Soulstone.";
SHARDTRACKER_SOULBUTTON_TIP3            = "Click again to use the Soulstone on a selected player.";
SHARDTRACKER_SOULBUTTON_TIP4            = "The counter indicates the cooldown period until you may use";
SHARDTRACKER_SOULBUTTON_TIP5            = "another Soulstone (at which point, this button will flash).";

SHARDTRACKER_SPELLBUTTON_TIP1           = "ShardTracker Spellstone Button";
SHARDTRACKER_SPELLBUTTON_TIP2           = "Click to create your highest rank Spellstone.";
SHARDTRACKER_SPELLBUTTON_TIP3           = "Click again to equip your Spellstone.  Once the";
SHARDTRACKER_SPELLBUTTON_TIP4           = "cooldown is over, clicking will use your Spellstone";
SHARDTRACKER_SPELLBUTTON_TIP5           = "and automatically re-equip your previous off-hand item.";

SHARDTRACKER_FIREBUTTON_TIP1            = "ShardTracker Firestone Button";
SHARDTRACKER_FIREBUTTON_TIP2            = "Click to create your highest rank Firestone.";
SHARDTRACKER_FIREBUTTON_TIP3            = "Click again to equip your Firestone.  Clicking";
SHARDTRACKER_FIREBUTTON_TIP4            = "again will unequip your Firestone and automatically";
SHARDTRACKER_FIREBUTTON_TIP5            = "re-equip your previous off-hand item.";

SHARDTRACKER_PARTYHEALTH_TIP1           = "ShardTracker Party Healthstone";
SHARDTRACKER_PARTYHEALTH_TIP2           = "When solid, this party member has a Healthstone";
SHARDTRACKER_PARTYHEALTH_TIP3           = "When flashing, this party member needs a Healthstone";

SHARDTRACKER_SHARDBUTTON_STATUS1        = "(Click to Sort)";
SHARDTRACKER_HEALTHBUTTON_STATUS1       = "(Click to Use)";
SHARDTRACKER_HEALTHBUTTON_STATUS2       = "(Click to Create)";
SHARDTRACKER_SOULBUTTON_STATUS1         = "(Click to Use)";
SHARDTRACKER_SOULBUTTON_STATUS2         = "(Waiting for Cooldown)";
SHARDTRACKER_SOULBUTTON_STATUS3         = "(Click to Create)";
SHARDTRACKER_SPELLBUTTON_STATUS1        = "(Click to Use)";
SHARDTRACKER_SPELLBUTTON_STATUS2        = "(Waiting for Cooldown)";
SHARDTRACKER_SPELLBUTTON_STATUS3        = "(Click to Equip)";
SHARDTRACKER_SPELLBUTTON_STATUS4        = "(Click to Create)";
SHARDTRACKER_FIREBUTTON_STATUS1         = "(Click to Equip)";
SHARDTRACKER_FIREBUTTON_STATUS2         = "(Click to Un-Equip)";
SHARDTRACKER_FIREBUTTON_STATUS3         = "(Click to Create)";
SHARDTRACKER_BUTTON_CTRLCLICKTEXT       = "(Ctrl-Click to Set Text Color)";
SHARDTRACKER_BUTTON_SHIFTCLICKTEXT1     = "(Shift-Click to ";
SHARDTRACKER_BUTTON_SHIFTCLICKTEXT2     = "un";
SHARDTRACKER_BUTTON_SHIFTCLICKTEXT3     = "mute)";

-- popup messages
SHARDTRACKERSORT_SORTING                = "ShardTracker is Sorting";
SHARDTRACKER_SOULSTONEREADYMSG          = "Soulstone is Ready!";

-- key bindings
BINDING_HEADER_SHARDTRACKER_HEADER      = "ShardTracker";
BINDING_NAME_SHARDBUTTON_BINDING        = "Shard Button";
BINDING_NAME_HEALTHBUTTON_BINDING       = "Healthstone Button";
BINDING_NAME_SOULBUTTON_BINDING         = "Soulstone Button";
BINDING_NAME_SPELLBUTTON_BINDING        = "Spellstone Button";
BINDING_NAME_FIREBUTTON_BINDING         = "Firestone Button";

-- localization / translation text
SHARDTRACKER_WARLOCK                  = "Warlock";     
SHARDTRACKER_SPELLSTONE               = "Spellstone";  
SHARDTRACKER_FIRESTONE                = "Firestone";  
SHARDTRACKER_SOULSHARD                = "Soul Shard";  
SHARDTRACKER_SOULSTONE                = "Soulstone";  
SHARDTRACKER_HEALTHSTONE              = "Healthstone"; 
SHARDTRACKER_CREATEHEALTHSTONEMINOR   = "Create Healthstone (Minor)";
SHARDTRACKER_CREATEHEALTHSTONELESSER  = "Create Healthstone (Lesser)"; 
SHARDTRACKER_CREATEHEALTHSTONE        = "Create Healthstone";
SHARDTRACKER_CREATEHEALTHSTONEGREATER = "Create Healthstone (Greater)"; 
SHARDTRACKER_CREATEHEALTHSTONEMAJOR   = "Create Healthstone (Major)"; 
SHARDTRACKER_CREATESOULSTONEMINOR     = "Create Soulstone (Minor)"; 
SHARDTRACKER_CREATESOULSTONELESSER    = "Create Soulstone (Lesser)"; 
SHARDTRACKER_CREATESOULSTONE          = "Create Soulstone"; 
SHARDTRACKER_CREATESOULSTONEGREATER   = "Create Soulstone (Greater)"; 
SHARDTRACKER_CREATESOULSTONEMAJOR     = "Create Soulstone (Major)"; 
SHARDTRACKER_CREATESPELLSTONE         = "Create Spellstone"; 
SHARDTRACKER_CREATESPELLSTONEGREATER  = "Create Spellstone (Greater)"; 
SHARDTRACKER_CREATESPELLSTONEMAJOR    = "Create Spellstone (Major)"; 
SHARDTRACKER_CREATEFIRESTONELESSER    = "Create Firestone (Lesser)"; 
SHARDTRACKER_CREATEFIRESTONE          = "Create Firestone"; 
SHARDTRACKER_CREATEFIRESTONEGREATER   = "Create Firestone (Greater)"; 
SHARDTRACKER_CREATEFIRESTONEMAJOR     = "Create Firestone (Major)"; 
SHARDTRACKER_JOINSTHEPARTY            = "joins the party"; 
SHARDTRACKER_LEAVESTHEPARTY           = "leaves the party";
SHARDTRACKER_GROUPDISBANDED           = "Your group has been disbanded";
SHARDTRACKER_YOULEAVEGROUP            = "You leave the group";
SHARDTRACKER_SOULSTONERES             = "Soulstone Resurrection";
SHARDTRACKER_COOLDOWN                 = "Cooldown remaining";
SHARDTRACKER_COMMON                   = "Common";
SHARDTRACKER_ORCISH                   = "Orcish";
SHARDTRACKER_HUMAN                    = "Human";
SHARDTRACKER_DWARF                    = "Dwarf";
SHARDTRACKER_NIGHTELF                 = "Night Elf";
SHARDTRACKER_GNOME                    = "Gnome";
SHARDTRACKER_SSREADYTOCAST            = "Soulstone Resurrection is ready to recast!";
ST_LIMITANSWER                        = "ShardTracker: Minimum number of shards before shard button flashes set to ";
ST_LIMITUSAGE                         = "Usage: /st limit [0-20]";
ST_ONLYFORWARLOCKS                    = "This function is only available to Warlocks.";
ST_SPELLSTONEERROR                    = "ShardTracker: Unable to equip Spellstone or Firestone!  Perhaps there's not enough pack space to unequip your mainhand weapon?";
ST_DRAGERROR                          = "To reposition the ShardTracker buttons, you must first unlock them with the \"/st unlock\" command.";
ST_LOCKMSG                            = "ShardTracker buttons are now locked in place and functional.  To reposition them, unlock them with the \"/st unlock\" command.";
ST_UNLOCKMSG                          = "ShardTracker buttons are now unlocked.  You may position them anywhere on the screen.  While unlocked, they are NOT FUNCTIONAL.  To lock them in place, use the \"/st lock\" command.";
ST_SCALECHANGE                        = "ShardTracker button scale set to ";
ST_SCALEUSAGE                         = "Usage: /shardtracker scale ";
ST_HEALTHSTONEFLASH                   = "ShardTracker: Healthstone button will flash when you need a new one.";
ST_HEALTHSTONEFLASHOFF                = "ShardTracker: Healthstone button will no longer flash.";
ST_TOGGLEUSAGE                        = "Usage: /shardtracker toggle \[shards\|healthstone\|soulstone\|spellstone\|firestone\]";
ST_SOUNDON                            = "ShardTracker: Sound On";
ST_SOUNDOFF                           = "ShardTracker: Sound Off";
ST_POPUPENABLED                       = "ShardTracker: Soulstone Popup Message Enabled.";
ST_POPUPDISABLED                      = "ShardTracker: Soulstone Popup Message Disabled.";
ST_MONITORINGON                       = "ShardTracker will only communicate with party members on our communication list.";
ST_MONITORINGOFF                      = "ShardTracker will attempt to communicate with all party members.";
ST_BGENABLED                          = "ShardTracker: Shard button background enabled.";
ST_BGDISABLED                         = "ShardTracker: Shard button background disabled.";
ST_PARTYMONITORINGON                  = "ShardTracker is monitoring your party's healthstones.  For this to work, your party members must also be running ShardTracker.  To disable, use \"/st monitor off\".";
ST_PARTYMONITORINGOFF                 = "ShardTracker is not monitoring your party's Healthstones.  To enable, use \"/st monitor on\" and be sure your party members are also running ShardTracker.";
ST_FLASHYGRAPHICSON                   = "ShardTracker: Advanced graphics enabled.";
ST_FLASHYGRAPHICSOFF                  = "ShardTracker: Advanced graphics disabled.";
ST_SOULNAGON                          = "ShardTracker will now nag you about re-casting Soulstone Resurrection.";
ST_SOULNAGOFF                         = "ShardTracker will no longer nag you about re-casting Soulstone Resurrection.";
ST_HEALTHNAGON                        = "ShardTracker will now nag you when party members need a new Healthstone.";
ST_HEALTHNAGOFF                       = "ShardTracker will no longer nag you when party members need a new Healthstone.";
ST_NAGINTERVAL1                       = "ShardTracker will nag you every ";
ST_NAGINTERVAL2                       = " second(s) about Healthstones and Soulstones.";
ST_NAGCOUNT1                          = "ShardTracker will nag you ";
ST_NAGCOUNT2                          = " time(s) before giving up.";
ST_NAGCOUNT3                          = "infinitely (or until you go insane).";
ST_NEEDCHRONOS                        = "Note: You must install Chronos for this function to work.  Please see www.wowwiki.com/Chronos for details.";
ST_MAXSHARDSSET1                      = "ShardTracker: Maximum Soul Shards allowed in inventory set to ";
ST_MAXSHARDSSET2                      = "Any additional shards will automatically be destroyed.  Use at your own risk!  To allow unlimited shards, set this to 0.";
ST_MAXSHARDSSETUNLIMITED              = "ShardTracker: You may now have unlimited Soul Shards in your inventory.";
ST_MAXSHARDSERROR                     = "Usage: /shardtracker maxshards <n>, where n is the maximum number of Soul Shards you want to keep in inventory.  Set n to 0 to allow unlimited Soul Shards.";
ST_DELETEDASHARD                      = "ShardTracker: Soul Shard deleted!";
ST_NIGHTFALLEFFECTON                  = "ShardTracker: Nightfall effect enabled.";
ST_NIGHTFALLEFFECTOFF                 = "ShardTracker: Nightfall effect disabled.";
ST_SHARDEFFECTON                      = "ShardTracker: Shard creation effect enabled.";
ST_SHARDEFFECTOFF                     = "ShardTracker: Shard creation effect disabled.";
ST_BUTTONSARELOCKED                   = "To use this button, you need to lock the ShardTracker interface with \"/st lock\".";
ST_AUTOSORTON                         = "ShardTracker: As you acquire them, shards will now be automatically sorted into the bag specified with the \"/st bag\" command.";
ST_AUTOSORTOFF                        = "ShardTracker: Autosorting disabled.  To manually sort your shards, left-click the Soul Shard button.";

-- needed for info messages below
SHARDTRACKER_COLOR_RED       = "|cffff0000";
SHARDTRACKER_COLOR_YELLOW    = "|cffffff00";
SHARDTRACKER_COLOR_VIOLET    = "|cffbb88dd";
SHARDTRACKER_COLOR_GREY      = "|caaaaaaaa";
SHARDTRACKER_COLOR_WHITE     = "|cffffffff";
SHARDTRACKER_COLOR_BLUE      = "|cff3366ff";
SHARDTRACKER_COLOR_GREEN     = "|cff64c528";
SHARDTRACKER_COLOR_LTGREEN   = "|cffE4FB75";
SHARDTRACKER_COLOR_CLOSE     = "|r";

-- info messages
ST_SHOWINFO_MSG1    = "ShardTracker is a Soul Shard management tool for Warlocks.";
ST_SHOWINFO_MSG2    = "It has two primary functions: keeping you informed about your own shards, and keeping you informed about your party members' Healthstone status.  In the first function, your own shards are managed via four small buttons.  These are initially grouped near your radar, but you may position them where ever you like using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_LOCK_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." and "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.."unlock"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." functions.";
ST_SHOWINFO_MSG3    = "(Note: grabbing onto the buttons to drag can be hit and miss.)";
ST_SHOWINFO_MSG4    = "You can also scale the buttons using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SCALE_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.  Four scales are available: regular, large, biggie, and supersizeme.";
ST_SHOWINFO_MSG5    = "You may toggle the background image of the Shard button using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SHARDBG_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.  Finally, you can "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_RESET_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." the positions of the buttons to their original locations, or if other objects are blocking the original locations, you can use the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_CENTER_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.."command to center them onscreen for your placement.";
ST_SHOWINFO_MSG6    = "The Soul Shard button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." lets you know how many shards you have in your inventory.  This button will turn red and flash when the number of shards drops below a certain level.  Currently this level is set to ";
ST_SHOWINFO_MSG6a   = ", but you may set it to any number you like using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_LIMIT_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
ST_SHOWINFO_MSG7    = "Clicking on this button will sort your shards (including Healthstone, Soulstone, and Spellstones) into the pack of your choice.  Right now, this is set to pack number ";
ST_SHOWINFO_MSG7a   = ", but you may change this using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_BAG_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
ST_SHOWINFO_MSG8    = "The Healthstone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." lets you know if you have a Healthstone.  If you don't have one, clicking on this button will create your highest rank Healthstone.";
ST_SHOWINFO_MSG9    = "Clicking again will use your Healthstone.  Additionally, if you have a friendly player selected, clicking will place the Healthstone into a trade window with that player.";
ST_SHOWINFO_MSG10   = "The Soulstone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." informs you about the status of your Soulstone.";
ST_SHOWINFO_MSG11   = "When you have no Soulstone, the button will be greyed.  Clicking on this button will create your highest rank Soulstone.";
ST_SHOWINFO_MSG12   = "Clicking again will cast Soulstone Resurrection on any friendly target you have selected.  Once cast, the Soulstone button will show a counter representing the number of minutes until you can cast your next Soulstone Resurrection spell.";
ST_SHOWINFO_MSG13   = "When this countdown ends, an alarm will sound and the button will flash to remind you to re-cast Soulstone Resurrection.  You can optionally disable the audible alarm using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SOUND_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
ST_SHOWINFO_MSG14   = "To disable the popup notification, use the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SOUL_POPUP_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
ST_SHOWINFO_MSG15   = "The Spellstone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." shows your Spellstone status.  Clicking this button will create your highest rank Spellstone.";
ST_SHOWINFO_MSG16   = "Clicking again will equip your Spellstone and display the number of seconds until you can use your Spellstone.  Once the timer ends, clicking will activate your Spellstone as well as automatically re-equip whatever weapon you were wielding before you equipped the Spellstone.";
ST_SHOWINFO_MSG15a  = "The Firestone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." shows your Firestone status.  Clicking this button will create your highest rank Firestone.";
ST_SHOWINFO_MSG16a  = "Clicking again will equip your Firestone.  When equipped, clicking will unequip your Firestone and automatically re-equip whatever weapon you were wielding before you equipped the Spellstone.";
ST_SHOWINFO_MSG17   = "The second functionally of the AddOn involves notifying you of your party members' Healthstone status.  Whenever a party member gains a Healthstone, an icon will appear over her party portrait.  When a party member uses her Healthstone, this icon will flash and an alarm will sound.";
ST_SHOWINFO_MSG18   = "For this functionality to work, party members must also be running the Shardtracker AddOn.";
ST_SHOWINFO_MSG19   = "You may optionally disable this functionality using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_MONITOR_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.   In addition, you may create a list of players to monitor.  Only those players in your list will receive communication from ShardTracker.";
ST_SHOWINFO_MSG20   = "You can "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_ADD_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." or "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_REMOVE_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." players from this list, and use the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_RESTRICT_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command to enable or disable the list.  Players running Cosmos that aren't on your list will still have their Healthstones monitored, but ShardTracker will do so silently.";
ST_SHOWINFO_MSG21   = "For specific commands, please see /shardtracker help.";

-- help messages
ST_HELP_MSG1     = "ShardTracker, an AddOn by Cragganmore.  ";
ST_HELP_MSG1A    = "\"Your Soul Is Mine!\"";
ST_HELP_MSG2     = "Based on code by Kithador and Ryu";
ST_HELP_MSG3     = "Usage: ";
ST_HELP_MSG4     = "/shardtracker <command>";
ST_HELP_MSG5     = " or ";
ST_HELP_MSG6     = "/st <command>";
ST_HELP_MSG7     = "Turns ShardTracker on or off.";
ST_HELP_MSG8     = "Toggles the respective button on or off.";
ST_HELP_MSG9     = "Toggles whether you monitor your party's Healthstones.";
ST_HELP_MSG10    = "Sets the default bag to sort shards (0 = backpack, 4 = leftmost bag).";
ST_HELP_MSG11    = "Sorts your shards into the default bag (set with the \"bag\" command).";
ST_HELP_MSG12    = "When your total Shards drops below this number, the shard button will flash to warn you.";
ST_HELP_MSG13    = "Turns audible warnings on or off.";
ST_HELP_MSG14    = "Turns the Soulstone popup alert on or off.";
ST_HELP_MSG15    = "Turns the shard button background image on or off.";
ST_HELP_MSG16    = "Toggles whether your Healthstone button flashes when you need a new one.";
ST_HELP_MSG17    = "When unlocked, the ShardTracker buttons are disabled and may be positioned anywhere on screen.";
ST_HELP_MSG18    = "When locked, the ShardTracker buttons are enabled and unmovable.";
ST_HELP_MSG19    = "Resets the ShardTracker buttons to their default locations.";
ST_HELP_MSG20    = "Places the ShardTracker buttons in the center of the screen, in case they're inaccessible due to other buttons near the radar.";
ST_HELP_MSG21    = "Sets the size/scale of the ShardTracker buttons.";
ST_HELP_MSG22    = "When enabled, ShardTracker will only communicate with party members on our \"OK to communicate with\" list.  Note: Party members running Cosmos will always be communicated with, but silently.";
ST_HELP_MSG23    = "Add a player to our \"OK to communicate with\" list.";
ST_HELP_MSG24    = "Remove a player from our \"OK to communicate with\" list.";
ST_HELP_MSG25    = "Show our \"OK to communicate with\" list.";
ST_HELP_MSG26    = "Displays a detailed description of ShardTracker.";
ST_HELP_MSG27    = "Displays this message.";
ST_HELP_MSG28    = "Example: \"/st flash off\" turns off Healthstone flashing.";
ST_HELP_MSG29    = "Set the sound to play when Soulstone is ready to re-cast.";
ST_HELP_MSG30    = "Set the sound to play when a player needs a new Healthstone.";
ST_HELP_MSG31    = "Toggles advanced graphics effects.";
ST_HELP_MSG32    = "Toggles Soulstone nagging.";
ST_HELP_MSG33    = "Toggles Healthstone nagging.";
ST_HELP_MSG34    = "Sets the number of seconds between each nag.";
ST_HELP_MSG35    = "Sets the number of times to nag before giving up (set to 0 for infinite nagginess!).";
ST_HELP_MSG36    = "Sets the maximum number of Soul Shards allowed in your inventory (extra Shards will be automatically deleted).  Set this to 0 to allow unlimited Shards.";
ST_HELP_MSG37    = "When enabled, causes your screen to glow purple whenever you gain the Nightfall aura. (Requires the ColorCycle AddOn.)"
ST_HELP_MSG38    = "When enabled, causes your screen to flash whenever you gain a Soul Shard. (Requires the ColorCycle AddOn.)"
ST_HELP_MSG39    = "When enabled, ShardTracker will automatically sort your shards into the pack specified by the \"bag\" command."
ST_HELP_ENABLED  = " (enabled)";
ST_HELP_DISABLED = " (disabled)";
