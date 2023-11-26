local ThisRealmName = GetCVar("realmName");
RealmPlayers = { };
RealmGuilds = { };

function TooltipsFrameTarget_TargetFrame_Update()
end

--[[  Perl frame stuff
function UpdatePerlClassification_Elite()
	Perl_Target_BossFrame:Show();
	Perl_Target_CreatureBossText:SetText("Elite");
	Perl_Target_BossFrame:SetWidth(43);
	Perl_Target_TypeFramePlayer:Hide();
end

function UpdatePerlClassification_Rare()
	Perl_Target_BossFrame:Show();
	Perl_Target_CreatureBossText:SetText("Rare");
	Perl_Target_BossFrame:SetWidth(38);
	Perl_Target_TypeFramePlayer:Hide();
end
]]--

-- unithandle	= "player"	"target"
-- unittype		= "elite"	"rare" 	"raremob" 

function UniversalFrameHandler(unithandle,unittype)
	if( unithandle == "target" ) then
		if( unittype == "elite" ) then
			TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
		elseif( unittype == "rare" ) then
			TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
		elseif( unittype == "raremob" ) then
			TargetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-RareMob");
		end
	elseif( unithandle == "player" ) then
		if( unittype == "elite" ) then
			PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite");
		elseif( unittype == "rare" ) then
			PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare");
		elseif( unittype == "raremob" ) then
			PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-RareMob");
		end
	end
end

-- ARTHAS
function Realm_Arthas()
	RealmPlayers = { 
		["Mobscene"] = "elite";
		["Faredegyn"] = "elite";
		["Damagius"] = "elite";
		["Sketchy"] = "elite";
		["Dakkon"] = "elite";
	};
	RealmGuilds = { };
end

-- NATHREZIM
function Realm_Nathrezim()
	RealmPlayers = { 
		["Dakkan"] = "elite";
		["Exodius"] = "elite";
		["Arch"] = "elite";
		["Kilah"] = "elite";
		["Nightcrawlor"] = "elite";
		["Archen"] = "elite";
		["Archera"] = "elite";
	};
	RealmGuilds = {	
		["Ab Igne Inferiori"] = "rare";
	};
end

-- ELDRAD THALAS
function Realm_Eldrad_Thalas()
	RealmPlayers = { 
		["Bikk"] = "elite";
	};
	RealmGuilds = { };
end

-- DUNEMAUL
function Realm_Dunemaul()
	RealmPlayers = { 
		["Melady"] = "elite";
		["Dardas"] = "elite";
		["Xandarous"] = "elite";
	};
	RealmGuilds = { };
end

-- STORMSCALE
function Realm_Stormscale()
	RealmPlayers = { 
		["Valec"] = "elite";
		["Vilandra"] = "elite";
	};
	RealmGuilds = { };
end

-- MAL'GANIS
function Realm_MalGanis()
	RealmPlayers = { 
		["Zariz"] = "elite";
	};
	RealmGuilds = { };
end

-- DRAGONBLIGHT
function Realm_Dragonblight()
	RealmPlayers = { 
		["Kellen"] = "elite";
		["Nossferratus"] = "elite";
	};
	RealmGuilds = { };
end

-- MEDIVH
function Realm_Medivh()
	RealmPlayers = { 
		["Wizbang"] = "rare";
	};
	RealmGuilds = { };
end

-- STORMRAGE
function Realm_Stormrage()
	RealmPlayers = { 
		["Breasal"] = "rare";
	};
	RealmGuilds = { };
end

-- ARCHIMONDE
function Realm_Archimonde()
	RealmPlayers = { 
		["UFLA"] = "rare";
	};
	RealmGuilds = { };
end

-- ICECROWN
function Realm_Icecrown()
	RealmPlayers = { 
		["Eludeveren"] = "elite";
	};
	RealmGuilds = { };
end

-- BLOODSCALP
function Realm_Bloodscalp()
	RealmPlayers = { 
		["Canibis"] = "elite";
	};
	RealmGuilds = { };
end

-- PERENOLDE
function Realm_Perenolde()
	RealmPlayers = { 
		["Nytebandit"] = "elite";
	};
	RealmGuilds = { };
end

-- AGGRAMAR
function Realm_Aggramar()
	RealmPlayers = { 
		["Showdon"] = "elite";
	};
	RealmGuilds = { };
