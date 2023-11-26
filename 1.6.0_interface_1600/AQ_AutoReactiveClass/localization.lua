
AUTOREACTIVE_CLASS_WARRIOR					= "Warrior";
AUTOREACTIVE_CLASS_HUNTER					= "Hunter";
AUTOREACTIVE_CLASS_ROGUE					= "Rogue";
AUTOREACTIVE_CLASS_SHAMAN					= "Shaman";

-- Warrior

AUTOREACTIVE_STANCE_BATTLE					= "Battle Stance";
AUTOREACTIVE_STANCE_DEFENSIVE				= "Defensive Stance";
AUTOREACTIVE_STANCE_BERSERKER				= "Berserker Stance";

AUTOREACTIVECLASS_OVERPOWER_NAME			= "Overpower";
AUTOREACTIVECLASS_REVENGE_NAME				= "Revenge";

-- Hunter

AUTOREACTIVECLASS_MONGOOSE_BITE_NAME		= "Mongoose Bite";

-- Rogue

AUTOREACTIVECLASS_RIPOSTE_NAME				= "Riposte";
AUTOREACTIVECLASS_KICK_NAME					= "Kick";
AUTOREACTIVECLASS_KIDNEY_SHOT_NAME			= "Kidney Shot";

-- Shaman

AUTOREACTIVECLASS_EARTH_SHOCK_NAME			= "Earth Shock";

AUTOREACTIVECLASS_SHAMAN_CLEARCAST_NAME		= "Clearcasting";
AUTOREACTIVECLASS_SHAMAN_CLEARCAST_TEXTURE	= "Interface\\Icons\\Spell_Shadow_Manaburn";

-- Message format

AUTOREACTIVECLASS_MESSAGE_FORMAT			= "Use %s!";

AUTOREACTIVECLASS_PERFORMED_BY_ON_FORMAT	= "%s is doing %s on %s";
AUTOREACTIVECLASS_PERFORMED_BY_FORMAT		= "%s is doing %s";
AUTOREACTIVECLASS_INVOLVING_FORMAT			= "%s gets %s";

AUTOREACTIVECLASS_CAST_BY_ON_FORMAT			= "%s is casting %s on %s";
AUTOREACTIVECLASS_CAST_BY_FORMAT			= "%s is casting %s";
AUTOREACTIVECLASS_CAST_FORMAT				= "%s gets %s";

-- Options

AUTOREACTIVECLASS_CONFIG_HEADER				= "[AQ] AutoReactiveClass";
AUTOREACTIVECLASS_CONFIG_HEADER_INFO		= "Contains settings for the AutoReactiveClass AddOn. This addon allows the user to see when certain abilities are available and for queueing them up for execution.";

AUTOREACTIVECLASS_CONFIG_ENABLED			= "Enabled";
AUTOREACTIVECLASS_CONFIG_ENABLED_INFO		= "Enables/disables AQ_AutoReactiveClass. This allows for complete disabling of the addon. The addon will still remain in memory, but will not take any actions if disabled.";

AUTOREACTIVECLASS_CONFIG_SHOW_MESSAGE		= "Show message";
AUTOREACTIVECLASS_CONFIG_SHOW_MESSAGE_INFO	= "Controls whether a message should appear when a monitored ability is ready to be used.";

AUTOREACTIVECLASS_CONFIG_QUEUE_ACTION		= "Queue action";
AUTOREACTIVECLASS_CONFIG_QUEUE_ACTION_INFO	= "Controls whether an action should be queued when a monitored ability is ready to be used.";


AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_ALWAYS = "Use highest rank Earth Shock Always";
AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_ALWAYS_INFO = "Will make sure that the highest rank of the Earth Shock spell is used. This is not recommended for normal casting interruption (PvE).";

AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_WHEN_CLEARCASTING = "Use highest rank ES when Clearcasting active";
AUTOREACTIVECLASS_CONFIG_SHAMAN_USE_HIGHEST_EARTH_SHOCK_WHEN_CLEARCASTING_INFO = "Will make sure that the highest rank of the Earth Shock spell is used when Clearcasting is active.";

-- Khaos 

AUTOREACTIVECLASS_STATE_ENABLED				= "enabled";
AUTOREACTIVECLASS_STATE_DISABLED			= "disabled";
AUTOREACTIVECLASS_STATE_TEXT				= "Option";


-- Spell interruption specific stuff

AutoReactiveClass_SpellsThatShouldNotBeInterrupted = {
	"Frost Breath", -- not worth it and not easy to trigger in time
	"Shoot",
	"Shoot Gun",
	"Shoot Bow",
	"Shoot Crossbow",
	"Hearthstone",
	"Opening"
};


-- Rogue specific stuff

AutoReactiveClass_Rogue_SpellsThatCanNotBeKickInterrupted = {
	"Black Sludge",
	"Clone",
	"Dire Growl",
	"Encasing Webs",
	"Frost Breath",
	"Healing Ward",
	"Melt Ore",
	"Summon Remote-Controlled Golem", 
	"Fire Shield II"
};



