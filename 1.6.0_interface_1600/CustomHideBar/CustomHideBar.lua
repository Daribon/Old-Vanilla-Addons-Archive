--Keeps track of which Bonus buttons were showing last time we checked
        BONUS_BUTTONS_OFFSET = 0;

-- Configuration variables
        CHB_BagBar = true;
        CHB_ActionBar = true;
        CHB_MicroBar = true;
        CHB_PetBar = true;
        CHB_ShapeshiftBar = true;
        CHB_Locked = false;

function CustomHideBar_OnLoad(component)
-- Slash commands
	SlashCmdList["CUSTOMHIDEBARCOMMAND"] = CustomHideBar_SlashHandler;
	SLASH_CUSTOMHIDEBARCOMMAND1 = "/customhidebar";
	SLASH_CUSTOMHIDEBARCOMMAND2 = "/chb";

-- Loading saved variables        
	this:RegisterEvent("VARIABLES_LOADED");
        --CHB_ChatMessage("CustomHideBar loaded. Type '/chb' for help.");
        
-- Hiding Main Bar
        MainMenuBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
        
function CHB_MainBarReset()
	MainMenuBar:ClearAllPoints();
	MainMenuBar:SetPoint("BOTTOM", "UIParent", "BOTTOM");
end
        
        
-- Support for Ultimate UI
	if(UltimateUI_RegisterConfiguration) then
		UltimateUI_RegisterConfiguration(
			"UUI_CUSTOMEHIDEBAR",
			"SECTION",
			"Action Bar Options"
			);
		UltimateUI_RegisterConfiguration(
			"UUI_CHB_SEPARATOR",
			"SEPARATOR",
			"Action Bar Settings"
			);
		UltimateUI_RegisterConfiguration(
			"UUI_CHB_LOCK",
			"BUTTON",
			"Lock/Unlock the action bar parts",
			"Click this button to lock all parts of the action bar.",
			CHB_LockToggle,
			0,
			0,
			0,
			0,
			"Toggle"
		);
		UltimateUI_RegisterConfiguration(
		 	"UUI_CHB_ACTIONBAR", 
		 	"CHECKBOX", 
		 	"Show the Action Bar",
		 	"Check here to show the action bar", 
		 	function (toggle) 
				if ( toggle == 1 ) then 
					CustomHideBar_ShowBar("CHBActionBar");
					CHB_ActionBar = true;
				else
					CustomHideBar_HideBar("CHBActionBar");
					CHB_ActionBar = false;
				end
			end,
			1
		);
		UltimateUI_RegisterConfiguration(
		 	"UUI_CHB_BAGBAR", 
		 	"CHECKBOX", 
		 	"Show the Bag Bar",
		 	"Check here to show the bag bar", 
		 	function (toggle) 
				if ( toggle == 1 ) then 
					CustomHideBar_ShowBar("CHBBagBar");
					CHB_BagBar = true;
				else
					CustomHideBar_HideBar("CHBBagBar");
					CHB_BagBar = false;
				end
			end,
			1
		);
		UltimateUI_RegisterConfiguration(
		 	"UUI_CHB_MICROBAR", 
		 	"CHECKBOX", 
		 	"Show the Micro Bar",
		 	"Check here to show the Micro bar", 
		 	function (toggle) 
				if ( toggle == 1 ) then 
					CustomHideBar_ShowBar("CHBMicroBar");
					CHB_MicroBar = true;
				else
					CustomHideBar_HideBar("CHBMicroBar");
					CHB_MicroBar = false;
				end
			end,
			1
		);
		UltimateUI_RegisterConfiguration(
		 	"UUI_CHB_PetBAR", 
		 	"CHECKBOX", 
		 	"Show the Pet Bar",
		 	"Check here to show the Pet bar", 
		 	function (toggle) 
				if ( toggle == 1 ) then 
					CustomHideBar_ShowBar("CHBPetBar");
					CHB_PetBar = true;
				else
					CustomHideBar_HideBar("CHBPetBar");
					CHB_PetBar = false;
				end
			end,
			1
		);
		UltimateUI_RegisterConfiguration(
		 	"UUI_CHB_ShapeshiftBAR", 
		 	"CHECKBOX", 
		 	"Show the Shapeshift Bar",
		 	"Check here to show the Shapeshift bar", 
		 	function (toggle) 
				if ( toggle == 1 ) then 
					CustomHideBar_ShowBar("CHBShapeshiftBar");
					CHB_ShapeshiftBar = true;
				else
					CustomHideBar_HideBar("CHBShapeshiftBar");
					CHB_ShapeshiftBar = false;
				end
			end,
			1
		);
		UltimateUI_RegisterConfiguration(
			"UUI_CHB_HIDEBUTTONS",
			"BUTTON",
			"Hide/show the drag icons",
			"Click this button to hide/show all but the action bar drag icons.",
			CHB_HideToggle,
			0,
			0,
			0,
			0,
			"Toggle"
		);
		UltimateUI_RegisterConfiguration(
			"UUI_CHB_RESETMAIN",
			"BUTTON",
			"Rest to default",
			"Click this button to reset the main bottom bar and background.",
			CHB_MainBarReset,
			0,
			0,
			0,
			0,
			"Reset"
		);
	end
