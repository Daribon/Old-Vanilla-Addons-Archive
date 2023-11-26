--[ Mod data ]--
local version = "1.7.5";
local modname = "QuickHeal";

--[ References ]--

local TopFrame;
local OriginalUIErrorsFrame_OnEvent;

-- Function references
local UnitHasHealthInfo;
local EstimateUnitHealNeed;
local debug;

--[ Settings ]--
QuickHealVariables = {};
local QHV; -- Local alias
local DQHV = { -- Default values
    DebugMode = false,
    PetPriority = 1, -- 2: Pet/Players equal, 1: Pet low priority, 0: Don't heal pets
    TargetSelf = false, -- Targetting self doesn't change anything
    RatioForceself = 0.4,
    RatioHealthyDruid = 0.4,
    RatioHealthyPaladin = 0.1,
    RatioHealthyPriest = 0.3,
    RatioHealthyShaman = 0.6,
    RatioFull = 0.9,
    NotificationStyle = "NORMAL",
    NotificationChannelName = "",
    NotificationWhisper = false,
    NotificationParty = false,
    NotificationRaid = false,
    NotificationChannel = false,
    NotificationTextNormal = "Healing %s with %s",
    NotificationTextWhisper = "Healing you with %s",
    MessageScreenCenterHealing = true,
    MessageScreenCenterInfo = true,
    MessageScreenCenterBlacklist = true,
    MessageScreenCenterError = true,
    MessageChatWindowHealing = false,
    MessageChatWindowInfo = false,
    MessageChatWindowBlacklist = false,
    MessageChatWindowError = false
}

--[ Monitor variables ]--
local MassiveOverhealInProgress = false;
local HealingSpellSize = 0;
local HealingTarget; -- Contains the unitID of the last player that was attempted healed
local BlackList = {}; -- List of times were the players are no longer blacklisted
local LastBlackListTime = 0;

--[ Command Settings ]--
local ForceTarget = false;
local ForceTargetTarget = false;
local ForceSelf = false;
local ForceParty = false;

--[ Keybinding ]--
BINDING_HEADER_QUICKHEAL = "QuickHeal";
BINDING_NAME_QUICKHEAL_HEAL = "Heal";
BINDING_NAME_QUICKHEAL_HEALPARTY = "Heal Party";
BINDING_NAME_QUICKHEAL_HEALSELF = "Heal Self";
BINDING_NAME_QUICKHEAL_HEALTARGET = "Heal Target";
BINDING_NAME_QUICKHEAL_HEALTARGETTARGET = "Heal Target's Target";

--[ Reference to external Who-To-Heal modules ]--
local FindSpellToUse = nil;
local GetRatioHealthyExplanation = nil;

--[ Load status of mod ]--
QUICKHEAL_LOADED = false;

--[ Titan Panel functions ]--

function TitanPanelQuickHealButton_OnLoad()
    this.registry = {
        id = modname,
        menuText = modname,
        buttonTextFunction = nil,
        tooltipTitle = modname .. " Configuration",
        tooltipTextFunction = "TitanPanelQuickHealButton_GetTooltipText",
        frequency = 0,
	    icon = "Interface\\Icons\\Spell_Holy_GreaterHeal"
    };
end

function TitanPanelQuickHealButton_GetTooltipText()
    return "Click to toggle configuration panel";
end

--[ Utilities ]--

-- Write one line to chat
local function writeLine(s,r,g,b)
   if DEFAULT_CHAT_FRAME then
       DEFAULT_CHAT_FRAME:AddMessage(s, r or 1, g or 1, b or 1)
   end
end

-- Display debug info in the chat frame if debug is enabled
function QuickHeal_debug(...)
   if DEFAULT_CHAT_FRAME and QHV.DebugMode then
       local msg = ''
       for k,v in ipairs(arg) do
          msg = msg .. tostring(v) .. ' : '
       end
       writeLine(msg)
   end
end

local function Message(text,kind,duration)
    -- Deliver message to center of screen
    if kind == "Healing" and QHV.MessageScreenCenterHealing then UIErrorsFrame:AddMessage(text, 0.1, 1, 0.1, 1, duration or 2)
    elseif kind == "Info" and QHV.MessageScreenCenterInfo then UIErrorsFrame:AddMessage(text, 0.1, 0.1, 1, 1, duration or 2)
    elseif kind == "Blacklist" and QHV.MessageScreenCenterBlacklist then UIErrorsFrame:AddMessage(text, 1, 0.9, 0, 1, duration or 2)
    elseif kind == "Error" and QHV.MessageScreenCenterError then UIErrorsFrame:AddMessage(text, 1, 0.1, 0.1, 1, duration or 2) end
    -- Deliver message to chat window
    if kind == "Healing" and QHV.MessageChatWindowHealing then writeLine(text, 0.1, 1, 0.1)
    elseif kind == "Info" and QHV.MessageChatWindowInfo then writeLine(text, 0.1, 0.1, 1)
    elseif kind == "Blacklist" and QHV.MessageChatWindowBlacklist then writeLine(text, 1, 0.9, 0.2)
    elseif kind == "Error" and QHV.MessageChatWindowError then writeLine(text, 1, 0.1, 0.1) end
end

function QuickHeal_ListUnitEffects(Target)
    if UnitExists(Target) then
        local i=1;
        writeLine("******* Buffs on " .. (UnitName(Target) or "Unknown") .. " *******");
        while (UnitBuff(Target,i)) do
            local icon,apps = UnitBuff(Target,i);
            writeLine(string.format("%s (%d)",icon,apps));
            i=i+1;
        end
        i=1;
        writeLine("******* DeBuffs on " .. (UnitName(Target) or "Unknown") .. " *******");
        while (UnitDebuff(Target,i)) do
            local icon,apps = UnitDebuff(Target,i);
            writeLine(string.format("%s (%d)",icon,apps));
            i=i+1;
        end
    end
