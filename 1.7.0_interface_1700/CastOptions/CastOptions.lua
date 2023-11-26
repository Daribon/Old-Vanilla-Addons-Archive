--[[
	Cast Options
	 	Provides enchanced casting options such as auto self casting
	
	By: Mugendai
	Special Thanks:
		Telo - Orgigional concept for Self Cast
		Sarf - For making the origional Addon
		Exi and Miravlix -	For doing some rewriting and initial implimentation of Smart Ranks,
												resulting in prompting me to go ahead and do the rewrite.
		Some Other People -	For the concept of smart ranks, and their implementations.
												The info on the spell ranks, and some of the code related to them
												is based on someone elses work.  I do not know who, but whoever
												they are, they deserve credit for it.  If you wanna claim credit
												for this, then let me, Mugendai know.
		Wh1sper -	For the concept of Smart Assist Casting, and for going through the trouble to
							workout the textures for allmsot all the hostile, and self cast spells.
	Contact: mugekun@gmail.com
	
	Cast Options is a mod to allow the user to customize the way in which they cast spells.  It
	allows the user to choose a key to press in combination with a key to cast a spell, and in
	turn, cast the spell on themselves.  It also adds a smart casting mode that will cast any
	positive spells on the caster if the caster doesn't have a friendly target selected.  It
	also adds an option to cast buffs that can't be cast on lower level characters at	a lower
	rank so that the highest rank spell that can be cast on that player is cast.  It allows the
	user to cast hostile spells at the target of their friends, without detargeting their
	friends.  It also allows has the ability pick the target of friendly spells when in a gruop
	based on the type of spell, and the current status of the group members, and do so without
	retargeting from their current target.
	
	$Id: CastOptions.lua 2174 2005-07-27 02:21:50Z mugendai $
	$Rev: 2174 $
	$LastChangedBy: mugendai $
	$Date: 2005-07-26 21:21:50 -0500 (Tue, 26 Jul 2005) $
]]--

