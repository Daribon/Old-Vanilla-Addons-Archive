--[[
	BOBonusActionBarFrame
	 	An overloaded BonusActionBar
	
	By: Mugendai
	
	Replaces the normal BonusActionBar with one that has a name for the second texture on it.
	Used to allow modules like PopNUI, and TransNUI to hide the artwork, without hiding the buttons.
	
	$Id: BOBonusActionBarFrame.lua 1441 2005-05-05 08:41:19Z Sinaloit $
	$Rev: 1441 $
	$LastChangedBy: Sinaloit $
	$Date: 2005-05-05 10:41:19 +0200 (Thu, 05 May 2005) $
]]--

--------------------------------------------------
--
-- Constants
--
--------------------------------------------------
BO_BAB_FirstShow = nil;		--Set to true, once the bar is shown for the first time


--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
function BOBonusActionBar_OnLoad()
	this:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	this:RegisterEvent("ACTIONBAR_SHOWGRID");
	this:RegisterEvent("ACTIONBAR_HIDEGRID");
	if ( GetBonusBarOffset() > 0 and CURRENT_ACTIONBAR_PAGE == 1 ) then
		BOShowBonusActionBar();
	end
	this:SetFrameLevel(this:GetFrameLevel() + 2);
	this.mode = "none";
	this.completed = 1;
	if (BonusActionBar) then
		BonusActionBar.lastBonusBar = 1;
	end
end

function BOBonusActionBar_OnEvent()	
	if ( event == "UPDATE_BONUS_ACTIONBAR" ) then
		if ( GetBonusBarOffset() > 0 ) then
			if (BonusActionBar) then
				BonusActionBar.lastBonusBar = GetBonusBarOffset();
			end
			UnlockPetActionBar();
			HidePetActionBar();
			BOShowBonusActionBar();
		else
			BOHideBonusActionBar();
			if ( PetHasActionBar() ) then
				ShowPetActionBar();
				LockPetActionBar();
			end
		end
	else
		--The system doesn't seem to set the bonus bar mode at the time it gets loaded.
		--So we need to go ahead and check at later times to see if this ever gets set.
		--if it does get set, we should go ahead and show it atleast once.
		if (( GetBonusBarOffset() > 0 and CURRENT_ACTIONBAR_PAGE == 1 ) and not BO_BAB_FirstShow) then
			BOShowBonusActionBar();
		end
	end
end

function BOBonusActionBar_OnUpdate(elapsed)
	local yPos;
	if ( this.slideTimer and (this.slideTimer < this.timeToSlide) ) then
		-- Animating
		this.completed = nil;
		if ( this.mode == "show" ) then
			yPos = (this.slideTimer/this.timeToSlide) * this.yTarget;
			this:SetPoint("TOPLEFT", this:GetParent():GetName(), "BOTTOMLEFT", BONUSACTIONBAR_XPOS, yPos);
			this.state = "showing";
			this:Show();
		elseif ( this.mode == "hide" ) then
			yPos = (1 - (this.slideTimer/this.timeToSlide)) * this.yTarget;
			this:SetPoint("TOPLEFT", this:GetParent():GetName(), "BOTTOMLEFT", BONUSACTIONBAR_XPOS, yPos);
			this.state = "hiding";
		end
		this.slideTimer = this.slideTimer + elapsed;
	else
		-- Animation complete
		if ( this.completed == 1 ) then
			return;
		else
			this.completed = 1;
		end
		BOBonusActionBar_SetButtonTransitionState(nil);
		if ( this.mode == "show" ) then
			this:SetPoint("TOPLEFT", this:GetParent():GetName(), "BOTTOMLEFT", BONUSACTIONBAR_XPOS, this.yTarget);
			this.state = "top";
			PlaySound("igBonusBarOpen");
		elseif ( this.mode == "hide" ) then
			this:SetPoint("TOPLEFT", this:GetParent():GetName(), "BOTTOMLEFT", BONUSACTIONBAR_XPOS, 0);
			this.state = "bottom";
			this:Hide();
		end
		this.mode = "none";
	end
end

function BOShowBonusActionBar()
	BO_BAB_FirstShow = true;	--So we know this bar has been shown for the first time.
	BOBonusActionBar_SetButtonTransitionState(nil);
	if ( BOBonusActionBarFrame.mode ~= "show" and BOBonusActionBarFrame.state ~= "top") then
		BOBonusActionBarFrame:Show();
		if ( BOBonusActionBarFrame.completed ) then
			BOBonusActionBarFrame.slideTimer = 0;
		end
		BOBonusActionBarFrame.timeToSlide = BONUSACTIONBAR_SLIDETIME;
		BOBonusActionBarFrame.yTarget = BONUSACTIONBAR_YPOS;
		BOBonusActionBarFrame.mode = "show";
	end
end

function BOHideBonusActionBar()
	if ( BOBonusActionBarFrame:IsVisible() ) then
		BOBonusActionBar_SetButtonTransitionState(1);
		if ( BOBonusActionBarFrame.completed ) then
			BOBonusActionBarFrame.slideTimer = 0;
		end
		BOBonusActionBarFrame.timeToSlide = BONUSACTIONBAR_SLIDETIME;
		BOBonusActionBarFrame.yTarget = BONUSACTIONBAR_YPOS;
		BOBonusActionBarFrame.mode = "hide";
	end
end

function BOBonusActionButton_OnEvent()
	if ( event == "UPDATE_BINDINGS" ) then
		ActionButton_UpdateHotkeys();
	end
end

function BOBonusActionButtonUp(id)
	PetActionButtonUp(id);
end

function BOBonusActionButtonDown(id)
	PetActionButtonDown(id);
end

function BOBonusActionBar_SetButtonTransitionState(state)
	local button, icon;
	for i=1, NUM_BONUS_ACTION_SLOTS, 1 do
		button = getglobal("BOBonusActionButton"..i);
		icon = getglobal("BOBonusActionButton"..i.."Icon");
		button.inTransition = state;
		if ( state ) then
			icon:SetTexture(button.texture);
			if ( button.texture ) then
				icon:Show();
				button:Show();
			end
		end
	end
end