-- CT_RA_CustomOnClickFunction

-- Set this variable (CT_RA_CustomOnClickFunction) in your own mod to your function to handle OnClicks.
-- Two arguments are passed, button and raidid.
-- Button is a string that refers to the mouse button pressed, "LeftButton" or "RightButton".
-- Raidid is a string with the unit id, such as "raid1".

-- Example: function MyFunction(button, raidid) doStuff(); end
-- CT_RA_CustomOnClickFunction = MyFunction;

-- Note! If the function returns true, the default CTRA behaviour will not be called.
-- If it returns false or nil, the default behaviour will be called.

-- Variables
CHAT_MSG_CTRAID = "CTRaid";
CT_RA_Comm_MessageQueue = { };
CT_RA_Level = 0;
CT_RA_AllowedCommanders = 1;
CT_RA_Stats = {
	{
		{ }
	}
};
CT_RA_BuffsToCure = { };
CT_RA_BuffsToRecast = { };
CT_RA_RaidParticipant = nil; -- Used to see what player participated in the raid on this account

CT_RA_Auras = { 
	["buffs"] = { },
	["debuffs"] = { }
};
CT_RA_LastSend = nil;
CT_RA_ClassPositions = {
	[CT_RA_WARRIOR] = 1,
	[CT_RA_DRUID] = 2,
	[CT_RA_MAGE] = 3,
	[CT_RA_WARLOCK] = 4,
	[CT_RA_ROGUE] = 5,
	[CT_RA_HUNTER] = 6,
	[CT_RA_PRIEST] = 7,
	[CT_RA_PALADIN] = 8,
	[CT_RA_SHAMAN] = 8
};

CT_RA_LastSent = { };
CT_RA_BuffTimeLeft = { };
CT_RA_ResFrame_Options = { };
CT_RA_CurrPlayerName = "";

CT_RA_NumRaidMembers = 0;

ChatTypeGroup["CTRAID"] = {
	"CHAT_MSG_CTRAID"
};
ChatTypeInfo["CTRAID"] = { sticky = 0 };
tinsert(OtherMenuChatTypeGroups, "CTRAID");
CHAT_CTRAID_GET = "";
CT_RA_ChatInfo = {
	["Default"] = {
		["r"] = 1.0,
		["g"] = 0.5,
		["b"] = 0,
		["show"] = {
			"ChatFrame1"
		}
	}
};

CT_oldFCF_Tab_OnClick = FCF_Tab_OnClick;
function CT_newFCF_Tab_OnClick(button)
	CT_oldFCF_Tab_OnClick(button);
	if ( button == "RightButton" ) then
		local frame = getglobal("ChatFrame" .. this:GetID());
		local info = CT_RA_ChatInfo["Default"];
		if ( CT_RA_ChatInfo[UnitName("player")] ) then
			info = CT_RA_ChatInfo[UnitName("player")];
		end
		for k, v in info["show"] do
			if ( v == "ChatFrame" .. this:GetID() ) then
				local y = 1;
				while ( frame.messageTypeList[y] ) do
					y = y + 1;
				end
				frame.messageTypeList[y] = "CTRAID";
			end
		end
	end
end
FCF_Tab_OnClick = CT_newFCF_Tab_OnClick;

CT_oldFCF_SetChatTypeColor = FCF_SetChatTypeColor;
function CT_newFCF_SetChatTypeColor()
	CT_oldFCF_SetChatTypeColor();
	if ( UIDROPDOWNMENU_MENU_VALUE == "CTRAID" ) then
		local r,g,b = ColorPickerFrame:GetColorRGB();
		if ( not CT_RA_ChatInfo[UnitName("player")] ) then
			CT_RA_ChatInfo[UnitName("player")] = CT_RA_ChatInfo["Default"];
		end
		CT_RA_ChatInfo[UnitName("player")].r = r;
		CT_RA_ChatInfo[UnitName("player")].g = g;
		CT_RA_ChatInfo[UnitName("player")].b = b;
		ChatTypeInfo["CTRAID"].r = r;
		ChatTypeInfo["CTRAID"].g = g;
		ChatTypeInfo["CTRAID"].b = b;
	end
end
FCF_SetChatTypeColor = CT_newFCF_SetChatTypeColor;

CT_oldFCF_CancelFontColorSettings = FCF_CancelFontColorSettings;
function CT_newFCF_CancelFontColorSettings(prev)
	CT_oldFCF_CancelFontColorSettings(prev);
	if ( prev.r and UIDROPDOWNMENU_MENU_VALUE == "CTRAID" ) then
		if ( not CT_RA_ChatInfo[UnitName("player")] ) then
			CT_RA_ChatInfo[UnitName("player")] = CT_RA_ChatInfo["Default"];
		end
		CT_RA_ChatInfo[UnitName("player")].r = prev.r;
		CT_RA_ChatInfo[UnitName("player")].g = prev.g;
		CT_RA_ChatInfo[UnitName("player")].b = prev.b;
		ChatTypeInfo["CTRAID"].r = prev.r;
		ChatTypeInfo["CTRAID"].g = prev.g;
		ChatTypeInfo["CTRAID"].b = prev.b;
	end
end
FCF_CancelFontColorSettings = CT_newFCF_CancelFontColorSettings;
CT_oldFCFMessageTypeDropDown_OnClick = FCFMessageTypeDropDown_OnClick;
function CT_newFCFMessageTypeDropDown_OnClick()
	CT_oldFCFMessageTypeDropDown_OnClick();
	if ( not CT_RA_ChatInfo[UnitName("player")] ) then
		CT_RA_ChatInfo[UnitName("player")] = CT_RA_ChatInfo["Default"];
	end
	if ( this.value == "CTRAID" ) then
		if ( UIDropDownMenuButton_GetChecked() ) then
			for k, v in CT_RA_ChatInfo[UnitName("player")]["show"] do
				if ( v == FCF_GetCurrentChatFrame():GetName() ) then
					CT_RA_ChatInfo[UnitName("player")]["show"][k] = nil;
					break;
				end
			end
		else
			tinsert(CT_RA_ChatInfo[UnitName("player")]["show"], FCF_GetCurrentChatFrame():GetName());
		end
	end
end
FCFMessageTypeDropDown_OnClick = CT_newFCFMessageTypeDropDown_OnClick;

function CT_RA_ShowHideWindows()
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"] ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] = CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"];
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"] = nil;

		local num = 0;
		for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] do
			num = num + 1;
			getglobal("CT_RAOptionsGroupCB" .. k):SetChecked(1);
		end
		if ( num > 0 ) then
			CT_RACheckAllGroups:SetChecked(1);
		else
			CT_RACheckAllGroups:SetChecked(nil);
		end
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"] = CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"];
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] = { };
		for i = 1, 8, 1 do
			getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(nil);
		end
		CT_RACheckAllGroups:SetChecked(nil);
	end
	CT_RA_UpdateRaidGroup();
end

function CT_RA_SetGroup()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"][this:GetID()] = this:GetChecked();
	local num = 0;
	for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] do
		num = num + 1;
	end
	if ( num > 0 ) then
		CT_RACheckAllGroups:SetChecked(1);
	else
		CT_RACheckAllGroups:SetChecked(nil);
	end
	CT_RA_UpdateRaidGroup();
end

function CT_RA_CheckAllGroups()
	if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] ) then CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] = { }; end
	for i = 1, 8, 1 do
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"][i] = this:GetChecked();
		getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(this:GetChecked());
	end
	CT_RA_UpdateRaidGroup();
end

function CT_RA_ParseEvent(event)
	local sMsg = arg1;
	if ( strsub(event, 1, 13) == "CHAT_MSG_RAID" and type(arg1) == "string" ) then
		msg = gsub(sMsg, "%%", "%%%%");
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, raidid;

		for i = 1, GetNumRaidMembers(), 1 do
			if ( UnitName("raid" .. i) == arg2 ) then
				raidid = i;
				name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
				break;
			end
		end
		if ( CT_RA_Stats[arg2] and raidid ) then
			if ( arg6 and not CT_RA_Stats[arg2][arg6]  and ( arg6 == "AFK" or arg6 == "DND" ) ) then
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
				CT_RA_Stats[arg2][arg6] = { 1, 0 };
				CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. raidid), fileName, name, online);
			elseif ( arg2 == name and ( not arg6 or arg6 == "" ) and ( CT_RA_Stats[arg2]["DND"] or CT_RA_Stats[arg2]["AFK"] ) ) then
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
				CT_RA_Stats[arg2]["DND"] = nil;
				CT_RA_Stats[arg2]["AFK"] = nil;
				CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. raidid), fileName, name, online);
			end
		end
		local useless, useless, chan = string.find(sMsg, "<CTMod> This is an automatic message sent by CT_RaidAssist. Channel changed to: (.+)");
		if ( chan and raidid ) then
			if ( rank >= 1 ) then
				if ( chan ~= CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
					LeaveChannelByName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
				end
				CT_RA_UpdateFrame.newchan = chan;
				CT_RA_UpdateFrame.joinchan = 1;

				CT_RA_Print("<CTRaid> The CT_RaidAssist channel has been changed to '|c00FFFFFF" .. chan .. "|r'. You have automatically joined this channel.", 1, 0.5, 0);
			end
			return;
		end
		local useless, useless, chan = string.find(sMsg, "<CTRaid> This is an automatic message sent by CT_RaidAssist. Channel changed to: (.+)");
		if ( chan and raidid ) then
			if ( rank >= 1 ) then
				if ( chan ~= CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
					LeaveChannelByName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
				end
				CT_RA_UpdateFrame.newchan = chan;
				CT_RA_UpdateFrame.joinchan = 1;

				CT_RA_Print("<CTRaid> The CT_RaidAssist channel has been changed to '|c00FFFFFF" .. chan .. "|r'. You have automatically joined this channel.", 1, 0.5, 0);
			end
			return;
		end
		
		if ( string.find(sMsg, "<CTRaid> Disbanding raid on request by (.+)") ) then
			return;
		end

	elseif ( event == "CHAT_MSG_WHISPER" and type(arg1) == "string" ) then
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["KeyWord"] and strlower(sMsg) == strlower(CT_RAMenu_Options[CT_RAMenu_CurrSet]["KeyWord"]) ) then
			local temp = arg2;
			CT_RA_Print("<CTRaid> Invited '|c00FFFFFF" .. arg2 .. "|r' by Keyword Inviting.", 1, 0.5, 0);
			InviteByName(temp);
		end

	elseif ( strsub(event, 1, 15) == "CHAT_MSG_SYSTEM" and type(sMsg) == "string" ) then
		local useless, useless, plr = string.find(sMsg, "^([^%s]+) has left the raid group$");
		if ( CT_RA_RaidParticipant and plr and plr ~= CT_RA_RaidParticipant ) then
			CT_RA_Stats[plr] = nil;
			for k, v in CT_RA_MainTanks do
				if ( v == plr ) then
					CT_RA_MainTanks[k] = nil;
					break;
				end
			end
			CT_RA_UpdateRaidGroup();
			CT_RA_UpdateMTs();
			CT_RAOptions_Update();
		elseif ( string.find(arg1, CT_RA_AFKMESSAGE) or arg1 == MARKED_AFK ) then
			local _, _, msg = string.find(sMsg, CT_RA_AFKMESSAGE);
			if ( msg and msg ~= DEFAULT_AFK_MESSAGE ) then
				if ( strlen(msg) > 20 ) then
					msg = strsub(msg, 1, 20) .. "...";
				end
				CT_RA_AddMessage("AFK " .. msg);
			else
				CT_RA_AddMessage("AFK");
			end
		elseif ( string.find(arg1, CT_RA_DNDMESSAGE) ) then
			local _, _, msg = string.find(sMsg, CT_RA_DNDMESSAGE);
			if ( msg and msg ~= DEFAULT_DND_MESSAGE ) then
				if ( strlen(msg) > 20 ) then
					msg = strsub(msg, 1, 20) .. "...";
				end
				CT_RA_AddMessage("DND " .. msg);
			else
				CT_RA_AddMessage("DND");
			end
		elseif ( sMsg == CLEARED_AFK ) then
			CT_RA_AddMessage("UNAFK");
		elseif ( sMsg == CLEARED_DND ) then
			CT_RA_AddMessage("UNDND");
		end

	elseif ( event == "CHAT_MSG_CHANNEL" and CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] and arg9 and strlower(arg9) == strlower(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) and sMsg and type(sMsg) == "string" ) then
		local eventtype = strsub(event, 10);
		local info = ChatTypeInfo[eventtype];
		event = "CHAT_MSG_CTRAID";
		for i = 1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			local message, tempUpdate;
			local update = { };
			if ( name == arg2 ) then
				if ( not CT_RA_Stats[arg2] ) then
					CT_RA_Stats[arg2] = {
						["Buffs"] = { },
						["Debuffs"] = { },
						["Position"] = { }
					};
				end
				if ( arg6 and not CT_RA_Stats[arg2][arg6] and ( arg6 == "AFK" or arg6 == "DND" ) ) then
					CT_RA_Stats[arg2][arg6] = { 1, 0 };
					CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online);
				elseif ( ( not arg6 or arg6 == "" ) and ( CT_RA_Stats[arg2]["DND"] or CT_RA_Stats[arg2]["AFK"] ) ) then
					CT_RA_Stats[arg2]["DND"] = nil;
					CT_RA_Stats[arg2]["AFK"] = nil;
					CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online);
				end
				if ( not sMsg ) then
					return;
				end
				local msg = string.gsub(sMsg, "%$", "s");
				if ( CT_RA_Stats[arg2]["Version"] and CT_RA_Stats[arg2]["Version"] >= 1.151 ) then
					msg = string.gsub(msg, "§", "S");
				else
					msg = string.gsub(msg, "¤", "S");
				end
				if ( strsub(msg, strlen(msg)-7) == " ...hic!") then
					msg = strsub(msg, 1, strlen(msg)-8);
				end
				if ( string.find(msg, "#") ) then
					local arr = CT_RA_Split(msg, "#");
					for k, v in arr do
						tempUpdate, message = CT_RA_ParseMessage(name, v);
						if ( message ) then
							CT_RA_Print(message, 1, 0.5, 0);
						end
						if ( tempUpdate ) then
							for k, v in tempUpdate do
								tinsert(update, v);
							end
						end
					end
				else
					tempUpdate, message = CT_RA_ParseMessage(name, msg);
					if ( message ) then
						CT_RA_Print(message, 1, 0.5, 0);
					end
					if ( tempUpdate ) then
						for k, v in tempUpdate do
							tinsert(update, v);
						end
					end
				end
				if ( type(update) == "table" ) then
					for k, v in update do
						if ( type(v) == "number" ) then
							local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(v);
							CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. v), fileName, name, online);
						else
							for i = 1, GetNumRaidMembers(), 1 do
								if ( UnitName("raid" .. i) and UnitName("raid" .. i) == v ) then
									local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
									CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online);
									break;
								end
							end
						end
					end
				end
				break;
			end
		end
	elseif ( event == "CHAT_MSG_PARTY" ) then
		if ( CT_RA_Stats[arg2] ) then
			if ( arg6 and not CT_RA_Stats[arg2][arg6] and ( arg6 == "AFK" or arg6 == "DND" ) ) then
				for i = 1, GetNumRaidMembers(), 1 do
					if ( UnitName("raid" .. i) == arg2 ) then
						local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
						CT_RA_Stats[arg2][arg6] = { 1, 0 };
						CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online);
						break;
					end
				end
			elseif ( ( not arg6 or arg6 == "" ) and ( CT_RA_Stats[arg2]["DND"] or CT_RA_Stats[arg2]["AFK"] ) ) then
				for i = 1, GetNumRaidMembers(), 1 do
					if ( UnitName("raid" .. i) == arg2 ) then
						local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
						CT_RA_Stats[arg2]["DND"] = nil;
						CT_RA_Stats[arg2]["AFK"] = nil;
						CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online);
						break;
					end
				end
			end
		end
	end
end
	
CT_RA_oldChatFrame_OnEvent = ChatFrame_OnEvent;
function CT_RA_newChatFrame_OnEvent(event)

	if ( strsub(event, 1, 13) == "CHAT_MSG_RAID" ) then
		local useless, useless, chan = string.find(gsub(arg1, "%%", "%%%%"), "^<CTMod> This is an automatic message sent by CT_RaidAssist. Channel changed to: (.+)$");
		if ( chan ) then
			return;
		end
	end

	if ( event == "CHAT_MSG_WHISPER" ) then
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["KeyWord"] and strlower(arg1) == strlower(CT_RAMenu_Options[CT_RAMenu_CurrSet]["KeyWord"]) ) then
			return;
		end
	end

	-- There is a channel
	if ( strsub(event, 1, 8) == "CHAT_MSG" and CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] and arg9 and strlower(arg9) == strlower(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) ) then
		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];
		if ( type ~= "CHANNEL_LIST" and type ~= "SYSTEM" ) then
			return;
		end
	end
	CT_RA_oldChatFrame_OnEvent(event);
end
ChatFrame_OnEvent = CT_RA_newChatFrame_OnEvent;

