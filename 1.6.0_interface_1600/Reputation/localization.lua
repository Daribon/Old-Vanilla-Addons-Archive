-- Version : English

REPUTATION_VERSION				= "Reputation Mod Version |cff00ff00%s|r";
REPUTATION_LOADED					= REPUTATION_VERSION.." Loaded.";

--Cosmos Configuration
REPUTATION_HEADER					= "Reputation";
REPUTATION_HEADER_INFO		= "Show reputation numbers.";
REPUTATION_ENABLE					= "Enable reputation.";
REPUTATION_ENABLE_INFO		= "This will activate the reputation mod.";
REPUTATION_RAW						= "Enable raw numbers.";
REPUTATION_RAW_INFO				= "Show Reputations as raw numbers.";
REPUTATION_FRAME					= "Chatframe";
REPUTATION_FRAME_INFO			= "Selects which chatframe reputation messages are sent to.";
REPUTATION_STANDING					= "Next standing notification.";
REPUTATION_STANDING_INFO		= "This will show numbers until the next standing in chat.";
REPUTATION_NOTIFICATION					= "Reputation notification.";
REPUTATION_NOTIFICATION_INFO		= "This will show reputation notifications in chat.";

--Slash Commands
REPUTATION_HELP						= "help";
REPUTATION_LIST						= "list";
REPUTATION_ON							= "on";
REPUTATION_OFF						= "off";
REPUTATION_STATUS					= "status";
REPUTATION_PCT_RAW				= "raw";
REPUTATION_FRAME					= "frame";
REPUTATION_NEXT						= "next";
REPUTATION_NOTIFY						= "notify";
REPUTATION_DEBUG					= "debug";


--Messages
REPUTATION_MOD_ON			= "Reputation Mod |cff00ff00On|r.";
REPUTATION_MOD_OFF			= "Reputation Mod |cffff0000Off|r.";
REPUTATION_NOTIFY_FRAME		= "Reputation Notification now set to this frame.";
REPUTATION_RAW_NUMS				= "Raw Numbers |cff00ff00On|r.";
REPUTATION_PCT_NUMS				= "Percentages |cff00ff00On|r.";
REPUTATION_DEBUG_ON				= "Debug Info |cff00ff00On|r.";
REPUTATION_INVALID_FRAME	= "Chatframe %s invalid.";
REPUTATION_VALID_FRAMES		= "Valid Frames: 1-%d.";
REPUTATION_SEL_FRAME			= "Printing reputation messages to: |cff00ff00ChatFrame%d|r.";
REPUTATION_NEXT_ON				= "Next Standing Notification |cff00ff00On|r.";
REPUTATION_NEXT_OFF				= "Next Standing Notification |cffff0000Off|r.";
REPUTATION_NOTIFY_ON			= "Reputation Notification |cff00ff00On|r.";
REPUTATION_NOTIFY_OFF			= "Reputation Notification |cffff0000Off|r.";


REPUTATION_HELP_TEXT0			= " ";
REPUTATION_HELP_TEXT1			= "Reputation mod help:";
REPUTATION_HELP_TEXT2			= "/reputation or /rep without any arguments displays this message.";
REPUTATION_HELP_TEXT3			= "/reputation <command> or /rep <command> to perform the following commands:";
REPUTATION_HELP_TEXT4			= "|cff00ff00"..REPUTATION_HELP.."|r: Also displays this message.";
REPUTATION_HELP_TEXT5			= "|cff00ff00"..REPUTATION_LIST.."|r: Shows current reputation values.";
REPUTATION_HELP_TEXT6			= "|cff00ff00"..REPUTATION_ON.."|r: Turns Reputation mod on.";
REPUTATION_HELP_TEXT7			= "|cff00ff00"..REPUTATION_OFF.."|r: Turns Reputation mod off.";
REPUTATION_HELP_TEXT8			= "|cff00ff00"..REPUTATION_STATUS.."|r: Show if reputation messaging is on or not.";
REPUTATION_HELP_TEXT9			= "|cff00ff00"..REPUTATION_PCT_RAW.."|r: Toggle between raw and percentage values.";
REPUTATION_HELP_TEXT10		= "|cff00ff00"..REPUTATION_FRAME.." #|r: Selects which chat window reputation messages are printed.";
REPUTATION_HELP_TEXT11		= "|cff00ff00"..REPUTATION_NEXT.."|r: Toggle to display next standing information in notifications.";
REPUTATION_HELP_TEXT12		= "|cff00ff00"..REPUTATION_NOTIFY.."|r: Toggle to display reputation notifications.";

