--[[
 The Original Cosmos UI Configuration values
 
 This is the simplest example of how CosmosMaster can be used. 
 Simply include this lua file in CosmosIncludes.xml file,
 then register it under the proper event handlers.
 
 
 Original code by Justin Crites (Xiphoris)
 Registration design by Alex Brazie (AlexanderYoshi)
]]--

-- allows you to scroll text in chat with the mouse wheel
-- readded OnMouseWheel link in ChatFrame.xml, and made it optional.
Cosmos_UseMouseWheelToScrollChat = false;

function Cosmos_ChangeUseMouseWheelToScrollChat(value)
	if ( ( value == 1 ) or ( value == true ) ) then 
		Cosmos_UseMouseWheelToScrollChat = true;
	else
		Cosmos_UseMouseWheelToScrollChat = false;
	end
end


Cosmos_ShiftToSell = false;

function Cosmos_ContainerFrameItemButton_OnClick(button, ignoreShift)
	if ( button == "RightButton" ) then
		if ( Cosmos_ShiftToSell == true ) then
			if (  MerchantFrame:IsVisible() ) then
				if ( IsShiftKeyDown() ) then
					UseContainerItem(this:GetParent():GetID(), this:GetID());
				end
			else
					UseContainerItem(this:GetParent():GetID(), this:GetID());					
			end
		else 
			UseContainerItem(this:GetParent():GetID(), this:GetID());
		end
	else
		return true;
	end

	return false;
end
Sea.util.hook("ContainerFrameItemButton_OnClick", "Cosmos_ContainerFrameItemButton_OnClick", "hide");

-- Adds ALT Invites to WhoLinks
function Cosmos_SetItemRef (link) 
	if ( strsub(link, 1, 6) == "Player" ) then
		local name = strsub(link, 8);
		if ( name and (strlen(name) > 0) ) then
			if ( IsAltKeyDown() ) then
				InviteByName(name);
				return false;
			else					
			end
		end
	end
	return true;
end
Sea.util.hook("SetItemRef", "Cosmos_SetItemRef", "hide");

--[[
function Cosmos_SetPaperDollScale(scale,toggle) 
	if ( scale == 0 or toggle==0 ) then scale=1; end
	PaperDollFrame:SetScale(scale);
end
]]--

function Cosmos_TurnOnFPSMove(toggle)
	-- Move the FPS
	if (toggle == 1) then
		FramerateLabel:ClearAllPoints();
		FramerateLabel:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
	else
		FramerateLabel:ClearAllPoints();
		FramerateLabel:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 0, 64);
	end
end


-- Begin Keypad stuff

Cosmos_UseAbbreviatedShortcutNames = 0;

function Cosmos_UpdateAllButtonHotKeys()
	if ( SideBarButton_UpdateAllHotkeys ) then
		SideBarButton_UpdateAllHotkeys();
	end
	if ( PopBar_Update ) then
		PopBar_Update(true);
	end
	if ( SecondActionButton_UpdateAllHotkeys ) then
		SecondActionButton_UpdateAllHotkeys();
	end
	local button = nil;
	local actionButtonFormatStr = "ActionButton%d";
	local bonusActionButtonFormatStr = "BonusActionButton%d";
	for i = 1, 12 do
		button = getglobal(format(actionButtonFormatStr, i));
		if ( button ) then
			if ( SideBarButton_UpdateHotkeys ) then
				SideBarButton_UpdateHotkeys(nil, button);
			end
		end
		button = getglobal(format(bonusActionButtonFormatStr, i));
		if ( button ) then
			if ( SideBarButton_UpdateHotkeys ) then
				SideBarButton_UpdateHotkeys(nil, button);
			end
		end
	end
end

function Cosmos_SetUseAbbreviatedShortcutNames(toggle)
	if ( Cosmos_UseAbbreviatedShortcutNames ~= toggle ) then
		Cosmos_UseAbbreviatedShortcutNames = toggle;
		Cosmos_UpdateAllButtonHotKeys();
	end
end

Cosmos_ShortcutAbbreviations = {
	["Shift"] = "S",
	["Alt"] = "A",
	["Ctrl"] = "C",
	["Control"] = "C",
	["shift"] = "S",
	["alt"] = "A",
	["ctrl"] = "C",
	["control"] = "C",
	["SHIFT"] = "S",
	["ALT"] = "A",
	["CTRL"] = "C",
	["CONTROL"] = "C"
};

-- Begin Keypad stuff
old_KeyBindingFrame_GetLocalizedName = KeyBindingFrame_GetLocalizedName;
function KeyBindingFrame_GetLocalizedName(name, prefix)
       -- call the previous routine
       local text = old_KeyBindingFrame_GetLocalizedName(name, prefix);

       -- now rename the numeric keypad names
       -- Sea.io.print("MyKeyBindingFrame_GetLocalizedName: "..text..".");
       if (text == "NUMPADEQUALS") then
               text = "KP =";
       elseif(string.find(text,"Num Pad ")) then
       		local startpos, endpos = string.find(text,"Num Pad ");
       		if (startpos and (startpos > 1)) then
       			text = string.sub(text, 1, startpos - 1).."KP "..string.sub(text, endpos + 1, strlen(text));
       		else
       			text = "KP"..string.sub(text, 8);
       		end               
       end
		if ( Cosmos_UseAbbreviatedShortcutNames == 1 ) then
			for str, repl in Cosmos_ShortcutAbbreviations do
				text = string.gsub(text, str, repl);
			end
		end

       return text;
