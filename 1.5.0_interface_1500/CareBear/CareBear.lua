CareBearOptions = {};
local gotVariables = false;
local gotPlayerName = false;
local Realm;
local Player;

local function InitializeSetup()
	Player=UnitName("player");
	Realm=GetCVar("realmName");

	if CareBearOptions[Realm] == nil then
		CareBearOptions[Realm] = {}
	end

	if CareBearOptions[Realm][Player] == nil then
		CareBearOptions[Realm][Player] = {}
	end

	if (CareBearOptions[Realm][Player].Level  == nil) then
		CareBearOptions[Realm][Player].Level  = 999;
	end
end

function CareBear_OnLoad()
	this:RegisterEvent("DUEL_REQUESTED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	CareBear_Version = "CareBear v0.4b [1300]";
	SlashCmdList["CareBear"] = CareBear_SlashHandler;
	SLASH_CareBear1 = "/CareBear";
	SLASH_CareBear2 = "/CB";
	-- DEFAULT_CHAT_FRAME:AddMessage(CareBear_Version);
	-- DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_ONLOAD);
end

function CareBear_OnEvent(event)
	if (event == "UNIT_NAME_UPDATE") then
		if ((arg1) and (arg1 == "player")) then
			local playerName = UnitName("player");
			if ((playerName) and (playerName ~= UNKNOWNOBJECT) and (playerName ~= UKNOWNBEING)) then
				InitializeSetup();
			end
		end
	end

	if (event == 'DUEL_REQUESTED') then
		if (CareBearOptions[Realm][Player].Enabled ) then
			if (CareBearOptions[Realm][Player].Level  < 999) then
				TargetByName(arg1);
				ReqLevel = UnitLevel('target');
			else
				ReqLevel=9999;
			end
			if (ReqLevel > UnitLevel('player') + CareBearOptions[Realm][Player].Level ) then
				CancelDuel();
				if (CareBearOptions[Realm][Player].Whisper ) then
					SendChatMessage(CareBearOptions[Realm][Player].Whisper , "WHISPER", DEFAULT_CHAT_FRAME.language, arg1);
				end
				if (CareBearOptions[Realm][Player].Emote ) then
					DoEmote(CareBearOptions[Realm][Player].Emote ,arg1);
				end
			end
			if (CareBearOptions[Realm][Player].Level  < 999) then
				ClearTarget();
			end
		end
	end
end

function CareBear_SlashHandler(msg)

	if (msg == '') then msg = nil end

	if msg then
		local command = tyn_Split(msg, "=")
		local current = string.lower(command[1]);
		if (command[2] == '') then
			command[2] = nil;
		end


		if (current == 'enable') then
			CareBearOptions[Realm][Player].Enabled  = true;
			DEFAULT_CHAT_FRAME:AddMessage(CB_ENABLED);
		end

		if (current == 'disable') then
			CareBearOptions[Realm][Player].Enabled  = false;
			DEFAULT_CHAT_FRAME:AddMessage(CB_DISABLED);
		end

		if (current == 'emote') then
			if (command[2]==nil) then
				CareBearOptions[Realm][Player].Emote  = false;
				DEFAULT_CHAT_FRAME:AddMessage(CB_EMOTE_DISABLED);

			else
				CareBearOptions[Realm][Player].Emote  = command[2];
				DEFAULT_CHAT_FRAME:AddMessage(CB_EMOTE_ENABLED.."("..CareBearOptions[Realm][Player].Emote ..")");
				if (CareBearOptions[Realm][Player].Enabled ==false) then
					CareBearOptions[Realm][Player].Enabled  = true;
					DEFAULT_CHAT_FRAME:AddMessage(CB_ENABLED);
				end
			end
		end

		if (current == 'whisper') then
			if (command[2]==nil) then
				CareBearOptions[Realm][Player].Whisper  = false;
				DEFAULT_CHAT_FRAME:AddMessage(CB_WHISPER_DISABLED);

			else
				CareBearOptions[Realm][Player].Whisper  = command[2];
				DEFAULT_CHAT_FRAME:AddMessage(CB_WHISPER_ENABLED.."("..CareBearOptions[Realm][Player].Whisper ..")");
				if (CareBearOptions[Realm][Player].Enabled ==false) then
					CareBearOptions[Realm][Player].Enabled  = true;
					DEFAULT_CHAT_FRAME:AddMessage(CB_ENABLED);
				end
			end
		end

		if (current == 'level') then
			if (tonumber(command[2])==nil) then
				CareBearOptions[Realm][Player].Level  = 999;
				DEFAULT_CHAT_FRAME:AddMessage(CB_LEVEL_DISABLED);

			else
				CareBearOptions[Realm][Player].Level  = tonumber(command[2]);
				DEFAULT_CHAT_FRAME:AddMessage(CB_LEVEL_ENABLED.."(+"..CareBearOptions[Realm][Player].Level ..")");
				if (CareBearOptions[Realm][Player].Enabled == false) then
					CareBearOptions[Realm][Player].Enabled  = true;
					DEFAULT_CHAT_FRAME:AddMessage(CB_ENABLED);
				end
			end
		end

		if (current == 'status') then
			CareBear_ShowStatus();
		end

		if (current == 'help') then
			DEFAULT_CHAT_FRAME:AddMessage(CareBear_Version);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE1);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE2);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE3);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE4);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE5);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE6);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE7);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE8);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE9);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE10);
			DEFAULT_CHAT_FRAME:AddMessage(CB_HELP_LINE11);
		end

	else
		DEFAULT_CHAT_FRAME:AddMessage(CareBear_Version);
		CareBear_ShowStatus();
		DEFAULT_CHAT_FRAME:AddMessage(CB_VALID_PARAMETERS);
	end
end



function CareBear_ShowStatus()
	if (CareBearOptions[Realm][Player].Enabled ) then
		DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_REFUSAL_ON);
		if (CareBearOptions[Realm][Player].Emote ) then
			DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_EMOTE_ON.." ("..CareBearOptions[Realm][Player].Emote ..")");
		else
			DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_EMOTE_OFF);
		end
		if (CareBearOptions[Realm][Player].Whisper ) then
			DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_WHISPER_ON.." ("..CareBearOptions[Realm][Player].Whisper ..")");
		else
			DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_WHISPER_OFF);
		end
		if (CareBearOptions[Realm][Player].Level  < 999) then
			DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_LEVEL_ON.." (+"..CareBearOptions[Realm][Player].Level ..")");
		else
			DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_LEVEL_OFF);
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(CB_STATUS_REFUSAL_OFF);
	end
end

function tyn_Split(toCut, separator)
	local splitted = {};
	local i = 0;
	local regEx = "([^" .. separator .. "]*)" .. separator .. "?";

	for item in string.gfind(toCut .. separator, regEx) do
		i = i + 1;
		splitted[i] = tyn_Trim(item) or '';
	end
	splitted[i] = nil;
	return splitted;
end

function tyn_Trim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end
