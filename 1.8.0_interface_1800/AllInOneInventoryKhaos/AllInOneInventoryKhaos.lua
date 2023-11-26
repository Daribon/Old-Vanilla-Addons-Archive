--[[
	All In One Inventory (Khaos)

	By sarf

	This mod allows you to configure AIOI from Khaos.

	Thanks goes to AlexYoshi for inspiring me to seperate my addons into ever smaller parts. :)

	KhaosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]

AllInOneInventoryKhaos_Registered = 0;

AllInOneInventoryKhaos_Saved_Register = AllInOneInventory_Register;

ALLINONEINVENTORY_KHAOS_SET_EASY_ID 			= "AIOIBasicSetID";
ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID 		= "AIOIAdvancedSetID";

AllInOneInventoryKhaos_Generic_SetName 			= ALLINONEINVENTORY_KHAOS_SET_EASY_ID;
AllInOneInventoryKhaos_Generic_ParameterName	= "checked";

ALLINONEINVENTORY_KHAOS_FOLDER_ID			= "AllInOneInventoryID";

AllInOneInventoryKhaos_Folder = {
	id = ALLINONEINVENTORY_KHAOS_FOLDER_ID;
	text = ALLINONEINVENTORY_CONFIG_HEADER;
	helptext = ALLINONEINVENTORY_CONFIG_HEADER_INFO;
	difficulty = 1;
	default = true;
};

--AllInOneInventoryKhaos_Folders = { AllInOneInventoryKhaos_Folder }; -- only needed with more than one folder

AllInOneInventoryKhaos_Generic_Map = {
	["AllInOneInventory_Enabled"] = { key = "enabled" },
	["AllInOneInventory_ReplaceBags"] = { key = "replacebags" },
	["AllInOneInventory_IncludeShotBags"] = { key = "includeshotbags" },
	["AllInOneInventory_IncludeBagZero"] = { key = "includebag0", set = ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID },
	["AllInOneInventory_IncludeBagOne"] = { key = "includebag1", set = ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID },
	["AllInOneInventory_IncludeBagTwo"] = { key = "includebag2", set = ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID },
	["AllInOneInventory_IncludeBagThree"] = { key = "includebag3", set = ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID },
	["AllInOneInventory_IncludeBagFour"] = { key = "includebag4", set = ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID },
	["AllInOneInventory_Columns"] = { key = "columns", parameter = "value" },
	["AllInOneInventory_SwapBagOrder"] = { key = "swapbagorder", set = ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID },
	["AllInOneInventory_Locked"] = { key = "locked" },
	["AllInOneInventory_Alpha"] = { key = "alpha", parameter = "value" },
	["AllInOneInventory_Scale"] = { key = "scale", parameter = "value" },
};

AllInOneInventoryKhaos_Generic_FuncMap = {
	["AllInOneInventoryKhaos_Saved_Generic_Toggle"] = "AllInOneInventoryCosmos_Generic_Toggle",
	["AllInOneInventoryKhaos_Saved_Generic_Value"] = "AllInOneInventoryCosmos_Generic_Value",
	["AllInOneInventoryKhaos_Saved_Generic_Number"] = "AllInOneInventoryCosmos_Generic_Number"
};

function AllInOneInventoryKhaos_Generic_SetOthers(oldFuncName, value, variableName, p1, p2, p3, p4, p5)
	if ( not arg ) then
		arg = {};
	end
	if ( not variableName ) then
		AllInOneInventory_Print("ERROR: AllInOneInventoryKhaos_Generic_SetOthers() given nil name!");
		return;
	end
	local oldFunc = getglobal(oldFuncName);
	if ( not oldFunc ) then
		AllInOneInventory_Print("ERROR: AllInOneInventoryKhaos_Generic_SetOthers() given nil oldFunc!");
		return value;
	end
	local retValue = oldFunc(value, variableName, p1, p2, p3, p4, p5);
	if ( variableName == "AllInOneInventory_Locked" ) then
		AllInOneInventory_SetLock();
	end
	--[[
	local cosmosOldFunc = getglobal(AllInOneInventoryKhaos_Generic_FuncMap[oldFuncName]);
	if ( cosmosOldFunc ) then
		cosmosOldFunc(retValue, variableName, p1, p2, p3, p4, p5);
	end
	]]--
	return retValue;
end


