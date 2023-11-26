local AHWmute
local Default_Options = {
	Show 		=	TRUE,
	Tooltip = TRUE,
	HideDR	= TRUE
}

--[[-----------
	Create Object
--------------]]

AHWipe	 				= AceAddonClass:new({
	name					= "AH_Wipe",
	version				= "a/R.8",
	releaseDate		=	"10-12-05",
	author				=	"Neriak",
	email					= "pk@neriak.de",
	website				=	"http://www.wowace.com",
	aceCompatible	= "102",
	category			= ACE_CATEGORY_INTERFACE,
	db						= AceDbClass:new("AHWipeDB"),
	defaults			= Default_Options,
	cmd						= AceChatCmdClass:new(AHW.Commands, AHW.CmdOptions),
})

--[[-----------
	Initialize it
--------------]]

function AHWipe:Initialize()
	self.Get		= function(v) return self.db:get({self.profilePath}, v) end
	self.Set		= function(v, vl) self.db:set({self.profilePath}, v, vl) end
	self.Tog		= function(v)	return self.db:toggle({self.profilePath}, v) end
	self.TogMsg = function(v, txt) self.cmd:status(txt, self.Tog(v), ACEG_MAP_ONOFF) end
end

--[[--------------
	Enable / Disable
-----------------]]

function AHWipe:Enable()
	self:RegisterEvent("AUCTION_HOUSE_SHOW", "Start")
end

function AHWipe:Disable()
	AHWButton:Hide()
end

function AHWipe:Start()
	if self.Get("Show") then
		self:CheckPos()
		self.ShowB()
		self:HookScript(AHWButton, "OnMouseDown", "StartMoving")
		self:HookScript(AHWButton, "OnMouseUp", "StopMoving")
	end
	if self.Get("Auto") then
		self:Wipe()
	end
end

--[[----------
	Chat Options
-------------]]

function AHWipe:Show()
	if not self.TogMsg("Show", AHW.Display) then
		AHWButton:Hide()
	end
end

function AHWipe:HideDR()
	self.TogMsg("HideDR", AHW.HideDR)
end

function AHWipe:Tooltip()
	if self.Get("Tooltip") then
		GameTooltip_SetDefaultAnchor(GameTooltip,this)
		GameTooltip:AddLine(AHW.Tooltip)
		GameTooltip:Show()
	end
end

function AHWipe:HideTT()
	self.TogMsg("Tooltip", AHW.HideTT)
end

function AHWipe:Restore()
	self.Set("Pos")
	AHWButton:ClearAllPoints() 
	AHWButton:SetPoint("TOPLEFT", "AuctionFrameBrowse", "TOPLEFT", 746, -14)
	if not AHWmute then
		self.cmd:result(AHW.ButtonReset)
	end
end

function AHWipe:Auto()
	self.TogMsg("Auto", AHW.Auto)
end

function AHWipe:Report()
	local p
	if self.Get("Pos") then 
 		p = TRUE
	else
		p = FALSE
 	end
	self.cmd:report({
		{text=AHW.Auto, val=self.Get("Auto"), map=ACEG_MAP_ONOFF},
		{text=AHW.Display, val=self.Get("Show"), map=ACEG_MAP_ONOFF},
		{text=AHW.HideDR, val=self.Get("HideDR"), map=ACEG_MAP_ONOFF},
		{text=AHW.HideTT, val=self.Get("Tooltip"), map=ACEG_MAP_ONOFF},
		{text=AHW.ButtonPos, val=p, map=ACEG_MAP_SAVED},
})
end				

--[[----------------------------
	I like to move it, move it ...
-------------------------------]]

function AHWipe:StartMoving()
	if IsShiftKeyDown() and arg1 == "RightButton" then
		self:CallScript(AHWButton, "OnMouseDown")
		AHWButton:StartMoving()
	else
		return
	end
end

function AHWipe:StopMoving()
	if IsShiftKeyDown() and arg1 == "RightButton" then
		self:CallScript(AHWButton, "OnMouseUp")
		AHWButton:StopMovingOrSizing()	
		local cx, cy = AuctionFrameBrowse:GetLeft(), AuctionFrameBrowse:GetTop() 
		local ax,ay  = AHWButton:GetLeft(), AHWButton:GetTop() 
		local x,y 
		x = ax - cx
		y = ay - cy
		local tmpDB = {x = x, y = y}
		self:debug("x="..x.." : ".."y="..y)
		self.Set("Pos", tmpDB)
		AHWButton:ClearAllPoints()
		AHWButton:SetPoint("TOPLEFT", "AuctionFrameBrowse", "TOPLEFT", x, y)
		self.cmd:result(AHW.ButtonPos..ACEG_MAP_SAVED[1])
	else
		return
	end
end

function AHWipe:Pos()
	local dbp = self.Get("Pos")
		self:debug("x="..dbp.x.." : ".."y="..dbp.y)
	AHWButton:ClearAllPoints()
	AHWButton:SetPoint("TOPLEFT", "AuctionFrameBrowse", "TOPLEFT", dbp.x, dbp.y)
end

function AHWipe:CheckPos()
	if self.Get("Pos") then 
		self:Pos()
	else 
		AHWmute = TRUE
		self:Restore()
	end
end

function AHWipe:ShowB() 
	AHWButton:SetParent("AuctionFrameBrowse") 
	AHWButton:Show() 
end

--[[-------------------------------------
	The function Blizzard never gave to us.
----------------------------------------]]

function AHWipe:Wipe()
	PlaySound("igMainMenuOptionCheckBoxOn")
	IsUsableCheckButton:SetChecked()
	UIDropDownMenu_SetSelectedValue(BrowseDropDown, -1)
	AuctionFrameBrowse.selectedClass = nil
  AuctionFrameBrowse.selectedClassIndex = nil
	AuctionFrameFilters_Update()
	BrowseName:SetText("")
	BrowseName:SetFocus()
	BrowseMinLevel:SetText("")
	BrowseMaxLevel:SetText("")
	AuctionDressUpModel:Dress()
  if self.Get("HideDR") or self.Get("Auto") then
		ShowOnPlayerCheckButton:SetChecked()
		SHOW_ON_CHAR = "0"
		HideUIPanel(AuctionDressUpFrame)
	end
end


--[[------------------------
	The End -> Register Object
---------------------------]]

AHWipe:RegisterForLoad()