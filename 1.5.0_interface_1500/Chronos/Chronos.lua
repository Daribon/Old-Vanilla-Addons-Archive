--[[
--
--	Chronos
--		Keeper of Time
--
--	By Alexander Brazie
--
--	Chronos manages time. You can schedule a function to be called
--	in X seconds, with or without an id. You can request a timer, 
--	which tracks the elapsed duration since the timer was started. 
--	
--	You can also create Tasks - functions which will perform a
--	complex operation over time, reducing system lag if used properly.
--
--	Please see below or see http://www.wowwiki.com/Chronos for details.
--
--	$LastChangedBy: Sinaloit $
--	$Date: 2005-05-30 22:11:59 +0200 (Mon, 30 May 2005) $
--	$Rev: 1653 $
--	
--]]

CHRONOS_REV = "$Rev: 1653 $";
CHRONOS_DEBUG = false;
CH_DEBUG = "CHRONOS_DEBUG";
CHRONOS_DEBUG_WARNINGS = false;
CH_DEBUG_T = "CHRONOS_DEBUG_WARNINGS";

-- Chronos Data 
ChronosData = {
	-- Initialize the startup time
	elaspedTime = 0;

	-- Initialize the VariablesLoaded flag
	variablesLoaded = false;

	-- Initialize the EnteredWorld flag
	enteredWorld = false;

	-- Last ID
	lastID = nil;
	
	-- Initialize the Timers
	timers = {};

	-- Initialize the perform-over-time task list
	tasks = {};
};
-- Prototype Chronos
Chronos = {
	-- Online or off
	online = true;
	
	-- Maximum items per frame
	MAX_TASKS_PER_FRAME = 100;
	
	-- Maximum steps per task
	MAX_STEPS_PER_TASK = 300;

	-- Maximum time delay per frame
	MAX_TIME_PER_STEP = .3;

	--[[
	-- Scheduling functions
	-- Parts rewritten by Thott for speed
	-- Written by Alexander
	-- Original by Thott
	--
	-- Usage: Chronos.schedule(when,handler,arg1,arg2,etc)
	--
	-- After <when> seconds pass (values less than one and fractional values are
	-- fine), handler is called with the specified arguments, i.e.:
	--	 handler(arg1,arg2,etc)
	--
	-- If you'd like to have something done every X seconds, reschedule
	-- it each time in the handler.
	--
	-- Also, please note that there is a limit to the number of
	-- scheduled tasks that can be performed per xml object at the
	-- same time. 
	--]]
	schedule = function (when,handler,...)
		if ( not Chronos.online ) then 
			return;
		end
		if ( not handler) then
			Sea.io.print("ERROR: nil handler passed to Chronos.schedule()");
			return;
		end
				
		--local memstart = gcinfo();
		-- -- Assign an id
		-- local id = "";
		-- if ( not this ) then 
		-- 	id = "Keybinding";
		-- else
		-- 	id = this:GetName();
		-- end
		-- if ( not id ) then 
		-- 	id = "_DEFAULT";
		-- end
		-- if ( not when ) then 
		-- 	Sea.io.derror(CH_DEBUG_T, "Chronos Error Detection: ", id , " has sent no interval for this function. ", when );
		-- 	return;
		-- end

		-- -- Ensure we're not looping ChronosFrame
		-- if ( id == "ChronosFrame" and ChronosData.lastID ) then 
		-- 	id = ChronosData.lastID;
		-- end

		local task;
		-- reuse task memory if possible to avoid excessive garbage collection --Thott
		if(not ChronosData.sched[ChronosData.sched.n+1]) then
			ChronosData.sched[ChronosData.sched.n+1] = {};
		end
		ChronosData.sched.n = ChronosData.sched.n+1;
		local i = ChronosData.sched.n;
		-- ChronosData.sched[i].id = id;
		ChronosData.sched[i].time = when + GetTime();
		ChronosData.sched[i].handler = handler;
		ChronosData.sched[i].args = arg;

		-- task list is a heap, add new --Thott
		while(i > 1) do
			parent = floor(i/2);
			if(ChronosData.sched[parent].time > ChronosData.sched[i].time) then
				Chronos_Swap(i,parent);
			else
				break;
			end
			i = parent;
		end
		
		-- Debug print
		--Sea.io.dprint(CH_DEBUG, "Scheduled ", handler," in ",when," seconds from ", id );
		--Sea.io.print("Memory change in schedule: ",memstart,"->",memend," = ",memend-memstart);
	end;
	

	--[[
	--	Chronos.scheduleByName(name, delay, function, arg1, ... );
	--
	-- Same as Chronos.schedule, except it takes a schedule name argument.
	-- Only one event can be scheduled with a given name at any one time.
	-- Thus if one exists, and another one is scheduled, the first one
	-- is deleted, then the second one added.
	--
	--]]
	scheduleByName = function (name,when,handler,...)
		if ( not name ) then 
			Sea.io.derror(CH_DEBUG_T,"Chronos Error Detection: No name specified to Chronos.scheduleByName");
			return;
		end
		if(ChronosData.byName[name] and handler) then
			ChronosData.byName[name].time = when+GetTime();
			ChronosData.byName[name].handler = handler;
			ChronosData.byName[name].arg = arg;
		else
			if ( not handler ) then
				if ( not ChronosData.byName[name] ) then
					Sea.io.derror(CH_DEBUG_T,"Chronos Error Detection: No handler specified to Chronos.scheduleByName, no previous entry found for scheduled entry.");
					return;
				end
				if ( not ChronosData.byName[name].handler ) then
					Sea.io.derror(CH_DEBUG_T,"Chronos Error Detection: No handler specified to Chronos.scheduleByName, no handler could be found in previous entry either.");
					return;
				end
				handler = ChronosData.byName[name].handler;
			end
			ChronosData.byName[name] = { time = when+GetTime(), handler = handler, arg = arg };
		end
	end;



	--[[
	--	unscheduleByName(name);
	--
	--		Removes an entry that was created with scheduleByName()
	--
	--	Args:
	--		name - the name used
	--
	--]]
	unscheduleByName = function(name)
		if ( not Chronos.online ) then 
			return;
		end
		if ( not name ) then 
			Sea.io.error("No name specified to Chronos.unscheduleByName");
			return;
		end
		if(ChronosData.byName[name]) then
			ChronosData.byName[name] = nil;
		end
		
		-- Debug print
		--Sea.io.dprint(CH_DEBUG, "Cancelled scheduled timer of name ",name);
	end;

	--[[
	--	isScheduledByName(name)
	--		Returns the amount of time left if it is indeed scheduled by name!
	--
	--	returns:
	--		number - time remaining
	--		nil - not scheduled
	--
	--]]
	isScheduledByName = function (name)
		if ( not Chronos.online ) then 
			return;
		end
		if ( not name ) then 
			Sea.io.error("No name specified to Chronos.isScheduledByName ", this:GetName());
			return;
		end
		if(ChronosData.byName[name]) then
			return ChronosData.byName[name].time - GetTime();
		end
		
		-- Debug print
		--Sea.io.dprint(CH_DEBUG, "Did not find timer of name ",name);
		return nil;
	end;

	--[[
	--	Chronos.startTimer([ID]);
	--		Starts a timer on a particular
	--
	--	Args
	--		ID - optional parameter to identify who is asking for a timer.
	--		
	--		If ID does not exist, this:GetName() is used. 
	--
	--	When you want to get the amount of time passed since startTimer(ID) is called, 
	--	call getTimer(ID) and it will return the number in seconds. 
	--
	--]]
	startTimer = function ( id ) 
		if ( not Chronos.online ) then 
			return;
		end

		if ( not id ) then 
			id = this:GetName();
		end

		-- Create a table for this id's timers
		if ( not ChronosData.timers[id] ) then
			ChronosData.timers[id] = {};
			ChronosData.timers[id].n = 0;
		end

		-- Clear out an entry if the table is too big.
		if (ChronosData.timers[id].n > Chronos.MAX_TASKS_PER_FRAME) then
			Sea.io.print("Too many Chronos timers created for id ",id);
			return;
		end

		-- Add a new timer entry 
		Sea.table.push(ChronosData.timers[id],GetTime());
	end;


	--[[
	--	endTimer([id]);
	-- 
	--		Ends the timer and returns the amount of time passed.
	--
	--	args:
	--		id - ID for the timer. If not specified, then ID will
	--		be this:GetName()
	--
	--	returns:
	--		(Number delta, Number start, Number end)
	--
	--		delta - the amount of time passed in seconds.
	--		start - the starting time 
	--		now - the time the endTimer was called.
	--]]

	endTimer = function( id ) 
		if ( not Chronos.online ) then 
			return;
		end

		if ( not id ) then 
			id = this:GetName();
		end

		if ( not ChronosData.timers[id] or ChronosData.timers[id].n == 0) then
			return nil;
		end
	
		local now = GetTime();

		-- Grab the last timer called
		local startTime = Sea.table.pop(ChronosData.timers[id]);

		return (now - startTime), startTime, now;
	end;


	--[[
	--	getTimer([id]);
	-- 
	--		Gets the timer and returns the amount of time passed.
	--		Does not terminate the timer.
	--
	--	args:
	--		id - ID for the timer. If not specified, then ID will
	--		be this:GetName()
	--
	--	returns:
	--		(Number delta, Number start, Number end)
	--
	--		delta - the amount of time passed in seconds.
	--		start - the starting time 
	--		now - the time the endTimer was called.
	--]]

	getTimer = function( id ) 
		if ( not Chronos.online ) then 
			return;
		end

		if ( not id ) then 
			id = this:GetName();
		end

		local now = GetTime();
		if ( not ChronosData.timers[id] or ChronosData.timers[id].n == 0) then
			return 0,0,now;
		end
	
		-- Grab the last timer called
		local startTime = ChronosData.timers[id][ChronosData.timers[id].n];

		return (now - startTime), startTime, now;
	end;
	
	--[[
	--	isTimerActive([id])
	--		returns true if the timer exists. 
	--		
	--	args:
	--		id - ID for the timer. If not specified, then ID will
	--		be this:GetName()
	--
	--	returns:
	--		true - exists
	--		false - does not
	--]]
	isTimerActive = function ( id ) 
		if ( not Chronos.online ) then 
			return;
		end

		if ( not id ) then 
			id = this:GetName();
		end

		-- Create a table for this id's timers
		if ( not ChronosData.timers[id] ) then
			return false;
		end

		return true;
	end;

	--[[
	--	getTime()
	--
	--		returns the Chronos internal elapsed time.
	--
	--	returns:
	--		(elaspedTime)
	--		
	--		elapsedTime - time in seconds since Chronos initialized
	--]]
	
	getTime = function() 
		return ChronosData.elapsedTime;
	end;

	--[[
	--	Chronos.everyFrame(func,arg1,...)
	--
	--		runs func(arg1,...) every frame until func returns true.
	--		This is the most effecient way to have something run 
	--		every frame, either forever, or until some job is done.
	--
	--	By Thott
	--]]
	everyFrame = function(func,...)
		Sea.table.push(ChronosData.everyFrame,{func=func,arg=arg});
	end;

	--[[
	--	performTask( TaskObject );
	--		
	--		Queues up a task to be completed over time. 
	--		Contains a before and after function 
	--		to be called when the task is started and
	--		completed.
	--		
	--	Args:
	--		TaskObject - a table containing:
	--		{
	--		 (Required:)
	--		  step - function to be performed, must be fast
	--
	--		  isDone - function which determines if the 
	--		  	task is completed. 
	--		  	Returns true when done
	--		  	Returns false if the task should continue
	--		  	 to call step() each frame. 
	--		  
	--
	--		 (Optional:)
	--		  stepArgs - arguments to be passed to step
	--		  doneArgs - arguments to be passed to isDone
	--
	--		  before - function called before the first step
	--		  beforeArgs - arguments passed to Before
	--
	--		  after - function called when isDone returns true
	--		  afterArgs - arguments passed
	--
	--		  limit - a number defining the maximum number
	--		  	of steps that will be peformed before
	--		  	the task is removed to prevent lag.
	--		  	(Defaults to 100)
	--		}
	--]]

	performTask = function (taskTable, name) 
		if ( not Chronos.online ) then 
			return;
		end

		-- Valid table?
		if ( not taskTable ) then
			Sea.io.error ("Chronos Error Detection: Invalid table to Chronos.peformTask", this:GetName());
			return nil;
		end

		-- Must contain a step function
		if ( not taskTable.step or type(taskTable.step) ~= "function" ) then 
			Sea.io.derror(CH_DEBUG_T,"Chronos Error Detection: You must specify a step function to be called to perform the task. (",this:GetName(),")");
			return nil;
		end
		
		-- Must contain a completion function
		if ( not taskTable.isDone or type(taskTable.isDone) ~= "function" ) then 
			Sea.io.derror(CH_DEBUG_T,"Chronos Error Detection: You must specify an isDone function to be called to indicate if the task is complete. (",this:GetName(),")");
			return nil;
		end

		-- Get an ID
		if ( not name ) then 
			name = this:GetName();
		end

		-- Set the limit
		if ( not taskTable.limit ) then 
			taskTable.limit = Chronos.MAX_STEPS_PER_TASK;
		end
		
		local foundId = nil;

		for i=1,table.getn(ChronosData.tasks) do 
			if ( ChronosData.tasks[i].name == id ) then 
				foundId = i;
			end
		end
		
		-- Add it to the task list
		if ( not foundId ) then 
			taskTable.name = name;
			table.insert(ChronosData.tasks, taskTable);
			return true;
		elseif ( not ChronosData.tasks[foundId].errorSent ) then
			ChronosData.tasks[foundId].errorSent = true;
			Sea.io.error ("Chronos Error Detection: There's already a task with the ID: ", name );
			return nil;
		end
	end;

	--[[
	--	Chronos.afterInit(func, ...)
	--		Performs func after the game has truely started.
	--	By Thott
	--]]
	afterInit = function (func, ...)
		local id;
		if(this) then
			id = this:GetName();
		else
			id = "unknown";
		end
		--if(id == "SkyFrame") then
		--	Sea.io.print("Ignoring Sky init");
		--	return;
		--end
		if(ChronosData.initialized) then
			func(unpack(arg));
		else
			if(not ChronosData.afterInit) then
				ChronosData.afterInit = {};
				ChronosData.afterInit.n = 0;
				Chronos.schedule(0.2,Chronos_InitCheck);
			end
			local n = ChronosData.afterInit.n;
			n = n + 1;
			ChronosData.afterInit[n] = {};
			ChronosData.afterInit[n].func = func;
			ChronosData.afterInit[n].args = arg;
			ChronosData.afterInit[n].id = id;
			ChronosData.afterInit.n = n;
		end
	end;
};

