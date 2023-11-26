--[[	****************************************************************
	MiniGroup K0.4a (bugbash ver)

	Author: Kaitlin of Sargeras
	****************************************************************
	Description:
		A set of moveable, dockable, and configurable
		minimalistic, DAoC-esque mini-windows including
		Mini-Group, Mini-Target, and Mini-Group Buff windows.

	Thank you to:
		Lothero of Sargeras (my bro) for debuffing me instead
			of leveling
		ImageShack.us for hosting my pics

	Official Site:
		wow.jaslaughter.com
	
	K0.4a-MiniGroup Glue
	****************************************************************]]

--[[	**********************************************************************************************
										    Variable Functions
	**********************************************************************************************]]

-- ** Global Vars
MGPlayer = nil;
DebuffID = { [1]="Magic",[2]="Poison",[3]="Disease",[4]="Curse",[5]="None" };
MGParty_FrameColors = { red = TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, green = TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, blue = TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, alpha = 1 };
MGTarget_FrameColors = { red = MGParty_FrameColors.red, green = MGParty_FrameColors.green, blue = MGParty_FrameColors.blue, alpha = MGParty_FrameColors.alpha };
MGBuff_FrameColors = { red = MGParty_FrameColors.red, green = MGParty_FrameColors.green, blue = MGParty_FrameColors.blue, alpha = MGParty_FrameColors.alpha };

-- ** Local Vars
local MGParty_Frame_IsLoaded = nil;
local varConfig = {
	"ShowBindingLabels",		-- 1
	"ShowPlayerFrame",		-- 2
	"ShowPartyFrames",		-- 3
	"ShowTargetFrame",		-- 4
	"ShowMGPartyFrame",		-- 5
	"ShowMGTargetFrame",		-- 6
	"ShowMGBuffFrame",		-- 7
	"UseGlobalDebuffColors",	-- 8
	"ShowMGPartyTips",		-- 9
	"ShowMGTargetTips",
	"ShowColorBlindIndicators",	-- 10
	"MGTarget_BuffFrame",		-- 11
	"MGToolTipStyle",		-- 12
	"ShowHealthType",		-- 13
	"SmoothHealthColor",		-- 14
	"TargetAuraPos",		-- 15
	"ShowMGPartyBuffs",		-- 16
	"UseUIScale",			-- 17
	"MGMemberScaling",		-- 18
	"LockMGPartyFrame",		-- 19
	"LockMGBuffFrame",		-- 20
	"LockMGTargetFrame",		-- 21
	"ShowColorIndicators",
	"ShowTColorIndicators",
	"ShowTColorBlindIndicators",
	"MGTToolTipStyle",
	"AutoHide"
};

local AuraPosFunc = {
	[1] = function(x) MGTarget_BuffFrameSet("on",1) end,
	[2] = function(x) MGTarget_BuffFrameSet("on",2) end };
local MiniGroup_ColorPicker = {
	["Party"] = function(x) MG_ColorPicker("MGParty_Frame") end,
	["Target"] = function(x) MG_ColorPicker("MGTarget_Frame") end,
	["Buff"] = function(x) MG_ColorPicker("MGBuff_Frame") end };
local MiniGroup_ColorPickerCancel = {
	["Party"] = function(x) MG_ColorPickerCancel("MGParty_Frame") end,
	["Target"] = function(x) MG_ColorPickerCancel("MGTarget_Frame") end,
	["Buff"] = function(x) MG_ColorPickerCancel("MGBuff_Frame") end };
local MiniGroup_Opacity = {
	["Party"] = function(x) MG_Opacity("MGParty_Frame") end,
	["Target"] = function(x) MG_Opacity("MGTarget_Frame") end,
	["Buff"] = function(x) MG_Opacity("MGBuff_Frame") end };
function MiniGroup_FreshVar()
	MiniGroup_Config = {
		["version"] = "K0.4",
		["DebuffOrder"] = {
			[1] = "Magic",
			[2] = "Poison",
			[3] = "Disease",
			[4] = "Curse",
			[5] = "None"
		},
		["DebuffColors"] = {
			["Magic"] = {r = 0.5, g = 0.5, b = 0.75, c = "!"},
			["Poison"] = {r = 0.75, g = 0, b = 0, c = "~"},
			["Disease"] = {r = 1, g = 1, b = 0, c = "^"},
			["Curse"] = {r = 1, g = 0.5, b = 0, c = "@"},
			["None"] = {r = 1, g = 1, b = 1, c = ""}
		}
	};
end

function MG_Get(option)
	if (MGPlayer ~= nil) then
		local myVars = MG_Split(MGPlayer.options,"|");
		for key, value in varConfig do
			if (value == option) then
				return tonumber(myVars[key]);
			end
		end

		return MGPlayer[option];
	else
		return nil;
	end
