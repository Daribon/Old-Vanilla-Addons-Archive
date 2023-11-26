--[[

	File containing localized strings
	Test for French or German versions, defaults to English
	Version: 3.0.4
	Revision: $Id: localization.lua,v 1.9 2005/06/13 15:19:03 norganna Exp $

]]


-- ENGLISH STRINGS;
--   Override these below in a locale specific section.

AUCT_CLAS_ARMOR = "Armor";
AUCT_CLAS_CLOTH = "Cloth";
AUCT_CLAS_CONTAINER = "Container";
AUCT_CLAS_DRINK = "Drink";
AUCT_CLAS_FISHING = "Fishing";
AUCT_CLAS_FOOD = "Food";
AUCT_CLAS_GEM = "Gem";
AUCT_CLAS_HERB = "Herb";
AUCT_CLAS_HIDE = "Hide";
AUCT_CLAS_LEATHER = "Leather";
AUCT_CLAS_MAGE = "Mage";
AUCT_CLAS_ORE = "Ore";
AUCT_CLAS_POTION = "Potion";
AUCT_CLAS_QUEST = "Quest";
AUCT_CLAS_SHAMAN = "Shaman";
AUCT_CLAS_WARLOCK = "Warlock";
AUCT_CLAS_WEAPON = "Weapon";
AUCT_CLAS_WRITTEN = "Written";

AUCT_TYPE_ALCHEM = "Alchemy";
AUCT_TYPE_COOK = "Cook";
AUCT_TYPE_ENCHANT = "Enchant";
AUCT_TYPE_ENGINEER = "Engineer";
AUCT_TYPE_FSTAID = "1stAid";
AUCT_TYPE_LEATHER = "Leather";
AUCT_TYPE_MINING = "Mining";
AUCT_TYPE_POISON = "Poison";
AUCT_TYPE_SMITH = "Smith";
AUCT_TYPE_TAILOR = "Tailor";

AUCT_RECIPE_PREFIXES = {
	"Recipe: ", "Pattern: ", "Plans: ", "Schematic: ", "Formula: "
};

AUCT_FRMT_BROKER_HEADER = "Minimum profit: %s, HSP = 'Highest Sellable Price'";
AUCT_FRMT_BROKER_LINE = "%s, Last %s seen, HSP: %s, BO: %s, Prof: %s";
AUCT_FRMT_BROKER_DONE = "Brokering done";

AUCT_FRMT_BIDBROKER_HEADER = "Minimum profit: %s, HSP = 'Highest Sellable Price'";
AUCT_FRMT_BIDBROKER_MINBID = "minBid"
AUCT_FRMT_BIDBROKER_CURBID = "currentBid"
AUCT_FRMT_BIDBROKER_LINE = "%s, Last %s seen, HSP: %s, %s: %s, Prof: %s, Time: %s";
AUCT_FRMT_BIDBROKER_DONE = "Bid brokering done";

AUCT_FRMT_PCTLESS_HEADER = "Percent Less than Highest Sellable Price (HSP): %d%%";
AUCT_FRMT_PCTLESS_LINE = "%s, Last %d seen, HSP: %s, BO: %s, Prof: %s, Less %s";
AUCT_FRMT_PCTLESS_DONE = "Percent less done.";

AUCT_FRMT_COMPETE_HEADER = "Competing auctions at least %s less per item.";
AUCT_FRMT_COMPETE_LINE = "%s, Bid: %s, BO %s vs %s, %s less";
AUCT_FRMT_COMPETE_DONE = "Competing auctions done.";

AUCT_FRMT_NOAUCT = "No auctions found for the item: %s";
AUCT_FRMT_MEDIAN_LINE = "Of last %d seen, median buyout for 1 %s is: %s";
AUCT_FRMT_LOW_LINE = "%s, BO: %s, Seller: %s, For one: %s, Less than median: %s";
AUCT_FRMT_HSP_LINE = "Highest Sellable Price for one %s is: %s";

