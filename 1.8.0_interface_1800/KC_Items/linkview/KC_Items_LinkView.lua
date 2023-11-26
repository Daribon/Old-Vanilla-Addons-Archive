local TRUE = 1;
local FALSE = nil;

local DEFAULT_OPTIONS =	{};

--[[--------------------------------------------------------------------------------
	Module Description : LinkView

	This module displays tooltips on the various saved links in KCI

	NOTE: No link collection functions exist in this module.  

	Version: 0.91
	Last Released: 8/7/2005

-----------------------------------------------------------------------------------]]

--[[--------------------------------------------------------------------------------
  Class Definition
-----------------------------------------------------------------------------------]]

KC_LinkViewClass = KC_ItemsCoreClass:new({
    name          = KC_LINKVIEW_NAME,
    description   = KC_LINKVIEW_DESCRIPTION,
    version       = "0.91",
    releaseDate   = "8/07/05",
    aceCompatible = "100", -- Check ACE_COMP_VERSION in Ace.lua for current.
    author        = "Kaelten",
    email         = "kaelten@gmail.com",
    website       = "http://kaelcycle.wowinterface.com",
	defaults	  = DEFAULT_OPTIONS,
    category      = "inventory",
    --optionsFrame  = "KC_LinkViewOptionsFrame",
    db            = AceDbClass:new("KC_LinkViewDB"),
	dependents	  = AceDbClass:new(),
	cmd           = AceChatCmdClass:new({})
})

--[[--------------------------------------------------------------------------------
  Initialization
-----------------------------------------------------------------------------------]]

function KC_LinkViewClass:Initialize()
	self.strsubt = string.sub;
	-- don't load me if KC_Items is not loaded.
	if (KC_Items and KC_Items.disabled == FALSE) then
		KC_Items:RegisterDependent("KC_LinkView");
	else 
		self.disabled = TRUE;
	end
	self.sortmethod = KC_LINKVIEW_TEXT_NAME;

	if (KC_RadialButton) then
		KC_RadialButton:RegisterButton(KC_RadialButton_LinkView, "KC_LinkView_Frame", 295);
	end
end


--[[--------------------------------------------------------------------------------
  Addon Enabling/Disabling
-----------------------------------------------------------------------------------]]

function KC_LinkViewClass:Enable()

end

function KC_LinkViewClass:Disable()
	self:DisableDependents()
end

--[[--------------------------------------------------------------------------------
  LinkView Functions
-----------------------------------------------------------------------------------]]

function KC_LinkViewClass:BuildLinkTable(pattern)

	self.linkTotal = 0;
	self.links = {};

	local id;
	for id in KC_Items.db:get() do
		local name;
		if (id ~= "stats" and id ~= "profiles" and id ~= "v") then
			name = KC_Items:GetName(id);	
		end
		if (name) then
			local matches = TRUE;
			if (pattern) then
				matches = name and strfind(strlower(name), strlower(pattern)) or nil;	
			end
			if (matches) then
				self.linkTotal = self.linkTotal + 1;
				self.links[self.linkTotal] = KC_Items:GetHyperlink(id);
			end
		end	
	end
	
	self:BuildSortTable();

	KC_LinkView_FrameTitle:SetText(format(KC_LINKVIEW_TEXT_HEADERPATTERN, self.linkTotal, KC_Items.db:get(KC_Items.statsPath, "cnt")));
end

function KC_LinkViewClass:BuildSortTable()
	method = self.sortmethod;
	self.sortTable = {};
	self.crossReference = {};
	local key, name;
	
	for i = 1, self.linkTotal do		
		key = ""; x = 0; orgkey = key;
		if (method == KC_LINKVIEW_TEXT_QUALITY) then
			key = KC_Items:GetQuality(self.links[i]);
		elseif (method == KC_LINKVIEW_TEXT_CLASS) then
			key = KC_Items:GetClass(self.links[i]);
		elseif (method == KC_LINKVIEW_TEXT_TYPE) then
			key = KC_Items:GetSubClass(self.links[i]);
		elseif (method == KC_LINKVIEW_TEXT_LEVEL) then
			key = KC_Items:GetMinLevel(self.links[i]);
			if (tonumber(key) < 10) then
				key = "0" .. key;
			end
		end
		
		key = key .. KC_Items:GetName(self.links[i]);
		orgkey = key;
		while (self.crossReference[key]) do
			key = orgkey .. x;
			x = x + 1;
		end
		self.sortTable[i] = key;
		self.crossReference[key] = self.links[i];
	end
	
	ace.sort(self.sortTable)
	
	self:BuildSortedLinkTable()
end

function KC_LinkViewClass:BuildSortedLinkTable()
	self.sortedLinks = {}

	for i = 1, self.linkTotal do
		self.sortedLinks[i] = self.crossReference[self.sortTable[i]];
	end
	
	self.crossReference = nil;
	self.sortTable = nil;
	self.links = nil;
end

