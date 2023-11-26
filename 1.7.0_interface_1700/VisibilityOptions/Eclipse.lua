--[[
	Visibility Options(aka Eclipse)
	 	Allows you to autohide, hide, and set the transparency of frames.
	
	By: Mugendai
	Contact: mugekun@gmail.com
	
	Visibility Options, also known as Eclipse, allows users the ability to hide frames, autohide
	frames that don't have the mouse over them, and to change the transparency of frames.  It
	consists of four parts, the main addon, Eclipse, and three libraries:
	Lunar: Handles autohiding
	Solar: Handles transparency
	Total: Handles persistant hiding
	
	Each of the three libraries have a function that allows a developer to register a frame that
	they want to be autohidden, hidden on transpertized.  Simply calling one of these functions
	with the appropriate parameters will add both a GUI and a slash command based configuration
	option for the frame.
	
	Look into each library for full information on its usage.
	
	VisibilityOptions is a rather complex system so let me try to give you a run down of how things
	work.  First of all the system needs to periodically check that the registered frames meet the
	setting that have been passed.  This is because other frames throught the UI may hide, show or
	adjust the transparency of items, so that they are no longer what the VO requested settings are.
	
	The main part of the Addon, Eclipse, handles this funcionality by maintaining a list of all
	frames that need to be hidden/shown, and transparentized.  It checks each frame periodically to
	ensure that the settings are met.
	
	Because Eclipse has no way of knowing if a frame that it has hidden should be showing or not,
	it allows frames to be setup with a list of requirements that can determine how it should
	noramally behave.	
	(Ex. if the pet bar has been hidden, then if hiding of the bar is disabled, it should be shown,
	but	only if the player has a pet.  In this case Eclipse needs to know that if the player has no
	pet	it should not show the bar)
	
	Eclipse also keeps up with whether or not the mouse is hovering of a frame(if needed).  This
	can be somewhat complicated as well.  There is no way to simply ask each frame politely if the
	mouse is in the area above it, especially when the frame is hidden.  So Eclipse needs to know
	the dimensions of each frame it checks, which it typically takes from the actaul dimensions of
	the checked frame.  However, it's not this simple for all frames, as an example the Buffs frame
	is not actually one single frame, it's actually some 24 buttons.  In this case we need to check
	the area starting at the top left of the top left button, and bottom right of the bottom right
	button.  Eclipse provides several methods of specifying the dimensions of a frame.  Including
	manually choose the sides of the frame, setting padding to be added to the sides of the frames,
	choosing a frame to use to determine each side of the frame, passing a variable to check for
	the sides, and passing a function to use to determine the side.
	
	To give Eclipse the info it needs to appropriately handle a frame you should call the SetFrame
	function, see it's comments for further details.
	
	Each update cycle, Eclipse first checks the requirements for all frames, then it checks all
	frames for the mouse(ones that don't meet requirements are considered to not have the mouse)
	then it calls Lunar's update function to let Lunar deal with autohiding,  finally it runs
	its own function to handle the actual updating of hiding/showing and transparency fo frames.
	
	$Id: Eclipse.lua 2177 2005-07-28 01:26:55Z mugendai $
	$Rev: 2177 $
	$LastChangedBy: mugendai $
	$Date: 2005-07-27 20:26:55 -0500 (Wed, 27 Jul 2005) $
]]--

--------------------------------------------------
--
-- Eclipse Declaration
--
--------------------------------------------------
Eclipse = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	VERSION = 1.45;
	UPDATETIME = 0.1;								--How long between updates
	
	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	LastUpdate = 0;		--How long it has been since the last update
	Frames = {};	--The list of frames that Eclipse keeps control of.
};

