------------------------
------------------------
--                    --
--  Atlas             --
--  07/03/2005        --
--  loglow@gmail.com  --
--                    --
------------------------
------------------------

AtlasOptions = {
	AtlasAlpha = 1.0,
	AtlasLocked = false,
	AtlasButtonPosition = 32,
	AtlasButtonShown = false
};

ATLAS_DROPDOWN_LIST = {
	"BlackfathomDeeps",
	"BlackrockDepths",
	"BlackrockSpireLower",
	"BlackrockSpireUpper",
	"TheDeadmines",
	"DireMaulEast",
	"DireMaulNorth",
	"DireMaulWest",
	"Gnomeregan",
	"Maraudon",
	"MoltenCore",
	"OnyxiasLair",
	"RagefireChasm",
	"RazorfenDowns",
	"RazorfenKraul",
	"ScarletMonastery",
	"Scholomance",
	"ShadowfangKeep",
	"TheStockades",
	"Stratholme",
	"TheSunkenTemple",
	"Uldaman",
	"WailingCaverns",
	"ZulFarrak"
};

function Atlas_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	tinsert(UISpecialFrames, "AtlasFrame");
	UIPanelWindows["AtlasFrame"] = nil;
	AtlasFrame:RegisterForDrag("LeftButton");
	SLASH_ATLAS1 = ATLAS_SLASH;
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
		if(EarthFeature_AddButton) then
			EarthFeature_AddButton(
			{
				id = ATLAS_TITLE;
				name = ATLAS_NAME;
				subtext = ATLAS_SUBTITLE;
				tooltip = ATLAS_DESC;
				icon = "Interface\\AddOns\\Atlas\\Images\\AtlasIcon";
				callback = Atlas_Toggle;
				test = nil;
			}
		);
		elseif(Cosmos_RegisterButton) then
			Cosmos_RegisterButton(
				ATLAS_NAME,
				ATLAS_SUBTITLE,
				ATLAS_DESC,
				"Interface\\AddOns\\Atlas\\Images\\AtlasIcon",
				Atlas_Toggle
			);
		end

		--------------------
		-- support for CTMod
		--------------------
		if(CT_RegisterMod) then
			CT_RegisterMod(
				ATLAS_NAME,
				ATLAS_SUBTITLE,
				5,
				"Interface\\AddOns\\Atlas\\Images\\AtlasIcon",
				ATLAS_DESC,
				"switch",
				"",
				Atlas_Toggle
			);
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
				optionsframe = "AtlasOptionsFrame"};
		end
	end
end

function Atlas_ToggleLock()
	if(AtlasOptions.AtlasLocked) then
		AtlasOptions.AtlasLocked = false;
		Atlas_UpdateLock();
	else
		AtlasOptions.AtlasLocked = true;
		Atlas_UpdateLock();
	end
end

function Atlas_UpdateLock()
	if(AtlasOptions.AtlasLocked) then
		AtlasLockNorm:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Locked-Up");
		AtlasLockPush:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Locked-Down");
	else
		AtlasLockNorm:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Unlocked-Up");
		AtlasLockPush:SetTexture("Interface\\AddOns\\Atlas\\Images\\LockButton-Unlocked-Down");
	end
end

function Atlas_StartMoving()
	if(not AtlasOptions.AtlasLocked) then
		AtlasFrame:StartMoving();
	end
end

function Atlas_SlashCommand(msg)
	if(msg == ATLAS_SLASH_OPTIONS) then
		AtlasOptions_Toggle();
	else
		Atlas_Toggle();
	end
end

function Atlas_UpdateAlpha()
	AtlasFrame:SetAlpha(AtlasOptions.AtlasAlpha);
end

function Atlas_Toggle()
	if(AtlasFrame:IsVisible()) then
		HideUIPanel(AtlasFrame);
	else
		ShowUIPanel(AtlasFrame);
	end
end

function Atlas_Refresh()
	local zoneID = ATLAS_DROPDOWN_LIST[UIDropDownMenu_GetSelectedID(AtlasFrameDropDown)];
	AtlasMap:ClearAllPoints();
	AtlasMap:SetWidth(512);
	AtlasMap:SetHeight(512);
	AtlasMap:SetPoint("TOPLEFT", "AtlasFrame", "TOPLEFT", 14, -71);
	AtlasMap:SetTexture("Interface\\AddOns\\Atlas\\Images\\"..zoneID);
	AtlasText_ZoneName:SetText(AtlasText[zoneID]["ZoneName"]);
	AtlasText_Location:SetText(ATLAS_STRING_LOCATION..": "..AtlasText[zoneID]["Location"]);
	AtlasText_LevelRange:SetText(ATLAS_STRING_LEVELRANGE..": "..AtlasText[zoneID]["LevelRange"]);
	AtlasText_PlayerLimit:SetText(ATLAS_STRING_PLAYERLIMIT..": "..AtlasText[zoneID]["PlayerLimit"]);
	for i = 1, 28, 1 do
		getglobal("AtlasText_"..i):SetText(AtlasText[zoneID][i]);
	end
end

function AtlasFrameDropDown_Initialize()
	local info;
	for i = 1, getn(ATLAS_DROPDOWN_LIST), 1 do
		info = {
			text = AtlasText[ATLAS_DROPDOWN_LIST[i]]["ZoneName"];
			func = AtlasFrameDropDownButton_OnClick;
		};
		UIDropDownMenu_AddButton(info);
	end
end

function AtlasFrameDropDown_OnLoad()
	UIDropDownMenu_Initialize(AtlasFrameDropDown, AtlasFrameDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDown, 1);
	UIDropDownMenu_SetWidth(175);
end

function AtlasFrameDropDownButton_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID(AtlasFrameDropDown);
	UIDropDownMenu_SetSelectedID(AtlasFrameDropDown, this:GetID());
	if(oldID ~= this:GetID()) then
		Atlas_Refresh();
	end
end
