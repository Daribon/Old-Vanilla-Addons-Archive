--[[

    :: XRaid
    by Moonsorrow (ingame Ghash) (moonsorrow@gmx.de)
    www.for-the-horde.de
    
    Credits: Credits go to the developer of Nymbia's Perl Unitframes from which
             i took the code of the raid addon and created my own with it.

--]]

local showing={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

local DEFAULT_OPTIONS = {
    BarTextures		   = TRUE,	  -- change to 0 to not show the bar textures -- not implemented yet
	Transparency	   = 1,	      -- change to the desired overall transparency, between 0 and 1
	TextTransparency   = 0.8,	  -- change to the desired text transparency, between 0 and 1
	CastParty	       = TRUE,	  -- change to 0 to turn off CastParty support
	SortRaidByClass	   = FALSE,
	ShowGroup1		   = TRUE,
	ShowGroup2		   = TRUE,
	ShowGroup3		   = TRUE,
	ShowGroup4		   = TRUE,
	ShowGroup5		   = TRUE,
	ShowGroup6		   = TRUE,
	ShowGroup7		   = TRUE,
	ShowGroup8		   = TRUE,
	ShowGroup9		   = TRUE,
	ShowRaidPercents   = 1,
	Scale_Raid		   = 0.7,
	Locked             = FALSE,
	UpdateTimer        = 0.3,
	-- COLOR Table
	Color = {
    	[XRAID_CLASS_WARRIOR]  = {r=0.78, g=0.61, b=0.43},
        [XRAID_CLASS_MAGE]     = {r=0.41, g=0.8, b=0.94},
        [XRAID_CLASS_ROGUE]    = {r=1, g=0.96, b=0.41},
        [XRAID_CLASS_DRUID]    = {r=1, g=0.49, b=0.04},
        [XRAID_CLASS_HUNTER]   = {r=0.67, g=0.83, b=0.45},
        [XRAID_CLASS_SHAMAN]   = {r=0.96, g=0.55, b=0.73},
        [XRAID_CLASS_PRIEST]   = {r=1, g=1, b=1},
        [XRAID_CLASS_WARLOCK]  = {r=0.58, g=0.51, b=0.79},
        [XRAID_CLASS_PALADIN]  = {r=0.96, g=0.55, b=0.73}
    }
}

--[[--------------------------------------------------------------------------------
  Class Setup
-----------------------------------------------------------------------------------]]

XRaidClass = AceAddonClass:new({
    name          = XRAID_NAME,
    description   = XRAID_DESCRIPTION,
    version       = XRAID_VERSION,
    releaseDate   = XRAID_RELEASEDATE,
    aceCompatible = "100",
    author        = "Ghash",
    email         = "moonsorrow@gmx.de",
    website       = "http://www.for-the-horde.de",
    category      = "raid",
    --optionsFrame  = "AddonNameOptionsFrame",
    db            = AceDbClass:new("XRaidDB"),
    defaults      = DEFAULT_OPTIONS,
    cmd           = AceChatCmdClass:new(XRAID_COMMANDS, XRAID_CMD_OPTIONS)
})


--[[--------------------------------------------------------------------------------
  Initialize function
-----------------------------------------------------------------------------------]]

function XRaidClass:Initialize()
    -- Helpful closures for accessing the addon's currently loaded profile.
    self.GetOpt = function(var) return self.db:get(self.profilePath,var)    end
    self.SetOpt = function(var,val) self.db:set(self.profilePath,var,val)   end
    self.TogOpt = function(var) return self.db:toggle(self.profilePath,var) end
end


--[[--------------------------------------------------------------------------------
  Addon Enabling/Disabling
-----------------------------------------------------------------------------------]]

function XRaidClass:Enable()
    self:RegisterEvent("RAID_ROSTER_UPDATE")
    self:RAID_ROSTER_UPDATE()
end 

function XRaidClass:Disable()
    self:LeaveRaid()
end


--[[--------------------------------------------------------------------------------
  Event Handling
-----------------------------------------------------------------------------------]]

function XRaidClass:RegisterRaidEvents()
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_MAXHEALTH", "UNIT_HEALTH")
    self:RegisterEvent("UNIT_MANA")
    self:RegisterEvent("UNIT_MAXMANA",   "UNIT_MANA")
    self:RegisterEvent("UNIT_RAGE",      "UNIT_MANA")
    self:RegisterEvent("UNIT_MAXRAGE",   "UNIT_MANA")
    self:RegisterEvent("UNIT_ENERGY",    "UNIT_MANA")
    self:RegisterEvent("UNIT_MAXENERGY", "UNIT_MANA")
    self:RegisterEvent("UNIT_FOCUS",     "UNIT_MANA")
    self:RegisterEvent("UNIT_MAXFOCUS",  "UNIT_MANA")
    self:RegisterEvent("UNIT_NAMEUPDATE")
    self:RegisterEvent("UNIT_AURA")
    self:RegisterEvent("UNIT_DISPLAYPOWER")
end

function XRaidClass:UnregisterRaidEvents()
    self:UnregisterEvent("UNIT_HEALTH")
    self:UnregisterEvent("UNIT_MAXHEALTH")
    self:UnregisterEvent("UNIT_MANA")
    self:UnregisterEvent("UNIT_MAXMANA")
    self:UnregisterEvent("UNIT_RAGE")
    self:UnregisterEvent("UNIT_MAXRAGE")
    self:UnregisterEvent("UNIT_ENERGY")
    self:UnregisterEvent("UNIT_MAXENERGY")
    self:UnregisterEvent("UNIT_FOCUS")
    self:UnregisterEvent("UNIT_MAXFOCUS")
    self:UnregisterEvent("UNIT_NAMEUPDATE")
    self:UnregisterEvent("UNIT_AURA")
    self:UnregisterEvent("UNIT_DISPLAYPOWER")
end

--[[--------------------------------------------------------------------------------
  Main processing
-----------------------------------------------------------------------------------]]

-- Will update everything, so it is only called when the RAID_ROSTER_EVENT is fired
-- or somebody made some config changes
function XRaidClass:RAID_ROSTER_UPDATE()
    if( GetNumRaidMembers() > 0 ) then
        if( not self.inRaid ) then
            self.inRaid = TRUE
            self:RegisterRaidEvents()
        end
        self:AddMTTimer()
        self:CheckCorrectMTs()
        self:SetTransparency()
        self:UpdateAll()
    elseif( self.inRaid ) then
        self:LeaveRaid()
    end
end

function XRaidClass:AddMTTimer()
    if (not Timex:NamedScheduleCheck("Targets") and self.GetOpt("ShowGroup9")) then
        Timex:AddNamedSchedule("Targets", self.GetOpt("UpdateTimer"), TRUE, nil, XRaid["UpdateMTTargets"], self, "")
    end
end

function XRaidClass:DeleteMTTimer()
    if (Timex:NamedScheduleCheck("Targets")~=nil) then
        Timex:DeleteNamedSchedule("Targets")
    end
end

function XRaidClass:UNIT_HEALTH()
    if arg1 then
        local id = self:CheckForUnit(arg1)
        if (id) then
            self:UpdateHealth(self:UpdatePartyID(id), "XRaid"..id)
        end
    end
end

function XRaidClass:UNIT_MANA()
    if arg1 then
        local id = self:CheckForUnit(arg1)
		if (id) then
			self:UpdateMana(self:UpdatePartyID(id), "XRaid"..id)
		end
	end
end

function XRaidClass:UNIT_NAMEUPDATE()
    if arg1 then
        local id = self:CheckForUnit(arg1)
		if (id) then
			self:UpdateName(self:UpdatePartyID(id), "XRaid"..id)
		end
	end
end

function XRaidClass:UNIT_AURA()
    if arg1 then
        local id = self:CheckForUnit(arg1)
        if (id) then
            self:UpdateBuff(self:UpdatePartyID(id), "XRaid"..id)
			self:CheckCurableDebuffs(self:UpdatePartyID(id), "XRaid"..id)
		end
	end
end

function XRaidClass:UNIT_DISPLAYPOWER()
    if arg1 then
        local id = self:CheckForUnit(arg1)
		if (id) then
		    self:UpdateManaType(self:UpdatePartyID(id), "XRaid"..id)
		    self:UpdateMana(self:UpdatePartyID(id), "XRaid"..id)
		end
	end
end


function XRaidClass:LeaveRaid()
    self:DeleteMTTimer()
    
    for num=1,60 do
		getglobal("XRaid"..num):Hide()
    end
    
    for num=1,9 do
        getglobal("XRaid_Grp"..num):Hide()
    end
    
    self.inRaid = FALSE
end


function XRaidClass:CheckForUnit(unit)
	if UnitExists(unit) then
		local id=self:FindNum(unit)
		if id then
			if UnitIsUnit(unit, "raid"..id) then
			    return id
			end
		end
	end
	return false
end

function XRaidClass:UpdatePartyID(id)
	if (id<=40) then
		partyid = ("raid"..id)
	elseif (id>40 and id<=50) then
	    local mtframe = getglobal("XRaidMenu"..id-40)
		if mtframe.mt then
			partyid = ("raid"..mtframe.mt.."target")
		else 
            return
		end
	elseif (id>50 and id<=60) then
	    local mtframe = getglobal("XRaidMenu"..id-50)
	    if mtframe.mt then
			partyid = ("raid"..mtframe.mt.."targettarget")
		else 
            return
		end
	end
	return partyid
end

function XRaidClass:Scale(num)
	for frame=1,9 do
		getglobal("XRaid_Grp"..frame):SetScale(num)
	end
	for frame=1,60 do
		getglobal("XRaid"..frame):SetScale(num)
	end
end

function XRaidClass:SetTransparency()
    for num=1,60 do
		getglobal("XRaid"..num.."_StatsFrame_HealthBar_HealthBarText"):SetTextColor(1,1,1, self.GetOpt("TextTransparency"))
		getglobal("XRaid"..num.."_StatsFrame"):SetBackdropColor(0, 0, 0, self.GetOpt("Transparency"))
		getglobal("XRaid"..num.."_StatsFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
		getglobal("XRaid"..num.."_NameFrame"):SetBackdropColor(0, 0, 0, self.GetOpt("Transparency"))
		getglobal("XRaid"..num.."_NameFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
		getglobal("XRaid"..num):SetAlpha(self.GetOpt("Transparency"))
    end
end

-- Update everything
function XRaidClass:UpdateAll()
    self:Scale(self.GetOpt("Scale_Raid"))
    
    for num=1,8 do
	   getglobal("XRaid_Grp"..num):Show()
	end
	
	if (self.GetOpt("ShowGroup9")) then
	   getglobal("XRaid_Grp9"):Show()
	else
	   getglobal("XRaid_Grp9"):Hide()
	end
	
	if (self.GetOpt("SortRaidByClass")) then
		self:Classes()
	else
		self:Groups()
	end
	
	for num=1,40 do
	   self:UpdateBuff("raid"..num, "XRaid"..num)
	end
	
	self:UpdateRaidMembers()
    self:UpdateMTTargets()
    self:BarTextures()
end

-- Sort by class
function XRaidClass:Classes()
	local wa=0
	local m=0
	local p=0
	local wr=0
	local d=0
	local r=0
	local h=0
	local ps=0
	local counter={0,0,0,0,0,0,0,0}	
	
	XRaid_Grp1_NameFrame_NameBarText:SetText(XRAID_CLASS_WARRIOR)
	XRaid_Grp2_NameFrame_NameBarText:SetText(XRAID_CLASS_MAGE)
	XRaid_Grp3_NameFrame_NameBarText:SetText(XRAID_CLASS_PRIEST)
	XRaid_Grp4_NameFrame_NameBarText:SetText(XRAID_CLASS_WARLOCK)
	XRaid_Grp5_NameFrame_NameBarText:SetText(XRAID_CLASS_DRUID)
	XRaid_Grp6_NameFrame_NameBarText:SetText(XRAID_CLASS_ROGUE)
	XRaid_Grp7_NameFrame_NameBarText:SetText(XRAID_CLASS_HUNTER)
	XRaid_Grp8_NameFrame_NameBarText:SetText(XRAID_CLASS_PALADIN.."/"..XRAID_CLASS_SHAMAN)
	XRaid_Grp9_NameFrame_NameBarText:SetText(XRAID_MTT)
	
	for num=1,40 do
		if (UnitClass("raid"..num)==XRAID_CLASS_WARRIOR) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp1", "BOTTOMLEFT", 0,(2-(counter[1]*43)))
			counter[1]=counter[1]+1
			showing[num]=self.GetOpt("ShowGroup1")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_MAGE) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp2", "BOTTOMLEFT", 0,(2-(counter[2]*43)))
			counter[2]=counter[2]+1
            showing[num]=self.GetOpt("ShowGroup2")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_PRIEST) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp3", "BOTTOMLEFT", 0,(2-(counter[3]*43)))
			counter[3]=counter[3]+1
            showing[num]=self.GetOpt("ShowGroup3")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_WARLOCK) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp4", "BOTTOMLEFT", 0,(2-(counter[4]*43)))
			counter[4]=counter[4]+1
            showing[num]=self.GetOpt("ShowGroup4")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_DRUID) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp5", "BOTTOMLEFT", 0,(2-(counter[5]*43)))
			counter[5]=counter[5]+1
            showing[num]=self.GetOpt("ShowGroup5")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_ROGUE) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp6", "BOTTOMLEFT", 0,(2-(counter[6]*43)))
			counter[6]=counter[6]+1
            showing[num]=self.GetOpt("ShowGroup6")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_HUNTER) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp7", "BOTTOMLEFT", 0,(2-(counter[7]*43)))
			counter[7]=counter[7]+1
            showing[num]=self.GetOpt("ShowGroup7")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_PALADIN) then
			if counter[8]==0 then XRaid_Grp8_NameFrame_NameBarText:SetText(XRAID_CLASS_PALADIN) end
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp8", "BOTTOMLEFT", 0,(2-(counter[8]*43)))
			counter[8]=counter[8]+1
            showing[num]=self.GetOpt("ShowGroup8")
		elseif (UnitClass("raid"..num)==XRAID_CLASS_SHAMAN) then
			if counter[8]==0 then XRaid_Grp8_NameFrame_NameBarText:SetText(XRAID_CLASS_SHAMAN) end
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp8", "BOTTOMLEFT", 0,(2-(counter[8]*43)))
			counter[8]=counter[8]+1
            showing[num]=self.GetOpt("ShowGroup8")
		else
			showing[num]=FALSE
		end
	end
	
	-- Hide the group names if there are no players in the group
	for num=1,8 do
	   if (counter[num]==0 or not self.GetOpt("ShowGroup"..num)) then
	       getglobal("XRaid_Grp"..num):Hide()
	   end
	end
	
	-- Update MT targets position
	for num=41,50 do
    	getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp9", "BOTTOMLEFT", 0,(2-((num-41)*43)))
    end
    for num=51,60 do
    	getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp9", "BOTTOMLEFT", 77,(2-((num-51)*43)))
    end
