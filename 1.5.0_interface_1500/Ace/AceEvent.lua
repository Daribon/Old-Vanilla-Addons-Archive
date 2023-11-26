
local register = AceDbClass:new()

-- Class creation
AceEventClass = AceCoreClass:new()

function AceEventClass:OnLoad()
    self.frame = this
    ace.state  = AceStateClass:new()
    self:RegisterEvent(ace.state, "VARIABLES_LOADED")
end

function AceEventClass:EventHandler()
    local addon, method

    if( event and register:get(event) ) then
        for addon, method in register:get(event) do
            if( addon[method] ) then addon[method](addon) end
        end
    end
end

function AceEventClass:RegisterEvent(addon, event, method)
    if( not register:get(event) ) then
        self.frame:RegisterEvent(event)
    end

    register:set({event}, addon, (method or event))
end

function AceEventClass:UnregisterEvent(obj, event)
    if( register:get({event}, obj) ) then
        register:set({event}, obj)
    end
end

function AceEventClass:UnregisterAllEvents(obj)
    local event

    for event in register:get() do
        self:UnregisterEvent(obj, event)
    end
end

ace.event = AceEventClass:new()
