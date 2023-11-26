CT_RA_DebuffOptions = { };
CT_RA_DebuffTemplates = {
	{
		["name"] = "Magical Spells",
		["debuffName"] = "*",
		["debuffType"] = "Magic",
		["nonDeletable"] = 1
	},
	{
		["name"] = "Diseases",
		["debuffName"] = "*",
		["debuffType"] = "Disease",
		["nonDeletable"] = 1
	},
	{
		["name"] = "Curses",
		["debuffName"] = "*",
		["debuffType"] = "Curse",
		["nonDeletable"] = 1
	},
	{
		["name"] = "Poisons",
		["debuffName"] = "*",
		["debuffType"] = "Poison",
		["nonDeletable"] = 1
	},
		{
		["name"] = "All Spells",
		["debuffName"] = "*",
		["debuffType"] = "*",
		["nonDeletable"] = 1
	}
};

------------------------------------------------------------
--              CT_RADebuff_Add(name, debuffType)               --
-- Takes a debuff and inserts it to the queue accordingly --
------------------------------------------------------------

function CT_RADebuff_Add(name, type)
	
	-- Find matching template
	for key, val in CT_RA_DebuffTemplates do
		local searchName, searchType = string.gsub(val["debuffName"], "*", ".+"), string.gsub(val["debuffType"], "*", ".+");

		if ( string.find(name, searchName) or string.find(debuffType, searchType) ) then
			-- Check to see if the debuff needs to be inserted at a special place
			for index, value in CT_RA_DebuffQueue do
				if ( value["index"] >= key ) then
					CT_Print("Inserting debuff " .. name .. " ("..debuffType..") at index " .. index);
					tinsert(
						CT_RA_DebuffQueue,
						index,
						{
							["index"] = key,
							["name"] = name,
							["type"] = debuffType
						}
					);
					return;
				end
			end
			
			-- If not, insert at the end
			CT_Print("Inserting debuff " .. name .. " ("..debuffType..") at the end");
			tinsert(
				CT_RA_DebuffQueue,
				{
					["index"] = key,
					["name"] = name,
					["type"] = debuffType
				}
			);
		end
	end
end