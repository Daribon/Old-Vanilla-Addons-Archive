--[[

AutoTravel Glue AutoMount

This addon should allow AutoTravel to mount you up if you get dismounted.

]]--

ATGLUEAM_MIN_DISTANCE = 150;
ATGLUEAM_MOUNT_TIME = 5;

ATGLUEAM_UI_INFO_MOUNT_ERRORS = {
	ERR_MOUNT_ALREADYMOUNTED,
	ERR_MOUNT_FORCEDDISMOUNT,
	ERR_MOUNT_INVALIDMOUNTEE,
	ERR_MOUNT_LOOTING,
	ERR_MOUNT_NOTMOUNTABLE,
	ERR_MOUNT_NOTYOURPET,
	ERR_MOUNT_OTHER,
	ERR_MOUNT_RACECANTMOUNT,
	ERR_MOUNT_SHAPESHIFTED,
	ERR_MOUNT_TOOFARAWAY,
	SPELL_FAILED_NO_MOUNTS_ALLOWED,
	SPELL_FAILED_AFFECTING_COMBAT,
	SPELL_FAILED_CASTER_DEAD
};

AutoTravelGlueAutoMount_Default_Options = {
	noMountZones = {
		[ATGLUEAM_ZONE_NIGHTHAVEN] = 1;
	};
};
AutoTravelGlueAutoMount_Options = {};

AutoTravelGlueAutoMount_MountTime = nil;
AutoTravelGlueAutoMount_PausedIt = false;

function AutoTravelGlueAutoMount_Event_UIErrorMessage(msg)
	if ( not msg ) then
		return;
	end
	if ( msg == SPELL_FAILED_NO_MOUNTS_ALLOWED ) then
		if ( AutoTravelGlueAutoMount_PrevPoint ) then
			if ( not AutoTravelGlueAutoMount_Options.noMountPoints ) then
				AutoTravelGlueAutoMount_Options.noMountPoints = {};
			end
			AutoTravelGlueAutoMount_Options.noMountPoints[AutoTravelGlueAutoMount_PrevPoint] = 1;
		end
	end
	--if ( AutoTravelGlueAutoMount_MountTime ) and ( AutoTravelGlueAutoMount_MountTime > 0 ) then
	if ( AutoTravelGlueAutoMount_PausedIt ) then
		for k, v in ATGLUEAM_UI_INFO_MOUNT_ERRORS do
			if ( string.find(msg, v) ) then
				AutoTravelGlueAutoMount_CompleteWaitForMount();
				break;
			end
		end
	end
end

function AutoTravelGlueAutoMount_OnEvent(event)
	if ( event == "UI_ERROR_MESSAGE" ) then
		AutoTravelGlueAutoMount_Event_UIErrorMessage(arg1);
	end
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in AutoTravelGlueAutoMount_Default_Options do
			if ( AutoTravelGlueAutoMount_Options[k] == nil ) then
				AutoTravelGlueAutoMount_Options[k] = v;
			else
				local present = false;
				if ( type(v) == "table" ) then
					for key, value in v do
						if ( type(key) == "string" ) then
							if ( AutoTravelGlueAutoMount_Options[k][key] == nil ) then
								AutoTravelGlueAutoMount_Options[k][key] = value;
							end
						else
							present = false;
							for kkey, vvalue in AutoTravelGlueAutoMount_Options[k] do
								if ( vvalue == value ) then
									present = true;
									break;
								end
							end
							if ( not present ) then
								table.insert(AutoTravelGlueAutoMount_Options[k], value);
							end
						end
					end
				end
			end
		end
	end
end

function AutoTravelGlueAutoMount_OnMountingCompleted()
	AutoTravelAPI.Resume();
	AutoTravelGlueAutoMount_PausedIt = false;
end

function AutoTravelGlueAutoMount_TimeNeededToMount()
	return ATGLUEAM_MOUNT_TIME;
end

ATGLUEAM_STAGE_PAUSE = 1;
ATGLUEAM_STAGE_MOUNT = 2;
ATGLUEAM_STAGE_WAITFORMOUNT = 3;

ATGLUEAM_STAGE_ILLEGAL = 0;
AutoTravelGlueAutoMount_UpdateStage = ATGLUEAM_STAGE_ILLEGAL;


