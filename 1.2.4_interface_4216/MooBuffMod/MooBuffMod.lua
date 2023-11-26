MOOBUFF_FLASH_TIME_ON = 0.75;
MOOBUFF_FLASH_TIME_OFF = 0.75;
MOOBUFF_MIN_ALPHA = 0.3;
MOOBUFF_WARNING_TIME = 31;

MooBuffMod_Enabled = false;
MooBuffMod_ShowNames = false;
MooBuffMod_Vertical = false;
MooBuffMod_TextOrientation = 1;
MooBuffMod_ShortBuffNames = false;
MooBuffMod_TextShortDescription = true;
MooBuffMod_LocationUnderMinimap = false;

MooBuffFrame_DefaultRowSize = -5;
MooBuffFrame_TextBelowRowSize = -14;

MooBuffFrame_DefaultFrameOffset = -205;
MooBuffFrame_NameTextLeftFrameOffset = -280;

MooBuffFrame_DefaultColumnOffset = -5;
MooBuffFrame_HorizontalColumnOffset = -10;

function MooBuffFrame_OnLoad()
	MooBuffFrameUpdateTime = 0;
	MooBuffFrameFlashTime = 0;
	MooBuffFrameFlashState = 1;
	
	if(not (Cosmos_RegisterConfiguration == nil)) then
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD", "SECTION", MBM_SEP, MBM_SEP_INFO );
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_MBMHEADER", "SEPARATOR", MBM_SEP, MBM_SEP_INFO );
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_ONOFF", "CHECKBOX", 
			MBM_CHECK, 
			MBM_CHECK_INFO,
			MooBuffMod_Toggle,
			0
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_SHOW_NAMES", "CHECKBOX", 
			MBM_SHOW_NAMES, 
			MBM_SHOW_NAMES_INFO,
			MooBuffFrame_DisplayNameText,
			0
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_VERTICAL", "CHECKBOX", 
			MBM_VERTICAL, 
			MBM_VERTICAL_INFO,
			MooBuffFrame_SetVerticalMode,
			0
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_TEXT_BELOW", "CHECKBOX", 
			MBM_TEXT_BELOW, 
			MBM_TEXT_BELOW_INFO,
			MooBuffFrame_ChangeExpireTextOrientation,
			1
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_TIME_SHORT", "CHECKBOX", 
			MBM_TIME_SHORT, 
			MBM_TIME_SHORT_INFO,
			MooBuffFrame_ChangeExpireTextShortDescription,
			1
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_NAME_SHORT", "CHECKBOX", 
			MBM_NAME_SHORT, 
			MBM_NAME_SHORT_INFO,
			MooBuffFrame_ChangeNameTextShortDescription,
			0
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_UNDER_MINIMAP", "CHECKBOX", 
			MBM_UNDER_MINIMAP, 
			MBM_UNDER_MINIMAP_INFO,
			MooBuffFrame_ChangeLocationUnderMinimap,
			0
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_NORMAL_MODE", "BUTTON", 
			MBM_NORMAL_MODE, 
			MBM_NORMAL_MODE_INFO,
			MooBuffFrame_NormalMode,
			0,
			0,
			0,
			0,
			MBM_NORMAL_MODE_NAME
		);
		Cosmos_RegisterConfiguration("COS_MOOBUFFMOD_NEW_MODE", "BUTTON", 
			MBM_NEW_MODE, 
			MBM_NEW_MODE_INFO,
			MooBuffFrame_NewMode,
			0,
			0,
			0,
			0,
			MBM_NEW_MODE_NAME
		);
	else
		-- ADD STANDALONE CONFIG HERE
	end

	MooBuffFrame_Saved_BuffButton_Update = BuffButton_Update;
	BuffButton_Update = MooBuffFrame_BuffFrame_BuffButton_Update;

	this:RegisterEvent("VARIABLES_LOADED");
end

function MooBuffFrame_BuffFrame_BuffButton_Update()
	if ( MooBuffMod_Enabled ) then
		this:Hide();
	else
		MooBuffFrame_Saved_BuffButton_Update();
	end