end

function CHB_ConstructActionBar()
	ActionButton1:ClearAllPoints();
	ActionButton1:SetPoint("BOTTOMLEFT", this:GetName());
        for i = 2, 12 do
                getglobal("ActionButton"..i):ClearAllPoints();
                getglobal("ActionButton"..i):SetPoint("LEFT","ActionButton"..i-1,"RIGHT", 2, 0);
        end 
        ActionBarUpButton:ClearAllPoints();
        ActionBarUpButton:SetPoint("LEFT", "ActionButton12", "RIGHT", -5, 7);
        ActionBarDownButton:ClearAllPoints();
        ActionBarDownButton:SetPoint("TOP", "ActionBarUpButton", "BOTTOM", 0, 13);
end

function CHB_ConstructBagBar()
	CharacterBag3Slot:ClearAllPoints();
	CharacterBag3Slot:SetPoint("BOTTOMLEFT", this:GetName());
	CharacterBag2Slot:ClearAllPoints();
	CharacterBag2Slot:SetPoint("LEFT", "CharacterBag3Slot", "RIGHT", 2, 0);
	CharacterBag1Slot:ClearAllPoints();
	CharacterBag1Slot:SetPoint("LEFT", "CharacterBag2Slot", "RIGHT", 2, 0);
	CharacterBag0Slot:ClearAllPoints();
	CharacterBag0Slot:SetPoint("LEFT", "CharacterBag1Slot", "RIGHT", 2, 0);
	MainMenuBarBackpackButton:ClearAllPoints();
	MainMenuBarBackpackButton:SetPoint("LEFT", "CharacterBag0Slot", "RIGHT", 2, 0);
end

function CHB_ConstructMicroBar()
  CharacterMicroButton:ClearAllPoints();
  CharacterMicroButton:SetPoint("BOTTOMLEFT", this:GetName());
  SpellbookMicroButton:ClearAllPoints();
  SpellbookMicroButton:SetPoint("LEFT", "CharacterMicroButton", "RIGHT", -3, 0);
  TalentMicroButton:ClearAllPoints();
  TalentMicroButton:SetPoint("LEFT", "SpellbookMicroButton", "RIGHT", -3, 0);
  QuestLogMicroButton:ClearAllPoints();
  QuestLogMicroButton:SetPoint("LEFT", "TalentMicroButton", "RIGHT", -3, 0);
  SocialsMicroButton:ClearAllPoints();
  SocialsMicroButton:SetPoint("LEFT", "QuestLogMicroButton", "RIGHT", -3, 0);
  WorldMapMicroButton:ClearAllPoints();
  WorldMapMicroButton:SetPoint("LEFT", "SocialsMicroButton", "RIGHT", -3, 0);
  MainMenuMicroButton:ClearAllPoints();
  MainMenuMicroButton:SetPoint("LEFT", "WorldMapMicroButton", "RIGHT", -3, 0);
  HelpMicroButton:ClearAllPoints();
  HelpMicroButton:SetPoint("LEFT", "MainMenuMicroButton", "RIGHT", -3, 0);
end

function CHB_ConstructPetBar()
	for i=1, 12 do
		pet_button = getglobal("PetActionButton"..i);
		if (pet_button ~= nil) then
			pet_button:ClearAllPoints();
			pet_button:SetPoint("TOPLEFT", this:GetName(), "TOPLEFT", 2 + ((i - 1) * 33), -1);
		end
	end
end

function CHB_ConstructShapeshiftBar()
	for i=1, 10 do
		shapeshift_button = getglobal("ShapeshiftButton"..i);
		shapeshift_button:ClearAllPoints();
		shapeshift_button:SetPoint("TOPLEFT", this:GetName(), "TOPLEFT", 4 + ((i - 1) * 39), -4);
	end
end

function CHB_LinkFrameToDragButton(dragbutton, component)
	getglobal(component):ClearAllPoints();
	getglobal(component):SetPoint("TOPLEFT", dragbutton, "TOPRIGHT");
end

function CHB_ChatMessage(message)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(message);
	end
end

--Overrides and disables the normal paging functionality
function ChangeActionBarPage()
	CHB_ChangeActionBarPage(CURRENT_ACTIONBAR_PAGE);
end

function CHB_ChangeActionBarPage(page)
        local bonusBar = false;

	if(BONUS_BUTTONS_OFFSET > 0 and page==1) then
		page = 6 + GetBonusBarOffset();
                bonusBar = true;
	end
        
	
	local offset = 0;
	local button;
        
        if (bonusBar == true) then
                offset = 12 * (page-1);
        end

	for i = 1, 12 do
		button = getglobal("ActionButton"..i);
		button:SetID(i+offset);
		button:SetChecked(false);
                button:Hide();
                button:Show();
	end
end

