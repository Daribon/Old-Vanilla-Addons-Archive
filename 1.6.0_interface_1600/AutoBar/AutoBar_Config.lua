--
--  AutoBar
--
--  Config functions
-- 
--  Author: Marc aka Saien on Hyjal
--  http://64.168.251.69/wow
--

UIPanelWindows["AutoBar_ConfigFrame"] = { area = "left", pushable = 999 };
StaticPopupDialogs["AUTOBAR_CONFIG_CUSTOM_ENTRY"] = {
	text = TEXT("Enter Item Name:"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = 1,
	maxLetters = 32,
	hasWideEditBox = 1,
	OnAccept = function ()
		local editBox = getglobal(this:GetParent():GetName().."WideEditBox");
		if (not AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary]) then
			AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary] = {};
		end
		AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary][AutoBar_CustomEditing_Secondary] = editBox:GetText();
		AutoBar_Config_Tab3_Display();
	end,
	OnShow = function ()
		local editBox = getglobal(this:GetName().."WideEditBox");
		if (AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary] and AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary][AutoBar_CustomEditing_Secondary]) then
			editBox:SetText(AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary][AutoBar_CustomEditing_Secondary]);
		else
			editBox:SetText("");
		end
		editBox:SetFocus();
	end,
	OnHide = function ()
		local editBox = getglobal(this:GetName().."WideEditBox");
		if (ChatFrameEditBox:IsVisible()) then 
			ChatFrameEditBox:SetFocus();
		end
		editBox:SetText("");
	end,
	EditBoxOnEnterPressed = function ()
		local editBox = getglobal(this:GetParent():GetName().."WideEditBox");
		if (not AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary]) then
			AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary] = {};
		end
		AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomEditing_Primary][AutoBar_CustomEditing_Secondary] = editBox:GetText();
		this:GetParent():Hide();
		AutoBar_Config_Tab3_Display();
	end,
	EditBoxOnEscapePressed = function ()
		this:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1
};

local AutoBar_Config_Tab2_PDFrames = {"1", "2", "3", "4"}
local AutoBar_Config_Tab2_PDSides = {
	{ txt="Left", cmd="LEFT" },
	{ txt="Right", cmd="RIGHT" },
	{ txt="Top", cmd="TOP"}, 
	{ txt="Bottom", cmd="BOTTOM"}}
local AutoBar_Config_Tab2_PDSetFrame = "1";
local AutoBar_Config_Tab2_PDSetSide = "LEFT";
local AutoBar_Config_Tab2_PDSetFrameIdx = 1;
local AutoBar_Config_Tab2_PDSetSideIdx = 1;
local AutoBar_CustomViewing_Primary = 1;
AutoBar_CustomEditing_Primary = nil; -- global
AutoBar_CustomEditing_Secondary = nil; -- global

local function AutoBar_Config_Tab2_DetermineChatDock()
	if (AutoBar_Config_Tab2_Docking_ChatFrame:GetChecked()) then
		AutoBar_Config[AutoBar_Player].docked = "CHATFRAME"..AutoBar_Config_Tab2_PDSetFrame.."_"..AutoBar_Config_Tab2_PDSetSide;
	end
end

function AutoBar_Config_Tab3_Display()
	AutoBar_Config_Tab3_Text1:SetText("Custom Category #"..AutoBar_CustomViewing_Primary.."\n(Click to edit)");
	local i;
	for i = 1, 20, 1 do
		local button = getglobal ("AutoBar_Config_Tab3_Entry"..i);
		local buttontext = getglobal ("AutoBar_Config_Tab3_Entry"..i.."TextName");
		-- Hey, could this line get any longer?
		if (AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomViewing_Primary] and AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomViewing_Primary][i] and AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomViewing_Primary][i]== "") then
			AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomViewing_Primary][i] = nil;
		end
		if (AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomViewing_Primary] and AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomViewing_Primary][i]) then
			buttontext:SetText(AutoBar_Config[AutoBar_Player].custom[AutoBar_CustomViewing_Primary][i]);
		else
			buttontext:SetText("(Entry #"..i.." empty)");
		end
		button:UnlockHighlight();
		button:Show();
	end
end

