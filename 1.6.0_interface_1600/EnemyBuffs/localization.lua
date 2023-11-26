-- Templates

EnemyBuffs_Template_Death = {
	msg = "UNITDIESOTHER";
	performerIndex = 1;
	-- actionIndex = 2;
	--targetIndex = 1;
	type = "death";
};

EnemyBuffs_Template_DispelOther = {
	msg = "AURADISPELOTHER";
	-- performerIndex = 1; -- this is not totally adequate. We do not know who causes this to happen, so...
	actionIndex = 2;
	targetIndex = 1;
	type = "dispel";
};

EnemyBuffs_Template_FadeOther = {
	msg = "AURAREMOVEDOTHER";
	--performerIndex = 1;
	actionIndex = 1;
	targetIndex = 2;
	type = "fade";
};

-- ERROR messages. These need not be localized, as they are the result of sloppy coding. 
-- Coders should be able to read English or suffer the consequences.


-- WARNING messages. These need not be localized, as they are the result of sloppy coding or strange code flows.
-- Coders should be able to read English or suffer the consequences.