--[[ Event Handlers ]]--
function Chronos_OnLoad()
	Chronos.framecount = 0;

	ChronosData.byName = {};
	ChronosData.tasks = {};
	ChronosData.tasks.n = 0;
	ChronosData.sched = {};
	ChronosData.sched.n = 0;
	ChronosData.elapsedTime = 0;
	ChronosData.variablesLoaded = false;
	ChronosData.everyFrame = {};
	ChronosData.everyFrame.n = 0;

	--[[ Convert Revision to Numeric ]]--
	if (convertRev) then
		convertRev("CHRONOS_REV");
	end

	Chronos.afterInit(Chronos_SkyRegister);
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function Chronos_OnEvent(event)
	if(event == "VARIABLES_LOADED") then
		ChronosData.variablesLoaded = true;
		ChronosFrame:Show();
	elseif (event == "PLAYER_ENTERING_WORLD") then
		ChronosData.enteredWorld = true;
	end	
end

function Chronos_InitCheck()
	if(not ChronosData.initialized) then
		if(UnitName("player") and UnitName("player")~=UKNOWNBEING and UnitName("player")~=UNKNOWNBEING and UnitName("player")~=UNKNOWNOBJECT and ChronosData.variablesLoaded and ChronosData.enteredWorld) then
			ChronosData.initialized = true;
			Chronos.schedule(1,Chronos_InitCheck); 
			return;
		else
			Chronos.schedule(0.2,Chronos_InitCheck); 
			return;
		end
	end
	if(ChronosData.afterInit) then
		local i = ChronosData.afterInit_i;
		if(not i) then
			i = 1;
		end
		ChronosData.afterInit_i = i+1;
		--Sea.io.print("afterInit: processing ",i," of ",ChronosData.afterInit.n," initialization functions, id: ",ChronosData.afterInit[i].id);
		Chronos_Run(ChronosData.afterInit[i].func,ChronosData.afterInit[i].args);
		if(i == ChronosData.afterInit.n) then
			ChronosData.afterInit = nil;
			ChronosData.afterInit_i = nil;
		else
			Chronos.schedule(0.1,Chronos_InitCheck);
			return;
		end
	end
