CooldownCountAutoBar_Saved_GenerateButtonUpdateList = nil;
CooldownCountAutoBar_BarNames = { "AutoBar_MainMenu_Button", "AutoBar_Normal_Button" };
CooldownCountAutoBar_NumberOfButtons = 12;
CooldownCountAutoBar_NormalBar = 1;

function CooldownCountAutoBar_OnLoad()
	if ( CooldownCountAutoBar_NormalBar == 1 ) then
		for k, v in CooldownCountAutoBar_BarNames do
			if ( getglobal(v.."1") ) then
				table.insert(CooldownCount_ButtonNames, v);
			end
		end
	else
		CooldownCountAutoBar_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountAutoBar_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountAutoBar_GenerateButtonUpdateList()
	local updateList = CooldownCountAutoBar_Saved_GenerateButtonUpdateList();
	for k, v in CooldownCountAutoBar_BarNames do
		for i = 1, CooldownCountAutoBar_NumberOfButtons do
			name = format(v.."%d", i);
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	return updateList;
end
