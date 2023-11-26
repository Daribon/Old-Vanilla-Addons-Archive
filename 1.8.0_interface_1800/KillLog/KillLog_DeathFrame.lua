--[[
path: /KillLog/
filename: KillLog_DeathFrame.lua
author: Daniel Risse <dan@risse.com>
created: Mon, 17 Jan 2005 17:33:00 -0800
updated: Mon, 17 Jan 2005 17:33:00 -0800

death frame: Listing of your deaths
]]

function KillLog_DeathFrame_OnLoad()
	local color;
	if ( MATERIAL_TITLETEXT_COLOR_TABLE and MATERIAL_TITLETEXT_COLOR_TABLE.Stone ) then
		color = MATERIAL_TITLETEXT_COLOR_TABLE.Stone;
		KillLog_DeathFrameMainTitle:SetTextColor(color[1], color[2], color[3]);
	end
	if ( MATERIAL_TEXT_COLOR_TABLE and MATERIAL_TEXT_COLOR_TABLE.Stone ) then
		color = MATERIAL_TEXT_COLOR_TABLE.Stone;
		KillLog_DeathFrameMainData:SetTextColor(color[1], color[2], color[3]);
	end
end


function KillLog_DeathFrame_OnShow()
	if ( not KillLog_AllCharacterData or not KillLog_AllCharacterData["death"] or table.getn(KillLog_AllCharacterData["death"]) == 0 ) then
		KillLog_DeathFrameMainData:SetText(KILLLOG_NOT_AVAILABLE);
	else
		local index;
		local deathLog = "";
		for index=table.getn(KillLog_AllCharacterData["death"]), 1, -1 do
			deathLog = deathLog..format(KILLLOG_DEATH_FORMAT, KillLog_AllCharacterData["death"][index].time, KillLog_AllCharacterData["death"][index].creepName, KillLog_AllCharacterData["death"][index].level);
		end
		KillLog_DeathFrameMainData:SetText(deathLog);
	end
end
