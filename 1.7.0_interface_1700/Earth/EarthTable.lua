--[[
--
--	Earth Table
--		By Alexander Brazie
--
--	A spreadsheet style organization system.
--
--]]

EARTHTABLE_HEADER_HEIGHT = 24;
EARTHTABLE_ROW_HEIGHT = 16;
EARTHTABLE_HEADER_MAX = 6;
EARTHTABLE_ROW_MAX = 20;

EARTHTABLE_DEFAULT_HEADER_COLOR = NORMAL_FONT_COLOR;
EARTHTABLE_DEFAULT_DATA_COLOR = HIGHLIGHT_FONT_COLOR;

EARTHTABLE_DEBUG = false;
ETABLE_DEBUG = "EARTHTABLE_DEBUG";

--[[
--
--	Using EarthTable
--
--	Create a frame which inherits EarthTableFrameTemplate
--
--	Then create your database, a table with key-value pairs. This can be
--	any type of lua table, so long as the first level index is numbers only.
--
--	e.g. database = {
--		[1] = {name="Alex";class="Warlock";onClick=function() Sea.io.print("hi!");};
--		[2] = {name="John";class="Priest";onClick=function() Sea.io.print("GoAway!");};
--		};
--
--		
--
--	Then create the headers. 
--
--	The header list should be a list of all possible headers. 
--		Each header can have:
--			
--		.title - Header title
--		.titleColor - color of the title text
--		.textColor - color of the table text for that col.
--		.key - [REQUIRED] the database key used for that row. 
--			(In this case, "name" or "class" would work).
--		.disabled - not clickable if true
--
--		.stick - true if the header should not be removed when changing pages. 
--			No more than 1 of these per table for your own sake.
--
--		.width - maximum width of the column.
--			If the width is larger than the whole table, it will be shrunken.
--	
--	Then call 
--		EarthTable_LoadDatabase(MyTableFrame, myDatabase);
--		EarthTable_LoadHeaders(MyTableFrame, myHeaders);
--		EarthTable_UpdateFrame(MyTableFrame);
--
--]]


