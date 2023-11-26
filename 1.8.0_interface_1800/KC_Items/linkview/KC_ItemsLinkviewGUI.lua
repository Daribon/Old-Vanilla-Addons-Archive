
KC_LINKVIEW_GUI_CONFIG = {
	name	  = "KC_LinkviewFrame",
	type	  = ACEGUI_DIALOG,
	title	  = KC_LINKVIEW_TEXT_LINKVIEWTITLE,
	isSpecial = TRUE,
	width	  = 375,
	height	  = 500,
	OnShow	  = "Build",
	OnHide	  = "Cleanup",
	elements  = {
		SortBox	 = {
			type	 = ACEGUI_OPTIONSBOX,
			title	 = KC_LINKVIEW_TEXT_SORT_OPTIONS,
			width	 = 351,
			height	 = 46,
			anchors	 = {
				topleft	= {xOffset = 12, yOffset = -37}
			},
			elements = {
				Teir1	 = {
					type	 = ACEGUI_DROPDOWN,
					title	 = KC_LINKVIEW_TEXT_TEIR_1,
					width	 = 103,
					height	 = 26,
					anchors	 = {
						topleft = {xOffset = 5, yOffset = -15}
					},
					fill	 = "FillSortDrops",
				},
				Teir2	 = {
					type	 = ACEGUI_DROPDOWN,
					title	 = KC_LINKVIEW_TEXT_TEIR_2,
					width	 = 103,
					height	 = 26,
					anchors	 = {
						left = {relTo = "$parentTeir1", relPoint = "right", xOffset = 4, yOffset = 0}
					},
					fill	 = "FillSortDrops",
				},
				Teir3	 = {
					type	 = ACEGUI_DROPDOWN,
					title	 = KC_LINKVIEW_TEXT_TEIR_3,
					width	 = 103,
					height	 = 26,
					anchors	 = {
						left = {relTo = "$parentTeir2", relPoint = "right", xOffset = 4, yOffset = 0}
					},
					fill	 = "FillSortDrops",
				},
				Order  = {
					type	 = ACEGUI_BUTTON,
					title	 = "^",
					width	 = 20,
					height	 = 24,
					anchors	 = {
						left = {relTo = "$parentTeir3", relPoint = "right", xOffset = 1, yOffset = 0}
					},
					disabled = FALSE,
					OnClick	 = "Sort"
				},
			},
		},
		ItemsCount = {
			type	 = ACEGUI_BUTTON,
			title	 = "",
			width	 = 320,
			height	 = 16,
			anchors	 = {
				bottomright = {relTo = "$parentItems", relPoint = "topright", xOffset = -5, yOffset = -1}
			},
			disabled = TRUE,
		},
		Items	 = {
			type	 = ACEGUI_LISTBOX,
			title	 = KC_LINKVIEW_TEXT_ITEMS,
			width	 = 351,
			height	 = 320,
			anchors	 = {
				topleft = {relTo = "$parentSortBox", relPoint = "bottomleft", xOffset = 0, yOffset = -14}
			},
			fill		= "FillItemsListBox",
			OnItemEnter = "OnItemEnter",
			OnSelect	= "OnSelect",
		},
		SearchBox	 = {
			type	 = ACEGUI_OPTIONSBOX,
			title	 = KC_LINKVIEW_TEXT_SEARCH_OPTIONS,
			width	 = 251,
			height	 = 50,
			anchors	 = {
				bottomleft	= {relPoint = "bottomleft", xOffset = 12, yOffset = 16}
			},
			elements = {
				SearchText = {
					type			= ACEGUI_INPUTBOX,
					title			= KC_LINKVIEW_TEXT_SEARCH_TEXT,
					width			= 165 ,
					height			= 26,
					anchors			= {
						left  = {relPoint = "left", xOffset = 12, yOffset = -5}					
					},
					disabled = FALSE,
					OnEnterPressed	= "SimpleSearch"
				},
				SearchButton  = {
					type	 = ACEGUI_BUTTON,
					title	 = KC_LINKVIEW_TEXT_SEARCH,
					width	 = 68,
					height	 = 22,
					anchors	 = {
						bottomleft = {relTo = "$parentSearchText", relPoint = "bottomright", xOffset = -3, yOffset = 2}
					},
					disabled = FALSE,
					OnClick	 = "SimpleSearch"
				},
			},
		},
		AdvSearchButton  = {
			type	 = ACEGUI_BUTTON,
			title	 = KC_LINKVIEW_TEXT_ADV_SEARCH,
			width	 = 98,
			height	 = 22,
			anchors	 = {
				bottomleft = {relTo = "$parentClose", relPoint = "topleft", xOffset = 0, yOffset = -1}
			},
			disabled = FALSE,
			OnClick	 = "Order"
		},
	}
}

