--[[

	MonkeyQuest:
	Displays your quests for quick viewing.
	
	Website:	http://wow.visualization.ca/
	Author:		Trentin (monkeymods@gmail.com)
	
	
	Contributors:
	Celdor
		- Help with the Quest Log Freeze bug
		
	Diungo
		- Toggle grow direction
		
	Pkp
		- Color Quest Titles the same as the quest level
	
	wowpendium.de
		- German translation
		
	MarsMod
		- Valid player name before the VARIABLES_LOADED event bug

--]]


-- as good a place as any for default "constants"
MONKEYQUEST_DELAY							= 0.3;
MONKEYQUEST_DEFAULT_ALPHA					= 0.5;
MONKEYQUEST_DEFAULT_WIDTH					= 255;
MONKEYQUEST_DEFAULT_LEFT					= 216;
MONKEYQUEST_DEFAULT_TOP						= 864;
MONKEYQUEST_DEFAULT_BOTTOM					= 832;
MONKEYQUEST_DEFAULT_QUESTTITLECOLOUR		= "|cFFFFFFFF";
MONKEYQUEST_DEFAULT_HEADEROPENCOLOUR		= "|cFFBFBFFF";
MONKEYQUEST_DEFAULT_HEADERCLOSEDCOLOUR		= "|cFF9F9FFF";
MONKEYQUEST_DEFAULT_OVERVIEWCOLOUR			= "|cFF7F7F7F";
MONKEYQUEST_DEFAULT_SPECIALOBJECTIVECOLOUR	= "|cFFFFFF00";
MONKEYQUEST_DEFAULT_INITIALOBJECTIVECOLOUR	= "|cFFD82619";
MONKEYQUEST_DEFAULT_COMPLETEOBJECTIVECOLOUR	= "|cFF00FF19";
MONKEYQUEST_PADDING							= 25;


-- English
MONKEYQUEST_TITLE					= "MonkeyQuest";
MONKEYQUEST_VERSION					= "1.3.1";
MONKEYQUEST_TITLE_VERSION			= MONKEYQUEST_TITLE .. " v" .. MONKEYQUEST_VERSION;
MONKEYQUEST_DESCRIPTION				= "Displays your quests for quick viewing.";
MONKEYQUEST_INFO_COLOUR				= "|cffffff00";
MONKEYQUEST_LOADED_MSG				= MONKEYQUEST_INFO_COLOUR .. MONKEYQUEST_TITLE .. " v" .. MONKEYQUEST_VERSION .. " loaded";

MONKEYQUEST_CLOSE_TOOLTIP			= "Close";
MONKEYQUEST_MINIMIZE_TOOLTIP		= "Minimize";
MONKEYQUEST_HIDDEN_TOOLTIP			= "Show Hidden Items";

MONKEYQUEST_QUEST_DONE				= "done";
MONKEYQUEST_CONFIRM_RESET			= "Okay to reset " .. MONKEYQUEST_TITLE .. " settings to default values?";

MONKEYQUEST_CHAT_COLOUR				= "|cff00ff00";
MONKEYQUEST_SET_WIDTH_MSG			= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": You may need to '/console reloadui' to see the changes in width."
MONKEYQUEST_ALLOW_CLICKS_ON_MSG		= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": Allowing clicks on quests."
MONKEYQUEST_ALLOW_CLICKS_OFF_MSG	= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": NOT Allowing clicks on quests."
MONKEYQUEST_RESET_MSG				= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": Settings reset."

MONKEYQUEST_HELP_MSG				= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest help <command>\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Where <command> is any of the following: \n" ..
									  "reset, open, close, showhidden, hidehidden, useoverviews, nooverviews, " ..
									  "tipanchor, alpha, width, hideheaders, showheaders, hideborder, showborder, " ..
									  "growup, growdown, hidenumquests, shownumquests, lock, unlock, colourtitleon, " ..
									  "colourtitleoff, hidecompletedquests, showcompletedquests, hidecompletedobjectives, " ..
									  "showcompletedobjectives.";
