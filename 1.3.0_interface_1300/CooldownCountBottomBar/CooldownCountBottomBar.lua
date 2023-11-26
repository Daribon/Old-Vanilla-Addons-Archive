CooldownCountBottomBar_Saved_GenerateButtonUpdateList = nil;
CooldownCountBottomBar_BarName = "BottomBarButton";
CooldownCountBottomBar_ButtonNameFormat = "BottomBarButton%d";
CooldownCountBottomBar_NumberOfButtons = 24;
CooldownCountBottomBar_NormalBar = 0;

function CooldownCountBottomBar_OnLoad()
	if ( CooldownCountBottomBar_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountBottomBar_BarName);
	else
		CooldownCountBottomBar_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountBottomBar_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountBottomBar_GenerateButtonUpdateList()
	local updateList = CooldownCountBottomBar_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountBottomBar_NumberOfButtons do
		name = format(CooldownCountBottomBar_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
