--[[
	Lunar
	 	Allows autohiding of frames
	
	By: Mugendai
	
	Lunar allows a developer to specify a frame to be autohidden when the mouse is not
	over the frame.  To register a frame for autohiding use the Eclipse.Lunar.Register
	function.
	
	$Id: Lunar.lua 2640 2005-10-17 09:22:31Z mugendai $
	$Rev: 2640 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-17 04:22:31 -0500 (Mon, 17 Oct 2005) $
]]--

--------------------------------------------------
--
-- Lunar Declaration
--
--------------------------------------------------
Eclipse.Lunar = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	UPDATETIME = 0.1;								--How long between updates
	MAXTIME = 2;										--Maximum amount of time the user can set the hover delay on a frame to
	CONFIG_PREFIX = "Lunar";		--The prefix for the configuration options
	CALL_BEFORE = "before";					--Call the callback before checking the ui
	CALL_AFTER = "after";						--Call the callback after checking the ui	
	CALL_INSTEAD = "instead";				--Call the callback instead of checking the ui
	
	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	Regs = {};			--The registered frames
	Initialized = 0;	--Whether Lunar has been initialized or not
	LastUpdate = 0;		--How long it has been since the last update
};

--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
Lunar_Config = {};		--Main Configuration variable
Lunar_Storage = {};		--Configuration Storage Variable

