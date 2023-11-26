
--[[ TrinketMenu 2.23 ]]--

--[[ SavedVariables ]]--

TrinketMenuOptions = {
	MainDock = "BOTTOMRIGHT",	-- corner of main window docked to
	MenuDock = "BOTTOMLEFT",	-- corner menu window is docked from
	MainOrient = "HORIZONTAL",	-- direction of main window
	MenuOrient = "VERTICAL",	-- direction of menu window
	CooldownCount = "OFF",		-- whether to display numerical cooldown counters
	Locked = "OFF",				-- whether windows can be moved/scaled/rotated
	TooltipFollow = "OFF",		-- whether tooltips follow the mouse
	KeepOpen = "OFF",			-- whether menu hides after use
	ShowIcon = "ON",			-- whether to show the minimap button
	IconPos = -100,				-- angle of initial minimap icon position
	XPos = 400,					-- left edge of main window
	YPos = 400,					-- top edge of main window
	MainScale = 1,				-- scaling of main window
	MenuScale = 1,				-- scaling of menu window
	KeepDocked = "ON",			-- whether to keep menu docked at all times
	Notify = "OFF",				-- whether a message appears when a trinket is ready
	DisableToggle="OFF",		-- whether minimap button toggles trinkets
	NotifyUsedOnly="OFF",		-- whether notify happens only on trinkets used
	NotifyChatAlso="OFF",		-- whether to send notify to chat also
	Visible="ON"				-- whether to display the trinkets
}

--[[ Misc Variables ]]--

TrinketMenu_Version = 2.23
BINDING_HEADER_TRINKETMENU = "TrinketMenu"

local TrinketMenu = {}

TrinketMenu.MaxTrinkets = 30 -- add more to TrinketMenu_MenuFrame if this changes

TrinketMenu.BaggedTrinkets = {} -- indexed by number, 1-30 of trinkets in the menu
TrinketMenu.NumberOfTrinkets = 0 -- number of trinkets in the menu
TrinketMenu.Swapping = false -- true if a swap in progress

TrinketMenu.ScalingTime = 0 -- time since last scaling OnUpdate
TrinketMenu.ScalingUpdateTimer = .1 -- frequency (in seconds) of scaling OnUpdates
TrinketMenu.FrameToScale = nil -- handle to the frame (_MainFrame or _MenuFrame) being scaled
TrinketMenu.ScalingWidth = 0 -- width of the frame being scaled

TrinketMenu.DockingTime = 0 -- time since last docking OnUpdate
TrinketMenu.DockingUpdateTimer = .2 -- frequency (in seconds) of docking OnUpdates

TrinketMenu.InventoryTime = 0 -- time since last inventory/bag change
TrinketMenu.InventoryUpdateTimer = .25 -- time after last inventory/bag change before doing an update

TrinketMenu.MenuFrameTime = 0 -- time since last MenuFrame OnUpdate
TrinketMenu.MenuFrameUpdateTimer = .25 -- time before menu disappears after leaving main/menu frames

TrinketMenu.TooltipTime = 0 -- time since last tooltip OnUpdate
TrinketMenu.TooltipUpdateTimer = 1 -- frequency (in seconds) of updating tooltip
TrinketMenu.TooltipOwner = nil -- (this) when tooltip created
TrinketMenu.TooltipType = nil -- "BAG" or "INVENTORY"
TrinketMenu.TooltipBag = nil -- bag number
TrinketMenu.TooltipSlot = nil -- bag or inventory slot number

TrinketMenu.CooldownCountTime = 0 -- time since last cooldown numbers update
TrinketMenu.CooldownCountUpdateTimer = 1 -- frequency (in seconds) of updating cooldown numbers
TrinketMenu.CurrentTime = 0 -- time when a cooldown pass begins

TrinketMenu.Queue = {} -- [0] or [1] = name of trinket queued for slot 0 or 1
TrinketMenu.NotifyList = {} -- name of trinkets used to be notified when cooldown expires

-- option labels, tooltips and variables
TrinketMenu.OptInfo = {
	["TrinketMenuOptShowIcon"] = { text="Minimap Button", tooltip="Check this to show a gear button along the minimap edge to access TrinketMenu.\n\n/trinket opt : display options", info="ShowIcon" },
	["TrinketMenuOptLocked"] = { text="Lock Windows", tooltip="Check this to lock the windows to prevent moving, scaling or rotating.", info="Locked" },
	["TrinketMenuOptCooldownCount"] = { text="Cooldown Numbers", tooltip="Check this to show numerical cooldowns remaining on trinkets.", info="CooldownCount" },
	["TrinketMenuOptTooltipFollow"] = { text="Tooltips at Mouse", tooltip="Check this to show trinket tooltips at the pointer instead of the default position.", info="TooltipFollow" },
	["TrinketMenuOptKeepOpen"] = { text="Keep Menu Open", tooltip="Check this to keep the trinket menu open at all times.", info="KeepOpen" },
	["TrinketMenuOptKeepDocked"] = { text="Keep Menu Docked", tooltip="Check this to keep the trinket menu docked to the equipped trinkets.\n\nRecommended: On\n\nIf you undock and move the menu far away from equipped trinkets, you may not be able to move the mouse to the menu before it disappears.  If this happens, hold Shift to keep the menu open or check this option to redock the window.", info="KeepDocked" },
	["TrinketMenuOptNotify"] = { text="Notify When Ready", tooltip="Check this to display a message when a trinket's cooldown is expiring.", info="Notify" },
	["TrinketMenuOptDisableToggle"] = { text="Disable Toggle", tooltip="Check this to prevent clicking the minimap button from toggling the trinkets on/off.", info="DisableToggle" },
	["TrinketMenuOptNotifyUsedOnly"] = { text="Notify Used Only", tooltip="Check this to show cooldown notifications only if you actually used the trinket.  So that equip cooldowns and shared timers will not notify on expiring.", info="NotifyUsedOnly" },
	["TrinketMenuOptNotifyChatAlso"] = { text="Notify Chat Also", tooltip="Check this to send cooldown notifications to the chat window also.", info="NotifyChatAlso" }
}

--[[ Local functions ]]--

