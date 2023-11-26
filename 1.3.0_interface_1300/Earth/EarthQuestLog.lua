--[[
--
--	Earth Quest Log
--
--		An simpler way of showing a custom quest
--
--		by Alexander Brazie
--
--]]

EARTHQUESTLOG_MAX_OBJECTIVES = 30;
EARTHQUESTLOG_MAX_ITEMS = 10;

-- Debug Toggles
EARTHQUESTLOG_DEBUG = true;
EQ_DEBUG = "EARTHQUESTLOG_DEBUG";

--
--[[ Update the new Quest Log Frame ]]--
--
function EarthQuestLog_LoadQuest(questLogName, questInfo)
	local frame = getglobal(questLogName);

	if ( frame ) then 
		frame.questInfo = questInfo;
	end
end

--
--	Retrieves the current quest in the log
--
function EarthQuestLog_GetQuest(questLogName)
	local frame = getglobal(questLogName);

	if ( frame ) then 
		return frame.questInfo;
	end
end

--
--[[ Update the new Quest Log Frame ]]--
--
function EarthQuestLog_Clear(questLogName)
	local frame = getglobal(questLogName);

	if ( frame ) then 
		frame.questInfo = nil;
	end
	EarthQuestLog_Update(questLogName);
end



--
-- Updates the quest log 
-- 

--(This is just a giant cut and paste from the 
-- Blizz version. Ugly, but effective! )

function EarthQuestLog_Update(questLogName)
	local questInfo = getglobal(questLogName).questInfo;

	if ( not questInfo ) then 
		questInfo = {};
	end

	local questTitle = questInfo.title;
	if ( not questTitle ) then
		questTitle = "";
	end
	if ( questInfo.failed ) then
		questTitle = questTitle.." - ("..TEXT(FAILED)..")";
	end
	getglobal(questLogName.."QuestTitle"):SetText(questTitle);

	local questDescription, questObjectives = questInfo.description, questInfo.objective;
	getglobal(questLogName.."ObjectivesText"):SetText(questObjectives);
	
	local questTimer = questInfo.timer;
	if ( questTimer ) then
		getglobal(questLogName).hasTimer = 1;
		getglobal(questLogName).timePassed = 0;
		getglobal(questLogName.."TimerText"):Show();
		getglobal(questLogName.."TimerText"):SetText(TEXT(TIME_REMAINING).." "..SecondsToTime(questTimer));
		getglobal(questLogName.."Objective1"):SetPoint("TOPLEFT", questLogName.."TimerText", "BOTTOMLEFT", 0, -10);
	else
		getglobal(questLogName).hasTimer = nil;
		getglobal(questLogName.."TimerText"):Hide();
		getglobal(questLogName.."Objective1"):SetPoint("TOPLEFT", questLogName.."ObjectivesText", "BOTTOMLEFT", 0, -10);
	end
	
	local numObjectives = 0;
	if ( questInfo.objectives ) then numObjectives = table.getn(questInfo.objectives) end;
	for i=1, numObjectives, 1 do
		local string = getglobal(questLogName.."Objective"..i);
		local text;
		local type;
		local finished;
		text, type, finished = questInfo.objectives[i].text, questInfo.objectives[i].questType, questInfo.objectives[i].finished; 
		if ( not text or strlen(text) == 0 ) then
			text = type;
		end
		if ( finished ) then
			string:SetTextColor(0.2, 0.2, 0.2);
			text = text.." ("..TEXT(COMPLETE)..")";
		else
			string:SetTextColor(0, 0, 0);
		end
		string:SetText(text);
		string:Show();
		QuestFrame_SetAsLastShown(string);
	end

	for i=numObjectives + 1, MAX_OBJECTIVES, 1 do
		getglobal(questLogName.."Objective"..i):Hide();
	end
	
	-- If there's money required then anchor and display it
	if ( questInfo.requiredMoney ) then
		if ( numObjectives > 0 ) then
			getglobal(questLogName.."RequiredMoneyText"):SetPoint("TOPLEFT", questLogName.."Objective"..numObjectives, "BOTTOMLEFT", 0, -4);
		else
			getglobal(questLogName.."RequiredMoneyText"):SetPoint("TOPLEFT", questLogName.."ObjectivesText", "BOTTOMLEFT", 0, -10);
		end
		
		MoneyFrame_Update(questLogName.."RequiredMoneyFrame", questInfo.requiredMoney);
		
		if ( questInfo.requiredMoney > GetMoney() ) then
			-- Not enough money
			getglobal(questLogName.."RequiredMoneyText"):SetTextColor(0, 0, 0);
			SetMoneyFrameColor(questLogName.."RequiredMoneyFrame", 1.0, 0.1, 0.1);
		else
			getglobal(questLogName.."RequiredMoneyText"):SetTextColor(0.2, 0.2, 0.2);
			SetMoneyFrameColor(questLogName.."RequiredMoneyFrame", 1.0, 1.0, 1.0);
		end
		getglobal(questLogName.."RequiredMoneyText"):Show();
		getglobal(questLogName.."RequiredMoneyFrame"):Show();
	else
		getglobal(questLogName.."RequiredMoneyText"):Hide();
		getglobal(questLogName.."RequiredMoneyFrame"):Hide();
	end

	if ( questInfo.requiredMoney ) then
		getglobal(questLogName.."DescriptionTitle"):SetPoint("TOPLEFT", questLogName.."RequiredMoneyText", "BOTTOMLEFT", 0, -10);
	elseif ( numObjectives > 0 ) then
		getglobal(questLogName.."DescriptionTitle"):SetPoint("TOPLEFT", questLogName.."Objective"..numObjectives, "BOTTOMLEFT", 0, -10);
	else
		if ( questTimer ) then
			getglobal(questLogName.."DescriptionTitle"):SetPoint("TOPLEFT", questLogName.."TimerText", "BOTTOMLEFT", 0, -10);
		else
			getglobal(questLogName.."DescriptionTitle"):SetPoint("TOPLEFT", questLogName.."ObjectivesText", "BOTTOMLEFT", 0, -10);
		end
	end
	if ( questDescription ) then
		getglobal(questLogName.."QuestDescription"):SetText(questDescription);
		QuestFrame_SetAsLastShown(getglobal(questLogName.."QuestDescription"));
	else 
		getglobal(questLogName.."QuestDescription"):SetText("");
	end
	local numRewards = 0; 
	if ( questInfo.rewards ) then numRewards = table.getn(questInfo.rewards); end
	local numChoices = 0;
	if ( questInfo.choices ) then numChoices = table.getn(questInfo.choices); end
	local money;

	if ( questInfo.rewardMoney ) then
		money = questInfo.rewardMoney;
	else 
		money = 0;
	end

	if ( (numRewards + numChoices + money) > 0 ) then
		getglobal(questLogName.."RewardTitleText"):Show();
		QuestFrame_SetAsLastShown(getglobal(questLogName.."RewardTitleText"));
	else
		getglobal(questLogName.."RewardTitleText"):Hide();
	end

	EarthQuestLog_QuestItems_Update(questLogName, questInfo);
	getglobal(questLogName.."DetailScrollFrameScrollBar"):SetValue(0);
	getglobal(questLogName.."DetailScrollFrame"):UpdateScrollChildRect();
