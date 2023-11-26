KC_AUCTION_FILTERCHK_TEMPLATE = {
	type     = ACEGUI_CHECKBOX,
	title    = "",
	disabled = FALSE,
	OnClick	 = "filterClick",
	width	 = 20,
	height	 = 20,
	anchors	 = {
		right = {
			relPoint = "right",
			xOffset	 = -5,
			yOffset	 = 0,
		}
	}
}

KC_AUCTION_GUI_CONFIG = {
	name = "KC_Auction_",
	elements = {
		ScanButton   = {
			type     = ACEGUI_BUTTON,
			title    = KC_AUCTION_TEXT_SCAN,
			disabled = FALSE,
			OnClick	 = "scan",
			width	 = 80,
			height	 = 22,
			anchors	 = {
				right = {
					relTo	 = "BrowseBidButton",
					relPoint = "left",
					xOffset	 = 0,
					yOffset	 = 0,
				}
			},
		},
		FilterChk0 = {
			type     = ACEGUI_CHECKBOX,
			title    = "All",
			disabled = FALSE,
			OnClick	 = "filterAllClick",
			OnShow	 = "UpdateAllChk",
			width	 = 20,
			height	 = 20,
			anchors	 = {
				bottom = {
					relTo	 = "KC_Auction_FilterChk1",
					relPoint = "top",
					xOffset	 = -8,
					yOffset	 = 3,
				}
			}
		},
		FilterChk1   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk2   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk3   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk4   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk5   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk6   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk7   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk8   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk9   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk10   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk11   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk12   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk13   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk14   = KC_AUCTION_FILTERCHK_TEMPLATE,
		FilterChk15   = KC_AUCTION_FILTERCHK_TEMPLATE,
	}
}

KC_AuctionGUI= AceGUI:new()

function KC_AuctionGUI:scan()
	if (self.scanning) then
		self.ScanButton:SetValue(KC_AUCTION_TEXT_SCAN);
		self.scanning = FALSE;
		self.app:ScanCanceled();
	else 
		self.ScanButton:SetValue(KC_AUCTION_TEXT_STOP_SCAN);
		self.scanning = TRUE;
		self.app:Scan();
	end
end

function KC_AuctionGUI:filterClick()
	this:SetChecked(self.app:TogOpt(this:GetID(), {"options"}));
	self:UpdateAllChk();
end

function KC_AuctionGUI:filterAllClick()
	if (self.FilterChk0:GetChecked()) then
		for i = 1, 10 do
			self.app:SetOpt(i, 1, self.app.optPath);
		end
	else
		for i = 1, 10 do
			self.app:SetOpt(i, nil, self.app.optPath);
		end
	end
	self:UpdateChks();
end

function KC_AuctionGUI:UpdateChks()
	for i = 1, 15 do
		local button = getglobal("AuctionFilterButton" .. i);
		local chk = self["FilterChk" .. i];
		if (not button:IsVisible() or button.type ~= "class") then
			chk:Hide();
		else
			chk:Show();
			chk:SetID(button.index);
			chk:SetChecked(self.app:GetOpt(chk:GetID(), self.app.optPath));
		end
	end
	self:UpdateAllChk();
end

function KC_AuctionGUI:UpdateAllChk()
	local all = true;
	for i = 1, 10 do
		all = all and self.app:GetOpt(i, self.app.optPath);
	end
	self.FilterChk0:SetChecked(all);
end

function KC_AuctionGUI:FiltersUpdate()
	self:CallHook("AuctionFrameFilters_Update");
	self:UpdateChks();
end

function KC_AuctionGUI:FilterClick()
	self:CallHook("AuctionFrameFilter_OnClick");
	self:UpdateChks();
end

function KC_AuctionGUI:Hooks()
	self:Hook("AuctionFrameFilter_OnClick", "FilterClick");
	self:Hook("AuctionFrameFilters_Update", "FiltersUpdate");
end