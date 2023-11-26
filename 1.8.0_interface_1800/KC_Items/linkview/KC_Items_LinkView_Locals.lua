


if( not ace:LoadTranslation("KC_Items_LinkView") ) then

KC_LINKVIEW_NAME          = "KC_LinkView"
KC_LINKVIEW_DESCRIPTION   = "A KC_Items Module for viewing stored Itemlinks."

if (not KC_ITEMS_CMD_OPTIONS) then KC_ITEMS_CMD_OPTIONS = {}; end

local options = {
		option = "linkview",
		method = "linkviewtoggle",
        desc   = "LinkView related commands.",
}

table.insert(KC_ITEMS_CMD_OPTIONS, options);

KC_LINKVIEW_TEXT_HEADERPATTERN = "KC_LinkView - cnt: %s (%s)";

KC_ITEMS_TEXT_SEARCH = "Search";

KC_LINKVIEW_TEXT_NAME		= "Name";
KC_LINKVIEW_TEXT_QUALITY	= "Quality";
KC_LINKVIEW_TEXT_CLASS		= "Class";
KC_LINKVIEW_TEXT_TYPE		= "Type";
KC_LINKVIEW_TEXT_SLOT		= "Slot";
KC_LINKVIEW_TEXT_LEVEL		= "Level";
KC_LINKVIEW_TEXT_EMPTY		= " ";

KC_LINKVIEW_SORTDROPDOWN_LIST = {
	KC_LINKVIEW_TEXT_NAME,
	KC_LINKVIEW_TEXT_QUALITY,
	KC_LINKVIEW_TEXT_CLASS,
	KC_LINKVIEW_TEXT_TYPE,
	KC_LINKVIEW_TEXT_LEVEL,
	--KC_LINKVIEW_TEXT_EMPTY,
};

end
