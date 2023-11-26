--[[
 	Combat Caller
 	By Alex Brazie, modified by LedMirage to Insomniax Combat Caller v1.0
		**further modifications made by Reuben "Ascendant" Johnson to Insomniax Combat Caller v2.0**
	http://www.insomniax.net
	03/29/2005
	
	**Further modifications made by Ascendant**	
	**06/07/2005**
	
	**Modifications made: 6/7/2005
		**Added code to allow for user defined settings (per char, per realm) that save between sessions**
		**Added "slash" command handler**
		**Included ingame help file**
		**Allow user to customize how the CombatCaller makes its calls 
			(i.e. the ability to turn off the "OOM" and "HEALME" emotes and replace them with just the sound, a simple text emote, or both)**
			
	**Modifications made: 6/14/2005
		**Added /disable, /enable slash commands to /combatcaller parameter list**
		**Added error checking to prevent user from modifying settings while mod is disabled**
		**Fixed some chat confirmation errors when modifying settings**
		
	**Modifications made: 6/16/2005
		**Added check to code that updates variables if new variables are added to code
			(this allows the new variable(s) to be added without the user having to modify the SavedVariables.lua file to get the new variable)
		**Added 2 functions (IX_Initialize_Variables and IX_Add_Verify_Variables) to handle user variable initialization and update, as described in the above note

	- Automates Low-HP and Out-Of-Mana calls
  
]]

--[[	No longer needed - Ascendant
-- These will the the values with checkboxes
CombatCaller_HealthCall = true;
CombatCaller_ManaCall = true;
CombatCaller_Cooldown = true;

-- These will be the variable variables. ;)
CombatCaller_HealthRatio = .4;
CombatCaller_ManaRatio = .2;
CombatCaller_CooldownTime = 10;
]]

IX_Var_Loaded = false;		-- Toggle to determine if VARIABLES_LOADED event happened
IX_Mod_Loaded = false;		-- Toggle to determine if the mod has been loaded
IX_Play_Sound = false;		-- Toggle to determine if the "HEALME" or "OOM" emote sounds should play when the default emote is disabled

ThisCharRealm = nil;	-- Holds name of char and realm for accessing saved variables
ThisChar = nil;			-- Holds char name for use in output to user

DCF = DEFAULT_CHAT_FRAME;  -- I got lazy =p

-- Borrowed this function from another mod
local function Command_Capture(msg)
	-- used to separate the command from the parameter in the input string
	
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	
	if ( index ) then
	
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1, -1);
		
	else
	
		params = "";
		
	end
	
	return command, params;

end

