local selectedItems;
local callbackFunction;

local NUM_CHECKBOXES = 36;

local CheckBoxByItemName = {};


local function ConfigureCheckboxes(showCheckboxes, items)
	CheckBoxByItemName = {};
	local i = 1;

	if (not showCheckboxes)
	then
		ChooseItemsFrameBodyText:Show();
		ChooseItemsFrameCancelButton:Hide();
	else
		ChooseItemsFrameBodyText:Hide();
		ChooseItemsFrameCancelButton:Show();
		for index, name in items do
			if (i > NUM_CHECKBOXES)
			then
				DEBUG_MSG("Too many items for checkboxes in popup (only "..NUM_CHECKBOXES.." allowed)", -1);
				break;
			end

			-- set up forward mappings
			local checkbox = getglobal("ChooseItemsFrameCheckbox"..i)
			CheckBoxByItemName[name] = checkbox;
			checkbox:Show();

			-- set the display text which we also use as a reverse mapping
			local text = getglobal("ChooseItemsFrameCheckbox"..i.."Text");
			text:SetText(name);

			-- move on to next
			i = i + 1;
		end
	end

	-- hide any unused checkboxes
	for j = i, NUM_CHECKBOXES, 1 do
		getglobal("ChooseItemsFrameCheckbox"..j):Hide();
	end
	
--	ChooseItemsFrame:SetSize(192, 80 + 20 * ceil(i / 2));
--	ChooseItemsFrameOkayButton:SetPoint("TOPLEFT", "ChooseItemsFrame", "TOPLEFT", 5, -(40 + 20 * ceil(i / 2)));
end


-- ChooseItemsFrame_Update()
--
-- Matches the checkbox status to the state in a zone AA.
-- If something is missing from the item AA, its corresponding checkbox is to be unchecked.
--
local function ChooseItemsFrame_Update()
	DEBUG_MSG("Refreshing choose item frame.", 3);
	-- update all checkbox states
	for index, checkbox in CheckBoxByItemName do
		local text = getglobal(checkbox:GetName().."Text");
		local checked = true;
		if (selectedItems)
		then
			checked = selectedItems[text:GetText()];
			if (checked)
			then
				DEBUG_MSG("Checking box for "..text:GetText().." box name is "..checkbox:GetName(), 4);
			end
		end
		checkbox:SetChecked(checked);
	end

end


local function GetHashText(hash, firstSeparator, restSeparator, lineLength)
	local separator = firstSeparator;
	local message = "";
	local line = "";
	for item, checked in hash do
		if (checked)
		then
			local newLine = line..separator..item;
			if (strlen(newLine) > lineLength)
			then
				if (strlen(line) == 0)
				then
					message = message..separator..item.."\n";
				else
					message = message..line..separator.."\n";
					line = item;
				end
			else
				line = newLine;
			end
			separator = restSeparator;
		end
	end
	return message..line;
end


local function GetBodyTextFromItemHash(hash)
	return GetHashText(hash, "", ", ", 40);
end


function Autotrade_OpenChooseItemsFrame(items, checkedItemNames, parent, titleText, callback)
	local debugmessage = "OpenChooseItemsFrame; checkedItemNames=";
	if (not checkedItemNames)
	then
		DEBUG_MSG(debugmessage.."nil", 4);
	else
		debugmessage = debugmessage..GetHashText(checkedItemNames, "", "&", 256);
		DEBUG_MSG(debugmessage, 4);
	end

	ConfigureCheckboxes(callback, items)
	selectedItems = Cosmos_CopyTable(checkedItemNames);
	callbackFunction = callback;

--	ChooseItemsFrame:SetPoint("BOTTOMRIGHT", parent:GetName(), "TOPRIGHT", 0, 0);
	ChooseItemsFrame:SetPoint("LEFT", "UIParent", "LEFT", 200, 0);
	ChooseItemsFrame:Show();

	ChooseItemsFrame_Update();

	ChooseItemsFrameHeaderText:SetText(titleText);

	if (callback)
	then
		-- There's a callback so this is read/write
		ChooseItemsFrameBodyText:SetText("");
	else
		-- No callback so this is read-only
		local bodyText = GetBodyTextFromItemHash(selectedItems);
		DEBUG_MSG("Body text is "..bodyText, 4);
		ChooseItemsFrameBodyText:SetText(bodyText);
	end
end


function ChooseItemsFrameCheckbox_OnClick()
	if (not selectedItems)
	then
		selectedItems = {};
	end
	local text = getglobal(this:GetName().."Text");
	selectedItems[text:GetText()] = this:GetChecked();
end


function ChooseItemsFrameOkay_OnClick()
	if ( callbackFunction )
	then
		callbackFunction(selectedItems);
	end

	ChooseItemsFrame:Hide();
end


function ChooseItemsFrameCancel_OnClick()
	ChooseItemsFrame:Hide();
end


function ChooseItemsFrame_OnHide()
	selectedItems = nil;
	callbackFunction = nil;
end
