--------------------------------------------------------------------------
-- MobileFrames.lua 
--------------------------------------------------------------------------
--[[
Mobile Frames

By: AnduinLothar    <KarlKFI@ultimateuiui.org>

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
	"/mfoffset [regular/containers] [#]" - sets the offset for regular windows and bags
	 from the left and right respectively. Good for avoiding sidebars.

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
	BottomMultiBars
	SideMultiBars
	MinimapCluster
	AuctionFrame
	TalentFrame
	PetFrame
	MailFrame
	OpenMailFrame
	QuestWatchFrame
	FramerateLabel
	
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
		-Addded a bunch of UltimateUI Options as well as new slash commands. Reset, enable or
		disable all or individually.
	v1.3 (2/20/05)
		-Fixed Massive frame lag issues/bugs when you moved some frames on top of eachother.
		-Cleaned up some XML code.
	v1.4 (2/21/05)
		-Added more readable and localizable frame names in the ultimateui config.
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
	v1.61 (3/11/05)
		-Added German Localization.
	v1.7 (3/23/05)
		-TOC updated to 1300.
		-Added "Toggle Anchors" button to the ultimateui button page.
		-Made new blizzard MultiBars and MinimapCluster mobile using anchors
		-Made Mobile: MultiBarBottomLeft, MultiBarBottomRight, MultiBarLeft, MultiBarRight, 
		MinimapCluster, AuctionFrame, TalentFrame, PetFrame, MailFrame, OpenMailFrame
		-(Known Issues: Mailbox sometimes doesn't update for a time after reset.)
		-(Pet and Shapeshift bar automaticly reposition when you toggle anchors if you have moved the MultiBarBottomLeft much.)
	v1.8 (3/25/05)
		-Major Bag overhaul. Now reset/unmoved bags act like normal until you click on the bar to drag them. No more default overlap.
		-Fixes CONTAINER_OFFSET bug that caused bags to be unopenable.
		-French Localization Upgrade.
	v1.81 (3/26/05)
		-Fixed bags so that they aren't draggable when disabled.
	v1.82
		-Added PopNUI and TransNUI Override toggling when anchors are visible.
	v1.83
		-Made Mobile: QuestWatchFrame
	v1.9
		-Added Container and Regular Frame Side offset sliders so that you can adjust them not to overlap the Side Multibars.
	v1.91
		-Fixed Container Offset to work with PopNUI
		-Stopped some exsessive Offset Flashing.
	v1.92
		-Made Mobile: FramerateLabel
	v1.93
		-Fixed Bug where UltimateUI Variables wouldn't save using slash commands
	v2.0
		-Made Mobile: Minimap Buttons (zoomin, zoomout, mail, tracking, meetingstone)
		[Shift-Drag to move around the Minimap. Shift-Rightclick to reset.]
	v2.1
		-Made Mobile: DurabilityFrame, TicketStatusFrame
		-Updated Mobile MiniMap Button code. You can now hook MobileFrames_MobileMinimapButton_OnClick to cast spells and the mouseover/click graphics work.
	
	$Id: MobileFrames.lua 1426 2005-05-02 21:50:25Z karlkfi $
	$Rev: 1426 $
	$LastChangedBy: karlkfi $
	$Date: 2005-05-02 16:50:25 -0500 (Mon, 02 May 2005) $


]]--

MobileFrames_AnchorsSoundOn = true;

MobileFrames_UIPanelWindowBackup = {};
MobileFrames_UIPanelsVisible = {};
MobileFrames_RightSide_IsReset = {};
MobileFrames_MasterEnableList = {};
MobileFrames_MasterAnchorEnableList = {};
MobileFrames_MinimapButtonCoords = {};
MobileFrames_MinimapButtonDefaultCoords = {};
MobileFrames_ResetFrame = {};			--reset a mobile frame using MobileFrames_ResetFrame[frameName]() used for ultimateui config
MobileFrames_EnableToggle = {};			--enable/disable a mobile frame using MobileFrames_EnableToggle[frameName](1/0) used for ultimateui config
MobileFrames_EnabledByDefault = true;   --true or false, never use nil
local SavedCloseWindows = nil;
UIPANEL_OFFSET_LEFT = 0;

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

MobileFrames_SpecialFrames = { };

function MobileFrames_DefineSpecialFrames()
	MobileFrames_SpecialFrames = {

		PlayerFrame = { ultimateui = "UUI_MOBILE_FRAMES_PLAYERFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePlayerFrame, reset = MobileFrames_ResetMobilePlayerFrame },
		PetFrame = { ultimateui = "UUI_MOBILE_FRAMES_PETFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePetFrame, reset = MobileFrames_ResetMobilePetFrame },
		TargetFrame = { ultimateui = "UUI_MOBILE_FRAMES_TARGETFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileTargetFrame, reset = MobileFrames_ResetMobileTargetFrame },
		PartyMemberFrames = { ultimateui = "UUI_MOBILE_FRAMES_PARTYMEMBERFRAMES", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePartyMemberFrames, reset = MobileFrames_ResetMobilePartyMemberFrames},
		Containers = { ultimateui = "UUI_MOBILE_FRAMES_CONTAINERS", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileContainers, reset = MobileFrames_ResetMobileContainers},
		BottomMultiBars = { ultimateui = "UUI_MOBILE_FRAMES_BOTTOMMULTIBARS", reset = MobileFrames_ResetMobileBottomMultiBars, default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileBottomMultiBars },
		SideMultiBars = { ultimateui = "UUI_MOBILE_FRAMES_SIDEMULTIBARS", reset = MobileFrames_ResetMobileSideMultiBars, default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileSideMultiBars },
		MinimapCluster = { ultimateui = "UUI_MOBILE_FRAMES_MINIMAP", reset = MobileFrames_ResetMobileMinimapCluster, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("MinimapCluster", checked) end },
		QuestWatchFrame = { ultimateui = "UUI_MOBILE_FRAMES_QUESTWATCH", reset = function() MobileFrames_UIParent_ManageRightSideFrames(true, nil) end, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("QuestWatchFrame", checked) end },
		FramerateLabel = { ultimateui = "UUI_MOBILE_FRAMES_FRAMERATE", reset = function() MobileFrames_FramerateLabelReset() end, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("FramerateLabel", checked) end },
		DurabilityFrame = { ultimateui = "UUI_MOBILE_FRAMES_DURRABILITY", reset = function() MobileFrames_UIParent_ManageRightSideFrames(nil, true) end, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("DurabilityFrame", checked) end },
		TicketStatusFrame = { ultimateui = "UUI_MOBILE_FRAMES_TICKETSTATUS", reset = MobileFrames_TicketStatus_Reset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("TicketStatusFrame", checked) end },
		
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
	
	SlashCmdList["MOBILETOGGLEANCHORS"] = MobileFrames_ToggleAnchors;
	SLASH_MOBILETOGGLEANCHORS1 = "/mfanchors";
	
	SlashCmdList["MOBILETOGGLESOUND"] = MobileFrames_ToggleSound;
	SLASH_MOBILETOGGLESOUND1 = "/mfsound";
	
	SlashCmdList["MOBILEFRAMESOFFSET"] = MobileFrames_SetOffsets;
	SLASH_MOBILEFRAMESOFFSET1 = "/mfoffset";
	
	--manual hook for returning
	if (CloseWindows ~= SavedCloseWindows) then
        SavedCloseWindows = CloseWindows;
        CloseWindows = MobileFrames_CloseWindows;
    end
	
	Sea.util.hook( "ShowUIPanel", "MobileFrames_ShowUIPanel", "replace" );
	Sea.util.hook( "updateContainerFrameAnchors", "MobileFrames_updateContainerFrameAnchors", "replace" );
	Sea.util.hook( "PetActionBar_UpdatePosition", "MobileFrames_PetActionBar_UpdatePosition", "replace" );
	Sea.util.hook( "ShapeshiftBar_UpdatePosition", "MobileFrames_ShapeshiftBar_UpdatePosition", "replace" );
	Sea.util.hook( "UIParent_ManageRightSideFrames", "MobileFrames_UIParent_ManageRightSideFrames", "replace" );
	Sea.util.hook( "ToggleFramerate", "MobileFrames_ToggleFramerateMobileBar", "after" );
	Sea.util.hook( "Minimap_ZoomInClick", "MobileFrames_Minimap_ZoomInClick", "after" );
	Sea.util.hook( "Minimap_ZoomOutClick", "MobileFrames_Minimap_ZoomOutClick", "after" );
	Sea.util.hook( "Minimap_OnEvent", "MobileFrames_Minimap_OnEvent", "after" );
	
	Sea.util.hook("SetDoublewideFrame", "MobileFrames_SetDoublewideFrame", "replace");
	Sea.util.hook("SetLeftFrame", "MobileFrames_SetLeftFrame", "replace");
	Sea.util.hook("SetCenterFrame", "MobileFrames_SetCenterFrame", "replace");
	Sea.util.hook("MovePanelToLeft", "MobileFrames_MovePanelToLeft", "replace");
	Sea.util.hook("MovePanelToCenter", "MobileFrames_MovePanelToCenter", "replace");
	
	if (PopNUI_UIParent_ManageRightSideFrames) then
		Sea.util.unhook("UIParent_ManageRightSideFrames", "PopNUI_UIParent_ManageRightSideFrames", "after");
	end
	if (UltimateUIMaster_SyncVars) then
		Sea.util.hook("UltimateUIMaster_SyncVars", "MobileFrames_OffsetMarker_Hide", "after");
	end
	
	MobileFrames_DefineSpecialFrames();
	MobileFrames_UIParent_ManageRightSideFrames(true);
	
	--UltimateUI Master Hack to stop checkbox syncing on okay.
	--UltimateUIMaster_Save = MobileFrames_UltimateUIMaster_Save;

end

function BarOptions_AdjustUIPanelFramesLeftOffsetAfterMoving()
	if ( UIParent.left ) then
		local frame = UIParent.left;
	elseif ( UIParent.center ) then
		local frame = UIParent.center;
	end
	if ( frame ) then
		local left = frame:GetLeft() + UIPANEL_OFFSET_LEFT;
		local top = frame:GetTop();
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", left, top);
	end
end

function MobileFrames_BarOnLoad(barFrame)
	MobileFrames_UIPanel_AddFrameRepositionIgnore(barFrame:GetParent():GetName());
	MobileFrames_OverlayOnLoad(barFrame)
	--set to parent width
	barFrame:SetWidth(barFrame:GetParent():GetWidth());
	--subtract HitRectInsets/AbsInset/right value of parent stored in bar id
	--only needed since there's no GetRightHitRectInset()
	local widthOffeset = barFrame:GetID();
	if ( widthOffeset ) then
		barFrame:SetWidth(barFrame:GetWidth()-widthOffeset);
	end
end

function MobileFrames_OverlayOnLoad(barFrame)
	MobileFrames_MakeParentMobile(barFrame);
	MobileFrames_SetEnabledStatus(barFrame:GetParent());
end

function MobileFrames_SetEnabledStatus(frame)
	MobileFrames_MasterEnableList[frame:GetName()] = MobileFrames_EnabledByDefault;
end

function MobileFrames_MakeParentMobile(barFrame)
	if (not barFrame:GetParent():IsMovable()) then
		barFrame:GetParent():SetMovable(1);
	end
end

function MobileFrames_BarOnShow(barFrame)
	if MobileFrames_MasterEnableList[barFrame:GetParent():GetName()] then
		MobileFrames_AddToVisibleList(barFrame:GetParent():GetName());
	end
end

function MobileFrames_BarStopDrag(barFrame)
	MobileFrames_StopDrag(barFrame:GetParent());
end

function MobileFrames_StopDrag(frame)
	if ( frame.isMoving ) then
		frame:StopMovingOrSizing();
		frame.isMoving = false;
	end
end

function MobileFrames_BarStartDrag(barFrame)
	MobileFrames_StartDrag(barFrame:GetParent());
end

function MobileFrames_StartDrag(frame)
	if ( ( ( not frame.isLocked ) or ( frame.isLocked == 0 ) ) and ( arg1 == "LeftButton" ) ) then
		frame:StartMoving();
		frame.isMoving = true;
	end
end

function MobileFrames_BarOnDragStart(barFrame)
	MobileFrames_OnDragStart(barFrame:GetParent())
end

function MobileFrames_OnDragStart(frame)
	if frame.isMoving then
		frame:StopMovingOrSizing();
		frame.isMoving = false;
	end
	MobileFrames_RemoveFromVisibleList(frame:GetName());
end


function MobileFrames_OnEvent(event)
	if event == "VARIABLES_LOADED" then
		--define enable/disable functions for all loaded frames
		table.foreach(MobileFrames_MasterEnableList, function(frameName) MobileFrames_EnableToggle[frameName] = function(checked) MobileFrames_ToggleEnableGeneral(frameName, checked); end; end);
		--define reset functions for all loaded frames
		table.foreach(MobileFrames_MasterEnableList, function(frameName) MobileFrames_ResetFrame[frameName] = function() MobileFrames_Reset(frameName); end; end);
		
		if (not MobileFrames_ContainerPositionsByID) then
			MobileFrames_ContainerPositionsByID = {};
		end
		
		if (UUI_MOBILE_FRAMES_CONTAINERS_X) then
			MobileFrames_MobileContainers = (UUI_MOBILE_FRAMES_CONTAINERS_X == 1);
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
		
		--this and the previous if arn't mutually exclusive (Ex: had MFs and just added ultimateui)
		if (UltimateUI_RegisterConfiguration) then
			--register Mobile Frames with ultimateui config
			UltimateUI_RegisterConfiguration("UUI_MOBILE_FRAMES_HEADER",
				"SECTION",
				MOBILE_FRAMES_HEADER,
				MOBILE_FRAMES_HEADER_INFO
			);
			UltimateUI_RegisterConfiguration("UUI_MOBILE_FRAMES_HEADER_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_HEADER,
				MOBILE_FRAMES_HEADER_INFO
			);
			
			--enable all button
			UltimateUI_RegisterConfiguration("UUI_MOBILE_FRAMES_ENABLE_ALL",	-- registered name
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
			UltimateUI_RegisterConfiguration("UUI_MOBILE_FRAMES_DISABLE_ALL",   -- registered name
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
			UltimateUI_RegisterConfiguration("UUI_MOBILE_FRAMES_RESET_ALL",		-- registered name
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
			
			--Toggle Anchor button
			UltimateUI_RegisterConfiguration(
				"UUI_MOBILE_FRAMES_TOGGLEANCHORS",	-- CVar
				"BUTTON",								-- register type
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS),		-- short description
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS_INFO), -- long description
				MobileFrames_ToggleAnchors,			-- function
				0,						-- useless
				0,						-- useless
				0,						-- useless
				0,						-- useless
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS)  -- button text
			);
			
			UltimateUI_RegisterConfiguration(
				"UUI_MOBILE_FRAMES_ENABLE_SOUND",   --CVar
				"CHECKBOX",							--Things to use
				TEXT(MOBILE_FRAMES_ENABLE_SOUND),
				TEXT(MOBILE_FRAMES_ENABLE_SOUND_INFO),
				MobileFrames_EnableAnchorSound,		--Callback
				1									--Default Checked/Unchecked
			);
			
			UltimateUI_RegisterConfiguration(
				"UUI_MOBILE_FRAMES_SET_CONTAINERS_OFFSET",		-- CVar
				"BOTH",											-- Type
				TEXT(MOBILE_FRAMES_SET_CONTAINERS_OFFSET),		-- Short description
				TEXT(MOBILE_FRAMES_SET_CONTAINERS_OFFSET_INFO),	-- Long description
				MobileFrames_SetContainerOffset,				-- Callback
				0,							-- Default Checked/Unchecked
				CONTAINER_OFFSET_X,			-- Default slider value
				0,							-- Minimum slider value
				200,						-- Maximum slider value
				TEXT(OFFSET),				-- Substring
				5,							-- Slider steps
				1,							-- Text on slider?
				"",							-- Text to append on slider
				1							-- Multiplier for slider value
			);
			
			UltimateUI_RegisterConfiguration(
				"UUI_MOBILE_FRAMES_SET_UIPANEL_OFFSET",			-- CVar
				"BOTH",											-- Type
				TEXT(MOBILE_FRAMES_SET_UIPANEL_OFFSET),			-- Short description
				TEXT(MOBILE_FRAMES_SET_UIPANEL_OFFSET_INFO),	-- Long description
				MobileFrames_SetUIPanelOffsetLeft,				-- Callback
				0,							-- Default Checked/Unchecked
				0,							-- Default slider value
				0,							-- Minimum slider value
				200,						-- Maximum slider value
				TEXT(OFFSET),				-- Substring
				5,							-- Slider steps
				1,							-- Text on slider?
				"",							-- Text to append on slider
				1							-- Multiplier for slider value
			);
			
			UltimateUI_RegisterConfiguration(
				"UUI_MOBILE_FRAMES_REGULAR_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_REGULAR_OPTIONS_HEADER,
				MOBILE_FRAMES_REGULAR_OPTIONS_HEADER_INFO
			);
			
			--register each frame with ultimateui config
			for frameName, enabled in MobileFrames_MasterEnableList do
				if (not MobileFrames_SpecialFrames[frameName]) then
					local ultimateuiCheckboxName = "UUI_MOBILE_FRAMES_ENABLE_"..string.upper(frameName);
					local ultimateuiCheckedStatus = getglobal(ultimateuiCheckboxName.."_X");
					if ultimateuiCheckedStatus ~= nil then
						--if saved value by ultimateui, use it
						MobileFrames_MasterEnableList[frameName] = (ultimateuiVariable == 1);
					end
					
					frameReadable  = GetReadableFrameName(frameName);
					
					--register this frame with ultimateui config
					--enable checkbox
					UltimateUI_RegisterConfiguration(ultimateuiCheckboxName,		-- registered name
						"CHECKBOX",											-- register type
						format(MOBILE_FRAMES_ENABLE_TEXT, frameReadable),		-- short description
						format(MOBILE_FRAMES_ENABLE_TEXT_INFO, frameReadable),  -- long description
						MobileFrames_EnableToggle[frameName],				-- function
						MobileFrames_MasterEnableList[frameName]			-- default value
					);
					
					local ultimateuiResetButtonName = "UUI_MOBILE_FRAMES_RESET_"..string.upper(frameName);
					--reset button
					UltimateUI_RegisterConfiguration(ultimateuiResetButtonName,		-- registered name
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
			end
			
			UltimateUI_RegisterConfiguration("UUI_MOBILE_FRAMES_SPECIAL_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_SPECIAL_HEADER,
				MOBILE_FRAMES_SPECIAL_HEADER_INFO
			);
			
			for varPrefix, data in MobileFrames_SpecialFrames do
			
				frameReadable  = GetReadableFrameName(varPrefix);
				--frameCaps = string.upper(varPrefix);
				
				--register this frame with ultimateui config
				--enable checkbox
				UltimateUI_RegisterConfiguration(data.ultimateui,		-- registered name
					"CHECKBOX",											-- register type
					format(MOBILE_FRAMES_ENABLE_TEXT, frameReadable),		-- short description
					format(MOBILE_FRAMES_ENABLE_TEXT_INFO, frameReadable),  -- long description
					data.func,				-- function
					data.default			-- default value
				);
				
				--reset button
				UltimateUI_RegisterConfiguration(data.ultimateui.."_RESET",		-- registered name
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

		else
			--save enabled values if not using ultimateui
			MobileFrames_SavedEnableList = MobileFrames_MasterEnableList;
			RegisterForSave("MobileFrames_SavedEnableList");
			RegisterForSave("UIPANEL_OFFSET_LEFT");
			RegisterForSave("CONTAINER_OFFSET_X_SET");
		end
		
		if(UltimateUI_RegisterButton) then
			UltimateUI_RegisterButton ( 
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS), 
				"", 
				TEXT(MOBILE_FRAMES_TOGGLEANCHORS_INFO), 
				"Interface\\AddOns\\MobileFrames\\Skin\\Anchor", 
				MobileFrames_ToggleAnchors
			);
		end
		
	end
end


function MobileFrames_ToggleEnableGeneral(frameName, checked)
	if checked == nil then
		MobileFrames_MasterEnableList[frameName] = (not MobileFrames_MasterEnableList[frameName]);
	else
		MobileFrames_MasterEnableList[frameName] = (checked == 1);
	end
	local isSpecialFrame = Sea.table.isInTable(Sea.table.getKeyList(MobileFrames_SpecialFrames), frameName);
	if not MobileFrames_MasterEnableList[frameName] then
		if (not isSpecialFrame) then
			MobileFrames_UIPanel_RemoveFrameRepositionIgnore(frameName);
		end
		getglobal(frameName.."MobileBar"):EnableMouse(0);
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameName));
		end
	else
		if (not isSpecialFrame) then
			MobileFrames_UIPanel_AddFrameRepositionIgnore(frameName);
		end
		getglobal(frameName.."MobileBar"):EnableMouse(1);
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameName));
		end
	end
	if (checked == nil) and (not isSpecialFrame) then
		ShowUIPanel(getglobal(frameName));
	end
end


function MobileFrames_UIPanel_AddFrameRepositionIgnore(frameName)
	if not MobileFrames_UIPanelWindowBackup[frameName] then
		--Sea.IO.print("Ignoring Reposition of "..frameName.." ("..UIPanelWindows[frameName].pushable..")")
		MobileFrames_UIPanelWindowBackup[frameName] = UIPanelWindows[frameName];
	end
	UIPanelWindows[frameName] = nil;
end


function MobileFrames_UIPanel_RemoveFrameRepositionIgnore(frameName)
	if MobileFrames_UIPanelWindowBackup[frameName] then
		UIPanelWindows[frameName] = MobileFrames_UIPanelWindowBackup[frameName];
		--Sea.IO.print("Allowing Reposition of "..frameName.." ("..UIPanelWindows[frameName].pushable..")")
	end
	MobileFrames_UIPanelWindowBackup[frameName] = nil;
end

function MobileFrames_RightSide_AddFrameRepositionIgnore(frameName)
	--Sea.IO.print("Ignoring Reposition of Right Side Frame: "..frameName);
	MobileFrames_RightSide_IsReset[frameName] = true;
end


function MobileFrames_RightSide_RemoveFrameRepositionIgnore(frameName)
	--Sea.IO.print("Allowing Reposition of Right Side Frame: "..frameName);
	MobileFrames_RightSide_IsReset[frameName] = nil;
end

function MobileFrames_RightSide_FrameRepositionIsBeingIgnored(frameName)
	return MobileFrames_RightSide_IsReset[frameName];
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

	for index, value in MobileFrames_SpecialFrames do
		frameReadable  = GetReadableFrameName(index);
		if (frameReadable) then
			Sea.IO.print(index.." = "..frameReadable);
		else
			Sea.IO.print(index);
		end
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
	local redrawUltimateUI;
	local frameReadable = "";
	if (msg == "") or (not msg) or (msg == 0) then
		enableAll = true;
	end
	
	for varPrefix, data in MobileFrames_SpecialFrames do
		if (enableAll) or (frameName == string.upper(varPrefix)) then
			data.func(1);
			if (UltimateUI_RegisterConfiguration) then
				UltimateUI_UpdateValue(data.ultimateui, CSM_CHECKONOFF, 1);
				UltimateUI_SetCVar(data.ultimateui.."_X", 1);
				redrawUltimateUI = true;
			end
			if (not enableAll) then
				frameReadable  = GetReadableFrameName(msg);
				Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameReadable));
			end
		end
	end
	
	for index, value in MobileFrames_MasterEnableList do
		if string.upper(index) == frameName or enableAll then
			found = 1;
			MobileFrames_EnableToggle[index](1);
			if (UltimateUI_RegisterConfiguration) then
				UltimateUI_UpdateValue("UUI_MOBILE_FRAMES_ENABLE_"..string.upper(index), CSM_CHECKONOFF, 1);
				UltimateUI_SetCVar("UUI_MOBILE_FRAMES_ENABLE_"..string.upper(index).."_X", 1);
				redrawUltimateUI = true;
			end
			if not enableAll then
				frameReadable  = GetReadableFrameName(index);
				Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameReadable));
				ShowUIPanel(getglobal(index));
				break;
			end
		end
	end
	if (UltimateUI_RegisterConfiguration) then
		if UltimateUIMasterFrame:IsVisible() and (not UltimateUIMasterFrame_IsLoading) and redrawUltimateUI then
			UltimateUIMaster_DrawData();
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
	local redrawUltimateUI;
	local frameReadable = "";
	if (msg == "") or (not msg) or (msg == 0) then
		disableAll = true;
	end
	
	for varPrefix, data in MobileFrames_SpecialFrames do
		if (disableAll) or (frameName == string.upper(varPrefix)) then
			data.func(0);
			if (UltimateUI_RegisterConfiguration) then
				UltimateUI_UpdateValue(data.ultimateui, CSM_CHECKONOFF, 0);
				UltimateUI_SetCVar(data.ultimateui.."_X", 1);
				redrawUltimateUI = true;
			end
			if (not disableAll) then
				frameReadable  = GetReadableFrameName(msg);
				Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameReadable));
			end
		end
	end
	
	for index, value in MobileFrames_MasterEnableList do
		if string.upper(index) == frameName or disableAll then
			found = 1;
			MobileFrames_EnableToggle[index](0);
			if (UltimateUI_RegisterConfiguration) then
				UltimateUI_UpdateValue("UUI_MOBILE_FRAMES_ENABLE_"..string.upper(index), CSM_CHECKONOFF, 0);
				UltimateUI_SetCVar("UUI_MOBILE_FRAMES_ENABLE_"..string.upper(index).."_X", 0);
				redrawUltimateUI = true;
			end
			if not disableAll then
				frameReadable  = GetReadableFrameName(index);
				Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameReadable));
				ShowUIPanel(getglobal(index));
				break;
			end
		end
	end
	if (UltimateUI_RegisterConfiguration) then
		if UltimateUIMasterFrame:IsVisible() and (not UltimateUIMasterFrame_IsLoading) and redrawUltimateUI then
			UltimateUIMaster_DrawData();
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
	if UltimateUIMasterFrame then
		if not UltimateUIMasterFrame:IsVisible() then
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
	
	if (resetAll) or (frameName == "OPENMAILFRAME") then
		found = 1;
		if OpenMailFrame:IsVisible() then
			OpenMailFrame:Hide();
		end
		OpenMailFrame:ClearAllPoints();
		OpenMailFrame:SetPoint("TOPLEFT", "InboxFrame", "TOPRIGHT", -10, 0);
		if not resetAll then 
			frameReadable  = GetReadableFrameName("OpenMailFrame");
			Sea.IO.print(format(MOBILE_FRAMES_RESET, frameReadable));
		end
	end
	
	for index, value in MobileFrames_UIPanelWindowBackup do
		if string.upper(index) == frameName or resetAll then
			found = 1;
			MobileFrames_UIPanel_RemoveFrameRepositionIgnore(index);
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
	
	PetActionBar_UpdatePosition();
	ShapeshiftBar_UpdatePosition();
	
	if found and resetAll then
		Sea.IO.print(MOBILE_FRAMES_RESET_ALL);
	elseif not found then
		-- If it's not found, it's unrecognized.  Tell the user.
		-- disabled due to confusing call on multiple reset
		-- Sea.IO.print(MOBILE_FRAMES_ERROR);
	end