function CT_RA_ParseMessage(nick, msg)
	local useless, useless, val1, val2, val3, val4, frame, raidid;
	local update;

	for i = 1, GetNumRaidMembers(), 1 do
		if ( UnitName("raid" .. i) and UnitName("raid" .. i) == nick ) then
			raidid = i;
			frame = getglobal("CT_RAMember" .. i);
			break;
		end
	end

	if ( not frame or not raidid ) then return nil; end

	if ( not CT_RA_Stats[nick] ) then
		if ( not update ) then
			update = { };
		end
		CT_RA_Stats[nick] = {
			["Buffs"] = { },
			["Debuffs"] = { },
			["Position"] = { }
		};
		tinsert(update, raidid);
	end
	CT_RA_Stats[nick]["Reporting"] = 1;
	
	-- Check buffs
	useless, useless, val1, val2, val3 = string.find(msg, "^B ([^%s]+) ([^%s]+) (.+)$");
	if ( val1 ) then
		-- Buffs
		CT_RA_Stats[nick]["Buffs"][val3] = { val1, tonumber(val2) };
		CT_RA_UpdateUnitBuffs(CT_RA_Stats[nick]["Buffs"], frame, nick);
		return update;
	end

	-- Check buffs for others
	useless, useless, val3, val1, val2 = string.find(msg, "^BPA ([^%s]+) ([^%s]+) (.+)$");
	if ( val1 and val2 and val3 ) then
		-- Buffs
		if ( not CT_RA_Stats[val3] ) then
			if ( not update ) then
				update = { };
			end
			CT_RA_Stats[val3] = {
				["Buffs"] = { },
				["Debuffs"] = { },
				["Position"] = { }
			};
			tinsert(update, val3);
		end
		CT_RA_Stats[val3]["Buffs"][val2] = { val1 };
		for i = 1, GetNumRaidMembers(), 1 do
			if ( UnitName("raid" .. i) and UnitName("raid" .. i) == val3 ) then
				CT_RA_UpdateUnitBuffs(CT_RA_Stats[val3]["Buffs"], getglobal("CT_RAMember" .. i), val3);
				break;
			end
		end
		return update;
	end

	-- Check buff expiration
	useless, useless, val1 = string.find(msg, "^BE (.+)$");
	if ( val1 ) then
		CT_RA_Stats[nick]["Buffs"][val1] = nil;
		if ( val1 == "Feign Death" ) then
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
			CT_RA_UpdateUnitStatus(class, frame, fileName, name, online);
		else
			CT_RA_UpdateUnitBuffs(CT_RA_Stats[nick]["Buffs"], frame, nick);
		end
		-- Buff expired
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["hidebuffs"] and val1 ~= "Power Word: Shield" and val1 ~= "Fire Shield" and val1 ~= "Admiral's Hat") then
			for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"] do
				local spell = v["name"][CT_RA_GetLocale()];
				local ismatch;
				if ( type(spell) == "string" and spell == val1 ) then
					ismatch = 1;
				elseif ( type(spell) == "table" and ( spell[1] == val1 or spell[2] == val1 ) ) then
					ismatch = 1;
				end
				if ( ismatch and v["show"] ~= -1 ) then
					for key, val in CT_RA_CurrPositions do
						local name, rank, subgroup, level, class = GetRaidRosterInfo(key);
						if ( name == nick and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"][val] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffsClass"][CT_RA_ClassPositions[class]] ) then
							if ( CT_RA_ClassSpells and CT_RA_ClassSpells[val1] and GetBindingKey("CT_RECASTRAIDBUFF") ) then
								if ( GetBindingKey("CT_RECASTRAIDBUFF") ) then
									CT_RA_AddToBuffQueue(val1, "raid"..key);
									return update, "<CTRaid> '|c00FFFFFF" .. nick .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded. Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_RECASTRAIDBUFF"), "KEY_") .. "|r' to recast.";
								else
									return update, "<CTRaid> '|c00FFFFFF" .. nick .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded.";
								end
							end
							break;
						end
					end
				end
					
			end
		end
		return update;
	end

	-- Check buff expiration for others
	useless, useless, val2, val1 = string.find(msg, "^BEPA ([^%s]+) (.+)$");
	if ( val1 and val2 ) then
		if ( not CT_RA_Stats[val2] ) then
			if ( not update ) then
				update = { };
			end
			CT_RA_Stats[val2] = {
				["Buffs"] = { },
				["Debuffs"] = { },
				["Position"] = { }
			};
			tinsert(update, val2);
		end
		CT_RA_Stats[val2]["Buffs"][val1] = nil;
		for i = 1, GetNumRaidMembers(), 1 do
			if ( UnitName("raid" .. i) and UnitName("raid" .. i) == val2 ) then
				if ( val1 == "Feign Death" ) then
					local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
					CT_RA_UpdateUnitStatus(class, frame, fileName, name, online);
				else
					CT_RA_UpdateUnitBuffs(CT_RA_Stats[val2]["Buffs"], getglobal("CT_RAMember" .. i), val2);
				end
				break;
			end
		end
		-- Buff expired
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["hidebuffs"] and val1 ~= "Power Word: Shield" and val1 ~= "Fire Shield" and val1 ~= "Admiral's Hat") then
			for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"] do
				local spell = v["name"][CT_RA_GetLocale()];
				local ismatch;
				if ( type(spell) == "string" and spell == val1 ) then
					ismatch = 1;
				elseif ( type(spell) == "table" and ( spell[1] == val1 or spell[2] == val1 ) ) then
					ismatch = 1;
				end
				if ( ismatch and v["show"] ~= -1 ) then
					for key, val in CT_RA_CurrPositions do
						local name, rank, subgroup, level, class = GetRaidRosterInfo(key);
						if ( name == val2 and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"][val] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffsClass"][CT_RA_ClassPositions[class]] ) then
							if ( CT_RA_ClassSpells and CT_RA_ClassSpells[val1] and GetBindingKey("CT_RECASTRAIDBUFF") ) then
								if ( GetBindingKey("CT_RECASTRAIDBUFF") ) then
									CT_RA_AddToBuffQueue(val1, "raid"..key);
									return update, "<CTRaid> '|c00FFFFFF" .. val2 .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded. Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_RECASTRAIDBUFF"), "KEY_") .. "|r' to recast.";
								else
									return update, "<CTRaid> '|c00FFFFFF" .. val2 .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded.";
								end
							end
							break;
						end
					end
				end
			end
		end
		return update;
	end

	-- Check debuffs
	useless, useless, val3, val4, val1, val2 = string.find(msg, "^D ([^%s]+) ([^%s]+) ([^%s]+) (.+)$");
	if ( val1 and val2 and val3 and val4 ) then
		-- Debuff
		if ( val2 == "Living Bomb" and CT_RAMenu_Options[CT_RAMenu_CurrSet]["Geddon_Status"] == 3 and nick ~= UnitName("player") ) then
			CT_RA_WarningFrame:AddMessage(nick .. " IS THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
		CT_RA_Stats[nick]["Debuffs"][val2] = { val1, tonumber(val3), val4 };
		CT_RA_UpdateUnitDebuffs(CT_RA_Stats[nick]["Debuffs"], frame);
		if ( CastParty_AddDebuff ) then
			for i = 1, GetNumRaidMembers(), 1 do
				if ( UnitName("raid"..i) == nick ) then
					CastParty_AddDebuff("raid" .. i, val1);
					break;
				end
			end
		end
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["main"] ) then
			for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"] do
				local en = v["type"]["en"];
				local de = v["type"]["de"];
				local fr = v["type"]["fr"];

				if ( ( ( de and de == val1 ) or ( en and en == val1 ) or ( fr and fr == val1 ) ) and v["id"] ~= -1 ) then
					for key, val in CT_RA_CurrPositions do
						local name, rank, subgroup, level, class = GetRaidRosterInfo(key);
						if ( name == nick and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"][val] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffsClass"][CT_RA_ClassPositions[class]] ) then
							if ( ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideShort"] or tonumber(val3) >= 10 ) and val2 ~= "Mind Vision" ) then
								local postfix = " (|c00FFFFFF" .. string.gsub(val1, "_", " ") .. "|r)";
								if ( string.gsub(val1, "_", " ") == val2 ) then
									postfix = "";
								end
								if ( CT_RA_ClassSpells and GetBindingKey("CT_CUREDEBUFF") and CT_RA_GetCure(val1)) then
									CT_RA_AddToQueue(val1, "raid"..key, string.gsub(val1, "_", " "));
									return update, "<CTRaid> '|c00FFFFFF" .. nick .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ". Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_CUREDEBUFF"), "KEY_") .. "|r' to cure.";
								else
									return update, "<CTRaid> '|c00FFFFFF" .. nick .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ".";
								end
							end
							break;
						end
					end
				end
			end
		end
		return update;
	end

	-- Check debuffs for others
	useless, useless, val4, val3, val1, val2 = string.find(msg, "^DPA ([^%s]+) ([^%s]+) ([^%s]+) (.+)$"); -- nick(4), texture(3), type(1), name(2)
	if ( val1 and val2 and val3 and val4 ) then
		-- Debuff
		if ( val2 == "Living Bomb" and CT_RAMenu_Options[CT_RAMenu_CurrSet]["Geddon_Status"] == 3 and val4 ~= UnitName("player") ) then
			CT_RA_WarningFrame:AddMessage(val4 .. " IS THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
		
		if ( not CT_RA_Stats[val4] ) then
			if ( not update ) then
				update = { };
			end
			CT_RA_Stats[val4] = {
				["Buffs"] = { },
				["Debuffs"] = { },
				["Position"] = { }
			};
			tinsert(update, val4);
		end
		CT_RA_Stats[val4]["Debuffs"][val2] = { val1, 50, val3 };
		for i = 1, GetNumRaidMembers(), 1 do
			if ( UnitName("raid" .. i) and UnitName("raid" .. i) == val4 ) then
				CT_RA_UpdateUnitDebuffs(CT_RA_Stats[val4]["Debuffs"], getglobal("CT_RAMember" .. i));
				if ( CastParty_AddDebuff ) then
					CastParty_AddDebuff("raid" .. i, val1);
				end
				break;
			end
		end
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["main"] ) then
			for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"] do
				local en = v["type"]["en"];
				local de = v["type"]["de"];
				local fr = v["type"]["fr"];

				if ( ( ( de and de == val1 ) or ( en and en == val1 ) or ( fr and fr == val1 ) ) and v["id"] ~= -1 ) then
					for key, val in CT_RA_CurrPositions do
						local name, rank, subgroup, level, class = GetRaidRosterInfo(key);
						if ( name == val4 and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"][val] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffsClass"][CT_RA_ClassPositions[class]] ) then
							local postfix = " (|c00FFFFFF" .. string.gsub(val1, "_", " ") .. "|r)";
							if ( string.gsub(val1, "_", " ") == val2 ) then
								postfix = "";
							end
							if ( CT_RA_ClassSpells and GetBindingKey("CT_CUREDEBUFF") and CT_RA_GetCure(val1) ) then
								CT_RA_AddToQueue(val1, "raid"..key, string.gsub(val1, "_", " "));
								return update, "<CTRaid> '|c00FFFFFF" .. val4 .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ". Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_CUREDEBUFF"), "KEY_") .. "|r' to cure.";
							else
								return update, "<CTRaid> '|c00FFFFFF" .. val4 .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ".";
							end
							break;
						end
					end
				end
			end
		end
		return update;
	end

	-- Check debuff expiration
	useless, useless, val1 = string.find(msg, "^DE (.+)$");
	if ( val1 ) then
		-- Debuff expired
		if ( CT_RA_Stats[nick] and CT_RA_Stats[nick]["Debuffs"][val1] and CT_RA_Stats[nick]["Debuffs"][val1][1] ) then
			local debuffType = CT_RA_Stats[nick]["Debuffs"][val1][1];
			if ( CastParty_RemoveDebuff ) then
				for i = 1, GetNumRaidMembers(), 1 do
					if ( UnitName("raid" .. i) == nick ) then
						CastParty_RemoveDebuff("raid" .. i, debuffType);
						break;
					end
				end
			end
		end
		CT_RA_Stats[nick]["Debuffs"][val1] = nil;
		CT_RA_UpdateUnitDebuffs(CT_RA_Stats[nick]["Debuffs"], frame);
		return update;
	end

	-- Check debuff expiration for others
	useless, useless, val1, val2 = string.find(msg, "^DEPA ([^%s]+) (.+)$");
	if ( val1 and val2) then
		-- Debuff expired
		if ( not CT_RA_Stats[val1] ) then
			if ( not update ) then
				update = { };
			end
			CT_RA_Stats[val1] = {
				["Health"] = nil,
				["Mana"] = nil,
				["Buffs"] = { },
				["Debuffs"] = { },
				["Position"] = { }
			};
			tinsert(update, val1);
		end
		if ( CT_RA_Stats[val1] and CT_RA_Stats[val1]["Debuffs"][val2] and CT_RA_Stats[val1]["Debuffs"][val2][1] ) then
			local debuffType = CT_RA_Stats[val1]["Debuffs"][val2][1];
			if ( CastParty_RemoveDebuff ) then
				for i = 1, GetNumRaidMembers(), 1 do
					if ( UnitName("raid" .. i) == val1 ) then
						CastParty_RemoveDebuff("raid" .. i, debuffType);
						break;
					end
				end
			end
		end
		CT_RA_Stats[val1]["Debuffs"][val2] = nil;
		for i = 1, GetNumRaidMembers(), 1 do
			if ( UnitName("raid" .. i) and UnitName("raid" .. i) == val1 ) then
				CT_RA_UpdateUnitDebuffs(CT_RA_Stats[val1]["Debuffs"], getglobal("CT_RAMember" .. i));
				break;
			end
		end
		return update;
	end
	useless, useless, val1 = string.find(msg, "^Z (.+)$");
	if ( val1 ) then
		CT_RA_Stats[nick]["Zone"] = val1;
		return update;
	end

	-- Check status requests
	if ( msg == "SR" ) then
		if ( CT_RA_IsSendingWithVersion(1.08) ) then
			for k, v in CT_RA_MainTanks do
				CT_RA_AddMessage("SET " .. k .. " " .. v);
			end
		end
		CT_RA_Stats = { };
		CT_RA_UpdateFrame.scheduleUpdate = 1;
		return update;
	end

	if ( strsub(msg, 1, 2) == "S " ) then
		for str in string.gfind(msg, " B [^%s]+ [^%s]+ [^#]+ #") do
			useless, useless, val1, val3, val2 = string.find(str, "B ([^%s]+) ([^%s]+) (.+) #");
			if ( val1 and val2 and val3 ) then
				CT_RA_Stats[nick]["Buffs"][val2] = { val1, tonumber(val3) };
				CT_RA_UpdateUnitBuffs(CT_RA_Stats[nick]["Buffs"], frame, nick);
				return update;
			end
		end
	end

	if ( strsub(msg, 1, 3) == "MS " ) then
		for i = 1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( rank >= 1 and name == nick ) then
				if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["PlayRSSound"] ) then
					PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav");
				end
				CT_RAMessageFrame:AddMessage(nick .. ": " .. strsub(msg, 3), CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"].b, 1.0, UIERRORS_HOLD_TIME);
				return update;
			end
		end
	end

	useless, useless, val1 = string.find(msg, "^V (.+)$");
	if ( tonumber(val1) ) then
		CT_RA_Stats[nick]["Version"] = tonumber(val1);
		return update;
	end

	if ( strsub(msg, 1, 4) == "SET " ) then
		local useless, useless, num, name = string.find(msg, "^SET (%d) (.+)$");
		if ( num and name ) then
			for i = 1, GetNumRaidMembers(), 1 do
				local user, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
				if ( user == nick ) then
					for k, v in CT_RA_MainTanks do
						if ( v == name ) then
							CT_RA_MainTanks[k] = nil;
						end
					end
					CT_RA_MainTanks[tonumber(num)] = name;
					CT_RAOptions_Update();
					CT_RA_UpdateMTs();
					return update;
				end
			end
		end
	end

	if ( strsub(msg, 1, 2) == "R " ) then
		local useless, useless, name = string.find(msg, "^R (.+)$");
		if ( name ) then
			for k, v in CT_RA_MainTanks do
				if ( v == name ) then
					for i = 1, GetNumRaidMembers(), 1 do
						local user, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
						if ( rank >= 1 and user == nick ) then
							CT_RA_MainTanks[k] = nil;
							CT_RA_UpdateMTs();
							CT_RAOptions_Update();
							return update;
						end
					end
				end
			end
		end
	end

	if ( msg == "DB" ) then
		for i = 1, GetNumRaidMembers(), 1 do
			local user, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( rank >= 1 and user == nick ) then
				CT_RA_Print("<CTRaid> Disbanding raid on request by '|c00FFFFFF" .. nick .. "|r'.", 1, 0.5, 0);
				LeaveParty();
				return update;
			end
		end
	end

	if ( msg == "RESSED" ) then
		CT_RA_Stats[nick]["Ressed"] = 1;
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
		CT_RA_UpdateUnitStatus(class, frame, fileName, name, online);
		return update;
	end

	if ( msg == "NORESSED" ) then
		CT_RA_Stats[nick]["Ressed"] = nil;
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
		CT_RA_UpdateUnitStatus(class, frame, fileName, name, online);
		return update;
	end

	if ( strsub(msg, 1, 3) == "RES" ) then
		if ( msg == "RESNO" ) then
			CT_RA_Ressers[nick] = nil;
		else
			local _, _, player = string.find(msg, "^RES (.+)$");
			if ( player ) then
				CT_RA_Ressers[nick] = player;
			end
		end
		CT_RA_UpdateResFrame();
		return update;
	end
	-- Check ready

	if ( msg == "CHECKREADY" ) then
		local name, rank = GetRaidRosterInfo(raidid);
		if ( rank >= 1 ) then
			CT_RA_CheckReady_Person = nick;
			if ( nick ~= UnitName("player") ) then
				CT_RA_ReadyFrame:Show();
			end
		end
	elseif ( msg == "READY" ) then
		CT_RA_Stats[nick]["notready"] = nil;
		local all_ready = true;
		for k, v in CT_RA_Stats do
			if ( v["notready"] ) then
				all_ready = false;
				break;
			end
		end
		if ( all_ready and CT_RA_CheckReady_Person == UnitName("player") ) then
			CT_RA_Print("<CTRaid> Everybody is ready.", 1, 1, 0);
		end
		CT_RA_UpdateUnitDead(frame);
	end

	-- Check AFK

	if ( msg == "AFK" ) then
		CT_RA_Stats[nick]["AFK"] = { 1, 0 };
	elseif ( msg == "UNAFK" ) then
		CT_RA_Stats[nick]["AFK"] = nil;
	elseif ( msg == "DND" ) then
		CT_RA_Stats[nick]["DND"] = { 1, 0 };
	elseif ( msg == "UNDND" ) then
		CT_RA_Stats[nick]["DND"] = nil;
	elseif ( strsub(msg, 1, 3) == "AFK" ) then
		-- With reason
		CT_RA_Stats[nick]["AFK"] = { strsub(msg, 5), 0 };
	elseif ( strsub(msg, 1, 3) == "DND" ) then
		-- With reason
		CT_RA_Stats[nick]["DND"] = { strsub(msg, 5), 0 };
	end

	return update;
end

-- Send messages
function CT_RA_AddMessage(msg)
	tinsert(CT_RA_Comm_MessageQueue, msg);
end

function CT_RA_SendMessage(msg, force)
	
	if ( GetNumRaidMembers() == 0 ) then return; end -- Mod should be disabled if not in raid
	msg = string.gsub(msg, "|Hitem:%d+:%d+:%d+:%d+|h(%[[^%|]+%])|h", "%1");
	msg = string.gsub(msg, "|c%w%w%w%w%w%w%w%w([^%|]+)|r", "%1");
	msg = string.gsub(msg, "s", "$");
	msg = string.gsub(msg, "S", "§");
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] and GetChannelName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) and ( not CT_RA_LastSend or CT_RA_LastSend ~= msg or force ) ) then
		CT_RA_LastSend = msg;
		local priorValue = GetCVar("autoClearAFK");
		SetCVar("autoClearAFK", 0);
		SendChatMessage(msg, "CHANNEL", nil, GetChannelName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]));
		SetCVar("autoClearAFK", priorValue);
	end
