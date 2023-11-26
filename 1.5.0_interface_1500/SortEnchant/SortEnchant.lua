-------------------------------------------------------------------------------------------------------
--
--	SortEnchant Mod - By Guvante
--
--	v1.08b
--
--  I really really need to get around to commenting this thing properly :P
--
-------------------------------------------------------------------------------------------------------


--Set up data table
function SortEnchant_GetNum()
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origGetNum(); end

	--Reset tables
	SortEnchant_Master.Data = { };
	SortEnchant_Master.Groups = { };

	local Searcher = SortEnchant_Master.Search[SortEnchant_Master.Type];
	local Displayer = SortEnchant_Master.Show[SortEnchant_Master.Type];

	--Build tables for sorting drop downs
	local CheckingTables = {[SortEnchant_Type_C] = { }; [SortEnchant_Armor_C] = { }};
	if SortEnchant_Master.SelectedID[SortEnchant_Type_C] ~= 1 then
		for i=1, SortEnchant_origGetNum() do
			local craftName = SortEnchant_origGetInfo(i);
			local found = nil;
			if string.find(SortEnchant_Master.Search.Type[SortEnchant_Master.SelectedID[SortEnchant_Type_C] - 1], ";") then
				for v in string.gfind(SortEnchant_Master.Search.Type[SortEnchant_Master.SelectedID[SortEnchant_Type_C] - 1], "[^%;]+") do
					if string.find(craftName, v) then
						found = true;
						break;
					end
				end
			end
			if (not found) and string.find(craftName, SortEnchant_Master.Search.Type[SortEnchant_Master.SelectedID[SortEnchant_Type_C] - 1]) then
				found = true;
			end
			CheckingTables[SortEnchant_Type_C][i] = found;
		end
	else
		CheckingTables[SortEnchant_Type_C] = nil;
	end

	if SortEnchant_Master.SelectedID[SortEnchant_Armor_C] ~= 1 then
		for i=1, SortEnchant_origGetNum() do
			local craftName = SortEnchant_origGetInfo(i);
			local found = nil;
			if string.find(SortEnchant_Master.Search.Armor[SortEnchant_Master.SelectedID[SortEnchant_Armor_C] - 1], ";") then
				for v in string.gfind(SortEnchant_Master.Search.Armor[SortEnchant_Master.SelectedID[SortEnchant_Armor_C] - 1], "[^%;]+") do
					if string.find(craftName, v) then
						found = true;
						break;
					end
				end
			end
			if (not found) and string.find(craftName, SortEnchant_Master.Search.Armor[SortEnchant_Master.SelectedID[SortEnchant_Armor_C] - 1]) then
				found = true;
			end
			CheckingTables[SortEnchant_Armor_C][i] = found;
		end
	else
		CheckingTables[SortEnchant_Armor_C] = nil;
	end

	local RawData = { };
	local found;
	--Sort all items into their own tables by Type enchanted
	for i=1, SortEnchant_origGetNum() do
		local craftName, dummy1, craftType = SortEnchant_origGetInfo(i);
		if (craftType == "trivial") and (not SortEnchant_Master.Grey) then
			SortEnchant_Master.Data["hidden" .. (SortEnchant_origGetInfo(i))] = true;
		elseif type(Searcher) == "table" then
			for j=1, Displayer.Total do
				found = nil;
				if string.find(Searcher[j], ";") then
					for v in string.gfind(Searcher[j], "[^%;]+") do
						if string.find(craftName, v) then
							found = true;
							break;
						end
					end
				end
				if (not found) and string.find(craftName, Searcher[j]) then --Don't use excess processor time
					found = true;
				end
				if found then
					local matches;

					if CheckingTables[SortEnchant_Type_C] then
						matches = CheckingTables[SortEnchant_Type_C][i];
					else
						matches = true;
					end

					if CheckingTables[SortEnchant_Armor_C] then
						matches = CheckingTables[SortEnchant_Armor_C][i] and matches;
					end

					if matches then
						--Initialize the table if necessary
						if not RawData[Displayer[j]] then
							RawData[Displayer[j]] = {Total = 0};
						end
						--Increment number of items
						RawData[Displayer[j]].Total = RawData[Displayer[j]].Total + 1;
						--Add the item to the list
						RawData[Displayer[j]][RawData[Displayer[j]].Total] = i;
						break;
					else
						SortEnchant_Master.Data["hidden" .. i] = true; --Always hide what you didn't show
					end
				end
			end
		elseif type(Searcher) == "function" then
			local id = Searcher(i); --Avoid calling it too much
			--Initialize the table if necessary
			if not RawData[Displayer[id]] then
				RawData[Displayer[id]] = {Total = 0};
			end
			--Increment number of items
			RawData[Displayer[id]].Total = RawData[Displayer[id]].Total + 1;
			--Add the item to the list
			RawData[Displayer[id]][RawData[Displayer[id]].Total] = i;
		end
	end

	--Add all data to master table in order
	local total = 0;
	local types = 0;

	for i=1, Displayer.Total do
		if RawData[Displayer[i]] then --Ensure it is initialized
			--Add it to the groups table
			types = types + 1;
			SortEnchant_Master.Groups[types] = Displayer[i];

			--Add the header
			total = total + 1;
			SortEnchant_Master.Data["craftName" .. total] = Displayer[i];
			SortEnchant_Master.Data["craftSubSpellName" .. total] = "";
			SortEnchant_Master.Data["craftType" .. total] = "header";
			SortEnchant_Master.Data["numAvailable" .. total] = 0;
			SortEnchant_Master.Data["trainingPointCost" .. total] = 0;
			SortEnchant_Master.Data["requiredLevel" .. total] = 0;

			if SortEnchant_Master.Collapsed[Displayer[i]] then
				SortEnchant_Master.Data["isExpanded" .. total] = false;
				for j=1, RawData[Displayer[i]].Total do
					SortEnchant_Master.Data["hidden" .. (SortEnchant_origGetInfo(RawData[Displayer[i]][j]))] = true;
				end
			else
				SortEnchant_Master.Data["isExpanded" .. total] = true;
				--Only add items if it is expanded
				for j=1, RawData[Displayer[i]].Total do
					total = total + 1;
					--Kind of hard to read, but best way of doing it
					SortEnchant_Master.Data["craftName" .. total], SortEnchant_Master.Data["craftSubSpellName" .. total],
						SortEnchant_Master.Data["craftType" .. total], SortEnchant_Master.Data["numAvailable" .. total],
						SortEnchant_Master.Data["isExpanded" .. total], SortEnchant_Master.Data["trainingPointCost" .. total],
						SortEnchant_Master.Data["requiredLevel" .. total] = SortEnchant_origGetInfo(RawData[Displayer[i]][j]);
					SortEnchant_Master.Data["original" .. total] = RawData[Displayer[i]][j];
					SortEnchant_Master.Data["hidden" .. (SortEnchant_origGetInfo(RawData[Displayer[i]][j]))] = nil;
					SortEnchant_Master.Data["backward" .. RawData[Displayer[i]][j]] = total;
				end
			end
		end
	end

	SortEnchant_Master.Data.Total = total;
	SortEnchant_Master.Groups.Total = types;
	return total;