--[[ Updates a single frame ]]--
function EarthTable_UpdateFrame(frame)
	local headerBudget = frame.headerSpace;

	local vOffset = FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrameV"));
	local hOffset = FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrameH"));

	local currentOffset = nil;
	local newActiveHeaders = {};
	local stickCount = 0;
	
	for k,v in frame.activeHeaders do
		if ( frame.headerList[v].stick and headerBudget > frame.headerList[v].width ) then 
			table.insert(newActiveHeaders, v);
			headerBudget = headerBudget - frame.headerList[v].width;
			stickCount = stickCount + 1;
		end
	end

	-- Cycle through all headers. Fit as many as possible
	for i=hOffset+1, table.getn(frame.headerList) do
		if ( frame.headerList[i] ) then
			local alreadyAdded = false;

			-- Ensure we don't add the same header multiple times
			for k,v in newActiveHeaders do 
				if ( v == i ) then 
					alreadyAdded = true;
				end
			end
		
			-- If its not already added...
			if ( not alreadyAdded ) then
				-- If we have any headerspace left
				if ( headerBudget >= frame.headerList[i].width and table.getn(newActiveHeaders) <= frame.headerMax ) then 
					table.insert(newActiveHeaders, i);
					headerBudget = headerBudget - frame.headerList[i].width;
				-- But if we also have no headers, accept this header
				elseif ( table.getn(newActiveHeaders) == stickCount ) then 
					table.insert(newActiveHeaders, i); 
					break;
				else
					break;
				end
			end
		end
	end

	-- Clear all headers and cells
	for j=1,EARTHTABLE_HEADER_MAX do
		local header = getglobal(frame:GetName().."ColumnHeader"..j);
	
		EarthTable_Header_Clear(header);
		header:Hide();
		for i=1,frame.rowCount do			
			local nth = i + vOffset;
			local cell = getglobal(frame:GetName().."Row"..i.."Cell"..j);
			
			-- Hide unused cells.
			EarthTable_Cell_Clear(cell);
		end
	end
	
	frame.activeHeaders = newActiveHeaders;

	-- Reset the headerBudget
	headerBudget = frame.headerSpace;

	local lastHeader = 0;
	for k,v in frame.activeHeaders do
		local header = getglobal(frame:GetName().."ColumnHeader"..k);
		lastHeader = k;

		if ( frame.headerList[v] and headerBudget > 0 ) then
			header:SetText(frame.headerList[v].title);
			header:Show();
			
			-- Set the Width
			if ( frame.headerList[v].width <= headerBudget ) then
				EarthTable_Header_SetWidth(frame.headerList[v].width, header);
			else				
				EarthTable_Header_SetWidth(headerBudget, header);
			end
			
			-- Set the header color
			if ( frame.headerList[v].titleColor ) then
				header:SetTextColor(frame.headerList[v].titleColor.r,frame.headerList[v].titleColor.g,frame.headerList[v].titleColor.b);
			else 
				header:SetTextColor(EARTHTABLE_DEFAULT_HEADER_COLOR.r,EARTHTABLE_DEFAULT_HEADER_COLOR.g,EARTHTABLE_DEFAULT_HEADER_COLOR.b);				
			end

			-- Check if its clickable 
			if ( frame.headerList[v].disabled ) then 
				header:Disable();
			else
				header:Enable();
			end

			local key = frame.headerList[v].key;
			
			for i=1,frame.rowCount do			
				local nth = i + vOffset;
				local cell = getglobal(frame:GetName().."Row"..i.."Cell"..k);

				-- If an index exists, fill the cell
				if ( frame.database[nth] ) then 
					local text = EarthTable_GetInfo(frame.database[nth][key]);
					cell:SetText(text);	

					
					if ( frame.headerList[v].width <= headerBudget ) then
						cell:SetWidth(frame.headerList[v].width);
					else
						cell:SetWidth(headerBudget);
					end

					-- Ooh text color!					
					if ( frame.headerList[v].textColor ) then
						cell:SetTextColor(frame.headerList[v].textColor.r,frame.headerList[v].textColor.g,frame.headerList[v].textColor.b);
					else
						cell:SetTextColor(EARTHTABLE_DEFAULT_DATA_COLOR.r,EARTHTABLE_DEFAULT_DATA_COLOR.g,EARTHTABLE_DEFAULT_DATA_COLOR.b);						
					end

					cell:Show();
				else
				end
			end

			-- Empty the header budget
			headerBudget = headerBudget - frame.headerList[v].width;

		end
	end

	-- ScrollFrame update
	FauxScrollFrame_Update(getglobal(frame:GetName().."ListScrollFrameV"), table.getn(frame.database), frame.rowCount, EARTHTABLE_ROW_HEIGHT);
	
	local newmax = table.getn(frame.headerList)-1;
	if ( newmax < 0 ) then newmax = 0; end

	getglobal(frame:GetName().."ListScrollFrameH".."ScrollBar"):SetMinMaxValues(stickCount,newmax);
	getglobal(frame:GetName().."ListScrollFrameH".."ScrollBar"):SetValueStep(1);


end

