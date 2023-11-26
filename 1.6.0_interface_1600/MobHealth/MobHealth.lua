--[[

	MobHealth: A database of estimated creature health values, with display
		copyright 2004 by Telo
	
	- Displays the estimated current and maximum health values of your target
	- Continually updates its estimates for each creature's health as you play
	
]]

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Combat events
local lCombatEvents = {
	"CHAT_MSG_COMBAT_ERROR",
	"CHAT_MSG_COMBAT_MISC_INFO",
	"CHAT_MSG_COMBAT_SELF_HITS",
	"CHAT_MSG_COMBAT_PET_HITS",
	"CHAT_MSG_COMBAT_PARTY_HITS",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS",
	"CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS",
	"CHAT_MSG_SPELL_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PET_DAMAGE",
	"CHAT_MSG_SPELL_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF",
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS",
	"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
};

-- Combat and spell patterns; order is important (your entries must come before other entries)
local lMatchData = {
	-- Your damage or healing
	{ pattern = "Your (.+) hits (.+) for (%d+)", spell = 0, mob = 1, pts = 2 },
	{ pattern = "Your (.+) crits (.+) for (%d+)", spell = 0, mob = 1, pts = 2 },
	{ pattern = "You drain (%d+) (.+) from (.+)", mob = 2, pts = 0, stat = 1 },
	{ pattern = "Your (.+) causes (.+) (%d+) damage", spell = 0, mob = 1, pts = 2 },
	{ pattern = "You reflect (%d+) (.+) damage to (.+)", mob = 2, pts = 0, type = 1 },
	{ pattern = "(.+) suffers (%d+) (.+) damage from your (.+)", spell = 3, mob = 0, pts = 1, type = 2 },
	{ pattern = "Your (.+) heals (.+) for (%d+)", mob = 1, spell = 0, pts = 2, heal = 1 },
	{ pattern = "Your (.+) critically heals (.+) for (%d+)", mob = 1, spell = 0, pts = 2, heal = 1 },
	{ pattern = "(.+) gains (%d+) health from your (.+)", spell = 2, mob = 0, pts = 1, heal = 1 },
	{ pattern = "You hit (.+) for (%d+)", mob = 0, pts = 1 },
	{ pattern = "You crit (.+) for (%d+)", mob = 0, pts = 1 },

	-- Other damage or healing
	{ pattern = "(.+)'s (.+) hits (.+) for (%d+)", spell = 1, mob = 2, pts = 3, cause = 0 },
	{ pattern = "(.+)'s (.+) crits (.+) for (%d+)", spell = 1, mob = 2, pts = 3, cause = 0 },
	{ pattern = "(.+) drains (%d+) (.+) from (.+)", mob = 3, pts = 1, stat = 2, cause = 0 },
	{ pattern = "(.+)'s (.+) causes (.+) (%d+) damage", spell = 1, mob = 2, pts = 3, cause = 0 },
	{ pattern = "(.+) reflects (%d+) (.+) damage to (.+)", mob = 3, pts = 1, type = 2, cause = 0 },
	{ pattern = "(.+) suffers (%d+) (.+) damage from (.+)'s (.+)", spell = 4, mob = 0, pts = 1, type = 2, cause = 3 },
	{ pattern = "(.+)'s (.+) heals (.+) for (%d+)", mob = 2, spell = 1, pts = 3, cause = 0, heal = 1 },
	{ pattern = "(.+)'s (.+) critically heals (.+) for (%d+)", mob = 2, spell = 1, pts = 3, cause = 0, heal = 1 },
	{ pattern = "(.+) gains (%d+) health from (.+)'s (.+)", spell = 3, mob = 0, pts = 1, cause = 2, heal = 1 },
	{ pattern = "(.+) hits (.+) for (%d+)", mob = 1, pts = 2, cause = 0 },
	{ pattern = "(.+) crits (.+) for (%d+)", mob = 1, pts = 2, cause = 0 },
	
	-- Environmental damage
	{ pattern = "(.+) is drowning and loses (%d+) health", mob = 0, pts = 1 },
	{ pattern = "(.+) falls and loses (%d+) health", mob = 0, pts = 1 },
	{ pattern = "(.+) is exhausted and loses (%d+) health", mob = 0, pts = 1 },
	{ pattern = "(.+) suffers (%d+) points of fire damage", mob = 0, pts = 1 },
	{ pattern = "(.+) loses (%d+) health for swimming in (.+)", mob = 0, pts = 1 }, -- lava or slime
};