function CombatCaller_OnLoad() 

	this:RegisterEvent("VARIABLES_LOADED");			-- Added by Ascendant
	this:RegisterEvent("UNIT_NAME_UPDATE");			-- Added by Ascendant
	this:RegisterEvent("PLAYER_ENTERING_WORLD");	-- Added by Ascendant
	
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	
	this.hp = -1;
	this.mana = -1;
	this.lasthp = -1;
	this.lastmana = -1;
	this.InCombat = 0;
	this.IsGhost = 0;
	this.LastHPShout = 0;
	this.LastManaShout = 0;

	-- Displays message at startup that the AddOn loaded (added by Ascendant)
	if(DCF) then
	
		DCF:AddMessage(IX_COMBATCALLER_VERSION.." "..IX_COMBATCALLER_LOADED);
		
	end
	
	UIErrorsFrame:AddMessage(IX_COMBATCALLER_VERSION..IX_COMBATCALLER_LOADED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	
	-- Registers slash commands to be used to modify settings ingame (added by Ascendant)	
	SLASH_COMBATCALLER1 = "/combatcaller";
	SlashCmdList["COMBATCALLER"] = function(msg)
		IX_CombatCaller_SlashCmdHandler(msg);
		
	end

end

function CombatCaller_OnEvent(event)

-- The following was added by Ascendant ***************************************************************************************************
	
	-- Gets called when variables are loaded
	if (event == "VARIABLES_LOADED") then 
	
		IX_Var_Loaded = true;

		if (not IX_Mod_Loaded) then
		
			ThisCharRealm = GetPlayerAndRealmNames();	-- gets current char and server names
			
			-- make sure we get a valid name before moving on			
			if ((ThisCharRealm ~= nil) and (ThisCharRealm ~= UNKNOWNOBJECT) and (ThisCharRealm ~= "unknown")) then
			
				IX_CombatCaller_Init();
				
			end		
			
		end
		
		return;	-- get out of event
		
	end
	
	-- Gets called when player's name gets changed or when entering the world
	if ((event == "UNIT_NAME_UPDATE") or (event == "PLAYER_ENTERING_WORLD")) then
	
		if (not IX_Mod_Loaded) then
		
			ThisCharRealm = GetPlayerAndRealmNames();	-- gets current char and server names
			
			-- make sure we get a valid name before moving on
			if ((ThisCharRealm ~= nil) and (ThisCharRealm ~= UNKNOWNOBJECT) and (ThisCharRealm ~= "unknown")) then
			
				IX_CombatCaller_Init();
				
			end		
			
		end
		
		return;	-- get out of event
		
	end
	
-- End of Ascendant's additions to code ***************************************************************************************************
	
	if ( UnitIsDeadOrGhost("player") ) then
	
		this.IsGhost = 1;
		
		return;
		
	elseif ( this.IsGhost == 1 ) then
	
		this.hp = UnitHealth("player");
		this.lasthp = this.hp;
		this.mana = UnitMana("player");
		this.lastmana = this.mana;
		this.IsGhost = 0;
		this.InCombat = 0;
		
		return;
		
	end
	
	if (event == "PLAYER_ENTER_COMBAT") then
	
		this.InCombat = 1;
		
	elseif (event == "PLAYER_LEAVE_COMBAT") then
	
		this.InCombat = 0;
		
	end
	
	if( this.InCombat == 0 ) then
	
		return;
		
	end
	
	if ( event == "UNIT_HEALTH" ) then
	
		local ratio = UnitHealth("player")/UnitHealthMax("player");
		local oldratio = this.lasthp/UnitHealthMax("player");
		
		if ( (this.hp < this.lasthp) and 
		     (ratio < IX_CombatCaller_Config[ThisCharRealm].HealthRatio) and							-- changed right side variable by Ascendant
		     (GetTime() - this.LastHPShout > IX_CombatCaller_Config[ThisCharRealm].CoolDown) and		-- changed right side variable by Ascendant
		     (oldratio > IX_CombatCaller_Config[ThisCharRealm].HealthRatio)) then						-- changed right side variable by Ascendant
			 
			CombatCaller_ShoutLowHealth();
			this.LastHPShout = GetTime();
			
		end
		
		this.lasthp = this.hp;
		this.hp = UnitHealth("player");
		
	end
	
	if ( event == "UNIT_MANA" ) then
	
		if(UnitPowerType("player") ~= 0) then
		
		  this.lastmana = 0;
		  
		else 
		
		  local ratio = UnitMana("player")/UnitManaMax("player");
		  local oldratio = this.lastmana/UnitManaMax("player");

		  if ( (this.mana < this.lastmana) and 
		       (ratio < IX_CombatCaller_Config[ThisCharRealm].ManaRatio) and								-- changed right side variable by Ascendant
		       (GetTime() - this.LastManaShout > IX_CombatCaller_Config[ThisCharRealm].CoolDown) and		-- changed right side variable by Ascendant 
		       (oldratio > IX_CombatCaller_Config[ThisCharRealm].ManaRatio) ) then							-- changed right side variable by Ascendant
			   
			CombatCaller_ShoutLowMana();
			this.LastManaShout = GetTime();
			
		  end
	  
		  this.lastmana = this.mana;
		  this.mana = UnitMana("player");
		  
		end
		
	end
	
end

function GetPlayerAndRealmNames() 
	-- Finds and returns Char name and Realm name to calling function
	
	local realmName = GetCVar("realmName");
	local playerName = UnitName("player");
	
	if ((playerName ~= nil) and (playerName ~= UNKNOWNOBJECT) and (playerName ~= UKNOWNBEING)) then
	
		ThisChar = playerName;
	
		return realmName.."-"..playerName;
		
	end
	
	return "unknown";
end

function IX_CombatCaller_Init()
	-- Function to initialize variables if they don't already exist
	
	-- Verifies that the AddOn mod has not already been loaded
	if (IX_Mod_Loaded == true) then
	
		return;
		
	end
	
	-- Ensures that "VARIABLES_LOADED" event has happened, if not, get out of this function
	if (IX_Var_Loaded == false) then
	
		return;
		
	end
	
	-- Checks to see if variable config has already been created, create it if it hasn't
	if ((not IX_CombatCaller_Config)) then
	
		IX_CombatCaller_Config	= {};
		
	end
	
	-- Verifies that this char has not already been initialized, proceeds to initialize variables if no entry for this char
	if (not IX_CombatCaller_Config[ThisCharRealm]) then
	
		IX_CombatCaller_Config[ThisCharRealm] 									= {};
			
		IX_Initialize_Variables();
			
	else
	
		IX_Add_Verify_Variables();
		
	end
	
	-- Inform user that this char's settings have  been loaded
	DCF:AddMessage(CC_SETTINGS_LOADED..ThisChar);
	UIErrorsFrame:AddMessage(CC_SETTINGS_LOADED..ThisChar, 1.0, 0.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	
	-- Sets AddOn mod loaded toggle
	IX_Mod_Loaded = true;
		
end

function IX_Initialize_Variables()
	-- Initialize this character
		
	if (IX_CombatCaller_Config[ThisCharRealm].CombatCaller == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].CombatCaller						= true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].HealthRatio == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthRatio						= HEALTH_RATIO;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaRatio == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaRatio							= MANA_RATIO;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].CoolDown == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].CoolDown							= COOL_DOWN;
		
	end

	if (IX_CombatCaller_Config[ThisCharRealm].HealthWatch == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthWatch 						= HEALTH_WATCH;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaWatch == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaWatch							= MANA_WATCH;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].HealthCall == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthCall						= HEALTH_CALL;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText 				= HEALTH_CALL_CUSTOM_TEXT;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaCall == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaCall							= MANA_CALL;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText 				= MANA_CALL_CUSTOM_TEXT;
		
	end
		
	if (IX_CombatCaller_Config[ThisCharRealm].Race == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].Race 								= UnitRace("player");
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Sex == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].Sex 								= UnitSex("player");
		
	end

	-- Inform user that this char has been added
	DCF:AddMessage(ThisChar..CC_SETTINGS_ADDED);