-- dock-dependant offset and directions: MainDock..MenuDock
-- x/yoff   = offset MenuFrame is positioned to MainFrame
-- x/ydir   = direction trinkets are added to menu
-- x/ystart = starting offset when building a menu, relativePoint MenuDock
local dock_stats = { ["TOPRIGHTTOPLEFT"] =		 { xoff=-4, yoff=0,  xdir=1,  ydir=-1, xstart=8,   ystart=-8 },
					 ["BOTTOMRIGHTBOTTOMLEFT"] = { xoff=-4, yoff=0,  xdir=1,  ydir=1,  xstart=8,   ystart=44 },
					 ["TOPLEFTTOPRIGHT"] =		 { xoff=4,  yoff=0,  xdir=-1, ydir=-1, xstart=-44, ystart=-8 },
					 ["BOTTOMLEFTBOTTOMRIGHT"] = { xoff=4,  yoff=0,  xdir=-1, ydir=1,  xstart=-44, ystart=44 },
					 ["TOPRIGHTBOTTOMRIGHT"] =   { xoff=0,  yoff=-4, xdir=-1, ydir=1,  xstart=-44,  ystart=44 },
					 ["BOTTOMRIGHTTOPRIGHT"] =   { xoff=0,  yoff=4,	 xdir=-1, ydir=-1, xstart=-44,  ystart=-8 },
					 ["TOPLEFTBOTTOMLEFT"] =	 { xoff=0,  yoff=-4, xdir=1,  ydir=1,  xstart=8,   ystart=44 },
					 ["BOTTOMLEFTTOPLEFT"] =	 { xoff=0,  yoff=4,  xdir=1,  ydir=-1, xstart=8,   ystart=-8 } }

-- returns offset and direction depending on current docking. ie: dock_info("xoff")
local function dock_info(arg1)

	local anchor = TrinketMenuOptions.MainDock..TrinketMenuOptions.MenuDock

	if dock_stats[anchor] and arg1 and dock_stats[anchor][arg1] then
		return dock_stats[anchor][arg1]
	else
		return 0
	end
end

-- hide the docking markers
local function clear_docking()

	local corners,i = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" }

	for i=1,4 do
		getglobal("TrinketMenu_MainDock_"..corners[i]):Hide()
		getglobal("TrinketMenu_MenuDock_"..corners[i]):Hide()
	end
end

-- returns true if the two values are close to each other
local function near(arg1,arg2)

    local isnear = false

    if (math.max(arg1,arg2)-math.min(arg1,arg2)) < 15 then
		isnear = true
    end

    return isnear
end

-- returns true if windows unlocked
local function unlocked()
	return TrinketMenuOptions.Locked=="OFF"
end

-- moves the MenuFrame to the dock position against MainFrame
local function dock_windows()

	clear_docking()

	if TrinketMenuOptions.KeepDocked=="ON" then
	
		TrinketMenu_MenuFrame:ClearAllPoints()
		if TrinketMenuOptions.Locked=="OFF" then
			TrinketMenu_MenuFrame:SetPoint(TrinketMenuOptions.MenuDock,"TrinketMenu_MainFrame",TrinketMenuOptions.MainDock,dock_info("xoff"),dock_info("yoff"))
		else
			TrinketMenu_MenuFrame:SetPoint(TrinketMenuOptions.MenuDock,"TrinketMenu_MainFrame",TrinketMenuOptions.MainDock,dock_info("xoff")*3,dock_info("yoff")*3)
		end
	end
end

-- displays windows vertically or horizontally
local function orient_windows()

	if TrinketMenuOptions.MainOrient=="HORIZONTAL" then
		TrinketMenu_MainFrame:SetWidth(90)
		TrinketMenu_MainFrame:SetHeight(52)
	else
		TrinketMenu_MainFrame:SetWidth(52)
		TrinketMenu_MainFrame:SetHeight(90)
	end

	TrinketMenu.InventoryTime = 10 -- immediate update
	TrinketMenu_InventoryFrame:Show()

end

-- cooldowns started offscreen cause lockups. hide them if they're not on the screen

-- returns true if frame is entirely within the bounds of the screen, based on parent's scale
local function onscreen(frame)

	local scale = frame:GetParent():GetScale()
	local left,right,top,bottom = (frame:GetLeft() or 0)*scale, (frame:GetRight() or 0)*scale, (frame:GetTop() or 0)*scale, (frame:GetBottom() or 0)*scale

	if left>0 and right<1024 and top<768 and bottom>0 then
		return true
	else
		return false
	end
end

-- redisplay menu cooldowns only if they're on screen
local function update_menu_cooldowns()

	-- set cooldown timers on menu trinkets
	local start, duration, enable
	for i=1,TrinketMenu.NumberOfTrinkets do
		if onscreen(getglobal("TrinketMenu_Menu"..i.."Cooldown")) then
			start,duration,enable = GetContainerItemCooldown(TrinketMenu.BaggedTrinkets[i].bag,TrinketMenu.BaggedTrinkets[i].slot)
			CooldownFrame_SetTimer(getglobal("TrinketMenu_Menu"..i.."Cooldown"), start, duration, enable)
		end
	end
end

-- update equipped trinkets cooldowns
local function update_cooldowns()

	local start, duration, enable

	if onscreen(TrinketMenu_Trinket0Cooldown) then
		start, duration, enable = GetInventoryItemCooldown("player",13)
		CooldownFrame_SetTimer(TrinketMenu_Trinket0Cooldown, start, duration, enable)
	end
	if onscreen(TrinketMenu_Trinket1Cooldown) then
		start, duration, enable = GetInventoryItemCooldown("player",14)
		CooldownFrame_SetTimer(TrinketMenu_Trinket1Cooldown, start, duration, enable)
	end

	if TrinketMenu_MenuFrame:IsVisible() and TrinketMenu.NumberOfTrinkets>0 then
		update_menu_cooldowns()
	end
end

-- call this when any action can change the 'Cooldown Numbers' or 'Notify When Ready' options
-- both share the same OnUpdate frame, but either should work independently of other.
local function cooldown_opts_changed()

	local i

	if TrinketMenuOptions.CooldownCount=="OFF" then
		TrinketMenu_Trinket0Time:Hide("")
		TrinketMenu_Trinket1Time:Hide("")
		for i=1,TrinketMenu.MaxTrinkets do
			getglobal("TrinketMenu_Menu"..i.."Time"):Hide("")
		end
	else
		TrinketMenu_Trinket0Time:Show()
		TrinketMenu_Trinket1Time:Show()
		for i=1,TrinketMenu.MaxTrinkets do
			getglobal("TrinketMenu_Menu"..i.."Time"):Show()
		end
	end
end

-- hides all cooldown models: MUST be called anytime a cooldown model can go off the screen
local function hide_cooldowns()

	local i
	TrinketMenu_Trinket0Cooldown:Hide()
	TrinketMenu_Trinket1Cooldown:Hide()
	for i=1,TrinketMenu.MaxTrinkets do
		getglobal("TrinketMenu_Menu"..i.."Cooldown"):Hide()
	end