end

-- Sort by groups (1-8)
function XRaidClass:Groups()
	local counter={0,0,0,0,0,0,0,0}	
	
	XRaid_Grp1_NameFrame_NameBarText:SetText(XRAID_GRP1)
	XRaid_Grp2_NameFrame_NameBarText:SetText(XRAID_GRP2)
	XRaid_Grp3_NameFrame_NameBarText:SetText(XRAID_GRP3)
	XRaid_Grp4_NameFrame_NameBarText:SetText(XRAID_GRP4)
	XRaid_Grp5_NameFrame_NameBarText:SetText(XRAID_GRP5)
	XRaid_Grp6_NameFrame_NameBarText:SetText(XRAID_GRP6)
	XRaid_Grp7_NameFrame_NameBarText:SetText(XRAID_GRP7)
	XRaid_Grp8_NameFrame_NameBarText:SetText(XRAID_GRP8)
	XRaid_Grp9_NameFrame_NameBarText:SetText(XRAID_MTT)
	
	for num=1,40 do
		local name, rank, subgroup= GetRaidRosterInfo(num)
		if (name) then
			getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp"..subgroup, "BOTTOMLEFT", 0,(2-(counter[subgroup]*43)))
			counter[subgroup]=counter[subgroup]+1
			showing[num]=self.GetOpt("ShowGroup"..subgroup)
		else
			showing[num]=FALSE
		end
	end
	
	for num=1,8 do
	   if (counter[num]==0 or not self.GetOpt("ShowGroup"..num)) then
	       getglobal("XRaid_Grp"..num):Hide()
	   end
	end
	
	-- Update MT targets position
	for num=41,50 do
    	getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp9", "BOTTOMLEFT", 0,(2-((num-41)*44)))
    end
    for num=51,60 do
    	getglobal("XRaid"..num):SetPoint("TOPLEFT", "XRaid_Grp9", "BOTTOMLEFT", 80,(2-((num-51)*44)))
    end