end

-- DEATHWING
function Realm_Deathwing()
	RealmPlayers = { 
		["Narconis"] = "elite";
	};
	RealmGuilds = { };
end

-- DAGGERSPINE
function Realm_Daggerspine()
	RealmPlayers = { 
		["Dyami"] = "elite";
	};
	RealmGuilds = { };
end

-- LIGHTNING'S BLADE
function Realm_LightningsBlade()
	RealmPlayers = { 
		["Zeeg"] = "elite";
		["Dakkan"] = "elite";
	};
	RealmGuilds = { 
		["Descension"] = "rare";
	};
end

-- SKULLCRUSHER
function Realm_Skullcrusher()
	RealmPlayers = { 
		["Reaver"] = "elite";
		["Wizzy"] = "elite";
	};
	RealmGuilds = { };
end

-- KHAZ'GOROTH
function Realm_Khazgoroth()
	RealmPlayers = { 
		["Nightslayer"] = "rare";
	};
	RealmGuilds = { };
end

-- AZJOL-NERUB
function Realm_AzjolNerub()
	RealmPlayers = { 
		["Valentyne"] = "rare";
	};
	RealmGuilds = { };
end


function TooltipsFrameTarget_UnitHandler(type)
	if( ThisRealmName == "Arthas" ) then
		Realm_Arthas();
	elseif( ThisRealmName == "Nathrezim" ) then
		Realm_Nathrezim();
	elseif( ThisRealmName == "Eldrad Thalas" ) then
		Realm_Eldrad_Thalas();
	elseif( ThisRealmName == "Dunemaul" ) then
		Realm_Dunemaul();
	elseif( ThisRealmName == "Stormscale" ) then
		Realm_Stormscale();
	elseif( ThisRealmName == "Mal'Ganis" ) then
		Realm_MalGanis();
	elseif( ThisRealmName == "Dragonblight" ) then
		Realm_Dragonblight();
	elseif( ThisRealmName == "Medivh" ) then
		Realm_Medivh();
	elseif( ThisRealmName == "Stormrage" ) then
		Realm_Stormrage();
	elseif( ThisRealmName == "Archimonde" ) then
		Realm_Archimonde();
	elseif( ThisRealmName == "Icecrown" ) then
		Realm_Icecrown();
	elseif( ThisRealmName == "Bloodscalp" ) then
		Realm_Bloodscalp();
	elseif( ThisRealmName == "Perenolde" ) then
		Realm_Perenolde();
	elseif( ThisRealmName == "Aggramar" ) then
		Realm_Aggramar();
	elseif( ThisRealmName == "Deathwing" ) then
		Realm_Deathwing();
	elseif( ThisRealmName == "Daggerspine" ) then
		Realm_Daggerspine();
	elseif( ThisRealmName == "Lightning's Blade" ) then
		Realm_LightningsBlade();
	elseif( ThisRealmName == "Skullcrusher" ) then
		Realm_Skullcrusher();
	elseif( ThisRealmName == "Azjol-Nerub" ) then
		Realm_AzjolNerub();
	elseif( ThisRealmName == "Khaz'goroth" ) then
		Realm_Khazgoroth();
	end
	
	TargetBorderType = RealmPlayers[UnitName("target")];
	if( TargetBorderType ) then
		UniversalFrameHandler("target", TargetBorderType);
	else
		TargetBorderType = RealmGuilds[GetGuildInfo("target")];
		if( TargetBorderType ) then
			UniversalFrameHandler("target", TargetBorderType);
		end
	end

end

function SetPlayerFrameOnload()
	PlayerBorderType = RealmPlayers[UnitName("player")];
	if( PlayerBorderType ) then
		UniversalFrameHandler("player", PlayerBorderType);
	else
		PlayerBorderType = RealmGuilds[GetGuildInfo("player")];
		if( PlayerBorderType ) then
			UniversalFrameHandler("player", PlayerBorderType);
		end
	end
end

function TooltipsFrameTarget_OnLoad()
	Sea.util.hook("TargetFrame_Update","TooltipsFrameTarget_TargetFrame_Update","after");
	Sea.util.hook("TooltipsBase_UnitHandler","TooltipsFrameTarget_UnitHandler","after");
	SetPlayerFrameOnload();
end