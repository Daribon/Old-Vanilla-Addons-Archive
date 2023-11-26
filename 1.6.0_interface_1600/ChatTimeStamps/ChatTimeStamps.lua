--[[
	ChatTimeStamps

	Originally by sarf (Anders Kronquist)
	Recode by Alexander (Alexander Brazie)

	This mod allows time stamps to be prepended to chat. 
	
	It does not require modifications to ChatFrame.lua any longer.
	However, the configuration is UltimateUI 2 dependent. 
	
  ]]--
   
ChatTimeStamps_ENABLED = nil;
ChatTimeStamps_SEPARATOR = nil;
ChatTimeStamps_LOCALTIME = true;
ChatTimeStamps_PRINTOVERLOAD = nil;
ChatTimeStamps_DELAY = nil;
ChatTimeStamps_SILENCE = nil;
ChatTimeStamps_ORIGINAL = ChatFrame1.AddMessage;

ChatTimeStamps_LastStamp = {}; 
  
function ChatTimeStamps_Toggle(state)	
	if (state == 1 or (type(state) == "table" and state.checked)) then 
		ChatTimeStamps_ENABLED = true;
		
	else
		ChatTimeStamps_ENABLED = nil;
	end
end

function ChatTimeStamps_ToggleSeparator(state)	
	if (state == 1 or (type(state) == "table" and state.checked)) then 
		ChatTimeStamps_SEPARATOR = true;
	else
		ChatTimeStamps_SEPARATOR = nil;
	end
end

function ChatTimeStamps_ToggleLocalTime(state)	
	if (state == 1 or (type(state) == "table" and state.checked)) then 
		ChatTimeStamps_LOCALTIME = true;
	else
		ChatTimeStamps_LOCALTIME = nil;
	end
end

function ChatTimeStamps_ToggleSilence(state)	
	if (state == 1 or (type(state) == "table" and state.checked)) then 
		ChatTimeStamps_SILENCE = true;
	else
		ChatTimeStamps_SILENCE = nil;
	end
end

function ChatTimeStamps_ChangeDelay(state)	
	if (state.checked) then 
		ChatTimeStamps_DELAY = state.slider*60;
	else
		ChatTimeStamps_DELAY = nil;
	end
end

function ChatTimeStamps_ChangeAffectedChatFrames(state)
	for i=1,5 do 
		if ( Sea.list.isInList(state.value, i) ) then 
			getglobal("ChatFrame"..i).AddMessage = ChatTimeStamps_NewAddMessage;
		else
			getglobal("ChatFrame"..i).AddMessage = ChatTimeStamps_ORIGINAL;
		end
	end
end

