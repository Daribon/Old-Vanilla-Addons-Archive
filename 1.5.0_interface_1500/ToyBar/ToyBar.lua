-- ToyBar Mod 0.4.2
-- ..for all your toy management needs
--
-- Author: Huki / Boulderfist

ToyBar_Config = {}
ToyBar_EData = {}
ToyBar_HData = {}

local TB_VERSION = "0.4.2"
local NUM_EQUIPPED = 8
local NUM_HELD = 25

local tb_cfg = nil
local tb_default = {}
local tb_tick = 0
local tb_inCombat = nil
local tb_queue = {}
local tb_used = {}
tb_dragged = nil
local tb_slotNames = {"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", 
		      "Wrist", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", 
		      "MainHand", "SecondaryHand", "Ranged", "Tabard",[0]="Ammo"}

local BORDER = 8
local T_COL = "|cffffff50" -- title color
local H_COL = "|cffffff90" -- header color

--BINDINGS
BINDING_HEADER_TOYBAR = "ToyBar"
BINDING_NAME_TOYBARUSE1 = "Use ToyBar Button 1"
BINDING_NAME_TOYBARUSE2 = "Use ToyBar Button 2"
BINDING_NAME_TOYBARUSE3 = "Use ToyBar Button 3"
BINDING_NAME_TOYBARUSE4 = "Use ToyBar Button 4"
BINDING_NAME_TOYBARUSE5 = "Use ToyBar Button 5"
BINDING_NAME_TOYBARUSE6 = "Use ToyBar Button 6"

local function tb_out(string)
	string = gsub(string, "$H", H_COL)
	string = gsub(string, "$T", T_COL)
	DEFAULT_CHAT_FRAME:AddMessage(string)
end

local function tb_extractID(itemLink)
	if not itemLink then return nil end
	local a,b, id = strfind(itemLink,"item:(%d+):")
	
	return tonumber(id)
end

local function tb_extractName(itemLink)
	if not itemLink then return nil end
	local a,b, name = strfind(itemLink,"[[]([%w ]+)")
	
	return name
end

local function tb_getSlot(id, sub)
	if sub then
		return ToyBar_HData[id]["bag"], ToyBar_HData[id]["slot"]
	else
		return "player", ToyBar_EData[id]["slot"]
	end
end

local function tb_searchMatch(link)
	if tb_cfg["search"] then
		local match = nil
		local search = tb_cfg["search"]
		local itemID = tb_extractID(link)

		if itemID then
			for id, val in search do
				if type(val) ~= "table" then
					search[id] = nil
				elseif itemID == id then
					return true, val[1], val[2]
				end
			end
		end
	end
	
	return nil
end

local function tb_setDefault(slot, id)
	tb_cfg["defaults"][slot] = id
end

local function tb_formatTime(seconds)
	if seconds > 300 then
		return ceil(seconds/60).."m"
	else
		return floor(seconds/60)..":"..format("%.2d",mod(seconds,60))
	end
end

local function tb_findDefault(itemSlot)
	if not tb_cfg["defaults"] or not tb_cfg["defaults"][itemSlot] or MerchantFrame:IsVisible() or CursorHasItem() then
		return
	end
	
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link then
				local id = tb_extractID(link)
				if tb_cfg["defaults"][itemSlot] == id then
					PickupContainerItem(bag, slot)
					PickupInventoryItem(itemSlot)
				end
			end
		end
	end
end

local function tb_updateHotkeys()
	for id = 1,NUM_EQUIPPED do
		local action = "TOYBARUSE"..id
		local text = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_")

		text = gsub(text, "CTRL--", "C-")
		text = gsub(text, "ALT--", "A-")
		text = gsub(text, "SHIFT--", "S-")
		text = gsub(text, "Num Pad", "NP")
		text = gsub(text, "Backspace", "Bksp")
		text = gsub(text, "Spacebar", "Space")
		text = gsub(text, "Page", "Pg")
		text = gsub(text, "Down", "Dn")
		text = gsub(text, "Arrow", "")
		text = gsub(text, "Insert", "Ins")
		text = gsub(text, "Delete", "Del")
		if text then getglobal("ToyBar_E"..id.."HotKey"):SetText(text) end
	end
	
	
