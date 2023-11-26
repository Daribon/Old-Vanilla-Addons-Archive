if ( GetLocale() == "deDE" ) then
-- german translation

	CB_VALID_PARAMETERS = "G\195\188ltige Parameter: enable|disable emote= whisper= level= status help"
	CB_HELP_ONLOAD = "/carebear oder /cb f\195\188r Hilfe"

	CB_ENABLED = "|cff00ff00CareBear aktiviert.|r"
	CB_DISABLED = "|cffff0000CareBear deaktiviert.|r"

	CB_EMOTE_DISABLED = "|cffff0000CareBear Emote-bei-Ablehnung deaktiviert.|r"
	CB_EMOTE_ENABLED = "|cff00ff00CareBear Emote-bei-Ablehnung aktiviert. |r"

	CB_WHISPER_DISABLED = "|cffff0000CareBear Fl\195\188stern-bei-Ablehnung deaktiviert.|r"
	CB_WHISPER_ENABLED = "|cff00ff00CareBear Fl\195\188stern-bei-Ablehnung aktiviert. |r"

	CB_LEVEL_DISABLED = "|cffff0000CareBear Levelbasierte Ablehnung deaktiviert.|r"
	CB_LEVEL_ENABLED = "|cff00ff00CareBear Levelbasierte Ablehnung aktiviert. |r"
	
	CB_HELP_LINE1 = "CareBear lehnt automatisch alle Duellanfragen ab wenn es aktiviert ist."
	CB_HELP_LINE2 = "Benutze |cffea8fd4/cb enable|r um CareBear zu aktivieren, |cffea8fd4/cb disable|r um es zu deaktivieren."
	CB_HELP_LINE3 = "|cffea8fd4/cb emote=<emote>|r setzt ein Emote, das bei Ablehnung ausgef\195\188hrt wird."
	CB_HELP_LINE4 = " - zum Beispiel f\195\188hrt |cffea8fd4/cb emote=stare|r dazu, das ihr die anfragende Person anstarrt."
	CB_HELP_LINE5 = "|cffea8fd4/cb emote=|r ohne Emote deaktiviert die Funktion."
	CB_HELP_LINE6 = "|cffea8fd4/cb whisper=<message>|r setzt eine Nachricht, die bei Ablehnung gefl\195\188stert wird."
	CB_HELP_LINE7 = " - zum Beispiel |cffea8fd4/cb whisper=Ich m\195\182chte im Moment kein Duell.|r"
	CB_HELP_LINE8 = "|cffea8fd4/cb whisper=|r ohne Nachricht deaktiviert die Funktion."
	CB_HELP_LINE9 = "|cffea8fd4/cb level=<num>|r setzt eine maximale Leveldifferenz f\195\188r Duelle."
	CB_HELP_LINE10 = " - zum Beispiel |cffea8fd4/cb level=10|r"
	CB_HELP_LINE11 = "|cffea8fd4/cb level=|r ohne Nummer deaktiviert die Funktion."

	CB_STATUS_REFUSAL_ON = "CareBear Duell-Ablehnung: |cff00ff00An|r"
	CB_STATUS_REFUSAL_OFF = "CareBear Duell-Ablehnung: |cffff0000Aus|r"
	CB_STATUS_EMOTE_ON = "CareBear Emote-bei-Ablehnung: |cff00ff00An|r"
	CB_STATUS_EMOTE_OFF = "CareBear Emote-bei-Ablehnung: |cffff0000Aus|r"
	CB_STATUS_WHISPER_ON = "CareBear Fl\195\188stern-bei-Ablehnung: |cff00ff00An|r"
	CB_STATUS_WHISPER_OFF = "CareBear Fl\195\188stern-bei-Ablehnung: |cffff0000Aus|r"
	CB_STATUS_LEVEL_ON = "CareBear Levelbasierte Ablehnung: |cff00ff00An|r"
	CB_STATUS_LEVEL_OFF = "CareBear Levelbasierte Ablehnung: |cffff0000Aus|r"

else
-- english (default)

	CB_VALID_PARAMETERS = "Valid Parameters: enable|disable emote= whisper= level= status help"
	CB_HELP_ONLOAD = "/carebear or /cb for help"

	CB_ENABLED = "|cff00ff00CareBear Enabled.|r"
	CB_DISABLED = "|cffff0000CareBear Disabled.|r"

	CB_EMOTE_DISABLED = "|cffff0000CareBear Emote-on-Refusal Disabled.|r"
	CB_EMOTE_ENABLED = "|cff00ff00CareBear Emote-on-Refusal Enabled. |r"

	CB_WHISPER_DISABLED = "|cffff0000CareBear Whisper-on-Refusal Disabled.|r"
	CB_WHISPER_ENABLED = "|cff00ff00CareBear Whisper-on-Refusal Enabled.|r"

	CB_LEVEL_DISABLED = "|cffff0000CareBear Level-Based Refusal Disabled.|r"
	CB_LEVEL_ENABLED = "|cff00ff00CareBear Level-Based Refusal Enabled. |r"
	
	CB_HELP_LINE1 = "CareBear will auto-refuse all duel requests you receive when enabled."
	CB_HELP_LINE2 = "Use |cffea8fd4/cb enable|r to turn on, |cffea8fd4/cb disable|r to turn off."
	CB_HELP_LINE3 = "|cffea8fd4/cb emote=<emote>|r will set an emote to be performed on refusal."
	CB_HELP_LINE4 = " - for example |cffea8fd4/cb emote=stare|r will cause you to /stare the person requesting the duel."
	CB_HELP_LINE5 = "|cffea8fd4/cb emote=|r without an emote will turn off the Emote function."
	CB_HELP_LINE6 = "|cffea8fd4/cb whisper=<message>|r will set a message to send to the person requesting the duel."
	CB_HELP_LINE7 = " - for example |cffea8fd4/cb whisper=I don't want to duel right now.|r"
	CB_HELP_LINE8 = "|cffea8fd4/cb whisper=|r without a message will turn off the Whisper function."
	CB_HELP_LINE9 = "|cffea8fd4/cb level=<num>|r will set a maximum level difference for Dueling."
	CB_HELP_LINE10 = " - for example |cffea8fd4/cb level=10|r"
	CB_HELP_LINE11 = "|cffea8fd4/cb level=|r without a number will turn off the Level-Based Refusal."

	CB_STATUS_REFUSAL_ON = "CareBear Duel-Refusal: |cff00ff00On|r"
	CB_STATUS_REFUSAL_OFF = "CareBear Duel-Refusal: |cffff0000Off|r"
	CB_STATUS_EMOTE_ON = "CareBear Emote-on-Refusal: |cff00ff00On|r"
	CB_STATUS_EMOTE_OFF = "CareBear Emote-on-Refusal: |cffff0000Off|r"
	CB_STATUS_WHISPER_ON = "CareBear Whisper-on-Refusal: |cff00ff00On|r"
	CB_STATUS_WHISPER_OFF = "CareBear Whisper-on-Refusal: |cffff0000Off|r"
	CB_STATUS_LEVEL_ON = "CareBear Level-Based Refusal: |cff00ff00On|r"
	CB_STATUS_LEVEL_OFF = "CareBear Level-Based Refusal: |cffff0000Off|r"

end