end;
function Chronos_Run(func,arg)
	if(func) then
		if(arg) then
			return func(unpack(arg));
		else
			return func();
		end
	end
end
function Chronos_Swap(i,j)
	local t = ChronosData.sched[i];
	ChronosData.sched[i] = ChronosData.sched[j];
	ChronosData.sched[j] = t;
end
function Chronos_PopTask()
	if(ChronosData.sched.n == 1) then
		ChronosData.sched.n = 0;
		return 1;
	end
	Chronos_Swap(1,ChronosData.sched.n);
	ChronosData.sched.n = ChronosData.sched.n - 1;
	local i = 1;
	local new;
	while(ChronosData.sched[i] and i <= ChronosData.sched.n) do
		new = i*2;
		if(new > ChronosData.sched.n) then
			break;
		elseif(new < ChronosData.sched.n) then
			if(ChronosData.sched[new+1].time < ChronosData.sched[new].time) then
				new = new + 1;
			end
		end
		if(ChronosData.sched[new].time < ChronosData.sched[i].time) then
			Chronos_Swap(i,new);
			i = new;
		else
			break;
		end
	end
	return ChronosData.sched.n+1;
end

--function memcheck(memstart,where)
--	local memend = gcinfo();
--	if(memstart ~= memend) then
--		Sea.io.print("Memory change in ",where,": ",memstart,"->",memend," = ",memend-memstart);
--	end
--	return gcinfo();
--end
function Chronos_OnUpdate(dt)
	--local memstart = gcinfo();
	if ( not Chronos.online ) then 
		return;
	end
	if ( ChronosData.variablesLoaded == false ) then 
		return;
	end
	
	if ( ChronosData.elapsedTime ) then
		ChronosData.elapsedTime = ChronosData.elapsedTime + dt;
	else
		ChronosData.elapsedTime = dt;
	end

	local timeThisUpdate = 0;
	local largest = 0;
	local largestName = nil;

	-- execute all the everyFrame tasks, deleting any that return true. --Thott
	for i=1,ChronosData.everyFrame.n do
		if(Chronos_Run(ChronosData.everyFrame[i].func,ChronosData.everyFrame[i].arg)) then
			-- delete
			ChronosData.everyFrame[i] = Sea.table.pop(ChronosData.everyFrame);
		end
	end

	local now = GetTime();
	local i;
	-- Execute scheduled tasks that are ready, popping them off the heap. --Thott
	while(ChronosData.sched.n > 0) do
		if(ChronosData.sched[1].time <= now) then
			i = Chronos_PopTask();
			Chronos_Run(ChronosData.sched[i].handler,ChronosData.sched[i].args);
		else
			break;
		end
	end
	local memstart = gcinfo();
	local k,v = next(ChronosData.byName);
	local newK, newV;
	while (k ~= nil) do
		newK,newV = next(ChronosData.byName, k);
		if(v.time <= now) then
			ChronosData.byName[k] = nil;
			local m = gcinfo();
			Chronos_Run(v.handler,v.arg);
			local mm = gcinfo();
			memstart = memstart + mm - m;
		end
		k,v = newK,newV;
	end
	local memend = gcinfo();
	if(memend - memstart > 0) then
		Sea.io.print("gcmemleak from ChronosData.byName in OnUpdate: ",memend - memstart);
	end

	local largest = 0;
	local largestName = nil;

	-- Perform tasks if the time limit is not exceeded
	-- Only perform each task once at most per update
	-- 
	--memstart = memcheck(memstart,"OnUpdate, after all scheduled tasks, before Chronos tasks");
	local ctn = table.getn(ChronosData.tasks);
	for i=1, ctn do
		-- Perform a task
		runTime = Chronos_OnUpdate_Tasks(timeThisUpdate);
		timeThisUpdate = timeThisUpdate + runTime;

		-- Check if this was the biggest hog yet
		if ( runTime > largest ) then 
			largest = runTime;
			largestName = i;
		end

		-- Check if we've overrun our limit
		if ( timeThisUpdate > Chronos.MAX_TIME_PER_STEP ) then
			Sea.io.derror(CH_DEBUG_T,"Chronos Warning: Maximum cpu usage time exceeded on task. Largest task was: ", largestName );
			break
		end

		if ( largestName ) then
			-- ### Remove later for efficiency
			--Sea.io.dprint(CH_DEBUG, " Largest named task: ", largestName );
		end
	end
	--memstart = memcheck(memstart,"OnUpdate, end");
