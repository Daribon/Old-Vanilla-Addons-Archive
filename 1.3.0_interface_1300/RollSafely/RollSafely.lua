--
-- Roll Safely - 1.1.0
-- http://home.san.rr.com/kral/WoW/rollsafely/
--
-- Roll Safely modifies the World of Warcraft user interface to warn the user 
-- if they are about to roll on a 'Binds when picked up' item.  It does this 
-- just as you would have expected WoW's programmers to have implemented it - 
-- when you click the roll button, if the item is 'Binds when picked up', the 
-- same warning dialog is displayed as the one you get when looting such an 
-- item without a roll.
--
-- Rosten <rosten@variadic.org>
-- AnduinLothar <karlkfi@yahoo.com>
-- Wulph <shadowulph@earthlink.net>
--

local ROLLSAFELY_VERSION = "1.1.0";

local RollSafely_OriginalRollOnLootHandler;


function RollSafely_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
end

function RollSafely_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		RollSafely_Init();
	end
end

function RollSafely_Init()

	-- Hook RollOnLoot.
	RollSafely_OriginalRollOnLootHandler = RollOnLoot;
	RollOnLoot = RollSafely_RollOnLoot;

	-- Define a dialog similar to LOOT_BIND, but designed to roll on
	-- confirmation, and also not automatically cancel on interruptions
	-- like death and cinematics.
	StaticPopupDialogs["ROLL_BIND"] = {
		text = TEXT(LOOT_NO_DROP),
		button1 = TEXT(OKAY),
		button2 = TEXT(CANCEL),
		OnAccept = function(rollID)
			RollSafely_OriginalRollOnLootHandler(rollID, 1);
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		interruptCinematic = 1
	};

end

function RollSafely_RollOnLoot(rollID, roll)

	-- If this is not an attempt to roll, pass.
	if ( roll ~= 1 ) then
		RollSafely_OriginalRollOnLootHandler(rollID, roll);
		return;
	end

	-- Check if the rolled item is bind on pickup.
	GameTooltip:SetLootRollItem(rollID);
	if ( (GameTooltip:NumLines() >= 2) and (GameTooltipTextLeft2:GetText() == TEXT(ITEM_BIND_ON_PICKUP)) ) then

		-- Need to ask the user if they want to roll on a binding item.
		local dialog = StaticPopup_Show("ROLL_BIND");
		if ( dialog ) then
			dialog.data = rollID;

		-- Failed to ask the user, so just roll anyway.
		else
			RollSafely_OriginalRollOnLootHandler(rollID, roll);
		end

	-- Roll as usual on non-binding items.
	else
		RollSafely_OriginalRollOnLootHandler(rollID, roll);
	end
end
