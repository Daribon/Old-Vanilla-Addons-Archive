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

Cosmos_MppBoolean = 1;

function Cosmos_Mpp(toogle)
	Cosmos_MppBoolean = toogle;
end

-- Updates the MP bar of the party frame with a % instead of the mana
function Cosmos_TextStatusBar_UpdateTextString()
	if ( this:GetParent() ~= nil ) then 
		local frame = this:GetParent():GetName();
		if (frame ~= "PartyMemberFrame1" and frame ~= "PartyMemberFrame2" and frame ~= "PartyMemberFrame3" and frame ~= "PartyMemberFrame4" and frame ~= "PartyMemberFrame5") then
			return;
		end
		local string = this.TextString;
		local value = this:GetValue();
		local valueMin, valueMax = this:GetMinMaxValues();
		local percent = Sea.math.round(value / valueMax * 100);
		if ( Cosmos_MppBoolean == 1 and string and value > 0 and this.prefix ) then
			string:SetText(this.prefix.." "..percent.."%");
		end
	end
end
HookFunction("TextStatusBar_UpdateTextString", "Cosmos_TextStatusBar_UpdateTextString", "after");


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
HookFunction("ContainerFrameItemButton_OnClick", "Cosmos_ContainerFrameItemButton_OnClick", "hide");

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
HookFunction("SetItemRef", "Cosmos_SetItemRef", "hide");

function Cosmos_TurnOnPlayerHP(toggle)
	DefaultStatusBarText(PlayerFrameHealthBar, toggle);
	DefaultStatusBarText(PlayerFrameManaBar, toggle);
	if (toogle and (toogle == "1" or toogle == 1 or toggle == "show") ) then
		DefaultStatusBarText(MainMenuExpBar, toggle);
	end
end

function Cosmos_TurnOnPartyHP(toggle) 
	local i = 1;
	for i = 1, 4, 1 do
		local bar = getglobal("PartyMemberFrame"..i.."HealthBar");
		DefaultStatusBarText(bar, toggle);
	end
end

function Cosmos_TurnOnPartyMana(toggle) 
	local i = 1;
	for i = 1, 4, 1 do
		local bar = getglobal("PartyMemberFrame"..i.."ManaBar");
		DefaultStatusBarText(bar, toggle);
	end
end

function Cosmos_TurnOnPetHP(toggle)
	DefaultStatusBarText(PetFrameHealthBar, toggle);
end

function Cosmos_TurnOnPetMana(toggle)
	DefaultStatusBarText(PetFrameManaBar, toggle);
end


function Cosmos_TurnOnTargetHP(toggle)
	DefaultStatusBarText(TargetFrameHealthBar, toggle);
end

function Cosmos_TurnOnAllText(toggle)
	if ( toggle == 1) then
		--OptionsFrameCheckButtons["STATUS_BAR_TEXT"].value = 1;
	else
		--OptionsFrameCheckButtons["STATUS_BAR_TEXT"].value = 0;
	end	
	SetCVar("STATUS_BAR_TEXT", toggle, 5);
end
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
-- Hides/shows the buffs at all times
function Cosmos_HideBuffsToggle(toggle)
	if ( toggle ~= 0 ) then
		Cosmos_HideBuffs = true;
	else
		Cosmos_HideBuffs = false;
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

-- Game Tooltip Relocator START
function Cosmos_RelocateGameTooltip(toggle)
	if ( toggle == 0 ) then
		Cosmos_RelocateTooltip = true;
	else
		Cosmos_RelocateTooltip = false;
	end
end
-- Game Tooltip Relocator END

-- Game Tooltip Relocator2 START
function Cosmos_RelocateGameTooltipToMouse(toggle)
	if ( toggle == 0 ) then
		Cosmos_RelocateTooltip_ToMouse = false;
	else
		Cosmos_RelocateTooltip_ToMouse = true;
	end
end
-- Game Tooltip Relocator2 END

-- Game Uber Tooltip Relocator START
function Cosmos_UberRelocateTooltip(toggle)
	if ( toggle == 0 ) then
		Cosmos_RelocateUberTooltip = nil;
	else
		Cosmos_RelocateUberTooltip = true;
	end
end
-- Game Uber Tooltip Relocator END

