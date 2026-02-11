local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerPackages = ReplicatedStorage:WaitForChild("ServerPackages")
local ServerSource = ReplicatedStorage:WaitForChild("ServerSource")

local ProfileService = require(ServerPackages:WaitForChild("ProfileService"))
local ProfileTemplate = require(ServerPackages:WaitForChild("ProfileTemplate"))

local Leaderstats = require(ServerSource:WaitForChild("Leaderstats"))
local AuraHandler = require(ServerSource:WaitForChild("AuraHandler"))
local DataHandler = require(ServerSource:WaitForChild("DataHandler"))

local ProfileStore = ProfileService.GetProfileStore("PlayerData_v1", ProfileTemplate)

local function onPlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")

	if not profile then
		player:Kick("Erro ao carregar dados. Tente novamente.")
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	if not player:IsDescendantOf(Players) then
		profile:Release()
		return
	end

	DataHandler.Init(player, profile)

	Leaderstats.Create(player)
	AuraHandler:Init()

	local playerData = DataHandler.Get(player)
	if playerData then
		print(string.format("Dados carregados de %s:", player.Name))
		print(playerData)
	else
		warn("Falha ao obter dados de", player.Name)
	end
end

local function onPlayerRemoving(player)
	DataHandler.Remove(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, player)
end
