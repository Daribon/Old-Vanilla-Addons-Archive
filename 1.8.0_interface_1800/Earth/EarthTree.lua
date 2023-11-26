--[[
--
--	Earth Tree
--
--		An easy way of rendering structured data.
--
--		by Alexander Brazie
--
--]]
 
EARTHTREE_MAXTITLE_COUNT = 20;
EARTHTREE_TITLE_HEIGHT = 16;
EARTHTREE_EXPAND_INDENT = 16;
EARTHTREE_COLOR_NUMBER = NORMAL_FONT_COLOR;
EARTHTREE_COLOR_STRING = HIGHLIGHT_FONT_COLOR;
EARTHTREE_COLOR_BOOLEAN = GRAY_FONT_COLOR;
EARTHTREE_COLOR_NIL = RED_FONT_COLOR;
EARTHTREE_COLOR_TABLE = RED_FONT_COLOR;
EARTHTREE_COLOR_FUNCTION = GREEN_FONT_COLOR;
EARTHTREE_COLOR_UNKNOWN = GRAY_FONT_COLOR;
EARTHTREE_DEFAULT_FONT = ChatFontNormal;
EARTHTREE_DEFAULT_HIGHLIGHT_COLOR = HIGHLIGHT_FONT_COLOR;

-- Debug Toggles
EARTHTREE_DEBUG = false;
ET_DEBUG = "EARTHTREE_DEBUG";

--[[
--
--	Using EarthTree
--
--	Create a Frame which uses EarthTreeTemplate. 
--
--	Usage:
--		Call either EarthTree_LoadTable or EarthTree_LoadEnhanced, 
--		Then call EarthTree_UpdateFrame to draw to the screen.
--
--
--	Load a normal Lua table using
--	
--	EarthTree_LoadTable(
--		getglobal("YourFrameName"), 
--		tableOfData,
--		functionTable,
--		keyOrder
--		);
--
--	functionTable may contain:
--		onClick - function called when the text is clicked
--			arguments to onClick are:
--				arg1 - table showing the parent hierarchy of the clicked item
--		onCheck - function called when the checkbox is checked or unchecked
--			arguments to onCheck are:
--				arg1 - check state (value or nil)
--				arg2 - table showing the parent hierarchy of the clicked item
--
--			returns:
--				true - the checkbox will be set
--				false - the checkbox will be unset
--				nil - set to whatever state was sent to it.
--
--	Load an enhanced (customized) table using:
--
--	EarthTree_LoadEnhanced(
--		getglobal("YourFrameName"),
--		enhancedTable
--		);
--
--	enhancedTable is a table of numerically indexed elements. 
--		Each enhanced table entry may contain the following:
--
--		{
--			title - the title text
--			titleColor - the color of the title 
--			right - the text bound to the right side
--			rightColor - the color of the right text
--
--			disabled - true if the text cannot be clicked.
--			
--			check - true if a checkbox exists, false if not
--			checked - true if the checkbox is checked, false if not
--			checkDisabled - true if the checkbox is disable, false if not
--
--			radio - uses radio artwork instead of checkbox artwork
--			radioSelected - true if the radio is active, false if not
--			radioDisabled - true if the radio button is disabled
--
--			onClick - function called when the text is clicked
--			onCheck - function called when the checkbox is checked or unchecked
--			onRadio - function called when the radio button is clicked
--
--			tooltip - tooltip text when the text is moused-over
--			checkTooltip - tooltip text when the checkbox is moused-over
--			radioTooltip - tooltip text when the radiobox is moused-over
--			expandTooltip - tooltip text when the expandbox is moused-over
--			
--			noTextIndent - the item will not indent children an extra amount 
--
--			children - a table of enhanced entrys
--			childrenOverride - true if the + should show up even if there are 0 children
--			collapsed - true if the child elements are collapsed(hidden)
--		}
--
--	Each EarthTreeFrame has the following modifiable properties:
--		titleCount - the number of title(rows) shown in the tree
--		highlight - true if the frame will highlight the last clicked item
--		highlightSize - "long" or "short" (short is buggy)
--		
--		tooltip - a string which represents the name of the tooltip used
--		tooltipPlacement - "cursor","button" or "frame"
--		tooltipAnchor - a string which is any valid tooltip anchor
--
--		activeTable - the frame's activeTable
--		
--		collapseAllButton - true if the collapseAll button is shown
--
--		keyOrder is a list of keys to use, in the order you want to use them.
--]]

--[[ Load a generic table for the Frame ]]--
function EarthTree_LoadTable(frame, data, funcTable, keyOrder)
	local newEnhancedTable = {};

	if ( not data ) then Sea.io.error("Attempt to send nil data to ", frame:GetName(), " from ", this:GetName()); end
	if ( not funcTable ) then funcTable = {}; end
	
	-- Since we can only load 2 levels of depth
	-- We simply parse the first set of keys/values
	if ( type(keyOrder) ~= "table" ) then 
		for k,v in data do 
			local entry = EarthTree_CreateEntry(k,v,funcTable,nil);

			-- Set the tooltip
			entry.tooltip = nil; -- No tooltip!

			table.insert(newEnhancedTable, entry);
		end
	else
		for k,v in keyOrder do 
			local entry = EarthTree_CreateEntry(v,data[v],funcTable,nil);

			-- Set the tooltip
			entry.tooltip = nil; -- No tooltip!

			table.insert(newEnhancedTable, entry);
		end
	end

	--[[ Load it ]]--
	EarthTree_LoadEnhanced(frame, newEnhancedTable);
end

--[[ Loads an Enhanced (Complex) Table for the Frame ]]--
function EarthTree_LoadEnhanced(frame, earthTable)
	if ( EarthTree_CheckFrame(frame) and EarthTree_CheckTable(earthTable) ) then
		frame.activeTable = earthTable;
		return true;
	else
		Sea.io.error("Invalid data in LoadEnhanced");
		return nil;
	end
	
end

--[[ Retrieves an Enhanced (Complex) Table from the Frame ]]--
function EarthTree_GetEnhanced(frame)
	if (frame.activeTable) then 
		return frame.activeTable;
	end	
end