--------------------------------------------------
--
-- Public Functions
--
--------------------------------------------------
--[[
 	registerForAutohide ( {reglist} )
	 	Registers a frame to be autohidden.  This is the main function for interfacing with
	 	Lunar.  The function will register the frame, as well as a chat command, and a 
	 	GUI option if you provide it the info it needs to do so.
	
	Args:
	 	reglist - the table of options, some options will be listed more than once to show when they are needed, but only set them once
	 	 	{
	 	 	Data required to register a frame for autohiding:
	 	 		(string) name - The name of this configuration, should be the name of the frame to autohide if you aren't passing frames
	 	 	
	 	 	Optional data for autohiding:
	 	 		(bool) enabled -	If this is true, then the option will be enabled by default
	 	 		(number) time -	Sets the default value for the amount of time the mouse must hover to show
	 	 		(string or table)	frames -	The name of the frame to autohide, or a list of frames to autohide, if not specified, name is used.
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
				(string or table)	checkframes -	The name of the frame, or a list of frames to check for mouse, if not specified, frames is used.
																				These frames are the ones checked to see if the mouse is over, and will cause poping when it is.
																				If you pass "" no frames will be checked, and only the reqs will matter.
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
	 	 		
	 	 	Optional:
	 	 		(function) callback - A function that can be called to allow for advanced behavior.
	 	 													This function can either be called instead of the internal
	 	 													functions for showing/hiding the frame.  Or it can be called
	 	 													just before the frame is about to be shown/hidden.  Or it can
	 	 													be called just after the frame is shown/hidden.
	 	 													
	 	 		(string) callhow -	How/When to call the callback.  Here is a list of the options as
	 	 												as well as the functions that are called:

	 	 												Eclipse.Lunar.CALL_INSTEAD -	This is default.  The function will
	 	 													be called instead of the internal code for checking whether to
	 	 													show or not.  You	are responsible for showing the frame in this
	 	 													case.

										 	 				function ( whichUI, isEnabled, xPos, yPos )
										 	 					(string) whichUI - The name of the frame we are checking
										 	 					(number) isEnabled - 1 if the option is enabled, 0 if not
										 	 					(number) xPos - The X position of the mouse cursor
										 	 					(number) yPos - The Y position of the mouse cursor
										 	 			
										 	 			Eclipse.Lunar.CALL_BEFORE -	The function will be called just
										 	 				before the frame is hidden/shown.  If the function returns
										 	 				true, then the show/hide will be canceled.

										 	 				function ( whichUI, isEnabled, doShow )
										 	 					(string) whichUI - The name of the frame we are checking
										 	 					(number) isEnabled - 1 if the option is enabled, 0 if not
										 	 					(number) doShow - 1 if it is showing, 0 if it is hiding
										 	 			
										 	 			Eclipse.Lunar.CALL_AFTER -	The function will be called just
										 	 				after the frame is hidden/shown.

										 	 				function ( whichUI, isEnabled, isShowing )
										 	 					(string) whichUI - The name of the frame we are checking
										 	 					(number) isEnabled - 1 if the option is enabled, 0 if not
										 	 					(number) isShowing - true if the frame is shown, false if not
										 	 					
			The following options are provided as convience wrappers to Eclipses SetFrame function
			See Eclipse.SetFrame for further details:
				(table) reqs -	A table of requirements.  The frame(s) will only show if all requirements
												are met.
				(boolean) manual -	Should Eclipse have full control of the frames hiding/showing
				(table)	state	-	The default state of the frame
				(function) onupdate -	the OnUpdate function for the frame, if it needs called while hidden
				(multi) top - the distance from the bottom of the screen to the top of the frame
				(multi) left - the distance from the left of the screen to the left of the frame
				(multi) bottom - the distance from the bottom of the screen to the bottom of the frame
				(multi) right - the distance from the left of the screen to the right of the frame
				(number) toppad - the amount of padding to add to the top of the frame
				(number) leftpad - the amount of padding to add to the left of the frame
				(number) bottompad - the amount of padding to add to the bottom of the frame
				(number) rightpad - the amount of padding to add to the right of the frame	 	 				
	 	 	}
]]--
Eclipse.Lunar.registerForAutohide = function ( reglist )
	--Get a local copy of reglist, so we dont end up altering the origional
	local reglist = Sea.table.copy(reglist);

	--We need at bare minimum the name of a frame to make autohideable
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
		--If checkframes doesn't exist, then make it
		if (not reglist.checkframes) then
			reglist.checkframes = {};
			for index in reglist.frames do
				reglist.checkframes[index] = reglist.frames[index];
			end
		end
		--If checkframes is not a list of frames, then turn it into one
		if ( type(reglist.checkframes) ~= "table" ) then
			reglist.checkframes = { reglist.checkframes };
		elseif (reglist.checkframes.name and reglist.checkframes.min and reglist.checkframes.max) then
			reglist.checkframes = { reglist.checkframes };
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
		
		--Convert any itterated checkframes to their real frame names, and put them in the table
		for index in reglist.checkframes do
			if ( type(reglist.checkframes[index]) == "table" ) then
				local curName = reglist.checkframes[index].name;
				local curMin = reglist.checkframes[index].min;
				local curMax = reglist.checkframes[index].max;
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
							reglist.checkframes[index] = curFrameName;
						else
							table.insert(reglist.checkframes, index + curCount, curFrameName);
						end
						curCount = curCount + 1;
					end
				else
					table.remove(reglist.checkframes, index);
				end
			end
		end
		
		--Convert enabled to 1/0 format
		if ( reglist.enabled and (reglist.enabled == true) ) then
			reglist.enabled = 1;
		else
			reglist.enabled = 0;
		end
		
		--Set time's default
		if (reglist.time == nil) then
			reglist.time = 0;
		end
		if (reglist.time > Eclipse.Lunar.MAXTIME) then
			reglist.time = Eclipse.Lunar.MAXTIME;
		end
		if (reglist.time < 0) then
			reglist.time = 0;
		end
		
		--Add frames to Eclipses list
		for index in reglist.frames do
			Eclipse.SetFrame( {
				name = reglist.frames[index];
				control = true;
				manual = reglist.manual;
				state = reglist.state;
			} )
		end
		--Add checkframes to Eclipses mouse checking list
		for index in reglist.checkframes do
			Eclipse.SetFrame( {
				name = reglist.checkframes[index];
				checkmouse = true;
			} )
		end
		--If we don't have a config for this frame, then make one
		if (not Lunar_Config[reglist.name]) then
			Lunar_Config[reglist.name] = {};
		end
		if (not Lunar_Config[reglist.name].Enabled) then
			Lunar_Config[reglist.name].Enabled = reglist.enabled;
		end
		if (not Lunar_Config[reglist.name].PopTime) then
			Lunar_Config[reglist.name].PopTime = 0;
		end
		
		--Make sure callhow is set
		if (not reglist.callhow) then
			reglist.callhow = Eclipse.Lunar.CALL_INSTEAD;
		end
		
		--Add the frame to the list
		Eclipse.Lunar.Regs[reglist.name] = {};
		Eclipse.Lunar.Regs[reglist.name].frames = reglist.frames;
		Eclipse.Lunar.Regs[reglist.name].checkframes = reglist.checkframes;
		Eclipse.Lunar.Regs[reglist.name].callback = reglist.callback;
		Eclipse.Lunar.Regs[reglist.name].callhow = reglist.callhow;
		
		--Add this frame to Eclipses list
		Eclipse.SetFrame( {
			name = reglist.name;
			checkmouse = true;
			reqs = reglist.reqs;
			manual = reglist.manual;
			state = reglist.state;
			onupdate = reglist.onupdate;
			top = reglist.top;
			left = reglist.left;
			bottom = reglist.bottom;
			right = reglist.right;
			toppad = reglist.toppad;
			leftpad = reglist.leftpad;
			bottompad = reglist.bottompad;
			rightpad = reglist.rightpad;
		} )
		local confVarName = nil;																				--The name of the the UI variable for this frame
		local confVarBool = "Lunar_Config."..reglist.name..".Enabled";	--The name of the boolean variable to update
		local confVarNum = "Lunar_Config."..reglist.name..".PopTime";		--The name of the number variable to update
		
		if (reglist.uiname or reglist.uilabel) then
			--Generate the name for the the UI variable
			confVarName = Eclipse.Lunar.CONFIG_PREFIX..reglist.name;
			
			--If no name was passed for the ui option then make one
			if (not reglist.uiname) then
				reglist.uiname = reglist.slashname;
			end
			if (not reglist.uiname) then
				reglist.uiname = reglist.name;
			end
			--If no label was passed for the ui option then make one
			if (not reglist.uilabel) then
				reglist.uilabel = string.format(LUNAR_CONFIG_LABEL, reglist.uiname);
			end
			--If no ui description was passed, then make one ourselves
			if (not reglist.uidesc) then
				reglist.uidesc = string.format(LUNAR_CONFIG_INFO, reglist.uiname);
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
				reglist.uisep = reglist.uisec..Eclipse.Lunar.CONFIG_PREFIX.."Sep";
			end
			if (not reglist.uiseplabel) then
				reglist.uiseplabel = LUNAR_CONFIG_HEADER;
			end
			if (not reglist.uisepdesc) then
				reglist.uisepdesc = LUNAR_CONFIG_HEADER_INFO;
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
				update = Eclipse.Lunar.SaveConfig;
				uicheck = reglist.enabled;												--The default value for the checkbox in the UI
				uislider = reglist.time;													--The default value for the slider in the UI
				uimin = 0;																				--The minimum value for the slider in the UI
				uimax = Eclipse.Lunar.MAXTIME;										--The maximum value for the slider in the UI
				uitext = LUNAR_CONFIG_SLIDER;											--The text to show above the slider in the UI
				uistep = 0.1;																			--The increment to increase the slider in the UI
				uitexton = 1;																			--Whether to show the exact value of the slider in the UI or not
				uisuffix = LUNAR_CONFIG_SUFFIX;										--The suffix to place after the slider balue
				uimul = 1;																				--What to multiply the actual value of the slider by when showing the value in the UI
			} );
		end
		
		--If a name for a slash command was passed, make a slash command for this frame
		if (reglist.slashcom) then
			--If no slash help was passed, then make one ourselves
			if (not reglist.slashhelp) then
				local slashName = reglist.name;
				if (reglist.uiname) then
					slashName = reglist.uiname;
				end
				reglist.slashhelp = string.format(LUNAR_CHAT_SUBCOMMAND_INFO, slashName);
			end
				
			--Register the super slash command
			MCom.registerSmart( {
				supercom = {"/autohide", "/ahide", "/voah"};				--The main(super) slash command associated with this subommand
				comaction = "before";																--See Sky for info on this
				comsticky = false;																	--See Sky for info on this
				comhelp = LUNAR_CHAT_COMMAND_INFO;									--The help text to show for the slash command
				extrahelp = LUNAR_CHAT_COMMAND_HELP;								--Extra help text to print out
			} );
			--Register the slash command for this frame
			MCom.registerSmart( {
				supercom = {"/autohide", "/ahide"};									--The main(super) slash command associated with this subommand
				subcom = reglist.slashcom;													--The sub slash command and any aliases
				comtype = MCOM_MULTIT;															--The type of subcommand it is
				subhelp = reglist.slashhelp;												--The help text for the sub slash command
				uivar = confVarName;																--The option name for the UI
				varbool = confVarBool;															--The boolean variable that the UI should be updated from, when using the slash command
				varnum = confVarNum;																--The number variable that the UI should be updated from, when using the slash command
				textbool = string.format(LUNAR_CHAT_BOOL, reglist.slashname);
				textnum = string.format(LUNAR_CHAT_NUM, reglist.slashname);
				update = Eclipse.Lunar.SaveConfig;
			} );
		end

		--Store this config for safe load
		MCom.safeLoad("Lunar_Config");
	end
