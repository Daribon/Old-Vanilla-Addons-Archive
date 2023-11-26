-- Add a field to the chat frames
CHAT_MSG_CTRAID = "CTRaid";
ChatTypeGroup["CTRAID"] = {
	"CHAT_MSG_CTRAID"
};
ChatTypeInfo["CTRAID"] = { sticky = 0 };
OtherMenuChatTypeGroups[4] = "CTRAID";
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

CT_RA_ShowGroups = { };
CT_RA_Channel = nil;
CT_RA_Level = 0;
CT_RA_AllowedCommanders = 1;
CT_RA_Stats = {
	{
		{ }
	}
};
CT_RA_BuffsToCure = { };
CT_RA_BuffsToRecast = { };
CT_RA_MainTankStats = { };
CT_RA_RaidParticipant = nil; -- Used to see what player participated in the raid on this account

CT_RA_Auras = { 
	["buffs"] = { },
	["debuffs"] = { }
};
CT_RA_LastSend = nil;
CT_RA_DebuffColors = {
	{ ["type"] = CT_RA_CURSE, ["r"] = 1, ["g"] = 0, ["b"] = 0.75, ["a"] = 0.5, ["id"] = 4 },
	{ ["type"] = CT_RA_MAGIC, ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 6 },

	{ ["type"] = CT_RA_POISON, ["r"] = 0, ["g"] = 0.5, ["b"] = 0, ["a"] = 0.5, ["id"] = 3 },
	{ ["type"] = CT_RA_DISEASE, ["g"] = 1, ["b"] = 0, ["a"] = 0.5, ["id"] = 5 },
	{ ["type"] = CT_RA_WEAKENEDSOUL, ["r"] = 1, ["g"] = 0, ["b"] = 1, ["a"] = 0.5, ["id"] = 2 },
	{ ["type"] = CT_RA_RECENTLYBANDAGED, ["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 1 }
};
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
CT_RA_Geddon_Status = 1;

CT_RA_HiddenGroups = nil; -- Used by Hide/Show all windows
CT_RA_NumRaidMembers = 0;

function CT_RA_ShowHideWindows()
	if ( CT_RA_HiddenGroups ) then
		CT_RA_ShowGroups = CT_RA_HiddenGroups;
		CT_RA_HiddenGroups = nil;

		local num = 0;
		for k, v in CT_RA_ShowGroups do
			num = num + 1;
			getglobal("CT_RAOptionsGroupCB" .. k):SetChecked(1);
		end
		if ( num > 0 ) then
			CT_RACheckAllGroups:SetChecked(1);
		else
			CT_RACheckAllGroups:SetChecked(nil);
		end
	else
		CT_RA_HiddenGroups = CT_RA_ShowGroups;
		CT_RA_ShowGroups = { };
		for i = 1, 8, 1 do
			getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(nil);
		end
		CT_RACheckAllGroups:SetChecked(nil);
	end
	CT_RA_UpdateRaidGroup();
end

function CT_RA_SetGroup()
	CT_RA_ShowGroups[this:GetID()] = this:GetChecked();
	local num = 0;
	for k, v in CT_RA_ShowGroups do
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
	if ( not CT_RA_ShowGroups ) then CT_RA_ShowGroups = { }; end
	for i = 1, 8, 1 do
		CT_RA_ShowGroups[i] = this:GetChecked();
		getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(this:GetChecked());
	end
	CT_RA_UpdateRaidGroup();
end

function CT_RA_ParseEvent(event)
	if ( strsub(event, 1, 13) == "CHAT_MSG_RAID" ) then
		arg1 = gsub(arg1, "%%", "%%%%");
		local useless, useless, chan = string.find(arg1, "<CTMod> This is an automatic message sent by CT_RaidAssist. Channel changed to: (.+)");
		if ( chan ) then
			for i = 1, GetNumRaidMembers(), 1 do
				local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
				if ( rank >= 1 and name == arg2 ) then
					CT_RA_ChangeChannel(chan);
					CT_RA_Print("<CTRaid> The CT_RaidAssist channel has been changed to '|c00FFFFFF" .. chan .. "|r'. You have automatically joined this channel.", 1, 0.5, 0);
				end
			end
		elseif ( string.find(arg1, "<CTMod> Disbanding raid on request by (.+)%.") ) then
			return;
		end

	elseif ( event == "CHAT_MSG_WHISPER" ) then
		if ( CT_RA_KeyWord and strlower(arg1) == strlower(CT_RA_KeyWord) ) then
			local temp = arg2;
			CT_RA_Print("<CTMod> Invited '|c00FFFFFF" .. arg2 .. "|r' by Keyword Inviting.", 1, 0.5, 0);
			InviteByName(temp);
		end

	elseif ( strsub(event, 1, 15) == "CHAT_MSG_SYSTEM" ) then
		local useless, useless, plr = string.find(arg1, "^([^%s]+) has left the raid group$");
		if ( CT_RA_RaidParticipant and plr and plr ~= CT_RA_RaidParticipant ) then
			CT_RA_Stats[plr] = nil;
			for k, v in CT_RA_MainTanks do
				if ( v == plr ) then
					CT_RA_MainTanks[k] = nil;
					CT_RA_MainTankStats[k] = nil;
					break;
				end
			end
			CT_RA_UpdateRaidGroup();
			CT_RA_UpdateMTs();
			CT_RAOptions_Update();
		end

	elseif ( event == "CHAT_MSG_CHANNEL" and CT_RA_Channel and arg9 and strlower(arg9) == strlower(CT_RA_Channel) ) then
		local eventtype = strsub(event, 10);
		local info = ChatTypeInfo[eventtype];
		event = "CHAT_MSG_CTRAID";
		for i = 1, GetNumRaidMembers(), 1 do
			local name = GetRaidRosterInfo(i);
			local message, tempUpdate;
			local update = { };
			if ( name == arg2 ) then
				arg1 = gsub(arg1, "%%", "%%%%");
				local msg = string.gsub(arg1, "%$", "s");
				msg = string.gsub(msg, "¤", "S");
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
							tinsert(update, tempUpdate);
						end
					end
				else
					tempUpdate, message = CT_RA_ParseMessage(name, msg);
					if ( message ) then
						CT_RA_Print(message, 1, 0.5, 0);
					end
					if ( tempUpdate ) then
						tinsert(update, tempUpdate);
					end
				end
				if ( type(update) == "table" ) then
					for k, v in update do
						local raidid, name;
						if ( type(v) == "table" ) then
							raidid = v[2];
						else
							for i = 1, GetNumRaidMembers(), 1 do
								if ( UnitName("raid" .. i) and UnitName("raid" .. i) == v ) then
									raidid = i;
									break;
								end
							end
						end
						if ( raidid and name ) then
							local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
							CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
						end
					end
				end
				break;
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
		if ( CT_RA_KeyWord and strlower(arg1) == strlower(CT_RA_KeyWord) ) then
			return;
		end
	end

	-- There is a channel
	if ( strsub(event, 1, 8) == "CHAT_MSG" and CT_RA_Channel and arg9 and strlower(arg9) == strlower(CT_RA_Channel) ) then
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
	update = { };

	for i = 1, GetNumRaidMembers(), 1 do
		if ( UnitName("raid" .. i) and UnitName("raid" .. i) == nick ) then
			raidid = i;
			frame = getglobal("CT_RAMember" .. i);
			break;
		end
	end
	if ( not CT_RA_Stats[nick] ) then
		CT_RA_Stats[nick] = {
			["Health"] = nil,
			["Healthmax"] = nil,
			["Mana"] = nil,
			["Buffs"] = { },
			["Debuffs"] = { },
			["Position"] = { }
		};
		tinsert(update, { nick, raidid });
	end
	CT_RA_Stats[nick]["Reporting"] = 1;

	if ( not frame or not raidid ) then return update; end

	-- Check health
	useless, useless, val1, val2 = string.find(msg, "^H ([^%s]+) ([^%s]+)$");
	if ( tonumber(val1) and tonumber(val2) ) then
		-- Health
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);

		local prevhealth = CT_RA_Stats[nick]["Health"];
		CT_RA_Stats[nick]["Health"] = floor(tonumber(val1));
		CT_RA_Stats[nick]["Healthmax"] = floor(tonumber(val2));
		if ( floor(tonumber(val1)) ~= -1 ) then
			CT_RA_Stats[nick]["Ressed"] = nil;
		end
		if ( tonumber(val1) == -1 and not CT_RA_Stats[nick]["Buffs"]["Feign Death"] ) then
			CT_RA_Stats[nick]["Buffs"] = { };
			CT_RA_Stats[nick]["Debuffs"] = { };
			if ( CastParty_ClearDebuffs ) then
				CastParty_ClearDebuffs("raid" .. raidid);
			end
			CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
		else
			if ( prevhealth == -1 ) then
				CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
			else
				CT_RA_UpdateUnitHealth(frame, floor(tonumber(val1)), floor(tonumber(val2)), fileName);
			end
		end
		return update;
	end

	-- Check health (compatibility version)
	useless, useless, val1 = string.find(msg, "^H ([^%s]+)");
	if ( tonumber(val1) ) then
		-- Health
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);

		local prevhealth = CT_RA_Stats[nick]["Health"];
		CT_RA_Stats[nick]["Health"] = floor(tonumber(val1));
		if ( floor(tonumber(val1)) ~= -1 ) then
			CT_RA_Stats[nick]["Ressed"] = nil;
		end
		if ( tonumber(val1) == -1 and not CT_RA_Stats[nick]["Buffs"]["Feign Death"] ) then
			CT_RA_Stats[nick]["Buffs"] = { };
			CT_RA_Stats[nick]["Debuffs"] = { };
			if ( CastParty_ClearDebuffs ) then
				CastParty_ClearDebuffs("raid" .. raidid);
			end
			CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
		else
			if ( prevhealth == -1 ) then
				CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
			else
				CT_RA_UpdateUnitHealth(frame, floor(tonumber(val1)), nil, fileName);
			end
		end
		return update;
	end

	-- Check mana
	useless, useless, val1 = string.find(msg, "^M (%d+)$");
	if ( val1 ) then
		-- Mana
		CT_RA_Stats[nick]["Mana"] = tonumber(val1);
		CT_RA_UpdateUnitMana(frame, tonumber(val1));
		return update;
	end
	
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
			CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
		else
			CT_RA_UpdateUnitBuffs(CT_RA_Stats[nick]["Buffs"], frame, nick);
		end
		-- Buff expired
		if ( not CT_RA_NotifyDebuffs["hidebuffs"] and val1 ~= "Power Word: Shield" and val1 ~= "Fire Shield" and val1 ~= "Admiral's Hat") then
			for k, v in CT_RA_BuffArray do
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
						if ( name == nick and ( ( not CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[val] ) or ( CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[CT_RA_ClassPositions[class]] ) ) ) then
							if ( CT_RA_ClassSpells and CT_RA_ClassSpells[val1] and GetBindingKey("CT_RECASTRAIDBUFF") ) then
								if ( GetBindingKey("CT_RECASTRAIDBUFF") ) then
									CT_RA_AddToBuffQueue(val1, "raid"..key);
									return update, "<CTMod> '|c00FFFFFF" .. nick .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded. Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_RECASTRAIDBUFF"), "KEY_") .. "|r' to recast.";
								else
									return update, "<CTMod> '|c00FFFFFF" .. nick .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded.";
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
			CT_RA_Stats[val2] = {
				["Buffs"] = { },
				["Debuffs"] = { },
				["Position"] = { }
			};
			tinsert(update, val2);
		end
		CT_RA_Stats[val2]["Buffs"][val1] = nil;
		for i = 1, GetNumRaidMembers(), 1 do
			if ( UnitName("raid" .. i) and UnitName("raid" .. i) == val3 ) then
				if ( val1 == "Feign Death" ) then
					local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
					CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
				else
					CT_RA_UpdateUnitBuffs(CT_RA_Stats[val3]["Buffs"], getglobal("CT_RAMember" .. i), val3);
				end
				break;
			end
		end
		-- Buff expired
		if ( not CT_RA_NotifyDebuffs["hidebuffs"] and val1 ~= "Power Word: Shield" and val1 ~= "Fire Shield" and val1 ~= "Admiral's Hat") then
			for k, v in CT_RA_BuffArray do
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
						if ( name == val2 and ( ( not CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[val] ) or ( CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[CT_RA_ClassPositions[class]] ) ) ) then
							if ( CT_RA_ClassSpells and CT_RA_ClassSpells[val1] and GetBindingKey("CT_RECASTRAIDBUFF") ) then
								if ( GetBindingKey("CT_RECASTRAIDBUFF") ) then
									CT_RA_AddToBuffQueue(val1, "raid"..key);
									return update, "<CTMod> '|c00FFFFFF" .. val2 .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded. Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_RECASTRAIDBUFF"), "KEY_") .. "|r' to recast.";
								else
									return update, "<CTMod> '|c00FFFFFF" .. val2 .. "|r's '|c00FFFFFF" .. val1 .. "|r' has faded.";
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
	useless, useless, val3, val4, val1, val2 = string.find(msg, "^D ([^%s]+) ([^%s]+) ([%a_]+) (.+)$");
	if ( val1 and val2 and val3 and val4 ) then
		-- Debuff
		CT_RA_Stats[nick]["Debuffs"][val2] = { val1, tonumber(val3), val4 };
		CT_RA_UpdateUnitDebuffs(CT_RA_Stats[nick]["Debuffs"], frame);
		local types = { ["Magic"] = 1, ["Poison"] = 1, ["Disease"] = 1, ["Curse"] = 1 };
		if ( CT_RA_NotifyDebuffs["main"] ) then
			for k, v in CT_RA_DebuffColors do
				local en = v["type"]["en"];
				local de = v["type"]["de"];
				local fr = v["type"]["fr"];

				if ( ( ( de and de == val1 ) or ( en and en == val1 ) or ( fr and fr == val1 ) ) and v["id"] ~= -1 ) then
					for key, val in CT_RA_CurrPositions do
						local name, rank, subgroup, level, class = GetRaidRosterInfo(key);
						if ( CastParty_AddDebuff and name == nick ) then
							CastParty_AddDebuff("raid" .. key, val1);
						end
						if ( name == nick and ( ( not CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[val] ) or ( CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[CT_RA_ClassPositions[class]] ) ) ) then
							if ( ( not CT_RA_HideShort or tonumber(val3) >= 10 ) and val2 ~= "Mind Vision" ) then
								local postfix = " (|c00FFFFFF" .. string.gsub(val1, "_", " ") .. "|r)";
								if ( string.gsub(val1, "_", " ") == val2 ) then
									postfix = "";
								end
								if ( CT_RA_ClassSpells and GetBindingKey("CT_CUREDEBUFF") and CT_RA_GetCure(val1)) then
									CT_RA_AddToQueue(val1, "raid"..key, string.gsub(val1, "_", " "));
									return update, "<CTMod> '|c00FFFFFF" .. nick .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ". Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_CUREDEBUFF"), "KEY_") .. "|r' to cure.";
								else
									return update, "<CTMod> '|c00FFFFFF" .. nick .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ".";
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
	useless, useless, val4, val3, val1, val2 = string.find(msg, "^DPA ([^%s]+) ([^%s]+) ([%a_]+) (.+)$"); -- nick(4), texture(3), type(1), name(2)
	if ( val1 and val2 and val3 and val4 ) then
		-- Debuff
		--[[ Experimental, not working yet
		if ( val2 == "Living Bomb" and CT_RA_Geddon_Status == 3 and val4 ~= UnitName("player") ) then
			CT_RA_WarningFrame:AddMessage(val4 .. " IS THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
		]]
		if ( not CT_RA_Stats[val4] ) then
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
				break;
			end
		end
		if ( CT_RA_NotifyDebuffs["main"] ) then
			for k, v in CT_RA_DebuffColors do
				local en = v["type"]["en"];
				local de = v["type"]["de"];
				local fr = v["type"]["fr"];

				if ( ( ( de and de == val1 ) or ( en and en == val1 ) or ( fr and fr == val1 ) ) and v["id"] ~= -1 ) then
					for key, val in CT_RA_CurrPositions do
						local name, rank, subgroup, level, class = GetRaidRosterInfo(key);
						if ( CastParty_AddDebuff and name == val4 ) then
							CastParty_AddDebuff("raid" .. key, val1);
						end
						if ( name == val4 and ( ( not CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[val] ) or ( CT_RA_NotifyClasses and CT_RA_NotifyDebuffs[CT_RA_ClassPositions[class]] ) ) ) then
							local postfix = " (|c00FFFFFF" .. string.gsub(val1, "_", " ") .. "|r)";
							if ( string.gsub(val1, "_", " ") == val2 ) then
								postfix = "";
							end
							if ( CT_RA_ClassSpells and GetBindingKey("CT_CUREDEBUFF") and CT_RA_GetCure(val1) ) then
								CT_RA_AddToQueue(val1, "raid"..key, string.gsub(val1, "_", " "));
								return update, "<CTMod> '|c00FFFFFF" .. val4 .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ". Press '|c00FFFFFF" .. KeyBindingFrame_GetLocalizedName(GetBindingKey("CT_CUREDEBUFF"), "KEY_") .. "|r' to cure.";
							else
								return update, "<CTMod> '|c00FFFFFF" .. val4 .. "|r' has been debuffed by '|c00FFFFFF" .. val2 .. "|r'" .. postfix .. ".";
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
				if ( CT_RA_PlayRSSound ) then
					PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav");
				end
				CT_RAMessageFrame:AddMessage(nick .. ": " .. strsub(msg, 3), CT_RA_DefaultAlertColor.r,CT_RA_DefaultAlertColor.g, CT_RA_DefaultAlertColor.b, 1.0, UIERRORS_HOLD_TIME);
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
					if ( name == UnitName("player") ) then
						CT_RA_SendTargetInfo(tonumber(num));
					end
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

	if ( strsub(msg, 1, 3) == "MT " ) then
		local useless, useless, id, type, percent = string.find(msg, "^MT ([^%s]+) (.) (%d+)$");
		if ( id and type and percent ) then
			id = tonumber(id);
			percent = tonumber(percent);
			if ( CT_RA_MainTanks[id] == nick ) then
				if ( not CT_RA_MainTankStats[id] ) then return; end

				if ( type == "H" ) then
					CT_RA_MainTankStats[id]["health"] = percent;
				elseif ( type == "M" ) then
					CT_RA_MainTankStats[id]["mana"] = percent;
				end
			end
		end
		CT_RA_UpdateMTs();
		return update;
	end
	if ( strsub(msg, 1, 3) == "TC " ) then
		local useless, useless, id, hasmana, friend, health, mana, name = string.find(msg, "^TC (%d) (%d) (%d) ([^%s]+) ([^%s]+) (.+)$");
		if ( id and hasmana and friend and health and mana and name and CT_RA_MainTanks[tonumber(id)] == nick ) then
			id = tonumber(id);
			friend = tonumber(friend);
			health = tonumber(health);
			mana = tonumber(mana);
			hasmana = tonumber(hasmana);
			CT_RA_MainTankStats[id] = { };
			CT_RA_MainTankStats[id]["hasmana"] = hasmana;
			CT_RA_MainTankStats[id]["friend"] = friend;
			CT_RA_MainTankStats[id]["name"] = name;
			CT_RA_MainTankStats[id]["health"] = health;
			if ( mana ~= -1 ) then
				CT_RA_MainTankStats[id]["mana"] = mana;
			end
			CT_RA_UpdateMTs();
		end
		return update;
	end

	if ( strsub(msg, 1, 3) == "LT " ) then
		local id = strsub(msg, 4);
		if ( tonumber(id) and CT_RA_MainTanks[tonumber(id)] == nick ) then
			CT_RA_MainTankStats[tonumber(id)] = nil;
		end
		CT_RA_UpdateMTs();
		return update;
	end
	
	if ( strsub(msg, 1, 2) == "P " ) then
		local useless, useless, hp, max, mana = string.find(msg, "^P ([^%s]+) ([^%s]+) (%d+)$");
		if ( tonumber(hp) and tonumber(mana) and tonumber(max)) then
			CT_RA_Stats[nick]["Health"] = floor(tonumber(hp));
			CT_RA_Stats[nick]["Healthmax"] = tonumber(max);
			CT_RA_Stats[nick]["Mana"] = tonumber(mana);
			if ( tonumber(hp) == -1 ) then
				CT_RA_Stats[nick]["Buffs"] = { };
				CT_RA_Stats[nick]["Debuffs"] = { };
				if ( CastParty_ClearDebuffs ) then
					CastParty_ClearDebuffs("raid" .. raidid);
				end
			end
		else
			-- Backwards compatibility
			local useless, useless, hp, mana = string.find(msg, "^P ([^%s]+) (%d+)$");
			if ( tonumber(hp) and tonumber(mana)) then
				CT_RA_Stats[nick]["Health"] = floor(tonumber(hp));
				CT_RA_Stats[nick]["Mana"] = tonumber(mana);
				if ( tonumber(hp) == -1 and not CT_RA_Stats[nick]["Buffs"]["Feign Death"] ) then
					CT_RA_Stats[nick]["Buffs"] = { };
					CT_RA_Stats[nick]["Debuffs"] = { };
					if ( CastParty_ClearDebuffs ) then
						CastParty_ClearDebuffs("raid" .. raidid);
					end
				end
			end
		end
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
		CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
		return update;
	end

	if ( strsub(msg, 1, 3) == "PH " ) then
		local useless, useless, player, val, max = string.find(msg, "^P. ([^%s]+) ([^%s]+) ([^%s]+)$");
		if ( player and tonumber(val) and tonumber(max) ) then
			if ( not CT_RA_Stats[player] ) then
				CT_RA_Stats[player] = {
					["Health"] = nil,
					["Mana"] = nil,
					["Buffs"] = { },
					["Debuffs"] = { },
					["Position"] = { }
				};
				tinsert(update, player);
			end
			local prevhealth = CT_RA_Stats[player]["Health"];
			CT_RA_Stats[player]["Health"] = floor(tonumber(val));
			CT_RA_Stats[player]["Healthmax"] = tonumber(max);
			if ( floor(tonumber(val)) ~= -1 ) then
				CT_RA_Stats[player]["Ressed"] = nil;
			end
			if ( tonumber(val1) == -1 and not CT_RA_Stats[player]["Buffs"]["Feign Death"] ) then
				CT_RA_Stats[player]["Buffs"] = { };
				CT_RA_Stats[player]["Debuffs"] = { };
			end
			for i = 1, GetNumRaidMembers(), 1 do
				if ( UnitName("raid" .. i) and UnitName("raid" .. i) == player ) then
					local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
					if ( CastParty_ClearDebuffs ) then
						CastParty_ClearDebuffs("raid" .. i);
					end
					if ( ( floor(tonumber(val)) == -1 and not CT_RA_Stats[player]["Buffs"]["Feign Death"] ) or ( prevhealth and prevhealth == -1 ) ) then
						CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online, isDead);
					else
						CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. i), floor(tonumber(val)), tonumber(max), fileName);
					end
					return update;
				end
			end		
		else
			-- Backwards compatibility
			local useless, useless, player, val, max = string.find(msg, "^P. ([^%s]+) ([^%s]+)$");
			if ( player and tonumber(val) ) then
				if ( not CT_RA_Stats[player] ) then
					CT_RA_Stats[player] = {
						["Health"] = nil,
						["Mana"] = nil,
						["Buffs"] = { },
						["Debuffs"] = { },
						["Position"] = { }
					};
					tinsert(update, player);
				end
				local prevhealth = CT_RA_Stats[player]["Health"];
				CT_RA_Stats[player]["Health"] = floor(tonumber(val));
				if ( floor(tonumber(val)) ~= -1 ) then
					CT_RA_Stats[player]["Ressed"] = nil;
				end
				if ( tonumber(val1) == -1 and not CT_RA_Stats[player]["Buffs"]["Feign Death"] ) then
					CT_RA_Stats[player]["Buffs"] = { };
					CT_RA_Stats[player]["Debuffs"] = { };
				end
				for i = 1, GetNumRaidMembers(), 1 do
					if ( UnitName("raid" .. i) and UnitName("raid" .. i) == player ) then
						local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
						if ( ( floor(tonumber(val)) == -1 and not CT_RA_Stats[player]["Buffs"]["Feign Death"] ) or ( prevhealth and prevhealth == -1 ) ) then
							CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online, isDead);
						else
							CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. i), floor(tonumber(val)), tonumber(max), fileName);
						end
						return update;
					end
				end
			end
		end
	end
	if ( strsub(msg, 1, 3) == "PM " ) then
		local useless, useless, player, val = string.find(msg, "^P. ([^%s]+) ([^%s]+)$");
		if ( player and tonumber(val) ) then
			if ( not CT_RA_Stats[player] ) then
				CT_RA_Stats[player] = {
					["Health"] = nil,
					["Healthmax"] = nil,
					["Mana"] = nil,
					["Buffs"] = { },
					["Debuffs"] = { },
					["Position"] = { }
				};
				tinsert(update, player);
			end
			CT_RA_Stats[player]["Mana"] = tonumber(val);
			for i = 1, GetNumRaidMembers(), 1 do
				if ( UnitName("raid" .. i) and UnitName("raid" .. i) == player ) then
					local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
					CT_RA_UpdateUnitMana(getglobal("CT_RAMember" .. i), tonumber(val));
					return update;
				end
			end
		end
	end

	if ( strsub(msg, 1, 3) == "PR " ) then
		local useless, useless, player = string.find(msg, "^PR (.+)$");
		if ( player and CT_RA_Stats[player] ) then
			CT_RA_Stats[player] = nil;
			for i = 1, GetNumRaidMembers(), 1 do
				if ( UnitName("raid" .. i) and UnitName("raid" .. i) == player ) then
					local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
					CT_RA_UpdateUnitStatus(class, getglobal("CT_RAMember" .. i), fileName, name, online, isDead);
					return update;
				end
			end
		end
	end

	if ( msg == "DB" ) then
		for i = 1, GetNumRaidMembers(), 1 do
			local user, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( rank >= 1 and user == nick ) then
				CT_RA_Print("<CTMod> Disbanding raid on request by '|c00FFFFFF" .. nick .. "|r'.", 1, 0.5, 0);
				LeaveParty();
				return update;
			end
		end
	end

	if ( msg == "RESSED" ) then
		CT_RA_Stats[nick]["Ressed"] = 1;
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
		CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
		return update;
	end

	if ( msg == "NORESSED" ) then
		CT_RA_Stats[nick]["Ressed"] = nil;
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidid);
		CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, isDead);
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
	msg = string.gsub(msg, "S", "¤");
	if ( CT_RA_Channel and GetChannelName(CT_RA_Channel) and ( not CT_RA_LastSend or CT_RA_LastSend ~= msg or force ) ) then
		CT_RA_LastSend = msg;
		SendChatMessage(msg, "CHANNEL", nil, GetChannelName(CT_RA_Channel));
	end