end

-- Function to invite your guild members into your raid group
function XRaidClass:GuildInvite(lvl)
    local offline = GetGuildRosterShowOffline()
	local selection = GetGuildRosterSelection()
	SetGuildRosterShowOffline(0)
	SetGuildRosterSelection(0)
	GetGuildRosterInfo(0)
	GuildRoster()
	local numInvites = 0
	local numGuildMembers = GetNumGuildMembers()
	for i = 1, numGuildMembers, 1 do
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(i)
		if ( level == lvl and name ~= UnitName("player") and online ) then
				InviteByName(name)
				numInvites = numInvites + 1
		end
	end
	SetGuildRosterShowOffline(offline)
	SetGuildRosterSelection(selection)
	self.cmd:result("Total invites: "..numInvites)
end

function XRaidClass:UpdateDisplay(id, objectname)
    local xraid = getglobal(objectname)	
    partyid = self:UpdatePartyID(id)
	if (UnitName(partyid) ~= nil) then
		self:UpdateManaType(partyid, objectname)
		self:UpdateHealth(partyid, objectname)
		self:UpdateMana(partyid, objectname)
		self:UpdateName(partyid, objectname)
	else
		xraid:Hide()
		xraid:StopMovingOrSizing()
	end
end

function XRaidClass:UpdateName(partyid,objectname)
    local namebartext = getglobal(objectname.."_NameFrame_NameBarText")
    if (not namebartext) then return end
    
	local name = UnitName(partyid)
	if ((objectname) and (name)) then
		if (strlen(name) > 10) then
			name = strsub(name, 1, 9).."..."
		end
		namebartext:SetText(name)  
	end