end

function MG_GetGlobal(option)
	if ( MGParty_Frame_IsLoaded ) then
		return MiniGroup_Config[option];
	else
		return nil;
	end
end

function MG_SetGlobal(option, value)
	if ( MGParty_Frame_IsLoaded ) then
		MiniGroup_Config[option] = value;
		return;
	end
end

function MG_Set(option, newVal)
	if (MGPlayer ~= nil) then
		local myVars = MG_Split(MGPlayer.options,"|");
		for key, value in varConfig do
			if (value == option) then
				myVars[key] = newVal;
				MGPlayer.options = table.concat(myVars,"|");
				return;
			end
		end
		if ( option ) then
			MGPlayer[option] = newVal;
		end
	end
end

--[[	*********************************** Player Info ********************************************]]

function MiniGroup_Initialize()
	if ( MiniGroup_Config["version"] ~= "K0.4" ) then
		MG_Chat("New version - Settings cleared.  Sorry!",1);
		MiniGroup_FreshVar();
	end
	MGPlayer = MiniGroup_GetPlayer();
	MiniGroup_SetOptions();
end

function MiniGroup_GetPlayer()
	if (MiniGroup_Config[UnitName("player").." of "..GetCVar("realmName")] == nil) then
		MiniGroup_NewPlayer(UnitName("player").." of "..GetCVar("realmName"));
	end
	return MiniGroup_Config[UnitName("player").." of "..GetCVar("realmName")];
end

function MiniGroup_NewPlayer(PlayerName)
	MiniGroup_Config[PlayerName] = {
		["options"] = "0|1|1|1|1|1|0|1|1|1|1|0|3|0|1|1|0|0|1|0|0|0|1|0|0|3|0",
		["MGParty_FrameColors"] = {r = MGParty_FrameColors.red, b = MGParty_FrameColors.blue, g = MGParty_FrameColors.green, opacity = MGParty_FrameColors.alpha},
		["MGTarget_FrameColors"] = {r = MGParty_FrameColors.red, b = MGParty_FrameColors.blue, g = MGParty_FrameColors.green, opacity = MGParty_FrameColors.alpha},
		["MGBuff_FrameColors"] = {r = MGParty_FrameColors.red, b = MGParty_FrameColors.blue, g = MGParty_FrameColors.green, opacity = MGParty_FrameColors.alpha},
		["DebuffOrder"] = {
			[1] = "Magic",
			[2] = "Poison",
			[3] = "Disease",
			[4] = "Curse",
			[5] = "None"},
     		["DebuffColors"] = {
			["Magic"] = {r = 0.5, g = 0.5, b = 0.75, c = "!"},
			["Poison"] = {r = 0.75, g = 0, b = 0, c = "~"},
			["Disease"] = {r = 1, g = 1, b = 0, c = "^"},
			["Curse"] = {r = 1, g = 0.5, b = 0, c = "@"},
			["None"] = {r = 1, g = 1, b = 1, c = ""}},
		["MGScale"] = 1,
		["WindowPos"] = { 427, 294, 477, 344, 377, 230 }
	};
	MG_Chat("New player "..PlayerName.." added.",1);
end

function MiniGroup_SetOptions()
	if ( MG_Get("ShowMGPartyFrame") == 0 ) then
		MGParty_Frame:Hide();
	end

	if ( MG_Get("ShowMGTargetFrame") == 1 ) then
		MiniGroup_MGTargetFrameSet("on");
	end

	if ( MG_Get("ShowMGBuffFrame") == 1 ) then
		MiniGroup_BuffFrameSet("on");
	end

	if ( MG_Get("MGTarget_BuffFrame") == 1 ) then
		MGTarget_BuffFrameSet("on",MG_Get("TargetAuraPos"));
	else
		MGTarget_BuffFrameSet("off");
	end

	if ( MG_Get("LockMGPartyFrame") == 1 ) then
		MGParty_FrameCloseButton:Hide();
	end

	if ( MG_Get("LockMGBuffFrame") == 1 ) then
		MGBuff_FrameCloseButton:Hide();
	end

	if ( MG_Get("ShowPlayerFrame") == 0 ) then
		MiniGroup_PlayerFrame("off");
	end

	if ( MG_Get("ShowPartyFrames") == 0 ) then
		HidePartyFrame();
	end

	MiniGroup_SetFrameColor(
		MGParty_Frame,
		MGPlayer["MGParty_FrameColors"].r,
		MGPlayer["MGParty_FrameColors"].g,
		MGPlayer["MGParty_FrameColors"].b,
		MGPlayer["MGParty_FrameColors"].opacity);
	MiniGroup_SetFrameColor(
		MGTarget_Frame,
		MGPlayer["MGTarget_FrameColors"].r,
		MGPlayer["MGTarget_FrameColors"].g,
		MGPlayer["MGTarget_FrameColors"].b,
		MGPlayer["MGTarget_FrameColors"].opacity);
	MiniGroup_SetFrameColor(
		MGBuff_Frame,
		MGPlayer["MGBuff_FrameColors"].r,
		MGPlayer["MGBuff_FrameColors"].g,
		MGPlayer["MGBuff_FrameColors"].b,
		MGPlayer["MGBuff_FrameColors"].opacity);

	MiniGroup_SetScale();
	MiniGroup_GetPos();
	MGParty_Member_UpdateAllMembers();
	MGTarget_UpdateCombatStatus();