MONKEYQUEST_HELP_RESET_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest reset\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Displays the reset config variables dialog.\n"
MONKEYQUEST_HELP_OPEN_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest open\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Shows the main " .. MONKEYQUEST_TITLE .. " frame.\n"
MONKEYQUEST_HELP_CLOSE_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest close\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Hides the main " .. MONKEYQUEST_TITLE .. " frame.\n"
MONKEYQUEST_HELP_SHOWHIDDEN_MSG		= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest showhidden\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Shows collapsed zone headers and hidden quests.\n"
MONKEYQUEST_HELP_HIDEHIDDEN_MSG		= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest hidehidden\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Hides collapsed zone headers and hidden quests.\n"
MONKEYQUEST_HELP_USEOVERVIEWS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest useoverviews\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Displays the quest overview for quests without objectives.\n"
MONKEYQUEST_HELP_NOOVERVIEWS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest nooverviews\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Don't display the quest overview for quests without objectives.\n"
MONKEYQUEST_HELP_TIPANCHOR_MSG		= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest tipanchor=<anchor position>\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Sets the anchor point of the tooltip where <anchor position> " .. 
									  "can be any of the following:\nANCHOR_TOPLEFT, ANCHOR_TOPRIGHT, ANCHOR_TOP, ANCHOR_LEFT, " ..
									  "ANCHOR_RIGHT, ANCHOR_BOTTOMLEFT, ANCHOR_BOTTOMRIGHT, ANCHOR_BOTTOM, ANCHOR_CURSOR, " .. 
									  "DEFAULT, NONE";
MONKEYQUEST_HELP_ALPHA_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest alpha=<0 - 255>\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Sets the backdrop alpha to the specified value.\n"
MONKEYQUEST_HELP_WIDTH_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest width=<positive integer>\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Sets the width to the specified value, the default is 255. " .. 
									  "Needs a '/console reloadui' to take effect.\n"
MONKEYQUEST_HELP_HIDEHEADERS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest hideheaders\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Never display any zone headers.\n"
MONKEYQUEST_HELP_SHOWHEADERS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest showheaders\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Display zone headers.\n"
MONKEYQUEST_HELP_HIDEBORDER_MSG		= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest hideborder\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Hide the border around the main " .. MONKEYQUEST_TITLE .. " frame.\n"
MONKEYQUEST_HELP_SHOWBORDER_MSG		= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest showborder\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Show the border around the main " .. MONKEYQUEST_TITLE .. " frame.\n"
MONKEYQUEST_HELP_GROWUP_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest growup\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Makes the main " .. MONKEYQUEST_TITLE .. " frame expand upwards.\n"
MONKEYQUEST_HELP_GROWDOWN_MSG		= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest growdown\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Makes the main " .. MONKEYQUEST_TITLE .. " frame expand downwards.\n"
MONKEYQUEST_HELP_HIDENUMQUESTS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest hidenumquests\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Hide the number of quests next to the title.\n"
MONKEYQUEST_HELP_SHOWNUMQUESTS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest shownumquests\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Show the number of quests next to the title.\n"
MONKEYQUEST_HELP_LOCK_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest lock\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Locks the " .. MONKEYQUEST_TITLE .. " frame in place.\n"
MONKEYQUEST_HELP_UNLOCK_MSG			= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest unlock\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Unlocks the " .. MONKEYQUEST_TITLE .. " frame, making it movable.\n"
MONKEYQUEST_HELP_COLOURTITLEON_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest colourtitleon\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Uses the difficulty to colour the entier quest title.\n"
MONKEYQUEST_HELP_COLOURTITLEOFF_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest colourtitleoff\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Doesn't colour the entier quest title by difficulty.\n"
MONKEYQUEST_HELP_HIDECOMPLETEDQUESTS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest hidecompletedquests\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Hides completed quests.\n"
MONKEYQUEST_HELP_SHOWCOMPLETEDQUESTS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest showcompletedquests\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Shows completed quests.\n"
MONKEYQUEST_HELP_HIDECOMPLETEDOBJECTIVES_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest hidecompletedobjectives\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Hides completed objectives.\n"
MONKEYQUEST_HELP_SHOWCOMPLETEDOBJECTIVES_MSG	= MONKEYQUEST_INFO_COLOUR .. "Usage: /mquest showcompletedobjectives\n" ..
									  MONKEYQUEST_CHAT_COLOUR .. "Shows completed objectives.\n"


