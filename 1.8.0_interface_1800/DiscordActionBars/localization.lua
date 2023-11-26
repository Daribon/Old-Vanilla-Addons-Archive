DAB_VERSION = "2.36";

DAB_ARROW_LEFT = "<";
DAB_ARROW_RIGHT = ">";
DAB_ATTACKING = nil;
DAB_BAR = 1;
DAB_BORDERS = { "_Left", "_Right", "_Top", "_Bottom" };
DAB_COPYBAR = nil;
DAB_DRAGGING_UNLOCKED = nil;
DAB_MACROEVENTS = {};
DAB_FLOATER = nil;
DAB_FLOATER_COUNT = nil;
DAB_SHOWWHENUSABLE = {};
DAB_FORMBARINMAINBAR = nil;
DAB_FREE_BUTTONS = {};
DAB_INCOMBAT = nil;
DAB_INDEX = nil;
DAB_INITIALIZED = nil;
DAB_KB_MAP = {};
DAB_LAST_FORM = nil;
DAB_LAST_FORM2 = nil;
DAB_MAINBAR = nil;
DAB_MENU_FORMS = {};
DAB_MENU_SAVEDSETTINGS = {};
DAB_NUMBER_OF_BARS = 10;
DAB_OTHERBAR = nil;
DAB_REGEN_ENABLED = true;
DAB_SETTINGS_INDEX = nil;
DAB_SHOWING_EMPTY = nil;
DAB_SHOWING_IDS = nil;
DAB_UNSWAP = nil;

DAB_BAR_COLOR = { "|cFF00FF00", "|cFFFFAA00", "|cFF5555FF", "|cFFFF0000", "|cFFFF00FF", "|cFF00FFFF", "|cFFDDDDDD", "|cFFAA00FF", "|cFF00FFAA", "|cFFFF00AA" }

--**************************************
--*      TEXT TO TRANSLATE    *
--**************************************
DAB_TITLE = "Discord Action Bars v"..DAB_VERSION.."\nhttp://www.discordmods.com";
DAB_FREEBUTTONSLABEL = "Free Buttons";
DAB_SELECTFLOATER = "Select a Floater to Edit";
DAB_ENTERMACROTEXT = "Enter Macro Code Below:";
DAB_LOAD = "LOAD";
DAB_SAVE = "SAVE";
DAB_DELETE = "DELETE";
DAB_NUDGE = "Nudge:";

