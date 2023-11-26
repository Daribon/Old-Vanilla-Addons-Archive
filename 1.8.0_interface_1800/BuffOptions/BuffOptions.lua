--[[
	Buff Options
	 	Provides additional options for buffs display
	
	By: Mugendai
	Special Thanks:
	    GotMoo - For MooBuffMod, the inspiration for most buff mods
	    Zespri - For many ideas, and testing, and more
	Contact: mugekun@gmail.com
	
	BuffOptions is an addon that allows you to
	customize the display and behavior of your buffs.
	It allows you to stack your buffs vertically
	reverse them, swap their position with the debuffs
	show reminders when a buff is about to expire, and more.
	
	$Id: BuffOptions.lua 2690 2005-10-25 01:49:24Z mugendai $
	$Rev: 2690 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-24 20:49:24 -0500 (Mon, 24 Oct 2005) $
]]--

--------------------------------------------------
--
-- BuffOptions Declaration
--
--------------------------------------------------
BuffOptions = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	VERSION = 1.07;
};
--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
--Main Configuration variable
BuffOptions_Config = {
	Reverse = 0;																			--Make the buffs stack in reverse order
	Swap = 0;																					--Swap the position of the buffs/debuffs
	Border = 0;																				--Should we show a background and border around each buff
	Size = 1;																					--Size of the buffs
	Vertical = 0;																			--Make the buffs stack vertically
	SideTime = 0; 																		--Put the expiration time on the side of the buffs
	Text = 0;																					--Show the name of the buff to the side of it
	DebuffType = 0;																		--Show the type of DeBuff instead of it's name
	NoRight = 0;																			--If enabled will not move the buffs to the right of the screen when in vertical mode
	LongTime = 0;																			--Should we show the time in long format
	ShortTime = 0;																		--Should we show the time in short format
	FadeTime = 0;																			--Should we fade the duration along with the rest of the buff
	TextColor = {	r=NORMAL_FONT_COLOR.r;							--The color of the text
								g=NORMAL_FONT_COLOR.g;
								b=NORMAL_FONT_COLOR.b; };
	TextShortColor = {	r=HIGHLIGHT_FONT_COLOR.r;			--The color of the text when the buff has almost expired
											g=HIGHLIGHT_FONT_COLOR.g;
											b=HIGHLIGHT_FONT_COLOR.b; };
	TextSize = 1;																			--The size of the text, and duration
	Reminder = 0;																			--Let the user know when a buff is about to expire
	ReminderSound = 0;																--Sould we make a sound when reminding the user
	ReminderTime = 30;																--How many seconds before the buff expires to remind the user
	ReminderColor = {	r=1;														--The color of the reminder text
										g=0.82;
										b=0; };
	ReminderOSD = 0;																	--Should we show the reminder text in the UIErrorMessage frame
	EquipmentOnly = 0;																--Should we only show reminders for equipment buffs
	NoShort = 1;																			--Don't remind on short duration buffs
	ShortBuffTime = 30;																--How many seconds a buff must be less than or equal to be considered short
};
--Store this config for safe load
MCom.safeLoad("BuffOptions_Config");

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------