end

-- scan inventory and build MenuFrame
local function build_menu()

	local idx,i,j,k,texture = 1

	-- go through bags and gather trinkets into .BaggedTrinkets
	for i=0,4 do
		for j=1,GetContainerNumSlots(i) do
			texture = GetContainerItemInfo(i,j)
			if texture then
				TrinketMenu_Tooltip:SetBagItem(i,j)
				for k=2,5 do
					if getglobal("TrinketMenu_TooltipTextLeft"..k):GetText()==INVTYPE_TRINKET then
						if not TrinketMenu.BaggedTrinkets[idx] then
							TrinketMenu.BaggedTrinkets[idx] = {}
						end
						TrinketMenu.BaggedTrinkets[idx].bag = i
						TrinketMenu.BaggedTrinkets[idx].slot = j
						TrinketMenu.BaggedTrinkets[idx].name = TrinketMenu_TooltipTextLeft1:GetText()
						TrinketMenu.BaggedTrinkets[idx].texture = texture
						idx = idx + 1
					end
				end
			end
		end
	end
	TrinketMenu.NumberOfTrinkets = math.min(idx-1,TrinketMenu.MaxTrinkets)

	if TrinketMenu.NumberOfTrinkets<1 then
		-- user has no bagged trinkets :(
		TrinketMenu_MenuFrame:Hide()
	else
		-- display trinkets outward from docking point
		local col,row,xpos,ypos = 0,0,dock_info("xstart"),dock_info("ystart")
		local max_cols = 1

		if TrinketMenu.NumberOfTrinkets>24 then
			max_cols = 5
		elseif TrinketMenu.NumberOfTrinkets>18 then
			max_cols = 4
		elseif TrinketMenu.NumberOfTrinkets>12 then
			max_cols = 3
		elseif TrinketMenu.NumberOfTrinkets>4 then
			max_cols = 2
		end

		for i=1,TrinketMenu.NumberOfTrinkets do
			local item = getglobal("TrinketMenu_Menu"..i)
			getglobal("TrinketMenu_Menu"..i.."Icon"):SetTexture(TrinketMenu.BaggedTrinkets[i].texture)
			item:SetPoint("TOPLEFT","TrinketMenu_MenuFrame",TrinketMenuOptions.MenuDock,xpos,ypos)

			if TrinketMenuOptions.MenuOrient=="VERTICAL" then
				xpos = xpos + dock_info("xdir")*40
				col = col + 1
				if col==max_cols then
					xpos = dock_info("xstart")
					col = 0
					ypos = ypos + dock_info("ydir")*40
					row = row + 1
				end
				item:Show()
			else
				ypos = ypos + dock_info("ydir")*40
				col = col + 1
				if col==max_cols then
					ypos = dock_info("ystart")
					col = 0
					xpos = xpos + dock_info("xdir")*40
					row = row + 1
				end
				item:Show()
			end
		end
		for i=(TrinketMenu.NumberOfTrinkets+1),TrinketMenu.MaxTrinkets do
			getglobal("TrinketMenu_Menu"..i):Hide()
		end
		if col==0 then
			row = row-1
		end

		if TrinketMenuOptions.MenuOrient=="VERTICAL" then
			TrinketMenu_MenuFrame:SetWidth(12+(max_cols*40))
			TrinketMenu_MenuFrame:SetHeight(12+((row+1)*40))
		else
			TrinketMenu_MenuFrame:SetWidth(12+((row+1)*40))
			TrinketMenu_MenuFrame:SetHeight(12+(max_cols*40))
		end

		update_menu_cooldowns()
	end

end

-- sets window lock "ON" or "OFF"
local function set_lock(arg1)

	TrinketMenuOptions.Locked = arg1

	if arg1=="ON" then
		TrinketMenu_MainFrame:SetBackdropColor(0,0,0,0)
		TrinketMenu_MainFrame:SetBackdropBorderColor(0,0,0,0)
		TrinketMenu_MainResizeButton:Hide()
		TrinketMenu_MenuFrame:SetBackdropColor(0,0,0,0)
		TrinketMenu_MenuFrame:SetBackdropBorderColor(0,0,0,0)
		TrinketMenu_MenuResizeButton:Hide()
	else
		TrinketMenu_MainFrame:SetBackdropColor(1,1,1,1)
		TrinketMenu_MainFrame:SetBackdropBorderColor(1,1,1,1)
		TrinketMenu_MainResizeButton:Show()
		TrinketMenu_MenuFrame:SetBackdropColor(1,1,1,1)
		TrinketMenu_MenuFrame:SetBackdropBorderColor(1,1,1,1)
		TrinketMenu_MenuResizeButton:Show()
	end
	dock_windows()
end

local function move_icon()
	TrinketMenu_IconFrame:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(TrinketMenuOptions.IconPos or 0)),(80*sin(TrinketMenuOptions.IconPos or 0))-52)
end

local function show_icon()
	if TrinketMenuOptions.ShowIcon=="ON" then
		TrinketMenu_IconFrame:Show()
	else
		TrinketMenu_IconFrame:Hide()
	end
end

local function check_state(arg1)

	if arg1=="ON" then
		return 1
	else
		return 0
	end
end

-- for use with main/menu frames with UIParent parent when relocated by the mod, to register for layout-cache.txt
local function really_setpoint(frame,point,relativeTo,relativePoint,xoff,yoff)
	frame:SetPoint(point,relativeTo,relativePoint,xoff,yoff)
	frame:StartMoving()
	frame:StopMovingOrSizing()
end

-- enable/disable subopt (arg2) arg1->arg2
local function subopt_enable(arg1,arg2)

	if arg1 and arg2 and TrinketMenuOptions[arg1]=="ON" then
		getglobal("TrinketMenuOpt"..arg2):Enable()
		getglobal("TrinketMenuOpt"..arg2.."Text"):SetTextColor(1,.82,0)
	elseif arg1 and arg2 then
		getglobal("TrinketMenuOpt"..arg2):Disable()
		getglobal("TrinketMenuOpt"..arg2.."Text"):SetTextColor(.6,.6,.6)
	end
end

-- returns the name of the trinket in slot 0 or 1
local function trinket_name(slot)

	local _,_,name = string.find(GetInventoryItemLink("player",tonumber(slot)+13) or "","^.*%[(.*)%].*$")
	return name
end

