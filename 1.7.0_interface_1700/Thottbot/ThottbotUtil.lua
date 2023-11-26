-- Various functions written by Thott, for Thottbot, placed here for earlier
-- loading and use by other Cosmos developers.

-- Moved into Sea
-- -- HookFunction("some_blizzard_function","my_function","before|after|hide")
-- -- calls "my_function" before/after "some_blizzard_function".
-- -- if type is "hide", calls "my_function" before all others, and only continues if it returns true
-- -- This method is used so the hook can be later undone without screwing up someone else's later hook.
-- function HookFunction(orig,new,type)
--   if(not type) then
--     type = "before";
--   end
--   dprint("Hooking ",orig," to ",new,", type ",type);
--   if(not Hooks) then
--     Hooks = {};
--   end
--   if(not Hooks[orig]) then
--     Hooks[orig] = {};
--     Hooks[orig].before = {};
--     Hooks[orig].before.n = 0;
--     Hooks[orig].after = {};
--     Hooks[orig].after.n = 0;
--     Hooks[orig].hide = {};
--     Hooks[orig].hide.n = 0;
--     Hooks[orig].orig = getglobal(orig);
--   else
--     for key,value in Hooks[orig] do
--       if(key == new) then
-- 	dprint("already hooked ",new,", skipping");
-- 	return;
--       end
--     end
--   end
--   -- intentionally will error if bad type is passed
--   push(Hooks[orig][type],getglobal(new));
--   setglobal(orig,function(...) HookHandler(orig,arg); end);
-- end
-- -- same format as HookFunction
-- function UnHookFunction(orig,new,type)
--   if(not type) then
--     type = "before";
--   end
--   local l,g;
--   l = Hooks[orig][type];
--   g = getglobal(new);
--   for key,value in l do
--     if(value == g) then
--       l[key] = nil;
--       dprint("found and unhooked ",new);
--       return;
--     end
--   end
-- end
-- -- AfterInit(function,arg,arg...)
-- -- calls a function (with arguments) once the client is fully initialized.  
-- -- In this case, "fully initialized" means UnitName("player") != "Unknown Being"
-- -- MOVED to CosmosSchedule
-- --function AfterInit(func,...)
-- --  if(UnitName("player") and UnitName("player") ~= "Unknown Being") then
-- --    func(unpack(arg));
-- --  else
-- --    Cosmos_Schedule(0.2,AfterInit,func,unpack(arg));
-- --  end
-- --end
function dbanner(...)
  if(Thottbot.Debug) then
    UIErrorsFrame:AddMessage(join(arg,""), 0.9, 0.9, 0.0, 1.0, UIERRORS_HOLD_TIME);			  					
    dprint(join(arg,""));
  end
end
function banner(...)
  UIErrorsFrame:AddMessage(join(arg,""), 0.9, 0.9, 0.0, 1.0, UIERRORS_HOLD_TIME);			  					
end
function dbyte(c)
  return string.format("<%02X>",string.byte(c));
end
function dprint_runqueue()
  local counter = 10;
  while(counter > 0) do
    counter = counter - 1;
    print2(dprint_queue[dprint_queue_i]);
    dprint_queue_i = dprint_queue_i+1;
    if(dprint_queue_i > dprint_queue.n) then
      dprint_queue = nil;
      return true;
    end
  end
end
function dprint(...)
  if(Thottbot.Debug) then
    local msg = join(arg,"");
    msg = string.gsub(msg,"|","<pipe>");
    msg = string.gsub(msg,"([^%w%s%a%p])",dbyte);
--    if(Thottbot.DebugFrame) then
--      printframe(Thottbot.DebugFrame,msg);
--    else
--      print2(msg);
--    end
    if(not dprint_queue) then
      dprint_queue = {};
      dprint_queue.n = 0;
      dprint_queue_i = 1;
      Chronos.everyFrame(dprint_runqueue);
    end
    Sea.table.push(dprint_queue,msg);
  end
end
--    Thottbot.PrintCount = Thottbot.PrintCount + 1;
--    if(Thottbot.PrintCount < 60) then
--      for key,value in arg do
--        arg[key] = string.gsub(value,"[^%w%s%p]",".");
--      end
--      print2(Thottbot.PrintCount,":",join(arg,""));
function dprint1(...)
  if(Thottbot.Debug) then
    print1(join(arg,""));
  end