--[[ ReOrients the Buffs based on config options ]]--
BuffOptions.ReOrient = function ()
	--Setup all the variables to deal with what should be oriented to what else
	--and in what way
	local curBuff, curDur, curText, curBorder;	--These hold the objects we are working with
	local curSide, curRel, curRelSide, curX, curY;	--These hold the info for the buff
	local curDuSide, curDuRel, curDuRelSide, curDuX, curDuY, curDuJ;	--These hold the info for the duration
	local curTextSide, curTextRel, curTextRelSide, curTextX, curTextY, curTextJ;	--These hold the info for the text
	local curBoSide, curBoRel, curBoRelSide, curBoX, curBoY, curBoW, curBoH;	--These hold the info for the border
	--Side is the side of the object that will be use for placement
	--Rel is the object this object will be relative to
	--RelSide is the side of the object this object will be relative to
	--X is the X offset
	--Y is the Y offset
	--J is the horizontal justification of the text
	--W is the width
	--H is the height

	--Go through all of the buffs
	for i = 0, 23 do
		--Get the objects for this buff
		curBuff = getglobal("BuffButton"..i);
		curDur = getglobal("BuffButton"..i.."Duration");
		curText = getglobal("BuffButton"..i.."BuffOTextText");
		curBorder = getglobal("BuffButton"..i.."BuffOBorder");
		--Make sure we got the buff
		if (curBuff) then
			--Setup default placement of the buff to be to the left of the previous buff
			curRel = "BuffButton"..(i-1);
			curSide = "RIGHT";
			curRelSide = "LEFT";
			curX = -5;
			curY = 0;
			--Setup the default placement of the duration to be below the buff
			curDuSide = "TOP";
			curDuRel = "BuffButton"..i;
			curDuRelSide = "BOTTOM";
			curDuX = 0;
			curDuY = 0;
			curDuJ = "center";
			--Setup the default Text placement to be centered on the right of the buff
			curTextSide = "LEFT";
			curTextRel = "BuffButton"..i;
			curTextRelSide = "RIGHT";
			curTextX = 2;
			curTextY = 0;
			curTextJ = "left";
			--Setup the border to default to surrounding just the buff and the duration below it
			curBoSide = "TOPLEFT";
			curBoRel = "BuffButton"..i;
			curBoRelSide = "TOPLEFT";
			curBoX = -5;
			curBoY = 5;
			curBoW = 40;
			curBoH = 40;
			--If we are swapping buffs and debuffs, or if this is a debuff then setup the text to be on the left
			--and the border to extend to the left
			if ( ( ( BuffOptions_Config.Swap == 1 ) and ( i < 16 ) ) or ( ( BuffOptions_Config.Swap ~= 1 ) and ( i >= 16 ) ) ) then
				curTextSide = "RIGHT";
				curTextRelSide = "LEFT";
				curTextX = curTextX * -1;
				curTextJ = "right";
				curBoSide = "TOPRIGHT";
				curBoRelSide = "TOPRIGHT";
				curBoX = curBoX * -1;
			end
			--If we are reversing, setup the buff to stack right
			if (BuffOptions_Config.Reverse == 1) then
				curSide = "LEFT";
				curRelSide = "RIGHT";
				curX = curX * -1;
			end
			--Handle vertical orientation
			if (BuffOptions_Config.Vertical == 1) then
				--Setup the buff to stack from the top down
				curSide = "TOP";
				curRelSide = "BOTTOM";
				curX = 0;
				curY = -5;
				--Setup the duration to sit flush left under the buff
				curDuSide = "TOPLEFT";
				curDuRelSide = "BOTTOMLEFT";
				curDuJ = "left";
				--If this is a debuff, or if the buffs and debuffs are swapped, set up the duration to be flush to the right, under the buff
				if ( ( ( BuffOptions_Config.Swap == 1 ) and ( i < 16 ) ) or ( ( BuffOptions_Config.Swap ~= 1 ) and ( i >= 16 ) ) ) then
					curDuSide = "TOPRIGHT";
					curDuRelSide = "BOTTOMRIGHT";
					curDuJ = "right";
				end
				--Account for width changes from duration placement options
				if ( (BuffOptions_Config.Text == 1) or ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.LongTime == 1 ) and ( BuffOptions_Config.ShortTime ~= 1 ) ) ) then
					curBoW = curBoW + 120;
				elseif ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime == 1 ) ) then
					curBoW = curBoW + 60;
				end
				--If the durations will be showing under the buff, then make the distance between buffs and buff height accomidate this
				if ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime ~= 1 ) ) then
					curY = -15;
					curBoH = curBoH + 10;
				end
				--If we are reversing, then set the buff to stack up
				if (BuffOptions_Config.Reverse == 1) then
					curSide = "BOTTOM";
					curRelSide = "TOP";
					curX = 0;
					curY = curY * -1;
				end
				--Handle buff duration on the side
				if ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime == 1 ) ) then
					--Setup the duration to be centered on the right
					curDuSide = "LEFT";
					curDuRelSide = "RIGHT";
					curDuX = 2;
					curDuY = 0;
					--If this is a debuff or we are swapping, then move the duration to the left
					if ( ( ( BuffOptions_Config.Swap == 1 ) and ( i < 16 ) ) or ( ( BuffOptions_Config.Swap ~= 1 ) and ( i >= 16 ) ) ) then
						curDuSide = "RIGHT";
						curDuRelSide = "LEFT";
						curDuX = curDuX * -1;
						curDuJ = "right";
					end
					--Deal with displaying both text and duration
					if (BuffOptions_Config.Text == 1) then
						--Setup the text to be top right aligned on the side of the buff
						curTextY = -2;
						curTextSide = "TOP"..curTextSide;
						curTextRelSide = "TOP"..curTextRelSide;
						--Setup the duration to be bottom right aligned on the side of the buff
						curDuSide = "BOTTOMLEFT";
						curDuRelSide = "BOTTOMRIGHT";
						curDuX = 2;
						curDuY = 2;
						--If this is a debuff, or we are swapping, then move the text and duration to the right of the buff
						if ( ( ( BuffOptions_Config.Swap == 1 ) and ( i < 16 ) ) or ( ( BuffOptions_Config.Swap ~= 1 ) and ( i >= 16 ) ) ) then
							curDuSide = "BOTTOMRIGHT";
							curDuRelSide = "BOTTOMLEFT";
							curDuX = curDuX * -1;
							curDuJ = "right";
						end
					end
				end
			else
				--If we aren't vertical then expand the border to fit around the duration
				if ( SHOW_BUFF_DURATIONS == "1" ) then
					curBoH = curBoH + 10;
				end
			end

			--If this is the first buff, then align it to the top right of the buff frame(which is aligned to the left of the enchant frame)
			if (i == 0) then
				curSide = "TOPRIGHT";
				curRel = "BuffFrame";
				curRelSide = "TOPRIGHT";
				curX = 0;
				curY = 0;
				--If we are reversing, then align to the top left of the buff frame
				if (BuffOptions_Config.Reverse == 1) then
					curSide = "TOPLEFT";
					curRelSide = "TOPLEFT";
					--If we are vertical the align to the bottom right of the buff frame
					if (BuffOptions_Config.Vertical == 1) then
						curSide = "BOTTOMRIGHT";
						curRelSide = "BOTTOMRIGHT";
					end
				end
			elseif (i == 8) then
				--If this is the 9th buff, and we are horizontal, then align it below the enchant buff 1, so that we have two rows of 8 columns
				if (BuffOptions_Config.Vertical ~= 1) then
					curSide = "TOP";
					curRel = "TempEnchant1";
					curRelSide = "BOTTOM";
					curX = 0;
					curY = -5;
					--Account for the duration showing
					if (SHOW_BUFF_DURATIONS == "1") then
						curY = -15;
					end
				end
			elseif (i == 16) then
				--If this is the first debuff and we are horizontal, then align it below the 1st buff in the second row
				if (BuffOptions_Config.Vertical ~= 1) then
					curSide = "TOPRIGHT";
					curRel = "TempEnchant1";
					curRelSide = "TOPRIGHT";
					curX = 0;
					curY = -70;
					--Account for the duration showing
					if (SHOW_BUFF_DURATIONS == "1") then
						curY = -90;
					end
					--If we are swapping then put the debuff above the first enchant buff
					if (BuffOptions_Config.Swap == 1) then
						curSide = "BOTTOMRIGHT";
						curRelSide = "TOPRIGHT";
						curY = 0;
						--Account for the duration showing
						if (SHOW_BUFF_DURATIONS == "1") then
							curY = curY + 15;
						end
					end
				else
					--If we are vertical then place the first debuff on the left of the first enchant buff
					curSide = "RIGHT";
					curRel = "TempEnchant1";
					curRelSide = "LEFT";
					curX = -5;
					curY = 0;
					--If we are swapping, then place it on the right instead
					if (BuffOptions_Config.Swap == 1) then
						curSide = "LEFT";
						curRelSide = "RIGHT";
						curX = curX * -1;
					end
				end
			end
			--Use the calculated values to orient the buff, duration, text, and border
			curBuff:ClearAllPoints();
			curBuff:SetPoint(curSide, curRel, curRelSide, curX, curY);
			if (curDur) then
				curDur:ClearAllPoints();
				curDur:SetPoint(curDuSide, curDuRel, curDuRelSide, curDuX, curDuY);
				curDur:SetWidth(curBoW);
				curDur:SetJustifyH(curDuJ);
			end
			if (curText) then
				curText:ClearAllPoints();
				curText:SetPoint(curTextSide, curTextRel, curTextRelSide, curTextX, curTextY);
				curText:SetWidth(curBoW);
				curText:SetJustifyH(curTextJ);
			end
			if (curBorder) then
				curBorder:SetWidth(curBoW);
				curBorder:SetHeight(curBoH);
				curBorder:ClearAllPoints();
				curBorder:SetPoint(curBoSide, curBoRel, curBoRelSide, curBoX, curBoY);
			end
		end
	end

	--Handle the orientation for the enchant buffs(as in weapon buffs)
	for i = 1, 2 do
		--Get the buff's objects
		curBuff = getglobal("TempEnchant"..i);
		curDur = getglobal("TempEnchant"..i.."Duration");
		curText = getglobal("TempEnchant"..i.."BuffOTextText");
		curBorder = getglobal("TempEnchant"..i.."BuffOBorder");
		if (curBuff) then
			--Set the duration to default centered below the buff
			curDuSide = "TOP";
			curDuRel = "TempEnchant"..i;
			curDuRelSide = "BOTTOM";
			curDuX = 0;
			curDuY = 0;
			curDuJ = "center";
			--Set the text to default centered to the right of the buff
			curTextSide = "LEFT";
			curTextRel = "TempEnchant"..i;
			curTextRelSide = "RIGHT";
			curTextX = 2;
			curTextY = -2;
			curTextJ = "left";
			--Set the border to default surrounding the buff
			curBoSide = "TOPLEFT";
			curBoRel = "TempEnchant"..i;
			curBoRelSide = "TOPLEFT";
			curBoX = -5;
			curBoY = 5;
			curBoW = 40;
			curBoH = 40;
			--If we are swapping then move the text to the left, and expand the border to the left
			if ( BuffOptions_Config.Swap == 1 ) then
				curTextSide = "RIGHT";
				curTextRelSide = "LEFT";
				curTextX = curTextX * -1;
				curTextJ = "right";
				curBoSide = "TOPRIGHT";
				curBoRelSide = "TOPRIGHT";
				curBoX = curBoX * -1;
			end
			--Handle vertical orientation
			if (BuffOptions_Config.Vertical == 1) then
				--Set the duration to be left aligned under the buff
				curDuSide = "TOPLEFT";
				curDuRelSide = "BOTTOMLEFT";
				curDuJ = "left";
				--If we are swapping then set the duration right aligned under the buff
				if ( BuffOptions_Config.Swap == 1 ) then
					curDuSide = "TOPRIGHT";
					curDuRelSide = "BOTTOMRIGHT";
					curDuJ = "right";
				end
				--Handle the time being on the side
				if (BuffOptions_Config.SideTime == 1) then
					--Center the duration on the right of the buff
					curDuSide = "LEFT";
					curDuRelSide = "RIGHT";
					curDuX = 2;
					curDuY = 0;
					curDuJ = "left";
					--If we are swapping then move the duration to the left of the buff
					if (BuffOptions_Config.Swap == 1) then
						curDuSide = "RIGHT";
						curDuRelSide = "LEFT";
						curDuX = curDuX * -1;
						curDuJ = "right";
					end
					--Handle showing of text and duration
					if (BuffOptions_Config.Text == 1) then
						--Move the text to be top right on the side of the buff, and the duration to be bottom right on the side of the buff
						curTextSide = "TOP"..curTextSide;
						curTextRelSide = "TOP"..curTextRelSide;
						curDuSide = "BOTTOMLEFT";
						curDuRelSide = "BOTTOMRIGHT";
						curDuX = 2;
						curDuY = 2;
						curDuJ = "left";
						--If swapping, then move the text and duration to the left of the buff
						if (BuffOptions_Config.Swap == 1) then
							curDuSide = "BOTTOMRIGHT";
							curDuRelSide = "BOTTOMLEFT";
							curDuX = curDuX * -1;
							curDuJ = "right";
						end
					end
				end
				--Handle expanding the border to fit the text and duration settings
				if ( (BuffOptions_Config.Text == 1) or ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.LongTime == 1 ) and ( BuffOptions_Config.ShortTime ~= 1 ) ) ) then
					curBoW = curBoW + 120;
				elseif ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime == 1 ) ) then
					curBoW = curBoW + 60;
				end
				--If we are showing the durations on the bottom, then increase the border height
				if ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime ~= 1 ) ) then
					curBoH = curBoH + 10;
				end
			else
				--Increase the border height to deal with the time on the bottom
				if ( SHOW_BUFF_DURATIONS == "1" ) then
					curBoH = curBoH + 10;
				end
			end
			--If this is the first enchant buff, then place it at the top right of the enchant frame(which is the top right of the buffs in genral)
			if (i == 1) then
				curSide = "TOPRIGHT";
				curRel = "TemporaryEnchantFrame";
				curRelSide = "TOPRIGHT";
				curX = 0;
				curY = 0;
				--If we are reversing, then put it at the top left of the enchant frame
				if (BuffOptions_Config.Reverse == 1) then
					curSide = "TOPLEFT";
					curRelSide = "TOPLEFT";
					--If we are vertical and reverse then put it at the bottom right of the enchant frane
					if (BuffOptions_Config.Vertical == 1) then
						curSide = "BOTTOMRIGHT";
						curRelSide = "BOTTOMRIGHT";
						--Account for duration being on the bottom
						if ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime ~= 1 ) ) then
							curY = 10;
						end
					end
				end
			end
			--If this is the second enchant buff, place it to the left of the first
			if (i == 2) then
				curSide = "RIGHT";
				curRel = "TempEnchant1";
				curRelSide = "LEFT";
				curX = -5;
				curY = 0;
				--If we are reversing place it to the right of the first
				if (BuffOptions_Config.Reverse == 1) then
					curSide = "LEFT";
					curRelSide = "RIGHT";
					curX = curX * -1;
				end
				--If we are vertical put it below the first
				if (BuffOptions_Config.Vertical == 1) then
					curSide = "TOP";
					curRelSide = "BOTTOM";
					curX = 0;
					curY = -5;
					--Account for duaration on the bottom
					if ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime ~= 1 ) ) then
						curY = -15;
					end
					--If we are reversing then place it above the first
					if (BuffOptions_Config.Reverse == 1) then
						curSide = "BOTTOM";
						curRelSide = "TOP";
						curY = curY * -1;
					end
				end
			end
			--Use the calculated values to orient the buff
			curBuff:ClearAllPoints();
			curBuff:SetPoint(curSide, curRel, curRelSide, curX, curY);
			if (curDur) then
				curDur:ClearAllPoints();
				curDur:SetPoint(curDuSide, curDuRel, curDuRelSide, curDuX, curDuY);
				curDur:SetWidth(curBoW);
				curDur:SetJustifyH(curDuJ);
			end
			if (curText) then
				curText:ClearAllPoints();
				curText:SetPoint(curTextSide, curTextRel, curTextRelSide, curTextX, curTextY);
				curText:SetWidth(curBoW);
				curText:SetJustifyH(curTextJ);
			end
			if (curBorder) then
				curBorder:SetWidth(curBoW);
				curBorder:SetHeight(curBoH);
				curBorder:ClearAllPoints();
				curBorder:SetPoint(curBoSide, curBoRel, curBoRelSide, curBoX, curBoY);
			end
		end
	end
	--Update the position and borders of all the buffs
	BuffOptions.RePosition();
	BuffOptions.UpdateBorder();