-- sets initial display
local function initialize_display()

	local i

	TrinketMenuOptions.KeepDocked = TrinketMenuOptions.KeepDocked or "ON" -- new option for 2.1
	TrinketMenuOptions.Notify = TrinketMenuOptions.Notify or "OFF" -- 2.1
	TrinketMenuOptions.DisableToggle = TrinketMenuOptions.DisableToggle or "OFF" -- new option for 2.2
	TrinketMenuOptions.NotifyUsedOnly = TrinketMenuOptions.NotifyUsedOnly or "OFF" -- 2.2
	TrinketMenuOptions.NotifyChatAlso = TrinketMenuOptions.NotifyChatAlso or "OFF" -- 2.2

	if TrinketMenuOptions.XPos and TrinketMenuOptions.YPos then
		really_setpoint(TrinketMenu_MainFrame,"TOPLEFT","UIParent","BOTTOMLEFT",TrinketMenuOptions.XPos,TrinketMenuOptions.YPos)
	end
	if TrinketMenuOptions.MainScale then
		TrinketMenu_MainFrame:SetScale(TrinketMenuOptions.MainScale)
	end
	if TrinketMenuOptions.MenuScale then
		TrinketMenu_MenuFrame:SetScale(TrinketMenuOptions.MenuScale)
	end

	TrinketMenu_Title:SetText("TrinketMenu "..TrinketMenu_Version)

	move_icon()
	show_icon()
	set_lock(TrinketMenuOptions.Locked)
	orient_windows()
	dock_windows()
	local _,texture = GetInventorySlotInfo("Trinket0Slot")
	TrinketMenu_Trinket0Icon:SetTexture(texture)
	_,texture = GetInventorySlotInfo("Trinket1Slot")
	TrinketMenu_Trinket1Icon:SetTexture(texture)

	-- initialize options
	for i in TrinketMenu.OptInfo do
		getglobal(i.."Text"):SetText(TrinketMenu.OptInfo[i].text)
		getglobal(i):SetChecked(check_state(TrinketMenuOptions[TrinketMenu.OptInfo[i].info]))
	end

	if TrinketMenuOptions.KeepOpen=="ON" then
		TrinketMenu_MenuFrame:Show()
	end

	if TrinketMenuOptions.Visible=="OFF" then
		TrinketMenu_MainFrame:Hide()
		TrinketMenu_MenuFrame:Hide()
	end

	cooldown_opts_changed()
	subopt_enable("ShowIcon","DisableToggle")
	subopt_enable("Notify","NotifyUsedOnly")
	subopt_enable("Notify","NotifyChatAlso")

end

local function cursor_empty()
	return not (CursorHasItem() or CursorHasMoney() or CursorHasSpell())
end

-- swap trinket named 'name' into trinket slot 'which' (0 or 1)
local function swap_by_name(which,name)

	local i

	if TrinketMenu.Queue[which] and cursor_empty() then
		for i=1,TrinketMenu.NumberOfTrinkets do
			if TrinketMenu.BaggedTrinkets[i].name==TrinketMenu.Queue[which] then
				PickupInventoryItem(which+13)
				PickupContainerItem(TrinketMenu.BaggedTrinkets[i].bag,TrinketMenu.BaggedTrinkets[i].slot)
				getglobal("TrinketMenu_Trinket"..which.."Icon"):SetVertexColor(0.4,0.4,0.4)
				TrinketMenu.Swapping = true
			end
		end
	end
end

-- moves options window above or below minimap depending on minimap location
local function move_optframe()

	if Minimap:GetBottom() and Minimap:GetBottom()<200 then
		TrinketMenu_OptFrame:ClearAllPoints()
		TrinketMenu_OptFrame:SetPoint("BOTTOMLEFT","Minimap","TOPLEFT",0,32)
	else
		TrinketMenu_OptFrame:ClearAllPoints()
		TrinketMenu_OptFrame:SetPoint("TOPLEFT","Minimap","BOTTOMLEFT",0,-32)
	end
end

-- returns true if the player is really dead or ghost, not merely FD
local function player_really_dead()
	local dead,i = UnitIsDeadOrGhost("player")

	for i=1,16 do
		if UnitBuff("player",i)=="Interface\\Icons\\Ability_Rogue_FeignDeath" then
			dead = nil -- player is just FD, not really dead
		end
	end

	return dead
end

--[[ Frame Scripts ]]--

function TrinketMenu_OnLoad()

	SlashCmdList["TrinketMenuCOMMAND"] = TrinketMenu_SlashHandler
	SLASH_TrinketMenuCOMMAND1 = "/trinketmenu";
	SLASH_TrinketMenuCOMMAND2 = "/trinket";
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function TrinketMenu_OnEvent(event)

	if event=="UNIT_INVENTORY_CHANGED" or event=="BAG_UPDATE" then
		TrinketMenu.InventoryTime = 0 -- reset time of last update
		TrinketMenu_InventoryFrame:Show()

	elseif (event=="PLAYER_REGEN_ENABLED" or event=="PLAYER_UNGHOST" or event=="PLAYER_ALIVE") and not player_really_dead() then
		-- trinkets can now be swapped after combat/death
		if TrinketMenu.Queue[0] or TrinketMenu.Queue[1] then
			build_menu()
			swap_by_name(0,TrinketMenu.Queue[0])
			swap_by_name(1,TrinketMenu.Queue[1])
			TrinketMenu.Queue[0] = nil
			TrinketMenu.Queue[1] = nil
			TrinketMenu_Trinket0Queue:Hide()
			TrinketMenu_Trinket1Queue:Hide()
		end

	elseif event=="CVAR_UPDATE" then
		if (arg1=="USE_UISCALE" or arg1=="WINDOWED_MODE") and TrinketMenuOptions.XPos then
			TrinketMenu_MainFrame:SetScale(TrinketMenuOptions.MainScale)
			TrinketMenu_MenuFrame:SetScale(TrinketMenuOptions.MenuScale)
			really_setpoint(TrinketMenu_MainFrame,"TOPLEFT","UIParent","BOTTOMLEFT",TrinketMenuOptions.XPos,TrinketMenuOptions.YPos)
		end

	elseif event=="PLAYER_ENTERING_WORLD" then
		this:UnregisterEvent("PLAYER_ENTERING_WORLD")
		table.insert(UISpecialFrames,"TrinketMenu_OptFrame") -- make options window ESCable

		initialize_display()

		this:RegisterEvent("UNIT_INVENTORY_CHANGED")
		this:RegisterEvent("BAG_UPDATE")
		this:RegisterEvent("PLAYER_REGEN_ENABLED")
		this:RegisterEvent("PLAYER_UNGHOST")
		this:RegisterEvent("PLAYER_ALIVE")
		this:RegisterEvent("CVAR_UPDATE")
	end
