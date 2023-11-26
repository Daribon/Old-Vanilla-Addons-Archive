--[[
--	BuffOptions Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2538 2005-09-29 00:51:52Z mugendai $
--	$Rev: 2538 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-09-28 19:51:52 -0500 (Wed, 28 Sep 2005) $
--]]

--------------------------------------------------
--
-- UI Strings
--
--------------------------------------------------
BUFFOPTIONS_CONFIG_SECTION = "Buff Options";
BUFFOPTIONS_CONFIG_SECTION_INFO = "Options to change the behavior of the Buffs";
BUFFOPTIONS_CONFIG_MAIN_HEADER = "Buff Options";
BUFFOPTIONS_CONFIG_MAIN_HEADER_INFO = "Options in general for Buff Options";
BUFFOPTIONS_CONFIG_REVERSE = "Reverse Order";
BUFFOPTIONS_CONFIG_REVERSE_INFO = "Enable to reverse the order the buffs are displayed in";
BUFFOPTIONS_CONFIG_SWAP = "Swap Buffs/Debuffs";
BUFFOPTIONS_CONFIG_SWAP_INFO = "Enable to swap the positions of the buffs and debuffs";
BUFFOPTIONS_CONFIG_BORDER = "Show Border";
BUFFOPTIONS_CONFIG_BORDER_INFO = "Enable to display a background and border around each buff";
BUFFOPTIONS_CONFIG_SIZE = "Buff Size";
BUFFOPTIONS_CONFIG_SIZE_INFO = "Allows you to change the size of the buffs";
BUFFOPTIONS_CONFIG_SIZE_TEXT = "Size Percentage";
BUFFOPTIONS_CONFIG_SIZE_SUFFIX = "%";
BUFFOPTIONS_CONFIG_VERTICAL_HEADER = "Vertical Buffs Options";
BUFFOPTIONS_CONFIG_VERTICAL_HEADER_INFO = "Options that apply only to vertical buff mode";
BUFFOPTIONS_CONFIG_VERTICAL = "Vertical Buffs";
BUFFOPTIONS_CONFIG_VERTICAL_INFO = "If enabled, buffs will stack up and down, instead of right and left";
BUFFOPTIONS_CONFIG_SIDETIME = "Time on Side";
BUFFOPTIONS_CONFIG_SIDETIME_INFO = "If enabled, the buff duration will be placed on the side of the buff, instead of under it";
BUFFOPTIONS_CONFIG_TEXT = "Buff Text";
BUFFOPTIONS_CONFIG_TEXT_INFO = "If enabled, the name of the buff will be displayed on the side of the buff";
BUFFOPTIONS_CONFIG_DEBUFFTYPE = "Use Debuff Type";
BUFFOPTIONS_CONFIG_DEBUFFTYPE_INFO = "If enabled, instead of showing the name of debuffs, the type will be shown";
BUFFOPTIONS_CONFIG_NORIGHT = "Don't move to right";
BUFFOPTIONS_CONFIG_NORIGHT_INFO = "If enabled, will not move the buffs to the right of the screen when in vertical mode";
BUFFOPTIONS_CONFIG_TEXT_HEADER = "Buff Text Display";
BUFFOPTIONS_CONFIG_TEXT_HEADER_INFO = "Display options for the buff text";
BUFFOPTIONS_CONFIG_LONGTIME = "Long Time Format";
BUFFOPTIONS_CONFIG_LONGTIME_INFO = "If enabled, the time will display in long format, ex. '29 Minutes 14 Seconds'";
BUFFOPTIONS_CONFIG_SHORTTIME = "Short Time Format";
BUFFOPTIONS_CONFIG_SHORTTIME_INFO = "If enabled, the time will display in short format, ex. '29:14'";
BUFFOPTIONS_CONFIG_FADETIME = "Fade Time";
BUFFOPTIONS_CONFIG_FADETIME_INFO = "If enabled, the buff time will fade in and out with the buff when it is soon to expire";
BUFFOPTIONS_CONFIG_TEXTCOLOR = "Text Color";
BUFFOPTIONS_CONFIG_TEXTCOLOR_INFO = "Sets the color of the buff text and duration";
BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR = "Expire Text Color";
BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR_INFO = "Sets the color of the buff text and duration, when the buff is about to expire";
BUFFOPTIONS_CONFIG_TEXTSIZE = "Text Size";
BUFFOPTIONS_CONFIG_TEXTSIZE_INFO = "Sets the size of the buff text and duration";
BUFFOPTIONS_CONFIG_TEXTSIZE_TEXT = "Size Percentage";
BUFFOPTIONS_CONFIG_TEXTSIZE_SUFFIX = "%";
BUFFOPTIONS_CONFIG_REMINDER_HEADER = "Reminder Options";
BUFFOPTIONS_CONFIG_REMINDER_HEADER_INFO = "Options for configuring alerts when buffs are soon to expire";
BUFFOPTIONS_CONFIG_REMINDER = "Buff Reminders";
BUFFOPTIONS_CONFIG_REMINDER_INFO = "If enabled, you will get an alert when a buff is about to expire";
BUFFOPTIONS_CONFIG_REMINDER_TEXT = "Warning Time";
BUFFOPTIONS_CONFIG_REMINDER_SUFFIX = " second(s)";
BUFFOPTIONS_CONFIG_REMINDERSOUND = "Reminder Sound";
BUFFOPTIONS_CONFIG_REMINDERSOUND_INFO = "If enabled, will play a sound when the buff reminder occurs";
BUFFOPTIONS_CONFIG_REMINDERCOLOR = "Reminder Color";
BUFFOPTIONS_CONFIG_REMINDERCOLOR_INFO = "Sets the color of the buff reminder text";
BUFFOPTIONS_CONFIG_REMINDEROSD = "OSD Reminder";
BUFFOPTIONS_CONFIG_REMINDEROSD_INFO = "If enabled, the reminder text will be displayed on screen, instead of in the chat area";
BUFFOPTIONS_CONFIG_EQUIPMENTONLY = "Equipment Only";
BUFFOPTIONS_CONFIG_EQUIPMENTONLY_INFO = "If enabled, then only equipment buffs will get reminders";
BUFFOPTIONS_CONFIG_NOSHORT = "No Short Buffs";
BUFFOPTIONS_CONFIG_NOSHORT_INFO = "If enabled, only buffs that are longer than the specified time will get reminders";
BUFFOPTIONS_CONFIG_NOSHORT_TEXT = "Minimum Time";
BUFFOPTIONS_CONFIG_NOSHORT_SUFFIX = " second(s)";