function AllInOneInventoryKhaos_Generic_Set(oldFuncName, value, variableName, p1, p2, p3, p4, p5)
	if ( not arg ) then
		arg = {};
	end
	local retValue = AllInOneInventoryKhaos_Generic_SetOthers(oldFuncName, value, variableName, p1, p2, p3, p4, p5);
	local mappedValue = AllInOneInventoryKhaos_Generic_Map[variableName];
	if ( not mappedValue ) then
		return retValue;
	end
	if ( AllInOneInventoryKhaos_Registered == 1 ) then 
		local setName = mappedValue.set; 
		if ( not setName ) then setName = AllInOneInventoryKhaos_Generic_SetName; end
		local keyName = mappedValue.key;
		if ( not keyName ) then return retValue; end
		local paramName = mappedValue.parameter; 
		if ( not paramName ) then paramName = AllInOneInventoryKhaos_Generic_ParameterName; end
		
		local v = Khaos.getSetKey(setName, keyName);
		if ( v ) then
			Khaos.setSetKeyParameter(setName, keyName, paramName, value);
			-- TODO: fix this once I know what the parameters should be
			Khaos.refresh();
			-- Khaos.refresh(nil, setName, keyName);
		end
	end
	return retValue;
end

function AllInOneInventoryKhaos_Generic_Toggle(value, variableName, p1, p2, p3, p4, p5)
	return AllInOneInventoryKhaos_Generic_Set("AllInOneInventoryKhaos_Saved_Generic_Toggle", value, variableName, p1, p2, p3, p4, p5);
end

function AllInOneInventoryKhaos_Generic_Value(value, variableName, p1, p2, p3, p4, p5)
	return AllInOneInventoryKhaos_Generic_Set("AllInOneInventoryKhaos_Saved_Generic_Value", value, variableName, p1, p2, p3, p4, p5);
end

function AllInOneInventoryKhaos_Generic_Number(value, variableName, p1, p2, p3, p4, p5)
	return AllInOneInventoryKhaos_Generic_Set("AllInOneInventoryKhaos_Saved_Generic_Number", value, variableName, p1, p2, p3, p4, p5);
end

function AllInOneInventoryKhaos_Generic_ToggleOthers(value, variableName, p1, p2, p3, p4, p5)
	return AllInOneInventoryKhaos_Generic_SetOthers("AllInOneInventoryKhaos_Saved_Generic_Toggle", value, variableName, p1, p2, p3, p4, p5);
end

function AllInOneInventoryKhaos_Generic_ValueOthers(value, variableName, p1, p2, p3, p4, p5)
	if ( not arg ) then
		arg = {};
	end
	return AllInOneInventoryKhaos_Generic_SetOthers("AllInOneInventoryKhaos_Saved_Generic_Value", value, variableName, p1, p2, p3, p4, p5);
end

function AllInOneInventoryKhaos_Generic_NumberOthers(value, variableName, p1, p2, p3, p4, p5)
	if ( not arg ) then
		arg = {};
	end
	return AllInOneInventoryKhaos_Generic_SetOthers("AllInOneInventoryKhaos_Saved_Generic_Number", value, variableName, p1, p2, p3, p4, p5);
end

function AllInOneInventoryKhaosFrame_OnLoad()
	AllInOneInventoryKhaos_Saved_Generic_Toggle = AllInOneInventory_Generic_Toggle;
	AllInOneInventory_Generic_Toggle = AllInOneInventoryKhaos_Generic_Toggle;

	AllInOneInventoryKhaos_Saved_Generic_Value = AllInOneInventory_Generic_Value;
	AllInOneInventory_Generic_Value = AllInOneInventoryKhaos_Generic_Value;

	AllInOneInventoryKhaos_Saved_Generic_Number = AllInOneInventory_Generic_Number;
	AllInOneInventory_Generic_Number = AllInOneInventoryKhaos_Generic_Number;
	
	AllInOneInventoryKhaos_Register();
end

function AllInOneInventoryKhaosFrame_OnEvent(event)
	
end

function AllInOneInventoryKhaos_Register()
	if ( Khaos ) then
		AllInOneInventoryKhaos_Register_Khaos();
		-- TODO: use Khaos slash commands? naaaaaaaaaaah
		AllInOneInventory_Register_SlashCommands();
	end
end

