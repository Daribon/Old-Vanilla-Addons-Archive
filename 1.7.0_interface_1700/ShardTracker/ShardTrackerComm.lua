--[[

    ShardTracker -- Client / Server Code

  ]]--

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              CLIENT / SERVER MESSAGING FUNCTIONS                           --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- Re-ping any non-responsive party members
-- We have to do this because sometimes scheduled events don't
-- fire correctly, so we need to make sure the message gets to the party member
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdatePartyMemberPingStatus()

    ShardTrackerTron("UpdatePartyMemberPingStatus");

    local foundUnansweredPing = false;

    ShardTrackerDebug("ShardTracker_UpdatePartyMemberPingStatus: Updating the ping status for the party.");
    ShardTrackerDebug("  Number of party members in PartyMemberList = "..table.getn(ShardTracker_PartyMemberList));
    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        ShardTrackerDebug("   For PartyMember "..i.." ("..ShardTracker_PartyMemberList[i].name..") answeredPing = "..tostring(ShardTracker_PartyMemberList[i].answeredPing),0,1,0);
        if (not ShardTracker_PartyMemberList[i].answeredPing) then

            -- if this char is a warlock, we don't want to be pinging them
            if (UnitClass("party"..ShardTracker_GetPartyMemberNumber(ShardTracker_PartyMemberList[i].name)) == SHARDTRACKER_WARLOCK) then
                ShardTrackerDebug("   "..ShardTracker_PartyMemberList[i].name.." is a Warlock, ignoring.");
                ShardTracker_PartyMemberList[i].answeredPing = true;
            else
                foundUnansweredPing = true;
                ShardTrackerDebug("   Ping from ("..ShardTracker_PartyMemberList[i].name..") was unanswered! Scheduling another!",0,1,0);
                ShardTracker_StartPingQuery(10, ShardTracker_PartyMemberList[i].name, "WHISPER");

                -- stop pinging after 10 tries
                -- or if we're pinging over normal chat, only allow 1 try
                ShardTracker_PartyMemberList[i].pingCount = ShardTracker_PartyMemberList[i].pingCount + 1;
                if (not Sky or not ShardTracker_CheckForSky(ShardTracker_PartyMemberList[i].name)) then
                    ShardTracker_PartyMemberList[i].answeredPing = true;
                elseif (ShardTracker_PartyMemberList[i].pingCount > 10) then
                    ShardTracker_PartyMemberList[i].answeredPing = true;
                end
            end
        end
    end

    if (not foundUnansweredPing) then
        ShardTrackerDebug("   Found no unanswered pings.  Turning off pinging.",0,1,0);
        ShardTracker_StopPinging = true;
    end
end


-----------------------------------------------------------------------------------
--
-- Schedule a query that will repeat over and over until answered or timed out
--
-----------------------------------------------------------------------------------
function ShardTracker_StartPingQuery(theSecs, memberName, msgType)

    ShardTrackerTron("StartPingQuery");

    ShardTrackerDebug("ShardTracker_StartPingQuery: Scheduling a ping to ["..memberName.."]",0,1,0);

    ShardTracker_StopPinging = false;
    if (Chronos) then
        Chronos.schedule(theSecs, ShardTracker_SendHealthStoneQuery, msgType, memberName);
    else
        ShardTrackerPrint("Error in ShardTracker_StartPingQuery: Attempting to call Chronos.schedule when Chronos isn't installed.  Please lock your doors and hide under the bed.");
    end
end



-----------------------------------------------------------------------------------
--
-- Set the language to send our messages in
--
-----------------------------------------------------------------------------------
function ShardTracker_SetMessageLanguage()

    --ShardTrackerTron("SetMessageLanguage");

    local ourRace = UnitRace("player");

    -- if we're alliance
    if (ourRace == SHARDTRACKER_HUMAN or ourRace == SHARDTRACKER_DWARF or ourRace == SHARDTRACKER_GNOME or ourRace == SHARDTRACKER_NIGHTELF) then
        ShardTracker_MessageLanguage = SHARDTRACKER_COMMON;
    -- else we're horde
    else
        ShardTracker_MessageLanguage = SHARDTRACKER_ORCISH;
    end

    -- This is supposed to work ???
    --ShardTracker_MessageLanguage = GetLanguageByIndex(0);
end


