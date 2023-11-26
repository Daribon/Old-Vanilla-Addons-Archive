--[[
-- 
-- GuildedListGUI is the Guilded member list sub-frame user interface
--
--]]
GUILDED_LIST_MEMBERS_TO_DISPLAY = 17;
GUILDED_LIST_FRAME_HEIGHT = 68;

GuildedListGUI = {
    --[[
    -- onUpdate()
    --     Update the member list sub-frame display
    --]]
    onUpdate = function()
    	local button;
    	local guildedListOffset = FauxScrollFrame_GetOffset(GuildedListScrollFrame);
    	local index;
    	local showScrollBar = nil;
    	if ( GuildedData.numMembers > GUILDED_LIST_MEMBERS_TO_DISPLAY ) then
	    	showScrollBar = 1;
	    end

		GuildedListFrameTotals:SetText(format(GetText("GUILDED_LIST_FRAME_TOTAL_TEMPLATE", nil, GuildedData.numMembers), GuildedData.numMembers));

		-- Check if selected member has left.
		if ( GuildedData.findMember(GuildedListFrame.selectedName) < 0 ) then
		    GuildedListFrame.selectedName = nil;
		end
	    GuildedListFrame.selectedMember = nil;
		
		local i = 1;
		local member;
    	for index = 1 + guildedListOffset, guildedListOffset + GUILDED_LIST_MEMBERS_TO_DISPLAY do
		    if ( index > GuildedData.numMembers ) then
			    break;
			end
		    member = GuildedData.members[index];
    		button = getglobal("GuildedListFrameButton"..i);
    		button.index = index;
    		getglobal("GuildedListFrameButton"..i.."Name"):SetText(member.name);
	    	getglobal("GuildedListFrameButton"..i.."Guild"):SetText(member.guild);
	    	getglobal("GuildedListFrameButton"..i.."Level"):SetText(member.level);
		    getglobal("GuildedListFrameButton"..i.."Class"):SetText(member.class);
		
    		-- If need scrollbar resize columns
	    	if ( showScrollBar ) then
		    	getglobal("GuildedListFrameButton"..i.."Guild"):SetWidth(95);
    		else
	    		getglobal("GuildedListFrameButton"..i.."Guild"):SetWidth(110);
		    end
			
			if ( GuildedListFrame.selectedName == member.name ) then
			    GuildedListFrame.selectedMember = index;
			end

    		-- Highlight the correct who
	    	if ( GuildedListFrame.selectedMember == index ) then
		    	button:LockHighlight();
    		else
	    		button:UnlockHighlight();
		    end
		
   			button:Show();
			
			i = i + 1;
			if (i > GUILDED_LIST_MEMBERS_TO_DISPLAY) then
			    break;
		    end
		end
		
		while ( i <= GUILDED_LIST_MEMBERS_TO_DISPLAY ) do
		    getglobal("GuildedListFrameButton"..i):Hide();
			i = i + 1;
		end

    	if ( not GuildedListFrame.selectedMember ) then
		    GuildedListFrameWhisperButton:Disable();
		    GuildedListFrameAddFriendButton:Disable();
		    GuildedListFrameGroupInviteButton:Disable();
	    else
	    	GuildedListFrameWhisperButton:Enable();
	    	GuildedListFrameAddFriendButton:Enable();
	    	GuildedListFrameGroupInviteButton:Enable();
	    end

    	-- If need scrollbar resize column headers
    	if ( showScrollBar ) then
	    	GuildedSetColumnWidth(105, GuildedListFrameColumnHeader2);
    	else
	    	GuildedSetColumnWidth(120, GuildedListFrameColumnHeader2);
    	end

    	-- ScrollFrame update
	    FauxScrollFrame_Update(GuildedListScrollFrame, GuildedData.numMembers, GUILDED_LIST_MEMBERS_TO_DISPLAY, GUILDED_LIST_FRAME_HEIGHT );
    end;

	
    --[[
    -- onListButtonClick()
    --     Select the Guilded member that has been clicked on
    --]]
    onListButtonClick = function()
    	GuildedListFrame.selectedMember = getglobal("GuildedListFrameButton"..this:GetID()).index;
	    GuildedListFrame.selectedName = getglobal("GuildedListFrameButton"..this:GetID().."Name"):GetText();
    	GuildedListGUI.onUpdate();
    end;
	
    --[[
    -- onEditBoxEnterPressed()
    --     Send text in edit box to the Guilded channel
    --]]
	onEditBoxEnterPressed = function()
    	Guilded.sendChatMsg(GuildedListFrameEditBox:GetText());
		GuildedListFrameEditBox:SetText("");
    end;
};
