--------------------------------------------------------------------------
-- Gymnast.lua 
--------------------------------------------------------------------------
--[[
Gymnast Tooltips

Bending over backwards to please. Make your Tooltip as flexible as you are.

By author: AnduinLothar    <Anduin@ultimateuiui.org>

Slash Commands:
"/gtshow" - Makes the Game Tooltip visible for you to drag to your preferred position.
"/gtreset" - Moves the Game Tooltip back to its original position.
"/gttopcenter" - Moves the Game Tooltip to the alternate top center position.
"/gtanchor [position]" - Makes the tooltip extend from this anchored position.
(position can be "SMART", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "LEFT", "TOP", "RIGHT", "BOTTOM", "MOUSE", "UBER")

	$Id: Gymnast.lua 1053 2005-03-14 04:49:18Z AlexYoshi $
	$Rev: 1053 $
	$LastChangedBy: AlexYoshi $
	$Date: 2005-03-13 20:49:18 -0800 (Sun, 13 Mar 2005) $
	
changelog:
v1.0
-Replaced tooltips with mobile ones.
-Included instructions in the tooltip.
v2.0
-Completely redesigned... now it plays nicely with TooltipsBase.
v2.1
-Added Anchoring
-Modified instructions in the tooltip.
v2.2
-Added Mouse and Uber tooltip relocations
v2.3
-Added smart anchoring and center anchoring
-Added a button to move to the old ultimateui position top center.
v2.4
-French localization updated by Sasmira
v2.41
-Updated TOC to 1300
-Fixed a UltimateUI dependancy to be truely optional
v2.42
-Extra options now save correctly when not using ultimateui.

]]--

-- Constants
GYMNAST_TOOLTIPS_POINT = "Point";
GYMNAST_TOOLTIPS_RELATIVETO = "RelativeTo";
GYMNAST_TOOLTIPS_RELATIVEPOINT = "RelativePoint";
GYMNAST_TOOLTIPS_POSITION = "Position";

local SavedGameTooltip_SetDefaultAnchor = nil;
local SavedSmartSetOwner = nil;
local anchorPositions = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "CENTER", "LEFT", "TOP", "RIGHT", "BOTTOM" };
Gymnast_SetTootipAnchorList = {};


