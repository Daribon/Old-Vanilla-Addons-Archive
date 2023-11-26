--------------------------------------------------------------------------
-- AltInvite.lua 
--------------------------------------------------------------------------
--[[
AltInvite

author: <zespri@mail.ru>

-Alt-click on a player name in chat to invite him/her in your group.

]]--

AltInvite_Enabled = true;

function AltInvite_SetItemRef (link)
	if ( strsub(link, 1, 6) == "player" ) and AltInvite_Enabled then
		local name = strsub(link, 8);
		if ( name and (strlen(name) > 0) ) then
			if ( IsAltKeyDown() ) then
				InviteByName(name);
				return false;
			end
		end
	end
	return true;
end

Sea.util.hook("SetItemRef", "AltInvite_SetItemRef", "hide");


function AltInvite_OnLoad()
	if (Khaos) then
		AltInvite_Register_Khaos();
	end
end

function AltInvite_Register_Khaos()
	local optionSet = {
		id="AltInvite";
		text=ALTINVITE_CONFIG_HEADER;
		helptext=ALTINVITE_CONFIG_HEADER_INFO;
		difficulty=1;
		options={
			{
				id="Header";
				text=ALTINVITE_CONFIG_HEADER;
				helptext=ALTINVITE_CONFIG_HEADER_INFO;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="AltInviteEnable";
				type=K_TEXT;
				text=ALTINVITE_ENABLED;
				helptext=ALTINVITE_ENABLED_INFO;
				callback=function(state) if (state.checked) then AltInvite_Enabled = true; else AltInvite_Enabled = nil; end end;
				feedback=function(state) return ALTINVITE_ENABLED_INFO; end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
		};
	};
	Khaos.registerOptionSet(
		"chat",
		optionSet
	);
end