--------------------------------------------------
--
-- CastOptions Declaration
--
--------------------------------------------------
CastOptions = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	VERSION = 1.77;
	MAINTAINER = "mugekun@gmail.com";
	MAX_RECAST = 60;
	MAX_BOUNDDELAY = 5;
	MAX_ID = 120;
	SHOT_CANCELED_HOLD_TIME = 1;
	BOUND_HOLD_TIME = 1;
	NOTARG_HOLD_TIME = 1;
	
	--------------------------------------------------
	--
	-- Spell Information
	--
	--------------------------------------------------
	SpellData = {
		--Spells that should be cast on player if there is no friendly target
		--Set any of the options to a true value to set it
		--h - this spell heals
		--n - this spell boosts mana
		--b - this spell has a buff(including heal spells that do heal over time
		--p - this spell cures poison
		--c - this spell removes curses
		--d - this spell cures disease
		--m - this spell removes magic effects
		--r - this spell must have a range specifier in the tooltip to match
		--g - this spell can only be cast on group members
		--f - this spell is a first aid spell that channels
		--t - the texture of the buff, if it is different from the spell

		Self = {
			DRUID = {
				["Interface\\Icons\\Spell_Nature_NullifyPoison_02"] = {p=1;b=1;};			--Abolish Poison
				["Interface\\Icons\\Spell_Nature_NullifyPoison"] = {p=1;};							--Cure Poison
				["Interface\\Icons\\Spell_Nature_HealingTouch"] = {h=1;};							--Healing Touch
				["Interface\\Icons\\Spell_Nature_Lightning"] = {b=1;n=1;};						--Innervate
				["Interface\\Icons\\Spell_Nature_Regeneration"] = {b=1;};							--Mark of the Wild
				["Interface\\Icons\\Spell_Nature_ResistNature"] = {h=1;b=1;};					--Regrowth
				["Interface\\Icons\\Spell_Nature_Rejuvenation"] = {h=1;b=1;};					--Rejuvenation
				["Interface\\Icons\\Spell_Holy_RemoveCurse"] = {c=1;};								--Remove Curse
				["Interface\\Icons\\Spell_Nature_Thorns"] = {b=1;};										--Thorns
			};
			HUNTER = {
				--["Interface\\Icons\\"] = 0;	--
			};
			MAGE = {
				["Interface\\Icons\\Spell_Holy_FlashHeal"] = {b=1;g=1;};							--Amplify Magic
				["Interface\\Icons\\Spell_Holy_MagicalSentry"] = {b=1;};							--Arcane Intellect
				["Interface\\Icons\\Spell_Nature_AbolishMagic"] = {b=1;g=1;};					--Dampen Magic
				["Interface\\Icons\\Spell_Nature_RemoveCurse"] = {c=1;};							--Remove Lesser Curse
			};
			PALADIN = {
				["Interface\\Icons\\Spell_Holy_SealOfValor"] = {b=1;};								--Blessing of Freedom
				["Interface\\Icons\\Spell_Magic_MageArmor"] = {b=1;};									--Blessing of Kings
				["Interface\\Icons\\Spell_Holy_PrayerOfHealing02"] = {b=1;};					--Blessing of Light
				["Interface\\Icons\\Spell_Holy_FistOfJustice"] = {b=1;};							--Blessing of Might
				["Interface\\Icons\\Spell_Holy_SealOfProtection"] = {b=1;g=1;};				--Blessing of Protection
				["Interface\\Icons\\Spell_Holy_SealOfSacrifice"] = {b=1;r=1;};				--Blessing of Sacrifice
				["Interface\\Icons\\Spell_Holy_SealOfSalvation"] = {b=1;g=1;};				--Blessing of Salvation
				["Interface\\Icons\\Spell_Nature_LightningShield"] = {b=1;};					--Blessing of Sanctuary
				["Interface\\Icons\\Spell_Holy_SealOfWisdom"] = {b=1;n=1;};						--Blessing of Wisdom
				["Interface\\Icons\\Spell_Holy_Renew"] = {p=1;d=1;m=1;};							--Cleanse
				["Interface\\Icons\\Spell_Nature_TimeStop"] = {b=1;g=1;};							--Divine Intervention
				["Interface\\Icons\\Spell_Holy_FlashHeal"] = {h=1;};									--Flash of Light
				["Interface\\Icons\\Spell_Holy_HolyBolt"] = {h=1;};										--Holy Light
				["Interface\\Icons\\Spell_Holy_LayOnHands"] = {h=1;};									--Lay on Hands
				["Interface\\Icons\\Spell_Holy_Purify"] = {p=1;d=1;};									--Purify
			};
			PRIEST = {
				["Interface\\Icons\\Spell_Nature_NullifyDisease"] = {p=1;b=1;};				--Abolish Disease
				["Interface\\Icons\\Spell_Holy_NullifyDisease"] = {d=1;};							--Cure Disease
				["Interface\\Icons\\Spell_Holy_DispelMagic"] = {m=1;};								--Dispel Magic (neutral)
				["Interface\\Icons\\Spell_Holy_HolyProtection"] = {b=1;};							--Divine Spirit
				["Interface\\Icons\\Spell_Holy_Excorcism"] = {b=1;};									--Fear Ward
				["Interface\\Icons\\Spell_Holy_FlashHeal"] = {h=1;};									--Flash Heal
				["Interface\\Icons\\Spell_Holy_GreaterHeal"] = {h=1;};								--Greater Heal
				["Interface\\Icons\\Spell_Holy_Heal"] = {h=1;};												--Heal
				["Interface\\Icons\\Spell_Holy_Heal02"] = {h=1;};											--Heal
				["Interface\\Icons\\Spell_Holy_LesserHeal"] = {h=1;};									--Lesser Heal
				["Interface\\Icons\\Spell_Holy_LesserHeal02"] = {h=1;};								--Lesser Heal
				["Interface\\Icons\\Spell_Holy_WordFortitude"] = {b=1;};							--Power Word: Fortitude
				["Interface\\Icons\\Spell_Holy_PowerWordShield"] = {b=1;g=1;};					--Power Word: Shield
				["Interface\\Icons\\Spell_Holy_PrayerOfFortitude"] = {b=1;};					--Prayer of Fortitude
				["Interface\\Icons\\Spell_Holy_Renew"] = {h=1;};											--Renew
				["Interface\\Icons\\Spell_Shadow_AntiShadow"] = {b=1;};								--Shadow Protection
			};
			ROGUE = {
				--["Interface\\Icons\\"] = 0;	--
			};
			SHAMAN = {
				["Interface\\Icons\\Spell_Nature_HealingWaveGreater"] = {h=1;};				--Chain Heal
				["Interface\\Icons\\Spell_Nature_RemoveDisease"] = {d=1;};						--Cure Disease
				["Interface\\Icons\\Spell_Nature_NullifyPoison"] = {p=1;};						--Cure Poison
				["Interface\\Icons\\Spell_Nature_MagicImmunity"] = {h=1;};						--Healing Wave
				["Interface\\Icons\\Spell_Nature_HealingWaveLesser"] = {h=1;};				--Lesser Healing Wave
				["Interface\\Icons\\Spell_Shadow_DemonBreath"] = {b=1;};							--Water Breathing
				["Interface\\Icons\\Spell_Frost_WindWalkOn"] = {b=1;};								--Water Walking
			};
			WARLOCK = {
				["Interface\\Icons\\Spell_Shadow_DetectInvisibility"] = {b=1;};				--Detect Invisibility and Greater Invisibility
				["Interface\\Icons\\Spell_Shadow_DetectLesserInvisibility"] = {b=1;};	--Detect Lesser Invisibility
				["Interface\\Icons\\Spell_Shadow_DemonBreath"] = {b=1;};							--Unending Breath
			};
			WARRIOR = {
				--["Interface\\Icons\\"] = 0;	--
			};
			--List of any container items that should be self cast
			Container = {
				--First Aid
				["Interface\\Icons\\INV_Misc_Bandage_15"] = {h=1;f=1;};								--Linen Bandage
				["Interface\\Icons\\INV_Misc_Bandage_18"] = {h=1;f=1;};								--Heavy Linen Bandage
				["Interface\\Icons\\INV_Misc_Bandage_14"] = {h=1;f=1;};								--Wool Bandage
				["Interface\\Icons\\INV_Misc_Bandage_17"] = {h=1;f=1;};								--Heavy Wool Bandage
				["Interface\\Icons\\INV_Misc_Bandage_01"] = {h=1;f=1;};								--Silk Bandage
				["Interface\\Icons\\INV_Misc_Bandage_02"] = {h=1;f=1;};								--Heavy Silk Bandage
				["Interface\\Icons\\INV_Misc_Bandage_19"] = {h=1;f=1;};								--Mageweave Bandage
				["Interface\\Icons\\INV_Misc_Bandage_20"] = {h=1;f=1;};								--Heavy Mageweave Bandage
				["Interface\\Icons\\INV_Misc_Bandage_11"] = {h=1;f=1;};								--Runecloth Bandage
				["Interface\\Icons\\INV_Misc_Bandage_12"] = {h=1;f=1;};								--Heavy Runecloth Bandage
				["Interface\\Icons\\INV_Misc_Slime_01"] = {p=1;};											--Anti-Venom and Strong Anti-Venom
				--Scrolls
				--Prolly too indecisive to use
				--["Interface\\Icons\\INV_Scroll_01"] = {b=1;};													--Scroll of Spirit/Intellect
				--["Interface\\Icons\\INV_Scroll_02"] = {b=1;};													--Scroll of Agility/Strength
				--["Interface\\Icons\\INV_Scroll_0t"] = {b=1;};													--Scroll of Protection/Stamina
			};
		};
		--Spells that should be cast on friendlies hostile target
		Hostile = {
			DRUID = {
				["Interface\\Icons\\Ability_Druid_Bash"] = true;													--Bash
				["Interface\\Icons\\Ability_Druid_ChallangingRoar"] = true;								--Claw
				["Interface\\Icons\\Spell_Nature_StrangleVines"] = true;									--Entangling Roots
				["Interface\\Icons\\Spell_Nature_FaerieFire"] = true;											--Faerie Fire
				["Interface\\Icons\\Ability_Hunter_Pet_Bear"] = true;											--Feral Charge
				["Interface\\Icons\\Ability_Druid_FerociousBite"] = true;									--Ferocious Bite
				["Interface\\Icons\\Spell_Nature_Sleep"] = true;													--Hibernate
				["Interface\\Icons\\Ability_Druid_Maul"] = true;													--Maul
				["Interface\\Icons\\Spell_Nature_StarFall"] = true;												--Moonfire
				["Interface\\Icons\\Ability_Druid_SupriseAttack"] = true;									--Pounce
				["Interface\\Icons\\Ability_Druid_Disembowel"] = true;										--Rake
				["Interface\\Icons\\Ability_Druid_Ravage"] = true;												--Ravage
				["Interface\\Icons\\Ability_GhoulFrenzy"] = true;													--Rip
				["Interface\\Icons\\Spell_Shadow_VampiricAura"] = true;										--Shred
				["Interface\\Icons\\Ability_Hunter_BeastSoothe"] = true;									--Soothe Animal
				["Interface\\Icons\\Spell_Arcane_StarFire"] = true;												--Starfire
				["Interface\\Icons\\INV_Misc_MonsterClaw_03"] = true;											--Swipe
				["Interface\\Icons\\Spell_Nature_AbolishMagic"] = true;										--Wrath
			};
			HUNTER = {
				["Interface\\Icons\\INV_Spear_07"] = true;																--Aimed Shot
				["Interface\\Icons\\Ability_ImpalingBolt"] = true;												--Arcane Shot
				["Interface\\Icons\\Ability_Whirlwind"] = true;														--Auto Shot
				["Interface\\Icons\\Spell_Frost_Stun"] = true;														--Concussive Shot
				--["Interface\\Icons\\Ability_Warrior_Challange"] = true;										--Counterattack (melee reactive)
				["Interface\\Icons\\Ability_Rogue_Feint"] = true;													--Disengage (melee)
				["Interface\\Icons\\Spell_Arcane_Blink"] = true;													--Distracting Shot
				["Interface\\Icons\\Ability_Hunter_SniperShot"] = true;										--Hunter's Mark
				["Interface\\Icons\\Ability_Gouge"] = true;																--Lacerate (melee)
				--["Interface\\Icons\\Ability_Hunter_SwiftStrike"] = true;									--Mongoose Bite (melee reactive)
				["Interface\\Icons\\Ability_UpgradeMoonGlaive"] = true;										--Multi-Shot
				["Interface\\Icons\\Ability_MeleeDamage"] = true;													--Raptor Strike (melee)
				["Interface\\Icons\\Ability_Druid_Cower"] = true;													--Scare Beast
				["Interface\\Icons\\Ability_GolemStormBolt"] = true;											--Scatter Shot
				["Interface\\Icons\\Ability_Hunter_CriticalShot"] = true;									--Scorpid Sting
				["Interface\\Icons\\Ability_Hunter_Quickshot"] = true;										--Serpent Sting
				["Interface\\Icons\\Ability_Marksmanship"] = true;												--Shoot
				["Interface\\Icons\\Ability_Hunter_AimedShot"] = true;										--Viper Sting
				["Interface\\Icons\\Ability_Rogue_Trip"] = true;													--Wing Clip (melee)
			};
			MAGE = {
				["Interface\\Icons\\Spell_Nature_StarFall"] = true;												--Arcane Missiles
				["Interface\\Icons\\Spell_Frost_IceShock"] = true;												--Counterspell
				["Interface\\Icons\\Spell_Holy_Dizzy"] = true;														--Detect Magic
				["Interface\\Icons\\Spell_Fire_Fireball"] = true;													--Fire Blast
				["Interface\\Icons\\Spell_Fire_FlameBolt"] = true;												--Fireball
				["Interface\\Icons\\Spell_Frost_FrostBolt02"] = true;											--Frostbolt
				["Interface\\Icons\\Spell_Nature_Polymorph"] = true;											--Polymorph
				["Interface\\Icons\\Spell_Fire_Fireball02"] = true;												--Pyroblast
				["Interface\\Icons\\Spell_Fire_SoulBurn"] = true;													--Scorch
				["Interface\\Icons\\Ability_ShootWand"] = true;														--Shoot (Wand)
			};
			PALADIN = {
				["Interface\\Icons\\Spell_Holy_Excorcism_02"] = true;											--Exorcism
				["Interface\\Icons\\Spell_Holy_SealOfMight"] = true;											--Hammer of Justice
				["Interface\\Icons\\Spell_Holy_SearingLight"] = true;											--Holy Shock
				["Interface\\Icons\\Spell_Holy_RighteousFury"] = true;										--Judgement (melee)
				["Interface\\Icons\\Spell_Holy_PrayerOfHealing"] = true;									--Repentance
				["Interface\\Icons\\Spell_Holy_TurnUndead"] = true;												--Turn Undead
			};
			PRIEST = {
				["Interface\\Icons\\Spell_Shadow_BlackPlague"] = true;										--Devouring Plague
				["Interface\\Icons\\Spell_Holy_DispelMagic"] = true;											--Dispel Magic (neutral)
				["Interface\\Icons\\Spell_Shadow_FingerOfDeath"] = true;									--Hex of Weakness
				["Interface\\Icons\\Spell_Holy_SearingLight"] = true;											--Holy Fire
				["Interface\\Icons\\Spell_Shadow_UnholyFrenzy"] = true;										--Mind Blast
				["Interface\\Icons\\Spell_Shadow_ManaBurn"] = true;												--Mana Burn
				["Interface\\Icons\\Spell_Shadow_ShadowWordDominate"] = true;							--Mind Control
				["Interface\\Icons\\Spell_Shadow_SiphonMana"] = true;											--Mind Flay
				["Interface\\Icons\\Spell_Holy_MindSooth"] = true;												--Mind Soothe
				["Interface\\Icons\\Spell_Holy_MindVision"] = true;												--Mind Vision
				["Interface\\Icons\\Spell_Nature_Slow"] = true;														--Shackle Undead
				["Interface\\Icons\\Spell_Shadow_ShadowWordPain"] = true;									--Shadow Word: Pain
				["Interface\\Icons\\Ability_ShootWand"] = true;														--Shoot (Wand)
				["Interface\\Icons\\Spell_Shadow_ImpPhaseShift"] = true;									--Silence
				["Interface\\Icons\\Spell_Holy_HolySmite"] = true;												--Smite
				["Interface\\Icons\\Spell_Arcane_StarFire"] = true;												--Starshards
				["Interface\\Icons\\Spell_Shadow_UnsummonBuilding"] = true;								--Vampiric Embrace
			};
			ROGUE = {
				["Interface\\Icons\\Ability_Rogue_Ambush"] = true;												--Ambush (meles)
				["Interface\\Icons\\Ability_Whirlwind"] = true;														--Auto Shot
				["Interface\\Icons\\Ability_BackStab"] = true;														--Backstab (melee)
				["Interface\\Icons\\Spell_Shadow_MindSteal"] = true;											--Blind
				["Interface\\Icons\\Ability_CheapShot"] = true;														--Cheap Shot (melee)
				["Interface\\Icons\\Ability_Rogue_Eviscerate"] = true;										--Eviscerate (melee)
				["Interface\\Icons\\Ability_Warrior_Riposte"] = true;											--Expose Armor (melee)
				["Interface\\Icons\\Ability_Rogue_Feint"] = true;													--Feint (melee)
				["Interface\\Icons\\Ability_Rogue_Garrote"] = true;												--Garrote (melee)
				["Interface\\Icons\\Spell_Shadow_Curse"] = true;													--Ghostly Strike (melee)
				["Interface\\Icons\\Ability_Gouge"] = true;																--Gouge (melee)
				["Interface\\Icons\\Spell_Shadow_LifeDrain"] = true;											--Hemorrhage (melee)
				["Interface\\Icons\\Ability_Kick"] = true;																--Kick (melee)
				["Interface\\Icons\\Ability_Rogue_KidneyShot"] = true;										--Kidney Shot (melee)
				--["Interface\\Icons\\INV_Misc_Bag_11"] = true;															--Pick Pocket (melee)
				["Interface\\Icons\\Spell_Shadow_Possession"] = true;											--Premeditation
				--["Interface\\Icons\\Ability_Warrior_Challange"] = true;										--Riposte (melee and reactive)
				["Interface\\Icons\\Ability_Rogue_Rupture"] = true;												--Rupture (melee)
				["Interface\\Icons\\Ability_Sap"] = true;																	--Sap (melee)
				["Interface\\Icons\\Spell_Shadow_RitualOfSacrifice"] = true;							--Sinister Strike (melee)
				["Interface\\Icons\\Ability_Marksmanship"] = true;												--Shoot
			};
			SHAMAN = {
				["Interface\\Icons\\Spell_Nature_ChainLightning"] = true;									--Chain Lightning
				["Interface\\Icons\\Spell_Nature_EarthShock"] = true;											--Earth Shock
				["Interface\\Icons\\Spell_Fire_FlameShock"] = true;												--Flame Shock
				["Interface\\Icons\\Spell_Frost_FrostShock"] = true;											--Frost Shock
				["Interface\\Icons\\Spell_Nature_Lightning"] = true;											--Lightning Bolt
				["Interface\\Icons\\Spell_Nature_Purge"] = true;													--Purge
				["Interface\\Icons\\Spell_Holy_SealOfMight"] = true;											--Stormstrike (melee)
			};
			WARLOCK = {
				["Interface\\Icons\\Spell_Shadow_Cripple"] = true;												--Banish
				["Interface\\Icons\\Spell_Fire_Fireball"] = true;													--Conflagrate
				["Interface\\Icons\\Spell_Shadow_AbominationExplosion"] = true;						--Corruption
				["Interface\\Icons\\Spell_Shadow_CurseOfSargeras"] = true;								--Curse of Agony
				["Interface\\Icons\\Spell_Shadow_AuraOfDarkness"] = true;									--Curse of Doom
				["Interface\\Icons\\Spell_Shadow_GrimWard"] = true;												--Curse of Exhaustion
				["Interface\\Icons\\Spell_Shadow_UnholyStrength"] = true;									--Curse of Recklessness
				["Interface\\Icons\\Spell_Shadow_CurseOfAchimonde"] = true;								--Curse of Shadow
				["Interface\\Icons\\Spell_Shadow_ChillTouch"] = true;											--Curse of the Elements
				["Interface\\Icons\\Spell_Shadow_CurseOfTounges"] = true;									--Curse of Tongues
				["Interface\\Icons\\Spell_Shadow_CurseOfMannoroth"] = true;								--Curse of Weakness
				["Interface\\Icons\\Spell_Shadow_DeathCoil"] = true;											--Death Coil
				["Interface\\Icons\\Spell_Shadow_LifeDrain02"] = true;										--Drain Life
				["Interface\\Icons\\Spell_Shadow_SiphonMana"] = true;											--Drain Mana
				["Interface\\Icons\\Spell_Shadow_Haunting"] = true;												--Drain Soul
				["Interface\\Icons\\Spell_Shadow_EnslaveDemon"] = true;										--Enslave Demon
				["Interface\\Icons\\Spell_Shadow_Possession"] = true;											--Fear
				["Interface\\Icons\\Spell_Fire_Immolation"] = true;												--Immolate
				["Interface\\Icons\\Spell_Fire_SoulBurn"] = true;													--Searing Pain
				["Interface\\Icons\\Spell_Shadow_ScourgeBuild"] = true;										--Shadowburn
				["Interface\\Icons\\Spell_Shadow_ShadowBolt"] = true;											--Shadow Bolt
				["Interface\\Icons\\Ability_ShootWand"] = true;														--Shoot (Wand)
				["Interface\\Icons\\Spell_Shadow_Requiem"] = true;												--Siphon Life
				["Interface\\Icons\\Spell_Fire_Fireball02"] = true;												--Soul Fire
			};
			WARRIOR = {
				["Interface\\Icons\\Ability_Whirlwind"] = true;														--Auto Shot
				["Interface\\Icons\\Ability_Warrior_Charge"] = true;											--Charge
				["Interface\\Icons\\Ability_Warrior_Cleave"] = true;											--Cleave (melee)
				["Interface\\Icons\\Ability_ThunderBolt"] = true;													--Concussion Blow (melee)
				["Interface\\Icons\\Ability_Warrior_Disarm"] = true;											--Disarm (melee)
				["Interface\\Icons\\INV_Sword_48"] = true;																--Execute (melee)
				["Interface\\Icons\\Ability_ShockWave"] = true;														--Hamstring (melee)
				["Interface\\Icons\\Ability_Rogue_Ambush"] = true;												--Heroic Strike (melee)
				["Interface\\Icons\\Ability_Rogue_Sprint"] = true;												--Intercept
				["Interface\\Icons\\Ability_Warrior_PunishingBlow"] = true;								--Mocking Blow (melee)
				["Interface\\Icons\\Ability_Warrior_SavageBlow"] = true;									--Mortal Strike (melee)
				--["Interface\\Icons\\Ability_MeleeDamage"] = true;													--Overpower (melee reactive)
				["Interface\\Icons\\INV_Gauntlets_04"] = true;														--Pummel (melee)
				["Interface\\Icons\\Ability_Gouge"] = true;																--Rend (melee)
				--[Interface\\Icons\\Ability_Warrior_Revenge"] = true;											--Revenge (melee reactive)
				["Interface\\Icons\\Ability_Warrior_ShieldBash"] = true;									--Shield Bash (melee)
				["Interface\\Icons\\Ability_Marksmanship"] = true;												--Shoot
				["Interface\\Icons\\Ability_Warrior_DecisiveStrike"] = true;							--Slam (melee)
				["Interface\\Icons\\Ability_Warrior_Sunder"] = true;											--Sunder Armor (melee)
			};
			--List of any container items that should be hostile cast
			Container = {
				--["Interface\\Icons\\"] = true;	--
			};
		};
		Ranks = {
			DRUID = {
				["Interface\\Icons\\Spell_Nature_Regeneration"] = { 1, 10, 20, 30, 40, 50, 60 };							--Mark of the Wild
				["Interface\\Icons\\Spell_Nature_Rejuvenation"] = { 4, 10, 16, 22, 28, 34, 40, 46, 52, 58 };	--Rejuvination
				["Interface\\Icons\\Spell_Nature_Thorns"] = { 6, 14, 24, 34, 44, 54 };												--Thorns
				["Interface\\Icons\\Spell_Nature_ResistNature"] = { 12, 18, 24, 30, 36, 42, 48, 54, 60 };			--Regrowth
			};
			HUNTER = {
				--["Interface\\Icons\\"] = ;
			};
			MAGE = {
				["Interface\\Icons\\Spell_Holy_MagicalSentry"] = { 1, 14, 28, 42, 56 };												--Arcane Intellect
				["Interface\\Icons\\Spell_Nature_AbolishMagic"] = { 12, 24, 36, 48, 60 };											--Dampen Magic
				["Interface\\Icons\\Spell_Holy_FlashHeal"] = { 18, 30, 42, 54 };															--Amplify Magic
			};
			PALADIN = {
				["Interface\\Icons\\Spell_Holy_FistOfJustice"] = { 4, 12, 22, 32, 42, 52 };										--Blessing of Might
				["Interface\\Icons\\Spell_Holy_SealOfProtection"] = { 10, 24, 38 };														--Blessing of Protection
				["Interface\\Icons\\Spell_Holy_SealOfWisdom"] = { 14, 24, 34, 44, 54 };												--Blessing of Wisdom
				["Interface\\Icons\\Spell_Nature_LightningShield"] = { 1, 30, 40, 50, 60 };										--Blessing of Sanctuary
				["Interface\\Icons\\Spell_Holy_PrayerOfHealing02"] = { 40, 50, 60 };													--Blessing of Light
				["Interface\\Icons\\Spell_Holy_SealOfSacrifice"] = { 46, 54 };																--Blessing of Sacrifice
			};
			PRIEST = {
				["Interface\\Icons\\Spell_Holy_WordFortitude"] = { 1, 12, 24, 36, 48, 60 };										--Power Word Fortitude
				["Interface\\Icons\\Spell_Holy_PowerWordShield"] = { 6, 12, 18, 24, 30, 36, 42, 48, 54, 60 };	--Power Word Sield
				["Interface\\Icons\\Spell_Holy_Renew"] = { 8, 14, 20, 26, 32, 38, 44, 50, 56 };								--Renew
				["Interface\\Icons\\Spell_Shadow_AntiShadow"] = { 30, 42, 56 };																--Shadow Protection
				["Interface\\Icons\\Spell_Holy_HolyProtection"] = { 40, 42, 54 };															--Divine Spirit
			};
			ROGUE = {
				--["Interface\\Icons\\"] = ;
			};
			SHAMAN = {
				--["Interface\\Icons\\"] = ;
			};
			WARLOCK = {
				--["Interface\\Icons\\"] = ;
			};
			WARRIOR = {
				--["Interface\\Icons\\"] = ;
			};
		};
		--Spells that bind a target, and the target will be freed if attacked
		--p means it will only potentially be unbound
		--a means that it can still attack
		--n allows specifying a debuff by name, in the case that there are non-specific textures
		--d if set to 0 the buff must not have a digit in its tooltip's second left entry to pass
		--	if set to 1 the buff must have a digit in its tooltip's second left entry to pass
		Bindings = {
			--Druid
			["Interface\\Icons\\Spell_Nature_StrangleVines"] = {p=1;a=1;};							--Entangling Roots
			["Interface\\Icons\\Spell_Nature_Sleep"] = {};															--Hibernate
			--Hunter
			["Interface\\Icons\\Spell_Frost_ChainsOfIce"] = {};													--Freezing Trap
			["Interface\\Icons\\Ability_Druid_Cower"] = {p=1;};													--Scare Beast
			--Mage
			["Interface\\Icons\\Spell_Frost_FrostNova"] = {p=1;a=1;};										--Frost Nova
			["Interface\\Icons\\Spell_Nature_Polymorph"] = {};													--Polymorph
			--Paladin
			["Interface\\Icons\\Spell_Holy_PrayerOfHealing"] = {};											--Repentance
			["Interface\\Icons\\Spell_Holy_TurnUndead"] = {p=1;};												--Turn Undead
			--Priest
			["Interface\\Icons\\Spell_Nature_Slow"] = {};																--Shackle Undead
			--Rogue
			["Interface\\Icons\\Spell_Shadow_MindSteal"] = {};													--Blind 
			["Interface\\Icons\\Ability_Gouge"] = {d=0};																--Gouge (melee)
			["Interface\\Icons\\Ability_Sap"] = {};																			--Sap (melee)
			--Shaman
			--Warlock
			["Interface\\Icons\\Spell_Shadow_Possession"] = {p=1;};											--Fear
			["Interface\\Icons\\Spell_Shadow_DeathScream"] = {p=1;};										--Howl of Terror
			--Warrior
		};
	};

	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	Targ = {				--If any entry is 1, then the spell will be cast at that target
		player = 0; party1 = 0; party2 = 0; party3 = 0; party4 = 0;
	};
	Holding = 0; 		--true when the user has a spell held in their mouse cursor
	Texture = 0;		--if true will print the texture when a player casts a spell
};
--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
--Main Configuration variable
CastOptions_Config = {
	Enabled = 0;				--Whether the mod is enabled or not
	SmartRank = 0;			--Whether or not to automatically cast lower rank spells when neccisary
	CancelWand = 0;			--Whether or not to cancel casting of a wand when a new spell is cast
	CancelShot = 0;			--Whether or not to cancel casting of a ranged weapon when using a bandage
	ShowCancelShot = 1;	--Whether or not to show a warning to let you know that the wand or ranged shot has been canceled
	NoDispel = 0;				--Whether or not to not automatically self cast dispel magic
	NoBoundCast = 0;		--Whether or not to not cast spells that will free a unit bound by a stun type spell
	BoundPotential = 1;	--Whether or not to not cast on bound units that will only potentially be freed
	BoundAttack = 1;		--Whether or not to not cast on bound units that can still attack
	BoundDelay = 1;			--Amount of time to a spell must be recast to override the bindings protection
	ManaControl = 0;		--Whether or not to prevent casting of mana boosting spells on units that don't have mana
	Alt = 1;						--Whether or not to self cast when alt is held down
	Shift = 0;					--Whether or not to self cast when shift is held down
	Ctrl = 0;						--Whether or not to self cast when ctrl is held down
	AimedCast = 0;			--Whether or not to cast friendly spells at the group member that the mouse is over the frame of
	AimedWorld = 0;			--Whether or not to aimed cast at units in the world frame
	AimedHostile = 0;		--Whether or not to allow aimed casting of hostile spells
	AimedAlt = 0;				--Whether or not to aimed cast when alt is held down
	AimedShift = 0;			--Whether or not to aimed cast when shift is held down
	AimedCtrl = 0;			--Whether or not to aimed cast when ctrl is held down
	Smart = 0;					--Whether or not to automatically self cast friendly spells
	NoGroup = 0;				--Whether or not to disable smart self casting in groups
	SmartAssist = 0;		--Whether or not to cast hostile spells and friendly unit's target
	AssistTarget = 0;		--Whether or not to change to the hostile target selected in an assist
	ChainAssist = 0;		--Whether or not to keep targeting targets targets till a hostile is found
	SmartGroup = 0;			--Whether or not to do smaart group casting
	GroupPets = 0;			--Whether or not to do smaart group casting on pets
	GroupTarget = 0;		--Whether or not to change to the chosen target when group casting
	GroupGroup = 0;			--Whether or not to group cast when a group member is selected
	GroupSelf = 1;			--Whether or not to self cast when a group member is selected
	GroupHeal = 1;			--Whether or not to heal the lowest life party member
	GroupMana = 1;			--Whether or not to boost the lowest mana party members
	GroupCure = 1;			--Whether or not to cure party members with poisen/curse/disease/magic
	GroupBuff = 1;			--Whether or not to put buffs on those who don't have them yet, if your target already has it, or is invalid
	CancelSpell = 0;		--Whether or not to cancel casting of the group spell, if no good target is found
	RecastTime = 5;			--Amount of time to wait till a spell can be recast on a character
};
--Store this config for safe load
MCom.safeLoad("CastOptions_Config");

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ Hooks or unhooks needed functions ]]--
CastOptions.SetupHooks = function (toggle)
	if ( toggle == 1 ) then
		--Get the proper initial state of holding
		if (CursorHasItem() or CursorHasSpell()) then 
			CastOptions.Holding = 1; 
		else 
			CastOptions.Holding = 0; 
		end
		--Set up the use action hook
		MCom.util.hook("UseAction", "CastOptions.UseAction", "replace");
		--Set up the use container item hook
		MCom.util.hook("UseContainerItem", "CastOptions.UseContainerItem", "replace");
		--Set up the use book spell hook
		MCom.util.hook("CastSpell", "CastOptions.CastSpell", "replace");
		--Set up the by name hook
		MCom.util.hook("CastSpellByName", "CastOptions.CastSpellByName", "replace");
		--These are hooked to let us know if something is held in the mouse cursor or not, to prevent some issues
		MCom.util.hook("PickupAction", "CastOptions.PickupAction", "after");
		MCom.util.hook("PlaceAction", "CastOptions.PlaceAction", "after");
	else
		--Unhook the functions
		MCom.util.unhook("UseAction", "CastOptions.UseAction", "replace");
		MCom.util.unhook("UseContainerItem", "CastOptions.UseContainerItem", "replace");
		MCom.util.unhook("CastSpell", "CastOptions.CastSpell", "replace");
		MCom.util.unhook("CastSpellByName", "CastOptions.CastSpellByName", "replace");
		MCom.util.unhook("PickupAction", "CastOptions.PickupAction", "after");
		MCom.util.unhook("PlaceAction", "CastOptions.PlaceAction", "after");
	end
