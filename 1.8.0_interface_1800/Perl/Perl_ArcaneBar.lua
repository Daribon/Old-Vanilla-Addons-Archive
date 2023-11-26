--[[
	ArcaneBar
	 	Adds a second casting bar to the player frame.
	
	By: Zlixar
	
	Adds a second casting bar to the player frame.
	
	Modified by Nymbia for Nymbia's Perl Unitframes
]]--
--------------------------------------------------
--
-- Configuration Functions
--
--------------------------------------------------
--[[ 
	Registers "frame" (passed as a string) to spellcast events.
]]
function Perl_ArcaneBar_Register(frame)
	getglobal(frame):RegisterEvent("SPELLCAST_START");
	getglobal(frame):RegisterEvent("SPELLCAST_STOP");
	getglobal(frame):RegisterEvent("SPELLCAST_FAILED");
	getglobal(frame):RegisterEvent("SPELLCAST_INTERRUPTED");
	getglobal(frame):RegisterEvent("SPELLCAST_DELAYED");
	getglobal(frame):RegisterEvent("SPELLCAST_CHANNEL_START");
	getglobal(frame):RegisterEvent("SPELLCAST_CHANNEL_UPDATE");

end
--[[ 
	Unregisters "frame" (passed as a string) from spellcast events.
]]
function Perl_ArcaneBar_Unregister(frame)
	getglobal(frame):UnregisterEvent("SPELLCAST_START");
	getglobal(frame):UnregisterEvent("SPELLCAST_STOP");
	getglobal(frame):UnregisterEvent("SPELLCAST_FAILED");
	getglobal(frame):UnregisterEvent("SPELLCAST_INTERRUPTED");
	getglobal(frame):UnregisterEvent("SPELLCAST_DELAYED");
	getglobal(frame):UnregisterEvent("SPELLCAST_CHANNEL_START");
	getglobal(frame):UnregisterEvent("SPELLCAST_CHANNEL_UPDATE");
end

function Perl_ArcaneBar_EnableToggle(value)
	if (value == 1) then
		if (Perl_ArcaneBarFrame.Enabled == 1) then
			--Do nothing
		else
			Perl_ArcaneBar_Register("Perl_ArcaneBarFrame");
			Perl_ArcaneBarFrame.Enabled = 1;
		end
	else
		if (Perl_ArcaneBarFrame.Enabled == 1) then
			Perl_ArcaneBar_Unregister("Perl_ArcaneBarFrame");
			Perl_ArcaneBarFrame.Enabled = 0;
		end
	end

end

function Perl_ArcaneBar_OverrideToggle(value)
	if (value == 1) then
		if (Perl_ArcaneBarFrame.Overrided == 1) then
			--Do nothing
		else
			Perl_ArcaneBar_Unregister("CastingBarFrame");
			Perl_ArcaneBarFrame.Overrided = 1;
		end
	else
		if (Perl_ArcaneBarFrame.Overrided == 1) then
			Perl_ArcaneBar_Register("CastingBarFrame");
			Perl_ArcaneBarFrame.Overrided = 0;			
		end
	end
end