function Gymnast_OnLoad()
	
	if (GameTooltip_SetDefaultAnchor ~= SavedGameTooltip_SetDefaultAnchor) then
		SavedGameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor;
		GameTooltip_SetDefaultAnchor = Gymnast_GameTooltip_SetDefaultAnchor;
	end
	
	if (SmartSetOwner ~= SavedSmartSetOwner) then
		SavedSmartSetOwner = SmartSetOwner;
		SmartSetOwner = Gymnast_SmartSetOwner;
	end
	
	table.foreach(anchorPositions, function(index,position) Gymnast_SetTootipAnchorList[position] = function() Gymnast_SetTootipAnchor(position); end; end);
	
	if (UltimateUI_RegisterConfiguration) then
		--register Mobile Frames with ultimateui config
		UltimateUI_RegisterConfiguration("UUI_GYMNAST_TOOLTIPS_HEADER",
			"SECTION",
			TEXT(GYMNAST_TOOLTIPS_HEADER),
			TEXT(GYMNAST_TOOLTIPS_HEADER_INFO)
		);
		UltimateUI_RegisterConfiguration("UUI_GYMNAST_TOOLTIPS_HEADER_SECTION",
			"SEPARATOR",
			TEXT(GYMNAST_TOOLTIPS_HEADER),
			TEXT(GYMNAST_TOOLTIPS_HEADER_INFO)
		);
		
		UltimateUI_RegisterConfiguration(
			"UUI_GYMNAST_TOOLTIPS_ENABLED",
			"CHECKBOX",
			TEXT(GYMNAST_TOOLTIPS_ENABLED_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ENABLED_TEXT_INFO),
			Gymnast_ToggleEnable,
			0
		);
		
		UltimateUI_RegisterConfiguration(
			"UUI_GYMNAST_TOOLTIPS_ANCHOR_UBER",
			"CHECKBOX",
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT_INFO),
			Gymnast_GameTooltipUber,
			0
		);
		
		UltimateUI_RegisterConfiguration(
			"UUI_GYMNAST_TOOLTIPS_ANCHOR_MOUSE",
			"CHECKBOX",
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT_INFO),
			Gymnast_RelocateGameTooltipToMouse,
			0
		);
		
		--show button
		UltimateUI_RegisterConfiguration("UUI_GYMNAST_TOOLTIPS_SHOW",	-- registered name
			"BUTTON",												-- register type
			TEXT(GYMNAST_TOOLTIPS_SHOW_TEXT),								-- short description
			TEXT(GYMNAST_TOOLTIPS_SHOW_TEXT_INFO),						-- long description
			Gymnast_ShowMobileGameTooltip,								-- function
			0,						-- useless
			0,						-- useless
			0,						-- useless
			0,						-- useless
			TEXT(SHOW)		-- button text
		);
		--reset button
		UltimateUI_RegisterConfiguration("UUI_GYMNAST_TOOLTIPS_RESET",  -- registered name
			"BUTTON",												-- register type
			TEXT(GYMNAST_TOOLTIPS_RESET_TEXT),							-- short description
			TEXT(GYMNAST_TOOLTIPS_RESET_TEXT_INFO),						-- long description
			Gymnast_ResetGameTooltip,								-- function
			0,						-- useless
			0,						-- useless
			0,						-- useless
			0,						-- useless
			TEXT(RESET)		-- button text
		);
		
		UltimateUI_RegisterConfiguration("UUI_GYMNAST_TOOLTIPS_SHOW_TOPCENTER",  -- registered name
			"BUTTON",												-- register type
			TEXT(GYMNAST_TOOLTIPS_SHOW_TOPCENTER_TEXT),							-- short description
			TEXT(GYMNAST_TOOLTIPS_SHOW_TOPCENTER_TEXT_INFO),						-- long description
			Gymnast_SetTootipTopCenter,								-- function
			0,						-- useless
			0,						-- useless
			0,						-- useless
			0,						-- useless
			TEXT(SHOW)		-- button text
		);
		
		UltimateUI_RegisterConfiguration(
			"UUI_GYMNAST_TOOLTIPS_ANCHOR_SMART",  -- registered name
			"CHECKBOX",													--Things to use
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT_INFO),
			Gymnast_SetTootipAnchorSmart,								--Callback
			1										--Default Checked/Unchecked
		);
		
		UltimateUI_RegisterConfiguration("UUI_GYMNAST_TOOLTIPS_ADV_OPTIONS_SECTION",
			"SEPARATOR",
			TEXT(GYMNAST_TOOLTIPS_ADV_OPTIONS),
			TEXT(GYMNAST_TOOLTIPS_ADV_OPTIONS_INFO)
		);
		
		for index, position in anchorPositions do
			UltimateUI_RegisterConfiguration(
				"UUI_GYMNAST_TOOLTIPS_ANCHOR_"..position,				-- registered name
				"BUTTON",												-- register type
				format(GYMNAST_TOOLTIPS_ANCHOR_TEXT, position),			-- short description
				format(GYMNAST_TOOLTIPS_ANCHOR_TEXT_INFO, position),	-- long description
				Gymnast_SetTootipAnchorList[position],					-- function
				0,						-- useless
				0,						-- useless
				0,						-- useless
				0,						-- useless
				TEXT(position)		-- button text
			);
		end
		
	else
		Gymnast_Enabled = true;
		RegisterForSave("Gymnast_RelocateUberTooltips");
		RegisterForSave("Gymnast_RelocateTooltip_ToMouse");
		RegisterForSave("Gymnast_TootipAnchorSmart");
	end
	
	SlashCmdList["GYMNASTTOOLTIPSSHOW"] = Gymnast_ShowMobileGameTooltip;
    SLASH_GYMNASTTOOLTIPSSHOW1 = "/gtshow";
	
	SlashCmdList["GYMNASTTOOLTIPSTOPCENTER"] = Gymnast_SetTootipTopCenter;
    SLASH_GYMNASTTOOLTIPSTOPCENTER1 = "/gttopcenter";
	
	SlashCmdList["GYMNASTTOOLTIPSRESET"] = Gymnast_ResetGameTooltip;
    SLASH_GYMNASTTOOLTIPSRESET1 = "/gtreset";
	
	SlashCmdList["GYMNASTTOOLTIPSANCHOR"] = Gymnast_SlashAnchorTooltip;
    SLASH_GYMNASTTOOLTIPSANCHOR1 = "/gtanchor";
	
