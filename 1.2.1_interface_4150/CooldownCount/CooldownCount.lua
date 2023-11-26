--[[
	Cooldown Count

	By sarf

	This mod allows you to see the amount of time left until the cooldown expires on an action button.

	Thanks goes to Drex of the #cosmostesters channel for suggesting this!
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
COOLDOWNCOUNT_HOUR_MINUTES_FORMAT_LIMIT = 3600;
COOLDOWNCOUNT_MINUTES_SECONDS_FORMAT_LIMIT = 60;

-- Variables
CooldownCount_Enabled = 0;
CooldownCount_SideBarsSideCount = 0;
CooldownCount_UseLongTimerDescriptions = 0;
CooldownCount_UseLongTimerDescriptionsForSeconds = 0;
CooldownCount_TimeBetweenFlashes = 0.5;

CooldownCount_Saved_CooldownFrame_SetTimer = nil;
CooldownCount_Cosmos_Registered = 0;

CooldownCount_LastUpdate = 0;

CooldownCount_UserScale = 2;

CooldownCount_AutoScaleSideBars = 1;
CooldownCount_SideBarOffset = 36*1.5;

CooldownCount_FramesAndTheirButtonNames = {
};


CooldownCount_ButtonNames = {
	"ActionButton", "SecondActionButton", "BonusActionButton", "ShapeshiftButton", 
	"CT_ActionButton", "CT2_ActionButton", "CT3_ActionButton", "CT4_ActionButton",
};



-- executed on load, calls general set-up functions
function CooldownCount_OnLoad()
	CooldownCount_Register();
end

-- registers the mod with Cosmos
function CooldownCount_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( CooldownCount_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT",
			"SECTION",
			TEXT(COOLDOWNCOUNT_CONFIG_HEADER),
			TEXT(COOLDOWNCOUNT_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_HEADER",
			"SEPARATOR",
			TEXT(COOLDOWNCOUNT_CONFIG_HEADER),
			TEXT(COOLDOWNCOUNT_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_ENABLED",
			"CHECKBOX",
			TEXT(COOLDOWNCOUNT_ENABLED),
			TEXT(COOLDOWNCOUNT_ENABLED_INFO),
			CooldownCount_Toggle_Enabled,
			CooldownCount_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_SIDECOUNT",
			"CHECKBOX",
			TEXT(COOLDOWNCOUNT_SIDECOUNT),
			TEXT(COOLDOWNCOUNT_SIDECOUNT_INFO),
			CooldownCount_Toggle_SideCount,
			CooldownCount_SideBarsSideCount
		);
		CooldownCount_UseLongTimerDescriptions = 0;
		--[[
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_USELONGTIMERS",
			"CHECKBOX",
			TEXT(COOLDOWNCOUNT_USELONGTIMERS),
			TEXT(COOLDOWNCOUNT_USELONGTIMERS_INFO),
			CooldownCount_Toggle_UseLongTimers,
			CooldownCount_UseLongTimerDescriptions
		);
		]]--
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_AUTOSCALESIDEBARS",
			"CHECKBOX",
			TEXT(COOLDOWNCOUNT_AUTOSCALESIDEBARS),
			TEXT(COOLDOWNCOUNT_AUTOSCALESIDEBARS_INFO),
			CooldownCount_Toggle_AutoScaleSideBars,
			CooldownCount_AutoScaleSideBars
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_FLASHSPEED",
			"SLIDER",
			TEXT(COOLDOWNCOUNT_FLASHSPEED),
			TEXT(COOLDOWNCOUNT_FLASHSPEED_INFO),
			function (checked, value) CooldownCount_SetFlashSpeed(value); end,
			1,
			CooldownCount_TimeBetweenFlashes,
			0.1,
			1,
			COOLDOWNCOUNT_FLASHSPEED_SLIDER_DESCRIPTION,
			0.1,
			1,
			COOLDOWNCOUNT_FLASHSPEED_SLIDER_APPEND,
			1
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_USERSCALE",
			"SLIDER",
			TEXT(COOLDOWNCOUNT_USERSCALE),
			TEXT(COOLDOWNCOUNT_USERSCALE_INFO),
			function (checked, value) CooldownCount_SetUserScale(value, true); end,
			1,
			CooldownCount_UserScale,
			0.1,
			5,
			COOLDOWNCOUNT_USERSCALE_SLIDER_DESCRIPTION,
			0.1,
			1,
			COOLDOWNCOUNT_USERSCALE_SLIDER_APPEND,
			100
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_SIDEBAROFFSET",
			"SLIDER",
			TEXT(COOLDOWNCOUNT_SIDEBAROFFSET),
			TEXT(COOLDOWNCOUNT_SIDEBAROFFSET_INFO),
			function (checked, value) CooldownCount_SetSideBarOffset(value); end,
			1,
			CooldownCount_SideBarOffset,
			1,
			200,
			COOLDOWNCOUNT_SIDEBAROFFSET_SLIDER_DESCRIPTION,
			1,
			1,
			COOLDOWNCOUNT_SIDEBAROFFSET_SLIDER_APPEND,
			1
		);
		CooldownCount_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function CooldownCount_Register()
	if ( Cosmos_RegisterConfiguration ) then
		CooldownCount_Register_Cosmos();
	else
		SlashCmdList["COOLDOWNCOUNTSLASHENABLE"] = CooldownCount_Enable_ChatCommandHandler;
		SLASH_COOLDOWNCOUNTSLASHENABLE1 = "/cooldowncountenable";
		SLASH_COOLDOWNCOUNTSLASHENABLE2 = "/ccenable";
		SLASH_COOLDOWNCOUNTSLASHENABLE3 = "/cce";
		SLASH_COOLDOWNCOUNTSLASHENABLE4 = "/cooldowncountdisable";
		SLASH_COOLDOWNCOUNTSLASHENABLE5 = "/ccdisable";
		SLASH_COOLDOWNCOUNTSLASHENABLE6 = "/ccd";
		SLASH_COOLDOWNCOUNTSLASHENABLE7 = "/cooldowncounttoggle";
		SLASH_COOLDOWNCOUNTSLASHENABLE8 = "/cctoggle";
		SLASH_COOLDOWNCOUNTSLASHENABLE9 = "/cct";
		SlashCmdList["COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE"] = CooldownCount_SideBarsSideCount_ChatCommandHandler;
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE1 = "/cooldowncountsidebarcountenable";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE2 = "/ccsbcenable";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE3 = "/ccsbce";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE4 = "/cooldowncountsidebarcountdisable";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE5 = "/ccsbcdisable";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE6 = "/ccsbcd";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE7 = "/cooldowncountsidebarcounttoggle";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE8 = "/ccsbctoggle";
		SLASH_COOLDOWNCOUNTSLASHSIDEBARCOUNTENABLE9 = "/ccsbct";
		SlashCmdList["COOLDOWNCOUNTSLASHFLASHSPEED"] = CooldownCount_FlashSpeed_ChatCommandHandler;
		SLASH_COOLDOWNCOUNTSLASHFLASHSPEED1 = "/cooldowncountflashspeed";
		SLASH_COOLDOWNCOUNTSLASHFLASHSPEED2 = "/ccflashspeed";
		SLASH_COOLDOWNCOUNTSLASHFLASHSPEED3 = "/ccfs";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local CooldownCountEnableCommands = {"/cooldowncountenable", "/ccenable", "/cce", "/cooldowncountdisable", "/ccdisable", "/ccd","/cooldowncounttoggle","/cctoggle","/cct"};
		Cosmos_RegisterChatCommand (
			"COOLDOWNCOUNT_ENABLE_COMMANDS", -- Some Unique Group ID
			CooldownCountEnableCommands, -- The Commands
			CooldownCount_Enable_ChatCommandHandler,
			COOLDOWNCOUNT_CHAT_COMMAND_ENABLE_INFO -- Description String
		);
		local CooldownCountSideBarCountEnableCommands = {"/cooldowncountsidebarcountenable", "/ccsbcenable", "/ccsbce", "/cooldowncountsidebarcountdisable", "/ccsbcdisable", "/ccsbcd","/cooldowncountsidebarcounttoggle","/ccsbctoggle","/ccsbct"};
		Cosmos_RegisterChatCommand (
			"COOLDOWNCOUNT_SIDEBARCOUNT_ENABLE_COMMANDS", -- Some Unique Group ID
			CooldownCountSideBarCountEnableCommands, -- The Commands
			CooldownCount_SideBarsSideCount_ChatCommandHandler,
			COOLDOWNCOUNT_CHAT_COMMAND_SIDECOUNT_ENABLE_INFO -- Description String
		);
		local CooldownCountFlashSpeedCommands = {"/cooldowncountflashspeed", "/ccflashspeed", "/ccfs"};
		Cosmos_RegisterChatCommand (
			"COOLDOWNCOUNT_FLASHSPEED_COMMANDS", -- Some Unique Group ID
			CooldownCountFlashSpeedCommands, -- The Commands
			CooldownCount_FlashSpeed_ChatCommandHandler,
			COOLDOWNCOUNT_CHAT_COMMAND_FLASHSPEED_INFO -- Description String
		);
	end
end

-- Handles chat - e.g. slashcommands - enabling/disabling the CooldownCount
function CooldownCount_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		CooldownCount_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			CooldownCount_Toggle_Enabled(0);
		else
			CooldownCount_Toggle_Enabled(-1);
		end
	end
end

-- Handles chat - e.g. slashcommands - enabling/disabling the CooldownCount
function CooldownCount_FlashSpeed_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	local num = tonumber(msg);
	if ( num ) then
		CooldownCount_SetFlashSpeed(num);
	end
end

function CooldownCount_SetFlashSpeed(speed)
	if ( speed ) then
		if ( speed ~= CooldownCount_TimeBetweenFlashes ) then
			CooldownCount_Print(format(COOLDOWNCOUNT_CHAT_FLASHSPEED, speed));
			CooldownCount_TimeBetweenFlashes = speed;
		end
		if ( CooldownCount_Cosmos_Registered == 0 ) then
			RegisterForSave("CooldownCount_TimeBetweenFlashes");
		end
	end
end

function CooldownCount_SetUserScale(scale, quiet)
	if ( scale ) then
		if ( scale ~= CooldownCount_UserScale ) then
			if ( not quiet ) then
				CooldownCount_Print(format(COOLDOWNCOUNT_CHAT_USERSCALE, scale));
			end
			CooldownCount_UserScale = scale;
			CooldownCount_UpdateSideBars();
		end
		if ( CooldownCount_Cosmos_Registered == 0 ) then
			RegisterForSave("CooldownCount_UserScale");
		end
	end
end

function CooldownCount_UpdateSideBars()
	if ( CooldownCount_SideBarsSideCount == 1 ) then
		CooldownCount_SetupSideBarFrames(false);
	else
		CooldownCount_SetupSideBarFrames(true);
	end
	local sideBarFormatStr = "SideBar%sButton%d";
	local sideBarStr = "";
	local tmpSideBarButton = "";
	local cooldownCount = nil;
	local cooldownCountFrame = nil;
	local str;
	for i = 1, 12 do
		if ( i >= 7 ) then
			tmpSideBarButton = format(sideBarFormatStr, "2", i-6);
		else
			tmpSideBarButton = format(sideBarFormatStr, "", i);
		end
		cooldownCount = getglobal(tmpSideBarButton.."CooldownCount");
		cooldownCountFrame = getglobal(tmpSideBarButton.."CooldownCountFrame");
		str = cooldownCount:GetText();
		local oldScale = getglobal(tmpSideBarButton.."CooldownCountFrameScale");
		if ( not oldScale ) then
			oldScale = cooldownCountFrame:GetScale();
			setglobal(tmpSideBarButton.."CooldownCountFrameScale", oldScale);
		end
		local noAutoScale = false;
		if ( CooldownCount_AutoScaleSideBars == 0 ) then
			RegisterForSave("CooldownCount_AutoScaleSideBars");
			noAutoScale = true;
		end
		local newScale = oldScale * CooldownCount_GetAppropriateScale(str, noAutoScale);
		cooldownCountFrame:SetScale(newScale);
		local oldWidth = getglobal(tmpSideBarButton.."CooldownCountFrameWidth");
		if ( not oldWidth ) then
			oldWidth = cooldownCountFrame:GetWidth();
			setglobal(tmpSideBarButton.."CooldownCountFrameWidth", oldWidth);
		end
		local newWidth = newScale * oldWidth;
		if ( newWidth < 32 ) then newWidth = 32; end
		cooldownCountFrame:SetWidth(newWidth);
		cooldownCount:SetWidth(newWidth);
		local oldHeight = getglobal(tmpSideBarButton.."CooldownCountFrameHeight");
		if ( not oldHeight ) then
			oldHeight = cooldownCountFrame:GetHeight();
			setglobal(tmpSideBarButton.."CooldownCountFrameHeight", oldHeight);
		end
		local newHeight = newScale * oldHeight;
		if ( newHeight < 10 ) then newHeight = 10; end
		cooldownCountFrame:SetHeight(newHeight);
		cooldownCount:SetHeight(newHeight);
	end
end

function CooldownCount_SetSideBarOffset(offset)
	if ( offset ) then
		if ( offset ~= CooldownCount_SideBarOffset ) then
			CooldownCount_Print(format(COOLDOWNCOUNT_CHAT_SIDEBAROFFSET, offset));
			CooldownCount_SideBarOffset = offset;
			CooldownCount_UpdateSideBars();
			if ( CooldownCount_Cosmos_Registered == 0 ) then
				RegisterForSave("CooldownCount_SideBarOffset");
			end
		end
	end
end

function CooldownCount_SideBarsSideCount_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		CooldownCount_Toggle_SideCount(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			CooldownCount_Toggle_SideCount(0);
		else
			CooldownCount_Toggle_SideCount(-1);
		end
	end
end


function CooldownCount_CooldownFrame_SetTimer(this, start, duration, enable)
	CooldownCount_Saved_CooldownFrame_SetTimer(this, start, duration, enable);
	CooldownCount_UpdateCooldownCount(this, start, duration, enable);
end

function CooldownCount_GenerateButtonUpdateList()
	local updateList = {};
	local name = nil;
	for k, v in CooldownCount_ButtonNames do
		for i = 1, 12 do
			name = v..i;
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	local sideBarFormatStr = "SideBar%sButton%d";
	local sideBarStr = "";
	local tmpSideBarButton = "";
	for i = 1, 12 do
		if ( i >= 7 ) then
			tmpSideBarButton = format(sideBarFormatStr, "2", i-6);
		else
			tmpSideBarButton = format(sideBarFormatStr, "", i);
		end
		if ( getglobal(tmpSideBarButton) ) then
			table.insert(updateList, tmpSideBarButton);
		end
	end
	local popBarFormatStr = "PopBarButton%d%02d";
	for i = 1, 12 do
		for j = 1, 12 do
			name = format(popBarFormatStr, i, j);
			if ( getglobal(name) ) then
				table.insert(updateList, name);
			end
		end
	end
	local gypsyBarFormatStr = "Gypsy_ActionButton%d";
	for i = 1, 17 do
		name = format(gypsyBarFormatStr, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	local flexBarFormatStr = "FlexBarButton%d";
	for i = 1, 96 do
		name = format(flexBarFormatStr, i);
		if ( getglobal(name) ) then
			table.insert(updateList, name);
		end
	end
	return updateList;
end

CooldownCount_ButtonUpdateList = nil;

function CooldownCount_OnUpdate(elapsed)
	local curTime = GetTime();
	if ( ( CooldownCount_LastUpdate ) and ( CooldownCount_LastUpdate > 0 ) ) then
		if ( ( CooldownCount_LastUpdate + 1.00) < curTime ) then
			if ( not CooldownCount_ButtonUpdateList ) then
				CooldownCount_ButtonUpdateList = CooldownCount_GenerateButtonUpdateList();
			end
			for k, v in CooldownCount_ButtonUpdateList do
				CooldownCount_DoUpdateCooldownCount(v);
			end
			CooldownCount_LastUpdate = curTime;
		end
	else
		CooldownCount_LastUpdate = curTime;
	end
end

function CooldownCount_GetFormattedNumber(number)
	if (strlen(number) < 2 ) then
		return "0"..number;
	else
		return number;
	end
end

-- thanks to vjeux and QuestMinion for this one!
function CooldownCount_Round(x)
	if(x - math.floor(x) > 0.5) then
		x = x + 0.5;
	end
	return math.floor(x);
end

function CooldownCount_GetFormattedTime(time)
	local newTime = CooldownCount_Round(time);
	
	local formattedTime = "";
	
	if ( newTime > COOLDOWNCOUNT_HOUR_MINUTES_FORMAT_LIMIT ) then
		local hours = 0;
		
		if ( CooldownCount_UseLongTimerDescriptions == 1 ) then
			hours = math.floor((newTime / 3600));
			local minutes = math.floor( (( newTime - ( 3600 * hours ) )  / 60) + 0.5 );
			formattedTime = format(COOLDOWNCOUNT_HOUR_MINUTES_FORMAT, hours, CooldownCount_GetFormattedNumber(minutes));
		else
			hours = math.floor((newTime / 3600)+0.5);
			formattedTime = format(COOLDOWNCOUNT_HOURS_FORMAT, hours);
		end
		
	elseif ( newTime > COOLDOWNCOUNT_MINUTES_SECONDS_FORMAT_LIMIT ) then
		local minutes = 0;
		if ( CooldownCount_UseLongTimerDescriptions == 1 ) then
			minutes = math.floor( ( newTime  / 60 ));
			local seconds = math.ceil( newTime - ( 60 * minutes ));
			formattedTime = format(COOLDOWNCOUNT_MINUTES_SECONDS_FORMAT, minutes, CooldownCount_GetFormattedNumber(seconds));
		else
			minutes = math.ceil( ( newTime  / 60 ));
			formattedTime = format(COOLDOWNCOUNT_MINUTES_FORMAT, minutes);
		end
	else
		--[[
		if ( CooldownCount_UseLongTimerDescriptionsForSeconds == 1 ) then
			formattedTime = format(COOLDOWNCOUNT_SECONDS_LONG_FORMAT, newTime);
		else
			formattedTime = format(COOLDOWNCOUNT_SECONDS_FORMAT, newTime);
		end
		]]--
		formattedTime = format(COOLDOWNCOUNT_SECONDS_FORMAT, newTime);
	end
	
	return formattedTime;
end	

--/script CooldownCount_CooldownFrame_SetTimer(getglobal("SecondActionButton3Cooldown"), 544630, 300, 1);
--/script getglobal("SecondActionButton3CooldownCount"):SetText("15"); getglobal("SecondActionButton3CooldownCount"):Show();
--/script Print(getglobal("SecondActionButton3CooldownCount"):GetText());

CooldownCount_OneLetterScale = 1.5;
CooldownCount_TwoLetterScale = 1;
CooldownCount_ThreeLetterScale = 0.66;
CooldownCount_FourLetterScale = 0.5;

CooldownCount_PrecalculatedSizes = {
	[1] = 1,
	[2] = 0.8,
	[3] = 0.7,
	[4] = 0.5,
	[5] = 0.4
};

function CooldownCount_GetAppropriateScale(newTime, noAutoScale)
	if ( not newTime ) then
		newTime = "";
	end
	local lenWithoutSpaces = strlen(string.gsub(newTime, " ", ""));
	local len = strlen(newTime);
	local lenSpaces = len-lenWithoutSpaces;
	local scale = (2 / (lenWithoutSpaces + floor(lenSpaces/2)));
	if ( noAutoScale ) then 
		scale = 1; 
	else
		if ( lenWithoutSpaces < len ) then
			scale = (2 / len);
		end
		if ( CooldownCount_PrecalculatedSizes[len] ) then
			scale = CooldownCount_PrecalculatedSizes[len];
		else
			for k, v in CooldownCount_PrecalculatedSizes do
				if ( k >= len ) then
					scale = v;
					break;
				end
			end
		end
	end
	if ( scale > 1 ) then scale = 1; end
	if ( CooldownCount_UserScale ) and ( CooldownCount_UserScale > 0 ) then 
		scale = scale * CooldownCount_UserScale;
	end
	if ( not noAutoScale ) then if ( scale > 2 ) then scale = 2; end end
	if ( noAutoScale ) then if ( scale > 2 ) then scale = 2; end end
	return scale;
end

-- /script CooldownCount_BasePosition = "CENTER"; CooldownCount_RelativeToPosition = "CENTER"; if ( CooldownCount_SideBarsSideCount == 1 ) then CooldownCount_SetupSideBarFrames(false); else CooldownCount_SetupSideBarFrames(true); end

	

CooldownCount_BasePosition = "CENTER";
CooldownCount_RelativeToPosition = "CENTER";

function CooldownCount_SetupSideBarFrames(onTop)
	local sideBarButton = getglobal("SideBarButton1");
	if ( not sideBarButton ) then
		return;
	end
	local offset = CooldownCount_SideBarOffset;
	if ( ( ( not CooldownCount_SideBarOffset) or ( CooldownCount_SideBarOffset == 0 ) ) and ( sideBarButton ) ) then
		offset = floor(sideBarButton:GetWidth());
		offset = floor(offset * 1.25);
	end
	local sideBarButtonFormatStr = "SideBar%sButton%d";
	local sideBarButtonStr = "SideBar%sButton%d";
	local countStrAppend = "CooldownCount";
	local frame = nil;
	local sideBarStr = "";
	local buttonId = 0;
	
	for i = 1, 12 do
		if ( i <= 6 ) then
			sideBarStr = "";
			buttonId = i;
		else
			sideBarStr = "2";
			buttonId = i-6;
		end
		sideBarButtonStr = format(sideBarButtonFormatStr, sideBarStr, buttonId);
		countName = sideBarButtonStr..countStrAppend;
		count = getglobal(countName);
		frame = getglobal(countName.."Frame");
		if ( ( frame ) and (count) ) then
			frame:ClearAllPoints();
			count:ClearAllPoints();
			if ( not onTop ) then
				if ( i <= 6 ) then
					frame:SetPoint(CooldownCount_BasePosition, sideBarButtonStr, CooldownCount_RelativeToPosition, (offset * -1), 0);
					count:SetPoint(CooldownCount_BasePosition, sideBarButtonStr, CooldownCount_RelativeToPosition, (offset * -1), 0);
				else
					frame:SetPoint(CooldownCount_BasePosition, sideBarButtonStr, CooldownCount_RelativeToPosition, offset, 0);
					count:SetPoint(CooldownCount_BasePosition, sideBarButtonStr, CooldownCount_RelativeToPosition, offset, 0);
				end
			else
				frame:SetPoint(CooldownCount_BasePosition, sideBarButtonStr, CooldownCount_RelativeToPosition, 0, 0);
				count:SetPoint(CooldownCount_BasePosition, sideBarButtonStr, CooldownCount_RelativeToPosition, 0, 0);
			end
		end
	end
end

function CooldownCount_DoUpdateCooldownCount(name)
	local cooldownName = name.."Cooldown";
	local parent = getglobal(name);
	local icon = getglobal(name.."Icon");
	local buttonCooldown = getglobal(cooldownName);
	local cooldownCount = getglobal(cooldownName.."Count");
	local cooldownCountFrame = getglobal(cooldownName.."CountFrame");
	
	local debug = false;
	
	if ( ( ( not parent ) or ( not parent:IsVisible() ) ) or ( ( icon ) and ( not icon:IsVisible() ) ) ) then
		if ( cooldownCount ) then
			cooldownCount:Hide();
		end
		if ( cooldownCountFrame ) then
			cooldownCountFrame:Hide();
		end
		return;
	else
		local frameLevel = parent:GetFrameLevel();
		if ( cooldownCountFrame ) then
			cooldownCountFrame:SetFrameLevel(frameLevel+2);
		end
	end

	local cooldownCountValuesName = (cooldownName.."CountValues");
	local cooldownCountValues = getglobal(cooldownCountValuesName);
	if ( not cooldownCountValues ) then
		if ( cooldownCount ) then
			cooldownCount:Hide();
		end
		if ( cooldownCountFrame ) then
			cooldownCountFrame:Hide();
		end
		return;
	end
	local start = cooldownCountValues[1];
	local duration = cooldownCountValues[2];
	local enable = cooldownCountValues[3];
	if ( (CooldownCount_Enabled == 1) and ( start > 0 and duration > 0) ) then
		local remainingTimeCutOff = 2;
		local remainingTime = -1;
		local flashTimeMax = 10;
		local flashTime = duration / 4;
		if ( flashTime > flashTimeMax ) then
			flashTime = flashTimeMax;
		end
		
		if ( start <= 0 ) then
			remainingTime = -1;
		else
			remainingTime = ceil(( start + duration ) - GetTime());
		end
		
		if ( ( cooldownCount ) and ( cooldownCountFrame ) ) then
			--Print(format("Remaining time : %d", remainingTime));
			if ( ( not cooldownCount:IsVisible() ) and ( duration <= remainingTimeCutOff ) ) then
				--if ( debug ) then Print("cut off engaged lixom"); end
				return;
			end
			if ( ( remainingTime <= 0 ) ) then
				if ( cooldownCount:IsVisible() ) then
					cooldownCount:Hide();
				end
				if ( cooldownCountFrame:IsVisible() ) then
					cooldownCountFrame:Hide();
				end
			else
				local newTime = CooldownCount_GetFormattedTime(remainingTime)
				if ( ( cooldownCount.flashing ) ) then
					if ( ( not cooldownCount.flashTime ) or ( (cooldownCount.flashTime + CooldownCount_TimeBetweenFlashes) < GetTime() ) ) then
						if ( cooldownCount.flashingon ) then
							cooldownCount:SetVertexColor(1.0, 0.82, 0.0);
							cooldownCount.flashingon = false;
						else
							cooldownCount:SetVertexColor(1.0, 0.12, 0.12);
							cooldownCount.flashingon = true;
						end
						cooldownCount.flashTime = GetTime();
					end
				else
					cooldownCount:SetVertexColor(1.0, 0.82, 0.0);
					newTimeString = newTime;
				end
				--Print(format("NewTime : %s", newTime));
				
				local oldTime = cooldownCount:GetText();
				
				if ( newTime ~= oldTime ) then
					cooldownCount:SetText(newTime);
					local oldScale = getglobal(cooldownName.."CountFrameScale");
					if ( not oldScale ) then
						oldScale = cooldownCountFrame:GetScale();
						setglobal(cooldownName.."CountFrameScale", oldScale);
					end
					local noAutoScale = false;
					if ( CooldownCount_AutoScaleSideBars == 0 ) then
						RegisterForSave("CooldownCount_AutoScaleSideBars");
						if ( strfind(name, "SideBar") ) then
							noAutoScale = true;
						end
					end
					local newScale = oldScale * CooldownCount_GetAppropriateScale(newTime, noAutoScale);
					cooldownCountFrame:SetScale(newScale);
					local oldWidth = getglobal(cooldownName.."CountFrameWidth");
					if ( not oldWidth ) then
						oldWidth = cooldownCountFrame:GetWidth();
						setglobal(cooldownName.."CountFrameWidth", oldWidth);
					end
					local newWidth = newScale * oldWidth;
					if ( newWidth < 32 ) then newWidth = 32; end
					cooldownCountFrame:SetWidth(newWidth);
					cooldownCount:SetWidth(newWidth);
					local oldHeight = getglobal(cooldownName.."CountFrameHeight");
					if ( not oldHeight ) then
						oldHeight = cooldownCountFrame:GetHeight();
						setglobal(cooldownName.."CountFrameHeight", oldHeight);
					end
					local newHeight = newScale * oldHeight;
					if ( newHeight < 10 ) then newHeight = 10; end
					cooldownCountFrame:SetHeight(newHeight);
					cooldownCount:SetHeight(newHeight);
				end
				
				if ( remainingTime <= flashTime ) then
					cooldownCount.flashing = true;
				else
					cooldownCount.flashing = false;
				end
				
				if ( ( cooldownCount.flashingQWEQWE ) ) then
					if ( not cooldownCount:IsVisible() ) then
						cooldownCount:Show();
					else
						cooldownCount:Hide();
					end
					if ( not cooldownCountFrame:IsVisible() ) then
						cooldownCountFrame:Show();
					else
						cooldownCountFrame:Hide();
					end
				else
					if ( not cooldownCount:IsVisible() ) then
						cooldownCount:Show();
					end
					if ( not cooldownCountFrame:IsVisible() ) then
						cooldownCountFrame:Show();
					end
				end
			end
		end
	else
		if ( cooldownCount ) then
			cooldownCount:Hide();
		end
		if ( cooldownCountFrame ) then
			cooldownCountFrame:Hide();
		end
	end
end

function CooldownCount_UpdateCooldownCount(this, start, duration, enable)
	local cooldownCount = getglobal(this:GetName().."Count");
	local cooldownCountFrame = getglobal(this:GetName().."CountFrame");
	local cooldownCountValuesName = (this:GetName().."CountValues");
	local cooldownCountValues = { start, duration, enable };
	if ( cooldownCount ) then
		setglobal(cooldownCountValuesName, cooldownCountValues);
	end
	--CooldownCount_DoUpdateCooldownCount(this:GetName());
end



-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function CooldownCount_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( CooldownFrame_SetTimer ~= CooldownCount_CooldownFrame_SetTimer ) and (CooldownCount_Saved_CooldownFrame_SetTimer == nil) ) then
			CooldownCount_Saved_CooldownFrame_SetTimer = CooldownFrame_SetTimer;
			CooldownFrame_SetTimer = CooldownCount_CooldownFrame_SetTimer;
		end
	else
		if ( CooldownFrame_SetTimer == CooldownCount_CooldownFrame_SetTimer) then
			CooldownFrame_SetTimer = CooldownCount_Saved_CooldownFrame_SetTimer;
			CooldownCount_Saved_CooldownFrame_SetTimer = nil;
		end
	end
end

-- Handles events
function CooldownCount_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( CooldownCount_Cosmos_Registered == 0 ) then
			local value = CooldownCount_Enabled;
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			CooldownCount_Toggle_Enabled(value);
			local value = CooldownCount_SideBarsSideCount;
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			CooldownCount_Toggle_SideCount(value);
			
			local value = CooldownCount_TimeBetweenFlashes;
			if (value == nil ) then
				value = 0.25;
			end
			CooldownCount_SetFlashSpeed(value);
			
			local value = CooldownCount_UserScale;
			if (value == nil ) then
				value = 1;
			end
			CooldownCount_SetUserScale(value);
			
			local value = CooldownCount_UseLongTimerDescriptions;
			if (value == nil ) then
				value = 1;
			end
			CooldownCount_Toggle_UseLongTimers(value);
			
			local value = CooldownCount_AutoScaleSideBars;
			if (value == nil ) then
				value = 1;
			end
			CooldownCount_Toggle_AutoScaleSideBars(value);
		end
	end
end

function CooldownCount_Toggle_UseLongTimers(toggle)
	local oldvalue = CooldownCount_UseLongTimerDescriptions;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	CooldownCount_UseLongTimerDescriptions = newvalue;
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_USELONGTIMERS_ENABLED);
		else
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_USELONGTIMERS_DISABLED);
		end
	end
	CooldownCount_Register_Cosmos();
	if ( CooldownCount_Cosmos_Registered == 0 ) then 
		RegisterForSave("CooldownCount_UseLongTimers");
	end
end

function CooldownCount_Toggle_AutoScaleSideBars(toggle)
	local oldvalue = CooldownCount_AutoScaleSideBars;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	CooldownCount_AutoScaleSideBars = newvalue;
	if ( newvalue ~= oldvalue ) then
		CooldownCount_UpdateSideBars();
		if ( newvalue == 1 ) then
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_AUTOSCALESIDEBARS_ENABLED);
		else
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_AUTOSCALESIDEBARS_DISABLED);
		end
	end
	CooldownCount_Register_Cosmos();
	if ( CooldownCount_Cosmos_Registered == 0 ) then 
		RegisterForSave("CooldownCount_AutoScaleSideBars");
	end