end

--[[ Toggles the Self cast variable ]]--
CastOptions.ToggleSelf = function (toggle)
	--Toggle it if -1 or nothing was passed
	if ( (not toggle) or (toggle == -1) ) then
		if (CastOptions.Targ.player == 1) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	--Make sure its in range
	if (toggle > 1) then
		toggle = 1;
	end
	if (toggle < 0) then
		toggle = 0;
	end
	--Set it
	CastOptions.Targ.player = toggle;
end

--[[ Returns true if any keys are pressed to force a targeted cast ]]--
CastOptions.AnyKeysDown = function ()
	--See if any self key confitions are met
	if ( CastOptions.SelfKeysDown() ) then
		return true;
	end
	--See if any group key conditions are met
	for i = 1, MAX_PARTY_MEMBERS do
		if ( CastOptions.Targ["party"..i] == 1 ) then
			return true;
		end
	end
	--No targeting keys are pressed
	return false;
end

--[[ Returns true if appropriate keys are pressed to force self cast ]]--
CastOptions.SelfKeysDown = function ()
	--When the right conditions are met return to true to indicate spells should be self cast
	if ( CastOptions.Targ.player == 1 ) then
		return true;
	elseif ( IsAltKeyDown() and ( CastOptions_Config.Alt == 1) ) then
		return true;
	elseif ( IsShiftKeyDown() and ( CastOptions_Config.Shift == 1) ) then
		return true;
	elseif ( IsControlKeyDown() and ( CastOptions_Config.Ctrl == 1) ) then
		return true;
	else
		--Nothing indicates that this should be self cast so return false
		return false;
	end
end

--[[ Returns false if the spell is dispel, and should not be cast on the player ]]--
CastOptions.SelfDispel = function (texture)
	--If this is dispel, then check to see if the player has something to dispel
	if ( (texture == "Interface\\Icons\\Spell_Holy_DispelMagic") ) then
		--If the player has something to be dispeled, return true
		if ( CastOptions.CheckForDeBuff("player", CASTOPTIONS_DEBUFF_MAGIC) ) then
			return true;
		end
		--If the player has no target, then we can do dispel
		if ( not UnitExists("target") ) then
			return true;
		end
		--If the player doesn't have something to be dispeled return false
		return false;
	end
	--If this isn't dispel, then return true
	return true;
end

--[[ Returns true if smart self casting should be used ]]--
CastOptions.UseSmart = function (texture, localSelfCast)
	--Check if the option is enabled
	if ( CastOptions_Config.Smart == 1 ) then
		--if we are supposed to disable when in a group, and are in a group then return false
		if ( CastOptions_Config.NoGroup == 1 ) then
			if ( ( GetNumPartyMembers() > 0 ) or ( GetNumRaidMembers() > 0 ) ) then
				return false;
			end
		end
		if ( UnitExists("target") ) then
			--Only return true if the target isn't friendly
			if ( not UnitCanAttack("player", "target") ) then
				if ( texture and localSelfCast[texture] and localSelfCast[texture].g ) then
					if ( CastOptions.UnitInGroup("target") ) then
						return false;
					end
				else
					return false;
				end
			end
		end
		return true;
	else
		return false;
	end
end

--[[ Returns true if smart group casting should be used ]]--
CastOptions.UseGroup = function ()
	--Check if the option is enabled
	if ( (CastOptions_Config.SmartGroup == 1) and ( ( GetNumPartyMembers() > 0 ) or ( GetNumRaidMembers() > 0 ) or UnitExists("pet") ) ) then
		--If we have a target that is in our group, and group casting is enabled, then return true
		if ( UnitExists("target") ) then
			if ( (CastOptions_Config.GroupGroup == 1) and CastOptions.UnitInGroup("target") ) then
				return true;
			elseif ( UnitCanAttack("player", "target") )	then
				return true;
			end
		else
			--If we have no target, then group cast
			return true;
		end
	end
	return false;
end

--[[ Gets the self cast table ]]--
CastOptions.GetSelfTable = function (container)
	local _, pClass = UnitClass("player");
	local _, pRace = UnitRace("player");
	if (pClass) then
		--Default the self cast table to empty
		local selfCastTable = {};
		if (not container) then
			--Get the self cast table
			selfCastTable = CastOptions.SpellData.Self[pClass];
			if (pClass == "PRIEST") then
				--remove dispel from the list if we arent supposed to self cast it, otherwise make sure its in the list
				if (CastOptions_Config.NoDispel == 1) then
					selfCastTable["Interface\\Icons\\Spell_Holy_DispelMagic"] = nil;
				else
					selfCastTable["Interface\\Icons\\Spell_Holy_DispelMagic"] = {m=1;};
				end
			end
			
			if (pRace and CastOptions.SpellData.Self[pRace]) then
				--Add the racial self cast list to the table
				for curSpell in CastOptions.SpellData.Self[pRace] do
					selfCastTable[curSpell] = CastOptions.SpellData.Self[pRace][curSpell];
				end
			end
		end
		
		--Add the container self cast list to the table
		for curItem in CastOptions.SpellData.Self.Container do
			selfCastTable[curItem] = CastOptions.SpellData.Self.Container[curItem];
		end

		return selfCastTable;
	end
end

--[[ Gets the hostile cast table ]]--
CastOptions.GetHostileTable = function (container)
	local _, pClass = UnitClass("player");
	local _, pRace = UnitRace("player");
	if (pClass) then
		--Default the hostile cast table to empty
		local hostileCastTable = {};
		if (not container) then
			--Get the hostile cast table
			hostileCastTable = CastOptions.SpellData.Hostile[pClass];
			
			if (pRace and CastOptions.SpellData.Self[pRace]) then
				--Add the racial hostile cast list to the table
				for curSpell in CastOptions.SpellData.Hostile[pRace] do
					hostileCastTable[curSpell] = CastOptions.SpellData.Hostile[pRace][curSpell];
				end
			end
		end
		
		--Add the container hostile cast list to the table
		for curItem in CastOptions.SpellData.Hostile.Container do
			hostileCastTable[curItem] = CastOptions.SpellData.Hostile.Container[curItem];
		end

		return hostileCastTable;
	end
end

--[[ Gets the highest level rank of the spell for the target ]]--
CastOptions.GetRank = function (unit, buff, rank, texture)
	if (unit and buff and rank and texture) then
		local castRank = tonumber(rank);	--The rank to cast
		
		--Get the player class
		local _, pClass = UnitClass("player");
		--Get the data for the buff
		local curBuff = CastOptions.SpellData.Ranks[pClass][texture];
		--Get the targets level
		local targetLevel = UnitLevel(unit);
		
		--Make sure we have the buff data, and the targets level
		if ( curBuff and (targetLevel and targetLevel > 0) ) then
			--Make sure the passed rank is found
			if (curBuff[castRank]) then
				--Keep lowering the rank till one that can be cast on the target is found
				while ( ((curBuff[castRank] - 10) > targetLevel) and (castRank > 1) ) do
					castRank = castRank - 1;
				end
			else
				--We didn't find the requested rank, so pop out an error
				Sea.io.printc(ChatTypeInfo["SYSTEM"], "ERROR: Spell rank "..castRank.." not found for "..buff..", please contact "..CastOptions.MAINTAINER);
			end
		end
		return castRank;
	else
		return;
	end
end

--[[ Returns true if this spell either requires no range check, or passes a range check ]]--
CastOptions.SpellHasRange = function (texture, spellName)
	--Make sure we have a texture that matches a spell
	if (texture and spellName and CastOptions.SpellData.Player[spellName] and CastOptions.SpellData.Self[texture] and CastOptions.SpellData.Self[texture].r) then
		--Get the ID of this spell
		local spellID = CastOptions.SpellData.Player[spellName];
		--Setup the tooltip with this spell
		Sea.wow.tooltip.protectTooltipMoney();
		CastOptionsTooltip:SetSpell(spellID, BOOKTYPE_SPELL);
		Sea.wow.tooltip.unprotectTooltipMoney();
		local tip = Sea.wow.tooltip.scan("CastOptionsTooltip");
		--If the tooltip has a range string, then this spell can target
		if ( tip and tip[2] and tip[2]["right"] and ( tip[2]["right"] ~= "" ) ) then
			return true;
		end
		return false;
	end
	return true;
