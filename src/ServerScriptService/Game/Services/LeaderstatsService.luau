local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local LeaderstatsService = {}

function LeaderstatsService.OnPlayerAdded(self : LeaderstatsService, playerJoined : Player)
    
end

function LeaderstatsService.init(self : LeaderstatsService)
    self.networker = Networker.server.new('Leaderstats', self)

    for i, player in Players:GetPlayers() do
        self:OnPlayerAdded(player)
    end
    
    Players.PlayerAdded:Connect(function(player: Player)  
        self:OnPlayerAdded(player)
    end)
end

type LeaderstatsService = typeof(LeaderstatsService)
return LeaderstatsService