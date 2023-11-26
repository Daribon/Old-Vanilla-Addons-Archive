--[[
path: /KillLog/
filename: KillLog_GeneralFrame.xml
author: Daniel Risse <dan@risse.com>
created: Mon, 17 Jan 2005 17:33:00 -0800
updated: Mon, 17 Jan 2005 17:33:00 -0800

general frame: Listing of interesting statistics
]]

KILLLOG_MAXHIT_COUNT = 10;

function KillLog_GeneralFrame_OnLoad()
	local color;
	if ( MATERIAL_TITLETEXT_COLOR_TABLE and MATERIAL_TITLETEXT_COLOR_TABLE.Parchment ) then
		color = MATERIAL_TITLETEXT_COLOR_TABLE.Parchment;
		KillLog_GeneralFrameHitTitle:SetTextColor(color[1], color[2], color[3]);
		KillLog_GeneralFrameXpTitle:SetTextColor(color[1], color[2], color[3]);
	end
	if ( MATERIAL_TEXT_COLOR_TABLE and MATERIAL_TEXT_COLOR_TABLE.Parchment ) then
		color = MATERIAL_TEXT_COLOR_TABLE.Parchment;
		local index;
		for index=1, KILLLOG_MAXHIT_COUNT, 1 do
			getglobal("KillLog_GeneralFrameHit"..index):SetTextColor(color[1], color[2], color[3]);
			getglobal("KillLog_GeneralFrameXp"..index):SetTextColor(color[1], color[2], color[3]);
		end
	end
end


function KillLog_GeneralFrame_OnShow()
	local maxHitList = { };
	table.setn(maxHitList, 0);
	if ( KillLog_AllCharacterData and KillLog_AllCharacterData["max"] ) then
		local spell, data;
		for spell, data in KillLog_AllCharacterData["max"] do
			if ( data.hit ~= 0 ) then
				table.insert(maxHitList, { name = spell.." hit", value = data.hit });
			end
			if ( data.crit ~= 0 ) then
				table.insert(maxHitList, { name = spell.." crit", value = data.crit });
			end
		end
	end

	local index, fontString;
	if ( table.getn(maxHitList) == 0 ) then
		table.insert(maxHitList, "placeholder");
		KillLog_GeneralFrameHit1:SetText(KILLLOG_LIST_UNKNOWNTYPE);
		KillLog_GeneralFrameHit1:Show();
	else
		QuickSort(maxHitList, function(a,b) if (a.value ~= b.value) then return a.value > b.value; end return a.name < b.name; end);
		if ( table.getn(maxHitList) > KILLLOG_MAXHIT_COUNT ) then
			table.setn(maxHitList, KILLLOG_MAXHIT_COUNT);
		end

		for index=1, KILLLOG_MAXHIT_COUNT, 1 do
			fontString = getglobal("KillLog_GeneralFrameHit"..index);
			if ( maxHitList[index] ) then
				fontString:SetText(maxHitList[index].name..": "..maxHitList[index].value);
				fontString:Show();
			end
		end
	end

	KillLog_GeneralFrameXpTitle:SetPoint("TOPLEFT", "KillLog_GeneralFrameHit"..table.getn(maxHitList), "BOTTOMLEFT", 0, -8);


	local xpList = { };
	local creepList = { total = 0 };
	if ( KillLog_AllCharacterData and KillLog_AllCharacterData["overall"] ) then
		table.setn(xpList, 0);
		if ( KillLog_AllCharacterData["quest xp"] ) then
			table.insert(xpList, { name = KILLLOG_LABEL_QUEST, value = 0 + KillLog_AllCharacterData["quest xp"] });
		end
		if ( KillLog_AllCharacterData["exploration xp"] ) then
			table.insert(xpList, { name = KILLLOG_LABEL_EXPLORATION, value = 0 + KillLog_AllCharacterData["exploration xp"] });
		end
		local xp, rested, group, raid = 0, 0, 0, 0;
		for creepName, data in KillLog_AllCharacterData["overall"] do
			if ( data.xp ) then
				xp = xp + data.xp;
			end
			if ( data.rested ) then
				rested = rested + data.rested;
				xp = xp - data.rested;
			end
			if ( data.group ) then
				group = group + data.group;
				xp = xp - data.group;
			end
			if ( data.raid ) then
				raid = raid + data.raid;
				xp = xp - data.raid;
			end

			if ( data.kill ) then
				creepList.total = creepList.total + data.kill;
				if ( KillLog_CreepInfo and KillLog_CreepInfo[creepName] ) then
					if ( KillLog_CreepInfo[creepName].type ) then
						if ( not creepList[ KillLog_CreepInfo[creepName].type ] ) then
							creepList[ KillLog_CreepInfo[creepName].type ] = 0;
						end
						creepList[ KillLog_CreepInfo[creepName].type ] = creepList[ KillLog_CreepInfo[creepName].type ] + data.kill;
					end
					if ( KillLog_CreepInfo[creepName].class ) then
						if ( not creepList[ KillLog_CreepInfo[creepName].class ] ) then
							creepList[ KillLog_CreepInfo[creepName].class ] = 0;
						end
						creepList[ KillLog_CreepInfo[creepName].class ] = creepList[ KillLog_CreepInfo[creepName].class ] + data.kill;
					end
				end
			end
		end
		if ( xp ~= 0 ) then
			table.insert(xpList, { name = KILLLOG_LABEL_CREEP_XP, value = xp });
		end
		if ( rested ~= 0 ) then
			table.insert(xpList, { name = KILLLOG_LABEL_RESTED, value = rested });
		end
		if ( group ~= 0 ) then
			table.insert(xpList, { name = KILLLOG_LABEL_GROUP, value = group });
		end
		if ( raid ~= 0 ) then
			table.insert(xpList, { name = KILLLOG_LABEL_RAID, value = raid });
		end
	end

	if ( table.getn(xpList) == 0 ) then
		table.insert(xpList, "placeholder");
		KillLog_GeneralFrameXp1:SetText(KILLLOG_LIST_UNKNOWNTYPE);
		KillLog_GeneralFrameXp1:Show();
	else
		QuickSort(xpList, function(a,b) if (a.value ~= b.value) then return a.value > b.value; end return a.name < b.name; end);
		if ( table.getn(xpList) > KILLLOG_MAXHIT_COUNT ) then
			table.setn(xpList, KILLLOG_MAXHIT_COUNT);
		end

		for index=1, KILLLOG_MAXHIT_COUNT, 1 do
			fontString = getglobal("KillLog_GeneralFrameXp"..index);
			if ( xpList[index] ) then
				fontString:SetText(xpList[index].name..": "..xpList[index].value);
				fontString:Show();
			end
		end
	end

	KillLog_GeneralFrameCreepTitle:SetPoint("TOPLEFT", "KillLog_GeneralFrameXp"..table.getn(xpList), "BOTTOMLEFT", 0, -4);


	KillLog_GeneralFrameCreepTitle:Hide();
	if ( creepList.total == 0 ) then
	else
	end
end
