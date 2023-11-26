PopupHandler_Options_Default = {
	enabled = true;
};

PopupHandler_Options = {
};


PopupHandler_HandlersOnLoad = {};

PopupHandler_HandlersPopups = {};

PopupHandler_EventHandlers = {};


PopupHandler_StaticPopup_Show_ReturnNow = false;
PopupHandler_StaticPopup_Show_ReturnValues = {};
PopupHandler_StaticPopup_Show_ReturnDialog = nil;


function PopupHandler_OnLoad()
	for k, v in PopupHandler_HandlersOnLoad do
		v();
	end
	local f = PopupHandlerFrame;
	f:RegisterEvent("VARIABLES_LOADED");
	PopupHandler_Saved_StaticPopup_Show = StaticPopup_Show;
	StaticPopup_Show = PopupHandler_StaticPopup_Show;
	PopupHandler_AddOptions();
end


function PopupHandler_AddEventListener(event, func)
	if ( not PopupHandler_EventHandlers[event] ) then
		PopupHandler_EventHandlers[event] = {};
		PopupHandlerFrame:RegisterEvent(event);
	end
	table.insert(PopupHandler_EventHandlers[event], func);
end

function PopupHandler_AddPopupHandler(popup, func)
	if ( not popup ) or ( not func ) then
		return false;
	end
	if ( not PopupHandler_HandlersPopups[popup] ) then
		PopupHandler_HandlersPopups[popup] = {};
	end
	table.insert(PopupHandler_HandlersPopups[popup], func);
end


function PopupHandler_OnEvent()
	if ( PopupHandler_EventHandlers[event] ) then
		local func = nil;
		for k, v in PopupHandler_EventHandlers[event] do
			if (type(v) == "string" ) then
				func = getglobal(v);
			else
				func = v;
			end
			if ( func ) then
				func(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
			end
		end
	end
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in PopupHandler_Options_Default do
			if ( PopupHandler_Options[k] == nil ) then
				PopupHandler_Options[k] = v;
			end
		end
		return;
	end
	if ( event == "" ) then
		return;
	end
end


function PopupHandler_StaticPopup_Show(which, text_arg1, text_arg2)
	if ( PopupHandler_Options.enabled ) then
	
		if ( PopupHandler_HandlersPopups[which] ) and ( table.getn(PopupHandler_HandlersPopups[which]) > 0 ) then
			PopupHandler_StaticPopup_Show_ReturnDialog = nil;
			PopupHandler_StaticPopup_Show_ReturnNow = false;
			local func = nil;
			for k, v in PopupHandler_HandlersPopups[which] do
				if ( type(v) == "string" ) then
					func = getglobal(v);
				else
					func = v;
				end
				if ( func ) then
					func(which, text_arg1, text_arg2);
					if ( PopupHandler_StaticPopup_Show_ReturnNow ) then
						break;
					end
				end
			end
			
			return PopupHandler_StaticPopup_Show_ReturnDialog;
		end
	
	end
	return PopupHandler_Saved_StaticPopup_Show(which, text_arg1, text_arg2);
end


function PopupHandler_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(string.format(chatFormat, state), 1, 1, 0.1);
end

function PopupHandler_GetStaticPopup(which)
	for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
		local frame = getglobal("StaticPopup"..index);
		if( frame:IsVisible() and (frame.which == which) ) then 
			return frame;
		end
	end
	return nil;
end
