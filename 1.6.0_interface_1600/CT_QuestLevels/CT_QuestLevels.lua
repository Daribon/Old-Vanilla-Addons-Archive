CT_QuestLevels_ShowQuestLevels = 1;
CT_Old_QuestLog_Update = QuestLog_Update;

function CT_QuestLevels_QuestLog_Update()
	CT_Old_QuestLog_Update();
	if ( CT_QuestLevels_ShowQuestLevels == 0 ) then return; end
	local i, questLogTitle, questTitleTag, questCheck, tempWidth;
	local numEntries = GetNumQuestLogEntries();
	for i = 1, numEntries, 1 do
		local questIndex = i + FauxScrollFrame_GetOffset(QuestLogListScrollFrame);
		local useless, level, tag, isHeader, useless, isComplete = GetQuestLogTitle(questIndex);
		questLogTitle = getglobal("QuestLogTitle"..i);
		questTitleTag = getglobal("QuestLogTitle"..i.."Tag");
		questCheck = getglobal("QuestLogTitle"..i.."Check");

		if ( level and not isHeader ) then
			local title = getglobal("QuestLogTitle" .. i);
			if ( title ) then
				title:SetText(" [" .. level .. "]" .. strsub(title:GetText(),2));
			end
			if ( isComplete ) then
				tag = COMPLETE;
			end
			if ( IsQuestWatched and IsQuestWatched(questIndex) and questCheck and questLogTitle ) then
				if ( tag and questTitleTag ) then
					tempWidth = 275 - 5 - questTitleTag:GetWidth();
					questCheck:SetPoint("LEFT", questLogTitle:GetName(), "LEFT", tempWidth+24, 0);
				elseif ( QuestLogDummyText ) then
					questCheck:SetPoint("LEFT", questLogTitle:GetName(), "LEFT", QuestLogDummyText:GetWidth()+40, 0);
				end
			end
		end
	end
end

QuestLog_Update = CT_QuestLevels_QuestLog_Update;

function questlevelsfunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_QuestLevels_ShowQuestLevels = 1;
		CT_Print(CT_QUESTLEVELS_ON, 1, 1, 0);
	else
		CT_Print(CT_QUESTLEVELS_OFF, 1, 1, 0);
		CT_QuestLevels_ShowQuestLevels = 0;
	end
	CT_QuestLevels_QuestLog_Update();
end

function questlevelsinitfunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_QuestLevels_ShowQuestLevels = 1;
	else
		CT_QuestLevels_ShowQuestLevels = 0;
	end
end

CT_RegisterMod(CT_QUESTLEVELS_MODNAME, CT_QUESTLEVELS_SUBNAME, 5, "Interface\\Icons\\INV_Letter_13", CT_QUESTLEVELS_TOOLTIP, "on", nil, questlevelsfunction, questlevelsinitfunction);