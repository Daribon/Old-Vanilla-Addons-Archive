--[[
	An Example Add-On using Cosmos Values

	By Alexander Brazie (AlexYoshi)

	The purpose of this script is to give a demonstration of how 
	to write a mod which uses the Cosmos features. 
	
	Uhm, otherwise this mod does absolutely nothing. 

	No, really. Its just a demonstration. 
   ]]

Vickel_Time = 0;
Vickel_Columns = 16;
Vickel_Rows = 4;
Vickel_IdleAnimation = 1;
Vickel_IdleSpeed = 5; -- Default value
Vickel_Texture_Width = 1 / Vickel_Columns;
Vickel_Texture_Height = 1 / Vickel_Rows;

-- Set a debug output
VICKEL_DEBUG_TOGGLE = 0;
VICKEL_DEBUG = "VICKEL_DEBUG_TOGGLE";

Vickel_GFX = {
['HEAD_LEFT'] = { 1, 1 };
['HEAD_RIGHT'] = { 1, 2 };
['HEAD_FRONT'] = { 1, 3 };
['HEAD_BACK'] = { 1, 4 };

['BODY_STAND_LEFT'] = { 2, 1 };
['BODY_STAND_RIGHT'] = { 2, 2 };
['BODY_STAND_FRONT'] = { 2, 3 };
['BODY_STAND_BACK'] = { 2, 4 };

['BODY_WALK_LEFT_1'] = { 2, 5 };
['BODY_WALK_RIGHT_1'] = { 2, 6 };
['BODY_WALK_FRONT_1'] = { 2, 7 };
['BODY_WALK_BACK_1'] = { 2, 8 };

['BODY_WALK_LEFT_2'] = { 3, 1 };
['BODY_WALK_RIGHT_2'] = { 3, 2 };
['BODY_WALK_FRONT_2'] = { 3, 3 };
['BODY_WALK_BACK_2'] = { 3, 4 };

['BODY_JUMP_LEFT'] = { 3, 7 };
['BODY_JUMP_RIGHT'] = { 3, 6 };
['BODY_JUMP_FRONT'] = { 3, 5 };
['BODY_JUMP_BACK'] = { 3, 8 };

['BODY_HURT_LEFT'] = { 4, 3 };
['BODY_HURT_RIGHT'] = { 4, 2 };
['BODY_HURT_FRONT'] = { 4, 1 };
['BODY_HURT_BACK'] = { 4, 4 };

['BODY_VANISH_1'] = { 4, 5 };
['BODY_VANISH_2'] = { 4, 6 };
['BODY_VANISH_3'] = { 4, 7 };
['BODY_VANISH_4'] = { 4, 8 };

['BODY_FLY_BACK'] = { 1, 9 };
['BODY_FLY_FRONT'] = { 2, 9 };
['BODY_FLY_LEFT'] = { 2, 10 };
['BODY_FLY_RIGHT'] = { 2, 11 };

['HEAD_FLY_LEFT'] = { 1, 10 };
['HEAD_FLY_RIGHT'] = { 1, 11 };
['HEAD_FLY_FRONT'] = { 3, 9 };
['HEAD_FLY_BACK'] = { 3, 10 };
};

-- Vickel State values
Vickel_Cosmos_Debug = 0;
Vickel_Cosmos_Party_Debug = 0;
Vickel_Mem_Watch = 0;