-- Cosmos channels functionality START
function Cosmos_ToggleUseChatFunctions(toggle)
	if ( toggle == 0 ) then
		if (CosmosMaster_UseChatFunctions ~= nil) then
			CosmosMaster_UseChatFunctions = nil;
			CosmosMaster_ChanList = {};
			CosmosMaster_CleanChannels();
		end
	else
		if (not (CosmosMaster_UseChatFunctions == true)) then
			CosmosMaster_UseChatFunctions = true;
		end
	end
end
-- Cosmos channels functionality END

-- Cosmos distance increaser functionality START
Cosmos_DistanceToggled = 0;
function Cosmos_ToggleDistance(toggle, value)
	local oldvalue = Cosmos_DistanceToggled;
	if ( toggle == 1 ) then
		ConsoleExec("targetNearestDistance = \"50.000000\"");
	else
		ConsoleExec("targetNearestDistance = \"20.000000\"");
	end
	if ( (oldvalue) and ( toggle ~= oldvalue ) ) then
		--Sea.io.print(COSMOS_CONFIG_DISTANCE_CHAT);
	end
	Cosmos_DistanceToggled = toggle;
end
-- Cosmos distance increaser functionality END


-- Cosmos START
function PartyMemberFrame_UpdateCosmos(type, info, arg1, arg2, arg3, arg4)
	--Sea.io.print ( "PMF_UC: '"..arg1.."'");
	if (arg1 == "<UC>" or arg1 == '<CL>') then -- UC : Use Cosmos
		for i = 1, MAX_PARTY_MEMBERS, 1 do
			if (UnitName("party"..i) == arg2) then
				getglobal("PartyMemberFrame"..i.."CosmosIcon"):Show();
			end
		end
	elseif (arg1 == "<AC>") then
		Cosmos_SendPartyMessage("<UC>");
	end

	return 1;
end
-- Cosmos END

function Cosmos_BankButtonToggle()
	if ( BankFrame:IsVisible() ) then 
		HideUIPanel(BankFrame);
	else
		ShowUIPanel(BankFrame);
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
 		"COS_COS_PLAYERHPMPXPTXT",		--CVar
 		"CHECKBOX",					--Things to use
		TEXT(COSMOS_CONFIG_PLHPMPXP),
		TEXT(COSMOS_CONFIG_PLHPMPXP_INFO),
 		Cosmos_TurnOnPlayerHP,		--Callback
 		0							--Default Checked/Unchecked
 		);

	Cosmos_RegisterConfiguration(
 		"COS_COS_PARTYHPTXT",			--CVar
 		"CHECKBOX",					--Things to use
		TEXT(COSMOS_CONFIG_PARTYHP),
		TEXT(COSMOS_CONFIG_PARTYHP_INFO),
 		Cosmos_TurnOnPartyHP,		--Callback
 		0							--Default Checked/Unchecked
 		);
	Cosmos_RegisterConfiguration(
 		"COS_COS_PARTYMANATXT",			--CVar
 		"CHECKBOX",					--Things to use
		TEXT(COSMOS_CONFIG_PARTYMANA),
		TEXT(COSMOS_CONFIG_PARTYMANA_INFO),
 		Cosmos_TurnOnPartyMana,			--Callback
 		0						--Default Checked/Unchecked
 		);
	Cosmos_RegisterConfiguration(
 		"COS_COS_PETHPTXT",				--CVar
 		"CHECKBOX",					--Things to use
		TEXT(COSMOS_CONFIG_PETHP),
		TEXT(COSMOS_CONFIG_PETHP_INFO),
 		Cosmos_TurnOnPetHP,			--Callback
 		0							--Default Checked/Unchecked
 		);

	Cosmos_RegisterConfiguration(
 		"COS_COS_PETMANATXT",			--CVar
 		"CHECKBOX",					--Things to use
		TEXT(COSMOS_CONFIG_PETMANA),
		TEXT(COSMOS_CONFIG_PETMANA_INFO),
 		Cosmos_TurnOnPetMana,		--Callback
 		0							--Default Checked/Unchecked
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
 		"COS_COS_PARTYSHOWBUFF",		--CVar
 		"CHECKBOX",					--Things to use
		TEXT(COSMOS_CONFIG_PARTYBUFF),
		TEXT(COSMOS_CONFIG_PARTYBUFF_INFO),
 		Cosmos_HideBuffsToggle,		--Callback
 		0							--Default Checked/Unchecked
 		);

