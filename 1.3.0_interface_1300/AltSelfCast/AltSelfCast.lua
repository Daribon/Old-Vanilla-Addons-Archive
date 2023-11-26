--[[
	Alt Self Cast

	By sarf

	This mod will enable Alt-self-casting, e.g. holding alt and pressing a button 
	will mean that your avatar will try casting it on him/herself.
	
	Main credits for this AddOn should go to Telo - I simply took his code and wrapped it in an AddOn.

	Thanks also goes to karconn, for inspiring me to write better code.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
	This has been modified by Mugendai to fix a few problems and add a few things
	I added Smart Self Cast which is based off of Telo's AutoSelfCast mod.
	Smart Self Cast makes it always self cast friendly spells unless you have a friendly target.
	Also changed a bunch of things about how config is saved and some other fixes here and there.
	Oh and since it isn't possible to make it ctrl+alt self cast or what not.. if you press any
	of the enabled self cast buttons now, it will self cast.
	
   ]]


-- Constants

-- Variables
AltSelfCast_Enabled = 0;
AltSelfCast_Alt = 1;
AltSelfCast_Shift = 0;
AltSelfCast_Ctrl = 0;
AltSelfCast_Override = 0;
AltSelfCast_Smart = 0;
AltSelfCast_NoDispel = 0;
AltSelfCast_Smart_NoGroup = 0;


AltSelfCast_ChatHandlers = {};
AltSelfCast_Holding = 0;

-- The list of desired self-cast spells
localSelfCast = Sea.data.spell.selfCast;

function AltSelfCast_OnLoad()
	AltSelfCast_Register();
	AltSelfCast_Setup_Hooks(1);
end

function AltSelfCast_Register_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST",
			"SECTION",
			ALTSELFCAST_CONFIG_HEADER,
			ALTSELFCAST_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_HEADER",
			"SEPARATOR",
			ALTSELFCAST_CONFIG_HEADER,
			ALTSELFCAST_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_ENABLED",
			"CHECKBOX",
			ALTSELFCAST_ENABLED,
			ALTSELFCAST_ENABLED_INFO,
			AltSelfCast_Toggle_Enabled,
			AltSelfCast_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_ALT_KEY",
			"CHECKBOX",
			ALTSELFCAST_ALT_KEY,
			ALTSELFCAST_ALT_KEY_INFO,
			AltSelfCast_Toggle_Alt,
			AltSelfCast_Alt
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_CTRL_KEY",
			"CHECKBOX",
			ALTSELFCAST_CTRL_KEY,
			ALTSELFCAST_CTRL_KEY_INFO,
			AltSelfCast_Toggle_Ctrl,
			AltSelfCast_Ctrl
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_SHIFT_KEY",
			"CHECKBOX",
			ALTSELFCAST_SHIFT_KEY,
			ALTSELFCAST_SHIFT_KEY_INFO,
			AltSelfCast_Toggle_Shift,
			AltSelfCast_Shift
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_SMART",
			"CHECKBOX",
			ALTSELFCAST_SMART,
			ALTSELFCAST_SMART_INFO,
			AltSelfCast_Toggle_Smart,
			AltSelfCast_Smart
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_SMART_NOGROUP",
			"CHECKBOX",
			ALTSELFCAST_SMART_NOGROUP,
			ALTSELFCAST_SMART_NOGROUP_INFO,
			AltSelfCast_Toggle_Smart_NoGroup,
			AltSelfCast_Smart_NoGroup
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_NODISPEL",
			"CHECKBOX",
			ALTSELFCAST_NODISPEL,
			ALTSELFCAST_NODISPEL_INFO,
			AltSelfCast_Toggle_NoDispel,
			AltSelfCast_NoDispel
		);
		Cosmos_RegisterConfiguration(
			"COS_ALTSELFCAST_OVERRIDE_BUTTON",
			"BUTTON",
			ALTSELFCAST_OVERRIDE,
			ALTSELFCAST_OVERRIDE_INFO,
			AltSelfCast_Disable_Override,
			0,
			0,
			0,
			0,
			ALTSELFCAST_OVERRIDE_NAME
		);
	end
end

