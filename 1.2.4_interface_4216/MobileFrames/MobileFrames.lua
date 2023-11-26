--------------------------------------------------------------------------
-- MobileFrames.lua 
--------------------------------------------------------------------------
--[[
Mobile Frames

By: AnduinLothar    <Anduin@cosmosui.org>

Makes selected frames mobile by dragging their top bar.
All would-be mobile frames must have a mobile parent already.
If the parent's right HitRectInsets are different than 30 pixels then OnShow must
be replaced with a modified width update. (See QuestLogFrameMobileBar for example)

Slash Commands:
	"/mflist" - lists currently mobile frames.
	"/mfreset [Frame]" - resets the position of that mobile frame. No frame resets all.
	"/mfenable [Frame]" - enables that mobile frame. No frame enables all.
	"/mfdisable [Frame]" - disables that mobile frame. No frame disables all.
	"/mfanchors" - toggles the unit frame anchor visibility.
	"/mfsound" - toggles the splash sound when unit frame anchors are hiden.

Currently Mobile Frames:
	LootFrame,
	QuestLogFrame,
	TradeFrame,
	MerchantFrame,
	ClassTrainerFrame,
	TradeSkillFrame,
	MacroFrame,
	FriendsFrame,
	CharacterFrame,
	SpellBookFrame,
	InspectFrame,
	CraftFrame,
	BankFrame,
	QuestFrame,
	GossipFrame,
	GuildRegistrarFrame,
	ItemTextFrame,
	TabardFrame,
	PetStableFrame,
	TradeFrame,
	Containers (Bags)
	PlayerFrame,
	TargetFrame,
	PartyMemberFrames
	
List of All Builtin UI Frames:
	GameMenuFrame,
	OptionsFrame,
	SoundOptionsFrame,
	UIOptionsFrame,
	CharacterFrame,
	InspectFrame,
	ItemTextFrame,
	SpellBookFrame,
	LootFrame,
	TaxiFrame,
	QuestFrame,
	QuestLogFrame,
	ClassTrainerFrame,
	TradeSkillFrame,
	MerchantFrame,
	TradeFrame,
	BankFrame,
	FriendsFrame,
	SuggestFrame,
	CraftFrame,
	WorldMapFrame,
	KeyBindingFrame,
	CinematicFrame,
	TabardFrame,
	GuildRegistrarFrame,
	PetitionFrame,
	HelpFrame,
	MacroFrame,
	GossipFrame,
	MailFrame,
	BattlefieldFrame,
	TalentFrame,
	PetStableFrame,
	AuctionFrame


Change Log:
	v1.0 (2/9/05)
		Initial Release:
		-Created MobileBarTemplate for instantiation.
		-Made Mobile: LootFrame, QuestLogFrame, FriendsFrame, CharacterFrame, SpellBookFrame.
	v1.1 (2/14/05)
		-Limited open windows using default 'pushable' status.
		-Made Mobile: TradeFrame, MerchantFrame, ClassTrainerFrame, TradeSkillFrame,
		MacroFrame, InspectFrame, CraftFrame, BankFrame.
	v1.11 (2/15/05)
		-Fixed a bug that would cause wow to loop infinitely when you opened the guild or
		who tabs of the Friends Frame.
	v1.2 (2/18/05)
		-Addded a bunch of Cosmos Options as well as new slash commands. Reset, enable or
		disable all or individually.
	v1.3 (2/20/05)
		-Fixed Massive frame lag issues/bugs when you moved some frames on top of eachother.
		-Cleaned up some XML code.
	v1.4 (2/21/05)
		-Added more readable and localizable frame names in the cosmos config.
		-Fixed a bug on frame reset involving a code typo.
		-Added French and German Localization
	v1.41 (2/28/05)
		-Fixed a '/mflist' bug and made it a little more useful for localized versions.
		It now shows actual frame name used in reset and enable/disable along with a more readable version.
	v1.5 (3/7/05)
		-Added Mobile Containers!
		-Made Mobile: QuestFrame, GossipFrame, GuildRegistrarFrame, ItemTextFrame, TabardFrame, 
		PetStableFrame, TradeFrame, Containers
	v1.6 (3/9/05)
		-Added Unit Frames!
		-Made Mobile: PlayerFrame, TargetFrame, PartyMemberFrames
		-Added Anchor for Unit Frame dragging.  Use binding or "/mfanchors" to toggle visibility.
		-Added Splash sound when you drop Unit Frame Anchors.  Use "/mfsound" to toggle.
		-Anchor moves to left of Unit Frame if toggled while off screen.


	$Id: MobileFrames.lua 999 2005-03-11 02:07:10Z AlexYoshi $
	$Rev: 999 $
	$LastChangedBy: AlexYoshi $
	$Date: 2005-03-10 21:07:10 -0500 (Thu, 10 Mar 2005) $


]]--

