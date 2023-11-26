--[[
-- 
-- Guilded is an AddOn designed to facilitate multi-guild alliances
--
-- Features: Guilded
--     Multi Guild/Player chat channel
--     Guilded channel member listing
--     Guilded channel configuration
--     Crafting skill notification + level (automatic and configurable)
--     TBD - Item Request + notification (WTS/WTB user setup)
--     TBD - Multi Guild Raid Channel
--     TBD - Raid / Instance Organisation (user setup)
-- 
--]]
GUILDED_VERSION = "v0.9";

-- Global configuration data structure stored by SavedVariables in toc file.
GuildedConfigAll = {};

-- Realm_PlayerName unique identifier for indexing global config data
GuildedPlayerIndex = nil;

-- Config data for this realm/player combination. Loaded at run time.
GuildedConfig = {
    valid = false;
    slashChatCmd = GUILDED_DEFAULT_CHAT_SLASHCMD;
    chanAlias = GUILDED_DEFAULT_CHAT_ALIAS;
    chanName = nil;
    chanPwd = nil;
	advertProf = false;
	
	numStock = 0;
	stock = {};
	
	
    --[[
    -- resetItems()
    --     Reset the stock data
    --]]
	resetItems = function()
   	    GuildedConfig.numStock = 0;
    	GuildedConfig.stock = {};
    end;


    --[[
    -- findItem( link )
    --     Find the stock index for the given item link
    --]]
	findItem = function( link )
	    if ( link ) then
			for i, stockData in GuildedConfig.stock do
			    if (stockData.link == link) then
				    return i;
				end
			end
		end
		return -1;
    end;

    --[[
    -- addItem( link, texture, itemCount, locked, quality, price )
    --     Add the item to the guilded config stock data structure
    --]]
	addItem = function( link, texture, itemCount, locked, quality, price )
		if ( link and texture ) then
    	    local newItem = {};
    	    newItem.link = link;
	        newItem.texture = texture;
    	    newItem.itemCount = itemCount;
	        newItem.locked = locked;
    	    newItem.quality = quality;
    	    newItem.price = price;
    	    newItem.wts = false;
    	    newItem.wtb = false;

		    local idx = GuildedConfig.findItem(link);
		    if (idx > 0) then
			    GuildedConfig.stock[idx] = newItem;
			else
       	    	GuildedConfig.numStock = GuildedConfig.numStock + 1;
           	    table.insert(GuildedConfig.stock, newItem);
			end
		end
	end;
	

    --[[
    -- delItem( link )
    --     Delete the item from the guilded config stock data structure
    --]]
	delItem = function( link )
	    if ( link ) then
			local idx = GuildedConfig.findItem(link);
			if ( idx > 0 ) then
                table.remove(GuildedConfig.stock, idx);
   	    		if ( GuildedConfig.numStock > 0 ) then
       	    	    GuildedConfig.numStock = GuildedConfig.numStock - 1;
   		    	end
   	    	end
		end
	end;
	

    --[[
    -- flagItem( link, flag, val )
    --     Flag the item as WTS or WTB
    --]]
	flagItem = function( link, flag, val )
	    if ( link and flag and (val ~= nil) ) then
			local idx = GuildedConfig.findItem(link);
			if ( idx > 0 ) then
			    if (flag == "WTS") then
					GuildedConfig.stock[idx].wts = val;
				elseif (flag == "WTB") then
					GuildedConfig.stock[idx].wtb = val;
				end
   	    	end
		end
	end;
	

    --[[
    -- loadData()
    --     Safely load data or keep default values.
    --]]
	loadData = function( data )
	    if (data) then
		    if (data.valid ~= nil) then
			    GuildedConfig.valid = data.valid;
			end

		    if (data.slashChatCmd ~= nil) then
			    GuildedConfig.slashChatCmd = data.slashChatCmd;
			end

		    if (data.chanAlias ~= nil) then
			    GuildedConfig.chanAlias = data.chanAlias;
			end

		    if (data.chanName ~= nil) then
			    GuildedConfig.chanName = data.chanName;
			end

		    if (data.chanPwd ~= nil) then
			    GuildedConfig.chanPwd = data.chanPwd;
			end

		    if (data.advertProf ~= nil) then
			    GuildedConfig.advertProf = data.advertProf;
			end

		    GuildedConfig.numStock = 0;
		    if (data.stock ~= nil) then
			    for i, v in data.stock do
				    GuildedConfig.stock[i] = v;
					GuildedConfig.numStock = GuildedConfig.numStock + 1;
				end
			end
		end
	end;

	
    --[[
    -- getSaveData()
    --     Return data structure ready for saving to global local variables data structure.
    --]]
	getSaveData = function()
	    local saveData = {};
        saveData.valid = GuildedConfig.valid;
        saveData.slashChatCmd = GuildedConfig.slashChatCmd;
        saveData.chanAlias = GuildedConfig.chanAlias;
        saveData.chanName = GuildedConfig.chanName;
        saveData.chanPwd = GuildedConfig.chanPwd;
    	saveData.advertProf = GuildedConfig.advertProf;
	    saveData.stock = GuildedConfig.stock;
		
		return saveData;
	end;
};


