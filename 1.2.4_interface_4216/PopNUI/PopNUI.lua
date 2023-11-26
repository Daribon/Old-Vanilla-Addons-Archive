--[[
	PopNUI

	By Mugendai

	This mod lets you make many part
	of your UI be hidden until you mouse
	over them.
   ]]

POPNUI_UPDATETIME = 0.1;
POPNUI_MAXTIME = 2;
POPNUI_CONFIG_PREFIX = "COS_PUI_";
POPNUI_NAME = "name";
POPNUI_DESC = "desc";
POPNUI_CHAT = "chat";
POPNUI_CALLBACK = "callback";
POPNUI_ENABLED = "enabled";
POPNUI_POPTIME = "poptime";

PopNUI_Config = { };
PopNUI_Regs = {};
PopNUI_Initialized=0;
PopNUI_ShapeDone=0;
PopNUI_LastUpdate=0;
PopNUI_MainOn=0;
PopNUI_SecondOn=0;
PopNUI_ShapeOn=0;
PopNUI_PetOn=0;

function PopNUI_FixUI(whichUI)
	if (type(PopNUI_Config[whichUI]) ~= "table") then
		PopNUI_Config[whichUI] = { };
		PopNUI_Config[whichUI][POPNUI_ENABLED] = 0;
		PopNUI_Config[whichUI][POPNUI_POPTIME] = 0;
	end
end

function PopNUI_OnUpdate(elapsed)
	PopNUI_LastUpdate = PopNUI_LastUpdate + elapsed;
	if (PopNUI_LastUpdate >= POPNUI_UPDATETIME) then 
		PopNUI_LastUpdate = 0;
		
		local xPos, yPos = GetCursorPosition();
		
		if (xPos and yPos) then
			for curUI in PopNUI_Regs do
				PopNUI_FixUI(curUI);
				PopNUI_CheckReqs(curUI, xPos, yPos);
			end
		end
	end
end

function PopNUI_Toggle()
	if (PopNUI_Override) then
		PopNUI_Override = nil;
	else
		PopNUI_Override = true;
	end
end

function PopNUI_CheckReq(req, runCheck, doHide)
	local curVar, curReq, curHide = unpack(req);
	local reqVar = getglobal(curVar);
	if (reqVar) then
		local reqVal = nil;
		if (type(reqVar) == "function") then
			reqVal = reqVar();
		else
			reqVal = reqVar;
		end
		if (reqVar ~= curReq) then
			runCheck = false;
		end
	else
		runCheck = false;
	end
	if (curHide) then
		doHide = true;
	end
	return runCheck, doHide;
end

function PopNUI_CheckReqs(whichUI, xPos, yPos)
	if (not whichUI) then
		return;
	end
	if ((not xPos) and (not yPos)) then
		xPos, yPos = GetCursorPosition();
	end
	
	local reqList = nil;
	if (PopNUI_Regs[whichUI] and PopNUI_Regs[whichUI][POPNUI_CALLBACK]) then
		reqList = PopNUI_Regs[whichUI][POPNUI_CALLBACK];
	end
	
	local isEnabled = PopNUI_Config[whichUI][POPNUI_ENABLED];
	if ((not isEnabled) or PopNUI_Override) then
		isEnabled = 0;
	elseif ((isEnabled ~= 1) and (isEnabled ~= 0)) then
		isEnabled = 0;
	end
	
	local runCheck = true;
	local doHide = false;
	if (reqList and (type(reqList) == "table")) then
		if (reqList[1] and (type(reqList[1]) == "table")) then
			for k in reqList do
				runCheck, doHide = PopNUI_CheckReq(reqList[k], runCheck, doHide);
			end
		else
			runCheck, doHide = PopNUI_CheckReq(reqList, runCheck, doHide);
		end
	elseif (reqList and (type(reqList) == "function")) then
		reqList(whichUI, isEnabled, xPos, yPos);
		return;
	end
	
	if (runCheck) then
		PopNUI_CheckUI(whichUI, whichUI, isEnabled, xPos, yPos);
	elseif (reqList and doHide) then
		PopNUI_ShowHide(whichUI, 0, 1);
	end
end

