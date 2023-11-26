CT_BagNames = { { } };
RegisterForSave("CT_BagNames");
function CT_GetNextCID()
	for i=1, 5, 1 do
		if (not getglobal("ContainerFrame" .. i):IsVisible()) then
			return i;
		end
	end
	return 5;
end

function CT_GetBagID(container)
	if ( not container ) then return nil; end
	return getglobal("ContainerFrame" .. container):GetID();
end

function CT_CCFrame_ToggleEditBox()
	if ( getglobal(this:GetParent():GetName() .. "EBFrame"):IsVisible() ~= 1 ) then
		getglobal(this:GetParent():GetName() .. "EBFrame"):Show();
	else
		CT_SaveEditBox(getglobal(this:GetParent():GetName() .. "EBFrameEditBox"), this:GetParent():GetID()+1);
		getglobal(this:GetParent():GetName() .. "EBFrame"):Hide();
	end
end

function CT_SaveEditBox(box, id)
	local text = box:GetText();
	if ( not text or strlen(text) == 0 ) then 
		text = "";
	end
	box:SetText("");
	CT_BagNames[UnitName("player")][CT_GetBagID(id)] = text;
	if ( text == "" ) then
		getglobal("ContainerFrame" .. id .. "Name"):SetText(GetBagName(CT_GetBagID(id)));
	else
		getglobal("ContainerFrame" .. id .. "Name"):SetText(text);
	end
end

function CT_CCEditBox_OnEnterPressed()
	CT_SaveEditBox(this, this:GetParent():GetParent():GetID()+1);
end

function CT_CCEditBox_OnEscapePressed()
	if ( CT_BagNames[UnitName("player")][CT_GetBagID(this:GetParent():GetParent():GetID()+1)] and strlen(CT_BagNames[UnitName("player")][CT_GetBagID(this:GetParent():GetParent():GetID()+1)]) > 0 and CT_BagNames[UnitName("player")][CT_GetBagID(this:GetParent():GetParent():GetID()+1)] ~= GetBagName(CT_GetBagID(this:GetParent():GetParent():GetID()+1)) ) then
		getglobal("ContainerFrame" .. this:GetParent():GetParent():GetID()+1 .. "Name"):SetText(CT_BagNames[UnitName("player")][CT_GetBagID(this:GetParent():GetParent():GetID()+1)]);
	else
		getglobal("ContainerFrame" .. this:GetParent():GetParent():GetID()+1 .. "Name"):SetText(GetBagName(CT_GetBagID(this:GetParent():GetParent():GetID()+1)));
	end
	this:SetText("");
	if ( this:GetParent():IsVisible() == 1 ) then
		this:GetParent():Hide();
	end
end

function CT_CCFrame_OnShow()
	if ( CT_BagNames[UnitName("player")] and CT_BagNames[UnitName("player")][CT_GetBagID(this:GetParent():GetID()+1)] and strlen(CT_BagNames[UnitName("player")][CT_GetBagID(this:GetParent():GetID()+1)]) > 0 ) then
		getglobal("ContainerFrame" .. this:GetParent():GetID()+1 .. "Name"):SetText(CT_BagNames[UnitName("player")][CT_GetBagID(this:GetParent():GetID()+1)]);
	else
		getglobal("ContainerFrame" .. this:GetParent():GetID()+1 .. "Name"):SetText(GetBagName(CT_GetBagID(this:GetParent():GetID()+1)));
	end
end

function CT_CCItemSlotButton_OnLoad()
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("CURSOR_UPDATE");
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
	this:RegisterEvent("SHOW_COMPARE_TOOLTIP");
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function CT_CCSlotButton_OnClick()
	local isVisible = 0;
	local container;
	local button;
	if ( this:GetID() >= 1 ) then
		button = getglobal("CharacterBag" .. this:GetID()-1 .. "Slot")

		local id = button:GetID();
		local translatedID = id - CharacterBag0Slot:GetID() + 1;
		local hadItem = PutItemInBag(id);
		if ( not hadItem ) then
			ToggleBag(translatedID);
			PlaySound("BAGMENUBUTTONPRESS");
		end
		for i=1, NUM_CONTAINER_FRAMES, 1 do
			local frame = getglobal("ContainerFrame"..i);
			if (frame:GetID() == translatedID) then
				container = i;
				if ( frame:IsVisible() ) then
					isVisible = 1;
					break;
				end
			end
		end
		button:SetChecked(isVisible);

	else
		if ( not PutItemInBackpack() ) then
			ToggleBackpack();
			
			for i=1, NUM_CONTAINER_FRAMES, 1 do
				local frame = getglobal("ContainerFrame"..i);
				if (frame:GetID() == 0) then
					container = i;
					if ( frame:IsVisible() ) then
						isVisible = 1;
						break;
					end
				end
			end
			getglobal("MainMenuBarBackpackButton"):SetChecked(isVisible);
			
		end
	end
	local newCID = container;
	for z=0, 4, 1 do
		local glb = getglobal("CT_CCB" .. z .. "Button");
		if ( glb and glb.CID == newCID ) then
			glb.CID = this.CID;
			this.CID = newCID;
			getglobal("ContainerFrame" .. glb.CID):SetID(glb:GetID());
		end
	end
