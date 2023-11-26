-- Localisation file
-- "frFR": français (myself)
-- "deDE": allemand (thx to w1cked on CurseGaming)
-- "usEN": anglais (myself, with help of Skuug)
-- "koKR": coréen 



GOUGEHELPER_TEXT_ON = "(.+) is afflicted by Gouge."
--GOUGEHELPER_TEXT_ON = "(.+) gains Gouge."
GOUGEHELPER_TEXT_BREAK = "(.+)'s Gouge is removed."
GOUGEHELPER_TEXT_OFF = "Gouge fades from (.+)."

GOUGEHELPER_HELP1 = "GougeHelper : "
GOUGEHELPER_HELP2 = "/gh on/off"
GOUGEHELPER_HELP3 = "/gh unlock/lock (Show/Hide GougeHelper window to move it around)"
GOUGEHELPER_HELP4 = "/gh clear (Remove the saved parameters)"

GOUGEHELPER_SKILL = "Gouge"

if (GetLocale() == "frFR") then 
-- TODO
	GOUGEHELPER_HELP3 = "/gh unlock/lock (Affiche la fenetre pour la positionner)"
	GOUGEHELPER_HELP4 = "/gh clear (efface les parametres enregistres)"
	
	GOUGEHELPER_TEXT_ON = "(.+) subit les effets de Suriner"
	GOUGEHELPER_TEXT_BREAK = "(.+) n'est plus sous l'influence de Suriner."
	GOUGEHELPER_TEXT_OFF = "Suriner sur (.+) vient de se dissiper."

	
	GOUGEHELPER_SKILL = "Suriner"
elseif (GetLocale() == "deDE") then
-- thx to w1cked on CurseGaming
	GOUGEHELPER_TEXT_ON = "(.+) ist von Ausquetschen betroffen."
	GOUGEHELPER_TEXT_OFF = "Ausquetschen schwindet von (.+)."
elseif (GetLocale() == "usEN") then
-- TODO
elseif (GetLocale() == "koKR") then
-- TODO
end