end

--[ Initialisation ]--

local function Initialise()

    local _,PlayerClass = UnitClass('player');
    PlayerClass = string.lower(PlayerClass);

    if PlayerClass == "shaman" then
        FindSpellToUse = QuickHeal_Shaman_FindSpellToUse;
        GetRatioHealthyExplanation = QuickHeal_Shaman_GetRatioHealthyExplanation;
    elseif PlayerClass == "priest" then
        FindSpellToUse = QuickHeal_Priest_FindSpellToUse;
        GetRatioHealthyExplanation = QuickHeal_Priest_GetRatioHealthyExplanation;
    elseif PlayerClass == "paladin" then
        FindSpellToUse = QuickHeal_Paladin_FindSpellToUse;
        GetRatioHealthyExplanation = QuickHeal_Paladin_GetRatioHealthyExplanation;
    elseif PlayerClass == "druid" then
        FindSpellToUse = QuickHeal_Druid_FindSpellToUse;
        GetRatioHealthyExplanation = QuickHeal_Druid_GetRatioHealthyExplanation;
    else
        writeLine(modname .. " " .. version .. " does not support " .. UnitClass('player') .. ". " .. modname .. " not loaded.")
        return;
    end

    SlashCmdList["QUICKHEAL"] = QuickHeal_Command;
    SLASH_QUICKHEAL1 = "/qh";
    SLASH_QUICKHEAL2 = "/quickheal";

    -- Hook the UIErrorsFrame
    OriginalUIErrorsFrame_OnEvent = UIErrorsFrame_OnEvent;
    UIErrorsFrame_OnEvent = NewUIErrorsFrame_OnEvent;

    -- Setup QuickHealVariables (and initialise upon first use)
    QHV = QuickHealVariables;
    for k in pairs(DQHV) do
        if QHV[k] == nil then QHV[k] = DQHV[k] end;
    end

    UnitHasHealthInfo = QuickHeal_UnitHasHealthInfo;
    EstimateUnitHealNeed = QuickHeal_EstimateUnitHealNeed;
    debug = QuickHeal_debug;

    -- Save the version of the mod along with the configuration
    QuickHealVariables["ConfigID"] = version;

    -- reference to the top frame of QuickHeal
    TopFrame = this;

	--Allows Configuration Panel to be closed with the Escape key
	tinsert(UISpecialFrames, getglobal("QuickHealConfig"));

    -- Right-click party member menu item (disabled to prevent confusion!)
    --table.insert(UnitPopupMenus["PARTY"],table.getn(UnitPopupMenus["PARTY"]),"DEDICATEDHEALINGTARGET");
    --UnitPopupButtons["DEDICATEDHEALINGTARGET"] = { text = TEXT("Designate Healing Target"), dist = 0 };

    writeLine(modname .. " " .. version .. " for " .. UnitClass('player') .. " Loaded. Usage: '/qh help'.")

    QUICKHEAL_LOADED = true;
end

function QuickHeal_SetDefaultParameters()
    for k in pairs(DQHV) do
        QHV[k] = DQHV[k];
    end
end

--[ Event Handlers and monitor setup ]--

-- Update the Overheal status label above the CastingBarFrame
local function UpdateQuickHealOverhealStatus()
    local textframe = getglobal("QuickHealOverhealStatus_Text");
    local healneed,overheal,waste;

    -- Determine healneed on HealingTarget
    if UnitHasHealthInfo(HealingTarget) then
        -- Full info available
        healneed = UnitHealthMax(HealingTarget) - UnitHealth(HealingTarget);
    else
        -- Estimate target health
        healneed = EstimateUnitHealNeed(HealingTarget);
    end

    -- Determine overheal
    overheal = HealingSpellSize - healneed;

    -- Calculate waste
    waste = overheal / HealingSpellSize * 100;

    -- Hide text if no overheal and debugmode is off
    if not QHV.DebugMode then
        if waste < 10 then
            textframe:SetText("")
            return
        end
    end

    -- Update the label
    local txt = floor(waste) .. "% of heal will be wasted (" .. floor(overheal) .. " Health)";
    debug(txt);
    textframe:SetText(txt);
    local font = textframe:GetFont();
    if waste > 50 then
        textframe:SetTextColor(1,0,0);
        textframe:SetFont(font,14);
        MassiveOverhealInProgress = true;
    else
        MassiveOverhealInProgress = false;
        textframe:SetTextColor(1,1,0);
        textframe:SetFont(font,12);
    end
end

local function StartMonitor(Target)
    MassiveOverhealInProgress = false;
    HealingTarget = Target;
    debug("*Starting Monitor",UnitName(Target));
    TopFrame:RegisterEvent("SPELLCAST_STOP");   -- For detecting successful spellcast and deliberate interupt
    TopFrame:RegisterEvent("UNIT_HEALTH"); -- For detecting overheal situations
    UpdateQuickHealOverhealStatus();
    QuickHealOverhealStatus:Show(); -- Show the overheal warning text frame above the casting bar
end

local function StopMonitor(trigger)
    QuickHealOverhealStatus:Hide();
    TopFrame:UnregisterEvent("SPELLCAST_STOP");
    TopFrame:UnregisterEvent("UNIT_HEALTH");
    debug("*Stopping Monitor",trigger or "Unknown Trigger");
    HealingTarget = nil;
end

-- UIErrorsFrame Hook

