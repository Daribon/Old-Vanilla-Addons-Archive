--[[
	ArcaneBar
	 	Adds a second casting bar to the player frame.
	
	By: Zlixar
	
	Adds a second casting bar to the player frame.
	
	$Id: ArcaneBar.lua 2438 2005-09-14 04:20:49Z karlkfi $
	$Rev: 2438 $
	$LastChangedBy: karlkfi $
	$Date: 2005-09-13 23:20:49 -0500 (Tue, 13 Sep 2005) $
]]--

--------------------------------------------------
--
-- Globals
--
--------------------------------------------------
ArcaneBar_DefaultColors = {
	["MAIN"] = {
		r=1.0;
		g=0.7;
		b=0.0;		
	};
	["CHANNEL"] = {
		r=0.0;
		g=1.0;
		b=0.0;
	};
	["SUCCESS"] = {
		r=0.0;
		g=1.0;
		b=0.0;
	};
	["FAILURE"] = {
		r=1.0;
		g=0.0;
		b=0.0;
	};	
};

--------------------------------------------------
--
-- Configuration Functions
--
--------------------------------------------------
--[[ 
	Registers "frame" (passed as a string) to spellcast events.
]]--
function ArcaneBar_Register(frame)
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
]]--
function ArcaneBar_Unregister(frame)
	getglobal(frame):UnregisterEvent("SPELLCAST_START");
	getglobal(frame):UnregisterEvent("SPELLCAST_STOP");
	getglobal(frame):UnregisterEvent("SPELLCAST_FAILED");
	getglobal(frame):UnregisterEvent("SPELLCAST_INTERRUPTED");
	getglobal(frame):UnregisterEvent("SPELLCAST_DELAYED");
	getglobal(frame):UnregisterEvent("SPELLCAST_CHANNEL_START");
	getglobal(frame):UnregisterEvent("SPELLCAST_CHANNEL_UPDATE");
end
--[[ 
	The cancel function assigned to ColorPicker for this script.

	### ALL OF THESE BELOW ARE USELESS IF THE USER
	### IS NOT USING COSMOS ANYMORE
]]--
function ArcaneBar_NilFunc(u,b,c)
	CosmosMasterFrame:Show();
end
function ArcaneBar_MainColorSetButton()
	ColorPickerFrame.func = ArcaneBar_MainColorSet;
	ColorPickerFrame.cancelFunc = ArcaneBar_NilFunc;
	ColorPickerFrame.hasOpacity = false;
	ColorPickerFrame:SetColorRGB(ArcaneBar_Colors["MAIN"].r, ArcaneBar_Colors["MAIN"].g, ArcaneBar_Colors["MAIN"].b);
	ColorPickerFrame.previousValues = {r = ArcaneBar_Colors["MAIN"].r, g = ArcaneBar_Colors["MAIN"].g, b = ArcaneBar_Colors["MAIN"].b, opacity = 1};
	CosmosMasterFrame:Hide();
	ColorPickerFrame:Show();
end
function ArcaneBar_MainColorResetButton()
	if ( not ArcaneBar_Colors["MAIN"] ) then ArcaneBar_Colors["MAIN"] = {}; end
	ArcaneBar_Colors["MAIN"] = ArcaneBar_DefaultColors["MAIN"];
	DEFAULT_CHAT_FRAME:AddMessage("ArcaneBar: Main Color Reset.", .8, 1.0, .8);
end
function ArcaneBar_ChannelColorSetButton()
	ColorPickerFrame.func = ArcaneBar_ChannelColorSet;
	ColorPickerFrame.cancelFunc = ArcaneBar_NilFunc;
	ColorPickerFrame.hasOpacity = false;
	ColorPickerFrame:SetColorRGB(ArcaneBar_Colors["CHANNEL"].r, ArcaneBar_Colors["CHANNEL"].g, ArcaneBar_Colors["CHANNEL"].b);
	ColorPickerFrame.previousValues = {r = ArcaneBar_Colors["CHANNEL"].r, g = ArcaneBar_Colors["CHANNEL"].g, b = ArcaneBar_Colors["CHANNEL"].b, opacity = 1};
	CosmosMasterFrame:Hide();
	ColorPickerFrame:Show();
