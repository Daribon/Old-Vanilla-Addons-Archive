function AQ_BuffBot_RangeToUnit(target_unit)
	if ( target_unit == "player" ) then
		return 0;
	end
	if ( UnitDistance ) then
		local distance = UnitDistance("player", target_unit);
		if ( not distance ) then
			return -1;
		end
		return distance;
	end
	if ( GetWorldPosition ) and ( YardDistance ) then
		local px, py = GetWorldPosition("player", nil, true);
		local tx, ty = GetWorldPosition(target_unit, nil, true);
		if ( not px ) or ( not py ) then
			_In_Instance = true;
			return -1;
		end
		return YardDistance(px, py, tx, ty);
	end
	if ( AutoTravel_GetCurrentPosition ) then
		local px, py = AutoTravel_GetCurrentPosition(nil, nil, "player");
		local tx, ty = AutoTravel_GetCurrentPosition(nil, nil, target_unit);
		if ( not px ) or ( not py ) then
			_In_Instance = true;
			return -1;
		end
		_In_Instance = false;
		local dX = tx-px;
		local dY = ty-py;
		local distance = sqrt(dX*dX + dY*dY) * ATStatus.yard_factor;
		return distance;
	end
	local continent = GetCurrentContinent();
	local zone = GetCurrentMapZone();
	local range = AQ_BuffBot_RangeToUnit_Internal(target_unit);
	if ( zone > 0 ) then
		SetCurrentMapZoom(continent, zone);
	else
		SetCurrentMapZoom(continent);
	end
	return range;
end

function AQ_BuffBot_RangeToUnit_Internal(target_unit)
	if ( GatherConfig ) and ( GatherConfig.mapMinder == true ) then return -1 end
	local px, py = GetPlayerMapPosition("player")
	if (px == 0 and py == 0) then
		if _In_Instance then return -1 end
		SetMapToCurrentZone()
		if GetCurrentMapContinent() == 0 then
			_In_Instance = true
			return -1
		else
			px, py = GetPlayerMapPosition("player")
		end
	else
		if _In_Instance then 
			_In_Instance = not _In_Instance;
			SetMapToCurrentZone()
		end
	end

	local continent = GetCurrentMapContinent()
	local tx, ty = GetPlayerMapPosition(target_unit)
	if (tx == 0 and ty == 0) or (px == 0 and py == 0) then return -1 end
	if GetCurrentMapZone() > 0 then SetMapZoom(continent) end
	local mapFileName, textureHeight, textureWidth = GetMapInfo()
	local xdelta = ((tx-px) * textureWidth)   * 1.47167
	local ydelta = ((ty-py) * textureHeight)
	local distance
	if  continent == 2 then
		distance = sqrt(xdelta*xdelta + ydelta*ydelta) * 11.65
	elseif continent == 1 then
		distance = sqrt(xdelta*xdelta + ydelta*ydelta) * 12.13
	else
		return -1
	end
	return (math.floor(distance*100)/100)
end

function AQ_BuffBot_IsInRange(unit)
	local cheapRangeCheck = false;
	if ( unit == "player" ) then
		return true;
	end
	if ( AutoTravel_GetCurrentPosition ) or ( YardDistance ) then
		-- AutoTravel is nice and fast, as is MapLibrary
		cheapRangeCheck = true;
	end
	if ( AQ_BuffBot_Options.opt.ignoreRange ) then
		return true;
	end
	local range = -1;
	local didUpdate = false;
	if ( not AQ_BuffBot_Map_Updated_Since_Change ) or ( cheapRangeCheck ) then
		didUpdate = true;
		range = AQ_BuffBot_RangeToUnit(unit);
		AQ_BuffBot_Map_Updated_Since_Change = true;
	end
	if ( range == -1 ) and ( didUpdate ) and ( AQ_BuffBot_Options.alwaysInRangeInInstances ) then
		return true;
	end
	if ( ( AQ_BuffBot_Options.opt.checkPresentBuffsWhenNoRange ) and ( range == -1 ) ) or 
		( ( AQ_BuffBot_Options.opt.onlyBuffIfBuffsArePresent ) and ( not didUpdate ) ) then
		if ( _In_Instance ) and ( AQ_BuffBot_Options.opt.overridePresentBuffsInInstances ) then
			return true;
		end
		local b = UnitBuff(unit, 1);
		if ( not b ) then
			b = UnitDebuff(unit, 1);
		end
		if ( b ) then
			return true;
		else
			return false;
		end
	end
	if ( not didUpdate ) then
		range = AQ_BuffBot_RangeToUnit(unit);
	end
	if ( range < 29 ) then
		return true;
	else
		return false;
	end
end

