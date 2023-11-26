--[[

	File containing localized strings
	Test for French or German versions, defaults to English
	Version: <%version%>
	Revision: $Id: localization.lua,v 1.10 2005/07/12 11:26:51 islorgris Exp $

]]

if ( GetLocale() == "frFR" ) then
	-- French localized variables
	GATHERER_VERSION_WARNING="Nouvelle version de Gatherer d\195\169tect\195\169e, v\195\169rifiez le zone match.";

	-- TRADE NAME
	TRADE_HERBALISM="Herboriste"
	OLD_TRADE_HERBALISM="Herboriste"
	TRADE_MINING="Minage"

	-- strings for gather line in chat
	HERB_GATHER_STRING="Vous ex\195\169cutez Cueillette sur"
	ORE_GATHER_STRING="Vous ex\195\169cutez Minage sur"
	TREASURE_GATHER_STRING="Vous ex\195\169cutez Ouverture sur"

	GATHERER_REQUIRE="N\195\169cessite"
	GATHERER_NOSKILL="Requiert"

	-- Length of the string to keep the gather name
	HERB_GATHER_LENGTH=31
	HERB_GATHER_END=-2
	ORE_GATHER_LENGTH=27
	ORE_GATHER_END=-2
	TREASURE_GATHER_LENGTH=30
	TREASURE_GATHER_END=-2

	-- ore classes
	ORE_CLASS_VEIN   ="veine"
	ORE_CLASS_DEPOSIT="d\195\169p\195\180t"
	ORE_CLASS_LODE   ="filon"
	ORE_CLASS_SEAM   ="gisement"

	-- ore types
	ORE_COPPER     ="cuivre"
	ORE_TIN        ="\195\169tain"
	ORE_IRON       ="fer"
	ORE_SILVER     ="argent"
	ORE_TRUESILVER ="vrai-argent"
	ORE_GOLD       ="or"
	ORE_MITHRIL    ="mithril"
	ORE_THORIUM    ="thorium"
	ORE_RTHORIUM   ="thorium (riche)"

	-- herb types (ingame verified translations)
	HERB_PEACEBLOOM        ="pacifique"
	HERB_SILVERLEAF        ="feuillargent"
	HERB_EARTHROOT         ="terrestrine"
	HERB_MAGEROYAL         ="mage royal"
	HERB_BRIARTHORN        ="eglantine"
	HERB_STRANGLEKELP      ="etouffante"
	HERB_SWIFTTHISTLE      ="chardonnier"
	HERB_BRUISEWEED        ="doulourante"
	HERB_WILDSTEELBLOOM    ="aci\195\169rite sauvage"
	HERB_GRAVEMOSS         ="tombeline"
	HERB_KINGSBLOOD        ="sang-royal"
	HERB_LIFEROOT          ="viet\195\169rule"
	HERB_FADELEAF          ="p\195\162lerette"
	HERB_KHADGARSWHISKER   ="moustache de khadgar"
	HERB_FIREBLOOM         ="fleur de feu"
	HERB_GOLDTHORN         ="dor\195\169pine"
	HERB_PURPLELOTUS       ="lotus pourpre"
	HERB_BLINDWEED         ="aveuglette"
	HERB_SUNGRASS          ="soleillette"
	HERB_GHOSTMUSHROOM     ="champignon fant\195\180me"
	HERB_GOLDENSANSAM      ="sansam dor\195\169"
	HERB_GROMSBLOOD        ="gromsang"
	HERB_WILDVINE	       ="sauvageonne"
	HERB_WINTERSBITE       ="hivernale"
	HERB_ARTHASTEAR        ="larmes d'arthas"
	HERB_BLACKLOTUS        ="lotus noir"
	HERB_DREAMFOIL         ="feuiller\195\170ve"
	HERB_ICECAP            ="calot de glace"
	HERB_MOUNTAINSILVERSAGE="sauge argent\195\169e des montagnes"
	HERB_PLAGUEBLOOM       ="fleur de peste"

	-- treasure types
	-- Note: BARREL is a placeholder, chances are it's translated by the one corresponding to CASK.
	TREASURE_BOX        ="bo\195\174te"
	TREASURE_CHEST      ="coffre"
	TREASURE_CLAM       ="palourde"
	TREASURE_CRATE      ="caisse"
	TREASURE_BARREL     ="barrique"
	TREASURE_CASK       ="tonneau"
	-- UNTESTED
	TREASURE_FOOTLOCKER   = "cantine"
	TREASURE_BLOODHERO    = "sang des h\195\169ros"
	TREASURE_BLOODPETAL   = "bloodpetal"
	TREASURE_BLOODPETAL_G = "pousse de bloodpetal"
	TREASURE_POWERCRYST   = "cristal de puissance"
	TREASURE_UNGOROSOIL_G = "tas de poussi\195\168re"
	TREASURE_UNGOROSOIL   = "humus d'Un'Goro"

	TREASURE_REGEX = {
		[1] = " ([^ ]+)$",
		[2] = "^([^ ]+) ",
		[3] = "([^ ]+) ([^ ]+) ",
		[4] = "([^ ]+) ([^ ]+)$",
	};


	function Gatherer_FindOreType(input)
		local i,j, oreType, oreClass, oreArticle;
		local trinput=string.gsub(input, '\'', " ")

		if ( string.find(input, "riche") and string.find(input, "thorium") ) then 
			return ORE_RTHORIUM;
		end;
			
		i, j, oreClass, oreArticle, oreType = string.find(input, "([^ ]+) ([^ ]+) ([^ ]+)$");
		if (oreClass ~= ORE_CLASS_VEIN and oreClass ~= ORE_CLASS_DEPOSIT and oreClass ~= ORE_CLASS_LODE and oreClass ~= ORE_CLASS_SEAM) then
			i, j, oreClass, oreArticle, oreType = string.find(trinput, "^([^ ]+) ([^ ]+) ([^ ]+)");
		end
		if (oreType and oreClass and (oreClass == ORE_CLASS_VEIN or oreClass == ORE_CLASS_DEPOSIT or oreClass == ORE_CLASS_LODE or oreClass == ORE_CLASS_SEAM)) then
			return oreType;
		end
		return;
	end

	function Gatherer_FindTreasureType(input)
		local iconName;

		if ( string.find(input, TREASURE_UNGOROSOIL_G) ) then
			return TREASURE_UNGOROSOIL, TREASURE_UNGOROSOIL;
		end
			
		if (string.find(input, TREASURE_POWERCRYST) ) then
			return TREASURE_POWERCRYST, TREASURE_POWERCRYST;
		end

		if (string.find(input, TREASURE_BLOODPETAL_G) or string.find(input, TREASURE_BLOODPETAL)) then
			return TREASURE_BLOODPETAL, TREASURE_BLOODPETAL_G;
		end

		if (string.find(input, TREASURE_BLOODHERO) ) then
			return TREASURE_BLOODHERO, TREASURE_BLOODHERO;
		end

		for iconName in Gather_DB_IconIndex[0] do
			local index, treasure_regex, i, j, treasType;
			if ( input == iconName ) then
				return iconName;
			end
			
			if ( string.find(input, iconName) ) then
				for index, treasure_regex in TREASURE_REGEX do
					i,j, treasType = string.find(input, treasure_regex);
					if ( treasType and treasType == iconName ) then
						return iconName;
					end
					
					i,j, _, treasType = string.find(input, treasure_regex);
					if ( treasType and treasType == iconName ) then
						return iconName;
					end
				end
			end
		end
		return;
	end

	function Gatherer_ExtractItemFromTooltip()
		return string.lower(GameTooltipTextLeft1:GetText());
	end