end
function ArcaneBar_ChannelColorResetButton()
	if ( not ArcaneBar_Colors["CHANNEL"] ) then ArcaneBar_Colors["CHANNEL"] = {}; end
	ArcaneBar_Colors["CHANNEL"] = ArcaneBar_DefaultColors["CHANNEL"];
	DEFAULT_CHAT_FRAME:AddMessage("ArcaneBar: Channel Color Reset.", .8, 1.0, .8);
end
function ArcaneBar_SuccessColorSetButton()
	ColorPickerFrame.func = ArcaneBar_SuccessColorSet;
	ColorPickerFrame.cancelFunc = ArcaneBar_NilFunc;
	ColorPickerFrame.hasOpacity = false;
	ColorPickerFrame:SetColorRGB(ArcaneBar_Colors["SUCCESS"].r, ArcaneBar_Colors["SUCCESS"].g, ArcaneBar_Colors["SUCCESS"].b);
	ColorPickerFrame.previousValues = {r = ArcaneBar_Colors["SUCCESS"].r, g = ArcaneBar_Colors["SUCCESS"].g, b = ArcaneBar_Colors["SUCCESS"].b, opacity = 1};
	CosmosMasterFrame:Hide();
	ColorPickerFrame:Show();
end
function ArcaneBar_SuccessColorResetButton()
	if ( not ArcaneBar_Colors["SUCCESS"] ) then ArcaneBar_Colors["SUCCESS"] = {}; end
	ArcaneBar_Colors["SUCCESS"] = ArcaneBar_DefaultColors["SUCCESS"];
	DEFAULT_CHAT_FRAME:AddMessage("ArcaneBar: Success Color Reset.", .8, 1.0, .8);
end
function ArcaneBar_FailureColorSetButton()
	ColorPickerFrame.func = ArcaneBar_FailureColorSet;
	ColorPickerFrame.cancelFunc = ArcaneBar_NilFunc;
	ColorPickerFrame.hasOpacity = false;
	ColorPickerFrame:SetColorRGB(ArcaneBar_Colors["FAILURE"].r, ArcaneBar_Colors["FAILURE"].g, ArcaneBar_Colors["FAILURE"].b);
	ColorPickerFrame.previousValues = {r = ArcaneBar_Colors["FAILURE"].r, g = ArcaneBar_Colors["FAILURE"].g, b = ArcaneBar_Colors["FAILURE"].b, opacity = 1};
	CosmosMasterFrame:Hide();
	ColorPickerFrame:Show();
end
function ArcaneBar_FailureColorResetButton()
	if ( not ArcaneBar_Colors["FAILURE"] ) then ArcaneBar_Colors["FAILURE"] = {}; end
	ArcaneBar_Colors["FAILURE"] = ArcaneBar_DefaultColors["FAILURE"];
	DEFAULT_CHAT_FRAME:AddMessage("ArcaneBar: Failure Color Reset.", .8, 1.0, .8);
end
function ArcaneBar_MainColorSet()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	ArcaneBar_Colors["MAIN"].r = r;
	ArcaneBar_Colors["MAIN"].g = g;
	ArcaneBar_Colors["MAIN"].b = b;
	if(not ColorPickerFrame:IsVisible()) then
		CosmosMasterFrame:Show();
	end
end
function ArcaneBar_ChannelColorSet()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	ArcaneBar_Colors["CHANNEL"].r = r;
	ArcaneBar_Colors["CHANNEL"].g = g;
	ArcaneBar_Colors["CHANNEL"].b = b;
	if(not ColorPickerFrame:IsVisible()) then
		CosmosMasterFrame:Show();
	end
end
function ArcaneBar_SuccessColorSet()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	ArcaneBar_Colors["SUCCESS"].r = r;
	ArcaneBar_Colors["SUCCESS"].g = g;
	ArcaneBar_Colors["SUCCESS"].b = b;
	if(not ColorPickerFrame:IsVisible()) then
		CosmosMasterFrame:Show();
	end
end
function ArcaneBar_FailureColorSet()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	ArcaneBar_Colors["FAILURE"].r = r;
	ArcaneBar_Colors["FAILURE"].g = g;
	ArcaneBar_Colors["FAILURE"].b = b;
	if(not ColorPickerFrame:IsVisible()) then
		CosmosMasterFrame:Show();
	end
end

