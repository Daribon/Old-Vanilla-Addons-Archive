--[[
	AutoInnerFire 1.33
	base by Gello
	mod by deto
	
	Localization for:
		EN (by deto)
		DE (by deto)
		FR (by Fue)
]]

--------------------------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------------------------
-- Version
AIF_SHORTVERSION = "v1.33";
AIF_VERSION = "|cff00FF00AutoInnerFire - "..AIF_SHORTVERSION.." (by deto, based on the concept of Gello & Hyjal)|r";

--------------------------------------------------------------------------------------------------
-- EN (English)
--------------------------------------------------------------------------------------------------
-- Names
AIF_SPELLNAME = "Inner Fire";

-- Slash Commadns help
AIF_HELP1 = "Configurate with |cffff0000/autoinnerfire|r";
AIF_HELP2 = "Options:";
AIF_HELP3 = "|cffffff00on|r (enables AutoInnerFire)";
AIF_HELP4 = "|cffffff00off|r (disables AutoInnerFire)";
AIF_HELP5 = "|cffffff00threshold|r |cffff0000XX|r (mana threshold / XX = mana in percent)";
AIF_HELP6 = "|cffffff00combat|r (toggles buff in combat)";
AIF_HELP7 = "";
AIF_HELP8 = "|cffffff00button|r (toggles minimap button)";
AIF_HELP9 = "|cffffff00position|r |cffff0000XX|r (changes minimap Button position / XX = degree)";
AIF_HELP10 = "|cffffff00options|r (options frame)";

-- Slash Commands reply
AIF_ON = "AutoInnerFire enabled.";
AIF_OFF = "AutoInnerFire disabled.";
AIF_THRESHOLD = "Mana theshold successfully changed to: ";
AIF_COMBAT_ON = "Buff in combat enabled.";
AIF_COMBAT_OFF = "Buff in combat disabled.";
AIF_BUTTON_ON = "Minimap Button enabled.";
AIF_BUTTON_OFF = "Minimap Button disabled.";
AIF_POS = "Minimap Button Position changed to ";

-- MyAddons
AIF_MYADDONS_NAME = "AutoInnerFire";
AIF_MYADDONS_DESCRIPTION = "Automatically casts 'Inner Fire' if you need on movement";

-- Misc
AIF_LOADED = "AutoInnerFire loaded, use /autoinnerfire or /aif";
AIF_PROFILE_CREATING = "AutoInnerFire Profile created of: ";
AIF_PROFILE_LOADED_1 = "Loaded profile of '";
AIF_PROFILE_LOADED_2 = "'.";
AIF_DISABLED = "<AIF> AutoInnerFire disabled - you don't play a priest.";

-- Options Frame
AIF_OPTIONS_TITLE = "AutoInnerFire "..AIF_SHORTVERSION;
AIF_OPTIONS_ON = "On/Off";
AIF_OPTIONS_COMBAT = "Buff in combat";
AIF_OPTIONS_BUTTON = "Button On/Off";
AIF_OPTIONS_BUTPOS = "Minimap Button Position ";
AIF_OPTIONS_THRESHOLD = "Mana threshold";
AIF_OPTIONS_DEFAULTS = "Default";

-- Button Frame
AIF_BUTTON_TOOLTIP = "AutoInnerFire Options Frame";


--------------------------------------------------------------------------------------------------
-- DE (German)
--------------------------------------------------------------------------------------------------
if( GetLocale() == "deDE" ) then

-- Names
AIF_SPELLNAME = "Inneres Feuer";

-- Slash Commadns help
AIF_HELP1 = "Konfigurieren mit |cffff0000/autoinnerfire|r";
AIF_HELP2 = "Optionen:";
AIF_HELP3 = "|cffffff00on|r (Aktiviert AutoInnerFire)";
AIF_HELP4 = "|cffffff00off|r (Deaktiviert AutoInnerFire)";
AIF_HELP5 = "|cffffff00threshold|r |cffff0000XX|r (Mana Schwelle / XX = Mana in Prozent)";
AIF_HELP6 = "|cffffff00combat|r (Buff im Kampf An/Aus)";
AIF_HELP7 = "";
AIF_HELP8 = "|cffffff00button|r (Minimap Button An/Aus)";
AIF_HELP9 = "|cffffff00position|r |cffff0000XX|r (\195\132ndert Minimap Button Position / XX = Grad)";
AIF_HELP10 = "|cffffff00options|r (Einstellungs Fenster)";

-- Slash Commands reply
AIF_ON = "AutoInnerFire aktiviert.";
AIF_OFF = "AutoInnerFire deaktiviert.";
AIF_THRESHOLD = "Mana Schwelle erfolgreich ge\195\164ndert auf: ";
AIF_COMBAT_ON = "Buff im Kampf aktiviert.";
AIF_COMBAT_OFF = "Buff im Kampf deaktiviert.";
AIF_BUTTON_ON = "Minimap Button aktiviert.";
AIF_BUTTON_OFF = "Minimap Button deaktiviert.";
AIF_POS = "Minimap Button Position ge\195\164ndert auf ";