end

function TrinketMenu_SlashHandler(arg1)

	if not string.find(arg1,".+") then
		TrinketMenu_Toggle()
	elseif string.lower(arg1)=="reset" then
		TrinketMenu_Opt_Reset()
	elseif string.find(string.lower(arg1),"^opt") or string.find(string.lower(arg1),"^config") then
		move_optframe()
		TrinketMenu_OptFrame:Show()
	elseif string.lower(arg1)=="lock" then
		set_lock("ON")
	elseif string.lower(arg1)=="unlock" then
		set_lock("OFF")
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00TrinketMenu useage:")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket or /trinketmenu : toggle the window")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket reset : reset window")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket opt : summon options window")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket lock or unlock : toggles window lock")
	end

end

--[[ Window Movement ]]--

function TrinketMenu_MainFrame_OnMouseUp(arg1)
	if arg1=="LeftButton" then
		update_cooldowns()
		this:StopMovingOrSizing()
		TrinketMenuOptions.XPos = TrinketMenu_MainFrame:GetLeft()
		TrinketMenuOptions.YPos = TrinketMenu_MainFrame:GetTop()
	elseif unlocked() then
		hide_cooldowns()
		if TrinketMenuOptions.MainOrient=="VERTICAL" then
			TrinketMenuOptions.MainOrient = "HORIZONTAL"
		else
			TrinketMenuOptions.MainOrient = "VERTICAL"
		end
		orient_windows()
	end

end

function TrinketMenu_MainFrame_OnMouseDown(arg1)
	if arg1=="LeftButton" and unlocked() then
		hide_cooldowns()
		this:StartMoving()
	end
end

--[[ MainFrame and MenuFrame Scaling ]]--

function TrinketMenu_StartScaling(arg1)
	if arg1=="LeftButton" and unlocked() then
		this:LockHighlight()
		TrinketMenu.FrameToScale = this:GetParent()
		TrinketMenu.ScalingWidth = this:GetParent():GetWidth()
		hide_cooldowns()
		TrinketMenu_ScalingFrame:Show()
	end
end

function TrinketMenu_StopScaling(arg1)
	if arg1=="LeftButton" then
		TrinketMenu_ScalingFrame:Hide()
		TrinketMenu.FrameToScale = nil
		this:UnlockHighlight()
		if this:GetParent():GetName() == "TrinketMenu_MainFrame" then
			TrinketMenuOptions.MainScale = TrinketMenu_MainFrame:GetScale()
		else
			TrinketMenuOptions.MenuScale = TrinketMenu_MenuFrame:GetScale()
		end
		update_cooldowns()
	end
end

function TrinketMenu_ScaleFrame(scale)
	local frame = TrinketMenu.FrameToScale
	local oldscale = frame:GetScale() or 1
	local framex = (frame:GetLeft() or TrinketMenuOptions.XPos)* oldscale
	local framey = (frame:GetTop() or TrinketMenuOptions.YPos)* oldscale

	frame:SetScale(scale)
	if frame:GetName() == "TrinketMenu_MainFrame" then
		really_setpoint(TrinketMenu_MainFrame,"TOPLEFT","UIParent","BOTTOMLEFT",framex/scale,framey/scale)
		TrinketMenuOptions.XPos = TrinketMenu_MainFrame:GetLeft()
		TrinketMenuOptions.YPos = TrinketMenu_MainFrame:GetTop()
	elseif TrinketMenuOptions.KeepDocked=="OFF" then
		TrinketMenu_MenuFrame:ClearAllPoints()
		really_setpoint(TrinketMenu_MenuFrame,"TOPLEFT","UIParent","BOTTOMLEFT",framex/scale,framey/scale)
	end
end

function TrinketMenu_ScalingFrame_OnUpdate(arg1)

	TrinketMenu.ScalingTime = TrinketMenu.ScalingTime + arg1
	if TrinketMenu.ScalingTime > TrinketMenu.ScalingUpdateTimer then
		TrinketMenu.ScalingTime = 0

		local frame = TrinketMenu.FrameToScale
		local oldscale = frame:GetScale()
		local framex, framey, cursorx, cursory = frame:GetLeft()*oldscale, frame:GetTop()*oldscale, GetCursorPosition()

		if (cursorx-framex)>32 then
			local newscale = (cursorx-framex)/TrinketMenu.ScalingWidth
			TrinketMenu_ScaleFrame(newscale)
		end

	end
end

--[[ Menu docking ]]--

function TrinketMenu_MenuFrame_OnMouseUp(arg1)
	if arg1=="LeftButton" then
		update_cooldowns()
		TrinketMenu_DockingFrame:Hide()
		TrinketMenu_MenuFrame:StopMovingOrSizing()
		if TrinketMenuOptions.KeepDocked=="ON" then
			dock_windows()
		end
		TrinketMenu.InventoryTime = 1 -- reset time of last update
		TrinketMenu_InventoryFrame:Show()
	elseif unlocked() then
		hide_cooldowns()
		if TrinketMenuOptions.MenuOrient=="VERTICAL" then
			TrinketMenuOptions.MenuOrient="HORIZONTAL"
		else
			TrinketMenuOptions.MenuOrient="VERTICAL"
		end
		orient_windows()
	end
end

function TrinketMenu_MenuFrame_OnMouseDown(arg1)
	if arg1=="LeftButton" and unlocked() then
		hide_cooldowns()
		TrinketMenu_MenuFrame:StartMoving()

		if TrinketMenuOptions.KeepDocked=="ON" then
			TrinketMenu_DockingFrame:Show()
		end
	end
end

