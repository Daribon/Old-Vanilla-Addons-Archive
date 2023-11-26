--[[
	Total
	 	Allows hiding of frames
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	Total allows a developer to specify a frame to be made hidden.
	To register a frame for hiding/showing use the Eclipse.Total.Register
	function.
	
	$Id: Total.lua 2640 2005-10-17 09:22:31Z mugendai $
	$Rev: 2640 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-17 04:22:31 -0500 (Mon, 17 Oct 2005) $
]]--

--------------------------------------------------
--
-- Total Declaration
--
--------------------------------------------------
Eclipse.Total = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	CONFIG_PREFIX = "Total";		--The prefix for the configuration options
	
	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	Regs = {};			--The registered frames
	Initialized = 0;	--Whether Total has been initialized or not
};

--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
Total_Config = {};		--Main Configuration variable
Total_Storage = {};		--Configuration Storage Variable

--------------------------------------------------
--
-- Public Functions
--
--------------------------------------------------
--[[
 	registerForHide ( {reglist} )
	 	Registers a frame to be hidden.  This is the main function for interfacing with Total.
	 	The function will register the frame, as well as a chat command, and a GUI
	 	option if you provide it the info it needs to do so.
	
	Args:
	 	reglist - the table of options, some options will be listed more than once to show when they are needed, but only set them once
	 	 	{
	 	 	Data required to register a frame for hiding:
	 	 		(string) name - The name of this configuration, should be the name of the frame to autohide if you aren't passing frames
	 	 	
	 	 	Optional data for hiding:
	 	 		(bool) show -	If this is true, then the frame will be shown when the option is enabled, instead of hidden, and hidden when
	 	 									disabled, instead of shown
	 	 		(bool) enabled -	If this is true, then the option will be enabled by default
	 	 		(string or table)	frames -	The name of the frame to hide, or a list of frames to to hide, if not specified, name is used.
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
				(table) reqs -	A table of requirements.  The frame(s) will only show if all requirements
												are met.
				(boolean) manual -	Should Eclipse have full control of the frames hiding/showing
				(table)	state	-	The default state of the frame
				(function) onupdate -	the OnUpdate function for the frame, if it needs called while hidden
	 	 		
]]--
Eclipse.Total.registerForHide = function ( reglist )
	--Get a local copy of reglist, so we dont end up altering the origional
	local reglist = Sea.table.copy(reglist);
	
	--We need at bare minimum the name of a frame to hide
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

		--Setup defaults for reglist.enabled
		if ( reglist.enabled == nil ) then
			if ( reglist.show and (reglist.show == true) ) then
				reglist.enabled = true;
			else
				reglist.enabled = false;
			end
		end
		
		--Convert reglist.enabled to wantHide format
		if ( reglist.enabled == true ) then
			reglist.enabled = 1;
		else
			reglist.enabled = 0;
		end
		
		--Account for reglist.show
		local wantHide = reglist.enabled;
		if ( reglist.show and (reglist.show == true) ) then
			if (wantHide == 1) then
				wantHide = 0;
			else
				wantHide = 1;
			end
		end
		
		--Add frames to Eclipses list
		for index in reglist.frames do
			Eclipse.SetFrame( {
				name = reglist.frames[index];
				control = true;
				manual = reglist.manual;
				state = reglist.state;
				wantHide = wantHide;
			} )
		end
		--If we don't have a config for this frame, then make one
		if (not Total_Config[reglist.name]) then
			Total_Config[reglist.name] = {};
		end
		if (not Total_Config[reglist.name].Enabled) then
			Total_Config[reglist.name].Enabled = reglist.enabled;
		end
		
		--Add the frame to the list
		Eclipse.Total.Regs[reglist.name] = {};
		Eclipse.Total.Regs[reglist.name].frames = reglist.frames;
		Eclipse.Total.Regs[reglist.name].show = reglist.show;
		
		--Add this frame to Eclipses list
		Eclipse.SetFrame( {
			name = reglist.name;
			reqs = reglist.reqs;
			manual = reglist.manual;
			state = reglist.state;
			onupdate = reglist.onupdate;
		} )

		local confVarName = nil;	--The name of the UI variable for this frame
		local confVarBool = "Total_Config."..reglist.name..".Enabled";	--The name of the boolean variable to update
		
		--If a name to display for a UI option has been passed, then register with the UI
		if (reglist.uiname or reglist.uilabel) then
			--Generate the name for the UI variable
			confVarName = Eclipse.Total.CONFIG_PREFIX..reglist.name;
			
			--If no name was passed for the ui option then make one
			if (not reglist.uiname) then
				reglist.uiname = reglist.slashname;
			end
			if (not reglist.uiname) then
				reglist.uiname = reglist.name;
			end
			--If no label was passed for the ui option then make one
			if (not reglist.uilabel) then
				if ( reglist.show ~= true ) then
					reglist.uilabel = string.format(TOTAL_CONFIG_LABEL, reglist.uiname);
				else
					reglist.uilabel = string.format(TOTAL_CONFIG_LABEL_SHOW, reglist.uiname);
				end
			end
			--If no ui description was passed, then make one ourselves
			if (not reglist.uidesc) then
				if ( reglist.show ~= true ) then
					reglist.uidesc = string.format(TOTAL_CONFIG_INFO, reglist.uiname);
				else
					reglist.uidesc = string.format(TOTAL_CONFIG_INFO_SHOW, reglist.uiname);
				end
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
				reglist.uisep = reglist.uisec..Eclipse.Total.CONFIG_PREFIX.."Sep";
			end
			if (not reglist.uiseplabel) then
				reglist.uiseplabel = TOTAL_CONFIG_HEADER;
			end
			if (not reglist.uisepdesc) then
				reglist.uisepdesc = TOTAL_CONFIG_HEADER_INFO;
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
				uitype = K_TEXT;																	--The option type for the UI
				uilabel = reglist.uilabel;												--The label to use for the option in the UI
				uidesc = reglist.uidesc;													--The description to use for the option in the UI
				uidiff = reglist.uidiff;
				varbool = confVarBool;
				update = function () Eclipse.Total.updateUI(reglist.name); end;
				uicheck = reglist.enabled;												--The default value for the checkbox in the UI
			} );
		end
		
		--If a name for a slash command was passed, make a slash command for this frame
		if (reglist.slashcom) then
			if (not reglist.slashhelp) then
				local slashName = reglist.name;
				if (reglist.uiname) then
					slashName = reglist.uiname;
				end
				if ( reglist.show ~= true ) then
					reglist.slashhelp = string.format(TOTAL_CHAT_SUBCOMMAND_INFO, slashName);
				else
					reglist.slashhelp = string.format(TOTAL_CHAT_SUBCOMMAND_INFO_SHOW, slashName);
				end
			end
				
			--Register the super slash command
			MCom.registerSmart( {
				supercom = { "/hide", "/show", "/voh" };						--The main(super) slash command associated with this subommand
				comaction = "before";																--See Sky for info on this
				comsticky = false;																	--See Sky for info on this
				comhelp = TOTAL_CHAT_COMMAND_INFO;									--The help text to show for the slash command
				extrahelp = TOTAL_CHAT_COMMAND_HELP;								--Extra help text to print out
			} );
			--Register the slash command for this frame
			MCom.registerSmart( {
				supercom = { "/hide", "/show" };										--The main(super) slash command associated with this subommand
				subcom = reglist.slashcom;													--The sub slash command and any aliases
				comtype = MCOM_BOOLT;																--The type of subcommand it is
				subhelp = reglist.slashhelp;												--The help text for the sub slash command
				uivar = confVarName;																--The option name for the UI
				varbool = confVarBool;															--The boolean variable that the UI should be updated from, when using the slash command
				textname = string.format(TOTAL_CHAT, reglist.slashname);
				update = function () Eclipse.Total.updateUI(reglist.name); end;
			} );
		end

		--Store this config for safe load
		MCom.safeLoad("Total_Config");
	end
