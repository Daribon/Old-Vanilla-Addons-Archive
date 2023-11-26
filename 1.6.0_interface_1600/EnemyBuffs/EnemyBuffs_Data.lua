-- START DOES NOT NEED TO BE LOCALIZED
if ( not ENEMYBUFFS_RADIATION ) then
	ENEMYBUFFS_RADIATION = "Interface\\Icons\\INV_Enchant_EssenceNetherLarge";
end
-- END DOES NOT NEED TO BE LOCALIZED


EnemyBuffs_BuffMap = {
};

EnemyBuffs_BuffType = {
};

function EnemyBuffs_MergeBuffMap(buffMap)
	for k, v in buffMap do
		EnemyBuffs_BuffMap[k] = v;
	end
end


local m = "Magic";
EnemyBuffs_BuffType_English = {
	["Gift of the Wild"] = m;
	["Mark of the Wild"] = m;
	["Thorns"] = m;

	["Trueshot Aura"] = m;

	["Arcane Intellect"] = m;
	["Arcane Brilliance"] = m;
	["Frost Armor"] = m;
	["Ice Armor"] = m;
	["Mage Armor"] = m;
	["Mana Shield"] = m;
	["Feather Fall"] = m;
	["Fire Ward"] = m;
	["Frost Ward"] = m;

	["Blessing of Wisdom"] = m;

	["Power Word: Fortitude"] = m;
	["Prayer of Fortitude"] = m;
	["Divine Spirit"] = m;
	["Power Word: Shield"] = m;
	["Renew"] = m;
	["Shadowguard"] = m;
	["Elune's Grace"] = m;
	
	["Lightning Shield"] = m;

	["Demon Armor"] = m;
	["Demon Skin"] = m;
	["Underwater Breathing"] = m;
	["Detect Greater Invisibility"] = m;
	["Detect Invisibility"] = m;
	["Detect Lesser Invisibility"] = m;
	["Shadow Ward"] = m;

};