end

local function tb_getCorner()
	local lr = "RIGHT"
	local ud = "TOP"
	
	if tb_cfg["horiz"] > 0 then
		lr = "LEFT"
	end
	if tb_cfg["vert"] > 0 then
		ud = "BOTTOM"
	end
	
	return ud..lr
end

local function tb_newAnchor(button)
	local x = button:GetLeft()
	local y = button:GetBottom()
	local hDir = tb_cfg["horiz"]
	local vDir = tb_cfg["vert"]
	local rel = tb_getCorner()
	
	if x and y then
		if vDir < 0 then
			y = y + tb_cfg["tsize"];
		end
		if hDir < 0 then
			x = x + tb_cfg["tsize"];
		end
		ToyBar:ClearAllPoints()
		ToyBar:SetPoint(rel, "UIParent","BOTTOMLEFT",x-hDir*BORDER,y-vDir*BORDER)
	end
end

local function tb_getWrap()
	local B_ROW = tb_cfg["brow"]
	
	if B_ROW == -1 then
		B_ROW = floor((getn(ToyBar_EData)*(tb_cfg["tsize"]+tb_cfg["tgap"]) - tb_cfg["tgap"] + tb_cfg["bgap"])/(tb_cfg["bsize"]+tb_cfg["bgap"]))
		if B_ROW < 1 then B_ROW = 1 end
	end
	
	return B_ROW
end

local function tb_sizeBackdrop()

	local B_ROW = tb_getWrap()
	local heldW = min(B_ROW, getn(ToyBar_HData), NUM_HELD)
	local heldH = min(getn(ToyBar_HData), NUM_HELD)
	local eqW = min(getn(ToyBar_EData), NUM_EQUIPPED)	
	local width = max(tb_cfg["tsize"],eqW*(tb_cfg["tsize"]+tb_cfg["tgap"])-tb_cfg["tgap"]+2*BORDER, heldW*(tb_cfg["bsize"]+tb_cfg["bgap"]) - tb_cfg["bgap"] + 2*BORDER)
	local height = tb_cfg["tsize"]+ceil(heldH/B_ROW)*(tb_cfg["bsize"]+tb_cfg["bgap"])-tb_cfg["bgap"]+tb_cfg["rgap"]+2*BORDER
	
	if tb_cfg["flip"] == 1 then
		tHeight = height
		height = width
		width = tHeight
	end
	ToyBar:SetWidth(width)
	ToyBar:SetHeight(height)
end

local function tb_arrange(noAnchor)
	local T_SIZE = tb_cfg["tsize"]
	local B_SIZE = tb_cfg["bsize"]
	local R_GAP = tb_cfg["rgap"]
	local T_GAP = tb_cfg["tgap"]
	local B_GAP = tb_cfg["bgap"]
	local B_ROW = tb_getWrap()
	

	local V = tb_cfg["flip"]
	local H = 1 - V
	local vDir = tb_cfg["vert"]
	local hDir = tb_cfg["horiz"]
	
	local rel = tb_getCorner()
	
	if not noAnchor then tb_newAnchor(ToyBar_E1) end
	
	ToyBar_E1:ClearAllPoints()
	ToyBar_E1:SetPoint(rel, "ToyBar",rel,hDir*BORDER,vDir*BORDER)
	ToyBar_E1:SetWidth(T_SIZE)
	ToyBar_E1:SetHeight(T_SIZE)

	
	for i = 2, NUM_EQUIPPED do
		local button = getglobal("ToyBar_E"..i)
		button:ClearAllPoints()
		button:SetPoint(rel,"ToyBar_E"..(i-1),rel,hDir*H*(T_SIZE+T_GAP),vDir*V*(T_SIZE+T_GAP))
		button:SetWidth(T_SIZE)
		button:SetHeight(T_SIZE)
	end
	ToyBar_H1:ClearAllPoints()
	ToyBar_H1:SetPoint(rel,"ToyBar_E1",rel,hDir*V*(R_GAP+T_SIZE),vDir*H*(R_GAP+T_SIZE))
	ToyBar_H1:SetWidth(B_SIZE)
	ToyBar_H1:SetHeight(B_SIZE)
	
	for i = 2, NUM_HELD do
		local button = getglobal("ToyBar_H"..i)
		button:ClearAllPoints()
		if (mod(i-1,B_ROW) == 0) then
			button:SetPoint(rel,"ToyBar_H"..i-B_ROW,rel,hDir*V*(B_SIZE+B_GAP),vDir*H*(B_SIZE+B_GAP))
		else
			button:SetPoint(rel,"ToyBar_H"..(i-1),rel,hDir*H*(B_SIZE+B_GAP),vDir*V*(B_SIZE+B_GAP))
		end
		button:SetWidth(B_SIZE)
		button:SetHeight(B_SIZE)
	end
	
	tb_sizeBackdrop()
