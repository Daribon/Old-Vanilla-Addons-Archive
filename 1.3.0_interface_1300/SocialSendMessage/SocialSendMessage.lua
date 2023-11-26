--[[

	SocialSendMessage: Adds a "Send Message" button to the Social frames that do not have one.
	- by geowar 5 Sep, 2004.
	- added a "Send Page" button 6 Sep, 2004 - geowar
]]

-- Configuration variables
local COS_SSM_SEND_MESSAGE_ENABLE	= nil;	-- set this to non nil to enable the 'Send Message' button
local COS_SSM_SEND_PAGE_ENABLE	= nil;		-- set this to non nil to enable the 'Send Page' button

-- Callback functions

function SSM_SendMessageEnable(toggle)
	if(toggle == 1) then 
		COS_SSM_SEND_MESSAGE_ENABLE = 1;
	else
		COS_SSM_SEND_MESSAGE_ENABLE = nil;
	end
	SSM_Save();
end

function SSM_SendPageEnable(toggle)
	if(toggle == 1) then 
		COS_SSM_SEND_PAGE_ENABLE = 1;
	else
		COS_SSM_SEND_PAGE_ENABLE = nil;
	end
	SSM_Save();
end

-- OnFoo functions

function SocialSendMessage_OnLoad()
	--Print("SocialSendMessage_OnLoad.");

	this:RegisterEvent("VARIABLES_LOADED");

	-- Register with the CosmosMaster
	if(Cosmos_RegisterConfiguration ~= nil) then
		Cosmos_RegisterConfiguration(
			"COS_SSM",
			"SECTION",
			TEXT(COS_SSM_SEP_TEXT),
			TEXT(COS_SSM_SEP_INFO)
			);
		Cosmos_RegisterConfiguration(
			"COS_SSM_SEPARATOR",
			"SEPARATOR",
			TEXT(COS_SSM_SEP_TEXT),
			TEXT(COS_SSM_SEP_INFO)
			);

		Cosmos_RegisterConfiguration(
			"COS_SSM_SEND_MESSAGE_ENABLE",	--CVar
			"CHECKBOX",						--Things to use
			TEXT(COS_SSM_SEND_MESSAGE_ENABLE_TEXT),
			TEXT(COS_SSM_SEND_MESSAGE_ENABLE_INFO),
			SSM_SendMessageEnable,		--Callback
			1							--Default Checked/Unchecked
			);
	
		Cosmos_RegisterConfiguration(
			"COS_SSM_SEND_PAGE_ENABLE",		--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SSM_SEND_PAGE_ENABLE_TEXT),
			TEXT(COS_SSM_SEND_PAGE_ENABLE_INFO),
			SSM_SendPageEnable,			--Callback
			1							--Default Checked/Unchecked
			);

		--Print("SocialSendMessage_OnLoad, Cosmos Registered.");
	end
end

function SocialSendMessage_OnEvent()
--[[
	if(nil == arg1) then
		Print(format("SocialSendMessage_OnEvent:%s: {}.", event));
	else
		if(nil == arg2) then
			Print(format("SocialSendMessage_OnEvent:%s: {%s}.", event, arg1));
		else
			Print(format("SocialSendMessage_OnEvent:%s: {%s, %s}.", event, arg1, arg2));
		end
	end
]]
	if(event == "VARIABLES_LOADED") then
		if(COS_SSM_SEND_MESSAGE_ENABLE == nil) then
			COS_SSM_SEND_MESSAGE_ENABLE = 1;
		end
		SSM_SendMessageEnable(COS_SSM_SEND_MESSAGE_ENABLE);

		if(COS_SSM_SEND_PAGE_ENABLE == nil) then
			COS_SSM_SEND_PAGE_ENABLE = 1;
		end
		SSM_SendPageEnable(COS_SSM_SEND_PAGE_ENABLE);

		return;
	end
end

function SSM_Save()
	RegisterForSave("COS_SSM_SEND_MESSAGE_ENABLE");
	RegisterForSave("COS_SSM_SEND_PAGE_ENABLE");
end

function SocialSendMessage_Update()
	--Print("SocialSendMessage_Update.");
	if (COS_SSM_SEND_MESSAGE_ENABLE) then
		WhoFrameSendMessageButton:Show();
		if ( WhoFrame.selectedName ) then
			WhoFrameSendMessageButton:Enable();
		else
			WhoFrameSendMessageButton:Disable();
		end
		
		GuildFrameSendMessageButton:Show();
		if ( GuildFrame.selectedName ) then
			GuildFrameSendMessageButton:Enable();
		else
			GuildFrameSendMessageButton:Disable();
		end
	else
		WhoFrameSendMessageButton:Hide();
		GuildFrameSendMessageButton:Hide();
	end

	if (COS_SSM_SEND_PAGE_ENABLE) then
		FriendsFrameSendPageButton:Show();
		if ( FriendsFrame.selectedName ) then
			FriendsFrameSendPageButton:Enable();
		else
			FriendsFrameSendPageButton:Disable();
		end

		WhoFrameSendPageButton:Show();
		if ( WhoFrame.selectedName ) then
			WhoFrameSendPageButton:Enable();
		else
			WhoFrameSendPageButton:Disable();
		end

		GuildFrameSendPageButton:Show();
		if ( GuildFrame.selectedName ) then
			GuildFrameSendPageButton:Enable();
		else
			GuildFrameSendPageButton:Disable();
		end
	else
		FriendsFrameSendPageButton:Hide();
		WhoFrameSendPageButton:Hide();
		GuildFrameSendPageButton:Hide();
	end
end

function SocialSendMessage_SendMessage(name)
	if ( name ) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetText("/w "..name.." ");
		else
			ChatFrame_OpenChat("/w "..name.." ");
		end
		ChatEdit_ParseText(ChatFrame1.editBox, 0);
	end
end

function SocialSendMessage_SendPage(name)
	if ( name ) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetText("/page "..name.." ");
		else
			ChatFrame_OpenChat("/page "..name.." ");
		end
		ChatEdit_ParseText(ChatFrame1.editBox, 0);
	end
end
