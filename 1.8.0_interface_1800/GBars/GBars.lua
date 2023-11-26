-- bindings
BINDING_HEADER_GBARS = "GBars"
BINDING_NAME_GACTIONBUTTON13 = "GBar Button 13"
BINDING_NAME_GACTIONBUTTON14 = "GBar Button 14"
BINDING_NAME_GACTIONBUTTON15 = "GBar Button 15"
BINDING_NAME_GACTIONBUTTON16 = "GBar Button 16"
BINDING_NAME_GACTIONBUTTON17 = "GBar Button 17"
BINDING_NAME_GACTIONBUTTON18 = "GBar Button 18"
BINDING_NAME_GACTIONBUTTON19 = "GBar Button 19"
BINDING_NAME_GACTIONBUTTON20 = "GBar Button 20"
BINDING_NAME_GACTIONBUTTON21 = "GBar Button 21"
BINDING_NAME_GACTIONBUTTON22 = "GBar Button 22"
BINDING_NAME_GACTIONBUTTON23 = "GBar Button 23"
BINDING_NAME_GACTIONBUTTON24 = "GBar Button 24"
BINDING_NAME_GACTIONBUTTON25 = "GBar Button 25"
BINDING_NAME_GACTIONBUTTON26 = "GBar Button 26"
BINDING_NAME_GACTIONBUTTON27 = "GBar Button 27"
BINDING_NAME_GACTIONBUTTON28 = "GBar Button 28"
BINDING_NAME_GACTIONBUTTON29 = "GBar Button 29"
BINDING_NAME_GACTIONBUTTON30 = "GBar Button 30"

-- local vars
local old_ActionButton_GetPagedID
local old_ActionButton_OnEvent
local old_Doll_OnLoad

-- saved vars
GBars_State = {}

-- save myself some typing
local function msg (txt)
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(txt)
	end
end

function GBars_OnLoad()
	-- hide the default xp bar
	-- this also kills the whole MainMenuBarArtFrame, which they made a child
	-- of the MainMenuExpBar for some unfathomable reason, including the
	-- minibar, lagbar, and bag bar
	if (MainMenuExpBar) then
		MainMenuExpBar_Update = function() end
		MainMenuExpBar:UnregisterEvent("PLAYER_XP_UPDATE")
	end
	if (MainMenuBar) then
		MainMenuBar:Hide()
	end

	-- also lose the exhaustion tick, for some reason it's separate
	if (ExhaustionTick) then
		ExhaustionTick:UnregisterEvent("PLAYER_XP_UPDATE");
		ExhaustionTick:UnregisterEvent("UPDATE_EXHAUSTION");
		ExhaustionTick:UnregisterEvent("PLAYER_LEVEL_UP");
		ExhaustionTick:UnregisterEvent("PLAYER_UPDATE_RESTING");
		ExhaustionTick:UnregisterEvent("PLAYER_ENTERING_WORLD");
		ExhaustionTick_Update = function() end
		ExhaustionTick:Hide()
	end

	-- hook the ActionButton_GetPagedID function to override paging on our extra buttons
	old_ActionButton_GetPagedID = ActionButton_GetPagedID
	ActionButton_GetPagedID = GBars_GetPagedID
	
	-- hook the action button event handler because it sucks
	old_ActionButton_OnEvent = ActionButton_OnEvent
	ActionButton_OnEvent = function(event)
		if (event == "UPDATE_BONUS_ACTIONBAR") then
			ActionButton_Update()
		else
			old_ActionButton_OnEvent(event)
		end
	end
	
	-- Replace the standard button keybinding handler
	ActionButtonDown = GActionButtonDown
	ActionButtonUp = GActionButtonUp

	-- register for events
	this:RegisterEvent("VARIABLES_LOADED")

	-- set our default dock method
	this.Dock = function(this)
		this:ClearAllPoints()
		this:SetPoint("BOTTOM", "$parent")
	end

	-- list of bars that are handled by this mod
	this.bars = {}
	this.bars["mainbar"] = "GMainBar"
	this.bars["secondbar"] = "GSecondBar"
	this.bars["bags"] = "GBagBar"
	this.bars["extra1"] = "GExtraBar1"
	this.bars["pet"] = "GPetActionBar"
	this.bars["shape"] = "GShapeshiftBar"
	this.bars["options"] = "GMicroButtons"
	this.bars["xp"] = "GXPBar"

	-- show a welcome message
	--msg("GBars Loaded")

	-- register the chat command
	SlashCmdList["GBARS"] = GBars_Command
	SLASH_GBARS1 = "/gbar"
	SLASH_GBARS2 = "/gbars"
