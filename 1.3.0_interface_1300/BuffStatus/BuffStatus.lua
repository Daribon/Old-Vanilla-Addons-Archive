--=============================================================================
-- File:		BuffStatus.lua
-- Author:		© 2004, 2005 Miron
-- Description:	AddOn to return extended information about a target's buffs
--=============================================================================

--=============================================================================
-- Return information about the pattern
--
-- pattern	pattern to find
local function UnitInformation( pattern )
	if pattern then
		return 1, string.find( BuffStatusTooltipTextLeft2:GetText(), pattern );
	else
		return 1;
	end
end
--=============================================================================

--=============================================================================
-- Returns information if the given debuff is applied to the unit
--
-- unit		unit name ("player", "target", "pary1", ...)
-- debuff	debuff's name
-- patern	optional, regex pattern to use on the debuff's information.
-- texture  the texture of the debuff (optional)
--
-- returns	returns 1/nil if the debuff is applied. if pattern is
--			not nil it will also return the results of string.find using
--			the pattern
function UnitDebuffInformation( unit, debuff, pattern, texture )
	local i = 1;
	
	local curTexture = UnitDebuff( unit, i );
	local doCheck = true;

	while curTexture  do
		
		if ( texture ) then
			if ( texture == curTexture ) then
				doCheck = true;
			else
				doCheck = false;
			end
		else
			doCheck = true;
		end
		if ( doCheck ) then
			BuffStatusTooltip:SetUnitDebuff( unit, i );
	
			if BuffStatusTooltipTextLeft1:GetText() == debuff then
				return UnitInformation( pattern );
			end
		end

		i = i + 1;
		curTexture = UnitDebuff( unit, i )
	end

	return nil;
end

-- Returns information if the given buff is applied to the unit
--
-- unit		unit name ("player", "target", "pary1", ...)
-- debuff	buff's name
-- patern	optional, regex pattern to use on the buff's information.
--
-- returns	returns 1/nil if the buff is applied. if pattern is
--			not nil it will also return the results of string.find using
--			the pattern
function UnitBuffInformation( unit, buff, pattern )
	local i = 1;

	while UnitBuff( unit, i ) do
		BuffStatusTooltip:SetUnitBuff( unit, i );

		if BuffStatusTooltipTextLeft1:GetText() == buff then
			return UnitInformation( pattern );
		end

		i = i + 1;
	end

	return nil;
end

-- Returns if a debuff of the specified type is applied and the debuff's name
--
-- unit			unit name ("player", "target", "party1", ...)
-- debuffType	debuff type ("Poison", "Magic", ...)
--
-- returns		returns 1/nil if the unit has a debuff of that type. If the
--				it does have a debuff of that type the debuff's name is also
--				returned
function UnitDebuffType( unit, debuffType )
	local i = 1;

	while UnitDebuff( unit, i ) do
		BuffStatusTooltip:SetUnitDebuff( unit, i );

		if BuffStatusTooltipTextRight1:GetText() == debuffType then
			return 1, BuffStatusTooltipTextLeft1:GetText();
		end

		i = i + 1;
	end

	return nil;
end

-- Returns if a buff of the specified type is applied and the buff's name
--
-- unit			unit name ("player", "target", "party1", ...)
-- buffType		buff type ("Poison", "Magic", ...)
--
-- returns		returns 1/nil if the unit has a buff of that type. If the
--				it does have a buff of that type the buff's name is also
--				returned
function UnitBuffType( unit, buffType )
	local i = 1;

	while UnitBuff( unit, i ) do
		BuffStatusTooltip:SetUnitBuff( unit, i );

		if BuffStatusTooltipTextRight1:GetText() == buffType then
			return 1, BuffStatusTooltipTextLeft1:GetText();
		end

		i = i + 1;
	end

	return nil;
end
--=============================================================================