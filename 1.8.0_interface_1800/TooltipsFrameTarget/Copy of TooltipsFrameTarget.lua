local ThisRealmName = GetCVar("realmName");

function TooltipsFrameTarget_TargetFrame_Update()

end

function UpdatePerlClassification_Elite()
	-- TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
	Perl_Target_BossFrame:Show();
	Perl_Target_CreatureBossText:SetText("Elite");
	Perl_Target_BossFrame:SetWidth(43);
	Perl_Target_TypeFramePlayer:Hide();
end

function UpdatePerlClassification_Rare()
	-- TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
	Perl_Target_BossFrame:Show();
	Perl_Target_CreatureBossText:SetText("Rare");
	Perl_Target_BossFrame:SetWidth(38);
	Perl_Target_TypeFramePlayer:Hide();
end

function TooltipsFrameTarget_UnitHandler(type)
	if( ThisRealmName == "Arthas" ) then
		if(	UnitName("target") == "Mobscene" or 
			UnitName("target") == "Faredegyn" or 
			UnitName("target") == "Damagius" or 
			UnitName("target") == "Sketchy" ) then
			UpdatePerlClassification_Rare();
		end
	elseif( ThisRealmName == "Nathrezim" ) then
		if( UnitName("target") == "Dakkan" or 
			UnitName("target") == "Exodius" or 
			UnitName("target") == "Archen" or 
			UnitName("target") == "Arch" ) then
			UpdatePerlClassification_Elite();
		else
			if ( GetGuildInfo("target") == "Ab Igne Inferiori" ) then
				UpdatePerlClassification_Rare();
			end
		end
	elseif( ThisRealmName == "Eldrad Thalas" ) then
		if( UnitName("target") == "Bikk" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Dunemaul" ) then
		if( UnitName("target") == "Melady" or 
			UnitName("target") == "Dardas" or 
			UnitName("target") == "Xandarous" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Stormscale" ) then
		if( UnitName("target") == "Valec" or 
			UnitName("target") == "Vilandra" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Mal'Ganis" ) then
		if( UnitName("target") == "Zariz" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Dragonblight" ) then
		if( UnitName("target") == "Kellen" or 
			UnitName("target") == "Nossferratus" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Medivh" ) then
		if( UnitName("target") == "Wizbang" ) then
			UpdatePerlClassification_Rare();
		end
	elseif( ThisRealmName == "Stormrage" ) then
		if( UnitName("target") == "Breasal" ) then
			UpdatePerlClassification_Rare();
		end
	elseif( ThisRealmName == "Archimonde" ) then
		if( UnitName("target") == "UFLA" ) then
			UpdatePerlClassification_Rare();
		end
	elseif( ThisRealmName == "Icecrown" ) then
		if( UnitName("target") == "Eludeveren" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Bloodscalp" ) then
		if( UnitName("target") == "Canibis" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Perenolde" ) then
		if( UnitName("target") == "Nytebandit" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Aggramar" ) then
		if( UnitName("target") == "Showdon" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Deathwing" ) then
		if( UnitName("target") == "Narconis" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Daggerspine" ) then
		if( UnitName("target") == "Dyami" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Lightning's Blade" ) then
		if( UnitName("target") == "Zeeg" or 
			UnitName("target") == "Dakkan") then
			UpdatePerlClassification_Elite();
		else
			if ( GetGuildInfo("target") == "Descension" ) then
				UpdatePerlClassification_Rare();
			end
		end
	elseif( ThisRealmName == "Skullcrusher" ) then
		if( UnitName("target") == "Reaver" or 
			UnitName("target") == "Wizzy" ) then
			UpdatePerlClassification_Elite();
		end
	elseif( ThisRealmName == "Khaz'goroth" ) then
		if( UnitName("target") == "Nightslayer" ) then
			UpdatePerlClassification_Rare();
		end
	end
	
--[[ .: old school style :.

		if ( (UnitName("target") == "Dakkon" and ThisRealmName == "Arthas") or 
			(UnitName("target") == "Dakkan" and ThisRealmName == "Nathrezim") or 
			(UnitName("target") == "Archaedos" and ThisRealmName == "Arthas") or 
			(UnitName("target") == "Alliyah" and ThisRealmName == "Destromath") or 
			(UnitName("target") == "Mobscene" and ThisRealmName == "Arthas") or 
			(UnitName("target") == "Faredegyn" and ThisRealmName == "Arthas") or 
			(UnitName("target") == "Exodius" and ThisRealmName == "Arthas") or  
			(UnitName("target") == "Zariz" and ThisRealmName == "Mal'Ganis") or  
			(UnitName("target") == "Valec" and ThisRealmName == "Stormscale") or 
			(UnitName("target") == "Vilandra" and ThisRealmName == "Stormscale") or 
			(UnitName("target") == "Kellen" and ThisRealmName == "Dragonblight") or 
			(UnitName("target") == "Rayni" and ThisRealmName == "Arthas") ) then 
			TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
		else
			if ( (GetGuildInfo("target") == "Night Fall" and ThisRealmName == "Arthas") or
				(UnitName("target") == "Breasal" and ThisRealmName == "Stormrage") or 
				(UnitName("target") == "Wizbang" and ThisRealmName == "Medivh") ) then 
				TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
			end
		end
		
]]--

end

function TooltipsFrameTarget_OnLoad()
	Sea.util.hook("TargetFrame_Update","TooltipsFrameTarget_TargetFrame_Update","after");
	Sea.util.hook("TooltipsBase_UnitHandler","TooltipsFrameTarget_UnitHandler","after");
end