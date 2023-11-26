CT_RA_ClassSpells = { };

function CT_RA_GetClassSpells()
	CT_RA_ClassSpells = { };
	for i = 1, GetNumSpellTabs(), 1 do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
		for y = 1, numSpells, 1 do
			local spellName, rankName = GetSpellName(offset+y, BOOKTYPE_SPELL);
			local useless, useless, rank = string.find(rankName, "(%d+)");
			if ( not CT_RA_ClassSpells[spellName] or CT_RA_ClassSpells[spellName]["rank"] < tonumber(rank) ) then
				CT_RA_ClassSpells[spellName] = { ["rank"] = tonumber(rank), ["tab"] = i, ["spell"] = y+offset };
			end
		end
	end
end

function CT_RA_ClassSpells_OnEvent(event)
	if ( event == "SPELLS_CHANGED" ) then
		CT_RA_GetClassSpells();
	end
end