--------------------------------------------------
--
-- Weapon Buff Strings
--
--------------------------------------------------
--The search string for finding the line with the number of charges in a tooltip
BUFFOPTIONS_CHARGE_STRINGS = {
	"%d+ Charges",
	"%d+ Charge"
};
--The search string for finding the line with the enchant name in a tooltip
BUFFOPTIONS_ENCHANT_STRINGS = {
	".+ %(%d+ "..string.lower(DAYS_ABBR).."%)",
	".+ %(%d+ "..string.lower(DAYS_ABBR_P1).."%)",
	".+ %(%d+ "..string.lower(HOURS_ABBR_P1).."%)",
	".+ %(%d+ "..string.lower(DAYS_ABBR_P1).."%)",
	".+ %(%d+ "..string.lower(MINUTES_ABBR).."%)",
	".+ %(%d+ "..string.lower(SECONDS_ABBR).."%)",
};
--The string to parse out the number of charges from a tooltip
BUFFOPTIONS_CHARGE = "%((%d+) Charge";
--The string to parse out the name of the enchant from a tooltip
BUFFOPTIONS_ENCHANT = "(.+) %(";
--Strings for displaying the name and number of charges on a weapon
BUFFOPTIONS_WEAPONBUFF = "%s";
BUFFOPTIONS_WEAPONBUFF_CHARGE = "%s (%s)";
--If this is defined it will be used instead of BUFFOPTIONS_WEAPONBUFF_CHARGE,
--and the charge will be the first variable and buff name the second
--BUFFOPTIONS_CHARGE_WEAPONBUFF = "(%s) %s";

--------------------------------------------------
--
-- Other Strings
--
--------------------------------------------------
BUFFOPTIONS_EXPIRESOON = "%s will expire soon";
BUFFOPTIONS_EXPIRESOON_ENCHANT = "The buff on your %s will expire soon"

--------------------------------------------------
--
-- Help Text
--
--------------------------------------------------
BUFFOPTIONS_CONFIG_INFOTEXT = {
	"[NOTE: If you are using Khaos, you may not be "..
	"seeing all of the options available.  For more "..
	"advanced options, increase the difficulty setting.]\n"..
	"\n"..
	"  BuffOptions is an addon that allows you to "..
	"customize the display and behavior of your buffs.\n\n"..
	"It allows you to stack your buffs vertically,  "..
	"reverse them, swap their position with the debuffs, "..
	"show reminders when a buff is about to expire, and more.\n\n"..
	"Options Explaination:\n"..
	BUFFOPTIONS_CONFIG_REVERSE.." - "..BUFFOPTIONS_CONFIG_REVERSE_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_SWAP.." - "..BUFFOPTIONS_CONFIG_SWAP_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_BORDER.." - "..BUFFOPTIONS_CONFIG_BORDER_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_SIZE.." - "..BUFFOPTIONS_CONFIG_SIZE_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_SIDETIME.." - "..BUFFOPTIONS_CONFIG_SIDETIME_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_TEXT.." - "..BUFFOPTIONS_CONFIG_TEXT_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_DEBUFFTYPE.." - "..BUFFOPTIONS_CONFIG_DEBUFFTYPE_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_NORIGHT.." - "..BUFFOPTIONS_CONFIG_NORIGHT_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_LONGTIME.." - "..BUFFOPTIONS_CONFIG_LONGTIME_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_SHORTTIME.." - "..BUFFOPTIONS_CONFIG_SHORTTIME_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_FADETIME.." - "..BUFFOPTIONS_CONFIG_FADETIME_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_TEXTCOLOR.." - "..BUFFOPTIONS_CONFIG_TEXTCOLOR_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_TEXTSIZE.." - "..BUFFOPTIONS_CONFIG_TEXTSIZE_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_REMINDER.." - "..BUFFOPTIONS_CONFIG_REMINDER_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_REMINDERCOLOR.." - "..BUFFOPTIONS_CONFIG_REMINDERCOLOR_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_REMINDEROSD.." - "..BUFFOPTIONS_CONFIG_REMINDEROSD_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_EQUIPMENTONLY.." - "..BUFFOPTIONS_CONFIG_EQUIPMENTONLY_INFO.."\n\n"..
	BUFFOPTIONS_CONFIG_NOSHORT.." - "..BUFFOPTIONS_CONFIG_NOSHORT_INFO.."\n\n"..
	"\n"..
	"See page 3 for a list of slash commands.",
	
	"Buff Options\n"..
	"\n"..
	"By: Mugendai\n"..
	"Special Thanks:\n"..
	"    GotMoo - For MooBuffMod, the inspiration for most buff mods\n\n"..
	"    Zespri - For many ideas, and testing, and more\n\n"..
	"Contact: mugekun@gmail.com"
};