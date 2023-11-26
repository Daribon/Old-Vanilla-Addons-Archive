
-- Class creation
AceAddonClass = AceCoreClass:new()


--[[--------------------------------------------------------------------------
  Register For Load With AceState
-----------------------------------------------------------------------------]]

function AceAddonClass:RegisterForLoad()
    ace.state:RegisterForLoad(self)
end


--[[--------------------------------------------------------------------------
  Event Registering
-----------------------------------------------------------------------------]]

function AceAddonClass:RegisterEvent(event, method)
    ace.event:RegisterEvent(self, event, method)
end

function AceAddonClass:UnregisterEvent(event)
    ace.event:UnregisterEvent(self, event)
end

function AceAddonClass:UnregisterAllEvents()
    ace.event:UnregisterAllEvents(self)
end


--[[--------------------------------------------------------------------------
   Function Hooking
-----------------------------------------------------------------------------]]

function AceAddonClass:HookFunction(func, method, nocall)
    ace.hook:HookFunction(self, func, method, nocall)
end

function AceAddonClass:UnhookFunction(func)
    ace.hook:UnhookFunction(self, func)
end

function AceAddonClass:UnhookAllFunctions(func)
    ace.hook:UnhookAllFunctions(self, func)
end

function AceAddonClass:CallHook(...)
    return ace.hook:CallHook(self, unpack(arg))
end


--[[--------------------------------------------------------------------------
  Addon Enabling/Disabling
-----------------------------------------------------------------------------]]

function AceAddonClass:EnableAddon()
    if( not self.disabled ) then
        self.cmd:result(format(ACE_ADDON_ALREADY_ENABLED, self.name))
        return
    end
    if( not self.Enable ) then return end

    self.disabled = FALSE
    if( ace.disabledCnt > 0 ) then ace.disabledCnt = ace.disabledCnt - 1 end
    if( self.db ) then self.db:set(self.profilePath, "disabled") end
    self:Enable()
    self.cmd:result(format(ACE_ADDON_NOW_ENABLED, self.name))
end

function AceAddonClass:DisableAddon()
    if( self.disabled ) then
        self.cmd:result(format(ACE_ADDON_ALREADY_DISABLED, self.name))
        return
    end
    -- If no Enable then the addon is not setup for enable/disable
    if( not self.Enable ) then return end

    self.disabled = TRUE
    ace.disabledCnt = ace.disabledCnt + 1
    if( self.db ) then self.db:set(self.profilePath, "disabled", TRUE) end

    self:UnregisterAllEvents()
    self:UnhookAllFunctions()

    if( self.Disable ) then self:Disable() end
    self.cmd:result(format(ACE_ADDON_NOW_DISABLED, self.name))
end