function AutoBar_ConfigButton_SetTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	if (AutoBar_Config[AutoBar_Player].buttonTypes[this:GetID()]) then
		GameTooltip:AddLine(AutoBar_CatInfo[AutoBar_Config[AutoBar_Player].buttonTypes[this:GetID()]].description,"",1,1,1);
	else
		GameTooltip:AddLine("Empty","",1,1,1);
	end
	GameTooltip:Show();
end

function AutoBar_ConfigChooseButton_SetTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	if (AutoBar_ConfigChoose_Maps[this:GetID()]) then
		GameTooltip:AddLine(AutoBar_CatInfo[this.itemType].description,"",1,1,1);
	else
		GameTooltip:AddLine("Empty","",1,1,1);
	end
	GameTooltip:Show();
end

function AutoBar_EditConfig()
	AutoBar_Config_Choose:Hide();
	AutoBar_ConfigFrame_Title:SetText("AutoBar ("..AUTOBAR_VERSION..")");
	if (AutoBar_ConfigFrame:IsVisible()) then
		AutoBar_Config_Tab2_DetermineChatDock();
		HideUIPanel(AutoBar_ConfigFrame);
		AutoBar_Init();
	else
		ShowUIPanel(AutoBar_ConfigFrame);
		AutoBar_Config_Tab_OnClick()
	end
end

function AutoBar_Config_OnLoad()
	PanelTemplates_SetNumTabs(this, 3);
	this.selectedTab = 1;
	PanelTemplates_UpdateTabs(this);
end

function AutoBar_ConfigButton_OnClick()
	local buttonNum = 0;
	local function AutoBar_ConfigButton_SetupButton(itemType)
		if (not AutoBar_CatInfo[itemType].chooseDisplayed) then
			local texture = AutoBar_CatInfo[itemType].texture;
			buttonNum = buttonNum + 1;
			local button = getglobal("AutoBar_ConfigChoose_Button"..buttonNum);
			if (not button) then
				Debug ("BUTTONS RAN OUT: "..buttonNum);
			end
			button.itemType = itemType;
			local text = getglobal(button:GetName().."Count");
			text:SetText("");
			AutoBar_ConfigChoose_Maps[buttonNum] = itemType;
			getglobal(button:GetName().."Icon"):SetTexture(texture);
			button:Show();
			AutoBar_CatInfo[itemType].chooseDisplayed = true;
		end
	end
	AutoBar_Config_Choose:ClearAllPoints();
	AutoBar_Config_Choose:SetPoint("TOPLEFT",this:GetName(),"TOPRIGHT",6,50);
	AutoBar_Config_Choose:Show();
	AutoBar_ConfigChoose_Maps = {};
	AutoBar_ConfigChoose_ChooseButton = this:GetID();
	AutoBar_Config_Choose_Text1:SetText("Basics");
	AutoBar_Config_Choose_Text2:SetText("Ammo");
	AutoBar_Config_Choose_Text3:SetText("Class Specific");
	AutoBar_Config_Choose_Text4:SetText("Rogue Poisons");
	AutoBar_Config_Choose_Text5:SetText("Misc");
	AutoBar_Config_Choose_Text6:SetText("Merged");
	AutoBar_Config_Choose_Text7:SetText("Custom");
	AutoBar_Config_Choose_TextInstruction:SetText("Click on your choice for this button");
	
	for itemType in AutoBar_CatInfo do
		AutoBar_CatInfo[itemType].chooseDisplayed = false;
	end
	-- Basics
	AutoBar_ConfigButton_SetupButton("BANDAGES");			-- 1
	AutoBar_ConfigButton_SetupButton("HEALPOTIONS");		-- 2
	AutoBar_ConfigButton_SetupButton("MANAPOTIONS");		-- 3
	AutoBar_ConfigButton_SetupButton("FOOD");			-- 4
	AutoBar_ConfigButton_SetupButton("WATER");			-- 5
	AutoBar_ConfigButton_SetupButton("HEALTHSTONE");		-- 6
	AutoBar_ConfigButton_SetupButton("HEARTHSTONE");		-- 7
	-- Unusable
	AutoBar_ConfigButton_SetupButton("ARROWS");			-- 8
	AutoBar_ConfigButton_SetupButton("BULLETS");			-- 9
	AutoBar_ConfigButton_SetupButton("THROWN");			-- 10
	-- Class Specific
	AutoBar_ConfigButton_SetupButton("MANASTONE");			-- 11
	AutoBar_ConfigButton_SetupButton("SOULSHARDS");			-- 12
	AutoBar_ConfigButton_SetupButton("RAGEPOTIONS");		-- 13
	AutoBar_ConfigButton_SetupButton("ENERGYPOTIONS");		-- 14
	-- Poisons
	AutoBar_ConfigButton_SetupButton("POISON-CRIPPLING");		-- 15
	AutoBar_ConfigButton_SetupButton("POISON-DEADLY");		-- 16
	AutoBar_ConfigButton_SetupButton("POISON-INSTANT");		-- 17
	AutoBar_ConfigButton_SetupButton("POISON-MINDNUMBING");		-- 18
	AutoBar_ConfigButton_SetupButton("POISON-WOUND");		-- 19
	-- Misc
	AutoBar_ConfigButton_SetupButton("SWIFTNESSPOTIONS");		-- 20
	AutoBar_ConfigButton_SetupButton("SHARPENINGSTONES");		-- 21
	AutoBar_ConfigButton_SetupButton("WEIGHTSTONE");		-- 22
	AutoBar_ConfigButton_SetupButton("UNGORORESTORE");		-- 23
	AutoBar_ConfigButton_SetupButton("UNGOROCHARGE");		-- 24
	AutoBar_ConfigButton_SetupButton("UNGOROFORCE");		-- 25
	AutoBar_ConfigButton_SetupButton("UNGOROSPIRE");		-- 26
	AutoBar_ConfigButton_SetupButton("UNGOROWARD");			-- 27 
	AutoBar_ConfigButton_SetupButton("UNGOROYIELD");		-- 28
	AutoBar_ConfigButton_SetupButton("EXPLOSIVES");			-- 29
	-- Merged
	AutoBar_ConfigButton_SetupButton("MERGED_HEAL");		-- 30
	AutoBar_ConfigButton_SetupButton("MERGED_MANA");		-- 31
	AutoBar_ConfigButton_SetupButton("MERGED_BANDAGE");		-- 32
	for itemType in AutoBar_CatInfo do
		if (not AutoBar_CatInfo[itemType].donotdisplay and not AutoBar_CatInfo[itemType].chooseDisplayed) then
			AutoBar_ConfigButton_SetupButton(itemType);
		end
	end
	local i;
	for i = 1, 12, 1 do 
		local button = getglobal("AutoBar_ConfigChoose_Empty"..i);
		button.itemType = "CUSTOM"..i;
		local text = getglobal(button:GetName().."HotKey");
		text:SetText("#"..i);
		text = getglobal(button:GetName().."Count");
		text:SetText("Custom");
	end	
	local button = getglobal("AutoBar_ConfigChoose_Empty13");
	local text = getglobal(button:GetName().."Count");
	text:SetText("Empty");
