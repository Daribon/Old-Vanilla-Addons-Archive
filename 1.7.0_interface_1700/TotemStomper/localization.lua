-- Version : English (by AlexYoshi, Sarf, Mugendai, Vjeux ...)
-- Last Update : 02/17/2005

-- <= == == == == == == == == == == == == =>
-- => Bindings Names
-- <= == == == == == == == == == == == == =>
BINDING_HEADER_TOTEMSTOMPER		= "Totem Stomper";

BINDING_NAME_TOTEMSET1			= "Drop totem set A";
BINDING_NAME_TOTEMSET2			= "Drop totem set B";
BINDING_NAME_TOTEMSET3			= "Drop totem set C";
BINDING_NAME_TOTEMSET4			= "Drop totem set D";
BINDING_NAME_TOTEMSET5			= "Drop totem set E";

BINDING_NAME_TOTEMSHOW			= "Toggle Totem Stomper";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Settings
-- <= == == == == == == == == == == == == =>
COS_TS_SEPARATOR_TEXT			= "Totem Stomper";
COS_TS_SEPARATOR_INFO			= "Totem Stomper allows a shaman to group different totems together to be cast by a single hotkey.";
COS_TS_ENABLE_TEXT			= "Enable Totem Stomper Keys";
COS_TS_ENABLE_INFO			= "Checking here will enable the Stomper keys.";
COS_TS_DELAY_TEXT			= "Modify Stomp Delay";
COS_TS_DELAY_INFO			= "This allows you to tweak the time delay between allowed stomps.\n The default (unchecked) setting will attempt to calculate by cooldown.";

-- <= == == == == == == == == == == == == =>
-- => International Language Code
-- <= == == == == == == == == == == == == =>
TOTEMSTOMPER_HELP			= " Use /stomp A-E or 1-5 (e.g. /stomp 2) to cast that Totem set. |cFFAA3333[Macro Only]|r";
TOTEMSTOMPER_INSTRUCTION		= "Drag Totem spells from your\n spellbook into the boxes.\n Then press the set's keybind (each keystroke cycles through the configured totems) )";
TOTEMSTOMPER_PARTY_INSTRUCTION		= "Displays party Totem usage. \n Boxes remain empty until \na totem set is used.";
TOTEMSTOMPER_FULL_INSTRUCTIONS		= "Instructions: \n Open the TotemStomper frame from the Cosmos menu, open your spellbook, then drag and drop or shift-click and drop the Totems you wish you use into the appropriate Set/Column. After drag/drop is complete, open the Keybindings (Cosmos) and scroll to the Totem Stomper section. Set a hotkey for Totem Sets A-E and then simply tap the totem set hotkey serveral times to drop the totems. It will cast the totems in the order they appear. (Open Totem Stomper and watch while you press the hotkeys if you don't understand how it is working)\nIt will default to waiting for the spell to cooldown before casting. If you want to skip spells you cannot cast yet, turn the 'wait' checkbox off. (not in the screenshot)\nYou can write the Totem Stomper action into a macro (for use with a normal action bar) with the /stomp command. Type /stomp A in a macro to try it out (this macro will activate the Stomp A series). "
TOTEMSTOMPER_TOTEMSHARE_INSTRUCTIONS	= "Totem Share:\nTotem Share will now share the contents of your active TotemSet with all of your party members. It will then do cross-party Totem comparisons, then color the player with the Best totem of a particular type in green, players who are using the same totem & rank in red and players who are using inferior totems in grey.\nThis will only work if you're casting your Totems from Totem Stomper via the /stomp A macro command or the Totem Stomper hotkeys. ";
TOTEMSTOMPER_VERSION_TIP		= "Made by AlexYoshi";
TOTEMSTOMPER_VERSION			= "1.0";

TOTEMSTOMPER_WAIT_TIP			= "Check here to wait for a spell \nto cooldown before cycling";
TOTEMSTOMPER_SKIP_TIP			= "Check here to skip a spell \nand continue cycling";

VERSIONLABEL				= "Version";
RESET					= "Reset";

TOTEMSTOMPER_BUTTON_TITLE		= "Totem Stomper";
TOTEMSTOMPER_BUTTON_SUBTITLE		= "Totem-Sets";
TOTEMSTOMPER_BUTTON_TIP			= "Totem Stomper allows a shaman to group different\n totems together to be cast by a single hotkey.";