function NewUIErrorsFrame_OnEvent(...)
    -- Catch only if monitor is running (HealingTarget ~= nil) and if event is UI_ERROR_MESSAGE
    if HealingTarget and event == "UI_ERROR_MESSAGE" and arg1 then
        if arg1 == SPELL_FAILED_OUT_OF_RANGE .. "." then
            Message(string.format(SPELL_FAILED_OUT_OF_RANGE .. ". %s blacklisted for 5 sec.", UnitName(HealingTarget)),"Blacklist",5)
            LastBlackListTime = GetTime();
            BlackList[UnitName(HealingTarget)] = LastBlackListTime + 5;
            StopMonitor("Out of range");
            return;
        elseif arg1 == SPELL_FAILED_LINE_OF_SIGHT then
            Message(string.format(SPELL_FAILED_LINE_OF_SIGHT .. ". %s blacklisted for 2 sec.", UnitName(HealingTarget)),"Blacklist",2)
            LastBlackListTime = GetTime();
            BlackList[UnitName(HealingTarget)] = LastBlackListTime + 2;
            StopMonitor("Not in line of sight")
            return;
        else
            StopMonitor((event or "Unknown Event") .. " : " .. (arg1 or "Unknown Argument"));
        end
    end
    return {OriginalUIErrorsFrame_OnEvent(unpack(arg))};
end

-- Triggered when someone in the party/raid, current target or mouseover is healed/damaged
local function HealHandler()
    if UnitIsUnit(HealingTarget,arg1) then
        UpdateQuickHealOverhealStatus();
    end
end

-- Called when the mod is loaded
function QuickHeal_OnLoad()
    this:RegisterEvent("VARIABLES_LOADED");
end

-- Called whenever a registered event occurs
function QuickHeal_OnEvent()
    if (event == "VARIABLES_LOADED") then
        Initialise();
    elseif (event == "SPELLCAST_STOP") then
        StopMonitor(event);
    elseif (event == "UNIT_HEALTH") then
        HealHandler();
    else
        debug("EVENT",event,arg1 or "nil",arg2 or "nil",arg3 or "nil",arg4 or "nil",arg5 or "nil",arg6 or "nil",arg7 or "nil")
    end
end

--[ User Interface Functions ]--

-- Items in the NotificationStyle ComboBox
function QuickHeal_ComboBoxNotificationStyle_Fill()
    UIDropDownMenu_AddButton{ text = "Normal"; func = QuickHeal_ComboBoxNotificationStyle_Click; value = "NORMAL" };
    UIDropDownMenu_AddButton{ text = "Role-Playing"; func = QuickHeal_ComboBoxNotificationStyle_Click; value = "RP" };
end
-- Function for handling clicks on the NotificationStyle ComboBox
function QuickHeal_ComboBoxNotificationStyle_Click()
    QHV.NotificationStyle = this.value;
    UIDropDownMenu_SetSelectedValue(QuickHealConfig_ComboBoxNotificationStyle,this.value);
    QuickHealConfig_Explanation:SetText(QuickHeal_GetExplanation());
end

-- Items in the MessageConfigure ComboBox
function QuickHeal_ComboBoxMessageConfigure_Fill()
    UIDropDownMenu_AddButton{ text = "Healing (Green)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Healing" };
    UIDropDownMenu_AddButton{ text = "Info (Blue)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Info" };
    UIDropDownMenu_AddButton{ text = "Blacklist (Yellow)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Blacklist" };
    UIDropDownMenu_AddButton{ text = "Error (Red)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Error" };
end
-- Function for handling clicks on the MessageConfigure ComboBox
function QuickHeal_ComboBoxMessageConfigure_Click()
    UIDropDownMenu_SetSelectedValue(QuickHealConfig_ComboBoxMessageConfigure,this.value);
    if QHV["MessageScreenCenter" .. this.value] then
        QuickHealConfig_CheckButtonMessageScreenCenter:SetChecked(true);
    else
        QuickHealConfig_CheckButtonMessageScreenCenter:SetChecked(false);
    end
    if QHV["MessageChatWindow" .. this.value] then
        QuickHealConfig_CheckButtonMessageChatWindow:SetChecked(true);
    else
        QuickHealConfig_CheckButtonMessageChatWindow:SetChecked(false);
    end
end

-- Convert a list of string items to a written language enumeration strings
function ConvertListToString(t,lower)
    local N = table.getn(t);
    if N == 0 then return "" end
    if N == 1 then return t[1] end
    if N == 2 then
        if lower then
            return string.lower(t[1]) .. " and " .. string.lower(t[2])
        else
            return t[1] .. " and " .. string.lower(t[2])
        end
    end
    if N > 2 then
        local first = t[1];
        table.remove(t,1);
        if lower then
            return string.lower(first) .. ", " .. ConvertListToString(t,true);
        else
            return first .. ", " .. ConvertListToString(t,true);
        end
    end
end

