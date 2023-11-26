if ( CooldownCountPopBar_BarName ) then
	CooldownCountCosmos_Present = true;
else
	CooldownCountCosmos_Present = false;
end
CooldownCountPopBar_Saved_GenerateButtonUpdateList = nil;
CooldownCountPopBar_BarName = "PopBarButton";
CooldownCountPopBar_ButtonNameFormat = "PopBarButton%d%02d";
CooldownCountPopBar_NumberOfButtons = 12;
CooldownCountPopBar_NumberOfBars = 12;
CooldownCountPopBar_NormalBar = 0;

function CooldownCountPopBar_OnLoad()
	if ( CooldownCountCosmos_Present ) then
		return false;
	end
	if ( CooldownCountPopBar_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountPopBar_BarName);
	else
		CooldownCountPopBar_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountPopBar_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountPopBar_GenerateButtonUpdateList()
	local updateList = CooldownCountPopBar_Saved_GenerateButtonUpdateList();
	for bar = 1, CooldownCountPopBar_NumberOfBars do
		for i = 1, CooldownCountPopBar_NumberOfButtons do
			name = format(CooldownCountPopBar_ButtonNameFormat, bar, i);
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	return updateList;
end
