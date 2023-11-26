--[[

	WorldMapInfo: Add info to the world map

	- by geowar 14 Sep, 2004.

]]

----------------------------
-- the chat slash command(s)
----------------------------

SLASH_WMI1 = "/WMI";

SlashCmdList["WMI"] = function(msg)
	local tag = string.lower(msg);
	if(tag) then
		if((string.find("on", tag) ~= nil)) then
			CWMI_Enable(1);
		elseif((string.find("off", tag) ~= nil)) then
			CWMI_Enable(0);
		elseif((string.find("cursor", tag) ~= nil)) then
			CWMI_EnableCursor(not CWMI_Config.cursor);
		elseif((string.find("player", tag) ~= nil)) then
			CWMI_EnablePlayer(not CWMI_Config.player);
		elseif((string.find("save", tag) ~= nil)) then
			CWMI_Save();
		else
			-- print proper usage info here
		end
	end
end

--------------------------
-- Configuration variables
--------------------------

CWMI_Config = {};			-- all the configurations variables are stored here
CWMI_Config.enable = true;	-- on by default
CWMI_Config.cursor = true;	-- on by default
CWMI_Config.player = true;	-- on by default

------------
-- Constants
------------

local UPDATE_RATE = 0.25;
local OFFSET_X = 0.0;
local OFFSET_Y = -0.02;

------------------
-- Local variables
------------------

-----------------
-- "On" functions
-----------------

function CWMI_OnLoad()
	-- Print("CWMI_OnLoad.");
	CWMI_RegisterCosmos();
	
	WorldMapInfoFrame.TimeSinceLastUpdate = 0;
end -- CWMI_OnLoad

function CWMI_OnEnter()
	-- Print("CWMI_OnEnter.");
end -- CWMI_OnEnter

function CWMI_OnClick()
	-- Print("CWMI_OnClick.");
end -- CWMI_OnClick

function CWMI_OnUpdate(arg1)
	-- Print("CWMI_OnUpdate."..asText(arg1)..".");

	WorldMapInfoFrame.TimeSinceLastUpdate = WorldMapInfoFrame.TimeSinceLastUpdate + arg1;
	if(WorldMapInfoFrame.TimeSinceLastUpdate > UPDATE_RATE) then
		local text;
		local x, y = GetCursorPosition();
		local scale = WorldMapFrame:GetScale();

		-- WorldMapInfoRawCursorText:SetText(format("%d,%d (*%f)", x, y, scale));

		x = x / scale;
		y = y / scale;
	
		local width = WorldMapButton:GetWidth();
		local height = WorldMapButton:GetHeight();
		local centerX, centerY = WorldMapFrame:GetCenter();
	
		if (not centerX) then
			centerX = width / 2;
		end
	
		if (not centerY) then
			centerY = height / 2;
		end
	
		local adjustedX = (x - (centerX - (width/2))) / width;
		local adjustedY = (centerY + (height/2) - y) / height;

		adjustedX = adjustedX + OFFSET_X;
		adjustedY = adjustedY + OFFSET_Y;
	
		WorldMapInfoCursorText:SetText(format("%d,%d", adjustedX * 100.0, adjustedY * 100.0));

		local px, py = GetPlayerMapPosition("player");
		WorldMapInfoPlayerText:SetText(format("%d,%d", px * 100.0, py * 100.0));

		WorldMapInfoFrame.TimeSinceLastUpdate = 0.0;
	end
end -- CWMI_OnUpdate

function CWMI_OnEvent()
	if(nil == arg1) then
		Print(format("CWMI_OnEvent:%s: {}.", event));
	else
		if(nil == arg2) then
			Print(format("CWMI_OnEvent:%s: {%s}.", event, arg1));
		else
			Print(format("CWMI_OnEvent:%s: {%s, %s}.", event, arg1, arg2));
		end
	end
end -- CWMI_OnEvent

function CWMI_OnKeyDown()
	Print("CWMI_OnKeyDown"..asText(arg1));
	local keyPressed = arg1;
	if ( IsShiftKeyDown() ) then
		keyPressed = "SHIFT-"..keyPressed;
	end
	if ( IsControlKeyDown() ) then
		keyPressed = "CTRL-"..keyPressed;
	end
	if ( IsAltKeyDown() ) then
		keyPressed = "ALT-"..keyPressed;
	end
	local theAction = GetBindingAction(keyPressed);
	Print("action: "..asText(theAction));
	-- RunBinding(GetBindingAction(keyPressed));
end -- CWMI_OnKeyDown

---------------------
-- Callback functions
---------------------

-- Shows/hides all the Info
function CWMI_Enable(toggle) 
	-- Print("CWMI_Enable("..asText(toggle)..").");
	if (toggle == 1) then 
		CWMI_Config.enable = true;
		WorldMapInfoFrame:Show();
	else
		CWMI_Config.enable = false;
		WorldMapInfoFrame:Hide();
	end
	CWMI_Save();
end -- CWMI_Enable