-- Get an explanation of effects based on current settings
function QuickHeal_GetExplanation()
    local string;
    if QHV.RatioFull > 0 then
        string = "Will only heal if target has less than " .. QHV.RatioFull*100 .. "% life.\n\n";
    else
        string = modname .. " is disabled.";
        return string;
    end
    string = string .. GetRatioHealthyExplanation();
    string = string .. "\n\n";
    if QHV.RatioForceself > 0 then
        if QHV.RatioForceself > QHV.RatioFull then
            string = string .. "You will always be the target of the heal.\n\n";
        else
            string = string .. "If you have less than " .. QHV.RatioForceself*100 .. "% life, you will become the target of the heal.\n\n";
        end
    end
    if QHV.TargetSelf then
        string = string .. "If you target yourself, you will get highest priority.\n\n";
    end
    if QHV.PetPriority == 0 then
        string = string .. "Pets will never be healed.\n\n";
    end
    if QHV.PetPriority == 1 then
        string = string .. "Pets will only be healed if no players need healing.\n\n";
    end
    if QHV.PetPriority == 2 then
        string = string .. "Pets will be considered equal to players.\n\n";
    end

    local ValidChannelName = false;
    if QHV.NotificationChannelName and QHV.NotificationChannelName ~= "" then
        ValidChannelName = true;
    end
    if QHV.NotificationParty or QHV.NotificationRaid or QHV.NotificationChannel and ValidChannelName then
        if QHV.NotificationStyle == "NORMAL" then
            string = string .. "Notification ";
        elseif QHV.NotificationStyle == "RP" then
            string = string .. "Role-playing style notification ";
        end
    end
    if QHV.NotificationParty or QHV.NotificationRaid or QHV.NotificationChannel then
        if QHV.NotificationChannel and ValidChannelName then
            string = string .. "will be delivered to channel '" .. QHV.NotificationChannelName .. "' if it exists. ";
            if QHV.NotificationRaid or QHV.NotificationParty then
                string = string .. "Otherwise it will be delivered to ";
                if QHV.NotificationRaid and QHV.NotificationParty then
                    string = string .. "party chat when in a party or to raid chat when in a raid. ";
                elseif QHV.NotificationParty then
                    string = string .. "party chat when in a party. ";
                elseif QHV.NotificationRaid then
                    string = string .. "raid chat when in a raid. ";
                end
            end
        elseif QHV.NotificationRaid or QHV.NotificationParty then
            string = string .. "will be delivered to ";
            if QHV.NotificationRaid and QHV.NotificationParty then
                string = string .. "party chat when in a party or to raid chat when in a raid. ";
            elseif QHV.NotificationParty then
                string = string .. "party chat when in a party. ";
            elseif QHV.NotificationRaid then
                string = string .. "raid chat when in a raid. ";
            end
        end
    end
    if QHV.NotificationWhisper then
        string = string .. "Healing target will receive notification by whisper.\n\n"
    elseif QHV.NotificationParty or QHV.NotificationRaid or QHV.NotificationChannel and ValidChannelName then
        string = string .. "\n\n";
    end
    local t = {};
    local Green = QHV.MessageScreenCenterHealing;
    local Blue = QHV.MessageScreenCenterInfo;
    local Yellow = QHV.MessageScreenCenterBlacklist;
    local Red = QHV.MessageScreenCenterError;
    if Green then table.insert(t,"Healing") end
    if Blue then table.insert(t,"Info") end
    if Yellow then table.insert(t,"Blacklist") end
    if Red then table.insert(t,"Error") end
    if Yellow or Blue or Red or Green then
        string = string .. ConvertListToString(t) .. " messages are delivered to center of screen. ";
    end
    t = {};
    Green = QHV.MessageChatWindowHealing;
    Blue = QHV.MessageChatWindowInfo;
    Yellow = QHV.MessageChatWindowBlacklist;
    Red = QHV.MessageChatWindowError;
    if Green then table.insert(t,"Healing") end
    if Blue then table.insert(t,"Info") end
    if Yellow then table.insert(t,"Blacklist") end
    if Red then table.insert(t,"Error") end
    if Yellow or Blue or Red or Green then
        string = string .. ConvertListToString(t) .. " messages are delivered to chat window. ";
    end
    return string;
end

function QuickHeal_GetRatioHealthy()
    local _,PlayerClass = UnitClass('player');
    if string.lower(PlayerClass) == "druid" then return QHV.RatioHealthyDruid end
    if string.lower(PlayerClass) == "paladin" then return QHV.RatioHealthyPaladin end
    if string.lower(PlayerClass) == "priest" then return QHV.RatioHealthyPriest end
    if string.lower(PlayerClass) == "shaman" then return QHV.RatioHealthyShaman end
    return nil;
end

-- Hides/Shows the configuration dialog
function QuickHeal_ToggleConfigurationPanel()
    local frame = getglobal("QuickHealConfig")
        if (frame) then
            if frame:IsVisible() then
                frame:Hide();
            else
                frame:Show();
            end
        end
end

--[ Buff and Debuff detection ]--

function QuickHeal_DetectBuff(unit,name)
    local i=1;
    local state;
    while true do
        state = UnitBuff(unit,i);
        if not state then return false end
        if strfind(state,name) then return true end
        i=i+1;
    end
end

function QuickHeal_DetectDebuff(unit,name)
    local i=1;
    local state;
    while true do
        state = UnitDebuff(unit,i);
        if not state then return false end
        if strfind(state,name) then return true end
        i=i+1;
    end
end

-- Priest talent Inner Focus and Shaman skill Water Walking: Spell_Frost_WindWalkOn
-- Spirit of Redemption: Spell_Holy_GreaterHeal
-- Nature's Swiftness: Spell_Nature_Swiftness
-- Hand of Edward the Odd: Spell_Holy_SearingLight
-- Divine Protection (paladin 'bubble' aura): Spell_Holy_Restoration
-- Curse of the Deadwood: Spell_Shadow_GatherShadows