end

--Subsitute original data with new data from table
function SortEnchant_GetInfo(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origGetInfo(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	return SortEnchant_Master.Data["craftName" .. id], SortEnchant_Master.Data["craftSubSpellName" .. id], SortEnchant_Master.Data["craftType" .. id],
			SortEnchant_Master.Data["numAvailable" .. id], SortEnchant_Master.Data["isExpanded" .. id], SortEnchant_Master.Data["trainingPointCost" .. id],
			SortEnchant_Master.Data["requiredLevel" .. id];
end


--Expand or Collapse a group, or all groups
function SortEnchant_Expand(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origExpand(id);	end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if id ~= 0 then
		SortEnchant_Master.Collapsed[SortEnchant_Master.Data["craftName" .. id]] = nil;
	else
		for i=1, SortEnchant_Master.Groups.Total do
			SortEnchant_Master.Collapsed[SortEnchant_Master.Groups[i]] = nil;
		end
	end
	if SortEnchant_TrueSelected then
		SortEnchant_GetNum(); --Regenerates list
		if not SortEnchant_Master.Data["hidden" .. SortEnchant_origGetInfo(SortEnchant_TrueSelected)] then
			SortEnchant_SelectCraft(SortEnchant_Master.Data["backward" .. SortEnchant_TrueSelected]);
		end
	else
		local tempNum = SortEnchant_Master.Data["original" .. SortEnchant_GetIndex()];
		if type(tempNum) == "number" then --Avoid problems when nothing is selected
			local tempName = (SortEnchant_origGetInfo(tempNum));
			SortEnchant_GetNum(); --Regenerates list
			if tempName ~= SortEnchant_Master.Data["craftName" .. SortEnchant_GetIndex()] then
				SortEnchant_SelectCraft(SortEnchant_Master.Data["backward" .. tempNum]);
			end
		end
	end
	CraftFrame_Update(); --Causes window to be refreshed
end

function SortEnchant_Collapse(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origTradeCollapse(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if id ~= 0 then
		SortEnchant_Master.Collapsed[SortEnchant_Master.Data["craftName" .. id]] = true;
	else
		for i=1, SortEnchant_Master.Groups.Total do
			SortEnchant_Master.Collapsed[SortEnchant_Master.Groups[i]] = true;
		end
	end
	if not SortEnchant_TrueSelected then --Don't need to worry about selection if the selected one is hidden
		local tempNum = SortEnchant_Master.Data["original" .. SortEnchant_GetIndex()]
		if type(tempNum) == "number" then --Avoid problems when nothing is selected
			local tempName = (SortEnchant_origGetInfo(tempNum));
			SortEnchant_GetNum(); --Regenerates list
			if SortEnchant_Master.Data["hidden" .. tempName] then
				SortEnchant_SelectCraft(nil);
				SortEnchant_TrueSelected = tempNum;
			else
				SortEnchant_SelectCraft(SortEnchant_Master.Data["backward" .. tempNum]);
			end
		end
	end
	CraftFrame_Update(); --Causes window to be refreshed
end


--Overlay these functions due to having a larger barrier for a range
function SortEnchant_SelectCraft(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origSelectCraft(id); end
	SortEnchant_Selected = id;
	SortEnchant_TrueSelected = nil;
	return id;
end

function SortEnchant_GetIndex()
	if (not SortEnchant_Master.Enabled) or (not SortEnchant_Selected) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origGetIndex(); end
	return SortEnchant_Selected;
end

--This catches the on event function to hide the drop downs outside of Enchanting
function SortEnchant_CFOnEvent()
	if ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) and (SortEnchant_Master.Enabled) then
		SortEnchant_ArmorDropDown:Hide(); SortEnchant_TypeDropDown:Hide();
	else
		SortEnchant_ArmorDropDown:Show(); SortEnchant_TypeDropDown:Show();
	end
	SortEnchant_origOnEvent();
end


--Offseting functions
function SortEnchant_DoCraft(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origDoCraft(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origDoCraft(SortEnchant_TrueSelected);
	end
	return SortEnchant_origDoCraft(SortEnchant_Master.Data["original" .. id]);
end

function SortEnchant_ToolItem(obj, id, reagId)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origToolItem(obj, id, reagId); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origToolItem(obj, SortEnchant_TrueSelected, reagId);
	end
	return SortEnchant_origToolItem(obj, SortEnchant_Master.Data["original" .. id], reagId);
end

function SortEnchant_ToolSpell(obj, id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origToolSpell(obj, id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origToolSpell(obj, SortEnchant_TrueSelected);
	end
	return SortEnchant_origToolSpell(obj, SortEnchant_Master.Data["original" .. id]);
end

function SortEnchant_GetSubString(from, id)
	local i = 0;
	for v in string.gfind(from, "[^%;]+") do
		i = i + 1;
		if i == id then
			return v;
		end
	end
	return nil; --Wasn't found
end

--To preserve uniformity, and make it easy to revert
function SortEnchant_NewLinkItem(id)
	if not SortEnchant_Master.ShortenNames then
		return (SortEnchant_origGetInfo(id));
	end

	local ret = SortEnchant_origGetInfo(id);
	local armor;
	local retain;
	local offset;
	local dummy1, dummy2; --I don't care where they are in the string

	dummy1, dummy2, armor, ret = string.find(ret, SortEnchant_SearchString); --Enchant Armor - Type
	armor = string.sub(armor, 0, string.len(armor) - 1);

	--"Default" values
	if string.find(ret, SortEnchant_Minor) then
		val = 1;
		offset = 7;
	elseif string.find(ret, SortEnchant_Lesser) then
		val = 3;
		offset = 8;
	elseif string.find(ret, SortEnchant_Greater) then
		val = 7;
		offset = 9;
	elseif string.find(ret, SortEnchant_Superior) then
		val = 9;
		offset = 10;
	elseif string.find(ret, SortEnchant_Major) then
		val = 20;
		offset = 7;
	elseif string.find(ret, SortEnchant_Advanced) then
		val = 2; --Dummy value for later
		offset = 10;
	else --Normal
		val = 5;
		offset = 0;
	end

	--Modify as necessary
	if string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][9], 3)) then
		if armor == SortEnchant_Master.Search[SortEnchant_Armor_C][7] then
			val = val * 10;
		else
			val = (math.floor(val / 2) + 1) * 10;
		end
		ret = SortEnchant_Armor_Show;
		retain = true;
	elseif string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][6]) then
		val = val * 5;
		if val == 45 then
			val = 50;
		end
	elseif string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][7]) then
		if val == 1 then
			val = 5;
		elseif val == 3 then
			val = 20;
		elseif val == 5 then
			val = 20;
		elseif val == 7 then
			val = 50;
		elseif val == 9 then
			val = 65;
		elseif val == 20 then
			val = 100;
		end
	elseif string.find(ret, SortEnchant_Major) then --Don't ask me why the 2H Weapons don't match the pattern, this should be superior
		val = 9;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][14], 1)) or
			string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][14], 2)) or
			string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][14], 4)) then
		if val == 2 then
			val = 5;
		else
			val = 2;
		end
	elseif string.find(ret, SortEnchant_Resist.Fire.Search) then
		val = val + 2; --Lesser = 5, Normal = 7
		ret = SortEnchant_Resist.Fire.Show;
		retain = true;
	elseif string.find(ret, SortEnchant_Resist.Shadow.Search) then
		val = 10; -- Lesser = 10
		ret = SortEnchant_Resist.Shadow.Show;
		retain = true;
	elseif string.find(ret, SortEnchant_Resist.Frost.Search) then
		val = 8; -- Normal = 8
		ret = SortEnchant_Resist.Frost.Show;
		retain = true;
	elseif string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][10]) then
		val = math.floor(val / 2) + 1;
		ret = SortEnchant_Resist_All;
		retain = true;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][9], 4)) then --Don't give these a number, they are odd
		val = 0;
		retain = true;
	elseif string.find(ret, SortEnchant_Minor_Impact) then
		val = 2;
		ret = SortEnchant_Master.Show[SortEnchant_Type_C][11];
		retain = true;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][11], 1)) then
		ret = SortEnchant_Master.Show[SortEnchant_Type_C][11];
		retain = true;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][11], 2)) then
		val = math.floor(val / 2) + 1;
		armor = SortEnchant_1H_Weapon;
		ret = SortEnchant_Master.Show[SortEnchant_Type_C][11];
		retain = true;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][12], 1)) then
		val = val * 2; --Minor = 2, Lesser = 6
	elseif string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][8]) then
		val = math.floor(val / 2) + 1;
		ret = SortEnchant_All_Stats;
		retain = true;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][9], 1)) then
		val = math.floor(val / 2) + 1;
		ret = SortEnchant_Defense_Skill;
		retain = true;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][9], 2)) then
		if val == 5 then
			val = 30;
		elseif val == 7 then
			val = 50;
		else
			val = 70;
		end
		ret = SortEnchant_Armor_Show;
		retain = true;
	elseif string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][1]) or string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][2]) or
			string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][3]) or string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][4]) or
			string.find(ret, SortEnchant_Master.Search[SortEnchant_Type_C][5]) then
		--Do nothing
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][14], 7)) then
		val = val .. "%";
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][14], 6)) then
		val = 0;
		retain = true;
	elseif string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][14], 3)) or
			string.find(ret, SortEnchant_GetSubString(SortEnchant_Master.Search[SortEnchant_Type_C][14], 5)) then
		val = 0;
	else --For now
		val = 0;
		armor = nil;
		retain = true;
	end

	if not retain then
		ret = string.sub(ret, offset);
	end

	if val ~= 0 then
		if armor then
			return "+" .. val .. " " .. ret .. "(" .. armor .. ")";
		else
			return "+" .. val .. " " .. ret;
		end
	else
		if armor then
			return ret .. "(" .. armor .. ")";
		else
			return ret;
		end
	end
