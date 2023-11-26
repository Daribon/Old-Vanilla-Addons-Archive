-- RangeRecolor
-- by CrowGoblin

BINDING_HEADER_RANGERECOLOR = "RangeRecolor";

local RangeRecolorName = "RangeRecolor";
local RangeRecolorVersion = 2.1;
local isLoaded = false;

function RangeRecolor_OptionsCheckButtonOnClick1()
	if (RangeRecolorEnabled) then
		RangeRecolorEnabled = false;
	else
		RangeRecolorEnabled = true;
	end
end
function RangeRecolor_OptionsCheckButtonOnClick2()
		if(RangeRecolorRed == true) then
			RangeRecolorRed = false;
			RangeRecolorGrey = true;
		elseif(RangeRecolorGrey == true) then
			RangeRecolorRed = true;
			RangeRecolorGrey = false;
		end
end

function RangeRecolorOptions_Defaults()
	RangeRecolorEnabled = true;
	RangeRecolorRed = true;
	RangeRecolorGrey = false;
	RangeRecolorColorRed = { r = 0.8, g = 0.1, b = 0.1 };
	RangeRecolorColorGrey = { r = 0.4, g = 0.4, b = 0.4 };
	RangeRecolorColorNoMana = { r = 0.5, g = 0.5, b = 1.0 };
	RangeRecolorOptions_Show();
end

function RangeRecolorOptions_Show()
	local string = getglobal("RangeRecolorOptionsFrame_CheckButton1Text");
	string:SetText("Enable RangeRecolor");
	local button1 = getglobal("RangeRecolorOptionsFrame_CheckButton1");
	if (RangeRecolorEnabled) then
		checked = 1;
	else
		checked = 0;
	end
	button1:SetChecked(checked);

	local string = getglobal("RangeRecolorOptionsFrame_CheckButton2Text");
	string:SetText("Recolor Red/Grey");
	local button2 = getglobal("RangeRecolorOptionsFrame_CheckButton2");
	if (RangeRecolorRed) then
		checked = 1;
	else
		checked = 0;
	end
	button2:SetChecked(checked);
end


function RangeRecolorOptions_Hide()
	RangeRecolorOptions:Hide();
end

-- Command parser
function RangeRecolor_Command(msg)
	if (msg==nil) then
		msg = "";
	end
	msg = string.lower(msg);
	
	-- configure?
	if(string.find(msg, 'red')) then
		RangeRecolorRed = true;
		RangeRecolorGrey = false;
	elseif(string.find(msg, 'grey')) then
		RangeRecolorRed = false;
		RangeRecolorGrey = true;
	elseif(string.find(msg, '')) then
		RangeRecolorOptions:Show();
	end
end

local function SetHook(myFunction, HookFunc)
	local oldFunction = getglobal(HookFunc);
	local newFunction =
		function(e)
			oldFunction(e);
			myFunction(e);
		end
	setglobal(HookFunc, newFunction);
end


function RangeRecolorAction_OnLoad()

	this:RegisterEvent("VARIABLES_LOADED");

	-- Set Default
	if (not RangeRecolorEnabled) then
		RangeRecolorEnabled = true;
		RangeRecolorColorRed = { r = 0.8, g = 0.1, b = 0.1 };
		RangeRecolorColorGrey = { r = 0.4, g = 0.4, b = 0.4 };
		RangeRecolorColorNoMana = { r = 0.5, g = 0.5, b = 1.0 };

		if(RangeRecolorRed == true) then
			RangeRecolorRed = true;
			RangeRecolorGrey = false;
		elseif(RangeRecolorGrey == true) then
			RangeRecolorRed = false;
			RangeRecolorGrey = true;
		else
			RangeRecolorRed = true;
		end
	end

	this:RegisterEvent("UNIT_NAME_UPDATE");

	-- Add RangeRecolor frame to the UIPanelWindows list
	UIPanelWindows["RangeRecolorOptions"] = {area = "center", pushable = 0};

	SlashCmdList["RangeRecolorCMD"] = RangeRecolor_Command;
	SLASH_RangeRecolorCMD1 = "/rr";
end