end

function IX_Add_Verify_Variables()
	-- Checks to make sure that the char has all correct variables, if not, initialize varaible with default values
		
	local bVarChange = false;
	
	if (IX_CombatCaller_Config[ThisCharRealm].CombatCaller == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].CombatCaller						= true;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].HealthRatio == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthRatio						= HEALTH_RATIO;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaRatio == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaRatio							= MANA_RATIO;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].CoolDown == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].CoolDown							= COOL_DOWN;
		bVarChange = true;
		
	end

	if (IX_CombatCaller_Config[ThisCharRealm].HealthWatch == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthWatch 						= HEALTH_WATCH;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaWatch == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaWatch							= MANA_WATCH;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].HealthCall == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthCall						= HEALTH_CALL;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText 				= HEALTH_CALL_CUSTOM_TEXT;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaCall == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaCall							= MANA_CALL;
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText 				= MANA_CALL_CUSTOM_TEXT;
		bVarChange = true;
		
	end
		
	if (IX_CombatCaller_Config[ThisCharRealm].Race == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].Race 								= UnitRace("player");
		bVarChange = true;
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Sex == nil) then
	
		IX_CombatCaller_Config[ThisCharRealm].Sex 								= UnitSex("player");
		bVarChange = true;
		
	end
	
	if (bVarChange) then
	
		DCF:AddMessage(VARIABLE_UPDATE);
		
	end

end