AUCT_FRMT_INFO_SEEN = "Seen %d times at auction total";
AUCT_FRMT_INFO_FORONE = "For 1: %s min/%s buyout (%s bid) [in %d's]";
AUCT_FRMT_INFO_AVERAGE = "%s min/%s buyout (%s bid)"
AUCT_FRMT_INFO_HISTMED = "Last %d seen, buyout median:";
AUCT_FRMT_INFO_SNAPMED = "Last scan %d seen, buyout median:";
AUCT_FRMT_INFO_YOURSTX = "Your %d stack: %s min/%s buyout (%s bid)";
AUCT_FRMT_INFO_BIDRATE = "%d%% have bids, %d%% have buyout";

AUCT_FRMT_INFO_NEVER = "Never seen at %s";
AUCT_FRMT_INFO_ALSOSEEN = "Seen %d times at %s";

AUCT_FRMT_INFO_CLASSUSE = "Class: %s used for %s";
AUCT_FRMT_INFO_CLASS = "Class: %s";
AUCT_FRMT_INFO_USE = "Used for: %s";

AUCT_FRMT_INFO_BUY = "Buy%s from vendor";
AUCT_FRMT_INFO_SELL = "Sell%s to vendor";
AUCT_FRMT_INFO_BUYMULT = "Buy%s %d (%s each)";
AUCT_FRMT_INFO_SELLMULT = "Sell%s %d (%s each)";

AUCT_FRMT_INFO_STX = "Stacks in lots of %d";

AUCT_FRMT_ACT_REMOVE = "Removing auction signature %s from current AH snapshot.";

AUCT_FRMT_AUCTINFO_HIST = "%d historical";
AUCT_FRMT_AUCTINFO_SNAP = "%d last scan";
AUCT_FRMT_AUCTINFO_LOW = "Snapshot low";
AUCT_FRMT_AUCTINFO_NOLOW = "Item not seen last snapshot";
AUCT_FRMT_AUCTINFO_ORIG = "Original bid";
AUCT_FRMT_AUCTINFO_SUGBUY = "Suggested buyout";
AUCT_FRMT_AUCTINFO_SUGBID = "Suggested bid";
AUCT_FRMT_AUCTINFO_MKTPRICE = "Market price";

AUCT_FRMT_WARN_MARKUP = "Marking up vendor by %s%%";
AUCT_FRMT_WARN_UNDERCUT = "Undercutting by %s%%";
AUCT_FRMT_WARN_NOCOMP = "No competition";
AUCT_FRMT_WARN_ABOVEMKT = "Competiton above market";
AUCT_FRMT_WARN_TOOLOW = "Cannot match lowest price";
AUCT_FRMT_WARN_MYPRICE = "Using my current price";
AUCT_FRMT_WARN_NODATA = "No data for HSP";

AUCT_CMD_OFF = "off";
AUCT_CMD_ON = "on";
AUCT_CMD_TOGGLE = "toggle";
AUCT_CMD_CLEAR = "clear";
AUCT_CMD_CLEAR_ALL = "all";
AUCT_CMD_CLEAR_SNAPSHOT = "snapshot";
AUCT_CMD_ALSO = "also";
AUCT_CMD_ALSO_OPPOSITE = "opposite";
AUCT_CMD_BROKER = "broker";
AUCT_CMD_BIDBROKER = "bidbroker";
AUCT_CMD_BIDBROKER_SHORT = "bb";
AUCT_CMD_EMBED = "embed";
AUCT_CMD_PERCENTLESS = "percentless";
AUCT_CMD_PERCENTLESS_SHORT = "pl";
AUCT_CMD_COMPETE = "compete";
AUCT_CMD_SCAN = "scan";

AUCT_CMD_AUTOFILL = "autofill";

AUCT_CMD_PCT_BIDMARKDOWN = "pct-bidmarkdown";
AUCT_CMD_PCT_MARKUP      = "pct-markup";
AUCT_CMD_PCT_MAXLESS     = "pct-maxless";
AUCT_CMD_PCT_NOCOMP      = "pct-nocomp";
AUCT_CMD_PCT_UNDERLOW    = "pct-underlow";
AUCT_CMD_PCT_UNDERMKT    = "pct-undermkt";


