--[[
  ****************************************************************
	Scrolling Combat Text v3.01

	Author: Grayhoof
	****************************************************************
	Description:
		A fairly simple but very configurable mod that adds damage, 
		heals, and events (dodge, parry, etc...) as 
		scrolling text above you character model, much like what 
		already happens above your target. This makes it so you do not 
		have to watch (or use) your regular combat chat window and 
		gives it a "Final Fantasy" feel.

	Thank you to:
		Nulli, for the original healthbar mod
		Kaitlin, for Mini-Group code examples
		Dhargo/Mairelon, for FlexBar code examples
		Ayny, for the new parsing code samples

	Official Site:
		http://rjhaney.pair.com/sct/ 
	
	****************************************************************]]

-- global flags/vars
SCTPlayer = nil;
SCT_NameRegistered = 0;
SCT_LastHPPercent = 0;
SCT_LastManaPercent = 0;

-- local constants
local SCT_CRIT_FADEINTIME = 0.5;
local SCT_CRIT_HOLDTIME = 2.0;
local SCT_CRIT_FADEOUTTIME = 0.5;
local SCT_CRIT_X_OFFSET = 100;
local SCT_CRIT_Y_OFFSET = 75;
local SCT_CRIT_SIZE_PERCENT = 1.25;
local SCT_CRUSH_SIZE_PERCENT = 1.15;
local SCT_GLANCE_SIZE_PERCENT = .85;
local SCT_MAX_SPEED = .025;
local SCT_TOP_POINT = 210;
local SCT_BOTTOM_POINT = 60;
local SCT_STEP = 2;
local SCT_BERSERK_LEVEL = .2;

--Animation System variables
local SCT_LASTBAR = 1;					-- Holds what the next avalible fontstring for the animation system is
local SCT_LASTCRITBAR = 1;					-- Holds what the next avalible fontstring for the animation system is
local arrAniData = {
		["aniData1"] = {},					-- These are structures that define the animation data
		["aniData2"] = {},
		["aniData3"] = {},
		["aniData4"] = {},
		["aniData5"] = {},
		["aniData6"] = {},
		["aniData7"] = {},
		["aniData8"] = {},
		["aniData9"] = {},
		["aniData10"] = {}
}

local sct_spelltypes = {
	[0] = RESISTANCE0_NAME,
	[1] = RESISTANCE1_NAME,
	[2] = RESISTANCE2_NAME,
	[3] = RESISTANCE3_NAME,
	[4] = RESISTANCE4_NAME,
	[5] = RESISTANCE5_NAME,
	[6] = RESISTANCE6_NAME,
}

local default_config = {
		["VERSION"] = SCT_Version,
		["ENABLED"] = 1,
		["ANIMATIONSPEED"] = 0.015,
		["TEXTSIZE"] = 24,
		["LOWHP"] = .4,
		["LOWMANA"] = .4,
		["SHOWHIT"] = 1,
		["SHOWMISS"] = 1,
		["SHOWDODGE"] = 1,
		["SHOWPARRY"] = 1,
		["SHOWBLOCK"] = 1,
		["SHOWSPELL"] = 1,
		["SHOWHEAL"] = 1,
		["SHOWRESIST"] = 1,
		["SHOWDEBUFF"] = 1,
		["SHOWBUFF"] = 1,
		["SHOWFADE"] = 0,
		["SHOWABSORB"] = 1,
		["SHOWLOWHP"] = 1,
		["SHOWLOWMANA"] = 1,
		["SHOWPOWER"] = 1,
		["SHOWCOMBAT"] = 0,
		["SHOWCOMBOPOINTS"] = 0,
		["SHOWHONOR"] = 1,
		["SHOWASMESSAGE"] = 0,
		["SHOWSELF"] = 0,
		["DIRECTION"] = 0,
		["STICKYCRIT"] = 1,
		["SPELLTYPE"] = 0,
		["ALPHA"] = 1,
		["COLORS"] = {
			[1] =  {r = 1.0, g = 0.0, b = 0.0},
			[2] =  {r = 0.0, g = 0.0, b = 1.0},
			[3] =  {r = 0.0, g = 0.0, b = 1.0},
			[4] =  {r = 0.0, g = 0.0, b = 1.0},
			[5] =  {r = 0.0, g = 0.0, b = 1.0},
			[6] =  {r = 0.5, g = 0.0, b = 0.5},
			[7] =  {r = 0.0, g = 1.0, b = 0.0},
			[8] =  {r = 0.5, g = 0.0, b = 0.5},
			[9] =  {r = 0.0, g = 0.5, b = 0.5},
			[10] =  {r = 1.0, g = 1.0, b = 0.0},
			[11] =  {r = 1.0, g = 0.5, b = 0.5},
			[12] =  {r = 0.5, g = 0.5, b = 1.0},
			[13] =  {r = 1.0, g = 1.0, b = 0.0},
			[14] =  {r = 1.0, g = 1.0, b = 1.0},
			[15] =  {r = 1.0, g = 0.5, b = 0.0},
			[16] =  {r = 0.5, g = 0.5, b = 0.7},
			[17] =  {r = 0.7, g = 0.7, b = 0.0},
			[18] =  {r = 0.7, g = 0.7, b = 0.0}
		}
	};