end;
--[[ Alias for registerForAutohide ]]--
Eclipse.Lunar.registerUI = Eclipse.Lunar.registerForAutohide;

--[[
 	toggle (number onOff)
	 	Enables/Disabled the Lunar override.  While the override is on
	 	all frames lunar controls will be shown as normal.
	
	Optional: 
	 	onOff - If not passed, will toggle.  If 1 will enable override.
	 					If anything else, will turn off override.
]]--
Eclipse.Lunar.toggle = function (onOff)
	if (onOff) then
		if (onOff == 1) then
			Lunar_Override = true;
		else
			Lunar_Override = nil;
		end
	else
		if (Lunar_Override) then
			Lunar_Override = nil;
		else
			Lunar_Override = true;
		end
	end
end;

--[[
 	autoHide (string frameName, number doShow, number isEnabled)
	 	Sets a frame/frameset to be autohidden or not, based on doShow and isEnabled.
	 	If Eclipse doesn't control the frame to be hidden/shown, a manual hider/shower
	 	is used.
	
	Args:
	 	frameName - The name of the frame to hide or show.
	 	doShow - 1 if the frame should be shown, 0 if not.
	 	isEnabled - 1 if the frame should be hidden when not shown, 0 if not.
]]--
Eclipse.Lunar.autoHide = function (frameName, doShow, isEnabled)
	--Make sure we have all our info
	if (frameName and doShow and isEnabled) then
		--Check to see if this frame is in Lunar's list, and if not, make sure its a list
		local curFrames = frameName;
		if (Eclipse.Lunar.Regs[frameName] and Eclipse.Lunar.Regs[frameName].frames) then
			curFrames = Eclipse.Lunar.Regs[frameName].frames;
		end
		if (type(curFrames) ~= "table") then
			curFrames = { curFrames };
		end
	
		--Go through all frames in the list
		for index, curFrameName in curFrames do
			--Default hiding to off
			local setHide = 0;
			--If we aren't supposed to show, and this option is enabled, then hide it
			if ( (doShow ~= 1) and (isEnabled == 1) ) then
				setHide = 1;
			end
			--If the frame isnt enabled for autohiding, set to -1 to symbolize this
			if ( ( setHide == 0 ) and ( isEnabled ~= 1 ) ) then
				setHide = -1;
			end
			--Set the autohide parameter for the frame
			if (Eclipse.Frames[curFrameName] and Eclipse.Frames[curFrameName].control) then
				Eclipse.Frames[curFrameName].autohide = setHide;
			else
				--If eclipse doesn't control this frame, then use the manual shower/hider
				Eclipse.Lunar.showHide(curFrameName, doShow, isEnabled);
			end
		end
	end