MobileFrames_AnchorsSoundOn = true;

MobileFrames_UIPanelWindowBackup = {};
MobileFrames_UIPanelsVisible = {};
MobileFrames_MasterEnableList = {};
MobileFrames_ResetFrame = {};			--reset a mobile frame using MobileFrames_ResetFrame[frameName]() used for cosmos config
MobileFrames_EnableToggle = {};			--enable/disable a mobile frame using MobileFrames_EnableToggle[frameName](1/0) used for cosmos config
MobileFrames_EnabledByDefault = true;   --true or false, never use nil
local SavedCloseWindows = nil;

MOBILEFRAMES_CONTAINER_POINT = "Point";
MOBILEFRAMES_CONTAINER_RELATIVETO = "RelativeTo";
MOBILEFRAMES_CONTAINER_RELATIVEPOINT = "RelativePoint";
MOBILEFRAMES_CONTAINER_POSITION = "Position";

MobileFrames_ContainerPointSettings = {
	[MOBILEFRAMES_CONTAINER_POINT] = "TOPLEFT",
	[MOBILEFRAMES_CONTAINER_RELATIVETO] = "UIParent",
	[MOBILEFRAMES_CONTAINER_RELATIVEPOINT] = "BOTTOMLEFT",
	--[MOBILEFRAMES_CONTAINER_POSITION] = nil
};

MobileFrames_ContainerIDByFrame = { };
MobileFrames_SpecialFrames = { };

