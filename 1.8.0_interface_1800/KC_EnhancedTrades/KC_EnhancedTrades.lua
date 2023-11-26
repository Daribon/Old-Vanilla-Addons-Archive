TRUE = 1;
FALSE = nil;

local DEFAULT_OPTIONS =	{}
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_DISPLAYS] = {}
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_DISPLAYS][KC_ENHANCEDTRADES_TEXT_I_V]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_DISPLAYS][KC_ENHANCEDTRADES_TEXT_I_B]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_DISPLAYS][KC_ENHANCEDTRADES_TEXT_I_V_B]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_DISPLAYS][KC_ENHANCEDTRADES_TEXT_SMART]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_DISPLAYS][KC_ENHANCEDTRADES_TEXT_I_V_B_A] = FALSE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS] = {}
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_I]		 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_I_V]		 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_I_B]		 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_I_V_B]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_I_V_B_A]  = TRUE		
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_OPTIMAL]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_MEDIUM]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_EASY]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS][KC_ENHANCEDTRADES_TEXT_TRIVIAL]	 = TRUE
DEFAULT_OPTIONS[KC_ENHANCEDTRADES_TEXT_FILTERS]["header"]						 = TRUE				
DEFAULT_OPTIONS.installed = TRUE


--[[--------------------------------------------------------------------------
- Class	Definition
-----------------------------------------------------------------------------]]

KC_EnhancedTradesClass = AceAddonClass:new({
    name			= KC_ENHANCEDTRADES_NAME,
    description		= KC_ENHANCEDTRADES_DESCRIPTION,
    version			= "1.1",
    releaseDate		= "10/14/05",
    aceCompatible	= "102", -- Check ACE_COMP_VERSION in	Ace.lua	for current.
    author			= "Kaelten",
    email			= "kaelten@gmail.com",
    website			= "http://www.kaelcycle.org",
    category		= "professions",
    optionsFrame	= "KC_EnhancedTrades_Config",
    defaults		= DEFAULT_OPTIONS;
    db				= AceDbClass:new("KC_EnhancedTradesDB"),
    buyables		= AceDbClass:new("KC_ET_Buyables"),
    dataCache		= AceDbClass:new(),
    cmd				= AceChatCmdClass:new(KC_ENHANCEDTRADES_CHAT_COMMANDS, KC_ENHANCEDTRADES_CHAT_OPTIONS),
});

function KC_EnhancedTradesClass:Initialize()
	self.optPath	 = {self.profilePath};
	self.displayPath = {self.optPath, KC_ENHANCEDTRADES_TEXT_DISPLAYS};
	self.filterPath	 = {self.optPath, KC_ENHANCEDTRADES_TEXT_FILTERS};
	self.lEssence	 = KC_ET_lEssence;
	self.gEssence	 = KC_ET_gEssence;

	self.TRADE	 = 1;
	self.CRAFT	 = 2;

	self:_Install();
	self.buyables:Initialize();

	KC_EnhancedTrades_TSFButton:Hide();
	KC_EnhancedTrades_CFButton:Hide();
end


--[[--------------------------------------------------------------------------
- Addon	Enabling/Disabling
-----------------------------------------------------------------------------]]

function KC_EnhancedTradesClass:Enable()

	self:RegisterEvent("BAG_UPDATE"	 , "BagUpdate")

	self:RegisterEvent("CRAFT_SHOW"		 , "HookCraftFrame");
	self:RegisterEvent("TRADE_SKILL_SHOW", "HookTradeFrame");

--	KC_EnhancedTradesFrame:Enable()
end

function KC_EnhancedTradesClass:Disable()
	KC_EnhancedTrades_TSFButton:Hide();
	KC_EnhancedTrades_CFButton:Hide();

--	KC_EnhancedTradesFrame:Disable()
end

--[[--------------------------------------------------------------------------
- Data Cache Management
-----------------------------------------------------------------------------]]
function KC_EnhancedTradesClass:HookTradeFrame()
	self:Hook("TradeSkillFrame_SetSelection"		, "TSF_SetSelection");
	self:Hook("TradeSkillFrame_Update"				, "TSF_Update", true);
	self:Hook("TradeSkillCollapseAllButton_OnClick"	, "TSF_CAB_OnClick");
	
	self:RegisterEvent("TRADE_SKILL_CLOSE", "TradeClose");
	self:RegisterEvent("TRADE_SKILL_SHOW", "TradeShow");
	
	KC_EnhancedTrades_TSFButton:SetParent("TradeSkillFrame");
	KC_EnhancedTrades_TSFButton:SetPoint("RIGHT", "TradeSkillFrameCloseButton", "LEFT", 6, 0);

	KC_EnhancedTrades_TSFButton:Show();
	self:UnregisterEvent("TRADE_SKILL_SHOW")

	self:TradeShow()
	self:TSF_Update();
end

