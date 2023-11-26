-- the time that is allowed to elapse from automatic dismount to remount. set to nil / 0 to disable this check.
MOUNTGATHERER_TIMEOUT = 15;

-- how much time to allow the user to loot
MOUNTGATHERER_TIME_TO_LOOT = 1;

-- how much time to allow the user to loot when using a "multiple" gathering skill (i.e. Mining).
MOUNTGATHERER_TIME_TO_LOOT_MULTIPLE = 3;

-- time between updates
MOUNTGATHERER_TIME_BETWEEN_UPDATES = 0.1;

MOUNTGATHERER_MAILBOXTIMEOUT = 0.5;

MOUNTGATHERER_MODE_DOMOUNT = 1;
MOUNTGATHERER_MODE_DOMAILBOXCHECK = 2;



MountGatherer_ShouldMountAt = nil;

MountGatherer_Saved_GameTooltip_Show = nil;
MountGatherer_Saved_GameTooltip_OnHide = nil;
MountGatherer_LastShownTooltip = nil;
MountGatherer_TooltipStrings = {};

MountGatherer_HandledItem = nil;
MountGatherer_LastDismount = nil;
MountGatherer_HasMining = false;
MountGatherer_HasHerbalism = false;
MountGatherer_HasSkinning = false;
MountGatherer_LastMailboxHidden = nil;

MountGatherer_Options = {
	["handleGathering"] = true,
	["handleMailbox"] = true,
	["remountWhenClosingMailbox"] = true,
	["remountWithMailboxOpen"] = true,
};


function MountGatherer_OnLoad()
	MountGatherer_Saved_GameTooltip_Show = GameTooltip.Show;
	GameTooltip.Show = MountGatherer_GameTooltip_Show;
	MountGatherer_Saved_GameTooltip_OnHide = GameTooltip_OnHide;
	GameTooltip_OnHide = MountGatherer_GameTooltip_OnHide;

	local f = MountGathererFrame;
	f:RegisterEvent("VARIABLES_LOADED");
	f:RegisterEvent("SPELLS_CHANGED");
	f:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	f:RegisterEvent("UI_ERROR_MESSAGE");
	f:RegisterEvent("MAIL_SHOW");
	f:RegisterEvent("MAIL_CLOSED");
end

function MountGatherer_TurnOrAction(state)
	if ( MountGatherer_Options.handleMailbox ) then
		local mountBuffPos = AutoMount_GetMountBuffPosition();
		if ( mountBuffPos > -1 ) then
			local mountBuffPos = AutoMount_GetMountBuffPosition();
			if ( mountBuffPos > -1 ) then
				if ( MountGatherer_TooltipStrings[1] == MountGatherer_DismountableStringsMailbox ) then
					MountGatherer_HandledItem = MountGatherer_DismountableStringsMailbox;
					CancelPlayerBuff(mountBuffPos);
					MountGatherer_LastDismount = curTime;
				end
			end
		end
	end
	MountGatherer_TurnOrAction(state);
end

function MountGatherer_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		MountGatherer_SetupGatheringSkills();
		MountGathererFrame:UnregisterEvent(event);
	end
	if ( event == "SPELLS_CHANGED" ) then
		MountGatherer_SetupGatheringSkills();
	end
	if ( event == "CHAT_MSG_SPELL_SELF_BUFF" ) then
		MountGatherer_HandlePerformChat(arg1);
	end
	if ( event == "MAIL_CLOSED" ) then
		if ( MountGatherer_Options.handleMailbox ) then
			if ( MountGatherer_Options.remountWhenClosingMailbox ) then
				if ( not MailFrame:IsVisible() ) then
					local mountBuffPos = AutoMount_GetMountBuffPosition();
					if ( mountBuffPos <= -1 ) then
						MountGatherer_Mount();
					end
				end
			end
		end
	end
	if ( event == "MAIL_SHOW" ) then
		if ( MountGatherer_Options.handleMailbox ) then
			if ( MountGatherer_Options.remountWithMailboxOpen ) then
				local mountBuffPos = AutoMount_GetMountBuffPosition();
				if ( mountBuffPos <= -1 ) then
					MountGatherer_Mount();
				end
			end
		end
	end
	if ( event == "UI_ERROR_MESSAGE" ) then
		if ( arg1 == SPELL_FAILED_NOT_MOUNTED ) then
			if ( not UnitOnTaxi("player") ) then
				MountGatherer_FixMount();
			end
		end
	end
end

