CooldownCountGypsy_Saved_GenerateButtonUpdateList = nil;
CooldownCountGypsy_BarName = "Gypsy_ActionButton";
CooldownCountGypsy_ButtonNameFormat = "Gypsy_ActionButton%d";
CooldownCountGypsy_NumberOfButtons = 17;
CooldownCountGypsy_NormalBar = 0;

function CooldownCountGypsy_OnLoad()
	if ( CooldownCountGypsy_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountGypsy_BarName);
	else
		CooldownCountGypsy_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountGypsy_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountGypsy_GenerateButtonUpdateList()
	local updateList = CooldownCountGypsy_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountGypsy_NumberOfButtons do
		name = format(CooldownCountGypsy_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
