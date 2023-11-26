-- Version : English - ?????

PAGER_COMMAND				= {"/page"};
PAGER_COMMAND_DESC			= "/page <player> <message> - Allows you to 'page' a distracted player with a large message displayed on their screen and a sound effect to draw their attention.";

if ( GetLocale() == "frFR" ) then
	-- Traduction par Vjeux

	PAGER_COMMAND				= {"/bump"};
	PAGER_COMMAND_DESC			= "/bump <joueur> <message> - Vous allez pouvoir attirer l'attention de la personne de votre choix en lui affichant un message en gros sur son Ècran, il va aussi entendre un son.";

elseif ( GetLocale() == "deDE" ) then
	-- Translation by ??? and pc

	PAGER_COMMAND			= {"/anhauen"};
	PAGER_COMMAND_DESC		= "/anhauen <Spielername> <Nachricht> - Erlaubt einen abgelenkten Spieler 'anzuhauen'. Eine groﬂe Meldung wird auf seinem Bildschirm angezeigt und ein Soundeffekt abgespielt um seine Aufmerksamkeit zu erlangen.";

end