--[[
-- Guilded
--     The main Guilded object
--]]
Guilded = {
    GUILDED_CMD_PREFIX = "G";
    GUILDED_CMD_VERSION = "0";
    GUILDED_CMD_JOIN = "1";
    GUILDED_CMD_LEAVE = "2";
    GUILDED_CMD_UPDATE = "3";
	
	flagUpdate = true;
	
    cmdHandlers = {};
	logoutOriginal = nil;
	quitOriginal = nil;

    --[[
    -- onLoad()
    --     OnLoad setup function
    --]]
    onLoad = function()
        -- Setup Slash Commands
        SlashCmdList["GUILDED"] = Guilded.onSlashCmd;
        SLASH_GUILDED1 = "/guilded";
		
        StaticPopupDialogs["GUILDED_WARNING"] = {
	        text = TEXT(GUILDED_UPDATE_WARNING),
	        button1 = TEXT(CLOSE),
	        timeout = 0,
        };

		Guilded.logoutOriginal = Logout;
		Logout = Guilded.logout;
		
		Guilded.quitOriginal = Quit;
		Quit = Guilded.quit;
		
		Guilded.cmdRegisterHandler(Guilded.GUILDED_CMD_VERSION, Guilded.cmdHandler);
		Guilded.cmdRegisterHandler(Guilded.GUILDED_CMD_JOIN, Guilded.cmdHandler);
		Guilded.cmdRegisterHandler(Guilded.GUILDED_CMD_UPDATE, Guilded.cmdHandler);
		Guilded.cmdRegisterHandler(Guilded.GUILDED_CMD_LEAVE, Guilded.cmdHandler);
		
    	-- Load Inform
        if (DEFAULT_CHAT_FRAME) then 
            local info = ChatTypeInfo["SYSTEM"];
            DEFAULT_CHAT_FRAME:AddMessage(GUILDED_LOADED..GUILDED_VERSION, info.r, info.g, info.b, info.id);
        end
    end;


    --[[
    -- onUnload()
    --     Called to copy current config data into global data structure
    --     and leave the current guilded channel
    --]]
    onUnload = function( event )
	    if (GuildedPlayerIndex ~= nil) then
		    GuildedConfigAll[GuildedPlayerIndex] = GuildedConfig.getSaveData();
		end
		Guilded.leaveGuilded();
    end;


    --[[
    -- logout()
    --     logout Hook, so we can store data before login off
    --]]
    logout = function()
	    Guilded.onUnload();
		Guilded.logoutOriginal();
    end;


    --[[
    -- quit()
    --     quit Hook, so we can store data before quiting
    --]]
    quit = function()
	    Guilded.onUnload();
		Guilded.quitOriginal();
    end;


    --[[
    -- onSlashCmd( msg )
    --     Slash Command Handler
    --]]
    onSlashCmd = function( msg )
        local info = ChatTypeInfo["SYSTEM"];
	    if (not msg) then
            DEFAULT_CHAT_FRAME:AddMessage(GUILDED_HELP, info.r, info.g, info.b, info.id);
	        return;
        end

        local command = string.lower(msg);

        -- list / toggle
        if ( command == GUILDED_SLASHCMD_LIST ) then
		    for key, member in GuildedData.members do
                DEFAULT_CHAT_FRAME:AddMessage(member.name.." level "..member.level.." "..member.class.." and guild member of "..member.guild, info.r, info.g, info.b, info.id);
			end
        elseif ( command == GUILDED_SLASHCMD_TOGGLE ) then
		    GuildedGUI.toggle();
        else
    		DEFAULT_CHAT_FRAME:AddMessage(GUILDED_HELP, info.r, info.g, info.b, info.id);
        end
    end;


    --[[ 
    -- joinGuilded( slashCmd, alias, name, pwd )
    --     Guilded Join Channel functionality
    --]]
    joinGuilded = function( slashCmd, alias, chan, pwd )
	    GuildedData.resetMembers();
		GuildedData.resetCrafters();
        local id = ChanComm.attach(slashCmd, alias, chan, pwd, Guilded.GUILDED_CMD_PREFIX, Guilded.cmdParser);
        if ( id > 0 ) then
		    local guild = GetGuildInfo("player");
			if ( not guild ) then
			    guild = "";
			end
			ChanComm.sendCmdMsg(Guilded.GUILDED_CMD_VERSION..":"..GUILDED_VERSION);
			ChanComm.sendCmdMsg(Guilded.GUILDED_CMD_JOIN..":"..UnitClass("player")..":"..UnitLevel("player")..":"..guild);
            local info = ChatTypeInfo["SYSTEM"];
            DEFAULT_CHAT_FRAME:AddMessage(format(GUILDED_JOINED, chan), info.r, info.g, info.b, info.id);

            GuildedTraders.onJoin();
        	GuildedGUI.onUpdate();
            return id;
        else
            return 0;
		end
    end;


    --[[ 
    -- leaveGuilded()
    --     Guilded Leave Channel functionality
    --]]
    leaveGuilded = function()
        if ( ChanComm.chanID > 0 ) then
            GuildedTraders.onLeave();
            local info = ChatTypeInfo["SYSTEM"];
            DEFAULT_CHAT_FRAME:AddMessage(format(GUILDED_LEFT, GuildedConfig.chanName), info.r, info.g, info.b, info.id);
			ChanComm.sendCmdMsg(Guilded.GUILDED_CMD_LEAVE);
    		GuildedData.resetMembers();
			ChanComm.detach();
		end
		GuildedGUI.onUpdate();
    end;


    --[[
    -- cmdHandler( cmd )
    --     Guilded default command message handler
    --]]
    cmdHandler = function( cmd, msg, author )
        if ( cmd and author) then
		    if ( cmd == Guilded.GUILDED_CMD_VERSION and msg ) then
			    if (GUILDED_VERSION < msg) then
				    if (Guilded.flagUpdate) then
				        StaticPopup_Show("GUILDED_WARNING", msg, GUILDED_VERSION);
						Guilded.flagUpdate = false;
					end
				end
		    elseif ( cmd == Guilded.GUILDED_CMD_JOIN and msg ) then
			    local class, level, guild;
				class = string.gsub(msg, "([^:]*).*", "%1");
				level = string.gsub(msg, "[^:]*:([^:]*).*", "%1");
				guild = string.gsub(msg, "[^:]*:[^:]*:([^:]*).*", "%1");
  			    GuildedData.addMember(author, class, level, guild);
                -- Broadcast player info for recently joined members
				if ( author ~= UnitName("player") ) then
        		    local guild = GetGuildInfo("player");
		        	if ( not guild ) then
        			    guild = "";
		        	end
        			ChanComm.sendCmdMsg(Guilded.GUILDED_CMD_UPDATE..":"..UnitClass("player")..":"..UnitLevel("player")..":"..guild);
				end
                local info = ChatTypeInfo["SYSTEM"];
                DEFAULT_CHAT_FRAME:AddMessage(format(GUILDED_PLAYER_JOINED, author), info.r, info.g, info.b, info.id);
		    elseif ( cmd == Guilded.GUILDED_CMD_UPDATE ) then
			    local class, level, guild
				class = string.gsub(msg, "([^:]*).*", "%1");
				level = string.gsub(msg, "[^:]*:([^:]*).*", "%1");
				guild = string.gsub(msg, "[^:]*:[^:]*:([^:]*).*", "%1");
  			    GuildedData.addMember(author, class, level, guild);
		    elseif ( cmd == Guilded.GUILDED_CMD_LEAVE ) then
    			GuildedData.delMember(author);
                local info = ChatTypeInfo["SYSTEM"];
                DEFAULT_CHAT_FRAME:AddMessage(format(GUILDED_PLAYER_LEFT, author), info.r, info.g, info.b, info.id);
            end
        end
    end;


    --[[
    -- cmdParser( msg, author )
    --     Guilded Command message parser
    --]]
    cmdParser = function( msg, author )
        if ( msg and author ) then
            local cmd = string.gsub(msg, "(:.*)", "");
			msg = string.sub(msg, string.len(cmd) + 2);
			
            if ( Guilded.cmdHandlers and cmd and Guilded.cmdHandlers[cmd] ) then
			    Guilded.cmdHandlers[cmd](cmd, msg, author);
        		GuildedGUI.onUpdate();
            end
        end
    end;


    --[[ 
    -- cmdRegisterHandler( cmd, handler )
    --     Register a Guilded Command and Handler pair
    --]]
    cmdRegisterHandler = function( cmd, handler )
        if ( cmd and handler ) then
            Guilded.cmdHandlers[cmd] = handler;
        end
    end;


    --[[ 
    -- cmdUnregisterHandler( cmd )
    --     Unregister a Guilded Command and Handler pair
    --]]
    cmdUnregisterHandler = function( cmd )
        if ( Guilded.cmdHandlers and cmd and Guilded.cmdHandlers[cmd] ) then
            table.remove(Guilded.cmdHandlers, cmd);
        end
    end;


	--[[
	--	sendChatMsg( msg )
    --      Sends a chat message to the Guilded channel.
	--
	--	Returns:
	--		success - true for successful send, false if something goes wrong.
	--]]		
    sendChatMsg = function( msg )
        return ChanComm.sendChatMsg( msg );
    end;


	--[[
	--	sendCmdMsg( cmd )
    --      Sends a command message to the Guilded channel.
	--
	--	Returns:
	--		success - true for successful send, false if something goes wrong.
	--]]		
    sendCmdMsg = function( cmd )
        return ChanComm.sendCmdMsg ( cmd );
    end;
};