end

function MobileFrames_SetOffsets(msg)
	local redrawUltimateUI;
	msg = string.upper(msg);
	local startpos, endpos, option, value = string.find(msg, "(%w+) (%d+)");
	value = tonumber(value);
	if (option) and (value) then
		if (value >= 0) and (value <= 200) then
			if (option == "REGULAR") then
				MobileFrames_SetUIPanelOffsetLeft(1, value);
				Sea.IO.print(MOBILE_FRAMES_SET_UIPANEL_OFFSET..": "..value);
				if (UltimateUI_RegisterConfiguration) then
					UltimateUI_UpdateValue("UUI_MOBILE_FRAMES_SET_UIPANEL_OFFSET", CSM_CHECKONOFF, 1);
					UltimateUI_SetCVar("UUI_MOBILE_FRAMES_SET_UIPANEL_OFFSET_X", 1);
					UltimateUI_UpdateValue("UUI_MOBILE_FRAMES_SET_UIPANEL_OFFSET", CSM_SLIDERVALUE, value);
					UltimateUI_SetCVar("UUI_MOBILE_FRAMES_SET_UIPANEL_OFFSET", value);
					redrawUltimateUI = true;
				end
			elseif (option == "CONTAINERS") or (option == string.upper(GetReadableFrameName("Containers"))) then
				MobileFrames_SetContainerOffset(1, value);
				Sea.IO.print(MOBILE_FRAMES_SET_CONTAINERS_OFFSET..": "..value);
				if (UltimateUI_RegisterConfiguration) then
					UltimateUI_UpdateValue("UUI_MOBILE_FRAMES_SET_CONTAINERS_OFFSET", CSM_CHECKONOFF, 1);
					UltimateUI_SetCVar("UUI_MOBILE_FRAMES_SET_CONTAINERS_OFFSET_X", 1);
					UltimateUI_UpdateValue("UUI_MOBILE_FRAMES_SET_CONTAINERS_OFFSET", CSM_SLIDERVALUE, value);
					UltimateUI_SetCVar("UUI_MOBILE_FRAMES_SET_CONTAINERS_OFFSET", value);
					redrawUltimateUI = true;
				end
			end
		end
	end
	if (UltimateUI_RegisterConfiguration) then
		if UltimateUIMasterFrame:IsVisible() and (not UltimateUIMasterFrame_IsLoading) and (redrawUltimateUI) then
			UltimateUIMaster_DrawData();
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
			MobileFrames_UIPanel_AddFrameRepositionIgnore(frameName);
		end
		if MobileFrames_UIPanelWindowBackup[frameName] then
			MobileFrames_UIPanelsVisible[frameName] = MobileFrames_UIPanelWindowBackup[frameName].pushable;
		end
	end
