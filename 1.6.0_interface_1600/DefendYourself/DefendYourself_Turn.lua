local pMBS, pMBE, pMFS, pMFE, pSLS, pSLE, pSRS, pSRE, pTRS, pTRE, pTLS, pTLE, pAR, errorframe;
DYTurn = {};
local lastposx, lastposy, turning, combat, dyturninit;

function DefendYourself_Turn_OnLoad()
		pMBS = MoveBackwardStart;
		pMBE = MoveBackwardStop;
		pMFS = MoveForwardStart;
		pMFE = MoveForwardStop;
		pSLS = StrafeLeftStart;
		pSLE = StrafeLeftStop;
		pSRS = StrafeRightStart;
		pSRE = StrafeRightStop; 
		pTRS = TurnRightStart;
		pTRE = TurnRightStop;
		pTLS = TurnLeftStart;
		pTLE = TurnLeftStop;
		pAR = ToggleAutoRun;
		MoveBackwardStart = DYmbs;
		MoveBackwardStop = DYmbe;
		MoveForwardStart = DYmfs;
		MoveForwardStop = DYmfe;
		StrafeLeftStart = DYsls;
		StrafeLeftStop = DYsle;
		StrafeRightStart = DYsrs;
		StrafeRightStop = DYsre; 
		TurnRightStart = DYtrs;
		TurnRightStop = DYtre;
		TurnLeftStart = DYtls;
		TurnLeftStop = DYtle;
		ToggleAutoRun = DYar;
		DefendYourself_Turn:RegisterEvent("UI_ERROR_MESSAGE");
		DefendYourself_Turn:RegisterEvent("VARIABLES_LOADED");
end

function DefendYourself_Turn_OnEvent(event, arg1, arg2, arg3)
	if event == "VARIABLES_LOADED" then
		dyturninit = true;
	elseif event == "UI_ERROR_MESSAGE" then
		if (arg1 == ERR_WRONG_DIRECTION_FOR_ATTACK or arg1 == ERR_BADATTACKFACING) then
				if (DYKey and DYKey.Turn and not DYTurn.On) then
					DefendYourself_DoTurnStuff();
				end
		end
	elseif (event == "CHAT_MSG_COMBAT_SELF_HITS" or event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
			DefendYourself_StopTurnStuff();
	end
end

function dyjunkfunction(event, arg1, arg2, arg3)
	if event == "UI_ERROR_MESSAGE" and (arg1 == ERR_WRONG_DIRECTION_FOR_ATTACK or arg1 == ERR_BADATTACKFACING) then
		--nothing
	else
		errorframe(event,arg1,arg2,arg3);
	end
end

function DefendYourself_Turn_OnUpdate(elapsed)
	if not dyturninit then return; end
	DYturnMovement();
	DYturncheck();
	if DYTurn.On or not DYVar.hate then DefendYourself_StopTurnStuff(); end
	if turning then
		if not errorframe then
			errorframe = UIErrorsFrame_OnEvent;
			UIErrorsFrame_OnEvent = dyjunkfunction;
		end
		AttackTarget();
	else
		if errorframe then
			UIErrorsFrame_OnEvent = errorframe;
			errorframe = nil;
		end
	end
end


function DYmbs(time)
	pMBS(time);
	DYTurn.backward = true;
	if DYTurn.autorun then
		DYTurn.autorun = nil;
	end
end

function DYmfs(time)
	pMFS(time);
	DYTurn.forward = true;
	if DYTurn.autorun then
		DYTurn.autorun = nil;
	end
end

function DYsls(time)
	pSLS(time);
	DYTurn.strafeleft = true;
	if DYTurn.autorun then
		DYTurn.autorun = nil;
	end
end

function DYsrs(time)
	pSRS(time);
	DYTurn.straferight = true;
	if DYTurn.autorun then
		DYTurn.autorun = nil;
	end
end

function DYtrs(time)
	pTRS(time);
	DYTurn.turnright = true;
end

function DYtls(time)
	pTLS(time);
	DYTurn.turnleft = true;
end

function DYmbe(time)
	pMBE(time);
	DYTurn.backward = nil;
end

function DYmfe(time)
	pMFE(time);
	DYTurn.forward = nil;
end

function DYsle(time)
	pSLE(time);
	DYTurn.strafeleft = nil;
end

function DYsre(time)
	pSRE(time);
	DYTurn.straferight = nil;
end

function DYtre(time)
	pTRE(time);
	DYTurn.turnright = nil;
end

function DYtle(time)
	pTLE(time);
	DYTurn.turnleft = nil;
end

function DYar()
	pAR();
	if DYTurn.autorun then
		DYTurn.autorun = nil;
	else
		DYTurn.autorun = true;
	end
end

function DYturncheck()
	if (DYTurn.forward or DYTurn.backward or DYTurn.turnleft or DYTurn.turnright or DYTurn.strafeleft or DYTurn.straferight or DYTurn.autorun or DYTurn.other) then
		DYTurn.On = true;
	else
		DYTurn.On = nil;
	end
end

function DYturnMovement()
	local curx, cury = GetPlayerMapPosition("player");
	if curx ~= lastposx or cury ~= lastposy then DYTurn.other = true; else DYTurn.other = nil; end
	lastposx = curx;
	lastposy = cury;
end

--This makes you turn around if you're being beat the hell on.
function DefendYourself_DoTurnStuff()
	local pakow = UnitHealth("player") / UnitHealthMax("player") * 100;
	if (floor(pakow) > 30) and not DYTurn.On and not turning then
			pTRS();
			turning = true;
			DefendYourself_Turn:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
			DefendYourself_Turn:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
			DefendYourself_Turn:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	end
end

--[[Function 2 stops your walking in 3 ways:
1) one of the 3 events registered above gets fired.
3) You move. Any movement = stop spinning.
]]
function DefendYourself_StopTurnStuff()
	if turning then
		pTRE(); 
		turning = nil;
		DefendYourself_Turn:UnregisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
		DefendYourself_Turn:UnregisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
		DefendYourself_Turn:UnregisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	end
end