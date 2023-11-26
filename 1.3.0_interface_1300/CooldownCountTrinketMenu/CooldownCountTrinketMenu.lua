CooldownCountTrinketMenu_Saved_GenerateButtonUpdateList = nil;
CooldownCountTrinketMenu_BarNames = { "TrinketMenuInv", "TrinketMenuEquipped" };
CooldownCountTrinketMenu_NumberOfButtons = { 12, 2 };
CooldownCountTrinketMenu_NormalBar = 0;

function CooldownCountTrinketMenu_OnLoad()
	if ( CooldownCountTrinketMenu_NormalBar == 1 ) then
		for k, v in CooldownCountTrinketMenu_BarNames do
			if ( getglobal(v.."1") ) then
				table.insert(CooldownCount_ButtonNames, v);
			end
		end
	else
		CooldownCountTrinketMenu_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountTrinketMenu_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountTrinketMenu_GenerateButtonUpdateList()
	local updateList = CooldownCountTrinketMenu_Saved_GenerateButtonUpdateList();
	for k, v in CooldownCountTrinketMenu_BarNames do
		for i = 1, CooldownCountTrinketMenu_NumberOfButtons[k] do
			name = format(v.."%d", i);
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	return updateList;
end