function KC_EnhancedTradesClass:HookCraftFrame()
	self:Hook("CraftFrame_SetSelection"				, "CF_SetSelection");
	self:Hook("CraftFrame_Update"					, "CF_Update", true);
	self:Hook("CraftCollapseAllButton_OnClick"		, "CF_CAB_OnClick", true);

	self:RegisterEvent("CRAFT_SHOW"	 , "CraftShow");
	self:RegisterEvent("CRAFT_CLOSE" , "CraftClose");

	KC_EnhancedTrades_CFButton:SetParent("CraftFrame");
	KC_EnhancedTrades_CFButton:SetPoint("RIGHT", "CraftFrameCloseButton", "LEFT", 6, 0);

	KC_EnhancedTrades_CFButton:Show();
	self:UnregisterEvent("CRAFT_SHOW")

	self:CraftShow()
	self:CF_Update();
end

function KC_EnhancedTradesClass:BagUpdate()
	self.dataCache:reset();
end

function KC_EnhancedTradesClass:CraftShow()
	self.dataCache:reset();
	if (GetCraftName() == KC_ENHANCEDTRADES_TEXT_BEASTTRAIN)	then
		self:Unhook("CraftFrame_SetSelection");
		self:Unhook("CraftFrame_Update");
		KC_EnhancedTrades_CFButton:Hide()
		CraftFrame_Update();
	end
end

function KC_EnhancedTradesClass:CraftClose()
	self:Hook("CraftFrame_SetSelection", "CF_SetSelection");
	self:Hook("CraftFrame_Update", "CF_Update", true);
	KC_EnhancedTrades_CFButton:Show();
	self._craftName	= nil;
	self:_purgeDataCache("craft")
end

function KC_EnhancedTradesClass:TradeClose()
	self._tradeSkillName = nil;
	self:_purgeDataCache("trade")
end

function KC_EnhancedTradesClass:TradeShow()
	self.dataCache:reset();
end

function KC_EnhancedTradesClass:_purgeDataCache(mode)
	if (mode == "trade" and TradeSkillFrame and not TradeSkillFrame:IsVisible()) then
		self.dataCache:reset();
		if (KC_EnhancedTrades_Config:IsVisible()) then
			KC_EnhancedTrades_Config:Hide();
		end	
	elseif (mode == "craft" and CraftFrame and not CraftFrame:IsVisible()) then
		self.dataCache:reset();
		if (KC_EnhancedTrades_Config:IsVisible()) then
			KC_EnhancedTrades_Config:Hide();
		end
	end
end

--[[--------------------------------------------------------------------------
- Addon	Installation and Data Upgrade Functions
-----------------------------------------------------------------------------]]

function KC_EnhancedTradesClass:_Install()
	if (self.db:get({ace.char.id, "Settings"}, "version")) then
		self.db:reset();
	end
	
	self.db:set(self.optPath, "version", self.version);
end

--[[--------------------------------------------------------------------------
- TradeSkillFrame Management
-----------------------------------------------------------------------------]]

function KC_EnhancedTradesClass:TSF_SetSelection(id)
	-- make	sure that the window is	setup before its messed	with.
	self:CallHook("TradeSkillFrame_SetSelection", id);
	-- keep	default	value and append to it.
	--local	skillName = TradeSkillSkillName:GetText() or "";
	--TradeSkillSkillName:SetText(skillName.." [bob/dole]");
	local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(id);

	if (skillType == "header") then
		self.dataCache:reset();
		self:TSF_SetSelection(TradeSkillFrame.selectedSkill);
	end
	

	local mode = self.TRADE;

	-- do the same thing for each reagent.
	local numReagents = GetTradeSkillNumReagents(id);
	for i=1, numReagents, 1	do
		-- store orginal value.
		local name = getglobal("TradeSkillReagent"..i.."Name");
		local nameText=	name:GetText() or "";
		-- get all the random bits of info togather.
		local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);
		if (not	reagentName) then break; end
		
		local linkText = GetTradeSkillReagentItemLink(id, i);

		local reagentID, bankReagentCount, buyable;
		bankReagentCount = 0;

		if (linkText) then
			reagentID = KC_Items:GetID(linkText);
			bankReagentCount = KC_Items.bank:BankCount(reagentID);

			buyable	= self.buyables:get(reagentID);
		end
		
		-- build bank text
		local bankText = "";
		if (bankReagentCount > 0) then bankText	= " [" .. bankReagentCount .. "]"; end
		if (buyable == 1) then bankText	= bankText .. "	" .. KC_ENHANCEDTRADES_TEXT_BUYABLE; end
		-- set new text	using a	combo of the stored original value and the new value.
		name:SetText(reagentName .. bankText);
	end
end

function KC_EnhancedTradesClass:TSF_CAB_OnClick()
	self.dataCache:reset();
	self:TSF_SetSelection(TradeSkillFrame.selectedSkill);
	self:CallHook("TradeSkillCollapseAllButton_OnClick");
end

function KC_EnhancedTradesClass:TSF_Update()
	local numTradeSkills = GetNumTradeSkills();
	local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame);
	-- If no tradeskills
	if ( numTradeSkills == 0 ) then
		
		TradeSkillSkillName:Hide();