end

-- Toggles the enabled/disabled state of the CooldownCount
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function CooldownCount_Toggle_SideCount(toggle)
	local oldvalue = CooldownCount_SideBarsSideCount;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	CooldownCount_SideBarsSideCount = newvalue;
	if ( newvalue == 1 ) then
		CooldownCount_SetupSideBarFrames(false);
	else
		CooldownCount_SetupSideBarFrames(true);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_SIDECOUNT_ENABLED);
		else
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_SIDECOUNT_DISABLED);
		end
	end
	CooldownCount_Register_Cosmos();
	if ( CooldownCount_Cosmos_Registered == 0 ) then 
		RegisterForSave("CooldownCount_SideBarsSideCount");
	end
end

-- Toggles the enabled/disabled state of the CooldownCount
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function CooldownCount_Toggle_Enabled(toggle)
	local oldvalue = CooldownCount_Enabled;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	CooldownCount_Enabled = newvalue;
	CooldownCount_Setup_Hooks(newvalue);
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_ENABLED);
		else
			CooldownCount_Print(COOLDOWNCOUNT_CHAT_DISABLED);
		end
	end
	CooldownCount_Register_Cosmos();
	if ( CooldownCount_Cosmos_Registered == 0 ) then 
		RegisterForSave("CooldownCount_Enabled");
	end
end

-- Prints out text to a chat box.
function CooldownCount_Print(msg,r,g,b,frame,id,unknown4th)
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