DAB_TEXT = {
	ActionBarPageChanged = "Action Bar Page Changed ",
	ActionBarUpdateCooldown = "Action Bar Update Cooldown",
	AnchorButton = "Attach to Button",
	AnchorFrame = "Attach to Frame",
	AnchorPoint = "Attach Point",
	AnchorTo = "Attach To",
	AutoAttack = "Auto-Attack When Using an Action",
	Background = "Background",
	BackgroundAlpha = "Background Alpha",
	BackgroundColor = "Background Color",
	BackgroundPadding = "Padding",
	BackgroundStyle = "Background Style",
	BackgroundTexture = "Background Texture",
	Bag = "Bag Bar",
	BagUpdate = "Bag Contents Changed",
	BagOffsetX = "Bag Offset X",
	BagOffsetY = "Bag Offset Y",
	Bar = "Bar ",
	BarKeybindings = "BUTTON KEYBINDINGS",
	BarOptions = "BAR $n OPTIONS",
	BarToEdit = "Bar To Edit: ",
	BonusActionbar = "You Shapeshift ",
	BorderAlpha = "Border Alpha",
	BorderColor = "Border Color",
	BorderTexture = "Border Texture",
	Button = "Button ",
	ButtonAlpha = "Button Transparency",
	ButtonBorderAlpha = "Button Border Alpha",
	ButtonBorderColor = "Button Border Color",
	ButtonBorderPadding = "Button Border Padding",
	ButtonRows = "Button Rows",
	ButtonScale = "Button Scale",
	ButtonSize = "Button Size",
	ButtonSpacingH = "Horizontal Spacing",
	ButtonSpacingV = "Vertical Spacing",
	CCFontSize = "Cooldown Font Size",
	ChooseEvent = "Choose An Event: ",
	CollapseEmpty = "Collapse Empty Buttons",
	ControlBox= "Control Box",
	ControlBoxBindings = "Control Boxes",
	ConvertToFloater = "Convert Free Button To Floater",
	CooldownCountThreshold = "Cooldown Count Threshold",
	Copy = "COPY",
	CopyBarSettings = "Copy Settings From Bar",
	CopyBGSettings = "Copy Settings From Background of Bar",
	CopyControlBoxSettings = "Copy Settings From Control Box",
	CopyLabelSettings = "Copy Settings From Label of Bar",
	DefaultSettingsLoaded = "Default settings loaded.",
	DefaultTarget = "Default Target",
	DeleteThisFloater = "Delete This Floater",
	DisableTooltips = "Disable Action Button Tooltips",
	DoNotShowCooldownCountSec = "Don't show s for seconds",
	Druid = "Druid",
	DuelFinished = "Duel Finished ",
	DuelRequested = "Duel Requested ",
	DynamicKeybindings = "Dynamic Keybindings",
	Events = "On Event Macros",
	Floater = "Floater ",
	Floaters = "Floaters",
	FloatersHeader = "FLOATER OPTIONS",
	Force = "Force",
	Form = "Shapeshift Bar",
	GhostBar = "Ghost Bar",
	Height = "Height",
	Hide = "Hide",
	HideDynamicKeybindings = "Hide Dynamic Keybindings Text",
	HideEmpty = "Hide Empty Buttons",
	HideFloaterOnClick = "Hide When Clicked",
	HideIDs = "Hide Button IDs",
	HideKeybindings = "Hide Keybindings Text",
	HideLabels = "Hide Labels",
	HideOnClick = "Hide When an Action Button is Pressed",
	HideOtherBars = "Hide Other Bars On Click",
	Humanoid = "Humanoid",
	Label = "Label",
	Layout = "Layout",
	LoadCustomSettings = "Load Custom Settings",
	LoadDefaultSettings = "Load Default Settings",
	LoadSettings = "Load Settings: ",
	LockButtons = "Lock Buttons",
	LockDragging = "Lock Dragging",
	MacroOnClick = "Perform Macro On Click",
	MacrosOnEvents = "DEFINE MACROS TO RUN ON EVENTS",
	MainBar = "Main Bar for Shapeshifting",
	MainBarWarning = "This bar is set as the Main Bar.  You cannot set the Main Bar to use a specific shapeshift form.",
	Menu = "Menu Bar",
	MiddleClickBar = "Middle-click Bar",
	MiddleClickButton = "Middle-click Button",
	MiscOptions = "Misc Options",
	MiscOptionsHeader = "MISCELLANEOUS OPTIONS",
	ModifyCooldownByUIScale = "Modify Cooldown's Scale by the UI's Scale",
	MouseoverBGColor = "Mouseover Background Color",
	MouseoverTextColor = "Mouseover Text Color",
	None = "None",
	NumButtons = "Num Buttons",
	NumButtonsHeader = "SET NUMBER OF BUTTONS PER BAR",
	OffsetX = "X Offset",
	OffsetY = "Y Offset",
	OneTrue = "Only One Condition Must Be True",
	OnlyClickedButtons = "Only show count on clicked buttons",
	OnUpdate = "OnUpdate",
	OptionsScale = "Options Window Scale",
	OtherBars = "Other Bars",
	OtherBarsHeader = "OTHER BARS OPTIONS",
	OutOfManaColor = "Not Enough Mana Color",
	OutOfRangeColor = "Out of Range Color",
	Paladin = "Paladin",
	PartyChanged = "Party Members Changed ",
	Pet = "Pet Action Bar",
	PetAttackStart = "Pet Attack Start ",
	PetAttackStop = "Pet Attack Stop ",
	PlayerAlive = "You're Returned to Life ",
	PlayerDead = "You Die ",
	PlayerEnterCombat = "You Enter Attack Mode",
	PlayerLeaveCombat = "You Leave Attack Mode",
	PlayerRegenDisabled = "Your Health Regen is Disabled",
	PlayerRegenEnabled = "Your Health Regen is Enabled",
	PlayerTargetChanged = "You Change Targets",
	QuickLoad = "Quick Load",
	QuickSave = "Quick Save",
	RaidMembersChanged = "Raid Members Changed ",
	RecolorBorder = "Recolor A Button's Border Instead of Its Icon",
	RecolorOnMouseover = "Change Background Color on Mouseover",
	RecolorTextOnMouseover = "Change Text Color on Mouseover",
	RightClickBar = "Right-click Bar",
	RightClickButton = "Right-click Button",
	Rogue = "Rogue",
	SaveSettings = "Save Settings: ",
	SetAllBarsToZero = "Set All Bars to 0",
	SetDynamicKeybindingsTo = "Set Dynamic Keybindings to",
	SettingsDeleted = "Settings deleted.",
	SettingsLoaded = "New settings loaded.",
	SettingsSaved = "Settings saved successfully.",
	ShapeshiftForm = "Use for Shapeshift Form",
	ShowBarOnClick = "Show Bar On Click",
	ShowBarOnMouseover = "Show Bar On Mouseover",
	ShowBarsSetToKeypress = "Show Bars and Floaters Set to Show on Keypress",
	ShowBottomBorder = "Show Bottom Border",
	ShowCooldownCount = "Show a Text Display of Cooldown Time",
	ShowDefaultArt = "Show Default Main Bar Art (requires a relog)",
	ShowForFriendly = "Show For Friendly Target",
	ShowForHostile = "Show For Hostile Target",
	ShowForShapeshiftForm = "Show For Shapeshift Form",
	ShowGhostBar = "Show Ghost Bar",
	ShowIDs = "Show Button IDs",
	ShowInCombat = "Show When In Combat",
	ShowLabels = "Show Labels",
	ShowLeftBorder = "Show Left Border",
	ShowOnBarMouseover = "Show When Mouse Moves Over the Bar",
	ShowOutOfCombat = "Show When Out Of Combat",
	ShowRightBorder = "Show Right Border",
	ShowTopBorder = "Show Top Border",
	ShowXPBar = "Show XP Bar",
	ShowWhileKeyIsPressed = "Show While A Key Is Pressed",
	SpellcastDelayed = "Your Spellcast is Delayed ",
	SpellcastFailed = "Your Spellcast Failed ",
	SpellcastInterrupted = "Your Spellcast was Interrupted ",
	SpellcastStart = "You Start Casting a Spell ",
	SpellcastStop = "You Stop Casting a Spell ",
	Text = "Text",
	TextAlpha = "Text Alpha",
	TextColor = "Text Color",
	TextSize = "Text Size",
	Timeout = "Time To Hide on Mouseout",
	ToggleButtonIDs = "Toggle Button IDs",
	ToggleButtonLock = "Toggle Buttonlock",
	ToggleDragging = "Toggle Dragging",
	ToggleOptions = "Show/Hide Options",
	Undefined = "Undefined",
	UnitAura = "Unit Buffs/Debuffs Changed ",
	UnitCombat = "Unit Combat Events",
	UnitComboPoints = "Your Combo Points Changed",
	UnitEnergy = "Unit's Energy Changed ",
	UnitFocus = "Unit's Focus Changed ",
	UnitHealth = "Unit's Health Changed ",
	UnitMana = "Unit's Mana Changed ",
	UnitPet = "Unit's Pet Changed ",
	UnitRage = "Unit's Rage Changed ",
	UnitSpellmiss = "Unit Resisted a Spell ",
	UnlockButtons = "Unlock Buttons",
	UnlockDragging = "Unlock Dragging",
	UnusableColor = "Action Unusable Color",
	UseOnDown = "Use Action on Keybinding Down",
	VariablesLoaded = "Variables Loaded",
	Warrior = "Warrior",
	WhenIShapeshift = "When I Shapeshift",
	Width = "Width",
	YouHitMessage = "'You Hit' Chat Message",
	YouMissMessage = "'You Miss' Chat Message",
};