function RangeRecolorAction_OnEvent(event)
	if( (event=="UNIT_NAME_UPDATE") and (not isLoaded) ) then
		if( ( arg1 == "player" ) and ( UnitName("player") ~= nil) and ( UnitName("player") ~= UNKNOWNOBJECT )) then
			RangeRecolorAction_Setup();
		end
	end	

	if (event=="VARIABLES_LOADED") then
		if (RangeRecolorEnabled) then
			if(RangeRecolorRed == true) then
				RangeRecolorRed = true;
				RangeRecolorGrey = false;
			elseif(RangeRecolorGrey == true) then
				RangeRecolorRed = false;
				RangeRecolorGrey = true;
			else
				RangeRecolorRed = true;
			end
		end

		-- Add RangeRecolor to myAddOns addons list
		if(myAddOnsFrame) then
		myAddOnsList.RangeRecolor = {name = RangeRecolorName, description = "Recolor out of range action buttons", version = RangeRecolorVersion, category = MYADDONS_CATEGORY_BARS, frame = "RangeRecolorOptions", optionsframe = "RangeRecolorOptions"};
		end
	end

end

function RangeRecolorAction_Setup()
	isLoaded = true;

	if (not RangeRecolorEnabled) then
		return;
	end

	-- Hook Standard Buttons
	SetHook(RangeRecolorAction_OnUpdate, "ActionButton_OnUpdate");
	SetHook(RangeRecolorAction_UpdateUsable, "ActionButton_UpdateUsable");
	local hooks = "Standard Bar";

	-- CTMod
	if (type(CT_ActionButton_OnUpdate) == 'function') then
		SetHook(RangeRecolorAction_CT_OnUpdate, "CT_ActionButton_OnUpdate");
		SetHook(RangeRecolorAction_CT_UpdateUsable, "CT_ActionButton_UpdateUsable");
		hooks = hooks..", CT ToolBars";	
	end

	-- Gypsy
	if (type(Gypsy_ActionButtonOnUpdate) == 'function') then
		SetHook(RangeRecolorAction_OnUpdate, "Gypsy_ActionButtonOnUpdate");
		SetHook(RangeRecolorAction_UpdateUsable, "Gypsy_ActionButtonUpdateUsable");
		hooks = hooks..", Gypsy HotBar";
	end

	-- GhostBar
	if (type(GhostBar_ButtonOnUpdate) == 'function') then
		SetHook(RangeRecolorAction_OnUpdate, "GhostBar_ButtonOnUpdate");
		SetHook(RangeRecolorAction_UpdateUsable, "GhostBar_ButtonUpdateUsable");
		hooks = hooks..", GhostBar";	
	end

	-- PopBar
	if (type(PopBarButton_OnUpdate) == 'function') then
		SetHook(RangeRecolorAction_Pop_OnUpdate, "PopBarButton_OnUpdate");
		SetHook(RangeRecolorAction_Pop_UpdateUsable, "PopBarButton_UpdateUsable");
		hooks = hooks..", PopBar";	
	end

	-- Telo Sidebar
	if (type(SideBarButton_OnUpdate) == 'function') then
		SetHook(RangeRecolorAction_TSB_OnUpdate, "SideBarButton_OnUpdate");
		SetHook(RangeRecolorAction_TSB_UpdateUsable, "SideBarButton_UpdateUsable");
		hooks = hooks..", SideBar";	
	end

	-- Telo Bottombar
	if (type(BottomBarButton_OnUpdate) == 'function') then
		SetHook(RangeRecolorAction_TBB_OnUpdate, "BottomBarButton_OnUpdate");
		SetHook(RangeRecolorAction_TBB_UpdateUsable, "BottomBarButton_UpdateUsable");
		hooks = hooks..", BottomBar";	
	end

	-- FlexBar
	if (type(FlexBarButton_Update) == 'function') then
		SetHook(RangeRecolorAction_Flex_OnUpdate, "FlexBarButton_Update");
		SetHook(RangeRecolorAction_Flex_UpdateUsable, "FlexBarButton_UpdateUsable");
		hooks = hooks..", FlexBar";	
	end

	-- Discord ActionBars
	if (type(DAB_ActionButton_OnUpdate) == 'function') then
		SetHook(RangeRecolorAction_DAB_OnUpdate, "DAB_ActionButton_Update");
		hooks = hooks..", Discord ActionBars";	
	end

	-- BidToolBars supported
	-- HoloBar supported
	-- Nurfed ActionBars supported
	-- UltimateUI supported
	-- Insomniax supported

	-- if ( DEFAULT_CHAT_FRAME ) then
		-- DEFAULT_CHAT_FRAME:AddMessage(string.format("RangeRecolor loaded version %.1f",RangeRecolorVersion),1.0,1.0,1.0);
	-- end
