-- This load method is different from the one Ace(d) addons should use. It has to
-- be done this way here, because the ace object isn't created yet, so
-- ace:LoadTranslation() can't be called.
local loader = getglobal("AceLocals_"..GetLocale())
if( loader ) then loader()
else

-- All text inside quotes is translatable.

ACE_NAME                    = "Ace"
ACE_DESCRIPTION             = "Lightweight, powerful addon development system."
ACE_VERSION_MISMATCH        = "|cffff6060[Ace version mismatch]|r"
ACE_WEBSITE_MSG             = "(website %s)"

-- Load message locals
ACE_LOAD_MSG_SUMMARY        = "|cffffff78Ace Addon Initialization Complete|r%s\n"..
                              "|cffffff78Addons loaded:|r %s%s\n"..
                              "|cffffff78Profile loaded:|r %s\n"..
                              "|cffffff78Type|r |cffd8c7ff/ace|r |cffffff78for more information|r"
ACE_LOAD_MSG_DISABLED       = " (%s disabled)"

-- Addon locals
ACE_ADDON_LOADED            = "|cffffff78%s v%s|r |cffffffffby|r |cffd8c7ff%s|r |cffffffffis now loaded.|r"
ACE_ADDON_CHAT_COMMAND      = "|cffffff78(%s)"
ACE_ADDON_ENABLED           = "|cff00ff00(enabled)|r "
ACE_ADDON_DISABLED          = "|cffff5050(disabled)|r "
ACE_ADDON_ALREADY_ENABLED   = "%s is already enabled."
ACE_ADDON_ALREADY_DISABLED  = "%s is already disabled."
ACE_ADDON_NOW_ENABLED       = "%s is now enabled."
ACE_ADDON_NOW_DISABLED      = "%s is now disabled."

-- Addon Categories
ACE_CATEGORY_BARS           = "Interface Bars"
ACE_CATEGORY_CHAT           = "Chat/Communications"
ACE_CATEGORY_CLASS          = "Class Enhancement"
ACE_CATEGORY_COMBAT         = "Combat/Casting"
ACE_CATEGORY_COMPILATIONS   = "Compilations"
ACE_CATEGORY_INTERFACE      = "Interface Enhancements"
ACE_CATEGORY_INVENTORY      = "Inventory/Item Enhancements"
ACE_CATEGORY_MAP            = "Map Enhancements"
ACE_CATEGORY_OTHERS         = "Other"
ACE_CATEGORY_PROFESSIONS    = "Professions"
ACE_CATEGORY_QUESTS         = "Quest Enhancements"
ACE_CATEGORY_RAID           = "Raid Assistance"

-- Profile locals
ACE_PROFILE_DEFAULT         = "default"
ACE_PROFILE_LOADED_CHAR     = "A separate profile has been loaded for %s."
ACE_PROFILE_LOADED_CLASS    = "The %s class profile has been loaded for %s."
ACE_PROFILE_LOADED_DEFAULT  = "The default profile has been loaded for %s."

-- Information locals
ACE_INFO_HEADER             = "|cffffff78Ace Information|r"
ACE_INFO_MISMATCH           = "\n|cffff5050(%s addons have Ace version mismatches.)|r"
ACE_INFO_NUM_ADDONS         = "Addons loaded"
ACE_INFO_PROFILE_LOADED     = "Profile loaded"

-- Chat handler locals
ACE_COMMANDS                = {"/ace"}
ACE_CMD_OPTIONS             = {
    ["info"] = {
        desc   = "Display addon and current profile information.",
        method = "DisplayInfo"
    },
    ["loadmsg"] = {
        args = {
            ["addon"] = {
                desc   = "Display a load message for each addon.",
                method = "ChangeLoadMsgAddon"
            },
            ["none"]  = {
                desc   = "Do not display any load messages at all.",
                method = "ChangeLoadMsgNone"
            },
            ["sum"]   = {
                desc   = "Display a short summary message.",
                method = "ChangeLoadMsgSum"
            }
        },
        desc = "Change the displaying of load messages at game startup or reload.",
        method = "ChangeLoadMsgSum"
    },
    ["profile"] = {
        args = {
            ["char"]    = {
                desc   = "Use a profile specific to this character.",
                method = "UseProfileChar"
            },
            ["class"]   = {
                desc   = "Use a profile specific to this character's class.",
                method = "UseProfileClass"
            },
            ["default"] = {
                desc   = "Use the default profile for this character.",
                method = "UseProfileDefault"
            },
        },
        desc = "Load one of three profiles, char, class, or default. This loads that profile "..
               "or creates it as a blank profile that will continue to use all addon's "..
               "defaults. To add an addon to the profile, type the addon name after the profile "..
               "name, or type 'all' to add all addons to it. Afterwards, any changes you make "..
               "to that addon's settings will be specific to that profile.",
    }
}

ACE_CMD_OPT_HELP            = "?"
ACE_CMD_OPT_HELP_DESC       = "Detailed information; enter ? or ? <option>"
ACE_CMD_OPT_ENABLE          = "enable"
ACE_CMD_OPT_ENABLE_DESC     = "Enables %s"
ACE_CMD_OPT_DISABLE         = "disable"
ACE_CMD_OPT_DISABLE_DESC    = "Disables %s"
ACE_CMD_OPT_REPORT          = "report"
ACE_CMD_OPT_REPORT_DESC     = "Display the status of all settings"
ACE_CMD_OPT_INVALID         = "Invalid option '%s' entered."
ACE_CMD_OPT_NONE            = "Additional input is required."

ACE_CMD_PROFILE_NO_ADDON    = "No addon named '%s' was found."
ACE_CMD_PROFILE_ADDON_ADDED = "%s has been added to the current profile: %s."
ACE_CMD_PROFILE_ALL         = "all"
ACE_CMD_PROFILE_NO_PROFILE  = "%s has no profiling options available."

ACE_CMD_LOADMSG_ADDON       = "A load message will be displayed for each addon."
ACE_CMD_LOADMSG_NONE        = "No load messages will be displayed."
ACE_CMD_LOADMSG_SUM         = "A summary message will be displayed at load."

ACE_CMD_USAGE_ADDON_DESC    = "|cffffff78[%s v%s]|r : %s"
ACE_CMD_USAGE_HEADER        = "|cffffff78Usage:|r |cffd8c7ff%s|r %s"
ACE_CMD_USAGE_OPT_DESC      = " - |cffffff78%s:|r %s"
ACE_CMD_USAGE_OPT_SEP       = " | "
ACE_CMD_USAGE_OPT_OPEN      = "["
ACE_CMD_USAGE_OPT_CLOSE     = "]"
ACE_CMD_USAGE_OPTION        = "|cffd8c7ff%s %s|r %s"
ACE_CMD_USAGE_NOARGS        = "- No further information"

ACE_CMD_RESULT              = "|cffffff78%s:|r %s"

ACE_CMD_REPORT_STATUS       = "Status"
ACE_CMD_REPORT_LINE         = " - %s [|cfff5f530%s|r]"

ACE_CMD_REPORT_NO_VAL       = "no value"

ACE_TEXT_OF                 = "of"
ACE_TEXT_AUTHOR             = "Author"
ACE_TEXT_EMAIL              = "Email"
ACE_TEXT_RELEASED           = "Released"
ACE_TEXT_WEBSITE            = "Website"

end


loader = nil