end

--[[ Repositions the buffs based on configuration options ]]--
BuffOptions.RePosition = function (hasTicket)
	--Only reposition the buffs if the user hasnt manually placed them
	if ( not TemporaryEnchantFrame:IsUserPlaced() ) then
		--Default to placing the buffs in the default position to the left of the minimap
		local curPoint = "TOPRIGHT";
		local curRel = "UIParent";
		local curRelPoint = "TOPRIGHT";
		local curX = -205;
		local curY = -13;
		--Adjust for TitanBar
		if (TitanPanelGetVar and TITAN_PANEL_PLACE_TOP and ( TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_TOP ) and TitanMovable_GetPanelYOffset ) then
			local titanOffset = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_TOP, TitanPanelGetVar("BothBars"));
			if (titanOffset) then
				curY = curY + titanOffset;
			end
		end
		--If the player has a GM ticked open, then move the buffs down below it
		if (hasTicket) then
			if ( TicketStatusFrame ) then
				local tsfH = TicketStatusFrame:GetHeight();
				if (tsfH) then
					curY = -tsfH;
				end
			end
		end

		--Handle horizontal positioning
		if ( BuffOptions_Config.Vertical ~= 1 ) then
			--If we are reversing, then position it left  offset the width of the buff area
			if (BuffOptions_Config.Reverse == 1) then
				curPoint = "TOPLEFT";
				curX = curX - 365;
			end
			--If we are swapping, then move it down the height of a buff
			if (BuffOptions_Config.Swap == 1) then
				local curH = -37;
				--Account for duration on bottom
				if ( ( SHOW_BUFF_DURATIONS == "1" ) ) then
					curH = curH - 10;
				end
				--Border space
				curY = curY + curH + 2;
			end
		else
			--Deal with vertical placement
			--Only position on the right below the minimap if we should
			if ( BuffOptions_Config.NoRight ~= 1 ) then
				curX = -13;
				curY = curY - 177;
				--Handle the offset of the side bars
				if (SHOW_MULTI_ACTIONBAR_3 and ( not MultiBarRight:IsUserPlaced() ) ) then
					curX = curX - 46;
					if (SHOW_MULTI_ACTIONBAR_4 and ( not MultiBarLeft:IsUserPlaced() ) ) then
						curX = curX - 46;
					end
				end
			end
			--Offset left based on the text and duration display options
			if ( (BuffOptions_Config.Text == 1) or ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.LongTime == 1 ) and ( BuffOptions_Config.ShortTime ~= 1 ) ) ) then
				curX = curX - 115;
			elseif ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime == 1 ) ) then
				curX = curX - 56;
			end
			--If we are reversing, then stack up from just above the main bar
			if (BuffOptions_Config.Reverse == 1) then
				curPoint = "BOTTOMRIGHT";
				curY = MainMenuBar:GetHeight() + 10;
				--Account for the bottom right bar
				if (SHOW_MULTI_ACTIONBAR_2 and ( not MultiBarBottomRight:IsUserPlaced() ) ) then
					curY = curY + MultiBarBottomRight:GetHeight();
				end
				curRelPoint = "BOTTOMRIGHT";
			end
			--If we are swapping then offset the width of a buff left
			if (BuffOptions_Config.Swap == 1) then
				curX = curX - 37;
			end
		end

		--Adjust for scaled buffs
		if (BuffOptions_Config.Vertical ~= 1) then
			curX = curX / BuffOptions_Config.Size;
		end
		curY = curY / BuffOptions_Config.Size;

		--Move the frame to the calculated position
		TemporaryEnchantFrame:ClearAllPoints();
		TemporaryEnchantFrame:SetPoint(curPoint, curRel, curRelPoint, curX, curY);
	end