function TrinketMenu_DockingFrame_OnUpdate(arg1)

	TrinketMenu.DockingTime = TrinketMenu.DockingTime + arg1
	if TrinketMenu.DockingTime > TrinketMenu.DockingUpdateTimer then
		TrinketMenu.DockingTime = 0

		local main = TrinketMenu_MainFrame
		local menu = TrinketMenu_MenuFrame
		local mainscale = TrinketMenu_MainFrame:GetScale()
		local menuscale = TrinketMenu_MenuFrame:GetScale()

		if near(main:GetRight()*mainscale,menu:GetLeft()*menuscale) then
			if near(main:GetTop()*mainscale,menu:GetTop()*menuscale) then
				TrinketMenuOptions.MainDock = "TOPRIGHT"
				TrinketMenuOptions.MenuDock = "TOPLEFT"
			elseif near(main:GetBottom()*mainscale,menu:GetBottom()*menuscale) then
				TrinketMenuOptions.MainDock = "BOTTOMRIGHT"
				TrinketMenuOptions.MenuDock = "BOTTOMLEFT"
			end
		elseif near(main:GetLeft()*mainscale,menu:GetRight()*menuscale) then
			if near(main:GetTop()*mainscale,menu:GetTop()*menuscale) then
				TrinketMenuOptions.MainDock = "TOPLEFT"
				TrinketMenuOptions.MenuDock = "TOPRIGHT"
			elseif near(main:GetBottom()*mainscale,menu:GetBottom()*menuscale) then
				TrinketMenuOptions.MainDock = "BOTTOMLEFT"
				TrinketMenuOptions.MenuDock = "BOTTOMRIGHT"
			end
		elseif near(main:GetRight()*mainscale,menu:GetRight()*menuscale) then
			if near(main:GetTop()*mainscale,menu:GetBottom()*menuscale) then
				TrinketMenuOptions.MainDock = "TOPRIGHT"
				TrinketMenuOptions.MenuDock = "BOTTOMRIGHT"
			elseif near(main:GetBottom()*mainscale,menu:GetTop()*menuscale) then
				TrinketMenuOptions.MainDock = "BOTTOMRIGHT"
				TrinketMenuOptions.MenuDock = "TOPRIGHT"
			end
		elseif near(main:GetLeft()*mainscale,menu:GetLeft()*menuscale) then
			if near(main:GetTop()*mainscale,menu:GetBottom()*menuscale) then
				TrinketMenuOptions.MainDock = "TOPLEFT"
				TrinketMenuOptions.MenuDock = "BOTTOMLEFT"
			elseif near(main:GetBottom()*mainscale,menu:GetTop()*menuscale) then
				TrinketMenuOptions.MainDock = "BOTTOMLEFT"
				TrinketMenuOptions.MenuDock = "TOPLEFT"
			end
		end

		clear_docking()
		getglobal("TrinketMenu_MainDock_"..TrinketMenuOptions.MainDock):Show()
		getglobal("TrinketMenu_MenuDock_"..TrinketMenuOptions.MenuDock):Show()

	end
end

--[[ Inventory ]]--