DAB_HELP_TEXT = {
	"Discord Action Bars Slash Commands",
	"------------------------------------------------------",
	"/dab - toggle the options window",
	"/dab barshow # - show bar #",
	"/dab barhide # - hide bar #",
	"/dab bartoggle # - show bar # if it's hidden else hide it",
	"/dab barswap barA barB - swap the buttons on barA with those on barB",
	"/dab unswap - swap the last two bars you swapped using the /dab barswap command",
	"/dab floatershow # - show floater #",
	"/dab floaterhide # - hide floater #",
	"/dab floatertoggle # - show floater # if it's hidden else hide it",
	"/dab clearbar # - removes the actions from all buttons on bar #",
	"/dab setkeybar # - set bar # as the bar the dynamic keybindings use",
	"/dab hideallbars - hide all bars",
	"/dab showallbars - show all bars"
};


DAB_MENU_FORMMETHODS = {
		{ text = "Show Bar", value = 1 },
		{ text = "Show Bar and Set Dynamic Keybindings", value = 2 },
		{ text = "Swap with Main Bar", value = 3 }
	};

DAB_MENU_ANCHORS = {
		{ text = "TOPLEFT", value = "TOPLEFT" },
		{ text = "TOP", value = "TOP" },
		{ text = "TOPRIGHT", value = "TOPRIGHT" },
		{ text = "LEFT", value = "LEFT" },
		{ text = "CENTER", value = "CENTER" },
		{ text = "RIGHT", value = "RIGHT" },
		{ text = "BOTTOMLEFT", value = "BOTTOMLEFT" },
		{ text = "BOTTOM", value = "BOTTOM" },
		{ text = "BOTTOMRIGHT", value = "BOTTOMRIGHT" }
	 };

DAB_MENU_OTHERBARLAYOUTS = {
		{ text = "1 Row Horizontal", value = 1 },
		{ text = "2 Rows Horizontal", value = 2 },
		{ text = "1 Column Vertical", value = 3 },
		{ text = "2 Columns Vertical", value = 4 }
	};

DAB_MENU_OTHERBARS = {
		{ text = "Pet Action Bar", value = 11},
		{ text = "Shapeshift Bar", value = 12},
		{ text = "Bag Bar", value = 13},
		{ text = "Menu Bar", value = 14}
	};

if (GetLocale() == "deDE") then
	DAB_TEXT.Rogue = "Schurke";
	DAB_TEXT.Warrior = "Krieger";
	DAB_TEXT.Druid = "Druide";
	DAB_TEXT.Paladin = "Paladin";
end

-- *********************************************************
-- *      French translations courtesy of Miro           *
-- *********************************************************

if (GetLocale() == "frFR") then
DAB_TITLE = "Discord Action Bars v"..DAB_VERSION.."\nhttp://www.discordmods.com";
DAB_FREEBUTTONSLABEL = "Bouttons Libres";
DAB_SELECTFLOATER = "      S\195\169lectionnez un Flotteur pour l'\195\169diter";
DAB_ENTERMACROTEXT = "Entrez le code de la macro ici:";
DAB_LOAD = "CHARGE";
DAB_SAVE = "SAUVE";
DAB_DELETE = "EFFACER";
DAB_NUDGE = "D\195\169placer:";