--		TradeSkillSkillLineName:Hide();
		TradeSkillSkillIcon:Hide();
		TradeSkillRequirementLabel:Hide();
		TradeSkillCollapseAllButton:Disable();
		for i=1, MAX_TRADE_SKILL_REAGENTS, 1 do
			getglobal("TradeSkillReagent"..i):Hide();
		end
	else
		TradeSkillSkillName:Show();
--		TradeSkillSkillLineName:Show();
		TradeSkillSkillIcon:Show();
		TradeSkillCollapseAllButton:Enable();
	end
	-- ScrollFrame update
	
	FauxScrollFrame_Update(TradeSkillListScrollFrame, numTradeSkills, TRADE_SKILLS_DISPLAYED, TRADE_SKILL_HEIGHT, nil, nil,	nil, TradeSkillHighlightFrame, 293, 316	);	
	
	TradeSkillHighlightFrame:Hide();
	for i=1, TRADE_SKILLS_DISPLAYED, 1 do


		repeat
			skillIndex = i + skillOffset;
			skillOffset = skillOffset + 1;
			show = self:_getShowState(skillIndex, "trade");
		until ((skillIndex > numTradeSkills) or	show);
		
		skillOffset = skillOffset - 1;

		local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(skillIndex); 
		local skillButton = getglobal("TradeSkillSkill"..i);
		if ( skillIndex	<= numTradeSkills ) then	
			-- Set button widths if	scrollbar is shown or hidden
			if ( TradeSkillListScrollFrame:IsVisible() ) then
				skillButton:SetWidth(293);
			else
				skillButton:SetWidth(323);
			end
			local color = TradeSkillTypeColor[skillType];
			if ( color ) then
				skillButton:SetTextColor(color.r, color.g, color.b);
			end
			
			skillButton:SetID(skillIndex);
			skillButton:Show();
			-- Handle headers
			if ( skillType == "header" ) then
				skillButton:SetText(skillName);
				if ( isExpanded	) then
					skillButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					skillButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
				getglobal("TradeSkillSkill"..i.."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
				getglobal("TradeSkillSkill"..i):UnlockHighlight();
			else
				if ( not skillName ) then return; end
				skillButton:SetNormalTexture("");
				getglobal("TradeSkillSkill"..i.."Highlight"):SetTexture("");

				local availableText = self:_getPossibileString(skillIndex, "trade") or "";
				skillButton:SetText(" "..skillName.." ["..availableText.."]");
				
				-- Place the highlight and lock	the highlight state
				if ( GetTradeSkillSelectionIndex() == skillIndex ) then
					TradeSkillHighlightFrame:SetPoint("TOPLEFT", "TradeSkillSkill"..i, "TOPLEFT", 0, 0);
					TradeSkillHighlightFrame:Show();
					-- Set the max makeable	items for the create all button
					TradeSkillFrame.numAvailable = numAvailable;
					getglobal("TradeSkillSkill"..i):LockHighlight();
				else
					getglobal("TradeSkillSkill"..i):UnlockHighlight();
				end
			end
			
		else
			skillButton:Hide();
		end
	end
	
	-- Set the expand/collapse all button texture
	local numHeaders = 0;
	local notExpanded = 0;
	for i=1, numTradeSkills, 1 do
		local index = i	+ skillOffset;
		local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(index);
		if ( skillName and skillType ==	"header" ) then
			numHeaders = numHeaders	+ 1;
			if ( not isExpanded ) then
				notExpanded = notExpanded + 1;
			end
		end
	end

	-- If all headers are not expanded then	show collapse button, otherwise	show the expand	button
	if ( notExpanded ~= numHeaders ) then
		TradeSkillCollapseAllButton.collapsed =	nil;
		TradeSkillCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	else
		TradeSkillCollapseAllButton.collapsed =	1;
		TradeSkillCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	end
----------------------------------------------------------------------------------------------------------------------------------
	local skillLineName, skillLineRank, skillLineMaxRank = GetTradeSkillLine();
	TradeSkillFrameTitleText:SetText(format(TEXT(TRADE_SKILL_TITLE), skillLineName)	.. self:_getLngdString());

	self:CallHook("TradeSkillFrame_Update");

end

--[[--------------------------------------------------------------------------
- CraftFrame Management
-----------------------------------------------------------------------------]]

function KC_EnhancedTradesClass:CF_CAB_OnClick()
	self.dataCache:reset();
	self:CF_SetSelection(CraftFrame.selectedCraft);
	return self:CallHook("CraftCollapseAllButton_OnClick");
end

function KC_EnhancedTradesClass:CF_SetSelection(id)
	-- make	sure that the window is	setup before its messed	with.
	self:CallHook("CraftFrame_SetSelection", id);
	-- keep	default	value and append to it.
	--local	craftName = CraftSkillName:GetText() or	"";
	--CraftSkillName:SetText(craftName.." [bob/dole]");

	CraftFrame.selectedCraft = id;
	-- do the same thing for each reagent.
	craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(id);
	if (craftType == "header") then
		self.dataCache:reset();
		return;	
	end
	
	local numReagents = GetCraftNumReagents(id);
	for i=1, numReagents, 1	do
		local name = getglobal("CraftReagent"..i.."Name");
		local count = getglobal("CraftReagent"..i.."Count");
		-- get all the random bits of info togather.
		local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(id, i);
		if (not	reagentName) then break; end
		
		local linkText = GetCraftReagentItemLink(id, i);
		
		local reagentID, bankReagentCount, buyable,	gEssence, lEssence, gEssenceCount, lEssenceCount;
		bankReagentCount = 0;
		gEssenceCount =	0;
		lEssenceCount =	0;

		if (linkText) then
			reagentID = KC_Items:GetID(linkText);
			bankReagentCount = KC_Items.bank:BankCount(reagentID);

			buyable	= self.buyables:get(reagentID);
			gEssence = self.gEssence[reagentID];
			lEssence = self.lEssence[reagentID];			

			if (gEssence) then
				gEssenceCount =	KC_Items.bank:BankCount(gEssence) + KC_Items.inventory:InvCount(gEssence);
				gEssenceCount =	gEssenceCount *	3;
			elseif (lEssence) then
				lEssenceCount =	KC_Items.bank:BankCount(lEssence)  +	KC_Items.inventory:InvCount(lEssence);
				lEssenceCount =	math.floor(lEssenceCount / 3);
			end
		end
	
		-- build bank text
		local bankText = "";
		if  (bankReagentCount > 0) then bankText = " [" .. bankReagentCount .. "]";
		elseif (gEssenceCount >	0) then	bankText = " ["	.. bankReagentCount .. "/^" .. gEssenceCount ..	"^]";
		elseif (lEssenceCount >	0) then	bankText = " ["	.. bankReagentCount .. "/^" .. lEssenceCount ..	"^]";	
		end
		
		if (buyable == 1) then bankText	= bankText .. " " .. KC_ENHANCEDTRADES_TEXT_BUYABLE; end
		-- set new text	using a	combo of the stored original value and the new value.
		name:SetText(reagentName .. bankText);
		count:SetText(playerReagentCount.."/"..reagentCount);
		count:Show();
	end
end

function KC_EnhancedTradesClass:CF_Update()

	SetPortraitTexture(CraftFramePortrait, "player");
	local numCrafts	= GetNumCrafts();
	local craftOffset = FauxScrollFrame_GetOffset(CraftListScrollFrame);
	-- Set the action button text
	CraftCreateButton:SetText(getglobal(GetCraftButtonToken()));
	-- Set the craft skill line status bar info
	local name, rank, maxRank = GetCraftDisplaySkillLine();
	if ( name ) then
		CraftFrameTitleText:SetText(name .. self:_getLngdString());
		CraftRankFrame:SetStatusBarColor(0.0, 0.0, 1.0,	0.5);
		CraftRankFrameBackground:SetVertexColor(0.0, 0.0, 0.75,	0.5);
		CraftRankFrame:SetMinMaxValues(0, maxRank);
		CraftRankFrame:SetValue(rank);
		CraftRankFrameSkillRank:SetText(rank.."/"..maxRank);
		CraftRankFrame:Show();
		CraftSkillBorderLeft:Show();
		CraftSkillBorderRight:Show();
	else
		CraftRankFrame:Hide();
		CraftSkillBorderLeft:Hide();
		CraftSkillBorderRight:Hide();
	end
	

	-- Hide	the expand all button if less than 2 crafts learned	
	if ( numCrafts <=1 ) then
		CraftExpandButtonFrame:Hide();
	else
		CraftExpandButtonFrame:Show();
	end
	-- If no Crafts
	if ( numCrafts == 0 ) then
		CraftName:Hide();
		CraftRequirements:Hide();
		CraftIcon:Hide();
		CraftReagentLabel:Hide();
		CraftDescription:Hide();
		for i=1, MAX_CRAFT_REAGENTS, 1 do
			getglobal("CraftReagent"..i):Hide();
		end
		CraftDetailScrollFrameScrollBar:Hide();
		CraftDetailScrollFrameTop:Hide();
		CraftDetailScrollFrameBottom:Hide();
		CraftListScrollFrame:Hide();
		for i=1, CRAFTS_DISPLAYED, 1 do
			getglobal("Craft"..i):Hide();
		end
		CraftHighlightFrame:Hide();
		CraftRequirements:Hide();
		return;
	end
	
	-- If has crafts
	CraftName:Show();
	CraftRequirements:Show();
	CraftIcon:Show();
	CraftDescription:Show();
	CraftCollapseAllButton:Enable();
	
	-- ScrollFrame update
	FauxScrollFrame_Update(CraftListScrollFrame, numCrafts,	CRAFTS_DISPLAYED, CRAFT_SKILL_HEIGHT, nil, nil,	nil, CraftHighlightFrame, 293, 316 );
	
	CraftHighlightFrame:Hide();
	
	local craftIndex, craftName, craftButton, craftButtonSubText, craftButtonCost;
	for i=1, CRAFTS_DISPLAYED, 1 do
		craftIndex = i + craftOffset;
		craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(craftIndex);
		
		repeat	
			craftIndex = i + craftOffset;
			craftOffset = craftOffset + 1;
			show = self:_getShowState(craftIndex, "craft");
			if (craftType == "none") then
				show = true;
			end
			
		until ((craftIndex > numCrafts)	or show);
		
		craftOffset = craftOffset - 1;

		craftName, craftSubSpellName, craftType, numAvailable, isExpanded, trainingPointCost, requiredLevel = GetCraftInfo(craftIndex);
		craftButton = getglobal("Craft"..i);
		craftButtonSubText = getglobal("Craft"..i.."SubText");
		craftButtonCost	= getglobal("Craft"..i.."Cost");
		if ( craftIndex	<= numCrafts ) then	
			-- Set button widths if	scrollbar is shown or hidden
			if ( CraftListScrollFrame:IsVisible() )	then
				craftButton:SetWidth(293);
			else
				craftButton:SetWidth(323);
			end
			local color = CraftTypeColor[craftType];
			local subColor = CraftSubTypeColor[craftType];
			craftButton:SetTextColor(color.r, color.g, color.b);
			craftButton.r =	color.r;
			craftButton.g =	color.g;
			craftButton.b =	color.b;
			craftButtonCost:SetTextColor(color.r, color.g, color.b);
			craftButtonSubText:SetTextColor(color.r, color.g, color.b);
			craftButton:SetID(craftIndex);
			craftButton:Show();
			-- Handle headers
			if ( craftType == "header" ) then
				craftButton:SetText(craftName);
				craftButtonSubText:SetText("");
				if ( isExpanded	) then
					craftButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					craftButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
				getglobal("Craft"..i.."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
				getglobal("Craft"..i):UnlockHighlight();
			else
				craftButton:SetNormalTexture("");
				getglobal("Craft"..i.."Highlight"):SetTexture("");
				
				local availableText = self:_getPossibileString(craftIndex, "craft") or "";

				if (string.sub(craftName, 1, 8)	== "Enchant ") then
					craftName = string.sub(craftName, 9);
				end
				if (craftType == "none") then
					availableText =	"";
				else 
					availableText =	" ["..availableText.."]";
				end
				
				craftButton:SetText(" "..craftName..availableText);

				if ( craftSubSpellName ~= "" ) then
					craftButtonSubText:SetText(format(TEXT(PARENS_TEMPLATE), craftSubSpellName));
				else 
					craftButtonSubText:SetText("");
				end
				if ( trainingPointCost > 0 ) then
					craftButtonCost:SetText(format(TRAINER_LIST_TP,	trainingPointCost));
				else
					craftButtonCost:SetText("");
				end
				craftButtonSubText:SetPoint("LEFT", "Craft"..i.."Text",	"RIGHT", 10, 0);
				-- Place the highlight and lock	the highlight state
				if ( GetCraftSelectionIndex() == craftIndex ) then
					CraftHighlightFrame:SetPoint("TOPLEFT",	"Craft"..i, "TOPLEFT", 0, 0);
					CraftHighlightFrame:Show();
					craftButtonSubText:SetTextColor(1.0, 1.0, 1.0);
					craftButtonCost:SetTextColor(1.0, 1.0, 1.0);
					getglobal("Craft"..i):LockHighlight();
				else
					getglobal("Craft"..i):UnlockHighlight();
				end
			end
			
		else
			craftButton:Hide();
		end
	end
	
	-- If player has training points show them here
	Craft_UpdateTrainingPoints();

	-- Set the expand/collapse all button texture
	local numHeaders = 0;
	local notExpanded = 0;
	for i=1, numCrafts, 1 do
		local index = i	+ craftOffset;
		local craftName, craftSubSpellName, craftType, numAvailable, isExpanded	= GetCraftInfo(index);
		if ( craftName and craftType ==	"header" ) then
			numHeaders = numHeaders	+ 1;
			if ( not isExpanded ) then
				notExpanded = notExpanded + 1;
			end
		end
	end
	-- If all headers are not expanded then	show collapse button, otherwise	show the expand	button
	if ( notExpanded ~= numHeaders ) then
		CraftCollapseAllButton.collapsed = nil;
		CraftCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	else
		CraftCollapseAllButton.collapsed = 1;
		CraftCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	end

	-- If has headers show the expand all button
	if ( numHeaders	> 0 ) then
		-- If has headers then move all	the names to the right
		for i=1, CRAFTS_DISPLAYED, 1 do
			getglobal("Craft"..i.."Text"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 21, 0);
			getglobal("Craft"..i.."HighlightText"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 21, 0);
			getglobal("Craft"..i.."DisabledText"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 21, 0);
		end
		CraftExpandButtonFrame:Show();
	else
		-- If no headers then move all the names to the	left
		for i=1, CRAFTS_DISPLAYED, 1 do
			getglobal("Craft"..i.."Text"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 3, 0);
			getglobal("Craft"..i.."HighlightText"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 3, 0);
			getglobal("Craft"..i.."DisabledText"):SetPoint("TOPLEFT", "Craft"..i, "TOPLEFT", 3, 0);
		end
		CraftExpandButtonFrame:Hide();
	end
----------------------------------------------------------------------------------------------------------------------------------
	self:CallHook("CraftFrame_Update");
	
end


--[[--------------------------------------------------------------------------
- Helper Functions
-----------------------------------------------------------------------------]]

function KC_EnhancedTradesClass:_getLngdString()
	local lngd = " (" .. KC_ENHANCEDTRADES_TEXT_I;

	if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V)) then
		lngd = lngd .. "/" .. KC_ENHANCEDTRADES_TEXT_I_V;
	end
	if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_B)) then
		lngd = lngd .. "/" .. KC_ENHANCEDTRADES_TEXT_I_B;
	end
	if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V_B)) then
		lngd = lngd .. "/" .. KC_ENHANCEDTRADES_TEXT_I_V_B;
	end
	if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V_B_A)) then
		lngd = lngd .. "/" .. KC_ENHANCEDTRADES_TEXT_I_V_B_A;
	end
	
	lngd = lngd .. ")";

	return lngd;
