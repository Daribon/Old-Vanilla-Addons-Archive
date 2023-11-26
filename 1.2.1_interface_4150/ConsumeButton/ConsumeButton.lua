--[[
	Consume Button

	By sarf

	This mod creates a window that displays your food/drink resources and allows you to click it to use them both.

	Thanks goes to sancus for the idea and the nagging. :)
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants

-- Variables
ConsumeButton_Enabled = 0;
ConsumeButton_Large = 1;

ConsumeButton_Saved_Hooked_Function = nil;
ConsumeButton_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function ConsumeButton_OnLoad()
	ConsumeButton_Register();
end

-- registers the mod with Cosmos
function ConsumeButton_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( ConsumeButton_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_CONSUMEBUTTON",
			"SECTION",
			TEXT(CONSUMEBUTTON_CONFIG_HEADER),
			TEXT(CONSUMEBUTTON_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_CONSUMEBUTTON_HEADER",
			"SEPARATOR",
			TEXT(CONSUMEBUTTON_CONFIG_HEADER),
			TEXT(CONSUMEBUTTON_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_CONSUMEBUTTON_ENABLED",
			"CHECKBOX",
			TEXT(CONSUMEBUTTON_ENABLED),
			TEXT(CONSUMEBUTTON_ENABLED_INFO),
			ConsumeButton_Toggle_Enabled_NoChat,
			ConsumeButton_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_CONSUMEBUTTON_LARGE",
			"CHECKBOX",
			TEXT(CONSUMEBUTTON_LARGE),
			TEXT(CONSUMEBUTTON_LARGE_INFO),
			ConsumeButton_Toggle_Large_NoChat,
			ConsumeButton_Large
		);
		if ( Cosmos_RegisterChatCommand ) then
			local ConsumeButtonMainCommands = {"/consumebutton","/cb"};
			Cosmos_RegisterChatCommand (
				"CONSUMEBUTTON_MAIN_COMMANDS", -- Some Unique Group ID
				ConsumeButtonMainCommands, -- The Commands
				ConsumeButton_Main_ChatCommandHandler,
				CONSUMEBUTTON_CHAT_COMMAND_INFO -- Description String
			);
		end
		ConsumeButton_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function ConsumeButton_Register()
	if ( Cosmos_RegisterConfiguration ) then
		ConsumeButton_Register_Cosmos();
	else
		SlashCmdList["CONSUMEBUTTONSLASHMAIN"] = ConsumeButton_Main_ChatCommandHandler;
		SLASH_CONSUMEBUTTONSLASHMAIN1 = "/consumebutton";
		SLASH_CONSUMEBUTTONSLASHMAIN2 = "/cb";
		this:RegisterEvent("VARIABLES_LOADED");
	end
end

function ConsumeButton_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the ConsumeButton
function ConsumeButton_Main_ChatCommandHandler(msg)
	
	local func = ConsumeButton_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		ConsumeButton_Print(CONSUMEBUTTON_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = ConsumeButton_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = ConsumeButton_Toggle_Enabled;
	elseif ( strfind( commandName, "large" ) ) then
		func = ConsumeButton_Toggle_Large;
	else
		ConsumeButton_Print(CONSUMEBUTTON_CHAT_COMMAND_USAGE);
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

-- Does things with the hooked function
function ConsumeButton_Hooked_Function()
	if ( ConsumeButton_Enabled == 1 ) then
	end
	ConsumeButton_Saved_Hooked_Function();
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function ConsumeButton_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( Hooked_Function ~= ConsumeButton_Hooked_Function ) and (ConsumeButton_Saved_Hooked_Function == nil) ) then
			ConsumeButton_Saved_Hooked_Function = Hooked_Function;
			Hooked_Function = ConsumeButton_Hooked_Function;
		end
	else
		if ( Hooked_Function == ConsumeButton_Hooked_Function) then
			Hooked_Function = ConsumeButton_Saved_Hooked_Function;
			ConsumeButton_Saved_Hooked_Function = nil;
		end
	end
end

-- Handles events
function ConsumeButton_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( ConsumeButton_Cosmos_Registered == 0 ) then
			local value = getglobal("ConsumeButton_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			ConsumeButton_Toggle_Enabled(value);
			value = getglobal("ConsumeButton_Large");
			if (value == nil ) then
				-- defaults to on
				value = 1;
			end
			ConsumeButton_Toggle_Large(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function ConsumeButton_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			ConsumeButton_Print(text);
		end
	end
	ConsumeButton_Register_Cosmos();
	if ( ConsumeButton_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		ConsumeButton_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		ConsumeButton_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

function ConsumeButton_Generic_CosmosUpdateCheckOnOff(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_CHECKONOFF, value);
	end
end

function ConsumeButton_Generic_CosmosUpdateValue(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_SLIDERVALUE, value);
	end
end



-- Toggles the enabled/disabled state of the ConsumeButton
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function ConsumeButton_Toggle_Enabled(toggle)
	ConsumeButton_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function ConsumeButton_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = ConsumeButton_Generic_Toggle(toggle, "ConsumeButton_Enabled", "COS_CONSUMEBUTTON_ENABLED_X", "CONSUMEBUTTON_CHAT_ENABLED", "CONSUMEBUTTON_CHAT_DISABLED");
	else
		newvalue = ConsumeButton_Generic_Toggle(toggle, "ConsumeButton_Enabled", "COS_CONSUMEBUTTON_ENABLED_X");
	end
	ConsumeButton_Setup_Hooks(newvalue);
	if ( newvalue == 1 ) then
		ConsumeButtonDisplayFrame:Show();
	else
		ConsumeButtonDisplayFrame:Hide();
	end
end

-- toggling - no text
function ConsumeButton_Toggle_Enabled_NoChat(toggle)
	ConsumeButton_DoToggle_Enabled(toggle, false);
end

-- Toggles the large/small state of the ConsumeButton
--  if toggle is 1, it's large
--  if toggle is 0, it's small
--   otherwise, it's toggled
function ConsumeButton_Toggle_Large(toggle)
	ConsumeButton_DoToggle_Large(toggle, true);
end

-- does the actual toggling
function ConsumeButton_DoToggle_Large(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = ConsumeButton_Generic_Toggle(toggle, "ConsumeButton_Large", "COS_CONSUMEBUTTON_LARGE_X", "CONSUMEBUTTON_CHAT_LARGE_ENABLED", "CONSUMEBUTTON_CHAT_LARGE_DISABLED");
	else
		newvalue = ConsumeButton_Generic_Toggle(toggle, "ConsumeButton_Large", "COS_CONSUMEBUTTON_LARGE_X");
	end
	local large = false;
	if ( newvalue == 1 ) then
		large = true;
	end
	ConsumeButtonDisplayFrame_SetTextDisplay(large)
end

-- toggling - no text
function ConsumeButton_Toggle_Large_NoChat(toggle)
	ConsumeButton_DoToggle_Large(toggle, false);
end

-- Prints out text to a chat box.
function ConsumeButton_Print(msg,r,g,b,frame,id,unknown4th)
	if ( Print ) then
		Print(msg, r, g, b, frame, id, unknown4th);
		return;
	end
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


function ConsumeButton_GetItemName(bag, slot)
	local name = "";
	local strings = nil;
	Sea.wow.tooltip.clear("ConsumeButtonDataTooltip");
	if ( Sea.wow.tooltip.protectTooltipMoney ) then
		DynamicData.util.protectTooltipMoney();
	end 
	if ( bag > -1 ) then
		ConsumeButtonDataTooltip:SetBagItem( bag, slot );
	else
		local hasItem, hasCooldown = ConsumeButtonDataTooltip:SetInventoryItem("player", slot);
	end
	if ( Sea.wow.tooltip.unprotectTooltipMoney ) then
		Sea.wow.tooltip.unprotectTooltipMoney();
	end 
	strings = Sea.wow.tooltip.scan("ConsumeButtonDataTooltip");
	if ( not hasItem) then
		if ( strings[1] ) then
			strings[1].left = "";
		end
	end
	if ( strings[1] ) then
		name = strings[1].left;
	end
	return name;
end



function ConsumeButtonDisplayFrame_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("BAG_UPDATE");
end

function ConsumeButtonDisplayFrame_OnShow()
	ConsumeButtonDisplayFrame_Update();
end

function ConsumeButtonDisplayFrame_OnEvent(event)
	if ( event == "BAG_UPDATE" ) then
		if ( ConsumeButtonDisplayFrame:IsVisible() ) then
			ConsumeButtonDisplayFrame_Update();
		end
	end
end

ConsumeButton_Consumables = {};
ConsumeButton_Consumables_Positions = {};

ConsumeButton_Consumables_ChosenDrink = nil;
ConsumeButton_Consumables_ChosenFood = nil;

ConsumeButton_LastScan = 0;

CONSUMEBUTTON_SCAN_BOUNDARY = 0.5;

ConsumeButton_FoodPreferenceList = {
		"Conjured Sweet Roll",
		"Conjured Sourdough",
		"Conjured Pumpernickel",
		"Conjured Rye",
		"Conjured Muffin",
		"Conjured Bread"
};

ConsumeButton_DrinkPreferenceList = {
		"Conjured Sparkling Water",
		"Conjured Mineral Water",
		"Conjured Spring Water",
		"Conjured Purified Water",
		"Conjured Water",
		"Conjured Fresh Water",
		"Glory Dew",
		"Spring Water",
		"Sweet Nectar",
		"Melon Juice",
		"Cold Milk",
		"Moonberry Juice",
		"Cherry Grog",
		"Refreshing Spring Water"
};

function ConsumeButton_GetTotalNumberOfType(classification)
	local totalNr = 0;
	for k, v in ConsumeButton_Consumables do
		if ( v == classification) then
			totalNr = totalNr + ConsumeButton_GetTotalNumberOfConsumable(k);
		end
	end
	return totalNr;
end

function ConsumeButton_GetTotalNumberOfFoods()
	return ConsumeButton_GetTotalNumberOfType("Food");
end

function ConsumeButton_GetTotalNumberOfDrinks()
	return ConsumeButton_GetTotalNumberOfType("Drink");
end

function ConsumeButton_GetTotalNumberOfConsumable(consumable)
	if ( not ConsumeButton_Consumables_Positions[consumable] ) then
		return 0;
	end
	local nr = 0;
	for k, v in ConsumeButton_Consumables_Positions[consumable] do
		if ( not v.count ) then
			nr = nr + 1;
		else
			nr = nr + v.count;
		end
	end
	return nr;
end

function ConsumeButtonDisplayFrame_ChooseConsumables()
	ConsumeButton_Consumables_ChosenFood = nil;
	for k, v in ConsumeButton_FoodPreferenceList do
		if ( ConsumeButton_Consumables[v] ) then
			ConsumeButton_Consumables_ChosenFood = v;
			break;
		end
	end
	if ( not ConsumeButton_Consumables_ChosenFood ) then
		local temp = 0;
		local minNumber = 131905831980135;
		local minNumberIndex = nil;
		for k, v in ConsumeButton_Consumables do
			if ( v == "Food" ) then
				temp = ConsumeButton_GetTotalNumberOfConsumable(k);
				if ( temp < minNumber ) then
					minNumberIndex = k;
				end
			end
		end
		ConsumeButton_Consumables_ChosenFood = minNumberIndex;
	end
	ConsumeButton_Consumables_ChosenDrink = nil;
	for k, v in ConsumeButton_DrinkPreferenceList do
		if ( ConsumeButton_Consumables[v] ) then
			ConsumeButton_Consumables_ChosenDrink = v;
			break;
		end
	end
	if ( not ConsumeButton_Consumables_ChosenDrink ) then
		local temp = 0;
		local minNumber = 131905831980135;
		local minNumberIndex = nil;
		for k, v in ConsumeButton_Consumables do
			if ( v == "Drink" ) then
				temp = ConsumeButton_GetTotalNumberOfConsumable(k);
				if ( temp < minNumber ) then
					minNumberIndex = k;
				end
			end
		end
		ConsumeButton_Consumables_ChosenDrink = minNumberIndex;
	end
end

function ConsumeButtonDisplayFrame_GetDescriptionString(name, classification, small)
	local formatStr = "%d / %d";
	if ( not name ) then
		return "N/A";
	end
	local totalNumber = ConsumeButton_GetTotalNumberOfConsumable(name);
	local totalNumberType = ConsumeButton_GetTotalNumberOfType(classification);
	if ( not small ) then
		return format(formatStr, totalNumber, totalNumberType);
	else
		return format("%d", totalNumber);
	end
end

function ConsumeButtonDisplayFrame_GetSize(large)
	local sizeData = {};
	if ( large ) then
		sizeData.height = 50;
		sizeData.width = 80;
	else
		sizeData.height = 40;
		sizeData.width = 65;
	end
	return sizeData;
end

function ConsumeButtonDisplayFrame_SetSize(sizeData)
	ConsumeButtonDisplayFrame:SetHeight(sizeData.height);
	ConsumeButtonDisplayFrame:SetWidth(sizeData.width);
end

function ConsumeButtonDisplayFrame_SetTextDisplay(large)
	if ( not ConsumeButtonDisplayFrame.oldTooltipScale ) then
		ConsumeButtonDisplayFrame.oldTooltipScale = ConsumeButtonTooltip:GetScale();
	end
	if ( large ) then
		ConsumeButtonDisplayFrameTextUpper:Show();
		ConsumeButtonDisplayFrameTextLower:Show();
		ConsumeButtonDisplayFrameText:Hide();
		ConsumeButtonTooltip:SetScale(ConsumeButtonDisplayFrame.oldTooltipScale);
		if ( ConsumeButtonTooltip:IsOwned(ConsumeButtonDisplayFrameText) ) then
			ConsumeButtonTooltip:SetOwner(ConsumeButtonDisplayFrameText, "ANCHOR_TOPRIGHT");
		end
	else
		ConsumeButtonDisplayFrameTextUpper:Hide();
		ConsumeButtonDisplayFrameTextLower:Hide();
		ConsumeButtonDisplayFrameText:Show();
		ConsumeButtonTooltip:SetScale(ConsumeButtonDisplayFrame.oldTooltipScale*0.7);
	end
	ConsumeButtonDisplayFrame_SetSize(ConsumeButtonDisplayFrame_GetSize(large));
end

function ConsumeButtonDisplayFrame_UpdateText()
	local drinkDescription = ConsumeButton_FormatDrinkText(ConsumeButtonDisplayFrame_GetDescriptionString(ConsumeButton_Consumables_ChosenDrink, "Drink"));
	local foodDescription = ConsumeButton_FormatFoodText(ConsumeButtonDisplayFrame_GetDescriptionString(ConsumeButton_Consumables_ChosenFood, "Food"));
	ConsumeButtonDisplayFrameTextUpper:SetText(drinkDescription);
	ConsumeButtonDisplayFrameTextLower:SetText(foodDescription);
	ConsumeButtonDisplayFrameText:SetText(ConsumeButton_FormatDrinkText(ConsumeButtonDisplayFrame_GetDescriptionString(ConsumeButton_Consumables_ChosenDrink, "Drink", true)).." "..ConsumeButton_FormatFoodText(ConsumeButtonDisplayFrame_GetDescriptionString(ConsumeButton_Consumables_ChosenFood, "Food", true)));
end

function ConsumeButtonDisplayFrame_ScanInventory(forced)
	local curTime = GetTime();
	if ( not forced ) and ( curTime - ConsumeButton_LastScan < CONSUMEBUTTON_SCAN_BOUNDARY ) then
		return false;
	end
	local itemInfo = nil;
	local startBag = 0;
	local startSlot = 1;
	ConsumeButton_Consumables = {};
	ConsumeButton_Consumables_Positions = {};
	for bag = startBag, 4 do
		for slot = startSlot, GetContainerNumSlots(bag) do
			itemInfo = Sea.wow.item.classifyInventoryItem( bag, slot );
			if ( itemInfo.name ) and ( strlen(itemInfo.name) > 0 ) then
				if (( itemInfo.classification == "Food" ) or ( itemInfo.classification == "Drink" ) ) then
					ConsumeButton_Consumables[itemInfo.name] = itemInfo.classification;
					if ( not ConsumeButton_Consumables_Positions[itemInfo.name] ) then
						ConsumeButton_Consumables_Positions[itemInfo.name] = {};
					end
					local element = {};
					element.classification = itemInfo.classification;
					element.bag = bag;
					element.slot = slot;
					element.count = itemInfo.count;
					table.insert(ConsumeButton_Consumables_Positions[itemInfo.name], element);
				end
			end
		end
	end
	ConsumeButton_LastScan = curTime;
	return true;
end

function ConsumeButtonDisplayFrame_Update()
	ConsumeButtonDisplayFrame_ScanInventory();
	ConsumeButtonDisplayFrame_ChooseConsumables();
	ConsumeButtonDisplayFrame_UpdateText();
end


function ConsumeButtonDisplayFrame_UseSmallestStack(name)
	local smallestEntry = nil;
	for k, v in ConsumeButton_Consumables_Positions[name] do
		if ( not smallestEntry ) or ( smallestEntry.count > v.count ) then
			smallestEntry = v;
		end
	end
	UseContainerItem(smallestEntry.bag, smallestEntry.slot);
end

function ConsumeButton_ConsumeFoodDrink()
	if ( ( MerchantFrame ) and ( MerchantFrame:IsVisible() ) ) then
		return false;
	end
	if ( not ConsumeButton_Consumables_ChosenDrink ) or ( not ConsumeButton_Consumables_ChosenFood ) then
		ConsumeButtonDisplayFrame_ScanInventory();
		ConsumeButtonDisplayFrame_ChooseConsumables();
	end
	if ( ( UnitPowerType("player") == 0 ) and ( ConsumeButton_Consumables_ChosenDrink ) and ( UnitMana("player") < UnitManaMax("player") ) ) then
		ConsumeButtonDisplayFrame_UseSmallestStack(ConsumeButton_Consumables_ChosenDrink);
	end
	if ( ( ConsumeButton_Consumables_ChosenFood ) and ( UnitHealth("player") < UnitHealthMax("player") ) ) then
		ConsumeButtonDisplayFrame_UseSmallestStack(ConsumeButton_Consumables_ChosenFood);
	end
end


function ConsumeButtonDisplayFrame_OnClick(button)
	if ( button == "LeftButton" ) then
		if ( IsShiftKeyDown() ) then
			ConsumeButton_Toggle_Large_NoChat(-1);
		end
	end
	if ( button == "RightButton" ) then
		ConsumeButton_ConsumeFoodDrink();
	end
end

function ConsumeButton_FormatDrinkText(drink)
	return format(ConsumeButton_GetColorFormatString(15, 15, 208), drink);
end

function ConsumeButton_FormatFoodText(food)
	return format(ConsumeButton_GetColorFormatString(30, 240, 30), food);
end

function ConsumeButtonDisplayFrame_GetDisplayTooltip()
	return getglobal("ConsumeButtonTooltip");
	--return getglobal("GameTooltip");
end


function ConsumeButtonDisplayFrame_OnEnter()
	local tooltip = ConsumeButtonDisplayFrame_GetDisplayTooltip();
	tooltip:SetOwner(this, "ANCHOR_TOPRIGHT");
	local drink = ConsumeButton_Consumables_ChosenDrink;
	if ( not drink ) then drink = TEXT(CONSUMEBUTTON_NODRINK); end
	drink = ConsumeButton_FormatDrinkText(drink);
	local food = ConsumeButton_Consumables_ChosenFood;
	if ( not food ) then food = TEXT(CONSUMEBUTTON_NOFOOD); end
	food = ConsumeButton_FormatFoodText(food);
	tooltip:SetText(format(CONSUMEBUTTON_TOOLTIP_FORMAT, drink, food));
	tooltip:Show();
end

function ConsumeButtonDisplayFrame_OnLeave()
	local tooltip = ConsumeButtonDisplayFrame_GetDisplayTooltip();
	if ( tooltip:IsOwned(this) ) then
		tooltip:Hide();
	end
end

-- Yet another function from George Warner, modified a bit to fit my own nefarious purposes. 
-- It can now accept r, g and b specifications, too (leaving out a), as well as handle 255 255 255
-- Source : http://www.cosmosui.org/cgi-bin/bugzilla/show_bug.cgi?id=159
function ConsumeButton_GetColorFormatString(a, r, g, b)
	local percent = false;
	if ( ( ( not b ) or ( b <= 1 ) ) and ( a <= 1 ) and ( r <= 1 ) and ( g <= 1) ) then percent = true; end
	if ( ( not b ) and ( a ) and ( r ) and ( g ) ) then b = g; g = r; r = a; if ( percent ) then a = 1; else a = 255; end end
	if ( percent ) then a = a * 255; r = r * 255; g = g * 255; b = b * 255; end
	a = Cosmos_GetByteValue(a); r = Cosmos_GetByteValue(r); g = Cosmos_GetByteValue(g); b = Cosmos_GetByteValue(b);
	
	return format("|c%02X%02X%02X%02X%%s|r", a, r, g, b);
end