end

local function tb_assignItems()
	
	for i = 1, NUM_EQUIPPED do
		local name = "ToyBar_E"..i
		local button = getglobal(name)
		if ToyBar_EData[i] then
			item = ToyBar_EData[i]
			getglobal(name.."Icon"):SetTexture(item["texture"])
			getglobal(name.."Text"):SetText()
			ToyBar_Button_Update(button)
			if not button:IsVisible() then button:Show() end
		else
			button:Hide()
		end
	end
	
	for i = 1, NUM_HELD do
		local name = "ToyBar_H"..i
		local button = getglobal(name)
		if ToyBar_HData[i] then
			item = ToyBar_HData[i]
			getglobal(name.."Icon"):SetTexture(item["texture"])
			getglobal(name.."Text"):SetText()
			ToyBar_Button_Update(button)
			if not button:IsVisible() then button:Show() end
		else
			button:Hide()
		end
	end
end

local function tb_updateItems()
	if not tb_cfg then return end
	
	ToyBar_EData = {}
	ToyBar_HData = {}
	
	local i = 1
	for slot = 1, 18 do
		local link = GetInventoryItemLink("player", slot)
		local found = tb_searchMatch(link)
		
		if found or tb_cfg["locks"][slot] then
			ToyBar_EData[i] = {}
			ToyBar_EData[i]["texture"] = GetInventoryItemTexture("player",slot)
			if not ToyBar_EData[i]["texture"] then
				local id, texture = GetInventorySlotInfo(tb_slotNames[slot].."Slot")
				ToyBar_EData[i]["texture"] = texture
			end
			ToyBar_EData[i]["slot"] = slot
			ToyBar_EData[i]["link"] = link
			ToyBar_EData[i]["count"] = GetInventoryItemCount("player", slot)
			ToyBar_EData[i]["nw"] = not found and tb_cfg["locks"][slot]
			ToyBar_EData[i]["id"] = tb_extractID(link)
			i = i + 1
		end
	end
	
	i = 1
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local found, slot1, slot2 = tb_searchMatch(link)
			local id = tb_extractID(link)
			if found then
				local dup = nil
				for key, val in ToyBar_HData do
					if id == val["id"] then
						local texture, count = GetContainerItemInfo(bag,slot)
						ToyBar_HData[key]["count"] = ToyBar_HData[key]["count"] + count
						dup = true
					end
				end
				
				if not dup then
					ToyBar_HData[i] = {}
					ToyBar_HData[i]["texture"], ToyBar_HData[i]["count"] = GetContainerItemInfo(bag,slot)
					ToyBar_HData[i]["bag"] = bag
					ToyBar_HData[i]["slot"] = slot
					ToyBar_HData[i]["eqSlot1"] = slot1
					ToyBar_HData[i]["eqSlot2"] = slot2
					ToyBar_HData[i]["link"] = link
					ToyBar_HData[i]["id"] = id
					i = i + 1
				end
			end
		end
	end
	
	--sort alphabetically?
	--sort(ToyBar_HData, function(a,b) return tb_extractName(a["link"]) < tb_extractName(b["link"]) end )
	
	tb_assignItems();
	tb_arrange();
end

local function tb_setGap(bar, amount)
	
	if (bar == "all" or bar == "e") then
		tb_cfg["tgap"] =  amount
	end
	if (bar == "all" or bar == "h") then
		tb_cfg["bgap"] =  amount
	end
	
	if (bar == "all" or bar == "mid") then
		tb_cfg["rgap"] =  amount
	end
	
	tb_arrange()
end

