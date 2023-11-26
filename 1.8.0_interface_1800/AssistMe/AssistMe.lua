--------------------------------------------------------------------------
-- AssistMe.lua 
--------------------------------------------------------------------------
--[[
Assist Me!

author: AnduinLothar    <Anduin@cosmosui.org>

Slash Commands:
	"/assistpartytrack" - Toggles '/assistlast' to assist the last party member that used the '/attacktarget' emote.
	"/assistparty" - Toggles automaticly assisting any party member that uses the '/attacktarget' emote.
	"/assistraidtrack" - Toggles '/assistlast' to assist the last raid member that used the '/attacktarget' emote.
	"/assistraid" - Toggles automaticly assisting any raid member that uses the '/attacktarget' emote.
	"/assistlast" - Assist the last _tracked_ user of the '/attacktarget' emote. (Bindable)
	"/assistmenotice" - Toggles visual cue on '/attacktarget' use.

Change Log:
	v1.0 (2/16/05)
		-Initial Release:
		-Assist Me! is a method for tracking the use of the vocal/text emote '/attacktarget' withing a party or
		raid group.  After the emote has been used if auto-assist is enabled your player will automaticly change
		targets to the target of the emote caller. If auto-assist is disabled but tracking is on then you can still
		use '/assistlast' by binding or macro to assume the last emoter's current target
		-Advanced options: /assistparty and /assistraid require their targeting counterpart and autoenable appropriately.
		Exclusive toggling (radio buttons) enabled if using cosmos config.
		-Recommended Macros: 
		'/attacktarget' - to get people to assist you.
		'/assistlast' - to assist the last person who requested assistance.
	v1.1 (2/19/05)
		-Added visual cue for when '/attacktarget' macro is used in a party/raid.
		-Added slash command: "/assistmenotice" 
	v1.2 (2/26/05)
		-Added German Localization and '/zielangreifen' emote support.
		-Added French Localization and '/attaquecible' emote support.
	v1.3 (6/29/05)
		-Added Khaos Configuration
		-Rewrote standard configuration to be mroe geralized
		-Fixed Slash commands to correctly update GUI configs
		-Fixed printout spam onload.

]]--


AssistMe_Current_Assist = nil;
AssistMe_Cosmos_IsLoaded = nil;

