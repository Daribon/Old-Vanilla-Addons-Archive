If you want a localized version of Petfeed (it won't work with unknown languages!), then please translate
these variables into your language, tell me, what your locale is ("deDE", "frFR" etc.) and send it to 
vincent@wow.g-d-g.de.


PF_CHATTITLE		= "Pet Feed US version loaded";

-- happiness, these must exactly match the text in pet window
PF_CONTENT	= "content";
PF_HAPPY	= "happy";

-- diets, these must exactly match the text in "pet detail"
PF_MEAT		= "meat";
PF_FISH		= "fish";
PF_BREAD	= "bread";
PF_CHEESE	= "cheese";
PF_FRUITS	= "fruit";
PF_FUNGUS	= "fungus";
PF_ALL		= "all";

-- various captions
PF_USAGE	= "Usage";
PF_FOOD		= "food";
PF_LIST		= "list";
PF_DIET		= "diet";
PF_ON		= "on";
PF_OFF		= "off";

-- commands
PF_ADD		= "+";
PF_ALERT	= "alert";
PF_FEED		= "feed";
PF_HELP		= "help";
PF_LEVEL	= "level";
PF_REMOVE	= "-";
PF_RESET	= "reset";
PF_SHOW		= "show";
PF_STATUS	= "status";

-- messages from client, these must exactly(!) match
PF_AFK		= "You are now AFK:";
PF_NOTAFK	= "You are no longer AFK.";

-- various messages to the chat
PF_AFKMODE	= "You're AFK, pet won't eat.";
PF_NOAFKMODE	= "You're no longer AFK, pet will eat again.";
PF_NOPET	= "You do not currently have a pet.";
PF_DEACT	= "PetFeed is disabled.";
PF_LETFEED	= "You are letting %s eat food in your pack.";
PF_WHENFEED	= "%s will eat food when less than %s.";
PF_TELLFEED	= "%s is alerting you when feeding.";
PF_NOTELLFEED	= "%s will not alert you when feeding.";
PF_ACTIVATED	= "PetFeed is now enabled.";
PF_DEACTIVATED	= "PetFeed is now disabled.";
PF_MSG_RESET	= "PetFeed configuration reset.";
PF_ADDEDTOLIST	=	"%s added to list '%s'.";
PF_ALREADYADDED	=  "%s is already in list '%s'.";
PF_FOODNOTFOUND	= "Could not find %s in your packs.";
PF_REMOVEDFROMLIST	=	"%s removed from list '%s'.";
PF_FOODNOTFOUNDINL	= "Could not find %s in list '%'.";
PF_SEARCHINGPACK	= "%s is searching through your bag...";
PF_EATS		= "%s eats a %s from your pack.";
PF_NOFOODFOUND	=	"%s could not find any food in your pack.";

-- help messages
PF_USAGE_ADD	= PF_USAGE..": /pf "..PF_ADD.." <"..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS.."> <"..PF_FOOD..">.";
PF_USAGE_REM	= PF_USAGE..": /pf " .. PF_REMOVE .. " <"..PF_FOOD..">.";
PF_USAGE_SHOW	= PF_USAGE..": /pf " .. PF_SHOW .. " <"..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS.."|"..PF_ALL..">.";
PF_HELP_HELP	= " - show this help";
PF_HELP_ONOFF	= " - turn PetFeed on or off.";
PF_HELP_STATUS	= " - check current settings.";
PF_HELP_RESET	= " - reset to default settings.";
PF_HELP_ALERT	= " - toggle alerting when feeding.";
PF_HELP_LEVEL	= " - set happiness level.";
PF_HELP_FEED	= " - feed your pet.";
PF_HELP_ADD	= " <"..PF_DIET.."> <"..PF_FOOD.."> - add food to list <"..PF_DIET..">.";
PF_HELP_REMOVE	= " <"..PF_FOOD.."> - remove food.";
PF_HELP_SHOW	= " <"..PF_DIET.."> - show food list <"..PF_DIET..">.";
PF_HELP_DIET	= "<"..PF_DIET..">: "..PF_MEAT.."|"..PF_FISH.."|"..PF_BREAD.."|"..PF_CHEESE.."|"..PF_FRUITS.."|"..PF_FUNGUS;