end

function CT_RA_OnEvent(event)
	if ( event == "RAID_ROSTER_UPDATE" or event == "VARIABLES_LOADED" ) then
		if ( event == "RAID_ROSTER_UPDATE" ) then
			if ( GetNumRaidMembers() == 0 ) then
				CT_RA_MainTanks = { };
				CT_RA_MainTankStats = { };
				CT_RA_Stats = { };
				CT_RA_ButtonIndexes = { };
				CT_RA_ChangeChannel();
			end
			if ( CT_RA_NumRaidMembers == 0 and GetNumRaidMembers() > 0 ) then
				CT_RA_UpdateFrame.SS = 5;
				if ( event == "RAID_ROSTER_UPDATE" ) then
					CT_RA_ChangeChannel();
				end
			end
		end
		if ( CT_RA_ResFrame_Options["Shown"] and GetNumRaidMembers() > 0 ) then
			CT_RA_ResFrame:Show();
		else
			CT_RA_ResFrame:Hide();
		end
		CT_RA_NumRaidMembers = GetNumRaidMembers();
		CT_RA_UpdateRaidGroup();
		CT_RAOptions_Update();
		CT_RA_UpdateMTs();
		if ( not CT_RA_Channel and GetGuildInfo("player") ) then
			CT_RA_Channel = "CT" .. string.gsub(GetGuildInfo("player"), "[^%w]", "");
		end

	end
	if ( event == "UNIT_NAME_UPDATE" ) then
		if ( arg1 == "player" and UnitName("player") ~= "Unknown Unit" ) then
			if ( CT_RA_RaidParticipant ) then
				if ( CT_RA_RaidParticipant ~= UnitName("player") ) then
					CT_RA_Stats = { { } };
					CT_RA_MainTankStats = { };
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

	if ( not CT_RA_Channel ) then return; end
	-- All events below this line requires CT_RA_Channel to be initialized

	if ( event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" ) then
		if ( arg1 == "player" ) then
			local health = floor(UnitHealth("player")/UnitHealthMax("player")*100);
			if ( not CT_RA_LastSent["health"] or abs(CT_RA_LastSent["health"]-health) >= CT_RA_Comm_HPChangeThreshold or ( health == 100 and CT_RA_LastSent["health"] < 100 ) ) then
				if ( UnitIsDead("player") or UnitIsGhost("player")) then
					health = -1;
				end
				CT_RA_AddMessage("H " .. health .. " " .. UnitHealthMax("player"));
				CT_RA_LastSent["health"] = health;
			end
			return;
		elseif ( strsub(arg1, 1, 5) == "party" ) then
			if ( UnitName(arg1) and UnitHealthMax(arg1) and UnitHealth(arg1) and CT_RA_IsReportingForParty() and ( not CT_RA_Stats[UnitName(arg1)] or not CT_RA_Stats[UnitName(arg1)]["Reporting"] ) ) then
				local health = floor(UnitHealth(arg1)/UnitHealthMax(arg1)*100+0.5);
				if ( UnitIsDead(arg1) or UnitIsGhost(arg1) ) then
					health = -1;
				end
				if ( health and ( not CT_RA_LastSent[arg1 .. "health"] or abs(CT_RA_LastSent[arg1 .. "health"]-health) >= CT_RA_Comm_HPChangeThreshold ) or health == 100 ) then
					CT_RA_AddMessage("PH " .. UnitName(arg1) .. " " .. health .. " " .. UnitHealthMax(arg1));
					CT_RA_LastSent[arg1 .. "health"] = health;
				end
			end
		elseif ( arg1 == "target" ) then
			for k, v in CT_RA_MainTanks do
				if ( UnitName("player") == v ) then
					-- Player is a main tank
					local health = floor(UnitHealth("target")/UnitHealthMax("target")*100);
					if ( UnitIsDead("target") ) then
						health = -1;
					end
					if ( not CT_RA_LastSent["mthealth"] or abs(CT_RA_LastSent["mthealth"]-health) >= CT_RA_Comm_MTHPChangeThreshold ) then
						CT_RA_AddMessage("MT " .. k .. " H " .. health);
						CT_RA_LastSent["mthealth"] = health;
					end
					return;
				end
			end
		end
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		for k, v in CT_RA_MainTanks do
			if ( v == UnitName("player") ) then
				CT_RA_SendTargetInfo(k);
			end
		end
	end

	if ( event == "UNIT_AURA" ) then
		if ( strsub(arg1, 1, 5) == "party" and ( not CT_RA_Stats[UnitName(arg1)] or not CT_RA_Stats[UnitName(arg1)]["Reporting"] ) ) then
			if ( CT_RA_IsReportingForParty() ) then
				local table = CT_RA_ScanPartyAuras(arg1);
				for k, v in table do
					CT_RA_AddMessage(v);
				end
				return;
			end
		end
	end

	if ( event == "UNIT_MANA" or event == "UNIT_MAXMANA" or event == "UNIT_RAGE" or event == "UNIT_MAXRAGE" or event == "UNIT_ENERGY" or event == "UNIT_MAXENERGY" ) then
		if ( arg1 == "player" ) then
			local mana = floor(UnitMana("player")/UnitManaMax("player")*100);
			if ( not CT_RA_LastSent["mana"] or abs(CT_RA_LastSent["mana"]-mana) >= CT_RA_Comm_MPChangeThreshold or ( mana == 100 and CT_RA_LastSent["mana"] < 100 )  ) then
				CT_RA_AddMessage("M " .. mana);
				CT_RA_LastSent["mana"] = mana;
			end
			return;
		elseif ( strsub(arg1, 1, 5) == "party" ) then
			if ( UnitName(arg1) and CT_RA_IsReportingForParty() and ( not CT_RA_Stats[UnitName(arg1)] or not CT_RA_Stats[UnitName(arg1)]["Reporting"] ) ) then
				local mana = floor(UnitMana(arg1)/UnitManaMax(arg1)*100+0.5);
				if ( not CT_RA_LastSent[arg1 .. "mana"] or abs(CT_RA_LastSent[arg1 .. "mana"]-mana) >= CT_RA_Comm_MPChangeThreshold or mana == 100 ) then
					CT_RA_AddMessage("PM " .. UnitName(arg1) .. " " .. mana);
					CT_RA_LastSent[arg1 .. "mana"] = mana;
				end
			end
		elseif ( arg1 == "target" ) then
			for k, v in CT_RA_MainTanks do
				if ( UnitName("player") == v ) then
					-- Player is a main tank
					if ( UnitPowerType("target") == 0 ) then
						local mana = floor(UnitMana("target")/UnitManaMax("target")*100);
						if ( not CT_RA_LastSent["mtmana"] or abs(CT_RA_LastSent["mtmana"]-mana) >= CT_RA_Comm_MTMPChangeThreshold ) then
							CT_RA_AddMessage("MT " .. k .. " M " .. mana);
							CT_RA_LastSent["mtmana"] = mana;
						end
					end
					return;
				end
			end
		end
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
		CT_RA_AddMessage("H -1");
		CT_RA_LastSent["health"] = -1;
		local msgs = CT_RA_ScanAuras();
		if ( msgs ) then
			for k, v in msgs do
				CT_RA_AddMessage(v);
			end
		end
	end


	if ( ( ( event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE" ) and CT_RA_Geddon_Status == 2 ) or ( event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" and CT_RA_Geddon_Status <= 2 ) ) then
		local iStart, iEnd, sPlayer, sType = string.find(arg1, "^([^%s]+) (%w+) afflicted with Living Bomb");
		if ( sPlayer and sType ) then
			if ( sPlayer == "You" and sType == "are" ) then
				CT_RA_WarningFrame:AddMessage("YOU ARE THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
				PlaySoundFile("Sound\\Doodad\\BellTollAlliance.wav");
			else
				CT_RA_WarningFrame:AddMessage(sPlayer .. " IS THE BOMB!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
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
function CT_RA_UpdateUnitHealth(frame, percent, max, fileName)
	if ( percent and percent > 0 ) then

		if ( fileName ) then
			local color = RAID_CLASS_COLORS[fileName];
			if ( color ) then
				getglobal(frame:GetName() .. "Name"):SetTextColor(color.r, color.g, color.b);
			end
		end

		if ( percent > 100 ) then
			percent = 100;
		end
		getglobal(frame:GetName() .. "HPBar"):SetValue(percent);

		if ( CT_RA_ShowHP and CT_RA_ShowHP == 1 and max ) then
			getglobal(frame:GetName() .. "Percent"):SetText(floor(percent/100*max) .. "/" .. max);
		elseif ( CT_RA_ShowHP and CT_RA_ShowHP == 2 ) then
			getglobal(frame:GetName() .. "Percent"):SetText(percent .. "%");
		elseif ( CT_RA_ShowHP and CT_RA_ShowHP == 3 ) then
			if ( max ) then
				local diff = floor(percent/100*max)-max;
				if ( diff == 0 ) then diff = ""; end
				getglobal(frame:GetName() .. "Percent"):SetText(diff);
			else
				getglobal(frame:GetName() .. "Percent"):SetText(percent-100 .. "%");
			end
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
		if ( CT_RA_MemberHeight == 40 ) then
			getglobal(frame:GetName() .. "HPBar"):Show();
			if ( CT_RA_ShowHP and CT_RA_ShowHP < 4 ) then
				getglobal(frame:GetName() .. "Percent"):Show();
			end
		end
	end
end

-- Update status

function CT_RA_UpdateUnitStatus(class, frame, fileName, name, online, dead)
	local height = CT_RA_MemberHeight;
	if ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RA_HideRP ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RA_HideMP ) ) then
		height = height - 4;
	end
	if ( CT_RA_HideBorder ) then
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
		if ( CT_RA_ShowHP and CT_RA_ShowHP < 4 ) then
			getglobal(frame:GetName() .. "Percent"):Show();
		else
			getglobal(frame:GetName() .. "Percent"):Hide();
		end
		getglobal(frame:GetName() .. "HPBar"):Show();
	end
	stats = CT_RA_Stats[name];
	if ( frame.group and CT_RA_ShowGroups[frame.group:GetID()] ) then
		frame:Show();
	end
	getglobal(frame:GetName() .. "Name"):SetText(name);
	CT_RA_UpdateUnitDead(frame);
	if ( stats and online ) then
		CT_RA_UpdateUnitBuffs(stats["Buffs"], frame, name);
	end
	if ( online and stats and stats["Health"] and stats["Health"] >= 0 and not dead ) then
		CT_RA_UpdateUnitHealth(frame, stats["Health"], stats["Healthmax"]);
		CT_RA_UpdateUnitMana(frame, stats["Mana"]);
		CT_RA_UpdateUnitDebuffs(stats["Debuffs"], frame);
	end
end

-- Update mana
function CT_RA_UpdateUnitMana(frame, percent)
	-- Mana
	if ( not percent ) then
		return;
	end
	getglobal(frame:GetName() .. "MPBar"):SetValue(percent);
end

-- Update buffs
function CT_RA_UpdateUnitBuffs(buffs, frame, nick)
	local num = 1;
	if ( buffs ) then
		-- Feign Death check
		local height = CT_RA_MemberHeight;
		for k, v in buffs do
			local en = CT_RA_FEIGNDEATH["en"];
			local de = CT_RA_FEIGNDEATH["de"];
			local fr = CT_RA_FEIGNDEATH["fr"];
			if ( ( en and k == CT_RA_FEIGNDEATH["en"] ) or ( de and k == de ) or ( fr and k == fr ) ) then
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
		
		if ( not CT_RA_ShowDebuffs ) then
			for key, val in CT_RA_BuffArray do
				local en, de, fr, name;
				if ( val["name"]["en"] ) then
					if ( type(val["name"]["en"]) == "string" ) then
						en = buffs[val["name"]["en"]];
						name = val["name"]["en"];
					elseif ( buffs[val["name"]["en"][1]] ) then
						en = buffs[val["name"]["en"][1]];
						name = val["name"]["en"][1];
					elseif ( buffs[val["name"]["en"][2]] ) then
						en = buffs[val["name"]["en"][2]];
						name = val["name"]["en"][2];
					end
				end
				if ( val["name"]["de"] ) then
					if ( type(val["name"]["de"]) == "string" ) then
						de = buffs[val["name"]["de"]];
						name = val["name"]["de"];
					elseif ( buffs[val["name"]["de"][1]] ) then
						de = buffs[val["name"]["de"][1]];
						name = val["name"]["de"][1];
					elseif ( buffs[val["name"]["de"][2]] ) then
						de = buffs[val["name"]["de"][2]];
						name = val["name"]["de"][2];
					end
				end
				if ( val["name"]["fr"] ) then
					if ( type(val["name"]["fr"]) == "string" ) then
						fr = buffs[val["name"]["fr"]];
						name = val["name"]["fr"];
					elseif ( buffs[val["name"]["fr"][1]] ) then
						fr = buffs[val["name"]["fr"][1]];
						name = val["name"]["fr"][1];
					elseif ( buffs[val["name"]["fr"][2]] ) then
						fr = buffs[val["name"]["fr"][2]];
						name = val["name"]["fr"][2];
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
	local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(frame:GetID());
	local height = CT_RA_MemberHeight;
	if ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RA_HideRP ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RA_HideMP ) ) then
		height = height - 4;
	end
	if ( not online ) then
		if ( CT_RA_HideOffline ) then
			frame:Hide();
		end
		for i = 1, 4, 1 do
			if ( i <= 2 ) then
				getglobal(frame:GetName() .. "DebuffButton" .. i):Hide();
			end
			getglobal(frame:GetName() .. "BuffButton" .. i):Hide();
		end
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RA_HideBorder and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RA_HideRP ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RA_HideMP ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Status"):SetText("OFFLINE");
		getglobal(frame:GetName() .. "Status"):Show();
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.75, 0.75, 0.75);
		return;
	elseif ( not stats ) then
		if ( CT_RA_HideNA and online ) then
			frame:Hide();
		end
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RA_HideBorder and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RA_HideRP ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RA_HideMP ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.5, 0.5, 0.5);
		getglobal(frame:GetName() .. "Status"):SetText("N/A");
		getglobal(frame:GetName() .. "Status"):Show()

		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		return;
	elseif ( stats["Ressed"] ) then
		getglobal(frame:GetName() .. "Status"):Show();
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RA_HideBorder and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RA_HideRP ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RA_HideMP ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Status"):SetText("Resurrected");
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.5, 0.5, 0.5);
	elseif ( ( stats["Health"] and stats["Health"] <= 0 ) or dead ) then

		getglobal(frame:GetName() .. "Status"):Show();
		frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
		if ( CT_RA_HideBorder and ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RA_HideRP ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RA_HideMP ) ) ) then
			frame:SetHeight(height+3);
		end
		getglobal(frame:GetName() .. "Status"):SetText("DEAD");
		getglobal(frame:GetName() .. "HPBar"):Hide();
		getglobal(frame:GetName() .. "Percent"):Hide();
		getglobal(frame:GetName() .. "MPBar"):Hide();
		getglobal(frame:GetName() .. "Name"):SetTextColor(0.5, 0.5, 0.5);
	else
		frame:SetBackdropColor(CT_RA_DefaultColor.r, CT_RA_DefaultColor.g, CT_RA_DefaultColor.b, CT_RA_DefaultColor.a);
		local color = RAID_CLASS_COLORS[fileName];
		if ( color ) then
			getglobal(frame:GetName() .. "Name"):SetTextColor(color.r, color.g, color.b);
		end
		getglobal(frame:GetName() .. "Status"):Hide();
		if ( ( not CT_RA_HideRP and ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and not CT_RA_HideMP ) ) then
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
	if ( name and CT_RA_Stats[name] and CT_RA_Stats[name]["Health"] and CT_RA_Stats[name]["Health"] ~= -1 and online and not isDead ) then
		if ( not CT_RA_Stats[name]["Buffs"]["Feign Death"] ) then
			frame:SetBackdropColor(CT_RA_DefaultColor["r"], CT_RA_DefaultColor["g"], CT_RA_DefaultColor["g"], CT_RA_DefaultColor["a"]);
		end
		if ( debuffs ) then
			for key, val in CT_RA_DebuffColors do
				for k, v in debuffs do
					local en = val["type"]["en"];
					local de = val["type"]["de"];
					local fr = val["type"]["fr"];
					if ( ( ( en and en == v[1] ) or ( de and de == v[1] ) or ( fr and fr == v[1] ) ) and val["id"] ~= -1 and ( v[2] >= 10 or not CT_RA_HideShort ) ) then
						if ( CT_RA_ShowDebuffs and num <= 2 ) then
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
		[CT_RA_WARLOC] = 4,
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
		if ( CT_RA_ShowMTs[key] ) then
			local frame = getglobal("CT_RAMTGroupMember" .. key);
			local framecast = getglobal("CT_RAMTGroupMember" .. key .. "CastFrame");
			frame:SetBackdropColor(CT_RA_DefaultColor["r"], CT_RA_DefaultColor["g"], CT_RA_DefaultColor["g"], CT_RA_DefaultColor["a"]);
			frame:GetParent():Show();
			frame:Show();
			local height = CT_RA_MemberHeight;
			if ( CT_RA_HideMP ) then
				height = height - 4;
			end
			if ( CT_RA_HideBorder ) then
				getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOP", 2, -16);
				frame:SetBackdropBorderColor(1, 1, 1, 0);
				getglobal(frame:GetName() .. "HPBar"):SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 10, -19);
				frame:SetHeight(height-3);
				framecast:SetHeight(height-3);
				framecast:SetWidth(85);
			else
				frame:SetBackdropBorderColor(1, 1, 1, 1);
				getglobal(frame:GetName() .. "HPBar"):SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 10, -22);
				getglobal(frame:GetName().. "Percent"):SetPoint("TOP", frame:GetName(), "TOP", 2, -18);
				frame:SetHeight(height);
				framecast:SetHeight(height);
				framecast:SetWidth(90);
			end
			if ( not CT_RA_HideNames ) then
				getglobal(frame:GetParent():GetName() .. "GroupName"):Show();
			else
				getglobal(frame:GetParent():GetName() .. "GroupName"):Hide();
			end
			if ( not CT_RA_LockGroups ) then
				CT_RAMTGroupDrag:Show();
				hide = nil;
			end
			if ( CT_RA_MainTankStats[key] ) then
				local v = CT_RA_MainTankStats[key];	
				getglobal(frame:GetName() .. "Name"):SetHeight(15);
				getglobal(frame:GetName() .. "Status"):Hide();
				getglobal(frame:GetName() .. "HPBar"):Show();
				getglobal(frame:GetName() .. "MPBar"):Show();
				getglobal(frame:GetName() .. "Name"):Show();
				if ( v["health"] ~= -1 and v["health"] and type(v["health"]) == "number" ) then
					if ( CT_RA_ShowHP ) then
						getglobal(frame:GetName() .. "Percent"):Show();
					else
						getglobal(frame:GetName() .. "Percent"):Hide();
					end
					getglobal(frame:GetName() .. "HPBar"):SetValue(v["health"]);
					getglobal(frame:GetName() .. "Percent"):SetText(v["health"] .. "%");
					local percent = v["health"]/100;
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
				elseif ( v["health"] == -1 ) then
					getglobal(frame:GetName() .. "HPBar"):Hide();
					getglobal(frame:GetName() .. "Percent"):Hide();
					getglobal(frame:GetName() .. "MPBar"):Hide();
					getglobal(frame:GetName() .. "Status"):Show();
					getglobal(frame:GetName() .. "Status"):SetText("DEAD");
				else
					getglobal(frame:GetName() .. "HPBar"):Hide();
				end
				if ( v["hasmana"] == 1 and not CT_RA_HideMP ) then
					if ( CT_RA_HideBorder ) then
						frame:SetHeight(37);
						framecast:SetHeight(37);
					else
						frame:SetHeight(40);
						framecast:SetHeight(40);
					end
					getglobal(frame:GetName() .. "MPBar"):Show();
					getglobal(frame:GetName() .. "MPBar"):SetValue(v["mana"]);
				else
					getglobal(frame:GetName() .. "MPBar"):Hide();
					if ( CT_RA_HideBorder ) then
						frame:SetHeight(33);
						framecast:SetHeight(33);
					else
						frame:SetHeight(36);
						framecast:SetHeight(36);
					end
				end
				getglobal(frame:GetName() .. "Name"):SetText(v["name"]);
				getglobal(frame:GetName() .. "CastFrame").name = v["name"];
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
end

