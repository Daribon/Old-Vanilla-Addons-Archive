-- Nurfed Unit Frames Events

function Nurfed_UnitFrames_OnLoad()
	this:RegisterEvent("UNIT_PVP_UPDATE");
	this:RegisterEvent("UNIT_NAME_UPDATE");

	Nurfed_ToT_Elapsed = 0;
end

function Nurfed_UnitFrames_OnEvent(event)
	if (event == "UNIT_PVP_UPDATE") then
		Nurfed_UpdatePvP(arg1);
		return;
	end
	if (event == "UNIT_NAME_UPDATE") then
		Nurfed_UnitUpdateName(arg1);
		return;
	end
end

function Nurfed_UnitUpdateName(unit)
	local text;
	local name = UnitName(unit);
	if (not name) then return; end
	local label = getglobal("Nurfed_"..unit.."Name");
	if ( (unit == "player") or (unit == "pet") ) then
		text = UnitLevel(unit).." "..name;
	elseif (unit == "target") then
		text = name;
	elseif (unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4") then
		local id = this:GetID();
		local binding = KeyBindingFrame_GetLocalizedName(GetBindingKey("TARGETPARTYMEMBER"..id), "KEY_");
		local classcolor = Nurfed_UnitClass[UnitClass(unit)];
		text = binding.." |cff"..classcolor..name.."|r";
	end
	if (label) then
		label:SetText(text);
	end
end

function Nurfed_ToT_OnUpdate(arg1)
	Nurfed_ToT_Elapsed = Nurfed_ToT_Elapsed + arg1;
	if (Nurfed_ToT_Elapsed > NURFED_TOT_UPDATERATE ) then
		Nurfed_Update_ToT("targettarget");
		Nurfed_Update_ToT("targettargettarget");
		Nurfed_Update_ToT("pettarget");
	end
end
