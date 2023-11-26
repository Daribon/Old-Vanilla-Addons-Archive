--[[
	MissingHP.lua

	This Addon adds a small frame to each party bar that displays how much HP the group member is missing.
]]

function MissingHP_setup ()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function MissingHP_OnEvent (event)
	if (event == "UNIT_HEALTH" or event == "PARTY_MEMBERS_CHANGED" or event == "PARTY_LEADER_CHANGED") then
		MissingHP_calc();
		return;
	end
	if(event == "PLAYER_ENTERING_WORLD") then
		MissingHP_Compat();
		return;
	end
end

function MissingHP_calc ()
	local id = this:GetID();
	local MissingHP_string = getglobal("MissingHP_"..id.."Text");
	if (GetPartyMember(id)) then
		MissingHP_string:SetText("-"..(UnitHealthMax("party"..id) - UnitHealth("party"..id)));
	else
		return;
	end
end

function MissingHP_Compat ()
	local id
	if (Gypsy_PartyFrameSetup) then
		for id = 1,4 do
			local MissingHP_ChangeAnchor = getglobal("MissingHP_"..id);
			MissingHP_ChangeAnchor:ClearAllPoints();
			MissingHP_ChangeAnchor:SetPoint("LEFT", "PartyMemberFrame"..id, "RIGHT", 0, 0);
		end
	end
end