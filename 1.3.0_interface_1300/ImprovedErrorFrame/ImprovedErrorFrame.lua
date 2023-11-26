old_ERRORMESSAGE = _ERRORMESSAGE;
old_message = message;
_ERRORMESSAGE = nil;
message = nil;
NUMBER_ERROR_MESSAGE_PAGE_MAX = 10;
NUMBER_ERROR_MESSAGE_MAX = 999;
NUMBER_ERROR_MESSAGE_INFINITE = 20;
error_message_list = { };
message_print = "";
error_message_reportlist = { };
RegisterForSave("error_message_reportlist");
UIPanelWindows["ImprovedErrorFrame"] = { area = "center",	pushable = 0 }; -- Allows the frame to be closed by Escape

function Print(msg, r, g, b, frame)
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
		else 
		end
	end
end

function _ERRORMESSAGE(message)
	debuginfo();
	if (not message) then return; end
	if (table.getn(error_message_list) > 0 and ImprovedErrorFrameCancelButton:IsVisible()) then return; end
	--if (table.getn(error_message_list) == NUMBER_ERROR_MESSAGE_MAX) then return; end

	local foundMes = false;
	for curNum, curMes in error_message_list do
		if (curMes[1] == message) then
			if (curMes[2].."" ~= "infinite") then
				curMes[2] = curMes[2] + 1;
				if (curMes[2] > NUMBER_ERROR_MESSAGE_INFINITE) then
					curMes[2] = "infinite";
				end
				curMes[3] = 0;
			else
				if (curMes[3] == 2) then
					return;
				end
			end
			foundMes = true;
			break;
		end
	end

	if (not foundMes) then
		Print(message);
	end
	
	if ((not foundMes) and (table.getn(error_message_list) < NUMBER_ERROR_MESSAGE_MAX)) then 
		table.insert(error_message_list, {message; 1; 0});
	end

	message_print = "";
	local shown = 0;
	local rerun = 0;
	for i = 1, table.getn(error_message_list), 1 do
		if (shown >= NUMBER_ERROR_MESSAGE_PAGE_MAX) then
			break;
		end
		local curMes = error_message_list[i];
		if (curMes[3] ~= 2) then
			shown = shown + 1;
			if (curMes[3] == 1) then
				rerun = rerun + 1;
			end
			curMes[3] = 1;

			local Useless, Useless, file, line, error = string.find(curMes[1], "^%[string \"(.+)\"%]:([^:]+):(.+)");
			local count = curMes[2];
			if (file) then
				local Useless, one = string.gsub(file, "%.lua$", "lol");
				local Useless, two = string.gsub(file, "%.xml$", "lol");
			end
			if (file) then
				if (one == 1 or two == 1) then
					message_print = message_print..IEF_FILE.." "..file.."\n"..IEF_LINE.." "..line.."\n"..IEF_COUNT.." "..count.."\n|cFFFF0000"..IEF_ERROR..error.."|r";
				else
					message_print = message_print..IEF_STRING.." "..file.."\n"..IEF_LINE.." "..line.."\n"..IEF_COUNT.." "..count.."\n|cFFFF0000"..IEF_ERROR..error.."|r";
				end
			else 
				message_print = message_print.."\nCount : "..count.."|cFFFF0000"..IEF_ERROR..curMes[1].."|r";
			end
			if (i ~= table.getn(error_message_list)) then
				message_print = message_print.."\n--------------------------------------------------\n";
			end
		end
	end
	
	if (rerun < shown) then
		if (not ImprovedErrorFrame:IsVisible()) then
			--ImprovedErrorFrameReportButton:Disable();
			ImprovedErrorFrameCloseButton:Show();
			ImprovedErrorFrameCancelButton:Hide();
			ScriptErrorsScrollFrameOne:Show();
			ScriptErrorsScrollFrameAsk:Hide();
			ImprovedErrorFrameButton:Hide();
			ImprovedErrorFrame:Show();
		end
	
		ScriptErrorsScrollFrameOneText:SetText(message_print);
		ScriptErrorsScrollFrameOneText:ClearFocus();
	end
end


function ImprovedError_Report_OnClick()
	if (ImprovedErrorFrameCloseButton:IsVisible()) then
		ImprovedErrorFrameCloseButton:Hide();
		ImprovedErrorFrameCancelButton:Show();
		ScriptErrorsScrollFrameOne:Hide();
		ScriptErrorsScrollFrameAsk:Show();
		message_print = IEF_MESSAGE;
		ScriptErrorsScrollFrameAskText:SetText(message_print);
		ScriptErrorsScrollFrameAskText:ClearFocus(message_print);
	else
		local temp = { };
		temp.desc = ScriptErrorsScrollFrameAskText:GetText();
		temp.bug = error_message_list;
		table.insert(error_message_reportlist, temp);
		Print(IEF_THX);
		this:GetParent():Hide();
	end
end

function message(text)
	_ERRORMESSAGE(text);
end

ScriptErrors.Show = function()
	message(ScriptErrors_Message:GetText());
end