--------------------------------------------------
--
-- Public Functions
--
--------------------------------------------------
--[[
	SetFrame ( {reglist} )
		Adds or updates a frame for Eclipse to keep track of.  If you need to specify a frame
		to have a special area, or requirements, use this function.
	
	Args:
		reglist - the table of options
	 	 	{
	 	 	Data required to register or update a frame:
	 	 		(string) name -	the name of the frame to register, or update.  This can be a made up
	 	 										name if you wish to track a virtual frame, usefull for tracking the
	 	 										mouse in custom areas.
	 	 	
	 	 	Optional data:
	 	 		(boolean) control - if true, Eclipse should control showing/hiding of this frame
	 	 		(boolean) controltrans - if true, Eclipse should control the transparency of this frame
				(number) trans - the level of opacity for this frame
	 	 		(boolean) checkmouse -	if true, then Eclipse should check this frame to see if the mouse
																is hovering over it.
	 	 		(table) reqs -	A table of requirements that must be met for the frame to be considered
	 	 										as having the mouse.  Also you can force a frame to hide or show if the
	 	 										requirements are not, or are met(respectively).
	 	 										If there is only one requirement, you do not have to encapsulate it in
	 	 										a table.
					{
						(table)	- each requirement is a table of this form.  var and val must be passed for
											each requirement, but hide and show are optional.
							{
								-required-
								(string or function) var -	the name of the variable to check or this can be a
																						function, or the name of a function instead.
								(any) val -	the value that var must be equal to for the requirement to be
														considered met.
								-optional-
								(bool) hide - if true, then if this requirement is not met, the frame will be hidden.
								(bool) show -	if true, then if this requirement is met, then the frame will be shown,
															but only if all other requirements are met.  Failing a show requirement
															does not cause the full requirements check to fail, it simply doens't
															force the frame to show.
							}
					}
				(boolean) manual -	If this is true, then Eclipse takes complete control over the hide/showing
														of the frame, and will show ignore the normal state of the frame all
														together.  I.E. if something tries to hide the frame, it will not hide,
														instead it will only hide if VO decides it should.
				(boolean) manualtrans -	If this is true, then Eclipse takes complete control over the
																transparency of the frame, and will ignore what other things try to do
																to the transparency.  The frames transparency will be exactly as it is
																set in VO.
				(table)	state	-	Allows you to set the initial state of the hidden/transparency of the frames
												true setting.  Useful if the item is actually shown, but not showing at time
												of reg, such as if it's parent is hidden.
					{
						Optional:
							(boolean) show - Set to true, if the frame is showing
							(number) trans - Set to the alpha transparency of the frame
					}
				(function) onupdate -	When a frame is hidden it will not receive OnUpdate events.  Some frames
															need to receive these events even while hidden, if this is the cast for
															your frame, then set onupdate to your frames OnUpdate function, and it
															will be called while the frame is hidden.
																
			These options will allow you to specify the area tested against the mouse position.
			Each option can be one of these:
				An exact value, indicating distance from the bottom left of the screen in pixels.
				A string containing the name of a variable with the exact value.
				A function whose return value will be used.
				Or a frame to get the position of the side from.
				
				(multi) top - the distance from the bottom of the screen to the top of the frame
				(multi) left - the distance from the left of the screen to the left of the frame
				(multi) bottom - the distance from the bottom of the screen to the bottom of the frame
				(multi) right - the distance from the left of the screen to the right of the frame
				
			Frame Padding Specifiers:
				These options allow you to specify and amount of additional space to be added to the
				ends of the frame area.  Allowing you to incrase/decrease the area the mouse can go
				into to trigger the showing of the frame.
				
				(number) toppad - the amount of padding to add to the top of the frame
				(number) leftpad - the amount of padding to add to the left of the frame
				(number) bottompad - the amount of padding to add to the bottom of the frame
				(number) rightpad - the amount of padding to add to the right of the frame
	 	 	}
	Note:
		If you wish to make any particular frame behave as normal despite all of what Eclipse does,
		then simply set the override option on the frame to 1, like so:
		Eclipse.Frames["frameName"].override = 1;
		Set it back to 0, to return it to normal Eclipse controlled behavior
]]--
Eclipse.SetFrame = function ( reglist )
	--Make sure reglist is properly formatted
	if (reglist and ( type(reglist) == "table" ) and reglist.name and (reglist.name ~= "") ) then
		--If this frame isn't already in the table, then initialize it
		if ( not Eclipse.Frames[reglist.name] ) then
			Eclipse.Frames[reglist.name] = {
				autohide = -1;		--If 1 will cause the frame to hide
				forceShow = 0;		--If 1 will cause the frame to show, despite autohide
				wantHide = 0;			--If 1 will cause the frame to hide, despite forceShow and autohide
				override = 0;			--If 1 will cause the frame to show, despite wantHide, forceShow, and autohide
				forceHide = 0;		--If 1 will cause the frame to show, despite all others
				hasMouse = 0;			--If 1 the frame is considered as having the mouse
				reqsmet = 1;			--If 1 then all requirements were met
				isShown = true;		--Will be set true when the frame is showing
				state = {					--Keeps up with the internal show/hide and transparancy state
									show = true;
									trans = 1;
								};
			};

			--Hook the frames show/hide/trans events
			local regFrame = getglobal(reglist.name);
			if (regFrame) then
				if ( regFrame.Show and regFrame.Hide ) then
					Eclipse.Frames[reglist.name].state.show = regFrame:IsVisible();
					MCom.util.hook(reglist.name..".Show", "Eclipse.ShowHook", "hide");
					MCom.util.hook(reglist.name..".Hide", "Eclipse.HideHook", "hide");
				end
				if ( regFrame.SetAlpha ) then
					Eclipse.Frames[reglist.name].state.trans = regFrame:GetAlpha();
					MCom.util.hook(reglist.name..".SetAlpha", "Eclipse.SetAlphaHook", "hide");
					MCom.util.hook(reglist.name..".SetAlpha", "Eclipse.SetAlphaHookReplace", "replace");
				end
			end

			--If defult state has been set for this frame, then use it
			if ( type(reglist.state) == "table" ) then
				if (reglist.state.show ~= nil) then
					Eclipse.Frames[reglist.name].state.show = reglist.state.show;
				end
				if (reglist.state.trans ~= nil) then
					Eclipse.Frames[reglist.name].state.trans = reglist.state.trans;
				end
			end
		end
		
		--Set any data passed into the frame, but don't set anything nil
		if (reglist.control) then
			Eclipse.Frames[reglist.name].control = reglist.control;
		end
		if (reglist.controltrans) then
			Eclipse.Frames[reglist.name].controltrans = reglist.controltrans;
		end
		if (reglist.trans) then
			Eclipse.Frames[reglist.name].trans = reglist.trans;
		end
		if (reglist.checkmouse) then
			Eclipse.Frames[reglist.name].checkmouse = reglist.checkmouse;
		end
		if (reglist.reqs) then
			Eclipse.Frames[reglist.name].reqs = reglist.reqs;
		end
		if (reglist.manual) then
			Eclipse.Frames[reglist.name].manual = reglist.manual;
		end
		if (reglist.manualtrans) then
			Eclipse.Frames[reglist.name].manualtrans = reglist.manualtrans;
		end
		if (reglist.onupdate) then
			Eclipse.Frames[reglist.name].onupdate = reglist.onupdate;
		end
		if (reglist.top) then
			Eclipse.Frames[reglist.name].top = reglist.top;
		end
		if (reglist.left) then
			Eclipse.Frames[reglist.name].left = reglist.left;
		end
		if (reglist.bottom) then
			Eclipse.Frames[reglist.name].bottom = reglist.bottom;
		end
		if (reglist.right) then
			Eclipse.Frames[reglist.name].right = reglist.right;
		end
		if (reglist.toppad) then
			Eclipse.Frames[reglist.name].toppad = reglist.toppad;
		end
		if (reglist.leftpad) then
			Eclipse.Frames[reglist.name].leftpad = reglist.leftpad;
		end
		if (reglist.bottompad) then
			Eclipse.Frames[reglist.name].bottompad = reglist.bottompad;
		end
		if (reglist.rightpad) then
			Eclipse.Frames[reglist.name].rightpad = reglist.rightpad;
		end
	end
