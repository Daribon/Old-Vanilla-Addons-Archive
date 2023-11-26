--[[
-- 
-- ChanComm - similar Sky/PartyComm but designed to be a simple channel communications object
--          - One day I'll release this on its own as a seperate library.
--          - In the mean time, feel free to use it..
--          - Credit would be nice.  :)  And if you improve it. Let me know!!
-- 
-- Note: This is just supposed to be something simple.
--       Sky is a bit too much.
--       PartyComm is party specific
--
--]]
ChanComm = {
    attached = false;
    hooked = false;
    chanID = 0;
    chanName = nil;
    chanAlias = nil;
    chanSlashCmd = nil;
    chanSlashCmdUpper = nil;
    cmdPrefix = nil;
    cmdParser = nil;

    ChatFrame_OnEvent_Original = nil;
	SendChatMessage_Original = nil;

	--[[
	--	hook()
    --      Hook into required functionality.
	--]]		
    hook = function()
        if ( ChanComm.hooked ) then
           return;
        end
        ChanComm.hooked = true;

   		ChatTypeInfo[ChanComm.chanSlashCmdUpper] = ChatTypeInfo["CHANNEL"..ChanComm.chanID];
		ChatTypeInfo[ChanComm.chanSlashCmdUpper].sticky = 1;

		setglobal("CHAT_MSG_"..ChanComm.chanSlashCmdUpper, ChanComm.chanAlias);
		setglobal("CHAT_"..ChanComm.chanSlashCmdUpper.."_GET", "["..ChanComm.chanAlias.."] %s:\32");
		setglobal("CHAT_"..ChanComm.chanSlashCmdUpper.."_SEND", ChanComm.chanAlias..":\32");

		-- Hook the chat frame events function
        ChanComm.ChatFrame_OnEvent_Original = ChatFrame_OnEvent;
        ChatFrame_OnEvent = ChanComm.ChatFrame_OnEvent_Override;

    	-- Hook the Parse Text function
		ChanComm.SendChatMessage_Original = SendChatMessage;
		SendChatMessage = ChanComm.SendChatMessage_Override;

        SlashCmdList[ChanComm.chanSlashCmdUpper] = ChanComm.sendChatMsg;
		setglobal("SLASH_"..ChanComm.chanSlashCmdUpper.."1", "/"..ChanComm.chanSlashCmd);
	end;


	--[[
	--	unhook()
    --      Unhook the functionality we hooked.
	--]]		
    unhook = function()
        if ( not ChanComm.hooked ) then
           return;
        end

        ChanComm.hooked = false;

        SlashCmdList[ChanComm.chanSlashCmdUpper] = nil;
		setglobal("SLASH_"..ChanComm.chanSlashCmdUpper.."1", nil);
		
		if ( DEFAULT_CHAT_FRAME.editBox.stickyType == string.upper(ChanComm.chanSlashCmd) ) then
		    DEFAULT_CHAT_FRAME.editBox.chatType = "SAY"
		    DEFAULT_CHAT_FRAME.editBox.stickyType = "SAY"
		end

    	-- Unhook the chat frame events function
        ChanComm.ChatFrame_OnEvent_Override = ChatFrame_OnEvent;
        ChatFrame_OnEvent = ChanComm.ChatFrame_OnEvent_Original;

    	-- Unhook the Parse Text function
        ChanComm.SendChatMessage_Override = SendChatMessage;
        SendChatMessage = ChanComm.SendChatMessage_Original;

   		ChatTypeInfo[ChanComm.chanSlashCmdUpper] = nil;
		setglobal("CHAT_MSG_"..ChanComm.chanSlashCmdUpper, nil);
		setglobal("CHAT_"..ChanComm.chanSlashCmdUpper.."_GET", nil);
		setglobal("CHAT_"..ChanComm.chanSlashCmdUpper.."_SEND", nil);

	end;


	--[[
	--	attach( channelSlashCmd, channelAlias, channelName, channelPassword, commandPrefix, commandParser )
    --      Attaches to the channel name using the given password.
	--		Stores the Command Prefix and Channel Filter function for command
	--		sending and receiving. 
	--
	--	Returns:
	--		id - the channels id or 0 if it failed to attach to the channel.
	--]]		
    attach = function( channelSlashCmd, channelAlias, channelName, channelPassword, commandPrefix, commandParser )
        local id = 0;
        local name = nil;

        -- Don't allow Invalid channel
		if ( ( not channelName )
		    or ( string.find(channelName, GUILDED_INVALID_CHAN_GENERAL) ~= nil )
			or ( string.find(channelName, GUILDED_INVALID_CHAN_TRADE) ~= nil )
			or ( string.find(channelName, GUILDED_INVALID_CHAN_LFG) ~= nil )
			or ( string.find(channelName, GUILDED_INVALID_CHAN_LOCALDEF) ~= nil )
			or ( string.find(channelName, GUILDED_INVALID_CHAN_WORLDDEF) ~= nil ) ) then
            return 0;
		end

        -- Detach from existing channel if new channelName is different.
        if ( ChanComm.chanName and (ChanComm.chanName ~= channelName) and GetChannelName( ChanComm.chanName ) > 0 ) then
			ChanComm.detach();
        end

        if ( ChanComm.chanSlashCmd and (ChanComm.chanSlashCmd ~= channelSlashCmd) ) then
			ChanComm.unhook();
        end

        -- Unhook existing slash commands and rehook.
		if ( channelSlashCmd and channelAlias and commandPrefix and commandParser ) then
            ChanComm.chanSlashCmd = channelSlashCmd;
            ChanComm.chanSlashCmdUpper = string.upper(channelSlashCmd);
            ChanComm.chanAlias = channelAlias;
            ChanComm.cmdPrefix = commandPrefix;
            ChanComm.cmdParser = commandParser;
		else
			return 0;
		end

        -- Check if already joined to channel by an external source.
        -- If so, just update state data.
        id = GetChannelName( channelName );
        if ( id > 0 ) then
            ChanComm.attached = true;
            ChanComm.chanID = id;
            ChanComm.chanName = channelName;
            ChanComm.hook();
            return id;
        end

        -- Finally, channelName is good, we are not already attached and we have detached
        -- from any previous attached channel. So now attach to new channel name.
        JoinChannelByName(channelName, channelPassword, DEFAULT_CHAT_FRAME:GetID());

        -- Confirm channel join was successful.
        id, name = GetChannelName( channelName );
        if ( ( id > 0 ) and ( name == channelName ) ) then
            ChanComm.attached = true;
            ChanComm.chanID = id;
            ChanComm.chanName = channelName;
            ChanComm.hook();
		else
--		    message("Guilded failed to attach to a channel, probably because it is the first time it's been created. Please try enabling Guilded again.");
			return 0;
        end

        return ChanComm.chanID;
    end;


	--[[
	--	detach()
    --      Call this function to detach from the current channel.
	--]]		
    detach = function()
        -- Check chanName is valid
        ChanComm.unhook();

        if ( ChanComm.chanName ) then
            LeaveChannelByName( ChanComm.chanName );
        end

        ChanComm.attached = false;
        ChanComm.chanID = 0;
        ChanComm.chanName = nil;
        ChanComm.chanSlashCmdUpper = nil;
        ChanComm.chanAlias = nil;
        ChanComm.cmdPrefix = nil;
        ChanComm.cmdParser = nil;
    end;


	--[[
	--	sendChatMsg( msg )
    --      Sends a chat message to the channel.
	--
	--	Returns:
	--		success - true for successful send, false if something goes wrong.
	--]]		
    sendChatMsg = function( msg )
        if ( ( ChanComm.attached ) and ( msg ) and ( ( type(msg) == "string" ) or ( type(msg) == "number" ) ) ) then
            SendChatMessage(msg, ChanComm.chanSlashCmdUpper, nil, ChanComm.chanName);
            return true;
        else
            return false;
        end
    end;


	--[[
	--	sendCmdMsg( cmd )
    --      Sends a command message to the channel.
	--
	--	Returns:
	--		success - true for successful send, false if something goes wrong.
	--]]		
    sendCmdMsg = function( cmd )
        if ( ( ChanComm.attached ) and ( cmd ) and ( ( type(cmd) == "string" ) or ( type(cmd) == "number" ) ) ) then
            SendChatMessage("<"..ChanComm.cmdPrefix..">"..cmd, ChanComm.chanSlashCmdUpper, nil, ChanComm.chanName);
            return true;
        else
            return false;
        end
    end;


    --[[
    -- ChatFrame_OnEvent_Override(event)
    --     Overloads ChatFrame_OnEvent.
    --     This function will replace the original chanel name in arg4 of the
    --     CHAT_MSG_CHANNEL event with the channel alias
    --]]
    ChatFrame_OnEvent_Override = function()
        -- Is it a channel chat message event, are we attached, and is it our channel.
        if ( ( event == "CHAT_MSG_CHANNEL" ) and ChanComm.attached and ( arg9 == ChanComm.chanName ) ) then
		    if (DEFAULT_CHAT_FRAME:GetID() ~= this:GetID()) then
			    -- Why the hell do we get 7 chat messages for every sent string?!?
				-- Surely there is a better way. Filtering all the ones we don't want.
			    return;
			end
			
   			arg1 = string.gsub(arg1, "<"..ChanComm.cmdPrefix.."I1>", "|c");
   			arg1 = string.gsub(arg1, "<"..ChanComm.cmdPrefix.."I2>", "|Hitem:");
   			arg1 = string.gsub(arg1, "<"..ChanComm.cmdPrefix.."I3>", "|h|r");
		    arg1 = string.gsub(arg1, "<"..ChanComm.cmdPrefix.."I4>", "|h");

				-- Is this message a command message
            if ( (string.sub(arg1, 1, string.len("<"..ChanComm.cmdPrefix..">")) ==  "<"..ChanComm.cmdPrefix..">" ) ) then
                -- Process message and return.
                ChanComm.cmdParser(string.sub(arg1, string.len("<"..ChanComm.cmdPrefix..">") + 1), arg2);
                return;
			else
        		event = "CHAT_MSG_"..ChanComm.chanSlashCmdUpper;
				arg4 = "";
            end
        end
        -- Process original Chat Frame Event handler.
        ChanComm.ChatFrame_OnEvent_Original(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
    end;

	
    --[[
    -- SendChatMessage_Override(event)
    --     Overloads SendChatMessage.
    --     This function will replace the internal Guilded channel system type of "GA" with CHANNEL.
    --]]
	SendChatMessage_Override = function(msg, sys, lang, name)
	    if (sys == ChanComm.chanSlashCmdUpper) then
			msg = string.gsub(msg, "|c", "<"..ChanComm.cmdPrefix.."I1>");
			msg = string.gsub(msg, "|Hitem:", "<"..ChanComm.cmdPrefix.."I2>");
			msg = string.gsub(msg, "|h|r", "<"..ChanComm.cmdPrefix.."I3>");
			msg = string.gsub(msg, "|h", "<"..ChanComm.cmdPrefix.."I4>");
	        return ChanComm.SendChatMessage_Original(msg, "CHANNEL", nil, ChanComm.chanID);
		else
	        return ChanComm.SendChatMessage_Original(msg, sys, lang, name);
		end
	end;
};