end

-- handle events
function GBars_OnEvent()
	if (event == "VARIABLES_LOADED") then
		GBars_LoadState()
	elseif (event == "UNIT_NAME_UPDATE") then
		local player_name = UnitName("player")
		if (player_name and player_name ~= UNKNOWNOBJECT) then
			this:UnregisterEvent("UNIT_NAME_UPDATE")
			GBars_LoadState()
		end
	end
end

-- load the addon config from the saved variable
function GBars_LoadState()
	-- get the player's name - watch out for UNKNOWNOBJECT!
	local player_name = UnitName("player")
	if (not player_name or player_name == UNKNOWNOBJECT) then
		this:RegisterEvent("UNIT_NAME_UPDATE")
		return
	end
	g_player_name = player_name

	-- init the state from the saved variable
	local state = GBars_State[g_player_name]
	if (not state) then state = {} end
    
    if (not GBars_State["auto_disable"]) then GBars_State["auto_disable"] = 0 end
    
	-- perform AutoBar init stuff if it's enabled
	if (GBars_State["auto_disable"] ~= 1) then
		GAutoBar_Init()
	else
		GBars_Hide(GAutoBar)
	end

	-- restore bar settings
	for key, bar_name in pairs(this.bars) do
		local bar = getglobal(bar_name)
		if (type(state[bar_name]) == "table") then
			-- orientation
			if (state[bar_name]["vertical"] == 1) then
				GBars_LayoutVertical(bar)
				getglobal(bar:GetName().."Handle"):SetChecked(1) -- set red drag button
			else
				GBars_LayoutHorizontal(bar)
			end

			-- hide/show
			if (state[bar_name]["hidden"] == 1) then
				GBars_Hide(bar)
			end
		end
	end

	-- make sure the pet and shape bars get positioned properly (scaling workaround)
	if (not GShapeshiftBar:IsUserPlaced()) then GShapeshiftBar:Dock() end
	if (not GPetActionBar:IsUserPlaced()) then GPetActionBar:Dock() end

	-- init the xp bar
	GBars_XPUpdate()
end

-- save some data to the saved state
function GBars_SaveState(data)
	if (not g_player_name) then return end
	if (not GBars_State[g_player_name]) then
		GBars_State[g_player_name] = {}
	end
	RecursiveMerge(GBars_State[g_player_name], data)
end

-- merge some values into a table
function RecursiveMerge(target, source)
	for key, val in pairs(source) do
		if (target[key] and type(target[key]) == "table" and type(val) == "table") then
			RecursiveMerge(target[key], val)
		else
			target[key] = val
		end
	end
end

