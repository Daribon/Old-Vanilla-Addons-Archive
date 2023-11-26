-- This will not need to be localized, I hope.

EnemySpellDetector_AllTemplates = {
	EnemySpellDetector_Template_Gain,
	EnemySpellDetector_Template_PerformOther,
	EnemySpellDetector_Template_PerformSelf,
	EnemySpellDetector_Template_CastTerse,
	EnemySpellDetector_Template_CastOther,
	EnemySpellDetector_Template_BeginCast,
	EnemySpellDetector_Template_BeginPerform
};

EnemySpellDetector_ChatMessages = {
	CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = {
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_CastTerse,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF = {
		EnemySpellDetector_Template_Gain,
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_PerformSelf,
		EnemySpellDetector_Template_CastTerse,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = {
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_CastTerse,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS = EnemySpellDetector_AllTemplates;
	CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = EnemySpellDetector_AllTemplates;
	CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS = EnemySpellDetector_AllTemplates;
	CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE = {
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF = {
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE = {
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_CastTerse,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF = {
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = {
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_CastTerse,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
	CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF = {
		EnemySpellDetector_Template_Gain,
		EnemySpellDetector_Template_CastOther,
		EnemySpellDetector_Template_PerformOther,
		EnemySpellDetector_Template_PerformSelf,
		EnemySpellDetector_Template_CastTerse,
		EnemySpellDetector_Template_BeginCast,
		EnemySpellDetector_Template_BeginPerform
	};
};