function MobileFrames_DefineSpecialFrames()
	MobileFrames_SpecialFrames = {

		PlayerFrame = { cosmos = "COS_MOBILE_FRAMES_PLAYERFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePlayerFrame, reset = MobileFrames_ResetMobilePlayerFrame, var = "MobileFrames_MobilePlayerFrame" },
		TargetFrame = { cosmos = "COS_MOBILE_FRAMES_TARGETFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileTargetFrame, reset = MobileFrames_ResetMobileTargetFrame, var = "MobileFrames_MobileTargetFrame" },
		PartyMemberFrames = { cosmos = "COS_MOBILE_FRAMES_PARTYMEMBERFRAMES", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePartyMemberFrames, reset = MobileFrames_ResetMobilePartyMemberFrames, var = "MobileFrames_MobilePartyMemberFrames" },
		Containers = { cosmos = "COS_MOBILE_FRAMES_CONTAINERS", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileContainers, reset = MobileFrames_ResetMobileContainers, var = "MobileFrames_MobileContainers" },
	
	};
end


function MobileFrames_OnLoad()
	
	SlashCmdList["MOBILEFRAMESLIST"] = MobileFrames_List;
    SLASH_MOBILEFRAMESLIST1 = "/mflist";
	
	SlashCmdList["MOBILEFRAMESENABLE"] = MobileFrames_Enable;
    SLASH_MOBILEFRAMESENABLE1 = "/mfenable";
	
	SlashCmdList["MOBILEFRAMESDISABLE"] = MobileFrames_Disable;
    SLASH_MOBILEFRAMESDISABLE1 = "/mfdisable";
	
	SlashCmdList["MOBILEFRAMESRESET"] = MobileFrames_Reset;
    SLASH_MOBILEFRAMESRESET1 = "/mfreset";
	
	SlashCmdList["MOBILETOGGLEANCHORS"] = MobileFrames_ToggleUnitAnchors;
	SLASH_MOBILETOGGLEANCHORS1 = "/mfanchors";
	
	SlashCmdList["MOBILETOGGLESOUND"] = MobileFrames_ToggleSound;
	SLASH_MOBILETOGGLESOUND1 = "/mfsound";
	
	--manual hook for returning
	if (CloseWindows ~= SavedCloseWindows) then
        SavedCloseWindows = CloseWindows;
        CloseWindows = MobileFrames_CloseWindows;
    end
	
	Sea.util.hook( "ShowUIPanel", "MobileFrames_ShowUIPanel", "replace" );
	Sea.util.hook( "ContainerFrame_GenerateFrame", "MobileFrames_ContainerFrame_GenerateFrame", "after" );
	Sea.util.hook( "updateContainerFrameAnchors", "MobileFrames_updateContainerFrameAnchors", "replace" );
	
	MobileFrames_DefineSpecialFrames();
	
	--Cosmos Master Hack to stop checkbox syncing on okay.
	CosmosMaster_Save = MobileFrames_CosmosMaster_Save;
	

end


function MobileFrames_BarOnLoad(barFrame)
	MobileFrames_AddFrameRepositionIgnore(barFrame:GetParent():GetName());
	
	--enable by default
	MobileFrames_MasterEnableList[barFrame:GetParent():GetName()] = MobileFrames_EnabledByDefault;
	
	--set to parent width
	barFrame:SetWidth(barFrame:GetParent():GetWidth());

	--subtract HitRectInsets/AbsInset/right value of parent stored in bar id
	--only needed since there's no GetRightHitRectInset()
	local widthOffeset = barFrame:GetID();
	if ( widthOffeset ) then
		barFrame:SetWidth(barFrame:GetWidth()-widthOffeset);
	end
	
	--[[
	--subtract close button width
	local parentCloseButton = getglobal(barFrame:GetParent():GetName().."CloseButton");
	if parentCloseButton then
		barFrame:SetWidth(barFrame:GetWidth()-parentCloseButton:GetWidth());
	end
	]]--
end

function MobileFrames_BarOnShow(barFrame)
	if not MobileFrames_MasterEnableList[barFrame:GetParent():GetName()] then
		barFrame:SetWidth(0);
	else
		MobileFrames_AddToVisibleList(barFrame:GetParent():GetName());
	end
end

function MobileFrames_BarStopDrag(barFrame)
	if ( barFrame:GetParent().isMoving ) then
		barFrame:GetParent():StopMovingOrSizing();
		barFrame:GetParent().isMoving = false;
	end
end

function MobileFrames_BarStartDrag(barFrame)
	if ( ( ( not barFrame:GetParent().isLocked ) or ( barFrame:GetParent().isLocked == 0 ) ) and ( arg1 == "LeftButton" ) ) then
		barFrame:GetParent():StartMoving();
		barFrame:GetParent().isMoving = true;
	end
end

function MobileFrames_BarOnDragStart(barFrame)
	if this:GetParent().isMoving then
		this:GetParent():StopMovingOrSizing();
		this:GetParent().isMoving = false;
	end
	MobileFrames_RemoveFromVisibleList(this:GetParent():GetName());
end


function MobileFrames_OnEvent(event)
	if event == "VARIABLES_LOADED" then
		--define enable/disable functions for all loaded frames
		table.foreach(MobileFrames_MasterEnableList, function(frameName) MobileFrames_EnableToggle[frameName] = function(checked) MobileFrames_EnableToggleGeneral(frameName, checked); end; end);
		--define reset functions for all loaded frames
		table.foreach(MobileFrames_MasterEnableList, function(frameName) MobileFrames_ResetFrame[frameName] = function() MobileFrames_Reset(frameName); end; end);
		
		if (not MobileFrames_ContainerPositionsByID) then
			MobileFrames_ContainerPositionsByID = {};
		end
		
		if (COS_MOBILE_FRAMES_CONTAINERS_X) then
			MobileFrames_MobileContainers = (COS_MOBILE_FRAMES_CONTAINERS_X == 1);
		else
			if (MobileFrames_MobileContainers == nil) then
				MobileFrames_MobileContainers = MobileFrames_EnabledByDefault;
			end
		end
		
		if (MobileFrames_SavedEnableList) then
			--use saved enable states
			for frameName, enabled in MobileFrames_SavedEnableList do
				if MobileFrames_MasterEnableList[frameName] ~= nil then
					--mobile frame was loaded and has a saved value, use it
					MobileFrames_MasterEnableList[frameName] = enabled;
				end
			end
		end
		
		--this and the previous if arn't mutually exclusive (Ex: had MFs and just added cosmos)
		if (Cosmos_RegisterConfiguration) then
			--register Mobile Frames with cosmos config
			Cosmos_RegisterConfiguration("COS_MOBILE_FRAMES_HEADER",
				"SECTION",
				MOBILE_FRAMES_HEADER,
				MOBILE_FRAMES_HEADER_INFO
			);
			Cosmos_RegisterConfiguration("COS_MOBILE_FRAMES_HEADER_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_HEADER,
				MOBILE_FRAMES_HEADER_INFO
			);
			
			--enable all button
			Cosmos_RegisterConfiguration("COS_MOBILE_FRAMES_ENABLE_ALL",	-- registered name
				"BUTTON",													-- register type
				MOBILE_FRAMES_ENABLE_ALL_TEXT,								-- short description
				MOBILE_FRAMES_ENABLE_ALL_TEXT_INFO,							-- long description
				MobileFrames_Enable,											-- function
				0,						-- useless
				0,						-- useless
				0,						-- useless
				0,						-- useless
				TEXT(ENABLE_ALL)		-- button text
			);
			
			--disable all button
			Cosmos_RegisterConfiguration("COS_MOBILE_FRAMES_DISABLE_ALL",   -- registered name
				"BUTTON",													-- register type
				MOBILE_FRAMES_DISABLE_ALL_TEXT,								-- short description
				MOBILE_FRAMES_DISABLE_ALL_TEXT_INFO,						-- long description
				MobileFrames_Disable,										-- function
				0,						-- useless
				0,						-- useless
				0,						-- useless
				0,						-- useless
				TEXT(DISABLE_ALL)		-- button text
			);
			
			--reset all button
			Cosmos_RegisterConfiguration("COS_MOBILE_FRAMES_RESET_ALL",		-- registered name
				"BUTTON",													-- register type
				MOBILE_FRAMES_RESET_ALL_TEXT,								-- short description
				MOBILE_FRAMES_RESET_ALL_TEXT_INFO,							-- long description
				MobileFrames_Reset,											-- function
				0,						-- useless
				0,						-- useless
				0,						-- useless
				0,						-- useless
				TEXT(RESET_ALL)			-- button text
			);
			
			
			--register each frame with cosmos config
			for frameName, enabled in MobileFrames_MasterEnableList do
				local cosmosCheckboxName = "COS_MOBILE_FRAMES_ENABLE_"..string.upper(frameName);
				local cosmosCheckedStatus = getglobal(cosmosCheckboxName.."_X");
				if cosmosCheckedStatus ~= nil then
					--if saved value by cosmos, use it
					MobileFrames_MasterEnableList[frameName] = (cosmosVariable == 1);
				end
				
				frameReadable  = GetReadableFrameName(frameName);
				
				--register this frame with cosmos config
				--enable checkbox
				Cosmos_RegisterConfiguration(cosmosCheckboxName,		-- registered name
					"CHECKBOX",											-- register type
					format(MOBILE_FRAMES_ENABLE_TEXT, frameReadable),		-- short description
					format(MOBILE_FRAMES_ENABLE_TEXT_INFO, frameReadable),  -- long description
					MobileFrames_EnableToggle[frameName],				-- function
					MobileFrames_MasterEnableList[frameName]			-- default value
				);
				
				local cosmosResetButtonName = "COS_MOBILE_FRAMES_RESET_"..string.upper(frameName);
				--reset button
				Cosmos_RegisterConfiguration(cosmosResetButtonName,		-- registered name
					"BUTTON",											-- register type
					format(MOBILE_FRAMES_RESET_TEXT, frameReadable),		-- short description
					format(MOBILE_FRAMES_RESET_TEXT_INFO, frameReadable),   -- long description
					MobileFrames_ResetFrame[frameName],					-- function
					0,						-- useless
					0,						-- useless
					0,						-- useless
					0,						-- useless
					TEXT(RESET_TO_DEFAULT)  -- button text
				);
				
			end
			
			Cosmos_RegisterConfiguration("COS_MOBILE_FRAMES_SPECIAL_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_SPECIAL_HEADER,
				MOBILE_FRAMES_SPECIAL_HEADER_INFO
			);
			
			for varPrefix, data in MobileFrames_SpecialFrames do
			
				frameReadable  = GetReadableFrameName(varPrefix);
				--frameCaps = string.upper(varPrefix);
				
				if (varPrefix == "Containers") then
					--enable checkbox
					Cosmos_RegisterConfiguration(
						data.cosmos,					--CVar
						"CHECKBOX",						--Things to use
						format(MOBILE_FRAMES_ENABLE_TEXT, frameReadable),
						format(MOBILE_FRAMES_ENABLE_TEXT_INFO, frameReadable),
						data.func,						--Callback
						data.default					--Default Checked/Unchecked
					);
				end
				
				--reset button
				Cosmos_RegisterConfiguration(data.cosmos.."_RESET",		-- registered name
					"BUTTON",											-- register type
					format(MOBILE_FRAMES_RESET_TEXT, frameReadable),		-- short description
					format(MOBILE_FRAMES_RESET_TEXT_INFO, frameReadable),   -- long description
					data.reset,				-- function
					0,						-- useless
					0,						-- useless
					0,						-- useless
					0,						-- useless
					TEXT(RESET_TO_DEFAULT)  -- button text
				);
				
			end
			
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_SPECIAL_OPTIONS_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_SPECIAL_OPTIONS_HEADER,
				MOBILE_FRAMES_SPECIAL_OPTIONS_HEADER_INFO
			);
			
			--Toggle Anchor button
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_TOGGLEANCHORS_RESET",	-- CVar
				"BUTTON",								-- register type
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS),		-- short description
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS_INFO), -- long description
				MobileFrames_ToggleUnitAnchors,			-- function
				0,						-- useless
				0,						-- useless
				0,						-- useless
				0,						-- useless
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS)  -- button text
			);
			
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_ENABLE_SOUND",   --CVar
				"CHECKBOX",							--Things to use
				TEXT(MOBILE_FRAMES_ENABLE_SOUND),
				TEXT(MOBILE_FRAMES_ENABLE_SOUND_INFO),
				MobileFrames_EnableAnchorSound,		--Callback
				1									--Default Checked/Unchecked
			);
			
		else
			--save enabled values if not using cosmos
			MobileFrames_SavedEnableList = MobileFrames_MasterEnableList;
			RegisterForSave("MobileFrames_SavedEnableList");
		end
		
	end
