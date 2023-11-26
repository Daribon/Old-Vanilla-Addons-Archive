--<< ================================================= >>--
-- Section I: Chronos Support.                           --
--<< ================================================= >>--

Chronos = {
	parseArgs         = function(n, t, f, ...)
		return n, t, nil, nil, f, arg
	end,
	isScheduledByName = function(n)
		return Timex:NamedScheduleCheck(n)
	end,
	schedule          = function(...)
		Chronos.scheduleByName(nil, unpack(arg))
	end,
	scheduleByName    = function(...)
		local n, t, r, c, f, a= Chronos.parseArgs(unpack(arg))
		Timex:AddNamedSchedule(n, t, r, c, f, unpack(a))
	end,
	unscheduleByName  = function(n)
		Timex:DeleteNamedSchedule(n)
	end,
	getTimer          = function(n)
		return (Timex:NamedScheduleCheck(n, TRUE) or 0)
	end,
	startTimer        = function(n)
		Chronos.scheduleByName(n)
	end,
	endTimer          = function(n)
		local r= Chronos.getTimer(n)
		Timex:DeleteNamedSchedule(n)
		return r
	end,
	afterInit         = function(...)
		Timex:AddStartupFunc(unpack(arg))
	end
}

--<< ================================================= >>--
-- Section Omega: Closure.                               --
--<< ================================================= >>--