-----------------------------------------------------------------------------------
--
-- Send a chat message to party members who don't have Sky installed
--
-----------------------------------------------------------------------------------
function ShardTracker_SendChatMessageToNonSkyUsers(msg, who, theType)

    ShardTrackerTron("SendChatMessageToNonSkyUsers");

    local memberHasSky;

    ShardTrackerDebug("Ready to send "..theType.." msg to ["..who.."], msg = "..msg);
    ShardTrackerDebug("    Found "..table.getn(ShardTracker_PartyMemberList).." party members in ShardTracker_PartyMemberList.");

    -- if it's a message for just one party member
    if (theType == "WHISPER") then
        memberHasSky = ShardTracker_CheckForSky(who);
        if (memberHasSky and not ShardTracker_ForceNonCosmosChat) then
            ShardTrackerDebug("    Party member \""..who.."\" has sky, not sending a whisper");
        else
            ShardTrackerDebug("    Party member \""..who.."\ doesn't have sky, sending WHISPER msg NOW = "..SHARDTRACKER_CHAT_PREFIX..msg);
            ShardTracker_SendMessageNormally(SHARDTRACKER_CHAT_PREFIX..msg, "WHISPER", ShardTracker_MessageLanguage, who);
        end

    -- else it's a message for the whole party
    else
        -- check for party members not using sky
        for i = 1, table.getn(ShardTracker_PartyMemberList) do
            memberHasSky = ShardTracker_CheckForSky(ShardTracker_PartyMemberList[i].name);
            if (memberHasSky and not ShardTracker_ForceNonCosmosChat) then
                ShardTrackerDebug("    Party member "..i.." has sky, not sending a whisper");
            else
                ShardTrackerDebug("    Party member "..i.." doesn't have sky, sending WHISPER, msg  NOW= "..SHARDTRACKER_CHAT_PREFIX..msg.." who = "..who);
                who = ShardTracker_PartyMemberList[i].name;
                ShardTracker_SendMessageNormally(SHARDTRACKER_CHAT_PREFIX..msg, "WHISPER", ShardTracker_MessageLanguage, who);
            end
        end
    end
end



-----------------------------------------------------------------------------------
--
-- Send a normal chat message
--
-----------------------------------------------------------------------------------
function ShardTracker_SendMessageNormally(msg, theType, lang, who)
    local inList = false;

    -- check to see if we're in the OK-to-send list
    if (SHARDTRACKER_CONFIG.LIST_RESTRICT and SHARDTRACKER_CONFIG.LIST_RESTRICT ~= 0) then
        for i = 1, table.getn(SHARDTRACKER_CONFIG.COMM_LIST) do
            if (string.lower(who) == string.lower(SHARDTRACKER_CONFIG.COMM_LIST[i])) then
                inList = true;
                break;
            end
        end
    end

    if (inList or not SHARDTRACKER_CONFIG.LIST_RESTRICT or SHARDTRACKER_CONFIG.LIST_RESTRICT == 0) then
        SendChatMessage(msg, theType, lang, who);
    end
end


-----------------------------------------------------------------------------------
--
-- Send a sky chat message
--
-----------------------------------------------------------------------------------
function ShardTracker_Sky_SendChatMessage(msg, who, theType, directToPlayer)

    ShardTrackerTron("Sky_SendChatMessage");

    -- Outgoing sky messages contain header tags that take the form of:
    --
    -- Partywide messages:  "<ST>>P" and the message
    -- Whisper messages:    "<ST>>W(charactername)" and the message

    ShardTrackerDebug("ShardTracker_Sky_SendChatMessage: Entering with msg = "..msg.." who = "..who.." theType = "..theType);

    local skyMsg = "";
    if (theType == "PARTY") then
        skyMsg = ">P"..msg;
    elseif (theType == "WHISPER") then
        skyMsg = ">W("..who..")"..msg;
    end

    ShardTrackerDebug("ShardTracker_Sky_SendChatMessage: Sending msg via sky NOW, msg = "..SHARDTRACKER_CHAT_PREFIX..skyMsg);

    if (directToPlayer) then
        ShardTracker_Sky_SendDirectMessage(SHARDTRACKER_CHAT_PREFIX..skyMsg, who);
    else
        ShardTracker_Sky_SendPartyMessage(SHARDTRACKER_CHAT_PREFIX..skyMsg);
    end
end


