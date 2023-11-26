CooldownCountAutoTrinketBar_Saved_GenerateButtonUpdateList = nil;
CooldownCountAutoTrinketBar_BarNames = { "AutoTrinketBar_Button" };
CooldownCountAutoTrinketBar_NumberOfButtons = 2;
CooldownCountAutoTrinketBar_NormalBar = 0;

function CooldownCountAutoTrinketBar_OnLoad()
	if ( CooldownCountAutoTrinketBar_NormalBar == 1 ) then
		for k, v in CooldownCountAutoTrinketBar_BarNames do
			if ( getglobal(v.."1") ) then
				table.insert(CooldownCount_ButtonNames, v);
			end
		end
	else
		CooldownCountAutoTrinketBar_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountAutoTrinketBar_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountAutoTrinketBar_GenerateButtonUpdateList()
	local updateList = CooldownCountAutoTrinketBar_Saved_GenerateButtonUpdateList();
	for k, v in CooldownCountAutoTrinketBar_BarNames do
		for i = 1, CooldownCountAutoTrinketBar_NumberOfButtons do
			name = format(v.."%d", i);
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	return updateList;
end
