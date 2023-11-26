AHW	=	{}

if not ace:LoadTranslation("AH_Wipe") then

ace:RegisterGlobals({
	version             = 1.01,
	ACEG_DISPLAY_OPTION	=	"[|cfff5f530%s|r]",
	ACEG_MAP_SAVED			=	{[0]="|cffff5050not saved|r",[1]="|cff00ff00saved|r"},
	ACEG_MAP_ONOFF      = {[0]="|cffff5050Off|r",[1]="|cff00ff00On|r"}
})

AHW.Display			= "Button Display:"
AHW.Tooltip			=	"Resets the Browser view to its defaults."
AHW.HideDR			=	"Hide Dressup Room:"
AHW.ButtonReset	= "Button position has been set to defaults."
AHW.ButtonPos		= "Custom Button position: "
AHW.Auto				=	"Auto-Reset:"
AHW.HideTT			= "Tooltip:"

AHW.Commands 		=	{"/ahw", "/ahwipe"}	
AHW.CmdOptions = {
	{	option	=	"restore",
		desc		=	"Restores the Button to its default position.",
		method	=	"Restore"
	},
	{	option	=	"clear",
		desc		=	"Resets the AH Browse view to its defaults.",
		method	=	"Wipe"
	},
	{	option	=	"hidedr",
		desc		=	"Hides the DressUp Room on Reset. (Toggle)",
		method	=	"HideDR"
	},
	{	option	=	"show",
		desc		=	"Shows or hides the Button (Toggle).",
		method	=	"Show"
	},
	{	option	=	"auto",
		desc		=	"Resets automatically on opening the Auction Frame. (Toggle)",
		method	=	"Auto"
	},
	{	option	=	"tooltip",
		desc		=	"Toggles the Tooltip display on/off.",
		method	=	"HideTT"
	}
}

end