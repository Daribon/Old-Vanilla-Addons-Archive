--[[
	Free Bag Slots

	By sarf

	This mod allows the lazy user to keep track of the number of free slots in his or her backpacks.

	Thanks goes to Beider for suggesting this.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants

-- Variables
FreeBagSlots_Enabled = 1;
FreeBagSlots_ShowEmptySlotsOnShotBags = 1;
FreeBagSlots_ShowTotalSlots = 1;
FreeBagSlots_ShowTotalFreeSlots = 1;
FreeBagSlots_ShowGlobalSlots = 0;


FreeBagSlots_Number_Color_Red = 1.0;
FreeBagSlots_Number_Color_Green = 1.0;
FreeBagSlots_Number_Color_Blue = 1.0;

FreeBagSlots_Number_Color_Other_Red = 0.0;
FreeBagSlots_Number_Color_Other_Green = 0.0;
FreeBagSlots_Number_Color_Other_Blue = 0.0;

FreeBagSlots_Saved_Hooked_Function = nil;
FreeBagSlots_Khaos_Registered = 0;
FreeBagSlots_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function FreeBagSlots_OnLoad()
	FreeBagSlots_Register();
end

-- registers the mod with Cosmos
function FreeBagSlots_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( FreeBagSlots_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_FREEBAGSLOTS",
			"SECTION",
			TEXT(FREEBAGSLOTS_CONFIG_HEADER),
			TEXT(FREEBAGSLOTS_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_FREEBAGSLOTS_HEADER",
			"SEPARATOR",
			TEXT(FREEBAGSLOTS_CONFIG_HEADER),
			TEXT(FREEBAGSLOTS_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_FREEBAGSLOTS_ENABLED",
			"CHECKBOX",
			TEXT(FREEBAGSLOTS_ENABLED),
			TEXT(FREEBAGSLOTS_ENABLED_INFO),
			FreeBagSlots_Toggle_Enabled_NoChat,
			FreeBagSlots_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_FREEBAGSLOTS_SHOW_TOTAL_SLOTS",
			"CHECKBOX",
			TEXT(FREEBAGSLOTS_SHOW_TOTAL_SLOTS),
			TEXT(FREEBAGSLOTS_SHOW_TOTAL_SLOTS_INFO),
			FreeBagSlots_Toggle_ShowTotalSlots_NoChat,
			FreeBagSlots_ShowTotalSlots
		);
		Cosmos_RegisterConfiguration(
			"COS_FREEBAGSLOTS_SHOW_EMPTY_SLOTS_ON_SHOTBAGS",
			"CHECKBOX",
			TEXT(FREEBAGSLOTS_SHOW_EMPTY_SLOTS_ON_SHOTBAGS),
			TEXT(FREEBAGSLOTS_SHOW_EMPTY_SLOTS_ON_SHOTBAGS_INFO),
			FreeBagSlots_Toggle_ShowEmptySlotsOnShotBags_NoChat,
			FreeBagSlots_ShowEmptySlotsOnShotBags
		);
		Cosmos_RegisterConfiguration(
			"COS_FREEBAGSLOTS_SHOW_TOTAL_FREE_SLOTS",
			"CHECKBOX",
			TEXT(FREEBAGSLOTS_SHOW_TOTAL_FREE_SLOTS),
			TEXT(FREEBAGSLOTS_SHOW_TOTAL_FREE_SLOTS_INFO),
			FreeBagSlots_Toggle_ShowTotalFreeSlots_NoChat,
			FreeBagSlots_ShowTotalFreeSlots
		);
		Cosmos_RegisterConfiguration(
			"COS_FREEBAGSLOTS_SHOW_GLOBAL_SLOTS",
			"CHECKBOX",
			TEXT(FREEBAGSLOTS_SHOW_GLOBAL_SLOTS),
			TEXT(FREEBAGSLOTS_SHOW_GLOBAL_SLOTS_INFO),
			FreeBagSlots_Toggle_ShowGlobalSlots_NoChat,
			FreeBagSlots_ShowGlobalSlots
		);
		FreeBagSlots_Cosmos_Registered = 1;
	end
end

function FreeBagSlots_Get_Khaos_CheckBox(pid, pkey, ptext, phelptext, pcheck, cb)
	local option1 = {
		id = pid;
		key = pkey;
		text = ptext;
		helptext = phelptext;
		check = true;
		callback = cb;
		type = K_TEXT;
		feedback = function(state) local s = FREEBAGSLOTS_STATE_ENABLED; if ( not state.checked ) then s = FREEBAGSLOTS_STATE_DISABLED; end return FREEBAGSLOTS_STATE_TEXT.." "..s; end;
		default = {
			checked = pcheck;
		};
		disabled = {
			checked = false;
		};
	};
	return option1;
end

FREEBAGSLOTS_KHAOS_SET_EASY_ID 			= "FreeBagSlotsBasicSetID";

FREEBAGSLOTS_KHAOS_FOLDER_ID			= "inventory"; 

FreeBagSlots_Folder = {
	id = FREEBAGSLOTS_KHAOS_FOLDER_ID;
	text = FREEBAGSLOTS_CONFIG_HEADER;
	helptext = FREEBAGSLOTS_CONFIG_HEADER_INFO;
	difficulty = 1;
	default = true;
};

function FreeBagSlots_GetStateAsToggleValue(newState)
	if ( newState ) then
		return 1;
	else
		return 0;
	end
end

-- registers the mod with Cosmos
function FreeBagSlots_Register_Khaos()
	if ( Khaos )  and ( FreeBagSlots_Khaos_Registered == 0 ) then
		--Khaos.registerFolder(FreeBagSlots_Folder);
		local optionSetEasy = {
			id = FREEBAGSLOTS_KHAOS_SET_EASY_ID;
			text = FREEBAGSLOTS_KHAOS_EASYSET_TEXT;
			helptext = FREEBAGSLOTS_KHAOS_EASYSET_HELP;
			difficulty = 1;
			options = {
				FreeBagSlots_Get_Khaos_CheckBox("CheckBoxEnabled", "enabled", 
					FREEBAGSLOTS_ENABLED, 
					FREEBAGSLOTS_ENABLED_INFO, 
					true, 
					function(state) FreeBagSlots_Toggle_Enabled_NoChat(FreeBagSlots_GetStateAsToggleValue(state.checked)); end
				),
				FreeBagSlots_Get_Khaos_CheckBox("CheckBoxShowTotalSlots", "showTotalSlots", 
					FREEBAGSLOTS_SHOW_TOTAL_SLOTS, 
					FREEBAGSLOTS_SHOW_TOTAL_SLOTS_INFO, 
					true, 
					function(state) FreeBagSlots_Toggle_ShowTotalSlots_NoChat(FreeBagSlots_GetStateAsToggleValue(state.checked)); end
				),
				FreeBagSlots_Get_Khaos_CheckBox("CheckBoxShowEmptySlotsOnShotBats", "showEmptySlotsOnShotBags", 
					FREEBAGSLOTS_SHOW_EMPTY_SLOTS_ON_SHOTBAGS, 
					FREEBAGSLOTS_SHOW_EMPTY_SLOTS_ON_SHOTBAGS_INFO, 
					true, 
					function(state) FreeBagSlots_Toggle_ShowEmptySlotsOnShotBags_NoChat(FreeBagSlots_GetStateAsToggleValue(state.checked)); end
				),
				FreeBagSlots_Get_Khaos_CheckBox("CheckBoxShowTotalFreeSlots", "showTotalFreeSlots", 
					FREEBAGSLOTS_SHOW_TOTAL_FREE_SLOTS, 
					FREEBAGSLOTS_SHOW_TOTAL_FREE_SLOTS_INFO, 
					false, 
					function(state) FreeBagSlots_Toggle_ShowTotalFreeSlots_NoChat(FreeBagSlots_GetStateAsToggleValue(state.checked)); end
				),
				FreeBagSlots_Get_Khaos_CheckBox("CheckBoxShowGlobalSlots", "showGlobalSlots", 
					FREEBAGSLOTS_SHOW_GLOBAL_SLOTS, 
					FREEBAGSLOTS_SHOW_GLOBAL_SLOTS_INFO, 
					true, 
					function(state) FreeBagSlots_Toggle_ShowGlobalSlots_NoChat(FreeBagSlots_GetStateAsToggleValue(state.checked)); end
				),
			};
			default = true;
		};
		Khaos.registerOptionSet( FREEBAGSLOTS_KHAOS_FOLDER_ID, optionSetEasy );
		FreeBagSlots_Khaos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function FreeBagSlots_Register()
	if ( Khaos ) then
		FreeBagSlots_Register_Khaos();
	end
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		FreeBagSlots_Register_Cosmos();
	else
		SlashCmdList["FREEBAGSLOTSSLASHMAIN"] = FreeBagSlots_Main_ChatCommandHandler;
		SLASH_FREEBAGSLOTSSLASHMAIN1 = "/freebagslots";
		SLASH_FREEBAGSLOTSSLASHMAIN2 = "/fbs";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local FreeBagSlotsMainCommands = {"/freebagslots","/fbs"};
		Cosmos_RegisterChatCommand (
			"FREEBAGSLOTS_MAIN_COMMANDS", -- Some Unique Group ID
			FreeBagSlotsMainCommands, -- The Commands
			FreeBagSlots_Main_ChatCommandHandler,
			FREEBAGSLOTS_CHAT_COMMAND_INFO -- Description String
		);
	end
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
end

function FreeBagSlots_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end



-- Handles chat - e.g. slashcommands - enabling/disabling the FreeBagSlots
function FreeBagSlots_Main_ChatCommandHandler(msg)
	
	local func = FreeBagSlots_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		FreeBagSlots_Print(FREEBAGSLOTS_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = FreeBagSlots_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "show" ) ) then
		func = FreeBagSlots_Toggle_Enabled;
	elseif ( ( strfind( commandName, "totalslots" ) ) or ( strfind( commandName, "totalbagslots" ) ) ) then
		func = FreeBagSlots_Toggle_ShowTotalSlots;
	elseif ( strfind( commandName, "global" ) ) then
		func = FreeBagSlots_Toggle_ShowGlobalSlots;
	elseif ( strfind( commandName, "shotbag" ) ) then
		func = FreeBagSlots_Toggle_ShowEmptySlotsOnShotBags;
	else
		FreeBagSlots_Print(FREEBAGSLOTS_CHAT_COMMAND_USAGE);
		return;
	end
	
	if ( toggleFunc ) then
		-- Toggle appropriately
		if ( (string.find(params, 'on')) or ((string.find(params, '1')) and (not string.find(params, '-1')) ) ) then
			func(1);
		else
			if ( (string.find(params, 'off')) or (string.find(params, '0')) ) then
				func(0);
			else
				func(-1);
			end
		end
	else
		func();
	end
end

-- Handles chat - e.g. slashcommands - enabling/disabling the FreeBagSlots
function FreeBagSlots_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		FreeBagSlots_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			FreeBagSlots_Toggle_Enabled(0);
		else
			FreeBagSlots_Toggle_Enabled(-1);
		end
	end
end

-- Handles events
function FreeBagSlots_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( FreeBagSlots_Cosmos_Registered == 0 ) then
			local value = getglobal("FreeBagSlots_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			FreeBagSlots_Toggle_Enabled(value);
		end
	end
	if ( event == "BAG_UPDATE") then
		FreeBagSlots_UpdateFreeBagSlots((FreeBagSlots_Enabled == 0));
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		FreeBagSlots_UpdateFreeBagSlots((FreeBagSlots_Enabled == 0));
	end
end

function FreeBagSlots_GetFreeBagSlots(bag)
	local freeSlots = 0;
	local slot;
	for slot = GetContainerNumSlots(bag),1,-1 do
		if ( not FreeBagSlots_SlotHasItem(bag, slot ) ) then
			freeSlots = freeSlots + 1;
		end
	end
	return freeSlots;
end

function FreeBagSlots_GetTotalBagSlots(bag)
	return GetContainerNumSlots(bag);
end

function FreeBagSlots_GetByteValue(pValue)
	local value = tonumber(pValue);
	if ( value <= 0 ) then return 0; end
	if ( value >= 255 ) then return 255; end
	return value;
end

-- Yet another function from George Warner, modified a bit to fit my own nefarious purposes. 
-- It can now accept r, g and b specifications, too (leaving out a), as well as handle 255 255 255
-- Source : http://www.cosmosui.org/cgi-bin/bugzilla/show_bug.cgi?id=159
function FreeBagSlots_GetColorFormatString(a, r, g, b)
	local percent = false;
	if ( ( ( not b ) or ( b <= 1 ) ) and ( a <= 1 ) and ( r <= 1 ) and ( g <= 1) ) then percent = true; end
	if ( ( not b ) and ( a ) and ( r ) and ( g ) ) then b = g; g = r; r = a; if ( percent ) then a = 1; else a = 255; end end
	if ( percent ) then a = a * 255; r = r * 255; g = g * 255; b = b * 255; end
	a = FreeBagSlots_GetByteValue(a); r = FreeBagSlots_GetByteValue(r); g = FreeBagSlots_GetByteValue(g); b = FreeBagSlots_GetByteValue(b);
	
	return format("|c%02X%02X%02X%02X%%s|r", a, r, g, b);
end

function FreeBagSlots_GetColorFormat(useOtherColorSet)
	if ( not useOtherColorSet ) then
		return FreeBagSlots_GetColorFormatString(FreeBagSlots_Number_Color_Red, FreeBagSlots_Number_Color_Green, FreeBagSlots_Number_Color_Blue);
	else
		return FreeBagSlots_GetColorFormatString(FreeBagSlots_Number_Color_Other_Red, FreeBagSlots_Number_Color_Other_Green, FreeBagSlots_Number_Color_Other_Blue);
	end
end

function FreeBagSlots_IsShotBag(bag) 
	if ( bag < 0 ) or ( bag > 4 ) then
		return false;
	end
	local name = "MainMenuBarBackpackButton";
	if ( bag > 0 ) then
		name = "CharacterBag"..(bag-1).."Slot";
	end
	local objCount = getglobal(name.."Count");
	if ( objCount ) then
		local tmp = objCount:GetText();
		if ( ( tmp ) and ( strlen(tmp) > 0) ) then
			return true;
		end
	end
	return false;
end

function FreeBagSlots_GetFreeBagSlotsText(bag, useOtherColorSet, showTotalSlots)
	useOtherColorSet = false;
	local totalSlots = 0;
	if ( bag == -1 ) then
		for i = 0, 4 do 
			if ( ( FreeBagSlots_ShowEmptySlotsOnShotBags ~= 0 ) or ( not FreeBagSlots_IsShotBag(i) ) ) then
				totalSlots = totalSlots + FreeBagSlots_GetTotalBagSlots(i);
			end
		end
	else
		totalSlots = FreeBagSlots_GetTotalBagSlots(bag);
	end
	if ( ( totalSlots <= 0 ) and ( bag >= 0 ) ) then
		return "";
	else
		local freeSlots = 0;
		if ( bag == -1 ) then
			for i = 0, 4 do 
				if ( ( FreeBagSlots_ShowEmptySlotsOnShotBags ~= 0 ) or ( not FreeBagSlots_IsShotBag(i) ) ) then
					freeSlots = freeSlots + FreeBagSlots_GetFreeBagSlots(i);
				end
			end
		else
			freeSlots = FreeBagSlots_GetFreeBagSlots(bag);
		end
		local text = "";
		if ( ( FreeBagSlots_ShowTotalSlots == 1 ) or ( showTotalSlots ) ) then
			text = freeSlots.."/"..totalSlots;
		else
			text = freeSlots.."";
		end
		return format(FreeBagSlots_GetColorFormat(useOtherColorSet), text);
	end
end

function FreeBagSlots_UpdateFreeBagSlotsCount(name, text, disable)
	local obj = getglobal(name.."FreeSlotCount");
	local objCount = getglobal(name.."Count");
	local objFrame = getglobal(name.."FreeSlotCountFrame");
	if ( not objFrame ) then
		if ( strfind(name, "MainMenuBarBackpackButtonTotal") ) then
			objFrame = MainMenuBarBackpackButtonFreeSlotCountFrame;
		end
	end
	if ( obj ) then
		if ( objCount ) then
			local tmp = objCount:GetText();
			if ( ( tmp ) and ( strlen(tmp) > 0) and (FreeBagSlots_ShowEmptySlotsOnShotBags == 0) ) then
				disable = true;
			end
		end
		if ( not text ) then
			disable = true;
		else
			obj:SetText(text);
			if ( strlen(text) <= 0 ) then
				disable = true;
			end
		end
		if ( objFrame ) then
			--objFrame:SetScale(1.0);
			--[[
			if ( not disable ) then
				objFrame:Show();
			else
				objFrame:Hide();
			end
			]]--
			objFrame:Show();
		end
		if ( not disable ) then
			obj:Show();
		else
			obj:Hide();
		end
	end
end

function FreeBagSlots_UpdateFreeBagSlots(disable)
	local oldDisable = disable;
	if ( FreeBagSlots_ShowGlobalSlots == 1 ) then
		disable = true;
	end
	FreeBagSlots_UpdateFreeBagSlotsCount("MainMenuBarBackpackButton", FreeBagSlots_GetFreeBagSlotsText(0, MainMenuBarBackpackButton:GetChecked()), disable);
	if ( not disable ) then
		FreeBagSlots_UpdateFreeBagSlotsCount("MainMenuBarBackpackButtonTotal", FreeBagSlots_GetFreeBagSlotsText(-1, MainMenuBarBackpackButton:GetChecked()), (FreeBagSlots_ShowTotalFreeSlots == 0));
	else
		FreeBagSlots_UpdateFreeBagSlotsCount("MainMenuBarBackpackButtonTotal", FreeBagSlots_GetFreeBagSlotsText(-1, MainMenuBarBackpackButton:GetChecked()), disable);
	end
	if ( ( ( not oldDisable ) or ( oldDisable == false ) ) and ( FreeBagSlots_ShowGlobalSlots == 1 ) ) then
		FreeBagSlots_UpdateFreeBagSlotsCount("MainMenuBarBackpackButtonTotal", FreeBagSlots_GetFreeBagSlotsText(-1, MainMenuBarBackpackButton:GetChecked()), nil);
	end
	local name, obj;
	for i = 0, 3 do
		name = "CharacterBag"..i.."Slot";
		
		FreeBagSlots_UpdateFreeBagSlotsCount(name, FreeBagSlots_GetFreeBagSlotsText(i+1, getglobal(name):GetChecked()), disable);
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function FreeBagSlots_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
	local oldvalue = getglobal(variableName);
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	setglobal(variableName, newvalue);
	setglobal(CVarName, newvalue);
	if ( newvalue ~= oldvalue ) then
		local text = "";
		if ( newvalue == 1 ) then
			if ( enableMessage ) then
				text = TEXT(getglobal(enableMessage));
			end
		else
			if ( disableMessage ) then
				text = TEXT(getglobal(disableMessage));
			end
		end
		if ( text ) and ( strlen(text) > 0 ) then
			FreeBagSlots_Print(text);
		end
	end
	FreeBagSlots_Register_Cosmos();
	RegisterForSave(variableName);
	if ( FreeBagSlots_Cosmos_Registered == 1 ) then 
		if ( CosmosVarName ) then
			Cosmos_UpdateValue(strsub(CVarName, 1, strlen(CVarName)-2), CSM_CHECKONOFF, newvalue);
		end
	end
	return newvalue;
end

-- Toggles the enabled/disabled state of the FreeBagSlots
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function FreeBagSlots_Toggle_Enabled(toggle)
	FreeBagSlots_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function FreeBagSlots_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_Enabled", "COS_FREEBAGSLOTS_ENABLED_X", "FREEBAGSLOTS_CHAT_ENABLED", "FREEBAGSLOTS_CHAT_DISABLED");
	else
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_Enabled", "COS_FREEBAGSLOTS_ENABLED_X");
	end
	FreeBagSlots_UpdateFreeBagSlots();
end

-- toggling - no text
function FreeBagSlots_Toggle_Enabled_NoChat(toggle)
	FreeBagSlots_DoToggle_Enabled(toggle, false);
end

function FreeBagSlots_Toggle_ShowTotalSlots(toggle)
	FreeBagSlots_DoToggle_ShowTotalSlots(toggle, true);
end

function FreeBagSlots_DoToggle_ShowTotalSlots(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowTotalSlots", "COS_FREEBAGSLOTS_SHOW_TOTAL_SLOTS_X", "FREEBAGSLOTS_CHAT_SHOW_TOTAL_SLOTS_ENABLED", "FREEBAGSLOTS_CHAT_SHOW_TOTAL_SLOTS_DISABLED");
	else
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowTotalSlots", "COS_FREEBAGSLOTS_SHOW_TOTAL_SLOTS_X");
	end
	FreeBagSlots_UpdateFreeBagSlots((FreeBagSlots_Enabled == 0));
end

function FreeBagSlots_Toggle_ShowTotalSlots_NoChat(toggle)
	FreeBagSlots_DoToggle_ShowTotalSlots(toggle, false);
end

function FreeBagSlots_Toggle_ShowEmptySlotsOnShotBags(toggle)
	FreeBagSlots_DoToggle_ShowEmptySlotsOnShotBags(toggle, true);
end

function FreeBagSlots_DoToggle_ShowEmptySlotsOnShotBags(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowEmptySlotsOnShotBags", "COS_FREEBAGSLOTS_SHOW_EMPTY_SLOTS_ON_SHOTBAGS_X", "FREEBAGSLOTS_CHAT_SHOW_EMPTY_SLOTS_ON_SHOTBAGS_ENABLED", "FREEBAGSLOTS_CHAT_SHOW_EMPTY_SLOTS_ON_SHOTBAGS_DISABLED");
	else
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowEmptySlotsOnShotBags", "COS_FREEBAGSLOTS_SHOW_EMPTY_SLOTS_ON_SHOTBAGS_X");
	end
	FreeBagSlots_UpdateFreeBagSlots((FreeBagSlots_Enabled == 0));
end

function FreeBagSlots_Toggle_ShowEmptySlotsOnShotBags_NoChat(toggle)
	FreeBagSlots_DoToggle_ShowEmptySlotsOnShotBags(toggle, false);
end

function FreeBagSlots_Toggle_ShowTotalSlots(toggle)
	FreeBagSlots_DoToggle_ShowTotalSlots(toggle, true);
end

function FreeBagSlots_DoToggle_ShowTotalFreeSlots(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowTotalFreeSlots", "COS_FREEBAGSLOTS_SHOW_TOTAL_FREE_SLOTS_X", "FREEBAGSLOTS_CHAT_SHOW_TOTAL_FREE_SLOTS_ENABLED", "FREEBAGSLOTS_CHAT_SHOW_TOTAL_FREE_SLOTS_DISABLED");
	else
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowTotalFreeSlots", "COS_FREEBAGSLOTS_SHOW_TOTAL_FREE_SLOTS_X");
	end
	FreeBagSlots_UpdateFreeBagSlots((FreeBagSlots_Enabled == 0));
end

function FreeBagSlots_Toggle_ShowTotalFreeSlots_NoChat(toggle)
	FreeBagSlots_DoToggle_ShowTotalFreeSlots(toggle, false);
end

function FreeBagSlots_Toggle_ShowGlobalSlots(toggle)
	FreeBagSlots_DoToggle_ShowGlobalSlots(toggle, true);
end

function FreeBagSlots_DoToggle_ShowGlobalSlots(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowGlobalSlots", "COS_FREEBAGSLOTS_SHOW_GLOBAL_FREE_SLOTS_X", "FREEBAGSLOTS_CHAT_SHOW_GLOBAL_FREE_SLOTS_ENABLED", "FREEBAGSLOTS_CHAT_SHOW_GLOBAL_FREE_SLOTS_DISABLED");
	else
		newvalue = FreeBagSlots_Generic_Toggle(toggle, "FreeBagSlots_ShowGlobalSlots", "COS_FREEBAGSLOTS_SHOW_GLOBAL_FREE_SLOTS_X");
	end
	FreeBagSlots_UpdateFreeBagSlots((FreeBagSlots_Enabled == 0));
end

function FreeBagSlots_Toggle_ShowGlobalSlots_NoChat(toggle)
	FreeBagSlots_DoToggle_ShowGlobalSlots(toggle, false);
end

-- Prints out text to a chat box.
function FreeBagSlots_Print(msg,r,g,b,frame,id,unknown4th)
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end


function FreeBagSlots_SlotHasItem(bag, slot)
	if ( bag == -1) then
		if (slot == -1) then
			return false;
		end
		if ( DynamicData ) and ( DynamicData.item ) and ( DynamicData.item.getInventoryInfo ) then
			local itemInfo = DynamicData.item.getInventoryInfo(bag, slot);
			if ( ( not itemInfo ) or ( not itemInfo.name ) or ( strlen(itemInfo.name) <= 0 ) or ( not itemInfo.count ) or ( itemInfo.count == 0 ) ) then
				return false;
			else
				return true;
			end
		end
		if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
			DynamicData.util.protectTooltipMoney();
		elseif ( Sea ) and ( Sea.wow ) and ( Sea.wow.tooltip ) and ( Sea.wow.tooltip.protectTooltipMoney ) then
			Sea.wow.tooltip.protectTooltipMoney();
		end 
		local hasItem, hasCooldown = FreeBagSlotsTooltip:SetInventoryItem("player", slot);
		if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.unprotectTooltipMoney ) then
			DynamicData.util.unprotectTooltipMoney();
		elseif ( Sea ) and ( Sea.wow ) and ( Sea.wow.tooltip ) and ( Sea.wow.tooltip.protectTooltipMoney ) then
			Sea.wow.tooltip.unprotectTooltipMoney();
		end 
		if ( not hasItem) then
			return false;
		else
			return true;
		end
	end
	local texture, itemCount = GetContainerItemInfo(bag, slot);
	if (not itemCount) then
		return false;
	else
		return true;
	end
end

