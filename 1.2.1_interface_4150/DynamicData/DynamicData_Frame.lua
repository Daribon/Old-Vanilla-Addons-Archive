--[[
	DynamicData

	By sarf

	This mod allows you to access dynamic data in WoW without being forced to rely on strange Blizzard functions

	Thanks goes to the Cosmos team, the nice (but strange) people at #cosmostesters and Blizzard.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=NOT_YET_ANNOUNCED
	
   ]]

function DynamicDataScriptFrame_OnLoad()
	-- item events
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");

	-- effect events
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("UNIT_AURASTATE");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_ENABLE");
	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	this:RegisterEvent("PLAYER_PET_CHANGED");
	
	-- action events
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	
	-- spell events
	
	this:RegisterEvent("SPELLS_CHANGED");
	this:RegisterEvent("LEARNED_SPELL_IN_TAB");

	DynamicData.action.OnLoad();
	DynamicData.effect.OnLoad();
	DynamicData.item.OnLoad();
	DynamicData.spell.OnLoad();
end

function DynamicDataScriptFrame_OnEvent(event)
	-- item events
	if ( event == "BAG_UPDATE" ) then
		DynamicData.item.updateItems(arg1);
	end
	if ( event == "BAG_UPDATE_COOLDOWN" ) then
		DynamicData.item.updateItemCooldowns();
	end
	if ( event == "ITEM_LOCK_CHANGED" ) then
		DynamicData.item.updateItemLocks();
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			DynamicData.item.updateItems(-1);
		end
	end
	if ( event == "UPDATE_INVENTORY_ALERTS" ) then
		DynamicData.item.updateItemAlerts();
	end
	-- effect events
	if ( event == "UNIT_AURA" ) then
		DynamicData.effect.updateEffects(arg1);
		return;
	end
	if ( event == "PLAYER_AURAS_CHANGED" ) then
		DynamicData.effect.updateEffects("player");
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		DynamicData.effect.updateEffects(arg1);
		return;
	end
	if ( event == "PARTY_MEMBER_ENABLE" or event == "PARTY_MEMBER_DISABLE" ) then
		DynamicData.effect.updateEffects(arg1);
	end
	if ( event == "PARTY_MEMBERS_CHANGED" ) then
		local unit = "party";
		for i = 1, 4 do
			unit = "party"..i;
			DynamicData.effect.updateEffects(unit);
		end
		return;
	end
	if ( event == "PLAYER_PET_CHANGED" ) then
		DynamicData.effect.updateEffects("pet");
	end	
	-- target changed event
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		DynamicData.effect.updateEffects("target");
	end
	-- action events
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 ) then
			DynamicData.action.updateActions();
		else
			DynamicData.action.updateActions(arg1);
		end
	end
	-- spell events
	if ( (event == "SPELLS_CHANGED") or ( event == "LEARNED_SPELL_IN_TAB") ) then
		DynamicData.spell.updateSpells();
	end
end



