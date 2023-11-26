--[[
-- 
-- GuildedGUI is the main user interface to the Guilded AddOn
--
--]]
UIPanelWindows["GuildedFrame"] = { area = "left", pushable = 11 };

GuildedGUI = {
    --[[
    -- onLoad()
    --     OnLoad initialisation function
    --]]
    onLoad = function()
		Guilded.onLoad();

    	PanelTemplates_SetNumTabs(GuildedFrame, 4);
		GuildedFrame.selectedTab = 1;
		
		if ( not GuildedRaiders ) then
		    PanelTemplates_DisableTab(GuildedFrame, 3);
		end
	    PanelTemplates_UpdateTabs(GuildedFrame);

    	GuildedFrame:RegisterForDrag("LeftButton");
    end;


    --[[
    -- showSubFrame()
    --     Shows the subframe name given and hides the rest.
    --]]
    GUILDED_SUBFRAMES = { "GuildedListFrame", "GuildedTradersFrame", "GuildedRaidersFrame", "GuildedConfigFrame" };
    showSubFrame = function( frameName )
    	for index, value in GuildedGUI.GUILDED_SUBFRAMES do
	    	if ( value == frameName ) then
		    	getglobal(value):Show()
    		else
	    		getglobal(value):Hide();	
		    end	
    	end 
    end;

	
    --[[
    -- onUpdate()
    --     Update the main GUI display
    --]]
    onUpdate = function()
	    if ( not GuildedFrame:IsVisible() ) then
		    return;
		end

    	if ( GuildedFrame.selectedTab == 1 ) then
			GuildedFrameTopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
			GuildedFrameTopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
			GuildedFrameBottomLeft:SetTexture("Interface\\FriendsFrame\\WhoFrame-BotLeft");
			GuildedFrameBottomRight:SetTexture("Interface\\FriendsFrame\\WhoFrame-BotRight");
			GuildedFrameTitleText:SetText(GUILDED_MEMBERS_LIST);
			GuildedListGUI.onUpdate();
			GuildedGUI.showSubFrame("GuildedListFrame");
		elseif ( GuildedFrame.selectedTab == 2 ) then
			GuildedFrameTopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
			GuildedFrameTopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
			GuildedFrameBottomLeft:SetTexture("Interface\\FriendsFrame\\UI-IgnoreFrame-BotLeft");
			GuildedFrameBottomRight:SetTexture("Interface\\FriendsFrame\\UI-IgnoreFrame-BotRight");
			GuildedFrameTitleText:SetText(GUILDED_TRADERS_LIST);
			GuildedTradersGUI.onUpdate();
			GuildedGUI.showSubFrame("GuildedTradersFrame");
		elseif ( GuildedFrame.selectedTab == 3 ) then
			GuildedFrameTopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
			GuildedFrameTopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
			GuildedFrameBottomLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft");
			GuildedFrameBottomRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight");
			GuildedFrameTitleText:SetText(GUILDED_RAIDERS_LIST);
			GuildedRaidersGUI.onUpdate();
			GuildedGUI.showSubFrame("GuildedRaidersFrame");
		elseif ( GuildedFrame.selectedTab == 4 ) then
			GuildedFrameTopLeft:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft");
			GuildedFrameTopRight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight");
			GuildedFrameBottomLeft:SetTexture("Interface\\FriendsFrame\\UI-IgnoreFrame-BotLeft");
			GuildedFrameBottomRight:SetTexture("Interface\\FriendsFrame\\UI-IgnoreFrame-BotRight");
			GuildedFrameTitleText:SetText(GUILDED_CONFIG_LIST);
			GuildedConfigGUI.onUpdate();
			GuildedGUI.showSubFrame("GuildedConfigFrame");
		end;
    end;


    --[[
    -- onShow()
    --     onShow event handler
    --]]
    onShow = function( event )
    	PlaySound("igMainMenuOpen");
	    GuildedGUI.onUpdate();
    end;


    --[[
    -- onHide()
    --     onHide event handler
    --]]
    onHide = function( event )
    	PlaySound("igMainMenuClose");
    end;


    --[[ 
    -- onDragStart()
    --     onDragStart event handler
    --]]
    onDragStart = function()
    	GuildedFrame:StartMoving();
    end;


    --[[ 
    -- onDragStop()
    --     onDragStop event handler
    --]]
    onDragStop = function()
    	GuildedFrame:StopMovingOrSizing();
    end;


    --[[ 
    -- toggle()
    --     toggle the GUI display. Used by the key bindings.
    --]]
    toggle = function()
	    if ( GuildedFrame:IsVisible() ) then
    		HideUIPanel(GuildedFrame);
		else
    		ShowUIPanel(GuildedFrame);
		end
    end;
};



--[[
--	GuildedInitialiser( arg1 )
--      Wait until the player name is loaded, then attempt to attach to the guilded channel after 
--      all the global channels have been joined and the guilded channel has been created.
--]]		
local guildedInitialiserTimer = 0.0;
local guildedJoinChannelAttempts = 0;
local guildedLastChannelJoined = 1;
local GUILDED_INIT_TIMEOUT = 0.25;
local GUILDED_MAX_CHANNEL_JOIN_ATTEMPTS = 4; -- equals about 1 second after last channel joined.
GuildedInitialiser = function (arg1)
    guildedInitialiserTimer = guildedInitialiserTimer + arg1;
    if (guildedInitialiserTimer < GUILDED_INIT_TIMEOUT) then
        return;
    end
    guildedInitialiserTimer = 0.0;
	
	-- First get player name
	if (GuildedPlayerIndex == nil) then
    	local playerName = UnitName("player");
        if ( (playerName == nil) or (playerName == UNKNOWNBEING)
    	  or (playerName == UKNOWNBEING) or (playerName == UNKNOWNOBJECT) ) then
	        return;
    	else
	        GuildedPlayerIndex = GetCVar("realmName").."_"..playerName;
			if (GuildedConfigAll[GuildedPlayerIndex]) then
    			GuildedConfig.loadData(GuildedConfigAll[GuildedPlayerIndex]);
			end
    	end
	else -- Then check for Guilded channel name
        guildedJoinChannelAttempts = guildedJoinChannelAttempts + 1;
        -- Wait until world channels are loaded
        if (GetChannelName(guildedLastChannelJoined) ~= guildedLastChannelJoined) then
            if (guildedJoinChannelAttempts > GUILDED_MAX_CHANNEL_JOIN_ATTEMPTS) then
	    	    -- assume it is safe to join channel
		        if (GuildedConfig.valid and GuildedConfig.slashChatCmd and GuildedConfig.chanAlias and GuildedConfig.chanName and GuildedConfig.chanPwd ) then
		            if (Guilded.joinGuilded(GuildedConfig.slashChatCmd, GuildedConfig.chanAlias, GuildedConfig.chanName, GuildedConfig.chanPwd) > 0) then
			            this:Hide();
            	    end
	    	    else
		            this:Hide();
	    	    end
    	    end
			return;
		else
		    guildedLastChannelJoined = guildedLastChannelJoined + 1;
			guildedJoinChannelAttempts = 0;
        end
	end
end;


--[[
-- GuildedSetColumnWidth( width, frame )
--     Set the column width for the column header
--]]
GuildedSetColumnWidth = function( width, frame )
    if ( not frame ) then
    	frame = this;
   	end
    frame:SetWidth(width);
   	getglobal(frame:GetName().."Middle"):SetWidth(width - 9);
end;
	