end;

--[[
	registerForVisibility ( {reglist} )
		This is a wrapper function that registers a frame with all three of the parts of Eclipse.
		
	Args:
	 	reglist - the table of options
	 	 	{
	 	 	Required:
	 	 		(string) name -	The name of the frame to register, see each of the three parts for
	 	 										further details.
	 	 	Optional:
	 	 		(bool) nototal - If this is true, then the frame will not be registered with total
	 	 		(bool) nolunar - If this is true, then the frame will not be registered with lunar
	 	 		(bool) nosolar - If this is true, then the frame will not be registered with solar
	 	 	
	 	 	Other Required and Optional Data:
	 	 		You need to look at the registration functions for Total, Lunar, and Solar, for a
	 	 		complete explaination on all the arguments needed to register with each of the
	 	 		three parts.
	 	 		
	 	 		See:
		 	 		Eclipse.Total.registerUI
		 	 			and
		 	 		Eclipse.Lunar.registerUI
		 	 			and
		 	 		Eclipse.Solar.registerUI
		
]]--
Eclipse.registerForVisibility = function ( reglist )
	if (reglist.name) then
		if (not reglist.nototal) then
			Eclipse.Total.registerUI( reglist );
		end
		if (not reglist.nolunar) then
			Eclipse.Lunar.registerUI( reglist );
		end
		if (not reglist.nosolar) then
			Eclipse.Solar.registerUI( reglist );
		end
	end
end
--[[ Alias for registerForVisibility ]]--
Eclipse.registerUI = Eclipse.registerForVisibility;

--[[
	HasMouse (string frameName)
		Returns true if frameName ha the mouse over it.  If the frames requirements were not met
		then this will return false.  All frames have already been checked for the mouse on an
		interval, this function simply checks the results of those previous checks, so it doesn't
		consume many resources.
		
	Args:
		(string) frameName - the name of the frame to check for the mouse on
		
	Returns:
		true - the mouse is hovering over the frame, and reqs were met
		false - the mouse is not over the frame, or reqs were not met
]]--
Eclipse.HasMouse = function (frameName)
	--If we have the frame in our list, and it has the mouse, then return true, otherwise false
	if ( frameName and Eclipse.Frames[frameName] and (Eclipse.Frames[frameName].hasMouse == 1) ) then
		return true;
	else
		return false;
	end
end;

--[[
	This is a wrapper function to support backwards compatability with PopNUI.
	If you are an addon developer, and are using the PopNUI, register, then
	please update your mod to directly use "Eclipse.Lunar.registerForAutohide".
	This function is deprecated, and will eventually be removed.
]]--
if (not ( PopNUI_OnLoad or TransNUI_OnLoad ) ) then
	function PopNUI_RegisterUI(whichUI, chatComm, callback, confName, confDesc)
		if (whichUI) then
			local complainUI = whichUI;
			if (this:GetName()) then
				complainUI = this:GetName();
			end
			if (not Eclipse.OldChecks) then
				Eclipse.OldChecks = {};
			end
			if (not Eclipse.OldChecks[complainUI]) then
				Eclipse.OldChecks[complainUI] = true;
				if (ChatTypeInfo["SYSTEM"]) then
					Sea.io.printc(ChatTypeInfo["SYSTEM"], "Warning: "..complainUI.." is using old PopNUI_Register with VisibilityOptions, please ask the author to update their code.");
				end
			end
			local req = nil;
			--If callback isn't a callback function, then we need to modify it.
			if (callback) then
				if (type(callback) == "table") then
					if (type(callback[1]) == "table") then
					--If we have a table of reqs, then change each one to match the new format
						for curCall in callback do
							callback[curCall] = { var = callback[curCall][1]; val = callback[curCall][2]; hide = callback[curCall][3]; };
						end
					else
						--We have just one req, so change it to match the new format
						callback = { { var = callback[1]; val = callback[2]; hide = callback[3]; } };
					end
					req = callback;
					--We don't have an actual callback, so make callback nil
					callback = nil;
				end;
			end
			--Register the frame
			Eclipse.Lunar.registerForAutohide( {
				name = whichUI;
				slashcom = chatComm;
				reqs = req;
				manual = true;
				callback = callback;
				uilabel = confName;
				uidesc = confDesc;
			} );
			--If a callback was passed, then Eclipse shouldn't be controlling the frame,
			--as most old style callbacks manually controlled the frame.
			if (callback) then
				if (Eclipse.Frames[whichUI]) then
					Eclipse.Frames[whichUI].control = nil;
				end
			end
		end
	end
	
	--[[
		This is a wrapper function to support backwards compatability to PopNUI,
		however, this should not be used, please update to modern code.
	]]--
	function PopNUI_CheckUI(whichUI)
		if (whichUI) then
			if (not Eclipse.OldChecks) then
				Eclipse.OldChecks = {};
			end
			if (not Eclipse.OldChecks[whichUI]) then
				Eclipse.OldChecks[whichUI] = true;
				if (ChatTypeInfo["SYSTEM"]) then
					Sea.io.printc(ChatTypeInfo["SYSTEM"], "Warning: "..whichUI.." is using old PopNUI_CheckUI with VisibilityOptions, please ask the author to update their code.");
				end
			end
			Eclipse.Lunar.checkUI(whichUI);
		end
	end

	--[[
		This is a wrapper function to support backwards compatability with TransNUI.
		If you are an addon developer, and are using the TransNUI, register, then
		please update your mod to directly use "Eclipse.Solar.registerForTransparency".
		This function is deprecated, and will eventually be removed.
	]]--
	function TransNUI_RegisterUI(whichUI, chatComm, confName, confDesc, confMin)
		if (whichUI) then
			local complainUI = whichUI;
			if (this:GetName()) then
				complainUI = this:GetName();
			end
			if (not Eclipse.OldChecks) then
				Eclipse.OldChecks = {};
			end
			if (not Eclipse.OldChecks[complainUI]) then
				Eclipse.OldChecks[complainUI] = true;
				if (ChatTypeInfo["SYSTEM"]) then
					Sea.io.printc(ChatTypeInfo["SYSTEM"], "Warning: "..complainUI.." is using old TransNUI_Register with VisibilityOptions, please ask the author to update their code.");
				end
			end
			local req = nil;
			--Register the frame
			Eclipse.Solar.registerForTransparency( {
				name = whichUI;
				slashcom = chatComm;
				reqs = req;
				manualtrans = true;
				uilabel = confName;
				uidesc = confDesc;
				min = confMin;
			} );
		end
	end
end

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ 
	Checks an individual requirement, and returns data to show
	how the results should be handled.
	
	Returns:
	 	failed
	 		true - the requirement was not met
	 		failed - the requirement was met, or was a show type
	 	forceHide
	 		true - the frame should be hidden because it failed a hide requirement
	 		forceHide - the hide requirement was met, or this wasn't a hide requirement
	 	forceShow
	 		true - the frame should be shown if all reqs are met
	 		forceShow - the show requirement was not met, or this wasn't a show requirement
]]--
Eclipse.CheckReq = function (req, failed, forceHide, forceShow)
	--Get the variable for this requirement
	local reqVar = req.var;
	--If it is a string then turn it to a function
	if (type(req.var) == "string") then
		reqVar = MCom.getStringVar(req.var);
	end
	local reqVal = nil;	--The value of the passed var
	--If our requirement variable is a function then call it and get the value returned
	if (type(reqVar) == "function") then
		reqVal = reqVar();
	else
		reqVal = reqVar;
	end
	
	--Get the value that the variable must be
	local curVal = req.val;
	--If our required value is a function then call it and get the value returned
	if (type(curVal) == "function") then
		curVal = curVal();
	end
	--If the two don't match, then handle as a failed requirement
	if (reqVal ~= curVal) then
		--Only set as failed, if this isn't a show type requirement
		if (not req.show) then
			failed = true;
		end		
		--If this is a hide requirement, then set that the frame should hide
		if (req.hide) then
			forceHide = true;
		end
	elseif (req.show) then
		--If it does match, and this is a show style requirement, then set that we should show
		forceShow = true;
	end

	return failed, forceHide, forceShow;