end

-- Updates a single task
function Chronos_OnUpdate_Tasks(timeThisUpdate)
	if ( not Chronos.online ) then 
		return;
	end

	-- Lets start the timer
	Chronos.startTimer();

	-- Execute the first task
	if ( ChronosData.tasks[1] ) then
		-- Obtains the first task
		local task = table.remove(ChronosData.tasks, 1);

		-- Start the task if not yet started
		if ( not task.started ) then 
			Chronos_Run(task.before,task.beforeArgs);

			-- Mark the task as started
			task.started = true;
		end

		-- Perform a step in the task
		Chronos_Run(task.step,task.stepArgs);
			
		-- Check if the task is completed.
		if ( task.isDone() ) then
			-- Call the after-task
			if ( task.after ) then
				if ( task.afterArgs ) then 
					task.after(unpack(task.afterArgs) );
				else
					task.after();
				end
			end
		else
			if ( not task.count ) then 
				task.count = 1; 
			else
				task.count = task.count + 1; 				
			end

			if ( task.count < task.limit ) then 
				-- Move them to the back of the list
				table.insert(ChronosData.tasks, task);
			else
				Sea.io.derror(CH_DEBUG_T, "Task killed due to limit-break: ", task.name ); 
			end
		end
	end

	-- End the timer
	return Chronos.endTimer();		
