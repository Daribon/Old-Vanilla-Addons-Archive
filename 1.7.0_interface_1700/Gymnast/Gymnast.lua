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
"/gttopcenter" - Moves the Game Tooltip to the alternate top center position.
"/gtanchor [position]" - Makes the tooltip extend from this anchored position.
(position can be "SMART", "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "LEFT", "TOP", "RIGHT", "BOTTOM", "MOUSE", "UBER")

	$Id: Gymnast.lua 2305 2005-08-15 18:28:33Z karlkfi $
	$Rev: 2305 $
	$LastChangedBy: karlkfi $
	$Date: 2005-08-15 13:28:33 -0500 (Mon, 15 Aug 2005) $
	
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
-Added a button to move to the old cosmos position top center.
v2.4
-French localization updated by Sasmira
v2.41
-Updated TOC to 1300
-Fixed a Cosmos dependancy to be truely optional
v2.42
-Extra options now save correctly when not using cosmos.
v2.5
-Updated TOC to 1600
-Added Khaos Options.
-Fixed the Smart Anchor option to be under advanced options.
-Raised advanced options to Master difficulty.
-Made feedback localizable.
-Clarified Uber tooltip relocation in the mouse-over info.

]]--

-- Constants
GYMNAST_TOOLTIPS_POINT = "Point";
GYMNAST_TOOLTIPS_RELATIVETO = "RelativeTo";
GYMNAST_TOOLTIPS_RELATIVEPOINT = "RelativePoint";
GYMNAST_TOOLTIPS_POSITION = "Position";

local SavedGameTooltip_SetDefaultAnchor = nil;
local SavedSmartSetOwner = nil;
local anchorPositions = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "CENTER", "LEFT", "TOP", "RIGHT", "BOTTOM" };
Gymnast_SetTooltipAnchorList = {};


