ZGAnnounceGUI_PassDatabase_CurrentSelection = "";
ZGAnnounceGUI_Pass_Order = {};

ZGAnnounceGUI_PassDatabase_CurrentArr = nil;

function ZGAnnounceGUI_PassDatabase_InitiatePass(arr)
	ZGAnnounceGUI_Pass_Order = {};
	for k, v in arr do 
		table.insert(ZGAnnounceGUI_Pass_Order, k);
	end
	ZGAnnounceGUI_PassDatabase_RemoveDupes();
	ZGAnnounceGUI_PassDatabase_CurrentArr = arr;
	ZGAnnounceGUI_PassDatabase_CurrentSelection = nil;
	ZGAnnounceGUI_PassDatabase_Update();
end


function ZGAnnounceGUI_PassDatabase_Update()
	local maxItems = table.getn(ZGAnnounceGUI_Pass_Order);
	FauxScrollFrame_Update(ZGAnnounceGUI_PassDatabaseFrameScrollFrame, maxItems, ZGANNOUNCEUI_DB_ITEMS_SHOWN, ZGANNOUNCEUI_DB_ITEM_HEIGHT);
	for iItem = 1, ZGANNOUNCEUI_DB_ITEMS_SHOWN, 1 do
		local itemIndex = iItem + FauxScrollFrame_GetOffset(ZGAnnounceGUI_PassDatabaseFrameScrollFrame);
		local ZGAnnounceGUI_PassDatabaseItemSlot = getglobal("ZGAnnounceGUI_PassDatabaseItem"..iItem);
		if( itemIndex <= maxItems) then
			local name = ZGAnnounceGUI_Pass_Order[itemIndex];
			if name == ZGAnnounceGUI_PassDatabase_CurrentSelection then
				ZGAnnounceGUI_PassDatabaseItemSlot:SetTextColor(1,1,0);
			else
				ZGAnnounceGUI_PassDatabaseItemSlot:SetTextColor(1,1,1);
			end
			if ( type(name) ~= "string" ) then
				name = "";
			end
			ZGAnnounceGUI_PassDatabaseItemSlot:SetText(name);
			ZGAnnounceGUI_PassDatabaseItemSlot:Show();
		else
			ZGAnnounceGUI_PassDatabaseItemSlot:Hide();
		end
	end
end

function ZGAnnounceGUI_PassDatabase_RemoveDupes()
	local dirty = true;
	local foundId = nil;
	local iterations = 0;
	while ( dirty ) do
		dirty = false;
		for k, v in ZGAnnounceGUI_Pass_Order do
			for key, value in ZGAnnounceGUI_Pass_Order do
				if ( value == v ) and ( key ~= k ) then
					foundId = key;
					dirty = true;
					break;
				end
			end
			if ( dirty ) then
				break;
			end
		end
		if ( foundId ) then
			table.remove(ZGAnnounceGUI_Pass_Order, foundId);
			foundId = nil;
		end
		iterations = iterations + 1;
		if ( iterations > 1000 ) then
			ChatFrame1:AddMessage("ZGAnnounceGUI: Too many iterations. Breaking...");
			break;
		end
	end
end

function ZGAnnounceGUI_PassDatabase_SaveArray()
	local maxSize = table.getn(ZGAnnounceGUI_PassDatabase_CurrentArr);
	for i = maxSize, 1, -1 do
		table.remove(ZGAnnounceGUI_PassDatabase_CurrentArr, i);
	end
	for k, v in ZGAnnounceGUI_Pass_Order do
		table.insert(ZGAnnounceGUI_PassDatabase_CurrentArr, v);
	end
end

function MoveUpPass()
	for i = 2, table.getn(ZGAnnounceGUI_Pass_Order), 1 do
		if ZGAnnounceGUI_Pass_Order[i] == ZGAnnounceGUI_PassDatabase_CurrentSelection then
			local temp = ZGAnnounceGUI_Pass_Order[i - 1];
			ZGAnnounceGUI_Pass_Order[i - 1] = ZGAnnounceGUI_Pass_Order[i];
			ZGAnnounceGUI_Pass_Order[i] = temp;
			return;
		end
	end
end

function MakeFirstPass()
	for i = table.getn(ZGAnnounceGUI_Pass_Order), 2, -1 do
		if ZGAnnounceGUI_Pass_Order[i] == ZGAnnounceGUI_PassDatabase_CurrentSelection then
			local temp = ZGAnnounceGUI_Pass_Order[i - 1];
			ZGAnnounceGUI_Pass_Order[i - 1] = ZGAnnounceGUI_Pass_Order[i];
			ZGAnnounceGUI_Pass_Order[i] = temp;
		end
	end