DAB_TEXT = {
	ActionBarPageChanged = "Action Bar Page Changed ",
	ActionBarUpdateCooldown = "Action Bar Update Cooldown",
	AnchorButton = "Attacher au Bouton",
	AnchorFrame = "Attacher Fen\195\170tre",
	AnchorPoint = "Point d'attache",
	AnchorTo = "Attacher \195\160",
	AutoAttack = "Attaquer auto quand une action est utilis\195\169e",
	Background = "Fond",
	BackgroundAlpha = "Transparence du Fond",
	BackgroundColor = "Couleur du fond",
	BackgroundPadding = "Remplissage",
	BackgroundStyle = "Style du fond",
	BackgroundTexture = "Texture du fond",
	Bag = "Barre des sacs",
	BagUpdate = "Contenu des sacs modifi\195\169",
	BagOffsetX = "D\195\169calage sacs en X",
	BagOffsetY = "D\195\169calage sacs en Y",
	Bar = "Barre ",
	BarKeybindings = "RACCOURCIS DES BOUTONS",
	BarOptions = "OPTIONS BARRE $n",
	BarToEdit = "Barre \195\160 \195\169diter: ",
	BonusActionbar = "Vous changez de forme",
	BorderAlpha = "Transparence du Bord",
	BorderColor = "Couleur du Bord",
	BorderTexture = "Texture du Bord",
	Button = "Bouton ",
	ButtonAlpha = "Transparence des Boutons",
	ButtonBorderAlpha = "Transparence Bord Bouton",
	ButtonBorderColor = "Couleur du Bord du Bouton",
	ButtonBorderPadding = "  Remplissage Bord Bouton",
	ButtonRows = "Ligne de Bouton",
	ButtonScale = "Agrandissement de Bouton",
	ButtonSize = "Taille de Bouton",
	ButtonSpacingH = "Espace Horizontal",
	ButtonSpacingV = "Espace Vertical",
	CCFontSize = "Taille des compteurs",
	ChooseEvent = "Ev\195\169nement: ",
	CollapseEmpty = "Supprimer les boutons vides",
	ControlBox= "Contr\195\180le",
	ControlBoxBindings = "Boites de contr\195\180le",
	ConvertToFloater = "Convertir 1 bouton libre en Flotteur",
	CooldownCountThreshold = "Limite pour compteurs",
	Copy = "COPIER",
	CopyBarSettings = "Copier les param\195\170tres de la barre",
	CopyBGSettings = "Copier param\195\170tres du fond de la barre",
	CopyControlBoxSettings = "Copier param\195\170tres de la boite de contr\195\180le",
	CopyLabelSettings = "Copier param\195\170tres du titre",
	DefaultSettingsLoaded = "Param\195\170tres par d\195\169faut charg\195\169s.",
	DefaultTarget = "Cible par d\195\169faut",
	DeleteThisFloater = "Effacer ce flotteur",
	DisableTooltips = "D\195\169sactiver les infos souris des boutons",
	DoNotShowCooldownCountSec = "Ne pas afficher le s pour les secondes",
	Druid = "Druide",
	DuelFinished = "Duel Termin\195\169 ",
	DuelRequested = "Duel Demand\195\169 ",
	DynamicKeybindings = "Raccourcis Dynamiques",
	Events = "Macros \195\169v\195\169nements",
	Floater = "Flotteur ",
	Floaters = "Flotteurs",
	FloatersHeader = "OPTIONS FLOTTEURS",
	Force = "Force",
	Form = "Barre de forme",
	GhostBar = "Barre Fant\195\180me",
	Height = "Hauteur",
	Hide = "Cacher",
	HideDynamicKeybindings = "Cacher les raccourcis dynamiques",
	HideEmpty = "Cacher les boutons vides",
	HideFloaterOnClick = "Cacher quand cliqu\195\169",
	HideIDs = "Cacher No boutons",
	HideKeybindings = "Cacher les raccourcis",
	HideLabels = "Cacher les Titres",
	HideOnClick = "Cacher quand cliqu\195\169",
	HideOtherBars = "Cacher les autres barres quand cliqu\195\169",
	Humanoid = "Humano\195\175de",
	Label = "Titre",
	Layout = "Disposition",
	LoadCustomSettings = "Param\195\170tres perso",
	LoadDefaultSettings = "Param\195\170tres par d\195\169faut",
	LoadSettings = "Charger param\195\170tres: ",
	LockButtons = "Verrouiller Boutons",
	LockDragging = "Verrouiller Barres",
	MacroOnClick = "Execute la macro quand cliqu\195\169",
	MacrosOnEvents = "Faire que les macros demmarre sur l'\195\169v\195\169nement",
	MainBar = "Barre principale pour changement de forme",
	MainBarWarning = "Cette barre est la principale et ne peut \195\170tre d\195\169finie comme changement de forme.",
	Menu = "Barre de Menu",
	MiddleClickBar = "Barre de Click-milieu",
	MiddleClickButton = "Bouton de Click-milieu",
	MiscOptions = "Options Diverses",
	MiscOptionsHeader = "OPTIONS DIVERSES",
	ModifyCooldownByUIScale = "Modifier la taille des compteurs avec l'interface",
	MouseoverBGColor = "Couleur fond au passage souris",
	MouseoverTextColor = "Couleur texte au passage souris",
	None = "Aucun",
	NumButtons = "Nombre de Boutons",
	NumButtonsHeader = "NOMBRE DE BOUTONS PAR BARRE",
	OffsetX = "D\195\169calage X",
	OffsetY = "D\195\169calage Y",
	OneTrue = "Seulement une condition doit \195\170tre vraie",
	OnlyClickedButtons = "Montrer le d\195\169compte seulement sur le bouton cliqu\195\169",
	OnUpdate = "Quand mise \195\160 jour",
	OptionsScale = "Taille de la fen\195\170tre d'options",
	OtherBars = "Autres barres",
	OtherBarsHeader = "OPTIONS DES AUTRES BARRES",
	OutOfManaColor = "Couleur quand manque de mana",
	OutOfRangeColor = "Couleur quand trop loin",
	Paladin = "Paladin",
	PartyChanged = "Membres du groupe modifi\195\169s ",
	Pet = "Barre d'action du PET",
	PetAttackStart = "PET attaque ",
	PetAttackStop = "PET arr\195\170te d'attaquer ",
	PlayerAlive = "Vous \195\170tes revenu \195\160 la vie ",
	PlayerDead = "Vous \195\170tes mort ",
	PlayerEnterCombat = "Vous entrez en mode d'attaque",
	PlayerLeaveCombat = "Vous sortez du mode d'attaque",
	PlayerRegenDisabled = "R\195\169g\195\169n\195\169ration de vie d\195\169sactiv\195\169e",
	PlayerRegenEnabled = "R\195\169g\195\169n\195\169ration de vie activ\195\169e",
	PlayerTargetChanged = "Vous changez de cible",
	QuickLoad = "Chargement rapide",
	QuickSave = "Sauvegarde rapide",
	RaidMembersChanged = "Membres du raid modifi\195\169s ",
	RecolorBorder = "Colorier le bord du bouton au lieu de son icone",
	RecolorOnMouseover = "Changer couleur de fond au passage souris",
	RecolorTextOnMouseover = "Changer couleur de texte au passage souris",
	RightClickBar = "Barre click-droit",
	RightClickButton = "Bouton click-droit",
	Rogue = "Voleur",
	SaveSettings = "Sauver param\195\170tres: ",
	SetAllBarsToZero = "TOUT \195\160 0",
	SetDynamicKeybindingsTo = "D\195\169finir les raccourcis dynamiques sur",
	SettingsDeleted = "Param\195\170tres effac\195\169s.",
	SettingsLoaded = "Nouveau param\195\170tres charg\195\169s.",
	SettingsSaved = "Les param\195\170tres ont \195\169t\195\169 sauvegard\195\169s avec succ\195\168s.",
	ShapeshiftForm = "Utiliser pour changement de forme",
	ShowBarOnClick = "Montre la barre quand cliqu\195\169",
	ShowBarOnMouseover = "Affiche la barre au passage souris",
	ShowBarsSetToKeypress = "Affiche barres et flotteurs quand touche enfonc\195\169e",
	ShowBottomBorder = "Affiche le bord des boutons",
	ShowCooldownCount = "Affiche les d\195\169comptes",
	ShowDefaultArt = "Affiche les fen\195\170tres d'origine (Red\195\169marrage n\195\169cessaire)",
	ShowForFriendly = "Affiche pour cibles amies",
	ShowForHostile = "Affiche pour cibles ennemies",
	ShowForShapeshiftForm = "Affiche pour changement de forme",
	ShowGhostBar = "Affiche Barre Fant\195\180me",
	ShowIDs = "Afficher No boutons",
	ShowInCombat = "Affiche quand en combat",
	ShowLabels = "Affiche les Titres",
	ShowLeftBorder = "Affiche Bord gauche",
	ShowOnBarMouseover = "Affiche au passage souris",
	ShowOutOfCombat = "Affiche quand hors combat",
	ShowRightBorder = "Affiche Bord droit",
	ShowTopBorder = "Affiche Bord haut",
	ShowXPBar = "Affiche barre d'XP",
	ShowWhileKeyIsPressed = "Affiche quand une touche est enfonc\195\169e",
	SpellcastDelayed = "Votre incantation est report\195\169e ",
	SpellcastFailed = "Votre incantation a \195\169chou\195\169 ",
	SpellcastInterrupted = "Votre incantation est interrompue ",
	SpellcastStart = "Vous commencez votre incantation ",
	SpellcastStop = "Vous interompez votre incantation ",
	Text = "Texte",
	TextAlpha = "Transparence du Texte",
	TextColor = "Couleur du Texte",
	TextSize = "Taille du Texte",
	Timeout = "Temps avant disparition",
	ToggleButtonIDs = "Toggle Button IDs",
	ToggleButtonLock = "Toggle Buttonlock",
	ToggleDragging = "Toggle Dragging",
	ToggleOptions = "Affiche ou non les options",
	Undefined = "Non d\195\169fini",
	UnitAura = "Am\195\169lioration/Mal\195\169dictions Chang\195\169es ",
	UnitCombat = "Ev\195\169nements de combat de l'unit\195\169 ",
	UnitComboPoints = "Vos points de combos ont chang\195\169s ",
	UnitEnergy = "L'\195\169n\195\169rgie de l'unit\195\169 a chang\195\169 ",
	UnitFocus = "La cible de l'unit\195\169 a chang\195\169 ",
	UnitHealth = "La vie de l'unit\195\169 a chang\195\169 ",
	UnitMana = "Le mana de l'unit\195\169 a chang\195\169 ",
	UnitPet = "Le PET de l'unit\195\169 a chang\195\169 ",
	UnitRage = "La rage de l'unit\195\169 a chang\195\169 ",
	UnitSpellmiss = "L'unit\195\169 a r\195\169sist\195\169 \195\160 votre sort ",
	UnlockButtons = "D\195\169verrouiller Boutons",
	UnlockDragging = "D\195\169verouiller Barres",
	UnusableColor = "Couleur quand action innutilisable",
	UseOnDown = "Utilise l'action quand raccourcis press\195\169",
	VariablesLoaded = "Variables Charg\195\169es",
	Warrior = "Guerrier",
	WhenIShapeshift = "Quand je change de forme",
	Width = "Largeur",
	YouHitMessage = "'Vous touchez' Message Chat",
	YouMissMessage = "'Vous ratez' Message Chat",
};