end

function SortEnchant_LinkItem(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origLinkItem(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		local temp = SortEnchant_origLinkItem(SortEnchant_TrueSelected);

		if temp then
			return SortEnchant_origLinkItem(SortEnchant_TrueSelected);
		else
			return SortEnchant_NewLinkItem(SortEnchant_TrueSelected);
		end
	end

	--This function does not return anything if it does not have a link, requiring a temporary variable to figure it out
	local temp = SortEnchant_origLinkItem(SortEnchant_Master.Data["original" .. id]);

	if temp then
		return SortEnchant_origLinkItem(SortEnchant_Master.Data["original" .. id]);
	else
		return SortEnchant_NewLinkItem(SortEnchant_Master.Data["original" .. id]);
	end
end

function SortEnchant_LinkReag(id, reagId)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origLinkReag(id, reagId); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origLinkReag(SortEnchant_TrueSelected, reagId);
	end

	return SortEnchant_origLinkReag(SortEnchant_Master.Data["original" .. id], reagId);
end

function SortEnchant_Icon(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origIcon(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origIcon(SortEnchant_TrueSelected);
	end
	return SortEnchant_origIcon(SortEnchant_Master.Data["original" .. id]);
end

function SortEnchant_Desc(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origDesc(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origDesc(SortEnchant_TrueSelected);
	end
	return SortEnchant_origDesc(SortEnchant_Master.Data["original" .. id]);
end

function SortEnchant_NumReag(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origNumReag(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origNumReag(SortEnchant_TrueSelected);
	end
	return SortEnchant_origNumReag(SortEnchant_Master.Data["original" .. id]);
end

function SortEnchant_ReagInfo(id, reagId)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origReagInfo(id, reagId); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origReagInfo(SortEnchant_TrueSelected, reagId);
	end
	return SortEnchant_origReagInfo(SortEnchant_Master.Data["original" .. id], reagId);
end

function SortEnchant_SpellFocus(id)
	if (not SortEnchant_Master.Enabled) or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origSpellFocus(id); end

	if not SortEnchant_Master.Data then
		SortEnchant_GetNum();
	end

	if SortEnchant_TrueSelected then
		return SortEnchant_origSpellFocus(SortEnchant_TrueSelected);
	end
	return SortEnchant_origSpellFocus(SortEnchant_Master.Data["original" .. id]);
end

--Blizzard code is calling the wrong function
function SortEnchant_AllButton()
	if (not SortEnchant_Master.Enabled) or (this:GetName() ~= "CraftCollapseAllButton") or ((GetCraftDisplaySkillLine()) ~= SortEnchant_EncTitle) then return SortEnchant_origAllButton(); end
	return CraftCollapseAllButton_OnClick();
end



--UI Controls
function SortEnchant_TypeDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, SortEnchant_TypeDropDown_Initialize);
	UIDropDownMenu_SetWidth(120);
	UIDropDownMenu_SetSelectedID(SortEnchant_TypeDropDown, 1);
end

function SortEnchant_TypeDropDown_OnShow()
	UIDropDownMenu_Initialize(this, SortEnchant_TypeDropDown_Initialize);
	if SortEnchant_Master.SelectedID[SortEnchant_Type_C] > 0 then
		UIDropDownMenu_SetSelectedID(SortEnchant_TypeDropDown, SortEnchant_Master.SelectedID[SortEnchant_Type_C]);
	else
		UIDropDownMenu_SetSelectedID(SortEnchant_TypeDropDown, 1);
	end
end

function SortEnchant_TypeDropDown_Initialize()
	if SortEnchant_Master then
		if not SortEnchant_Master.Data then
			SortEnchant_GetNum();
		end
	end
	SortEnchant_FilterFrame_LoadTypes();
end

function SortEnchant_FilterFrame_LoadTypes()
	local info = {};
	--if ( SortEnchant_DefaultShow[SortEnchant_Type_C].Total > 1 ) then
		info.text = SortEnchant_DropDown_Type;
		info.func = SortEnchant_TypeDropDownButton_OnClick;
		info.checked = not (SortEnchant_Master and SortEnchant_Master.Selected);
		UIDropDownMenu_AddButton(info);
	--end

	local checked;
	for i=1, SortEnchant_DefaultShow[SortEnchant_Type_C].Total, 1 do
		if SortEnchant_Master and SortEnchant_Master.Selected then
			checked = (SortEnchant_Master.Selected[SortEnchant_Type_C] == SortEnchant_DefaultShow[SortEnchant_Type_C][i]);
		else
			checked = nil;
		end
		if ( checked ) then
			UIDropDownMenu_SetText(SortEnchant_DefaultShow[SortEnchant_Type_C][i], SortEnchant_TypeDropDown);
		end
		info = {};
		info.text = SortEnchant_DefaultShow[SortEnchant_Type_C][i];
		info.func = SortEnchant_TypeDropDownButton_OnClick;
		info.checked = checked;
		if info.text ~= nil then
			UIDropDownMenu_AddButton(info);
		end
	end
end

function SortEnchant_ArmorDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, SortEnchant_ArmorDropDown_Initialize);
	UIDropDownMenu_SetWidth(120);
	UIDropDownMenu_SetSelectedID(SortEnchant_ArmorDropDown, 1);
end

function SortEnchant_ArmorDropDown_OnShow()
	UIDropDownMenu_Initialize(this, SortEnchant_ArmorDropDown_Initialize);
	if SortEnchant_Master.SelectedID[SortEnchant_Armor_C] > 0 then
		UIDropDownMenu_SetSelectedID(SortEnchant_ArmorDropDown, SortEnchant_Master.SelectedID[SortEnchant_Armor_C]);
	else
		UIDropDownMenu_SetSelectedID(SortEnchant_ArmorDropDown, 1);
	end
end

function SortEnchant_ArmorDropDown_Initialize()
	if SortEnchant_Master then
		if not SortEnchant_Master.Data then
			SortEnchant_GetNum();
		end
	end
	SortEnchant_FilterFrame_LoadArmors();
end

function SortEnchant_FilterFrame_LoadArmors()
	local info = {}
	--if ( SortEnchant_DefaultShow[SortEnchant_Armor_C].Total > 1 ) then
		info.text = SortEnchant_DropDown_Armor;
		info.func = SortEnchant_ArmorDropDownButton_OnClick;
		info.checked = not(SortEnchant_Master and SortEnchant_Master.Selected);
		UIDropDownMenu_AddButton(info);
	--end

	local checked;
	for i=1, SortEnchant_DefaultShow[SortEnchant_Armor_C].Total, 1 do
		if SortEnchant_Master and SortEnchant_Master.Selected then
			checked = (SortEnchant_Master.Selected[SortEnchant_Armor_C] == SortEnchant_DefaultShow[SortEnchant_Armor_C][i]);
		else
			checked = nil;
		end
		if ( checked ) then
			UIDropDownMenu_SetText(SortEnchant_DefaultShow[SortEnchant_Armor_C][i], SortEnchant_ArmorDropDown);
		end
		info = {};
		info.text = SortEnchant_DefaultShow[SortEnchant_Armor_C][i];
		info.func = SortEnchant_ArmorDropDownButton_OnClick;
		info.checked = checked;
		if info.text ~= nil then
			UIDropDownMenu_AddButton(info);
		end
	end
end

function SortEnchant_TypeDropDownButton_OnClick()
	UIDropDownMenu_SetSelectedID(SortEnchant_TypeDropDown, this:GetID());
	SortEnchant_Master.Selected[SortEnchant_Type_C] = this:GetText();
	SortEnchant_Master.SelectedID[SortEnchant_Type_C] = this:GetID();
	--Reset the selection
	if SortEnchant_GetNum() > 1 then
		CraftFrame_SetSelection(2);
	end
	if CraftFrame:IsVisible() then CraftFrame_Update(); end
end

function SortEnchant_ArmorDropDownButton_OnClick()
	UIDropDownMenu_SetSelectedID(SortEnchant_ArmorDropDown, this:GetID())
	SortEnchant_Master.Selected[SortEnchant_Armor_C] = this:GetText();
	SortEnchant_Master.SelectedID[SortEnchant_Armor_C] = this:GetID();
	--Reset the selection
	if SortEnchant_GetNum() > 1 then
		CraftFrame_SetSelection(2);
	end
	if CraftFrame:IsVisible() then CraftFrame_Update(); end
end


--Slash command handler
function SortEnchant_Slash(msg)
	local origMsg = msg; --Store Original for case insensitive things
	msg = string.lower(msg);
	if msg == SortEnchant_Toggle then
		SortEnchant_Master.Enabled = not SortEnchant_Master.Enabled;
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
		if SortEnchant_Master.Enabled then
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_OnMsg .. SortEnchant_Master.Type);
			end
			SortEnchant_ArmorDropDown:Show();
			SortEnchant_TypeDropDown:Show();
			if Cosmos_UpdateValue then
				Cosmos_UpdateValue("COS_SORTENCHANT_ENABLE", CSM_CHECKONOFF, 1);
			end
		else
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_OffMsg);
			end
			SortEnchant_ArmorDropDown:Hide();
			SortEnchant_TypeDropDown:Hide();
			if Cosmos_UpdateValue then
				Cosmos_UpdateValue("COS_SORTENCHANT_ENABLE", CSM_CHECKONOFF, 0);
			end
		end
	elseif msg == SortEnchant_On then
		SortEnchant_Master.Enabled = true;
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_OnMsg .. SortEnchant_Master.Type);
		end
		SortEnchant_ArmorDropDown:Show();
		SortEnchant_TypeDropDown:Show();
		if Cosmos_UpdateValue then
			Cosmos_UpdateValue("COS_SORTENCHANT_ENABLE", CSM_CHECKONOFF, 1);
		end
	elseif msg == SortEnchant_Off then
		SortEnchant_Master.Enabled = false;
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_OffMsg);
		end
		SortEnchant_ArmorDropDown:Hide();
		SortEnchant_TypeDropDown:Hide();
		if Cosmos_UpdateValue then
			Cosmos_UpdateValue("COS_SORTENCHANT_ENABLE", CSM_CHECKONOFF, 0);
		end
	elseif msg == SortEnchant_Grey or msg == SortEnchant_Gray then
		SortEnchant_Master.Grey = not SortEnchant_Master.Grey;
		if SortEnchant_Master.Grey then
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_GreyOnMsg);
			end
			--Reset the selection
			if SortEnchant_GetNum() > 1 then
				CraftFrame_SetSelection(2);
			endectCraft(nil);
			end
			if Cosmos_UpdateValue then
				Cosmos_UpdateValue("COS_SORTENCHANT_GREY", CSM_CHECKONOFF, 1);
			end
		else
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_GreyOffMsg);
			end
			--Reset the selection
			if SortEnchant_GetNum() > 1 then
				CraftFrame_SetSelection(2);
			end
			if Cosmos_UpdateValue then
				Cosmos_UpdateValue("COS_SORTENCHANT_GREY", CSM_CHECKONOFF, 0);
			end
		end
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
	elseif msg == SortEnchant_Armor then
		SortEnchant_Master.Type = SortEnchant_Armor_C;
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_TypeMsg .. SortEnchant_Armor_C);
		end
	elseif msg == SortEnchant_Type then
		SortEnchant_Master.Type = SortEnchant_Type_C;
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_TypeMsg .. SortEnchant_Type_C);
		end
	elseif msg == SortEnchant_Available then
		SortEnchant_Master.Type = SortEnchant_Available_C;
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_TypeMsg .. SortEnchant_Available_C);
		end
	elseif msg == SortEnchant_Reset then
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_ResetConfirmDialog);
		end
	elseif msg == SortEnchant_ResetConfirm then
		SortEnchant_Master = nil;
		SortEnchant_OnEvent("VARIABLES_LOADED");
		if CraftFrame:IsVisible() then CraftFrame_Update(); end
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_ResetMsg);
		end
	elseif msg == SortEnchant_Dump then
		SortEnchant_INeedHelp = {};
		RegisterForSave("SortEnchant_INeedHelp");
		local total = SortEnchant_origGetNum();
		for i=1, total do
			SortEnchant_INeedHelp[i] = (SortEnchant_origGetInfo(i));
		end
	elseif msg == SortEnchant_Shorten then
		SortEnchant_Master.ShortenNames = not SortEnchant_Master.ShortenNames;
		if SortEnchant_Master.ShortenNames then
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage("Shortened naming enabled");
			end
			if Cosmos_UpdateValue then
				Cosmos_UpdateValue("COS_SORTENCHANT_SHORTEN", CSM_CHECKONOFF, 1);
			end
		else
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage("Shortened naming disabled");
			end
			if Cosmos_UpdateValue then
				Cosmos_UpdateValue("COS_SORTENCHANT_SHORTEN", CSM_CHECKONOFF, 0);
			end
		end
	elseif string.find(msg, "^" .. SortEnchant_NewType) then
		SortEnchant_Master.Search[string.sub(origMsg, 9)] = { Total = 0 };
		SortEnchant_Master.Show[string.sub(origMsg, 9)] = { Total = 0 };
	elseif string.find(msg, "^modify") then
		local dummy1, dummy2, type, search, show
		if string.find(string.sub(origMsg, 8), "([^ ]*) %'([^%']*)%' %'([^%']*)%'") then
			dummy1, dummy2, type, search, show = string.find(string.sub(origMsg, 8), "([^ ]*) %'([^%']*)%' %'([^%']*)%'");
		elseif string.find(string.sub(origMsg, 8), "([^ ]*) %'([^%']*)%'") then
			dummy1, dummy2, type, show = string.find(string.sub(origMsg, 8), "([^ ]*) %'([^%']*)%'");
		else
			if DEFAULT_CHAT_FRAME then
				DEFAULT_CHAT_FRAME:AddMessage("Please enter it in the form /SortEnchant <Cat> '<Search>' '<Show>'");
				return;
			end
		end
		local total = SortEnchant_Master.Show[type].Total + 1;
		if search then
			SortEnchant_Master.Search[type][total] = search;
		end
		SortEnchant_Master.Show[type][total] = show;
		SortEnchant_Master.Show[type].Total = total;
	elseif string.find(msg, "^" .. SortEnchant_Type) then
		SortEnchant_Master.Type = string.sub(origMsg, 6);
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_TypeMsg .. SortEnchant_Master.Type);
		end
	elseif msg == SortEnchant_HelpAdvanced then
		if DEFAULT_CHAT_FRAME then
			SortEnchant_DisplayAdvancedHelp();
		end
	else
		if DEFAULT_CHAT_FRAME then
			SortEnchant_DisplayHelp();
		end
	end
