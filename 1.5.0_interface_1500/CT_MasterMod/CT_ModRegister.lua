CT_HideBAB = 0;
CT_RelocateTooltip = 0;

questfadefunction = function (modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		QUEST_FADING_ENABLE = nil;
		CT_Print("<CTMod> "..CT_MASTERMOD_ON_QUESTFADE, 1.0, 1.0, 0.0);
	else
		QUEST_FADING_ENABLE = 1;
		CT_Print("<CTMod> "..CT_MASTERMOD_OFF_QUESTFADE, 1.0, 1.0, 0.0);
	end
end
questfadeinitfunction = function (modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		QUEST_FADING_ENABLE = nil;
	else
		QUEST_FADING_ENABLE = 1;
	end
end
CT_RegisterMod(CT_MASTERMOD_MODNAME_QUESTFADING, CT_MASTERMOD_SUBNAME_QUESTFADING, 5, "Interface\\Icons\\INV_Misc_Note_04", CT_MASTERMOD_TOOLTIP_QUESTFADING, "on", nil, questfadefunction, questfadeinitfunction);

reloadfunction = function ()
	ConsoleExec("reloadui");
	CT_Print("<CTMod> "..CT_MASTERMOD_WARNING_RELOAD, 1, 1, 0);
end

resetfunction = function()
	CT_Print("<CTMod> "..CT_MASTERMOD_WARNING_RESET, 1, 1, 0);
end

CT_RegisterMod(CT_MASTERMOD_MODNAME_RELOAD, "", 5, "Interface\\Icons\\Ability_Whirlwind", CT_MASTERMOD_TOOLTIP_RELOAD, "switch", "", reloadfunction);
CT_RegisterMod(CT_MASTERMOD_MODNAME_RESET, "", 5, "Interface\\Icons\\Spell_Frost_WindWalkOn", CT_MASTERMOD_TOOLTIP_RESET, "switch", "", resetfunction);

local gryphonfunction = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_Print("<CTMod> " ..CT_MASTERMOD_ON_GRYPHONS, 1, 1, 0);
		MainMenuBarLeftEndCap:Hide();
		MainMenuBarRightEndCap:Hide();
	else
		CT_Print("<CTMod> "..CT_MASTERMOD_OFF_GRYPHONS, 1, 1, 0);
		MainMenuBarLeftEndCap:Show();
		MainMenuBarRightEndCap:Show();
	end
end

local gryphoninitfunction = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		MainMenuBarLeftEndCap:Hide();
		MainMenuBarRightEndCap:Hide();
	else
		MainMenuBarLeftEndCap:Show();
		MainMenuBarRightEndCap:Show();
	end
end
-- LedMirage 6/10/2005 Change Start [ 1 of 1] OFF to ON
CT_RegisterMod(CT_MASTERMOD_MODNAME_GRYPHONS, "", 5, "Interface\\Icons\\Ability_EyeOfTheOwl", CT_MASTERMOD_TOOLTIP_GRYPHONS, "on", nil, gryphonfunction, gryphoninitfunction);
-- LedMirage 6/10/2005 Change End [ 1 of 1]

CT_Old_ShowSB_Update = ShapeshiftBar_Update;
function CT_ShapeshiftBar_Update()
	if ( CT_HideBAB == 1 ) then
		ShapeshiftBarFrame:Hide();
	else
		CT_Old_ShowSB_Update();
	end
end
ShapeshiftBar_Update = CT_ShapeshiftBar_Update;
	
local hidebarfunc = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_HideBAB = 1;
		CT_Print("<CTMod> "..CT_MASTERMOD_ON_HIDEBONUSBARS, 1, 1, 0);
	else
		CT_Print("<CTMod> "..CT_MASTERMOD_OFF_HIDEBONUSBARS, 1, 1, 0);
		CT_HideBAB = 0;
	end
	ShapeshiftBar_Update();
end

local hidebarinitfunc = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_HideBAB = 1;
	else
		CT_HideBAB = 0;
	end
	ShapeshiftBar_Update();
end
CT_RegisterMod(CT_MASTERMOD_MODNAME_HIDEBONUSBARS, "", 5, "Interface\\Icons\\Spell_Nature_Sleep", CT_MASTERMOD_TOOLTIP_HIDEBONUSBARS, "off", nil, hidebarfunc, hidebarinitfunc);

SlashCmdList["RESETOPTIONS"] = function(msg)
	CT_Options[UnitName("player")] = { };
	CT_Print(CT_MASTERMOD_OPTIONRESET, 1, 1, 0);
end

SLASH_RESETOPTIONS1 = "/resetoptions";

function CT_QuestTimer_UpdatePosition()
	if ( CT_BuffFrame and CT_BuffFrame:IsVisible() ) then
		if ( Minimap:IsVisible() ) then
			QuestTimerFrame:ClearAllPoints();
			QuestTimerFrame:SetPoint("CENTER", "MinimapCluster", "LEFT", -50, 0);	
		else
			QuestTimerFrame:ClearAllPoints();
			QuestTimerFrame:SetPoint("RIGHT", "MinimapCluster", "RIGHT", -25, 0);
		end
	else
		QuestTimerFrame:ClearAllPoints();
		QuestTimerFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", 10, 0);
	end
end
CT_QuestTimer_oldToggleMinimap = ToggleMinimap;
function CT_QuestTimer_newToggleMinimap()
	CT_QuestTimer_oldToggleMinimap();
	CT_QuestTimer_UpdatePosition();
end
ToggleMinimap = CT_QuestTimer_newToggleMinimap;

CT_oldUIParent_ManageRightSideFrames = UIParent_ManageRightSideFrames;
function CT_newUIParent_ManageRightSideFrames()
	CT_oldUIParent_ManageRightSideFrames();
	CT_QuestTimer_UpdatePosition();
end
UIParent_ManageRightSideFrames = CT_newUIParent_ManageRightSideFrames;

function CT_QuestTimerFrame_OnShow()
	CT_QuestTimer_UpdatePosition();
	return;
end
function CT_QuestTimerFrame_OnHide()
	return;
end
-- Redefine how the show/hide happens
QuestTimerFrame_OnShow = CT_QuestTimerFrame_OnShow;
QuestTimerFrame_OnHide = CT_QuestTimerFrame_OnHide;

CT_OldDD_AddButton = UIDropDownMenu_AddButton;
function CT_NewDD_AddButton(info, level)
	if ( not level ) then
		level = 1;
	end
	
	local listFrame = getglobal("DropDownList"..level);
	local listFrameName = listFrame:GetName();
	local index = listFrame.numButtons + 1;
	local width;

	-- If too many buttons error out
	if ( index > UIDROPDOWNMENU_MAXBUTTONS ) then
		return;
	end
	CT_OldDD_AddButton(info, level);
end

UIDropDownMenu_AddButton = CT_NewDD_AddButton;

CT_oldGT_SetDefaultAnchor = GameTooltip_SetDefaultAnchor;

function CT_GT_SetDefaultAnchor(tooltip, parent) 
	if ( tooltip == GameTooltip and CT_RelocateTooltip == 1 ) then
		tooltip:SetOwner(parent, "ANCHOR_NONE");
		tooltip:ClearAllPoints();
		tooltip:SetPoint("TOP", "UIParent", "TOP");
	else
		CT_oldGT_SetDefaultAnchor(tooltip, parent);
	end
end

GameTooltip_SetDefaultAnchor = CT_GT_SetDefaultAnchor;

local relocatefunc = function(modId, text)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_RelocateTooltip = 1;
		CT_Print("<CTMod> "..CT_MASTERMOD_ON_RELOCATETT, 1, 1, 0);
	else
		CT_RelocateTooltip = 0;
		CT_Print("<CTMod> "..CT_MASTERMOD_OFF_RELOCATETT, 1, 1, 0);
	end
end

local relocateinitfunc = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_RelocateTooltip = 1;
	else
		CT_RelocateTooltip = 0;
	end
end
CT_RegisterMod(CT_MASTERMOD_MODNAME_RELOCATETT, CT_MASTERMOD_SUBNAME_RELOCATETT, 5, "Interface\\Icons\\INV_Misc_Map_01", CT_MASTERMOD_TOOLTIP_RELOCATETT, "off", nil, relocatefunc, relocateinitfunc);

CT_oldSetItemButtonCount = SetItemButtonCount;
function CT_newSetItemButtonCount(button, count)
	CT_oldSetItemButtonCount(button, count);
	getglobal(button:GetName().."Count"):SetText(button.count);
end
SetItemButtonCount = CT_newSetItemButtonCount;

function MasterLockFunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_LockMovables(1);
		CT_Print("<CTMod> " .. CT_MASTERMOD_UNLOCKED, 1, 1, 0);
	else
		CT_Print("<CTMod> " .. CT_MASTERMOD_LOCKED, 1, 1, 0);
		CT_LockMovables(nil);
	end
end

function MasterLockInitFunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_MF_ShowFrames = 1;
	else
		CT_MF_ShowFrames = nil;
	end
end

function MasterResetFunction(modId, text)
	CT_ResetFrame:Show();
	if ( text ) then text:SetText(""); end
end


CT_RegisterMod(CT_MASTERMOD_MODNAME_UNLOCK, CT_MASTERMOD_SUBNAME_UNLOCK, 1, "Interface\\Icons\\INV_Misc_Key_03", CT_MASTERMOD_TOOLTIP_UNLOCK, "off", nil, MasterLockFunction, MasterLockInitFunction, 11);
CT_RegisterMod(CT_MASTERMOD_MODNAME_RESETFRAMES, CT_MASTERMOD_SUBNAME_RESETFRAMES, 1, "Interface\\Icons\\INV_Misc_Key_04", CT_MASTERMOD_TOOLTIP_RESETFRAMES, "switch", "", MasterResetFunction, nil, 12);

--[[
function CT_FindTellTarget(text)
	if ( not text ) then return; end
	text = strlower(text);
	-- /tell
	local iStart, iEnd, nick = string.find(text, "^/tell ([^%s]+)$");
	if ( iStart and iEnd and nick ) then
		return nick, "/tell ";
	end

	-- /t
	local iStart, iEnd, nick = string.find(text, "^/t ([^%s]+)$");
	if ( iStart and iEnd and nick ) then
		return nick, "/t ";
	end

	-- /whisper
	local iStart, iEnd, nick = string.find(text, "^/whisper ([^%s]+)$");
	if ( iStart and iEnd and nick ) then
		return nick, "/whisper ";
	end

	-- /w
	local iStart, iEnd, nick = string.find(text, "^/w ([^%s]+)$");
	if ( iStart and iEnd and nick ) then
		return nick, "/w ";
	end

	-- No result, return nil
	return nil;
end

CT_oldChatEdit_ExtractTellTarget = ChatEdit_ExtractTellTarget;
function CT_newChatEdit_ExtractTellTarget(editBox, msg)
	if ( not this.noParse ) then
		CT_oldChatEdit_ExtractTellTarget(editBox, msg);
	else
		this.noParse = nil;
	end
end
ChatEdit_ExtractTellTarget = CT_newChatEdit_ExtractTellTarget;

CT_oldChatEdit_OnTextChanged = ChatEdit_OnTextChanged;
function CT_newChatEdit_OnTextChanged()
	CT_oldChatEdit_OnTextChanged();

	if ( this.hasCompleted ) then
		this.hasCompleted = nil;
		return;
	end
	if ( this.lastTextLen and strlen(this:GetText()) <= this.lastTextLen ) then
		this.lastTextLen = strlen(this:GetText());
		return;
	end

	this.noParse = nil;
	-- Auto Completion
	local textlen = strlen(this:GetText());
	this.lastTextLen = textlen;

	local text, type = CT_FindTellTarget(this:GetText());
	if ( not text ) then return; end

	local numFriends = GetNumFriends();
	local name;
	if ( numFriends > 0 ) then
		for i=1, numFriends do
			name = 	GetFriendInfo(i);
			if ( strfind(strlower(name), "^"..text) ) then
				this.noParse = 1;
				this:SetText(type .. name);
				this:HighlightText(textlen, -1);
				this.hasCompleted = 1;
				break;
			end
		end
	end

	-- Hack to scan offline members
	local oldOffline = GuildFrameLFGButton:GetChecked();
	SetGuildRosterShowOffline(1);

	local numGuildMembers = GetNumGuildMembers();
	if ( numGuildMembers > 0 ) then
		for i=1, numGuildMembers do
			name = GetGuildRosterInfo(i);
			if ( strfind(strlower(name), "^"..text) ) then
				this.noParse = 1;
				this:SetText(type .. name);
				this:HighlightText(textlen, -1);
				this.hasCompleted = 1;
				break;
			end
		end
	end
	this.noParse = nil;
	SetGuildRosterShowOffline(oldOffline);
end
ChatEdit_OnTextChanged = CT_newChatEdit_OnTextChanged;
]]