elseif ( GetLocale() == "deDE" ) then
	-- German localized variables
	GATHERER_VERSION_WARNING="New Gatherer Version detected, check zone match.";

	-- TRADE NAME
	TRADE_HERBALISM="Kr\195\164uterkunde"
	OLD_TRADE_HERBALISM="Kr\195\164uterkunde"
	TRADE_MINING="Bergbau"

	-- strings for gather line in chat
	HERB_GATHER_STRING="Ihr f\195\188hrt Kr\195\164utersammeln auf" -- "Ihr führt Kräutersammeln auf Beulengras aus."
	ORE_GATHER_STRING="Ihr f\195\188hrt Bergbau auf"                -- "Ihr führt Bergbau auf Kupfervorkommen aus."
	TREASURE_GATHER_STRING="Ihr f\195\188hrt \195\150ffnen auf"     -- "Ihr führt Öffnen auf Ramponierte Truhe aus."

	-- Length of the string to keep the gather name
	HERB_GATHER_LENGTH=32
	HERB_GATHER_END=-6
	ORE_GATHER_LENGTH=24
	ORE_GATHER_END=-6
	TREASURE_GATHER_LENGTH=24
	TREASURE_GATHER_END=-6

	GATHERER_REQUIRE="Ben\195\182tigt"
	GATHERER_NOSKILL="Erfordert" 

	-- ore classes
	ORE_CLASS_VEIN   ="vorkommen"
	ORE_CLASS_DEPOSIT="ablagerung"

	-- ore types
	ORE_COPPER    ="kupfer"
	ORE_TIN       ="zinn"
	ORE_IRON      ="eisen"
	ORE_SILVER    ="silber"
	ORE_TRUESILVER="echtsilber"
	ORE_GOLD      ="gold"
	ORE_MITHRIL   ="mithril"
	ORE_THORIUM   ="thorium"
	ORE_RTHORIUM   ="thorium (kleines)"

	-- herb types
	HERB_ARTHASTEAR        ="arthas' tr\195\164nen"
	HERB_BLACKLOTUS        ="schwarzer lotus"
	HERB_BLINDWEED         ="blindkraut"
	HERB_BRIARTHORN        ="wilddornrose"
	HERB_BRUISEWEED        ="beulengras"
	HERB_DREAMFOIL         ="traumblatt"
	HERB_EARTHROOT         ="erdwurzel"
	HERB_FADELEAF          ="blassblatt"
	HERB_FIREBLOOM         ="feuerbl\195\188te"
	HERB_GHOSTMUSHROOM     ="geisterpilz"
	HERB_GOLDENSANSAM      ="goldener sansam"
	HERB_GOLDTHORN         ="golddorn"
	HERB_GRAVEMOSS         ="grabmoos"
	HERB_GROMSBLOOD        ="gromsblut"
	HERB_ICECAP            ="eiskappe"
	HERB_KHADGARSWHISKER   ="khadgars schnurrbart"
	HERB_KINGSBLOOD        ="k\195\182nigsblut"
	HERB_LIFEROOT          ="lebenswurz"
	HERB_MAGEROYAL         ="magusk\195\182nigskraut"
	HERB_MOUNTAINSILVERSAGE="bergsilberweisling"
	HERB_PEACEBLOOM        ="friedensblume"
	HERB_PLAGUEBLOOM       ="pestbl\195\188te"
	HERB_PURPLELOTUS       ="lila lotus"
	HERB_SILVERLEAF        ="silberblatt"
	HERB_STRANGLEKELP      ="w\195\188rgetang"
	HERB_SUNGRASS          ="sonnengras"
	HERB_SWIFTTHISTLE      ="flitzdistel"
	HERB_WILDSTEELBLOOM    ="wildstahlblume"
	HERB_WINTERSBITE       ="winterbiss"
	HERB_WILDVINE          ="wildranke"

	-- treasure types
	TREASURE_BOX        ="kiste"
	TREASURE_CHEST      ="truhe"
	TREASURE_CLAM       ="muschel"
	TREASURE_CRATE      ="kasten"
	TREASURE_BARREL     ="tonne"
	TREASURE_CASK       ="fass"
	-- UNTESTED
	TREASURE_FOOTLOCKER = "schlie\195\159kiste"
	TREASURE_UNGOROSOIL = "un'Goro erde"
	TREASURE_UNGOROSOIL_G = "erdhaufen"
	TREASURE_BLOODPETAL = "bloodpetal"
	TREASURE_BLOODPETAL_G = "bloodpetal-spr\195\182ssling"
	TREASURE_POWERCRYST = "machtkristall"
	TREASURE_BLOODHERO  = "blut von helden"

	TREASURE_REGEX = {
		[1] = " ([^ ]+)$",
		[2] = "^([^ ]+) ",
		[3] = "([^ ]+) ([^ ]+) ",
		[4] = "([^ ]+) ([^ ]+)$",
	};

	function Gatherer_FindOreType(input)
		local i,j, oreType, oreClass, oreTypeClass;

		if ( string.find(input, "kleines") and string.find(input, "thorium") ) then
			 return ORE_RTHORIUM;
		end;

		-- fix for ooze covered
		oreTypeClass = string.gsub(string.gsub(string.gsub(string.gsub(input, "br\195\188hschlammbedecktes ", ""), "kleines ", ""), "reiches ", "" ), "br\195\188hschlammbedeckte ", "" );


		if (string.find(oreTypeClass, ORE_CLASS_VEIN)) then
			oreType = strsub(oreTypeClass, 0, string.len(oreTypeClass)-string.len(ORE_CLASS_VEIN));
			oreClass = ORE_CLASS_VEIN;
		end
		if (string.find(oreTypeClass, ORE_CLASS_DEPOSIT)) then
			oreType = strsub(oreTypeClass, 0, string.len(oreTypeClass)-string.len(ORE_CLASS_DEPOSIT));
			oreClass = ORE_CLASS_DEPOSIT;
		end
		if( oreClass == ORE_CLASS_DEPOSIT and oreType == ORE_SILVER ) then
		       oreType = ORE_TRUESILVER;
		end
		if (oreType and oreClass and ((oreClass == ORE_CLASS_VEIN) or (oreClass == ORE_CLASS_DEPOSIT))) then
			return oreType;
		end
		return;
	end

	function Gatherer_FindTreasureType(in_input)
		local iconName, input;

		-- fix for clams
		input = string.gsub(in_input, "riesen", "");

		if ( string.find(input, TREASURE_UNGOROSOIL_G) or string.find(input, TREASURE_UNGOROSOIL)) then
			return TREASURE_UNGOROSOIL, TREASURE_UNGOROSOIL;
		end
			
		if (string.find(input, TREASURE_POWERCRYST) ) then
			return TREASURE_POWERCRYST, TREASURE_POWERCRYST;
		end

		if (string.find(input, TREASURE_BLOODPETAL_G) or string.find(input, TREASURE_BLOODPETAL)) then
			return TREASURE_BLOODPETAL, TREASURE_BLOODPETAL_G;
		end

		if (string.find(input, TREASURE_BLOODHERO) ) then
			return TREASURE_BLOODHERO, TREASURE_BLOODHERO;
		end

		for iconName in Gather_DB_IconIndex[0] do
			local index, treasure_regex, i, j, treasType;
			if ( input == iconName ) then
				return iconName;
			end
			
			if ( string.find(input, iconName) ) then
				for index, treasure_regex in TREASURE_REGEX do
					i,j, treasType = string.find(input, treasure_regex);
					if ( treasType and treasType == iconName ) then
						return iconName;
					end
					
					i,j, _, treasType = string.find(input, treasure_regex);
					if ( treasType and treasType == iconName ) then
						return iconName;
					end
				end
			end
		end
		return;
	end

	function Gatherer_ExtractItemFromTooltip()
		return string.lower(GameTooltipTextLeft1:GetText());	
	end