end


function MobileFrames_RemoveFromVisibleList(frameName)
	MobileFrames_UIPanelsVisible[frameName] = nil;
end


--UltimateUI Master Hack to stop checkbox syncing on okay.
function MobileFrames_UltimateUIMaster_Save()
	UltimateUIMaster_StoreVariables();
	RegisterForSave('UltimateUIMaster_CVars');
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
-- => UIPanel Offsets Frames
-- <= == == == == == == == == == == == == =>

function MobileFrames_SetDoublewideFrame(frame)
	local oldFrame1 = UIParent.left;
	local oldFrame2 = UIParent.center;
	UIParent.doublewide = frame;
	UIParent.left = nil;
	UIParent.center = nil;

	if ( oldFrame1 ) then
		oldFrame1:Hide();
	end
	
	if ( oldFrame2 ) then
		oldFrame2:Hide();
	end

	if ( frame ) then
		frame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", UIPANEL_OFFSET_LEFT, -104);
		frame:Show();
	end
end

function MobileFrames_SetLeftFrame(frame)
	local oldFrame = UIParent.left;
	UIParent.left = frame;

	if ( oldFrame ) then
		oldFrame:Hide();
	end	

	if ( frame ) then
		frame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", UIPANEL_OFFSET_LEFT, -104);
		frame:Show();
		--HidePartyFrame();
	else
		--ShowPartyFrame();
	end
