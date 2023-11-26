-- Class creation
KC_EnhancedTradesFrame = AceAddonClass:new()

KC_Skill_Colors = { };
KC_Skill_Colors["optimal"]	= "|cFFFF8040";
KC_Skill_Colors["medium"]	= "|cFFFFFF00";
KC_Skill_Colors["easy"]		= "|cFF40A040";
KC_Skill_Colors["trivial"]	= "|cFF808080";
KC_Skill_Colors["header"]	= "|cFFFFD100";

function KC_EnhancedTradesFrame:Enable()
	self:RegisterEvent("TRADE_SKILL_SHOW", "TradeOpen");
	self:RegisterEvent("TRADE_SKILL_CLOSE", "TradeClose");

	self.OldTSFrame = TradeSkillFrame

	TradeSkillFrame:UnregisterEvent("TRADE_SKILL_UPDATE");
	TradeSkillFrame:UnregisterEvent("TRADE_SKILL_SHOW");
	TradeSkillFrame:UnregisterEvent("TRADE_SKILL_CLOSE");
	TradeSkillFrame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	TradeSkillFrame:UnregisterEvent("UPDATE_TRADESKILL_RECAST");

	TradeSkillFrame = KC_TradeSkillFrame;
	
	self.TSFrame = KC_TradeSkillFrame;
end

function KC_EnhancedTradesFrame:Disable()
	self:UnregisterAllEvents();
	TradeSkillFrame = self.OldTSFrame;

	TradeSkillFrame:RegisterEvent("TRADE_SKILL_UPDATE");
	TradeSkillFrame:RegisterEvent("TRADE_SKILL_SHOW");
	TradeSkillFrame:RegisterEvent("TRADE_SKILL_CLOSE");
	TradeSkillFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	TradeSkillFrame:RegisterEvent("UPDATE_TRADESKILL_RECAST");
end


function KC_EnhancedTradesFrame:TradeOpen()
	self.Queue			= {};
    self.ShrunkHeaders	= {};
	self.Crafting		= false;
	self.selectedSkill  = 0;

	self:BuildSkillList();
	HideUIPanel(self.OldTSFrame);
	self.TSFrame:Show();
	self:_updateSkillList();

	self:RegisterEvent("CHAT_MSG_SPELL_TRADESKILLS", "CraftChat");
	self:RegisterEvent("SPELLCAST_INTERRUPTED", "CraftInterupt");
	self:RegisterEvent("SPELLCAST_FAILED", "CraftFail");
	self:RegisterEvent("SPELLCAST_START", "CraftStart");
	self:RegisterEvent("TRADE_SKILL_UPDATE", "BuildSkillList");

end

function KC_EnhancedTradesFrame:TradeClose()
	self:UnregisterEvent("CHAT_MSG_SPELL_TRADESKILLS");
	self:UnregisterEvent("SPELLCAST_INTERRUPTED");
	self:UnregisterEvent("SPELLCAST_FAILED");
	self:UnregisterEvent("SPELLCAST_START");
	self:UnregisterEvent("TRADE_SKILL_UPDATE");

	self.TSFrame:Hide();
end

function KC_EnhancedTradesFrame:BuildSkillList()
	local numSkills = GetNumTradeSkills();
	self.SkillList = {};

	for i = 0, numSkills do
		local skillName, skillType = GetTradeSkillInfo(i); 
		if (skillType == "header") then
			self.header = i;
		end
		self.SkillList[i] = { name = skillName, type = skillType, header = self.header};

	end
end

function KC_EnhancedTradesFrame:_updateSkillList()
	skillNum		=	self.SkillList and getn(self.SkillList) or 0;

	if (not self.SkillList) then
		FauxScrollFrame_Update(KC_TradeSkillFrame_skillList_ScrollFrame, skillNum, 15, 25);
		return;
	end
	
    local offset	=	FauxScrollFrame_GetOffset(KC_TradeSkillFrame_skillList_ScrollFrame)

	for index = 1, 15 do
		local button = getglobal("KC_TradeSkillFrame_skillList_SkillButton"..index)
		button:SetText("");
	end

	for index = 1, 15 do
		local button = getglobal("KC_TradeSkillFrame_skillList_SkillButton"..index)

        if ( index+offset > skillNum ) then
            button:Hide()
        else
			local skill

			repeat
				local skill = self.SkillList[index+offset];
				if (skill) then
					show = (skill.type == "header" or not self.ShrunkHeaders[skill.header])					
				else
					show = true;
				end
				offset = offset + 1;
			until (show);

			offset = offset - 1;
			local skill = self.SkillList[index+offset];
			
			if (not skill) then return;	end
			
			local text = KC_Skill_Colors[skill.type];
			if (skill.type == "header") then
				text = text .. skill.name;
				getglobal(button:GetName() .. "_MakeCount"):SetText("")
			else
				text = text .. "    " .. skill.name;
			end
			
            getglobal(button:GetName() .. "_NormalText"):SetText(text)
            getglobal(button:GetName() .. "_HighlightText"):SetText(text)
            button:Show()
            button:UnlockHighlight()
            button:SetID(index+offset)
        end
	end
	

	FauxScrollFrame_Update(KC_TradeSkillFrame_skillList_ScrollFrame, skillNum, 15, 25);
end

function KC_EnhancedTradesFrame:SkillButton_OnClick(skillID)
	local skill = self.SkillList[skillID];

	if (not skill) then return;	end

	if (skill.type == "header") then
		if (self.ShrunkHeaders[skillID]) then
			 self.ShrunkHeaders[skillID] = FALSE;
		else
			self.ShrunkHeaders[skillID] = TRUE;
		end
		self:_updateSkillList();
		self.selectedSkill = nil;
	else
		self.selectedSkill = skillID;
	end
	
	SelectTradeSkill(skillID);
end

--[[
----	Queue functions.
]]--
function KC_EnhancedTradesFrame:AddQueue(skillID, qty)
	if (not skillID or skillID == 0) then return; end
	self.Queue[getn(self.Queue)+1] = {skillID = skillID, qty = qty};
	self:EatQueue()
end


function KC_EnhancedTradesFrame:CraftFail() 
	self.Crafting = false;
	self:CraftDone(1);
end

function KC_EnhancedTradesFrame:CraftInterupt() 
	self.Crafting = false;
end

function KC_EnhancedTradesFrame:CraftStart() 
	self.Crafting = true;
end

function KC_EnhancedTradesFrame:CraftChat() 
	for item in string.gfind(arg1, "You create (.+).") do
			self:CraftDone(item);
			return;
	end
end

function KC_EnhancedTradesFrame:CraftDone(item)
	if (getn(self.Queue) > 0 and item == self.SkillList[self.Queue[1].skillID].name) then
		self.Queue[1].qty = self.Queue[1].qty -1;
		if (self.Queue[1].qty <= 0) then
			self.Crafting = false;
			table.remove(self.Queue, 1);
			if (getn(self.Queue) > 0) then
				self:EatQueue();
			end
		end
	elseif(item == 1) then
		table.remove(self.Queue, 1);
		ChatFrame2:AddMessage("Should be Gone");
	end
end

function KC_EnhancedTradesFrame:EatQueue()
	if (self.Crafting) then return nil; end

	local skill = self.Queue[1] or {skillID = 0};

	if (skill and skill.skillID >= 0) then
		DoTradeSkill(skill.skillID, skill.qty);
	end
end