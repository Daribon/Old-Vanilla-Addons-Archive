UnrealSoundPack_Options = {};

UnrealSoundPack_Setup = {
	lastKill = 0;
	kills = 0;
	mustBeInCombat = true;
};

UnrealSoundPack_PlaySoundFile_Table = {};

function UnrealSoundPack_OnLoad()
	local f = this;
	f:RegisterEvent("VARIABLES_LOADED");
	f:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");
	f:RegisterEvent("PLAYER_TARGET_CHANGED");
	local s = string.gsub(UNITDIESOTHER, "%%s", "%(.+%)");
	USP_GSTRING_DIES = s;
end

function UnrealSoundPack_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in UNREALSOUNDPACK_OPTIONS_DEFAULT do
			if ( UnrealSoundPack_Options[k] == nil ) then
				UnrealSoundPack_Options[k] = v;
			end
		end
	elseif ( event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" ) then
		local ok = true;
		if ( ok ) and ( not PlayerFrame.inCombat ) and ( UnrealSoundPack_Options.mustBeInCombat ) then
			ok = false;
		end
		if ( ok ) and ( UnrealSoundPack_Options.mustMatchName ) then
			for name in string.gfind(arg1, USP_GSTRING_DIES) do
				if ( UnrealSoundPack_Setup.lastTargetName == name ) then 
					ok = false;
					break;
				end
			end
		end
		if ( ok ) then
			UnrealSoundPack_AddDeath();
		end
	elseif ( event == "PLAYER_TARGET_CHANGED" ) then
		local target = UnitName("target");
		if ( target ) and ( target ~= "" ) then
			UnrealSoundPack_Setup.lastTargetName = target;
			UnrealSoundPack_Setup.lastTargetPlayer = UnitIsPlayer("target");
		end
	end
end

function UnrealSoundPack_GetRandomSound()
	local totalSum = 0;
	for k, v in USP_RANDOM_KILL do
		totalSum = totalSum + v;
	end
	local n = random(1, totalSum);
	for k, v in USP_RANDOM_KILL do
		n = n - v;
		if ( n <= 0 ) then
			return k;
		end
	end
	return nil;
end

function UnrealSoundPack_Reset()
	UnrealSoundPack_Setup.lastKill = 0;
	UnrealSoundPack_Setup.kills = 0;
end

UnrealSoundPack_ShowMessage_Params = {
	sound = false;
};

function UnrealSoundPack_ShowMessage(msg)
	if ( not UnrealSoundPack_Options.showMessages ) then
		return;
	end
	if ( ActionQueue_ShowMessage ) then
		ActionQueue_ShowMessage(msg, 1, 0.1, 0.1, UnrealSoundPack_ShowMessage_Params );
	else
		UIErrorsFrame:AddMessage(msg, 1, 0.1, 0.1, 1.0, 2);
	end
end


function UnrealSoundPack_AddDeath()
	if ( UnitIsDeadOrGhost("player") ) or ( not UnrealSoundPack_Options.enabled ) then
		UnrealSoundPack_Reset();
		return;
	end
	if ( UnrealSoundPack_Options.onlyPvP ) and ( not UnrealSoundPack_Setup.lastTargetPlayer ) then
		return;
	end
	local curTime = GetTime();
	local timeBetweenKills = UnrealSoundPack_Options.timeBetweenKills;
	local lastTime = UnrealSoundPack_Setup.lastKill;
	if ( timeBetweenKills > 0 ) and ( lastTime == 0 ) or ( curTime-lastTime > timeBetweenKills ) then
		UnrealSoundPack_Setup.kills = 0;
	end
	UnrealSoundPack_Setup.lastKill = curTime;
	local numKills = UnrealSoundPack_Setup.kills + 1;
	UnrealSoundPack_Setup.kills = numKills;
	local timeBetweenSounds = UnrealSoundPack_Options.timeBetweenSounds;
	if ( timeBetweenSounds > 0 ) and ( lastTime > 0 ) and ( curTime-lastTime < timeBetweenSounds ) then
		return;
	end
	if ( numKills == 1 ) then
		UnrealSoundPack_PlaySoundFile(USP_FIRST_KILL);
		UnrealSoundPack_ShowMessage(USP_MESSAGES_KILLS[numKills]);
	elseif ( numKills == 2 ) then
		UnrealSoundPack_PlaySoundFile(USP_SECOND_KILL) 
		UnrealSoundPack_ShowMessage(USP_MESSAGES_KILLS[numKills]);
	elseif ( numKills == 5 ) then
		UnrealSoundPack_PlaySoundFile(USP_FIFTH_KILL) 
		UnrealSoundPack_ShowMessage(USP_MESSAGES_KILLS[numKills]);
	elseif ( numKills == 10 ) then
		UnrealSoundPack_PlaySoundFile(USP_TENTH_KILL) 
		UnrealSoundPack_ShowMessage(USP_MESSAGES_KILLS[numKills]);
	elseif ( numKills == 15 ) then
		UnrealSoundPack_PlaySoundFile(USP_FIFTEENTH_KILL) 
		UnrealSoundPack_ShowMessage(USP_MESSAGES_KILLS[numKills]);
	elseif ( numKills == 20 ) then
		UnrealSoundPack_PlaySoundFile(USP_TWENTIETH_KILL) 
		UnrealSoundPack_ShowMessage(USP_MESSAGES_KILLS[numKills]);
	elseif ( numKills == 25 ) then
		UnrealSoundPack_PlaySoundFile(USP_TWENTYFIFTH_KILL) 
		UnrealSoundPack_ShowMessage(USP_MESSAGES_KILLS[numKills]);
	else 
		local five = numKills / 5;
		if ( ceil(five) == floor(five) ) then
			UnrealSoundPack_PlaySoundFile(USP_BEYONDTHIRTY_KILL);
			UnrealSoundPack_ShowMessage(USP_MESSAGES_KILL_BEYOND_THIRTY);
		else
			local snd = UnrealSoundPack_GetRandomSound();
			UnrealSoundPack_PlaySoundFile(snd);
			UnrealSoundPack_ShowMessage(USP_MESSAGES_RANDOM_KILL[snd]);
		end
	end
end

function UnrealSoundPack_PlaySoundFile(snd)
	if ( not snd ) then return; end
	local file = UnrealSoundPack_PlaySoundFile_Table[snd];
	if ( not file ) then
		file = "Interface\\AddOns\\UnrealSoundPack\\Sounds\\"..snd..".mp3";
		UnrealSoundPack_PlaySoundFile_Table[snd] = file;
	end
	PlaySoundFile(file);
end