DAB_HELP_TEXT = {
	"Les commandes de Discord Action Bars",
	"------------------------------------------------------",
	"/dab - Affiche la fen\195\170tre d'option",
	"/dab barshow # - Affiche la barre #",
	"/dab barhide # - Cache la barre #",
	"/dab bartoggle # - Affiche la barre # si elle n'est pas visible et inversement",
	"/dab barswap barA barB - Echange les boutons de la Barre A avec ceux de la Barre B",
	"/dab unswap - Echange les boutons des deux barre que vous avez \195\169chang\195\169es en utilisant la commande /dab barswap",
	"/dab floatershow # - Montre le flotteur #",
	"/dab floaterhide # - Cache le flotteur #",
	"/dab floatertoggle # - Affiche le flotteur # si il est cach\195\169 et le cache si il est affich\195\169",
	"/dab clearbar # - Efface les actions sur tout les boutons de la barre #",
	"/dab setkeybar # - D\195\169finis les raccourcis dynamiques sur la barre #",
	"/dab hideallbars - Cache toutes les barres",
	"/dab showallbars - Affiche toutes les barres"
};


DAB_MENU_FORMMETHODS = {
		{ text = "Affiche barre", value = 1 },
		{ text = "Affiche barre et y d\195\169finis les raccourcis dynamiques", value = 2 },
		{ text = "Echange avec la barre principale", value = 3 }
	};

