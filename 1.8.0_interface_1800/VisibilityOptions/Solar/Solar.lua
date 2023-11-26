--[[
	Solar
	 	Allows transparentizing of frames
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	Solar allows a developer to specify a frame to be made transparent.
	To register a frame for transparency use the Eclipse.Solar.Register
	function.
	
	$Id: Solar.lua 2476 2005-09-18 12:43:06Z mugendai $
	$Rev: 2476 $
	$LastChangedBy: mugendai $
	$Date: 2005-09-18 07:43:06 -0500 (Sun, 18 Sep 2005) $
]]--

--------------------------------------------------
--
-- Solar Declaration
--
--------------------------------------------------
Eclipse.Solar = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	CONFIG_PREFIX = "Solar";		--The prefix for the configuration options
	
	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	Regs = {};			--The registered frames
	Initialized = 0;	--Whether Solar has been initialized or not
};

--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
Solar_Config = {};		--Main Configuration variable
Solar_Storage = {};		--Configuration Storage Variable

--------------------------------------------------
--
-- Public Functions
--
--------------------------------------------------
--[[
 	registerForTransparency ( {reglist} )
	 	Registers a frame to be made transparent.  This is the main function for interfacing with
	 	Solar.  The function will register the frame, as well as a chat command, and GUI
	 	option if you provide it the info it needs to do so.
	
	Args:
	 	reglist - the table of options, some options will be listed more than once to show when they are needed, but only set them once
	 	 	{
	 	 	Data required to register a frame for autohiding:
	 	 		(string) name - The name of this configuration, should be the name of the frame to autohide if you aren't passing frames
	 	 	
	 	 	Optional data for transparency:
	 	 		(bool) enabled -	If this is true, then the option will be enabled by default
	 	 		(number) trans - The default transparency for this frame
	 	 		(number) min - The minimum that the transparency may be set to for this frame
				(number) max - The minimum that the transparency may be set to for this frame
	 	 		(string or table)	frames -	The name of the frame to transparentize, or a list of frames to to transparentize, if not specified, name is used.
					{
	 					(string or table) -	Each entry can be either a string with the name of the frame, or a table specifying a range of frames
	 															If you pass the table specifying the range it will take the name and tack on a number at the end
	 															based on min, and max.
	 															Ex, {name="PartyFrame", min=1, max=4} will register "PartyFrame1" though "PartyFrame4"
	 															Alternative Ex, {name="Party%dFrame", min=1, max=4} will register "Party1Frame" though "Party4Frame"
	 	 					{
								(string) name -	The base name of this set of frames to to hide.  If this contains a format character such as %d,
																it will be replaced with the frame number, otherwise the frame number will be added to the end.
								(number) min - The lowest number frame to start with
								(number) max - The highest number of frame to end with
							}
					}
	 	 	
	 	 	Data required to register a slash command:
	 	 		(string or table) slashcom - The slash command, Ex. "framename", or this can be a list of commands Ex. {"framename", "fname", "fn"}
	 	 		
	 	 	Optional slash command data:
	 	 		(string) slashname - The name to display for this option when printing status from a slash command change, defaults to uiname
	 	 		(string) slashhelp -	Message to show next to the slash command when help is printed, if not
	 	 													passed then this is generated from uiname, or name if uiname isn't
	 	 													available.
	 	 		
	 	 	Data required to register a UI option:
	 	 		(string) uiname - The name to display for the option in the UI, defaults to slashname
	 	 			or
	 	 		(string) uilabel -	The label to display for the option in the UI, if this isn't passed, it
	 	 												it is then generated based on uiname.
	 	 	
	 	 	Optional data for the UI:
	 	 		(string) uidesc - The description to display for the option in the UI
	 	 		(number) uidiff - The difficulty of the option in the UI
	 	 		(string) uisec - The section to put the option in, if not passed, will put it in VisibilityOptions
	 	 		(string) uiseclabel -	The name of the section to put the option in, only pointful if putting
	 	 													into a new section.
	 	 		(string) uisecdesc -	The description of the section to put the option in, only pointful if
	 	 													putting	into a new section.
	 	 		(number) uisecdiff -	The difficulty of the section to put the option in, only pointful if
	 	 													putting	into a new section.
	 	 		(string) uisep -	The separator to put the option behind, if not passed, will put it behind
	 	 											an Autohide separator.
	 	 		(string) uiseplabel -	The name of the separator to put the option behind, only pointful if
	 	 													putting behind a new separator.
	 	 		(string) uisepdesc -	The description of the separator to put the option behind, only
	 	 													pointful if	putting	behind a new section.
	 	 		(number) uisepdiff -	The difficulty of the separator to put the option in, only pointful if
	 	 													putting	into a new separator.
	 	 													
	 	 	The following options are provided as convience wrappers to Eclipses SetFrame function
			See Eclipse.SetFrame for further details:
	 	 		(boolean) manualtrnas -	Should Eclipse have full control of the frames transparency
				(table)	state	-	The default state of the frame
	 	 		
]]--
Eclipse.Solar.registerForTransparency = function ( reglist )
	--Get a local copy of reglist, so we dont end up altering the origional
	local reglist = Sea.table.copy(reglist);
	
	--We need at bare minimum the name of a frame to make transparent
	if (reglist and reglist.name) then
		--If frames list doesn't exist, then make it
		if (not reglist.frames) then
			reglist.frames = { reglist.name };
		end
		--If frames is not a list of frames, then turn it into one
		if ( type(reglist.frames) ~= "table" ) then
			reglist.frames = { reglist.frames };
		elseif (reglist.frames.name and reglist.frames.min and reglist.frames.max) then
			reglist.frames = { reglist.frames };
		end

		--Convert any itterated frames to their real frame names, and put them in the table
		for index in reglist.frames do
			if ( type(reglist.frames[index]) == "table" ) then
				local curName = reglist.frames[index].name;
				local curMin = reglist.frames[index].min;
				local curMax = reglist.frames[index].max;
				if (curName and curMin and curMax) then
					local curCount = 0;
					local curFrameName = curName;
					for curNum = curMin, curMax do
						--If there is a % in the current frame name, then replace it with the frame number
						--otherwise tack it on the end
						curFrameName = curName;
						if (string.find(curFrameName, "%%")) then
							curFrameName = string.format(curFrameName, curNum);
						else
							curFrameName = curFrameName..curNum;
						end
						--If this is the first entry in the list, then replace the current frame with it
						--otherwise insert it after the current frame
						if (curCount == 0) then
							reglist.frames[index] = curFrameName;
						else
							table.insert(reglist.frames, index + curCount, curFrameName);
						end
						curCount = curCount + 1;
					end
				else
					table.remove(reglist.frames, index);
				end
			end
		end

		--Convert enabled to 1/0 format
		if ( reglist.enabled and (reglist.enabled == true) ) then
			reglist.enabled = 1;
		else
			reglist.enabled = 0;
		end

		--Make sure the min value is safe
		if (not reglist.min) then
			reglist.min = 0;
		end
		if (reglist.min >= 1) then
			reglist.min = 0.99;
		end
		if (reglist.min < 0) then
			reglist.min = 0;
		end
		
		--Make sure the max value is safe
		if (not reglist.max) then
			reglist.max = 1;
		end
		if (reglist.max > 1) then
			reglist.max = 1;
		end
		if (reglist.max <= reglist.min) then
			reglist.max = reglist.min + 0.01;
		end
		
		--Make sure the default value is safe
		if (not reglist.trans) then
			reglist.trans = reglist.max;
		end
		if (reglist.trans > reglist.max) then
			reglist.trans = reglist.max;
		end
		if (reglist.trans < reglist.min) then
			reglist.trans = reglist.min;
		end
		
		--Add frames to Eclipses list
		for index in reglist.frames do
			Eclipse.SetFrame( {
				name = reglist.frames[index];
				controltrans = true;
				manualtrans = reglist.manualtrans;
				state = reglist.state;
				trans = reglist.trans;
			} )
		end
		--If we don't have a config for this frame, then make one
		if (not Solar_Config[reglist.name]) then
			Solar_Config[reglist.name] = {};
		end
		if (not Solar_Config[reglist.name].Enabled) then
			Solar_Config[reglist.name].Enabled = reglist.enabled;
		end
		if (not Solar_Config[reglist.name].Trans) then
			Solar_Config[reglist.name].Trans = reglist.trans;
		end
		
		--Add the frame to the list
		Eclipse.Solar.Regs[reglist.name] = {};
		Eclipse.Solar.Regs[reglist.name].frames = reglist.frames;

		local confVarName = nil;	--The name of the UI variable for this frame
		local confVarBool = "Solar_Config."..reglist.name..".Enabled";	--The name of the boolean variable to update
		local confVarNum = "Solar_Config."..reglist.name..".Trans";			--The name of the number variable to update
		
		--If a name to display for a UI option has been passed, then register with the UI
		if (reglist.uiname or reglist.uilabel) then
			--Generate the name for the UI variable
			confVarName = Eclipse.Solar.CONFIG_PREFIX..reglist.name;
			
			--If no name was passed for the ui option then make one
			if (not reglist.uiname) then
				reglist.uiname = reglist.slashname;
			end
			if (not reglist.uiname) then
				reglist.uiname = reglist.name;
			end
			--If no label was passed for the ui option then make one
			if (not reglist.uilabel) then
				reglist.uilabel = string.format(SOLAR_CONFIG_LABEL, reglist.uiname);
			end
			--If no ui description was passed, then make one ourselves
			if (not reglist.uidesc) then
				reglist.uidesc = string.format(SOLAR_CONFIG_INFO, reglist.uiname);
			end
			--If no ui difficulty was passed, then make one ourselves
			if (not reglist.uidiff) then
				reglist.uidiff = 2;
			end
			
			--If section info was not passed, then use defaults
			if (not reglist.uisec) then
				reglist.uisec = "VisibilityOptions";
			end
			if (not reglist.uiseclabel) then
				reglist.uiseclabel = ECLIPSE_CONFIG_SECTION;
			end
			if (not reglist.uisecdesc) then
				reglist.uisecdesc = ECLIPSE_CONFIG_SECTION_INFO;
			end
			if (not reglist.uisecdiff) then
				reglist.uisecdiff = 2;
			end
			
			--If separator info was not passed, then use defaults
			if (not reglist.uisep) then
				reglist.uisep = reglist.uisec..Eclipse.Solar.CONFIG_PREFIX.."Sep";
			end
			if (not reglist.uiseplabel) then
				reglist.uiseplabel = SOLAR_CONFIG_HEADER;
			end
			if (not reglist.uisepdesc) then
				reglist.uisepdesc = SOLAR_CONFIG_HEADER_INFO;
			end
			if (not reglist.uisepdiff) then
				reglist.uisepdiff = 2;
			end
			
			--If no name was passed to show in the chat outout, then use defaults
			if (not reglist.slashname) then
				reglist.slashname = reglist.uiname;
			end
			if (not reglist.slashname) then
				reglist.slashname = reglist.name;
			end

			--Register the option
			MCom.registerSmart( {
				uifolder = "frames";
				uisec = reglist.uisec;
				uiseclabel = reglist.uiseclabel;
				uisecdesc = reglist.uisecdesc;
				uisecdiff = reglist.uisecdiff;
				uisep = reglist.uisep;
				uiseplabel = reglist.uiseplabel;
				uisepdesc = reglist.uisepdesc;
				uisepdiff = reglist.uisepdiff;
				hasbool = true;
				uivar = confVarName;															--The option name for the UI
				uitype = K_SLIDER;																--The option type for the UI
				uilabel = reglist.uilabel;												--The label to use for the option in the UI
				uidesc = reglist.uidesc;													--The description to use for the option in the UI
				uidiff = reglist.uidiff;
				varbool = confVarBool;
				varnum = confVarNum;
				update = function () Eclipse.Solar.updateUI(reglist.name); end;
				uicheck = reglist.enabled;												--The default value for the checkbox in the UI
				uislider = reglist.trans;													--The default value for the slider in the UI
				uimin = reglist.min;															--The minimum value for the slider in the UI
				uimax = reglist.max;															--The maximum value for the slider in the UI
				uitext = SOLAR_CONFIG_SLIDER;											--The text to show above the slider in the UI
				uistep = 0.01;																		--The increment to increase the slider in the UI
				uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
				uisuffix = SOLAR_CONFIG_SUFFIX;										--The suffix to place after the slider balue
				uimul = 100;																			--What to multiply the actual value of the slider by when showing the value in the UI
			} );
		end
		
		--If a name for a slash command was passed, make a slash command for this frame
		if (reglist.slashcom) then
			if (not reglist.slashhelp) then
				local slashName = reglist.name;
				if (reglist.uiname) then
					slashName = reglist.uiname;
				end
				reglist.slashhelp = string.format(SOLAR_CHAT_SUBCOMMAND_INFO, slashName);
			end
				
			--Register the super slash command
			MCom.registerSmart( {
				supercom = {"/transparency", "/trans", "/vot"};			--The main(super) slash command associated with this subommand
				comaction = "before";																--See Sky for info on this
				comsticky = false;																	--See Sky for info on this
				comhelp = SOLAR_CHAT_COMMAND_INFO;									--The help text to show for the slash command
				extrahelp = SOLAR_CHAT_COMMAND_HELP;								--Extra help text to print out
			} );
			--Register the slash command for this frame
			MCom.registerSmart( {
				supercom = {"/transparency", "/trans"};							--The main(super) slash command associated with this subommand
				subcom = reglist.slashcom;													--The sub slash command and any aliases
				comtype = MCOM_MULTIT;															--The type of subcommand it is
				subhelp = reglist.slashhelp;												--The help text for the sub slash command
				uivar = confVarName;																--The option name for the UI
				varbool = confVarBool;															--The boolean variable that the UI should be updated from, when using the slash command
				varnum = confVarNum;																--The number variable that the UI should be updated from, when using the slash command
				textname = string.format(SOLAR_CHAT, reglist.slashname);
				varmin = reglist.min;																--The minimum the var can be set to
				varmax = reglist.max;																--The maximum the var can be set to
				commul = 100;
				cominmul = 0.01;
				update = function () Eclipse.Solar.updateUI(reglist.name); end;
			} );
		end

		--Store this config for safe load
		MCom.safeLoad("Solar_Config");
	end
end;
--[[ Alias for registerForTransparency ]]--
Eclipse.Solar.registerUI = Eclipse.Solar.registerForTransparency;

--[[
 	toggle (number onOff)
	 	Enables/Disabled the Solar override.  While the override is on
	 	all frames solar controls will be shown as normal.
	
	Optional: 
	 	onOff - If not passed, will toggle.  If 1 will enable override.
	 					If anything else, will turn off override.
]]--
Eclipse.Solar.toggle = function (onOff)
	if (onOff) then
		if (onOff == 1) then
			Solar_Override = true;
		else
			Solar_Override = nil;
		end
	else
		if (Solar_Override) then
			Solar_Override = nil;
		else
			Solar_Override = true;
		end
	end
end;

--[[
 	updateUI (string frameName)
	 	Sets a frame/frameset to have a level of transparency.
	
	Args:
	 	frameName - The name of the frame to set transparency on.
]]--
Eclipse.Solar.updateUI = function (frameName)
	--Make sure we have all our info
	if (frameName and Eclipse.Solar.Regs[frameName] and Solar_Config[frameName]) then
		--Check to see if this frame is in Solar's list, and if not, make sure its a list
		local curFrames = frameName;
		if (Eclipse.Solar.Regs[frameName].frames) then
			curFrames = Eclipse.Solar.Regs[frameName].frames;
		end
		if (type(curFrames) ~= "table") then
			curFrames = { curFrames };
		end
		
		--Default transparency to normal
		local setTrans = 1;
		--Set the transparency level, only if enabled
		if (Solar_Config[frameName].Enabled == 1) then
			setTrans = Solar_Config[frameName].Trans;
		end
	
		--Go through all frames in the list
		for index, curFrameName in curFrames do
			--Set the trans parameter for the frame
			if (Eclipse.Frames[curFrameName]) then
				Eclipse.Frames[curFrameName].trans = setTrans;
			end
		end
	end
	--Save the configuration
	Eclipse.Solar.SaveConfig();
end;

--[[ Updates all Eclipse frames with the current config data ]]--
Eclipse.Solar.UpdateFrames = function ()
	for curFrameName in Eclipse.Solar.Regs do
		Eclipse.Solar.updateUI(curFrameName);
	end
end;

--[[ Saves the current configuration on a per realm/per character basis ]]--
Eclipse.Solar.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "Solar_Config";
		storeVar = "Solar_Storage";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
Eclipse.Solar.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "Solar_Config";
		storeVar = "Solar_Storage";
		nonUIList = {};
	});
end