end

function AutoBar_ConfigChooseButton_OnClick()
	local itemType = AutoBar_ConfigChoose_Maps[this:GetID()];
	if (not itemType and this.itemType) then
		itemType = this.itemType;
	end
	AutoBar_Config[AutoBar_Player].buttonTypes[AutoBar_ConfigChoose_ChooseButton] = itemType;
	local button = getglobal ("AutoBar_Config_Button"..AutoBar_ConfigChoose_ChooseButton);
	local text = getglobal(button:GetName().."Count");
	local hotkey = getglobal(button:GetName().."HotKey");
	if (itemType) then
		local startidx, endidx;
		startidx, endidx = string.find(itemType,"CUSTOM");
		if (startidx) then
			hotkey:SetText("#"..string.sub(itemType,endidx+1));
			text:SetText("Custom");
		else
			hotkey:SetText("");
			text:SetText("");
		end
		getglobal(button:GetName().."Icon"):SetTexture(AutoBar_CatInfo[AutoBar_Config[AutoBar_Player].buttonTypes[AutoBar_ConfigChoose_ChooseButton]].texture);
	else
		getglobal(button:GetName().."Icon"):SetTexture("");
		hotkey:SetText("");
		text:SetText("Empty");
	end
	button:SetChecked(0);
	AutoBar_Config_Choose:Hide();
end

