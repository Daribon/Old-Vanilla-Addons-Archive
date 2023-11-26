-- Version : English
-- $LastChangedBy: AlexYoshi $
-- $Date: 2005-07-12 23:54:14 -0500 (Tue, 12 Jul 2005) $

--[[ Cosmos/Khaos Config Strings ]]--
T_HEADER_HELP = "Options related to Thottbot profile and data collection\nhttp://www.thottbot.com/";

T_PROFILE_TEXT = "Collect Personal Equipment Profile";
T_PROFILE_HELP = "Enable Thottbot Profile collection.  Run Cosmos.exe to upload.\nAfter uploading, your profile will be visible at:\n";
T_PROFILE_ENABLED = "Player Profile collection enabled.  Be sure to run Cosmos.exe to upload!\nAfter updating, your profile will be visible at:\n";
T_PROFILE_DISABLED = "Player Profile collection disabled.";
T_PROFILE_TEXT1 = "Equipment and skill information about any character you play will now be gathered and stored.	Running Cosmos.exe will upload this data, immediately updating your profile.";
T_PROFILE_TEXT2 = "Your profile is collected every time you turn this feature on, every time you log in, and every time you type the /tprofile command.";
T_PROFILE_TEXT3 = "After updating, your character profile will be visible on the net at:";

T_TARGET_PROFILE_TEXT = "Collect Target Equipment Profile";
T_TARGET_PROFILE_HELP = "Collects profile data from people you target.  Especially useful to help people who don't have Cosmos.";
T_TARGET_PROFILE_ENABLED = "Target Profile collection enabled.";
T_TARGET_PROFILE_DISABLED = "Target Profile collection disabled.";

T_DATA_TEXT = "Enable Thottbot Data Collection";
T_DATA_HELP = "Help Thottbot!  This option turns on Thottbot data collection, such as mob locations and drops.  This is very safe; no personal information is sent.  Run Cosmos.exe to upload.";
T_DATA_ENABLED = "Thottbot Data Collection Enabled.";
T_DATA_DISABLED = "Thottbot Data Collection Disabled.";

T_HEAVY_TEXT = "Enable Heavy Thottbot Data Collection";
T_HEAVY_HELP = "Heavy data collection collects more information than normal, including tradeskill information and more mob location information, however, it can sometimes have a performance impact.";
T_HEAVY_ENABLED = "Heavy Thottbot Data Collection Enabled.";
T_HEAVY_DISABLED = "Heavy Thottbot Data Collection Disabled.";
T_HEAVY_TEXT1 = "Thottbot Heavy mode collects everything normally collected, plus:";
T_HEAVY_TEXT2 = "- Captures all tradeskill information.";
T_HEAVY_TEXT3 = "- Captures large trainers.";
T_HEAVY_TEXT4 = "- Captures NPC locations when moused over, instead of just when targetted.";
T_HEAVY_TEXT5 = "For those that don't have new tradeskill recipes and aren't in a rarely visited zone, Heavy mode is overkill.";

T_STATE_TEXT = "Display Thottbot State At Startup";
T_STATE_HELP = "Turns on and off the purty THOTTBOT [on/off] state display at startup.";
T_STATE_ENABLED = "Thottbot State Display Enabled.";
T_STATE_DISABLED = "Thottbot State Display Disabled.";

T_SET_DESC = "Thottbot Profile/Data Collection Options";
T_SECTION_DESC = "This section configures the Thottbot plugin.\n http://www.thottbot.com/";

--[[ Slash Command Related Strings ]]--
T_CMD_SIZE_COMLIST = {"/tsize", "/thottbotsize"};
T_CMD_SIZE_HELP = "display size of collected Thottbot data";

T_CMD_STATE_COMLIST = {"/tstate", "/thottbotstate"};
T_CMD_STATE_HELP = "display Thottbot state";

T_CMD_RESET_COMLIST = {"/treset", "/thottbotreset"};
T_CMD_RESET_HELP = "reset Thottbot data";

T_CMD_LOC_COMLIST = {"/tloc", "/thottbotloc"};
T_CMD_LOC_HELP = "display current Thottbot location coordinates";
T_CMD_LOC_MINIMAP = "Current Thottbot location is under the minimap.";
T_CMD_LOC_ZONEMAP = "Target Thottbot location is on the zone map.";
T_CMD_LOC_USAGE = "Usage: /tloc x,y";
T_CMD_LOC_NOTE = "Note: /tloc x,y will show coordinates on the map.";
T_CMD_LOC_NOTE2 = "Note2: /goto x,y will try to take you there!	Use at your own risk.	No refunds.";

