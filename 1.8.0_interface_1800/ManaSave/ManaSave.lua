--
-- ========== axel0r's ManaSave - www.for-the-horde.de // www.ocrana.com ==========
-- = big thx to FtH|Ghash for introducing me into WoW API and Lua and helping me a lot with this =
--


--
-- ========== Define default options ==========
--
local DEFAULT_OPTIONS = {
	[CLASS_PRIEST]  = {
       		[GREATER_HEAL] = {percent=50, absolute=2700},
       		[FLASH_HEAL] = {percent=85, absolute=990},
       		[HEAL] = {percent=85, absolute=950} 
    	},
    	[CLASS_SHAMAN]   = {
        	[HEALING_WAVE] = {percent=70, absolute=1500}, 
        	[LESSER_HEAL] = {percent=85, absolute=900}
    	},
    	[CLASS_DRUID]   = {
        	[HEALING_TOUCH] = {percent=65, absolute=2100},
        	[REGROWTH] = {percent=85, absolute=1050}
    	},
    	[CLASS_PALADIN]   = {
        	[HOLY_LIGHT] = {percent=75, absolute=1300}, 
        	[FLASH_OF_LIGHT] = {percent=90, absolute=400}       	       	
    	},  	

    	MS_USEPERCENT = FALSE,
    	MS_DEBUG = FALSE,
    	MS_SELFCHECK = TRUE,
    	MS_SECONDSBEFORECHECK = 0.5,
    	MS_MULTIPLICATOR = 1
}


--
-- ========== Define a new ManaSaveClass ==========
--

ManaSaveClass = AceAddonClass:new({
    name          = MANASAVE_NAME,
    description   = MANASAVE_DESCRIPTION,
    version       = MANASAVE_VERSION,
    releaseDate   = MANASAVE_RELEASEDATE,
    aceCompatible = "100",
    author        = "axel0r",
    email         = "vader@ocrana.com",
    website       = "http://www.for-the-horde.de",
    category      = ACE_CATEGORY_RAID,
    db            = AceDbClass:new("ManaSaveDB"),
    defaults      = DEFAULT_OPTIONS,
    cmd           = AceChatCmdClass:new(MANASAVE_COMMANDS, MANASAVE_CMD_OPTIONS)
})


-- Initialzie function - called on init
function ManaSaveClass:Initialize()
    -- Helpful closures for accessing the addon's currently loaded profile.
    self.GetOpt = function(var) return self.db:get(self.profilePath,var)    end
    self.SetOpt = function(var,val) self.db:set(self.profilePath,var,val)   end
    self.TogOpt = function(var) return self.db:toggle(self.profilePath,var) end 
end

-- called on enable
function ManaSaveClass:Enable()
--			event name		fuction die aufgerufen wird
    self:RegisterEvent("SPELLCAST_START",    "SpellCastStart");
    self:RegisterEvent("SPELLCAST_INTERRUPTED",    "SpellCastAbort");
    self:RegisterEvent("SPELLCAST_STOP",    "SpellCastAbort");
    self:RegisterEvent("SPELLCAST_FAILED",    "SpellCastAbort");
end

-- called on disable
function ManaSaveClass:Disable()
    self:UnregisterEvent("SPELLCAST_START");
    self:UnregisterEvent("SPELLCAST_INTERRUPTED");
    self:UnregisterEvent("SPELLCAST_STOP");
    self:UnregisterEvent("SPELLCAST_FAILED");
end



--
-- ========== EVENT HANDLE FUNCTIONS ==========
--


-- fuction will be called on start of a spellcast
function ManaSaveClass:SpellCastStart()
	-- TODO: check zeitpunkt einfügen (dh 0.5sec vor ende)
	
	-- check if target is a correct target
	if(not UnitIsFriend("target","player")) then return end;
	if(not UnitPlayerControlled("target")) then return end;
		
	-- get spell attributes
	local spellname = arg1;
	local duration = arg2;
	-- get player class
	local class=UnitClass("player");
	-- get spells for this class and store em into htable
	local htable=self.GetOpt(class);
	-- get target infos
	local name = UnitName("target");
	
	-- if not grouped but selfcast do:
	if (UnitIsUnit("target","player")) then
		-- if player wants to use MS while selfcasting
		if(self.GetOpt("MS_SELFCHECK")) then
			-- check if spell is relevant for ManaSave - add a timer 
			if (htable and htable[spellname]) then		
			-- start a new timex event
				-- checks if user wants to use percent or absolute 
				if (self.GetOpt("MS_USEPERCENT")) then
					Timex:AddNamedSchedule("ManaSave",(duration/1000) - self.GetOpt("MS_SECONDSBEFORECHECK"),nil,1,ManaSave["CheckTargetByPercent"],ManaSave,spellname,htable,"player");
				else
					Timex:AddNamedSchedule("ManaSave",(duration/1000) - self.GetOpt("MS_SECONDSBEFORECHECK"),nil,1,ManaSave["CheckTargetByAbsolute"],ManaSave,spellname,htable,"player");
				end;
			end;
		end;
	-- if target is grouped with player we can use absolute settings
	elseif(UnitInParty("target") or UnitInRaid("target")) then
		
		-- get targetId
		if (UnitInParty("target")) then
			local id = self:GetPartyIdByName(name)
		else
			local id = self:GetRaidIdByName(name)
		end;
		
		self:MSDebug("SpellCastStart : idofmember: "..id.."spellname: "..spellname);
		
		-- check if spell is relevant for ManaSave - add a timer 
		if (htable and htable[spellname]) then
		
		-- start a new timex event
			-- checks if user wants to use percent or absolute 
			if (self.GetOpt("MS_USEPERCENT")) then
				Timex:AddNamedSchedule("ManaSave",(duration/1000) - self.GetOpt("MS_SECONDSBEFORECHECK"),nil,1,ManaSave["CheckTargetByPercent"],ManaSave,spellname,htable,id);
			else
				Timex:AddNamedSchedule("ManaSave",(duration/1000) - self.GetOpt("MS_SECONDSBEFORECHECK"),nil,1,ManaSave["CheckTargetByAbsolute"],ManaSave,spellname,htable,id);
			end;
		end;
	-- if not grouped and not selfcasting
	else
		-- check if spell is relevant for ManaSave - add a timer 
		if (htable and htable[spellname]) then		
		-- start a new timex event
		Timex:AddNamedSchedule("ManaSave",(duration/1000) - self.GetOpt("MS_SECONDSBEFORECHECK"),nil,1,ManaSave["CheckTargetByPercent"],ManaSave,spellname,htable,"target");
		end;
	end;
	 
