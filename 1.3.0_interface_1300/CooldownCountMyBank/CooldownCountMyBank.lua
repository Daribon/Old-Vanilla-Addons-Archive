CooldownCountMyBank_Saved_GenerateButtonUpdateList = nil;
CooldownCountMyBank_BarName = "MyBankFrameItem";
CooldownCountMyBank_ButtonNameFormat = "MyBankFrameItem%d";
CooldownCountMyBank_NumberOfButtons = 132;
CooldownCountMyBank_NormalBar = 0;

function CooldownCountMyBank_OnLoad()
	if ( CooldownCountMyBank_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountMyBank_BarName);
	else
		CooldownCountMyBank_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountMyBank_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountMyBank_GenerateButtonUpdateList()
	local updateList = CooldownCountMyBank_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountMyBank_NumberOfButtons do
		name = format(CooldownCountMyBank_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end