-- General Cosmos Registration Functions
function Vickel_RegisterCosmos()

	--
	-- Check for the functions before calling them. 
	--
	-- This will make it possible to keep the add-on
	-- independent of Cosmos Core
	-- 
	if ( Cosmos_RegisterConfiguration ) then 

		Cosmos_RegisterConfiguration(
			"COS_VICKEL",
			"SECTION",
			VICKEL_CONFIG_HEADER,
			VICKEL_CONFIG_HEADER_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_VICKEL_HEADER",
			"SEPARATOR",
			VICKEL_CONFIG_HEADER,
			VICKEL_CONFIG_HEADER_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_VICKEL_TOGGLE", -- CVAr
			"CHECKBOX",
			VICKEL_CONFIG_ONOFF,
			VICKEL_CONFIG_ONOFF_INFO,
			Vickel_PowerSwitch,
			0
			);
	 	Cosmos_RegisterConfiguration(
 			"COS_VICKEL_IDLESPEED", --CVar
 			"BOTH",	 --CHECKBOX, SLIDER (or BOTH), BUTTON, SEPARATOR
	 		VICKEL_CONFIG_IDLE,	 --Short Description String
 			VICKEL_CONFIG_IDLE_INFO,  -- Long Description 
	 		Vickel_IdleConfigUpdate, --Callback
 			Vickel_IdleAnimation,	 --Default Checked/Unchecked (1 = checked)
 			Vickel_IdleSpeed,	 --Default Value
	 		1,	 --Min value
 			10,	 --Max value
 			VICKEL_CONFIG_IDLE_SLIDER, --Slider Text
	 		1,		 --Slider Increment
 			1,		 --Slider state text on/off
 			VICKEL_CONFIG_IDLE_SLIDER_TAG, --Slider state text append
	 		1		 --Slider state text multiplier 
 			);
		Cosmos_RegisterConfiguration(
			"COS_VICKEL_WATCHCOSMOS",
			"CHECKBOX",
			VICKEL_CONFIG_COSMOS,
			VICKEL_CONFIG_COSMOS_INFO,
			Vickel_WatchCosmosUpdate,
			0
			);
		Cosmos_RegisterConfiguration(
			"COS_VICKEL_WATCHCOSMOS_PARTY",
			"CHECKBOX",
			VICKEL_CONFIG_COSMOS_PARTY,
			VICKEL_CONFIG_COSMOS_PARTY_INFO,
			Vickel_WatchCosmosPartyUpdate,
			0
			);
	end

	-- Check for the button menu
	if ( Cosmos_RegisterButton ) then 
		Cosmos_RegisterButton ( 
			VICKEL_BUTTON_TEXT,    -- The Button Text
			VICKEL_BUTTON_SUBTEXT, -- The Button Subtext
			VICKEL_BUTTON_TIP,  -- The Button Mouse-over tooltip 
			"Interface\\Icons\\INV_Misc_MonsterHead_04", -- The Button image
			ToggleVickel -- The Function called when button is clicked
		);
	end

	-- Add /commands
	if ( Cosmos_RegisterChatCommand ) then
		Cosmos_RegisterChatCommand (
			"VICKEL_COMMANDS", -- Some Unique Group ID
			VICKEL_CHAT_COMMAND, -- The Commands
			Vickel_ChatCommandHandler,
			VICKEL_CHAT_COMMAND_INFO -- Description String
			);
			
			
	end
	-- Check for the chat watcher
	if ( Cosmos_RegisterChatWatch ) then 
		Cosmos_RegisterChatWatch(
			"VICKEL_WATCHES_COSMOS", -- A reminder for you when you have to debug this!
			{CHANNEL_COSMOS, CHANNEL_PARTY}, -- Chat types to watch
			Vickel_WatchCosmos  -- The parser function (return 1 if the message is displayed)
			);
		Cosmos_RegisterChatWatch(
			"VICKEL_WATCHES", -- A reminder for you when you have to debug this!
			{"COMBAT_HOSTILE_DEATH", "COMBAT_FRIENDLY_DEATH", "SPELL_PERIODIC_SELF_DAMAGE"}, -- Chat types to watch
			Vickel_WatchChat  -- The parser function (return 1 if the message is displayed)
			);			
	end
end

-- Make Menu Function
function Vickel_MakeMenu() 
	local vMenu = {};

	local item = {text="Hi";checked=1;isTitle=1;keepShownOnClick=1;owner=VickelFrame;};
	table.insert(vMenu, item);

	return vMenu;
end

-- Report periodically
function Vickel_MemWatch()
	Vickel_Speak(VICKEL_MEMORY_STRING..gcinfo()..VICKEL_MEMORY_STRING_END);
	Cosmos_ScheduleByName("VICKEL_MEMWATCH", 2, Vickel_MemWatch);
end


-- OnLoad Function
function Vickel_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButton", "RightButton");
	
	Vickel_Draw('HEAD_FRONT', 'BODY_STAND_FRONT');
	VickelText:AddMessage(VICKEL_DEFAULT_STRING);

	Vickel_RegisterCosmos();
