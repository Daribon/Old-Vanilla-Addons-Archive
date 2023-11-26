function myBindings_Locals_deDE()

ace:RegisterGlobals({
	version		= 1.01,
	translation = "", -- Needs to be set to deDE when there's a real translation.
	ACEG_LABEL_ERROR = "|cffff6060[error]|r"
})

-- These variables are a fix for the standard multiaction bars Blizzard added in
-- the 03/22/2005 1.3.0 (4286) patch.
BINDING_HEADER_MULTIACTIONBAR		= "MultiActionBar Bottom Left"
BINDING_HEADER_BLANK				= "MultiActionBar Bottom Right"
BINDING_HEADER_BLANK2				= "MultiActionBar Right Side 1"
BINDING_HEADER_BLANK3				= "MultiActionBar Right Side 2"

MYBINDINGS_NAME						= "myBindings"
MYBINDINGS_DESCRIPTION				= "Eine verbesserte Anzeige der Tastenbelegungen"
MYBINDINGS_MENU_TITLE				= "Befehlsmen\195\188"
MYBINDINGS_CONFIRM_REPLACE			= "Best\195\164tigen"
MYBINDINGS_UNBIND_BUTTON			= "L\195\182schen"
MYBINDINGS_BOUND_ERROR				= "|cffff0000%s ist bereits %s zugewiesen. \195\156berschreiben best\195\164tigen.|r"

MYBINDINGS_CATEGORY_GAME			= "Standard Interface"

MYBINDINGS_KEYBIND_OPEN				= "Opens the myBindings interface"

MYBINDINGS_TEXT_INVALID_ENTRY		= "You have entered invalid options."
MYBINDINGS_TEXT_CAT_INVALID			= "'%s' is not a valid category."
MYBINDINGS_TEXT_CAT_SET				= "Key header '%s' will now appear in the '%s' category."
MYBINDINGS_TEXT_HDR_INVALID			= "'%s' does not seem to be a valid header to categorize. Be "..
									  "sure you enter the exact case and spelling."

-- Chat command locals
MYBINDINGS_COMMANDS		= {"/mybindings", "/mb"}
MYBINDINGS_CMD_OPTIONS	= {
	{
		option	= "setcat",
		desc	= "Set a category for a specific binding header (found in the addon's Bindings.xml). "..
				  "Usage: /mybindings setcat <header> <category>",
		input	= TRUE,
		method	= "SetCategory",
	}
}

MYBINDINGS_LABEL_BINDINGS_LOADED	= "Bindings Loaded: |cffffffff%s|r"

MYBINDINGS_SAVE_BUTTON				= "Save"
MYBINDINGS_CANCEL_BUTTON			= "Cancel"
MYBINDINGS_GAME_DEFAULTS			= "Game Defaults"

end