local function tb_setSize(bar, amount)
	if (bar == "all" or bar == "e") then
		tb_cfg["tsize"] =  amount
	end
	if (bar == "all" or bar == "h") then
		tb_cfg["bsize"] =  amount
	end
		
	tb_arrange()
end

local function tb_setAlpha(bar, amount)
	if (bar == "all" or bar == "e") then
		tb_cfg["talpha"] =  amount
	end
	if (bar == "all" or bar == "h") then
		tb_cfg["balpha"] =  amount
	end
		
	ToyBar_E:SetAlpha(tb_cfg["talpha"]/10)
	ToyBar_H:SetAlpha(tb_cfg["balpha"]/10)
end

local function tb_setScale(amount)
	if (amount >= 3 and amount <= 25) then
		local m = tb_cfg["scale"] / amount
		local x = ToyBar_E1:GetLeft()
		local y = ToyBar_E1:GetBottom()
		local hDir = tb_cfg["horiz"]
		local vDir = tb_cfg["vert"]
		tb_cfg["scale"] =  amount
		ToyBar:SetScale(tb_cfg["scale"]/10)
		ToyBar:ClearAllPoints()
		if x and y then
			if vDir < 0 then
				y = y + tb_cfg["tsize"]
			end
			if hDir < 0 then
				x = x + tb_cfg["tsize"]
			end
		end
		
		ToyBar:SetPoint(tb_getCorner(), "UIParent","BOTTOMLEFT",m*x-hDir*BORDER,m*y-vDir*BORDER)
	end
end

function ToyBar_Flip()
	if tb_cfg["flip"] == 1 then
		tb_cfg["flip"] =  0
	else
		tb_cfg["flip"] =  1
	end
	
	tb_arrange()
end

function ToyBar_Rotate()
	local h = tb_cfg["horiz"]
	local v = tb_cfg["vert"]
	
	if h == 1 and v == 1 then
		tb_cfg["horiz"] = -1
	elseif h == -1 and v == 1 then
		tb_cfg["vert"] =  -1
	elseif h == -1 and v== -1 then
		tb_cfg["horiz"] =  1
	else
		tb_cfg["vert"] = 1
	end
	
	tb_arrange(true)
end

local function tb_bool(bool, a, b)
	if bool then
		return a
	else
		return b
	end
end