-----------------------------------------------------------------------------------
--
-- Main routine to send a chat message
--
-----------------------------------------------------------------------------------
function ShardTracker_SendChatMessage(msg, who, theType)

    ShardTrackerTron("SendChatMessage");

    if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1) then

        -- if we haven't figured out our language, look it up
        if (ShardTracker_MessageLanguage == "") then
            ShardTracker_SetMessageLanguage();
        end

        ShardTrackerDebug("ShardTracker_SendChatMessage: Entering with msg = "..SHARDTRACKER_CHAT_PREFIX..msg.." to = "..who.." theType = "..theType);

        -- for messages sent to the party or directly to players
        if (theType == "PARTY" or theType == "WHISPER") then

            -- if we have sky enabled
            if (Sky and not ShardTracker_ForceNonCosmosChat) then

                ShardTrackerDebug("    We have sky installed!");

                -- handling messages to the non-sky folk
                ShardTracker_SendChatMessageToNonSkyUsers(msg, who, theType);
                ShardTrackerTron("Back to SendChatMessage");

                -- regardless of party members running sky, we'll go ahead and
                -- send the message via the sky party channel
                ShardTracker_Sky_SendChatMessage(msg, who, theType);

            -- we don't have sky, so send the message as a simple "/party" or "/whisper" message
            else
                ShardTrackerDebug("    We don't have sky. Sending normal msg NOW. msg = "..SHARDTRACKER_CHAT_PREFIX..msg.." to = "..who.." theType = "..theType);
                ShardTracker_SendMessageNormally(SHARDTRACKER_CHAT_PREFIX..msg, theType, ShardTracker_MessageLanguage, who);
            end
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Break up an incoming message into its parts, if needed (break up headers, etc)
--
-----------------------------------------------------------------------------------
function ShardTracker_PreProcessIncomingMessage(msg, whoFrom, theType)

    ShardTrackerTron("Pre-ProcessIncomingMessage");

    ShardTrackerDebug("Received ["..tostring(theType).."] msg from ["..tostring(whoFrom).."] msg = "..tostring(msg));

    local whoTo = "";

    -- ignore all system messages
    if (theType ~= "SYSTEM" and theType ~= "CHAT_MSG_SYSTEM" and (msg ~= nil)) then

        -- check to see if this message has a header tag
        local headerChar = string.sub(msg, 5, 5);
        if (headerChar == ">") then

            ShardTrackerDebug("    Saw sky Message");

            -- strip off the "<ST>" header
            msg = string.sub(msg, 5);

            -- get the msgType char
            msgTypeChar = string.sub(msg, 2, 2);

            ShardTrackerDebug("    msgTypeChar = "..msgTypeChar);

            -- if this is a partywide message
            if (msgTypeChar == "P") then
                msg = string.sub(msg, 3);
                theType = "PARTY";
                ShardTrackerDebug("      Message was for the Party, msg = "..tostring(msg));

            -- if this message is just intended for one character in the party
            elseif (msgTypeChar == "W") then

                -- grab the sender name
                local sender = nil;
                for w in string.gfind(msg, "%b()") do
                    sender = w;
                    break;
                end
                if (not sender) then
                    ShardTrackerPrint("ShardTracker: Error!  Malformed Whisper Message for sky!");
                    return;
                else
                    whoTo = string.sub(sender, 2, string.len(sender) - 1);
                end
                theType = "WHISPER";
                msg = string.sub(msg, string.len(whoTo) + 5);

                ShardTrackerDebug("      Message was ["..tostring(theType).."] from ["..tostring(whoFrom).." to ["..whoTo.."], msg = "..tostring(msg));

            end

        -- else it's not a sky message
        else
            -- strip off the "<ST>" header
            msg = string.sub(msg, 5);

            -- if it's a whisper message, it's to us
            if (theType == "WHISPER") then
                whoTo = UnitName("player");
            end

            ShardTrackerDebug("      Not a sky msg, msg after stripping <ST> = "..msg);
        end

    end

    ShardTrackerDebug("      Returning ["..tostring(theType).."] from ["..tostring(whoFrom).."] to ["..whoTo.."], msg = "..tostring(msg));
    return msg, whoFrom, theType, whoTo;
end


