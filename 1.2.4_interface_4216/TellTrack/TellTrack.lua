--[[
	Tell Track

	By sarf & Lash
	Modified by AnduinLothar.

	This mod allows you to keep track of people you have sent tells to.

	Thanks goes to Lash for the idea, support and the development of the XML file 
	(as well as providing acceleration to the rear end of sarf).
	Remember, only Lash prevented your CPU from suffering from loops galore!
	
	CosmosUI URL:
	http://www.cosmosui.org/
	
	Change Log:
	v1.1 (2/11/05) - Taken Over by AnduinLothar:
		-The newest whisper appears on the bottom and TellTrack auto-scrolls when updated.
		-Also added a "Delete All" option to the right-click menu.
		-Now monitors incomming whispers and adds their sender to the list.
		-If they were the last one to whisper their name is red. If you whispered last their name is green.
		-Added /re or /retell slash commands to whisper the last person you whispered.
		-Made retell bindable too. (I use shift-r)
		-Works w/o cosmos now.
	v1.2 (2/15/05) 
		-TellTrack is now resizable! Drag the bottom right corner. Remade button graphics to stretch correctly.
		-Added ability to extend up to 20 or down to 2 visible names.
		-List is now invertable "/telltrackinvert" or use cosmos options or right-click menu (cosmos only).
		-Bugfix for variable saving for non-cosmos users.
	v1.21 (2/15/05) 
		-Updated the toc version number to 4211.
		-Updated the right-click menu height
	v1.22 (2/15/05) 
		-Compressed images.
		-Made image alpha layers compatible with UI transparency (TransNUI)
	v1.23 (2/19/05)
		-Fixed name length trunkating.
		-Fixed right-click indexing and menu problems.
		-Added resize tooltip.
		-Optimized the arrow buttons code.
		-Fixed a rare bug where if you closed TellTrack while resizing or moving you couldn't click on anything.
		-Tooltip now scales correctly (set parent to UIParent)
	v1.24 (2/21/05) 
		-Fixed too many buttons showing onload.
		-Fixed unhooking issue with Sky.
		-Fixed reseting offset on Cosmos options cancil and login/reload.
	v1.25 (2/21/05)
		-Fixed Resize bug with too many buttons showing
	
   ]]--

-- Variables

TellTrack_ButtonCount = 4;
TellTrack_TooltipSetId = 0;
TellTrack_Array = {};
TellTrack_ID = 0;
TellTrack_LastTell = nil;
TellTrack_ArrayMaxSize = 20;
TellTrack_ArrayOffset = 1;

local SavedSendChatMessage = nil;

-- executed on load, calls general set-up functions
function TellTrack_OnLoad()
	TellTrack_Register();
	TellTrack_UpdateTellTrackButtonsText();
	
	-- Hook the chat event handler on the front
	if (SendChatMessage ~= SavedSendChatMessage) then
		SavedSendChatMessage = SendChatMessage;
		SendChatMessage = TellTrack_SendChatMessage;
	end
	
end