end


function MobileFrames_EnableToggleGeneral(frameName, checked)
	if checked == nil then
		MobileFrames_MasterEnableList[frameName] = (not MobileFrames_MasterEnableList[frameName]);
	else
		MobileFrames_MasterEnableList[frameName] = (checked == 1);
	end
	if getglobal(frameName):IsVisible() then
		getglobal(frameName):Hide();
	end
	if not MobileFrames_MasterEnableList[frameName] then
		MobileFrames_RemoveFrameRepositionIgnore(frameName);
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameName));
		end
	else
		MobileFrames_AddFrameRepositionIgnore(frameName);
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameName));
		end
	end
	if checked == nil then
		ShowUIPanel(getglobal(frameName));
	end
end


function MobileFrames_AddFrameRepositionIgnore(frameName)
	if not MobileFrames_UIPanelWindowBackup[frameName] then
		--Sea.IO.print("Ignoring Reposition of "..frameName.." ("..UIPanelWindows[frameName].pushable..")")
		MobileFrames_UIPanelWindowBackup[frameName] = UIPanelWindows[frameName];
	end
	UIPanelWindows[frameName] = nil;
end


function MobileFrames_RemoveFrameRepositionIgnore(frameName)
	if MobileFrames_UIPanelWindowBackup[frameName] then
		UIPanelWindows[frameName] = MobileFrames_UIPanelWindowBackup[frameName];
		--Sea.IO.print("Allowing Reposition of "..frameName.." ("..UIPanelWindows[frameName].pushable..")")
	end
	MobileFrames_UIPanelWindowBackup[frameName] = nil;