--[[ Sets the Table's database ]]--
function EarthTable_LoadDatabase(frame,database)
	frame.database = database;
end

--[[ Sets the table's headers ]]--
function EarthTable_LoadHeaders(frame,headers)
	if ( EarthTable_CheckHeaders(headers) ) then
		frame.headerList = headers;
		frame.activeHeaders = {};
	else
		Sea.io.error("Invalid header for ", frame, "! ", this:GetName());		
	end
end

--[[ Validates a Header Table ]]--
function EarthTable_CheckHeaders(headers)
	for k,v in headers do 
		if ( not EarthTable_CheckHeader(v) ) then
			Sea.io.error("Invalid header! ",this:GetName());
			return false;
		end
	end

	return true;
end

--[[ Validates a single header table ]]--
function EarthTable_CheckHeader(header)
	if ( not header.key ) then 
		Sea.io.error("No key specified in header! ",this:GetName());
		return false;
	end

	if ( not header.title ) then
		header.title = header.key;
	end

	if ( not header.width or header.width <= 0 ) then 
		header.width = 50;
	end

	return true;
end

--[[ The Workhorse ]]--
function EarthTable_HandleEvent(frame, id, action, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20 ) 
	Sea.io.dprint(ETABLE_DEBUG, frame,": ",id," ",action);

	local vOffset = FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrameV"));
	local nth = id + vOffset;		
	local update = true;

	if ( action == "CLICK_HEADER" ) then 
		local currentHeader = frame.activeHeaders[id];

		-- Lets see if its already there. 
		local found = false;

		if ( frame.sortingOrder.headerId == currentHeader ) then 
			frame.sortingOrder = { headerId = currentHeader; key = frame.headerList[currentHeader].key; reverse = not frame.sortingOrder.reverse; };
		-- If this sort hasn't been added, then add it
		else
			frame.sortingOrder = { headerId = currentHeader; key = frame.headerList[currentHeader].key; reverse = false; };
		end

		-- Perform the sorting, oh hat!
		table.sort(frame.database, EarthTable_CreateComparator(frame.sortingOrder));
	elseif ( action == "CLICK_ROW" ) then
		local item = EarthTable_GetDatabaseItemByID(frame,id);

		if ( item and item.onClick ) then 
			item.onClick(item);
		end
	elseif ( action == "DOUBLECLICK_ROW" ) then
		local item = EarthTable_GetDatabaseItemByID(frame,id);

		if ( item and item.onDoubleClick ) then 
			item.onDoubleClick(item);
		end
	elseif ( action == "ENTER_ROW" ) then
		local item = EarthTable_GetDatabaseItemByID(frame, id);

		if ( item and item.tooltip ) then 
			EarthTable_SetTooltip(frame, item.tooltip);	
		end
		update = false;
		
	elseif ( action == "ENTER_HEADER" ) then
		local header = EarthTable_GetHeaderByID(frame,id);

		if ( header and header.tooltip ) then 
			EarthTable_SetTooltip(frame, header.tooltip);
		end
		update = false;
	elseif ( action == "LEAVE_HEADER" or action == "LEAVE_ROW" ) then
		EarthTable_HideTooltip(frame);
		update = false;		
	end
	
	-- Update the gui
	if ( update ) then 
		EarthTable_UpdateFrame(frame);
	end
end

--[[
--	GUI Modifiers
--
--]]
function EarthTable_Header_SetWidth(width, frame)
	if ( not frame ) then
		frame = this;
	end
	frame:SetWidth(width);
	getglobal(frame:GetName().."Middle"):SetWidth(width - 9);
end

function EarthTable_Header_Clear(header)
	if ( header ) then 
		header:SetText("");
		header:Hide();
	end
end

function EarthTable_Cell_Clear(cell)
	if ( cell ) then 
		cell:SetText("");
		cell:Hide();
	end
end

function EarthTable_OnHorizontalScroll( call )
	local scrollbar = getglobal(this:GetName().."ScrollBar");
	scrollbar:SetValue(arg1);
	local min, max = scrollbar:GetMinMaxValues();
	this.offset = floor(scrollbar:GetValue() + 0.5);

	call();
end

--[[ Converts a type into a string ]]--
function EarthTable_GetInfo(data)
	if ( type(data) == "string" ) then
		return data;
	elseif ( type(data) == "boolean" ) then 
		if ( data ) then 
			return EARTHTABLE_KEYWORD_BOOL_TRUE;
		else
			return EARTHTABLE_KEYWORD_BOOL_FALSE;
		end
	elseif ( type(data) == "table" ) then 
		return EARTHTABLE_KEYWORD_TABLE;
	elseif ( type(data) == "function" ) then 
		return EARTHTABLE_KEYWORD_FUNCTION;
	elseif ( type(data) == "nil" ) then 
		return EARTHTABLE_KEYWORD_NIL;
	else
		return EARTHTABLE_KEYWORD_UNKNOWN;
	end
end

--[[ Creates a Database Comparator function ]]--
function EarthTable_CreateComparator(order) 
	return function(a,b)
		if ( order.reverse == true ) then 
			if ( a[order.key] > b[order.key] ) then
				return true;
			end
		else
			if ( a[order.key] < b[order.key] ) then
				return true;
			end
		end
		return false;
	end		
end

-- Gets an item by ID
function EarthTable_GetDatabaseItemByID(frame,id)
	local vOffset = FauxScrollFrame_GetOffset(getglobal(frame:GetName().."ListScrollFrameV"));
	local nth = id + vOffset;		
	
	if ( frame.database[nth] ) then
		return frame.database[nth];
	else
		return nil;
	end
end

function EarthTable_GetHeaderByID(frame,id)
	local realid = frame.activeHeaders[id];

	if( realid ) then 
		return frame.headerList[realid];
	else
		return nil;
	end
end

--
--	Sets the location of the Tooltip
--
function EarthTable_SetTooltip(frame, tooltipText) 
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
function EarthTable_HideTooltip(frame)
	if ( frame.tooltip ) then 		
		getglobal(frame.tooltip):Hide();
		getglobal(frame.tooltip):SetOwner(UIParent, "ANCHOR_RIGHT");
	end
end

--[[
--
--	Event Handlers
--
--]]

--[[ Row Actions ]]--
function EarthTable_RowButton_OnLoad()
	--this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp");
	this:RegisterForClicks("LeftButtonDown", "RightButtonDown");

	this.onClick = EarthTable_RowButton_OnClick;
	this.onDoubleClick = EarthTable_RowButton_OnDoubleClick;
	this.onEnter = EarthTable_RowButton_OnEnter;
	this.onLeave = EarthTable_RowButton_OnLeave;
end

function EarthTable_RowButton_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	EarthTable_HandleEvent(this:GetParent(),this:GetID(),"CLICK_ROW");
end
function EarthTable_RowButton_OnDoubleClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	EarthTable_HandleEvent(this:GetParent(),this:GetID(),"DOUBLECLICK_ROW");
end
function EarthTable_RowButton_OnEnter()
	EarthTable_HandleEvent(this:GetParent(),this:GetID(),"ENTER_ROW");
end
function EarthTable_RowButton_OnLeave()
	EarthTable_HandleEvent(this:GetParent(),this:GetID(),"LEAVE_ROW");
end

--[[ Header Actions ]]--
function EarthTable_HeaderButton_OnLoad()
	--this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonDown", "RightButtonUp");
	this:RegisterForClicks("LeftButtonDown", "RightButtonDown");

	EarthTable_Header_SetWidth(52);
	this.onClick = EarthTable_HeaderButton_OnClick;
	this.onEnter = EarthTable_HeaderButton_OnEnter;
	this.onLeave = EarthTable_HeaderButton_OnLeave;
end

	
function EarthTable_HeaderButton_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	EarthTable_HandleEvent(this:GetParent(),this:GetID(),"CLICK_HEADER");
end
function EarthTable_HeaderButton_OnEnter()
	EarthTable_HandleEvent(this:GetParent(),this:GetID(),"ENTER_HEADER");
end
function EarthTable_HeaderButton_OnLeave()
	EarthTable_HandleEvent(this:GetParent(),this:GetID(),"LEAVE_HEADER");
end

--[[ Frame Actions ]]--

function EarthTable_Frame_OnLoad()
	-- Initalizes the frame
	
	this.rowCount = 20;
	-- 
	this.database = {};
	this.headerList = {};
	this.activeHeaders = {};
	this.sortingOrder = {};
	this.headerIndex = 0;
	this.headerSpace = 300;
	this.headerMax = 4;

	-- Use any tooltip you'd like. I use my own
	this.tooltip = "EarthTooltip";
	
	--
	-- Can be "button", "frame", "cursor"
	-- 
	this.tooltipPlacement = "cursor"; 	
	this.tooltipAnchor = "ANCHOR_RIGHT"; -- Can be any valid tooltip anchor
	this.activeTable = {};
	

	getglobal(this:GetName().."ListScrollFrameVScrollBar"):SetMinMaxValues(0,1);
	getglobal(this:GetName().."ListScrollFrameHScrollBar"):SetMinMaxValues(0,1);

end

--[[
--	Demo function
--
--

function dt() 
	local database = {
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
		{name="Roger";class="Rabbit";level="1";group="yes";onClick=function() Sea.io.print("Hiya!")end;tooltip="R!"};
		{name="Sam";  class="Spy";level="32";group="no";onClick=function() Sea.io.print("Yo.")end;tooltip="S!"};
		{name="Alex";class="Host";level="500";group="yes";onClick=function() Sea.io.print("The question is...")end;tooltip="A!!"};
	}
	local headers = {
		{
			title = "Name";
			key = "name";
			width = 100;
			titleColor = {r=1.0;g=1.0;b=0.0};
			sortable = true;
			stick="true";
		};
		{
			title = "Class";
			key = "class";
			width = 120;
			titleColor = {r=1.0;g=1.0;b=1.0};
			sortable = true;
		};
		{
			title = "Level";
			key = "level";
			width = 150;
			titleColor = {r=1.0;g=1.0;b=1.0};
			sortable = true;
		};
		{
			title = "Grouped?";
			key = "group";
			width = 150;
			titleColor = {r=1.0;g=1.0;b=1.0};
			sortable = true;
		};	
		{
			title = "Grouped? 2";
			key = "group";
			width = 300;
			titleColor = {r=1.0;g=1.0;b=1.0};
			sortable = true;
		};	
	}

	EarthTable_LoadDatabase(
		getglobal("EarthTable"),
		database
		);

	EarthTable_LoadHeaders(
		getglobal("EarthTable"),
		headers
		);

	EarthTable_UpdateFrame(
		getglobal("EarthTable")
		);
end

]]