end

function XRaidClass:UpdateRaidMembers()
    -- Will update each raid member
	for num=1,40 do
	   if (showing[num]) then
			self:UpdateDisplay(num, "XRaid"..num)
			getglobal("XRaid"..num):Show()
	   else
	        getglobal("XRaid"..num):Hide()
	   end
	end
	
	-- Update the class colors
    for num=1,40 do
        self:SetStandardClassColor("raid"..num, "XRaid"..num)
    end
end

function XRaidClass:NoMTTarget(id, objectname)
    partyid = XRaidClass:UpdatePartyID(id)
    if (UnitName(partyid) ~= nil) then
        self:UpdateName(partyid, objectname)
        getglobal(objectname.."_StatsFrame_ManaBar"):Hide()
        getglobal(objectname.."_StatsFrame_ManaBarBG"):Hide()
        getglobal(objectname.."_StatsFrame_HealthBar"):Hide()
		getglobal(objectname.."_StatsFrame_HealthBarBG"):Hide()
		getglobal(objectname.."_StatsFrame_HealthBar_HealthBarText"):Hide()        
    end
end

function XRaidClass:ShowMTTarget(objectname)
    getglobal(objectname.."_StatsFrame_ManaBar"):Show()
    getglobal(objectname.."_StatsFrame_ManaBarBG"):Show()
    getglobal(objectname.."_StatsFrame_HealthBar"):Show()
	getglobal(objectname.."_StatsFrame_HealthBarBG"):Show()
	getglobal(objectname.."_StatsFrame_HealthBar_HealthBarText"):Show()        
end

-- Update maintank target (target) frames
function XRaidClass:UpdateMTTargets()
    if (self.GetOpt("ShowGroup9")) then
    	for num=41,50 do
            local nameframeT    = getglobal("XRaid".. num.."_NameFrame")
            local nameframeTT   = getglobal("XRaid".. num+10 .."_NameFrame")
            local xraidT        = getglobal("XRaid".. num)
            local xraidTT       = getglobal("XRaid".. num+10)
            local mtframe       = getglobal("XRaidMenu".. num-40)
            
    	    -- Check for targets of the warriors
    		if (mtframe.mt and UnitName("raid"..mtframe.mt.."target")) then
    		    xraidT:Show()
                self:ShowMTTarget("XRaid"..num)	
                self:UpdateDisplay(num, "XRaid"..num)
    			-- Check for targettargets
    			if (UnitName("raid"..mtframe.mt.."targettarget")) then
    			     self:UpdateDisplay(num+10, "XRaid"..num+10)
    			     xraidTT:Show()
    			     if UnitIsUnit("raid"..mtframe.mt, "raid"..mtframe.mt.."targettarget") then
    			         nameframeT:SetBackdropColor(0,1,0)
    			         nameframeTT:SetBackdropColor(0,1,0)
    			     else
    			         nameframeT:SetBackdropColor(1,0,0)
    			         nameframeTT:SetBackdropColor(1,0,0)
    			     end
    			else
    			     nameframeT:SetBackdropColor(0,0,0)
    			     nameframeTT:SetBackdropColor(0,0,0)
    			     xraidTT:Hide()
    			end
    		elseif (mtframe.mt) then
    			self:NoMTTarget(mtframe.mt, "XRaid"..num)	
    			xraidT:Show()
    			xraidTT:Hide()
    			nameframeT:SetBackdropColor(0,0,0)
    		else
    		    xraidT:Hide()
    		    xraidTT:Hide()
    		end
    	end
    else
        for num=41,50 do
            local xraidT    = getglobal("XRaid".. num)
            local xraidTT   = getglobal("XRaid".. num+10)
            
            xraidT:Hide()
            xraidTT:Hide()
        end
    end
end

function XRaidClass:CheckMTTargets()
    for num=1,10 do
        
    end
end

-- Update mana/rage/energy
function XRaidClass:UpdateMana(partyid, objectname)
	local manabar = getglobal(objectname.."_StatsFrame_ManaBar")
	if (not manabar) then return end
	
	local mana = UnitMana(partyid)
	local manamax = UnitManaMax(partyid)
	
	manabar:SetMinMaxValues(0, manamax)
	manabar:SetValue(mana)
	
	if ( not UnitIsConnected(partyid) ) then
	  manabar:SetValue(0)
    end
end

-- Check mana/energy/rage type
function XRaidClass:UpdateManaType(partyid, objectname)
	local manabar = getglobal(objectname.."_StatsFrame_ManaBar")
	if (not manabar) then return end
	
	local manabarbg = getglobal(objectname.."_StatsFrame_ManaBarBG")
	local power = UnitPowerType(partyid)
	
	if  (power == 1) then
	  r = 1
	  g = 0
	  b = 0
	elseif (power == 2) then
	  r = 1
	  g = 0.5
	  b = 0
	elseif (power == 3) then
	  r = 1
	  g = 1
	  b = 0
	else
	  r = 0
	  g = 0
	  b = 1
	end
	
	-- Setting the colors
	manabar:SetStatusBarColor(r, g, b, 1)
	manabarbg:SetStatusBarColor(r, g, b, 0.25)
end

