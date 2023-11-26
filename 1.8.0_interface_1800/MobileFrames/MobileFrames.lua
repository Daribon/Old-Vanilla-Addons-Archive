--------------------------------------------------------------------------
-- MobileFrames.lua 
--------------------------------------------------------------------------
--[[
Mobile Frames

By: AnduinLothar    <KarlKFI@cosmosui.org>

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
	"/mfrollstack" - toggle group loot window stacking down or up.

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
	Containers (Bags),
	PlayerFrame,
	TargetFrame,
	PartyMemberFrames,
	BottomMultiBars,
	SideMultiBars,
	MinimapCluster,
	AuctionFrame,
	TalentFrame,
	PetFrame,
	MailFrame,
	OpenMailFrame,
	QuestWatchFrame,
	FramerateLabel  (Framerate),
	DurabilityFrame,
	TicketStatusFrame,
	TemporaryEnchantFrame (Buffs),
	BattlefieldFrame,
	MiniMapBattlefieldFrame,
	WorldStateScoreFrame,
	DressUpFrame,
	TaxiFrame,
	MainMenuBar,
	BackpackButtons,
	MicroButtons,
	ActionButtons,
	ShapeshiftBarFrame (Shapeshift/Aura/Stance Bar)
	
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
	v1.61 (3/11/05)
		-Added German Localization.
	v1.7 (3/23/05)
		-TOC updated to 1300.
		-Added "Toggle Anchors" button to the cosmos button page.
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
		-Fixed Bug where Cosmos Variables wouldn't save using slash commands
	v2.0
		-Made Mobile: Minimap Buttons (zoomin, zoomout, mail, tracking, meetingstone)
		[Shift-Drag to move around the Minimap. Shift-Rightclick to reset.]
	v2.1 (5/2/05)
		-Made Mobile: DurabilityFrame, TicketStatusFrame
		-Updated Mobile MiniMap Button code. You can now hook MobileFrames_MobileMinimapButton_OnClick to cast spells and the mouseover/click graphics work.
	v2.2 (5/10/05)
		-Made Mobile: Buffs
		-Reworked slash commands so that you can use the readable name (as seen in /mflist) to reset, enable and disable frames.
	v2.3 (5/13/05)
		-Fixed Bug where settings weren't being restored w/o cosmos
		-Added Khaos Config Registration
	v2.4 (5/16/05)
		-Made Mobile: BattlefieldFrame, MiniMapBattlefieldFrame, WorldStateScoreFrame
		-Updated TOC to 1500
	v2.5 (6/2/05)
		-Fixed Buff repositioning
		-Made Mobile: GroupLootFrame
		-Added option for GroupLootFrame stacking down or up.
	v2.6 (6/24/05)
		-Made Mobile: CastingBarFrame
		-Fixed Khaos enable and disable all
		-Fixed slash commands to correctly update Khaos.
		-Fixed a VisibilityOptions cyclic loading problem
	v2.7 (9/6/05)
		-Fixed UIPanelOffset Khaos Option dependancy
		-Fixed MinimapZoomOut wrapping bug
	v2.71 (9/26/05)
		-Updated Container Hook to work with BarOptions
	v2.8 (10/16/05)
		-Updated for 1800 compatibility
		-Made Mobile: DressUpFrame, TaxiFrame, MainMenuBar, BackpackButtons, MicroButtons, ActionButtons, ShapeshiftBarFrame (Shapeshift/Aura/Stance Bar)
		-Implimented SetUserPlaced(0) for all resets
		-Removed Minimap Mobile Buttons (use the MobileMinimapButtons addon)
		-Removed duplicate entries in the Khaos 'Regular Options'.
		-Added Shift-RightClick Reset menus for all anchors and mobile bars.
	v2.9 (10/17/05)
		-Made MainMenuBar anchor top/bottom rather than left/right
		-Made Mobile: PetActionBarFrame
		-Fixed some PetActionBarFrame related positioning overlap
		-Added Tooltip for Mobile Bars and Anchors.
		-Fixed WorldStateScoreFrame reset bug
	v2.91 (10/19/05)
		-Fixed Pet Bar positioning problems.
		-Fixed Shapeshift Bar positionig problems.
		-Made Mobile: WorldStateAlwaysUpFrame (AB Scores)
	v2.92 (10/20/05)
		-Fixed another Pet Bar positioning problem regarding the chatframe.
	v2.93 (10/23/05)
		-Fixed a bug with enable and disable all with the wrong khaos key being called.
		-Alphebatized the Frame Listings
		
	$Id: MobileFrames.lua 2685 2005-10-23 12:23:02Z karlkfi $
	$Rev: 2685 $
	$LastChangedBy: karlkfi $
	$Date: 2005-10-23 07:23:02 -0500 (Sun, 23 Oct 2005) $


]]--

MobileFrames_AnchorsSoundOn = true;

