-- Version : English - sarf
-- Translation by : None

BINDING_HEADER_SPELLCHECKERHEADER		= "SpellChecker";
BINDING_NAME_SPELLCHECKER				= "SpellChecker Toggle";

SPELLCHECKER_CONFIG_HEADER				= "SpellChecker";
SPELLCHECKER_CONFIG_HEADER_INFO			= "Contains settings for the SpellChecker,\nan AddOn which...";

SPELLCHECKER_ENABLED					= "Enable SpellChecker";
SPELLCHECKER_ENABLED_INFO				= "Enables SpellChecker, which allow messages that are sent to be auto-corrected.";

SPELLCHECKER_CHAT_ENABLED				= "SpellChecker enabled.";
SPELLCHECKER_CHAT_DISABLED				= "SpellChecker disabled.";

SPELLCHECKER_CHAT_WORD_NOT_SPECIFIED	= "No spellchecking word entered.\n Usage: /spellchecker <add/delete/modify> <word to add/modify/delete> [correct spelling of word]\n  Note that the correct spelling of the word MUST be omitted to delete the word.";
SPELLCHECKER_CHAT_WORD_ADDED			= "Added spellchecking for \"%s\" - will now be corrected to \"%s\".";
SPELLCHECKER_CHAT_WORD_MODIFIED			= "Modified spellchecking for \"%s\" - will now be corrected to \"%s\".";
SPELLCHECKER_CHAT_WORD_DELETED			= "Removed spellchecking for \"%s\".";
SPELLCHECKER_CHAT_WORD_DELETED_NONE		= "\"%s\" was not corrected.";
SPELLCHECKER_CHAT_WORD_SHOW				= "\"%s\" is corrected to \"%s\".";
SPELLCHECKER_CHAT_WORD_SHOW_NONE		= "\"%s\" is not corrected.";
SPELLCHECKER_CHAT_WORD_SHOW_LIST		= "List of spellchecks and their corrections:";
SPELLCHECKER_CHAT_WORD_SHOW_LIST_FORMAT	= "%s => %s";

SPELLCHECKER_CHAT_COMMAND_INFO			= "Controls SpellChecker by the command line - /spellchecker for usage.";

SPELLCHECKER_CHAT_COMMAND_USAGE			= "Usage: /spellchecker [add/delete/modify/show/state] [params...]\nCommands:\n state [on/off/toggle] - determines whether the SpellChecker should be enabled or not.\n add/delete/modify [word] [correct spelling]\nNote that the correct spelling of the word MUST be omitted to delete the word.\n show [word] - shows the correct spelling of the word (if a correction is present), or the list of the corrections if the word is ommitted.";
SPELLCHECKER_CHAT_COMMAND_USAGE_EXAMPLE	= "Example:\nAdding a word to the sarf SpellChecker:\n /spellchecker add smufr smurf\n This will autocorrect any \"smufr\" to \"smurf\".\nRemoving a word from the spellchecker:\n /spellchecker delete smufr\n This will delete the spellchecking of smufr.\nModifying a spellchecking word:\n /spellchecker modify smufr sarf\n This will change the autocorrection of smufr to be corrected to sarf. Right.\n\nNote that for all intents and purposes, /spellchecker add, /spellchecker delete and /spellchecker modify do the EXACT same thing.\nFunky, huh?";