AUCT_OPT_CLEAR = "<[item]|"..AUCT_CMD_CLEAR_ALL.."|"..AUCT_CMD_CLEAR_SNAPSHOT..">";
AUCT_OPT_ALSO = "<realm-faction|"..AUCT_CMD_ALSO_OPPOSITE..">"
AUCT_OPT_BROKER = "[silver_profit]";
AUCT_OPT_BIDBROKER = "[silver_profit]";
AUCT_OPT_PERCENTLESS = "[percent]";
AUCT_OPT_COMPETE = "[silver_less]";
AUCT_OPT_SCAN = "[category]";

AUCT_OPT_PCT_BIDMARKDOWN = "<percent>";
AUCT_OPT_PCT_MARKUP = "<percent>";
AUCT_OPT_PCT_MAXLESS = "<percent>";
AUCT_OPT_PCT_NOCOMP = "<percent>";
AUCT_OPT_PCT_UNDERLOW = "<percent>";
AUCT_OPT_PCT_UNDERMKT = "<percent>";

AUCT_OPT_PCT_BIDMARKDOWN_DEFAULT = 20;
AUCT_OPT_PCT_MARKUP_DEFAULT = 300;
AUCT_OPT_PCT_MAXLESS_DEFAULT = 30;
AUCT_OPT_PCT_NOCOMP_DEFAULT = 2;
AUCT_OPT_PCT_UNDERLOW_DEFAULT = 5;
AUCT_OPT_PCT_UNDERMKT_DEFAULT = 20;


AUCT_SHOW_AVERAGE = "show-average";
AUCT_SHOW_LINK = "show-link";
AUCT_SHOW_MEDIAN = "show-median";
AUCT_SHOW_MESH = "show-mesh";
AUCT_SHOW_STACK = "show-stack";
AUCT_SHOW_STATS = "show-stats";
AUCT_SHOW_SUGGEST = "show-suggest";
AUCT_SHOW_USAGE = "show-usage";
AUCT_SHOW_VENDOR = "show-vendor";
AUCT_SHOW_VENDOR_BUY = "show-vendor-buy";
AUCT_SHOW_VENDOR_SELL = "show-vendor-sell";
AUCT_SHOW_EMBED_BLANK = "show-embed-blankline";

AUCT_HELP_ONOFF = "Turns the auction data display on and off";
AUCT_HELP_AVERAGE = "Select whether to show item's average auction price";
AUCT_HELP_LINK = "Select whether to show the link id in the tooltip";
AUCT_HELP_MEDIAN = "Select whether to show item's median buyout price";
AUCT_HELP_MESH = "Select whether to show item's mesh if it has one";
AUCT_HELP_SUGGEST = "Select whether to show item's suggested auction price";
AUCT_HELP_STATS = "Select whether to show item's bidded/buyout percentages";
AUCT_HELP_VENDOR = "Select whether to show item's vendor pricing";
AUCT_HELP_VENDOR_SELL = "Select whether to show item's vendor sell pricing (req show-vendor=on)";
AUCT_HELP_VENDOR_BUY = "Select whether to show item's vendor buy pricing (req show-vendor=on)";
AUCT_HELP_USAGE = "Select whether to show tradeskill item's usage";
AUCT_HELP_STACK = "Select whether to show the item's stackable size";
AUCT_HELP_EMBED_BLANK = "Select whether to show a blank line between the tooltip info and the auction info when embedded mode is on";

