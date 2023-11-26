CooldownCountMyInventory_Saved_GenerateButtonUpdateList = nil;
CooldownCountMyInventory_BarName = "MyInventoryFrameItem";
CooldownCountMyInventory_ButtonNameFormat = "MyInventoryFrameItem%d";
CooldownCountMyInventory_NumberOfButtons = 109;
CooldownCountMyInventory_NormalBar = 0;

function CooldownCountMyInventory_OnLoad()
	if ( CooldownCountMyInventory_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountMyInventory_BarName);
	else
		CooldownCountMyInventory_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountMyInventory_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountMyInventory_GenerateButtonUpdateList()
	local updateList = CooldownCountMyInventory_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountMyInventory_NumberOfButtons do
		name = format(CooldownCountMyInventory_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end