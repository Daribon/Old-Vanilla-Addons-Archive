-- Version : English
-- Last Update : 04/05/2005


-- Start Not Localized --
local strTab = "	";
local strWhite = "|cffffffff";
local strYellow = "|cffffff00";
local strGreen = "|cff00ff00";
-- End Not Localized --

CASTINGBAR_HEADER = strWhite.."eCastingBar v"..strGreen..CASTING_BAR_MAJOR_VERSION..strWhite.."."..strGreen..CASTING_BAR_MINOR_VERSION..strWhite;

CASTINGBAR_CHAT_C1				= "unlock";
CASTINGBAR_CHAT_C2				= "lock";
CASTINGBAR_CHAT_C3				= "disabled";
CASTINGBAR_CHAT_C4				= "enabled";
CASTINGBAR_CHAT_C5				= "toggletexture";
CASTINGBAR_CHAT_C6				= "status";

-- Help Text
CASTINGBAR_LOADED = CASTINGBAR_HEADER.." Loaded. Type: /eCastingBar (eCB) for help."; 
CASTINGBAR_HELP = {

	strLine1 = strYellow.."--- "..CASTINGBAR_HEADER..strYellow.." --- ",
	strLine2 = strWhite..strTab..CASTINGBAR_CHAT_C4..strYellow.." - Enables the mod"..strWhite,
	strLine3 = strWhite..strTab..CASTINGBAR_CHAT_C3..strYellow.." - Disables the mod - blizzards casting bar will be used"..strWhite,
	strLine4 = strWhite..strTab..CASTINGBAR_CHAT_C2..strYellow.." - Lock the frame in place"..strWhite,
	strLine5 = strWhite..strTab..CASTINGBAR_CHAT_C1..strYellow.." - Unlock the frame so it can be moved"..strWhite,
	strLine6 = strWhite..strTab..CASTINGBAR_CHAT_C5..strYellow.." - Toggles between Perl texture, and default bar texture"..strWhite

};