local function tb_slashHandler(msg)
	msg = strlower(msg)
	local i = 0
	local arg = {}
	for w in string.gfind(msg, "[^%s]+") do
		arg[i] = w
		i = i + 1
	end
	
	local bar = "all"
	
	if (arg[0] == "e" or arg[0] == "h" or arg[0] == "all" or (arg[0] == "mid" and arg[1] == "gap")) then
		bar = arg[0]
		tremove(arg, 0)
	end
	
	if (arg[0] == "lock") then
		ToyBar_Lock(1)
	elseif (arg[0] == "unlock") then
		ToyBar_Lock(0)
	elseif (arg[0] == "show") then
		ToyBar_Show(1)
	elseif (arg[0] == "hide") then
		ToyBar_Show(0)
	elseif (arg[0] == "help") then
		tb_out("$TToyBar General Usage:|r")
		tb_out("$HTo add items|r: Ctrl+click desired item in bags or equipment frame.")
		tb_out("$HTo remove|r: Ctrl+click item in ToyBar.")
		tb_out("$HSet default item|r: Shift+click equipped item in ToyBar.")
		tb_out("$HUse default item|r: Right click top item to swap.")
		tb_out("$HTo equip a trinket in the secondary slot|r: Right click desired bottom trinket.")
	elseif (arg[0] == "scale" ) then
		local scale = tonumber(arg[1])
		if not scale or scale < 5 or scale > 20 then
			tb_out("Invalid scale.")
		else
			tb_setScale(scale)
		end
	elseif (arg[0] == "align") then
		if arg[1] == nil then
			ToyBar_Flip()
		else
			if arg[1] == "top" or arg[2] == "top" then
				tb_cfg["vert"] =  -1
				tb_arrange(true)
			elseif arg[1] == "bottom" or arg[2] == "bottom" then
				tb_cfg["vert"] =  1
				tb_arrange(true)
			end
			
			if arg[1] == "right" or arg[2] == "right" then
				tb_cfg["horiz"] =  -1
				tb_arrange(true)
			elseif arg[1] == "left" or arg[2] == "left" then
				tb_cfg["horiz"] =  1
				tb_arrange(true)
			end
		end
		

	elseif (arg[0] == "wrap") then
		local amt = tonumber(arg[1])
		if not amt or amt < 1 and amt ~= -1 then
			tb_out("Invalid wrap size.")
		else
			if amt > NUM_HELD then
				amt = NUM_HELD
			end
			tb_cfg["brow"] = amt
			tb_arrange()
		end
	elseif (arg[0] == "trinkets") then
		if tb_cfg["locks"][13] then
			tb_cfg["locks"] = {}
			tb_out("Trinkets will now only show when watched.")
		else
			tb_cfg["locks"]  = {[13]=true, [14]=true}
			tb_out("Trinkets will now always be shown.")
		end
		tb_updateItems()
	elseif (arg[0] == "gap") then
		amount = tonumber(arg[1])
		if not amount or amount < 0 or amount > 20 then
			tb_out("Invalid gap.[0-20]")
		else
			tb_setGap(bar, amount)
		end
	elseif (arg[0] == "size") then
		amount = tonumber(arg[1])
		if not amount or amount < 25 or amount > 250 then
			tb_out("Invalid size. [25-250]")
		else
			tb_setSize(bar, amount)
		end
	elseif (arg[0] == "alpha") then
		amount = tonumber(arg[1])
		if not amount or amount < 0 or amount > 10 then
			tb_out("Invalid alpha. [0-10]")
		else
			tb_setAlpha(bar, amount)
		end
	elseif (arg[0] == "resetpos") then
		ToyBar:ClearAllPoints()
		ToyBar:SetPoint("CENTER","UIParent","CENTER",0,0)
	elseif (arg[0] == "tooltip") then
		tb_out(tb_bool(tb_cfg["tooltip"], "Tooltips turned off.", "Tooltips turned on."))
		tb_cfg["tooltip"] = not tb_cfg["tooltip"]
	elseif (arg[0] == "anchor") then
		tb_out(tb_bool(tb_cfg["anchor"], "Tooltips no longer anchored.", "Tooltips now anchored."))
		tb_cfg["anchor"] = not tb_cfg["anchor"]
	else
		tb_out("$TToyBar Slash Usage:|r")
		tb_out("$H/toybar lock |r: Locks the bar and hides the background.")
		tb_out("$H/toybar unlock |r: Unlocks bar")
		tb_out("$H/toybar hide |r: Hides bar")
		tb_out("$H/toybar show |r: Shows bar")
		tb_out("$H/toybar [all/e/h] size [25-250] |r: Sets absolute size of all, equipped, or held buttons")
		tb_out("$H/toybar [all/e/h/mid] gap [0-20] |r: Sets button gap")
		tb_out("$H/toybar [all/e/h] alpha [0-10] |r: Sets transparency")
		tb_out("$H/toybar scale [3-25] |r: Sets scale")
		tb_out("$H/toybar align |r: Flips orientation between horizontal and vertical")
		tb_out("$H/toybar align [top/bottom] and/or [left/right] |r: Orients the bar in the direction specified.")
		tb_out("$H/toybar wrap [1+] |r: Sets the number of items in the sub-bar before it wraps to a new row or column.")
		tb_out("$H/toybar trinkets |r: Toggles whether trinkets will always be shown")
		tb_out("$H/toybar tooltip |r: Toggles tooltips")
		tb_out("$H/toybar anchor |r: Toggles tooltips anchored to the button")
		tb_out("$H/toybar resetpos |r: Resets current position")
		tb_out("$H/toybar help |r: General Usage")
	end
end

local function tb_addWatch(bag, slot)
	local link
	
	if bag then
		link = GetContainerItemLink(bag, slot)
	else
		link = GetInventoryItemLink("player", slot)
	end
	
	if link then
		local itemID = tb_extractID(link)
		for id, key in tb_cfg["search"] do
			if itemID == id then
				return
			end
		end
		local eqSlot1 = nil
		local eqSlot2 = nil
		
		for i = 1, 19 do
			if CursorCanGoInSlot(i) and not eqSlot1 then
				eqSlot1 = i
			elseif CursorCanGoInSlot(i) then
				eqSlot2 = i
			end
		end
		
		tb_cfg["search"][itemID] = {eqSlot1, eqSlot2}
		tb_updateItems()
	end