end
-- End Keypad stuff

function Cosmos_ShiftSell(toggle)
	if ( toggle ~= 0 ) then
		Cosmos_ShiftToSell = true;
	else
		Cosmos_ShiftToSell = false;
	end
end

-- Quest Scroll speed
function Cosmos_SetQuestTextScrollSpeed(toggle, speed)
	if ( toggle ~= 0 ) then 
		--setglobal('QUEST_FADING_ENABLE',true);
		setglobal('QUEST_DESCRIPTION_GRADIENT_CPS',speed);
	else
		--setglobal('QUEST_FADING_ENABLE',false);
		setglobal('QUEST_DESCRIPTION_GRADIENT_CPS',600000);
	end
end


function Cosmos_ResetPartyFrames()
	local lastFrame = PartyMemberFrame1;
	lastFrame:ClearAllPoints();
	lastFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 10, -128);
	local newFrame = nil;
	for i = 2, MAX_PARTY_MEMBERS do
		newFrame = getglobal(string.format("PartyMemberFrame%d", i));
		if ( newFrame ) then
			newFrame:ClearAllPoints();
			newFrame:SetPoint("TOPLEFT", lastFrame:GetName(), "BOTTOMLEFT", 0, -10);
		end
		lastFrame = newFrame;
	end
end

function Cosmos_Registers()
	-- Register with the CosmosMaster
	Cosmos_RegisterConfiguration(
		"COS_COS",
		"SECTION",
		TEXT(COSMOS_CONFIG_SEP),
		TEXT(COSMOS_CONFIG_SEP_INFO)
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_DEFAULTSEPARATOR",
		"SEPARATOR",
		TEXT(COSMOS_CONFIG_SEP),
		TEXT(COSMOS_CONFIG_SEP_INFO)
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_QUESTSCROLL",
		"BOTH",
		COSMOS_CONFIG_QUESTSCROLL,
		COSMOS_CONFIG_QUESTSCROLL_INFO,
		Cosmos_SetQuestTextScrollSpeed,
		0,
 		40,				--Default Value
 		40,				--Min value
 		400,			--Max value
 		COSMOS_CONFIG_QUESTSCROLL_CHARS,	--Slider Text
 		20,				--Slider Increment
 		1,				--Slider state text on/off
 		COSMOS_CONFIG_QUESTSCROLL_APPEND,			--Slider state text append
 		1				--Slider state text multiplier
		);

	Cosmos_RegisterConfiguration(
		"COS_COS_SHIFTSELL",
		"CHECKBOX", 
		TEXT(COSMOS_CONFIG_S2SELL),
		TEXT(COSMOS_CONFIG_S2SELL_INFO),
		Cosmos_ShiftSell,
		0
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_SCROLLCHATWITHMOUSEWHEEL",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_MWHEELCHAT),
		TEXT(COSMOS_CONFIG_MWHEELCHAT_INFO),
		Cosmos_ChangeUseMouseWheelToScrollChat,
		0
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_FPSMOVE",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_FPSMOVE),
		TEXT(COSMOS_CONFIG_FPSMOVE_INFO),
		Cosmos_TurnOnFPSMove,
		0
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_SHORTCUT_NAMES",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_SHORTCUT_NAMES),
		TEXT(COSMOS_CONFIG_SHORTCUT_NAMES_INFO),
		Cosmos_SetUseAbbreviatedShortcutNames,
		Cosmos_UseAbbreviatedShortcutNames
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_RESET_PARTY_FRAMES",
		"BUTTON",
		TEXT(COSMOS_CONFIG_RESET_PARTY_FRAMES),
		TEXT(COSMOS_CONFIG_RESET_PARTY_FRAMES_INFO),
		Cosmos_ResetPartyFrames,
		0,
		0,
		0,
		0,
		TEXT(COSMOS_CONFIG_RESET_PARTY_FRAMES_TEXT)
		);
	

	--[[
	-- Cosmos Help Button
	Cosmos_RegisterButton ( 
		COSMOS_BUTTON_COSMOS_HELP, 
		COSMOS_BUTTON_COSMOS_HELP_SUB, 
		COSMOS_BUTTON_COSMOS_HELP_TIP, 
		"Interface\\Icons\\INV_Misc_Book_08", 
		function()
			LaunchURL("http://www.wowwiki.com/index.php/Cosmos_Portal"); 		
		end
		);
	]]--
	-- Cosmos Configuration Button
	Cosmos_RegisterButton ( 
		COSMOS_BUTTON_COSMOS, 
		COSMOS_BUTTON_COSMOS_SUB, 
		COSMOS_BUTTON_COSMOS_TIP, 
		"Interface\\Icons\\Ability_Repair", 
		function()
			if (CosmosMasterFrame:IsVisible()) then 
				HideUIPanel(CosmosMasterFrame);
			else 
				PlaySound("igMainMenuOption");
				ShowUIPanel(CosmosMasterFrame);
				CosmosMasterFrame_Show();
			end
		end
		);

end