-- after a period of no inventory/bag updates since one happens, update
function TrinketMenu_InventoryFrame_OnUpdate(arg1)

	TrinketMenu.InventoryTime = TrinketMenu.InventoryTime + arg1
	if TrinketMenu.InventoryTime>TrinketMenu.InventoryUpdateTimer then
		TrinketMenu_InventoryFrame:Hide()
		TrinketMenu.InventoryTime = 0

		local t0texture, t1texture = GetInventoryItemTexture("player",13), GetInventoryItemTexture("player",14)

		TrinketMenu.Swapping = false

		TrinketMenu_Trinket0Icon:SetTexture(t0texture or "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket")
		TrinketMenu_Trinket1Icon:SetTexture(t1texture or "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket")
		TrinketMenu_Trinket0:SetChecked(0)
		TrinketMenu_Trinket1:SetChecked(0)
		TrinketMenu_Trinket0Icon:SetVertexColor(1,1,1,1)
		TrinketMenu_Trinket1Icon:SetVertexColor(1,1,1,1)
		TrinketMenu.CooldownCountTime = TrinketMenu.CooldownCountUpdateTimer -- immediate update of cooldown counters
		update_cooldowns()

		if not t0texture and not t1texture and TrinketMenu.NumberOfTrinkets<1 then
			-- user has no trinkets at all. :( poor guy.  hide window
			TrinketMenuOptions.Visible = "OFF"
			TrinketMenu_MainFrame:Hide()
		end

		build_menu()

	end
end

--[[ Menu popup ]]--

function TrinketMenu_ResetMenuTimer()
	TrinketMenu.MenuFrameTime = 0
end

function TrinketMenu_MenuFrame_OnUpdate(arg1)

	TrinketMenu.MenuFrameTime = TrinketMenu.MenuFrameTime + arg1
	if TrinketMenu.MenuFrameTime>TrinketMenu.MenuFrameUpdateTimer then
		TrinketMenu.MenuFrameTime = 0
		if (not MouseIsOver(TrinketMenu_MainFrame)) and (not MouseIsOver(TrinketMenu_MenuFrame)) and (not TrinketMenu_ScalingFrame:IsVisible()) and not IsShiftKeyDown() and (TrinketMenuOptions.KeepOpen=="OFF") then
			TrinketMenu_MenuFrame:Hide()
		end
	end

end

function TrinketMenu_ShowMenu()

	build_menu()
	if TrinketMenu.NumberOfTrinkets>0 then
		TrinketMenu.MenuFrameTime = 0
		TrinketMenu_MenuFrame:Show()
	end
end

function TrinketMenu_Toggle()

	if TrinketMenu_MainFrame:IsVisible() then
		TrinketMenuOptions.Visible = "OFF"
		TrinketMenu_MainFrame:Hide()
		TrinketMenu_MenuFrame:Hide()
		TrinketMenu_OptFrame:Hide()
	else
		TrinketMenuOptions.Visible = "ON"
		TrinketMenu_MainFrame:Show()
		if TrinketMenuOptions.KeepOpen=="ON" then
			TrinketMenu_MenuFrame:Show()
		end
	end
end

--[[ Trinket clicks ]]--

-- can be used in key binding also, arg1==13 or 14
function TrinketMenu_UseTrinket(arg1)

	if arg1==13 or arg1==14 then

		if not MerchantFrame:IsVisible() then
			UseInventoryItem(arg1)
			getglobal("TrinketMenu_Trinket"..(arg1-13)):SetChecked(1)

			local name = trinket_name(arg1-13)
			if name then
				TrinketMenu.NotifyList[name] = 1 -- add this trinket's name to notify list
			end

		end
		update_cooldowns()

		TrinketMenu.InventoryTime = -1.25
		TrinketMenu_InventoryFrame:Show()
	end
end

-- called from Trinket0/1's OnClick
function TrinketMenu_Trinket_OnClick(arg1)

	local id = this:GetID()
	this:SetChecked(0)

	if arg1=="LeftButton" and IsShiftKeyDown() and ChatFrameEditBox:IsVisible() then
		-- link to chat instead of use
		ChatFrameEditBox:Insert(GetInventoryItemLink("player",id))
	else
		TrinketMenu_UseTrinket(id)
	end
end

-- called from Menu1-30's OnClick
function TrinketMenu_SwapTrinket(arg1)

	local id = this:GetID()
	this:SetChecked(0)

	if UnitAffectingCombat("player") or player_really_dead() then
		-- if in combat, put the chosen trinket(id) into queue

		local which = arg1=="LeftButton" and 0 or 1 -- which==which trinket, 0(left) or 1(right)

		if TrinketMenu.Queue[which]==TrinketMenu.BaggedTrinkets[id].name then
			-- if already queued for this slot, remove from queue
			TrinketMenu.Queue[which] = nil
			getglobal("TrinketMenu_Trinket"..which.."Queue"):Hide()
		else
			if TrinketMenu.Queue[1-which]==TrinketMenu.BaggedTrinkets[id].name then
				-- if this was queued for other slot, move to this one
				TrinketMenu.Queue[1-which] = nil
				getglobal("TrinketMenu_Trinket"..(1-which).."Queue"):Hide()
			end

			getglobal("TrinketMenu_Trinket"..which.."Queue"):SetTexture(TrinketMenu.BaggedTrinkets[id].texture)
			TrinketMenu.Queue[which] = TrinketMenu.BaggedTrinkets[id].name
			getglobal("TrinketMenu_Trinket"..which.."Queue"):Show()
		end

	elseif not TrinketMenu.Swapping then

		if arg1=="LeftButton" and IsShiftKeyDown() and ChatFrameEditBox:IsVisible() then
			-- link to chat instead of swap
			ChatFrameEditBox:Insert(GetContainerItemLink(TrinketMenu.BaggedTrinkets[id].bag,TrinketMenu.BaggedTrinkets[id].slot))
		elseif cursor_empty() then
			PickupContainerItem(TrinketMenu.BaggedTrinkets[id].bag,TrinketMenu.BaggedTrinkets[id].slot)
			if arg1=="LeftButton" then
				PickupInventoryItem(13)
				TrinketMenu_Trinket0Icon:SetVertexColor(0.4, 0.4, 0.4)
			else
				PickupInventoryItem(14)
				TrinketMenu_Trinket1Icon:SetVertexColor(0.4, 0.4, 0.4)
			end
			TrinketMenu.Swapping = true
		end
	end

	if not IsShiftKeyDown() and TrinketMenuOptions.KeepOpen=="OFF" then
		TrinketMenu_MenuFrame:Hide()
	end
end

--[[ Tooltips ]]--

function TrinketMenu_InventoryTooltip()

	local id = this:GetID()

	if TrinketMenu_ScalingFrame:IsVisible() then
		return
	end

	TrinketMenu.TooltipOwner = this
	TrinketMenu.TooltipType = "INVENTORY"
	TrinketMenu.TooltipSlot = id

	TrinketMenu.TooltipBag = TrinketMenu.Queue[id-13]

	TrinketMenu.TooltipTime = 10 -- immediate update
	TrinketMenu_TooltipFrame:Show()
end

function TrinketMenu_BagTooltip()

	local id = this:GetID()

	if TrinketMenu_ScalingFrame:IsVisible() then
		return
	end

	TrinketMenu.TooltipOwner = this
	TrinketMenu.TooltipType = "BAG"
	TrinketMenu.TooltipBag = TrinketMenu.BaggedTrinkets[id].bag
	TrinketMenu.TooltipSlot = TrinketMenu.BaggedTrinkets[id].slot

	TrinketMenu.TooltipTime = 10 -- immediate update
	TrinketMenu_TooltipFrame:Show()
end

function TrinketMenu_ClearTooltip()

	GameTooltip:Hide()
	TrinketMenu.TooltipType = nil
	TrinketMenu_TooltipFrame:Hide()
end

-- updates the tooltip created in the functions above
function TrinketMenu_TooltipFrame_OnUpdate(arg1)

	TrinketMenu.TooltipTime = TrinketMenu.TooltipTime + arg1
	if TrinketMenu.TooltipTime > TrinketMenu.TooltipUpdateTimer then
		TrinketMenu.TooltipTime = 0

		if TrinketMenu.TooltipType then

			local cooldown

			if TrinketMenuOptions.TooltipFollow=="ON" then
				if TrinketMenu.TooltipOwner:GetLeft()<400 then
					GameTooltip:SetOwner(TrinketMenu.TooltipOwner,"ANCHOR_RIGHT")
				else
					GameTooltip:SetOwner(TrinketMenu.TooltipOwner,"ANCHOR_LEFT")
				end
			else
				GameTooltip_SetDefaultAnchor(GameTooltip,TrinketMenu.TooltipOwner)
			end
			if TrinketMenu.TooltipType=="BAG" then
				GameTooltip:SetBagItem(TrinketMenu.TooltipBag,TrinketMenu.TooltipSlot)
				cooldown = GetContainerItemCooldown(TrinketMenu.TooltipBag,TrinketMenu.TooltipSlot)
			else
				GameTooltip:SetInventoryItem("player",TrinketMenu.TooltipSlot)
				cooldown = GetInventoryItemCooldown("player",TrinketMenu.TooltipSlot)
				if TrinketMenu.TooltipBag then
					GameTooltip:AddLine("Queued: "..TrinketMenu.TooltipBag)
				end
			end
			GameTooltip:Show()
			if cooldown==0 then
				-- stop updates if this trinket has no cooldown
				TrinketMenu.TooltipType = nil
				TrinketMenu_TooltipFrame:Hide()
			end
		end

	end

end

-- normal tooltip for options
function TrinketMenu_OnTooltip(arg1,arg2)

	GameTooltip_SetDefaultAnchor(GameTooltip,this)
	GameTooltip:AddLine(arg1)
	GameTooltip:AddLine(arg2,.8,.8,.8,1)
	GameTooltip:Show()
end

--[[ Minimap Icon ]]--

function TrinketMenu_IconDraggingFrame_OnUpdate(arg1)
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70

	TrinketMenuOptions.IconPos = math.deg(math.atan2(ypos,xpos))
	move_icon()
end

function TrinketMenu_IconFrame_OnClick(arg1)

	if arg1=="LeftButton" and TrinketMenuOptions.DisableToggle=="OFF" then
		TrinketMenu_Toggle()
	else
		if TrinketMenu_OptFrame:IsVisible() then
			TrinketMenu_OptFrame:Hide()
		else
			move_optframe()
			TrinketMenu_OptFrame:Show()
		end
	end
end

--[[ Options ]]--

function TrinketMenu_Opt_OnEnter()

	local id = this:GetName()

	if TrinketMenu.OptInfo[id] then
		TrinketMenu_OnTooltip(TrinketMenu.OptInfo[id].text,TrinketMenu.OptInfo[id].tooltip)
	end
end

function TrinketMenu_Opt_OnClick()

	local id_name = this:GetName()
	local id_var = TrinketMenu.OptInfo[id_name].info

	if this:GetChecked()==1 then
		TrinketMenuOptions[id_var] = "ON"
	else
		TrinketMenuOptions[id_var] = "OFF"
	end

	if id_var=="Locked" then
		set_lock(TrinketMenuOptions.Locked)
	elseif id_var=="KeepOpen" then
		TrinketMenu_MenuFrame:Show()
	elseif id_var=="ShowIcon" then
		show_icon()
	elseif id_var=="CooldownCount" then
		TrinketMenu.CooldownCountTime = TrinketMenu.CooldownCountUpdateTimer -- immediate update
		cooldown_opts_changed()
	elseif id_var=="KeepDocked" then
		if TrinketMenuOptions.KeepDocked=="ON" then
			dock_windows()
		else
			TrinketMenu.FrameToScale = TrinketMenu_MenuFrame
			TrinketMenu_ScaleFrame(TrinketMenu_MenuFrame:GetScale())
		end

		TrinketMenu.FrameToScale = this:GetParent()
		TrinketMenu.ScalingWidth = this:GetParent():GetWidth()
	elseif id_var=="Notify" then
		cooldown_opts_changed()
	end

	subopt_enable("ShowIcon","DisableToggle")
	subopt_enable("Notify","NotifyUsedOnly")
	subopt_enable("Notify","NotifyChatAlso")
end

function TrinketMenu_Opt_Reset()

	TrinketMenuOptions = {
		MainDock="BOTTOMRIGHT", MenuDock="BOTTOMLEFT", MainOrient="HORIZONTAL", MenuOrient="VERTICAL",
		CooldownCount="OFF", Locked="OFF", TooltipFollow="OFF", KeepOpen="OFF", ShowIcon="ON",
		IconPos=-100, XPos=400, YPos=400, MainScale=1.0, MenuScale=1.0,
		KeepDocked="ON", Notify="OFF", -- 2.1
		DisableToggle="OFF", NotifyUsedOnly="OFF", NotifyChatAlso="OFF" -- 2.2
	}
	initialize_display()

end

--[[ Cooldown Counters ]]--


local function format_time(seconds)

	if seconds<60 then
		return math.floor(seconds+.5).." s"
	else
		if seconds < 3600 then 
			return math.ceil((seconds/60)).." m"
		else
			return math.ceil((seconds/3600)).." h"
		end
	end

end

-- sends a message "(trinket) ready!"
local function notify(trinket)

	if trinket and ((TrinketMenu.NotifyList[trinket] and TrinketMenuOptions.NotifyUsedOnly=="ON") or TrinketMenuOptions.NotifyUsedOnly=="OFF") then
		if SCT_CmdDisplay then
			-- send via SCT if it exists
			SCT_CmdDisplay("'"..string.gsub(trinket,"'","").." ready!' 2 7 9")
		else
			-- send vis UIErrorsFrame if SCT doesn't exit
			UIErrorsFrame:AddMessage(trinket.." ready!",.2,.7,.9,1,UIERRORS_HOLD_TIME)
		end

		if TrinketMenuOptions.NotifyChatAlso=="ON" then
			DEFAULT_CHAT_FRAME:AddMessage("|cff33b2e5"..trinket.." ready!")
		end
		TrinketMenu.NotifyList[trinket] = nil
	end
end

local function write_cooldown(where,start,duration)

	local cooldown = duration - (TrinketMenu.CurrentTime - start)

	if start==0 then
		where:SetText("")
	elseif cooldown<3 and not where:GetText() then
		-- this is a global cooldown. don't display it. not accurate but at least not annoying
	else
		where:SetText(format_time(cooldown))

		-- placed here because we don't want to be notified on global cooldowns
		if TrinketMenuOptions.Notify=="ON" and cooldown<1 then
			local _,_,id = string.find(where:GetName(),"TrinketMenu_Menu(%d+)Time")
			if id then
				notify(TrinketMenu.BaggedTrinkets[tonumber(id)].name)
			else
				if where==TrinketMenu_Trinket0Time then
					id = trinket_name(0)
					if id then
						notify(id)
					end
				else
					id = trinket_name(1)
					if id then
						notify(id)
					end
				end
			end
		end
	end
end

function TrinketMenu_CooldownCountFrame_OnUpdate(arg1)

	TrinketMenu.CooldownCountTime = TrinketMenu.CooldownCountTime + arg1
	if TrinketMenu.CooldownCountTime > TrinketMenu.CooldownCountUpdateTimer then
		-- update cooldowns
		TrinketMenu.CooldownCountTime = 0

		-- fix for scaling bug on alt-tab: see Rowne's Switchfix at http://www.curse-gaming.com/mod.php?addid=1052
		if UIParent:GetScale()==TrinketMenu_ScaleBugFix:GetScale() and TrinketMenuOptions.MainScale then
			TrinketMenu_ScaleBugFix:SetScale(0.2)
			TrinketMenu_MainFrame:SetScale(TrinketMenuOptions.MainScale)
			TrinketMenu_MenuFrame:SetScale(TrinketMenuOptions.MenuScale)
		end
		
		if TrinketMenuOptions.CooldownCount=="ON" or TrinketMenuOptions.Notify=="ON" then

			local i,start,duration
			TrinketMenu.CurrentTime = GetTime()

			if TrinketMenu_MainFrame:IsVisible() then
				start, duration = GetInventoryItemCooldown("player",13)
				write_cooldown(TrinketMenu_Trinket0Time,start,duration)
				start, duration = GetInventoryItemCooldown("player",14)
				write_cooldown(TrinketMenu_Trinket1Time,start,duration)
			end

			if TrinketMenu_MenuFrame:IsVisible() or TrinketMenuOptions.Notify=="ON" then
				for i=1,TrinketMenu.NumberOfTrinkets do
					start, duration = GetContainerItemCooldown(TrinketMenu.BaggedTrinkets[i].bag,TrinketMenu.BaggedTrinkets[i].slot)
					write_cooldown(getglobal("TrinketMenu_Menu"..i.."Time"),start,duration)
				end
			end
		end

	end

end

function TrinketMenu_CooldownCountFrame_OnHide()

	local i

	TrinketMenu_Trinket0Time:SetText("")
	TrinketMenu_Trinket1Time:SetText("")

	for i=1,TrinketMenu.MaxTrinkets do
		getglobal("TrinketMenu_Menu"..i.."Time"):SetText("")
	end
end