end




function RangeRecolorAction_UpdateUsable(arg)

	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));

	if ( IsActionInRange(ActionButton_GetPagedID(this)) == 0 ) then
		if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
	else
		if ( isUsable ) then
			icon:SetVertexColor(1.0, 1.0, 1.0);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		elseif ( notEnoughMana ) then
			icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
			normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
		else
			icon:SetVertexColor(0.4, 0.4, 0.4);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		end
	end
end

function RangeRecolorAction_CT_UpdateUsable(button)

	if (not button) then
		button = this;
	end
	local icon = getglobal(button:GetName().."Icon");
	local normalTexture = getglobal(button:GetName().."NormalTexture");
	local pagedID = CT_ActionButton_GetPagedID(button);
	local isUsable, notEnoughMana;
	if (pagedID) then
		isUsable, notEnoughMana = IsUsableAction(pagedID);
	end
	if (icon and normalTexture) then
		if ( IsActionInRange(CT_ActionButton_GetPagedID(button)) == 0) then
			if(RangeRecolorRed == true) then
				icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
				normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			elseif(RangeRecolorGrey == true) then
				icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
				normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			end
		else
			if ( isUsable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			elseif ( notEnoughMana ) then
				icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			end
		end
	end

end

function RangeRecolorAction_Pop_UpdateUsable(button)

	if (not button) then
		button = this;
	end
	local icon = getglobal(button:GetName().."Icon");
	local normalTexture = getglobal(button:GetName().."NormalTexture");
	local pagedID = PopBarButton_GetPagedID(button);
	local isUsable, notEnoughMana;
	if (pagedID) then
		isUsable, notEnoughMana = IsUsableAction(pagedID);
	end
	if (icon and normalTexture) then
		if ( IsActionInRange(PopBarButton_GetPagedID(button)) == 0) then
			if(RangeRecolorRed == true) then
				icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
				normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			elseif(RangeRecolorGrey == true) then
				icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
				normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			end
		else
			if ( isUsable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			elseif ( notEnoughMana ) then
				icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			end
		end
	end
end


function RangeRecolorAction_TSB_UpdateUsable(button)

	if (not button) then
		button = this;
	end
	local icon = getglobal(button:GetName().."Icon");
	local normalTexture = getglobal(button:GetName().."NormalTexture");
	local pagedID = SideBarButton_GetID(button);
	local isUsable, notEnoughMana;
	if (pagedID) then
		isUsable, notEnoughMana = IsUsableAction(pagedID);
	end
	if (icon and normalTexture) then
		if ( IsActionInRange(SideBarButton_GetID(button)) == 0) then
			if(RangeRecolorRed == true) then
				icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
				normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			elseif(RangeRecolorGrey == true) then
				icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
				normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			end
		else
			if ( isUsable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			elseif ( notEnoughMana ) then
				icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			end
		end
	end
end

function RangeRecolorAction_TBB_UpdateUsable(button)

	if (not button) then
		button = this;
	end
	local icon = getglobal(button:GetName().."Icon");
	local normalTexture = getglobal(button:GetName().."NormalTexture");
	local pagedID = BottomBarButton_GetID(button);
	local isUsable, notEnoughMana;
	if (pagedID) then
		isUsable, notEnoughMana = IsUsableAction(pagedID);
	end
	if (icon and normalTexture) then
		if ( IsActionInRange(BottomBarButton_GetID(button)) == 0) then
			if(RangeRecolorRed == true) then
				icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
				normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			elseif(RangeRecolorGrey == true) then
				icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
				normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			end
		else
			if ( isUsable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			elseif ( notEnoughMana ) then
				icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			end
		end
	end
end

function RangeRecolorAction_Flex_UpdateUsable(button)

	if (not button) then
		button = this;
	end
	local icon = getglobal(button:GetName().."Icon");
	local normalTexture = getglobal(button:GetName().."NormalTexture");
	local pagedID = FlexBarButton_GetID(button);
	local isUsable, notEnoughMana;
	if (pagedID) then
		isUsable, notEnoughMana = IsUsableAction(pagedID);
	end
	if (icon and normalTexture) then
		if ( IsActionInRange(FlexBarButton_GetID(button)) == 0) then
			if(RangeRecolorRed == true) then
				icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
				normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			elseif(RangeRecolorGrey == true) then
				icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
				normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			end
		else
			if ( isUsable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			elseif ( notEnoughMana ) then
				icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			end
		end
	end

end






-- Update Function, sent elapsed time since last update (ms)
function RangeRecolorAction_OnUpdate(elapsed)
	
	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));

	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			ActionButton_UpdateUsable();
			if ( IsActionInRange(ActionButton_GetPagedID(this)) == 0 ) then
		if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
					normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
		end
	end

end

function RangeRecolorAction_CT_OnUpdate(elapsed)
	
	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(CT_ActionButton_GetPagedID(this));

	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			CT_ActionButton_UpdateUsable(button);
			if (IsActionInRange( CT_ActionButton_GetPagedID(this)) == 0) then
if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
					normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	else
		local count = getglobal(this:GetName().."HotKey");
		count:SetVertexColor(0.6, 0.6, 0.6);
	end

end

function RangeRecolorAction_Pop_OnUpdate(elapsed)
	
	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(PopBarButton_GetPagedID(this));

	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			PopBarButton_UpdateUsable(button);
			if (IsActionInRange( PopBarButton_GetPagedID(this)) == 0) then
if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
					normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	else
		local count = getglobal(this:GetName().."HotKey");
		count:SetVertexColor(0.6, 0.6, 0.6);
	end

end


function RangeRecolorAction_TSB_OnUpdate(elapsed)
	
	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(SideBarButton_GetID(this));

	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			SideBarButton_UpdateUsable(button);
			if (IsActionInRange( SideBarButton_GetID(this)) == 0) then
if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
					normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	else
		local count = getglobal(this:GetName().."HotKey");
		count:SetVertexColor(0.6, 0.6, 0.6);
	end

end

function RangeRecolorAction_TBB_OnUpdate(elapsed)
	
	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(BottomBarButton_GetID(this));

	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			BottomBarButton_UpdateUsable(button);
			if (IsActionInRange( BottomBarButton_GetID(this)) == 0) then
if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
					normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	else
		local count = getglobal(this:GetName().."HotKey");
		count:SetVertexColor(0.6, 0.6, 0.6);
	end

end

function RangeRecolorAction_Flex_OnUpdate(elapsed)
	
	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(FlexBarButton_GetID(this));

	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			FlexBarButton_UpdateUsable(button);
			if (IsActionInRange( FlexBarButton_GetID(this)) == 0) then
		if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
					normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			-- this.rangeTimer = this.rangeTimer - elapsed;
		end
	else
		-- getglobal(this:GetName().."HotKey"):SetVertexColor(0.6, 0.6, 0.6);
	end

end

function RangeRecolorAction_DAB_OnUpdate(elapsed)
	
	local icon = getglobal(this:GetName().."Icon");
	local isUsable, notEnoughMana = IsUsableAction(this:GetID());
	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			if ( IsActionInRange(this:GetID()) == 0 ) then
		if(RangeRecolorRed == true) then
			icon:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
			normalTexture:SetVertexColor(RangeRecolorColorRed.r, RangeRecolorColorRed.g, RangeRecolorColorRed.b);
		elseif(RangeRecolorGrey == true) then
			icon:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
			normalTexture:SetVertexColor(RangeRecolorColorGrey.r, RangeRecolorColorGrey.g, RangeRecolorColorGrey.b);
		end
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
					normalTexture:SetVertexColor(RangeRecolorColorNoMana.r, RangeRecolorColorNoMana.g, RangeRecolorColorNoMana.b);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			-- this.rangeTimer = this.rangeTimer - elapsed;
		end
	else
		-- getglobal(this:GetName().."HotKey"):SetVertexColor(0.6, 0.6, 0.6);
	end
end