end

--[[ Updated the text display of all the buffs ]]--
BuffOptions.UpdateText = function ()
	local curBuff;
	--Go through all the buffs
	for i = 0, 23 do
		curBuff = getglobal("BuffButton"..i);
		if (curBuff) then
			BuffOptions.BuffButton_Update(curBuff);
		end
	end
	--Go through the enchant buffs
	for i = 1, 2 do
		curBuff = getglobal("TempEnchant"..i);
		if (curBuff) then
			BuffOptions.UpdateEnchantButtonText(curBuff);
		end
	end
end

--[[ Updates the text on the Enchant buttons ]]--
BuffOptions.UpdateEnchantButtonText = function (buff, override)
	--The the buff wasn't passed, use this
	if (not buff) then
		buff = this;
	end
	--Get the buffs ID
	local ID = buff:GetID();
	if (ID) then
		--Get the buff text objects
		local buffTextFrame = getglobal(buff:GetName().."BuffOText");
		local buffTextTextFrame = getglobal(buff:GetName().."BuffOTextText");
		--Setup the tooltip with this buff
		Sea.wow.tooltip.clear("BuffOptionsTooltip");
		BuffOptionsTooltip:SetInventoryItem("player", ID);
		--Get the text from the first line of the tooltip
		local buffText = MCom.wow.tooltip.get("BuffOptionsTooltip", 1, "left");
		--If we are going to be diaplying text, then do so
		if ( ( BuffOptions_Config.Text == 1 ) and ( BuffOptions_Config.Vertical == 1 ) and buffText and ( buffText ~= "" ) ) then
			local charges;	--Holds the number of charges
			--Go through all the other rows in the tooltip looking for the enchant type, and charges
			for curRow = 2, 15 do
				--Get the text for this row
				local curText = MCom.wow.tooltip.get("BuffOptionsTooltip", curRow, "left");
				if (curText and ( curText ~= "" ) ) then 
					--Check to see if it matches any of the charge strings
					for i, curString in BUFFOPTIONS_CHARGE_STRINGS do
						--If it matches the charge string, then pull the charge count from it
						if( string.find(curText, curString) ) then
							_, _, charges = string.find(curText, BUFFOPTIONS_CHARGE);
							if (not charges) then
								charges = curText;
							end
							break;
						end
					end
					--Check to see if it matches any of the enchant strings
					for i, curString in BUFFOPTIONS_ENCHANT_STRINGS do
						--If it matches the enchant string, then pull the enchant name from it
						if( string.find(curText, curString) ) then
							_, _, buffText = string.find(curText, BUFFOPTIONS_ENCHANT);
							if (not buffText) then
								buffText = curText;
							end
							break;
						end
					end
				end
			end
			--If we got buff text, then format it as desired
			if ( buffText ) then
				--If we have charges, use the format string that has both enchant and charges
				if (charges) then
					--Put it charges first and buff name second, or visa versa if the option is there
					if ( BUFFOPTIONS_CHARGE_WEAPONBUFF ) then
						buffText = string.format(BUFFOPTIONS_CHARGE_WEAPONBUFF, charges, buffText);
					else
						buffText = string.format(BUFFOPTIONS_WEAPONBUFF_CHARGE, buffText, charges);
					end
				else
					--Format the string with only the buff name
					buffText = string.format(BUFFOPTIONS_WEAPONBUFF, buffText)
				end
			else
				--If we got no buff text, use a nil string
				buffText = "";
			end
			--If we got the buff text frame, then show it, and set the text
			if (buffTextFrame) then
				buffTextFrame:Show();
				if (buffTextTextFrame) then
					buffTextTextFrame:SetText(buffText);
				end
			end
		elseif (buffTextFrame) then
			--Hide the buff text frame
			buffTextFrame:Hide();
			if (buffTextTextFrame) then
				buffTextTextFrame:SetText("");
			end
		end
	end
end

--[[ Hides or shows the borders ]]--
BuffOptions.UpdateBorder = function ()
	local curFrame;
	--Update displaying of the borders for the normal buffs
	for i = 0, 23 do
		curFrame = getglobal("BuffButton"..i.."BuffOBorder");
		if (curFrame) then
			if ( BuffOptions_Config.Border == 1 ) then
				curFrame:Show();
			else
				curFrame:Hide();
			end
		end
	end
	--Update displaying of the borders for the enchant buffs
	for i = 1, 2 do
		curFrame = getglobal("TempEnchant"..i.."BuffOBorder");
		if (curFrame) then
			if ( BuffOptions_Config.Border == 1 ) then
				curFrame:Show();
			else
				curFrame:Hide();
			end
		end
	end
end

--[[ Updates the size of all of the buffs ]]--
BuffOptions.UpdateSize = function (newSize)
	--If no size was passed, then use the set config size
	if (not newSize) then
		newSize = BuffOptions_Config.Size;
	end
	local curFrame;
	--Get the UI scale
	local curScale = UIParent:GetScale();
	--Scale the frames
	curFrame = getglobal("TemporaryEnchantFrame");
	if (curFrame) then
		curFrame:SetScale(curScale * newSize);
	end
	curFrame = getglobal("BuffFrame");
	if (curFrame) then
		curFrame:SetScale(curScale * newSize);
	end
	BuffOptions.RePosition();
end

--[[ Updates the text size of all the buffs ]]--
BuffOptions.UpdateTextSize = function ()
	local curFrame;
	--Update the text size of all the normal buffs
	for i = 0, 23 do
		curFrame = getglobal("BuffButton"..i.."BuffOTextText");
		if (curFrame) then
			curFrame:SetTextHeight(10 * BuffOptions_Config.TextSize);
		end
		curFrame = getglobal("BuffButton"..i.."Duration");
		if (curFrame) then
			curFrame:SetTextHeight(10 * BuffOptions_Config.TextSize);
		end
	end
	--Update the text size of all the enchant buffs
	for i = 1, 2 do
		curFrame = getglobal("TempEnchant"..i.."BuffOTextText");
		if (curFrame) then
			curFrame:SetTextHeight(10 * BuffOptions_Config.TextSize);
		end
		curFrame = getglobal("TempEnchant"..i.."Duration");
		if (curFrame) then
			curFrame:SetTextHeight(10 * BuffOptions_Config.TextSize);
		end
	end

	--This is a hack to make the game properly smooth the new font size, if we adjust the scale, it fixes the font
	BuffOptions.UpdateSize(BuffOptions_Config.Size + 0.001);
	BuffOptions.UpdateSize(BuffOptions_Config.Size);
end

--------------------------------------------------
--
-- Data Storage
--
--------------------------------------------------

--[[ Saves the current configuration on a per realm/per character basis ]]--
BuffOptions.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "BuffOptions_Config";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
BuffOptions.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "BuffOptions_Config";
		nonUIList = {};
	});