end

function CT_RA_OnEvent(event)
	if ( event == "RAID_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" ) then
		if ( event == "RAID_ROSTER_UPDATE" ) then
			if ( GetNumRaidMembers() == 0 ) then
				CT_RA_MainTanks = { };
				CT_RA_Stats = { };
				CT_RA_ButtonIndexes = { };
			end
			if ( CT_RA_NumRaidMembers == 0 and GetNumRaidMembers() > 0 ) then
				CT_RA_UpdateFrame.SS = 10;
				if ( CT_RA_UpdateFrame.time ) then
					CT_RA_UpdateFrame.time = nil;
				end
				if ( not CT_RA_HasJoinedRaid ) then
					if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] and GetChannelName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) == 0 ) then
						CT_RA_Print("<CTRaid> First raid detected. To join the current RaidAssist channel (|c00FFFFFF" .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] .. "|r), use |c00FFFFFF/rajoin|r.", 1, 0.5, 0);
					elseif ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
						CT_RA_Print("<CTRaid> First raid detected. There is currently no RaidAssist channel set. To set and join one, type |c00FFFFFF/rajoin [channel]|r, where |c00FFFFFF[channel]|r is the name of the channel to use.", 1, 0.5, 0);
					end
				end
				CT_RA_PartyMembers = { };
				CT_RA_HasJoinedRaid = 1;
			end
			CT_RA_CheckGroups();
		end
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMonitor"] and GetNumRaidMembers() > 0 ) then
			CT_RA_ResFrame:Show();
		else
			CT_RA_ResFrame:Hide();
		end
		CT_RA_NumRaidMembers = GetNumRaidMembers();
		CT_RA_UpdateRaidGroup();
		CT_RAOptions_Update();
		CT_RA_UpdateMTs();
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] and GetGuildInfo("player") ) then
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] = "CT" .. string.gsub(GetGuildInfo("player"), "[^%w]", "");
		end

	end

	if ( event == "UNIT_NAME_UPDATE" ) then
		if ( arg1 == "player" and UnitName("player") ~= "Unknown Unit" ) then
			if ( CT_RA_RaidParticipant ) then
				if ( CT_RA_RaidParticipant ~= UnitName("player") ) then
					CT_RA_Stats = { { } };
					CT_RA_MainTanks = { };
					CT_RA_ButtonIndexes = { };
					CT_RA_UpdateRaidGroup();
				end
			end
			CT_RA_RaidParticipant = UnitName("player");
			-- Add chat frame stuff
			local info = CT_RA_ChatInfo["Default"];
			if ( CT_RA_ChatInfo[UnitName("player")] ) then
				info = CT_RA_ChatInfo[UnitName("player")];
			end
			ChatTypeInfo["CTRAID"].r = info.r;
			ChatTypeInfo["CTRAID"].g = info.g;
			ChatTypeInfo["CTRAID"].b = info.b;
		end
	end
	if ( event == "PARTY_MEMBERS_CHANGED" ) then
		CT_RAMenu_CheckParty();
	end

	if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then return; end
	-- All events below this line requires CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] to be initialized

	if ( event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" ) then
		local _, _, id = string.find(arg1, "^raid(%d+)$");
		if ( id ) then
			local name, rank, subgroup, level, class, fileName, zone, online, dead = GetRaidRosterInfo(tonumber(id));
			if ( UnitIsDead(arg1) or UnitIsGhost(arg1) ) then
				if ( not CT_RA_Stats[UnitName(arg1)] ) then
					CT_RA_Stats[UnitName(arg1)] = {
						["Buffs"] = { },
						["Debuffs"] = { },
						["Position"] = { }
					};
				end
				CT_RA_Stats[UnitName(arg1)]["Dead"] = 1;
				CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. tonumber(id)), fileName, name, online)
			elseif ( CT_RA_Stats[UnitName(arg1)] and CT_RA_Stats[UnitName(arg1)]["Dead"] ) then
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(tonumber(id));
				CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. tonumber(id)), fileName, name, online)
			else
				CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. tonumber(id)));
			end
		end
		return;
	end

	if ( event == "UNIT_AURA" ) then
		if ( string.find(arg1, "^party(%d+)$") and ( not CT_RA_Stats[UnitName(arg1)] or not CT_RA_Stats[UnitName(arg1)]["Reporting"] ) ) then
			if ( CT_RA_IsReportingForParty() ) then
				local table = CT_RA_ScanPartyAuras(arg1);
				if ( table ) then
					for k, v in table do
						CT_RA_AddMessage(v);
					end
				end
				return;
			end
		end
	end
	if ( event == "UNIT_MANA" or event == "UNIT_MAXMANA" or event == "UNIT_RAGE" or event == "UNIT_MAXRAGE" or event == "UNIT_ENERGY" or event == "UNIT_MAXENERGY" ) then
		local _, _, id = string.find(arg1, "^raid(%d+)$");
		if ( id ) then
			CT_RA_UpdateUnitMana(getglobal("CT_RAMember" .. tonumber(id)));
		end
		return;
	end

	if ( event == "PLAYER_AURAS_CHANGED" ) then
		local msgs = CT_RA_ScanAuras();
		if ( msgs ) then
			for k, v in msgs do
				CT_RA_AddMessage(v);
			end
			return;
		end
	end

	if ( event == "UI_ERROR_MESSAGE" or event == "UI_INFO_MESSAGE" ) then
		if ( CT_RA_LastCast and (GetTime()-CT_RA_LastCast) <= 0.1 ) then
			if ( CT_RA_LastCastType == "debuff" ) then
				tinsert(CT_RA_BuffsToCure, 1, CT_RA_LastCastSpell);
			else
				tinsert(CT_RA_BuffsToRecast, 1, CT_RA_LastCastSpell);
			end
			CT_RA_LastCast = nil;
			CT_RA_LastCastSpell = nil;
		end
	end

	if ( event == "PLAYER_DEAD" ) then
		local msgs = CT_RA_ScanAuras();
		if ( msgs ) then
			for k, v in msgs do
				CT_RA_AddMessage(v);
			end
		end
	end


	if ( ( ( event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["Geddon_Status"] == 2 ) or ( event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" and CT_RAMenu_Options[CT_RAMenu_CurrSet]["Geddon_Status"] <= 2 ) ) then
		local iStart, iEnd, sPlayer, sType = string.find(arg1, "^([^%s]+) ([^%s]+) afflicted by Living Bomb");
		if ( sPlayer and sType ) then
			if ( sPlayer == "You" and sType == "are" ) then
				CT_RA_WarningFrame:AddMessage("YOU ARE THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
				CT_RA_WarningFrame:AddMessage("YOU ARE THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
				PlaySoundFile("Sound\\Doodad\\BellTollAlliance.wav");
			elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Geddon_Status"] == 2 ) then
				CT_RA_WarningFrame:AddMessage(sPlayer .. " IS THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
				PlaySoundFile("Sound\\Doodad\\BellTollAlliance.wav");
			end
		end
	end
end

function CT_RA_SendTargetInfo(num)
	if ( UnitExists("target") ) then
		local hasmana, friend, health, mana, name;
		if ( UnitManaMax("target") and UnitManaMax("target") > 0 and UnitPowerType("target") == 0 ) then
			hasmana = 1;
			mana = floor(UnitMana("target")/UnitManaMax("target")*100);
		else
			hasmana = 0;
			mana = -1;
		end
		health = floor(UnitHealth("target")/UnitHealthMax("target")*100);
		if ( UnitIsDead("target") ) then
			health = -1;
		end
		if ( UnitIsFriend("player", "target") ) then
			friend = 1;
		else
			friend = 0;
		end
		name = UnitName("target");
		CT_RA_AddMessage("TC " .. num .. " " .. hasmana .. " " .. friend .. " " .. health .. " " .. mana .. " " .. name);
	else
		CT_RA_AddMessage("LT " .. num);
	end
end

function CT_RA_ScanAuras()
	local currauras = { 
		["buffs"] = { },
		["debuffs"] = { }
	};

	local changed = {
		["newbuffs"] = { },
		["expiredbuffs"] = { },
		["newdebuffs"] = { },
		["expireddebuffs"] = { }
	};

	local returnstr = { };

	for i = 0, 23, 1 do
		local buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL");
		if ( buffIndex >= 0 ) then
			CT_RATooltip:SetPlayerBuff(buffIndex);
			local name = CT_RATooltipTextLeft1:GetText();
			if ( name ) then
				local useless, useless, texture = string.find(GetPlayerBuffTexture(buffIndex), "([%w_&]+)$");
				currauras["buffs"][name] = { ["texture"] = texture, ["timeleft"] = floor(GetPlayerBuffTimeLeft(buffIndex)+0.5) };
			end
		end

		local buffIndex, untilCancelled = GetPlayerBuff(i, "HARMFUL");
		if ( buffIndex >= 0 ) then
			CT_RATooltip:SetPlayerBuff(buffIndex);
			local name = CT_RATooltipTextLeft1:GetText();
			local type = CT_RATooltipTextRight1:GetText();
			if ( not type or not CT_RATooltipTextRight1:IsVisible() ) then type = nil; end
			if ( CT_RATooltipTextLeft1:IsVisible() and name ) then
				local useless, useless, texture = string.find(GetPlayerBuffTexture(buffIndex), "([%w_&]+)$");
				currauras["debuffs"][name] = { ["name"] = name, ["type"] = type, ["time"] = GetPlayerBuffTimeLeft(buffIndex), ["texture"] = texture };
			end
		end
	end

	-- Compare the tables
	for key, val in currauras["buffs"] do
		if ( not CT_RA_Auras["buffs"][key] ) then
			-- New buff
			CT_RA_BuffTimeLeft[key] = val["timeleft"];
			changed["newbuffs"][key] = val;
		else
			-- Remove
			CT_RA_Auras["buffs"][key] = nil;
		end

	end
	for key, val in currauras["debuffs"] do
		if ( not CT_RA_Auras["debuffs"][key] ) then
			-- New debuff
			changed["newdebuffs"][key] = val; -- Using val because this value is a table
		else
			-- Remove
			CT_RA_Auras["debuffs"][key] = nil;
		end
	end

	for key, val in CT_RA_Auras["buffs"] do
		changed["expiredbuffs"][key] = 1;
		CT_RA_BuffTimeLeft[key] = nil;
	end

	for key, val in CT_RA_Auras["debuffs"] do
		changed["expireddebuffs"][key] = 1;
	end

	for key, val in changed["newbuffs"] do
		tinsert(returnstr, "B " .. val["texture"] .. " " .. val["timeleft"] .. " " .. key);
	end
	for key, val in changed["newdebuffs"] do
		if ( not val["type"] ) then val["type"] = string.gsub(val["name"], " ", "_"); end
		tinsert(returnstr, "D " .. val["time"] .. " " .. val["texture"] .. " " .. val["type"] .. " " .. val["name"]);
	end
	for key, val in changed["expiredbuffs"] do
		tinsert(returnstr, "BE " .. key);
	end
	for key, val in changed["expireddebuffs"] do
		tinsert(returnstr, "DE " .. key);
	end
	CT_RA_Auras = currauras;
	return returnstr;
end

-----------------------------------------------------
--                  Update Functions               --
-----------------------------------------------------
	
-- Update health
function CT_RA_UpdateUnitHealth(frame)
	local id = "raid" .. frame:GetID();
	local percent = floor(UnitHealth(id) / UnitHealthMax(id) * 100);
	local maxHealth = UnitHealthMax(id);
	if ( percent and percent > 0 ) then
		if ( CT_RA_Stats[UnitName(id)] and CT_RA_Stats[UnitName(id)]["Ressed"] ) then
			CT_RA_Stats[UnitName(id)]["Ressed"] = nil;
			CT_RA_UpdateUnitDead(frame);
		end
		if ( percent > 100 ) then
			percent = 100;
		end
		getglobal(frame:GetName() .. "HPBar"):SetValue(percent);
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] == 1 and maxHealth ) then
			getglobal(frame:GetName() .. "Percent"):SetText(floor(percent/100*maxHealth) .. "/" .. maxHealth);
		elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] == 2 ) then
			getglobal(frame:GetName() .. "Percent"):SetText(percent .. "%");
		elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] == 3 ) then
			if ( maxHealth ) then
				local diff = floor(percent/100*maxHealth)-maxHealth;
				if ( diff == 0 ) then diff = ""; end
				getglobal(frame:GetName() .. "Percent"):SetText(diff);
			else
				getglobal(frame:GetName() .. "Percent"):SetText(percent-100 .. "%");
			end
		else
			getglobal(frame:GetName() .. "Percent"):Hide();
		end
		local hppercent = percent/100;
		local r, g;
		if ( hppercent > 0.5 and hppercent <= 1) then
			g = 1;
			r = (1.0 - hppercent) * 2;
		elseif ( hppercent >= 0 and hppercent <= 0.5 ) then
			r = 1.0;
			g = hppercent * 2;
		else
			r = 0;
			g = 1;
		end
		getglobal(frame:GetName() .. "HPBar"):SetStatusBarColor(r, g, 0);
	end
	local name = UnitName(id);
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] <= 3 and 
	( not UnitIsDead(id) and not UnitIsGhost(id) and UnitIsConnected(id) ) and 
	( not CT_RA_Stats[name] or ( not CT_RA_Stats[name]["Ressed"] and not CT_RA_Stats[name]["notready"] and not CT_RA_Stats[name]["Buffs"][CT_RA_FEIGNDEATH["en"]] and not CT_RA_Stats[name]["Buffs"][CT_RA_FEIGNDEATH["fr"]] and not CT_RA_Stats[name]["Buffs"][CT_RA_FEIGNDEATH["de"]] ) 
	and ( ( not CT_RA_Stats[name]["AFK"] and not CT_RA_Stats[name]["DND"] ) or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowAFK"] ) ) ) then
		getglobal(frame:GetName() .. "Percent"):Show();
	else
		getglobal(frame:GetName() .. "Percent"):Hide();
	end
end

-- Update status

function CT_RA_UpdateUnitStatus(class, frame, fileName, name, online)
	local height = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"];
	if ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) then
		height = height - 4;
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] ) then
		if ( height == 28 ) then
			getglobal(frame:GetName() .. "BuffButton1"):SetPoint("TOPRIGHT", frame:GetName(), "TOPRIGHT", -5, -5);
			getglobal(frame:GetName() .. "DebuffButton1"):SetPoint("TOPRIGHT", frame:GetName(), "TOPRIGHT", -5, -5);
		else
			getglobal(frame:GetName() .. "BuffButton1"):SetPoint("TOPRIGHT", frame:GetName(), "TOPRIGHT", -5, -3);
			getglobal(frame:GetName() .. "DebuffButton1"):SetPoint("TOPRIGHT", frame:GetName(), "TOPRIGHT", -5, -3);
		end
		getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOP", 2, -16);
		frame:SetBackdropBorderColor(1, 1, 1, 0);
		getglobal(frame:GetName() .. "HPBar"):SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 10, -19);
		frame:SetHeight(height-3);
		getglobal(frame:GetName() .. "CastFrame"):SetHeight(height-3);
		getglobal(frame:GetName() .. "CastFrame"):SetWidth(85);
	else
		getglobal(frame:GetName() .. "BuffButton1"):SetPoint("TOPRIGHT", frame:GetName(), "TOPRIGHT", -5, -5);
		getglobal(frame:GetName() .. "DebuffButton1"):SetPoint("TOPRIGHT", frame:GetName(), "TOPRIGHT", -5, -5);
		frame:SetBackdropBorderColor(1, 1, 1, 1);
		getglobal(frame:GetName() .. "HPBar"):SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 10, -22);
		getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOP", 2, -18);
		frame:SetHeight(height);
		getglobal(frame:GetName() .. "CastFrame"):SetHeight(height);
		getglobal(frame:GetName() .. "CastFrame"):SetWidth(90);
	end
	if ( height == 32 or height == 28 ) then
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
	else
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] < 4 ) then
			getglobal(frame:GetName() .. "Percent"):Show();
		else
			getglobal(frame:GetName() .. "Percent"):Hide();
		end
		getglobal(frame:GetName() .. "HPBar"):Show();
	end
	stats = CT_RA_Stats[name];
	if ( frame.group and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"][frame.group:GetID()] ) then
		frame:Show();
	end
	getglobal(frame:GetName() .. "Name"):SetText(UnitName("raid" .. frame:GetID()));
	CT_RA_UpdateUnitDead(frame);
	if ( stats and online ) then
		CT_RA_UpdateUnitBuffs(stats["Buffs"], frame, name);
	end
	if ( online ) then
		CT_RA_UpdateUnitHealth(frame);
		CT_RA_UpdateUnitMana(frame);
		if ( stats ) then
			CT_RA_UpdateUnitDebuffs(stats["Debuffs"], frame);
		end
	end
end

-- Update mana
function CT_RA_UpdateUnitMana(frame)
	local percent = floor(UnitMana("raid" .. frame:GetID()) / UnitManaMax("raid" .. frame:GetID()) * 100);
	getglobal(frame:GetName() .. "MPBar"):SetValue(percent);
end

-- Update buffs
function CT_RA_UpdateUnitBuffs(buffs, frame, nick)
	local num = 1;
	if ( buffs ) then
		-- Feign Death check
		local height = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"];
		for k, v in buffs do
			local en = CT_RA_FEIGNDEATH["en"];
			local de = CT_RA_FEIGNDEATH["de"];
			local fr = CT_RA_FEIGNDEATH["fr"];
			if ( ( en and k == en ) or ( de and k == de ) or ( fr and k == fr ) ) then
				-- Feign Death
				getglobal(frame:GetName() .. "Status"):Show();
				frame:SetBackdropColor(0.5, 0.5, 0.5, 1);
				getglobal(frame:GetName() .. "Status"):SetText(CT_RA_FEIGNDEATH[CT_RA_GetLocale()]);
				getglobal(frame:GetName() .. "HPBar"):Hide();
				getglobal(frame:GetName() .. "Percent"):Hide();
				getglobal(frame:GetName() .. "MPBar"):Hide();
				getglobal(frame:GetName() .. "Name"):SetTextColor(0.75, 0.75, 0.75);
				return;
			end
		end
		
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowDebuffs"] ) then
			for key, val in CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"] do
				local en, de, fr, name;
				if ( val["name"]["en"] ) then
					if ( type(val["name"]["en"]) == "string" ) then
						en = buffs[val["name"]["en"]];
						name = val["name"][CT_RA_GetLocale()];
					elseif ( buffs[val["name"]["en"][1]] ) then
						en = buffs[val["name"]["en"][1]];
						name = val["name"][CT_RA_GetLocale()][1];
					elseif ( buffs[val["name"]["en"][2]] ) then
						en = buffs[val["name"]["en"][2]];
						name = val["name"][CT_RA_GetLocale()][2];
					end
				end
				if ( val["name"]["de"] and not name ) then
					if ( type(val["name"]["de"]) == "string" ) then
						de = buffs[val["name"]["de"]];
						name = val["name"][CT_RA_GetLocale()];
					elseif ( buffs[val["name"]["de"][1]] ) then
						de = buffs[val["name"]["de"][1]];
						name = val["name"][CT_RA_GetLocale()][1];
					elseif ( buffs[val["name"]["de"][2]] ) then
						de = buffs[val["name"]["de"][2]];
						name = val["name"][CT_RA_GetLocale()][2];
					end
				end
				if ( val["name"]["fr"] and not name ) then
					if ( type(val["name"]["fr"]) == "string" ) then
						fr = buffs[val["name"]["fr"]];
						name = val["name"][CT_RA_GetLocale()];
					elseif ( buffs[val["name"]["fr"][1]] ) then
						fr = buffs[val["name"]["fr"][1]];
						name = val["name"][CT_RA_GetLocale()][1];
					elseif ( buffs[val["name"]["fr"][2]] ) then
						fr = buffs[val["name"]["fr"][2]];
						name = val["name"][CT_RA_GetLocale()][2];
					end
				end
				if ( num <= 4 and ( en or de or fr ) and val["show"] ~= -1 ) then -- Change 4 to number of buffs
					local tex, selected;
					if ( en ) then
						tex = en["texture"];
						selected = en;
					elseif ( de ) then
						tex = de["texture"];
						selected = de;
					elseif ( fr ) then
						tex = fr["texture"];
						selected = fr;
					end
					if ( not tex  ) then
						tex = selected[1];
					end
					getglobal(frame:GetName() .. "BuffButton" .. num .. "Icon"):SetTexture("Interface\\Icons\\" .. tex);
					getglobal(frame:GetName() .. "BuffButton" .. num).name = name;
					getglobal(frame:GetName() .. "BuffButton" .. num).owner = nick;
					getglobal(frame:GetName() .. "BuffButton" .. num).texture = tex;
					getglobal(frame:GetName() .. "BuffButton" .. num):Show();
					num = num + 1;
				end
			end
		end
	end
	for i = num, 4, 1 do -- Change 4 to number of buffs
		getglobal(frame:GetName() .. "BuffButton" .. i):Hide();
	end
end

function CT_RA_UpdateUnitDead(frame)
	local name, rank, subgroup, level, class, fileName, zone, online, dead = GetRaidRosterInfo(frame:GetID());
	local isDead, stats;
	stats = CT_RA_Stats[name];
	if ( UnitIsGhost("raid" .. frame:GetID()) or UnitIsDead("raid" .. frame:GetID()) ) then
		isDead = 1;
	end
	local height = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"];
	if ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) then
		height = height - 4;
	end
	if ( not online ) then
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideOffline"] ) then
			frame:Hide();
		end
		for i = 1, 4, 1 do
			if ( i <= 2 ) then
				getglobal(frame:GetName() .. "DebuffButton" .. i):Hide();
			end
			getglobal(frame:GetName() .. "BuffButton" .. i):Hide();
		end
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Status"):SetText("OFFLINE");
		getglobal(frame:GetName() .. "Status"):Show();
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.75, 0.75, 0.75);
		return;
	elseif ( stats and stats["notready"] ) then
		getglobal(frame:GetName() .. "Status"):Show();
		frame:SetBackdropColor(0.7, 0.45, 0.45, 1);
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Status"):SetText("Not Ready");
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.7, 0.45, 0.45);
	elseif ( stats and stats["Ressed"] ) then
		getglobal(frame:GetName() .. "Status"):Show();
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Status"):SetText("Resurrected");
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.5, 0.5, 0.5);
	elseif ( isDead ) then

		getglobal(frame:GetName() .. "Status"):Show();
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Status"):SetText("DEAD");
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.5, 0.5, 0.5);
	elseif ( stats and ( stats["AFK"] or stats["DND"] ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowAFK"] ) then
		getglobal(frame:GetName() .. "Status"):Show();
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) ) then
			frame:SetHeight(height+3);
		end
		if ( stats["AFK"] ) then
			getglobal(frame:GetName() .. "Status"):SetText("AFK");
		else
			getglobal(frame:GetName() .. "Status"):SetText("DND");
		end

		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.5, 0.5, 0.5);
	else
		frame:SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].b, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].a);
		local color = RAID_CLASS_COLORS[fileName];
		if ( color ) then
			getglobal(frame:GetName() .. "Name"):SetTextColor(color.r, color.g, color.b);
		end
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"] == 40 ) then
			getglobal(frame:GetName() .. "HPBar"):Show();
			if ( CT_RA_ShowHP and CT_RA_ShowHP < 4 ) then
				getglobal(frame:GetName() .. "Percent"):Show();
			end
		end
		getglobal(frame:GetName() .. "Status"):Hide();
		if ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) then
			getglobal(frame:GetName() .. "MPBar"):Show();
		else
			getglobal(frame:GetName() .. "MPBar"):Hide();
		end
		if ( class == CT_RA_WARRIOR ) then
			getglobal(frame:GetName() .. "MPBar"):SetStatusBarColor(1, 0, 0);
		elseif ( class == CT_RA_ROGUE ) then
			getglobal(frame:GetName() .. "MPBar"):SetStatusBarColor(1, 1, 0);
		else
			getglobal(frame:GetName() .. "MPBar"):SetStatusBarColor(0, 0, 1);
		end
	end