-----------------------------------------------------------------------------------
--
-- Main routine to process any incoming messages
--
-----------------------------------------------------------------------------------
function ShardTracker_ProcessMessage(msg, whoFrom, theType)

    ShardTrackerTron("ProcessMessage");

    ShardTrackerDebug("Entering with msg = "..tostring(msg));

    if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1) then

        -- rename for clarity
        if (theType == "CHAT_MSG_WHISPER" or theType == "CHAT_MSG_WHISPER_INFORM" or theType == SKY_PLAYER) then
            theType = "WHISPER";
        end
        if (theType == "CHAT_MSG_SYSTEM") then
            theType = "SYSTEM";
        end
        if (theType == "CHAT_MSG_PARTY" or theType == SKY_PARTY) then
            theType = "PARTY";
        end

        ShardTrackerDebug("Received ["..tostring(theType).."] msg from ["..tostring(whoFrom).."] msg = "..tostring(msg));

        -- process out any header strings
        msg, whoFrom, theType, whoTo = ShardTracker_PreProcessIncomingMessage(msg, whoFrom, theType);

        ShardTrackerTron("Back to ProcessMessage");

        ShardTrackerDebug("After Preprocess we have: ["..tostring(theType).."] msg from ["..tostring(whoFrom).."] to ["..tostring(whoTo).."] msg = "..tostring(msg));

        -- ignore messages from ourself or that aren't for us
        if ((whoFrom ~= UnitName("player")) or (theType == "WHISPER" and (whoTo == "" or whoTo == UnitName("player")))) then

            -- only Warlocks need to worry about these incoming messages
            if (UnitClass("player") == SHARDTRACKER_WARLOCK) then

                -- if it's a system msg about the party: party forming, players joining/leaving, etc
                if (theType == "SYSTEM") then

                    -- if it's a player joining party message
                    if (string.find(msg, SHARDTRACKER_JOINSTHEPARTY,1,true)) then
                        ShardTrackerDebug("Saw joined notification!");
                        for memberName in string.gfind(msg, "%a+") do
                            ShardTracker_UpdatePartyHealthstoneIcons(true, memberName);
                            ShardTrackerTron("Back to ProcessMessage");

                            -- if using sky, schedule sending out a message
                            if (Sky and not ShardTracker_ForceNonCosmosChat) then

                                -- if we both have sky, schedule the query
                                if (ShardTracker_CheckForSky(memberName)) then
                                    ShardTrackerDebug("ProcessMessage: Both "..tostring(memberName).." and we have sky, so start pinging");
                                    ShardTracker_StartPingQuery(10, memberName, "WHISPER");

                                -- if the party member doesn't have sky, send as normal msg
                                else
                                    ShardTrackerDebug("ProcessMessage: "..memberName.." doesn't have sky, so sending normal msg");
                                    ShardTracker_SendHealthStoneQuery("WHISPER", memberName);
                                end

                            -- otherwise we just send it right out
                            else
                                ShardTrackerDebug("We don't have sky, so sending normal msg to "..tostring(memberName));
                                ShardTracker_SendHealthStoneQuery("WHISPER", memberName);
                            end
                            break;
                        end

                    -- else if it's a player leaving party message
                    elseif (string.find(msg, SHARDTRACKER_LEAVESTHEPARTY,1,true)) then
                        ShardTrackerDebug("Saw player left party notification!");
                        for memberName in string.gfind(msg, "%a+") do
                            ShardTracker_UpdatePartyHealthstoneIcons(false, memberName);
                            break;
                        end

                    -- else if the group was disbanded, clear the list and all the healthstone icons
                    elseif (string.find(msg, SHARDTRACKER_GROUPDISBANDED,1,true) or string.find(msg, SHARDTRACKER_YOULEAVEGROUP,1,true)) then
                        ShardTrackerDebug("Saw disbanded notification!");
                        ShardTracker_ResetPartyList();
                    end

                -- else if it's a msg from a player regarding his/her healthstone status
                elseif (theType == "WHISPER" or theType == "PARTY") then


                    -- determine which party member number sent the message
                    senderNumber = ShardTracker_GetPartyMemberNumber(whoFrom);

                    -- if the sender is in the party, handle the message
                    if (senderNumber ~= 0) then

                        -- if it's a "got a healthstone" message from a player
                        if (string.find(msg, SHARDTRACKER_GOT_HEALTHSTONE_MSG, 1, true) or string.find(msg, SHARDTRACKER_SYNC_HEALTHSTONE_YES_MSG, 1, true)) then
                            ShardTrackerDebug("Msg was GOT HEALTHSTONE. Updating partylist.");
                            ShardTracker_SignalHealthstoneStatus(whoFrom, true);
                            ShardTracker_UpdatePartyHealthstoneList(whoFrom, true, false);

                        -- if it's a "need a healthstone" message from a player
                        elseif (string.find(msg, SHARDTRACKER_NEED_HEALTHSTONE_MSG, 1, true) or string.find(msg, SHARDTRACKER_SYNC_HEALTHSTONE_NO_MSG, 1, true)) then
                            ShardTrackerDebug("Msg was NEED HEALTHSTONE. Updating partylist.");
                            ShardTracker_SignalHealthstoneStatus(whoFrom, false);
                            ShardTracker_UpdatePartyHealthstoneList(whoFrom, false, true);
                        end
                    end
                end

            -- else we're not a warlock, so handle the non-warlock messages
            else

                ShardTrackerDebug("We're not a Warlock, so ignoring Warlock msgs.");

                -- if it's a partywide message
                if (theType == "PARTY" or theType == "WHISPER") then

                    if (whoTo == "") then
                        ShardTrackerDebug("Msg was a PARTY-WIDE msg.");
                    else
                        ShardTrackerDebug("Msg was a WHISPER msg.");
                    end

                    -- if it's a message requesting we sync our healthstone status with a warlock
                    if (string.find(msg, SHARDTRACKER_REQUEST_HEALTHSTONE_STATUS_MSG, 1, true)) then
                        ShardTrackerDebug("Msg was a REQUEST STATUS msg.  Replying to Warlocks.");
                        ShardTracker_SyncHealthstoneStatusWithWarlock(whoFrom);
                    end
                end
            end

            -- look for version ping related message
            if (theType == "WHISPER") then

                -- look for a version ping message
                if (string.find(msg, SHARDTRACKER_VERSIONPINGSTRING, 1, true)) then
                    ShardTracker_ReplyToVersionPing(whoFrom);

                -- look for a reply to a version ping message
                elseif (string.find(msg, SHARDTRACKER_VERSIONPINGREPLYSTRING, 1, true)) then
                    ShardTracker_HandleVersionPingReply(whoFrom, msg);
                end
            end

        else
            ShardTrackerDebug("**Ignoring msg from ourself!**");
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Signal our healthstone status (play a sound and/or print a message)
--
-----------------------------------------------------------------------------------
function ShardTracker_SignalHealthstoneStatus(whoFrom, hasHealthStone)

   ShardTrackerTron("SignalHealthstoneStatus");
   ShardTrackerDebug("Entering with whoFrom = "..whoFrom.." hasHealthStone = "..tostring(hasHealthStone));

   local theNum = theNum or 1

   if (hasHealthStone) then
       for n = 1, table.getn(ShardTracker_PartyMemberList) do
           if (ShardTracker_PartyMemberList[n].name == whoFrom) then
               theNum = n;
               break;
           end
       end
       theNum = theNum or 1
       if theNum > 0 and (ShardTracker_PartyMemberList[theNum].hasHealthstone ~= true) then
           ShardTrackerPrint(whoFrom.." received a healthstone!",1,1,0.5);
           ShardTracker_PlaySound("TellMessage");
       end
   else
       for n = 1, table.getn(ShardTracker_PartyMemberList) do
           if (ShardTracker_PartyMemberList[n].name == whoFrom) then
               theNum = n;
               break;
           end
       end
       theNum = theNum or 1
       if theNum > 0 and (ShardTracker_PartyMemberList[theNum].hasHealthstone ~= false) then
           ShardTracker_StartNotificationSound(SHARDTRACKER_HEALTHSTONE, theNum);
           ShardTrackerPrint(whoFrom.." needs a new healthstone!",1,0,0);
       end
   end