----------------------
--Called when its loaded
function SCT_OnLoad()
	-- Register Startup Events
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("ADDON_LOADED");
end

----------------------
-- Show the Option Menu
function SCT_showMenu()
	PlaySound("igMainMenuOpen");
	ShowUIPanel(SCTOptions);
end

----------------------
--Hide the Option Menu
function SCT_hideMenu()
	PlaySound("igMainMenuClose");
	HideUIPanel(SCTOptions);
	
	-- myAddOns support
	if(MYADDONS_ACTIVE_OPTIONSFRAME == SCTOptions) then
		ShowUIPanel(myAddOnsFrame);
	end
end


----------------------
--Get a clean config
function SCT_FreshVar()
	SCT_CONFIG = {};
end

----------------------
--Set the global player config
function SCT_Initialize()
	
	if (SCT_NameRegistered == 1) then
			return;
	end
	
	local playerName = UnitName("player");
	SCT_Chat_Message(SCT_STARTUP);
	SCT_NameRegistered = 1;
	SCT_aniInit();

	
	-- Register Main Events
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("UNIT_SPELLMISS");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"); 


	-- Add Slash Commands
	SlashCmdList["SCT"] = SCT_showMenu;
	SLASH_SCT1 = "/sct";
	
	SlashCmdList["SCTMENU"] = SCT_showMenu;
	SLASH_SCTMENU1 = "/sctmenu";
	
	SlashCmdList["SCTRESET"] = SCT_Reset;
	SLASH_SCTRESET1 = "/sctreset";
	
	SlashCmdList["SCTDISPLAY"] = SCT_CmdDisplay;
	SLASH_SCTDISPLAY1 = "/sctdisplay";
	
	-- myAddOns support
	if(myAddOnsList) then
		myAddOnsList.SCT = {
			name = SCT_CB_NAME,
			description = SCT_CB_LONG_DESC,
			version = SCT_Version,
			frame = "SCT_HEALTHTEXT",
			optionsframe = "SCTOptions",
			category = MYADDONS_CATEGORY_COMBAT
		};
	end
	
	--Cosmos support
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton(
		   {
		      id="SCT";
		      name=SCT_CB_NAME;
		      text=SCT_CB_NAME;
		      subtext=SCT_CB_SHORT_DESC;
		      helptext=SCT_CB_LONG_DESC;
		      icon=SCT_CB_ICON;
		      callback=SCT_showMenu;
		   }
		);
	elseif (Cosmos_RegisterButton) then
		Cosmos_RegisterButton (
		   SCT_CB_NAME,
		   SCT_CB_SHORT_DESC,
		   SCT_CB_LONG_DESC,
		   SCT_CB_ICON,
		   SCT_showMenu,
		   function()
		      return true;
		   end
		);
		default_config.ENABLED = 0;
	end

	
	-- Add my options frame to the global UI panel list
	UIPanelWindows["SCTOptions"] = {area = "center", pushable = 0};

	--if there's not a config loaded
	if ( SCT_CONFIG == nil) then
		--get a new clean one
		SCT_FreshVar();
	end
	
	--set the currentplayer config
	SCTPlayer = SCT_Config_GetPlayer();
end

----------------------
--Get or Create a config based on the current player
function SCT_Config_GetPlayer()
	if (SCT_CONFIG[UnitName("player").." of "..GetCVar("realmName")] == nil) then
		SCT_Config_NewPlayer(UnitName("player").." of "..GetCVar("realmName"));
	end
	return SCT_CONFIG[UnitName("player").." of "..GetCVar("realmName")];
end

----------------------
--Set up a default config
function SCT_Config_NewPlayer(PlayerName)
	SCT_CONFIG[PlayerName] = SCT_clone(default_config);
	local yellow = {r = 1.0, g = 1.0, b = 0.0};
	SCT_Display_Message("New player "..PlayerName.." added to SCT.", yellow);
end

----------------------
--Copy a whole table
function SCT_clone(t)             -- return a copy of the table t
  local new = {};             -- create a new table
  local i, v = next(t, nil);  -- i is an index of t, v = t[i]
  while i do
  	if type(v)=="table" then 
  		v=SCT_clone(v);
  	end 
    new[i] = v;
    i, v = next(t, i);        -- get next index
  end
  return new;