MobileFrames_UIPanelWindowBackup = {};
MobileFrames_UIPanelsVisible = {};
MobileFrames_RightSide_IsReset = {};
MobileFrames_MasterEnableList = {};
MobileFrames_MasterAnchorEnableList = {};
MobileFrames_MinimapButtonDefaultCoords = {};
MobileFrames_ResetFrame = {};			--reset a mobile frame using MobileFrames_ResetFrame[frameName]() used for cosmos config
MobileFrames_EnableToggle = {};			--enable/disable a mobile frame using MobileFrames_EnableToggle[frameName](1/0) used for cosmos config
MobileFrames_EnabledByDefault = true;   --true or false, never use nil
local SavedCloseWindows = nil;
MobileFrames_RollStackDown = nil;
MobileFrames_Tooltip_Enabled = true;
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

		PlayerFrame = { cosmos = "COS_MOBILE_FRAMES_PLAYERFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePlayerFrame, reset = MobileFrames_ResetMobilePlayerFrame },
		PetFrame = { cosmos = "COS_MOBILE_FRAMES_PETFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePetFrame, reset = MobileFrames_ResetMobilePetFrame },
		TargetFrame = { cosmos = "COS_MOBILE_FRAMES_TARGETFRAME", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileTargetFrame, reset = MobileFrames_ResetMobileTargetFrame },
		PartyMemberFrames = { cosmos = "COS_MOBILE_FRAMES_PARTYMEMBERFRAMES", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobilePartyMemberFrames, reset = MobileFrames_ResetMobilePartyMemberFrames},
		Containers = { cosmos = "COS_MOBILE_FRAMES_CONTAINERS", default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileContainers, reset = MobileFrames_ResetMobileContainers},
		BottomMultiBars = { cosmos = "COS_MOBILE_FRAMES_BOTTOMMULTIBARS", reset = MobileFrames_ResetMobileBottomMultiBars, default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileBottomMultiBars },
		SideMultiBars = { cosmos = "COS_MOBILE_FRAMES_SIDEMULTIBARS", reset = MobileFrames_ResetMobileSideMultiBars, default = MobileFrames_EnabledByDefault, func = MobileFrames_EnableMobileSideMultiBars },
		MinimapCluster = { cosmos = "COS_MOBILE_FRAMES_MINIMAP", reset = MobileFrames_ResetMobileMinimapCluster, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("MinimapCluster", checked) end },
		QuestWatchFrame = { cosmos = "COS_MOBILE_FRAMES_QUESTWATCH", reset = function() MobileFrames_UIParent_ManageRightSideFrames(true, nil) end, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("QuestWatchFrame", checked) end },
		FramerateLabel = { cosmos = "COS_MOBILE_FRAMES_FRAMERATE", reset = MobileFrames_FramerateLabelReset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("FramerateLabel", checked) end },
		DurabilityFrame = { cosmos = "COS_MOBILE_FRAMES_DURRABILITY", reset = function() MobileFrames_UIParent_ManageRightSideFrames(nil, true) end, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("DurabilityFrame", checked) end },
		TicketStatusFrame = { cosmos = "COS_MOBILE_FRAMES_TICKETSTATUS", reset = MobileFrames_ResetTicketStatusFrame, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("TicketStatusFrame", checked) end },
		TemporaryEnchantFrame = { cosmos = "COS_MOBILE_FRAMES_BUFFFRAME", reset = MobileFrames_ResetMobileBuffFrame, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("TemporaryEnchantFrame", checked) end },
		WorldStateScoreFrame = { cosmos = "COS_MOBILE_FRAMES_WORLDSTATESCORE", reset = MobileFrames_WorldStateScoreFrameReset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("WorldStateScoreFrame", checked) end },
		WorldStateAlwaysUpFrame = { cosmos = "COS_MOBILE_FRAMES_WORLDSTATEALWAYSUP", reset = MobileFrames_WorldStateAlwaysUpFrameReset, default = MobileFrames_EnabledByDefault, func = MobileFrames_WorldStateAlwaysUpFrameEnable },
		GroupLootFrame = { cosmos = "COS_MOBILE_FRAMES_GROUPLOOT", reset = function() MobileFrames_UIParent_ManageRightSideFrames(nil, nil, true) end, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("GroupLootFrame1", checked) end },
		CastingBarFrame = { cosmos = "COS_MOBILE_FRAMES_CASTINGBAR", reset = function() MobileFrames_CastingBarFrame_UpdatePosition(true) end, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_ToggleEnableGeneral("CastingBarFrame", checked) end },
		MainMenuBar = { cosmos = "COS_MOBILE_FRAMES_MAINMENUBAR", reset = MobileFrames_MobileMainMenuBar_Reset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("MainMenuBar", checked) end },
		BackpackButtons = { cosmos = "COS_MOBILE_FRAMES_BACKPACKBUTTONS", reset = MobileFrames_MobileMainBackpackButtons_Reset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("MainMenuBarBackpackButton", checked) end },
		MicroButtons = { cosmos = "COS_MOBILE_FRAMES_MICROBUTTONS", reset = MobileFrames_MobileCharacterMicroButtons_Reset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("CharacterMicroButton", checked) end },
		ActionButtons = { cosmos = "COS_MOBILE_FRAMES_ACTIONBUTTONS", reset = MobileFrames_MobileActionButtons_Reset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("ActionButton1", checked) end },
		ShapeshiftBarFrame = { cosmos = "COS_MOBILE_FRAMES_SHAPESHIFTBAR", reset = MobileFrames_MobileShapeshiftBarFrame_Reset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("ShapeshiftBarFrame", checked) end },
		PetActionBarFrame = { cosmos = "COS_MOBILE_FRAMES_PETACTIONBAR", reset = MobileFrames_MobilePetActionBarFrame_Reset, default = MobileFrames_EnabledByDefault, func = function(checked) MobileFrames_AnchorToggleEnableGeneral("PetActionBarFrame", checked) end },
	};
end

MobileFrames_MultiSpecialFrames = {
	MultiBarLeft = "SideMultiBars";
	MultiBarRight = "SideMultiBars";
	MultiBarBottomLeft = "BottomMultiBars";
	MultiBarBottomRight = "BottomMultiBars";
	PartyMemberFrame1 = "PartyMemberFrames";
	PartyMemberFrame2 = "PartyMemberFrames";
	PartyMemberFrame3 = "PartyMemberFrames";
	PartyMemberFrame4 = "PartyMemberFrames";
	ActionButton1 = "ActionButtons";
	CharacterMicroButton = "MicroButtons";
	MainMenuBarBackpackButton = "BackpackButtons";
	FramerateLabelMobileBar = "FramerateLabel";
	ContainerFrame1 = "Containers";
	ContainerFrame2 = "Containers";
	ContainerFrame3 = "Containers";
	ContainerFrame4 = "Containers";
	ContainerFrame5 = "Containers";
	ContainerFrame6 = "Containers";
	ContainerFrame7 = "Containers";
	ContainerFrame8 = "Containers";
	ContainerFrame9 = "Containers";
	ContainerFrame10 = "Containers";
	ContainerFrame11 = "Containers";
	ContainerFrame12 = "Containers";
	ContainerFrame13 = "Containers";
	ContainerFrame14 = "Containers";
	ContainerFrame15 = "Containers";
	ContainerFrame16 = "Containers";
	ContainerFrame17 = "Containers";
	GroupLootFrame1 = "GroupLootFrame";
};


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
	
	SlashCmdList["MOBILEFRAMESROLLSTACK"] = MobileFrames_ToggleRollStack;
	SLASH_MOBILEFRAMESROLLSTACK1 = "/mfrollstack";
	
	--manual hook for returning
	if (CloseWindows ~= SavedCloseWindows) then
        SavedCloseWindows = CloseWindows;
        CloseWindows = MobileFrames_CloseWindows;
    end
	
	Sea.util.hook( "ShowUIPanel", "MobileFrames_ShowUIPanel", "replace" );
	Sea.util.hook( "updateContainerFrameAnchors", "MobileFrames_updateContainerFrameAnchors", "replace" );
	Sea.util.hook( "PetActionBar_UpdatePosition", "MobileFrames_PetActionBar_UpdatePosition", "replace" );
	Sea.util.hook( "PetActionBarFrame_OnUpdate", "MobileFrames_PetActionBarFrame_OnUpdate", "replace" );
	
	--Sea.util.hook( "PetActionBarFrame.SetPoint", "MobileFrames_PetActionBarFrame_SetPoint", "after" );
	
	Sea.util.hook( "ShapeshiftBar_UpdatePosition", "MobileFrames_ShapeshiftBar_UpdatePosition", "replace" );
	Sea.util.hook( "UIParent_ManageRightSideFrames", "MobileFrames_UIParent_ManageRightSideFrames", "replace" );
	Sea.util.hook( "TicketStatusFrame_OnEvent", "MobileFrames_TicketStatusFrame_OnEvent", "replace" );
	Sea.util.hook( "CastingBarFrame_UpdatePosition", "MobileFrames_CastingBarFrame_UpdatePosition", "replace" );
	Sea.util.hook( "ToggleFramerate", "MobileFrames_ToggleFramerateMobileBar", "after" );
	
	Sea.util.hook("SetDoublewideFrame", "MobileFrames_SetDoublewideFrame", "replace");
	Sea.util.hook("SetLeftFrame", "MobileFrames_SetLeftFrame", "replace");
	Sea.util.hook("SetCenterFrame", "MobileFrames_SetCenterFrame", "replace");
	Sea.util.hook("MovePanelToLeft", "MobileFrames_MovePanelToLeft", "replace");
	Sea.util.hook("MovePanelToCenter", "MobileFrames_MovePanelToCenter", "replace");
	
	if (CosmosMaster_SyncVars) then
		Sea.util.hook("CosmosMaster_SyncVars", "MobileFrames_OffsetMarker_Hide", "after");
	end
	
	MobileFrames_WorldStateAlwaysUpFrame_SetupHooks();
	
	MobileFrames_DefineSpecialFrames();
	MobileFrames_UIParent_ManageRightSideFrames(true);
	
	--Cosmos Master Hack to stop checkbox syncing on okay.
	--CosmosMaster_Save = MobileFrames_CosmosMaster_Save;

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

function MobileFrames_ShowTooltip(barFrame, frameName)
	if (MobileFrames_Tooltip_Enabled) then
		MobileFramesTooltip:SetOwner(barFrame, "ANCHOR_CURSOR");
		MobileFramesTooltip:SetText(format(MOBILE_FRAMES_TOOLTIP_TEXT, GetReadableFrameName(frameName)));
	end
end

function MobileFrames_HideTooltip(barFrame)
	MobileFramesTooltip:Hide();
end

function MobileFrames_BarOnEnter(barFrame)
	MobileFrames_ShowTooltip(barFrame, barFrame:GetParent():GetName());
end

function MobileFrames_BarOnLeave(barFrame)
	MobileFrames_HideTooltip(barFrame);
end

function MobileFrames_BarOnMouseUp(barFrame)
	MobileFrames_BarStopDrag(barFrame);
end

function MobileFrames_BarOnMouseDown(barFrame)
	if (arg1 == "RightButton") and (IsShiftKeyDown()) then
		MobileFramesDropDown.displayMode = "MENU";
		ToggleDropDownMenu(1, barFrame:GetParent():GetName(), MobileFramesDropDown, barFrame:GetName());
	else
		MobileFrames_BarStartDrag(barFrame);
	end
end

function MobileFrames_BarOnHide(barFrame)
	MobileFrames_BarStopDrag(barFrame);
	MobileFrames_RemoveFromVisibleList(barFrame:GetParent():GetName());
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
		frame.isReset = nil;
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
		if (PopNUI_UIParent_ManageRightSideFrames) then
			Sea.util.unhook("UIParent_ManageRightSideFrames", "PopNUI_UIParent_ManageRightSideFrames", "after");
		end
		if (Eclipse) then
			if (Eclipse.UIParent_ManageRightSideFrames) then
				Sea.util.unhook("UIParent_ManageRightSideFrames", "Eclipse.UIParent_ManageRightSideFrames", "after");
			end
			if (Eclipse.ShapeshiftBar_UpdatePosition) then
				Sea.util.unhook("ShapeshiftBar_UpdatePosition", "Eclipse.ShapeshiftBar_UpdatePosition", "replace");
			end
			if (Eclipse.PetActionBar_UpdatePosition) then
				Sea.util.unhook("PetActionBar_UpdatePosition", "Eclipse.PetActionBar_UpdatePosition", "after");
			end
		end
		
		--define enable/disable functions for all loaded frames
		table.foreach(MobileFrames_MasterEnableList, function(frameName) MobileFrames_EnableToggle[frameName] = function(checked) MobileFrames_ToggleEnableGeneral(frameName, checked); end; end);
		--define reset functions for all loaded frames
		table.foreach(MobileFrames_MasterEnableList, function(frameName) MobileFrames_ResetFrame[frameName] = function() MobileFrames_Reset(frameName); end; end);
		
		if (not MobileFrames_ContainerPositionsByID) then
			MobileFrames_ContainerPositionsByID = {};
		end
		
		--Update Bar Graphics
		MobileFrames_ShapeshiftBar_UpdatePosition();
		--MobileFrames_PetActionBar_UpdatePosition();
		
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
		
		--this and the previous if arn't mutually exclusive (Ex: had MFs and just added cosmos, khaos)
		if ( Khaos ) then 
			local optionSet = {
					id="MobileFrames";
					text=MOBILE_FRAMES_HEADER;
					helptext=MOBILE_FRAMES_HEADER_INFO;
					difficulty=1;
					options={
						{
							id="Header";
							text=MOBILE_FRAMES_HEADER;
							helptext=MOBILE_FRAMES_HEADER_INFO;
							type=K_HEADER;
							difficulty=1;
						};
						{
							id="EnableAll";
							type=K_BUTTON;
							text=MOBILE_FRAMES_ENABLE_ALL_TEXT;
							helptext=MOBILE_FRAMES_ENABLE_ALL_TEXT_INFO;
							callback=function()MobileFrames_Enable("")end;
							setup={buttonText=ENABLE_ALL};
						};
						{
							id="DisableAll";
							type=K_BUTTON;
							text=MOBILE_FRAMES_DISABLE_ALL_TEXT;
							helptext=MOBILE_FRAMES_DISABLE_ALL_TEXT_INFO;
							callback=function()MobileFrames_Disable("")end;
							setup={buttonText=DISABLE_ALL};
						};
						{
							id="ResetAll";
							type=K_BUTTON;
							text=MOBILE_FRAMES_RESET_ALL_TEXT;
							helptext=MOBILE_FRAMES_RESET_ALL_TEXT_INFO;
							callback=function()MobileFrames_Reset("")end;
							setup={buttonText=RESET_ALL};
						};
						{
							id="ToggleAnchors";
							type=K_BUTTON;
							text=MOBILE_FRAMES_TOGGLEANCHORS;
							helptext=MOBILE_FRAMES_TOGGLEANCHORS_INFO;
							callback=MobileFrames_ToggleAnchors;
							setup={buttonText=MOBILE_FRAMES_TOGGLEANCHORS};
						};
						{
							id="EnableSound";
							type=K_TEXT;
							text=MOBILE_FRAMES_ENABLE_SOUND;
							helptext=MOBILE_FRAMES_ENABLE_SOUND_INFO;
							callback=function(state)MobileFrames_AnchorsSoundOn=state.checked; end;
							feedback=function(state)
								if ( state.checked ) then 
									return "Will play a splashing noise when frames a locked.";
								else
									return "Will not play sounds for mobile frames.";
								end;
							end;
							check=true;
							default={checked=true};
							disabled={checked=false};
						};
						{
							id="DownwardsRollWindowStacking";
							type=K_TEXT;
							text=MOBILE_FRAMES_DOWN_ROLL_STACK;
							helptext=MOBILE_FRAMES_DOWN_ROLL_STACK_INFO;
							callback=function(state)
								if ( state.checked ) then
									MobileFrames_SetDownwardRollWindowStack(1);
								else
									MobileFrames_SetDownwardRollWindowStack(0);
								end
							end;
							feedback=function(state)
								if ( state.checked ) then 
									return "GroupLootFrames 2-4 will now stack downwards instead of upwards.";
								else
									return "GroupLootFrames 2-4 will now stack upwards (default).";
								end;
							end;
							check=true;
							default={checked=false};
							disabled={checked=false};
						};
						{
							id="SetContainerOffset";
							type=K_SLIDER;
							text=MOBILE_FRAMES_SET_CONTAINERS_OFFSET;
							helptext=MOBILE_FRAMES_SET_CONTAINERS_OFFSET_INFO;
							callback=function(state)
								if ( state.checked ) then 
									MobileFrames_SetContainerOffset(1,state.slider);
								else
									MobileFrames_SetContainerOffset();
								end
							end;
							feedback=function(state)
								if ( state.checked ) then 
									MobileFrames_ContainerOffsetMarker_Show();
									return "Will offset your bags by "..state.slider.." pixels.";
								else
									return "Will not offset your bags.";
								end;
							end;
							check=true;
							default={checked=false;slider=CONTAINER_OFFSET_X};
							disabled={checked=false;slider=CONTAINER_OFFSET_X};
							dependencies={SetContainerOffset={checked=true;match=true}};
							setup={
								sliderStep=5;
								sliderText=OFFSET;
								sliderMin=0;
								sliderMax=200;
							};
						};
						{
							id="SetUIPanelOffset";
							type=K_SLIDER;
							text=MOBILE_FRAMES_SET_UIPANEL_OFFSET;
							helptext=MOBILE_FRAMES_SET_UIPANEL_OFFSET_INFO;
							callback=function(state)
								if ( state.checked ) then 
									MobileFrames_SetUIPanelOffsetLeft(1,state.slider);
								else
									MobileFrames_SetUIPanelOffsetLeft(0,state.slider);
								end
							end;
							feedback=function(state)
								if ( state.checked ) then 
									MobileFrames_UIPanelOffsetMarker_Show();
									return "Will offset the UIPanel by "..state.slider.." pixels.";
								else
									return "Will not offset the UIPanel.";
								end;
							end;
							check=true;
							default={checked=false;slider=0};
							disabled={checked=false;slider=0};
							dependencies={SetUIPanelOffset={checked=true;match=true}};
							setup={
								sliderStep=5;
								sliderText=OFFSET;
								sliderMin=0;
								sliderMax=200;
							};
						};
						{
							id="RegularHeader";
							type=K_HEADER;
							text=MOBILE_FRAMES_REGULAR_OPTIONS_HEADER;
							helptext=MOBILE_FRAMES_REGULAR_OPTIONS_HEADER_INFO;
						};
					};
				};
			local alphList = Sea.table.getKeyList(MobileFrames_MasterEnableList);
			table.sort(alphList);
			for index, frameName in alphList do
				local enabled = MobileFrames_MasterEnableList[frameName]
				if (not MobileFrames_SpecialFrames[frameName]) and (not MobileFrames_MultiSpecialFrames[frameName]) then
					local frameName2 = frameName;
					table.insert(optionSet.options, 
						{
							id="Enable"..frameName;
							type=K_TEXT;
							check=true;
							text=string.format(MOBILE_FRAMES_ENABLE_TEXT,GetReadableFrameName(frameName));
							helptext=string.format(MOBILE_FRAMES_ENABLE_TEXT_INFO,GetReadableFrameName(frameName));
							callback=function(state)
								if (state.checked) then 
									MobileFrames_EnableToggle[frameName2](1);
								else
									MobileFrames_EnableToggle[frameName2](0);
								end
							end;
							feedback=function(state)
								if ( state.checked ) then 
									return frameName2.." can be moved around.";
								else
									return frameName2.." cannot be moved anymore.";
								end;
							end;
							default={
								checked=MobileFrames_MasterEnableList[frameName];
							};
							disabled={
								checked=false;
							};
						}
					);
					table.insert(optionSet.options, 
						{
							id="Reset"..frameName;
							type=K_BUTTON;
							text=string.format(MOBILE_FRAMES_RESET_TEXT,GetReadableFrameName(frameName));
							helptext=string.format(MOBILE_FRAMES_RESET_TEXT_INFO,GetReadableFrameName(frameName));
							callback=MobileFrames_ResetFrame[frameName];
							setup={buttonText=RESET};
						}
					);
				end
			end
				
			table.insert(optionSet.options, 
				{
					id="SpecialSectionHeader";
					type=K_HEADER;
					text=MOBILE_FRAMES_SPECIAL_HEADER;
					helptext=MOBILE_FRAMES_SPECIAL_HEADER_INFO;
					difficulty=2;
				}
			);
			
			local alphList = Sea.table.getKeyList(MobileFrames_SpecialFrames);
			table.sort(alphList);
			for index, varPrefix in alphList do
				local data = MobileFrames_SpecialFrames[varPrefix]
				frameReadable  = GetReadableFrameName(varPrefix);
				local f = data.func;
				table.insert(optionSet.options,
					{
						id="EnableSpecial"..varPrefix;
						text=format(MOBILE_FRAMES_ENABLE_TEXT, frameReadable);
						helptext=format(MOBILE_FRAMES_ENABLE_TEXT_INFO, frameReadable);
						difficulty=2;
						type=K_TEXT;
						check=true;
						callback=function(state)
							if ( state.checked ) then 
								f(1);		
							else
								f(0);
							end
						end;
						feedback=function(state)
							if ( state.checked ) then 
								return frameReadable.." can be moved with the mouse.";
							else
								return frameReadable.." cannot be moved around.";
							end;
						end;
						default={checked=data.default;};
						disabled={checked=false};
					}
				);

				local r = data.reset;
				table.insert(optionSet.options,
					{
						id="ResetSpecial"..frameReadable;
						text=format(MOBILE_FRAMES_RESET_TEXT, frameReadable);
						helptext=format(MOBILE_FRAMES_RESET_TEXT_INFO, frameReadable);
						difficulty=2;
						type=K_BUTTON;
						callback=r;
						setup={buttonText=RESET};
					}
				);
			end			
			Khaos.registerOptionSet(
				"frames",
				optionSet
			);
		elseif (Cosmos_RegisterConfiguration) then
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
			
			--Toggle Anchor button
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_TOGGLEANCHORS",	-- CVar
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
			
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_ENABLE_SOUND",   --CVar
				"CHECKBOX",							--Things to use
				TEXT(MOBILE_FRAMES_ENABLE_SOUND),
				TEXT(MOBILE_FRAMES_ENABLE_SOUND_INFO),
				MobileFrames_EnableAnchorSound,		--Callback
				1									--Default Checked/Unchecked
			);
			
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_DOWN_ROLL_STACK",   --CVar
				"CHECKBOX",							--Things to use
				TEXT(MOBILE_FRAMES_DOWN_ROLL_STACK),
				TEXT(MOBILE_FRAMES_DOWN_ROLL_STACK_INFO),
				MobileFrames_SetDownwardRollWindowStack,		--Callback
				0									--Default Checked/Unchecked
			);
			
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_SET_CONTAINERS_OFFSET",		-- CVar
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
			
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_SET_UIPANEL_OFFSET",			-- CVar
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
			
			Cosmos_RegisterConfiguration(
				"COS_MOBILE_FRAMES_REGULAR_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_REGULAR_OPTIONS_HEADER,
				MOBILE_FRAMES_REGULAR_OPTIONS_HEADER_INFO
			);
			
			--register each frame with cosmos config
			local alphList = Sea.table.getKeyList(MobileFrames_MasterEnableList);
			table.sort(alphList);
			for index, frameName in alphList do
				local enabled = MobileFrames_MasterEnableList[frameName]
				if (not MobileFrames_SpecialFrames[frameName]) and (not MobileFrames_MultiSpecialFrames[frameName]) then
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
			end
			
			Cosmos_RegisterConfiguration("COS_MOBILE_FRAMES_SPECIAL_SECTION",
				"SEPARATOR",
				MOBILE_FRAMES_SPECIAL_HEADER,
				MOBILE_FRAMES_SPECIAL_HEADER_INFO
			);
			
			local alphList = Sea.table.getKeyList(MobileFrames_SpecialFrames);
			table.sort(alphList);
			for index, varPrefix in alphList do
				
				local data = MobileFrames_SpecialFrames[varPrefix]
				frameReadable  = GetReadableFrameName(varPrefix);
				--frameCaps = string.upper(varPrefix);
				
				--register this frame with cosmos config
				--enable checkbox
				Cosmos_RegisterConfiguration(data.cosmos,		-- registered name
					"CHECKBOX",											-- register type
					format(MOBILE_FRAMES_ENABLE_TEXT, frameReadable),		-- short description
					format(MOBILE_FRAMES_ENABLE_TEXT_INFO, frameReadable),  -- long description
					data.func,				-- function
					data.default			-- default value
				);
				
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

		else
			--save enabled values if not using cosmos
			RegisterForSave("MobileFrames_SavedEnableList");
			RegisterForSave("MobileFrames_SavedAnchorEnableList");
			RegisterForSave("UIPANEL_OFFSET_LEFT");
			RegisterForSave("CONTAINER_OFFSET_X_SET");
			--restore saved enable states
			local checked;
			if (MobileFrames_SavedEnableList) then
				for frameName, enabled in MobileFrames_SavedEnableList do
					if (enabled) then
						checked = 1;
					else
						checked = 0;
					end
					if (type(MobileFrames_SpecialFrames[frameName]) == "table") then
						MobileFrames_SpecialFrames[frameName].func(checked);
						--Sea.io.print(frameName.." enable set to "..checked);
					elseif (MobileFrames_MasterEnableList[frameName] ~= nil) then
						MobileFrames_EnableToggle[frameName](checked);
						--Sea.io.print(frameName.." enable set to "..checked);
					end
				end
			end
			if (MobileFrames_SavedAnchorEnableList) then
				for frameName, enabled in MobileFrames_SavedAnchorEnableList do
					if (enabled) then
						checked = 1;
					else
						checked = 0;
					end
					if (type(MobileFrames_SpecialFrames[frameName]) == "table") then
						MobileFrames_SpecialFrames[frameName].func(checked);
						--Sea.io.print(frameName.." enable set to "..checked);
					elseif (type(MobileFrames_SpecialFrames[MobileFrames_MultiSpecialFrames[frameName]]) == "table") then
						MobileFrames_SpecialFrames[MobileFrames_MultiSpecialFrames[frameName]].func(checked);
						--Sea.io.print(MobileFrames_MultiSpecialFrames[frameName].." enable set to "..checked);
					end
				end
			end
			MobileFrames_SavedEnableList = MobileFrames_MasterEnableList;
			MobileFrames_SavedAnchorEnableList = MobileFrames_MasterAnchorEnableList;
			if (MobileFrames_MobileContainers ~= nil) then
				if (MobileFrames_MobileContainers) then
					checked = 1;
				else
					checked = 0;
				end
				MobileFrames_EnableMobileContainers(checked);
				--Sea.io.print("Bags enable set to "..checked);
			end
			if (MobileFrames_RollStackDown) then
				MobileFrames_SetDownwardRollWindowStack(1);
			end
		end
		
		if (EarthFeature_AddButton) then 
			EarthFeature_AddButton(
				{
					id="ToggleMobileAnchors";
					name=TEXT(MOBILE_FRAMES_TOGGLEANCHORS);
					tooltip=TEXT(MOBILE_FRAMES_TOGGLEANCHORS_INFO);
					icon="Interface\\AddOns\\MobileFrames\\Skin\\Anchor";
					callback=MobileFrames_ToggleAnchors;
				}
			);
		elseif(Cosmos_RegisterButton) then
			Cosmos_RegisterButton ( 
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
	local isSpecialFrame = (type(MobileFrames_SpecialFrames[frameName]) == "table");
	if not MobileFrames_MasterEnableList[frameName] then
		if (not isSpecialFrame) then
			MobileFrames_UIPanel_RemoveFrameRepositionIgnore(frameName);
		end
		if (getglobal(frameName.."MobileBar")) then	
			getglobal(frameName.."MobileBar"):EnableMouse(0);
		end
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameName));
		end
	else
		if (not isSpecialFrame) then
			MobileFrames_UIPanel_AddFrameRepositionIgnore(frameName);
		end
		if (getglobal(frameName.."MobileBar")) then
			getglobal(frameName.."MobileBar"):EnableMouse(1);
		end
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
	getglobal(frameName):SetUserPlaced(false);
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
	local frameReadable;
	local alphList = Sea.table.getKeyList(MobileFrames_SpecialFrames);
	local templist = Sea.table.getKeyList(MobileFrames_MasterEnableList);
	for index, frameName in templist do
		if (not MobileFrames_SpecialFrames[frameName]) then
			table.insert(alphList, frameName);
		end
	end
	table.sort(alphList);
	
	for index, frameName in alphList do
		frameReadable  = GetReadableFrameName(frameName);
		if (frameReadable) then
			Sea.IO.print(frameName.." = "..frameReadable);
		else
			Sea.IO.print(frameName);
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
	if (type(msg) == "string") then
		local frameName = string.upper(msg)
	end
	local found;
	local enableAll;
	local redrawCosmos;
	local frameReadable = "";
	if (msg == "") or (not msg) or (msg == 0) then
		enableAll = true;
	end
	
	for varPrefix, data in MobileFrames_SpecialFrames do
		frameReadable  = GetReadableFrameName(varPrefix);
		if (enableAll) or (frameName == string.upper(varPrefix)) or (frameName == string.upper(frameReadable)) then
			data.func(1);
			if (Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue(data.cosmos, CSM_CHECKONOFF, 1);
				Cosmos_SetCVar(data.cosmos.."_X", 1);
				redrawCosmos = true;
			end
			if (Khaos) then
				if (Khaos.getSetKey("MobileFrames","EnableSpecial"..varPrefix)) then
					Khaos.setSetKeyParameter("MobileFrames","EnableSpecial"..varPrefix, "checked", true);
				end
				redrawCosmos = true;
			end
			if (not enableAll) then
				Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameReadable));
			end
		end
	end
	
	for index, value in MobileFrames_MasterEnableList do
		frameReadable  = GetReadableFrameName(index);
		if (enableAll) or (frameName == string.upper(index)) or (frameName == string.upper(frameReadable)) then
			found = 1;
			MobileFrames_EnableToggle[index](1);
			if (Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_MOBILE_FRAMES_ENABLE_"..string.upper(index), CSM_CHECKONOFF, 1);
				Cosmos_SetCVar("COS_MOBILE_FRAMES_ENABLE_"..string.upper(index).."_X", 1);
				redrawCosmos = true;
			end
			if (Khaos) then
				if (Khaos.getSetKey("MobileFrames","Enable"..index)) then
					Khaos.setSetKeyParameter("MobileFrames","Enable"..index, "checked", true);
				end
				redrawCosmos = true;
			end
			if not enableAll then
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
	if (Khaos) then
		if KhaosFrame:IsVisible() and (redrawCosmos) then
			Khaos.refresh(false, false, true);
		end
	end
	if enableAll then
		Sea.IO.print(MOBILE_FRAMES_ENABLED_ALL_TEXT);
	end
end


function MobileFrames_Disable(msg)
	-- Raise it to upper case for comparison purposes.
	if (type(msg) == "string") then
		local frameName = string.upper(msg)
	end
	local found;
	local disableAll;
	local redrawCosmos;
	local frameReadable = "";
	if (msg == "") or (not msg) or (msg == 0) then
		disableAll = true;
	end
	
	for varPrefix, data in MobileFrames_SpecialFrames do
		frameReadable  = GetReadableFrameName(varPrefix);
		if (disableAll) or (frameName == string.upper(varPrefix)) or (frameName == string.upper(frameReadable)) then
			data.func(0);
			if (Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue(data.cosmos, CSM_CHECKONOFF, 0);
				Cosmos_SetCVar(data.cosmos.."_X", 1);
				redrawCosmos = true;
			end
			if (Khaos) then
				if (Khaos.getSetKey("MobileFrames","EnableSpecial"..varPrefix)) then
					Khaos.setSetKeyParameter("MobileFrames","EnableSpecial"..varPrefix, "checked", false);
				end
				redrawCosmos = true;
			end
			if (not disableAll) then
				Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameReadable));
			end
		end
	end
	
	for index, value in MobileFrames_MasterEnableList do
		frameReadable  = GetReadableFrameName(index);
		if (disableAll) or (frameName == string.upper(index)) or (frameName == string.upper(frameReadable)) then
			found = 1;
			MobileFrames_EnableToggle[index](0);
			if (Cosmos_RegisterConfiguration) then
				Cosmos_UpdateValue("COS_MOBILE_FRAMES_ENABLE_"..string.upper(index), CSM_CHECKONOFF, 0);
				Cosmos_SetCVar("COS_MOBILE_FRAMES_ENABLE_"..string.upper(index).."_X", 0);
				redrawCosmos = true;
			end
			if (Khaos) then
				if (Khaos.getSetKey("MobileFrames","Enable"..index)) then
					Khaos.setSetKeyParameter("MobileFrames","Enable"..index, "checked", false);
				end
				redrawCosmos = true;
			end
			if not disableAll then
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
	if (Khaos) then
		if KhaosFrame:IsVisible() and (redrawCosmos) then
			Khaos.refresh(false, false, true);
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
		frameReadable  = GetReadableFrameName(varPrefix);
		if (resetAll) or (frameName == string.upper(varPrefix)) or (frameName == string.upper(frameReadable)) then
			data.reset();
			if (not resetAll) then
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
		frameReadable  = GetReadableFrameName(index);
		if (resetAll) or (frameName == string.upper(index)) or (frameName == string.upper(frameReadable)) then
			found = 1;
			MobileFrames_UIPanel_RemoveFrameRepositionIgnore(index);
			if getglobal(index):IsVisible() then
				getglobal(index):Hide();
			end
			if not resetAll then 
				ShowUIPanel(getglobal(index));
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
	local redrawCosmos;
	msg = string.upper(msg);
	local startpos, endpos, option, value = string.find(msg, "(%w+) (%d+)");
	value = tonumber(value);
	if (option) and (value) then
		if (value >= 0) and (value <= 200) then
			if (option == "REGULAR") then
				MobileFrames_SetUIPanelOffsetLeft(1, value);
				Sea.IO.print(MOBILE_FRAMES_SET_UIPANEL_OFFSET..": "..value);
				if (Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue("COS_MOBILE_FRAMES_SET_UIPANEL_OFFSET", CSM_CHECKONOFF, 1);
					Cosmos_SetCVar("COS_MOBILE_FRAMES_SET_UIPANEL_OFFSET_X", 1);
					Cosmos_UpdateValue("COS_MOBILE_FRAMES_SET_UIPANEL_OFFSET", CSM_SLIDERVALUE, value);
					Cosmos_SetCVar("COS_MOBILE_FRAMES_SET_UIPANEL_OFFSET", value);
					redrawCosmos = true;
				end
				if (Khaos) then
					Khaos.setSetKeyParameter("MobileFrames","SetUIPanelOffset", "checked", true);
					Khaos.setSetKeyParameter("MobileFrames","SetUIPanelOffset", "slider", value);
					redrawCosmos = true;
				end
			elseif (option == "CONTAINERS") or (option == string.upper(GetReadableFrameName("Containers"))) then
				MobileFrames_SetContainerOffset(1, value);
				Sea.IO.print(MOBILE_FRAMES_SET_CONTAINERS_OFFSET..": "..value);
				if (Cosmos_RegisterConfiguration) then
					Cosmos_UpdateValue("COS_MOBILE_FRAMES_SET_CONTAINERS_OFFSET", CSM_CHECKONOFF, 1);
					Cosmos_SetCVar("COS_MOBILE_FRAMES_SET_CONTAINERS_OFFSET_X", 1);
					Cosmos_UpdateValue("COS_MOBILE_FRAMES_SET_CONTAINERS_OFFSET", CSM_SLIDERVALUE, value);
					Cosmos_SetCVar("COS_MOBILE_FRAMES_SET_CONTAINERS_OFFSET", value);
					redrawCosmos = true;
				end
				if (Khaos) then
					Khaos.setSetKeyParameter("MobileFrames","SetContainerOffset", "checked", true);
					Khaos.setSetKeyParameter("MobileFrames","SetContainerOffset", "slider", value);
					redrawCosmos = true;
				end
			end
		end
	end
	if (Cosmos_RegisterConfiguration) then
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) and (redrawCosmos) then
			CosmosMaster_DrawData();
		end
	end
	if (Khaos) then
		if KhaosFrame:IsVisible() and (redrawCosmos) then
			Khaos.refresh(false, false, true);
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