end;

--[[
	Checks an individual frame for all of it's requirements and updates the frame data
	to reflect whether it passed the requirements or not, and if the frame should be
	force hidden or shown if needed.
]]--
Eclipse.CheckFrameForReqs = function (frameName)
	--Make sure we have this frame in our list
	if ( frameName and Eclipse.Frames[frameName] ) then
		--Get the list of requirements if there is one
		local reqList = nil;
		if (Eclipse.Frames[frameName] and Eclipse.Frames[frameName].reqs) then
			reqList = Eclipse.Frames[frameName].reqs;
		end
		
		local failed = false;	--If any of the requirements fail, this wil be true
		local forceHide = false;	--If this comes up true, then a hide req failed, and the frame will need to be hidden
		local forceShow = false; --If this comes up true, then a show req succeeded, and if all reqs are met, we should show the frame
		--Make sure we have a requirements list that is a table
		if (reqList and (type(reqList) == "table")) then
			--If this isn't a table of requirements(IE, it's just one requirement), then turn it into one
			if ((not reqList[1]) or (reqList[1] and (type(reqList[1]) ~= "table"))) then
				reqList = { reqList };
				Eclipse.Frames[frameName].reqs = reqList;
			end
			--Check all the requirements
			for k in reqList do
				--Make sure we have a table for this requirement
				if (type(reqList[k]) == "table") then
					--check the requirement
					failed, forceHide, forceShow = Eclipse.CheckReq(reqList[k], failed, forceHide, forceShow);
				end
			end
		end
		
		--Set default states on the frame
		Eclipse.Frames[frameName].reqsmet = 1;
		Eclipse.Frames[frameName].forceHide = 0;
		Eclipse.Frames[frameName].forceShow = 0;
		if ( failed == true ) then
			--If we failed any reqs, set reqsmet to 0
			Eclipse.Frames[frameName].reqsmet = 0;
			--If we have a force hide, then set forceHide to 1
			if ( forceHide == true ) then
				Eclipse.Frames[frameName].forceHide = 1;
			end
		else
			--We didn't fail any, so if we have a forceShow, set forceShow to 1
			if ( forceShow == true ) then
				Eclipse.Frames[frameName].forceShow = 1;
			end
		end
	end
