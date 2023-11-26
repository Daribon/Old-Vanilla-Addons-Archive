function BagGauge_Update()
  local slots, usedSlots, availableSlots;
	
	slots = 0;
	usedSlots = 0;
	for bag = 0, 4 do
		if (not IsAmmoPouch(GetBagName(bag))) then	
			local size = GetContainerNumSlots(bag);
			if (size and size > 0) then
				slots = slots + size;
				for slot = 1, size do
					if (GetContainerItemInfo(bag, slot)) then
						usedSlots = usedSlots + 1;
					end
				end
			end
		end
	end


	if(slots == 0) then 
		return;
	end
	
	percent = (usedSlots/slots);

	if(percent < 0.5) then
		green = 1 - (percent / 2);
		red = (percent * 1.5);
	else
		green = 0.75 - ((percent - 0.5) * 1.5)
		red = 0.75 + ((percent - 0.5) / 2);
	end

	this:SetMinMaxValues(0, slots);		
	this:SetValue(usedSlots);
	this:SetStatusBarColor(red, green, 0.0, 0.75);

	if(red ~= 1.0) then
		BagGaugeLabel:SetText(usedSlots .. "/" .. slots .. USED_SLOTS_STRING);
	else
		BagGaugeLabel:SetText(FULL_BAG_STRING);
	end
end

function BagGauge_OnEvent(event)
	if ( event == "BAG_UPDATE" ) then
  	BagGauge_Update();
  elseif ( event == "ITEM_LOCK_CHANGED" or event == "BAG_UPDATE_COOLDOWN" or event == "UPDATE_INVENTORY_ALERTS" or event == "UNIT_MODEL_CHANGED") then
 	BagGauge_Update();
  end
end

function BagGauge_OnClick()
--TODO: Toggle something or other.
end

function BagGauge_OnLoad()
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("UNIT_MODEL_CHANGED");
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	
	this:SetValue(0);
	BagGaugeLabel:SetText("Uninitialized.");
end

function IsAmmoPouch(name)	
	if (name) then
		for index, value in AMMO_POUCH_NAMES do
			if (string.find(name, value)) then
				return true;
			end
		end
	end
	return false;
end