end

function KC_EnhancedTradesClass:_getPossibileString(id,	mode)
	local invMake, vendorInvMake, bankMake,	vendorBankMake,	altMake	= self:_getCreationData(id, mode);
	local possibleString = tostring(invMake) or "";

	if (vendorInvMake == "*" or vendorBankMake == "*") then
		possibleString = possibleString	.. "/*";
	else
		if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V)) then
			possibleString = possibleString	.. "/" .. vendorInvMake;
		end
		if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_B)) then
			possibleString = possibleString	.. "/" .. bankMake;
		end
		if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V_B)) then
			possibleString = possibleString	.. "/" .. vendorBankMake;
		end
		if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V_B_A)) then
			if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_SMART)) then
				if (altMake ~= vendorBankMake) then
					possibleString = possibleString	.. "/" .. altMake;					
				end					
			else
				possibleString = possibleString	.. "/" .. altMake;
			end			
		end
	end
	

	if (invMake	== -1 or vendorInvMake == -1 or	bankMake == -1 or vendorBankMake == -1)	then
		return "~$~";
	elseif (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_SMART)) then
		local same = true;
		local values = {ace.SplitString(tostring(possibleString) or "",	"/")};
		for index = 1, table.getn(values) do
			if (values[1] == values[index] and same) then
				same = true;
			else
				same = false;
			end
		end
		if (same) then
			possibleString = invMake;
		end
		
	end
	
	return possibleString;