end


-- OnClick Function
function Vickel_OnClick()
	Vickel_Speak(VICKEL_RESPONSE_STRING);

	CosmosMaster_MenuOpen(Vickel_MakeMenu(), 1, this, 0, 0);
end

-- OnMouseWheel
function Vickel_OnMouseWheel(ScrollDirection)
	-- If you mousewheel on vickel, view history. 
	if ( ScrollDirection == 1 ) then 
		VickelText:ScrollDown();
	elseif (ScrollDirection == -1 ) then 
		VickelText:ScrollUp();
	end
end

-- OnDragStart
function Vickel_OnDragStart()
	Vickel_Speak(VICKEL_WHEE_STRING);
end
-- OnDragEnd
function Vickel_OnDragEnd()
	Vickel_Speak(VICKEL_WHOA_STRING);
end

-- The Timing for Vickel
function Vickel_OnUpdate(arg1)
	Vickel_Time = Vickel_Time+arg1;

	if ( Vickel_IdleAnimation == 1 ) then 
		if (Vickel_Time > 4 * (Vickel_IdleSpeed/10)) then
			Vickel_Time = 0;
			Vickel_SetBody('BODY_WALK_FRONT_2');
		elseif (Vickel_Time > 3 * (Vickel_IdleSpeed/10)) then 
			Vickel_SetBody('BODY_STAND_FRONT');
		elseif (Vickel_Time > 2 * (Vickel_IdleSpeed/10)) then 
			Vickel_SetBody('BODY_WALK_FRONT_1');
		elseif (Vickel_Time > 1 * (Vickel_IdleSpeed/10)) then 
			Vickel_SetBody('BODY_STAND_FRONT');
		end
	end

	if ( gcinfo() > 30000 ) then 
		-- Show if hidden
		Vickel_PowerSwitch(1);
		
		Vickel_Speak(VICKEL_LOWMEMORY_STRING);
	end
end

-- Vickel /vickle command handler
function Vickel_ChatCommandHandler (msg)
	local found=0;
	msg = string.lower(msg);
	
	DebugPrint("VkDbg: Got Chat Message '"..msg.."'", VICKEL_DEBUG);

	-- Show if hidden
	Vickel_PowerSwitch(1);
	
	if ( string.find(msg, VICKEL_CHAT_C1) ) then 
		Vickel_Speak(VICKEL_HELLO_STRING);
		found = found + 1;
	end

	-- If the message contains cosmos
	if ( string.find(msg, VICKEL_CHAT_C2) ) then 
		-- Update the value in case the Cosmos mod is missing
		Vickel_Cosmos_Debug=1;
		
		-- Update the Cosmos configuration menu
		if ( Cosmos_UpdateValue ) then 
			Cosmos_UpdateValue('VICKEL_WATCH_COSMOS', CSM_VALUE, 1);
		end
		
		Vickel_Speak(VICKEL_COSMOS_WATCHING_STRING);
		found = found + 1;
	end
	if ( string.find(msg, VICKEL_CHAT_C3) ) then 
		-- Update the value in case the Cosmos mod is missing
		Vickel_Cosmos_Party_Debug=1;
		
		-- Update the Cosmos configuration menu
		if ( Cosmos_UpdateValue ) then 
			Cosmos_UpdateValue('VICKEL_WATCH_COSMOS_PARTY', CSM_VALUE, 1);
		end
		
		Vickel_Speak(VICKEL_COSMOS_PARTY_WATCHING_STRING);
		found = found + 1;
	end
	-- Display the memory spent.
	if ( string.find(msg, VICKEL_CHAT_C4) ) then 
		Vickel_Speak(VICKEL_MEMORY_STRING..gcinfo()..VICKEL_MEMORY_STRING_END);
		found = found + 1;		
	end
	-- Display the memory spent.
	if ( string.find(msg, VICKEL_CHAT_C6) ) then 
		Vickel_MemWatch();
		found = found + 1;		
	end
	-- Go away
	if ( string.find(msg, VICKEL_CHAT_C5) ) then 
		Vickel_Cosmos_Debug=0;
		Vickel_Party_Debug=0;
		VickelFrame:Hide();
		found = found + 1;		
	end
	if ( found == 0 ) then
		Vickel_Speak(VICKEL_NOT_UNDERSTAND_STRING);
	end