--[[ Updates the frame with values from the frame.activeTable object ]]--
function EarthTree_UpdateFrame(frame)
	local flat = {};
	if ( not frame ) then 
		return;
	end

	-- Hide the highlight frame
	if ( getglobal(frame:GetName().."HighlightFrame") ) then
		getglobal(frame:GetName().."HighlightFrame"):Hide();
	end

	-- Check if there's a table
	if ( frame.activeTable ) then
		flat = EarthTree_MakeFlatTable(frame.activeTable);
		local index = 0;
		
		if (frame.titleCount > EARTHTREE_MAXTITLE_COUNT) then
			Sea.io.dprint(ET_DEBUG,frame.titleCount, " exceeds EARTHTREE_MAXTITLE_COUNT (",EARTHTREE_MAXTITLE_COUNT,")");
			frame.titleCount = EARTHTREE_MAXTITLE_COUNT;
		end
		
		for id=1, frame.titleCount do 
			index = FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrame")) + id;
			local value = flat[index];

			if ( value ) then 
				EarthTree_AddItem(frame,value,id);
			else
				EarthTree_ClearItem(frame,id);
			end

		end
		for id=frame.titleCount+1, EARTHTREE_MAXTITLE_COUNT do 
			EarthTree_ClearItem(frame,id);
		end
		Sea.io.dprint(ET_DEBUG,index,",",frame.titleCount);
		
	end

	-- Toggles the collapseAllButton
	if ( frame.collapseAllButton ) then
		if ( getglobal(frame:GetName().."Expand") ) then
			getglobal(frame:GetName().."Expand"):Show();
		end		

		-- Shows or hides the artwork
		if ( frame.collapseAllArtwork ) then
			--getglobal(frame:GetName().."ExpandCollapseAllTabLeft"):SetTexture("Interface\\QuestFrame\\UI-QuestLogSortTab-Left");
			--getglobal(frame:GetName().."ExpandCollapseAllTabMiddle"):SetTexture("Interface\\QuestFrame\\UI-QuestLogSortTab-Middle");
			--getglobal(frame:GetName().."ExpandCollapseAllTabRight"):SetTexture("Interface\\QuestFrame\\UI-QuestLogSortTab-Right");
		else
			--getglobal(frame:GetName().."ExpandCollapseAllTabLeft"):SetTexture();
			--getglobal(frame:GetName().."ExpandCollapseAllTabMiddle"):SetTexture();
			--getglobal(frame:GetName().."ExpandCollapseAllTabRight"):SetTexture();
		end
	else
		if ( getglobal(frame:GetName().."Expand") ) then
			getglobal(frame:GetName().."Expand"):Hide();
		end
	end

	-- ScrollFrame update
	FauxScrollFrame_Update(getglobal(frame:GetName().."ListScrollFrame"), table.getn(flat), frame.titleCount, EARTHTREE_TITLE_HEIGHT, nil, nil, nil, getglobal(frame:GetName().."HighlightFrame"), getglobal(frame:GetName().."HighlightFrame"):GetWidth(), getglobal(frame:GetName().."HighlightFrame"):GetHeight() );

end

--[[ Obtains an item from a GUI index ]]--
function EarthTree_GetItemByID( frame, id ) 
	local nth = id + FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrame"));
	local tableD = EarthTree_MakeFlatTable(frame.activeTable);

	return tableD[nth];
end

--[[
--	Obtains a tooltip for a specific frame/id
--
--]]
function EarthTree_GetTooltipText(frame, id, ttype)
	local item = EarthTree_GetItemByID(frame,id);
	if ( item ) then
		local tooltip = "";
		if ( type(item.tooltip) == "function" ) then 
			tooltip = item.tooltip(item.value, ttype);
		else
			tooltip = item.tooltip;
		end

		if ( ttype == "CHECK" ) then 
			if ( type(item.checkTooltip) == "function" ) then 
				tooltip = item.checkTooltip(item.value, ttype);
			elseif ( type (item.checkTooltip) ~= "nil" ) then
				tooltip = item.checkTooltip;
			end
		elseif ( ttype == "RADIO" ) then 
			if ( type(item.radioTooltip) == "function" ) then 
				tooltip = item.radioTooltip(item.value, ttype);
			elseif ( type (item.radioTooltip) ~= "nil" ) then
				tooltip = item.radioTooltip;
			end
		end
		
		return tooltip;
	else
		return nil;
	end
end


--[[
--
--	Functions beyond this point are tool function and not meant for general use.
--
--	-Alex
--
--]]



