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
--	$LastChangedBy: AlexYoshi $
--	$Date: 2005-03-04 16:52:24 +0100 (Fri, 04 Mar 2005) $
--	$Rev: 927 $
--	
--]]

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

	-- Last ID
	lastID = nil;
	
	-- Initialize the Timers
	timers = {};

	-- Intialize the anonymous todo list
	anonTodo = {};

	-- Initialize the named todo list
	namedTodo = {};

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
		
		
		-- Assign an id
		local id = "";
		if ( not this ) then 
			id = "Keybinding";
		else
			id = this:GetName();
		end
		if ( not id ) then 
			id = "_DEFAULT";
		end
		if ( not when ) then 
			Sea.io.derror(CH_DEBUG_T, "Chronos Error Detection: ", id , " has sent no interval for this function. ", when );
			return;
		end

		-- Ensure we're not looping ChronosFrame
		if ( id == "ChronosFrame" and ChronosData.lastID ) then 
			id = ChronosData.lastID;
		end

		-- Create the new task
		local todo = {};
		todo.time = when + GetTime();
		todo.handler = handler;
		todo.args = arg;

		-- Create a new table if one does not exist
		if ( not ChronosData.anonTodo[id] ) then
			ChronosData.anonTodo[id] = {};
		end
		
		-- Find the correct index within the frame's table
		local i = 1;
		while(ChronosData.anonTodo[id][i] and
			ChronosData.anonTodo[id][i].time < todo.time) do
			i = i + 1;
		end
		
		-- Add the new task for the current frame
		table.insert(ChronosData.anonTodo[id],i,todo);

		--
		-- Ensure we don't have too many events
		--	(For now, we just ignore it and pop a message)
		--	
		if ( table.getn(ChronosData.anonTodo[id] ) > Chronos.MAX_TASKS_PER_FRAME 
			and not ChronosData.anonTodo[id].errorSent ) then
			Sea.io.derror(CH_DEBUG_T, "Chronos Error Detection: ", id , " has scheduled too many events. Please report this to the Developers, as it may cause your interface to lag. " );
			ChronosData.anonTodo[id].errorSent = true;
		end
		
		-- Debug print
		Sea.io.dprint(CH_DEBUG, "Scheduled ", handler," in ",when," seconds from ", id );
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
	scheduleByName = function (name, when,handler,...)
		if ( not Chronos.online ) then 
			return;
		end

		-- Assign an id
		if ( not name ) then 
			Sea.io.derror(CH_DEBUG_T,"Chronos Error Detection: No name specified to Chronos.scheduleByName");
			return;
		end

		-- Ensure the table exists
		if ( not ChronosData.namedTodo ) then
			ChronosData.namedTodo = {};
		end
		
		-- Check if a named entry already exists
		local i;
		for i=1, table.getn(ChronosData.namedTodo), 1 do
			if(ChronosData.namedTodo[i].name and ChronosData.namedTodo[i].name == name) then
				entry = table.remove(ChronosData.namedTodo,i);

				-- Allow you to do scheduleByName("name", 12);
				if ( not handler ) then
					handler = entry.handler;
				end
				break;
			end
		end
		
		-- Create the new task
		local todo = {};
		todo.time = when + GetTime();
		todo.handler = handler;
		todo.args = arg;
		todo.name = name;

		-- Find the correct index within the frame's table
		local i = 1;
		while(ChronosData.namedTodo[i] and
			ChronosData.namedTodo[i].time < todo.time) do
			i = i + 1;
		end
		
		-- Add the new task for the current frame
		table.insert(ChronosData.namedTodo,i,todo);
		
		-- Debug print
		Sea.io.dprint(CH_DEBUG, "Scheduled by name ",name, ",", handler," in ",when," seconds");
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

		-- Assign an id
		if ( not name ) then 
			Sea.io.error("No name specified to Chronos.scheduleByName");
			return;
		end

		-- Ensure the table exists
		if ( not ChronosData.namedTodo ) then
			return;
		end
		
		-- Check if a named entry already exists
		local i;
		for i=1, table.getn(ChronosData.namedTodo), 1 do
			if(ChronosData.namedTodo[i].name and ChronosData.namedTodo[i].name == name) then
				table.remove(ChronosData.namedTodo,i);
				break;
			end
		end
		
		-- Debug print
		Sea.io.dprint(CH_DEBUG, "Cancelled scheduled timer of name ",name);
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

		-- Assign an id
		if ( not name ) then 
			Sea.io.error("No name specified to Chronos.isScheduledByName ", this:GetName());
			return;
		end

		-- Ensure the table exists
		if ( not ChronosData.namedTodo ) then
			return;
		end
		
		-- Check if a named entry already exists
		local i;
		for i=1, table.getn(ChronosData.namedTodo), 1 do
			if(ChronosData.namedTodo[i].name and ChronosData.namedTodo[i].name == name) then
				return (ChronosData.namedTodo[i].time - GetTime());
			end
		end
		
		-- Debug print
		Sea.io.dprint(CH_DEBUG, "Did not find timer of name ",name);
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
		end

		-- Clear out an entry if the table is too big.
		if ( table.getn(ChronosData.timers[id]) >= Chronos.MAX_TASKS_PER_FRAME ) then
			table.remove(ChronosData.timers[id], 1 );
		end

		-- Add a new timer entry 
		table.insert(ChronosData.timers[id], GetTime() );		
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

		-- Create a table for this id's timers
		if ( not ChronosData.timers[id] ) then
			ChronosData.timers[id] = {};
		end
	
		-- Check to see if there is any timers started
		if ( table.getn(ChronosData.timers[id]) == 0 ) then
			return 0, GetTime(), GetTime();
		end

		-- Grab the last timer called
		local startTime = table.remove ( ChronosData.timers[id] );
		local now = GetTime();

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

		-- Create a table for this id's timers
		if ( not ChronosData.timers[id] ) then
			ChronosData.timers[id] = {};
		end
	
		-- Check to see if there is any timers started
		if ( table.getn(ChronosData.timers[id]) == 0 ) then
			return 0, GetTime(), GetTime();
		end

		-- Grab the last timer called
		local startTime = ChronosData.timers[id][table.getn(ChronosData.timers[id])];
		local now = GetTime();

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
	--]]
	afterInit = function (func, ...)
		if(UnitName("player") and UnitName("player")~=UKNOWNBEING and UnitName("player")~=UNKNOWNBEING and UnitName("player")~=UNKNOWNOBJECT and ChronosData.variablesLoaded) then
			func(unpack(arg));
		else
			Chronos.schedule(0.2,Chronos.afterInit,func,unpack(arg));
		end
	end;
};

