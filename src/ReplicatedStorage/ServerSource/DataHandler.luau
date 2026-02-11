local DataHandler = {}

-- Cache: [player] = profile
local Profiles = {}

function DataHandler.Init(player, profile)
	Profiles[player] = profile
end

function DataHandler.Get(player)
	local profile = Profiles[player]
	if not profile then
		warn("Profile não encontrado para", player.Name)
		return nil
	end

	-- Retorna os dados do profile, não o profile inteiro
	return profile.Data
end

function DataHandler.GetProfile(player)
	return Profiles[player]
end

function DataHandler.SaveData(player, key, value)
	local profile = Profiles[player]
	if not profile then
		warn("Profile não encontrado para salvar dados de", player.Name)
		return false
	end

	-- Salva diretamente no profile.Data
	profile.Data[key] = value
	return true
end

function DataHandler.UpdateData(player, callback)
	local profile = Profiles[player]
	if not profile then
		warn("Profile não encontrado para atualizar dados de", player.Name)
		return false
	end

	callback(profile.Data)
	return true
end

function DataHandler.Remove(player)
	local profile = Profiles[player]
	if profile then
		profile:Release() -- Libera o profile do ProfileService
	end
	Profiles[player] = nil
end

return DataHandler
