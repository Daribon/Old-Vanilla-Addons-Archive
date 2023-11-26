CooldownCountSecondBar_Saved_GenerateButtonUpdateList = nil;
CooldownCountSecondBar_BarName = "SecondActionButton";
CooldownCountSecondBar_ButtonNameFormat = "SecondActionButton%d";
CooldownCountSecondBar_NumberOfButtons = 12;
CooldownCountSecondBar_NormalBar = 1;

function CooldownCountSecondBar_OnLoad()
	if ( CooldownCountSecondBar_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountSecondBar_BarName);
	else
		CooldownCountSecondBar_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountSecondBar_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountSecondBar_GenerateButtonUpdateList()
	local updateList = CooldownCountSecondBar_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountSecondBar_NumberOfButtons do
		name = format(CooldownCountSecondBar_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