DAB_MENU_ANCHORS = {
		{ text = "HAUTgauche", value = "TOPLEFT" },
		{ text = "HAUT", value = "TOP" },
		{ text = "HAUTdroite", value = "TOPRIGHT" },
		{ text = "GAUCHE", value = "LEFT" },
		{ text = "CENTRE", value = "CENTER" },
		{ text = "DROITE", value = "RIGHT" },
		{ text = "BASgauche", value = "BOTTOMLEFT" },
		{ text = "BAS", value = "BOTTOM" },
		{ text = "BASdroite", value = "BOTTOMRIGHT" }
	 };

DAB_MENU_OTHERBARLAYOUTS = {
		{ text = "1 Ligne Horizontale", value = 1 },
		{ text = "2 Lignes Horizontales", value = 2 },
		{ text = "1 Colonne Verticale", value = 3 },
		{ text = "2 Colonnes Verticales", value = 4 }
	};

DAB_MENU_OTHERBARS = {
		{ text = "Barre d'action du PET", value = 11},
		{ text = "Barre de Forme", value = 12},
		{ text = "Barre des sacs", value = 13},
		{ text = "Barre de menu", value = 14}
	};
end

DAB_MENU_ANCHORFRAMES = {
		{ text = "", value = nil },
		{ text = DAB_TEXT.Bar..1, value = "DAB_ActionBar_1" },
		{ text = DAB_TEXT.Bar..2, value = "DAB_ActionBar_2" },
		{ text = DAB_TEXT.Bar..3, value = "DAB_ActionBar_3" },
		{ text = DAB_TEXT.Bar..4, value = "DAB_ActionBar_4" },
		{ text = DAB_TEXT.Bar..5, value = "DAB_ActionBar_5" },
		{ text = DAB_TEXT.Bar..6, value = "DAB_ActionBar_6" },
		{ text = DAB_TEXT.Bar..7, value = "DAB_ActionBar_7" },
		{ text = DAB_TEXT.Bar..8, value = "DAB_ActionBar_8" },
		{ text = DAB_TEXT.Bar..9, value = "DAB_ActionBar_9" },
		{ text = DAB_TEXT.Bar..10, value = "DAB_ActionBar_10" },
		{ text = DAB_TEXT.ControlBox.." "..1, value = "DAB_ControlBox_1" },
		{ text = DAB_TEXT.ControlBox.." "..2, value = "DAB_ControlBox_2" },
		{ text = DAB_TEXT.ControlBox.." "..3, value = "DAB_ControlBox_3" },
		{ text = DAB_TEXT.ControlBox.." "..4, value = "DAB_ControlBox_4" },
		{ text = DAB_TEXT.ControlBox.." "..5, value = "DAB_ControlBox_5" },
		{ text = DAB_TEXT.ControlBox.." "..6, value = "DAB_ControlBox_6" },
		{ text = DAB_TEXT.ControlBox.." "..7, value = "DAB_ControlBox_7" },
		{ text = DAB_TEXT.ControlBox.." "..8, value = "DAB_ControlBox_8" },
		{ text = DAB_TEXT.ControlBox.." "..9, value = "DAB_ControlBox_9" },
		{ text = DAB_TEXT.ControlBox.." "..10, value = "DAB_ControlBox_10" },
		{ text = "Pet Action Bar", value = "DAB_OtherBar_Pet" },
		{ text = "Shapeshift Bar", value = "DAB_OtherBar_Form" },
		{ text = "Bag Bar", value = "DAB_OtherBar_Bag" },
		{ text = "Menu Bar", value = "DAB_OtherBar_Menu" },
		{ text = "UI Parent", value = "UIParent" }
	};

DAB_MENU_BARNUMS = {};
DAB_MENU_BARNUMS[1] = { text = DAB_TEXT.None, value=nil };
for i=1,DAB_NUMBER_OF_BARS do
	DAB_MENU_BARNUMS[i + 1] = { text = i, value = i };
end

DAB_MENU_BACKGROUNDSTYLES = {
		{ text = 1, value = 1 },
		{ text = 2, value = 2 },
		{ text = 3, value = 3 }
	};

