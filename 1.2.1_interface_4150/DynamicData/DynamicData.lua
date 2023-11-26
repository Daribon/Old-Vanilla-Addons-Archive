--[[
	DynamicData

	By sarf

	This mod allows you to access dynamic data in WoW without being forced to rely on strange Blizzard functions

	Thanks goes to the Cosmos team, the nice (but strange) people at #cosmostesters and Blizzard.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=NOT_YET_ANNOUNCED
	
   ]]

DYNAMICDATA_DEFAULT_NUMBER_OF_TOOLTIP_SCANS_PER_UPDATE = 5;

DynamicData = {

	-- Action information
	action = {};

	-- Effect information - what buffs/debuffs the player, party, pet and target has
	effect = {};

	-- Item information - what the player is wearing and so on.
	item = {};

	-- Quest information - current quests and their objectives.
	quest = {};

	-- Party information - who is your current comrades and what are they wearing?
	party = {};

	-- Spell information
	spell = {};

	-- Utility functions and data
	util = {};

};