end

-- Update debuffs
function CT_RA_UpdateUnitDebuffs(debuffs, frame)
	local num = 1;
	local setbg = 0;
	local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(frame:GetID());
	if ( name and CT_RA_Stats[name] and online and not UnitIsGhost("raid" .. frame:GetID()) and not UnitIsDead("raid" .. frame:GetID()) ) then
		if ( not CT_RA_Stats[name]["Buffs"]["Feign Death"] and not CT_RA_Stats[name]["DND"] and not CT_RA_Stats[name]["AFK"] and not CT_RA_Stats[name]["Ressed"] and not CT_RA_Stats[name]["notready"] ) then
			frame:SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["r"], CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["g"], CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["b"], CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["a"]);
		end
		if ( debuffs ) then
			for key, val in CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"] do
				for k, v in debuffs do
					local en, de, fr;
					if ( type(val["type"]) == "table" ) then
						en = val["type"]["en"];
						de = val["type"]["de"];
						fr = val["type"]["fr"];
					else
						en = val["type"];
					end
					if ( ( ( en and en == v[1] ) or ( de and de == v[1] ) or ( fr and fr == v[1] ) ) and val["id"] ~= -1 and ( v[2] >= 10 or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideShort"] ) ) then
						if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowDebuffs"] and num <= 2 ) then
							getglobal(frame:GetName() .. "DebuffButton" .. num .. "Icon"):SetTexture("Interface\\Icons\\" ..v[3]);
							getglobal(frame:GetName() .. "DebuffButton" .. num).name = k;
							getglobal(frame:GetName() .. "DebuffButton" .. num).owner = nick;
							getglobal(frame:GetName() .. "DebuffButton" .. num).texture = v[3];
							
							getglobal(frame:GetName() .. "DebuffButton" .. num):Show();
							num = num + 1;
						end
						if ( setbg == 0 ) then
							frame:SetBackdropColor(val.r, val.g, val.b, val.a);
							setbg = 1;
						end
					end
				end
			end
		end
		for i = num, 2, 1 do
			getglobal(frame:GetName() .. "DebuffButton" .. i):Hide();
		end
	end
end

-- Get info

function CT_RA_UpdateUnit_GetInfo(arr, obj)
	local nick, stats, var, frame;
	if ( type(arr) == "string" ) then
		nick = arr;
		for i=1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( name == arr ) then
				var = { name, online, isDead, class, fileName };
				frame = getglobal("CT_RAMember" .. i);
				break;
			end
		end
	elseif ( type(arr) == "table" ) then
		frame = obj;
		var = arr;
		nick = arr[1];
	else
		return;
	end
	return var, nick, stats, frame;
end

function CT_RA_UpdateUnit(arr, obj)
	local nick, stats, var, frame;
	if ( type(arr) == "string" ) then
		nick = arr;
		for i=1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( name == arr ) then
				var = { name, online, isDead, class, fileName };
				frame = getglobal("CT_RAMember" .. i);
				break;
			end
		end
	elseif ( type(arr) == "table" ) then
		frame = obj;
		var = arr;
		nick = arr[1];
	else
		return;
	end
	if ( not frame ) then
		return;
	end
	stats = CT_RA_Stats[nick];
end

function CT_RA_SortClassArray(arr)

	local classValues = {
		[CT_RA_WARRIOR] = 8,
		[CT_RA_PALADIN] = 7,
		[CT_RA_DRUID] = 6,
		[CT_RA_MAGE] = 5,
		[CT_RA_WARLOCK] = 4,
		[CT_RA_ROGUE] = 3,
		[CT_RA_HUNTER] = 2,
		[CT_RA_PRIEST] = 1,
		[CT_RA_SHAMAN] = 0
	};

	-- A little more advanced BubbleSort algorithm

	local limit, st, j, temp, swapped;
	limit = getn(arr);
	st = 0;
	while ( st < limit ) do
		swapped = false;
		st = st + 1;
		limit = limit - 1;
		local val, val1;

		for j = st, limit, 1 do
			if ( arr[j]["class"] ) then
				val = classValues[arr[j]["class"]];
			else
				val = 0;
			end
			if ( arr[j+1]["class"] ) then
				val1 = classValues[arr[j+1]["class"]];
			else
				val1 = 0;
			end
			if ( val < val1 ) then
				temp = arr[j];
				arr[j] = arr[j+1];
				arr[j+1] = temp;
				swapped = true;
			end
		end
		if ( not swapped ) then return arr; end

		swapped = false;
		for j=limit, st, -1 do
			if ( arr[j]["class"] ) then
				val = classValues[arr[j]["class"]];
			else
				val = 0;
			end
			if ( arr[j+1]["class"] ) then
				val1 = classValues[arr[j+1]["class"]];
			else
				val1 = 0;
			end

			if ( val < val1 ) then
				temp = arr[j];
				arr[j] = arr[j+1];
				arr[j+1] = temp;
				swapped = true;
			end
		end
		if ( not swapped ) then return arr; end
	end
	return arr;
end

function CT_RA_UpdateMTs()
	CT_RAMTGroupGroupName:SetText("MT Targets");
	CT_RAMTGroup:Hide();
	CT_RAMTGroupGroupName:Hide();
	for i = 1, 5, 1 do
		getglobal("CT_RAMTGroupMember" .. i):Hide();
	end
	if ( GetNumRaidMembers() == 0 ) then return; end
	local hide = 1;
	for key, val in CT_RA_MainTanks do
		local height = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"];
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) then
			height = height - 4;
		end
		local frame = getglobal("CT_RAMTGroupMember" .. key);
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTs"][key] ) then
			local raidid, mtid;
			for i = 1, GetNumRaidMembers(), 1 do
				if ( UnitName("raid" .. i) == CT_RA_MainTanks[key] ) then
					raidid = "raid" .. i .. "target";
					mtid = "raid" .. i;
					break;
				end
			end
			local framecast = getglobal("CT_RAMTGroupMember" .. key .. "CastFrame");
			frame:SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["r"], CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["g"], CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["b"], CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["a"]);
			frame:GetParent():Show();
			frame:Show();
			if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] ) then
				getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOPLEFT", 47, -16);
				frame:SetBackdropBorderColor(1, 1, 1, 0);
				getglobal(frame:GetName() .. "HPBar"):SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 10, -19);
				frame:SetHeight(height-3);
				framecast:SetHeight(height-3);
				framecast:SetWidth(85);
			else
				frame:SetBackdropBorderColor(1, 1, 1, 1);
				getglobal(frame:GetName() .. "HPBar"):SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 10, -22);
				getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOPLEFT", 47, -18);
				frame:SetHeight(height);
				framecast:SetHeight(height);
				framecast:SetWidth(90);
			end
			if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNames"] ) then
				getglobal(frame:GetParent():GetName() .. "GroupName"):Show();
			else
				getglobal(frame:GetParent():GetName() .. "GroupName"):Hide();
			end
			if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockGroups"] ) then
				CT_RAMTGroupDrag:Show();
				hide = nil;
			end
			if ( raidid and UnitExists(raidid) ) then
				local health, healthmax, mana, manamax = UnitHealth(raidid), UnitHealthMax(raidid), UnitMana(raidid), UnitManaMax(raidid);
				getglobal(frame:GetName() .. "Name"):SetHeight(15);
				getglobal(frame:GetName() .. "Status"):Hide();
				getglobal(frame:GetName() .. "HPBar"):Show();
				getglobal(frame:GetName() .. "MPBar"):Show();
				getglobal(frame:GetName() .. "Name"):Show();
				if ( health and healthmax and not UnitIsDead(raidid) and not UnitIsGhost(raidid) ) then
					if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] ) then
						getglobal(frame:GetName() .. "Percent"):Show();
					else
						getglobal(frame:GetName() .. "Percent"):Hide();
					end
					
					getglobal(frame:GetName() .. "HPBar"):SetMinMaxValues(0, healthmax);
					getglobal(frame:GetName() .. "HPBar"):SetValue(health);
					
					getglobal(frame:GetName() .. "Percent"):SetText(floor(health/healthmax*100+0.5) .. "%");
					local percent = health/healthmax;
					if ( percent >= 0 and percent <= 1 ) then
						local r, g;
						if ( percent > 0.5 ) then
							g = 1;
							r = (1.0 - percent) * 2;
						else
							r = 1;
							g = percent * 2;
						end
						getglobal(frame:GetName() .. "HPBar"):SetStatusBarColor(r, g, 0);
					end
				elseif ( UnitIsDead(raidid) or UnitIsGhost(raidid) ) then
					getglobal(frame:GetName() .. "HPBar"):Hide();
					getglobal(frame:GetName() .. "Percent"):Hide();
					getglobal(frame:GetName() .. "MPBar"):Hide();
					getglobal(frame:GetName() .. "Status"):Show();
					getglobal(frame:GetName() .. "Status"):SetText("DEAD");
				else
					getglobal(frame:GetName() .. "HPBar"):Hide();
				end
				if ( UnitPowerType(raidid) == 0 and not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) then
					if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] ) then
						frame:SetHeight(37);
						framecast:SetHeight(37);
					else
						frame:SetHeight(40);
						framecast:SetHeight(40);
					end
					getglobal(frame:GetName() .. "MPBar"):Show();
					getglobal(frame:GetName() .. "MPBar"):SetMinMaxValues(0, manamax);
					getglobal(frame:GetName() .. "MPBar"):SetValue(mana);
				else
					getglobal(frame:GetName() .. "MPBar"):Hide();
					if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] ) then
						frame:SetHeight(33);
						framecast:SetHeight(33);
					else
						frame:SetHeight(36);
						framecast:SetHeight(36);
					end
				end
				getglobal(frame:GetName() .. "Name"):SetText(UnitName(raidid));
				getglobal(frame:GetName() .. "CastFrame").name = UnitName(raidid);
			else
				getglobal(frame:GetName() .. "Percent"):Hide();
				getglobal(frame:GetName() .. "HPBar"):Hide();
				getglobal(frame:GetName() .. "MPBar"):Hide();
				getglobal(frame:GetName() .. "Status"):Hide();
				getglobal(frame:GetName() .. "Name"):SetText("" .. val .. "'s Target");
				getglobal(frame:GetName() .. "Name"):SetHeight(30);
			end
		end
	end
	if ( hide ) then
		CT_RAMTGroupDrag:Hide();
	end
	CT_RA_UpdateMTTTs();