end

function MobileFrames_CloseWindows(ignoreCenter)
	local found;
	for index, value in MobileFrames_UIPanelWindowBackup do
		if getglobal(index):IsVisible() then
			getglobal(index):Hide();
			found = 1;
		end
	end
	
	--if reseting sets to center make sure left isn't left defined but hidden
	local leftFrame = GetLeftFrame();
	if leftFrame then
		if not leftFrame:IsVisible() then
			SetLeftFrame(nil);
		end
	end
	
	local closed = SavedCloseWindows(ignoreCenter);
	return closed or found;
end


function MobileFrames_List()
	
	Sea.IO.print("**List of Movable UI Panels**");
	
	local frameReadable  = GetReadableFrameName("Containers");
	if (frameReadable) then
		Sea.IO.print("Containers".." = "..frameReadable);
	else
		Sea.IO.print("Containers");
	end
	for index, value in MobileFrames_UIPanelWindowBackup do
		frameReadable  = GetReadableFrameName(index);
		if (frameReadable) then
			Sea.IO.print(index.." = "..frameReadable);
		else
			Sea.IO.print(index);
		end
	end
end


function MobileFrames_ListVisible()

	Sea.IO.print("**List of Visible UI Panels**");
	local frameReadable = "";
	for index, value in MobileFrames_UIPanelsVisible do
		frameReadable  = GetReadableFrameName(index);
		Sea.IO.print(frameReadable.." ("..value..")");
	end
end


function MobileFrames_Enable(msg)
	-- Raise it to upper case for comparison purposes.
	local frameName = string.upper(msg)
	local found;
	local enableAll;
	local redrawCosmos;
	local frameReadable = "";
	if (msg == "") or (not msg) or (msg == 0) then
		enableAll = true;
	end
	
	for varPrefix, data in MobileFrames_SpecialFrames do
		if (varPrefix == "Containers") then
			if (enableAll) or (frameName == string.upper(varPrefix)) then
				data.func(1);
				if (Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue(data.cosmos, CSM_CHECKONOFF, 1);
					redrawCosmos = true;
				end
				if (not enableAll) then
					frameReadable  = GetReadableFrameName(msg);
					Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameReadable));
				end
			end
		end
	end
	
	for index, value in MobileFrames_MasterEnableList do
		if string.upper(index) == frameName or enableAll then
			found = 1;
			MobileFrames_EnableToggle[index](1);
			if (Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_MOBILE_FRAMES_ENABLE_"..string.upper(index), CSM_CHECKONOFF, 1);
				redrawCosmos = true;
			end
			if not enableAll then
				frameReadable  = GetReadableFrameName(index);
				Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameReadable));
				ShowUIPanel(getglobal(index));
				break;
			end
		end
	end
	if (Cosmos_RegisterConfiguration) then
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) and redrawCosmos then
			CosmosMaster_DrawData();
		end
	end
	if enableAll then
		Sea.IO.print(MOBILE_FRAMES_ENABLED_ALL_TEXT);
	end
