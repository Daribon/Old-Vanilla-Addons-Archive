--[[
 WarWatch v0.2
    By Malphaseous

    Filters zone is under attack spam

    Thanks
        - Curse Gaming
        - WoW Wiki
        - ChatTimestamps by Micah
        - FilterAFK by tsigo
]]--

-- Globals

local WARWATCH_VERSION = "0.2";
local WoW_ChatFrame_OnEvent;
WarWatch_Data = {};
WarWatch_Enabled = true;
WarWatch_Inhibit = false;
WarWatch_Threshold = 120;
-- {{{ WarWatch_OnLoad()

function WarWatch_OnLoad()
    local EnableStatus;
    
    SLASH_WARWATCH1 = '/warwatch';
    SLASH_WARWATCH2 = '/ww';
    SlashCmdList['WARWATCH'] = WarWatch_SlashHandler;

    if WarWatch_Enabled then 
        EnableStatus = " Enabled.";
    else
        EnableStatus = " Disabled.";
    end
    
	if(DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage("WarWatch v" .. WARWATCH_VERSION .. EnableStatus .. " .", 1.0, 0.82, 0.0);
	end

    -- Hooks
    WoW_ChatFrame_OnEvent = ChatFrame_OnEvent;
    ChatFrame_OnEvent = WarWatch_ChatFrame_OnEvent;

    -- Events
    this:RegisterEvent("VARIABLES_LOADED");
end

local function print(msg, color)
	color = color or { r = 1, g = 1, b = 1 };
	DEFAULT_CHAT_FRAME:AddMessage(msg, color.r, color.g, color.b);
end

-- {{{ WarWatch_ChatFrame_OnEvent()

function WarWatch_ChatFrame_OnEvent(event)
    if ( WarWatch_Enabled ) and ( event == "CHAT_MSG_CHANNEL" ) then
        -- event: CHAT_MSG_CHANNEL
        -- arg1: message
        -- arg9: Channel Name
        if (( arg9 == "WorldDefense" ) or ( arg9 == "LocalDefense" )) then
            start, stop = string.find(arg1, "is under");
            if (start) and (WarWatch_Inhibit) then
                return false;
            end
            zone = string.sub(arg1,1,start-2);
            if (WarWatch_Data[zone] ~= nil) then
                WarWatch_Data[zone].Count = (WarWatch_Data[zone].Count + 1);
                Last = WarWatch_Data[zone].LastTime;
                if (WarWatch_Data[zone].Count < 7) then
                    WoW_ChatFrame_OnEvent(event);
                end
                if (GetTime() -  Last > WarWatch_Threshold) then
                        WarWatch_Data[zone].LastTime = GetTime();
                        WarWatch_Data[zone].Count = 1;
                        WoW_ChatFrame_OnEvent(event);
                        return true;
                else
                    return false;
                end
            else
                WarWatch_Data[zone] = {};
                WarWatch_Data[zone].Count = 1;
                WarWatch_Data[zone].LastTime = GetTime();
                WoW_ChatFrame_OnEvent(event);
                return true;
            end
        else
            WoW_ChatFrame_OnEvent(event);
            return true;
       end
    else
        WoW_ChatFrame_OnEvent(event);
        return true;
    end
end

function WarWatch_SlashHandler(command)
    local EnableStatus;
    local i,j, a1, a2, a3 = string.find(command, '^([^ ]+)[ ]*([^ ]*)[ ]*(.*)$');
    
    if ( WarWatch_Enabled ) then
        EnableStatus = " Enabled.";
    else
        EnableStatus = " Disabled.";
    end

    if (a1 == 'enable') or (a1 == 'on') then
        WarWatch_Enabled = true;
        print('WarWatch enabled.');
    elseif (a1 == 'disable') or (a1 == 'off') then
        WarWatch_Enabled = false;
        print('WarWatch disabled.');
    elseif (a1 == 'inhibit') then
        local stat = not WarWatch_Inhibit;
        WarWatch_Inhibit = stat;
        if (stat) then
            print('WarWatch will now inhibit all defense messages');
        else
            print('WarWatch inhibit disabled.');
        end
    elseif (a1 == 'threshold') then
        local arg = tonumber(a2);
        if (arg) then
            WarWatch_Threshold = arg;
            print('WarWatch Threshold is now ' .. arg .. ' seconds.');
        else
            print('Invalid number for WarWatch threshold');
        end
    else
        print('Usage: /warwatch [enable|on|disable|off|inhibit|threshold ##]');
        print('       alternate command /ww');
		print('Use "/warwatch enable" or "/warwatch on" to enable suppression of messages.');
		print('Use "/warwatch disable" or "/warwatch off" to disable suppression.');
		print('Use "/warwatch inhibit" to inhibit all "under attack" messages.');
		print('Use "/warwatch threshold ##" to set suppression threshold to ## seconds (default 120).');
		print('WarWatch is currently' .. EnableStatus .. ' Threshold: ' .. WarWatch_Threshold, { r = 1, g = 1, b = 0 });
    end
end
-- }}}