end

-- fuction will be called on any aborts on spellcasting
function ManaSaveClass:SpellCastAbort()
    if (Timex:NamedScheduleCheck("ManaSave")~=nil) then
    	-- deletes upcoming checkevent
    	Timex:DeleteNamedSchedule("ManaSave");
    end
end

--
-- ========== CHECK FUNCTIONS ==========
--

-- checks target if heal should be cast or not
function ManaSaveClass:CheckTargetByPercent(spellname, htable, id)
	-- get percent of hp
	local hp = self:HpPercent(id);	
	self:MSDebug("CheckTargetByPercent() : hplost of target: "..hp);	
	-- check on percent and abort if too less hp loss
	if (hp > htable[spellname]["percent"]) then
		SpellStopCasting();
		self.cmd:result("Aborting your Heal - target is at: "..hp.."%");
	end;
end

-- checks target if heal should be cast or not
function ManaSaveClass:CheckTargetByAbsolute(spellname, htable, id)
	-- get missing hp
	local hp = self:HpLost(id);
	self:MSDebug("CheckTargetByAbsolute() : hplost of target: "..hp);
	-- check on absolute hp and abort if too less hp loss
	if (hp < (htable[spellname]["absolute"]*self.GetOpt("MS_MULTIPLICATOR"))) then
		SpellStopCasting();
		self.cmd:result("Aborting your Heal - target health deficit: "..hp.." hp");
	end;

end

--
-- ========== HELP FUNCTIONS ==========
--

-- returns the missing hp from them given unitid
function ManaSaveClass:HpLost(player)
    self:MSDebug("HpLost() : called");
    ret = UnitHealthMax(player)-UnitHealth(player);
    return  ceil(ret);
end

-- returns the percent of hp from them given unitid
function ManaSaveClass:HpPercent(player)
    self:MSDebug("HpPercent() : called");
    ret = (UnitHealth(player) / UnitHealthMax(player) * 100);
    return  ceil(ret);
end

-- returns the id of the player with name, only use when target is grouped with you 
function ManaSaveClass:GetPartyIdByName(name)
	self:MSDebug("GetPartyIdByName() : called");
	
	if (GetNumPartyMembers() ~= 0) then
		partymembers = GetNumPartyMembers()	
		for i = 1, partymembers do 
			id = "party"..i;
			buffer = UnitName(id);
			if (buffer == name) then
				return id
			end;	
		end;  
	else
		self:MSDebug("GetPartyIdByName : 0 raid members");
	end;  
end

-- returns the id of the player with name, only use when target is in raid with you 
function ManaSaveClass:GetRaidIdByName(name)
	self:MSDebug("GetRaidIdByName() : called");
	
	if (GetNumRaidMembers() ~= 0) then
		raidmembers = GetNumRaidMembers()	
		for i = 1, raidmembers do 
			id = "raid"..i;
			self:MSDebug("GetRaidIdByName() : partyid = "..id);
			buffer = UnitName(id);
			self:MSDebug("GetRaidIdByName() : buffer = "..buffer);
			if (buffer == name) then
				return id;
			end;	
		end;  
	else
		self:MSDebug("GetRaidIdByName : 0 raid members");
	end; 
end

--
-- ========== DEBUG FUNCTIONS ==========
--

function ManaSaveClass:MSDebug(output)
	if (self.GetOpt("MS_DEBUG")) then 
		output = "DEBUG : "..output;
		self.cmd:result(output);
	end;
end;



