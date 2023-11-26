function Perl_SlashOnLoad()
	SlashCmdList["PERL"] = Perl_SlashHandler;
	SLASH_PERL1 = "/perl";
end
function Perl_SlashHandler (msg)
	local args = {};
	for value in string.gfind(msg, "[^ ]+") do
		table.insert(args, string.lower(value));
	end
	if (args[1]=="") then
		Perl_OptionsMenu_Frame:Show();
		return;
	end
	if  (args[1]=="lock") then
		perl_locked=1;
	elseif (args[1]=="unlock") then
		perl_locked=0;
	elseif ((args[1]=="menu") or (args[1] == "options")) then
		Perl_OptionsMenu_Frame:Show();
		return;
	elseif (args[1]=="playerportrait" and args[2]=="hide") then
		Perl_Config.ShowPlayerPortrait=0;
	elseif (args[1]=="playerportrait" and args[2]=="show") then
		Perl_Config.ShowPlayerPortrait=1;
	elseif (args[1]=="playerlevel" and args[2]=="hide") then
		Perl_Config.ShowPlayerLevel=0;
	elseif (args[1]=="playerlevel" and args[2]=="show") then
		Perl_Config.ShowPlayerLevel=1;
	elseif (args[1]=="playerclass" and args[2]=="hide") then
		Perl_Config.ShowPlayerClassIcon=0;
	elseif (args[1]=="playerclass" and args[2]=="show") then
		Perl_Config.ShowPlayerClassIcon=1;
	elseif (args[1]=="targetportrait" and args[2]=="show") then
		Perl_Config.ShowTargetPortrait=1;
	elseif (args[1]=="targetportrait" and args[2]=="hide") then
		Perl_Config.ShowTargetPortrait=0;
	elseif (args[1]=="targetmobtype" and args[2]=="show") then
		Perl_Config.ShowTargetMobType=1;
	elseif (args[1]=="targetmobtype" and args[2]=="hide") then
		Perl_Config.ShowTargetMobType=0;
	elseif (args[1]=="targetlevel" and args[2]=="show") then
		Perl_Config.ShowTargetLevel=1;
	elseif (args[1]=="targetlevel" and args[2]=="hide") then
		Perl_Config.ShowTargetLevel=0;
	elseif (args[1]=="targetmana" and args[2]=="show") then
		Perl_Config.ShowTargetMana=1;
	elseif (args[1]=="targetmana" and args[2]=="hide") then
		Perl_Config.ShowTargetMana=0;
	elseif (args[1]=="targetelite" and args[2]=="show") then
		Perl_Config.ShowTargetElite=1;
	elseif (args[1]=="targetelite" and args[2]=="hide") then
		Perl_Config.ShowTargetElite=0;
	elseif (args[1]=="targetclass" and args[2]=="show") then
		Perl_Config.ShowTargetClassIcon=1;
	elseif (args[1]=="targetclass" and args[2]=="hide") then
		Perl_Config.ShowTargetClassIcon=0;
	elseif (args[1]=="partydistance" and args[2]=="hide") then
		Perl_Config.ShowPartyDistance=0;
	elseif (args[1]=="partydistance" and args[2]=="show") then
		Perl_Config.ShowPartyDistance=1;
	elseif (args[1]=="partylevel" and args[2]=="hide") then
		Perl_Config.ShowPartyLevel=0;
	elseif (args[1]=="partylevel" and args[2]=="show") then
		Perl_Config.ShowPartyLevel=1;
	elseif (args[1]=="partyicon" and args[2]=="hide") then
		Perl_Config.ShowPartyClassIcon=0;
	elseif (args[1]=="partyicon" and args[2]=="show") then
		Perl_Config.ShowPartyClassIcon=1;
	elseif (args[1]=="partypercent" and args[2]=="hide") then
		Perl_Config.ShowPartyPercent=0;
	elseif (args[1]=="partypercent" and args[2]=="show") then
		Perl_Config.ShowPartyPercent=1;
	elseif (args[1]=="partynames" and args[2]=="hide") then
		Perl_Config.ShowPartyNames=0;
	elseif (args[1]=="partynames" and args[2]=="show") then
		Perl_Config.ShowPartyNames=1;
	elseif (args[1]=="petlevel" and args[2]=="hide") then
		Perl_Config.ShowPetLevel=0;	
	elseif (args[1]=="petlevel" and args[2]=="show") then
		Perl_Config.ShowPetLevel=1;
	elseif (args[1]=="pethappiness" and args[2]=="hide") then
		Perl_Config.PetHappiness=0;	
	elseif (args[1]=="pethappiness" and args[2]=="show") then
		Perl_Config.PetHappiness=1;	
	elseif (args[1]=="usecptext") then
		Perl_Config.UseCPMeter=0;
	elseif (args[1]=="usecpmeter") then
		Perl_Config.UseCPMeter=1;
	elseif (args[1]=="playerxp" and args[2]=="show") then
		Perl_Config.ShowPlayerXPBar=1;
	elseif (args[1]=="playerxp" and args[2]=="hide") then
		Perl_Config.ShowPlayerXPBar=0;
	elseif (args[1]=="playerrank" and args[2]=="show") then
		Perl_Config.ShowPlayerPVPRank=1;
	elseif (args[1]=="playerrank" and args[2]=="hide") then
		Perl_Config.ShowPlayerPVPRank=0;
	elseif (args[1]=="targetrank" and args[2]=="show") then
		Perl_Config.ShowTargetPVPRank=1;
	elseif (args[1]=="targetrank" and args[2]=="hide") then
		Perl_Config.ShowTargetPVPRank=0;
	elseif (args[1]=="nobartextures") then
		Perl_Config.BarTextures=0;
	elseif (args[1]=="bartextures") then
		Perl_Config.BarTextures=1;
	elseif (args[1]=="settexttrans") then
		Perl_Config.TextTransparency=args[2];	
	elseif (args[1]=="settrans") then
		Perl_Config.Transparency=args[2];			
	elseif (args[1]=="setplayerscale") then
		Perl_Config.Scale_PlayerFrame=args[2];
	elseif (args[1]=="setpetscale") then
		Perl_Config.Scale_PetFrame=args[2];
	elseif (args[1]=="setpartyscale") then
		Perl_Config.Scale_PartyFrame=args[2];
	elseif (args[1]=="settargetscale") then
		Perl_Config.Scale_TargetFrame=args[2];
	elseif (args[1]=="settargettargetscale") then
		Perl_Config.Scale_TargetTargetFrame=args[2];
	elseif (args[1]=="arcanebar" and args[2]=="hide") then
		Perl_Config.ArcaneBar=0;
	elseif (args[1]=="arcanebar" and args[2]=="show") then
		Perl_Config.ArcaneBar=1;
	elseif (args[1]=="oldcastbar" and args[2]=="hide") then
		Perl_Config.OldCastBar=0;
	elseif (args[1]=="oldcastbar" and args[2]=="show") then
		Perl_Config.OldCastBar=1;
	elseif (args[1]=="blizzardplayer" and args[2]=="show") then
		Perl_Config.ShowOldPlayerFrame=1;
	elseif (args[1]=="blizzardplayer" and args[2]=="hide") then
		Perl_Config.ShowOldPlayerFrame=0;
	elseif (args[1]=="partyinraid" and args[2]=="show") then
		Perl_Config.ShowPartyRaid=1;
	elseif (args[1]=="partyinraid" and args[2]=="hide") then
		Perl_Config.ShowPartyRaid=0;
	elseif (args[1]=="castparty" and args[2]=="show") then
		Perl_Config.CastPartyShow=0;
	elseif (args[1]=="castparty" and args[2]=="hide") then
		Perl_Config.CastPartyShow=1;
	elseif (args[1]=="castparty" and args[2]=="on") then
		Perl_Config.CastParty=1;
	elseif (args[1]=="castparty" and args[2]=="off") then
		Perl_Config.CastParty=0;
	elseif (args[1]=="targettarget" and args[2]=="on") then
		Perl_Config.ShowTargetTarget=1;
	elseif (args[1]=="targettarget" and args[2]=="off") then
		Perl_Config.ShowTargetTarget=0;
	elseif (args[1]=="targetdistance" and args[2]=="hide") then
		Perl_Config.ShowTargetDistance=0;
	elseif (args[1]=="targetdistance" and args[2]=="show") then
		Perl_Config.ShowTargetDistance=1;
	elseif (args[1]=="raidbyclass") then
		Perl_Config.SortRaidByClass=1;
	elseif (args[1]=="raidbygroup") then
		Perl_Config.SortRaidByClass=0;
	elseif (args[1]=="petxp" and args[2]=="hide") then
		Perl_Config.ShowPetXP=0;
	elseif (args[1]=="petxp" and args[2]=="show") then
		Perl_Config.ShowPetXP=1;
		
	elseif (args[1]=="partydebuffs" and args[2]=="below") then
		Perl_Config.PartyDebuffsBelow=1;
	elseif (args[1]=="partydebuffs" and args[2]=="right") then
		Perl_Config.PartyDebuffsBelow=0;
	elseif (args[1]=="raid" and args[2]=="show") then
		Perl_Config.ShowRaid=1;
		Perl_Config.ShowGroup1=1;
		Perl_Config.ShowGroup2=1;
		Perl_Config.ShowGroup3=1;
		Perl_Config.ShowGroup4=1;
		Perl_Config.ShowGroup5=1;
		Perl_Config.ShowGroup6=1;
		Perl_Config.ShowGroup7=1;
		Perl_Config.ShowGroup8=1;
		Perl_Config.ShowGroup9=1;
		Perl_Config.ShowGroup10=1;
	elseif (args[1]=="raid" and args[2]=="hide") then
		Perl_Config.ShowRaid=0;
		Perl_Config.ShowGroup1=0;
		Perl_Config.ShowGroup2=0;
		Perl_Config.ShowGroup3=0;
		Perl_Config.ShowGroup4=0;
		Perl_Config.ShowGroup5=0;
		Perl_Config.ShowGroup6=0;
		Perl_Config.ShowGroup7=0;
		Perl_Config.ShowGroup8=0;
		Perl_Config.ShowGroup9=0;
		Perl_Config.ShowGroup10=0;
	elseif (args[1]=="raidpercent" and args[2]=="show") then
		Perl_Config.ShowRaidPercents=1;
	elseif (args[1]=="raidpercent" and args[2]=="hide") then
		Perl_Config.ShowRaidPercents=0;
	elseif (args[1]=="group1" and args[2]=="show") then
		Perl_Config.ShowGroup1=1;
	elseif (args[1]=="group1" and args[2]=="hide") then
		Perl_Config.ShowGroup1=0;
	elseif (args[1]=="group2" and args[2]=="show") then
		Perl_Config.ShowGroup2=1;
	elseif (args[1]=="group2" and args[2]=="hide") then
		Perl_Config.ShowGroup2=0;
	elseif (args[1]=="group3" and args[2]=="show") then
		Perl_Config.ShowGroup3=1;
	elseif (args[1]=="group3" and args[2]=="hide") then
		Perl_Config.ShowGroup3=0;
	elseif (args[1]=="group4" and args[2]=="show") then
		Perl_Config.ShowGroup4=1;
	elseif (args[1]=="group4" and args[2]=="hide") then
		Perl_Config.ShowGroup4=0;
	elseif (args[1]=="group5" and args[2]=="show") then
		Perl_Config.ShowGroup5=1;
	elseif (args[1]=="group5" and args[2]=="hide") then
		Perl_Config.ShowGroup5=0;
	elseif (args[1]=="group6" and args[2]=="show") then
		Perl_Config.ShowGroup6=1;
	elseif (args[1]=="group6" and args[2]=="hide") then
		Perl_Config.ShowGroup6=0;
	elseif (args[1]=="group7" and args[2]=="show") then
		Perl_Config.ShowGroup7=1;
	elseif (args[1]=="group7" and args[2]=="hide") then
		Perl_Config.ShowGroup7=0;
	elseif (args[1]=="group8" and args[2]=="show") then
		Perl_Config.ShowGroup8=1;
	elseif (args[1]=="group8" and args[2]=="hide") then
		Perl_Config.ShowGroup8=0;
	elseif (args[1]=="group9" and args[2]=="show") then
		Perl_Config.ShowGroup9=1;
	elseif (args[1]=="group9" and args[2]=="hide") then
		Perl_Config.ShowGroup9=0;
	elseif (args[1]=="setraidscale") then
		Perl_Config.Scale_Raid=args[2];
	elseif (args[1]=="casttime" and args[2]=="show") then
		Perl_Config.CastTime=1;
	elseif (args[1]=="casttime" and args[2]=="hide") then
		Perl_Config.CastTime=0;
	elseif (args[1]=="simpleframes") then
		Perl_Config.ShowPlayerPortrait=0;
		Perl_Config.ShowPlayerLevel=0;
		Perl_Config.ShowPlayerClassIcon=0;
		Perl_Config.ShowTargetClassIcon=0;
		Perl_Config.ShowTargetPortrait=0;
		Perl_Config.ShowTargetMobType=0;
		Perl_Config.ShowTargetLevel=0;
		Perl_Config.ShowTargetElite=0;
		Perl_Config.ShowTargetDistance=0;
		Perl_Config.ShowPartyDistance=0;
		Perl_Config.ShowPartyLevel=0;
		Perl_Config.ShowPartyClassIcon=0;
		Perl_Config.ShowPartyPercent=0;	
		Perl_Config.ShowPetLevel=0;	
		Perl_Config.PetHappiness=0;
	elseif (args[1]=="complexframes") then
		Perl_Config.ShowPlayerPortrait=1;
		Perl_Config.ShowPlayerLevel=1;
		Perl_Config.ShowPlayerClassIcon=1;
		Perl_Config.ShowTargetClassIcon=1;
		Perl_Config.ShowTargetPortrait=1;
		Perl_Config.ShowTargetMobType=1;
		Perl_Config.ShowTargetLevel=1;
		Perl_Config.ShowTargetElite=1;
		Perl_Config.ShowTargetDistance=1;
		Perl_Config.ShowPartyDistance=1;
		Perl_Config.ShowPartyLevel=1;
		Perl_Config.ShowPartyClassIcon=1;
		Perl_Config.ShowPartyPercent=1;	
		Perl_Config.ShowPetLevel=1;	
		Perl_Config.PetHappiness=1;
	elseif (args[1]=="raidhelp") then
		DEFAULT_CHAT_FRAME:AddMessage("/perl raidbyclass");
		DEFAULT_CHAT_FRAME:AddMessage("/perl raidbygroup");
		DEFAULT_CHAT_FRAME:AddMessage("/perl setraidscale #");
		DEFAULT_CHAT_FRAME:AddMessage("Show/hide the following:");
		DEFAULT_CHAT_FRAME:AddMessage("/perl raid");
		DEFAULT_CHAT_FRAME:AddMessage("/perl raidpercent");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group1 (Warrior)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group2 (Mage)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group3 (Priest)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group4 (Warlock)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group5 (Druid)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group6 (Rogue)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group7 (Hunter)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group8 (Shaman/Paladin");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group9 (Warrior Targets)");
		DEFAULT_CHAT_FRAME:AddMessage("/perl group10 (Pets)");
	elseif (args[1]=="basichelp") then
		DEFAULT_CHAT_FRAME:AddMessage("/perl lock /perl unlock /perl menu");
		DEFAULT_CHAT_FRAME:AddMessage("/perl simpleframes /perl complexframes");
		DEFAULT_CHAT_FRAME:AddMessage("/perl showhidehelp /perl settexttrans #");
		DEFAULT_CHAT_FRAME:AddMessage("/perl settrans # /perl raidhelp");
		DEFAULT_CHAT_FRAME:AddMessage("/perl settargetscale # /perl setpartyscale #");
		DEFAULT_CHAT_FRAME:AddMessage("/perl setplayerscale # /perl setpetscale #");
		DEFAULT_CHAT_FRAME:AddMessage("/perl usecpmeter /perl usecptext");
		DEFAULT_CHAT_FRAME:AddMessage("/perl bartextures /perl nobartextures");
		DEFAULT_CHAT_FRAME:AddMessage("/perl castparty on /perl castparty off");
		DEFAULT_CHAT_FRAME:AddMessage("/perl targettarget on /perl targettarget off");
	elseif (args[1]=="showhidehelp") then
		DEFAULT_CHAT_FRAME:AddMessage("Use /perl target show/hide");
		DEFAULT_CHAT_FRAME:AddMessage("For example, to hide the player level, use");
		DEFAULT_CHAT_FRAME:AddMessage("/perl playerlevel hide --make sure your only space is directly after 'perl'.");
		DEFAULT_CHAT_FRAME:AddMessage("Valid Targets:");
		DEFAULT_CHAT_FRAME:AddMessage("playerportrait targetportrait  targetdistance  partyicon   ");
		DEFAULT_CHAT_FRAME:AddMessage("playerlevel    targetlevel     partylevel  petlevel  pethappiness");
		DEFAULT_CHAT_FRAME:AddMessage("playerclass    targetmobtype   partypercent  castparty");
		DEFAULT_CHAT_FRAME:AddMessage("playerxp       targetmana      partydistance  partyinraid");
		DEFAULT_CHAT_FRAME:AddMessage("playerrank     targetrank      partynames  blizzardplayer");
		DEFAULT_CHAT_FRAME:AddMessage("targetclass    targetelite     arcanebar  oldcastbar petxp");
		DEFAULT_CHAT_FRAME:AddMessage("Note that /perl simpleframes or complexframes may override these settings.");
	else
		DEFAULT_CHAT_FRAME:AddMessage("Unknown command, type /perl basichelp");
	end
	Perl_OptionActions();
end