function AssistMe_Init()
	
	SlashCmdList["ASSISTMEPARTYTRACK"] = AssistMe_PartyTrackToggle;
    SLASH_ASSISTMEPARTYTRACK1 = "/assistpartytrack";
	
	SlashCmdList["ASSISTMEPARTY"] = AssistMe_PartyToggle;
    SLASH_ASSISTMEPARTY1 = "/assistparty";
	
	SlashCmdList["ASSISTMERAIDTRACK"] = AssistMe_RaidTrackToggle;
    SLASH_ASSISTMERAIDTRACK1 = "/assistraidtrack";
	
	SlashCmdList["ASSISTMERAID"] = AssistMe_RaidToggle;
    SLASH_ASSISTMERAID1 = "/assistraid";
	
	SlashCmdList["ASSISTMELAST"] = AssistMe_AssistLast;
    SLASH_ASSISTMELAST1 = "/assistlast";
	
	SlashCmdList["ASSISTMENOTICE"] = AssistMe_NoticeToggle;
    SLASH_ASSISTMENOTICE1 = "/assistmenotice";
	
	if (Khaos) then
		AssistMe_RegisterWithKhaos()
	elseif (Cosmos_RegisterConfiguration) then
		AssistMe_RegisterWithCosmos()
	else
		--Set Defaults
		if AssistMe_PartyTrack == nil then
			AssistMe_PartyTrack = true;
		end
		if AssistMe_Party == nil then
			AssistMe_Party = true;
		end
		if AssistMe_RaidTrack == nil then
			AssistMe_RaidTrack = true;
		end
		if AssistMe_Raid == nil then
			AssistMe_Raid = true;
		end
		if AssistMe_Notice == nil then
			AssistMe_Notice = true;
		end
		RegisterForSave("AssistMe_PartyTrack");
		RegisterForSave("AssistMe_Party");
		RegisterForSave("AssistMe_RaidTrack");
		RegisterForSave("AssistMe_Raid");
		RegisterForSave("AssistMe_Notice");
	end
	
	--Sea.IO.print("Assist Me! Loaded");
	--UIErrorsFrame:AddMessage("Assist Me! Loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function AssistMe_RegisterWithKhaos()
	local optionSet = {
		id="AssistMe";
		text=ASSIST_ME_HEADER;
		helptext=ASSIST_ME_HEADER_INFO;
		difficulty=1;
		options={
			{
				id="Header";
				text=ASSIST_ME_HEADER;
				helptext=ASSIST_ME_HEADER_INFO;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="EnablePartyTracking";
				type=K_TEXT;
				text=ASSIST_ME_ENABLE_PARTY_TRACK;
				helptext=ASSIST_ME_ENABLE_PARTY_TRACK_INFO;
				callback=AssistMe_PartyTrackToggle;
				feedback=function(state) return AssistMe_Feedback_Generater("ASSIST_ME_PARTY_TRACK", state.checked); end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableParty";
				type=K_TEXT;
				text=ASSIST_ME_ENABLE_PARTY;
				helptext=ASSIST_ME_ENABLE_PARTY_INFO;
				callback=AssistMe_PartyToggle;
				feedback=function(state) return AssistMe_Feedback_Generater("ASSIST_ME_PARTY", state.checked); end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={EnablePartyTracking={checked=true;match=true}};
			};
			{
				id="EnableRaidTracking";
				type=K_TEXT;
				text=ASSIST_ME_ENABLE_RAID_TRACK;
				helptext=ASSIST_ME_ENABLE_RAID_TRACK_INFO;
				callback=AssistMe_RaidTrackToggle;
				feedback=function(state) return AssistMe_Feedback_Generater("ASSIST_ME_RAID_TRACK", state.checked); end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableRaid";
				type=K_TEXT;
				text=ASSIST_ME_ENABLE_RAID;
				helptext=ASSIST_ME_ENABLE_RAID_INFO;
				callback=AssistMe_RaidToggle;
				feedback=function(state) return AssistMe_Feedback_Generater("ASSIST_ME_RAID", state.checked); end;
				check=true;
				default={checked=true};
				disabled={checked=false};
				dependencies={EnableRaidTracking={checked=true;match=true}};
			};
			{
				id="EnableNotices";
				type=K_TEXT;
				text=ASSIST_ME_ENABLE_NOTICE;
				helptext=ASSIST_ME_ENABLE_NOTICE_INFO;
				callback=AssistMe_NoticeToggle;
				feedback=function(state) return AssistMe_Feedback_Generater("ASSIST_ME_NOTICE", state.checked); end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
		};
	};
	Khaos.registerOptionSet(
		"combat",
		optionSet
	);
	AssistMe_Khaos_IsLoaded = true;
end

function AssistMe_RegisterWithCosmos()
	Cosmos_RegisterConfiguration("COS_ASSIST_ME_HEADER",
		"SECTION",
		ASSIST_ME_HEADER,
		ASSIST_ME_HEADER_INFO
		);
	Cosmos_RegisterConfiguration("COS_ASSIST_ME_HEADER_SECTION",
		"SEPARATOR",
		ASSIST_ME_HEADER,
		ASSIST_ME_HEADER_INFO
		);
	Cosmos_RegisterConfiguration("COS_ASSIST_ME_ENABLE_PARTY_TRACK",
		"CHECKBOX",
		ASSIST_ME_ENABLE_PARTY_TRACK,
		ASSIST_ME_ENABLE_PARTY_TRACK_INFO,
		AssistMe_PartyTrackToggle,
		AssistMe_PartyTrack
	);
	Cosmos_RegisterConfiguration("COS_ASSIST_ME_ENABLE_PARTY",
		"CHECKBOX",
		ASSIST_ME_ENABLE_PARTY,
		ASSIST_ME_ENABLE_PARTY_INFO,
		AssistMe_PartyToggle,
		AssistMe_Party
	);
	Cosmos_RegisterConfiguration("COS_ASSIST_ME_ENABLE_RAID_TRACK",
		"CHECKBOX",
		ASSIST_ME_ENABLE_RAID_TRACK,
		ASSIST_ME_ENABLE_RAID_TRACK_INFO,
		AssistMe_RaidTrackToggle,
		AssistMe_RaidTrack
	);
	Cosmos_RegisterConfiguration("COS_ASSIST_ME_ENABLE_RAID",
		"CHECKBOX",
		ASSIST_ME_ENABLE_RAID,
		ASSIST_ME_ENABLE_RAID_INFO,
		AssistMe_RaidToggle,
		AssistMe_Raid
	); 
	Cosmos_RegisterConfiguration("COS_ASSIST_ME_ENABLE_NOTICE",
		"CHECKBOX",
		ASSIST_ME_ENABLE_NOTICE,
		ASSIST_ME_ENABLE_NOTICE_INFO,
		AssistMe_NoticeToggle,
		AssistMe_Notice
	);
	AssistMe_Cosmos_IsLoaded = true;
end


function AssistMe_OnEvent(event)
	if ( event == "CHAT_MSG_TEXT_EMOTE" ) then
		local startpos, endpos, name = string.find(arg1, "(%w+) "..ASSIST_ME_EMOTE_PARTY_GET);
		if name and name ~= ASSIST_ME_EMOTE_YOU then
			local numPartyMembers = GetNumPartyMembers();
			local numRaidMembers = GetNumRaidMembers();
			if AssistMe_RaidTrack and numRaidMembers > 0 then
				for i=1, numRaidMembers do
					local currName, rank, subgroup, level, class, fileName, zone, online = GetRaidRosterInfo(i);
					if currName == name then
						AssistMe_SetCurrentAssist(name, (not AssistMe_Raid and AssistMe_Notice))
						if AssistMe_Raid then
							--UIErrorsFrame:AddMessage("Assisting "..name..".", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
							Sea.IO.print("Assisting "..name..".");
							AssistByName(name);
							--AssistUnit("party"..i);
						end
						--UIErrorsFrame:AddMessage(name.." wants assistance.", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
						break;
					end
				end
			elseif AssistMe_PartyTrack and numPartyMembers > 0 then
				for i=1, numPartyMembers do
					if UnitName("party"..i) == name then
						AssistMe_SetCurrentAssist(name, (not AssistMe_Party and AssistMe_Notice));
						if AssistMe_Party then
							--UIErrorsFrame:AddMessage("Assisting "..name..".", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
							Sea.IO.print("Assisting "..name..".");
							AssistByName(name);
							--AssistUnit("party"..i);
						end
						--UIErrorsFrame:AddMessage(name.." wants assistance.", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
						break;
					end
				end
			end
		end
	elseif event == "VARIABLES_LOADED" then
		AssistMe_Init();
	end
end

function AssistMe_SetCurrentAssist ( player, alert )
	if ( Sea and alert ) then 
		if ( not AssistMe_NewbieSent ) then 
			Sea.IO.banner( ASSIST_ME_BANNER_NEWBIE_STRING );
			AssistMe_NewbieSent = true;
		end
		Sea.IO.banner ( string.format(ASSIST_ME_BANNER_STRING , player) );
		
	end
	AssistMe_Current_Assist = player;
end

function AssistMe_AssistLast()
	if AssistMe_Current_Assist then
		AssistByName(AssistMe_Current_Assist);
	end
end

function AssistMe_Feedback_Generater(variableString, enabled)
	if (enabled) then
		return getglobal(variableString.."_ENABLED");
	else
		return getglobal(variableString.."_DISABLED");
	end
end

function AssistMe_BinaryConversion(boolean)
	if (boolean) then
		return 1;
	else
		return 0;
	end
end

function AssistMe_GeneralizedToggle(checked, currentSessionVariableString, feedbackPrefixString, khaosOptionID, cosmosOptionID, dependantAssertion, dependantVariableString, dependantFeedbackPrefixString, dependantKhaosOptionID, dependantCosmosOptionID)
	local redrawGUI = false;
	if (type(checked) == "table") then
		--Convert Khaos table to checked value
		checked = checked.checked;
	end
	
	if (type(checked) == "string") then
		--From slash command
		setglobal(currentSessionVariableString, not getglobal(currentSessionVariableString));
		
		if (Sea) then
			Sea.IO.print(AssistMe_Feedback_Generater(feedbackPrefixString, getglobal(currentSessionVariableString)));
		end
		
		if (AssistMe_Khaos_IsLoaded) then
			Khaos.setSetKeyParameter("AssistMe", khaosOptionID, "checked", getglobal(currentSessionVariableString));
			redrawGUI = true;
		elseif (AssistMe_Cosmos_IsLoaded) then
			Cosmos_UpdateValue(cosmosOptionID, CSM_CHECKONOFF, AssistMe_BinaryConversion(getglobal(currentSessionVariableString)))
			redrawGUI = true;
		end
	else
		--From GUI
		if (AssistMe_Khaos_IsLoaded) then
			setglobal(currentSessionVariableString, (checked));
		elseif (AssistMe_Cosmos_IsLoaded) then
			setglobal(currentSessionVariableString, (checked == 1));
		end
	end
	
	if (dependantVariableString) and (dependantFeedbackPrefixString) and (dependantCosmosOptionID) then
		if (dependantAssertion) then
			if (getglobal(currentSessionVariableString)) and (not getglobal(dependantVariableString)) then
				setglobal(dependantVariableString, true)
				if (AssistMe_Khaos_IsLoaded) then
					Khaos.setSetKeyParameter("AssistMe", dependantKhaosOptionID, "checked", true);
					redrawGUI = true;
				elseif (AssistMe_Cosmos_IsLoaded) then
					Cosmos_UpdateValue(dependantCosmosOptionID, CSM_CHECKONOFF, 1);
					redrawGUI = true;
				end
				if (Sea) and (type(checked) == "string") then
					Sea.IO.print(AssistMe_Feedback_Generater(dependantFeedbackPrefixString, true));
				end
			end
		else	
			if (not getglobal(currentSessionVariableString)) and (getglobal(dependantVariableString)) then
				setglobal(dependantVariableString, false)
				if (AssistMe_Cosmos_IsLoaded) then
					Cosmos_UpdateValue(dependantCosmosOptionID, CSM_CHECKONOFF, 0);
					redrawGUI = true;
				end
				if (Sea) and (type(checked) == "string") then
					Sea.IO.print(AssistMe_Feedback_Generater(dependantFeedbackPrefixString, false));
				end
			end 
		end
	end
	
	if redrawGUI then
		if (AssistMe_Khaos_IsLoaded) then
			if (KhaosFrame:IsVisible()) then
				Khaos.refresh(false, false, true);
			end
		elseif (AssistMe_Cosmos_IsLoaded) then
			if (CosmosMasterFrame:IsVisible()) and (not CosmosMasterFrame_IsLoading) then
				CosmosMaster_DrawData();
			end
		end
	end
end

function AssistMe_PartyTrackToggle(checked)
	AssistMe_GeneralizedToggle(checked, "AssistMe_PartyTrack", "ASSIST_ME_PARTY_TRACK", "EnablePartyTracking", "COS_ASSIST_ME_ENABLE_PARTY_TRACK", false, "AssistMe_Party", "ASSIST_ME_PARTY", "EnableParty", "COS_ASSIST_ME_ENABLE_PARTY");
end

function AssistMe_PartyToggle(checked)
	AssistMe_GeneralizedToggle(checked, "AssistMe_Party", "ASSIST_ME_PARTY", "EnableParty", "COS_ASSIST_ME_ENABLE_PARTY", true, "AssistMe_PartyTrack", "ASSIST_ME_PARTY_TRACK", "EnablePartyTracking", "COS_ASSIST_ME_ENABLE_PARTY_TRACK");
end

function AssistMe_RaidTrackToggle(checked)
	AssistMe_GeneralizedToggle(checked, "AssistMe_RaidTrack", "ASSIST_ME_RAID_TRACK", "EnableRaidTracking", "COS_ASSIST_ME_ENABLE_RAID_TRACK", false, "AssistMe_Raid", "ASSIST_ME_RAID", "EnableRaid", "COS_ASSIST_ME_ENABLE_RAID");
end

function AssistMe_RaidToggle(checked)
	AssistMe_GeneralizedToggle(checked, "AssistMe_Raid", "ASSIST_ME_RAID", "EnableRaid", "COS_ASSIST_ME_ENABLE_RAID", true, "AssistMe_RaidTrack", "ASSIST_ME_RAID_TRACK", "EnableRaidTracking", "COS_ASSIST_ME_ENABLE_RAID_TRACK");
end

function AssistMe_NoticeToggle(checked)
	AssistMe_GeneralizedToggle(checked, "AssistMe_Notice", "ASSIST_ME_NOTICE", "EnableNotices", "COS_ASSIST_ME_ENABLE_NOTICE");
end


