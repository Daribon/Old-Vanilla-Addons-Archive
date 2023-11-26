CooldownCountGbars_Saved_GenerateButtonUpdateList = nil;
CooldownCountGbars_BarName = "GActionButtonButton";
CooldownCountGbars_ButtonNameFormat = "GActionButton%d";
CooldownCountGbars_ButtonNameFormat2 = "GAutoBarButton%d";
CooldownCountGbars_NumberOfButtons = 30;
CooldownCountGbars_NumberOfButtons2 = 5;
CooldownCountGbars_NormalBar = 0;

function CooldownCountGbars_OnLoad()
	if ( CooldownCountGbars_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountGbars_BarName);
	else
		CooldownCountGbars_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountGbars_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountGbars_GenerateButtonUpdateList()
	local updateList = CooldownCountGbars_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountGbars_NumberOfButtons do
		name = format(CooldownCountGbars_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	for i = 1, CooldownCountGbars_NumberOfButtons2 do
		name = format(CooldownCountGbars_ButtonNameFormat2, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