function AltSelfCast_Register()
	if ( Cosmos_RegisterConfiguration ) then
		AltSelfCast_Register_Cosmos();
	else
		SlashCmdList["ALTSELFCASTSLASH"] = AltSelfCast_ChatCommandHandler;
		SLASH_ALTSELFCASTSLASH1 = "/altselfcast";
		SLASH_ALTSELFCASTSLASH2 = "/asc";
		
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local AltSelfCastCommands = {"/altselfcast","/asc"};
		Cosmos_RegisterChatCommand (
			"ALTSELFCAST_COMMANDS", -- Some Unique Group ID
			AltSelfCastCommands, -- The Commands
			AltSelfCast_ChatCommandHandler,
			ALTSELFCAST_CHAT_COMMAND_INFO -- Description String
		);
	end
end

function AltSelfCast_Disable_Override()
	AltSelfCast_Toggle_Override(0);
end

function AltSelfCast_ChatCommandHandler(msg)
	if (msg) then
		msg = string.lower(msg);
		local command, setStr = unpack(Sea.string.split(msg, " "));
		if ((not command) and msg) then
			command = msg;
		end
		if (command) then
			for curCommand in AltSelfCast_ChatHandlers do
				if (command == curCommand) then
					AltSelfCast_ChatHandlers[curCommand](setStr);
					return;
				end
			end
		end
	end
	for i = 1, getn(ALTSELFCAST_CHAT_COMMAND_HELP) do
		Sea.io.printc(ChatTypeInfo["SYSTEM"], ALTSELFCAST_CHAT_COMMAND_HELP[i]);
	end
end

