
-- CVar Keywords
CSM_CVARNAME = "cvarname";
CSM_CVARVALUE= "cvarval";
CSM_CVARCALLBACK = "callback";
COS_LAST_PLAYER = "cos_last_player";
COS_LAST_REALM = "cos_last_realm";


CosmosMaster_CVars = { };
CosmosMaster_CVarsToRegister = { };
CosmosMaster_CVarsToSet = { };
CosmosMaster_Callbacks = { };
RegisterForSave('CosmosMaster_CVars');

-- Debug tools
COSMOSMASTER_DEBUG_CVAR = 0;
CSM_DEBUG_CVAR = "COSMOSMASTER_DEBUG_CVAR";

	--[[
		CosmosMaster_RegisterCVar

		Usage: 
		CosmosMaster_RegisterCVar(cos_cvar, [cos_defvalue, cos_callback ])

		cos_cvar is the "COS_CVAR_NAME" you used to use. 
		cos_defvalue is the default value you're storing.
		cos_callback will be called when the cvars are loaded
		
		
	]]
function Cosmos_RegisterCVar (cos_cvar, cos_defvalue, cos_callback)
	Sea.io.dprint( CSM_DEBUG_CVAR, "REGISTER: "..cos_cvar);
	
	if ( cos_cvar == nil ) then return false; end
	if ( cos_defvalue == nil) then cos_defvalue = 0; end
	if ( cos_callback ) then
		CosmosMaster_Callbacks[this:GetName()] = cos_callback;
	end
	
	playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT )) then
		if (CosmosMaster_CVarsToRegister[cos_cvar] == nil) then
			CosmosMaster_CVarsToRegister[cos_cvar] = cos_defvalue;
		end
		return false;
	end

	local realmname = GetCVar("realmName");
	if ( CosmosMaster_CVars[realmname] == nil ) then 
		CosmosMaster_CVars[realmname]={};
	end
	if ( CosmosMaster_CVars[realmname][playername] == nil ) then 
		CosmosMaster_CVars[realmname][playername]={};
	end
	local var = Cosmos_GetCVar(cos_cvar);
	if (var) then
		CosmosMaster_CVars[realmname][playername][cos_cvar] = var;
	else
		CosmosMaster_CVars[realmname][playername][cos_cvar] = cos_defvalue;
	end

	return true;
end

-- The Cosmos own 
function Cosmos_SetCVar ( cos_cvar, cos_value)
	if ( cos_cvar == nil ) then return false; end
	if(not cos_value) then
	  cos_value = "0";
	end
	if (isTable(cos_value)) then
		Sea.io.dprint( CSM_DEBUG_CVAR, "SET: ",cos_cvar," table");
	else
		Sea.io.dprint( CSM_DEBUG_CVAR, "SET: ",cos_cvar,' ',cos_value);
	end

	playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT )) then
		CosmosMaster_CVarsToSet[cos_cvar] = cos_value;
		return false;
	end
	
	local realmname = GetCVar("realmName");
	if ( CosmosMaster_CVars[realmname] == nil ) then 
		CosmosMaster_CVars[realmname]={};
	end
	if ( CosmosMaster_CVars[realmname][playername] == nil ) then 
		CosmosMaster_CVars[realmname][playername]={};
	end
	CosmosMaster_CVars[realmname][playername][cos_cvar] = cos_value;
end

-- Fakes the GetCVar command
function Cosmos_GetCVar ( cos_cvar )
	Sea.io.dprint( CSM_DEBUG_CVAR,"GET:", cos_cvar);
	if ( cos_cvar == nil ) then return nil; end

	playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT )) then return nil; end

	--Sea.io.dprint(  CSM_DEBUG_CVAR, "GET: VALUE "..CosmosMaster_CVars[cos_cvar] );
	
	local realmname = GetCVar("realmName");
	--Check if variable exists on current realm/player
	if (isTable(CosmosMaster_CVars[realmname]) and isTable(CosmosMaster_CVars[realmname][playername]) and CosmosMaster_CVars[realmname][playername][cos_cvar]) then
		return CosmosMaster_CVars[realmname][playername][cos_cvar];
	end
	--Check if variable exists on last realm, current player
	if (CosmosMaster_LastRealm and isTable(CosmosMaster_CVars[CosmosMaster_LastRealm]) and isTable(CosmosMaster_CVars[CosmosMaster_LastRealm][playername]) and CosmosMaster_CVars[CosmosMaster_LastRealm][playername][cos_cvar]) then
		return CosmosMaster_CVars[CosmosMaster_LastRealm][playername][cos_cvar];
	end	
	--Check if variable exists on any realm, current player
	for curRealm in CosmosMaster_CVars do
		if (isTable(CosmosMaster_CVars[curRealm]) and isTable(CosmosMaster_CVars[curRealm][playername]) and CosmosMaster_CVars[curRealm][playername][cos_cvar]) then
			return CosmosMaster_CVars[curRealm][playername][cos_cvar];
		end	
	end
	--Check if current player exists in old format
	if (isTable(CosmosMaster_CVars[playername]) and CosmosMaster_CVars[playername][cos_cvar]) then
		return CosmosMaster_CVars[playername][cos_cvar];
	end	
	--Check if variable exists on last realm, last player
	if (CosmosMaster_LastRealm and CosmosMaster_LastPlayer and isTable(CosmosMaster_CVars[CosmosMaster_LastRealm]) and isTable(CosmosMaster_CVars[CosmosMaster_LastRealm][CosmosMaster_LastPlayer]) and CosmosMaster_CVars[CosmosMaster_LastRealm][CosmosMaster_LastPlayer][cos_cvar]) then
		return CosmosMaster_CVars[CosmosMaster_LastRealm][CosmosMaster_LastPlayer][cos_cvar];
	end	
	--Check if variable exists on cur realm, any player
	if (isTable(CosmosMaster_CVars[realmname])) then
		for curPlayer in CosmosMaster_CVars[realmname] do
			if (isTable(CosmosMaster_CVars[realmname][curPlayer]) and CosmosMaster_CVars[realmname][curPlayer][cos_cvar]) then
				return CosmosMaster_CVars[realmname][curPlayer][cos_cvar];
			end	
		end
	end
	--Check if variable exists on any realm, any player
	for curRealm in CosmosMaster_CVars do
		if (isTable(CosmosMaster_CVars[curRealm])) then
			for curPlayer in CosmosMaster_CVars[curRealm] do
				if (isTable(CosmosMaster_CVars[curRealm][curPlayer]) and CosmosMaster_CVars[curRealm][curPlayer][cos_cvar]) then
					return CosmosMaster_CVars[curRealm][curPlayer][cos_cvar];
				end	
			end
		end
	end	
	--Check if previous player exists in old format
	if (CosmosMaster_LastPlayer and isTable(CosmosMaster_CVars[CosmosMaster_LastPlayer]) and CosmosMaster_CVars[CosmosMaster_LastPlayer][cos_cvar]) then
		return CosmosMaster_CVars[CosmosMaster_LastPlayer][cos_cvar];
	end
	--Check if var exists on any player in old format
	for curPlayer in CosmosMaster_CVars do
		if (isTable(CosmosMaster_CVars[curPlayer]) and CosmosMaster_CVars[curPlayer][cos_cvar]) then
			return CosmosMaster_CVars[curPlayer][cos_cvar];
		end	
	end
	--Check if var exists in really old format
	if (CosmosMaster_CVars[cos_cvar]) then
		return CosmosMaster_CVars[cos_cvar];
	end
	--Give up
	return nil;