end

function MobileFrames_SetCenterFrame(frame, skipSetPoint)
	local oldFrame = UIParent.center;
	UIParent.center = frame;

	if ( oldFrame ) then
		oldFrame:Hide();
	end

	if ( frame ) then
		frame:Show();
		if ( not skipSetPoint ) then
			frame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", UIPANEL_OFFSET_LEFT+384, -104);
		end
		-- Hide all child windows
		local childWindow;
		for index, value in UIChildWindows do
			childWindow = getglobal(value);
			if ( childWindow ) then
				childWindow:Hide();
			end
		end
	end
	
end

function MobileFrames_MovePanelToLeft()
	if ( UIParent.center ) then
		SetLeftFrame(nil);
		UIParent.center:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", UIPANEL_OFFSET_LEFT, -104);
		UIParent.left = UIParent.center
		UIParent.center = nil;
	end
end

function MobileFrames_MovePanelToCenter()
	if ( UIParent.left ) then
		SetCenterFrame(nil);
		UIParent.left:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", UIPANEL_OFFSET_LEFT+384, -104);
		UIParent.center = UIParent.left
		UIParent.left = nil;
	end
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Container Frames
-- <= == == == == == == == == == == == == =>

function MobileFrames_updateContainerFrameAnchors()
	-- Adjust the start anchor for bags depending on the multibars
	UIParent_ManageRightSideFrames();
	local xOffset = CONTAINER_OFFSET_X;
	local uiScale = GetCVar("uiscale") + 0;
