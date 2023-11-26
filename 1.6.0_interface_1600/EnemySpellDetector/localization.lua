ENEMYSPELLDETECTOR_TARGET_SELF	= "you";

-- Templates

-- these could somply 
EnemySpellDetector_Template_Gain = {
	msg = "AURAADDEDOTHERHELPFUL";
	-- performerIndex = 1; -- this is not totally adequate. We do not know who causes this to happen, so...
	actionIndex = 2;
	targetIndex = 1;
	type = "gain";
};

EnemySpellDetector_Template_PerformOther = {
	msg = "SIMPLEPERFORMOTHEROTHER";
	performerIndex = 1;
	actionIndex = 2;
	targetIndex = 3;
	type = "perform";
};

EnemySpellDetector_Template_PerformSelf = {
	msg = "SPELLTERSEPERFORM_OTHER";
	performerIndex = 1;
	actionIndex = 2;
	targetIndex = 1;
	type = "perform";
};
EnemySpellDetector_Template_CastTerse = {
	msg = "SPELLTERSE_OTHER";
	performerIndex = 1;
	actionIndex = 2;
	--targetIndex = 1; -- as above, we're not sure what the target is.
	type = "cast";
};

EnemySpellDetector_Template_CastOther = {
	msg = "SIMPLECASTOTHEROTHER";
	performerIndex = 1;
	actionIndex = 2;
	targetIndex = 3;
	type = "cast";
};

EnemySpellDetector_Template_BeginCast = {
	msg = "SPELLCASTOTHERSTART";
	performerIndex = 1;
	actionIndex = 2;
	--targetIndex = 3;
	type = "begincast";
};

EnemySpellDetector_Template_BeginPerform = {
	msg = "SPELLPERFORMOTHERSTART";
	performerIndex = 1;
	actionIndex = 2;
	--targetIndex = 3;
	type = "beginperform";
};

-- ERROR messages. These need not be localized, as they are the result of sloppy coding. 
-- Coders should be able to read English or suffer the consequences.

ENEMYSPELLDETECTOR_ERROR_NON_EVENTTYPE = "You have used a non-existing eventType. While it will be added to prevent fatal errors, please refrain from doing so in the future... or tell Sarf to get his butt off his chair and fix the event type.";
ENEMYSPELLDETECTOR_ERROR_MISSING_EVENTTYPE = "You have used a non-existing eventType.";

-- WARNING messages. These need not be localized, as they are the result of sloppy coding or strange code flows.
-- Coders should be able to read English or suffer the consequences.

ENEMYSPELLDETECTOR_WARNING_ADDED_EXISTING_LISTENER = "You have added an already existing listener. The old listener was removed and a new one added. Please refrain from doing this as it causes unnecessary processing.";

