-- to use, macro: /run DoctorBag_SmartBlessing("target")

DoctorBag_Options = {

	buffByClass = true; -- if set to false, will buff by type of "power" - mana or not.
	
};

DoctorBag_Setup = {
	blessings = {};
	cleanseSpell = nil;
};


DOCTORBAG_BLESSINGLIST_RAID		= {
	DOCTORBAG_BLESSING_OF_WISDOM,
	DOCTORBAG_BLESSING_OF_MIGHT,
	DOCTORBAG_BLESSING_OF_SALVATION,
	DOCTORBAG_BLESSING_OF_LIGHT
};

DOCTORBAG_BLESSINGLIST_PARTY	= {
	DOCTORBAG_BLESSING_OF_WISDOM,
	DOCTORBAG_BLESSING_OF_MIGHT,
	DOCTORBAG_BLESSING_OF_LIGHT
};

function DoctorBag_RogueButton_GetTalentInfo(talentName)
	local talentMax = 0;
	local name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq;
	local maxTab = 5;
	-- Damn Blizzard and dynamic constants. :(
	if ( MAX_TALENT_TABS ) then maxTab = MAX_TALENT_TABS; end
	for tab=1,maxTab do
		for talent=1,GetNumTalents(tab) do
			name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(tab, talent);
			if ( name == talentName ) then
				return name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq;
			end
		end
	end
end

function DoctorBag_HasBlessingOfKings()
	local name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq = DoctorBag_RogueButton_GetTalentInfo(DOCTORBAG_BLESSING_OF_KINGS);
	if ( rank > 0 ) then
		return true;
	else
		return false;
	end
end

function DoctorBag_HasBuffByTexture(unit, tex, tex2)
	local buff;
	for i=1,24 do 
		buff = UnitBuff(unit,i);
		if ( not buff ) then
			return false;
		end
		if ( strfind(buff, tex) ) then
			return true;
		end
		if ( tex2 ) and ( strfind(buff, tex2) ) then
			return true;
		end
	end
	return false;
end

function DoctorBag_SmartBlessing(unit, useGreater)
	if ( not unit ) then unit = "target"; end
	local l = DoctorBag_Setup.blessings;
	while ( table.getn(l) > 0 ) do table.remove(l) end
	local list = DOCTORBAG_BLESSINGLIST_PARTY;
	if ( GetNumRaidMembers() > 0 ) then
		list = DOCTORBAG_BLESSINGLIST_RAID;
	end
	for k,v in list do
		table.insert(l, v);
	end
	if ( DoctorBag_HasBlessingOfKings() ) then
		table.insert(l, 1, DOCTORBAG_BLESSING_OF_KINGS);
	end
	return DoctorBag_CastBlessing(unit, l, useGreater);
end

function DoctorBag_IsInPvP(unit)
	return DOCTORBAG_PVP_ZONES[GetRealZoneText()];
end

function DoctorBag_ShouldCastBlessing(unit, blessing)
	if ( blessing == DOCTORBAG_BLESSING_OF_MIGHT ) then 
		local class;
		_,class = UnitClass(unit);
		if ( class == "MAGE" ) or ( class == "PRIEST" ) or ( class == "WARLOCK" ) then
			return false;
		end
	end
	if ( blessing == DOCTORBAG_BLESSING_OF_WISDOM ) then 
		local class;
		_,class = UnitClass(unit);
		if ( class == "WARRIOR" ) or ( class == "ROGUE" ) then
			return false;
		end
	end
	if ( blessing == DOCTORBAG_BLESSING_OF_SALVATION ) then
		if ( DoctorBag_IsInPvP(unit) ) then
			return false;
		end
		if ( type(CT_RATarget) == "table" ) and ( CT_RATarget.MainTanks ) then
			for k, v in CT_RATarget.MainTanks do
				if ( UnitIsUnit("raid"..v[1].."target", unit) ) then
					return false;
				end
			end
		end
	end
	local textures = DOCTORBAG_BUFF_TEXTURES[blessing];
	if ( type(textures) == "table" ) and ( DoctorBag_HasBuffByTexture(unit, textures[1], textures[2]) ) then
		return false;
	end
	return true;
end

function DoctorBag_CastBlessing(unit, blessingList, useGreater)
	local s = "";
	for k,v in blessingList do
		if ( DoctorBag_ShouldCastBlessing(unit,v) ) then
			s = v;
			if ( useGreater ) then
				s=DoctorBag_MakeGreaterBlessing(v);
			end
			CastSpellByName(s);
			SpellTargetUnit(unit);
			return true;
		end
	end
	return false;
end

function DoctorBag_InitializeFrame(frame)
	frame:SetScript("OnEvent", DoctorBag_OnEvent);
	
end

function DoctorBag_UpdateBoK()
	local hasBoK = DoctorBag_HasBlessingOfKings();
	if ( DoctorBag_Setup.blessingsRaid ) then
	end
end

function DoctorBag_OnEvent()
	if ( event == "SPELLS_CHANGED" ) then
		DoctorBag_UpdateBoK();
		return;
	end
end

function DoctorBag_SimpleCleanseUnit(unit, spell)
	if ( not unit ) then return false; end
	if ( not UnitExists(unit) ) or ( not UnitIsVisible(unit) ) or ( not UnitIsCharmed(unit) ) or ( not CheckInteractDistance(unit, 4) ) then
		return false;
	end
	local d,c,k;
	for j=1,16 do
		d,c,k = UnitDebuff(unit, j);
		if ( not d ) then
			return false;
		elseif ( k ) and ( k~="none" ) then
			if ( DOCTORBAG_DEBUFF_REMOVING[spell][k] ) then
				local lastTarget = nil;
				if ( UnitIsFriend("player", "target") ) then
					lastTarget = UnitName("target");
					ClearTarget();
				end
				CastSpellByName(spell);
				SpellTargetUnit(unit);
				if ( lastTarget ) then
					TargetByName(lastTarget, 1);
				end
				return true;
			end
		end
	end
	return false;
end

function DoctorBag_GetCleanseSpell()
	if ( DoctorBag_Setup.cleanseSpell == false ) then
		return nil;
	end
	if ( DoctorBag_Setup.cleanseSpell ) then
		return DoctorBag_Setup.cleanseSpell;
	end
	local spell = nil;
	local spellName = nil;
	for i=1,9999 do 
		spellName = GetSpellName(i,"spell")
		if ( spellName == DOCTORBAG_PURIFY ) and ( not spell ) then 
			spell = spellName;
		end
		if ( spellName == DOCTORBAG_CLEANSE ) then 
			spell = spellName;
			break;
		end
	end
	if ( not spell ) then
		spell = false;
	end
	DoctorBag_Setup.cleanseSpell = spell;
	return cleanseSpell;
end

function DoctorBag_SimpleCleanseAll()
	local spell = DoctorBag_GetCleanseSpell();
	if ( not spell ) then return false; end
	local g = "raid";
	local n = GetNumRaidMembers();
	if ( n <= 0 ) then
		n = GetNumPartyMembers();
		g = "party";
	end
	local unit;
	for i=1,n do
		unit = DOCTORBAG_UNITS[g][i];
		if ( unit ) then
			if ( DoctorBag_SimpleCleanseUnit(unit, spell) ) then
				return true;
			end
		end
	end
	return DoctorBag_SimpleCleanseUnit("player");
end

local frame = CreateFrame("Frame","DoctorBagFrame");
DoctorBag_InitializeFrame(frame);

