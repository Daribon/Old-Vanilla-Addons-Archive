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
	-- Sea.io.print("CWMI_OnLoad.");
	CWMI_RegisterCosmos();
	
	WorldMapInfoFrame.TimeSinceLastUpdate = 0;
end -- CWMI_OnLoad

function CWMI_OnEnter()
	-- Sea.io.print("CWMI_OnEnter.");
end -- CWMI_OnEnter

function CWMI_OnLeave()
	-- Sea.io.print("CWMI_OnLeave.");
end -- CWMI_OnLeave

function CWMI_OnClick()
	-- Sea.io.print("CWMI_OnClick.");
end -- CWMI_OnClick

function CWMI_OnUpdate(arg1)
	-- Sea.io.print("CWMI_OnUpdate."..asText(arg1)..".");

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
		Sea.io.print(format("CWMI_OnEvent:%s: {}.", event));
	else
		if(nil == arg2) then
			Sea.io.print(format("CWMI_OnEvent:%s: {%s}.", event, arg1));
		else
			Sea.io.print(format("CWMI_OnEvent:%s: {%s, %s}.", event, arg1, arg2));
		end
	end
end -- CWMI_OnEvent

function CWMI_OnKeyDown()
	Sea.io.print("CWMI_OnKeyDown"..asText(arg1));
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
	Sea.io.print("action: "..asText(theAction));
	-- RunBinding(GetBindingAction(keyPressed));
end -- CWMI_OnKeyDown

---------------------
-- Callback functions
---------------------

-- Shows/hides all the Info
function CWMI_Enable(toggle) 
	-- Sea.io.print("CWMI_Enable("..asText(toggle)..").");
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
	-- Sea.io.print("CWMI_Toggle().");
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
	-- Sea.io.print("CWMI_EnableCursor("..asText(toggle)..").");
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
	-- Sea.io.print("CWMI_EnablePlayer("..asText(toggle)..").");
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
	if ( Khaos ) then
	local optionSet = {};
	local commandSet = {};
	local configurationSet = {
		id="WorldMapInfo";
		text=COS_WMI_CONFIG_HEADER;
		helptext=COS_WMI_CONFIG_HEADER_INFO;
		difficulty=1;
		options=optionSet;
		commands=commandSet;
		default=true;
	}; 
 		table.insert(
		optionSet,
		{
			id="Header";
			text=COS_WMI_CONFIG_HEADER;
			helptext=COS_WMI_CONFIG_HEADER_INFO;
			difficulty=1;
			type=K_HEADER;
		}
		);
 		table.insert(
		optionSet,
		{
			id="Enable";
			text=COS_WMI_CONFIG_ONOFF;
			helptext=COS_WMI_CONFIG_ONOFF_INFO;
			difficulty=1;
			callback=function(state)
				if ( state.checked ) then
					CWMI_Enable(1);
				else
					CWMI_Enable(0);
				end
			end;
			feedback=function ( state)
				if ( state.checked ) then
					return "World Map Information Enabled.";
				else
					return "World Map Information Disabled.";
				end
			end;
			check=true;
			type=K_TEXT;
			default={
				checked=true;
			};
			disabled={
				checked=false;
			};
		}
		);
		
 		table.insert(
		optionSet,
		{
			id="CursorEnable";
			text=COS_WMI_CONFIG_CURSOR_ONOFF;
			helptext=COS_WMI_CONFIG_CURSOR_ONOFF_INFO;
			difficulty=1;
			callback=function(state)
				if (state.checked) then
					CWMI_EnableCursor(1);
				else
					CWMI_EnableCursor(0);
				end
			end;
			feedback=function(state)
				if ( state.checked ) then
					return "Cursor Position Enabled.";
				else
					return "Cursor Position Disabled.";
				end;
			end;
			check=true;
			type=K_TEXT;
			default={
				checked=true;
			};
			disabled={
				checked=false;
			};
			dependencies={
				["Enable"]={checked=true;match=true};
			};
		}
		);
 		table.insert(
		optionSet,
		{
			id="PlayerEnable";
			text=COS_WMI_CONFIG_PLAYER_ONOFF;
			helptext=COS_WMI_CONFIG_PLAYER_ONOFF_INFO;
			difficulty=1;
			callback=function(state)
				if (state.checked) then
					CWMI_EnablePlayer(1);
				else
					CWMI_EnablePlayer(0);
				end
			end;
			feedback=function(state)
				if ( state.checked ) then
					return "Player Position Enabled.";
				else
					return "Player Position Disabled.";
				end;
			end;
			check=true;
			type=K_TEXT;
			default={
				checked=true;
			};
			disabled={
				checked=false;
			};
			dependencies={
				["Enable"]={checked=true;match=true};
			};
		}
		);
		
		Khaos.registerOptionSet(
			"maps",
			configurationSet
		);
	elseif (Cosmos_RegisterConfiguration) then 

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
    -- Sea.io.print("CWMI_Save");
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