end

function CT_RA_AssistMTTT()
	local id = this.id;
	if ( not id ) then
		return;
	end
	if ( SpellIsTargeting() ) then
		SpellTargetUnit(id);
	else
		TargetUnit(id);
	end
end

function CT_RA_UpdateMTTTs()
	for key, val in CT_RA_MainTanks do
		local height = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"];
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) then
			height = height - 4;
		end
		local frame = getglobal("CT_RAMTGroupMember" .. key .. "MTTT");
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTTT"] ) then
			if ( CT_RA_MainTanks[key] ) then
				local raidid, mtid;
				for i = 1, GetNumRaidMembers(), 1 do
					if ( UnitName("raid" .. i) == CT_RA_MainTanks[key] ) then
						raidid = "raid" .. i .. "targettarget";
						mtid = "raid" .. i;
						break;
					end
				end
				frame:Show();
				local currHeight = frame:GetParent():GetHeight();
				if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] ) then
					getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOPLEFT", 47, -16);
					getglobal(frame:GetName() .. "HPBar"):SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 10, -19);
					frame:SetHeight(height-3);
				else
					getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOPLEFT", 47, -18);
					frame:SetHeight(height);
				end
				if ( raidid and UnitExists(raidid) ) then
					if ( not UnitIsUnit(mtid, raidid) and not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideColorChange"] ) then
						frame:GetParent():SetBackdropColor(1, 0, 0, 1);
					else
						frame:GetParent():SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].b, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].a);
					end
					local health, healthmax, mana, manamax = UnitHealth(raidid), UnitHealthMax(raidid), UnitMana(raidid), UnitManaMax(raidid);
					getglobal(frame:GetName() .. "CastFrame").id = raidid;
					getglobal(frame:GetName() .. "Name"):SetHeight(12);
					getglobal(frame:GetName() .. "Status"):Hide();
					getglobal(frame:GetName() .. "HPBar"):Show();
					getglobal(frame:GetName() .. "MPBar"):Show();
					getglobal(frame:GetName() .. "Name"):Show();
					if ( health and healthmax and not UnitIsDead(raidid) and not UnitIsGhost(raidid) ) then
						if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] ) then
							getglobal(frame:GetName() .. "Percent"):Show();
						else
							getglobal(frame:GetName() .. "Percent"):Hide();
						end
						getglobal(frame:GetName() .. "HPBar"):SetMinMaxValues(0, healthmax);
						getglobal(frame:GetName() .. "HPBar"):SetValue(health);
						getglobal(frame:GetName() .. "Percent"):SetText(floor(health/healthmax*100+0.5) .. "%");
						local percent = health/healthmax;
						if ( percent >= 0 and percent <= 1 ) then
							local r, g;
							if ( percent > 0.5 ) then
								g = 1;
								r = (1.0 - percent) * 2;
							else
								r = 1;
								g = percent * 2;
							end
							getglobal(frame:GetName() .. "HPBar"):SetStatusBarColor(r, g, 0);
						end
					elseif ( UnitIsDead(raidid) or UnitIsGhost(raidid) ) then
						getglobal(frame:GetName() .. "HPBar"):Hide();
						getglobal(frame:GetName() .. "Percent"):Hide();
						getglobal(frame:GetName() .. "MPBar"):Hide();
						getglobal(frame:GetName() .. "Status"):Show();
						getglobal(frame:GetName() .. "Status"):SetText("DEAD");
					else
						getglobal(frame:GetName() .. "HPBar"):Hide();
					end
					if ( UnitPowerType(raidid) == 0 and not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) then
						if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] ) then
							frame:SetHeight(37);
						else
							frame:SetHeight(40);
						end
						getglobal(frame:GetName() .. "MPBar"):Show();
						getglobal(frame:GetName() .. "MPBar"):SetMinMaxValues(0, manamax);
						getglobal(frame:GetName() .. "MPBar"):SetValue(mana);
					else
						getglobal(frame:GetName() .. "MPBar"):Hide();
						if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] ) then
							frame:SetHeight(33);
						else
							frame:SetHeight(36);
						end
					end
					getglobal(frame:GetName() .. "Name"):SetText(UnitName(raidid));
					if ( frame:GetHeight() > currHeight ) then
						frame:GetParent():SetHeight(frame:GetHeight());
					end
				else
					frame:GetParent():SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].b, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].a);
					frame:SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].b, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].a);
					getglobal(frame:GetName() .. "Percent"):Hide();
					getglobal(frame:GetName() .. "HPBar"):Hide();
					getglobal(frame:GetName() .. "MPBar"):Hide();
					getglobal(frame:GetName() .. "Status"):Hide();
					getglobal(frame:GetName() .. "Name"):SetText("<No Target>");
					getglobal(frame:GetName() .. "Name"):SetHeight(30);
				end
			end
			frame:GetParent():SetWidth(165);
			CT_RAMTGroupMember1:SetPoint("TOPLEFT", "CT_RAMTGroup", "TOPLEFT", -35, -20);
		else
			frame:Hide();
			frame:GetParent():SetWidth(90);
			CT_RAMTGroupMember1:SetPoint("TOPLEFT", "CT_RAMTGroup", "TOPLEFT", 0, -20);
		end
	end
end

function CT_RA_UpdateGroupVisibility(num)
	local group = getglobal("CT_RAGroup" .. num);
	if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"][num] or GetNumRaidMembers() == 0 or not group.next ) then
		group:Hide();
		getglobal("CT_RAGroupDrag" .. num):Hide();
	elseif ( group.next ) then
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockGroups"] ) then
			getglobal("CT_RAGroupDrag" .. num):Hide();
		else
			getglobal("CT_RAGroupDrag" .. num):Show();
		end
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNames"] ) then
			getglobal(group:GetName() .. "GroupName"):Hide();
		else
			getglobal(group:GetName() .. "GroupName"):Show();
		end
		group:Show();
	end
	while ( group.next ) do
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"][num] ) then
			group.next:Show();
		else
			group.next:Hide();
		end
		group = group.next;
	end
end

function CT_RA_UpdateVisibility()
	for i = 1, 8, 1 do
		CT_RA_UpdateGroupVisibility(i);
	end
	if ( CT_RA_MainTanks ) then
		CT_RA_UpdateMTs();
	end
end
			
function CT_RA_UpdateRaidGroup()
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "group" ) then
		CT_RA_SortByGroup();
	elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "custom" ) then
		CT_RA_SortByCustom();
	elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "class" ) then
		CT_RA_SortByClass();
	end
	local numRaidMembers = GetNumRaidMembers();
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local groups_showing = { };

	for i=1, MAX_RAID_MEMBERS do
		if ( i <= numRaidMembers ) then
			name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( UnitIsDead("raid" .. i) or UnitIsGhost("raid" .. i) ) then
				isDead = 1;
			end
			-- Set Rank
			if ( name == UnitName("player") ) then
				CT_RA_Level = rank;
			end
			local button = getglobal("CT_RAMember" .. i);
			local buttoncast = getglobal("CT_RAMember" .. i .. "CastFrame");
			local group = button.group;
			if ( group ) then

				if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"][group:GetID()] ) then
					if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockGroups"] ) then
						groups_showing[group:GetID()] = 1;
					end
					local height = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"];
					if ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] ) ) then
						height = height - 4;
					end

					getglobal(button:GetName() .. "Name"):SetText(name);
					getglobal(button:GetName() .. "CastFrame").name = name;
					CT_RA_UpdateUnitStatus(class, button, fileName, name, online);
				end
			end
		else
			getglobal("CT_RAMember" .. i):Hide();
			getglobal("CT_RAMember" .. i).next = nil;
		end
	end
	CT_RA_UpdateVisibility();
end

function CT_RA_MemberFrame_OnUpdate(elapsed)
	this.update = this.update - elapsed;
	if ( this.update <= 0 ) then
		this.update = 0.1;
		if ( this.cursor ) then
			if ( SpellIsTargeting() and ( strsub(this:GetParent():GetName(), 1, 12) == "CT_RAMTGroup" or SpellCanTargetUnit("raid" .. this:GetParent():GetParent():GetID()) ) ) then
				SetCursor("CAST_CURSOR");
			elseif ( SpellIsTargeting() ) then
				SetCursor("CAST_ERROR_CURSOR");
			end
		end
	end
end

function CT_RA_MemberFrame_OnEnter()
	if ( SpellIsTargeting() ) then
		SetCursor("CAST_CURSOR");
	end
	local id = this:GetParent():GetParent():GetID();
	if ( strsub(this:GetParent():GetName(), 1, 12) == "CT_RAMTGroup" ) then
		local name;
		if ( CT_RA_MainTanks[id] ) then
			name = CT_RA_MainTanks[id];
		end
		for i = 1, 40, 1 do
			local memberName = GetRaidRosterInfo(i);
			if ( name == memberName ) then
				id = i;
				break;
			end
		end
	elseif ( not SpellCanTargetUnit("raid" .. id) and SpellIsTargeting() ) then
		SetCursor("CAST_ERROR_CURSOR");
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideTooltip"] ) then
		return;
	end

	local xp = "LEFT";
	local yp = "BOTTOM";
	local xthis, ythis = this:GetCenter();
	local xui, yui = UIParent:GetCenter();
	if ( xthis < xui ) then
		xp = "RIGHT";
	end
	if ( ythis < yui ) then
		yp = "TOP";
	end
	GameTooltip:SetOwner(this, "ANCHOR_" .. yp .. xp);

	local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(id);
	local version = CT_RA_Stats[name];
	if ( version ) then
		version = version["Version"];
	end
	if ( name == UnitName("player") ) then
		zone = GetRealZoneText();
		version = CT_RA_VersionNumber;
	end
	local color = RAID_CLASS_COLORS[fileName];
	GameTooltip:AddDoubleLine(name, level, color.r, color.g, color.b, 1, 1, 1);
	GameTooltip:AddLine(UnitRace("raid"..id) .. " " .. class, 1, 1, 1);
	GameTooltip:AddLine(zone, 1, 1, 1);
	
	if ( not version ) then
		if ( not CT_RA_Stats[name] or not CT_RA_Stats[name]["Reporting"] ) then
			GameTooltip:AddLine("No CTRA Found", 0.7, 0.7, 0.7);
		else
			GameTooltip:AddLine("CTRA <1.077", 1, 1, 1);
		end
	else
		GameTooltip:AddLine("CTRA " .. version, 1, 1, 1);
	end

	if ( CT_RA_Stats[name] and CT_RA_Stats[name]["AFK"] ) then
		if ( type(CT_RA_Stats[name]["AFK"][1]) == "string" ) then
			GameTooltip:AddLine("AFK: " .. CT_RA_Stats[name]["AFK"][1]);
		end
		GameTooltip:AddLine("AFK for " .. CT_RA_FormatTime(CT_RA_Stats[name]["AFK"][2]));
	elseif ( CT_RA_Stats[name] and CT_RA_Stats[name]["DND"] ) then
		if ( type(CT_RA_Stats[name]["DND"][1]) == "string" ) then
			GameTooltip:AddLine("DND: " .. CT_RA_Stats[name]["DND"][1]);
		end
		GameTooltip:AddLine("DND for " .. CT_RA_FormatTime(CT_RA_Stats[name]["DND"][2]));
	end
	GameTooltip:Show();
	this.cursor = 1;
end

function CT_RA_FormatTime(num)
	num = floor(num + 0.5);
	local hour, min, sec, str = 0, 0, 0, "";

	hour = floor(num/3600);
	min = floor(mod(num, 3600)/60);
	sec = mod(num, 60);
	
	if ( hour > 0 ) then
		str = hour .. "h";
	end

	if ( min > 0 ) then
		if ( strlen(str) > 0 ) then
			str = str .. ", ";
		end
		str = str .. min .. "m";
	end

	if ( sec > 0 or strlen(str) == 0 ) then
		if ( strlen(str) > 0 ) then
			str = str .. ", ";
		end
		str = str .. sec .. "s";
	end
	return str;

end


function CT_RA_Drag_OnEnter()
	if ( this:GetCenter() < UIParent:GetCenter() ) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	else
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	end
	GameTooltip:SetText("Click to drag");
end

function CT_RA_BuffButton_OnEnter()
	if ( CT_RA_LockPosition ) then return; end
	if ( this:GetCenter() < UIParent:GetCenter() ) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	else
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	end
	local left;
	if ( CT_RA_Stats[this.owner] and CT_RA_Stats[this.owner]["Buffs"][this.name] and CT_RA_Stats[this.owner]["Buffs"][this.name][2] ) then
		left = CT_RA_Stats[this.owner]["Buffs"][this.name][2];
	end
	if ( this.name and left ) then
		local str;
		if ( left >= 60 ) then
			secs = mod(left, 60);
			mins = (left-secs)/60;
		else
			mins = 0;
			secs = left;
		end
		if ( mins < 10 ) then mins = "0" .. mins; end
		if ( secs < 10 ) then secs = "0" .. secs; end
		GameTooltip:SetText(this.name .. " (" .. mins .. ":" .. secs .. ")");
	elseif ( this.name ) then
		GameTooltip:SetText(this.name);
	end
end

function CT_RA_AssistMT(id)
	if ( CT_RA_MainTanks[id] ) then
		for i = 1, GetNumRaidMembers(), 1 do
			if (  UnitName("raid" .. i) == CT_RA_MainTanks[id] ) then
				AssistUnit("raid" .. i);
				return;
			end
		end
	end
end

function CT_RA_MemberFrame_OnClick(button)
	local id = this:GetParent():GetParent():GetID();
	local assistMT = false;
	if ( strsub(this:GetParent():GetName(), 1, 12) == "CT_RAMTGroup" ) then
		for i = 1, GetNumRaidMembers(), 1 do
			if (  UnitName("raid" .. i) == CT_RA_MainTanks[id] ) then
				AssistUnit("raid" .. i);
				return;
			end
		end
		assistMT = true;
	end
	
	local stopDefaultBehaviour;
	if ( type(CT_RA_CustomOnClickFunction) == "function" ) then
		stopDefaultBehaviour = CT_RA_CustomOnClickFunction(button, "raid" .. id);
	end
	if ( not stopDefaultBehaviour ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("raid" .. id);
		else
			TargetUnit("raid" .. id);
		end
	end
end

function CT_RA_SendStatus()
	CT_RA_Auras = { 
		["buffs"] = { },
		["debuffs"] = { }
	}; -- Reset everything so every buff & debuff is treated as new
	local arr = CT_RA_ScanAuras();
	for key, val in arr do
		CT_RA_AddMessage(val);
	end
	CT_RA_AddMessage("V " .. CT_RA_VersionNumber);
	for k, v in CT_RA_MainTanks do
		if ( v == UnitName("player") ) then
			CT_RA_AddMessage("SET " .. k .. " " .. v);
			CT_RA_SendTargetInfo(k);
			break;
		end
	end
end

function CT_RA_Onyxia_OnEvent(event)
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Onyxia_Status"] == 0 ) then return; end
	if ( event == "CHAT_MSG_MONSTER_EMOTE" and arg1 == "takes in a deep breath..." ) then
		if ( CT_RA_AddMessage and CT_RA_Level >= 1 ) then
			CT_RA_AddMessage("MS " .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["Onyxia_Text"]);
		end
		SendChatMessage(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Onyxia_Text"], "RAID");
	end
end

function CT_RA_CureLastDebuff()
	local debuff = CT_RA_GetDebuff();
	if ( not debuff ) then return; end

	-- Check to make sure the player is debuffed with selected
	if ( CT_RA_Stats[UnitName(debuff["nick"])] ) then
		local found;
		for k, v in CT_RA_Stats[UnitName(debuff["nick"])]["Debuffs"] do
			if ( v[1] == debuff["type"] ) then
				found = 1;
			end
		end
		if ( not found ) then 
			return;
		end
	else
		return;
	end

	local cure = CT_RA_GetCure(debuff["type"]);
	if ( cure ) then

		CT_RA_LastCastSpell = debuff;
		CT_RA_LastCast = GetTime();
		CT_RA_LastCastType = "debuff";
		local i, targetunit, targetname;
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["MaintainTarget"] ) then
			-- Check parties
			if ( UnitExists("target") ) then
				for i = 1, 40, 1 do
					if ( UnitIsUnit("raid" ..i, "target") ) then
						targetunit = "raid" .. i;
						break;
					end
				end
				if ( UnitIsUnit("target", "pet" ) ) then
					targetunit = "pet";
				elseif ( UnitIsUnit("target", "player" ) ) then
					targetunit = "player";
				elseif ( UnitIsFriend("player", "target") ) then
					targetunit = "friend";
					targetname = UnitName("target");
				else
					targetunit = "lastenemy";
				end
			end
	
			TargetUnit(debuff["nick"])
			if ( not UnitIsUnit("target", debuff["nick"]) ) then
				if ( targetunit ) then
					if ( targetunit == "lastenemy" ) then
						TargetLastEnemy();
					elseif ( targetunit == "friend" ) then
						TargetByName(targetname);
					else
						TargetUnit(targetunit);
					end
				else
					ClearTarget();
				end
				return;
			end
		else
			TargetUnit(debuff["nick"]);
		end
		if ( UnitIsUnit("target", debuff["nick"]) ) then
			CastSpell(CT_RA_ClassSpells[cure]["spell"], CT_RA_ClassSpells[cure]["tab"]+1);
		end
		if ( SpellIsTargeting() and not SpellCanTargetUnit("target") ) then
			SpellStopTargeting();
			
		elseif ( SpellIsTargeting() and SpellCanTargetUnit("target") ) then
			SpellStopTargeting();
			tinsert(CT_RA_BuffsToCure, 1, debuff);
		end
		if ( targetunit and CT_RAMenu_Options[CT_RAMenu_CurrSet]["MaintainTarget"] ) then
			if ( targetunit == "lastenemy" ) then
				TargetLastEnemy();
			elseif ( targetunit == "friend" ) then
				TargetByName(targetname);
			else
				TargetUnit(targetunit);
			end
		elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["MaintainTarget"] ) then
			ClearTarget();
		end
	end
