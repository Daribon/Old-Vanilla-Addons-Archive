--[[

	QuestLog Level Patch
	
	by sarf
	
	Adds level of quest to the quest log, so that Smurf becomes [15] Smurf.
	
]]--

-- This can be patched runtime to provide even more fun patching.
QuestLogLevelPatch_Frames = {
	"QuestLog";
};

QuestLogLevelPatch_Options = {
	enabled = true;
};

function QuestLogLevelPatch_ShouldPatch()
	if ( this ) and ( this.GetName ) then
		local name = this:GetName();
		for k, v in QuestLogLevelPatch_Frames do
			if ( string.find(name, v) ) then
				return true;
			end
		end
	end
	return false;
end

function QuestLogLevelPatch_GetQuestLogTitle(questIndex)
	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete, a1, a2, a3, a4, a5, a6, a7, a8, a9 = QuestLogLevelPatch_Saved_GetQuestLogTitle(questIndex);
	if ( questLogTitleText ) and ( level ) and ( QuestLogLevelPatch_Options.enabled ) and ( not isHeader ) and ( level ) and ( QuestLogLevelPatch_ShouldPatch() ) then
		local formatStr = QuestLogLevelPatch_Format;
		if ( questTag ) then
			local newFormatStr = QuestLogLevelPatch_Format_Tags[questTag];
			if ( newFormatStr ) then
				formatStr = newFormatStr;
			end
		end
		questLogTitleText = string.format(formatStr, level, questLogTitleText);
	end
	return questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete, a1, a2, a3, a4, a5, a6, a7, a8, a9;
end

function QuestLogLevelPatch_OnLoad()
	QuestLogLevelPatch_Saved_GetQuestLogTitle = GetQuestLogTitle;
	GetQuestLogTitle = QuestLogLevelPatch_GetQuestLogTitle;
	
	local slashCmd = "QUESTLOGLEVELPATCH";
	SlashCmdList[slashCmd] = QuestLogLevelPatch_Slash;
	for k, v in QUESTLEVEL_CMDS do 
		setglobal("SLASH_"..slashCmd..k, v);
	end
	
	QuestLogLevelPatch_Register_Cosmos();
	QuestLogLevelPatch_Register_Khaos();
end

QuestLogLevelPatch_SetEnabled_Inside = false;

function QuestLogLevelPatch_Slash(msg)
	if ( not QuestLogLevelPatch_Options ) then
		QuestLogLevelPatch_Options = {};
	end
	if ( QuestLogLevelPatch_Options.enabled ) then
		QuestLogLevelPatch_Options.enabled = false;
	else
		QuestLogLevelPatch_Options.enabled = true;
	end
	QuestLogLevelPatch_SetEnabled(QuestLogLevelPatch_EnabledValue_Cosmos());
	ChatFrame1:AddMessage(QuestLogLevelPatch_GetEnabledTextState(QuestLogLevelPatch_Options.enabled));
end


function QuestLogLevelPatch_SetEnabled(toggle)
	if ( QuestLogLevelPatch_SetEnabled_Inside ) then
		return;
	end
	QuestLogLevelPatch_SetEnabled_Inside = true;
	if ( toggle == 1 ) then
		QuestLogLevelPatch_Options.enabled = true;
	else
		QuestLogLevelPatch_Options.enabled = false;
	end
	if ( Khaos ) then
		local setId = QUESTLEVEL_KHAOS_SET_EASY_ID;
		local key = "enabled";
		local khaosKey = Khaos.getSetKey(setId, key);
		if ( not khaosKey ) then
			Khaos.setSetKey(setId, key, {});
		end
		Khaos.setSetKeyParameter(setId, key, "checked", QuestLogLevelPatch_Options.enabled);
		if ( Khaos.updateOptionSet ) then
			Khaos.updateOptionSet(setId);
		end
	end
	if ( Cosmos_UpdateValue ) then
		local name = "COS_QUESTLEVEL_ENABLED";
		if ( ( name ) and ( strlen(name) > 0 ) ) then
			Cosmos_UpdateValue(name, CSM_CHECKONOFF, toggle);
		end
		if ( CosmosMaster_DrawData ) then
			CosmosMaster_DrawData();
		end
	end
	QuestLogLevelPatch_SetEnabled_Inside = false;
end

function QuestLogLevelPatch_EnabledValue_Cosmos()
	if ( QuestLogLevelPatch_Options.enabled ) then
		return 1;
	else
		return 0;
	end
end

function QuestLogLevelPatch_Register_Cosmos()
	if ( not Cosmos_RegisterConfiguration ) then
		return;
	end
	Cosmos_RegisterConfiguration(
		"COS_QUESTLEVEL",
		"SECTION",
		TEXT(QUESTLEVEL_CONFIG_HEADER),
		TEXT(QUESTLEVEL_CONFIG_HEADER_INFO)
	);
	Cosmos_RegisterConfiguration(
		"COS_QUESTLEVEL_HEADER",
		"SEPARATOR",
		TEXT(QUESTLEVEL_CONFIG_HEADER),
		TEXT(QUESTLEVEL_CONFIG_HEADER_INFO)
	);
	Cosmos_RegisterConfiguration(
		"COS_QUESTLEVEL_ENABLED",
		"CHECKBOX",
		TEXT(QUESTLEVEL_CONFIG_ENABLED),
		TEXT(QUESTLEVEL_CONFIG_ENABLED_INFO),
		QuestLogLevelPatch_SetEnabled,
		QuestLogLevelPatch_EnabledValue_Cosmos()
	);
end

function QuestLogLevelPatch_GetEnabledTextState(enabled)
	local s = QUESTLEVEL_KHAOS_STATE_ENABLED; 
	if ( not enabled ) then 
		s = QUESTLEVEL_KHAOS_STATE_DISABLED; 
	end 
	return QUESTLEVEL_KHAOS_STATE_TEXT.." "..s;
end

function QuestLogLevelPatch_Register_Khaos()
	if ( not Khaos ) then
		return;
	end
	local optionSetEasy = {
		id = QUESTLEVEL_KHAOS_SET_EASY_ID;
		text = QUESTLEVEL_KHAOS_EASYSET_TEXT;
		helptext = QUESTLEVEL_KHAOS_EASYSET_HELP;
		difficulty = 1;
		options = {};
		default = true;
	};
	local optionEnabled = {
		id = "questLevelCheckBoxEnabled";
		key = "enabled";
		text = QUESTLEVEL_KHAOS_ENABLED_TEXT;
		helptext = QUESTLEVEL_KHAOS_ENABLED_HELPTEXT;
		check = true;
		callback = function(state) QuestLogLevelPatch_Options.enabled = state.checked; QuestLogLevelPatch_SetEnabled(QuestLogLevelPatch_EnabledValue_Cosmos()); end;
		type = K_TEXT;
		feedback = function(state) QuestLogLevelPatch_GetEnabledTextState(state.checked); end;
		default = {
			checked = true;
		};
		disabled = {
			checked = false;
		};
	};
	table.insert(optionSetEasy.options, optionEnabled);
	Khaos.registerOptionSet( "quest", optionSetEasy);
end

function QuestLogLevelPatch_OnEvent(event)
end


