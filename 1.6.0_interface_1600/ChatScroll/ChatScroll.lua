--------------------------------------------------------------------------
-- ChatScroll.lua 
--------------------------------------------------------------------------
--[[
ChatScroll

author: AnduinLothar    <Anduin@ultimateuiui.org>

Replaces an old UltimateUI FrameXML Hack.
-ChatFrame Mouse Wheel Scroll


]]--

UltimateUI_UseMouseWheelToScrollChat = true;

function ChatFrame_OnMouseWheel(chatframe, value)
	if ( UltimateUI_UseMouseWheelToScrollChat ) and ( not IsShiftKeyDown() ) then
		if ( value > 0 ) then
			chatframe:ScrollUp();
		elseif ( value < 0 ) then
			chatframe:ScrollDown();
		end
	else
		if ( value > 0 ) then
			ActionBar_PageUp();
		elseif ( value < 0 ) then
			ActionBar_PageDown();
		end
	end
end
