--[[
-- $Id: cosmos.lua 2056 2005-07-07 05:36:23Z AlexYoshi $
-- Cosmos-integration for MobHealth2
-- By Sparkz	
--]]


-- Variables
MobHealth_Cosmos_Registered = 0;
MobHealth_Enabled	= 1;

-- registers the mod with Cosmos
function MobHealth_Register_Cosmos()
	if ( Khaos ) then
	local optionSet = {};
	local commandSet = {};
	local configurationSet = {
		id="MobHealth";
		text=MOBHEALTH_CONFIG_HEADER;
		helptext=MOBHEALTH_CONFIG_HEADER_INFO;
		difficulty=2;
		options=optionSet;
		commands=commandSet;
		default=false;
	}; 
 		table.insert(
		optionSet,
		{
			id="Header";
			text=MOBHEALTH_CONFIG_HEADER;
			helptext=MOBHEALTH_CONFIG_HEADER_INFO;
			difficulty=1;
			callback=function(state)
				if ( state.checked ) then
					MobHealth_Enabled = 1;MobHealth_Cosmos_Registered = 1;
				else
					MobHealth_Enabled = 0;
					local field = getglobal("MobHealthText");
					field:SetText("");
				end
			end;
			feedback=function(state)
				if ( state.checked ) then
					return "MobHealth Enabled";
				else
					return "MobHealth Disabled";
				end
			end;
			type=K_HEADER;
		});
 		table.insert(
		optionSet,
		{
			id="Enable";
			text=MOBHEALTH_ENABLED;
			helptext=MOBHEALTH_ENABLED_INFO;
			difficulty=1;
			type=K_TEXT;
			callback=function(state)
				if ( state.checked ) then
					MobHealth_Enabled = 1;
				else
					MobHealth_Enabled = 0;
					local field = getglobal("MobHealthText");
					field:SetText("");
				end
			end;
			feedback=function(state)
				if ( state.checked ) then
					return "MobHealth Enabled";
				else
					return "MobHealth Disabled";
				end
			end;
			check=true;
			default={
				checked=true;
			};
			disabled={
				checked=false;
			};				
		});
 		table.insert(
		optionSet,
		{
			id="MobileHealthPosition";
			text=MOBHEALTH_POSITION_SLIDER_DESC;
			helptext=MOBHEALTH_POSITION_SLIDER_INFO;
			difficulty=1;
			callback=function(state) MobHealth_SetPos(state.slider,false); end;
			feedback=function(state) return "Moved to "..tostring(state.slider); end;
			type=K_SLIDER;
			setup= {
				sliderMin=0;
				sliderMax=55;
				sliderStep=1;
				sliderText=MOBHEALTH_POSITION_SLIDER;
			};
			default={
				slider=22;
			};
			disabled={
				slider=22;
			};				
		});
 		table.insert(
		optionSet,
		{
			id="StableMax";
			text=MOBHEALTH_STABLEMAX;
			helptext=MOBHEALTH_STABLEMAX_INFO;
			difficulty=2;
			callback=function(state)
				if(state.checked) then
					MobHealth_StableMax_Set(1);
				else
					MobHealth_StableMax_Set(0);
				end
			end;
			feedback=function(state)
				if ( state.checked ) then
					return "Stable Max Enabled";
				else
					return "Stable Max Disabled";
				end
			end;
			check=true;
			type=K_TEXT;
			default={
				checked=false;
			};
			disabled={
				checked=false;
			};				
		});
 		table.insert(
		optionSet,
		{
			id="ResetAll";
			text=MOBHEALTH_RESET_ALL;
			helptext=MOBHEALTH_RESET_ALL_INFO;
			difficulty=1;
			callback=MobHealth_Reset;
			type=K_BUTTON;
			setup={
				buttonText=TEXT(MOBHEALTH_RESET_TARGET_BUTTON);
			};
		}
		);
 		table.insert(
		optionSet,
		{
			id="ResetTarget";
			text=MOBHEALTH_RESET_TARGET;
			helptext=MOBHEALTH_RESET_TARGET_INFO;
			difficulty=2;
			callback=MobHealth_ClearTargetData;
			type=K_BUTTON;
			setup={
				buttonText=TEXT(MOBHEALTH_RESET_TARGET_BUTTON);
			};
		}
		);
		Khaos.registerOptionSet(
			"combat",
			configurationSet
		);
		MobHealth_Cosmos_Registered = 1;	
	elseif ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( MobHealth_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_MOBHEALTH",
			"SECTION",
			TEXT(MOBHEALTH_CONFIG_HEADER),
			TEXT(MOBHEALTH_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_MOBHEALTH_HEADER",
			"SEPARATOR",
			TEXT(MOBHEALTH_CONFIG_HEADER),
			TEXT(MOBHEALTH_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_MOBHEALTH_ENABLED",
			"CHECKBOX",
			TEXT(MOBHEALTH_ENABLED),
			TEXT(MOBHEALTH_ENABLED_INFO),
			function (checked)
				MobHealth_Enabled = checked;
				local field = getglobal("MobHealthText");
				field:SetText("");
			end,
			MobHealth_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_MOBHEALTH_POSITION",
			"SLIDER",
			TEXT(MOBHEALTH_POSITION_SLIDER_DESC),
			TEXT(MOBHEALTH_POSITION_SLIDER_INFO),
			function (checked, value) MobHealth_SetPos(value, false); end,
			1,
			22,
			0,
			55,
			MOBHEALTH_POSITION_SLIDER,
			1,
			1,
			"",
			1
		);
		Cosmos_RegisterConfiguration(
			"COS_MOBHEALTH_STABLEMAX",
			"CHECKBOX",
			TEXT(MOBHEALTH_STABLEMAX),
			TEXT(MOBHEALTH_STABLEMAX_INFO),
			function (checked) MobHealth_StableMax_Set(checked); end,
			0
		);
		Cosmos_RegisterConfiguration(
			"COS_MOBHEALTH_RESET_ALL",
			"BUTTON",
			TEXT(MOBHEALTH_RESET_ALL),
			TEXT(MOBHEALTH_RESET_ALL_INFO),
			MobHealth_Reset,
			0,
			0,
			0,
			0,
			TEXT(MOBHEALTH_RESET_ALL_BUTTON)
		);
		Cosmos_RegisterConfiguration(
			"COS_MOBHEALTH_RESET_TARGET",
			"BUTTON",
			TEXT(MOBHEALTH_RESET_TARGET),
			TEXT(MOBHEALTH_RESET_TARGET_INFO),
			MobHealth_ClearTargetData,
			0,
			0,
			0,
			0,
			TEXT(MOBHEALTH_RESET_TARGET_BUTTON)
		);
		MobHealth_Cosmos_Registered = 1;
	end
end

function MobHealth_StableMax_Set(checked)
	--DEFAULT_CHAT_FRAME:AddMessage(COLOR_WHITE..checked);
	if (checked == 1) then
		MobHealthConfig["unstablemax"] = true;
	else
		MobHealthConfig["unstablemax"] = nil;
	end
end
