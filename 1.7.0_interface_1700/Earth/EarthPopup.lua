--[[
--
--	Earth Popup
--
--		Pop-up requests on-demand
--
--		by Alexander Brazie
--
--]]
EARTH_POPUP_DEBUG = true;
EP_DEBUG = "EARTH_POPUP_DEBUG";

--[[
--	EarthPopup definition
--
--	{
--		text = "Hello, please enter your name.";
--		leftButton = "Confirm";
--		rightButton = "Cancel";
--
--		onLeft = function ( text ) message ( "You clicked the left button with "..text); end;
--		onRight = function ( text ) message ( "See you next time!" ) end;
--		
--		hasEditBox = true;
--		autoFocus = true;
--		onEnterPressed = function (text) message("You typed: "..text); end;
--		editBoxMax = 24;
--	}
--	
--	text - (string/function) text for the popup
--	leftButton - (string/function) for the left button text
--		- arg1 is the editbox text if it exists
--	rightButton - (string/function) text for the right button text
--		- arg1 is the editbox text if it exists
--
--	timeout - (number) - delay until the popup should vanish
--	onLeft - function called when the left button is pushed
--	onRight - function called when the right button is pushed
--
--	hasEditBox - true if there's an edit box
--	editBoxLength - maximum length of the edit box
--	editBoxText - initial editbox text
--	onEnterPressed - function called when the edit box enter key is pressed
--	onEscapePressed - function called when the edit box escape key is pressed (defaults to hide the box)
--	autoFocus - automatically select the input box
--	
--	onShow - function called when shown
--	onHide - function called when hidden
--		
--	-- Money frame doesnt work
--	hasMoneyFrame - true if there's a money frame
--	moneyFrameCount - amount of money in the frame
--
--	hideOnEscape
--		- true (default) - you want to hide it when the escape key is pressed
--		- false - remain visible until a button is pushed
--
--	sound - filename of a sound to be played when the popup appears
--	whileDead - true (default) the popup should appear - even while you're dead!
--
--]]

function Earth_Popup(p)
	if ( Earth_Popup_Validate(p) ) then
		local text = p.text;
		if ( type(text) == "function" ) then
			text = text();
		end

		local left = p.leftButton;
		if ( type(left) == "function" ) then
			left = left();
		end
		local right = p.rightButton;
		if ( type(right) == "function" ) then
			right = right();
		end
		
		local onLeft, onRight = p.onLeft, p.onRight;
		
		local hasEditBox = p.hasEditBox;
		local hideOnEscape = p.hideOnEscape;
		local autoFocus = p.autoFocus; 
		local editText = p.editBoxText;
		local editBoxLength = p.editBoxLength;
		local onEnterPressed = p.onEnterPressed;
		local onEscapePressed = p.onEscapePressed;

		local timeout = p.timeout;
		local onShow = p.onShow;
		local onHide = p.onHide;
		local onUpdate = p.onUpdate;
		local whileDead = p.whileDead;
		local hasMoneyFrame = p.hasMoneyFrame;
		local moneyFrameCount = p.moneyFrameCount;
		local realOnShow = function()
			if ( hasEditBox ) then 
				if ( autoFocus ) then 
					getglobal(this:GetName().."EditBox"):SetFocus();
				end
				if ( editText ) then 
					getglobal(this:GetName().."EditBox"):SetText(editText);
				else
					getglobal(this:GetName().."EditBox"):SetText("");					
				end
			end
			if ( hasMoneyFrame ) then 
				MoneyFrame_Update(this:GetName().."MoneyFrame", moneyFrameCount);
			end

			if ( onShow ) then
				onShow();
			end
		end;

		local realOnAccept = function ()
			local text;
			if ( hasEditBox ) then 
				text = getglobal(this:GetParent():GetName().."EditBox"):GetText();
			end
			if ( onLeft ) then 
				return onLeft(text);
			end
		end;
		local realOnEnterPressed = function ()
			local text;
			if ( hasEditBox ) then 
				text = getglobal(this:GetParent():GetName().."EditBox"):GetText();
			end
			if ( onEnterPressed ) then 
				return onEnterPressed(text);
			end
		end;
		local realOnCancel = function ()
			local text;
			if ( hasEditBox ) then 
				text = getglobal(this:GetParent():GetName().."EditBox"):GetText();
			end
			if ( onRight ) then 
				return onRight(text);
			end
		end;

		-- Create the static entry
		local popupStatic = {};		
		popupStatic.text = text;
		popupStatic.button1 = left;
		popupStatic.button2 = right;
		popupStatic.OnAccept = realOnAccept;
		popupStatic.OnCancel = realOnCancel;
		popupStatic.OnShow = realOnShow;
		popupStatic.OnHide = onHide;
		popupStatic.OnUpdate = onUpdate;

		if ( editBoxLength ) then 
			popupStatic.maxLetters = editBoxLength;
		else
			popupStatic.maxLetters = 60;
		end

		if ( hasMoneyFrame ) then
			popupStatic.hasMoneyFrame = 1;
		end
		if ( timeout ) then 
			popupStatic.timeout = timeout;
		else
			popupStatic.timeout = 0;
		end
		if ( hasEditBox ) then 
			popupStatic.hasEditBox = 1;
		end
		
		if ( whileDead == false ) then 
			popupStatic.whileDead = nil;
		else
			popupStatic.whileDead = 1;
		end

		popupStatic.EditBoxOnEnterPressed = realOnEnterPressed;

		if ( onEscapePressed ) then 
			popupStatic.EditBoxOnEscapePressed = onEscapePressed;
		else
			popupStatic.EditBoxOnEscapePressed = function()
				this:GetParent():Hide();
			end;
		end

		StaticPopupDialogs["EARTH_POPUP"] = popupStatic;
		StaticPopup_Show("EARTH_POPUP");
	end
end

function Earth_Popup_Validate(popup) 
	if ( type ( popup ) ~= "table" ) then 
		return false;
	end

	if ( type ( popup.text ) ~= "function" and type( popup.text ) ~= "string" ) then
		Sea.io.derror(EP_DEBUG, "Invalid text in popup sent by ", this:GetName() );
		return false;
	end
	
	if ( not popup.leftButton and not popup.rightButton ) then 
		Sea.io.derror(EP_DEBUG, "You need at least one button in the popup dialog");
		return false;
	else
		if ( popup.leftButton ) then 
			if ( type ( popup.leftButton ) ~= "function" and type( popup.leftButton ) ~= "string" ) then
				Sea.io.derror(EP_DEBUG, "Invalid leftButton in popup sent by ", this:GetName() );
				return false;
			end
		end
		if ( popup.rightButton ) then 
			if ( type ( popup.rightButton ) ~= "function" and type( popup.rightButton ) ~= "string" ) then
				Sea.io.derror(EP_DEBUG, "Invalid rightButton in popup sent by ", this:GetName() );
				return false;
			end
		end
	end
	
	if ( type ( popup.text ) ~= "function" and type( popup.text ) ~= "string" ) then
		Sea.io.derror(EP_DEBUG, "Invalid text in popup sent by ", this:GetName() );
		return false;
	end
	
	return true;
end