end

--[[ Checks all frames for requirements, and updates their variables ]]--
Eclipse.CheckFramesForReqs = function ()
	--Go through all the frames
	for frameName in Eclipse.Frames do
		--Only proccess frame that have requirements
		if ( Eclipse.Frames[frameName].reqs ) then
			Eclipse.CheckFrameForReqs(frameName);
		else
			--Ones that have no reqs, should be treated as if their reqs were met
			Eclipse.Frames[frameName].reqsmet = 1;
		end
	end
end

--[[
	Retreives the position of a side from an actual frame
	
	Returns:
		value - the position of the specified side for the frame
]]--
Eclipse.GetSide = function (uiFrame, side)
	local value = 0;
	--Make sure we have the frame to check
	if (uiFrame and (type(uiFrame) == "table") and uiFrame[0] and (type(uiFrame[0]) == "userdata")) then
		--Get the appropriate side
		if (side == "left") then
			value = uiFrame:GetLeft();
		end
		if (side == "right") then
			value = uiFrame:GetRight();
		end
		if (side == "top") then
			value = uiFrame:GetTop();
		end
		if (side == "bottom") then
			value = uiFrame:GetBottom();
		end
	end
	return value;
end

--[[
	Gets the position of the side of a frame thats registered with Eclipse
	
	Returns:
		value - the position of the side specified for this frame
]]--
Eclipse.GetFrameSide = function (frameName, uiFrame, side, scale)
	local value = nil;
	--Make sure we have all data
	if (frameName and side and scale) then
		--If this frame has this side specified, then get the side from it
		local usePos = Eclipse.Frames[frameName][side];
		if ((type(usePos) == "table") and usePos[0] and (type(usePos[0]) == "userdata")) then
			--If it's a frame, then get the side of the frame
			usePos = Eclipse.GetSide(usePos, side);
		elseif (type(usePos) == "function") then
			--If it's a function, then call the function and get the result
			usePos = usePos();
		elseif (type(usePos) == "string") then
			--If it's a string, then convert it to a variable
			usePos = MCom.getStringVar(usePos);
		end
		if (type(usePos) ~= "number") then
			--If it isn't a number, then get the side from the frame itself
			if (uiFrame) then
				usePos = Eclipse.GetSide(uiFrame, side);
			end
		end
		--If there was any padding specified then get it
		local padding = Eclipse.Frames[frameName][side.."pad"];
		if (not padding) then
			padding = 0;
		end
		--Calculate the position
		if (usePos and padding) then
			value = (usePos + padding) * scale;
		end
	end
	return value;