--	local screenHeight = GetScreenHeight();
	local screenHeight = 768;
	if ( GetCVar("useUiScale") == "1" ) then
		screenHeight = 768 / uiScale;
	end
	local freeScreenHeight = screenHeight - CONTAINER_OFFSET_Y;
	local lastBag = nil;
	local column = 0;
	for index, frameName in ContainerFrame1.bags do
		local frame = getglobal(frameName);
		if (not frame.isMoving) then
			if (MobileFrames_MobileContainers) and (MobileFrames_ContainerPositionsByID[frame:GetID()]) then
				-- Bag has been previously moved
				local x = MobileFrames_ContainerPositionsByID[frame:GetID()][1];
				local y = MobileFrames_ContainerPositionsByID[frame:GetID()][2];
				frame:ClearAllPoints();
				frame:SetPoint(MobileFrames_ContainerPointSettings[MOBILEFRAMES_CONTAINER_POINT], MobileFrames_ContainerPointSettings[MOBILEFRAMES_CONTAINER_RELATIVETO], MobileFrames_ContainerPointSettings[MOBILEFRAMES_CONTAINER_RELATIVEPOINT], x, y );
				
			else
				-- freeScreenHeight determines when to start a new column of bags
				if ( not lastBag ) then
					-- First bag
					frame:ClearAllPoints();
					frame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -xOffset, CONTAINER_OFFSET_Y);
				elseif ( freeScreenHeight < frame:GetHeight() ) then
					-- Start a new column
					column = column + 1;
					freeScreenHeight = UIParent:GetHeight() - CONTAINER_OFFSET_Y;
					frame:ClearAllPoints();
					frame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - xOffset, CONTAINER_OFFSET_Y);
				else
					-- Anchor to the previous bag
					frame:ClearAllPoints();
					frame:SetPoint("BOTTOMRIGHT", lastBag, "TOPRIGHT", 0, CONTAINER_SPACING);	
				end
				freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
				--last bag is the last unpositioned bag (not yet dragged)
				lastBag = frameName;
			end
		end
	end
	-- This is used to position the unit tooltip
	local oldContainerPosition = OPEN_CONTAINER_POSITION;
	if ( ContainerFrame1.bagsShown == 0 ) then
		DEFAULT_TOOLTIP_POSITION = -13;
	else
		DEFAULT_TOOLTIP_POSITION = -((column + 1) * CONTAINER_WIDTH) - xOffset;
	end
	if ( DEFAULT_TOOLTIP_POSITION ~= oldContainerPosition and GameTooltip.default and GameTooltip:IsVisible() ) then
		GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", DEFAULT_TOOLTIP_POSITION, 64);
	end
end

function MobileFrames_MarkContainerCoords(frame)
	local x = frame:GetLeft(); 
	local y = frame:GetTop(); 
	local coords = { x, y }; 
	MobileFrames_ContainerPositionsByID[frame:GetID()] = coords;
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
	local container;
	local bar;
	for i=1, 17 do
		container = getglobal("ContainerFrame"..i);
		bar = getglobal("ContainerFrame"..i.."MobileBar");
		container:ClearAllPoints();
		if container:IsVisible() then
			container:Hide();
		end
		if (MobileFrames_MobileContainers) then
			bar:EnableMouse(1);
		else
			bar:EnableMouse(0);
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
-- => Mobile Frame Anchors
-- <= == == == == == == == == == == == == =>

function MobileFrames_SideAnchor_OnShow(anchorFrame)
	if (MobileFrames_AnchorsSoundOn) then
		--PlaySoundFile("Sound\\Character\\Footsteps\\EnterWaterSplash\\EnterWaterMediumA.wav");
	end
	if ( (anchorFrame:GetParent():GetLeft()+(anchorFrame:GetParent():GetWidth()/2)) > UIParent:GetRight()/2 ) then
		anchorFrame:ClearAllPoints();
		anchorFrame:SetPoint("RIGHT", anchorFrame:GetParent():GetName(), "LEFT", anchorFrame.leftx, 0);
	else
		anchorFrame:ClearAllPoints();
		anchorFrame:SetPoint("LEFT", anchorFrame:GetParent():GetName(), "RIGHT", anchorFrame.rightx, 0);
	end
end

function MobileFrames_TopBottomAnchor_OnShow(anchorFrame)
	if (MobileFrames_AnchorsSoundOn) then
		--PlaySoundFile("Sound\\Character\\Footsteps\\EnterWaterSplash\\EnterWaterMediumA.wav");
	end
	if ( (anchorFrame:GetParent():GetBottom()+(anchorFrame:GetParent():GetHeight()/2)) < UIParent:GetTop()/2 ) then
		anchorFrame:ClearAllPoints();
		anchorFrame:SetPoint("BOTTOM", anchorFrame:GetParent():GetName(), "TOP", 0, anchorFrame.topy);
	else
		anchorFrame:ClearAllPoints();
		anchorFrame:SetPoint("TOP", anchorFrame:GetParent():GetName(), "BOTTOM", 0, anchorFrame.bottomy);
	end
end

