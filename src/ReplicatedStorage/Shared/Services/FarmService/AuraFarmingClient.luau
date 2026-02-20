local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local AuraFarmingService = {}
local Client = game:GetService("Players").LocalPlayer

local AuraKey = Enum.KeyCode.Z

function AuraFarmingService:AsyncFarm()
	UserInputService.InputBegan:Connect(function(key: InputObject, gp: boolean)
		if gp then
			return
		end
		if key.KeyCode == AuraKey then
			self.networker:fire("AsyncFarm", "On")
		end
	end)

	UserInputService.InputEnded:Connect(function(key: InputObject, gp: boolean)
		if gp then
			return
		end
		if key.KeyCode == AuraKey then
			self.networker:fire("AsyncFarm", "Off")
		end
	end)
end

function AuraFarmingService:init()
	self.networker = Networker.client.new("AuraFarmingService", self)
	self:AsyncFarm()
end

type AuraFarmingService = typeof(AuraFarmingService)
return AuraFarmingService