end



-----------------------------------------------------------------------------------
--
-- Send a msg to any Warlocks in the party to let them know we need another Healthstone
--
-----------------------------------------------------------------------------------
function ShardTracker_NotifyHealthstoneStatus(theMessage)

    ShardTrackerTron("NotifyHealthstoneStatus");

    if (SHARDTRACKER_CONFIG.ENABLED == 1) then

        ShardTrackerDebug("In ShardTracker_NotifyHealthstoneStatus");
        if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1) then

            -- don't ask for a healthstone if we're a warlock
            if (UnitClass("player") ~= SHARDTRACKER_WARLOCK) then

                -- if we haven't already sent out a notification
                if (ShardTracker_SentHealthstoneNotification ~= 1) then
                    local unitList = {"party1", "party2", "party3", "party4"};

                    for k, v in unitList do
                        partyMember = v;

                        -- if this party member exists
                        if (UnitName(partyMember)) then

                            -- if he/she is a warlock
                            if (UnitClass(partyMember) == SHARDTRACKER_WARLOCK) then
                                myName      = UnitName("player");
                                warlockName = UnitName(partyMember);
                                if (not UnitIsUnit("player",partyMember)) then
                                    ShardTracker_SendChatMessage(myName.." "..theMessage, warlockName, "WHISPER");
                                end
                            end
                        end
                    end
                    ShardTracker_SentHealthstoneNotification = 1;
                end
            end
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Send a message to a warlock with the status of our healthstone
--
-----------------------------------------------------------------------------------
function ShardTracker_SyncHealthstoneStatusWithWarlock(warlockName)

    ShardTrackerTron("SyncHealthstoneStatusWithWarlock");

    if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1) then
        ShardTrackerDebug("  Sending query, warlockName = "..tostring(warlockName));

        local theMsg = "";

        -- if we have a healthstone, tell the warlock
        if (ShardTracker_HaveHealthStone == 1) then
            theMsg = SHARDTRACKER_SYNC_HEALTHSTONE_YES_MSG;
        else
            theMsg = SHARDTRACKER_SYNC_HEALTHSTONE_NO_MSG;
        end

        ShardTracker_SendChatMessage(UnitName("player").." "..theMsg, warlockName, "WHISPER");
    end
end


-----------------------------------------------------------------------------------
--
-- Send a query to all party members about their healthstone status
--
-----------------------------------------------------------------------------------
function ShardTracker_SendHealthStoneQuery(theChannel, thePlayer)

    local targetIsWarlock;

    ShardTrackerTron("SendHealthStoneQuery");

    if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1) then
        ShardTrackerDebug("ShardTracker_SendHealthStoneQuery: Sending query, theChannel = "..tostring(theChannel).." thePlayer = "..tostring(thePlayer),0,1,0);

        -- only do this if we're a warlock and
        if (UnitClass("player") == SHARDTRACKER_WARLOCK) then

            -- find out if our target is a warlock
            targetIsWarlock = true;

            -- a nil thePlayer indicated this query is to the whole party
            if (thePlayer == nil) then
                targetIsWarlock = false;
            elseif (UnitClass("party"..ShardTracker_GetPartyMemberNumber(thePlayer)) ~= SHARDTRACKER_WARLOCK) then
                targetIsWarlock = false;
            end

            -- only send a query if our target isn't a warlock (don't want to ask warlocks if they need a healthstone)
            if (not targetIsWarlock) then

                -- only send a query if we're in a party or have a specific player to send to
                 if (table.getn(ShardTracker_PartyMemberList) > 0 or thePlayer) then
                    if (thePlayer == nil) then thePlayer = "" end;
                    ShardTracker_SendChatMessage(SHARDTRACKER_REQUEST_HEALTHSTONE_STATUS_MSG, thePlayer, theChannel);
                end
            end
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Hide all the healthstone icons for party members
--
-----------------------------------------------------------------------------------
function ShardTracker_ClearPartyHealthstoneIcons()

    for i = 1, 4 do
        local healthStoneIcon = getglobal("PartyMemberFrame"..i.."ShardTrackerIcon");
        if (healthStoneIcon) then
            healthStoneIcon:Hide();
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Checks to see if the specified membername is new to our list of party members
-- we do this to ignore any duplicate "joined party" messages
--
-----------------------------------------------------------------------------------
function ShardTracker_IsNewPartyMember(memberName)

    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        if (ShardTracker_PartyMemberList.name == memberName) then
            return false;
        end
    end
    return true;
end