function AIOIKhaos_Get_Khaos_CheckBox(pid, pkey, ptext, phelptext, pcheck, cb, diff)
	local option1 = {
		id = pid;
		key = pkey;
		text = ptext;
		helptext = phelptext;
		check = true;
		callback = cb;
		difficulty = diff;
		type = K_TEXT;
		feedback = function(state) local s = ALLINONEINVENTORYKHAOS_STATE_ENABLED; if ( not state.checked ) then s = ALLINONEINVENTORYKHAOS_STATE_DISABLED; end return ALLINONEINVENTORYKHAOS_STATE_TEXT.." "..s; end;
		default = {
			checked = pcheck;
		};
		disabled = {
			checked = false;
		};
	};
	return option1;
end

function AIOIKhaos_UpdateValue(name, value)
	if ( not name ) then
		return false;
	end
	if ( value == true ) then
		if ( type(getglobal(name)) == "function" )then
			local a = getglobal(name);
			a(1);
		else
			setglobal(name,1);
		end
	elseif ( value == nil ) or ( value == false ) then
		if ( type(getglobal(name)) == "function" )then
			local a=getglobal(name);
			a(0);
		else
			setglobal(name,0);
		end
	else
		AllInOneInventoryKhaos_Generic_NumberOthers(value, name);
	end
end



