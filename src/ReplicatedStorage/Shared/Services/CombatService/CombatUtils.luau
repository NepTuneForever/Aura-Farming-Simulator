local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

export type hotbar = Frame & {
	Attack: ImageButton,
	AutoFree: ImageButton,
	FastAutoAttack: ImageButton,
	AuraEnable: ImageLabel,
}

local CombatUtils = {}

CombatUtils.Keys = {
	Attack = Enum.UserInputType.MouseButton1,
	AutoFree = Enum.KeyCode.E,
	FastAutoAttack = Enum.KeyCode.Q,
	AuraEnable = Enum.KeyCode.Z,
}

local delays = {
	Attack = 0.1,
	AutoFree = 0.5,
	FastAutoAttack = 0.3,
	AuraEnable = 3,
}

export type delays = typeof(delays)

-- Combo configuration
CombatUtils.ComboConfig = {
	MaxCombo = 5,
	ComboResetTime = 2,
	AnimationIds = {
		"rbxassetid://127411719903524",
		"rbxassetid://125089054037735",
		"rbxassetid://81617246627511",
		"rbxassetid://139105831334886",
		"rbxassetid://73615540733950",
	},
	AuraPointsPerCombo = 10, -- Pontos de aura ao completar combo
}

CombatUtils.DamageConfig = {
	BaseDamage = {
		[1] = 1, -- Primeiro ataque
		[2] = 1.3, -- Segundo ataque
		[3] = 1.7, -- Terceiro ataque
		[4] = 2, -- Quarto ataque
		[5] = 2.2, -- Quinto ataque (finisher)
	},
	CritChance = 0.15, -- 15% de chance de crítico
	CritMultiplier = 1.5,
	Range = 8, -- Alcance em studs
	HitboxSize = Vector3.new(6, 6, 6), -- Tamanho da hitbox
}

CombatUtils.GetDelays = function()
	return delays :: delays
end

return CombatUtils
