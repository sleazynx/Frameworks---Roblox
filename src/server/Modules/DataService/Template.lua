local module = {
	HasPlayed = false,

	Coins = 25,

	PlayerClass = "None",

	Classes = {
		Assassin = {
			Name = "Assassin",
			Perks = {
				Speed = 25, -- +25% speed
				SwordDamage = 20, -- +20% sword damage
				SwordSwing = 15, -- -15% sword swing speed
			},
			Drawbacks = {
				MaxDefense = 20 -- -20% max defense
			},
		},
		Mage = {
			Name = "Mage",
			Perks = {
				MagicDamage = 35, -- +35% magic damage
				SpellCooldown = 25, -- -25% spell cooldown
				Luck = 10, -- +10% luck
			},
			Drawbacks = {
				Strength = 15, -- -15% Strength Damage, and Strength XP Gain
				SlowerMining = 50, -- -50% Mining Speed
				SlowerChopping = 50, -- -50% Chopping Speed
			},
		},
		Tank = {
			Name = "Tank",
			Perks = {
				Defense = 40, -- +40% defense
				BaseStrength = 15, -- +15% base strength
				Knockback = 25, -- -25% knockback
			},
			Drawbacks = {
				Speed = 25, -- -25% speed
			},
		},
		Prodigy = {
			Name = "The Prodigy",
			Perks = {
				-- None Perks (+0% starting bonuses)
			},
			Drawbacks = {
				-- None Drawbacks (-0% starting penalties)
			},
			Note = "Because Prodigy has zero passive penalties, it is the only class that can reach 100% maximum efficiency across every single skill, mining activity, and magic tree in late-game progression."
		}
	},

	Damage = 1,
	CriticalChance = 10, -- 10%

	Level = {
	CurrentLevel = 1,
	CurrentXP = 0,
	MaxXP = 100
	},

	Skills = {
	Strength = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			DefeatingEnemy = 10,
			Mining = 5,
			Chopping = 5,
		},
		Unlocked = true,
		Description = "Increases general damage output across all activities."
	},

	Speed = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			Sprinting = 1, -- e.g., XP per second/meter
			ExploringNewArea = 25, -- Bonus XP
		},
		Unlocked = true,
		Description = "Increases overall player movement speed."
	},

	Defense = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			TakingDamage = 2,
			DefeatingEnemy = 10,
		},
		Unlocked = true,
		Description = "Increases maximum player health."
	},

	Luck = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			OpeningEggs = 15,
			RollingTalents = 10,
			RareDrops = 20,
		},
		Unlocked = true,
		Description = "Improves odds when hatching eggs, rolling talents, and finding drops."
	},

	SwordMastery = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			HittingEnemy = 2,
			DefeatingEnemy = 10,
		},
		Unlocked = false, -- Must Start the first Sword Mastery Quest to set to true
		Description = "Enhances sword swing cooldowns and melee damage efficiency."
	},

	Magic = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			CastingSpells = 5,
			DefeatingEnemy = 10,
			Meditation = 2, -- XP per second
		},
		Unlocked = false, -- Must Start the Wizard Quest to set to true
		Description = "Allows casting of powerful spells."
	},

	Mining = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			MiningOre = 10,
		},
		Unlocked = false, -- Must Start the first Miner Quest to set to true
		Description = "Allows gathering of materials for crafting, selling, or temporary boosts."
	},

	TreeChopping = {
		Level = 1,
		CurrentXP = 0,
		MaxXP = 100,
		XPGain = {
			ChoppingTrees = 10,
		},
		Unlocked = false, -- Must Start the first Lumberjack Quest to set to true
		Description = "Allows harvesting wood for crafting and selling, with a chance to drop apples."
	}
	},

	Inventory = {
		Items = {
			Ores = {
				Stone = 0,
				Coal = 222,
				Copper = 0,
				Silver = 0,
				Iron = 0,
				Gold = 0,
				Diamond = 0,
				Obsidean = 0,
				Emerald = 3,
				Ruby = 0,
				Sapphire = 0,
				Sulfur = 0,
			},
			
			Wood = {
				Oak = 0,
				Birch = 0,
				Pine = 0,
				ElderWood = 0,
			},

			Foraging = {
				Apples = 0,
				GoldenApple = 0,
				TreeSap = 0,
			},

			EnemiesDrops = {
				Slime = 0,
				Bone = 0,
				SpiderLeg = 0,
				Flesh = 0,
				ZombieHeart = 0,
				Skull = 2, 
				SpiderEye = 0,
				WolfPelt = 0,
				SharpFang = 0,
				VenomSac = 0,
				ManaEssence = 0,
				SpellScrollFragment = 0,
				GolemCore = 1,
			},
		},

		Swords = {
			RustyCutlass = {
				Name = "RustyCutlass",
				Damage = 12,
				AttackSpeed = 1.2,
				Value = 15,
				Rarity = "Common",
				Description = "An old, worn blade weathered by salt water.",
				Image = "rbxassetid://1234567890",
				Equipped = false,
				Id = "1"
			},
			IronBroadsword = {
				Name = "Iron Broadsword",
				Damage = 28,
				AttackSpeed = 1.0,
				Value = 85,
				Rarity = "Uncommon",
				Description = "A sturdy standard-issue broadsword forged from refined iron.",
				Image = "rbxassetid://1234567890",
				Equipped = true,
				Id = "2"
			},
			SilverRapier = {
				Name = "Silver Rapier",
				Damage = 45,
				AttackSpeed = 1.5,
				Value = 220,
				Rarity = "Rare",
				Description = "A nimble, light blade designed for swift precision thrusts.",
				Image = "rbxassetid://1234567890",
				Id = "3"
			},
			ObsidianGreatsword = {
				Name = "Obsidian Great Sword",
				Damage = 95,
				AttackSpeed = 0.7,
				Value = 750,
				Rarity = "Epic",
				Description = "A heavy, razor-sharp blade forged from volcanic glass. Hits exceptionally hard.",
				Image = "rbxassetid://1234567890",
				Equipped = false,
				Id = "4"
			},
			FlameforgedSaber = {
				Name = "Flame Forged Saber",
				Quantity = 0,
				Damage = 160,
				AttackSpeed = 1.1,
				Value = 2500,
				Rarity = "Legendary",
				Description = "Imbued with molten magic, leaving trails of fire with every swing.",
				Image = "rbxassetid://1234567890",
				Equipped = false,
				Id = "5"
			},
		},

		Spells = {
			-- The spells the player owns will be stored here, with their unique attributes and stats.
		},

		EquippedSword = {
			EquippedSword = nil,
			Damage = 1,
			AttackSpeed = 1,
			SwordName = ""
		},

		EquippedSpells = {
			Spell1 = nil,
			Spell2 = nil,
			Spell3 = nil,
		}
	}
}

return module