function AutoTravelGlueAutoMount_CanMount()
	if ( AutoTravelGlueAutoMount_IsShapeshifter() ) then
		if ( AutoTravelGlueAutoMount_IsShapeshifted() ) then
			return false;
		end
	end
	if ( PlayerFrame.inCombat ) then
		return false;
	end
	if ( UnitLevel("player") < 40 ) then
		return false;
	end
	if ( AutoMount_HasNoMount ) then
		return false;
	end
	if ( UnitIsDeadOrGhost("player") ) then
		return false;
	end
	if ( AutoTravelGlueAutoMount_Options.noMountZones ) then
		local zone = GetRealZoneText();
		if ( AutoTravelGlueAutoMount.noMountZones[zone] ) then
			return false;
		end
	end
	return true;
end

function AutoTravelGlueAutoMount_DoAutoMount()
	local dist = AutoTravelAPI.GetDistance();
	if ( AutoTravelGlueAutoMount_CanMount() ) and ( not AutoTravelGlueAutoMount_IsMounted() ) and ( dist ) and ( dist > ATGLUEAM_MIN_DISTANCE ) then
		--DEFAULT_CHAT_FRAME:AddMessage("Initiating mount procedure.");
		AutoTravelGlueAutoMount_UpdateStage = ATGLUEAM_STAGE_PAUSE;
		AutoTravelGlueAutoMountFrame:Show();
	else
		--DEFAULT_CHAT_FRAME:AddMessage("Already mounted, skipping all that work.");
		AutoTravelGlueAutoMount_AutoMountInProgress = false;
	end
end

AutoTravelGlueAutoMount_LastUpdate = nil;

function AutoTravelGlueAutoMount_CompleteWaitForMount()
	--DEFAULT_CHAT_FRAME:AddMessage("Mount-wait completed.");
	AutoTravelGlueAutoMount_BeforeMountCompleted();
	AutoTravelGlueAutoMountFrame:Hide();
	AutoTravelGlueAutoMount_OnMountingCompleted();
	AutoTravelGlueAutoMount_MountTime = nil;
	AutoTravelGlueAutoMount_AfterMountCompleted();
	AutoTravelGlueAutoMount_AutoMountInProgress = false;
	AutoTravelGlueAutoMount_UpdateStage = ATGLUEAM_STAGE_ILLEGAL;
end

function AutoTravelGlueAutoMount_OnUpdate(elapsed)
	if ( AutoTravelGlueAutoMount_MountTime ) then
		AutoTravelGlueAutoMount_MountTime = AutoTravelGlueAutoMount_MountTime - elapsed;
	end
	local curTime = GetTime();
	if ( AutoTravelGlueAutoMount_LastUpdate ) and ( curTime - AutoTravelGlueAutoMount_LastUpdate <= 0.2 ) then
		return;
	end
	
	if ( AutoTravelGlueAutoMount_UpdateStage == ATGLUEAM_STAGE_PAUSE ) then
		--DEFAULT_CHAT_FRAME:AddMessage("Pausing AutoTravel for mounting.");
		AutoTravelAPI.Pause();
		AutoTravelGlueAutoMount_PausedIt = true;
		AutoTravelGlueAutoMount_UpdateStage = ATGLUEAM_STAGE_MOUNT;
	elseif ( AutoTravelGlueAutoMount_UpdateStage == ATGLUEAM_STAGE_MOUNT ) then
		if ( AutoTravelGlueAutoMount_DoMount() ) then
			--DEFAULT_CHAT_FRAME:AddMessage("Mounting initiated.");
			AutoTravelGlueAutoMount_MountTime = AutoTravelGlueAutoMount_TimeNeededToMount();
			AutoTravelGlueAutoMount_UpdateStage = ATGLUEAM_STAGE_WAITMOUNT;
		else
			AutoTravelGlueAutoMount_MountTime = nil;
			--DEFAULT_CHAT_FRAME:AddMessage(ATGLUEAM_ERR_MOUNTING_FAILED, 1);
			AutoTravelGlueAutoMount_UpdateStage = ATGLUEAM_STAGE_ILLEGAL;
			AutoTravelGlueAutoMountFrame:Hide();
			AutoTravelGlueAutoMount_AutoMountInProgress = false;
			AutoTravelAPI.Resume();
		end
	elseif ( AutoTravelGlueAutoMount_UpdateStage == ATGLUEAM_STAGE_WAITMOUNT ) then
		if ( not AutoTravelGlueAutoMount_MountTime ) or ( AutoTravelGlueAutoMount_MountTime <= 0 ) then
			AutoTravelGlueAutoMount_CompleteWaitForMount();
		end
	else
		AutoTravelGlueAutoMountFrame:Hide();
		AutoTravelGlueAutoMount_MountTime = nil;
	end
	
	AutoTravelGlueAutoMount_LastUpdate = curTime;
