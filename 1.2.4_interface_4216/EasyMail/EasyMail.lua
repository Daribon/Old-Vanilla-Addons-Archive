-- EasyMail
-- Written by Thott

function EasyMail_OnLoad()
  Sea.util.hook("SendMailFrame_SendMail","EasyMail_SendMail","before");
  Sea.util.hook("MailFrameTab_OnClick","EasyMail_MailFrameTab","after");
  Sea.util.hook("SendMailFrame_Update","EasyMail_SendMailUpdate","after");
  RegisterForSave("EasyMail_LastMailed");
end

function EasyMail_SendMail()
  EasyMail_LastMailed = SendMailNameEditBox:GetText();
  Chronos.schedule(0.1,EasyMail_MailFrameTab);
  Chronos.schedule(1.0,EasyMail_MailFrameTab);
end
function EasyMail_MailFrameTab(tab)
  if(EasyMail_LastMailed) then
    local text = SendMailNameEditBox:GetText();
    if(not text or text == "") then
      SendMailNameEditBox:SetText(EasyMail_LastMailed);
    end
  end
end
function EasyMail_SendMailUpdate()
  local itemName,texture,count = GetSendMailItem();
  dprint("itemName: ",itemName);
  if(itemName) then
    local subject = SendMailSubjectEditBox:GetText();
    if(not subject or subject == "") then
      if(count and count > 1) then
	SendMailSubjectEditBox:SetText(count.."x "..itemName);
      else
	SendMailSubjectEditBox:SetText(itemName);
      end
    end
  end
end
