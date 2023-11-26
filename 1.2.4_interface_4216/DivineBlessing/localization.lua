-- Version : English (by CheshireKatt)
-- Last Update : 02/17/2005

-- <= == == == == == == == == == == == == =>
-- => Bindings Names
-- <= == == == == == == == == == == == == =>
BINDING_HEADER_DIVINEBLESSING	= "Divine Blessing";

BINDING_NAME_BLESSINGSET1	= "Use Blessing Set A";
BINDING_NAME_BLESSINGSET2	= "Use Blessing Set B";
BINDING_NAME_BLESSINGSET3	= "Use Blessing Set C";
BINDING_NAME_BLESSINGSET4	= "Use Blessing Set D";
BINDING_NAME_BLESSINGSET5	= "Use Blessing Set E";

BINDING_NAME_BLESSINGSHOW	= "Toggle Divine Blessing";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Settings
-- <= == == == == == == == == == == == == =>
DIVINEBLESSING_BUTTON_TITLE	= "Divine Blessing";
DIVINEBLESSING_BUTTON_SUBTITLE  = "Blessing Sets";
DIVINEBLESSING_BUTTON_TIP	= "This allows you to organize blessings into one button sets.";

COS_DB_SEPARATOR_TEXT		= "Divine Blessing";
COS_DB_SEPARATOR_INFO		= "Divine Blessing allows a Paladin to assign different blessing sets to simplify party-wide buffing.";
COS_DB_ENABLE_TEXT		= "Enable Divine Blessing Keys";
COS_DB_ENABLE_INFO		= "Checking here will allow the Blessing keys to work.";
COS_DB_DELAY_TEXT		= "Modify Blessing Delay";
COS_DB_DELAY_INFO		= "This allows you to tweak the time delay between allowed blessings. The default unchecked setting will attempt to calculate by cooldown.";
COS_DB_IGNOREABSENT_TEXT	= "Ignore Empty Party Slots";
COS_DB_IGNOREABSENT_INFO	= "If checked, blessings assigned to party slots with no present party member will be skipped.";
COS_DB_SHOWANNOUNCE_TEXT	= "Status Messages Enabled";
COS_DB_SHOWANNOUNCE_INFO	= "If checked, a status messages about Divine Blessing operation will be displayed.";
COS_DB_BANNERANNOUNCE_TEXT	= "Announce Set Completion in Center Screen";
COS_DB_BANNERANNOUNCE_INFO	= "If unchecked, Blessing Set completion will be displayed in the main chat window instead of center screen.";
COS_DB_OVERRIDETARGET_TEXT	= "Override Friendly Target";
COS_DB_OVERRIDETARGET_INFO	= "If checked, using a Blessing Set with a valid friendly target will cast the first blessing in the set on that target, regardless of order.";

-- <= == == == == == == == == == == == == =>
-- => International Language Code
-- <= == == == == == == == == == == == == =>
DIVINEBLESSING_HELP		= " Use /bless A-E or 1-5 (e.g. /bless 2) to cast that Blessing set. |cFFAA3333[Macro Only]|r";
DIVINEBLESSING_INSTRUCTION	= "Drag Blessing spells from your\n spellbook into the boxes.\n Then press the set's keybind (x5)";
DIVINEBLESSING_PARTY_INSTRUCTION= "Displays party Blessing usage. \n Boxes remain empty until \na blessing set is used.";
DIVINEBLESSING_FULL_INSTRUCTIONS= "Instructions: \n Open the DivineBlessing frame from the Cosmos menu, open your spellbook, then drag and drop or shift-click and drop the Blessings you wish you use into the appropriate Set/Column. Then open the Keybindings and scroll to the bottom. Set a hotkey for Blessing Sets A-E and then simply tap the blessing set hotkey serveral times to sequentially bless your party. It will cast the blessings in the order they appear, starting on the caster and proceeding to the second, third, fourth, and fifth party members, if applicable. (Open Divine Blessings and watch while you press the hotkeys if you don't understand how it is working)\nIt will default to waiting for the spell to cooldown before casting.  If you want to skip spells you cannot cast yet, turn the 'wait' checkbox off. (not in the screenshot)\nYou can write the Divine Blessing action into a macro (for use with a normal action bar) with the /bless command. Type /bless A in a macro to try it out. "
DIVINEBLESSING_BLESSINGSHARE_INSTRUCTIONS = "Blessing Share:\nBlessing Share will now share the contents of your active Blessing Set with all of your party members.  It will then do cross-party Blessing comparisons, then color the player with the best blessing of a particular type in green, players who are using the same blessing & rank in red and players who are using inferior blessings in grey.\nThis will only work if you're casting your Blessings from Divine Blessing via the /bless A macro command or the Divine Blessing hotkeys. ";
DIVINEBLESSING_VERSION_TIP	= "Made by CheshireKatt";
DIVINEBLESSING_VERSION		= "1.5";

DIVINEBLESSING_WAIT_TIP		= "Check here to wait for a spell \nto cooldown before cycling";
DIVINEBLESSING_SKIP_TIP		= "Check here to skip a spell \nand continue cycling";

VERSIONLABEL			= "Version";
RESET				= "Reset";

DIVINEBLESSING_CLASS_PALADIN	= "Paladin";
DIVINEBLESSING_BLESSING_OF_MIGHT_SPELL_NAME	= "Blessing of Might";
