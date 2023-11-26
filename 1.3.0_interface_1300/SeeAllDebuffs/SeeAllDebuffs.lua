--SeeAllDebuffs v1.0
--Author: Abaddon (Abatorlos on Spinebreaker)
--Last Updated: 3/23/05

local alpha = 1;
local fading = 0;
local enabled = true;

function SeeAllDebuffsFrame_OnLoad()
	this:Show();
	SeeAllDebuffsButton6:Hide();
	SeeAllDebuffsButton7:Hide();
	SeeAllDebuffsButton8:Hide();
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	DEFAULT_CHAT_FRAME:AddMessage("SeeAllDebuffs 1.0 loaded");
	this:RegisterEvent("VARIABLES_LOADED");
	SLASH_SeeAllDebuffs1 = "/SeeAllDebuffs";
	SLASH_SeeAllDebuffs2 = "/sad";
	SlashCmdList["SeeAllDebuffs"] = function(msg)
		SeeAllDebuffs_Slash(msg);
	end
	SLASH_ReadBuffs1 = "/readbuffs";
	SlashCmdList["ReadBuffs"] = function()
		ReadBuffs();
	end
end

function SeeAllDebuffsFrame_OnEvent()
	if ( event == "PLAYER_TARGET_CHANGED" or event == "UNIT_AURA" and arg1 == "target" ) then
		SeeAllDebuffsFrame_Update();
	end
end

function SeeAllDebuffsButton_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 15, -25);
	if (this.id ~= nil) then
		if (UnitDebuff("target",this.id)) then
			GameTooltip:SetUnitDebuff("target", this.id);
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("Error: this.id is nil on enter");
	end
end

function SeeAllDebuffsFrame_Update()
	local i = 1;
	local button = "";
	local buttonIcon = "";
	for i = 6, 8 do
		debuffTexture = UnitDebuff("target",i);
		button = getglobal("SeeAllDebuffsButton"..i);
		buttonIcon = getglobal("SeeAllDebuffsButton"..i.."Icon");

		buttonIcon:SetTexture(debuffTexture);
		if (debuffTexture ~= nil and (not UnitIsFriend("player", "target")) and (not (UnitName("target") == ""))) then
			button:Show();
		else
			button:Hide();
		end
		button.id = i;
	end
end

function Usage()
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("SeeAllDebuffs Usage:");
		DEFAULT_CHAT_FRAME:AddMessage("/SeeAllDebuffs <enable/disable>");
		DEFAULT_CHAT_FRAME:AddMessage("You can use /sad in place of /SeeAllDebuffs");
	end
end

function SeeAllDebuffs_Slash(msg)
	local text = msg;
	local a, b, c, n = string.find (msg, "(%w+) (.+)");
	if (n == nil) then
		a, b, c = string.find (msg, "(%w+)");
	end
	if (c == nil) then
 		Usage();
    	else
		c = string.lower(c);
	end

	if (c == "enable") then
		enabled = true;
		SeeAllDebuffsFrame:Show();
		DEFAULT_CHAT_FRAME:AddMessage("ShowAllDebuffs enabled");
	elseif (c == "disable") then
		enabled = false;
		SeeAllDebuffsFrame:Hide();
		DEFAULT_CHAT_FRAME:AddMessage("ShowAllDebuffs disabled");
	end
end