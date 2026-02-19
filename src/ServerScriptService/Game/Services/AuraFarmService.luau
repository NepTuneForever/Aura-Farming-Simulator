local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local VFXHandler = require(ServerScriptService.Game.Services.VFXHandler)
local AuraFarmingService = {}

function AuraFarmingService.AsyncFarm(self: AuraFarmingService, Player: Player, AuraName: string)
	print(self, Player.DisplayName, AuraName)
end

function AuraFarmingService.init(self: AuraFarmingService)
	self.networker = Networker.server.new("AuraFarmingService", self, {
		self.AsyncFarm,
	})
end

type AuraFarmingService = typeof(AuraFarmingService)
return AuraFarmingService
