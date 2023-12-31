--[[

	Name:		MobHealth2
	Version:	2.6
	Author:		Wyv (wyv@wp.pl)
	Description:	Displays health value for mobs.
	Original version by Telo.
	Cosmos integration and localization support by Sparkz (sollie@gmail.com)
	$Id: MobHealth.lua 2056 2005-07-07 05:36:23Z AlexYoshi $
	
	URL:		http://www.curse-gaming.com/mod.php?addid=1087
			http://ui.worldofwar.net/ui.php?id=681
			http://www.wowinterface.com/downloads/fileinfo.php?id=3938
			
]]

-- Current target data
local lTargetData;

-- table of event handlers
local lEventHandler = {};

local COLOR_BLUE	= "|c009090FF";
local COLOR_WHITE	= "|c00FFFFFF";
local TITLE		= "|c003060FFMobHealth2"..COLOR_WHITE;

--------------------------------------------------------------------------------------------------
-- external functions for macros / scripts
--   - return value:
--     * (current hp or max hp) if a mob is selected and it's health is known
--     * 0 otherwise
--------------------------------------------------------------------------------------------------

function MobHealth_GetTargetCurHP()
	if ( lTargetData ) then
		return math.floor(lTargetData.currentHealthPercent * lTargetData.PPP + 0.5);
	end	
end

function MobHealth_GetTargetMaxHP()
	if ( lTargetData ) then
		return math.floor(100 * lTargetData.PPP + 0.5);
	end		
end

