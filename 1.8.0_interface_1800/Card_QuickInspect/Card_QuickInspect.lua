local str = CARDQI_STRINGS
local opt = {"rank","bonus","weapons","rarity","special","sets"}
local DEFAULT_OPTIONS = {compare = TRUE}

CardQI = AceAddonClass:new({
	name          = "QuickInspect",
	description   = str.DESCRIPTION,
	version       = "1.6.3",
	releaseDate   = str.RELEASEDATE,
	aceCompatible = "100",
	author        = "Cardella",
	db            = AceDbClass:new("CardQIDB"),
	defaults      = DEFAULT_OPTIONS,
	cmd           = AceChatCmdClass:new({"/qi", "/quickinspect"}, CARDQI_CMD_OPTIONS)
})

CardQI:RegisterForLoad()

function CardQI:Initialize()
	self.AddVal = function(p,k,v) if (self.db:get(p,k)) then self.db:set(p,k,self.db:get(p,k)+v) else self.db:set(p,k,v) end end
	self.GetOpt = function(var) return self.db:get(self.profilePath,var) end
	self.SetOpt = function(var,val) self.db:set(self.profilePath,var,val) end
	self.TogOpt = function(var) return self.db:toggle(self.profilePath,var) end
	self.Result = function(text, val, map)
		map = map or CARDQI_MAP
		self.cmd:result(text," ",format("[%s]",map[val or 0]))
	end
	self.ArgIsValid = function(arg,validargs,valid)
		for k, v in validargs do if arg == v then valid = TRUE break end end
		if not valid then self.cmd:result(format(str.INVALID_OPTION,arg)) end
		return valid
	end
	InspectFrame_LoadUI();
end

function CardQI:Enable()
	self:Hook("InspectUnit")
	self:Hook("InspectFrame_OnUpdate")
	self:Hook("UnitPopup_OnClick")
	UnitPopupButtons["INSPECT"] = {text = TEXT(INSPECT), dist = 0}
	UnitPopupButtons["QUICKINSPECT"] = {text = "Quick Inspect", dist = 0}
	UnitPopupButtons["QUICKINSPECTSELF"] = {text = "Quick Inspect", dist = 0}
	UnitPopupMenus["SELF"] = {"LOOT_METHOD","LOOT_THRESHOLD","LOOT_PROMOTE","LEAVE","QUICKINSPECTSELF","CANCEL"}
	UnitPopupMenus["PARTY"] = {"WHISPER","PROMOTE","LOOT_PROMOTE","UNINVITE","INSPECT","QUICKINSPECT","TRADE","FOLLOW","DUEL","CANCEL"}
	UnitPopupMenus["PLAYER"] = {"WHISPER","INSPECT","QUICKINSPECT","INVITE","TRADE","FOLLOW","DUEL","CANCEL"}
end

function CardQI:Disable()
	InspectTitleText:Hide()
	UnitPopupButtons["INSPECT"] = {text = TEXT(INSPECT), dist = 1}
	UnitPopupMenus["SELF"] = {"LOOT_METHOD","LOOT_THRESHOLD","LOOT_PROMOTE","LEAVE","CANCEL"}
	UnitPopupMenus["PARTY"] = {"WHISPER","PROMOTE","LOOT_PROMOTE","UNINVITE","INSPECT","TRADE","FOLLOW","DUEL","CANCEL"}
	UnitPopupMenus["PLAYER"] = {"WHISPER","INSPECT","INVITE","TRADE","FOLLOW","DUEL","CANCEL"}
end

--------------------------------------------------------------------------------------
--			Hooks
--------------------------------------------------------------------------------------

function CardQI:UnitPopup_OnClick()
	self:CallHook("UnitPopup_OnClick")
	local index = this.value
	local button = UnitPopupMenus[this.owner][index]
	if button == "QUICKINSPECT" then self:ScanInventory() elseif button == "QUICKINSPECTSELF" then self:ScanInventory("player") end
end

-- GoodInspect
function CardQI:InspectUnit(unit)
	HideUIPanel(InspectFrame)
	if (UnitIsPlayer(unit) and UnitIsVisible(unit)) then
		NotifyInspect(unit)
		InspectFrame.unit = unit
		ShowUIPanel(InspectFrame)
		local guildname, guildtitle = GetGuildInfo(unit)
		if (guildname and guildtitle) then
			InspectTitleText:SetText(format(TEXT(GUILD_TITLE_TEMPLATE), guildtitle, guildname))
			InspectTitleText:Show()
		else
			InspectTitleText:Hide()
		end
	end