function CT_RA_UpdateGroupVisibility(num)
	local group = getglobal("CT_RAGroup" .. num);
	if ( not CT_RA_ShowGroups or not CT_RA_ShowGroups[num] or GetNumRaidMembers() == 0 or not group.next ) then
		group:Hide();
		getglobal("CT_RAGroupDrag" .. num):Hide();
	elseif ( group.next ) then
		if ( CT_RA_LockGroups ) then
			getglobal("CT_RAGroupDrag" .. num):Hide();
		else
			getglobal("CT_RAGroupDrag" .. num):Show();
		end
		if ( CT_RA_HideNames ) then
			getglobal(group:GetName() .. "GroupName"):Hide();
		else
			getglobal(group:GetName() .. "GroupName"):Show();
		end
		group:Show();
	end
	while ( group.next ) do
		if ( CT_RA_ShowGroups and CT_RA_ShowGroups[num] ) then
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
end
			
function CT_RA_UpdateRaidGroup()
	if ( CT_RA_SORTTYPE == "group" ) then
		CT_RA_SortByGroup();
	elseif ( CT_RA_SORTTYPE == "custom" ) then
		CT_RA_SortByCustom();
	elseif ( CT_RA_SORTTYPE == "class" ) then
		CT_RA_SortByClass();
	end
	local numRaidMembers = GetNumRaidMembers();
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local groups_showing = { };

	for i=1, MAX_RAID_MEMBERS do
		if ( i <= numRaidMembers ) then
			name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( CT_RA_Stats[name] and CT_RA_Stats[name]["Health"] and CT_RA_Stats[name]["Health"] <= 1 ) then
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

				if ( CT_RA_ShowGroups and CT_RA_ShowGroups[group:GetID()] ) then
					if ( not CT_RA_LockGroups ) then
						groups_showing[group:GetID()] = 1;
					end
					local height = CT_RA_MemberHeight;
					if ( ( ( class == CT_RA_WARRIOR or class == CT_RA_ROGUE ) and CT_RA_HideRP ) or ( class ~= CT_RA_WARRIOR and class ~= CT_RA_ROGUE and CT_RA_HideMP ) ) then
						height = height - 4;
					end

					getglobal(button:GetName() .. "Name"):SetText(name);
					getglobal(button:GetName() .. "CastFrame").name = name;
					CT_RA_UpdateUnitStatus(class, button, fileName, name, online, dead);
				end
			end
		else
			getglobal("CT_RAMember" .. i):Hide();
			getglobal("CT_RAMember" .. i).next = nil;
		end
	end
	CT_RA_UpdateVisibility();
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
	end
	if ( CT_RA_HideTooltip ) then
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
		
	GameTooltip:Show();
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
		AssistByName(CT_RA_MainTanks[id]);
	end