-- registers the mod with Khaos
function AllInOneInventoryKhaos_Register_Khaos()
	if ( Khaos ) and ( AllInOneInventoryKhaos_Registered == 0 ) then
		--Khaos.registerFolder(AllInOneInventoryKhaos_Folder);
		local optionSetEasy = {
			id = "AllInOneInventory";
			text = ALLINONEINVENTORY_CONFIG_HEADER;
			helptext = ALLINONEINVENTORY_KHAOS_EASYSET_HELP;
			difficulty = 1;
			options = {};
			default = true;
		};
		--[[
		local cb1 = function(state) AIOIKhaos_UpdateValue("AllInOneInventory_Enabled", state.checked); end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxEnabled", "enabled", ALLINONEINVENTORY_ENABLED, ALLINONEINVENTORY_ENABLED_INFO, true, cb1));
		]]--
		local cb2 = function(state) 
			if ( state.checked ) then
				AllInOneInventory_ReplaceBags=1;
			else
				AllInOneInventory_ReplaceBags=0;
			end 
		end;
		local cb3 = function(state) 
			if ( state.checked ) then
				AllInOneInventory_IncludeShotBags=1;
			else
				AllInOneInventory_IncludeShotBags=0;
			end 
		end;
		local cb4 = function(state) 
			if ( state.checked ) then
				AllInOneInventory_SwapBagOrder=1;
			else
				AllInOneInventory_SwapBagOrder=0;
			end 
		end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxReplaceBags", "replacebags", ALLINONEINVENTORY_REPLACEBAGS, ALLINONEINVENTORY_REPLACEBAGS_INFO, true, cb2));
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxSwapBagOrder", "swapbagorder", ALLINONEINVENTORY_SWAP_BAG_ORDER, ALLINONEINVENTORY_SWAP_BAG_ORDER_INFO, false, cb4,2));
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxIncludeShotBags", "includeshotbags", ALLINONEINVENTORY_INCLUDE_SHOTBAGS, ALLINONEINVENTORY_INCLUDE_SHOTBAGS_INFO, true, cb3));

		table.insert(optionSetEasy.options, 
			{
			id = ALLINONEINVENTORY_KHAOS_SET_ADVANCED_ID;
			text = ALLINONEINVENTORY_KHAOS_ADVANCEDSET_TEXT;
			helptext = ALLINONEINVENTORY_KHAOS_ADVANCEDSET_HELP;
			difficulty = 3;
			type=K_HEADER;
			}
		);

		local cb4 = function(state) AIOIKhaos_UpdateValue("AllInOneInventory_IncludeBagZero", state.checked); end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxIncludeBagZero", "includebag0", ALLINONEINVENTORY_INCLUDE_BAGZERO, ALLINONEINVENTORY_INCLUDE_BAGZERO_INFO, true, cb4,3));
		local cb5 = function(state) AIOIKhaos_UpdateValue("AllInOneInventory_IncludeBagOne", state.checked); end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxIncludeBagOne", "includebag1", ALLINONEINVENTORY_INCLUDE_BAGONE, ALLINONEINVENTORY_INCLUDE_BAGONE_INFO, true, cb5,3));
		local cb6 = function(state) AIOIKhaos_UpdateValue("AllInOneInventory_IncludeBagTwo", state.checked); end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxIncludeBagTwo", "includebag2", ALLINONEINVENTORY_INCLUDE_BAGTWO, ALLINONEINVENTORY_INCLUDE_BAGTWO_INFO, true, cb6,3));
		local cb7 = function(state) AIOIKhaos_UpdateValue("AllInOneInventory_IncludeBagThree", state.checked); end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxIncludeBagThree", "includebag3", ALLINONEINVENTORY_INCLUDE_BAGTHREE, ALLINONEINVENTORY_INCLUDE_BAGTHREE_INFO, true, cb7,3));
		local cb8 = function(state) AIOIKhaos_UpdateValue("AllInOneInventory_IncludeBagFour", state.checked); end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxIncludeBagFour", "includebag4", ALLINONEINVENTORY_INCLUDE_BAGFOUR, ALLINONEINVENTORY_INCLUDE_BAGFOUR_INFO, true, cb8,3));

		local cb9 = function(state) AIOIKhaos_UpdateValue("AllInOneInventory_Locked", state.checked); end;
		table.insert(optionSetEasy.options, AIOIKhaos_Get_Khaos_CheckBox("CheckBoxLocked", "locked", ALLINONEINVENTORY_LOCKED, ALLINONEINVENTORY_LOCKED_INFO, false, cb9));

		local optionAlpha = {
			id = "SliderAlpha";
			key = "alpha";
			text = ALLINONEINVENTORY_ALPHA;
			helptext = ALLINONEINVENTORY_ALPHA_INFO;
			callback = function(state) 
				AIOIKhaos_UpdateValue("AllInOneInventory_Alpha", state.slider); 
				AllInOneInventoryFrame_SetAlpha(state.slider);
			end;
			type = K_SLIDER;
			feedback = function(state) if ( state.slider == 0 ) then return ALLINONEINVENTORY_KHAOS_ALPHA_NONE; end return string.format(ALLINONEINVENTORY_KHAOS_ALPHA_FORMAT, state.slider); end;
			setup = {
				sliderMin = ALLINONEINVENTORY_ALPHA_MIN;
				sliderMax = ALLINONEINVENTORY_ALPHA_MAX;
				sliderStep = 0.01;
				sliderDisplayFunc = function ( val ) return math.floor(val*100)/100; end;
			};
			default = {
				slider = 1;
			};
			disabled = {
				slider = 0;
			};
		};
		table.insert(optionSetEasy.options, optionAlpha);
		local optionScale = {
			id = "SliderScale";
			key = "scale";
			text = ALLINONEINVENTORY_SCALE;
			helptext = ALLINONEINVENTORY_SCALE_INFO;
			callback = function(state)
				AIOIKhaos_UpdateValue("AllInOneInventory_Scale", state.slider);
				AllInOneInventory_DoChange_Scale(state.slider, false);
			end;
			type = K_SLIDER;
			difficulty = 2;
			feedback = function(state) 
				if ( state.slider == 0 ) then 
					return ALLINONEINVENTORY_KHAOS_SCALE_NONE; 
				end 
				return string.format(ALLINONEINVENTORY_KHAOS_SCALE_FORMAT, state.slider); 
			end;
			setup = {
				sliderMin = ALLINONEINVENTORY_SCALE_MIN;
				sliderMax = ALLINONEINVENTORY_SCALE_MAX;
				sliderStep = 0.01;
				sliderDisplayFunc = function ( val ) return math.floor(val*100)/100; end;
			};
			default = {
				slider = 1;
			};
			disabled = {
				slider = 0;
			};
		};
		table.insert(optionSetEasy.options, optionScale);
		local optionColumns = {
			id = "SliderColumns";
			key = "columns";
			text = ALLINONEINVENTORY_COLUMNS;
			helptext = ALLINONEINVENTORY_COLUMNS_INFO;
			callback = function(state) 
				AIOIKhaos_UpdateValue("AllInOneInventory_Columns", state.slider); 
				AllInOneInventory_Change_Columns(1, value);
			end;
			type = K_SLIDER;
			difficulty=3;
			feedback = function(state) return 
				string.format(ALLINONEINVENTORY_CHAT_COLUMNS_FORMAT, state.slider); 
			end;
			setup = {
				sliderMin = ALLINONEINVENTORY_COLUMNS_MIN;
				sliderMax = ALLINONEINVENTORY_COLUMNS_MAX;
				sliderStep = 1;
				sliderDisplayFunc = function ( val ) return math.floor(val*100)/100; end;
			};
			default = {
				slider = 8;
			};
			disabled = {
				slider = 8;
			};
		};
		table.insert(optionSetEasy.options, optionColumns);
		Khaos.registerOptionSet( "inventory", optionSetEasy );
		AllInOneInventoryKhaos_Registered = 1;
	end
end

