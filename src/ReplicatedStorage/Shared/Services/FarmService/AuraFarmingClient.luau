local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local AuraFarmingService = {}
local Client = game:GetService("Players").LocalPlayer

function AuraFarmingService.init(self: AuraFarmingService)
	self.networker = Networker.client.new("AuraFarmingService", self)
	self.networker:fire("AsyncFarm", "Test")
end

type AuraFarmingService = typeof(AuraFarmingService)
return AuraFarmingService