function CHB_GetActionButtonName(button_num)
	return "ActionButton"..button_num;	
end

--Keeps track of UI changes that should affect the action bar, and changes it accordingly
function CHB_UpdateActionBar()
	local button;
	local bonusButtonsOffset = GetBonusBarOffset();
	
	if (BONUS_BUTTONS_OFFSET ~= bonusButtonsOffset) then
		BONUS_BUTTONS_OFFSET = bonusButtonsOffset;
                ChangeActionBarPage();
	end
end

function CustomHideBar_OnEvent()
    if (event == "VARIABLES_LOADED") then
        if (CHB_Locked) then
                CustomHideBar_LockBars();
        end

        if (not CHB_BagBar) then
                CustomHideBar_HideBar("CHBBagBar");
        end
        if (not CHB_ActionBar) then
                CustomHideBar_HideBar("CHBActionBar");
        end
        if (not CHB_MicroBar) then
                CustomHideBar_HideBar("CHBMicroBar");
        end
        if (not CHB_PetBar) then
                CustomHideBar_HideBar("CHBPetBar");
        end
        if (not CHB_ShapeshiftBar) then
                CustomHideBar_HideBar("CHBShapeshiftBar");
        end
    end 
end

function CustomHideBar_SlashHandler(msg)
  if (msg == "bagbar hide") then
        CustomHideBar_HideBar("CHBBagBar");
        CHB_BagBar = false;
  elseif (msg == "bagbar show") then
        CustomHideBar_ShowBar("CHBBagBar");
        CHB_BagBar = true;
  elseif (msg == "actionbar hide") then
        CustomHideBar_HideBar("CHBActionBar");
        CHB_ActionBar = false;
  elseif (msg == "actionbar show") then
        CustomHideBar_ShowBar("CHBActionBar");
        CHB_ActionBar = true;
  elseif (msg == "microbar hide") then
        CustomHideBar_HideBar("CHBMicroBar");
        CHB_MicroBar = false;
  elseif (msg == "microbar show") then
        CustomHideBar_ShowBar("CHBMicroBar");
        CHB_MicroBar = true;
  elseif (msg == "petbar hide") then
        CustomHideBar_HideBar("CHBPetBar");
        CHB_PetBar = false;
  elseif (msg == "petbar show") then
        CustomHideBar_ShowBar("CHBPetBar");
        CHB_PetBar = true;
  elseif (msg == "shapeshiftbar hide") then
        CustomHideBar_HideBar("CHBShapeshiftBar");
        CHB_ShapeshiftBar = false;
  elseif (msg == "shapeshiftbar show") then
        CustomHideBar_ShowBar("CHBShapeshiftBar");
        CHB_ShapeshiftBar = true;
  elseif (msg == "lock") then
        CustomHideBar_LockBars();
        CHB_Locked = true;
  elseif (msg == "unlock") then
        CustomHideBar_UnLockBars();
        CHB_Locked = false;
  else
        CHB_PrintHelp();
  end
end

function CustomHideBar_HideBar(bar)
  getglobal(bar):ClearAllPoints();
  getglobal(bar):SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
end

function CustomHideBar_ShowBar(bar)
  CHB_LinkFrameToDragButton(bar.."DragButton", bar, "RIGHT");    
end

function CustomHideBar_LockBars()
        CHBBagBarDragButton:Hide();
        CHBActionBarDragButton:Hide();
        CHBMicroBarDragButton:Hide();
        CHBPetBarDragButton:Hide();
        CHBShapeshiftBarDragButton:Hide();
end        

function CustomHideBar_UnLockBars()
        CHBBagBarDragButton:Show();
        CHBActionBarDragButton:Show();
        CHBMicroBarDragButton:Show();
        CHBPetBarDragButton:Show();
        CHBShapeshiftBarDragButton:Show();
end        

function CHB_PrintHelp()
        CHB_ChatMessage("/chb lock|unlock - locks or unlocks toolbars");
        CHB_ChatMessage("/chb <toolbar> hide|show - hides or shows specified toolbar. Toolbar must be one of actionbar, bagbar, microbar, petbar or shapeshiftbar");
        CHB_ChatMessage("See Interface/AddOns/CustomHideBar/README in your World of Warcraft folder for more info");
end

function CHB_LockToggle()
	if ( CHB_Locked == false ) then 
		CustomHideBar_LockBars();
		CHB_Locked = true;
	else
		CustomHideBar_UnLockBars();
		CHB_Locked = false;
	end
end

function CHB_HideToggle()
	if( CHBBagBarDragButton:IsVisible() ) then
		CHBBagBarDragButton:Hide();
		CHBMicroBarDragButton:Hide();
	--	CHBActionBarDragButton:Hide();
		CHBPetBarDragButton:Hide();
		CHBShapeshiftBarDragButton:Hide();
	else
		CHBBagBarDragButton:Show();
		CHBMicroBarDragButton:Show();
		CHBActionBarDragButton:Show();
		CHBPetBarDragButton:Show();
		CHBShapeshiftBarDragButton:Show();
	end
end