end;

--[[
 	showHide (string frameName, number doShow, number isEnabled)
	 	Shows or hides a frame, based on doShow and isEnabled.
	 	If the frame is controled by Eclipse, will switch to autoHide to allow Eclipse
	 	to control showing/hiding
	
	Args:
	 	frameName - The name of the frame to hide or show.
	 	doShow - 1 if the frame should be shown, 0 if not.
	 	isEnabled - 1 if the frame should be hidden when not shown, 0 if not.
]]--
Eclipse.Lunar.showHide = function (frameName, doShow, isEnabled)
	--Make sure we have all our info
	if (frameName and doShow and isEnabled) then
		--If the frame is controled by Eclipse, then use autoHide
		if ( Eclipse.Frames[frameName] and (Eclipse.Frames[frameName].control == true) ) then
			Eclipse.Lunar.autoHide(frameName, doShow, isEnabled);
		else
			--Grab the frame to show/hide
			uiFrame = getglobal(frameName);
			--Make sure we got the frame
			if (uiFrame) then
				--Check to see if it is visible, prefer IsShown over IsVisible, if available
				local isShown;
				if (uiFrame.IsShown) then
					isShown = uiFrame:IsShown();
				else
					isShown = uiFrame:IsVisible();
				end
				if (doShow == 1) then
					--If we are supposed to show it, then if it isn't visable, show it
					if (not isShown) then
						uiFrame:Show();
					end
				else
					if (isEnabled == 1) then
						--If we are supposed to hide it, then only do so if the otpion is enabled
						if (isShown) then
							uiFrame:Hide();
						end
					elseif ( (not isShown) and (isEnabled == 0) ) then
						--If the option is not enabled, then show the frame
						uiFrame:Show();
					end
				end
			end
		end
	end
