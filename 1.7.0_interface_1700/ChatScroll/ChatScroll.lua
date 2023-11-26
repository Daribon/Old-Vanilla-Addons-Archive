--------------------------------------------------------------------------
-- ChatScroll.lua 
--------------------------------------------------------------------------
--[[
ChatScroll

author: AnduinLothar    <karlkfi@cosmosui.org>

-ChatFrame Mouse Wheel Scroll
-Visibility Options using TransNUI and PopNUI for scroll buttons on all seven ChatFrames, plus the menu button.


]]--

Cosmos_UseMouseWheelToScrollChat = true;

function ChatFrame_OnMouseWheel(chatframe, value)
	if ( Cosmos_UseMouseWheelToScrollChat ) and ( not IsShiftKeyDown() ) then
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

function ChatScroll_OnLoad()
	if (Khaos) then
		ChatScroll_Register_Khaos();
	end
	if (not Eclipse) then
		if ( TransNUI_RegisterUI ) then
			TransNUI_RegisterUI("ChatFrameMenuButton", { "chatframe1", "menu" }, "Chat Frame Menu Button", "Chat Frame Menu Button", 0);
		end
		if ( PopNUI_RegisterUI ) then
			PopNUI_RegisterUI("ChatFrameMenuButton", { "chatframe1", "menu" }, nil, "Chat Frame Menu Button", "Chat Frame Menu Button");
		end
		
		local chatframename;
		for i=1, 7 do
			chatframename = "ChatFrame"..i;
			if ( TransNUI_RegisterUI ) then
				TransNUI_RegisterUI(chatframename.."UpButton", { string.lower(chatframename), "up" }, chatframename.." Up Button", chatframename.." Up Button", 0);
				TransNUI_RegisterUI(chatframename.."DownButton", { string.lower(chatframename), "down" }, chatframename.." Down Button", chatframename.." Down Button", 0);
				TransNUI_RegisterUI(chatframename.."BottomButton", { string.lower(chatframename), "bottom" }, chatframename.." Bottom Button", chatframename.." Bottom Button", 0);
			end
			if ( PopNUI_RegisterUI ) then
				PopNUI_RegisterUI(chatframename.."UpButton", { string.lower(chatframename), "up" }, nil, chatframename.." Up Button", chatframename.." Up Button");
				PopNUI_RegisterUI(chatframename.."DownButton", { string.lower(chatframename), "down" }, nil, chatframename.." Down Button", chatframename.." Down Button");
				PopNUI_RegisterUI(chatframename.."BottomButton", { string.lower(chatframename), "bottom" }, nil, chatframename.." Bottom Button", chatframename.." Bottom Button");
			end
		end
	end
end

function ChatScroll_Register_Khaos()
	local optionSet = {
		id="ChatScroll";
		text=CHATSCROLL_CONFIG_HEADER;
		helptext=CHATSCROLL_CONFIG_HEADER_INFO;
		difficulty=1;
		options={
			{
				id="Header";
				text=CHATSCROLL_CONFIG_HEADER;
				helptext=CHATSCROLL_CONFIG_HEADER_INFO;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="ChatScrollEnable";
				type=K_TEXT;
				text=CHATSCROLL_ENABLED;
				helptext=CHATSCROLL_ENABLED_INFO;
				callback=function(state) if (state.checked) then Cosmos_UseMouseWheelToScrollChat = true; else Cosmos_UseMouseWheelToScrollChat = nil; end end;
				feedback=function(state) if (state.checked) then return CHATSCROLL_CHAT_ENABLED; else return CHATSCROLL_CHAT_DISABLED; end end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
		};
	};
	Khaos.registerOptionSet(
		"chat",
		optionSet
	);
	ChatScroll_Khaos_Registered = true;
end
