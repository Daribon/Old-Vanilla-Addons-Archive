--[[***** Nurfed Options *****]]--
--[[***** Nurfed UI Options *****]]--

--Current version number
NURFED_VERSION = "8.01.2005";

--Check for Nurfed_General AddOn
NURFED_GENERAL = 1;

-- Bindings for the menu, locking and reloadui
BINDING_HEADER_NURFEDHEADER = "Nurfed General";
BINDING_NAME_NURFEDOPTIONSMENU = "Toggle Options Window";
BINDING_NAME_NURFEDRELOADUI = "Reload Interface";
BINDING_NAME_NURFEDLOCKALL = "Lock / Unlock the UI"

NURFED_SLIDER_FORMAT = "%.2f ";

-- Register the options frame
UIPanelWindows["Nurfed_OptionsFrame"] = {area = "center", pushable = 1};

-- Track tab initialization
Nurfed_TabInit = 0;

-- Initialize an array to hold our global configuration variables, and one to hold our saved values, and register the later for saving
NURFED_REGISTRATIONS = {};
NURFED_SAVED = {};
RegisterForSave('NURFED_SAVED');

-- Registration variable text
NURFED_ID = "id";
NURFED_TYPE = "type";
NURFED_VALUE = "value";
NURFED_NAME = "name";
NURFED_FUNC = "func";
NURFED_LABEL = "label";
NURFED_TOOLTIP = "tooltip";
NURFED_SLIDMIN = "slidermin";
NURFED_SLIDMAX = "slidermax";
NURFED_SLIDSTEP = "sliderstep";
NURFED_SLIDUNIT = "sliderunit";

function Nurfed_RegisterOption(id, type, value, name, func, label, tooltip, slidermin, slidermax, sliderstep, sliderunit)
	-- Get the current number of registrations and then increment the number for indexing
	local n = getn(NURFED_REGISTRATIONS);
	local index = n + 1;
	-- Set a new registration at the index
	NURFED_REGISTRATIONS[index] = {
		[NURFED_ID] = id,
		[NURFED_TYPE] = type,
		[NURFED_VALUE] = value,
		[NURFED_NAME] = name,
		[NURFED_FUNC] = func,
		[NURFED_LABEL] = label,
		[NURFED_TOOLTIP] = tooltip,
		[NURFED_SLIDMIN] = slidermin,
		[NURFED_SLIDMAX] = slidermax,
		[NURFED_SLIDSTEP] = sliderstep,
		[NURFED_SLIDUNIT] = sliderunit
	}
	-- If a value is defined, add it to our saved values array at 'name'
	if (value ~= nil) then
		NURFED_SAVED[name] = value;
	end
	-- Initialize category tabs, we do this so the Shell add-on doesn't break when particular add-ons aren't present
	if (type == "category") then
		-- If this is the first category we run into, or a category with a lower ID than is set, make this tab show when opening the options window
		if (Nurfed_VisibleTab == nil or Nurfed_VisibleTab > id) then
			Nurfed_VisibleTab = id;
		end
		-- Tab items hard-coded in the XML, which are hidden to start out
		local tabButton = getglobal("Nurfed_Tab"..id.."Button");
		local tabText = getglobal("Nurfed_Tab"..id.."Text");
		-- Make sure the elements are there and show them, or error
		if (tabButton ~= nil and tabText ~= nil) then
			tabButton:Show();
			tabText:Show();
		else
			Nurfed_Error("Invalid category ID, ID="..id);
		end
	end
end

function Nurfed_RetrieveOption(id)
	-- Loop through each registration until we find the supplied ID, and then return it's registration information
	local n = getn(NURFED_REGISTRATIONS);
	for i=1, n do
		if (NURFED_REGISTRATIONS[i] ~= nil) then
			if (NURFED_REGISTRATIONS[i][NURFED_ID] == id) then
				local data = NURFED_REGISTRATIONS[i];
				return data;
			end
		end
	end
	-- Return nil if the ID is not found
	return nil;
end

function Nurfed_OptionsFrameToggle()
	if (Nurfed_OptionsFrame:IsVisible()) then
		HideUIPanel(Nurfed_OptionsFrame);
		PlaySound("igMainMenuOption");
	else
		ShowUIPanel(Nurfed_OptionsFrame);
		PlaySound("igMainMenuQuit");
	end