MountGatherer_TooltipTextLeftNames = {
	[1] = "GameTooltipTextLeft1",
	[2] = "GameTooltipTextLeft2",
	[3] = "GameTooltipTextLeft3",
	[4] = "GameTooltipTextLeft4",
};

function MountGatherer_GameTooltip_Show(tooltip)
	if ( tooltip == GameTooltip ) then
		local curTime = GetTime();
		local obj = nil;
		local oldFirst = MountGatherer_TooltipStrings[1];
		for k, v in MountGatherer_TooltipTextLeftNames do
			obj = getglobal(v);
			if ( obj ) then
				MountGatherer_TooltipStrings[k] = obj:GetText();
			end
		end
		MountGatherer_LastShownTooltip = curTime;
	end
	MountGatherer_Saved_GameTooltip_Show(tooltip);
end

MountGatherer_GameTooltip_OnHide_OldText = nil;

function MountGatherer_GameTooltip_OnHide(tooltip)
	if ( MailFrame:IsVisible() ) then
		MountGatherer_LastMailboxHidden = nil;
	elseif ( ( not tooltip ) or ( tooltip == GameTooltip ) ) then
		local curTime = GetTime();
		local newvalue = nil;
		local obj = getglobal(MountGatherer_TooltipTextLeftNames[1]);
		if ( obj ) then
			local oldFirst = obj:GetText();
			if ( oldFirst ) and ( oldFirst == MountGatherer_DismountableStringsMailbox ) and ( oldFirst == MountGatherer_GameTooltip_OnHide_OldText ) then 
				newvalue = curTime;
			end
			MountGatherer_GameTooltip_OnHide_OldText = oldFirst;
		end
		MountGatherer_LastMailboxHidden = newvalue;
		if ( newvalue ) then
			MountGatherer_SetMode(MOUNTGATHERER_MODE_DOMAILBOXCHECK);
		end
	end
	MountGatherer_Saved_GameTooltip_OnHide(tooltip);
end

function MountGatherer_HandlePerformed(action)
	if ( not action ) then
		return false;
	end
	local ok = false;
	for k, v in MountGatherer_Chat_SkillNames do
		if ( v == action ) then
			ok = true;
		end
	end
	if ( not ok ) then
		return false;
	end
	if ( MOUNTGATHERER_TIMEOUT ) and ( MOUNTGATHERER_TIMEOUT > 0 ) then
		if ( not MountGatherer_LastDismount ) or ( GetTime() - MountGatherer_LastDismount > MOUNTGATHERER_TIMEOUT ) then
			return false;
		end
	end
	
	-- fix for mining
	local addTime = MOUNTGATHERER_TIME_TO_LOOT;
	for k, v in MountGatherer_SkillNames_Multiple do
		if ( v == action ) then
			addTime = MOUNTGATHERER_TIME_TO_LOOT_MULTIPLE;
			break;
		end
	end
	MountGatherer_LastDismount = MountGatherer_LastDismount + addTime;
	MountGatherer_ShouldMountAt = GetTime() + addTime;
	MountGatherer_SetMode(MOUNTGATHERER_MODE_DOMOUNT);
	return true;
end

function MountGatherer_HandlePerformChat(msg)
	if ( not MountGatherer_Options.handleGathering ) then
		return false;
	end
	local pattern = nil;
	local index = nil;
	for k, v in MountGatherer_Chat_PerformPatterns do
		pattern = v.pattern;
		index = v.actionIndex;
		for p1, p2, p3 in string.gfind(msg, pattern) do
			if ( index == 1 ) then
				MountGatherer_HandlePerformed(p1);
			elseif ( index == 2 ) then
				MountGatherer_HandlePerformed(p2);
			elseif ( index == 3 ) then
				MountGatherer_HandlePerformed(p3);
			end
		end
	end
end


function MountGatherer_SetupGatheringSkills()
	local spellName = nil;
	MountGatherer_HasMining = false;
	MountGatherer_HasHerbalism = false;
	MountGatherer_HasSkinning = false;
	for i = 1, 150 do
		spellName = GetSpellName(i, "spell");
		if ( not spellName ) then
			break;
		end
		if ( spellName == MountGatherer_Skill_Mining ) then
			MountGatherer_HasMining = true;
		end
		if ( spellName == MountGatherer_Skill_Herbalism ) then
			MountGatherer_HasHerbalism = true;
		end
		if ( spellName == MountGatherer_Skill_Skinning ) then
			MountGatherer_HasSkinning = true;
		end
	end
	MountGatherer_SetupDismountableStrings();