end


function Gymnast_OnEvent(event)
	if event == "VARIABLES_LOADED" then
		if (not Gymnast_TooltipPointSettings) then
		Gymnast_TooltipPointSettings = {
			[GYMNAST_TOOLTIPS_POINT] = "TOPLEFT",
			[GYMNAST_TOOLTIPS_RELATIVETO] = "UIParent",
			[GYMNAST_TOOLTIPS_RELATIVEPOINT] = "BOTTOMLEFT",
			[GYMNAST_TOOLTIPS_POSITION] = nil
		};
		end
	end
end


function Gymnast_SetTootipAnchor(point)
	Gymnast_SetTootipAnchorSmart(0);
	if (UltimateUI_RegisterConfiguration) then
		UltimateUI_UpdateValue("UUI_GYMNAST_TOOLTIPS_ANCHOR_SMART", CSM_CHECKONOFF, 0);
		if UltimateUIMasterFrame:IsVisible() and (not UltimateUIMasterFrame_IsLoading) then
			UltimateUIMaster_DrawData();
		end
	end
	Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = point;
end

function Gymnast_SetTootipTopCenter()
	MobileGameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
	MobileGameTooltip:SetPoint("TOP", "UIParent", "TOP", 0, -32);
	local r = 0.3;
	local g = 0.7;
	local b = 0.9;
	MobileGameTooltip:AddLine(GYMNAST_TOOLTIPS_HEADER, r+.3, g, b);
	MobileGameTooltip:AddLine(" ", r, g, b);
	MobileGameTooltip:AddLine(GYMNAST_TOOLTIPS_INSTRUCTIONS, r, g, b);
	MobileGameTooltip:Show();
end

function Gymnast_SetTootipAnchorSmart(checked)
	Gymnast_TootipAnchorSmart = (checked == 1);
end

