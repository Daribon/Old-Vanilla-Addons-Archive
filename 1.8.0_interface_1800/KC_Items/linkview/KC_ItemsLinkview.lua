
KC_ItemsLinkview = KC_ItemsModuleClass:new({
	type		 = "linkview",
	name		 = KC_LINKVIEW_NAME,
	desc		 = KC_LINKVIEW_DESCRIPTION,
	cmdOptions	 = KC_LINKVIEW_CMD_OPTIONS,
	optPath		 = {"linkview", "options"},
	gui			 = KC_LinkviewGUI,
	advsearch	 = KC_LinkviewAdvSearch,
})

function KC_ItemsLinkview:Enable()
	self.gui:Initialize(self, KC_LINKVIEW_GUI_CONFIG)
	self.advsearch:Initialize(self, KC_LINKVIEW_ADV_SEARCH_CONFIG)
end

function KC_ItemsLinkview:show()
	self.gui:Show();
	--self.advsearch:Show();
end

-- Registering with KCI
KC_Items:Register(KC_ItemsLinkview)