end


----------------------
--Reset everything to default
function SCT_Reset()
	SCT_CONFIG[UnitName("player").." of "..GetCVar("realmName")] = nil;
	SCTPlayer = SCT_Config_GetPlayer();
	SCT_hideMenu();
	SCT_showMenu();
end

----------------------
--Get a value from player config
function SCT_Get(option)
	if (SCTPlayer ~= nil) and (SCTPlayer[option] ~= nil) then
		return SCTPlayer[option];
	else
		return default_config[option];
	end
end

----------------------
--Set a value in player config
function SCT_Set(option, newVal)
	if (SCTPlayer ~= nil) then
		if ( option ) then
			SCTPlayer[option] = newVal;
		end
	end
end

----------------------
--Get a color in the player config
function SCT_GetColor(key)
	local color = {r = 1.0, g = 1.0, b = 1.0};
	
	if (SCTPlayer ~= nil) and (SCTPlayer["COLORS"][key] ~= nil) then
		color.r = SCTPlayer["COLORS"][key].r
		color.g = SCTPlayer["COLORS"][key].g
		color.b = SCTPlayer["COLORS"][key].b
		return color;
	else
		color.r = default_config["COLORS"][key].r
		color.g = default_config["COLORS"][key].g
		color.b = default_config["COLORS"][key].b
		return color;
	end
end

----------------------
--Set a color in the player config
function SCT_SetColor(key, r, g, b)
	if (SCTPlayer ~= nil) and (SCTPlayer["COLORS"][key] ~= nil) then
		SCTPlayer["COLORS"][key].r = r;
		SCTPlayer["COLORS"][key].g = g;
		SCTPlayer["COLORS"][key].b = b;
	else
		local color = {r = 1.0, g = 1.0, b = 1.0};
		color.r = default_config["COLORS"][key].r
		color.g = default_config["COLORS"][key].g
		color.b = default_config["COLORS"][key].b
		SCTPlayer["COLORS"][key] = color;
	end
end