REPUTATION_HELP_TEXT = {
	REPUTATION_HELP_TEXT0,
	REPUTATION_HELP_TEXT1,
	REPUTATION_HELP_TEXT2,
	REPUTATION_HELP_TEXT3,
	REPUTATION_HELP_TEXT4,
	REPUTATION_HELP_TEXT5,
	REPUTATION_HELP_TEXT6,
	REPUTATION_HELP_TEXT7,
	REPUTATION_HELP_TEXT8,
	REPUTATION_HELP_TEXT9,
	REPUTATION_HELP_TEXT10,
	REPUTATION_HELP_TEXT11,
	REPUTATION_HELP_TEXT12
};

--0=percentage, 1=raw numbers
REPUTATION_LOST0						= "Your reputation with %s has decreased by %.4f%%.";
REPUTATION_LOST1						= "Your reputation with %s has decreased by %d.";
REPUTATION_GAINED0					= "Your reputation with %s has increased by %.4f%%.";
REPUTATION_GAINED1					= "Your reputation with %s has increased by %d.";
REPUTATION_NEEDED0					= "%.4f%% reputation needed until %s with %s.";
REPUTATION_NEEDED1					= "%d reputation needed until %s with %s.";
REPUTATION_LEFT0						= "%.4f%% reputation left until %s with %s.";
REPUTATION_LEFT1						= "%d reputation left until %s with %s.";

REPUTATION_REACHED					= "%s reputation reached with %s.";

if ( GetLocale() == "frFR" ) then