end

function CardQI:InspectFrame_OnUpdate() end

--------------------------------------------------------------------------------------
--			Scan
--------------------------------------------------------------------------------------

function CardQI:ScanInventory(t,compare)
	if (not t or t ~= "player") then t = (UnitIsPlayer("target") and not UnitIsUnit("target","player")) and "target" or "player" end
	local scan = function(t)
		local H = (t == "target" and UnitIsEnemy("player",t)) and 1
		local ss = H and not self.GetOpt("Hspecial") or not self.GetOpt("special")
		local sw = H and not self.GetOpt("Hweapons") or not self.GetOpt("weapons")
		local sb = H and not self.GetOpt("Hbonus") or not self.GetOpt("bonus")
		for i = 1, 18 do
			local link = GetInventoryItemLink(t, i)
			if (link) then
				local _,_,color,name = strfind(link, "|c(%x+)|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r")
				self.AddVal({t,"itemcounter"},color,1)
				if (i>=16 and i<=18) then self.db:set({t,"weapons",i},"color",color) end
				local list = self.GetOpt("list") or CARDQI_SCAN_DEFAULT_ITEM_LIST
				for i = 1, getn(list) do if (strfind(name,list[i])) then self.db:set({t,"special","items"},name,color) end end
				CardQIHiddenTooltip:SetInventoryItem(t, i)
				self:ScanItem(t, i, ss, sw, sb)
			end
		end
		return t
	end
	if compare then
		if UnitIsPlayer("target") then self:SetCompareTooltip(scan("target")) end
	else
		local H = UnitIsEnemy(t,"player")
		self:SetFrame(scan(t))
		if t == "target" and self.db:get(t) and (UnitClass(t) == UnitClass("player") or self.GetOpt("compare") ~= "class") then
			if (H and self.GetOpt("Hcompare")) or (not H and self.GetOpt("compare")) then
				self:SetCompareTooltip(scan("player"))
			end
		end
	end
	self.db:set("target")
	self.db:set("player")
	GameTooltip:Hide()
end

function CardQI:ScanItem(t, slot, ss, sw, sb)
	local line = "CardQIHiddenTooltipText"
	local scan = function(str,p,_,v)
		for i = 1, getn(p) do if (not v) then _,_,v = strfind(str,p[i]) else break end end
		return v
	end
	for i = 2, CardQIHiddenTooltip:NumLines() do
		local text = getglobal(line.."Left"..i):GetText()
		if (text == " \n") then
			text = getglobal(line.."Left"..i+1):GetText()
			local _,_,setname,maxitems = strfind(text, "([^%(]+) %(%d+%/(%d+)%)")
			self.db:set({t,"sets",setname},"maxitems",maxitems)
			self.AddVal({t,"sets",setname},"items",1)
			return
		end
		local v = ss and scan(text,CARDQI_SCAN_SPECIAL_ENCHANTS)
		if v then self.db:set({t,"special","enchants"},v,1) end
		if (sw and slot>=16 and slot<=18 and not v) then
			local right = getglobal(line.."Right"..i):IsVisible() and getglobal(line.."Right"..i):GetText()
			for stat in CARDQI_SCAN_WEAPONS do
				v = scan(text,CARDQI_SCAN_WEAPONS[stat])
				if v then self.db:set({t,"weapons",slot},stat,v) end
				local v2 = right and scan(right,CARDQI_SCAN_WEAPONS[stat])
				if v2 then self.db:set({t,"weapons",slot},stat,v2) end
			end
		end
		if (sb and not v) then
			for cat in CardQI_Scan do
				for bonus in CardQI_Scan[cat] do
					v = CardQI_Scan[cat][bonus].bonus and scan(text,CardQI_Scan[cat][bonus].bonus)
					local bt, r, g, b
					if CardQI_Scan[cat][bonus].desc and CardQI_Scan[cat][bonus].desc[3] then -- same pattern for bonus and enchant, so we check the color
						r, g, b = getglobal(line.."Left"..i):GetTextColor()
						bt = (r+g+b > 2.7) and "bonus" or "enchant"
					else
						bt = v and "bonus" or "enchant"
					end
					if (not v and CardQI_Scan[cat][bonus].enchant) then v = scan(text,CardQI_Scan[cat][bonus].enchant) end
					if v then self.AddVal({t,"stats",cat,bonus},bt,v) end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------
