function AH_Wipe_Locals_deDE()

ace:RegisterGlobals({
	version							=	1.01,
	translation					=	"deDE",
	ACEG_DISPLAY_OPTION	=	"[|cfff5f530%s|r]",
	ACEG_MAP_SAVED			=	{[0]="|cffff5050nicht gespeichert|r",[1]="|cff00ff00gespeichert|r"},
	ACEG_MAP_ONOFF			=	{[0]="|cffff5050Aus|r",[1]="|cff00ff00An|r"},
})

AHW.Display			= "Button-Anzeige:"
AHW.Tooltip			=	"Setzt die Such-Anzeige auf deren Standardwerte zurück."
AHW.HideDR			=	"Vorschau-Fenster verstecken:"
AHW.ButtonReset = "Der Button wurde auf die Original-Position zurückgesetzt."
AHW.ButtonPos		=	"Eigene Button-Position: "
AHW.Auto				=	"Auto-Reset:"
AHW.HideTT			= "Tooltip:"

AHW.Commands 		=	{"/ahw", "/ahwipe"}	 
AHW.CmdOptions = {
	{	option	=	"restore",
		desc		=	"Stellt die Original-Position des Buttons wieder her.",
		method	=	"Restore"
	},
	{	option	=	"clear",
		desc		=	"Setzt die AH Such-Anzeige auf deren Standardwerte zurück.",
		method	=	"Wipe"
	},
	{	option	=	"hidedr",
		desc		=	"Versteckt das Vorschau-Fenster, sobald der Reset-Button gedrückt wird. (Toggle)",
		method	=	"HideDR"
	},
	{	option	=	"auto",
		desc		=	"Setzt beim Öffnen des AH die Such-Anzeige automatisch zurück. (Toggle)",
		method	=	"Auto"
	},
	{	option	=	"show",
		desc		=	"Schaltet die Anzeiges des Buttons ein/aus.",
		method	=	"Show"
	},
	{	option	=	"tooltip",
		desc		=	"Schaltet die Tooltip-Anzeige ein/aus. (Toggle)",
		method	=	"HideTT"
	}
}
end