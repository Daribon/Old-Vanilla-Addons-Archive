if( not ace:LoadTranslation("KC_Items_Linkview") ) then

KC_LINKVIEW_NAME          = "KC_Linkview"
KC_LINKVIEW_DESCRIPTION   = "A KC_Items Module for showing link data."

KC_LINKVIEW_TEXT_ADVSEARCHTITLE = "KC_Linkview: Adv Search";

KC_LINKVIEW_TEXT_LINKVIEWTITLE	= "KC_Linkview";
KC_LINKVIEW_TEXT_ITEMS			= "Items";
KC_LINKVIEW_TEXT_SORT_OPTIONS	= "Sort Options";
KC_LINKVIEW_TEXT_SEARCH_OPTIONS	= "Search Options";
KC_LINKVIEW_TEXT_SEARCH_TEXT	= "Search Text";
KC_LINKVIEW_TEXT_SEARCH			= "Search";
KC_LINKVIEW_TEXT_ADV_SEARCH		= "Adv Search";

KC_LINKVIEW_TEXT_TOTAL_GOOD_MATCHED	= "Total Links: %s | Good Links: %s | Matches: %s";

KC_LINKVIEW_TEXT_TEIR_1	= "Teir 1"
KC_LINKVIEW_TEXT_TEIR_2	= "Teir 2"
KC_LINKVIEW_TEXT_TEIR_3	= "Teir 3"

KC_LINKVIEW_SORTLIST_OPTIONS = {
	{val="Name"		,tip="Sorts an item by its name."},
	{val="Quality"	,tip="Sorts an item by its quality."},
	{val="Class"	,tip="Sorts an item by its class."},
	{val="Type"		,tip="Sorts an item by its type."},
	{val="Slot"		,tip="Sorts an item by its slot."},
	{val="Level"	,tip="Sorts an item by its level."},
}

KC_LINKVIEW_CMD_OPTIONS = {
	option	= "linkview",
	desc	= "commands related to the viewing of link data.",
	args	= {
		{
			option = "open",
			desc   = "Toggles view of the linkview window.",
			method = "show"
		},
	},
}

end