-----------------------------------------------------------------------------------
--
-- Keep the list of which party members have healthstones current
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdatePartyHealthstoneIcons(memberJoined, memberName)

    ShardTrackerTron("UpdatePartyHealthstoneIcons");

    -- clear all the healthstone icons
    ShardTracker_ClearPartyHealthstoneIcons();

    ShardTrackerDebug("UpdatePartyHealthstoneIcons for memberName = "..memberName);

    -- if a party member joined us
    if (memberJoined and ShardTracker_IsNewPartyMember(memberName)) then

        ShardTrackerDebug("     "..memberName.." just joined the party");
        tempTable = { };
        tempTable.name = memberName;
        tempTable.hasHealthstone = false;

        -- we don't ever want to be pinging warlocks asking if they need a healthstone...
        if (UnitClass("party"..ShardTracker_GetPartyMemberNumber(memberName)) == SHARDTRACKER_WARLOCK) then
            tempTable.answeredPing = true;
        else
            tempTable.answeredPing = false;
        end
        tempTable.pingCount = 0;
        tempTable.flashing = false;
        table.insert(ShardTracker_PartyMemberList, tempTable);

        ShardTrackerDebug("     PartyMemberList has "..table.getn(ShardTracker_PartyMemberList).." members:");
        for i = 1, table.getn(ShardTracker_PartyMemberList) do
            ShardTrackerDebug("     "..i.." = "..ShardTracker_PartyMemberList[i].name);
        end

    -- remove a member
    elseif (not memberJoined) then
        ShardTrackerDebug("     memberName = "..memberName..": left the party");
        for i = 1, table.getn(ShardTracker_PartyMemberList) do
            if (ShardTracker_PartyMemberList[i].name == memberName) then
                table.remove(ShardTracker_PartyMemberList, i);
                break;
            end
        end
    else
        ShardTrackerDebug("     memberName = "..memberName..": got joined msg, but was already in the party");
    end

end


-----------------------------------------------------------------------------------
--
-- Initialize the list of people in our party, mostly for when we crash and reload
-- directly back into our already existing party
--
-----------------------------------------------------------------------------------
function ShardTracker_InitializePartyHealthstoneIcons()

    ShardTrackerTron("InitializePartyHealthstoneIcons");

    -- clear all the healthstone icons
    ShardTracker_ClearPartyHealthstoneIcons();

    -- for each party member, put them into the table
    ShardTracker_PartyMemberList = { };
    local numberOfPartyMembers = GetNumPartyMembers();
    ShardTrackerDebug("Saw "..numberOfPartyMembers.." members in the party");
    for i = 1, numberOfPartyMembers do
        tempTable = { };
        tempTable.name = UnitName("party"..i);
        tempTable.hasHealthstone = false;

        -- we don't ever want to be pinging warlocks asking if they need a healthstone...
        if (UnitClass("party"..i) == SHARDTRACKER_WARLOCK) then
            tempTable.answeredPing = true;
        else
            tempTable.answeredPing = false;
        end
        tempTable.pingCount = 0;
        tempTable.flashing = false;
        table.insert(ShardTracker_PartyMemberList, tempTable);
    end

end


-----------------------------------------------------------------------------------
--
-- Reset the party list
--
-----------------------------------------------------------------------------------
function ShardTracker_ResetPartyList()

    ShardTrackerTron("ResetPartyList");

    -- clear all the healthstone icons
    ShardTracker_ClearPartyHealthstoneIcons();

    -- clear the party list
    ShardTracker_PartyMemberList = { };

    ShardTrackerDebug("After reset, have "..table.getn(ShardTracker_PartyMemberList).." members in the partylist.");
end


-----------------------------------------------------------------------------------
--
-- Update a party member's healthstone list entry (name of player, if they have a healthstone,
-- if they need a new one (is flashing))
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdatePartyHealthstoneList(charName, hasHealthStone, isFlashing)

    ShardTrackerTron("UpdatePartyHealthstoneList");

    ShardTrackerDebug("Entering with charname = "..charName.." hasHealthStone = "..tostring(hasHealthStone).." isFlashing = "..tostring(isFlashing).."...");
    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        ShardTrackerDebug("    Looking at member "..i.." name = "..ShardTracker_PartyMemberList[i].name.."...");
        if (ShardTracker_PartyMemberList[i].name == charName) then
            ShardTracker_PartyMemberList[i].hasHealthstone = hasHealthStone;
            ShardTracker_PartyMemberList[i].flashing = isFlashing;
            if (ShardTracker_PartyMemberList[i].answeredPing == false) then
                ShardTracker_PlaySound("TellMessage");
            end
            ShardTracker_PartyMemberList[i].answeredPing = true;
        end
    end
end


---------------------------------------------------------------------------------
--
-- Send out Healthstone queries to all party members again
--
---------------------------------------------------------------------------------
function ShardTracker_ReQueryAllPartyMembers()
    if (Sky and Chronos) then
        for i = 1, GetNumPartyMembers() do
            Chronos.schedule(5+i,ShardTracker_SendHealthStoneQuery, "WHISPER", UnitName("party"..i));
        end
    else
        for i = 1, GetNumPartyMembers() do
            ShardTracker_SendHealthStoneQuery("WHISPER", UnitName("party"..i));
        end
    end
end