--			Display
--------------------------------------------------------------------------------------

function CardQI:SetFrame(t)
	if not self.db:get(t) then UIErrorsFrame:AddMessage(str.NO_BONUS_DETECTED, 1, 1, 0, 1, 5) return end
	if t == "player" then CardQITooltip:Hide() end
	CardQIFrame:SetOwner(UIParent, "ANCHOR_PRESERVE")
	CardQIFrame:SetText(self:GetHeader(t))
	local H = UnitIsEnemy(t,"player") and "H" or ""
	for i = 1, getn(opt) do if not self.GetOpt(H..opt[i]) then CardQIFrame:AddLine(self[opt[i]](self,t,"")) end end
	CardQIFrame:Show()
end

function CardQI:SetCompareTooltip(t)
	CardQITooltip:SetOwner(CardQIFrame, "ANCHOR_NONE")
	CardQITooltip:SetPoint("TOPLEFT", "CardQIFrame", "TOPRIGHT", 0, -10)
	CardQITooltip:SetText(self:GetHeader(t))
	local H = UnitIsEnemy(t,"player") and "H" or ""
	for i = 1, getn(opt) do if not self.GetOpt(H..opt[i]) then CardQITooltip:AddLine(self[opt[i]](self,t,"")) end end
	CardQITooltip:Show()
end

function CardQI:GetHeader(t)
	local col = UnitIsEnemy(t,"player") and "|cffff7d00" or "|cff1eff00"
	local g = GetGuildInfo(t) and " <"..GetGuildInfo(t)..">" or ""
	return col..UnitName(t).." "..UnitClass(t).." "..UnitLevel(t)..g
end

function CardQI:rank(t)
	local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank(t))
	if (rankNumber>0) then return rankName.." ("..str.TEXT_RANK.." "..rankNumber..")" end
end

function CardQI:bonus(t,l)
	for cat in self.db:get({t},"stats") or {} do
		l = l.."\n|cffffff00"..CardQI_Scan[cat].desc[1].."|cffffffff"
			for bonus in self.db:get({t,"stats"},cat) do
				local get = function(arg) return self.db:get({t,"stats",cat,bonus},arg) end
				local p = CardQI_Scan[cat][bonus].desc[2] or ""
				local b = get("bonus") and get("bonus")..p.." " or ""
				local e = get("enchant") and "|cff00ff00+"..get("enchant")..p.."|cffffffff" or ""
				local total = (get("bonus") and get("enchant")) and " ("..get("bonus")+get("enchant")..p..")" or ""
				l = l.."\n   "..CardQI_Scan[cat][bonus].desc[1].." : "..b..e..total
			end
	end
	return l
end

function CardQI:weapons(t,l)
	if self.db:get({t},"weapons") then
		l = l.."|cffffff00"..CARDQI_SCAN_WEAPONS.desc[1].."|cffffffff"
		for slot = 16, 18 do
			if self.db:get({t,"weapons"},slot) then
				local get = function(arg) return self.db:get({t,"weapons",slot},arg) end
				local color = get("color") and "\n   |c"..get("color") or ""
				local st = get("weaponSubType") and get("weaponSubType").."|cffffffff  " or ""
				local wt = get("weaponType") and "("..get("weaponType")..")|cffffffff" or ""
				local dps = get("dps") and "\n      "..get("dps").." dps" or ""
				local b = get("block") and "\n      "..str.BLOCK.." : "..get("block") or ""
				local spd = get("speed") and "  -  ("..str.SPEED.." "..get("speed")..")" or ""
				local e = get("enchant") and "\n      |cff00ff00"..get("enchant") or ""
				l = l..color..st..wt..dps..b..spd..e
			end
		end
	end
	return l
end

function CardQI:rarity(t,l)
	for c, n in self.db:get({t},"itemcounter") or {} do l = l.."|c"..c.."("..n..") " end
	return "\n"..l
end

