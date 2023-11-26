--[[
	XP Bar Color

	By sarf

	This mod allows the user to control the color of the XP Bar (as well as its opacity).

	Credits goes to zendar on the CosmosUI forums for the idea!
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=293
	
   ]]


-- Constants
XPBARCOLOR_DEFAULTCOLORVALUE = { ["RED"] = 0.0, ["GREEN"] = 0.39, ["BLUE"] = 0.88, ["ALPHA"] = 1.0};


-- Variables
XPBarColor_Enabled = 0;
XPBarColor_Saved_ExhaustionTick_Update = nil;

XPBarColor_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function XPBarColor_OnLoad()
	XPBarColor_Register();
end

-- registers the mod with Cosmos
function XPBarColor_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( XPBarColor_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_XPBARCOLOR",
			"SECTION",
			XPBARCOLOR_CONFIG_HEADER,
			XPBARCOLOR_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_XPBARCOLOR_HEADER",
			"SEPARATOR",
			XPBARCOLOR_CONFIG_HEADER,
			XPBARCOLOR_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_XPBARCOLOR_ENABLED",
			"CHECKBOX",
			XPBARCOLOR_ENABLED,
			XPBARCOLOR_ENABLED_INFO,
			XPBarColor_Toggle_Enabled,
			0
		);
		Cosmos_RegisterConfiguration(
			"COS_XPBARCOLOR_RED",
			"SLIDER",
			XPBARCOLOR_COLOR_RED,
			XPBARCOLOR_COLOR_RED_INFO,
			XPBarColor_Color_Changed,
			0,
			0.0,
			0,
			1,
			format(XPBARCOLOR_SLIDER_PREFIX, XPBARCOLOR_VALUE_RED),
			0.01,
			1,
			"",
			1
		);
		Cosmos_RegisterConfiguration(
			"COS_XPBARCOLOR_GREEN",
			"SLIDER",
			XPBARCOLOR_COLOR_GREEN,
			XPBARCOLOR_COLOR_GREEN_INFO,
			XPBarColor_Color_Changed,
			0,
			0.39,
			0,
			1,
			format(XPBARCOLOR_SLIDER_PREFIX, XPBARCOLOR_VALUE_GREEN),
			0.01,
			1,
			"",
			1
		);
		Cosmos_RegisterConfiguration(
			"COS_XPBARCOLOR_BLUE",
			"SLIDER",
			XPBARCOLOR_COLOR_BLUE,
			XPBARCOLOR_COLOR_BLUE_INFO,
			XPBarColor_Color_Changed,
			0,
			0.88,
			0,
			1,
			format(XPBARCOLOR_SLIDER_PREFIX, XPBARCOLOR_VALUE_BLUE),
			0.01,
			1,
			"",
			1
		);
		Cosmos_RegisterConfiguration(
			"COS_XPBARCOLOR_ALPHA",
			"SLIDER",
			XPBARCOLOR_ALPHA,
			XPBARCOLOR_ALPHA_INFO,
			XPBarColor_Color_Changed,
			0,
			1,
			0,
			1,
			format(XPBARCOLOR_SLIDER_PREFIX, XPBARCOLOR_VALUE_ALPHA),
			0.01,
			1,
			"",
			1
		);
		if ( Cosmos_RegisterChatCommand ) then
			local XPBarColorEnableCommands = {"/xpbarcolortoggle","/xbctoggle","/xpbarcolorenable","/xbcenable","/xpbarcolordisable","/xbcdisable"};
			Cosmos_RegisterChatCommand (
				"XPBARCOLOR_ENABLE_COMMANDS", -- Some Unique Group ID
				XPBarColorEnableCommands, -- The Commands
				XPBarColor_Enable_ChatCommandHandler,
				XPBARCOLOR_CHAT_COMMAND_ENABLE_INFO -- Description String
			);
			local slashcmdlist = nil;
			local colors = { "Red", "Green", "Blue", "Alpha" };
			for k, v in colors do
				slashcmdlist = 
					{ "/xpbarcolor"..string.lower(v), 
					"/xbc"..string.lower(v), 
					"/xpbarcolor"..string.sub(string.lower(v), 1, 1), 
					"/xbc"..string.sub(string.lower(v), 1, 1) };
				Cosmos_RegisterChatCommand (
					format("XPBARCOLOR_%s_COMMANDS", string.upper(v)), -- Some Unique Group ID
					slashcmdlist, -- The Commands
					getglobal(format("XPBarColor_%s_ChatCommandHandler", v)),
					format(XPBARCOLOR_CHAT_COMMAND_VALUE_INFO, getglobal("XPBARCOLOR_VALUE_"..string.upper(v))) -- Description String
				);
			end
		end

		XPBarColor_Cosmos_Registered = 1;

	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function XPBarColor_Register()
	local colors = { "Red", "Green", "Blue", "Alpha" };
	local cmdname = nil;
	local currentslashcmd = 0;
	
	if ( Cosmos_RegisterConfiguration ) then
		XPBarColor_Register_Cosmos();
	else
		SlashCmdList["XPBARCOLORSLASHENABLE"] = XPBarColor_Enable_ChatCommandHandler;
		SLASH_XPBARCOLORSLASHENABLE1 = "/xpbarcolortoggle";
		SLASH_XPBARCOLORSLASHENABLE2 = "/xbctoggle";
		SLASH_XPBARCOLORSLASHENABLE3 = "/xpbarcolorenable";
		SLASH_XPBARCOLORSLASHENABLE4 = "/xbcenable";
		SLASH_XPBARCOLORSLASHENABLE5 = "/xpbarcolordisable";
		SLASH_XPBARCOLORSLASHENABLE6 = "/xbcdisable";
		
		for k, v in colors do
			cmdname = "XPBARCOLORSLASH"..string.upper(v);
			SlashCmdList[cmdname] = getglobal(format("XPBarColor_%s_ChatCommandHandler", v));
			setglobal(cmdname.."1", "/xpbarcolor"..string.lower(v));
			setglobal(cmdname.."2", "/xbc"..string.lower(v));
			setglobal(cmdname.."3", "/xpbarcolor"..string.sub(string.lower(v), 1, 1));
			setglobal(cmdname.."4", "/xbc"..string.sub(string.lower(v), 1, 1));
		end
		
		this:RegisterEvent("VARIABLES_LOADED");
	end