end


local function tb_loadValues()
	ToyBar_E:SetAlpha(tb_cfg["talpha"]/10)
	ToyBar_H:SetAlpha(tb_cfg["balpha"]/10)
	if ToyBar:GetScale() ~= tb_cfg["scale"]/10 then ToyBar:SetScale(tb_cfg["scale"]/10) end
	tb_updateHotkeys()
end

local function tb_unitInit(found)
	ToyBar_Fetch_Frame:Hide()
	local player="default"
	local newProfile = nil
	
	if found then player=Fetch_PlayerInfo end
	if not ToyBar_Config then ToyBar_Config={} end
	
	if not ToyBar_Config[player] then
		newProfile = true
		ToyBar_Config[player] = {}
	end
	
	tb_cfg = ToyBar_Config[player]
	
	tb_default["search"] = {}
	tb_default["defaults"] = {}
	tb_default["firstLoad"] = 1
	tb_default["locks"] = {[13]=true, [14]=true}
	tb_default["locked"] = nil
	tb_default["hidden"] = nil
	tb_default["tooltip"] = true
	tb_default["anchor"] = nil
	tb_default["tsize"] = 39
	tb_default["bsize"] = 26
	tb_default["rgap"] = 0
	tb_default["tgap"] = 0
	tb_default["bgap"] = 0
	tb_default["talpha"] = 10
	tb_default["balpha"] = 10
	tb_default["scale"] = 10
	tb_default["brow"] = 6
	tb_default["flip"] = 0
	tb_default["vert"] = -1
	tb_default["horiz"] = 1
	
	tb_default.__index = function(table, key) table[key] = tb_default[key] return tb_default[key] end
	setmetatable(tb_cfg, tb_default)
	
	tb_loadValues()	
	tb_updateItems()
	tb_arrange()

	if not tb_cfg["locked"] then
		ToyBar_Backdrop:Show()
	end
	
	if not tb_cfg["hidden"] then
		ToyBar:Show()
	end
	
	tb_out("$TToybar Mod "..TB_VERSION.."$H - Settings for |cffffffff'"..player.."'$H loaded.|r")
	if newProfile then
		tb_out("$H*** NOTE: Use '/toybar lock' to hide background. Refer to '/toybar' for slash commands, and '/toybar help' for brief explanation on how to use.|r")
	end
end

local function tb_isSub(button)
	return button.sub
end

-- Alt+tab scaling fix, thanks Rowne
function ToyBar_OnUpdate(arg1)
	tb_tick=tb_tick+arg1
	if tb_tick>1 then
		local this=ToyBar_Updater
		if this:GetScale()==UIParent:GetScale() then
			this:SetScale(0.2)
			if tb_cfg and tb_cfg["scale"] then
				ToyBar:SetScale(tb_cfg["scale"]/10)
			end
		end
		tb_tick=0
	end
end

function ToyBar_Load()
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("UNIT_INVENTORY_CHANGED")
	this:RegisterEvent("BAG_UPDATE")
	this:RegisterEvent("UPDATE_BINDINGS")
	this:RegisterEvent("PLAYER_REGEN_DISABLED")
	this:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	SlashCmdList["TOYBARCOMMAND"] = tb_slashHandler
	SLASH_TOYBARCOMMAND1 = "/toybar"
	SLASH_TOYBARCOMMAND2 = "/toy"
	
	ToyBar_OldCPickup = PickupContainerItem
	PickupContainerItem = ToyBar_CPickup
	
	ToyBar_OldIPickup = PickupInventoryItem
	PickupInventoryItem = ToyBar_IPickup
end

function ToyBar_Fetch_OnUpdate()
	if not Fetch_Frame then tb_unitInit() return end
	if Fetch_Done then tb_unitInit(true) return end
end

function ToyBar_CPickup(bag, slot)
	tb_dragged = {bag, slot}
	if (ToyBar:IsVisible() and IsControlKeyDown() and not CursorHasItem()) then
		ToyBar_OldCPickup(bag, slot)
		tb_addWatch(bag, slot)
	end
	
	ToyBar_OldCPickup(bag, slot)
