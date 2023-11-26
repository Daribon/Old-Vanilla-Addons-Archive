-- version strings
PCB_ADDON_NAME  = "PerCharBinding";
PCB_ADDON_VER   = "1.1.3";
PCB_ADDON_TITLE = PCB_ADDON_NAME.." "..PCB_ADDON_VER;

-- commands
PCB_CMD_SAVE     = "save";
PCB_CMD_LOAD     = "load";
PCB_CMD_DELETE   = "delete";
PCB_CMD_LIST     = "list";
PCB_CMD_IMPORT   = "import";
PCB_CMD_VERBOSE  = "verbose";

-- syntax
PCB_SYNTAX_ERROR    = PCB_ADDON_NAME.." Syntax Error: ";
PCB_SYNTAX_SAVE     = " |cff00ff00"..PCB_CMD_SAVE.."|r <profile name> (Save the current bindings to a new profile.)";
PCB_SYNTAX_LOAD     = " |cff00ff00"..PCB_CMD_LOAD.."|r <profile name> (Load a set of bindings from an existing profile.)";
PCB_SYNTAX_DELETE   = " |cff00ff00"..PCB_CMD_DELETE.."|r <profile name> (Delete the specified profile.)";
PCB_SYNTAX_LIST     = " |cff00ff00"..PCB_CMD_LIST.."|r (Display a list of all saved profiles.)";
PCB_SYNTAX_IMPORT   = " |cff00ff00"..PCB_CMD_IMPORT.."|r (Import binding sets from ClassBinding.)";
PCB_SYNTAX_VERBOSE  = " |cff00ff00"..PCB_CMD_VERBOSE.."|r (Toggles whether binding update confirmations are displayed.)";

-- Command Help
PCB_COMMAND_HELP = {
	PCB_ADDON_NAME.." Help:",
	"/pcb <command> [args] to perform the following commands:",
	PCB_SYNTAX_SAVE,
	PCB_SYNTAX_LOAD,
	PCB_SYNTAX_DELETE,
	PCB_SYNTAX_LIST,
	PCB_SYNTAX_IMPORT,
	PCB_SYNTAX_VERBOSE,
}

-- Output Strings
PCB_OUT_UPDATED          = "Key bindings updated for %s.";
PCB_OUT_IMPORT_OK        = "Import of key binding sets was successful.";
PCB_OUT_IMPORT_FAIL      = "Failed importing key binding sets from ClassBinding.  This is most likely because no SavedVariables data was found.";
PCB_OUT_IMPORT_NONE      = "Unable to find any character specific key binding sets from ClassBinding's SavedVariables.";
PCB_OUT_IMPORTING        = "Importing key binding set for %s";
PCB_OUT_PROFILE_DELETE   = "The binding profile for '%s' has been deleted.";
PCB_OUT_PROFILE_SAVE     = "The current bindings have been saved to '%s'.";
PCB_OUT_PROFILE_LOAD     = "Bindings for '%s' have been loaded successfully.";
PCB_OUT_PROFILE_NOTFOUND = "The binding profile for '%s' does not exist.";
PCB_OUT_LIST_HEADER      = "The following binding profiles have been saved:";
PCB_OUT_LIST_TOTAL       = "Total: %s";
PCB_OUT_VERBOSE_ON       = "Binding update confirmations are now on.";
PCB_OUT_VERBOSE_OFF      = "Binding update confirmations are now off.";
