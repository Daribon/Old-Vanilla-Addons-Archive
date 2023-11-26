
--[[ Miscellaneous variables and localization strings for Recap 2.6 ]]

recap_temp = {};

--[[ Filter method  ]]

-- filter method largely taken from Telo's MobHealth. source=5 when it's the player
-- effect=6 when it's Melee, effect=7 when it's a damage shield
-- crit=1 when the pattern identifies a crit
recap_temp.Filter = {
		{ pattern="Your (.+) hits (.+) for (%d+)", source=5, dest=2, damage=3, effect=1 },
		{ pattern="Your (.+) crits (.+) for (%d+)", source=5, dest=2, damage=3, effect=1, crit=1 },
		{ pattern="Your (.+) causes (.+) (%d+) damage", source=5, dest=2, damage=3, effect=1 },
		{ pattern="You suffer (%d+) (.+) damage from (.+)'s (.+)", source=3, dest=5, damage=1, effect=4 },
		{ pattern="(.+) suffers (%d+) (.+) damage from your (.+)", source=5, dest=1, damage=2, effect=4 },
		{ pattern="You reflect (%d+) (.+) damage to (.+)", source=5, dest=3, damage=1, effect=7 },
		{ pattern="You hit (.+) for (%d+)", source=5, dest=1, damage=2, effect=6 },
		{ pattern="You crit (.+) for (%d+)", source=5, dest=1, damage=2, effect=6, crit=1 },
		{ pattern="(.+)'s (.+) hits (.+) for (%d+)", source=1, dest=3, damage=4, effect=2 },
		{ pattern="(.+)'s (.+) crits (.+) for (%d+)", source=1, dest=3, damage=4, effect=2, crit=1 },
		{ pattern="(.+)'s (.+) causes (.+) (%d+) damage", source=1, dest=3, damage=4, effect=2 },
		{ pattern="(.+) reflects (%d+) (.+) damage to (.+)", source=1, dest=4, damage=2, effect=7 },
		{ pattern="(.+) suffers (%d+) .+ damage from (.+)'s (.+)", source=3, dest=1, damage=2, effect=4 },
		{ pattern="(.+) hits (.+) for (%d+)", source=1, dest=2, damage=3, effect=6 },
		{ pattern="(.+) crits (.+) for (%d+)", source=1, dest=2, damage=3, effect=6, crit=1 } };
recap_temp.FilterSize = 15; -- number of filters, change to recap_temp.Filter size

-- separate filter for heals, processed apart from damage hits from above
-- but same rules: source=5 is player, effect=6 is melee, effect=7 is damage shield, crit=1 is a crit
recap_temp.HealFilter = {
		{ pattern="You gain (%d+) health from (.+)'s (.+)", source=2, dest=5, heal=1, effect=3 },
		{ pattern="You gain (%d+) health from (.+)", source=5, dest=5, heal=1, effect=2 },
		{ pattern="(.+) gains (%d+) health from your (.+)", source=5, dest=1, heal=2, effect=3 },
		{ pattern="(.+) gains (%d+) health from (.+)'s (.+)", source=3, dest=1, heal=2, effect=3 },
		{ pattern="Your (.+) critically heals (.+) for (%d+)", source=5, dest=2, heal=3, effect=1, crit=1 },
		{ pattern="Your (.+) heals (.+) for (%d+)", source=5, dest=2, heal=3, effect=1 },
		{ pattern="(.+)'s (.+) critically heals (.+) for (%d+)", source=1, dest=3, heal=4, effect=2, crit=1 },
		{ pattern="(.+)'s (.+) heals (.+) for (%d+)", source=1, dest=3, heal=4, effect=2 } };
recap_temp.HealFilterSize = 8;

recap_temp.DeathFilter = {
		{ pattern="You die.", victim=5 },
		{ pattern="(.+) has died", victim=1 },
		{ pattern="(.+) dies", victim=1 } };
recap_temp.DeathFilterSize = 3;

--[[ Tooltips, option indexes ]]