--Cosmos Master Hack to stop checkbox syncing on okay.
function MobileFrames_CosmosMaster_Save()
	CosmosMaster_StoreVariables();
	RegisterForSave('CosmosMaster_CVars');
end

function GetReadableFrameName(frameName)
	--makes the frame name readble and localizable
	if (MobileFrames_MultiSpecialFrames[frameName]) then
		frameName = MobileFrames_MultiSpecialFrames[frameName]
	end
	local frameReadable = MOBILE_FRAMES_FRAMEDESCRIPTIONS[frameName];
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
	local bag;
	for i=1, 17 do
		bag = getglobal("ContainerFrame"..i);
		if bag:IsVisible() then
			bag:Hide();
		end
		bag:SetUserPlaced(false);
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

function MobileFrames_Anchor_OnMouseUp(anchorFrame)
	MobileFrames_BarStopDrag(anchorFrame);
end

function MobileFrames_Anchor_OnMouseDown(anchorFrame)
	if (arg1 == "RightButton") and (IsShiftKeyDown()) then
		MobileFramesDropDown.displayMode = "MENU";
		ToggleDropDownMenu(1, anchorFrame:GetParent():GetName(), MobileFramesDropDown, anchorFrame:GetName());
	else
		MobileFrames_BarStartDrag(this);
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
	
	if (Cosmos_RegisterConfiguration) then
		local onOff;
		if (MobileFrames_AnchorsSoundOn) then
			onOff = 1;
		else
			onOff = 0;
		end
		Cosmos_UpdateValue("COS_MOBILE_FRAMES_ENABLE_SOUND", CSM_CHECKONOFF, onOff);
		Cosmos_SetCVar("COS_MOBILE_FRAMES_ENABLE_SOUND_X", onOff);
		if CosmosMasterFrame:IsVisible() and (not CosmosMasterFrame_IsLoading) then
			CosmosMaster_DrawData();
		end
	elseif (Khaos) then
		local onOff;
		if (MobileFrames_AnchorsSoundOn) then
			onOff = true;
		else
			onOff = false;
		end
		Khaos.updateSetKeys("MobileFrames",{EnableSound={checked=onOff}})
		if KhaosFrame:IsVisible() then
			Khaos.refresh(false, false, true);
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
	local frame;
	for i=1, 4 do
		frame = getglobal("PartyMemberFrame"..i);
		if ( frame.isMoving ) then
			frame:StopMovingOrSizing();
			frame.isMoving = false;
			wasMoving = true;
		end
		frame:SetUserPlaced(false);
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
		PlayerFrame:SetUserPlaced(false);
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
		TargetFrame:SetUserPlaced(false);
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
		PetFrame:SetUserPlaced(false);
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
		MultiBarBottomLeft.isReset = true;
		MultiBarBottomLeft:SetUserPlaced(false);
		MultiBarBottomRight:ClearAllPoints();
		MultiBarBottomRight:SetPoint("LEFT", "MultiBarBottomLeft", "RIGHT", 10, 0);
		MultiBarBottomRight.isReset = true;
		MultiBarBottomRight:SetUserPlaced(false);
		MobileFrames_ShapeshiftBar_UpdatePosition();
		MobileFrames_PetActionBar_UpdatePosition();
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
		MultiBarRight:SetUserPlaced(false);
		MultiBarLeft:ClearAllPoints();
		MultiBarLeft:SetPoint("TOPRIGHT", "MultiBarRight", "TOPLEFT", -5, 0);
		MultiBarLeft:SetUserPlaced(false);
	end
