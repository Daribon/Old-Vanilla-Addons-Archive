-- Version : English
-- Last Update : 03/3/2005

-- Slash commands:

SLASH_COS_SSM1				= "/COS_SSM";
SLASH_COS_SSM2				= "/ssm";

COS_SSM_SLASH_MESSAGE		= "message";
COS_SSM_SLASH_PAGE			= "page";

-- Binding Configuration

BINDING_HEADER_COS_SSM							= "Social Modifications";

BINDING_NAME_COS_SSM_SEND_MESSAGE_ENABLE_TOGGLE	= "Toggle 'Send Message' button";
BINDING_NAME_COS_SSM_SEND_PAGE_ENABLE_TOGGLE	= "Toggle 'Send Page' button";
BINDING_NAME_COS_SN_ENABLE_TOGGLE				= "Toggle player notes";
BINDING_NAME_COS_SN_EDITOR_OPEN					= "Open player notes editor";
BINDING_NAME_COS_SSM_EDIT_NOTE_ENABLE_TOGGLE	= "Toggle 'Edit note' button";

BINDING_NAME_COS_SN_PARTY_NOTES_ENABLE_TOGGLE	= "Toggle Party note buttons";
BINDING_NAME_COS_SN_TARGET_NOTE_ENABLE_TOGGLE	= "Toggle Target note button";

-- Cosmos Configuration
COS_SSM_SEP_TEXT					= "Social Modifications";
COS_SSM_SEP_INFO					= "This section is for configuring Social Modifications!";

COS_SSM_SEND_MESSAGE_ENABLE_TEXT	= "Enable 'Send Message' Button";
COS_SSM_SEND_MESSAGE_ENABLE_INFO	= "Check this to enable the 'Send Message' button";
COS_SSM_SEND_MESSAGE_TOGGLE_TEXT	= "Toggle 'Send Message' Button";

COS_SSM_SEND_PAGE_ENABLE_TEXT		= "Enable 'Send Page' Button";
COS_SSM_SEND_PAGE_ENABLE_INFO		= "Check this to enable the 'Send Page' button";
COS_SSM_SEND_PAGE_TOGGLE_TEXT		= "Toggle 'Send Page' Button";

COS_SSM_SEND_PAGE					= "Send Page";
COS_SSM_SENDPAGE_NEWBIE_TOOLTIP		= "Sends a private page to the selected player.";

COS_SN_ENABLE_TEXT					= "Enable social notes";
COS_SN_ENABLE_INFO					= "Check this to enable social notes";

COS_SSM_EDIT_NOTE_ENABLE_TEXT		= "Enable 'Edit note' Button";
COS_SSM_EDIT_NOTE_ENABLE_INFO		= "Check this to enable the 'Edit note' button";

-- Slash commands:

SLASH_COS_SSN1				= "/COS_SSN";
SLASH_COS_SSN2				= "/ssn";

-- /ssn [on|off|enable|disable|toggle|help]
-- /ssn button [on|off|enable|disable|toggle]
-- /ssn self note [on|off|enable|disable|toggle]
-- /ssn self note party [on|off|enable|disable|toggle]
-- /ssn self note complete [on|off|enable|disable|toggle]
-- /ssn self note finish [on|off|enable|disable|toggle]
-- /ssn self note ding [on|off|enable|disable|toggle]
-- /ssn party notes [on|off|enable|disable|toggle]
-- /ssn party notes [party|complete|finish]
-- /ssn target note [on|off|enable|disable|toggle]
-- /ssn guild ding [on|off|enable|disable|toggle]

COS_SSN_SLASH_SELF			= "self";
COS_SSN_SLASH_PARTY			= "party";
COS_SSN_SLASH_TARGET		= "target";
COS_SSN_SLASH_GUILD			= "guild";
COS_SSN_SLASH_BUTTON		= "button";
COS_SSN_SLASH_NOTE			= "note";
COS_SSN_SLASH_NOTES			= "notes";
COS_SSN_SLASH_PARTY			= "party";
COS_SSN_SLASH_COMPLETE		= "complete";
COS_SSN_SLASH_FINISH		= "finish";
COS_SSN_SLASH_DING			= "ding";

COS_SSN_SLASH_ON			= "on";
COS_SSN_SLASH_OFF			= "off";
COS_SSN_SLASH_ENABLE		= "enable";
COS_SSN_SLASH_DISABLE		= "disable";
COS_SSN_SLASH_TOGGLE		= "toggle";

COS_SSN_ENABLED_TEXT		= "enabled";
COS_SSN_DISABLED_TEXT		= "disabled";

-- Interface Configuration

COS_SN_SEP_TEXT						= "Social Notes";
COS_SN_SEP_INFO						= "This section is for configuring Social Notes!";

COS_SN_EDIT_NOTE_ENABLE_TEXT		= "Enable 'Edit Note' button";
COS_SN_EDIT_NOTE_ENABLE_INFO		= "Check this to enable the 'Edit Note' button";