end


function KC_EnhancedTradesClass:_getCreationData(id, mode)
	local skillName, skillType, numAvailable, isExpanded;
	if (mode == "trade") then
		ET_GetInfo = GetTradeSkillInfo;
		ET_GetNumReagents = GetTradeSkillNumReagents;
		ET_GetReagentItemLink =	GetTradeSkillReagentItemLink;
		ET_GetReagentInfo = GetTradeSkillReagentInfo;
		skillName, skillType, numAvailable, isExpanded = ET_GetInfo(id);	
	elseif (mode ==	"craft") then
		ET_GetInfo = GetCraftInfo;
		ET_GetNumReagents = GetCraftNumReagents;
		ET_GetReagentItemLink =	GetCraftReagentItemLink;
		ET_GetReagentInfo = GetCraftReagentInfo;
		skillName, _, skillType, numAvailable, isExpanded = ET_GetInfo(id);
		if (skillType == "header") then	return nil,nil,nil,nil;	end
	end
	
	local numReagents = ET_GetNumReagents(id); 

	local invMake =	-1;
	local vendorInvMake = -1;
	local bankMake = -1;
	local vendorBankMake = -1;
	local altMake =	-1;
	local buyables = 0;
	for i=1, numReagents, 1	do
		local linkText = ET_GetReagentItemLink(id, i);
		if (not	linkText) then break; end
		
		local reagentID = KC_Items:GetID(linkText);
		local bankReagentCount = KC_Items.bank:BankCount(reagentID);
		local buyable =	self.buyables:get(reagentID);	
		local reagentName, reagentTexture, reagentCount, playerReagentCount = ET_GetReagentInfo(id, i);
		local totalCount = playerReagentCount +	bankReagentCount;
		local altCount = -1;
		if (self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V_B_A)) then
			altCount = self:_getAltCount(reagentID) + totalCount;			
		end		

		gEssence = self.gEssence[reagentID];
		lEssence = self.lEssence[reagentID];

		if (gEssence) then
			local gEssenceBankCount	= KC_Items.bank:BankCount(gEssence);
			local gEssenceInvCount	= KC_Items.inventory:InvCount (gEssence);
			gEssenceBankCount  = gEssenceBankCount * 3;
			gEssenceInvCount   = gEssenceInvCount  * 3;
			playerReagentCount = playerReagentCount	+ gEssenceInvCount;
			bankReagentCount   = bankReagentCount	+ gEssenceBankCount;
			totalCount	   = totalCount		+ gEssenceBankCount + gEssenceInvCount;
			if (altCount ~=	-1) then
				altCount = altCount + gEssenceBankCount	+ gEssenceInvCount;				
			end

		elseif (lEssence) then
			local lEssenceBankCount	= KC_Items.bank:BankCount(lEssence);
			local lEssenceInvCount	= KC_Items.inventory:InvCount (lEssence);
			lEssenceBankCount  = math.floor(lEssenceBankCount / 3);
			lEssenceInvCount   = math.floor(lEssenceInvCount / 3);
			playerReagentCount = playerReagentCount	+ lEssenceInvCount;
			bankReagentCount   = bankReagentCount	+ lEssenceBankCount;
			totalCount	   = totalCount		+ lEssenceBankCount + lEssenceInvCount;
			if (altCount ~=	-1) then
				altCount = altCount + lEssenceBankCount	+ lEssenceInvCount;
			end
		end
		
		if (buyable == 1) then
			local bankPossible	 = math.floor(totalCount / reagentCount);
			local invPossible	 = math.floor(playerReagentCount / reagentCount);

			if (bankMake ==	-1) then
				bankMake = bankPossible;
			else
				if (bankPossible) then
					bankMake = math.min(bankPossible, bankMake);					
				end
			end

			if (invMake == -1) then
				invMake	= invPossible;
			elseif (invPossible) then
				invMake	= math.min(invPossible,	invMake);
			end
			
			buyables = buyables + 1;
		else
			local vendorBankPossible = math.floor(totalCount / reagentCount);
			local vendorPossible	 = math.floor(playerReagentCount / reagentCount)
			local bankPossible	 = math.floor(totalCount / reagentCount);
			local invPossible	 = math.floor(playerReagentCount / reagentCount);
			local altPossible	 = math.floor(altCount / reagentCount);

			if (invMake == -1) then
				invMake	= invPossible;
			elseif (invPossible) then
				invMake	= math.min(invPossible,	invMake);
			end
			

			if (vendorBankMake == -1) then
				vendorBankMake = vendorBankPossible;
			elseif (vendorBankPossible) then
				vendorBankMake = math.min(vendorBankPossible, vendorBankMake);					
			end
			
			
			if (vendorInvMake == -1) then
				vendorInvMake =	vendorPossible;
			elseif (vendorPossible)	then
				vendorInvMake =	math.min(vendorPossible, vendorInvMake);					
			end

			
			if (bankMake ==	-1) then
				bankMake = bankPossible;
			elseif (bankPossible) then
				bankMake = math.min(bankPossible, bankMake);					
			end
			
			if (altMake == -1) then
				altMake	= altPossible;
			elseif (altPossible) then
				altMake	= math.min(altPossible,	altMake);
			end
			
			
		end
		
	end
	if (buyables ==	numReagents) then
		vendorInvMake =	"*";
		vendorBankMake = "*";
	end
	
	return invMake,	vendorInvMake, bankMake, vendorBankMake, altMake;
