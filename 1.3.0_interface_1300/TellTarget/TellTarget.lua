--[[
	Tell Target

	By sarf

	This mod adds a binding which will automatically fill 
	in the chat edit box so that you can easily send a tell to your currently selected target.

	Thanks goes to Allanth for the idea!
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=269
	
   ]]


-- Constants

-- Variables
TellTarget_Debug_Enabled = 0;

function TellTarget_OnLoad()
	if ( Cosmos_RegisterChatCommand ) then
		local TellTargetDoTellTargetCommands = {"/telltarget","/tt","/tellt","/ttarget"};
		Cosmos_RegisterChatCommand (
			"TELLTARGET_DOTELLTARGET_COMMANDS", -- Some Unique Group ID
			TellTargetDoTellTargetCommands, -- The Commands
			TellTarget_SendMessageToTarget,
			TELLTARGET_CHAT_COMMAND_DO_TELLTARGET_INFO -- Description String
		);
	else
		SlashCmdList["TELLTARGETSLASHDOTELLTARGET"] = TellTarget_SendMessageToTarget;
		SLASH_TELLTARGETSLASHDOTELLTARGET1 = "/telltarget";
		SLASH_TELLTARGETSLASHDOTELLTARGET2 = "/tt";
		SLASH_TELLTARGETSLASHDOTELLTARGET3 = "/tellt";
		SLASH_TELLTARGETSLASHDOTELLTARGET4 = "/ttarget";
	end

end


function TellTarget_SendMessageToTarget(msg)
	if ( not UnitExists("target") ) then
		TellTarget_Print_Debug(TELLTARGET_CHAT_ERROR_NOTARGET);
		return;
	end;
	if ( not UnitIsPlayer("target") ) then
		TellTarget_Print_Debug(TELLTARGET_CHAT_ERROR_TARGET_NOTPLAYER);
		return;
	end
	if ( ( not msg ) or ( strlen(msg) <= 0 ) ) then
		TellTarget_DoTellTarget();
		return;
	end
	local name = UnitName("target");
	SendChatMessage(msg, "WHISPER", GetLanguageByIndex(0), name);
end

function TellTarget_Print_Debug(str)
	if (TellTarget_Debug_Enabled == 1) then
		TellTarget_Print(str);
	end
end

function TellTarget_DoTellTarget()
	if ( not UnitExists("target") ) then
		TellTarget_Print_Debug(TELLTARGET_CHAT_ERROR_NOTARGET);
		return;
	end;
	if ( not UnitIsPlayer("target") ) then
		TellTarget_Print_Debug(TELLTARGET_CHAT_ERROR_TARGET_NOTPLAYER);
		return;
	end
	local name = UnitName("target");
	if ( not name ) then
		TellTarget_Print_Debug(TELLTARGET_CHAT_ERROR_TARGET_NONAME);
		return;
	end
	local chatFrame = DEFAULT_CHAT_FRAME;
	chatFrame.editBox.chatType = "WHISPER";
	chatFrame.editBox.tellTarget = name;
	ChatEdit_UpdateHeader(chatFrame.editBox);
	if ( not chatFrame.editBox:IsVisible() ) then
		ChatFrame_OpenChat("", chatFrame);
	end
end

function TellTarget_OnEvent(event)
end

function TellTarget_Print(msg,r,g,b,frame,id,unknown4th)
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end