end

function CT_RA_MemberFrame_OnClick(button)
	local id = this:GetParent():GetParent():GetID();
	local func = TargetUnit;
	if ( strsub(this:GetParent():GetName(), 1, 12) == "CT_RAMTGroup" ) then
		func = AssistUnit;
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
	end
	if ( CastParty_OnClickByUnitWithHealth ) then
		local memberName = GetRaidRosterInfo(id);
		local health = CT_RA_Stats[memberName]["Health"] * CT_RA_Stats[memberName]["Healthmax"] / 100
		CastParty_OnClickByUnitWithHealth(button, "raid" .. id, health, CT_RA_Stats[memberName]["Healthmax"]);
	else
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("raid" .. id);
		else
			func("raid" .. id);
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
	local health = ceil(UnitHealth("player")/UnitHealthMax("player")*100);
	if ( UnitIsDead("player") or UnitIsGhost("player")) then
		health = -1;
	end
	CT_RA_AddMessage("P " .. health .. " " .. UnitHealthMax("player") .. " " .. ceil(UnitMana("player")/UnitManaMax("player")*100));
	CT_RA_AddMessage("V " .. CT_RA_VersionNumber);
	for k, v in CT_RA_MainTanks do
		if ( v == UnitName("player") ) then
			CT_RA_AddMessage("SET " .. k .. " " .. v);
			CT_RA_SendTargetInfo(k);
			break;
		end
	end
	if ( CT_RA_IsReportingForParty() ) then
		for i = 1, GetNumPartyMembers(), 1 do
			local name = UnitName("party" .. i);
			if ( not CT_RA_Stats[name] or not CT_RA_Stats[name]["Reporting"] ) then
				if ( UnitHealthMax("party" .. i) and UnitHealthMax("party" .. i) ~= 1 ) then
					CT_RA_AddMessage("SM " .. name .. " " .. UnitHealthMax("party" .. i));
				end
				if ( CT_RA_Stats[name] ) then
					CT_RA_Stats[name]["Buffs"] = { };
				end
				local table = CT_RA_ScanPartyAuras("party" .. i);
				for k, v in table do
					CT_RA_AddMessage(v);
				end
			end
		end
	end