-- MyAddons
AIF_MYADDONS_NAME = "AutoInnerFire";
AIF_MYADDONS_DESCRIPTION = "Castet automatisch 'Inneres Feuer' beim bewegen";

-- Misc
AIF_LOADED = "AutoInnerFire geladen, benutze /autoinnerfire oder /aif";
AIF_PROFILE_CREATING = "AutoInnerFire Profil erstellt von: ";
AIF_PROFILE_LOADED_1 = "<AIF> Profil von '";
AIF_PROFILE_LOADED_2 = "' geladen.";
AIF_DISABLED = "<AIF> AutoInnerFire deaktiviert - du spielst keinen Priester.";

-- Options Frame
AIF_OPTIONS_TITLE = "AutoInnerFire "..AIF_SHORTVERSION;
AIF_OPTIONS_ON = "An/Aus";
AIF_OPTIONS_BUTTON = "Button An/Aus";
AIF_OPTIONS_COMBAT = "Buff im Kampf";
AIF_OPTIONS_BUTPOS = "Minimap Button Position ";
AIF_OPTIONS_THRESHOLD = "Mana Schwelle";
AIF_OPTIONS_DEFAULTS = "Standard";

end


--------------------------------------------------------------------------------------------------
-- FR (Frence)
--------------------------------------------------------------------------------------------------
if ( GetLocale() == "frFR" ) then
-- È: C3 A9  - \195\169
-- Í: C3 AA  - \195\170
-- ‡: C3 A0  - \195\160
-- Ó: C3 AE  - \195\174
-- Ë: C3 A8  - \195\168
-- Î: C3 AB  - \195\171
-- Ù: C3 B4  - \195\180
-- ˚: C3 BB  - \195\187
-- ‚: C3 A2  - \195\162
-- Á: C3 A7  - \185\167
--
-- ': E2 80 99  - \226\128\153
	
-- Names
AIF_SPELLNAME = "Feu int\195\169rieur";

-- Slash Commadns help
AIF_HELP1 = "Configurer avec |cffff0000/autoinnerfire|r";
AIF_HELP2 = "Options :"
AIF_HELP3 = "|cffffff00on|r (Active AutoInnerFire)";
AIF_HELP4 = "|cffffff00off|r (Desactive AutoInnerFire)";
AIF_HELP5 = "|cffffff00threshold|r |cffff0000XX|r (Fixe la limite de mana / XX = mana in percent)";
AIF_HELP6 = "|cffffff00combat|r (toggles buff in combat)";
AIF_HELP7 = "";
AIF_HELP8 = "|cffffff00button|r (toggles minimap button)";
AIF_HELP9 = "|cffffff00position|r |cffff0000XX|r (changes minimap Button position / XX = degree)";
AIF_HELP10 = "|cffffff00options|r (options frame)";

-- Slash Commands reply
AIF_ON = "AutoInnerFire activ\195\169.";
AIF_OFF = "AutoInnerFire desactiv\195\169.";
AIF_THRESHOLD = "Limite de mana fix\195\169e a : ";
AIF_COMBAT_ON = "Buff in combat enabled.";
AIF_COMBAT_OFF = "Buff in combat disabled.";
AIF_BUTTON_ON = "Minimap Button enabled.";
AIF_BUTTON_OFF = "Minimap Button disabled.";
AIF_POS = "Minimap Button Position changed to ";

-- MyAddons
AIF_MYADDONS_NAME = "AutoInnerFire"
AIF_MYADDONS_DESCRIPTION = "Lance automatiquement 'Feu int\195\169rieur' si besoin, lors d'un mouvement.";

-- Misc
AIF_LOADED = "AutoInnerFire charg\195\169, utilisez /autoinnerfire ou /aif";
AIF_PROFILE_CREATING = "Profil AutoInnerFire cr\195\169\195\169 depuis : ";
AIF_PROFILE_LOADED_1 = "Profil charg\195\169 depuis '";
AIF_PROFILE_LOADED_2 = "'.";
AIF_DISABLED = "<AIF> AutoInnerFire disabled - you don't play a priest.";

-- Options Frame
AIF_OPTIONS_TITLE = "AutoInnerFire "..AIF_SHORTVERSION;
AIF_OPTIONS_ON = "Activ√©/D√©sactiv√©";
AIF_OPTIONS_BUTTON = "Button Activ√©/D√©sactiv√©";
AIF_OPTIONS_COMBAT = "Buff in combat";
AIF_OPTIONS_BUTPOS = "Minimap Button Position ";
AIF_OPTIONS_THRESHOLD = "Fixe la limite de mana";
AIF_OPTIONS_DEFAULTS = "D\195\169faut";

end

--------------------------------------------------------------------------------------------------
-- AutoInnerFire - END OF FILE
--------------------------------------------------------------------------------------------------