end

-- Handles chat - e.g. slashcommands - enabling/disabling the XPBarColor
function XPBarColor_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		XPBarColor_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			XPBarColor_Toggle_Enabled(0);
		else
			XPBarColor_Toggle_Enabled(-1);
		end
	end
end

-- Handles chat - e.g. slashcommands - changing the color/attribute of the XP Bar
function XPBarColor_Value_ChatCommandHandler(msg, value)
	msg = string.lower(msg);
	
	XPBar_Change_Color(value, msg);
end

function XPBarColor_Red_ChatCommandHandler(msg)
	XPBarColor_Value_ChatCommandHandler(getglobal(XPBARCOLOR_VALUE_RED), msg);
end

function XPBarColor_Green_ChatCommandHandler(msg)
	XPBarColor_Value_ChatCommandHandler(getglobal(XPBARCOLOR_VALUE_GREEN), msg);
end

function XPBarColor_Blue_ChatCommandHandler(msg)
	XPBarColor_Value_ChatCommandHandler(getglobal(XPBARCOLOR_VALUE_BLUE), msg);
end

function XPBarColor_Alpha_ChatCommandHandler(msg)
	XPBarColor_Value_ChatCommandHandler(getglobal(XPBARCOLOR_VALUE_ALPHA), msg);
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function XPBarColor_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( ExhaustionTick_Update ~= XPBarColor_ExhaustionTick_Update ) and (XPBarColor_Saved_ExhaustionTick_Update == nil) ) then
			XPBarColor_Saved_ExhaustionTick_Update = ExhaustionTick_Update;
			ExhaustionTick_Update = XPBarColor_ExhaustionTick_Update;
		end
	else
		if ( ExhaustionTick_Update == XPBarColor_ExhaustionTick_Update) then
			ExhaustionTick_Update = XPBarColor_Saved_ExhaustionTick_Update;
			XPBarColor_Saved_ExhaustionTick_Update = nil;
		end
	end
end