function MobileFrames_Anchor_OnHide(anchorFrame)
	MobileFrames_BarStopDrag(anchorFrame);
	if (MobileFrames_AnchorsSoundOn) and (not MobileFrames_AnchorsUp) then
		PlaySoundFile("Sound\\Character\\Footsteps\\EnterWaterSplash\\EnterWaterMediumA.wav");
	end
end

function MobileFrames_Anchor_OnLoad(anchorFrame)
	
	anchorFrame.rightx = 0;
	anchorFrame.leftx = 0;
	anchorFrame.topy = 0;
	anchorFrame.bottomy = 0;
				
	if (not anchorFrame:GetParent():IsMovable()) then
		anchorFrame:GetParent():SetMovable(1);
	end

	--set default enable status
	MobileFrames_MasterAnchorEnableList[anchorFrame:GetParent():GetName()] = MobileFrames_EnabledByDefault;
	
end

function MobileFrames_ToggleSound()

	MobileFrames_EnableAnchorSound();
	
	if (UltimateUI_RegisterConfiguration) then
		local onOff;
		if (MobileFrames_AnchorsSoundOn) then
			onOff = 1;
		else
			onOff = 0;
		end
		UltimateUI_UpdateValue("UUI_MOBILE_FRAMES_ENABLE_SOUND", CSM_CHECKONOFF, onOff);
		UltimateUI_SetCVar("UUI_MOBILE_FRAMES_ENABLE_SOUND_X", onOff);
		if UltimateUIMasterFrame:IsVisible() and (not UltimateUIMasterFrame_IsLoading) then
			UltimateUIMaster_DrawData();
		end
	end

end

function MobileFrames_EnableAnchorSound(checked)
	if checked == nil then
		MobileFrames_AnchorsSoundOn = (not MobileFrames_AnchorsSoundOn);
	else
		MobileFrames_AnchorsSoundOn = (checked == 1);
	end
end

function MobileFrames_AnchorToggleEnableGeneral(frameName, checked)
	if checked == nil then
		MobileFrames_MasterAnchorEnableList[frameName] = (not MobileFrames_MasterAnchorEnableList[frameName]);
	else
		MobileFrames_MasterAnchorEnableList[frameName] = (checked == 1);
	end
	if getglobal(frameName.."MobileButton"):IsVisible() then
		getglobal(frameName.."MobileButton"):Hide();
	end
	if not MobileFrames_MasterAnchorEnableList[frameName] then
		if getglobal(frameName.."MobileButton"):IsVisible() then
			getglobal(frameName.."MobileButton"):Hide();
		end
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameName));
		end
	else
		if ( not getglobal(frameName.."MobileButton"):IsVisible() ) and (MobileFrames_AnchorsUp) then
			getglobal(frameName.."MobileButton"):Show();
		end
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameName));
		end
	end
end

function MobileFrames_ToggleAnchors()
	
	if (MobileFrames_AnchorsUp) then
		MobileFrames_AnchorsUp = false;
		MultiActionBar_HideAllGrids();
		PopNUI_Override = Previous_PopNUI_Override;
		TransNUI_Override = Previous_TransNUI_Override;
	else
		MobileFrames_AnchorsUp = true;
		MultiActionBar_ShowAllGrids();
		Previous_PopNUI_Override = PopNUI_Override;
		Previous_TransNUI_Override = TransNUI_Override;
		PopNUI_Override = true;
		TransNUI_Override = true;
	end
	
	for frameName, enabled in MobileFrames_MasterAnchorEnableList do
		if (MobileFrames_AnchorsUp) and (enabled) then
			getglobal(frameName.."MobileButton"):Show();
		else
			getglobal(frameName.."MobileButton"):Hide();
		end
	end
	
	PetActionBar_UpdatePosition();
	ShapeshiftBar_UpdatePosition();

end

-- <= == == == == == == == == == == == == =>
-- => Mobile Anchor Frames Reset
-- <= == == == == == == == == == == == == =>

function MobileFrames_EnableMobilePartyMemberFrames(checked) 
	MobileFrames_AnchorToggleEnableGeneral("PartyMemberFrame1", checked);
	MobileFrames_AnchorToggleEnableGeneral("PartyMemberFrame2", checked);
	MobileFrames_AnchorToggleEnableGeneral("PartyMemberFrame3", checked);
	MobileFrames_AnchorToggleEnableGeneral("PartyMemberFrame4", checked);
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
	MobileFrames_AnchorToggleEnableGeneral("PlayerFrame", checked);
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
	MobileFrames_AnchorToggleEnableGeneral("TargetFrame", checked);
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
	MobileFrames_AnchorToggleEnableGeneral("PetFrame", checked);
end

function MobileFrames_ResetMobilePetFrame()
	if ( PetFrame.isMoving ) then
		PetFrame:StopMovingOrSizing();
		PetFrame.isMoving = false;
	else
		PetFrame:ClearAllPoints();
		PetFrame:SetPoint("TOPLEFT", "PlayerFrame", "TOPLEFT", 80, -60);
	end
end

function MobileFrames_EnableMobileBottomMultiBars(checked) 
	MobileFrames_AnchorToggleEnableGeneral("MultiBarBottomRight", checked);
	MobileFrames_AnchorToggleEnableGeneral("MultiBarBottomLeft", checked);
end

function MobileFrames_ResetMobileBottomMultiBars()
	if ( MultiBarBottomLeft.isMoving ) or ( MultiBarBottomRight.isMoving ) then
		MultiBarBottomLeft:StopMovingOrSizing();
		MultiBarBottomLeft.isMoving = false;
		MultiBarBottomRight:StopMovingOrSizing();
		MultiBarBottomRight.isMoving = false;
	else
		MultiBarBottomLeft:ClearAllPoints();
		MultiBarBottomLeft:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", 0, 17);
		MultiBarBottomRight:ClearAllPoints();
		MultiBarBottomRight:SetPoint("LEFT", "MultiBarBottomLeft", "RIGHT", 10, 0);
	end
end

function MobileFrames_EnableMobileSideMultiBars(checked) 
	MobileFrames_AnchorToggleEnableGeneral("MultiBarLeft", checked);
	MobileFrames_AnchorToggleEnableGeneral("MultiBarRight", checked);
end

function MobileFrames_ResetMobileSideMultiBars()
	if ( MultiBarLeft.isMoving ) or ( MultiBarRight.isMoving ) then
		MultiBarLeft:StopMovingOrSizing();
		MultiBarLeft.isMoving = false;
		MultiBarRight:StopMovingOrSizing();
		MultiBarRight.isMoving = false;
	else
		MultiBarRight:ClearAllPoints();
		MultiBarRight:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -7, 98);
		MultiBarLeft:ClearAllPoints();
		MultiBarLeft:SetPoint("TOPRIGHT", "MultiBarRight", "TOPLEFT", -5, 0);
	end
end

function MobileFrames_ResetMobileMinimapCluster()
	if ( MinimapCluster.isMoving ) then
		MinimapCluster:StopMovingOrSizing();
		MinimapCluster.isMoving = false;
	else
		MinimapCluster:ClearAllPoints();
		MinimapCluster:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", 0, 0);
	end
end

function MobileFrames_TicketStatus_Reset()
	TicketStatusFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -180, 0);
end

-- <= == == == == == == == == == == == == =>
-- => Pet/Shapeshift/Aura Bar Position Update
-- <= == == == == == == == == == == == == =>