function AutoBar_Config_Tab_OnClick()
	local oldTab = AutoBar_ConfigFrame.selectedTab;
	local newTab;
	if (this and this:GetID()) then
		newTab = this:GetID();
		PanelTemplates_Tab_OnClick(AutoBar_ConfigFrame);
	else
		newTab = oldTab;
	end
	AutoBar_Config_Choose:Hide();
	if (newTab ~= 1) then
		AutoBar_ConfigFrame_ButtonText:Hide();
		local idx = 1;
		local button = getglobal("AutoBar_Config_Button"..idx);
		while (button) do
			button:Hide();
			idx = idx + 1;
			button = getglobal("AutoBar_Config_Button"..idx);
		end
		AutoBar_Config_Tab1:Hide();
	end
	if (newTab ~= 2) then
		AutoBar_Config_Tab2:Hide();
	end
	if (newTab ~= 3) then
		AutoBar_Config_Tab3:Hide();
	end
	if (newTab == 1) then
		AutoBar_ConfigFrame_ButtonText:Show();
		AutoBar_ConfigFrame_ButtonText:SetText("Click on\nthe button\nyou want\nto change");
		local i = 1;
		local button = getglobal("AutoBar_Config_Button"..i);
		while (button) do
			local hotkey = getglobal(button:GetName().."HotKey");
			local text = getglobal(button:GetName().."Count");
			if (AutoBar_Config[AutoBar_Player].buttonTypes[i]) then
				local startidx, endidx;
				startidx, endidx = string.find(AutoBar_Config[AutoBar_Player].buttonTypes[i],"CUSTOM");
				if (startidx) then
					hotkey:SetText("#"..string.sub(AutoBar_Config[AutoBar_Player].buttonTypes[i],endidx+1));
					text:SetText("Custom");
				else
					hotkey:SetText("");
					text:SetText("");
				end
				getglobal(button:GetName().."Icon"):SetTexture(AutoBar_CatInfo[AutoBar_Config[AutoBar_Player].buttonTypes[i]].texture);
			else
				hotkey:SetText("");
				text:SetText("Empty");
			end
			button:Show();
			i = i + 1;
			button = getglobal("AutoBar_Config_Button"..i);
			AutoBar_Config_Tab1_HideKeys:SetChecked(AutoBar_Config[AutoBar_Player].hidekeys);
			AutoBar_Config_Tab1_HideCount:SetChecked(AutoBar_Config[AutoBar_Player].hidecount);
			AutoBar_Config_Tab1_SelfCast:SetChecked(AutoBar_Config[AutoBar_Player].selfcast);
			AutoBar_Config_Tab1_DoNotSkip:SetChecked(AutoBar_Config[AutoBar_Player].donotskip);
		end
		AutoBar_Config_Tab1:Show();
	elseif (newTab == 2) then
		AutoBar_Config_Tab2_Rows:SetValue(AutoBar_Config[AutoBar_Player].rows);
		AutoBar_Config_Tab2_Columns:SetValue(AutoBar_Config[AutoBar_Player].columns);
		AutoBar_Config_Slider_RowColumns();
		AutoBar_Config_Tab2_Scaling:SetValue(AutoBar_Config[AutoBar_Player].scaling);
		AutoBar_Config_Tab2_ScaleButtons:SetChecked(AutoBar_Config[AutoBar_Player].scalebuttons);
		AutoBar_Config_Tab2_MicroAspect:SetChecked(AutoBar_Config[AutoBar_Player].microaspect);
		AutoBar_Config_Tab2_Docking_UnDocked:SetChecked(0);
		AutoBar_Config_Tab2_Docking_Hide:SetChecked(0);
		AutoBar_Config_Tab2_Docking_MainMenu:SetChecked(0);
		AutoBar_Config_Tab2_Docking_ChatFrame:SetChecked(0);
		AutoBar_Config_Tab2_Docking_Locked:SetChecked(0);
		if (AutoBar_Config[AutoBar_Player].docked == "UNDOCKED") then
			AutoBar_Config_Tab2_Docking_UnDocked:SetChecked(1);
		elseif (AutoBar_Config[AutoBar_Player].docked == "HIDE") then
			AutoBar_Config_Tab2_Docking_Hide:SetChecked(1);
		elseif (AutoBar_Config[AutoBar_Player].docked == "MAINMENU") then
			AutoBar_Config_Tab2_Docking_MainMenu:SetChecked(1);
		elseif (string.find(AutoBar_Config[AutoBar_Player].docked,"CHATFRAME")) then
			AutoBar_Config_Tab2_Docking_ChatFrame:SetChecked(1);
		        local idx,ridx = string.find(AutoBar_Config[AutoBar_Player].docked,"CHATFRAME");
			local rest = string.sub(AutoBar_Config[AutoBar_Player].docked,ridx+1);
			local frame = "1";
			local side = "LEFT";
			idx,ridx = string.find(rest,"_");
			if (idx and ridx and ridx > 1) then
				frame = tonumber(string.sub(rest,1,ridx-1));
				if (frame and frame > 0) then
					frame = tostring(frame);
				else
					frame = "1";
				end
			end
			rest = string.sub(rest,idx+1);
			if (rest == "TOP" or rest == "BOTTOM" or rest == "LEFT" or rest == "RIGHT") then
				side = rest;
			end
		
			AutoBar_Config_Tab2_PDSetFrame = frame;
			AutoBar_Config_Tab2_PDSetSide = side;
			AutoBar_Config_Tab2_Docking_ChatFrame_PDSide_Init();
			AutoBar_Config_Tab2_Docking_ChatFrame_PDFrame_Init();
			UIDropDownMenu_SetSelectedID(AutoBar_Config_Tab2_Docking_ChatFrame_PDFrame,AutoBar_Config_Tab2_PDSetFrameIdx);
			UIDropDownMenu_SetSelectedID(AutoBar_Config_Tab2_Docking_ChatFrame_PDSide,AutoBar_Config_Tab2_PDSetSideIdx);
			
		elseif (AutoBar_Config[AutoBar_Player].docked == "LOCKED") then
			AutoBar_Config_Tab2_Docking_Locked:SetChecked(1);
		end
		AutoBar_Config_Tab2:Show();
	elseif (newTab == 3) then
		AutoBar_Config_Tab3_Display();
		AutoBar_Config_Tab3:Show();
	end
