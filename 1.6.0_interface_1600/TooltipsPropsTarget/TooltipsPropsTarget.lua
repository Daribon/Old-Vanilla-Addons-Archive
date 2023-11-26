

-- Configuration variables
local UUI_PROPS_ENABLE	= 1;	-- set this to non nil to enable props
local ThisRealmName = GetCVar("realmName");

if( ThisRealmName == "Arthas" ) then
	PropsCoderTooltips = {
		["Dakkon"] = "Ultimate UI Mastermind";
		["Dakken"] = "Mage Headmaster";
		["Zris"] = "Ascendant Evincar";
	};
elseif( ThisRealmName == "Lightning's Blade" ) then
	PropsCoderTooltips = {
		["Dakkan"] = "Descendant Taskmaster";
		["Zeeg"] = "zeeg will pwn j00!!!";
	};
elseif( ThisRealmName == "Nathrezim" ) then
	PropsCoderTooltips = {
		["Dakkan"] = "Deathstalker Overlord";
		["Scatercraft"] = "UUI Warning: Ninja Looter DO NOT GROUP WITH.";
		["Arch"] = "Creator of Ultimate UI";
		["Exodius"] = "Elite Horde Champion";
		["Archen"] = "Mage Headmaster";
		["Archera"] = "This... is... my... BOOMSTICK!!!";
		["Nightcrawlor"] = "For the End Of The World spell, press ctrl-alt-delete.";
		["Aparition"] = "You can't kill me, Im already dead.";
		["Kilah"] = "nice pull... ROFL";
		["Lucrend"] = "I have bad breathren...";
		["Canarn"] = "Im a Canadian Treasure.";
		["Mucher"] = "*cellphone ring* Argh! For the last time, I'm a DREADLORD not a druglord!";
		["Corleone"] = "i wont roll on any hunter drops LOL";
		["Corlepwn"] = "If you see this, you're dead.";
		["Ryi"] = "got any gummy humans?";
		["Gnothkhar"] = "i love mattperrin";
		["Thokk"] = "its only a flesh wound...";
		["Azuzel"] = "Inspect me baby one more time";
		["Rhuen"] = "Cant... stop... dancing!";
		["Odus"] = "Got Milk?";
		["Orangex"] = "Curiosity killed my last ride.";
		["Ruroken"] = "Right-click for hot undead action";
		["Balikruxh"] = "Free rides... for the ladies.";
		["Joeycbird"] = "Say 'ello to my lil' friend...";
		["Penguina"] = "Humans check in, they DONT check out.";
		["Qcdreadhead"] = "Every man lives, not every man truly dies.";
		["Karim"] = "I see undead people.";
		["Ralpok"] = "NERF SHAMANS!!  LOL";
		["Zubazz"] = "oh brother, where art thou?";
		["Dignan"] = "Dig this.";
		["Sweeterika"] = "Im sweet but I like it rough.";
		["Goshinki"] = "Go shinki! Its your birthday!";
		["Jekni"] = "Founding members of the Knights who say Ni";
		["Twistar"] = "Pirates vs Ninjas: Who wins?";
		["Zulejah"] = "tasdengo";
	};
elseif( ThisRealmName == "Mal'Ganis" ) then
	PropsCoderTooltips = {
		["Zariz"] = "Rogues do it from Behind";
	};
elseif( ThisRealmName == "Medivh" ) then
	PropsCoderTooltips = {
		["Wizbang"] = "Devious Degenerate, Defender of the Devil";
	};
elseif( ThisRealmName == "Destromath" ) then
	PropsCoderTooltips = {
		["Alliyah"] = "High Priestess of the Alliance";
		["Brix"] = "Queen of Stealth";
	};
elseif( ThisRealmName == "Khaz'goroth" ) then
	PropsCoderTooltips = {
		["Nightslayer"] = "Member of the Demonhunters";
	};
else
		PropsCoderTooltips = { };
end

PropsTooltips = { };

-- Callback functions
function TooltipsPropsTarget_Enable(toggle)
	if(toggle == 1) then 
		UUI_PROPS_ENABLE = 1;
	else
		UUI_PROPS_ENABLE = nil;
	end
end

 
function TooltipsPropsTarget_ModifyTooltip(type)
		local name = UnitName("mouseover");
		if (name) then
			local oldTip = GameTooltipTextLeft2:GetText();
			if (oldTip) then
				local TargetClass = UnitClass("mouseover");
				if (TargetClass and UnitIsDeadOrGhost("mouseover")) then
					GameTooltipTextLeft2:SetText(oldTip.." ("..TargetClass..")");
				end
				local coder = PropsCoderTooltips[name];
				if (coder) then
					GameTooltip:AddLine(coder,1.0,1.0,1.0);
					--GameTooltipTextLeft3:SetText(coder);
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

--[[ old style
function TooltipsPropsTarget_ModifyTooltip(type)
		local name = GameTooltipTextLeft1:GetText();
		if (name) then
			local oldTip = GameTooltipTextLeft2:GetText();
			if (oldTip) then
				local coder = PropsCoderTooltips[name];
				if (coder) then
					--GameTooltipTextLeft2:SetText(oldTip..coder);
					GameTooltip:AddLine(coder,1.0,1.0,1.0);
					--GameTooltipTextLeft3:SetText(coder);
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
]]--


-- OnFoo functions

function TooltipsPropsTarget_OnLoad()
	--Print("SocialSendMessage_OnLoad.");

	-- Register with the UltimateUIMaster
	if(UltimateUI_RegisterConfiguration ~= nil) then
		UltimateUI_RegisterConfiguration(
			"UUI_TOOLTIPSBASE",
			"SECTION",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		UltimateUI_RegisterConfiguration(
			"UUI_TOOLTIPSBASE_SEP",
			"SEPARATOR",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);

		UltimateUI_RegisterConfiguration(
			"UUI_PROPS_ENABLE",	--CVar
			"CHECKBOX",						--Things to use
			TEXT(UUI_PROPS_ENABLE_TEXT),
			TEXT(UUI_PROPS_INFO),
			TooltipsPropsTarget_Enable,		--Callback
			1							--Default Checked/Unchecked
			);
		UltimateUI_RegisterChatCommand(
			"PropsAdder",
			{"/label"},
			TooltipsPropsTarget_ChatCommandHandler,
			"Adds a custom title to a player's tooltip. Usage: /label PlayerName Their Title"
			);
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
