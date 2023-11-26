BINDING_HEADER_IMPROVEDASSIST = "Improved Assist";
BINDING_NAME_IASET = "Set Assist";
BINDING_NAME_IAASSIST = "Assist";

function ImprovedAssist_Init() 
	DEFAULT_CHAT_FRAME:AddMessage("Improved Assist loaded", 1, 1, 1);
end 

function SetAssist()
	if( UnitIsFriend("target","player") and UnitIsPlayer("target") ) then
		IA_Assist = UnitName("target");
		DEFAULT_CHAT_FRAME:AddMessage("The assigned assist is: "..IA_Assist, 1, 1, 0);
	else
		IA_Assist = nil;
		DEFAULT_CHAT_FRAME:AddMessage("Assigned assist cleared.", 1, 1, 0);
	end
end

-- Keypress handler.  Determines which type of assist
-- is appropriate and calls it.
function DoAssist()
	if( UnitClass("player") == "Hunter" ) then
		DoHunterAssist();
	elseif( UnitClass("player") == "Warlock" ) then
		DoPetAssist();
	else
		DoNormalAssist();
	end
end

-- Called if the character's class is Hunter.
-- Extra functionality to replace attack on assist
-- with autoshot instead of melee attack.
function DoHunterAssist()
	if( GetCVar("assistAttack") == "1") then
		SetCVar("assistAttack", "Delayed");
	end	
	
	DoPetAssist()
	
	if ( GetCVar("assistAttack") == "Delayed") then
		CastSpellByName("Auto Shot");
		SetCVar("assistAttack", "1");
	end
end

-- Assist main assist if it's set.  Otherwise assist
-- the character's pet.
function DoPetAssist()
	if( IA_Assist == nil ) then
		AssistUnit("pet");
	else
		AssistByName( IA_Assist );
	end
end

-- Assist main assist if it's set.  Otherwise act as
-- normal melee attack (target nearest and attack).
function DoNormalAssist()
	if( IA_Assist == nil ) then
		TargetNearestEnemy();
		AttackTarget();
	else
		AssistByName( IA_Assist );
	end
end