--[[ Event Handlers ]]--
function Chronos_OnLoad()
	ChronosData.elapsedTime = 0;
	ChronosData.variablesLoaded = false;
	Chronos.afterInit(Chronos_SkyRegister);
	this:RegisterEvent("VARIABLES_LOADED");	
end

function Chronos_OnEvent(event)
	if(event == "VARIABLES_LOADED") then
		ChronosData.variablesLoaded = true;
		ChronosFrame:Show();
	end	
end

function Chronos_OnUpdate(dt)
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

	if ( not ChronosData.anonTodo ) then 
		ChronosData.anonTodo = {};
	end

	-- Handle Anonymous Scheduled Tasks
	for k,v in ChronosData.anonTodo do 
		ChronosData.lastID = k;
		-- Call all handlers whose time has been exceeded
		while(v[1] and v[1].time <= GetTime()) do
			-- Lets start the timer
			Chronos.startTimer();

			
			local todo = table.remove(v,1);
			if(todo.args) then
				if ( todo.handler ) then 
					todo.handler(unpack(todo.args));
				end
			else
				if ( todo.handler ) then 
					todo.handler();
				end
			end
			-- End the timer
			local runTime = Chronos.endTimer();
		
			-- Update the elapsed time
			timeThisUpdate = timeThisUpdate + runTime;

			-- Check if this was the biggest hog yet
			if ( runTime > largest ) then 
				largest = runTime;
				largestName = k;
			end

			-- Check if we've overrun our limit
			if ( timeThisUpdate > Chronos.MAX_TIME_PER_STEP ) then
				Sea.io.derror(CH_DEBUG_T,"Chronos Warns: Maximum cpu time usage exceeded by an Addon. Largest was: ", largestName );
				break;
			end
		end	

		-- Clean out the table
		if ( table.getn(v) == 0 ) then 
			ChronosData.anonTodo[k] = nil;
		end
	end

	-- ### Remove later for efficiency
	if ( largestName ) then
		Sea.io.dprint(CH_DEBUG, " Largest anonymous task: ", largestName, ", ", largest);
	end

	
	-- Handle Named
	-- Call all handlers whose time has been exceeded
	while( ChronosData.namedTodo[1] and 
		ChronosData.namedTodo[1].time <= GetTime()) do
		
		-- Lets start the timer
		Chronos.startTimer();

		-- Lets perform the action
		local todo = table.remove(ChronosData.namedTodo,1);
		if(todo.args) then
			todo.handler(unpack(todo.args));
		else
			todo.handler();
		end
		
		-- End the timer
		local runTime = Chronos.endTimer();
		
		-- Update the elapsed time
		timeThisUpdate = timeThisUpdate + runTime;

		-- Check if this was the biggest hog yet
		if ( runTime > largest ) then 
			largest = runTime;
			largestName = todo.name;
		end

		-- Check if we've overrun our limit
		if ( timeThisUpdate > Chronos.MAX_TIME_PER_STEP ) then
			Sea.io.derror(CH_DEBUG_T,"Chronos Warning: Maximum cpu time-limit exceeded. Largest was: ", largestName );
			break;
		end

		-- ### Remove later for efficiency
		Sea.io.dprint(CH_DEBUG, " Largest named task: ", todo.name );
	end
		
	local largest = 0;
	local largestName = nil;

	-- Perform tasks if the time limit is not exceeded
	-- Only perform each task once at most per update
	-- 
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
			Sea.io.dprint(CH_DEBUG, " Largest named task: ", largestName );
		end
	end		
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
			if ( task.before ) then
				if ( task.beforeArgs ) then
					task.before(unpack(task.beforeArgs));
				else
					task.before();
				end
			end

			-- Mark the task as started
			task.started = true;
		end

		-- Perform a step in the task
		if ( task.stepArgs ) then
			task.step(unpack(task.stepArgs));
		else
			task.step();
		end
			
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

-- UltimateUI Registrations
-- Notes to self: 
-- 	* Change to Sky Registration
-- 	* Relocate to its own module?
-- 	

function Chronos_SkyRegister()
	if(Sky) then
		local comlist = SCHEDULE_COMM;
		local desc = SCHEDULE_DESC;
		local id = "SCHEDULE";
		local func = function(msg)
			local i,j,seconds,command = string.find(msg,"([%d\.]+) (.*)");
			if(seconds and command) then
				Chronos.schedule(seconds,Chronos_SendChatCommand,command);
			else
				Sea.io.print(SCHEDULE_USAGE1);
				Sea.io.print(SCHEDULE_USAGE2);
			end
		end
		Sky.registerSlashCommand(
			{
			id=id;
			commands=comlist;
			onExecute=func;
			description=desc;
			}
		);
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