end;

--[[
 	checkUI (string uiName)
	 Checks to see if the mouse is inside any of the frames checked on this frame, then
	 sets whether the frames for this frameset should be shown or hidden.
	
	Args:
	 	uiName - The name of the frame we are checking.
 
	Returns:
	 	true - The mouse is in the area of the frame, and the frame should be showing
	 	false - The mouse is either not in the area of the frame, or hasn't been there for long enough
]]--
Eclipse.Lunar.checkUI = function (uiName)
	--Make sure we have the name of the UI to check, and that it's valid
	if (uiName and Eclipse.Lunar.Regs[uiName] and Lunar_Config[uiName] and Eclipse.Lunar.Regs[uiName].checkframes) then
		--Get whether this option is enabled
		local isEnabled = Lunar_Config[uiName].Enabled;
		--If override is on, then act as if the option is disabled
		if (Lunar_Override) then
			isEnabled = 0;
		end
		--Default to not having the mouse
		local hasMouse = false;
		--Go through all checked frames, and if any have the mouse, then set hasMouse true
		for curFrameName in Eclipse.Lunar.Regs[uiName].checkframes do
			local curFrame = Eclipse.Lunar.Regs[uiName].checkframes[curFrameName];
			if ( Eclipse.HasMouse(curFrame) ) then
				hasMouse = true;
				break;
			end
		end
		--whether the frame should be shown despite not having the mouse
		local forceShow = (Eclipse.Frames[uiName] and (Eclipse.Frames[uiName].forceShow == 1));
			
		--If the mouse is inside the area, then we need to decide whether to show or not
		if (hasMouse or forceShow) then
			local willShow = false;
			if (Chronos) then
				--If we have Chronos, then handle popup delays
				if (Chronos.getTimer(Eclipse.Lunar.CONFIG_PREFIX..uiName) > 0) then
					--If we have a timer going, then check it
					if ( forceShow or (Chronos.getTimer(Eclipse.Lunar.CONFIG_PREFIX..uiName) >= Lunar_Config[uiName].PopTime) ) then
						--If it's time to show the frame then do so
						if ((isEnabled == 1) or (isEnabled == 0)) then
							local checkResult = nil;
							if (Eclipse.Lunar.Regs[uiName].callback and (Eclipse.Lunar.Regs[uiName].callhow == Eclipse.Lunar.CALL_BEFORE)) then
								--If we have a callback to call before, then call it
								checkResult = Eclipse.Lunar.Regs[uiName].callback(uiName, isEnabled, 1);
							end
							if (not checkResult) then
								--If the callback returned true, then dont show/hide the frame
								Eclipse.Lunar.autoHide(uiName, 1, isEnabled);
							end
						end
						return true;
					end
				else
					--If we don't have a timer, then start one
					Chronos.startTimer(Eclipse.Lunar.CONFIG_PREFIX..uiName);
				end
			else
				--We don't have Chronos so we will show the frame now
				willShow = true;
			end
			
			if (willShow) then
				--Show the frame
				if ((isEnabled == 1) or (isEnabled == 0)) then
					local checkResult = nil;
					if (Eclipse.Lunar.Regs[uiName].callback and (Eclipse.Lunar.Regs[uiName].callhow == Eclipse.Lunar.CALL_BEFORE)) then
						--If we have a callback to call before, then call it
						checkResult = Eclipse.Lunar.Regs[uiName].callback(uiName, isEnabled, 1);
					end
					if (not checkResult) then
						--If the callback returned true, then dont show/hide the frame
						Eclipse.Lunar.autoHide(uiName, 1, isEnabled);
					end
				end
				return true;
			end
		else
			--If the mouse is not in the area, then make sure it's not showing
			--End the timer if we have one
			if (Chronos) then
				Chronos.endTimer(Eclipse.Lunar.CONFIG_PREFIX..uiName);
			end
			--Hide the frame if the option is enabled
			local checkResult = nil;
			if (Eclipse.Lunar.Regs[uiName].callback and (Eclipse.Lunar.Regs[uiName].callhow == Eclipse.Lunar.CALL_BEFORE)) then
				--If we have a callback to call before, then call it
				checkResult = Eclipse.Lunar.Regs[uiName].callback(uiName, isEnabled, 0);
			end
			if (not checkResult) then
				--If the callback returned true, then dont show/hide the frame
				Eclipse.Lunar.autoHide(uiName, 0, isEnabled);
			end
			return false;
		end
	end