end

function MooBuffFrame_HideOrShow()
	if ( MooBuffMod_Enabled ) then
		MooBuffFrame_Show();
	else
		MooBuffFrame_Hide();
	end
end

function MooBuffFrame_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		MooBuffFrame_SetLocation();
		MooBuffFrame_HideOrShow();
		if ( Cosmos_ScheduleByName ) then
			Cosmos_ScheduleByName("MOOBUFF_UPDATE", 5, MooBuffFrame_HideOrShow);
			Cosmos_ScheduleByName("MOOBUFF_UPDATE_SECOND", 30, MooBuffFrame_HideOrShow);
			Cosmos_ScheduleByName("MOOBUFF_UPDATE_THIRD", 60, MooBuffFrame_HideOrShow);
		end
	end
end

function MooBuffFrame_NormalMode()
	MooBuffFrame_ChangeExpireTextOrientation(1);
	MooBuffFrame_DisplayNameText(0);
	MooBuffFrame_SetVerticalMode(0);
	if ( Cosmos_SetCVar ) then
		Cosmos_UpdateValue("COS_MOOBUFFMOD_TEXT_BELOW", CSM_CHECKONOFF, 1);
		Cosmos_UpdateValue("COS_MOOBUFFMOD_SHOW_NAMES", CSM_CHECKONOFF, 0);
		Cosmos_UpdateValue("COS_MOOBUFFMOD_VERTICAL", CSM_CHECKONOFF, 0);
		Cosmos_UpdateValue("COS_MOOBUFFMOD_TIME_SHORT", CSM_CHECKONOFF, 1);
		if ( CosmosMaster_DrawData ) then
			CosmosMaster_DrawData();
		end
	end
end

function MooBuffFrame_NewMode()
	MooBuffFrame_ChangeExpireTextOrientation(0);
	MooBuffFrame_DisplayNameText(1);
	MooBuffFrame_SetVerticalMode(1);
	if ( Cosmos_SetCVar ) then
		Cosmos_UpdateValue("COS_MOOBUFFMOD_TEXT_BELOW", CSM_CHECKONOFF, 0);
		Cosmos_UpdateValue("COS_MOOBUFFMOD_SHOW_NAMES", CSM_CHECKONOFF, 1);
		Cosmos_UpdateValue("COS_MOOBUFFMOD_VERTICAL", CSM_CHECKONOFF, 1);
		Cosmos_UpdateValue("COS_MOOBUFFMOD_TIME_SHORT", CSM_CHECKONOFF, 0);
		if ( CosmosMaster_DrawData ) then
			CosmosMaster_DrawData();
		end
	end
end

function MooBuffFrame_ChangeExpireTextShortDescription(value)
	if ( value == 1 ) then
		MooBuffMod_TextShortDescription = true;
	else
		MooBuffMod_TextShortDescription = false;
	end
end

function MooBuffFrame_ChangeNameTextShortDescription(value)
	if ( value == 1 ) then
		MooBuffMod_ShortBuffNames = true;
	else
		MooBuffMod_ShortBuffNames = false;
	end
end

function MooBuffFrame_ChangeLocationUnderMinimap(value)
	if ( value == 1 ) then
		MooBuffMod_LocationUnderMinimap = true;
	else
		MooBuffMod_LocationUnderMinimap = false;
	end
	MooBuffFrame_SetLocation();
end

function MooBuffFrame_SetLocation()
	MooBuffFrame:ClearAllPoints();
	if ( MooBuffMod_LocationUnderMinimap ) then
		local x = -56;
		if ( ( MooBuffMod_TextOrientation == 0 ) or ( MooBuffMod_ShowNames ) ) then
			x = x - 75;
		end
		MooBuffFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", x, 13);
	else
		MooBuffFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", MooBuffFrame_GetFrameHorizontalOffset(), -13);
	end
end

