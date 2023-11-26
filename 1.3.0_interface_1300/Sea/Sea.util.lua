--[[
--
--	Sea.util
--
--	Useful data manipulation functions
--
--	$LastChangedBy: mugendai $
--	$Rev: 1218 $
--	$Date: 2005-03-26 14:12:17 +0100 (Sat, 26 Mar 2005) $
--]]

Sea.util = {

	--[[ Function Hooking ]]--
	
	--
	-- hook( string originalFunctionName, string newFunction, string hooktype )
	--
	-- 	Hooks a function.
	--
	-- 	Example: 
	-- 		hook("some_blizzard_function","my_function","before|after|hide|replace");
	-- 	
	-- 	Calls "my_function" before/after "some_blizzard_function".
	-- 	If type is "hide", calls "my_function" before all others, and only continues if it returns true.
	-- 	If type is "replace", calls "my_function" instead of the origional function, but will also call the origional function afterwards if it returns true.
	--    You can also return a list of values to be returned, but only if you don't return true as the first return.  Ex. return false, { val1, val2 };
	-- 	This method is used so the hook can be later undone without screwing up someone else's later hook.
	--
	hook = function ( original, new, hooktype ) 
		Sea.util.hookFunction( original, new, hooktype);
	end;

	-- 
	-- unhook( string originalFunctionName, string newFunction, string hooktype )
	-- 
	--	Unhooks a function
	--
	--	Example:
	-- 		unhook("some_blizzard_function","my_function","before|after|hide");
	--
	-- 	This will remove a function hooked by hook.
	-- 
	unhook = function ( original, new, hooktype )
		Sea.util.unhookFunction ( original, new, hooktype );
	end;

	--[[ Hyperlinks ]] --
	--
	-- makeHyperlink(string type, string linkText, Table[r,g,b] color)
	--
	-- 	Creates a hyperlink string which is returned to you.
	--
	-- Args:
	--   (string type, string linkText, Table[r,g,b] color, boolean braces, table[left,right] braceString)
	--   type - the Hyperlink type.
	--   linkText - the text shown in the link
	--   color - color of the link
	--   braces - if true, add braces
	--   braceString - table with .left for left brace and .right for right brace
	--
	makeHyperlink = function (type, linkText, color, braces, braceString)
		local link = linkText;
		if ( braces ) then 
			if ( braceString == nil ) then braceString = {}; end
			if ( braceString.left == nil ) then braceString.left="["; end
			if ( braceString.right == nil ) then braceString.right="]"; end

			link = braceString.left..link..braceString.right;
		end
		if (color) then
			link = "|cFF"..color..link.."|r";
		end
		return "|H"..type.."|h"..link.."|h";
	end;
	--[[ Candidates for String ]]--
	
	-- 
	-- join(list,separator)
	--
	-- Arguments: 
	-- 	(table list, String separator)
	-- 	list 	- table of things to join
	-- 	separator 	- the separator to place between objects
	--
	-- Returns:
	-- 	(string joinedstring)
	--	joinedstring - the list.toString() joined by separator(s)
	-- 
	-- Written by Thott (thott@thottbot.com)
	join = function (list, separator)
		-- Type check
		if ( type(list) ~= "table" and type(list) ~= nil ) then 
			ChatFrame1:AddMessage("Non-table passed to Sea.util.join");
			return nil;
		end
		if ( not list.n ) then 
			ChatFrame1:AddMessage("Custom table without .n passed to Sea.util.join");
			return "";
		end
		if ( separator == nil ) then separator = ""; end
		
		local i;
		local c = "";
		local msg = "";
		for i=1, list.n, 1 do
			if(type(list[i]) ~= "nil" ) then
				if(type(list[i]) == "boolean" ) then 
					msg = msg .. c .. "(";
					if ( list[i] ) then
						msg = msg .. "true";
					else
						msg = msg .. "false";
					end
					msg = msg .. ")";
				elseif(type(list[i]) ~= "string" and type(list[i]) ~= "number") then
        				msg = msg .. c .. "(" .. type(list[i]) .. ")";
				else
					msg = msg .. c .. list[i];
				end
			else
				msg = msg .. c .. "(nil)";
			end
				c = separator;
		end
		return msg;		
	end;

	-- 
	-- split(string text, separator )
	--
	-- 	Splits a string into a table by separators
	--
	-- Args:
	-- 	text - string containing input
	-- 	separator - separators
	--
	-- Returns:
	-- 	(table)
	-- 	table - the table containing the exploded strings
	--
	-- Aliases:
	-- 	Sea.string.split
	-- 	Sea.string.explode
	-- 	
	-- Written by Thott (thott@thottbot.com)
	split = function ( text, separator ) 
		local t = {};
		for value in string.gfind(text,"[^"..separator.."]+") do
			table.insert(t, value);
		end
		return t;
	end;
	
	--[[ Nil in Array Fixing Functions ]]--
	
	--
	-- fixnil (...)
	-- 
	-- 	Converts all nils to "(nil)" strings
	--
	-- Arguments:
	-- 	() arg
	--	arg - the list
	--
	-- Written by Thott (thott@thottbot.com)
	-- 
	fixnil = function(...)
		return Sea.util.fixnilSub("(nil)", unpack(arg));
	end;


	--
	-- Fixes nils with empty strings
	--
	-- Written by Thott (thott@thottbot.com)

	fixnilEmptyString = function (...)
		return Sea.util.fixnilSub("", unpack(arg));
	end;

	-- 
	-- Fixes nils with 0s
	-- 
	-- Written by Thott (thott@thottbot.com)
	fixnilZero = function (...)
		return Sea.util.fixnilSub(0, unpack(arg));
	end;
		
	--
	-- fixnilsub (sub, ... )
	--
	--	replaces nils with a substitute
	--	
	--
	-- Written by Thott (thott@thottbot.com)
	fixnilSub = function(sub, ... )
		for i=1, arg.n, 1 do
			if(not arg[i]) then
				arg[i] = sub;
			end
		end
		return arg;
	end;


};