---------------------------------------------------------------------------------
--
-- Our own version of the ChatFrame_OnEvent
--
---------------------------------------------------------------------------------
function ShardTracker_ChatFrame_OnEvent(event)

    --local message, sender, language, channel, arg5, arg6, arg7, channelNumber, channelName, loops, frame = arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, loops, frame;
    ShardTracker_Orig_ChatFrame_OnEvent(event);

    if (event and arg1) then
        if (strsub(event, 1, 16) == "CHAT_MSG_WHISPER" or strsub(event, 1, 14) == "CHAT_MSG_PARTY" or
            (strsub(event, 1, 15) == "CHAT_MSG_SYSTEM" and
            (string.find(arg1, SHARDTRACKER_JOINSTHEPARTY,1,true) or
            string.find(arg1, SHARDTRACKER_LEAVESTHEPARTY,1,true) or
            string.find(arg1, SHARDTRACKER_GROUPDISBANDED,1,true) or
            string.find(arg1, SHARDTRACKER_YOULEAVEGROUP,1,true)))) then
            ShardTracker_ProcessMessage(arg1,arg2,event);
        end
    end
end


---------------------------------------------------------------------------------
--
-- Add a player to our OK to communicate with list
--
---------------------------------------------------------------------------------
function ShardTracker_AddToCommList(playerName)

    -- make sure we were passed a player to add
    if (playerName == "" or playerName == nil) then
        ShardTrackerPrint("Usage: /shardtracker add <playername>");
    else

        -- make sure this player isn't already on the list
        local foundInList;
        foundInList = false;
        for i = 1, table.getn(SHARDTRACKER_CONFIG.COMM_LIST) do
            if (string.lower(SHARDTRACKER_CONFIG.COMM_LIST[i]) == string.lower(playerName)) then
                foundInList = true;
                break;
            end
        end

        if (foundInList) then
            ShardTrackerPrint("Player "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..playerName..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.." is already in your \"OK to communicate\" list.");
        else
            table.insert(SHARDTRACKER_CONFIG.COMM_LIST, playerName);
            ShardTrackerPrint("Player "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..playerName..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.." added to your \"OK to communicate\" list.");
            ShardTracker_ListCommList();
            ShardTracker_ReQueryAllPartyMembers();
        end
    end
end

---------------------------------------------------------------------------------
--
-- Remove a player from our OK to communicate with list
--
---------------------------------------------------------------------------------
function ShardTracker_RemoveFromCommList(playerName)

    -- make sure we were passed a player to add
    if (playerName == "" or playerName == nil) then
        ShardTrackerPrint("Usage: /shardtracker remove <playername>");
    else

        -- make sure this player is on the list
        local foundInList;
        local foundIndex;
        foundInList = false;
        for i = 1, table.getn(SHARDTRACKER_CONFIG.COMM_LIST) do
            if (string.lower(SHARDTRACKER_CONFIG.COMM_LIST[i]) == string.lower(playerName)) then
                foundInList = true;
                foundIndex = i;
                break;
            end
        end

        if (foundInList) then
            table.remove(SHARDTRACKER_CONFIG.COMM_LIST, foundIndex);
            ShardTrackerPrint("Player "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..playerName..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.." removed from your \"OK to communicate\" list.");
            ShardTracker_ListCommList();
            ShardTracker_ReQueryAllPartyMembers();
        else
            ShardTrackerPrint("Player "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..playerName..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.." isn't on your \"OK to communicate\" list.");
        end
    end
end


---------------------------------------------------------------------------------
--
-- Show our OK to communicate list
--
---------------------------------------------------------------------------------
function ShardTracker_ListCommList()
    ShardTrackerPrint("Your \"OK to communicate\" list contains the following players:");
    if (table.getn(SHARDTRACKER_CONFIG.COMM_LIST) == 0) then
        ShardTrackerPrint("   o none");
    else
        for i = 1, table.getn(SHARDTRACKER_CONFIG.COMM_LIST) do
            ShardTrackerPrint("   o "..SHARDTRACKER_CONFIG.COMM_LIST[i]);
        end
    end

    if (SHARDTRACKER_CONFIG.LIST_RESTRICT == 1 or SHARDTRACKER_CONFIG.LIST_RESTRICT == true) then
        ShardTrackerPrint("ShardTracker will only monitor the Healthstones of these party members.");
        ShardTrackerPrint("No other players will be contacted by ShardTracker.  To allow");
        ShardTrackerPrint("ShardTracker to monitor any party member's Healthstones, use the");
        ShardTrackerPrint("\"/shardtracker restrict off\" command.");
    else
        ShardTrackerPrint("Turn on communication restriction with the \"/shardtracker restrict on\"");
        ShardTrackerPrint("command for ShardTracker to only monitor the Healthstones of these");
        ShardTrackerPrint("party members.");
    end
end



---------------------------------------------------------------------------------
--
-- Register a mailbox with sky
--
---------------------------------------------------------------------------------
function ShardTracker_RegisterSky()
    if (Sky) then
        Sky.registerMailbox(
            {
                id = "ShardTracker";
                events = { SKY_PARTY, SKY_PLAYER };
                acceptTest = ShardTracker_SkyMessageAcceptTest;
            }
        );
        ShardTracker_RegisterAlert();
    end