end


function CT_RA_AddToQueue(type, nick, name)
	tinsert(CT_RA_BuffsToCure, { ["type"] = type, ["nick"] = nick, ["name"] = name });
end

function CT_RA_GetDebuff()
	return tremove(CT_RA_BuffsToCure);
end

function CT_RA_GetCure(school)
	local lang = CT_RA_GetLocale();
	local arr = {
		[CT_RA_PRIEST] = { [CT_RA_MAGIC[lang]] = CT_RA_DISPELMAGIC[lang], [CT_RA_DISEASE[lang]] = { CT_RA_CUREDISEASE[lang], CT_RA_ABOLISHDISEASE[lang] } },
		[CT_RA_SHAMAN] = { [CT_RA_DISEASE[lang]] = CT_RA_CUREDISEASE[lang], [CT_RA_POISON[lang]] = CT_RA_CUREPOISON[lang] },
		[CT_RA_DRUID] = { [CT_RA_CURSE[lang]] = CT_RA_REMOVECURSE[lang], [CT_RA_POISON[lang]] = { CT_RA_CUREPOISON[lang], CT_RA_ABOLISHPOISON[lang] } },
		[CT_RA_MAGE] = { [CT_RA_CURSE[lang]] = CT_RA_REMOVELESSERCURSE[lang] },
		[CT_RA_PALADIN] = { [CT_RA_MAGIC[lang]] = CT_RA_CLEANSE[lang], [CT_RA_POISON[lang]] = { CT_RA_PURIFY[lang], CT_RA_CLEANSE[lang] }, [CT_RA_DISEASE[lang]] = { CT_RA_PURIFY[lang], CT_RA_CLEANSE[lang] } }
	};

	if ( arr[UnitClass("player")] and arr[UnitClass("player")][school] ) then
		local tmp = arr[UnitClass("player")][school];
		if ( type(tmp) == "table" ) then
			for i = getn(tmp), 1, -1 do
				if ( CT_RA_ClassSpells[tmp[i]] ) then
					return tmp[i];
				end
			end
			return nil;
		else
			if ( CT_RA_ClassSpells[tmp] ) then
				return tmp;
			else
				return nil;
			end
		end
	end
	return nil;
end

function CT_RA_UpdateRaidGroupColors()
	for y = 1, 40, 1 do
		if ( y <= 5 ) then
			getglobal("CT_RAMTGroupMember" .. y):SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].b, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].a);
			getglobal("CT_RAMTGroupMember" .. y .. "Percent"):SetTextColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].b);
		end
		getglobal("CT_RAMember" .. y):SetBackdropColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].b, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].a);
		getglobal("CT_RAMember" .. y .. "Percent"):SetTextColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].b);
		if ( CT_RA_Stats[UnitName("raid"..y)] ) then
			CT_RA_UpdateUnitDebuffs(CT_RA_Stats[UnitName("raid"..y)]["Debuffs"], getglobal("CT_RAMember"..y));
		end
	end
end

function CT_RA_UpdateRaidMovability()
	for i = 1, 8, 1 do
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockGroups"] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"][i] ) then
			getglobal("CT_RAGroupDrag" .. i):Hide();
		else
			if ( getglobal("CT_RAGroup" .. i).next ) then
				getglobal("CT_RAGroupDrag" .. i):Show();
			end
		end
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockGroups"] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTs"] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTs"][i] ) then
		getglobal("CT_RAMTGroupDrag"):Hide();
	else
		for i = 1, 5, 1 do
			if ( CT_RA_MainTanks[i] ) then
				CT_RAMTGroupDrag:Show();
				break;
			else
				CT_RAMTGroupDrag:Hide();
			end
		end
	end
end

function CT_RA_AddToBuffQueue(name, nick)
	tinsert(CT_RA_BuffsToRecast, { ["name"] = name, ["nick"] = nick });
end

function CT_RA_GetBuff()
	return tremove(CT_RA_BuffsToRecast);
end

function CT_RA_RecastLastBuff()
	local buff = CT_RA_GetBuff();
	
	while ( buff ) do
		if ( CT_RA_Stats[UnitName(buff["nick"])] and CT_RA_Stats[UnitName(buff["nick"])]["Buffs"][buff["name"]] ) then
			buff = CT_RA_GetBuff();
		else
			CT_RA_LastCastSpell = buff;
			CT_RA_LastCast = GetTime();
			CT_RA_LastCastType = "buff";
			local couldNotCast;
			local i, targetunit, targetname;
			if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["MaintainTarget"] ) then
				-- Check parties
				if ( UnitExists("target") ) then
					for i = 1, 40, 1 do
						if ( UnitIsUnit("raid" ..i, "target") ) then
							targetunit = "raid" .. i;
							break;
						end
					end
					if ( UnitIsUnit("target", "pet" ) ) then
						targetunit = "pet";
					elseif ( UnitIsUnit("target", "player" ) ) then
						targetunit = "player";
					elseif ( UnitIsFriend("player", "target") ) then
						targetunit = "friend";
						targetname = UnitName("target");
					else
						targetunit = "lastenemy";
					end
				end
				TargetUnit(buff["nick"]);
				if ( not UnitIsUnit("target", buff["nick"]) ) then
					if ( targetunit ) then
						if ( targetunit == "lastenemy" ) then
							TargetLastEnemy();
						elseif ( targetunit == "friend" ) then
							TargetByName(targetname);
						else
							TargetUnit(targetunit);
						end
					else
						ClearTarget();
					end
					return;
				end
			else
				TargetUnit(buff["nick"]);
			end
			if ( UnitIsUnit("target", buff["nick"]) ) then
				CastSpell(CT_RA_ClassSpells[buff["name"]]["spell"], CT_RA_ClassSpells[buff["name"]]["tab"]+1);
			end
			if ( SpellIsTargeting() and not SpellCanTargetUnit(buff["nick"]) ) then
				SpellStopTargeting();
				couldNotCast = 1;
			elseif ( SpellIsTargeting() and SpellCanTargetUnit(buff["nick"]) ) then
				SpellStopTargeting();
				tinsert(CT_RA_BuffsToRecast, 1, buff);
			end
			if ( targetunit and CT_RA_MaintainTarget ) then
				if ( targetunit == "lastenemy" ) then
					TargetLastEnemy();
				elseif ( targetunit == "friend" ) then
					TargetByName(targetname);
				else
					TargetUnit(targetunit);
				end
			elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["MaintainTarget"] ) then
				ClearTarget();
			end
			break;
		end
		buff = couldNotCast;
	end
end

function CT_RA_Print(msg, r, g, b)
	if ( SIMPLE_CHAT == "1" ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	else
		event = "CHAT_MSG_CTRAID";
		arg1 = msg;
		arg2, arg3, arg4, arg6 = "", "", "", "";
		local info = CT_RA_ChatInfo["Default"];
		if ( CT_RA_ChatInfo[UnitName("player")] ) then
			info = CT_RA_ChatInfo[UnitName("player")];
		end
		for i = 1, 7, 1 do
			for k, v in info["show"] do
				if ( v == "ChatFrame" .. i ) then
					this = getglobal("ChatFrame" .. i);
					CT_RA_oldChatFrame_OnEvent(event);
				end
			end
		end
	end
end

function CT_RA_SortByClass()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "class";
	CT_RA_ButtonIndexes = { };
	CT_RA_CurrPositions = { };
	local groupnum = 1;
	local membernum = 1;
	
	for k, v in CT_RA_ClassPositions do
		if ( k ~= CT_RA_SHAMAN or ( UnitFactionGroup("player") and UnitFactionGroup("player") == "Horde" ) ) then
			getglobal("CT_RAOptionsGroup" .. v .. "Label"):SetText(k);
		end
	end
	for i = 1, 40, 1 do
		if ( i <= 8 ) then
			getglobal("CT_RAGroup" .. i).next = nil;
			getglobal("CT_RAGroup" .. i).num = 0;
		end
		getglobal("CT_RAMember" .. i).next = nil;
	end
	for i = 1, GetNumRaidMembers(), 1 do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
		if ( class and CT_RA_ClassPositions[class] ) then
			local group = getglobal("CT_RAGroup" .. CT_RA_ClassPositions[class]);
			CT_RA_CurrPositions[i] = CT_RA_ClassPositions[class];
			local button = getglobal("CT_RAMember" .. i);
			getglobal(group:GetName() .. "GroupName"):SetText(class);
			local modifier = 0.5;
			if ( not online ) then
				modifier = 0.3;
			end
			getglobal("CT_RAOptionsGroupButton" .. i .."Texture"):SetVertexColor(modifier, modifier, modifier);
			getglobal("CT_RAOptionsGroupButton" .. i .."Rank"):SetTextColor(modifier, modifier, modifier);
			getglobal("CT_RAOptionsGroupButton" .. i .."Name"):SetTextColor(modifier, modifier, modifier);
			getglobal("CT_RAOptionsGroupButton" .. i .."Level"):SetTextColor(modifier, modifier, modifier);
			getglobal("CT_RAOptionsGroupButton" .. i .."Class"):SetTextColor(modifier, modifier, modifier);
			if ( ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideOffline"] or online ) and ( CT_RA_Stats[name] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNA"] ) ) then
				button:ClearAllPoints();
				local new;
				if ( group.next and group.next ~= button ) then
					new = group;
					while ( new.next ) do
						if ( new.next ) then
							new = new.next;
						end
					end
					group.num = group.num + 1;
					button:SetPoint("TOPLEFT", new:GetName(), "BOTTOMLEFT", 0, 4);
				else
					group.num = 1;
					new = group;
					button:SetPoint("TOPLEFT", group:GetName(), "TOPLEFT", 0, -20);
				end
				new.next = button;
				button.group = group;
			end
		end
	end
end

function CT_RA_SortByGroup()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "group";
	CT_RA_ButtonIndexes = { };
	CT_RA_CurrPositions = { };
	local groupnum = 1;
	local membernum = 1;
	for i = 1, 40, 1 do
		if ( i <= 8 ) then
			getglobal("CT_RAGroup" .. i).next = nil;
			getglobal("CT_RAGroup" .. i).num = 0;
			if ( getglobal("CT_RAOptionsGroup" .. i .. "Label") ) then
				getglobal("CT_RAOptionsGroup" .. i .. "Label"):SetText("Group " .. i);
			end
		end
		getglobal("CT_RAMember" .. i).next = nil;
	end
	for i = 1, GetNumRaidMembers(), 1 do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
		if ( ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideOffline"] or online ) and ( CT_RA_Stats[name] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNA"] ) ) then
			local groupid = subgroup;
			if ( CT_RA_CurrPositions[i] ) then
				groupid = CT_RA_CurrPositions[i];
			else
				CT_RA_CurrPositions[i] = subgroup;
			end
			local group = getglobal("CT_RAGroup" .. groupid);
			getglobal(group:GetName() .. "GroupName"):SetText("Group " .. subgroup);
			if ( getglobal("CT_RAOptionsGroupButton" .. i .."Texture") ) then
				getglobal("CT_RAOptionsGroupButton" .. i .."Texture"):SetVertexColor(1.0, 1.0, 1.0);
			end

			local button = getglobal("CT_RAMember" .. i);
			local new;
			if ( group.next and group.next ~= button ) then
				new = group;
				while ( new.next ) do
					if ( new.next ) then
						new = new.next;
					end
				end
				group.num = group.num + 1;
				button:SetPoint("TOPLEFT", new:GetName(), "BOTTOMLEFT", 0, 4);
			else
				group.num = 1;
				new = group;
				button:SetPoint("TOPLEFT", group:GetName(), "TOPLEFT", 0, -20);
			end
			new.next = button;
			button.group = group;
		end
	end
end

function CT_RA_SortByCustom()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "custom";
	local groupnum = 1;
	local membernum = 1;
	for i = 1, 40, 1 do
		if ( i <= 8 ) then
			getglobal("CT_RAGroup" .. i).next = nil;
			getglobal("CT_RAGroup" .. i).num = 0;
			getglobal("CT_RAOptionsGroup" .. i .. "Label"):SetText("Custom " .. i);
		end
		getglobal("CT_RAMember" .. i).next = nil;
	end
	for i = 1, GetNumRaidMembers(), 1 do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
		if ( getglobal("CT_RAOptionsGroupButton" .. i .."Texture") ) then
			getglobal("CT_RAOptionsGroupButton" .. i .."Texture"):SetVertexColor(1.0, 1.0, 1.0);
		end
		if ( ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideOffline"] or online ) and ( CT_RA_Stats[name] or not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNA"] ) ) then
			if ( CT_RA_CurrPositions[i] ) then
				subgroup = CT_RA_CurrPositions[i];
			else
				for y = 1, 8, 1 do
					if ( not getglobal("CT_RAGroup" .. y).num or getglobal("CT_RAGroup" .. y).num < 5 ) then
						subgroup = y;
						CT_RA_CurrPositions[i] = y;
						break;
					end
				end
			end

			local group = getglobal("CT_RAGroup" .. subgroup);
			local button = getglobal("CT_RAMember" .. i);
			getglobal(group:GetName() .. "GroupName"):SetText("Custom " .. subgroup);
			button:ClearAllPoints();
			local new;
			if ( group.next and group.next ~= button ) then
				new = group;
				while ( new.next ) do
					if ( new.next ) then
						new = new.next;
					end
				end
				group.num = group.num + 1;
				button:ClearAllPoints();
				button:SetPoint("TOPLEFT", new:GetName(), "BOTTOMLEFT", 0, 4);
			else
				group.num = 1;
				new = group;
				button:ClearAllPoints();
				button:SetPoint("TOPLEFT", group:GetName(), "TOPLEFT", 0, -20);
			end
			new.next = button;
			button.group = group;
		end
	end
end

function CT_RA_LinkDrag(frame, drag, point, relative, x, y)
	frame:ClearAllPoints();
	frame:SetPoint(point, drag:GetName(), relative, x, y);
end

CT_RA_ConvertedRaid = 1;
CT_RA_HasInvited = { };

function CT_RA_SendMTs()
	for k, v in CT_RA_MainTanks do
		if ( UnitName("player") == v ) then
			-- Player is a main tank
			CT_RA_AddMessage("SET " .. k .. " " .. v);
			if ( UnitExists("target") ) then
				local hasmana, friend, health, mana, name;
				if ( UnitManaMax("target") and UnitManaMax("target") > 0 and UnitPowerType("target") == 0 ) then
					hasmana = 1;
					mana = floor(UnitMana("target")/UnitManaMax("target")*100);
				else
					hasmana = 0;
					mana = -1;
				end
				health = floor(UnitHealth("target")/UnitHealthMax("target")*100);
				if ( UnitIsDead("target") ) then
					health = -1;
				end
				if ( UnitIsFriend("player", "target") ) then
					friend = 1;
				else
					friend = 0;
				end
				name = UnitName("target");
				CT_RA_AddMessage("TC " .. k .. " " .. hasmana .. " " .. friend .. " " .. health .. " " .. mana .. " " .. name);
				break;
			else
				CT_RA_AddMessage("LT " .. k);
			end
		end
	end
end

local CT_RA_GameTooltip_ClearMoney;

local function CT_RA_MoneyToggle()
	if( CT_RA_GameTooltip_ClearMoney ) then
		GameTooltip_ClearMoney = CT_RA_GameTooltip_ClearMoney;
		CT_RA_GameTooltip_ClearMoney = nil;
	else
		CT_RA_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
		GameTooltip_ClearMoney = CT_RA_GameTooltipFunc_ClearMoney;
	end
end

function CT_RA_GameTooltipFunc_ClearMoney()

end

function CT_RA_GetBuffIndex(name, filter)
	local i = 0;
	if ( filter == "HELPFUL" ) then
		local buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL");
		while ( buffIndex ~= -1 ) do
			CT_RA_MoneyToggle();
			CT_RATooltip:SetPlayerBuff(buffIndex);
			CT_RA_MoneyToggle();
			local tooltipName = CT_RATooltipTextLeft1:GetText();
			if ( tooltipName and name == tooltipName ) then
				return buffIndex;
			end
			i = i + 1;
			buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL");
		end
	else
		local buffIndex, untilCancelled = GetPlayerDebuff(i, "HARMFUL");
		while ( buffIndex ~= -1 ) do
			CT_RA_MoneyToggle();
			CT_RATooltip:SetPlayerDebuff(buffIndex);
			CT_RA_MoneyToggle();
			local tooltipName = CT_RATooltipTextLeft1:GetText();
			if ( tooltipName and name == tooltipName ) then
				return buffIndex;
			end
			i = i + 1;
			buffIndex, untilCancelled = GetPlayerDebuff(i, "HELPFUL");
		end
	end
	return nil;
end
	

