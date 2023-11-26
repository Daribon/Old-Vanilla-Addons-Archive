--<< ================================================= >>--
-- Section I: Initialize the AddOn Object.               --
--<< ================================================= >>--

TimexBar = Timex:new({})

function TimexBar:Enable()
	self.barsDB = {}
	self.bars   = {
		false, false, false, false, false,
		false, false, false, false, false,
		false, false, false, false, false,
		false, false, false, false, false
	}
	self:RegisterEvent("TIMEX_UPDATE")
end

--<< ================================================= >>--
-- Section II: The Start and Stop Bar Functions.         --
--<< ================================================= >>--

function TimexBar:StartBar(txt, tmr, r, g, blu, x, y, pr, a1, a2)
	if not tmr or not txt or txt == "" then return end
	local b
	for k, v in self.bars do
		if v == txt then b = k end
	end
	if not b then for k, v in self.bars do
		if v == false then b = k self.bars[k] = txt break end
	end
	elseif not b then return end
	self.barsDB[b] = {
		bar = b, n  = txt, t  = tmr, v  = tmr,
		r   = r, g  = g,   b  = blu, x  = x,
		y   = y, pr = pr,  a1 = a1,  a2 = a2
	}
	self:BarHandler(self.barsDB[b])
	Timex:AddNamedSchedule("TimexBar"..b, 1.0,
		nil, tmr, "doTimexEvent")
	return "TimexBar"..b
end

function TimexBar:StopBar(txt)
	for k, v in self.bars do
		if v == txt then
			Timex:DeleteNamedSchedule("TimexBar"..k)
			getglobal("TimexBar"..k):Hide()
		end
	end
end

--<< ================================================= >>--
-- Section III: The BarHandler Function.                 --
--<< ================================================= >>--

function TimexBar:BarHandler(db)
	local bar  = getglobal("TimexBar"..db.bar)
	local sbar = getglobal("TimexBar"..db.bar.."StatusBar")
	local sprk = getglobal("TimexBar"..db.bar.."StatusBarSpark")
	local txt  = getglobal("TimexBar"..db.bar.."Text")
	bar:Show()
	if db.x and db.y then
		bar:ClearAllPoints()
		bar:SetPoint((db.a1 or "CENTER"), (db.pr or "UIParent"), (db.a2 or "BOTTOMLEFT"), db.x, db.y)
	end
	local settext = db.v
	settext = settext > 60 and format("%.2f", settext / 60).."m" or settext.."s"
	settext = db.n.." "..settext
	sbar:SetMinMaxValues(1, db.t)
	sbar:SetStatusBarColor((db.r or 0.1), (db.g or 0.2), (db.b or 0.8))
	sbar:SetValue(db.v)
	txt:SetText(settext)
	local sp = floor(db.v / db.t * 195) + 1.5
	sp = sp > 0 and sp or 0
	sprk:SetPoint("CENTER", "TimexBar"..db.bar, "LEFT", sp, 4)
end

--<< ================================================= >>--
-- Section IV: The Time-Event Handler.                   --
--<< ================================================= >>--

function TimexBar:TIMEX_UPDATE(a, c, n)
	if not strfind(n, "TimexBar") then return end
	n = gsub(n, "TimexBar", "") n = tonumber(n)
	self.barsDB[n].v = self.barsDB[n].v - 1
	if self.barsDB[n].v <= 0 then
		getglobal("TimexBar"..n):Hide()
		self.barsDB[n] = nil
		Timex:DeleteNamedSchedule("TimexBar"..n)
		self.bars[n] = false return
	end
	self:BarHandler(self.barsDB[n])
end

--<< ================================================= >>--
-- Section Omega: Register the AddOn Object.             --
--<< ================================================= >>--

TimexBar:RegisterForLoad()