-- Current target data
local lTargetData;

--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

local function MobHealth_PPP(index)
	if( index and MobHealthDB[index] ) then
		local s, e;
		local pts;
		local pct;
		
		s, e, pts, pct = string.find(MobHealthDB[index], "^(%d+)/(%d+)$");
		if( pts and pct ) then
			pts = pts + 0;
			pct = pct + 0;
			if( pct ~= 0 ) then
				return pts / pct;
			end
		end
	end
	return 0;
end

local function MobHealth_Pts(index)
	if( index and MobHealthDB[index] ) then
		local s, e;
		local val;
		
		s, e, val = string.find(MobHealthDB[index], "^(%d+)/");
		
		if( val ) then
			return val + 0;
		end
	end
	return 0;
end

local function MobHealth_Pct(index)
	if( index and MobHealthDB[index] ) then
		local s, e;
		local val;
		
		s, e, val = string.find(MobHealthDB[index], "/(%d+)$");
		
		if( val ) then
			return val + 0;
		end
	end
	return 0;
end

local function MobHealth_Set(index, pts, pct)
	if( index ) then
		if( pts ) then
			pts = pts + 0;
		else
			pts = 0;
		end
		if( pct ) then
			pct = pct + 0;
		else
			pct = 0;
		end
		if( pts == 0 and pct == 0 ) then
			MobHealthDB[index] = nil;
		else
			MobHealthDB[index] = pts.."/"..pct;
		end
	end
end

local function MobHealth_Display(currentPct, index)
	local field = getglobal("MobHealthText");
	local text = "";
	
	if( field ) then
		local pointsPerPct = MobHealth_PPP(index);
		if( pointsPerPct > 0 ) then	
			if( currentPct ) then
				text = string.format("%d/%d", (currentPct * pointsPerPct) + 0.5, (100 * pointsPerPct) + 0.5);
			else
				text = string.format("???/%d", (100 * pointsPerPct) + 0.5);
			end
			if( lTargetData ) then
				if( lTargetData.suspect or lTargetData.tainted ) then
					text = text.." ";
					if( lTargetData.suspect ) then
						text = text.."S";
					end
					if( lTargetData.tainted ) then
						text = text.."T";
					end
				end
			end
		end
		field:SetText(text);
	end
end

local function MobHealth_CheckForSpells()
	local iBuff;

	-- Check for spells that give the target a chance to regen a lot of health;
	-- right now the only one I can think of is Polymorph, but there may be others
	if( lTargetData and not lTargetData.tainted ) then	
		for iBuff = 1, MAX_TARGET_DEBUFFS do
			local debuff = UnitDebuff("target", iBuff);
			if( debuff ) then
				if( debuff == "Interface\\Icons\\Spell_Nature_Polymorph" ) then
					lTargetData.tainted = 1;
				end
			end
		end
	end
end

local function MobHealth_VariablesLoaded()
	if( not MobHealthDB ) then
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
end

