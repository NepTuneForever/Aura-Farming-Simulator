local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Networker = require(ReplicatedStorage.Packages.Networker)
local CombatUtils = require(ReplicatedStorage.Shared.Services.CombatService.CombatUtils)

type CombatService = {
	networker: any,
	LastAttackTime: { [Player]: number },
	GetDelays: (self: CombatService, playerReceived: Player) -> CombatUtils.delays,
	PerformAttack: (self: CombatService, playerReceived: Player, comboIndex: number) -> (),
	CreateHitbox: (self: CombatService, character: Model, comboIndex: number) -> (),
	GetEnemiesInRange: (self: CombatService, origin: Vector3, range: number, attackingPlayer: Player) -> { Model },
	ApplyDamage: (self: CombatService, targetHumanoid: Humanoid, damage: number, attackingPlayer: Player) -> (),
	ValidateAttack: (self: CombatService, player: Player) -> boolean,
	init: (self: CombatService) -> (),
}

local CombatService: CombatService = {} :: any

function CombatService.ValidateAttack(self: CombatService, player: Player): boolean
	local now = tick()
	local lastAttack = self.LastAttackTime[player] or 0

	if now - lastAttack < CombatUtils.GetDelays().Attack then
		warn("Player", player.Name, "atacando muito rápido - possível exploit")
		return false
	end

	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end

	local humanoid = player.Character:FindFirstChild("Humanoid") :: Humanoid?
	if not humanoid or humanoid.Health <= 0 then
		return false
	end

	return true
end

function CombatService.GetEnemiesInRange(
	self: CombatService,
	origin: Vector3,
	range: number,
	attackingPlayer: Player
): { Model }
	local enemies = {}
	local hitboxSize = CombatUtils.DamageConfig.HitboxSize

	local hitboxCFrame = CFrame.new(origin)
	local hitboxMin = origin - (hitboxSize / 2)
	local hitboxMax = origin + (hitboxSize / 2)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= attackingPlayer then
			local character = player.Character
			if character then
				local enemyHumanoid = character:FindFirstChild("Humanoid") :: Humanoid?

				if enemyHumanoid and enemyHumanoid.Health > 0 then
					local characterCFrame, characterSize = character:GetBoundingBox()
					local characterMin = characterCFrame.Position - (characterSize / 2)
					local characterMax = characterCFrame.Position + (characterSize / 2)

					local distance = (origin - characterCFrame.Position).Magnitude

					if distance <= range then
						local overlapsX = hitboxMin.X <= characterMax.X and hitboxMax.X >= characterMin.X
						local overlapsY = hitboxMin.Y <= characterMax.Y and hitboxMax.Y >= characterMin.Y
						local overlapsZ = hitboxMin.Z <= characterMax.Z and hitboxMax.Z >= characterMin.Z

						if overlapsX and overlapsY and overlapsZ then
							table.insert(enemies, character)
						end
					end
				end
			end
		end
	end

	return enemies
end

function CombatService.ApplyDamage(
	self: CombatService,
	targetHumanoid: Humanoid,
	damage: number,
	attackingPlayer: Player
)
	if targetHumanoid.Health <= 0 then
		return
	end

	local finalDamage = damage
	local isCrit = math.random() < CombatUtils.DamageConfig.CritChance

	if isCrit then
		finalDamage = damage * CombatUtils.DamageConfig.CritMultiplier
		print("CRITICAL HIT!", finalDamage)
	end

	targetHumanoid:TakeDamage(finalDamage)

	print(string.format("%s causou %.1f de dano%s", attackingPlayer.Name, finalDamage, isCrit and " (CRÍTICO!)" or ""))
end

function CombatService.CreateHitbox(self: CombatService, character: Model, comboIndex: number)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not humanoidRootPart then
		return
	end

	local player = Players:GetPlayerFromCharacter(character)
	if not player then
		return
	end

	local lookVector = humanoidRootPart.CFrame.LookVector
	local hitboxPosition = humanoidRootPart.Position + (lookVector * 5)

	local baseDamage = CombatUtils.DamageConfig.BaseDamage[comboIndex] or 10

	local enemies = self:GetEnemiesInRange(hitboxPosition, CombatUtils.DamageConfig.Range, player)

	for _, enemyCharacter in ipairs(enemies) do
		local enemyHumanoid = enemyCharacter:FindFirstChild("Humanoid") :: Humanoid?
		if enemyHumanoid then
			self:ApplyDamage(enemyHumanoid, baseDamage, player)
		end
	end

	if game:GetService("RunService"):IsStudio() then
		local hitboxPart = Instance.new("Part")
		hitboxPart.Size = CombatUtils.DamageConfig.HitboxSize
		hitboxPart.CFrame = CFrame.new(hitboxPosition)
		hitboxPart.Transparency = 0.7
		hitboxPart.Color = Color3.new(1, 0, 0)
		hitboxPart.Anchored = true
		hitboxPart.CanCollide = false
		hitboxPart.Parent = workspace

		game:GetService("Debris"):AddItem(hitboxPart, 0.3)
	end
end

function CombatService.PerformAttack(self: CombatService, playerReceived: Player, comboIndex: number)
	if not self:ValidateAttack(playerReceived) then
		return
	end

	self.LastAttackTime[playerReceived] = tick()

	local character = playerReceived.Character
	if character then
		self:CreateHitbox(character, comboIndex)
	end

	-- TODO: Sistema de Aura - Adicionar aura ao completar combo, ao dar crítico, e ao matar inimigo
	if comboIndex == CombatUtils.ComboConfig.MaxCombo then
		print(playerReceived.Name, "completou o combo!")

		local leaderstats = playerReceived:FindFirstChild("leaderstats")
		if leaderstats then
			local auraPoints = leaderstats:FindFirstChild("Aura")
			if auraPoints and auraPoints:IsA("IntValue") then
				auraPoints.Value += CombatUtils.ComboConfig.AuraPointsPerCombo
			end
		end
	end
end

function CombatService.GetDelays(self: CombatService)
	return CombatUtils.GetDelays()
end

function CombatService.init(self: CombatService)
	self.networker = Networker.server.new("CombatService", self, {
		self.GetDelays,
		self.PerformAttack,
	})

	self.LastAttackTime = {}

	Players.PlayerRemoving:Connect(function(player)
		self.LastAttackTime[player] = nil
	end)

	print("CombatService iniciado com sistema de hitbox")
end

return CombatService
