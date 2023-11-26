--[[
--
--	Sea.wow.spell
--
--	Spell related wow functions
--
--	$LastChangedBy: AlexYoshi $
--	$Rev: 1142 $
--	$Date: 2005-03-22 17:20:48 +0100 (Tue, 22 Mar 2005) $
--]]

Sea.wow.spell = {

	--
	-- getHighestBuffRankForLevel( buffName, level )
	--
	-- 	Retrieves the highest rank available for the specified buff
	--
	-- Args:
	-- 	(string buffName, int level)
	-- 	buffName - the name of the buff spell
	-- 	level - the level to verify against
	-- 	
	-- Returns:
	-- 	(int rank)
	-- 	rank - the highest rank for the level, 0 if no rank matches, -1 if buff spell could not be found
	-- 	
	getHighestBuffRankForLevel( buffName, level )
		if ( not buffName ) or ( not level ) then
			return -1;
		end
		local data = Sea.data.spell.spellRankLevel[buffName];
		if ( not data ) then
			return -1;
		end
		for i = 1, table.getn(data), 1 do
			if ( level < data[i] ) then
				return i-1;
			end
		end
		return 0;
	end;

	--
	-- getSpellNameAndRankFromStrings(strings)
	--
	-- 	Returns a great deal of useful information about an item.
	--
	-- Return:
	-- 	Table[
	-- 		.name -- spellname
	-- 		.rank -- rank string
	-- 		.rankNumber -- rank as number (nil if not possible to convert to number)
	-- 		] spellInfo; 
	--
	--		 return value is nil if no strings are nil
	--
	getSpellNameAndRankFromStrings = function (strings)
		if ( not strings ) then
			return nil;
		end
		local spellInfo = {};
		spellInfo.name = strings[1].left;
		spellInfo.rank = strings[1].right;
		for number in string.gfind(spellInfo.rank, Sea.data.spell.rankText) do
			spellInfo.rankNumber = tonumber(number);
		end
		return spellInfo;
	end;
	
	
};