else
	-- English localized variables (default)
	GATHERER_VERSION_WARNING="New Gatherer Version detected, check zone match.";

	-- TRADE NAME
	TRADE_HERBALISM="Herbalism"
	OLD_TRADE_HERBALISM="Herbalism"
	TRADE_MINING="Mining"

	-- strings for gather line in chat
	HERB_GATHER_STRING="You perform Herb Gathering on"
	ORE_GATHER_STRING="You perform Mining on"
	TREASURE_GATHER_STRING="You perform Opening on"

	-- Length of the string to keep the gather name
	HERB_GATHER_LENGTH=31
	HERB_GATHER_END=-2
	ORE_GATHER_LENGTH=23
	ORE_GATHER_END=-2
	TREASURE_GATHER_LENGTH=24
	TREASURE_GATHER_END=-2

	GATHERER_REQUIRE="Requires"
	GATHERER_NOSKILL="Requires"

	-- ore classes
	ORE_CLASS_VEIN   ="vein"
	ORE_CLASS_DEPOSIT="deposit"

	-- ore types
	ORE_COPPER    ="copper"
	ORE_TIN       ="tin"
	ORE_IRON      ="iron"
	ORE_SILVER    ="silver"
	ORE_TRUESILVER="truesilver"
	ORE_GOLD      ="gold"
	ORE_MITHRIL   ="mithril"
	ORE_THORIUM   ="thorium"
	ORE_RTHORIUM   ="thorium (rich)"

	-- herb types 
	HERB_ARTHASTEAR        ="arthas' tears"
	HERB_BLACKLOTUS        ="black lotus"
	HERB_BLINDWEED         ="blindweed"
	HERB_BRIARTHORN        ="briarthorn"
	HERB_BRUISEWEED        ="bruiseweed"
	HERB_DREAMFOIL         ="dreamfoil"
	HERB_EARTHROOT         ="earthroot"
	HERB_FADELEAF          ="fadeleaf"
	HERB_FIREBLOOM         ="firebloom"
	HERB_GHOSTMUSHROOM     ="ghost mushroom"
	HERB_GOLDENSANSAM      ="golden sansam"
	HERB_GOLDTHORN         ="goldthorn"
	HERB_GRAVEMOSS         ="grave moss"
	HERB_GROMSBLOOD        ="gromsblood"
	HERB_ICECAP            ="icecap"
	HERB_KHADGARSWHISKER   ="khadgar's whisker"
	HERB_KINGSBLOOD        ="kingsblood"
	HERB_LIFEROOT          ="liferoot"
	HERB_MAGEROYAL         ="mageroyal"
	HERB_MOUNTAINSILVERSAGE="mountain silversage"
	HERB_PEACEBLOOM        ="peacebloom"
	HERB_PLAGUEBLOOM       ="plaguebloom"
	HERB_PURPLELOTUS       ="purple lotus"
	HERB_SILVERLEAF        ="silverleaf"
	HERB_STRANGLEKELP      ="stranglekelp"
	HERB_SUNGRASS          ="sungrass"
	HERB_SWIFTTHISTLE      ="swiftthistle"
	HERB_WILDSTEELBLOOM    ="wild steelbloom"
	HERB_WINTERSBITE       ="wintersbite"
	HERB_WILDVINE	       ="wildvine"

	-- treasure types
	TREASURE_BOX        ="box"
	TREASURE_CHEST      ="chest"
	TREASURE_CLAM       ="giant clam"
	TREASURE_CRATE      ="crate"
	TREASURE_BARREL     ="barrel"
	TREASURE_CASK       ="cask"
	-- UNTESTED
	TREASURE_FOOTLOCKER = "footlocker"
	TREASURE_UNGOROSOIL = "un'goro soil"
	TREASURE_UNGOROSOIL_G= "dirt pile"
	TREASURE_BLOODPETAL = "bloodpetal"
	TREASURE_BLOODPETAL_G = "bloodpetal sprout"
	TREASURE_POWERCRYST = "power crystal"
	TREASURE_BLOODHERO  = "blood of heroes"

	TREASURE_REGEX = {
		[1] = " ([^ ]+)$",
		[2] = "^([^ ]+)",
		[3] = "([^ ]+) ([^ ]+) ",
	};

	function Gatherer_FindOreType(input)
		local i,j, oreType, oreClass, oreTypeClass;
		
		if ( string.find(input, "rich") and string.find(input, "thorium") ) then 
			return ORE_RTHORIUM;
		end;
			
		i,j, oreType, oreClass = string.find(input, "([^ ]+) ([^ ]+)$");
		if (oreType and oreClass and ((oreClass == ORE_CLASS_VEIN) or (oreClass == ORE_CLASS_DEPOSIT))) then
			return oreType;
		end
		return;
	end

	function Gatherer_FindTreasureType(input)
		local iconName;

		if ( string.find(input, TREASURE_UNGOROSOIL_G) or string.find(input, TREASURE_UNGOROSOIL)) then
			return TREASURE_UNGOROSOIL, TREASURE_UNGOROSOIL;
		end
			
		if (string.find(input, TREASURE_POWERCRYST) ) then
			return TREASURE_POWERCRYST, TREASURE_POWERCRYST;
		end

		if (string.find(input, TREASURE_BLOODPETAL_G) or string.find(input, TREASURE_BLOODPETAL)) then
			return TREASURE_BLOODPETAL, TREASURE_BLOODPETAL_G;
		end

		if (string.find(input, TREASURE_BLOODHERO) ) then
			return TREASURE_BLOODHERO, TREASURE_BLOODHERO;
		end

		for iconName in Gather_DB_IconIndex[0] do
			local index, treasure_regex, i, j, treasType;
			if ( input == iconName ) then
				return iconName;
			end
			
			if ( string.find(input, iconName) ) then
				for index, treasure_regex in TREASURE_REGEX do
					i,j, treasType = string.find(input, treasure_regex);
					if ( treasType and treasType == iconName ) then
						return iconName;
					end
					
					i,j, _, treasType = string.find(input, treasure_regex);
					if ( treasType and treasType == iconName ) then
						return iconName;
					end
				end
			end
		end
		return;
	end

	function Gatherer_ExtractItemFromTooltip()
		return string.lower(GameTooltipTextLeft1:GetText());	
	end

end