end

AutoTravelGlueAutoMount_OldMountItemBagSlot = nil;

function AutoTravelGlueAutoMount_GetMountItemName()
	if ( not AutoMount_Mount ) then
		local itemName = nil;
		for i = 0, 4, 1 do
			local numSlot = GetContainerNumSlots(i);
			for y = 1, numSlot, 1 do
				itemName = AutoMount_GetItemName(i, y)
				for k, v in AutoMount_Mount_Items do
					if (itemName == v) then
						AutoMount_Mount = v;
						return AutoMount_Mount, i, y;
					end
				end
			end
		end
	end
	return AutoMount_Mount;
end


function AutoTravelGlueAutoMount_GetMountItemBagSlot(noLoop)
	local itemName, bag, slot = AutoTravelGlueAutoMount_GetMountItemName();
	if ( not itemName ) then
		return nil, nil;
	end 
	if ( bag ) and ( slot ) then
		if ( not AutoTravelGlueAutoMount_OldMountItemBagSlot ) then
			AutoTravelGlueAutoMount_OldMountItemBagSlot = {};
		end
		AutoTravelGlueAutoMount_OldMountItemBagSlot.bag = bag;
		AutoTravelGlueAutoMount_OldMountItemBagSlot.slot = slot;
		return bag, slot;
	end
	if ( AutoTravelGlueAutoMount_OldMountItemBagSlot ) then
		local arr = AutoTravelGlueAutoMount_OldMountItemBagSlot;
		if (AutoMount_GetItemName(arr.bag, arr.slot) == itemName) then
			return arr.bag, arr.slot;
		end
	end
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (AutoMount_GetItemName(i, y) == itemName) then
				if ( not AutoTravelGlueAutoMount_OldMountItemBagSlot ) then
					AutoTravelGlueAutoMount_OldMountItemBagSlot = {};
				end
				AutoTravelGlueAutoMount_OldMountItemBagSlot.bag = i;
				AutoTravelGlueAutoMount_OldMountItemBagSlot.bag = y;
				return i, y;
			end
		end
	end
	AutoMount_Mount = nil;
	if ( not noLoop ) then
		return AutoTravelGlueAutoMount_GetMountItemBagSlot(true);
	end
	return nil, nil;
end

AutoTravelGlueAutoMount_IsShapeshifted_Effects_List = {};

ATGAM_SHAPESHIFT_ICONS		= {
	"Interface\\Icons\\Ability_Druid_CatForm",
	"Interface\\Icons\\Ability_Druid_TravelForm",
	"Interface\\Icons\\Ability_Racial_BearForm",
	"Interface\\Icons\\Ability_Druid_AquaticForm",
	"Interface\\Icons\\Spell_Nature_SpiritWolf",
};

ATGLUEAM_CLASS_SHAPESHIFTERS		= {
	ATGLUEAM_CLASS_DRUID,
	ATGLUEAM_CLASS_SHAMAN,
};

AutoTravelGlueAutoMount_IsShapeshifter_Value = nil;

function AutoTravelGlueAutoMount_IsShapeshifter()
	if ( AutoTravelGlueAutoMount_IsShapeshifter_Value ~= nil ) then
		return AutoTravelGlueAutoMount_IsShapeshifter_Value;
	end
	AutoTravelGlueAutoMount_IsShapeshifter_Value = AutoTravelGlueAutoMount_IsUnitShapeshifter("player");
	return AutoTravelGlueAutoMount_IsShapeshifter_Value;
end

function AutoTravelGlueAutoMount_IsUnitShapeshifter(unit)
	local class = UnitClass(unit);
	if ( not class ) or ( class == UKNOWNBEING ) or ( class == UNKNOWN ) or ( class == UNKNOWNOBJECT ) then
		return nil;
	end
	for k, v in ATGLUEAM_CLASS_SHAPESHIFTERS do
		if ( v == class ) then
			return true;
		end
	end
	return false;
end

