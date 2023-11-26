TITAN_DEFENSE_FREQUENCY = 1;

-- Options
TitanDefense_warningDuration = 40;

TitanDefense_showSubzonesByTime = true;
TitanDefense_showZonesByTime = true;
TitanDefense_showSubzonesBySum = true;
TitanDefense_showZonesBySum = true;
TitanDefense_numSubzonesByTime = 5;
TitanDefense_numZonesByTime = 5;
TitanDefense_numSubzonesBySum = 5;
TitanDefense_numZonesBySum = 5;


function TitanPanelDefenseButton_OnLoad()
	this.registry = { 
		id = "Defense",
		menuText = TITAN_DEFENSE_MENU_TEXT, 
		buttonTextFunction = "TitanPanelDefenseButton_GetButtonText", 
		tooltipTitle = TITAN_DEFENSE_TOOLTIP,
		tooltipTextFunction = "TitanPanelDefenseButton_GetTooltipText", 
		frequency = TITAN_DEFENSE_FREQUENCY, 
	};
	
	-- Register with myAddOns
	if(myAddOnsFrame) then
		myAddOnsList.TitanPanelDefense = {
		name = TITAN_DEFENSE_STRINGS_MODNAME,
		description = TITAN_DEFENSE_STRINGS_MODDESC,
		version = DEFENSETRACKER_STRINGS_MODVERSION,
		category = MYADDONS_CATEGORY_BARS,
		frame = TITAN_DEFENSE_STRINGS_BARFRAMENAME
		};
	end

end

function TitanPanelDefenseButton_GetButtonText(id)
	local button, id = TitanUtils_GetButton(id, true);
	
	local att, islocal, atttime = DefenseTracker_getLastAttack();
	
	if (not att) then 
		att = DefenseTracker_GetNumAttText();
		return TitanUtils_GetGreenText(att);
	elseif (atttime + TitanDefense_warningDuration < time()) then
		att = DefenseTracker_GetNumAttText();
		return TitanUtils_GetGreenText(att);
	elseif (islocal) then
		return TitanUtils_GetNormalText(att);
	else
		return TitanUtils_GetRedText(att);
	end
end

function TitanPanelDefenseButton_GetTooltipText()
	if (DefenseTracker_numAttacks == 0) then return DEFENSETRACKER_STRINGS_NOATTACKS; end

	local rawdataset = {
		{"------SubzoneSum-----\n", DefenseTracker_SortedSubzoneSum},
		{"------ZoneSum-----\n", DefenseTracker_SortedZoneSum},
		{"------SubzoneTime-----\n", DefenseTracker_SortedSubzoneTimestamp},
		{"------ZoneTime-----\n", DefenseTracker_SortedZoneTimestamp},
		{"------Unknowns-----\n", DefenseTracker_unknowns},
		{"------Attacks-----\n", DefenseTracker_attacks}
	};
	
	local dataset = {
		{DEFENSETRACKER_STRINGS_SZTIMETITLE, TitanDefense_showSubzonesByTime,
			TitanDefense_numSubzonesByTime, DefenseTracker_SortedSubzoneTimestamp, true},
		{DEFENSETRACKER_STRINGS_ZTIMETITLE, TitanDefense_showZonesByTime,
			TitanDefense_numZonesByTime, DefenseTracker_SortedZoneTimestamp, false},
		{DEFENSETRACKER_STRINGS_SZFRQTITLE, TitanDefense_showSubzonesBySum, 
			TitanDefense_numSubzonesBySum, DefenseTracker_SortedSubzoneSum, true},
		{DEFENSETRACKER_STRINGS_ZFRQTITLE, TitanDefense_showZonesBySum, 
			TitanDefense_numZonesBySum, DefenseTracker_SortedZoneSum, false}
	};

	local returnstring = "";
	
	returnstring = returnstring.. DefenseTracker_GetNumAttText().. "\n";
		
	if (DefenseTracker_DebugOutput) then
		for i,arrayinfo in rawdataset do
			returnstring = returnstring.. arrayinfo[1];
			returnstring = returnstring.. DefenseTracker_GetTooltipRawData(arrayinfo[2]);
			returnstring = returnstring.. "\n";
		end
	end

	for i,arrayinfo in dataset do
		if (arrayinfo[2]) then
			returnstring = returnstring.. "\n".. arrayinfo[1].. "\n";
			returnstring = returnstring.. TitanUtils_GetHighlightText(DefenseTracker_GetTooltipData(arrayinfo[4], arrayinfo[3], arrayinfo[5]));
		end
		returnstring = returnstring.. "\n";
	end
	
	return returnstring;
end
