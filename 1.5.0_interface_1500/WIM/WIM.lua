WIMOptions = {};
local gotVariables = false;
local gotPlayerName = false;
local Realm;
local Player;

BINDING_HEADER_WIM = "WIM Bindings";
BINDING_NAME_WIMREPLY = "WIM Reply";
BINDING_NAME_WIMSAY = "WIM Say";

local function InitializeSetup()
	Player=UnitName("player");
	Realm=GetCVar("realmName");

	if WIMOptions[Realm] == nil then
		WIMOptions[Realm] = {};
	end

	if WIMOptions[Realm][Player] == nil then
		WIMOptions[Realm][Player] = {};
		WIMOptions[Realm][Player].Enabled = true;
	end
end

function WIM_OnLoad()
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
	WIM_Version = "WoW Instant Messenger v0.3";
	SlashCmdList["WIM"] = WIM_SlashHandler;
	SLASH_WIM1 = "/WIM";
	DEFAULT_CHAT_FRAME:AddMessage(WIM_Version);
	DEFAULT_CHAT_FRAME:AddMessage(WIM_HELP_ONLOAD);
	InitializeSetup();
end

function WIM_OnEvent(event)
	if (event == "CHAT_MSG_WHISPER") then
		if WIMOptions[Realm][Player].Enabled == true then
			local OtherPlayer = arg2;
			local message = arg1;
			WIM_AddIncomingMessage(OtherPlayer, message);
		end
	end
	
	if (event == "CHAT_MSG_WHISPER_INFORM") then
		if WIMOptions[Realm][Player].Enabled == true then
			local OtherPlayer = arg2;
			local message = arg1;
			WIM_AddOutgoingMessage(OtherPlayer, message);
		end
	end
end

function WIM_SlashHandler(msg)

	if (msg == '') then msg = nil end
	
	if msg then
		local command = WIM_Split(msg, " ")
		local current = string.lower(command[1]);
		if (command[2] == '') then
			command[2] = nil;
		end
	
		if (current == 'on') then
			WIMOptions[Realm][Player].Enabled = true;
			DEFAULT_CHAT_FRAME:AddMessage(WIM_ENABLED);
		end

		if (current == 'off') then
			WIMOptions[Realm][Player].Enabled = false;
			DEFAULT_CHAT_FRAME:AddMessage(WIM_DISABLED);
		end

		if (current == 'status') then
			WIM_ShowStatus();
		end

		if (current == 'help') then
			DEFAULT_CHAT_FRAME:AddMessage(WIM_Version);
		end
				
	else
		DEFAULT_CHAT_FRAME:AddMessage(WIM_Version);
		WIM_ShowStatus();
		DEFAULT_CHAT_FRAME:AddMessage(WIM_VALID_PARAMETERS);
	end
end



function WIM_ShowStatus()
	if (WIMOptions[Realm][Player].Enabled) then
		DEFAULT_CHAT_FRAME:AddMessage(WIM_STATUS_ON);
	else
		DEFAULT_CHAT_FRAME:AddMessage(WIM_STATUS_OFF);
	end
end

function WIM_Split(toCut, separator)
	local splitted = {};
	local i = 0;
	if (separator == nil) then
		 separator = " ";
	end
	local regEx = "([^" .. separator .. "]*)" .. separator .. "?";

	for item in string.gfind(toCut .. separator, regEx) do
		i = i + 1;
		splitted[i] = WIM_Trim(item) or '';
	end
	splitted[i] = nil;
	return splitted;
end

function WIM_Trim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end

function WIM_AddIncomingMessage(sender, message)
	local chatframe = WIM_GetTab(sender);
	chatframe:AddMessage("|ceeff1100<" .. sender .. ">|r " .. message);
	PlaySound("TellMessage");
	chatframe.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
	FCF_FlashTab();
end

function WIM_AddOutgoingMessage(receiver, message)
	local chatframe = WIM_GetTab(receiver);
	chatframe:AddMessage("|c0000ffff<" .. UnitName("player") .. ">|r " .. message);
	PlaySound("TellMessage");
	chatframe.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
	FCF_FlashTab();
end

function WIM_GetTab(ch)
	local frame, framtab, tempframe1, tempframe2;
	for i = 1, NUM_CHAT_WINDOWS do
		tempframe1 = getglobal("ChatFrame" .. i);
		tempframe2 = getglobal("ChatFrame" .. i .. "Tab");
		if (tempframe2:GetText() == "WIM:" .. ch) then
			frame = tempframe1;
			frametab = tempframe2;
			break;
		end
	end	
	if (frame ~= nil) then
		if not frametab:IsVisible() then
			frametab:Show();
		end
		FCF_DockFrame(frame);
		return frame;
	else
		FCF_OpenNewWindow("WIM:" .. ch);
		frame = WIM_GetTab(ch); 
		FCF_SetLocked(frame, true, false);
		ChatFrame_RemoveAllMessageGroups(frame);
		return frame;
	end		
end

function WIMReply()
	local frame = SELECTED_DOCK_FRAME;
	local frametab = getglobal(frame:GetName() .. "Tab");
	if (string.sub(frametab:GetText(), 1, 4) ~= "WIM:") then
		local receiver = ChatEdit_GetLastTellTarget(frame.editBox);
		if (strlen(receiver) > 0 ) then 
			frame.editBox.chatType = "WHISPER"; 
        	frame.editBox.tellTarget = receiver; 
        	ChatEdit_UpdateHeader(frame.editBox); 
    		if ( not frame.editBox:IsVisible() ) then 
        		ChatFrame_OpenChat("", frame); 
        	end
        else
        	SELECTED_DOCK_FRAME:AddMessage("WIM tab not selected and no whispers to reply to.");
        end
	else
		local receiver = string.sub(frametab:GetText(), 5);
		frame.editBox.chatType = "WHISPER"; 
        frame.editBox.tellTarget = receiver; 
        ChatEdit_UpdateHeader(frame.editBox); 
    	if ( not frame.editBox:IsVisible() ) then 
        	ChatFrame_OpenChat("", frame); 
        end
	end
end

function WIMSay()
	local frame = SELECTED_DOCK_FRAME;
	local frametab = getglobal(frame:GetName() .. "Tab");
	if (string.sub(frametab:GetText(), 1, 4) ~= "WIM:") then
   		if ( not frame.editBox:IsVisible() ) then 
       		ChatFrame_OpenChat("", frame); 
       	end
	else
		local receiver = string.sub(frametab:GetText(), 5);
		frame.editBox.chatType = "WHISPER"; 
        frame.editBox.tellTarget = receiver; 
        ChatEdit_UpdateHeader(frame.editBox); 
    	if ( not frame.editBox:IsVisible() ) then 
        	ChatFrame_OpenChat("", frame); 
        end
	end
end