-- Returns the modifier to healing (a factor between 1 and 0) caused by debuffs (and buffs)
function QuickHeal_GetHealDebuff(Target)
    local HealDebuff = 1;
    -- Detect if Curse of the Deadwood is active (reduces healing by 50%)
    if QuickHeal_DetectDebuff(Target,"Spell_Shadow_GatherShadows") then
        debug("DEBUFF: Curse of the Deadwood (-50%)");
        HealDebuff = HealDebuff * 0.5;
    end
    -- Detect if Mortal Strike (warrior talent) is active (reduces healing by 50%)
    if QuickHeal_DetectDebuff(Target,"Ability_Warrior_SavageBlow") then
        debug("DEBUFF: Mortal Strike (-50%)");
        HealDebuff = HealDebuff * 0.5;
    end
    -- Detect if Blood Fury (Orc Racial) is active (reduces healing by 50%)
    if QuickHeal_DetectDebuff(Target,"Ability_Rogue_FeignDeath") then
        debug("DEBUFF: Blood Fury (-50%)");
        HealDebuff = HealDebuff * 0.5;
    end
    return HealDebuff;
end

--[ Healing related helper functions ]--

-- Returns true if the unit is blacklisted (because it could not be healed)
-- Note that the parameter is the name of the unit, not 'party1', 'raid1' etc.
local function IsBlacklisted(unitname)
    local CurrentTime = GetTime()
    if CurrentTime < LastBlackListTime then
        -- Game time info has overrun, clearing blacklist to prevent permanent bans
        BlackList = {};
        LastBlackListTime = 0;
    end
    if (BlackList[unitname] == nil) or BlackList[unitname] < CurrentTime then return false
    else return true
    end
end

-- Returns true if the player is in a raid group
local function InRaid()
	if GetNumRaidMembers() > 0 then
		return true
    else
        return false
	end
end

-- Returns true if the player is in a party or a raid
local function InParty()
	if GetNumPartyMembers() > 0 then
		return true
    else
        return false
	end
end

-- Returns true if the unit is not in party or raid and is not a partymembers pet
local function UnitIsExternal(unit)

    if not unit then return true end -- Protection

    local i;
    if InRaid() and not ForceParty then
        -- In raid and healing of everyone in raid enabled
        for i=1,40 do if UnitIsUnit("raidpet"..i,unit) or UnitIsUnit("raid"..i,unit) then return false end end
    else
        -- Not in raid or healing restricted to local party
        if UnitInParty(unit) or UnitIsUnit("pet",unit) then return false end;
        for i=1,4 do
            if (UnitIsUnit("partypet"..i,unit)) then return false end
        end
    end
    return true;
end

-- Returns true if health information is available for the unit
function QuickHeal_UnitHasHealthInfo(unit)
    local i;

    if not unit then return false end -- Protection

    if InRaid() then
        -- In raid
        for i=1,40 do if UnitIsUnit("raidpet"..i,unit) or UnitIsUnit("raid"..i,unit) then return true end end
    else
        -- Not in raid
        if UnitInParty(unit) or UnitIsUnit("pet",unit) then return true end;
        for i=1,4 do
            if (UnitIsUnit("partypet"..i,unit)) then return true end
        end
    end
    return false;
end

-- Only used by UnitIsHealable
local function EvaluateUnitCondition(unit,condition,debugText,explain)
    if not condition then
        if explain then debug(unit, debugText) end
        return true
    else
        return false
    end
end

-- Return true if the unit is healable by player
local function UnitIsHealable(unit,explain)
    if UnitExists(unit) then
        if EvaluateUnitCondition(unit, UnitIsFriend('player', unit), "is not a friend",explain) then return false end
        if EvaluateUnitCondition(unit, not UnitIsEnemy(unit, 'player'), "is an enemy",explain) then return false end
        --if EvaluateUnitCondition(unit, not UnitCanAttack(unit, 'player'), "can attack player") then return false end
        if EvaluateUnitCondition(unit, not UnitCanAttack('player', unit), "can be attacked by player",explain) then return false end
        --if EvaluateUnitCondition(unit, unit == 'player' or UnitCanCooperate('player', unit), "cannot cooperate with player") then return false end
        if EvaluateUnitCondition(unit, UnitIsConnected(unit), "is not connected",explain) then return false end
        if EvaluateUnitCondition(unit, not UnitIsDeadOrGhost(unit), "is dead or ghost",explain) then return false end
        if EvaluateUnitCondition(unit, UnitIsVisible(unit), "is not visible to client",explain) then return false end
    else return false
    end
    return true
end

-- Return a list of spell id's for the given spell name
function QuickHeal_GetSpellIDs(spellName)
    local i = 1;
    local List = {};
    local spellNamei, spellRank;

    while true do
        spellNamei,spellRank = GetSpellName(i, BOOKTYPE_SPELL);
        if not spellNamei then return List end

        _, _, spellRank = string.find(spellRank, "^" .. QUICKHEAL_SPELL_RANK .. " (%d+)");
        spellRank = tonumber(spellRank);

        if spellNamei == spellName then
            List[spellRank] = i;
        end
        i = i + 1;
    end
end

-- Returns an estimate of the units heal need for external units
function QuickHeal_EstimateUnitHealNeed(unit,report)
    -- Estimate target health
    local HealthPercentage = UnitHealth(unit);
    if not HealthPercentage then HealthPercentage = 0 end -- Protect against missing info
    HealthPercentage = HealthPercentage/100;
    local _,Class = UnitClass(unit);
    Class = Class or "unknown"; -- Protect against missing info
    MaxHealthTab = {warrior=4100,
                    paladin=4000,
                    shaman=3500,
                    rogue=3100,
                    hunter=3100,
                    druid=3100,
                    warlock=2300,
                    mage=2200,
                    priest=2100};
    local MaxHealth = MaxHealthTab[string.lower(Class)];
    if not MaxHealth then MaxHealth = 4000 end -- Protect against missing info or unknown classes
    local Level = UnitLevel(unit);
    if not Level then Level = 60 end -- Protect against missing info
    local HealNeed = (1-HealthPercentage)*MaxHealth*Level/60;
    if report then debug("Estimated healing needed for level " .. Level .. " " .. Class .. " with " .. HealthPercentage*100 .. " percent life",HealNeed) end
    return HealNeed;