end
function ShardTracker_RegisterAlert()
    if (Sky) then
        Sky.registerAlert(
            {
                id = "SH";
                func = ShardTracker_ProcessSkyAlert;
                description = "ShardTracker Alerts";
            }
        );
    end
end

---------------------------------------------------------------------------------
--
-- Test to see if this is a message for Shardtracker
--
---------------------------------------------------------------------------------
function ShardTracker_SkyMessageAcceptTest(envelope)

    -- only accept messages that begin with the SHARDTRACKER_CHAT_PREFIX ---> <ST>
    if (type(envelope.msg) == "string") then
        local header = string.sub(envelope.msg, 1, string.len(SHARDTRACKER_CHAT_PREFIX));
        if (header == SHARDTRACKER_CHAT_PREFIX) then
            return true;
        else
            return false;
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Check for an incoming SKY message
--
-----------------------------------------------------------------------------------
function ShardTracker_CheckForIncomingSkyMessage()
    local envelope = Sky.getNextMessage("ShardTracker");

    -- if there was a message
    if (envelope) then
        ShardTrackerDebug("Got SKY envelope.  Processing...");
        ShardTracker_ProcessMessage(envelope.msg, envelope.sender, envelope.type)
    end

    -- if we have chronos, schedule the next check
    if (Chronos) then
        Chronos.schedule(SKY_MESSAGE_CHECK_FREQ, ShardTracker_CheckForIncomingSkyMessage);
    end
end




-----------------------------------------------------------------------------------
--
-- Stub for checking sky use
--
-----------------------------------------------------------------------------------
function ShardTracker_CheckForSky(who)
    if (who and Sky) then
        return(Sky.isSkyUser(who));
    else
        return false;
    end
end



-----------------------------------------------------------------------------------
--
-- Stub for sending sky party message
--
-----------------------------------------------------------------------------------
function ShardTracker_Sky_SendPartyMessage(theMessage)
    if (Sky) then
        ShardTrackerTron("ShardTracker_Sky_SendPartyMessage");
        ShardTrackerDebug("Sending SKY party message");
        Sky.sendMessage(theMessage, SKY_PARTY);
    end
end

-----------------------------------------------------------------------------------
--
-- Stub for sending sky party message
--
-----------------------------------------------------------------------------------
function ShardTracker_Sky_SendDirectMessage(theMessage, thePlayer)
    if (Sky) then
        ShardTrackerTron("ShardTracker_Sky_SendDirectMessage");
        ShardTrackerDebug("Sending SKY message direct to player: msg = ["..theMessage.."]  dest = ["..thePlayer.."]");
        Sky.sendMessage(theMessage, SKY_PLAYER, nil, thePlayer);
    end
end


function ShardTracker_ProcessSkyAlert(msg, sender, system, timeReceived)
    local msgParts, numParts;
    ShardTracker_SubVersion = 0;
    msgParts, numParts = ShardTracker_BreakupParentheticalString(msg);

    if (numParts >= 2) then
        if (msgParts[2] == UnitName("player")) then
            if (msgParts[1] == SHARDTRACKER_VERSIONPINGSTRING) then
                ShardTracker_ReplyToVersionPing(sender);
            elseif (msgParts[1] == SHARDTRACKER_VERSIONPINGREPLYSTRING) then
                ShardTracker_HandleVersionPingReply(sender, msgParts[3], msgParts[4]);
            end
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Breakup a parenthetical-based message into its parts
--
-----------------------------------------------------------------------------------
function ShardTracker_BreakupParentheticalString(message)
    local msgParts = {};
    local numParts = 0;
    for w in string.gfind(message, "%b()") do
        w = string.sub(w, 2, string.len(w)-1);
        table.insert(msgParts, w);
        numParts = numParts + 1;
    end

    return msgParts, numParts;
end


-----------------------------------------------------------------------------------
--
-- Send a ping message using sky to see if someone is using ShardTracker
--
-----------------------------------------------------------------------------------
function ShardTracker_SendVersionPing(who)
    if (Sky and who) then
        ShardTrackerPrint("Sending ping to "..who.."...");
        Sky.sendAlert("("..SHARDTRACKER_VERSIONPINGSTRING..")("..who..")", SKY_CHANNEL, "SH");
    end
end


-----------------------------------------------------------------------------------
--
-- Reply to a version ping message using sky
--
-----------------------------------------------------------------------------------
function ShardTracker_ReplyToVersionPing(who)
    --ShardTrackerDebug("Received version ping from "..who.."...");
    if (Sky) then

        local w, z;
        w = ShardTracker_SubVersion;
        z = floor(w / 10000);
        Sky.sendAlert("("..SHARDTRACKER_VERSIONPINGREPLYSTRING..")("..who..")("..SHARDTRACKER_VERSION..")("..z..")", SKY_CHANNEL, "SH");
    end
end


-----------------------------------------------------------------------------------
--
-- Reply to a version ping message using sky
--
-----------------------------------------------------------------------------------
function ShardTracker_HandleVersionPingReply(who, versionString, z)
    ShardTrackerPrint(who.." is running ShardTracker Version "..versionString..". ("..tostring(z)..")");
end