end

--------------------------------------------------
--
-- Hooked Functions
--
--------------------------------------------------

--[[ Hooked to handle new positioning, and duration fading ]]--
BuffOptions.BuffFrame_Enchant_OnUpdate = function (elapsed)
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo();
	
	-- No enchants, kick out early
	if ( not hasMainHandEnchant and not hasOffHandEnchant ) then
		TempEnchant1:Hide();
		TempEnchant1Duration:Hide();
		TempEnchant2:Hide();
		TempEnchant2Duration:Hide();

		local curPoint = "TOPRIGHT";
		local curRelPoint = "TOPRIGHT";
		--Handle reverse orientation
		if (BuffOptions_Config.Reverse == 1) then
			curPoint = "TOPLEFT";
			curRelPoint = "TOPLEFT";
		end
		--Handle vertical reverse orientation
		if (BuffOptions_Config.Vertical == 1) then
			if (BuffOptions_Config.Reverse == 1) then
				curPoint = "BOTTOMRIGHT";
				curRelPoint = "BOTTOMRIGHT";
			end
		end
		BuffFrame:ClearAllPoints();
		BuffFrame:SetPoint(curPoint, "TemporaryEnchantFrame", curRelPoint, 0, 0);
		return;
	end
	-- Has enchants
	local enchantButton;
	local textureName;
	local buffAlphaValue;
	local enchantIndex = 0;
	if ( hasOffHandEnchant ) then
		enchantIndex = enchantIndex + 1;
		textureName = GetInventoryItemTexture("player", 17);
		if ( ( not BuffOptions.lastEnchant2Tex ) or ( BuffOptions.lastEnchant2Tex ~= textureName ) ) then
			BuffOptions.UpdateEnchantButtonText(TempEnchant2);
		end
		BuffOptions.lastEnchant2Tex = textureName;
		TempEnchant1:SetID(17);
		TempEnchant1Icon:SetTexture(textureName);
		TempEnchant1:Show();
		hasEnchant = 1;

		-- Show buff durations if necessary
		if ( offHandExpiration ) then
			offHandExpiration = offHandExpiration/1000;
		end
		local duration = getglobal("TempEnchant1Duration");
		local lastTime = duration:GetText();
		BuffFrame_UpdateDuration(TempEnchant1, offHandExpiration);
		if ( lastTime ~= duration:GetText() ) then
			BuffOptions.UpdateEnchantButtonText(TempEnchant1);
		end

		-- Handle flashing
		if ( offHandExpiration and offHandExpiration < BUFF_WARNING_TIME ) then
			TempEnchant1:SetAlpha(BUFF_ALPHA_VALUE);

			--If enabled, then make the duration text flash with the buff
			if (BuffOptions_Config.FadeTime == 1) then
				if (duration) then
					duration:SetAlpha(BUFF_ALPHA_VALUE);
				end
			end
		else
			--If it isn't time for fading, then make sure the duration is solid
			if (duration) then
				duration:SetAlpha(1);
			end
		end
	end
	if ( hasMainHandEnchant ) then
		enchantIndex = enchantIndex + 1;
		enchantButton = getglobal("TempEnchant"..enchantIndex);
		textureName = GetInventoryItemTexture("player", 16);
		enchantButton:SetID(16);
		getglobal(enchantButton:GetName().."Icon"):SetTexture(textureName);
		enchantButton:Show();
		hasEnchant = 1;

		-- Show buff durations if necessary
		if ( mainHandExpiration ) then
			mainHandExpiration = mainHandExpiration/1000;
		end
		
		local duration = getglobal(enchantButton:GetName().."Duration");
		local lastTime = duration:GetText();
		BuffFrame_UpdateDuration(enchantButton, mainHandExpiration);
		if ( lastTime ~= duration:GetText() ) then
			BuffOptions.UpdateEnchantButtonText(enchantButton);
		end

		-- Handle flashing
		if ( mainHandExpiration and mainHandExpiration < BUFF_WARNING_TIME ) then
			enchantButton:SetAlpha(BUFF_ALPHA_VALUE);

			--If enabled, then make the duration text flash with the buff
			if (BuffOptions_Config.FadeTime == 1) then
				if (duration) then
					duration:SetAlpha(BUFF_ALPHA_VALUE);
				end
			end
		else
			--If it isn't time for fading, then make sure the duration is solid
			if (duration) then
				duration:SetAlpha(1);
			end
		end
	end
	--Hide unused enchants
	for i=enchantIndex+1, 2 do
		getglobal("TempEnchant"..i):Hide();
		getglobal("TempEnchant"..i.."Duration"):Hide();
	end

	-- Position buff frame, default to being just left of the right of the enchant frame
	local curPoint = "TOPRIGHT";
	local curRelPoint = "TOPLEFT";
	local curW = enchantIndex * 32;
	local curH = 36;
	local curX = -5;
	local curY = 0;
	--If we are reversing, then place it on the right of the enchant frame
	if (BuffOptions_Config.Reverse == 1) then
		curPoint = "TOPLEFT";
		curRelPoint = "TOPRIGHT";
		curX = curX * -1;
	end
	--If we are vertical, then place it under the enchant frame
	if (BuffOptions_Config.Vertical == 1) then
		curPoint = "TOPRIGHT";
		curRelPoint = "BOTTOMRIGHT";
		curW = 32;
		curH = 30;
		--Account for duration being under the buff
		if ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime ~= 1 ) ) then
			curH = 40
		end
		--Account for the number of enchant buffs that are showing
		curH = curH * enchantIndex;
		curX = 0;
		curY = -5;
		--If we are reversing then stack on top of the enchant frame
		if (BuffOptions_Config.Reverse == 1) then
			curPoint = "BOTTOMRIGHT";
			curRelPoint = "TOPRIGHT";
			curY = curY * -1;
			--Account for duration under buff
			if ( ( SHOW_BUFF_DURATIONS == "1" ) and ( BuffOptions_Config.SideTime ~= 1 ) ) then
				curY = curY + 10;
			end
		end	
	end

	--Resize the enchant frame, and place the buff frame based on calculations
	TemporaryEnchantFrame:SetWidth(curW);
	TemporaryEnchantFrame:SetHeight(curH);
	BuffFrame:ClearAllPoints();
	BuffFrame:SetPoint(curPoint, "TemporaryEnchantFrame", curRelPoint, curX, curY);
end

--[[ Hooked to update the text of the buff ]]--
BuffOptions.BuffButton_Update = function (buff)
	--Default buff to this
	if (not buff) then
		buff = this;
	end
	--Get the buffs ID
	local ID = buff:GetID();
	if (ID) then
		--Get the buffs index
		local buffIndex, untilCancelled = GetPlayerBuff(buff:GetID(), buff.buffFilter);
		if (buffIndex) then
			--Get the buffs text objects
			local buffTextFrame = getglobal(buff:GetName().."BuffOText");
			local buffTextTextFrame = getglobal(buff:GetName().."BuffOTextText");
			local buffText = "";
			--Only set the text if enabled
			if ( ( BuffOptions_Config.Text == 1 ) and ( BuffOptions_Config.Vertical == 1 ) ) then
				--Setup the tooltip with this buff
				Sea.wow.tooltip.clear("BuffOptionsTooltip");
				BuffOptionsTooltip:SetPlayerBuff(buffIndex);
				--If we got the tip text, then set the buff to use that name
				local tip, tipRight = MCom.wow.tooltip.get("BuffOptionsTooltip", curRow);
				if ( tip and ( tip ~= "" ) ) then
					buffText = tip;
					--If this is a debuff, then use the debuff type, if the option is enabled
					if ( ( BuffOptions_Config.DebuffType == 1 ) and ( buff.buffFilter == "HARMFUL" ) and tipRight and ( tipRight ~= "" ) ) then
						buffText = tipRight;
					end
				end
			end
			--Set the buff text
			if (buffTextFrame) then
				if (buffText and ( buffText ~= "" ) ) then
					buffTextFrame:Show();
				else
					buffTextFrame:Hide();
				end
				if (buffTextTextFrame) then
					buffTextTextFrame:SetText(buffText);
				end
			end

			--Initialize the buff duration to full alpha
			local buffTime = getglobal(buff:GetName().."Duration");
			if (buffTime) then
				buffTime:SetAlpha(1);
			end
		end
	end
