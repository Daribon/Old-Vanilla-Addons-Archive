---- LSTracker -- made by Znagge ----------

-- Patched by sarf 2005-04-26

LSTRACKER_LIGHTNING_SHIELD_BUFF_ICON = "Spell_Nature_LightningShield"

LSTracker_Options = {
	showExactBuffTime = true; -- set to false if you want to see times in "8 m" instead of "8:39"
};



-------------------------------------------
LSTracker_max_balls = 3;


LSTracker_num_balls = max_balls;
LSTracker_lastBuff = 0;

function LSTracker_IsShaman()
	if ( UnitClass("player") == LSTRACKER_CLASS_SHAMAN ) then
		return true;
	else
		return false;
	end
end

function LSTracker_OnLoad()
	if ( LSTracker_IsShaman() ) then
		this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
		this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
		this:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
	end
end

function LSTracker_ShowExactBuffDuration()
	if ( LSTracker_Options ) and ( LSTracker_Options.showExactBuffTime ) then
		return true;
	else
		return false;
	end
end

function LSTracker_HandleEvent(event, msg)
	if(event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
		for something in string.gfind(arg1, LSTRACKER_PATTERN_LIGHTNING_SHIELD_HIT) do --fire of a ball
		
		if(LSTracker_num_balls>=1) then
			LSTracker_num_balls = LSTracker_num_balls-1;
		end
	end
	
	elseif (event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS") then --gain shield
	
		if( msg == LSTRACKER_PATTERN_GAIN_LIGHTNING_SHIELD) then
			LSTracker_num_balls = LSTracker_max_balls;
		end
	
	elseif (event == "CHAT_MSG_SPELL_AURA_GONE_SELF") then --lose shield
	
		if(msg == LSTRACKER_PATTERN_LOSE_LIGHTNING_SHIELD) then
			LSTracker_num_balls = 0;
			LSTracker_lastBuff = 0;
		end
	
	end
	
end

function LSTracker_OnEvent()
	if ( LSTracker_IsShaman() ) then
		LSTracker_HandleEvent(event, arg1);
	end --else dont bother
end

function BuffFrame_UpdateDuration(buffButton, timeLeft)
	local duration = getglobal(buffButton:GetName().."Duration");
	local LSCounter = "";
	if ( SHOW_BUFF_DURATIONS == "1" and timeLeft ) then
		local s = timeLeft;
		local minutes = floor(s/60); s = mod(s, 60);
		local seconds = floor(s);
		if(seconds<=9) then
			seconds = "0"..seconds;
		end

		if ( LSTracker_IsShaman() ) then
			local buffIndex = this.buffIndex;	
			if ( buffIndex~=nil and LSTracker_num_balls ~= nil ) then
				local icon_name = GetPlayerBuffTexture(buffIndex);
			
				for whatever in string.gfind(icon_name, LSTRACKER_LIGHTNING_SHIELD_BUFF_ICON) do -- we found our lightningshield
	
					if ( LSTracker_lastBuff < timeLeft) then --hey, we got ourself a new buff that doesnt show in GAIN_AURA
						LSTracker_num_balls = LSTracker_max_balls;
					end
					LSTracker_lastBuff = timeLeft;
	
					LSCounter = "\n"..WHITE_FONT_COLOR_CODE..LSTracker_num_balls..FONT_COLOR_CODE_CLOSE; --color it white
				end
			end
		end --else dont bother

		if( LSTracker_ShowExactBuffDuration() ) then
			duration:SetText(minutes..":"..seconds..LSCounter); -- makes it display MM:SS instead of just minutes
		else
			duration:SetText(SecondsToTimeAbbrev(timeLeft)..LSCounter);
		end

		if ( timeLeft < BUFF_DURATION_WARNING_TIME ) then
			duration:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		else
			duration:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end
		duration:Show();
	else
		duration:Hide();
	end
end