end

function Nurfed_RetrieveSaved(name)
	-- Simply check to see if there's an array index 'name', and return it's value if so, otherwise return nil
	if (NURFED_SAVED[name] ~= nil) then
		local value = NURFED_SAVED[name];
		return value;
	else
		return nil;
	end
end

function Nurfed_UpdateValue(id, value)
	-- Check the ID, error if it's invalid
	if (Nurfed_RetrieveOption(id) ~= nil) then
		-- Check to be certain this is an ID that has a valid value for modifying, error if not
		if (Nurfed_RetrieveOption(id)[NURFED_VALUE] ~= nil) then
			-- Update our registration table
			Nurfed_RetrieveOption(id)[NURFED_VALUE] = value;
			-- Get the name our value is saved under
			local name = Nurfed_RetrieveOption(id)[NURFED_NAME];
			-- Update our saved values
			NURFED_SAVED[name] = value;
		else
			Nurfed_Error("No value registered at ID "..id);
		end
	else
		Nurfed_Error("Invalid ID request, ID="..id);
	end
end

-- ** TAB/PANEL FUNCTIONS ** --

-- OnShow initializations for option tabs
function Nurfed_OptionsTabOnShow ()
	-- Set the tab text above all so it always shows
	this:SetFrameLevel("100");
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "category") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		-- Cooresponding button
		local button = getglobal("Nurfed_Tab"..id.."Button");
		if (button == nil) then
			Nurfed_Error('Failed to find tab button, id='..id);
		end
		-- And text for it
		local buttonText = getglobal("Nurfed_Tab"..id.."Text");
		if (buttonText == nil) then
			Nurfed_Error('Failed to find tab text, id='..id);
		end
		-- Cooresponding panel
		local panel = getglobal("Nurfed_OptionsPanel"..id);
		if (panel == nil) then
			Nurfed_Error('Failed to find panel frame, id='..id);
		end
		-- If this tab is shown by default, then..
		if (id == Nurfed_VisibleTab) then
			-- Set checked state to true
			button:SetChecked(1);
			-- Show cooresponding panel
			panel:Show();
			-- Set cooresponding button frame level up
			button:SetFrameLevel("5");
			-- Set cooresponding panel frame level below the button
			panel:SetFrameLevel("4");
			-- If tabs haven't been initialized, set it up
			if (Nurfed_TabInit == 0) then
				-- Set this tab to be at the top of the options menu
				button:ClearAllPoints();
				button:SetPoint("TOPRIGHT", "Nurfed_OptionsFrame", "TOPRIGHT", -4, -10);
				buttonText:ClearAllPoints();
				buttonText:SetPoint("LEFT", button:GetName(), "LEFT", 0, 0);
			end
		else
			-- If this is not the default tab, set cooresponding button below the panel level
			button:SetFrameLevel("3");
			-- If tabs haven't been initialized, set it up
			if (Nurfed_TabInit == 0) then
				-- Anchor this tab to the last tab
				local lastId = id-50;
				local lastButton = getglobal("Nurfed_Tab"..lastId.."Button");
				button:ClearAllPoints();
				button:SetPoint("TOP", lastButton:GetName(), "BOTTOM", 0, 0);
				buttonText:ClearAllPoints();
				buttonText:SetPoint("LEFT", button:GetName(), "LEFT", 0, 0);
			end
		end
		local label = Nurfed_RetrieveOption(id)[NURFED_LABEL];
		-- Get this frame's font string object
		local labelString = getglobal(this:GetName().."Text");
		-- Set font string to read out the category string
		labelString:SetText(label);
	end
end

-- Set tab tooltip OnEnter
function Nurfed_OptionsTabOnEnter ()
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "category") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		local description = Nurfed_RetrieveOption(id)[NURFED_TOOLTIP];
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		GameTooltip:SetText(description, 1.0, 1.0, 1.0);
	end
end