end

--[[ Produces the string used for the current buff duration ]]--
BuffOptions.SecondsToTimeAbbrev = function (seconds)
	--Initialize the unit text with the one letter abbreviations
	local dayWord = " "..DAY_ONELETTER_ABBR;			--Day
	local daysWord = " "..DAY_ONELETTER_ABBR;			--Days
	local hourWord = " "..HOUR_ONELETTER_ABBR;		--Hour
	local hoursWord = " "..HOUR_ONELETTER_ABBR;		--Hours
	local hourWordA = " "..HOUR_ONELETTER_ABBR;		--Hr
	local hoursWordA = " "..HOUR_ONELETTER_ABBR;	--Hrs
	local minWord = " "..MINUTE_ONELETTER_ABBR;		--Minute
	local minsWord = " "..MINUTE_ONELETTER_ABBR;	--Minutes
	local minWordA = " "..MINUTE_ONELETTER_ABBR;	--Min
	local minsWordA = " "..MINUTE_ONELETTER_ABBR;	--Mins
	local secWord = " "..SECOND_ONELETTER_ABBR;		--Second
	local secsWord = " "..SECOND_ONELETTER_ABBR;	--Seconds
	local secWordA = " "..SECOND_ONELETTER_ABBR;	--Sec
	local secsWordA = " "..SECOND_ONELETTER_ABBR;	--Secs
	local timeSep = " ";	--Separator used in time display
	local maxParts = 1;		--Maximum number of parts(day/hr/sec/min) to display

	--If we should be using long time format, then setup the strings for it
	if ( ( BuffOptions_Config.LongTime == 1 ) and ( BuffOptions_Config.Vertical == 1 ) ) then
		dayWord = " "..DAYS;
		daysWord = " "..DAYS_P1;
		hourWord = " "..HOURS;
		hoursWord = " "..HOURS_P1;
		hourWordA = " "..HOURS_ABBR;
		hoursWordA = " "..HOURS_ABBR_P1;
		minWord = " "..MINUTES;
		minsWord = " "..MINUTES_P1;
		minWordA = " "..MINUTES_ABBR;
		minsWordA = " "..MINUTES_ABBR_P1;
		secWord = " "..SECONDS;
		secsWord = " "..SECONDS_P1;
		secWordA = " "..SECONDS_ABBR;
		secsWordA = " "..SECONDS_ABBR_P1;
		--We want to allow up to two parts, ex: "1 hour 5 mins"
		maxParts = 2;
	end

	--If we are using short time, then use no unit text
	if ( BuffOptions_Config.ShortTime == 1 ) then
		dayWord = "";
		daysWord = "";
		hourWord = "";
		hoursWord = "";
		hourWordA = "";
		hoursWordA = "";
		minWord = "";
		minsWord = "";
		minWordA = "";
		minsWordA = "";
		secWord = "";
		secsWord = "";
		secWordA = "";
		secsWordA = "";
		timeSep = ":";
		--We want to allow up to 4 parts, ex: "1:04:17:34"
		maxParts = 4;
	end

	local curParts = 0;	--So far we have not proccessed any parts
	local time = "";		--Default the output string to be empty
	local tempTime;			--Will hold the formatted time before placing it in the real string
	--If there is atleast a days worth of seconds, then proccess the day part
	if ( seconds > 86400  ) then
		--We are proccessing a part
		curParts = curParts + 1;
		--If this is the final part, then round up
		if (curParts == maxParts) then
			tempTime = ceil(seconds / 86400);
		else
			--otherwise round down, and subtract from the remaining seconds
			tempTime = floor(seconds / 86400);
			seconds = seconds - (tempTime * 86400);
		end
		--If there is more than one day, use the plural
		if ( tempTime ~= 1 ) then
			dayWord = daysWord;
		end
		--Set the time string for days
		time = tempTime..dayWord;
	end
	--If we have all of our parts, then return the string
	if (curParts >= maxParts) then
		return nil, time;
	end
	if ( seconds > 3600  ) then
		--If we have proccessed a part, then add a separator
		if (curParts > 0) then
			time = time..timeSep;
		end
		--We are proccessing a part
		curParts = curParts + 1;
		--If this is the final part, then round up
		if (curParts == maxParts) then
			tempTime = ceil(seconds / 3600);
		else
			--otherwise round down, and subtract from the remaining seconds
			tempTime = floor(seconds / 3600);
			seconds = seconds - (tempTime * 3600);
		end
		--If we have proccessed a part, then use abbreviated format
		if (curParts > 1) then
			hourWord = hourWordA;
		end
		--If there is more than one, use the plural
		if ( tempTime ~= 1 ) then
			hourWord = hoursWord;
			--If we have proccessed a part, then use abbreviated format
			if (curParts > 1) then
				hourWord = hoursWordA;
			end
		end
		--If this is the second part or more, and we are using short format, and there is only 1 digit in the number, then add a 0 infront of it
		if ( ( BuffOptions_Config.ShortTime == 1 ) and (curParts > 1) and ( string.len(tempTime) < 2 ) ) then
			tempTime = "0"..tempTime;
		end
		--Add the hour to the string
		time = time..tempTime..hourWord;
	end
	--If we have all of our parts, then return the string
	if (curParts >= maxParts) then
		return nil, time;
	end
	if ( seconds > 60  ) then
		--If we have proccessed a part, then add a separator
		if (curParts > 0) then
			time = time..timeSep;
		end
		--We are proccessing a part
		curParts = curParts + 1;
		--If this is the final part, then round up
		if (curParts == maxParts) then
			tempTime = ceil(seconds / 60);
		else
			--otherwise round down, and subtract from the remaining seconds
			tempTime = floor(seconds / 60);
			seconds = seconds - (tempTime * 60);
		end
		--If we have proccessed a part, then use abbreviated format
		if (curParts > 1) then
			minWord = minWordA;
		end
		--If there is more than one, use the plural
		if ( tempTime ~= 1 ) then
			minWord = minsWord;
			--If we have proccessed a part, then use abbreviated format
			if (curParts > 1) then
				minWord = minsWordA;
			end
		end
		--If this is the second part or more, and we are using short format, and there is only 1 digit in the number, then add a 0 infront of it
		if ( ( BuffOptions_Config.ShortTime == 1 ) and (curParts > 1) and ( string.len(tempTime) < 2 ) ) then
			tempTime = "0"..tempTime;
		end
		--Add the minute to the string
		time = time..tempTime..minWord;
	end
	--If we have all of our parts, then return the string
	if (curParts >= maxParts) then
		return nil, time;
	end
	--If we have proccessed a part, then add a separator
	if (curParts > 0) then
		time = time..timeSep;
	end
	--We are proccessing a part
	curParts = curParts + 1;
	tempTime = format("%d", seconds);
	--If we have proccessed a part, then use abbreviated format
	if (curParts > 1) then
		secWord = secWordA;
	end
	--If there is more than one, use the plural
	if ( tempTime ~= '1' ) then
		secWord = secsWord;
		--If we have proccessed a part, then use abbreviated format
		if (curParts > 1) then
			secWord = secsWordA;
		end
	end
	--If this is the second part or more, and we are using short format, and there is only 1 digit in the number, then add a 0 infront of it
	if ( ( BuffOptions_Config.ShortTime == 1 ) and (curParts > 1) and ( string.len(tempTime) < 2 ) ) then
		tempTime = "0"..tempTime;
	end
	--Add the second to the string
	time = time..tempTime..secWord;
	return nil, time;
