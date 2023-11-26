
local register = AceDbClass:new()


--[[---------------------------------------------------------------------------------
  Class Definition
------------------------------------------------------------------------------------]]

AceHookClass = AceCoreClass:new()


--[[---------------------------------------------------------------------------------
  Class Methods
------------------------------------------------------------------------------------]]

function AceHookClass:HookFunction(object, func, method, nocall)
    -- Order of method, nocall doesn't matter, so if method is TRUE or true, it must
    -- be the nocall value, so swap them.
    if( (method == TRUE) or (method == true) ) then
        method = nocall
        nocall = TRUE
    end

    local sep = strfind(func, "%:")
    if( sep ) then
        self:_MethodHook(object, func, method, sep)
    else
        self:_FunctionHook(object, func, method)
    end

    if( nocall ) then register:set({func}, "nocall", TRUE) end
end

function AceHookClass:_FunctionHook(object, func, method)
    if( not register:get(func) ) then
        register:set(func, {stack={},hooks={},func=getglobal(func)})
    end

    -- Don't multi-hook
    if( register:get({func, "hooks"}, object) ) then return end

    if( not method ) then method = func end
    setglobal(func, function(...) return object[method](object, unpack(arg)) end)
    register:set({func, "hooks"}, object, TRUE)
    register:insert({func}, "stack", {obj=object, meth=method})
end

function AceHookClass:_MethodHook(object, func, method, sep)
    local hobj  = getglobal(strsub(func, 1, sep-1))
    local hmeth = strsub(func, sep+1)

    if( not register:get(func) ) then
        register:set(func, {
            stack = {},
            hooks = {},
            func  = hobj[hmeth],
            obj   = hobj,
            meth  = hmeth
        })
    end

    -- Don't multi-hook
    if( register:get({func, "hooks"}, object) ) then return end

    if( not method ) then method = gsub(func, "%:", "_") end

    -- The first arg, o, is the hooked object and isn't needed.
    hobj[hmeth] = function(o,...) return object[method](object, unpack(arg)) end
    register:set({func, "hooks"}, object, TRUE)
    register:insert({func}, "stack", {obj=object, meth=method})
end

function AceHookClass:UnhookFunction(object, func)
    if( not register:get(func) ) then return end

    local index = self:_FindHookInStack(object, func)

    if( not index ) then return end

    local hook = register:get(func)

    if( index == getn(hook.stack) ) then
        if( hook.obj ) then self:_MethodUnhook(hook, func, index)
        else self:_FunctionUnhook(hook, func, index)
        end
        hook.hooks[object] = nil
    else
        tremove(hook.stack, index)
        hook.hooks[object] = nil
    end
end

function AceHookClass:_FunctionUnhook(hook, func, index)
    if( index > 1 ) then
        local object = hook.stack[index - 1].obj
        local method = hook.stack[index - 1].meth

        setglobal(func, function(...) return object[method](object, unpack(arg)) end)
        tremove(hook.stack, index)
    else
        -- If the stack is less than 1, that means it is being emptied out, so
        -- reinstate it and clear it from the hook list.
        setglobal(func, hook.func)
        register:set(func)
    end
end

function AceHookClass:_MethodUnhook(hook, func, index)
    if( index > 1 ) then
        local object = hook.stack[index - 1].obj
        local method = hook.stack[index - 1].meth

        hook.obj[hook.meth] = function(o,...)
                                return object[method](object, unpack(arg))
                              end
        tremove(hook.stack, index)
    else
        -- If the stack is less than 1, that means it is being emptied out, so
        -- reinstate it and clear it from the hook list.
        hook.obj[hook.meth] = hook.func
        register:set(func)
    end
end

function AceHookClass:UnhookAllFunctions(object)
    local func
    for func in register:get() do
        self:UnhookFunction(object, func)
    end
end

function AceHookClass:CallHook(object, func, ...)
    local hook   = register:get(func)
    local index  = self:_FindHookInStack(object, func)

    if( ace.tonum(index) > 1 ) then
        local obj  = hook.stack[index-1].obj
        local meth = hook.stack[index-1].meth
        return obj[meth](obj, unpack(arg))
    elseif( hook.nocall ) then
        return
    elseif( hook.obj ) then
        return hook.func(hook.obj, unpack(arg))
    else
        return hook.func(unpack(arg))
    end
end

function AceHookClass:_FindHookInStack(object, func)
    local index, hook

    for index, hook in register:get({func}, "stack") do
        if( hook.obj == object ) then return index end
    end
end

ace.hook = AceHookClass:new()