end
	
function AutoBar_Config_Slider_RowColumns()
	local rows = AutoBar_Config_Tab2_Rows:GetValue();
	local columns = AutoBar_Config_Tab2_Columns:GetValue();
	if (not rows or not columns or rows == 0 or columns == 0) then
		return;
	end
	while (rows*columns > 12) do 
		this:SetValue(this:GetValue()-1);
		rows = AutoBar_Config_Tab2_Rows:GetValue();
		columns = AutoBar_Config_Tab2_Columns:GetValue();
	end
	AutoBar_Config_Tab2_Text1:SetText("Select the number of\nrows and columns of\nbuttons to display.\nCannot exceed 12 total\n\nRows: "..rows.."  Columns: "..columns.."\n     Total:"..(rows*columns));
	AutoBar_Config[AutoBar_Player].rows = AutoBar_Config_Tab2_Rows:GetValue();
	AutoBar_Config[AutoBar_Player].columns = AutoBar_Config_Tab2_Columns:GetValue();
end

function AutoBar_Config_Slider_Scaling()
	local newScaling = this:GetValue();
	if (newScaling >= 0.25 and newScaling <= 2.0) then
		AutoBar_Config[AutoBar_Player].scaling = newScaling;
	end
end

function AutoBar_Config_UpdateScaling()
	AutoBar_Config[AutoBar_Player].scalebuttons = this:GetChecked();
end

function AutoBar_Config_ChooseDocking()
	local name = this:GetName();
	local checked = this:GetChecked();
	if (checked) then
		AutoBar_Config_Tab2_Docking_UnDocked:SetChecked(0);
		AutoBar_Config_Tab2_Docking_Hide:SetChecked(0);
		AutoBar_Config_Tab2_Docking_MainMenu:SetChecked(0);
		AutoBar_Config_Tab2_Docking_ChatFrame:SetChecked(0);
		AutoBar_Config_Tab2_Docking_Locked:SetChecked(0);
		this:SetChecked(1);
		if (name == "AutoBar_Config_Tab2_Docking_UnDocked") then
			AutoBar_Config[AutoBar_Player].docked = "UNDOCKED";
		elseif (name == "AutoBar_Config_Tab2_Docking_Hide") then
			AutoBar_Config[AutoBar_Player].docked = "HIDE";
		elseif (name == "AutoBar_Config_Tab2_Docking_MainMenu") then
			AutoBar_Config[AutoBar_Player].docked = "MAINMENU";
		elseif (name == "AutoBar_Config_Tab2_Docking_ChatFrame") then
			AutoBar_Config_Tab2_DetermineChatDock();
		elseif (name == "AutoBar_Config_Tab2_Docking_Locked") then
			AutoBar_EngageLock();
		end
	elseif (name ~= "AutoBar_Config_Tab2_Docking_MainMenu" and not checked) then
		AutoBar_Config_Tab2_Docking_MainMenu:SetChecked(1);
		AutoBar_Config[AutoBar_Player].docked = "MAINMENU";
	elseif (name ~= "AutoBar_Config_Tab2_Docking_MainMenu" and not checked) then
		AutoBar_Config_Tab2_Docking_UnDocked:SetChecked(1);
		AutoBar_Config[AutoBar_Player].docked = "UNDOCKED";
	end
		