end

--[[ Allows casting a spell by a name from scripts ]]--
CastOptions.DoCastSpellByName = function (spellname)
	--Make sure we have the spell data
	if (not CastOptions.SpellData.Player) then
		CastOptions.GetSpellInfo();
	end
	--if the spell is found then cast it
	if CastOptions.SpellData.Player[spellname] then
		MCom.callHook("CastSpell", CastOptions.SpellData.Player[spellname], BOOKTYPE_SPELL);
	elseif CastOptions.SpellData.Pet[spellname] then
		MCom.callHook("CastSpell", CastOptions.SpellData.Pet[spellname], BOOKTYPE_PET);
	else
		Sea.io.dprint("ERROR: Attempt to cast non-existent spell");
	end
end

--[[ Makes a table of all the spells a player and their pet can cast ]]--
CastOptions.GetSpellInfo = function ()
	--Clear/Create the player spells table
	CastOptions.SpellData.Player = {};
	
	local index = 1;	--The current index in the spell book
	local spellname, spellrank;	--The current spells name and rank
	local texture;  --The current spells rank
	--Go through all the spells in the players spellbook
	repeat
		--Get the spell name and rank
		spellname, spellrank = GetSpellName(index, BOOKTYPE_SPELL);
		--Get the spell texture
		spellname, spellrank = GetSpellName(index, BOOKTYPE_SPELL);
		texture = GetSpellTexture(index, BOOKTYPE_SPELL);
		--Make sure we have the spells name, otherwise we've gone through all spells
		if (spellname) then
			--if we have a rank for this spell, then make a ranked spell entry for it
			if (spellrank) then
				CastOptions.SpellData.Player[spellname.."("..spellrank..")"] = index;
			end
			--Make a non ranked spell entry to the highest rank of the spell
			CastOptions.SpellData.Player[spellname] = index;
			if (texture) then
				--Make a texture based spell entry to the highest rank of the spell
				CastOptions.SpellData.Player[texture] = index;
			end
		end
		index = index + 1;
	until (spellname == nil)
	
	--Clear/Create the pet spells table
	CastOptions.SpellData.Pet = {};
	
	--Make sure the pet has spells
	if ( not HasPetSpells() ) then
		return;
	end
	
	index = 1;	--Reset the index
	--Go through all the spells in the pets spellbook
	repeat
		--Get the spell name and rank
		spellname, spellrank = GetSpellName(index, BOOKTYPE_PET);
		texture = GetSpellTexture(index, BOOKTYPE_SPELL);
		--Make sure we have the spells name, otherwise we've gone through all spells
		if (spellname) then
			--if we have a rank for this spell, then make a ranked spell entry for it
			if (spellrank) then
				CastOptions.SpellData.Pet[spellname.."("..spellrank..")"] = index;
			end
			--Make a non ranked spell entry to the highest rank of the spell
			CastOptions.SpellData.Pet[spellname] = index;
			if (texture) then
				--Make a texture based spell entry to the highest rank of the spell
				CastOptions.SpellData.Pet[texture] = index;
			end
		end
		index = index + 1;
	until (spellname == nil)
end

--[[
	Selects the target by name and or unit type
	
	Args:
		(string) name - the name of the unit to target
		(string) unit - the unit type to target, such as player, party1, raid1, etc..
		
		NOTE: Either name or unit can be passed.  If both are passed then it will first try
					to target by unit, and if that unit's name doesn't match name, then it will
					try a name search.
					
	Returns:
		true - if the unit was targeted
		false - if the unit was not targeted
]]--
CastOptions.TargetUnit = function (name, unit)
	--Get the current target so we can switch back to it, if we fail to find the right target
	local prevTarg = nil;
	if ( UnitExists("target") ) then
		prevTarg = UnitName("target");
	end
	--Make sure we have a name to work with
	if (name) then
		--If we already have the target, targeted then return true
		if ( UnitExists("target") and (UnitName("target") == name) ) then
			return true;
		end
		--If the passed unit has the same name, as name, then target it
		if ( unit and UnitExists(unit) and ( UnitName(unit) == name ) ) then
			TargetUnit(unit);
			--If the selected target is the one we wanted, then return true
			if ( UnitExists("target") and ( UnitName("target") == name ) ) then
				return true;
			end
		end
		--A list of targets that we have checked, if we end up checking the same target twice,
		--then we abort our search to avoid needless loops
		local targetList = {};
		--First search for friendly units, then hostile units
		for curType = 1, 2 do
			--Switch targets till we find out unit, if we check more than 100 units, then give up
			for curTry = 1, 100 do
				--Do the appropriate targeting type
				if (curType == 1) then
					TargetNearestFriend();
				else
					TargetNearestEnemy();
				end
				--If we failed to target anything then quit looking
				if ( UnitExists("target") and UnitName("target") ) then
					--If the unit we targeted is the one we wanted, then return true
					if (UnitName("target") == name) then
						return true;
					else
						--We didn't find the desired unit
						if (targetList[UnitName("target")]) then
							--If we've targeted this unit before, then stop looking
							break;
						else
							--Add this target to the list of checked targets
							targetList[UnitName("target")] = true;
						end
					end
				else
					break;
				end
			end
		end
	elseif ( unit and UnitExists(unit) ) then
		--If we don't have a name, but do have a unit type that exists, then target it
		TargetUnit(unit);
		return true;
	end
	--We failed to find the right target, so switch back to the previous one
	if (prevTarg) then
		if (CastOptions.TargetUnit(prevTarg)) then
			return false;
		end
	end
	--If we failed to switch back to the previous target, then target nothing
	ClearTarget();
	return false;
end

--[[ Checks the unit for the passed debuff type ]]--
CastOptions.CheckForDeBuff = function (unit, debuff)
	--Make sure the unit exists
	if ( unit and UnitExists(unit) ) then
		--Check all of the unit's debuffs for this type of debuff
		for index = 1, MAX_PARTY_TOOLTIP_DEBUFFS do
			--If we have a debuff
			if ( UnitDebuff(unit, index) ) then
				--Setup the tooltip with the debuff info
				Sea.wow.tooltip.protectTooltipMoney();
				CastOptionsTooltip:SetUnitDebuff(unit, index);
				Sea.wow.tooltip.unprotectTooltipMoney();
				local tip = Sea.wow.tooltip.scan("CastOptionsTooltip");
				--If the top right of the tooltip is the passed debuff, then return true
				if ( tip and tip[1] and tip[1]["right"] and ( tip[1]["right"] == debuff ) ) then
					return true;
				end
			end
		end
	end
	return false;
end

--[[ Checks the target unit for a buff called spellName ]]--
CastOptions.CheckForBuff = function (unit, spellName, buffTexture)
	--Make sure the unit exists
	if ( unit and UnitExists(unit) ) then
		--Check all of the unit's buffs for the passed buff
		for index = 1, MAX_PARTY_TOOLTIP_BUFFS do
			--If we have a buff
			local buff = UnitBuff(unit, index);
			if ( buff ) then
				--If the buff's texture matches the passed buff texture, then return true
				if (buff == buffTexture) then
					return true;
				end				
				--Setup the tooltip with the buff info
				Sea.wow.tooltip.protectTooltipMoney();
				CastOptionsTooltip:SetUnitBuff(unit, index);
				Sea.wow.tooltip.unprotectTooltipMoney();
				local tip = Sea.wow.tooltip.scan("CastOptionsTooltip");
				--If the top left of the tooltip is the passed spellname, then return true
				if ( tip and tip[1] and tip[1]["left"] and ( tip[1]["left"] == spellName ) ) then
					return true;
				end
			end
		end
	end
	return false;
end

--[[ Tells if the target unit can receive this spell level wise ]]--
CastOptions.CanReceiveSpell = function (unit, spellName, texture, spellRank)
	--Get the player class
	local _, pClass = UnitClass("player");
	--Make sure we have the needed data, and that the unit exists
	if ( unit and UnitExists(unit) and texture and spellRank ) then
		--Get the unit's level
		local tLevel = UnitLevel(unit);
		--If SmartRanking is not enabled, then check the spell at this rank
		if (CastOptions_Config.SmartRank ~= 1) then
			if (CastOptions.SpellData.Ranks[pClass][texture] and spellRank and ( spellRank > 0 ) and CastOptions.SpellData.Ranks[pClass][texture][spellRank] and ( ( CastOptions.SpellData.Ranks[pClass][texture][spellRank] - 10 ) > tLevel ) ) then
				--If no suitable rank was found, then return false
				return false;
			end
		else
			--Get the smart ranked rank
			local newRank = CastOptions.GetRank(unit, spellName, spellRank, texture);
			if (CastOptions.SpellData.Ranks[pClass][texture] and newRank and ( newRank > 0 ) and CastOptions.SpellData.Ranks[pClass][texture][newRank] and ( ( CastOptions.SpellData.Ranks[pClass][texture][newRank] - 10 ) > tLevel ) ) then
				--If no suitable rank was found, then return false
				return false;
			end
		end
	end
	return true;
end

--[[ Checks to see if this unit has had this buff cast on them longer ago than the current unit ]]--
CastOptions.CheckBuffTime = function (unit, curUnit, spellName)
	--Make sure we have all the data we need, and can get the bufftime table for this spell
	if ( unit and curUnit and spellName and CastOptions.recentCasts ) then
		--Get the names of the units
		local unitName = UnitName(unit);
		local curUnitName = UnitName(curUnit);

		--If we have the names of these unit's and and their buff times, then see if the new unit's time is newer
		if (	unitName and curUnitName and CastOptions.recentCasts[unitName] and CastOptions.recentCasts[unitName][spellName] and
					CastOptions.recentCasts[curUnitName] and CastOptions.recentCasts[curUnitName][spellName] ) then
			--See how long it has been since each unit last had the buff cast on them
			local unitTime = GetTime() - CastOptions.recentCasts[unitName][spellName];
			local curUnitTime = GetTime() - CastOptions.recentCasts[curUnitName][spellName];
			--If the new unit has had the buff cast on them more recently than the current unit, then return false
			if (unitTime <= curUnitTime) then
				return false;
			end
		elseif ( curUnitName and ( ( not CastOptions.recentCasts[curUnitName] ) or ( not CastOptions.recentCasts[curUnitName][spellName] ) ) ) then
			--If the current unit doesn't have a buff time, then consider it older
			return false;
		end
		return true;
	end
end

--[[ Checks to see if the unit is the most suitable for this spell ]]--
CastOptions.CheckCastUnit = function (unit, curUnit, health, debuffs, buff, texture, spellName, spellRank, spellType, ignoreList)
	--Make sure we have all the needed info, and that the unit can receive this spell
	if (	unit and ( not ( ignoreList and ignoreList[unit] ) ) and UnitExists(unit) and SpellCanTargetUnit(unit) and
				CastOptions.CanReceiveSpell(unit, spellName, texture, spellRank) and ( not UnitIsDead(unit) ) and 
				( not UnitCanAttack("player", unit) ) and ( type(spellType) == "table" ) and ( UnitHealth(unit) > 0 ) and
				UnitIsVisible(unit) ) then
		--Check to see if this spell has been cast on this char recently
		local tooSoon = false;
		local curUnitName = UnitName(unit);
		if ( ( CastOptions_Config.RecastTime > 0 ) and curUnitName ) then
			if ( CastOptions.recentCasts and CastOptions.recentCasts[curUnitName] and CastOptions.recentCasts[curUnitName][spellName] ) then
				if ( ( GetTime() - CastOptions.recentCasts[curUnitName][spellName] ) <= CastOptions_Config.RecastTime ) then
					tooSoon = true;
				end
			end
		end

		--If it isn't too soon to cast this spell on this char again yet, then go ahead and check it out
		if (not tooSoon) then
			local maxDeBuffs = 0;		--The total number of debuffs we check for for this spell
			local curDeBuffs = 0;		--The number of debuffs this character could have
			--For each type of debuff, increment the maxDeBuffs, and increment curDeBuffs if they have that DeBuff
			if (spellType.p) then
				maxDeBuffs = maxDeBuffs + 1;
				if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_POISEN) ) then
					curDeBuffs = curDeBuffs + 1;
				end
			end
			if (spellType.c) then
				maxDeBuffs = maxDeBuffs + 1;
				if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_CURSE) ) then
					curDeBuffs = curDeBuffs + 1;
				end
			end
			if (spellType.d) then
				maxDeBuffs = maxDeBuffs + 1;
				if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_DISEASE) ) then
					curDeBuffs = curDeBuffs + 1;
				end
			end
			if (spellType.m) then
				maxDeBuffs = maxDeBuffs + 1;
				if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_MAGIC) ) then
					curDeBuffs = curDeBuffs + 1;
				end
			end
			--Convert debuffs to a percentage
			curDeBuffs = (100 * curDeBuffs) / maxDeBuffs;
			
			--If this is a healing spell, and group healing is enabled, then check out healing
			if ( ( CastOptions_Config.GroupHeal == 1 ) and spellType.h ) then
				--Get the players health as a percentage
				local curHealth = (100 * UnitHealth(unit)) / UnitHealthMax(unit);
				--If we have a buff with this heal then prefer players that dont already have the buff
				if (spellType.b) then
					--If we don't already have a unit, then simply check health
					if ( not curUnit ) then
						if (curHealth < health) then
							--If this player has lost any life, make them the current player to heal
							health = curHealth;
							buff = CastOptions.CheckForBuff(unit, spellName, buffTexture);
							curUnit = unit;
						end
					else
						--If we have a unit set already, then compare this one, to that one
						if ( buff ) then
							--If the current one has the buff, then use this one, if it doesn't have the buff
							if ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) then
								health = curHealth;
								buff = false;
								curUnit = unit;
							elseif (curHealth < health) then
								--If this one also has the buff, then use it if this one has less life
								health = curHealth;
								buff = true;
								curUnit = unit;
							end
						elseif ( ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) and (curHealth < health) ) then
							--If the current one doesn't have a buff, then only replace it, if this one has less life
							health = curHealth;
							buff = false;
							curUnit = unit;
						end
					end
				elseif (curHealth < health) then
					--If there is no buff with this heal, then just compare health
					health = curHealth;
					curUnit = unit;
				end
			elseif ( ( CastOptions_Config.GroupMana == 1 ) and spellType.n ) then
				--Make sure the current unit has a mana bar
				if ( UnitPowerType(unit) == 0 ) then
					--Get the players mana as a percentage
					local curMana = (100 * UnitMana(unit)) / UnitManaMax(unit);
					--If we have a buff with this mana spell then prefer players that dont already have the buff
					if (spellType.b) then
						--If we don't already have a unit, then simply check health
						if ( not curUnit ) then
							if (curMana < mana) then
								--If this player has lost any mana, make them the current player to cast at
								mana = curMana;
								buff = CastOptions.CheckForBuff(unit, spellName, buffTexture);
								curUnit = unit;
							end
						else
							--If we have a unit set already, then compare this one, to that one
							if ( buff ) then
								--If the current one has the buff, then use this one, if it doesn't have the buff
								if ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) then
									mana = curMana;
									buff = false;
									curUnit = unit;
								elseif (curMana < mana) then
									--If this one also has the buff, then use it if this one has less mana
									mana = curMana;
									buff = true;
									curUnit = unit;
								end
							elseif ( ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) and (curMana < mana) ) then
								--If the current one doesn't have a buff, then only replace it, if this one has less life
								mana = curMana;
								buff = false;
								curUnit = unit;
							end
						end
					elseif (curMana < mana) then
						--If there is no buff with this heal, then just compare health
						mana = curMana;
						curUnit = unit;
					end
				end
			elseif ( ( CastOptions_Config.GroupBuff == 1 ) and spellType.b ) then
				--If this is a buff spell, then find a player who doesn't have the buff
				local curHasBuff = CastOptions.CheckForBuff(unit, spellName, buffTexture);
				--If we don't already have a unit set, and this player doesn't have the buff yet, then set them as the target
				if ( not curUnit ) then
					if (not curHasBuff) then
						buff = false;
						debuffs = curDeBuffs;
						curUnit = unit;
					else
						--If the current and previous unit have the buff, then if this one was buffed less recently, nail it
						buff = true;
						debuffs = curDeBuffs;
						curUnit = unit;
					end
				elseif ( buff ) then
					if ( ( not curHasBuff ) or ( curDeBuffs > debuffs ) ) then
						--If the current unit has a buff and the new unit doesn't, or the new unit has better debuffs, then use the new unit
						buff = false;
						debuffs = curDeBuffs;
						curUnit = unit;
					elseif ( CastOptions.CheckBuffTime(unit, curUnit, spellName) ) then
						--If this unit has had this buff cast on them longer than the current unit, then replace the current unit
						buff = true;
						debuffs = curDeBuffs;
						curUnit = unit;
					end
				elseif ( ( not curHasBuff ) and ( curDeBuffs > debuffs ) ) then
					--If the current and new unit don't have the buff, and the new unit has more debuffs, then use the new one
					buff = false;
					debuffs = curDeBuffs;
					curUnit = unit;
				end
			elseif ( ( CastOptions_Config.GroupCure == 1 ) and ( maxDeBuffs > 0 ) ) then
				--If this is a curing spell, then use this unit if they have more debuffs to be nuked
				if ( curDeBuffs > debuffs ) then
					debuffs = curDeBuffs;
					curUnit = unit;
				end
			end
		end
	end
	return curUnit, health, debuffs, buff;
