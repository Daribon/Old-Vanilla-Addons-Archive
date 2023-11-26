--[[
	ActionButtonUnabridged

	By sarf

	This mod expands action button tooltips into more informative ones.

	Thanks also goes to Bayta (on the official WoW community boards), who came up with the idea, 
	as well as karconn (Bayta's nick on the CosmosUI.org forums) for providing feedback.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=266
	
	Bayta's Thread URL:
	http://www.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=7287
   ]]


-- Constants
ACTIONBUTTONUNABRIDGED_FUNCTION_POINTERS = {"ActionButton_SetTooltip", "SecondActionButton_SetTooltip", "SideBarButton_SetTooltipLeft", "SideBarButton_SetTooltipRight" };

-- Variables
ActionButtonUnabridged_BookTypes = { "spell", "ability", "pet" };

ActionButtonUnabridged_Saved_ActionButton_SetTooltip = nil;

ActionButtonUnabridged_Enabled = 0;

ActionButtonUnabridged_CosmosRegistered = 0;

ActionButtonUnabridged_Debug_Enabled = 0;

ActionButtonUnabridged_Saved_Pointers = {};

function ActionButtonUnabridged_OnLoad()
	ActionButtonUnabridged_Register();
end

function ActionButtonUnabridged_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( ActionButtonUnabridged_CosmosRegistered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_ABUNABRIDGED_HEADER",
			"SEPARATOR",
			ABUNABRIDGED_CONFIG_HEADER,
			ABUNABRIDGED_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_ABUNABRIDGED_ENABLED",
			"CHECKBOX",
			ABUNABRIDGED_ENABLED,
			ABUNABRIDGED_ENABLED_INFO,
			ActionButtonUnabridged_Toggle_Enabled,
			ActionButtonUnabridged_Enabled
		);
		ActionButtonUnabridged_CosmosRegistered = 1;
	end
end

function ActionButtonUnabridged_Register()
	if ( Cosmos_RegisterConfiguration ) then
		ActionButtonUnabridged_Register_Cosmos();
	else
		SlashCmdList["ABUNABRIDGEDSLASHENABLE"] = ActionButtonUnabridged_Enable_ChatCommandHandler;
		SLASH_ABUNABRIDGEDSLASHENABLE1 = "/actionbuttonunabridgedenable";
		SLASH_ABUNABRIDGEDSLASHENABLE2 = "/abuenable";
		SLASH_ABUNABRIDGEDSLASHENABLE3 = "/actionbuttonunabridgeddisable";
		SLASH_ABUNABRIDGEDSLASHENABLE4 = "/abudisable";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local ActionButtonUnabridgedEnableCommands = {"/actionbuttonunabridgedenable","/abuenable","/actionbuttonunabridgeddisable","/abudisable"};
		Cosmos_RegisterChatCommand (
			"ABUNABRIDGED_ENABLE_COMMANDS", -- Some Unique Group ID
			ActionButtonUnabridgedEnableCommands, -- The Commands
			ActionButtonUnabridged_Enable_ChatCommandHandler,
			ABUNABRIDGED_CHAT_COMMAND_ENABLE_INFO -- Description String
		);
	end
end

function ActionButtonUnabridged_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		ActionButtonUnabridged_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			ActionButtonUnabridged_Toggle_Enabled(0);
		else
			ActionButtonUnabridged_Toggle_Enabled(-1);
		end
	end
end

function ActionButtonUnabridged_Setup_Hooks_Old(toggle)
	if ( toggle == 1 ) then
	
		if ( ( ActionButton_SetTooltip ~= ActionButtonUnabridged_ActionButton_SetTooltip ) and (ActionButtonUnabridged_Saved_ActionButton_SetTooltip == nil) ) then
			ActionButtonUnabridged_Saved_ActionButton_SetTooltip = ActionButton_SetTooltip;
			ActionButton_SetTooltip = ActionButtonUnabridged_ActionButton_SetTooltip;
		end
	else
		if ( ActionButton_SetTooltip == ActionButtonUnabridged_ActionButton_SetTooltip) then
			ActionButton_SetTooltip = ActionButtonUnabridged_Saved_ActionButton_SetTooltip;
			ActionButtonUnabridged_Saved_ActionButton_SetTooltip = nil;
		end
	end
end

function ActionButtonUnabridged_Setup_Hooks(toggle)
	for k, v in ACTIONBUTTONUNABRIDGED_FUNCTION_POINTERS do
		local currentFunctionPointer = getglobal(v);
		local moduleFunctionPointer = getglobal("ActionButtonUnabridged_"..v);
		if ( currentFunctionPointer ) then
			if ( toggle == 1 ) then
				if ( ( currentFunctionPointer ~= moduleFunctionPointer ) and (ActionButtonUnabridged_Saved_Pointers[v] == nil) ) then
					ActionButtonUnabridged_Saved_Pointers[v] = currentFunctionPointer;
					setglobal(v, moduleFunctionPointer);
				end
			else
				if ( currentFunctionPointer == moduleFunctionPointer) then
					setglobal(v, ActionButtonUnabridged_Saved_Pointers[v]);
					ActionButtonUnabridged_Saved_Pointers[v] = nil;
				end
			end
		end
	end
end


function ActionButtonUnabridged_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if( ActionButtonUnabridged_CosmosRegistered == 0) then
			local value = getglobal("COS_ABUNABRIDGED_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			ActionButtonUnabridged_Toggle_Enabled(value);
			if( Cosmos_SetCVar ) then
				Cosmos_SetCVar("COS_ABUNABRIDGED_ENABLED_X", value);
			end
		end
	end
end

function ActionButtonUnabridged_Toggle_Enabled(toggle)
	local oldvalue = ActionButtonUnabridged_Enabled;
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
	ActionButtonUnabridged_Enabled = newvalue;
	setglobal("COS_ABUNABRIDGED_ENABLED_X", newvalue);
	ActionButtonUnabridged_Setup_Hooks(newvalue);
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			ActionButtonUnabridged_Print(ABUNABRIDGED_CHAT_ENABLED);
		else
			ActionButtonUnabridged_Print(ABUNABRIDGED_CHAT_DISABLED);
		end
	end
	ActionButtonUnabridged_Register_Cosmos();
	--if ( ActionButtonUnabridged_CosmosRegistered == 0 ) then 
		RegisterForSave("COS_ABUNABRIDGED_ENABLED_X");
	--end
end

function ActionButtonUnabridged_DoSetTooltip(previousFunctionPointer, tooltipName)
	if ( previousFunctionPointer ) then
		previousFunctionPointer();
	end
	local tooltip = getglobal(tooltipName);
	if ( not tooltip ) then
		return;
	end
	if ( (ActionButtonUnabridged_Enabled == 1) ) then
		local spellName, spellRank = ActionButtonUnabridged_GetSpellNameAndRank(tooltipName);
		if (spellName == nil) then
			ActionButtonUnabridged_DebugPrint("ABU: Could not retrieve spell from tooltip.");
			return;
		end
		ActionButtonUnabridged_DebugPrint(format("ABU: Found spell name. Spell '%s'", spellName));
		if (spellRank ~= nil) then
			ActionButtonUnabridged_DebugPrint(format("ABU: Spell had ranks. '%s'", spellRank));
		end
		local tmpID, tmpRank;
		for k, v in ActionButtonUnabridged_BookTypes do
			tmpID, tmpRank = ActionButtonUnabridged_findSpell(spellName, spellRank, v);
			if (tmpID ~= nil) then
		  		ActionButtonUnabridged_DebugPrint("ABU: Setting up tooltip.");
				tooltip:SetSpell(tmpID, v);
				return;
			else
		  		ActionButtonUnabridged_DebugPrint(format("ABU: Failed to find spell in spellbook '%s'.", v));
			end
		end
	end
end

function ActionButtonUnabridged_ActionButton_SetTooltip()
	ActionButtonUnabridged_DoSetTooltip(ActionButtonUnabridged_Saved_Pointers["ActionButton_SetTooltip"], "GameTooltip");
end
	
function ActionButtonUnabridged_SecondActionButton_SetTooltip()
	ActionButtonUnabridged_DoSetTooltip(ActionButtonUnabridged_Saved_Pointers["SecondActionButton_SetTooltip"], "GameTooltip");
end

function ActionButtonUnabridged_SideBarButton_SetTooltipLeft()
	ActionButtonUnabridged_DoSetTooltip(ActionButtonUnabridged_Saved_Pointers["SideBarButton_SetTooltipLeft"], "CosmosTooltip");
end

function ActionButtonUnabridged_SideBarButton_SetTooltipRight()
	ActionButtonUnabridged_DoSetTooltip(ActionButtonUnabridged_Saved_Pointers["SideBarButton_SetTooltipRight"], "CosmosTooltip");
end


function ActionButtonUnabridged_Print(msg,r,g,b,frame,id,unknown4th)
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

function ActionButtonUnabridged_GetSpellNameAndRank(tooltip)
	local strings = ActionButtonUnabridgedTooltip_ScanTooltip(tooltip);
	if ( ( strings ~= nil ) and ( table.getn(strings) >= 1) ) then
		local spellName = strings[1].left;
		local spellRank = nil;
		if ( ( table.getn(strings) >= 2) ) then
			spellRank = strings[2].left;
		end
		return spellName, spellRank;
	else
		ActionButtonUnabridged_DebugPrint("ABU: Tooltip was empty.");
		return nil, nil;
	end
end

function ActionButtonUnabridged_DebugPrint(msg)
	if ( ActionButtonUnabridged_Debug_Enabled == 1 ) then
		ActionButtonUnabridged_Print(msg);
	end
end

-- Helper methods from Cosmos
-- All credit should go to the Cosmos team for this one!

-- Gets all lines out of a tooltip.
function ActionButtonUnabridgedTooltip_ScanTooltip(TooltipNameBase)
	if ( TooltipNameBase == nil ) then 
		TooltipNameBase = "ActionButtonUnabridgedTooltip";
	end
	
	local strings = {};
	for idx = 1, 10 do
		local textLeft = nil;
		local textRight = nil;
		ttext = getglobal(TooltipNameBase.."TextLeft"..idx);
		if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
		then
			textLeft = ttext:GetText();
		end
		ttext = getglobal(TooltipNameBase.."TextRight"..idx);
		if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
		then
			textRight = ttext:GetText();
		end
		if (textLeft or textRight)
		then
			strings[idx] = {};
			strings[idx].left = textLeft;
			strings[idx].right = textRight;
		end
	end
	
	return strings;
end

-- Obtains all information about a bag/slot and returns it as an array 
function ActionButtonUnabridgedTooltip_GetItemInfoStrings(bag,slot, TooltipNameBase)
	if ( TooltipNameBase == nil ) then 
		TooltipNameBase = "ActionButtonUnabridgedTooltip";
	end

	--ClearTooltip(TooltipNameBase);

	local tooltip = getglobal(TooltipNameBase);
	
	-- Open tooltip & read contents
	tooltip:SetBagItem( bag, slot );
	local strings = ActionButtonUnabridgedTooltip_ScanTooltip(TooltipNameBase);

	-- Done our duty, send report
	return strings;
end


-- the following was taken and adapted from ActionButtonUnabridged, an AddOn by Munelear.

function ActionButtonUnabridged_findSpell(name,rank,bookType)
	local spellName = nil;
	local subSpellName = nil;
	local i = 1;
	local j = 1;
	
	local tempID,tempRank = nil;
	
	spellName, subSpellName = GetSpellName(i,bookType);
	while spellName do
	  	if (spellName == name) then
	  		ActionButtonUnabridged_DebugPrint("ABU: Found matching spell.");
			if ( (rank == subSpellName) or (rank == nil) ) then
				tempID = i;
  				tempRank = subSpellName;
				return tempID, tempRank;
			end
	  	end

		i = i + 1;
		spellName,subSpellName = nil;
		spellName,subSpellName = GetSpellName(i,bookType);
	end
	
	return nil,nil;
end

