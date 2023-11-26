CooldownCountNurfed_Saved_GenerateButtonUpdateList = nil;
CooldownCountNurfed_BarNames = { "SideBarButton", "BottomBarButton" };
CooldownCountNurfed_NumberOfButtons = { 24, 12 };
CooldownCountNurfed_NormalBar = 0;

function CooldownCountNurfed_OnLoad()
	if ( CooldownCountNurfed_NormalBar == 1 ) then
		for k, v in CooldownCountNurfed_BarNames do
			if ( getglobal(v.."1") ) then
				table.insert(CooldownCount_ButtonNames, v);
			end
		end
	else
		CooldownCountNurfed_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountNurfed_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountNurfed_GenerateButtonUpdateList()
	local updateList = CooldownCountNurfed_Saved_GenerateButtonUpdateList();
	for k, v in CooldownCountNurfed_BarNames do
		for i = 1, CooldownCountNurfed_NumberOfButtons[k] do
			name = format(v.."%d", i);
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	return updateList;
end