-- Set clicked tab and show cooresponding panel
function Nurfed_OptionsTabOnClick ()
	local id = this:GetID();
	-- Cooresponding button
	local button = getglobal("Nurfed_Tab"..id.."Button");
	-- Cooresponding panel
	local panel = getglobal("Nurfed_OptionsPanel"..id);
	-- If this was checked true then...
	if (button:GetChecked()) then
		-- Show cooresponding panel
		panel:Show();
		-- Set this button above panel level
		button:SetFrameLevel("5");
		-- Set panel level, should not be necesary, but do it in case
		panel:SetFrameLevel("4");
		-- Make this the visible tab
		Nurfed_VisibleTab = id;
		-- Play clicking sound!
		PlaySound("igCharacterInfoTab");
	else
		-- If someone tries to uncheck, or click an already selected tab, then deny them
		button:SetChecked(1);
	end
	-- Update all other tabs
	Nurfed_OptionsUpdateTabs();
end

-- Set checked conditions for non-clicked tabs
function Nurfed_OptionsUpdateTabs()
	-- Total number of records in our data table
	local n = getn(NURFED_REGISTRATIONS);
	-- For each record...
	for i=1, n do
		-- If it is a category..
		if (NURFED_REGISTRATIONS[i][NURFED_TYPE] == "category") then
			local id = NURFED_REGISTRATIONS[i][NURFED_ID];
			-- And is not currently shown...
			if (Nurfed_VisibleTab ~= id) then
				-- Button & panel 'id'
				local button = getglobal("Nurfed_Tab"..id.."Button")
				local panel = getglobal("Nurfed_OptionsPanel"..id);
				-- Set checked state to false
				button:SetChecked(0);	
				-- Set button level below current panel level
				button:SetFrameLevel("3");
				-- Set panel level to 0 in case clicks could fall through
				panel:SetFrameLevel("0");
				-- Hide this panel
				panel:Hide();
			end
		end	
	end
end		
	
-- ** HEADER FUNCTIONS ** --

-- Write label text to headers
function Nurfed_OptionsHeaderOnShow()
	this:SetFrameLevel("5");
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "header") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		local label = Nurfed_RetrieveOption(id)[NURFED_LABEL];
		-- Get this frame's font string object
		local labelString = getglobal(this:GetName().."Text");
		-- Set font string to read out the header string
		labelString:SetText(label);
	end
end

-- Set header tooltip OnEnter
function Nurfed_OptionsHeaderOnEnter ()
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "header") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		local description = Nurfed_RetrieveOption(id)[NURFED_TOOLTIP];
		GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
		GameTooltip:SetText(description, 1.0, 1.0, 1.0);
	end
end

-- ** PUSH BUTTON FUNCTIONS ** --

-- Initialize our push buttons according to stored variables and update the button
function Nurfed_OptionsButtonOnShow()
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "button") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		-- Need buttons to float above other objects
		this:SetFrameLevel("10");
		-- String to write on button
		local label = Nurfed_RetrieveOption(id)[NURFED_LABEL];
		-- Get this frame's font string object
		local labelString = getglobal(this:GetName());
		labelString:SetText(label);
	end
end

-- Set button tooltip OnEnter
function Nurfed_OptionsButtonOnEnter ()
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "button") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		local description = Nurfed_RetrieveOption(id)[NURFED_TOOLTIP];
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		GameTooltip:SetText(description, 1.0, 1.0, 1.0);
	end
end

-- Change settings OnClick
function Nurfed_OptionsButtonOnClick()
	-- Simply get the cooresponding function and run it
	local id = this:GetID();
	local func = Nurfed_RetrieveOption(id)[NURFED_FUNC];
	func();
	-- Play sound
	PlaySound("igMainMenuOption");
end

-- ** CHECKBUTTON FUNCTIONS ** --

-- Initialize our check buttons according to stored variables and update the check button
function Nurfed_OptionsCheckButtonOnShow()
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "check") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		local value = Nurfed_RetrieveOption(id)[NURFED_VALUE];
		local label = Nurfed_RetrieveOption(id)[NURFED_LABEL];
		local func = Nurfed_RetrieveOption(id)[NURFED_FUNC];
		-- Get this frame's font string object
		local labelString = getglobal(this:GetName().."Text");
		-- Set font string to read out our description
		labelString:SetText(label);
		if (value == 1) then
			this:SetChecked(1);
		else
			this:SetChecked(0);
		end
		-- If this option has a function, run it initially - use this for disabling
		if (func) then
			func();
		end
	end