end

--[[ Used to adjust the colors of the text, and to display the reminders ]]--
BuffOptions.BuffFrame_UpdateDuration = function (buffButton, timeLeft)
	--Handle reminders
	if ( buffButton and timeLeft and ( BuffOptions_Config.Reminder == 1 ) ) then
		--Round the time to the nearest tenth
		local roundTimeLeft = Sea.math.round(timeLeft * 10) / 10;
		local buffButtonName = buffButton:GetName();
		--Create the list of buffs if it doesn't exist
		if (not BuffOptions.BuffList) then
			BuffOptions.BuffList = {};
		end
		--Create the list of last time used for buffs if it doesn't exist
		if (not BuffOptions.BuffList.LastTime) then
			BuffOptions.BuffList.LastTime = {};
		end
		--See if this is an enchant buff
		local isEnchant = nil;
		if ( ( buffButtonName == "TempEnchant1" ) or ( buffButtonName == "TempEnchant2" ) ) then
			isEnchant = true;
		end
		--Only proccess reminder if we aren't doing equipment only, or this is an equipment/enchant buff
		if ( ( BuffOptions_Config.EquipmentOnly ~= 1 ) or isEnchant ) then
			local buffText = BUFFOPTIONS_EXPIRESOON;	--Initialize the buff text for a normal buff
			--Setup the tooltip with this buff
			Sea.wow.tooltip.clear("BuffOptionsTooltip");
			--If this isn't an enchant, then set the tooltip as a normal buff
			if ( not isEnchant ) then
				local buffIndex, untilCancelled = GetPlayerBuff(buffButton:GetID(), buffButton.buffFilter);
				if (buffIndex) then
					BuffOptionsTooltip:SetPlayerBuff(buffIndex);
				end
			else
				--If this is an enchant, then set the tooltip as an enchant buff
				BuffOptionsTooltip:SetInventoryItem("player", buffButton:GetID());
				--Set the buff text for an enchant buff
				buffText = BUFFOPTIONS_EXPIRESOON_ENCHANT;
			end
			--Get the name of the buff from the tooltip
			local buffName = MCom.wow.tooltip.get("BuffOptionsTooltip", 1, "left");
			if ( buffName and ( buffName ~= "" ) and ( buffButton.buffFilter ~= "HARMFUL" ) ) then
				--If we don't have a highest time table, make one now
				if (not BuffOptions.BuffList.HighTime) then
					BuffOptions.BuffList.HighTime = {};
				end
				--If we haven't recorded a highest time for this buff yet, or the current time is greater than the current, then set it to the current
				if ( ( not BuffOptions.BuffList.HighTime[buffName] ) or ( roundTimeLeft > BuffOptions.BuffList.HighTime[buffName] ) ) then
					BuffOptions.BuffList.HighTime[buffName] = roundTimeLeft;
				end
				--If the reminder time is 0 or less, then we need to up it to 1
				local upRemTime = BuffOptions_Config.ReminderTime;
				if (upRemTime < 1) then
					upRemTime = 1;
				end
				--Only display the reminder if we haven't already done so for this cycle, and if we aren't short time limiting, or we are short time limiting
				--and this buff is longer than the short time(we use high time to determine the buffs time)
				if	( ( ( BuffOptions_Config.NoShort ~= 1 ) or ( BuffOptions.BuffList.HighTime[buffName] > BuffOptions_Config.ShortBuffTime ) ) and
						( ( roundTimeLeft == upRemTime ) and ( roundTimeLeft ~= BuffOptions.BuffList.LastTime[buffButtonName] ) ) ) then
					--Format the buffText with the buff name
					buffText = string.format(buffText, buffName);
					--Display the buff reminder either on screen, or in chat
					if (BuffOptions_Config.ReminderOSD == 1) then
						UIErrorsFrame:AddMessage(buffText, BuffOptions_Config.ReminderColor.r, BuffOptions_Config.ReminderColor.g, BuffOptions_Config.ReminderColor.b, 1.0, UIERRORS_HOLD_TIME);
					else
						Sea.io.printc(BuffOptions_Config.ReminderColor, buffText);
					end
					--If we should play a reminder sound, then do so now
					if (BuffOptions_Config.ReminderSound == 1) then
						PlaySoundFile("Sound\\interface\\igQuestFailed.wav");
					end
				end
			end
		end
		--Store the current time, as the last time, so we know if we are still working within the same second, to avoid repeated prints
		BuffOptions.BuffList.LastTime[buffButtonName] = roundTimeLeft;
	end

	local duration = getglobal(buffButton:GetName().."Duration");
	if ( SHOW_BUFF_DURATIONS == "1" and timeLeft ) then
		duration:SetText(SecondsToTimeAbbrev(timeLeft));
		if ( ( timeLeft < BUFF_DURATION_WARNING_TIME ) and ( buffButton.untilCancelled ~= 1 ) ) then
			duration:SetVertexColor(BuffOptions_Config.TextShortColor.r, BuffOptions_Config.TextShortColor.g, BuffOptions_Config.TextShortColor.b);
		else
			duration:SetVertexColor(BuffOptions_Config.TextColor.r, BuffOptions_Config.TextColor.g, BuffOptions_Config.TextColor.b);
		end
		duration:Show();
	else
		duration:Hide();
	end
	--If we are showing text, then update the color of it
	if ( ( BuffOptions_Config.Text == 1 ) and ( BuffOptions_Config.Vertical == 1 ) ) then
		local buffText = getglobal(buffButton:GetName().."BuffOTextText");
		if ( timeLeft and ( timeLeft < BUFF_DURATION_WARNING_TIME ) and ( buffButton.untilCancelled ~= 1 )  ) then
			buffText:SetVertexColor(BuffOptions_Config.TextShortColor.r, BuffOptions_Config.TextShortColor.g, BuffOptions_Config.TextShortColor.b);
		else
			buffText:SetVertexColor(BuffOptions_Config.TextColor.r, BuffOptions_Config.TextColor.g, BuffOptions_Config.TextColor.b);
		end
	end
end

--[[ Modified to update the alpha value for duration of expiring buffs and to properly color durationless buffs ]]--
BuffOptions.BuffButton_OnUpdate = function ()
	local buffDuration = getglobal(this:GetName().."Duration");
	if ( this.untilCancelled == 1 ) then
		--Update the display of the duration for this buff, if it has one
		BuffOptions.BuffFrame_UpdateDuration(this);
		return;
	end

	local buffIndex = this.buffIndex;
	local timeLeft = GetPlayerBuffTimeLeft(buffIndex);
	if ( timeLeft < BUFF_WARNING_TIME ) then
		this:SetAlpha(BUFF_ALPHA_VALUE);
	else
		this:SetAlpha(1);
	end
	--Fade the time as well
	if ( (BuffOptions_Config.FadeTime == 1) and ( timeLeft < BUFF_WARNING_TIME ) ) then
		buffDuration:SetAlpha(BUFF_ALPHA_VALUE);
	else
		--If we aren't fading time, then make it solid
		buffDuration:SetAlpha(1);
	end

	-- Update duration
	BuffFrame_UpdateDuration(this, timeLeft);

	if ( BuffFrameUpdateTime > 0 ) then
		return;
	end
	if ( GameTooltip:IsOwned(this) ) then
		GameTooltip:SetPlayerBuff(buffIndex);
	end