end;

--[[
	Checks an individual frame to see if the mouse is hovering over it
	
	Returns:
		true - the mouse was hovering a frame whose reqs were met
		false - the mouse was not hovering a frame, or the reqs weren't met
]]--
Eclipse.CheckFrameForMouse = function (frameName, xPos, yPos)
	if (frameName) then
		--If we don't have the cursor position, then get it
		if ((not xPos) and (not yPos)) then
			xPos, yPos = GetCursorPosition();
		end
		
		--Get the frame and declare the variables to handle the frame area
		local uiFrame = getglobal(frameName);
		local left = nil;
		local right = nil;
		local top = nil;
		local bottom = nil;
		local scale = nil;
		--Make sure we have the frame to work with
		if (uiFrame) then
			--Get the scale for the frame, so we can properly test it
			scale = uiFrame:GetScale();
		end
		--If we didn't get a scale, use the default 1-1
		if (not scale) then
			scale = 1;
		end

		--Get the position of the four sides
		left = Eclipse.GetFrameSide(frameName, uiFrame, "left", scale);
		right = Eclipse.GetFrameSide(frameName, uiFrame, "right", scale);
		top = Eclipse.GetFrameSide(frameName, uiFrame, "top", scale);
		bottom = Eclipse.GetFrameSide(frameName, uiFrame, "bottom", scale);
		
		--Make sure we have everything we need
		if (xPos and yPos and left and right and top and bottom) then
			--If the mouse is in the right area, then return true
			if ((xPos >= left) and (xPos <= right) and (yPos >= bottom) and (yPos <= top)) then
				return true;
			end
		end
	end
	return false;
end;

--[[
	Checks all frames registered with Eclipse, that should be checked, to see if the mouse
	is hovering over the frame, and that requirements are met.
]]--
Eclipse.CheckFramesForMouse = function ()
	--Get the current mouse postion
	local xPos, yPos = GetCursorPosition();
	--Go through all frames
	for frameName in Eclipse.Frames do
		--Only check frames that should be checked
		if ( Eclipse.Frames[frameName].checkmouse ) then
			--Default hasMouse to 0
			Eclipse.Frames[frameName].hasMouse = 0;
			--Only check it if requirements are met
			if ( Eclipse.Frames[frameName].reqsmet == 1 ) then
				--If the mouse is hovering the frames, then set hasMouse to 1
				if ( Eclipse.CheckFrameForMouse(frameName, xPos, yPos) == true ) then
					Eclipse.Frames[frameName].hasMouse = 1;
				end
			end
		end
	end
end;

--[[
	Performs the actual updating of the frames, hiding/showing and transparentizing
]]--
Eclipse.UpdateFrames = function ()
	--Go through all the frames
	for frameName in Eclipse.Frames do
		local uiFrame = nil;
		--Only control visibility of frames that should be controled(excluding nes only used for checking)
		if ( Eclipse.Frames[frameName].control ) then
			--By default we will show the frame
			local doShow = true;
			--If the frame should be autohidden, then we say we hide it
			if ( Eclipse.Frames[frameName].autohide == 1 ) then
				doShow = false;
			end
			--If we have a force show, we ignore autohide state, and set to show
			if ( Eclipse.Frames[frameName].forceShow == 1 ) then
				doShow = true;
			end
			--If we want to hide this frame anyway, we do so
			if ( (not Total_Override) and (Eclipse.Frames[frameName].wantHide == 1) ) then
				doShow = false;
			end
			--If we have the override on, then we show the frame anyway
			if ( Eclipse.Frames[frameName].override == 1 ) then
				doShow = true;
			end
			--If we are forcing hiding, like if the base UI shouldn't show the frame,
			--then we hide it to despite all else
			if ( Eclipse.Frames[frameName].forceHide == 1 ) then
				doShow = false;
			end
			--Remember if we have it shown or not
			Eclipse.Frames[frameName].isShown = doShow;

			--If the frame should not be normally showing, and we aren't manually controlling the show state, then hide it.
			if ( ( not Eclipse.Frames[frameName].manual ) and ( not Eclipse.Frames[frameName].state.show ) ) then
				doShow = false;
			end

			--Get the actual frame
			uiFrame = getglobal(frameName);
			if (uiFrame) then
				if ( doShow == true ) then
					--If we are supposed to show it, then if it isn't visable, show it
					if (not uiFrame:IsVisible()) then
						Eclipse.Show(frameName);
						--uiFrame:Show();
					end
				elseif ( uiFrame:IsVisible() ) then
					--We aren't supposed to show it, and it isn't visible, so hide it
					Eclipse.Hide(frameName);
					--uiFrame:Hide();
				end
			end
		end
		if ( Eclipse.Frames[frameName].controltrans ) then
			--Get the frames transparency setting
			local setTrans = Eclipse.Frames[frameName].trans;
			--If UIParent has been set to under 0.10 then set it to 0.10 so it wont get too invisible, for safety reasons
			if ( ( frameName == "UIParent" ) and ( Eclipse.Frames[frameName].trans < 0.10 ) ) then
				Eclipse.Frames[frameName].trans = 0.10;
			end
			--Don't let the transparency go above the UIParent transparency
			if (Eclipse.Frames["UIParent"] and Eclipse.Frames["UIParent"].trans and ( ( Eclipse.Frames["UIParent"].trans * Eclipse.Frames["UIParent"].state.trans ) < Eclipse.Frames[frameName].trans) ) then
				setTrans = Eclipse.Frames["UIParent"].trans * Eclipse.Frames["UIParent"].state.trans;
			end
			--If the override is on, then trans should be at full
			if (Solar_Override) then
				setTrans = 1;
			end
			--If the transparency is not being fully manually controlled then combine it
			if ( not Eclipse.Frames[frameName].manualtrans ) then
				setTrans = setTrans * Eclipse.Frames[frameName].state.trans;
			end
			--Don't let UIParent be made too invisible for safety reasons
			if ( ( frameName == "UIParent" ) and ( setTrans < 0.10 ) ) then
				setTrans = 0.10;
			end
			--Change the frames transparency
			if (not uiFrame) then
				uiFrame = getglobal(frameName);
			end
			if (uiFrame) then
				if (uiFrame:GetAlpha() ~= setTrans) then
					Eclipse.SetAlpha(frameName, setTrans);
				end
			end
		end
	end