-- helper function for hook function
function XPBarColor_GetColorValue(color)
	local variableName = "COS_XPBARCOLOR_"..string.upper(color);
	local value = getglobal(variableName);
	if ( Cosmos_GetCVar ) then
		local val = Cosmos_GetCVar(variableName);
		if ( CosmosMaster_Configurations ) then
			local va = nil;
			for k, v in CosmosMaster_Configurations do
				if ( v[CSM_VARIABLE] == variableName ) then
					va = v[CSM_SLIDERVALUE];
				end
			end
			if ( va ) then
				val = va;
			end
		end
		if ( val ) then
			value = val;
		end
	end
	if ( value == nil ) then
		value = XPBARCOLOR_DEFAULTCOLORVALUE[color];
	end
	return value;
end

-- hooked function
function XPBarColor_ExhaustionTick_Update()
	XPBarColor_Saved_ExhaustionTick_Update();
	XPBarColor_Update_Color();
end

function XPBarColor_Update_Color()
	if ( XPBarColor_Enabled == 1 ) then
		local mainmenuxpbar = getglobal("MainMenuExpBar");
		if ( mainmenuxpbar ) then
			local red, green, blue, alpha;
			red = XPBarColor_GetColorValue("RED");
			green = XPBarColor_GetColorValue("GREEN");
			blue = XPBarColor_GetColorValue("BLUE");
			alpha = XPBarColor_GetColorValue("ALPHA");
			mainmenuxpbar:SetStatusBarColor(red, green, blue, alpha);
			--mainmenuxpbar:SetAlpha(alpha);
		end
	end
end

function XPBarColor_Update_Color_From_Cosmos_Settings()
	if ( XPBarColor_Enabled == 1 ) then
		local mainmenuxpbar = getglobal("MainMenuExpBar");
		if ( mainmenuxpbar ) then
			local red, green, blue, alpha;
			red = XPBarColor_GetColorValue("RED");
			green = XPBarColor_GetColorValue("GREEN");
			blue = XPBarColor_GetColorValue("BLUE");
			alpha = XPBarColor_GetColorValue("ALPHA");
			mainmenuxpbar:SetStatusBarColor(red, green, blue, alpha);
			mainmenuxpbar:SetAlpha(alpha);
		end
	end
end

function XPBarColor_Color_Changed(toggle, value)
	XPBarColor_Update_Color();
end

-- Handles events
function XPBarColor_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( XPBarColor_Cosmos_Registered == 0 ) then
			local value = getglobal("XPBarColor_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			XPBarColor_Toggle_Enabled(value);
			local colors = { "Red", "Green", "Blue", "Alpha" };
			local default = { 0.0, 0.39, 0.88, 1.0 };
			for k, v in colors do
				value = getglobal("COS_XPBARCOLOR_"..string.upper(v));
				if (value == nil ) then
					-- defaults to off
					value = default[k];
				end
				XPBar_Change_Color(getglobal("XPBARCOLOR_VALUE_"..string.upper(v)), value);
			end
		end
	end
end

-- Toggles the enabled/disabled state of the XPBarColor
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function XPBarColor_Toggle_Enabled(toggle)
	local oldvalue = XPBarColor_Enabled;
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
	XPBarColor_Enabled = newvalue;
	setglobal("COS_XPBARCOLOR_ENABLED_X", newvalue);
	XPBarColor_Setup_Hooks(newvalue);
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			XPBarColor_Print(XPBARCOLOR_CHAT_ENABLED);
		else
			XPBarColor_Print(XPBARCOLOR_CHAT_DISABLED);
		end
	end
	XPBarColor_Register_Cosmos();
	RegisterForSave("XPBarColor_Enabled");
end

function XPBar_Change_Color(color, value)
	local variable = "COS_XPBARCOLOR_"..string.upper(color);
	local oldvalue = getglobal(variable, newvalue);
	local newvalue = value+0;
	setglobal(variable, newvalue);
	if ( newvalue ~= oldvalue ) then
		XPBarColor_Print(format(XPBARCOLOR_CHAT_VALUE_CHANGED, color, newvaluevalue));
	end
	XPBarColor_Register_Cosmos();
	RegisterForSave(variable);
end


-- Prints out text to a chat box.
function XPBarColor_Print(msg,r,g,b,frame,id,unknown4th)
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
