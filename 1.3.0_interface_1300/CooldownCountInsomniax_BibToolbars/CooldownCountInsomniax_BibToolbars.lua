CooldownCountInsomniax_BibToolbars_Saved_GenerateButtonUpdateList = nil;
CooldownCountInsomniax_BibToolbars_BarName = "BibActionButton";
CooldownCountInsomniax_BibToolbars_ButtonNameFormat = "BibActionButton%d";
CooldownCountInsomniax_BibToolbars_NumberOfButtons = 84;
CooldownCountInsomniax_BibToolbars_NormalBar = 0;

function CooldownCountInsomniax_BibToolbars_OnLoad()
	if ( CooldownCountInsomniax_BibToolbars_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountInsomniax_BibToolbars_BarName);
	else
		CooldownCountInsomniax_BibToolbars_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountInsomniax_BibToolbars_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountInsomniax_BibToolbars_GenerateButtonUpdateList()
	local updateList = CooldownCountInsomniax_BibToolbars_Saved_GenerateButtonUpdateList();
	for i = 1, CooldownCountInsomniax_BibToolbars_NumberOfButtons do
		name = format(CooldownCountInsomniax_BibToolbars_ButtonNameFormat, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