end

--[[	**********************************************************************************************
											Event Handlers
	**********************************************************************************************]]

--[[	******************************** Shared Event Handlers ***************************************]]

function MiniGroup_OnMouseUp(frame,button)
	if ( button ~= "RightButton" ) then
		local fName = frame:GetName();
		local canMove = nil;
		if ( fName == "MGParty_Frame" and MG_Get("LockMGPartyFrame") ~= 1 ) then
			canMove = 1;
		elseif ( fName == "MGBuff_Frame" and MG_Get("LockMGBuffFrame") ~= 1 ) then
			canMove = 1;
		elseif ( fName == "MGTarget_Frame" and MG_Get("LockMGTargetFrame") ~= 1 ) then
			canMove = 1;
		end

		frame:StopMovingOrSizing();
		MiniGroup_SavePos(frame);

		-- Close all dropdowns
		CloseDropDownMenus();
	end
end

function MiniGroup_OnMouseDown(frame,button)
	if ( button == "LeftButton" ) then
		local fName = frame:GetName();
		local canMove = nil;
		if ( fName == "MGParty_Frame" and MG_Get("LockMGPartyFrame") ~= 1 ) then
			canMove = 1;
		elseif ( fName == "MGBuff_Frame" and MG_Get("LockMGBuffFrame") ~= 1 ) then
			canMove = 1;
		elseif ( fName == "MGTarget_Frame" and MG_Get("LockMGTargetFrame") ~= 1 ) then
			canMove = 1;
		end

		if ( canMove ) then
			frame:StartMoving();
		end

		-- Close all dropdowns
		CloseDropDownMenus();
	else
		if ( frame:GetName() == "MGTarget_Frame" ) then
			return;
		else
			local distance;
			if ( frame:GetName() == "MGParty_Frame" ) then
				distance = ( UIParent:GetWidth() - MGParty_Frame:GetRight() );
			elseif ( frame:GetName() == "MGBuff_Frame" ) then
				distance = ( UIParent:GetWidth() - MGBuff_Frame:GetRight() );
			end
			if ( distance <= 100 ) then
				ToggleDropDownMenu(1, nil, MGParty_FrameDropDown, "MGParty_FrameDropDown", -150, 0);
			else
				ToggleDropDownMenu(1, nil, MGParty_FrameDropDown, "MGParty_FrameDropDown", 0, 0);
			end
		end
	end
end

function MGHealthBar_OnValueChanged(value, smooth)
	if ( not value or not MGPlayer ) then
		return;
	end

	if ( MG_Get("SmoothHealthColor") == 1 ) then
		local r, g, b;
		local min, max = this:GetMinMaxValues();
		if ( (value < min) or (value > max) ) then
			return;
		end
		if ( (max - min) > 0 ) then
			value = (value - min) / (max - min);
		else
			value = 0;
		end

		if(value > 0.5) then
			r = (1.0 - value) * 2;
			g = 1.0;
		else
			r = 1.0;
			g = value * 2;
		end
		b = 0.0;
		this:SetStatusBarColor(r, g, b);
	else
		HealthBar_OnValueChanged( value, smooth );
	end
end

--[[	******************************** MGParty Frame Events ****************************************]]

function MGParty_Frame_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("CVAR_UPDATE");

	SlashCmdList["MINIGROUP"] = function (msg) MiniGroup_SlashHandler(msg, 0); end;
	SLASH_MINIGROUP1 = "/minigroup";
	SLASH_MINIGROUP2 = "/mg";

	MiniGroup_FreshVar();
	MiniGroup_SetFrameColor();
end

function MGParty_Frame_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		MGParty_Frame_IsLoaded = 1;
		return;
	end

	if ( event == "UNIT_NAME_UPDATE" and arg1 == "player" ) then
		local playerName = UnitName("player");
		if ( playerName ~= UNKNOWNBEING and playerName ~= "Unknown Entity" and MGParty_Frame_IsLoaded and MGPlayer == nil ) then
			MG_Chat("MiniGroup vK0.4b by Kaitlin loaded.");
			MiniGroup_Initialize();
		end
		return;
	end

	if ( event == "CVAR_UPDATE" ) then
		MiniGroup_SetScale();
		MiniGroup_GetPos();
		return;
	end