-- 0 = right/left text, 1 = below text
function MooBuffFrame_ChangeExpireTextOrientation(value)
	MooBuffMod_TextOrientation = value;
	local buttonId;
	local buttonName;
	local textBelow, textLeft, textRight;
	local mooBuffFrame = getglobal("MooBuffFrame");
	mooBuffFrame:ClearAllPoints();
	mooBuffFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", MooBuffFrame_GetFrameHorizontalOffset(), -13);
	for buttonId = 0, 23 do
		buttonName = "MooBuffButton"..buttonId;
		textBelow = getglobal(buttonName.."ExpireTextBelow");
		textLeft = getglobal(buttonName.."ExpireTextLeft");
		textRight = getglobal(buttonName.."ExpireTextRight");
		if ( textBelow ) then
			if ( value == 0 ) then
				textBelow:Hide();
			elseif ( value == 1 ) then
				textBelow:Show();
			end
		end
		if ( buttonId >= 16 ) then
			if ( textLeft ) then
				textLeft:Hide();
			end
			if ( textRight ) then
				if ( value == 0 ) then
					textRight:Show();
				elseif ( value == 1 ) then
					textRight:Hide();
				end
			end
		else
			if ( textLeft ) then
				if ( value == 0 ) then
					textLeft:Show();
				elseif ( value == 1 ) then
					textLeft:Hide();
				end
			end
			if ( textRight ) then
				textRight:Hide();
			end
		end
	end
	if ( value ~= 1 ) then
		MooBuffFrame_SetVerticalMode(1);
	else
		if ( MooBuffMod_Vertical ) then
			MooBuffFrame_SetVerticalMode(1);
		else
			MooBuffFrame_SetVerticalMode(0);
		end
	end
end

function MooBuffFrame_DisplayNameText(toggle)
	if ( toggle == 1 ) then
		MooBuffMod_ShowNames = true;
	else
		MooBuffMod_ShowNames = false;
	end
	local buttonId;
	local buttonName;
	local nameTextLeft, nameTextRight;
	local mooBuffFrame = getglobal("MooBuffFrame");
	mooBuffFrame:ClearAllPoints();
	mooBuffFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", MooBuffFrame_GetFrameHorizontalOffset(), -13);
	for buttonId = 0, 23 do
		buttonName = "MooBuffButton"..buttonId;
		nameTextLeft = getglobal(buttonName.."NameTextLeft");
		nameTextRight = getglobal(buttonName.."NameTextRight");
		if ( ( nameTextLeft ) and ( nameTextRight)  ) then
			if ( toggle == 1 ) then
				if ( buttonId >= 16) then
					nameTextRight:Show();
					nameTextLeft:Hide();
				else
					nameTextLeft:Show();
					nameTextRight:Hide();
				end
			else
				nameTextLeft:Hide();
				nameTextRight:Hide();
			end
		end
	end
	if ( toggle == 1 ) then
		MooBuffFrame_SetVerticalMode(1);
	else
		if ( MooBuffMod_Vertical ) then
			MooBuffFrame_SetVerticalMode(1);
		else
			MooBuffFrame_SetVerticalMode(0);
		end
	end
end

function MooBuffFrame_GetFrameHorizontalOffset()
	local frameX = MooBuffFrame_DefaultFrameOffset;
	if ( ( MooBuffMod_TextOrientation == 0 ) or ( MooBuffMod_ShowNames ) ) then
		frameX = MooBuffFrame_NameTextLeftFrameOffset;
	end
	return frameX;
end

function MooBuffFrame_GetHorizontalOffset()
	local frameX = MooBuffFrame_DefaultColumnOffset;
	if ( not MooBuffMod_Vertical ) then
		frameX = MooBuffFrame_HorizontalColumnOffset;
	end
	return frameX;
end

function MooBuffFrame_GetVerticalOffset()
	local rowSize = MooBuffFrame_DefaultRowSize;
	if ( MooBuffMod_TextOrientation == 1 ) then
		rowSize = MooBuffFrame_TextBelowRowSize;
	end
	return rowSize;
end

