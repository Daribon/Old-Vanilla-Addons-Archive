RoadRunner_Events = {
	"CHAT_MSG_SAY",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_RAID",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER"
};

RoadRunner_Sound = true;

RoadRunner_Minimum_Time_Between = 5;

RoadRunner_Last_Played = 0;

RoadRunner_Chat_Sound = "meepmeep.wav";
RoadRunner_Emote_Sound = "rrunner2.wav";

function RoadRunner_OnLoad()
	local name = "ROADRUNNERSLASHTAKEOFF";
	SlashCmdList[name] = RoadRunner_TakeOff;
	for k, v in ROADRUNNER_CMD_TAKEOFF do
		setglobal("SLASH_"..name..k, v);
	end
	name = "ROADRUNNERSLASHMEEPMEEP";
	SlashCmdList[name] = RoadRunner_MeepMeep;
	for k, v in ROADRUNNER_CMD_MEEPMEEP do
		setglobal("SLASH_"..name..k, v);
	end
	
	local f = RoadRunnerFrame;
	for k, v in RoadRunner_Events do
		f:RegisterEvent(v);
	end
end

function RoadRunner_TakeOff()
	--RoadRunner_PlaySound(RoadRunner_Emote_Sound);
	if ( RoadRunner_TakeOff_Msg ) then
		RoadRunner_Last_Played = 0;
		SendChatMessage(RoadRunner_TakeOff_Msg, "EMOTE");
	end
end

function RoadRunner_MeepMeep()
	--RoadRunner_PlaySound(RoadRunner_Chat_Sound);
	if ( RoadRunner_MeepMeep_Msg ) then
		RoadRunner_Last_Played = 0;
		SendChatMessage(RoadRunner_MeepMeep_Msg, "SAY");
	end
end

RoadRunner_Sounds = {};

function RoadRunner_PlaySound(sound)
	if ( not RoadRunner_Sound ) then
		return;
	end
	if ( not sound ) then
		return;
	end
	local snd = RoadRunner_Sounds[sound];
	if ( not snd ) then
		snd = "Interface\\AddOns\\RoadRunner\\"..sound;
		RoadRunner_Sounds[sound] = snd;
	end
	PlaySoundFile(snd);
end

function RoadRunner_OnEvent()
	local curTime = GetTime();
	if ( curTime - RoadRunner_Last_Played < RoadRunner_Minimum_Time_Between ) then
		return;
	end

	local sound = RoadRunner_Chat_Sound;
	local patterns = ROADRUNNER_CHAT_PATTERNS;
	if ( string.find(event, "EMOTE") ) then
		patterns = ROADRUNNER_EMOTE_PATTERNS;
		sound = RoadRunner_Emote_Sound;
	end
	for k, v in patterns do
		if ( string.find(arg1, v) ) then
			RoadRunner_Last_Played = curTime;
			RoadRunner_PlaySound(sound);
			break;
		end
	end
end