-- registers the mod with Cosmos
function TellTrack_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( not TellTrack_Cosmos_Registered ) ) then
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
		Cosmos_RegisterConfiguration(
			"COS_TELLTRACK_INVERTED",
			"CHECKBOX",
			TELLTRACK_INVERTED,
			TELLTRACK_INVERTED_INFO,
			TellTrack_Toggle_Inverted,
			TellTrack_InvertedList
		);
		if ( Cosmos_RegisterChatCommand ) then
			local TellTrackEnableCommands = {"/telltracktoggle","/ttracktoggle","/telltrackenable","/ttrocknenable","/telltrackdisable","/ttrackdisable","/telltrack"};
			Cosmos_RegisterChatCommand (
				"TELLTRACK_ENABLE_COMMANDS", -- Some Unique Group ID
				TellTrackEnableCommands, -- The Commands
				TellTrack_Enable_ChatCommandHandler,
				TELLTRACK_CHAT_COMMAND_ENABLE_INFO -- Description String
			);
			local TellTrackInvertCommands = {"/telltrackinvert","/ttrackinvert"};
			Cosmos_RegisterChatCommand (
				"TELLTRACK_INVERT_COMMANDS", -- Some Unique Group ID
				TellTrackInvertCommands, -- The Commands
				TellTrack_Invert_ChatCommandHandler,
				TELLTRACK_CHAT_COMMAND_INVERT_INFO -- Description String
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
		RegisterForSave("TellTrack_Enabled");
		SlashCmdList["TELLTRACKSLASHINVERT"] = TellTrack_Invert_ChatCommandHandler;
		SLASH_TELLTRACKSLASHINVERT1 = "/telltrackinvert";
		SLASH_TELLTRACKSLASHINVERT2 = "/ttrackinvert";
		RegisterForSave("TellTrack_InvertedList");
	end
        
	SlashCmdList["TELLTRACKRETELL"] = TellTrack_WhisperToPreviousTarget;
	SLASH_TELLTRACKRETELL1 = "/re";
	SLASH_TELLTRACKRETELL2 = "/retell";
        
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_WHISPER");

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

-- Handles chat - e.g. slashcommands - inverting/normalizing the TellTrack list
function TellTrack_Invert_ChatCommandHandler(msg)
	if msg == nil then
		msg = "";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		TellTrack_Toggle_Inverted(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			TellTrack_Toggle_Inverted(0);
		else
			TellTrack_Toggle_Inverted(-1);
		end
	end
end

-- Does things with the hooked function
function TellTrack_SendChatMessage(text, type, language, target)
        -- saves target for 'Retell' regardless of TellTrack_Enabled
	if ( type == "WHISPER" ) then
		TellTrack_LastTell = target;
	end
	if ( TellTrack_Enabled == 1 ) then
		if ( type == "WHISPER" ) then 
			-- prevent data message transfers from being used
			if ( strsub(text, 1, 1) ~= "<" ) then
				TellTrack_HandleMessageSentOrRecieved(target, false);
			end
		end
	end
	SavedSendChatMessage(text, type, language, target);
end


-- Handles events
function TellTrack_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		local value = TellTrack_Enabled;
		if ( TellTrack_Cosmos_Registered ) then
			value = getglobal("COS_TELLTRACK_ENABLED_X");
			TellTrack_InvertedList = getglobal("COS_TELLTRACK_INVERTED_X");
		end
		if (value == nil) then
			-- defaults to off
			value = 0;
		end
		if (TellTrack_InvertedList == nil) then
			-- defaults to off
			TellTrack_InvertedList = 0;
		end
		TellTrack_ModifyButtonCount(this:GetHeight());
		TellTrack_Toggle_Enabled(value);
		TellTrack_LoadNames();
	elseif ( event == "CHAT_MSG_WHISPER" ) then
		TellTrack_HandleMessageSentOrRecieved(arg2, true);
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
	if ( ( newvalue ~= oldvalue ) and ( not TellTrack_Cosmos_Registered ) ) then
		if ( newvalue == 1 ) then
			TellTrack_Print(TEXT(getglobal(enableMessage)));
		else
			TellTrack_Print(TEXT(getglobal(disableMessage)));
		end
	end
	TellTrack_Register_Cosmos();
	if ( not TellTrack_Cosmos_Registered ) then 
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
	local oldvalue = TellTrack_Enabled;
	local newvalue = TellTrack_Generic_Toggle(toggle, "TellTrack_Enabled", "COS_TELLTRACK_ENABLED", "TELLTRACK_CHAT_ENABLED", "TELLTRACK_CHAT_DISABLED", "COS_TELLTRACK_ENABLED");
	--only change telltrack and tooltip visibility if TellTrack_Enabled was changed
	if ( oldvalue ~= newvalue ) then
		if ( TellTrack_Enabled == 0 ) then
			TellTrackFrame:Hide();
			if ( TellTrackTooltip:IsVisible() ) then
				TellTrackTooltip:Hide();
			end
		else
			TellTrackFrame:Show();
		end
	end
end

-- Toggles the inverted/normalized state of the TellTrack list
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function TellTrack_Toggle_Inverted(toggle)
	local oldvalue = TellTrack_InvertedList;
	local newvalue = TellTrack_Generic_Toggle(toggle, "TellTrack_InvertedList", "COS_TELLTRACK_INVERTED", "TELLTRACK_CHAT_INVERTED", "TELLTRACK_CHAT_NORMALIZED", "COS_TELLTRACK_INVERTED");
	--only change (reset offset) telltrack if TellTrack_InvertedList was changed
	if ( oldvalue ~= newvalue ) then
		if ( newvalue == 1 ) then
			TellTrack_ChangeArrayOffset(TellTrack_ArrayMaxSize);
		else
			TellTrack_ChangeArrayOffset(1);
		end
		TellTrack_UpdateTellTrackButtonsText();
	end
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

function TellTrack_ArrowButton_OnLoad(frame)
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
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

-- 1/20/05 'Retell' added by AnduinLothar
function TellTrack_InitiateWhisperToPreviousTarget()
	if ( not TellTrack_LastTell ) then
		return;
	end
	TellTrack_InitiateWhisperToTarget(TellTrack_LastTell);
end

function TellTrack_WhisperToPreviousTarget(msg)
	if ( not TellTrack_LastTell ) then
		return;
	end
	TellTrack_SendChatMessage(msg, "WHISPER", this.language, TellTrack_LastTell);
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

-- Function by AnduinLothar used in right click menu

function TellTrack_Menu_DeleteAll()
	--Print("TT: Reseting Tell List");
	TellTrack_Array = {};
	--Print("TT: Updating Tell Track Button");
	TellTrack_UpdateTellTrackButtonsText();
	-- saves the names to the list
	TellTrack_SaveNames();
end

-- Modified by AnduinLothar to add "Delete All", and "Invert List"

function TellTrackTextButton_CreateMenuArray()
	local info = { }
	info[1] = { text = "   "..BINDING_HEADER_TELLTRACKHEADER, isTitle = 1 };
	info[2] = { text = TELLTRACK_WHISPER, func = TellTrack_Menu_Whisper };
	info[2] = { text = TELLTRACK_WHO, func = TellTrack_Menu_Who };
	info[3] = { text = TELLTRACK_GRPINV, func = TellTrack_Menu_GroupeInvite };
	info[4] = { text = TELLTRACK_ADDFRIEND, func = TellTrack_Menu_AddToFriend };
	info[5] = { text = TELLTRACK_DELETE, func = TellTrack_Menu_Delete };
	info[6] = { text = "|cFFCCCCCC--------------|r", disabled = 1, notClickable = 1 };
	info[7] = { text = TELLTRACK_DELETE_ALL, func = TellTrack_Menu_DeleteAll };
	info[8] = { text = TELLTRACK_INVERT, func = TellTrack_Invert_ChatCommandHandler };
	info[9] = { text = "|cFFCCCCCC--------------|r", disabled = 1, notClickable = 1 };
	info[10] = { text = TELLTRACK_CANCEL, func = function () end };
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
		
		-- fiddle with the menu size so it looks nice (needs to be changed if menu size changes)
		DropDownList1:SetWidth(100);
		DropDownList1:SetHeight(164);
		
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
	if ( TellTrack_Array[TellTrack_GetArrayId(id)] == nil ) then
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
	local newID
	if ( TellTrack_InvertedList == 1 ) then
		newID = TellTrack_ArrayMaxSize - (id + TellTrack_ArrayOffset) + 2;
	else
		newID = (id + TellTrack_ArrayOffset) - 1;
	end
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
	a = TellTrack_GetByteValue(a); r = TellTrack_GetByteValue(r); g = TellTrack_GetByteValue(g); b = TellTrack_GetByteValue(b);
	
	--return format("[c%02X%02X%02X%02X%%s]r", a, r, g, b);
	return format("|c%02X%02X%02X%02X%%s|r", a, r, g, b);
end

function TellTrack_UpdateTellTrackButtonsText()
	local lastSentToNameFormatStr = TellTrack_GetColorFormatString(0.2, 1.0, 0.2);
	local lastRecievedFromNameFormatStr = TellTrack_GetColorFormatString(1.0, 0.2, 0.2);
	local noNameFormatStr = TellTrack_GetColorFormatString(0.4, 0.4, 0.4);
	local id = 0;
	for i = 1, TellTrack_ButtonCount do
		local buttonText = getglobal("TellTrack"..i.."Text");
		local formatStr, valueStr;
		id = TellTrack_GetArrayId(i);
		if ( ( TellTrack_Array[id] ) and ( TellTrack_Array[id].name ) ) then
			if( TellTrack_Array[id].sentTo ) then
				formatStr = lastSentToNameFormatStr;
			else
				formatStr = lastRecievedFromNameFormatStr;
			end
			valueStr = TellTrack_Array[id].name;
		else
			formatStr = noNameFormatStr;
			valueStr = "Empty";
		end
		valueStr = id..". "..valueStr;
		if ( buttonText ) then
			buttonText:SetText(format(formatStr, valueStr));
			buttonText:Show();
		end
	end
end

--[[ The following function was edited by AnduinLothar (1/15/05)
		to add the following features:

	 The last person whispered is automaticly moved to the bottom
	of the list and everytime you whisper it autoscrolls to the 
	bottom of the list.  Also if the list is full the top name is
	deleted and the new name is appended to the bottom.
        
        1/17/05
	Added recieved/sent boolean for color on button reload.
	
]]--
function TellTrack_HandleMessageSentOrRecieved(target, recieved)
	local tempName = strlower(target);
	local firstEmptySlotIndex = nil;
	local previousNameInstance = nil;
	for i = 1, TellTrack_ArrayMaxSize do
		if ( ( not firstEmptySlotIndex ) and ( not TellTrack_Array[i] )) then
			--Print("TT: First empty slot "..i);
			firstEmptySlotIndex = i;
		elseif( not firstEmptySlotIndex ) then
			if( TellTrack_Array[i].compareName == tempName ) then
				--Print("TT: Found in array");
				previousNameInstance = i;
			end
		end
	end
	if( (not firstEmptySlotIndex) and (not previousNameInstance) ) then
		--Print("TT: No empty slots found, deleting first name");
		TellTrack_Array[1] = nil;
		TellTrack_CompressList();
		firstEmptySlotIndex = TellTrack_ArrayMaxSize;
	elseif( (not firstEmptySlotIndex) and previousNameInstance) then
		firstEmptySlotIndex = TellTrack_ArrayMaxSize+1;
	end
	for i = 1, TellTrack_ArrayMaxSize do
		if ( previousNameInstance == i and firstEmptySlotIndex == i+1) then
			--Print("TT: Name found is last name sent "..i);
			TellTrack_Array[i].sentTo = not recieved;
			firstEmptySlotIndex = firstEmptySlotIndex-1
		elseif ( previousNameInstance == i and firstEmptySlotIndex ~= i+1) then
			--Print("TT: Removing old instance at "..i);
			TellTrack_Array[i] = nil;
			TellTrack_CompressList()
			firstEmptySlotIndex = firstEmptySlotIndex-1;
		elseif ( firstEmptySlotIndex == i ) then
			--Print("TT: Adding to array "..i);
			TellTrack_Array[i] = {};
			TellTrack_Array[i].name = target;
			TellTrack_Array[i].compareName = tempName;
			TellTrack_Array[i].sentTo = not recieved;
			if( i > TellTrack_ButtonCount and (i-TellTrack_ButtonCount+1) ~= TellTrack_ArrayOffset ) then
				TellTrack_ChangeArrayOffset(i-TellTrack_ButtonCount+1);
			end
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

function TellTrack_ResizeButton_OnEnter()
	TellTrackTooltip:SetOwner(TellTrackFrame, "ANCHOR_TOPLEFT");
	TellTrackTooltip:SetText(TELLTRACK_RESIZE_TOOLTIP);
end

function TellTrack_ResizeButton_OnLeave()
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
	--1/20/05 now aditionally loads sentTo instead of just names. This allows loading of 'recieved/sent' status.
	if ( list ) then
		for k, v in list do
			if(type(v) == "table") then
				if(v.name and v.sentTo ~= nil) then
					TellTrack_HandleMessageSentOrRecieved(v.name, not v.sentTo);
				elseif(v.name) then
					TellTrack_HandleMessageSentOrRecieved(v.name, false);
				end
                        elseif(type(v) == "string") then
				TellTrack_HandleMessageSentOrRecieved(v, false); --Support for previous TellTrack Saved Lists (all are marked as sent)
			end
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
	--[[
	local list = {};
	for k, v in TellTrack_Array do
		if (v.name) then
			table.insert(list, v.name);
		end
	end
	]]--
	 --1/20/05 now saves whole array instead of just names. This allows saving of 'recieved/sent' status.
	list = TellTrack_Array;
        
	if ( not TellTrack_SavedList ) then
		TellTrack_SavedList = {};
	end
	TellTrack_SavedList[index] = list;
	RegisterForSave("TellTrack_SavedList");
end

-- helper function - returns value as a byte
function TellTrack_GetByteValue(pValue)
	local value = tonumber(pValue);
	if ( value <= 0 ) then return 0; end
	if ( value >= 255 ) then return 255; end
	return value;
end


function TellTrack_ModifyButtonCount(height)
	height = height - 44;   --insets and arrow buttons
	local newCount = floor((height)/20);
	if ( newCount ~= TellTrack_ButtonCount ) then
		TellTrack_ButtonCount = newCount;
		for i=1, TellTrack_ArrayMaxSize do
			local thisButton = getglobal("TellTrack"..i);
			if not thisButton:IsVisible() and i <= TellTrack_ButtonCount then
				thisButton:Show();
			elseif thisButton:IsVisible() and i > TellTrack_ButtonCount then
				thisButton:Hide();
			end
		end
	end
	local offset = floor((height-TellTrack_ButtonCount*20+20)/2);
	TellTrackFrameArrowUpButton:SetHeight(offset);
	TellTrackFrameArrowDownButton:SetHeight(offset);
end

function TellTrackFrame_OnSizeChanged()
	local width = TellTrackFrame:GetWidth()-24;
	TellTrackFrameArrowUpButton:SetWidth(width);
	for i=1, TellTrack_ArrayMaxSize do
		getglobal("TellTrack"..i):SetWidth(width);
	end
	TellTrackFrameArrowDownButton:SetWidth(width);
	TellTrack_ModifyButtonCount(TellTrackFrame:GetHeight());
	TellTrack_ChangeArrayOffset(TellTrack_ArrayOffset);
	TellTrack_UpdateTellTrackButtonsText();
end

function TellTrack_ArrowButton_OnSizeChanged(frame)
	local height = frame:GetHeight();
	getglobal(frame:GetName().."RightBG"):SetHeight(height);
	getglobal(frame:GetName().."LeftBG"):SetHeight(height);
	getglobal(frame:GetName().."Arrow"):SetHeight(height);
end