function MooBuffFrame_SetVerticalMode(toggle)
	if ( toggle == 1 ) then
		MooBuffMod_Vertical = true;
	else
		MooBuffMod_Vertical = false;
	end
	local buttonId, prevButtonId;
	local buttonName, prevButtonName;
	local button;
	local mooBuffFrame = getglobal("MooBuffFrame");
	mooBuffFrame:ClearAllPoints();
	mooBuffFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", MooBuffFrame_GetFrameHorizontalOffset(), -13);
	
	local rowSize = MooBuffFrame_GetVerticalOffset();
	
	for buttonId = 1, 23 do
		prevButtonId = buttonId - 1;
		prevButtonName = "MooBuffButton"..prevButtonId;
		buttonName = "MooBuffButton"..buttonId;
		button = getglobal(buttonName);
		if ( button ) then
			button:ClearAllPoints();
			if ( toggle == 1 ) then
				if ( buttonId ~= 16 ) then
					button:SetPoint("TOP", prevButtonName, "BOTTOM", 0, rowSize);
				else
					prevButtonId = 0;
					prevButtonName = "MooBuffButton"..prevButtonId;
					button:SetPoint("RIGHT", prevButtonName, "LEFT", MooBuffFrame_GetHorizontalOffset(), 0);
				end
			else
				if ( ( buttonId ~= 8 ) and ( buttonId ~= 16 ) ) then
					button:SetPoint("RIGHT", prevButtonName, "LEFT", MooBuffFrame_GetHorizontalOffset(), 0);
				else
					-- button 8 should be one level below 0, button 16 one level below 8
					prevButtonId = ( buttonId / 8 - 1 ) * 8;
					prevButtonName = "MooBuffButton"..prevButtonId;
					button:SetPoint("TOP", prevButtonName, "BOTTOM", 0, rowSize);
				end
			end
		end
	end
end

function MooBuffFrame_OnUpdate(elapsed)
	if ( MooBuffFrameUpdateTime > 0 ) then
		MooBuffFrameUpdateTime = MooBuffFrameUpdateTime - elapsed;
	else
		MooBuffFrameUpdateTime = MooBuffFrameUpdateTime + TOOLTIP_UPDATE_TIME;
	end

	MooBuffFrameFlashTime = MooBuffFrameFlashTime - elapsed;
	if ( MooBuffFrameFlashTime < 0 ) then
		local overtime = -MooBuffFrameFlashTime;
		if ( MooBuffFrameFlashState == 0 ) then
			MooBuffFrameFlashState = 1;
			MooBuffFrameFlashTime = MOOBUFF_FLASH_TIME_ON;
		else
			MooBuffFrameFlashState = 0;
			MooBuffFrameFlashTime = MOOBUFF_FLASH_TIME_OFF;
		end
		if ( overtime < MooBuffFrameFlashTime ) then
			MooBuffFrameFlashTime = MooBuffFrameFlashTime - overtime;
		end
	end
	
end

function MooBuffMod_SetTooltip(buffIndex)
	Sea.wow.tooltip.protectTooltipMoney();
	MooBuffTooltip:SetPlayerBuff(buffIndex);
	Sea.wow.tooltip.unprotectTooltipMoney();
	this.updateTooltip = TOOLTIP_UPDATE_TIME;
end


function MooBuffMod_GetBuffNameUsingBuffIndex(buffIndex)
	if (buffIndex ~= -1) then
		local tooltiptext = getglobal("MooBuffTooltipTextLeft1");
		if ( tooltiptext ) then
			tooltiptext:SetText("");
		end
		Sea.wow.tooltip.protectTooltipMoney();
		MooBuffTooltip:SetPlayerBuff(buffIndex);
		Sea.wow.tooltip.unprotectTooltipMoney();
		if ( tooltiptext ) then
			local name = tooltiptext:GetText();
			if ( name ~= nil ) then
				return name;
			end
		end
	end
	return nil;
end

function MooBuffMod_GetBuffName(index, buffFilter)
	local buffIndex, untilCancelled = GetPlayerBuff(index, buffFilter);
	return MooBuffMod_GetBuffNameUsingBuffIndex(buffIndex);
end

