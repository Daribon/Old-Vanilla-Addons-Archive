BINDING_HEADER_PETFEED = "PetFeed";

BINDING_NAME_PETFEED = "Feed Pet"; -- caption in config.

PF_CHATTITLE		= "Pet Feed US version loaded";

-- happiness, these must exactly match the text in pet window
PF_CONTENT			= "content";
PF_HAPPY				= "happy";

-- diets, these must exactly match the text in "pet detail"
PF_MEAT					= "Meat";
PF_FISH					= "Fish";
PF_BREAD				= "Bread";
PF_CHEESE				= "Cheese";
PF_FRUITS				= "Fruit";
PF_FUNGUS				= "Fungus";
PF_ALL					= "all";

-- various captions
PF_USAGE				= "Usage";
PF_FOOD					= "food";
PF_LIST					= "list";
PF_DIET					= "diet";
PF_ON						= "on";
PF_OFF					= "off";

-- commands
PF_ADD					= "+";
PF_ALERT				= "alert";
PF_FEED					= "feed";
PF_HELP					= "help";
PF_LEVEL				= "level";
PF_REMOVE				= "-";
PF_RESET				= "reset";
PF_SHOW					= "show";
PF_STATUS				= "status";

-- messages from client, these must exactly(!) match
PF_AFK					= "You are now AFK:";
PF_NOTAFK				= "You are no longer AFK.";

-- various messages to the chat
PF_AFKMODE			= "You're AFK, pet won't eat.";
PF_NOAFKMODE		= "You're no longer AFK, pet will eat again.";
PF_NOPET				= "You do not currently have a pet.";
PF_DEACT				= "PetFeed is disabled.";
PF_LETFEED			= "You are letting %s eat food in your pack.";
PF_WHENFEED			= "%s will eat food when less than %s.";
PF_TELLFEED			= "%s is alerting you when feeding.";
PF_NOTELLFEED		= "%s will not alert you when feeding.";
PF_ACTIVATED		= "PetFeed is now enabled.";
PF_DEACTIVATED	= "PetFeed is now disabled.";
PF_MSG_RESET		= "PetFeed configuration reset.";
PF_ADDEDTOLIST			=	"%s added to list '%s'.";
PF_ALREADYADDED			=  "%s is already in list '%s'.";
PF_FOODNOTFOUND			= "Could not find %s in your packs.";
PF_REMOVEDFROMLIST	=	"%s removed from list '%s'.";
PF_FOODNOTFOUNDINL	= "Could not find %s in list '%s'.";
PF_SEARCHINGPACK		= "%s is searching through your bag...";
PF_EATS							= "%s eats a %s from your pack.";
PF_NOFOODFOUND			=	"%s could not find any food in your pack.";

-- help messages
PF_USAGE_ADD		= PF_USAGE..": /pf "..PF_ADD.." <"..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS.."> <"..PF_FOOD..">.";
PF_USAGE_REM		= PF_USAGE..": /pf " .. PF_REMOVE .. " <"..PF_FOOD..">.";
PF_USAGE_SHOW		= PF_USAGE..": /pf " .. PF_SHOW .. " <"..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS.."|"..PF_ALL..">.";
PF_HELP_HELP		= " - show this help";
PF_HELP_ONOFF		= " - turn PetFeed on or off.";
PF_HELP_STATUS	= " - check current settings.";
PF_HELP_RESET		= " - reset to default settings.";
PF_HELP_ALERT		= " - toggle alerting when feeding.";
PF_HELP_LEVEL		= " - set happiness level.";
PF_HELP_FEED		= " - feed your pet.";
PF_HELP_ADD			= " <"..PF_DIET.."> <"..PF_FOOD.."> - add food to list <"..PF_DIET..">.";
PF_HELP_REMOVE	= " <"..PF_FOOD.."> - remove food.";
PF_HELP_SHOW		= " <"..PF_DIET.."> - show food list <"..PF_DIET..">.";
PF_HELP_DIET		= "<"..PF_DIET..">: "..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS;