function CT_RA_UpdateFrame_OnUpdate(elapsed)
	this.updateAFK = this.updateAFK + elapsed;
	if ( this.updateAFK >= 1 ) then
		this.updateAFK = this.updateAFK - 1;
		for k, v in CT_RA_Stats do
			if ( v["AFK"] ) then
				v["AFK"][2] = v["AFK"][2] + 1;
			end
			if ( v["DND"] ) then
				v["DND"][2] = v["DND"][2] + 1;
			end
		end
	end

	this.update = this.update + elapsed;
	if ( this.update >= 1 ) then
		for k, v in CT_RA_BuffTimeLeft do
			local buffIndex, buffTimeLeft, buffTexture;
			buffIndex = CT_RA_GetBuffIndex(k, "HELPFUL");
			if ( buffIndex ) then
				buffTimeLeft = GetPlayerBuffTimeLeft(buffIndex);
				buffTexture = GetPlayerBuffTexture(buffIndex);
				if ( buffTimeLeft and buffTexture ) then
					if ( abs(CT_RA_BuffTimeLeft[k]-buffTimeLeft) >= 2 ) then
						local useless, useless, texture = string.find(buffTexture, "([%w_&]+)$");
						CT_RA_AddMessage("B " .. texture .. " " .. floor(buffTimeLeft+0.5) .. " " .. k);
					end
					CT_RA_BuffTimeLeft[k] = buffTimeLeft;
				end
			end
		end
		for k, v in CT_RA_Stats do
			if ( v["Buffs"] ) then
				for key, val in v["Buffs"] do
					if ( type(val) == "table" and val[2] ) then
						val[2] = val[2] - 1;
						if ( val[2] <= 0 ) then
							CT_RA_Stats[k]["Buffs"][key] = nil;
						end
					end
				end
			end
		end
		this.update = this.update - 1;
	end
	if ( this.time ) then
		this.time = this.time - elapsed;
		if ( this.time <= 0 ) then
			if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
				this.time = nil;
				CT_RA_AddMessage("SR");
			else
				this.time = 5;
			end
		end
		if ( this.SS ) then
			this.SS = nil;
		end
	end
	if ( this.invite ) then
		this.invite = this.invite - elapsed;
		if ( this.invite <= 0 ) then
			if ( not CT_RA_ConvertedRaid ) then
				CT_RA_ConvertedRaid = 1;
				ConvertToRaid();
				this.invite = 3;
			else
				CT_RA_InviteGuild(CT_RA_MinLevel, CT_RA_MaxLevel);
				this.invite = nil;
			end
		end
	end
	if ( this.startinviting ) then
		this.startinviting = this.startinviting - elapsed;
		if ( this.startinviting <= 0 ) then
			this.startinviting = nil;
			CT_RA_HasInvited = { };
			if ( GetNumRaidMembers() == 0 ) then
				CT_RA_ConvertedRaid = nil;
			else
				CT_RA_ConvertedRaid = 1;
			end
			CT_RA_InviteGuild(CT_RA_MinLevel, CT_RA_MaxLevel);
			if ( CT_RA_MinLevel == CT_RA_MaxLevel ) then
				CT_RA_Print("<CTRaid> Guild Members of level |c00FFFFFF" .. CT_RA_MinLevel .. "|r have been invited.", 1, 0.5, 0);
			else
				CT_RA_Print("<CTRaid> Guild Members of levels |c00FFFFFF" .. CT_RA_MinLevel .. "|r to |c00FFFFFF" .. CT_RA_MaxLevel .. "|r have been invited.", 1, 0.5, 0);
			end
		end
	end
	if ( this.closeroster ) then
		this.closeroster = this.closeroster - elapsed;
		if ( this.closeroster <= 0 ) then
			HideUIPanel(FriendsFrame);
			this.closeroster = nil;
		end
	end

	if ( this.SS ) then
		this.SS = this.SS - elapsed;
		if ( this.SS <= 0 ) then
			if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
				this.SS = nil;
				CT_RA_AddMessage("SR");
			else
				this.SS = 5;
			end
		end
	end
	if ( this.scheduleUpdate ) then
		this.scheduleUpdate = this.scheduleUpdate - elapsed;
		if ( this.scheduleUpdate <= 0 ) then
			if ( CT_RA_InCombat ) then
				this.scheduleUpdate = 1;
			else
				this.scheduleUpdate = nil;
				for i = 1, GetNumRaidMembers(), 1 do
					if ( UnitIsUnit("raid" .. i, "player") ) then
						local useless, useless, subgroup = GetRaidRosterInfo(i);
						this.updateDelay = subgroup;
						return;
					end
				end
			end
		end
	end
	if ( this.updateDelay ) then
		this.updateDelay = this.updateDelay - elapsed;
		if ( this.updateDelay <= 0 ) then
			if ( CT_RA_Level >= 1 ) then
				for i = 1, GetNumRaidMembers(), 1 do
					local name, rank = GetRaidRosterInfo(i);
					for k, v in CT_RA_MainTanks do
						if ( v == nick ) then
							CT_RA_AddMessage("SET " .. k .. " " .. v);
							break;
						end
					end
				end
			end
			CT_RA_SendStatus();
			CT_RA_UpdateRaidGroup();
			this.updateDelay = nil;
		end
	end
	if ( this.joinchan ) then
		this.joinchan = this.joinchan - elapsed;
		if ( this.joinchan <= 0 ) then
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] = this.newchan;
			if ( GetChannelName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) == 0 ) then
				CT_RA_Join(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
			end
			this.joinchan = nil;
			this.newchan = nil;
		end
	end
	if ( this.readyTimer ) then
		this.readyTimer = this.readyTimer - elapsed;
		if ( this.readyTimer <= 0 ) then
			this.readyTimer = nil;
			local numNotReady = 0;
			local notReadyString = "";
			for k, v in CT_RA_Stats do
				if ( v["notready"] ) then
					numNotReady = numNotReady + 1;
					if ( strlen(notReadyString) > 0 ) then
						notReadyString = notReadyString .. ", ";
					end
					notReadyString = notReadyString .. "|c00FFFFFF" .. k .. "|r";
				end
				CT_RA_Stats[k]["notready"] = nil;
			end
			if ( numNotReady > 0 ) then
				if ( numNotReady == 1 ) then
					CT_RA_Print("<CTRaid> " .. notReadyString .. " is not ready.", 1, 1, 0);
				elseif ( numNotReady >= 8 ) then
					CT_RA_Print("<CTRaid> |c00FFFFFF" .. numNotReady .. "|r raid members are not ready.", 1, 1, 0);
				else
					CT_RA_Print("<CTRaid> |c00FFFFFF" .. numNotReady .. "|r raid members (" .. notReadyString .. ") are not ready.", 1, 1, 0);
				end
				CT_RA_UpdateRaidGroup();
			end
		end
	end
	if ( this.updateMT ) then
		this.updateMT = this.updateMT - elapsed;
		if ( this.updateMT <= 0 ) then
			this.updateMT = 0.25;
			CT_RA_UpdateMTs();
		end
	end
end
function CT_RA_UpdateFrame_OnEvent(event)
	if ( event == "PARTY_MEMBERS_CHANGED" ) then
		if ( not CT_RA_ConvertedRaid ) then
			this.invite = 3;
		end
	end
end

function CT_RA_InviteGuild(min, max)
	local offline = GetGuildRosterShowOffline();
	local selection = GetGuildRosterSelection();
	SetGuildRosterShowOffline(0);
	SetGuildRosterSelection(0);
	GetGuildRosterInfo(0);
	GuildRoster();
	local numInvites = 0;
	local numGuildMembers = GetNumGuildMembers();
	CT_RA_UpdateFrame.closeroster = 2;
	for i = 1, numGuildMembers, 1 do
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(i);
		if ( level >= min and level <= max and name ~= UnitName("player") and not CT_RA_HasInvited[i] and online ) then
			CT_RA_HasInvited[i] = 1;
			InviteByName(name);
			numInvites = numInvites + 1;
			if ( numInvites == 4 and not CT_RA_ConvertedRaid ) then 
				CT_RA_UpdateFrame.invite = 1.5;
				break;
			end
		end
	end
	SetGuildRosterShowOffline(offline);
	SetGuildRosterSelection(selection);
end

function CT_RA_ProcessMessages(elapsed)
	if ( this.elapsed > 0 ) then
		this.elapsed = this.elapsed - elapsed;
	end
	if ( this.elapsed <= 0 ) then
		if ( getn(CT_RA_Comm_MessageQueue) > 0 ) then
			CT_RA_SendMessageQueue();
			this.elapsed = 0.1;
		end
	end
end
function CT_RA_SendMessageQueue()
	local retstr = "";
	for key, val in CT_RA_Comm_MessageQueue do
		if ( strlen(retstr)+strlen(val)+1 > 255 ) then
			CT_RA_SendMessage(retstr, 1);
			retstr = "";
		end
		if ( retstr ~= "" ) then
			retstr = retstr .. "#";
		end
		retstr = retstr .. val;
	end
	if ( retstr ~= "" ) then
		CT_RA_SendMessage(retstr, 1);
	end
	CT_RA_Comm_MessageQueue = { };
end

function CT_RA_Split(msg, char)
	local arr = { };
	while (string.find(msg, char) ) do
		local iStart, iEnd = string.find(msg, char);
		tinsert(arr, strsub(msg, 1, iStart-1));
		msg = strsub(msg, iEnd+1, strlen(msg));
	end
	if ( strlen(msg) > 0 ) then
		tinsert(arr, msg);
	end
	return arr;
end

function CT_RA_IsReportingForParty()
	local names = { };
	for i = 1, GetNumRaidMembers(), 1 do
		if ( UnitName("raid" .. i) and UnitInParty("raid" .. i)) then
			tinsert(names, UnitName("raid" .. i));
		end
	end
	table.sort(
		names, 
		function(a1, a2)
			return a1 < a2;
		end
	);

	for k, v in names do
		if ( v == UnitName("player") ) then
			return 1;
		end
		if ( CT_RA_Stats[v] and CT_RA_Stats[v]["Reporting"] ) then
			return nil;
		end
	end
	return 1;
end

function CT_RA_IsSendingWithVersion(version)
	local names = { };
	for i = 1, GetNumRaidMembers(), 1 do
		if ( CT_RA_Stats[UnitName("raid" .. i)] and CT_RA_Stats[UnitName("raid" .. i)]["Version"] and CT_RA_Stats[UnitName("raid" .. i)]["Version"] >= version ) then
			tinsert(names, UnitName("raid" .. i));
		end
	end
	table.sort(
		names, 
		function(a1, a2)
			return a1 < a2;
		end
	);

	for k, v in names do
		if ( v == UnitName("player") ) then
			return 1;
		else
			return nil;
		end
	end
	return 1;
end

function CT_RA_ScanPartyAuras(unit)
	local name = name;
	if ( not name ) then
		return;
	end
	local currauras = { 
		["buffs"] = { },
		["debuffs"] = { }
	};

	local changed = {
		["newbuffs"] = { },
		["expiredbuffs"] = { },
		["newdebuffs"] = { },
		["expireddebuffs"] = { }
	};
	local oldBuffs = { };
	if ( CT_RA_Stats[name] ) then
		oldBuffs = CT_RA_Stats[name]["Buffs"];
	end
	local oldDebuffs = { };
	if ( CT_RA_Stats[name] ) then
		oldDebuffs = CT_RA_Stats[name]["Debuffs"];
	end

	local returnstr = { };

	local i = 1;
	local buff = UnitBuff(unit, 1);
	while ( buff ) do
		CT_RATooltip:SetUnitBuff(unit, i);
		local name = CT_RATooltipTextLeft1:GetText();
		if ( name ) then
			local useless, useless, texture = string.find(buff, "([%w_&]+)$");
			currauras["buffs"][name] = { ["texture"] = texture };
		end
		i = i + 1;
		buff = UnitBuff(unit, i);
	end

	i = 1;
	buff = UnitDebuff(unit, 1);
	while ( buff ) do
		CT_RATooltip:SetUnitDebuff(unit, i);
		local name = CT_RATooltipTextLeft1:GetText();
		local type = CT_RATooltipTextRight1:GetText();
		if ( not type or not CT_RATooltipTextRight1:IsVisible() ) then type = nil; end
		if ( name ) then
			local useless, useless, texture = string.find(buff, "([%w_&]+)$");
			currauras["debuffs"][name] = { ["texture"] = texture, ["type"] = type };
		end
		i = i + 1;
		buff = UnitDebuff(unit, i);
	end
	-- Compare the tables
	for key, val in currauras["buffs"] do
		if ( not oldBuffs[key] ) then
			-- New buff
			changed["newbuffs"][key] = val["texture"];
		else
			-- Remove
			oldBuffs[key] = nil;
		end

	end
	for key, val in currauras["debuffs"] do
		if ( not oldDebuffs[key] ) then
			-- New debuff
			changed["newdebuffs"][key] = val;
		else
			-- Remove
			oldDebuffs[key] = nil;
		end
	end

	for key, val in oldBuffs do
		changed["expiredbuffs"][key] = 1;
	end

	for key, val in oldDebuffs do
		changed["expireddebuffs"][key] = 1;
	end

	for key, val in changed["newbuffs"] do
		tinsert(returnstr, "BPA " .. name .. " " .. val .. " " .. key);
	end
	for key, val in changed["newdebuffs"] do
		if ( not val["type"] ) then val["type"] = string.gsub(key, " ", "_"); end
		tinsert(returnstr, "DPA " .. name .. " " .. val["texture"] .. " " .. val["type"] .. " " .. key);
	end
	for key, val in changed["expiredbuffs"] do
		tinsert(returnstr, "BEPA " .. name .. " " .. key);
	end
	for key, val in changed["expireddebuffs"] do
		tinsert(returnstr, "DEPA " .. name .. " " .. key);
	end
	if ( CT_RA_Stats[name] ) then
		CT_RA_Stats[name]["Buffs"] = currauras["buffs"];
		CT_RA_Stats[name]["Debuffs"] = currauras["debuffs"];
	else
		CT_RA_Stats[name] = {
			["Buffs"] = currauras["buffs"],
			["Debuffs"] = currauras["debuffs"],
			["Position"] = { }
		};
	end
	return returnstr;
end

function CT_RA_ShowHideDebuffs()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowDebuffs"] = not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowDebuffs"];
	CT_RAMenuFrameBuffsShowDebuffsCheckButton:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowDebuffs"]);
	CT_RA_UpdateRaidGroup();
end

-- Thanks to Darco for the idea & some of the code
CT_RA_OldChatFrame_OnEvent = ChatFrame_OnEvent;
function CT_RA_NewChatFrame_OnEvent(event)
	if ( event == "CHAT_MSG_SYSTEM" ) then
		local iStart, iEnd, sName, iID, iDays, iHours, iMins, iSecs = string.find(arg1, "(.+) %(ID=(%w+)%): (%d+)d (%d+)h (%d+)m (%d+)s");
		if ( sName ) then
			local table = date("*t");
			table["sec"] = table["sec"] + (tonumber(iDays) * 86400) + (tonumber(iHours) * 3600) + (tonumber(iMins) * 60) + iSecs;
			arg1 = arg1 .. " ("..date("%A %b %d, %I:%M%p", time(table)) .. ")";
		end
	end
	CT_RA_OldChatFrame_OnEvent(event);
end

ChatFrame_OnEvent = CT_RA_NewChatFrame_OnEvent;



CT_RA_OldStaticPopup_OnShow = StaticPopup_OnShow;
function CT_RA_NewStaticPopup_OnShow()
	if ( strsub(this.which, 1, 9) == "RESURRECT" ) then
		CT_RA_AddMessage("RESSED");
	end
	CT_RA_OldStaticPopup_OnShow();
end
StaticPopup_OnShow = CT_RA_NewStaticPopup_OnShow;

function CT_RA_ResFrame_DropDown_OnClick()
	if ( this:GetID() == 2 ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockMonitor"] = not CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockMonitor"];
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMonitor"] = nil;
		CT_RA_ResFrame:Hide();
	end
end

function CT_RA_ResFrameLock_OnLoad()
	UIDropDownMenu_Initialize(this, CT_RA_ResFrameLock_InitButtons, "MENU");
end

function CT_RA_ResFrameLock_InitButtons()
	local dropdown, info;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end

	info = {};
	info.text = "Resurrection Monitor";
	info.isTitle = 1;
	info.justifyH = "CENTER";
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	info = { };
	info.text = "Lock position";
	info.notCheckable = 1;
	info.func = CT_RA_ResFrame_DropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = { };
	info.text = "Hide";
	info.notCheckable = 1;
	info.func = CT_RA_ResFrame_DropDown_OnClick;
	UIDropDownMenu_AddButton(info);
end

function CT_RA_ResFrameUnlock_OnLoad()
	UIDropDownMenu_Initialize(this, CT_RA_ResFrameUnlock_InitButtons, "MENU");
end

function CT_RA_ResFrameUnlock_InitButtons()
	local dropdown, info;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end

	info = {};

	info.text = "Resurrection Monitor";
	info.isTitle = 1;
	info.justifyH = "CENTER";
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	info = { };
	info.text = "Unlock position";
	info.notCheckable = 1;
	info.func = CT_RA_ResFrame_DropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = { };
	info.text = "Hide";
	info.notCheckable = 1;
	info.func = CT_RA_ResFrame_DropDown_OnClick;
	UIDropDownMenu_AddButton(info);
end

function CT_RA_SendReady()
	CT_RA_AddMessage("READY");
end

function CT_RA_ReadyFrame_OnUpdate(elapsed)
	if ( this.hide ) then
		this.hide = this.hide - elapsed;
		if ( this.hide <= 0 ) then
			this:Hide();
		end
	end
end