end


function MobileFrames_Disable(msg)
	-- Raise it to upper case for comparison purposes.
	local frameName = string.upper(msg)
	local found;
	local disableAll;
	local redrawCosmos;
	local frameReadable = "";
	if (msg == "") or (not msg) or (msg == 0) then
		disableAll = true;
	end
	
	for varPrefix, data in MobileFrames_SpecialFrames do
		if (varPrefix == "Containers") then
			if (disableAll) or (frameName == string.upper(varPrefix)) then
				data.func(0);
				if (Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue(data.cosmos, CSM_CHECKONOFF, 0);
					redrawCosmos = true;
				end
				if (not disableAll) then
					frameReadable  = GetReadableFrameName(msg);
					Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameReadable));
				end
			end
		end
	end
	
	
	
	for index, value in MobileFrames_MasterEnableList do
		if string.upper(index) == frameName or disableAll then
			found = 1;
			MobileFrames_EnableToggle[index](0);
			if (Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_MOBILE_FRAMES_ENABLE_"..string.upper(index), CSM_CHECKONOFF, 0);
				redrawCosmos = true;
			end
			if not disableAll then
				frameReadable  = GetReadableFrameName(index);
				Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameReadable));
				ShowUIPanel(getglobal(index));
				break;
			end
		end
	end
	if (Cosmos_RegisterConfiguration) then
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) and redrawCosmos then
			CosmosMaster_DrawData();
		end
	end
	if disableAll then
		Sea.IO.print(MOBILE_FRAMES_DISABLED_ALL_TEXT);
	end
end


function MobileFrames_Reset(msg)
	-- Raise it to upper case for comparison purposes.
	local frameName = string.upper(msg)
	local found;
	local resetAll;
	local frameReadable  = "";
	if (msg == "") or (not msg) or (msg == 0) then
		resetAll = true;
	end
	if CosmosMasterFrame then
		if not CosmosMasterFrame:IsVisible() then
			CloseWindows();
		end
	end
	
	for varPrefix, data in MobileFrames_SpecialFrames do
		if (resetAll) or (frameName == string.upper(varPrefix)) then
			data.reset();
			if (not resetAll) then
				frameReadable  = GetReadableFrameName(msg);
				Sea.IO.print(format(MOBILE_FRAMES_RESET, frameReadable));
			end
		end
	end
	
	for index, value in MobileFrames_UIPanelWindowBackup do
		if string.upper(index) == frameName or resetAll then
			found = 1;
			MobileFrames_RemoveFrameRepositionIgnore(index);
			if getglobal(index):IsVisible() then
				getglobal(index):Hide();
			end
			if not resetAll then 
				ShowUIPanel(getglobal(index));
				frameReadable  = GetReadableFrameName(msg);
				Sea.IO.print(format(MOBILE_FRAMES_RESET, frameReadable));
				break;
			end
		end
	end
	if found and resetAll then
		Sea.IO.print(MOBILE_FRAMES_RESET_ALL);
	elseif not found then
		-- If it's not found, it's unrecognized.  Tell the user.
		-- disabled due to confusing call on multiple reset
		-- Sea.IO.print(MOBILE_FRAMES_ERROR);
	end
end

function MobileFrames_ToggleSound()

	MobileFrames_EnableAnchorSound();
	
	if (Cosmos_RegisterConfiguration) then
		local onOff;
		if (MobileFrames_AnchorsSoundOn) then
			onOff = 1;
		else
			onOff = 0;
		end
		Cosmos_UpdateValue("COS_MOBILE_FRAMES_ENABLE_SOUND", CSM_CHECKONOFF, onOff);
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
			CosmosMaster_DrawData();
		end
	end

end



function MobileFrames_ShowUIPanel(frame, force)
	if ( not frame or frame:IsVisible() ) then
		return false;
	end
	-- if Mobile frame
	if MobileFrames_UIPanelWindowBackup[frame:GetName()] then
		-- if not pushable
		if MobileFrames_UIPanelWindowBackup[frame:GetName()].pushable == 0 then
			-- hide visible, non-pushable, mobile frames
			for frameName, value in MobileFrames_UIPanelsVisible do
				if MobileFrames_UIPanelWindowBackup[frameName].pushable == 0 then
					getglobal(frameName):Hide();
				end
			end
			-- hide visible, non-pushable, left, standard UI Panel
			-- preserve any center frame
			local leftName = GetLeftFrame();
			if leftName then
				if UIPanelWindows[leftName:GetName()] then
					if UIPanelWindows[leftName:GetName()].pushable == 0 then
						if GetCenterFrame() then
							MovePanelToLeft();
						else
							SetLeftFrame(nil);
						end
					end
				end
			end
		end
	end
	return true;