function Gymnast_SlashAnchorTooltip(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, anchor = string.find(msg, "(%w+)");
	if (anchor) then
		if (anchor == "SMART") then
			Gymnast_SetTootipAnchorSmart(1);
			if (UltimateUI_RegisterConfiguration) then
				UltimateUI_UpdateValue("UUI_GYMNAST_TOOLTIPS_ANCHOR_SMART", CSM_CHECKONOFF, 1);
				if UltimateUIMasterFrame:IsVisible() and (not UltimateUIMasterFrame_IsLoading) then
					UltimateUIMaster_DrawData();
				end
			end
		elseif (anchor == "MOUSE") then
			Gymnast_RelocateGameTooltipToMouse();
		elseif (anchor == "UBER") then
			Gymnast_GameTooltipUber();
		else
			for index, position in anchorPositions do
				if (position == anchor) then
					Gymnast_SetTootipAnchor(position);
				end
			end
		end
	end
end


function Gymnast_MarkTootipCoords()
	local centerX,centerY = MobileGameTooltip:GetCenter();
	local left = MobileGameTooltip:GetLeft(); 
	local top = MobileGameTooltip:GetTop(); 
	local right = MobileGameTooltip:GetRight(); 
	local bottom = MobileGameTooltip:GetBottom();
	local coords;
	local place = Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT];
	
	if (Gymnast_TootipAnchorSmart) then
		local parentW = UIParent:GetWidth();
		local parentH = UIParent:GetHeight();
		local onRightThird = (centerX > 2*(parentW/3));
		local onLeftThird = (centerX < (parentW/3));
		local onTopThird = (centerY > 2*(parentH/3));
		local onBottomThird = (centerY < (parentH/3));
		if onRightThird then
			if onTopThird then
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "TOPRIGHT";
			elseif onBottomThird then
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "BOTTOMRIGHT";
			else
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "RIGHT";
			end
		elseif onLeftThird then
			if onTopThird then
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "TOPLEFT";
			elseif onBottomThird then
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "BOTTOMLEFT";
			else
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "LEFT"; 
			end
		else
			if onTopThird then
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "TOP"; 
			elseif onBottomThird then
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "BOTTOM";
			else
				Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = "CENTER";
			end
		end
	end
	
	local place = Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT];
	
	if (place == "TOPLEFT") then
		coords = { left, top }; 
	elseif (place == "TOPRIGHT") then
		coords = { right, top }; 
	elseif (place == "BOTTOMLEFT") then
		coords = { left, bottom }; 
	elseif (place == "BOTTOMRIGHT") then
		coords = { right, bottom };
	elseif (place == "CENTER") then
		coords = { centerX, centerY }; 
	elseif (place == "LEFT") then
		coords = { left, centerY }; 
	elseif (place == "TOP") then
		coords = { centerX, top }; 
	elseif (place == "RIGHT") then
		coords = { right, centerY };
	elseif (place == "BOTTOM") then
		coords = { centerX, bottom };
	end
	Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POSITION] = coords;
end

function Gymnast_RelocateGameTooltipToMouse(toggle)
	if ( toggle == nil ) then
		Gymnast_RelocateTooltip_ToMouse = (not Gymnast_RelocateTooltip_ToMouse);
	elseif ( toggle == 0 ) then
		Gymnast_RelocateTooltip_ToMouse = false;
	else
		Gymnast_RelocateTooltip_ToMouse = true;
	end
end

function Gymnast_GameTooltipUber(toggle)
	if ( toggle == nil ) then
		Gymnast_RelocateUberTooltips = (not Gymnast_RelocateUberTooltips);
	elseif ( toggle == 0 ) then
		Gymnast_RelocateUberTooltips = false;
	else
		Gymnast_RelocateUberTooltips = true;
	end
end

function Gymnast_ToggleEnable(toggle)
	if ( toggle == 0 ) then
		Gymnast_Enabled = false;
	else
		Gymnast_Enabled = true;
	end
end

function Gymnast_GameTooltip_SetDefaultAnchor(tooltip, owner) 
	if (Gymnast_Enabled) then
		if (Gymnast_RelocateUberTooltips) and (owner ~= UIParent) then
			NewSmartSetOwner(owner, "ANCHOR_NONE", 0, 0, tooltip);
			return;
		elseif (tooltip == GameTooltip) or (tooltip == MobileGameTooltip) then 
			if (Gymnast_RelocateTooltip_ToMouse) then
				tooltip:ClearAllPoints();
				tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
				return;
			elseif ( Gymnast_TooltipPointSettings ) then
				local position = Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POSITION];
				if ( ( position ) and ( position[1] ) and ( position[2] ) ) then
					tooltip:Hide()
					tooltip:SetOwner(owner, "ANCHOR_NONE");
					tooltip:ClearAllPoints();
					tooltip:SetPoint(Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT], Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_RELATIVETO], Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_RELATIVEPOINT], position[1], position[2] );
					return;
				end
			end
		end
	end
	SavedGameTooltip_SetDefaultAnchor(tooltip, owner);
end

function Gymnast_GameTooltip_FadeOut()
	if  (MobileGameTooltip:IsVisible()) then
		MobileGameTooltip:FadeOut();
	end