end

function ToyBar_IPickup(slot)
	tb_dragged = {nil, slot}
	if (ToyBar:IsVisible() and IsControlKeyDown() and not CursorHasItem()) then
		ToyBar_OldIPickup(slot)	
		tb_addWatch(nil, slot)
	end
	
	ToyBar_OldIPickup(slot)
end

function ToyBar_Dragged()
	if CursorHasItem() and tb_dragged then
		tb_addWatch(tb_dragged[1], tb_dragged[2])
		if tb_dragged[1] then
			ToyBar_OldCPickup(tb_dragged[1], tb_dragged[2])
		else
			ToyBar_OldIPickup(tb_dragged[2])
		end
		
		tb_dragged = nil
		return true
	end
	
	return nil
end

function ToyBar_OnEvent()
	if (event == "VARIABLES_LOADED" ) then
		if(myAddOnsFrame) then
			myAddOnsList.ToyBar = {
				name = "ToyBar",
				description = "Toy management aid.",
				version = TB_VERSION,
				category = MYADDONS_CATEGORY_BARS,
				frame = "ToyBar"
			};
		end
	elseif ( (event == "UNIT_INVENTORY_CHANGED" and arg1 == "player") or event == "BAG_UPDATE") then
		tb_updateItems()
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		tb_inCombat = nil
		tb_used = {}
		tb_queue = {}
	elseif ( event == "UPDATE_BINDINGS" ) then
		tb_updateHotkeys()
	elseif ( event == "PLAYER_REGEN_DISABLED" ) then
		tb_inCombat = true
	elseif ( event == "PLAYER_REGEN_ENABLED" ) then
		tb_inCombat = nil
		for i=getn(tb_queue), 1,-1 do
			ToyBar_Use(tb_queue[i][1], tb_queue[i][2], tb_queue[i][3])
		end
		tb_used = {}
		tb_queue = {}
	end
end

function ToyBar_Lock(lock)
	if lock == 1 then
		tb_cfg["locked"] = true
	elseif lock == 0 then
		tb_cfg["locked"] = nil
	else
		tb_cfg["locked"] = not tb_cfg["locked"]
	end
	
	if tb_cfg["locked"] then
		ToyBar_Backdrop:Hide()
	else
		ToyBar_Backdrop:Show()
	end
end

function ToyBar_Show(show)
	if show == 0 then
		tb_cfg["hidden"] = true
	elseif show == 1 then
		tb_cfg["hidden"] = nil
	else
		tb_cfg["hidden"] = not tb_cfg["hidden"]
	end
	
	if tb_cfg["hidden"] then
		ToyBar:Hide()
	else
		ToyBar:Show()
	end
end

function ToyBar_Button_OnLoad()
	this:RegisterEvent("UPDATE_BINDINGS")
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end

function ToyBar_Button_Update(button)
	if not button.lastUpdate then
		button.lastUpdate = 0
	end
	
	if tonumber(arg1) then
		button.lastUpdate = button.lastUpdate - arg1
		if (button.lastUpdate > 0) then
			return
		end
	end
	button.lastUpdate = 1
	
	local id = button:GetID()
	local name = button:GetName()
	local sub = tb_isSub(button)
	local data = tb_bool(sub, ToyBar_HData[id], ToyBar_EData[id])
	local start, duration, enable
	
	if not data then return end
	
	if sub then
		start, duration, enable = GetContainerItemCooldown(tb_getSlot(id, true))
	else
		start, duration, enable = GetInventoryItemCooldown(tb_getSlot(id))
	end
	
	local time = duration - floor(GetTime() - start)
	local weapon = data["eqSlot1"] and data["eqSlot1"] >= 16 and data["eqSlot1"] <= 18;
	
	if (start > 0 and duration > 2 and enable > 0) then
		if tb_inCombat and sub and not weapon then
			getglobal(name.."Icon"):SetVertexColor(0.7,0.4,0.4)
		else
			getglobal(name.."Icon"):SetVertexColor(0.5,0.5,0.5)
		end

		getglobal(name.."Text"):SetText(tb_formatTime(time))
	else
		if tb_inCombat and sub and not weapon then
			getglobal(name.."Icon"):SetVertexColor(1.0,0.5,0.5)
		else
			getglobal(name.."Icon"):SetVertexColor(1.0,1.0,1.0)
		end
		
		getglobal(name.."Text"):SetText()
	end