--------------------------------------------------------------------------------------------------
-- external functions for macros / scripts
--   - return value:
--     curHP, maxHP = MobHealth_GetUnitHP(unit)
--     curHP and maxHP equal 0 if unknown
--     (for unit = "target" or unit = "mouseover" etc.)
--     (please use MobHealth_GetTargetCurHP / MaxHP if you are always intrested in unit="target"
--     (they are faster)
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Internal functions
--   - all MobHealthDB access functions are left intact for compatiblity
--   - MobHealth is no longer local (but it's not a recomended way to access mob health - even tho
--     it's better than using MobHealthDB directly)
--------------------------------------------------------------------------------------------------

function MobHealth_PPP(index)
	if ( index and MobHealthDB[index] ) then
		local s, e;
		local pts;
		local pct;
		
		s, e, pts, pct = string.find(MobHealthDB[index], "^(%d+)/(%d+)$");
		if ( pts and pct ) then
			pts = pts + 0;
			pct = pct + 0;
			if ( pct ~= 0 ) then
				return pts / pct;
			end
		end
	end
	return 0;
end

local function MobHealth_Pts(index)
	if ( index and MobHealthDB[index] ) then
		local s, e;
		local val;
		
		s, e, val = string.find(MobHealthDB[index], "^(%d+)/");
		
		if ( val ) then
			return val + 0;
		end
	end
	return 0;
end

local function MobHealth_Pct(index)
	if ( index and MobHealthDB[index] ) then
		local s, e;
		local val;
		
		s, e, val = string.find(MobHealthDB[index], "/(%d+)$");
		
		if ( val ) then
			return val + 0;
		end
	end
	return 0;
end

local function MobHealth_Set(index, pts, pct)
	if ( index ) then
		if ( pts ) then
			pts = pts + 0;
		else
			pts = 0;
		end
		if ( pct ) then
			pct = pct + 0;
		else
			pct = 0;
		end
		if ( pts == 0 and pct == 0 ) then
			MobHealthDB[index] = nil;
		else
			MobHealthDB[index] = pts.."/"..pct;
		end
	end
end



local function MobHealthPlayer_Pts(index)
	if ( index and MobHealthPlayerDB[index] ) then
		local s, e;
		local val;
		
		s, e, val = string.find(MobHealthPlayerDB[index], "^(%d+)/");
		
		if ( val ) then
			return val + 0;
		end
	end
	return 0;
end

local function MobHealthPlayer_Pct(index)
	if ( index and MobHealthPlayerDB[index] ) then
		local s, e;
		local val;
		
		s, e, val = string.find(MobHealthPlayerDB[index], "/(%d+)$");
		
		if ( val ) then
			return val + 0;
		end
	end
	return 0;
end

local function MobHealthPlayer_Set(index, pts, pct)
	if ( index ) then
		if ( pts ) then
			pts = pts + 0;
		else
			pts = 0;
		end
		if ( pct ) then
			pct = pct + 0;
		else
			pct = 0;
		end
		if ( pts == 0 and pct == 0 ) then
			MobHealthPlayerDB[index] = nil;
		else
			MobHealthPlayerDB[index] = pts.."/"..pct;
		end
	end
end

local function MobHealth_Display(currentPct, index)
	local field = getglobal("MobHealthText");
	local text = "";
	
	if ( field ) then
		if ( lTargetData and lTargetData.PPP > 0 ) then
			local maxhp;
			if (not MobHealthConfig["unstablemax"] and lTargetData.maxHP) then
				maxhp = lTargetData.maxHP;
			else
				maxhp = (100 * lTargetData.PPP) + 0.5;
			end
			if ( currentPct ) then
				text = string.format("%d / %d", (currentPct * lTargetData.PPP) + 0.5, maxhp);
			else
				text = string.format("??? / %d", maxhp);
			end

		end
		field:SetText(text);
	end
end

function MobHealth_SetPos(pos, show)
  MobHealthFrame:SetPoint("TOP", "TargetFrameHealthBar", "BOTTOM", -2, tonumber(pos) );
  MobHealthConfig["position"] = arg1;
  if (show) then
		DEFAULT_CHAT_FRAME:AddMessage(TITLE..TEXT(MOBHEALTH_CHAT_COMMAND_SETPOS)..pos);
  end
end

local function MobHealth_VariablesLoaded()
	if (not MobHealthDB ) then
		MobHealthDB = { };
	else
		local index, value;
		
		for index, value in MobHealthDB do
			-- Convert the old-style data into the newer, more compact form
			if( type(value) == "table" ) then
				MobHealth_Set(index, value.damPts, value.damPct);
			end
		end
	end
	
	if (not MobHealthConfig ) then
		MobHealthConfig = {};
	elseif (MobHealthConfig["position"]) then
		MobHealth_SetPos(MobHealthConfig["position"]);
	end

	if (not MobHealthPlayerDB) then
		MobHealthPlayerDB = {};
	end

end

function MobHealth_Reset()
	DEFAULT_CHAT_FRAME:AddMessage(TITLE..TEXT(MOBHEALTH_CHAT_COMMAND_RESETDB));
	MobHealthDB = {};
	MobHealthConfig = {};
	MobHealthPlayerDB = {}; -- this is not saved variable
end

function MobHealth_ClearTargetData()
	if (lTargetData) then
		DEFAULT_CHAT_FRAME:AddMessage(TITLE..TEXT(MOBHEALTH_CHAT_COMMAND_RESETDATA)..lTargetData.index);
		lTargetData.PPP = 0;
		lTargetData.firstBattle = true;
		lTargetData.totalDamagePoints = 0;
		lTargetData.totalChangeHP = 0;
		lTargetData.maxHP = nil;

		MobHealth_Display(nil, nil);

		if (lTargetData.mob) then
			MobHealthDB[lTargetData.index] = nil;
		else
			MobHealthPlayerDB[lTargetData.index] = nil;
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(TITLE.." no target with hp information in DB found.");
	end

end


function MobHealth_ChatCommandHandler(msg)
	local _, _, cmd, arg1 = string.find(msg, "(%w+)[ ]?([-%w]*)"); 

	if (cmd == "pos") then
		if (arg1 ~= "") then
			MobHealth_SetPos(arg1, true);
		else
			DEFAULT_CHAT_FRAME:AddMessage(TEXT(MOBHEALTH_CHAT_COMMAND_HELP_POS));
		end
	elseif (cmd == "stablemax") then
		MobHealthConfig["unstablemax"] = nil;
		DEFAULT_CHAT_FRAME:AddMessage(TITLE..TEXT(MOBHEALTH_CHAT_COMMAND_STABLEMAX));
	elseif (cmd == "unstablemax") then
		MobHealthConfig["unstablemax"] = true;
		DEFAULT_CHAT_FRAME:AddMessage(TITLE..TEXT(MOBHEALTH_CHAT_COMMAND_UNSTABLEMAX));
	elseif (cmd == "reset" and arg1 == "all") then
		MobHealth_Reset();
	elseif (cmd == "reset" or cmd == "del" or cmd == "delete" or cmd == "rem" or cmd == "remove" or cmd == "clear") then
		MobHealth_ClearTargetData();
	else
		DEFAULT_CHAT_FRAME:AddMessage(TITLE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_1));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_BLUE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_2));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_3));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_4));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_BLUE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_5));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_6));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_7));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_BLUE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_8));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_9));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_BLUE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_10));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_11));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_BLUE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_12));
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..TEXT(MOBHEALTH_CHAT_COMMAND_HELPTEXT_13));
	end
end

function MobHealth_SaveTargetData()
	if (lTargetData) then
		if( lTargetData.PPP > 0 and lTargetData.totalChangeHP < 10000 ) then
			if (lTargetData.mob) then
				MobHealth_Set(lTargetData.index, lTargetData.totalDamagePoints, lTargetData.totalChangeHP);
			else
				MobHealthPlayer_Set(lTargetData.index, lTargetData.totalDamagePoints, lTargetData.totalChangeHP);
			end
		end
	end	
end

--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------

function MobHealth_OnLoad()
	for key,value in lEventHandler do
		--DEFAULT_CHAT_FRAME:AddMessage("Registering "..key);
		this:RegisterEvent(key);
	end
	
	MobHealth_Register();
end

