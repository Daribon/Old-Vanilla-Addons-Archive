--<< ================================================= >>--
-- Section I: Initialize the AddOn Object.               --
--<< ================================================= >>--

Timex             = AceAddonClass:new({
    name          = TimexLocals.Title,
    version       = TimexLocals.Version,
    description   = TimexLocals.Desc,
    author        = "Rowne",
    authorEmail   = "wuffxiii@gmail.com",
    aceCompatible = "100",
    category      = ACE_CATEGORY_OTHERS,
    cmd           = AceChatCmdClass:new(TimexLocals.ChatCmd, (TimexLocals.ChatOpt or {})),
    db            = AceDbClass:new("TimexDB"),
    
    timerDB       = {},
    initDB        = {}
})

function Timex:Enable()
	self:RunStartupFunctions()
end

--<< ================================================= >>--
-- Section II: The Timex System Functions.               --
--<< ================================================= >>--

function Timex:RunStartupFunctions()
	for k, v in self.initDB do
		tremove(self.initDB, k)
		if v.f then v.f(unpack(v.a or {})) end
	end
end

function Timex:AddStartupFunc(f, ...)
	tinsert(self.initDB, {
		f = f,
		a = arg
	})
end

function Timex:NamedScheduleCheck(n, r)
	for k, v in self.timerDB do
		if v.n == n then
			if r then return (v.e or 0) end
			return TRUE
		end
	end
end

function Timex:AddNamedSchedule(n, t, r, c, f, ...)
	if not n and not t then return end
	self:DeleteNamedSchedule(n)
	tinsert(self.timerDB, {
		n = n or this:GetName(),
		t = tonumber(t),
		r = r,
		c = tonumber(c),
		e = 0,
		f = f,
		a = arg
	})
	self:HandleFrame(TRUE)
end

function Timex:DeleteNamedSchedule(n, r)
	for k, v in self.timerDB do
		if v.n == n then tremove(self.timerDB, k) end
	end
	self:HandleFrame()
end

function Timex:ChangeDuration(n, t)
	for k, v in self.timerDB do
		if v.n == n then v.t = t or v.t end
	end
end

function Timex:HandleFrame(h)
	if getn(self.timerDB) == 1 or h then
		TimexUpdateFrame:Show()
	elseif getn(self.timerDB) == 0 then
		TimexUpdateFrame:Hide()
	end
end

function Timex:Update()
	for k, v in Timex.timerDB do
		v.e = v.e + (arg1 or 0.015)
		if not v.t then elseif v.e >= v.t then v.e = 0
			if v.c then
				v.c = v.c - 1
				if v.c <= 0 then
					tremove(Timex.timerDB, k)
					Timex:HandleFrame()
				end
			elseif not v.r then
				tremove(Timex.timerDB, k)
            Timex:HandleFrame()
         end
         if v.f == "doTimexEvent" then
         	self:TriggerEvent("TIMEX_UPDATE", v.a, v.c, v.n)
         elseif v.f then v.f(unpack(v.a or {})) end
      end
   end
end

--<< ================================================= >>--
-- Section Omega: Register the AddOn Object.             --
--<< ================================================= >>--

Timex:RegisterForLoad()