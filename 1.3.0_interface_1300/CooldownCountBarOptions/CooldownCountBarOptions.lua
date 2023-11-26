if ( CooldownCountBarOptions_BarName ) then
	CooldownCountCosmos_Present = true;
else
	CooldownCountCosmos_Present = false;
end
CooldownCountBarOptions_Saved_GenerateButtonUpdateList = nil;
CooldownCountBarOptions_BarName = "BOBonusActionButton";
CooldownCountBarOptions_ButtonNameFormat = "BOBonusActionButton%d";
CooldownCountBarOptions_NumberOfButtons = 12;
CooldownCountBarOptions_NormalBar = 1;

function CooldownCountBarOptions_OnLoad()
	if ( CooldownCountCosmos_Present ) then
		return false;
	end
	if ( CooldownCountBarOptions_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountBarOptions_BarName);
	else
		CooldownCountBarOptions_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountBarOptions_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountBarOptions_GenerateButtonUpdateList()
	local updateList = CooldownCountBarOptions_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountBarOptions_NumberOfButtons do
		name = format(CooldownCountBarOptions_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
