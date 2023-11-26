-- Version : English
-- Last Update : 02/17/2005

-- Commands
MAPNOTES_ENABLE_COMMANDS = { "/mapnote" };
MAPNOTES_ONENOTE_COMMANDS = { "/onenote", "/allowonenote", "/aon" };
MAPNOTES_MININOTE_COMMANDS = { "/nextmininote", "/nmn" };
MAPNOTES_MININOTEONLY_COMMANDS = { "/nextmininoteonly", "/nmno" };
MAPNOTES_MININOTEOFF_COMMANDS = { "/mininoteoff", "/mno" };
MAPNOTES_MNTLOC_COMMANDS = { "/mntloc" };
MAPNOTES_QUICKNOTE_COMMANDS = { "/quicknote", "/qnote" };
MAPNOTES_QUICKTLOC_COMMANDS = { "/quicktloc", "/qtloc" };

-- Interface Configuration
MAPNOTES_WORLDMAPHELP = "Double Click The Map To Open Map Notes Menu";
MAPNOTES_CLICK_ON_SECOND_NOTE = "|cFFFF0000Map Notes:|r Choose Second Note To Draw/Clear A Line";

MAPNOTES_NEW_MENU = "Map Notes";
MAPNOTES_NEW_NOTE = "Create Note";
MAPNOTES_MININOTE_OFF = "Turn MiniNote Off";
MAPNOTES_OPTIONS = "Options";
MAPNOTES_CANCEL = "Cancel";

MAPNOTES_POI_MENU = "Map Notes";
MAPNOTES_EDIT_NOTE = "Edit Note";
MAPNOTES_MININOTE_ON = "Set As MiniNote";
MAPNOTES_SPECIAL_ACTIONS = "Special Actions";
MAPNOTES_SEND_NOTE = "Send Note";

MAPNOTES_SPECIALACTION_MENU = "Special Actions";
MAPNOTES_TOGGLELINE = "Toggle Line";
MAPNOTES_DELETE_NOTE = "Delete Note";

MAPNOTES_EDIT_MENU = "Edit Note";
MAPNOTES_SAVE_NOTE = "Save";
MAPNOTES_EDIT_TITLE = "Title (mandatory):";
MAPNOTES_EDIT_INFO1 = "Infoline 1 (optional):";
MAPNOTES_EDIT_INFO2 = "Infoline 2 (optional):";

MAPNOTES_SEND_MENU = "Send Note";
MAPNOTES_SLASHCOMMAND = "Change Mode";
MAPNOTES_SEND_COSMOSTITLE = "Send Note:";
MAPNOTES_SEND_COSMOSTIP = "These notes can be received by all Map Notes users\n('Send to party' works only with Sky)";
MAPNOTES_SEND_PLAYER = "Enter player name:";
MAPNOTES_SENDTOPLAYER = "Send to player";
MAPNOTES_SENDTOPARTY = "Send to party";
MAPNOTES_SHOWSEND = "Change Mode";
MAPNOTES_SEND_SLASHTITLE = "Get slash Command:";
MAPNOTES_SEND_SLASHTIP = "Highlight this and use CTRL+C to copy to clipboard\n(then you can post it in a forum for example)";
MAPNOTES_SEND_SLASHCOMMAND = "/Command:";

MAPNOTES_OPTIONS_MENU = "Options";
MAPNOTES_SAVE_OPTIONS = "Save";
MAPNOTES_OWNNOTES = "Show notes created by your character";
MAPNOTES_OTHERNOTES = "Show notes received from other characters";
MAPNOTES_HIGHLIGHT_LASTCREATED = "Highlight last created note in |cFFFF0000red|r";
MAPNOTES_HIGHLIGHT_MININOTE = "Highlight note selected for MiniNote in |cFF6666FFblue|r";
MAPNOTES_ACCEPTINCOMING = "Accept incoming notes from other players";
MAPNOTES_INCOMING_CAP = "Decline notes if they would leave less than 5 notes free";
MAPNOTES_AUTOPARTYASMININOTE = "Automatically set party notes as MiniNote."