KC_LinkviewGUI= AceGUI:new()

function KC_LinkviewGUI:FillSortDrops()
	return KC_LINKVIEW_SORTLIST_OPTIONS;
end

function KC_LinkviewGUI:FillItemsListBox()
	return self.sortedTable or {"Please Search"};
end

function KC_LinkviewGUI:Build()
	local str = format(KC_LINKVIEW_TEXT_TOTAL_GOOD_MATCHED, self.totalLinks or "0", self.goodLinks or "0", self.matchedLinks or "0");
	self.ItemsCount:SetValue(str);
end

function KC_LinkviewGUI:Cleanup()
	self.totalLinks		= 0;
	self.goodLinks		= 0;
	self.matchedLinks	= 0;
	self.searchTable = nil;
	self.idTable = nil;
	self.sortedTable = nil;
	self.Items:ClearList();
end

function KC_LinkviewGUI:OnItemEnter()
	if (not self.idTable) then return; end
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetHyperlink(self.idTable[this.rowID]);
end

function KC_LinkviewGUI:OnSelect()
	if (not self.idTable) then return; end
	local id = self.idTable[this.rowID];
	if( arg1 == "LeftButton" ) then
		if( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert(self.app.app:GetTextLink(id));
		elseif (IsControlKeyDown()) then
			DressUpItemLink(self.app.app:GetHyperlink(id));
		else
			SetItemRef(self.app.app:GetHyperlink(id));
		end
	elseif( arg1 == "RightButton" and IsShiftKeyDown()) then
		local id = self.sortedLinks[this:GetID()];
		self.app.app:RemoveCode(id);
		self:SimpleSearch();
	end
end

--

function KC_LinkviewGUI:BuildSearchTable(pattern)
	self.totalLinks		= 0;
	self.goodLinks		= 0;
	self.matchedLinks	= 0;
	self.searchTable	= {};

	local id, name;
	local matches = TRUE;
	
	for id in self.app.app.db:get() do
		self.totalLinks = self.totalLinks + 1;
		if (id ~= "stats" and id ~= "profiles" and id ~= "v") then
			name = self.app:GetColoredName(id, 60);	
		end
		if (name) then
			self.goodLinks = self.goodLinks + 1;
			if (pattern) then
				matches = name and strfind(strlower(name), strlower(pattern)) or nil;	
			end
			if (matches) then
				self.searchTable[id] = name;
				self.matchedLinks = self.matchedLinks + 1;
			else
				matches = TRUE;
			end
			name = nil;
		end	
	end
	self:Build();
end

function KC_LinkviewGUI:BuildSortedTable()
	if (not self.searchTable) then return; end
	
	self.sortedTable = {}; local crossTable = {}; local sortTable = {};
	self.idTable = {};
	local method1 = self.SortBox.Teir1:GetValue() or "Name";
	local method2 = self.SortBox.Teir2:GetValue() or "Name";
	local method3 = self.SortBox.Teir3:GetValue() or "Name";
	local method4 = ((method1 ~= "Name") and (method2 ~= "Name") and (method3 ~= "Name")) and "Name" or "";
	local x = 1;

	for id in self.searchTable do

		local key = self:GetSortValue(id, method1) .. self:GetSortValue(id, method2) .. self:GetSortValue(id, method3) .. self:GetSortValue(id, method4);
		local orgkey = key;

		while (crossTable[key]) do
			key = orgkey .. x;
			x = x + 1;
		end

		tinsert(sortTable, key);
		crossTable[key] = id;
	end
	
	sort(sortTable);

	for id, value in sortTable do
		tinsert(self.sortedTable, self.searchTable[crossTable[value]]);
		tinsert(self.idTable, "item:" .. crossTable[value]);
	end
end

function KC_LinkviewGUI:GetSortValue(id, method)
	local value;
	if (method == "Name") then
		value = self.app:GetName(id);
	elseif (method == "Quality") then
		value = 9 - self.app:GetQuality(id);
	elseif (method == "Class") then
		value = self.app:GetClass(id);
	elseif (method == "Type") then
		value = self.app:GetSubClass(id);
	elseif (method == "Slot") then
		value = self.app:GetLocation(id) or "";
	elseif (method == "Level") then
		value = self.app:GetMinLevel(id);
	end
	return value or "";
end

function KC_LinkviewGUI:SimpleSearch()
	local pattern = self.SearchBox.SearchText:GetValue();
	pattern = pattern and ace.trim(pattern) or nil;
	self:BuildSearchTable(pattern);
	self:BuildSortedTable();
	self.Items:ClearList();
	self.Items:Update();
end

function KC_LinkviewGUI:Sort()
	self:BuildSortedTable();
	self.Items:ClearList();
	self.Items:Update();
end