end
function split(s,seperator)
  local t = {};
  t.n = 0;
  for value in string.gfind(s,"[^"..seperator.."]+") do
    t.n = t.n + 1;
    t[t.n] = value;
  end
  return t;
end
function join(list,seperator)
  local i;
  local c = "";
  local msg = "";
  if(not list.n) then
    dbanner("ERROR: no .n variable in list!");
    return "";
  end
  for i=1, list.n, 1 do
    if(list[i]) then
      if(type(list[i]) ~= "string" and type(list[i]) ~= "number") then
        dbanner("found ",type(list[i])," in list!");
        msg = msg .. c .. "(" .. type(list[i]) .. ")";
      else
	msg = msg .. c .. list[i];
      end
    else
      msg = msg .. c .. "(nil)";
    end
    c = seperator;
  end
  return msg;
end
function dprintlist(list)
  if(Thottbot.Debug) then
    if(list) then
      dprint(join(list,","));
    else
      dprint("nil list");
    end
  end
end
function dprintcomma(...)
  dprint(join(arg,","));
end
function printframe(frame,...)
  if(frame) then
    frame:AddMessage(join(arg,""), 1.0, 1.0, 0.0);
  end
end
function print2(...)
  if(ChatFrame2) then
    ChatFrame2:AddMessage(join(arg,""), 1.0, 1.0, 0.0);
  end
end
function print1(...)
  if(ChatFrame1) then
    ChatFrame1:AddMessage(join(arg,""), 1.0, 1.0, 0.0);
  end
end
function push(t,v)
  if(not t or not t.n) then
    dbanner("Bad table passed to push");
    return nil;
  end
  t.n = t.n+1;
  t[t.n] = v;
end
function pop(t)
  if(not t or not t.n) then
    dbanner("Bad table passed to push");
    return nil;
  end
  local v = t[t.n];
  t.n = t.n - 1;
  return v;
end
function push2(t,x,y)
  if(not t or not t.n) then
    dbanner("Bad table passed to push2");
    return nil;
  end
  t.n = t.n+1;
  t[t.n] = x;
  t.n = t.n+1;
  t[t.n] = y;
end
function pop2(t)
  if(not t or not t.n) then
    --dbanner("Bad table passed to pop2");
    return nil;
  end
  if(t.n < 2) then
    return nil;
  end
  local tt = {};
  tt.n = 2;
  tt[1] = t[t.n-1];
  tt[2] = t[t.n];
  t.n = t.n - 2;
  return tt;
end
function fixnil(...)
  for i=1, arg.n, 1 do
    if(not arg[i]) then
      arg[i] = "(nil)";
    end
  end
  return arg;
end
function fixnilempty(...)
  for i=1, arg.n, 1 do
    if(not arg[i]) then
      arg[i] = "";
    end
  end
  return arg;
end
function fixnilzero(...)
  for i=1, arg.n, 1 do
    if(not arg[i]) then
      arg[i] = 0;
    end
  end
  return arg;
end
-- function HookHandler(name,arg)
--   --dprint("HookHandler ",name);
--   local called = false;
--   local continue = true;
--   local retval;
--   for key,value in Hooks[name].hide do
--     if(type(value) == "function") then
--       --dprint("calling before ",name);
--       if(not value(unpack(arg))) then
--         continue = false;
--       end
--       called = true;
--     end
--   end
--   if(not continue) then
--     dprint("hide returned false, aborting call to ",name);
--     return;
--   end
--   for key,value in Hooks[name].before do
--     if(type(value) == "function") then
--       --dprint("calling before ",name);
--       value(unpack(arg));
--       called = true;
--     end
--   end
--   --dprint("calling original ",name);
--   retval = Hooks[name].orig(unpack(arg));
--   for key,value in Hooks[name].after do
--     if(type(value) == "function") then
--       --dprint("calling after ",name);
--       value(unpack(arg));
--       called = true;
--     end
--   end
--   if(not called) then
--     dprint("no hooks left for ",name,", clearing");
--     setglobal(name,Hooks[name].orig);
--     Hooks[name] = nil;
--   end
--   return retval;
-- end