end

--[[ Finds a unit to group cast on ]]--
CastOptions.FindCastUnit = function (texture, spellName, spellRank, spellType, ignoreList)
	local castUnit = nil;		--The unit to cast on
	local curHealth = 100;	--The current lowest health percentage
	local curDeBuffs = 0;		--The current debuff percentage
	local curBuff = false;	--Whether or not the current unit has the buff already
	--If the selected target is in the group, then consider it first
	if ( UnitExists("target") and CastOptions.UnitInGroup("target") ) then
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("target", castUnit, curHealth, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	--If the option is enabled, then check the player as a candidate
	if (CastOptions_Config.GroupSelf == 1) then
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("player", castUnit, curHealth, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	--Check all party and raid members as candidates
	for index = 1, MAX_PARTY_MEMBERS do
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("party"..index, castUnit, curHealth, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	for index = 1, MAX_RAID_MEMBERS do
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("raid"..index, castUnit, curHealth, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	--If the option is enabled, then check the group pets as candidates
	if (CastOptions_Config.GroupPets == 1) then
		--Check the player's pet as a candidate
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("pet", castUnit, curHealth, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
		--Check the group's pets as candidates
		for index = 1, MAX_PARTY_MEMBERS do
			castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("partypet"..index, castUnit, curHealth, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
		end
		for index = 1, MAX_RAID_MEMBERS do
			castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("raidpet"..index, castUnit, curHealth, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
		end
	end
	--Return the unit we decided on
	return castUnit;
end

--[[ Returns true if the passed unit is in the players group ]]--
CastOptions.UnitInGroup = function (target)
	--If the unit exists
	if ( target and UnitExists(target) and UnitName(target) ) then
		local name = UnitName(target);		--Get the units name
		--Check to see if it is the player
		if ( (CastOptions_Config.GroupSelf == 1) and (name == UnitName("player") ) ) then
			return true;
		end
		--Check to see if it is a party or raid member
		local curName = "party";
		for index = 1, MAX_PARTY_MEMBERS do
			if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
				return true;
			end
		end
		curName = "raid";
		for index = 1, MAX_PARTY_MEMBERS do
			if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
				return true;
			end
		end
		--If we are allowing pets, then check to see if it's anyones pet
		if (CastOptions_Config.GroupPets == 1) then
			--Check to see if it is the pet
			if ( UnitExists("pet") and (name == UnitName("pet") ) ) then
				return true;
			end
			--Check to see if it is one of the group's pets
			curName = "partypet";
			for index = 1, MAX_PARTY_MEMBERS do
				if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
					return true;
				end
			end
			curName = "raidpet";
			for index = 1, MAX_PARTY_MEMBERS do
				if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
					return true;
				end
			end
		end
	end
	--If we didn't find the unit as any of the group members, then return false
	return false;
end

--[[ If the current target has a unit type this will return it ]]--
CastOptions.GetUnitType = function ()
	local unit = nil;
	--Only proceed if the target is friendly
	if ( UnitExists("target") and UnitIsFriend("player", "target") ) then
		--Get the name of the friend that is currently targeted
		local friendName = UnitName("target");
		--Only proceed if we don't have ourselves targeted
		if (friendName ~= UnitName("player")) then
			--Get the unit targeting type of the target
			local unit = nil;
			--Check to see if the target is one of the party members
			if (not unit) then
				for i = 1, MAX_PARTY_MEMBERS do
					if ( UnitExists("party"..i) and (UnitName("party"..i) == friendName) ) then
						unit = "party"..i;
						break;
					end
				end
			end
			--Check to see if the target is one of the raid members
			if (not unit) then
				for i = 1, MAX_RAID_MEMBERS do
					if ( UnitExists("raid"..i) and (UnitName("raid"..i) == friendName) ) then
						unit = "raid"..i;
						break;
					end
				end
			end
			--Check to see if it is anyones pet
			if (not unit) then
				if ( UnitExists("pet") and (UnitName("pet") == friendName) ) then
					unit = "pet";
				end
			end
			if (not unit) then
				for i = 1, MAX_PARTY_MEMBERS do
					if ( UnitExists("partypet"..i) and (UnitName("partypet"..i) == friendName) ) then
						unit = "partypet"..i;
						break;
					end
				end
			end
			if (not unit) then
				for i = 1, MAX_RAID_MEMBERS do
					if ( UnitExists("raidpet"..i) and (UnitName("raidpet"..i) == friendName) ) then
						unit = "raidpet"..i;
						break;
					end
				end
			end
		else
			--We have ourselves targeted
			unit = "player";
		end
	end
	return unit;
end

--[[ Checks to see if any of the units debuffs match this texture ]]--
CastOptions.CheckForDeBuffTex = function (unit, texture)
	--Make sure the unit exists
	if ( unit and UnitExists(unit) and texture ) then
		--Check all of the unit's debuffs for this debuff
		for index = 1, MAX_PARTY_TOOLTIP_DEBUFFS do
			--If we have a debuff
			local debuff = UnitDebuff(unit, index);
			if ( debuff == texture ) then
				return true;
			end
		end
	end
	return false;
end

--[[ Checks the unit for any binding type debuffs ]]--
CastOptions.CheckForBound = function (unit)
	--Make sure the unit exists
	if ( ( CastOptions_Config.NoBoundCast == 1 ) and unit and UnitExists(unit) ) then
		--Check all of the unit's debuffs for a boinding debuff
		for index = 1, MAX_PARTY_TOOLTIP_DEBUFFS do
			--If we have a debuff
			local debuff = UnitDebuff(unit, index);
			if ( debuff ) then
				local bindInfo = CastOptions.SpellData.Bindings[debuff];
				if (bindInfo) then
					local isValid = true;
					if (bindInfo.n or bindInfo.d) then
						--Setup the tooltip with the debuff info
						Sea.wow.tooltip.protectTooltipMoney();
						CastOptionsTooltip:SetUnitDebuff(unit, index);
						Sea.wow.tooltip.unprotectTooltipMoney();
						local tip = Sea.wow.tooltip.scan("CastOptionsTooltip");
						if (bindInfo.n) then
							--If the top left of the tooltip is not the name specified, then go on to the next debuff
							if ( tip and tip[1] and tip[1]["left"] and ( tip[1]["left"] ~= bindInfo.n ) ) then
								isValid = false;
							end
						end
						--If this must have, or must not have, a digit in the seccond left tooltip, then check for one
						if (bindInfo.d) then
							--If the top left of the tooltip is not the name specified, then go on to the next debuff
							if ( tip and tip[2] and tip[2]["left"] ) then
								--If it must not have a digit, but does, then it is not valid
								if (bindInfo.d == 0) then
									if ( string.find( tip[2]["left"], "%d" ) ) then
										isValid = false;
									end
								elseif (bindInfo.d == 1) then
									--If it must have a digit, but does not, then it is not valid
									if ( not string.find( tip[2]["left"], "%d" ) ) then
										isValid = false;
									end
								end
							end
						end
					end
					--Only continue if this is validified as the right debuff
					if (isValid) then
						if ( bindInfo.p and ( CastOptions_Config.BoundPotential == 1 ) ) then
							return true;
						end
						if ( bindInfo.a and ( CastOptions_Config.BoundAttack == 1 ) ) then
							return true;
						end
						if ( ( not bindInfo.a ) and ( not bindInfo.p ) ) then
							return true;
						end
					end
				end
			end
		end
	end
	return false;
end

--[[ If the spell is hostile, and the target is bound, will return true ]]--
CastOptions.SpellBound = function (texture, isHostile)
	--Initialize the bound spells table
	if (not CastOptions.SpellData.BoundSpells) then
		CastOptions.SpellData.BoundSpells = {};
	end
	--If we are going to be casting the origional spell, don't do so if the unit is mean and bound, if the option is enabled
	if (	texture and ( not CastOptions.CheckForDeBuffTex("target", texture) ) and UnitExists("target") and UnitCanAttack("player", "target") and
				CastOptions.CheckForBound("target") and isHostile[texture] ) then
		if (	( not CastOptions.SpellData.BoundSpells[texture] ) or
					(CastOptions.SpellData.BoundSpells[texture] and ( ( GetTime() - CastOptions.SpellData.BoundSpells[texture] ) >= CastOptions_Config.BoundDelay ) ) ) then
			UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_BOUND, 1.0, 0.1, 0.1, 1.0, CastOptions.BOUND_HOLD_TIME);
			CastOptions.SpellData.BoundSpells[texture] = GetTime();
			return true;
		else
			--Make sure the spell is no longer bound
			CastOptions.SpellData.BoundSpells[texture] = nil;
		end
	elseif (texture) then
		--Make sure the spell is no longer bound
		CastOptions.SpellData.BoundSpells[texture] = nil;
	end
end

--[[ Checks to see if the spell is in an action slot, and returns the ID if it is ]]--
CastOptions.GetSpellActionID = function (spellName)
	--Make sure we have the spell name
	if ( spellName ) then
		--Check all of the action ID's
		for index = 1, CastOptions.MAX_ID do
			--If we have an action in the slot
			if ( HasAction(index) ) then
				--Setup the tooltip with the action info
				Sea.wow.tooltip.protectTooltipMoney();
				CastOptionsTooltip:SetAction(index);
				Sea.wow.tooltip.unprotectTooltipMoney();
				local tip = Sea.wow.tooltip.scan("CastOptionsTooltip");
				--If the top left of the tooltip is the passed spellname, then return true
				if ( tip and tip[1] and tip[1]["left"] and ( tip[1]["left"] == spellName ) ) then
					return index;
				end
			end
		end
	end
end

--[[ Stores the spell cast on the unit in the recent cast table ]]--
CastOptions.StoreRecentCast = function (unit, spellName, texture, selfCastList)
	if (	unit and UnitExists(unit) and spellName and UnitName(unit) and CastOptions.UnitInGroup(unit) and
				texture and selfCastList and selfCastList[texture] and UnitIsFriend("player", unit) ) then
		local curUnitName = UnitName(unit);
		--If we have a spell name, then add the spell to the recent cast list, for this unit
		if (curUnitName) then
			if (not CastOptions.recentCasts) then
				CastOptions.recentCasts = {};
			end
			if (not CastOptions.recentCasts[curUnitName])  then
				CastOptions.recentCasts[curUnitName] = {};
			end
			CastOptions.recentCasts[curUnitName][spellName] = GetTime();
		end
	end
end

--[[ Returns true if the frame is visible and the mouse is over it ]]--
CastOptions.FrameHasMouse = function (frameName ,xPos, yPos)
	--Make sure a frame name was passed
	if (frameName) then
		--Get the frame itself
		local curFrame = getglobal(frameName);
		--Make sure we got the frame, and that it is visible
		if ( curFrame and curFrame:IsVisible() ) then
			--If the mouse position was not passed, then lets get it ourself
			if ( (not xPos) or (not yPos) ) then
				xPos, yPos = GetCursorPosition();
			end

			--Get the scale of the frame
			local scale = curFrame:GetScale();
			--Make sure we have the scale
			if (scale) then
				--Scale the mouse coordinates
				xPos = xPos / scale;
				yPos = yPos / scale;
				--Get the frame edges
				local left = curFrame:GetLeft();
				local right = curFrame:GetRight();
				local top = curFrame:GetTop();
				local bottom = curFrame:GetBottom();
				--Make sure we have all of the frame edges
				if (left and right and top and bottom) then
					--If the mouse is over the frame, then return true
					if ( ( ( xPos >= left ) and ( xPos < right ) ) and ( ( yPos >= bottom ) and ( yPos <= top ) ) ) then
						return true;
					end
				end
			end
		end
	end
end

--[[ Returns true if appropriate keys are pressed to force aimed cast ]]--
CastOptions.AimedKeysDown = function ()
	--When the right conditions are met return to true to indicate spells should be aimed cast
	if ( CastOptions.Aimed == 1 ) then
		return true;
	elseif ( IsAltKeyDown() and ( CastOptions_Config.AimedAlt == 1) ) then
		return true;
	elseif ( IsShiftKeyDown() and ( CastOptions_Config.AimedShift == 1) ) then
		return true;
	elseif ( IsControlKeyDown() and ( CastOptions_Config.AimedCtrl == 1) ) then
		return true;
	else
		--Nothing indicates that this should be aimed cast so return false
		return false;
	end
end

--[[ Gets the unit aimed at by the mouse ]]--
CastOptions.GetAimedUnit = function (texture, localSelfCast)
	--Only return a unit if aimed casting is enabled, and this is a friendly spell
	if ( ( (CastOptions_Config.AimedCast == 1) or CastOptions.AimedKeysDown() ) and ( ( CastOptions_Config.AimedHostile == 1 ) or ( texture and localSelfCast[texture] ) ) ) then
		--If world frame aiming is enabled, then if a unit is aimed at, then cast the spell at it
		if ( ( CastOptions_Config.AimedWorld == 1 ) and UnitExists("mouseover") ) then
			return "mouseover";
		end

		--Get the cursor position now, so we don't have to do it for every frame
		local xPos, yPos = GetCursorPosition();

		--See if the mouse is over the pet frame
		if ( CastOptions.FrameHasMouse("PetFrame", xPos, yPos) ) then
			return "pet";
		end
		--See if the mouse is over any of the party members pet frame
		for curPet = 1, MAX_PARTY_MEMBERS do
			if ( CastOptions.FrameHasMouse("PartyMemberFrame"..curPet.."PetFrame", xPos, yPos) ) then
				return "partypet"..curPet;
			end
		end
		--See if the mouse is over the player frame
		if ( CastOptions.FrameHasMouse("PlayerFrame", xPos, yPos) ) then
			return "player";
		end
		--See if the mouse is over any of the party members frames
		for curParty = 1, MAX_PARTY_MEMBERS do
			if ( CastOptions.FrameHasMouse("PartyMemberFrame"..curParty, xPos, yPos) ) then
				return "party"..curParty;
			end
		end
	end
end

--[[
	Casts a spell at a higher rank if needed
	
	Args:
		(string) spellName - The name of the spell to cast
		(string) spellRank - The rank of the spell to cast
		(string) texture - The tecture of the spell to cast
		
	Returns:
		true - The spell was cast at a different rank than passed
		false - The spell was not cast at a different rank than passed
]]--
CastOptions.RankCast = function (spellName, spellRank, texture)
	local _, pClass = UnitClass("player");
	if (	( CastOptions_Config.SmartRank == 1 ) and spellName and texture and pClass and CastOptions.SpellData.Ranks[pClass][texture] and
				UnitExists("target") and UnitIsFriend("player", "target") and (not UnitCanAttack("player", "target") ) and ( UnitName("target") ~= UnitName("player") ) ) then
		--We are casting at a target, so we may need to cast a lower rank spell
		--Make sure we have the spells rank
		if (spellRank) then
			--if there is a buff entry for this spell, then check to see if we need to cast a lower rank
			local buffInfo = CastOptions.SpellData.Ranks[pClass][texture];
			if (buffInfo) then
				--if we need to cast a lower rank then do so
				local newRank = CastOptions.GetRank("target", spellName, spellRank, texture);
				if (newRank and (newRank ~= spellRank)) then
					CastOptions.DoCastSpellByName(spellName.."("..CASTOPTIONS_RANK.." "..newRank..")");
					return true;
				end
			end
		end
	end
	return false;
end

--[[ Casts the passed spell at the passed unit ]]--
CastOptions.CastAtUnit = function (unit, byName, bookType, container, spell, number, onSelf, localSelfCast, spellName, spellRank, texture)
	local _, pClass = UnitClass("player");
	local castSelf = nil;
	if ( ( onSelf == 1 ) or ( unit == "player" ) ) then
		castSelf = 1;
	end
	
	--Only cast if the target exists
	if ( UnitExists(unit) ) then
		local clearedTarget = nil;
		local targtedHostile = nil;
		if ( UnitIsFriend("player", unit) ) then
			if ( UnitExists("target") ) then
				--If the current target is friendly, or a hostile and the spell is dispel, then select no target, so we can get a targeting cursor
				if (	( UnitName(unit) ~= UnitName("target") ) and ( ( not UnitCanAttack("player", "target") ) or
							( pClass and ( pClass == "PRIEST" ) and texture == "Interface\\Icons\\Spell_Holy_DispelMagic" ) ) ) then
					ClearTarget();
					clearedTarget = true;
				end
			end
		else
			--If the target unit is not a friend, then we have to target it first
			TargetUnit(unit);
			targtedHostile = true;
		end

		--Begin casting the spell
		CastOptions.DoCast(byName, bookType, container, spell, number, castSelf);

		--If we had targeted a hostile unit, then return to the prvious target
		if (targtedHostile) then
			TargetLastTarget();
		else
			if (SpellIsTargeting()) then
				--If we need to lower the rank of the spell, then do so now
				if ( ( CastOptions_Config.SmartRank == 1 ) and (unit ~= "player") and spellName and spellRank and pClass and texture ) then
					--if there is a buff entry for this spell, then check to see if we need to cast a lower rank
					local buffInfo = CastOptions.SpellData.Ranks[pClass][texture];
					if (buffInfo) then
						--if we need to cast a lower rank then do so
						local newRank = CastOptions.GetRank(unit, spellName, spellRank, texture);
						if ( newRank and (newRank ~= spellRank) ) then
							SpellStopTargeting();
							CastOptions.DoCastSpellByName(spellName.."("..CASTOPTIONS_RANK.." "..newRank..")");
						end
					end
				end
	
				--Record this spell cast, if the spell is actually going to hit the target
				if ( SpellCanTargetUnit(unit) ) then
					CastOptions.StoreRecentCast(unit, spellName, texture, localSelfCast);
				end
	
				--If the spell is waiting for a target, give it one
				SpellTargetUnit(unit);
			else
				--Record this spell cast
				CastOptions.StoreRecentCast(unit, spellName, texture, localSelfCast);
			end
	
			--If we cleared the target early, then retarget now
			if (clearedTarget) then
				TargetLastTarget();
			end
		end
	else
		--If the desired unit does not exist, then give an error
		UIErrorsFrame:AddMessage(SPELL_FAILED_BAD_TARGETS, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
	end
end

--[[ Does the actual casting part of the casting function ]]--
CastOptions.DoCast = function (byName, bookType, container, spell, number, onSelf)
	--Cast the spell via appropriate mechanism
	if (byName) then
		--Cast by spell name
		CastOptions.DoCastSpellByName(spell);
	else
		if (not container) then
			if (not bookType) then
				--call the default handler
				MCom.callHook("UseAction", spell, number, onSelf);
			else
				--call the default handler
				MCom.callHook("CastSpell", spell, bookType);
			end
		else
			--call the default handler
			MCom.callHook("UseContainerItem", container, spell);
		end
	end

	--self cast by targeting ourself, if needed
	if( ( onSelf == 1 ) and SpellIsTargeting() ) then
		SpellTargetUnit("player");
	end
end

--[[ Does the actual casting procedure ]]--
CastOptions.Cast = function (byName, bookType, container, spell, number, onSelf)
	--if we Cast Options is not enabled, or if we are holding something, then use the default handler
	if ( (CastOptions_Config.Enabled ~= 1) or (CastOptions.Holding == 1) ) then 
		return true;
	end
	--If we should call the origional this will become false
	local callOrig = true;
	--Make sure we have the spell data
	if (not CastOptions.SpellData.Player) then
		CastOptions.GetSpellInfo();
	end	
	
	--If this is by name and not coming from ChatFrame1, then don't proccess it
	local validCast = true;
	if ( byName ) then
		validCast = false;
		if ( this and ( this:GetName() == "ChatFrame1" ) ) then
			validCast = true;
		end
	end
	--If this is by book and not coming from SpellBookFrame, then don't proccess it
	if ( bookType ) then
		validCast = false;
		if ( this and this:GetParent() and ( this:GetParent():GetName() == "SpellBookFrame" ) ) then
			validCast = true;
		end
	end
	--If this is a macro, then don't proccess it
	if ( ( not byName ) and ( not bookType ) and ( not container ) and spell ) then
		--We identify this as a macro by seing if it has text, only macros have text
		local macroName = GetActionText(spell);
		if ( macroName and ( macroName ~= "" ) ) then
			validCast = false;
		end
	end

	--Make sure we have spell
	if ( spell and validCast ) then
		--Get the self cast table
		local localSelfCast = CastOptions.GetSelfTable(container);
		--Get the hostile cast table
		local localHostileCast = CastOptions.GetHostileTable(container);
		
		local spellRank = nil;
		local spellName = nil;
		
		--If we are supposed to cast by name, then get the name from the passed spell name
		--otherwise get it from the tooltip
		if (byName) then
			--Find the rank portion of the spell name
			local nameStart, nameStop;
			nameEnd, _, spellRank = string.find(spell, CASTOPTIONS_RANK_PARSE);
			--Default the spell name to all of spell, incase we didn't find the rank portion
			spellName = spell;
			if (nameEnd) then
				spellName = string.sub(spell, 1, nameEnd - 1);
			end
			spellRank = tonumber(spellRank);
		else
			if (not container) then
				--If it's not a book spell, then get the action info
				if (not bookType) then
					--Setup the invisible cast options tooltip with the spell, so we can get info on the spell
					Sea.wow.tooltip.protectTooltipMoney();
					CastOptionsTooltip:SetAction(spell);
					Sea.wow.tooltip.unprotectTooltipMoney();
					local tip = Sea.wow.tooltip.scan("CastOptionsTooltip");
					
					--Make sure we have the info we need from the tooltip
					if (tip and tip[1] and tip[1]["left"]) then
						--Get the spell name
						spellName = tip[1]["left"];
		
						--Get the spell rank
						if ( (tip[1]["right"] ~= "") and (tip[1]["right"]) ) then
							local first, last;
							first, last, spellRank = string.find(tip[1]["right"], "[^%d]*(%d+)");
							spellRank = tonumber(spellRank);
						end
					end
				else
					--Get the spell name and rank from the book
					spellName, spellRank = GetSpellName(spell, bookType);
					if (spellRank) then
						local _, _, spellRankNum = string.find(spellRank, "(%d+)");
						
						if (spellRankNum) then
							spellRank = tonumber(spellRankNum);
						end
					end
				end
			end
		end

		--Get the texture for the spell
		local texture = nil;
		--If this isn't a container item then get the texture from the spell book
		if (not container) then
			--If the spell is passed by name, then look it up in the list
			if (byName) then
				if (spellName and CastOptions.SpellData.Player[spellName]) then
					texture = GetSpellTexture(CastOptions.SpellData.Player[spellName], BOOKTYPE_SPELL);
				end
			elseif (not bookType) then
				--If the spell is passed by action id, then get the texture from that
				texture = GetActionTexture(spell);
			else
				--If the spell is a spell book type, then get the texture from it
				texture = GetSpellTexture(spell, bookType);
			end
		else
			--Get the texture from the container slot
			texture = GetContainerItemInfo(container, spell);
		end
		
		--If enabled then print the spell texture
		if ( (CastOptions.Texture == 1) and texture) then
			Sea.io.print(texture);
		end

		--Get the player clas
		local _, pClass = UnitClass("player");

		--Cancel the wand if need be
		if (CastOptions_Config.CancelWand == 1) then
			--Get the wand texture, if there is one
			local rangedTexture = GetInventoryItemTexture("player", GetInventorySlotInfo("RangedSlot"));
			--If we are casting a wand, then stop doing so now
			if ( ( ( pClass == "MAGE" ) or ( pClass == "PRIEST" ) or ( pClass == "WARLOCK" ) ) and
						rangedTexture and CastOptions.SpellData.Player[rangedTexture] and ( texture ~= rangedTexture ) and
						CastOptions.IsAutoRepeating ) then
				--Get the wand spell ID
				local shootID = CastOptions.SpellData.Player[rangedTexture];
				--Get the name of the wand spell
				local shotName = GetSpellName(shootID, BOOKTYPE_SPELL);
				--If the wand action is in the action bar, get its ID
				local shootAID = CastOptions.GetSpellActionID(shotName);
				if (shootAID) then
					--Cast the wand action, to stop it
					MCom.callHook("UseAction", shootAID);
				else
					--Cast the wand spell, to stop it
					MCom.callHook("CastSpell", shootID, BOOKTYPE_SPELL);
				end

				--Let the user know that we canceled the wand shot
				if (CastOptions_Config.ShowCancelShot == 1) then
					UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_CANCELED_WAND, 1.0, 0.1, 0.1, 1.0, CastOptions.SHOT_CANCELED_HOLD_TIME);
				end
			end
		end

		--Cancel auto shot if need be
		if (CastOptions_Config.CancelShot == 1) then
			--Get the bow/gun texture, if there is one
			local rangedTexture = GetInventoryItemTexture("player", GetInventorySlotInfo("RangedSlot"));
			--If we are firing a ranged weapon, then stop doing so now
			if ( ( ( pClass == "HUNTER" ) or ( pClass == "ROGUE" ) or ( pClass == "WARRIOR" ) ) and
						rangedTexture and CastOptions.SpellData.Player[rangedTexture] and ( texture ~= rangedTexture ) and
						CastOptions.IsAutoRepeating and texture and localSelfCast and localSelfCast[texture] and localSelfCast[texture].f ) then
				--Get the auto shot spell ID
				local shootID = CastOptions.SpellData.Player[rangedTexture];
				--Get the name of the auto shot spell
				local shotName = GetSpellName(shootID, BOOKTYPE_SPELL);
				--If auto shot is in the action bar, get its ID
				local shootAID = CastOptions.GetSpellActionID(shotName);
				if (shootAID) then
					--Cast the auto shot action, to stop it
					MCom.callHook("UseAction", shootAID);
				else
					--Cast the auto shot spell, to stop it
					MCom.callHook("CastSpell", shootID, BOOKTYPE_SPELL);
				end

				--Let the user know that we canceled the auto shot
				if (CastOptions_Config.ShowCancelShot == 1) then
					UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_CANCELED_SHOT, 1.0, 0.1, 0.1, 1.0, CastOptions.SHOT_CANCELED_HOLD_TIME);
				end
			end
		end
		
		--If this spell requires checking for a range indicator to be sure it is the right spell, then check now
		local hasRange = true;
		if ( not CastOptions.SpellHasRange(texture, spellName) ) then
			hasRange = false;
		end
		if (hasRange) then
			--Get the aimed unit, if there is one
			local aimedUnit = CastOptions.GetAimedUnit(texture, localSelfCast)

			--Cast at the key targeted unit if there is one
			if ( CastOptions.AnyKeysDown() or ( onSelf == 1 ) ) then
				--Default to player as the target
				local curUnit = "player";
				local castSelf = 1;
				--If any of the other possible targets is selected, then use it instead
				for curTarg in CastOptions.Targ do
					if ( ( curTarg ~= "player" ) and ( CastOptions.Targ[curTarg] == 1 ) ) then
						curUnit = curTarg;
						castSelf = nil;
						break;
					end
				end

				--Cast the spell at the unit
				CastOptions.CastAtUnit(curUnit, byName, bookType, container, spell, number, castSelf, localSelfCast, spellName, spellRank, texture);

				--We cast our spell, so dont call the origional
				callOrig = false;
			elseif ( aimedUnit ) then
				--Cast the spell at the aimed unit, if there is one
				CastOptions.CastAtUnit(aimedUnit, byName, bookType, container, spell, number, onSelf, localSelfCast, spellName, spellRank, texture);

				--We cast our spell, so dont call the origional
				callOrig = false;
			elseif (	CastOptions.UseGroup() and texture and localSelfCast[texture] and
								( not ( (UnitExists("target") and UnitCanAttack("player", "target") and UnitIsFriend("player", "target") ) ) ) ) then
				--Cast this on the most elligable group member if it is a heal or a buff or a cure
				--Get the type of spell we are casting
				local spellType = localSelfCast[texture];

				--If there is a target, the get the name of it
				local clearedTarget = nil;
				if ( UnitExists("target") ) then
					--If the target is friendly, or a hostile and the spell is dispel, then select no target, so we can get a targeting cursor
					if ( ( not UnitCanAttack("player", "target") ) or ( pClass and ( pClass == "PRIEST" ) and texture == "Interface\\Icons\\Spell_Holy_DispelMagic" ) ) then
						ClearTarget();
						clearedTarget = true;
					end
				end

				--Begin casting the spell
				CastOptions.DoCast(byName, bookType, container, spell, number);

				--Find the most eligable unit to cast on
				local curUnit = CastOptions.FindCastUnit(texture, spellName, spellRank, spellType);

				if ( (not curUnit) and CastOptions.UseSmart(texture, localSelfCast) and CastOptions.SelfDispel(texture) ) then
					curUnit = "player";
				end

				if (curUnit) then
					--If we need to lower the rank of the spell, then do so now
					if ( ( CastOptions_Config.SmartRank == 1 ) and (curUnit ~= "player") and spellName and spellRank and pClass and texture ) then
						--if there is a buff entry for this spell, then check to see if we need to cast a lower rank
						local buffInfo = CastOptions.SpellData.Ranks[pClass][texture];
						if (buffInfo) then
							--if we need to cast a lower rank then do so
							local newRank = CastOptions.GetRank(curUnit, spellName, spellRank, texture);
							if (newRank and (newRank ~= spellRank)) then
								SpellStopTargeting();
								CastOptions.DoCastSpellByName(spellName.."("..CASTOPTIONS_RANK.." "..newRank..")");
							end
						end
					end

					--Cast the spell at the unit
					if (SpellIsTargeting()) then
						SpellTargetUnit(curUnit);
					end
					if (CastOptions_Config.GroupTarget == 1) then
						--Target the unit
						TargetUnit(curUnit);
						clearedTarget = nil;
					end
					--Record this spell cast
					CastOptions.StoreRecentCast(curUnit, spellName, texture, localSelfCast);
				end

				if( SpellIsTargeting() ) then
					--If no target was found, then show an error
					UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_NOTARG, 1.0, 0.1, 0.1, 1.0, CastOptions.NOTARG_HOLD_TIME);
					--If the spell is still targeting, and we have spell canceling enabled, then cancel the spell now
					if ( CastOptions_Config.CancelSpell == 1 ) then
						SpellStopTargeting();
					end
				end

				--If we cleared the target early, then retarget now
				if (clearedTarget) then
					--If we didn't pick a target to cast at, but already had an elligible target
					--then when we retarget it, it will get cast at, but not selected, so we need
					--to target once for the cast, and again for the retargeting
					if ( SpellIsTargeting() ) then
						TargetLastTarget();
					end
					TargetLastTarget();
				end

				--We cast our spell, so dont call the origional
				callOrig = false;
			elseif ( texture and localSelfCast[texture] and CastOptions.UseSmart(texture, localSelfCast) and CastOptions.SelfDispel(texture) ) then
				--Smart Self Cast this if we should
				CastOptions.DoCast(byName, bookType, container, spell, number, 1);
				--Record this spell cast
				CastOptions.StoreRecentCast("player", spellName, texture, localSelfCast);
				--We cast our spell, so dont call the origional
				callOrig = false;
			elseif ( CastOptions.RankCast(spellName, spellRank, texture) ) then
				--Record this spell cast
				CastOptions.StoreRecentCast("target", spellName, texture, localSelfCast);
				--If we have cast the spell at a lower rank, then don't do the default function
				callOrig = false;
			elseif ( (CastOptions_Config.SmartAssist == 1) and texture and localHostileCast[texture] ) then
				--If smart assist casting is enabled, and this spell is hostile, then do so now
				--Only proceed if the target is friendly
				if ( UnitExists("target") and UnitIsFriend("player", "target") and (not UnitCanAttack("player", "target") ) ) then
					--Only proceed if we don't have ourselves targeted
					if ( UnitName("target") ~= UnitName("player") ) then
						--Start by pointing at target, so we can look at targets target on first loop
						local curTarg = "target";
						local changedTarget = false;
						for count = 1, 100 do
							--Add target on the end
							curTarg = curTarg.."target";
							--If we've targeted a hostile, then try casting the hostile spell at it
							if ( UnitExists(curTarg) and UnitCanAttack("player", curTarg) ) then
								--Target the unit
								TargetUnit(curTarg);
								changedTarget = true;
								
								--Only cast if the target is not bound
								if ( not CastOptions.SpellBound(texture, localHostileCast) ) then
									CastOptions.DoCast(byName, bookType, container, spell, number);
								end
								break;
							elseif (CastOptions_Config.ChainAssist ~= 1) then
								--If chain assist is off, then stop now
								break;
							end
						end
						--If we want to return to the friendly target, then do so now
						if ( changedTarget and ( CastOptions_Config.AssistTarget ~= 1) ) then
							TargetLastTarget();
						end
					end
				end
			end
		end

		--If we are going to be calling the origonal, but the spell is bound, don't call it
		if ( callOrig and CastOptions.SpellBound(texture, localHostileCast) ) then
			callOrig = false;
		end
		
		--If we are going to be calling the origonal, but the spell is a mana spell, and the target shouldn't be getting a mana spell, then don't call it
		if (	callOrig and ( CastOptions.ManaControl == 1 ) and UnitExists("target") and ( UnitPowerType("target") ~= 0 ) and
					texture and localSelfCast and localSelfCast[texture] and localSelfCast[texture].n ) then
			callOrig = false;
			UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_NOMANA, 1.0, 0.1, 0.1, 1.0, CastOptions.NOMANA_HOLD_TIME);
		end

		if (callOrig) then
			--Record this spell cast
			CastOptions.StoreRecentCast("target", spellName, texture, localSelfCast);
		end
	end
	
	--call the default handler if neccisary
	return callOrig;
end

--[[ Saves the current configuration on a per realm/per character basis ]]--
CastOptions.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "CastOptions_Config";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
CastOptions.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "CastOptions_Config";
		nonUIList = {};
	});
end

--------------------------------------------------
--
-- Hooked Functions
--
--------------------------------------------------
function CastOptions.PlaceAction(id)
	AltSelfCast_Holding = 0;
end

function CastOptions.PickupAction(id)
	AltSelfCast_Holding = 1;
end

function CastOptions.UseAction(id, number, onSelf)
	--Cast the spell by id using CastOptions methods
	return CastOptions.Cast(false, nil, nil, id, number, onSelf);
end

function CastOptions.UseContainerItem(container, id)
	--Cast the container item by container and id using CastOptions methods
	return CastOptions.Cast(false, nil, container, id);
end

function CastOptions.CastSpell(id, bookType)
	--Cast the book spell by book type and id using CastOptions methods
	return CastOptions.Cast(false, bookType, nil, id);
end

function CastOptions.CastSpellByName(spell)
	--Cast the spell by name using CastOptions methods
	if (CastOptions.Cast(true, nil, nil, spell)) then
		CastOptions.DoCastSpellByName(spell);
	end
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
CastOptions.OnEvent = function (event)
	--When the info on the spells change, we need to update our tables
	if (event == "SPELLS_CHANGED") then
		CastOptions.GetSpellInfo();
	end

	--If this is a wand casting or ranged auto shot, then record the state
	if (event == "START_AUTOREPEAT_SPELL") then
		CastOptions.IsAutoRepeating = true;
	end
	if (event == "STOP_AUTOREPEAT_SPELL") then
		CastOptions.IsAutoRepeating = nil;
	end
end;

CastOptions.OnVarsLoaded = function ()
	if (not CastOptions.ConfigLoaded) then
		CastOptions.ConfigLoaded = true;
		--Load the configuration
		CastOptions.LoadConfig();
		--Store the configuration for this character
		CastOptions.SaveConfig();
	end;
end

CastOptions.OnLoad = function ()
	--If AltSelfCast is around, then get out, and get out NOW!
	if (AltSelfCast_OnLoad) then
		UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_ASC, 1.0, 0.1, 0.1, 1.0, 30);
		Sea.io.printc({r=1;g=0;b=0;}, CASTOPTIONS_ERROR_ASC_INFO);
		PlaySoundFile("Sound\\interface\\Error.wav");
		CastOptions = nil;
		return;
	end
	
	if ( CastOptions.Initialized ~= 1) then
		--Register our configuration variable to be saved
		RegisterForSave("CastOptions_Config");
		
		--When the info on the spells change, we need to update our tables
		this:RegisterEvent("SPELLS_CHANGED");
		--Track wheater we are autorepeating or not
		this:RegisterEvent("START_AUTOREPEAT_SPELL");
		this:RegisterEvent("STOP_AUTOREPEAT_SPELL");

		--Hook functions
		CastOptions.SetupHooks(1);
		
		--Smart register all the options
		--Register a seperator, specifying section, and main super slash command
		MCom.registerSmart( {
			uifolder = "combat";															--The folder to use in Khaos
			uisec = "CastOptions";														--The section/set to use in the UI
			uiseclabel = CASTOPTIONS_CONFIG_SECTION;					--The section/set label
			uisecdesc = CASTOPTIONS_CONFIG_SECTION_INFO;			--The section/set description
			uisecdiff = 1;																		--The section/set difficulty
			uivar = "CastOptionsSeparator";										--The option name for the UI
			uitype = K_HEADER;																--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_MAIN_HEADER;					--The label to use for the seperator in the UI
			uidesc = CASTOPTIONS_CONFIG_MAIN_HEADER_INFO;			--The description to use for the seperator in the UI
			uiver = CastOptions.VERSION;											--The version number to display in the UI
			uiframe = "CastOptionsFrame";											--The frame to identify this addon by
			supercom = {"/castoptions", "/co"};								--The main slash command, and any aliases for it
			comaction = "before";															--See Sky for info on this
			comsticky = false;																--See Sky for info on this
			comhelp = CASTOPTIONS_CHAT_COMMAND_INFO;					--The help text to show for the slash command
			name = CASTOPTIONS_CONFIG_SECTION;								--The name of the addon, for display in the info text
			infotext = CASTOPTIONS_CONFIG_INFOTEXT;						--The text to show when the help function is called
		} );
		--Register a checkbox, and a boolean sub slash command for Enabled
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsEnabled";												--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_ENABLED;								--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_ENABLED_INFO;						--The description to use for the checkbox in the UI
			uidiff = 1;																					--The difficulty of the option
			varbool = "CastOptions_Config.Enabled";							--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_ENABLED;								--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.Enabled;								--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"enable"};																--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_ENABLED_INFO;					--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for SmartRank
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsSmartRank";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SMARTRANK;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_SMARTRANK_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.SmartRank";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_SMARTRANK;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.SmartRank;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"smartrank", "sr"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_SMARTRANK_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for CancelWand
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsCancelWand";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_CANCELWAND;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_CANCELWAND_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.CancelWand";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_CANCELWAND;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.CancelWand;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"cancelwand", "cw"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_CANCELWAND_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for CancelShot
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsCancelShot";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_CANCELSHOT;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_CANCELSHOT_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.CancelShot";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_CANCELSHOT;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.CancelShot;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"cancelautoshot", "cas"};									--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_CANCELSHOT_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for ShowCancelShot
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsShowCancelShot";								--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SHOWCANCELSHOT;				--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO;		--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.ShowCancelShot";			--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_SHOWCANCELSHOT;					--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.ShowCancelShot;				--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"showcancelshot", "scs"};									--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO;		--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for NoDispel
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsNoDispel";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_NODISPEL;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_NODISPEL_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.NoDispel";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_NODISPEL;								--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.NoDispel;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"nodispel", "nd"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_NODISPEL_INFO;					--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for ManaControl
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsManaControl";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_MANACONTROL;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_MANACONTROL_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.ManaControl";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_MANACONTROL;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.ManaControl;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"manacontrol", "mc"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_MANACONTROL_INFO;			--The help text for the sub slash command
		} );
		--Register a button, and a simple slash command to toggle self cast
		MCom.registerSmart( {
			uivar = "CastOptionsToggle";										--The option name for the UI
			uitype = "BUTTON";															--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_TOGGLESELF;				--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_TOGGLESELF_INFO;		--The description to use for the checkbox in the UI
			uidiff = 3;																			--The difficulty of the option
			func = CastOptions.ToggleSelf;									--The function to call
			uitext = CASTOPTIONS_CONFIG_TOGGLESELF_TEXT;		--The text to show on the button
			supercom = "/castoptions";											--The main(super) slash command associated with this subommand
			subcom = {"toggleself", "ts"};									--The sub slash command and any aliases
			subhelp = CASTOPTIONS_CONFIG_TOGGLESELF_INFO;		--The help text for the sub slash command
		} );
		--Register a seperator
		MCom.registerSmart( {
			uivar = "CastOptionsKeysSep";											--The option name for the UI
			uitype = "SEPARATOR";															--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_KEYS_HEADER;					--The label to use for the seperator in the UI
			uidesc = CASTOPTIONS_CONFIG_KEYS_HEADER_INFO;			--The description to use for the seperator in the UI
			uidiff = 1;
		} );
		--Register a checkbox, and a boolean sub slash command for Alt
		MCom.registerSmart( {
			hasbool = true;																	--Whether this options has a boolean part
			uivar = "CastOptionsAlt";												--The option name for the UI
			uitype = K_TEXT;																--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_ALT;								--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_ALT_INFO;						--The description to use for the checkbox in the UI
			uidiff = 1;																			--The difficulty of the option
			varbool = "CastOptions_Config.Alt";							--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_ALT;								--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.Alt;								--The default value for the checkbox in the UI
			supercom = "/castoptions";											--The main(super) slash command associated with this subommand
			subcom = {"alt"};																--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_ALT_INFO;					--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for Shift
		MCom.registerSmart( {
			hasbool = true;																		--Whether this options has a boolean part
			uivar = "CastOptionsShift";												--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SHIFT;								--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_SHIFT_INFO;						--The description to use for the checkbox in the UI
			uidiff = 1;																				--The difficulty of the option
			varbool = "CastOptions_Config.Shift";							--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_SHIFT;								--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.Shift;								--The default value for the checkbox in the UI
			supercom = "/castoptions";												--The main(super) slash command associated with this subommand
			subcom = {"shift"};																--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_SHIFT_INFO;					--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for Ctrl
		MCom.registerSmart( {
			hasbool = true;																		--Whether this options has a boolean part
			uivar = "CastOptionsCtrl";												--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_CTRL;								--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_CTRL_INFO;						--The description to use for the checkbox in the UI
			uidiff = 1;																				--The difficulty of the option
			varbool = "CastOptions_Config.Ctrl";							--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_CTRL;									--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.Ctrl;								--The default value for the checkbox in the UI
			supercom = "/castoptions";												--The main(super) slash command associated with this subommand
			subcom = {"control", "ctrl"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_CTRL_INFO;						--The help text for the sub slash command
		} );
		--Register a seperator
		MCom.registerSmart( {
			uivar = "CastOptionsAimedKeysSep";									--The option name for the UI
			uitype = "SEPARATOR";																--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER;			--The label to use for the seperator in the UI
			uidesc = CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER_INFO;	--The description to use for the seperator in the UI
			uidiff = 2;
		} );
		--Register a checkbox, and a boolean sub slash command for AimedCast
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsAimedCast";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_AIMEDCAST;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_AIMEDCAST_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.AimedCast";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_AIMEDCAST;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.AimedCast;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"aimedcast", "ac"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_AIMEDCAST_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for AimedWorld
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsAimedWorld";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_AIMEDWORLD;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_AIMEDWORLD_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.AimedWorld";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_AIMEDWORLD;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.AimedWorld;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"aimedworld", "aw"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_AIMEDWORLD_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for AimedHostile
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsAimedHostile";									--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_AIMEDHOSTILE;					--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_AIMEDHOSTILE_INFO;			--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.AimedHostile";				--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_AIMEDHOSTILE;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.AimedHostile;					--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"aimedhostile", "ah"};										--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_AIMEDHOSTILE_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for AimedAlt
		MCom.registerSmart( {
			hasbool = true;																		--Whether this options has a boolean part
			uivar = "CastOptionsAimedAlt";										--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_AIMEDALT;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_AIMEDALT_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																				--The difficulty of the option
			varbool = "CastOptions_Config.AimedAlt";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_AIMEDALT;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.AimedAlt;						--The default value for the checkbox in the UI
			supercom = "/castoptions";												--The main(super) slash command associated with this subommand
			subcom = {"aimedalt", "aalt"};										--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_AIMEDALT_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for AimedShift
		MCom.registerSmart( {
			hasbool = true;																		--Whether this options has a boolean part
			uivar = "CastOptionsAimedShift";									--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_AIMEDSHIFT;					--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_AIMEDSHIFT_INFO;			--The description to use for the checkbox in the UI
			uidiff = 2;																				--The difficulty of the option
			varbool = "CastOptions_Config.AimedShift";				--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_AIMEDSHIFT;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.AimedShift;					--The default value for the checkbox in the UI
			supercom = "/castoptions";												--The main(super) slash command associated with this subommand
			subcom = {"aimedshift", "ashift"};								--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_AIMEDSHIFT_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for AimedCtrl
		MCom.registerSmart( {
			hasbool = true;																		--Whether this options has a boolean part
			uivar = "CastOptionsAimedCtrl";										--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_AIMEDCTRL;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_AIMEDCTRL_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																				--The difficulty of the option
			varbool = "CastOptions_Config.AimedCtrl";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_AIMEDCTRL;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;									--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.AimedCtrl;						--The default value for the checkbox in the UI
			supercom = "/castoptions";												--The main(super) slash command associated with this subommand
			subcom = {"aimedcontrol", "aimedctrl", "actrl"};	--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_AIMEDCTRL_INFO;			--The help text for the sub slash command
		} );
		--Register a seperator
		MCom.registerSmart( {
			uivar = "CastOptionsSmartSep";											--The option name for the UI
			uitype = "SEPARATOR";																--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SMART_HEADER;					--The label to use for the seperator in the UI
			uidesc = CASTOPTIONS_CONFIG_SMART_HEADER_INFO;			--The description to use for the seperator in the UI
			uidiff = 1;
		} );
		--Register a checkbox, and a boolean sub slash command for Smart
		MCom.registerSmart( {
			hasbool = true;																		--Whether this options has a boolean part
			uivar = "CastOptionsSmart";												--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SMART;								--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_SMART_INFO;						--The description to use for the checkbox in the UI
			uidiff = 1;																				--The difficulty of the option
			varbool = "CastOptions_Config.Smart";							--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_SMART;								--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.Smart;								--The default value for the checkbox in the UI
			supercom = "/castoptions";												--The main(super) slash command associated with this subommand
			subcom = {"smartcast", "smart", "sc"};						--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_SMART_INFO;					--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for NoGroup
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsNoGroup";												--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_NOGROUP;								--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_NOGROUP_INFO;						--The description to use for the checkbox in the UI
			uidiff = 1;																					--The difficulty of the option
			varbool = "CastOptions_Config.NoGroup";							--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_NOGROUP;								--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.NoGroup;								--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"nogroup", "ng"};													--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_NOGROUP_INFO;					--The help text for the sub slash command
		} );
		--Register a seperator
		MCom.registerSmart( {
			uivar = "CastOptionsSmartAssistSep";								--The option name for the UI
			uitype = "SEPARATOR";																--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SMARTASSIST_HEADER;		--The label to use for the seperator in the UI
			uidesc = CASTOPTIONS_CONFIG_SMARTASSIST_HEADER_INFO;--The description to use for the seperator in the UI
			uidiff = 2;
		} );
		--Register a checkbox, and a boolean sub slash command for SmartAssist
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsSmartAssist";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SMARTASSIST;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_SMARTASSIST_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.SmartAssist";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_SMARTASSIST;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.SmartAssist;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"smartassist", "sa"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_SMARTASSIST_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for AssistTarget
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsAssistTarget";									--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_ASSISTTARGET;					--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_ASSISTTARGET_INFO;			--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.AssistTarget";				--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_ASSISTTARGET;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.AssistTarget;					--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"assisttarget", "at"};										--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_ASSISTTARGET_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for ChainAssist
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsChainAssist";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_CHAINASSIST;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_CHAINASSIST_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.ChainAssist";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_CHAINASSIST;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.ChainAssist;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"chainassist", "ca"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_CHAINASSIST_INFO;			--The help text for the sub slash command
		} );
		--Register a seperator
		MCom.registerSmart( {
			uivar = "CastOptionsSmartGroupSep";									--The option name for the UI
			uitype = "SEPARATOR";																--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SMARTGROUP_HEADER;			--The label to use for the seperator in the UI
			uidesc = CASTOPTIONS_CONFIG_SMARTGROUP_HEADER_INFO;	--The description to use for the seperator in the UI
			uidiff = 2;
		} );
		--Register a checkbox, and a boolean sub slash command for SmartGroup
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsSmartGroup";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_SMARTGROUP;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_SMARTGROUP_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.SmartGroup";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_SMARTGROUP;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.SmartGroup;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"smartgroup", "sg"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_SMARTGROUP_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupPets
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupPets";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPPETS;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPPETS_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupPets";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPPETS;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupPets;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"grouppets", "gp"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPPETS_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupTarget
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupTarget";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPTARGET;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPTARGET_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupTarget";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPTARGET;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupTarget;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"grouptarget", "gt"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPTARGET_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupGroup
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupGroup";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPGROUP;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPGROUP_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupGroup";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPGROUP;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupGroup;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"groupcast", "gc"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPGROUP_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupSelf
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupSelf";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPSELF;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPSELF_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupSelf";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPSELF;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupSelf;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"groupself", "gs"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPSELF_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupHeal
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupHeal";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPHEAL;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPHEAL_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupHeal";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPHEAL;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupHeal;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"groupheal", "gh"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPHEAL_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupMana
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupMana";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPMANA;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPMANA_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupMana";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPMANA;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupMana;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"groupmana", "gm"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPMANA_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupCure
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupCure";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPCURE;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPCURE_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupCure";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPCURE;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupCure;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"groupcure", "gcu"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPCURE_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for GroupBuff
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsGroupBuff";											--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_GROUPBUFF;							--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_GROUPBUFF_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.GroupBuff";						--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_GROUPBUFF;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.GroupBuff;							--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"groupbuff", "gb"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_GROUPBUFF_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for CancelSpell
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsCancelSpell";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_CANCELSPELL;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_CANCELSPELL_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.CancelSpell";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_CANCELSPELL;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.CancelSpell;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"cancelspell", "cs"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_CANCELSPELL_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox and slider, and a boolean and number sub slash command for RecastTime
		MCom.registerSmart( {
			uivar = "CastOptionsRecastTime";										--The option name for the UI
			uitype = K_SLIDER;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_RECASTTIME;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_RECASTTIME_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varnum = "CastOptions_Config.RecastTime";						--The number variable associate with this option
			textname = CASTOPTIONS_CHAT_RECASTTIME;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uislider = CastOptions_Config.RecastTime;						--The default value for the checkbox in the UI
			uimin = 0;
			uimax = CastOptions.MAX_RECAST;
			uitext = CASTOPTIONS_CONFIG_RECASTTIME;
			uistep = 1;
			uitexton = 1;
			uisuffix = CASTOPTIONS_CONFIG_RECASTTIME_SUFFIX;
			uimul = 1;
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"recasttime", "rct"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_RECASTTIME_INFO;				--The help text for the sub slash command
		} );
		--Register a seperator
		MCom.registerSmart( {
			uivar = "CastOptionsBoundSep";										--The option name for the UI
			uitype = "SEPARATOR";															--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_BOUND_HEADER;				--The label to use for the seperator in the UI
			uidesc = CASTOPTIONS_CONFIG_BOUND_HEADER_INFO;		--The description to use for the seperator in the UI
			uidiff = 2;
		} );
		--Register a checkbox, and a boolean sub slash command for NoBoundCast
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsNoBoundCast";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_NOBOUNDCAST;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_NOBOUNDCAST_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																					--The difficulty of the option
			varbool = "CastOptions_Config.NoBoundCast";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_NOBOUNDCAST;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.NoBoundCast;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"noboundcast", "nbc"};										--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_NOBOUNDCAST_INFO;					--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for BoundPotential
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsBoundPotential";								--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_BOUNDPOTENTIAL;				--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_BOUNDPOTENTIAL_INFO;		--The description to use for the checkbox in the UI
			uidiff = 3;																					--The difficulty of the option
			varbool = "CastOptions_Config.BoundPotential";			--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_BOUNDPOTENTIAL;					--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.BoundPotential;				--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"noboundpotential", "nbp"};								--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_BOUNDPOTENTIAL_INFO;		--The help text for the sub slash command
		} );
		--Register a checkbox, and a boolean sub slash command for BoundAttack
		MCom.registerSmart( {
			hasbool = true;																			--Whether this options has a boolean part
			uivar = "CastOptionsBoundAttack";										--The option name for the UI
			uitype = K_TEXT;																		--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_BOUNDATTACK;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_BOUNDATTACK_INFO;				--The description to use for the checkbox in the UI
			uidiff = 3;																					--The difficulty of the option
			varbool = "CastOptions_Config.BoundAttack";					--The boolean variable associate with this option
			textname = CASTOPTIONS_CHAT_BOUNDATTACK;						--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uicheck = CastOptions_Config.BoundAttack;						--The default value for the checkbox in the UI
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"noboundattack", "nba"};									--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_BOUNDATTACK_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox and slider, and a boolean and number sub slash command for BoundDelay
		MCom.registerSmart( {
			uivar = "CastOptionsBoundDelay";										--The option name for the UI
			uitype = K_SLIDER;																	--The option type for the UI
			uilabel = CASTOPTIONS_CONFIG_BOUNDDELAY;						--The label to use for the checkbox in the UI
			uidesc = CASTOPTIONS_CONFIG_BOUNDDELAY_INFO;				--The description to use for the checkbox in the UI
			uidiff = 3;																					--The difficulty of the option
			varnum = "CastOptions_Config.BoundDelay";						--The number variable associate with this option
			textname = CASTOPTIONS_CHAT_BOUNDDELAY;							--What to say when the command is successfully updated, and there is no GUI
			update = CastOptions.SaveConfig;										--A command to perform when the option is succesfully updated
			uislider = CastOptions_Config.BoundDelay;						--The default value for the checkbox in the UI
			uimin = 0;
			uimax = CastOptions.MAX_BOUNDDELAY;
			uitext = CASTOPTIONS_CONFIG_BOUNDDELAY;
			uistep = 0.1;
			uitexton = 1;
			uisuffix = CASTOPTIONS_CONFIG_BOUNDDELAY_SUFFIX;
			uimul = 1;
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"bounddelay", "bd"};											--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_BOUNDDELAY_INFO;				--The help text for the sub slash command
		} );
		--Register a boolean sub slash command for Texture feedback
		MCom.registerSmart( {
			supercom = "/castoptions";													--The main(super) slash command associated with this subommand
			subcom = {"texture", "tex"};												--The sub slash command and any aliases for this option
			subhelp = CASTOPTIONS_CONFIG_TEXTURE_INFO;					--The help text for the sub slash command
			comtype = MCOM_BOOLT;
			varbool = "CastOptions.Texture";
			textbool = CASTOPTIONS_CHAT_TEXTURE;
			textshow = true;
		} );
		
		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(CastOptions.OnVarsLoaded);

		CastOptions.Initialized = 1;
	end
end;
