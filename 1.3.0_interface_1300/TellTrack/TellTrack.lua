--[[
	Tell Track

	By sarf & Lash

	This mod allows you to keep track of people you have sent tells to.

	Thanks goes to Lash for the idea, support and the development of the XML file 
	(as well as providing acceleration to the rear end of sarf).
	Remember, only Lash prevented your CPU from suffering from loops galore!
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants

-- Variables
TellTrack_Enabled = 0;

TellTrack_ButtonCount = 4;
TellTrack_MaximumNameLength = 11;
TellTrack_TooltipSetId = 0;
TellTrack_Array = {};
TellTrack_ID = 0;

TellTrack_ArrayMaxSize = 20;
TellTrack_ArrayOffset = 1;

TellTrack_Saved_SendChatMessage = nil;
TellTrack_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function TellTrack_OnLoad()
	TellTrack_Register();
	TellTrack_UpdateTellTrackButtonsText();
end

-- registers the mod with Cosmos
function TellTrack_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( TellTrack_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_TELLTRACK",
			"SECTION",
			TELLTRACK_CONFIG_HEADER,
			TELLTRACK_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_TELLTRACK_HEADER",
			"SEPARATOR",
			TELLTRACK_CONFIG_HEADER,
			TELLTRACK_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_TELLTRACK_ENABLED",
			"CHECKBOX",
			TELLTRACK_ENABLED,
			TELLTRACK_ENABLED_INFO,
			TellTrack_Toggle_Enabled,
			TellTrack_Enabled
		);
		if ( Cosmos_RegisterChatCommand ) then
			local TellTrackEnableCommands = {"/telltracktoggle","/ttracktoggle","/telltrackenable","/ttrocknenable","/telltrackdisable","/ttrackdisable","/telltrack"};
			Cosmos_RegisterChatCommand (
				"TELLTRACK_ENABLE_COMMANDS", -- Some Unique Group ID
				TellTrackEnableCommands, -- The Commands
				TellTrack_Enable_ChatCommandHandler,
				TELLTRACK_CHAT_COMMAND_ENABLE_INFO -- Description String
			);
		end
		TellTrack_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function TellTrack_Register()
	if ( Cosmos_RegisterConfiguration ) then
		TellTrack_Register_Cosmos();
	else
		SlashCmdList["TELLTRACKSLASHENABLE"] = TellTrack_Enable_ChatCommandHandler;
		SLASH_TELLTRACKSLASHENABLE1 = "/telltracktoggle";
		SLASH_TELLTRACKSLASHENABLE2 = "/ttracktoggle";
		SLASH_TELLTRACKSLASHENABLE3 = "/telltrackenable";
		SLASH_TELLTRACKSLASHENABLE4 = "/ttrackenable";
		SLASH_TELLTRACKSLASHENABLE5 = "/telltrackdisable";
		SLASH_TELLTRACKSLASHENABLE6 = "/ttrackdisable";
		SLASH_TELLTRACKSLASHENABLE7 = "/telltrack";
	end
	this:RegisterEvent("VARIABLES_LOADED");

	if ( TransNUI_RegisterUI ) then
		TransNUI_RegisterUI("TellTrackFrame", { "telltrack" }, TELLTRACK_CONFIG_TRANSNUI, TELLTRACK_CONFIG_TRANSNUI_INFO, 0);
	end
	if ( PopNUI_RegisterUI ) then
		PopNUI_RegisterUI("TellTrackFrame", { "telltrack" }, {"TellTrack_Enabled", 1, true}, TELLTRACK_CONFIG_POPNUI, TELLTRACK_CONFIG_POPNUI_INFO);
	end
end

-- Handles chat - e.g. slashcommands - enabling/disabling the TellTrack
function TellTrack_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		TellTrack_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			TellTrack_Toggle_Enabled(0);
		else
			TellTrack_Toggle_Enabled(-1);
		end
	end
end

-- Does things with the hooked function
function TellTrack_SendChatMessage(text, type, language, target)
	if ( TellTrack_Enabled == 1 ) then
		if ( type == "WHISPER" ) then 
			-- prevent data message transfers from being used
			if ( strsub(text, 1, 1) ~= "<" ) then
				TellTrack_HandleSentMessageToSomeone(target);
			end
		end
	end
	TellTrack_Saved_SendChatMessage(text, type, language, target);
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function TellTrack_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( SendChatMessage ~= TellTrack_SendChatMessage ) and (TellTrack_Saved_SendChatMessage == nil) ) then
			TellTrack_Saved_SendChatMessage = SendChatMessage;
			SendChatMessage = TellTrack_SendChatMessage;
		end
	else
		if ( SendChatMessage == TellTrack_SendChatMessage) then
			SendChatMessage = TellTrack_Saved_SendChatMessage;
			TellTrack_Saved_SendChatMessage = nil;
		end
	end
end

-- Handles events
function TellTrack_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( TellTrack_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_TELLTRACK_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			TellTrack_Toggle_Enabled(value);
		end
		TellTrack_LoadNames();
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function TellTrack_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
	if ( ( newvalue ~= oldvalue ) and ( TellTrack_Cosmos_Registered == 0 ) ) then
		if ( newvalue == 1 ) then
			TellTrack_Print(TEXT(getglobal(enableMessage)));
		else
			TellTrack_Print(TEXT(getglobal(disableMessage)));
		end
	end
	TellTrack_Register_Cosmos();
	if ( TellTrack_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
		RegisterForSave(CVarName);
	else
		if ( CosmosVarName ) then
			Cosmos_UpdateValue(CosmosVarName, CSM_CHECKONOFF, newvalue);
			Cosmos_SetCVar(CosmosVarName, newvalue);
		end
	end
	return newvalue;
end

-- Toggles the enabled/disabled state of the TellTrack
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function TellTrack_Toggle_Enabled(toggle)
	local newvalue = TellTrack_Generic_Toggle(toggle, "TellTrack_Enabled", "COS_TELLTRACK_ENABLED", "TELLTRACK_CHAT_ENABLED", "TELLTRACK_CHAT_DISABLED", "COS_TELLTRACK_ENABLED");
	if ( newvalue == 0 ) then
		TellTrackFrame:Hide();
		if ( TellTrackTooltip:IsVisible() ) then
			TellTrackTooltip:Hide();
		end
	else
		TellTrackFrame:Show();
	end
	TellTrack_Setup_Hooks(newvalue);
end

-- Prints out text to a chat box.
function TellTrack_Print(msg,r,g,b,frame,id,unknown4th)
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

function TellTrack_ArrowUpButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TellTrack_ArrowUpButton_OnClick(button)
	local id = this:GetID();
	if ( not id ) then
		return
	end
	if ( button == "RightButton" ) then
		TellTrack_ChangeArrayOffset(1);
	elseif ( button == "LeftButton" ) then
		TellTrack_PageUp();
	end
end

function TellTrack_ArrowDownButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TellTrack_ArrowDownButton_OnClick(button)
	local id = this:GetID();
	if ( not id ) then
		return;
	end
	if ( button == "RightButton" ) then
		TellTrack_ChangeArrayOffset(TellTrack_ArrayMaxSize);
	elseif ( button == "LeftButton" ) then
		TellTrack_PageDown();
	end
end

function TellTrack_QButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TellTrack_QButton_OnClick(button)
	local id = this:GetID();
	if ( not id ) then
		return
	end
	TellTrack_Print(TELLTRACK_CHAT_QUESTION_MARK_INFO,1.0,1.0,0);
end

function TellTrackTextButton_OnEnter()
	local id = this:GetID();
	if ( id ) then
		TellTrackTooltip:SetOwner(TellTrackFrame, "ANCHOR_TOPLEFT");
		TellTrackSetTooltip(id);
	end
end

function TellTrackTextButton_OnLeave()
	if ( TellTrackTooltip:IsOwned(TellTrackFrame) ) then
		TellTrackTooltip:Hide();
	end
end

function TellTrackTextButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TellTrack_InitiateWhisperByID(id)
	local name = TellTrackGetName(id);
	TellTrack_InitiateWhisperToTarget(name);
end

function TellTrack_InitiateWhisperToTarget(name)
	if ( not name ) then
		return;
	end
	local chatFrame = DEFAULT_CHAT_FRAME;
	chatFrame.editBox.chatType = "WHISPER";
	chatFrame.editBox.tellTarget = name;
	ChatEdit_UpdateHeader(chatFrame.editBox);
	if ( not chatFrame.editBox:IsVisible() ) then
		ChatFrame_OpenChat("", chatFrame);
	end
end

function TellTrack_Menu_Whisper()
	TellTrack_InitiateWhisperByID(TellTrack_ID);
end

function TellTrack_Menu_Who()
	local name = TellTrackGetName(TellTrack_ID);
	SendWho("n-\""..name.."\"");
end

function TellTrack_Menu_GroupeInvite()
	local name = TellTrackGetName(TellTrack_ID);
	InviteByName(name);
end

function TellTrack_Menu_AddToFriend()
	local name = TellTrackGetName(TellTrack_ID);
	AddFriend(name);
end

function TellTrack_Menu_Delete()
	TellTrack_EraseByID(TellTrack_ID);
end

function TellTrackTextButton_CreateMenuArray()
	local info = { }
	info[1] = { text = "   "..BINDING_HEADER_TELLTRACKHEADER, isTitle = 1 };
	info[2] = { text = TELLTRACK_WHISPER, func = TellTrack_Menu_Whisper };
	info[2] = { text = TELLTRACK_WHO, func = TellTrack_Menu_Who };
	info[3] = { text = TELLTRACK_GRPINV, func = TellTrack_Menu_GroupeInvite };
	info[4] = { text = TELLTRACK_ADDFRIEND, func = TellTrack_Menu_AddToFriend };
	info[5] = { text = TELLTRACK_DELETE, func = TellTrack_Menu_Delete };
	info[6] = { text = "|cFFCCCCCC--------------|r", disabled = 1, notClickable = 1 };
	info[7] = { text = TELLTRACK_CANCEL, func = function () end };
	return info;
end

function TellTrackTextButton_GetMenuLevels(menu)
	if ( not menu ) then
		return 0;
	end
	local menuLevels = 1;
	for i = 1, getn(menu) do
		if ( menu[i][1] ) then
			menuLevels = menuLevels + TellTrackTextButton_GetMenuLevels(menu[i]);
			break;
		end
	end
	return menuLevels;
end

function TellTrackTextButton_ShowMenu()
	if (CosmosMaster_MenuOpen) then
		local info = TellTrackTextButton_CreateMenuArray();
		CosmosMaster_MenuOpen(info, 1, this:GetName(), 25, 20);
		
		-- fiddle with the menu settings so it looks nice - Lash's code! (slightly rewritten)
		
		DropDownList1:SetWidth(80);
		DropDownList1:SetHeight(118);
		local listName = "DropDownList1";
		local baseName = listName.."Button";
		for menuLevel = 1, TellTrackTextButton_GetMenuLevels(info) do
			listName = "DropDownList"..menuLevel;
			baseName = listName.."Button";
			local obj = nil;
			for i = 1, getn(info) do
				obj = getglobal(baseName..i);
				if ( obj ) then
					obj:SetPoint("TOPLEFT", listName, "TOPLEFT", -20, -5 + ( (i-1) * -15));
				end
			end
		end
		return true;
	end
	return false;
end

function TellTrackTextButton_OnClick(button)
	local id = this:GetID();
	if ( not id ) then
		return;
	end
	if ( TellTrack_Array[id] == nil ) then
		return;
	end
	TellTrack_ID = id;
	if ( button == "RightButton" ) then
		if ( not TellTrackTextButton_ShowMenu() ) then
			TellTrack_EraseByID(id);
		end
	elseif ( button == "LeftButton" ) then
		TellTrack_InitiateWhisperByID(id);
	end
end

function TellTrack_GetArrayId(id)
	local newID = (id + TellTrack_ArrayOffset)-1;
	return newID;
end

function TellTrack_EraseByID(id)
	if ( id ) then
		id = TellTrack_GetArrayId(id);
		if ( TellTrack_Array ) and ( TellTrack_Array[id] ) then
			if ( ( TellTrackTooltip:IsVisible() ) and ( TellTrack_TooltipSetId == id ) ) then
				TellTrackTooltip:Hide();
			end
			TellTrack_Array[id] = nil;
		end
		TellTrack_CompressList();
		TellTrack_UpdateTellTrackButtonsText();
	end
end

function TellTrackGetName(id)
	if ( id ) then
		id = TellTrack_GetArrayId(id);
		if ( ( TellTrack_Array ) and ( TellTrack_Array[id] ) and ( TellTrack_Array[id].name ) ) then
			return TellTrack_Array[id].name;
		end
	end
	return nil;
end

function TellTrackSetTooltip(id)
	local name = TellTrackGetName(id);
	if ( name ) then
		TellTrackTooltip:SetText(name);
		TellTrack_TooltipSetId = id;
	end
end

-- Yet another function from George Warner, modified a bit to fit my own nefarious purposes. 
-- It can now accept r, g and b specifications, too (leaving out a), as well as handle 255 255 255
-- Source : http://www.cosmosui.org/cgi-bin/bugzilla/show_bug.cgi?id=159
function TellTrack_GetColorFormatString(a, r, g, b)
	local percent = false;
	if ( ( ( not b ) or ( b <= 1 ) ) and ( a <= 1 ) and ( r <= 1 ) and ( g <= 1) ) then percent = true; end
	if ( ( not b ) and ( a ) and ( r ) and ( g ) ) then b = g; g = r; r = a; if ( percent ) then a = 1; else a = 255; end end
	if ( percent ) then a = a * 255; r = r * 255; g = g * 255; b = b * 255; end
	a = Cosmos_GetByteValue(a); r = Cosmos_GetByteValue(r); g = Cosmos_GetByteValue(g); b = Cosmos_GetByteValue(b);
	
	return format("|c%02X%02X%02X%02X%%s|r", a, r, g, b);
end

function TellTrack_UpdateTellTrackButtonsText()
	local gotNameFormatStr = TellTrack_GetColorFormatString(0.2, 1.0, 0.2);
	local noNameFormatStr = TellTrack_GetColorFormatString(0.4, 0.4, 0.4);
	local id = 0;
	for i = 1, TellTrack_ButtonCount do
		local buttonText = getglobal("TellTrack"..i.."Text");
		local formatStr, valueStr;
		id = TellTrack_GetArrayId(i);
		if ( ( TellTrack_Array[id] ) and ( TellTrack_Array[id].name ) ) then
			formatStr = gotNameFormatStr;
			valueStr = TellTrack_Array[id].name;
		else
			formatStr = noNameFormatStr;
			valueStr = "Empty";
		end
		valueStr = id..". "..valueStr;
		if ( buttonText ) then
			if ( strlen(valueStr) > TellTrack_MaximumNameLength ) then
				valueStr = strsub(valueStr, 1, (TellTrack_MaximumNameLength-3)).."...";
			end
			buttonText:SetText(format(formatStr, valueStr));
			buttonText:Show();
		end
	end
end

function TellTrack_HandleSentMessageToSomeone(target)
	local tempName = strlower(target);
	for k, v in TellTrack_Array do
		if ( v.compareName == tempName ) then
			--Print("TT: Found in array");
			return;
		end
	end
	for i = 1, TellTrack_ArrayMaxSize do
		if ( ( not TellTrack_Array[i] ) or ( not TellTrack_Array[i].name ) ) then
			--Print("TT: Found empty slot "..i);
			TellTrack_Array[i] = {};
			TellTrack_Array[i].name = target;
			TellTrack_Array[i].compareName = tempName;
			break;
		end
	end
	--Print("TT: Updating Tell Track Button");
	TellTrack_UpdateTellTrackButtonsText();
	-- saves the names to the list
	TellTrack_SaveNames();
end

-- thanks again to Lash for the idea and the pushing of this function :)
function TellTrack_CompressList()
	local index;
	local otherArray = {};
	index = 1;
	if ( TellTrack_Array ) then
		for k, v in TellTrack_Array do
			otherArray[index] = v;
			index = index + 1;
		end
	end
	TellTrack_Array = otherArray;
	TellTrack_UpdateTellTrackButtonsText();
end


function TellTrack_ChangeArrayOffset(offset)
	local capSize = TellTrack_ArrayMaxSize - TellTrack_ButtonCount+1;
	if ( offset <= 0 ) then
		offset = 1;
	end
	if ( offset > capSize ) then
		offset = capSize;
	end
	TellTrack_ArrayOffset = offset;
	TellTrack_UpdateTellTrackButtonsText();
end

function TellTrack_PageDown()
	TellTrack_ChangeArrayOffset(TellTrack_ArrayOffset + TellTrack_ButtonCount);
end

function TellTrack_PageUp()
	TellTrack_ChangeArrayOffset(TellTrack_ArrayOffset - TellTrack_ButtonCount);
end

function TellTrack_OnMouseWheel(value)
	if ( value > 0 ) then
		TellTrack_ChangeArrayOffset(TellTrack_ArrayOffset - 1);
	elseif ( value < 0 ) then
		TellTrack_ChangeArrayOffset(TellTrack_ArrayOffset + 1);
	end
end


function TellTrack_QButton_OnEnter()
	TellTrackTooltip:SetOwner(TellTrackFrame, "ANCHOR_TOPLEFT");
	TellTrackTooltip:SetText(TELLTRACK_QUESTION_MARK_TOOLTIP);
end

function TellTrack_QButton_OnLeave()
	if ( TellTrackTooltip:IsOwned(TellTrackFrame) ) then
		TellTrackTooltip:Hide();
	end
end

function TellTrack_IsClassHorde(class)
	local hordeClasses = { "Orc", "Tauren", "Troll", "Undead" };
	for k, v in hordeClasses do
		if ( class == v ) then
			return true;
		end
	end
	return false;
end

-- returns the index name for the load/save funcs
function TellTrack_GetListIndex()
	local firstString = GetCVar("realmName");
	local secondString = UnitClass("player");
	--local secondString = UnitName("player");
	if ( not firstString ) or ( not secondString ) then
		return nil;
	end
	if ( TellTrack_IsClassHorde(secondString) ) then
		secondString = "Horde";
	else
		secondString = "Alliance";
	end
	return format("%s_%s", firstString, secondString);
end

function TellTrack_LoadNames()
	local index = TellTrack_GetListIndex();
	if ( not index ) then
		if ( Cosmos_ScheduleByName ) then
			Cosmos_ScheduleByName("TELLTRACK_LOADNAMES", 0.5, TellTrack_LoadNames);
		end
		return;
	end
	if ( not TellTrack_SavedList ) then
		return;
	end;
	local list = TellTrack_SavedList[index];
	if ( list ) then
		for k, v in list do
			TellTrack_HandleSentMessageToSomeone(v);
		end
	end
end

function TellTrack_SaveNames()
	local index = TellTrack_GetListIndex();
	if ( not index ) then
		if ( Cosmos_ScheduleByName ) then
			Cosmos_ScheduleByName("TELLTRACK_SAVENAMES", 0.5, TellTrack_SaveNames);
		end
		return;
	end
	local list = {};
	for k, v in TellTrack_Array do
		if (v.name) then
			table.insert(list, v.name);
		end
	end
	if ( not TellTrack_SavedList ) then
		TellTrack_SavedList = {};
	end
	TellTrack_SavedList[index] = list;
	RegisterForSave("TellTrack_SavedList");
end

