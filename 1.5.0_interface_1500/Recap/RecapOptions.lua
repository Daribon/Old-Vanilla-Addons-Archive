--[[ RecapOptions.lua ]]

function Recap_InitializeOptions()

	local chatname,chatid,i;

	RecapAutoFadeSlider:SetValue(recap.Opt.AutoFadeTimer.value);
	RecapIdleFightSlider:SetValue(recap.Opt.IdleFightTimer.value);
	RecapMaxRowsSlider:SetValue(recap.Opt.MaxRows.value);
	RecapMaxRankSlider:SetValue(recap.Opt.MaxRank.value);
	RecapOptTab1:LockHighlight();
	RecapOptSubFrame1:Show();
	RecapOpt_StatDropDownText:SetText(recap.Opt.AutoPost.Stat);
	_,_,chatid,chatname = string.find(recap.Opt.AutoPost.Channel,"(%d+)-(%w+)")
	if chatid and chatid~=GetChannelName(chatid) then
		recap.Opt.AutoPost.Channel = "Self";
	end
	RecapOpt_ChannelDropDownText:SetText(recap.Opt.AutoPost.Channel);
	if not UnitIsVisible then
		-- disable MergePets if we're not on 1.5+ client
		RecapOpt_MergePets:SetTextColor(0.5,0.5,0.5,1);
		recap_temp.OptList[44][3] = "This option will only work after the 1.5 client patch (or on test server)."
		recap.Opt.MergePets.value = false;
	end

	-- set check state for all checked options
	for i in recap.Opt do
		if RecapOptFrame and recap.Opt[i].type=="Check" then
			if recap.Opt[i].value==true then
				getglobal("RecapOptCheck_"..i):SetChecked(1);
			else
				getglobal("RecapOptCheck_"..i):SetChecked(0);
			end
		end
	end

end

function RecapOpt_OnMouseDown(arg1)

	if recap_temp.Loaded and arg1=="LeftButton" then
		RecapOptFrame:StartMoving();
	end
end

function RecapOpt_OnMouseUp(arg1)

	if recap_temp.Loaded and arg1=="LeftButton" then
		RecapOptFrame:StopMovingOrSizing();
	end
end

function Recap_AutoFadeSlider_OnValueChanged(arg1)

	if recap_temp.Loaded and arg1 then
		RecapAutoFadeSlider_Text:SetText(arg1.." seconds");
		recap.Opt.AutoFadeTimer.value = arg1;
	end
end

function Recap_IdleFightSlider_OnValueChanged(arg1)

	if recap_temp.Loaded and arg1 then
		RecapIdleFightSlider_Text:SetText(arg1.." seconds");
		recap.Opt.IdleFightTimer.value = arg1;
	end
end

function Recap_MaxRowsSlider_OnValueChanged(arg1)

	if recap_temp.Loaded and arg1 then
		RecapMaxRowsSlider_Text:SetText(arg1.." rows");
		recap.Opt.MaxRows.value = arg1;
		RecapScrollBar_Update();
	end
end

function Recap_MaxRankSlider_OnValueChanged(arg1)

	if recap_temp.Loaded and arg1 then
		RecapMaxRankSlider_Text:SetText("Rank top "..arg1);
		recap.Opt.MaxRank.value = arg1;
	end
end


function RecapOptCheck_OnEnter()

	local id = this:GetID();
	Recap_Tooltip(recap_temp.OptList[id][2],recap_temp.OptList[id][3]);
end

function RecapOptCheck_OnClick()

	local i;
	local id = this:GetID();

	RecapSetEditBox:ClearFocus();

	if id>0 and recap_temp.OptList[id][1] then
		i = getglobal("RecapOptCheck_"..recap_temp.OptList[id][1]):GetChecked();
		if i==1 then
			recap.Opt[recap_temp.OptList[id][1]].value = true;
			PlaySound("igMainMenuOptionCheckBoxOn");
		else
			recap.Opt[recap_temp.OptList[id][1]].value = false;
			PlaySound("igMainMenuOptionCheckBoxOff");
		end
		-- if display list/self checks
		if ((id>=11 and id<=16) or (id>=26 and id<=27) or (id>=30 and id<=41)) and not recap.Opt.Minimized.value then
			Recap_Maximize();
		-- if display minimized checks
		elseif ((id>=17 and id<=22) or id==43) and recap.Opt.Minimized.value then
			Recap_Minimize();
		elseif recap_temp.OptList[id][1]=="UseColor" then
			Recap_SetColors();
			if not recap.Opt.Minimized.value then
				Recap_SetView();
			end
		elseif recap_temp.OptList[id][1]=="ShowTooltips" then
			GameTooltip:Hide();
			Recap_OnTooltip("ShowTooltips");
		elseif recap_temp.OptList[id][1]=="HideFoe" then
			Recap_SetView();
		elseif recap_temp.OptList[id][1]=="HideZero" then
			Recap_SetView();
		elseif recap_temp.OptList[id][1]=="HideYardTrash" then
			Recap_SetView();
		elseif recap_temp.OptList[id][1]=="IdleFight" then
			if recap.Opt.IdleFight.value and recap.Opt.State.value=="Active" then
				recap_temp.IdleTimer = 0;
			else
				recap_temp.IdleTimer = -1;
			end
		elseif recap_temp.OptList[id][1]=="TooltipFollow" then
			Recap_OnTooltip("TooltipFollow");
		elseif recap_temp.OptList[id][1]=="AutoFade" then
			recap_temp.FadeTimer = -1;
		elseif recap_temp.OptList[id][1]=="MergePets" and not UnitIsVisible then
			recap.Opt.MergePets.value = false
			RecapOptCheck_MergePets:SetChecked(0)
		end

	end