end

--[[ We replace this to get proper repositioning when dealing with GM tickets ]]--
BuffOptions.TicketStatusFrame_OnEvent = function ()
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		GetGMTicket();
	else
		if ( arg1 ~= 0 ) then		
			this:Show();
			BuffOptions.RePosition(true);
			refreshTime = GMTICKET_CHECK_INTERVAL;
		else
			this:Hide();
			BuffOptions.RePosition();
		end
	end	
end

--[[ Modified version of Mobile Frames reset buff position, to clear the user placed setting ]]--
BuffOptions.MobileFrames_ResetMobileBuffFrame = function ()
	if ( TemporaryEnchantFrame.isMoving ) then
		TemporaryEnchantFrame:StopMovingOrSizing();
		TemporaryEnchantFrame.isMoving = false;
	else
		TemporaryEnchantFrame:ClearAllPoints();
		if (TicketStatusFrame:IsVisible()) then
			TemporaryEnchantFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -205, (-TicketStatusFrame:GetHeight()));
		else
			TemporaryEnchantFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -205, -13);
		end
		TemporaryEnchantFrame:SetUserPlaced(false);
	end
end

--[[ Modified version of Mobile Frames reset bottom multibar position, to clear the user placed setting ]]--
BuffOptions.MobileFrames_ResetMobileBottomMultiBars = function ()
	if ( MultiBarBottomLeft.isMoving ) or ( MultiBarBottomRight.isMoving ) then
		MultiBarBottomLeft:StopMovingOrSizing();
		MultiBarBottomLeft.isMoving = false;
		MultiBarBottomRight:StopMovingOrSizing();
		MultiBarBottomRight.isMoving = false;
	else
		MultiBarBottomLeft:ClearAllPoints();
		MultiBarBottomLeft:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", 0, 17);
		MultiBarBottomLeft:SetUserPlaced(false);
		MultiBarBottomRight:ClearAllPoints();
		MultiBarBottomRight:SetPoint("LEFT", "MultiBarBottomLeft", "RIGHT", 10, 0);
		MultiBarBottomRight:SetUserPlaced(false);
	end
end

--[[ Modified version of Mobile Frames reset side multibar position, to clear the user placed setting ]]--
BuffOptions.MobileFrames_ResetMobileSideMultiBars = function ()
	if ( MultiBarLeft.isMoving ) or ( MultiBarRight.isMoving ) then
		MultiBarLeft:StopMovingOrSizing();
		MultiBarLeft.isMoving = false;
		MultiBarRight:StopMovingOrSizing();
		MultiBarRight.isMoving = false;
	else
		MultiBarRight:ClearAllPoints();
		MultiBarRight:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -7, 98);
		MultiBarRight:SetUserPlaced(false);
		MultiBarLeft:ClearAllPoints();
		MultiBarLeft:SetPoint("TOPRIGHT", "MultiBarRight", "TOPLEFT", -5, 0);
		MultiBarLeft:SetUserPlaced(false);
	end
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
BuffOptions.OnVarsLoaded = function ()
	if (not BuffOptions.ConfigLoaded) then
		BuffOptions.ConfigLoaded = true;
		--Load the configuration
		BuffOptions.LoadConfig();
		--Store the configuration for this character
		BuffOptions.SaveConfig();
		
		--do anything that needs to happen after variables are loaded, for when the UI isn't around
		BuffOptions.ReOrient();
		BuffOptions.UpdateText();
		BuffOptions.UpdateSize();
		BuffOptions.UpdateTextSize();
		BuffOptions.RePosition();
	end
end

BuffOptions.OnLoad = function ()
	if ( BuffOptions.Initialized ~= 1) then
		--Hook functions
		--Hook the buff frames to do all of what needs done
		MCom.util.hook("BuffFrame_Enchant_OnUpdate", "BuffOptions.BuffFrame_Enchant_OnUpdate", "replace");
		MCom.util.hook("BuffButtons_UpdatePositions", "BuffOptions.ReOrient", "replace");
		MCom.util.hook("BuffButton_Update", "BuffOptions.BuffButton_Update", "after");
		MCom.util.hook("SecondsToTimeAbbrev", "BuffOptions.SecondsToTimeAbbrev", "replace");
		MCom.util.hook("MultiActionBar_Update", "BuffOptions.RePosition", "after");
		MCom.util.hook("BuffFrame_UpdateDuration", "BuffOptions.BuffFrame_UpdateDuration", "replace");
		MCom.util.hook("BuffButton_OnUpdate", "BuffOptions.BuffButton_OnUpdate", "replace");
		--Hook the GM ticket event so we know if a GM ticket is displayed or not
		if (MobileFrames_TicketStatusFrame_OnEvent) then
			--If MobileFrames has hooked this already, then unhook it
			MCom.util.unhook( "TicketStatusFrame_OnEvent", "MobileFrames_TicketStatusFrame_OnEvent", "replace" );
		end
		MCom.util.hook("TicketStatusFrame_OnEvent", "BuffOptions.TicketStatusFrame_OnEvent", "replace");
		--Hook the varying mobile frames reset events to ensure that they properly set UserPlaced to false
		--Only do this with older MobileFrames versions
		if ( MobileFrames_SpecialFrames and (not MobileFramesDropDown_Reposition) ) then
			if (MobileFrames_SpecialFrames.TemporaryEnchantFrame and MobileFrames_SpecialFrames.TemporaryEnchantFrame.reset) then
				MCom.util.hook("MobileFrames_SpecialFrames.TemporaryEnchantFrame.reset", "BuffOptions.MobileFrames_ResetMobileBuffFrame", "replace");
			end
			if (MobileFrames_SpecialFrames.BottomMultiBars and MobileFrames_SpecialFrames.BottomMultiBars.reset) then
				MCom.util.hook("MobileFrames_SpecialFrames.BottomMultiBars.reset", "BuffOptions.MobileFrames_ResetMobileBottomMultiBars", "replace");
			end
			if (MobileFrames_SpecialFrames.SideMultiBars and MobileFrames_SpecialFrames.SideMultiBars.reset) then
				MCom.util.hook("MobileFrames_SpecialFrames.SideMultiBars.reset", "BuffOptions.MobileFrames_ResetMobileSideMultiBars", "replace");
			end
		end
		--Hook the MobileFrames buff reset function to update buff positions properly
		if (MobileFrames_SpecialFrames and MobileFrames_SpecialFrames.TemporaryEnchantFrame and MobileFrames_SpecialFrames.TemporaryEnchantFrame.reset) then
			MCom.util.hook("MobileFrames_SpecialFrames.TemporaryEnchantFrame.reset", "BuffOptions.RePosition", "after");
		end
		--If Titan is around, then hook it's move function so we can re-reposition the buffs anytime Titan does
		if (TitanMovableFrame_MoveFrames) then
			MCom.util.hook("TitanMovableFrame_AdjustBlizzardFrames", "BuffOptions.RePosition", "after");
		end
		--If Titan has hooked TicketStatusFrame_OnEvent, then return the hook to Sea/MCom hook control
		if ( TicketStatusFrame_OnEvent == Titan_TicketStatusFrame_OnEvent ) then
			TicketStatusFrame_OnEvent = function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20) return MCom.util.hookHandler("TicketStatusFrame_OnEvent",a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20); end;
		end

		--Register the configuration options
		BuffOptions.Register();

		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(BuffOptions.OnVarsLoaded);

		BuffOptions.Initialized = 1;
	end
end