local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local dataservice = require(ReplicatedStorage.Packages.dataservice).server
local LeaderstatsService = {}

function LeaderstatsService.OnPlayerAdded(self: LeaderstatsService, playerJoined: Player)
	local data = dataservice:waitForData(playerJoined)

	local function fetchUpdate(newValue)
		self.networker:fire(playerJoined, 'fetchUpdate', newValue)
		
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = playerJoined

	local aura = Instance.new("IntValue")
	aura.Name = "Aura"
	aura.Parent = leaderstats
	aura.Value = data:get({ "currency", "aura" })

	fetchUpdate(aura.Value)
	data:getChangedSignal({ "currency", "aura" }):Connect(function(newValue)
		aura.Value = newValue
		fetchUpdate(newValue)
	end)
end

function LeaderstatsService.init(self: LeaderstatsService)
	self.networker = Networker.server.new("Leaderstats", self)

	for _, player in Players:GetPlayers() do
		self:OnPlayerAdded(player)
	end

	Players.PlayerAdded:Connect(function(player: Player)
		self:OnPlayerAdded(player)
	end)
end

type LeaderstatsService = typeof(LeaderstatsService)
return LeaderstatsService