--
-- Hook Function
-- 
-- Written by Thott (thott@thottbot.com)
Sea.util.hookFunction = function (orig,new,type)
	if(not type) then
		type = "before";
	end
	Sea.IO.dprint("Hooking ",orig," to ",new,", type ",type);
	if(not Sea.util.Hooks) then
		Sea.util.Hooks = {};
	end
	if(not Sea.util.Hooks[orig]) then
		Sea.util.Hooks[orig] = {};
		Sea.util.Hooks[orig].before = {};
		Sea.util.Hooks[orig].before.n = 0;
		Sea.util.Hooks[orig].after = {};
		Sea.util.Hooks[orig].after.n = 0;
		Sea.util.Hooks[orig].hide = {};
		Sea.util.Hooks[orig].hide.n = 0;
		Sea.util.Hooks[orig].replace = {};
		Sea.util.Hooks[orig].replace.n = 0;
		Sea.util.Hooks[orig].orig = getglobal(orig);
	else
		for key,value in Sea.util.Hooks[orig][type] do
			-- NOTE THIS SHOULD BE VALUE! VALUE! *NOT* KEY!
			if(value == getglobal(new)) then
				Sea.IO.dprint(nil, "already hooked ",new,", skipping");
				return;
			end
		end
	end
	-- intentionally will error if bad type is passed
	Sea.table.push(Sea.util.Hooks[orig][type],getglobal(new));
	setglobal(orig,function(...) return Sea.util.hookHandler(orig,arg); end);
end

-- 
-- Unhook function
-- 
-- Written by Thott (thott@thottbot.com)

Sea.util.unhookFunction = function ( orig, new, type )
	-- same format as hookFunction
	if(not type) then
		type = "before";
	end
	local l,g;
	if(not Sea.util.Hooks) then
		Sea.util.Hooks = {};
	end
	if(not Sea.util.Hooks[orig]) then
		Sea.util.Hooks[orig] = {};
		Sea.util.Hooks[orig].before = {};
		Sea.util.Hooks[orig].before.n = 0;
		Sea.util.Hooks[orig].after = {};
		Sea.util.Hooks[orig].after.n = 0;
		Sea.util.Hooks[orig].hide = {};
		Sea.util.Hooks[orig].hide.n = 0;
		Sea.util.Hooks[orig].replace = {};
		Sea.util.Hooks[orig].replace.n = 0;
		Sea.util.Hooks[orig].orig = getglobal(orig);
	end
	l = Sea.util.Hooks[orig][type];
	g = getglobal(new);
	if ( l ) then 
		for key,value in l do
			if(value == g) then
				l[key] = nil;
				Sea.IO.dprint(nil, "found and unhooked ",new);
				return;
			end
		end
	end
end

--
-- Hook Handler
--
-- Handles the name and the argument table
-- 
-- Written by Thott (thott@thottbot.com)

Sea.util.hookHandler = function (name,arg)
	local called = false;
	local continue = true;
	local retval;
	for key,value in Sea.util.Hooks[name].hide do
		if(type(value) == "function") then
			--Sea.IO.dprint(nil, "calling before ",name);
			if(not value(unpack(arg))) then
				continue = false;
			end
			called = true;
		end
	end
	if(not continue) then
		Sea.IO.dprint(nil,"hide returned false, aborting call to ",name);
		return;
	end
	for key,value in Sea.util.Hooks[name].before do
		if(type(value) == "function") then
			--Sea.UI.dprint(nil, "calling before ",name);
			value(unpack(arg));
			called = true;
		end
	end
	continue = false;
	local replacedFunction = false;
	for key,value in Sea.util.Hooks[name].replace do
		if(type(value) == "function") then
			replacedFunction = true;
			--Sea.IO.dprint(nil, "calling before ",name);
			local callOrig, valList = value(unpack(arg));
			if(callOrig) then
				continue = true;
			else
				retval = valList;
			end
			called = true;
		end
	end
	if(continue or (not replacedFunction)) then
		--Sea.IO.dprint(nil, "calling original ",name);
  		retval = { Sea.util.Hooks[name].orig(unpack(arg)) };
	end
	for key,value in Sea.util.Hooks[name].after do
		if(type(value) == "function") then
			value(unpack(arg));
			called = true;
		end
	end
	if(not called) then
		Sea.IO.dprint(nil,"no hooks left for ",name,", clearing");
		setglobal(name,Sea.util.Hooks[name].orig);
		Sea.util.Hooks[name] = nil;
	end
	if (type(retval) ~= "table") then
		retval = {retval};
	end
	return unpack(retval);
end

-- Alias table
Sea.string.split = Sea.util.split;
Sea.string.explode = Sea.util.split;
