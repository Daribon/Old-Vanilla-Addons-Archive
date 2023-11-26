CooldownCountBibToolbars_Saved_GenerateButtonUpdateList = nil;
CooldownCountBibToolbars_BarName = "BibActionButton";
CooldownCountBibToolbars_ButtonNameFormat = "BibActionButton%d";
CooldownCountBibToolbars_NumberOfButtons = 84;
CooldownCountBibToolbars_NormalBar = 0;

function CooldownCountBibToolbars_OnLoad()
	if ( CooldownCountBibToolbars_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountBibToolbars_BarName);
	else
		CooldownCountBibToolbars_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountBibToolbars_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountBibToolbars_GenerateButtonUpdateList()
	local updateList = CooldownCountBibToolbars_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountBibToolbars_NumberOfButtons do
		name = format(CooldownCountBibToolbars_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