end

--[[	**********************************************************************************************
											 Slash Handler
	**********************************************************************************************]]

function MiniGroup_SlashHandler(msg, level)
	if ( strlen(msg) == 0 ) then
		MG_Chat("MiniGroup Window Suite");
		MG_Chat(" - by Kaitlin of Sargeras");
		MG_Chat("");
		MG_Chat("Version: K0.4b");
		MG_Chat("Commands: /minigroup or /mg");
		MG_Chat("show / hide : Show or hide the MG Window");
	elseif ( msg == "hide" ) then
		MG_Set("ShowMGPartyFrame",0);
		MGParty_Frame:Hide();
	elseif ( msg == "show" ) then
		MG_Set("ShowMGPartyFrame",1);
		MGParty_Frame:Show();
	elseif ( msg == "config" ) then
		MGOptionsFrame:Show();
	elseif ( msg == "resetpos" ) then
		MiniGroup_ResetPos();
		MiniGroup_SavePos(MGParty_Frame);
		MiniGroup_SavePos(MGTarget_Frame);
		MiniGroup_SavePos(MGBuff_Frame);
	elseif ( tonumber(msg) ) then
		MG_Set("UseUIScale",1);
		MG_Set("MGScale",tonumber(msg));
		MiniGroup_SetScale();
		MiniGroup_ResetPos();
		MiniGroup_SavePos(MGParty_Frame);
		MiniGroup_SavePos(MGTarget_Frame);
		MiniGroup_SavePos(MGBuff_Frame);
	elseif ( msg == "clear" ) then
		MiniGroup_FreshVar();
		MGPlayer = MiniGroup_GetPlayer();
		MiniGroup_SetOptions();
	end
end

--[[	**********************************************************************************************
									      Window / Frame Functions
	**********************************************************************************************]]

function MiniGroup_LoadButtons(name)
	local prefix = "Interface\\Buttons\\UI-MicroButton-";
	this:SetNormalTexture(prefix..name.."-Up");
	this:SetPushedTexture(prefix..name.."-Down");
	this:SetDisabledTexture(prefix..name.."-Disabled");
	this:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight");
end

function MiniGroup_ResetPos()
	MGParty_Frame:ClearAllPoints();
	MGTarget_Frame:ClearAllPoints();
	MGBuff_Frame:ClearAllPoints();
	MGParty_Frame:SetPoint("CENTER","UIParent","CENTER",0,0);
	MGTarget_Frame:SetPoint("CENTER","UIParent","CENTER",150,150);
	MGBuff_Frame:SetPoint("CENTER","UIParent","CENTER",-150,-150);
end

function MiniGroup_PlayerFrame(switch)
	-- Hide the UIParent Player Frame
	if (switch == "off") then
		MG_Set("ShowPlayerFrame",0);
		PlayerFrame:Hide();
	else
		MG_Set("ShowPlayerFrame",1);
		PlayerFrame:Show();
	end
end

function MiniGroup_PartyFrames(switch)
	-- Hide the UIParent Party Frames
	if (switch == "off") then
		MG_Set("ShowPartyFrames",0);
		HidePartyFrame();
	else
		MG_Set("ShowPartyFrames",1);
		ShowPartyFrame();
	end
end

function MiniGroup_MGTargetFrameSet(switch)
	if (switch == "on") then
		MGParty_ToggleMGTarget_Button:SetButtonState("PUSHED",1);
		if ( UnitExists("target") ) then
			MGTarget_Frame:Show();
		end
	else
		MGParty_ToggleMGTarget_Button:SetButtonState("NORMAL");
		MGTarget_Frame:Hide();
	end
end

function MiniGroup_BuffFrameSet(switch)
	if (switch and switch == "on") then
		MGParty_ToggleMGBuff_Button:SetButtonState("PUSHED",1);
		MGParty_ToggleMGBuff_Button:SetAlpha(0.5);
		MGBuff_Frame:Show();
	else
		MGParty_ToggleMGBuff_Button:SetButtonState("NORMAL");
		MGParty_ToggleMGBuff_Button:SetAlpha(1);
		MGBuff_Frame:Hide();
	end
end

function MiniGroup_LoadButtons(name)
	local prefix = "Interface\\Buttons\\UI-MicroButton-";
	this:SetNormalTexture(prefix..name.."-Up");
	this:SetPushedTexture(prefix..name.."-Down");
	this:SetDisabledTexture(prefix..name.."-Disabled");
	this:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight");
