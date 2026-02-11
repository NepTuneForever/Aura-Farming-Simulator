local AuraHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ControlAura = ReplicatedStorage:WaitForChild("Remotes").ControlAura

local DataHandler = require(ReplicatedStorage:WaitForChild("ServerSource").DataHandler)

local Info = TweenInfo.new(0.65, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

local ActiveAnimations = {}

local Shapes = {
	["Ball"] = {
		Name = "Ball",
		NewSize = Vector3.new(11.211, 10.485, 11.178),
		FinalTransparency = 1,
		Rotation = Vector3.new(0, 180, 0),
	},
}

local function GetEntryByLevel(PlayerLevel)
	if PlayerLevel >= 1 and PlayerLevel <= 10 then
		return "Ball"
	else
		return "Ball"
	end
end

function AuraHandler:LoadEntryVFX(PlayerLevel, player)
	local PlayerEntry = Shapes[GetEntryByLevel(PlayerLevel)]
	local PlayerEntryVFX = ReplicatedStorage.Assets.VFX["Transform"][PlayerEntry.Name]:Clone()

	PlayerEntryVFX.Parent = game.Workspace
	PlayerEntryVFX.CFrame = player.Character.HumanoidRootPart.CFrame

	local Tween = TweenService:Create(PlayerEntryVFX, Info, {
		Size = PlayerEntry.NewSize,
		Transparency = PlayerEntry.FinalTransparency,
		Rotation = PlayerEntry.Rotation,
	})

	Tween:Play()

	Tween.Completed:Connect(function()
		PlayerEntryVFX:Destroy()
	end)
end

function AuraHandler:Init()
	ControlAura.OnServerEvent:Connect(function(player, mode)
		print(player, mode)
		local playerdata = DataHandler.Get(player)

		local able = false

		local PlayerAura =
			ReplicatedStorage.Assets.VFX[playerdata.CurrentAura.AuraType][playerdata.CurrentAura.AuraName]:Clone()

		if mode == "On" then
			if playerdata.CurrentAura.AuraType == "PlayerAura" then
				local character = player.Character or player.CharacterAdded:Wait()
				local humanoid = character:WaitForChild("Humanoid")
				local animator = humanoid:FindFirstChildOfClass("Animator")

				if not animator then
					animator = Instance.new("Animator")
					animator.Parent = humanoid
				end

				for _, part in pairs(PlayerAura:GetChildren()) do
					if character:FindFirstChild(part.Name) then
						for _, attachments in pairs(part:GetChildren()) do
							attachments.Parent = character[part.Name]
							task.wait()
							able = true
						end
					else
						warn("Parte do corpo não encontrada:")
						able = false
					end
				end

				task.spawn(function()
					if able == true then
						AuraHandler:LoadEntryVFX(playerdata.Level, player)

						local auraAnimation = script.AuraFarm
						local animationTrack = animator:LoadAnimation(auraAnimation)
						animationTrack.Looped = true
						animationTrack:Play()

						ActiveAnimations[player] = animationTrack
					end
				end)
			end
		end

		if mode == "Off" then
			local character = player.Character
			if not character then
				return
			end

			if ActiveAnimations[player] then
				ActiveAnimations[player]:Stop()
				ActiveAnimations[player] = nil
			end

			for _, descendant in pairs(character:GetDescendants()) do
				if descendant:IsA("ParticleEmitter") then
					task.spawn(function()
						descendant.Enabled = false
						task.delay(0.2, function()
							descendant:Destroy()
						end)
					end)
					task.wait()
				end
			end
		end
	end)
end

return AuraHandler