function CombatCaller_ShoutLowHealth()
	-- Controls calls for help with low health (below threshold)

	if ((IX_CombatCaller_Config[ThisCharRealm].HealthWatch == true) and (this.InCombat == 1)) then				-- changed variable reference
	
		if (IX_CombatCaller_Config[ThisCharRealm].HealthCall == true) then
			
			-- default emote
			DoEmote("HEALME");
			
		else
		
			-- if IX_PlaySound is true then play the sound
			if (IX_Play_Sound) then
					
				-- if char is male then play male sound, otherwise play female sound or a 'tell' sound ( <- shouldn't happen)
				if (IX_CombatCaller_Config[ThisCharRealm].Sex == 0) then		-- if male
				
					IX_PlaySoundMaleHealth();
					
				elseif (IX_CombatCaller_Config[ThisCharRealm].Sex == 1) then	-- if female
				
					IX_PlaySoundFemaleHealth();
					
				else
				
					PlaySound("TellMessage");
				
				end
				
			end
			
		end
			
		-- if user entered a custom text emote, write it
		if (IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText ~= HEALTH_CALL_CUSTOM_TEXT) then
			
			SendChatMessage(IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText, "EMOTE");
				
		end
		
	end
	
end

function CombatCaller_ShoutLowMana()
	-- Controlls calls for help with low mana (below threshold)
	
	if ((IX_CombatCaller_Config[ThisCharRealm].ManaWatch == true) and (this.InCombat == 1)) then				-- changed variable reference
	
		if (IX_CombatCaller_Config[ThisCharRealm].ManaCall == true) then

			DoEmote("OOM");
			
		else
			
			-- if IX_PlaySound is true then play the sound
			if (IX_Play_Sound) then
			
				-- if char is male then play male sound, otherwise play female sound or a 'tell message' sound ( <- shouldn't happen)
				if ((IX_CombatCaller_Config[ThisCharRealm].Sex == 0) or 
					(IX_CombatCaller_Config[ThisCharRealm].Sex == "male")) then		-- if male
				
					IX_PlaySoundMaleMana();
										
				elseif (IX_CombatCaller_Config[ThisCharRealm].Sex == 1) then	-- if female
				
					IX_PlaySoundFemaleMana();
					
				else
	
					PlaySound("TellMessage");
					
				end
				
			end
			
		end
		
		-- if user entered a custom text emote, write it
		if (IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText ~= MANA_CALL_CUSTOM_TEXT) then
			
			SendChatMessage(IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText, "EMOTE");
				
		end
		
	end
	
end

function IX_CombatCaller_SlashCmdHandler(msg)
	-- Controls how "slash" commands act
	
	msg = string.lower(msg);
	
	-- if nothing was entered after slash command then display help info
	if ((not msg) or (msg == "") or (strlen(msg) <= 0) or (strfind(msg, "help"))) then 
	
		IX_CombatCaller_HelpFile();
	
	elseif (strfind(msg, "disable")) then
		
		IX_CombatCaller_Config[ThisCharRealm].CombatCaller = false;
		IX_CombatCaller_Config[ThisCharRealm].HealthWatch = false;
		IX_CombatCaller_Config[ThisCharRealm].ManaWatch = false;
		DCF:AddMessage(COMBAT_CALLER_DISABLED);
		
	elseif (strfind(msg, "enable")) then
	
		IX_CombatCaller_Config[ThisCharRealm].CombatCaller = true;
		IX_CombatCaller_Config[ThisCharRealm].HealthWatch = true;
		IX_CombatCaller_Config[ThisCharRealm].ManaWatch = true;
		DCF:AddMessage(COMBAT_CALLER_ENABLED);
	
	else		
	
		-- call function to separate command and paramater and return values here
		command, param = Command_Capture(msg);
		
		-- convert command string to lower case
		if ((command) and (strlen(command)>0)) then		
		
			command = string.lower(command);	
			
		else		
		
			command = "";	
			
		end
		
		-- convert param string to lower case
		if ((param) and (strlen(param)>0)) then
		
			param = string.lower(param);
			
		else
		
			param = "";
			
		end
		
		-- Make sure the mod is enabled before changing any settings
		if (IX_CombatCaller_Config[ThisCharRealm].CombatCaller) then
		
			-- Handles user modification of Health Ratio (determines at what point CombatCaller calls out for health - parameter in tenths representing percent of 100)
			if ((strfind(command, "hr")) or (strfind(command, "healthratio"))) then	
				
				if ((param == "") or (param == nil) or (param == "help")) then
				
					IX_CombatCaller_HelpFile();
					
				elseif (param == "reset") then
				
					IX_CombatCaller_Config[ThisCharRealm].HealthRatio = HEALTH_RATIO;
					DCF:AddMessage(HEALTH_RATIO_RESET);
					
				else
				
					if (tonumber(param)) then
			
						param = string.format("%.1f", param);		
						
						param = tonumber(param);
						
						if ((param <= 1) and (param > 0)) then		
						
							IX_CombatCaller_Config[ThisCharRealm].HealthRatio = param;
							DCF:AddMessage(HEALTH_RATIO_UPDATE..param.." or "..(IX_CombatCaller_Config[ThisCharRealm].HealthRatio*100).."%".." for "..ThisChar..".");		
							
						else				
						
							DCF:AddMessage(ERROR_WRONG_VALUE);
						
						end
						
					else
					
						DCF:AddMessage(ERROR_WRONG_VALUE);
						
					end
					
				end
			
			-- Handles user modification of Mana Ratio (Determines at what point CombatCaller calls out for mana - parameter in tenths representing percent of 100)
			elseif ((strfind(command, "mr")) or (strfind(command, "manaratio"))) then
	
				if ((param == "") or (param == nil) or (param == "help")) then
				
					IX_CombatCaller_HelpFile();
					
				elseif (param == "reset") then
				
					IX_CombatCaller_Config[ThisCharRealm].ManaRatio = MANA_RATIO;
					DCF:AddMessage(MANA_RATIO_RESET);
				
				else
				
					if (tonumber(param)) then
			
						param = string.format("%.1f", param);		
						
						param = tonumber(param);
					
						if ((param <= 1) and (param > 0)) then		
						
							IX_CombatCaller_Config[ThisCharRealm].ManaRatio = param;
							DCF:AddMessage(MANA_RATIO_UPDATE..param.." or "..(IX_CombatCaller_Config[ThisCharRealm].ManaRatio*100).."%".." for "..ThisChar..".");		
							
						else				
						
							DCF:AddMessage(ERROR_WRONG_VALUE);	
							
						end
						
					else
					
						DCF:AddMessage(ERROR_WRONG_VALUE);
						
					end
					
				end
			
			-- Handles user modification of Cool Down (Allows user to set how much time elapses between CombatCaller's calls for health or mana - in seconds)
			elseif ((strfind(command, "cd")) or (strfind(command, "cooldown")) or (strfind(command, "cooldowntime"))) then		
				
				if ((param == "") or (param == nil) or (param == "help")) then
				
					IX_CombatCaller_HelpFile();
					
				else
				
					if (tonumber(param)) then
					
						param = string.format("%02d", param);		
						
						param = tonumber(param);
						
						if ((param <= 30) and (param > 5)) then		
						
							IX_CombatCaller_Config[ThisCharRealm].CoolDown = param;
							DCF:AddMessage(COOL_DOWN_UPDATE..param.." seconds for "..ThisChar);		
							
						else				
						
							DCF:AddMessage(ERROR_COOLDOWN);
							
						end
						
					else
					
						DCF:AddMessage(ERROR_COOLDOWN);
						
					end
					
				end
			
			-- Handles user modification of Health On (Enables/Disables CombatCaller's calls for health)
			elseif (strfind(command, "healthwatch")) then
			
				if ((param == "") or (param == nil) or (param == "help")) then
				
					IX_CombatCaller_HelpFile();
					
				else
			
					if ((param == "on") or (param == "enable")) then
					
						param_result = true;				
						IX_CombatCaller_Config[ThisCharRealm].HealthWatch = param_result;
						
						if (param == "on") then
						
							DCF:AddMessage(HEALTH_MONITOR_UPDATE.."turned on for "..ThisChar);
						
						elseif (param == "enable") then
		
							DCF:AddMessage(HEALTH_MONITOR_UPDATE.."enabled for "..ThisChar);
							
						end
					
					elseif ((param == "off") or (param == "disable")) then
					
						param_result = false;			
						IX_CombatCaller_Config[ThisCharRealm].HealthWatch = param_result;
						
						if (param == "off") then				
		
							DCF:AddMessage(HEALTH_MONITOR_UPDATE.."turned off for "..ThisChar);
						
						elseif (param == "disable") then
						
							DCF:AddMessage(HEALTH_MONITOR_UPDATE.."disabled for "..ThisChar);
							
						end
					
					else				
					
						DCF:AddMessage(ERROR_HEALTH_MANA_MONITOR);
						
					end
					
				end
			
			-- Handles user modification of Mana On (Enables/Disables CombatCaller's calls for mana)
			elseif (strfind(command, "manawatch")) then	
	
				if ((param == "") or (param == nil) or (param == "help")) then
				
					IX_CombatCaller_HelpFile();
					
				else
						
					if ((param == "on") or (param == "enable")) then
					
						param_result = true;
					
						IX_CombatCaller_Config[ThisCharRealm].ManaWatch = param_result;
		
						if (param == "on") then
						
							DCF:AddMessage(MANA_MONITOR_UPDATE.."turned on for "..ThisChar);
						
						elseif (param == "enable") then
		
							DCF:AddMessage(MANA_MONITOR_UPDATE.."enabled for "..ThisChar);
							
						end
					
					elseif ((param == "off") or (param == "disable")) then
					
						param_result = false;
					
						IX_CombatCaller_Config[ThisCharRealm].ManaWatch = param_result;
		
						if (param == "off") then
						
							DCF:AddMessage(MANA_MONITOR_UPDATE.."turned off for "..ThisChar);
						
						elseif (param == "disable") then
		
							DCF:AddMessage(MANA_MONITOR_UPDATE.."disabled for "..ThisChar);
							
						end
					
					else				
					
						DCF:AddMessage(ERROR_HEALTH_MANA_MONITOR);
						
					end
				
				end
			
			-- Handles user modification of Health Call (Allows user to determine what to show in chat when calling for health, defaults to "/HEALME" emote)
			elseif (strfind(command, "healthcall")) then
				
				if ((param == "") or (param == nil) or (param == "help")) then
	
					IX_CombatCaller_HelpFile();
					
				elseif (param == "reset") then
				-- sets CombatCaller to default "HEALME" emote
					
					IX_Play_Sound = false;
					IX_CombatCaller_Config[ThisCharRealm].HealthCall = true;
					IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText = HEALTH_CALL_CUSTOM_TEXT;
					DCF:AddMessage(HEALTH_EMOTE_STATUS);
					
				elseif (strfind(param, "customcall")) then
				
					Custom_Command, Custom_Param = Command_Capture(param);
					
					if ((Custom_Command == "customcall") and (strfind (Custom_Param, "reset"))) then
					-- resets Custom emote/sounds to default, basically re-enables default "HEALME" emote
					
						IX_Play_Sound = false;
						IX_CombatCaller_Config[ThisCharRealm].HealthCall = true;
						IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText = HEALTH_CALL_CUSTOM_TEXT;
						DCF:AddMessage(CUSTOM_CALL_RESET);
						
					elseif ((Custom_Command == "customcall") and (strfind (Custom_Param, "soundonly"))) then
					-- plays "HEALME" emote sound only, no text emote
						
						IX_Play_Sound = true;
						IX_CombatCaller_Config[ThisCharRealm].HealthCall = false;
						IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText = HEALTH_CALL_CUSTOM_TEXT;
						DCF:AddMessage(CUSTOM_CALL_SOUND_ONLY_HEAL);
						
					elseif ((Custom_Command == "customcall") and (strfind(Custom_Param, "soundtext"))) then
					
						Custom_SoundCommand, Custom_SoundParam = Command_Capture(Custom_Param);
						
						if ((Custom_SoundCommand == "soundtext") and (Custom_SoundParam ~= "help")) then
						-- plays "HEALME" sound and sets custom text emote
							
							IX_Play_Sound = true;
							IX_CombatCaller_Config[ThisCharRealm].HealthCall = false;
							IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText = Custom_SoundParam;
							DCF:AddMessage(CUSTOM_CALL_SOUND_TEXT_HEAL);
							SendChatMessage(IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText, "EMOTE");
							
						else
						
							IX_CombatCaller_HelpFile();
						
						end
					
					elseif ((Custom_Command == "customcall") and (Custom_Param ~= "reset") and 
						(Custom_Param ~= "soundonly") and (not strfind(Custom_Param, "soundtext")) and 
							(Custom_Param ~= "") and (Custom_Param ~= "help")) then
						-- sets custom emote text and disables all sounds
							
								IX_Play_Sound = false;
								IX_CombatCaller_Config[ThisCharRealm].HealthCall = false;
								IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText = Custom_Param;
								DCF:AddMessage(CUSTOM_CALL_TEXT_ONLY);
								SendChatMessage(IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText, "EMOTE");
							
					else
					
						IX_CombatCaller_HelpFile();
					
					end
					
				else
				
					IX_CombatCaller_HelpFile();
				
				end
				
			-- Handles user modification of Mana Call (Allows user to determine what to show in chat when calling for mana, defaults to "/OOM" emote)
			elseif (strfind(command, "manacall")) then
				
				if ((param == "") or (param == nil) or (param == "help")) then
	
					IX_CombatCaller_HelpFile();
					
				elseif (param == "reset") then
				-- sets CombatCaller to default "OOM" emote
					
					IX_Play_Sound = false;
					IX_CombatCaller_Config[ThisCharRealm].ManaCall = true;
					IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText = MANA_CALL_CUSTOM_TEXT;
					DCF:AddMessage(MANA_EMOTE_STATUS);
					
				elseif (strfind(param, "customcall")) then
				
					Custom_Command, Custom_Param = Command_Capture(param);
					
					if ((Custom_Command == "customcall") and (strfind (Custom_Param, "reset"))) then
					-- resets Custom emote/sounds to default, basically re-enables default "OOM" emote
					
						IX_Play_Sound = false;
						IX_CombatCaller_Config[ThisCharRealm].ManaCall = true;
						IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText = MANA_CALL_CUSTOM_TEXT;
						DCF:AddMessage(CUSTOM_CALL_RESET);
						
					elseif ((Custom_Command == "customcall") and (strfind (Custom_Param, "soundonly"))) then
					-- plays "OOM" emote sound only, no text emote
						
						IX_Play_Sound = true;
						IX_CombatCaller_Config[ThisCharRealm].ManaCall = false;
						IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText = MANA_CALL_CUSTOM_TEXT;
						DCF:AddMessage(CUSTOM_CALL_SOUND_ONLY_MANA);
						
					elseif ((Custom_Command == "customcall") and (strfind(Custom_Param, "soundtext"))) then
					
						Custom_SoundCommand, Custom_SoundParam = Command_Capture(Custom_Param);
						
						if ((Custom_SoundCommand == "soundtext")  and (Custom_SoundCommand ~= "help"))then
						-- plays "OOM" sound and sets custom text emote
							
							IX_Play_Sound = true;
							IX_CombatCaller_Config[ThisCharRealm].ManaCall = false;
							IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText = Custom_SoundParam;
							DCF:AddMessage(CUSTOM_CALL_SOUND_TEXT_MANA);
							SendChatMessage(IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText, "EMOTE");
							
						else
						
							IX_CombatCaller_HelpFile();
						
						end
					
					elseif ((Custom_Command == "customcall") and (Custom_Param ~= "reset") and 
						(Custom_Param ~= "soundonly") and (not strfind(Custom_Param, "soundtext")) and
							(Custom_Param ~= "") and (Custom_Param ~= "help")) then
						-- sets custom emote text and disables all sounds
							
								IX_Play_Sound = false;
								IX_CombatCaller_Config[ThisCharRealm].ManaCall = false;
								IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText = Custom_Param;
								DCF:AddMessage(CUSTOM_CALL_TEXT_ONLY);
								SendChatMessage(IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText, "EMOTE");
							
					else
					
						IX_CombatCaller_HelpFile();
					
					end
					
				else
				
					IX_CombatCaller_HelpFile();				
					
				end
		
			elseif (strfind(command, "reset")) then
			-- resets default CombatCaller settings
			
				IX_CombatCaller_Reset();
				DCF:AddMessage(CC_SETTINGS_RESET..ThisChar);
				
			elseif (strfind(command, "default")) then
			-- displays default CombatCaller settings
			
				IX_CombatCaller_Default();
				
			elseif (strfind(command, "display")) then
			-- displays current user's settings
			
				IX_CombatCaller_Display();
				
			else
			
				DCF:AddMessage(ERROR_GENERAL);
			
			end
			
		else
		
			DCF:AddMessage(ENABLE_BEFORE_CHANGE);
			
		end
		
		if (IX_CombatCaller_Config[ThisCharRealm].CombatCaller) then
		-- if the mod is already don't disable it again
		
			-- if healthwatch and manawatch have both been disabled, then disable mod all together
			if ((not IX_CombatCaller_Config[ThisCharRealm].HealthWatch) and (not IX_CombatCaller_Config[ThisCharRealm].ManaWatch)) then
			
				IX_CombatCaller_Config[ThisCharRealm].CombatCaller = false;
				DCF:AddMessage(COMBAT_CALLER_DISABLED);
				
			end
			
		end
		
	end
	
end

function IX_CombatCaller_Reset()
	-- Reset all variables to default
		
	IX_CombatCaller_Config[ThisCharRealm].CombatCaller 			= COMBAT_CALLER;
	IX_CombatCaller_Config[ThisCharRealm].HealthRatio 			= HEALTH_RATIO;
	IX_CombatCaller_Config[ThisCharRealm].ManaRatio 			= MANA_RATIO;
	IX_CombatCaller_Config[ThisCharRealm].CoolDown				= COOL_DOWN;
	IX_CombatCaller_Config[ThisCharRealm].HealthWatch			= HEALTH_WATCH;
	IX_CombatCaller_Config[ThisCharRealm].ManaWatch				= MANA_WATCH;
	IX_CombatCaller_Config[ThisCharRealm].HealthCall			= HEALTH_CALL;
	IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText	= HEALTH_CALL_CUSTOM_TEXT;
	IX_CombatCaller_Config[ThisCharRealm].ManaCall				= MANA_CALL;
	IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText	= MANA_CALL_CUSTOM_TEXT;
	IX_Play_Sound 												= false;

end

function IX_CombatCaller_Default()

	DCF:AddMessgae(DEFAULT_CC_ONOFF);
	DCF:AddMessage(DEFAULT_COMBAT_CALLER);
	DCF:AddMessage(DEFAULT_HEALTH_RATIO);
	DCF:AddMessage(DEFAULT_MANA_RATIO);
	DCF:AddMessage(DEFAULT_COOL_DOWN);
	DCF:AddMessage(DEFAULT_HEALTH_WATCH);
	DCF:AddMessage(DEFAULT_MANA_WATCH);
	DCF:AddMessage(DEFAULT_HEALTH_CALL);
	DCF:AddMessage(DEFAULT_HEALTH_CALL_CUSTOM_TEXT);
	DCF:AddMessage(DEFAULT_MANA_CALL);
	DCF:AddMessage(DEFAULT_MANA_CALL_CUSTOM_TEXT);
	
end

function IX_CombatCaller_Display()
	-- Disply current user settings
	
	-- if mod is enabled display current settings
	if (IX_CombatCaller_Config[ThisCharRealm].CombatCaller) then
	
		DCF:AddMessage(DISPLAY_USER_SETTINGS..ThisChar);
		DCF:AddMessage(DISPLAY_COMBAT_CALLER);
		DCF:AddMessage(DISPLAY_HEALTH_RATIO..IX_CombatCaller_Config[ThisCharRealm].HealthRatio.." or "..(IX_CombatCaller_Config[ThisCharRealm].HealthRatio*100).."%.");
		DCF:AddMessage(DISPLAY_MANA_RATIO..IX_CombatCaller_Config[ThisCharRealm].ManaRatio.." or "..(IX_CombatCaller_Config[ThisCharRealm].ManaRatio*100).."%.");
		DCF:AddMessage(DISPLAY_COOL_DOWN..IX_CombatCaller_Config[ThisCharRealm].CoolDown);
		
		if (IX_CombatCaller_Config[ThisCharRealm].HealthWatch) then
			DCF:AddMessage(DISPLAY_HEALTH_WATCH.."enabled.");
		else
			DCF:AddMessage(DISPLAY_HEALTH_WATCH.."disabled.");
		end
		
		if (IX_CombatCaller_Config[ThisCharRealm].ManaWatch) then
			DCF:AddMessage(DISPLAY_MANA_WATCH.."enabled.");
		else
			DCF:AddMessage(DISPLAY_MANA_WATCH.."disabled.");
		end
		
		if (IX_CombatCaller_Config[ThisCharRealm].HealthCall) then
			DCF:AddMessage(DISPLAY_HEALTH_CALL.."enabled.");
		else
			DCF:AddMessage(DISPLAY_HEALTH_CALL.."disabled.");
		end
		
		if (IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText == HEALTH_CALL_CUSTOM_TEXT) then
			DCF:AddMessage(DISPLAY_HEALTH_CALL_CUSTOM_TEXT.."disabled.");
		else
			DCF:AddMessage(DISPLAY_HEALTH_CALL_CUSTOM_TEXT..IX_CombatCaller_Config[ThisCharRealm].HealthCallCustomText);
		end
		
		if (IX_CombatCaller_Config[ThisCharRealm].ManaCall) then
			DCF:AddMessage(DISPLAY_MANA_CALL.."enabled.");
		else
			DCF:AddMessage(DISPLAY_MANA_CALL.."disabled.");
		end
		
		if (IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText == MANA_CALL_CUSTOM_TEXT) then
			DCF:AddMessage(DISPLAY_MANA_CALL_CUSTOM_TEXT.."disabled.");
		else
			DCF:AddMessage(DISPLAY_MANA_CALL_CUSTOM_TEXT..IX_CombatCaller_Config[ThisCharRealm].ManaCallCustomText);
		end
	
	else
	
		DCF:AddMessage(ENABLE_BEFORE_CHANGE);
		
	end

end

function IX_CombatCaller_HelpFile()

	DCF:AddMessage(IX_HELP_FILE);
	DCF:AddMessage(HELP_COMBATCALLER);
	DCF:AddMessage(HELP_HEALTH_RATIO);
	DCF:AddMessage(HELP_MANA_RATIO);
	DCF:AddMessage(HELP_COOL_DOWN);
	DCF:AddMessage(HELP_HEALTH_WATCH);
	DCF:AddMessage(HELP_MANA_WATCH);
	DCF:AddMessage(HELP_HEALTH_CALL);
	DCF:AddMessage(HELP_HEALTH_CALL_CUSTOM_TEXT);
	DCF:AddMessage(HELP_HEALTH_CALL_CUSTOM_TEXT1);
	DCF:AddMessage(HELP_HEALTH_CALL_CUSTOM_TEXT2);
	DCF:AddMessage(HELP_MANA_CALL);
	DCF:AddMessage(HELP_MANA_CALL_CUSTOM_TEXT);
	DCF:AddMessage(HELP_MANA_CALL_CUSTOM_TEXT1);
	DCF:AddMessage(HELP_MANA_CALL_CUSTOM_TEXT2);
	DCF:AddMessage(HELP_RESET);
	DCF:AddMessage(HELP_DEFAULT);
	DCF:AddMessage(HELP_DISPLAY);

end

--[[

The following functions were never called to begin with, but were here anyway

function CombatCaller_OnHealthConfigUpdate(toggle, value) 
	if ( toggle == 0 ) then
		CombatCaller_HealthCall = false;
	else 
		CombatCaller_HealthCall = true;
		CombatCaller_HealthRatio = value;
	end
end

function CombatCaller_OnManaConfigUpdate(toggle, value) 
	if ( toggle == 0 ) then
		CombatCaller_ManaCall = false;
	else 
		CombatCaller_ManaCall = true;
		CombatCaller_ManaRatio = value;
	end
end

function CombatCaller_OnCooldownUpdate(toggle, value) 
	if ( toggle == 0 ) then
		CombatCaller_Cooldown = false;
		CombatCaller_CooldownTime = 0;
	else 
		CombatCaller_Cooldown = true; 
		CombatCaller_CooldownTime = value;
	end
end

function CombatCaller_TurnOff()
	CombatCaller_HealthCall = false;
	CombatCaller_ManaCall = false;
end

function CombatCaller_TurnOn()
	CombatCaller_HealthCall = true;
	CombatCaller_ManaCall = true;
end

]]


	