--[[
--
--	EarthTree_AddItem(
--		frame - the frame to add the item
--		item - the table containing the item values
--		i - the current index to be updated
--		depth - the number of recursions performed
--		)
--
--	Returns: 
--		i, total
--		i - the new i
--		total - the new total of non-collapsed tree items
--
--]]
function EarthTree_AddItem(frame, item, i, depth) 
	if ( not i ) then i = 1; end
	if ( not depth ) then depth = 0; end

	if ( i > frame.titleCount ) then 
		-- Do nothing
		-- and EarthTree_CheckItem(item)
	elseif ( EarthTree_CheckFrame(frame) ) then
	
		-- If a item exits
		if ( item ) then
			local ldepth = item.depth-1;
			local title = item.title; 

			local titleColor = nil;
			if ( type ( title ) == "function" ) then 
				title, titleColor = title();
			end
			if ( not titleColor ) then titleColor = item.titleColor; end
						
			Sea.io.dprint(ET_DEBUG,frame:GetName(),": ",i," ",title);

			if ( item.disabled ) then 
				getglobal(frame:GetName().."Title"..i.."Button"):Disable();
				getglobal(frame:GetName().."Title"..i.."Button"):SetDisabledTextColor(titleColor.r, titleColor.g, titleColor.b);
			else
				getglobal(frame:GetName().."Title"..i.."Button"):Enable();
			end
			
			-- Title
			if ( title ) then 
				getglobal(frame:GetName().."Title"..i):Show();
				if ( titleColor ) then 
					getglobal(frame:GetName().."Title"..i.."Button"):SetText(title);
					-- Inset																	
					getglobal(frame:GetName().."Title"..i.."Button"):SetTextColor(titleColor.r, titleColor.g, titleColor.b);
					
					getglobal(frame:GetName().."Title"..i.."Button").r = titleColor.r;
					getglobal(frame:GetName().."Title"..i.."Button").g = titleColor.g;
					getglobal(frame:GetName().."Title"..i.."Button").b = titleColor.b;
				else							
					getglobal(frame:GetName().."Title"..i.."Button"):SetText(title);
					getglobal(frame:GetName().."Title"..i.."Button"):SetTextColor(EARTHTREE_COLOR_NUMBER.r,EARTHTREE_COLOR_NUMBER.g,EARTHTREE_COLOR_NUMBER.b);

					getglobal(frame:GetName().."Title"..i.."Button").r = EARTHTREE_COLOR_NUMBER.r;
					getglobal(frame:GetName().."Title"..i.."Button").g = EARTHTREE_COLOR_NUMBER.g;
					getglobal(frame:GetName().."Title"..i.."Button").b = EARTHTREE_COLOR_NUMBER.b;
				end
				getglobal(frame:GetName().."Title"..i):SetWidth(getglobal(frame:GetName().."Title"..i):GetParent():GetWidth()-20);

				
			else
				getglobal(frame:GetName().."Title"..i.."Button"):Hide();	
			end

			-- Tag
			local rightText = item.right;
			local rightColor = nil;
			
			if ( type ( rightText ) == "function" ) then 
				rightText, rightColor = rightText();
			end			
			if ( not rightColor ) then rightColor = item.rightColor; end
			
			Sea.io.dprint(ET_DEBUG,frame:GetName(),": ",i," ",rightText);
			
			if ( rightText ) then 				
				getglobal(frame:GetName().."Title"..i.."Tag"):Show();
				if ( rightColor ) then 
					getglobal(frame:GetName().."Title"..i.."Tag"):SetText(rightText);
					getglobal(frame:GetName().."Title"..i.."Tag"):SetTextColor(rightColor.r, rightColor.g, rightColor.b);
					
					getglobal(frame:GetName().."Title"..i.."Tag").r = rightColor.r;
					getglobal(frame:GetName().."Title"..i.."Tag").g = rightColor.g;
					getglobal(frame:GetName().."Title"..i.."Tag").b = rightColor.b;
				else			
					getglobal(frame:GetName().."Title"..i.."Tag"):SetText(rightText);
					getglobal(frame:GetName().."Title"..i.."Tag"):SetTextColor(EARTHTREE_COLOR_STRING.r,EARTHTREE_COLOR_STRING.g,EARTHTREE_COLOR_STRING.b);
					
					getglobal(frame:GetName().."Title"..i.."Tag").r = EARTHTREE_COLOR_STRING.r;
					getglobal(frame:GetName().."Title"..i.."Tag").g = EARTHTREE_COLOR_STRING.g;
					getglobal(frame:GetName().."Title"..i.."Tag").b = EARTHTREE_COLOR_STRING.b;
				end

			else
				getglobal(frame:GetName().."Title"..i.."Tag"):Hide();
			end

			-- Checkbox Text?
			if ( item.check ) then 
				-- Indent the check symbol
				getglobal(frame:GetName().."Title"..i.."Check"):SetPoint("LEFT",frame:GetName().."Title"..i,"LEFT",EARTHTREE_EXPAND_INDENT*(ldepth)-2, 2 );

				getglobal(frame:GetName().."Title"..i.."Check"):Show();

				-- If might be checked...
				if ( item.checked ) then 
					getglobal(frame:GetName().."Title"..i.."Check"):SetChecked(1);
				else
					getglobal(frame:GetName().."Title"..i.."Check"):SetChecked(nil);
				end

				-- If its disabled...
				if ( item.checkDisabled ) then
					getglobal(frame:GetName().."Title"..i.."Check"):Disable();
				else
					getglobal(frame:GetName().."Title"..i.."Check"):Enable();
				end

				-- Indent
				ldepth = ldepth + 1;

			else
				getglobal(frame:GetName().."Title"..i.."Check"):Hide();
			end

			-- Radio Box?
			if ( item.radio ) then 
				-- Indent the check symbol
				getglobal(frame:GetName().."Title"..i.."Radio"):SetPoint("LEFT",frame:GetName().."Title"..i,"LEFT",EARTHTREE_EXPAND_INDENT*(ldepth)-2, 2 );

				getglobal(frame:GetName().."Title"..i.."Radio"):Show();

				-- If might be checked...
				if ( item.radioSelected ) then 
					getglobal(frame:GetName().."Title"..i.."Radio"):SetChecked(1);
				else
					getglobal(frame:GetName().."Title"..i.."Radio"):SetChecked(nil);
				end

				-- If its disabled...
				if ( item.radioDisabled ) then
					getglobal(frame:GetName().."Title"..i.."Radio"):Disable();
				else
					getglobal(frame:GetName().."Title"..i.."Radio"):Enable();
				end

				-- Indent
				ldepth = ldepth + 1;

			else
				getglobal(frame:GetName().."Title"..i.."Radio"):Hide();
			end

			-- display the highlight
			if ( frame.highlight ) then
				-- Check if its the selected item
				if ( EarthTree_GetSelected(frame) == item ) then 
					--- Highlight Sizes
					if ( frame.highlightSize == "short" ) then 						
						getglobal(frame:GetName().."HighlightFrame"):ClearAllPoints();
						getglobal(frame:GetName().."HighlightFrame"):SetPoint("TOPLEFT", frame:GetName().."Title"..i, "TOPLEFT", EARTHTREE_EXPAND_INDENT*(ldepth), -1);
					else
						getglobal(frame:GetName().."HighlightFrame"):SetAllPoints(frame:GetName().."Title"..i);
					end
					
					-- If there's a highlight color
					if ( frame.highlightColor ) then
						getglobal(frame:GetName().."HighlightFrameHighlight"):SetVertexColor(frame.highlightColor.r,frame.highlightColor.g,frame.highlightColor.b);
					else
						getglobal(frame:GetName().."HighlightFrameHighlight"):SetVertexColor(EARTHTREE_DEFAULT_HIGHLIGHT_COLOR.r,EARTHTREE_DEFAULT_HIGHLIGHT_COLOR.g,EARTHTREE_DEFAULT_HIGHLIGHT_COLOR.b);
					end

					-- Render the highlight
					getglobal(frame:GetName().."HighlightFrame"):Show();
				end					
			end

			-- all children items
			if ( item.children and (table.getn(item.children) > 0 or item.childrenOverride) ) then
				-- Indent the + symbol
				getglobal(frame:GetName().."Title"..i.."Expand"):SetPoint("TOPLEFT",frame:GetName().."Title"..i,"TOPLEFT",EARTHTREE_EXPAND_INDENT*(ldepth) -2, 2 );
				getglobal(frame:GetName().."Title"..i.."Expand"):Enable(); 
				getglobal(frame:GetName().."Title"..i.."Expand"):Show(); 
				
				-- Ignore collapsed items
				if ( item.collapsed ) then 
					getglobal(frame:GetName().."Title"..i.."Expand"):SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				else
					getglobal(frame:GetName().."Title"..i.."Expand"):SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up"); 
					getglobal(frame:GetName().."Title"..i.."Expand".."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
					
				end
			else
				getglobal(frame:GetName().."Title"..i.."Expand"):Hide(); 
				getglobal(frame:GetName().."Title"..i.."Expand"):Disable(); 
				getglobal(frame:GetName().."Title"..i.."Expand"):SetNormalTexture(""); 
				getglobal(frame:GetName().."Title"..i.."Expand".."Highlight"):SetTexture("");		
			end

			-- Indent the text further if its marked as indented
			if ( not item.noTextIndent ) then 
				ldepth = ldepth + 1;
			end

			-- Indent the text
			getglobal(frame:GetName().."Title"..i.."Button"):SetPoint("TOPLEFT",frame:GetName().."Title"..i,"TOPLEFT",EARTHTREE_EXPAND_INDENT*(ldepth), 0 );
			getglobal(frame:GetName().."Title"..i.."Button"):SetWidth( getglobal(frame:GetName().."Title"..i):GetWidth() - ldepth * EARTHTREE_EXPAND_INDENT );

			-- Set the text width
			if ( item.right ) then
				local newWidth =  getglobal(frame:GetName().."Title"..i):GetWidth() - getglobal(frame:GetName().."Title"..i.."Tag"):GetStringWidth() - ldepth * EARTHTREE_EXPAND_INDENT - 2;
				-- Ideally this should be changed so frame scrolls left/right, needs looking at.
				if (newWidth < 1) then
					newWidth = 1;
				end
				getglobal(frame:GetName().."Title"..i.."ButtonNormalText"):SetWidth( newWidth );
				getglobal(frame:GetName().."Title"..i.."ButtonHighlightText"):SetWidth( newWidth );
				getglobal(frame:GetName().."Title"..i.."ButtonDisabledText"):SetWidth( newWidth );
			else
				local newWidth = getglobal(frame:GetName().."Title"..i):GetWidth() - ldepth * EARTHTREE_EXPAND_INDENT - 2;
				-- Ideally this should be changed so frame scrolls left/right, needs looking at.
				if (newWidth < 1) then
					newWidth = 1;
				end
				getglobal(frame:GetName().."Title"..i.."ButtonNormalText"):SetWidth( newWidth );
				getglobal(frame:GetName().."Title"..i.."ButtonHighlightText"):SetWidth( newWidth );
				getglobal(frame:GetName().."Title"..i.."ButtonDisabledText"):SetWidth( newWidth );
			end

		end
	end
	
	return i;
end

--[[ Clear's a Tree's Item ]]--
function EarthTree_ClearItem(frame, i ) 
	if ( i > 0  and i <= EARTHTREE_MAXTITLE_COUNT ) then
		getglobal(frame:GetName().."Title"..i):Hide();
		getglobal(frame:GetName().."Title"..i.."Tag"):Hide();					
		getglobal(frame:GetName().."Title"..i.."Check"):Hide();
		getglobal(frame:GetName().."Title"..i.."Expand"):Disable(); 
		getglobal(frame:GetName().."Title"..i.."Expand"):SetNormalTexture(""); 
		getglobal(frame:GetName().."Title"..i.."Expand".."Highlight"):SetTexture("");		
	end
end


--[[ Makes a flat tree from the activeTable, skipping collapsed trees according to setting ]]--

function EarthTree_MakeFlatTable(theTable, depth, ignoreCollapsed)
	if ( not depth ) then depth = 0; end
	if ( ignoreCollapsed == nil ) then ignoreCollapsed = true; end
	local flatTable = {};
	local myTable = theTable;
	local i = 0;

	-- If the table doesnt exist, then the flat table is empty
	if ( myTable == nil ) then 
		return {};
	end

	for k,v in myTable do
		v.depth = depth;
		table.insert(flatTable, v);

		if ( v.children and (not v.collapsed or ignoreCollapsed == false ) ) then 
			local flatChildren = EarthTree_MakeFlatTable(v.children, depth + 1, ignoreCollapsed);

			for k2,v2 in flatChildren do
				table.insert(flatTable,v2);
			end		
		end
	end

	return flatTable;
end

--[[ Collapses a Tree ]]--
function EarthTree_SetItemCollapsed( frame, id, state ) 
	local count = 0;
	local nth = id+FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrame"));
	local myTable = EarthTree_MakeFlatTable(frame.activeTable);

	if ( myTable[nth] ) then
		myTable[nth].collapsed = state;
	end

	EarthTree_UpdateFrame(frame);
end

--[[ Set the selected ID ]]--
function EarthTree_SetSelectedByID(frame,id)
	local nth = id+FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrame"));
	local flat = EarthTree_MakeFlatTable(frame.activeTable, nil, true);

	if ( flat[nth] ) then 
		frame.selected = flat[nth];
	else
		frame.selected = nil;
	end
end

--[[ Get the selected object or nil ]]--
function EarthTree_GetSelected(frame)
	if ( frame.selected ) then 
		return frame.selected;
	end
	return nil;
end

--[[
--	Returns the number of nodes in a table counting .children tables
--]]
function EarthTree_GetNodeCount( tableD, ignoreCollapsed )
	local count = 0;

	if ( tableD.children ) then 
		if ( ignoreCollapsed and tableD.collapsed ) then 
		else
			count = count + table.getn(tableD.children);
			for k,v in tableD.children do 
				if ( v.children ) then 
					count = count + EarthTree_GetNodeCount(v, ignoreCollapsed);
				end
			end
		end
	end

	return count;
end


--[[
--	Returns the number of nodes in a table counting .children tables
--]]
function EarthTree_GetFullCount( tableD, ignoreCollapsed )
	local count = table.getn( tableD );

	for k,v in tableD do 
		if ( v.children ) then 
			if ( v.collapsed and ignoreCollapsed ) then 
			else
				count = count + table.getn(v.children);
				for k2,v2 in v.children do 
					if ( v2.children ) then 
						count = count + EarthTree_GetNodeCount(v2, ignoreCollapsed);
					end
				end
			end
		end
	end

	return count;
end


--[[ Validates a Frame ]]--
function EarthTree_CheckFrame(frame)
	if ( frame ) then 
		return true;	
	else
		Sea.io.error("Invalid frame passed to EarthTree_CheckFrame");
		return nil;
	end
end

--[[ Validates a Table ]]--
function EarthTree_CheckTable(data)
	if ( not data ) then 
		Sea.io.error("Data sent to EarthTree is nil! Name:", this:GetName() );
		return false;
	end

	if ( type(data) ~= "table" ) then 
		Sea.io.error("Data sent to EarthTree is not a table! Name:", this:GetName() );
		return false;
	end

	for k,v in data do 
		--Something
		if ( type(k) ~= "number" ) then 
			Sea.io.error("Invalid index in data: ",this:GetName() );
			return false;
		end
	
		if ( EarthTree_CheckItem(v) == false ) then
			Sea.io.error("Invalid item: ",k);
			return false;
		end
	end

	return true;
end

--[[ Validates a Table Item ]]--
function EarthTree_CheckItem(item)
	if ( not item.title and not item.right ) then 
		Sea.io.error("No title or subtext provided: ",this:GetName() );
		return false;
	end

	-- Now subfunctioned, this may never be used.
	if ( not item.titleColor ) then 
		item.titleColor = EARTHTREE_COLOR_STRING;
	end
		
	if ( not item.rightColor ) then 
		item.rightColor = EARTHTREE_COLOR_STRING;
	end

	if ( item.children ) then 
		return EarthTree_CheckTable(item.children);
	end
end	

--[[ Creates an Entry out of a Standard Table ]]--
function EarthTree_CreateEntry(k,v,funcTable,parents)
	local entry = {};

	-- Create the parent chain
	if ( not parents ) then
		parents = {};
	end

	-- Set the title portion
	if ( type(k) == "table" ) then 
		entry.title = EARTHTREE_KEYWORD_TABLE;
		entry.titleColor = EARTHTREE_COLOR_STRING;
	elseif ( type(k) == "function" ) then
		entry.title = EARTHTREE_KEYWORD_FUNCTION;
		entry.titleColor = EARTHTREE_COLOR_STRING;
	elseif ( type(k) == "nil" ) then 
		entry.title = EARTHTREE_KEYWORD_NIL;
		entry.titleColor = EARTHTREE_COLOR_NUMBER;
	elseif ( type(k) == "number" ) then 
		entry.title = "["..k.."]";
		entry.titleColor = EARTHTREE_COLOR_NUMBER;
	elseif ( type(k) == "boolean" ) then 
		if ( k ) then 
			entry.title = "|".."true".."|";
		else
			entry.title = "|".."false".."|";
		end
		entry.titleColor = EARTHTREE_COLOR_BOOLEAN;		
		
	elseif ( type(k) == "string" ) then 
		entry.title = k;
		entry.titleColor = EARTHTREE_COLOR_STRING;
	else
		entry.title = EARTHTREE_KEYWORD_UNKNOWN;
		entry.titleColor = EARTHTREE_COLOR_UNKNOWN;
	end

	-- Set the secondary value
	if ( type(v) == "table" ) then
		entry.right = EARTHTREE_KEYWORD_TABLE;
		entry.rightColor = EARTHTREE_COLOR_TABLE;

		entry.children = {};
		-- Ooh, its a table! Parse its children.
		for k2,v2 in v do 
			-- Create the parent hierarchy!
			local newParent = {};
			for k3,v3 in parents do 
				table.insert(newParent, v3);
			end
			
			-- Add the current parent
			table.insert(newParent, k);
			
			-- Add kids
			local kid = EarthTree_CreateEntry(k2,v2,funcTable,newParent);
			table.insert(entry.children, kid);
		end

		entry.expandTooltip = EARTHTREE_EXPAND_INFO..EarthTree_GetNodeCount( entry );
		
	elseif ( type(v) == "function" ) then
		entry.right = EARTHTREE_KEYWORD_FUNCTION;
		entry.rightColor = EARTHTREE_COLOR_FUNCTION;
	elseif ( type(v) == "nil" ) then 
		entry.right = EARTHTREE_KEYWORD_NIL;
		entry.rightColor = EARTHTREE_COLOR_NIL;
	elseif ( type(v) == "number" ) then 
		entry.right = v;
		entry.rightColor = EARTHTREE_COLOR_NUMBER;
	elseif ( type(v) == "string" ) then 
		entry.right = '"'..v..'"';
		entry.rightColor = EARTHTREE_COLOR_STRING;
	elseif ( type(v) == "boolean" ) then 
		if ( v ) then 
			entry.right = "true";
		else
			entry.right = "false";
		end
		entry.rightColor = EARTHTREE_COLOR_BOOLEAN;
	else
		entry.right = EARTHTREE_KEYWORD_UNKNOWN;
		entry.rightColor = EARTHTREE_COLOR_UNKNOWN;
	end

	-- Set the functions
	if ( funcTable.onClick ) then
		entry.onClick = funcTable.onClick;
	end
	if ( funcTable.onCollapseClick ) then
		entry.onCollapseClick = funcTable.onCollapseClick;
	end
	if ( funcTable.onDoubleClick ) then
		entry.onDoubleClick = funcTable.onDoubleClick;
	end
	if ( funcTable.onCheck ) then
		entry.onCheck = funcTable.onCheck;
	end


	-- Set the value passed back to the function
	entry.value = {key=k,value=v,parent=parents};

	return entry;
end

--[[
--	HandleAction
--
--	Delegates particular actions to events
--
--]]
function EarthTree_HandleAction (frame, id, action, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
	Sea.io.dprint(ET_DEBUG, frame:GetName(),": ",id," [",action,"]");
	
	local update = true;
	if ( action == "CLICK_EXPAND" or action == "CLICK_COLLAPSE") then 
		if ( id > 0 ) then 
			local item = EarthTree_GetItemByID(frame,id);
			local collapse = false;
			if ( not item.collapsed ) then 
				collapse = true;
			end		
			if ( item ) then 
				if ( item.onCollapseClick ) then
					local newCollapse = nil;
					newCollapse = item.onCollapseClick(collapse, item.value);
					
					if ( newCollapse ~= nil ) then 
						collapse = newCollapse;
					end
				end
			end

			EarthTree_SetItemCollapsed(frame,id, collapse);
		else
			EarthTree_CollapseAllToggle(frame);
		end
	elseif ( action == "CLICK_TEXT" ) then 
		if ( id > 0 ) then 
			local item = EarthTree_GetItemByID(frame,id);
			if ( item ) then 
				if ( item.onClick ) then 
					item.onClick(item.value);
				end
			end
			
			-- Set the selection
			EarthTree_SetSelectedByID(frame,id);
		end	
	elseif ( action == "DOUBLECLICK_TEXT" ) then 
		if ( id > 0 ) then 
			local item = EarthTree_GetItemByID(frame,id);
			if ( item ) then 
				if ( item.onDoubleClick ) then 
					item.onDoubleClick(item.value);
				end
			end
			
			-- Set the selection
			EarthTree_SetSelectedByID(frame,id);
		end	
	elseif ( action == "CLICK_CHECK" ) then 
		if ( id > 0 ) then 
			local item = EarthTree_GetItemByID(frame,id);
			if ( item ) then
				local checked = nil;
				if ( item.onCheck ) then 
					checked = item.onCheck(a1, item.value);
				end

				if ( checked == nil ) then 
					-- Set the checkbox state.
					item.checked = a1;
				else
					item.checked = checked;
				end
			end
		end
	elseif ( action == "CLICK_RADIO" ) then 
		if ( id > 0 ) then 
			local item = EarthTree_GetItemByID(frame,id);
			if ( item ) then 
				if ( item.onRadio ) then 
					item.onRadio(a1, item.value);
				end

				-- Set the checkbox state.
				item.radioSelected = a1;
			end
		end
	elseif ( action == "ENTER_TEXT" ) then 
		local tooltipText = EarthTree_GetTooltipText(frame,id);
		EarthTree_SetTooltip(frame, tooltipText);	
		update = false;
	elseif ( action == "ENTER_CHECK" ) then
		local tooltipText = EarthTree_GetTooltipText(frame,id, "CHECK");
		EarthTree_SetTooltip(frame, tooltipText);
		update = false;
	elseif ( action == "ENTER_RADIO" ) then
		local tooltipText = EarthTree_GetTooltipText(frame,id, "RADIO");
		EarthTree_SetTooltip(frame, tooltipText);
		update = false;
	elseif ( action == "ENTER_EXPAND" ) then 
		local tooltipText = EarthTree_GetTooltipText(frame,id, "EXPAND");
		EarthTree_SetTooltip(frame, tooltipText);
		update = false;
	elseif ( action == "LEAVE_TEXT" or action == "LEAVE_CHECK" or action == "LEAVE_EXPAND" ) then
		EarthTree_HideTooltip(frame);
		update = false;
	end

	-- Prevent unnessecary re-draws
	if ( update ) then
		-- Update the gui
		EarthTree_UpdateFrame( frame );
	end
end


--
--	Sets the location of the Tooltip
--
function EarthTree_SetTooltip(frame, tooltipText) 
	if ( frame.tooltip ) then 
		local tooltip = getglobal(frame.tooltip);
		if ( tooltipText ) then 	
			-- Set the location of the tooltip
			if ( frame.tooltipPlacement == "cursor" ) then
				tooltip:SetOwner(UIParent,"ANCHOR_CURSOR");	
			elseif ( frame.tooltipPlacement == "button" ) then
				tooltip:SetOwner(this,frame.tooltipAnchor);	
			else
				tooltip:SetOwner(frame,frame.tooltipAnchor);				
			end

			Sea.wow.tooltip.protectTooltipMoney();
			tooltip:SetText(tooltipText, 0.8, 0.8, 1.0);
			tooltip:Show();
			Sea.wow.tooltip.unprotectTooltipMoney();		
		end
	end
end

--
--	Hides the location of the Tooltip
--
function EarthTree_HideTooltip(frame)
	if ( frame.tooltip ) then 		
		getglobal(frame.tooltip):Hide();
		getglobal(frame.tooltip):SetOwner(UIParent, "ANCHOR_RIGHT");
	end
end

--[[
--	All Object Event Handlers are Below
--
--]]

--[[ MouseWheel Events ]]
function EarthTree_OnMouseWheel(frameName, delta)
	local offset = FauxScrollFrame_GetOffset(getglobal(frameName.."ListScrollFrame"));
	local maxOffset = EarthTree_GetFullCount( getglobal(frameName).activeTable, true) - getglobal(frameName).titleCount;
	local scrollbar = getglobal(frameName.."ListScrollFrameScrollBar")
	local min,max = scrollbar:GetMinMaxValues();

	if ( type(offset) == "number" ) then 
		local newVal = offset - delta;
		if ( newVal >= 0 and newVal <= maxOffset ) then
			scrollbar:SetValue(newVal/maxOffset*max);
			FauxScrollFrame_SetOffset(getglobal(frameName.."ListScrollFrame"), newVal );
			EarthTree_UpdateFrame(getglobal(frameName));
		elseif ( newVal > maxOffset ) then 
			if ( maxOffset < 0 ) then 
				offset = 0;
				maxOffset = 1;
			else
				offset = maxOffset;
			end
			scrollbar:SetValue(offset/maxOffset*max);
			
			FauxScrollFrame_SetOffset(getglobal(frameName.."ListScrollFrame"), offset);
			EarthTree_UpdateFrame(getglobal(frameName));
		end
	end
end

--[[ CheckButton Events ]]--
function EarthTree_CheckButton_OnLoad()
	--this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp");
	this:RegisterForClicks("LeftButtonDown", "RightButtonDown");

	this.onEnter = EarthTree_CheckButton_OnEnter;
	this.onLeave = EarthTree_CheckButton_OnLeave;
	this.onClick = EarthTree_CheckButton_OnClick;
	this.onMouseWheel = EarthTree_ExpandButton_OnMouseWheel;
	
end	
function EarthTree_CheckButton_OnEnter()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"ENTER_CHECK", this:GetChecked());
end
function EarthTree_CheckButton_OnLeave()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"LEAVE_CHECK", this:GetChecked());
end
function EarthTree_CheckButton_OnClick()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"CLICK_CHECK", this:GetChecked());
end


