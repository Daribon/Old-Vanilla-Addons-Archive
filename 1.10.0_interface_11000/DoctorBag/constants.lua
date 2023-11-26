DOCTORBAG_TEXTURE_BLESSING_OF_SALVATION 		= "Interface\\Icons\\Spell_Holy_SealOfSalvation";
DOCTORBAG_TEXTURE_BLESSING_OF_SALVATION_GREATER	= "Interface\\Icons\\Spell_Holy_GreaterBlessingofSalvation";
DOCTORBAG_TEXTURE_BLESSING_OF_WISDOM	 		= "Interface\\Icons\\Spell_Holy_SealOfWisdom";
DOCTORBAG_TEXTURE_BLESSING_OF_WISDOM_GREATER	= "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom";
DOCTORBAG_TEXTURE_BLESSING_OF_MIGHT		 		= "Interface\\Icons\\Spell_Holy_FistOfJustice";
DOCTORBAG_TEXTURE_BLESSING_OF_MIGHT_GREATER		= "Interface\\Icons\\Spell_Holy_GreaterBlessingofMight";
DOCTORBAG_TEXTURE_BLESSING_OF_KINGS		 		= "Interface\\Icons\\Spell_Magic_MageArmor";
DOCTORBAG_TEXTURE_BLESSING_OF_KINGS_GREATER		= "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings";
DOCTORBAG_TEXTURE_BLESSING_OF_LIGHT		 		= "Interface\\Icons\\Spell_Holy_PrayerOfHealing02";
DOCTORBAG_TEXTURE_BLESSING_OF_LIGHT_GREATER		= "Interface\\Icons\\Spell_Holy_GreaterBlessingofLight";


DOCTORBAG_UNITS = {
	party = 4;
	partypet = 4;
	raid = 40;
	raidpet = 40;
};
for k,v in DOCTORBAG_UNITS do
	if ( type(v) ~= "table" ) then
		local t = {};
		for i=1,v do
			table.insert(t, k..i);
		end
		DOCTORBAG_UNITS[k] = t;
	end
end