function AutoTravelGlueAutoMount_IsShapeshifted()
	local list = AutoTravelGlueAutoMount_IsShapeshifted_Effects_List;
	for i = 0, 15 do
		list[i] = GetPlayerBuffTexture(i);
	end
	for k, v in ATGAM_SHAPESHIFT_ICONS do
		for key, effect in list do
			if ( effect == v ) then
				return true;
			end
		end
	end
	return false;
end

function AutoTravelGlueAutoMount_IsMounted()
	for i = 0, 15 do
		if not AutoMount_Texture then
			for j = 1, table.getn(AutoMount_Mount_List) do
				if GetPlayerBuffTexture(i) ~= nil then
					if (string.find(GetPlayerBuffTexture(i),AutoMount_Mount_List[j])) then
						AutoMount_Texture = GetPlayerBuffTexture(i);
						return true;
					end
				end
			end
		else
			if GetPlayerBuffTexture(i) == AutoMount_Texture then
				return true;
			end
		end
	end
	return false;
end

function AutoTravelGlueAutoMount_DoMount()
	AutoTravelGlueAutoMount_BeforeMountStarting();
	local bag, slot = AutoTravelGlueAutoMount_GetMountItemBagSlot();
	local ok = false;
	if ( bag ) and ( slot ) then
		UseContainerItem(bag, slot);
		ok = true;
	end
	AutoTravelGlueAutoMount_AfterMountStarting();
	return ok;
end

AutoTravelGlueAutoMount_AutoMountInProgress = false;

AutoTravelGlueAutoMount_PrevPoint = nil;
AutoTravelGlueAutoMount_NextPoint = nil;


function AutoTravelGlueAutoMount_OnStop()
	--AddOnHelper_Print("OnStop!");
end

function AutoTravelGlueAutoMount_OnStart()
	AutoTravelGlueAutoMount_PrevPoint = AutoTravelGlueAutoMount_NextPoint;
	AutoTravelGlueAutoMount_NextPoint = nil;
	if ( ATStatus ) and ( ATStatus.path ) and ( ATStatus.path[1].point ) then
		AutoTravelGlueAutoMount_NextPoint = ATStatus.path[1].point;
	end
end

function AutoTravelGlueAutoMount_OnWaypointReached()
	AutoTravelGlueAutoMount_PrevPoint = AutoTravelGlueAutoMount_NextPoint;
	AutoTravelGlueAutoMount_NextPoint = nil;
	if ( ATStatus ) and ( ATStatus.path ) and ( ATStatus.path[1] ) then
		AutoTravelGlueAutoMount_NextPoint = ATStatus.path[1].point;
	end
	if ( not AutoTravelGlueAutoMount_AutoMountInProgress ) then
		local noMountPoints = AutoTravelGlueAutoMount_Options.noMountPoints;
		if ( not AutoTravelGlueAutoMount_PrevPoint ) or ( not noMountPoints ) or ( not noMountPoints[AutoTravelGlueAutoMount_PrevPoint] ) then
			AutoTravelGlueAutoMount_AutoMountInProgress = true;
			AutoTravelGlueAutoMount_DoAutoMount();
		end
	end
end


function AutoTravelGlueAutoMount_Init()
	if ( not AutoTravelGlueAutoMount_InitDone ) and ( AutoTravelAPI.RegisterEvent ) then
		AutoTravelAPI.RegisterEvent("OnStart", AutoTravelGlueAutoMount_OnStart);
		AutoTravelAPI.RegisterEvent("OnStop", AutoTravelGlueAutoMount_OnStop);
		AutoTravelAPI.RegisterEvent("OnWaypointReached", AutoTravelGlueAutoMount_OnWaypointReached);
		this:RegisterEvent("UI_ERROR_MESSAGE");
		AutoTravelGlueAutoMount_InitDone = true;
	end
end


function AutoTravelGlueAutoMount_OnLoad()
	AutoTravelGlueAutoMount_Init();
	
	local name = "ATGLUEAMSLASHMAIN";
	SlashCmdList[name] = AutoTravelGlueAutoMount_Main_SlashCommand;
	for k, v in ATGLUEAM_SLASH_CMDS do
		setglobal(name..k, v);
	end
end

