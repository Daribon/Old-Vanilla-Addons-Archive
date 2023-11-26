-- Cosmos Scheduling functions
-- Written by Thott
--
-- Usage: Cosmos_Schedule(when,handler,arg1,arg2,etc)
--
-- After <when> seconds pass (values less than one and fractional values are
-- fine), handler is called with the specified arguments, i.e.:
--   handler(arg1,arg2,etc)
--
-- If you'd like to have something done every X seconds, reschedule
-- it each time in the handler.
--

function Cosmos_Schedule(when,handler,...)
  local todo = {};
  todo.time = when + GetTime();
  todo.handler = handler;
  todo.args = arg;
  local i = 1;
  while(CosmosSchedule.Todo[i] and
  	CosmosSchedule.Todo[i].time < todo.time) do
    i = i + 1;
  end
  table.insert(CosmosSchedule.Todo,i,todo);
  if(CosmosSchedule.Debug) then
    dprint("scheduled ",handler," in ",when," seconds");
  end
end

CosmosScheduleByNameLastElement = nil;

-- same as Cosmos_Schedule, except it takes a schedule name argument.
-- Only one event can be scheduled with a given name at any one time.
-- Thus if one exists, and another one is scheduled, the first one
-- is deleted, then the second one added.
function Cosmos_ScheduleByName(name,when,handler,...)
  local i;
  for i=1, CosmosSchedule.Todo.n, 1 do
    if(CosmosSchedule.Todo[i].name and CosmosSchedule.Todo[i].name == name) then
      table.remove(CosmosSchedule.Todo,i);
      break;
    end
  end
  local todo = {};
  todo.time = when + GetTime();
  todo.handler = handler;
  todo.name = name;
  todo.args = arg;
  local i = 1;
  while(CosmosSchedule.Todo[i] and
  	CosmosSchedule.Todo[i].time < todo.time) do
    i = i + 1;
  end
  table.insert(CosmosSchedule.Todo,i,todo);
  CosmosScheduleByNameLastElement = todo;
  if(CosmosSchedule.Debug) then
    dprint("scheduled by name ",name,", ",handler,", in ",when," seconds");
  end
end
-- Cosmos_AfterInit(function,arg,arg...)
-- calls a function (with arguments) once the client is fully initialized.  
-- In this case, "fully initialized" means UnitName("player") != "Unknown Being"
-- and VARIABLES_LOADED event occurred
function Cosmos_AfterInit(func,...)
  if(UnitName("player") and UnitName("player") ~= "Unknown Being" and CosmosSchedule.Variables_Loaded) then
    func(unpack(arg));
  else
    Cosmos_Schedule(0.2,Cosmos_AfterInit,func,unpack(arg));
  end
end

function CosmosSchedule_OnLoad()
  CosmosSchedule.Todo = {};
  CosmosSchedule.Todo.n = 0;
  CosmosSchedule.Variables_Loaded = false;
  this:RegisterEvent("VARIABLES_LOADED");

  Cosmos_Schedule(0.1,CosmosSchedule_Register);
  if ( Cosmos_SendPartyMessage ) then 
	Cosmos_Schedule ( 10, Cosmos_SendPartyMessage, "<AC>"); -- Ask for Cosmos
  end
end
function CosmosSchedule_OnEvent(event)
  if(event == "VARIABLES_LOADED") then
    CosmosSchedule.Variables_Loaded = true;
  end
end
function CosmosSchedule_Register()
  if(Cosmos_RegisterChatCommand) then
    local comlist = SCHEDULE_COMM;
    local desc  = SCHEDULE_DESC;
    local id = "SCHEDULE";
    local func = function(msg)
      local i,j,seconds,command = string.find(msg,"([%d\.]+) (.*)");
      if(seconds and command) then
	Cosmos_Schedule(seconds,CosmosSchedule_ChatCommand,command);
      else
	print1(SCHEDULE_USAGE1);
	print1(SCHEDULE_USAGE2);
      end
    end
    function CosmosSchedule:GetText()
      return CosmosSchedule.text;
    end
    Cosmos_RegisterChatCommand ( id, comlist, func, desc );
  end
end

function CosmosSchedule_ChatCommand(command)
  --CosmosSchedule.text = command;
  --ChatEdit_ParseText(CosmosSchedule,1);
  local text = ChatFrameEditBox:GetText();
  ChatFrameEditBox:SetText(command);
  ChatEdit_SendText(ChatFrameEditBox);
  ChatFrameEditBox:SetText(text);
end

function CosmosSchedule_OnUpdate()
  while(CosmosSchedule.Todo[1] and 
	CosmosSchedule.Todo[1].time <= GetTime()) do
    local todo = table.remove(CosmosSchedule.Todo,1);
    if(todo.args) then
      todo.handler(unpack(todo.args));
    else
      todo.handler();
    end
  end
end