end

function MGTarget_BuffFrameSet(switch, pos)
	if ( pos ) then
		MG_Set("TargetAuraPos",pos);
	end
	MGTargetDebuffButton_Update();
end

function MiniGroup_SetFrameColor(frame,r,g,b,a)
	local red, green, blue, alpha;

	if ( not frame ) then
		frame = this;
	end

	if ( frame:GetName() == "MGParty_Frame" ) then
		colorVar = MGParty_FrameColors;
	elseif ( frame:GetName() == "MGTarget_Frame" ) then
		colorVar = MGTarget_FrameColors;
	else
		colorVar = MGBuff_FrameColors;
	end

	frame = getglobal(frame:GetName().."Backdrop");
	if ( not frame ) then
		MG_Chat(this:GetName().." not found.");
	end

	if ( r and g and b ) then
		colorVar.red = r;
		colorVar.green = g;
		colorVar.blue = b;
	else
		colorVar.red = TOOLTIP_DEFAULT_BACKGROUND_COLOR.r;
		colorVar.green = TOOLTIP_DEFAULT_BACKGROUND_COLOR.g;
		colorVar.blue = TOOLTIP_DEFAULT_BACKGROUND_COLOR.b;
	end

	if ( a ) then
		colorVar.alpha = a;
	else
		colorVar.alpha = 1;
	end

	frame:SetBackdropColor(r,g,b,a);
	frame:SetBackdropBorderColor(
			TOOLTIP_DEFAULT_COLOR.r,
			TOOLTIP_DEFAULT_COLOR.g,
			TOOLTIP_DEFAULT_COLOR.b,
			a);
end

function MiniGroup_SetScale(scale)
	local useUIScale = GetCVar("useUiScale");
	local parentScale = UIParent:GetScale();
	local frameScale = MGParty_Frame:GetScale();

	if ( MG_Get("UseUIScale") == 1 ) then
		scale = MG_Get("MGScale");
	elseif ( not scale ) then
		if ( useUIScale == "1" ) then
			scale = parentScale;
		else
			scale = 1;
		end
	end

	if ( MGParty_Frame and MGBuff_Frame and MGTarget_Frame ) then
		if ( scale == frameScale ) then
			return;
		end
		local fX = MGParty_Frame:GetLeft();
		local fY = MGParty_Frame:GetBottom();

		if ( fX and fY ) then
			if ( frameScale > parentScale or frameScale < parentScale ) then
				fX = ( frameScale * fX ) / scale;
				fY = ( frameScale * fY ) / scale;
			else
				fX = fX / scale;
				fY = fY / scale;
			end

			MGParty_Frame:SetScale(scale);
			MGBuff_Frame:SetScale(scale);
			MGTarget_Frame:SetScale(scale);
			MGParty_Frame:ClearAllPoints();
			MGParty_Frame:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT",fX,fY);
		end
	end
end

function MiniGroup_SavePos(frame)
	local fName = frame:GetName();
	local fX = frame:GetLeft();
	local fY = frame:GetTop();

	if ( fName == "MGParty_Frame" ) then
		MGPlayer["WindowPos"][1] = fX;
		MGPlayer["WindowPos"][2] = fY;
	elseif ( fName == "MGTarget_Frame" ) then
		MGPlayer["WindowPos"][3] = fX;
		MGPlayer["WindowPos"][4] = fY;
	elseif ( fName == "MGBuff_Frame" ) then
		MGPlayer["WindowPos"][5] = fX;
		MGPlayer["WindowPos"][6] = fY;
	end
end

function MiniGroup_GetPos()
	MGParty_Frame:ClearAllPoints();
	MGParty_Frame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",MGPlayer["WindowPos"][1], MGPlayer["WindowPos"][2]);
	MGTarget_Frame:ClearAllPoints();
	MGTarget_Frame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",MGPlayer["WindowPos"][3], MGPlayer["WindowPos"][4]);
	MGBuff_Frame:ClearAllPoints();
	MGBuff_Frame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",MGPlayer["WindowPos"][5], MGPlayer["WindowPos"][6]);
end

--[[	************************** Window / Frame Toggle Functions *************************************]]

function MGParty_ToggleMGBuff()
	if (MG_Get("ShowMGBuffFrame") == 0) then
		MG_Set("ShowMGBuffFrame", 1);
		MiniGroup_BuffFrameSet("on");
	else
		MG_Set("ShowMGBuffFrame", 0);
		MiniGroup_BuffFrameSet("off");
	end
end

