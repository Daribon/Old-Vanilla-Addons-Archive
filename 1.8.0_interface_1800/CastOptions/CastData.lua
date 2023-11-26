--[[
	Cast Data
	 	Contain data needed to properly handle the many spells and items in the game
	
	By: Mugendai
	Special Thanks:
		Wh1sper -	For the concept of Smart Assist Casting, and for going through the trouble to
							workout the textures for allmsot all the hostile, and self cast spells.
	Contact: mugekun@gmail.com

	$Id: CastOptions.lua 2174 2005-07-27 02:21:50Z mugendai $
	$Rev: 2174 $
	$LastChangedBy: mugendai $
	$Date: 2005-07-26 21:21:50 -0500 (Tue, 26 Jul 2005) $
]]--

--------------------------------------------------
--
-- Spell Information
--
--------------------------------------------------
CastOptions.SpellData = {
	----------------------------------------------------------------------
	-- Spells that should be cast on player if there is no friendly target
	----------------------------------------------------------------------
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
	--l - this spell is a blessing
	--t - the texture of the buff, if it is different from the spell
	Self = {
		DRUID = {
			["Interface\\Icons\\Spell_Nature_NullifyPoison_02"] = {p=1;b=1;};			--Abolish Poison
			["Interface\\Icons\\Spell_Nature_NullifyPoison"] = {p=1;};						--Cure Poison
			["Interface\\Icons\\Spell_Nature_HealingTouch"] = {h=1;};							--Healing Touch
			["Interface\\Icons\\Spell_Nature_Lightning"] = {b=1;n=1;};						--Innervate
			["Interface\\Icons\\Spell_Nature_Regeneration"] = {b=1;};							--Mark of the Wild
			["Interface\\Icons\\Spell_Nature_ResistNature"] = {h=1;b=1;};					--Regrowth
			["Interface\\Icons\\Spell_Nature_Rejuvenation"] = {h=1;b=1;};					--Rejuvenation
			["Interface\\Icons\\Spell_Holy_RemoveCurse"] = {c=1;r=1};							--Remove Curse
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
			["Interface\\Icons\\Spell_Magic_MageArmor"] = {b=1;l=1;};							--Blessing of Kings
			["Interface\\Icons\\Spell_Holy_PrayerOfHealing02"] = {b=1;l=1;};			--Blessing of Light
			["Interface\\Icons\\Spell_Holy_FistOfJustice"] = {b=1;l=1;};					--Blessing of Might
			["Interface\\Icons\\Spell_Holy_SealOfProtection"] = {b=1;g=1;l=1;};		--Blessing of Protection
			["Interface\\Icons\\Spell_Holy_SealOfSacrifice"] = {b=1;r=1;l=1;};		--Blessing of Sacrifice
			["Interface\\Icons\\Spell_Holy_SealOfSalvation"] = {b=1;g=1;l=1;};		--Blessing of Salvation
			["Interface\\Icons\\Spell_Nature_LightningShield"] = {b=1;l=1;};			--Blessing of Sanctuary
			["Interface\\Icons\\Spell_Holy_SealOfWisdom"] = {b=1;n=1;l=1;};				--Blessing of Wisdom
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
			["Interface\\Icons\\Spell_Holy_PowerWordShield"] = {b=1;g=1;};				--Power Word: Shield
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
			--Misc
			["Interface\\Icons\\INV_Misc_Herb_04"] = {h=1;};											--Sprouted Frond
		};
	};
	
	----------------------------------------------------------
	-- Spells that should be cast on friendlies hostile target
	----------------------------------------------------------
	Hostile = {
		DRUID = {
			["Interface\\Icons\\Ability_Druid_Bash"] = true;													--Bash
			["Interface\\Icons\\Ability_Druid_ChallangingRoar"] = true;								--Claw
			["Interface\\Icons\\Spell_Nature_StrangleVines"] = true;									--Entangling Roots
			["Interface\\Icons\\Spell_Nature_FaerieFire"] = true;											--Faerie Fire
			["Interface\\Icons\\Ability_Hunter_Pet_Bear"] = true;											--Feral Charge
			["Interface\\Icons\\Ability_Druid_FerociousBite"] = true;									--Ferocious Bite
			["Interface\\Icons\\Spell_Nature_Sleep"] = true;													--Hibernate
			["Interface\\Icons\\Spell_Shadow_Contagion"] = true;											--Insect Swarm
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
	
	-------------------------------------------------------------------------------------------------
	-- List of spells that have level requirements for the target, and the level requirement per rank
	-------------------------------------------------------------------------------------------------
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

	-------------------------------------------------------------------------------------------------
	-- List of healing spells and the maximum heal value for them
	-------------------------------------------------------------------------------------------------
	--ranks - the max heal per rank
	--talents - if this spell is modified by any talents, this holds the data for those talents
	--  texture - the texture for the talent that modifies the heal value
	--  boost - the percentage to multiply the heal value by, per rank
	HealRanks = {
		DRUID = {
			["Interface\\Icons\\Spell_Nature_HealingTouch"] = {																										--Healing Touch
				ranks = { 37, 88, 195, 363, 572, 742, 936, 1199, 1516, 1890 };
				talents = { { texture = "Interface\\Icons\\Spell_Nature_ProtectionformNature"; boost = 0.05; }; };	--Gift of Nature
			};
			["Interface\\Icons\\Spell_Nature_ResistNature"] = {																										--Regrowth
				ranks = { 84, 164, 240, 318, 405, 511, 646, 809, 1003 };
				talents = { { texture = "Interface\\Icons\\Spell_Nature_ProtectionformNature"; boost = 0.05; }; };
			};
		};
		HUNTER = {
			--["Interface\\Icons\\"] = ;
		};
		MAGE = {
			--["Interface\\Icons\\"] = ;
		};
		PALADIN = {
			["Interface\\Icons\\Spell_Holy_HolyBolt"] = {																													--Holy Light
				ranks = { 42, 76, 159, 310, 491, 698, 945, 1246 };
				talents = { { texture = "Interface\\Icons\\Spell_Holy_HolyBolt"; boost = 0.04; }; };								--Improved Holy Light
			};
			["Interface\\Icons\\Spell_Holy_FlashHeal"] = {																												--Flash of Light
				ranks = { 62, 96, 145, 197, 267, 343 };
				talents = { { texture = "Interface\\Icons\\Spell_Holy_FlashHeal"; boost = 0.04; }; };								--Improved Flash of Light
			};
		};
		PRIEST = {
			["Interface\\Icons\\Spell_Holy_LesserHeal"] = {																												--Lesser Heal
				ranks = { 43, 71, 135 };
				talents = { { texture = "Interface\\Icons\\Spell_Nature_MoonGlow"; boost = 0.02; }; };							--Spritual Healing
			};
			["Interface\\Icons\\Spell_Holy_Heal"] = {																															--Heal
				ranks = { 295, 499, 754, 948 };
				talents = { { texture = "Interface\\Icons\\Spell_Nature_MoonGlow"; boost = 0.02; }; };							--Spritual Healing
			};
			["Interface\\Icons\\Spell_Holy_GreaterHeal"] = {																											--Greater Heal
				ranks = { 1201, 1531, 1919, 2396 };
				talents = { { texture = "Interface\\Icons\\Spell_Nature_MoonGlow"; boost = 0.02; }; };							--Spritual Healing
			};
			
			["Interface\\Icons\\Spell_Holy_FlashHeal"] = {																												--Flash Heal
				ranks = { 193, 258, 327, 400, 518, 644, 812 };
				talents = { { texture = "Interface\\Icons\\Spell_Nature_MoonGlow"; boost = 0.02; }; };							--Spritual Healing
			};
		};
		ROGUE = {
			--["Interface\\Icons\\"] = ;
		};
		SHAMAN = {
			["Interface\\Icons\\Spell_Nature_MagicImmunity"] = {																									--Healing Wave
				ranks = { 39, 64, 129, 268, 376, 536, 740, 1017, 1367 };
				talents = { { texture = "Interface\\Icons\\Spell_Frost_WizardMark"; boost = 0.02; }; };							--Purification
			};
			["Interface\\Icons\\Spell_Nature_HealingWaveLesser"] = {																							--Lesser Healing Wave
				ranks = { 162, 247, 337, 458, 631, 832 };
				talents = { { texture = "Interface\\Icons\\Spell_Frost_WizardMark"; boost = 0.02; }; };							--Purification
			};
			--["Interface\\Icons\\Spell_Nature_HealingWaveGreater"] = {																							--Chain Heal
			--	ranks = { 320, 405, 551 };
			--	talents = { { texture = "Interface\\Icons\\Spell_Frost_WizardMark"; boost = 0.02; }; };							--Purification
			--};
		};
		WARLOCK = {
			--["Interface\\Icons\\"] = ;
		};
		WARRIOR = {
			--["Interface\\Icons\\"] = ;
		};
	};

	----------------------------------------------------------------------
	-- Spells that bind a target, and the target will be freed if attacked
	----------------------------------------------------------------------
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

	--------------------------------------------
	-- Items that should be applied to equipment
	--------------------------------------------
	--s - this applies to sharp weapons
	--b - this applies to blunt weapons
	--f - this applies to fishing weapons
	Equipment = {
		["3239:0:0"] = {b=1;};											--Rough Weightstone
		["3240:0:0"] = {b=1;};											--Coarse Weightstone
		["3241:0:0"] = {b=1;};											--Heavy Weightstone
		["7965:0:0"] = {b=1;};											--Solid Weightstone
		["2862:0:0"] = {s=1;};											--Rough Sharpening Stone
		["2863:0:0"] = {s=1;};											--Coarse Sharpening Stone
		["2871:0:0"] = {s=1;};											--Heavy Sharpening Stone
		["7964:0:0"] = {s=1;};											--Solid Sharpening Stone


		--Fishing Lures
		["6533:0:0"] = {f=1;};											--Aquadynamic Fish Attractor
		["6532:0:0"] = {f=1;};											--Bright Baubles
		["6811:0:0"] = {f=1;};											--Aquadynamic Fish Lens
		["6530:0:0"] = {f=1;};											--Nightcrawlers
		["6529:0:0"] = {f=1;};											--Shiny Bauble
	};
};
--Add in copies of the heal spells that have more than one texture
CastOptions.SpellData.HealRanks.PRIEST["Interface\\Icons\\Spell_Holy_LesserHeal02"] = CastOptions.SpellData.HealRanks.PRIEST["Interface\\Icons\\Spell_Holy_LesserHeal"];
CastOptions.SpellData.HealRanks.PRIEST["Interface\\Icons\\Spell_Holy_Heal02"] = CastOptions.SpellData.HealRanks.PRIEST["Interface\\Icons\\Spell_Holy_Heal"];