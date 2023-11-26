-- Version : French (by Vjeux)
-- Last Update : 02/17/2005

if ( GetLocale() == "frFR" ) then

	-- <= == == == == == == == == == == == == =>
	-- => Bindings Names
	-- <= == == == == == == == == == == == == =>
	BINDING_NAME_TOGGLEVICKEL		= "Activer/Désactiver Vickel";

	-- <= == == == == == == == == == == == == =>
	-- => Vickel's Strings
	-- <= == == == == == == == == == == == == =>
	VICKEL_DEFAULT_STRING			= "Salut, je suis Vickel.";
	VICKEL_RESPONSE_STRING			= "Oui ?";
	VICKEL_HELLO_STRING				= "Bijour !";
	VICKEL_NOT_UNDERSTAND_STRING	= "Désolé mais je ne comprends pas, je n'ai qu'un petit vocabulaire.";
	VICKEL_COSMOS_WATCHING_STRING	= "Je vais vous reporter le canal de Cosmos !";
	VICKEL_COSMOS_PARTY_WATCHING_STRING = "Je vais vous reporter le canal de votre groupe !";
	VICKEL_KILL_STRING				= "Bien joué !";
	VICKEL_HURT_STRING				= "Ouch !";
	VICKEL_WHEE_STRING				= "Whee !";
	VICKEL_WHOA_STRING				= "Whoa !";
	VICKEL_MEMORY_STRING			= "La mémoire utilisée actuellement est de ";
	VICKEL_MEMORY_STRING_END		= " Kilobytes";
	VICKEL_FRIENDLY_DEATH			= "NAN !";
	VICKEL_FRIENDLY_DEATH_END		= " a mourru !";
	VICKEL_POISONED					= "Hey, fais attention\n Tu es actuellement empoisonné !";
	VICKEL_TYPE						= "Type : %s";
	VICKEL_USER						= "Qui : %s";
	VICKEL_MSG						= "Msg : %s";
	VICKEL_CHAN						= "Canal : %s";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Configuration Strings
	-- <= == == == == == == == == == == == == =>
	VICKEL_CONFIG_HEADER			= "Vickel Config";
	VICKEL_CONFIG_HEADER_INFO		= "Vickel est un petit animal qui se balade sur votre écran en vous donnant quelques informations par la même occasion.";
	VICKEL_CONFIG_IDLE				= "Ralentir l'Animation";
	VICKEL_CONFIG_IDLE_INFO			= "Plus la valeur du slider est grande, plus Vickel va être lent. Désactivez cette option pour rétablir la vitesse normale.";
	VICKEL_CONFIG_IDLE_SLIDER		= " Vitesse de l'Animation";
	VICKEL_CONFIG_IDLE_SLIDER_TAG	= " / 10";
	VICKEL_CONFIG_ONOFF				= "Activer/Désactiver Vickel";
	VICKEL_CONFIG_ONOFF_INFO		= "Si cette option n'est pas activée, Vickel ne va pas être affiché.";
	VICKEL_CONFIG_COSMOS			= "Voir les discutions sur le canal de Cosmos";
	VICKEL_CONFIG_COSMOS_INFO		= "Affiche les informations normalement cachées qui circulent sur le canal dédié à Cosmos.";
	VICKEL_CONFIG_COSMOS_PARTY		= "Voir les discutions sur le canal Cosmos de votre Groupe";
	VICKEL_CONFIG_COSMOS_PARTY_INFO = "Affiche les informations normalement cachées qui circulent sur le canal Cosmos de votre Groupe.";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Button Strings
	-- <= == == == == == == == == == == == == =>
	VICKEL_BUTTON_TEXT				= "Vickel";
	VICKEL_BUTTON_SUBTEXT			= "L'Exemple";
	VICKEL_BUTTON_TIP				= "Cliquez ici pour afficher Vickel.";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Chat Command Strings
	-- <= == == == == == == == == == == == == =>
	VICKEL_CHAT_COMMAND				= {"/vickel", "/vick", "/vkl", "/vickle", "/vi"};
	VICKEL_CHAT_C1					= "lu";
	VICKEL_CHAT_C2					= "cosmos";
	VICKEL_CHAT_C3					= "groupe";
	VICKEL_CHAT_C4					= "mem";
	VICKEL_CHAT_COMMAND_INFO		= "Reveillez Vickel s'il dort, ou donnez lui une petite claque !";

end