end

-- Vickel Chat Event Watcher
function Vickel_WatchCosmos (type, info, message, player, arg3, channel)

	DebugPrint("Vk: got cosmos message ",VICKEL_DEBUG);
	DebugPrint("VK: cosmos output state: "..Vickel_Cosmos_Debug,VICKEL_DEBUG);

	if ( type == "COSMOS_CHANNEL" or type == "COSMOS_PARTY") then
		if ( Vickel_Cosmos_Debug == 1 ) then 
			local msg;
			msg = format(VICKEL_TYPE, type);
			Vickel_Speak (msg);
			msg = format(VICKEL_USER, player);
			Vickel_Speak (msg);
			msg = format(VICKEL_MSG, message);
			Vickel_Speak (msg);
			msg = format(VICKEL_MSG, channel);
			Vickel_Speak (msg);
		end
	end
end

-- Vickel Chat Event Watcher
function Vickel_WatchChat (type,info, message, user, language, channel)
	-- Vickel_Speak ("Type: "..type.."\nUser: "..arg2.."\nMessage: "..arg1.."\nChannel: "..arg4);

	if ( type == "COMBAT_FRIENDLY_DEATH" ) then 
		local name = string.gsub(message, "(%w+)%s.*", "%1");
		Vickel_Speak(VICKEL_FRIENDLY_DEATH.."\n "..name..VICKEL_FRIENDLY_DEATH_END);
	end
	if ( type == "COMBAT_HOSTILE_DEATH" ) then 
		if ( math.random() < .1 ) then 
			Vickel_Speak(VICKEL_KILL_STRING);
		end
	end
	if ( type == "SPELL_PERIODIC_SELF_DAMAGE" ) then
		Vickel_Speak(VICKEL_POISONED);
	end
end


-- Vickel Speaking
function Vickel_Speak(text)
	-- Add text cooldown here.
	VickelText:AddMessage(text);

	if ( Cosmos_ScheduleByName) then
		Cosmos_ScheduleByName("Vickel", 3, Vickel_Speak, "");
	end
end

-- General Draw Function
function Vickel_Draw(head, body) 
	if ( head ~= nil ) then
		Vickel_SetHead(head);
	end
	if ( body ~=nil ) then 
		Vickel_SetBody(body);
	end
end

-- Various Texture Mapping helper functions
function Vickel_SetHead(texture)
	local x = Vickel_GFX[texture][2];
	local y = Vickel_GFX[texture][1];
	Vickel_SetHeadXY(x,y);
end
function Vickel_SetHeadXY(x,y)
	Vickel_SetXY(VickelHeadTexture,x,y);
end
function Vickel_SetBodyXY(x,y)
	Vickel_SetXY(VickelTexture,x,y);
end
function Vickel_SetXY(texture, x,y)
	texture:SetTexCoord((x-1)*Vickel_Texture_Width,(x)*Vickel_Texture_Width,(y-1)*Vickel_Texture_Height,(y)* Vickel_Texture_Height);
end	
function Vickel_SetBody(texture)
	local x = Vickel_GFX[texture][2];
	local y = Vickel_GFX[texture][1];
	Vickel_SetBodyXY(x,y);
end

-- Idle animation enable. 
function Vickel_IdleConfigUpdate( toggle, value ) 
	Vickel_IdleAnimation = toggle;
	Vickel_IdleSpeed = value;
end

-- Cosmos channel watching
function Vickel_WatchCosmosUpdate( toggle ) 
	Vickel_Cosmos_Debug = toggle;
end
-- Cosmos channel watching
function Vickel_WatchCosmosPartyUpdate( toggle ) 
	Vickel_Cosmos_Party_Debug = toggle;
end
-- Shows/hides Vickel
function Vickel_PowerSwitch(toggle) 
	if ( toggle == 1 ) then 
		VickelFrame:Show();
	else
		VickelFrame:Hide();
	end
end
-- Show/Hide Vickel
function ToggleVickel() 
	if ( VickelFrame:IsVisible() ) then 
		VickelFrame:Hide();
	else
		VickelFrame:Show();
	end
end