--------------------------------------------------
--
-- Event/Update Handlers
--
--------------------------------------------------
function Perl_ArcaneBar_OnEvent()
	if ( event == "SPELLCAST_START" ) then
		Perl_ArcaneBar:SetStatusBarColor(Perl_ArcaneBar_Colors["MAINR"], Perl_ArcaneBar_Colors["MAING"], Perl_ArcaneBar_Colors["MAINB"], Perl_Config.Transparency);
		Perl_ArcaneBarSpark:Show();
		this.startTime = GetTime();
		this.maxValue = this.startTime + (arg2 / 1000);
		Perl_ArcaneBar:SetMinMaxValues(this.startTime, this.maxValue);
		Perl_ArcaneBar:SetValue(this.startTime);
		this:SetAlpha(0.8);
		this.holdTime = 0;
		this.casting = 1;
		this.fadeOut = nil;
		this:Show();
		this.delaySum = 0;
		if Perl_Config.CastTime==1 then Perl_ArcaneBar_CastTime:Show(); else Perl_ArcaneBar_CastTime:Hide(); end
		this.mode = "casting";
	elseif ( event == "SPELLCAST_STOP" ) then
		this.delaySum = 0;
		this.sign = "+";
		if (not this.casting) then
			Perl_ArcaneBar_CastTime:Hide();
		end
		if ( not this:IsVisible() ) then
			this:Hide();
		end
		if ( this:IsShown() ) then
			Perl_ArcaneBar:SetValue(this.maxValue);
			Perl_ArcaneBar:SetStatusBarColor(Perl_ArcaneBar_Colors["SUCCESSR"], Perl_ArcaneBar_Colors["SUCCESSG"], Perl_ArcaneBar_Colors["SUCCESSB"], Perl_Config.Transparency);
			Perl_ArcaneBarSpark:Hide();
			Perl_ArcaneBarFlash:SetAlpha(0.0);
			Perl_ArcaneBarFlash:Show();
			this.casting = nil;
			this.flash = 1;
			this.fadeOut = 1;

			this.mode = "flash";
		end
	elseif ( event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" ) then
		if ( this:IsShown() ) then
			Perl_ArcaneBar:SetValue(this.maxValue);
			Perl_ArcaneBar:SetStatusBarColor(Perl_ArcaneBar_Colors["FAILURER"], Perl_ArcaneBar_Colors["FAILUREG"], Perl_ArcaneBar_Colors["FAILUREB"], Perl_Config.Transparency);
			Perl_ArcaneBarSpark:Hide();
			this.casting = nil;
			this.fadeOut = 1;
			this.holdTime = GetTime() + CASTING_BAR_HOLD_TIME;
		end
	elseif ( event == "SPELLCAST_DELAYED" ) then
		if( this:IsShown() ) then
			if arg1 then
				this.startTime = this.startTime + (arg1 / 1000);
				this.maxValue = this.maxValue + (arg1 / 1000);
				this.delaySum = this.delaySum + arg1;
				Perl_ArcaneBar:SetMinMaxValues(this.startTime, this.maxValue);
			end
		end
	elseif ( event == "SPELLCAST_CHANNEL_START" ) then
		Perl_ArcaneBar:SetStatusBarColor(Perl_ArcaneBar_Colors["CHANNELR"], Perl_ArcaneBar_Colors["CHANNELG"], Perl_ArcaneBar_Colors["CHANNELB"], Perl_Config.Transparency);
		Perl_ArcaneBarSpark:Show();
		this.maxValue = 1;
		this.startTime = GetTime();
		this.endTime = this.startTime + (arg1 / 1000);
		this.duration = arg1 / 1000;
		Perl_ArcaneBar:SetMinMaxValues(this.startTime, this.endTime);
		Perl_ArcaneBar:SetValue(this.endTime);
		this:SetAlpha(1.0);
		this.holdTime = 0;
		this.casting = nil;
		this.channeling = 1;
		this.fadeOut = nil;
		this:Show();
		this.delaySum = 0;
		if Perl_Config.CastTime==1 then Perl_ArcaneBar_CastTime:Show(); else Perl_ArcaneBar_CastTime:Hide(); end
	elseif ( event == "VARIABLES_LOADED" ) then
		if (not Perl_ArcaneBar_Colors) then
			Perl_ArcaneBar_Colors = {
			["MAINR"] = 1.0,
			["MAING"] = 0.7,
			["MAINB"] = 0.0,
			["CHANNELR"] = 0.0,
			["CHANNELG"] = 1.0,
			["CHANNELB"] = 0.0,
			["SUCCESSR"] = 0.0,
			["SUCCESSG"] = 1.0,
			["SUCCESSB"] = 0.0,
			["FAILURER"] = 1.0,
			["FAILUREG"] = 0.0,
			["FAILUREB"] = 0.0		
			}

		end
	elseif ( event == "SPELLCAST_CHANNEL_UPDATE" ) then
		if ( arg1 == 0 ) then
			this.channeling = nil;
			this.delaySum = 0;
			Perl_ArcaneBar_CastTime:Hide();
		elseif ( this:IsShown() ) then
			local origDuration = this.endTime - this.startTime
			local elapsedTime = GetTime() - this.startTime;
			local losttime = origDuration*1000 - elapsedTime*1000 - arg1;
			this.delaySum = this.delaySum + losttime;
			this.startTime = this.endTime - origDuration;
			this.endTime = GetTime() + (arg1 / 1000);
			Perl_ArcaneBar:SetMinMaxValues(this.startTime, this.endTime);
			
		end
	else
		this.delaySum = 0;
		this.sign = "+";
		Perl_ArcaneBar_CastTime:Hide();
	end
end
function Perl_ArcaneBar_OnUpdate()
	if (not Perl_ArcaneBar:IsShown()) then
		Perl_ArcaneBar_CastTime:Hide();
	end
	local current_time = this.maxValue - GetTime();
	if (this.channeling) then
		current_time = this.endTime - GetTime();
	end
	
	
	local text = string.sub(math.max(current_time,0)+0.001,1,4);
	if (this.delaySum ~= 0) then
		local delay = string.sub(math.max(this.delaySum/1000, 0)+0.001,1,4);

		if (this.channeling == 1) then
			this.sign = "-";
		else
			this.sign = "+";
		end
		text = "|cffcc0000"..this.sign..delay.."|r "..text;
	end
	Perl_ArcaneBar_CastTime:SetText(text);
	
	
	if ( this.casting ) then
		local status = GetTime();
		if ( status > this.maxValue ) then
			status = this.maxValue
		end
		Perl_ArcaneBar:SetValue(status);
		Perl_ArcaneBarFlash:Hide();
		local sparkPosition = ((status - this.startTime) / (this.maxValue - this.startTime)) * 154;
		if ( sparkPosition < 0 ) then
			sparkPosition = 0;
		end
		Perl_ArcaneBarSpark:SetPoint("CENTER", "Perl_ArcaneBar", "LEFT", sparkPosition, 0);
	elseif ( this.channeling ) then
		local time = GetTime();
		if ( time > this.endTime ) then
			time = this.endTime
		end
		if ( time == this.endTime ) then
			this.channeling = nil;
			this.fadeOut = 1;
			return;
		end
		local barValue = this.startTime + (this.endTime - time);
		Perl_ArcaneBar:SetValue( barValue );
		Perl_ArcaneBarFlash:Hide();
		local sparkPosition = ((barValue - this.startTime) / (this.endTime - this.startTime)) * 154;
		Perl_ArcaneBarSpark:SetPoint("CENTER", "Perl_ArcaneBar", "LEFT", sparkPosition, 0);
	elseif ( GetTime() < this.holdTime ) then
		return;
	elseif ( this.flash ) then
		local alpha = Perl_ArcaneBarFlash:GetAlpha() + CASTING_BAR_FLASH_STEP;
		if ( alpha < 1 ) then
			Perl_ArcaneBarFlash:SetAlpha(alpha);
		else
			this.flash = nil;
		end
	elseif ( this.fadeOut ) then
		local alpha = this:GetAlpha() - CASTING_BAR_ALPHA_STEP;
		if ( alpha > 0 ) then
			this:SetAlpha(alpha);
		else
			this.fadeOut = nil;
			this:Hide();
		end
	end
end
function Perl_ArcaneBar_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	Perl_ArcaneBar:SetFrameLevel(Perl_Player_NameFrame:GetFrameLevel() + 1);
	Perl_Player_Name:SetFrameLevel(Perl_Player_NameFrame:GetFrameLevel() + 2);
	Perl_ArcaneBarFlashTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_ArcaneBarFlash");
	Perl_ArcaneBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	this.casting = nil;
	this.holdTime = 0;
	this.Enabled = 0;
	this.Overrided = 0;
end