PagerMessagePrefix = "Pager - ";

function Pager_Onload()
	local id = "PAGER";
	local func = function(msg)
		Pager_SendPage(msg, this.language);
	end
	Cosmos_RegisterChatCommand ( id, PAGER_COMMAND, func, PAGER_COMMAND_DESC );

	Cosmos_RegisterChatWatch ( "PAGER", {"WHISPER"}, function (type, info, arg1, arg2, arg3, arg4) return Pager_ProcessMessage(arg1,arg2); end );
end

function Pager_SendPage(msg, language)
    local who = gsub(msg, "(%s*)([^%s]+)(.*)", "%2", 1);
    if (strlen(who) <= 0) then
        return;
    end
    
    local text = strsub(msg, strlen(who) + 1);
    
    --Pager_DebugMessage("Sending Page to "..who..": "..text);
    
    if (who == UnitName("player")) then
        Pager_ReceivePage(text);
    else
        SendChatMessage(PagerMessagePrefix..text, "WHISPER", language, who);
    end
end

function Pager_ProcessMessage(msg,who)
    local len = strlen(PagerMessagePrefix);
    if (strsub(msg, 1, len) ~= PagerMessagePrefix) then
        return 1; -- Show
    end
    Sea.io.printc({r=1.0,g=0.0,b=0.0}, who," sent you a page: ",strsub(msg,len+1));
    Pager_ReceivePage(strsub(msg, len));
	return 0; -- Hide
end

function Pager_ReceivePage(msg)
    --Pager_DebugMessage("Receiving Page: "..msg);
    ZoneTextString:SetText(msg);
    ZoneTextString:SetTextColor(1.0, 0.2, 0.2);
    ZoneTextFrame.startTime = GetTime();
    ZoneTextFrame:Show();
    PlaySound("MapPing");
end

function Pager_DebugMessage(msg)
    local info = ChatTypeInfo["SYSTEM"];
    Sea.io.printc(info, message);
    --PlaySound("TellMessage");
end