-- [[ ### END COSMOS COMPAT FUNCTIONS ]]--
function ArcaneBar_EnableToggle(value)
	if (value == 1) then
		if (ArcaneBarFrame.Enabled == 1) then
			--Do nothing
		else
			ArcaneBar_Register("ArcaneBarFrame");
			ArcaneBarFrame.Enabled = 1;
			ArcaneBar_Enabled = true;
		end
	else
		if (ArcaneBarFrame.Enabled == 1) then
			ArcaneBar_Unregister("ArcaneBarFrame");
			ArcaneBarFrame.Enabled = 0;
			ArcaneBar_Enabled = nil;
		else
			--Do nothing
		end
	end

end

function ArcaneBar_OverrideToggle(value)
	if (value == 1) then
		if (ArcaneBarFrame.Overrided == 1) then
			--Do nothing
		else
			ArcaneBar_Unregister("CastingBarFrame");
			ArcaneBarFrame.Overrided = 1;
			ArcaneBar_Override = true;
			
--[[
			CastTimeFrame:UnregisterEvent("SPELLCAST_START");
			CastTimeFrame:UnregisterEvent("SPELLCAST_STOP");
			CastTimeFrame:UnregisterEvent("SPELLCAST_FAILED");
			CastTimeFrame:UnregisterEvent("SPELLCAST_INTERRUPTED");
]]--
		end
	else
		if (ArcaneBarFrame.Overrided == 1) then
			ArcaneBar_Register("CastingBarFrame");
			ArcaneBarFrame.Overrided = 0;
			ArcaneBar_Override = nil;
--[[
			CastTimeFrame:RegisterEvent("SPELLCAST_START");
			CastTimeFrame:RegisterEvent("SPELLCAST_STOP");
			CastTimeFrame:RegisterEvent("SPELLCAST_FAILED");
			CastTimeFrame:RegisterEvent("SPELLCAST_INTERRUPTED");
]]--
		else
			--Do nothing
		end
	end

end
--------------------------------------------------
--
-- Event/Update Handlers
--
--------------------------------------------------
function ArcaneBar_OnEvent()
	if ( event == "SPELLCAST_START" ) then
		ArcaneBar:SetStatusBarColor(ArcaneBar_Colors["MAIN"].r, ArcaneBar_Colors["MAIN"].g, ArcaneBar_Colors["MAIN"].b);
		ArcaneBarSpark:Show();
		this.startTime = GetTime();
		this.maxValue = this.startTime + (arg2 / 1000);
		ArcaneBar:SetMinMaxValues(this.startTime, this.maxValue);
		ArcaneBar:SetValue(this.startTime);
		this:SetAlpha(1.0);
		this.holdTime = 0;
		this.casting = 1;
		this.fadeOut = nil;
		this:Show();

		this.mode = "casting";
	elseif ( event == "SPELLCAST_STOP" ) then
		if (not this.channeling) then
			if ( not this:IsVisible() ) then
				this:Hide();
			end
			if ( this:IsShown() ) then
				ArcaneBar:SetValue(this.maxValue);
				ArcaneBar:SetStatusBarColor(ArcaneBar_Colors["SUCCESS"].r, ArcaneBar_Colors["SUCCESS"].g, ArcaneBar_Colors["SUCCESS"].b);
				ArcaneBarSpark:Hide();
				ArcaneBarFlash:SetAlpha(0.0);
				ArcaneBarFlash:Show();
				this.casting = nil;
				this.flash = 1;
				this.fadeOut = 1;
	
				this.mode = "flash";
			end
		end
	elseif ( event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" ) then
		if ( this:IsShown() ) then
			ArcaneBar:SetValue(this.maxValue);
			ArcaneBar:SetStatusBarColor(ArcaneBar_Colors["FAILURE"].r, ArcaneBar_Colors["FAILURE"].g, ArcaneBar_Colors["FAILURE"].b);
			ArcaneBarSpark:Hide();
			this.casting = nil;
			this.fadeOut = 1;
			this.holdTime = GetTime() + CASTING_BAR_HOLD_TIME;
		end
	elseif ( event == "SPELLCAST_DELAYED" ) then
		if( this:IsShown() ) then
			this.startTime = this.startTime + (arg1 / 1000);
			this.maxValue = this.maxValue + (arg1 / 1000);
			ArcaneBar:SetMinMaxValues(this.startTime, this.maxValue);
		end
	elseif ( event == "SPELLCAST_CHANNEL_START" ) then
		ArcaneBar:SetStatusBarColor(ArcaneBar_Colors["CHANNEL"].r, ArcaneBar_Colors["CHANNEL"].g, ArcaneBar_Colors["CHANNEL"].b);
		ArcaneBarSpark:Hide();
		this.maxValue = 1;
		this.startTime = GetTime();
		this.endTime = this.startTime + (arg1 / 1000);
		this.duration = arg1 / 1000;
		ArcaneBar:SetMinMaxValues(this.startTime, this.endTime);
		ArcaneBar:SetValue(this.endTime);
		this:SetAlpha(1.0);
		this.holdTime = 0;
		this.casting = nil;
		this.channeling = 1;
		this.fadeOut = nil;
		this:Show();
	elseif ( event == "VARIABLES_LOADED" ) then
		if (not ArcaneBar_Colors) then
			ArcaneBar_Colors = {
				["MAIN"] = {
					r=1.0,
					g=0.7,
					b=0.0
				};
				["CHANNEL"] = {
					r=0.0,
					g=1.0,
					b=0.0
				};
				["SUCCESS"] = {
					r=0.0,
					g=1.0,
					b=0.0
				};
				["FAILURE"] = {
					r=1.0,
					g=0.0,
					b=0.0		
				};
			}
		-- I'm nice and converting colors for the old format users
		elseif ( ArcaneBar_Colors["MAINR"] ) then 
			ArcaneBar_Colors = {
				["MAIN"] = {
					r=ArcaneBar_Colors["MAINR"],
					g=ArcaneBar_Colors["MAING"],
					b=ArcaneBar_Colors["MAINB"]
				};
				["CHANNEL"] = {
					r=ArcaneBar_Colors["CHANNELR"],
					g=ArcaneBar_Colors["CHANNELG"],
					b=ArcaneBar_Colors["CHANNELB"]
				};
				["SUCCESS"] = {
					r=ArcaneBar_Colors["SUCCESSR"],
					g=ArcaneBar_Colors["SUCCESSG"],
					b=ArcaneBar_Colors["SUCCESSB"]
				};
				["FAILURE"] = {
					r=ArcaneBar_Colors["FAILURER"],
					g=ArcaneBar_Colors["FAILUREG"],
					b=ArcaneBar_Colors["FAILUREB"]
				};
			}
		end

		if ( Khaos ) then 
			local optionSet = {};
			local commandSet = {};
			local configurationSet = {
				id="ArcaneBar";
				text=ARCANE_SECTION_TEXT;
				helptext=ARCANE_SECTION_TIP;
				difficulty=2;
				options=optionSet;
				commands=commandSet;
				default=false;
				callback=function(enabled)
					if ( enabled ) then
						 ArcaneBar_EnableToggle(1);
					else
						 ArcaneBar_EnableToggle(0);
					end
				end;
			};

			-- Register Basics
			table.insert(
				optionSet,
				{
					id="Header";
					text=ARCANE_HEADER_TEXT;
					helptext=ARCANE_HEADER_TIP;
					difficulty=1;
					type=K_HEADER;
				}
			);
			table.insert(
				optionSet,
				{
					id="Message";
					text=ARCANEBAR_ACTIVE;
					helptext=ARCANEBAR_ACTIVE_TIP;
					type=K_TEXT;
					difficulty=1;
				}
			);
			table.insert(
				optionSet,
				{
					id="RemoveCastingBar";
					text=ARCANE_OVERRIDE_TEXT;
					helptext=ARCANE_OVERRIDE_TIP;
					difficulty=1;
					callback=function(state)
						if ( state.checked ) then
							ArcaneBar_OverrideToggle(1);
						else
							ArcaneBar_OverrideToggle(0);
						end
					end;
					feedback=function(state)
						if ( state.checked ) then
							return "Casting bar will be hidden.";
						else
							return "Casting bar will be shown.";
						end
					end;
					check=true;
					type=K_TEXT;
					setup= {						
					};
					default={
						checked=false;
					};
					disabled={
						disabled=false;
					};					
				}
			);

			-- Register for each type			
			local types = {"MAIN","CHANNEL","SUCCESS","FAILURE"};
			for i=1,4 do 
				local typeString = types[i];
				local niceType = Sea.string.capitalizeWords(types[i]);
				local colorChangeFeedback = function(state)
					return string.format(ARCANEBAR_COLOR_CHANGED, Sea.string.colorToString(state.color), niceType );
				end;
				local colorResetFeedback = function(state)
					return string.format(ARCANEBAR_COLOR_RESET, Sea.string.colorToString(state.color), niceType );
				end;
				table.insert(
					optionSet,
					{
						id=niceType.."ColorSetter";
						text=getglobal("ARCANEBAR_"..typeString.."COLOR_SET");
						helptext=getglobal("ARCANEBAR_"..typeString.."COLOR_SET_TIP");
						difficulty=3;
						callback=function(state)
							if (ArcaneBar_Resetting[typeString] == true) then
								state.color = ArcaneBar_DefaultColors[typeString];
								ArcaneBar_Resetting[typeString] = false;
							end
							ArcaneBar_Colors[typeString] = state.color;
						end;
						feedback=colorChangeFeedback;
						type=K_COLORPICKER;
						setup= {
							hasOpacity=false;
						};
						default={
							color=ArcaneBar_DefaultColors[typeString];
						};
						disabled={
							color=ArcaneBar_DefaultColors[typeString];
						};					
					}
				);
				table.insert(
					optionSet,
					{
						id=niceType.."Reset";
						text=getglobal("ARCANEBAR_"..typeString.."COLOR_RESET");
						helptext=getglobal("ARCANEBAR_"..typeString.."COLOR_RESET_TIP");
						difficulty=3;
						callback=function(state)
							ArcaneBar_Resetting[typeString] = true;
							-- The khaos config's color has to be reset too or else it will just get refreshed
							-- with its state and override any values of ArcaneBar_Colors we change here.
						end;
						feedback=colorResetFeedback;
						type=K_BUTTON;
						setup = {
							buttonText=ARCANEBAR_RESETTEXT;
						};
					}
				);
			end
			Khaos.registerOptionSet(
				"combat",
				configurationSet
			);			
		elseif ( Cosmos_RegisterConfiguration ) then 
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR",
				"SECTION",
				ARCANE_SECTION_TEXT,
				ARCANE_SECTION_TIP
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_HEADER",
				"SEPARATOR",
				ARCANE_HEADER_TEXT,
				ARCANE_HEADER_TIP
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_ENABLE",
				"CHECKBOX",
				ARCANE_ENABLE_TEXT,
				ARCANE_ENABLE_TIP,
				ArcaneBar_EnableToggle,
				1
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_NOCAST",
				"CHECKBOX",
				ARCANE_OVERRIDE_TEXT,
				ARCANE_OVERRIDE_TIP,
				ArcaneBar_OverrideToggle,
				0
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_MAINCOLORSET",
				"BUTTON",
				ARCANEBAR_MAINCOLOR_SET,
				ARCANEBAR_MAINCOLOR_SET_TIP,
				ArcaneBar_MainColorSetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_SETTEXT
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_MAINCOLORRESET",
				"BUTTON",
				ARCANEBAR_MAINCOLOR_RESET,
				ARCANEBAR_MAINCOLOR_RESET_TIP,
				ArcaneBar_MainColorResetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_RESETTEXT
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_CHANNELCOLORSET",
				"BUTTON",
				ARCANEBAR_CHANNELCOLOR_SET,
				ARCANEBAR_CHANNELCOLOR_SET_TIP,
				ArcaneBar_ChannelColorSetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_SETTEXT
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_CHANNELCOLORRESET",
				"BUTTON",
				ARCANEBAR_CHANNELCOLOR_RESET,
				ARCANEBAR_CHANNELCOLOR_RESET_TIP,
				ArcaneBar_ChannelColorResetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_RESETTEXT
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_SUCCESSCOLORSET",
				"BUTTON",
				ARCANEBAR_SUCCESSCOLOR_SET,
				ARCANEBAR_SUCCESSCOLOR_SET_TIP,
				ArcaneBar_SuccessColorSetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_SETTEXT
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_SUCCESSCOLORRESET",
				"BUTTON",
				ARCANEBAR_SUCCESSCOLOR_RESET,
				ARCANEBAR_SUCCESSCOLOR_RESET_TIP,
				ArcaneBar_SuccessColorResetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_RESETTEXT
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_FAILURECOLORSET",
				"BUTTON",
				ARCANEBAR_FAILURECOLOR_SET,
				ARCANEBAR_FAILURECOLOR_SET_TIP,
				ArcaneBar_FailureColorSetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_SETTEXT
			);
			Cosmos_RegisterConfiguration(
				"COS_ARCANEBAR_FAILURECOLORRESET",
				"BUTTON",
				ARCANEBAR_FAILURECOLOR_RESET,
				ARCANEBAR_FAILURECOLOR_RESET_TIP,
				ArcaneBar_FailureColorResetButton,
				0,
				0,
				0,
				0,
				ARCANEBAR_RESETTEXT
			);
		else
			--Save enabled state w/o khaos
			if (ArcaneBar_Enabled) then
				ArcaneBar_EnableToggle(1);
			end
			if (ArcaneBar_Override) then
				ArcaneBar_OverrideToggle(1);
			end
			
			RegisterForSave("ArcaneBar_Enabled");
			RegisterForSave("ArcaneBar_Override");
			
			SlashCmdList["ARCANE_BAR_ENABLE"] = function() 
				ArcaneBar_Enabled = (not ArcaneBar_Enabled);
				if (ArcaneBar_Enabled) then
					ArcaneBar_EnableToggle(1);
				else
					ArcaneBar_EnableToggle(0);
				end
			end;
   			SLASH_ARCANE_BAR_ENABLE1 = "/arcanebar";
   			SLASH_ARCANE_BAR_ENABLE2 = "/ab";
   			
   			SlashCmdList["ARCANE_BAR_OVERRIDE"] = function() 
				ArcaneBar_Override = (not ArcaneBar_Override);
				if (ArcaneBar_Override) then
					ArcaneBar_OverrideToggle(1);
				else
					ArcaneBar_OverrideToggle(0);
				end
			end;
   			SLASH_ARCANE_BAR_OVERRIDE1 = "/arcanebaroverride";
   			SLASH_ARCANE_BAR_OVERRIDE2 = "/aboverride";
   			SLASH_ARCANE_BAR_OVERRIDE3 = "/abo";
		end

	elseif ( event == "SPELLCAST_CHANNEL_UPDATE" ) then
		if ( arg1 == 0 ) then
			this.channeling = nil;
		elseif ( this:IsShown() ) then
			local origDuration = this.endTime - this.startTime
			this.endTime = GetTime() + (arg1 / 1000)
			this.startTime = this.endTime - origDuration
			--this.endTime = this.startTime + (arg1 / 1000);
			ArcaneBar:SetMinMaxValues(this.startTime, this.endTime);
		end
	end
end
function ArcaneBar_OnUpdate()
	if ( this.channeling ) then
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
		ArcaneBar:SetValue( barValue );
		ArcaneBarFlash:Hide();
		local sparkPosition = ((barValue - this.startTime) / (this.endTime - this.startTime)) * 118.5;
		ArcaneBarSpark:SetPoint("CENTER", "ArcaneBar", "LEFT", sparkPosition, 0);
	elseif ( this.casting ) then
		local status = GetTime();
		if ( status > this.maxValue ) then
			status = this.maxValue
		end
		ArcaneBar:SetValue(status);
		ArcaneBarFlash:Hide();
		local sparkPosition = ((status - this.startTime) / (this.maxValue - this.startTime)) * 118.5;
		if ( sparkPosition < 0 ) then
			sparkPosition = 0;
		end
		ArcaneBarSpark:SetPoint("CENTER", "ArcaneBar", "LEFT", sparkPosition, 0);
	elseif ( GetTime() < this.holdTime ) then
		return;
	elseif ( this.flash ) then
		local alpha = ArcaneBarFlash:GetAlpha() + CASTING_BAR_FLASH_STEP;
		if ( alpha < 1 ) then
			ArcaneBarFlash:SetAlpha(alpha);
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
function ArcaneBar_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	ArcaneBar:SetFrameLevel(ArcaneBar:GetFrameLevel() - 1);
	this.casting = nil;
	this.holdTime = 0;
	this.Enabled = 0;
	this.Overrided = 0;
	ArcaneBar_Resetting = {};
end

