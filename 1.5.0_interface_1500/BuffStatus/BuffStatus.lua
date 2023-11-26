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
--
-- returns	returns 1/nil if the debuff is applied. if pattern is
--			not nil it will also return the results of string.find using
--			the pattern
function UnitDebuffInformation( unit, debuff, pattern )
	local i = 1;

	while UnitDebuff( unit, i ) do
		BuffStatusTooltip:SetUnitDebuff( unit, i );

		if BuffStatusTooltipTextLeft1:GetText() == debuff then
			return UnitInformation( pattern );
		end

		i = i + 1;
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
--=============================================================================