-- handle slash commands
function GBars_Command(cmd)
	bits = {}
	for w in string.gfind(cmd, "%w+") do
		table.insert(bits, w)
	end

	-- this is a little more complicated than I would like right now, but eh
	if (cmd == "reset" or cmd == "dock") then
		GBars_Dock(GBars)
		for key, barname in pairs(GBars.bars) do GBars_Lock(getglobal(barname)) end
		for key, barname in pairs(GBars.bars) do getglobal(barname):Dock() end
		for key, barname in pairs(GBars.bars) do GBars_Show(getglobal(barname)) end
	elseif (cmd == "lock") then
		GBars_Lock(GBars)
		for key, barname in pairs(GBars.bars) do GBars_Lock(getglobal(barname)) end
	elseif (cmd == "unlock") then
		GBars_Unlock(GBars)
		for key, barname in pairs(GBars.bars) do GBars_Unlock(getglobal(barname)) end
	elseif (cmd == "help") then
		msg("|cffffff00GBars Help")
		msg("/gbars lock - lock all bars in place")
		msg("/gbars unlock - unlock all bars for dragging")
		msg("/gbars reset - dock all bars in their default locations")
		msg(" ")
		msg("/gbars auto disable - turn off the GAutoBar feature (account-wide)")
		msg("/gbars auto enable - turn on the GAutoBar feature (account-wide)")
		msg(" ")
		msg("/gbars <barname> lock - lock one bar in place")
		msg("/gbars <barname> unlock - unlock one bar for dragging")
		msg("/gbars <barname> reset - dock one bar in default position")
		msg("/gbars <barname> hide - hide a bar from view")
		msg("/gbars <barname> show - unhide a bar")
		msg("(where <barname> is one of mainbar, secondbar, extra1, shape, pet, bags, options, xp, auto)")
		msg(" ")
		msg("Right-click the green drag handle when a bar is unlocked to flip it vertical.")
	elseif (bits[1] == "auto" and bits[2] == "disable") then
		GBars_State["auto_disable"] = 1
		GAutoBar_Disable()
		GBars_Hide(GAutoBar)
	elseif (bits[1] == "auto" and bits[2] == "enable") then
		GBars_State["auto_disable"] = 0
		GAutoBar_Init()
		GBars_Show(GAutoBar)
	elseif (GBars.bars[bits[1]]) then
		bar = getglobal(GBars.bars[bits[1]])
		if (bits[2] == "lock") then
			GBars_Lock(bar)
		elseif (bits[2] == "unlock") then
			GBars_Unlock(bar)
		elseif (bits[2] == "reset" or bits[2] == "dock") then
			GBars_Lock(bar)
			GBars_Dock(bar)
		elseif (bits[2] == "hide") then
			GBars_Hide(bar)
		elseif (bits[2] == "show") then
			GBars_Show(bar)
		else
			msg(RED_FONT_COLOR_CODE.."GBars did not understand '"..cmd.."'")
			msg(RED_FONT_COLOR_CODE.."Type "..HIGHLIGHT_FONT_COLOR_CODE.."/gbars help "..RED_FONT_COLOR_CODE.."for help.")
		end
	else
		msg(RED_FONT_COLOR_CODE.."GBars did not understand '"..cmd.."'")
		msg(RED_FONT_COLOR_CODE.."Type "..HIGHLIGHT_FONT_COLOR_CODE.."/gbars help "..RED_FONT_COLOR_CODE.."for help.")
	end
end

-- lock a window so it is unmovable
function GBars_Lock(frame)
	if (not frame) then frame = this; end
	if (frame.locked) then return end
	GBars_HideHandle(frame)
	GBars_HideGrid(frame)
	frame.locked = 1
end

-- unlock a window so it is movable
function GBars_Unlock(frame)
	if (not frame) then frame = this; end
	if (not frame.locked) then return end
	GBars_ShowHandle(frame)
	GBars_ShowGrid(frame)
	frame.locked = nil
end

-- dock (and lock) a frame at its current dock point
function GBars_Dock(frame)
	if (not frame) then frame = this; end
	GBars_Lock(frame)
	frame:Dock()
end

-- if the passed-in frame has a handle, show it
function GBars_ShowHandle(frame)
	handle = getglobal(frame:GetName().."Handle")
	if (handle) then
		handle:SetScale(0.6)
		handle:Show()
	end
end

-- if the passed-in frame has a handle, hide it
function GBars_HideHandle(frame)
	handle = getglobal(frame:GetName().."Handle")
	if (handle) then
		handle:Hide()
	end
end

-- start dragging if not locked
function GBars_DragStart(frame)
	if (not frame) then frame = this; end
	if (not frame.locked) then
		frame.isMoving = 1
		frame:StartMoving()
	end
