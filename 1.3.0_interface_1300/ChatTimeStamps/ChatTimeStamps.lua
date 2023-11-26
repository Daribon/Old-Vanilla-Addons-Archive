--[[
	ChatTimeStamps

	Originally by sarf (Anders Kronquist)

	This mod allows time stamps to be prepended to chat. 
	In this version it requires a lot of changes to ChatFrame.lua, so it is Cosmos-dependent
	
  ]]--
   
ChatTimeStamps_ENABLED = nil;
ChatTimeStamps_SEPARATOR = nil;

ChatTimeStamps_PRINTOVERLOAD = nil;
   
function ChatTimeStamps_Toggle(toggle)	
	if (toggle == 1) then 
		ChatTimeStamps_ENABLED = 1;
		
		-- handle the overload of the cosmos print function
		if(Print and not ChatTimeStamps_PRINTOVERLOAD) then
			ChatTimeStamps_PRINTOVERLOAD = Print;
			Print = CTS_Print;
		elseif(not ChatTimeStamps_PRINTOVERLOAD) then
			ChatTimeStamps_PRINTOVERLOAD = COS_Print;
			Print = CTS_Print;
		end
	else
		-- undo the overload of the cosmos print function
		if(ChatTimeStamps_PRINTOVERLOAD) then
			Print = ChatTimeStamps_PRINTOVERLOAD;
			ChatTimeStamps_PRINTOVERLOAD = nil;
		end
		ChatTimeStamps_ENABLED = nil;
	end
end

function COS_Print(msg,r,g,b,frame)
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
		end
	end
end

function CTS_Print(msg,r,g,b,frame,id,unknown4th)
	msg = ChatTimeStamps_TimeStamp(msg);
				
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


function ChatTimeStamps_ToggleSeparator(toggle)	
	if (toggle == 1) then 
		ChatTimeStamps_SEPARATOR = 1;
	else
		ChatTimeStamps_SEPARATOR = nil;
	end
end

function ChatTimeStamps_OnLoad()
	if (Cosmos_RegisterConfiguration) then
		Cosmos_RegisterConfiguration(
			"COS_CHATTS",
			"SECTION",
			CHATTS_CONFIG_HEADER,
			CHATTS_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_CHATTS_HEADER",
			"SEPARATOR",
			CHATTS_CONFIG_HEADER,
			CHATTS_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_CHATTS_ENABLED",
			"CHECKBOX",
			CHATTS_CONFIG_ENABLED,
			CHATTS_CONFIG_ENABLED_INFO,
			ChatTimeStamps_Toggle,
			0
		);
		Cosmos_RegisterConfiguration(
			"COS_CHATTS_SEPARATOR",
			"CHECKBOX",
			CHATTS_CONFIG_SEPARATOR,
			CHATTS_CONFIG_SEPARATOR_INFO,
			ChatTimeStamps_ToggleSeparator,
			0
		);
	else
		-- ADD STANDALONE CONFIG HERE
	end
end

function ChatTimeStamps_TimeStamp(msg)
	if (ChatTimeStamps_ENABLED) then
		local separator = "";
		if ( ChatTimeStamps_SEPARATOR ) then
			separator = ">";	
		end
		if (Clock_GetTimeText) then
			return Clock_GetTimeText()..separator.." "..msg;
		end

		local hour, minute = GetGameTime();
		
		local timestring = format(TEXT(CHATTS_FORMAT_STRING), hour, minute);
		local ts_body = timestring..separator.." "..msg;
	
		return ts_body;
	else
		return msg;
	end
end