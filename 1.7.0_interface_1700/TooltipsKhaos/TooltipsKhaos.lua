--[[
	Tooltips for Khaos
	 	Because dirt makes poor lubricant
	
	By: AlexanderYoshi
	Special Thanks: Celandro for the original code
	
	This is a series of tooltip modification, 
	compiled into one addon because the old one
	was not written for extensibility.
	
	$Id$
	$Rev$
	$LastChangedBy$
	$Date$
]]--

-- Globals
TooltipsFunctions_Original_GameTooltip_ClearMoney = nil;

-- Presets :-)
PropsTooltips = {
	cenarius={
		["xott"] = "Thottbot Lord";
		["thott"] = "Thottbot Lord";
		["celandro"] = "Cosmos Developer";
	};
	daggerspine={
		["khaelon"] = "Cosmos Warlock";
		["naarolla"] = "Mango Maniac";
	};
	blackrock={
		["alexander"] = "Cosmos Lead";
	};
	silvermoon={
		["graby"] = "Cosmos Frenchie";
		["vjeux"] = "Cosmos Frenchie";
		["boulay"] = "Cosmos Frenchie";
		["sarf"] = "Cosmos Bugsquasher";
		["fras"] = "Cosmos Bugsquasher";
		["rafs"] = "Cosmos Bugsquasher";
		["pren"] = "Cosmos Bugsquasher";
		["legorol"] = "Cosmos Bughunter";
	};
	stormscale={
		["hodd"] = "Cosmos Debugger";
	};
};

PropsCoderTooltips = {
	["khaelon"] = " Coder";
	["alexyoshi"] = " Coder";
	["draelor"] = " Coder";
	["thott"] = " Coder";
	["xott"] = " Coder";
	["darkwing"] = " Coder";
	["scree"] = " Coder";
	["celandro"] = " Coder";
}

