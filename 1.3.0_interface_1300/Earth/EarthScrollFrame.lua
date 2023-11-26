
-- Scrollframe functions
function ScrollFrame_H_OnLoad()
	getglobal(this:GetName().."ScrollBarScrollRightButton"):Disable();
	getglobal(this:GetName().."ScrollBarScrollLeftButton"):Disable();
	this.offset = 0;
end

function ScrollFrame_H_OnScrollRangeChanged(scrollrange)
	local scrollbar = getglobal(this:GetName().."ScrollBar");
	if ( not scrollrange ) then
		scrollrange = this:GetHorizontalScrollRange();
	end
	local value = scrollbar:GetValue();
	if ( value > scrollrange ) then
		value = scrollrange;
	end
	scrollbar:SetMinMaxValues(0, scrollrange);
	scrollbar:SetValue(value);
	if ( floor(scrollrange) == 0 ) then
		if (this.scrollBarHideable ) then
			getglobal(this:GetName().."ScrollBar"):Hide();
			getglobal(scrollbar:GetName().."ScrollRightButton"):Hide();
			getglobal(scrollbar:GetName().."ScrollLeftButton"):Hide();
		else
			getglobal(scrollbar:GetName().."ScrollRightButton"):Disable();
			getglobal(scrollbar:GetName().."ScrollLeftButton"):Disable();
			getglobal(scrollbar:GetName().."ScrollRightButton"):Show();
			getglobal(scrollbar:GetName().."ScrollLeftButton"):Show();
		end
		
	else
		getglobal(scrollbar:GetName().."ScrollRightButton"):Show();
		getglobal(scrollbar:GetName().."ScrollLeftButton"):Show();
		getglobal(this:GetName().."ScrollBar"):Show();
		getglobal(scrollbar:GetName().."ScrollRightButton"):Enable();
	end
	
	-- Hide/show scrollframe borders
	local top = getglobal(this:GetName().."Top");
	local bottom = getglobal(this:GetName().."Bottom");
	if ( top and bottom and this.scrollBarHideable) then
		if ( this:GetHorizontalScrollRange() == 0 ) then
			top:Hide();
			bottom:Hide();
		else
			top:Show();
			bottom:Show();
		end
	end
end



function ScrollFrame_H_Template_OnMouseWheel(value)
	local scrollBar = getglobal(this:GetName().."ScrollBar");
	if ( value > 0 ) then
		scrollBar:SetValue(scrollBar:GetValue() - (scrollBar:GetWidth() / 2));
	else
		scrollBar:SetValue(scrollBar:GetValue() + (scrollBar:GetWidth() / 2));
	end
end

-- Function to handle the update of manually calculated scrollframes.  Used mostly for listings with an indeterminate number of items
function Faux_H_ScrollFrame_Update(frame, numItems, numToDisplay, valueStep, highlightFrame, smallHighlightWidth, bigHighlightWidth )
	-- If more than one screen full of skills then show the scrollbar
	local frameName = frame:GetName();
	local scrollBar = getglobal( frameName.."ScrollBar" );
	if ( numItems > numToDisplay ) then
		frame:Show();
	else
		scrollBar:SetValue(0);
		frame:Hide();
	end
	if ( frame:IsVisible() ) then
		local scrollChildFrame = getglobal( frameName.."ScrollChildFrame" );
		local scrollLeftButton = getglobal( frameName.."ScrollBarScrollLeftButton" );
		local scrollRightButton = getglobal( frameName.."ScrollBarScrollRightButton" );
		local scrollFrameHeight = 0;
		local scrollChildHeight = 0;

		if ( numItems > 0 ) then
			scrollFrameHeight = (numItems - numToDisplay) * valueStep;
			scrollChildHeight = numItems * valueStep;
			if ( scrollFrameHeight < 0 ) then
				scrollFrameHeight = 0;
			end
			scrollChildFrame:Show();
		else
			scrollChildFrame:Hide();
		end
		scrollBar:SetMinMaxValues(0, scrollFrameHeight); 
		scrollBar:SetValueStep(valueStep);
		scrollChildFrame:SetWidth(scrollChildHeight);

		-- To handle bad initialization
		if ( scrollBar:GetValue() < 0 ) then
			scrollBar:SetValue(0);
		end
		
		-- Arrow button handling
		if ( scrollBar:GetValue() == 0 ) then
			scrollLeftButton:Disable();
		else
			scrollLeftButton:Enable();
		end
		if ((scrollBar:GetValue() - scrollFrameHeight) == 0) then
			scrollRightButton:Disable();
		else
			scrollRightButton:Enable();
		end
		
		-- Shrink because scrollbar is shown
		if ( highlightFrame ) then
			highlightFrame:SetHeight(smallHighlightWidth);
		end
	else
		-- Widen because scrollbar is hidden
		if ( highlightFrame ) then
			highlightFrame:SetHeight(bigHighlightWidth);
		end
	end
end

function Earth_FauxScrollFrame_OnHorizontalScroll(itemWidth, updateFunction)
	local scrollbar = getglobal(this:GetName().."ScrollBar");
	scrollbar:SetValue(arg1);
	this.offset = floor((scrollbar:GetValue() / itemWidth) + 0.5);

	updateFunction();
end

function Earth_FauxScrollFrame_OnVerticalScroll(itemHeight, updateFunction)
	local scrollbar = getglobal(this:GetName().."ScrollBar");
	scrollbar:SetValue(arg1);
	this.offset = floor((scrollbar:GetValue() / itemHeight) + 0.5);

	updateFunction();
end


function FauxScrollFrame_GetOffset(frame)
	return frame.offset;
end

function FauxScrollFrame_SetOffset(frame, offset)
	frame.offset = offset;
end

function EarthSlider_CheckButton_Horizontal(slider)
	local min;
	local max;
	min, max = slider:GetMinMaxValues();
	
	if ( slider:GetValue() <= min ) then
		slider:SetValue(min);
		getglobal(slider:GetName().."ScrollLeftButton"):Disable();
	else
		getglobal(slider:GetName().."ScrollLeftButton"):Enable();
	end
	if (slider:GetValue()  >= max ) then
		slider:SetValue(max);
		getglobal(slider:GetName().."ScrollRightButton"):Disable();
	else
		getglobal(slider:GetName().."ScrollRightButton"):Enable();
	end

end

function EarthSlider_CheckButton_Vertical(slider)
	local min;
	local max;
	min, max = slider:GetMinMaxValues();
	
	if ( slider:GetValue() <= min ) then
		slider:SetValue(min);
		getglobal(slider:GetName().."ScrollUpButton"):Disable();
	else
		getglobal(slider:GetName().."ScrollUpButton"):Enable();
	end
	if (slider:GetValue()  >= max ) then
		slider:SetValue(max);
		getglobal(slider:GetName().."ScrollDownButton"):Disable();
	else
		getglobal(slider:GetName().."ScrollDownButton"):Enable();
	end

end

function EarthSlider_Button_Left()
	local parent = this:GetParent();
	parent:SetValue(parent:GetValue() - parent:GetValueStep());
	PlaySound("UChatScrollButton");
	
	EarthSlider_CheckButton_Horizontal(parent);
end

function EarthSlider_Button_Right()
	local parent = this:GetParent();
	parent:SetValue(parent:GetValue() + parent:GetValueStep());
	PlaySound("UChatScrollButton");

	EarthSlider_CheckButton_Horizontal(parent);
end