end


function Gymnast_SmartSetOwner(owner, tooltip, setX, setY)
	if (not owner) then
 		owner = this;
 	end
 	if (not tooltip) then
 		tooltip = GameTooltip;
 	end
	NewSmartSetOwner(owner, "ANCHOR_NONE", setX, setY, tooltip);
end

function NewSmartSetOwner(owner, position, setX, setY, tooltip)
	if (not owner) then
 		owner = UIParent;
 	end
 	if (not tooltip) then
 		tooltip = this;
 	end
	if (not setX) then
 		setX = 0;
 	end
 	if (not setY) then
 		setY = 0;
 	end
	if (not Gymnast_RelocateUberTooltips) then
		GameTooltip_SetDefaultAnchor(tooltip, owner);
	else
		local x,y = owner:GetCenter();
		local left = owner:GetLeft();
		local right = owner:GetRight();
		local top = owner:GetTop();
		local bottom = owner:GetBottom();
		local screenWidth = UIParent:GetWidth();
		local screenHeight = UIParent:GetHeight();
		local scale = owner:GetScale();
		if (x~=nil and y~=nil and left~=nil and right~=nil and top~=nil and bottom~=nil and screenWidth>0 and screenHeight>0) then
			setX = setX * scale;
			setY = setY * scale;
			x = x * scale;
			y = y * scale;
			left = left * scale;
			right = right * scale;
			width = right - left;
			top = top * scale;
			bottom = bottom * scale;
			local anchorPoint = "";
			if (y <= (screenHeight * (1/2))) then
				top = top + setY;
				anchorPoint = "TOP";
				if (top < 0) then
					setY = setY - top;
				end
			else
				setY = -setY;
				bottom = bottom + setY;
				anchorPoint = "BOTTOM";
				if (bottom > screenHeight) then
					setY = setY + (screenHeight - bottom);
				end
			end
			
			if (x <= (screenWidth * (1/2))) then
				left = left + setX;
				if (anchorPoint == "BOTTOM") then
					anchorPoint = anchorPoint.."RIGHT";
					setX = setX - width;
					if (left < 0) then
						setX = setX - left;
					end
				else
					anchorPoint = anchorPoint.."LEFT";
					if (left < 0) then
						setX = setX - left;
					end
				end
			else
				setX = -setX;
				right = right + setX;
				if (anchorPoint == "BOTTOM") then
					anchorPoint = anchorPoint.."LEFT";
					setX = setX + width;
					if (right > screenWidth) then
						setX = setX - (right - screenWidth);
					end
				else
					anchorPoint = anchorPoint.."RIGHT";
					if (right > screenWidth) then
						setX = setX + (screenWidth - right);
					end
				end
			end
			
			if (anchorPoint == "") then
				anchorPoint = "TOPLEFT";
			end
			scale = tooltip:GetScale();
			if (scale) then
				setX = setX / scale;
				setY = setY / scale;
			end
			tooltip:SetOwner(owner, "ANCHOR_"..anchorPoint, setX, setY);
		end
	end
end

function Gymnast_ShowMobileGameTooltip()
	GameTooltip_SetDefaultAnchor(MobileGameTooltip, UIParent);
	local r = 0.3;
	local g = 0.7;
	local b = 0.9;
	MobileGameTooltip:AddLine(GYMNAST_TOOLTIPS_HEADER, r+.3, g, b);
	MobileGameTooltip:AddLine(" ", r, g, b);
	MobileGameTooltip:AddLine(GYMNAST_TOOLTIPS_INSTRUCTIONS, r, g, b);
	MobileGameTooltip:Show();
end

function Gymnast_ResetGameTooltip()
	Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POSITION] = nil;
	Gymnast_ShowMobileGameTooltip();
	Chronos.scheduleByName("MobileGameTooltipFade", 1, Gymnast_GameTooltip_FadeOut);
end