end

function MobileFrames_ResetMobileMinimapCluster()
	if ( MinimapCluster.isMoving ) then
		MinimapCluster:StopMovingOrSizing();
		MinimapCluster.isMoving = false;
	else
		MinimapCluster:ClearAllPoints();
		MinimapCluster:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", 0, 0);
		MinimapCluster:SetUserPlaced(false);
	end
end

function MobileFrames_ResetMobileBuffFrame()
	if ( TemporaryEnchantFrame.isMoving ) then
		TemporaryEnchantFrame:StopMovingOrSizing();
		TemporaryEnchantFrame.isMoving = false;
	else
		TemporaryEnchantFrame:ClearAllPoints();
		if (TicketStatusFrame:IsVisible()) then
			TemporaryEnchantFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -205, (-TicketStatusFrame:GetHeight()));
		else
			TemporaryEnchantFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -205, -13);
		end
		TemporaryEnchantFrame:SetUserPlaced(false);
	end
end

function MobileFrames_ResetTicketStatusFrame()
	if ( TicketStatusFrame.isMoving ) then
		TicketStatusFrame:StopMovingOrSizing();
		TicketStatusFrame.isMoving = false;
	else
		TicketStatusFrame:ClearAllPoints();
		TicketStatusFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -180, 0);
		TicketStatusFrame:SetUserPlaced(false);
	end