end

local function FindWhoToHeal()
    local selfPercentage = UnitHealth('player') / UnitHealthMax('player');
    local playerIds;
    local petIds;
    local AllPlayersAreFull = true;
    local AllPetsAreFull = true;

    -- Heal Self
    if ForceSelf then
        debug("********** Heal Self **********");
        if selfPercentage < QHV.RatioFull then
            return 'player';
        else
            return nil;
        end
    end

    -- Heal Target
    if ForceTarget then
        debug("********** Heal Target **********");
        if UnitIsHealable('target',true) then
            local targetPercentage;
            if UnitHasHealthInfo('target') then
                targetPercentage = UnitHealth('target') / UnitHealthMax('target');
            else
                targetPercentage = UnitHealth('target') / 100;
            end
            if targetPercentage < QHV.RatioFull then
                return 'target';
            end
        end
        return nil;
    end

    -- Heal Target's Target
    if ForceTargetTarget then
        debug("********** Heal Target's Target **********");
        if UnitIsHealable('targettarget',true) then
            local targetPercentage;
            if UnitHasHealthInfo('targettarget') then
                targetPercentage = UnitHealth('targettarget') / UnitHealthMax('targettarget');
            else
                targetPercentage = UnitHealth('targettarget') / 100;
            end
            if targetPercentage < QHV.RatioFull then
                return 'targettarget';
            end
        end
        return nil;
    end

    -- Self Preservation
    if selfPercentage <= QHV.RatioForceself then
        debug("********** Self Preservation **********");
        return 'player';
    end


    -- Target Self
    if QHV.TargetSelf and UnitIsUnit('player','target') and selfPercentage < QHV.RatioFull then
        debug("********** Target Self **********");
        return 'player';
    end

    -- Heal or Heal Party
    if (InRaid() and not ForceParty) then
        debug("********** Heal **********");
        playerIds = {raid1 = 1, raid2 = 2, raid3 = 3, raid4 = 4, raid5 = 5, raid6 = 6, raid7 = 7, raid8 = 8, raid9 = 9, raid10 = 10,
                     raid11  = 11 , raid12  = 12, raid13  = 13, raid14  = 14, raid15  = 15, raid16  = 16, raid17 = 17, raid18 = 18, raid19 = 19, raid20 = 20,
                     raid21 = 21, raid22 = 22, raid23 = 23, raid24 = 24, raid25 = 25, raid26 = 26, raid27 = 27, raid28 = 28, raid29 = 29, raid30 = 30,
                     raid31 = 31, raid32 = 32, raid33 = 33, raid34 = 34, raid35 = 35, raid36 = 36, raid37 = 37, raid38 = 38, raid39 = 39, raid40 = 40};
        petIds    = {raidpet1 = 1, raidpet2 = 2, raidpet3 = 3, raidpet4 = 4, raidpet5 = 5, raidpet6 = 6, raidpet7 = 7, raidpet8 = 8, raidpet9 = 9, raidpet10 = 10,
                     raidpet11 = 11, raidpet12 = 12, raidpet13 = 13, raidpet14 = 14, raidpet15 = 15, raidpet16 = 16, raidpet17 = 17, raidpet18 = 18, raidpet19 = 19, raidpet20 = 20,
                     raidpet21 = 21, raidpet22 = 22, raidpet23 = 23, raidpet24 = 24, raidpet25 = 25, raidpet26 = 26, raidpet27 = 27, raidpet28 = 28, raidpet29 = 29, raidpet30 = 30,
                     raidpet31 = 31, raidpet32 = 32, raidpet33 = 33, raidpet34 = 34, raidpet35 = 35, raidpet36 = 36, raidpet37 = 37, raidpet38 = 38, raidpet39 = 39, raidpet40 = 40};
    else
        debug("********** Heal Party **********");
        playerIds = {player = 0, party1 = 1, party2 = 2, party3 = 3, party4 = 4};
        petIds = {pet = 0, partypet1 = 1, partypet2 = 2, partypet3 = 3, partypet4 = 4};
    end

    local healingTarget = nil;
    local healingTargetHealth = 1;

    -- Examine Players
    for i in playerIds do
        if UnitIsHealable(i,true) then
            if not IsBlacklisted(UnitName(i)) then
                debug(string.format("%s (%s) : %d/%d",UnitName(i),i,UnitHealth(i),UnitHealthMax(i)));
                local Health = UnitHealth(i) / UnitHealthMax(i);
                if Health < QHV.RatioFull then
                    if Health < healingTargetHealth then
                        healingTarget = i;
                        healingTargetHealth = Health;
                        AllPlayersAreFull = false;
                    end
                end
            else
                debug(UnitName(i) .. " (" .. i .. ")","is blacklisted");
            end
        end
    end

    -- Examine Pets
    if QHV.PetPriority > 0 then
        for i in petIds do
            if UnitIsHealable(i,true) then
                if not IsBlacklisted(UnitName(i)) then
                    debug(string.format("%s (%s) : %d/%d",UnitName(i),i,UnitHealth(i),UnitHealthMax(i)));
                    local Health = UnitHealth(i) / UnitHealthMax(i);
                    if Health < QHV.RatioFull then
                        if ((QHV.PetPriority == 1) and AllPlayersAreFull) or (QHV.PetPriority == 2) or UnitIsUnit(i,"target") then
                            if Health < healingTargetHealth then
                                healingTarget = i;
                                healingTargetHealth = Health;
                                AllPetsAreFull = false;
                            end
                        end
                    end
                else
                    debug(UnitName(i) .. " (" .. i .. ")","is blacklisted");
                end
            end
        end
    end

    -- Examine External Target
    if AllPlayersAreFull and (AllPetsAreFull or QHV.PetPriority == 0) then
        if UnitIsExternal('target') and UnitIsHealable('target',true) then
            debug(string.format("%s (%s) : %d/%d",UnitName('target'),'target',UnitHealth('target'),UnitHealthMax('target')));
            local Health;
            if UnitHasHealthInfo('target') then
                Health = UnitHealth('target') / UnitHealthMax('target');
            else
                Health = UnitHealth('target') / 100;
            end
            if Health < QHV.RatioFull then
                return 'target';
            end
        end
    end

    return healingTarget;
