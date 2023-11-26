--[[

	TooltipsPropsTarget: Giving a little credit to my friends

	This mod add cute mouseovers and borders to various Cosmos
	Devs and long-term testers. 
	
	- by Alexander Yoshi 2 Oct. 2004.

]]

-- Configuration variables
local COS_PROPS_ENABLE	= 1;	-- set this to non nil to enable props

PropsTooltips = {
	["Xott"] = "Thottbot Lord";
	["Thott"] = "Thottbot Lord";
	["Naarolla"] = "Mango Maniac";
	["Graby"] = "Cosmos Frenchie";
	["Vjeux"] = "Cosmos Frenchie";
	["boulay"] = "Cosmos Frenchie";
	["Sarf"] = "Cosmos Bugsquasher";
	["Fras"] = "Cosmos Bugsquasher";
	["Celandro"] = "Cosmos Developer";
};

RegisterForSave("PropsTooltips");

RareList = {
	"Thott",
	"Xott",
	"Kelthan"
};
EliteList = { 
};

-- Callback functions
function TooltipsPropsTarget_Enable(toggle)
	if(toggle == 1) then 
		COS_PROPS_ENABLE = 1;
	else
		COS_PROPS_ENABLE = nil;
	end
end


function TooltipsPropsTarget_ModifyTooltip(type)
	if ( COS_PROPS_ENABLE == 1) then 
		if ( (GameTooltipTextLeft1:GetText() == "Alaair") or (GameTooltipTextLeft1:GetText() == "AlexYoshi") or (GameTooltipTextLeft1:GetText() == "Kelthan") ) then 
			GameTooltipTextLeft3:SetText(GameTooltipTextLeft3:GetText().." Coder");
		elseif ((GameTooltipTextLeft1:GetText() == "Thott")  or (GameTooltipTextLeft1:GetText() == "Xott") ) then 
			GameTooltipTextLeft3:SetText(GameTooltipTextLeft3:GetText().." Coder");
		elseif ((GameTooltipTextLeft1:GetText() == "Darkwing")  or (GameTooltipTextLeft1:GetText() == "Scree") ) then 
			GameTooltipTextLeft3:SetText(GameTooltipTextLeft3:GetText().." Coder");
		end

		-- Sets your own notes
		local note = PropsTooltips[GameTooltipTextLeft1:GetText()];
		if (note) then 
			GameTooltip:AddLine(note,1.0,1.0,1.0);
		end
	end
end


-- OnFoo functions

function TooltipsPropsTarget_OnLoad()
	--Print("SocialSendMessage_OnLoad.");

	-- Register with the CosmosMaster
	if(Cosmos_RegisterConfiguration ~= nil) then
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPSBASE",
			"SECTION",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPSBASE_SEP",
			"SEPARATOR",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);

		Cosmos_RegisterConfiguration(
			"COS_PROPS_ENABLE",	--CVar
			"CHECKBOX",						--Things to use
			TEXT(COS_PROPS_ENABLE_TEXT),
			TEXT(COS_PROPS_INFO),
			TooltipsPropsTarget_Enable,		--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterChatCommand(
			"PropsAdder",
			{"/label"},
			TooltipsPropsTarget_ChatCommandHandler,
			"Adds a custom title to a player's tooltip. Usage: /label PlayerName Their Title"
			);
	else 
			SLASH_PROPSADDER1 = "/label";
			SlashCmdList["PROPSADDER"] = function (msg)
				TooltipsPropsTarget_ChatCommandHandler(msg);
			end
	
	end
   HookFunction("TooltipsBase_UnitHandler","TooltipsPropsTarget_ModifyTooltip","after");
end

function TooltipsPropsTarget_ChatCommandHandler (msg)
	name = string.gsub (msg, "([%w]+)[ ]?(.*)", "%1");
	title = string.gsub (msg, "([%w]+)[ ]?(.*)", "%2");

	if ( name ~= "" ) then 
		if ( title == "" ) then 
			title = nil;
		end
		PropsTooltips[name] = title;
	end
end