--[[ CheckButton Events ]]--
function EarthTree_RadioButton_OnLoad()
	--this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp");
	this:RegisterForClicks("LeftButtonDown", "RightButtonDown");

	this.onEnter = EarthTree_RadioButton_OnEnter;
	this.onLeave = EarthTree_RadioButton_OnLeave;
	this.onClick = EarthTree_RadioButton_OnClick;
	this.onMouseWheel = EarthTree_ExpandButton_OnMouseWheel;
	
end	
function EarthTree_RadioButton_OnEnter()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"ENTER_RADIO", this:GetChecked());
end
function EarthTree_RadioButton_OnLeave()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"LEAVE_RADIO", this:GetChecked());
end
function EarthTree_RadioButton_OnClick()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"CLICK_RADIO", this:GetChecked());
end

--[[ Expand Button Event Handlers ]]--
function EarthTree_ExpandButton_OnLoad()
	--this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp");
	this:RegisterForClicks("LeftButtonDown", "RightButtonDown");

	this.onEnter = EarthTree_ExpandButton_OnEnter;
	this.onClick = EarthTree_ExpandButton_OnClick;
	this.onLeave = EarthTree_ExpandButton_OnLeave;	
	this.onMouseWheel = EarthTree_ExpandButton_OnMouseWheel;