end

function KC_EnhancedTradesClass:_getShowState(skillIndex, mode)
	local skillName, skillType, numAvailable, isExpanded;
	if (mode == "trade") then
		skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(skillIndex);
	elseif (mode ==	"craft") then
		skillName, _, skillType, numAvailable, isExpanded = GetCraftInfo(skillIndex);
	else 
		return true;
	end
	
	local showstate	= self.db:get(self.filterPath, skillType);
	local invMake, vendorInvMake, bankMake,	vendorBankMake;

	if (showstate and skillType ~= "header") then
		invMake, vendorInvMake,	bankMake, vendorBankMake, altMake = self:_getCreationData(skillIndex, mode);
		if (invMake == 0) then
			showstate = self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I);		
		end
		if (vendorInvMake == 0)	then
			showstate = self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_V) and showstate;		
		end
		if (bankMake ==	0) then
			showstate = self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_B) and showstate;		
		end
		if (vendorBankMake == 0) then
			showstate = self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_V_B) and showstate;		
		end
		if (altMake == 0) then
			showstate = self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_V_B_A) and showstate;
		end
		
	end

	return showstate;
end

function KC_EnhancedTradesClass:_getDisplayState(option)
	return self.db:get(self.displayPath, option);
end

function KC_EnhancedTradesClass:_toggleDisplayState(option)
	return self.db:toggle(self.displayPath,	option);
