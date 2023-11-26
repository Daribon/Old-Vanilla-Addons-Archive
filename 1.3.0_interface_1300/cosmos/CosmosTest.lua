--[[
 Unit tests for cosmos
 For use with a lua runtime, not inside wow
]]--

COSMOS_TEST = true;

---------
--Mock objects
---------
UIPanelWindows = {};
CVars = {};
tinsert = table.insert;
-- Overrides function from CosmosCommonFunctions.lua
function DebugPrint(msg, debugLevel)
	print(msg);
end

-- Overrides blizzard native functions
function GetCVar(name)
   return CVars[name];
end
function SetCVar(name, value)
   CVars[name] = value;
end
function RegisterCVar(name, value)
   if not CVars[name] then
      CVars[name] = value;
   end
end
function getglobal(name)
   local success, value = pcall(loadstring("return "..name));
   if (success) then
      return value;
   end
end
function setglobal(name, value)
   if (not value) then
      local success = pcall(loadstring(name.." = nil"));
   elseif (value == "{}") then -- only works with empty tables, not full ones
      local success = pcall(loadstring(name.." = {}"));
   elseif (type(value) == "string") then
      local success = pcall(loadstring(name.." = \""..value.."\""));
   else
      local success = pcall(loadstring(name.." = "..value));
   end
   if (success) then
      return value;
   end
end

---------
--Files to test
---------
require("CosmosCVar");
require("CosmosMaster");
require("CosmosCvarList");

---------
--Helper functions
---------
function AssertEquals(expected, actual)
   if not (expected == actual) then
      if (actual) then
         print("Expected <"..expected..">, but was <"..actual..">");
      else
         print("Expected <"..expected..">, but was nil");
      end
      assert(nil);
   end
end
function AssertNil(actual)
   if actual then
      print("Expected nil, but was <"..actual..">");
      assert(nil);
   end
end


----------
--Tests
----------
function testSetGlobal()
   MY_GLOBAL = "blah";
   AssertEquals(MY_GLOBAL, getglobal("MY_GLOBAL"));
   AssertEquals("blah", MY_GLOBAL);
   setglobal("MY_GLOBAL", "bleh");
   AssertEquals("bleh", MY_GLOBAL);
   AssertEquals("bleh", getglobal("MY_GLOBAL"));
end
function testCosmosMaster_SaveMemoryToDisk()
	setglobal('COS_1','`YNN``````````````````````````````````````````````````````````````````````````');
	PrintMem();
	CosmosMaster_DiskInitialization();   
	PrintMem();
	CosmosMaster_Register("COS_INVM_LOOTTOGGLE", "CHECKBOX", 
			 "Turn on the Right Sidebar", 
			 "This controls whether or not the sidebar will appear on the right side.",
			 SideBar_Toggle,
			 1
		    );
	CosmosMaster_SaveMemoryToDisk();
	CosmosMaster_LoadMemoryFromDisk();
	PrintMem();
   

end

----------
--main()
----------
testSetGlobal();
testCosmosMaster_SaveMemoryToDisk();