function ChatTimeStamps_OnLoad()
	if ( Khaos ) then 
		Khaos.registerFolder(
			{
				id = "chat";
				text = CHAT_FOLDER_TITLE;
				helptext = CHAT_FOLDER_HELP;
				difficulty = 2;
			}
		);

		local CTTS_Feedback = function ( state )
			if ( ChatTimeStamps_ENABLED ) then 
				return string.format(CHATTS_CONFIG_FEEDBACK_ENABLED,  ChatTimeStamps_TimeStamp(CHATTS_CONFIG_FEEDBACK_EXAMPLE) );
			else
				return string.format(CHATTS_CONFIG_FEEDBACK_DISABLED,  ChatTimeStamps_TimeStamp(CHATTS_CONFIG_FEEDBACK_EXAMPLE) );
			end
		end;

		local CTTS_Options = {
				{
					id="ChatTimeStampsHeader";
					text=CHATTS_CONFIG_HEADER;
					helptext=CHATTS_CONFIG_HEADER_INFO;
					difficulty=1;
					type=K_HEADER;
				},
				{
					id="ChatTimeStampsEnable";
					text=CHATTS_CONFIG_ENABLED;
					helptext=CHATTS_CONFIG_ENABLED_INFO;
					difficulty=1;
					key="enable";
					check=true;
					type=K_TEXT;
					callback=ChatTimeStamps_Toggle;
					feedback=CTTS_Feedback;
					default = {
						checked = true;
					};
					disabled = {
						checked = false;
					};
				},
				{
					id="ChatTimeStampsSeparator";
					text=CHATTS_CONFIG_SEPARATOR;
					helptext=CHATTS_CONFIG_SEPARATOR_INFO;
					difficulty=1;
					key="separator";
					check=true;
					type=K_TEXT;
					callback=ChatTimeStamps_ToggleSeparator;
					feedback=CTTS_Feedback;
					default = {
						checked = true;
					};
					disabled = {
						checked = false;
					};
				},
				{
					id="ChatTimeStampsDelay";
					text=CHATTS_CONFIG_PERIODICSTAMPS;
					helptext=CHATTS_CONFIG_PERIODICSTAMPS_INFO;
					difficulty=3;
					key="delay";
					check=true;
					type=K_SLIDER;
					callback=ChatTimeStamps_ChangeDelay;
					feedback=CTTS_Feedback;
					setup = {
						sliderMin = 1;
						sliderMax = 60;
						sliderStep = 1;
						sliderText = CHATTS_CONFIG_PERIODICSTAMPS_SLIDER_TEXT;
					};
					default = {
						checked = false;
						slider = 5;
					};
					disabled = {
						checked = false;
						slider = 1;
					};
				},
				{
					id="ChatTimeStampsSilence";
					text=CHATTS_CONFIG_SILENCE;
					helptext=CHATTS_CONFIG_SILENCE_INFO;
					difficulty=3;
					key="silence";
					check=true;
					type=K_TEXT;
					callback=ChatTimeStamps_ToggleSilence;
					feedback=CTTS_Feedback;
					default = {
						checked = false;
					};
					disabled = {
						checked = false;
					};
					dependencies = {
						delay = {checked=true;match=true;};
					};
				},
				{
					id="ChatTimeStampsLocalTime";
					text=CHATTS_CONFIG_LOCALTIME;
					helptext=CHATTS_CONFIG_LOCALTIME_INFO;
					difficulty=1;
					key="localtime";
					check=true;
					type=K_TEXT;
					callback=ChatTimeStamps_ToggleLocalTime;
					feedback=CTTS_Feedback;
					default = {
						checked = true;
					};
					disabled = {
						checked = false;
					};
				},		
				{
					id="ChatTimeStampsAffectedFrames";
					text=CHATTS_CONFIG_CHOOSEFRAMES;
					helptext=CHATTS_CONFIG_CHOOSEFRAMES_INFO;
					difficulty=1;
					key="frames";
					type=K_PULLDOWN;
					callback=ChatTimeStamps_ChangeAffectedChatFrames;
					feedback=CTTS_Feedback;
					default = {
						value={1,2,3,4,5,6};
					};
					disabled = {
						value={};
					};
					setup = {
						options = ChatTimeStamps_GetFrameNames;
						multiSelect = true;
					};
				}	
			};
		
		Khaos.registerOptionSet(
			"chat",
			{
				id = "ChatTimeStamps";
				text = CHATTS_CONFIG_HEADER;
				helptext = CHATTS_CONFIG_HEADER_INFO;
				options = CTTS_Options;
				difficulty = 2;
			}
		);
	elseif (UltimateUI_RegisterConfiguration) then
		UltimateUI_RegisterConfiguration(
			"UUI_CHATTS",
			"SECTION",
			CHATTS_CONFIG_HEADER,
			CHATTS_CONFIG_HEADER_INFO
		);
		UltimateUI_RegisterConfiguration(
			"UUI_CHATTS_HEADER",
			"SEPARATOR",
			CHATTS_CONFIG_HEADER,
			CHATTS_CONFIG_HEADER_INFO
		);
		UltimateUI_RegisterConfiguration(
			"UUI_CHATTS_ENABLED",
			"CHECKBOX",
			CHATTS_CONFIG_ENABLED,
			CHATTS_CONFIG_ENABLED_INFO,
			ChatTimeStamps_Toggle,
			0
		);
		UltimateUI_RegisterConfiguration(
			"UUI_CHATTS_SEPARATOR",
			"CHECKBOX",
			CHATTS_CONFIG_SEPARATOR,
			CHATTS_CONFIG_SEPARATOR_INFO,
			ChatTimeStamps_ToggleSeparator,
			0
		);
		UltimateUI_RegisterConfiguration(
			"UUI_CHATTS_LOCALTIME",
			"CHECKBOX",
			CHATTS_CONFIG_LOCALTIME,
			CHATTS_CONFIG_LOCALTIME_INFO,
			ChatTimeStamps_ToggleLocalTime,
			0
		);
		-- Overwrite the default AddMessage
		ChatFrame1.AddMessage = ChatTimeStamps_NewAddMessage;
		ChatFrame2.AddMessage = ChatTimeStamps_NewAddMessage;
		ChatFrame3.AddMessage = ChatTimeStamps_NewAddMessage;
		ChatFrame4.AddMessage = ChatTimeStamps_NewAddMessage;
		ChatFrame5.AddMessage = ChatTimeStamps_NewAddMessage;
		ChatFrame6.AddMessage = ChatTimeStamps_NewAddMessage;
		
	else
		-- ADD STANDALONE CONFIG HERE
	end
end

function ChatTimeStamps_TimeStamp(msg)
	if (ChatTimeStamps_ENABLED) and ( msg ) then
		local separator = "";
		if ( ChatTimeStamps_SEPARATOR ) then
			separator = ">";	
		end
		if ( date and ChatTimeStamps_LOCALTIME ) then 
			return date()..separator.." "..msg;
		end
		if (Clock_GetTimeText) then
			return Clock_GetTimeText()..separator.." "..msg;
		end

		local hour, minute = GetGameTime();
		
		if (hour < 10) then 
			hour = "0"..hour; 
		end
	
		if (minute < 10) then 
			minute = "0"..minute; 
		end
	
		local timestring = hour..":"..minute;
		local ts_body = timestring..separator.." "..msg;
	
		return ts_body;
	else
		return msg;
	end
end

function ChatTimeStamps_NewAddMessage(self, msg, ...)
	if ( not ChatTimeStamps_LastStamp[self:GetName()] ) then 
		ChatTimeStamps_LastStamp[self:GetName()] = 0;
	end
	if ( ChatTimeStamps_SILENCE and ChatTimeStamps_LastStamp[self:GetName()] + ChatTimeStamps_DELAY < GetTime() ) then 
		ChatTimeStamps_LastStamp[self:GetName()] = GetTime();
	end
	if ( not ChatTimeStamps_DELAY or ChatTimeStamps_LastStamp[self:GetName()] + ChatTimeStamps_DELAY < GetTime() ) then 
		msg = ChatTimeStamps_TimeStamp(msg);
		ChatTimeStamps_LastStamp[self:GetName()] = GetTime();
	end
	ChatTimeStamps_ORIGINAL(self, msg, unpack(arg));
end

function ChatTimeStamps_GetFrameNames ()
	local options = {};

	for i=1,5 do 
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(i);
		
		if ( name ~= "" ) then 
			options[name] = i;
		end
	end

	return options;
end