end

function MobileFrames_WorldStateScoreFrameReset()
	if ( WorldStateScoreFrame.isMoving ) then
		WorldStateScoreFrame:StopMovingOrSizing();
		WorldStateScoreFrame.isMoving = false;
	else
		WorldStateScoreFrame:ClearAllPoints();
		WorldStateScoreFrame:SetPoint("CENTER", "UIParent", "CENTER", 55, 0);
		WorldStateScoreFrame:SetUserPlaced(false);
	end
end

-- <= == == == == == == == == == == == == =>
-- => Pet/Shapeshift/Aura Bar Position Update
-- <= == == == == == == == == == == == == =>

function MobileFrames_PetActionBar_UpdatePosition()
	if (PetActionBarFrame:IsUserPlaced()) then
		SlidingActionBarTexture0:Hide();
		SlidingActionBarTexture1:Hide();
		return;
	end
	if (MultiBarBottomLeft.isShowing) and (not MultiBarBottomLeft:IsUserPlaced()) then
		PETACTIONBAR_YPOS = 141;
		SlidingActionBarTexture0:Hide();
		SlidingActionBarTexture1:Hide();
	else
		PETACTIONBAR_YPOS = 98;
		SlidingActionBarTexture0:Show();
		SlidingActionBarTexture1:Show();
	end
	if (not PetActionBarFrame:IsVisible()) and (not PetHasActionBar()) then
		return;
	end
	PetActionBarFrame:ClearAllPoints();
	PetActionBarFrame:SetPoint("TOPLEFT", "MainMenuBar", "BOTTOMLEFT", PETACTIONBAR_XPOS, PETACTIONBAR_YPOS);
	PetActionBarFrame:SetUserPlaced(false);