end

--[[
	Wrapper to call the frame's origional show function
]]--
Eclipse.Show = function (frameName)
	if (frameName) then
		local frame = getglobal(frameName);
		if (frame) then
			MCom.callHook(frameName..".Show", frame);
		end
	end
end

--[[
	Wrapper to call the frame's origional hide function
]]--
Eclipse.Hide = function (frameName)
	if (frameName) then
		local frame = getglobal(frameName);
		if (frame) then
			MCom.callHook(frameName..".Hide", frame);
		end
	end
end

--[[
	Wrapper to call the frame's origional set alpha function
]]--
Eclipse.SetAlpha = function (frameName, trans)
	if (frameName and trans) then
		local frame = getglobal(frameName);
		if (frame) then
			MCom.callHook(frameName..".SetAlpha", frame, trans);
		end
	end
end

--------------------------------------------------
--
-- Hooked Functions
--
--------------------------------------------------
--[[ Hook to keep up with the true state of the frames visibility, and to not let it show when it shouldn't ]]--
Eclipse.ShowHook = function (frame)
	--Make sure a frame object was passed
	if (frame) then
		--Get the name of the frame
		local frameName = frame:GetName();
		--Only proceed if we have the name of the frame, and it is one we control
		if ( frameName and Eclipse.Frames[frameName] and Eclipse.Frames[frameName].control ) then
			--Set the show state to true from this frame
			Eclipse.Frames[frameName].state.show = true;
			--If we aren't supposed to be showing the frame then dont let the origional function run
			if ( not Eclipse.Frames[frameName].isShown ) then
				return false;
			end
		end
	end
	--Run the origional function
	return true;
end

--[[ Hook to keep up with the true state of the frames visibility, and to not let it hide when it shouldn't ]]--
Eclipse.HideHook = function (frame)
	--Make sure a frame object was passed
	if (frame) then
		--Get the name of the frame
		local frameName = frame:GetName();
		--Only proceed if we have the name of the frame, and it is one we control
		if ( frameName and Eclipse.Frames[frameName] and Eclipse.Frames[frameName].control ) then
			--Set the show state to true from this frame
			Eclipse.Frames[frameName].state.show = false;
			--If we aren't supposed to be hiding the frame then dont let the origional function run
			if ( Eclipse.Frames[frameName].manual and Eclipse.Frames[frameName].isShown ) then
				return false;
			end
		end
	end
	--Run the origional function
	return true;
end

--[[ Hook to keep up with the true state of the frames transparency, and to not let it change when it shouldn't ]]--
Eclipse.SetAlphaHook = function (frame, trans)
	--Make sure a frame object was passed
	if (frame) then
		--Get the name of the frame
		local frameName = frame:GetName();
		--Only proceed if we have the name of the frame, and it is one we control
		if ( frameName and Eclipse.Frames[frameName] and Eclipse.Frames[frameName].controltrans and trans ) then
			--Set the show state to true from this frame
			Eclipse.Frames[frameName].state.trans = trans;
			--If we are taking full manual control of transparency, then dont change the transparency at this point
			if ( Eclipse.Frames[frameName].manualtrans ) then
				--Dont call the origional function
				return false;
			end
		end
	end
	--Run the origional function
	return true;
end

--[[ Hook to combine transparency when setting alpha ]]--
Eclipse.SetAlphaHookReplace = function (frame, trans)
	--Make sure a frame object was passed
	if (frame) then
		--Get the name of the frame
		local frameName = frame:GetName();
		--Only proceed if we have the name of the frame, and it is one we control
		if ( frameName and Eclipse.Frames[frameName] and Eclipse.Frames[frameName].controltrans ) then
			--If we aren't taking full manual control of transparency, then set the transparency to be combined
			if ( not Eclipse.Frames[frameName].manualtrans ) then
				--Get the current transparency setting
				local setTrans = Eclipse.Frames[frameName].trans;
				--If UIParent has been set to under 0.10 then set it to 0.10 so it wont get too invisible, for safety reasons
				if ( ( frameName == "UIParent" ) and ( Eclipse.Frames[frameName].trans < 0.10 ) ) then
					Eclipse.Frames[frameName].trans = 0.10;
				end
				--Don't let the transparency go above the UIParent transparency
				if (Eclipse.Frames["UIParent"] and Eclipse.Frames["UIParent"].trans and ( ( Eclipse.Frames["UIParent"].trans * Eclipse.Frames["UIParent"].state.trans ) < Eclipse.Frames[frameName].trans) ) then
					setTrans = Eclipse.Frames["UIParent"].trans * Eclipse.Frames["UIParent"].state.trans;
				end
				--If the override is on, then trans should be at full
				if (Solar_Override) then
					setTrans = 1;
				end
				--Combine the transparency
				setTrans = setTrans * Eclipse.Frames[frameName].state.trans;
				--Don't let UIParent be made too invisible for safety reasons
				if ( ( frameName == "UIParent" ) and ( setTrans < 0.10 ) ) then
					setTrans = 0.10;
				end
				--Change the frames transparency
				Eclipse.SetAlpha(frameName, setTrans);
			end
			--Dont call the origional function
			return false;
		end
	end
	--Run the origional function
	return true;
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
Eclipse.OnVarsLoaded = function ()
	if (not Eclipse.ConfigLoaded) then
		Eclipse.ConfigLoaded = true;
		--Load the configuration
		Eclipse.Lunar.LoadConfig();
		Eclipse.Solar.LoadConfig();
		Eclipse.Total.LoadConfig();
		
		--Store the configuration for this character
		Eclipse.Lunar.SaveConfig();
		Eclipse.Solar.SaveConfig();
		Eclipse.Total.SaveConfig();
		
		--Update the frames
		Eclipse.Total.UpdateFrames();
		Eclipse.Solar.UpdateFrames();
	end;
end

Eclipse.OnUpdate = function (elapsed)
	--Only run Eclipse updates at the appropriate intervals
	Eclipse.LastUpdate = Eclipse.LastUpdate + elapsed;
	if (Eclipse.LastUpdate >= Eclipse.UPDATETIME) then 
		--Reset the timer
		Eclipse.LastUpdate = 0;
	
		--Check all frames requirements
		Eclipse.CheckFramesForReqs();
		--Check all frames needed to be checked for mouse
		Eclipse.CheckFramesForMouse();
	end
	
	--We let Lunar, Solar, and Total handle their own timing
	--Let lunar handle the state of auothiding
	Eclipse.Lunar.Update(elapsed);
	
	--Update all the frames visibility at the appropriate intervals
	if (Eclipse.LastUpdate == 0) then
		Eclipse.UpdateFrames();
	end

	--Call the OnUpdate event for hidden frames that need it
	if ( Eclipse.Frames ) then
		for frameName in Eclipse.Frames do
			--Run the OnUpdate function if there is one
			if ( Eclipse.Frames[frameName].onupdate and Eclipse.Frames[frameName].control and ( not Eclipse.Frames[frameName].isShown ) ) then
				Eclipse.Frames[frameName].onupdate(elapsed);
			end
		end
	end
end;

Eclipse.OnLoad = function ()
	--If PopNUI or TransNUI is around, then get out, and get out NOW!
	if (PopNUI_OnLoad or TransNUI_OnLoad) then
		UIErrorsFrame:AddMessage(ECLIPSE_ERROR_XUI, 1.0, 0.1, 0.1, 1.0, 30);
		Sea.io.printc({r=1;g=0;b=0;}, ECLIPSE_ERROR_XUI_INFO);
		PlaySoundFile("Sound\\interface\\Error.wav");
		Eclipse = {};
		Eclipse.OnUpdate = function () end;
		return;
	end
	
	if ( Eclipse.Initialized ~= 1) then
		--Register the included frames
		Eclipse.RegisterFrames();

		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(Eclipse.OnVarsLoaded);
		
		--Set Eclipse as not yet initialized
		Eclipse.Initialized = 1;
	end
end;