end

--Cosmos setting handler
SortEnchant_HandleCosmos = {
	Enable = function(toggle)
		if toggle == 0 then
			SortEnchant_Master.Enabled = false;
		else
			SortEnchant_Master.Enabled = true;
		end
	end;

	Grey = function(toggle)
		if toggle == 0 then
			SortEnchant_Master.Grey = false;
		else
			SortEnchant_Master.Grey = true;
		end
	end;

	Shorten = function(toggle)
		if toggle == 0 then
			SortEnchant_Master.ShortenNames = false;
		else
			SortEnchant_Master.ShortenNames = true;
		end
	end;

	Type = { --toggle is never used in these, but doesn't hurt to leave it
		Armor = function()
			SortEnchant_Master.Type = SortEnchant_Armor_C;
		end;

		Type = function()
			SortEnchant_Master.Type = SortEnchant_Type_C;
		end;

		Availible = function()
			SortEnchant_Master.Type = SortEnchant_Available_C;
		end;
	};
};

function SortEnchant_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		--Data is old, get rid of it, reset selections in those tabs as well
		if SortEnchant_Master then
			SortEnchant_Master.Data = nil;
			SortEnchant_Master.Selected = {
				[SortEnchant_Type_C] = SortEnchant_DropDown_Type;
				[SortEnchant_Armor_C] = SortEnchant_DropDown_Armor
			};
			SortEnchant_Master.SelectedID = {[SortEnchant_Type_C] = 1; [SortEnchant_Armor_C] = 1};
			SortEnchant_Master.Search = SortEnchant_DefaultSearch;
			SortEnchant_Master.Show = SortEnchant_DefaultShow;

			if not SortEnchant_Master.Enabled then
				SortEnchant_ArmorDropDown:Hide();
				SortEnchant_TypeDropDown:Hide();
			end
		else
		--------------------------------------------------------------------------------------------
		--   Begin Definition of SortEnchant
		--------------------------------------------------------------------------------------------
			--Generic table to hold most things
			SortEnchant_Master = {
				--Initialize tables to avoid hiccups, skip data, going to manually ensure it is good
				Collapsed = { };
				Groups = { };

				--Settings
				Type = SortEnchant_Armor_C;
				Enabled = true;
				Grey = true;
				ShortenNames = false;

				--What to show for each group
				Show = SortEnchant_DefaultShow;

				--What to search the name with, for each group
				Search = SortEnchant_DefaultSearch;

				Selected = {
					[SortEnchant_Type_C] = SortEnchant_Type;
					[SortEnchant_Armor_C] = SortEnchant_Armor
				};

				SelectedID = {
					[SortEnchant_Type_C] = 1;
					[SortEnchant_Armor_C] = 1;
				};
			}
		--------------------------------------------------------------------------------------------
		--   End Definition of SortEnchant
		--------------------------------------------------------------------------------------------
		end

		--Set up config screen
		if Cosmos_RegisterConfiguration then
			Cosmos_RegisterConfiguration(
				"COS_SORTENCHANT",
				"SECTION",
				SortEnchant_Cosmos_Section,
				SortEnchant_Cosmos_Section_Desc
				);
			Cosmos_RegisterConfiguration(
				"COS_SORTENCHANT_SEPERATOR",
				"SEPARATOR",
				SortEnchant_Cosmos_Main,
				SortEnchant_Cosmos_Main_Desc
				);
			if SortEnchant_Master.Enable then
				Cosmos_RegisterConfiguration(
					"COS_SORTENCHANT_ENABLE",
					"CHECKBOX",
					SortEnchant_Cosmos_Enable,
					SortEnchant_Cosmos_Enable_Desc,
					SortEnchant_HandleCosmos.Enable,
					1
					);
			else
				Cosmos_RegisterConfiguration(
					"COS_SORTENCHANT_ENABLE",
					"CHECKBOX",
					SortEnchant_Cosmos_Enable,
					SortEnchant_Cosmos_Enable_Desc,
					SortEnchant_HandleCosmos.Enable,
					0
					);
			end

			if SortEnchant_Master.Grey then
				Cosmos_RegisterConfiguration(
					"COS_SORTENCHANT_GREY",
					"CHECKBOX",
					SortEnchant_Cosmos_Grey,
					SortEnchant_Cosmos_Grey_Desc,
					SortEnchant_HandleCosmos.Grey,
					1
					);
			else
				Cosmos_RegisterConfiguration(
					"COS_SORTENCHANT_GREY",
					"CHECKBOX",
					SortEnchant_Cosmos_Grey,
					SortEnchant_Cosmos_Grey_Desc,
					SortEnchant_HandleCosmos.Grey,
					0
					);
			end

			if SortEnchant_Master.ShortenNames then
				Cosmos_RegisterConfiguration(
					"COS_SORTENCHANT_SHORTEN",
					"CHECKBOX",
					SortEnchant_Cosmos_Shorten,
					SortEnchant_Cosmos_Shorten_Desc,
					SortEnchant_HandleCosmos.Shorten,
					1
					);
			else
				Cosmos_RegisterConfiguration(
					"COS_SORTENCHANT_SHORTEN",
					"CHECKBOX",
					SortEnchant_Cosmos_Shorten,
					SortEnchant_Cosmos_Shorten_Desc,
					SortEnchant_HandleCosmos.Shorten,
					0
					);
			end

			Cosmos_RegisterConfiguration(
				"COS_SORTENCHANT_TYPE_SEPERATOR",
				"SEPARATOR",
				SortEnchant_Cosmos_Sort,
				SortEnchant_Cosmos_Sort_Desc
				);
			Cosmos_RegisterConfiguration(
				"COS_SORTENCHANT_TYPE_ARMOR",
				"BUTTON",
				SortEnchant_Armor_C,
				SortEnchant_Cosmos_Type_Armor_Desc,
				SortEnchant_HandleCosmos.Type.Armor,
				0, 0, 0, 0, --Skip these values, useless in a button
				SortEnchant_Cosmos_Type_Name
				);
			Cosmos_RegisterConfiguration(
				"COS_SORTENCHANT_TYPE_TYPE",
				"BUTTON",
				SortEnchant_Type_C,
				SortEnchant_Cosmos_Type_Type_Desc,
				SortEnchant_HandleCosmos.Type.Type,
				0, 0, 0, 0, --Skip these values, useless in a button
				SortEnchant_Cosmos_Type_Name
				);
			Cosmos_RegisterConfiguration(
				"COS_SORTENCHANT_TYPE_AVAILIBLE",
				"BUTTON",
				SortEnchant_Available_C,
				SortEnchant_Cosmos_Type_Available_Desc,
				SortEnchant_HandleCosmos.Type.Availible,
				0, 0, 0, 0, --Skip these values, useless in a button
				SortEnchant_Cosmos_Type_Name
				);
		end
	end