end

function MobileFrames_PetActionBarFrame_OnUpdate()
	if (not PetActionBarFrame:IsUserPlaced()) then
		return true;
	end
end

function MobileFrames_PetActionBarFrame_SetPoint(frame, point, parent, refpoint, x, y)
	Sea.io.print("MobileFrames_PetActionBarFrame_SetPoint", point, ", ", parent, ", ",  refpoint, ", ",  x, ", ",  y);
	if (type(frame) == "table") then
		Sea.io.print("Frame: ", frame:GetName());
	else
		Sea.io.print("Frame: ", frame);
	end
end

function MobileFrames_ShapeshiftBar_UpdatePosition()
	if (ShapeshiftBarFrame:IsUserPlaced()) then
		ShapeshiftBarLeft:Hide();
		ShapeshiftBarRight:Hide();
		ShapeshiftBarMiddle:Hide();
		return;
	end
	if (MultiBarBottomLeft.isShowing) and (not MultiBarBottomLeft:IsUserPlaced()) then
		ShapeshiftBarFrame:ClearAllPoints();
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 45);
		ShapeshiftBarLeft:Hide();
		ShapeshiftBarRight:Hide();
		ShapeshiftBarMiddle:Hide();
	else
		ShapeshiftBarFrame:ClearAllPoints();
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
		if ( GetNumShapeshiftForms() > 2 ) then
			ShapeshiftBarMiddle:Show();
		end
		ShapeshiftBarLeft:Show();
		ShapeshiftBarRight:Show();
	end
	ShapeshiftBarFrame:SetUserPlaced(false);
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