end

function Cosmos_RegisterMissed ()
	playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT )) then return false;	end

	for cos_cvar, cos_defvalue in CosmosMaster_CVarsToRegister do
		Cosmos_RegisterCVar(cos_cvar, cos_defvalue);
		CosmosMaster_CVarsToRegister[cos_cvar] = nil;
	end
	
	return true;
end

function Cosmos_SetMissed ()
	playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT )) then return false;	end

	for cos_cvar, cos_value in CosmosMaster_CVarsToSet do
		Cosmos_SetCVar(cos_cvar, cos_value);
		CosmosMaster_CVarsToSet[cos_cvar] = nil;
	end
	
	return true;
end

function Cosmos_RegisterVarsLoaded (cos_callback)
	if ( cos_callback ) then
		CosmosMaster_Callbacks[this:GetName()] = cos_callback;
	end
end

function Cosmos_CallVarsLoaded ()
	playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT )) then return false;	end

	for cos_mod, cos_func in CosmosMaster_Callbacks do
		if (cos_func) then
-----------------------------------------------------------------------
--WARNING WARNING WARNING we are chaning this so that the called-------
--function will behave normalish, but this could be dangerous----------
-----------------------------------------------------------------------
			--Store old this
			local curThis = this;
			--If we got a good something to set this to, then do it
			if (getglobal(cos_mod)) then
				this = getglobal(cos_mod);
			end
			--Call the function
			cos_func();
			--Reset this
			this = curThis;
		end
	end
	
	return true;
end

COSMOS_SETTINGS_CLASS_PREFIX = "CLASS_DEFAULT_SETTING_";

-- this saves default settings for a certain class
-- it is recommended that CosmosMaster_StoreVariables() is called prior to 
-- this function so that the CVars contain the latest info, but...
function Cosmos_SaveDefaultSettingsForClass(className)
	if ( not className ) then
		className = UnitClass("player");
	end
	local playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT ) or ( not className ) ) then
		return false;
	end

	if ( CosmosMaster_CVars[playername] == nil ) then 
		CosmosMaster_CVars[playername]={};
	end
	
	local cvarIndex = COSMOS_SETTINGS_CLASS_PREFIX..className;
	
	if ( CosmosMaster_CVars[cvarIndex] == nil ) then 
		CosmosMaster_CVars[cvarIndex]={};
	end
	
	for k, v in CosmosMaster_CVars[playername] do
		CosmosMaster_CVars[cvarIndex][k] = v;
	end
	return true;
end	

-- this loads default settings for a certain class
-- it is recommended that CosmosMaster_LoadVariables() is called after this 
-- function so that the system contains the latest info, but...
function Cosmos_LoadDefaultSettingsForClass(className)
	if ( not className ) then
		className = UnitClass("player");
	end
	local playername = UnitName("player");
	if (( playername == nil ) or ( playername == UKNOWNBEING ) or ( playername == UNKNOWNOBJECT ) or ( not className ) ) then
		return false;
	end

	if ( CosmosMaster_CVars[playername] == nil ) then 
		CosmosMaster_CVars[playername]={};
	end
	
	local cvarIndex = COSMOS_SETTINGS_CLASS_PREFIX..className;
	
	if ( CosmosMaster_CVars[cvarIndex] == nil ) then 
		CosmosMaster_CVars[cvarIndex]={};
	end
	
	for k, v in CosmosMaster_CVars[cvarIndex] do
		CosmosMaster_CVars[playername][k] = v;
	end
	return true;
end	

--[[
  
  Everything below this point is a helper function. 
  
  You shouldn't have to call any of these.
  
  ]]--

function PrintCvars()
	PrintTable(CosmosMaster_CVars, "CosmosMaster_CVars");
end
	
function pcv ()
	DEFAULT_CHAT_FRAME=ChatFrame1;
	PrintCvars();
end
