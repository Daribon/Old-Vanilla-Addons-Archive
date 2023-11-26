--[[
-- 
-- GuildedConfigGUI is the Guilded Configuration sub-frame user interface
--
--]]
GuildedConfigGUI = {
    --[[
    -- onUpdate()
    --     Update the Configuration sub-frame display
    --]]
    onUpdate = function()
	    local slashChatCmd = GuildedConfig.slashChatCmd;
	    local alias = GuildedConfig.chanAlias;
	    local name = GuildedConfig.chanName;
	    local pwd = GuildedConfig.chanPwd;
		if (not slashChatCmd) then slashChatCmd = GUILDED_DEFAULT_CHAT_SLASHCMD end
		if (not alias) then alias = GUILDED_DEFAULT_CHAT_ALIAS end
		if (not name) then name = "" end
		if (not pwd) then pwd = "" end
	    GuildedConfigFrameChannelSlashCmdText:SetText(slashChatCmd);
	    GuildedConfigFrameChannelAliasText:SetText(alias);
	    GuildedConfigFrameChannelNameText:SetText(name);
	    GuildedConfigFrameChannelPasswordText:SetText(pwd);
	    GuildedConfigFrameChannelSlashCmdText:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	    GuildedConfigFrameChannelAliasText:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	    GuildedConfigFrameChannelNameText:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
	    GuildedConfigFrameChannelPasswordText:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);

        if (GuildedConfig.valid) then
    		GuildedConfigFrameStatus:SetText(GUILDEDCONFIG_ONLINE);
	        GuildedConfigFrameStatus:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		else
    		GuildedConfigFrameStatus:SetText(GUILDEDCONFIG_OFFLINE);
	        GuildedConfigFrameStatus:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		end
    end;

	
    --[[
    -- onReset()
    --     Reset and leave the current Guilded configuration
    --]]
    onReset = function()
	    Guilded.leaveGuilded();
	    GuildedConfig.valid = false;
		GuildedConfig.slashChatCmd = GUILDED_DEFAULT_CHAT_SLASHCMD;
	    GuildedConfig.chanAlias = GUILDED_DEFAULT_CHAT_ALIAS;
	    GuildedConfig.chanName = nil;
	    GuildedConfig.chanPwd = nil;
		GuildedConfigGUI.onUpdate();
		
		GuildedConfigFrameChannelSlashCmdText:ClearFocus();
		GuildedConfigFrameChannelAliasText:ClearFocus();
		GuildedConfigFrameChannelNameText:ClearFocus();
		GuildedConfigFrameChannelPasswordText:ClearFocus();
    end;

	
    --[[
    -- onAccept()
    --     Accept and join the current Guilded configuration
    --]]
	onAccept = function()
	    local slashCmd = GuildedConfigFrameChannelSlashCmdText:GetText();
	    local alias = GuildedConfigFrameChannelAliasText:GetText();
	    local name = GuildedConfigFrameChannelNameText:GetText();
		
		if (slashCmd and alias and name) then
    	    GuildedConfig.valid = true;
    	    GuildedConfig.slashChatCmd = slashCmd;
	        GuildedConfig.chanAlias = alias;
	        GuildedConfig.chanName = name;
    	    GuildedConfig.chanPwd = GuildedConfigFrameChannelPasswordText:GetText();
	    	GuildedConfigGUI.onUpdate();
   		    if ( Guilded.joinGuilded(GuildedConfig.slashChatCmd, GuildedConfig.chanAlias, GuildedConfig.chanName, GuildedConfig.chanPwd) <= 0) then
			    GuildedInitialiserFrame:Show();
			end
		end
		
		GuildedConfigFrameChannelSlashCmdText:ClearFocus();
		GuildedConfigFrameChannelAliasText:ClearFocus();
		GuildedConfigFrameChannelNameText:ClearFocus();
		GuildedConfigFrameChannelPasswordText:ClearFocus();
    end;

	
    --[[
    -- onCheckButtonClick()
    --     Update the configuration
    --]]
    onCheckButtonClick = function()
	    if ( this == getglobal("GuildedConfigFrameAdvertProfCheckButton") ) then
		    GuildedConfig.advertProf = GuildedConfigFrameAdvertProfCheckButton:GetChecked();
    	    GuildedTraders.advertiseProfessions(GuildedConfig.advertProf, false);
		end
    end;
};
