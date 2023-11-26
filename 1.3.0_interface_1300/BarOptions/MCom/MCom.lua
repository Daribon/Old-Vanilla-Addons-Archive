--[[
	MCom
	 	A set of utility functions to simplify addon creation
	
	By: Mugendai
	
	MCom provides several functions designed to lower the amount of code
	required to make an addon be configurable.  It helps to handle the
	things that need to go on to handle user input, either via console
	or via some GUI(like Cosmos).
	
	It aims mainly at tasks that are repeated in multiple places in every addon.
	Any addon that wants to have chat commands needs a chat handler, and functions
	for each command it can accept.  It also needs functions for updating
	the variables that have to do with configuration.  Addons may also need
	wrapper functions for a GUI interface.
	
	These things are all handled by MCom either by registering with it for such
	functions, or by calling functions that do the repetative part.
	
	$Id: MCom.lua 1441 2005-05-05 08:41:19Z Sinaloit $
	$Rev: 1441 $
	$LastChangedBy: Sinaloit $
	$Date: 2005-05-05 10:41:19 +0200 (Thu, 05 May 2005) $
]]--

--The MCom library
if (not MCom) then
MCom = {
	--------------------------------------------------
	--
	-- Public Library Functions
	--
	--------------------------------------------------
	--[[
	 	registerSmart ( {reglist} )
		 	A single function that can register a chat command, and a cosmos variable at the same time.
		 	You pass only the data you need to, and it will do anything it can with that data.
		 	If you pass enough data to register a cosmos command and callback, a slash command, a super slash command,
		 	and a sub slash command, this will do all of those things.
		
		Args:
		 	reglist - the table of options, some options will be listed more than once to show when they are needed, but only set them once
		 	 	{
		 	 	Data required to register a cosmos command:
		 	 	 	(string) uivar - the name of the Cosmos variable
		 	 	 	(string) uitype - the type of Cosmos variable
		 	 	 	(string) uilabel - the label of the Cosmos variable
		 	 	 	
		 	 	Optional data for cosmos options:
		 	 		(function) func -	the function to call when this variable changes, see addSlashCommand for further details on the function
		 	 	 										if this is not passed, a generic callback will be provided for you
		 	 	 	(string) varbool - the name of the boolean variable to use in the generic setter
		 	 	 	(string) varnum - the name of the number variable to use in the generic setter
		 	 	 	(function) update - this function will be called when using the generic setter, and the variable is updated
		 	 	 	(function) noupdate - this function will be called when using the generic setter, and the variable is not updated
		 	 	 	
		 	 	 	(string) uidesc - the description of the Cosmos variable
		 	 	 	(number) uicheck - the default value for a checkbox, 1 or 0
		 	 	 	(number) uislider - the default value for a slider
		 	 	 	(number) uimin - the minimum value for a slider
		 	 	 	(number) uimax - the maximum value for a slider
		 	 	 	(string) uitext - the text to show on a Cosmos control
		 	 	 	(number) uistep - the increment to use for a slider
		 	 	 	(number) uitexton - whether to show the text for the control or not, 1 or 0
		 	 	 	(string) uisuffix - the suffix to show at the end of the slider text
		 	 	 	(number) uimul - how much to multiple the slider value by when displaying it
					
				Data required to register a standard slash command:
					(string) command - the name of the slash command Ex: "/command"					
					(string) comtype -	[Required if uitype is not passed, takes precidence over uitype]
															the type of data you are expecting from this slash command
									 						MCOM_BOOLT - Expects boolean data, an on, off, 1, or 0
									 						MCOM_NUMT - Expects a number value
									 						MCOM_MULTIT - Expects a boolean and then a number value, Ex: "/command on 3"
									 						MCOM_STRINGT - Expects any string
									 						MCOM_SIMPLET - No input needed, just calls the function
					
				Optional data for a standard slash command:
					(function) func -	the function to call when this variable changes, see addSlashCommand for further details on the function
		 	 	 										if this is not passed, a generic callback will be provided for you
		 	 	 	(string) varbool - the name of the boolean variable to use in the generic setter
		 	 	 	(string) varnum - the name of the number variable to use in the generic setter
		 	 	 	(number) varmin -	the minimum value the number variable can be set to when using the generic setter
		 	 	 										if not passed, and uimin is passed, uimin will be used
		 	 	 	(number) varmax -	the maximum value the number variable can be set to when using the generic setter
		 	 	 										if not passed, and uimax is passed, uimax will be used
		 	 	 	(function) update - this function will be called when using the generic setter, and the variable is updated
		 	 	 	(function) noupdate - this function will be called when using the generic setter, and the variable is not updated
		 	 	 	(string) textbool -	the string to print for the boolean portion, when not using cosoms, and the variable has been updated in the generic setter
		 	 	 												if this string contains a %s, then it will be replaced with the value its updated to
		 	 	 	(string) textnum -	the string to print for the number portion, when not using cosoms, and the variable has been updated in the generic setter
		 	 	 												if this string contains a %s, then it will be replaced with the value its updated to
		 	 	 	(number) commul - the value to multiply the number by when priting status in the generic setter
					(string) comaction -	The action to perform, see Sky documentation for further details
		 			(number) comsticky -	Whether the command is sticky or not(1 or 0), see Sky documentation for further details
		 			(string) comhelp -	What message to display as help in Sky for this command, see Sky documentation for further details
		 			({string}) extrahelp -	A table of extra help messages to display, each line in the table is a separate line when printed.
					
				Data required to register a super slash command:
					(string) supercom - the name of the super slash command Ex: "/command"
					
				Optional data for a super slash command:
					(string) comaction -	The action to perform, see Sky documentation for further details
		 			(number) comsticky -	Whether the command is sticky or not(1 or 0), see Sky documentation for further details
		 			(string) comhelp -	What message to display as help in Sky for this command, see Sky documentation for further details
		 			({string}) extrahelp -	A table of extra help messages to display, each line in the table is a separate line when printed.
					
				Data required to register a sub slash command:
					(string) supercom - the name of the super slash command to use for this sub slash command Ex: "/command"
					(string) subcom - the name of the sub command, Ex: "command"
					
					(string) comtype -	[Required if uitype is not passed], see above for details
					
				Optional data for a sub command:
					(function) func -	the function to call when this variable changes, see addSlashCommand for further details on the function
		 	 	 										if this is not passed, a generic callback will be provided for you
		 	 	 	(string) varbool - the name of the boolean variable to use in the generic setter
		 	 	 	(string) varnum - the name of the number variable to use in the generic setter
		 	 	 	(number) varmin -	the minimum value the number variable can be set to when using the generic setter
		 	 	 										if not passed, and uimin is passed, uimin will be used
		 	 	 	(number) varmax -	the maximum value the number variable can be set to when using the generic setter
		 	 	 										if not passed, and uimax is passed, uimax will be used
		 	 	 	(function) update - this function will be called when using the generic setter, and the variable is updated
		 	 	 	(function) noupdate - this function will be called when using the generic setter, and the variable is not updated
		 	 	 	(string) textbool -	the string to print for the boolean portion, when not using cosoms, and the variable has been updated in the generic setter
		 	 	 												if this string contains a %s, then it will be replaced with the value its updated to
		 	 	 	(string) textnum -	the string to print for the number portion, when not using cosoms, and the variable has been updated in the generic setter
		 	 	 												if this string contains a %s, then it will be replaced with the value its updated to
		 	 	 	(number) commul - the value to multiply the number by when priting status in the generic setter
					(string) subhelp -	What message to display next to the sub command when listing sub commands in the help output.
					
				Data required for a slash command to update a cosmos variable:
					(string) uivar -	The Cosmos variable that should be updated
					
				Data required for a slash command to update a cosmos variable, if func does not return a value:
		 			(string) varbool -	The variable that the cosmos variable should be set by
		 												This should be a string containing the name of the variable to update, this can include .'s for tables, Ex: "Something.Value"
		 												When type is MULTI, this specifies the bool variable
		 			(string) varnum - The same as comnum, but used to specify the number variable when type is MULTI, only used for MULTI type
		 	 	}
	]]--
	registerSmart = function ( reglist )
		--Make sure reglist is here, and a table
		if (reglist and type(reglist) == "table") then
			--Support for old sytax variables
			if (reglist.comvar) then
				reglist.varbool = reglist.comvar;
			end
			if (reglist.comvarmulti) then
				reglist.varnum = reglist.comvarmulti;
			end
			
			local regtype = nil;
			--If we have uitype, then figure out the MCOM type for it
			if (reglist.uitype) then
				if (reglist.uitype == "CHECKBOX") then
					regtype = MCOM_BOOLT;
				elseif (reglist.uitype == "SLIDER") then
					regtype = MCOM_NUMT;
				elseif (reglist.uitype == "BOTH") then
					regtype = MCOM_MULTIT;
				elseif (reglist.uitype == "BUTTON") then
					regtype = MCOM_SIMPLET;
				end
			end
			--If we have the comtype, use it instead of the uitype
			if (reglist.comtype) then
				regtype = reglist.comtype;
			end
			
			--If no min, max, or mul were provided for the setter, but was provided for the UI, then use the ui values
			if (reglist.uimin and (not reglist.varmin)) then
				reglist.varmin = reglist.uimin;
			end
			if (reglist.uimax and (not reglist.varmax)) then
				reglist.varmax = reglist.uimax;
			end
			if (reglist.uimul and (not reglist.commul)) then
				reglist.commul = reglist.uimul;
			end
			
			--If there was no function passed, then provide our own generic function
			if (not reglist.func) then
				if ((regtype == MCOM_BOOLT) and reglist.varbool) then
					reglist.func =	function (checked)
														if (MCom.updateVar(reglist.varbool, checked, MCOM_BOOLT)) then
															--If there is a function to run on an update, call it
															if (reglist.update and (type(reglist.update) == "function")) then
																reglist.update(reglist.varbool);
															end
															
															if (reglist.textbool) then
																--Print output to let the player know the command succeeded, if there is no Cosmos
																MCom.printStatus(reglist.textbool, checked, true);
															end
														else
															--If there is a function to run on an attempted update, that resulted in no change, then run it
															if (reglist.noupdate and (type(reglist.noupdate) == "function")) then
																reglist.noupdate(reglist.varbool);
															end
														end
													end;
				elseif ((regtype == MCOM_NUMT) and reglist.varnum) then
					reglist.func =	function (value)
														if (MCom.updateVar(reglist.varnum, value, MCOM_NUMT, reglist.varmin, reglist.varmax)) then
															--If there is a function to run on an update, call it
															if (reglist.update and (type(reglist.update) == "function")) then
																reglist.update(reglist.varnum);
															end
															
															if (reglist.textnum) then
																--Print output to let the player know the command succeeded, if there is no Cosmos
																if (value and reglist.commul) then
																	value = value * reglist.commul;
																end
																MCom.printStatus(reglist.textnum, value);
															end
														else
															--If there is a function to run on an attempted update, that resulted in no change, then run it
															if (reglist.noupdate and (type(reglist.noupdate) == "function")) then
																reglist.noupdate(reglist.varnum);
															end
														end
													end;
				elseif ((regtype == MCOM_MULTIT) and reglist.varbool and reglist.varnum) then
					reglist.func =	function (checked, value)
														if (MCom.updateVar(reglist.varbool, checked, MCOM_BOOLT)) then
															--If there is a function to run on an update, call it
															if (reglist.update and (type(reglist.update) == "function")) then
																reglist.update(reglist.varbool);
															end
															
															if (reglist.textbool) then
																--Print output to let the player know the command succeeded, if there is no Cosmos
																MCom.printStatus(reglist.textbool, checked, true);
															end
														else
															--If there is a function to run on an attempted update, that resulted in no change, then run it
															if (reglist.noupdate and (type(reglist.noupdate) == "function")) then
																reglist.noupdate(reglist.varbool);
															end
														end
														
														if (MCom.updateVar(reglist.varnum, value, MCOM_NUMT, reglist.varmin, reglist.varmax)) then
															--If there is a function to run on an update, call it
															if (reglist.update and (type(reglist.update) == "function")) then
																reglist.update(reglist.varnum);
															end
															
															if (reglist.textnum) then
																--Print output to let the player know the command succeeded, if there is no Cosmos
																if (value and reglist.commul) then
																	value = value * reglist.commul;
																end
																MCom.printStatus(reglist.textnum, value);
															end
														else
															--If there is a function to run on an attempted update, that resulted in no change, then run it
															if (reglist.noupdate and (type(reglist.noupdate) == "function")) then
																reglist.noupdate(reglist.varnum);
															end
														end
													end;
				end
			end
		
			if (Cosmos_RegisterConfiguration and reglist.uivar and reglist.uitype and reglist.uilabel ) then
				--Register with Cosmos is available
				Cosmos_RegisterConfiguration(reglist.uivar, reglist.uitype, reglist.uilabel, reglist.uidesc,
					function (checked, value) MCom.SetFromUI(reglist.uivar, checked, value); end,
					reglist.uicheck, reglist.uislider, reglist.uimin, reglist.uimax, reglist.uitext, reglist.uistep, reglist.uitexton, reglist.uisuffix, reglist.uimul
				);
				--Add the function to the list of callback functions
				if (reglist.func and reglist.uitype) then
					--Only do this for UI elements that have options
					if ((reglist.uitype == "CHECKBOX") or (reglist.uitype == "SLIDER") or (reglist.uitype == "BOTH") or (reglist.uitype == "BUTTON")) then
						if (not MCom.UIFuncList) then
							MCom.UIFuncList = {};
						end
						if (not MCom.UIFuncList[reglist.uivar]) then
							MCom.UIFuncList[reglist.uivar] = {};
						end
						MCom.UIFuncList[reglist.uivar].func = reglist.func;
						MCom.UIFuncList[reglist.uivar].uitype = reglist.uitype;
					end
				end
			end

			--If we have enough data to register a slash command, then do it
			if (reglist.command and reglist.func) then
				MCom.addSlashCom(reglist.command, reglist.func, reglist.comaction, reglist.comsticky, reglist.comhelp, regtype, reglist.uivar, reglist.varbool, reglist.varnum, reglist.extrahelp);
			end
			--If we have enough data to register a super slash command, then do it
			if (reglist.supercom) then
				MCom.addSlashSuperCom(reglist.supercom, reglist.comaction, reglist.comsticky, reglist.comhelp, reglist.extrahelp);
			end
			--If we have enough data to register a sub slash command, then do it
			if (reglist.supercom and reglist.subcom and reglist.func) then
				MCom.addSlashSubCom(reglist.supercom, reglist.subcom, reglist.func, reglist.subhelp, regtype, reglist.uivar, reglist.varbool, reglist.varnum);
			end			
		end
	end;
	
	--[[
	 	stringToVar ( string value )
		 	Accepts a variable as a string, and returns the value.
		 	However this can parse complex variable names that contain .
		 	such as "Something.Variable"
		 	
		 	It does not handle "Something['Variable']".. yet.
		
		Args:
		 	varString - the variable to get, encapsulated in a string, ex:
		 	"Something.Variable.Monkey.Hippo"
	 
		Returns:
		 	the contents of the variable in the passed string
	]]--
	stringToVar = function (varString)
		if (varString) then
			--Seperate the variable by the .'s into a list
			local valList = Sea.util.split(varString, ".");
			local endVal;
			--If there this is not a simple variable, parse it, otherwise go ahead and return it
			if (getn(valList) > 1) then
				--Get the first part of the string as a global, we can then work with that
				endVal = getglobal(valList[1]);
				--Go through each part of the list
				for index = 2, getn(valList) do
					--Get the inner variable
					local newVal = valList[index];
					if (newVal) then
						--if the next part is in found then change the part we are looking at to it
						if (endVal[newVal]) then
							endVal = endVal[newVal];
						else
							return;
						end
					else
						return;
					end
				end
			else
				endVal = getglobal(varString);
			end		
			return endVal;
		end
	end;
	
	--[[
	 	setStringVar ( string varString, value )
		 	Sets a variable, specified by a string, to a value.
		 	However this can parse complex variable names that contain .
		 	such as "Something.Variable"
		
		Args:
		 	varString - the variable to set, encapsulated in a string, ex:
		 		"Something.Variable.Monkey.Hippo"
		 	value - the value to set the variable to, can be any type
	]]--
	setStringVar = function (varString, value)
		if (varString and value) then
			--Seperate the variable by the .'s into a list
			local valList = Sea.util.split(varString, ".");
			local curVal;
			--If there this is not a simple variable, parse it, otherwise go ahead and set it
			if (getn(valList) > 1) then
				--Get the first part of the string as a global, we can then work with that
				curVal = getglobal(valList[1]);
				--Go through each part of the list
				for index = 2, getn(valList) do
					--Get the inner variable
					local newVal = valList[index];
					if (newVal) then
						if (curVal[newVal]) then
							if (index == getn(valList)) then
								--if we are at the end of the list, then set the variable
								curVal[newVal] = value;
							else
								--if the next part is in found then change the part we are looking at to it
								curVal = curVal[newVal];
							end
						else
							return;
						end
					else
						return;
					end
				end
			else
				setglobal(varString, value);
			end
		end
	end;
	
	--[[
	 	updateVar ( string varname, value [, string vartype, number varmin, number varmax] )
		 	updates the variable contained in varname, to value.
		 	Handles things different based on the type of var varname is.
		 	If it should be a bool, then it only accepts 1 and 0, or -1 to invert the current setting.
		 	For number, it makes sure it is in the range varmin and varmax.
		
		Args:
		 	varname - name of the variable to update, wrapped in a string, can be complex like "Something.Variable"
		 	value - what to set it to, should be 1, 0, or -1 for bool, any number for number type, or any string for string type
	
		Optional: 
		 	vartype - should be MCOM_BOOLT for bool, MCOM_NUMT for number, or MCOM_STRINGT for string.
		 	varmin - specifies the minimum value for a number type
		 	varmax - specifies the maximum value for a number type
	 
		Returns:
		 	if the value changed from its origional value, returns true
	]]--
	updateVar = function (varname, value, vartype, varmin, varmax)
		if (varname and value) then
			-- store the old value of the variable
			local oldValue = MCom.stringToVar(varname);

			if (vartype == MCOM_BOOLT) then
				--If a -1 is passed, invert the value
				if (value and (value == -1)) then
					if (oldValue == 1) then
						value = 0;
					else
						value = 1;
					end
				end
				
				--Update the value
				if (value and (value==1)) then
					value = 1;
				else
					value = 0;
				end
			elseif (vartype == MCOM_NUMT) then
				--if its a number and max/min were specified, make sure it's in range
				if (varmin and (value < varmin)) then
					value = varmin;
				end
				if (varmax and (value > varmax)) then
					value = varmax;
				end
			end
			
			--if the value changed, return true
			if (value ~= oldValue) then
				MCom.setStringVar(varname, value);
				return true;
			end
		end
	end;

	--[[
	 	printStatus ( string text, [string/number/bool] value, bool isbool )
		 	If Cosmos is not found printStatus will print out a status message, intended to let user know when an option has
		 	been changed, when there is no GUI available.
		
		Args:
		 	text -		the text to print, this can include a %s, and value(or enabled/disabled for bool) will be put in place of the %s
		 						Ex: "This option has been %s" for bool, or "This option has been set to %s" for number or string
	
		Optional: 
			value -		what value to display, can be a string, a number, or a bool
		 	isbool -	if this is true, then the value will be treated as a bool, and if true(or 1) then the %s will contain
		 						the world "Enabled" or "Disabled" for false(or 0)
	]]--
	printStatus = function (text, value, isbool)
		if ( Cosmos_RegisterConfiguration == nil ) then
			--Convert to string
			if (type(value) == "number") then
				tostring(value);
			end
			--If it's boolean or nill convert to 1 or 0
			if ((type(value) == "boolean") or (type(value) == "nil")) then
				if (value) then
					value = "1";
				else
					value = "0";
				end
			end
			if (type(value) == "string") then
				local outText = value;
				--If it's a bool convert to Enabled/Disabled
				if (isbool) then
					outText = MCOM_CHAT_DISABLED;
					if (value == "1") then
						outText = MCOM_CHAT_ENABLED;
					end
				end
				--Format and print the message
				local msg = string.format(text, outText);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], msg);
			end
		end	
	end;
	
	--[[
	 	updateUI ( string slashcom, string subcom )
		 	Updates the UI(Cosmos) with the values of the variable associated with the slash command
		 	passed to the function.  If this is done on a super slash commands, then all sub commands
		 	will be updated, unless a specific on is specified.
		
		Args:
		 	slashcom - The slash commmand, or super slash command to update the variable from.
	
		Optional: 
		 	subcom -	If slashcom is a super slash command, you can use this to specify which slash
		 						command to update.
	]]--
	updateUI = function (slashcom, subcom)
		if (MCom.SlashComs) then
			--Get the command IDs
			local comid, subcomid = MCom.getComID(slashcom, subcom);
			if (comid) then
				--Get the command
				local command = MCom.SlashComs[comid];
				--If we have a subcommand, then lets use it
				if (subcomid) then
					command = command.commands[subcomid];
				elseif (command.commands) then
					command = command.commands;
				end
				
				--If command isnt a table, then turn it into one
				if (type(command) ~= "table") then
					command = { command };
				end
				local didUpdate = nil;
				--We only need to update Cosmos if it exists
				if (Cosmos_RegisterConfiguration) then
					local curCom = nil;
					local newValMulti = nil;
					local newVal = nil;
					--Go trhough all commands and update them
					for curComID in command do
						curCom = command[curComID];
						if (curCom.uivar and curCom.comvar) then
							--get the value of the variable
							newVal = MCom.stringToVar(curCom.comvar);
							if (newVal) then
								newValMulti = MCom.stringToVar(curCom.comvarmulti);
								if ((curCom.comtype ~= MCOM_MULTIT) or ((curCom.comtype == MCOM_MULTIT) and newValMulti)) then
									--if its a boolean, then set the checkbox
									if ((curCom.comtype == MCOM_BOOLT) or (curCom.comtype == MCOM_MULTIT)) then
										Cosmos_UpdateValue(curCom.uivar, CSM_CHECKONOFF, newVal);
										didUpdate = true;
									end
									--if its a number, then set the slider
									if ((curCom.comtype == MCOM_NUMT) or (curCom.comtype == MCOM_MULTIT)) then
										if (curCom.comtype == MCOM_MULTIT) then
											newVal = newValMulti;
										end
										Cosmos_UpdateValue(curCom.uivar, CSM_SLIDERVALUE, newVal);
										didUpdate = true;
									end
								end
							end
						end
					end
					--If we updated something, then update the Cosmos display
					if (didUpdate) then
						CosmosMaster_DrawData();
					end
				end
			end
		end
	end;
	
	
	--[[
	 	getComID ( [string/number] slashcom, string subcom )
		 	Gets the ID of the slashcom in the slash commands list, as well as a
		 	sub slash command, if you specify that you want a sub commands ID.
		
		Args:
		 	slashcom -	The slash commmand, or super slash command to get the ID of.
		 							If you pass the ID itself, that ID will be used when getting
		 							the sub command.  This can be a list of commands, instead of
		 							just one, in which case, it will return the first one in the
		 							list that it finds. Don't forget the / ex. "/command"
		Optional:
		 	slashcom -	The sub command you want to get, if you want one.  This can
		 							be a list instead of just one command, the first one found
		 							will be used.
		 	
		Returns:
			commandid - If it finds the command, it returns the ID, otherwise it returns nil.
			subcommand - If it finds the subcommand it also returns that, otherwise, nil.
	]]--
	getComID = function (command, subcom)
		local commandid = nil;
		local subcommandid = nil;
		if (MCom.SlashComs) then
			--If the ID was passed, then use it
			if ((type(command) == "number") and MCom.SlashComs[command]) then
				commandid = command;
			else
				--make sure command is a table
				if (type(command) ~= "table") then
					command = {command};
				end
				--find the command in the table
				for curCom in command do
					for curListCom in MCom.SlashComs do
						if (MCom.SlashComs[curListCom].basecommand) then
							for curBaseCom in MCom.SlashComs[curListCom].basecommand do
								if (MCom.SlashComs[curListCom].basecommand[curBaseCom] == command[curCom]) then
									commandid = curListCom;
									break;
								end
							end
							if (commandid) then
								break;
							end
						end
					end
				end
			end			
			
			if (commandid and subcom) then
				--make sure sub command is a table
				if (type(subcom) ~= "table") then
					subcom = {subcom};
				end
				--Try and find the subcommand in the list
				for curSub in subcom do
					for curCom in MCom.SlashComs[commandid].commands do
						if (MCom.SlashComs[commandid].commands[curCom].command) then
							for curComCom in MCom.SlashComs[commandid].commands[curCom].command do
								if (MCom.SlashComs[commandid].commands[curCom].command[curComCom] == subcom[curSub]) then
									subcommandid = curCom;
									break;
								end
							end
							if (subcommandid) then
								break;
							end
						end
					end
				end
			end			
		end
		return commandid, subcommandid;
	end;

	--[[
	 	addSlashCom ( [string/{string, ...}] command, function comfunc, string comaction, bool comsticky, string comhelp, string comtype, string uivar, string comvar, string comvarmulti )
		 	Registers a standard slash command.  This will register with Sky, if it exists.
		 	addSlashCom makes its own chat handler function.  The function expects a particular kind of input, specified by comtype.
		 	
		 	For boolean input, it will require that the user pass on, off, 1, or 0, to consider the command valid. It will then call
		 	the function you pass, and will pass a 1, 0, or a -1, standing for True, False, and no input(I suggest you make it invert
		 	the current value in this case).  If Cosmos is loaded, and you have passed uivar and comvar, it will update the cosmos
		 	variable after the function has completed.
		 	
		 	If the slash command is already registered with MCom, nothing will happen.
		
		Args:
		 	command -	The slash command(s) you want to register. Ex: "/command". This can be a string or a table of strings if you
		 						want more than one command.
		 	comfunc -	The function that the should be called when the slash command is used, and valid.  If the function returns a value
		 						that value will be used to update a cosmos variable, if uivar has been passed.  You don't have to return a value
		 						to do this, but if you don't then you need to use comvar, and comvarmulti(for multi type).  For multi type it
		 						should return the bool then the value, like so: "return enabled, value;"
		 						BOOL - function (bool enabled)
		 						NUMBER - function (number value)
		 						MULTI - function (bool enabled, number value)
		 						STRING - function (string value)
		 						SIMPLE - function ()
	
		Optional: 
		 	comaction -	The action to perform, see Sky documentation for further details
		 	comsticky -	Whether the command is sticky or not(1 or 0), see Sky documentation for further details
		 	comhelp -	What message to display as help in Sky for this command, see Sky documentation for further details
		 	comtype -	the type of data you are expecting from this slash command
		 						MCOM_BOOLT - Expects boolean data, an on, off, 1, or 0
		 						MCOM_NUMT - Expects a number value
		 						MCOM_MULTIT - Expects a boolean and then a number value, Ex: "/command on 3"
		 						MCOM_STRINGT - Expects any string
		 						MCOM_SIMPLET - No input needed, just calls the function
		 	extrahelp - A table of extra help messages to display, each line is printed on a seperate line
		 	
		These are required if you want to update a Cosmos variable:
		 	uivar -	The Cosmos variable that should be updated, if you want this slash command to update a cosmos variable
		These are required if you want to update a Cosmos variable, and your function doesn't return the updated value:
		 	comvar -	The variable that the cosmos variable should be set by, if you want this slash command to update a cosmos variable
		 						This should be a string containing the name of the variable to update, this can include .'s for tables, Ex: "Something.Value"
		 						When type is MULTI, this specifies the bool variable
		 	comvarmulti - The same as comvar, but used to specify the number variable when type is MULTI, only used for MULTI type
	]]--
	addSlashCom = function (command, comfunc, comaction, comsticky, comhelp, comtype, uivar, comvar, comvarmulti, extrahelp)
		--We need at bare minimum command, and comfunc
		if (command and comfunc) then
			--If we dont have our chat command list yet, make one
			if (not MCom.SlashComs) then
				MCom.SlashComs = {};
			end
			--make sure command is a table
			if (type(command) ~= "table") then
				command = {command};
			end

			--If the command is not in the list yet, then add it
			if (not MCom.getComID(command)) then
				table.insert(MCom.SlashComs, {});
				local commandid = getn(MCom.SlashComs);
				
				--Set the commands various elements
				MCom.SlashComs[commandid].basecommand = command;
				MCom.SlashComs[commandid].comfunc = comfunc;
				if (comtype) then
					MCom.SlashComs[commandid].comtype = comtype;
				end
				if (uivar) then
					MCom.SlashComs[commandid].uivar = uivar;
				end
				if (comvar) then
					MCom.SlashComs[commandid].comvar = comvar;
				end
				if (comvarmulti) then
					MCom.SlashComs[commandid].comvarmulti = comvarmulti;
				end
				if (extrahelp) then
					MCom.SlashComs[commandid].extrahelp = extrahelp;
				end
				
				--Register the command with Sky, or the default method
				if ( Sky ) then
					Sky.registerSlashCommand(
						{
							id=string.upper(command[1]).."_COMMAND";
							commands = command;
							onExecute = function (msg) MCom.SlashCommandHandler(commandid, msg); end;
							action = comaction;
							sticky = comsticky;
							helpText = comhelp;
						}
					);
				else
					SlashCmdList[string.upper(string.sub(command[1], 2))] = function (msg) MCom.SlashCommandHandler(commandid, msg); end;
					for curCom = 1, getn(command) do
						setglobal("SLASH_"..string.upper(string.sub(command[1], 2))..curCom, command[curCom]);
					end
				end
			end
		end
	end;
	
	--[[
	 	addSlashSuperCom ( [string/{string, ...}] command, string comaction, number comsticky, string comhelp )
		 	This registers a slash command that will have sub commands in it.  See addSlashSubCom for more details on sub commands.
		 	
		 	If the slash command is already registered with MCom, nothing will happen.
		
		Args:
		 	command -	The slash command(s) you want to register. Ex: "/command". This can be a string or a table of strings if you
		 						want more than one command.
	
		Optional: 
		 	comaction -	The action to perform, see Sky documentation for further details
		 	comsticky -	Whether the command is sticky or not(1 or 0), see Sky documentation for further details
		 	comhelp -	What message to display as help in Sky for this command, see Sky documentation for further details
		 	extrahelp - A table of extra help messages to display, each line is printed on a seperate line
	]]--
	addSlashSuperCom = function (command, comaction, comsticky, comhelp, extrahelp)
		--We need at bare minimum command
		if (command) then
			--If we dont have our chat command list yet, make one
			if (not MCom.SlashComs) then
				MCom.SlashComs = {};
			end
			--make sure command is a table
			if (type(command) ~= "table") then
				command = {command};
			end
			
			--If the command is not in the list yet, then add it
			if (not MCom.getComID(command)) then
				table.insert(MCom.SlashComs, {});
				local commandid = getn(MCom.SlashComs);

				MCom.SlashComs[commandid].basecommand = command;
				if (extrahelp) then
					MCom.SlashComs[commandid].extrahelp = extrahelp;
				end
				
				--Register the command with Sky, or the default method
				if ( Sky ) then
					Sky.registerSlashCommand(
						{
							id=string.upper(command[1]).."_COMMAND";
							commands = command;
							onExecute = function (msg) MCom.SlashCommandHandler(commandid, msg); end;
							action = comaction;
							sticky = comsticky;
							helpText = comhelp;
						}
					);
				else
					SlashCmdList[string.upper(string.sub(command[1], 2))] = function (msg) MCom.SlashCommandHandler(commandid, msg); end;
					for curCom = 1, getn(command) do
						setglobal("SLASH_"..string.upper(string.sub(command[1], 2))..curCom, command[curCom]);
					end
				end
			end
		end
	end;
	
	--[[
	 	addSlashSubCom ( [string/{string, ...}] basecommand, [string/{string, ...}] subcommand, function comfunc, string comhelp, string comtype, string uivar, string comvar, string comvarmulti )
		 	This is like addSlashCom, but it registers a sub command to be used with a super command.
		 	A sub command is one that is entered after the super command is entered.
		 	Example:
		 	Normal command: "/modcommand on"
		 	Sub command, with super command of mod: "/mod command on"
		 	
		 	Using super and sub commands allows you to register only one actual real command, which helps to clean up the listing of slash
		 	commands, and helps to prevent using a slash command that may already be there.  It also makes it easier for the user to remember
		 	and use, as if the user simply types the super command by itself they will get a listing of all sub commands, and usage.
		 	
		 	If the slash command is already registered with MCom, nothing will happen.
		
		Args:
		 	basecommand -	The super command that this sub command goes with.  Can be a single command or a list of commands.
		 	subcommand -	The sub command(s) you want to register. Ex: "command". This can be a string or a table of strings if you
		 						want more than one command.
		 	comfunc -	The function that the should be called when the slash command is used, and valid.  If the function returns a value
		 						that value will be used to update a cosmos variable, if uivar has been passed.  You don't have to return a value
		 						to do this, but if you don't then you need to use comvar, and comvarmulti(for multi type).  For multi type it
		 						should return the bool then the value, like so: "return enabled, value;"
		 						BOOL - function (bool enabled)
		 						NUMBER - function (number value)
		 						MULTI - function (bool enabled, number value)
		 						STRING - function (string value)
		 						SIMPLE - function ()
	
		Optional: 
		 	comhelp -	What message to display next to the sub command when listing sub commands in the help output.
		 	comtype -	the type of data you are expecting from this slash command
		 						MCOM_BOOLT - Expects boolean data, an on, off, 1, or 0
		 						MCOM_NUMT - Expects a number value
		 						MCOM_MULTIT - Expects a boolean and then a number value, Ex: "/command on 3"
		 						MCOM_STRINGT - Expects any string
		 						MCOM_SIMPLET - No input needed, just calls the function
		 	
		These are required if you want to update a Cosmos variable:
		 	uivar -	The Cosmos variable that should be updated, if you want this slash command to update a cosmos variable
		These are required if you want to update a Cosmos variable, and your function doesn't return the updated value:
		 	comvar -	The variable that the cosmos variable should be set by, if you want this slash command to update a cosmos variable
		 						This should be a string containing the name of the variable to update, this can include .'s for tables, Ex: "Something.Value"
		 						When type is MULTI, this specifies the bool variable
		 	comvarmulti - The same as comvar, but used to specify the number variable when type is MULTI, only used for MULTI type
	]]--
	addSlashSubCom = function (basecommand, subcommand, comfunc, comhelp, comtype, uivar, comvar, comvarmulti)
		--We need at bare minimum commandid, subcommand, and comfunc
		if (basecommand and subcommand and comfunc) then
			--If we don't have a chat com list, then we shouldn't do anything
			if (MCom.SlashComs) then
				--Make sure basecommand is a table
				if (type(basecommand) ~= "table") then
					basecommand = {basecommand};
				end
				
				--get the ID of the super command, if it is in the list
				local commandid = MCom.getComID(basecommand);		
				
				--no commandid means no nothing
				if (commandid) then
					--If this super command doesn't have a list of sub commands yet, then make one
					if (not MCom.SlashComs[commandid].commands) then
						MCom.SlashComs[commandid].commands = {};
					end
					
					--If the sub command isn't a table turn it to one
					if (type(subcommand) ~= "table") then
						subcommand = {subcommand};
					end
					
					--Try and find the subcommand in the list
					local monkey, subcommandid = MCom.getComID(commandid, subcommand);
					
					--Make sure this sub command doesn't already exist
					if (not subcommandid) then
						--Make the sub command
						table.insert(MCom.SlashComs[commandid].commands, {});
						subcommandid = getn(MCom.SlashComs[commandid].commands);
						
						--Setup the sub commands elements
						MCom.SlashComs[commandid].commands[subcommandid].command = subcommand;
						MCom.SlashComs[commandid].commands[subcommandid].comfunc = comfunc;
						if (comhelp) then
							MCom.SlashComs[commandid].commands[subcommandid].comhelp = comhelp;
						end
						if (comtype) then
							MCom.SlashComs[commandid].commands[subcommandid].comtype = comtype;
						end
						if (uivar) then
							MCom.SlashComs[commandid].commands[subcommandid].uivar = uivar;
						end
						if (comvar) then
							MCom.SlashComs[commandid].commands[subcommandid].comvar = comvar;
						end
						if (comvarmulti) then
							MCom.SlashComs[commandid].commands[subcommandid].comvarmulti = comvarmulti;
						end
					end
				end				
			end
		end
	end;
	
	--------------------------------------------------
	--
	-- Private Library Functions
	--
	--------------------------------------------------
	--[[ The slash command handler used by MCom slash commands ]]--
	SlashCommandHandler = function (commandid, msg)
		--Only works if we have some registered slash commands
		if (MCom.SlashComs and MCom.SlashComs[commandid]) then
			--Get a shorthand for the current command
			curCommand = MCom.SlashComs[commandid];
			--Only proccess the message if there is one
			if (msg) then
				local subcommand, value, value2;
				local isSimple = true;	--Set true if the command is a standard, not super, slash command
				local comType = nil;		--Stores the type of command
				local badCommand = nil;	--Set true if the data for the command turns out bad
				
				if (not curCommand.commands) then
					--This is simple so unpack it to the values
					value, value2 = unpack(Sea.string.split(msg, " "));
				else
					--This is a super command, so unpack the subcommand and values
					isSimple = nil;
					subcommand, value, value2 = unpack(Sea.string.split(msg, " "));
					
					if (subcommand) then
						--Try and find an exact match of the subcommand in the list
						local subcommandid = nil;
						for curCom in MCom.SlashComs[commandid].commands do
							if (MCom.SlashComs[commandid].commands[curCom].command) then
								for curComCom in MCom.SlashComs[commandid].commands[curCom].command do
									if (MCom.SlashComs[commandid].commands[curCom].command[curComCom] == subcommand) then
										subcommandid = curCom;
										break;
									end
								end
								if (subcommandid) then
									break;
								end
							end
						end
						
						if (not subcommandid) then
							--Try and find a similar match of the subcommand in the list
							for curCom in MCom.SlashComs[commandid].commands do
								if (MCom.SlashComs[commandid].commands[curCom].command) then
									for curComCom in MCom.SlashComs[commandid].commands[curCom].command do
										if (string.find(MCom.SlashComs[commandid].commands[curCom].command[curComCom], subcommand)) then
											subcommandid = curCom;
											break;
										end
									end
									if (subcommandid) then
										break;
									end
								end
							end
						end
						
						if (not subcommandid) then
							--We didn't find the sub command, so we've got a bad command
							badCommand = true;
						else
							--We found the sub command so change curCommand to point at it
							curCommand = curCommand.commands[subcommandid];
						end
					else
						--No subcommand passed, so thats a bad command
						badCommand = true;
					end
				end
				--We only want to continue if the command was good
				if (not badCommand) then
					--Get the command type
					if (curCommand.comtype) then
						comType = curCommand.comtype;
					end
					
					local retVal, retVal2;

					if (comType == MCOM_BOOLT) then
						--If it's a boolean then treat it as one
						if (value) then
							value = string.upper(value);
							if (string.find(value, "ON")) then
								value = 1;
							else
								if (string.find(value, "OFF")) then
									value = 0;
								else
									if (string.find(value, "1")) then
										value = 1;
									else
										if (string.find(value, "0")) then
											value = 0;
										else									
											value = nil;
										end
									end
								end
							end
						else
							--If there was no data passed for this boolean, then send -1 to the functions
							value = -1;
						end
						if (value) then
							--Call the function
							retVal = curCommand.comfunc(value);
						else
							--The function has bad data
							badCommand = true;
						end
					elseif (comType == MCOM_NUMT) then
						--It's a number type so parse it as one, making sure it is formated as number data
						if (value) then
							if ((string.find(value, "%-*%d") or string.find(value, "%-*%d.%d+") or string.find(value, ".%d+"))) then
								value = value+0;
							else
								value = nil;
							end
						end
						if (value) then
							--Call the functions
							retVal = curCommand.comfunc(value);
						else
						--The function has bad data
							badCommand = true;
						end
					elseif (comType == MCOM_MULTIT) then
						--We have a multi type, so treat the first part as boolean, and the second part as number
						if (value) then
							value = string.upper(value);
							if (string.find(value, "ON")) then
								value = 1;
							else
								if (string.find(value, "OFF")) then
									value = 0;
								else
									if (string.find(value, "1")) then
										value = 1;
									else
										if (string.find(value, "0")) then
											value = 0;
										else									
											value = nil;
										end
									end
								end
							end
						end
						--Parse the number portion of the data
						if (value2) then
							if ((string.find(value2, "%-*%d") or string.find(value2, "%-*%d.%d+") or string.find(value2, ".%d+"))) then
								value2 = value2+0;
							else
								value2 = nil;
							end
						end
						if (value or value2) then
							--Call the function
							retVal, retVal2 = curCommand.comfunc(value, value2);
						else
							--We got bad data
							badCommand = true;
						end
					elseif (comType == MCOM_STRINGT) then
						--If we have a string type then just pass whatever data we got to the function
						if (value) then
							retVal = curCommand.comfunc(value);
						end
					else
						--It's a simple type, so just call it and quit
						curCommand.comfunc();
						return;
					end
					if (not badCommand) then
						--if Cosmos is around, we need to update it when the variable changes
						if(Cosmos_RegisterConfiguration and (curCommand.comvar or retVal) and curCommand.uivar) then
							--get the value of the variable
							local newVal = MCom.stringToVar(curCommand.comvar);
							if (retVal) then
								newVal = retVal;
							end
							if (newVal) then
								local newValMulti = MCom.stringToVar(curCommand.comvarmulti);
								if (retVal2) then
									newValMulti = retVal2;
								end
								if ((comType ~= MCOM_MULTIT) or ((comType == MCOM_MULTIT) and newValMulti)) then
									--if its a boolean, then set the checkbox
									if ((comType == MCOM_BOOLT) or (comType == MCOM_MULTIT)) then
										Cosmos_UpdateValue(curCommand.uivar, CSM_CHECKONOFF, newVal);
									end
									--if its a number, then set the slider
									if ((comType == MCOM_NUMT) or (comType == MCOM_MULTIT)) then
										if (comType == MCOM_MULTIT) then
											newVal = newValMulti;
										end
										Cosmos_UpdateValue(curCommand.uivar, CSM_SLIDERVALUE, newVal);
									end
								end
							end
						end
						return;
					end
				end
			elseif ((curCommand.comtype) and (curCommand.comtype == MCOM_SIMPLET)) then
				--If the command is a standard simple command, then just execute it
				curCommand.comfunc();
			elseif ((curCommand.comtype) and (curCommand.comtype == MCOM_BOOLT)) then
				--If the command is a bool type and there was nothing passed, then invert it
				curCommand.comfunc(-1);
			end
			
			--If we didn't find any valid commands we print out the help
			MCom.PrintSlashCommandInfo(commandid);
		end
	end;
	
	
	--[[ Prints the help for a chat command	]]--
	PrintSlashCommandInfo = function (commandid)
		local chatLine = ""; --The current line of text to be printed
		local basecommand = MCom.SlashComs[commandid].basecommand[1];

		--Construct a list of the aliases for the command, if any
		local aliasList = "";
		if (getn(MCom.SlashComs[commandid].basecommand) > 1) then
			for curCom = 2, getn(MCom.SlashComs[commandid].basecommand) do
				if (aliasList ~= "") then
					aliasList = aliasList..", ";
				else
					aliasList = basecommand..", ";
				end
				aliasList = aliasList..MCom.SlashComs[commandid].basecommand[curCom];
			end
		end
	
		--Print list of aliases, if there are any
		if (aliasList ~= "") then
			chatLine = string.format(MCOM_CHAT_COMMAND_ALIAS, aliasList);
			Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
		end
		
		local isSimple = true;	--Set true if this command does not have sub commands
		local eSample = nil;		--Set to something if a simple command is found
		local bSample = nil;		--Set to something if a bool command is found
		local nSample = nil;		--Set to something if a num command is found
		local mSample = nil;		--Set to something if a multi command is found
		local sSample = nil;		--Set to something if a string command is found
		
		--If this command has sub commands, then print a list of them
		if (MCom.SlashComs[commandid].commands) then
			Sea.io.printc(ChatTypeInfo["SYSTEM"], MCOM_CHAT_COMMAND_COMMANDS);
			isSimple = nil;	--This is not a simple command, lets remember that
			for curCom = 1, getn(MCom.SlashComs[commandid].commands) do
				local curComType = MCOM_SIMPLET;	--Default our type to simple
				--If a type is specified look it up
				if (MCom.SlashComs[commandid].commands[curCom].comtype) then
					curComType = MCom.SlashComs[commandid].commands[curCom].comtype;
				end
				
				--Store this command as a sample of whatever type it is
				if ((not eSample) and (curComType == MCOM_SIMPLET)) then
					eSample = MCom.SlashComs[commandid].commands[curCom].command[1];
				end
				if ((not bSample) and (curComType == MCOM_BOOLT)) then
					bSample = MCom.SlashComs[commandid].commands[curCom].command[1];
				end
				if ((not nSample) and (curComType == MCOM_NUMT)) then
					nSample = MCom.SlashComs[commandid].commands[curCom].command[1];
				end
				if ((not mSample) and (curComType == MCOM_MULTIT)) then
					mSample = MCom.SlashComs[commandid].commands[curCom].command[1];
				end
				if ((not sSample) and (curComType == MCOM_STRINGT)) then
					sSample = MCom.SlashComs[commandid].commands[curCom].command[1];
				end
				
				--If help was specified look it up
				local curHelp = MCOM_CHAT_COMMAND_NOINFO;
				if (MCom.SlashComs[commandid].commands[curCom].comhelp) then
					curHelp = MCom.SlashComs[commandid].commands[curCom].comhelp;
				end
				
				--If we have aliases for this sub command then make a list
				local comList = MCom.SlashComs[commandid].commands[curCom].command[1];
				if (getn(MCom.SlashComs[commandid].commands[curCom].command) > 1) then
					for curAlias = 2, getn(MCom.SlashComs[commandid].commands[curCom].command) do
						comList = comList.."/"..MCom.SlashComs[commandid].commands[curCom].command[curAlias];
					end
				end
	
				--Print out the command info
				chatLine = string.format(MCOM_CHAT_COMMAND_SUBCOMMAND, comList, curComType, curHelp);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
		else
			--This is a simple command, find out what type it is, and set the correct sample
			if (MCom.SlashComs[commandid].comtype == MCOM_BOOLT) then
				bSample = true;
			elseif (MCom.SlashComs[commandid].comtype == MCOM_NUMT) then
				nSample = true;
			elseif (MCom.SlashComs[commandid].comtype == MCOM_MULTIT) then
				mSample = true;
			elseif (MCom.SlashComs[commandid].comtype == MCOM_STRINGT) then
				sSample = true;
			else
				eSample = true;
			end
		end	
		
		--Print basic usage info
		Sea.io.printc(ChatTypeInfo["SYSTEM"], MCOM_CHAT_COMMAND_USAGE);
		
		--Print detailed usage info
		if (isSimple) then
			--If its simple we print the simple versions of the usage info, but only for the command type
			if (eSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_S_E, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (bSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_S_B, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (nSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_S_N, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (mSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_S_M, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (sSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_S_S, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
		else
			--If its not simple then we print usage info for any type of subcommand used
			if (eSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_E, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (bSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_B, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (nSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_N, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (mSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_M, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (sSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_USAGE_S, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
		end
		
		--Print extra help for the command
		if (MCom.SlashComs[commandid].extrahelp) then
			if (type(MCom.SlashComs[commandid].extrahelp) ~= "table") then
				MCom.SlashComs[commandid].extrahelp = { MCom.SlashComs[commandid].extrahelp };
			end
			for curHelp in MCom.SlashComs[commandid].extrahelp do
				Sea.io.printc(ChatTypeInfo["SYSTEM"], MCom.SlashComs[commandid].extrahelp[curHelp]);
			end
		end
		
		--Print example usage
		Sea.io.printc(ChatTypeInfo["SYSTEM"], MCOM_CHAT_COMMAND_EXAMPLE);
		if (isSimple) then
			--If it's simple we print an example for the appropriate type
			if (eSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_S_E, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (bSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_S_B, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (nSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_S_N, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (mSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_S_M, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (sSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_S_S, basecommand);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
		else
			--If it's not simple we print an example for each type used
			if (eSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_E, basecommand, eSample);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (bSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_B, basecommand, bSample);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (nSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_N, basecommand, nSample);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (mSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_M, basecommand, mSample);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
			if (sSample) then
				chatLine = string.format(MCOM_CHAT_COMMAND_EXAMPLE_S, basecommand, sSample);
				Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
			end
		end
	end;
	
	--[[ The Cosmos callback function handler ]]--
	SetFromUI = function (option, checked, value)
		if (not MCom.UIFuncList) then
			MCom.UIFuncList = {};
		end
		
		--Get the info for this function
		local funcInfo = MCom.UIFuncList[option];
		if (funcInfo) then
			local func = funcInfo.func;
			local funcType = funcInfo.uitype;
			--Call the appropriate kind of function for this kind of element
			if (func and funcType) then
				if (funcType == "CHECKBOX") then
					func(checked);
				elseif (funcType == "SLIDER") then
					func(value);
				elseif (funcType == "BOTH") then
					func(checked, value);
				else
					func();
				end
			end
		end
	end;
	
};
end