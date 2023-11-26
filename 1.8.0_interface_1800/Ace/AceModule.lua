
-- Class creation
AceModule = AceCore:new()
-- Compatibility reference, deprecated use
AceModuleClass = AceModule


--[[--------------------------------------------------------------------------
  Event Handling
-----------------------------------------------------------------------------]]

function AceModule:RegisterEvent(event, method)
	ace.event:RegisterEvent(self, event, method)
end

function AceModule:UnregisterEvent(event)
	ace.event:UnregisterEvent(self, event)
end

function AceModule:UnregisterAllEvents()
	ace.event:UnregisterAllEvents(self)
end

function AceModule:TriggerEvent(...)
	ace.event:TriggerEvent(unpack(arg))
end


--[[--------------------------------------------------------------------------
   Function Hooking
-----------------------------------------------------------------------------]]

function AceModule:Hook(...)
	ace.hook:Hook(self, unpack(arg))
end

function AceModule:Unhook(...)
	ace.hook:Unhook(self, unpack(arg))
end

function AceModule:UnhookAll()
	ace.hook:UnhookAll(self)
end

function AceModule:CallHook(...)
	return ace.hook:CallHook(self, unpack(arg))
end


--[[--------------------------------------------------------------------------
   Script Hooking
-----------------------------------------------------------------------------]]

function AceModule:HookScript(t, h, m)
	ace.script:Hook(self, t, h, m)
end

function AceModule:UnhookScript(t, h)
	ace.script:Unhook(self, t, h)
end

function AceModule:UnhookAllScripts()
	ace.script:UnhookAll(self)
end

function AceModule:CallScript(...)
	return ace.script:Call(self, unpack(arg))
end