end

--[[ Fight Data Set functions ]]

function Recap_InitDataSets()

	if RecapOptTitle then

		RecapFightDataSetHeader_Name:SetTextColor(recap_temp.ColorNone.r,recap_temp.ColorNone.g,recap_temp.ColorNone.b);
		RecapFightDataSetHeader_Date:SetTextColor(recap_temp.ColorNone.r,recap_temp.ColorNone.g,recap_temp.ColorNone.b);
		RecapFightDataSetHeader_Combatants:SetTextColor(recap_temp.ColorNone.r,recap_temp.ColorNone.g,recap_temp.ColorNone.b);

		RecapSaveButton:Disable();
		RecapLoadButton:Disable();
		RecapDeleteButton:Disable();

		Recap_BuildFightSets();

		RecapOptTitle:SetText("Recap v"..Recap_Version.." for "..recap_temp.Player.." of "..recap_temp.Server);
	end
end

function Recap_SetEditValidateButtons()

	local text;

	if recap_temp.Loaded then

		text = RecapSetEditBox:GetText();

		if text and text~="" then
			RecapSaveButton:Enable();
		else
			RecapSaveButton:Disable();
			RecapLoadButton:Disable();
			RecapDeleteButton:Disable();
		end

		recap_temp.FightSetSelected = Recap_SetExists(text);
		RecapFightSetsScrollBar_Update();

		if recap_temp.FightSetSelected~=0 then
			RecapLoadButton:Enable();
			RecapDeleteButton:Enable();
		else
			RecapLoadButton:Disable();
			RecapDeleteButton:Disable();
		end
	end
end

-- populates recap_temp.FightSets with a list of existing fight sets
function Recap_BuildFightSets()

	local i,friendly;

	recap_temp.FightSetsSize = 1;
	for i in recap_set do
		if recap_set[i] and not string.find(i,"^UserData:") then
			if not recap_temp.FightSets[recap_temp.FightSetsSize] then
				recap_temp.FightSets[recap_temp.FightSetsSize] = {};
			end
			recap_temp.FightSets[recap_temp.FightSetsSize].Name = i;
			recap_temp.FightSets[recap_temp.FightSetsSize].Date = recap_set[i].TimeStamp;
			friendly = 0;
			for j in recap_set[i].Combatant do
				if string.find(recap_set[i].Combatant[j],"^true") then
					friendly = friendly + 1;
				end
			end
			recap_temp.FightSets[recap_temp.FightSetsSize].Combatants = recap_set[i].ListSize .. " ("..friendly..")";
			recap_temp.FightSetsSize = recap_temp.FightSetsSize + 1;
		end
	end
	table.sort(recap_temp.FightSets,Recap_SetSort);
end

function RecapFightSetsScrollBar_Update()

	local i, index, item;

  if recap_temp.Loaded then

	FauxScrollFrame_Update(RecapFightSetsScrollBar,recap_temp.FightSetsSize-1,5,5);

	for i=1,5 do
		index = i + FauxScrollFrame_GetOffset(RecapFightSetsScrollBar);
		if index < recap_temp.FightSetsSize then
			getglobal("RecapList"..i.."Back"):Hide();
			getglobal("RecapFightDataList"..i.."_Name"):SetText(recap_temp.FightSets[index].Name);
			getglobal("RecapFightDataList"..i.."_Date"):SetText(recap_temp.FightSets[index].Date);
			getglobal("RecapFightDataList"..i.."_Combatants"):SetText(recap_temp.FightSets[index].Combatants);
			item = getglobal("RecapFightDataList"..i);
			item:Show();
			if recap_temp.FightSetSelected == index then
				item:LockHighlight();
			else
				item:UnlockHighlight();
			end
		else
			item = getglobal("RecapFightDataList"..i);
			item:Hide();
			item:UnlockHighlight();
			getglobal("RecapList"..i.."Back"):Show();
		end
	end

  end
end			

function RecapFightData_OnClick()

	local id = this:GetID();

	RecapSetEditBox:ClearFocus();
   
	index = id + FauxScrollFrame_GetOffset(RecapFightSetsScrollBar);

	if index < recap_temp.FightSetsSize then
		recap_temp.FightSetSelected = index;
		RecapSetEditBox:SetText(recap_temp.FightSets[index].Name);
		RecapSaveButton:Enable();
		RecapLoadButton:Enable();
		RecapDeleteButton:Enable();
		RecapFightSetsScrollBar_Update();
	end
