CT_PartyFrame_ShowDrag = nil;

CT_oldPMF_UM = PartyMemberFrame_UpdateMember;
function CT_newPMF_UM()
	CT_oldPMF_UM();
	if ( this:IsVisible() and CT_MF_ShowFrames ) then
		getglobal("CT_PartyFrame" .. this:GetID() .. "_Drag"):Show();
	else
		getglobal("CT_PartyFrame" .. this:GetID() .. "_Drag"):Hide();
	end
end
PartyMemberFrame_UpdateMember = CT_newPMF_UM;

CT_AddMovable("CT_PartyFrame1_Drag", "TOPLEFT", "TOPLEFT", "UIParent", 50, -131, function(status)
	CT_PartyFrame_UpdateMembers();
end);

CT_AddMovable("CT_PartyFrame2_Drag", "TOPLEFT", "TOPLEFT", "CT_PartyFrame1_Drag", 0, -63);

CT_AddMovable("CT_PartyFrame3_Drag", "TOPLEFT", "TOPLEFT", "CT_PartyFrame2_Drag", 0, -63);

CT_AddMovable("CT_PartyFrame4_Drag", "TOPLEFT", "TOPLEFT", "CT_PartyFrame3_Drag", 0, -63);

function CT_PartyFrame_UpdateMembers()
	for i = 1, 4, 1 do
		if ( i <= GetNumPartyMembers() and CT_MF_ShowFrames ) then
			getglobal("CT_PartyFrame" .. i .. "_Drag"):Show();
		else
			getglobal("CT_PartyFrame" .. i .. "_Drag"):Hide();
		end
	end
end