
KC_LINKVIEW_ADV_SEARCH_CONFIG = {
	name	  = "KC_LinkviewAdvSearchFrame",
	type	  = ACEGUI_DIALOG,
	title	  = KC_LINKVIEW_TEXT_ADVSEARCHTITLE,
	isSpecial = TRUE,
	width	  = 375,
	height	  = 375,
	anchors	 = {
		topleft = {relTo = "KC_LinkviewFrame", relPoint = "topright", xOffset = 0, yOffset = 0}
	},
	elements = {
		SearchBox1	 = {
			type	 = ACEGUI_OPTIONSBOX,
			title	 = KC_LINKVIEW_TEXT_SEARCH_OPTIONS,
			width	 = 351,
			height	 = 46,
			anchors	 = {
				topleft	= {xOffset = 12, yOffset = -37}
			},
			elements = {
			},
		},
		SearchBox2	 = {
			type	 = ACEGUI_OPTIONSBOX,
			width	 = 351,
			height	 = 46,
			anchors	 = {
				topleft	= {relTo = "$parentSearchBox1", relPoint = "bottomleft", xOffset = 0, yOffset = 3}
			},
			elements = {
			},
		},
	}
}

KC_LinkviewAdvSearch = AceGUI:new()