function CardQI:special(t,l)
	for n, c in self.db:get({t,"special"},"items") or {} do l = l.."\n|c"..c..n end
	for e in self.db:get({t,"special"},"enchants") or {} do l = l.."\n|cff00ff00*"..e.."*" end
	return l
end

function CardQI:sets(t,l)
	for set in self.db:get({t},"sets") or {} do
		l = l.."\n"..set.." ("..self.db:get({t,"sets",set},"items").."/"..self.db:get({t,"sets",set},"maxitems")..")"
	end
	return l
end

--------------------------------------------------------------------------------------
--			Slash commands
--------------------------------------------------------------------------------------

function CardQI:Display(arg)
	if self.ArgIsValid(arg,opt) then self.Result(str[strupper(arg)], self.TogOpt(arg) and 0 or 1) end
end

function CardQI:Hostile(arg)
	if self.ArgIsValid(arg,{"compare","rank","bonus","weapons","special","rarity","sets"}) then
		self.Result(str[strupper(arg)].." "..str.FORHOSTILEPLAYERS,self.TogOpt("H"..arg) and 0 or 1)
	end
end

-- custom scans
function CardQI:SetList()
	if not self.GetOpt("list") then
		self.SetOpt("list",{})
		for i=1,getn(CARDQI_SCAN_DEFAULT_ITEM_LIST) do self.db:insert(self.profilePath,"list",CARDQI_SCAN_DEFAULT_ITEM_LIST[i]) end
	end
end

function CardQI:AddSpecial(text)
	if (not text or text == "") then self.cmd:result("|cffffff00"..str.ADD_ERR) return end
	self:SetList()
	self.db:insert(self.profilePath,"list",text)
	self:ListSpecial()
end

function CardQI:RemoveSpecial(index)
	index = tonumber(index)
	if (not index) then 
		self.cmd:result("|cffffff00"..str.REMOVE_ERR)
	else
		self:SetList()
		if self.GetOpt("list")[index] then
			local item = self.GetOpt("list")[index]
			self.db:remove(self.profilePath,"list",index)
			self.cmd:result(format("|cffffff00"..str.REMOVE,item))
		end
	end
	self:ListSpecial()
end

function CardQI:ListSpecial()
	local list = self.GetOpt("list") or CARDQI_SCAN_DEFAULT_ITEM_LIST
	if getn(list) > 0 then
		for i = 1, getn(list) do self.cmd:result("["..i.."] "..list[i]) end
	else
		self.cmd:result(str.LIST_IS_EMPTY)
	end
end

function CardQI:Compare(arg)
	local args = {{"on","off","class"}, on = TRUE, off = FALSE, class = "class"}
	if self.ArgIsValid(arg,args[1]) then self.SetOpt("compare",args[arg]) self.Result(str.COMPARE,self.GetOpt("compare")) end
end

function CardQI:ResetDisplay()
	for k, v in opt do self.SetOpt(v) end
	self.cmd:result(str.RESET_DISPLAY)
end

function CardQI:ResetHostile()
	for k, v in opt do self.SetOpt("H"..v) end
	self.SetOpt("Hcompare")
	self.cmd:result(str.RESET_HOSTILE)
end

function CardQI:ResetList()
	self.SetOpt("list")
	self.cmd:result(str.RESET_LIST)
end

function CardQI:ResetAll()
	CardQIDB[self.profilePath[1][1]][self.profilePath[2]] = {}
	for k, v in DEFAULT_OPTIONS do self.SetOpt(k,v) end
end

function CardQI:Report()
	local t = {}
	for k,v in opt do tinsert(t,{text=str[strupper(v)], val=(self.GetOpt(v) and 0 or 1), map=CARDQI_MAP}) end
	tinsert(t,{text=str.COMPARE, val=self.GetOpt("compare"), map=CARDQI_MAP})
	tinsert(t,{text=str.CUSTOMLIST, val=self.GetOpt("list") and 1 or 0, map=CARDQI_MAP})
	tinsert(t,{text=str.COMPARE.." "..str.FORHOSTILEPLAYERS, val=self.GetOpt("Hcompare"), map=CARDQI_MAP})
	for k,v in opt do tinsert(t,{text=str[strupper(v)].." "..str.FORHOSTILEPLAYERS, val=(self.GetOpt("H"..v) and 0 or 1), 
													map=CARDQI_MAP}) end
	self.cmd:report({unpack(t)})
end