function MooBuffButton_UpdateName(buffIndex, button)
	local obj = this;
	if ( button ) then
		obj = button;
	end
	if ( ( MooBuffMod_TooltipsCanBeUsed() == 1 ) and ( MooBuffMod_ShowNames ) ) then
		local buffname = nil;
		if ( ( DynamicData ) and ( DynamicData.effect ) and ( DynamicData.effect.getEffectInfos ) ) then
			local effects = DynamicData.effect.getEffectInfos("player");
			if ( effects ) then
				local arr = effects.buffs;
				-- kinda hackish solution, but will work
				if ( obj.buffFilter == "HARMFUL" ) then
					arr = effects.debuffs;
				end
				local effect = arr[obj:GetID()+1];
				if ( ( effect ) and ( effect.name ) and ( strlen(effect.name) > 0 ) ) then
					buffname = MooBuffButton_TranslateBuffName(effect.name);
					if ( strlen(buffname) <= 0 ) then
						buffname = nil;
					end
				end
			end
		end
		if ( not buffname ) then
			buffname = MooBuffButton_GetBuffName(buffIndex);
		end
		
		
		local textName = obj:GetName().."NameTextLeft";
		local nameLabel = getglobal(textName);
		if ( nameLabel ) then
			nameLabel:SetText(buffname);
		end
		textName = obj:GetName().."NameTextRight";
		nameLabel = getglobal(textName);
		if ( nameLabel ) then
			nameLabel:SetText(buffname);
		end
	end
end

function MooBuffMod_UpdateButton(button)
	local buffIndex, untilCancelled = GetPlayerBuff(button:GetID(), button.buffFilter);
	button.buffIndex = buffIndex;
	button.untilCancelled = untilCancelled;

	if ( buffIndex < 0 ) then
		button:Hide();
		return;
	else
		local timeLeft = GetPlayerBuffTimeLeft(buffIndex);
		MooBuffButton_SetExpireText(timeLeft, button);
		MooBuffButton_UpdateName(buffIndex, button);
	
		button:SetAlpha(1.0);
		button:Show();
	end

	local icon = getglobal(button:GetName().."Icon");
	local texture = GetPlayerBuffTexture(buffIndex);
	icon:SetTexture(texture);

	if ( MooBuffTooltip:IsOwned(button) ) then
		MooBuffMod_SetTooltip(buffIndex);
	end
end

function MooBuffButton_Update()
	MooBuffMod_UpdateButton(this);
end

function MooBuffButton_OnLoad()
	-- Valid tokens for "buffFilter" include: HELPFUL, HARMFUL, PASSIVE, CANCELABLE, NOT_CANCELABLE
	MooBuffButton_Update();
	this:RegisterForClicks("RightButtonUp");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
end

function MooBuffButton_OnEvent(event)
	MooBuffButton_Update();
end

function MooBuffButton_SetExpireText( timeLeft, button )
	if ( not button ) then
		button = this;
	end
	if ( not button ) then
		return;
	end
	local leftRightText = "";
	local belowText = "";
	if ( timeLeft > -1 ) then
		if ( MooBuffMod_TextShortDescription ) then
			leftRightText = MooBuffMod_GetTimeSmall(timeLeft);
		else
			leftRightText = MooBuffMod_GetTime(timeLeft);
		end
		belowText = MooBuffMod_GetTimeSmall(timeLeft);
	end
	local expireLabelName = this:GetName() .. "ExpireTextLeft";
	local expireLabel = getglobal(expireLabelName);
	if ( expireLabel ) then
		expireLabel:SetText(leftRightText);
	end
	expireLabelName = this:GetName() .. "ExpireTextRight";
	expireLabel = getglobal(expireLabelName);
	if ( expireLabel ) then
		expireLabel:SetText(leftRightText);
	end
	expireLabelName = this:GetName() .. "ExpireTextBelow";
	expireLabel = getglobal(expireLabelName);
	if ( expireLabel ) then
		expireLabel:SetText(belowText);
	end
end

