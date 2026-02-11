local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataTemplate = require(ServerScriptService.Game.Config.Data.DataTemplate)
local LeaderstatsService = require(ServerScriptService.Game.Services.LeaderstatsService)
local dataservice = require(ReplicatedStorage.Packages.dataservice)

dataservice.server:init({
    template = DataTemplate,
    profileStoreIndex = 'Teste1',
    useMock = true
})

LeaderstatsService:init()