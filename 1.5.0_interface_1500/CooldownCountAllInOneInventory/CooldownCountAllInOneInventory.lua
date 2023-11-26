CooldownCountAllInOneInventory_Saved_GenerateButtonUpdateList = nil;
CooldownCountAllInOneInventory_BarName = "AllInOneInventoryFrameItem";
CooldownCountAllInOneInventory_NumberOfButtons = 109;
CooldownCountAllInOneInventory_NormalBar = 0;
CooldownCountAllInOneInventory_ButtonUpdateList = {};

function CooldownCountAllInOneInventory_OnLoad()
	if ( CooldownCountAllInOneInventory_NormalBar == 1 ) then
		if ( getglobal(CooldownCountAllInOneInventory_BarName.."1") ) then
			table.insert(CooldownCount_ButtonNames, CooldownCountAllInOneInventory_BarName);
		end
	else
		CooldownCountAllInOneInventory_GenerateList();
		CooldownCountAllInOneInventory_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountAllInOneInventory_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
end

function CooldownCountAllInOneInventory_GenerateList()
	local barName = CooldownCountAllInOneInventory_BarName;
	for i = 1, CooldownCountAllInOneInventory_NumberOfButtons do
		name = barName..i;
		if ( getglobal(name) ) then
			table.insert(CooldownCountAllInOneInventory_ButtonUpdateList, name);
		end
	end
end

function CooldownCountAllInOneInventory_DoUpdate(force)
	if ( not CooldownCountAllInOneInventory_ButtonUpdateList ) then
		CooldownCount_DoUpdate(force);
	else
		for k, v in CooldownCountAllInOneInventory_ButtonUpdateList do
			CooldownCount_DoUpdateCooldownCount(v, force);
		end
	end
end

function CooldownCountAllInOneInventory_OnEvent()
	if ( event == "BAG_UPDATE_COOLDOWN" ) then
		CooldownCountAllInOneInventory_DoUpdate();
		return;
	end
end


function CooldownCountAllInOneInventory_GenerateButtonUpdateList()
	local updateList = CooldownCountAllInOneInventory_Saved_GenerateButtonUpdateList();
	for k, v in CooldownCountAllInOneInventory_ButtonUpdateList do
		table.insert(updateList, v);
	end
	return updateList;
end