function MooBuffButton_TranslateBuffName(buffName)
	if ( ( buffName ) and ( MooBuffMod_ShortBuffNames ) ) then
		local index, indexEnd = nil;
		local tmpStr, tmpStr2, buffLen;
		for k, v in MooBuffButton_ShorterBuffNames do
			if ( k == buffName ) then
				buffName = v;
			end
		end
		for k, v in MooBuffButton_ShorterBuffNames do
			index, indexEnd = strfind(buffName, k);
			if ( index ) then 
				tmpStr = ""; 
				if ( index > 2) then 
					tmpStr = string.sub(buffName, 1, index-2); 
				end 
				tmpStr2 = "";
				buffLen = strlen(buffName);
				if ( indexEnd+1 < buffLen ) then
					tmpStr2 = string.sub(buffName, indexEnd+1, buffLen);
				end
				buffName = tmpStr..v..tmpStr2; 
			end	
		end
	end
	if ( not buffName ) then
		buffName = "";
	end
	return buffName;
end

function MooBuffButton_GetBuffName(buffIndex)
	local buffName = MooBuffMod_GetBuffNameUsingBuffIndex(buffIndex);
	buffName = MooBuffButton_TranslateBuffName(buffName);
	return buffName;
end

function MooBuffFrame_Show()
	if ( BuffFrame:IsVisible() ) then
		BuffFrame:Hide();
		BuffFrame:ClearAllPoints();
		BuffFrame:SetPoint("RIGHT", "UIParent", "LEFT", 0, 0);
	end
	
	if ( not MooBuffFrame:IsVisible() ) then
		MooBuffFrame:Show();
	end
end

function MooBuffFrame_Hide()
	BuffFrame:ClearAllPoints();
	BuffFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -205, -13);
	if ( not BuffFrame:IsVisible() ) then
		BuffFrame:Show();
	end

	local name, button;
	local buffIndex, untilCancelled;
	
	for i = 0, 23 do
		name = "BuffButton"..i;
		button = getglobal(name);
		if ( button ) then
			MooBuffMod_UpdateButton(button);
--[[
			buffIndex, untilCancelled = GetPlayerBuff(button:GetID(), button.buffFilter);
			if ( buffIndex < 0 ) then
				button:Hide();
			else
				button:SetAlpha(1.0);
				button:Show();
			end
]]--
		end
	end
	
	if ( MooBuffFrame:IsVisible() ) then
		MooBuffFrame:Hide();
	end
end

function MooBuffButton_OnUpdate( elapsed )
	if ( not MooBuffMod_Enabled ) then
		return;
	end
	if ( not this:IsVisible() ) then
		return;
	end
	if ( this.untilCancelled == 1 ) then
		MooBuffButton_SetExpireText(-1, this);
		return;
	end


	local buffIndex = this.buffIndex;
	local timeLeft = GetPlayerBuffTimeLeft(buffIndex);
	if ( MooBuffMod_ShowNames ) then
		local currentTexture = GetPlayerBuffTexture(buffIndex);
		local currentSettings = MooBuffMod_GetSettings();
		if ( ( not this.oldTexture ) or ( this.oldTexture ~= currentTexture ) or ( not MooBuffMod_CompareSettings(currentSettings, this.oldSettings) ) ) then
			MooBuffButton_UpdateName(buffIndex, this);
			this.oldTexture = currentTexture;
			this.oldSettings = currentSettings;
		end
	else
		this.oldTexture = nil;
		this.oldSettings = nil;
	end
	
	MooBuffButton_SetExpireText(timeLeft, this);

	local buffAlphaValue;
	if ( timeLeft < MOOBUFF_WARNING_TIME ) then
		if ( MooBuffFrameFlashState == 1 ) then
			buffAlphaValue = (MOOBUFF_FLASH_TIME_ON - MooBuffFrameFlashTime) / MOOBUFF_FLASH_TIME_ON;
			buffAlphaValue = buffAlphaValue * (1 - MOOBUFF_MIN_ALPHA) + MOOBUFF_MIN_ALPHA;
		else
			buffAlphaValue = MooBuffFrameFlashTime / MOOBUFF_FLASH_TIME_ON;
			buffAlphaValue = (buffAlphaValue * (1 - MOOBUFF_MIN_ALPHA)) + MOOBUFF_MIN_ALPHA;
			this:SetAlpha(MooBuffFrameFlashTime / MOOBUFF_FLASH_TIME_ON);
		end
		this:SetAlpha(buffAlphaValue);
	end

	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( MooBuffTooltip:IsOwned(this) ) then
		MooBuffMod_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function MooBuffButton_OnClick()
	CancelPlayerBuff(this.buffIndex);