if (GetLocale() == "deDE")
then
	BINDING_NAME_PETFEED = "f\195\188ttere Tier";
	PF_CHATTITLE		= "Pet Feed deutsche Version geladen";
	
	-- happiness, these must exactly match the text in pet window
	PF_CONTENT			= "Zufrieden";
	PF_HAPPY				= "Gl\195\188cklich";

	-- diets, these must exactly match the text in "pet detail"
	PF_MEAT					= "Fleisch";
	PF_FISH					= "Fisch";
	PF_BREAD				= "Brot";
	PF_CHEESE				= "K\195\164se";
	PF_FRUITS				= "Obst";
	PF_FUNGUS				= "Fungus";
	PF_ALL					= "alle";

	-- various captions
	PF_USAGE				= "Aufruf";
	PF_FOOD					= "Nahrung";
	PF_LIST					= "Liste";
	PF_DIET					= "Futterart";
	PF_ON						= "an";
	PF_OFF					= "aus";

	-- commands
	PF_ADD					= "+";
	PF_ALERT				= "meldung";
	PF_FEED					= "f\195\188ttern";
	PF_HELP					= "hilfe";
	PF_LEVEL				= "level";
	PF_REMOVE				= "-";
	PF_RESET				= "reset";
	PF_SHOW					= "zeige";
	PF_STATUS				= "status";

	-- messages from client, these must exactly(!) match
	PF_AFK					= "Ihr seit jetzt AFK:";
	PF_NOTAFK				= "Ihr werdet nicht mehr mit ";

	-- various messages to the chat
	PF_AFKMODE			= "Du bist AFK, Dein Tier frisst nicht mehr von allein.";
	PF_NOAFKMODE		= "Du bist nicht mehr AFK, Dein Tier frisst jetzt wieder von allein.";
	PF_NOPET				= "Du hast gerade kein Tier.";
	PF_DEACT				= "PetFeed ist deaktiviert.";
	PF_LETFEED			= "Du laesst %s fressen.";
	PF_WHENFEED			= "%s wird fressen, wenn es weniger als %s ist.";
	PF_TELLFEED			= "%s sagt Dir, wenn es frisst.";
	PF_NOTELLFEED		= "%s sagt Dir nicht, wenn es frisst.";
	PF_ACTIVATED		= "PetFeed ist nun aktiviert.";
	PF_DEACTIVATED	= "PetFeed ist nun deaktiviert.";
	PF_MSG_RESET		= "PetFeed Konfiguration zur\195\188ckgesetzt.";
	PF_ADDEDTOLIST			=	"%s zur Liste '%s' hinzugef\195\188gt.";
	PF_ALREADYADDED			=  "%s ist schon in Liste '%s'.";
	PF_FOODNOTFOUND			= "Ich konnte %s nicht in Deinen Packs finden.";
	PF_ADDEDTOLIST			=	"%s zur Liste '%s' hinzugef\195\188gt.";
	PF_REMOVEDFROMLIST	=	"%s von Liste '%s' entfernt.";
	PF_FOODNOTFOUNDINL	= "Ich konnte %s nicht in der Liste '%s' finden.";
	PF_SEARCHINGPACK		= "%s schn\195\188ffelt durch Deine Tasche...";
	PF_EATS							= "%s frisst ein %s aus Deiner Tasche.";
	PF_NOFOODFOUND			=	"%s konnte kein passendes Futter in Deiner Tasche finden.";

	-- help messages
	PF_USAGE_ADD		= PF_USAGE..": /pf " .. PF_ADD .. " <"..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS.."> <"..PF_FOOD..">.";
	PF_USAGE_REM		= PF_USAGE..": /pf " .. PF_REMOVE .. " <"..PF_FOOD..">.";
	PF_USAGE_SHOW		= PF_USAGE..": /pf " .. PF_SHOW .. " <"..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS.."|"..PF_ALL..">.";
	PF_HELP_HELP		= " - zeigt diese Hilfe.";
	PF_HELP_ONOFF		= " - schalte PetFeed ein oder aus.";
	PF_HELP_STATUS	= " - zeige aktuelle Einstellungen.";
	PF_HELP_RESET		= " - setze auf Standardeinstellungen zur\195\188ck.";
	PF_HELP_ALERT		= " - schalte \'melden beim Fressen\' um.";
	PF_HELP_LEVEL		= " - setze Level, ab dem gefressen wird.";
	PF_HELP_FEED		= " - f\195\188ttere Dein Tier.";
	PF_HELP_ADD			= " <"..PF_DIET.."> <name> - fuege <name> zur Liste <"..PF_DIET.."> hinzu.";
	PF_HELP_REMOVE	= " <name> - entferne <name>.";
	PF_HELP_SHOW		= " <"..PF_DIET.."> - zeige Futter in Liste <"..PF_DIET..">.";
	PF_HELP_DIET		= "<"..PF_DIET..">: "..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS;
end

function LocalLevel()
	if ( PetFeed_Config.Level == "content" )
	then
		return PF_CONTENT;
	else
		return PF_HAPPY;
	end
end

function isAFKEvent()
	local msg = arg1;
	if ( string.find(msg,PF_AFK) )
	then
		return true;
	end
	return false;
end

function isnotAFKEvent()
	local msg = arg1;
	if (string.find(msg,PF_NOTAFK)) 
	then
		return true;
	end
	return false;
end


function ShowHelp()
	ChatMessage("PetFeed:");
	ChatMessage("/PetFeed /pf <command>");
	ChatMessage("> " .. PF_HELP .. PF_HELP_HELP);
	ChatMessage("> " .. PF_ON.."|"..PF_OFF .. PF_HELP_ONOFF);
	ChatMessage("> " .. PF_STATUS .. PF_HELP_STATUS);
	ChatMessage("> " .. PF_RESET .. PF_HELP_RESET);
	ChatMessage("> " .. PF_ALERT .. PF_HELP_ALERT);
	ChatMessage("> " .. PF_LEVEL.." "..PF_CONTENT.."|"..PF_HAPPY .. PF_HELP_LEVEL);
	ChatMessage("> " .. PF_FEED .. PF_HELP_FEED);
	ChatMessage("> " .. PF_ADD .. PF_HELP_ADD);
	ChatMessage("> " .. PF_REMOVE .. PF_HELP_REMOVE);
	ChatMessage("> " .. PF_SHOW .. PF_HELP_SHOW);
	ChatMessage("> " .. PF_HELP_DIET);
end
