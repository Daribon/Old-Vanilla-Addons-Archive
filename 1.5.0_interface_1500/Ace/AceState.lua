
ace.registry = AceDbClass:new()

-- Use a temporary Ace object to ensure we don't overwrite base class methods below.
local _ace = AceClass:new()
local STATE_REGISTRY  = {}

-- Class creation
AceStateClass = AceCoreClass:new({fVer=0,gVer=0})


--[[--------------------------------------------------------------------------------
  State and Util Registering
-----------------------------------------------------------------------------------]]

function AceStateClass:RegisterForLoad(addon)
    ace.registry:set(addon.name, addon)
    tinsert(STATE_REGISTRY, addon)
end

function AceStateClass:RegisterFunctions(class, utils)
    if( not utils ) then utils = class; class = nil end
    local ver, name, val = ace.tonum(utils.version)
    -- Clear the version so it doesn't get registered.
    utils.version = nil
    for name, val in utils do
        if( (not _ace[name]) and ((ver > self.fVer) or (not ace[name])) ) then
            ace[name] = nil
            ace[name] = val
        end
        if( class ) then class[name] = ace[name] end
    end
    self.fVer = ace.ternary(ver > self.fVer, ver, self.fVer)
    utils = nil
end

function AceStateClass:RegisterGlobals(globals)
    local ver, name, val = ace.tonum(globals.version)
    -- Clear the version so it doesn't get registered.
    globals.version = nil
    for name, val in globals do
        if( (ver > (self.gVer or 0)) or (not getglobal(name)) ) then
            setglobal(name,val)
        end
    end
    self.gVer = ace.ternary(ver > (self.gVer or 0), ver, self.gVer)
    globals = nil
end


--[[--------------------------------------------------------------------------------
  State and Addon Initialization
-----------------------------------------------------------------------------------]]

function AceStateClass:SetGameState()
    if( ace.char ) then return TRUE end

    local charName, charClass = UnitName("player"), UnitClass("player")
    -- Check for valid name and class just for added assurance.
    if( (charName  == UNKNOWNOBJECT) or (charName  == nil) or
        (charClass == UNKNOWNOBJECT) or (charClass == nil)
      ) then
        return FALSE
    end

    -- I've seen at least one occurance where GetCVar("realmName") returned an extra
    -- space on the end (e.g., "Archimonde "). So trim everything just to be safe.
    local realmName = ace.trim(GetCVar("realmName"))
    charName  = ace.trim(charName)
    charClass = ace.trim(charClass)

    ace.char = {
        realm   = realmName,
        name    = charName,
        id      = charName.." "..ACE_TEXT_OF.." "..realmName,
        class   = charClass,
        race    = ace.trim(UnitRace("player")),
        faction = ace.trim(UnitFactionGroup("player")), -- according to Wiki this doesn't localize. :(
        sex     = ace.trim(UnitSex("player"))
    }

    ace.db:Initialize()
    ace.cmd:Register()

    return TRUE
end

function AceStateClass:InitializeState()
    if( (not self._varsLoaded) or (not self:SetGameState()) ) then return FALSE end

    self:InitializeDatabases()
    if( not ace.db.profileName ) then ace.db:LoadCurrentProfile() end

    ace.addonCnt = getn(STATE_REGISTRY)
    if( ace.addonCnt > 0 ) then
        self:InitializeAddons()
        if( ace.db:GetOpt("loadMsg") ~= "none" ) then self:DisplayLoadMsgSummary() end
    end

    ace.event:UnregisterEvent(self, "VARIABLES_LOADED")
    STATE_REGISTRY = nil

    return TRUE
end

function AceStateClass:InitializeDatabases()
    local _, addon
    for _, addon in ipairs(STATE_REGISTRY) do
        if( addon.db and (not addon.db.failed) and (not addon.db.initialized) ) then
            self:RegisterAddon(addon)
            addon.db.failed = TRUE
            addon.db.addon  = addon
            addon.db:Initialize()
            addon.db.failed = FALSE
        end
    end
end

function AceStateClass:InitializeAddons()
    local _, addon
    for _, addon in ipairs(STATE_REGISTRY) do
        if( (not addon.failed) and (not addon.initialized) ) then
            addon.failed      = TRUE
            self:InitializeAddon(addon)
            addon.failed      = FALSE
            addon.initialized = TRUE
        end
    end
end

function AceStateClass:InitializeAddon(addon)
    if( addon.db ) then
        addon.disabled = addon.db:get(addon.profilePath, "disabled")
        if( addon.disabled ) then ace.disabledCnt = ace.disabledCnt + 1 end
    end

    if( addon.cmd ) then addon.cmd.addon=addon end
    if( addon.Initialize ) then addon.Initialize(addon) end
    if( addon.cmd and (not addon.cmd.registered) ) then
        addon.cmd:Register(addon)
    end
    if( (not addon.disabled) and addon.Enable ) then addon.Enable(addon) end

    -- Check Ace compatibility.
    local compat = ""
    if( ace:Compatability(addon.aceCompatible) ~= 0 ) then
        compat = ACE_VERSION_MISMATCH
        addon.aceMismatch = TRUE
        ace.mismatchCnt = ace.mismatchCnt + 1
    end

    if( ace.db:GetOpt("loadMsg") == "addon" ) then
        self:DisplayLoadMsgAddon(addon, compat)
    end
end

function AceStateClass:DisplayLoadMsgSummary(addon)
    local disabledMsg = ""
    local mismatchMsg = ""
    if( ace.disabledCnt > 0 ) then
        disabledMsg = format(ACE_LOAD_MSG_DISABLED, ace.disabledCnt)
    end
    if( ace.mismatchCnt > 0 ) then
        mismatchMsg = format(ACE_INFO_MISMATCH, ace.mismatchCnt)
    end
    ace:print(format(ACE_LOAD_MSG_SUMMARY,
                     mismatchMsg,
                     ace.addonCnt,
                     disabledMsg,
                     ace.db.profileName
                    )
             )
end

function AceStateClass:DisplayLoadMsgAddon(addon, compat)
    local cmdMsg = ""
    if( addon.cmd ) then
        cmdMsg = format(ACE_ADDON_CHAT_COMMAND, (addon.cmd.commands[2] or addon.cmd.commands[1]))
    end
    ace:print(ace.ternary(addon.disabled, ACE_ADDON_DISABLED.." ", ""),
              format(ACE_ADDON_LOADED, addon.name, addon.version, addon.author),
              " ", cmdMsg, " ", compat
             )
end

-- Register the application configuration with myAddOns so that it will be listed
-- in the myAddOns menu.
function AceStateClass:RegisterAddon(addon)
    if( myAddOnsList ) then
        myAddOnsList[addon.name] = {
            name         = addon.name,
            description  = addon.description,
            version      = addon.version,
            category     = getglobal("ACE_CATEGORY_"..strupper(addon.category or "")),
            frame        = "TRUE",
            optionsframe = addon.optionsFrame
        }
    end
end


--[[--------------------------------------------------------------------------------
  Events
-----------------------------------------------------------------------------------]]

function AceStateClass:VARIABLES_LOADED()
    self._varsLoaded = TRUE
end