function MobileFrames_UIParent_ManageRightSideFrames(setQWFPoint, setDFPoint, setGLFPoint)
	local anchorX = 0;
	local anchorY = 0;
	
	-- Update group loot frame anchor
	if (setGLFPoint) or (MobileFrames_RightSide_FrameRepositionIsBeingIgnored("GroupLootFrame1")) then
		GroupLootFrame1:ClearAllPoints();
		if ( MultiBarBottomRight:IsVisible() or MultiBarBottomLeft:IsVisible() ) then
			GroupLootFrame1:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 102);
		else
			GroupLootFrame1:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60);
		end
		GroupLootFrame1:SetUserPlaced(false);
		MobileFrames_RightSide_AddFrameRepositionIgnore("GroupLootFrame1");
	end
	
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
	elseif (Eclipse) and (Eclipse.UIParent_ManageRightSideFrames) then
		Eclipse.UIParent_ManageRightSideFrames();
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
	elseif (Eclipse) and (Eclipse.UIParent_ManageRightSideFrames) then
		Eclipse.UIParent_ManageRightSideFrames();
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
		DurabilityFrame:SetUserPlaced(false);
		MobileFrames_RightSide_AddFrameRepositionIgnore("DurabilityFrame");
	end
	if (MobileFrames_RightSide_FrameRepositionIsBeingIgnored("DurabilityFrame")) and (DurabilityFrame:IsVisible()) then
		anchorY = anchorY - DurabilityFrame:GetHeight();
	end
	if (setQWFPoint) or (MobileFrames_RightSide_FrameRepositionIsBeingIgnored("QuestWatchFrame")) then
		QuestWatchFrame:ClearAllPoints();
		QuestWatchFrame:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -anchorX, anchorY);
		if (QuestWatchFrame:IsMovable()) then
			QuestWatchFrame:SetUserPlaced(false);
		end
		MobileFrames_RightSide_AddFrameRepositionIgnore("QuestWatchFrame");
	end
end

function MobileFrames_SetContainerOffset(checked, value)
	CONTAINER_OFFSET_X_SET = nil;
	if (type(value) == "number") and (checked == 1) then
		if (value >= 0) then
			CONTAINER_OFFSET_X_SET = value;
			if (not Khaos) then
				MobileFrames_ContainerOffsetMarker_Show();
			end
		end
	end
end

function MobileFrames_ContainerOffsetMarker_Show()
	if (type(CONTAINER_OFFSET_X_SET) == "number") then
		MobileOffsetMarker:ClearAllPoints();
		MobileOffsetMarker:SetPoint("CENTER", "UIParent", "RIGHT", -CONTAINER_OFFSET_X_SET, 0);
		MobileOffsetMarker:Show();
		MobileFrames_OffsetMarker_Fade();
	end
end

function MobileFrames_SetUIPanelOffsetLeft(checked, value)
	UIPANEL_OFFSET_LEFT = 0;
	if (type(value) == "number") and (checked == 1) then
		if (value >= 0) then
			UIPANEL_OFFSET_LEFT = value;
			if (not Khaos) then
				MobileFrames_UIPanelOffsetMarker_Show();
			end
		end
	end
end

function MobileFrames_UIPanelOffsetMarker_Show()
	if (type(UIPANEL_OFFSET_LEFT) == "number") then
		MobileOffsetMarker:ClearAllPoints();
		MobileOffsetMarker:SetPoint("CENTER", "UIParent", "LEFT", UIPANEL_OFFSET_LEFT, 0);
		MobileOffsetMarker:Show();
		MobileFrames_OffsetMarker_Fade();
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
				FramerateLabelMobileBar:SetUserPlaced(false);
			end
		else
			bottom = math.abs(104 - FramerateLabelMobileBar:GetBottom());
			if (not passive) or (bottom <= 4 and center <= 4) then
				FramerateLabelMobileBar:ClearAllPoints();
				FramerateLabelMobileBar:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 0, 64);
				FramerateLabelMobileBar:SetUserPlaced(false);
			end
		end
	end
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Buffs Reposition Override
-- <= == == == == == == == == == == == == =>

function MobileFrames_TicketStatusFrame_OnEvent()
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		GetGMTicket();
	else
		if ( arg1 ~= 0 ) then		
			this:Show();
			if (false) then -- Fix when they add user repositioned
				TemporaryEnchantFrame:SetPoint("TOPRIGHT", this:GetParent():GetName(), "TOPRIGHT", -205, (-this:GetHeight()));
			end
			refreshTime = GMTICKET_CHECK_INTERVAL;
		else
			this:Hide();
			if (false) then -- Fix when they add user repositioned
				TemporaryEnchantFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -180, -13);
			end
		end
	end	
end

-- <= == == == == == == == == == == == == =>
-- => Mobile GroupLootFrame Stacking
-- <= == == == == == == == == == == == == =>

function MobileFrames_ToggleRollStack()

	if (MobileFrames_RollStackDown) then
		MobileFrames_RollStackDown = nil;
		MobileFrames_SetDownwardRollWindowStack(0);
	else
		MobileFrames_RollStackDown = true;
		MobileFrames_SetDownwardRollWindowStack(1);
	end

end

function MobileFrames_SetDownwardRollWindowStack(toggle)
	if (toggle == 1) then
		GroupLootFrame2:ClearAllPoints();
		GroupLootFrame2:SetPoint("TOP", "GroupLootFrame1", "BOTTOM", 0, -3);
		GroupLootFrame3:ClearAllPoints();
		GroupLootFrame3:SetPoint("TOP", "GroupLootFrame2", "BOTTOM", 0, -3);
		GroupLootFrame4:ClearAllPoints();
		GroupLootFrame4:SetPoint("TOP", "GroupLootFrame3", "BOTTOM", 0, -3);
	else
		GroupLootFrame2:ClearAllPoints();
		GroupLootFrame2:SetPoint("BOTTOM", "GroupLootFrame1", "TOP", 0, 3);
		GroupLootFrame3:ClearAllPoints();
		GroupLootFrame3:SetPoint("BOTTOM", "GroupLootFrame2", "TOP", 0, 3);
		GroupLootFrame4:ClearAllPoints();
		GroupLootFrame4:SetPoint("BOTTOM", "GroupLootFrame3", "TOP", 0, 3);
	end
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Casting Bar
-- <= == == == == == == == == == == == == =>

function MobileFrames_CastingBarFrame_UpdatePosition(reset)
	if (reset) or (MobileFrames_CastingBarFrame_isReset) then
		local castingBarPosition = 60;
		if ( PetActionBarFrame:IsVisible() or ShapeshiftBarFrame:IsVisible() ) then
			castingBarPosition = castingBarPosition + 40;
		end
		if ( MultiBarBottomLeft:IsVisible() or MultiBarBottomRight:IsVisible() ) then
			castingBarPosition = castingBarPosition + 40;
		end
		CastingBarFrame:ClearAllPoints();
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, castingBarPosition);
		CastingBarFrame:SetUserPlaced(false);
		MobileFrames_CastingBarFrame_isReset = true;
	end
end

-- <= == == == == == == == == == == == == =>
-- => Mobile Main Menu Bar
-- <= == == == == == == == == == == == == =>

function MobileFrames_MobileMainMenuBar_Reset()
	MainMenuBar:ClearAllPoints();
	MainMenuBar:SetPoint("BOTTOM", "UIParent", "BOTTOM");
	MainMenuBar:SetUserPlaced(false);
	MainMenuBar.isReset = true;
end

function MobileFrames_MobileMainBackpackButtons_Reset()
	MainMenuBarBackpackButton:ClearAllPoints();
	MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -6, 2);
	MainMenuBarBackpackButton:SetUserPlaced(false);
	MainMenuBarBackpackButton.isReset = true;
end

function MobileFrames_MobileCharacterMicroButtons_Reset()
	CharacterMicroButton:ClearAllPoints();
	CharacterMicroButton:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 552, 2);
	CharacterMicroButton:SetUserPlaced(false);
	CharacterMicroButton.isReset = true;
end

function MobileFrames_MobileActionButtons_Reset()
	ActionButton1:ClearAllPoints();
	ActionButton1:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4);
	ActionButton1:SetUserPlaced(false);
	ActionButton1.isReset = true;
end

function MobileFrames_MobileShapeshiftBarFrame_Reset()
	ShapeshiftBarFrame:SetUserPlaced(false);
	ShapeshiftBarFrame.isReset = true;
	MobileFrames_ShapeshiftBar_UpdatePosition();
end

function MobileFrames_MobilePetActionBarFrame_Reset()
	PetActionBarFrame:SetUserPlaced(false);
	PetActionBarFrame.isReset = true;
	--MobileFrames_PetActionBar_UpdatePosition();
	--disable OnUpdate relocation
	PetActionBarFrame.timeToSlide = 0;
	PetActionBarFrame.mode = "none";
end


-- <= == == == == == == == == == == == == =>
-- => Menu
-- <= == == == == == == == == == == == == =>