end

-- Command Registration
-- Notes to self: 
-- 	* Relocate to its own module?
-- 	

function Chronos_SkyRegister()
	local chronosFunc = function(msg)
		local _,_,seconds,command = string.find(msg,"([%d\.]+)%s+(.*)");
		if(seconds and command) then
			Chronos.schedule(seconds,Chronos_SendChatCommand,command);
		else
			Sea.io.print(SCHEDULE_USAGE1);
			Sea.io.print(SCHEDULE_USAGE2);
		end
	end
	if(Sky) then
		Sky.registerSlashCommand(
			{
				id = "Schedule";
				commands = SCHEDULE_COMM;
				onExecute = chronosFunc;
				helpText = SCHEDULE_DESC;
			}
		);
	else
		SlashCmdList["CHRONOS_SCHEDULE"] = chronosFunc;
		for i = 1, table.getn(SCHEDULE_COMM) do setglobal("SLASH_CHRONOS_SCHEDULE"..i, SCHEDULE_COMM[i]); end
	end
end

--[[
--	Sends a chat command through the standard 
--]]
function Chronos_SendChatCommand(command)
	local text = ChatFrameEditBox:GetText();
	ChatFrameEditBox:SetText(command);
	ChatEdit_SendText(ChatFrameEditBox);
	ChatFrameEditBox:SetText(text);
end

