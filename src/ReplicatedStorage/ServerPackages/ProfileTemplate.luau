local ProfileTemplate = {
	Version = 1,

	Level = 1,
	Exp = 0,
	MaxExp = 100,

	Rebirths = 0,

	CurrentAura = {
		AuraName = "Normal",
		AuraType = "PlayerAura",
	},

	Currency = {
		Coins = 0,
		Aura = 0,
	},

	Stats = {
		AuraMultiplier = 1,
		ExpMultiplier = 1,
	},

	Boosts = {
		Awakening = {
			Active = false,
			ExpiresAt = 0,
		},
	},

	Inventory = {
		Auras = {},
		Pets = {},
	},

	Monetization = {
		RobuxSpent = 0,
		Gamepasses = {},
	},
}

return ProfileTemplate
