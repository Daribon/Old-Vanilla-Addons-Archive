local AutoHide = TRUE

AceLoot 			= AceAddonClass:new({
	name					= "AceLoot",
	description		= "AceLoot, based on Telo's QuickLoot",
	version				= "a./R4",
	aceCompatible	= "102",
	category			= ACE_CATEGORY_INTERFACE,
	cmd						= AceChatCmdClass:new({"/aceloot", "/al"})
})

--[[---------------------------
 Hooking and Event Registration
-----------------------------]]

function AceLoot:Enable()
	self:RegisterEvent("LOOT_SLOT_CLEARED", "ItemUnderCursor")
	self:Hook("LootFrame_Update", "ItemUnderCursor")
		UIPanelWindows["LootFrame"] = nil
		LootFrame:SetMovable(1)
		LootFrame:SetScript("OnMouseUp", function () LootFrame:StopMovingOrSizing() end)
		LootFrame:SetScript("OnMouseDown", function () LootFrame:StartMoving() end)
end

--[[----------------------------------------------------
	Main Function taken and improved from Telo's QuickLoot
------------------------------------------------------]]

function AceLoot:ItemUnderCursor()
	self:CallHook("LootFrame_Update")
		local x, y = GetCursorPosition()
		local s = LootFrame:GetScale()
		x = x / s
		y = y / s
			LootFrame:ClearAllPoints()
	for i = 1, LOOTFRAME_NUMBUTTONS, 1 do
		local button = getglobal("LootButton"..i)
		if( button:IsVisible() ) then
			x = x - 42
			y = y + 56 + (40 * i)
				LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y)
			return
		end
	end
	if LootFrameDownButton:IsVisible() then
		-- If down arrow, position on it
		x = x - 158
		y = y + 223
	else
		if AutoHide and GetNumLootItems() == 0 then
			HideUIPanel(LootFrame)
			return
		end
	end
		LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y)
end

--[[------------------------
	The End -> Register Object
--------------------------]]

AceLoot:RegisterForLoad()