end;
--[[ Alias for registerForHide ]]--
Eclipse.Total.registerUI = Eclipse.Total.registerForHide;

--[[
 	toggle (number onOff)
	 	Enables/Disabled the Total override.  While the override is on
	 	all frames total controls will be shown as normal.
	
	Optional: 
	 	onOff - If not passed, will toggle.  If 1 will enable override.
	 					If anything else, will turn off override.
]]--
Eclipse.Total.toggle = function (onOff)
	if (onOff) then
		if (onOff == 1) then
			Total_Override = true;
		else
			Total_Override = nil;
		end
	else
		if (Total_Override) then
			Total_Override = nil;
		else
			Total_Override = true;
		end
	end
end;

--[[
 	updateUI (string frameName)
	 	Sets a frame/frameset to be hidden or not.
	
	Args:
	 	frameName - The name of the frame to set vidibility on.
]]--
Eclipse.Total.updateUI = function (frameName)
	if (frameName and Eclipse.Total.Regs[frameName] and Total_Config[frameName]) then
		--Check to see if this frame is in Total's list, and if not, make sure its a list
		local curFrames = frameName;
		if (Eclipse.Total.Regs[frameName].frames) then
			curFrames = Eclipse.Total.Regs[frameName].frames;
		end
		if (type(curFrames) ~= "table") then
			curFrames = { curFrames };
		end

		--Account for the Show option
		local wantHide = Total_Config[frameName].Enabled;
		if (Eclipse.Total.Regs[frameName].show == true) then
			if (wantHide == 1) then
				wantHide = 0;
			else
				wantHide = 1;
			end
		end
		--Go through all frames in the list
		for index, curFrameName in curFrames do
			--Set the wantHide parameter for the frame
			if (Eclipse.Frames[curFrameName]) then
				Eclipse.Frames[curFrameName].wantHide = wantHide;
			end
		end
	end
	--Save the configuration
	Eclipse.Total.SaveConfig();
end;

--[[ Updates all Eclipse frames with the current config data ]]--
Eclipse.Total.UpdateFrames = function ()
	for curFrameName in Eclipse.Total.Regs do
		Eclipse.Total.updateUI(curFrameName);
	end
end;

--[[ Saves the current configuration on a per realm/per character basis ]]--
Eclipse.Total.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "Total_Config";
		storeVar = "Total_Storage";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
Eclipse.Total.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "Total_Config";
		storeVar = "Total_Storage";
		nonUIList = {};
	});
end