function Gymnast_OnLoad()
	
	if (GameTooltip_SetDefaultAnchor ~= SavedGameTooltip_SetDefaultAnchor) then
		SavedGameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor;
		GameTooltip_SetDefaultAnchor = Gymnast_GameTooltip_SetDefaultAnchor;
	end
	
	if (SmartSetOwner ~= SavedSmartSetOwner) then
		SavedSmartSetOwner = SmartSetOwner;
		SmartSetOwner = Gymnast_SmartSetOwner;
	end
	
	table.foreach(anchorPositions, function(index,position) Gymnast_SetTooltipAnchorList[position] = function() Gymnast_SetTooltipAnchor(position); end; end);
	
	if ( Khaos ) then 
		local options = {};
		local commands = {};
		local optionSet = {
			id="Gymnast";
			text=GYMNAST_TOOLTIPS_HEADER;
			helptext=GYMNAST_TOOLTIPS_HEADER_INFO;
			difficulty=1;
			options=options;
			commands=commands;
		};

		table.insert(
			options, 
			{
				id="Header";
				type=K_HEADER;
				text=TEXT(GYMNAST_TOOLTIPS_HEADER);
				helptext=TEXT(GYMNAST_TOOLTIPS_HEADER_INFO);
				difficulty=1;
				default=false;
			}
		);
		table.insert(
			options, 
			{
				id="Enable";
				type=K_TEXT;
				text=TEXT(GYMNAST_TOOLTIPS_ENABLED_TEXT);
				helptext=TEXT(GYMNAST_TOOLTIPS_ENABLED_TEXT_INFO);
				callback=function(state) 
					Gymnast_Enabled=state.checked;
				end;
				feedback=function(state)
					if ( state.checked ) then 
						return GYMNAST_TOOLTIPS_ENABLED_TEXT_FEEDBACK_ON;
					else
						return GYMNAST_TOOLTIPS_ENABLED_TEXT_FEEDBACK_OFF;
					end
				end;
				difficulty=1;
				check=true;
				default={checked=true};
				disabled={checked=false};
			}
		);
		table.insert(
			options, 
			{
				id="UberAnchor";
				type=K_TEXT;
				text=TEXT(GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT);
				helptext=TEXT(GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT_INFO);
				callback=function(state) 
					Gymnast_RelocateUberTooltips=state.checked;
				end;										
				feedback=function(state)
					if ( state.checked ) then 
						return GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT_FEEDBACK_ON;
					else
						return GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT_FEEDBACK_OFF;
					end
				end;
				difficulty=1;
				check=true;
				default={checked=false};
				disabled={checked=false};
			}
		);
		table.insert(
			options, 
			{
				id="AnchorMouse";
				type=K_TEXT;
				text=TEXT(GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT);
				helptext=TEXT(GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT_INFO);
				callback=function(state) 
					Gymnast_RelocateTooltip_ToMouse=state.checked;
				end;										
				feedback=function(state)
					if ( state.checked ) then 
						return GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT_FEEDBACK_ON;
					else
						return GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT_FEEDBACK_OFF;
					end
				end;
				difficulty=1;
				check=true;
				default={checked=false};
				disabled={checked=false};
			}
		);
		table.insert(
			options, 
			{
				id="ShowMobile";
				type=K_BUTTON;
				text=TEXT(GYMNAST_TOOLTIPS_SHOW_TEXT);
				helptext=TEXT(GYMNAST_TOOLTIPS_SHOW_TEXT_INFO);
				callback=Gymnast_ShowMobileGameTooltip;										
				difficulty=1;
				setup={buttonText=SHOW};
			}
		);
		table.insert(
			options, 
			{
				id="ResetTooltip";
				type=K_TEXT;
				text=TEXT(GYMNAST_TOOLTIPS_RESET_TEXT);
				helptext=TEXT(GYMNAST_TOOLTIPS_RESET_TEXT_INFO);
				callback=Gymnast_ResetGameTooltip;									
				difficulty=1;
				setup={buttonText=RESET};
			}
		);
		table.insert(
			options, 
			{
				id="TopCenter";
				type=K_BUTTON;
				text=TEXT(GYMNAST_TOOLTIPS_SHOW_TOPCENTER_TEXT);
				helptext=TEXT(GYMNAST_TOOLTIPS_SHOW_TOPCENTER_TEXT_INFO);
				callback=Gymnast_SetTooltipTopCenter;									
				difficulty=1;
				setup={buttonText=SHOW};
			}
		);
		table.insert(
			options, 
			{
				id="AdvancedOptionsHeader";
				type=K_HEADER;
				text=TEXT(GYMNAST_TOOLTIPS_ADV_OPTIONS);
				helptext=TEXT(GYMNAST_TOOLTIPS_ADV_OPTIONS_INFO);
				difficulty=3;
			}
		);
		table.insert(
			options, 
			{
				id="SmartAnchor";
				type=K_TEXT;
				text=TEXT(GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT);
				helptext=TEXT(GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT_INFO);
				callback=function(state) 
					Gymnast_TooltipAnchorSmart=state.checked;
				end;										
				feedback=function(state)
					if ( state.checked ) then 
						return GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT_FEEDBACK_ON;
					else
						return GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT_FEEDBACK_OFF;
					end
				end;
				difficulty=3;
				check=true;
				default={checked=true};
				disabled={checked=true};
			}
		);

	for index, position in anchorPositions do
		table.insert(
			options, 
			{
				id="Anchor"..Sea.string.capitalizeWords(position);
				type=K_BUTTON;
				text=string.format(GYMNAST_TOOLTIPS_ANCHOR_TEXT,position);
				helptext=string.format(GYMNAST_TOOLTIPS_ANCHOR_TEXT_INFO,position);
				callback=Gymnast_SetTooltipAnchorList[position];										
				difficulty=3;
				setup={buttonText=position};
			}
		);
	end
	table.insert(commands, 
		{
			id="GymnastCommands";
			commands={"/gt"};
			parseTree={
				["show"] = Gymnast_ShowMobileGameTooltip;
				["topcenter"] = Gymnast_SetTooltipTopCenter;
				["reset"] = Gymnast_ResetGameTooltip;
				["anchor"] = Gymnast_SlashAnchorTooltip;
			};
		}
	);
		Khaos.registerOptionSet(
			"tooltip",
			optionSet
		);
	elseif (Cosmos_RegisterConfiguration) then
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
		
		Cosmos_RegisterConfiguration(
			"COS_GYMNAST_TOOLTIPS_ENABLED",
			"CHECKBOX",
			TEXT(GYMNAST_TOOLTIPS_ENABLED_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ENABLED_TEXT_INFO),
			Gymnast_ToggleEnable,
			0
		);
		
		Cosmos_RegisterConfiguration(
			"COS_GYMNAST_TOOLTIPS_ANCHOR_UBER",
			"CHECKBOX",
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_UBER_TEXT_INFO),
			Gymnast_GameTooltipUber,
			0
		);
		
		Cosmos_RegisterConfiguration(
			"COS_GYMNAST_TOOLTIPS_ANCHOR_MOUSE",
			"CHECKBOX",
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_MOUSE_TEXT_INFO),
			Gymnast_RelocateGameTooltipToMouse,
			0
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
		
		Cosmos_RegisterConfiguration("COS_GYMNAST_TOOLTIPS_SHOW_TOPCENTER",  -- registered name
			"BUTTON",												-- register type
			TEXT(GYMNAST_TOOLTIPS_SHOW_TOPCENTER_TEXT),							-- short description
			TEXT(GYMNAST_TOOLTIPS_SHOW_TOPCENTER_TEXT_INFO),						-- long description
			Gymnast_SetTooltipTopCenter,								-- function
			0,						-- useless
			0,						-- useless
			0,						-- useless
			0,						-- useless
			TEXT(SHOW)		-- button text
		);
		
		Cosmos_RegisterConfiguration(
			"COS_GYMNAST_TOOLTIPS_ANCHOR_SMART",  -- registered name
			"CHECKBOX",													--Things to use
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT),
			TEXT(GYMNAST_TOOLTIPS_ANCHOR_SMART_TEXT_INFO),
			Gymnast_SetTooltipAnchorSmart,								--Callback
			1										--Default Checked/Unchecked
		);
		
		Cosmos_RegisterConfiguration("COS_GYMNAST_TOOLTIPS_ADV_OPTIONS_SECTION",
			"SEPARATOR",
			TEXT(GYMNAST_TOOLTIPS_ADV_OPTIONS),
			TEXT(GYMNAST_TOOLTIPS_ADV_OPTIONS_INFO)
		);
		
		for index, position in anchorPositions do
			Cosmos_RegisterConfiguration(
				"COS_GYMNAST_TOOLTIPS_ANCHOR_"..position,				-- registered name
				"BUTTON",												-- register type
				format(GYMNAST_TOOLTIPS_ANCHOR_TEXT, position),			-- short description
				format(GYMNAST_TOOLTIPS_ANCHOR_TEXT_INFO, position),	-- long description
				Gymnast_SetTooltipAnchorList[position],					-- function
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
		RegisterForSave("Gymnast_TooltipAnchorSmart");
	end
	
	SlashCmdList["GYMNASTTOOLTIPSSHOW"] = Gymnast_ShowMobileGameTooltip;
    SLASH_GYMNASTTOOLTIPSSHOW1 = "/gtshow";
	
	SlashCmdList["GYMNASTTOOLTIPSTOPCENTER"] = Gymnast_SetTooltipTopCenter;
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


function Gymnast_SetTooltipAnchor(point)
	Gymnast_SetTooltipAnchorSmart(0);
	if (Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_GYMNAST_TOOLTIPS_ANCHOR_SMART", CSM_CHECKONOFF, 0);
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
			CosmosMaster_DrawData();
		end
	end
	Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT] = point;
end

function Gymnast_SetTooltipTopCenter()
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

function Gymnast_SetTooltipAnchorSmart(checked)
	Gymnast_TooltipAnchorSmart = (checked == 1);
end

function Gymnast_SlashAnchorTooltip(msg)
	local var;
	local onVal;
	msg = string.upper(msg);
	local startpos, endpos, anchor = string.find(msg, "(%w+)");
	if (anchor) then
		if (anchor == "SMART") then
			Gymnast_SetTooltipAnchorSmart(1);
			if (Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_GYMNAST_TOOLTIPS_ANCHOR_SMART", CSM_CHECKONOFF, 1);
				if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
					CosmosMaster_DrawData();
				end
			end
		elseif (anchor == "MOUSE") then
			Gymnast_RelocateGameTooltipToMouse();
		elseif (anchor == "UBER") then
			Gymnast_GameTooltipUber();
		else
			for index, position in anchorPositions do
				if (position == anchor) then
					Gymnast_SetTooltipAnchor(position);
				end
			end
		end
	end
end


function Gymnast_MarkTooltipCoords()
	local centerX,centerY = MobileGameTooltip:GetCenter();
	local left = MobileGameTooltip:GetLeft(); 
	local top = MobileGameTooltip:GetTop(); 
	local right = MobileGameTooltip:GetRight(); 
	local bottom = MobileGameTooltip:GetBottom();
	local coords;
	local place = Gymnast_TooltipPointSettings[GYMNAST_TOOLTIPS_POINT];
	
	if (Gymnast_TooltipAnchorSmart) then
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