DAB_MENU_EVENTS = {
	{ text=DAB_TEXT.ActionBarPageChanged, value="ACTIONBAR_PAGE_CHANGED" },
	{ text=DAB_TEXT.ActionBarUpdateCooldown, value="ACTIONBAR_UPDATE_COOLDOWN" },
	{ text=DAB_TEXT.BagUpdate, value="BAG_UPDATE" },
	{ text=DAB_TEXT.DuelRequested, value="DUEL_REQUESTED" },
	{ text=DAB_TEXT.DuelFinished, value="DUEL_FINISHED" },
	{ text=DAB_TEXT.PartyChanged, value="PARTY_MEMBERS_CHANGED" },
	{ text=DAB_TEXT.PetAttackStart, value="PET_ATTACK_START" },
	{ text=DAB_TEXT.PetAttackStop, value="PET_ATTACK_STOP" },
	{ text=DAB_TEXT.PlayerAlive, value="PLAYER_ALIVE" },
	{ text=DAB_TEXT.PlayerDead, value="PLAYER_DEAD" },
	{ text=DAB_TEXT.PlayerEnterCombat, value="PLAYER_ENTER_COMBAT" },
	{ text=DAB_TEXT.PlayerLeaveCombat, value="PLAYER_LEAVE_COMBAT" },
	{ text=DAB_TEXT.PlayerRegenEnabled, value="PLAYER_REGEN_ENABLED" },
	{ text=DAB_TEXT.PlayerRegenDisabled, value="PLAYER_REGEN_DISABLED" },
	{ text=DAB_TEXT.PlayerTargetChanged, value="PLAYER_TARGET_CHANGED" },
	{ text=DAB_TEXT.RaidMembersChanged, value="RAID_ROSTER_UPDATE" },
	{ text=DAB_TEXT.SpellcastDelayed, value="SPELLCAST_DELAYED" },
	{ text=DAB_TEXT.SpellcastFailed, value="SPELLCAST_FAILED" },
	{ text=DAB_TEXT.SpellcastInterrupted, value="SPELLCAST_INTERRUPTED" },
	{ text=DAB_TEXT.SpellcastStart, value="SPELLCAST_START" },
	{ text=DAB_TEXT.SpellcastStop, value="SPELLCAST_STOP" },
	{ text=DAB_TEXT.UnitAura, value="UNIT_AURA" },
	{ text=DAB_TEXT.UnitCombat, value="UNIT_COMBAT" },
	{ text=DAB_TEXT.UnitComboPoints, value="PLAYER_COMBO_POINTS" },
	{ text=DAB_TEXT.UnitEnergy, value="UNIT_ENERGY" },
	{ text=DAB_TEXT.UnitFocus, value="UNIT_FOCUS" },
	{ text=DAB_TEXT.UnitHealth, value="UNIT_HEALTH" },
	{ text=DAB_TEXT.UnitMana, value="UNIT_MANA" },
	{ text=DAB_TEXT.UnitPet, value="UNIT_PET" },
	{ text=DAB_TEXT.UnitRage, value="UNIT_RAGE" },
	{ text=DAB_TEXT.UnitSpellmiss, value="UNIT_SPELLMISS" },
	{ text=DAB_TEXT.VariablesLoaded, value="VARIABLES_LOADED" },
	{ text=DAB_TEXT.BonusActionbar, value="UPDATE_BONUS_ACTIONBAR" },
	{ text=DAB_TEXT.YouHitMessage, value="CHAT_MSG_COMBAT_SELF_HITS" },
	{ text=DAB_TEXT.YouMissMessage, value="CHAT_MSG_COMBAT_SELF_MISSES" },
	{ text=DAB_TEXT.OnUpdate, value="OnUpdate" }
};

DAB_MENU_OPTIONSSCALE = {
	{ text=50, value=50},
	{ text=60, value=60},
	{ text=70, value=70},
	{ text=80, value=80},
	{ text=90, value=90},
	{ text=100, value=100}
};

DAB_UNITIDS = { player = true, pet = true, target = true, targettarget = true, pettarget = true};
for i=1,40 do
	if (i < 5) then
		DAB_UNITIDS["party"..i] = true;
		DAB_UNITIDS["party"..i.."target"] = true;
		DAB_UNITIDS["partypet"..i] = true;
		DAB_UNITIDS["partypet"..i.."target"] = true;
	end
	DAB_UNITIDS["raid"..i] = true;
	DAB_UNITIDS["raid"..i.."target"] = true;
end

