--#################################################################################################
-- GougeHelper
-- by FizbanLaPolio
--
--#################################################################################################
-- Coding Inspiration :
--  * Blizzard's CastingBarFrame (main window)
--  * Miron's SunderThis (first gouge detection, changed for another way, but a lot of coding inspiration should goes to him, and for Talent detection)
--  * Telo's MobHealth (for the new CombatLog gouge detection)
--  * ???'s MoneyDisplay (for the moving-window and variable saving parts)
-- Thx to : 
--  * Zheniar, for his tests


-- GOUGEHELP_STATUS contient le status de GougeHelper
-- *   0 = inactif
-- *   1 = actif, pas de Gouge
-- *   2 = actif, Gouge en cours
-- *   3 = mode débloqué, affichage simple pour bouger la fenêtre à l'écran
GOUGEHELPER_TIMER_START = nil
GOUGEHELPER_TIMER_END = nil
GOUGEHELPERBAR_ALPHA_STEP = 0.2
GOUGEHELPER_GOUGE_LENGTH = 4
GOUGEHELPER_DEBUG = nil

function GougeHelper_OnLoad()

	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
	this:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA");
	this:RegisterEvent("VARIABLES_LOADED")

	-- Gère la commande Slash
	SLASH_GOUGEHELPER1 = "/gougehelper";
	SLASH_GOUGEHELPER2 = "/gh";
	SlashCmdList["GOUGEHELPER"] = function(msg)
		GougeHelper_SlashCommandHandler(msg);
	end

	--if( DEFAULT_CHAT_FRAME ) then
		--DEFAULT_CHAT_FRAME:AddMessage(GOUGEHELPER_HELP1.."/gh");
	--end
	--UIErrorsFrame:AddMessage("GougeHelper Loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function GougeHelper_SlashCommandHandler(msg)
	if( msg ) then
		local command = string.lower(msg);
		if( command == "on" ) then
			if ( GOUGEHELPER_STATUS == 0 ) then
				GOUGEHELPER_STATUS = 1;
				GH_Save.status = GOUGEHELPER_STATUS;
				DEFAULT_CHAT_FRAME:AddMessage("GougeHelper activated");
			end
		elseif ( command == "off" ) then
			if ( GOUGEHELPER_STATUS ~= 0 ) then
				GOUGEHELPER_STATUS = 0;
				GH_Save.status = GOUGEHELPER_STATUS;
				DEFAULT_CHAT_FRAME:AddMessage("GougeHelper removed");
			end
		elseif ( command == "unlock" ) then
				GOUGEHELPER_STATUS = 3;
				GougeHelper:Show();
		elseif ( command == "lock" ) then
				GOUGEHELPER_STATUS = 1;
				GougeHelper:Hide();
		elseif ( command == "clear" ) then
				GH_Save = nil;
				GOUGEHELPER_STAUTS = 0;
--		elseif (command >= "4" and command < "6" ) then
--			GOUGEHELPER_GOUGE_LENGTH = command
--			GH_Save.duration = GOUGEHELPER_GOUGE_LENGTH;
--			DEFAULT_CHAT_FRAME:AddMessage("GougeHelper : "..GOUGEHELPER_GOUGE_LENGTH.."sec");
		else
			DEFAULT_CHAT_FRAME:AddMessage(GOUGEHELPER_HELP1..GOUGEHELPER_GOUGE_LENGTH.."sec (autoDetection)");
			DEFAULT_CHAT_FRAME:AddMessage(GOUGEHELPER_HELP2);
			DEFAULT_CHAT_FRAME:AddMessage(GOUGEHELPER_HELP3);
			DEFAULT_CHAT_FRAME:AddMessage(GOUGEHELPER_HELP4);
		end
	end
end

function GougeHelper_OnEvent()
	if ( GOUGEHELPER_STATUS == 0 ) then
		return;
	end
-- Some Debug	
	if ( GOUGEHELPER_DEBUG ~= nil ) then
		if (event ~= "") then 
			DEFAULT_CHAT_FRAME:AddMessage("1 "..event);
		else
			DEFAULT_CHAT_FRAME:AddMessage("Rien...");
		end
		if (arg1 ~= "") and (arg1 ~= nil) then
			DEFAULT_CHAT_FRAME:AddMessage("2 "..arg1);
		end
		if (arg2 ~= "" ) and (arg2 ~= nil) then
			DEFAULT_CHAT_FRAME:AddMessage("3 \""..arg2.."\"");
		end
	end
--	
	if (event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" ) then
		for mobname in string.gfind(arg1, GOUGEHELPER_TEXT_ON) do
			GOUGEHELPER_MOBNAME = mobname ;
			GougeHelper:Show();
			break;
		end
	elseif (event == "CHAT_MSG_SPELL_BREAK_AURA" ) then
		for mobname in string.gfind(arg1, GOUGEHELPER_TEXT_BREAK) do
			GOUGEHELPER_MOBNAME = mobname ;
			GOUGEHELPER_TIMER_END = GetTime();
			break;
		end
	elseif (event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" ) then
		for mobname in string.gfind(arg1, GOUGEHELPER_TEXT_OFF) do
			GOUGEHELPER_MOBNAME = mobname ;
			GOUGEHELPER_TIMER_END = GetTime();
			break;
		end
	elseif (event == "VARIABLES_LOADED" ) then
		GougeHelper_LoadVariables();
	end
end


function GougeHelper_OnShow()
	GOUGEHELPER_TIMER_START = GetTime();
	GOUGEHELPER_TIMER_END = GOUGEHELPER_TIMER_START + GOUGEHELPER_GOUGE_LENGTH;
--	DEFAULT_CHAT_FRAME:AddMessage("GougeHelper Start : "..GetTime());
	if (GOUGEHELPER_STATUS ~= 3) then
		GOUGEHELPER_STATUS = 2;
	end
	this:SetAlpha(1);
	GougeHelperFrameStatusBar:SetStatusBarColor(1, 1, 0);
	GougeHelperSpark:SetPoint("CENTER", "GougeHelperFrameStatusBar", "LEFT", 0, 0);
	if ( GOUGEHELPER_MOBNAME == nil or GOUGEHELPER_MOBNAME == "" ) then
		GougeHelperText:SetText(GOUGEHELPER_SKILL);
	else
		GougeHelperText:SetText(GOUGEHELPER_SKILL.." : "..GOUGEHELPER_MOBNAME);
	end
end

function GougeHelper_OnUpdate()
--	DEFAULT_CHAT_FRAME:AddMessage("GougeHelper Update : "..GetTime());
	if (GOUGEHELPER_STATUS == 3) then
		return nil;
	end
--	if (GOUGEHELPER_STATUS == 2) then
		local Status = GetTime();
		-- Si on est avant la fin du Gouge
		if (Status <= GOUGEHELPER_TIMER_END) then
			local sparkPosition = ((Status - GOUGEHELPER_TIMER_START) / (GOUGEHELPER_TIMER_END - GOUGEHELPER_TIMER_START)) * 195;
			GougeHelperFrameStatusBar:SetMinMaxValues(GOUGEHELPER_TIMER_START, GOUGEHELPER_TIMER_END);
			GougeHelperFrameStatusBar:SetValue(GetTime());
			if ( Status > GOUGEHELPER_TIMER_END - 0.5 ) then
				GougeHelperFrameStatusBar:SetStatusBarColor(1, 0, 0);
			elseif ( Status > GOUGEHELPER_TIMER_END - 1 ) then
				GougeHelperFrameStatusBar:SetStatusBarColor(1, 0.5, 0);
			end
			if ( sparkPosition < 0 ) then
				sparkPosition = 0;
			end
			GougeHelperSpark:SetPoint("CENTER", "GougeHelperFrameStatusBar", "LEFT", sparkPosition, 0);
		-- Si on a fini le Gouge, on est en période de FadeOut
		elseif ( this:GetAlpha() > 0 ) then
			if ( GOUGEHELPER_STATUS == 2 ) then
	--			DEFAULT_CHAT_FRAME:AddMessage("GougeHelper Stop : "..GetTime());
				GOUGEHELPER_STATUS = 1;
				GougeHelperText:SetText("TimeOut");
			end
			local alpha = this:GetAlpha() - GOUGEHELPERBAR_ALPHA_STEP;
			if ( alpha > 0 ) then
				this:SetAlpha(alpha);
			else
				this.fadeOut = nil;
				this:Hide();
			end
		-- Au cas ou le FadeOut arrive ici
		else
	--		DEFAULT_CHAT_FRAME:AddMessage("GougeHelper Stop : "..GetTime());
			this:Hide();
			GOUGEHELPER_STATUS = 1;
		end
--	end
end

function GougeHelper_LoadVariables()
	if not GH_Save then
  	GH_Save = { };
		GH_Save.status = 1;
		UpdateImpGouge();
	end
	GOUGEHELPER_STATUS = GH_Save.status
	GOUGEHELPER_GOUGE_LENGTH = GH_Save.duration

end

function IsGouged()
	if (GOUGEHELPER_STATUS == 2) then
		return 1;
	else
		return nil;
	end
end

function UpdateImpGouge()
-- lecture de l'arbre des talents, page=2, talent=1 (ImpGouge)
	local _, texture, _, _, rank, _, _, _ = GetTalentInfo( 2, 1 );

	if texture then
		GH_Save.duration = 4 + rank*0.5;
	else
		GH_Save.duration = 4;
	end
end