end

function EarthTree_ExpandButton_OnEnter()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"ENTER_EXPAND");
end

function EarthTree_ExpandButton_OnClick()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"CLICK_EXPAND");
end

function EarthTree_ExpandButton_OnLeave()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"LEAVE_EXPAND");
end
function EarthTree_ExpandButton_OnMouseWheel(delta)
	local frameName = this:GetParent():GetParent():GetName();
	EarthTree_OnMouseWheel(frameName, delta);
end

--[[ Clicking on Text Event Handlers ]]--
function EarthTree_ButtonFrame_OnLoad()
	this.onEnter = EarthTree_Text_OnEnter;
	this.onClick = EarthTree_Text_OnClick;
	this.onLeave = EarthTree_Text_OnLeave;	
	this.onDoubleClick = EarthTree_Text_OnDoubleClick;
	this.onMouseWheel = EarthTree_Text_OnMouseWheel;
end

function EarthTree_Text_OnLoad()
	--this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp");
	this:RegisterForClicks("LeftButtonDown", "RightButtonDown");

	this.onEnter = EarthTree_Text_OnEnter;
	this.onClick = EarthTree_Text_OnClick;
	this.onLeave = EarthTree_Text_OnLeave;	
	this.onDoubleClick = EarthTree_Text_OnDoubleClick;
	this.onMouseWheel = EarthTree_Text_OnMouseWheel;
