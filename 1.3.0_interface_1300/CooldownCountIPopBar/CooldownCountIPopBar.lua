CooldownCountIPopBar_Saved_GenerateButtonUpdateList = nil;
CooldownCountIPopBar_BarName = "IPopBarButton";
CooldownCountIPopBar_ButtonNameFormat = "IPopBarButton%d";
CooldownCountIPopBar_NumberOfButtons = 22;
CooldownCountIPopBar_NormalBar = 0;

function CooldownCountIPopBar_OnLoad()
	if ( CooldownCountIPopBar_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountIPopBar_BarName);
	else
		CooldownCountIPopBar_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountIPopBar_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountIPopBar_GenerateButtonUpdateList()
	local updateList = CooldownCountIPopBar_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountIPopBar_NumberOfButtons do
		name = format(CooldownCountIPopBar_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end