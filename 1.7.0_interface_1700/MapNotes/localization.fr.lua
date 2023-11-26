-- Version : French (by Vjeux)
-- Last Update : 02/17/2005

if ( GetLocale() == "frFR" ) then
	-- é: C3 A9  - \195\169
	-- ê: C3 AA  - \195\170
	-- à: C3 A0  - \195\160
	-- î: C3 AE  - \195\174
	-- è: C3 A8  - \195\168
	-- ë: C3 AB  - \195\171
	-- ô: C3 B4  - \195\180
	-- û: C3 BB  - \195\187
	-- â: C3 A2  - \195\162
	-- ç: C3 A7  - \185\167
	-- ': E2 80 99  - \226\128\153
	
	-- Interface Configuration
	MAPNOTES_WORLDMAPHELP = "Double clique pour ouvrir Map Notes";
	MAPNOTES_CLICK_ON_SECOND_NOTE = "|cFFFF0000Map Notes:|r Choisissez une Note pour tracer/effacer une ligne";
	
	MAPNOTES_NEW_MENU = "Map Notes";
	MAPNOTES_NEW_NOTE = "Cr\195\169er une Note";
	MAPNOTES_MININOTE_OFF = "D\195\169sactiver MiniNotes";
	MAPNOTES_OPTIONS = "Options";
	MAPNOTES_CANCEL = "Annuler";
	
	MAPNOTES_POI_MENU = "Map Notes";
	MAPNOTES_EDIT_NOTE = "Modifier Note";
	MAPNOTES_MININOTE_ON = "Utiliser comme MiniNote";
	MAPNOTES_SPECIAL_ACTIONS = "Actions sp\195\169ciales";
	MAPNOTES_SEND_NOTE = "Envoyer Note";
	
	MAPNOTES_SPECIALACTION_MENU = "Actions sp\195\169ciales";
	MAPNOTES_TOGGLELINE = "Cr\195\169er/Supprimer la ligne";
	MAPNOTES_DELETE_NOTE = "Supprimer la Note";
	
	MAPNOTES_EDIT_MENU = "Modifier une Note";
	MAPNOTES_SAVE_NOTE = "Sauvegarder";
	MAPNOTES_EDIT_TITLE = "Titre (obligatoire):";
	MAPNOTES_EDIT_INFO1 = "Ligne 1 (optionel):";
	MAPNOTES_EDIT_INFO2 = "Ligne 2 (optionel):";
	
	MAPNOTES_SEND_MENU = "Envoyer Note";
	MAPNOTES_SLASHCOMMAND = "Changer de Mode";
	MAPNOTES_SEND_COSMOSTITLE = "Envoyer Note:";
	MAPNOTES_SEND_COSMOSTIP = "Les Notes peuvent \195\170tre re\185\167ues par tous les utilisateurs de Map Notes\n(\226\128\153Envoyer au groupe\226\128\153 ne marche qu\226\128\153avec Sky!)";
	MAPNOTES_SEND_PLAYER = "Nom du joueur :";
	MAPNOTES_SENDTOPLAYER = "Envoyer au joueur";
	MAPNOTES_SENDTOPARTY = "Envoyer au groupe";
	MAPNOTES_SHOWSEND = "Changer de Mode";
	MAPNOTES_SEND_SLASHTITLE = "Obtenir la /commande :";
	MAPNOTES_SEND_SLASHTIP = "Selectionnez ceci et utilisez CTRL+C pour la copier dans le presse-papier. (Vous pouvez ensuite l\226\128\153envoyer sur un forum par exemple)";
	MAPNOTES_SEND_SLASHCOMMAND = "/Commande :";
	
	MAPNOTES_OPTIONS_MENU = "Options";
	MAPNOTES_SAVE_OPTIONS = "Sauvegarder";
	MAPNOTES_OWNNOTES = "Afficher les notes cr\195\169\195\169es par votre personnage.";
	MAPNOTES_OTHERNOTES = "Afficher les Notes re\185\167ues des autres joueurs.";
	MAPNOTES_HIGHLIGHT_LASTCREATED = "Mettre en \195\169vidence (en |cFFFF0000rouge|r) la derni\195\168re Note cr\195\169\195\169e.";
	MAPNOTES_HIGHLIGHT_MININOTE = "Mettre en \195\169vidence (en |cFF6666FFbleu|r) la Note selectionn\195\169e.";
	MAPNOTES_ACCEPTINCOMING = "Accepter les Notes des autres utilisateurs.";
	MAPNOTES_INCOMING_CAP = "Refuser une Note si vous avez moins de 5 Notes disponibles.";
	MAPNOTES_AUTOPARTYASMININOTE = "Membres du groupe en MiniNote."
	
	MAPNOTES_CREATEDBY = "Cr\195\169\195\169 par";
	MAPNOTES_CHAT_COMMAND_ENABLE_INFO = "Cette commande vous permet d\226\128\153ajouter une Note trouv\195\169e sur une page web par exemple.";
	MAPNOTES_CHAT_COMMAND_ONENOTE_INFO = "Autorise la r\195\169ception de la prochaine Note.";
	MAPNOTES_CHAT_COMMAND_MININOTE_INFO = "Mettre la prochaine Note re\185\167ue en tant que MiniNote (avec une copie sur la carte).";
	MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO = "Mettre la prochaine Note re\185\167ue en tant que MiniNote (seulement sur la minicarte).";
	MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO = "D\195\169sactiver MiniNote.";
	MAPNOTES_CHAT_COMMAND_MNTLOC_INFO = "Ajoute une position sur la carte.";
	MAPNOTES_CHAT_COMMAND_QUICKNOTE = "Cr\195\169er une Note \195\160 votre position actuelle.";
	MAPNOTES_CHAT_COMMAND_QUICKTLOC = "Cr\195\169er une Note \195\160 la position donn\195\169e.";
	MAPNOTES_MAPNOTEHELP = "Cette commande ne peut \195\170tre utilis\195\169e que pour ajouter une Note.";
	MAPNOTES_ONENOTE_OFF = "Autoriser une Note : D\195\169sactiv\195\169";
	MAPNOTES_ONENOTE_ON = "Autoriser une Note : Activ\195\169";
	MAPNOTES_MININOTE_SHOW_0 = "Prochaine Note en MiniNote: D\195\169sactiv\195\169";
	MAPNOTES_MININOTE_SHOW_1 = "Prochaine Note en MiniNote: Activ\195\169";
	MAPNOTES_MININOTE_SHOW_2 = "Prochaine Note en MiniNote: Seulement";
	MAPNOTES_DECLINE_SLASH = "Ajout impossible, trop de Notes dans la zone |cFFFFD100%s|r.";
	MAPNOTES_DECLINE_SLASH_NEAR = "Ajout impossible, Note trop proche de |cFFFFD100%q|r dans |cFFFFD100%s|r.";
	MAPNOTES_DECLINE_GET = "R\195\169ception impossible, trop de Notes dans la zone |cFFFFD100%s|r, ou la r\195\169ception de Notes est d\195\169sactiv\195\169e.";
	MAPNOTES_ACCEPT_SLASH = "Note ajout\195\169 dans |cFFFFD100%s|r.";
	MAPNOTES_ACCEPT_GET = "Vous avez re\185\167u la Note \226\128\153|cFFFFD100%s|r dans |cFFFFD100%s|r.";
	MAPNOTES_PARTY_GET = "|cFFFFD100%s|r utilis\195\169 comme Note de groupe dans |cFFFFD100%s|r.";
	MAPNOTES_DECLINE_NOTETONEAR = "|cFFFFD100%s|r a essay\195\169 de vous envoyer la Note |cFFFFD100%s|r, mais elle est trop proche de |cFFFFD100%q|r.";
	MAPNOTES_QUICKNOTE_NOTETONEAR = "Cr\195\169ation impossible. Vous \195\170tes trop proche de |cFFFFD100%s|r.";
	MAPNOTES_QUICKNOTE_NOPOSITION = "Cr\195\169ation impossible. Impossible de r\195\169cup\195\169rer votre position actuelle.";
	MAPNOTES_QUICKNOTE_DEFAULTNAME = "Quicknote";
	MAPNOTES_QUICKNOTE_OK = "Cr\195\169\195\169 dans |cFFFFD100%s|r.";
	MAPNOTES_QUICKNOTE_TOOMANY = "Il y a d\195\169ja trop de Notes dans |cFFFFD100%s|r.";
	MAPNOTES_QUICKTLOC_NOTETONEAR = "Cr\195\169ation impossible. Trop proche de |cFFFFD100%s|r.";
	MAPNOTES_QUICKTLOC_NOZONE = "Cr\195\169ation impossible. Impossible de r\195\169cup\195\169rer la zone actuelle.";
	MAPNOTES_QUICKTLOC_NOARGUMENT = "Utilisation: \226\128\153/quicktloc xx,yy [icone] [titre]\226\128\153.";
	MAPNOTES_SETMININOTE = "Utiliser comme MiniNote";
	MAPNOTES_THOTTBOTLOC = "Thottbot Position";
	MAPNOTES_PARTYNOTE = "Note de groupe";
	
	-- Drop Down Menu
	MAPNOTES_SHOWNOTES = "Show Notes";
	MAPNOTES_DROPDOWNTITLE = "Map Notes";
	MAPNOTES_DROPDOWNMENUTEXT = "Options";

	MapNotes_ZoneShift = {
		[0] = { [0] = 0 },
		[1] = { 1, 2, 20, 3, 4, 5, 6, 8, 9, 17, 7, 18, 14, 10, 11, 12, 13, 15, 16, 19, 21 },
		[2] = { 2, 3, 4, 17, 6, 11, 7, 8, 10, 16, 15, 12, 20, 13, 19, 1, 14, 9, 23, 21, 5, 22, 18, 24, 25 },
	};

	MapNotes_ZoneShift[1][0] = 0;
	MapNotes_ZoneShift[2][0] = 0;

	-- French names, thanks to Khisanth
	MapNotes_Const["Goulet des Warsong"] = { scale = 0.035, xoffset = 0.41757282062541, 
                         yoffset = 0.33126468682991, xscale = 12897.3, yscale = 8638.1 };
        MapNotes_Const["Vall\195\169e d\226\128\153Alterac"] = { scale = 0.035, xoffset = 0.41757282062541, 
                          yoffset = 0.33126468682991, xscale = 12897.3, yscale = 8638.1 };
end