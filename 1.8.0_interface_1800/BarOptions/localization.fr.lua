--[[
--	BarOptions Localization
--		"English Localization"
--	
--	English By: Mugendai
--	
--	$Id: localization.fr.lua 2476 2005-09-18 12:43:06Z mugendai $
--	$Rev: 2476 $
--	$LastChangedBy: mugendai $ Sasmira
--	$Date: 2005-09-18 07:43:06 -0500 (Sun, 18 Sep 2005) $ 04/02/2005
--]]

if ( GetLocale() == "frFR" ) then
	--------------------------------------------------
	--
	-- Binding Strings
	--
	--------------------------------------------------
	BINDING_HEADER_INSTANTACTIONBAR = "Instant Action Bar Pages";
	
	BINDING_NAME_INSTANTACTIONBAR1 = "Instant Action Page 1";
	BINDING_NAME_INSTANTACTIONBAR2 = "Instant Action Page 2";
	BINDING_NAME_INSTANTACTIONBAR3 = "Instant Action Page 3";
	BINDING_NAME_INSTANTACTIONBAR4 = "Instant Action Page 4";
	BINDING_NAME_INSTANTACTIONBAR5 = "Instant Action Page 5";
	BINDING_NAME_INSTANTACTIONBAR6 = "Instant Action Page 6";
	
	--------------------------------------------------
	--
	-- Hotkey Constant
	--
	--------------------------------------------------
	--List of shortened names of hotkeys
	BO_SHORTHOTKEYS = {
		["Shift"] = "S",
		["Alt"] = "A",
		["Ctrl"] = "C",
		["Control"] = "C",
		["shift"] = "S",
		["alt"] = "A",
		["ctrl"] = "C",
		["control"] = "C",
		["SHIFT"] = "S",
		["ALT"] = "A",
		["CTRL"] = "C",
		["CONTROL"] = "C",
		["Num Pad"] = "KP"
	};
	
	--------------------------------------------------
	--
	-- UI Strings
	--
	--------------------------------------------------
	BAROPTIONS_CONFIG_SECTION = "Options des Barres";
	BAROPTIONS_CONFIG_SECTION_INFO = "Configure divers options pour les divers barres.";
	BAROPTIONS_CONFIG_BAR_HEADER = "Options des Barres";
	BAROPTIONS_CONFIG_BAR_HEADER_INFO = "Options li\195\169es au comportement de toutes les barres.";
	BAROPTIONS_CONFIG_DEFAULTSETUP = "Configuration par D\195\169faut";
	BAROPTIONS_CONFIG_DEFAULTSETUP_NAME = "D\195\169faut";
	BAROPTIONS_CONFIG_DEFAULTSETUP_INFO = "Configure toutes les options et positions les barres lat\195\169rales.";
	BAROPTIONS_CONFIG_SIDEBARSETUP = "Configuration des Barres Lat\195\169rales";
	BAROPTIONS_CONFIG_SIDEBARSETUP_NAME = "Barres Lat\195\169rales";
	BAROPTIONS_CONFIG_SIDEBARSETUP_INFO = "Configure les options et la positions des Barres Lat\195\169rales dans le Style Barres Lat\195\169rales classiques.";
	BAROPTIONS_CONFIG_ALTERNATEIDS = "Utiliser un ID particulier";
	BAROPTIONS_CONFIG_ALTERNATEIDS_INFO = "Si activ\195\169, les multi barres utiliseront un ID identique \195\160 celui des anciennes barres de Cosmos";
	BAROPTIONS_CONFIG_TURNPAGES = "Changer de Pages";
	BAROPTIONS_CONFIG_TURNPAGES_INFO = "Si activ\195\169, la multi barre inf\195\169rieure Gauche changera de pages quand la barre principale changera de pages. ID particulier doit \195\170tre activ\195\169.";
	BAROPTIONS_CONFIG_GROUPPAGES = "Grouper les Pages";
	BAROPTIONS_CONFIG_GROUPPAGES_INFO = "Si activ\195\169, Les boutons de Gauche de la multi barre et la barre principale agiront comme si ils partagent 3 pages de 24 boutons. ID particulier doit \195\170tre activ\195\169.";
	BAROPTIONS_CONFIG_STANCEBAR = "Position de la Barre Inf\195\169rieure";
	BAROPTIONS_CONFIG_STANCEBAR_INFO = "Si activ\195\169, la multi barre inf\195\169rieure changera d\'ID.";
	BAROPTIONS_CONFIG_HIDEEMPTY = "Cacher les boutons vides";
	BAROPTIONS_CONFIG_HIDEEMPTY_INFO = "Si activ\195\169, les boutons vides sur des barres seront cach\195\169s.";
	BAROPTIONS_CONFIG_HOTKEY_HEADER = "Raccourcis";
	BAROPTIONS_CONFIG_HOTKEY_HEADER_INFO = "Options li\195\169es au texte sur les Raccourcis des boutons d\'action.";
	BAROPTIONS_CONFIG_HIDEKEYS = "Cacher les Raccourcis";
	BAROPTIONS_CONFIG_HIDEKEYS_INFO = "Si activ\195\169, tous les raccourcis sur les boutons d\'action seront cach\195\169s.";
	BAROPTIONS_CONFIG_MULTIKEYS = "Activer les Raccourcis des Multi Barres";
	BAROPTIONS_CONFIG_MULTIKEYS_INFO = "Si activ\195\169, tous les raccourcis sur les multi barres seront visibles.";
	BAROPTIONS_CONFIG_SHORTKEYS = "Ecourter le texte des Raccourcis";
	BAROPTIONS_CONFIG_SHORTKEYS_INFO = "Si activ\195\169, le texte des raccourcis sera \195\169court\195\169. Exemple : 'Shift-1' deviendra 'S-1'";
	BAROPTIONS_CONFIG_HIDEKEYMOD = "Cacher le texte des Raccourcis";
	BAROPTIONS_CONFIG_HIDEKEYMOD_INFO = "Si activ\195\169, le texte des fonctions CTRL ALT et SHIFT sur les raccourcis sera cach\195\169.";
	BAROPTIONS_CONFIG_ART_HEADER = "Image de fond des Barres";
	BAROPTIONS_CONFIG_ART_HEADER_INFO = "Options li\195\169es \195\160 l\'affichage d\'une image de fond des diff\195\169rentes barres.";
	BAROPTIONS_CONFIG_MAINART = "Image de fond de la Barre Principale";
	BAROPTIONS_CONFIG_MAINART_INFO = "Si activ\195\169, les images des Dragons en fin de Barre seront affich\195\169s.";
	BAROPTIONS_CONFIG_BLART = "Image de fond de la Barre Inf\195\169rieure Gauche";
	BAROPTIONS_CONFIG_BLART_INFO = "Si activ\195\169, l\'image de fond de la Multi Barre Inf\195\169rieure Gauche sera visible.";
	BAROPTIONS_CONFIG_BRART = "Image de fond de la Barre Inf\195\169rieure Droite";
	BAROPTIONS_CONFIG_BRART_INFO = "Si activ\195\169, l\'image de fond de la Multi Barre Inf\195\169rieure Droite sera visible.";
	BAROPTIONS_CONFIG_RART = "Image de fond de la Barre Droite";
	BAROPTIONS_CONFIG_RART_INFO = "Si activ\195\169, l\'image de fond de la Multi Barre Droite sera visible.";
	BAROPTIONS_CONFIG_LART = "Image de fond de la Barre Gauche";
	BAROPTIONS_CONFIG_LART_INFO = "Si activ\195\169, l\'image de fond de la Multi Barre Gauche sera visible.";
	BAROPTIONS_CONFIG_COUNT_HEADER = "Nombre de Boutons";
	BAROPTIONS_CONFIG_COUNT_HEADER_INFO = "Configure le nombre de boutons sur les multi barres.";
	BAROPTIONS_CONFIG_COUNT_NAME = "Boutons";
	BAROPTIONS_CONFIG_COUNT_SUFFIX = "";
	BAROPTIONS_CONFIG_BLCOUNT = "Boutons sur Barre Inf\195\169rieure Gauche";
	BAROPTIONS_CONFIG_BLCOUNT_INFO = "Nombre de boutons visible sur la Multi Barre Inf\195\169rieure Gauche";
	BAROPTIONS_CONFIG_BRCOUNT = "Boutons sur Barre Inf\195\169rieure Droite";
	BAROPTIONS_CONFIG_BRCOUNT_INFO = "Nombre de boutons visible sur la Multi Barre Inf\195\169rieure Droite";
	BAROPTIONS_CONFIG_RCOUNT = "Boutons sur Barre Droite";
	BAROPTIONS_CONFIG_RCOUNT_INFO = "Nombre de boutons visible sur la Multi Barre Droite";
	BAROPTIONS_CONFIG_LCOUNT = "Boutons sur Barre Gauche";
	BAROPTIONS_CONFIG_LCOUNT_INFO = "Nombre de boutons visible sur la Multi Barre Gauche";
	BAROPTIONS_CONFIG_RANGECOLOR_HEADER = "Hors de Port\195\169e";
	BAROPTIONS_CONFIG_RANGECOLOR_HEADER_INFO = "Options li\195\169es \195\160 la couleur d\'une cible Hors de Port\195\169e.";
	BAROPTIONS_CONFIG_RANGECOLOR = "Couleur d\'une Cible Hors de Port\195\169e";
	BAROPTIONS_CONFIG_RANGECOLOR_INFO = "La Couleur du bouton d\'action lorsqu\'une cible est Hors de Port\195\169e.";
	BAROPTIONS_CONFIG_RANGECOLORRED = "Couleur : Rouge";
	BAROPTIONS_CONFIG_RANGECOLORRED_INFO = "La quantit\195\169 de Rouge visible lorsqu\'une cible est Hors de Port\195\169e.";
	BAROPTIONS_CONFIG_RANGECOLORGREEN = "Couleur : Verte";
	BAROPTIONS_CONFIG_RANGECOLORGREEN_INFO = "La quantit\195\169 de Vert visible lorsqu\'une cible est Hors de Port\195\169e.";
	BAROPTIONS_CONFIG_RANGECOLORBLUE = "Couleur : Bleue";
	BAROPTIONS_CONFIG_RANGECOLORBLUE_INFO = "La quantit\195\169 de Bleu visible lorsqu\'une cible est Hors de Port\195\169e.";
	BAROPTIONS_CONFIG_RANGECOLOR_NAME = "Intensit\195\169";
	BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX = "%";
	
	BAROPTIONS_CONFIG_STANCE_HEADER = "Configuration de la Position des Pages";
	BAROPTIONS_CONFIG_STANCE_HEADER_INFO = "Permet de configurer la Page de boutons utilis\195\169e par position";
	BAROPTIONS_CONFIG_STANCE_NAME = "Page";
	BAROPTIONS_CONFIG_STANCE_SUFFIX = "";
	BAROPTIONS_CONFIG_CUSTOMSTANCES = "Activer la configuration de la Position des Pages";
	BAROPTIONS_CONFIG_CUSTOMSTANCES_INFO = "Si activ\195\169, la configuration d\195\169termine quelle page de boutons \195\160 employer par position.";
	BAROPTIONS_CONFIG_STANCE0 = "Aucune Position de Page";
	BAROPTIONS_CONFIG_STANCE0_INFO = "Indique la page \195\160 employer lorsqu\'il n\'y a pas de position particuli\195\168re.";
	BAROPTIONS_CONFIG_STANCE1 = "Position Page 1 (Combat/chat/furtif)";
	BAROPTIONS_CONFIG_STANCE1_INFO = "Indique la page 1 \195\160 employer lorsqu\'il y a une position particuli\195\168re.";
	BAROPTIONS_CONFIG_STANCE2 = "Position Page 2 (D\195\169fense)";
	BAROPTIONS_CONFIG_STANCE2_INFO = "Indique la page 2 \195\160 employer lorsqu\'il y a une position particuli\195\168re";
	BAROPTIONS_CONFIG_STANCE3 = "Position Page 3(Berserker/Ours)";
	BAROPTIONS_CONFIG_STANCE3_INFO = "Indique la page 3 \195\160 employer lorsqu\'il y a une position particuli\195\168re.";
	
	--------------------------------------------------
	--
	-- Chat Strings
	--
	--------------------------------------------------
	BAROPTIONS_CHAT_DEFAULTSETUP = "Configuration par d\195\69faut des Options des Barres charg\195\169";
	BAROPTIONS_CHAT_SIDEBARSETUP = "Configuration des Barres Lat\195\69rales charg\195\169";
	BAROPTIONS_CHAT_ALTERNATEIDS = "Utiliser un ID particulier";
	BAROPTIONS_CHAT_GROUPPAGES = "Groupe Pages";
	BAROPTIONS_CHAT_STANCEBAR = "Position de la Barre Inf\195\169rieure Gauche";
	BAROPTIONS_CHAT_HIDEEMPTY = "Cacher les boutons vides";
	BAROPTIONS_CHAT_HIDEKEYS = "Cacher les Raccourcis";
	BAROPTIONS_CHAT_MULTIKEYS = "Activer les Raccourcis des Multi Barres";
	BAROPTIONS_CHAT_SHORTKEYS = "Ecourter le texte des Raccourcis";
	BAROPTIONS_CHAT_HIDEKEYMOD = "Cacher le texte des Raccourcis";
	BAROPTIONS_CHAT_MAINART = "Image de fond de la Barre Principale";
	BAROPTIONS_CHAT_BLART = "Image de fond de la Barre Inf\195\169rieure Gauche";
	BAROPTIONS_CHAT_BRART = "Image de fond de la Barre Inf\195\169rieure Droite";
	BAROPTIONS_CHAT_RART = "Image de fond de la Barre Droite";
	BAROPTIONS_CHAT_LART = "Image de fond de la Barre Gauche";
	BAROPTIONS_CHAT_BLCOUNT = "Boutons de la Barre Inf\195\169rieure Gauche";
	BAROPTIONS_CHAT_BRCOUNT = "Boutons de la Barre Inf\195\169rieure Droite";
	BAROPTIONS_CHAT_RCOUNT = "Boutons de la Barre Droite";
	BAROPTIONS_CHAT_LCOUNT = "Boutons de la Barre Gauche";
	BAROPTIONS_CHAT_RANGECOLOR_RANGE = " Doit \195\170tre entre 1 et 0, comme 0.2";
	BAROPTIONS_CHAT_RANGECOLOR = "Couleur d\'une Cible Hors de Port\195\169e";
	BAROPTIONS_CHAT_RANGECOLORRED = "Couleur Rouge r\195\69gl\195\169e \195\160";
	BAROPTIONS_CHAT_RANGECOLORGREEN = "Couleur Verte r\195\69gl\195\169e \195\160";
	BAROPTIONS_CHAT_RANGECOLORBLUE = "Couleur Bleue r\195\69gl\195\169e \195\160";
	BAROPTIONS_CHAT_CUSTOMSTANCES = "Activer la configuration de la Position des Pages";
	BAROPTIONS_CHAT_STANCE_RANGE = " Doit \195\170tre entre 1 et 10";
	BAROPTIONS_CHAT_STANCE0 = "Aucune Position de Page()";
	BAROPTIONS_CHAT_STANCE1 = "Position Page 1 (Combat/chat/furtif)";
	BAROPTIONS_CHAT_STANCE2 = "Position Page 2 Page(D\195\169fense)";
	BAROPTIONS_CHAT_STANCE3 = "Position Page 3(Berserker/Ours)";
end