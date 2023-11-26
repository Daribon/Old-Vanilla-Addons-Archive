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

]]--


AssistMe_Current_Assist = nil;


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
	
	if (Cosmos_RegisterConfiguration) then
		if COS_ASSIST_ME_ENABLE_PARTY_TRACK_X == 0 then
			AssistMe_PartyTrack = false;
		else
			AssistMe_PartyTrack = true;
		end
		if COS_ASSIST_ME_ENABLE_PARTY_X == 0 then
			AssistMe_Party = false;
		else
			AssistMe_Party = true;
		end
		if COS_ASSIST_ME_ENABLE_RAID_TRACK_X == 0 then
			AssistMe_RaidTrack = false;
		else
			AssistMe_RaidTrack = true;
		end
		if COS_ASSIST_ME_ENABLE_RAID_X == 0 then
			AssistMe_Raid = false;
		else
			AssistMe_Raid = true;
		end
		if COS_ASSIST_ME_ENABLE_NOTICE_X == 0 then
			AssistMe_Notice = false;
		else
			AssistMe_Notice = true;
		end
		AssistMe_RegisterWithCosmos()
	else
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
	if ( Sea ) then 
		Cosmos_RegisterConfiguration("COS_ASSIST_ME_ENABLE_NOTICE",
			"CHECKBOX",
			ASSIST_ME_ENABLE_NOTICE,
			ASSIST_ME_ENABLE_NOTICE_INFO,
			AssistMe_NoticeToggle,
			AssistMe_Notice
		);
	end
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


function AssistMe_PartyTrackToggle(checked)
	local redrawCosmos = false;
	if arg1 == nil then
		AssistMe_PartyTrack = not AssistMe_PartyTrack;
		
		if (Cosmos_RegisterConfiguration) then
			if AssistMe_PartyTrack then
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_PARTY_TRACK", CSM_CHECKONOFF, 1)
			else
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_PARTY_TRACK", CSM_CHECKONOFF, 0)
			end
		end
		
		if Sea then
			if AssistMe_PartyTrack then
				Sea.IO.print(ASSIST_ME_PARTY_TRACK_ENABLED);
			else
				Sea.IO.print(ASSIST_ME_PARTY_TRACK_DISABLED);
				if AssistMe_Party then
					Sea.IO.print(ASSIST_ME_PARTY_DISABLED);
				end
			end
		end
		
		if (Cosmos_RegisterConfiguration) then
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	else
		AssistMe_PartyTrack = (checked == 1);
	end
	
	if (AssistMe_Party) and (not AssistMe_PartyTrack) then
		AssistMe_Party = false;
		if (Cosmos_RegisterConfiguration) then
			Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_PARTY", CSM_CHECKONOFF, 0)
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	end
	
	if redrawCosmos then
		CosmosMaster_DrawData();
	end
end


function AssistMe_PartyToggle(checked)
	local redrawCosmos = false;
	if arg1 == nil then
		AssistMe_Party = not AssistMe_Party;
		
		if (Cosmos_RegisterConfiguration) then
			if AssistMe_Party then
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_PARTY", CSM_CHECKONOFF, 1)
			else
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_PARTY", CSM_CHECKONOFF, 0)
			end
		end
		
		if Sea then
			if AssistMe_Party then
				Sea.IO.print(ASSIST_ME_PARTY_ENABLED);
				if not AssistMe_PartyTrack then
					Sea.IO.print(ASSIST_ME_PARTY_TRACK_ENABLED);
				end
			else
				Sea.IO.print(ASSIST_ME_PARTY_DISABLED);
			end
		end
		
		if (Cosmos_RegisterConfiguration) then
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	else
		AssistMe_Party = (checked == 1);
	end
	
	if (AssistMe_Party) and (not AssistMe_PartyTrack) then
		AssistMe_PartyTrack = true;
		if (Cosmos_RegisterConfiguration) then
			Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_PARTY_TRACK", CSM_CHECKONOFF, 1)
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	end
	
	if redrawCosmos then
		CosmosMaster_DrawData();
	end
end


function AssistMe_RaidTrackToggle(checked)
	local redrawCosmos = false;
	if arg1 == nil then
		AssistMe_RaidTrack = not AssistMe_RaidTrack;
		
		if (Cosmos_RegisterConfiguration) then
			if AssistMe_PartyTrack then
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_RAID_TRACK", CSM_CHECKONOFF, 1)
			else
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_RAID_TRACK", CSM_CHECKONOFF, 0)
			end
		end
		
		if Sea then
			if AssistMe_RaidTrack then
				Sea.IO.print(ASSIST_ME_RAID_TRACK_ENABLED);
			else
				Sea.IO.print(ASSIST_ME_RAID_TRACK_DISABLED);
				if AssistMe_Raid then
					Sea.IO.print(ASSIST_ME_RAID_DISABLED);
				end
			end
		end
		
		if (Cosmos_RegisterConfiguration) then
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	else
		AssistMe_RaidTrack = (checked == 1);
	end
	
	if (AssistMe_Raid) and (not AssistMe_RaidTrack) then
		AssistMe_Raid = false;
		if (Cosmos_RegisterConfiguration) then
			Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_RAID", CSM_CHECKONOFF, 0)
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	end
	
	if redrawCosmos then
		CosmosMaster_DrawData();
	end
end

-- Turns banner notices on/off
function AssistMe_NoticeToggle(checked)
	local redrawCosmos = false;
	if ( arg1 == nil ) then
		AssistMe_Notice = not AssistMe_Notice;
		
		if (Cosmos_RegisterConfiguration) then
			if AssistMe_Notice then
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_NOTICE", CSM_CHECKONOFF, 1)
			else
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_NOTICE", CSM_CHECKONOFF, 0)
			end
		end
		
		if Sea then
			if AssistMe_Notice then
				Sea.IO.print(ASSIST_ME_NOTICE_ENABLED);
			else
				Sea.IO.print(ASSIST_ME_NOTICE_DISABLED);
			end
		end
		
		if (Cosmos_RegisterConfiguration) then
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	else
		AssistMe_Notice = (checked == 1);
	end
	
	if redrawCosmos then
		CosmosMaster_DrawData();
	end			
end

function AssistMe_RaidToggle(checked)
	local redrawCosmos = false;
	if arg1 == nil then
		AssistMe_Raid = not AssistMe_Raid;
		
		if (Cosmos_RegisterConfiguration) then
			if AssistMe_Party then
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_RAID", CSM_CHECKONOFF, 1)
			else
				Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_RAID", CSM_CHECKONOFF, 0)
			end
		end
		
		if Sea then
			if AssistMe_Raid then
				Sea.IO.print(ASSIST_ME_RAID_ENABLED);
				if not AssistMe_RaidTrack then
					Sea.IO.print(ASSIST_ME_RAID_TRACK_ENABLED);
				end
			else
				Sea.IO.print(ASSIST_ME_RAID_DISABLED);
			end
		end
		
		if (Cosmos_RegisterConfiguration) then
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	else
		AssistMe_Raid = (checked == 1);
	end
	
	if (AssistMe_Raid) and (not AssistMe_RaidTrack) then
		AssistMe_RaidTrack = true;
		if (Cosmos_RegisterConfiguration) then
			Cosmos_UpdateValue("COS_ASSIST_ME_ENABLE_RAID_TRACK", CSM_CHECKONOFF, 1)
			if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
				redrawCosmos = true;
			end
		end
	end
	
	if redrawCosmos then
		CosmosMaster_DrawData();
	end
end