end;

--[[
 	setUIOnOff (whichUI, onOff, value)
	 	Sets the frame to autohide or not, also sets its delay.
	
	Args:
	 	whichUI - The name of the frame to set

	Optional: 
	 	onOff - Whether to turn the option on or off, 1 or 0
	 	value - How long in seconds to set the delay for
]]--
Eclipse.Lunar.setUIOnOff = function (whichUI, onOff, value)
	--Make sure we know what frame to work with
	if (whichUI) then
		
		if (onOff) then
			--If onOff was passed, then enable/disable autohiding
			MCom.updateVar("Lunar_Config."..whichUI..".Enabled", onOff, MCOM_BOOLT);
		end
		
		if (value) then
			--If value was passed then change the popup delay
			MCom.updateVar("Lunar_Config."..whichUI..".PopTime", value, MCOM_NUMT, 0, Eclipse.Lunar.MAXTIME);
		end
	end
end;

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ Handles updating everything every UPDATETIME seconds ]]--
Eclipse.Lunar.Update = function (elapsed)
	--Update whenever the time that has passed exceeds or hits the update time
	Eclipse.Lunar.LastUpdate = Eclipse.Lunar.LastUpdate + elapsed;
	if (Eclipse.Lunar.LastUpdate >= Eclipse.Lunar.UPDATETIME) then 
		--Reset the timer
		Eclipse.Lunar.LastUpdate = 0;
		
		--Go through all the registered frames, and show/hide them as neccisary
		local xPos, yPos;
		for curUI in Eclipse.Lunar.Regs do
			local callback = Eclipse.Lunar.Regs[curUI].callback;
			local callhow = Eclipse.Lunar.Regs[curUI].callhow;
			local checkResult = nil;
			--If we have a CALL_INSTEAD callback, then call it instead of the normal checkup function
			if (callback and (callhow == Eclipse.Lunar.CALL_INSTEAD)) then
				--If we don't have the mouse position, then get it
				if ((not xPos) and (not yPos)) then
					xPos, yPos = GetCursorPosition();
				end
				--Call the callback
				callback(curUI, Lunar_Config[curUI].Enabled, xPos, yPos);
			else
				--Check the current UI for autohiding
				checkResult = Eclipse.Lunar.checkUI(curUI);
			end
			--If we have a CALL_AFTER callback, then call it now
			if (callback and (callhow == Eclipse.Lunar.CALL_AFTER)) then
				callback(curUI, Lunar_Config[curUI].Enabled, checkResult);
			end
		end
	end
end;

--[[ Saves the current configuration on a per realm/per character basis ]]--
Eclipse.Lunar.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "Lunar_Config";
		storeVar = "Lunar_Storage";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
Eclipse.Lunar.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "Lunar_Config";
		storeVar = "Lunar_Storage";
		nonUIList = {};
	});
end
