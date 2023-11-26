CT_RABoss_ScheduledActions = { };
CT_RABoss_Events = { };
CT_RABoss_Mods = { };
CT_RABoss_Save = { };
CT_RABoss_DropDown = { };
local hasLoadedVars;

CT_RABoss_Locations = {
	{ CT_RABOSS_LOCATIONS_MOLTENCORE, 0 }, { CT_RABOSS_LOCATIONS_BLACKWINGSLAIR, 0 }, { CT_RABOSS_LOCATIONS_ONYXIASLAIR, 0 }, { CT_RABOSS_LOCATIONS_ZULGURUB, 0 }, { CT_RABOSS_LOCATIONS_OUTDOOR, 0 }, { CT_RABOSS_LOCATIONS_OTHER, 0 }
};

-- Function to schedule a function
function CT_RABoss_Schedule(name, timeUntil, optParam)
	tinsert(CT_RABoss_ScheduledActions, { name, GetTime()+timeUntil, optParam });
end

-- Function to unschedule all functions where the first index is "name"
function CT_RABoss_UnSchedule(name, optParam)
	for k, v in CT_RABoss_ScheduledActions do
		if ( v[1] == name and ( not optParam or v[3] == optParam ) ) then
			tremove(CT_RABoss_ScheduledActions, k);
		end
	end
end

-- Function to process scheduled actions
function CT_RABoss_OnUpdate(elapsed)
	this.elapsed = this.elapsed + elapsed;
	if ( this.elapsed > 0.1 ) then
		for k, v in CT_RABoss_ScheduledActions do
			if ( GetTime() >= v[2] ) then
				getglobal(v[1])(v[3]);
				tremove(CT_RABoss_ScheduledActions, k);
			end
		end
		this.elapsed = this.elapsed - 0.1;
	end
end

-- Handles all the events
function CT_RABoss_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		hasLoadedVars = 1;
		-- Remove mods that are no longer loaded
		
		-- Add new mods that aren't saved yet
		for k, v in CT_RABoss_Save do
			if ( CT_RABoss_Mods[k] ) then
				for key, val in v do
					CT_RABoss_Mods[k][key] = val;
				end
			else
				CT_RABoss_Save[k] = nil;
			end
		end
	end
	
	for k, v in CT_RABoss_Events do
		if ( v[event] ) then
			v[event](event);
		end
	end
end

-- Add event
function CT_RABoss_AddEvent(modName, event, func)
	if ( not CT_RABoss_Events[modName] ) then
		CT_RABoss_Events[modName] = { };
	end
	CT_RABoss_Events[modName][event] = func;
	this:RegisterEvent(event);
end

-- Add mod
function CT_RABoss_AddMod(modName, modDescript, modStatus, modLocation)
	if ( not modLocation ) then
		modLocation = "Other";
	end
	
	local found;
	for k, v in CT_RABoss_Locations do
		if ( v[1] == modLocation ) then
			found = 1;
			break;
		end
	end
	if ( not found ) then
		tinsert(CT_RABoss_Locations, { modLocation, 0 });
	end
	CT_RABoss_Save[modName] = { ["status"] = modStatus };
	CT_RABoss_Mods[modName] = { ["status"] = modStatus, ["descript"] = modDescript, ["location"] = modLocation };
end

-- Enable/Disable mod
function CT_RABoss_EnableMod()
	CT_RABoss_Mods[this.value]["status"] = not CT_RABoss_Mods[this.value]["status"];
	CT_RABoss_Save[this.value]["status"] = not CT_RABoss_Mods[this.value]["status"];
	CT_RAMenuBoss_Update();
end

-- Get mod info
function CT_RABoss_ModInfo(modName, modVar)
	if ( CT_RABoss_Mods[modName] and CT_RABoss_Mods[modName][modVar] ) then
		if ( type(CT_RABoss_Mods[modName][modVar]) or CT_RABoss_Mods[modName][modVar] ~= 0 ) then
			return 1;
		end
	end
end

-- Set mod info
function CT_RABoss_SetInfo()
	CT_RABoss_SetVar(this.value[1], this.value[2], not CT_RABoss_Mods[this.value[1]][this.value[2]]);
end

function CT_RABoss_SetVar(modName, modVar, modValue)
	CT_RABoss_Mods[modName][modVar] = modValue;
	if ( not CT_RABoss_Save[modName] ) then
		CT_RABoss_Save[modName] = { };
	end
	CT_RABoss_Save[modName][modVar] = modValue;
	if ( CT_RAMenuBoss_Update ) then
		CT_RAMenuBoss_Update();
	end
end

-- Add dropdown buttons
function CT_RABoss_AddDropDownButton(modName, btnDesc, btnVar, btnParams, btnSetFunc)
	if ( not CT_RABoss_DropDown[modName] ) then
		CT_RABoss_DropDown[modName] = { };
	end
	tinsert( CT_RABoss_DropDown[modName], { btnDesc, btnVar, btnParams, btnSetFunc } );
end

-- Announce function
function CT_RABoss_Announce(msg, fullRaid)
	if ( fullRaid and CT_RA_Level >= 1 ) then
		CT_RA_AddMessage("MS " .. msg);
		SendChatMessage(msg, "RAID");
	end
	CT_RA_WarningFrame:AddMessage(msg, 1, 1, 1, 1, UIERRORS_HOLD_TIME);
end

function CT_RABoss_OnLoad()
	this.elapsed = 0;
	this:RegisterEvent("VARIABLES_LOADED");
end