local function MobHealth_ParseEvent(event)
	if( lTargetData ) then
		for index, value in lMatchData do
			local s, e;
			local results = { };
			s, e, results[0], results[1], results[2], results[3], results[4] = string.find(arg1, value.pattern);
			if( results[value.mob] == lTargetData.name ) then
				if( value.cause ) then

					-- Something else hit or healed our mob or a mob with the same name,
					-- so further results are suspect because we can't tell them apart
					
					-- Further, we can't guarantee delivery order or timeliness of events,
					-- so can't even assume that because our mob's health is unchanged that
					-- it wasn't hit, since we could get a later health update for this event

					lTargetData.suspect = 1;
				end
				if( value.heal ) then
					lTargetData.tempDamagePoints = lTargetData.tempDamagePoints - results[value.pts];
				else
					lTargetData.tempDamagePoints = lTargetData.tempDamagePoints + results[value.pts];
				end
				
				-- Matched one pattern, don't bother checking others
				return;
			end
		end
	end
end

--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------

function MobHealth_OnLoad()
	RegisterForSave("MobHealthDB");
	
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("UNIT_AURA");
	
	local index, value;
	for index, value in lCombatEvents do
		this:RegisterEvent(value);
	end

	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("Telo's MobHealth AddOn loaded");
	end
	UIErrorsFrame:AddMessage("Telo's MobHealth AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function MobHealth_OnEvent(event)
	if( event == "VARIABLES_LOADED" ) then
		MobHealth_VariablesLoaded();
	elseif( event == "UNIT_HEALTH" ) then
		MobHealth_Display(nil, nil);
		if( lTargetData ) then
			local health = UnitHealth("target");
			if( lTargetData.tainted ) then
				if( MobHealth_PPP(lTargetData.index) > 0 ) then
					MobHealth_Display(health, lTargetData.index);
				end
			else
				if( health and health ~= 0 ) then
					local change = lTargetData.currentHealthPercent - health;
					if( change ~= 0 ) then
						local damage = lTargetData.tempDamagePoints;
						local persistPts = MobHealth_Pts(lTargetData.index);
						local persistPct = MobHealth_Pct(lTargetData.index);
						local currentPPP = damage / change;
						local overallPPP;
						local updatedPPP;

						if( persistPct ~= 0 ) then
							overallPPP = persistPts / persistPct;
						else
							overallPPP = 0;
						end
						
						if( (persistPct + change) ~= 0 ) then
							updatedPPP = (persistPts + damage) / (persistPct + change);
						else
							updatedPPP = 0;
						end

						lTargetData.currentHealthPercent = health;
						lTargetData.tempDamagePoints = 0;

						-- If this target is suspect, mark it as tainted if the current data is too far off
						if( lTargetData.suspect ) then
							if( overallPPP == 0 or currentPPP < overallPPP * 0.85 or currentPPP > overallPPP * 1.15 ) then
								lTargetData.tainted = 1;
							end
						end
						
						if( not lTargetData.tainted and updatedPPP > 0 ) then
							MobHealth_Set(lTargetData.index, persistPts + damage, persistPct + change);
						end
					end
					MobHealth_Display(health, lTargetData.index);
				end
			end
		end
	elseif( event == "PLAYER_TARGET_CHANGED" ) then
		local name = UnitName("target");
		if( name ) then
			if( UnitCanAttack("player", "target") and not UnitIsDead("target") and not UnitIsPlayer("target") ) then
				-- Attackable, alive, non-player target
				lTargetData = { };
				lTargetData.name = name;
				lTargetData.level = UnitLevel("target");
				lTargetData.index = lTargetData.name..":"..lTargetData.level;
				lTargetData.currentHealthPercent = UnitHealth("target");
				lTargetData.tempDamagePoints = 0;
				lTargetData.suspect = nil;
				lTargetData.tainted = nil;
				
				MobHealth_CheckForSpells();
				MobHealth_Display(lTargetData.currentHealthPercent, lTargetData.index);
				return;
			end
		end

		-- Unusable target
		lTargetData = nil;

		MobHealth_Display(nil, nil);
	elseif( event == "UNIT_AURA" and arg1 == "target" ) then
		MobHealth_CheckForSpells();
	else
		MobHealth_ParseEvent(event);
	end
end