end

function KC_EnhancedTradesClass:_getFilterState(option)
	return self.db:get(self.filterPath, option);
end

function KC_EnhancedTradesClass:_toggleFilterState(option)
	return self.db:toggle(self.filterPath, option);
end

function KC_EnhancedTradesClass:_getAltCount(id)

	result = self.dataCache:get({"_getAltCount"}, id);

	if (result) then
		return result;
	end
	

	local chars = KC_Items:GetCharList();
	local number = 0;

	for index in chars do
		if (index ~= ace.char.id) then
			bankCount = KC_Bank and KC_Items.bank:BankCount(id, index) or 0;
			invCount  = KC_Inventory and KC_Items.inventory:InvCount(id, index) or 0;
			number = number	+ bankCount + invCount;				
		end
	end
	
	self.dataCache:set({"_getAltCount"}, id, number);

	return number;
end


--[[--------------------------------------------------------------------------
- Chat Handlers
-----------------------------------------------------------------------------]]
function KC_EnhancedTradesClass:ToggleDisplay(opt)
	opt = strlower(ace.tostr(opt))
	if (opt	== KC_ENHANCEDTRADES_TEXT_I_V	or opt== KC_ENHANCEDTRADES_TEXT_I_B or 
		opt == KC_ENHANCEDTRADES_TEXT_I_V_B or opt == KC_ENHANCEDTRADES_TEXT_I_V_B_A or 
		opt	== KC_ENHANCEDTRADES_TEXT_SMART) then

		local state = self:_toggleDisplayState(opt);
		local result;
		if (state) then
			result = KC_ENHANCEDTRADES_ENABLED_DISABLED[1];
		else
			result = KC_ENHANCEDTRADES_ENABLED_DISABLED[0];
		end
		if (not self._silent) then
			self.cmd:result(format(KC_ENHANCEDTRADES_DISPLAY_RESULT, opt, result));			
		end
	elseif (opt == "") then
		self.cmd:report(KC_ENHANCEDTRADES_DISPLAY_HEADER,{
			{text=KC_ENHANCEDTRADES_TEXT_I_V,		val=self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V)	,	map=KC_ENHANCEDTRADES_ENABLED_DISABLED},
			{text=KC_ENHANCEDTRADES_TEXT_I_B,		val=self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_B)	,	map=KC_ENHANCEDTRADES_ENABLED_DISABLED},
			{text=KC_ENHANCEDTRADES_TEXT_I_V_B,		val=self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V_B)	,	map=KC_ENHANCEDTRADES_ENABLED_DISABLED},
			{text=KC_ENHANCEDTRADES_TEXT_I_V_B_A,	val=self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_I_V_B_A),	map=KC_ENHANCEDTRADES_ENABLED_DISABLED},
			{text=KC_ENHANCEDTRADES_TEXT_SMART,		val=self:_getDisplayState(KC_ENHANCEDTRADES_TEXT_SMART)	,	map=KC_ENHANCEDTRADES_ENABLED_DISABLED},
		})
	else
		return self.cmd:DisplayUsage();
	end

	if (CraftFrame and CraftFrame:IsVisible()) then
		self:CF_Update();
	end

	if (TradeSkillFrame and TradeSkillFrame:IsVisible()) then
		self:TSF_Update();
	end	
