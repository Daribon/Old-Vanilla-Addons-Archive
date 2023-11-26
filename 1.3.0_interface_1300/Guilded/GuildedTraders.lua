--[[
-- 
-- Guilded Traders is the Trading control functionality for Guilded.
--
--]]

--[[
-- GuildedTraders
--     The main GuildedTraders object
--]]
GuildedTraders = {
    GUILDED_CMD_TRADERS_BUY_ADD = "4";
    GUILDED_CMD_TRADERS_SELL_ADD = "5";
    GUILDED_CMD_TRADERS_CRAFT_JOIN = "6";
    GUILDED_CMD_TRADERS_CRAFT_LEAVE = "7";
    GUILDED_CMD_TRADERS_CRAFT_UPDATE = "8";
    GUILDED_CMD_TRADERS_BUY_DEL = "9";
    GUILDED_CMD_TRADERS_BUY_UPDATE = "10";
    GUILDED_CMD_TRADERS_SELL_DEL = "11";
    GUILDED_CMD_TRADERS_SELL_UPDATE = "12";
	
    --[[
    -- onLoad()
    --     OnLoad setup function
    --]]
    onLoad = function()
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_BUY_ADD, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_BUY_DEL, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_BUY_UPDATE, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_SELL_ADD, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_SELL_DEL, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_SELL_UPDATE, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_JOIN, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_LEAVE, GuildedTraders.cmdHandler);
		Guilded.cmdRegisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_UPDATE, GuildedTraders.cmdHandler);
	end;


    --[[
    -- onUnLoad()
    --     OnUnLoad setup function
    --]]
    onUnLoad = function()
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_BUY_ADD);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_BUY_DEL);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_BUY_UPDATE);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_SELL_ADD);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_SELL_DEL);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_SELL_UPDATE);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_JOIN);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_LEAVE);
		Guilded.cmdUnregisterHandler(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_UPDATE);
	end;


    --[[
    -- cmdHandler( cmd )
    --     Guilded default command message handler
    --]]
    cmdHandler = function( cmd, msg, author )
        if ( cmd and author) then
		    if ( cmd == GuildedTraders.GUILDED_CMD_TRADERS_BUY_ADD and msg ) then
			    local link, texture, itemCount, locked, quality, price;
				link = string.gsub(msg, "([^:]*:[^:]*:[^:]*:[^:]*:[^:]*).*", "%1");
				texture = string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1");
				itemCount = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
				locked = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
				quality = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
				price = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
  			    GuildedData.addItem(link, texture, itemCount, locked, quality, price, author);
				GuildedData.flagItem(link, author, "WTB", true);
		    elseif ( cmd == GuildedTraders.GUILDED_CMD_TRADERS_BUY_DEL and msg ) then
			    local link;
				link = string.gsub(msg, "([^:]*:[^:]*:[^:]*:[^:]*:[^:]*).*", "%1");
				GuildedData.flagItem(link, author, "WTB", false);
				GuildedData.delItem(link, author);
		    elseif ( cmd == GuildedTraders.GUILDED_CMD_TRADERS_SELL_ADD and msg ) then
			    local link, texture, itemCount, locked, quality, price;
				link = string.gsub(msg, "([^:]*:[^:]*:[^:]*:[^:]*:[^:]*).*", "%1");
				texture = string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1");
				itemCount = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
				locked = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
				quality = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
				price = tonumber(string.gsub(msg, "[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^:]*).*", "%1"), 10);
  			    GuildedData.addItem(link, texture, itemCount, locked, quality, price, author);
				GuildedData.flagItem(link, author, "WTS", true);
		    elseif ( cmd == GuildedTraders.GUILDED_CMD_TRADERS_SELL_DEL and msg ) then
			    local link;
				link = string.gsub(msg, "([^:]*:[^:]*:[^:]*:[^:]*:[^:]*).*", "%1");
				GuildedData.flagItem(link, author, "WTS", false);
				GuildedData.delItem(link, author);
		    elseif ( cmd == GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_JOIN ) then
			    local prof, cat, level;
				prof = string.gsub(msg, "([^:]*).*", "%1");
				level = string.gsub(msg, "[^:]*:([^:]*).*", "%1");
				cat = string.gsub(msg, "[^:]*:[^:]*:([^:]*).*", "%1");
  			    GuildedData.addCrafter(author, prof, cat, level);
                -- Broadcast player info for recently joined members
				if ( author ~= UnitName("player") ) then
        	        if ( GuildedConfig.advertProf ) then
    	                GuildedTraders.advertiseProfessions(true, true);
            		end
				end
		    elseif ( cmd == GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_LEAVE ) then
  			    GuildedData.delCrafter(author);
		    elseif ( cmd == GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_UPDATE ) then
			    local prof, cat, level;
				prof = string.gsub(msg, "([^:]*).*", "%1");
				level = string.gsub(msg, "[^:]*:([^:]*).*", "%1");
				cat = string.gsub(msg, "[^:]*:[^:]*:([^:]*).*", "%1");
  			    GuildedData.addCrafter(author, prof, cat, level);
            end
       		GuildedTradersGUI.onUpdate();
        end
    end;


    --[[
    -- onJoin()
    --     On join channel function
    --]]
    onJoin = function()
	    if ( GuildedConfig.advertProf ) then
    	    GuildedTraders.advertiseProfessions(true, false);
		end
		
		for i, item in GuildedConfig.stock do
		    if (item.wts) then
    		    GuildedTraders.sendBuySellItem(item.link, "WTS");
			end
			
		    if (item.wtb) then
    		    GuildedTraders.sendBuySellItem(item.link, "WTB");
			end
		end
	end;


    --[[
    -- onLeave()
    --     On leave channel function
    --]]
    onLeave = function()
	    GuildedTraders.advertiseProfessions(false, false);
		GuildedData.resetCrafters();
	end;

    --[[
    -- sendBuySellItem( link, stockType )
    --     Send Buy/Sell message.
    --]]
    sendBuySellItem = function(link, stockType)
	    local idx = GuildedConfig.findItem(link);
	    if (idx > 0) then
    	    local item = GuildedConfig.stock[idx];
			local lockValue;
			local cmd;

			if (item.locked) then
			    lockValue = 1;
			else
			    lockValue = 0;
			end

    	    if (stockType == "WTS") then
			    if (item.wts) then
            	    Guilded.sendCmdMsg(GuildedTraders.GUILDED_CMD_TRADERS_SELL_ADD..":"..item.link..":"..item.texture..":"..item.itemCount..":"..lockValue..":"..item.quality..":"..item.price);
				else
            	    Guilded.sendCmdMsg(GuildedTraders.GUILDED_CMD_TRADERS_SELL_DEL..":"..item.link);
				end
		    elseif (stockType == "WTB") then
			    if (item.wtb) then
            	    Guilded.sendCmdMsg(GuildedTraders.GUILDED_CMD_TRADERS_BUY_ADD..":"..item.link..":"..item.texture..":"..item.itemCount..":"..lockValue..":"..item.quality..":"..item.price);
				else
            	    Guilded.sendCmdMsg(GuildedTraders.GUILDED_CMD_TRADERS_BUY_DEL..":"..item.link);
				end
    		end
		end
	end;


    --[[
    -- advertiseProfessions( join, updateOnly )
    --     Advertise professions or cancel advert.
    --]]
    advertiseProfessions = function( join, updateOnly )
	    if ( join ) then
    		local numSkills = GetNumSkillLines();
    		local professionsFound = false;
    		local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType;
    		for skillIdx = 1, numSkills do
    		    skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType = GetSkillLineInfo(skillIdx);
    			if ( header and ( skillName ==  TRADE_SKILLS ) ) then
    			    professionsFound = true;
    			elseif ( professionsFound ) then
    			    if ( header ) then
    				    break;
    				else
					    if ( updateOnly ) then
                		    Guilded.sendCmdMsg(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_UPDATE..":"..skillName..":"..skillRank..":".."TBD");
						else
                		    Guilded.sendCmdMsg(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_JOIN..":"..skillName..":"..skillRank..":".."TBD");
						end
	    			end
	    		end
	    	end
		else
    	    Guilded.sendCmdMsg(GuildedTraders.GUILDED_CMD_TRADERS_CRAFT_LEAVE);
		end
	end;
};