-- Shows/hides all the Info
function CWMI_Toggle() 
	-- Print("CWMI_Toggle().");
	if (WorldMapInfoFrame:IsVisible()) then 
		CWMI_Config.enable = false;
		WorldMapInfoFrame:Hide();
	else
		CWMI_Config.enable = true;
		WorldMapInfoFrame:Show();
	end
	CWMI_Save();
end -- CWMI_Toggle

-- Shows/hides the cursor Info
function CWMI_EnableCursor(toggle) 
	-- Print("CWMI_EnableCursor("..asText(toggle)..").");
	if (toggle == 1) then 
		CWMI_Config.cursor = true;
		WorldMapInfoCursorText:Show();
	else
		CWMI_Config.cursor = false;
		WorldMapInfoCursorText:Hide();
	end
	CWMI_Save();
end -- CWMI_EnableCursor

function CWMI_EnablePlayer(toggle) 
	-- Print("CWMI_EnablePlayer("..asText(toggle)..").");
	if (toggle == 1) then 
		CWMI_Config.player = true;
		WorldMapInfoPlayerText:Show();
	else
		CWMI_Config.player = false;
		WorldMapInfoPlayerText:Hide();
	end
	CWMI_Save();
end -- CWMI_EnablePlayer

-- local functions

-- General Cosmos Registration Function
function CWMI_RegisterCosmos()

	--
	-- Check for the functions before calling them. 
	--
	-- This will make it possible to keep the add-on
	-- independent of Cosmos Core
	-- 
	if (Cosmos_RegisterConfiguration) then 

		Cosmos_RegisterConfiguration(
			"COS_WMI",
			"SECTION",
			COS_WMI_CONFIG_HEADER,
			COS_WMI_CONFIG_HEADER_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_WMI_HEADER",
			"SEPARATOR",
			COS_WMI_CONFIG_HEADER,
			COS_WMI_CONFIG_HEADER_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_WMI_ENABLE", -- CVAR
			"CHECKBOX",
			COS_WMI_CONFIG_ONOFF,
			COS_WMI_CONFIG_ONOFF_INFO,
			CWMI_Enable,
			CWMI_Config.enable
			);
		Cosmos_RegisterConfiguration(
			"COS_WMI_CURSOR", -- CVAR
			"CHECKBOX",
			COS_WMI_CONFIG_CURSOR_ONOFF,
			COS_WMI_CONFIG_CURSOR_ONOFF_INFO,
			CWMI_EnableCursor,
			CWMI_Config.cursor
			);
		Cosmos_RegisterConfiguration(
			"COS_WMI_PLAYER", -- CVAR
			"CHECKBOX",
			COS_WMI_CONFIG_PLAYER_ONOFF,
			COS_WMI_CONFIG_PLAYER_ONOFF_INFO,
			CWMI_EnablePlayer,
			CWMI_Config.player
			);
	end
--[[
	-- Check for the button menu
	if (Cosmos_RegisterButton) then 
		Cosmos_RegisterButton (
			COS_WMI_BUTTON_TEXT,    -- The Button Text
			COS_WMI_BUTTON_SUBTEXT, -- The Button Subtext
			COS_WMI_BUTTON_TIP,  	-- The Button Mouse-over tooltip 
			"Interface\\Icons\\INV_Misc_Map_01", -- The Button image
			CWMI_Toggle -- The Function called when button is clicked
		);
	end
	-- Add /commands
	if (Cosmos_RegisterChatCommand) then
		Cosmos_RegisterChatCommand (
			"COS_WMI_COMMANDS", -- Some Unique Group ID
			COS_WMI_CHAT_COMMAND, -- The Commands
			CWMI_ChatCommandHandler,
			COS_WMI_CHAT_COMMAND_INFO -- Description String
			);
	end
]]
end -- CWMI_RegisterCosmos

function CWMI_Save()
    -- Print("CWMI_Save");
	RegisterForSave("CWMI_Config");
end

-- Returns a textual representation of "any" Lua object, 
-- incl. tables (and nested tables).
-- Functions are not decompiled (of course).
-- Try: print(asText({{"a", "b"}; c=3}))
function asText(obj)

    visitRef = {}
    visitRef.n = 0

    asTxRecur = function(obj, asIndex)
        if type(obj) == "table" then
            if visitRef[obj] then
                return "@"..visitRef[obj]
            end
            visitRef.n = visitRef.n +1
            visitRef[obj] = visitRef.n

            local begBrac, endBrac
            if asIndex then
                begBrac, endBrac = "[{", "}]"
            else
                begBrac, endBrac = "{", "}"
            end
            local t = begBrac
            local k, v = nil, nil
            repeat
                k, v = next(obj, k)
                if k ~= nil then
                    if t > begBrac then
                        t = t..", "
                    end
                    t = t..asTxRecur(k, 1).."="..asTxRecur(v)
                end
            until k == nil
            return t..endBrac
        else
            if asIndex then
                -- we're on the left side of an "="
                if type(obj) == "string" then
                    return obj
                else
                    return "["..obj.."]"
                end
            else
                -- we're on the right side of an "="
                if type(obj) == "string" then
                    return '"'..obj..'"'
                else
                    return tostring(obj)
                end
            end
        end
    end -- asTxRecur

    return asTxRecur(obj)
end -- asText