end

-- end dragging
function GBars_DragStop(frame)
	if (not frame) then frame = this; end
	frame:StopMovingOrSizing()
	frame.isMoving = nil
end

-- display empty buttons on a frame
function GBars_ShowGrid(bar)
	if (bar:GetName() == "GPetActionBar") then
		GPetActionBar_ShowGrid()
	elseif (bar:GetName() == "GShapeshiftBar") then
		return
	elseif (bar:GetName() == "GAutoBar") then
		for i = bar.first, bar.last do
			getglobal(bar.basename..i):Show()
		end
	elseif (not bar.basename) then
		return
	else
		for i = bar.first, bar.last do
			curr = getglobal(bar.basename..i)
			ActionButton_ShowGrid(curr)
		end
	end
end

-- hide empty buttons on a frame
function GBars_HideGrid(bar)
	if (bar:GetName() == "GPetActionBar") then
		GPetActionBar_HideGrid()
	elseif (bar:GetName() == "GShapeshiftBar") then
		return
	elseif (bar:GetName() == "GAutoBar") then
		for i = bar.first, bar.last do
			curr = getglobal(bar.basename..i)
			if (not curr.bag) then curr:Hide() end
		end
	elseif (not bar.basename) then
		return
	else
		for i = bar.first, bar.last do
			curr = getglobal(bar.basename..i)
			ActionButton_HideGrid(curr)
		end
	end
end

-- arrange a series of buttons as a horizontal bar
function GBars_LayoutHorizontal(bar)
	if (not bar.basename) then return end
	for i = bar.first + 1, bar.last do
		curr = getglobal(bar.basename..i)
		last = getglobal(bar.basename..(i - 1))
		curr:ClearAllPoints()
		curr:SetPoint("LEFT", last:GetName(), "RIGHT", 3, 0)
	end
	bar.vertical = nil
	GBars_SaveState({ [bar:GetName()] = { vertical = 0 } })
end

-- arrange a series of buttons as a vertical bar
function GBars_LayoutVertical(bar)
	if (not bar.basename) then
		getglobal(bar:GetName().."Handle"):SetChecked(nil)
		return
	end
	for i = bar.first + 1, bar.last do
		curr = getglobal(bar.basename..i)
		last = getglobal(bar.basename..(i - 1))
		curr:ClearAllPoints()
		curr:SetPoint("TOP", last:GetName(), "BOTTOM", 0, -3)
	end
	bar.vertical = 1
	GBars_SaveState({ [bar:GetName()] = { vertical = 1 } })
end

-- hide a bar from view
function GBars_Hide(bar)
	bar:Hide()
	bar.hidden = 1
	GBars_SaveState({ [bar:GetName()] = { hidden = 1 } })
end

-- display a bar
function GBars_Show(bar)
	bar:Show()
	bar.hidden = nil
	GBars_SaveState({ [bar:GetName()] = { hidden = 0 } })
end