end

function EarthQuestLog_QuestItems_Update(questLogName, questInfo)
	local numQuestRewards;
	local numQuestChoices;
	local numQuestSpellRewards = 0;
	local money;
	local spacerFrame;

	numQuestRewards = 0; 
	if ( questInfo.rewards ) then numQuestRewards = table.getn(questInfo.rewards); end
	numQuestChoices = 0;
	if ( questInfo.choices ) then numQuestChoices = table.getn(questInfo.choices); end

	if ( questInfo.spellReward ) then
		numQuestSpellRewards = 1;
	end
	money = 0;
	if ( questInfo.rewardMoney ) then money = questInfo.rewardMoney; end

	spacerFrame = QuestLogSpacerFrame;

	local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards;
	local questItemName = questLogName.."Item";
	local material = QuestFrame_GetMaterial();
	local  questItemReceiveText = getglobal(questLogName.."ItemReceiveText")
	if ( totalRewards == 0 and money == 0 ) then
		getglobal(questLogName.."RewardTitleText"):Hide();
	else
		getglobal(questLogName.."RewardTitleText"):Show();
		QuestFrame_SetTitleTextColor(getglobal(questLogName.."RewardTitleText"), material);
		QuestFrame_SetAsLastShown(getglobal(questLogName.."RewardTitleText"), spacerFrame);
	end
	if ( money == 0 ) then
		getglobal(questLogName.."MoneyFrame"):Hide();
	else
		getglobal(questLogName.."MoneyFrame"):Show();
		QuestFrame_SetAsLastShown(getglobal(questLogName.."MoneyFrame"), spacerFrame);
		MoneyFrame_Update(questLogName.."MoneyFrame", money);
	end
	
	for i=totalRewards + 1, MAX_NUM_ITEMS, 1 do
		getglobal(questItemName..i):Hide();
	end
	local questItem, name, texture, quality, isUsable, numItems = 1;
	if ( numQuestChoices > 0 ) then
		getglobal(questLogName.."ItemChooseText"):Show();
		QuestFrame_SetTextColor(getglobal(questLogName.."ItemChooseText"), material);
		QuestFrame_SetAsLastShown(getglobal(questLogName.."ItemChooseText"), spacerFrame);
		for i=1, numQuestChoices, 1 do	
			questItem = getglobal(questItemName..i);
			questItem.info = questInfo.choices[i].info;
			numItems = 1;

			name, texture, numItems, quality, isUsable = questInfo.choices[i].name, questInfo.choices[i].texture,  questInfo.choices[i].numItems,  questInfo.choices[i].quality,  questInfo.choices[i].isUsable;

			questItem:SetID(i)
			questItem:Show();

			-- For the tooltip
			questItem.rewardType = "item";

			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..i.."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.9, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 0.9, 0, 0);
			end
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..(i - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..(i - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questLogName.."ItemChooseText", "BOTTOMLEFT", -3, -5);
			end
			
		end
	else
		getglobal(questLogName.."ItemChooseText"):Hide();
	end
	local rewardsCount = 0;
	if ( numQuestRewards > 0 or money > 0 or numQuestSpellRewards > 0) then
		QuestFrame_SetTextColor(questItemReceiveText, material);
		-- Anchor the reward text differently if there are choosable rewards
		if ( numQuestChoices > 0  ) then
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS));
			local index = numQuestChoices;
			if ( mod(index, 2) == 0 ) then
				index = index - 1;
			end
			questItemReceiveText:SetPoint("TOPLEFT", questItemName..index, "BOTTOMLEFT", 3, -5);
		else 
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS_ONLY));
			questItemReceiveText:SetPoint("TOPLEFT", questLogName.."RewardTitleText", "BOTTOMLEFT", 3, -5);
		end
		questItemReceiveText:Show();
		QuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame);
		-- Setup mandatory rewards
		for i=1, numQuestRewards, 1 do
			questItem = getglobal(questItemName..(i + numQuestChoices));
			questItem.info = questInfo.rewards[i].info;
			numItems = 1;

			name, texture, numItems, quality, isUsable = questInfo.rewards[i].name, questInfo.rewards[i].texture,  questInfo.rewards[i].numItems,  questInfo.rewards[i].quality,  questInfo.rewards[i].isUsable;
			questItem:SetID(i)
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "item";
			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..(i + numQuestChoices).."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.5, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 0, 0);
			end
			
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..((i + numQuestChoices) - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..((i + numQuestChoices) - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questLogName.."ItemReceiveText", "BOTTOMLEFT", -3, -5);
			end
			rewardsCount = rewardsCount + 1;
		end
		-- Setup spell reward
		if ( numQuestSpellRewards > 0 ) then
			texture, name = questInfo.spellReward.texture, questInfo.spellReward.name;
			questItem = getglobal(questItemName..(rewardsCount + numQuestChoices + 1));
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "spell";
			SetItemButtonCount(questItem, 0);
			SetItemButtonTexture(questItem, texture);
			getglobal(questItemName..(rewardsCount + numQuestChoices + 1).."Name"):SetText(name);
			if ( rewardsCount > 0 ) then
				if ( mod(rewardsCount,2) == 0 ) then
					questItem:SetPoint("TOPLEFT", questItemName..((rewardsCount + numQuestChoices) - 1), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..((rewardsCount + numQuestChoices)), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questLogName.."ItemReceiveText", "BOTTOMLEFT", -3, -5);
			end
		end
	else	
		questItemReceiveText:Hide();
	end
end


--[[
--
--	Functions beyond this point are tool function and not meant for general use.
--
--	-Alex
--
--]]

--[[ Validates a Frame ]]--
function EarthQuestLog_CheckFrame(frame)
	if ( frame ) then 
		return true;	
	else
		Sea.io.error("Invalid frame passed to EarthQuestLog_CheckFrame");
		return nil;
	end
end

--[[ Validates a Quest Entry ]]--
function EarthQuestLog_CheckTable(questInfo)
	if ( not questInfo ) then 
		Sea.io.error("QuestInfo sent to EarthQuestLog is nil! Name:", this:GetName() );
		return false;
	end

	if ( type(questInfo) ~= "table" ) then 
		Sea.io.error("QuestInfo sent to EarthQuestLog is not a table! Name:", this:GetName() );
		return false;
	end

	for k,v in questInfo do 
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


--
--	Sets the location of the Tooltip
--
function EarthQuestLog_SetTooltip(frame, tooltipText) 
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
function EarthQuestLog_HideTooltip(frame)
	if ( frame.tooltip ) then 		
		getglobal(frame.tooltip):Hide();
		getglobal(frame.tooltip):SetOwner(UIParent, "ANCHOR_RIGHT");
	end
end

--[[ Frame Event Handlers ]]--
function EarthQuestLog_Frame_OnLoad()
	this.onClick = EarthQuestLog_Frame_OnClick;
	this.onShow = EarthQuestLog_Frame_OnShow;
	this.onEvent = EarthQuestLog_Frame_OnEvent;

	-- Use any tooltip you'd like. I use my own
	this.tooltip = "EarthTooltip";
	
	--
	-- Can be "button", "frame", "cursor"
	-- 
	this.tooltipPlacement = "cursor"; 	
	this.tooltipAnchor = "ANCHOR_RIGHT"; -- Can be any valid tooltip anchor
	this.activeTable = {};

end

function EarthQuestLog_Frame_OnShow()
end

function EarthQuestLog_Frame_OnClick()
end

function EarthQuestLog_Frame_OnEvent()
end

--[[ Item Texture Handlers ]]--
function EarthQuestLog_Item_OnLoad()
	this.onEnter = EarthQuestLog_Item_OnEnter;
	this.onLeave = EarthQuestLog_Item_OnLeave;
	this.onClick = EarthQuestLog_Item_OnClick;
	this:Hide();
end

function EarthQuestLog_Item_OnEnter()
	if ( this:GetAlpha() > 0 ) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		if ( this.rewardType == "item" ) then
			Sea.wow.tooltip.protectTooltipMoney();
			GameTooltip:SetHyperlink(this.info.link);
			Sea.wow.tooltip.unprotectTooltipMoney();
		elseif ( this.rewardType == "spell" ) then
			Sea.wow.tooltip.protectTooltipMoney();
			GameTooltip:SetText(this.info);
			Sea.wow.tooltip.unprotectTooltipMoney();
		end
	end
end

function EarthQuestLog_Item_OnLeave()
	GameTooltip:Hide();
end

function EarthQuestLog_Item_OnClick()
	if ( IsShiftKeyDown() ) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert("|c"..this.info.color.."|H"..this.info.link.."|h"..this.info.linkname.."|h|r");
		end
	end
end

function EarthQuestLog_RewardItem_OnLoad()
	this.onEnter = EarthQuestLog_RewardItem_OnEnter;
	this.onLeave = EarthQuestLog_RewardItem_OnLeave;
	this.onClick = EarthQuestLog_RewardItem_OnClick;
end

function EarthQuestLog_RewardItem_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	if ( this.rewardType == "item" ) then
		Sea.wow.tooltip.protectTooltipMoney();
		GameTooltip:SetHyperlink(this.info.link);
		Sea.wow.tooltip.unprotectTooltipMoney();
	elseif ( this.rewardType == "spell" ) then
		Sea.wow.tooltip.protectTooltipMoney();
		GameTooltip:SetText(this.info);
		Sea.wow.tooltip.unprotectTooltipMoney();
	end
end

function EarthQuestLog_RewardItem_OnLeave()
	GameTooltip:Hide();
end

function EarthQuestLog_RewardItem_OnClick()
	if ( IsShiftKeyDown() ) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert("|c"..this.info.color.."|H"..this.info.link.."|h"..this.info.linkname.."|h|r");
		end
		return;
	end

	if ( this.type == "choice" ) then
		QuestRewardItemHighlight:SetPoint("TOPLEFT", this:GetName(), "TOPLEFT", -8, 7);
		QuestRewardItemHighlight:Show();
		QuestFrameRewardPanel.itemChoice = this:GetID();
	end
end