local MiniGroup_ToggleLock = {
	["LockAll"] = function(x) MiniGroup_LockToggle("lockall") end,
	["UnlockAll"] = function(x) MiniGroup_LockToggle("unlockall") end,
	["MGParty_Frame"] = function(x) MiniGroup_LockToggle("Party") end,
	["MGTarget_Frame"] = function(x) MiniGroup_LockToggle("Target") end,
	["MGBuff_Frame"] = function(x) MiniGroup_LockToggle("Buff") end
};

function MiniGroup_LockToggle(frame)
	if ( frame == "lockall" ) then
		MG_Set("LockMGPartyFrame",1);
		MG_Set("LockMGTargetFrame",1);
		MG_Set("LockMGBuffFrame",1);
		MGParty_FrameCloseButton:Hide();
		MGBuff_FrameCloseButton:Hide();
	elseif ( frame == "unlockall" ) then
		MG_Set("LockMGPartyFrame",0);
		MG_Set("LockMGTargetFrame",0);
		MG_Set("LockMGBuffFrame",0);
		MGParty_FrameCloseButton:Show();
		MGBuff_FrameCloseButton:Show();
	end

	if (MG_Get("LockMG"..frame.."Frame") == 0) then
		MG_Set("LockMG"..frame.."Frame",1);
		if ( getglobal("MG"..frame.."_FrameCloseButton") ) then
			getglobal("MG"..frame.."_FrameCloseButton"):Hide();
		end
	else
		MG_Set("LockMG"..frame.."Frame",0);
		if ( getglobal("MG"..frame.."_FrameCloseButton") ) then
			getglobal("MG"..frame.."_FrameCloseButton"):Show();
		end
	end
end

function MGParty_ToggleMGTarget()
	if (MG_Get("ShowMGTargetFrame") == 0) then
		MG_Set("ShowMGTargetFrame", 1);
		MiniGroup_MGTargetFrameSet("on");
	else
		MG_Set("ShowMGTargetFrame", 0);
		MiniGroup_MGTargetFrameSet("off");
	end
end

function MGTarget_BuffFrameToggle()
	if (MG_Get("MGTarget_BuffFrame") == 0) then
		MG_Set("MGTarget_BuffFrame",1);
		MGTarget_BuffFrameSet("on");
	else
		MG_Set("MGTarget_BuffFrame",0);
		MGTarget_BuffFrameSet("off");
	end
end

--[[	**********************************************************************************************
										      Debuff Functions
	**********************************************************************************************]]

function MiniGroup_RefreshBuffs()
	local prefix = this:GetName();
	local unitName = getglobal(prefix.."UnitName"):GetText();
	local unitText = getglobal(prefix.."Name");
	local unitBlizText = getglobal(prefix.."UnitName");
	local unitID = this:GetID();
	local keyBinding, unitDebuffs, debuff,unit,info,infoNone;

	if ( MGPlayer == nil or unitName == nil ) then
		return;
	elseif ( unitID == 0 ) then
		unit = "player";
	else
		unit = "party"..unitID;
	end

	unitDebuffs = {};

	for i = 1, 8 do
		debuff = UnitDebuff(unit, i);
		if ( debuff ) then
			MGTooltipTextRight1:SetText("");
			MGTooltip:SetUnitDebuff(unit, i);
			debuff = MGTooltipTextRight1:GetText();
			if ( debuff ) then
				table.insert(unitDebuffs, debuff);
				debuff = nil;
			end
		end
	end

	if ( MG_Get("ShowBindingLabels") == 1 ) then
		if ( unitID == 0 ) then
			keyBinding = GetBindingKey("TARGETSELF").."-";
		elseif ( unitID > 0 and unitID < 5 ) then
			keyBinding = GetBindingKey("TARGETPARTYMEMBER"..unitID).."-";
		end
	else
		keyBinding = "";
	end

	info = MiniGroup_GetDebuffColor(unitDebuffs);
	infoNone = MiniGroup_GetDebuffColor();

	if ( table.getn(unitDebuffs) > 0 ) then
		if ( MG_Get("ShowColorBlindIndicators") == 1 ) then
			unitText:SetText(keyBinding..info.c..unitName..info.c);
		else
			unitText:SetText(keyBinding..unitName);
		end
		if ( MG_Get("ShowColorIndicators") == 1 ) then
			unitText:SetVertexColor(info.r,info.g,info.b);
		else
			unitText:SetVertexColor(infoNone.r,infoNone.g,infoNone.b);
		end
	else
		if ( MG_Get("ShowColorBlindIndicators") == 1 ) then
			unitText:SetText(keyBinding..infoNone.c..unitName..infoNone.c);
		else
			unitText:SetText(keyBinding..unitName);
		end
		unitText:SetVertexColor(infoNone.r,infoNone.g,infoNone.b);
	end
	unitBlizText:Hide();
end