end

function CT_CCSlotButton_OnDrag()
	local button;
	if ( this:GetID() ~= 0 ) then
		button = getglobal("CharacterBag" .. this:GetID()-1 .. "Slot")
	else
		return;
	end
	local translatedID = button:GetID() - CharacterBag0Slot:GetID() + 1;
	PickupBagFromSlot(button:GetID());
	PlaySound("BAGMENUBUTTONPRESS");
	local isVisible = 0;
	for i=1, NUM_CONTAINER_FRAMES, 1 do
		local frame = getglobal("ContainerFrame"..i);
		if ( (frame:GetID() == translatedID) and frame:IsVisible() ) then
			isVisible = 1;
			break;
		end
	end
	button:SetChecked(isVisible);
end

function CT_CCFrame_OnEnter()
 	
	local bagid = CT_GetBagID(this:GetParent():GetID()+1);
	local cid = this:GetParent():GetID()+1;
	local settext;
	if ( not CT_BagNames[UnitName("player")] or not CT_BagNames[UnitName("player")][bagid] or CT_BagNames[UnitName("player")][bagid] == "" ) then
		settext = GetBagName(bagid);
	else
		settext = CT_BagNames[UnitName("player")][bagid];
	end
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	
	if ( bagid and bagid == 0 ) then
		GameTooltip:SetText(settext, 1.0, 1.0, 1.0);
		if (GetBindingKey("TOGGLEBACKPACK")) then
			GameTooltip:AppendText(" "..NORMAL_FONT_COLOR_CODE.."("..GetBindingKey("TOGGLEBACKPACK")..")"..FONT_COLOR_CODE_CLOSE)
		end

	elseif ( bagid and bagid > 0 and ContainerIDToInventoryID(bagid) and GameTooltip:SetInventoryItem("player", ContainerIDToInventoryID(bagid)) ) then
		getglobal("GameTooltipTextLeft1"):SetText(settext);
		local binding = GetBindingKey("TOGGLEBAG"..(5 - bagid));
		if ( binding ) then
			GameTooltip:AppendText(" "..NORMAL_FONT_COLOR_CODE.."("..binding..")"..FONT_COLOR_CODE_CLOSE);
		end 
	end
	
end

function CT_CCButton_OnEnter()
	local bagid = this:GetID();
	local settext;
	if ( not CT_BagNames[UnitName("player")][bagid] or CT_BagNames[UnitName("player")][bagid] == "" ) then
		settext = GetBagName(bagid);
	else
		settext = CT_BagNames[UnitName("player")][bagid];
	end
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	if ( bagid == 0 ) then
		GameTooltip:SetText(settext, 1.0, 1.0, 1.0);
		if (GetBindingKey("TOGGLEBACKPACK")) then
			GameTooltip:AppendText(" "..NORMAL_FONT_COLOR_CODE.."("..GetBindingKey("TOGGLEBACKPACK")..")"..FONT_COLOR_CODE_CLOSE)
		end
	elseif ( GameTooltip:SetInventoryItem("player", ContainerIDToInventoryID(bagid)) ) then
		getglobal("GameTooltipTextLeft1"):SetText(settext);
		local binding = GetBindingKey("TOGGLEBAG"..(5 - bagid));
		if ( binding ) then
			GameTooltip:AppendText(" "..NORMAL_FONT_COLOR_CODE.."("..binding..")"..FONT_COLOR_CODE_CLOSE);
		end 
	else
		GameTooltip:SetText(TEXT(EQUIP_CONTAINER), 1.0, 1.0, 1.0);
	end
end

function CT_CCGlobalFrame_OnUpdate()
	if ( UnitName("player") and not CT_BagNames[UnitName("player")] ) then
		CT_BagNames[UnitName("player")] = { };
	end
end