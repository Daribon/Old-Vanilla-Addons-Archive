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

PropsCoderTooltips = {
	["Alaair"] = " Coder";
	["AlexYoshi"] = " Coder";
	["Kelthan"] = " Coder";
	["Thott"] = " Coder";
	["Xott"] = " Coder";
	["Darkwing"] = " Coder";
	["Scree"] = " Coder";
	["Celandro"] = " Coder";
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
		local name = GameTooltipTextLeft1:GetText();
		if (name) then
			local oldTip = GameTooltipTextLeft2:GetText();
			if (oldTip) then
				local coder = PropsCoderTooltips[name];
				if (coder) then
					GameTooltipTextLeft2:SetText(oldTip..coder);
				end
			end

		-- Sets your own notes
			local note = PropsTooltips[name];
			-- check for all lower case
			if (note == nil) then
				note = PropsTooltips[string.lower(name)];
			end
			if (note) then 
				GameTooltip:AddLine(note,1.0,1.0,1.0);
			end
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
   Sea.util.hook("TooltipsBase_UnitHandler","TooltipsPropsTarget_ModifyTooltip","after");
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