function PopNUI_CheckMainBar(whichUI, isEnabled, xPos, yPos)
	if (whichUI == "ActionBar") then
		return;
	end
	if ((not xPos) and (not yPos)) then
		xPos, yPos = GetCursorPosition();
	end

	if (PopNUI_CheckUI(whichUI, "MainMenuBar", 2, xPos, yPos) == true) then
		PopNUI_MainOn = 1;
	else
		PopNUI_MainOn = 0;
	end
	
	local doShow = 0;
	if ((PopNUI_MainOn == 1) or (PopNUI_ShapeOn == 1) or (PopNUI_SecondOn == 1) or (PopNUI_PetOn == 1)) then
		doShow = 1;
	end
	
	PopNUI_ShowHide("MainMenuBarTexture0", doShow, isEnabled);
	PopNUI_ShowHide("MainMenuBarTexture1", doShow, isEnabled);
	if ( GetBonusBarOffset() <= 0 ) then
		PopNUI_ShowHide("BonusActionBarTexture0", 0, isEnabled);
		PopNUI_ShowHide("BonusActionBarTexture1", 0, isEnabled);
	else
		PopNUI_ShowHide("BonusActionBarTexture0", doShow, isEnabled);
		PopNUI_ShowHide("BonusActionBarTexture1", doShow, isEnabled);
	end
	
	PopNUI_ShowHide("MainMenuBarTexture2", doShow, isEnabled);
	PopNUI_ShowHide("MainMenuBarTexture3", doShow, isEnabled);
	
	local HideEndcaps = true;
	if (Cosmos_RegisterConfiguration) then
		if (Cosmos_GetCVar("COS_SECONDBAR_SKIN_X") and (Cosmos_GetCVar("COS_SECONDBAR_SKIN_X") == 1)) then
			HideEndcaps = false;
		end
	end
	if (HideEndcaps) then
		PopNUI_ShowHide("MainMenuBarLeftEndCap", doShow, isEnabled);
		PopNUI_ShowHide("MainMenuBarRightEndCap", doShow, isEnabled);
		PopNUI_ShowHide("SecondBarTexture0", doShow, isEnabled);
		PopNUI_ShowHide("SecondBarTexture1", doShow, isEnabled);
		PopNUI_ShowHide("SecondBarRightEndCap", doShow, isEnabled);
	end
	
	PopNUI_ShowHide("MainMenuBarOverlayFrame", doShow, isEnabled);
	PopNUI_ShowHide("MainMenuBarPerformanceBarFrame", doShow, isEnabled);
	PopNUI_ShowHide("MainMenuBarPerformanceBarFrameButton", doShow, isEnabled);
	PopNUI_ShowHide("MainMenuBarBackpackButton", doShow, isEnabled);
	PopNUI_ShowHide("CharacterBag0Slot", doShow, isEnabled);
	PopNUI_ShowHide("CharacterBag1Slot", doShow, isEnabled);
	PopNUI_ShowHide("CharacterBag2Slot", doShow, isEnabled);
	PopNUI_ShowHide("CharacterBag3Slot", doShow, isEnabled);
	PopNUI_ShowHide("CharacterMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("SpellbookMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("TalentMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("QuestLogMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("SocialsMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("WorldMapMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("MainMenuMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("HelpMicroButton", doShow, isEnabled);
	PopNUI_ShowHide("ActionBarUpButton", doShow, isEnabled);
	PopNUI_ShowHide("ActionBarDownButton", doShow, isEnabled);
	PopNUI_ShowHide("ExhaustionLevelFillBar", doShow, isEnabled);

	local showAB = doShow;
	local enableAB = PopNUI_Config.ActionBar[POPNUI_ENABLED];
	local showBAB = 0;
	local enableBAB = isEnabled;
	if ( GetBonusBarOffset() > 0 ) then
		showAB = 0;
		enableAB = isEnabled;
		showBAB = doShow;
		enableBAB = PopNUI_Config.ActionBar[POPNUI_ENABLED];
	end
	
	PopNUI_ShowHide("ActionButton1", showAB, enableAB);
	PopNUI_ShowHide("ActionButton2", showAB, enableAB);
	PopNUI_ShowHide("ActionButton3", showAB, enableAB);
	PopNUI_ShowHide("ActionButton4", showAB, enableAB);
	PopNUI_ShowHide("ActionButton5", showAB, enableAB);
	PopNUI_ShowHide("ActionButton6", showAB, enableAB);
	PopNUI_ShowHide("ActionButton7", showAB, enableAB);
	PopNUI_ShowHide("ActionButton8", showAB, enableAB);
	PopNUI_ShowHide("ActionButton9", showAB, enableAB);
	PopNUI_ShowHide("ActionButton10", showAB, enableAB);
	PopNUI_ShowHide("ActionButton11", showAB, enableAB);
	PopNUI_ShowHide("ActionButton12", showAB, enableAB);
	
	PopNUI_ShowHide("BonusActionButton1", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton2", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton3", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton4", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton5", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton6", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton7", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton8", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton9", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton10", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton11", showBAB, enableBAB);
	PopNUI_ShowHide("BonusActionButton12", showBAB, enableBAB);
	
	local showLockBar = false;
	if (LockBar_IsEnabled) then
		showLockBar = doShow;
	end
	PopNUI_ShowHide("ActionLockButton", showLockBar, PopNUI_Config.ActionBar[POPNUI_ENABLED]);

	if (doShow == 1) then
		MainMenuExpBar:SetWidth(1024);
	else
		if (isEnabled == 1) then
			MainMenuExpBar:SetWidth(0.00001);
		elseif (isEnabled == 0) then
			MainMenuExpBar:SetWidth(1024);
		end
	end
	
	local exhaustionThreshold = GetXPExhaustion();
	local playerCurrXP = UnitXP("player");
	local playerMaxXP = UnitXPMax("player");
	if (exhaustionThreshold and playerCurrXP and playerMaxXP) then
		local exhaustionTickSet = ((playerCurrXP + exhaustionThreshold) / playerMaxXP) * MainMenuExpBar:GetWidth();
		if (exhaustionTickSet > MainMenuExpBar:GetWidth()) then
			PopNUI_ShowHide("ExhaustionTick", 0, 1);
		else
			PopNUI_ShowHide("ExhaustionTick", doShow, isEnabled);
		end
	else
		PopNUI_ShowHide("ExhaustionTick", 0, 1);
	end
end

function PopNUI_CheckSecondBar(whichUI, isEnabled, xPos, yPos)
	if (SecondBar_OnLoad) then
		if ((not xPos) and (not yPos)) then
			xPos, yPos = GetCursorPosition();
		end

		local SecondBarEnabled = 0;
		if (Cosmos_RegisterConfiguration) then
			if (Cosmos_GetCVar("COS_SECONDBAR_ONOFF_X") and (Cosmos_GetCVar("COS_SECONDBAR_ONOFF_X") == 1)) then
				SecondBarEnabled = 1;
			end
		end
		if (((PopNUI_ShapeOn == 1) or (PopNUI_PetOn == 1)) and (SecondBarEnabled == 1)) then
			isEnabled = 0;
		end
		if (SecondBarEnabled == 1) then
			if (PopNUI_CheckUI(whichUI, "SecondBar", isEnabled, xPos, yPos) == true) then
				PopNUI_SecondOn = 1;
			else
				PopNUI_SecondOn = 0;
			end
		end
	end
end

function PopNUI_CheckLeftSideBar(whichUI, isEnabled, xPos, yPos)
	if (SideBar_OnLoad) then
		if ((not xPos) and (not yPos)) then
			xPos, yPos = GetCursorPosition();
		end

		local LeftSideBarEnabled = 0;
		if (Cosmos_RegisterConfiguration) then
			if (Cosmos_GetCVar("COS_SIDEBARL_X") and (Cosmos_GetCVar("COS_SIDEBARL_X") == 1)) then
				LeftSideBarEnabled = 1;
			end
		elseif (Left_Sidebar_On == 1) then
			LeftSideBarEnabled = 1;
		end
		if (LeftSideBarEnabled == 1) then
			local left = nil;
			local right = nil;
			local top = nil;
			local bottom = nil;
			local scale = nil;
			local uiFrame = getglobal("SideBar2Button6");
			if (uiFrame) then
				bottom = uiFrame:GetBottom();
				left = uiFrame:GetLeft();
				right = uiFrame:GetRight();
				scale = uiFrame:GetScale();
			end
			uiFrame = getglobal("SideBar2Button1");
			if (uiFrame) then
				top = uiFrame:GetTop();
			end
			if (left and right and top and bottom and scale) then
				left = left * scale;
				right = right * scale;
				top = top * scale;
				bottom = bottom * scale;
				PopNUI_CheckUI(whichUI, "SideBar2", isEnabled, xPos, yPos, left, right, top, bottom);
			end
		end
	end
end

function PopNUI_CheckRightSideBar(whichUI, isEnabled, xPos, yPos)
	if (SideBar_OnLoad) then
		if ((not xPos) and (not yPos)) then
			xPos, yPos = GetCursorPosition();
		end

		local RightSideBarEnabled = 0;
		if (Cosmos_RegisterConfiguration) then
			if (Cosmos_GetCVar("COS_SIDEBARR_X") and (Cosmos_GetCVar("COS_SIDEBARR_X") == 1)) then
				RightSideBarEnabled = 1;
			end
		elseif (Right_Sidebar_On == 1) then
			RightSideBarEnabled = 1;
		end
		if (RightSideBarEnabled == 1) then
			local left = nil;
			local right = nil;
			local top = nil;
			local bottom = nil;
			local scale = nil;
			local uiFrame = getglobal("SideBarButton6");
			if (uiFrame) then
				bottom = uiFrame:GetBottom();
				left = uiFrame:GetLeft();
				right = uiFrame:GetRight();
				scale = uiFrame:GetScale();
			end
			uiFrame = getglobal("SideBarButton1");
			if (uiFrame) then
				top = uiFrame:GetTop();
			end
			if (left and right and top and bottom and scale) then
				left = left * scale;
				right = right * scale;
				top = top * scale;
				bottom = bottom * scale;
				PopNUI_CheckUI(whichUI, "SideBar", isEnabled, xPos, yPos, left, right, top, bottom);
			end
		end
	end
end

function PopNUI_CheckPetBar(whichUI, isEnabled, xPos, yPos)
	if ((not xPos) and (not yPos)) then
		xPos, yPos = GetCursorPosition();
	end

	if (PetHasActionBar()) then
		local left = nil;
		local right = nil;
		local top = nil;
		local bottom = nil;
		local scale = nil;
		local uiFrame = getglobal("PetActionButton1");
		if (uiFrame) then
			left = uiFrame:GetLeft();
			bottom = uiFrame:GetBottom();
			top = uiFrame:GetTop();
			scale = uiFrame:GetScale();
			local uiFrame = getglobal("PetActionButton10");
			if (uiFrame) then
				right = uiFrame:GetRight();
			end
		end
		if (left and right and top and bottom and scale) then
			left = left * scale;
			right = right * scale;
			top = top * scale;
			bottom = bottom * scale;
			if (PopNUI_CheckUI(whichUI, "PetActionBarFrame", isEnabled, xPos, yPos, left, right, top, bottom) == true) then
				PopNUI_PetOn = 1;
			else
				PopNUI_PetOn = 0;
			end
		end
	end
end

function PopNUI_CheckShapeBar(whichUI, isEnabled, xPos, yPos)
	if ((not xPos) and (not yPos)) then
		xPos, yPos = GetCursorPosition();
	end
	
	local forms = GetNumShapeshiftForms();
	if (forms > 0) then
		if (PopNUI_ShapeDone == 0) then
			PopNUI_ShapeDone = 1;
			ShapeshiftBarFrame:Show();
		end
		
		local left = nil;
		local right = nil;
		local top = nil;
		local bottom = nil;
		local scale = nil;
		local uiFrame = getglobal("ShapeshiftButton1");
		if (uiFrame) then
			left = uiFrame:GetLeft();
			bottom = uiFrame:GetBottom();
			top = uiFrame:GetTop();
			if (left and bottom and top) then
				left = left - 5;
				top = top + 3;
				bottom = bottom - 5;
				local extra = 10;
				if (forms > 3) then
					extra = extra + 3;
				end
				if (forms > 2) then
					extra = extra + 7;
				end
				if (forms > 1) then
					extra = extra + 7;
				end
				right = left + (((30 * forms) + extra));
			end
			scale = uiFrame:GetScale();
		end
		if (left and right and top and bottom and scale) then
			left = left * scale;
			right = right * scale;
			top = top * scale;
			bottom = bottom * scale;
			if (PopNUI_CheckUI(whichUI, "ShapeshiftBarFrame", isEnabled, xPos, yPos, left, right, top, bottom) == true) then
				PopNUI_ShapeOn = 1;
			else
				PopNUI_ShapeOn = 0;
			end
		end
	end
end

function PopNUI_ShapeshiftBar_Update()
	local numForms = GetNumShapeshiftForms();
	local fileName, name, isActive, isCastable;
	local button, icon, cooldown;
	local start, duration, enable;

	if ( numForms > 0 ) then
		if (Cosmos_RegisterConfiguration) then
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT",SHAPESHIFTBAR_XPOS,SHAPESHIFTBAR_YPOS);
		end
		--Setup the shapeshift bar to display the appropriate number of slots
		if ( numForms == 1 ) then
			ShapeshiftBarMiddle:Hide();
			ShapeshiftBarRight:SetPoint("LEFT", "ShapeshiftBarLeft", "LEFT", 12, 0);
		elseif ( numForms == 2 ) then
			ShapeshiftBarMiddle:Hide();
			ShapeshiftBarRight:SetPoint("LEFT", "ShapeshiftBarLeft", "RIGHT", 0, 0);
		else
			ShapeshiftBarMiddle:Show();
			ShapeshiftBarMiddle:SetPoint("LEFT", "ShapeshiftBarLeft", "RIGHT", 0, 0);
			ShapeshiftBarMiddle:SetWidth(38 * (numForms-2));
			ShapeshiftBarMiddle:SetTexCoord(0, numForms-2, 0, 1);
			ShapeshiftBarRight:SetPoint("LEFT", "ShapeshiftBarMiddle", "RIGHT", 0, 0);
		end
		
		--ShapeshiftBarFrame:Show();
		--Move the chat frame and edit box up a bit
		FCF_UpdateDockPosition("showshapeshift");
		--Move the casting bar up
		if (Cosmos_RegisterConfiguration) then
			CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83 + SHAPESHIFTBAR_YPOS);
		else
			CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83);
		end
	else
		ShapeshiftBarFrame:Hide();
		if ( not PetHasActionBar() ) then
			--Move the chat frame and edit box back down to original position
			FCF_UpdateDockPosition("hideshapeshift");
			--Move the casting bar back down
			if (Cosmos_RegisterConfiguration) then
				CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60 + SHAPESHIFTBAR_YPOS);
			else
				CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60);
			end
		else
			if (Cosmos_RegisterConfiguration) then 
				FCF_UpdateDockPosition("hideshapeshift");	
				CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83 + SHAPESHIFTBAR_YPOS);
			end
		end
	end
	
	for i=1, NUM_SHAPESHIFT_SLOTS do
		button = getglobal("ShapeshiftButton"..i);
		icon = getglobal("ShapeshiftButton"..i.."Icon");
		if ( i <= numForms ) then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			icon:SetTexture(texture);
			
			--Cooldown stuffs
			cooldown = getglobal("ShapeshiftButton"..i.."Cooldown");
			if ( texture ) then
				cooldown:Show();
			else
				cooldown:Hide();
			end
			start, duration, enable = GetShapeshiftFormCooldown(i);
			CooldownFrame_SetTimer(cooldown, start, duration, enable);
			
			if ( isActive ) then
				ShapeshiftBarFrame.lastSelected = button:GetID();
				button:SetChecked(1);
			else
				button:SetChecked(0);
			end

			if ( isCastable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
			end

			button:Show();
		else
			button:Hide();
		end
	end
end

function PopNUI_CheckBuffs(whichUI, isEnabled, xPos, yPos)
	if ((not xPos) and (not yPos)) then
		xPos, yPos = GetCursorPosition();
	end

	local left = nil;
	local right = nil;
	local top = nil;
	local bottom = nil;
	local scale = nil;
	local uiFrame = getglobal("BuffButton0");
	if (uiFrame) then
		top = uiFrame:GetTop();
		right = uiFrame:GetRight();
		scale = uiFrame:GetScale();
		if (top and right) then
			left = right - 256;
			bottom = top - 106;
		end
	end
	if (left and right and top and bottom and scale) then
		left = left * scale;
		right = right * scale;
		top = top * scale;
		bottom = bottom * scale;
		PopNUI_CheckUI(whichUI, "BuffFrame", isEnabled, xPos, yPos, left, right, top, bottom);
	end
end

function PopNUI_CheckUI(whichUI, uiName, isEnabled, xPos, yPos, uiLeft, uiRight, uiTop, uiBottom)
	if (uiName) then
		if ((not xPos) and (not yPos)) then
			xPos, yPos = GetCursorPosition();
		end
		
		local uiFrame = getglobal(uiName);
		local left = uiLeft;
		local right = uiRight;
		local top = uiTop;
		local bottom = uiBottom;
		local scale = nil;
		if (uiFrame) then
			scale = uiFrame:GetScale();
			if (not scale) then
				scale = 1;
			end
			if (not left) then
				left = uiFrame:GetLeft() * scale;
			end
			if (not right) then
				right = uiFrame:GetRight() * scale;
			end
			if (not top) then
				top = uiFrame:GetTop() * scale;
			end
			if (not bottom) then
				bottom = uiFrame:GetBottom() * scale;
			end
			
			if (xPos and yPos and left and right and top and bottom) then
				if ((xPos >= left) and (xPos <= right) and (yPos >= bottom) and (yPos <= top)) then
					local willShow = false;
					if (Chronos) then
						if (Chronos.getTimer(POPNUI_CONFIG_PREFIX..whichUI) > 0) then
							if (Chronos.getTimer(POPNUI_CONFIG_PREFIX..whichUI) >= PopNUI_Config[whichUI][POPNUI_POPTIME]) then
								if ((isEnabled == 1) or (isEnabled == 0)) then
									PopNUI_ShowHide(uiName, 1, isEnabled);
								end
								return true;
							end
						else
							Chronos.startTimer(POPNUI_CONFIG_PREFIX..whichUI);
						end
					else
						willShow = true;
					end
					
					if (willShow) then
						if ((isEnabled == 1) or (isEnabled == 0)) then
							PopNUI_ShowHide(uiName, 1, isEnabled);
						end
						return true;
					end
				else
					if (Chronos) then
						Chronos.endTimer(POPNUI_CONFIG_PREFIX..whichUI);
					end
					PopNUI_ShowHide(uiName, 0, isEnabled);
					return false;
				end
			end
		end
	end
end

function PopNUI_ShowHide(frameName, doShow, isEnabled)
	if (frameName and doShow and isEnabled) then
		uiFrame = getglobal(frameName);
		if (uiFrame) then
			if (doShow == 1) then
				if (not uiFrame:IsVisible()) then
					uiFrame:Show();
				end
			else
				if (isEnabled == 1) then
					if (uiFrame:IsVisible()) then
						uiFrame:Hide();
					end
				elseif ((not uiFrame:IsVisible()) and (isEnabled == 0)) then
					uiFrame:Show();
				end
			end
		end
	end
end

function PopNUI_SetUIOnOff(whichUI, onOff, value)
	if (whichUI) then
		PopNUI_FixUI(whichUI);
		if (onOff) then
			local setTo = 0;
			if (onOff and (onOff==1)) then
				setTo = 1;
			elseif (onOff and (onOff == 0)) then
				setTo = 0;
			else
				if (PopNUI_Config[whichUI][POPNUI_ENABLED] == 0) then
					setTo = 1;
				else
					setTo = 0;
				end
			end
			
			if (PopNUI_Config[whichUI][POPNUI_ENABLED] ~= setTo) then
				PopNUI_Config[whichUI][POPNUI_ENABLED] = setTo;
				if(Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue("COS_PUI_"..string.upper(whichUI), CSM_CHECKONOFF, setTo);
				end
			end
		end
		
		
		if (value) then
			if (value < 0) then
				value = 0;
			end
			if (value > POPNUI_MAXTIME) then
				value = POPNUI_MAXTIME;
			end
			if (PopNUI_Config[whichUI][POPNUI_POPTIME] ~= value) then
				PopNUI_Config[whichUI][POPNUI_POPTIME] = value;
				if(Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue("COS_PUI_"..string.upper(whichUI).."_X", CSM_SLIDER, value);
				end
			end
		end
	end
end

function PopNUI_Save()
	RegisterForSave("PopNUI_Config");
end

function PopNUI_OnLoad()
	if ( PopNUI_Initialized == 0) then
		Sea.util.hook("ShapeshiftBar_Update", "PopNUI_ShapeshiftBar_Update", "replace");
		
		PopNUI_RegisterUI("MainBar",	"main",	PopNUI_CheckMainBar,	POPNUI_CONFIG_MAINBAR,	POPNUI_CONFIG_MAINBAR_INFO);
		PopNUI_RegisterUI("ActionBar",	"action",	PopNUI_CheckMainBar,	POPNUI_CONFIG_ACTIONBAR,	POPNUI_CONFIG_ACTIONBAR_INFO);
		PopNUI_RegisterUI("ShapeBar",	{"shape", "stance", "aura", "stealth"},	PopNUI_CheckShapeBar,	POPNUI_CONFIG_SHAPEBAR,	POPNUI_CONFIG_SHAPEBAR_INFO);
		PopNUI_RegisterUI("PetBar",	"pet",	PopNUI_CheckPetBar,	POPNUI_CONFIG_PETBAR,	POPNUI_CONFIG_PETBAR_INFO);
		PopNUI_RegisterUI("SecondBar",	"second",	PopNUI_CheckSecondBar,	POPNUI_CONFIG_SECONDBAR,	POPNUI_CONFIG_SECONDBAR_INFO);
		PopNUI_RegisterUI("LeftSideBar",	{"left", "leftsidebar"},	PopNUI_CheckLeftSideBar,	POPNUI_CONFIG_LEFTSIDEBAR,	POPNUI_CONFIG_LEFTSIDEBAR_INFO);
		PopNUI_RegisterUI("RightSideBar",	{"right", "rightsidebar"},	PopNUI_CheckRightSideBar,	POPNUI_CONFIG_RIGHTSIDEBAR,	POPNUI_CONFIG_RIGHTSIDEBAR_INFO);
		PopNUI_RegisterUI("MinimapCluster",	{"map", "minimap"},	nil,	POPNUI_CONFIG_MINIMAP,	POPNUI_CONFIG_MINIMAP_INFO);
		PopNUI_RegisterUI("Buffs",	"buffs",	PopNUI_CheckBuffs,	POPNUI_CONFIG_BUFFS,	POPNUI_CONFIG_BUFFS_INFO);
		PopNUI_RegisterUI("PlayerFrame",	"stats",	nil,	POPNUI_CONFIG_STATS,	POPNUI_CONFIG_STATS_INFO);		

		if (not (Cosmos_RegisterConfiguration == nil)) then
			if ( Cosmos_RegisterChatCommand ) then
				local PopNUICommands = {"/popnui","/pui"};
				
				Cosmos_RegisterChatCommand (
					"POPNUI_COMMANDS", -- Some Unique Group ID
					PopNUICommands, -- The Commands
					PopNUI_ChatCommandHandler,
					POPNUI_CHAT_COMMAND_INFO -- Description String
				);
			end
		else
			SlashCmdList["POPNUISLASH"] = PopNUI_ChatCommandHandler;
			SLASH_POPNUISLASH1 = "/popnui";
			SLASH_POPNUISLASH2 = "/pui";
			PopNUI_Save();
		end
		PopNUI_Initialized = 1;
	end
end		

-- PopNUI Chat Command Handler
function PopNUI_ChatCommandHandler(msg)
	if (msg) then
		msg = string.lower(msg);
		local command, onOffStr, value = unpack(Sea.string.split(msg, " "));
		if ((not command) and msg) then
			command = msg;
		end
		if (command) then
			local whichUI = nil;
			for checkMode = 1, 2 do
				for curReg in PopNUI_Regs do
					local curCommand = PopNUI_Regs[curReg][POPNUI_CHAT];
					if ((type(curCommand) == "table")) then
						for k, inCommand in curCommand do
							if (checkMode == 1) then
								if (command == inCommand) then
									whichUI = curReg;
									break;
								end
							else
								if (string.find(command, inCommand)) then
									whichUI = curReg;
									break;
								end
							end
						end
					else
						if (checkMode == 1) then
							if (command == curCommand) then
								whichUI = curReg;
								break;
							end
						else
							if (string.find(command, curCommand)) then
								whichUI = curReg;
								break;
							end
						end
					end
				end
			end
			if (whichUI) then
				local onOff = -1;
				-- Toggle appropriately
				if (onOffStr) then
					if (string.find(onOffStr, "on")) then
						onOff = 1;
					elseif (string.find(onOffStr, "off")) then
						onOff = 0;
					end
				end

				if (value and (string.find(value, "%d") or string.find(value, "%d.%d+") or string.find(value, ".%d+"))) then
					value = value+0;
				else
					value = PopNUI_Config[whichUI][POPNUI_POPTIME];
				end

				PopNUI_SetUIOnOff(whichUI, onOff, value);
				return;
			end
		end
	end
	local chatList = "";
	for curReg in PopNUI_Regs do
		local curChatEntry = PopNUI_Regs[curReg][POPNUI_CHAT];
		if (chatList ~= "") then
			chatList = chatList..", ";
		else
			chatList = "";
		end
		if ((type(curChatEntry) == "table")) then
			local chatSet = "";
			for curChat in curChatEntry do
				if (chatSet ~= "") then
					chatSet = chatSet.."/";
				else
					chatSet = "";
				end
				chatSet = chatSet..curChatEntry[curChat];
			end
			chatList = chatList..chatSet;
		else
			chatList = chatList..curChatEntry;
		end
	end
	for i = 1, getn(POPNUI_CHAT_COMMAND_HELP) do
		local chatLine = string.format(POPNUI_CHAT_COMMAND_HELP[i], chatList);
		Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
	end
end

--Use this to add a UI element to be popped.
--whichUI - Which UI element, be sure to pass the exact name.
--chatComm - the chat command to use to control the options, don't pass a / or pui.. just the nickname for your UI element.  This can be a single command or a list of commands.
--callback - optional (pass nil if not needed)
--             if your UI element requires more specialized code to contol popupability, then provide a callback here.. here is the format:
--             function (whichUI, isEnabled, xPos, yPos)
--             whichUI will be the UI name you passed to the command
--             isEnabled will let you know if it is enabled or not(so you know to show it normal or popped)
--             xPos is the x position of the cursor
--             yPos is the y position of the cursor
--           callback can also be a table of requirements instead of an actual callback function.
--             this can either be a single 3 column table, or several rows of 3 column tables.
--             {"GlobalVarName", checkValue, hide}
--             "GlobalVarName" is the name of the global variable to check, this can be a function.
--             checkValue is what "GlobalVarName" needs to be equal to.
--             if hide is true then if the the variable is not equal, your UI will be hidden.
--confName - the name to show in Cosmos' UI config
--confDesc - the description to show in Cosmos' UI config
function PopNUI_RegisterUI(whichUI, chatComm, callback, confName, confDesc)
	if (whichUI and chatComm) then
		if (not PopNUI_Config[whichUI]) then
			PopNUI_Config[whichUI] = {};
		end
		if (not PopNUI_Config[whichUI][POPNUI_ENABLED]) then
			PopNUI_Config[whichUI][POPNUI_ENABLED] = 0;
		end
		if (not PopNUI_Config[whichUI][POPNUI_POPTIME]) then
			PopNUI_Config[whichUI][POPNUI_POPTIME] = 0;
		end
		PopNUI_Regs[whichUI] = {};
		PopNUI_Regs[whichUI][POPNUI_CHAT] = chatComm;
		PopNUI_Regs[whichUI][POPNUI_CALLBACK] = callback;
		
		if (Cosmos_RegisterConfiguration and confName and confDesc) then
			PopNUI_Regs[whichUI][POPNUI_NAME] = confName;
			PopNUI_Regs[whichUI][POPNUI_DESC] = confDesc;
			
			local confVarName = POPNUI_CONFIG_PREFIX..string.upper(whichUI);
			
			Cosmos_RegisterConfiguration(
				"COS_UIVIS",
				"SECTION",
				POPNUI_CONFIG_SECTION,
				POPNUI_CONFIG_SECTION_INFO
				);
			Cosmos_RegisterConfiguration(
				"COS_PUI_SEP",
				"SEPARATOR",
				POPNUI_CONFIG_HEADER,
				POPNUI_CONFIG_HEADER_INFO
				);
			Cosmos_RegisterConfiguration(
				confVarName,
				"BOTH",
				confName,
				confDesc,
				function (checked, value) PopNUI_SetFromCos(whichUI, checked, value); end,
				0,
				0,
				0,
				POPNUI_MAXTIME,
				POPNUI_CONFIG_SLIDER,
				0.1,
				1,
				POPNUI_CONFIG_SUFFIX,
				1
			);
		end
	end
end

function PopNUI_SetFromCos(passedUI, checked, value)
	PopNUI_SetUIOnOff(passedUI, checked, value);
end