function MobileFrames_PetActionBar_UpdatePosition()
	if ( MultiBarBottomLeft:IsVisible() ) and ( MobileFrames_MultiBarBottomLeft_IsReset() ) then
		PETACTIONBAR_YPOS = 141;
		SlidingActionBarTexture0:Hide();
		SlidingActionBarTexture1:Hide();
	else
		PETACTIONBAR_YPOS = 98;
		SlidingActionBarTexture0:Show();
		SlidingActionBarTexture1:Show();
	end
	if ( not PetActionBarFrame:IsVisible() ) then
		return;
	end
	PetActionBarFrame:SetPoint("TOPLEFT", "MainMenuBar", "BOTTOMLEFT", PETACTIONBAR_XPOS, PETACTIONBAR_YPOS);
end

function MobileFrames_ShapeshiftBar_UpdatePosition()
	if ( MultiBarBottomLeft:IsVisible() ) and ( MobileFrames_MultiBarBottomLeft_IsReset() ) then
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 45);
		ShapeshiftBarLeft:Hide();
		ShapeshiftBarRight:Hide();
		ShapeshiftBarMiddle:Hide();
	else
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
		if ( GetNumShapeshiftForms() > 2 ) then
			ShapeshiftBarMiddle:Show();
		end
		ShapeshiftBarLeft:Show();
		ShapeshiftBarRight:Show();
	end
end

function MobileFrames_MultiBarBottomLeft_IsReset()
	if ( not MultiBarBottomLeft:GetCenter() ) or ( not PetActionBarFrame:GetLeft() )  or ( not ActionButton1:GetTop() ) then
		if  ( MultiBarBottomLeft:IsVisible() ) then
			return true;
		else
			return false;
		end
	end
	if  ( MultiBarBottomLeft:IsVisible() ) and
		( MultiBarBottomLeft:GetCenter() < PetActionBarFrame:GetRight() ) and 
		( MultiBarBottomLeft:GetCenter() > PetActionBarFrame:GetLeft() ) and
		( MultiBarBottomLeft:GetTop() < ActionButton1:GetTop()+PetActionBarFrame:GetHeight()+MultiBarBottomLeft:GetHeight() )
		then
		return true;
	else
		return false;
	end
end

-- <= == == == == == == == == == == == == =>
-- => Special Frame Offsets
-- <= == == == == == == == == == == == == =>

function MobileFrames_UIParent_ManageRightSideFrames(setQWFPoint, setDFPoint)
	local anchorX = 0;
	local anchorY = 0;

	-- Update tutorial anchor
	if ( MultiBarBottomRight:IsVisible() or MultiBarBottomLeft:IsVisible() ) then
		TutorialFrameParent:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 94);
	else
		TutorialFrameParent:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 52);
	end
	
	MobileFrames_FramerateLabelReset(true);
	
	-- Update bag anchor
	if (PopNUI_UIParent_ManageRightSideFrames) then
		PopNUI_UIParent_ManageRightSideFrames()
	else
		if ( MultiBarBottomRight:IsVisible() ) then
			CONTAINER_OFFSET_Y = 97;
		else
			CONTAINER_OFFSET_Y = 70;
		end
	end
	
	-- Setup x anchor
	if (CONTAINER_OFFSET_X_SET) then
		CONTAINER_OFFSET_X = CONTAINER_OFFSET_X_SET;
	elseif (PopNUI_UIParent_ManageRightSideFrames) then
		PopNUI_UIParent_ManageRightSideFrames()
	else
		if ( MultiBarLeft:IsVisible() ) then
			CONTAINER_OFFSET_X = 90;
		elseif ( MultiBarRight:IsVisible() ) then
			CONTAINER_OFFSET_X = 45;
		else
			CONTAINER_OFFSET_X = 0;
		end
	end
	anchorX = CONTAINER_OFFSET_X;
	-- Setup y anchors
	QuestTimerFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -anchorX, anchorY);
	if ( QuestTimerFrame:IsVisible() ) then
		anchorY = anchorY - QuestTimerFrame:GetHeight();
	end
	if (setDFPoint) or (MobileFrames_RightSide_FrameRepositionIsBeingIgnored("DurabilityFrame")) then
		DurabilityFrame:ClearAllPoints();
		DurabilityFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -anchorX-40, anchorY);
		MobileFrames_RightSide_AddFrameRepositionIgnore("DurabilityFrame");
	end
	if (MobileFrames_RightSide_FrameRepositionIsBeingIgnored("DurabilityFrame")) and (DurabilityFrame:IsVisible()) then
		anchorY = anchorY - DurabilityFrame:GetHeight();
	end
	if (setQWFPoint) or (MobileFrames_RightSide_FrameRepositionIsBeingIgnored("QuestWatchFrame")) then
		QuestWatchFrame:ClearAllPoints();
		QuestWatchFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -anchorX, anchorY);
		MobileFrames_RightSide_AddFrameRepositionIgnore("QuestWatchFrame");
	end
end

function MobileFrames_SetContainerOffset(checked, value)
	CONTAINER_OFFSET_X_SET = nil;
	if (type(value) == "number") and (checked == 1) then
		if (value >= 0) then
			CONTAINER_OFFSET_X_SET = value;
			MobileOffsetMarker:ClearAllPoints();
			MobileOffsetMarker:SetPoint("CENTER", "UIParent", "RIGHT", -CONTAINER_OFFSET_X_SET, 0);
			MobileOffsetMarker:Show();
			MobileFrames_OffsetMarker_Fade();
		end
	end
end

function MobileFrames_SetUIPanelOffsetLeft(checked, value)
	UIPANEL_OFFSET_LEFT = 0;
	if (type(value) == "number") and (checked == 1) then
		if (value >= 0) then
			UIPANEL_OFFSET_LEFT = value;
			MobileOffsetMarker:ClearAllPoints();
			MobileOffsetMarker:SetPoint("CENTER", "UIParent", "LEFT", UIPANEL_OFFSET_LEFT, 0);
			MobileOffsetMarker:Show();
			MobileFrames_OffsetMarker_Fade();
		end
	end
end

function MobileFrames_OffsetMarker_Fade()
	if (MobileOffsetMarker:IsVisible()) then
		MobileOffsetMarker:SetAlpha(1);
		MobileOffsetMarker.counter = 80; -- ~ 2 sec timer
		MobileOffsetMarker.fadeCount = 40;  -- fade when ~ 1 sec left
		MobileOffsetMarker.isFading = true;
	end
end

function MobileFrames_OffsetMarker_OnLoad()
	--this.counter = 0;
end

function MobileFrames_OffsetMarker_Hide()
	MobileOffsetMarker.isFading = false;
	MobileOffsetMarker.counter = nil;
	MobileOffsetMarker.fadeCount = nil;
	MobileOffsetMarker:Hide();
end

function MobileFrames_OffsetMarker_OnUpdate()
	if (this.isFading) then
		if (type(this.counter) == "number") then
			if (this.counter > 0) then
				this.counter = this.counter - 1;
				if (type(this.fadeCount) == "number") then
					if (this.counter < this.fadeCount) then
						this:SetAlpha(this.counter/this.fadeCount);
					end
				end
			else
				this.counter = nil;
				this.fadeCount = nil;
			end
		else
			this.isFading = false;
			this:Hide()
			this:SetAlpha(1);
		end
	end
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Framerate
-- <= == == == == == == == == == == == == =>

function MobileFrames_ToggleFramerateMobileBar()
	if ( FramerateLabelMobileBar and FramerateLabel:IsVisible() ) then
		FramerateLabelMobileBar:Show();
	else
		FramerateLabelMobileBar:Hide();
	end
end

function MobileFrames_TurnOnFPSMove(toggle)
	-- Move the FPS
	if (toggle == 1) then
		FramerateLabelMobileBar:ClearAllPoints();
		FramerateLabelMobileBar:SetPoint("TOPLEFT", "WorldFrame", "TOPLEFT", 0, 0);
	else
		FramerateLabelMobileBar:ClearAllPoints();
		FramerateLabelMobileBar:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 0, 64);
	end