function CT_RA_ToggleGroupSort(skipCustom)
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "group" ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "class";
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 2);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Class");
	elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "class" and not skipCustom ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "custom";
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 3);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Custom");
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "group";
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 1);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Group");
	end

	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
	CT_RAOptions_Update();
end

function CT_RA_ToggleGroupSort()
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "group" ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "class";
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 2);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Class");
	elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "class" ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "custom";
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 3);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Custom");
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "group";
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 1);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Group");
	end

	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
	CT_RAOptions_Update();
end

function CT_RA_DragAllWindows(start)

	if ( start ) then

		local group = getglobal("CT_RAGroupDrag" .. this:GetID());
		local x, y = group:GetLeft(), group:GetTop();

		if ( not x or not y ) then
			return;
		end
		for i = 1, 8, 1 do
			if ( i ~= this:GetID() ) then
				local oGroup = getglobal("CT_RAGroupDrag" .. i);
				local oX, oY = oGroup:GetLeft(), oGroup:GetTop();
				if ( oX and oY ) then
					oGroup:ClearAllPoints();
					oGroup:SetPoint("TOPLEFT", group:GetName(), "TOPLEFT", oX-x, oY-y);
				end
			end
		end
	else
		for i = 1, 8, 1 do
			if ( i ~= this:GetID() ) then
				local oGroup = getglobal("CT_RAGroupDrag" .. i);
				local oX, oY = oGroup:GetLeft(), oGroup:GetTop();
				if ( oX and oY ) then
					oGroup:ClearAllPoints();
					oGroup:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", oX, oY-UIParent:GetTop());
				end
			end
		end
	end
end

function CT_RA_CheckGroups()
	if ( GetNumRaidMembers() == 0 ) then
		return;
	end
	if ( not CT_RA_PartyMembers ) then
		CT_RA_PartyMembers = { };
		if ( UnitName("party" .. GetNumPartyMembers()) ) then
			for i = 1, GetNumPartyMembers(), 1 do
				CT_RA_PartyMembers[UnitName("party"..i)] = i;
			end
		end
		return;
	end
	local joined, left, numleft, numjoin = "", "", 0, 0;
	if ( not UnitName("party" .. GetNumPartyMembers()) and GetNumPartyMembers() > 0 ) then
		CT_RA_PartyMembers = { };
		return;
	end
	for i = 1, GetNumPartyMembers(), 1 do
		if ( not CT_RA_PartyMembers[UnitName("party" .. i)] and UnitName("party" .. i) ) then
			if ( numjoin > 0 ) then
				joined = joined .. "|r, |c00FFFFFF";
			end
			joined = joined .. UnitName("party" .. i);
			numjoin = numjoin + 1;
		end
		CT_RA_PartyMembers[UnitName("party" .. i)] = nil;
	end

	for k, v in CT_RA_PartyMembers do
		if ( numleft > 0 ) then
			left = left .. "|r, |c00FFFFFF";
		end
		left = left .. k;
		numleft = numleft + 1;
	end

	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyGroupChange"] and ( numjoin > 0 or numleft > 0 ) ) then
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyGroupChangeSound"] ) then
			PlaySoundFile("Sound\\Spells\\Thorns.wav");
		end
		if ( numjoin > 1 ) then
			CT_RA_Print("<CTRaid> |c00FFFFFF" .. joined .. "|r have joined your party.", 1, 0.5, 0);
		elseif ( numjoin == 1 ) then
			CT_RA_Print("<CTRaid> |c00FFFFFF" .. joined .. "|r has joined your party.", 1, 0.5, 0);
		end
		if ( numleft > 1 ) then
			CT_RA_Print("<CTRaid> |c00FFFFFF" .. left .. "|r have left your party.", 1, 0.5, 0);
		elseif ( numleft == 1 ) then
			CT_RA_Print("<CTRaid> |c00FFFFFF" .. left .. "|r has left your party.", 1, 0.5, 0);
		end
	end
	CT_RA_PartyMembers = { };
	for i = 1, GetNumPartyMembers(), 1 do
		if ( UnitName("party" .. i) ) then
			CT_RA_PartyMembers[UnitName("party" .. i)] = 1;
		end
	end
end
function CT_RA_CheckReady()
	if ( CT_RA_Level >= 1 ) then
		CT_RA_AddMessage("CHECKREADY");
		local numValid = 0;
		for i = 1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( name ~= UnitName("player") and CT_RA_Stats[name] and CT_RA_Stats[name]["Reporting"] and online and CT_RA_Stats[name]["Version"] and CT_RA_Stats[name]["Version"] >= 1.097 ) then
				numValid = numValid + 1;
				CT_RA_Stats[name]["notready"] = 1;
			end
		end
		if ( numValid == 1 ) then
			CT_RA_Print("<CTRaid> Ready status is being checked for |c00FFFFFF" .. numValid .. "|r raid member.", 1, 1, 0);
		else
			CT_RA_Print("<CTRaid> Ready status is being checked for |c00FFFFFF" .. numValid .. "|r raid members.", 1, 1, 0);
		end
		CT_RA_UpdateFrame.readyTimer = 30;
		CT_RA_UpdateRaidGroup();
	else
		CT_RA_Print("<CTRaid> You need to be promoted or leader to do that!", 1, 1, 0);
	end
end


SlashCmdList["RASET"] = function(msg)
	local _, _, action, parameters = nil, nil, nil, "";
	if ( string.find(msg, " ") ) then
		_, _, action, parameters = string.find(msg, "([^%s]+) (.+)");
	else
		action = msg;
	end
	
	if ( action == "new" and parameters == "" ) then
		CT_RA_Print("<CTRaid> Usage: /raset new <name>", 1, 0.5, 0);
	elseif ( action == "new" ) then
		CT_RAMenu_Options[parameters] = { };
		for k, v in CT_RAMenu_Options["Default"] do
			CT_RAMenu_Options[parameters][k] = v;
		end
		CT_RA_Print("<CTRaid> Set '" .. parameters .. "' created.", 1, 0.5, 0);
	elseif ( action == "list" ) then
		for k, v in CT_RAMenu_Options do
			CT_RA_Print("<CTRaid> " .. k, 1, 0.5, 0);
		end
	elseif ( action == "load" and parameters == "" ) then
		CT_RA_Print("<CTRaid> Usage: /raset load <name>", 1, 0.5, 0);
	elseif ( action == "load" ) then
		local oldset = CT_RAMenu_CurrSet;
		CT_RAMenu_CurrSet = parameters;
		CT_RAMenu_UpdateMenu()
		
		if ( CT_RAMenu_Options[oldset]["Channel"] ) then
			LeaveChannelByName(CT_RAMenu_Options[oldset]["Channel"]);
		end
		CT_RA_UpdateFrame.joinchan = 1;
		CT_RA_UpdateFrame.newchan = msg;
	end
end

SlashCmdList["RAKEYWORD"] = function(msg)
	if ( msg == "off" ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["KeyWord"] = nil;
		CT_RA_Print("<CTRaid> Keyword Inviting has been turned off.", 1, 0.5, 0);
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["KeyWord"] = msg;
		CT_RA_Print("<CTRaid> Invite Keyword has been set to '|c00FFFFFF" .. msg .. "|r'. Use |c00FFFFFF/rakeyword off|r to turn Keyword Inviting off.", 1, 0.5, 0);
	end
end

SlashCmdList["RADISBAND"] = function(msg)
	if ( CT_RA_Level and CT_RA_Level >= 1 ) then
		CT_RA_Print("<CTRaid> Disbanding raid...", 1, 0.5, 0);
		SendChatMessage("<CTRaid> Disbanding raid on request by " .. UnitName("player") .. ".", "RAID");
		for i = 1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( online and rank <= CT_RA_Level and name ~= UnitName("player") ) then
				UninviteByName(name);
			end
		end
		CT_RA_AddMessage("DB");
		LeaveParty();
	else
		CT_RA_Print("<CTRaid> You need to be raid leader or promoted to do that!", 1, 0.5, 0);
	end
end

SlashCmdList["RASHOW"] = function(msg)
	if ( msg == "all" ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] = { 1, 1, 1, 1, 1, 1, 1, 1 };
		CT_RACheckAllGroups:SetChecked(1);
		for i = 1, 8, 1 do
			getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(1);
		end
	else
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"] ) then return; end
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] = CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"];
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"] = nil;
		local num = 0;
		for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] do
			num = num + 1;
			getglobal("CT_RAOptionsGroupCB" .. k):SetChecked(1);
		end
		if ( num > 0 ) then
			CT_RACheckAllGroups:SetChecked(1);
		else
			CT_RACheckAllGroups:SetChecked(nil);
		end
	end
	CT_RA_UpdateRaidGroup();
end

SlashCmdList["RAHIDE"] = function(msg)
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HiddenGroups"] = CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"];
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] = { };
		CT_RACheckAllGroups:SetChecked(nil);
		for i = 1, 8, 1 do
			getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(nil);
		end
	CT_RA_UpdateRaidGroup();
end

SlashCmdList["RAOPTIONS"] = function(msg)
	CT_RAMenuFrame:Show();
end
SlashCmdList["RAREADY"] = CT_RA_CheckReady;
SlashCmdList["RAINVITE"] = function(msg)
	if ( not GetGuildInfo("player") ) then
		CT_RA_Print("<CTRaid> You need to be in a guild to mass invite.");
		return;
	end
	if ( ( not CT_RA_Level or CT_RA_Level == 0 ) and GetNumRaidMembers() > 0 ) then
		CT_RA_Print("<CTRaid> You must be promoted or raid leader to mass invite.", 1, 1, 0);
		return;
	end

	local useless, useless, min, max = string.find(msg, "^(%d+)-(%d+)$");
	min = tonumber(min);
	max = tonumber(max);
	if ( min and max ) then
		if ( min > max ) then
			local temp = min;
			min = max;
			max = temp;
		end
		if ( min < 1 ) then min = 1; end
		if ( max > 60 ) then max = 60; end
		if ( min == max ) then
			SendChatMessage("Raid invites are coming in 10 seconds for players level " .. min .. ", leave your groups.", "GUILD");
		else
			SendChatMessage("Raid invites are coming in 10 seconds for players level " .. min .. " to " .. max .. ", leave your groups.", "GUILD");
		end
		CT_RA_MinLevel = min;
		CT_RA_MaxLevel = max;
		CT_RA_UpdateFrame.startinviting = 10;
	else
		useless, useless, min = string.find(msg, "^(%d+)$");
		min = tonumber(min);
		if ( min ) then
			if ( min < 1 ) then min = 1; end
			if ( min > 60 ) then min = 60; end
			SendChatMessage("Raid invites are coming in 10 seconds for players level " .. min .. ", leave your groups.", "GUILD");
			CT_RA_MinLevel = min;
			CT_RA_MaxLevel = min;
			CT_RA_UpdateFrame.startinviting = 10;
		else
			CT_RA_Print("<CTRaid> Syntax Error. Usage: |c00FFFFFF/rainvite level|r or |c00FFFFFF/rainvite minlevel-maxlevel|r.", 1, 0.5, 0);
			CT_RA_Print("<CTRaid> This command mass invites everybody in the guild within the selected level range (or only selected level if maxlevel is omitted).", 1, 0.5, 0);
		end
	end
end
SlashCmdList["RS"] = function(msg)
	if ( CT_RA_Level >= 1 ) then
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SendRARS"] ) then
			SendChatMessage(msg, "RAID");
		end
		CT_RA_AddMessage("MS " .. msg);
	else
		CT_RA_Print("<CTRaid> You must be promoted or leader to do that!", 1, 1, 0);
	end
end

SlashCmdList["RA"] = function(msg)
	msg = strlower(msg);
	if ( msg == "" or msg == "help" ) then
		CT_RA_Print("<CTRaid> RaidAssist uses the following slash commmands:", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/raidassist update|r - Updates raid stats (requires leader or promoted status)", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/raidassist broadcast|r - Broadcasts the RaidAssist channel (requires leader or promoted status)", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> There are also other commands:", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rakeyword keyword|r - Automatically invites people whispering you the set keyword", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rainvite minlevel-maxlevel|r or |c00FFFFFF/rainvite level|r - Invites people within the set level range", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/radisband|r - Disbands the raid (requires leader or promoted status)", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rashow|r - Shows raid windows that were hidden with /rahide", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rashow all|r - Shows all raid windows", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rahide|r - Hides all raid windows", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/raoptions|r - Shows the options window", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rares [show/hide]|r - Shows/hides the Resurrection Monitor.", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/raidassist onyxia [on/off]|r - Turns onyxia AE warning on/off", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/raidassist onyxia set [text]|r - Sets the onyxia AE warning message to '|c00FFFFFF[text]|r'", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rajoin|r - Joins the RaidAssist channel", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rajoin [channel]|r - Sets the RaidAssist channel to |c00FFFFFF[channel]|r, and automatically joins it", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/raready|r - Does a ready check with every RaidAssist user in the raid (requires leader or promoted status)", 1, 0.5, 0);
		CT_RA_Print("<CTRaid> |c00FFFFFF/rs [text]|r - Sends a message to all CTRA users in the raid, that appears in the center of the screen (requires leader or promoted status).", 1, 0.5, 0);
	elseif ( msg == "onyxia on" ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["Onyxia_Status"] = 1;
		CT_RA_Print("<CTRaid> Onyxia AE Warning is now turned |c0000FF00On|r.", 1, 0.5, 0);
	elseif ( msg == "onyxia off" ) then
		CT_RA_Print("<CTRaid> Onyxia AE Warning is now turned |c00FF0000Off|r.", 1, 0.5, 0);
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["Onyxia_Status"] = 0;
	elseif ( strsub(msg, 1, 6) == "geddon" ) then
		local types = {
			["geddon self"] = { 1, "showing for |c00FFFFFFself only|r." },
			["geddon nearby"] = { 2, "showing for |c00FFFFFFnearby players|r." },
			["geddon all"] = { 3, "showing for |c00FFFFFFeverybody in raid (with CTRA)|r." },
			["geddon off"] = { 4, "turned |c00FFFFFFoff|r." }
		};
		if ( types[msg] ) then
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["Geddon_Status"] = types[msg][1];
			CT_RA_Print("<CTRaid> Geddon Living Bomb Warning is now " .. types[msg][2], 1, 0.5, 0);
		else
			CT_RA_Print("<CTRaid> Use /raidassist for help on different CT_RaidAssist commands.", 1, 0.5, 0);
		end
	elseif ( msg == "update" and CT_RA_Level >= 1 ) then
		CT_RA_AddMessage("SR");
		CT_RA_Print("<CTRaid> Stats have been updated for the raid group.", 1, 0.5, 0);
	elseif ( msg == "update" and CT_RA_Level < 1 ) then
		CT_RA_Print("<CTRaid> You must be promoted or leader to do that!", 1, 0.5, 0);	
	elseif ( msg == "broadcast" ) then
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
			CT_RA_Print("<CTRaid> No channel set, cannot broadcast the channel!", 1, 0.5, 0);
		else
			if ( CT_RA_Level >= 1 ) then
				CT_RA_Print("<CTRaid> Channel \"|c00FFFFFF" .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] .. "|r\" has been broadcasted to the raid.", 1, 0.5, 0);
				SendChatMessage("<CTMod> This is an automatic message sent by CT_RaidAssist. Channel changed to: " .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"], "RAID");
			else
				CT_RA_Print("<CTRaid> You must be promoted or leader to do that!", 1, 0.5, 0);
			end
		end
	else
		CT_RA_Print("<CTRaid> Use /raidassist for help on different CT_RaidAssist commands.", 1, 0.5, 0);
	end
end
SlashCmdList["RAJOIN"] = function(msg)
	if ( msg == "" ) then
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
			CT_RA_Print("<CTRaid> No RaidAssist channel set. Use /rajoin |c00FFFFFF[channel]|r to set channel to |c00FFFFFF[channel]|r.", 1, 0.5, 0);
		elseif ( GetChannelName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) == 0 ) then
			CT_RA_Join(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
			CT_RA_Print("<CTRaid> Joined channel \"|c00FFFFFF" .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] .. "|r\".", 1, 0.5, 0);
		else
			CT_RA_Print("<CTRaid> The current RaidAssist channel is: |c00FFFFFF" .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] .. "|r.", 1, 0.5, 0);
		end
	else
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
			LeaveChannelByName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
		end
		CT_RA_UpdateFrame.joinchan = 1;
		CT_RA_UpdateFrame.newchan = msg;
		CT_RA_Print("<CTRaid> Joined channel \"|c00FFFFFF" .. msg .. "|r\".", 1, 0.5, 0);
	end
end
SlashCmdList["RARES"] = function(msg)
	if ( msg == "show" ) then
		if ( GetNumRaidMembers() > 0 ) then
			CT_RA_ResFrame:Show();
		end
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMonitor"] = 1;
	elseif ( msg == "hide" ) then
		CT_RA_ResFrame:Hide();
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMonitor"] = nil;
	else
		CT_RA_Print("<CTRaid> Usage: |c00FFFFFF/rares [show/hide]|r - Shows/hides the Resurrection Monitor.", 1, 0.5, 0);
	end
end


SLASH_RARES1 = "/rares";
SLASH_RAJOIN1 = "/rajoin";
SLASH_RAJOIN2 = "/rj";
SLASH_RADISBAND1 = "/radisband";
SLASH_RAINVITE1 = "/rainvite";
SLASH_RAINVITE2 = "/rainv";
SLASH_RAKEYWORD1 = "/rakeyword";
SLASH_RAKEYWORD2 = "/rakw";
SLASH_RASHOW1 = "/rashow";
SLASH_RAHIDE1 = "/rahide";
SLASH_RAOPTIONS1 = "/raoptions";
SLASH_RASET1 = "/raset";
SLASH_RAREADY1 = "/raready";
SLASH_RAREADY2 = "/rr";
SLASH_RA1 = "/raidassist";
SLASH_RS1 = "/rs";