end


function MobileFrames_AddToVisibleList(frameName)
	if not MobileFrames_UIPanelsVisible[frameName] then
		if not MobileFrames_UIPanelWindowBackup[frameName] then
			--recently reset
			local left = GetLeftFrame();
			local center = GetCenterFrame();
			local doublewide = GetDoublewideFrame();
			if (left) then
				if left:GetName() == frameName then
					SetLeftFrame(nil);
				end
			end
			if (center) then
				if center:GetName() == frameName then
					SetCenterFrame(nil);
				end
			end
			if (doublewide) then
				if doublewide:GetName() == frameName then
					SetDoublewideFrame(nil);
				end
			end
			MobileFrames_AddFrameRepositionIgnore(frameName);
		end
		if MobileFrames_UIPanelWindowBackup[frameName] then
			MobileFrames_UIPanelsVisible[frameName] = MobileFrames_UIPanelWindowBackup[frameName].pushable;
		end
	end
end


function MobileFrames_RemoveFromVisibleList(frameName)
	MobileFrames_UIPanelsVisible[frameName] = nil;
end


--Cosmos Master Hack to stop checkbox syncing on okay.
function MobileFrames_CosmosMaster_Save()
	CosmosMaster_StoreVariables();
	RegisterForSave('CosmosMaster_CVars');
end

function GetReadableFrameName(frameName)
	--makes the frame name readble and localizable
	local frameReadable  = MOBILE_FRAMES_FRAMEDESCRIPTIONS[frameName];
	if (not frameReadable) then
		frameReadable = frameName;
	end
	return frameReadable;
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Container Frames
-- <= == == == == == == == == == == == == =>

function MobileFrames_updateContainerFrameAnchors()
	--DELETED! MUAH HA HA!
	if (not MobileFrames_MobileContainers) then
		return true;
	end
end

function MobileFrames_MarkContainerCoords(frame)
	local x = frame:GetLeft(); 
	local y = frame:GetTop(); 
	local coords = { x, y }; 
	if (MobileFrames_ContainerIDByFrame[frame:GetName()]) then
		MobileFrames_ContainerPositionsByID[MobileFrames_ContainerIDByFrame[frame:GetName()]] = coords;
	end
end

function MobileFrames_ContainerFrame_GenerateFrame(frame, size, id)
	if (MobileFrames_MobileContainers) then
		local reset = true;
		
		--reposition the sucker!
		if (MobileFrames_ContainerPositionsByID[id]) then
			local x = MobileFrames_ContainerPositionsByID[id][1];
			local y = MobileFrames_ContainerPositionsByID[id][2];
			if (x and y) then
				frame:ClearAllPoints();
				frame:SetPoint(MobileFrames_ContainerPointSettings[MOBILEFRAMES_CONTAINER_POINT], MobileFrames_ContainerPointSettings[MOBILEFRAMES_CONTAINER_RELATIVETO], MobileFrames_ContainerPointSettings[MOBILEFRAMES_CONTAINER_RELATIVEPOINT], x, y );
				reset = false;
			end
		end
		
		if (reset) then
			frame:ClearAllPoints();
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", 0, CONTAINER_OFFSET);
		end
		
		MobileFrames_ContainerIDByFrame[frame:GetName()] = id;
	end
end

function MobileFrames_ContainerBarOnShow(barFrame)
	if (not MobileFrames_MobileContainers) then
		barFrame:SetWidth(0);
	elseif (barFrame:GetWidth() == 0) then
		barFrame:SetWidth(barFrame:GetParent():GetWidth());
	end
end

function MobileFrames_ContainerBarOnLoad(barFrame)
	--set to parent width
	barFrame:SetWidth(barFrame:GetParent():GetWidth());

	--subtract HitRectInsets/AbsInset/right value of parent stored in bar id
	--only needed since there's no GetRightHitRectInset()
	local widthOffeset = barFrame:GetID();
	if ( widthOffeset ) then
		barFrame:SetWidth(barFrame:GetWidth()-widthOffeset);
	end
end

function MobileFrames_EnableMobileContainers(checked) 
	if checked == nil then
		MobileFrames_MobileContainers = (not MobileFrames_MobileContainers);
	else
		MobileFrames_MobileContainers = (checked == 1);
	end
	for i=1, 17 do
		getglobal("ContainerFrame"..i):ClearAllPoints();
		if getglobal("ContainerFrame"..i):IsVisible() then
			getglobal("ContainerFrame"..i):Hide();
		end
	end
end

function MobileFrames_ResetMobileContainers()
	MobileFrames_ContainerPositionsByID = {};
	for i=1, 17 do
		if getglobal("ContainerFrame"..i):IsVisible() then
			getglobal("ContainerFrame"..i):Hide();
		end
	end
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Unit Frames
-- <= == == == == == == == == == == == == =>