end

function EarthTree_Text_OnEnter()
	-- Highlights the 2ndary text on mouseover
	getglobal(this:GetParent():GetName().."Tag"):SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);

	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"ENTER_TEXT");	
end

function EarthTree_Text_OnClick()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"CLICK_TEXT");
end

function EarthTree_Text_OnDoubleClick()
	EarthTree_HandleAction(this:GetParent():GetParent(),this:GetParent():GetID(),"DOUBLECLICK_TEXT");
end


function EarthTree_Text_OnMouseWheel(delta)
	local frameName = this:GetParent():GetParent():GetName();
	EarthTree_OnMouseWheel(frameName, delta);
end
function EarthTree_Text_OnLeave()
	if (this:GetParent():GetID() ~= this:GetParent():GetParent().selectedId) then
		local button = getglobal(this:GetName());
		button:SetTextColor(button.r, button.g,button.b);
		local check = getglobal(this:GetParent():GetName().."Check");
		check:SetTextColor(check.r, check.g, check.b);
		local tag = getglobal(this:GetParent():GetName().."Tag");
		tag:SetTextColor(tag.r, tag.g,tag.b);
	end
	
	-- Hides the parent tooltip
	EarthTree_HideTooltip(this:GetParent():GetParent());
end

--[[ Collapse All Button Event Handlers ]]--
function EarthTree_CollapseAllButton_OnLoad()
	--this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp");
	getglobal(this:GetName().."Button"):RegisterForClicks("LeftButtonDown", "RightButtonDown");
	getglobal(this:GetName().."Button"):SetText(ALL);
	getglobal(this:GetName().."Button"):SetWidth(this:GetWidth());
	getglobal(this:GetName().."Button"):SetPoint("TOPLEFT", this:GetName(), "TOPLEFT", EARTHTREE_EXPAND_INDENT, -2);

	this.onClick = EarthTree_CollapseAllButton_OnClick;
	this.onEnter = EarthTree_CollapseAllButton_OnEnter;
	this.onLeave = EarthTree_CollapseAllButton_OnLeave;
	getglobal(this:GetName().."Button").onClick = EarthTree_CollapseAllButton_OnClick;
	getglobal(this:GetName().."Expand").onClick = EarthTree_CollapseAllButton_Icon_OnClick;
	getglobal(this:GetName().."Button").onEnter = EarthTree_CollapseAllButton_OnEnter;
	getglobal(this:GetName().."Expand").onEnter = EarthTree_CollapseAllButton_Icon_OnEnter;
	getglobal(this:GetName().."Button").onLeave = EarthTree_CollapseAllButton_OnLeave;
	getglobal(this:GetName().."Expand").onLeave = EarthTree_CollapseAllButton_Icon_OnLeave;