function MobHealth_OnEvent(event)
	-- DEFAULT_CHAT_FRAME:AddMessage("Event: "..event)
	if (lEventHandler[event]) then
		lEventHandler[event](arg1, arg2, arg3, arg4);
	end
end

--------------------------------------------------------------------------------------------------
-- Register functions
--------------------------------------------------------------------------------------------------

function MobHealth_Register()
  if ( Khaos ) then 
	MobHealth_Register_Cosmos();
  elseif ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		MobHealth_Register_Cosmos();
	else
	  SlashCmdList["MOBHEALTH"] = MobHealth_ChatCommandHandler;
	  SLASH_MOBHEALTH1 = "/mobhealth";
	end
	
	if ( Cosmos_RegisterChatCommand ) then
		local MobHealthCommands = {"/mobhealth"};
		Cosmos_RegisterChatCommand (
			"MOBHEALTH_COMMANDS", -- Some Unique Group ID
			MobHealthCommands, -- The Commands
			MobHealth_ChatCommandHandler,
			MOBHEALTH_CHAT_COMMAND_INFO -- Description String
		);
	end
end

--------------------------------------------------------------------------------------------------
-- Event handlers
--------------------------------------------------------------------------------------------------

lEventHandler["VARIABLES_LOADED"] = function ()
	MobHealth_VariablesLoaded();	
end

lEventHandler["UNIT_HEALTH"] = function ()
	--DEFAULT_CHAT_FRAME:AddMessage("MobHealth_Enabled = "..MobHealth_Enabled);
	if (MobHealth_Enabled == 0) then
		return;
	end
	
	if (arg1 == "target") then
		MobHealth_Display(nil, nil);
		if( lTargetData ) then
			local health = UnitHealth("target");
			if( health and health ~= 0 ) then
				local change = lTargetData.currentHealthPercent - health;
				local damage = lTargetData.tempDamagePoints;
				if( change > 0 and damage > 0 ) then
					lTargetData.totalDamagePoints = lTargetData.totalDamagePoints + damage;
					lTargetData.totalChangeHP = lTargetData.totalChangeHP + change;

					if( lTargetData.totalChangeHP ~= 0 and lTargetData.totalDamagePoints ~= 0 ) then
						lTargetData.PPP = lTargetData.totalDamagePoints / lTargetData.totalChangeHP;
					end

					if (lTargetData.firstBattle) then
						-- this is needed for other addons reading directly from DB
						MobHealth_SaveTargetData()
					end

					lTargetData.tempDamagePoints = 0;

				elseif ( change ~= 0 ) then -- could be negative so let's be safe
					lTargetData.tempDamagePoints = 0;
				end

				lTargetData.currentHealthPercent = health;

				MobHealth_Display(health, lTargetData.index);
			end
		end
	end
end

lEventHandler["UNIT_COMBAT"] = function ()
	if( lTargetData and arg1 == "target" ) then
		lTargetData.tempDamagePoints = lTargetData.tempDamagePoints + arg4;
	end
end

lEventHandler["PLAYER_TARGET_CHANGED"] = function ()
	if (MobHealth_Enabled == 0) then
		return;
	end
	
	if (lTargetData) then
		-- we have old target, so we should update it's HP in database
		MobHealth_SaveTargetData();
	end

	local name = UnitName("target");
	if( name ) then
		if( UnitCanAttack("player", "target") and not UnitIsDead("target") and not UnitIsFriend("player", "target") ) then
			-- Attackable, alive, non-player target
			lTargetData = { };
			lTargetData.name = name;
			lTargetData.level = UnitLevel("target");
			lTargetData.currentHealthPercent = UnitHealth("target");
			lTargetData.tempDamagePoints = 0;

			if (UnitIsPlayer("target") ) then
				lTargetData.player = true;
				lTargetData.index = lTargetData.name;
				lTargetData.totalDamagePoints = MobHealthPlayer_Pts(lTargetData.index);
				lTargetData.totalChangeHP = MobHealthPlayer_Pct(lTargetData.index);
			else
				lTargetData.mob = true;
				lTargetData.index = lTargetData.name..":"..lTargetData.level;
				lTargetData.totalDamagePoints = MobHealth_Pts(lTargetData.index);
				lTargetData.totalChangeHP = MobHealth_Pct(lTargetData.index);
			end

			
			if( lTargetData.totalChangeHP ~= 0 and lTargetData.totalDamagePoints ~= 0 ) then
				lTargetData.PPP = lTargetData.totalDamagePoints / lTargetData.totalChangeHP;
			else
				lTargetData.PPP = 0;
			end

			if (lTargetData.totalChangeHP == 0) then
				-- first battle with mob/player
				lTargetData.firstBattle = true;
			else
				lTargetData.maxHP = math.floor(lTargetData.PPP * 100 + 0.5);
			end

			MobHealth_Display(lTargetData.currentHealthPercent, lTargetData.index);
			return;
		end
	end

	-- Unusable target
	lTargetData = nil;
	
	MobHealth_Display(nil, nil);
end