end

function MakeLastPass()
	for i = 1,table.getn(ZGAnnounceGUI_Pass_Order) -1, 1 do
		if ZGAnnounceGUI_Pass_Order[i] == ZGAnnounceGUI_PassDatabase_CurrentSelection then
			local temp = ZGAnnounceGUI_Pass_Order[i + 1];
			ZGAnnounceGUI_Pass_Order[i + 1] = ZGAnnounceGUI_Pass_Order[i];
			ZGAnnounceGUI_Pass_Order[i] = temp;
		end
	end
end

function MoveDownPass()
	for i = 1, table.getn(ZGAnnounceGUI_Pass_Order) - 1, 1 do
		if ZGAnnounceGUI_Pass_Order[i] == ZGAnnounceGUI_PassDatabase_CurrentSelection then
			local temp = ZGAnnounceGUI_Pass_Order[i + 1];
			ZGAnnounceGUI_Pass_Order[i + 1] = ZGAnnounceGUI_Pass_Order[i];
			ZGAnnounceGUI_Pass_Order[i] = temp;
			return;
		end
	end
end

function ZGAnnounceGUI_PassDatabase_SortPass()
	table.sort(ZGAnnounceGUI_Pass_Order);
	ZGAnnounceGUI_PassDatabase_Update();
end

function ZGAnnounceGUI_PassDatabaseItemButton_OnEnter()
	DebuffName = this:GetText();
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(DebuffName,1,1,1);
end


function ZGAnnounceGUI_PassDatabase_AddPass()
	StaticPopup_Show("ZGANNOUNCE_GUI_ADD_PASS");
end

function ZGAnnounceGUI_PassDatabase_RemovePass()
	if ( not ZGAnnounceGUI_PassDatabase_CurrentSelection ) then
		return;
	end
	local maxItems = table.getn(ZGAnnounceGUI_Pass_Order);
	local foundIndex = nil;
	for k, v in pairs(ZGAnnounceGUI_Pass_Order) do
		if v == ZGAnnounceGUI_PassDatabase_CurrentSelection then
			foundIndex = k;
			break;
		end
	end
	if ( foundIndex ) then
		table.remove(ZGAnnounceGUI_Pass_Order, foundIndex);
		ZGAnnounceGUI_PassDatabase_CurrentSelection = nil;
		ZGAnnounceGUI_PassDatabase_Update();
	end
end

function ZGAnnounceGUI_PassDatabase_AddPass_Callback(name)
	local index = nil;
	if ( name ) and ( strlen(name) > 0 ) then
		index = ZGAnnounce_Command_FindItemEntry(name);
	end
	if ( index ) then
		for k, v in ZGAnnounceGUI_Pass_Order do
			if ( k == name ) then
				DEFAULT_CHAT_FRAME:AddMessage(ZGANNOUNCE_GUI_PRESENT_IN_LIST, 1, 1, 0);
				return;
			end
		end
		table.insert(ZGAnnounceGUI_Pass_Order, name);
		ZGAnnounceGUI_PassDatabase_Update();
	else
		DEFAULT_CHAT_FRAME:AddMessage(ZGANNOUNCE_UNKNOWN_ITEM_PASS, 1, 1, 0);
	end
end

StaticPopupDialogs["ZGANNOUNCE_GUI_ADD_PASS"] = {
	text = TEXT(ZGANNOUNCE_GUI_ADD_PASS_ITEM),
	button1 = TEXT(OKAY),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		ZGAnnounceGUI_PassDatabase_AddPass_Callback(getglobal(this:GetParent():GetName().."EditBox"):GetText());
	end,
	EditBoxOnEnterPressed = function()
		ZGAnnounceGUI_PassDatabase_AddPass_Callback(getglobal(this:GetParent():GetName().."EditBox"):GetText());
		getglobal(this:GetParent():GetName().."EditBox"):SetText("");
		this:GetParent():Hide();
	end,
	OnShow = function()
		getglobal(this:GetName().."EditBox"):SetFocus();
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetFocus();
		end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	hasEditBox = 1,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
};


UIPanelWindows["ZGAnnounceGUI_PassDatabaseFrame"] = { area = left; pushable = 1; whileDead = 1; };