COS_SN_EDIT_NOTE					= "Edit note";

COS_SN_NOTES						= "Edit player Notes";
COS_SN_NOTES_NEWBIE_TOOLTIP			= "Edit your notes about this player";

COS_SN_SELF_NOTE_TEXT				= "Show note button on self.";
COS_SN_SELF_NOTE_INFO				= "Check this to show the note button and tooltip for your self.";
COS_SN_SELF_NOTE_STAT				= "Notes on self are ";	-- "enabled." / "disabled."

COS_SN_PARTY_NOTES_TEXT				= "Show note button on party members";
COS_SN_PARTY_NOTES_INFO				= "Check this to show the note button and tooltip for your party members.";
COS_SN_PARTY_NOTES_STAT				= "Notes on party members are ";	-- "enabled." / "disabled."

COS_SN_TARGET_NOTE_TEXT				= "Show note button on target";
COS_SN_TARGET_NOTE_INFO				= "Check this to enable the note button and tooltip for the current target.";
COS_SN_TARGET_NOTE_STAT				= "Notes on target are ";	-- "enabled." / "disabled."

COS_SN_PARTY_CHANGES_TO_SELF_NOTE_TEXT			= "Append party changes to your player's note";
COS_SN_PARTY_CHANGES_TO_SELF_NOTE_INFO			= "Check this to enable appending party changes to your player's note.";
COS_SN_PARTY_CHANGES_TO_SELF_NOTE_STAT			= "Appending party changes to your player's note is now ";

COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_TEXT		= "Append party changes to party notes";
COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_INFO		= "Check this to enable appending party changes to party members notes.";
COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_STAT		= "Appending party changes to party members notes is now ";

COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_TEXT		= "Append quest completions to player's note";
COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_INFO		= "Check this to enable appending to your player's note when you've complete a quests objectives.";
COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_STAT		= "Appending quest completions to player's note is now ";

COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_TEXT	= "Append quest completions to party notes";
COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_INFO	= "Check this to enable appending to all party members notes when note when you've complete a quests objectives";
COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_STAT	= "Appending party changes to your partys notes is now ";

COS_SN_QUEST_FINISHES_TO_SELF_NOTE_TEXT			= "Append quest finishes to player's note";
COS_SN_QUEST_FINISHES_TO_SELF_NOTE_INFO			= "Check this to enable appending to your player's note when a quest is finished (turned in)";
COS_SN_QUEST_FINISHES_TO_SELF_NOTE_STAT			= "Appending quest finishes to player's note is now ";

COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_TEXT		= "Append quest finishes to party notes";
COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_INFO		= "Check this to enable appending to all party members notes when a quest is finished (turned in)";
COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_STAT		= "Appending quest finishes to party notes is now ";

COS_SN_LEVEL_UP_TO_SELF_NOTE_TEXT				= "Append level up's to player's note";
COS_SN_LEVEL_UP_TO_SELF_NOTE_INFO				= "Check this to enable appending level up's to your player's note";
COS_SN_LEVEL_UP_TO_SELF_NOTE_STAT				= "Appending level up's to player's note is now ";

COS_SN_LEVEL_UP_TO_GUILD_CHAT_TEXT				= "Send level up message to guild chat channel.";
COS_SN_LEVEL_UP_TO_GUILD_CHAT_INFO				= "Check this to enable sending level up's messages to your player's guild chat channel.";
COS_SN_LEVEL_UP_TO_GUILD_CHAT_STAT				= "Sending level up message to guild chat channel is now ";

-- Social Note Editor strings

COS_SNE_CLEAR_NOTE					= "Clear Note";
COS_SNE_DELETE_NOTE					= "Delete Note";
COS_SNE_ADD_TIMESTAMP				= "Add Time Stamp";
COS_SNE_ADD_PARTY					= "Add Party";
COS_SNE_ADD_LOCATION				= "Add Location";

COS_SNE_SELF_JOINED_NOTE			= "joined party on: ";
COS_SNE_JOINED_NOTE					= "Joined party on: ";
COS_SNE_SELF_COMPLETED_NOTE			= "Completed '%s' on: ";
COS_SNE_COMPLETED_NOTE				= "Completed '%s' with me on: ";
COS_SNE_SELF_FINISHED_NOTE			= "Finished '%s' on: ";
COS_SNE_FINISHED_NOTE				= "Finished '%s' with me on: ";

COS_SNE_DINGED_TEXT					= "Dinged level %d";
COS_SNE_DINGED_AT_TEXT				= " at %d days %02d:%02d:%02d played.";
COS_SNE_DINGED_IN_TEXT				= " in %d days %02d:%02d:%02d.";
COS_SNE_DINGED_ON_DATE_TEXT			= " on %s.";
COS_SNE_DINGED_ON_DATETIME_TEXT		= " on %s at %s.";

SN_ADD_SOCIAL_NOTE					=	"Add Social Note"
SN_INVITE_TO_GUILD					=	"Invite to guild";