function MobileFramesDropDown_LoadDropDownMenu()
	--Title
	local info = {};
	info.text = GetReadableFrameName(UIDROPDOWNMENU_MENU_VALUE);
	info.notClickable = 1;
	info.isTitle = 1;
	UIDropDownMenu_AddButton(info, 1);
	
	--Reset
	local info = {};
	info.text = RESET;
	info.value = "Reset";
	info.func = function()
		if (MobileFrames_MultiSpecialFrames[UIDROPDOWNMENU_MENU_VALUE]) then
			MobileFrames_Reset(MobileFrames_MultiSpecialFrames[UIDROPDOWNMENU_MENU_VALUE]);
		else
			MobileFrames_Reset(UIDROPDOWNMENU_MENU_VALUE);
		end
	end;
	if (getglobal(UIDROPDOWNMENU_MENU_VALUE)) and (not getglobal(UIDROPDOWNMENU_MENU_VALUE):IsUserPlaced()) then
		info.disabled = 1;
	end
	UIDropDownMenu_AddButton(info, 1);
	
	--Reset All
	local info = {};
	info.text = RESET_ALL;
	info.value = "ResetAll";
	info.func = function() MobileFrames_Reset("") end;
	--info.notClickable = 1;
	UIDropDownMenu_AddButton(info, 1);
	
	MobileFramesDropDown_Reposition(getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL), this:GetName());
end

function MobileFramesDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, MobileFramesDropDown_LoadDropDownMenu, "MENU");
end

function MobileFramesDropDown_Reposition(listFrame, anchorName)
	local customPoint = "TOPLEFT";   --Default Anchor
	local offscreenY, offscreenX, anchorPoint, relativePoint, offsetX, offsetY;
	-- Determine whether the menu is off the screen or not
	local offscreenY, offscreenX;
	--Hack for built in bug
	if ( not listFrame:GetRight() ) then
		return;
	end
	
	if ( listFrame:GetBottom() < WorldFrame:GetBottom() ) then
		offscreenY = 1;
	end
	if ( listFrame:GetRight() > WorldFrame:GetRight() ) then
		offscreenX = 1;
	end
	
	local anchorPoint, relativePoint, offsetX, offsetY;
	if ( offscreenY == 1 ) then
		if ( offscreenX == 1 ) then
			anchorPoint = string.gsub(customPoint, "TOP(.*)", "BOTTOM%1");
			anchorPoint = string.gsub(anchorPoint, "(.*)LEFT", "%1RIGHT");
			relativePoint = "TOPRIGHT";
			offsetX = 0;
			offsetY = 14;
		else
			anchorPoint = string.gsub(customPoint, "TOP(.*)", "BOTTOM%1");
			relativePoint = "TOPLEFT";
			offsetX = 0;
			offsetY = 14;
		end
	else
		if ( offscreenX == 1 ) then
			anchorPoint = string.gsub(customPoint, "(.*)LEFT", "%1RIGHT");
			relativePoint = "BOTTOMRIGHT";
			offsetX = 0;
			offsetY = -14;
		else
			anchorPoint = customPoint;
			relativePoint = "BOTTOMLEFT";
			offsetX = 0;
			offsetY = -14;
		end
	end
	listFrame:ClearAllPoints();
	listFrame:SetPoint(anchorPoint, anchorName, relativePoint, offsetX, offsetY);
	
	-- Reshow the "MENU" border
	if (getglobal(listFrame:GetName().."Backdrop")) and (getglobal(listFrame:GetName().."MenuBackdrop")) then
		getglobal(listFrame:GetName().."Backdrop"):Hide();
		getglobal(listFrame:GetName().."MenuBackdrop"):Show();
	end
	--getglobal(listFrame:GetName().."Backdrop"):Show();
	--getglobal(listFrame:GetName().."MenuBackdrop"):Hide();
end

-- <= == == == == == == == == == == == == =>
-- => Mobile WorldStateAlwaysUpFrame
-- <= == == == == == == == == == == == == =>

function MobileFrames_WorldStateAlwaysUpFrame_SetupHooks()
	WorldStateAlwaysUpFrame:SetMovable(1);
	MobileFrames_SetEnabledStatus(WorldStateAlwaysUpFrame);
	--[[
	Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnEnter", "after", "OnEnter");
	Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnLeave", "after", "OnLeave");
	Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseUp", "after", "OnMouseUp");
	Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseDown", "after", "OnMouseDown");
	Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnEnter", "after", "OnEnter");
	Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnLeave", "after", "OnLeave");
	Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseUp", "after", "OnMouseUp");
	Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseDown", "after", "OnMouseDown");
	]]--
	Sea.util.hook("WorldStateAlwaysUpFrame", "MobileFrames_WorldStateAlwaysUpFrame_OnHide", "after", "OnHide");
end

function MobileFrames_WorldStateAlwaysUpFrame_OnEnter()
	--MobileFrames_ShowTooltip(WorldStateAlwaysUpFrame, WorldStateAlwaysUpFrame:GetName());
	if (MobileFrames_Tooltip_Enabled) then
		MobileFramesTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
		MobileFramesTooltip:SetText(format(MOBILE_FRAMES_TOOLTIP_TEXT, GetReadableFrameName("WorldStateAlwaysUpFrame")));
	end
end

function MobileFrames_WorldStateAlwaysUpFrame_OnLeave()
	MobileFramesTooltip:Hide();
end

function MobileFrames_WorldStateAlwaysUpFrame_OnMouseUp()
	MobileFrames_StopDrag(WorldStateAlwaysUpFrame);
end

function MobileFrames_WorldStateAlwaysUpFrame_OnMouseDown()
	--MobileFrames_BarOnMouseDown(WorldStateAlwaysUpFrame);
	local frame = WorldStateAlwaysUpFrame;
	if (arg1 == "RightButton") and (IsShiftKeyDown()) then
		MobileFramesDropDown.displayMode = "MENU";
		ToggleDropDownMenu(1, frame:GetName(), MobileFramesDropDown, frame:GetName());
	else
		MobileFrames_StartDrag(frame);
	end
end

function MobileFrames_WorldStateAlwaysUpFrame_OnHide()
	MobileFrames_StopDrag(WorldStateAlwaysUpFrame);
end

function MobileFrames_WorldStateAlwaysUpFrameReset()
	WorldStateAlwaysUpFrame.isReset = true;
	WorldStateAlwaysUpFrame:SetUserPlaced(false);
	WorldStateAlwaysUpFrame:ClearAllPoints();
	WorldStateAlwaysUpFrame:SetPoint("TOP", "UIParent", "TOP", -5, -15);
end

function MobileFrames_WorldStateAlwaysUpFrameEnable(checked)
	local frameName = "WorldStateAlwaysUpFrame";
	if (checked == nil) then
		MobileFrames_MasterEnableList[frameName] = (not MobileFrames_MasterEnableList[frameName]);
	else
		MobileFrames_MasterEnableList[frameName] = (checked == 1);
	end
	if (not MobileFrames_MasterEnableList[frameName]) then
		Sea.util.unhook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnEnter", "after", "OnEnter");
		Sea.util.unhook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnLeave", "after", "OnLeave");
		Sea.util.unhook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseUp", "after", "OnMouseUp");
		Sea.util.unhook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseDown", "after", "OnMouseDown");
		Sea.util.unhook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnEnter", "after", "OnEnter");
		Sea.util.unhook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnLeave", "after", "OnLeave");
		Sea.util.unhook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseUp", "after", "OnMouseUp");
		Sea.util.unhook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseDown", "after", "OnMouseDown");
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_DISABLED_TEXT, frameName));
		end
	else
		AlwaysUpFrame1:EnableMouse(1);
		AlwaysUpFrame2:EnableMouse(1);
		Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnEnter", "after", "OnEnter");
		Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnLeave", "after", "OnLeave");
		Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseUp", "after", "OnMouseUp");
		Sea.util.hook("AlwaysUpFrame1", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseDown", "after", "OnMouseDown");
		Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnEnter", "after", "OnEnter");
		Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnLeave", "after", "OnLeave");
		Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseUp", "after", "OnMouseUp");
		Sea.util.hook("AlwaysUpFrame2", "MobileFrames_WorldStateAlwaysUpFrame_OnMouseDown", "after", "OnMouseDown");
		if (checked == nil) then
			Sea.IO.print(format(MOBILE_FRAMES_ENABLED_TEXT, frameName));
		end
	end
end