MAPNOTES_CREATEDBY = "Created by";
MAPNOTES_CHAT_COMMAND_ENABLE_INFO = "This command enables you to instert notes gotten by a webpage for example.";
MAPNOTES_CHAT_COMMAND_ONENOTE_INFO = "Overrides the options setting, so that the next note you receive is accepted.";
MAPNOTES_CHAT_COMMAND_MININOTE_INFO = "Displays the next received note directly as MiniNote (and insterts it into the map):";
MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO = "Displays the next note received as MiniNote only (not inserted into map).";
MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO = "Turns the MiniNote off.";
MAPNOTES_CHAT_COMMAND_MNTLOC_INFO = "Sets a tloc on the map.";
MAPNOTES_CHAT_COMMAND_QUICKNOTE = "Creates a note at the current position on the map.";
MAPNOTES_CHAT_COMMAND_QUICKTLOC = "Creates a note at the given tloc position on the map in the current zone.";
MAPNOTES_MAPNOTEHELP = "This command can only be used to insert a note";
MAPNOTES_ONENOTE_OFF = "Allow one note: OFF";
MAPNOTES_ONENOTE_ON = "Allow one note: ON";
MAPNOTES_MININOTE_SHOW_0 = "Next as MiniNote: OFF";
MAPNOTES_MININOTE_SHOW_1 = "Next as MiniNote: ON";
MAPNOTES_MININOTE_SHOW_2 = "Next as MiniNote: ONLY";
MAPNOTES_DECLINE_SLASH = "Could not add, too many notes in |cFFFFD100%s|r.";
MAPNOTES_DECLINE_SLASH_NEAR = "Could not add, this note is too near to |cFFFFD100%q|r in |cFFFFD100%s|r.";
MAPNOTES_DECLINE_GET = "Could not receive note from |cFFFFD100%s|r: too many notes in |cFFFFD100%s|r, or reception disabled in the options.";
MAPNOTES_ACCEPT_SLASH = "Note added to the map of |cFFFFD100%s|r.";
MAPNOTES_ACCEPT_GET = "You received a note from |cFFFFD100%s|r in |cFFFFD100%s|r.";
MAPNOTES_PARTY_GET = "|cFFFFD100%s|r set a new party note in |cFFFFD100%s|r.";
MAPNOTES_DECLINE_NOTETONEAR = "|cFFFFD100%s|r tried to send you a note in |cFFFFD100%s|r, but it was too near to |cFFFFD100%q|r.";
MAPNOTES_QUICKNOTE_NOTETONEAR = "Can't create note. You are too near to |cFFFFD100%s|r.";
MAPNOTES_QUICKNOTE_NOPOSITION = "Can't create note: could not retrieve current position.";
MAPNOTES_QUICKNOTE_DEFAULTNAME = "Quicknote";
MAPNOTES_QUICKNOTE_OK = "Created note on the map of |cFFFFD100%s|r.";
MAPNOTES_QUICKNOTE_TOOMANY = "There are already too many notes on the map of |cFFFFD100%s|r.";
MAPNOTES_QUICKTLOC_NOTETONEAR = "Can't create note. The location is too near to the note |cFFFFD100%s|r.";
MAPNOTES_QUICKTLOC_NOZONE = "Can't create note: could not retrieve current zone.";
MAPNOTES_QUICKTLOC_NOARGUMENT = "Usage: '/quicktloc xx,yy [icon] [title]'.";
MAPNOTES_SETMININOTE = "Set note as new MiniNote";
MAPNOTES_THOTTBOTLOC = "Thottbot Location";
MAPNOTES_PARTYNOTE = "Party Note";

MAPNOTES_ADDONDESCRIPTION = "Adds a note system to the Worldmap.";

-- Drop Down Menu
MAPNOTES_SHOWNOTES = "Show Notes";
MAPNOTES_DROPDOWNTITLE = "Map Notes";
MAPNOTES_DROPDOWNMENUTEXT = "Quick Options";


MapNotes_ZoneShift = {
	[0] = { [0] = 0 },
	[1] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 },
	[2] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 },
};

MapNotes_ZoneShift[1][0] = 0;
MapNotes_ZoneShift[2][0] = 0;


MAPNOTES_WARSONGGULCH = "Warsong Gulch";
MAPNOTES_ALTERACVALLEY = "Alterac Valley";
MAPNOTES_ARATHIBASIN = "Arathi Basin";