end

function MountGatherer_SetupDismountableStrings()
	MountGatherer_DismountableStrings = {};
	if ( MountGatherer_HasMining ) then
		for k, v in MountGatherer_DismountableStringsMining do
			table.insert(MountGatherer_DismountableStrings, v);
		end
	end
	if ( MountGatherer_HasHerbalism ) then
		for k, v in MountGatherer_DismountableStringsHerbalism do
			table.insert(MountGatherer_DismountableStrings, v);
		end
	end
	for k, v in MountGatherer_DismountableStringsOther do
		table.insert(MountGatherer_DismountableStrings, v);
	end
end

function MountGatherer_FixMount()
	if ( UnitOnTaxi("player") ) then
		return false;
	end
	local curTime = GetTime();
	if ( not MountGatherer_LastShownTooltip ) or ( curTime - MountGatherer_LastShownTooltip > 1 ) then
		return false;
	end
	MountGatherer_LastShownTooltip = nil;
	return MountGatherer_Dismount();
end

function MountGatherer_Dismount()
	if ( UnitOnTaxi("player") ) then
		return false;
	end
	local mountBuffPos = AutoMount_GetMountBuffPosition();
	if ( mountBuffPos > -1 ) then
		local obj = nil;
		if ( MountGatherer_HasSkinning ) then
			local msg = nil;
			for i = 3, 4 do
				msg = MountGatherer_TooltipStrings[i];
				if ( msg ) and ( strlen(msg) > 0 ) then
					for k, v in MountGatherer_DismountableStringsSkinning do
						MountGatherer_HandledItem = v;
						CancelPlayerBuff(mountBuffPos);
						MountGatherer_LastDismount = GetTime();
						return true;
					end
				end
			end
		end
		local msg = MountGatherer_TooltipStrings[1];
		if ( msg ) and ( strlen(msg) > 0 ) then
			for k, v in MountGatherer_DismountableStrings do
				if ( string.find(msg, v) ) then
					MountGatherer_HandledItem = v;
					CancelPlayerBuff(mountBuffPos);
					MountGatherer_LastDismount = GetTime();
					return true;
				end
			end
		end
	end
	return false;
end

function MountGatherer_Mount()
	if ( PlayerFrame.inCombat ) then
		return false;
	end
	local bag, slot = AutoMount_GetMountItemBagSlot();
	if ( not bag ) or ( not slot ) then
		return false;
	end
	UseContainerItem(bag, slot);
	return true;
end

MountGatherer_Mode = 0;
MountGatherer_LastUpdate = 0;

function MountGatherer_SetMode(mode)
	MountGatherer_Mode = mode;
	if ( mode <= 0 ) then
		MountGathererFrame:Hide();
	else
		MountGathererFrame:Show();
	end
end

function MountGatherer_OnUpdate(arg1)
	local curTime = GetTime();
	local diff = curTime - MountGatherer_LastUpdate;
	if ( diff < MOUNTGATHERER_TIME_BETWEEN_UPDATES ) then
		return false;
	end
	MountGatherer_LastUpdate = curTime;
	if ( MountGatherer_Mode == MOUNTGATHERER_MODE_DOMOUNT ) then
		if ( MountGatherer_ShouldMountAt ) then
			if ( not LootFrame:IsVisible() ) then
				if ( curTime >= MountGatherer_ShouldMountAt ) then
					MountGatherer_Mount();
					MountGatherer_ShouldMountAt = nil;
					MountGathererFrame:Hide();
				end
			end
		else
			MountGathererFrame:Hide();
		end
	elseif ( MountGatherer_Mode == MOUNTGATHERER_MODE_DOMAILBOXCHECK ) then
		local isVisible = MailFrame:IsVisible();
		if ( isVisible ) or ( not MountGatherer_LastMailboxHidden ) then
			MountGatherer_LastMailboxHidden = nil;
			MountGathererFrame:Hide();
		else
			if ( curTime - MountGatherer_LastMailboxHidden > MOUNTGATHERER_MAILBOXTIMEOUT) then
				local mountBuffPos = AutoMount_GetMountBuffPosition();
				if ( mountBuffPos > -1 ) then
					MountGatherer_HandledItem = MountGatherer_DismountableStringsMailbox;
					CancelPlayerBuff(mountBuffPos);
					MountGatherer_LastDismount = curTime;
				end
				MountGatherer_LastMailboxHidden = nil;
				MountGathererFrame:Hide();
			end
		end
	else
		MountGathererFrame:Hide();
	end
end