-- Update everything concerning health of the unit
function XRaidClass:UpdateHealth(partyid, objectname)
    local xraid = getglobal(objectname)
    if (not xraid) then return end
    
    -- Definitions
    local healthbartext = getglobal(objectname.."_StatsFrame_HealthBar_HealthBarText")
    local healthbar = getglobal(objectname.."_StatsFrame_HealthBar")
    local healthbarbg = getglobal(objectname.."_StatsFrame_HealthBarBG")
    
    -- Health values
    local currhp = UnitHealth(partyid)
	local maxhp = UnitHealthMax(partyid)
	-- Workaround for the maxhp bug ...
	if currhp>maxhp then maxhp=currhp end
	local perchp = ceil((currhp / maxhp) * 100)
    
    healthbar:SetMinMaxValues(0,maxhp)
	healthbar:SetValue(currhp)
	
	-- Config check
	if (self.GetOpt("ShowRaidPercents")==0) then
	   text = ""
	elseif (self.GetOpt("ShowRaidPercents")==1) then
	   text = perchp.."%"
	elseif (self.GetOpt("ShowRaidPercents")==2) then
	   if (maxhp==currhp) then
	       text = ""
	   else
	       text = "-".. maxhp-currhp
	   end
	elseif (self.GetOpt("ShowRaidPercents")==3) then
	   text = currhp
    end
    
    -- Setting the correct health string
    healthbartext:SetText(text)
    
    -- Check for dead unit
    if ( UnitIsDead(partyid) ) then
        xraid:SetAlpha(self.GetOpt("Transparency")/2)
		healthbartext:SetText("DEAD")
		r = 1
		g = 0
		b = 0
	-- Check for ghost unit
    elseif ( UnitIsGhost(partyid) ) then
        xraid:SetAlpha(self.GetOpt("Transparency")/2)
		healthbartext:SetText("GHOST")
		r = 0.8
		g = 0.8
		b = 0
	-- Check if unit is offline
    elseif ( not UnitIsConnected(partyid) ) then
        xraid:SetAlpha(self.GetOpt("Transparency")/2)
		healthbartext:SetText("OFFLINE")
		healthbar:SetValue(0)
		r = 0.75
		g = 0.75
		b = 0.75
	else
	    xraid:SetAlpha(self.GetOpt("Transparency"))
	    r = 1
		g = 1
		b = 1
	end
    
    -- Set bar and text colors
	self:SetSmoothBarColor(healthbar)
	self:SetSmoothBarColor(healthbarbg,healthbar, 0.25)
	healthbartext:SetTextColor(r, g, b)
end

-- Check for debuffs which you can remove
function XRaidClass:CheckCurableDebuffs(partyid, objectname)
	local class=UnitClass("player")
	if class==XRAID_CLASS_MAGE then
		if (self:UnitDebuffType(partyid, XRAID_CURSE)) then
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(1,0,0)
		else
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(0,0,0)
		end
	elseif class==XRAID_CLASS_DRUID then
		if (self:UnitDebuffType(partyid, XRAID_CURSE) or self:UnitDebuffType(partyid, XRAID_POISON)) then
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(1,0,0)
		else
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(0,0,0)
		end
	elseif class==XRAID_CLASS_PRIEST then
		if (self:UnitDebuffType(partyid, XRAID_MAGIC) or self:UnitDebuffType(partyid, XRAID_DISEASE)) then
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(1,0,0)
		else
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(0,0,0)
		end
	elseif class==XRAID_CLASS_WARLOCK then
		if (self:UnitDebuffType(partyid, XRAID_MAGIC)) then
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(1,0,0)
		else
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(0,0,0)
		end
	elseif class==XRAID_CLASS_PALADIN then
		if (self:UnitDebuffType(partyid, XRAID_MAGIC) or self:UnitDebuffType(partyid, XRAID_POISON) or self:UnitDebuffType(partyid, XRAID_DISEASE)) then
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(1,0,0) 
		else
		  getglobal(objectname.."_NameFrame"):SetBackdropColor(0,0,0)
		end
	elseif class==XRAID_CLASS_SHAMAN then
		if (self:UnitDebuffType(partyid, XRAID_POISON) or self:UnitDebuffType(partyid, XRAID_DISEASE)) then 
	       getglobal(objectname.."_NameFrame"):SetBackdropColor(1,0,0)
		else
	       getglobal(objectname.."_NameFrame"):SetBackdropColor(0,0,0)
		end
	else return end
end

function XRaidClass:UpdateBuff(unit, objectname)
    local i = 1
    local tempbuffname = {}
    local tempbufftex = {}
    local tsize = table.getn (xraid_buffs)
    
    while UnitBuff(unit, i) do
        XRTooltipTextRight1:SetText(nil)
		XRTooltip:SetUnitBuff( unit, i )
		
		for k=1,tsize do
		  if xraid_buffs[k] == XRTooltipTextLeft1:GetText() then
		      tempbuffname[k] = XRTooltipTextLeft1:GetText()
		      tempbufftex[k] = UnitBuff( unit, i )
          end
		end
		
        i=i+1
    end
    
    local buffnum = 1
    
    for v=1,tsize do
        if tempbuffname[v] and buffnum<4 then
            local buff = getglobal(objectname.."_BuffFrame_BuffButton"..buffnum)
            local buffIcon = getglobal(objectname.."_BuffFrame_BuffButton"..buffnum.."Icon")
            buffIcon:SetTexture(tempbufftex[v])
            buff.text = tempbuffname[v]
            buff:Show()
            buffnum=buffnum+1
        end
    end
    
    while buffnum<4 do
        local buff = getglobal(objectname.."_BuffFrame_BuffButton"..buffnum)
        buffnum=buffnum+1
        buff:Hide()
    end
end

function XRaidClass:SetStandardClassColor(partyid, objectname)				
    self.class = UnitClass(partyid)
    self.GetColor = function(var) return self.db:get({self.profilePath,"Color",self.class},var)    end
    getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(self.GetColor("r"), self.GetColor("g"), self.GetColor("b"))
end

function XRaidClass:UnitDebuffType( unit, debuffType )
	local i = 1

	while UnitDebuff( unit, i ) do
		XRTooltipTextRight1:SetText(nil)
		XRTooltip:SetUnitDebuff( unit, i )
		if XRTooltipTextRight1:GetText() == debuffType then
			return 1
		end

		i = i + 1
	end

	return nil
end

-- Set the bar color
function XRaidClass:SetSmoothBarColor (bar, refbar, alpha)
	if (not refbar) then
		refbar = bar
	end
	if (not alpha) then
		alpha = 1
	end
	if (bar) then
		local barmin, barmax = refbar:GetMinMaxValues()
		if (barmin == barmax) then
			return false
		end
		local percentage = refbar:GetValue()/(barmax-barmin)
		local red
		local green
		if (percentage < 0.5) then
			red = 1
			green = 2*percentage
		else
			green = 1
			red = 2*(1 - percentage)
		end
		if ((red>=0) and (green>=0) and (alpha>=0) and (red<=1) and (green<=1) and (alpha<=1)) then
			bar:SetStatusBarColor(red, green, 0, alpha)
		end
	else
		return false
	end