function AltSelfCast_Enable_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_Enabled(0);
		else
			AltSelfCast_Toggle_Enabled(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_ENABLED", CSM_CHECKONOFF, AltSelfCast_Enabled);
	end
end
AltSelfCast_ChatHandlers["enable"] = AltSelfCast_Enable_ChatCommandHandler;

function AltSelfCast_Alt_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_Alt(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_Alt(0);
		else
			AltSelfCast_Toggle_Alt(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_ALT_KEY", CSM_CHECKONOFF, AltSelfCast_Alt);
	end
end
AltSelfCast_ChatHandlers["alt"] = AltSelfCast_Alt_ChatCommandHandler;

function AltSelfCast_Ctrl_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_Ctrl(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_Ctrl(0);
		else
			AltSelfCast_Toggle_Ctrl(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_CTRL_KEY", CSM_CHECKONOFF, AltSelfCast_Ctrl);
	end
end
AltSelfCast_ChatHandlers["ctrl"] = AltSelfCast_Ctrl_ChatCommandHandler;
AltSelfCast_ChatHandlers["control"] = AltSelfCast_Ctrl_ChatCommandHandler;

function AltSelfCast_Shift_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_Shift(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_Shift(0);
		else
			AltSelfCast_Toggle_Shift(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_SHIFT_KEY", CSM_CHECKONOFF, AltSelfCast_Shift);
	end
end
AltSelfCast_ChatHandlers["shift"] = AltSelfCast_Shift_ChatCommandHandler;

function AltSelfCast_Smart_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_Smart(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_Smart(0);
		else
			AltSelfCast_Toggle_Smart(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_SMART", CSM_CHECKONOFF, AltSelfCast_Smart);
	end
end
AltSelfCast_ChatHandlers["smart"] = AltSelfCast_Smart_ChatCommandHandler;

function AltSelfCast_NoDispel_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_NoDispel(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_NoDispel(0);
		else
			AltSelfCast_Toggle_NoDispel(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_NODISPEL", CSM_CHECKONOFF, AltSelfCast_NoDispel);
	end
end
AltSelfCast_ChatHandlers["nodispel"] = AltSelfCast_NoDispel_ChatCommandHandler;

function AltSelfCast_Smart_NoGroup_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_Smart_NoGroup(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_Smart_NoGroup(0);
		else
			AltSelfCast_Toggle_Smart_NoGroup(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_SMART_NOGROUP", CSM_CHECKONOFF, AltSelfCast_Smart_NoGroup);
	end
end
AltSelfCast_ChatHandlers["smartnogroup"] = AltSelfCast_Smart_NoGroup_ChatCommandHandler;
AltSelfCast_ChatHandlers["nogroup"] = AltSelfCast_Smart_NoGroup_ChatCommandHandler;

function AltSelfCast_Override_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AltSelfCast_Toggle_Override(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AltSelfCast_Toggle_Override(0);
		else
			AltSelfCast_Toggle_Override(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_ALTSELFCAST_OVERRIDE_BUTTON", CSM_CHECKONOFF, AltSelfCast_Override);
	end
end
AltSelfCast_ChatHandlers["override"] = AltSelfCast_Override_ChatCommandHandler;

function AltSelfCast_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if (CursorHasItem() or CursorHasSpell()) then 
			AltSelfCast_Holding = 1; 
		else 
			AltSelfCast_Holding = 0; 
		end
		Sea.util.hook("UseAction", "AltSelfCast_UseAction", "replace");
		Sea.util.hook("PickupAction", "AltSelfCast_PickupAction", "after");
		Sea.util.hook("PlaceAction", "AltSelfCast_PlaceAction", "after");
	else
		Sea.util.unhook("UseAction", "AltSelfCast_UseAction", "replace");
		Sea.util.unhook("PickupAction", "AltSelfCast_PickupAction", "after");
		Sea.util.unhook("PlaceAction", "AltSelfCast_PlaceAction", "after");
	end
end

function AltSelfCast_GetToggle(toggle, oldvalue)
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			toggle = 0;
		elseif ( oldvalue == 0 ) then
			toggle = 1;
		else
			toggle = 0;
		end
	end
	return toggle;
end

function AltSelfCast_Toggle_Enabled(toggle)
	local oldvalue = AltSelfCast_Enabled;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_Enabled = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_ENABLED_X", newvalue);
	end
	AltSelfCast_Setup_Hooks(newvalue);
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(ALTSELFCAST_CHAT_ENABLED);
		else
			AltSelfCast_Print(ALTSELFCAST_CHAT_DISABLED);
		end
	end
	RegisterForSave("AltSelfCast_Enabled");
end

function AltSelfCast_Toggle_Alt(toggle)
	local oldvalue = AltSelfCast_Alt;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_Alt = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_ALT_KEY_X", newvalue);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(format(ALTSELFCAST_CHAT_KEY_ENABLED, ALTSELFCAST_CHAT_KEY_ALT));
		else
			AltSelfCast_Print(format(ALTSELFCAST_CHAT_KEY_DISABLED, ALTSELFCAST_CHAT_KEY_ALT));
		end
	end
	RegisterForSave("AltSelfCast_Alt");
end

function AltSelfCast_Toggle_Ctrl(toggle)
	local oldvalue = AltSelfCast_Ctrl;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_Ctrl = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_CTRL_KEY_X", newvalue);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(format(ALTSELFCAST_CHAT_KEY_ENABLED, ALTSELFCAST_CHAT_KEY_CTRL));
		else
			AltSelfCast_Print(format(ALTSELFCAST_CHAT_KEY_DISABLED, ALTSELFCAST_CHAT_KEY_CTRL));
		end
	end
	RegisterForSave("AltSelfCast_Ctrl");
end

function AltSelfCast_Toggle_Shift(toggle)
	local oldvalue = AltSelfCast_Shift;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_Shift = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_SHIFT_KEY_X", newvalue);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(format(ALTSELFCAST_CHAT_KEY_ENABLED, ALTSELFCAST_CHAT_KEY_SHIFT));
		else
			AltSelfCast_Print(format(ALTSELFCAST_CHAT_KEY_DISABLED, ALTSELFCAST_CHAT_KEY_SHIFT));
		end
	end
	RegisterForSave("AltSelfCast_Shift");
end

function AltSelfCast_Toggle_Smart(toggle)
	local oldvalue = AltSelfCast_Smart;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_Smart = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_SMART_X", newvalue);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(ALTSELFCAST_CHAT_SMART_ENABLED);
		else
			AltSelfCast_Print(ALTSELFCAST_CHAT_SMART_DISABLED);
		end
	end
	RegisterForSave("AltSelfCast_Smart");
end

function AltSelfCast_Toggle_Smart_NoGroup(toggle)
	local oldvalue = AltSelfCast_Smart_NoGroup;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_Smart_NoGroup = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_SMART_NOGROUP_X", newvalue);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(ALTSELFCAST_CHAT_SMART_NOGROUP_ENABLED);
		else
			AltSelfCast_Print(ALTSELFCAST_CHAT_SMART_NOGROUP_DISABLED);
		end
	end
	RegisterForSave("AltSelfCast_Smart_NoGroup");
end

function AltSelfCast_Toggle_Override(toggle)
	local oldvalue = AltSelfCast_Override;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_Override = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_OVERRIDE", newvalue);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(ALTSELFCAST_CHAT_OVERRIDE_ENABLED);
		else
			AltSelfCast_Print(ALTSELFCAST_CHAT_OVERRIDE_DISABLED);
		end
	end
end

function AltSelfCast_Toggle_NoDispel(toggle)
	local oldvalue = AltSelfCast_NoDispel;
	local newvalue = AltSelfCast_GetToggle(toggle, oldvalue);
	AltSelfCast_NoDispel = newvalue;
	if ( Cosmos_SetCVar ) then
		Cosmos_SetCVar("COS_ALTSELFCAST_NODISPEL_X", newvalue);
	end
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			AltSelfCast_Print(ALTSELFCAST_CHAT_NODISPEL_ENABLED);
		else
			AltSelfCast_Print(ALTSELFCAST_CHAT_NODISPEL_DISABLED);
		end
	end
	if ( newvalue == 1 ) then
		localSelfCast["Dispel Magic"] = nil;
	else
		localSelfCast["Dispel Magic"] = 1;
	end
	RegisterForSave("AltSelfCast_NoDispel");
end



function AltSelfCast_CorrectKeysDown()
	if ( AltSelfCast_Override == 1 ) then
		return true;
	elseif ( IsAltKeyDown() and ( AltSelfCast_Alt == 1) ) then
		return true;
	elseif ( IsShiftKeyDown() and ( AltSelfCast_Shift == 1) ) then
		return true;
	elseif ( IsControlKeyDown() and ( AltSelfCast_Ctrl == 1) ) then
		return true;
	else
		return false;
	end
end

function AltSelfCast_GetNumberOfPartyMembers()
	for i=1, MAX_PARTY_MEMBERS, 1 do
		if ( not GetPartyMember(i) ) then
			return i - 1;
		end
	end
	return MAX_PARTY_MEMBERS;
end

function AltSelfCast_UseSmart()
	if ( AltSelfCast_Smart == 1 ) then
		if ( AltSelfCast_Smart_NoGroup == 1 ) then
			if ( AltSelfCast_GetNumberOfPartyMembers() > 0 ) then
				return false;
			end
		end
		return true;
	else
		return false;
	end
end

function AltSelfCast_PlaceAction(id)
	AltSelfCast_Holding = 0;
end

function AltSelfCast_PickupAction(id)
	AltSelfCast_Holding = 1;
end

function AltSelfCast_GetActionName(id)
	if ( DynamicData ) and ( DynamicData.action ) and ( DynamicData.action.getActionInfo ) then
		local actionInfo = DynamicData.action.getActionInfo(id);
		if ( actionInfo ) and ( actionInfo.name ) then
			return actionInfo.name;
		end
	else
		Sea.wow.tooltip.protectTooltipMoney();
		AltSelfCastTooltip:SetAction(id);
		Sea.wow.tooltip.unprotectTooltipMoney();
		local tip = Sea.wow.tooltip.scan("AltSelfCastTooltip");
		if (tip and tip[1] and tip[1]["left"]) then
			local name = tip[1]["left"];
			if ( not name ) then
				name = "";
			end
			return name;
		end
	end
	return "";
end

function AltSelfCast_UseAction(id, number, onSelf)
	if (AltSelfCast_Holding == 1) then return true; end

	if  ((AltSelfCast_Enabled == 1) and ((AltSelfCast_UseSmart()) or AltSelfCast_CorrectKeysDown())) then
		local doSelf = false;
		local spellName = AltSelfCast_GetActionName(id);
		if ( 
			(
			( 
			( localSelfCast[spellName] ) and 
			( ( AltSelfCast_UseSmart() ) and (UnitCanAttack("target", "player") ) ) 
			)
			) or 
			( AltSelfCast_CorrectKeysDown() ) ) then
			doSelf = true;
		end
		if (doSelf) then
			Sea.util.Hooks["UseAction"].orig(id, number, 1);
			if( SpellIsTargeting() ) then
				SpellTargetUnit("player");
			end
		else
			Sea.util.Hooks["UseAction"].orig(id, number, onSelf);
			if( SpellIsTargeting() and ((onSelf == 1) or ((AltSelfCast_UseSmart()) and localSelfCast[spellName]))) then
				SpellTargetUnit("player");
			end
		end
		return false;
	end
	return true;
end

function AltSelfCast_Print(msg)
	if (not Cosmos_RegisterConfiguration) then
		Sea.io.printc(ChatTypeInfo["SYSTEM"], msg);
	end
end