-- First field each line MUST NOT CHANGE (they are option id's)
-- the order MUST NOT CHANGE until HeaderTime.  They are in the order of GetID values
recap_temp.OptList = {
    { "UseColor", "Use Color", "When checked, friendly combatants and damage dealt to others are colored green, incoming damage is colored red." },
    { "GrowUpwards", "Expand Window Up", "When checked, the window's bottom edge will remain anchored while the top edge resizes." },
    { "GrowLeftwards", "Expand Window Left", "When checked, the window's right edge will remain anchored while the left edge resizes." },
    { "ShowTooltips", "Show Tooltips", "When checked, tooltips like the one you're reading will be shown." },
    { "AutoHide", "Auto Hide Entering Combat", "When checked, and the window isn't minimized, it will hide when a fight begins and reappear when the fight ends." },
    { "AutoFade", "Auto Fade Window", "When checked, and the window isn't minimized, the window will fade after your mouse leaves the window." },
    { "LimitFights", "Limit Fights to Combat", "When checked, fight logging will not begin until you enter combat mode.  Recommended Off unless you don't want to log fights around you." },
    { "HideZero", "Show Only Fights With Duration", "When checked, fights without a duration will not be shown.  Use this to hide damage done to totems, critters, etc." },
    { "HideFoe", "Show Only Friendly Combatants", "When checked, only fight information from friendly combatants will be shown.  Right-click a name to toggle its friend/foe status." },
    { "IdleFight", "End Fight If Idle", "When checked, fights will end if no hits happen for a length of time." },
    { "Time", "Display Time", "When checked, each combatants' time fighting will be displayed in the list." },
    { "MaxHit", "Display Max Hit", "When checked, each combatants' max hit will be displayed in the list." },
    { "DmgIn", "Display Damage In", "When checked, each combatants' total damage received will be displayed in the list." },
    { "DmgOut", "Display Damage Out", "When checked, each combatants' total damage dealt to others will be displayed in the list." },
    { "DPS", "Display DPS", "When checked, each combatants' damage per second dealt to others will be displayed in the list." },
    { "DPSIn", "Display Total DPS In", "When checked, the total damage per second friendly combatants received will be displayed in totals." },
    { "MinStatus", "Display Status While Minimized", "When checked, the status light will remain visible while minimized." },
    { "MinView", "Display Last/All While Minimized", "When checked, a small label indicating if you are watching the Last Fight or All Fights will be visible while minimized." },
    { "MinYourDPS", "Display Your DPS While Minimized", "When checked, your DPS will be displayed in minimized view." },
    { "MinDPSIn", "Display Total DPS In While Minimized", "When checked, the total damage per second friendly combatants received will be displayed in minimized view." },
    { "MinDPSOut", "Display Total DPS Out While Minimized", "When checked, the total damage per second friendly combatants dealt to others will be displayed in minimized view." },
    { "MinButtons", "Display Buttons While Minimized", "When checked, the buttons along the top-right edge (Close, Pin, Pause, Options, Last/All) will remain visible in minimized view." },
    { "TooltipFollow", "Tooltips At Pointer", "When checked, tooltips will follow the pointer instead of using the default tooltip placement. Note: Many mods override default tooltip behavior." },
    { "SaveFriends", "Only Save Friends", "When checked, only combatants currently marked as a friend will be saved to fight data sets.  To change the friend status of a combatant, right-click their name." },
    { "ReplaceSet", "Replace Existing Data", "When checked, sets saved and loaded will replace existing data.  Otherwise the data will merge." },
    { "Heal", "Display Heals", "When checked, each combatants' heals will be displayed in the list." },
    { "Kills", "Display Deaths", "When checked, the number of deaths for each combatant will be displayed in the list." },
    { "HideYardTrash", "Show Only Unique Combatants", "When checked, non-friendly combatants that have died more than once will be hidden.  Useful in single instance runs to hide yard trash or common mobs." },
    { "SpamRows", "Report Rankings in Rows", "When checked, shift+click on a header with the chat bar up will post the top ten ranking in rows instead of one line, for readability at the expense of spam." },
    { "SelfTotal", "Display Total", "When checked, the total damage or heals per effect will be displayed in Details view." },
    { "SelfRate", "Display Contribution", "When checked, the percent contribution of an effect to total damage or healing will be displayed in Details view." },
    { "SelfHits", "Display Normal Hits", "When checked, the number of normal hits will be displayed in Details view." },
    { "SelfMaxHit", "Display Normal Max Hit", "When checked, the highest max hit of normal hits will be displayed in Details view." },
    { "SelfCrits", "Display Critical Hits", "When checked, the number of critical hits will be displayed in Details view." },
    { "SelfMaxCrit", "Display Critical Max Hit", "When checked, the highest max critical hit will be displayed in Details view." },
    { "SelfCritRate", "Display Crit Rate", "When checked, the crit rate as a percentile will be displayed in Details view." },
	{ "Faction", "Display Faction", "When checked, if a combatant's faction is known its icon will be displayed by their name." },
	{ "Class", "Display Class", "When checked, if a combatant's class is known its icon will be displayed by their name." },
	{ "HealP", "Display Heals %", "When checked, a percentage of total friendly heals will be displayed for each friendly combatant." },
	{ "DmgInP", "Display Damage In %", "When checked, a percentage of total friendly damage received will be displayed for each friendly combatant." },
	{ "DmgOutP", "Display Damage Out %", "When checked, a percentage of total friendly damage dealt to others will be displayed for each friendly combatant." },
	{ "AutoPost", "Auto Post Results", "When checked, a summary will be reported at the end of each fight to the channel selected below." },
	{ "MinBack", "Display Back While Minimized", "When checked, the background will remain opaque in minimized view." },
	{ "MergePets", "Merge Pets With Owners", "When checked, from that point on, all friendly pet damage will be credited to its owner.  When unchecked, from that point on, all friendly pet damage will be credited to the pet." },

    -- tooltips that don't change can go below in any order. ensure future options go above these
    { "HeaderTime", "Fight Time", "This is the time each combatant fought from their first point of damage to their last." },
    { "HeaderMaxHit", "Max Hit", "This is the maximum damage each combatant dealt to others in a single hit or spell." },
    { "HeaderDmgIn", "Damage In", "This is the damage received (tanked) by each combatant." },
    { "HeaderDmgOut", "Damage Out", "This is the damage dealt to others by each combatant." },
    { "HeaderDPS", "Damage Per Second", "This is the damage per second dealt to others by each combatant." },
    { "HeaderHeal", "Heals Out", "This is the hit points healed by this combatant." },
    { "HeaderKills", "Death Count", "This is the number of times this combatant died within logging distance." },
    { "Options", "Open Options", "Summon or dismiss the options window to change settings or manage fight data sets." },
    { "TooltipMinYourDPS", "Your DPS", "This is your personal DPS, including pet." },
    { "TooltipMinDPSIn", "DPS In", "This is the total damage received by friendly combatants." },
    { "TooltipMinDPSOut", "DPS Out", "This is the total damage dealt to others from friendly combatants." },
    { "AutoFadeSlider", "Auto Fade Timer", "This is the time before the window fades after you leave it if Auto Fade Window is checked." },
    { "IdleFightSlider", "Fight Idle Timer", "This is the idle time before a fight will end if End Fight If Idle is checked." },
    { "MinPinned", "Window Pinned", "This window is now locked to this position.  Right-click again to make it movable." },
    { "MinUnpinned", "Window Unpinned", "This window is now unlocked and movable.  Right-click again to lock it in position." },
    { "ExitRecap", "Exit Recap", "Fight monitoring is suspended. Click here to shut down Recap completely." },
    { "HideWindow", "Hide Window", "Continue monitoring fights, but hide this window." },
    { "ExpandWindow", "Expand Window", "Expand window to show fight details." },
    { "MinimizeWindow", "Minimize Window", "Minimize window and hide fight details." },
    { "UnPinWindow", "Unpin Window", "Allow window to be moved." },
    { "PinWindow", "Pin Window", "Prevent window from being moved." },
    { "Resume", "Resume Monitoring", "Fight logging is currently suspended.  Click here to start watching fights." },
    { "PauseMonitoring", "Pause Monitoring", "Click here to stop watching fights.  If you dismiss Recap while paused, it will not attempt to log any fights until you summon it." },
    { "ShowAllFights", "Show All Fights", "Currently the window is displaying the result of the last fight.  Click here to show all fights since last reset." },
    { "ShowLastFight", "Show Last Fight", "Currently the window is displaying all fights since the last reset.  Click here to show only the last fight." },
    { "CombatLast", "Combatants for Last Fight", "This is a list of all combatants that did damage in the last fight.  To change a friend status, right-click the name." },
    { "CombatAll", "Combatants for All Fights", "This is a list of all combatants that did damage since your last reset.  The change a friend status, right-click the name." },
    { "ResetLastFight", "Reset Last Fight", "This will wipe the fight data for just the last fight.  Note: Max hits can only be reset by resetting All Fights." },
    { "ResetAllTotals", "Reset All Totals", "This will wipe all active fight data for all combatants, except for those stored in Fight Data Sets.  Those can only be deleted from within options." },
    { "SaveSet", "Save Fight Data Set", "Click here to save the current fight data." },
    { "LoadSet", "Load Fight Data Set", "Click here to load the selected fight data." },
    { "DeleteSet", "Delete Fight Data Set", "Click here to delete the selected fight data set." },
    { "DataSetEdit", "Fight Data Set Name", "Select a data set listed above or enter a new name here to create a new data set." },
    { "OptExit", "Exit Recap", "Suspend fight monitoring and exit Recap completely."},
    { "ShowDetails", "Show Damage Details", "Show a breakdown of your damage and healing by type." },
    { "HideDetails", "Hide Damage Details", "Hide damage details and return to Last/All fight." },
    { "ResetSelfView", "Reset Effect Details", "This will wipe the current effects totals such as damage and crit by type.  It will not alter Last or All Fights in any way." },
    { "EffectsHeader1", "Effect Name", "This is the name of the effect you or your pet used that caused or healed damage.  Green effects are damage, red are heals." },
    { "EffectsHeader2", "Total Amount", "This is the amount of damage or healing this effect did since effects were last reset.  This total is independent of Last/All fights and includes both normal and critical hits." },
    { "EffectsHeader3", "Total Contribution", "This is the percent contribution this effect contributed to your total damage or healing." },
    { "EffectsHeader4", "Normal Hits", "This is the number of times this effect landed without a critical." },
    { "EffectsHeader5", "Normal Max Hit", "This is the max hit of this effect when it landed without a critical." },
    { "EffectsHeader6", "Critical Hits", "This is the number of times this effect landed with a critical." },
    { "EffectsHeader7", "Critical Max Hit", "This is the max hit of this effect when it landed with a critical." },
    { "EffectsHeader8", "Crit Rate", "This is the 'crit rate' of this effect as a percentile: Crits/(Hits+Crits).\n\nNote: Some effects like Immolate and Moonfire can crit on the initial hit but cannot crit on future ticks.  The crit rate has no meaning for effects such as those." },
	{ "HeaderHealP", "% Heals", "This is the percent of total heals for each friendly combatant." },
	{ "HeaderDmgInP", "% Damage In", "This is the percent of total for each friendly combatants' damage received." },
	{ "HeaderDmgOutP", "% Damage Out", "This is the percent of total for each friendly combatants' damage dealt to others." },
	{ "OptTab1", "Display Options", "These options define what elements of the window to display in its various forms.\n\nNote: None of the display settings affect data.  You can turn off everything for normal use, and later reveal elements you want to see." },
	{ "OptTab2", "General Settings", "These options define window behavior, limits to data and miscellaneous options." },
	{ "OptTab3", "Fight Data Sets", "Here you can manage Fight Data Sets.  Fight Data Sets are compact archives of the 'All Fights' view." },
	{ "MaxRowsSlider", "Maximum Rows", "Adjust this to change the maximum rows the window can grow." },
	{ "MaxRankSlider", "Maximum Rank", "This adjusts a limit on how many combatants to report to chat." }
  };

-- misc localization strings
recap_temp.Local = {
    VerboseLinkStart = "%s took %s damage and dealt %s damage over %s for %s DPS (max hit %d)",
    Pronoun = "you",  -- Used when player is the recipient of damage "An orc hits you for 5"
    LastAll = { Last="Last Fight", All="All Fights" },
    LinkRank = { Time="Time Fighting", MaxHit="Max Hit", DmgIn="Damage Tanked", DmgOut="Damage Dealt", DPS="DPS", Heal="Healing", Kills="Deaths", HealP="Healing", DmgInP="Damage Tanked", DmgOutP="Damage Dealt" },
    StatusTooltip = "When this light is red, fight monitoring is suspended.\n\nWhen this light is green, a fight is currently being monitored.\n\nWhen this light is off, Recap is idle and waiting for a fight to begin.\n",
    RankUsage = "To copy a recap to chat, begin a chat and then shift+click. ie:\n|cFFAAAAFF/p (shift+click on Time)|cFFFFFFFF <- sends a ranking of times to /p\n|cFFFF8000/ra (shift+click on DPS)|cFFFFFFFF <- sends a ranking of DPS to /ra",
	ListMenu = { Add =    { "Add Friend", "Add %s", "Add %s to the list of friends." },
				 Drop =   { "Drop Friend", "Drop %s", "Remove %s from the list of friends."},
				 Reset =  { "Reset", "Reset %s", "Reset stats for %s." },
				 Ignore = { "Ignore", "Ignore %s", "Ignore %s from now until next reset." } },
	SkipChannels = { "General", "Trade", "WorldDefense", "LocalDefense", "LookingForGroup" },
  };

BINDING_HEADER_RECAP = "Recap";

--[[ Defaults ]]

recap_temp.DefaultOpt = {
		-- window state settings
		["View"] = 				{ type="Button", value="All" },
		["SelfView"] =			{ type="Flag", value=false },
		["SortBy"] =			{ type="Flag", value="Name" },
		["SortDir"] =			{ type="Flag", value=true },
		["State"] =				{ type="Flag", value="Idle" },
		["Visible"] =			{ type="Flag", value=true },
		["Minimized"] = 		{ type="Button", value=false },
		["Pinned"] = 			{ type="Button", value=false },
		["Paused"] =			{ type="Button", value=false },
		-- user settings options
		["UseColor"] =			{ type="Check", value=true },
		["GrowUpwards"] =		{ type="Check", value=false },
		["GrowLeftwards"] =		{ type="Check", value=true },
		["ShowTooltips"]=		{ type="Check", value=true },
		["TooltipFollow"] =		{ type="Check", value=false },
		["AutoHide"] =			{ type="Check", value=false },
		["AutoFade"] =			{ type="Check", value=false },
		["AutoFadeTimer"] =		{ type="Slider", value=5 },
		["LimitFights"] =		{ type="Check", value=false },
		["HideZero"] =			{ type="Check", value=false },
		["HideFoe"] = 			{ type="Check", value=false },
		["HideYardTrash"] = 	{ type="Check", value=false },
		["MergePets"] =			{ type="Check", value=false },
		["IdleFight"] =			{ type="Check", value=true },
		["IdleFightTimer"] = 	{ type="Slider", value=15 },
		["MaxRows"] =			{ type="Slider", value=10 },
		-- fight reporting
		["SpamRows"] = 			{ type="Check", value=false },
		["MaxRank"] =			{ type="Slider", value=5 },
		["AutoPost"] =			{ type="Check", value=false, Channel="Self", Stat="DPS" },
		-- fight data sets
		["SaveFriends"] = 		{ type="Check", value=false },
		["ReplaceSet"] = 		{ type="Check", value=true },
		-- list elements
		["Faction"] = 			{ type="Check", value=false, width=14 },
		["Class"] = 			{ type="Check", value=true, width=14 },
		["Kills"] =				{ type="Check", value=false, width=28 },
		["Time"] = 				{ type="Check", value=true, width=45 },
		["Heal"] =				{ type="Check", value=false, width=52 },
		["HealP"] =				{ type="Check", value=false, width=32 },
		["DmgIn"] = 			{ type="Check", value=true, width=52 },
		["DmgInP"] =			{ type="Check", value=false, width=32 },
		["DmgOut"] =			{ type="Check", value=true, width=52 },
		["DmgOutP"] =			{ type="Check", value=false, width=32 },
		["MaxHit"] = 			{ type="Check", value=true, width=34 },
		["DPS"] = 				{ type="Check", value=true, width=45 },
		["DPSIn"] = 			{ type="Check", value=true },
		-- minimized elements
		["MinStatus"] = 		{ type="Check", value=true, minwidth=16 },
		["MinView"] = 			{ type="Check", value=false, minwidth=35 },
		["MinYourDPS"] = 		{ type="Check", value=true, minwidth=45 },
		["MinDPSIn"] = 			{ type="Check", value=false, minwidth=45 },
		["MinDPSOut"] = 		{ type="Check", value=false, minwidth=45 },
		["MinButtons"] = 		{ type="Check", value=false },
		["MinBack"] =			{ type="Check", value=true },
		-- details elements
		["SelfTotal"] =			{ type="Check", value=true, selfwidth=55 },
		["SelfRate"] = 			{ type="Check", value=true, selfwidth=40 },
		["SelfHits"] = 			{ type="Check", value=true, selfwidth=35 },
		["SelfMaxHit"] = 		{ type="Check", value=true, selfwidth=40 },
		["SelfCrits"] = 		{ type="Check", value=true, selfwidth=35 },
		["SelfMaxCrit"] = 		{ type="Check", value=true, selfwidth=40 },
		["SelfCritRate"] = 		{ type="Check", value=true, selfwidth=50 }
};

recap_temp.DefaultCombatant = {
		TotalTime = 0,
		TotalDmgIn = 0,
		TotalDmgOut = 0,
		TotalDPS = 0,
		TotalMaxHit = 0,
		TotalKills = 0,
		TotalHeal = 0,
		LastTime = 0,
		LastDmgIn = 0,
		LastDmgOut = 0,
		LastDPS = 0,
		LastMaxHit = 0,
		LastKills = 0,
		LastHeal = 0,
		WasInLast = false,
		Friend = false,
		Ignore = false,
		Owner = nil
};

--[[ Misc variables ]]

recap_temp.Loaded = false;
recap_temp.Player = nil;
recap_temp.Server = nil;
recap_temp.p = nil;
recap_temp.Last = {}; -- last fight indexed by name
recap_temp.List = {}; -- constructed display list, numerically indexed
recap_temp.ListSize = 0; -- number of .List values
recap_temp.SelfList = {}; -- list for damage breakdown
recap_temp.SelfListSize = 0;
recap_temp.FightStart = 0; -- time fight started
recap_temp.FightEnd = 0; -- time fight ended
recap_temp.IdleTimer = -1; -- 0+ = time since last hit happened
recap_temp.FadeTimer = -1; -- 0+ = time since left window
recap_temp.UpdateTimer = 0; -- 0+ = time since last window update
recap_temp.ColorDmgIn =  { r=0.90, g=0.25, b=0.25 };
recap_temp.ColorDmgOut = { r=0.25, g=0.90, b=0.25 };
recap_temp.ColorHeal =	 { r=0.50, g=0.75, b=1.00 };
recap_temp.ColorGreen =  { r=0.25, g=0.90, b=0.25 };
recap_temp.ColorRed =    { r=0.90, g=0.25, b=0.25 };
recap_temp.ColorWhite =  { r=0.85, g=0.85, b=0.85 };
recap_temp.ColorBlue =	 { r=0.25, g=0.75, b=1.00 };
recap_temp.ColorNone =   { r=1.00, g=0.82, b=0.00 };
recap_temp.FightSets = {}; -- list of fight data sets
recap_temp.FightSetsSize = 1; -- size of fight list
recap_temp.FightSetSelected = 0;
recap_temp.FilterIndex = {}; -- list to hold filter finds
recap_temp.MinTime = 0.9; -- threshhold to calculate DPS (still accumulates time)
recap_temp.UpdateDuration = 0; -- minimized update total time
recap_temp.UpdateDmgIn = 0; -- minimized update total dmg in
recap_temp.UpdateDmgOut =0; -- minimized update total dmg out

recap_temp.ClassIcons = {
	["Warrior"] = { left=0.025, right=0.225, top=0.025, bottom=0.225 },
	["Mage"] = { left=0.275, right=0.475, top=0.025, bottom=0.225 },
	["Rogue"] = { left=0.525, right=0.725, top=0.025, bottom=0.225 },
	["Druid"] = { left=0.775, right=0.975, top=0.025, bottom=0.225 },
	["Hunter"] = { left=0.025, right=0.225, top=0.275, bottom=0.475 },
	["Shaman"] = { left=0.275, right=0.475, top=0.275, bottom=0.475 },
	["Priest"] = { left=0.525, right=0.725, top=0.275, bottom=0.475 },
	["Warlock"] = { left=0.775, right=0.975, top=0.275, bottom=0.475 },
	["Paladin"] = { left=0.025, right=0.225, top=0.525, bottom=0.725 },
	["Pet"] = { left=0.275, right=0.475, top=0.525, bottom=0.725 }
};

recap_temp.FactionIcons = {
	["Alliance"] = "Interface\\TargetingFrame\\UI-PVP-Alliance",
	["Horde"] = "Interface\\TargetingFrame\\UI-PVP-Horde"
};

-- auto-post drop down choices
recap_temp.StatDropList = {	"DPS", "Damage", "Tanking", "Healing" };
recap_temp.ChannelDropList = { "Self", "Party", "Say", "Raid", "Guild" }; 

-- to help keep saved sets from bloat, commonly used strings will be replaced
-- with indexes to this table.  The indexes need to remain in this order.  Add
-- new keys to the end.
recap_temp.Keys = {
	"Alliance", "Horde",
	"Warrior", "Mage", "Rogue", "Druid", "Hunter",
	"Shaman", "Priest", "Warlock", "Paladin"
}

-- German translation by Mojo, IceH, Maischter and Szudri at http://www.curse-gaming.com/mod.php?addid=761
if (GetLocale()=="deDE") then

	recap_temp.Filter = {
		{ pattern="(.+) von Euch trifft (.+) f\195\188r (%d+) Schaden", source=5, dest=2, damage=3, effect=1 },
		{ pattern="Ihr trefft (.+) kritisch f\195\188r (%d+) Schaden", source=5, dest=1, damage=2, effect=6, crit=1 },
		{ pattern="Ihr trefft (.+)%. Schaden: (%d+)", source=5, dest=1, damage=2, effect=6 },
		{ pattern="(.+) erleidet (%d+) (%a+)schaden %(durch (.+)%)", source=5, dest=1, damage=2, effect=4 },
		{ pattern="Ihr erleidet (%d+) (%w+)schaden von (.+) %(durch (.+)%)", source=3, dest=5, damage=1, effect=4 },
		{ pattern="(.+) erleidet (%d+) %w+schaden von (.+) %(durch (.+)%)", source=3, dest=1, damage=2, effect=4 },
		{ pattern="(.+) trifft (.+)%. f\195\188r (%d+) Schaden", source=1, dest=2, damage=3, effect=6 },
		{ pattern="(.-)s (.+) trifft (.+) kritisch f\195\188r (%d+) Schaden", source=1, dest=3, damage=4, effect=2, crit=1 },
		{ pattern="(.-)s (.+) trifft (.+) f\195\188r (%d+) Schaden", source=1, dest=3, damage=4, effect=2 },
		{ pattern="Ihr reflektiert (%d+) (.+)schaden auf (.+)", source=5, dest=3, damage=1, effect=7 },
		{ pattern="(.+) reflektiert (%d+) (.+)schaden auf (.+)", source=1, dest=4, damage=2, effect=7 },
		{ pattern="(.+) trifft Euch .-%(mit (.+)%)%. Schaden: (%d+)", source=1, dest=5, damage=3, effect=2 },
		{ pattern="(.+) trifft Euch kritisch .-%(mit (.+)%)%. Schaden: (%d+)", source=1, dest=5, damage=3, effect=2, crit=1,},
		{ pattern="(.+) trifft (.+) .-%(mit (.+)%)%. Schaden: (%d+)", source=1, dest=2, damage=4, effect=3 },
		{ pattern="(.+) trifft (.+) kritisch f\195\188r (%d+) Schaden", source=1, dest=2, damage=3, effect=6, crit=1 },
		{ pattern="(.+) trifft Euch f\195\188r (%d+) Schaden", source=1, dest=5, damage=2, effect=6 },
		{ pattern="(.+) trifft Euch kritisch%. Schaden: (%d+)", source=1, dest=5, damage=2, effect=6, crit=1 },
		{ pattern="(.+) trifft (.+) kritisch%. Schaden: (%d+)", source=5, dest=2, damage=3, effect=1, crit=1 } };
	recap_temp.FilterSize = 18; -- number of filters, change to recap_temp.Filter size

	recap_temp.HealFilter = {
		{ pattern="(.+)s (.+) heilt (.+) um (%d+) Punkte", source=1, dest=3, heal=4, effect=2 },
		{ pattern="(.+) benutzt (.+) und heilt Euch um (%d+) Punkte", source=1, dest=5, heal=3, effect=2 },
		{ pattern="Ihr erhaltet (%d+) Gesundheit von (.+) (durch (.+))", source=2, dest=5, heal=1, effect=3 },
		{ pattern="Ihr erhaltet (%d+) Gesundheit durch (.+)", source=5, dest=5, heal=1, effect=2 },
		{ pattern="(.+) erh\195\164lt (%d+) Gesundheit durch (.+)", source=5, dest=1, heal=2, effect=3 },
		{ pattern="(.+) erh\195\164lt (%d+) Gesundheit von (.+)s (.+)", source=3, dest=1, heal=2, effect=4 },
		{ pattern="Besondere Heilung: (.+) heilt Euch um (%d+) Punkte", source=5, dest=5, heal=2, effect=1, crit=1 },
		{ pattern="Besondere Heilung: (.+) heilt (.+) um (%d+) Punkte", source=5, dest=2, heal=3, effect=1, crit=1 },
		{ pattern="Besondere Heilung: (.+)s (.+) heilt (.+) um (%d+) Punkte", source=1, dest=3, heal=4, effect=2, crit=1 },
		{ pattern="(.+) heilt Euch um (%d+) Punkte", source=5, dest=5, heal=2, effect=1 },
		{ pattern="(.+) benutzt (.+) und Heilt Euch um (%d+) Punkte", source=1, dest=5, heal=3, effect=2 },
		{ pattern="(.+) heilt (.+) um (%d+) Punkte", source=5, dest=2, heal=3, effect=1 } };
	recap_temp.HealFilterSize = 12;

	recap_temp.DeathFilter = {
		{ pattern="Ihr sterbt.", victim=5 },
		{ pattern="(.+) ist tot", victim=1 },
		{ pattern="(.+) stirbt", victim=1 } };
	recap_temp.DeathFilterSize = 3;

	recap_temp.ClassIcons = {
		["Krieger"] = { left=0.025, right=0.225, top=0.025, bottom=0.225 },
		["Magier"] = { left=0.275, right=0.475, top=0.025, bottom=0.225 },
		["Schurke"] = { left=0.525, right=0.725, top=0.025, bottom=0.225 },
		["Druide"] = { left=0.775, right=0.975, top=0.025, bottom=0.225 },
		["J\195\164ger"] = { left=0.025, right=0.225, top=0.275, bottom=0.475 },
		["Schamane"] = { left=0.275, right=0.475, top=0.275, bottom=0.475 },
		["Priester"] = { left=0.525, right=0.725, top=0.275, bottom=0.475 },
		["Hexenmeister"] = { left=0.775, right=0.975, top=0.275, bottom=0.475 },
		["Paladin"] = { left=0.025, right=0.225, top=0.525, bottom=0.725 },
		["Pet"] = { left=0.275, right=0.475, top=0.525, bottom=0.725 }
	};

	recap_temp.FactionIcons = {
		["Allianz"] = "Interface\\TargetingFrame\\UI-PVP-Alliance",
		["Horde"] = "Interface\\TargetingFrame\\UI-PVP-Horde"
	};

	recap_temp.Keys = {	"Allianz","Horde", "Krieger","Magier","Schurke","Druide","J\195\164ger",
						"Schamane","Priester","Hexenmeister","Paladin" }

end


-- French translation by Oxman and Fabinou at http://www.curse-gaming.com/mod.php?addid=761
if (GetLocale()=="frFR") then

	recap_temp.Filter = {
		{ pattern="Votre (.+) touche (.+) avec un coup critique et inflige (%d+) points de", source=5, dest=2, damage=3, crit=1, effect=1 },
		{ pattern="Votre (.+) touche (.+) et inflige (%d+) points de d\195\169g\195\162ts", source=5, dest=2, damage=3, effect=1 },
		{ pattern="Votre (.+) cause (.+) (%d+) points", source=5, dest=2, damage=3, effect=1 },
		{ pattern="Votre (.+) inflige (%d+) points de d\195\169g\195\162ts de (.+) \195\160 (.+)", source=5, dest=4, damage=2, effect=1 },
		{ pattern="Vous renvoyez (%d+) points de d\195\169g\195\162ts de (.+) \195\160 (.+)", source=5, dest=3, damage=1, effect=7 },
		{ pattern="Vous touchez (.+) avec un coup critique et infligez (%d+) points", source=5, dest=1, damage=2, crit=1, effect=6 },
		{ pattern="Vous touchez (.+) et infligez (%d+) points", source=5, dest=1, damage=2, effect=6 },
		{ pattern="(.+) de (.+) touche (.+) pour (%d+) points", source=2, dest=3, damage=4, effect=1 },
		{ pattern="(.+) utilise (.+) et touche (.+) avec un coup critique, infligeant (%d+) points", source=1, dest=3, damage=4, crit=1, effect=2 },
		{ pattern="(.+), gr\195\162ce \195\160 (.+), inflige \195\160 (.+) (%d+) points", source=1, dest=3, damage=4, effect=2 },
		{ pattern="(.+) renvoie (%d+) points de d\195\169g\195\162ts de (.+) sur (.+)", source=1, dest=4, damage=2, effect=7 },
		{ pattern="(.+) de (.+) inflige \195\160 (.+) (%d+) points de d\195\169g\195\162ts de (.+)", source=2, dest=3, damage=4, effect=1 },
		{ pattern="(.+) touche (.+) et inflige (%d+) points", source=1, dest=2, damage=3 },
		{ pattern="(.+) touche (.+) avec un coup critique et inflige (%d+) points", source=1, dest=2, damage=3, crit=1 },
		{ pattern="(.+) de (.+) (vous) inflige (%d+) points", source=2, dest=3, damage=4, effect=1 },
		{ pattern="(.+) lance (.+) et (vous) inflige un coup critique .(%d+) points", source=1, dest=3, damage=4, crit=1, effect=2 },
		{ pattern="(.+), gr\195\162ce \195\160 (.+), (vous) cause (%d+) points", source=1, dest=3, damage=4, effect=2 },
		{ pattern="(.+) réfléchit (%d+) (.+) points de dégâts sur (vous)", source=1, dest=4, damage=2, effect=7 },
		{ pattern="(.+) de (.+) (vous) inflige (%d+) points de d\195\169g\195\162ts de (.+)", source=2, dest=3, damage=4, effect=1 },
		{ pattern="(.+) (vous) touche et inflige (%d+) points", source=1, dest=2, damage=3 },
		{ pattern="(.+) (vous) touche avec un coup critique et inflige (%d+) points", source=1, dest=2, damage=3, crit=1 } };
	recap_temp.FilterSize = 21; -- number of filters, change to recap_temp.Filter size

	recap_temp.HealFilter = {
		{ pattern="Le (.+) de (.+) vous fait gagner (%d+) points de vie", source=2, dest=5, heal=3, effect=1 },
		{ pattern="(.+) vous rend (%d) points de vie", source=5, dest=5, heal=2, effect=1 },
		{ pattern="Votre (.+) rend (%d+) points de vie Ã (.+)", source=5, dest=3, heal=2, effect=1 },
		{ pattern="(.+) de (.+) rend (%d+) points de vie Ã (.+)", source=2, dest=4, heal=3, effect=1 },
		{ pattern="Le (.+) de (.+) soigne avec un effet critique (.+),Â pour (%d+) points de vie", source=2, dest=3, heal=4, effect=1 },
		{ pattern="(.+) vous soigne avec (.+) et vous rend (%d+) points de vie", source=1, dest=5, heal=3, effect=2 },
		{ pattern="Votre (.+) soigne (.+) avec un effet critique et lui rend (%d+) points de vie", source=5, dest=2, heal=3, crit=1, effect=1 },
		{ pattern="Votre (.+) a un effet critique et vous rend (%d+) points de vie", source=5, dest=5, heal=2, crit=1, effect=1 },
		{ pattern="(.+) de (.+) guÃ©rit (.+) de (%d+) points de vie", source=2, dest=3, heal=4, effect=1 },
		{ pattern="Votre (.+) soigne (.+) pour (%d+) points de vie", source=5, dest=2, heal=3, effect=1 },
		{ pattern="Votre (.+) vous soigne pour (%d+) points de vie", source=5, dest=5, heal=2, effect=1 },
		{ pattern="(.+) de (.+) vous soigne pour (%d+) points de vie", source=2, dest=5, heal=3, effect=1 } };
	recap_temp.HealFilterSize = 12;

	recap_temp.DeathFilter = {
		{ pattern="Vous Ãªtes mort", victim=5 },
		{ pattern="(.+) a succombÃ©.", victim=1 },
		{ pattern="(.+) meurt.", victim=1 } };
	recap_temp.DeathFilterSize = 3;

	recap_temp.Keys = {
		"Alliance", "Horde",
		"Guerrier", "Mage", "Voleur", "Druide", "Chasseur",
		"Chaman", "PrÃªtre", "DÃ©moniste", "Paladin", "Familier"
	};

	recap_temp.ClassIcons = {
		["Guerrier"] = { left=0.025, right=0.225, top=0.025, bottom=0.225 },
		["Mage"] = { left=0.275, right=0.475, top=0.025, bottom=0.225 },
		["Voleur"] = { left=0.525, right=0.725, top=0.025, bottom=0.225 },
		["Druide"] = { left=0.775, right=0.975, top=0.025, bottom=0.225 },
		["Chasseur"] = { left=0.025, right=0.225, top=0.275, bottom=0.475 },
		["Chaman"] = { left=0.275, right=0.475, top=0.275, bottom=0.475 },
		["PrÃªtre"] = { left=0.525, right=0.725, top=0.275, bottom=0.475 },
		["DÃ©moniste"] = { left=0.775, right=0.975, top=0.275, bottom=0.475 },
		["Paladin"] = { left=0.025, right=0.225, top=0.525, bottom=0.725 },
		["Familier"] = { left=0.275, right=0.475, top=0.525, bottom=0.725 }
	};

	-- if this pronoun isn't enough, make more filters to cover the rest in the list above
	recap_temp.Local.Pronoun = "vous"; -- recipient of damage
end
