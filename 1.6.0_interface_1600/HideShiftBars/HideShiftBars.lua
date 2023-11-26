--[[

	HideShiftBars: Allows you to toggle the visibility of the rogue stealth
			bar, warrior stance bar, paladin aura bar, and druid shape shifting
			bar. (Hide/Show the Stealth/Stance/Aura/Shape bar)
			
	Author: copyright 2005 by Jake Bolton (ninmonkey) ninmonkeys@gmail.com
		
	Usage:
		Type << /shiftbar >> or  << /hideshiftbars >> for a list of commands		
		
	LastUpdate:	02/27/2005 (this isn't that accurate :P )
	
	Version 0.1.2:
		-updated for new blizz patch (interface 4216)
		-rewrote Initialization code
		-fixed the known issue that some classes defaulted to showing empty bars
			(ie: if a class like a mage has nothing binded too the shift-ing buttons
			then the buttons would show up as blank. With mods, they may have actions
			ie: AuraAspects + HideShiftBars to Show() the bar will show the aspects on
			a bar.)
	
	(for full changelog, view readme)

	todo:
		-set all clases that != (war|rogue|pally|druid) defaults to false (done)
			-otherwise they can get empty non-usable buttons		
			-hunter (with auraaspects) gets buttons that work, maybe optionable
				to be valid
			
	todo test:
			
	notes:
		-- bDebug = false before any release :P
		-- hooked function is in BonusActionBarFrame.lua - ShapeshiftBar_Update()
	
	notes misc:
		-when hooking, easy way to get a unique name is to use:
			local Pre_AddonName_OriginalFunction; then, in _OnLoad(), use:
			Pre_AddonName_OriginalFunction = Original function;
			(more info: http://www.wowwiki.com/HOWTO:_Hook_a_Function )
			
	Features:
		<view readme>
	
	ideas:
		maybe an option to turn on/off when entering/leaving combat

]]

-----------------------------------
-- variables
-----------------------------------

--debug
local bDebug = false;

-- mod version
HIDESHIFTBARS_MOD_VERSION = "0.1.2";
HIDESHIFTBARS_MOD_NAME = "|cffffff00HideShiftBars "..HIDESHIFTBARS_MOD_VERSION.."|r";

-- console command list
HIDESHIFTBARS_COMMANDS = { help="help", toggle="toggle" };

HIDESHIFTBARS_COLOR = { help="447cbf", helpheader="099779" };

HIDESHIFTBARS_CLASS_LIST = {"druid", "paladin", "rogue", "warrior"};


-- displayed at help
HIDESHIFTBARS_HELP_TEXT = {
	"HideShiftBars Help:",
	HIDESHIFTBARS_COMMANDS["help"]..": Shows this help message.",
	HIDESHIFTBARS_COMMANDS["toggle"]..": toggles the shift bar, (Stealth/Stance/Aura/Shape).",
};

-- var to hook ShapeshiftBar_Update(); to
local Pre_HideShiftBars_ShapeshiftBar_Update;
local bShowBar=true;

-- init vars
local bValidVariables = false;

-----------------------------------
-- local functions
-----------------------------------

local function print_error(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg.." Type /shiftbar help for a list of commands.");
end

local function print_msg(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

local function print_bool(bool)
	-- converts a boolean to a string
	if(bool) then
		return "true";
	else
		return "false";
	end
end

local function print_debug(msg)
	if(bDebug) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

local function IsValidClass(Class)

	local t_index;
    local t_class;
    for t_index, t_class in HIDESHIFTBARS_CLASS_LIST do
    	if(Class == nil) then
    	    print_debug("Error: IsValidClass(Class): Class was nil");
    	    return false;
    	end
        if( string.lower(Class) == string.lower(t_class) ) then
        	return true;
        end
    end
    
    -- not in array, so not valid
    return false
end


local function HelpColor()
	-- v0.2
		-- changed: regex is now "^(.-):(.*)$", 

	-- output colorized help (keeps help strings clean of color codes)
	
	-- if first line, either color, or leave plain
	-- all other lines, start with color blue, end before character ":"
	-- color start: |cff, color end: |r
	
	local index;
    local value;
    for index, value in HIDESHIFTBARS_HELP_TEXT do
    	local sText;
    	
    	if(index == 1) then    	
			
			-- header			
    		sText = "|cff"..HIDESHIFTBARS_COLOR["helpheader"]..value.."|r";
    		print_msg(sText);    		    		
    	else    	
    		
			--color normally    		
    		local sStart, sEnd, sCmd, sDesc = string.find(value, "^(.-):(.*)$");
    		sText = "|cff"..HIDESHIFTBARS_COLOR["help"]..sCmd.."|r:"..sDesc;
    		if( (sCmd == nil) or (sDesc == nil) ) then
    			-- if error in search, print non-colored string
    			print_msg(value);
    		end    		
    		-- print colored string
    		print_msg(sText);
    	end
    end
end

-----------------------------------
-- local command line functions
-----------------------------------

local function HideShiftBars_Toggle()	
	-- toggle, and save
	
	if(bShowBar) then
		-- IsVisible, so hide
		print_msg("Hiding bars.");
		ShapeshiftBarFrame:Hide();
		bShowBar = false;
	else
		-- IsHidden, so show
		print_msg("Showing bars.");
		ShapeshiftBarFrame:Show();
		bShowBar = true;
	end
	
	-- save
	HideShiftBars_SettingsSet();
end

local function HideShiftBars_SettingsLoad()

	local curClass = UnitClass("player");
	-- jake debug
	-- print_debug("Reading (or creating) class: "..curClass.." default value");
			
	if( not HideShiftBarsData ) then
		-- jake debug
		-- print_debug("Array does not even exist, creating array...");
		HideShiftBarsData = {};
		HideShiftBarsData[curClass]=true;			 
	else
		-- var exists, check if class setting exists
		-- cannot use if ( not <var> ) because if it does exist and is false, it will
				-- evaluate to true
		if( HideShiftBarsData[curClass] == nil ) then
			-- var exists, but, setting does not, so set setting
			-- jake debug
			-- print_debug("Class value for: "..curClass.." Does not exist yet, creating...");
			HideShiftBarsData[curClass]=true;				
		else
			-- var exists, and, setting does exist, so do load (below)
			-- jake debug
			-- print_debug("Class value for: "..curClass.." Exists. Loading...");			
		end			
	end
	
	if( IsValidClass(curClass) == false )then
		-- not valid
		HideShiftBarsData[curClass]=false;
		print_debug("Class not on list, not showing by default for: "..curClass);
	else
		-- is valid
		print_debug("Class *is* on list, showing by saved setting(default is on): "..curClass);
	end
		
	-- variables are created/loaded, so set boolean to proper value	
	bShowBar = HideShiftBarsData[curClass];
	-- jake debug
	-- print_debug("I just set bShowBar="..print_bool(bShowBar));
end

function HideShiftBars_SettingsSet()
	-- error if function is local, but still works... :P
	-- save current value (true|false)
	
	local curClass = UnitClass("player");
	-- print_debug("Saving class: "..curClass.."'s current value");
	HideShiftBarsData[curClass]=bShowBar;
	-- jake debug	
	-- print_debug("I'm calling _SettingsSet() with:"..print_bool(bShowBar).."!");
end

-----------------------------------
-- slash commands
-----------------------------------

function HideShiftBars_SlashCommandHandler(msg)

    if( msg ) then
        local command = string.lower(msg);
            
        if( command == "" or command == HIDESHIFTBARS_COMMANDS["help"] ) then        		        
	        HelpColor();
	            
	    elseif( string.find(command, "^"..HIDESHIFTBARS_COMMANDS["toggle"]) ) then
	    	-- togle the bars on/off
	        HideShiftBars_Toggle();
	    else
	        -- invalid flag/command
	        print_error("CommandHandler: "..msg..": command not found!");
	    end	  
	else
		-- no msg
		print_error("CommandHandler: No command given!");
    end	    
end

------------------------------------
-- Hooked functions
------------------------------------

function HideShiftBars_ShapeshiftBar_Update()
	-- call original function
	Pre_HideShiftBars_ShapeshiftBar_Update()
	
	-- do my stuff
	
	-- jake note: wierd, this function is called *alot*, just uncomment the line and see...
	-- print_msg("ShapeshiftBar_Update(): was called...");
	
	-- make sure bar stays hidden/shown
	if(bShowBar) then
		-- not shown, but should be
		if( not ShapeshiftBarFrame:IsVisible() ) then
			ShapeshiftBarFrame:Show();
		end
	else
		-- shown, but should be hidden
		if( ShapeshiftBarFrame:IsVisible() ) then
			ShapeshiftBarFrame:Hide();
		end
	end
end

------------------------------------
-- OnFoo functions
------------------------------------

function HideShiftBars_OnEvent()
	-- if( event == "VARIABLES_LOADED" ) then
		-- normally check if variables exist, if not create/set them, but,
		-- VARIABLES_LOADED event happens before player is a valid unit
	
	-- if ( (UnitClass("player") ~= nil) and (event == VARIABLES_LOADED ) ) then
		-- GetSavedSetting();
	-- end
	
	if( event == "VARIABLES_LOADED" ) then
		bValidVariables = true;
	end
		
	if( (event == "PLAYER_ENTERING_WORLD") and (bValidVariables) ) then
		local curClass = UnitClass("player");
		
		if( (curClass ~= nil) and (bValidVariables) ) then
			-- finnaly okay to load	
			-- print_debug("I'm calling _SettingsLoad()!");
			HideShiftBars_SettingsLoad();			
		end		
	end
end

function HideShiftBars_OnLoad()  
  -- Register events  
  this:RegisterEvent("VARIABLES_LOADED");
  this:RegisterEvent("PLAYER_ENTERING_WORLD");
  
  -- hook function
  Pre_HideShiftBars_ShapeshiftBar_Update = ShapeshiftBar_Update;
  ShapeshiftBar_Update = HideShiftBars_ShapeshiftBar_Update;
     
  -- Register slash command
  -- I don't like 2 letter slash commands, most likely to conflict, ie: /sb
  		-- would conflict with telo's sidebar, not sure what would happen then
  SLASH_HIDESHIFTBARS1 = "/hideshiftbars";
  SLASH_HIDESHIFTBARS2 = "/shiftbars"; -- optional "s" to prevent user confusion
  SLASH_HIDESHIFTBARS3 = "/shiftbar";
  
  SlashCmdList["HIDESHIFTBARS"] = function(msg)
      HideShiftBars_SlashCommandHandler(msg);
  end  

  -- loaded okay so show loaded text
  -- show on defualt chat window
  --if( DEFAULT_CHAT_FRAME ) then
     -- DEFAULT_CHAT_FRAME:AddMessage("ninmonkey's "..HIDESHIFTBARS_MOD_NAME.." loaded!");
 -- end

  -- show pop-up text like an error
 -- UIErrorsFrame:AddMessage("ninmonkey's "..HIDESHIFTBARS_MOD_NAME.." loaded!", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
  
	if(UltimateUI_RegisterConfiguration) then
		UltimateUI_RegisterConfiguration(
			"UUI_HIDESHIFTBARS",
			"SECTION",
			"Hide Shift Bars"
			);
		UltimateUI_RegisterConfiguration(
			"UUI_HSB_SEPARATOR",
			"SEPARATOR",
			"Hide Stance/Aura/Shapeshift Bar"
			);
		UltimateUI_RegisterConfiguration(
			"UUI_HSB_LOCK",
			"BUTTON",
			"Toggle the ShapeshiftBar frame",
			"Press the button to toggle the Shapeshiftbar frame.",
			HideShiftBars_Toggle,
			0,
			0,
			0,
			0,
			"Toggle"
		);
	end
  
end