end

-- Add/Remove bar textures
function XRaidClass:BarTextures()
    if (self.GetOpt("BarTextures")) then
        for num=1,60 do
            local healthbartex  = getglobal("XRaid"..num.."_StatsFrame_HealthBar_HealthBarTex")
            local manabartex    = getglobal("XRaid"..num.."_StatsFrame_ManaBar_ManaBarTex")
            
    		healthbartex:SetTexture("Interface\\AddOns\\XRaid\\images\\xraid_statusbar.tga")
    		manabartex:SetTexture("Interface\\AddOns\\XRaid\\images\\xraid_statusbar.tga")
    	end
	else
    	for num=1,60 do
    	    local healthbartex  = getglobal("XRaid"..num.."_StatsFrame_HealthBar_HealthBarTex")
            local manabartex    = getglobal("XRaid"..num.."_StatsFrame_ManaBar_ManaBarTex")
            
    		healthbartex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    		manabartex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    	end
	end
end

function XRaidClass:CheckCorrectMTs()
    for num=1,10 do
        local mtframe = getglobal("XRaidMenu"..num)
        if mtframe.mt and mtframe.mtname ~= UnitName("Raid"..mtframe.mt) then
            local mtid = self:GetRaidIdByName(mtframe.mtname)
            if mtid then 
                mtframe.mt = mtid 
            else 
                mtframe.mt = nil 
                mtframe.mtname = nil
            end
        end
    end
end

--[[--------------------------------------------------------------------------------
  Click Handlers
-----------------------------------------------------------------------------------]]