end

function Notification(unit, spellName)
    local unitName = UnitName(unit);
    local rand = math.random(1,10);
    local read;
    local _,race = UnitRace('player');
    race = string.lower(race);

    if race == "scourge" then
        rand = math.random(1,7);
    end

    if race == "human" then
        rand = math.random(1,7);
    end

    if race == "dwarf" then
        rand = math.random(1,7);
    end

    -- If Normal notification style is selected override random number (also if healing self)
    if QHV.NotificationStyle == "NORMAL" or UnitIsUnit('player',unit) then
        rand = 0;
    end

    if rand == 0 then read = string.format(QHV.NotificationTextNormal, unitName, spellName) end
    if rand == 1 then read = string.format("%s is looking pale, gonna heal you with %s.", unitName, spellName) end
    if rand == 2 then read = string.format("%s doesn't look so hot, healing with %s.", unitName, spellName) end
    if rand == 3 then read = string.format("I know it's just a flesh wound %s, but I'm healing you with %s.", unitName, spellName) end
    if rand == 4 then read = string.format("Oh great, %s is bleeding all over, %s should take care of that.", unitName, spellName) end
    if rand == 5 then read = string.format("Death is near %s... or is it? Perhaps a heal with %s will keep you with us.", unitName, spellName) end
    if rand == 6 then read = string.format("%s, lack of health got you down? %s to the rescue!", unitName, spellName) end
    if rand == 7 then read = string.format("%s is being healed with %s.", unitName, spellName) end
    if race == "orc" then
        if rand == 8 then read = string.format("Zug Zug %s with %s.", unitName, spellName) end
        if rand == 9 then read = string.format("Loktar! %s is being healed with %s.", unitName, spellName) end
        if rand == 10 then read = string.format("Health gud %s, %s make you healthy again!", unitName, spellName) end
    end
    if race == "tauren" then
        if rand == 8 then read = string.format("By the spirits, %s be healed with %s.", unitName, spellName) end
        if rand == 9 then read = string.format("Ancestors, save %s with %s.", unitName, spellName) end
        if rand == 10 then read = string.format("Your noble sacrifice is not in vain %s, %s will keep you in the fight!", unitName, spellName) end
    end
    if race == "troll" then
        if rand == 8 then read = string.format("Whoa mon, doncha be dyin' on me yet! %s is gettin' %s'd.", unitName, spellName) end
        if rand == 9 then read = string.format("Haha! %s keeps dyin' an da %s voodoo, keeps bringin' em back!.", unitName, spellName) end
        if rand == 10 then read = string.format("Doncha tink the heal is comin' %s, %s should keep ya' from whinin' too much!", unitName, spellName) end
    end
    if race == "night elf" then
        if rand == 8 then read = string.format("Asht'velanon, %s! Elune sends you the gift of %s.", unitName, spellName) end
        if rand == 9 then read = string.format("Remain vigilent %s, the Goddess' %s shall revitalize you!", unitName, spellName) end
        if rand == 10 then read = string.format("By Elune's grace I grant you this %s, %s.", spellName, unitName) end
    end

    -- Check if NotificationChannelName exists as a channel
    local ChannelNo,ChannelName = GetChannelName(QHV.NotificationChannelName);

    if QHV.NotificationChannel and ChannelNo ~= 0 and ChannelName then
        SendChatMessage(read, "CHANNEL", nil, ChannelNo);
    elseif QHV.NotificationRaid and InRaid() then
        SendChatMessage(read, "RAID");
    elseif QHV.NotificationParty and InParty() and not InRaid() then
        SendChatMessage(read, "PARTY");
    end

    if QHV.NotificationWhisper and not UnitIsUnit('player',unit) and UnitIsPlayer(unit) then
        SendChatMessage(string.format(QHV.NotificationTextWhisper,spellName), "WHISPER", nil, unitName);
    end

end