function MobileFrames_EnableMobilePartyMemberFrames(checked) 
	if checked == nil then
		MobileFrames_MobilePartyMemberFrames = (not MobileFrames_MobilePartyMemberFrames);
	else
		MobileFrames_MobilePartyMemberFrames = (checked == 1);
	end
end

function MobileFrames_ResetMobilePartyMemberFrames()
	local wasMoving = false;
	for i=1, 4 do
		if ( getglobal("PartyMemberFrame"..i).isMoving ) then
			getglobal("PartyMemberFrame"..i):StopMovingOrSizing();
			getglobal("PartyMemberFrame"..i).isMoving = false;
			wasMoving = true;
		end
	end
	if (not wasMoving) then
		PartyMemberFrame1:ClearAllPoints();
		PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 10, -128);
		PartyMemberFrame2:ClearAllPoints();
		PartyMemberFrame2:SetPoint("TOPLEFT", "PartyMemberFrame1", "BOTTOMLEFT", 0, -10);
		PartyMemberFrame3:ClearAllPoints();
		PartyMemberFrame3:SetPoint("TOPLEFT", "PartyMemberFrame2", "BOTTOMLEFT", 0, -10);
		PartyMemberFrame4:ClearAllPoints();
		PartyMemberFrame4:SetPoint("TOPLEFT", "PartyMemberFrame3", "BOTTOMLEFT", 0, -10);
	end
end


function MobileFrames_EnableMobilePlayerFrame(checked) 
	if checked == nil then
		MobileFrames_MobilePlayerFrame = (not MobileFrames_MobilePlayerFrame);
	else
		MobileFrames_MobilePlayerFrame = (checked == 1);
	end
end

function MobileFrames_ResetMobilePlayerFrame()
	if ( PlayerFrame.isMoving ) then
		PlayerFrame:StopMovingOrSizing();
		PlayerFrame.isMoving = false;
	else
		PlayerFrame:ClearAllPoints();
		PlayerFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", -19, -4);
	end
end

function MobileFrames_EnableMobileTargetFrame(checked) 
	if checked == nil then
		MobileFrames_MobileTargetFrame = (not MobileFrames_MobileTargetFrame);
	else
		MobileFrames_MobileTargetFrame = (checked == 1);
	end
end

function MobileFrames_ResetMobileTargetFrame()
	if ( TargetFrame.isMoving ) then
		TargetFrame:StopMovingOrSizing();
		TargetFrame.isMoving = false;
	else
		TargetFrame:ClearAllPoints();
		TargetFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 250, -4);
	end
end

function MobileFrames_EnableMobilePetFrame(checked) 
	if checked == nil then
		MobileFrames_MobilePetFrame = (not MobileFrames_MobilePetFrame);
	else
		MobileFrames_MobilePetFrame = (checked == 1);
	end
end

function MobileFrames_ResetMobileTargetFrame()
	if ( PetFrame.isMoving ) then
		PetFrame:StopMovingOrSizing();
		PetFrame.isMoving = false;
	else
		PetFrame:ClearAllPoints();
		PetFrame:SetPoint("TOPLEFT", "PlayerFrame", "TOPLEFT", 80, -60);
	end
end

function MobileFrames_EnableAnchorSound(checked)
	if checked == nil then
		MobileFrames_AnchorsSoundOn = (not MobileFrames_AnchorsSoundOn);
	else
		MobileFrames_AnchorsSoundOn = (checked == 1);
	end
end

function MobileFrames_ToggleUnitAnchors()
	if (MobileFrames_AnchorsUp) then
		MobileFrames_AnchorsUp = false;
		TargetFrameMobileButton:Hide();
		PlayerFrameMobileButton:Hide();
		--PetFrameMobileButton:Hide();
		PartyMemberFrame1MobileButton:Hide();
		PartyMemberFrame2MobileButton:Hide();
		PartyMemberFrame3MobileButton:Hide();
		PartyMemberFrame4MobileButton:Hide();
	else
		MobileFrames_AnchorsUp = true;
		TargetFrameMobileButton:Show();
		PlayerFrameMobileButton:Show();
		--PetFrameMobileButton:Show();
		PartyMemberFrame1MobileButton:Show();
		PartyMemberFrame2MobileButton:Show();
		PartyMemberFrame3MobileButton:Show();
		PartyMemberFrame4MobileButton:Show();
	end
end

--[[
Earth Right-Click Reset Notes
if ( EarthMenu_MenuOpen ) then  
	local info =  {};
	info[1] = { text = TEXT(RESET_TO_DEFAULT); func = function () ResetFunction(this:GetName()); end };
	EarthMenu_MenuOpen(info, this:GetName(), 0, 0, "MENU");
end
]]--