AUCT_HELP_CLEAR = "Clear the specified item's data (you must shift click insert the item(s) into the command) You may also specify the special keywords \"all\" or \"snapshot\"";
AUCT_HELP_ALSO = "Also display another server's values in the tooltip. The special keyword \"opposite\" means the opposite faction, \"off\" disables the functionality.";
AUCT_HELP_BROKER = "Show any auctions from the most recent scan that may be bid on and then resold for profit";
AUCT_HELP_BIDBROKER = "Show short or medium term auctions from the recent scan that may be bid on for profit";
AUCT_HELP_EMBED = "Embed the text in the original game tooltip (note: certain features are disabled when this is selected)";
AUCT_HELP_PERCENTLESS = "Show any recently scanned auctions whose buyout is a certain percent less than the highest sellable price";
AUCT_HELP_COMPETE = "Show any recently scanned auctions whose buyout is less than one of your items";
AUCT_HELP_SCAN = "Perform a scan of the auction house at the next visit, or while you are there (there is also a button in the auction pane)";
AUCT_HELP_AUTOFILL = "Set whether to autofill prices when dropping new auction items into the auction house window";

AUCT_HELP_PCT_BIDMARKDOWN = "Set the percentage that Auctioneer will mark down bids from the buyout price";
AUCT_HELP_PCT_MARKUP = "The percentage that vendor prices will be marked up when no other values are available";
AUCT_HELP_PCT_MAXLESS = "Set the maximum percentage that auctioneer will undercut market value before it gives up";
AUCT_HELP_PCT_NOCOMP = "The percentage that Auctioneer will undercut market value when there is no competition";
AUCT_HELP_PCT_UNDERLOW = "Set the percentage that Auctioneer will undercut the lowest auction price";
AUCT_HELP_PCT_UNDERMKT = "Percentage to cut market value by when unable to beat competition (due to maxless)";


AUCT_STAT_ON = "Displaying configured auction data";
AUCT_STAT_OFF = "Not displaying any auction data";

AUCT_FRMT_ACT_CLEARALL = "Clearing all auction data for %s";
AUCT_FRMT_ACT_CLEARSNAP = "Clearing current Auction House snapshot.";
AUCT_FRMT_ACT_CLEAR_OK = "Cleared data for item: %s";
AUCT_FRMT_ACT_CLEAR_FAIL = "Unable to find item: %s";
AUCT_FRMT_ACT_ENABLE = "Displaying item's %s data";
AUCT_FRMT_ACT_DISABLE = "Not displaying item's %s data";
AUCT_FRMT_ACT_SET = "Set %s to '%s'";
AUCT_FRMT_ACT_UNKNOWN = "Unknown command keyword: '%s'";

AUCT_TEXT_SCAN = "Scan";

-- Locale specific translations for the German client
if (GetLocale() == "deDE") then
--	AUCT_CLAS_ARMOR = "Armor";
--	AUCT_CLAS_CLOTH = "Cloth";
--	AUCT_CLAS_CONTAINER = "Container";
	AUCT_CLAS_DRINK = "Trunk";
--	AUCT_CLAS_FISHING = "Fishing";
	AUCT_CLAS_FOOD = "Nahrung";
	AUCT_CLAS_GEM = "Juwel";
	AUCT_CLAS_HERB = "Kraut";
--	AUCT_CLAS_HIDE = "Hide";
	AUCT_CLAS_LEATHER = "Leder";
--	AUCT_CLAS_MAGE = "Mage";
	AUCT_CLAS_ORE = "Erz";
	AUCT_CLAS_POTION = "Zaubertrank";
--	AUCT_CLAS_QUEST = "Quest";
--	AUCT_CLAS_SHAMAN = "Shaman";
--	AUCT_CLAS_WARLOCK = "Warlock";
--	AUCT_CLAS_WEAPON = "Weapon";
--	AUCT_CLAS_WRITTEN = "Written";

	AUCT_TYPE_ALCHEM = "Alchemie";
	AUCT_TYPE_COOK = "Koch";
	AUCT_TYPE_ENCHANT = "Verzaubern";
	AUCT_TYPE_ENGINEER = "Ingenieur";
	AUCT_TYPE_FSTAID = "Heilkunst";
	AUCT_TYPE_LEATHER = "Lederverarb";
	AUCT_TYPE_MINING = "Bergbau";
	AUCT_TYPE_POISON = "Giftmischer";
	AUCT_TYPE_SMITH = "Schmied";
	AUCT_TYPE_TAILOR = "Schneider";


-- Locale specific translations for the French client
elseif (GetLocale() == "frFR") then

end