function MGBuff_RefreshBuffs()
	if ( getglobal("MGBuff_Frame") ) then
		local Buff, BuffButton;
		local hasBuffs;
		local partySize = 0;
		local prefixBuff = "MGBuffMember";
		local prefixParty = "MGParty_Member";
		local unit;
		local showPartyBuffs = MG_Get("ShowMGPartyBuffs");

		for id = 0, 4 do
			hasBuffs = 0;
			for i=1, 10 do
				if ( id == 0 ) then
					unit = "player";
				else
					unit = "party"..id;
				end
				Buff = UnitBuff(unit, i);
				if ( Buff ) then
					hasBuffs = 1;
					if ( showPartyBuffs == 1 ) then
						getglobal(prefixParty..id.."Buff"..i.."Icon"):SetTexture(Buff);
						getglobal(prefixParty..id.."Buff"..i):Show();
					else
						getglobal(prefixParty..id.."Buff"..i):Hide();
					end
					getglobal(prefixBuff..id.."Buff"..i.."Icon"):SetTexture(Buff);
					getglobal(prefixBuff..id.."Buff"..i):Show();
				else
					getglobal(prefixParty..id.."Buff"..i):Hide();
					getglobal(prefixBuff..id.."Buff"..i):Hide();
				end
			end
			if ( hasBuffs == 1 and MGBuff_Frame:IsVisible() ) then
				getglobal(prefixBuff..id.."HR"):Show();
			else
				getglobal(prefixBuff..id.."HR"):Hide();
			end
		end

		for num = 1, 4 do
			if ( GetPartyMember(num) ) then
				partySize = partySize + 1;
			end
		end
		MGParty_Frame_CheckSize();
	end
end

function MiniGroup_GetDebuffColor(debuffs)
	local isItA = {["Magic"] = 0, ["Poison"] = 0, ["Disease"] = 0, ["Curse"] = 0, ["None"] = 0};
	local buffTop = nil;
	local buffTable;

	if ( MG_Get("UseGlobalDebuffColors") == 1 ) then
		buffTable = MiniGroup_Config;
	else
		buffTable = MGPlayer;
	end

	if ( debuffs ) then
		for key, value in debuffs do
			for nK,nV in DebuffID do
				if ( value == nV ) then
					isItA[nV] = 1;
					break;
				end
			end
		end

		for num = 1, table.getn(DebuffID) do
			if ( isItA[buffTable["DebuffOrder"][num]] == 1 ) then
				buffTop = buffTable["DebuffOrder"][num];
				break;
			end
		end
	end

	if ( buffTop ) then
		return buffTable["DebuffColors"][buffTop];
	else
		return buffTable["DebuffColors"]["None"];
	end
end

--[[	**********************************************************************************************
										  UIDropDown Functions
	**********************************************************************************************]]

function MGParty_FrameDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, MGParty_FrameDropDown_Initialize, "MENU");
end