end

-- Set check button tooltip OnEnter
function Nurfed_OptionsCheckButtonOnEnter ()
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "check") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		local description = Nurfed_RetrieveOption(id)[NURFED_TOOLTIP];
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		GameTooltip:SetText(description, 1.0, 1.0, 1.0);
	end
end

-- Change settings OnClick
function Nurfed_OptionsCheckButtonOnClick()
	local id = this:GetID();
	-- Value of refering variable, 0/1
	local value = Nurfed_RetrieveOption(id)[NURFED_VALUE];
	-- Update function to use for changes
	local func = Nurfed_RetrieveOption(id)[NURFED_FUNC];
	-- Check for incoming checked status, change our variable accordingly, and then run our function for changes
	if (this:GetChecked()) then
		Nurfed_UpdateValue(id, 1);
		-- Skip executing the function if it isn't defined
		if (func ~= nil) then
			func();
		end
		-- Checking sound
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		Nurfed_UpdateValue(id, 0);
		if (func ~= nil) then
			func();
		end
		-- Checking sound
		PlaySound("igMainMenuOptionCheckBoxOn");
	end
end

-- ** SLIDER FUNCTIONS ** --

-- Initialize slider frames
function Nurfed_OptionsSliderOnShow()
	local id = this:GetID();
	-- Main title text
	local text = getglobal(this:GetName().."Text");
	-- Low end label text, default is "Low"
	local minText = getglobal(this:GetName().."Low");
	-- High end label text, default is "High"
	local maxText = getglobal(this:GetName().."High");
	local valuetext = getglobal(this:GetName().."SliderValue");
	valuetext:SetText(this:GetValue());
	-- Set the minimum and maximum values of our slider
	this:SetMinMaxValues(Nurfed_RetrieveOption(id)[NURFED_SLIDMIN], Nurfed_RetrieveOption(id)[NURFED_SLIDMAX]);
	-- Set the value stepping of our slider
	this:SetValueStep(Nurfed_RetrieveOption(id)[NURFED_SLIDSTEP]);
	-- Set the initial value of our slider
	this:SetValue(Nurfed_RetrieveOption(id)[NURFED_VALUE]);
	-- Set the title text
	text:SetText(Nurfed_RetrieveOption(id)[NURFED_LABEL]);
	-- If we define a suffix for our low and high labels, then substitute the min and max values and add the suffix
	if (Nurfed_RetrieveOption(id)[NURFED_SLIDUNIT] ~= nil) then
		minText:SetText(Nurfed_RetrieveOption(id)[NURFED_SLIDMIN]..Nurfed_RetrieveOption(id)[NURFED_SLIDUNIT]);
		maxText:SetText(Nurfed_RetrieveOption(id)[NURFED_SLIDMAX]..Nurfed_RetrieveOption(id)[NURFED_SLIDUNIT]);
	end
end

-- Set slider tooltip OnEnter
function Nurfed_OptionsSliderOnEnter ()
	local id = this:GetID();
	if (not Nurfed_RetrieveOption(id)) then
		Nurfed_Error('Invalid options frame present, ID='..id..', object='..this:GetName());
	elseif (Nurfed_RetrieveOption(id)[NURFED_TYPE] ~= "slider") then
		Nurfed_Error('Invalid options frame type present, ID='..id..', object='..this:GetName());
	else
		local description = Nurfed_RetrieveOption(id)[NURFED_TOOLTIP];
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		GameTooltip:SetText(description, 1.0, 1.0, 1.0);
	end
end

-- Update our value and run the update function when the value is changed
function Nurfed_OptionsSliderOnValueChanged()
	local id = this:GetID();
	local valuetext = getglobal(this:GetName().."SliderValue");
	-- Get the slider value into our array
	--Nurfed_RetrieveOption(id)[NURFED_VALUE] = this:GetValue();
	Nurfed_UpdateValue(id, this:GetValue());
	-- Get cooresponding function
	local func = Nurfed_RetrieveOption(id)[NURFED_FUNC];
	valuetext:SetText( format(NURFED_SLIDER_FORMAT, this:GetValue()) );
	-- Run the function
	func();
	-- Play sound
	PlaySound("igMainMenuOptionCheckBoxOn");
end