end

function MooBuffMod_Toggle (toggle)
	if (toggle == 1) then
		MooBuffFrame_Show();
		MooBuffMod_Enabled = true;
	else
		MooBuffFrame_Hide();
		MooBuffMod_Enabled = false;
	end
end

function MooBuffMod_GetTimeSmall( timeLeft )
	local timestr = "";
	local minutes = 0;
	local seconds = 0;
	
	if ( timeLeft >= 60 ) then
		minutes = floor(timeLeft / 60);
		timestr = minutes..":";
	end
	
	seconds = floor(timeLeft - (minutes*60));
	if(seconds<10 and minutes>0) then
		timestr = timestr..0;
	end
	if(seconds==0 and minutes == 0) then
		timestr = "";
	else
		timestr = timestr..seconds;
	end
	
	return timestr;
end
function MooBuffMod_GetTime( timeLeft )
	local timestr = "";
	local minutes = 0;
	local seconds = 0;
	
	if ( timeLeft >= 60 ) then
		minutes = ceil(timeLeft / 60);
		timestr = minutes..":";
		if (minutes > 1) then
			return minutes..TEXT(MBM_TIME_MINUTES);
		else
			return minutes..TEXT(MBM_TIME_MINUTE);
		end
	end
	
	seconds = floor(timeLeft - (minutes*60));
	if(seconds<10 and minutes>0) then
		timestr = timestr..0;
	end
	if(seconds==0 and minutes == 0) then
		timestr = "";
	else
		timestr = timestr..seconds;
		if (seconds > 1) then
			return timestr..TEXT(MBM_TIME_SECONDS);
		else
			return timestr..TEXT(MBM_TIME_SECOND);
		end
	end
	
	return timestr;
end


-- taken from my other mods 
-- /sarf

-- tooltip helper function
MOOBUFFMOD_TOOLTIPS_UNSAFE_FRAMES = { 
   "TaxiFrame", "MerchantFrame", "TradeSkillFrame", "SuggestFrame", "WhoFrame", "AuctionFrame", "MailFrame" 
   }; 

-- use this to add unsafe frames 
function MooBuffMod_TooltipsCanNotBeUsedWithFrame(frame) 
   table.insert(MOOBUFFMOD_TOOLTIPS_UNSAFE_FRAMES, frame); 
end 


-- will return 1 if it is "safe" to use tooltips, otherwise 0 
function MooBuffMod_TooltipsCanBeUsed() 
   local frame = nil; 
   for k, v in MOOBUFFMOD_TOOLTIPS_UNSAFE_FRAMES do 
      frame = getglobal(v); 
      if ( ( frame ) and ( frame:IsVisible() ) ) then 
         return 0; 
      end 
   end 
   return 1; 
end



MooBuffMod_SettingNames = {
	"MooBuffMod_Enabled",
	"MooBuffMod_ShowNames",
	"MooBuffMod_Vertical",
	"MooBuffMod_TextOrientation",
	"MooBuffMod_ShortBuffNames",
	"MooBuffMod_TextShortDescription",
	"ooBuffMod_LocationUnderMinimap"
};

function MooBuffMod_GetSettings() 
	local arr = {};
	for k, v in MooBuffMod_SettingNames do
		arr[k] = v;
	end
	return arr;
end

function MooBuffMod_CompareSettings(settings1, settings2) 
	if ( settings1 ) and ( settings2 ) then
		for k, v in settings1 do
			if ( settings2[k] ~= v ) then
				return false;
			end
		end
		return true;
	elseif ( not settings1 ) and ( not settings2 ) then
		return true;
	else
		return false;
	end
end