function GBars_GetPagedID(button)
	local offset = GetBonusBarOffset()

	if (button.isGBar) then
		return button:GetID()
	elseif (button:GetParent():GetName() == "MultiBarLeft") then
		return button:GetID() + (LEFT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS
	elseif (button:GetParent():GetName() == "MultiBarRight") then
		return button:GetID() + (RIGHT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS
	elseif (offset > 0 and CURRENT_ACTIONBAR_PAGE == 1) then
		return button:GetID() + (NUM_ACTIONBAR_PAGES + offset - 1) * NUM_ACTIONBAR_BUTTONS
	else
		return button:GetID() + (CURRENT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS
		-- return old_ActionButton_GetPagedID(button)
	end
end

function GActionButtonDown(id)
	local button = getglobal("GActionButton"..id)
	if (button:GetButtonState() == "NORMAL") then
		button:SetButtonState("PUSHED")
	end
end

function GActionButtonUp(id, onSelf)
	local button = getglobal("GActionButton"..id)
	if (button:GetButtonState() == "PUSHED") then
		button:SetButtonState("NORMAL")
		if (MacroFrame_SaveMacro) then
			MacroFrame_SaveMacro()
		end
		UseAction(ActionButton_GetPagedID(button), 0, onSelf)
		if (IsCurrentAction(ActionButton_GetPagedID(button))) then
			button:SetChecked(1)
		else
			button:SetChecked(0)
		end
	end
end

function GActionButton_UpdateBindings(name)
	if (not name) then
		name = this:GetName()
	end
	local hotkey = getglobal(this:GetName().."HotKey")
	local text = GetBindingText(GetBindingKey(name), "KEY_")

	-- list of substitutions happily lifted from Telo's BottomBar, with a few new additions
	text = string.gsub(text, "CTRL%-", "C-")
	text = string.gsub(text, "STRG%-", "C-")
	text = string.gsub(text, "ALT%-", "A-")
	text = string.gsub(text, "SHIFT%-", "S-")
	text = string.gsub(text, "Num Pad", "NP")
	text = string.gsub(text, "Backspace", "Bksp")
	text = string.gsub(text, "Spacebar", "Space")
	text = string.gsub(text, "Page", "Pg")
	text = string.gsub(text, "Down", "Dn")
	text = string.gsub(text, "Arrow", "")
	text = string.gsub(text, "Insert", "Ins")
	text = string.gsub(text, "Delete", "Del")
	text = string.gsub(text, "Mouse Button", "MB")
	text = string.gsub(text, "Maustaste", "MT")
	
	hotkey:SetText(text)
end

function GBagBar_OnLoad()
	-- Obliterate the standard bag/bp variables with ours
	CharacterBag0Slot = GBagSlot0
	CharacterBag1Slot = GBagSlot1
	CharacterBag2Slot = GBagSlot2
	CharacterBag3Slot = GBagSlot3
	MainMenuBarBackpackButton = GBackpackButton
	
	-- set our default dock method
	this.Dock = function(this)
		this:ClearAllPoints()
		this:SetPoint("BOTTOMRIGHT", "$parent")
	end
end

-- This is a near copy of PaperDollItemSlotButton_OnLoad
function GBarsBagSlot_OnLoad()
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("CURSOR_UPDATE");
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
	this:RegisterEvent("SHOW_COMPARE_TOOLTIP");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	local slotName = "CharacterBag"..this:GetID().."Slot";
	local id;
	local textureName;
	id, textureName = GetInventorySlotInfo(strsub(slotName,10));
	this:SetID(id);
	local texture = getglobal(slotName.."IconTexture");
	texture:SetTexture(textureName);
	this.backgroundTextureName = textureName;
	PaperDollItemSlotButton_Update();
end

-- update the size of the xp bar texture
function GBars_XPUpdate()
	GXPBarFill:SetHeight(GXPBarBack:GetHeight() * UnitXP("player") / UnitXPMax("player"))
	if (GetXPExhaustion()) then
		GXPBarFill:SetVertexColor(0.0, 1.0, 0.0)
	else
		GXPBarFill:SetVertexColor(0.4, 0.7, 1.0)
	end
end

-- update xp bar
function GXPBar_OnEvent()
	GBars_XPUpdate()
end

-- show the xp tooltip
function GXPBar_ShowTooltip()
	-- anchor and set XP % text
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
	GameTooltip:SetText("XP "..format("%3.1f", 100 * UnitXP("player") / UnitXPMax("player")).."%")
	
	-- get latency info and set curr / max   ping line
	local rate_in, rate_out, latency = GetNetStats()
	GameTooltip:AddDoubleLine(UnitXP("player").." / "..UnitXPMax("player"), latency.." ping", 1.0, 1.0, 1.0, 0.6, 0.6, 1.0)

	-- add rest state line if rested
	if (GetXPExhaustion()) then
		GameTooltip:AddLine("Rested for "..GetXPExhaustion().." XP", 0.0, 1.0, 0.0)
	end
	
	-- show it!
	GameTooltip:Show()
end
