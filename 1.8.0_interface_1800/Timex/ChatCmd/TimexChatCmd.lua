--<< ================================================= >>--
-- Section I: The Global Functions.	                     --
--<< ================================================= >>--

ace:RegisterFunctions(Timex, {
	version	= 1.0,

    ExecuteChatCommand = function(...)
        if not DEFAULT_CHAT_FRAME then return end
        DEFAULT_CHAT_FRAME.editBox:SetText(ace.concat(arg))
        ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
    end,

	ParseByName = function(i, p, s)
		local tmpDB= {}
		p = p or "=" s = s or ":" i = i..s
		string.gsub(i, "(%a[%a%d_]-)"..p.."(.-)"..s, function(k, v) tmpDB[k] = v end)
		return tmpDB
	end
})

--<< ================================================= >>--
-- Section II: The Chat Options.                         --
--<< ================================================= >>--

function Timex:ChatExecute(i)
	local p = self.ParseByName(i)
	if not p.f or not p.t then
		self.cmd:result(TimexLocals.Chat_BadValues)
		return
	end
	p.a = "/script "..p.f.."("..(p.a or "")..")"
	p.f = Timex.ExecuteChatCommand
	self:AddNamedSchedule(p.n, p.t, p.r, p.c, p.f, p.a)
	self.cmd:result(TimexLocals.Chat_Execute)
end

function Timex:ChatDelete(i)
	if not Timex:NamedScheduleCheck(i) then
		self.cmd:result(format(TimexLocals.Chat_BadDelete, i))
		return
	end
	Timex:DeleteNamedSchedule(i)
	self.cmd:result(format(TimexLocals.Chat_Delete, i))
end

--<< ================================================= >>--
-- Section Omega: Register the AddOn Object.             --
--<< ================================================= >>--