end	

SLASH_RA1 = "/raidassist";
SLASH_RS1 = "/rs";

SlashCmdList["RS"] = function(msg)
	if ( CT_RA_Level >= 1 ) then
		CT_RA_AddMessage("MS " .. msg);
	else
		CT_RA_Print("<CTMod> You must be promoted or leader to do that!", 1, 1, 0);
	end
end

SlashCmdList["RA"] = function(msg)
	msg = strlower(msg);
	if ( msg == "" or msg == "help" ) then
		CT_RA_Print("<CTMod> RaidAssist uses the following slash commmands:", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/raidassist update|r - Updates raid stats (requires leader or promoted status)", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/raidassist set [channel]|r - Sets RaidAssist to monitor channel '|c00FFFFFF[channel]|r'", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/raidassist broadcast|r - Broadcasts the RaidAssist channel (requires leader or promoted status)", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/raidassist join|r - Joins the RaidAssist channel", 1, 0.5, 0);
		CT_RA_Print("<CTMod> There are also other commands:", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/rakeyword keyword|r - Automatically invites people whispering you the set keyword", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/rainvite minlevel-maxlevel|r or |c00FFFFFF/rainvite level|r - Invites people within the set level range", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/radisband|r - Disbands the raid (requires leader or promoted status)", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/rashow|r - Shows raid windows that were hidden with /rahide", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/rashow all|r - Shows all raid windows", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/rahide|r - Hides all raid windows", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/raoptions|r - Shows the options window", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/rares [show/hide]|r - Shows/hides the Resurrection Monitor.", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/raidassist onyxia [on/off]|r - Turns onyxia AE warning on/off", 1, 0.5, 0);
		CT_RA_Print("<CTMod> |c00FFFFFF/raidassist onyxia set [text]|r - Sets the onyxia AE warning message to '|c00FFFFFF[text]|r'", 1, 0.5, 0);
		--CT_RA_Print("<CTMod> |c00FFFFFF/raidassist geddon [self/nearby/all/off]|r - Sets the Living Bomb warning to show if the player/nearby players/everyone in raid (with CTRA) gets afflicted. Using |c00FFFFFFgeddon off|r will turn off the warning.", 1, 0.5, 0);
	elseif ( msg == "onyxia on" ) then
		CT_RA_Onyxia_Enable = 1;
		CT_RA_Print("<CTMod> Onyxia AE Warning is now turned |c0000FF00On|r.", 1, 0.5, 0);
	elseif ( msg == "onyxia off" ) then
		CT_RA_Print("<CTMod> Onyxia AE Warning is now turned |c00FF0000Off|r.", 1, 0.5, 0);
		CT_RA_Onyxia_Enable = nil;
	--[[
	elseif ( strsub(msg, 1, 6) == "geddon" ) then
		local types = {
			["geddon self"] = { 1, "showing for |c00FFFFFFself only|r." },
			["geddon nearby"] = { 2, "showing for |c00FFFFFFnearby players|r." },
			["geddon all"] = { 3, "showing for |c00FFFFFFeverybody in raid (with CTRA)|r." },
			["geddon off"] = { 4, "turned |c00FFFFFFoff|r." }
		};
		if ( types[msg] ) then
			CT_RA_Geddon_Status = types[msg][1];
			CT_RA_Print("<CTMod> Geddon Living Bomb Warning is now " .. types[msg][2], 1, 0.5, 0);
		else
			CT_RA_Print("<CTMod> Use /raidassist for help on different CT_RaidAssist commands.", 1, 0.5, 0);
		end
	]]
	elseif ( msg == "join" ) then
		CT_RA_ChangeChannel(CT_RA_Channel, 1);
	elseif ( msg == "update" and CT_RA_Level >= 1 ) then
		CT_RA_AddMessage("SR");
		CT_RA_Print("<CTMod> Stats have been updated for the raid group.", 1, 0.5, 0);
	elseif ( msg == "update" and CT_RA_Level < 1 ) then
		CT_RA_Print("<CTMod> You must be promoted or leader to do that!", 1, 0.5, 0);	
	elseif ( msg == "broadcast" ) then
		if ( CT_RA_Level >= 1 ) then
			SendChatMessage("<CTMod> This is an automatic message sent by CT_RaidAssist. Channel changed to: " .. CT_RA_Channel, "RAID");
		else
			CT_RA_Print("<CTMod> You must be promoted or leader to do that!", 1, 0.5, 0);
		end
	else
		local useless, useless, chan = string.find(msg, "^set (.+)$");
		if ( chan ) then
			CT_RA_ChangeChannel(chan);
			CT_RA_Print("<CTRaid> RaidAssist channel has been changed to '|c00FFFFFF" .. chan .. "|r'.", 1, 0.5, 0);
		else
			CT_RA_Print("<CTMod> Use /raidassist for help on different CT_RaidAssist commands.", 1, 0.5, 0);
		end
	end
end

CT_RA_Onyxia_Text = "ONYXIA FLAME AOE WILL BE INC, MOVE TO SIDES";

function CT_RA_Onyxia_OnEvent(event)
	if ( not CT_RA_Onyxia_Enable ) then return; end
	if ( event == "CHAT_MSG_MONSTER_EMOTE" and arg1 == "takes in a deep breath..." ) then
		if ( CT_RA_AddMessage and CT_RA_Level >= 1 ) then
			CT_RA_AddMessage("MS " .. CT_RA_Onyxia_Text);
		end
		SendChatMessage(text, "RAID");
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
		if ( CT_RA_MaintainTarget ) then
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
		if ( targetunit and CT_RA_MaintainTarget ) then
			if ( targetunit == "lastenemy" ) then
				TargetLastEnemy();
			elseif ( targetunit == "friend" ) then
				TargetByName(targetname);
			else
				TargetUnit(targetunit);
			end
		elseif ( CT_RA_MaintainTarget ) then
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
	local arr = {
		["Priest"] = { ["Magic"] = "Dispel Magic", ["Disease"] = { "Cure Disease", "Abolish Disease" } },
		["Shaman"] = { ["Disease"] = "Cure Disease", ["Poison"] = "Cure Poison" },
		["Druid"] = { ["Curse"] = "Remove Curse", ["Poison"] = { "Cure Poison", "Abolish Poison" } },
		["Mage"] = { ["Curse"] = "Remove Lesser Curse" },
		["Paladin"] = { ["Magic"] = { "Purify", "Cleanse" }, ["Poison"] = { "Purify", "Cleanse" }, ["Disease"] = { "Purify", "Cleanse" } }
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
			getglobal("CT_RAMTGroupMember" .. y):SetBackdropColor(CT_RA_DefaultColor.r, CT_RA_DefaultColor.g, CT_RA_DefaultColor.b, CT_RA_DefaultColor.a);
			getglobal("CT_RAMTGroupMember" .. y .. "Percent"):SetTextColor(CT_RA_PercentColor.r, CT_RA_PercentColor.g, CT_RA_PercentColor.b);
		end
		getglobal("CT_RAMember" .. y):SetBackdropColor(CT_RA_DefaultColor.r, CT_RA_DefaultColor.g, CT_RA_DefaultColor.b, CT_RA_DefaultColor.a);
		getglobal("CT_RAMember" .. y .. "Percent"):SetTextColor(CT_RA_PercentColor.r, CT_RA_PercentColor.g, CT_RA_PercentColor.b);
	end
end

function CT_RA_UpdateRaidMovability()
	for i = 1, 8, 1 do
		if ( CT_RA_LockGroups or not CT_RA_ShowGroups or not CT_RA_ShowGroups[i] ) then
			getglobal("CT_RAGroupDrag" .. i):Hide();
		else
			if ( getglobal("CT_RAGroup" .. i).next ) then
				getglobal("CT_RAGroupDrag" .. i):Show();
			end
		end
	end
	if ( CT_RA_LockGroups or not CT_RA_ShowMTs or not CT_RA_ShowMTs[i] ) then
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
			if ( CT_RA_MaintainTarget ) then
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
			elseif ( CT_RA_MaintainTarget ) then
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
	CT_RA_SORTTYPE = "class";
	CT_RA_ButtonIndexes = { };
	CT_RA_CurrPositions = { };
	local groupnum = 1;
	local membernum = 1;
	
	for k, v in CT_RA_ClassPositions do
		getglobal("CT_RAOptionsGroup" .. v .. "Label"):SetText(k);
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
			if ( ( not CT_RA_HideOffline or online ) and ( CT_RA_Stats[name] or not CT_RA_HideNA ) ) then
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
	CT_RA_SORTTYPE = "group";
	CT_RA_ButtonIndexes = { };
	CT_RA_CurrPositions = { };
	local groupnum = 1;
	local membernum = 1;
	for i = 1, 40, 1 do
		if ( i <= 8 ) then
			getglobal("CT_RAGroup" .. i).next = nil;
			getglobal("CT_RAGroup" .. i).num = 0;
			getglobal("CT_RAOptionsGroup" .. i .. "Label"):SetText("Group " .. i);
		end
		getglobal("CT_RAMember" .. i).next = nil;
	end
	for i = 1, GetNumRaidMembers(), 1 do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
		if ( ( not CT_RA_HideOffline or online ) and ( CT_RA_Stats[name] or not CT_RA_HideNA ) ) then
			CT_RA_CurrPositions[i] = subgroup;
			local group = getglobal("CT_RAGroup" .. subgroup);
			getglobal(group:GetName() .. "GroupName"):SetText("Group " .. subgroup);
			getglobal("CT_RAOptionsGroupButton" .. i .."Texture"):SetVertexColor(1.0, 1.0, 1.0);

			local button = getglobal("CT_RAMember" .. i);
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

function CT_RA_SortByCustom()
	CT_RA_SORTTYPE = "custom";
	local groupnum = 1;
	local membernum = 1;
	for i = 1, 40, 1 do
		if ( i <= 8 ) then
			getglobal("CT_RAGroup" .. i).next = nil;
			getglobal("CT_RAGroup" .. i).num = 0;
			getglobal("CT_RAOptionsGroup" .. i .. "Label"):SetText("Group " .. i);
		end
		getglobal("CT_RAMember" .. i).next = nil;
	end
	for i = 1, GetNumRaidMembers(), 1 do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
		getglobal("CT_RAOptionsGroupButton" .. i .."Texture"):SetVertexColor(1.0, 1.0, 1.0);
		if ( ( not CT_RA_HideOffline or online ) and ( CT_RA_Stats[name] or not CT_RA_HideNA ) ) then
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
			getglobal(group:GetName() .. "GroupName"):SetText("Group " .. subgroup);
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
	CT_RA_UpdateCustomSorting();
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
		local buffIndex, untilCancelled = GetPlayerDeuff(i, "HARMFUL");
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
			this.time = nil;
			CT_RA_AddMessage("SR");
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
				CT_RA_Print("<CTMod> Guild Members of level |c00FFFFFF" .. CT_RA_MinLevel .. "|r have been invited.", 1, 0.5, 0);
			else
				CT_RA_Print("<CTMod> Guild Members of levels |c00FFFFFF" .. CT_RA_MinLevel .. "|r to |c00FFFFFF" .. CT_RA_MaxLevel .. "|r have been invited.", 1, 0.5, 0);
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
			this.SS = nil;
			CT_RA_AddMessage("SR");
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
			this.updateDelay = nil;
		end
	end
	if ( this.initchannels ) then
		this.initchannels = this.initchannels - elapsed;
		if ( this.initchannels <= 0 ) then
			CT_RA_UpdateFrame.initchannels = 1;
			CT_RA_ChangeChannel();
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


SlashCmdList["RAINVITE"] = function(msg)
	if ( not GetGuildInfo("player") ) then
		CT_RA_Print("<CTMod> You need to be in a guild to mass invite.");
		return;
	end
	if ( ( not CT_RA_Level or CT_RA_Level == 0 ) and GetNumRaidMembers() > 0 ) then
		CT_RA_Print("<CTMod> You must be promoted or raid leader to mass invite.", 1, 1, 0);
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
			CT_RA_Print("<CTMod> Syntax Error. Usage: |c00FFFFFF/rainvite level|r or |c00FFFFFF/rainvite minlevel-maxlevel|r.", 1, 0.5, 0);
			CT_RA_Print("<CTMod> This command mass invites everybody in the guild within the selected level range (or only selected level if maxlevel is omitted).", 1, 0.5, 0);
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

SlashCmdList["RAKEYWORD"] = function(msg)
	if ( msg == "off" ) then
		CT_RA_KeyWord = nil;
		CT_RA_Print("<CTMod> Keyword Inviting has been turned off.", 1, 0.5, 0);
	else
		CT_RA_KeyWord = msg;
		CT_RA_Print("<CTMod> Invite Keyword has been set to '|c00FFFFFF" .. msg .. "|r'. Use |c00FFFFFF/rakeyword off|r to turn Keyword Inviting off.", 1, 0.5, 0);
	end
end

SlashCmdList["RADISBAND"] = function(msg)
	if ( CT_RA_Level and CT_RA_Level >= 1 ) then
		CT_RA_Print("<CTMod> Disbanding raid...", 1, 0.5, 0);
		SendChatMessage("<CTMod> Disbanding raid on request by " .. UnitName("player") .. ".", "RAID");
		for i = 1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( online and rank <= CT_RA_Level and name ~= UnitName("player") ) then
				UninviteByName(name);
			end
		end
		CT_RA_AddMessage("DB");
		LeaveParty();
	else
		CT_RA_Print("<CTMod> You need to be raid leader or promoted to do that!", 1, 0.5, 0);
	end
end

SlashCmdList["RASHOW"] = function(msg)
	if ( msg == "all" ) then
		CT_RA_ShowGroups = { 1, 1, 1, 1, 1, 1, 1, 1 };
		CT_RACheckAllGroups:SetChecked(1);
		for i = 1, 8, 1 do
			getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(1);
		end
	else
		if ( not CT_RA_HiddenGroups ) then return; end
		CT_RA_ShowGroups = CT_RA_HiddenGroups;
		CT_RA_HiddenGroups = nil;
		local num = 0;
		for k, v in CT_RA_ShowGroups do
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
	CT_RA_HiddenGroups = CT_RA_ShowGroups;
	CT_RA_ShowGroups = { };
		CT_RACheckAllGroups:SetChecked(nil);
		for i = 1, 8, 1 do
			getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(nil);
		end
	CT_RA_UpdateRaidGroup();
end

SlashCmdList["RAOPTIONS"] = function(msg)
	CT_RAMenuFrame:Show();
end

SLASH_RADISBAND1 = "/radisband";
SLASH_RAINVITE1 = "/rainvite";
SLASH_RAINVITE2 = "/rainv";
SLASH_RAKEYWORD1 = "/rakeyword";
SLASH_RAKEYWORD2 = "/rakw";
SLASH_RASHOW1 = "/rashow";
SLASH_RAHIDE1 = "/rahide";
SLASH_RAOPTIONS1 = "/raoptions";


-- Spam Control
CT_RA_Comm_HPChangeThreshold = 3;
CT_RA_Comm_MPChangeThreshold = 10;
CT_RA_Comm_MinMessageInterval = 0.1;
CT_RA_Comm_MTHPChangeTreshold = 3;
CT_RA_Comm_MTMPChangeTreshold = 10;
CT_RA_Comm_MessageQueue = { };

function CT_RA_ProcessMessages(elapsed)
	if ( this.elapsed > 0 ) then
		this.elapsed = this.elapsed - elapsed;
	end
	if ( this.elapsed <= 0 ) then
		if ( getn(CT_RA_Comm_MessageQueue) > 0 ) then
			CT_RA_SendMessageQueue();
			this.elapsed = CT_RA_Comm_MinMessageInterval;
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
	if ( CT_RA_Stats[UnitName(unit)] ) then
		oldBuffs = CT_RA_Stats[UnitName(unit)]["Buffs"];
	end
	local oldDebuffs = { };
	if ( CT_RA_Stats[UnitName(unit)] ) then
		oldDebuffs = CT_RA_Stats[UnitName(unit)]["Debuffs"];
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
		tinsert(returnstr, "BPA " .. UnitName(unit) .. " " .. val .. " " .. key);
	end
	for key, val in changed["newdebuffs"] do
		if ( not val["type"] ) then val["type"] = string.gsub(key, " ", "_"); end
		tinsert(returnstr, "DPA " .. UnitName(unit) .. " " .. val["texture"] .. " " .. val["type"] .. " " .. key);
	end
	for key, val in changed["expiredbuffs"] do
		tinsert(returnstr, "BEPA " .. UnitName(unit) .. " " .. key);
	end
	for key, val in changed["expireddebuffs"] do
		tinsert(returnstr, "DEPA " .. UnitName(unit) .. " " .. key);
	end
	if ( CT_RA_Stats[UnitName(unit)] ) then
		CT_RA_Stats[UnitName(unit)]["Buffs"] = currauras["buffs"];
		CT_RA_Stats[UnitName(unit)]["Debuffs"] = currauras["debuffs"];
	end
	return returnstr;
end

function CT_RA_ShowHideDebuffs()
	CT_RA_ShowDebuffs = not CT_RA_ShowDebuffs;
	CT_RAMenuFrameBuffsShowDebuffsCheckButton:SetChecked(CT_RA_ShowDebuffs);
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
		CT_RA_ResFrame_Options["Locked"] = not CT_RA_ResFrame_Options["Locked"];
	else
		CT_RA_ResFrame_Options["Shown"] = nil;
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