end


function EarthTree_CollapseAllButton_Icon_OnClick()
	EarthTree_HandleAction(this:GetParent():GetParent():GetParent(),0,"CLICK_COLLAPSE");

end
function EarthTree_CollapseAllButton_OnClick()
	EarthTree_HandleAction(this:GetParent():GetParent():GetParent(),0,"CLICK_COLLAPSE");

end
function EarthTree_CollapseAllButton_OnEnter()
end
function EarthTree_CollapseAllButton_Icon_OnEnter()
end
function EarthTree_CollapseAllButton_OnLeave()
end
function EarthTree_CollapseAllButton_Icon_OnLeave()
end

--[[
--	Toggles the collapsed state of all trees.
--]]
function EarthTree_CollapseAllToggle(frame)
	local count = 0;
	local myTable = EarthTree_MakeFlatTable(frame.activeTable, nil, false);

	-- Check if they are all collapsed
	for k,v in myTable do 
		if ( v.collapsed ) then 
			count = count + 1;
		end
	end

	-- If they are all collapsed
	if ( count == table.getn(myTable) ) then 
		-- Expand them all
		for k,v in myTable do 
			myTable[k].collapsed = false;
		end
		
		getglobal(frame:GetName().."Expand".."CollapseAllExpand"):SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up"); 		
	else
		-- Collapse them all
		for k,v in myTable do
			myTable[k].collapsed = true;
		end

		getglobal(frame:GetName().."Expand".."CollapseAllExpand"):SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	end

	EarthTree_UpdateFrame(frame);