T_CMD_PROFILE_COMLIST = {"/tprofile", "/thottbotprofile"};
T_CMD_PROFILE_HELP = "collect Thottbot profile";

T_CMD_GCINFO_COMLIST = {"/gcinfo"};
T_CMD_GCINFO_HELP = "garbage collector information (technical info for modders)";
T_CMD_GCINFO_FORMAT = "%d/%d\n+%d\n+%dk per sec";
T_CMD_GCINFO_FORMAT_WINDOW = "%d/%d\n+%d\n+%dk per sec\n%d sec window";

T_CMD_VER_COMLIST = {"/tver", "/thottbotversion"};
T_CMD_VER_HELP = "Thottbot version";
T_CMD_VER_VERSION = "Thottbot code version: ";

--[[ Miscellaneous Strings ]]--
T_SK = "Skinning";

T_RACE_HUMAN = "Human";
T_RACE_DWARF = "Dwarf";
T_RACE_NELF = "Night Elf";
T_RACE_GNOME = "Gnome";
T_RACE_UNDEAD = "Undead";
T_RACE_TAUREN = "Tauren";
T_RACE_ORC = "Orc";
T_RACE_TROLL = "Troll";

T_SERVER_UNKNOWN = "<ERROR: Your server is unknown!>"
T_IS_DISABLED = "Thottbot is disabled.";
T_DISABLED = "Thottbot disabled.";
T_ENABLED = "Thottbot enabled.";
T_RESET = "Thottbot reset.";

T_STATE_PROFILE = "Profile";
T_STATE_TARGET = "Target Profile";
T_STATE_DATA = "Data";
T_STATE_HEAVY = "Heavy";

T_LANGUAGE_COMM = {"/lang","/language"};
T_LANGUAGE_COMM_INFO = "Changes the language you use to speak.";
T_LANGUAGE_UNKNOWN = "Do not recognize the language %s.";
T_LANGUAGE_NOWSPEAK = "Now speaking %s.";
T_LANGUAGE_HELP1 = "Type /language Darnassian to speak another language.";
T_LANGUAGE_HELP2 = "";

--[[ Thottbot Engine Strings ]]--
T_ENGINE_SIZE = "Thottbot size: ";
T_ENGINE_SLEEP = "Thottbot is full! Thottbot is sleepy. Thottbot takes a nap.";
T_ENGINE_BYTES = " bytes";
T_ENGINE_NEW_ABIL = "You have learned a new ability: %s.";
T_ENGINE_NEW_SPELL = "You have learned a new spell: %s.";
T_ENGINE_SIZE_LIMIT = "Thottbot target profile limit reached, use /treset to reset.";
T_ENGINE_EXP_GAIN = "Experience gained: %d.";
T_ENGINE_FULL = "Thottbot is full!";
T_ENGINE_REALLY_FULL = "I cants fits no more in boss. Even them cement overshoes dont work no more, they just land there on top and dont sink. I think we's filled up the river.";
T_ENGINE_MEMORY = "Thottbot memory statistics";
T_ENGINE_PCOLLECT = "Collecting Thottbot Profile...";
T_ENGINE_PCOMPLETE = "Thottbot Profile Complete!";
T_ENGINE_PABORT = "Profile Aborted";
T_ENGINE_CONTINENT = "Continent ";
--[[ Please be careful if you translate these, verify thottbot still works after translation before commiting ]]--
T_ENGINE_LEARNED_NEW = "You have learned a new (%w+): (.*)";
T_ENGINE_REQ_POINT = "^Requires %d+ points in ";
T_ENGINE_REQ = "Requires (%d+)";
T_ENGINE_CORPSE = "Corpse of %s";
T_ENGINE_PET = "%s's Pet";
T_ENGINE_QUEST_REQ = "Requires (.*)";
T_ENGINE_QUEST_OBJ_COMP = "%s (Complete)";
T_ENGINE_QUEST_COMPLETE = "%s completed.";
T_ENGINE_HEARTHSTONE = "Hearthstone";
T_ENGINE_CREATED_BY = "|cff00ff00<Made by %s>|r";
T_ENGINE_REPUTATION = "Reputation with ([%w%s]+)([%w]+)by (%d+)";
