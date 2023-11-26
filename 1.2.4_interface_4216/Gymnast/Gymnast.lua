--------------------------------------------------------------------------
-- Gymnast.lua 
--------------------------------------------------------------------------
--[[
Gymnast Tooltips

Bending over backwards to please. Make your Tooltip as flexible as you are.

By author: AnduinLothar    <Anduin@cosmosui.org>

Slash Commands:
"/gtshow" - Makes the Game Tooltip visible for you to drag to your preferred position.
"/gtreset" - Moves the Game Tooltip back to its original position.
"/gtanchor [position]" - Makes the tooltip extend from this anchored position.
(position can be "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "LEFT", "TOP", "RIGHT", or "BOTTOM")

	$Id: Gymnast.lua 1002 2005-03-11 04:17:00Z karlkfi $
	$Rev: 1002 $
	$LastChangedBy: karlkfi $
	$Date: 2005-03-10 23:17:00 -0500 (Thu, 10 Mar 2005) $

]]--

-- Constants
GYMNAST_TOOLTIPS_POINT = "Point";
GYMNAST_TOOLTIPS_RELATIVETO = "RelativeTo";
GYMNAST_TOOLTIPS_RELATIVEPOINT = "RelativePoint";
GYMNAST_TOOLTIPS_POSITION = "Position";

Gymnast_TooltipPointSettings = {
	[GYMNAST_TOOLTIPS_POINT] = "TOPLEFT",
	[GYMNAST_TOOLTIPS_RELATIVETO] = "UIParent",
	[GYMNAST_TOOLTIPS_RELATIVEPOINT] = "BOTTOMLEFT",
	[GYMNAST_TOOLTIPS_POSITION] = nil
};

local SavedGameTooltip_SetDefaultAnchor = nil;
local SavedSmartSetOwner = nil;
local anchorPositions = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "LEFT", "TOP", "RIGHT", "BOTTOM" };
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
	
	if (Cosmos_RegisterConfiguration) then
		--register Mobile Frames with cosmos config
		Cosmos_RegisterConfiguration("COS_GYMNAST_TOOLTIPS_HEADER",
			"SECTION",
			TEXT(GYMNAST_TOOLTIPS_HEADER),
			TEXT(GYMNAST_TOOLTIPS_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration("COS_GYMNAST_TOOLTIPS_HEADER_SECTION",
			"SEPARATOR",
			TEXT(GYMNAST_TOOLTIPS_HEADER),
			TEXT(GYMNAST_TOOLTIPS_HEADER_INFO)
		);
		--show button
		Cosmos_RegisterConfiguration("COS_GYMNAST_TOOLTIPS_SHOW",	-- registered name
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
		Cosmos_RegisterConfiguration("COS_GYMNAST_TOOLTIPS_RESET",  -- registered name
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
		
		for index, position in anchorPositions do
			Cosmos_RegisterConfiguration(
				"COS_GYMNAST_TOOLTIPS_ANCHOR_"..position,				-- registered name
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
		
	end
	
	SlashCmdList["GYMNASTTOOLTIPSSHOW"] = Gymnast_ShowMobileGameTooltip;
    SLASH_GYMNASTTOOLTIPSSHOW1 = "/gtshow";
	
	SlashCmdList["GYMNASTTOOLTIPSRESET"] = Gymnast_ResetGameTooltip;
    SLASH_GYMNASTTOOLTIPSRESET1 = "/gtreset";
	
	SlashCmdList["GYMNASTTOOLTIPSANCHOR"] = Gymnast_SlashAnchorTooltip;
    SLASH_GYMNASTTOOLTIPSANCHOR1 = "/gtanchor";
	
end


function Gymnast_OnEvent(event)
	if event == "VARIABLES_LOADED" then
		
	end
end


function Gymnast_SetTootipAnchor(point)
	Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = point;
end


function Gymnast_SlashAnchorTooltip(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, anchor = string.find(msg, "(%w+)");
	if (anchor) then
		for index, position in anchorPositions do
			if (position == anchor) then
				Gymnast_SetTootipAnchor(position);
			end
		end
	end
end


function Gymnast_MarkTootipCoords()
	local left = MobileGameTooltip:GetLeft(); 
	local top = MobileGameTooltip:GetTop(); 
	local right = MobileGameTooltip:GetRight(); 
	local bottom = MobileGameTooltip:GetBottom();
	local coords;
	local place = Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT];
	if (place == "TOPLEFT") then
		coords = { left, top }; 
	elseif (place == "TOPRIGHT") then
		coords = { right, top }; 
	elseif (place == "BOTTOMLEFT") then
		coords = { left, bottom }; 
	elseif (place == "BOTTOMRIGHT") then
		coords = { right, bottom };
	elseif (place == "LEFT") then
		coords = { left, floor(math.abs(top-bottom)/2)+bottom }; 
	elseif (place == "TOP") then
		coords = { floor(math.abs(right-left)/2)+left, top }; 
	elseif (place == "RIGHT") then
		coords = { right, floor(math.abs(top-bottom)/2)+bottom };
	elseif (place == "BOTTOM") then
		coords = { floor(math.abs(right-left)/2)+left, bottom };
	end
	Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POSITION] = coords;
end

function Gymnast_GameTooltip_SetDefaultAnchor(tooltip, parent) 
	if (tooltip == GameTooltip) or (tooltip == MobileGameTooltip) then 
		if ( Gymnast_TooltipPointSettings ) then
			local position = Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POSITION];
			if ( ( position ) and ( position[1] ) and ( position[2] ) ) then
				tooltip:Hide()
				tooltip:SetOwner(parent, "ANCHOR_NONE");
				tooltip:ClearAllPoints();
				tooltip:SetPoint(Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT], Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_RELATIVETO], Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_RELATIVEPOINT], position[1], position[2] );
				return;
			end
		end
	end
	SavedGameTooltip_SetDefaultAnchor(tooltip, parent);
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
	GameTooltip_SetDefaultAnchor(tooltip, owner);
	--if not enabled use SavedSmartSetOwner
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