end

function ToyBar_Down(id)
	getglobal("ToyBar_E"..id):SetButtonState("PUSHED",1)
end

function ToyBar_Up(id)
	getglobal("ToyBar_E"..id):SetButtonState("NORMAL")
	ToyBar_Use(id)
end

function ToyBar_Use(id, sub, alt)
	if MerchantFrame:IsVisible() or CursorHasItem() then return end
	if sub then
		if ToyBar_HData[id] and ToyBar_HData[id]["bag"] and ToyBar_HData[id]["slot"] then	
			local slot = tb_bool(alt and ToyBar_HData[id]["eqSlot2"], ToyBar_HData[id]["eqSlot2"], ToyBar_HData[id]["eqSlot1"])
			
			if slot and tb_inCombat and (sub or alt) and not (slot >= 16 and slot <= 18) then -- add queue (if not weapon)
				tinsert(tb_queue, {id, sub, alt})
			elseif slot and not tb_used[slot] and not IsInventoryItemLocked(slot) then
				PickupContainerItem(tb_getSlot(id, true))
				PickupInventoryItem(slot)
				if getn(tb_queue) > 0 and not (slot >= 16 and slot <= 18) then tb_used[slot] = true end -- if more in queue waiting, lock slot as done (if not weapon)
				return
			end	
		end
	else
		local slot = ToyBar_EData[id]["slot"]
		
		if alt then
			if tb_inCombat and not (slot >= 16 and slot <= 18) then
				tinsert(tb_queue, {id, sub, alt})
			elseif not tb_used[slot] then
				tb_findDefault(slot)
				if getn(tb_queue) > 0 and not (slot >= 16 and slot <= 18) then tb_used[slot] = true end
			end
		elseif slot then
			UseInventoryItem(slot)
		end
	end
end

function ToyBar_Button_OnClick()
	local id = this:GetID()
	local sub = tb_isSub(this)
	local useAlt = arg1 == "RightButton"
	local setDefault = IsShiftKeyDown()
	local removing = IsControlKeyDown()
	
	local itemID = nil
	if sub then
		if ToyBar_HData[id] then 
			if removing then
				itemID = ToyBar_HData[id]["id"]
			else ToyBar_Use(id,true, useAlt) end
		end
	else
		if ToyBar_EData[id] then
			if setDefault then
				tb_out("Setting "..tb_slotNames[ToyBar_EData[id]["slot"]].." to default to "..ToyBar_EData[id]["link"])
				tb_cfg["defaults"][ToyBar_EData[id]["slot"]] = ToyBar_EData[id]["id"]
			elseif removing then
				itemID = ToyBar_EData[id]["id"]
			else ToyBar_Use(id, nil, useAlt) end
		end
	end
	
	if removing and itemID then	
		for i, val in tb_cfg["search"] do
			if i == itemID then
				tb_cfg["search"][i] = nil
				tb_updateItems()
			end
		end
	end
end

function ToyBar_Button_SetTooltip()
	if not tb_cfg["tooltip"] then return end
	
	id = this:GetID()
	local hasItem, hasCooldown, repairCost	
	local left = ToyBar:GetCenter() > (GetScreenWidth() / 2)

	local anchor = tb_bool(left, "ANCHOR_LEFT", "ANCHOR_RIGHT")
	
	if tb_isSub(this) then
		if ( GetCVar("UberTooltips") == "1" and not tb_cfg["anchor"] ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, this)
		else
			GameTooltip:SetOwner(this, anchor)
		end
		hasItem, hasCooldown, repairCost = GameTooltip:SetBagItem(tb_getSlot(id, true))
	else
		if ( GetCVar("UberTooltips") == "1" and not tb_cfg["anchor"] ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, this)
		else
			GameTooltip:SetOwner(this, anchor)
		end
		hasItem, hasCooldown, repairCost = GameTooltip:SetInventoryItem("player", ToyBar_EData[this:GetID()]["slot"])
	end
end