end

function Recap_SetExists(arg1)

	local result = 0;

	for i in recap_temp.FightSets do
		if recap_temp.FightSets[i].Name == arg1 then
			result = i;
		end
	end

	return result;
end

-- fight data set sort (by date)
function Recap_SetSort(e1,e2)
	if e1 and e2 and ( e1.Date > e2.Date ) then
		return true;
	else
		return false;
	end
end

--[[ Options tabs ]]

function RecapOptTab_OnEnter()

    id = this:GetID();

	if id and id>0 then
		Recap_OnTooltip("OptTab"..id);
	end
end

function RecapOptTab_OnClick()

	id = this:GetID();
	PlaySound("GAMEGENERICBUTTONPRESS");

	if id and id>0 then
		RecapOptTab1:UnlockHighlight();
		RecapOptTab2:UnlockHighlight();
		RecapOptTab3:UnlockHighlight();
		RecapOptSubFrame1:Hide();
		RecapOptSubFrame2:Hide();
		RecapOptSubFrame3:Hide();
		getglobal("RecapOptTab"..id):LockHighlight();
		getglobal("RecapOptSubFrame"..id):Show();
	end
end

--[[ drop down lists ]]

function RecapDropMenu_OnClick()

	local id = this:GetID();

	if recap_temp.CurrentDrop==RecapOpt_StatDropDownButton then
		recap.Opt.AutoPost.Stat = getglobal("RecapDropMenu"..id.."_Text"):GetText();
		RecapOpt_StatDropDownText:SetText(recap.Opt.AutoPost.Stat);
	else
		recap.Opt.AutoPost.Channel = getglobal("RecapDropMenu"..id.."_Text"):GetText();
		RecapOpt_ChannelDropDownText:SetText(recap.Opt.AutoPost.Channel);
	end
	Recap_DropMenu:Hide();
	recap_temp.CurrentDrop = nil;

end

function RecapDropMenu_OnEnter()

end

function Recap_ToggleDropDown()

	if Recap_DropMenu:IsVisible() and recap_temp.CurrentDrop==this then
		Recap_DropMenu:Hide();
		recap_temp.CurrentDrop = nil;
	elseif recap_temp.CurrentDrop~=this and this==RecapOpt_StatDropDownButton then
		Recap_ShowStatDrop();
		recap_temp.CurrentDrop = this;
	elseif recap_temp.CurrentDrop~=this then
		Recap_ShowChannelDrop();
		recap_temp.CurrentDrop = this;
	end

end

function Recap_ShowStatDrop()

	Recap_DropMenu:ClearAllPoints();
	Recap_DropMenu:SetPoint("TOPLEFT","RecapOpt_StatDropDown","BOTTOMLEFT",16,8);
	Recap_PopulateDrop(recap_temp.StatDropList);
end

function Recap_ShowChannelDrop()
	local new_list = {};

	Recap_DropMenu:ClearAllPoints();
	Recap_DropMenu:SetPoint("TOPLEFT","RecapOpt_ChannelDropDown","BOTTOMLEFT",16,8);

	for i=1,table.getn(recap_temp.ChannelDropList) do
		table.insert(new_list,recap_temp.ChannelDropList[i]);
	end
	for i=1,10 do
		c,name = GetChannelName(i);
		if name then
			for i=1,table.getn(recap_temp.Local.SkipChannels) do
				if string.find(name,recap_temp.Local.SkipChannels[i]) then
					name = nil;
					i = table.getn(recap_temp.Local.SkipChannels);
				end
			end
		end
		if name then
			table.insert(new_list,c.."-"..name);
		end
	end
	Recap_PopulateDrop(new_list);
end

function Recap_PopulateDrop(arg1)

	local height = 0;

	for i=1,math.min(8,table.getn(arg1)) do
		getglobal("RecapDropMenu"..i.."_Text"):SetText(arg1[i]);
		getglobal("RecapDropMenu"..i):Show();
		height = height + 16;
	end
	for i=table.getn(arg1)+1,8 do
		getglobal("RecapDropMenu"..i):Hide();
	end

	Recap_DropMenu:SetHeight(height+4);
	Recap_DropMenu:Show();
end

function RecapDropMenu_OnUpdate(arg1)

	if not recap_temp.MenuTimer or MouseIsOver(Recap_DropMenu) or 
		(recap_temp.CurrentDrop and MouseIsOver(recap_temp.CurrentDrop)) then
		recap_temp.MenuTimer = 0;
	end

	recap_temp.MenuTimer = recap_temp.MenuTimer + arg1;
	if recap_temp.MenuTimer > .25 then
		recap_temp.MenuTimer = 0;
		Recap_DropMenu:Hide();
		recap_temp.CurrentDrop = nil;
	end
end
