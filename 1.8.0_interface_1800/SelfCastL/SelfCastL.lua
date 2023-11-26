
-- Title: SelfCastL v0.3
-- Notes: Supports auto self-targeting for beneficial spells.  Use /selfcast help for a helpful list of commands.
-- Author: lua@lumpn.de

--	SelfCastL: Adds self-targeting, either by use of the alt key or automatically
--		original code by Telo
--		modified by LumpN
	
--	* If self-targeting is enabled, positive spells cast without a friendly target will
--	  automatically target the player
--	* Otherwise, if alt-casting is enabled, holding the alt key when activating a
--	  button will target the player


-- all commands get converted to lowercase
SELFCAST_HELP = "help";				-- displays help
SELFCAST_STATUS = "status";		-- shows status
SELFCAST_ON = "on";						-- for historical reasons, turns self-targeting on, same as selfon
SELFCAST_OFF = "off";					-- for historical reasons, turns self-targeting off, same as selfoff
SELFCAST_SELF = "self";				-- toggles self-targeting
SELFCAST_SELFON = "selfon";		-- turns self-targeting on
SELFCAST_SELFOFF = "selfoff";	-- turns self-targeting off
SELFCAST_ALT = "alt";					-- toggles alt-casting
SELFCAST_ALTON = "alton";			-- turns alt-casting on
SELFCAST_ALTOFF = "altoff";		-- turns alt-casting off

SELFCAST_STATUS_LOADED = "|cffffff00SelfCastL loaded|r";
SELFCAST_STATUS_HEADER = "|cffffff00SelfCastL status:|r";
SELFCAST_STATUS_SELF = " Auto self-casting is ";
SELFCAST_STATUS_ALT = " Alt self-casting is ";
SELFCAST_STATUS_ON = "|cff00ff00on|r";
SELFCAST_STATUS_OFF = "|cffff0000off|r";

SELFCAST_HELP_INVALID = "|cffffff00SelfCastL command not found.|r Use |cff00ffff/selfcast help|r for additional information.";
SELFCAST_HELP_TEXT0 = "|cffffff00SelfCast command help:|r";
SELFCAST_HELP_TEXT1 = "Use |cff00ffff/selfcast <command>|r or |cff00ffff/sc <command>|r| to perform the following commands:";
SELFCAST_HELP_TEXT2 = "|cff00ffff"..SELFCAST_HELP.."|r: displays this message.";
SELFCAST_HELP_TEXT3 = "|cff00ffff"..SELFCAST_STATUS.."|r: displays status information about the current option settings.";
SELFCAST_HELP_TEXT4 = "|cff00ffff"..SELFCAST_SELF.."|r: toggles on auto self casting.";
SELFCAST_HELP_TEXT5 = "|cff00ffff"..SELFCAST_SELFON.."|r: turns on auto self casting.";
SELFCAST_HELP_TEXT6 = "|cff00ffff"..SELFCAST_SELFOFF.."|r: turns off auto self casting.";
SELFCAST_HELP_TEXT7 = "|cff00ffff"..SELFCAST_ALT.."|r: toggles Alt-casting.";
SELFCAST_HELP_TEXT8 = "|cff00ffff"..SELFCAST_ALTON.."|r: turns on Alt-casting.";
SELFCAST_HELP_TEXT9 = "|cff00ffff"..SELFCAST_ALTOFF.."|r: turns off Alt-casting.";


--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Function hooks
local lOriginal_UseAction;


--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

local function SelfCastLStatusToString(x)
	if (x) then
		return SELFCAST_STATUS_ON;
	else
		return SELFCAST_STATUS_OFF;
	end
end

local function SelfCastLStatus()
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(SELFCAST_STATUS_HEADER);
		if (SelfCastLState) then
			DEFAULT_CHAT_FRAME:AddMessage(SELFCAST_STATUS_SELF..SelfCastLStatusToString(SelfCastLState.AutoSelfCast));
			DEFAULT_CHAT_FRAME:AddMessage(SELFCAST_STATUS_ALT..SelfCastLStatusToString(SelfCastLState.AltCast));
		else
			DEFAULT_CHAT_FRAME:AddMessage(SELFCAST_STATUS_SELF..SELFCAST_STATUS_OFF);
			DEFAULT_CHAT_FRAME:AddMessage(SELFCAST_STATUS_ALT..SELFCAST_STATUS_OFF);
		end
	end
end


--------------------------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------------------------

function SelfCastL(msg)
	if (msg) then
		local command = string.lower(msg);
		if (command == SELFCAST_STATUS) then
			--nothing as we display SelfCastLStatus anyways
		elseif (command == SELFCAST_SELF) then
			if (SelfCastLState.AutoSelfCast) then
					SelfCastLState.AutoSelfCast = false;
			else
					SelfCastLState.AutoSelfCast = true;
			end
		elseif (command == SELFCAST_ALT) then
			if (SelfCastLState.AltCast) then
					SelfCastLState.AltCast = false;
			else
					SelfCastLState.AltCast = true;
			end
		elseif (command == SELFCAST_SELFON or command == SELFCAST_ON) then
			SelfCastLState.AutoSelfCast = true;
		elseif (command == SELFCAST_SELFOFF or command == SELFCAST_OFF) then
			SelfCastLState.AutoSelfCast = false;
		elseif (command == SELFCAST_ALTON) then
			SelfCastLState.AltCast = true;
		elseif (command == SELFCAST_ALTOFF) then
			SelfCastLState.AltCast = false;
		elseif (command == SELFCAST_HELP) then
			local index = 0;
			local value = getglobal("SELFCAST_HELP_TEXT"..index);
			while (value) do
				DEFAULT_CHAT_FRAME:AddMessage(value);
				index = index + 1;
				value = getglobal("SELFCAST_HELP_TEXT"..index);
			end
			return;
		else
			DEFAULT_CHAT_FRAME:AddMessage(SELFCAST_HELP_INVALID);
			return;
		end
		SelfCastLStatus();
	end
end

			
--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------

function SelfCastL_OnLoad()
	-- Register our slash command
	SLASH_SELFCAST1 = "/selfcast";
	SLASH_SELFCAST2 = "/sc";
	SlashCmdList["SELFCAST"] = function(msg)
		SelfCastL(msg);
	end

	RegisterForSave("SelfCastLState");
	
	-- Hook UseAction
	lOriginal_UseAction = UseAction;
	UseAction = SelfCastL_UseAction;
	
	this:RegisterEvent("VARIABLES_LOADED");
end

function SelfCastL_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (not SelfCastLState) then
			SelfCastLState = {};
			SelfCastLState.AutoSelfCast = true;
		end
	end
end

function SelfCastL_UseAction(id, type, self)
	if (SelfCastLState.AltCast and IsAltKeyDown()) then
		self = 1;
	end

	lOriginal_UseAction(id, type, self);
	if (SelfCastLState.AutoSelfCast and SpellIsTargeting() and SpellCanTargetUnit("player") and not SpellCanTargetUnit("target")) then
		SpellTargetUnit("player");
	end
end