DAB_OTHER_BARS = {
	Pet = { frames = { "PetActionButton1", "PetActionButton2", "PetActionButton3", "PetActionButton4", "PetActionButton5", "PetActionButton6", "PetActionButton7", "PetActionButton8", "PetActionButton9", "PetActionButton10" }, first = "PetActionButton1", row2 = "PetActionButton6", last = "PetActionButton10", length1 = 10, length2 = 5},
	Form = { frames = { "ShapeshiftButton1", "ShapeshiftButton2", "ShapeshiftButton3", "ShapeshiftButton4", "ShapeshiftButton5", "ShapeshiftButton6", "ShapeshiftButton7", "ShapeshiftButton8", "ShapeshiftButton9", "ShapeshiftButton10" }, first = "ShapeshiftButton1", row2 = "ShapeshiftButton6", last = "ShapeshiftButton10", length1 = 10, length2 = 5 },
	Bag = { frames = { "CharacterBag3Slot", "CharacterBag2Slot", "CharacterBag1Slot", "CharacterBag0Slot", "MainMenuBarBackpackButton" }, last = "MainMenuBarBackpackButton", row2 = "CharacterBag2Slot", first = "CharacterBag3Slot", length1 = 5, length2 = 3 },
	Menu = { frames = { "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "QuestLogMicroButton", "SocialsMicroButton", "WorldMapMicroButton", "MainMenuMicroButton", "HelpMicroButton" }, first = "CharacterMicroButton", row2 = "SocialsMicroButton", last = "HelpMicroButton", length1 = 8, length2 = 4 }
};

BINDING_HEADER_DAB = DAB_TITLE;
BINDING_NAME_DAB_OPTIONS = DAB_TEXT.ToggleOptions;
BINDING_NAME_DAB_DRAGGING = DAB_TEXT.ToggleDragging;
BINDING_NAME_DAB_BUTTONLOCK = DAB_TEXT.ToggleButtonLock;
BINDING_NAME_DAB_BUTTONIDS = DAB_TEXT.ToggleButtonIDs;
BINDING_NAME_DAB_KEYPRESSBARS = DAB_TEXT.ShowBarsSetToKeypress;
BINDING_NAME_DAB_SHOWGHOSTBAR = DAB_TEXT.ShowGhostBar;

BINDING_HEADER_DAB2 = DAB_TEXT.SetDynamicKeybindingsTo;
BINDING_NAME_DAB2_1 = "     "..DAB_TEXT.Bar.."1";
BINDING_NAME_DAB2_2 = "     "..DAB_TEXT.Bar.."2";
BINDING_NAME_DAB2_3 = "     "..DAB_TEXT.Bar.."3";
BINDING_NAME_DAB2_4 = "     "..DAB_TEXT.Bar.."4";
BINDING_NAME_DAB2_5 = "     "..DAB_TEXT.Bar.."5";
BINDING_NAME_DAB2_6 = "     "..DAB_TEXT.Bar.."6";
BINDING_NAME_DAB2_7 = "     "..DAB_TEXT.Bar.."7";
BINDING_NAME_DAB2_8 = "     "..DAB_TEXT.Bar.."8";
BINDING_NAME_DAB2_9 = "     "..DAB_TEXT.Bar.."9";
BINDING_NAME_DAB2_10 = "     "..DAB_TEXT.Bar.."10";

BINDING_HEADER_DAB3 = DAB_TEXT.DynamicKeybindings;
BINDING_NAME_DAB3_1 = "     "..DAB_TEXT.Button.."1";
BINDING_NAME_DAB3_2 = "     "..DAB_TEXT.Button.."2";
BINDING_NAME_DAB3_3 = "     "..DAB_TEXT.Button.."3";
BINDING_NAME_DAB3_4 = "     "..DAB_TEXT.Button.."4";
BINDING_NAME_DAB3_5 = "     "..DAB_TEXT.Button.."5";
BINDING_NAME_DAB3_6 = "     "..DAB_TEXT.Button.."6";
BINDING_NAME_DAB3_7 = "     "..DAB_TEXT.Button.."7";
BINDING_NAME_DAB3_8 = "     "..DAB_TEXT.Button.."8";
BINDING_NAME_DAB3_9 = "     "..DAB_TEXT.Button.."9";
BINDING_NAME_DAB3_10 = "     "..DAB_TEXT.Button.."10";
BINDING_NAME_DAB3_11 = "     "..DAB_TEXT.Button.."11";
BINDING_NAME_DAB3_12 = "     "..DAB_TEXT.Button.."12";
BINDING_NAME_DAB3_13 = "     "..DAB_TEXT.Button.."13";
BINDING_NAME_DAB3_14 = "     "..DAB_TEXT.Button.."14";
BINDING_NAME_DAB3_15 = "     "..DAB_TEXT.Button.."15";
BINDING_NAME_DAB3_16 = "     "..DAB_TEXT.Button.."16";
BINDING_NAME_DAB3_17 = "     "..DAB_TEXT.Button.."17";
BINDING_NAME_DAB3_18 = "     "..DAB_TEXT.Button.."18";
BINDING_NAME_DAB3_19 = "     "..DAB_TEXT.Button.."19";
BINDING_NAME_DAB3_20 = "     "..DAB_TEXT.Button.."20";

BINDING_HEADER_DABCBOX = DAB_TEXT.ControlBoxBindings;
BINDING_NAME_DABCBOX_1 = "     "..DAB_TEXT.ControlBox.." 1";
BINDING_NAME_DABCBOX_2 = "     "..DAB_TEXT.ControlBox.." 2";
BINDING_NAME_DABCBOX_3 = "     "..DAB_TEXT.ControlBox.." 3";
BINDING_NAME_DABCBOX_4 = "     "..DAB_TEXT.ControlBox.." 4";
BINDING_NAME_DABCBOX_5 = "     "..DAB_TEXT.ControlBox.." 5";
BINDING_NAME_DABCBOX_6 = "     "..DAB_TEXT.ControlBox.." 6";
BINDING_NAME_DABCBOX_7 = "     "..DAB_TEXT.ControlBox.." 7";
BINDING_NAME_DABCBOX_8 = "     "..DAB_TEXT.ControlBox.." 8";
BINDING_NAME_DABCBOX_9 = "     "..DAB_TEXT.ControlBox.." 9";
BINDING_NAME_DABCBOX_10 = "     "..DAB_TEXT.ControlBox.." 10";

BINDING_HEADER_DABBARS = DAB_TEXT.BarKeybindings;
for i=1,120 do
	setglobal("BINDING_NAME_DABBUTTON"..i, DAB_TEXT.Button..i);
end