local function Heal(Target,SpellID)
    local TargetWasChanged = false;

    -- Start monitoring events on the target (out of range, not in line-of-sight, healing from others)
    StartMonitor(Target);

    -- If the current target is healable, take special measures
    if UnitIsHealable('target') then
        -- If the healing target is targettarget change current target to targettarget
        if Target == 'targettarget' then
            local old = UnitName('target');
            TargetUnit('targettarget');
            Target = 'target';
            TargetWasChanged = true;
            debug("Healable target preventing healing, temporarily switching target to target's target",old,'-->',UnitName('target'));
        end

        -- If healing target is not the current target clear the target
        if not (Target == 'target') then
            debug("Healable target preventing healing, temporarily clearing target",UnitName('target'));
            ClearTarget();
            TargetWasChanged = true;
        end
    end

    -- Get spell info
    local SpellName, SpellRank = GetSpellName(SpellID, BOOKTYPE_SPELL);
    local SpellNameAndRank = SpellName .. " (" .. SpellRank .. ")";

    -- Clear any pending spells
    if SpellIsTargeting() then SpellStopTargeting() end

    -- Cast the spell
    CastSpell(SpellID, BOOKTYPE_SPELL);

    -- The spell is awaiting target selection, write to screen if the spell can actually be cast
    if SpellCanTargetUnit(Target) or (Target == 'target') then

        Notification(Target, SpellNameAndRank);

        -- Write to center of screen
        if UnitIsUnit(Target,'player') then
            Message(string.format("Casting %s on yourself", SpellNameAndRank),"Healing",3)
        else
            Message(string.format("Casting %s on %s",SpellNameAndRank,UnitName(Target)),"Healing",3)
        end
    end

    -- Assign the target of the healing spell
    SpellTargetUnit(Target);

    debug("  Casting: " .. SpellNameAndRank .. " on " .. UnitName(Target) .. " (" .. Target .. ")" .. ", ID: " .. SpellID);

    -- just in case something went wrong here (Healing people in duels!)
    if SpellIsTargeting() then
        StopMonitor("Spell cannot target HealingTarget");
        SpellStopTargeting();
    end

    -- Reacquire target if it was cleared earlier
    if TargetWasChanged then
        local old = UnitName('target') or "None";
        TargetLastTarget();
        debug("Reacquired previous target",old,'-->',UnitName('target'));
    end
end

function QuickHeal_Command(msg)

    local cmd = string.lower(msg)

    -- Is healing in progress? Overheal ?
    if HealingTarget then
        if MassiveOverhealInProgress then
            debug("Massive overheal aborted.");
            SpellStopCasting();
            return;
        else
            debug("Healing in progress, command ignored");
            return;
        end
    end

    if cmd == "listplayereffects" then
        QuickHeal_ListUnitEffects('player');
        return;
    end

    if cmd == "listtargeteffects" then
        QuickHeal_ListUnitEffects('target');
        return;
    end

    if cmd == "cfg" then
        QuickHeal_ToggleConfigurationPanel();
        return;
    end

    if cmd == "debug on" then
        QHV.DebugMode = true;
        writeLine(modname .. " debug mode enabled",0,0,1);
        return;
    end

    if cmd == "debug off" then
        QHV.DebugMode = false;
        writeLine(modname .. " debug mode disabled",0,0,1);
        return;
    end

    if cmd == "reset" then
        QuickHeal_SetDefaultParameters();
        writeLine(modname .. " reset to default configuration",0,0,1);
        QuickHeal_ToggleConfigurationPanel();
        QuickHeal_ToggleConfigurationPanel();
        return;
    end

    -- Parse force-commands
    ForceSelf = false;
    ForceTarget = false;
    ForceTargetTarget = false;
    ForceParty = false;
    if cmd == "self" then
        ForceSelf = true;
    elseif cmd == "target" then
        if UnitExists('target') then
            ForceTarget = true;
        else
            Message("You don't have a target","Error",2);
            return;
        end
    elseif cmd == "targettarget" then
        if not UnitExists('target') then
            Message("You don't have a target","Error",2);
            return;
        elseif not UnitExists('targettarget') then
            local TargetName = UnitName('target') or "Target";
            Message(TargetName .. " doesn't have a target","Error",2);
            return;
        else
            ForceTargetTarget = true;
        end
    elseif cmd == "party" then
        ForceParty = true;
    end

    -- Parse healing command
    if ForceSelf or ForceTarget or ForceTargetTarget or ForceParty or cmd == "" then
        local Target = FindWhoToHeal();
        if Target then
            debug(string.format("  Healing target: %s (%s)", UnitName(Target), Target));
            local SpellID
            SpellID,HealingSpellSize = FindSpellToUse(Target);
            if SpellID then
                Heal(Target,SpellID);
            else
                Message("You have no healing spells to cast","Error",2);
            end
        else -- No healing target found
            if ForceSelf then
                Message("You don't need healing","Info",2);
            elseif ForceTarget then
                local TargetName = UnitName('target') or "Target";
                if not UnitIsHealable('target') then
                    Message(TargetName .. " cannot be healed","Error",2);
                else
                    Message(TargetName .. " doesn't need healing","Info",2);
                end
            elseif ForceTargetTarget then
                local TargetName = UnitName('target') or "Target";
                local TargetTargetName = UnitName('targettarget') or "Unknown";
                if not UnitIsHealable('targettarget') then
                    Message(TargetName .. "'s Target (" .. TargetTargetName .. ") cannot be healed","Error",2);
                else
                    Message(TargetName .. "'s Target (" .. TargetTargetName .. ") doesn't need healing","Info",2);
                end
            elseif InParty() or InRaid() then
                Message("No one needs healing","Info",2);
            else
                Message("You don't need healing","Info",2);
            end
        end
        return;
    end

    -- Print usage information
    writeLine(modname .. " Usage:");
    writeLine("/qh - Heals the party member that most need it with the best suited healing spell.");
    writeLine("/qh self - Forces the target of the healing to be yourself.");
    writeLine("/qh target - Forces the target of the healing to be your current target.");
    writeLine("/qh targettarget - Forces the target of the healing to be your current target's target.");
    writeLine("/qh party - Restricts the healing to the party, even when in a raid.");
    writeLine("/qh cfg - Opens up the configuration panel.");
    writeLine("/qh reset - Reset configuration to default parameters for all classes.");
    writeLine("/qh listplayereffects - List all buffs/debuffs on the player.");
    writeLine("/qh listtargeteffects - List all buffs/debuffs on the current target.");
end