--
-- ========== CONFIG FUNCTIONS ==========
--
-- sets the MS_SECONDSBEFORECHECK time
function ManaSaveClass:SetCheckTime(val)
	local args  = ace.ParseWords(val); 
	local buf = tonumber(args[1]);
	if(buf) then
		if (0.3<=buf and buf<=1) then
			self.SetOpt("MS_SECONDSBEFORECHECK",val);
			self.cmd:result("Checktime changed to "..val.." seconds");
		else
			self.cmd:result("Checktime must be between 0.3 and 1");
		end
	end;
end

-- sets the MS_MULTIPLICATOR value
function ManaSaveClass:SetMulti(val)
	local args  = ace.ParseWords(val); 
	buf = tonumber(args[1]);
	if(buf) then
		if (0.5<=buf and buf<=2) then
			self.SetOpt("MS_MULTIPLICATOR",val);
			self.cmd:result("MULTIPLICATOR changed to "..val);
		else
			self.cmd:result("Multiplicator must be between 0.5 and 2");
		end;
	end;
end

-- toggles Debug messages on/off
function ManaSaveClass:ToggleDebug()
	self.TogOpt("MS_DEBUG");
	if (self.GetOpt("MS_DEBUG")) then
		self.cmd:result("Debug Messages on");
	else
		self.cmd:result("Debug Messages off");
	end;
end

-- toggles Debug messages on/off
function ManaSaveClass:ToggleSelfCheck()
	self.TogOpt("MS_SELFCHECK");
	if (self.GetOpt("MS_SELFCHECK")) then
		self.cmd:result("Selfcheck on");
	else
		self.cmd:result("Selfcheck off");
	end;
end


-- makes ManaSave using percent values for health checking
function ManaSaveClass:SetUsePercent()
	self.SetOpt("MS_USEPERCENT", TRUE);
	self.cmd:result("now using PERCENT values for health checking");
end

-- makes ManaSave using absolute values for health checking
function ManaSaveClass:SetUseAbsolute()
	self.SetOpt("MS_USEPERCENT", FALSE);
	self.cmd:result("now using ABSOLUTE values for health checking");
end


-- reports all current settings
function ManaSaveClass:ReportSettings()
	-- get class and spells
	local class=UnitClass("player");
	local htable=self.GetOpt(class);
	if (htable) then 
		self.cmd:report({
		    	{text=MS_VAR_VERSION_TXT, val=MANASAVE_VERSION},
		        {text=MS_VAR_USEPERC_TEXT, val=self.GetOpt("MS_USEPERCENT"), map=ACE_MAP_ONOFF},
		        {text=MS_VAR_DEBUG_TEXT, val=self.GetOpt("MS_DEBUG"), map=ACE_MAP_ONOFF},
		        {text=MS_VAR_SELFCHECK_TEXT, val=self.GetOpt("MS_SELFCHECK"), map=ACE_MAP_ONOFF},
		        {text=MS_VAR_CHKTIME_TEXT, val=self.GetOpt("MS_SECONDSBEFORECHECK")},
		        {text=MS_VAR_MULTI_TEXT, val=self.GetOpt("MS_MULTIPLICATOR")}
		})
	    
	   	self.cmd:result(class.." health base check values:");
		for healname, value in htable do
		 	self.cmd:result(healname..": percent: "..value['percent'].."% absolute: "..value['absolute'].."hp" );
		end
	end
end;
	
-- sets the percent value	
function ManaSaveClass:setPercentValue(value)
	local _, _, cmd1, cmd2 = string.find(value, "(.+)=(.+)$");
	cmd2 = tonumber(cmd2);
	if (cmd1 and cmd2) then
	
		self.class = UnitClass("player");
		local htable=self.GetOpt(self.class);
		if (htable) then 
			if (htable[cmd1] and cmd2>=0 and cmd2<=100) then
				self.healspell = cmd1;
				self.SetOption = function(var,val) return self.db:set({self.profilePath,self.class, self.healspell},var,val) end
				self.SetOption("percent", cmd2)
				self.cmd:result("New "..cmd1.." percent="..cmd2.."%");
			end
		end
	end
end;	

-- sets the absolute value	
function ManaSaveClass:setAbsoluteValue(value)
	local _, _, cmd1, cmd2 = string.find(value, "(.+)=(.+)$");
	cmd2 = tonumber(cmd2);
	if (cmd1 and cmd2) then
	
		self.class = UnitClass("player");
		local htable=self.GetOpt(self.class);
		if (htable) then 
			if (htable[cmd1] and cmd2>=0 and cmd2<=10000) then
				self.healspell = cmd1;
				self.SetOption = function(var,val) return self.db:set({self.profilePath,self.class, self.healspell},var,val) end
				self.SetOption("absolute", cmd2)
				self.cmd:result("New "..cmd1.." absolute="..cmd2.."hp");
			end
		end
	end
end;

function ManaSaveClass:reset()
	self.db:reset(self.profilePath, self.defaults);	
	self.cmd:result("Settings resetted to default Values");
end

	
--[[--------------------------------------------------------------------------------
  Create and Register Addon Object
-----------------------------------------------------------------------------------]]

ManaSave = ManaSaveClass:new()
ManaSave:RegisterForLoad()