function MGParty_FrameDropDown_Initialize()

	-- Show Config Window
	info = {};
	info.text = "Open Config Window";
	info.notCheckable = 1;
	info.func = function(x) MGOptionsFrame:Show() end;
	UIDropDownMenu_AddButton(info);

	-- Spacer
	info = {};
	info.disabled = 1;
	UIDropDownMenu_AddButton(info);

	-- Header
	info = {};
	info.text = "Lock Options";
	info.notClickable = 1;
	info.isTitle = 1;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- All Lock
	info = {};
	info.func = MiniGroup_ToggleLock["LockAll"];
	info.notCheckable = 1;
	info.text = "Lock All Windows";
	UIDropDownMenu_AddButton(info);

	-- Buff Unlock
	info = {};
	info.func = MiniGroup_ToggleLock["UnlockAll"];
	info.notCheckable = 1;
	info.text = "Unlock All Windows";
	UIDropDownMenu_AddButton(info);

	-- Party Lock
	info = {};
	info.func = MiniGroup_ToggleLock["MGParty_Frame"];
	info.text = "Lock Party Window";
	if ( MGPlayer == nil or MG_Get("LockMGPartyFrame") == 0 ) then
		info.checked = nil;
	else
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);

	-- Target Lock
	info = {};
	info.func = MiniGroup_ToggleLock["MGTarget_Frame"];
	info.text = "Lock Target Window";
	if ( MGPlayer == nil or MG_Get("LockMGTargetFrame") == 0 ) then
		info.checked = nil;
	else
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);

	-- Buff Lock
	info = {};
	info.func = MiniGroup_ToggleLock["MGBuff_Frame"];
	info.text = "Lock Buff Window";
	if ( MGPlayer == nil or MG_Get("LockMGBuffFrame") == 0 ) then
		info.checked = nil;
	else
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);

	-- Spacer
	info = {};
	info.disabled = 1;
	UIDropDownMenu_AddButton(info);

	-- Header
	info = {};
	info.text = "Window Colors";
	info.notClickable = 1;
	info.isTitle = 1;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Set Party Background color
	info = {};
	info.text = "Party Window";
	info.hasColorSwatch = 1;
	info.r = MGParty_FrameColors.red;
	info.g = MGParty_FrameColors.green;
	info.b = MGParty_FrameColors.blue;
	info.notCheckable = 1;
	info.opacity = 1.0 - MGParty_FrameColors.alpha;
	info.swatchFunc = MiniGroup_ColorPicker["Party"];
	info.func = UIDropDownMenuButton_OpenColorPicker;
	info.hasOpacity = 1;
	info.opacityFunc = MiniGroup_Opacity["Party"];
	info.cancelFunc = MiniGroup_ColorPickerCancel["Party"];
	UIDropDownMenu_AddButton(info);

	-- Set Target Background color
	info = {};
	info.text = "Target Window";
	info.hasColorSwatch = 1;
	info.r = MGTarget_FrameColors.red;
	info.g = MGTarget_FrameColors.green;
	info.b = MGTarget_FrameColors.blue;
	info.notCheckable = 1;
	info.opacity = 1.0 - MGTarget_FrameColors.alpha;
	info.swatchFunc = MiniGroup_ColorPicker["Target"];
	info.func = UIDropDownMenuButton_OpenColorPicker;
	info.hasOpacity = 1;
	info.opacityFunc = MiniGroup_Opacity["Target"];
	info.cancelFunc = MiniGroup_ColorPickerCancel["Target"];
	UIDropDownMenu_AddButton(info);

	-- Set Buff Background color
	info = {};
	info.text = "Buff Window";
	info.hasColorSwatch = 1;
	info.r = MGBuff_FrameColors.red;
	info.g = MGBuff_FrameColors.green;
	info.b = MGBuff_FrameColors.blue;
	info.notCheckable = 1;
	info.opacity = 1.0 - MGBuff_FrameColors.alpha;
	info.swatchFunc = MiniGroup_ColorPicker["Buff"];
	info.func = UIDropDownMenuButton_OpenColorPicker;
	info.hasOpacity = 1;
	info.opacityFunc = MiniGroup_Opacity["Buff"];
	info.cancelFunc = MiniGroup_ColorPickerCancel["Buff"];
	UIDropDownMenu_AddButton(info);
end

--[[	**********************************************************************************************
									UIDropDown Menu Item Functions
	**********************************************************************************************]]

--[[	**********************  Color Picker Functions ********************** ]]

function MG_ColorPicker(frame)
	red,green,blue = ColorPickerFrame:GetColorRGB();
	local window = {r = red, b = blue, g = green, opacity = alpha};
	MG_Set(frame.."Colors", window);
	MiniGroup_SetFrameColor(getglobal(frame),red,green,blue,alpha);
end

function MG_ColorPickerCancel(frame)
	red = ColorPickerFrame.previousValues.r;
	green = ColorPickerFrame.previousValues.g;
	blue = ColorPickerFrame.previousValues.b;
	alpha = 1.0 - ColorPickerFrame.previousValues.opacity;
	MiniGroup_SetFrameColor(getglobal(frame),red,green,blue,alpha);
end

function MG_Opacity(frame)
	alpha = 1.0 - OpacitySliderFrame:GetValue();
	local window = {r = red, b = blue, g = green, opacity = alpha};
	MG_Set(frame.."Colors", window);
	MiniGroup_SetFrameColor(getglobal(frame),red,green,blue,alpha);
end

--[[	**********************************************************************************************
										   Auxiliary Functions
	**********************************************************************************************]]

function MG_Split(toCut, separator)
	local splitted = {};
	local i = 0;
	local regEx = "([^" .. separator .. "]*)" .. separator .. "?";

	for item in string.gfind(toCut .. separator, regEx) do
		i = i + 1;
		splitted[i] = MG_Trim(item) or '';
	end
	splitted[i] = nil;
	return splitted;
end

function MG_Chat(msg, error)
	if( DEFAULT_CHAT_FRAME ) then
		if ( error ) then
			DEFAULT_CHAT_FRAME:AddMessage("<MiniGroup> "..msg, 1.0, 0.5, 0.0);
		else
			DEFAULT_CHAT_FRAME:AddMessage("<MiniGroup> "..msg, 1.0, 1.0, 0.0);
		end
	end
end

function MG_Trim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end

function MG_ReOrder(cTable, buff, pos)
	for k,v in cTable do
		if (v == buff) then
			table.remove(cTable,k);
			break;
		end
	end
	table.insert(cTable,pos,buff);
end
