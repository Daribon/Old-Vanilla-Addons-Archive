
local registry = {}

--[[---------------------------------------------------------------------------------
  Class Setup
------------------------------------------------------------------------------------]]

AceHook = AceCore:new()


--[[---------------------------------------------------------------------------------
  Class Methods
------------------------------------------------------------------------------------]]

function AceHook:Hook(src, obj, meth, srcMeth, nocall)
	if( type(obj) == "string" ) then
		nocall	= srcMeth
		srcMeth = meth
		meth	= nil
	end
	-- 'srcMeth' is optional so it may either be a method or the 'nocall' value
	if( type(srcMeth) ~= "string" ) then
		nocall  = srcMeth;
		srcMeth = nil
	end
	srcMeth = srcMeth or meth or obj
	if( not src[srcMeth] ) then
		error("'"..srcMeth.."' is not a valid method to redirect to.", 3)
	end

	if( meth ) then
		self:_HookMethod(src, obj, meth, srcMeth, nocall)
	else
		self:_HookFunction(src, obj, srcMeth, nocall)
	end
end

function AceHook:_HookFunction(src, func, srcMeth, nocall)
	if( not registry[func] ) then
		registry[func] = {stack={},hooks={},func=getglobal(func),nocall=0}
	end

	-- Don't multi-hook
	if( registry[func].hooks[src] ) then return end

	setglobal(func, function(...) return src[srcMeth](src, unpack(arg)) end)
	registry[func].hooks[src] = TRUE
	tinsert(registry[func].stack, {obj=src, meth=srcMeth, nocall=nocall})

	if( nocall ) then
		registry[func].nocall = registry[func].nocall + 1
	end
end

function AceHook:_HookMethod(src, obj, meth, srcMeth, nocall)
	local key = tostring(obj)..meth

	if( not registry[key] ) then
		registry[key] = {stack={},hooks={},orig=obj[meth],obj=obj,meth=meth,nocall=0}
	end

	-- Don't multi-hook
	if( registry[key].hooks[src] ) then return end

	-- The first arg, o, is the hooked object and isn't needed.
	obj[meth] = function(o,...) return src[srcMeth](src, unpack(arg)) end
	registry[key].hooks[src] = TRUE
	tinsert(registry[key].stack, {obj=src, meth=srcMeth, nocall=nocall})

	if( nocall ) then
		registry[key].nocall = registry[key].nocall + 1
	end
end

function AceHook:Unhook(src, key, key2)
	if( type(key) ~= "string" ) then key = tostring(key)..key2 end
	if( not registry[key] ) then return end

	local i = ace.TableFindByKeyValue(registry[key].stack, "obj", src)

	if( not i ) then return end

	local def = registry[key]

	if( i == getn(def.stack) ) then
		if( def.obj ) then self:_MethodUnhook(def, key, i)
		else self:_FunctionUnhook(def, key, i)
		end
		def.hooks[src] = nil
	else
		tremove(def.stack, i)
		def.hooks[src] = nil
	end
end

function AceHook:_FunctionUnhook(def, func, i)
	if( i > 1 ) then
		local obj  = def.stack[i-1].obj
		local meth = def.stack[i-1].meth

		setglobal(func, function(...) return obj[meth](obj, unpack(arg)) end)
		if( def.stack[i].nocall ) then def.nocall = def.nocall - 1 end
		tremove(def.stack, i)
	else
		-- If the stack is less than 1, that means it is being emptied out, so
		-- reinstate it and clear it from the hook list.
		setglobal(func, def.func)
		def.nocall = 0
		registry[func] = nil
	end
end

function AceHook:_MethodUnhook(def, key, i)
	if( i > 1 ) then
		local obj  = def.stack[i-1].obj
		local meth = def.stack[i-1].meth

		def.obj[def.meth] = function(o,...)
								return obj[meth](obj, unpack(arg))
							end
		if( def.stack[i].nocall ) then def.nocall = def.nocall - 1 end
		tremove(def.stack, i)
	else
		-- If the stack is less than 1, that means it is being emptied out, so
		-- reinstate it and clear it from the hook list.
		def.obj[def.meth] = def.orig
		def.nocall = 0
		registry[key] = nil
	end
end

function AceHook:UnhookAll(src)
	for key in registry do
		self:Unhook(src, key)
	end
end

function AceHook:CallHook(src, key, ...)
	if( type(key) ~= "string" ) then key = tostring(key)..tremove(arg, 1) end

	local def = registry[key]
	if( not def ) then error("There is no hook to call for "..key..".", 2) end
	local i   = ace.TableFindByKeyValue(registry[key].stack, "obj", src)

	if( ace.tonum(i) > 1 ) then
		return def.stack[i-1].obj[def.stack[i-1].meth](def.stack[i-1].obj, unpack(arg))
	elseif( def.nocall > 0 ) then
		return
	elseif( def.orig ) then
		return def.orig(def.obj, unpack(arg))
	else
		return def.func(unpack(arg))
	end
end

ace.hook = AceHook