function XRaidClass:MouseUp(button)
	local id=this:GetID()
	
	if (id<=40) then
		partyid = ("raid"..id)
		if (button == "RightButton") then
		  self:CreateMenu(1, id)   
		end
	else
	   local mtframe = getglobal("XRaidMenu"..id-40)
	   local mttframe = getglobal("XRaidMenu"..id-50)
		if mtframe and mtframe.mt then          
		  partyid = ("raid"..mtframe.mt.."target")
		elseif mttframe and mttframe.mt then
		  partyid = ("raid"..mttframe.mt.."targettarget")
        elseif mtframe and not ("raid"..mtframe.mt.."target") then
          partyid = ("raid"..id-40)
		end
	end
	
	if ( SpellIsTargeting() and button == "RightButton" ) then
		SpellStopTargeting()
		return
	end
	
	if ( button == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit(partyid)
		elseif ( CursorHasItem() ) then
			DropItemOnUnit(partyid)
		else
			TargetUnit(partyid)
		end
	end
	
--	if ( button == "RightButton" ) then
--	   if ((this:GetName())==("XRaid"..id)) then 
  --        ToggleDropDownMenu(1, nil, getglobal(this:GetName().."_DropDown"), this:GetName(), 0, 0) 
    --   end
--	end
	
	getglobal("XRaid"..id):StopMovingOrSizing()
end

function XRaidClass:CreateMenu(offset, id)
    local i,cy,x,y,lines
    local alreadymt
    tempmaintank = id
    cy = 44 -- 12+32
	
    for i=1,10 do
        local mtframe = getglobal("XRaidMenu"..i)
        if mtframe.mt==id then alreadymt = i end
    end
    
    if alreadymt then
        for i=1,10 do
            local mtframe = getglobal("XRaidMenu"..i)
            getglobal("XRaidMenu"..i):Show()
            if not mtframe.mt then 
                getglobal("XRaidMenu"..i.."_Check"):Hide()
                getglobal("XRaidMenu"..i.."_Text"):SetText("Maintank "..i)
            else
                getglobal("XRaidMenu"..i.."_Check"):Show()
                name = UnitName("raid"..mtframe.mt)
                if i==alreadymt then
                    getglobal("XRaidMenu"..i.."_Text"):SetText("Del "..name)
                else
                    getglobal("XRaidMenu"..i.."_Text"):SetText(name) 
                end
            end
            cy = cy + 14
        end
    else
        for i=1,10 do
            local mtframe = getglobal("XRaidMenu"..i)
            getglobal("XRaidMenu"..i):Show()
            if not mtframe.mt then 
                getglobal("XRaidMenu"..i.."_Check"):Hide()
                getglobal("XRaidMenu"..i.."_Text"):SetText("Maintank "..i)
            else
                getglobal("XRaidMenu"..i.."_Check"):Show()
                name = UnitName("raid"..mtframe.mt)
                getglobal("XRaidMenu"..i.."_Text"):SetText(name)
            end
            cy = cy + 14
        end
    end

	XRaidMenu:SetHeight(cy)
	XRaidDropSubFrame:SetHeight(cy-32)
	XRaidMenu:ClearAllPoints()
	x,y = GetCursorPosition()
	--y = this:GetTop()*UIParent:GetScale()
	XRaidMenu:SetPoint("CENTER","UIParent","BOTTOMLEFT",x/UIParent:GetScale(),y/UIParent:GetScale())
	XRaidMenu:Show()
end

function XRaidClass:MenuOnClick()
    local id=this:GetID()
    --local mt = getglobal(objectname.."_BuffFrame_BuffButton"..i)
    
    if tempmaintank and not this.mt then
        for i=1,10 do
            local mtframe = getglobal("XRaidMenu"..i)
            if mtframe.mt==tempmaintank then mtframe.mt=nil end
        end
        getglobal("XRaidMenu"..id.."_Check"):Show()
        XRaidMenu:Hide()
        this.mt=tempmaintank
        this.mtname=UnitName("Raid"..tempmaintank)
    elseif this.mt~=tempmaintank then
        for i=1,10 do
            local mtframe = getglobal("XRaidMenu"..i)
            if mtframe.mt==tempmaintank then mtframe.mt=nil end
        end
        XRaidMenu:Hide()
        this.mt=tempmaintank
        this.mtname=UnitName("Raid"..tempmaintank)
    else
        getglobal("XRaidMenu"..id.."_Check"):Hide()
        XRaidMenu:Hide()
        this.mt = nil
        this.mtname=nil
    end
end

function XRaidClass:PlayerTip()
	local id=this:GetID()
	GameTooltip_SetDefaultAnchor(GameTooltip, this)
	partyid=nil
	if (this:GetID()<=40) then
		partyid = ("raid"..this:GetID())
	else
       local mtframe = getglobal("XRaidMenu"..id-40)
       local mttframe = getglobal("XRaidMenu"..id-50)
    	if mtframe and mtframe.mt then          
    	  partyid = ("raid"..mtframe.mt.."target")
    	elseif mttframe and mttframe.mt then
    	  partyid = ("raid"..mttframe.mt.."targettarget")
        else
          return
    	end
	end	
	if partyid then GameTooltip:SetUnit(partyid) end
end

function XRaidClass:OnClick(button)
	if (CastParty_constants and (self.GetOpt("CastParty")==1) and (this:GetID()<=40)) then
		local id=this:GetID()
		this:SetID(id+4)
		CastParty_OnClick(button)
		this:SetID(id)
	end
end

function XRaidClass:TitleMouseUp(button)
	this:StopMovingOrSizing()
end

function XRaidClass:MouseDown(button)
	if ( button == "LeftButton" and self.GetOpt("Locked") == FALSE) then
		this:StartMoving()
	end
end

function XRaidClass:FindNum(partyid)
	for num=10,60 do
		if (strfind(partyid, num)) then
			return num
		end
	end
	for num=1,9 do
		if (strfind(partyid, num)) then
			return num
		end
	end
	return nil
end

function XRaidClass:GetRaidIdByName(name)
    raidmembers = GetNumRaidMembers()	
	if (raidmembers ~= 0) then
		for i = 1, raidmembers do 
			local raidid = "raid"..i
			local buffer = UnitName(raidid)
			if (buffer == name) then
				return i
			end	
		end
	end
	return nil
end

function XRaidClass:BuffButtonOnEnter()
    local uiX, uiY = UIParent:GetCenter()
	local thisX, thisY = this:GetCenter()

	local anchor = ""
	if ( thisY > uiY ) then
		anchor = "BOTTOM"
	else
		anchor = "TOP"
	end
	
	if ( thisX < uiX  ) then
		if ( anchor == "TOP" ) then
			anchor = "TOPLEFT"
		else
			anchor = "BOTTOMRIGHT"
		end
	else
		if ( anchor == "TOP" ) then
			anchor = "TOPRIGHT"
		else
			anchor = "BOTTOMLEFT"
		end
	end
	XRTooltip:SetOwner(this, "ANCHOR_" .. anchor)
	XRTooltip:SetText(this.text)
end

--[[--------------------------------------------------------------------------------
  Chat Handlers
-----------------------------------------------------------------------------------]]

function XRaidClass:RaidInvite(msg)

    if ( not GetGuildInfo("player") ) then
		self.cmd:result("You need to be in a guild to massinvite players.")
		return
	end
	
	if ( GetNumRaidMembers() == 0 ) then
	   self.cmd:result("You are not in a raid group.")
	   return
	end
	
	local args = ace.ParseWords(msg)
	if (IsRaidLeader() or IsRaidOfficer()) then
	  level = tonumber(args[1])
	  if ( level and level>0 and level<61) then
	      SendChatMessage("XRaid :: Raid invite in 10 seconds for level "..level, "GUILD")
	      self.cmd:result("Please open your guild overview for this function to work properly!")
	      Timex:AddNamedSchedule(nil,10,nil,nil,XRaid["GuildInvite"],self,level)
	  end
	  return
	elseif (not IsRaidLeader() and not IsRaidOfficer()) then
	  self.cmd:result("You need to be promoted to massinvite players.")
	  return
	else
	  self.cmd:result("Critical Error, please report the problem to the author.")
	  return
	end
end

function XRaidClass:ChangeLock()
    if ( self.TogOpt("Locked") ) then
        self.cmd:result(XRAID_CMD_LOCK_MSG)
    else
        self.cmd:result(XRAID_CMD_UNLOCK_MSG)
    end
    self:RAID_ROSTER_UPDATE()
end

function XRaidClass:ChangeBarTextures()
    if ( self.TogOpt("BarTextures") ) then
        self.cmd:result(XRAID_CMD_BARTEX_MSG)
    else
        self.cmd:result(XRAID_CMD_NOBARTEX_MSG)
    end
    self:BarTextures()
end

function XRaidClass:ChangeScale(value)
    local args = ace.ParseWords(value)
    scale = tonumber(args[1])
    if (scale and scale>=0.5 and scale<=1.5) then
        self:Scale(scale)
        self.SetOpt("Scale_Raid", scale)
        self.cmd:result(format(XRAID_CMD_SCALE_MSG, scale))
    else
        self.cmd:result(XRAID_CMD_SCALE_FALSE_MSG)
    end
end

function XRaidClass:ChangeTransparency(value)
    local args = ace.ParseWords(value)
    value = tonumber(args[1])
    if (value and value>0 and value<=1) then
        self.SetOpt("Transparency", value)
        self:SetTransparency()
        self.cmd:result(format(XRAID_CMD_TRANS_MSG, value))
    else
        self.cmd:result(XRAID_CMD_TRANS_FALSE_MSG)
    end
end

function XRaidClass:ChangeTextTransparency(value)
    local args = ace.ParseWords(value)
    value = tonumber(args[1])
    if (value and value>0 and value<=1) then
        self.SetOpt("TextTransparency", value)
        self:SetTransparency()
        self.cmd:result(format(XRAID_CMD_TEXTTRANS_MSG, value))
    else
        self.cmd:result(XRAID_CMD_TEXTTRANS_FALSE_MSG)
    end
end

function XRaidClass:ChangeUpdaterate(value)
    local args = ace.ParseWords(value)
    value = tonumber(args[1])
    if (value and value>0 and value<=1) then
        self.SetOpt("UpdateTimer", value)
        self:DeleteMTTimer()
        self:AddMTTimer()
        self.cmd:result(format(XRAID_CMD_UPD_MSG, value))
    else
        self.cmd:result(XRAID_CMD_UPD_FALSE_MSG)
    end
end

function XRaidClass:ChangeToGroupView()
    if (self.GetOpt("SortRaidByClass")) then
        self.SetOpt("SortRaidByClass", FALSE)
        self:RAID_ROSTER_UPDATE()
        self.cmd:result(XRAID_CMD_GRPVIEW_MSG)
    else
        self.cmd:result(XRAID_CMD_GRPVIEW_FALSE_MSG)
    end
end

function XRaidClass:ChangeToClassView()
    if (self.GetOpt("SortRaidByClass") == FALSE) then
        self.SetOpt("SortRaidByClass", TRUE)
        self:RAID_ROSTER_UPDATE()
        self.cmd:result(XRAID_CMD_CLASSVIEW_MSG)
    else
        self.cmd:result(XRAID_CMD_CLASSVIEW_FALSE_MSG)
    end
end

function XRaidClass:ChangeToHealthPercView()
    self.SetOpt("ShowRaidPercents", 1)
    self.cmd:result(format(XRAID_CMD_HEALTH_MSG, "percent"))
    self:RAID_ROSTER_UPDATE()
end

function XRaidClass:ChangeToHealthDeficitView()
    self.SetOpt("ShowRaidPercents", 2)
    self.cmd:result(format(XRAID_CMD_HEALTH_MSG, "deficit"))
    self:RAID_ROSTER_UPDATE()
end

function XRaidClass:ChangeToHealthAbsoluteView()
    self.SetOpt("ShowRaidPercents", 3)
    self.cmd:result(format(XRAID_CMD_HEALTH_MSG, "absolute"))
    self:RAID_ROSTER_UPDATE()
end

function XRaidClass:ChangeToNoneHealthView()
    self.SetOpt("ShowRaidPercents", 0)
    self.cmd:result(XRAID_CMD_NOHEALTH_MSG)
    self:RAID_ROSTER_UPDATE()
end

function XRaidClass:ShowGroup(value)
    local args = ace.ParseWords(value)
    num = tonumber(args[1])
    if (num and num>=1 and num<=8) then
        self.SetOpt("ShowGroup"..num, TRUE)
        self.cmd:result(format(XRAID_CMD_SHOWGROUP_MSG, num))
    elseif (args[1]== "targets") then
        self.SetOpt("ShowGroup9", TRUE)
        self:DeleteMTTimer()
        self:AddMTTimer()
        getglobal("XRaid_Grp9"):Show()
        self.cmd:result(XRAID_CMD_SHOWMTTAR_MSG)
    elseif (args[1]== "all") then
        for num=1,8 do
            self.SetOpt("ShowGroup"..num, TRUE)
        end
    else
        self.cmd:result(XRAID_CMD_FALSESHOWGROUP_MSG)
    end
    self:RAID_ROSTER_UPDATE()
end

function XRaidClass:HideGroup(value)
    local args = ace.ParseWords(value)
    num = tonumber(args[1])
    if (num and num>=1 and num<=8) then
        self.SetOpt("ShowGroup"..num, FALSE)
        self.cmd:result(format(XRAID_CMD_HIDEGROUP_MSG, num))
    elseif (args[1]== "targets") then
        self.SetOpt("ShowGroup9", FALSE)
        self:DeleteMTTimer()
        getglobal("XRaid_Grp9"):Hide()
        self.cmd:result(XRAID_CMD_HIDEMTTAR_MSG)
    elseif (args[1]== "all") then
        for num=1,8 do
            self.SetOpt("ShowGroup"..num, FALSE)
        end
    else
        self.cmd:result(XRAID_CMD_FALSEHIDEGROUP_MSG)
    end
    self:RAID_ROSTER_UPDATE()
end

function XRaidClass:ResetPosition()
    for i = 1, 9 do
        getglobal("XRaid_Grp"..i):ClearAllPoints()
        getglobal("XRaid_Grp"..i):SetPoint("CENTER", "UIParent", "CENTER",0,0)
    end
end

function XRaidClass:ResetConfig()
	self.db:reset(self.profilePath, self.defaults)	
	self:RAID_ROSTER_UPDATE()
	self.cmd:result("Settings resetted")
end

function XRaidClass:Report()
    self.cmd:report({
        {text=XRAID_VAR_LOCK_TEXT, val=self.GetOpt("Locked"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_SORT_TEXT, val=self.GetOpt("SortRaidByClass"), map=RAID_SORT},
        {text=XRAID_VAR_BARTEX_TEXT, val=self.GetOpt("BarTextures"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_SCALE_TEXT, val=self.GetOpt("Scale_Raid")},
        {text=XRAID_VAR_UPDTIMER_TEXT, val=self.GetOpt("UpdateTimer")},
        {text=XRAID_VAR_TRANS_TEXT, val=self.GetOpt("Transparency")},
        {text=XRAID_VAR_TTRANS_TEXT, val=self.GetOpt("TextTransparency")},
        {text=XRAID_VAR_CASTPARTY_TEXT, val=self.GetOpt("CastParty"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP1_TEXT, val=self.GetOpt("ShowGroup1"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP2_TEXT, val=self.GetOpt("ShowGroup2"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP3_TEXT, val=self.GetOpt("ShowGroup3"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP4_TEXT, val=self.GetOpt("ShowGroup4"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP5_TEXT, val=self.GetOpt("ShowGroup5"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP6_TEXT, val=self.GetOpt("ShowGroup6"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP7_TEXT, val=self.GetOpt("ShowGroup7"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_GRP8_TEXT, val=self.GetOpt("ShowGroup8"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_MTTARGETS_TEXT, val=self.GetOpt("ShowGroup9"), map=ACE_MAP_ONOFF},
        {text=XRAID_VAR_BARTEX_TEXT, val=self.GetOpt("BarTextures"), map=ACE_MAP_ONOFF},
    })
end

--[[--------------------------------------------------------------------------------
  Create and Register Addon Object
-----------------------------------------------------------------------------------]]

XRaid = XRaidClass:new()
XRaid:RegisterForLoad()
