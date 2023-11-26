-- Four states, (3 I really care about)
-- 1 = off
-- 2 = player
-- 3 = player + guild
-- 4 = guild only

BINDING_HEADER_NAMECYCLE="Name Cycle";
BINDING_NAME_NAMECYCLE="Cycle Name Display";
BINDING_NAME_NAMECYCLE_TOGGLE="Toggle Name Display";
BINDING_NAME_NAMECYCLE_SHOW="Show Names (While held)";

NameCycleStates = {};
NameCycleStates.NC_STATE_NONE  = 1;
NameCycleStates.NC_STATE_NAME  = 2;
NameCycleStates.NC_STATE_ALL   = 3;
NameCycleStates.NC_STATE_GUILD = 4;

local CYCLE_STATES = 4;
local CYCLE_FUNCTIONS = {};
CYCLE_FUNCTIONS[NameCycleStates.NC_STATE_NONE] = 
   function () 
      SetCVar("UnitNamePlayer", "0")
      SetCVar("UnitNamePlayerGuild", "0")
      SetCVar("UnitNameNPC", 0)
   end

CYCLE_FUNCTIONS[NameCycleStates.NC_STATE_NAME] = 
   function () 
      SetCVar("UnitNamePlayer", "1")
      SetCVar("UnitNamePlayerGuild", "0")
   end

CYCLE_FUNCTIONS[NameCycleStates.NC_STATE_ALL] =
   function () 
      SetCVar("UnitNamePlayer", "1")
      SetCVar("UnitNamePlayerGuild", "1")
      SetCVar("UnitNameNPC", 1)
   end

CYCLE_FUNCTIONS[NameCycleStates.NC_STATE_GUILD] =
   function () 
      SetCVar("UnitNamePlayer", "0")
      SetCVar("UnitNamePlayerGuild", "1")
   end


local function NameCycle_GetState()
   if (GetCVar("UnitNamePlayer") == "1") then
     if (GetCVar("UnitNamePlayerGuild") == "1") then
	return NameCycleStates.NC_STATE_ALL;
     else
	return NameCycleStates.NC_STATE_NAME;
     end
  else
     if (GetCVar("UnitNamePlayerGuild") == "1") then
	return NameCycleStates.NC_STATE_GUILD;
     else
	return NameCycleStates.NC_STATE_NONE;
     end
  end
end

local savedState = nil;

-- CYCLE LISTS
local NORMAL_CYCLE = {
   NameCycleStates.NC_STATE_NONE,
   NameCycleStates.NC_STATE_NAME,
   NameCycleStates.NC_STATE_ALL
};

function NameCycle_Cycle(cycleType)
   if (not cycleType) then
      	cycleType = NORMAL_CYCLE;
   end
   local currentState = NameCycle_GetState();
   local newState;

   for k,state in cycleType do
      if (state == currentState) then
	 newState = cycleType[k+1];
		-- LedMirage 3/29/2005
		if(ChatFrame2) then
			ChatFrame2:AddMessage("|cff7FFF33NAME CYCLE: Overhead Names Displayed Changed|r");
		else
			if ( DEFAULT_CHAT_FRAME ) then 
				DEFAULT_CHAT_FRAME:AddMessage("|cff7FFF33NAME CYCLE: Overhead Names Displayed Changed|r");
			end
		end
	 if (newState == nil) then
	    newState = cycleType[1];
	 end
	 break;
      end
   end

   if (newState == nil) then
      local closestDist = CYCLE_STATES;
      for k,state in cycleType do
	 local distance = mod(state - currentState + CYCLE_STATES,
			      CYCLE_STATES);
	 if (distance < closestDist) then
	    closestDist = distance;
	    newState = state;
	 end
      end
   end

   if (newState ~= nil) then
      CYCLE_FUNCTIONS[newState]();
   end
end

function NameCycle_Show(startFlag) 
   if (startFlag) then
      if (savedState == nil) then
	 savedState = NameCycle_GetState();
      end
      if (savedState == NameCycleStates.NC_STATE_ALL) then
	 	CYCLE_FUNCTIONS[NameCycleStates.NC_STATE_NONE]();
		-- LedMirage 3/29/2005
		if(ChatFrame2) then
			ChatFrame2:AddMessage("|cff7FFF33NAME CYCLE: Hidding all names while key is held|r");
		else
			if ( DEFAULT_CHAT_FRAME ) then 
				DEFAULT_CHAT_FRAME:AddMessage("|cff7FFF33NAME CYCLE: Hidding all names while key is held|r");
			end
		end	 	
	 
      else
	 	CYCLE_FUNCTIONS[NameCycleStates.NC_STATE_ALL]();
 		-- LedMirage 3/29/2005
 		if(ChatFrame2) then
 			ChatFrame2:AddMessage("|cff7FFF33NAME CYCLE: Showing all names while key is held|r");
 		else
 			if ( DEFAULT_CHAT_FRAME ) then 
 				DEFAULT_CHAT_FRAME:AddMessage("|cff7FFF33NAME CYCLE: Showing all names while key is held|r");
 			end
		end
      end
   else
      if (savedState ~= nil) then
	 CYCLE_FUNCTIONS[savedState]();
	 savedState = nil;
      end
   end
end