function AutoTravelGlueAutoMount_Main_SlashCommand(msg)
	local cmd = ATGLUEAM_CMD_ZONE;
	local index = string.find(msg, cmd);
	if ( index ) then
		local zone = string.sub(msg, index+strlen(cmd));
		if ( zone ) and ( strlen(zone) > 0 ) and ( DEFAULT_CHAT_FRAME ) then
			local action = ATGLUEAM_CHAT_ADDEDZONE;
			if ( AutoTravelGlueAutoMount_Options.noMountZones[zone] ) then
				action = ATGLUEAM_CHAT_REMOVEDZONE;
				AutoTravelGlueAutoMount_Options.noMountZones[zone] = nil;
			else
				AutoTravelGlueAutoMount_Options.noMountZones[zone] = 1;
			end
			DEFAULT_CHAT_FRAME:AddMessage(string.format(ATGLUEAM_CHAT_ZONE, zone, action));
			return;
		end
	end
	if ( DEFAULT_CHAT_FRAME ) then
		for k, v in ATGLUEAM_CHAT_USAGE do
			DEFAULT_CHAT_FRAME:AddMessage(v);
		end
	end
end

-- hook these if you want

function AutoTravelGlueAutoMount_BeforeMountStarting()
end

function AutoTravelGlueAutoMount_AfterMountStarting()
end


function AutoTravelGlueAutoMount_BeforeMountCompleted()
end

function AutoTravelGlueAutoMount_AfterMountCompleted()
end

if ( not AutoMount_GetItemName ) then
	function AutoMount_GetItemName(bag, slot)
		local bagNumber = bag;
		if ( type(bagNumber) ~= "number" ) then
			bagNumber = tonumber(bag);
		end
		if (bagNumber <= -1) then
			GameTooltip:SetInventoryItem("player", slot);
		else
			GameTooltip:SetBagItem(bag, slot);
		end
		return GameTooltipTextLeft1:GetText();
	end
end

if ( not AutoMount_Mount_List ) then
AutoMount_Mount_List ={
"Spell_Nature_Swiftness",
"Ability_Mount",
"INV_Misc_Foot_Kodo",
};
end;
	
if ( not AutoMount_Mount_Items ) then
AutoMount_Mount_Items={
"Black Ram",
"Brown Ram",
"Frost Ram",
"Gray Ram",
"Swift Brown Ram",
"Swift Gray Ram",
"Swift White Ram",
"White Ram",
"Blue Mechanostrider",
"Green Mechanostrider",
"Icy Blue Mechanostrider Mod A",
"Red Mechanostrider",
"Swift Green Mechanostrider",
"Swift White Mechanostrider",
"Swift Yellow Mechanostrider",
"Unpainted Mechanostrider",
"White Mechanostrider Mod A",
"Black Stallion Bridle",
"Brown Horse Bridle",
"Chestnut Mare Bridle",
"Palomino Bridle",
"Pinto Bridle",
"White Stallion Bridle",
"Reins of the Frostsaber",
"Reins of the Nightsaber",
"Reins of the Spotted Frostsaber",
"Reins of the Striped Frostsaber",
"Reins of the Striped Nightsaber",
"Reins of the Swift Frostsaber",
"Reins of the Swift Mistsaber",
"Reins of the Swift Stormsaber",
"Reins of the Winterspring Frostsaber",
"Reins of the Bengal Tiger",
"Reins of the Leopard",
"Reins of the Night Saber",
"Reins of the Spotted Panther",
"Deathcharger's Reins",
"Blue Skeletal Horse",
"Brown Skeletal Horse",
"Green Skeletal Warhorse",
"Red Skeletal Horse",
"Brown Kodo",
"Gray Kodo",
"Great Brown Kodo",
"Great Gray Kodo",
"Great White Kodo",
"Green Kodo",
"Teal Kodo",
"Swift Blue Raptor",
"Swift Green Raptor",
"Swift Orange Raptor",
"Whistle of the Emerald Raptor",
"Whistle of the Ivory Raptor",
"Whistle of the Mottled Red Raptor",
"Whistle of the Turquoise Raptor",
"Whistle of the Violet Raptor",
"Horn of the Arctic Wolf",
"Horn of the Brown Wolf",
"Horn of the Dire Wolf",
"Horn of the Red Wolf",
"Horn of the Swift Brown Wolf",
"Horn of the Swift Gray Wolf",
"Horn of the Swift Timber Wolf",
"Horn of the Timber Wolf",
"Horn of the Winter Wolf",
"Horn of the Black Wolf",
"Horn of the Gray Wolf",
}
end