end

function MobileFrames_FramerateLabelReset(passive)
	if (FramerateLabelMobileBar) then
		local bottom;
		local center = math.abs(WorldFrame:GetCenter() - FramerateLabelMobileBar:GetCenter());
		if ( MultiBarBottomRight:IsVisible() or MultiBarBottomLeft:IsVisible() ) then
			bottom = math.abs(64 - FramerateLabelMobileBar:GetBottom());
			if (not passive) or (bottom <= 4 and center <= 4) then
				FramerateLabelMobileBar:ClearAllPoints();
				FramerateLabelMobileBar:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 0, 104);
			end
		else
			bottom = math.abs(104 - FramerateLabelMobileBar:GetBottom());
			if (not passive) or (bottom <= 4 and center <= 4) then
				FramerateLabelMobileBar:ClearAllPoints();
				FramerateLabelMobileBar:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 0, 64);
			end
		end
	end
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Minimap Buttons
-- <= == == == == == == == == == == == == =>

function MobileFrames_MobileMinimapButton_OnLoad(buttonFrame, point, defaultX, defaultY)
	local parentName = buttonFrame:GetParent():GetName();
	buttonFrame:RegisterEvent("VARIABLES_LOADED");
	buttonFrame:GetParent():SetFrameLevel(buttonFrame:GetParent():GetFrameLevel()+1);
	buttonFrame:SetFrameLevel(buttonFrame:GetParent():GetFrameLevel()+1);
	MobileFrames_MakeParentMobile(buttonFrame);
	MobileFrames_MinimapButtonDefaultCoords[parentName] = {};
	MobileFrames_MinimapButtonDefaultCoords[parentName].point = point;
	MobileFrames_MinimapButtonDefaultCoords[parentName].x = defaultX;
	MobileFrames_MinimapButtonDefaultCoords[parentName].y = defaultY;
end

function MobileFrames_MobileMinimapButton_OnEvent(buttonFrame, event)
	if (event == "VARIABLES_LOADED") then
		local coords = MobileFrames_MinimapButtonCoords[buttonFrame:GetParent():GetName()];
		if (not coords) or (not coords.x) or (not coords.y) then
			coords = MobileFrames_MinimapButtonDefaultCoords[buttonFrame:GetParent():GetName()];
			if (not coords.x) or (not coords.y) or (not coords.point) then
				Sea.io.print("ERROR: NO DEFALT POINTS DEFINED FOR ", buttonFrame:GetParent():GetName());
			else
				buttonFrame:GetParent():ClearAllPoints();
				buttonFrame:GetParent():SetPoint(coords.point, "Minimap", coords.point, coords.x, coords.y);
			end
		else
			buttonFrame:GetParent():ClearAllPoints();
			buttonFrame:GetParent():SetPoint("CENTER", "Minimap", "CENTER", coords.x, coords.y);
		end
	end
end

function MobileFrames_MobileMinimapButton_OnMouseDown(buttonFrame)
	if (IsShiftKeyDown()) then
		if ( arg1 == "RightButton" ) then
			--MobileFrames_MobileMinimapButton_Reset(buttonFrame:GetParent());
		else
			buttonFrame:GetParent().isMoving = true;
		end
	end
end

function MobileFrames_MobileMinimapButton_OnMouseUp(buttonFrame, clickFunction)
	if (buttonFrame:GetParent().isMoving) then
		local parentName = buttonFrame:GetParent():GetName();
		buttonFrame:GetParent().isMoving = false;
		if (not MobileFrames_MinimapButtonCoords[parentName]) then
			MobileFrames_MinimapButtonCoords[parentName] = {};
		end
		MobileFrames_MinimapButtonCoords[parentName].x = buttonFrame:GetParent().currentX;
		MobileFrames_MinimapButtonCoords[parentName].y = buttonFrame:GetParent().currentY;
	elseif (MouseIsOver(buttonFrame:GetParent())) then
		if (IsShiftKeyDown()) and ( arg1 == "RightButton" ) then
			MobileFrames_MobileMinimapButton_Reset(buttonFrame:GetParent());
		else
			clickFunction();
		end
	end
end

function MobileFrames_MobileMinimapButton_OnClick(frame)
	--Use me for casting spells from clicks.
end

function MobileFrames_MobileMinimapButton_OnHide(buttonFrame)
	buttonFrame:GetParent().isMoving = false;
end

function MobileFrames_MobileMinimapButton_OnUpdate(buttonFrame)
	if (buttonFrame:GetParent().isMoving) then
		local mouseX, mouseY = GetCursorPosition();
		local centerX, centerY = Minimap:GetCenter();
		local scale = Minimap:GetScale();
		mouseX = mouseX / scale;
		mouseY = mouseY / scale;
		local radius = (Minimap:GetWidth()/2) + (buttonFrame:GetParent():GetWidth()/3);
		local x = math.abs(mouseX - centerX);
		local y = math.abs(mouseY - centerY);
		local xSign = 1;
		local ySign = 1;
		if not (mouseX >= centerX) then
			xSign = -1;
		end
		if not (mouseY >= centerY) then
			ySign = -1;
		end
		--Sea.io.print(xSign*x,", ",ySign*y);
		local angle = math.atan(x/y);
		x = math.sin(angle)*radius;
		y = math.cos(angle)*radius;
		buttonFrame:GetParent().currentX = xSign*x;
		buttonFrame:GetParent().currentY = ySign*y;
		buttonFrame:GetParent():SetPoint("CENTER", "Minimap", "CENTER", buttonFrame:GetParent().currentX, buttonFrame:GetParent().currentY);
	end
end

function MobileFrames_MobileMinimapButton_Reset(minimapButtonFrame)
	local coords = MobileFrames_MinimapButtonDefaultCoords[minimapButtonFrame:GetName()];
	minimapButtonFrame:ClearAllPoints();
	minimapButtonFrame:SetPoint(coords.point, "Minimap", coords.point, coords.x, coords.y);
	local parentName = minimapButtonFrame:GetName();
	if (not MobileFrames_MinimapButtonCoords[parentName]) then
		MobileFrames_MinimapButtonCoords[parentName] = {};
	end
	MobileFrames_MinimapButtonCoords[parentName].x = coords.x;
	MobileFrames_MinimapButtonCoords[parentName].y = coords.y;
end

function MobileFrames_MobileMinimapButton_PrintCoordsOffset(buttonFrame)
	local buttonCenterX, buttonCenterY = buttonFrame:GetCenter();
	local centerX, centerY = Minimap:GetCenter();
	Sea.io.print(buttonCenterX-centerX,", ",buttonCenterY-centerY);
end

function MobileFrames_Minimap_ZoomInClick()
	MinimapZoomOutMobileMinimapButton:Enable();
	if(Minimap:GetZoom() == (Minimap:GetZoomLevels() - 1)) then
		MinimapZoomInMobileMinimapButton:Disable();
	end
end

function MobileFrames_Minimap_ZoomOutClick()
	MinimapZoomInMobileMinimapButton:Enable();
	if(Minimap:GetZoom() == 0) then
		MinimapZoomOutMobileMinimapButton:Disable();
	end
end

function MobileFrames_Minimap_OnEvent()
	if ( event == "MINIMAP_UPDATE_ZOOM" ) then
		MinimapZoomInMobileMinimapButton:Enable();
		MinimapZoomOutMobileMinimapButton:Enable();
		local zoom = Minimap:GetZoom();
		if ( zoom == (Minimap:GetZoomLevels() - 1) ) then
			MinimapZoomInMobileMinimapButton:Disable();
		elseif ( zoom == 0 ) then
			MinimapZoomOutMobileMinimapButton:Disable();
		end
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