----------------------
-- Event Handler
-- this function parses events that are printed in the combat
-- chat window then displays the health changes
function SCT_OnEvent()
	
	local critical;
		
	--Player loaded completely
	if (event == "VARIABLES_LOADED") or ( event == "ADDON_LOADED" and arg1 == "sct" ) or (event=="PLAYER_ENTERING_WORLD") then
		SCT_Initialize();
		return;
	end
	
	-- if its enabled
	if (SCT_Get("ENABLED") == 1) then
		
		--Player Health
		if (event == "UNIT_HEALTH") then
			if (arg1 == "player") and (SCT_Get("SHOWLOWHP") == 1) and (SCT_NameRegistered == 1)then
				local warnlevel = SCT_Get("LOWHP");
				local HPPercent = UnitHealth("player") / UnitHealthMax("player");
	      if (HPPercent < warnlevel) and (SCT_LastHPPercent >= warnlevel) then
	      	SCT_Display_Toggle(SCT_LowHP, SCT_GetColor(11));
	      end
	      SCT_LastHPPercent = HPPercent;
			end
			return;
	
		--Player Mana
		elseif (event == "UNIT_MANA") then
			if (arg1 == "player") and (SCT_Get("SHOWLOWMANA") == 1) and (SCT_NameRegistered == 1) and (UnitPowerType("player") == 0)then
				local warnlevel = SCT_Get("LOWMANA");
				local ManaPercent = UnitMana("player") / UnitManaMax("player");
	      if (ManaPercent < warnlevel) and (SCT_LastManaPercent >= warnlevel) then
	      	SCT_Display_Toggle(SCT_LowMana, SCT_GetColor(12));
	      end
	      SCT_LastManaPercent = ManaPercent;
			end
			return;
			
		--Player Combat
		elseif (event =="PLAYER_REGEN_DISABLED") then
			if (SCT_Get("SHOWCOMBAT") == 1) then
				SCT_Display_Toggle(SCT_Combat, SCT_GetColor(14));	
			end
			return;
			
		--Player NoCombat
		elseif (event =="PLAYER_REGEN_ENABLED") then
			if (SCT_Get("SHOWCOMBAT") == 1) then
				SCT_Display_Toggle(SCT_NoCombat, SCT_GetColor(14));
			end
			return;
			
		--Player Combo Points
		elseif (event == "PLAYER_COMBO_POINTS") then
			if (SCT_Get("SHOWCOMBOPOINTS") == 1) then
				local SCT_CP = GetComboPoints();
				if (SCT_CP ~= 0) then
					local SCT_CP_Message = SCT_CP.." "..SCT_ComboPoint;
					if (SCT_CP == 5) then
						SCT_CP_Message = SCT_CP_Message.." "..SCT_FiveCPMessage;
					end;
					SCT_Display_Toggle(SCT_CP_Message, SCT_GetColor(15));
				end
			end
			return;
			
		--Player Honor Gain
		elseif (event == "CHAT_MSG_COMBAT_HONOR_GAIN") then
			for honor in string.gfind(arg1, SCT_HONOR_SEARCH) do
				if (SCT_Get("SHOWHONOR") == 1) then
					SCT_Display_Toggle("+"..honor.." "..SCT_Honor, SCT_GetColor(16));
				end
				return;
			end
				
		--Player Misses
		elseif (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES") then
				
			--partial Absorob
			for num, num2 in string.gfind( arg1, SCT_ABSORB_AMOUNT_SEARCH) do
				if (SCT_Get("SHOWABSORB") == 1) then
					SCT_Display_Toggle(num2, SCT_GetColor(10), 0, SCT_YOU..SCT_Absorb.." "..num2);
				end
				return;
			end
			
			--if none, return
			return;
			
		--Player Hits
		elseif (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS") then				
					
			--partial block
			for num, num2 in string.gfind( arg1, SCT_BLOCK_AMOUNT_SEARCH) do
				--extra search here cause crsuhing and glancing blows, and
				--the punctuation of the line messes up SCT_BLOCK_AMOUNT_SEARCH
				num3, num4 = string.find(num2, SCT_BLOCK_SEARCH);
				if num3 then
					if (SCT_Get("SHOWBLOCK") == 1) then
						SCT_Display_Toggle(num2, SCT_GetColor(5), 0, SCT_YOU..SCT_BlockMsg.." "..num2);
					end
				end
				return;
			end
			
			--if none, return
			return;
			
			
		--Debuffs
		elseif (event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE") then
			
			--Configured self buffs
			if (SCT_CustomEventSearch(arg1) ~= true) then
				--DoT Heal, Mana, Rage, Energy
				for type, num, name in string.gfind( arg1, SCT_YOU_GAIN_AMOUNT_SEARCH ) do
					if (strlower(name) == strlower(MANA)) or (strlower(name) == strlower(ENERGY)) or (strlower(name) == strlower(RAGE)) then
						if (SCT_Get("SHOWPOWER") == 1) then
							SCT_Display("+"..num.." "..name, SCT_GetColor(13));
						end
					end
					return;
				end
				
				--Debuff
				for num in string.gfind(arg1, SCT_DEBUFF_NAME_SEARCH) do
					if (SCT_Get("SHOWDEBUFF") == 1) then
						SCT_Display_Toggle("("..num..")", SCT_GetColor(9), 0, SCT_AFFLICTED_BY..num);	
					end
					return;
				end
			end
			
			--if none, return
			return;
			
		--Self Buffs
		elseif (event == "CHAT_MSG_SPELL_SELF_BUFF") then
			
			--Configured self buffs
			if (SCT_CustomEventSearch(arg1) ~= true) then
				--DoT Heal, Mana, Rage, Energy
				for type, num, name in string.gfind( arg1, SCT_YOU_GAIN_AMOUNT_SEARCH ) do
					if (strlower(name) == strlower(MANA)) or (strlower(name) == strlower(ENERGY)) or (strlower(name) == strlower(RAGE)) then
						if (SCT_Get("SHOWPOWER") == 1) then
							SCT_Display("+"..num.." "..name, SCT_GetColor(13));
						end
					end
					return;
				end
				
				--Buff
				for name in string.gfind( arg1, SCT_YOU_GAIN_SEARCH ) do
					if (SCT_Get("SHOWBUFF") == 1) then
						SCT_Display_Toggle("["..name.."]", SCT_GetColor(17), 0, SCT_YOU_GAIN..name);
					end
					return;
				end
			end
			
			--if none, return
			return;
			
		--Other Self Buffs
		elseif (event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS") then
		
			--Configured self buffs
			if (SCT_CustomEventSearch(arg1) ~= true) then
				--DoT Heal, Mana, Rage, Energy
				for type, num, name in string.gfind( arg1, SCT_YOU_GAIN_AMOUNT_SEARCH ) do
					if (strlower(name) == strlower(MANA)) or (strlower(name) == strlower(ENERGY)) or (strlower(name) == strlower(RAGE)) then
						if (SCT_Get("SHOWPOWER") == 1) then
							SCT_Display("+"..num.." "..name, SCT_GetColor(13));
						end
					end
					return;
				end
				
				--Buff
				for name in string.gfind( arg1, SCT_YOU_GAIN_SEARCH ) do
					if (SCT_Get("SHOWBUFF") == 1) then
						SCT_Display_Toggle("["..name.."]", SCT_GetColor(17), 0, SCT_YOU_GAIN..name);
					end
					return;
				end
			end
			
			--if none, return
			return;
			
		--Buff Fades
		elseif (event == "CHAT_MSG_SPELL_AURA_GONE_SELF" ) then
			
			--Buff Fades
			if (SCT_CustomEventSearch(arg1) ~= true) then
				for name in string.gfind(arg1, SCT_FADE_SEARCH) do
					if (SCT_Get("SHOWFADE") == 1) then
						SCT_Display_Toggle("-["..name.."]", SCT_GetColor(18), 0, name..SCT_YOU_FADE);	
					end
					return;
				end
			end
			
			--if none, return
			return;
			
		--Other Self Events (for searching only)
		elseif (event == "CHAT_MSG_COMBAT_SELF_HITS" or 
						event == "CHAT_MSG_COMBAT_SELF_MISSES" or 
						event == "CHAT_MSG_SPELL_SELF_DAMAGE" or 
						event == "CHAT_MSG_SPELL_AURA_GONE_SELF" or
						event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or
						event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") or 
						event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
			
			--Configured events
			SCT_CustomEventSearch(arg1);
			return;	
			
		--Combat Event
		elseif((event == "UNIT_COMBAT") and (arg1 == "player")) then
		
			--Set Crit Flag
			if(arg3 == "CRITICAL") then
				critical=1;
			else
				critical=0;
			end
			
			--If Damage
			if(arg2 == "WOUND") then
				-- If Absorb
				if(arg3 == "ABSORB") then
					if (SCT_Get("SHOWABSORB") == 1) then
						SCT_Display_Toggle(SCT_Absorb, SCT_GetColor(10), critical, SCT_YOU..SCT_Absorb);
					end
					return;	
				end
				
				--If Damage
				if(arg4 ~= 0 or arg4 ~= nil) then
					--Spell
					if (arg5 > 0) then
						if (SCT_Get("SPELLTYPE") ==1) then
							arg4 = arg4.." ("..sct_spelltypes[arg5]..")";
						end
						if (SCT_Get("SHOWSPELL") ==1) then
							SCT_Display( "-"..arg4 , SCT_GetColor(6), critical);
						end
					--Health
					else
						if (SCT_Get("SHOWHIT") == 1) then
							--see if its glacing or crushing
							if ( arg3 == "CRUSHING" ) then
								critical = 2;
							elseif ( arg3 == "GLANCING" ) then
								critical = 3;
							end
							SCT_Display("-"..arg4 , SCT_GetColor(1), critical);
							--check for troll berzerk
				      if (UnitRace("player") == "Troll" and critical==1) then
				      	SCT_Display_Toggle(SCT_Berserk, SCT_GetColor(13));
							end
						end
					end
				end
				return;
			
			--If A Heal
			elseif(arg2 == "HEAL") then
				if(arg4 ~= 0 or arg4 ~= nil) then
					if (SCT_Get("SHOWHEAL") == 1) then
						SCT_Display( "+"..arg4 , SCT_GetColor(7), critical);
					end
				end
				return;
				
			--If a Dodge
			elseif(arg2 == "DODGE") then
				if (SCT_Get("SHOWDODGE") == 1) then
					SCT_Display_Toggle(SCT_DodgeMsg, SCT_GetColor(3), critical, SCT_YOU..SCT_DodgeMsg);		
				end
				return;
			
			--If a Full Block
			elseif(arg2 == "BLOCK") then
				if (SCT_Get("SHOWBLOCK") == 1) then
					SCT_Display_Toggle(SCT_BlockMsg, SCT_GetColor(5), critical, SCT_YOU..SCT_BlockMsg);				
				end
				return;
			
			--If a Parry
			elseif(arg2 == "PARRY") then
				if (SCT_Get("SHOWPARRY") == 1) then
					SCT_Display_Toggle(SCT_ParryMsg, SCT_GetColor(4), critical, SCT_YOU..SCT_ParryMsg);		
				end
				return;
				
			--If a Miss
			elseif(arg2 == "MISS") then
				if (SCT_Get("SHOWMISS") == 1) then
					SCT_Display_Toggle(SCT_MissMsg, SCT_GetColor(2), critical, SCT_TARGET..SCT_MissMsg);			
				end
				return;
			
			--If Resist
			elseif(arg2 == "RESIST") then
				if(SCT_Get("SHOWRESIST") == 1) then
					SCT_Display_Toggle(SCT_ResistMsg, SCT_GetColor(8), critical, SCT_YOU..SCT_ResistMsg);		
				end
				return;
			end

			--if none, return
			return;
		
		--Sepll Miss events
		elseif((event == "UNIT_SPELLMISS") and (arg1 == "player")) then
				
			--If Deflected
			if(arg2 == "DEFLECTED") then
				if(SCT_Get("SHOWRESIST") == 1) then
					SCT_Display_Toggle(SCT_DeflectMsg, SCT_GetColor(8), critical, SCT_YOU..SCT_DeflectMsg);			
				end
				return;
			end
		end
	end
end

----------------------
--Find a custom capture event message
function SCT_CustomEventSearch(arg1)
	local strTempMessage; 
	local currentcolor;
	local iscrit;
	local table;
	for key, value in SCT_Event_Config do
		for carg1, carg2, carg3, carg4, carg5 in string.gfind(arg1, value.search) do
			strTempMessage = value.name;
			--if there are capture args
			if ((value.argcount) and (value.argcount > 0) and (value.argcount < 6)) then
				table = {carg1, carg2, carg3, carg4, carg5}
				--loop though each capture arg. if it exists replace the display position with it
				for i = 1, value.argcount do
					if (table[i]) then
						strTempMessage, strCount = string.gsub(strTempMessage, "*"..i, table[i]);
					end
				end			 
			end
			--get color
			currentcolor = {r = 1.0, g = 1.0, b = 1.0};
			iscrit = 0
			if (value.r and value.g and value.b) then
				currentcolor.r = value.r;
				currentcolor.g = value.g;
				currentcolor.b = value.b;
			end
			--see if crit
			if (value.iscrit) then
				iscrit = value.iscrit
			end
			--display
			SCT_Display_Toggle(strTempMessage, currentcolor, iscrit);
			return true;				
		end
	end
	return false;
end

----------------------
--Display the Text based on message flag
function SCT_Display_Toggle(msg1, color, iscrit, msg2)
	if (SCT_Get("SHOWASMESSAGE") == 1) then
		if (msg2) then
			msg1 = msg2;
		end
		SCT_Display_Message( msg1, color );
	else
		SCT_Display( msg1 , color, iscrit );
	end	
end

----------------------
--Display the Text
function SCT_Display(msg, color, iscrit)
	local adat;
	local startpos, lastpos, textsize;
	
	--Set up  text animation
	adat = arrAniData["aniData"..SCT_LASTBAR];
	

	
	-- if its active (rarely happens as all 10 must be in use), set points, if not set as active
	if (adat.Active == true) then
		--Set the start pos based on setting
		if (SCT_Get("DIRECTION") == 0) then
			startpos = SCT_BOTTOM_POINT;
		else
			startpos = SCT_TOP_POINT;
		end
		
		adat.posX = 0;
		adat.posY = startpos;
	end
			
	--set alpha
	adat.alpha = SCT_Get("ALPHA");
		
	--If they want to tag all self events
	if (SCT_Get("SHOWSELF") == 1) then
		msg = SCT_SelfFlag..msg..SCT_SelfFlag
	end
		
	--If its a crit hit, increase the size
	if (iscrit == 1) then
		textsize = SCT_Get("TEXTSIZE") * SCT_CRIT_SIZE_PERCENT;
		if (SCT_Get("STICKYCRIT") == 1) then
			adat.crit = true;
			local critcount = SCT_critCount();
			
			adat.posY = (SCT_TOP_POINT + SCT_BOTTOM_POINT)/2;
			
			--if there are other Crits active, set offset.
			if (critcount > 1) then
				--alternate left to right, up, down
				if (SCT_LASTCRITBAR == 1) then
					adat.posX = adat.posX + SCT_CRIT_X_OFFSET;
					adat.posY = adat.posY + SCT_CRIT_Y_OFFSET;
					SCT_LASTCRITBAR = 2;
				elseif (SCT_LASTCRITBAR == 2) then
					adat.posX = adat.posX + SCT_CRIT_X_OFFSET;
					adat.posY = adat.posY - SCT_CRIT_Y_OFFSET;
					SCT_LASTCRITBAR = 3;
				elseif (SCT_LASTCRITBAR == 3) then
					adat.posX = adat.posX - SCT_CRIT_X_OFFSET;
					adat.posY = adat.posY + SCT_CRIT_Y_OFFSET;
					SCT_LASTCRITBAR = 4;
				elseif (SCT_LASTCRITBAR == 4) then
					adat.posX = adat.posX - SCT_CRIT_X_OFFSET;
					adat.posY = adat.posY - SCT_CRIT_Y_OFFSET;
					SCT_LASTCRITBAR = 5;
				else
					SCT_LASTCRITBAR = 1;
				end
			else
				SCT_LASTCRITBAR = 1;
			end
		end
	--Crushing
	elseif (iscrit == 2) then
		textsize = SCT_Get("TEXTSIZE") * SCT_CRUSH_SIZE_PERCENT;
	--glancing
	elseif (iscrit == 3) then
		textsize = SCT_Get("TEXTSIZE") * SCT_GLANCE_SIZE_PERCENT;
	else
		textsize = SCT_Get("TEXTSIZE");
	end
	
	--if its not a sticky crit, make sure they don't overlap
	if (adat.crit ~= true) then
		
		--get the last known point of active items
		lastpos = SCT_MinPoint()
		
		if (SCT_Get("DIRECTION") == 0) then
			--move the position down
			if ((lastpos - adat.posY) <= SCT_Get("TEXTSIZE")) then
				adat.posY = adat.posY - (SCT_Get("TEXTSIZE") - (lastpos - adat.posY));
			end
			--if its gone too far down, stop
			if (adat.posY < (SCT_BOTTOM_POINT * -1)) then
				adat.posY = (SCT_BOTTOM_POINT * -1)
			end
		else
			--move the position up
			if ((adat.posY - lastpos) <= SCT_Get("TEXTSIZE")) then
				adat.posY = adat.posY + (SCT_Get("TEXTSIZE") - (adat.posY - lastpos));
			end
			--if its gone too far up, stop
			if (adat.posY > (SCT_TOP_POINT + (SCT_BOTTOM_POINT * 2))) then
				adat.posY = (SCT_TOP_POINT + (SCT_BOTTOM_POINT * 2))
			end
		end
	end
	
	--set to active
	adat.Active = true;
	
	--Start up onUpdate, note this is done after active is set to true
	if (not SCT_HEALTHTEXT:IsVisible()) then
		SCT_HEALTHTEXT:Show();
	end
	
	--set text size
	adat.FObject:SetTextHeight(textsize);
	--set the color
	adat.FObject:SetTextColor(color.r, color.g, color.b);
	--set alpha
	adat.FObject:SetAlpha(adat.alpha);
	--Position
	adat.FObject:SetPoint("CENTER", "UIParent", "CENTER", adat.posX, adat.posY);
	--Set the text to display
	adat.FObject:SetText(msg);
	
	adat.lastupdate = GetTime();
	
	--update current text being used
	SCT_LASTBAR = SCT_LASTBAR + 1;
	
	--if we reached the end, set to first
	if (SCT_LASTBAR >= 11) then
		SCT_LASTBAR = 1;
	end
end

----------------------
--Displays a message at the top of the screen
function SCT_Display_Message(msg, color)
		UIErrorsFrame:AddMessage(msg, color.r, color.g, color.b, 1.0, 1);
end

function SCT_Chat_Message(msg)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

----------------------
--Display text from a command line
function SCT_CmdDisplay(msg)	
	
	local message = nil;
	local colors = nil;
	
	--If there are not parameters, display useage
	if string.len(msg) == 0 then
		SCTDisplayUseage();
	--Get message anf colors if quotes used
	elseif string.sub(msg,1,1) == "'" then
		local location = string.find(string.sub(msg,2),"'")
		if location and (location>1) then
			message = string.sub(msg,2,location)
			colors = string.sub(msg,location+1);
		end
	--Get message anf colors if single word used
	else
		local idx = string.find(msg," ");
		if (idx) then
			message = string.sub(msg,1,idx-1);
			colors = string.sub(msg,idx+1);
		else
			message = msg;
		end
	end
	
	--if they sent colors, grab them
	local firsti, lasti, red, green, blue = nil;
	if (colors ~= nil) then
		firsti, lasti, red, green, blue = string.find (colors, "(%w+) (%w+) (%w+)");
	end
    
  local color = {r = 1.0, g = 1.0, b = 1.0}; 
	
	--if they sent 3 colors use them, else use default white
  if (red == nil) or (green == nil) or (blue == nil) then
  	SCT_Display(message, color);
  else
  	color.r = (tonumber(red)/10)
  	color.g = (tonumber(green)/10)
  	color.b = (tonumber(blue)/10)
  	SCT_Display(message, color);
  end
end

----------------------
--Explains how to use sctdisplay
function SCTDisplayUseage()
    SCT_Chat_Message(SCT_DISPLAY_USEAGE);
end

----------------------
-- Update the animcation
function SCT_TextUpdate()
	SCT_updateAnimation();
end

----------------------
-- Upate animations that are being used
function SCT_updateAnimation()	
	local anyActive = false;
	
	for key, value in arrAniData do
		if (value.Active) then
			anyActive = true;
			SCT_doAnimation(value);
		end
	end
		
	--if none are active, stop onUpdate;
	if ((anyActive ~= true) and (SCT_HEALTHTEXT:IsVisible())) then
		SCT_HEALTHTEXT:Hide();
	end

end

----------------------
--Move text to get the animation
function SCT_doAnimation(aniData)
	--If a crit			
	if (aniData.crit) then		
		--display crit		
		local elapsedTime = GetTime() - aniData.lastupdate;
		local fadeInTime = SCT_CRIT_FADEINTIME;
		if ( elapsedTime < fadeInTime ) then
			local alpha = (elapsedTime / fadeInTime);
			alpha = alpha * SCT_Get("ALPHA");
			aniData.FObject:SetAlpha(alpha);
			return;
		end
		local holdTime = (SCT_CRIT_HOLDTIME * (SCT_Get("ANIMATIONSPEED")/SCT_MAX_SPEED));
		if ( elapsedTime < (fadeInTime + holdTime) ) then
			aniData.FObject:SetAlpha(SCT_Get("ALPHA"));
			return;
		end
		local fadeOutTime = SCT_CRIT_FADEOUTTIME;
		if ( elapsedTime < (fadeInTime + holdTime + fadeOutTime) ) then
			local alpha = 1 - ((elapsedTime - holdTime - fadeInTime) / fadeOutTime);
			alpha = alpha * SCT_Get("ALPHA");
			aniData.FObject:SetAlpha(alpha);
			return;
		end
		--reset crit
		SCT_aniReset(aniData);
		
	--else normal text
	else
		local curtime = GetTime();
		local startpos, endpos, step, alpha;
		local avgpos, diffpos;
		
		avgpos = (SCT_TOP_POINT + SCT_BOTTOM_POINT)/2;
		diffpos = (SCT_TOP_POINT - SCT_BOTTOM_POINT)/2;
		
		--if its time to update, move the text step positions
		if ((curtime-aniData.lastupdate) > SCT_Get("ANIMATIONSPEED")) then
			--set parameters based on direction settings
			if (SCT_Get("DIRECTION") == 0) then
				startpos = SCT_BOTTOM_POINT;
				endpos = SCT_TOP_POINT;
				step = SCT_STEP;
				if (aniData.posY > avgpos) then
					alpha = (1 - ((aniData.posY-avgpos) / (diffpos - SCT_STEP)));
				else
					alpha = 1;
				end
			else
				startpos = SCT_TOP_POINT;
				endpos = SCT_BOTTOM_POINT;
				step = SCT_STEP * -1;
				if (aniData.posY < avgpos) then
					alpha = (1 - (((avgpos + SCT_STEP) - aniData.posY) / diffpos));
				else
					alpha = 1;
				end
			end
			
			if (alpha > 1) then
				alpha = 1;
			end

			alpha = alpha * SCT_Get("ALPHA");
					
			aniData.posY = aniData.posY + step;
			aniData.lastupdate = curtime;
			aniData.alpha = alpha;
			
			aniData.FObject:SetAlpha(aniData.alpha);
			aniData.FObject:SetPoint("CENTER", "UIParent", "CENTER", 0, aniData.posY);
			
			--if it reachs the end, reset
			if (SCT_Get("DIRECTION") == 0) then
				if (aniData.posY >= endpos) then
					SCT_aniReset(aniData);
				end
			else
				if (aniData.posY <= endpos) then
					SCT_aniReset(aniData);
				end
			end
		end
	end
end

----------------------
--count the number of crits active
function SCT_critCount()
	local count = 0
	
	for key, value in arrAniData do
		if (value.crit) then
			count = count + 1;
		end
	end
	
	return count;
end

----------------------
--get the min current min point
function SCT_MinPoint()	
	
	local posY;
	
	if (SCT_Get("DIRECTION") == 0) then
		posY = SCT_TOP_POINT;
		for key, value in arrAniData do
			if ((value.Active) and (value.posY < posY) and (not value.crit)) then
				posY = value.posY;
			end
		end
	else
		posY = SCT_BOTTOM_POINT;
		for key, value in arrAniData do
			if ((value.Active) and (value.posY > posY) and (not value.crit)) then
				posY = value.posY;
			end
		end
	end
	
	return posY;
end

----------------------
--Rest the text animation
function SCT_aniReset(aniData)	
	local startpos;
	if (SCT_Get("DIRECTION") == 0) then
		startpos = SCT_BOTTOM_POINT;
	else
		startpos = SCT_TOP_POINT;
	end
	
	aniData.Active = false;
	aniData.crit = false;
	aniData.posY = startpos;
	aniData.posX = 0;
	aniData.alpha = 0;
	
	aniData.FObject:SetAlpha(aniData.alpha);
	aniData.FObject:SetPoint("CENTER", "UIParent", "CENTER", aniData.posX, aniData.posY);
	
end

----------------------
--Rest all the text animations
function SCT_aniResetAll()
	
	for key, value in arrAniData do
		SCT_aniReset(value);
	end

end

----------------------
--Initial animation settings
function SCT_aniInit()

	for key, value in arrAniData do
		value.FObject = getglobal("SCT"..key);
		value.lastupdate = 0;
	end
	
	SCT_aniResetAll();
end

