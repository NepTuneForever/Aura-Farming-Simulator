local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Networker = require(ReplicatedStorage.Packages.Networker)
local VFXHandler = require(ServerScriptService.Game.Services.VFXHandler)
local AnimationController = require(ServerScriptService.Game.Services.AnimationController)
local AuraFarmingService = {}

function AuraFarmingService.AsyncFarm(self: AuraFarmingService, Player: Player, Mode: string)
	if Mode == "On" then
		VFXHandler.Toggle(Player, true)
		AnimationController.Toggle(Player.Character, 89707667643313, true)
		return
	end
	if Mode == "Off" then
		VFXHandler.Toggle(Player, false)
		AnimationController.Toggle(Player.Character, 89707667643313, false)
		return
	end
	VFXHandler.Toggle(false)
	AnimationController.Toggle(Player.Character, 89707667643313, false)
end

function AuraFarmingService.init(self: AuraFarmingService)
	self.networker = Networker.server.new("AuraFarmingService", self, {
		self.AsyncFarm,
	})
end

type AuraFarmingService = typeof(AuraFarmingService)
return AuraFarmingService
