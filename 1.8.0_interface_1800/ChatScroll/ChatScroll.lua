--------------------------------------------------------------------------
-- ChatScroll.lua 
--------------------------------------------------------------------------
--[[
ChatScroll

author: AnduinLothar    <karlkfi@cosmosui.org>

-ChatFrame Mouse Wheel Scroll

Change List
v1.1
-Initial Release
v1.1
-Fixed negative framelevel bug in new patch
-Updated the TOC to 1300.
V2.0
-No longer uses hidden frames, now uses script element hooks
-No longer supports PopUI or TransUI, I recomend using VisibilityOptions to hide the buttons.
-Added Shift-MouseWheelUp to to to the top of the chat window
-Added Shift-MouseWheelDown to to to the bottom of the chat window
-Added Scroll to Top Binding

]]--

-- <= == == == == == == == == == == == == =>
-- => Function Definition
-- <= == == == == == == == == == == == == =>

function ChatFrame_OnMouseWheel(chatframe, value)
	if ( ChatScroll_Enabled ) then
		if ( IsShiftKeyDown() ) then
			if ( value > 0 ) then
				chatframe:ScrollToTop()
			elseif ( value < 0 ) then
				chatframe:ScrollToBottom();
			end
		else
			if ( value > 0 ) then
				chatframe:ScrollUp();
			elseif ( value < 0 ) then
				chatframe:ScrollDown();
			end
		end
	else
		if ( value > 0 ) then
			ActionBar_PageUp();
		elseif ( value < 0 ) then
			ActionBar_PageDown();
		end
	end
end

function ChatScroll_SetUpChatFrameScrollHooks()
	for i=1, 7 do
		local frame = getglobal("ChatFrame"..i);
		frame:EnableMouseWheel(1);
		local oldFunc = frame:GetScript("OnMouseWheel");
		if (oldFunc) then
			frame:SetScript("OnMouseWheel", function() oldFunc(); ChatFrame_OnMouseWheel(this, arg1); end);
		else
			frame:SetScript("OnMouseWheel", function() ChatFrame_OnMouseWheel(this, arg1); end);
		end
	end
end

function ChatScroll_ScrollToTop()
	SELECTED_DOCK_FRAME:ScrollToTop();
end

function ChatScroll_Register_Khaos()
	local optionSet = {
		id="ChatScroll";
		text=CHATSCROLL_CONFIG_HEADER;
		helptext=CHATSCROLL_CONFIG_HEADER_INFO;
		callback=function(state) if (state) then ChatScroll_Enabled = true; else ChatScroll_Enabled = nil; end end;
		feedback=function(state) if (state) then return CHATSCROLL_CHAT_ENABLED; else return CHATSCROLL_CHAT_DISABLED; end end;
		difficulty=1;
		default={checked=true};
		options={
			{
				id="Header";
				text=CHATSCROLL_CONFIG_HEADER;
				helptext=CHATSCROLL_CONFIG_HEADER_INFO;
				type=K_HEADER;
				difficulty=1;
			};
		};
	};
	Khaos.registerOptionSet(
		"chat",
		optionSet
	);
	ChatScroll_Khaos_Registered = true;
end

-- <= == == == == == == == == == == == == =>
-- => Execution
-- <= == == == == == == == == == == == == =>

ChatScroll_Enabled = true;

ChatScroll_SetUpChatFrameScrollHooks();

if (Khaos) then
	ChatScroll_Register_Khaos();
end