elseif ( GetLocale() == "deDE" ) then

  -- Version : German by Lunox
  --[[
    translation helpers:
    ä = \195\164
    ü = \195\188
    ö = \195\182
  ]]--
  
  REPUTATION_VERSION				= "Reputation Mod Version |cff00ff00%s|r";
  REPUTATION_LOADED					= REPUTATION_VERSION.." geladen.";

  --Cosmos Configuration
  REPUTATION_HEADER					= "Reputation Mod";
  REPUTATION_HEADER_INFO		    = "Ruf in Zahlen anzeigen.";
  REPUTATION_ENABLE					= "Reputation aktivieren.";
  REPUTATION_ENABLE_INFO		= "Dies aktiviert die Reputation Mod.";
  REPUTATION_RAW					= "Absolute Zahlen.";
  REPUTATION_RAW_INFO				= "Zeige den Ruf in absoluten Zahlen (anstatt Prozentwerten).";
  REPUTATION_FRAME					= "Chatfenster";
  REPUTATION_FRAME_INFO				= "Auswahl, in welchem Chatfenster die Rufmeldungen dargestellt werden.";
  REPUTATION_STANDING					= "Meldungen: N\195\164chste (Ruf-)Stufe.";
  REPUTATION_STANDING_INFO		= "Wenn aktiviert, wird im Chatfenster angezeigt, wie viel Ruf noch bis zur n\195\164chsten Stufe ben\195\182tigt wird.";
  REPUTATION_NOTIFICATION					= "Meldungen: Ruf erhalten.";
  REPUTATION_NOTIFICATION_INFO		= "Wenn aktiviert, wird im Chatfenster angezeigt, wie viel Ruf gerade erworben/verloren wurde.";

  --Slash Commands
  REPUTATION_HELP					= "hilfe";
  REPUTATION_LIST					= "liste";
  REPUTATION_ON						= "an";
  REPUTATION_OFF					= "aus";
  REPUTATION_STATUS					= "status";
  REPUTATION_PCT_RAW				= "absolute zahlen";
  REPUTATION_FRAME					= "chatfenster";
  REPUTATION_NEXT					= "stufen";
  REPUTATION_NOTIFY					= "meldungen";
  REPUTATION_DEBUG					= "debug";


  --Messages
  REPUTATION_ON				= "Reputation Mod |cff00ff00An|r.";
  REPUTATION_OFF			= "Reputation Mod |cffff0000Aus|r.";
  REPUTATION_NOTIFY_FRAME		= "Rufmeldungen werden in diesem Chatfenster ausgegeben.";
  REPUTATION_RAW_NUMS			= "Absolute Zahlen |cff00ff00An|r.";
  REPUTATION_PCT_NUMS			= "Prozentzahlen |cff00ff00An|r.";
  REPUTATION_DEBUG_ON			= "Debug Info |cff00ff00An|r.";
  REPUTATION_INVALID_FRAME		= "Chatfenster %s ist ung\195\188ltig.";
  REPUTATION_VALID_FRAMES		= "G\195\188ltige Fenster: 1-%d.";
  REPUTATION_SEL_FRAME			= "Ausgabe der Ruf-Meldungen in: |cff00ff00ChatFrame%d|r.";
  REPUTATION_NEXT_ON			= "Meldungen: N\195\164chste Stufe |cff00ff00An|r.";
  REPUTATION_NEXT_OFF			= "Meldungen: N\195\164chste Stufe |cffff0000Aus|r.";
  REPUTATION_NOTIFY_ON			= "Rufmeldungen |cff00ff00An|r.";
  REPUTATION_NOTIFY_OFF			= "Rufmeldungen |cffff0000Aus|r.";


  REPUTATION_HELP_TEXT0			= " ";
  REPUTATION_HELP_TEXT1			= "Reputation Mod Hilfe:";
  REPUTATION_HELP_TEXT2			= "/reputation oder /rep ohne Parameter zeigt diese Meldung.";
  REPUTATION_HELP_TEXT3			= "/reputation <Befehl> oder /rep <Befehl> um die folgenden Befehle auszuf\195\188hren:";
  REPUTATION_HELP_TEXT4			= "|cff00ff00"..  REPUTATION_HELP.."|r: zeigt diese Meldung.";
  REPUTATION_HELP_TEXT5			= "|cff00ff00"..  REPUTATION_LIST.."|r: zeigt die aktuellen Ansehenswerte.";
  REPUTATION_HELP_TEXT6			= "|cff00ff00"..  REPUTATION_ON.."|r: schaltet Reputation Mod an.";
  REPUTATION_HELP_TEXT7			= "|cff00ff00"..  REPUTATION_OFF.."|r: schaltet Reputation Mod aus.";
  REPUTATION_HELP_TEXT8			= "|cff00ff00"..  REPUTATION_STATUS.."|r: zeigt, ob Ansehensmeldungen aktiviert sind oder nicht.";
  REPUTATION_HELP_TEXT9			= "|cff00ff00"..  REPUTATION_PCT_RAW.."|r: schaltet zwischen Prozent- und absoluter Anzeige um.";
  REPUTATION_HELP_TEXT10		= "|cff00ff00"..  REPUTATION_FRAME.." #|r: w\195\164hlt aus, in welchem Chatfenster die Meldungen angezeigt werden.";
  REPUTATION_HELP_TEXT11		= "|cff00ff00"..  REPUTATION_NEXT.."|r: schaltet die Anzeige der verbleibenden Rufpunkte bis zur n\195\164chsten Rufstufe an bzw. aus.";
  REPUTATION_HELP_TEXT12		= "|cff00ff00"..  REPUTATION_NOTIFY.."|r: schaltet die Anzeige der erhaltenen/verlorenen Rufpunkte an bzw. aus.";

  REPUTATION_HELP_TEXT = {
  	REPUTATION_HELP_TEXT0,
  	REPUTATION_HELP_TEXT1,
  	REPUTATION_HELP_TEXT2,
  	REPUTATION_HELP_TEXT3,
  	REPUTATION_HELP_TEXT4,
  	REPUTATION_HELP_TEXT5,
  	REPUTATION_HELP_TEXT6,
  	REPUTATION_HELP_TEXT7,
  	REPUTATION_HELP_TEXT8,
  	REPUTATION_HELP_TEXT9,
  	REPUTATION_HELP_TEXT10,
  	REPUTATION_HELP_TEXT11,
  	REPUTATION_HELP_TEXT12
  };

  --0=percentage, 1=raw numbers
  REPUTATION_LOST0						= "Euer Ruf bei %s ist um %.4f%% gesunken.";
  REPUTATION_LOST1						= "Euer Ruf bei %s ist um %d gesunken.";
  REPUTATION_GAINED0					= "Euer Ruf bei %s ist um %.4f%% gestiegen.";
  REPUTATION_GAINED1					= "Euer Ruf bei %s ist um %d gestiegen.";
  REPUTATION_NEEDED0					= "Noch %.4f%% Ruf ben\195\182tigt, um %s bei %s zu erreichen.";
  REPUTATION_NEEDED1					= "Noch %d Ruf ben\195\182tigt, um %s bei %s zu erreichen.";
  REPUTATION_LEFT0						= "Noch %.4f%% Ruf \195\188brig bevor %s bei %s erreicht wird.";
  REPUTATION_LEFT1						= "Noch %d Ruf \195\188brig bevor %s bei %s erreicht wird.";

  REPUTATION_REACHED					= "%s bei %s erreicht.";

end