--[[ Stores the Addon's State ]]--
TooltipsData = {
	enabled=true;
	isNewbie=false;
	myHandlers={};
};

--[[ Contains API for Tooltips ]]--
TooltipsFunctions={
	--
	-- addHandler ( 
	-- 	{	
	-- 		id, -- Custom ID unique to this handler
	-- 		func, -- Function called on unit mouseover
	-- 		text, -- Checkbox text for that handler
	-- 		helptext, -- Mouseover text for that handler
	-- 		default, -- default state (true/false)
	-- 		featureName, -- String describing the feature "featureName enabled"
	-- 		keyword 	-- String keyword used for the /tooltip command
	-- 	);
	-- 	
	-- 	Adds a custom handler for this tooltip customization
	--
	addHandler = function(handler)
		local fail = false;
		if ( not handler.id ) then
			Sea.io.error("No \"id\" for TooltipExtension! Called from ",this:GetName());
			fail=true;
		elseif ( not handler.func ) then
			Sea.io.error("No \"func\" for TooltipExtension! You must have a func to be called when the tooltip show event occurs. Called from ",this:GetName());
			fail=true;
		elseif ( not handler.text ) then
			Sea.io.error("No \"text\" for TooltipExtension! You must have a short description for the tooltip extension. Called from ",this:GetName());
			fail=true;
		elseif ( not handler.helptext ) then
			Sea.io.error("No \"helptext\" for TooltipExtension! You want your users to know what they're doing, right? Called from ",this:GetName());
			fail=true;
		elseif ( not handler.featureName ) then
			Sea.io.error("No \"featureName\" string for TooltipExtension! You should have a simple term for this feature. Called from ",this:GetName());
			fail=true;
		elseif ( not handler.keyword ) then
			Sea.io.error("No \"keyword\" for TooltipExtension! Users need a keyword for when the /command is called. Called from ",this:GetName());
			fail=true;
		elseif ( not handler.default ) then
			handler.default=true;
		end

		if ( fail ) then return false; end

		-- Add the handler
		TooltipsData.myHandlers[handler.id] = handler;
		return true;

	end;
	
	-- fix the size and remove blank lines
	-- note that blank lines can still be created by setting the string to ""
	MouseoverFixSize = function()
		local tooltipName = "GameTooltip";
		local newWidth = 0;
		local newHeight = 20;
		local lastValid = 0;
		for i = 1, 20 do
			local checkText = getglobal(tooltipName.."TextLeft"..i);
			if (checkText and checkText:IsVisible()) then
				local width = checkText:GetWidth() + 24;
				if (width > newWidth) then
					newWidth = width;
				end
				newHeight = newHeight + checkText:GetHeight() + 2;
				lastValid = lastValid + 1;
				if (lastValid ~= i) then
					local moveText = getglobal(tooltipName.."TextLeft"..lastValid);
					if (moveText ~= nil) then
						moveText:SetText(checkText:GetText());
						moveText:Show();
						checkText:SetText("");
						checkText:Hide();
					end
				end
			end
		end

		GameTooltip:SetWidth(newWidth);
		GameTooltip:SetHeight(newHeight);
	end;
	
	IsNewbieTip = function()
		return TooltipsData.isNewbie;
	end;

	GameTooltip_AddNewbieTip = function(normalText, r, g, b, newbieText, noNormalText)
		if ( SHOW_NEWBIE_TIPS == "1" ) then
			TooltipsData.isNewbie = true;
		else
			TooltipsData.isNewbie = false;
		end
	end;
	GameTooltip_SetUnit = function(this,unit)
		TooltipsFunctions.unitHandler(unit);
		TooltipsFunctions.MouseoverFixSize();
	end;
	GameTooltip_OnHide = function ()
		TooltipsData.isNewbie = false;
	
		if ( TooltipsData.enabled ) then
			TooltipsFunctions_Original_GameTooltip_ClearMoney();
		end
	end;
	GameTooltip_ClearMoney = function()
		if ( TooltipsData.enabled ) then
		   -- do nothing, this is handled in the onHide now!
		else
			TooltipsFunctions_Original_GameTooltip_ClearMoney();
		end
	end;

	-- 
	-- unitHandler
	-- 	
	-- 	The function called when the unit is mouseover
	--
	unitHandler = function(typeA)
		for k,v in TooltipsData.myHandlers do 
			if ( type(v.func) == "function" ) then 
				v.func(typeA);
			end
		end;
	end;

	-- 
	-- registerConfigurations
	--
	-- 	Registers all of the configurations with the current configuration system
	--
	registerConfigurations = function()
		local alphaOrder = Sea.table.getKeyList(TooltipsData.myHandlers);
		table.sort(alphaOrder, function(a,b) return TooltipsData.myHandlers[a].text < TooltipsData.myHandlers[b].text; end );

		local optionSet = {};
		local commandSet = {};
		local configurationSet = {
			id="Tooltips";
			text=TOOLTIPSBASE_SEP;
			helptext=TOOLTIPSBASE_SEP_INFO;
			difficulty=1;
			options=optionSet;
			commands=commandSet;
			default=false;
			callback=function(active)
				if ( active ) then 
				--	Sea.io.error("HOOKED SetUnit");
					Sea.util.hook("GameTooltip.SetUnit","TooltipsFunctions.GameTooltip_SetUnit","after");
				else
					--Sea.io.error("UNHOOKED SetUnit");
					Sea.util.unhook("GameTooltip.SetUnit","TooltipsFunctions.GameTooltip_SetUnit","after");	
				end
			end;
		}; 
	 	table.insert(
			optionSet,
			{
				id="Header";
				text=TOOLTIPSBASE_SEP;
				helptext=TOOLTIPSBASE_SEP_INFO;
				difficulty=1;
				type=K_HEADER;
			}
		);
	 	table.insert(
			optionSet,
			{
				id="Enable";
				text=TOOLTIPSBASE_ENABLE;
				helptext=TOOLTIPSBASE_ENABLE_INFO;
				difficulty=1;
				callback=function(state) TooltipsData.enabled=state.checked; end;
				feedback=function(state) 
					if ( state.checked ) then
						--Sea.io.error("ENABLE ON");
						return TOOLTIPSBASE_ON;
					else
						--Sea.io.error("ENABLE OFF");
						return TOOLTIPSBASE_OFF;
					end
				end;
				check=true;
				type=K_TEXT;
				default={
					checked=true;
				};
				disabled={
					checked=false;
				};
			}
		);

		for k,v in alphaOrder do 
			local handler = TooltipsData.myHandlers[v];
			local handlerId = handler.id;
			local handlerFeatureName = handler.featureName;
			local handlerCallback = handler.callback;
		 	table.insert(
				optionSet,
				{
					id=handler.id;
					text=handler.text;
					helptext=handler.helptext;
					difficulty=1;
					callback=function(state) 
						TooltipsData[handlerId]=state.checked; 
						if ( type(handlerCallback)=="function" ) then
							handlerCallback(state);
						end
					end;
					feedback=function(state) 
						if ( state.checked ) then
							return string.format(TOOLTIPS_ENABLED, handlerFeatureName);
						else
							return string.format(TOOLTIPS_DISABLED, handlerFeatureName);
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=handler.default;
					};
					disabled={
						checked=false;
					};				
					dependencies={
						Enable={checked=true;match=true};
					};
				}
			);			
		end

		Khaos.registerOptionSet("tooltip",configurationSet);
		-- Note: the line below is a temporary hack, because we are registering the
		-- config afterInit. It should be removed once Khaos runs callbacks on
		-- registration
		KhaosCore.runCallbacks(nil,{"Tooltips"});
	end;
};

-- [[ Handler for load time ]] --
function TooltipsKhaos_OnLoad()
	Sea.util.hook("GameTooltip_OnHide","TooltipsFunctions.GameTooltip_OnHide","after");
	Sea.util.hook("GameTooltip_AddNewbieTip","TooltipsFunctions.GameTooltip_AddNewbieTip","after");
	Sea.util.hook("GameTooltip.SetUnit","TooltipsFunctions.GameTooltip_SetUnit","after");
	--We need to know when the mouseover unit has changed, so we can update the tooltip then
	this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	
	-- fix for clear money
	TooltipsFunctions_Original_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
	GameTooltip_ClearMoney = TooltipsFunctions.GameTooltip_ClearMoney;

	-- RegisterConfigurations
	Chronos.afterInit(TooltipsFunctions.registerConfigurations);

	-- Default Configurations
	
	-------------------------------------
	-- Colored Target
	-------------------------------------
	
	TooltipsFunctions.UnitColor = function (unit, original)
		if ( TooltipsData.ColorTarget and not original ) then
			return false, { 1, 1, 1 };
		else
			return true;
		end
	end;
	
	TooltipsFunctions.addHandler ( 
	 	{	
	 		id="ColorTarget", -- Custom ID unique to this handler
	 		func=function(type) -- Function called on unit mouseover
	if(UnitExists(type)) then
		if (not TooltipsFunctions.IsNewbieTip()) then
			local r, g, b = GameTooltip_UnitColor(type, true);
			local changed = false;
			if (TooltipsData.ColorTarget) then
				-- Set it back to blue for players
				if(r == 1 and g == 1 and b == 1) then
					r = 0;
					g = 0;
				end
				changed = true;
			end
			if (TooltipsData.ColorGuildTarget ) then
				-- set tooltip bg to a diffrent color for guild members
				local playerGuild = GetGuildInfo("Player");
				-- if the player is in a guild, and the 'type' is in the same guild
				if (playerGuild and playerGuild ~= "" and GetGuildInfo(type) == playerGuild ) then
					r = 0.4;
					g = 1.0;
					b = 1.0;
					changed = true;
				end
			end
			if (TooltipsData.ColorPartyTarget) then
				-- set tooltip bg to a diffrent color for party members
				if (UnitInParty(type) ) then
					r = 0.8;
					g = 0.4;
					b = 1.0;
					changed = true;
				end
			end
			
			if (changed) then
				GameTooltip:SetBackdropColor(r, g, b);
			end
		end
	end
				
			end;
			callback=function(state)
				if ( state.checked ) then 
					Sea.util.hook("GameTooltip_UnitColor","TooltipsFunctions.UnitColor","replace");
				else
					Sea.util.unhook("GameTooltip_UnitColor","TooltipsFunctions.UnitColor","replace");
				end	
			end;
	 		text=COLORTARGET_ENABLE, -- Checkbox text for that handler
	 		helptext=COLORTARGET_ENABLE_INFO, -- Mouseover text for that handler
	 		default=true, -- default state (true/false)
	 		featureName=COLORTARGET_FEATURENAME, -- String describing the feature "featureName enabled"
	 		keyword=COLORTARGET_KEYWORD 	-- String keyword used for the /tooltip command
		}
 	);
	
	-------------------------------------
	-- Guild Target Label
	-------------------------------------
	
	TooltipsFunctions.addHandler ( 
	 	{	
	 		id="GuildLabel", -- Custom ID unique to this handler
	 		func=function(type) -- Function called on unit mouseover				
				if (TooltipsData.GuildLabel) then
					if(UnitExists(type)) then
						local guild = GetGuildInfo(type);
						if ( guild ) then
							GameTooltip:AddLine(string.format("<%s>", guild));
						end
					end
				end			
			end;
	 		text=GUILDTARGET_ENABLE , -- Checkbox text for that handler
	 		helptext=GUILDTARGET_ENABLE_INFO, -- Mouseover text for that handler
	 		default=true, -- default state (true/false)
	 		featureName=GUILDTARGET_FEATURENAME, -- String describing the feature "featureName enabled"
	 		keyword=GUILDTARGET_KEYWORD	-- String keyword used for the /tooltip command
		}
 	);	-------------------------------------
	-- Colored Guild Target
	-------------------------------------
	
	TooltipsFunctions.addHandler ( 
	 	{	
	 		id="ColorGuildTarget", -- Custom ID unique to this handler
	 		func=function(type) -- Function called on unit mouseover				
			end;
	 		text=COLORGUILDTARGET_ENABLE, -- Checkbox text for that handler
	 		helptext=COLORGUILDTARGET_ENABLE_INFO, -- Mouseover text for that handler
	 		default=true, -- default state (true/false)
	 		featureName=COLORGUILDTARGET_FEATURENAME, -- String describing the feature "featureName enabled"
	 		keyword=COLORGUILDTARGET_KEYWORD	-- String keyword used for the /tooltip command
		}
 	);
	
	-------------------------------------
	-- Colored Party Target
	-------------------------------------
	
	TooltipsFunctions.addHandler ( 
	 	{	
	 		id="ColorPartyTarget", -- Custom ID unique to this handler
	 		func=function(type) -- Function called on unit mouseover
				
			end;
	 		text=COLORPARTYTARGET_ENABLE, -- Checkbox text for that handler
	 		helptext=COLORPARTYTARGET_ENABLE_INFO, -- Mouseover text for that handler
	 		default=true, -- default state (true/false)
	 		featureName=COLORPARTYTARGET_FEATURENAME, -- String describing the feature "featureName enabled"
	 		keyword=COLORPARTYTARGET_KEYWORD 	-- String keyword used for the /tooltip command
		}
 	);
	
	-------------------------------------
	-- Player Target
	-------------------------------------
	
	TooltipsFunctions.addHandler ( 
	 	{	
	 		id="PlayerTarget", -- Custom ID unique to this handler
	 		func=function(type) -- Function called on unit mouseover
				if (TooltipsData.PlayerTarget) then
					if(UnitExists(type)) then
						local originalText = GameTooltipTextLeft2:GetText();
						if (originalText ~= nil) then
							-- remove elite and boss designations
							local newText = string.gsub(originalText, " [(]"..PLAYERTARGET_SEARCHPATTERN.."[)]", "");
							GameTooltipTextLeft2:SetText(newText);
						end
					end
				end				
			end;
	 		text=PLAYERTARGET_ENABLE, -- Checkbox text for that handler
	 		helptext=PLAYERTARGET_ENABLE_INFO, -- Mouseover text for that handler
	 		default=true, -- default state (true/false)
	 		featureName=PLAYERTARGET_ENABLE, -- String describing the feature "featureName enabled"
	 		keyword=PLAYERTARGET_KEYWORD	-- String keyword used for the /tooltip command
		}
 	);

	
	-------------------------------------
	-- PvP Target
	-------------------------------------
	
	TooltipsFunctions.addHandler ( 
	 	{	
	 		id="PVPTarget", -- Custom ID unique to this handler
	 		func=function(type) -- Function called on unit mouseover
				if ( TooltipsData.PVPTarget ) then
					if(UnitExists(type)) then
						for i = 3, 5 do
							local tooltipTextLeft = getglobal("GameTooltipTextLeft"..i);
							local originalText = tooltipTextLeft:GetText();
							if (originalText ~= nil) then
								-- remove elite and boss designations
								local newText = string.gsub(originalText, PVPTARGET_SEARCHPATTERN, "");
								if (newText == "") then
									tooltipTextLeft:SetText(nil);
									tooltipTextLeft:Hide();
								end
							end
						end
					end
				end				
			end;
	 		text=PVPTARGET_ENABLE, -- Checkbox text for that handler
	 		helptext=PVPTARGET_ENABLE_INFO, -- Mouseover text for that handler
	 		default=true, -- default state (true/false)
	 		featureName=PVPTARGET_FEATURENAME, -- String describing the feature "featureName enabled"
	 		keyword=PVPTARGET_KEYWORD 	-- String keyword used for the /tooltip command
		}
 	);
	
	-------------------------------------
	-- Props Target
	-------------------------------------
	TooltipsFunctions.PropsTarget_ChatCommandHandler=function(msg)
		local name = string.gsub (msg, "([%w]+)[ ]?(.*)", "%1");
		local title = string.gsub (msg, "([%w]+)[ ]?(.*)", "%2");
		local realm = GetRealmName();
	
		if ( name ~= "" ) then 
			if ( title == "" ) then 
				title = nil;
			end
			PropsTooltips[string.lower(realm)][name] = title;
		end
	end
	
	if ( Sky ) then
		Sky.registerSlashCommand(
		{
			id="PropsAdder",
			commands={"/label"},
			onExecute=TooltipsFunctions.PropsTarget_ChatCommandHandler,
			helpText="Adds a custom title to a player's tooltip. Usage: /label PlayerName Their Title"
		}
		);
	else
			SLASH_PROPSADDER1 = "/label";
			SlashCmdList["PROPSADDER"] = function (msg)
				TooltipsFunctions.PropsTarget_ChatCommandHandler(msg);
			end
	end
	TooltipsFunctions.addHandler ( 
	 	{	
	 		id="PropsTarget", -- Custom ID unique to this handler
	 		func=function(type) -- Function called on unit mouseover
				if ( TooltipsData.PropsTarget) then 
					local name = GameTooltipTextLeft1:GetText();
					local words = Sea.string.split(name," ");
					if ( words[table.getn(words)] ) then 
						name=words[table.getn(words)];
					end
					if (name) then
						local oldTip = GameTooltipTextLeft2:GetText();
						local realm = GetRealmName();
						if (oldTip) then
							local coder = PropsCoderTooltips[string.lower(name)];
							if (coder) then
								GameTooltipTextLeft2:SetText(oldTip..coder);
							end
						end
			
					-- Sets your own notes
						if( PropsTooltips[string.lower(realm)] ) then 
							local note = PropsTooltips[string.lower(realm)][name];
							-- check for all lower case
							if (note == nil) then
								note = PropsTooltips[string.lower(realm)][string.lower(name)];
							end
							if (note) then 
								GameTooltip:AddLine(note,1.0,1.0,1.0);
							end
						end
					end
				end
			end;
	 		text=PROPS_ENABLE_TEXT, -- Checkbox text for that handler
	 		helptext=PROPS_ENABLE_INFO, -- Mouseover text for that handler
	 		default=true, -- default state (true/false)
	 		featureName=PROPS_FEATURENAME, -- String describing the feature "featureName enabled"
	 		keyword=PROPS_ENABLE 	-- String keyword used for the /tooltip command
		}
 	);
end
--[[ Event Handler In Case Needed ]]--
function TooltipsKhaos_OnEvent()
	if (event == "UPDATE_MOUSEOVER_UNIT") then
		TooltipsFunctions.GameTooltip_SetUnit(GameTooltip,"mouseover");
	end
end