end


--[[ Frame Event handlers ]]--
function EarthTree_Frame_OnLoad()
	this.onClick = EarthTree_Frame_OnClick;
	this.onShow = EarthTree_Frame_OnShow;
	this.onEvent = EarthTree_Frame_OnEvent;
	this.onMouseWheel = EarthTree_Frame_OnMouseWheel;
	
	--
	-- Sets the default object values
	-- 
	this.titleCount = EARTHTREE_MAXTITLE_COUNT;
	this.highlight = true;
	this.highlightSize = "long"; 	-- Can also be "short" [Buggy]
	this.extraIndent = true; -- Indents child nodes once all the of the time

	-- Use any tooltip you'd like. I use my own
	this.tooltip = "EarthTooltip";
	
	--
	-- Can be "button", "frame", "cursor"
	-- 
	this.tooltipPlacement = "cursor"; 	
	this.tooltipAnchor = "ANCHOR_RIGHT"; -- Can be any valid tooltip anchor
	this.activeTable = {};

	--
	-- Shows or hides the expand all button
	--
	this.collapseAllButton = true;
	this.collapseAllArtwork = true;

	-- Hide all buttons once
	for i=1,this.titleCount do
		getglobal(this:GetName().."Title"..i):Show();
	end
	for i=this.titleCount+1, EARTHTREE_MAXTITLE_COUNT do
		getglobal(this:GetName().."Title"..i):Hide();
	end
end

function EarthTree_Frame_OnShow()
	EarthTree_UpdateFrame(this);
end

function EarthTree_Frame_OnClick()
end

function EarthTree_Frame_OnEvent()
end

function EarthTree_Frame_OnMouseWheel(delta)
	local frameName = this:GetName();
	EarthTree_OnMouseWheel(frameName, delta);
end


--[[
--
--	Earth Tree Demo Code
--
--
--
--
function dt()
	local tree = {
		a = "a";
		b = "b";
		c = "c";
		d = "d";
		e = "e";
		f = {
			1,2,3,4,5,6,7,8;
			a={
				11,22,33,44,55;
			};
			b={
				66,77,88,99,110;
			};
		};

	};
	local eTree = { 
		{
			title="a";
			right="b";
			tooltip="Hail!";
			onClick = function(a) Sea.io.print(a); end;
			children = {
				{
					title="a's child";
					right="(some thing)";
					onClick = function(a) Sea.io.error(a); end;
					children = {
						{
							title="a's first grandkid";
							check=true;
							checked=true;
							onCheck = function(check) Sea.io.print(check) end;
							onClick = function( a ) Sea.io.print(a); end;
							children = {
								{
									check=true;
									checked=1;
									title="great grandkid";
									onClick = function( a ) Sea.io.error(a,"!") end;
								}
							};
						};
						{
							title="a's second grandkid";
							check=true;
							checked=true;
							checkDisabled=true;
							onCheck = function(check) Sea.io.print(check) end;
							onClick = function( a ) Sea.io.print(a); end;
							children = {
								{
									check=true;
									checked=1;
									title="great grandkid";
									onClick = function( a ) Sea.io.error(a,"!") end;
								}
							};
						};
					};
				};
				{
					title="a's child 2";
					right="(some other thing)";
					tooltip="Simon";
					onClick = function(a) Sea.io.error(a); end;
				};
				{
					title="a's child 3";
					right="(some other2 thing)";
					tooltip="Alvin";
					onClick = function(a) Sea.io.error(a); end;
				}
			};
		};
		{
			title="two";
			right="5";
			onClick = function(a) Sea.io.print(a); end;
			children = {
				{
					title="two's child";
					tooltip="Theodore";
					right="(some OTHER)";
					rightColor={r=1.0,g=.24,b=0};
					onClick = function(a) Sea.io.print(a); end;
				}
			};
		};
		
		{
			title="three";
			right="99 Bottles";
			onClick = function(a) Sea.io.print(a); end;
			children = {
				{
					title="three's child";
					right="(some third thing)";
					rightColor={r=1.0,g=.24,b=0};
					onClick = function(a) Sea.io.print(a); end;
				}
			};
		};
		
	};
	EarthTree_LoadTable(
		getglobal("EarthTree"), 
		tree,
		{
			onClick = function(a) Sea.io.printTable(a); end;
		},
		);
	EarthTree_LoadEnhanced(
		getglobal("EarthTree"), 
		eTree
		);
	EarthTree_UpdateFrame(
		getglobal("EarthTree")
		); 
end
]]