-- This doesn't work.  It looks like the text string is completely missing in the XML now.  It could likely be reconstructed by someone interested.
-- 	CosmosMaster_Register(
-- 		"COS_TARGETHEALTHTXT", --CVar
-- 		"CHECKBOX",								 --Things to use
-- 		"Always Display Target Health %",		 --Simple String
-- 		"Always displays % of the health remaining\n for targetted monsters.",
-- 		Cosmos_TurnOnTargetHP,		 --Callback
-- 		1				 --Default Checked/Unchecked
-- 		);
	Cosmos_RegisterConfiguration(
		"COS_COS_RELOC_TOOLTIP",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_RELOCTT),
		TEXT(COSMOS_CONFIG_RELOCTT_INFO),
		Cosmos_RelocateGameTooltip,
		0
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_RELOC_TOOLTIP_MOUSE",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_RELOCTT_2M),
		TEXT(COSMOS_CONFIG_RELOCTT_2M_INFO),
		Cosmos_RelocateGameTooltipToMouse,
		0
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_RELOC_TOOLTIP_UBER",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_RELOCTT_UBER),
		TEXT(COSMOS_CONFIG_RELOCTT_UBER_INFO),
		Cosmos_UberRelocateTooltip,
		0
		);
	--[[ Removed for the moment.
	
 	Cosmos_RegisterConfiguration(
 		"COS_COS_BAGSSCALE", --CVar
 		"BOTH",									 --Things to use
 		"Adjust Bag Scale",						 --Simple String
 		"Adjusts the scale of all bags from .3 to 1.2 times its original size. Any more and it breaks. Toggle to reset.",
 		Cosmos_SetBagsScale,					 --Callback
 		0,										 --Default Checked/Unchecked
 		1,										 --Default Value
 		.3,										 --Min value
 		1.2,									 --Max value
 		"Scale",								 --Slider Text
 		.01,									 --Slider Increment
 		1,										 --Slider state text on/off
 		"\%",									 --Slider state text append
 		100										 --Slider state text multiplier
 		);

	--]]--

	Cosmos_RegisterConfiguration(
		"COS_COS_SHIFTSELL",
		"CHECKBOX", 
		TEXT(COSMOS_CONFIG_S2SELL),
		TEXT(COSMOS_CONFIG_S2SELL_INFO),
		Cosmos_ShiftSell,
		0
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_MPP",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_MPP),
		TEXT(COSMOS_CONFIG_MPP_INFO),
		Cosmos_Mpp,
		1
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
		"COS_COS_USECHAN",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_USECHAN),
		TEXT(COSMOS_CONFIG_USECHAN_INFO),
		Cosmos_ToggleUseChatFunctions,
		1
		);
	Cosmos_RegisterConfiguration(
		"COS_COS_DISTANCE",
		"CHECKBOX",
		TEXT(COSMOS_CONFIG_DISTANCE),
		TEXT(COSMOS_CONFIG_DISTANCE_INFO),
		Cosmos_ToggleDistance,
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
	]]	
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
	--[[	
		Removed because blizzard disabled it.
	Cosmos_RegisterButton (
		COSMOS_BUTTON_BANK, 
		COSMOS_BUTTON_BANK_SUB, 
		COSMOS_BUTTON_BANK_TIP, 
		"Interface\\Icons\\Racial_Dwarf_FindTreasure",
		Cosmos_BankButtonToggle
		);
	]]
       -- Cosmos Party Button
	Cosmos_RegisterChatWatch( 
		"PARTYCOSMOSBUTTON", 
		{CHANNEL_COSMOS, CHANNEL_PARTY}, 
		PartyMemberFrame_UpdateCosmos, 
		"Add the cosmos button near the party member" 
		);
	-- Cosmos Userlist
	Cosmos_RegisterChatWatch( 
		"COSMOSUSERSONLINE", 
		{CHANNEL_COSMOS} ,
		CosmosMaster_CosmosUsers_Update,
		"Add cosmos users who login to the list"
		);
end