-- bindings
BINDING_HEADER_MONKEYQUEST 			= MONKEYQUEST_TITLE;
BINDING_NAME_MONKEYQUEST_CLOSE 		= MONKEYQUEST_CLOSE_TOOLTIP.."/Open";
BINDING_NAME_MONKEYQUEST_MINIMIZE 	= MONKEYQUEST_MINIMIZE_TOOLTIP.."/Restore";
BINDING_NAME_MONKEYQUEST_HIDDEN		= "Hide/"..MONKEYQUEST_HIDDEN_TOOLTIP;
BINDING_NAME_MONKEYQUEST_NOHEADERS	= "Toggle No Headers";


if (GetLocale() == "deDE") then
	-- Translation by wowpendium.de
	--
	-- Umlaute sind wie folgt kodiert:
	--
	-- ü  - \195\188
	-- Ü  - \195\156
	-- ö  - \195\182
	-- Ö  - \195\150
	-- ä  - \195\164
	-- Ä  - \195\134
	-- ß  - \195\159

	--MONKEYQUEST_TITLE					= "MonkeyQuest";
	--MONKEYQUEST_VERSION					= "1.3";
	MONKEYQUEST_DESCRIPTION				= "Stellt Quests in einer kompakten \195\156bersicht dar.";
	MONKEYQUEST_INFO_COLOUR				= "|cffffff00";
	MONKEYQUEST_LOADED_MSG				= MONKEYQUEST_INFO_COLOUR .. MONKEYQUEST_TITLE .. " v" .. MONKEYQUEST_VERSION .. " geladen";

	MONKEYQUEST_CLOSE_TOOLTIP			= "Schlie\195\159en";
	MONKEYQUEST_MINIMIZE_TOOLTIP		= "Minimieren";
	MONKEYQUEST_HIDDEN_TOOLTIP			= "Zeige versteckte Elemente";

	MONKEYQUEST_QUEST_DONE				= "fertig";
	MONKEYQUEST_CONFIRM_RESET			= "Einstellungen von " .. MONKEYQUEST_TITLE .. " wirklich zur\195\188cksetzen?";

	MONKEYQUEST_CHAT_COLOUR				= "|cff00ff00";
	MONKEYQUEST_SET_WIDTH_MSG			= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": Um \195\134nderungen an der Breite wirksam werden zu lassen, m\195\188ssen Sie '/console reloadui' ausf\195\188hren."
	MONKEYQUEST_ALLOW_CLICKS_ON_MSG		= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": \195\150ffnen des Blizzard Quest Logs durch einen Klick auf eine Quest."
	MONKEYQUEST_ALLOW_CLICKS_OFF_MSG	= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": Kein \195\150ffnen des Blizzard Quest Logs durch einen Klick auf eine Quest."
	MONKEYQUEST_RESET_MSG				= MONKEYQUEST_CHAT_COLOUR .. MONKEYQUEST_TITLE .. ": Einstellungen zur\195\188cksetzen."

	MONKEYQUEST_HELP_MSG				= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest help <Kommando>\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Anzeigen der Hilfe, wobei <Kommando> eines der folgenden sein kann: \n" ..
										  "reset, open, close, showhidden, hidehidden, useoverviews, nooverviews, " ..
										  "tipanchor, alpha, width, hideheaders, showheaders, hideborder, showborder, " ..
										  "growup, growdown, hidenumquests, shownumquests, lock, unlock, colourtitleon, colourtitleoff";
	MONKEYQUEST_HELP_RESET_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest reset\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Zur\195\188cksetzen der Einstellungen auf die Werkseinstellung\n"
	MONKEYQUEST_HELP_OPEN_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest open\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "\195\150ffnen des " .. MONKEYQUEST_TITLE .. " Fensters\n"
	MONKEYQUEST_HELP_CLOSE_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest close\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Schlie\195\159en des " .. MONKEYQUEST_TITLE .. " Fensters\n"
	MONKEYQUEST_HELP_SHOWHIDDEN_MSG		= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest showhidden\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Anzeigen aller, auch ausgeblendeter Quests\n"
	MONKEYQUEST_HELP_HIDEHIDDEN_MSG		= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest hidehidden\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Ausblenden entsprechend markierter Quests\n"
	MONKEYQUEST_HELP_USEOVERVIEWS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest useoverviews\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Anzeigen der Questzusammenfassung bei Quests, die keine Sammel- oder Killquest sind\n"
	MONKEYQUEST_HELP_NOOVERVIEWS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest nooverviews\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Kein Anzeigen der Questzusammenfassung bei Quests, die keine Sammel- oder Killquest sind\n"
	MONKEYQUEST_HELP_TIPANCHOR_MSG		= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest tipanchor=<Ankerposition>\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Festlegen der Tooltip Position. M\195\182gliche Werte f\195\188r <Ankerposition> sind \n" .. 
										  "ANCHOR_TOPLEFT, ANCHOR_TOPRIGHT, ANCHOR_TOP, ANCHOR_LEFT, " ..
										  "ANCHOR_RIGHT, ANCHOR_BOTTOMLEFT, ANCHOR_BOTTOMRIGHT, ANCHOR_BOTTOM, ANCHOR_CURSOR, " .. 
										  "DEFAULT, NONE";
	MONKEYQUEST_HELP_ALPHA_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest alpha=<0 - 255>\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Festlegen der Transparenz des Fensters, mu\195\159 eine positive Ganzzahl sein. 0 ist komplett transparent, 255 komplett undurchsichtig\n"
	MONKEYQUEST_HELP_WIDTH_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest width=<positive integer>\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Festlegen der Fensterbreite, Standardwert ist 225, mu\195\159 eine positive Ganzahl sein. Um die \195\134nderung sichtbar zu machen, mu\195\159 die Oberfl\195\164che \195\188ber das Kommando /console reloadui neu geladen werden\n"
	MONKEYQUEST_HELP_SHOWHEADERS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest showheaders\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Einblenden der Namen der Regionen\n"
	MONKEYQUEST_HELP_HIDEHEADERS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest hideheaders\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Ausblenden der Namen der Regionen\n"
	MONKEYQUEST_HELP_HIDEBORDER_MSG		= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest hideborder\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Kein Zeichnen eines Rahmens um das Fenster\n"
	MONKEYQUEST_HELP_SHOWBORDER_MSG		= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest showborder\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Zeichnen eines Rahmens um das Fenster\n"
	MONKEYQUEST_HELP_GROWUP_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest growup\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Festlegung, da\195\159 sich das Fenster nach oben hin erweitert, wenn eine neue Quest angenommen wird\n"
	MONKEYQUEST_HELP_GROWDOWN_MSG		= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest growdown\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Festlegung, da\195\159 sich das Fenster nach unten hin erweitert, wenn eine neue Quest angenommen wird\n"
	MONKEYQUEST_HELP_HIDENUMQUESTS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest hidenumquests\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Keine Anzeige der Anzahl der angenommenen Quests\n"
	MONKEYQUEST_HELP_SHOWNUMQUESTS_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest shownumquests\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Anzeige der Anzahl der angenommenen Quests\n"
	MONKEYQUEST_HELP_LOCK_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest lock\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Fixierung des Fensters\n"
	MONKEYQUEST_HELP_UNLOCK_MSG			= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest unlock\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Aufhebung der Fixierung des Fensters\n"
	MONKEYQUEST_HELP_COLOURTITLEON_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest colourtitleon\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Farbliche Kodierung der Quests nach ihrem Schwierigkeitsgrad\n"
	MONKEYQUEST_HELP_COLOURTITLEOFF_MSG	= MONKEYQUEST_INFO_COLOUR .. "Verwendung: /mquest colourtitleoff\n" ..
										  MONKEYQUEST_CHAT_COLOUR .. "Keine farbliche Kodierung der Quests nach ihrem Schwierigkeitsgrad\n"
end