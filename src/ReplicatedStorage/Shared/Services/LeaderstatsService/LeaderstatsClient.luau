local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)
local LeaderstatsClient = {}

function LeaderstatsClient.fetchUpdate(self: LeaderstatsClient, newValue: number)
	print("Methods has changed to update with new value: " .. tostring(newValue))
end

function LeaderstatsClient.init(self: LeaderstatsClient)
	self.networker = Networker.client.new("Leaderstats", self, {
		self.fetchUpdate,
	})
end

type LeaderstatsClient = typeof(LeaderstatsClient)

return LeaderstatsClient
