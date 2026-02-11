local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dataservice = require(ReplicatedStorage.Packages.dataservice)
local LeaderstatsClient = require(ReplicatedStorage.Shared.Services.LeaderstatsService.LeaderstatsClient)
dataservice.client:init()

LeaderstatsClient:init()