CooldownCountGBars_Saved_GenerateButtonUpdateList = nil;
CooldownCountGBars_BarNames = { 
	"GAutoBarButton", "GActionButton", "GPetActionButton" 
	--, "GShapeshiftButton"
	};
CooldownCountGBars_NumberOfButtons = { 
	5, 30, 10 
	--, 10
	};
CooldownCountGBars_NormalBar = 0;

function CooldownCountGBars_OnLoad()
	if ( CooldownCountGBars_NormalBar == 1 ) then
		for k, v in CooldownCountGBars_BarNames do
			if ( getglobal(v.."1") ) then
				table.insert(CooldownCount_ButtonNames, v);
			end
		end
	else
		CooldownCountGBars_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountGBars_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();
end


function CooldownCountGBars_GenerateButtonUpdateList()
	local updateList = CooldownCountGBars_Saved_GenerateButtonUpdateList();
	for k, v in CooldownCountGBars_BarNames do
		for i = 1, CooldownCountGBars_NumberOfButtons[k] do
			name = format(v.."%d", i);
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	return updateList;
end
