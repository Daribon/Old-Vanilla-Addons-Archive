--------------------------------------------------
--
--  AddOn: Atlas
--  Date: 5/10/2005
--  Author: Razark
--  Contact: loglow@gmail.com
--
--------------------------------------------------

Options = {
	AtlasAlpha = 1.0,
	AtlasLocked = false,
	AtlasButtonPosition = 268,
	AtlasButtonShown = true
};

ATLAS_VERSION = "v0.9.4";
ATLAS_TITLE = "Atlas";
ATLAS_SUBTITLE = "Interface Maps";
ATLAS_DESC = "Browse a collection of instance maps.";
ATLAS_VERS_TITLE = ATLAS_TITLE.." "..ATLAS_VERSION;

BINDING_HEADER_ATLAS_TITLE = ATLAS_TITLE;
BINDING_NAME_ATLAS_TOGGLE = "Toggle "..ATLAS_TITLE;
BINDING_NAME_ATLAS_TOGGLE_OPTIONS = "Toggle Options";

ATLAS_SLASH_HELP = "help";
ATLAS_SLASH_TOGGLE = "toggle";
ATLAS_SLASH_BUTTON = "button";
ATLAS_SLASH_ANGLE = "angle";
ATLAS_SLASH_ALPHA = "alpha";

ATLAS_DROPDOWN_LIST = {
	{name = "Blackfathom Deeps",		file = "BlackfathomDeeps"},
	{name = "Blackrock Depths",		file = "BlackrockDepths"},
	{name = "Dire Maul (East)",		file = "DireMaulEast"},
	{name = "Dire Maul (North)",		file = "DireMaulNorth"},
	{name = "Dire Maul (West)",		file = "DireMaulWest"},
	{name = "Gnomeregan",			file = "Gnomeregan"},
	{name = "Maraudon",			file = "Maraudon"},
	{name = "Molten Core",			file = "MoltenCore"},
	{name = "Ragefire Chasm",		file = "RagefireChasm"},
	{name = "Razorfen Downs",		file = "RazorfenDowns"},
	{name = "Razorfen Kraul",		file = "RazorfenKraul"},
	{name = "Scarlet Monastery",		file = "ScarletMonastery"},
	{name = "Scholomance",			file = "Scholomance"},
	{name = "Stratholme",			file = "Stratholme"},
	{name = "The Deadmines",		file = "TheDeadmines"},
	{name = "The Stockade",			file = "TheStockade"},
	{name = "The Temple of Atal'Hakkar",	file = "TheTemple"},
	{name = "Uldaman",			file = "Uldaman"},
	{name = "Wailing Caverns",		file = "WailingCaverns"},
	{name = "Zul'Farrak",			file = "Zul'Farrak"}
};

function Atlas_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	tinsert(UISpecialFrames, "AtlasFrame");
	UIPanelWindows["AtlasFrame"] = nil;
	AtlasFrame:RegisterForDrag("LeftButton");
	SLASH_ATLAS1 = "/atlas";
	SlashCmdList["ATLAS"] = function(msg)
		Atlas_SlashCommand(msg);
	end
end

function Atlas_OnEvent()
	if(event == "VARIABLES_LOADED") then

		Atlas_Refresh();
		AtlasOptions_Init();
		Atlas_UpdateLock();
		AtlasButton_UpdatePosition();
		Atlas_UpdateAlpha();

		---------------------
		-- support for Cosmos
		---------------------
		if(Cosmos_RegisterButton) then
			Cosmos_RegisterButton(
				ATLAS_VERS_TITLE,
				ATLAS_SUBTITLE,
				ATLAS_DESC,
				"Interface\\Icons\\INV_Misc_Map_01",
				Atlas_Toggle);
		end

		-----------------------
		-- support for myAddOns
		-----------------------
 		if(myAddOnsList) then
			myAddOnsList.Atlas = {
				name = ATLAS_TITLE,
				description = ATLAS_DESC,
				version = ATLAS_VERSION,
				category = MYADDONS_CATEGORY_MAP,
				frame = "AtlasFrame",
				optionsframe = 'AtlasOptionsFrame'};
		end
	end
end

function Atlas_ToggleLock()
	if(Options.AtlasLocked) then
		Options.AtlasLocked = false;
		Atlas_UpdateLock();
	else
		Options.AtlasLocked = true;
		Atlas_UpdateLock();
	end
end

function Atlas_UpdateLock()
	if(Options.AtlasLocked) then
		AtlasLockNorm:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Locked-Up");
		AtlasLockPush:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Locked-Down");
	else
		AtlasLockNorm:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Unlocked-Up");
		AtlasLockPush:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Unlocked-Down");
	end
end

function Atlas_StartMoving()
	if(not Options.AtlasLocked) then
		AtlasFrame:StartMoving();
	end
end

function Atlas_OnShow()
	local currentZone = GetRealZoneText();
	local currentMapID = UIDropDownMenu_GetSelectedID(AtlasFrameDropDown);
	if(currentZone ~= ATLAS_DROPDOWN_LIST[currentMapID].name) then
		for i = 1, getn(ATLAS_DROPDOWN_LIST), 1 do
			if(currentZone == ATLAS_DROPDOWN_LIST[i].name) then
				UIDropDownMenu_Initialize(AtlasFrameDropDown, AtlasFrameDropDown_Initialize);
				UIDropDownMenu_SetSelectedID(AtlasFrameDropDown, i);
				Atlas_Refresh();
			end
		end
	end
end

function Atlas_SlashCommand(msg)
	if(msg == "options") then
		AtlasOptions_Toggle();
	else
		Atlas_Toggle();
	end
end

function Atlas_UpdateAlpha()
	AtlasFrame:SetAlpha(Options.AtlasAlpha);
end

function Atlas_Toggle()
	if(AtlasFrame:IsVisible()) then
		HideUIPanel(AtlasFrame);
	else
		ShowUIPanel(AtlasFrame);
	end
end

function Atlas_Refresh()
	local currentID = UIDropDownMenu_GetSelectedID(AtlasFrameDropDown);
	AtlasMap:ClearAllPoints();
	AtlasMap:SetWidth(512);
	AtlasMap:SetHeight(512);
	AtlasMap:SetPoint("TOPLEFT", "AtlasFrame", "TOPLEFT", 14, -71);
	AtlasMap:SetTexture("Interface\\AddOns\\Atlas\\Images\\"..ATLAS_DROPDOWN_LIST[currentID].file);
end

function AtlasFrameDropDown_Initialize()
	local info;
	for i = 1, getn(ATLAS_DROPDOWN_LIST), 1 do
		info = { };
		info.text = ATLAS_DROPDOWN_LIST[i].name;
		info.func = AtlasFrameDropDownButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function AtlasFrameDropDown_OnLoad()
	UIDropDownMenu_Initialize(AtlasFrameDropDown, AtlasFrameDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDown, 1);
	UIDropDownMenu_SetWidth(150);
end

function AtlasFrameDropDownButton_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID(AtlasFrameDropDown);
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDown, this:GetID());
	if(oldID ~= this:GetID()) then
		Atlas_Refresh();
	end
end