end

function KC_EnhancedTradesClass:ToggleFilter(arg)
	if (arg	== KC_ENHANCEDTRADES_TEXT_I_V		or arg== KC_ENHANCEDTRADES_TEXT_I_B or 
		arg == KC_ENHANCEDTRADES_TEXT_I_V_B		or arg == KC_ENHANCEDTRADES_TEXT_I_V_B_A or 
		arg	== KC_ENHANCEDTRADES_TEXT_I			or arg == KC_ENHANCEDTRADES_TEXT_OPTIMAL or 
		arg == KC_ENHANCEDTRADES_TEXT_MEDIUM	or arg ==	KC_ENHANCEDTRADES_TEXT_TRIVIAL or 
		arg == KC_ENHANCEDTRADES_TEXT_EASY)		then

		local state = self:_toggleFilterState(arg);
		local result;
		if (state) then
			result = KC_ENHANCEDTRADES_SHOWING_HIDING[1];
		else
			result = KC_ENHANCEDTRADES_SHOWING_HIDING[0];
		end
		if (not self._silent) then
			self.cmd:result(format(KC_ENHANCEDTRADES_FILTER_RESULT,	arg, result));
		end
	elseif (arg == "") then
		self.cmd:report(KC_ENHANCEDTRADES_FILTER_HEADER,{
			{text=KC_ENHANCEDTRADES_TEXT_I,			val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I),			map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_I_V,		val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_V),		map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_I_B,		val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_B),		map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_I_V_B,		val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_V_B),		map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_I_V_B_A,	val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_I_V_B_A),	map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_OPTIMAL,	val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_OPTIMAL),	map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_MEDIUM,	val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_MEDIUM),	map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_EASY,		val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_EASY),		map=KC_ENHANCEDTRADES_SHOWING_HIDING},
			{text=KC_ENHANCEDTRADES_TEXT_TRIVIAL,	val=self:_getFilterState(KC_ENHANCEDTRADES_TEXT_TRIVIAL),	map=KC_ENHANCEDTRADES_SHOWING_HIDING},
		})
	else
		return self.cmd:DisplayUsage();
	end

	if (CraftFrame and CraftFrame:IsVisible()) then
		self:CF_Update();
	end
	
	if (TradeSkillFrame and TradeSkillFrame:IsVisible()) then
		self:TSF_Update();
	end	
end

function KC_EnhancedTradesClass:rundown(pattern)
	if (KC_Rundown) then
		KC_Rundown:rundown(pattern);
	end
end
--[[--------------------------------------------------------------------------
- Create and Register Addon Object
-----------------------------------------------------------------------------]]

KC_EnhancedTrades = KC_EnhancedTradesClass:new();
KC_EnhancedTrades:RegisterForLoad();				