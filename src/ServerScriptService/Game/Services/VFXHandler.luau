local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local VFXHandler = {}
local DataService = game:GetService("ReplicatedStorage").Packages.dataservice

local AurasModel = ServerStorage.Auras

function ChargeAura(character, model)
	for _, parts in pairs(model:GetDescendants()) do
		if parts:IsA("Attachment") and parts.Parent then
			if character:FindFirstChild(parts.Parent.Name) then
				local clone = parts:Clone()
				clone.Parent = character[parts.Parent.Name]
				task.wait()
			end
		end
	end
end

function UnchargeAura(character)
	for _, parts in pairs(character:GetDescendants()) do
		if parts:IsA("ParticleEmitter") and parts.Parent then
			parts.Parent:Destroy()
			task.wait()
		end
	end
end

function VFXHandler.Toggle(player, mode)
	local Character = player.Character
	local data = dataservice:waitForData(player)

	if mode then
		ChargeAura(Character, AurasModel[data:get({ "CurrentAura" })])
	else
		UnchargeAura(Character)
	end
end

export type VFXHandler = typeof(VFXHandler)
return VFXHandler