function KC_LinkViewClass:UpdateList()
	linkNum	= self.linkTotal and self.linkTotal or 0;

	if (not self.sortedLinks) then
		FauxScrollFrame_Update(KC_LinkView_Frame_ScrollFrame, linkNum, 22, 16);
		return;
	end
	
    local offset = FauxScrollFrame_GetOffset(KC_LinkView_Frame_ScrollFrame)

	for index = 1, 22 do
		local button = getglobal("KC_LinkView_Frame_Button"..index)

        if ( index+offset > linkNum ) then
            button:Hide()
        else
			local id = self.sortedLinks[index+offset];
			local name = KC_Items:GetColoredName(id, 43);

			getglobal(button:GetName() .. "_NormalText"):SetText(name)
            getglobal(button:GetName() .. "_HighlightText"):SetText(name)

			button:Show()
            button:UnlockHighlight()
            button:SetID(index+offset)
        end
	end
	
	FauxScrollFrame_Update(KC_LinkView_Frame_ScrollFrame, linkNum, 22, 16);
end


function KC_LinkViewClass:ItemEnter()
	local id = self.sortedLinks[this:GetID()];
	if( id ) then
		GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
		GameTooltip:SetHyperlink(KC_Items:GetHyperlink(id));
	end	
end

function KC_LinkViewClass:ItemLeave()
	if (GameTooltip:IsVisible()) then
		GameTooltip:Hide();
	end
end

function KC_LinkViewClass:ItemClick(button)
	if( button == "LeftButton" ) then
		local id = self.sortedLinks[this:GetID()];
		if( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert(KC_Items:GetTextLink(id));
		else
			SetItemRef(KC_Items:GetHyperlink(id));
		end
	elseif( button == "RightButton" and IsShiftKeyDown()) then
		local id = self.sortedLinks[this:GetID()];
		KC_Items:RemoveCode(id);
		self:BuildLinkTable(ace.trim(KC_LinkView_Frame_SearchText:GetText()));
		self:UpdateList();
	elseif( button == "RightButton" and KC_Rundown ) then
		KC_Rundown:rundown(KC_Items:GetName(self.sortedLinks[this:GetID()]));
	end
end


function KC_LinkViewClass:PopulateDropDown()
	UIDropDownMenu_Initialize(KC_LinkView_Frame_SortDropDown1, function() KC_LinkView:InitializeDropDown() end);
	self:DropDown_SetSelection(KC_LinkView_Frame_SortDropDown1, 1, KC_LINKVIEW_SORTDROPDOWN_LIST);
	UIDropDownMenu_SetWidth(135);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", KC_LinkView_Frame_SortDropDown1)
end

function KC_LinkViewClass:DropDown_SetSelection(frame, id, names)
	UIDropDownMenu_SetSelectedID(frame, id);
	if( not frame ) then
		frame = this;
	end
	UIDropDownMenu_SetText(names[id], frame);
end

function KC_LinkViewClass:DropDown_OnClick()
	local oldID = UIDropDownMenu_GetSelectedID(KC_LinkView_Frame_SortDropDown1);
	UIDropDownMenu_SetSelectedID(KC_LinkView_Frame_SortDropDown1, this:GetID());
	if( oldID ~= this:GetID() ) then	
		self.sortmethod = KC_LINKVIEW_SORTDROPDOWN_LIST[this:GetID()];
		KC_LinkView:BuildLinkTable(ace.trim(KC_LinkView_Frame_SearchText:GetText()));
		FauxScrollFrame_SetOffset(KC_LinkView_Frame_ScrollFrame, 1);
		self:UpdateList()
	end
end

function KC_LinkViewClass:InitializeDropDown()
	for i = 1, getn(KC_LINKVIEW_SORTDROPDOWN_LIST), 1 do
		UIDropDownMenu_AddButton({text = KC_LINKVIEW_SORTDROPDOWN_LIST[i], func = function() KC_LinkView:DropDown_OnClick()	end	});
	end
end

--[[--------------------------------------------------------------------------------
  KC_ItemsClass API wrapers

  NOTE: This means you CAN call KC_Items for these functions to provide a more 
  streamlined interface for devs.
-----------------------------------------------------------------------------------]]



--[[--------------------------------------------------------------------------------
  Chat Command Handlers

  NOTE: I didn't give each module its own chat handler.  Each addon present just
  adds more functionality into the default one for KCI.

  Unless I can get a standalone class working(failed horridly last time) this means
  chat handlers need to be included in the KC_ItemsClass.
-----------------------------------------------------------------------------------]]

function KC_ItemsClass:linkviewtoggle()
	if (KC_LinkView_Frame:IsVisible()) then
		KC_LinkView_Frame:Hide();
	else
		KC_LinkView_Frame:Show();
		KC_LinkView_Frame_SearchText:SetFocus();
	end
	
end


--[[--------------------------------------------------------------------------------
  Create and Register Addon Object
-----------------------------------------------------------------------------------]]

KC_LinkView = KC_LinkViewClass:new()
KC_LinkView:RegisterForLoad();