end

function SortEnchant_OnLoad()
	--Events
		this:RegisterEvent("VARIABLES_LOADED");

	--Hook into functions
		--Number of crafts
		SortEnchant_origGetNum = GetNumCrafts;
		GetNumCrafts = SortEnchant_GetNum;

		--Info on craft index
		SortEnchant_origGetInfo = GetCraftInfo;
		GetCraftInfo = SortEnchant_GetInfo;

		--Expand/Collapse header index
		SortEnchant_origExpand = ExpandCraftSkillLine;
		ExpandCraftSkillLine = SortEnchant_Expand;
		SortEnchant_origCollapse = CollapseCraftSkillLine;
		CollapseCraftSkillLine = SortEnchant_Collapse;

		--Collapse/Expand all
		SortEnchant_origAllButton = TradeSkillCollapseAllButton_OnClick;
		TradeSkillCollapseAllButton_OnClick = SortEnchant_AllButton;

		--Indexing
		SortEnchant_origSelectCraft = SelectCraft;
		SelectCraft = SortEnchant_SelectCraft;
		SortEnchant_origGetIndex = GetCraftSelectionIndex;
		GetCraftSelectionIndex = SortEnchant_GetIndex;

		--Crafting
		SortEnchant_origDoCraft = DoCraft;
		DoCraft = SortEnchant_DoCraft;

		--Tooltips
		SortEnchant_origToolItem = GameTooltip.SetCraftItem;
		GameTooltip.SetCraftItem = SortEnchant_ToolItem;
		SortEnchant_origToolSpell = GameTooltip.SetCraftSpell;
		GameTooltip.SetCraftSpell = SortEnchant_ToolSpell;

		--Links
		SortEnchant_origLinkItem = GetCraftItemLink;
		GetCraftItemLink = SortEnchant_LinkItem;
		SortEnchant_origLinkReag = GetCraftReagentItemLink;
		GetCraftReagentItemLink = SortEnchant_LinkReag;

		--During SetSelection
		SortEnchant_origIcon = GetCraftIcon;
		GetCraftIcon = SortEnchant_Icon;
		SortEnchant_origDesc = GetCraftDescription;
		GetCraftDescription = SortEnchant_Desc;
		SortEnchant_origNumReag = GetCraftNumReagents;
		GetCraftNumReagents = SortEnchant_NumReag;
		SortEnchant_origReagInfo = GetCraftReagentInfo;
		GetCraftReagentInfo = SortEnchant_ReagInfo;
		SortEnchant_origSpellFocus = GetCraftSpellFocus;
		GetCraftSpellFocus = SortEnchant_SpellFocus;

		--Because of UI elements
		SortEnchant_origOnEvent = CraftFrame_OnEvent;
		CraftFrame_OnEvent = SortEnchant_CFOnEvent;

	--Done show message
		if ( DEFAULT_CHAT_FRAME ) then
    	   -- DEFAULT_CHAT_FRAME:AddMessage(SortEnchant_LoadMsg);
  		end

  	--Slash commands, use cosmos if it is availible
	if Cosmos_RegisterChatCommand then
		local commands = {"/sortenchant", "/se"};
		local desc = "Sort Enchant command line options, type /SortEnchant help for details";
		local id = "SORTENCHANT";
		local func = SortEnchant_Slash;
		Cosmos_RegisterChatCommand(id, commands, func, desc);
	else
		SLASH_SORTENCHANT1 = "/sortenchant";
		SLASH_SORTENCHANT2 = "/se";
		SlashCmdList["SORTENCHANT"] = SortEnchant_Slash;
	end
end