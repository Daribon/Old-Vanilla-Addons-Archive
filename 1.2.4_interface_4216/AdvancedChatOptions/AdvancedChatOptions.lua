AdvancedChatOptions_Config = { };
AdvancedChatOptions_Config.SecondPos=0;
AdvancedChatOptions_Config.PetPos=0;
AdvancedChatOptions_Config.StancePos=0;
AdvancedChatOptions_Config.NoEntry=0;
AdvancedChatOptions_Config.Speed=0;
AdvancedChatOptions_Initialized=0;

-- Function for repositioning the chat dock depending on if there's a shapeshift bar/stance bar, etc...
function AdvancedChatOptions_FCF_UpdateDockPosition(case)
	local ASecond = AdvancedChatOptions_Config.SecondPos;
	local APet = AdvancedChatOptions_Config.PetPos;
	local AStance = AdvancedChatOptions_Config.StancePos;
	local ANoEntry = AdvancedChatOptions_Config.NoEntry;
	local ASpeed = AdvancedChatOptions_Config.Speed;
	if (ASecond==0 and APet==0 and AStance==0 and ANoEntry==0 and ASpeed==0) then
		return;
	end
	
	if ( DEFAULT_CHAT_FRAME:IsUserPlaced() ) then
		if ( SIMPLE_CHAT ~= "1" ) then
			return;
		end
	end
	
	local offY = 85;

	if (ANoEntry == 1) then
		offY = offY - 25;
	end
	if ((Cosmos_GetCVar("COS_SECONDBAR_ONOFF") and (Cosmos_GetCVar("COS_SECONDBAR_ONOFF") == 1)) and (ASecond == 1)) then
		offY = offY + 42;
	end
	if ((PetHasActionBar() and (APet == 1)) or ((GetNumShapeshiftForms() > 0) and (AStance == 1))) then
		offY = offY + 34;
	end
	offY = offY + ASpeed;

	
	DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, offY);
end

function AdvancedChatOptions_SliderUpdate(toggle, speed)
	AdvancedChatOptions_Config.Speed = speed;
	AdvancedChatOptions_FCF_UpdateDockPosition();
end

function AdvancedChatOptions_SetOption(whichOption, onOff)
	if (whichOption) then
		local setTo = 0;
		if (onOff and (onOff==1)) then
			setTo = 1;
		elseif (onOff and (onOff == 0)) then
			setTo = 0;
		else
			if (AdvancedChatOptions_Config[whichOption] == 0) then
				setTo = 1;
			else
				setTo = 0;
			end
		end
		
		if (AdvancedChatOptions_Config[whichOption] ~= setTo) then
			AdvancedChatOptions_Config[whichOption] = setTo;
			FCF_UpdateDockPosition();
		end
	end
end

function AdvancedChatOptions_OnLoad()
	if ( AdvancedChatOptions_Initialized == 0) then
		Sea.util.hook("FCF_UpdateDockPosition","AdvancedChatOptions_FCF_UpdateDockPosition","after");
		if (not (Cosmos_RegisterConfiguration == nil)) then
			Cosmos_RegisterConfiguration(
				"COS_ACHATOPTION",
				"SECTION",
				ACHATOPTION_CONFIG_HEADER,
				ACHATOPTION_CONFIG_HEADER_INFO
				);
			Cosmos_RegisterConfiguration(
				"COS_ACHATOPTION_SLIDER", -- CVAr
				"SLIDER",
				ACHATOPTION_CONFIG_SLIDER,
				"",
				AdvancedChatOptions_SliderUpdate,
				0,
				0,				--Default Value
				-100,			--Min value
				100,			--Max value
				ACHATOPTION_CONFIG_SLIDER_OFFSET,		--Slider Text
				1,				--Slider Increment
				1,				--Slider state text on/off
				"",				--Slider state text append
				1				--Slider state text multiplier
				);
			Cosmos_RegisterConfiguration(
				"COS_ACHATOPTION_SECOND", -- CVAr
				"CHECKBOX",
				ACHATOPTION_CONFIG_SECOND,
				ACHATOPTION_CONFIG_SECOND_INFO,
				AdvancedChatOptions_SetSecond,
				AdvancedChatOptions_Config.SecondPos
				);
			Cosmos_RegisterConfiguration(
				"COS_ACHATOPTION_PET", -- CVAr
				"CHECKBOX",
				ACHATOPTION_CONFIG_PET,
				ACHATOPTION_CONFIG_PET_INFO,
				AdvancedChatOptions_SetPet,
				AdvancedChatOptions_Config.PetPos
				);
			Cosmos_RegisterConfiguration(
				"COS_ACHATOPTION_STANCE", -- CVAr
				"CHECKBOX",
				ACHATOPTION_CONFIG_STANCE,
				ACHATOPTION_CONFIG_STANCE_INFO,
				AdvancedChatOptions_SetStance,
				AdvancedChatOptions_Config.StancePos
				);
			Cosmos_RegisterConfiguration(
				"COS_ACHATOPTION_NOENTRY", -- CVAr
				"CHECKBOX",
				ACHATOPTION_CONFIG_NOENTRY,
				ACHATOPTION_CONFIG_NOENTRY_INFO,
				AdvancedChatOptions_SetNoEntry,
				AdvancedChatOptions_Config.NoEntry
				);
		end
		AdvancedChatOptions_Initialized = 1;
	end
end		

function AdvancedChatOptions_SetSecond(checked)
	AdvancedChatOptions_SetOption("SecondPos", checked);
end
function AdvancedChatOptions_SetPet(checked)
	AdvancedChatOptions_SetOption("PetPos", checked);
end
function AdvancedChatOptions_SetStance(checked)
	AdvancedChatOptions_SetOption("StancePos", checked);
end
function AdvancedChatOptions_SetNoEntry(checked)
	AdvancedChatOptions_SetOption("NoEntry", checked);
end
