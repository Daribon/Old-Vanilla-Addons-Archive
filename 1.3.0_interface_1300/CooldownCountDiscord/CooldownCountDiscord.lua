CooldownCountDiscord_Saved_GenerateButtonUpdateList = nil;
CooldownCountDiscord_BarNames = { "ActionButton" };
CooldownCountDiscord_StartButton = 13;
CooldownCountDiscord_NumberOfButtons = 120;
CooldownCountDiscord_NormalBar = 0;

function CooldownCountDiscord_OnLoad()
	if ( CooldownCountDiscord_NormalBar == 1 ) then
		for k, v in CooldownCountDiscord_BarNames do
			if ( getglobal(v.."1") ) then
				table.insert(CooldownCount_ButtonNames, v);
			end
		end
	else
		CooldownCountDiscord_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountDiscord_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountDiscord_GenerateButtonUpdateList()
	local updateList = CooldownCountDiscord_Saved_GenerateButtonUpdateList();
	local buttonName = "ActionButton";
	for i = CooldownCountDiscord_StartButton, CooldownCountDiscord_NumberOfButtons do
		name = format(buttonName.."%d", i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end
