----------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------
local Old_GossipButton_Click;
local New_GossipButton_Click;
local GS_Version = "1.2c";
local GossipID = -1;
local gID
----------------------------------------------------------------------
-- OnFoo
----------------------------------------------------------------------

function GossipSafe_Onload()

	--Hook into the GossipFrame OnClick.
	Old_GossipButton_Click = GossipTitleButton_OnClick;
	GossipTitleButton_OnClick = New_GossipButton_Click;

	-- if( DEFAULT_CHAT_FRAME ) then
	--	DEFAULT_CHAT_FRAME:AddMessage("Gossip Safe "..GS_Version.." Loaded");
	-- end
end

function New_GossipButton_Click()
	if ( this.type == "Available" ) then
		Old_GossipButton_Click();
	elseif ( this.type == "Active" ) then
		Old_GossipButton_Click();
	else

		GossipID = -1;

		HandleGossip_Options(GetGossipOptions());

		--if( DEFAULT_CHAT_FRAME ) then
		--	DEFAULT_CHAT_FRAME:AddMessage("GossipDebug: ".."Found ID= "..GossipID.." Button Pressed= "..this:GetID());
		--end

		gID = this:GetID();

		if( GossipID == this:GetID() and Handle_ReCheck(GetGossipOptions()) == 1 ) then

			--Create our static popup.
			StaticPopupDialogs["GOSSIP_SAFE"] = {
		text = TEXT(POPUP_TEXT..GetZoneText()),
		button1 = TEXT(YES_TEXT),
		button2 = TEXT(NO_TEXT),
		OnAccept = function()
			Old_GossipButton_Click();
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		interruptCinematic = 1
		};

			local dialog = StaticPopup_Show("GOSSIP_SAFE");

			if( dialog ) then
				GossipID = -1;
			else
				Old_GossipButton_Click();
			end
		else
			Old_GossipButton_Click();
		end
	end
end

function HandleGossip_Options(...)
	for i=1, arg.n, 2 do
		if( i > 16 ) then
			GossipID = -1;
			break;
		end

		if( strlower(format(TEXT(arg[i]))) == GOSSIP_BUTTON_TEXT) then
			GossipID = i;
			break;
		end
	end
end

function Handle_ReCheck(...)
	if( strlower(format(TEXT(arg[gID]))) == GOSSIP_BUTTON_TEXT) then
		return 1;
	else
		return 0;
	end
end