EnemyBuffs_BuffMap_English = {

-- Druid

	["Gift of the Wild"] = "Interface\\Icons\\Spell_Nature_Regeneration";
	["Mark of the Wild"] = "Interface\\Icons\\Spell_Nature_Regeneration";
	["Thorns"] = "Interface\\Icons\\Spell_Nature_Thorns";

-- Hunter

	["Trueshot Aura"] = "Interface\\Icons\\Ability_TrueShot";
	["Feign Death"] = "Interface\\Icons\\Ability_Rogue_FeignDeath";

-- Mage

	["Arcane Brilliance"] = "Interface\\Icons\\Spell_Holy_ArcaneIntellect";
	["Arcane Intellect"] = "Interface\\Icons\\Spell_Holy_MagicalSentry";

	["Frost Armor"] = "Interface\\Icons\\Spell_Frost_FrostArmor02";
	["Ice Armor"] = "Interface\\Icons\\Spell_Frost_ChillingArmor";
	["Mage Armor"] = "Interface\\Icons\\Spell_Magic_MageArmor";

	["Feather Fall"] = "Interface\\Icons\\Spell_Magic_FeatherFall";

	["Fire Ward"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Frost Ward"] = "Interface\\Icons\\Spell_Frost_FrostWard";
	
	["Mana Shield"] = "Interface\\Icons\\Spell_Holy_BlessingOfProtection";


-- Paladin

	["Blessing of Wisdom"] = "Interface\\Icons\\Spell_Holy_SealOfWisdom";
	["Devotion Aura"] = "Interface\\Icons\\Spell_Holy_DevotionAura";
	["Retribution Aura"] = "Interface\\Icons\\Spell_Holy_AuraOfLight";

-- Priest

	["Inner Fire"] = "Interface\\Icons\\Spell_Holy_InnerFire";
	["Divine Spirit"] = "Interface\\Icons\\Spell_Holy_WordFortitude";
	["Power Word: Fortitude"] = "Interface\\Icons\\Spell_Holy_WordFortitude";
	["Prayer of Fortitude"] = "Interface\\Icons\\Spell_Holy_PrayerOfFortitude";
	["Renew"] = "Interface\\Icons\\Spell_Holy_Renew";
	["Power Word: Shield"] = "Interface\\Icons\\Spell_Holy_PowerWordShield";
	["Shadowguard"] = "Interface\\Icons\\INV_Misc_ShadowEgg";
	["Elune's Grace"] = "Interface\\Icons\\Spell_Nature_SpiritArmor";

-- Rogue

	["Sprint"] = "Interface\\Icons\\Ability_Rogue_Sprint";
	["Evasion"] = "Interface\\Icons\\Spell_Shadow_ShadowWard";

-- Shaman

	["Lightning Shield"] = "Interface\\Icons\\Spell_Nature_LightningShield";

-- Warlock

	["Blood Pact"] = "Interface\\Icons\\Spell_Shadow_BloodBoil";
	["Demon Skin"] = "Interface\\Icons\\Spell_Shadow_RagingScream";
	["Demon Armor"] = "Interface\\Icons\\Spell_Shadow_RagingScream";
	["Underwater Breathing"] = "Interface\\Icons\\Spell_Shadow_DemonBreath";
	["Detect Greater Invisibility"] = "Interface\\Icons\\Spell_Shadow_DetectInvisibility";
	["Detect Invisibility"] = "Interface\\Icons\\Spell_Shadow_DetectInvisibility";
	["Detect Lesser Invisibility"] = "Interface\\Icons\\Spell_Shadow_DetectLesserInvisibility";
	
	["Shadow Ward"] = "Interface\\Icons\\Spell_Shadow_ShadowWard";

-- Warrior

	["Battle Shout"] = "Interface\\Icons\\Ability_Warrior_BattleShout";
	["Shield Wall"] = "Interface\\Icons\\Ability_Warrior_ShieldWall";

-- Racial

	["Berserking"] = "Interface\\Icons\\Racial_Troll_Berserk";

-- Mob spells

	["Fire Shield"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield I"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield II"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield III"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield IV"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield V"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield 1"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield 2"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield 3"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield 4"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	["Fire Shield 5"] = "Interface\\Icons\\Spell_Fire_FireArmor";
	
	["Shadow Shield"] = "Interface\\Icons\\Spell_Shadow_GrimWard";
	
	["Invisibility"] = "Interface\\Icons\\Spell_Nature_Invisibilty";
	["Lesser Invisibility"] = "Interface\\Icons\\Spell_Magic_LesserInvisibilty";
	["Greater Invisibility"] = "Interface\\Icons\\Spell_Nature_Invisibilty";

-- Mob abilities

	["Enrage"] = "Interface\\Icons\\Ability_Racial_BloodRage";

	["Radiation"] = ENEMYBUFFS_RADIATION;
	["Rebuild"] = "Interface\\Icons\\Ability_Repair";

	-- may be replaced with happy burning spirit instead
	["Burning Spirit"] = "Interface\\Icons\\Spell_Shadow_BurningSpirit";
	["Supercharge"] = "Interface\\Icons\\Spell_Nature_StrengthOfEarthTotem02";

-- Listed but not yet assigned texture


-- Ignore Buffs

	["Flurry"] = false;
	["2 extra attacks through Thrash"] = false;
	["1 Rage"] = false;
	["10 Rage"] = false;
	
	--[[
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	[""] = "Interface\\Icons\\";
	]]--

};

EnemyBuffs_DefaultBuffs = {
};

EnemyBuffs_DefaultBuffs_English = {
	["Defias Pillager"] = { "Frost Armor" };
};

EnemyBuffs_Localization_Suffix = "";

if ( GetLocale ) and ( GetLocale() ~= "frFR" ) and ( GetLocale() ~= "deDE" ) and ( GetLocale() ~= "krKR" ) then
	EnemyBuffs_Localization_Suffix = "English";
else
	EnemyBuffs_BuffMap_English = nil;
	EnemyBuffs_BuffType_English = nil;
	EnemyBuffs_DefaultBuffs_English = nil;
end