end

function AutoBar_Config_TextEntry_OnClick()
	AutoBar_CustomEditing_Primary = AutoBar_CustomViewing_Primary;
	AutoBar_CustomEditing_Secondary = this:GetID();
	StaticPopup_Show("AUTOBAR_CONFIG_CUSTOM_ENTRY");
end

function AutoBar_Config_Tab3_NextPage_OnClick()
	if (AutoBar_CustomViewing_Primary == 12) then
		AutoBar_CustomViewing_Primary = 1;
	else
		AutoBar_CustomViewing_Primary = AutoBar_CustomViewing_Primary + 1;
	end
	AutoBar_Config_Tab3_Display();
end

function AutoBar_Config_Tab3_PrevPage_OnClick()
	if (AutoBar_CustomViewing_Primary == 1) then
		AutoBar_CustomViewing_Primary = 12;
	else
		AutoBar_CustomViewing_Primary = AutoBar_CustomViewing_Primary - 1;
	end
	AutoBar_Config_Tab3_Display();
end

function AutoBar_Config_Tab2_Docking_ChatFrame_PDFrame_Init()
	local info;
	local i;
	for i = 1, table.getn(AutoBar_Config_Tab2_PDFrames), 1 do
		info = {};
		info.text = tostring(AutoBar_Config_Tab2_PDFrames[i]);
		info.func = AutoBar_Config_Tab2_Docking_ChatFrame_PDFrame_OnClick;
		UIDropDownMenu_AddButton(info);
		if (AutoBar_Config_Tab2_PDFrames[i] == AutoBar_Config_Tab2_PDSetFrame) then
			AutoBar_Config_Tab2_PDSetFrameIdx = i;
			info.checked = 1;
		end
	end
	UIDropDownMenu_SetSelectedID(AutoBar_Config_Tab2_Docking_ChatFrame_PDFrame,AutoBar_Config_Tab2_PDSetFrameIdx);
end

function AutoBar_Config_Tab2_Docking_ChatFrame_PDSide_Init()
	local info;
	local i;
	for i = 1, table.getn(AutoBar_Config_Tab2_PDSides), 1 do
		info = {};
		info.text = AutoBar_Config_Tab2_PDSides[i].txt;
		info.func = AutoBar_Config_Tab2_Docking_ChatFrame_PDSide_OnClick;
		if (AutoBar_Config_Tab2_PDSides[i].cmd == AutoBar_Config_Tab2_PDSetSide) then 
			AutoBar_Config_Tab2_PDSetSideIdx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(AutoBar_Config_Tab2_Docking_ChatFrame_PDSide,AutoBar_Config_Tab2_PDSetSideIdx);
end

function AutoBar_Config_Tab2_Docking_ChatFrame_PDFrame_OnClick()
	AutoBar_Config_Tab2_PDSetFrame = AutoBar_Config_Tab2_PDFrames[this:GetID()];
	AutoBar_Config_Tab2_PDSetFrameIdx = this:GetID();
	UIDropDownMenu_SetSelectedID(AutoBar_Config_Tab2_Docking_ChatFrame_PDFrame, this:GetID());
end

function AutoBar_Config_Tab2_Docking_ChatFrame_PDSide_OnClick()
	AutoBar_Config_Tab2_PDSetSide = AutoBar_Config_Tab2_PDSides[this:GetID()].cmd;
	AutoBar_Config_Tab2_PDSetSideIdx = this:GetID();
	UIDropDownMenu_SetSelectedID(AutoBar_Config_Tab2_Docking_ChatFrame_PDSide,this:GetID());
end


