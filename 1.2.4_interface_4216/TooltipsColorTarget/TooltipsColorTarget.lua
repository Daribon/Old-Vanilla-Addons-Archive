TooltipsColorTarget_ENABLE=1;
TooltipsColorGuildTarget_ENABLE=1;
TooltipsColorPartyTarget_ENABLE=1;

function TooltipsColorTarget_UnitHandler(type)
	if(UnitExists(type)) then
		if (not TooltipsBase_IsNewbieTip()) then
			local r, g, b = GameTooltip_UnitColor(type);
			local changed = nil;
			if (TooltipsColorTarget_ENABLE == 1) then
				-- Set it back to blue for players
				if(r == 1 and g == 1 and b == 1) then
					r = 0;
					g = 0;
				end
				changed = 1;
			end
			if (TooltipsColorGuildTarget_ENABLE == 1) then
				-- set tooltip bg to a diffrent color for guild members
				local playerGuild = GetGuildInfo("Player");
				-- if the player is in a guild, and the 'type' is in the same guild
				if (playerGuild and playerGuild ~= "" and GetGuildInfo(type) == playerGuild ) then
					r = 0.4;
					g = 1.0;
					b = 1.0;
					changed = 1;
				end
			end
			if (TooltipsColorPartyTarget_ENABLE == 1) then
				-- set tooltip bg to a diffrent color for party members
				if (UnitInParty(type) ) then
					r = 0.8;
					g = 0.4;
					b = 1.0;
					changed = 1;
				end
			end
			if (changed) then
				GameTooltip:SetBackdropColor(r, g, b);
				GameTooltipTextLeft1:SetTextColor(1, 1, 1);	
			end

		end
	end

end

function TooltipsColorTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsColorTarget_ENABLE = 1;
	else
		TooltipsColorTarget_ENABLE = nil;
	end
end

function TooltipsColorGuildTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsColorGuildTarget_ENABLE = 1;
	else
		TooltipsColorGuildTarget_ENABLE = nil;
	end
end

function TooltipsColorPartyTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsColorPartyTarget_ENABLE = 1;
	else
		TooltipsColorPartyTarget_ENABLE = nil;
	end
end

function TooltipsColorTarget_OnLoad()
	if(Cosmos_RegisterConfiguration) then
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
			"COS_COLORTARGET_C",
			"CHECKBOX",
			COLORTARGET_ENABLE,
			COLORTARGET_ENABLE_INFO,
			TooltipsColorTarget_Toggle,
			0
			);
		Cosmos_RegisterConfiguration(
			"COS_COLORGUILDTARGET_C",
			"CHECKBOX",
			COLORGUILDTARGET_ENABLE,
			COLORGUILDTARGET_ENABLE_INFO,
			TooltipsColorGuildTarget_Toggle,
			0
			);
		Cosmos_RegisterConfiguration(
			"COS_COLORPARTYTARGET_C",
			"CHECKBOX",
			COLORPARTYTARGET_ENABLE,
			COLORPARTYTARGET_ENABLE_INFO,
			TooltipsColorPartyTarget_Toggle,
			0
			);
	else
		-- add stand alone here
	end
   
Sea.util.hook("TooltipsBase_UnitHandler","TooltipsColorTarget_UnitHandler","after");
end


